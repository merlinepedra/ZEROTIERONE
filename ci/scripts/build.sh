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
echo "EVENT: ${EVENT}"
echo "PKGFMT: ${PKGFMT}"
echo "PWD: ${PWD}"
echo "#~~~~~~~~~~~~~~~~~~~~"

if [ ${EVENT} == "push" ]; then
make munge_rpm zerotier-one.spec VERSION=${VERSION}
make munge_deb debian/changelog VERSION=${VERSION}
fi

export DOCKER_BUILDKIT=1
docker run --privileged --rm tonistiigi/binfmt --install all

docker pull --platform linux/${ARCH} registry.sean.farm/${PLATFORM}-builder

docker buildx build \
       --build-arg PLATFORM="${PLATFORM}" \
       --platform linux/${ARCH} \
       -f ci/Dockerfile.${PKGFMT} \
       --target export \
       -t build \
       . \
       --output .
