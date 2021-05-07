.\delete-cluster.ps1

multipass launch --cloud-init control-cloud-config.yaml --name control
multipass transfer control:/home/ubuntu/.ssh/id_rsa.pub .\id_rsa.pub

$PUBLIC_KEY = [IO.File]::ReadAllText(".\id_rsa.pub")
(Get-Content -path .\node-cloud-config.yaml -Raw) -replace '{PUBLIC_KEY}', $PUBLIC_KEY | multipass launch --name master --mem 3G --cpus 2 --cloud-init -
(Get-Content -path .\node-cloud-config.yaml -Raw) -replace '{PUBLIC_KEY}', $PUBLIC_KEY | multipass launch --name node1 --cloud-init -
(Get-Content -path .\node-cloud-config.yaml -Raw) -replace '{PUBLIC_KEY}', $PUBLIC_KEY | multipass launch --name node2 --cloud-init -

$MASTER_IP=(multipass info master --format json | jq -r .info.master.ipv4[0])
multipass exec control -- k3sup install --ip $MASTER_IP --user ubuntu --local-path /home/ubuntu/.kube/config --k3s-extra-args '--no-deploy traefik'
$NODE1_IP=(multipass info node1 --format json | jq -r .info.node1.ipv4[0])
multipass exec control -- k3sup join --ip $NODE1_IP --server-ip $MASTER_IP --user ubuntu
$NODE2_IP=(multipass info node2 --format json | jq -r .info.node2.ipv4[0])
multipass exec control -- k3sup join --ip $NODE2_IP --server-ip $MASTER_IP --user ubuntu
