# 파일 목록 — 적용 순서

| 순서 | 파일 | 용도 |
|---:|---|---|
| 1 | `01_PKG_DMF0040_SPEC.sql` | PACKAGE 스펙 (내용 무변경 — 시그니처 정합용) |
| 2 | `02_PKG_DMF0040_BODY.sql` | **적용 본체** — `CREATE OR REPLACE` + 종결자 `/` + `SET SQLBLANKLINES ON` |
| 3 | `90_VERIFY.sql` | 검증 G1~G7 (읽기 전용) |
| - | `00_README.md` | 변경 내역·검증 실측·주의사항 |

⚠ 순서 의존 : `01_` → `02_` → `90_`
