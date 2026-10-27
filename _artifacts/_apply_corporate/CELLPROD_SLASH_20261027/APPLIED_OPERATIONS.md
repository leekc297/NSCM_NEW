# CELLPROD_SLASH_20261027 — 사내 ZIOUI1 적용 기록 `[E20261027-CELLPRODDASH]`

- 요청(2026-10-27): 클라우드 DMF0082 실적/계획 2줄 → 원인 CELL_PROD_SITE_ID '/'(실적) vs '-'(계획). 사용자 확정: AS-IS 에 빈값 '-' 로직이 있으면 초기값 '-' → 제안(데이터 '/'→'-' · DEFAULT '-' · DMF0082 방어) + 실적 생성 '/' 로직 '-' 변경.
- AS-IS 확인: LESDFPSTO1C01 / LGCE_SCMDEV / SCP_MGR_DEV 14:47 — `_artifacts/_diagnostics/CELLPROD_ASIS_20261027/`
- 접속: 59.19.252.148:2521/ZIOUI1 · SERVER_HOST=localhost · SCM_MGR
- 범위: CELL_PROD_SITE_ID 한 컬럼만.

| 시각 | 작업 | 결과 |
|---|---|---|
| 14:56 | 실측 `inventory_dash.py` | DEFAULT ON NULL '/' 21개 테이블 · '/' 데이터 82 DM_PLN_SALES_PLAN 39,835 · PK 충돌 0 → `inventory_dash.log` |
| 15:01 | 기준 수집 `test_snapshot.py before` (20케이스) · 모의 재현 `test_mock.py` | GTT '/' 0건(20케이스) · 모의('/' 136행 + Column Set Cell Prod) 품목 7→12줄 재현 → `_mock_before.log` |
| 15:05:18 / 15:05:21 | `build_apply.py apply` — FRESH-GATE PASS · PKG_DMF0082 BODY(+18줄) · PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING(ELSE '/' 3줄 → '-') | VALID · 오류 0 · INVALID 35→35 |
| 15:06 | 모의 재현 재실행 · 20케이스 비교 | 12줄 → 7줄(CP '-') · 20/20 PASS → `_mock_after.log` `_snap_after.log` |
| 15:09~15:12 | 패키지 리허설 00 → 10(SKIP) → 30 DRY → 20 → 30 → 90 → 99_1 → 99_2 → 99_3 → 90 → 10 → 20 → 30 → 90 | 데이터 39,835 전환·복원·재전환 · DEFAULT 21개 변경·복원·재변경 · ★ 20 직후 **의존 객체 17개 INVALID**(PKG_DMF0082·0000·0003·0020 BODY · BALANCE 3종 · LONGPLAN 3종 · EXCHANGE_RATE 2종 등) |
| 15:13 | 무효화된 17개만 재컴파일 | 17/17 VALID · INVALID 총수 46(DDL 직전 46, 그 사이 타 세션 변동 35→46) |
| 15:15 | 20/99_2 에 재컴파일 추가 후 99_2 → 20 → 10(SKIP) → 30(0) → 90 | 재컴파일 실패 0 · 마커 PKG 2 · MAPPING 3 · VALID · DEFAULT '-' 21 · '/' 0 · INVALID 46 |
| 15:17 | 최종 확인 | DB 원문 == 01 적용본 (2객체 True) · 모의 7줄 · 20/20 PASS → `_snap_after2.log` |

## 남긴 객체 (원복용 · 삭제 금지)
- `SCM_MGR.ZZ_CELLPROD_DASH_DATA_20261027` — 바꾼 39,835행 ROWID·이전 값('/')
- `SCM_MGR.ZZ_CELLPROD_DASH_DFLT_20261027` — 21개 테이블 이전 DEFAULT
- 원복 = `_deploy_packages/DMF0082_CELLPRODDASH_CLOUD_20261027/A_DB/99_ROLLBACK_1→2→3`

## 미실행 / 한계
- 실적 매핑 배치(PR_DM_PLN_MKT_FCST_SALES_RESULT_MAPPING) 실행 검증 안 함 — 원장 기간 DELETE/INSERT 배치라 사내에서 돌리지 않음. 컴파일 VALID · 치환 3줄 diff 만 확인.
- 화면 확인 미실행. 사내에는 실적 '/' 데이터가 없어(81·40 '-' 뿐) 실데이터 재현 불가 → 같은 세션 모의 행으로 확인.
- 범위 밖: PR_DM_LONGPLAN_40_DELETE_IMPORT 등 CELL_PROD '/' 를 쓰는 다른 로직 미변경.
