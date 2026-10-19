# DMF0014 Excel Upload — Project/Model 검증 보정 + CUST_FCST 메저 생성 복구 (클라우드 이관)

> 마커 `[E20260929-DMF0014PRJMDL]` · `[E20260929-DMF0014CFSEQ]` · **rev2 `[E20260929-MAKECFCASE]`**

## ⭐ rev2 (2026-09-29 14:06) — 1차 적용 후 "CUST_FCST 메저가 생성되지 않음" 조치

| 항목 | 내용 |
|---|---|
| 증상 | 클라우드에 10·11 적용 후 Excel Upload [OK] 저장 → CUST_FCST 메저 미생성 (사용자 신고) |
| 원인 | `PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST` 원천 조회 `MEASURE IN ('Customer Fcst', 'CUST_FCST_EDI')` — AS-IS 리터럴 그대로. AS-IS MSSQL 은 대소문자 무시(CI)라 반영 SP 가 쓰는 **`'Customer FCST'`** 와 매칭됐으나 Oracle 은 구분 → **Excel 업로드분 전부 누락**, EDI 분만 합산. EDI 데이터가 없으면 0건 |
| 1차 검증 한계 | 1차 E2E 는 CUST_FCST "재생성 시각"만 확인했고 업로드 키의 CUST_FCST 값 유무를 확인하지 않았다 — 385행은 EDI 분뿐이었음 |
| 조치 | `UPPER(MEASURE) IN ('CUSTOMER FCST', 'CUST_FCST_EDI')` (AS-IS CI 비교 파리티 · 사용자 지시 "대소문자 상관없이 생성될 수 있도록") |
| 사내 | 14:03 적용 VALID · 의존 3객체 VALID · E2E: 업로드 키 CUST_FCST **110/120/130 생성 확인**, MAKE 대상 443 = EDI 385 + Customer FCST 58 |
| 영향 | 공용 SP — EDI 경로(`PR_DM_DNM_EDI_CALLOFF_MKT_FCST`)도 이제 Excel 분을 합산 (AS-IS 동일). 적용 후 첫 저장 시 당주 월요일 이후 **기존에 누락됐던 Excel 분이 CUST_FCST 에 합산**되어 값이 증가한다(사내 div81: 29,705 → 29,763행) |

**클라우드 rev2 적용 (1차 10·11 이미 적용된 상태 기준)** — ⚠ **QA · DEV 2곳 모두** 실행:
1. `91_DIAG_CUSTFCST_NOT_CREATED.sql` (조회 전용 — 원인 확정: [D4] JUDGE '⚠ … 대소문자 불일치')
2. `00_PRECHECK_CLOUD.sql` [H3] = `BEFORE` 확인 ([H1]/[H2] 는 `AFTER` 면 10·11 SKIP)
3. `05_BACKUP_CLOUD_SOURCE.sql` (1차에 만든 백업 테이블에 MAKE 원문만 추가)
4. `12_PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST.sql`
5. `90_VERIFY.sql` → V1·V2·V3-M PASS → 화면에서 업로드 [OK] 재저장 → `91 [D4]` JUDGE = `OK`


| 항목 | 값 |
|---|---|
| 패키지 | `DMF0014_PRJMDL_CUSTFCST_CLOUD_20260929` |
| 대상 화면 | **DMF0014 — Customer FCST Upload** / Excel Upload ([Upload] 검증 · [OK] 저장) |
| 범위 | **DB 3객체** — `PKG_DMF0014` BODY · `PR_DM_PLN_CUST_FCST_TO_MKT_FCST` · (rev2) `PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST`. FE / BE / PROC_M / API_M / 신규 MSG·LBL·MNU **없음** |
| 사내 적용 | **완료 · VALID · 오류 0** (222.110.191.243:2521/ZIOUI1 / SCM_MGR, 2026-09-29 12:21 PRJMDL · 13:11 CFSEQ) |
| 클라우드 | 1차(10·11) 적용됨(사용자 통보) · **rev2(12) 미적용** · ⚠ **QA·DEV 2곳 동시 적용 의무** |
| 원문 | 사내 USER_SOURCE 재추출 2026-09-29 13:28 (10·11 파일 1행 `SOURCE-FRESH` · 24h 초과 시 `python _build.py` 로 재빌드) |
| 선행 회차 포함 | `10_PKG_DMF0014_BODY.sql` 은 BODY 전체 — 미적용 상태일 수 있는 `DMF0014_VALMSG_CLOUD_20260923` · `DMF0014_PERIOD_BLANK_CLOUD_20260924` 의 변경도 **함께 반영됨** (그 두 패키지를 따로 적용할 필요 없음) |

---

## 1. 변경 ① — Excel Upload Project/Model 존재 검증 보정 `[E20260929-DMF0014PRJMDL]`

**증상 (사용자 지적 2026-09-29)**: "PROJECT, MODEL 명이 존재하지 않아도 VALIDATION 에 조회되지 않고 정상 처리됩니다."

| 원인 | 내용 |
|---|---|
| A | Customer Project/Model 이 고객모델 마스터(`DM_MST_CUSTOMER_MODEL`)에 없어도, 같은 행 **[Project]/[Model] 열이 `SCM_MST_SITE_ITEM` 에 있으면 통과**(품목 경로 구제) |
| B | **[Project]/[Model] 열 자체 검증 부재** — AS-IS `'Invalid Project.'`/`'Invalid Model.'` 블록이 `/* */` 사문 |

변경 (전부 `P_DMF0014_CUST_FCST_EXCEL_UPLOAD` · Division ≠ '40' 분기 — 사용자 결정 "1,2 모두 적용"):

| # | 검증 | 변경 후 판정 | 메시지 |
|---|---|---|---|
| 1 | Invalid Customer Project | 고객모델 마스터 (Div, Sales Site, Customer Project) **단독** — SITE_ITEM 구제 제거 | `Invalid Customer Project [Customer Project*: 값]` (기존) |
| 1 | Invalid Customer Model | 고객모델 마스터 정확일치 **단독** — `UNION SCM_MST_SITE_ITEM` 구제 제거 | `Invalid Customer Model [Customer Model*: 값]` (기존) |
| 2 | **Invalid Project (신설)** | [Project] 가 (Div, Sales Site) `SCM_MST_SITE_ITEM.PROJECT_CODE`(VALID_YN='Y') 에 없음 · **빈칸도 오류** | `Invalid Project [Project: 값]` |
| 2 | **Invalid Model (신설)** | [Project] 통과 행 중 (Div, Site, [Project], [Model]) SITE_ITEM 조합 없음 · 빈칸도 오류 | `Invalid Model [Model: 값]` |

- 기준 테이블 = `SCM_MST_SITE_ITEM` : [Project]/[Model] 값은 저장 시 `DM_PLN_CUSTOMER_PSI.PROJECT_CODE/ITEM_ID` 로 적재되고, 조회 시 SITE_ITEM 과 조인해 EDIT_FLAG(DEPT) 를 정한다.
- AS-IS 사문 블록(CUSTOMER_MODEL 매핑 일치 기준)은 채택하지 않고 사문 그대로 보존.
- Division 40 분기 · `P_DMF0014_CUST_FCST_EXCEL_UPLOAD_SM`(미배선) 무변경.

## 2. 변경 ② — Upload 저장 후 CUST_FCST(P+P) 메저 미생성 수정 `[E20260929-DMF0014CFSEQ]`

**AS-IS 흐름 (배치 아님)**: 팝업 [OK] → `PR_SCM_ADM_SAVE_UPLOAD_DATA` → `DMF0014_CUST_FCST_EXCEL_UPLOAD '1'` →
`DM_PLN_CUSTOMER_PSI` INSERT(`BATCH_RESULT='UI'`) → 같은 트랜잭션에서 `PR_DM_PLN_CUST_FCST_TO_MKT_FCST` →
말미 division 루프에서 `PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST(division)` = **`DM_PLN_MKT_FCST` MEASURE='CUST_FCST'** 생성 (Excel + RPA + EDI, 당주 월요일~).
Division 40 은 `_40` 반영만 하고 MAKE 미호출(AS-IS 동일).

**TO-BE 결함**: AS-IS `#TEMP_CUST_FCST_DIVISION.SEQ INT IDENTITY(0,1)` 이 GTT `GT_DPCF_CUST_FCST_DIVISION.SEQ`(일반 NUMBER) 로 이관되며 자동 채번이 빠짐
→ `INSERT (DIVISION_ID)` 만 해 SEQ NULL → `MAX(SEQ)` NULL → `WHILE 0 <= NULL` 거짓 → **MAKE_CUST_FCST 미호출**.
사내 실측: CUST_FCST(MAKE_CUST_FCST) 최종 생성 09-14 — 09-28 업로드는 'Customer FCST' 만 반영.

**수정** (정상 선례 `PR_DM_DNM_EDI_CALLOFF_MKT_FCST` L573~578 과 동일 방식):
```sql
INSERT INTO GT_DPCF_CUST_FCST_DIVISION (DIVISION_ID, SEQ)
SELECT D.DIVISION_ID, ROW_NUMBER() OVER (ORDER BY D.DIVISION_ID) - 1 AS SEQ
  FROM (SELECT DISTINCT DIVISION_ID FROM GT_DPCF_DM_PLN_CUSTOMER_PSI_2) D;
SELECT NVL(MAX(T.SEQ), -1) INTO V_CNT FROM GT_DPCF_CUST_FCST_DIVISION T;
```
대상: `PKG_DMF0014.P_PR_DM_PLN_CUST_FCST_TO_MKT_FCST`(DMF0014 업로드/저장 경로) + standalone `PR_DM_PLN_CUST_FCST_TO_MKT_FCST`(현 호출자 0 — 동일 결함 동일 수정).

---

## 3. 작업 ↔ 파일 대조표 (적용 순서)

| 순서 | 파일 | 내용 | 전제 / 판정 |
|---|---|---|---|
| 1 | [A_DB/00_PRECHECK_CLOUD.sql](A_DB/00_PRECHECK_CLOUD.sql) | READ-ONLY 선판정 | — |
| 2 | [A_DB/05_BACKUP_CLOUD_SOURCE.sql](A_DB/05_BACKUP_CLOUD_SOURCE.sql) | 클라우드 현 원문 → `BAK_SRC_DMF0014_20260929` CTAS (비파괴 · 멱등) | CREATE TABLE 권한 |
| 3 | [A_DB/10_PKG_DMF0014_BODY.sql](A_DB/10_PKG_DMF0014_BODY.sql) | PKG_DMF0014 BODY 전체 (변경 ①② + 선행 VALMSG/BLANK) | [A] MISSING 0 · [B] SEQ 컬럼 존재 · [H1] ≠ UNKNOWN |
| 4 | [A_DB/11_PR_DM_PLN_CUST_FCST_TO_MKT_FCST.sql](A_DB/11_PR_DM_PLN_CUST_FCST_TO_MKT_FCST.sql) | standalone 동일 수정 | [H2] ≠ UNKNOWN |
| 4-2 | [A_DB/12_PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST.sql](A_DB/12_PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST.sql) | **rev2** 원천 메저 대소문자 무시 비교 | [H3] = BEFORE |
| 5 | [A_DB/90_VERIFY.sql](A_DB/90_VERIFY.sql) | V1 VALID/ERR 0 · V2 지문 · V3/V3-M 마커 · V4 CUST_FCST 생성 | 조회 전용 |
| 진단 | [A_DB/91_DIAG_CUSTFCST_NOT_CREATED.sql](A_DB/91_DIAG_CUSTFCST_NOT_CREATED.sql) | CUST_FCST 미생성 원인 판정 D0~D6 | 조회 전용 |

롤백 전용 (평소 실행 안 함):
- [98_ROLLBACK_FROM_CLOUD_BACKUP.sql](A_DB/98_ROLLBACK_FROM_CLOUD_BACKUP.sql) — 2번에서 보관한 **클라우드 고유 원문**으로 재생성 (권장)
- [99_ROLLBACK_PKG_DMF0014_BODY.sql](A_DB/99_ROLLBACK_PKG_DMF0014_BODY.sql) / [99_ROLLBACK_PR_DM_PLN_CUST_FCST_TO_MKT_FCST.sql](A_DB/99_ROLLBACK_PR_DM_PLN_CUST_FCST_TO_MKT_FCST.sql) / [99_ROLLBACK_PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST.sql](A_DB/99_ROLLBACK_PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST.sql) — **사내** 이번 적용 직전본

### PRECHECK 판정표

`[H1]` PKG_DMF0014 BODY 지문 (USER_SOURCE LINE>1 의 행수, 문자합):

| 판정 | (행, 문자) | 의미 → 조치 |
|---|---|---|
| `PRE_VALMSG` | (11536, 734583) | 09-23 VALMSG 이전 → 10 적용 (VALMSG·BLANK·이번 2건 일괄 반영) |
| `VALMSG` | (11440, 743119) | VALMSG 만 적용 → 10 적용 |
| `BLANK` | (11430, 741999) | 09-24 BLANK 적용 = 사내 이번 직전 → 10 적용 |
| `PRJMDL_ONLY` | (11467, 746043) | PRJMDL 만 적용 → 10 적용 |
| `AFTER` | (11471, 746462) | 이미 적용 → SKIP |
| `⚠ UNKNOWN` | — | **클라우드 고유 변경 가능 → 적용 중단, 원문 diff 후 재병합** |

`[H2]` PR_DM_PLN_CUST_FCST_TO_MKT_FCST: `BEFORE`(2037, 101628) → 11 적용 / `AFTER`(2041, 102047) → SKIP / `⚠ UNKNOWN` → 중단.

`[H3]` PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST (rev2): `BEFORE`(225, 10078) → 12 적용 / `AFTER`(226, 10268) → SKIP / `⚠ UNKNOWN` → 중단.

사내 실측(적용 후, 2026-09-29 13:28 PRECHECK/VERIFY 실행): [H1] AFTER · [H2] AFTER · V1~V3 PASS · V3 `PKG 7/2/1/1 · PR 0/2/1/0`.

---

## 4. 사내 검증 실측

**변경 ① — 실제 BE Excel Upload E2E 24/24 PASS** (`_artifacts/_gate_reports/DMF0014_excel_upload_cases_20260929_1223.md`)

| 케이스 | 입력 | 결과 |
|---|---|---|
| 07_CPRJ | Customer Project 없음 + [Project]/[Model] 유효 | `Invalid Customer Project [Customer Project*: ZZ_PRJ]` (종전 통과) |
| 08_CMDL | Customer Model 없음 + [Project]/[Model] 유효 | `Invalid Customer Model [Customer Model*: ZZ_MODEL]` (종전 통과) |
| 17_PRJ | [Project] 없음 | `Invalid Project [Project: ZZ_PRJCODE]` (종전 통과) |
| 22_PMEMPTY | [Project]/[Model] 빈칸 | `Invalid Project [Project: (empty)]` (종전 통과) |
| 23_PMDL | [Model] 조합 없음 | `Invalid Model [Model: ZZ_ITEM]` (종전 통과) |
| 00_OK 외 19건 | 정상·기존 검증 | 기존과 동일 |

**변경 ②**
- 사전 점검: `PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST('81')` 직접 실행 25.8s 성공 → ROLLBACK 원복 확인.
- E2E: 테스트 기준키(GM_US_BQN / SGM Modified / N2.2)를 **기존 저장값과 동일 값**(0928=110 · 1005=120 · 1012=130)으로 업로드 → [OK] 저장 SUCCESS
  → `DM_PLN_MKT_FCST` CUST_FCST(MAKE_CUST_FCST) **385행 재생성**(13:16:10, 20260928~20271213). CUST_FCST / Customer FCST 전체 건수·합계 **불변**(멱등).

---

## 5. 적용 후 화면 확인 (클라우드)

1. DMF0014 → Excel Upload → Customer Project 또는 [Project] 를 없는 값으로 넣은 파일 [Upload] → 위 §1 메시지 표시
2. 정상 파일 [Upload] → [OK] 저장 → `90_VERIFY.sql [V4]` 의 해당 division `LAST_MAKE` 가 저장 시각으로 갱신

패키지 상태변수 없음 → **BE 재기동 불요**.

## 6. 주의

- **동작 변경**: 종전에 [Project]/[Model] 경로로 통과하던 행이 이제 반려된다. 예: 사내 09-28 저장분 `FCA_CA_WND / A15CR7001 / APFCAPHEV-B5-020` 은 고객모델 마스터 미등재 → `Invalid Customer Model`. 계속 써야 하는 모델은 고객모델 마스터 등록 필요.
- **저장 소요시간 증가**: Division ≠ 40 업로드 [OK] 마다 CUST_FCST 재생성이 수행된다(사내 직접 실행 25.8s / E2E 저장 0.8s — 데이터량 의존).
- AS-IS MSSQL 은 VPN 불통으로 직접 대조하지 못했다. AS-IS 흐름·IDENTITY 근거는 `Doc/_legacy_source/DB_DDL/AsIs_LGCE_SCMDEV_SP1/SP2_DDL.sql`(DEV 덤프, 05-07~08) 기준.

## 7. 사내 원복

```
cd _artifacts/_apply_corporate/DMF0014_MAKECF_CASE_20260929  && python apply_makecf.py restore   # rev2 되돌림
cd _artifacts/_apply_corporate/DMF0014_CUSTFCST_SEQ_20260929 && python apply_seq.py restore      # ② 되돌림
cd _artifacts/_apply_corporate/DMF0014_PRJMDL_CHK_20260929   && python apply_prjmdl.py restore   # ① 되돌림 (② 원복 후 실행)
```

## 8. 사내 실행 작업 ↔ 파일

| 사내 작업 (2026-09-29) | 스크립트 / 산출물 | 이 패키지 반영 |
|---|---|---|
| PKG_DMF0014 BODY PRJMDL 적용 12:21:14 | `_apply_corporate/DMF0014_PRJMDL_CHK_20260929/apply_prjmdl.py` | 10 |
| PKG_DMF0014 BODY CFSEQ 적용 13:11:25 | `_apply_corporate/DMF0014_CUSTFCST_SEQ_20260929/apply_seq.py` | 10 |
| PR_DM_PLN_CUST_FCST_TO_MKT_FCST CFSEQ 적용 13:11:27 | 동일 | 11 |
| PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST MAKECFCASE 적용 14:03:17 (rev2) | `_apply_corporate/DMF0014_MAKECF_CASE_20260929/apply_makecf.py` | 12 |
| rev2 E2E 저장(동일값 재저장) — CUST_FCST 에 누락분 합산(div81 +58행) | 데이터 변화 = 정상화 | — |
| MAKE_CUST_FCST 드라이런(ROLLBACK) · E2E 저장(동일값 재저장) | 데이터 변화 없음(멱등) | — (DDL 아님) |
| 테스트 케이스 생성기 기대값 동기화 · 22/23 케이스 추가 | `_artifacts/_diagnostics/gen_excel_upload_testcases.py` · `Doc/단위테스트/_excel_upload_cases/DMF0014/` | — (테스트 자산) |
| 권한·시노님 | 변경 없음 (CREATE OR REPLACE — 기존 GRANT 유지) | — |
