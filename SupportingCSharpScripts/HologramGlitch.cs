using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HologramGlitch : MonoBehaviour {

	public float glitchChance = .1f;

	private Renderer holoRenderer;
	private WaitForSeconds loopTime = new WaitForSeconds(.1f);
	private WaitForSeconds glitchDuration = new WaitForSeconds(.1f);

	void Awake() {
		holoRenderer = GetComponent<Renderer> ();
	}

	// Use IEnumerator to allow Start to be an iterator block
	IEnumerator Start () {
		while (true) {
			Debug.Log ("In while loop");
			float glitchTest = Random.Range (0f, 1f);
			if (glitchTest <= glitchChance) {
				Debug.Log ("In if statement");
				StartCoroutine (Glitch ());
			}
			yield return loopTime;
		}
	}

	// This is the function used by Start
	IEnumerator Glitch() {
		Debug.Log ("In Glitch method");
		//holoRenderer.material.SetFloat ("_Distance", .1f);
		holoRenderer.material.SetFloat ("_Amplitude", 100f);
		holoRenderer.material.SetFloat ("_Speed", 8.0f);

		// Dont understand why this doesnt exit the function, but it waits a certain amount of time before moving on
		yield return glitchDuration;
		//holoRenderer.material.SetFloat ("_Distance", .1f);
		holoRenderer.material.SetFloat ("_Amplitude", 7f);
		holoRenderer.material.SetFloat ("_Speed", 5.0f);

	}

}
