using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DisolveBike : MonoBehaviour
{
    public GameObject bike;
    public Material dissolveMat; 
    public void EnableBike()
    {
        //Debug.Log(dissolveMat.GetFloat("Vector1_7C536670"));
        dissolveMat.SetFloat("Vector1_7C536670", 0);
       // bike.SetActive(true);
    }

    public void DisableBike()
    {
        dissolveMat.SetFloat("Vector1_7C536670", 1);
       // bike.SetActive(true);
    }
    /*

    public Material dissolveMat;
    public float dissolveValue = 1.0f;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame

    void Update()
    {

        dissolveValue += Time.deltaTime / animationSpeed;

        dissolveMaterial.SetFloat("value", dissolveValue);
    }     */
}
