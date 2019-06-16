# btrbk

WORK IN PROGRESS

## Version 0.1

Multi-arch docker container for btrbk based on alpine

## Architectures

(Template taken from: https://github.com/docker-library/official-images#architectures-other-than-amd64)

* Architectures officially supported by Docker, Inc. for running Docker: (see download.docker.com)
	* ARMv7 32-bit (arm32v7): https://hub.docker.com/u/arm32v7/
	* ARMv8 64-bit (arm64v8): https://hub.docker.com/u/arm64v8/
	* Linux x86-64 (amd64): https://hub.docker.com/u/amd64/
* Other architectures built by official images: (but not officially supported by Docker, Inc.)
	* ARMv5 32-bit (arm32v5): https://hub.docker.com/u/arm32v5/

## Todo: Automated builds

* Generate Dockerfiles.<amd64|arm32v6|...> so that build files exist to build the images on cross-architecture servers or on dockerhub.
