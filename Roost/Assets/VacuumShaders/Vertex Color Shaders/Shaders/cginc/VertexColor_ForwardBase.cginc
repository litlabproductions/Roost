#ifndef VACUUM_SHADERS_VC_FORWARDBASE_CGINC
#define VACUUM_SHADERS_VC_FORWARDBASE_CGINC

#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "AutoLight.cginc"


#if defined(_NORMALMAP) && !defined(V_VC_COLOR_AND_TEXTURE_ON)
	#undef _NORMALMAP
#endif
 
#ifdef _NORMALMAP
	#define V_VC_LIGHTDIR i.lightDir
#else
	#define V_VC_LIGHTDIR _WorldSpaceLightPos0.xyz
#endif

#if defined(V_VC_REFLECTION_CUBE_SIMPLE) || defined(V_VC_REFLECTION_CUBE_ADVANED) || defined(V_VC_REFLECTION_UNITY_REFLECTION_PROBES)
	#define V_VC_REFLECTION_ON
#endif


//Variables//////////////////////////////////
fixed4 _Color;

#if defined(V_VC_COLOR_AND_TEXTURE_ON) || defined(_NORMALMAP)
	sampler2D _MainTex;
	half4 _MainTex_ST;
	half2 _V_VC_MainTex_Scroll;

	#ifdef _NORMALMAP
		sampler2D _V_VC_NormalMap;
	#endif
#endif


#ifdef V_VC_SPECULAR
	sampler2D _V_VC_Specular_Lookup;
#endif

#ifdef V_VC_REFLECTION_ON

	fixed4 _ReflectColor;
	half _V_VC_Reflection_Strength;
	half _V_VC_Reflection_Fresnel_Bias;

	#if defined(V_VC_REFLECTION_CUBE_SIMPLE) || defined(V_VC_REFLECTION_CUBE_ADVANED)
		UNITY_DECLARE_TEXCUBE(_Cube);
	#endif

	#if defined(V_VC_REFLECTION_CUBE_ADVANED) || defined(V_VC_REFLECTION_UNITY_REFLECTION_PROBES)
		half _V_VC_Reflection_Roughness;
	#endif
#endif

#ifdef V_VC_RENDERING_MODE_CUTOUT
	half _Cutoff; 
#endif

#ifdef V_VC_RIM_ON
	fixed4 _V_VC_RimColor;
	half _V_VC_RimBias;
#endif

//Struct/////////////////////////////////////////////////////////
struct vInput
{
    float4 vertex : POSITION;

	half4 texcoord : TEXCOORD0;
	half4 texcoord1 : TEXCOORD1;

	half3 normal : NORMAL;
	half4 tangent : TANGENT;

	fixed4 color : COLOR;
};

struct vOutput
{
	float4 pos :SV_POSITION;

	half4 uv : TEXCOORD0;	//xy - mainTex			
	half4 normal : TEXCOORD1;	//xyz - normal, w - rim
	

	#ifdef V_VC_REFLECTION_ON
		half4 refl : TEXCOORD2; //xyz - reflection, w - fresnel	
	#endif

	fixed4 vColor : TEXCOORD3;

	
	UNITY_FOG_COORDS(4)	
	

	#ifndef LIGHTMAP_OFF
		half2 lm : TEXCOORD5;
	#else
		half4 vLight : TEXCOORD5;

		#ifdef V_VC_SPECULAR
			half4 viewDir : TEXCOORD6;	//xyz - viewdir, w - specular(nh)
		#endif

		#ifdef _NORMALMAP
			half3 lightDir : TEXCOORD7;
		#endif	

		SHADOW_COORDS(8)
		
	#endif
};

//Vertex Shader///////////////////////////////////////////
vOutput vert(vInput v)
{ 
	vOutput o = (vOutput)0;	
	

	o.pos = UnityObjectToClipPos(v.vertex);

	#if defined(V_VC_COLOR_AND_TEXTURE_ON) || defined(_NORMALMAP)
		o.uv.xy = TRANSFORM_TEX(v.texcoord.xy, _MainTex);		
		o.uv.xy += _V_VC_MainTex_Scroll.xy * _Time.x;
	#endif

	
	float3 normal_WS = UnityObjectToWorldNormal(v.normal);

	#if defined(V_VC_REFLECTION_ON) || defined(V_VC_RIM_ON)
		
		#ifdef V_VC_INVERT_NORMAL
			v.normal *= -1;
		#endif

		half fresnel = dot (normalize(ObjSpaceViewDir(v.vertex).xyz), v.normal);
	#endif


	#ifdef V_VC_RIM_ON
		o.normal.w = saturate(fresnel + _V_VC_RimBias);

		o.normal.w *= o.normal.w * o.normal.w;
		o.normal.w *= o.normal.w * o.normal.w;
	#endif


	#ifdef V_VC_REFLECTION_ON
		half3 worldPos = mul(unity_ObjectToWorld, half4(v.vertex.xyz, 1)).xyz;
		half3 worldViewDir = UnityWorldSpaceViewDir(worldPos);
		o.refl.xyz = reflect( -worldViewDir, normal_WS );		
		
		o.refl.w = 1 - saturate(fresnel + _V_VC_Reflection_Fresnel_Bias);
		o.refl.w *= o.refl.w;
		o.refl.w *= o.refl.w;
	#endif


	o.vColor = v.color;

	//Fog
	UNITY_TRANSFER_FOG(o, o.pos);


	#ifndef LIGHTMAP_OFF
		o.lm = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
	#else
		
		#ifdef UNITY_SHOULD_SAMPLE_SH
			#ifdef V_VC_ENVIRONMENT_LIGHTING_ON
				o.vLight.rgb = ShadeSH9 (half4(normal_WS, 1.0));
				
				#ifdef VERTEXLIGHT_ON	
					float3 pos_WS = mul(unity_ObjectToWorld, v.vertex).xyz;
			
					o.vLight.rgb += Shade4PointLights ( unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
					 								   unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
													   unity_4LightAtten0, pos_WS, normal_WS );
				#endif
			#endif
		#endif


		#ifdef _NORMALMAP
			TANGENT_SPACE_ROTATION;

			o.lightDir = normalize(mul (rotation, ObjSpaceLightDir(v.vertex)));

			#ifdef V_VC_SPECULAR
				o.viewDir.xyz = mul (rotation, normalize(ObjSpaceViewDir(v.vertex)));
			#endif
		#else
			#ifdef V_VC_SPECULAR
				o.viewDir.xyz = WorldSpaceViewDir(v.vertex);
			#endif
		#endif
	#endif

	o.normal.xyz = normal_WS;

	#ifdef LIGHTMAP_OFF
		TRANSFER_VERTEX_TO_FRAGMENT(o);
	#endif

	return o;				
}

//Pixel Shader///////////////////////////////////////////
fixed4 frag(vOutput i) : SV_Target 
{			
	fixed4 retColor = i.vColor;

	//Main Texture
	#ifdef V_VC_COLOR_AND_TEXTURE_ON
		half4 mainTex = tex2D(_MainTex, i.uv.xy);
				
		retColor *= mainTex * _Color;
	#endif
	 
	//Cutout
	#ifdef V_VC_RENDERING_MODE_CUTOUT
		clip(retColor.a - _Cutoff);
	#endif


	
	#ifdef _NORMALMAP
		fixed3 bumpNormal = UnpackNormal(tex2D(_V_VC_NormalMap, i.uv.xy));
	#endif
	
	
	#ifndef LIGHTMAP_OFF
		fixed3 diff = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.lm));
		retColor.rgb *= diff;
	#else
		fixed atten = LIGHT_ATTENUATION(i);

		#ifdef _NORMALMAP
			half3 normal = bumpNormal;				
		#else
			half3 normal = normalize(i.normal.xyz);
		#endif
		
		fixed3 diff = _LightColor0.rgb * atten * max(0, dot(normal, V_VC_LIGHTDIR));
	
				
		#ifndef V_VC_ENVIRONMENT_LIGHTING_ON
			diff += UNITY_LIGHTMODEL_AMBIENT.xyz;
		#else
			diff += i.vLight.rgb;
		#endif
						

		retColor.rgb *= diff;


		#ifdef V_VC_SPECULAR
			half nh = max (0, dot (normal, normalize (V_VC_LIGHTDIR + normalize(i.viewDir.xyz))));
			fixed3 specular = tex2D(_V_VC_Specular_Lookup, half2(nh, 0.5)).rgb * retColor.a * _LightColor0.rgb * atten;

			retColor.rgb += specular;
		#endif
	#endif		
				
								
	 
	//Reflection
	#ifdef V_VC_REFLECTION_ON

		#ifdef _NORMALMAP
			i.refl.xyz += bumpNormal;
		#endif

		#if defined(V_VC_REFLECTION_CUBE_SIMPLE)
			fixed4 reflTex = UNITY_SAMPLE_TEXCUBE( _Cube, i.refl.xyz ) * _ReflectColor;
		#elif defined(V_VC_REFLECTION_CUBE_ADVANED)
			fixed4 reflTex = UNITY_SAMPLE_TEXCUBE_LOD( _Cube, i.refl.xyz, _V_VC_Reflection_Roughness * 10) * _ReflectColor;
		#elif defined(V_VC_REFLECTION_UNITY_REFLECTION_PROBES)
			fixed4 reflTex = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, i.refl.xyz, _V_VC_Reflection_Roughness * 10) * _ReflectColor;
			reflTex.xyz = DecodeHDR(reflTex, unity_SpecCube0_HDR);
		#else
			fixed4 reflTex = _ReflectColor;
		#endif
		

		#ifdef V_VC_COLOR_AND_TEXTURE_ON
			retColor.rgb = lerp(retColor.rgb, retColor.rgb + reflTex.rgb, saturate(mainTex.a + _V_VC_Reflection_Strength * 2 - 1) *  i.refl.w);
		#else
			retColor.rgb = lerp(retColor.rgb, retColor.rgb + reflTex.rgb, _V_VC_Reflection_Strength *  i.refl.w);
		#endif
	#endif

	#ifdef V_VC_RIM_ON
		retColor.rgb = lerp(lerp(retColor.rgb, _V_VC_RimColor.rgb, _V_VC_RimColor.a), retColor.rgb, i.normal.w);
	#endif
	
	//Fog
	UNITY_APPLY_FOG(i.fogCoord, retColor);

	//Alpha
	#if !defined(V_VC_RENDERING_MODE_CUTOUT) && !defined(V_VC_RENDERING_MODE_TRANSPARENT)
		UNITY_OPAQUE_ALPHA(retColor.a);
	#endif

	return retColor;
} 


#endif
