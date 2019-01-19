using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CamPosDetection : MonoBehaviour
{

    void Start()
    {

    }

    void FixedUpdate()
    {
        Shader.SetGlobalVector("_CamPos", transform.position);
    }

}
