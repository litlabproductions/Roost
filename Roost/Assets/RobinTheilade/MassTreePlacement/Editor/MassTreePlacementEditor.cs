using System;
using System.Reflection;
using UnityEditor;
using UnityEngine;
using Random = UnityEngine.Random;

namespace RobinTheilade.MassTreePlacement
{
    /// <summary>
    /// Places random trees on a terrain.
    /// </summary>
    [CanEditMultipleObjects]
    [CustomEditor(typeof(MassTreePlacement))]
    public class MassTreePlacementEditor : Editor
    {
        /// <summary>
        /// Reference to the <see cref="T:UnityEngine.TerrainData"/> type
        /// for later invocation using reflection.
        /// </summary>
        private static readonly Type terrainDataType = typeof(TerrainData);

        /// <summary>
        /// Draws the "Place" and "Clear" buttons.
        /// </summary>
        public override void OnInspectorGUI()
        {
            base.OnInspectorGUI();

            var mtp = this.target as MassTreePlacement;
            var terrain = mtp.GetComponent<Terrain>();

            if (GUILayout.Button("Place"))
            {
                PlaceRandomTrees(terrain, mtp);
            }
            if (GUILayout.Button("Clear"))
            {
                Clear(terrain);
            }
        }

        /// <summary>
        /// Clears the terrain of all trees.
        /// </summary>
        /// <param name="terrain">
        /// The terrain who's trees to remove.
        /// </param>
        public static void Clear(Terrain terrain)
        {
            terrain.terrainData.treeInstances = new TreeInstance[0];
            RecalculateTreePositions(terrain.terrainData);
            terrain.Flush();
        }

        /// <summary>
        /// Places random trees on the terrain.
        /// </summary>
        /// <param name="terrain">
        /// The terrain to place trees on.
        /// </param>
        /// <param name="mtp">
        /// The settings for the tree placement.
        /// </param>
        public static void PlaceRandomTrees(Terrain terrain, MassTreePlacement mtp)
        {
            var data = terrain.terrainData;

            var num = data.treePrototypes.Length;
            if (num == 0)
            {
                Debug.LogWarning("Can't place trees because no prototypes are defined. Process aborted.");
                return;
            }

            Undo.RegisterCompleteObjectUndo(data, "Mass Place Trees");

            var start = DateTime.Now;

            var array = new TreeInstance[mtp.count];
            var i = 0;
            while (i < array.Length)
            {
                // stop if process have run for over X seconds
                var delta = DateTime.Now - start;
                if (delta.TotalSeconds >= mtp.maxTime)
                {
                    Debug.LogWarning("Process was taking too much time to run");
                    return;
                }

                var position = new Vector3(Random.value, 0.0f, Random.value);

                // don't allow placement of trees below minWorldY and above maxWorldY
                var y = data.GetInterpolatedHeight(position.x, position.z);
                var worldY = y + terrain.transform.position.y;
                if (worldY < mtp.minWorldY || worldY > mtp.maxWorldY)
                {
                    continue;
                }

                // don't allow placement of trees on surfaces flatter than minSlope and steeper than maxSlope
                var steepness = data.GetSteepness(position.x, position.z);
                if (steepness < mtp.minSlope || steepness > mtp.maxSlope)
                {
                    continue;
                }

                var color = Color.Lerp(Color.white, Color.gray * 0.7f, Random.value);
                color.a = 1f;

                var treeInstance = default(TreeInstance);
                treeInstance.position = position;
                treeInstance.color = color;
                treeInstance.lightmapColor = Color.white;
                treeInstance.prototypeIndex = Random.Range(0, num);
                treeInstance.widthScale = Random.Range(mtp.minWidthScale, mtp.maxWidthScale);
                treeInstance.heightScale = Random.Range(mtp.minHeightScale, mtp.maxHeightScale);
                array[i] = treeInstance;
                i++;
            }
            data.treeInstances = array;
            RecalculateTreePositions(data);
            terrain.Flush();
        }

        /// <summary>
        /// Invokes <see cref="M:UnityEngine.TerrainData.RecalculateTreePositions"/> using reflection.
        /// </summary>
        /// <param name="data">
        /// The instance to invoke the method on.
        /// </param>
        /// <remarks>
        /// Some say it is enough to simply call <see cref="M:UnityEngine.Terrain.Flush"/>
        /// however I'm not sure what the difference is, so I'm calling this just to be on the safe side.
        /// </remarks>
        private static void RecalculateTreePositions(TerrainData data)
        {
            terrainDataType.InvokeMember(
                "RecalculateTreePositions",
                BindingFlags.Instance | BindingFlags.NonPublic | BindingFlags.InvokeMethod,
                null,
                data,
                null
                );
        }
    }
}
