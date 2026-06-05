#!/usr/local/bin/bash

ISSUER='LICENSE'
. $asserts/files/not_empty.sh "${ISSUER}"

AUTHOR='Stanley Wintergreen'
REGEX="Copyright 2[0-9]{3} ${AUTHOR}"

. $asserts/files/regex.sh "${ISSUER}" "${REGEX}"
