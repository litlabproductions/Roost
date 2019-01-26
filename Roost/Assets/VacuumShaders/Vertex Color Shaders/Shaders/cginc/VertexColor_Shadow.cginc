#ifndef VACUUM_SHADERS_VC_SHADOW_CGINC
#define VACUUM_SHADERS_VC_SHADOW_CGINC


//Variables//////////////////////////////////
#ifdef V_VC_RENDERING_MODE_CUTOUT
	half _Cutoff; 

	fixed4 _Color;
	sampler2D _MainTex;
	half4 _MainTex_ST;
	half2 _V_VC_MainTex_Scroll;
#endif

#include "UnityCG.cginc"


////////////////////////////////////////////////////////////////////////////
//																		  //
//Struct    															  //
//																		  //
////////////////////////////////////////////////////////////z////////////////
struct v2f 
{ 
	V2F_SHADOW_CASTER;				
	
	#ifdef V_VC_RENDERING_MODE_CUTOUT
		float4 uv : TEXCOORD1;
		fixed4 vColor : TEXCOORD2;
	#endif
};

 
////////////////////////////////////////////////////////////////////////////
//																		  //
//Vertex    															  //
//																		  //
////////////////////////////////////////////////////////////z////////////////
v2f vert( appdata_full v )
{
	v2f o = (v2f)0;
	

	#ifdef V_VC_RENDERING_MODE_CUTOUT
		o.uv.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
		o.uv.xy += _V_VC_MainTex_Scroll.xy * _Time.x;

		o.vColor = v.color;
	#endif

	TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
	return o;
}

////////////////////////////////////////////////////////////////////////////
//																		  //
//Fragment    															  //
//																		  //
////////////////////////////////////////////////////////////////////////////
float4 frag( v2f i ) : SV_Target
{
	#ifdef V_VC_RENDERING_MODE_CUTOUT

		fixed4 retColor = i.vColor;

		//Main Texture
		#ifdef V_VC_COLOR_AND_TEXTURE_ON
			half4 mainTex = tex2D(_MainTex, i.uv.xy);
				
			retColor *= mainTex * _Color;
		#endif
	 
		clip(retColor.a - _Cutoff);
	#endif

	SHADOW_CASTER_FRAGMENT(i)
}
#endif 
