#!/bin/bash
inputfile=/home/ubuntu/vars.sh
storageclassFile=/home/ubuntu/storageClass.yaml

createPassword()
{
  sleep 1
  echo "$(date +%s%N | openssl sha256 | awk '{print $2}' | head -c 12)$[ 1000 + $[ RANDOM % 9999 ]]"
}

echo "Starting Bootstrap"
sleep 30
ls $inputfile
source $inputfile
echo "Creating Kubernetes cluster using KOPS"
kops create cluster $CLIENT.devops \
--node-count $node_count \
--zones $ZONES \
--node-size $node_size \
--master-size $master_size \
--master-zones $ZONES \
--networking calico \
--api-loadbalancer-type $api_loadbalancer_type \
--topology $topology \
--dns-zone $dns_zone \
--dns $dns \
--vpc $VPC \
--bastion=false \
--yes

i=100
valid=$(kops validate cluster | grep ready | wc -l )
until [ $valid -gt 0 ]
do
  sleep $i
  echo "Still Starting cluster"
  valid=$(kops validate cluster | grep ready | wc -l )
  i=`expr $i - 10`
done

source $inputfile
INITIAL_ADMIN_PASSWORD=$(createPassword)
INITIAL_ADMIN_PASSWORD_BASE64=`echo -n $INITIAL_ADMIN_PASSWORD | base64`
JENKINS_PASSWORD=$(createPassword)
JENKINS_PASSWORD_BASE64=`echo -n $JENKINS_PASSWORD | base64`
GERRIT_PASSWORD=$(createPassword)
GERRIT_PASSWORD_BASE64=`echo -n $GERRIT_PASSWORD | base64`
LDAP_PASSWORD=$(createPassword)
LDAP_PASSWORD_BASE64=`echo -n $LDAP_PASSWORD | base64`
SQL_PASSWORD=$(createPassword)
SQL_PASSWORD_BASE64=`echo -n $SQL_PASSWORD | base64`
CLIENT=$CLIENT

cat > output <<EOF
INITIAL_ADMIN_USER=$INITIAL_ADMIN_USER
INITIAL_ADMIN_PASSWORD=$INITIAL_ADMIN_PASSWORD
INITIAL_ADMIN_PASSWORD_BASE64=$INITIAL_ADMIN_PASSWORD_BASE64
JENKINS_PASSWORD=$JENKINS_PASSWORD
JENKINS_PASSWORD_BASE64=$JENKINS_PASSWORD_BASE64
GERRIT_PASSWORD=$GERRIT_PASSWORD
GERRIT_PASSWORD_BASE64=$GERRIT_PASSWORD_BASE64
LDAP_PASSWORD=$LDAP_PASSWORD
LDAP_PASSWORD_BASE64=$LDAP_PASSWORD_BASE64
SQL_PASSWORD=$SQL_PASSWORD
SQL_PASSWORD_BASE64=$SQL_PASSWORD_BASE64
LDAP_MANAGER_PASSWORD=$LDAP_PASSWORD
SLAPD_PASSWORD=$LDAP_PASSWORD
SLAPD_PASSWORD_BASE64=$LDAP_PASSWORD_BASE64
CLIENT=$CLIENT
EOF

echo "Create Ethan Namespace "
kubectl create ns ethan
echo "Change Default ns to Ethan"
kubectl config set-context $(kubectl config current-context) --namespace=ethan

n=$(kubectl get cm | grep pass | wc -l)

if [[ $n -gt 0 ]]
then
  echo "Configmap is already present"
else
  echo "Creating Configmap"
  kubectl create configmap pass --from-file output
  kubectl create configmap dashing-config --from-file /home/ubuntu/.kube/config
fi

echo "Creating Storage Class"
sed -i "s|###ZONE###|$ZONES|g" $storageclassFile
kubectl create -f $storageclassFile
echo "Storage Class is created"
echo "Bootstrap is Completed"
