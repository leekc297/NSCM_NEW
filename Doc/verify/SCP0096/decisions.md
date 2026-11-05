# 결정표 — SCP0096 · 2026-10-29 14:32

> 기계가 PASS/FAIL 을 정하지 못한 18건. 각 행의 **실측**을 보고 answer 에 P(같다)/F(결함)/N(해당없음·사유) 를 적은 뒤 `python tools/Harness/verify/decisions.py SCP0096 --apply` → 원장에 수동 판정으로 반영(재실행이 덮지 않음).

> **근거 등급(2026-10-26)**: `by` 열에 답한 사람을 적는다(비우면 반영 안 함). AI(claude 등)가 답한 P·N 은 `evidence_ref`(경로:줄) + `evidence_quote`(그 줄 원문 인용)가 기계로 확인될 때만 반영하고, 확인되지 않으면 판정필요로 남는다. AI 의 F 는 보수적으로 반영한다.


| 그룹 | 건수 | 어떻게 결정하나 |
|---|---|---|
| 집계 행 — 구성 요소 검사 중 미확정이 남음(요소 결정이 끝나면 자동 확정) | 15 | 실측과 AS-IS 원문 대조 |
| 기타 | 2 | 실측과 AS-IS 원문 대조 |
| 조회 결과(A1) — AS-IS dev DB 와 데이터 차이 해석 | 1 | 실측과 AS-IS 원문 대조 |

## 집계 행 — 구성 요소 검사 중 미확정이 남음(요소 결정이 끝나면 자동 확정)

| ID | 규칙 | 대상 | 실측 | answer |
|---|---|---|---|---|
| DC-SCP0096-004 | A1 | COMMON:UC-02 · 수정 중 재조회 시 confirm (MSG00 | 행 집계 — 대조표 COMMON:UC-02 '수정 중 재조회 시 confirm (MSG00703)' 의 A1 3요소: REVIEW:3 · FAIL 요소: PKG_COM0000.P_SCP0009_GET_SHEE — golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0096/SCP0009 |  |
| DC-SCP0096-005 | A1 | COMMON:UC-03 · 컬럼 설정 적용 시 Reset 후 재조회 | 행 집계 — 대조표 COMMON:UC-03 '컬럼 설정 적용 시 Reset 후 재조회' 의 A1 3요소: REVIEW:3 · FAIL 요소: PKG_COM0000.P_SCP0009_GET_SHEE — golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0096/SCP0009_GET_SH |  |
| DC-SCP0096-006 | A1 | COMMON:UC-06 · Key-in 조회조건 콤마 다중 입력 전건 조 | 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 콤마 다중 입력 전건 조회' 의 A1 3요소: REVIEW:3 · FAIL 요소: PKG_COM0000.P_SCP0009_GET_SHEE — golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0096/SCP0009_GE |  |
| DC-SCP0096-007 | A1 | COMMON:UC-07 · 필터 걸린 상태 재조회 시 필터 유지 (reb | 행 집계 — 대조표 COMMON:UC-07 '필터 걸린 상태 재조회 시 필터 유지 (rebindFilterColumns)' 의 A1 3요소: REVIEW:3 · FAIL 요소: PKG_COM0000.P_SCP0009_GET_SHEE — golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SC |  |
| DC-SCP0096-008 | A1 | CRUD:SEARCH · Main 조회(FindData_Main) | 행 집계 — 대조표 CRUD:SEARCH 'Main 조회(FindData_Main)' 의 A1 3요소: REVIEW:3 · FAIL 요소: PKG_COM0000.P_SCP0009_GET_SHEE — golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0096/SCP0009_GET_SHE |  |
| DC-SCP0096-009 | A1 | D00-1-010 · §1 usrConditionPanel1 / UsrC | 행 집계 — 대조표 D00-1-010 '§1 usrConditionPanel1 / UsrConditionPanel' 의 A1 3요소: REVIEW:3 · FAIL 요소: PKG_COM0000.P_SCP0009_GET_SHEE — golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP009 |  |
| DC-SCP0096-010 | A1 | D00-1-011 · §1 usrButton1 / UsrButton | 행 집계 — 대조표 D00-1-011 '§1 usrButton1 / UsrButton' 의 A1 3요소: REVIEW:3 · FAIL 요소: PKG_COM0000.P_SCP0009_GET_SHEE — golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0096/SCP0009_GET_SH |  |
| DC-SCP0096-011 | A1 | D00-3-021 · §3 Query / 470 (FindData_Mai | 행 집계 — 대조표 D00-3-021 '§3 Query / 470 (FindData_Main 조회)' 의 A1 3요소: REVIEW:3 · FAIL 요소: PKG_COM0000.P_SCP0009_GET_SHEE — golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0096/SCP000 |  |
| DC-SCP0096-012 | A1 | D00-3-023 · §3 SmartColMerge / 477 (조회 후 | 행 집계 — 대조표 D00-3-023 '§3 SmartColMerge / 477 (조회 후 재병합)' 의 A1 3요소: REVIEW:3 · FAIL 요소: PKG_COM0000.P_SCP0009_GET_SHEE — golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0096/SCP000 |  |
| DC-SCP0096-013 | A1 | D00-3-024 · §3 Get / 683 (Columns.Get(0) | 행 집계 — 대조표 D00-3-024 '§3 Get / 683 (Columns.Get(0).Visible 조회 전 차단)' 의 A1 3요소: REVIEW:3 · FAIL 요소: PKG_COM0000.P_SCP0009_GET_SHEE — golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SC |  |
| DC-SCP0096-014 | A1 | D00-3-026 · §3 GetModelColumnFromViewCol | 행 집계 — 대조표 D00-3-026 '§3 GetModelColumnFromViewColumn / 735' 의 A1 3요소: REVIEW:3 · FAIL 요소: PKG_COM0000.P_SCP0009_GET_SHEE — golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0096/SC |  |
| DC-SCP0096-015 | A1 | D00-4b-004 · §4b Data_SCP.Common / Plant | 행 집계 — 대조표 D00-4b-004 '§4b Data_SCP.Common / PlantByDivisionOperOsp3 / dt' 의 A1 3요소: REVIEW:3 · FAIL 요소: PKG_COM0000.P_SCP0009_GET_SHEE — golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/gol |  |
| DC-SCP0096-016 | A1 | D00-4d-001 · §4d BtnInput_Click 가드 #1 조회 | 행 집계 — 대조표 D00-4d-001 '§4d BtnInput_Click 가드 #1 조회 전(MSG00135)' 의 A1 3요소: REVIEW:3 · FAIL 요소: PKG_COM0000.P_SCP0009_GET_SHEE — golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0096 |  |
| DC-SCP0096-017 | X-ROW | SCP0096_Shipment_Working_Day_OSP.BtnInpu | 진입점 집계 7검사 — NA:4 · PASS:2 · WARN:1 |  |
| DC-SCP0096-018 | X-ROW | SCP0096_Shipment_Working_Day_OSP.SaveDat | 진입점 집계 18검사 — PASS:10 · NA:7 · WARN:1 |  |

## 기타

| ID | 규칙 | 대상 | 실측 | answer |
|---|---|---|---|---|
| DC-SCP0096-001 | A1 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0096/SCP0009_GET_SHEET_CALENDAR_3SPAN.md — 파라미터 미정 |  |
| DC-SCP0096-002 | A1 | PKG_SCP0096.P_SCP0096_GET_SHIPMENT_WORKI | golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0096/SCP0096_GET_SHIPMENT_WORKING_DAY_OSP.md — 파라미터 미정 |  |

## 조회 결과(A1) — AS-IS dev DB 와 데이터 차이 해석

| ID | 규칙 | 대상 | 실측 | answer |
|---|---|---|---|---|
| DC-SCP0096-003 | A1 | PKG_SCP0019.P_SCP0019_GET_WORKING_TIME | 골든 비교 케이스 없음(PKG_SCP0019.P_SCP0019_GET_WORKING_TIME — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  |
