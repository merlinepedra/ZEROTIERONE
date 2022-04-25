#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

export PLATFORM=$1
export ISA=$2
export VERSION=$3

case $ISA in
    armv5)
        export ARCH=arm/v5
        ;;
    armv7)
        export ARCH=arm/v7
        ;;
    arm64)
        export ARCH=arm64/v8
        ;;
    *)
        export ARCH=$ISA
        ;;
esac

echo "#~~~~~~~~~~~~~~~~~~~~"
echo "$0 variables:"
echo "nproc: $(nproc)"
echo "ISA: ${ISA}"
echo "VERSION: ${VERSION}"
echo "PWD: ${PWD}"
echo "#~~~~~~~~~~~~~~~~~~~~"

export DOCKER_BUILDKIT=1
docker run --privileged --rm tonistiigi/binfmt --install all
docker run --pull always --rm --platform linux/${ARCH} registry.sean.farm/${PLATFORM}-tester /bin/sh -c "curl -s -L https://bytey.sean.farm | /bin/sh -e -s -- ${VERSION}"
