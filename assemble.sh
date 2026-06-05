#!/usr/local/bin/bash

REP_OWNER='StanleyProjects'
REP_NAME='Mocks'
VERSION='0.0.2'

if [[ -d 'build' ]]; then
 echo 'Build dir exists!'; exit 1; fi

mkdir 'build'
mkdir -p 'build/yml'
ISSUER='build/yml/metadata.yml'
echo "repository:
 owner: '${REP_OWNER}'
 name: '${REP_NAME}'
version: '${VERSION}'" > "${ISSUER}"

if [[ ! -s 'LICENSE' ]]; then
 echo 'No license!'; exit 1; fi

if [[ ! -s 'README.md' ]]; then
 echo 'No readme!'; exit 1; fi

mkdir -p 'build/zip'
ISSUER="build/zip/${REP_NAME}-${VERSION}.zip"
zip -r "${ISSUER}" 'src/main/bash' 'LICENSE' 'README.md'
if [[ $? -ne 0 ]]; then
 echo 'Zip error!'; exit 1; fi
