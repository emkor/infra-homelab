## Configure your local machine to use local-cloud registry
- add `docker-registry.cloud.local` to your `/etc/hosts`
    - command: `echo "192.168.193.1 docker-registry.cloud.local" | sudo tee -a /etc/hosts`
- add `ca.crt` (self-signed certificate) to docker:
    - `sudo mkdir -p "/etc/docker/certs.d/docker-registry.cloud.local"`
    - `sudo cp ca.crt "/etc/docker/certs.d/docker-registry.cloud.local/"`
- make sure to include the cache as local mirror:
    - `sudo cp daemon.json /etc/docker/daemon.json`
- restart docker:
    - `sudo systemctl restart docker`