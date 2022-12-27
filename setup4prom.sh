#!/bin/bash


kubectl get pod -n prom | grep prom-idle | grep -q Running
if [ $? -eq 1 ]; then
	set -e
	echo "Setup POD..."
	TEMPFILE=`tempfile -d ./`
	kubectl create -n prom deployment prom-idle-pod --image alpine --dry-run=client -o yaml > $TEMPFILE
	yq -i '.spec.template.spec.serviceAccountName = "prom-kube-state-metrics"' $TEMPFILE
	yq -i '.spec.template.spec.containers[].command = ["sleep", "1000000000"]' $TEMPFILE
	kubectl apply -f $TEMPFILE
	rm $TEMPFILE
else
	echo "Extract SA credential..."
	POD_NAME=`kubectl get pod -n prom | grep prom-idle | grep Running | cut -f 1 -d ' '`
	kubectl exec -it -n prom $POD_NAME -- sh -c 'cd /var/run/secrets/kubernetes.io/serviceaccount/..data && tar cf /home/sa.tgz *'
	kubectl cp -n prom $POD_NAME:/home/ .
fi
