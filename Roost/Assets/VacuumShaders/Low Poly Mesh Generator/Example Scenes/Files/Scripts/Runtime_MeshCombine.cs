using UnityEngine;
using System.Collections;

//LowPoly Mesh Generator API is here ↓
using VacuumShaders.LowPolyMeshGenerator;


[AddComponentMenu("VacuumShaders/Low Poly Mesh Generator/Example/Runtime Mesh Combine")]
public class Runtime_MeshCombine : MonoBehaviour 
{
    //////////////////////////////////////////////////////////////////////////////
    //                                                                          // 
    //Variables                                                                 //                
    //                                                                          //               
    //////////////////////////////////////////////////////////////////////////////

    //All meshes inside 'meshfilterCollection' will be combined into one mesh
    public Transform meshfilterCollection;


    //Describes which textures and colors will be baked and how
    public LowPolyMeshOptions lowPolyOptions;



    //This material will be used on final mesh
    public Material vertexColorMaterial;


    //////////////////////////////////////////////////////////////////////////////
    //                                                                          // 
    //Unity Functions                                                           //                
    //                                                                          //               
    //////////////////////////////////////////////////////////////////////////////
	void Start () 
    {
        //First check if meshes inside 'meshfilterCollection' can be combined
        LowPolyMeshGenerator.COMBINE_INFO combineInfo;

        combineInfo = LowPolyMeshGenerator.CanBeMeshesCombined(meshfilterCollection);
        if (combineInfo != LowPolyMeshGenerator.COMBINE_INFO.OK)
        {
            //Houston we have a problem
            Debug.LogError(combineInfo.ToString());

            return;
        }


        
        //Will contain bake results 
        Mesh newMesh = null;

        //Will contain baking reports, will help if something goes wrong
        LowPolyMeshGenerator.CONVERTION_INFO[] convertionInfo;

        //Same as above but with more detail info
        string[] convertionInfoString;



        //Generating LowPoly meshes and then combining  
       newMesh = LowPolyMeshGenerator.GenerateLowPolyMeshesAndThenCombine(meshfilterCollection, out convertionInfo, out convertionInfoString, lowPolyOptions);


        //Check reports
        if (convertionInfoString != null)
            for (int i = 0; i < convertionInfoString.Length; i++)
            {
                if (convertionInfo[i] != LowPolyMeshGenerator.CONVERTION_INFO.Ok)
                    Debug.LogWarning(convertionInfoString[i]);
            }


        //Successful conversation
        if (newMesh != null)
        {
            gameObject.AddComponent<MeshFilter>().sharedMesh = newMesh;
            gameObject.AddComponent<MeshRenderer>().sharedMaterial = vertexColorMaterial;
        }
	}
}
