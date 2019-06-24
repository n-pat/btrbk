#!/bin/sh

set -eux

VERSION="${1:-latest}"
ARCHS="${2:-amd64}" # 'amd64 arm32v6 arm32v7 arm32v8'
PRODUCT_NAME="npatde/btrbk"

# parameter: "platform-architecture"
build_and_push_images() {
  arch=$1

  docker build --build-arg ARCH=$arch -t "$PRODUCT_NAME:alpine-$arch-$VERSION" - <<-EOF
        ARG ARCH
		# TODO: alpine:latest has broken btrfs-progs. Need 4.17-r1; 4.19-1r0 or 5.x is broken.
		FROM \$ARCH/alpine:3.8	

		RUN apk --update upgrade \
			&& apk --no-cache --no-progress add \
				btrbk \
				pv \
				openssh-client \
				tzdata \
			&& rm -rf /var/cache/apk/*

		#VOLUME ["/etc/btrbk", "/var/lock", "/var/log"]

		# btrbk relies on timezone for snapshot names
		ENV TZ Europe/Berlin

		CMD ["/usr/bin/btrbk", "dryrun"]
	EOF

  for os in alpine; do
    docker tag  "$PRODUCT_NAME:$os-$arch-$VERSION" "$PRODUCT_NAME:$os-$arch"
    #docker push "$PRODUCT_NAME:$os-$arch-$VERSION"
    #docker push "$PRODUCT_NAME:$os-$arch"
  done
}

build_all() {
  for tag in $@; do
    build_and_push_images "$tag"
  done

  # docker manifest create npatde/btrbk:latest npatde/btrbk:alpine-arm32v6-latest npatde/btrbk:alpine-amd64-latest
  #docker manifest create 
  #  $PRODUCT_NAME:$VERSION
  #  $PRODUCT_NAME:alpine-arm32v6-$VERSION
  #  $PRODUCT_NAME:alpine-amd64-$VERSION
  
  #docker manifest push npatde/btrbk:latest
  
  #docker rmi $(docker images -q -f dangling=true)
}

build_all $ARCHS
exit 0
