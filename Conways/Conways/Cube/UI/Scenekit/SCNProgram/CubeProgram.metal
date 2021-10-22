
//
//  TimedStroke.metal
//  Delasign
//
//  Created by Oscar De la Hera Gomez on 9/21/18.
//  Copyright © 2018 Delasign. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

#include <SceneKit/scn_metal>

// SceneKit Definition
struct NodeBuffer {
    float4x4 modelTransform;
    float4x4 modelViewTransform;
    float4x4 normalTransform;
    float4x4 modelViewProjectionTransform;
    float2x3 boundingBox;
    
    float4x4 viewTransform;
    float4x4 inverseViewTransform; // view space to world space
    float4x4 projectionTransform;
    float4x4 viewProjectionTransform;
    float4x4 viewToCubeTransform; // view space to cube texture space (right-handed, y-axis-up)
    float4      ambientLightingColor;
    float4      fogColor;
    float3      fogParameters; // x: -1/(end-start) y: 1-start*x z: exponent
    float       time;     // system time elapsed since first render with this shader
    float       sinTime;  // precalculated sin(time)
    float       cosTime;  // precalculated cos(time)
    float       random01; // random value between 0.0 and 1.0
};

typedef struct {
    float3 position [[ attribute(SCNVertexSemanticPosition) ]];
    float2 texCoords0 [[ attribute(SCNVertexSemanticTexcoord0) ]];
    half4 color [[ attribute(SCNVertexSemanticColor)]];
    float3 normal   [[ attribute(SCNVertexSemanticNormal) ]];
    
} VertexInput;

// Width and Height for game
// When changing, recalculate segment size
#define GAME_SIZE 16
#define MAX_VALUE_COUNT GAME_SIZE*GAME_SIZE
#define segmentSize 0.0625 // 1 / GAME_SIZE

struct ShaderGameData {
    int8_t values [MAX_VALUE_COUNT * 6];
};

struct Vertex
{
    float4 position [[position]];
    float3 normal;
    float2 uv;
    half4 color;
    float2 texCoords [[user(tex_coords)]];
    float time;
    float4 modelViewProjectionTransformColumn;
};

vertex Vertex CubeVertexShader(VertexInput in [[ stage_in ]],
                                      uint vertexID [[vertex_id]],
                                      constant SCNSceneBuffer& scn_frame [[buffer(0)]],
                                      constant NodeBuffer& scn_node [[buffer(1)]])
{
    Vertex vert;
    vert.color = half4( half3(1,1,1), 0.1);
    vert.uv = in.texCoords0;
    vert.time = scn_frame.time;
    vert.modelViewProjectionTransformColumn = scn_node.modelViewProjectionTransform[3];
    vert.position = scn_node.modelViewProjectionTransform * float4(in.position, 1.0);
    vert.normal = in.normal;
    return vert;
}

/* Data from CPU to GPU resides in constant name space, we can attach through params below.
 Since this is meant to be an alternate shader for SceneKit, we need to include
 
 constant SCNSceneBuffer& scn_frame [[buffer(0)]],
 constant NodeBuffer& scn_node [[buffer(1)]]
 
 We can include custom buffers after this to pass extra data
 */

fragment half4 CubeFragmentShader(Vertex in [[stage_in]],
                                  constant SCNSceneBuffer& scn_frame [[buffer(0)]],
                                  constant NodeBuffer& scn_node [[buffer(1)]],
                                  constant ShaderGameData& game_data [[buffer(2)]])
{
    float2 uv = in.uv;

    int segmentX = clamp(int(floor(uv.x / segmentSize)), 0, GAME_SIZE - 1);
    int segmentY = clamp(int(floor(uv.y / segmentSize)), 0, GAME_SIZE - 1);

    int coordinateWithinSection = GAME_SIZE * segmentY + segmentX;

    /* section definitions. To refactor */
    
    int top = 0;
    int bottom = 1;
    int front = 2;
    int back = 3;
    int right = 4;
    int left = 5;
    
    int section =
    (1 - step(in.normal.y, 0.5)) * top +
    step(in.normal.y, -0.5) * bottom +
    (1 - step(in.normal.z, 0.5)) * front +
    step(in.normal.z, -0.5) * back +
    (1 - step(in.normal.x, 0.5)) * right +
    step(in.normal.x, -0.5) * left;
    
    int sectionOffset = MAX_VALUE_COUNT * section;

    //    half3 color = half3(abs(in.normal.xyz)) + half3(max(in.normal.zxy, 0.0)); // Color each face differently
    
    half4 fragColor = in.color;
    fragColor.rgb = (half3(1.0) * game_data.values[sectionOffset + coordinateWithinSection]);
    fragColor.a = 1;
        
    return fragColor;
}
