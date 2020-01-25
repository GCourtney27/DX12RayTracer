#include "Common.hlsl"


struct STriVertex
{
  float3 vertex;
  float4 color;
};

struct MyStructColors
{
  float4 a;
  float4 b;
  float4 c;
};

cbuffer Colors : register(b0)
{
  MyStructColors Tint[3];
}

StructuredBuffer<STriVertex> BTriVertex : register(t0);

[shader("closesthit")] 
void ClosestHit(inout HitInfo payload, Attributes attrib) 
{
  float3 barycentrics = float3(1.f - attrib.bary.x - attrib.bary.y, attrib.bary.x, attrib.bary.y);

  uint vertId = 3 * PrimitiveIndex();
  float3 hitColor = float3(0.6, 0.7, 0.6);
  // Shade only the first three instances (triangles)
  if(InstanceID() < 3)
  {
    int instanceID = InstanceID();
    hitColor = Tint[instanceID].a * barycentrics.x + Tint[instanceID].b * barycentrics.y +
                  Tint[instanceID].c * barycentrics.z;
  }
  //InstanceID()
  // float3 hitColor = BTriVertex[vertId + 0].color * barycentrics.x + 
  //                   BTriVertex[vertId + 1].color * barycentrics.y + 
  //                   BTriVertex[vertId + 2].color * barycentrics.z;

  payload.colorAndDistance = float4(hitColor, RayTCurrent());
}
