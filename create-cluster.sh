multipass delete --purge control
multipass delete --purge master
multipass delete --purge node1
multipass delete --purge node2
multipass launch --cloud-init control-cloud-config.yaml --name control
echo "Control IP: $(multipass info control --format json | jq -r .info.control.ipv4[0])"

multipass transfer control:/home/ubuntu/.ssh/id_rsa.pub ./id_rsa.pub
PUBLIC_KEY="$(cat ./id_rsa.pub)"
sed "s#{PUBLIC_KEY}#$PUBLIC_KEY#" node-cloud-config.yaml | multipass launch --name master --cloud-init -
sed "s#{PUBLIC_KEY}#$PUBLIC_KEY#" node-cloud-config.yaml | multipass launch --name node1 --cloud-init -
sed "s#{PUBLIC_KEY}#$PUBLIC_KEY#" node-cloud-config.yaml | multipass launch --name node2 --cloud-init -

MASTER_IP="$(multipass info master --format json | jq -r .info.master.ipv4[0])"
multipass exec control -- k3sup install --ip $MASTER_IP --user ubuntu --local-path ~/.kube/config
NODE1_IP="$(multipass info node1 --format json | jq -r .info.node1.ipv4[0])"
multipass exec control -- k3sup join --ip $NODE1_IP --server-ip $MASTER_IP --user ubuntu
NODE2_IP="$(multipass info node2 --format json | jq -r .info.node2.ipv4[0])"
multipass exec control -- k3sup join --ip $NODE2_IP --server-ip $MASTER_IP --user ubuntu