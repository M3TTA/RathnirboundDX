#version 150

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler2;
uniform sampler2D Sampler0;
uniform float GameTime;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform vec3 ChunkOffset;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
out vec4 normal;

void main() {
    vec3 position = Position + ChunkOffset;
    float animation = GameTime * 4000.0;

    float xs = 0.0;
    float zs = 0.0;
    float opacity = texture(Sampler0, UV0).a * 255;
    if (opacity == 253.0 || opacity == 100.0) {
        xs = sin(position.x + animation);
        zs = cos(position.z + animation);
    }
    if (opacity == 100.0){
        xs *= 2;
        zs *= 2;
    }

    gl_Position = ProjMat * ModelViewMat * (vec4(position, 1.0) + vec4(xs / 32.0, 0.0, zs / 32.0, 0.0));

    vertexDistance = length((ModelViewMat * vec4(Position + ChunkOffset, 1.0)).xyz);
    vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);
    texCoord0 = UV0;
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);
}
