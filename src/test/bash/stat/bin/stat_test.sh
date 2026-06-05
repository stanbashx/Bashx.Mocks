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

:> "${STDERR}"
:> "${STDOUT}"

MOCKS_STAT_EXIT_CODE='x' \
 "${SCRIPT}" >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'Wrong exit code!'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDOUT}")" ''

:> "${STDERR}"
:> "${STDOUT}"

MOCKS_STAT_EXIT_CODE='2' \
 "${SCRIPT}" >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '2'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" ''
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDOUT}")" ''

:> "${STDERR}"
:> "${STDOUT}"

MOCKS_STAT_SIZE='3' \
 "${SCRIPT}" >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '0'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" ''
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDOUT}")" '3'

rm "${STDERR}"
rm "${STDOUT}"
