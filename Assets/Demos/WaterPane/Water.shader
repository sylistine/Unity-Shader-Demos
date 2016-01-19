Shader "Custom/Water"
{
	Properties
	{
		_MainTex ("Main Texture", 2D) = "white" {}
		_MulBlend ("Multiply Color", Color) = (1, 1, 1, 1)
		_AddBlend ("Add Color", Color) = (0, 0, 0, 0)
		_BurnBlend ("Burn Color", Color) = (1, 1, 1, 1)
		_WaveSpeed ("Wave Speed", Float) = 40.0
		_WaveFreq ("Wave Frequency", Float) = 20.0
		_WaveAmp ("Wave Amplitude", Float) = 0.1
	}

	SubShader
	{
		Tags {
			"Queue" = "Transparent"
			"RenderType" = "Opaque"
		}

		GrabPass
		{
			Name "BASE"
			Tags { "LightMode" = "Always" }
		}

		Pass
		{
			Name "BASE"
			Tags { "LightMode" = "Always" }

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct appdata_t
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 uvgrab : TEXCOORD0;
				float2 uv : TEXCOORD1;
			};

			float4 _MainTex_ST;

			v2f vert (appdata_t v)
			{
				v2f o;
				float scale = 1.0;
				#if UNITY_UV_STARTS_AT_TOP
				scale = -1.0;
				#endif

				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);

				// Align the grabbed UV to the standard UV
				o.uvgrab.xy = (float2(o.vertex.x, o.vertex.y * scale) + o.vertex.w) * 0.5;
				o.uvgrab.zw = o.vertex.zw;

				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

				return o;
			}

			sampler2D _GrabTexture;
			float4 _GrabTexture_TexelSize;

			half4 _MulBlend;
			half4 _AddBlend;
			half4 _BurnBlend;
			sampler2D _MainTex;
			float _WaveSpeed;
			float _WaveFreq;
			float _WaveAmp;

			half4 frag (v2f i) : COLOR
			{
				// Get our wave, used to transform the grabbed stuff.
				i.uvgrab.x += sin((i.uv.x + _Time * _WaveSpeed) * _WaveFreq) * _WaveAmp;

				half4 originalColor = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab));

				originalColor.rgb *= _MulBlend.rgb;
				originalColor.rgb += _AddBlend.rgb;
				originalColor.rgb = originalColor.rgb / _BurnBlend.rgb;

				return originalColor;
			}

			ENDCG
		}
	}
}
