// SceneB.
// SceneB is given the sceneBuildIndex of 0 which will
// load SceneA from the Build Settings

using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneChange : MonoBehaviour
{
    public void LoadTheBackwoods()
    {
         SceneManager.LoadScene("TheBackwoods", LoadSceneMode.Additive);
    }
}