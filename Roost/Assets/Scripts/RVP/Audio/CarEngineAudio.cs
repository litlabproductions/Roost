using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace RVP
{


public class CarEngineAudio : MonoBehaviour 
{
 	FMOD.Studio.EventInstance CarEngine;
 	FMOD.Studio.ParameterInstance RPM;
 	FMOD.Studio.ParameterInstance AccelInput;

	public float rpmTest;

 	void Awake ()
 	{
  		CarEngine = FMODUnity.RuntimeManager.CreateInstance ("event:/125_2stroke_sounds");
  		CarEngine.getParameter ("RPM", out RPM);
  		CarEngine.getParameter ("Accel", out AccelInput);
  		//CC = GetComponent<CarController> ();
 	}

 	void Start ()
 	{
  		FMODUnity.RuntimeManager.AttachInstanceToGameObject(CarEngine, GetComponent<Transform>(), GetComponent<Rigidbody>());
  		CarEngine.start ();
 	}

 	void Update ()
 	{
  		RPM.setValue (GetComponent<GasMotor>().GetActualRPM());
 	 	AccelInput.setValue (GetComponent<GasMotor>().actualAccel);

		rpmTest = GetComponent<GasMotor>().GetActualRPM();
		 // rpmTest = (GetComponent<GasMotor>().Get);
 	}
}
}