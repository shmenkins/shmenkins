#!/usr/bin/env bash

set -eo pipefail

TERRAFORM_VERSION="0.7.10"

main() {
    check_root

    pip install cfgen awscli
    wget --timestamping --progress=bar:force:noscroll --directory-prefix="/usr/local/bin/" "https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/$TERRAFROM_ZIP"
    # -o tells unzip to overwrite existing files
    unzip -o "/usr/local/bin/$TERRAFROM_ZIP" -d "/usr/local/bin/"
    rm "/usr/local/bin/$TERRAFROM_ZIP"
}

install_terraform() {
    echo "Installing terraform ${TERRAFORM_VERSION}"
    local TERRAFROM_ZIP=terraform_${TERRAFORM_VERSION}_linux_amd64.zip
    wget --timestamping --progress=bar:force:noscroll --directory-prefix="/tmp" "https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/$TERRAFROM_ZIP"
    # -o tells unzip to overwrite existing files
    unzip -o "/tmp/$TERRAFROM_ZIP" -d "/usr/local/bin/"
    rm "/tmp/$TERRAFROM_ZIP"
}

check_root() {
    if [ "$(whoami)" != "root" ]; then
        echo "Must be root."
        exit 1
    fi
}

main

