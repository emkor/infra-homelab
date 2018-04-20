# Installing OpenStack with Packstack (home cloud PoC)
This is an example of installing OpenStack using Packstack on local machine within your LAN (homelab purposes)

### Prerequisites
- capable piece of hardware (my setup is on HP Z600 workstation)
- CentOS 7
- Specific network setup, so it's possible to use few IP addresses for your OpenStack VMs

### Usage:
- ssh to your machine
- make sure you're root or user with sudo
- `yum install git`
- `git clone https://github.com/emkor/openstack-on-hp-z600.git`
- `cd openstack-on-hp-z600`
- `chmod u+x ./main.sh`
- `./main.sh`
- be patient!