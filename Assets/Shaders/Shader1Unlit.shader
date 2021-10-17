Shader "WeiUnlit/Shader1Unlit"
{
    Properties
    {
        _ColorA ("ColorA", Color) = (1,1,1,0)   
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            

            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AUtolight.cginc"

            //mesh data: vertex position, vertex normal, uv coordinates, vertex colors
            struct appdata //vertex input
            {
                float4 vertex : POSITION;
                //float4 color : COLOR;
                float3 normal : NORMAL;
                float2 uv0 : TEXCOORD0;
                //float2 uv1 : TEXCOORD1;
            };

            struct v2f //vertex output
            {
                float2 uv0 : TEXCOORD0;
                float4 vertex : SV_POSITION; //clip position
                float3 normal : TEXCOORD1;
            };

            float4 _ColorA;

            // vertex functions, taking vertex input from appdata and transfer into clip space location and return it to vertex output
            v2f vert (appdata v)
            {
                v2f o;
                o.uv0 = v.uv0; // passthrough data from input to output
                o.normal = v.normal;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            //float - highest precision for desktop and consoles?
        
            //fixed - for mobile?
            //half - for mobile?

            fixed4 frag (v2f i) : SV_Target
            {

                
                float2 uv = i.uv0;
                
                // lightings
                //direct lightings
                float3 lightColor = _LightColor0.rgb;
                float3 lightDir = _WorldSpaceLightPos0.xyz;
                float lightFalloff = max(0, dot(lightDir,i.normal));
                float3 directDiffuseLight = lightColor * lightFalloff;

                //ambient lightings
                float3 ambientLight = float3(0.1,0.12,0.5);

                //Composite every lighting
                float3 diffuseLight = ambientLight + directDiffuseLight;
                float3 finalsurfaceColor = diffuseLight * _ColorA.rgb;
                
                


                //float3 normal = i.normal*0.5 +0.5; // -1 to 1
                return float4(finalsurfaceColor,0);
            }
            ENDCG
        }
    }
}
