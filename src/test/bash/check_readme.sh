#!/usr/local/bin/bash

ISSUER='build/yml/metadata.yml'
. $asserts/files/not_empty.sh "${ISSUER}"

VERSION="$(yq -Mer -p=yml -o=json .version "${ISSUER}")" || exit 1
REP_OWNER="$(yq -Mer -p=yml -o=json .repository.owner "${ISSUER}")" || exit 1
REP_NAME="$(yq -Mer -p=yml -o=json .repository.name "${ISSUER}")" || exit 1

ISSUER='README.md'
. $asserts/files/not_empty.sh "${ISSUER}"

EXPECTED_NAME="# ${REP_NAME}"

EXPECTED_RELEASE="\`${VERSION}\`
| [GitHub](https://github.com/${REP_OWNER}/${REP_NAME}/releases/tag/${VERSION})
| [Key](https://${REP_OWNER}.github.io/release-public.pem)"

EXPECTED_BUILD_AND_INSTALL="$ ./assemble.sh \\
 && ./src/test/bash/unit_test.sh \\
 && unzip -d /opt/${REP_NAME}-${VERSION} ./build/zip/${REP_NAME}-${VERSION}.zip"

EXPECTED_DOWNLOAD_AND_INSTALL="$ TMP_PATH=\"\$(mktemp)\"; \\
 curl -L 'https://github.com/${REP_OWNER}/${REP_NAME}/releases/download/${VERSION}/${REP_NAME}-${VERSION}.zip' \\
  -o \"\${TMP_PATH}\" && unzip -d /opt/${REP_NAME}-${VERSION} \"\${TMP_PATH}\" && rm \"\${TMP_PATH}\""

EXPECTED_TEXTS=(
 "${EXPECTED_NAME}"
 "${EXPECTED_RELEASE}"
 "${EXPECTED_BUILD_AND_INSTALL}"
 "${EXPECTED_DOWNLOAD_AND_INSTALL}"
)
for EXPECTED_TEXT in "${EXPECTED_TEXTS[@]}"; do
 . $asserts/files/contains.sh "${ISSUER}" "${EXPECTED_TEXT}"
done
