#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

export PLATFORM=$1
export ISA=$2
export VERSION=$3
export EVENT=$4

case $PLATFORM in
    el*|fc*|amzn*)
        export PKGFMT=rpm
        ;;
    *)
        export PKGFMT=deb
esac

# OSX
# x86_64-apple-darwin
# aarch64-apple-darwin

# Windows
# x86_64-pc-windows-msvc
# i686-pc-windows-msvc
# aarch64-pc-windows-msvc

# Linux
# i686-unknown-linux-gnu
# x86_64-unknown-linux-gnu
# arm-unknown-linux-gnueabi       ?
# arm-unknown-linux-gnueabihf     ?
# armv7-unknown-linux-gnueabihf
# 

case $ISA in
    armv5)
        export DOCKER_ARCH=arm/v5
        export LLVM_ARCH=arm
        ;;
    armv7)
        export DOCKER_ARCH=arm/v7
        ;;
    arm64)
        export DOCKER_ARCH=arm64/v8
        ;;
    *)
        export DOCKER_ARCH=$ISA
        ;;
esac

if [ -f "ci/Dockerfile.${PLATFORM}" ]; then
    export DOCKERFILE="ci/Dockerfile.${PLATFORM}"
else
    export DOCKERFILE="ci/Dockerfile.${PKGFMT}"
fi

echo "#~~~~~~~~~~~~~~~~~~~~"
echo "$0 variables:"
echo "nproc: $(nproc)"
echo "ISA: ${ISA}"
echo "VERSION: ${VERSION}"
echo "EVENT: ${EVENT}"
echo "PKGFMT: ${PKGFMT}"
echo "PWD: ${PWD}"
echo "DOCKERFILE: ${DOCKERFILE}"
echo "#~~~~~~~~~~~~~~~~~~~~"

if [ ${EVENT} == "push" ]; then
make munge_rpm zerotier-one.spec VERSION=${VERSION}
make munge_deb debian/changelog VERSION=${VERSION}
fi

export DOCKER_BUILDKIT=1
docker run --privileged --rm tonistiigi/binfmt --install all

docker pull --platform linux/${DOCKER_ARCH} registry.sean.farm/${PLATFORM}-builder

docker buildx build \
       --build-arg PLATFORM="${PLATFORM}" \
       --platform linux/${DOCKER_ARCH} \
       -f ${DOCKERFILE} \
       --target export \
       -t build \
       . \
       --output .
