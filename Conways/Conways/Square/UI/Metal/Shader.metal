//
//  Shader.metal
//  Conways
//
//  Created by Justin Lycklama on 2021-09-24.
//

// https://metalbyexample.com/modern-metal-1/

#include <metal_stdlib>
using namespace metal;

// 16x16 game
#define GAME_SIZE 2
#define MAX_VALUE_COUNT GAME_SIZE*GAME_SIZE
#define segmentSize 0.5 // 1 / GAME_SIZE


struct GameValues {
    int values [256];
};

struct VertexIn {
    float3 position  [[attribute(0)]];
    float3 normal    [[attribute(1)]];
    float2 texCoords [[attribute(2)]];
};
 
struct VertexOut {
    float4 position [[position]];
    float4 eyeNormal;
    float4 eyePosition;
    float2 texCoords;
};

struct Uniforms {
    float4x4 modelViewMatrix;
    float4x4 projectionMatrix;
};

vertex VertexOut vertex_main(VertexIn vertexIn [[stage_in]],
                             constant Uniforms &uniforms [[buffer(1)]])
{
    VertexOut vertexOut;
    vertexOut.position = uniforms.projectionMatrix * uniforms.modelViewMatrix * float4(vertexIn.position, 1);
    vertexOut.eyeNormal = uniforms.modelViewMatrix * float4(vertexIn.normal, 0);
    vertexOut.eyePosition = uniforms.modelViewMatrix * float4(vertexIn.position, 1);
    vertexOut.texCoords = vertexIn.texCoords;
    return vertexOut;
}

fragment float4 fragment_main(VertexOut fragmentIn [[stage_in]],
                              constant GameValues& gameValues [[buffer(0)]] ) {
    
    // grab uv coords from our material
    float2 uv = fragmentIn.texCoords;


    float segmentX = floor(uv.x / segmentSize);
    float staircaseValueX = segmentX / GAME_SIZE;

    float segmentY = floor(uv.y / segmentSize);
    float staircaseValueY = segmentY / GAME_SIZE;

    int coordinate = GAME_SIZE * segmentY + segmentX;


    return (float4(1.0) * (staircaseValueX/2 + staircaseValueY/2)); // - _output.color.rgb;
//    return float4(1, 0, 0, 1);
}
