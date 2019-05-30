#!/bin/sh

set -x
[ $# -eq 1 ] || exit 2

VERSION="$1"
product_name="n-pat/btrbk"

# parameter: "platform-architecture"
build_and_push_images() {
  arch=$1

  docker build -t "$product_name:alpine-$arch-$VERSION" - <<EOF -
		FROM $arch/alpine:latest

		#WORKDIR ["/"]

		#RUN apk --no-cache add btrbk
		RUN apk --update upgrade \
			&& apk --no-cache --no-progress add \
				btrbk \
				tzdata \
			&& rm -rf /var/cache/apk/*

		ENTRYPOINT ["btrbk"]
		CMD ["dryrun"]
		EOF

  for os in alpine; do
    docker tag  "$product_name:$os-$arch-$VERSION" "$product_name:$os-$arch"
    #docker push "$product_name:$os-$arch-$VERSION"
    #docker push "$product_name:$os-$arch"
  done
}

build_all() {
  for tag in $@; do
    build_and_push_images "$tag"
  done
  docker rmi $(docker images -q -f dangling=true)
}

#build_all 'amd64 arm32v6 arm32v7 arm32v8'
#build_all 'x86_64 arm32v7'
build_all 'amd64 arm32v7'
exit 0
