# APPLIED_OPERATIONS — [E20261009-VERNODATA] PKG_DMF0068.P_DMF0068_GET_ORDERLIST 버전 미존재 ORA-01403 보완 (사내 ZIOUI1)

| 항목 | 값 |
|---|---|
| 대상 | `SCM_MGR.PKG_DMF0068` PACKAGE BODY 1 객체 (SPEC 무변경) |
| 기준 원문 | 2026-10-08 16:02:29, 1476줄, md5 `61c8ea8fa713158eb0b5e12650241ce3` (`00_BACKUP_PKG_DMF0068_BODY.sql`, `_fresh_state.json`) — 2026-10-09 14:32 ALL_SOURCE 재조회 |
| 적용 | 2026-10-09 14:36:58 (1차) → 98 롤백 리허설 14:37:45 → 10 재적용 **14:37:46**, 1483줄(+7), md5 `26854a305d223ae48b482d12a76ef328`, VALID, ALL_ERRORS 0, 의존 INVALID 0 (`_apply_result.json`) |
| 도구 | `build_apply.py apply` (FRESH-GATE: 적용 직전 ALL_SOURCE 재조회 == 착수 기준본 assert → 고유 매칭 치환 → CREATE OR REPLACE → 재조회 원문 == 패치본 assert) |
| 권한 | 변경 없음 — SCMP_APP EXECUTE 기존 보유 (BODY 교체는 GRANT 유지) |
| 배경 | 클라우드 DMF0068 조회 SQL ERROR (2026-10-09 사용자 보고): `ORA-20001 [PKG_DMF0068.P_DMF0068_GET_ORDERLIST] SQLCODE=100 / ORA-01403 no data found / line 429 / P_VERSION_NO=R_S_20260902_V005` |

## 원인

- L429 `SELECT ORI_CUTOFF_VERSION_NO INTO V_ORI_VERSION_NO FROM (SELECT … FROM DM_MDF_VERSION WHERE DIVISION_ID=:div AND VERSION_NO=:ver FETCH FIRST 1 ROWS ONLY)` — 해당 버전 행이 없으면 NO_DATA_FOUND.
- AS-IS(MSSQL `LGCE_SCMDEV` sys.sql_modules `dbo.DMF0068_GET_ORDERLIST`, 2026-10-09 14:17 직접 조회) L69 `SET @V_ORI_VERSION_NO = (SELECT TOP 1 ORI_CUTOFF_VERSION_NO FROM DM_MDF_VERSION …)` — 행이 없으면 NULL, 오류 없음. 이후 PLAN 구간(DM_PLN_SALES_PLAN_C / DM_PLN_BP_FCST_C)만 `VERSION_NO = NULL` 로 0건, 수주(DM_PLN_ORDER_MGT)·실적 행은 그대로 표시.
- 없는 버전이 오는 경로: FE `useDemandManagerStore.restoreSearchConditions` 가 F6 저장조건(PKG_SCM0000.P_SCM0000_GET_SRCH_COND)의 `versionNo` 를 그대로 복원한다(주석: "없는 버전이면 SP 가 0건을 돌려줄 뿐"). 버전 팝업은 DM_MDF_VERSION 현재 행만 보여 주므로, 저장 뒤 삭제·재채번된 버전이 복원되면 SP 에서만 걸린다. `R_S_20260902_V005` 는 사내 DM_MDF_VERSION·DM_MST_VERSION·DM_PLN_SALES_PLAN_C 어디에도 없음(사내 동일 파라미터로 ORA-01403 재현).

## 변경 내용 (원본 + 7줄, 외과적 치환 — SELECT 9줄 무변경)

| # | 위치(적용 후 줄) | 내용 |
|---|---|---|
| ① | L368 | 헤더 History 1줄 `2026-10-09 ZIONEX [E20261009-VERNODATA] …` |
| ② | L431~433 | 사유 주석 2줄 + `BEGIN` |
| ③ | L443~445 | `EXCEPTION / WHEN NO_DATA_FOUND THEN V_ORI_VERSION_NO := NULL; /* 마커 */ / END;` |

P_DMF0068_GET_LOOKUPPROJECT 주석 블록 안 MSSQL 원문(L268)은 대상 아님. 같은 BODY 의 다른 SELECT INTO 4곳(SAVE_ORDERLIST L1087·L1109·L1243·L1257)은 이미 `WHEN NO_DATA_FOUND` 블록 안 — 변경 없음.

## 검증 (`build_apply.py` 내장, `_apply_result.json`)

| 버전 | 적용 전 | 적용 후 |
|---|---|---|
| `R_S_20260902_V005` (클라우드 오류 파라미터, 없는 버전) | ORA-20001 / ORA-01403 line 429 | **정상** 72행, RESULT `0/SUCCESS` (PLAN 구간 0) |
| `R_S_00000000_V000` (없는 버전) | 동일 오류 | 정상 72행 (위와 같은 md5) |
| `R_S_20260903_V001_C` (있는 R_S) | 72행 md5 `838f86a0…` | 72행 md5 **동일** |
| `R_B_20260814_V001` (있는 R_B) | 72행 md5 `aa1402bd…` | 72행 md5 **동일** |

호출 파라미터 = 오류 보고 그대로 (`'40', ver, '202501', '202712', 'minyonglee1', 'DMF0068'`). GET 은 GTT 만 쓰므로 호출 후 ROLLBACK.

클라우드 패키지 리허설(사내에서 파일 그대로 실행, 오류 0): 05 백업 → 적용 → 00 PRECHECK(적용 후라 `SKIP` 판정) → 13 → 90(V1~V5 기대값 일치 + V6 없는 버전 호출 정상) → **98 롤백 → 원문 md5 기준본 복원·ORA-01403 재발 확인** → 10 재적용 → 재검증. 리허설용 백업 테이블 `BAK_SRC_DMF0068_VERNODATA` 는 사내에서 DROP(클라우드에서는 05 가 만든 것을 남긴다).

## 사내에서 한 작업 ↔ 패키지 파일

| 작업 | 사내 파일 | 클라우드 패키지 (`_deploy_packages/DMF0068_VERNODATA_CLOUD_20261009/A_DB/`) |
|---|---|---|
| 원문 백업 | `00_BACKUP_PKG_DMF0068_BODY.sql` | `05_BACKUP_CLOUD_SOURCE.sql` (테이블 `BAK_SRC_DMF0068_VERNODATA`) |
| 판본 선판정 | (FRESH-GATE in `build_apply.py`) | `00_PRECHECK_CLOUD.sql` (H-APPLIED / H-LINES 1476 / H-LEN 68313 / H-TARGET / H-GUARD / H-DDL) |
| CREATE OR REPLACE BODY | `01_PKG_DMF0068_BODY.sql` | `10_PKG_DMF0068_BODY.sql` (전체본, 판본 다르면 `12_CHANGE_BLOCK_FOR_MANUAL_MERGE.txt`) |
| 컴파일·의존 | (내장) | `13_RECOMPILE_DEPENDENTS.sql` |
| 검증 | (내장 before/after) | `90_VERIFY.sql` (V1~V5 + V6 호출) |
| 롤백 | `00_BACKUP_*.sql` 실행 | `98_ROLLBACK_FROM_CLOUD_BACKUP.sql` |

FE·BE·메타 변경 없음. BE 재기동 불요.
