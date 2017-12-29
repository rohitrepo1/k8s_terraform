inputfile=/home/ubunutu/vars.sh

createPassword()
{
  sleep 1
  echo "$(date +%s%N | openssl sha256 | awk '{print $2}' | head -c 12)$[ 1000 + $[ RANDOM % 9999 ]]"
}

source $inputfile
echo "Creating Kubernetes cluster using KOPS"
kops create cluster
  --name $CLIENT.devops \
  --node-count $node_count \
  --zones $ZONES \
  --node-size $NODE_SIZE \
  --master-size $MASTER_SIZE \
  --master-zones $ZONES \
  --networking calico \
  --api-loadbalancer-type $api_loadbalancer_type \
  --topology $topology \
  --dns-zone $dns_zone \
  --dns $dns \
  --vpc $VPC \

valid=$(kops validate cluster | grep ready | wc -l )
until [ $valid -gt 0 ]
do
  sleep 20
  echo "Still Creating cluster"
  valid=$(kops validate cluster | grep ready | wc -l )
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
EOF

n=$(kubectl get cm | grep pass | wc -l)

if [[ $n -gt 0 ]]
then
  echo "Configmap is already present"
else
  echo "Creating Configmap"
  kubectl create configmap pass --from-file output
  kubectl create configmap dashing-config --from-file /home/ubuntu/.kube/config
fi
