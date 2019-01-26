Shader "Hidden/VacuumShaders/Vertex Color/Vertex Lit/Cutout" 
{
	Properties 
	{    
		//Rendering Options
		[V_VC_RenderingOptions_VertexLit] _V_VC_RenderingOptions_VertexLitEnumID("", float) = 0

		//Color and Texture
		[V_VC_ColorAndTexture]  _V_VC_ColorAndTextureEnumID("", float) = 0
		[HideInInspector] _Color("", color) = (1, 1, 1, 1)
		[HideInInspector] _MainTex("", 2D) = "white"{}
		[HideInInspector] _V_VC_MainTex_Scroll("", vector) = (0, 0, 0, 0) 

		_Cutoff("Alpha cutoff", range(0, 1)) = 0.5
	} 
	    
	Category      
	{
		Tags { "Queue"="AlphaTest" 
		       "IgnoreProjector"="True" 
			   "RenderType"="TransparentCutout" 
			 }    
		LOD 150 
	 
		SubShader  
		{			    
		 
			// Vertex Lit, emulated in shaders (4 lights max, no specular)
			Pass    
			{
				Tags { "LightMode" = "Vertex" }
				Lighting On 

				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma multi_compile_fog


			    #pragma shader_feature V_VC_COLOR_AND_TEXTURE_OFF V_VC_COLOR_AND_TEXTURE_ON

				#define V_VC_RENDERING_MODE_CUTOUT

				#include "../cginc/VertexColor_VertexLit.cginc"
				
				ENDCG
			}
		 
			// Lightmapped
			Pass 
			{
				Tags { "LightMode" = "VertexLM" }

				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma multi_compile_fog


			    #pragma shader_feature V_VC_COLOR_AND_TEXTURE_OFF V_VC_COLOR_AND_TEXTURE_ON


				#define V_VC_LIGHTMAP_ON
				#define V_VC_RENDERING_MODE_CUTOUT

				#include "../cginc/VertexColor_VertexLit.cginc"

				 
				ENDCG         
			}    
		     
			// Lightmapped, encoded as RGBM
			Pass 
	 		{
				Tags { "LightMode" = "VertexLMRGBM" }

				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma multi_compile_fog


			    #pragma shader_feature V_VC_COLOR_AND_TEXTURE_OFF V_VC_COLOR_AND_TEXTURE_ON
			  

				#define V_VC_LIGHTMAP_ON
				#define V_VC_RENDERING_MODE_CUTOUT

				#include "../cginc/VertexColor_VertexLit.cginc"
				 
				ENDCG
			}  
			 
			
			// Pass to render object as a shadow caster
			Pass 
			{
				Name "ShadowCaster"
				Tags { "LightMode" = "ShadowCaster" }
		
				CGPROGRAM
				#pragma vertex vert   
				#pragma fragment frag 
				#pragma multi_compile_shadowcaster 
				#include "UnityCG.cginc" 
				

			    #pragma shader_feature V_VC_COLOR_AND_TEXTURE_OFF V_VC_COLOR_AND_TEXTURE_ON

			  
				#define V_VC_RENDERING_MODE_CUTOUT 

				#include "../cginc/VertexColor_Shadow.cginc" 			
				ENDCG 
			}
		}
	}

	FallBack Off
}
 
