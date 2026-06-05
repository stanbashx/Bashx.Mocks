#!/usr/local/bin/bash

SCRIPTS='src/main/bash'

if [[ ! -d "${SCRIPTS}" ]]; then
 echo 'No scripts!' >&2; exit 1; fi

SCRIPTS_COUNT=0
COVERED_COUNT=0

while IFS= read -r -d '' SCRIPT; do
 if [[ -L "${SCRIPT}" || ! -f "${SCRIPT}" \
  || ! -s "${SCRIPT}" || ! -x "${SCRIPT}" \
  || ! "${SCRIPT}" =~ ^${SCRIPTS}/.+$ \
  ]] || ! /usr/local/bin/bash -n "${SCRIPT}"; then
  echo "\"${SCRIPT}\" is not supported!" >&2; exit 1
 fi
 SCRIPTS_COUNT=$((SCRIPTS_COUNT + 1))
 FILE_PATH="${SCRIPT#"${SCRIPTS}"/}"
 TEST_PATH="src/test/bash/${FILE_PATH}_test.sh"
 if [[ -L "${TEST_PATH}" || ! -f "${TEST_PATH}" \
  || ! -s "${TEST_PATH}" || ! -x "${TEST_PATH}" \
  ]] || ! /usr/local/bin/bash -n "${TEST_PATH}"; then
  echo "\"${SCRIPT}\" is not covered!"; continue; fi
 if [[ "$(< "${TEST_PATH}")" != *"SCRIPT='${SCRIPT}'"* ]]; then
  echo "\"${TEST_PATH}\" does not test \"${SCRIPT}\"!" >&2; exit 1; fi
 COVERED_COUNT=$((COVERED_COUNT + 1))
done < <(find "${SCRIPTS}" -depth -type f -print0)

if [[ ${SCRIPTS_COUNT} -eq 0 ]]; then
 echo 'No scripts!' >&2; exit 1
elif [[ ${COVERED_COUNT} -eq 0 ]]; then
 echo 'No scripts are covered!' >&2; exit 1
elif [[ ${COVERED_COUNT} -eq ${SCRIPTS_COUNT} ]]; then
 echo 'All scripts are covered.'
else
 echo "Only $((COVERED_COUNT * 100 / SCRIPTS_COUNT))% of all scripts are covered!" >&2; exit 1
fi
