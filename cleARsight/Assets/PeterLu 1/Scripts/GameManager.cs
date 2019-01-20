using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.MagicLeap;
using MagicLeap;

public class GameManager : MonoBehaviour
{
    public static GameManager instance;

    public bool isOnStandBy;

    bool toggleStandBy;
    bool toggleActive = false;

    public AudioClip tutorialVoiceOver;

    [Header("StandBy/Active Audio Data")]
    public AudioClip standbyModeActivatedAudio;
    public AudioClip activeModeActivatedAudio;

    [Space(50)]
    [Header("StandBy Mode Audio Data")]
    public AudioClip triggerPressedVO;
    public AudioClip bumperPressedVO;
    public AudioClip swipeUpVO;
    public AudioClip swipeDownVO;
    public AudioClip homePressedVO;

    [Space(50)]
    [Header("Label Gameobjects")]
    public GameObject triggerLabel;
    public GameObject bumperLabel;
    public GameObject swipeUpLabel;
    public GameObject swipeDownLabel;

    private AudioSource audioSource;

    private MLInputController _controller;

    public cleARsightVisualizer visualizer;

    public GameObject hitCast;
    public AudioSource controllerAudioSource;
    public AudioSource turotialAudioSource;

    private void Awake()
    {
        instance = this;

        MLInput.Start();
        MLInput.OnControllerButtonDown += OnButtonDown;
        MLInput.OnControllerButtonUp += OnButtonUp;
        MLInput.OnControllerTouchpadGestureStart += HandleOnTouchpadGestureStart;
        MLInput.OnControllerTouchpadGestureEnd += HandleOnTouchpadGestureEnd;
        _controller = MLInput.GetController(MLInput.Hand.Left);
    }

    private void Start()
    {
        audioSource = controllerAudioSource;
    }

    private void Update()
    {
        if (isOnStandBy)
        {
            StandByMode();
        }
        else
        {
            ActiveMode();
        }
    }

    void StandByMode()
    {
        if (!toggleStandBy)
        {
            audioSource.clip = standbyModeActivatedAudio;
            audioSource.Play();
            toggleStandBy = true;
            toggleActive = false;

            visualizer.SetRenderers(cleARsightVisualizer.RenderMode.None);
            hitCast.SetActive(false);
        }

        StandByModeControlCheck();
    }

    void StandByModeControlCheck()
    {
        if (_controller.TriggerValue > 0.2f)
        {
            TriggerDown();
        }
        else
        {
            TriggerUp();
        }
    }

    void ActiveMode()
    {
        if (!toggleActive)
        {
            audioSource.clip = activeModeActivatedAudio;
            audioSource.Play();
            toggleActive = true;
            toggleStandBy = false;
            visualizer.SetRenderers(cleARsightVisualizer.RenderMode.Outline);
        }
    }


    //StandBy Actions
    //------------------------------------------------------------------
    //Trigger
    bool triggerToggle;
    void TriggerDown()
    {
        if (!triggerToggle)
        {
            audioSource.clip = triggerPressedVO;
            audioSource.Play();
            triggerToggle = true;
        }

        triggerLabel.SetActive(true);
    }

    void TriggerUp()
    {
        triggerLabel.SetActive(false);
        triggerToggle = false;
    }


    //Bumper
    void BumperDown()
    {
        audioSource.clip = bumperPressedVO;
        audioSource.Play();

        bumperLabel.SetActive(true);
    }

    void BumperUp()
    {
        bumperLabel.SetActive(false);
    }

    //SwipeDown
    bool swipeDownTrigger;
    void SwipedDown()
    {
        if (!swipeDownTrigger)
        {
            audioSource.clip = swipeDownVO;
            audioSource.Play();
            swipeDownTrigger = true;
        }

        swipeDownLabel.SetActive(true);
    }

    void SwipeDownOff()
    {
        swipeDownLabel.SetActive(false);
        swipeDownTrigger = false;
    }


    //SwipeUp
    bool swipeUpTrigger;
    void SwipedUp()
    {
        if (!swipeUpTrigger)
        {
            audioSource.clip = swipeUpVO;
            audioSource.Play();
            swipeUpTrigger = true;
        }

        swipeUpLabel.SetActive(true);
    }

    void SwipeUpOff()
    {
        swipeUpLabel.SetActive(false);
        swipeUpTrigger = false;
    }
    //---------------------------------------------------------------------------------------
    //---------------------------------------------------------------------------------------


    void OnDestroy()
    {
        MLInput.OnControllerButtonDown -= OnButtonDown;
        MLInput.OnControllerButtonUp -= OnButtonUp;

        MLInput.OnControllerTouchpadGestureStart -= HandleOnTouchpadGestureStart;
        MLInput.OnControllerTouchpadGestureEnd -= HandleOnTouchpadGestureEnd;

        MLInput.Stop();
    }

    void OnButtonDown(byte controller_id, MLInputControllerButton button)
    {
        if (button == MLInputControllerButton.HomeTap)
        {
            isOnStandBy = !isOnStandBy;
        }
        if (isOnStandBy)
        {
            if (button == MLInputControllerButton.Bumper)
            {
                BumperDown();
            }
        }
    }

    void OnButtonUp(byte controller_id, MLInputControllerButton button)
    {
        if (button == MLInputControllerButton.HomeTap)
        {

        }

        if (isOnStandBy)
        {
            if (button == MLInputControllerButton.Bumper)
            {
                BumperUp();
            }
        }
    }

    private void HandleOnTouchpadGestureStart(byte controllerId, MLInputControllerTouchpadGesture gesture)
    {
        if (isOnStandBy)
        {
            if (gesture.Type == MLInputControllerTouchpadGestureType.Swipe)
            {
                if (gesture.Direction == MLInputControllerTouchpadGestureDirection.Up)
                {
                    SwipedUp();
                }
                else if (gesture.Direction == MLInputControllerTouchpadGestureDirection.Down)
                {
                    SwipedDown();
                }
                else if (gesture.Direction == MLInputControllerTouchpadGestureDirection.Left)
                {
                    StartVoiceOver(tutorialVoiceOver);
                }
                else if (gesture.Direction == MLInputControllerTouchpadGestureDirection.Right)
                {
                    StopVoiceOver();
                }
            }
        }

    }

    private void HandleOnTouchpadGestureEnd(byte controllerId, MLInputControllerTouchpadGesture gesture)
    {
        if (isOnStandBy)
        {
            if (gesture.Type == MLInputControllerTouchpadGestureType.Swipe)
            {
                if (gesture.Direction == MLInputControllerTouchpadGestureDirection.Up)
                {
                    SwipeUpOff();
                }
                else if (gesture.Direction == MLInputControllerTouchpadGestureDirection.Down)
                {
                    SwipeDownOff();
                }
            }
        }
    }

    void StartVoiceOver(AudioClip audioClip)
    {
        turotialAudioSource.clip = audioClip;
        turotialAudioSource.Play();
    }

    void StopVoiceOver()
    {
        if(turotialAudioSource.isPlaying)
            turotialAudioSource.Stop();
    }
}
