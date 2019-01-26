#ifndef VACUUM_SHADERS_VC_PBR_CGINC
#define VACUUM_SHADERS_VC_PBR_CGINC


#if defined(_NORMALMAP) && !defined(V_VC_COLOR_AND_TEXTURE_ON)
	#undef _NORMALMAP
#endif   

//Variables//////////////////////////////////
fixed4 _Color;

#if defined(V_VC_COLOR_AND_TEXTURE_ON) || defined(_NORMALMAP)
	sampler2D _MainTex;
	half4 _MainTex_ST;
	half2 _V_VC_MainTex_Scroll;
#endif

half _Glossiness;
half _Metallic;

#ifdef _NORMALMAP
	sampler2D _V_VC_NormalMap;
#endif

#ifdef V_VC_RENDERING_MODE_CUTOUT 
	half _Cutoff;
#endif

#ifdef V_VC_RIM_ON
	fixed4 _V_VC_RimColor;
	half _V_VC_RimBias;
	half _V_VC_RimPow;
#endif


//Struct/////////////////////////////////////////////////////////
struct Input 
{
	float4 texcoord; 
	
	half4 color : COLOR;

	#ifdef V_VC_RIM_ON
		float3 viewDir;
	#endif
};


//Vertex Shader///////////////////////////////////////////
void vert (inout appdata_full v, out Input o) 
{
	UNITY_INITIALIZE_OUTPUT(Input,o);	

	#if defined(V_VC_COLOR_AND_TEXTURE_ON) || defined(_NORMALMAP)
		o.texcoord.xy = TRANSFORM_TEX(v.texcoord.xy, _MainTex);		
		o.texcoord.xy += _V_VC_MainTex_Scroll.xy * _Time.x;
	#endif
}


//Pixel Shader///////////////////////////////////////////
void surf (Input IN, inout SurfaceOutputStandard o) 
{
	fixed4 retColor = IN.color;

	//Main Texture
	#ifdef V_VC_COLOR_AND_TEXTURE_ON
		half4 mainTex = tex2D(_MainTex, IN.texcoord.xy);
				
		retColor *= mainTex * _Color;
	#endif
	 
	//Cutout
	#ifdef V_VC_RENDERING_MODE_CUTOUT
		clip(retColor.a - _Cutoff);
	#endif
	
	#ifdef _NORMALMAP
		o.Normal = UnpackNormal(tex2D(_V_VC_NormalMap, IN.texcoord.xy));
	#endif

	
	// Metallic and smoothness come from slider variables
	o.Metallic = _Metallic;
	o.Smoothness = _Glossiness;
	 
	 
	
	#ifdef V_VC_RIM_ON
		 
		 #ifdef V_VC_INVERT_NORMAL
			IN.viewDir *= -1;
		 #endif

		 half rim = 1.0 - saturate(dot (normalize(IN.viewDir), o.Normal) + _V_VC_RimBias);
		 rim = pow (rim, _V_VC_RimPow);

         retColor.rgb = lerp(retColor.rgb, _V_VC_RimColor.rgb, rim);
	#endif 

	 
	o.Albedo = retColor.rgb;
	o.Alpha = retColor.a;  
}
#endif
