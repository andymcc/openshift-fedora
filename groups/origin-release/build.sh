#!/bin/bash
#pull repo in /tmp
rm -rf /tmp/origin-release
rm -rf /tmp/openshift
docker volume prune -f
source repo.txt
export arch=$(uname -m)
#build golang 1.10
git clone $REPO /tmp/origin-release
#build 1.10 for most of origin
cp -f golang-1.10/Dockerfile /tmp/origin-release/projects/origin-release/golang-1.10/Dockerfile.fedora
pushd /tmp/origin-release/projects/origin-release/golang-1.10/
docker build . -f Dockerfile.fedora  -t docker.io/jeffdyoung/f28-origin-release:golang-1.10-$arch

popd
#build 1.9 for 3.10 web-console 
cp -f golang-1.9/Dockerfile /tmp/origin-release/projects/origin-release/golang-1.9/Dockerfile.fedora
pushd /tmp/origin-release/projects/origin-release/golang-1.9/
docker build . -f Dockerfile.fedora  -t docker.io/jeffdyoung/f28-origin-release:golang-1.9-$arch
