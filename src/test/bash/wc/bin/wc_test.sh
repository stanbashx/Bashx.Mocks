#!/usr/local/bin/bash

SCRIPT='src/main/bash/wc/bin/wc'

echo "Running test for \"${SCRIPT}\"..."

. $asserts/files/execs.sh "${SCRIPT}"

if ! /usr/local/bin/bash -n "${SCRIPT}"; then
 echo "\"${SCRIPT}\" has invalid syntax!" >&2; exit 1; fi

STDOUT="$(mktemp)"
STDERR="$(mktemp)"

#

:> "${STDOUT}"
:> "${STDERR}"
PATH="src/main/bash/wc/bin:${PATH}" \
 wc > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 0
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/empty.sh "${STDERR}"

EXIT_CODES=('' ' ' $'\n' $'\t' '-0' '0' '+0' '256' 'x' '01' $'0\n' '-1' ' 1' '+1'  -2147483648 -2147483649 2147483647 2147483648)
for MOCKS_WC_EXIT_CODE in "${EXIT_CODES[@]}"; do
 :> "${STDERR}"
 :> "${STDOUT}"
 PATH="src/main/bash/wc/bin:${PATH}" \
  MOCKS_WC_EXIT_CODE="${MOCKS_WC_EXIT_CODE}" \
  wc > "${STDOUT}" 2> "${STDERR}"
 . $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
 . $asserts/files/empty.sh "${STDOUT}"
 . $asserts/files/equals.sh "${STDERR}" $'Wrong exit code!\n'
done

EXIT_CODES=(1 42 255)
for MOCKS_WC_EXIT_CODE in "${EXIT_CODES[@]}"; do
 :> "${STDERR}"
 :> "${STDOUT}"
 PATH="src/main/bash/wc/bin:${PATH}" \
  MOCKS_WC_EXIT_CODE="${MOCKS_WC_EXIT_CODE}" \
  wc > "${STDOUT}" 2> "${STDERR}"
 . $asserts/ints/eq.sh "${SCRIPT}" "$?" "${MOCKS_WC_EXIT_CODE}"
 . $asserts/files/empty.sh "${STDOUT}"
 . $asserts/files/empty.sh "${STDERR}"
done

#

rm "${STDERR}"
rm "${STDOUT}"
