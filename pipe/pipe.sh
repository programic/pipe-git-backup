#!/usr/bin/env bash

set -o errexit
set -o pipefail

# Include common.sh script
source "$(dirname "${0}")/common.sh"

: ${BACKUP_REPO?"You need to set the BACKUP_REPO environment variable."}
: ${BACKUP_BRANCH?"You need to set the BACKUP_BRANCH environment variable."}

git_config() {
  git config --global --add safe.directory '*'
  git remote add backup ${BACKUP_REPO}

  success "Config git and add remote backup repository"
}

git_backup() {
  git checkout --orphan backup
  success "Create backup branch without history"

  git add .
  git commit -m "Add files to backup"
  success "Commit files to backup branch"

  git push -f backup ${BACKUP_BRANCH}
  success "Push code to backup repository"
}

setup_ssh() {
  injected_ssh_config_dir="/opt/atlassian/pipelines/agent/ssh"
  identity_file="${injected_ssh_config_dir}/id_rsa_tmp"
  known_hosts_file="${injected_ssh_config_dir}/known_hosts"

  if [[ ! -f ${identity_file} ]]; then
    fail "No default SSH key configured in Pipelines"
  fi

  if [[ ! -f ${known_hosts_file} ]]; then
    fail "No SSH known_hosts configured in Pipelines"
  fi

  mkdir -p ~/.ssh
  touch ~/.ssh/authorized_keys
  cp ${identity_file} ~/.ssh/pipelines_id
  cat ${known_hosts_file} >> ~/.ssh/known_hosts
  echo "IdentityFile ~/.ssh/pipelines_id" >> ~/.ssh/config
  chmod -R go-rwx ~/.ssh/

  success "Set SSH key"
}

setup_ssh
git_config
git_backup