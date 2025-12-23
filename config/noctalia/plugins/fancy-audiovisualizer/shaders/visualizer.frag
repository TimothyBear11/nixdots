#version 450

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float time;
    float itemWidth;
    float itemHeight;
    vec4 primaryColor;
    vec4 accentColor;
    float sensitivity;
    float rotationSpeed;
    float showRings;
    float showBars;
    float barWidth;
    float ringOpacity;
    float cornerRadius;
    float bloomIntensity;
} ubuf;

layout(binding = 1) uniform sampler2D source;

#define TWOPI 6.28318530718
#define PI 3.14159265359
#define NBARS 32

// Sample audio amplitude at normalized position (0.0-1.0)
float getAudio(float pos) {
    return texture(source, vec2(clamp(pos, 0.0, 1.0), 0.5)).r;
}

// Smoothed audio sampling with interpolation
float smoothAudio(float pos) {
    float idx = pos * float(NBARS - 1);
    float frac = fract(idx);
    float i0 = floor(idx) / float(NBARS - 1);
    float i1 = ceil(idx) / float(NBARS - 1);
    return mix(getAudio(i0), getAudio(i1), frac) * ubuf.sensitivity;
}

// Frequency band helpers
float getBass() { return smoothAudio(0.05); }
float getMid() { return smoothAudio(0.3); }
float getHighMid() { return smoothAudio(0.6); }
float getTreble() { return smoothAudio(0.9); }

// SDF for rounded rectangle
float roundedBoxSDF(vec2 center, vec2 size, float radius) {
    vec2 q = abs(center) - size + radius;
    return min(max(q.x, q.y), 0.0) + length(max(q, 0.0)) - radius;
}

// Compute visualization color at given UV coordinates
// Returns vec4 with RGB color and alpha
vec4 computeVisualization(vec2 uv, float iTime, float bass, float mid, float highMid, float treble) {
    float aspect = ubuf.itemWidth / ubuf.itemHeight;
    vec2 centered = (uv - 0.5) * 2.0;
    centered.x *= aspect;

    float theta = atan(centered.y, centered.x);
    float d = length(centered);
    float baseRadius = 0.35;

    vec4 color = vec4(0.0);

    // RING SYSTEM
    if (ubuf.showRings > 0.5) {
        // Center Waves
        if (d < baseRadius * 0.6) {
            float wave = mid * 0.8;
            float ripple = sin(d * 25.0 + wave * 15.0 - iTime * 2.0);
            if (ripple > 0.7) {
                float intensity = clamp(mid * 0.6, 0.0, 0.4);
                vec4 waveColor = ubuf.accentColor * intensity * ubuf.ringOpacity;
                color = max(color, waveColor);
            }
        }

        // Energy Ring
        float energyRad = baseRadius * 0.65;
        float energyThickness = 0.015 + clamp(highMid * 0.02, 0.0, 0.03);
        if (d > energyRad - energyThickness && d < energyRad + energyThickness) {
            float segmentAngle = theta * 8.0 + highMid * 3.0 + iTime;
            if (mod(segmentAngle, 1.0) < 0.6) {
                float alpha = clamp(highMid * 2.0, 0.3, 1.0) * ubuf.ringOpacity;
                vec4 energyColor = mix(ubuf.primaryColor, ubuf.accentColor, 0.5) * alpha;
                color = max(color, energyColor);
            }
        }

        // Particle Ring
        float particleRad = baseRadius * 0.75;
        if (d > particleRad - 0.02 && d < particleRad + 0.02) {
            float particleAngle = theta + treble * 2.0 + iTime * 0.5;
            float particleSpacing = TWOPI / 16.0;
            if (mod(particleAngle, particleSpacing) < 0.15) {
                float brightness = 0.5 + clamp(treble * 1.5, 0.0, 0.5);
                vec4 particleColor = ubuf.accentColor * brightness * ubuf.ringOpacity;
                color = max(color, particleColor);
            }
        }

        // Tech Grid Ring
        float gridRad = baseRadius * 0.85;
        if (d > gridRad - 0.012 && d < gridRad + 0.012) {
            float gridAngle = theta + iTime * ubuf.rotationSpeed;
            float gridDensity = 0.08 + clamp(mid * 0.05, 0.0, 0.1);
            if (mod(gridAngle, 0.2) < gridDensity) {
                vec4 gridColor = ubuf.primaryColor * 0.7 * ubuf.ringOpacity;
                gridColor.rgb += vec3(0.1, 0.15, 0.2) * clamp(mid, 0.0, 0.8);
                color = max(color, gridColor);
            }
        }

        // Accent Ring
        float accentRad = baseRadius * 0.92;
        float pulse = clamp(bass * 0.08, 0.0, 0.05);
        if (d > accentRad - pulse - 0.008 && d < accentRad + pulse + 0.015) {
            float colorShift = clamp(bass * 0.5, 0.0, 1.0);
            vec4 ringColor = mix(ubuf.accentColor * 0.7, ubuf.primaryColor, colorShift);
            ringColor.a = ubuf.ringOpacity;
            ringColor.rgb *= 1.0 + bass * 0.3;
            color = max(color, ringColor);
        }

        // Outer Ring
        float outerRad = baseRadius + bass * 0.05;
        if (d > outerRad - 0.008 && d < outerRad + 0.008) {
            vec4 outerColor = ubuf.primaryColor * ubuf.ringOpacity;
            outerColor.rgb += vec3(0.2, 0.3, 0.4) * clamp(treble * 0.5, 0.0, 0.3);
            outerColor.rgb *= 1.0 + bass * 0.4;
            color = max(color, outerColor);
        }
    }

    // CIRCULAR AUDIO BARS (64 bars, mirrored from 32 audio samples)
    if (ubuf.showBars > 0.5 && d > baseRadius) {
        // Double the visual bars by using NBARS * 2
        float section = TWOPI / float(NBARS * 2);
        float center = section / 2.0;

        float adjustedTheta = theta + PI + iTime * ubuf.rotationSpeed * 0.2;
        float m = mod(adjustedTheta, section);
        float ym = d * sin(center - m);

        float barW = ubuf.barWidth * 0.015;
        if (abs(ym) < barW) {
            // Calculate position in the circle (0.0 to 1.0)
            float circlePos = mod(adjustedTheta, TWOPI) / TWOPI;
            // Mirror: first half (0-0.5) maps to 0-1, second half (0.5-1) maps back 1-0
            float mirroredPos = circlePos < 0.5 ? circlePos * 2.0 : (1.0 - circlePos) * 2.0;
            float v = smoothAudio(mirroredPos);

            float wave = sin(theta * 3.0 + mid * 5.0) * clamp(mid * 0.03, 0.0, 0.05);
            v += wave;
            v = max(v, 0.0);

            float barStart = baseRadius;
            float barEnd = baseRadius + v * 0.5;

            if (d >= barStart && d <= barEnd) {
                float heightFactor = (d - barStart) / max(barEnd - barStart, 0.001);

                vec3 bottomColor = ubuf.primaryColor.rgb * 0.6;
                vec3 middleColor = ubuf.primaryColor.rgb;
                vec3 topColor = ubuf.accentColor.rgb;

                vec3 barColor;
                if (heightFactor < 0.5) {
                    barColor = mix(bottomColor, middleColor, heightFactor * 2.0);
                } else {
                    barColor = mix(middleColor, topColor, (heightFactor - 0.5) * 2.0);
                }

                barColor *= 1.0 + bass * 0.4;

                if (heightFactor > 0.85) {
                    barColor += vec3(0.3, 0.4, 0.5) * clamp(treble * 0.8, 0.0, 0.5);
                }

                float edgeFactor = 1.0 - smoothstep(barW * 0.7, barW, abs(ym));
                vec4 finalBarColor = vec4(barColor, edgeFactor);
                color = max(color, finalBarColor);
            }
        }
    }

    return color;
}

void main() {
    vec2 uv = qt_TexCoord0;

    // Convert linear time (0-3600) to smooth oscillation for seamless looping
    // sin() ensures perfect continuity when QML wraps from 3600 back to 0
    float iTime = sin(ubuf.time * TWOPI / 3600.0) * 1800.0 + 1800.0;

    // Frequency analysis
    float bass = getBass();
    float mid = getMid();
    float highMid = getHighMid();
    float treble = getTreble();

    // Get base visualization color
    vec4 color = computeVisualization(uv, iTime, bass, mid, highMid, treble);

    // ============================================
    // BLOOM EFFECT - Glow based on distance to geometry
    // ============================================

    if (ubuf.bloomIntensity > 0.01 && color.a < 0.01) {
        // Only apply bloom where there's no geometry (empty space)
        // Find distance to nearest bright element

        float aspect = ubuf.itemWidth / ubuf.itemHeight;
        vec2 centered = (uv - 0.5) * 2.0;
        centered.x *= aspect;
        float d = length(centered);
        float theta = atan(centered.y, centered.x);

        float baseRadius = 0.35;
        float glowAmount = 0.0;
        vec3 glowColor = vec3(0.0);

        // Glow from rings (if enabled)
        if (ubuf.showRings > 0.5) {
            // Outer ring glow
            float outerRad = baseRadius + bass * 0.05;
            float ringDist = abs(d - outerRad);
            float ringGlow = exp(-ringDist * 8.0 / ubuf.bloomIntensity) * (1.0 + bass * 0.5);
            glowColor += ubuf.primaryColor.rgb * ringGlow;
            glowAmount = max(glowAmount, ringGlow);

            // Accent ring glow
            float accentRad = baseRadius * 0.92;
            float accentDist = abs(d - accentRad);
            float accentGlow = exp(-accentDist * 10.0 / ubuf.bloomIntensity) * (0.7 + bass * 0.3);
            glowColor += mix(ubuf.accentColor.rgb, ubuf.primaryColor.rgb, 0.5) * accentGlow;
            glowAmount = max(glowAmount, accentGlow);
        }

        // Glow from bars (if enabled and outside base radius) - 64 mirrored bars
        if (ubuf.showBars > 0.5 && d > baseRadius * 0.8) {
            float section = TWOPI / float(NBARS * 2);
            float adjustedTheta = theta + PI + iTime * ubuf.rotationSpeed * 0.2;
            float m = mod(adjustedTheta, section);
            float center = section / 2.0;

            // Distance to nearest bar edge
            float barAngleDist = min(abs(m - center), section - abs(m - center));
            float barW = ubuf.barWidth * 0.015;

            // Get bar height at this angle (mirrored)
            float circlePos = mod(adjustedTheta, TWOPI) / TWOPI;
            float mirroredPos = circlePos < 0.5 ? circlePos * 2.0 : (1.0 - circlePos) * 2.0;
            float v = smoothAudio(mirroredPos);
            float barEnd = baseRadius + v * 0.5;

            // Radial distance to bar
            float radialDist = 0.0;
            if (d < baseRadius) {
                radialDist = baseRadius - d;
            } else if (d > barEnd) {
                radialDist = d - barEnd;
            }

            // Combined distance (angular + radial)
            float totalDist = length(vec2(barAngleDist * d, radialDist));
            float barGlow = exp(-totalDist * 15.0 / ubuf.bloomIntensity) * v * 2.0;

            // Color gradient for bar glow
            float heightFactor = clamp((d - baseRadius) / max(barEnd - baseRadius, 0.001), 0.0, 1.0);
            vec3 barGlowColor = mix(ubuf.primaryColor.rgb, ubuf.accentColor.rgb, heightFactor);

            glowColor += barGlowColor * barGlow;
            glowAmount = max(glowAmount, barGlow);
        }

        // Apply bloom
        float bloomMult = ubuf.bloomIntensity * (1.0 + bass * 0.5);
        color.rgb = glowColor * bloomMult;
        color.a = glowAmount * bloomMult * 0.6;

        // Clamp to reasonable values
        color.rgb = min(color.rgb, vec3(1.5));
        color.a = min(color.a, 0.8);
    }

    // ============================================
    // CORNER MASKING
    // ============================================

    vec2 pixelPos = qt_TexCoord0 * vec2(ubuf.itemWidth, ubuf.itemHeight);
    vec2 centerPos = pixelPos - vec2(ubuf.itemWidth, ubuf.itemHeight) * 0.5;
    vec2 halfSize = vec2(ubuf.itemWidth, ubuf.itemHeight) * 0.5;
    float dist = roundedBoxSDF(centerPos, halfSize, ubuf.cornerRadius);
    float cornerMask = 1.0 - smoothstep(-1.0, 0.0, dist);

    // Final output with premultiplied alpha
    float finalAlpha = color.a * ubuf.qt_Opacity * cornerMask;
    fragColor = vec4(color.rgb * finalAlpha, finalAlpha);
}
