# DMF0020 Sales Price — 환율 없는 기간도 KRW·USD 를 0 으로 함께 생성 (DB 단, 클라우드 이관)

> 마커 `[E20260930-DMF0020FXZERO]` — `PKG_DMF0020` BODY 3 경로 (저장 `P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_ALL` · Excel Upload `P_DMF0020_EXCEL_UPLOAD` · Batch Input `P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP`)

| 항목 | 값 |
|---|---|
| 범위 | **DB 전용** — `PKG_DMF0020` BODY. 교체 8줄(원문은 `--[E20260930-DMF0020FXZERO] 원문:` 주석으로 보존) + 저장 경로 보충 INSERT 2블록. FE·BE·메타·GTT 변경 없음 |
| 사내 적용 | **완료 · VALID · 오류 0** (ZIOUI1, 2026-09-30 20:29:24, 기반 LAST_DDL 19:25:07) — [`_apply_corporate/DMF0020_FXZERO_20260930/apply_fxzero.py`](../../_apply_corporate/DMF0020_FXZERO_20260930/apply_fxzero.py) |
| 클라우드 | **미적용** · ⚠ QA · DEV 2곳 모두 |
| BE 재기동 | 불요 |

## 1. 현상 · 원인 (사용자 지시 2026-09-30 "저장, EXCEL UPLOAD, BATCH INPUT 동일 적용")

환율(`DM_MST_EXCHANGE_RATE`, CURRENCY='KRW', 월초일)이 없는 기간에 LOC 를 저장하면 KRW·USD 행이 생성되지 않는다.

| 경로 | 기존 동작 | 원인 |
|---|---|---|
| Excel Upload (5-4 KRW · 5-5 USD 파생) | 환율 임시표 `GT_F020_EXCH` 와 **INNER JOIN** → 환율 없는 달은 KRW/USD 파생 행 자체가 없음 | AS-IS 동일 (INNER JOIN) — 의도적 이탈 |
| Batch Input (POPUP, KRW · USD 파생) | `GT_DMF0020_EXCH` 와 **INNER JOIN** → 동일 | AS-IS 동일 — 의도적 이탈 |
| 저장 (ALL) | FE 가 LOC/KRW/USD 3쌍을 보내며 환율 없으면 KRW/USD=0 으로 보냄(09-09 GBP 증적) → 정상. 다만 SP 는 3쌍 미충족 시 MSG00452 로 거부하므로, 어떤 이유로든 LOC 만 오면 저장 자체가 실패 | SP 측 보충 없음 |

## 2. 변경 (12 파일 = 이 블록 전문)

- **Excel 5-4/5-5**: `LEFT JOIN GT_F020_EXCH B`, KRW=`ROUND(LOC*NVL(환율,0),3)`, USD=`CASE WHEN NVL(환율,0)=0 THEN 0 ELSE ROUND(LOC/환율,3) END`.
- **Batch Input**: `LEFT JOIN GT_DMF0020_EXCH B`, 동일 NVL/CASE.
- **저장 ALL**: 3쌍 검증(`--[E20250306-001052]`) **직전**에 `GT_FCSV_RESULTS_MST` 로 KRW·USD 보충 INSERT 2블록 — 같은 10키(DIVISION/PROJECT/SCM_SITE/PLANT_SITE/ITEM/YYYYMMDD/CURRENCY/DOM_EXP/FCST_TYPE/INCOTERMS, NULL-safe DECODE)에 KRW(또는 USD)가 없으면 LOC 행에서 파생. 환율 = `DM_MST_EXCHANGE_RATE` (CURRENCY='KRW', YYYYMMDD=월초일), 없으면 0. 이미 있는 KRW/USD 행은 보존.
- 저장 경로 division 40 거부·3쌍 검증 로직은 그대로 (보충 후 검증을 통과하게 됨).

**사내 E2E** (적용 후 · 81/EUR 실키 · 테스트 행 즉시 삭제)

| # | 경로 | 입력 | 결과 |
|---|---|---|---|
| B1 | Batch Input | 환율 없는 202711 · LOC 10 | KRW 0 / LOC 10 / USD 0 (3행) |
| B2 | Batch Input | 환율 있는 202703 · LOC 10 | KRW 16200 / USD 11.571 |
| S1 | 저장 ALL | 환율 없는 202711 · LOC 12 만 (3쌍 아님) | SUCCESS · KRW 0 / LOC 12 / USD 0 |
| S2 | 저장 ALL | 환율 있는 202703 · LOC 12 만 | KRW 19440 / USD 13.886 |
| S3 | 저장 ALL | 정상 3쌍 (KRW/USD=0) | 정상 |
| X | Excel 5-4/5-5 파생문 | 세션 GTT 드라이런 202703·202711 | 202703 KRW 16200/USD 11.571 · 202711 KRW 0/USD 0 |

⚠ Excel Upload 는 파일 업로드 전 구간(스테이징) 없이 파생 INSERT 문만 세션 GTT 로 검증했고, 화면(브라우저) E2E 는 하지 않았다. 클라우드 적용 후 §3-5 화면 확인 필요.

## 2.5 ⚠ 클라우드 1차 적용 실패 (2026-09-30 21:0x) — SPEC 구세대

11 적용 시 `PLS-00313: P_PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW_SINGLE 선언되지 않음` (7121·8029행) → **BODY INVALID 상태**. 원인 = 클라우드 `PKG_DMF0020` **SPEC** 이 09-15 UIPKG 취합 이전 세대라 BODY 뒤쪽(9189행)에 정의된 그 프로시저의 선언이 없음 (사내 SPEC 09-28 16:23:39 = 09-15 취합 SPEC 과 동일, 21 프로시저). BODY 는 SPEC 선언에 의존하므로 SPEC 을 먼저 맞춰야 한다.

**지금 클라우드에서 할 일 (QA·DEV 각각)**: `06` → `10` → `11`(재실행) → `13` → `90`. 00 을 다시 돌리면 `[H0]` 가 `⚠ SPEC 구세대`, `[H0-1]` 가 0 rows 인지 먼저 확인 (1건이라도 있으면 10 적용 전 회신 — 클라우드에만 있는 프로시저를 호출하는 곳이 있을 수 있음).

## 3. 작업 ↔ 파일 대조표 (SCM_MGR · QA → DEV 각각)

1. [A_DB/00_PRECHECK_CLOUD.sql](A_DB/00_PRECHECK_CLOUD.sql) — `[H0]` SPEC 판정(`SPEC OK` / `⚠ SPEC 구세대`) · `[H0-1]` 클라우드 전용 프로시저 0 rows · `[H]` BODY 지문 **`적용`**(10111/479983 = 사내 19:25:07 본) / `SKIP` / `⚠` → §4
2. [A_DB/05_BACKUP_CLOUD_SOURCE.sql](A_DB/05_BACKUP_CLOUD_SOURCE.sql) — 현 SPEC+BODY → `BAK_SRC_DMF0020_FXZERO` (멱등 · 이미 구버전으로 실행했으면 BODY 만 보관됨 → 다음 06)
3. [A_DB/06_BACKUP_CLOUD_SPEC.sql](A_DB/06_BACKUP_CLOUD_SPEC.sql) — `[H0]` ⚠ 이고 05 를 이미 실행한 DB 에서만: 현 SPEC → `BAK_SRC_DMF0020_FXZERO_SPEC`
4. [A_DB/10_PKG_DMF0020_SPEC.sql](A_DB/10_PKG_DMF0020_SPEC.sql) — `[H0]` ⚠ 일 때만: SPEC 전체본 (사내 09-28 16:23:39 원문) — 의존 객체가 INVALID 로 바뀌므로 13 필수
5. [A_DB/11_PKG_DMF0020_BODY.sql](A_DB/11_PKG_DMF0020_BODY.sql) — BODY 전체본 (사내 20:29:24 원문, 지문 10165/485652)
6. [A_DB/13_RECOMPILE_DEPENDENTS.sql](A_DB/13_RECOMPILE_DEPENDENTS.sql) — PKG_DMF0020 SPEC 의존 INVALID 객체 재컴파일 (사내 의존 6: PKG_DMF0000/0020/0082 BODY · DMF0020_SAVE_*_ALL/_POPUP 래퍼 · PR_SCM_MST_EXCHANGE_RATE — 클라우드에 없는 것은 자동 건너뜀). 사내 실행: PKG_DMF0082 BODY · DMF0020_SAVE_..._ALL 2건 OK → 6/6 VALID
7. [A_DB/90_VERIFY.sql](A_DB/90_VERIFY.sql) — V1 SPEC·BODY VALID / V2 원문주석 8 · 블록 2 · 환율 INNER JOIN 활성 0 / V3 GRANT / V4 SPEC 선언 1 · 의존 INVALID 0 (사내 실행 전부 PASS)
8. 화면: 환율 없는 미래 월에 LOC 만 입력 → 저장 · Batch Input · Excel Upload 각각 → KRW 0 / USD 0 행 동반 생성 확인

롤백: [A_DB/98_ROLLBACK_FROM_CLOUD_BACKUP.sql](A_DB/98_ROLLBACK_FROM_CLOUD_BACKUP.sql) (05 보관본의 SPEC→BODY 순 복원, SPEC 보관이 없으면 BODY 만) → 13

## 4. 지문이 다르면 수동 반영

[A_DB/12_CHANGE_BLOCK_FOR_MANUAL_MERGE.sql](A_DB/12_CHANGE_BLOCK_FOR_MANUAL_MERGE.sql): 8개 교체 줄(각 `-- L####` 앵커 = 사내 원문 행번호, `원문:` 주석 아래 줄이 새 줄)과 저장 경로 보충 2블록(3쌍 검증 `--[E20250306-001052]` 주석 직전 삽입)을 반영 후 재컴파일 → `90_VERIFY` V2.
