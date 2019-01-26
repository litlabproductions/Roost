using System.Collections;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Video;

[RequireComponent (typeof(AudioSource))]
public class PlayVideo : MonoBehaviour 
{
	public VideoPlayer vPlayer;

	void Start () 
	{
		vPlayer = GetComponent<VideoPlayer>();

		vPlayer.Play();
	}

	void Update () 
	{
		if (!vPlayer.isPlaying)
			UnityEngine.SceneManagement.SceneManager.LoadScene("MainMenu");
	}
}
