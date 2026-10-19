# _FILELIST — PKG_DMF0082_BIZTYPE_MSG_20260909

| 파일 | 크기(B) | sha256(16) |
|---|---:|---|
| `00_PRECHECK.sql` | 2,191 | `bbc0c9763bcb5667` |
| `00_README.md` | 6,627 | `25e117d6ff9d08c2` |
| `10_PATCH_BIZTYPE_MSG.sql` | 4,012 | `07657ba0a0ffe2c0` |
| `90_VERIFY.sql` | 2,412 | `d9c3248fb4eef380` |
| `99_ROLLBACK.sql` | 2,853 | `c3e4f50a8ad77b3b` |
| `_ref/PKG_DMF0082_BODY_CLOUD20260907_BASELINE.sql` | 853,929 | `ffd81f3b539efb3f` |
| `_ref/PKG_DMF0082_BODY_CLOUD20260907_PATCHED.sql` | 854,378 | `6fc6484998d79512` |

총 7파일 / 1,726,402 bytes

적용 순서 : `00_PRECHECK.sql` → `10_PATCH_BIZTYPE_MSG.sql` → `90_VERIFY.sql` (원복 = `99_ROLLBACK.sql`)
`_ref/` 는 검토용 참고본 — 배포에 사용하지 않는다.