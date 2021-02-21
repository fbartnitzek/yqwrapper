#!/bin/bash

function init_version() {
  YQ_VERSION=$($YQ_BIN --version 2>&1)
}

function read() {
  file=$1
  filter=$2
  if [[ $YQ_VERSION =~ 3\.[0-9]+\.[0-9]+  ]]; then
    $YQ_BIN r $file "$filter"
  else
    $YQ_BIN e ".$filter" $file
  fi
}

function write() {
  file=$1
  key=$2
  value=$3
  if [[ $YQ_VERSION =~ 3\.[0-9]+\.[0-9]+  ]]; then
    $YQ_BIN w -i $file "$key" "$value"
  else
    $YQ_BIN e -i ".$filter" $file
  fi
}

function merge() {
  src=$1
  target=$2

  if [[ $YQ_VERSION =~ 3\.[0-3][0-9]?\.[0-9]+  ]]; then
    $YQ_BIN m -i -a $target $src
  elif [[ $YQ_VERSION =~ 3\.[4-9][0-9]?\.[0-9]+  ]]; then
    $YQ_BIN m -i -a append $target $src
  elif [[ $YQ_VERSION =~ 4\.[6-9][0-9]?\.[0-9]+ ]]; then
    $YQ_BIN -i ea '. as $item ireduce ({}; . * $item )' $target $src
  fi
}

init_version
if [[ "$1" == "read" ]];then
  read ${@:2}
elif [[ "$1" == "write" ]];then
  write ${@:2}
elif [[ "$1" == "merge" ]];then
  merge ${@:2}
fi