# Bashx.Mocks
A few mock scripts.

---

## Release

`0.0.4`
| [GitHub](https://github.com/stanbashx/Bashx.Mocks/releases/tag/0.0.4)
| [Key](https://stanbashx.github.io/release-public.pem)

### Build and Install

```
$ ./assemble.sh \
 && ./src/test/bash/unit_test.sh \
 && unzip -d /opt/Bashx.Mocks-0.0.4 ./build/zip/Bashx.Mocks-0.0.4.zip
```

### Download and Install

```
$ TMP_PATH="$(mktemp)"; \
 curl -L 'https://github.com/stanbashx/Bashx.Mocks/releases/download/0.0.4/Bashx.Mocks-0.0.4.zip' \
  -o "${TMP_PATH}" && unzip -d /opt/Bashx.Mocks-0.0.4 "${TMP_PATH}" && rm "${TMP_PATH}"
```

---
