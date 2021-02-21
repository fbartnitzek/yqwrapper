#!/bin/bash

FAILED=0
function check() {
  if [[ "$1" != "$2" ]];then
    echo "$3 test failed ($1 != $2)"
    let "FAILED=FAILED+1"
  fi
}

function test_read() {
  echo 'hello: world' > a.yaml
  result=$(./yqwrapper.sh read a.yaml 'hello')
  check "world" "$result" read
}

function test_write() {
  :> a.yaml
  ./yqwrapper.sh write a.yaml 'hello2' 'world2'
  result=$(cat a.yaml)
  check 'hello2: world2' "$result" write
}

function test_merge() {
  echo 'hello: world'> a.yaml
  :> b.yaml
  ./yqwrapper.sh merge a.yaml b.yaml
  result=$(cat b.yaml)
  check 'hello: world' "$result" merge
}

function test() {
  FAILED=0
  test_read
  test_write
  test_merge

  if [[ $FAILED -ne 0 ]]; then
    echo "$FAILED tests failed"
  else
    echo "all tests passed"
  fi
}

for v in bins/yq-*; do
  echo "# tests for $v"
  export YQ_BIN=$v
  test
done