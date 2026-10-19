# DMF0042 Business Plan — 세트 첫 행 저장 시 세트 전체 0 일괄 생성 (DB 단, 클라우드 이관)

> 마커 `[E20260930-DMF0042SETZERO]` — `PKG_DMF0042.P_DMF0042_SAVE_DM_PLN_BP_FCST` (화면 [Save])

| 항목 | 값 |
|---|---|
| 범위 | **DB 전용** — `PKG_DMF0042` BODY (삽입 98줄, 기존 줄 무수정). **FE·BE·메타 변경 없음** |
| 사용자 결정 | "FE 수정 없이 DB 단에서 — SET ROW 중 최초 ROW 가 들어오면 SET 전체를 0 으로 일괄 생성하고, 이후 실제 값이 들어오면 수정" (2026-09-30) |
| 사내 적용 | **완료 · VALID · 오류 0** (ZIOUI1, 2026-09-30 18:44:08, KBJ 17:07 본 위에 FRESH-GATE 삽입) — [`_apply_corporate/DMF0042_SETZERO_20260930`](../../_apply_corporate/DMF0042_SETZERO_20260930/apply_setzero.py) |
| 클라우드 | **미적용** · ⚠ QA · DEV 2곳 모두 |
| BE 재기동 | 불요 |

## 1. 증상·원인

Insert 후 저장하면 Business_Plan·LOC·SalesAmt(LOC)·SalesAmt(KRW) 세트가 생기지 않는다 (사내 실측 `Peopleworks/202702` = LOC·SalesAmt 만, Business_Plan 없음).
- AS-IS 화면은 BP 행 + LOC 행을 **항상 2행 1조**로 보내고 빈 칸은 "0" — SP 가 LOC × BP 로 `SalesAmt_LOC`, 환율로 `SalesAmt_KRW/USD` 를 파생해 세트가 완성된다.
- TO-BE 화면은 **바뀐 셀의 메저 1행만** 보낸다. SP 의 08-24 보충(AJS, "수량만 와도 원장 LOC 복사")은 **원장에 짝이 있을 때만** 동작 → 신규 키는 짝이 없어 `LOC INSERT`(GTT `MEASURE='LOC'` 조인)가 돌지 않고 파생 3종이 만들어지지 않는다.

## 2. 조치 (삽입만 — 기존 ① 보충 INSERT 바로 뒤, `A002` 로그 직전)

| # | 조건 (I/M 행만 · 'D' 제외) | 동작 |
|---|---|---|
| ② | Business_Plan 이 왔는데 그 키·월의 LOC 가 GTT 에도 원장에도 없음 | GTT 에 **LOC = 0** |
| ④ | LOC 가 왔는데 그 키·월의 Business_Plan 이 GTT 에도 원장에도 없음 | GTT 에 **Business_Plan = 0** |

- 원장에 이미 있으면 만들지 않는다(= 실제 값 보존, "이후 실제 값이 들어오면 수정"). 뒤의 원장 삽입·SalesAmt 파생은 무수정. 삽입 지점은 NVL 키 정규화(L4338) 이후라 GTT·원장 키 표기('-')가 같다.
- 모든 키 비교 = 원장 PK 16컬럼 중 MEASURE 제외 15컬럼.

**사내 E2E (SP 직접 호출 · 40 · 테스트 행 즉시 삭제)**

| 케이스 | 입력 | 원장 결과 |
|---|---|---|
| A 신규 키 202712 | Business_Plan 123 (I) 1행 | **BP 123 · LOC 0 · SalesAmt_LOC 0 · SalesAmt_KRW 0 · SalesAmt_USD 0** (5행 세트) |
| B 같은 키 | LOC 2.5 (M) 1행 | BP 123 유지 · LOC 2.5 · SalesAmt_LOC 307.5 · KRW 427,425 · USD 307.5 (실제 값 반영) |
| C 신규 키 202711 | LOC 1.5 (I) 1행 | **BP 0** · LOC 1.5 · SalesAmt 3종 0 |
| D 202711 | Business_Plan 'D' | BP 행 삭제, 나머지 유지 (기존 'D' 동작 불변 — 0 재생성 없음) |

⚠ 화면 브라우저 E2E(Insert → 저장 → 재조회)는 미실시 — 사용자 확인 요망.

## 3. 작업 ↔ 파일 대조표 (SCM_MGR · QA → DEV 각각)

1. [A_DB/00_PRECHECK_CLOUD.sql](A_DB/00_PRECHECK_CLOUD.sql) — READ-ONLY. `[H]` **`적용`**(= 클라우드가 사내 KBJ 17:07 본과 동일) → 2·3·4 / `SKIP` 종료 / **`⚠ 11 적용 금지`** → §4 수동 삽입
2. [A_DB/05_BACKUP_CLOUD_SOURCE.sql](A_DB/05_BACKUP_CLOUD_SOURCE.sql) — 현 BODY → `BAK_SRC_DMF0042_SETZERO`
3. [A_DB/11_PKG_DMF0042_BODY.sql](A_DB/11_PKG_DMF0042_BODY.sql) — BODY 전체본 (`SHOW ERRORS` 0)
4. [A_DB/90_VERIFY.sql](A_DB/90_VERIFY.sql) — V1 VALID / V2 마커 2 / V3 GRANT
5. 화면: 40 에서 Insert → Business Plan 만 입력 후 저장 → 재조회 시 LOC 0·SalesAmt 0 이 함께 보이는지, 이후 LOC 입력 저장 시 금액이 계산되는지

롤백: [A_DB/98_ROLLBACK_FROM_CLOUD_BACKUP.sql](A_DB/98_ROLLBACK_FROM_CLOUD_BACKUP.sql)

## 4. ⚠ 타 작업자 수정 동봉 — 지문이 다르면 수동 삽입

`11` 전체본은 **AJS(08-24/08-26)·KBJ(09-30 17:07)** 의 `PKG_DMF0042` 수정을 그대로 담고 있다. 클라우드가 그 상태가 아니면(`[H]` = `⚠ 11 적용 금지`) 전체본을 덮어쓰지 말고:
- [A_DB/12_INSERT_BLOCK_FOR_MANUAL_MERGE.sql](A_DB/12_INSERT_BLOCK_FOR_MANUAL_MERGE.sql) (삽입 98줄)을 클라우드 BODY 의 **`/* 2026.08.24 AJS 수량만 와도 금액을 만들 수 있게 LOC 단가를 원장에서 보완 */` INSERT 가 끝나는 `, A.CELL_PROD_SITE;` 다음, `DBMS_OUTPUT.PUT_LINE(... ' : A002-- :' ...)` 직전**에 붙여 넣고 재컴파일 → `90_VERIFY` V2 마커 2 확인.
- 08-24 보충 INSERT 자체가 없으면(`[H]` 앵커 부재) 타 작업자 이관을 먼저 받아야 한다 — 결과 회신.

## 5. 유의

- FE 의 `qty '0' → activeFlag 'D'`(셀 값 지움 = 원장 행 삭제) 는 그대로다 — 'D' 행은 세트 생성 대상에서 제외.
- 오늘 오후 잠깐 FE 쪽(BP+LOC 짝 전송)으로 보완했다가 사용자 결정으로 **FE 는 원복**(단위테스트 11/11 원상), 본 DB 방식으로 대체.
