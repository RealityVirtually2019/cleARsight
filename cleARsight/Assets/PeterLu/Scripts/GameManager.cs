using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.MagicLeap;

public class GameManager : MonoBehaviour
{
    public static GameManager instance;

    bool isOnStandBy;

    bool toggleStandBy;
    bool toggleActive;

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

    private void Awake()
    {
        instance = this;

        MLInput.Start();
        MLInput.OnControllerButtonDown += OnButtonDown;
        MLInput.OnControllerButtonUp += OnButtonUp;
        _controller = MLInput.GetController(MLInput.Hand.Left);
    }

    private void Start()
    {
        audioSource = GetComponentInChildren<AudioSource>();
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
        if(!toggleStandBy)
        {
            audioSource.clip = standbyModeActivatedAudio;
            audioSource.Play();
            toggleStandBy = true;
            toggleActive = false;
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
        if(!toggleActive)
        {
            audioSource.clip = activeModeActivatedAudio;
            audioSource.Play();
            toggleActive = true;
            toggleStandBy = false;
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
        MLInput.Stop();
    }
    
    void OnButtonDown(byte controller_id, MLInputControllerButton button)
    {
        if (button == MLInputControllerButton.HomeTap)
        {
            isOnStandBy = !isOnStandBy;
        }
        else if(button == MLInputControllerButton.HomeTap && button == MLInputControllerButton.Bumper)
        {
            StartVoiceOver(tutorialVoiceOver);
        }
        if(isOnStandBy)
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
        if(isOnStandBy)
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
            }
        }

    }

    private void HandleOnTouchpadGestureEnd(byte controllerId, MLInputControllerTouchpadGesture gesture)
    {
        if(isOnStandBy)
        {
            if (gesture.Type == MLInputControllerTouchpadGestureType.Swipe)
            {
                if (gesture.Direction == MLInputControllerTouchpadGestureDirection.Up)
                {
                    SwipeUpOff();
                }
                else if (gesture.Direction == MLInputControllerTouchpadGestureDirection.Left)
                {
                    SwipeDownOff();
                }
            }
        }
    }

    void StartVoiceOver(AudioClip audioClip)
    {
        audioSource.clip = audioClip;
        audioSource.Play();
    }
}
