# DMF0082 FCST&Price — 환율 없는 기간도 KRW·USD 를 0 으로 함께 생성 (DB 단, 클라우드 이관 · 누적본)

> 마커 `[E20260930-DMF0082FXZERO]` — `PKG_DMF0082` BODY 2 프로시저 (LOC 저장 · Batch Price Input(SavePricePeriodModal) = `P_DMF0082_SAVE_MAIN_DATA` 1본 / Excel Upload = `P_DMF0082_EXCEL_UPLOAD`) · DMF0020 FXZERO([`DMF0020_FXZERO_CLOUD_20260930`](../DMF0020_FXZERO_CLOUD_20260930/00_README.md)) 의 DMF0082 판

| 항목 | 값 |
|---|---|
| 범위 | **DB 전용** — `PKG_DMF0082` BODY 교체 10줄(원문은 `--[E20260930-DMF0082FXZERO] 원문:` 주석으로 보존). SPEC·FE·BE·메타·GTT 변경 없음 |
| 사내 적용 | **완료 · VALID · 오류 0** (ZIOUI1, 2026-09-30 21:19:15, 기반 = CUSTEXCEL 누적본 20:59:46) — [`_apply_corporate/DMF0082_FXZERO_20260930/apply_fxzero82.py`](../../_apply_corporate/DMF0082_FXZERO_20260930/apply_fxzero82.py) |
| 클라우드 | **미적용** · ⚠ QA · DEV 2곳 모두 |
| 전제 | 클라우드 BODY = [`DMF0082_CUSTEXCEL_CLOUD_20260930`](../DMF0082_CUSTEXCEL_CLOUD_20260930/00_README.md) 적용본 (지문 `16375/843903`). PRECHECK `[H]` 로 판정 |
| BE 재기동 | 불요 |

## 1. 현상 · 원인 (사용자 지시 2026-09-30 "LOC 저장, EXCEL UPLOAD, BATCH PRICE INPUT 3개 — 환율이 없어도 3개 SET 이 일괄 저장")

| 경로 | 기존 동작 | 원인 |
|---|---|---|
| LOC 저장 · Batch Price Input (`P_DMF0082_SAVE_MAIN_DATA`, FE 는 LOC 행만 전송) | KRW = LOC × EX.EXCHANGE_PRICE (LEFT JOIN → 환율 없으면 **NULL**), USD = KRW ÷ USD환율 (NULL) → Phase1 DELETE(`QTY_PRICE = 0`) 도 Phase2 MERGE(`QTY_PRICE <> 0`) 도 NULL 은 해당 없음 → KRW·USD 행 미생성. 40(DM_PLN_CFM_SELLING_PRICE)·81(SCM_MST_FUTURE_PRICE) 두 분기 동일 | AS-IS `DMF0082_SAVE_MAIN_DATA` L1640/1656/1872/1880 동일 구조 — 의도적 이탈 |
| Excel Upload (`P_DMF0082_EXCEL_UPLOAD` 5-4/5-5, 81 전용) | `GT_F020_EXCH` 와 **INNER JOIN** → 환율 없는 달은 KRW/USD 파생 행 자체가 없음 | DMF0020 Excel 이식분(AS-IS DMF0082_EXCEL_UPLOAD 는 MKT_FCST 전용) — DMF0020 과 동일 정정 |

## 2. 변경 (12 파일 = 10줄 전문)

- **SAVE_MAIN 파생** (L14121·14135): KRW = LOC × `NVL(환율,0)` / USD = USD환율 없으면 (통화 USD 면 LOC 그대로, 아니면 0), 있으면 KRW ÷ USD환율.
- **SAVE_MAIN Phase1 DELETE** (40 L14368 · 81 L14425): `QTY_PRICE = 0` 이어도 **같은 세트의 LOC 가 0 이 아니면** KRW/USD 는 삭제 대상에서 제외 (환율 없어 0 이 된 것 ≠ 삭제 의도 0).
- **SAVE_MAIN Phase2 MERGE** (40 L14384 · 81 L14441): `QTY_PRICE <> 0` **또는** (KRW/USD 이고 같은 세트의 LOC 가 0 아님) → 0 으로 저장. LOC=0(삭제 의도) 세트의 KRW/USD 0 은 종전대로 삭제.
- **EXCEL 5-4/5-5** (L6295·6299·6314·6318): `LEFT JOIN GT_F020_EXCH` + NVL/CASE (DMF0020 과 동일).
- 세트 키 = 40: DIVISION/PROJECT/END_CUSTOMER/SCM_SITE/PLANT_SITE/CELL_PROD_SITE/ITEM/YYYYMMDD/DOM_EXP/FCST_TYPE/INCOTERMS (11) · 81: END_CUSTOMER/CELL_PROD 제외 (9). GT_PRDM1_T_MAIN 키 13컬럼은 DEFAULT ON NULL '-' NOT NULL 이라 등치 비교 안전.
- 이력(`_H`)·MKT_AMT(40) 는 이미 `NVL(QTY_PRICE,0)` 이라 변경 없음.

**사내 E2E** (적용 후 · 81 실키 A15PE4001 / Porsche_DE_SHM / WA00-P / AMPAGJ1PA-B1-010 / E / MPS / FCA / **USD** · 원장에 없는 버킷만 사용 · 종료 후 내 행 삭제)

| # | 경로 | 입력 | 결과 |
|---|---|---|---|
| S1 | LOC 저장 (`SAVE_MAIN`, I) | 환율 없는 20271101 · LOC 10 | KRW **0** / LOC 10 / USD **10**(통화 USD 는 LOC 그대로) — 3행 생성 |
| S2 | LOC 저장 (I) | 환율 있는 20270802 (USD 1,400) · LOC 10 | KRW 14,000 / LOC 10 / USD 10 |
| S3 | LOC 수정 (M) | 20271101 LOC 12 (환율 없음) | KRW **0** 유지 / LOC 12 / USD 12 — 세트 유지 |
| S4 | LOC 삭제 (D, 0) | 20271101 | 3행 **전부 삭제** (삭제 의도 0 은 종전 동작 유지) |
| X | Excel 5-4/5-5 파생문 | 세션 GTT 드라이런 EUR 202708(1,620)·202711 | 202708 KRW 16,200 / USD 11.571 · 202711 KRW 0 / USD 0 |

⚠ S2·S3·S4 는 원장 DML(커밋) 후 81 후속 ② BALANCE CALL(`PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE`) 의 `DELETE FROM GT_PRDM2_MF_BALANCE_MKT_FCST` 에서 `undo segment extension`(SMON ← CKPT `enq: CR - block range reuse ckpt`) 대기로 8~16분+ 정지(S3/S4 는 클라이언트 480초 타임아웃) — 사내 인스턴스 체크포인트 대기이며 본 변경과 무관(S1 은 8초 내 완료, 원장 결과는 모두 기대값). Batch Price Input 은 같은 SP 라 별도 호출 없음. Excel Upload 는 파생문만 검증(브라우저 E2E 없음). 테스트 행은 종료 후 삭제(원장 3 · 이력 12, 잔여 0).

## 3. 작업 ↔ 파일 대조표 (SCM_MGR · QA → DEV 각각)

1. [A_DB/00_PRECHECK_CLOUD.sql](A_DB/00_PRECHECK_CLOUD.sql) — `[H0]` SPEC·BODY VALID · `[H]` BODY 지문 **`적용`**(16375/843903 = CUSTEXCEL 적용본) / `SKIP` / `⚠` → §4
2. [A_DB/05_BACKUP_CLOUD_SOURCE.sql](A_DB/05_BACKUP_CLOUD_SOURCE.sql) — 현 SPEC+BODY → `BAK_SRC_DMF0082_FXZERO`
3. [A_DB/11_PKG_DMF0082_BODY.sql](A_DB/11_PKG_DMF0082_BODY.sql) — BODY 전체본 (사내 21:19:15 원문, 지문 16390/847373 · CUSTEXCEL 까지의 09-30 회차 누적)
4. [A_DB/13_RECOMPILE_DEPENDENTS.sql](A_DB/13_RECOMPILE_DEPENDENTS.sql) — 의존 INVALID 재컴파일 안전망 (사내 의존 0)
5. [A_DB/90_VERIFY.sql](A_DB/90_VERIFY.sql) — V1 VALID / V2 원문주석 10 · Excel INNER JOIN 활성 0 · 구 Phase2 조건 활성 0 / V3 GRANT / V4 의존 INVALID 0 (사내 실행 전부 PASS)
6. 화면: 환율 없는 미래 월에 LOC 만 입력 → 저장 · Price Batch Input · Excel Upload 각각 → KRW 0 / USD 0 행 동반 생성 확인. LOC 를 0/삭제하면 3행 모두 삭제되는 종전 동작 확인

롤백: [A_DB/98_ROLLBACK_FROM_CLOUD_BACKUP.sql](A_DB/98_ROLLBACK_FROM_CLOUD_BACKUP.sql) → 13

## 4. 지문이 다르면 수동 반영

[A_DB/12_CHANGE_BLOCK_FOR_MANUAL_MERGE.sql](A_DB/12_CHANGE_BLOCK_FOR_MANUAL_MERGE.sql): 10개 교체 줄(각 `-- L#####` 앵커 = 사내 원문 행번호, `원문:` 주석 아래 줄이 새 줄; Phase1/Phase2 는 1줄 → 2줄) 반영 후 재컴파일 → `90_VERIFY` V2. CUSTEXCEL 누적본이 미적용인 DB 라면 먼저 그 패키지부터.
