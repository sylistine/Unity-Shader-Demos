using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Transitioner : MonoBehaviour
{
    public class Scene
    {
        public int id;
        public Scene prev;
        public Scene next;

        public Scene (int i, Scene p, Scene n)
        {
            id = i;
            prev = p;
            next = n;
        }
    }
    
    public Camera _transitionCamera;
    public int[] sceneList;

    private int currentScene;
    private List<Scene> scenes = new List<Scene>();
    private bool transitioning = false;

    private Camera transitionCamera
    {
        get
        {
            if(_transitionCamera == null)
            {
                return null;
            }
            return _transitionCamera;
        }
    }
    
    void Start()
    {
        foreach (int sceneIndex in sceneList)
            scenes.Add(new Scene(sceneIndex, null, null));

        for (int i = 0; i < scenes.Count; i++)
        {
            scenes[i].prev = i == 0 ? scenes[scenes.Count - 1] : scenes[i - 1];
            scenes[i].next = i == scenes.Count - 1 ? scenes[0] : scenes[i + 1];
        }

        currentScene = 0;
        Application.LoadLevelAdditive(scenes[currentScene].id);
    }
    
    // Button event handler method.
    public void LoadPrev()
    {
        if (!transitioning)
            Load(scenes[currentScene].prev);
    }

    // Button event handler method.
    public void LoadNext()
    {
        if (!transitioning)
            Load(scenes[currentScene].next);
    }

    private void Load(Scene scene)
    {
        if(transitionCamera != null)
            StartCoroutine(Transition(scene));
        else
            LoadImmediate(scene);
    }

    private IEnumerator Transition(Scene scene)
    {
        var tCamAnimator = transitionCamera.GetComponent<HorizontalStretchProcess>();

        transitioning = true;

        tCamAnimator.transition = true;
        yield return new WaitForSeconds(1f);
        LoadImmediate(scene);
        yield return new WaitForSeconds(0.5f);
        tCamAnimator.transition = false;
        yield return new WaitForSeconds(1f);
        transitioning = false;
    }

    private void LoadImmediate(Scene scene)
    {
        Application.UnloadLevel(scenes[currentScene].id);
        Application.LoadLevelAdditive(scene.id);
        currentScene = scenes.IndexOf(scene);
    }
}
