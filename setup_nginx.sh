#!/bin/bash

kubectl --kubeconfig kubeconfig get nodes

kubectl  --kubeconfig kubeconfig create -f https://github.com/badr42/oke_A1/blob/main/nginx_deployment.yaml
kubectl --kubeconfig kubeconfig expose deployment nginx-deployment --port=80 --target-port=80 --name=nginx-lb --type=LoadBalancer
