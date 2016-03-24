#!/bin/bash

for i in `seq 10 22`; do
  ./upload.sh -m 01 -d $i -f mkv
done
