#
# This image adds the repository link for Origin
# RPMs to allow downstream images to install the
# components using `yum'.
#
# The standard name for this image is openshift/origin-source
#
FROM fedora:28
RUN dnf -y update &&\
    dnf clean all
COPY *.repo /etc/yum.repos.d/
