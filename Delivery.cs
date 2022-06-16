// Code for Delivery system in Unity driving game

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Delivery : MonoBehaviour
{

    bool hasPackage = false;
    [SerializeField] float timer = 1f;
    [SerializeField] Color32 full = Color.green;
    [SerializeField] Color32 noPackage = Color.red;
    

    SpriteRenderer spriteRenderer;
    Driver driver;

    private void Start()
    {
        spriteRenderer = GetComponent<SpriteRenderer>();
        driver = GetComponent<Driver>();
    }


    void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.tag == "Package" && !hasPackage)
        {
            Debug.Log("Package picked!");
            hasPackage = true;
            Destroy(collision.gameObject,timer);
            spriteRenderer.color = full;
        }

        if (collision.tag == "Customer" && hasPackage)
        {
            Debug.Log("Package delivered!");
            hasPackage=false;
            spriteRenderer.color = noPackage;
        }
    }
}
