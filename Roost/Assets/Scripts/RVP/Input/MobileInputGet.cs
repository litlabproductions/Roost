﻿using UnityEngine;
using System.Collections;
using SimpleInputNamespace;

namespace RVP
{
    [RequireComponent(typeof(VehicleParent))]
    [DisallowMultipleComponent]
    [AddComponentMenu("RVP/Input/Mobile Input Getter", 2)]

    //Class for getting mobile input
    public class MobileInputGet : MonoBehaviour
    {
        VehicleParent vp;
        MobileInput setter;
        public float steerFactor = 1;
        public float flipFactor = 1;
        public bool useAccelerometer = true;

        [Tooltip("Multiplier for input addition based on rate of change of input")]
        public float deltaFactor = 10;
        Vector3 accelerationPrev;
        Vector3 accelerationDelta;


        public Joystick js;
        void Start()
        {
            vp = GetComponent<VehicleParent>();
            setter = FindObjectOfType<MobileInput>();
        }

        void FixedUpdate()
        {
            if (setter)
            {
                accelerationDelta = Input.acceleration - accelerationPrev;
                accelerationPrev = Input.acceleration;
                vp.SetAccel(setter.accel);
                vp.SetBrake(setter.brake);
                vp.SetEbrake(setter.ebrake);
                vp.SetBoost(setter.boost);
                
                    //  **************************************
                    // ** NOT FINISHED **
                vp.SetPitch(js.Value.y);
                //vp.SetYaw(Input.GetAxis(yawAxis));
                vp.SetRoll(js.Value.x);

                if (setter.upShift)
                {
                    vp.upshiftPressed = true;
                    setter.upShift = false;
                } 
                else if (setter.downShift)
                {
                    vp.downshiftPressed = true;
                    setter.downShift = false;
                } 

                if (useAccelerometer)
                {
                    vp.SetSteer((Input.acceleration.x + accelerationDelta.x * deltaFactor) * steerFactor);
                    vp.SetYaw(Input.acceleration.x * flipFactor);
                    vp.SetPitch(-Input.acceleration.z * flipFactor);
                }
                else  // *********** THIS ONE VV
                {
                    vp.SetSteer(js.Value.x);
                }
            }
        }
    }
}