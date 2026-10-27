# 결정표 — SCP0007 · 2026-10-28 00:45

> 기계가 PASS/FAIL 을 정하지 못한 56건. 각 행의 **실측**을 보고 answer 에 P(같다)/F(결함)/N(해당없음·사유) 를 적은 뒤 `python tools/Harness/verify/decisions.py SCP0007 --apply` → 원장에 수동 판정으로 반영(재실행이 덮지 않음).

> **근거 등급(2026-10-26)**: `by` 열에 답한 사람을 적는다(비우면 반영 안 함). AI(claude 등)가 답한 P·N 은 `evidence_ref`(경로:줄) + `evidence_quote`(그 줄 원문 인용)가 기계로 확인될 때만 반영하고, 확인되지 않으면 판정필요로 남는다. AI 의 F 는 보수적으로 반영한다.


| 그룹 | 건수 | 어떻게 결정하나 |
|---|---|---|
| 기타 | 23 | 실측과 AS-IS 원문 대조 |
| 집계 행 — 구성 요소 검사 중 미확정이 남음(요소 결정이 끝나면 자동 확정) | 18 | 실측과 AS-IS 원문 대조 |
| 조회 결과(A1) — AS-IS dev DB 와 데이터 차이 해석 | 15 | 실측과 AS-IS 원문 대조 |

## 기타

| ID | 규칙 | 대상 | 실측 | answer |
|---|---|---|---|---|
| DC-SCP0007-001 | A7 | SCP0007_GET_BOD | 공통 컬럼 40 중 공란 컬럼 0 · 확인 필요 1 — REMARKS: AS-IS 소수 행만 값 있음(0.02%) ↔ TO-BE 전 행 공란 — DEV·사내 데이터 차이일 수 있음(같은 키 행 확인) |  |
| DC-SCP0007-002 | A7 | [DMF0035 결함 유형] 결과 컬럼 값(Plan Type=MKT FC | 규칙 A7 판정 4행 중 FAIL 0 · 판정필요 1 (대상 직접 일치 없음 · 규칙 전반 상속) — [V-96b515e6] SCP0007_GET_BOD: 공통 컬럼 40 중 공란 컬럼 0 · 확인 필요 1 — REMARKS: AS-IS 소수 행만 값 있음(0.02%) ↔ TO-BE 전 행 공란 — DEV·사내 데이터 차 |  |
| DC-SCP0007-003 | C1 | [DMF0035 결함 유형] Version 조회조건 기본값 | 규칙 C1 판정 8행 중 FAIL 0 · 판정필요 1 (대상 직접 일치 없음 · 규칙 전반 상속) — [V-19913349] 조회조건 Div:  / 검사기(_trace.spec(@trace) 상위 변경→하위 후보)가 이 대상을 실행하지 못함 — 시나리오 수동 확인 / 검사기(_trace.spec(@trace) 상위 변경→ |  |
| DC-SCP0007-004 | C1 | [DMF0035 결함 유형] 조회조건 전체(숫자·ITEM TYPE 포함) | 규칙 C1 판정 8행 중 FAIL 0 · 판정필요 1 (대상 직접 일치 없음 · 규칙 전반 상속) — [V-19913349] 조회조건 Div:  / 검사기(_trace.spec(@trace) 상위 변경→하위 후보)가 이 대상을 실행하지 못함 — 시나리오 수동 확인 / 검사기(_trace.spec(@trace) 상위 변경→ |  |
| DC-SCP0007-005 | C1 | [DMF0044 결함 유형] 조회조건 Report Type→Data Ty | 규칙 C1 판정 8행 중 FAIL 0 · 판정필요 1 (대상 직접 일치 없음 · 규칙 전반 상속) — [V-19913349] 조회조건 Div:  / 검사기(_trace.spec(@trace) 상위 변경→하위 후보)가 이 대상을 실행하지 못함 — 시나리오 수동 확인 / 검사기(_trace.spec(@trace) 상위 변경→ |  |
| DC-SCP0007-006 | C1 | 조회조건 Div |  / 검사기(_trace.spec(@trace) 상위 변경→하위 후보)가 이 대상을 실행하지 못함 — 시나리오 수동 확인 / 검사기(_trace.spec(@trace) 상위 변경→하위 후보)가 이 대상을 실행하지 못함 — 시나리오 수동 확인 / 검사기(_trace.spec(@trace) 상위 변경→하위 후보)가 이 대상을 |  |
| DC-SCP0007-007 | D4 | AFTER_LEAD_TIME |  / 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton )가 이 대상을 실행하지 못함 — 시나리오 수동 확인 / 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton )가 이 대상을 실행하지 못함  |  |
| DC-SCP0007-008 | D4 | BEFORE_LEAD_TIME |  / 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton )가 이 대상을 실행하지 못함 — 시나리오 수동 확인 / 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton )가 이 대상을 실행하지 못함  |  |
| DC-SCP0007-009 | D4 | BOD_VALID |  / 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton )가 이 대상을 실행하지 못함 — 시나리오 수동 확인 / 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton )가 이 대상을 실행하지 못함  |  |
| DC-SCP0007-010 | D4 | CUSTOMER,CUSTOMER |  / 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton )가 이 대상을 실행하지 못함 — 시나리오 수동 확인 / 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton )가 이 대상을 실행하지 못함  |  |
| DC-SCP0007-011 | D4 | FROM_CITY,FROM_CITY |  / 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton )가 이 대상을 실행하지 못함 — 시나리오 수동 확인 / 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton )가 이 대상을 실행하지 못함  |  |
| DC-SCP0007-012 | D4 | INCOTERMS |  / 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton )가 이 대상을 실행하지 못함 — 시나리오 수동 확인 / 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton )가 이 대상을 실행하지 못함  |  |
| DC-SCP0007-013 | D4 | INCOTERMS_SSP |  / 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton )가 이 대상을 실행하지 못함 — 시나리오 수동 확인 / 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton )가 이 대상을 실행하지 못함  |  |
| DC-SCP0007-014 | D4 | Insert 행 To Site 콤보·City | 규칙 D4 판정 5행 중 FAIL 0 · 판정필요 2 — [V-08d6ad02] FROM_CITY,FROM_CITY:  / 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton )가 이 대상을 실행하지 못함 — 시나리오 수동 확인 / 검사기(_verify.spe |  |
| DC-SCP0007-015 | D4 | ROUTE_CNT,ROUTE_CNT |  / 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton )가 이 대상을 실행하지 못함 — 시나리오 수동 확인 / 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton )가 이 대상을 실행하지 못함  |  |
| DC-SCP0007-016 | D4 | ROUTE_ID,BOD_ID |  / 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton )가 이 대상을 실행하지 못함 — 시나리오 수동 확인 / 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton )가 이 대상을 실행하지 못함  |  |
| DC-SCP0007-017 | D4 | ROUTE_VALID |  / 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton )가 이 대상을 실행하지 못함 — 시나리오 수동 확인 / 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton )가 이 대상을 실행하지 못함  |  |
| DC-SCP0007-018 | D4 | SAFETY_STOCK,SAFETY_STOCK |  / 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton )가 이 대상을 실행하지 못함 — 시나리오 수동 확인 / 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton )가 이 대상을 실행하지 못함  |  |
| DC-SCP0007-019 | D4 | TO_CITY,TO_CITY |  / 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton )가 이 대상을 실행하지 못함 — 시나리오 수동 확인 / 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton )가 이 대상을 실행하지 못함  |  |
| DC-SCP0007-020 | D4 | TO_YYYYMMDD |  / 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton )가 이 대상을 실행하지 못함 — 시나리오 수동 확인 / 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton )가 이 대상을 실행하지 못함  |  |
| DC-SCP0007-021 | D4 | VMI_YN |  / 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton )가 이 대상을 실행하지 못함 — 시나리오 수동 확인 / 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton )가 이 대상을 실행하지 못함  |  |
| DC-SCP0007-022 | D4 | [DMF0021 결함 유형] ETC 입력 Team·Measure 컬럼 | 규칙 D4 판정 39행 중 FAIL 0 · 판정필요 14 (대상 직접 일치 없음 · 규칙 전반 상속) — [V-7bf0abdf] VMI_YN:  / 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton )가 이 대상을 실행하지 못함 — 시나리오 수동 확인 / 검 |  |
| DC-SCP0007-023 | D4 | [SYS0017 결함 유형] Sub Module 컬럼·Category 코 | 규칙 D4 판정 39행 중 FAIL 0 · 판정필요 14 (대상 직접 일치 없음 · 규칙 전반 상속) — [V-7bf0abdf] VMI_YN:  / 검사기(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton )가 이 대상을 실행하지 못함 — 시나리오 수동 확인 / 검 |  |

## 집계 행 — 구성 요소 검사 중 미확정이 남음(요소 결정이 끝나면 자동 확정)

| ID | 규칙 | 대상 | 실측 | answer |
|---|---|---|---|---|
| DC-SCP0007-039 | A1 | CRUD:D00-4b-001:SEARCH · [SEARCH] §4b Fi | 행 집계 — 대조표 CRUD:D00-4b-001:SEARCH '[SEARCH] §4b FindButton / toolbarOverride / Search' 의 A1 5요소: REVIEW:2 · PASS:2 · NA:1 · FAIL 요소: PKG_SCP0007.P_SCP0007_GET_BOD — golden DIFF AS- |  |
| DC-SCP0007-040 | A1 | D00-2-008 · §2 this / Load → Form_Load ( | 행 집계 — 대조표 D00-2-008 '§2 this / Load → Form_Load (InitForm·InitControls·' 의 A1 5요소: REVIEW:2 · PASS:2 · NA:1 · FAIL 요소: PKG_SCP0007.P_SCP0007_GET_BOD — golden DIFF AS-IS 5000행 ↔ TO |  |
| DC-SCP0007-041 | A1 | D00-3-009 · §3 SetCellTypeCombo / (DIVIS | 행 집계 — 대조표 D00-3-009 '§3 SetCellTypeCombo / (DIVISION_ID, dtMyDivision)' 의 A1 5요소: REVIEW:2 · PASS:2 · NA:1 · FAIL 요소: PKG_SCP0007.P_SCP0007_GET_BOD — golden DIFF AS-IS 5000행 ↔ TO- |  |
| DC-SCP0007-042 | A1 | D00-3-040 · §3 SmartColMerge / () | 행 집계 — 대조표 D00-3-040 '§3 SmartColMerge / ()' 의 A1 5요소: REVIEW:2 · PASS:2 · NA:1 · FAIL 요소: PKG_SCP0007.P_SCP0007_GET_BOD — golden DIFF AS-IS 5000행 ↔ TO-BE 5001행: Doc/golden/SCP0007 |  |
| DC-SCP0007-043 | A1 | D00-4b-001 · §4b FindButton / toolbarOve | 행 집계 — 대조표 D00-4b-001 '§4b FindButton / toolbarOverride / Search' 의 A1 5요소: REVIEW:2 · PASS:2 · NA:1 · FAIL 요소: PKG_SCP0007.P_SCP0007_GET_BOD — golden DIFF AS-IS 5000행 ↔ TO-BE 5001 |  |
| DC-SCP0007-044 | A1 | D00-4d-003 · §4d Data_SCP.CommonAll / Fr | 행 집계 — 대조표 D00-4d-003 '§4d Data_SCP.CommonAll / FromSiteByDivision1Ex' 의 A1 5요소: REVIEW:2 · PASS:2 · NA:1 · FAIL 요소: PKG_SCP0007.P_SCP0007_GET_BOD — golden DIFF AS-IS 5000행 ↔ TO-BE |  |
| DC-SCP0007-045 | A1 | D00-4d-004 · §4d Data_SCP.CommonAll / To | 행 집계 — 대조표 D00-4d-004 '§4d Data_SCP.CommonAll / ToSiteBOD1' 의 A1 5요소: REVIEW:2 · PASS:2 · NA:1 · FAIL 요소: PKG_SCP0007.P_SCP0007_GET_BOD — golden DIFF AS-IS 5000행 ↔ TO-BE 5001행: Doc |  |
| DC-SCP0007-046 | A1 | D00-4d-005 · §4d Data_SCP.CommonAll / Fr | 행 집계 — 대조표 D00-4d-005 '§4d Data_SCP.CommonAll / FromSiteByDivision1' 의 A1 5요소: REVIEW:2 · PASS:2 · NA:1 · FAIL 요소: PKG_SCP0007.P_SCP0007_GET_BOD — golden DIFF AS-IS 5000행 ↔ TO-BE 5 |  |
| DC-SCP0007-047 | A1 | D00-4d-009 · §4d Data.Common / LookupCom | 행 집계 — 대조표 D00-4d-009 '§4d Data.Common / LookupCommon(INCOTERMS)' 의 A1 5요소: REVIEW:2 · PASS:2 · NA:1 · FAIL 요소: PKG_SCP0007.P_SCP0007_GET_BOD — golden DIFF AS-IS 5000행 ↔ TO-BE 5001 |  |
| DC-SCP0007-048 | A1 | D00-4e-005 · §4e dtFromSiteOfSpdAll / Fi | 행 집계 — 대조표 D00-4e-005 '§4e dtFromSiteOfSpdAll / FindData_Main' 의 A1 5요소: REVIEW:2 · PASS:2 · NA:1 · FAIL 요소: PKG_SCP0007.P_SCP0007_GET_BOD — golden DIFF AS-IS 5000행 ↔ TO-BE 5001행:  |  |
| DC-SCP0007-049 | A1 | D00-4e-006 · §4e dtToSiteOfSpdAll / Find | 행 집계 — 대조표 D00-4e-006 '§4e dtToSiteOfSpdAll / FindData_Main' 의 A1 5요소: REVIEW:2 · PASS:2 · NA:1 · FAIL 요소: PKG_SCP0007.P_SCP0007_GET_BOD — golden DIFF AS-IS 5000행 ↔ TO-BE 5001행: Do |  |
| DC-SCP0007-050 | D4 | CRUD:D00-4b-006:INSERT · [INSERT] §4b In | 행 집계 — 대조표 CRUD:D00-4b-006:INSERT '[INSERT] §4b InsertButton / toolbarOverride / Inse' 의 D4 56요소: REVIEW:29 · PASS:25 · NA:2 · FAIL 요소: CUSTOMER / Customer — 원장 V-713bf983 ASIS; FR |  |
| DC-SCP0007-051 | D4 | D00-3-008 · §3 Insert / () | 행 집계 — 대조표 D00-3-008 '§3 Insert / ()' 의 D4 56요소: REVIEW:29 · PASS:25 · NA:2 · FAIL 요소: CUSTOMER / Customer — 원장 V-713bf983 ASIS; FROM_CITY / From City — 원장 V-08d6ad02 ASIS; TO_CITY |  |
| DC-SCP0007-052 | D4 | D00-4b-006 · §4b InsertButton / toolbarO | 행 집계 — 대조표 D00-4b-006 '§4b InsertButton / toolbarOverride / Insert' 의 D4 56요소: REVIEW:29 · PASS:25 · NA:2 · FAIL 요소: CUSTOMER / Customer — 원장 V-713bf983 ASIS; FROM_CITY / From City |  |
| DC-SCP0007-053 | D4 | D00-4f-002 · §4f InsertButton / Insert / | 행 집계 — 대조표 D00-4f-002 '§4f InsertButton / Insert / InputStatus=="R"' 의 D4 56요소: REVIEW:29 · PASS:25 · NA:2 · FAIL 요소: CUSTOMER / Customer — 원장 V-713bf983 ASIS; FROM_CITY / From Cit |  |
| DC-SCP0007-054 | X-ROW | SCP0007_BOD.FindButton | 진입점 집계 6검사 — PASS:3 · REVIEW:2 · NA:1 |  |
| DC-SCP0007-055 | X-ROW | SCP0007_BOD.FindData_Main | 진입점 집계 17검사 — PASS:13 · NA:3 · REVIEW:1 |  |
| DC-SCP0007-056 | X-ROW | SCP0007_BOD.InitControls | 진입점 집계 20검사 — PASS:18 · NA:1 · REVIEW:1 |  |

## 조회 결과(A1) — AS-IS dev DB 와 데이터 차이 해석

| ID | 규칙 | 대상 | 실측 | answer |
|---|---|---|---|---|
| DC-SCP0007-024 | A1 | PKG_SCP0007.P_SCP0007_GET_BOD | golden DIFF AS-IS 5000행 ↔ TO-BE 5001행: Doc/golden/SCP0007/SCP0007_GET_BOD.md — 같은 조건 건수 차이(AS-IS dev DB ≠ TO-BE DB) 해석 필요 |  |
| DC-SCP0007-025 | A1 | PKG_SCP0007.P_SCP0007_GET_COUNTRY_CITY | golden DIFF AS-IS 1415행 ↔ TO-BE 1395행: Doc/golden/SCP0007/SCP0007_GET_COUNTRY_CITY.md — 같은 조건 건수 차이(AS-IS dev DB ≠ TO-BE DB) 해석 필요 |  |
| DC-SCP0007-026 | A1 | SCP0007 화면 | SCP0007_GET_BOD: DIFF AS-IS 5000행 ↔ TO-BE 5001행 · SCP0007_GET_COUNTRY_CITY: DIFF AS-IS 1415행 ↔ TO-BE 1395행 · SCP0007_GET_ROUTE_CNT: PASS AS-IS 1행 ↔ TO-BE 2행 · SCP0005_GET_DISTRIBUT |  |
| DC-SCP0007-027 | A1 | [DMF0003 결함 유형] Team 정보(DEPT_ID) | 규칙 A1 판정 6행 중 FAIL 0 · 판정필요 3 (대상 직접 일치 없음 · 규칙 전반 상속) — [V-28615bf9] SCP0007 화면: SCP0007_GET_BOD: DIFF AS-IS 5000행 ↔ TO-BE 5001행 · SCP0007_GET_COUNTRY_CITY: DIFF AS-IS 1415행 ↔ TO- |  |
| DC-SCP0007-028 | A1 | [DMF0003 결함 유형] 조회 건수 | 규칙 A1 판정 6행 중 FAIL 0 · 판정필요 3 (대상 직접 일치 없음 · 규칙 전반 상속) — [V-28615bf9] SCP0007 화면: SCP0007_GET_BOD: DIFF AS-IS 5000행 ↔ TO-BE 5001행 · SCP0007_GET_COUNTRY_CITY: DIFF AS-IS 1415행 ↔ TO- |  |
| DC-SCP0007-029 | A1 | [DMF0007 결함 유형] Customer FCST Master 기준정 | 규칙 A1 판정 6행 중 FAIL 0 · 판정필요 3 (대상 직접 일치 없음 · 규칙 전반 상속) — [V-28615bf9] SCP0007 화면: SCP0007_GET_BOD: DIFF AS-IS 5000행 ↔ TO-BE 5001행 · SCP0007_GET_COUNTRY_CITY: DIFF AS-IS 1415행 ↔ TO- |  |
| DC-SCP0007-030 | A1 | [DMF0020 결함 유형] 조회 건수 · Team 컬럼 표시 · 컬럼팝 | 규칙 A1 판정 6행 중 FAIL 0 · 판정필요 3 (대상 직접 일치 없음 · 규칙 전반 상속) — [V-28615bf9] SCP0007 화면: SCP0007_GET_BOD: DIFF AS-IS 5000행 ↔ TO-BE 5001행 · SCP0007_GET_COUNTRY_CITY: DIFF AS-IS 1415행 ↔ TO- |  |
| DC-SCP0007-031 | A1 | [DMF0035 결함 유형] 조회 결과 건수 | 규칙 A1 판정 6행 중 FAIL 0 · 판정필요 3 (대상 직접 일치 없음 · 규칙 전반 상속) — [V-28615bf9] SCP0007 화면: SCP0007_GET_BOD: DIFF AS-IS 5000행 ↔ TO-BE 5001행 · SCP0007_GET_COUNTRY_CITY: DIFF AS-IS 1415행 ↔ TO- |  |
| DC-SCP0007-032 | A1 | [DMF0035 결함 유형] 조회 결과 건수(SF_W_20260907_V | 규칙 A1 판정 6행 중 FAIL 0 · 판정필요 3 (대상 직접 일치 없음 · 규칙 전반 상속) — [V-28615bf9] SCP0007 화면: SCP0007_GET_BOD: DIFF AS-IS 5000행 ↔ TO-BE 5001행 · SCP0007_GET_COUNTRY_CITY: DIFF AS-IS 1415행 ↔ TO- |  |
| DC-SCP0007-033 | A1 | [DMF0048 결함 유형] 조회 결과 건수 | 규칙 A1 판정 6행 중 FAIL 0 · 판정필요 3 (대상 직접 일치 없음 · 규칙 전반 상속) — [V-28615bf9] SCP0007 화면: SCP0007_GET_BOD: DIFF AS-IS 5000행 ↔ TO-BE 5001행 · SCP0007_GET_COUNTRY_CITY: DIFF AS-IS 1415행 ↔ TO- |  |
| DC-SCP0007-034 | A1 | [DMF0053 결함 유형] 조회 결과 건수 | 규칙 A1 판정 6행 중 FAIL 0 · 판정필요 3 (대상 직접 일치 없음 · 규칙 전반 상속) — [V-28615bf9] SCP0007 화면: SCP0007_GET_BOD: DIFF AS-IS 5000행 ↔ TO-BE 5001행 · SCP0007_GET_COUNTRY_CITY: DIFF AS-IS 1415행 ↔ TO- |  |
| DC-SCP0007-035 | A1 | [DMF0082 결함 유형] RTF[R+P] Measure 행 | 규칙 A1 판정 6행 중 FAIL 0 · 판정필요 3 (대상 직접 일치 없음 · 규칙 전반 상속) — [V-28615bf9] SCP0007 화면: SCP0007_GET_BOD: DIFF AS-IS 5000행 ↔ TO-BE 5001행 · SCP0007_GET_COUNTRY_CITY: DIFF AS-IS 1415행 ↔ TO- |  |
| DC-SCP0007-036 | A1 | [DMF0082 결함 유형] 조회 건수 | 규칙 A1 판정 6행 중 FAIL 0 · 판정필요 3 (대상 직접 일치 없음 · 규칙 전반 상속) — [V-28615bf9] SCP0007 화면: SCP0007_GET_BOD: DIFF AS-IS 5000행 ↔ TO-BE 5001행 · SCP0007_GET_COUNTRY_CITY: DIFF AS-IS 1415행 ↔ TO- |  |
| DC-SCP0007-037 | A1 | [SCP0006 결함 유형] BOM Explosion Plant Assi | 규칙 A1 판정 6행 중 FAIL 0 · 판정필요 3 (대상 직접 일치 없음 · 규칙 전반 상속) — [V-28615bf9] SCP0007 화면: SCP0007_GET_BOD: DIFF AS-IS 5000행 ↔ TO-BE 5001행 · SCP0007_GET_COUNTRY_CITY: DIFF AS-IS 1415행 ↔ TO- |  |
| DC-SCP0007-038 | A1 | [SYS0013 결함 유형] Dynamic Query(ESS KWh 판가 | 규칙 A1 판정 6행 중 FAIL 0 · 판정필요 3 (대상 직접 일치 없음 · 규칙 전반 상속) — [V-28615bf9] SCP0007 화면: SCP0007_GET_BOD: DIFF AS-IS 5000행 ↔ TO-BE 5001행 · SCP0007_GET_COUNTRY_CITY: DIFF AS-IS 1415행 ↔ TO- |  |
