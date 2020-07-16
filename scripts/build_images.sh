#!/usr/bin/env bash

set -euo pipefail

#
# Build docker image of name:version specified in the infrastructure/docker
# directory.
#
build_image() {
  if [ $# -ne 2 ]; then
    echo 1>&2 "Usage: build_image [name] [version]"
    exit 1
  fi

  local name=${1}
  local version=${2}

  echo "Building ${name}:${version}"

  DOCKER_BUILDKIT=1 docker build \
    --tag "${name}:${version}" \
    --build-arg CACHE_REFRESH="$(date +%s)" \
    --file "docker/${name}.dockerfile" \
    --ssh default .
}

build_image hello dev
