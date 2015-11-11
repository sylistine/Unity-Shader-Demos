using UnityEngine;

public class HorizontalStretchProcess : PostProcess
{
    [Range(0, 1)]
    public float distance = 1;
    [Range(0, 1)]
    public float blackOut = 0;

    public bool transition = false;
    private Animator animator;

    void Start()
    {
        animator = this.GetComponent<Animator>();
    }

    void Update()
    {
        animator.SetBool("Transitioning", transition);
    }

    protected override Material ApplyMaterialProperties()
    {
        Material mat = material;

        mat.SetFloat("_Distance", distance);
        mat.SetFloat("_BlackOut", blackOut);

        return mat;
    }
}
