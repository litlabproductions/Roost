//  
// https://www.facebook.com/VacuumShaders

Shader "Hidden/VacuumShaders/Vertex Color/Unlit/Multiply/Simple"
{
    Properties 
    {
		//Rendering Options
		[V_VC_RenderingOptions_Unlit] _V_VC_RenderingOptions_UnlitEnumID("", float) = 0
		
		//Color and Texture
		[V_VC_ColorAndTexture]  _V_VC_ColorAndTextureEnumID("", float) = 0
		[HideInInspector] _Color("", color) = (1, 1, 1, 1)
		[HideInInspector] _MainTex("", 2D) = "white"{}
		[HideInInspector] _V_VC_MainTex_Scroll("", vector) = (0, 0, 0, 0) 

		//IBL
		[V_VC_IBL]      _V_VC_IBLEnumID("", float) = 0
		[HideInInspector] _V_VC_IBL_Cube_Intensity("", float) = 1
		[HideInInspector] _V_VC_IBL_Cube_Contrast("", float) = 1 
		[HideInInspector] _V_VC_IBL_Cube("", cube) = ""{}
		[HideInInspector] _V_VC_IBL_Light_Strength("", Range(-1, 1)) = 0	 
		[HideInInspector] _V_VC_IBL_Roughness("", Range(-1, 1)) = 0	   
		
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
    }

    SubShader  
    {
		Tags { "Queue"="Transparent+2" 
		       "IgnoreProjector"="True" 
			   "RenderType"="Transparent" 
			 }

		
		Blend Zero SrcColor
		ColorMask RGB
		Cull Off Lighting Off ZWrite Off Fog { Color (0,0,0,0) }
		 

		Pass 
	    {			
			Name "BASE"

            CGPROGRAM       
		    #pragma vertex vert    
	    	#pragma fragment frag    
			#pragma multi_compile_fog  
			 

			#pragma shader_feature V_VC_COLOR_AND_TEXTURE_OFF V_VC_COLOR_AND_TEXTURE_ON
			#pragma shader_feature V_VC_IBL_OFF V_VC_IBL_ON 
			#pragma shader_feature V_VC_REFLECTION_OFF V_VC_REFLECTION_CUBE_SIMPLE V_VC_REFLECTION_CUBE_ADVANED V_VC_REFLECTION_UNITY_REFLECTION_PROBES
			#pragma shader_feature V_VC_RIM_OFF V_VC_RIM_ON			   

			     
			#define V_VC_RENDERING_MODE_MULTIPLY

			#include "../cginc/VertexColor_Unlit.cginc"

	    	ENDCG

    	} //Pass
        
    } //SubShader
	
} //Shader
