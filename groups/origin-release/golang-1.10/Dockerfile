#
# This is the image that controls the standard build environment for releasing OpenShift Origin.
# It is responsible for performing a cross platform build of OpenShift.
#
# The standard name for this image is openshift/fedora-origin-release
#
# Valid values for ARCH (used to download gorpm): amd64, ppc64le, s390x, arm64
# to build with another arch:
# $docker build . -f Dockerfile -t fedora-origin-release:golang-1.10

FROM fedora:28
ENV VERSION=1.10.3 \
    GOCACHE=/go/.cache \
    GOARM=5 \
    GOPATH=/go \
    GOROOT=/usr/local/go
ENV PATH=$PATH:$GOROOT/bin:$GOPATH/bin
#needed for goversioninfo
COPY cbs-paas7-openshift-multiarch-el7-build.repo /etc/yum.repos.d/
#remove sysvinit-tools?
RUN dnf -y update
RUN INSTALL_PKGS="bc bind-utils bsdtar ceph-common createrepo device-mapper device-mapper-persistent-data e2fsprogs ethtool file findutils gcc git glibc-static glib2-devel gpgme gpgme-devel hostname iptables jq krb5-devel libassuan libassuan-devel libseccomp-devel libvirt-devel lsof make mercurial nmap-ncat openssl protobuf-compiler rsync socat tar tito tree util-linux wget which xfsprogs zip goversioninfo" && \
    dnf install -y $INSTALL_PKGS && \
#    rpm -V $INSTALL_PKGS && \
    dnf clean all && \
    touch /os-build-image && \
    git config --system user.name origin-release-container && \
    git config --system user.email origin-release@redhat.com


ADD golang-v1.10.0-1.fc25.noarch.rpm /tmp/origin-rpm/
RUN dnf install -y /tmp/origin-rpm/*.rpm && \
    dnf clean all 
#Download go for amd64 unless other archs are detected
RUN case "$(uname -m)" in \
        ppc64le) GOARCH='ppc64le';; \
        aarch64) GOARCH='arm64';; \
        s390x) GOARCH='s390x';; \
        *) GOARCH='amd64';; \
    esac; \
    curl https://storage.googleapis.com/golang/go$VERSION.linux-$GOARCH.tar.gz | tar -C /usr/local -xzf -; \
    go version

RUN go get golang.org/x/tools/cmd/cover \
        golang.org/x/tools/cmd/goimports \
        github.com/tools/godep \
        golang.org/x/lint/golint \
        github.com/openshift/imagebuilder/cmd/imagebuilder \
        k8s.io/test-infra/prow/cmd/clonerefs && \
    mv $GOPATH/bin/* /usr/bin/ && \
    rm -rf $GOPATH/* $GOPATH/.cache && \
    mkdir $GOPATH/bin && \
    ln -s /usr/bin/imagebuilder $GOPATH/bin/imagebuilder && \
    ln -s /usr/bin/goimports $GOPATH/bin/goimports
    # TODO: symlink for backwards compatibility with hack/build-images.sh only, remove

RUN chmod g+xw -R $GOPATH && \
    chmod g+xw -R $(go env GOROOT)

CMD ["/bin/bash"]

WORKDIR /go/src/github.com/openshift/origin
LABEL io.k8s.display-name="OpenShift Origin Release Environment (golang-$VERSION) (Fedora 28)" \
      architecture=$ARCH \
      io.k8s.description="This is the standard release image for OpenShift Origin and contains the necessary build tools to build the platform."
