uniform float targetHue;
uniform float hueWidth;
uniform float gain;
uniform float loss;
uniform float alpha;

uniform sampler2D source;
varying vec2 qt_TexCoord0;

// Hue in [0,1]

vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

float window(float center, float x)
{
    float left = center - 0.5 * hueWidth;
    float right = center + 0.5 * hueWidth;
    float delta = 0.1;
    if (x <= left - delta)
        return 0.0;
    else if (left - delta < x && x < left)
        return smoothstep(left - delta, left, x);
    else if (left <= x && x <= right)
        return 1.0;
    else if (right < x && x < right + delta)
        return 1.0 - smoothstep(right, right + delta, x);
    else
        return 0.0;
}

void main()
{
    vec2 uv = qt_TexCoord0.xy;
    vec3 rgbColor = texture2D(source, uv).rgb;
    vec3 hsvColor = rgb2hsv(rgbColor);
    vec3 color = rgbColor + (window(targetHue - 1.0, hsvColor.x) + window(targetHue, hsvColor.x) + window(targetHue + 1.0, hsvColor.x)) * (gain + loss) - loss;
    gl_FragColor = vec4(mix(rgbColor, color, alpha), 1.0);
}
