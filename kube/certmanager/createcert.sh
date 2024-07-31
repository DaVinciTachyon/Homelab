#!/bin/bash

kubectl get secret selfsigned-key-pair -n cert-manager-system -o jsonpath='{.data.tls\.crt}' | base64 --decode > homelab.crt