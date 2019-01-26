#ifndef VACUUM_SHADERS_VC_VERTEXLIT_CGINC
#define VACUUM_SHADERS_VC_VERTEXLIT_CGINC


//Variables//////////////////////////////////
fixed4 _Color;

#ifdef V_VC_COLOR_AND_TEXTURE_ON
	sampler2D _MainTex;
	half4 _MainTex_ST;
	half2 _V_VC_MainTex_Scroll;
#endif

#ifdef V_VC_RENDERING_MODE_CUTOUT
	half _Cutoff; 
#endif

#include "UnityCG.cginc"

////////////////////////////////////////////////////////////////////////////
//																		  //
//Struct    															  //
//																		  //
////////////////////////////////////////////////////////////z////////////////
struct v2f  
{  
	float4 pos : SV_POSITION;
	float4 uv : TEXCOORD0;	

	#ifdef V_VC_LIGHTMAP_ON
		half2 lm : TEXCOORD1;
	#else
		half4 vLight : TEXCOORD1;
	#endif		
	
	fixed4 vColor : TEXCOORD2;	

	//FOG
	UNITY_FOG_COORDS(5)	
};

 
////////////////////////////////////////////////////////////////////////////
//																		  //
//Vertex    															  //
//																		  //
////////////////////////////////////////////////////////////z////////////////
v2f vert (appdata_full v) 
{   
	v2f o;
	UNITY_INITIALIZE_OUTPUT(v2f,o); 

	
	o.pos = UnityObjectToClipPos(v.vertex); 

	#ifdef V_VC_COLOR_AND_TEXTURE_ON
		o.uv.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
		o.uv.xy += _V_VC_MainTex_Scroll.xy * _Time.x;
	#endif


	#ifdef V_VC_LIGHTMAP_ON
		o.lm = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
	#else
		float4 lighting = float4(ShadeVertexLightsFull(v.vertex, v.normal, 4, true), 1);
		o.vLight = lighting;
	#endif

	
	o.vColor = v.color;	

	//FOG
	UNITY_TRANSFER_FOG(o, o.pos);

	return o; 
}


////////////////////////////////////////////////////////////////////////////
//																		  //
//Fragment    															  //
//																		  //
////////////////////////////////////////////////////////////////////////////
fixed4 frag (v2f i) : SV_Target 
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


	#ifdef V_VC_LIGHTMAP_ON
		half3 lm = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.lm));

		retColor.rgb *= lm.rgb;

	#else 
		retColor *= i.vLight;
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
