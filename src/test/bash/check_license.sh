#!/usr/local/bin/bash

ISSUER='LICENSE'
. $asserts/files/not_empty.sh "${ISSUER}"

AUTHOR='Stanley Wintergreen'
REGEX="Copyright 2[0-9]{3} ${AUTHOR}"

# todo $asserts/files/regex.sh
if ! grep -qE "${REGEX}" "${ISSUER}"; then
 echo "File \"${ISSUER}\" does not satisfy the regex:
---
${REGEX}
---"; exit 1; fi
