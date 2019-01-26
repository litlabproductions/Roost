﻿using UnityEngine;
using System.Collections;

namespace RVP
{

    //Static class with extra functions
    public static class F
    {
        //Returns the number with the greatest absolute value
        public static float MaxAbs(params float[] nums)
        {
            float result = 0;

            for (int i = 0; i < nums.Length; i++)
            {
                if (Mathf.Abs(nums[i]) > Mathf.Abs(result))
                {
                    result = nums[i];
                }
            }

            return result;
        }

        //Returns the topmost parent with a certain component
        public static Component GetTopmostParentComponent<T>(Transform tr) where T : Component
        {
            Component getting = null;

            while (tr.parent != null)
            {
                if (tr.parent.GetComponent<T>() != null)
                {
                    getting = tr.parent.GetComponent<T>();
                }

                tr = tr.parent;
            }

            return getting;
        }
    }
}