#!/bin/bash

packer_common() {
  local packer_version
  packer_version=$(curl -sSL https://releases.hashicorp.com/packer/index.json | \
jq -r '.versions[].version' | sort -t. -k 1,1n -k 2,2n -k 3,3n -k 4,4n | \
grep -E -v 'alpha|beta|rc' | tail -1)

  local download_file="packer_${packer_version}_linux_amd64.zip"
  local download_url="https://releases.hashicorp.com/packer/${packer_version}/${download_file}"
  local prefix="/usr/bin"
  local download_dest="/tmp/${download_file}"

  if [[ -f "${prefix}/packer" ]]; then
    local packer_installed
    packer_installed=$("${prefix}"/packer -v | head -1)
  fi

  download_packer() {
    echo "Downloading ${download_file}..."
    curl -sSL "${download_url}" -o "${download_dest}"
    echo "Done."
    echo
  }

  install_packer() {
    rm -f ${prefix}/packer

    echo "Installing Packer ${packer_version}..."
    unzip "${download_dest}" -d /tmp >/dev/null 2>&1
    cp /tmp/packer $prefix

    rm -f /tmp/packer*

    # Remove symbolic links to cracklib-packer that makes
    # conflicts on CentOS
    rm -f /sbin/packer /usr/sbin/packer
    echo "Done."
    echo
  }

  if [[ "${packer_version}" != "${packer_installed}" ]]; then
    download_packer
    install_packer
  else
    echo "The latest Packer version $packer_installed is already installed."
    echo
  fi
}

debian_9_packer() {
  packer_common
}

debian_10_packer() {
  packer_common
}

ubuntu_16_packer() {
  packer_common
}

ubuntu_18_packer() {
  packer_common
}

centos_7_packer() {
  packer_common
}

centos_8_packer() {
  packer_common
}
