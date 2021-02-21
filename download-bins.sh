#!/bin/bash

if [[ ! -d bins ]]; then
  mkdir bins
fi
for v in v4.6.0 v4.5.0 v4.4.1 3.4.1 3.3.1; do
  echo $v
  wget https://github.com/mikefarah/yq/releases/download/${v}/yq_linux_amd64 \
  -O bins/yq-$v
done
chmod +x bins/yq-*
