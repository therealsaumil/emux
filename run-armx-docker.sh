#!/bin/sh

OWNERNAME="therealsaumil"
IMAGENAME="armx"
TAGNAME="04-2021"

docker run -it \
	--rm \
	--cap-add=NET_ADMIN \
	--cap-add=SYS_ADMIN \
	--device=/dev/net/tun \
	--name armx-docker \
	--mount type=bind,source="$(pwd)"/files/armx,target=/armx \
	$OWNERNAME/$IMAGENAME:$TAGNAME $*
