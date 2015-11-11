Shader "Post Process/CRT"
{
  Properties
  {
    _MainTex("Albedo (RGB)", 2D) = "white" {}
    _pixW("Pixel Width", Int) = 0
    _pixH("Pixel Height", Int) = 0
    _pixPitch("Pixel Pitch", Int) = 0
    _softness("Softness", Float) = 0
  }
  SubShader
  {
    pass
    {
      CGPROGRAM

      #pragma vertex vert
      #pragma fragment frag
      #include "UnityCG.cginc"

      // Use shader model 3.0 target, to get nicer looking lighting
      #pragma target 3.0

      struct v2f {
        float4 pos  : POSITION;
        float2 uv   : TEXCOORD0;
        float4 sPos : TEXCOORD1;
      };

      uniform sampler2D _MainTex;
      uniform float _pixW;
      uniform float _pixH;
      uniform float _pixPitch;
      uniform float _softness;

      v2f vert(appdata_img v) {
        v2f o;

        o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
        o.uv = MultiplyUV(UNITY_MATRIX_TEXTURE0, v.texcoord);
        o.sPos = ComputeScreenPos(o.pos);

        return o;
      }

      half4 frag(v2f i) : COLOR {
        half4 color;
        half4 sPixelColor = half4(0, 0, 0, 0);
        half4 glow = half4(0, 0, 0, 0);
        float timeMod = (sin(_Time * 64) + 1) / 2;

        float2 screenParams = _ScreenParams.xy / i.sPos.w;
        float2 sPos = i.sPos.xy * screenParams;
        int sPixelPositionX = (int)sPos.x % (int)(_pixW + _pixPitch);
        int sPixelPositionY = (int)sPos.y % (int)(_pixH + _pixPitch);

        i.uv.x -= sPixelPositionX / screenParams.x;
        i.uv.y += sPixelPositionY / screenParams.y;

        if (sPixelPositionX < _pixPitch || sPixelPositionY < _pixPitch)
        {
        }
        else if (sPixelPositionX < _pixPitch + (_pixW / 3) * 1)
        {
          sPixelColor.r = 1;
          sPixelColor.g = _softness;
          sPixelColor.b = _softness;
        }
        else if (sPixelPositionX < _pixPitch + (_pixW / 3) * 2)
        {
          sPixelColor.r = _softness;
          sPixelColor.g = 1;
          sPixelColor.b = _softness;
        }
        else
        {
          sPixelColor.r = _softness;
          sPixelColor.g = _softness;
          sPixelColor.b = 1;
        }

        color = tex2D(_MainTex, i.uv);
        color = color * sPixelColor;

        return color;
      }

      ENDCG
    }
  }
  FallBack "Diffuse"
}