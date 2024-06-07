#! bin/bash
      hostnamectl set-hostname rb-sas-use-1a
      yum update -y
      curl -fsSL https://tailscale.com/install.sh | sh
      tailscale up --auth-key ${tailscale_key} --ssh