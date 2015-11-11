using UnityEngine;
using System.Collections;

public class PostProcess : MonoBehaviour
{
    public Shader shader;

    protected Material _material;
    protected Material material
    {
        get
        {
            if (_material == null)
            {
                _material = new Material(shader);
                _material.hideFlags = HideFlags.HideAndDontSave;
            }
            return _material;
        }
    }
	
    protected void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (shader == null) return;

        Material mat = ApplyMaterialProperties();

        Graphics.Blit(source, destination, mat);
    }

    protected virtual Material ApplyMaterialProperties()
    {
        Material mat = material;
        return mat;
    }
}
