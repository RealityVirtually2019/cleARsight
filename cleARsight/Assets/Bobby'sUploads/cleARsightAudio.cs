﻿
// ---------------------------------------------------------------------
// %BANNER_END%

using System.Linq;

using UnityEngine;
using UnityEngine.UI;
using UnityEngine.XR.MagicLeap;

namespace MagicLeap
{
    /// <summary>
    /// This class uses a controller to start/stop audio capture
    /// using the Unity Microphone class. The audio is then played
    /// through an audio source attached to the parrot in the scene.
    /// </summary>
    [RequireComponent(typeof(PrivilegeRequester))]
    public class cleARsightAudio : MonoBehaviour
    {

        #region Private Variables
        [SerializeField, Tooltip("The reference to the controller connection handler in the scene.")]
        private ControllerConnectionHandler _controllerConnectionHandler;

        [SerializeField, Tooltip("The audio source that should capture the microphone input.")]
        private AudioSource _inputAudioSource;

        [SerializeField, Tooltip("The memo game object.")]
        private GameObject memoPrefab;

        [SerializeField, Tooltip("The controller location where memo is spawned.")]
        private Transform controller;

        private PrivilegeRequester _privilegeRequester;

        private bool _canCapture = false;
        private bool _isCapturing = false;
        private string _deviceMicrophone = string.Empty;

        private float _audioMaxSample = 0;
        private float[] _audioSamples = new float[128];
        
        private float _audioDetectionStart = 0;
        private float _audioDetectionEnd = 0;

        private const int AUDIO_CLIP_LENGTH_SECONDS = 60;
        private const int AUDIO_CLIP_FREQUENCY_HERTZ = 48000;
        private const float AUDIO_SENSITVITY_DECIBEL = 0.00015f;
        private const float AUDIO_CLIP_TIMEOUT_SECONDS = 2;
        private const float AUDIO_CLIP_FALLOFF_SECONDS = 0.5f;
        private const float ROTATION_DAMPING = 100;

        
        #endregion

        #region Unity Methods
        void Awake()
        {
            if (_inputAudioSource == null)
            {
                Debug.LogError("Error: AudioCaptureExample._inputAudioSource is not set, disabling script.");
                enabled = false;
                return;
            }

            if (_controllerConnectionHandler == null)
            {
                Debug.LogError("Error: AudioCaptureExample._controllerConnectionHandler is not set, disabling script.");
                enabled = false;
                return;
            }

            // Before enabling the microphone, the scene must wait until the privileges have been granted.
            _privilegeRequester = GetComponent<PrivilegeRequester>();

            _privilegeRequester.OnPrivilegesDone += HandleOnPrivilegesDone;
            MLInput.OnControllerButtonDown += HandleOnButtonDown;
            MLInput.OnControllerTouchpadGestureContinue += HandleOnTouchpadGestureEnd;
            MLInput.OnControllerTouchpadGestureStart += HandleOnTouchpadGestureStart;
        }

        void OnDestroy()
        {
            _privilegeRequester.OnPrivilegesDone -= HandleOnPrivilegesDone;
            MLInput.OnControllerButtonDown -= HandleOnButtonDown;


            MLInput.OnControllerTouchpadGestureContinue -= HandleOnTouchpadGestureEnd;
            MLInput.OnControllerTouchpadGestureStart -= HandleOnTouchpadGestureStart;

            StopCapture();
        }

        void OnApplicationPause(bool pause)
        {
            if (pause)
            {
                if (_isCapturing)
                {
                    // require privledges to be checked again.
                    _canCapture = false;

                    StopCapture();
                }
            }
        }
        #endregion

        #region Private Methods
        private void StartCapture()
        {

            // Use the first detected Microphone device.
            if (Microphone.devices.Length > 0)
            {
                _deviceMicrophone = Microphone.devices[0];
            }

            // If no microphone is detected, exit early and log the error.
            if (string.IsNullOrEmpty(_deviceMicrophone))
            {
                Debug.LogError("Error: AudioCaptureExample._deviceMicrophone is not set.");
                return;
            }

            _isCapturing = true;
            _inputAudioSource.clip = Microphone.Start(_deviceMicrophone, true, AUDIO_CLIP_LENGTH_SECONDS, AUDIO_CLIP_FREQUENCY_HERTZ);
            _inputAudioSource.loop = true;

        }

        private void StopCapture()
        {
            _isCapturing = false;

            // Stop microphone and input audio source.
            _inputAudioSource.Stop();

            if (!string.IsNullOrEmpty(_deviceMicrophone))
            {
                Microphone.End(_deviceMicrophone);
            }
            
        }

        private void MakeMemo()
        {
            var memo = Instantiate(memoPrefab, controller.transform.position, Quaternion.identity);
            var memosound = memo.GetComponent<AudioSource>();
            //memosound.clip = CreateAudioClip(_inputAudioSource.clip, _audioDetectionStart, _audioDetectionEnd);
            
            _audioDetectionStart = 0;
            _audioDetectionEnd = 0;
        }


        /// <summary>
        /// Creates a new audio clip within the start and stop range.
        /// </summary>
        /// <param name="clip"></param>
        /// <param name="start"></param>
        /// <param name="stop"></param>
        /// <returns></returns>
        private AudioClip CreateAudioClip(AudioClip clip, float start, float stop)
        {
            int length = (int)(clip.frequency * (stop - start));
            if (length <= 0)
            {
                return null;
            }

            AudioClip audioClip = AudioClip.Create("Memo", length, 1, clip.frequency, false);

            float[] data = new float[length];
            clip.GetData(data, (int)(clip.frequency * start));
            audioClip.SetData(data, 0);

            return audioClip;
        }
        #endregion

        #region Event Handlers
        /// <summary>
        /// Responds to privilege requester result.
        /// </summary>
        /// <param name="result"/>
        private void HandleOnPrivilegesDone(MLResult result)
        {
            if (!result.IsOk)
            {
                if (result.Code == MLResultCode.PrivilegeDenied)
                {
                    Instantiate(Resources.Load("PrivilegeDeniedError"));
                }

                Debug.LogErrorFormat("Error: AudioCaptureExample failed to get all requested privileges, disabling script. Reason: {0}", result);
                enabled = false;
                return;
            }

            _canCapture = true;
            Debug.Log("Succeeded in requesting all privileges");
            
        }

        private void HandleOnButtonDown(byte controllerId, MLInputControllerButton button)
        {
            if (_controllerConnectionHandler.IsControllerValid(controllerId))
            {
                if (_canCapture && button == MLInputControllerButton.Bumper)
                {
                    // Stop & Start to clear the previous mode.
                    if (_isCapturing)
                    {
                        _audioDetectionEnd = _inputAudioSource.time;
                        MakeMemo();
                        StopCapture();
                    }
                    else
                    {
                        StartCapture();
                    }
                }
            }
        }

        /// <summary>
        /// Update swiping counters to update textures if swipe left or right.
        /// </summary>
        /// <param name="controllerId">The id of the controller.</param>
        /// <param name="gesture">Touchpad gesture getting done.</param>
        private void HandleOnTouchpadGestureStart(byte controllerId, MLInputControllerTouchpadGesture gesture)
        {
            if (_controllerConnectionHandler.IsControllerValid(controllerId) && gesture.Type == MLInputControllerTouchpadGestureType.Swipe)
            {
                if (gesture.Direction == MLInputControllerTouchpadGestureDirection.Up)
                {
                }
                else if (gesture.Direction == MLInputControllerTouchpadGestureDirection.Left)
                {
                }
            }
        }

        /// <summary>
        /// Update swiping counters to update textures if swipe left or right.
        /// </summary>
        /// <param name="controllerId">The id of the controller.</param>
        /// <param name="gesture">Touchpad gesture getting done.</param>
        private void HandleOnTouchpadGestureEnd(byte controllerId, MLInputControllerTouchpadGesture gesture)
        {
            if (_controllerConnectionHandler.IsControllerValid(controllerId) && gesture.Type == MLInputControllerTouchpadGestureType.Swipe)
            {
                if (gesture.Direction == MLInputControllerTouchpadGestureDirection.Right)
                {
                }
                else if (gesture.Direction == MLInputControllerTouchpadGestureDirection.Left)
                {
                }
            }
        }
        #endregion
    }
}
