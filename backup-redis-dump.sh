#!/bin/bash
podname=$(kubectl get pod -n rentapp --selector=app=rentapp -o jsonpath="{.items[].metadata.name}")
echo $podname
kubectl cp -n rentapp $podname:/data/dump.rdb ./dump-$(date +%Y%m%d%H%M).rdb
