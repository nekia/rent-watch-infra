#!/bin/bash
podname=$(kubectl get pod -n rentapp --selector=app=rentapp -o jsonpath="{.items[].metadata.name}")
echo $podname
kubectl cp -n rentapp $podname:/data/dump.rdb ./dump-$(date +%Y%m%d%H%M).rdb
podname2=$(kubectl get pod -n rentapp2 --selector=app=rentapp -o jsonpath="{.items[].metadata.name}")
echo $podname2
kubectl cp -n rentapp2 $podname2:/data/dump.rdb ./dump2-$(date +%Y%m%d%H%M).rdb
