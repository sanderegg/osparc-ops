#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Paths
this_script_dir=$(dirname "$0")
repo_basedir=$(realpath ${this_script_dir}/../)
scripts_dir=$(realpath ${repo_basedir}/scripts)

# VCS info on current repo
current_git_url=$(git config --get remote.origin.url)
current_git_branch=$(git branch | grep \* | cut -d ' ' -f2)


# Loads configurations variables
# See https://askubuntu.com/questions/743493/best-way-to-read-a-config-file-in-bash
source ${repo_basedir}/repo.config
source ${repo_basedir}/services/portainer/.env

# create certificates
# install certificates
# restart docker service

# start portainer
pushd ${repo_basedir}/services/portainer
make up
popd

# start traefik with self-signed certificates
pushd ${repo_basedir}/services/traefik
make create-certificates up
popd

pushd ${repo_basedir}/services/minio
make up
popd

pushd ${repo_basedir}/services/portus
cp ${repo_basedir}/services/traefik/secrets/rootca.crt ${repo_basedir}/services/portus/secrets/rootca.crt
cp ${repo_basedir}/services/traefik/secrets/domain.crt ${repo_basedir}/services/portus/secrets/portus.crt
cp ${repo_basedir}/services/traefik/secrets/domain.key ${repo_basedir}/services/portus/secrets/portus.key
make up
popd

pushd ${repo_basedir}/services/monitoring
make up
popd