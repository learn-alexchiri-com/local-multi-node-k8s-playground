cp -f ~/.ssh/id_rsa* .
multipass delete control
multipass purge
multipass launch --cloud-init control-cloud-config.yaml --name control
multipass transfer id_rsa control:/home/ubuntu/.ssh/id_rsa
multipass transfer id_rsa.pub control:/home/ubuntu/.ssh/id_rsa.pub
rm -f id_rsa*
echo `Control IP: $(multipass info control --format json | jq -r .info.control.ipv4[0])`