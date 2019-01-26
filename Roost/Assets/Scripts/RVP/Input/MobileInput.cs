using UnityEngine;
using System.Collections;
using UnityEngine.UI;

namespace RVP
{
    [DisallowMultipleComponent]
    [AddComponentMenu("RVP/Input/Mobile Input Setter", 1)]

    //Class for setting mobile input
    public class MobileInput : MonoBehaviour
    {
        //Orientation the screen is locked at
        public ScreenOrientation screenRot = ScreenOrientation.LandscapeLeft;

        [System.NonSerialized]
        public float accel;
        [System.NonSerialized]
        public float brake;
        [System.NonSerialized]
        public float steer;
        [System.NonSerialized]
        public float ebrake;
        [System.NonSerialized]
        public bool boost;

        [System.NonSerialized]
        public bool upShift;

        [System.NonSerialized]
        public bool downShift;

        public VehicleParent vp;

        public float steerVal;



        //Set screen orientation
        void Start()
        {
            Screen.autorotateToPortrait = screenRot == ScreenOrientation.Portrait || screenRot == ScreenOrientation.AutoRotation;
            Screen.autorotateToPortraitUpsideDown = screenRot == ScreenOrientation.PortraitUpsideDown || screenRot == ScreenOrientation.AutoRotation;
            Screen.autorotateToLandscapeRight = screenRot == ScreenOrientation.LandscapeRight || screenRot == ScreenOrientation.Landscape || screenRot == ScreenOrientation.AutoRotation;
            Screen.autorotateToLandscapeLeft = screenRot == ScreenOrientation.LandscapeLeft || screenRot == ScreenOrientation.Landscape || screenRot == ScreenOrientation.AutoRotation;
            Screen.orientation = screenRot;

            vp = GetComponent<VehicleParent>();
        }

        //Input setting functions that can be linked to buttons
        public void SetAccel(float f)
        {
            accel = Mathf.Clamp01(f);
        }
        
        public void UpShift()
        {
            upShift = true;;
        }

        public void DownShift()
        {
            downShift = true;;
        }


        public void SetBrake(float f)
        {
            brake = Mathf.Clamp01(f);
        }

        public void TurnLeft()
        {
            steerVal = -1.0f;
            SetSteer(steerVal);
        }

        public void CancelTurnLeft()
        {
            steerVal = 0.0f;
            SetSteer(steerVal);
        }

        public void TurnRight()
        {
           steerVal = 1.0f;
           SetSteer(steerVal);
        }

        public void CancelTurnRight()
        {
            steerVal = 0.0f;
            SetSteer(steerVal);
        }

        public void SetSteer(float f)
        {
            steer = Mathf.Clamp(f, -1, 1);
        }

        public void SliderSetSteer(Slider slider)
        {
            steer = Mathf.Clamp(slider.value, -1, 1);
        }

        public void SetEbrake(float f)
        {
            ebrake = Mathf.Clamp01(f);
        }

        public void SetBoost(bool b)
        {
            boost = b;
        }
    }
}