//  
// https://www.facebook.com/VacuumShaders

Shader "Hidden/VacuumShaders/Vertex Color/Physically Based/Cutout/2 Sided/Bumped" 
{
	Properties 
	{
		//Rendering Options
		[V_VC_RenderingOptions_PBR] _V_VC_RenderingOptions_PBREnumID("", float) = 0

		//Color and Texture
		[V_VC_ColorAndTexture]  _V_VC_ColorAndTextureEnumID("", float) = 0
		[HideInInspector] _Color("", color) = (1, 1, 1, 1)
		[HideInInspector] _MainTex("", 2D) = "white"{}
		[HideInInspector] _V_VC_MainTex_Scroll("", vector) = (0, 0, 0, 0) 
		 	 	
		_Cutoff("Alpha cutoff", range(0, 1)) = 0.5
		   
		//Bump
	    [V_VC_BumpPBR]  _V_VC_BumpEnumID ("", Float) = 0	
		[HideInInspector] _V_VC_NormalMap ("", 2D) = "bump" {}

		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		
		//Rim
	    [V_VC_Rim]  _V_VC_RimEnumID ("", Float) = 0	
		[HideInInspector] _V_VC_RimColor("", color) = (1, 2, 1, 1)
		[HideInInspector] _V_VC_RimBias("", Range(-1, 1)) = 0
		[HideInInspector] _V_VC_RimPow("", Range(1, 16)) = 4
	}
	 
	SubShader 
	{
		Tags { "Queue"="AlphaTest"  
		       "IgnoreProjector"="True" 
			   "RenderType"="TransparentCutout" 
			 }
		LOD 200    
		     
		ZWrite Off
		Cull Front

		CGPROGRAM    
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows vertex:vert  

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0


		#pragma shader_feature V_VC_COLOR_AND_TEXTURE_OFF V_VC_COLOR_AND_TEXTURE_ON
		#pragma shader_feature V_VC_RIM_OFF V_VC_RIM_ON
		 
		
		#define V_VC_RENDERING_MODE_CUTOUT
		#define _NORMALMAP
		#define V_VC_INVERT_NORMAL

		#include "../cginc/VertexColor_PBR.cginc" 
		ENDCG 


		ZWrite On
		Cull Back

		CGPROGRAM    
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows vertex:vert alpha:fade  

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0


		#pragma shader_feature V_VC_COLOR_AND_TEXTURE_OFF V_VC_COLOR_AND_TEXTURE_ON
		#pragma shader_feature V_VC_RIM_OFF V_VC_RIM_ON
		 
		
		#define V_VC_RENDERING_MODE_CUTOUT
		#define _NORMALMAP

		#include "../cginc/VertexColor_PBR.cginc" 
		ENDCG 
	}
	
	FallBack "Hidden/VacuumShaders/Vertex Color/Vertex Lit/Cutout"
}
