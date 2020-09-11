#!/bin/sh

rsync -vrlptD README.TXT \
              LICENSE.TXT \
              dtb \
              hostfs \
              run \
              template \
              devices \
              qemuopts \
              armx@10.0.1.250:/armx/
