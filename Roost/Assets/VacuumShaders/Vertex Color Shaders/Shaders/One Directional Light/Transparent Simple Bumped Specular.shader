//  
// https://www.facebook.com/VacuumShaders

Shader "Hidden/VacuumShaders/Vertex Color/One Directional Light/Transparent/Simple/Bumped Specular"
{
	Properties     
	{                     
		//Rendering Options
		[V_VC_RenderingOptions_ODL] _V_VC_RenderingOptions_ODLEnumID("", float) = 0

		//Color and Texture
		[V_VC_ColorAndTexture]  _V_VC_ColorAndTextureEnumID("", float) = 0
		[HideInInspector] _Color("", color) = (1, 1, 1, 1)
		[HideInInspector] _MainTex("", 2D) = "white"{}
		[HideInInspector] _V_VC_MainTex_Scroll("", vector) = (0, 0, 0, 0) 
		 	 	   
		//Bump
	    [V_VC_BumpODL]  _V_VC_BumpEnumID ("", Float) = 0	
		[HideInInspector] _V_VC_NormalMap ("", 2D) = "bump" {}

		//Specular
	    [V_VC_SPECULAR] _V_VC_SpecularEnumID ("", Float) = 0
		[HideInInspector] _V_VC_Specular_Lookup("", 2D) = "black"{}

		//Reflection 
		[V_VC_Reflection] _V_VC_ReflectionEnumID("", float) = 0
		[HideInInspector]	_Cube("", Cube) = ""{}  
		[HideInInspector]	_ReflectColor("", Color) = (0.5, 0.5, 0.5, 1)
		[HideInInspector]	_V_VC_Reflection_Strength("", Range(0, 1)) = 0.5
		[HideInInspector]	_V_VC_Reflection_Fresnel_Bias("", Range(-1, 1)) = -1
		[HideInInspector]	_V_VC_Reflection_Roughness("", Range(0, 1)) = 0.3
		  
		//Rim
	    [V_VC_Rim]  _V_VC_RimEnumID ("", Float) = 0	
		[HideInInspector] _V_VC_RimColor("", color) = (1, 2, 1, 1)
		[HideInInspector] _V_VC_RimBias("", Range(-1, 1)) = 0
		[HideInInspector] _V_VC_RimPow("", Range(1, 16)) = 4

		//Vertex Light & Ambient
		[V_VC_EnvironmentLighting] _V_VC_VertexLightAndAmbientID ("", int) = 0
	}


	SubShader 
	{
		Tags { "Queue"="Transparent" 
		       "IgnoreProjector"="True" 
			   "RenderType"="Transparent"
			 }
		LOD 200		
		
		Blend SrcAlpha OneMinusSrcAlpha 		      

		//PassName "FORWARD" 
		Pass
	    { 
			Name "FORWARD" 
			Tags { "LightMode" = "ForwardBase" } 
			  
			CGPROGRAM            
			#pragma vertex vert   
	    	#pragma fragment frag  		  
			#pragma multi_compile_fwdbase nodirlightmap nodynlightmap
			#pragma target 3.0			       
			#pragma multi_compile_fog   
			

			#pragma shader_feature V_VC_COLOR_AND_TEXTURE_OFF V_VC_COLOR_AND_TEXTURE_ON
			#pragma shader_feature V_VC_REFLECTION_OFF V_VC_REFLECTION_CUBE_SIMPLE V_VC_REFLECTION_CUBE_ADVANED V_VC_REFLECTION_UNITY_REFLECTION_PROBES
			#pragma shader_feature V_VC_RIM_OFF V_VC_RIM_ON
			#pragma shader_feature V_VC_ENVIRONMENT_LIGHTING_OFF V_VC_ENVIRONMENT_LIGHTING_ON

			 
			#define _NORMALMAP
			#define V_VC_SPECULAR
			#define V_VC_RENDERING_MODE_TRANSPARENT

			#include "../cginc/VertexColor_ForwardBase.cginc"
			ENDCG   			 
		} //Pass   	
			 
	} //SubShader

	FallBack "Hidden/VacuumShaders/Vertex Color/Vertex Lit/Transparent"
} //Shader
