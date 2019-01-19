using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.MagicLeap;

namespace MagicLeap
{

    public class HapticTrigger : MonoBehaviour
    {


        public ControllerConnectionHandler _controllerConnectionHandler;
        public RaycastAudio raycaster;
        public float distance;

        private AudioSource soundTrigger;
        private MLInputController controller;

        // Use this for initialization
        void Start()
        {
            soundTrigger = this.GetComponent<AudioSource>();
            controller = _controllerConnectionHandler.ConnectedController;
        }

        // Update is called once per frame
        void Update()
        {
            distance = raycaster.dist;
            if (soundTrigger.time < 0.1f && soundTrigger.isPlaying)
            {

                MLInputControllerFeedbackIntensity intensity = (MLInputControllerFeedbackIntensity)((int)(3.0f / distance));
                controller.StartFeedbackPatternVibe(MLInputControllerFeedbackPatternVibe.Buzz, intensity);
            }
        }
    }
}
