using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CamLook : MonoBehaviour {

    private float MouseX;
    private float MouseY;

    private float SmoothX;
    private float SmoothY;
    private Vector2 mouselook;
    [Range(1, 20)]
    public float sensitivity;
    [Range(1, 20)]
    public float Smoothing;
    
       

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update ()
    {

       // MouseX = Input.GetAxis("Mouse Y");
       // MouseY = Input.GetAxis("Mouse X");


        var md = new Vector2(MouseX, MouseY);
        md = Vector2.Scale(md, new Vector2(sensitivity * Smoothing, sensitivity * Smoothing));

        SmoothX = Mathf.Lerp(SmoothX, md.x, 1f / Smoothing);
        SmoothY = Mathf.Lerp(SmoothY, md.y, 1f / Smoothing);

        mouselook += new Vector2(-SmoothX, SmoothY);

        Quaternion rot = Quaternion.Euler(mouselook);
        this.transform.rotation = rot;


        if (Input.GetKey(KeyCode.Space))
        {
            MouseX = 0;
            MouseY = 0;

        }
        else
        {
            MouseX = Input.GetAxis("Mouse Y");
            MouseY = Input.GetAxis("Mouse X");
        }
       

	}
}
