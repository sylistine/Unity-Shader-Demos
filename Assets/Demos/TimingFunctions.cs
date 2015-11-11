using UnityEngine;

public class TimingFunctions
{
    public static float SineOut(float t)
    {
        return Mathf.Sin(t * (Mathf.PI / 2));
    }

    public static float SineIn(float t)
    {
        return Mathf.Sin((t - 1) * (Mathf.PI / 2)) + 1;
    }

    public static float SineInOut(float t)
    {
        return (Mathf.Sin((t * 2 - 1) * (Mathf.PI / 2)) + 1) / 2;
    }
}
