using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class CrashDetector : MonoBehaviour
{

    [SerializeField] float delay = 1f;
    [SerializeField] ParticleSystem crashEffect;
    [SerializeField] AudioClip crashSFX;

    bool alive = true;

    void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.tag == "Ground")
        {
            FindObjectOfType<Player_Controller>().DisableControls();

            Debug.Log("Bonk");
            if (alive)
            {
                GetComponent<AudioSource>().PlayOneShot(crashSFX);
                crashEffect.Play();
                alive = false;
            }
            Invoke("reloadScene", delay);
        }
    }

    void reloadScene()
    {
        SceneManager.LoadScene(0);
    }

}
