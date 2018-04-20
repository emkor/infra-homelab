# Example: Installing OpenStack with Packstack within, local existing network (homelab purposes, HP Z600)

### Prerequisites
- CentOS 7
- Specific network setup, so it's possible to use few IP addresses for your OpenStack VMs

### Usage:
- ssh to your machine
- make sure you're root or user with sudo
- `yum install git`
- `git clone <THIS REPO URL>`
- `cd openstack-on-hp-z600`
- `chmod u+x ./main.sh`
- `./main.sh`
- be patient!