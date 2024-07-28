#!/bin/bash

docker run \
        --rm --net=host \
        -v "${HOME}/.kube:/helm/.kube" \
        -v "${HOME}/.config/helm:/helm/.config/helm" \
        -v "${PWD}:/wd" \
        --workdir /wd ghcr.io/helmfile/helmfile:v0.156.0 \
        helmfile apply \
        --file ./helm/helmfile.yml

kubectl apply -k .