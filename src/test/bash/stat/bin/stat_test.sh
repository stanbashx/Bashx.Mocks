#!/usr/local/bin/bash

SCRIPT='src/main/bash/stat/bin/stat'

echo "Running test of \"${SCRIPT}\"..."

. $asserts/files/execs.sh "${SCRIPT}"

if ! /usr/local/bin/bash -n "${SCRIPT}"; then
 echo "\"${SCRIPT}\" has wrong syntax!" >&2; exit 1; fi

STDERR="$(mktemp)"
STDOUT="$(mktemp)"

PATH="src/main/bash/stat/bin:${PATH}" \
 stat >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '0'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" ''
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDOUT}")" ''

:> "${STDERR}"
:> "${STDOUT}"

PATH="src/main/bash/stat/bin:${PATH}" \
MOCKS_STAT_EXIT_CODE='x' \
 stat >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'Wrong exit code!'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDOUT}")" ''

:> "${STDERR}"
:> "${STDOUT}"

PATH="src/main/bash/stat/bin:${PATH}" \
MOCKS_STAT_EXIT_CODE='2' \
 stat >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '2'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" ''
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDOUT}")" ''

:> "${STDERR}"
:> "${STDOUT}"

PATH="src/main/bash/stat/bin:${PATH}" \
MOCKS_STAT_SIZE='3' \
 stat >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '0'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" ''
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDOUT}")" '3'

rm "${STDERR}"
rm "${STDOUT}"
