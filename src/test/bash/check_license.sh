#!/usr/local/bin/bash

SUBJECT='LICENSE'
. $asserts/files/not_empty.sh "${SUBJECT}"

AUTHOR='Stanley Wintergreen'
REGEX="Copyright 2[0-9]{3} ${AUTHOR}"

. $asserts/files/regex.sh "${SUBJECT}" "${REGEX}"
