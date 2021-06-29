#!/bin/bash

kubectl run -i --rm --tty safe -n vault --overrides='
{
  "apiVersion": "v1",
  "kind": "Pod",
  "spec": {
    "serviceAccountName": "vault",
    "containers": [
      {
        "name": "safe",
        "image": "build.yields.io/safe:v1.6.1",
        "command": [
          "ash"
        ],
        "stdin": true,
        "stdinOnce": true,
        "tty": true,
        "env": [
          {
            "name": "POD_NAME",
            "valueFrom": {
              "fieldRef": {
                "apiVersion": "v1",
                "fieldPath": "metadata.name"
              }
            }
          }
        ],
        "volumeMounts": [
          {
            "mountPath": "/root/.saferc",
            "subPath": ".saferc",
            "name": "saferc"
          }
        ]
      }
    ],
    "volumes": [
      {
          "name": "saferc",
          "secret": {
              "defaultMode": 420,
              "secretName": "saferc"
          }
      }
    ]
  }
}
' --image=build.yields.io/safe:v1.6.1 --restart=Never -- ash
