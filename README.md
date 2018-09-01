# Installing OpenStack with Packstack (home cloud PoC)
This is an example of installing OpenStack using Packstack on local machine so OpenStack VMs are reachable from my LAN (homelab purposes)

Part of instructions are from [rdoproject](https://www.rdoproject.org/install/packstack/)

### Prerequisites
- capable piece of hardware (my setup is on HP Z600 workstation, dual CPU, 48 gigs of memory)
- CentOS 7 Minimal install
- Specific network setup, so it's possible to use few IP addresses for your OpenStack VMs

### Network setup
Network setup should have some spare addresses for OpenStack instances outside of DHCP range; below is example of my setup:
- my local network is 192.168.192.0/23 (192.168.192.1 - 192.168.193.254 IP address range)
- my physical router is at 192.168.192.254 and acts as a gateway
- DHCP on my router assigns IPs from range 192.168.192.100 - 192.168.192.200
- HP Z600 has single NIC with address 192.168.192.250 (the Z600 itself is configured to use DHCP, but my router has a MAC-to-IP binding, so effectively Z600 always gets same IP)


### Usage:
- ssh to your machine
- make sure you're root
- `yum install git`
- `git clone https://github.com/emkor/openstack-on-hp-z600.git`
- `cd openstack-on-hp-z600`
- `chmod u+x ./*.sh`
- `./pre_install.sh`
    - disables SELinux
    - replaces NetworkManager with network service
    - disables firewalld
    - installs base OS dependencies (nano, vim, htop etc)
- reboot the machine now, ssh to it again, enter the code dir with `cd openstack-on-hp-z600`
- `./install.sh`
    - installs raw OpenStack Queens with basic services using Packstack
- be patient!
- `./post_install.sh`
    - creates "development" project
    - create user guest / guest
    - creates network
    - creates basic security group for web development
    - creates basic keypair for instance access
    - re-arranges instance Flavors
- optionally, do `./create_base_images.sh`
    - downloads and creates images for Debians 8 and 9, Centos 7, CoreOS, Ubuntus 16.04 and 17.10

### What you'll end up with
- OpenStack instance installed at 192.168.192.250 (SSH-able as root and HTTP-able as either admin or guest)
- OpenStack will have following services: Keystone, Horizon, Neutron, Nova, Glance, Cinder, Heat, Magnum
- OpenStack uses 192.168.193.1-192.168.193.254 address range as Floating IPs; those are "public IPs" for VMs, reachable from local network
- OpenStack uses 172.16.0.0/16 network range as its internal network; those IPs are not reachable from my LAN