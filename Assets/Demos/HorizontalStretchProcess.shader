Shader "Post Process/Horizontal Stretch"
{
  Properties
  {
    _MainTex("Main Texture", 2D) = "white" {}
    _Distance("Blur Distance", Float) = 1
    _BlackOut("Black Amount", Float) = 0
  }
  SubShader
  {
    pass
    {
      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag
      #include "UnityCG.cginc"

      struct v2f
      {
        float4 vertex : POSITION;
        float2 uv : TEXCOORD0;
      };

      v2f vert(appdata_full v)
      {
        v2f o;

        o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
        o.uv = MultiplyUV(UNITY_MATRIX_TEXTURE0, v.texcoord);

        return o;
      }

      uniform sampler2D _MainTex;
      float _Distance;
      float _BlackOut;

      half4 frag (v2f i) : COLOR
      {
        i.uv.x = (i.uv.x - 0.5) * _Distance + 0.5;

        return tex2D(_MainTex, i.uv) * (1-_BlackOut);
      }
      ENDCG
    }
  }
}
