#!/bin/sh

REQUIRED_PACKAGES="git ansible bash-completion docker-ce python3-pip"
REQUIRED_COLLECTIONS="community.general community.docker ansible.posix"


yum -y install ${REQUIRED_PACKAGES}

ansible-galaxy collection install ${REQUIRED_COLLECTIONS}

