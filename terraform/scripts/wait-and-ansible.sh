#!/usr/bin/env bash
set -euo pipefail

PUBLIC_IP="${1:?public IP is required}"
SSH_KEY="${2:?SSH private key path is required}"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
ANSIBLE_DIR="${REPO_ROOT}/ansible"
SSH_KEY_EXPANDED="${SSH_KEY/#\~/$HOME}"

echo "Waiting for SSH on ${PUBLIC_IP}..."
for i in $(seq 1 30); do
  if ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 -i "${SSH_KEY_EXPANDED}" ubuntu@"${PUBLIC_IP}" "echo ready" >/dev/null 2>&1; then
    echo "SSH is available."
    break
  fi
  if [[ "${i}" -eq 30 ]]; then
    echo "Timed out waiting for SSH on ${PUBLIC_IP}" >&2
    exit 1
  fi
  sleep 10
done

export ANSIBLE_HOST_KEY_CHECKING=False

EXTRA_VARS=(
  -e "@inventory/dev/group_vars/all/main.yaml"
)

if [[ -f "inventory/dev/group_vars/all/secrets.yaml" ]]; then
  EXTRA_VARS+=(-e "@inventory/dev/group_vars/all/secrets.yaml")
fi

VAULT_ARGS=()
if [[ -f "${ANSIBLE_DIR}/.vault_pass" ]]; then
  VAULT_ARGS=(--vault-password-file "${ANSIBLE_DIR}/.vault_pass")
elif [[ -n "${ANSIBLE_VAULT_PASSWORD_FILE:-}" ]]; then
  VAULT_ARGS=(--vault-password-file "${ANSIBLE_VAULT_PASSWORD_FILE}")
fi

cd "${ANSIBLE_DIR}"
ansible-playbook \
  -i "${PUBLIC_IP}," \
  -u ubuntu \
  --private-key "${SSH_KEY_EXPANDED}" \
  "${VAULT_ARGS[@]}" \
  "${EXTRA_VARS[@]}" \
  playbooks/full-setup.yaml
