#version 150

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:globals.glsl> // ScreenSize(vec2) 유니폼 선언
#moj_import <minecraft:dynamictransforms.glsl>

uniform sampler2D Sampler0;

in float  sphericalVertexDistance;
in float  cylindricalVertexDistance;
in vec4   vertexColor;
in vec2   texCoord0;

out vec4  fragColor;

/* ─── 지울 색과 허용 오차 ─── */
const vec3 TARGET_COLOR = vec3(0.988, 0.329, 0.329);  // #FC5454
const float COLOR_EPS   = 0.02;
/* ──────────────────────────────── */

void main() {
    vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;

    // 화면 왼쪽에 있고, 특정 색상이면 숨기기
    if (
        ScreenSize.x * 0.97 < gl_FragCoord.x &&
        distance(color.rgb, TARGET_COLOR) < COLOR_EPS
    ) {
        discard;
    }
    /* ──────────────────────────────── */

    if (color.a < 0.1) {
        discard;
    }
    fragColor = apply_fog(color, sphericalVertexDistance, cylindricalVertexDistance, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, FogColor);
}