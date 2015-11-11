using UnityEngine;
using System.Collections;

public class CRTProcess : PostProcess
{
    [Range(1, 48)]
    public int pixelWidth = 3;
    [Range(1, 48)]
    public int pixelHeight = 4;
    [Range(0, 48)]
    public int pixelPitch = 1;
    [Range(0, 1)]
    public float softness = 0.33f;

    protected override Material ApplyMaterialProperties ()
    {
        Material mat = material;

        mat.SetInt("_pixW", pixelWidth);
        mat.SetInt("_pixH", pixelHeight);
        mat.SetInt("_pixPitch", pixelPitch);
        mat.SetFloat("_softness", softness);

        return mat;
    }
}
