#!/usr/bin/env bash

set -euo pipefail

##
# Save a tar file of an image and inject it into microk8s image cache.
# Docs: https://microk8s.io/docs/registry-images

create_and_import_tar() {
  if [ $# -ne 1 ]; then
    echo 1>&2 "Usage: inject_images [name]"
    exit 1
  fi

  local name=${1}

  # Save an image as a .tar file.
  docker save "${name}" > "${name}.tar"

  # Inject tar file of image into microk8s' image cache.
  microk8s ctr image import "${name}.tar"
}

create_and_import_tar demo
