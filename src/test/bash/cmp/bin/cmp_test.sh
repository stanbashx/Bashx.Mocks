#!/usr/local/bin/bash

SCRIPT='src/main/bash/cmp/bin/cmp'

echo "Running test of \"${SCRIPT}\"..."

. $asserts/files/execs.sh "${SCRIPT}"

if ! /usr/local/bin/bash -n "${SCRIPT}"; then
 echo "\"${SCRIPT}\" has wrong syntax!" >&2; exit 1; fi

STDERR="$(mktemp)"
STDOUT="$(mktemp)"

PATH="src/main/bash/cmp/bin:${PATH}" \
 cmp >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '0'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" ''
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDOUT}")" ''

EXIT_CODES=(0 256 'x' '01' $'0\n')
for MOCKS_CMP_EXIT_CODE in "${EXIT_CODES[@]}"; do
 :> "${STDERR}"
 :> "${STDOUT}"
 PATH="src/main/bash/cmp/bin:${PATH}" \
 MOCKS_CMP_EXIT_CODE="${MOCKS_CMP_EXIT_CODE}" \
  cmp >"${STDOUT}" 2>"${STDERR}"
 . $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
 . $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'Wrong exit code!'
 . $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDOUT}")" ''
done

EXIT_CODES=(1 42 255)
for MOCKS_CMP_EXIT_CODE in "${EXIT_CODES[@]}"; do
 :> "${STDERR}"
 :> "${STDOUT}"
 PATH="src/main/bash/cmp/bin:${PATH}" \
 MOCKS_CMP_EXIT_CODE="${MOCKS_CMP_EXIT_CODE}" \
  cmp >"${STDOUT}" 2>"${STDERR}"
 . $asserts/strings/eq.sh "${SCRIPT}" "$?" "${MOCKS_CMP_EXIT_CODE}"
 . $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" ''
 . $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDOUT}")" ''
done

MOCKS_CMP_SIZES=(0 1 42 1024 32000000 'foo' '' ' ' $'\t')
for MOCKS_CMP_SIZE in "${MOCKS_CMP_SIZES[@]}"; do
 :> "${STDERR}"
 :> "${STDOUT}"
 PATH="src/main/bash/cmp/bin:${PATH}" \
 MOCKS_CMP_SIZE="${MOCKS_CMP_SIZE}" \
  cmp >"${STDOUT}" 2>"${STDERR}"
 . $asserts/strings/eq.sh "${SCRIPT}" "$?" '0'
 . $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" ''
 . $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDOUT}")" "${MOCKS_CMP_SIZE}"
done

PATH="src/main/bash/cmp/bin:${PATH}" \
MOCKS_CMP_EXIT_CODE='2' \
MOCKS_CMP_SIZE='3' \
 cmp >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '2'
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" ''
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDOUT}")" ''

rm "${STDERR}"
rm "${STDOUT}"
