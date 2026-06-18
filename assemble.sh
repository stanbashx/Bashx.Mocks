#!/usr/local/bin/bash

REP_OWNER='stanbashx'
REP_NAME='Bashx.Mocks'
VERSION='0.0.4'

if [[ -d 'build' ]]; then
 echo 'Build dir exists!' >&2; exit 1; fi

mkdir 'build'
mkdir -p 'build/yml'
ISSUER='build/yml/metadata.yml'
echo "repository:
 owner: '${REP_OWNER}'
 name: '${REP_NAME}'
version: '${VERSION}'" > "${ISSUER}"

if [[ ! -s 'LICENSE' ]]; then
 echo 'No license!' >&2; exit 1; fi

if [[ ! -s 'README.md' ]]; then
 echo 'No readme!' >&2; exit 1; fi

mkdir -p 'build/zip'
ISSUER="build/zip/${REP_NAME}-${VERSION}.zip"
zip -r "${ISSUER}" 'src/main/bash' 'LICENSE' 'README.md'
if [[ $? -ne 0 ]]; then
 echo 'Zip error!' >&2; exit 1; fi
