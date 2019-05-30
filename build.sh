#!/bin/sh

set -ex

VERSION="${1:-latest}"
ARCHS="${2:-arm32v6}" # 'amd64 arm32v6 arm32v7 arm32v8'
PRODUCT_NAME="n-pat/btrbk"

# parameter: "platform-architecture"
build_and_push_images() {
  arch=$1

  docker build -t "$PRODUCT_NAME:alpine-$arch-$VERSION" - <<-EOF
		FROM $arch/alpine:latest

		RUN apk --update upgrade \
			&& apk --no-cache --no-progress add \
				btrbk \
				tzdata \
			&& rm -rf /var/cache/apk/*

		ENV TZ Europe/Berlin

		ENTRYPOINT ["btrbk"]
		CMD ["dryrun"]
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
  #docker rmi $(docker images -q -f dangling=true)
}

build_all $ARCHS
exit 0
