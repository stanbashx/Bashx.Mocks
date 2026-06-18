#!/usr/local/bin/bash

SCRIPT='src/main/bash/cmp/bin/cmp'

echo "Running test of \"${SCRIPT}\"..."

. $asserts/files/execs.sh "${SCRIPT}"

if ! /usr/local/bin/bash -n "${SCRIPT}"; then
 echo "\"${SCRIPT}\" has wrong syntax!" >&2; exit 1; fi

STDOUT="$(mktemp)"
STDERR="$(mktemp)"

#

PATH="src/main/bash/cmp/bin:${PATH}" \
cmp >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '0'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/empty.sh "${STDERR}"

EXIT_CODES=(0 256 'x' '01' $'0\n' '-1' '+1' ' 1' 2147483647)
for MOCKS_CMP_EXIT_CODE in "${EXIT_CODES[@]}"; do
 :> "${STDOUT}"
 :> "${STDERR}"
 PATH="src/main/bash/cmp/bin:${PATH}" \
 MOCKS_CMP_EXIT_CODE="${MOCKS_CMP_EXIT_CODE}" \
 cmp >"${STDOUT}" 2>"${STDERR}"
 . $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
 . $asserts/files/empty.sh "${STDOUT}"
 . $asserts/files/equals.sh "${STDERR}" $'Wrong exit code!\n'
done

EXIT_CODES=(1 42 255)
for MOCKS_CMP_EXIT_CODE in "${EXIT_CODES[@]}"; do
 :> "${STDOUT}"
 :> "${STDERR}"
 PATH="src/main/bash/cmp/bin:${PATH}" \
 MOCKS_CMP_EXIT_CODE="${MOCKS_CMP_EXIT_CODE}" \
 cmp >"${STDOUT}" 2>"${STDERR}"
 . $asserts/strings/eq.sh "${SCRIPT}" "$?" "${MOCKS_CMP_EXIT_CODE}"
 . $asserts/files/empty.sh "${STDOUT}"
 . $asserts/files/empty.sh "${STDERR}"
done

#

rm "${STDOUT}"
rm "${STDERR}"
