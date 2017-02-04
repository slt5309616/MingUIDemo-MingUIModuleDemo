using UnityEngine;
using System.Collections;
using MingUI.Com.Manager;

public class GameInit : MonoBehaviour {
    private SixWorldModule instance;
	// Use this for initialization
	void Start () {
        instance = SixWorldModule.getInstance();
	}

    void Update() {
        UILoopManager.FrameLoop();
    }
}
