# Local multi-node K8s playground

Wouldn't be nice to be able to quickly create a multi-node Kubernetes cluster on your local computer (macOS, Linux or Windows) and play with it? That is the purpose of this little project.

Warning: this is very much a work-in-progress.

## Dependencies (you need to install them on your own)
- [multipass](https://multipass.run)
- [jq](https://stedolan.github.io/jq/)

## Get started

1. Install the dependencies above for your platform
2. Clone this repo
3. Run ./create-cluster.sh script (Powershell script coming soon!)

## STATUS

- [ ] Basic local multi-node cluster for playground with [multipass](https://multipass.run), [k3s](https://k3s.io) and [k3sup](https://github.com/alexellis/k3sup) - in progress