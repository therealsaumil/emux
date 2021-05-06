#!/bin/sh

OWNERNAME="therealsaumil"
IMAGENAME="armx"
TAGNAME="04-2021"

docker build -t $OWNERNAME/$IMAGENAME:$TAGNAME -f Dockerfile .

