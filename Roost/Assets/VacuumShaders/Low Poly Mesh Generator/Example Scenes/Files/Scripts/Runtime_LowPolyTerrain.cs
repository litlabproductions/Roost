using UnityEngine;
using System.Collections;

//Low Poly Mesh Generator API is here ↓
using VacuumShaders.LowPolyMeshGenerator;


[AddComponentMenu("VacuumShaders/Low Poly Mesh Generator/Example/Runtime Low Poly Terrain")]
public class Runtime_LowPolyTerrain : MonoBehaviour 
{
    //////////////////////////////////////////////////////////////////////////////
    //                                                                          // 
    //Variables                                                                 //                
    //                                                                          //               
    //////////////////////////////////////////////////////////////////////////////

    //
    public Terrain targetTerrain;

    
    //Terrain To Mesh options
    public LowPolyTerrainOptions lowPolyOptions;


    //This material will be used on final mesh
    public Material vertexColorMaterial;

    //////////////////////////////////////////////////////////////////////////////
    //                                                                          // 
    //Unity Functions                                                           //                
    //                                                                          //               
    //////////////////////////////////////////////////////////////////////////////
	void Start () 
    {
        if (targetTerrain == null)
            return;



        //Will contain bake results 
        //Need - array - as LowPolyMeshGenerator returns mesh array depending on chunk count
        Mesh[] newMesh = null;

        //Will contain baking reports, will help if something goes wrong
        LowPolyMeshGenerator.CONVERTION_INFO[] convertionInfo;

        //Same as above but with more detail info
        string[] convertionInfoString;



        //Generating LowPoly terrain       
        newMesh = LowPolyMeshGenerator.GenerateLowPolyTerrain(targetTerrain, out convertionInfo, out convertionInfoString, lowPolyOptions);

        //Check reports
        if (convertionInfoString != null)
            for (int i = 0; i < convertionInfoString.Length; i++)
            {
                Debug.LogWarning(convertionInfoString[i]);
            }


        //Successful conversation
        if (newMesh != null)
        {
            for (int i = 0; i < newMesh.Length; i++)
            {
                //Create new gameobject for each chunk
                GameObject chunk = new GameObject(newMesh[i].name);
                chunk.AddComponent<MeshFilter>().sharedMesh = newMesh[i];
                chunk.AddComponent<MeshRenderer>().sharedMaterial = vertexColorMaterial;

                
                //Move to parent
                chunk.transform.parent = this.gameObject.transform;
                chunk.transform.localPosition = Vector3.zero;
            }
        }
	}
}
