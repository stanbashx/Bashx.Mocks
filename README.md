# Mocks
A few mock scripts.

---

## Release

`0.0.2`
| [GitHub](https://github.com/StanleyProjects/Mocks/releases/tag/0.0.2)
| [Key](https://StanleyProjects.github.io/release-public.pem)

### Build and Install

```
$ ./assemble.sh \
 && ./src/test/bash/unit_test.sh \
 && unzip -d /opt/Mocks-0.0.2 ./build/zip/Mocks-0.0.2.zip
```

### Download and Install

```
$ TMP_PATH="$(mktemp)"; \
 curl -L 'https://github.com/StanleyProjects/Mocks/releases/download/0.0.2/Mocks-0.0.2.zip' \
  -o "${TMP_PATH}" && unzip -d /opt/Mocks-0.0.2 "${TMP_PATH}" && rm "${TMP_PATH}"
```

---
