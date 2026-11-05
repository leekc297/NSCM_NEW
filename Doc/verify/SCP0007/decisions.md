# 결정표 — SCP0007 · 2026-10-29 14:48

> 기계가 PASS/FAIL 을 정하지 못한 15건. 각 행의 **실측**을 보고 answer 에 P(같다)/F(결함)/N(해당없음·사유) 를 적은 뒤 `python tools/Harness/verify/decisions.py SCP0007 --apply` → 원장에 수동 판정으로 반영(재실행이 덮지 않음).

> **근거 등급(2026-10-26)**: `by` 열에 답한 사람을 적는다(비우면 반영 안 함). AI(claude 등)가 답한 P·N 은 `evidence_ref`(경로:줄) + `evidence_quote`(그 줄 원문 인용)가 기계로 확인될 때만 반영하고, 확인되지 않으면 판정필요로 남는다. AI 의 F 는 보수적으로 반영한다.


| 그룹 | 건수 | 어떻게 결정하나 |
|---|---|---|
| 집계 행 — 구성 요소 검사 중 미확정이 남음(요소 결정이 끝나면 자동 확정) | 12 | 실측과 AS-IS 원문 대조 |
| 조회 결과(A1) — AS-IS dev DB 와 데이터 차이 해석 | 3 | 실측과 AS-IS 원문 대조 |

## 집계 행 — 구성 요소 검사 중 미확정이 남음(요소 결정이 끝나면 자동 확정)

| ID | 규칙 | 대상 | 실측 | answer |
|---|---|---|---|---|
| DC-SCP0007-004 | A1 | CRUD:D00-4b-001:SEARCH · [SEARCH] §4b Fi | 행 집계 — 대조표 CRUD:D00-4b-001:SEARCH '[SEARCH] §4b FindButton / toolbarOverride / Search' 의 A1 5요소: REVIEW:2 · PASS:2 · NA:1 · FAIL 요소: PKG_SCP0007.P_SCP0007_GET_BOD — golden DIFF AS- |  |
| DC-SCP0007-005 | A1 | D00-2-008 · §2 this / Load → Form_Load ( | 행 집계 — 대조표 D00-2-008 '§2 this / Load → Form_Load (InitForm·InitControls·' 의 A1 5요소: REVIEW:2 · PASS:2 · NA:1 · FAIL 요소: PKG_SCP0007.P_SCP0007_GET_BOD — golden DIFF AS-IS 6487행 ↔ TO |  |
| DC-SCP0007-006 | A1 | D00-3-009 · §3 SetCellTypeCombo / (DIVIS | 행 집계 — 대조표 D00-3-009 '§3 SetCellTypeCombo / (DIVISION_ID, dtMyDivision)' 의 A1 5요소: REVIEW:2 · PASS:2 · NA:1 · FAIL 요소: PKG_SCP0007.P_SCP0007_GET_BOD — golden DIFF AS-IS 6487행 ↔ TO- |  |
| DC-SCP0007-007 | A1 | D00-3-036 · §3 SetCellTypeCombo / (i,INC | 행 집계 — 대조표 D00-3-036 '§3 SetCellTypeCombo / (i,INCOTERMS_SSP, dtIncoterm' 의 A1 5요소: REVIEW:2 · PASS:2 · NA:1 · FAIL 요소: PKG_SCP0007.P_SCP0007_GET_BOD — golden DIFF AS-IS 6487행 ↔ TO |  |
| DC-SCP0007-008 | A1 | D00-3-040 · §3 SmartColMerge / () | 행 집계 — 대조표 D00-3-040 '§3 SmartColMerge / ()' 의 A1 5요소: REVIEW:2 · PASS:2 · NA:1 · FAIL 요소: PKG_SCP0007.P_SCP0007_GET_BOD — golden DIFF AS-IS 6487행 ↔ TO-BE 8121행: Doc/golden/SCP0007 |  |
| DC-SCP0007-009 | A1 | D00-4b-001 · §4b FindButton / toolbarOve | 행 집계 — 대조표 D00-4b-001 '§4b FindButton / toolbarOverride / Search' 의 A1 5요소: REVIEW:2 · PASS:2 · NA:1 · FAIL 요소: PKG_SCP0007.P_SCP0007_GET_BOD — golden DIFF AS-IS 6487행 ↔ TO-BE 8121 |  |
| DC-SCP0007-010 | A1 | D00-4d-003 · §4d Data_SCP.CommonAll / Fr | 행 집계 — 대조표 D00-4d-003 '§4d Data_SCP.CommonAll / FromSiteByDivision1Ex' 의 A1 5요소: REVIEW:2 · PASS:2 · NA:1 · FAIL 요소: PKG_SCP0007.P_SCP0007_GET_BOD — golden DIFF AS-IS 6487행 ↔ TO-BE |  |
| DC-SCP0007-011 | A1 | D00-4d-004 · §4d Data_SCP.CommonAll / To | 행 집계 — 대조표 D00-4d-004 '§4d Data_SCP.CommonAll / ToSiteBOD1' 의 A1 5요소: REVIEW:2 · PASS:2 · NA:1 · FAIL 요소: PKG_SCP0007.P_SCP0007_GET_BOD — golden DIFF AS-IS 6487행 ↔ TO-BE 8121행: Doc |  |
| DC-SCP0007-012 | A1 | D00-4d-005 · §4d Data_SCP.CommonAll / Fr | 행 집계 — 대조표 D00-4d-005 '§4d Data_SCP.CommonAll / FromSiteByDivision1' 의 A1 5요소: REVIEW:2 · PASS:2 · NA:1 · FAIL 요소: PKG_SCP0007.P_SCP0007_GET_BOD — golden DIFF AS-IS 6487행 ↔ TO-BE 8 |  |
| DC-SCP0007-013 | A1 | D00-4d-009 · §4d Data.Common / LookupCom | 행 집계 — 대조표 D00-4d-009 '§4d Data.Common / LookupCommon(INCOTERMS)' 의 A1 5요소: REVIEW:2 · PASS:2 · NA:1 · FAIL 요소: PKG_SCP0007.P_SCP0007_GET_BOD — golden DIFF AS-IS 6487행 ↔ TO-BE 8121 |  |
| DC-SCP0007-014 | A1 | D00-4e-005 · §4e dtFromSiteOfSpdAll / Fi | 행 집계 — 대조표 D00-4e-005 '§4e dtFromSiteOfSpdAll / FindData_Main' 의 A1 5요소: REVIEW:2 · PASS:2 · NA:1 · FAIL 요소: PKG_SCP0007.P_SCP0007_GET_BOD — golden DIFF AS-IS 6487행 ↔ TO-BE 8121행:  |  |
| DC-SCP0007-015 | A1 | D00-4e-006 · §4e dtToSiteOfSpdAll / Find | 행 집계 — 대조표 D00-4e-006 '§4e dtToSiteOfSpdAll / FindData_Main' 의 A1 5요소: REVIEW:2 · PASS:2 · NA:1 · FAIL 요소: PKG_SCP0007.P_SCP0007_GET_BOD — golden DIFF AS-IS 6487행 ↔ TO-BE 8121행: Do |  |

## 조회 결과(A1) — AS-IS dev DB 와 데이터 차이 해석

| ID | 규칙 | 대상 | 실측 | answer |
|---|---|---|---|---|
| DC-SCP0007-001 | A1 | PKG_SCP0007.P_SCP0007_GET_BOD | golden DIFF AS-IS 6487행 ↔ TO-BE 8121행: Doc/golden/SCP0007/SCP0007_GET_BOD.md — 같은 조건 건수 차이(AS-IS dev DB ≠ TO-BE DB) 해석 필요 · 데이터 기준: 공통 6438행 / AS-IS 전용 49 / TO-BE 전용 1683 (환경 데이터 차 |  |
| DC-SCP0007-002 | A1 | PKG_SCP0007.P_SCP0007_GET_COUNTRY_CITY | golden DIFF AS-IS 1415행 ↔ TO-BE 1394행: Doc/golden/SCP0007/SCP0007_GET_COUNTRY_CITY.md — 같은 조건 건수 차이(AS-IS dev DB ≠ TO-BE DB) 해석 필요 · 데이터 기준: 공통 1390행 / AS-IS 전용 25 / TO-BE 전용 4 (환경 |  |
| DC-SCP0007-003 | A1 | SCP0007 화면 | SCP0007_GET_BOD: DIFF AS-IS 6487행 ↔ TO-BE 8121행 · SCP0007_GET_COUNTRY_CITY: DIFF AS-IS 1415행 ↔ TO-BE 1394행 · SCP0007_GET_ROUTE_CNT: PASS AS-IS 1행 ↔ TO-BE 1행 · SCP0005_GET_DISTRIBUT |  |
