using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Driver : MonoBehaviour
{

    [SerializeField]float steerSpeed = 0.5f;
    [SerializeField] float moveSpeed = 0.01f;
    [SerializeField] float slowSpeed = 20f;
    [SerializeField] float fastSpeed = 30f;

    void Start()
    {
        
    }

    void Update()
    {
        float steerAmount = Input.GetAxis("Horizontal") * steerSpeed * Time.deltaTime;
        float driveAmount = Input.GetAxis("Vertical") * moveSpeed * Time.deltaTime;
        transform.Translate(0, driveAmount, 0);
        if (Input.GetAxis("Vertical") != 0)
        {
            transform.Rotate(0, 0, -steerAmount);
        }
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.tag == "Booster")
        {
            moveSpeed = fastSpeed;
        }
    }

    private void OnCollisionEnter2D(Collision2D collision)
    {
        moveSpeed = slowSpeed;
    }
}
