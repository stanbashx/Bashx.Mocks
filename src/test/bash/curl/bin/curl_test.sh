#!/usr/local/bin/bash

SCRIPT='src/main/bash/curl/bin/curl'

echo "Running test of \"${SCRIPT}\"..."

. $asserts/files/execs.sh "${SCRIPT}"

if ! /usr/local/bin/bash -n "${SCRIPT}"; then
 echo "\"${SCRIPT}\" has wrong syntax!" >&2; exit 1; fi

MOCKS_DATAS=('' ' ' 'x' 42 '{"foo":"bar"}' $'\t' $'\n200' 'foo=bar' 'foo: bar' 'document=@"/foo/bar/baz.txt"')

STDERR="$(mktemp)"
STDOUT="$(mktemp)"

PATH="src/main/bash/curl/bin:${PATH}" \
 curl >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '0'
. $asserts/files/empty.sh "${STDERR}"
. $asserts/files/empty.sh "${STDOUT}"

EXIT_CODES=(0 256 'x' '01' $'0\n' '-1' '+1' ' 1' 2147483647)
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

for MOCKS_CURL_DST in "${MOCKS_DATAS[@]}"; do
 :> "${STDERR}"
 :> "${STDOUT}"
 PATH="src/main/bash/curl/bin:${PATH}" \
 MOCKS_CURL_DST="${MOCKS_CURL_DST}" \
  curl >"${STDOUT}" 2>"${STDERR}"
 . $asserts/strings/eq.sh "${SCRIPT}" "$?" '0'
 . $asserts/files/empty.sh "${STDERR}"
 . $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDOUT}")" "${MOCKS_CURL_DST}"
done

:> "${STDERR}"
:> "${STDOUT}"
PATH="src/main/bash/curl/bin:${PATH}" \
MOCKS_CURL_HTTP_CODE=200 \
MOCKS_CURL_DST='foo' \
 curl -w 'bar' >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '0'
. $asserts/files/empty.sh "${STDERR}"
. $asserts/files/empty.sh "${STDOUT}"

# MOCKS_CURL_DATA + MOCKS_CURL_DATA_PATH

MOCKS_CURL_DATA_PATH="$(mktemp)"
MOCKS_FLAGS=('--data' '-d')
:> "${STDERR}"
:> "${STDOUT}"
for MOCKS_FLAG in "${MOCKS_FLAGS[@]}"; do
 for MOCKS_CURL_DATA in "${MOCKS_DATAS[@]}"; do
  PATH="src/main/bash/curl/bin:${PATH}" \
  MOCKS_CURL_DATA_PATH="${MOCKS_CURL_DATA_PATH}" \
   curl "${MOCKS_FLAG}" "${MOCKS_CURL_DATA}" >"${STDOUT}" 2>"${STDERR}"
  . $asserts/strings/eq.sh "${SCRIPT}" "$?" '0'
  . $asserts/files/empty.sh "${STDERR}"
  . $asserts/files/empty.sh "${STDOUT}"
  . $asserts/strings/eq.sh "${SCRIPT}" "$(<"${MOCKS_CURL_DATA_PATH}")" "${MOCKS_CURL_DATA}"
 done
done
rm "${MOCKS_CURL_DATA_PATH}"

# MOCKS_CURL_DATA

MOCKS_CURL_DATA_PATH="$(mktemp)"
MOCKS_FLAGS=('--data' '-d')
:> "${STDERR}"
:> "${STDOUT}"
for MOCKS_FLAG in "${MOCKS_FLAGS[@]}"; do
 PATH="src/main/bash/curl/bin:${PATH}" \
  curl "${MOCKS_FLAG}" 'foo' >"${STDOUT}" 2>"${STDERR}"
 . $asserts/strings/eq.sh "${SCRIPT}" "$?" '0'
 . $asserts/files/empty.sh "${STDERR}"
 . $asserts/files/empty.sh "${STDOUT}"
 . $asserts/files/empty.sh "${MOCKS_CURL_DATA_PATH}"
done
rm "${MOCKS_CURL_DATA_PATH}"

# MOCKS_CURL_DATA_PATH

MOCKS_CURL_DATA_PATH="$(mktemp)"
:> "${STDERR}"
:> "${STDOUT}"
PATH="src/main/bash/curl/bin:${PATH}" \
MOCKS_CURL_DATA_PATH="${MOCKS_CURL_DATA_PATH}" \
 curl >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '0'
. $asserts/files/empty.sh "${STDERR}"
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/empty.sh "${MOCKS_CURL_DATA_PATH}"
rm "${MOCKS_CURL_DATA_PATH}"

# MOCKS_CURL_DST + MOCKS_CURL_DST_PATH

MOCKS_CURL_DST_PATH="$(mktemp)"
for MOCKS_CURL_DST in "${MOCKS_DATAS[@]}"; do
 :> "${STDERR}"
 :> "${STDOUT}"
 PATH="src/main/bash/curl/bin:${PATH}" \
 MOCKS_CURL_DST="${MOCKS_CURL_DST}" \
  curl -o "${MOCKS_CURL_DST_PATH}" >"${STDOUT}" 2>"${STDERR}"
 . $asserts/strings/eq.sh "${SCRIPT}" "$?" '0'
 . $asserts/files/empty.sh "${STDERR}"
 . $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDOUT}")" "${MOCKS_CURL_DST}"
 . $asserts/strings/eq.sh "${SCRIPT}" "$(<"${MOCKS_CURL_DST_PATH}")" "${MOCKS_CURL_DST}"
done
rm "${MOCKS_CURL_DST_PATH}"

# MOCKS_CURL_DST

MOCKS_CURL_DST_PATH="$(mktemp)"
:> "${STDERR}"
:> "${STDOUT}"
PATH="src/main/bash/curl/bin:${PATH}" \
MOCKS_CURL_DST='foo' \
 curl >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '0'
. $asserts/files/empty.sh "${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${STDOUT}")" 'foo'
. $asserts/files/empty.sh "${MOCKS_CURL_DST_PATH}"
rm "${MOCKS_CURL_DST_PATH}"

# MOCKS_CURL_DST_PATH

MOCKS_CURL_DST_PATH="$(mktemp)"
:> "${STDERR}"
:> "${STDOUT}"
PATH="src/main/bash/curl/bin:${PATH}" \
 curl -o "${MOCKS_CURL_DST_PATH}" >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '0'
. $asserts/files/empty.sh "${STDERR}"
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/empty.sh "${MOCKS_CURL_DST_PATH}"
rm "${MOCKS_CURL_DST_PATH}"

PATH="src/main/bash/curl/bin:${PATH}" \
MOCKS_CURL_DST_TYPE='file' \
 curl -o "${MOCKS_CURL_DST_PATH}" >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '0'
. $asserts/files/empty.sh "${STDERR}"
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/empty.sh "${MOCKS_CURL_DST_PATH}"
rm "${MOCKS_CURL_DST_PATH}"

PATH="src/main/bash/curl/bin:${PATH}" \
MOCKS_CURL_DST_TYPE='symlink' \
 curl -o "${MOCKS_CURL_DST_PATH}" >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '0'
. $asserts/files/empty.sh "${STDERR}"
. $asserts/files/empty.sh "${STDOUT}"
if [[ ! -L "${MOCKS_CURL_DST_PATH}" ]]; then
 echo "\"${MOCKS_CURL_DST_PATH}\" is not a symlink!" >&2; exit 1; fi
rm "${MOCKS_CURL_DST_PATH}"

PATH="src/main/bash/curl/bin:${PATH}" \
MOCKS_CURL_DST_TYPE='dir' \
 curl -o "${MOCKS_CURL_DST_PATH}" >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '0'
. $asserts/files/empty.sh "${STDERR}"
. $asserts/files/empty.sh "${STDOUT}"
if [[ -L "${MOCKS_CURL_DST_PATH}" ]]; then
 echo "\"${MOCKS_CURL_DST_PATH}\" is a symlink!" >&2; exit 1
elif [[ ! -e "${MOCKS_CURL_DST_PATH}" ]]; then
 echo "\"${MOCKS_CURL_DST_PATH}\" does not exist!" >&2; exit 1
elif [[ ! -d "${MOCKS_CURL_DST_PATH}" ]]; then
 echo "\"${MOCKS_CURL_DST_PATH}\" is not a dir!" >&2; exit 1
fi
rm -rf "${MOCKS_CURL_DST_PATH}"

FORM_STRINGS=()
EXPECTED_TEXT=''
FORM_STRINGS+=('--form-string' "${MOCKS_DATAS[0]}")
EXPECTED_TEXT="${EXPECTED_TEXT}${MOCKS_DATAS[0]}"
for (( i=1; i<${#MOCKS_DATAS[@]}; i++ )); do
 FORM_STRINGS+=('--form-string' "${MOCKS_DATAS[i]}")
 EXPECTED_TEXT="${EXPECTED_TEXT}"$'\n'"${MOCKS_DATAS[i]}"
done
MOCKS_CURL_FORM_STRINGS_PATH="$(mktemp)"
rm "${MOCKS_CURL_FORM_STRINGS_PATH}"
:> "${STDERR}"
:> "${STDOUT}"
PATH="src/main/bash/curl/bin:${PATH}" \
MOCKS_CURL_FORM_STRINGS_PATH="${MOCKS_CURL_FORM_STRINGS_PATH}" \
 curl "${FORM_STRINGS[@]}" >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '0'
. $asserts/files/empty.sh "${STDERR}"
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/strings/eq.sh "${SCRIPT}" "$(<"${MOCKS_CURL_FORM_STRINGS_PATH}")" "${EXPECTED_TEXT}"
rm "${MOCKS_CURL_FORM_STRINGS_PATH}"

:> "${STDERR}"
:> "${STDOUT}"
MOCKS_FLAGS=('--form' '-F')
for MOCKS_FLAG in "${MOCKS_FLAGS[@]}"; do
 MOCKS_CURL_FORMS_PATH="$(mktemp)"
 rm "${MOCKS_CURL_FORMS_PATH}"
 MOCKS_FORMS=()
 EXPECTED_TEXT=''
 MOCKS_FORMS+=("${MOCKS_FLAG}" "${MOCKS_DATAS[0]}")
 EXPECTED_TEXT="${EXPECTED_TEXT}${MOCKS_DATAS[0]}"
 for (( i=1; i<${#MOCKS_DATAS[@]}; i++ )); do
  MOCKS_FORMS+=("${MOCKS_FLAG}" "${MOCKS_DATAS[i]}")
  EXPECTED_TEXT="${EXPECTED_TEXT}"$'\n'"${MOCKS_DATAS[i]}"
 done
 PATH="src/main/bash/curl/bin:${PATH}" \
 MOCKS_CURL_FORMS_PATH="${MOCKS_CURL_FORMS_PATH}" \
  curl "${MOCKS_FORMS[@]}" >"${STDOUT}" 2>"${STDERR}"
 . $asserts/strings/eq.sh "${SCRIPT}" "$?" '0'
 . $asserts/files/empty.sh "${STDERR}"
 . $asserts/files/empty.sh "${STDOUT}"
 . $asserts/strings/eq.sh "${SCRIPT}" "$(<"${MOCKS_CURL_FORMS_PATH}")" "${EXPECTED_TEXT}"
 rm "${MOCKS_CURL_FORMS_PATH}"
done

:> "${STDERR}"
:> "${STDOUT}"
MOCKS_FLAGS=('--header' '-H')
for MOCKS_FLAG in "${MOCKS_FLAGS[@]}"; do
 MOCKS_CURL_HEADERS_PATH="$(mktemp)"
 rm "${MOCKS_CURL_HEADERS_PATH}"
 MOCKS_HEADERS=()
 EXPECTED_TEXT=''
 MOCKS_HEADERS+=("${MOCKS_FLAG}" "${MOCKS_DATAS[0]}")
 EXPECTED_TEXT="${EXPECTED_TEXT}${MOCKS_DATAS[0]}"
 for (( i=1; i<${#MOCKS_DATAS[@]}; i++ )); do
  MOCKS_HEADERS+=("${MOCKS_FLAG}" "${MOCKS_DATAS[i]}")
  EXPECTED_TEXT="${EXPECTED_TEXT}"$'\n'"${MOCKS_DATAS[i]}"
 done
 PATH="src/main/bash/curl/bin:${PATH}" \
 MOCKS_CURL_HEADERS_PATH="${MOCKS_CURL_HEADERS_PATH}" \
  curl "${MOCKS_HEADERS[@]}" >"${STDOUT}" 2>"${STDERR}"
 . $asserts/strings/eq.sh "${SCRIPT}" "$?" '0'
 . $asserts/files/empty.sh "${STDERR}"
 . $asserts/files/empty.sh "${STDOUT}"
 . $asserts/strings/eq.sh "${SCRIPT}" "$(<"${MOCKS_CURL_HEADERS_PATH}")" "${EXPECTED_TEXT}"
 rm "${MOCKS_CURL_HEADERS_PATH}"
done

rm "${STDERR}"
rm "${STDOUT}"
