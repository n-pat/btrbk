#!/bin/sh

set -eux

VERSION="${1:-latest}"
ARCHS="${2:-amd64}" # 'amd64 arm32v6 arm32v7 arm32v8'
PRODUCT_NAME="npatde/btrbk"

# parameter: "platform-architecture"
build_and_push_images() {
  arch=$1

  # Currently alpine is the only OS supported. I thought about supporting ubuntu as well.
  for os in alpine; do
    docker build --build-arg ARCH=$arch -t "$PRODUCT_NAME:$os-$arch-$VERSION" .
    docker tag  "$PRODUCT_NAME:$os-$arch-$VERSION" "$PRODUCT_NAME:$os-$arch"
    #docker push "$PRODUCT_NAME:$os-$arch-$VERSION"
    #docker push "$PRODUCT_NAME:$os-$arch"
  done
}

build_all() {
  for arch in $@; do
    build_and_push_images "$arch"
  done

  # Multi-architecture build and push is not active yet. Therefore also the multi-arch manifest is not being pushed automatically.
  #docker manifest create npatde/btrbk:latest npatde/btrbk:alpine-arm32v6-latest npatde/btrbk:alpine-amd64-latest
  #docker manifest create 
  #  $PRODUCT_NAME:$VERSION
  #  $PRODUCT_NAME:alpine-arm32v6-$VERSION
  #  $PRODUCT_NAME:alpine-amd64-$VERSION
  
  #docker manifest push npatde/btrbk:latest
  
  #docker rmi $(docker images -q -f dangling=true)
}

build_all $ARCHS
exit 0
