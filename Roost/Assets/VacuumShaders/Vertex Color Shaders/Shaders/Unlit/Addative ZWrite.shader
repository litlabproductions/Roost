//  
// https://www.facebook.com/VacuumShaders

Shader "Hidden/VacuumShaders/Vertex Color/Unlit/Addative/ZWrite"
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
			  
		
		Pass 
		{
			ZWrite On
			ColorMask 0
		}
		
		UsePass "Hidden/VacuumShaders/Vertex Color/Unlit/Addative/Simple/BASE"
        
    } //SubShader

} //Shader
