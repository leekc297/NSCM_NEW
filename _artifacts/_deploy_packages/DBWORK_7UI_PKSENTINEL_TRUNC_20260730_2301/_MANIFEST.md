# _MANIFEST — DBWORK_7UI_PKSENTINEL_TRUNC_20260730_2301

파일 **31** / 생성 검증 이상 **0건**

| 파일 | 라인 | KB | 내용 검증 |
|---|---:|---:|---|
| `00_PRECHECK/00_PRECHECK_CLOUD.sql` | 128 | 7.6 |  |
| `00_PRECHECK/01_BACKUP_CLOUD_CURRENT.sql` | 87 | 4.0 |  |
| `01_PREREQ/00_GTT_DDL.sql` | 4,591 | 170.0 | GTT 203 본 |
| `01_PREREQ/00_TYPES_DDL.sql` | 174 | 5.8 | TYPE 18 본 |
| `01_PREREQ/00A_GTT_PRECISION_REBUILD_OPTIONAL.md` | 79 | 3.8 |  |
| `01_PREREQ/_GTT_TOKEN_CLASSIFICATION.md` | 25 | 0.8 |  |
| `02_DB_SP/01_PKG_DMF0003_SPEC.sql` | 73 | 6.8 | CREATE 1 / `/` 1 |
| `02_DB_SP/02_PKG_DMF0003_BODY.sql` | 14,927 | 753.8 | CREATE 1 / `/` 1 |
| `02_DB_SP/03_PKG_DMF0020_SPEC.sql` | 196 | 6.1 | CREATE 1 / `/` 1 |
| `02_DB_SP/04_PKG_DMF0020_BODY.sql` | 4,610 | 212.3 | CREATE 1 / `/` 1 |
| `02_DB_SP/05_PKG_DMF0021_SPEC.sql` | 70 | 2.2 | CREATE 1 / `/` 1 |
| `02_DB_SP/06_PKG_DMF0021_BODY.sql` | 3,535 | 222.7 | CREATE 1 / `/` 1 |
| `02_DB_SP/07_PKG_DMF0042_SPEC.sql` | 177 | 5.2 | CREATE 1 / `/` 1 |
| `02_DB_SP/08_PKG_DMF0042_BODY.sql` | 6,562 | 324.4 | CREATE 1 / `/` 1 |
| `02_DB_SP/09_PKG_DMF0044_SPEC.sql` | 73 | 6.9 | CREATE 1 / `/` 1 |
| `02_DB_SP/10_PKG_DMF0044_BODY.sql` | 9,745 | 563.0 | CREATE 1 / `/` 1 |
| `02_DB_SP/11_PKG_DMF0049_SPEC.sql` | 90 | 2.9 | CREATE 1 / `/` 1 |
| `02_DB_SP/12_PKG_DMF0049_BODY.sql` | 1,199 | 64.3 | CREATE 1 / `/` 1 |
| `02_DB_SP/13_PKG_DMF0082_SPEC.sql` | 40 | 3.7 | CREATE 1 / `/` 1 |
| `02_DB_SP/14_PKG_DMF0082_BODY.sql` | 12,888 | 672.4 | CREATE 1 / `/` 1 |
| `02_DB_SP/15_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL.sql` | 1,132 | 54.5 | CREATE 1 / `/` 1 |
| `02_DB_SP/16_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP.sql` | 796 | 28.8 | CREATE 1 / `/` 1 |
| `02_DB_SP/17_GRANT.sql` | 375 | 39.9 | GRANT 165 본 |
| `02_DB_SP/18_APP_SYNONYM_ONLY.sql` | 391 | 48.4 | SYNONYM 162 본 |
| `03_META/01_PROC_M_DMF0044_0049.sql` | 250 | 70.8 | DELETE 19 SP / INSERT 211 행 |
| `03_META/02_SHEET_MEASURE_DMF0082_DIV82.sql` | 86 | 15.1 | INSERT 10 / UPDATE 10 |
| `03_META/03_SHEET_COLUMNS_DMF0082_DIV82.sql` | 30 | 4.8 | INSERT 2 / UPDATE 2 |
| `03_META/04_MSG_LBL_VERSIONMODAL.sql` | 356 | 29.3 | INSERT 48 / UPDATE 48 |
| `04_VERIFY/90_VERIFY_AFTER_APPLY.sql` | 152 | 8.2 |  |
| `_MANIFEST.md` | 39 | 2.3 |  |
| `_README.md` | 147 | 8.5 |  |

## 검증 결과

✅ 전 항목 통과 — 종결자 1:1 / GTT 203 / TYPE 18 / PROC_M 19 SP·211행 / 멱등쌍 INSERT=UPDATE

## 이관 대상 요약

| 구분 | 수량 |
|---|---:|
| PKG SPEC/BODY | 7 × 2 = 14 |
| standalone PROCEDURE | 2 |
| GTT DDL | 203 |
| standalone TYPE DDL | 18 |
| GRANT 대상 | 165 (사내 미러링) |
| SYNONYM 대상 | 162 (사내 미러링) |
| PROC_M | 19 SP / 211 행 |
| SHEET_MEASURE / SHEET_COLUMNS | 10 / 2 |
| MSG_M (LBL) | 48 |

> 미포함·별건 판단 항목은 `_README.md` §4 / §5 참조.
