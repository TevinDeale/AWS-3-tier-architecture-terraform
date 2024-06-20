#! bin/bash
hostnamectl set-hostname ${name}
apt update -y
apt upgrade -y