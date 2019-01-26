#ifndef VACUUM_SHADERS_VC_UNLIT_CGINC
#define VACUUM_SHADERS_VC_UNLIT_CGINC

#include  "UnityCG.cginc"   


#if defined(V_VC_REFLECTION_CUBE_SIMPLE) || defined(V_VC_REFLECTION_CUBE_ADVANED) || defined(V_VC_REFLECTION_UNITY_REFLECTION_PROBES)
	#define V_VC_REFLECTION_ON
#endif

//Variables//////////////////////////////////
fixed4 _Color;

#ifdef V_VC_COLOR_AND_TEXTURE_ON
	sampler2D _MainTex;
	float4 _MainTex_ST;
	float2 _V_VC_MainTex_Scroll;
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

#ifdef V_VC_IBL_ON
	samplerCUBE _V_VC_IBL_Cube;
	fixed _V_VC_IBL_Cube_Intensity;
	fixed _V_VC_IBL_Cube_Contrast;		
	fixed _V_VC_IBL_Light_Strength;
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

	#if defined(V_VC_REFLECTION_ON) || defined(V_VC_IBL_ON) || defined(V_VC_RIM_ON)
		half3 normal : NORMAL;
	#endif	

	fixed4 color : COLOR;
};

struct vOutput
{
	float4 pos :SV_POSITION;

	half4 uv : TEXCOORD0;	//xy - mainTex
			
	
	#if defined(V_VC_IBL_ON) || defined(V_VC_RIM_ON)
		half4 normal : TEXCOORD2;	//xyz - normal, w - rim
	#endif
	

	#ifdef V_VC_REFLECTION_ON
		half4 refl : TEXCOORD3; //xyz - reflection, w - fresnel	
	#endif

	fixed4 vColor : TEXCOORD4;
	  

	UNITY_FOG_COORDS(5)	
};


//Vertex Shader///////////////////////////////////////////
vOutput vert(vInput v)
{ 
	vOutput o = (vOutput)0;	
		

	o.pos = UnityObjectToClipPos(v.vertex);

	#ifdef V_VC_COLOR_AND_TEXTURE_ON
		o.uv.xy = TRANSFORM_TEX(v.texcoord.xy, _MainTex);		
		o.uv.xy += _V_VC_MainTex_Scroll.xy * _Time.x;
	#endif


	half3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

	#if defined(V_VC_IBL_ON) || defined(V_VC_REFLECTION_ON)
		half3 worldNormal = UnityObjectToWorldNormal(v.normal);
	#endif

	#if defined(V_VC_REFLECTION_ON) || defined(V_VC_RIM_ON)

		#ifdef V_VC_INVERT_NORMAL
			v.normal *= -1;
		#endif

		half fresnel = dot (normalize(ObjSpaceViewDir(v.vertex).xyz), v.normal);
	#endif

	
	#if defined(V_VC_IBL_ON)
		o.normal.xyz = worldNormal;
	#endif

	#ifdef V_VC_RIM_ON
		o.normal.w = saturate(fresnel + _V_VC_RimBias);

		o.normal.w *= o.normal.w * o.normal.w;
		o.normal.w *= o.normal.w * o.normal.w;
	#endif


	#ifdef V_VC_REFLECTION_ON
		half3 worldViewDir = UnityWorldSpaceViewDir(worldPos);
		o.refl.xyz = reflect( -worldViewDir, worldNormal );		
		
		o.refl.w = 1 - saturate(fresnel + _V_VC_Reflection_Fresnel_Bias);
		o.refl.w *= o.refl.w;
		o.refl.w *= o.refl.w;
	#endif


	o.vColor = v.color;

	//Fog
	UNITY_TRANSFER_FOG(o, o.pos);

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


	//IBL
	#ifdef V_VC_IBL_ON
		fixed3 ibl = ((texCUBE(_V_VC_IBL_Cube, i.normal.xyz).rgb - 0.5) * _V_VC_IBL_Cube_Contrast + 0.5) * _V_VC_IBL_Cube_Intensity;
					
		retColor.rgb *= (_V_VC_IBL_Light_Strength + ibl);

		retColor.rgb = saturate(retColor.rgb);
	#endif
			
	 
	//Reflection
	#ifdef V_VC_REFLECTION_ON
		#if defined(V_VC_REFLECTION_CUBE_SIMPLE)
			fixed4 reflTex = UNITY_SAMPLE_TEXCUBE( _Cube, i.refl.xyz ) * _ReflectColor;
		#elif defined(V_VC_REFLECTION_CUBE_ADVANED)
			fixed4 reflTex = UNITY_SAMPLE_TEXCUBE_LOD( _Cube, i.refl.xyz, _V_VC_Reflection_Roughness * 10) * _ReflectColor;
		#elif defined(V_VC_REFLECTION_UNITY_REFLECTION_PROBES)
			fixed4 reflTex = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, i.refl.xyz, _V_VC_Reflection_Roughness * 10) * _ReflectColor;
		#else
			fixed4 reflTex = _ReflectColor;
		#endif
		

		#ifdef V_VC_COLOR_AND_TEXTURE_ON
			retColor.rgb = lerp(retColor.rgb, reflTex.rgb, saturate(mainTex.a + _V_VC_Reflection_Strength * 2 - 1) *  i.refl.w);
		#else
			retColor.rgb = lerp(retColor.rgb, reflTex.rgb, _V_VC_Reflection_Strength *  i.refl.w);
		#endif
	#endif 

	#ifdef V_VC_RIM_ON
		retColor.rgb = lerp(lerp(retColor.rgb, _V_VC_RimColor.rgb, _V_VC_RimColor.a), retColor.rgb, i.normal.w);
	#endif
	
	
	//Fog
	#if defined(V_VC_RENDERING_MODE_ADDATIVE)
		UNITY_APPLY_FOG_COLOR(i.fogCoord, retColor, fixed4(0,0,0,0)); // fog towards black due to our blend mode
	#elif defined(V_VC_RENDERING_MODE_MULTIPLY)
		UNITY_APPLY_FOG_COLOR(i.fogCoord, retColor, fixed4(1,1,1,1)); // fog towards white due to our blend mode
	#else
		UNITY_APPLY_FOG(i.fogCoord, retColor);
	#endif

	//Alpha
	#if !defined(V_VC_RENDERING_MODE_CUTOUT) && !defined(V_VC_RENDERING_MODE_TRANSPARENT)
		UNITY_OPAQUE_ALPHA(retColor.a);
	#endif

	return retColor;
} 

#endif
