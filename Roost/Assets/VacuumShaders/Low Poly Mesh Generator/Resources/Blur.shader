Shader "Hidden/VacuumShaders/Low Poly Mesh Generator/Blur"
{
    Properties
    {
        _MainTex("", 2D) = "white" {}
    }

    CGINCLUDE

    #include "UnityCG.cginc"

    sampler2D _MainTex;
    float4 _MainTex_TexelSize;


    half4 GaussianBlur(float2 uv, float2 coeff)
    {
        half4 s = tex2D(_MainTex, uv) * 0.227027027;

        float2 offset = coeff * 1.3846153846;
        s += (tex2D(_MainTex, uv + offset) + tex2D(_MainTex, uv - offset)) * 0.3162162162;

        offset = coeff * 3.2307692308;
        s += (tex2D(_MainTex, uv + offset) + tex2D(_MainTex, uv - offset)) * 0.0702702703;

        return s;
    }
	    

    half4 frag_h(v2f_img i) : SV_Target
    {
        return GaussianBlur(i.uv, float2(_MainTex_TexelSize.x, 0));
    }

    half4 frag_v(v2f_img i) : SV_Target
    {
        return GaussianBlur(i.uv, float2(0, _MainTex_TexelSize.y));
    }

    ENDCG

    Subshader
    {
        Pass
        {
            ZTest Always Cull Off ZWrite Off

            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag_h
            ENDCG
        }
        Pass
        {
            ZTest Always Cull Off ZWrite Off

            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag_v
            ENDCG
        }
    }
}
