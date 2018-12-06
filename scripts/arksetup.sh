#!/bin/bash
inputfile=/home/ubuntu/vars.sh
Backupstoragefile=/home/ubuntu/heptio-ark/ark-backupstoragelocation.yaml
Volumesnapshotlocation=/home/ubuntu/heptio-ark/ark-volumesnapshotlocation.yaml
ls $inputfile
source $inputfile


git clone https://github.com/projectethan007/heptio-ark.git
echo "cloned heptio-ark repository"

cp /home/ubuntu/.aws/credentials /home/ubuntu/heptio-ark/credentials-ark 

cd /home/ubuntu/heptio-ark
kubectl apply -f ark-prereqs.yaml
echo "prerequisites created"
sleep 5

kubectl create secret generic cloud-credentials --namespace heptio-ark --from-file cloud=credentials-ark
echo "secret cloud-crredentials created"
sleep 5

echo "creating backup storagelocation"
sed -i "s|###ZONES###|$ZONES|g" $Backupstoragefile
sed -i "s|###CLIENT###|$CLIENT|g" $Backupstoragefile
kubectl apply -f ark-volumesnapshotlocation.yaml

echo "creating volume snapshot location"
sed -i "s|###ZONES###|$ZONES|g" $Volumesnapshotlocation
kubectl apply -f ark-backupstoragelocation.yaml

echo "creating deployment"
kubectl apply -f ark-deployment.yaml
echo "ark deployment created"
sleep 5

echo "Heptio-Ark setup completed"
