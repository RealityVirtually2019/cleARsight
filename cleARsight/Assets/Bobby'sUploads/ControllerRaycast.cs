using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.MagicLeap;

public class ControllerRaycast : MonoBehaviour
{

    public Transform ctTransform; //Controller transform
    public GameObject prefab;    // Cube prefab

    // Use this for initialization
    void Start()
    {
        MLWorldRays.Start();
    }

    // Update is called once per frame
    void Update()
    {
        // Create a raycast parameters variable
        MLWorldRays.QueryParams _raycastParams = new MLWorldRays.QueryParams
        {
            // Update the parameters with our Camera's transform
            Position = ctTransform.position,
            Direction = ctTransform.forward,
            UpVector = ctTransform.up,
            // Provide a size of our raycasting array (1x1)
            Width = 1,
            Height = 1
        };
        // Feed our modified raycast parameters and handler to our raycast request
        MLWorldRays.GetWorldRays(_raycastParams, HandleOnReceiveRaycast);
    }
    private void OnDestroy()
    {
        MLWorldRays.Stop();
    }
    // Instantiate the prefab at the given point.
    // Rotate the prefab to match given normal.
    // Wait 2 seconds then destroy the prefab.
    private IEnumerator NormalMarker(Vector3 point, Vector3 normal)
    {
        Quaternion rotation = Quaternion.FromToRotation(Vector3.up, normal);
        GameObject go = Instantiate(prefab, point, rotation);
        yield return new WaitForSeconds(2);
        Destroy(go);
    }

    // Use a callback to know when to run the NormalMaker() coroutine.
    void HandleOnReceiveRaycast(MLWorldRays.MLWorldRaycastResultState state, UnityEngine.Vector3 point, Vector3 normal, float confidence)
    {
        if (state == MLWorldRays.MLWorldRaycastResultState.HitObserved)
        {
            StartCoroutine(NormalMarker(point, normal));
        }
    }

    // When the prefab is destroyed, stop MLWorldRays API from running.
}
