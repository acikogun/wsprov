#!/bin/bash

terraform_common() {
  local api_url="https://releases.hashicorp.com/terraform/index.json"

  local terraform_version
  terraform_version=$(curl -sL "${api_url}" | jq -r '.versions[].version' |\
  sort -t. -k 1,1n -k 2,2n -k 3,3n -k 4,4n | grep -E -v 'alpha|beta|rc' | tail -1)

  local download_file="terraform_${terraform_version}_linux_amd64.zip"
  local download_url="https://releases.hashicorp.com/terraform/${terraform_version}/${download_file}"
  local prefix="/usr/bin"
  local download_dest="/tmp/${download_file}"

  if [[ -f "${prefix}/terraform" ]]; then
    local terraform_installed
    terraform_installed=$("${prefix}"/terraform -v | head -1 | awk '{print $2}' | cut -c 2-)
  fi

  download_terraform() {
    echo "Downloading ${download_file}..."
    curl -sSL "${download_url}" -o "${download_dest}"
    echo "Done."
    echo
  }

  install_terraform() {
    rm -rf ${prefix}/terraform

    echo "Installing Terraform ${terraform_version}..."
    unzip "${download_dest}" -d /tmp >/dev/null 2>&1
    cp /tmp/terraform $prefix

    rm -rf /tmp/terraform*
    echo "Done."
    echo
  }

  if [[ "${terraform_version}" != "${terraform_installed}" ]]; then
    download_terraform
    install_terraform
  else
    echo "The latest Terraform version ${terraform_installed} is already installed."
    echo
  fi
}

debian_9_terraform() {
  terraform_common
}

debian_10_terraform() {
  terraform_common
}

ubuntu_16_terraform() {
  terraform_common
}

ubuntu_18_terraform() {
  terraform_common
}

centos_7_terraform() {
  terraform_common
}

centos_8_terraform() {
  terraform_common
}
