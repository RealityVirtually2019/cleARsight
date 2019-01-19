using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class proximityTrigger : MonoBehaviour {

    public float triggerDistance = 1.0f;
    private Transform target;
    private AudioSource memo;

	// Use this for initialization
	void Awake () {
        target = Camera.main.transform;
        memo = this.GetComponent<AudioSource>();
	}
	
	// Update is called once per frame
	void Update () {
		if((target.position - transform.position).magnitude < triggerDistance)
        {
            if (!memo.isPlaying)
            {
                memo.Play();
            }
        }
	}
}
