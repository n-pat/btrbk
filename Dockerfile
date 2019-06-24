ARG ARCH
# TODO: alpine:latest has broken btrfs-progs. Need 4.17-r1; 4.19-1r0 or 5.x is broken.
FROM $ARCH/alpine:3.8

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
