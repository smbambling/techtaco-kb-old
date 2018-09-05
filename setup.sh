#!/usr/bin/env bash

cmd_list=(
  "virtualenv-2.7 virtualenv-2.5 virtualenv"
)

# Function to check if referenced command exists
cmd_exists() {
  if [ $# -eq 0 ]; then
    echo 'WARNING: No command argument was passed to verify exists'
  fi

  #cmds=($(echo "${1}"))
  cmds=($(printf '%s' "${1}"))
  fail_counter=0
  for cmd in "${cmds[@]}"; do
    command -v "${cmd}" >&/dev/null # portable 'which'
    rc=$?
    if [ "${rc}" != "0" ]; then
      fail_counter=$((fail_counter+1))
    fi
  done

  if [ "${fail_counter}" -ge "${#cmds[@]}" ]; then
    echo "Unable to find one of the required commands [${cmds[*]}] in your PATH"
    return 1
  fi
}

# Verify that referenced commands exist on the system
for cmd in "${cmd_list[@]}"; do
  cmd_exists "${cmd[@]}"
  # shellcheck disable=SC2181
  if [ $? -ne 0 ]; then
    return $?
  fi
done

run() {
    if ! "$@"; then
      echo $?
      return $?
    fi
}

# Use existing Python VirtualENV if avilable
virtualenv_path='.venv'
if [ ! -d "${virtualenv_path}" ]; then
    echo "Failed to find a virtualenv, creating one."
    virtualenv --no-site-packages ${virtualenv_path}
else
    echo "Found existing virtualenv, using that instead."
fi

# shellcheck disable=SC1091
# shellcheck source=./venv/bin/activate
source ./.venv/bin/activate
# Upgrade pip iva pypa, need Pip 9.0.3 or greater that supports TLSv1.2
run curl https://bootstrap.pypa.io/get-pip.py | python
run pip install -U pip
run pip install -r requirements.txt --upgrade

echo " ----------------------------------------------------------------------------"
echo ""
echo " You are now within a python virtualenv at ${virtualenv_path} "
echo " This means that all python packages installed will not affect your system. "
echo " To return _back_ to system python, run deactivate in your shell. "
echo ""
echo " To test your changes run 'molecule test' in your shell. "
echo " ----------------------------------------------------------------------------"
