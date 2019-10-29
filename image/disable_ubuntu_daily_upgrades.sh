#!/usr/bin/env bash

set -e

echo "Disabling apt-daily-upgrade.service"
sudo systemctl mask apt-daily.service apt-daily-upgrade.service
sudo systemctl stop apt-daily.service
sudo systemctl kill --kill-who=all apt-daily.service

# wait until `apt-get updated` has been killed
while ! (sudo systemctl list-units --all apt-daily.service | fgrep -q dead)
do
  sleep 1;
done

echo "Done"
history -c
