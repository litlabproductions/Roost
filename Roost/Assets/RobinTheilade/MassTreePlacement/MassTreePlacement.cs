using UnityEngine;

namespace RobinTheilade.MassTreePlacement
{
    /// <summary>
    /// Values for placing random trees.
    /// <see cref="T:RobinTheilade.MassTreePlacement.MassTreePlacementEditor"/> does the work.
    /// </summary>
    [AddComponentMenu("Terrain/Mass Tree Placement")]
    [RequireComponent(typeof(Terrain))]
    public class MassTreePlacement : MonoBehaviour
    {
        /// <summary>
        /// The number of trees to place.
        /// </summary>
        [Tooltip("The number of trees to place.")]
        public int count = 70000;

        /// <summary>
        /// The lowest point to position a tree.
        /// </summary>
        [Tooltip("The lowest point to position a tree.")]
        public float minWorldY = 1.0f;

        /// <summary>
        /// The highest point to position a tree.
        /// </summary>
        [Tooltip("The highest point to position a tree.")]
        public float maxWorldY = 5200.0f;

        /// <summary>
        /// The minimum allowed slope of the ground to position a tree.
        /// </summary>
        [Tooltip("The minimum allowed slope of the ground to position a tree.")]
        public float minSlope = 0.0f;

        /// <summary>
        /// The maximum allowed slope of the ground to position a tree.
        /// </summary>
        [Tooltip("The maximum allowed slope of the ground to position a tree.")]
        public float maxSlope = 40.0f;

        /// <summary>
        /// The minimum value to scale the width of a tree.
        /// </summary>
        [Tooltip("The minimum value to scale the width of a tree.")]
        public float minWidthScale = 0.9f;

        /// <summary>
        /// The maximum value to scale the width of a tree.
        /// </summary>
        [Tooltip("The maximum value to scale the width of a tree.")]
        public float maxWidthScale = 2.0f;

        /// <summary>
        /// The minimum value to scale the height of a tree.
        /// </summary>
        [Tooltip("The minimum value to scale the height of a tree.")]
        public float minHeightScale = 0.8f;

        /// <summary>
        /// The maximum value to scale the height of a tree.
        /// </summary>
        [Tooltip("The maximum value to scale the height of a tree.")]
        public float maxHeightScale = 3.5f;

        /// <summary>
        /// The maximum number of seconds for the placement process to take.
        /// The process is aborted if it takes any longer.
        /// </summary>
        [Tooltip("The maximum number of seconds for the placement process to take. The process is aborted if it takes any longer.")]
        public double maxTime = 30.0d;
    }
}