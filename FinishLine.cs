// // Finish Line in Snow Boarding Unity game

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class FinishLine : MonoBehaviour
{

    [SerializeField] float delay = 1f;
    [SerializeField] ParticleSystem finishEffect;

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if(collision.tag == "Player")
        {
            Debug.Log("Finished!");
            finishEffect.Play();
            GetComponent<AudioSource>().Play();
            Invoke("reloadScene", delay);
            
        }
    }

    void reloadScene()
    {
        SceneManager.LoadScene(0);
    }
}
