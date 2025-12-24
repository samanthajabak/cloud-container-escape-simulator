#!/bin/bash


echo " RUNNING UNPRIVILEGED CONTAINER "


docker run --rm -it \
  -v $(pwd)/scripts:/scripts \
  unprivileged-container \
  bash -c "
    echo '[UNPRIVILEGED] Running escape tests...'
    /scripts/escape_tests/check_mounts.sh
    /scripts/escape_tests/check_namespaces.sh
    /scripts/escape_tests/check_capabilities.sh
    /scripts/escape_tests/check_devices.sh
    /scripts/escape_tests/check_kernel_logs.sh
  "

echo

echo " RUNNING DANGEROUS_CAPS CONTAINER "


docker run --rm -it \
  --cap-add=SYS_ADMIN \
  --cap-add=SYS_PTRACE \
  -v $(pwd)/scripts:/scripts \
  dangerous-caps-container \
  bash -c "
    echo '[DANGEROUS_CAPS] Running escape tests...'
    /scripts/escape_tests/check_mounts.sh
    /scripts/escape_tests/check_namespaces.sh
    /scripts/escape_tests/check_capabilities.sh
    /scripts/escape_tests/check_devices.sh
    /scripts/escape_tests/check_kernel_logs.sh
  "

echo

echo " RUNNING PRIVILEGED CONTAINER "


docker run --rm -it \
  --privileged \
  -v $(pwd)/scripts:/scripts \
  privileged-container \
  bash -c "
    echo '[PRIVILEGED] Running escape tests...'
    /scripts/escape_tests/check_mounts.sh
    /scripts/escape_tests/check_namespaces.sh
    /scripts/escape_tests/check_capabilities.sh
    /scripts/escape_tests/check_devices.sh
    /scripts/escape_tests/check_kernel_logs.sh
  "

echo

echo " RUNNING MOUNTED_HOST CONTAINER "


docker run --rm -it \
  -v /:/host \
  -v $(pwd)/scripts:/scripts \
  mounted-host-container \
  bash -c "
    echo '[MOUNTED_HOST] Running escape tests...'
    /scripts/escape_tests/check_mounts.sh
    /scripts/escape_tests/check_namespaces.sh
    /scripts/escape_tests/check_capabilities.sh
    /scripts/escape_tests/check_devices.sh
    /scripts/escape_tests/check_kernel_logs.sh

    echo '[MOUNTED_HOST] Listing /host to confirm host FS access...'
    ls /host
  "

echo

echo " ALL CONTAINERS COMPLETED "

