Shader "Unlit/AddColor"
{
    Properties
    {
        _Color("Color", Color) = (1, 1, 1, 1)
        _Brightness("ColorBrightness", Range(0,8)) = 1
        _MainTex("MainTex", 2D) = "black" {}
        _Speed ("Shine Speed", Float) = 1
        _min ("Light min", Range(0,1)) = 0.2
        _max ("Light max", Range(0,2)) = 1
    }
    SubShader
    {
        Tags{ "RenderType" = "Opaque" "Queue" = "Transparent" "IgnoreProjector" = "True" }

        Pass
        {
            ZWrite Off
            Lighting Off
            Fog { Mode Off }
            Blend One OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma shader_feature _INVERTROTATING_ON
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                fixed4 color : COLOR;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;                
                float4 vertex : SV_POSITION;
                fixed4 color : COLOR;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;            
            float4 _Color;            
            float _Brightness;
            float _Speed;
            float _min;
            float _max;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.color = v.color;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float light = clamp(sin(_Time.y * _Speed) + _min, _min, _max )* _Brightness ;

                fixed4 maintex = tex2D(_MainTex, i.uv).r;
                maintex *= maintex.r;
                fixed4 mulColor = maintex * _Color * light;
                return  saturate((maintex * (1 - mulColor.a) * i.color * i.color.a) + mulColor);
                
                
            }
            ENDCG
        }
    }
}
