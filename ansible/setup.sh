#!/bin/sh

yum -y install epel-release

REQUIRED_PACKAGES="git ansible bash-completion python3-pip"
REQUIRED_COLLECTIONS="community.general community.docker ansible.posix"


yum -y install ${REQUIRED_PACKAGES}

ansible-galaxy collection install ${REQUIRED_COLLECTIONS}

