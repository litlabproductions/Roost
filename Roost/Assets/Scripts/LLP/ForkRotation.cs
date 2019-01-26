	using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using SimpleInputNamespace;


public class ForkRotation : MonoBehaviour
{
	public bool turnLeft;
	public bool turnRight;

	public float leftX;
	public float leftY;
	public float leftZ;

	public float rightX;
	public float rightY;
	public float rightZ;
	public float defaultX;
	
	public float defaultY;

	public float defaultZ;

	public float turnSpeed;

	public float fixedTurnSpeed;

	public bool isMobile;
	
    public Joystick js;

	public float h;



	void Update ()
	{
			if(isMobile)
			   h = js.Value.x;
			else
				h = Input.GetAxis("Horizontal");

			if (h < 0)
				turnLeft = true;
			else
				turnLeft = false;

			if (h > 0)
				turnRight = true;
			else
				turnRight = false;	
		

		fixedTurnSpeed = isMobile ? turnSpeed * Mathf.Abs(h): turnSpeed; 

		if (turnLeft)
			transform.localRotation = Quaternion.Slerp(transform.localRotation, Quaternion.Euler(leftX, leftY, leftZ), Time.deltaTime * fixedTurnSpeed);
		else if (turnRight)
			transform.localRotation = Quaternion.Slerp(transform.localRotation, Quaternion.Euler(rightX, rightY, rightZ), Time.deltaTime * fixedTurnSpeed);
		else
			transform.localRotation = Quaternion.Slerp(transform.localRotation, Quaternion.Euler(defaultX, defaultY, defaultZ), Time.deltaTime * turnSpeed);
	}
	public void TurnLeft()
	{
		turnLeft = true;
	}

	public void CancelTurnLeft()
	{
		turnLeft = false;
	}

	public void TurnRight()
	{
		turnRight = true;
	}

	public void CancelTurnRight()
	{
		turnRight = false;
	}
}
	/*
		transform.localRotation =  Quaternion.Euler(-13.801f, 51.83f, 3f);  // LEFT 
		
		else if (turnRight)
			transform.localRotation =  Quaternion.Euler(14f, 130f, 3f); // RIGHT	
		*/