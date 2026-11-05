# 결정표 — SCP0100 · 2026-10-29 14:34

> 기계가 PASS/FAIL 을 정하지 못한 36건. 각 행의 **실측**을 보고 answer 에 P(같다)/F(결함)/N(해당없음·사유) 를 적은 뒤 `python tools/Harness/verify/decisions.py SCP0100 --apply` → 원장에 수동 판정으로 반영(재실행이 덮지 않음).

> **근거 등급(2026-10-26)**: `by` 열에 답한 사람을 적는다(비우면 반영 안 함). AI(claude 등)가 답한 P·N 은 `evidence_ref`(경로:줄) + `evidence_quote`(그 줄 원문 인용)가 기계로 확인될 때만 반영하고, 확인되지 않으면 판정필요로 남는다. AI 의 F 는 보수적으로 반영한다.


| 그룹 | 건수 | 어떻게 결정하나 |
|---|---|---|
| 집계 행 — 구성 요소 검사 중 미확정이 남음(요소 결정이 끝나면 자동 확정) | 28 | 실측과 AS-IS 원문 대조 |
| 조회 결과(A1) — AS-IS dev DB 와 데이터 차이 해석 | 6 | 실측과 AS-IS 원문 대조 |
| 기타 | 2 | 실측과 AS-IS 원문 대조 |

## 집계 행 — 구성 요소 검사 중 미확정이 남음(요소 결정이 끝나면 자동 확정)

| ID | 규칙 | 대상 | 실측 | answer |
|---|---|---|---|---|
| DC-SCP0100-009 | A1 | (CELL_GROUP) · `cellGroup` | 행 집계 — 대조표 (CELL_GROUP) '`cellGroup`' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP — 골든 비교 케이스 없음(COLUMN_SETUP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요; PKG_SCM0002.P_S |  |
| DC-SCP0100-010 | A1 | (세션) · — | 행 집계 — 대조표 (세션) '—' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP — 골든 비교 케이스 없음(COLUMN_SETUP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요; PKG_SCM0002.P_SCM0002_GET_ITEM —  |  |
| DC-SCP0100-011 | A1 | CA-102 · §1 [원문 무번호] FindButton / `hotke | 행 집계 — 대조표 CA-102 '§1 [원문 무번호] FindButton / `hotkeyConfig.search = ha' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP — 골든 비교 케이스 없음(COLUMN_SETUP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 |  |
| DC-SCP0100-012 | A1 | CB-108 · §2 [원문 무번호] cboDisplay / `displ | 행 집계 — 대조표 CB-108 '§2 [원문 무번호] cboDisplay / `display`' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP — 골든 비교 케이스 없음(COLUMN_SETUP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요 |  |
| DC-SCP0100-013 | A1 | CB-112 · §2 [원문 무번호] txtItemId / `itemId | 행 집계 — 대조표 CB-112 '§2 [원문 무번호] txtItemId / `itemId`' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP — 골든 비교 케이스 없음(COLUMN_SETUP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요;  |  |
| DC-SCP0100-014 | A1 | CB-114 · §2 [원문 무번호] txtProject / `proje | 행 집계 — 대조표 CB-114 '§2 [원문 무번호] txtProject / `project`' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP — 골든 비교 케이스 없음(COLUMN_SETUP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요 |  |
| DC-SCP0100-015 | A1 | COMMON:UC-03 · 컬럼 추가/제외(Column/Measure 설 | 행 집계 — 대조표 COMMON:UC-03 '컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP — 골든 비교 케이스 없음(COLUMN_SETUP — 팝업·보조 SP 는 golden_cases.csv 에  |  |
| DC-SCP0100-016 | A1 | COMMON:UC-06 · Key-in 조회조건 = 콤마 구분 다중 입력 | 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP — 골든 비교 케이스 없음(COLUMN_SETUP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파 |  |
| DC-SCP0100-017 | A1 | COMMON:UC-07 · 필터가 걸린 상태에서 재조회해도 조회되고 ** | 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP — 골든 비교 케이스 없음(COLUMN_SETUP — 팝업·보조 SP 는 golden_cases.csv 에  |  |
| DC-SCP0100-018 | A1 | CboGraphType · 미배선 | 행 집계 — 대조표 CboGraphType '미배선' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP — 골든 비교 케이스 없음(COLUMN_SETUP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요; PKG_SCM0002.P_SCM0002_G |  |
| DC-SCP0100-019 | A1 | FindButton · `hotkeyConfig.search = hand | 행 집계 — 대조표 FindButton '`hotkeyConfig.search = handleSearch`' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP — 골든 비교 케이스 없음(COLUMN_SETUP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 |  |
| DC-SCP0100-020 | A1 | SCP0100_Global_PSI_Report.AfterFindData | 진입점 집계 — 대조표 SCP0100_Global_PSI_Report.AfterFindData 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP — 골든 비교 케이스 없음(COLUMN_SETUP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요;  |  |
| DC-SCP0100-021 | A1 | cboBucket · `bucket` | 행 집계 — 대조표 cboBucket '`bucket`' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP — 골든 비교 케이스 없음(COLUMN_SETUP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요; PKG_SCM0002.P_SCM0002 |  |
| DC-SCP0100-022 | A1 | cboDisplay · `display` | 행 집계 — 대조표 cboDisplay '`display`' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP — 골든 비교 케이스 없음(COLUMN_SETUP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요; PKG_SCM0002.P_SCM00 |  |
| DC-SCP0100-023 | A1 | cboDivision · `divisionId` | 행 집계 — 대조표 cboDivision '`divisionId`' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP — 골든 비교 케이스 없음(COLUMN_SETUP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요; PKG_SCM0002.P_S |  |
| DC-SCP0100-024 | A1 | cboPlanType · `planType` | 행 집계 — 대조표 cboPlanType '`planType`' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP — 골든 비교 케이스 없음(COLUMN_SETUP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요; PKG_SCM0002.P_SCM |  |
| DC-SCP0100-025 | A1 | cboSearchLevel · `searchLevel` | 행 집계 — 대조표 cboSearchLevel '`searchLevel`' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP — 골든 비교 케이스 없음(COLUMN_SETUP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요; PKG_SCM0002 |  |
| DC-SCP0100-026 | A1 | dtpFrom · `fromYyyymmdd` | 행 집계 — 대조표 dtpFrom '`fromYyyymmdd`' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP — 골든 비교 케이스 없음(COLUMN_SETUP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요; PKG_SCM0002.P_SCM |  |
| DC-SCP0100-027 | A1 | dtpTo · `toYyyymmdd` | 행 집계 — 대조표 dtpTo '`toYyyymmdd`' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP — 골든 비교 케이스 없음(COLUMN_SETUP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요; PKG_SCM0002.P_SCM0002 |  |
| DC-SCP0100-028 | A1 | spdSearchLevel · SEARCH_LEVEL | 행 집계 — 대조표 spdSearchLevel 'SEARCH_LEVEL' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP — 골든 비교 케이스 없음(COLUMN_SETUP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요; PKG_SCM0002. |  |
| DC-SCP0100-029 | A1 | spdSearchLevelDetail · SEARCH_LEVEL_DETA | 행 집계 — 대조표 spdSearchLevelDetail 'SEARCH_LEVEL_DETAIL' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP — 골든 비교 케이스 없음(COLUMN_SETUP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요; |  |
| DC-SCP0100-030 | A1 | txtItemId · `itemId` | 행 집계 — 대조표 txtItemId '`itemId`' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP — 골든 비교 케이스 없음(COLUMN_SETUP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요; PKG_SCM0002.P_SCM0002 |  |
| DC-SCP0100-031 | A1 | txtProject · `project` | 행 집계 — 대조표 txtProject '`project`' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP — 골든 비교 케이스 없음(COLUMN_SETUP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요; PKG_SCM0002.P_SCM00 |  |
| DC-SCP0100-032 | A1 | ~~txtNickName~~ · `nickName`(잔존) | 행 집계 — 대조표 ~~txtNickName~~ '`nickName`(잔존)' 의 A1 8요소: REVIEW:8 · FAIL 요소: COLUMN_SETUP — 골든 비교 케이스 없음(COLUMN_SETUP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요; PKG_SCM00 |  |
| DC-SCP0100-033 | X-ROW | SCP0100_Global_PSI_Report.DCalendar_Valu | 진입점 집계 5검사 — NA:4 · WARN:1 |  |
| DC-SCP0100-034 | X-ROW | SCP0100_Global_PSI_Report.FindButton | 진입점 집계 3검사 — REVIEW:1 · NA:1 · PASS:1 |  |
| DC-SCP0100-035 | X-ROW | SCP0100_Global_PSI_Report.FindData | 진입점 집계 3검사 — REVIEW:1 · NA:1 · PASS:1 |  |
| DC-SCP0100-036 | X-ROW | SCP0100_Global_PSI_Report.FindDataMain | 진입점 집계 4검사 — PASS:2 · REVIEW:1 · NA:1 |  |

## 조회 결과(A1) — AS-IS dev DB 와 데이터 차이 해석

| ID | 규칙 | 대상 | 실측 | answer |
|---|---|---|---|---|
| DC-SCP0100-003 | A1 | COLUMN_SETUP | 골든 비교 케이스 없음(COLUMN_SETUP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  |
| DC-SCP0100-004 | A1 | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISI | 골든 비교 케이스 없음(PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  |
| DC-SCP0100-005 | A1 | PKG_SCM0002.P_SCM0002_GET_PROJECT_BY_DIV | 골든 비교 케이스 없음(PKG_SCM0002.P_SCM0002_GET_PROJECT_BY_DIVISION_POPUP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  |
| DC-SCP0100-006 | A1 | PKG_SCP0100.P_SCP0100_GET_GLOBAL_PSI_REP | 골든 비교 케이스 없음(PKG_SCP0100.P_SCP0100_GET_GLOBAL_PSI_REPORT — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  |
| DC-SCP0100-007 | A1 | P_CHK_AS | 골든 비교 케이스 없음(P_CHK_AS — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  |
| DC-SCP0100-008 | A1 | P_CHK_CELL_QTY | 골든 비교 케이스 없음(P_CHK_CELL_QTY — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  |

## 기타

| ID | 규칙 | 대상 | 실측 | answer |
|---|---|---|---|---|
| DC-SCP0100-001 | A1 | PKG_SCP0100.P_SCP0100_GET_PLAN_DATE | golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0100/SCP0100_GET_PLAN_DATE.md — 파라미터 미정 |  |
| DC-SCP0100-002 | A1 | PKG_SCP0100.P_SCP0100_GET_SITE | golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0100/SCP0100_GET_SITE.md — 파라미터 미정 |  |
