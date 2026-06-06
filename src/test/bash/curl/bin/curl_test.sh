#!/usr/local/bin/bash

SCRIPT='src/main/bash/curl/bin/curl'

echo "Running test of \"${SCRIPT}\"..."

. $asserts/files/execs.sh "${SCRIPT}"

if ! /usr/local/bin/bash -n "${SCRIPT}"; then
 echo "\"${SCRIPT}\" has wrong syntax!" >&2; exit 1; fi

STDERR="$(mktemp)"
STDOUT="$(mktemp)"

PATH="src/main/bash/curl/bin:${PATH}" \
 curl >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '0'
. $asserts/files/empty.sh "${STDERR}"
. $asserts/files/empty.sh "${STDOUT}"

EXIT_CODES=(0 256 'x' '01' $'0\n')
for MOCKS_CURL_EXIT_CODE in "${EXIT_CODES[@]}"; do
 :> "${STDERR}"
 :> "${STDOUT}"
 PATH="src/main/bash/curl/bin:${PATH}" \
 MOCKS_CURL_EXIT_CODE="${MOCKS_CURL_EXIT_CODE}" \
  curl >"${STDOUT}" 2>"${STDERR}"
 . $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
 . $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'Wrong exit code!'
 . $asserts/files/empty.sh "${STDOUT}"
done

EXIT_CODES=(1 42 255)
for MOCKS_CURL_EXIT_CODE in "${EXIT_CODES[@]}"; do
 :> "${STDERR}"
 :> "${STDOUT}"
 PATH="src/main/bash/curl/bin:${PATH}" \
 MOCKS_CURL_EXIT_CODE="${MOCKS_CURL_EXIT_CODE}" \
  curl >"${STDOUT}" 2>"${STDERR}"
 . $asserts/strings/eq.sh "${SCRIPT}" "$?" "${MOCKS_CURL_EXIT_CODE}"
 . $asserts/files/empty.sh "${STDERR}"
 . $asserts/files/empty.sh "${STDOUT}"
done

HTTP_CODES=(0 200 500 'x' '01' '' ' ' $'\t' $'\n200')
for MOCKS_CURL_HTTP_CODE in "${HTTP_CODES[@]}"; do
 :> "${STDERR}"
 :> "${STDOUT}"
 PATH="src/main/bash/curl/bin:${PATH}" \
 MOCKS_CURL_HTTP_CODE="${MOCKS_CURL_HTTP_CODE}" \
  curl -w '%{http_code}' >"${STDOUT}" 2>"${STDERR}"
 . $asserts/strings/eq.sh "${SCRIPT}" "$?" '0'
 . $asserts/files/empty.sh "${STDERR}"
 . $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDOUT}")" "${MOCKS_CURL_HTTP_CODE}"
done

echo 'Not implemented!'; exit 1 # todo

rm "${STDERR}"
rm "${STDOUT}"
