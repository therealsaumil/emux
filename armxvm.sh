#!/bin/sh

rsync -av README.TXT \
          LICENSE.TXT \
          dtb \
          hostfs \
          run \
          template \
          devices \
          qemuopts \
          root@10.0.1.250:/armx/

