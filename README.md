# installing OpenStack with Packstack (home cloud PoC)
This is an example of installing OpenStack using Packstack on local machine so OpenStack VMs are reachable from my LAN (homelab purposes)

Part of instructions are from [RDO Project](https://www.rdoproject.org/install/packstack/)

### prerequisites
- capable piece of hardware (citing RDO Project: Machine with at least 16GB RAM, processors with hardware virtualization extensions, and at least one network adapter.)
- up-to-date CentOS 7 Minimal install
- Specific network setup described below (you can adjust installation to your LAN by modifying the installation scripts)

### Network setup
- my physical LAN is 192.168.192.0/23, so:
    - 192.168.**192**.1 - first IP address in LAN (192.168.**192**.0/24 range is for physical hardware)
    - 192.168.**193**.254 - last IP address in LAN (192.168.**193**.0/24 range will be for VMs)
- my physical router LAN IP is: 192.168.192.254 and acts as a gateway to the Internet and DHCP server
- DHCP on my physical router assigns IPs from range 192.168.192.100 - 192.168.192.200
- HP Z600 has single NIC with static IP address: 192.168.192.250
    - in my case, the Z600 itself is configured to use DHCP
    - but my router has a MAC-to-IP binding, so effectively Z600 always gets same IP
    - OpenStack is fine with that :)

### usage:
- ssh to your machine
- make sure you're root
- `yum install git`
- `git clone https://github.com/emkor/openstack-on-hp-z600.git`
- `cd openstack-on-hp-z600`
- `chmod u+x ./*.sh`
- execute `./pre_install.sh` to:
    - disable SELinux
    - replace NetworkManager with network service
    - disable firewalld
    - install basic OS dependencies and tools (nano, vim, htop etc)
- `reboot` the machine now, ssh to it again, enter the code dir with `cd openstack-on-hp-z600`
- execute `./install.sh` to:
    - install OpenStack Stein using Packstack and answers/config file: `packstack-answers.txt` with basic services:
        - Keystone for user authentication
        - Neutron for networking
        - Nova for VM instances
        - Glance for VM images
        - Cinder for Volumes
        - Swift for Object Storage
        - Horizon for Web Admin panel
        - Heat for orchestration
    - be patient, as it may take up to hour
    - first login: you can access just-installed OpenStack with `admin` user and `szamanszaman` password
    - there's not much to see now, though
- execute `./post_install.sh` to:
    - create `development` project with user `guest` and password `guest`
    - creates network in such a way that you'll be able to `ssh` into instances from your home LAN
    - creates basic Keypair (basically SSH key) for user `guest` so you're able to ssh into instances using public key `guest.pem` (under `~/.ssh`)
    - creates basic Security Group (basically firewall) with all traffic allowed (ICMP+UDP+TCP ingress+egress)
    - re-arranges Instance Flavors (basically pre-defined Instance sizes) so they fit host resources
- optionally, do `image/create_base_images.sh`
    - downloads and creates images for Centos 7, CoreOS, Debian 9 and Ubuntu 18.04 LTS and Ubuntu 19.04
- optionally, create basic images with specific SDKs (Python, Java, Docker etc.) for Ubuntu 18.04 LTS using dirs under `image/`

### what you'll end up with
- OpenStack instance installed at 192.168.192.250 (SSH-able as root and HTTP-able as either `admin` or `guest`)
- OpenStack will have following services: Keystone, Neutron, Nova, Glance, Cinder, Horizon, Heat
- OpenStack uses 192.168.193.1-192.168.193.254 address range as Floating IPs; those are "public IPs" for VMs, reachable from your LAN
- OpenStack uses 172.16.0.0/16 network range as its internal network; those IPs are not reachable from your LAN