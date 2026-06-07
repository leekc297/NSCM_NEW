# DMF0003 SP Body 적재 가이드

> **작성**: 2026-06-07
> **원칙**: memory `feedback_sp_body_no_rewrite` — SP body 원본 1바이트도 변경 금지. archive 그대로 적재.

## 1. SP 위치 인벤토리 (총 30 SP)

### A. archive standalone SP (8건) — `To-be_v2_converted/07_Standalone_SP/_archive_absorbed_into_PKG/05_Standalone_SP_DMF0003.sql`

| # | SP | Line 범위 | 라인 수 | Phase | 비고 |
|---|---|---|---:|:-:|---|
| 1 | `DMF0003_GET_DM_ANL_MKT_PSI_AN_LOGIC` | 18 ~ 674 | 657 | P4 | PSI 분석 logic |
| 2 | `DMF0003_GET_DM_ANL_MKT_PSI_DATA` | 675 ~ 1545 | 871 | P4 | PSI 데이터 |
| 3 | **`DMF0003_GET_MKT_FCST_DATA`** | **1546 ~ 5745** | **4,200** | **P1+P2** | **메인 GET (★ 가장 큰 SP)** |
| 4 | `DMF0003_GET_PRPOPUP` | 5747 ~ 6030 | 284 | P5 | PR popup GET |
| 5 | `DMF0003_GET_PR_HISTORY_POPUP` | 6031 ~ 6108 | 78 | P5 | PR history |
| 6 | `DMF0003_SAVE_DM_ANL_MKT_PSI_DETAIL` | 6109 ~ 8331 | 2,223 | P4 | PSI SAVE batch |
| 7 | **`DMF0003_SAVE_MKT_FCST`** | **8332 ~ 10549** | **2,218** | **P2** | **메인 SAVE** |
| 8 | `DMF0003_SAVE_PRPOPUP` | 10550 ~ 10574 | 25 | P5 | PR SAVE wrapper |

### B. PKG_DMF0003 procedures (22건) — `To-be_v2_converted/06_Packages/04_Package_PKG_DMF0003.sql`

| # | PKG Procedure | Line | Phase | 비고 |
|---|---|---:|:-:|---|
| 1 | `P_DMF0003_GET_BUCKET_TYPE_CODE` | 292 | **P1** | Bucket combo (DAILY/WEEKLY/MONTHLY) |
| 2 | `P_DMF0003_CAR_FCST_EXCEL_UPLOAD` | 342 | P6 | Excel upload (★ analysis MD 누락) |
| 3 | `P_DMF0003_GET_DM_ANL_CAR_PROPERTY` | 1092 | P6 | Calculation - Car property |
| 4 | `P_DMF0003_GET_DM_ANL_CAR_REF` | 1204 | P6 | Calculation - Car ref |
| 5 | `P_DMF0003_GET_DM_ANL_MKT_PSI_DPINIT` | 1408 | P4 | PSI DP init |
| 6 | `P_DMF0003_GET_DM_ANL_MKT_PSI_DPRESULT` | 1622 | P4 | PSI DP result |
| 7 | `P_DMF0003_GET_SPREAD_TITLE` | 1780 | **P3** | 동적 PIVOT title |
| 8 | `P_DMF0003_GET_MKT_FCST_COMPARE_POPUP` | 2284 | P5 | SSP compare popup |
| 9 | `P_DMF0003_GET_QTY_TYPE_CODE` | 2565 | P6 | Qty type combo |
| 10 | `P_DMF0003_GET_REPORT_BUCKET_TYPE_CODE` | — | P6 | Report bucket |
| 11 | `P_DMF0003_GET_SPREAD_TITLE_CAR` | — | P4 | Car spread title |
| 12 | `P_DMF0003_GET_SPREAD_TITLE_PSI` | — | P4 | PSI spread title |
| 13 | `P_DMF0003_GET_SPREAD_TITLE_PSI_POPUP` | — | P5 | PSI popup title |
| 14 | `P_DMF0003_MKT_FCST_SALES_PLAN_SYNC` | — | P6 | **SSP 동기화 (★ analysis MD 누락)** |
| 15 | `P_DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE` | — | P5 | MasterChg SAVE |
| 16~22 | (별도 PROCEDURE) | — | — | 인벤토리 cross-check |

### C. SCM0001 공용 SP (5건) — **재사용 (작성 X)**
이미 다른 화면에서 적재된 standalone SP. cross-check 만:
- `SCM0001_GET_DIVISION` (Division combo)
- `SCM0001_GET_TEAM_BY_DIVISION` (Team cascade)
- `SCM0001_GET_CUSTOMER_BY_DIVISION` (End Customer cascade)
- `SCM0001_GET_BIZ_TYPE_BY_DIVISION` (Biz Type cascade)
- `SCM0001_GET_SITE_BY_DIVISION` (Sales Site cascade)
- `SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER` (Plant Site cascade — Div 81)

→ Phase 1 작업 시 `ALL_OBJECTS WHERE OBJECT_NAME LIKE 'SCM0001_%' AND STATUS='VALID'` 로 cross-check.

## 2. Phase 1 적재 순서

### Step 1: 메인 GET SP 적재 (★ 필수)
```bash
# archive 파일 전체 적재 (8 SP, line 1~10,574)
# Phase 1 필수: line 1546~5745 만 추출하여 적재 (메인 GET)
# 단 메모리 "원본 1바이트 변경 금지" — archive 파일 전체 적재 권장
sqlplus SCM_MGR/****@FREEPDB1 @"$NSCM_ROOT/To-be_v2_converted/07_Standalone_SP/_archive_absorbed_into_PKG/05_Standalone_SP_DMF0003.sql"
```

### Step 2: PKG_DMF0003 적재 (Bucket combo + 22 procedures)
```bash
# PKG 전체 적재 — Phase 1 검증은 P_DMF0003_GET_BUCKET_TYPE_CODE 만 사용
# Phase 2~7 진행 시 다른 SP 도 모두 컴파일 VALID 상태 유지
sqlplus SCM_MGR/****@FREEPDB1 @"$NSCM_ROOT/To-be_v2_converted/06_Packages/04_Package_PKG_DMF0003.sql"
```

### Step 3: 컴파일 상태 검증
```sql
-- 05_VERIFY/010_Object_Status_Verify.sql 사용
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS, LAST_DDL_TIME
FROM ALL_OBJECTS
WHERE OWNER='SCM_MGR'
  AND (OBJECT_NAME LIKE 'DMF0003%' OR OBJECT_NAME='PKG_DMF0003')
ORDER BY OBJECT_TYPE, OBJECT_NAME;
-- 기대: 모두 STATUS='VALID'. INVALID 발생 시 USER_ERRORS 조회.
```

## 3. Anti-Simplification 의무 점검

✅ **SP body 원본 보존** (memory `feedback_sp_body_no_rewrite`):
- archive + PKG 파일 그대로 적재 — rewrite / minimal change 모두 금지
- SP body 의 dual cursor `O_RC1 + O_RESULT_CURSOR` 이미 표준 (PKG body 검증)
- EXCEPTION WHEN OTHERS 의 dummy-open 표준 패턴 적용됨

✅ **PROC_M 정확 일치** (hook `proc-meta-signature-match`):
- 메인 GET SP signature: 22 IN + 4 OUT (archive line 1546~1574 검증)
- PROC_M 등록: 26 row (메타 SQL BLOCK 2 일치)

✅ **MSSQL→Oracle 변환 완료**:
- DATEADD → ADD_MONTHS / CHARINDEX → INSTR / GETDATE → SYSDATE / ISNULL → NVL
- PKG body + archive 모두 Oracle 19c 호환 (이미 To-Be v2 변환 완료)

## 4. 사고 회피 인벤토리

### A. 컴파일 의존성
- 메인 GET SP `DMF0003_GET_MKT_FCST_DATA` 는 다음 객체에 의존:
  - `SCM_MST_FUTURE_MKT_FCST` (메인 fact 테이블)
  - `SCM_MST_PROJECT` / `SCM_MST_ITEM` / `SCM_MST_SITE` (마스터)
  - `SCM_ADM_USER_GR_UNIT_AUTH_MPG_M` (권한)
  - 다수의 lookup table
- 부재 시 컴파일 INVALID — 사전 DDL 적재 필요

### B. row 0 사고 회피 (룰 21 §10.2 5단계 진단)
- Step 1: 메뉴 등록 확인 (BLOCK 4 MNU_M)
- Step 2: PROC_M 26 row 확인 (BLOCK 2)
- Step 3: API_M + BTN_MPG 확인 (BLOCK 5+6)
- Step 4: USER_GR_MNU_MPG 확인 (BLOCK 7)
- Step 5: SP 컴파일 VALID + 실제 row 존재 확인

### C. Bucket combo 결과 빈 경우
- `SCM_ADM_LOOKUP_MASTER_DETAIL` 의 `LOOKUP_TYPE='BUCKET_TYPE_CODE'` row 확인
- 부재 시 `02_SEED_DATA/010_Bucket_Type_Seed.sql` 적재 (다음 turn 작성)

## 5. 변경 이력

- 2026-06-07: 초기 작성. archive + PKG 적재 안내 표준 정립.
