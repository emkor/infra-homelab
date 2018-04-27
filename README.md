# Installing OpenStack with Packstack (home cloud PoC)
## WARNING: WORK IN PROGRESS
This is an example of installing OpenStack using Packstack on local machine so OpenStack VMs are reachable from my LAN (homelab purposes)

Part of instructions are from [rdoproject](https://www.rdoproject.org/install/packstack/)

### Prerequisites
- capable piece of hardware (my setup is on HP Z600 workstation, dual CPU, 48 gigs of memory)
- CentOS 7 Minimal install
- Specific network setup, so it's possible to use few IP addresses for your OpenStack VMs

### Network setup
Network setup should have some spare addresses for OpenStack instances outside of DHCP range; below is example of my setup:
- my local network is 192.168.192.0/23 (192.168.192.1 - 192.168.193.254 IP address range)
- DHCP on my router assigns IPs from range 192.168.192.100 - 192.168.192.200
- HP Z600 has single NIC with address 192.168.192.250
- OpenStack uses 192.168.193.1-192.168.193.254 address range as Floating IPs; those are "public IPs" for VMs, reachable from my local network
- OpenStack uses 172.16.0.0/16 network range as its internal network; those IPs are not reachable from my LAN

### Usage:
- ssh to your machine
- make sure you're root
- `yum install git`
- `git clone https://github.com/emkor/openstack-on-hp-z600.git`
- `cd openstack-on-hp-z600`
- `chmod u+x ./*.sh`
- `./pre_install.sh`
- reboot the machine now, ssh to it again, enter the code dir with `cd openstack-on-hp-z600`
- `./install.sh`
- be patient!
- `./post_install.sh`
- optionally, do `./create_base_images.sh`
