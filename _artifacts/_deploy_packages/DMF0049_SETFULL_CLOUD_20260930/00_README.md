# DMF0049 ETC Sales Reports — 메저 세트(3행) 항상 온전히 저장 (DB 단, 클라우드 이관)

> 마커 `[E20260930-DMF0049SETFULL]` — `PKG_DMF0049.P_DMF0049_SAVE_SALES_ETC_REPORT_C` (화면 [Save])

| 항목 | 값 |
|---|---|
| 범위 | **DB 전용** — `PKG_DMF0049` BODY ((a) 2줄 주석화 + (b) 삽입 62줄). **FE·BE·메타 변경 없음** |
| 사용자 지시 | "Insert 시 3개 ROW 가 생성되고, 값을 1개 ROW 에만 입력해도 3개 ROW 가 항상 같이 저장. FE 수정 없이 DB 단에서." (2026-09-30, 화면 = DMF0049 확인) |
| 사내 적용 | **완료 · VALID · 오류 0** (ZIOUI1, 2026-09-30 19:30:25, 15:46 본 위 FRESH-GATE) — [`_apply_corporate/DMF0049_SETFULL_20260930`](../../_apply_corporate/DMF0049_SETFULL_20260930/apply_setfull.py) |
| 클라우드 | **미적용** · ⚠ QA · DEV 2곳 모두 |
| BE 재기동 | 불요 |

## 1. 증상·원인

40 사업부 세트 = `SalesAmt_LOC · SalesAmt_KRW · RTF_SYS_RP` 3행(`P_DMF0049_GET_MEASURE`). Insert 후 값 1개만 넣고 저장하면 2행만 남는다 (사내 원장 실측: qjastar 세트 전부 `SalesAmt_KRW`·`SalesAmt_LOC` 2행뿐, `RTF_SYS_RP` 없음).
- FE 는 AS-IS SaveData 와 같이 **세트 × 월 × 세트 내 3행**을 모두 보낸다(빈 칸 0).
- 저장 SP 의 AS-IS 규칙 [C20210125-000207] "40사업부 RTF Measure 없으면 Row 삭제" — `DELETE ... MEASURE='RTF_SYS_RP' AND ACTIVE_FLAG='I' AND QTY='0'` 가 Insert 시 RTF 0 행을 버린다. 한 번 2행이 된 세트는 화면도 2행이라 이후 저장에서도 2행이다.

## 2. 조치 (사용자 지시로 AS-IS 규칙 폐지 + 세트 보충)

| # | 변경 | 내용 |
|---|---|---|
| (a) | [C20210125-000207] DELETE 2줄 `--` 비활성 | RTF_SYS_RP 0 행도 세트로 저장 |
| (b) | 세트 보충 INSERT 신설 (파싱·정규화 직후, LOC 단가 파생 앞) | GTT 의 세트(식별 33컬럼 + 월 동일, 'D' 제외)마다 division 메저 목록(`SCM_MST_SHEET_MEASURE` DMF0049 'MDF Reports' × `INSTR(DIVISION_ID)` — GET_MEASURE 와 같은 원천·필터)에 있는데 GTT 에 없는 메저를 QTY '0' 으로 채움. **원장에 그 세트·월·메저가 이미 있으면 보충하지 않음**(수정 경로에서 실제 값 보존). NULL-safe 비교(DECODE) |

기존 2행 세트는 다음 저장 때 3행으로 복구된다. 뒤 흐름(LOC 단가 파생·중복 검증·원장 삭제/삽입·이력) 무수정.

**사내 E2E** (SP 직접 호출 · `R_S_20260604_V001/40` · 테스트 세트 `CUST_REPORT='ZZ_TEST'` · 즉시 삭제)

| 케이스 | 입력 | 원장 결과 |
|---|---|---|
| A 신규 세트 | LOC 100 · KRW 0 · RTF 0 (I, 3행) | **RTF 0 · KRW 0 · LOC 100 — 3행** (종전: RTF 삭제 → 2행) |
| C 같은 세트 수정 | KRW 7 · LOC 100 · RTF 0 (M, 3행) | RTF 0 · KRW 7 · LOC 100 |
| D 같은 세트 수정 | KRW 9 (M, **1행만**) | KRW 9 · **LOC 100 보존** · RTF 0 (보충 0 이 실제 값을 덮지 않음) |
| B 신규 세트 | LOC 50 (I, **1행만**) | **RTF 0 · KRW 0 · LOC 50 — 3행 보충** |

⚠ 화면 브라우저 E2E(Insert → 1행 입력 → 저장 → 재조회 3행)는 미실시 — 사용자 확인 요망.

## 3. 작업 ↔ 파일 대조표 (SCM_MGR · QA → DEV 각각)

1. [A_DB/00_PRECHECK_CLOUD.sql](A_DB/00_PRECHECK_CLOUD.sql) — READ-ONLY. `[H]` **`적용`**(= 사내 15:46 본과 동일) → 2·3·4 / `SKIP` / **`⚠ 11 적용 금지`** → §4
2. [A_DB/05_BACKUP_CLOUD_SOURCE.sql](A_DB/05_BACKUP_CLOUD_SOURCE.sql) — 현 BODY → `BAK_SRC_DMF0049_SETFULL`
3. [A_DB/11_PKG_DMF0049_BODY.sql](A_DB/11_PKG_DMF0049_BODY.sql) — BODY 전체본 (`SHOW ERRORS` 0)
4. [A_DB/90_VERIFY.sql](A_DB/90_VERIFY.sql) — V1 VALID / V2 마커 3 · 활성 RTF 삭제 0 / V3 GRANT
5. 화면: 40 에서 Insert → SalesAmt(LOC) 만 입력 → 저장 → 재조회 시 3행(KRW 0 · RTF 0 포함) 확인

롤백: [A_DB/98_ROLLBACK_FROM_CLOUD_BACKUP.sql](A_DB/98_ROLLBACK_FROM_CLOUD_BACKUP.sql)

## 4. 지문이 다르면 수동 반영

`11` 은 사내 09-30 15:46 본(타 작업자 변경 포함 가능) 위에 만든 전체본이다. `[H]` = `⚠ 11 적용 금지` 이면 [A_DB/12_CHANGE_BLOCK_FOR_MANUAL_MERGE.sql](A_DB/12_CHANGE_BLOCK_FOR_MANUAL_MERGE.sql) 대로 — (a) `--[C20210125-000207] 40사업부 RTF Measure 없으면 Row 삭제` 아래 DELETE 2줄을 `--` 처리, (b) 삽입 블록을 `--Start [C20210125-000207] 40사업부 Unit Price Measure 추가` 바로 앞에 붙여 재컴파일 → `90_VERIFY` V2.

## 5. 유의

- AS-IS 와의 차이(의도된): AS-IS 는 40 RTF 0 행을 Insert 시 버렸으나, 사용자 지시로 세트 3행을 항상 유지한다. 81 계열(2행)·82(1행)도 같은 보충 규칙이 적용된다(메저 목록 원천 동일).
- 세트에 값이 전혀 없는 월은 FE 가 보내지 않으므로(채택월 규칙) 보충 대상이 아니다 — "값이 하나라도 있는 월"만 3행이 된다.
