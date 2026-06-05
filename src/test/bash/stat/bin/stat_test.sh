#!/usr/local/bin/bash

SCRIPT='src/main/bash/stat/bin/stat'

echo "Running test of \"${SCRIPT}\"..."

. $asserts/files/execs.sh "${SCRIPT}"

if ! /usr/local/bin/bash -n "${SCRIPT}"; then
 echo "\"${SCRIPT}\" has wrong syntax!" >&2; exit 1; fi

STDERR="$(mktemp)"
STDOUT="$(mktemp)"

"${SCRIPT}" >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '0'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" ''
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDOUT}")" ''

echo 'Not implemented!'; exit 1 # todo
