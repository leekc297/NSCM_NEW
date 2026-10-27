# 작업 원장 — SCP0124 · 2026-10-26 12:55

> 검사 인스턴스 116건 중 PASS·NA 45건 외 **71건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W1 | 기능 구현 | 1 | 대조표 구현 + 위치 기입 → W8 실행 |
| W5 | 검사기 연결 | 2 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 26 | 실행 → PASS |
| W7 | 기대값 확정 | 33 | 기대 확정 → PASS/FAIL |
| W8 | 구현 후 검증 | 9 | 선행 W1 → PASS |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 33 · E2E 26 · 선행 W1 완료 후 E2E 9 · 하네스 2 · FE 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 14 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| A1 | GEN |  |  |  |  |  |  | 8 | 1 |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| G1 | GEN |  |  |  |  |  | 4 | 4 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G4 | DESIGN |  |  |  |  |  | 3 |  | 4 |  | 조회조건 표시·라벨·활성 |
| G6 | GEN |  |  |  |  |  | 3 |  | 4 |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| X-LOC | GEN |  |  |  |  |  |  | 7 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| C1 | CASCADE |  |  |  |  |  | 4 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| F4 | DB |  |  |  |  |  | 2 |  |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| X-NOTIMPL | GEN | 1 |  |  |  |  |  |  |  |  | 대조표 상태 미구현 = 구현 대상(FAIL) |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K-SA | COMMON |  |  |  |  |  | 1 |  |  |  | 조회영역 토글 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| A6 | GEN |  |  |  |  |  | 1 |  |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W1 기능 구현 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0124-0001 | X-NOTIMPL | clbPlant | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — clbPlant (미노출) `plantId`(항상 'ALL' 고정 전송) 확인 필요 — 공급 SQL_ID 미확정 미구현(확인 필요) |  | 1 (clbPlant) |

## W5 검사기 연결 (2)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0124-0002 | F2 | SCP0124 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0124 화면 | 판단불가(대상 단위 SCREEN) | 1 (Insert/Delete/Save) |
| WK-SCP0124-0003 | G03-WIRE | SCP0124 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0124 화면 | 판단불가(대상 단위 SCREEN) | 6 (ACT:SCP0124_PlanGroupDashboard..ctor ACT) |

## W6 검증 실행 (26)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0124-0004 | J2 | SCP0124 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0124 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 9 (cboDivision cboPlanGroup clbPlant cboCom) |
| WK-SCP0124-0005 | C1 | cboCompleted / Completed | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboCompleted / Completed · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0124_PlanGroupDashboard.InitContr) |
| WK-SCP0124-0006 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0124_PlanGroupDashboard.InitContr) |
| WK-SCP0124-0007 | C1 | cboPlanGroup / Plan Group | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboPlanGroup / Plan Group · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0124_PlanGroupDashboard.RefreshPl) |
| WK-SCP0124-0008 | C1 | clbPlant / Plant | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbPlant / Plant · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0124_PlanGroupDashboard.RefreshPl) |
| WK-SCP0124-0009 | G3 | SCP0124 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0124 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 2 (usrConditionPanel1 하위 ActivityCode usrCo) |
| WK-SCP0124-0010 | K-SA | SCP0124 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCP0124 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 2 (usrConditionPanel1 하위 ActivityCode usrCo) |
| WK-SCP0124-0011 | F1 | SCP0124 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0124 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 1 (Insert/Delete/Save) |
| WK-SCP0124-0012 | F5 | SCP0124 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0124 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 1 (Insert/Delete/Save) |
| WK-SCP0124-0013 | F4 | PKG_COM0000.P_SCP0121_GET_SEARCH_INFO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_COM0000.P_SCP0121_GET_SEARCH_INFO · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: sm |  | 2 (ACT:SCP0124_PlanGroupDashboard.GetSearch) |
| WK-SCP0124-0014 | F4 | PKG_SCP0124.P_SCP0124_GET_PLAN_GROUP_DAS | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0124.P_SCP0124_GET_PLAN_GROUP_DASHBOARD · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) —  |  | 44 (ACT:SCP0124_PlanGroupDashboard.FindButto) |
| WK-SCP0124-0015 | G4 | cboCompleted / Completed | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboCompleted / Completed · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (cboCompleted ACT:SCP0124_PlanGroupDashbo) |
| WK-SCP0124-0016 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (cboDivision ACT:SCP0124_PlanGroupDashboa) |
| WK-SCP0124-0017 | G4 | cboPlanGroup / Plan Group | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboPlanGroup / Plan Group · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (cboPlanGroup ACT:SCP0124_PlanGroupDashbo) |
| WK-SCP0124-0018 | SC1 | SCP0124 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SCP0124 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 7 (cboDivision cboPlanGroup clbPlant cboCom) |
| WK-SCP0124-0019 | D6 | SCP0124 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0124 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 1 (Insert/Delete/Save) |
| WK-SCP0124-0020 | A10 | SCP0124 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0124 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 37 (ACT:SCP0124_PlanGroupDashboard.Form_Load) |
| WK-SCP0124-0021 | A6 | PKG_SCP0124.P_SCP0124_GET_PLAN_GROUP_DAS | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0124.P_SCP0124_GET_PLAN_GROUP_DASHBOARD · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새 |  | 44 (ACT:SCP0124_PlanGroupDashboard.FindButto) |
| WK-SCP0124-0022 | G1 | cboCompleted / Completed | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboCompleted / Completed · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (cboCompleted ACT:SCP0124_PlanGroupDashbo) |
| WK-SCP0124-0023 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (cboDivision ACT:SCP0124_PlanGroupDashboa) |
| WK-SCP0124-0024 | G1 | cboPlanGroup / Plan Group | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboPlanGroup / Plan Group · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (cboPlanGroup ACT:SCP0124_PlanGroupDashbo) |
| WK-SCP0124-0025 | G1 | clbPlant / Plant | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbPlant / Plant · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (clbPlant ACT:SCP0124_PlanGroupDashboard.) |
| WK-SCP0124-0026 | G6 | cboCompleted / Completed | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboCompleted / Completed · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (cboCompleted ACT:SCP0124_PlanGroupDashbo) |
| WK-SCP0124-0027 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (cboDivision ACT:SCP0124_PlanGroupDashboa) |
| WK-SCP0124-0028 | G6 | cboPlanGroup / Plan Group | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboPlanGroup / Plan Group · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (cboPlanGroup ACT:SCP0124_PlanGroupDashbo) |
| WK-SCP0124-0029 | X-REOPEN | SCP0124 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0124 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 6 (ACT:SCP0124_PlanGroupDashboard.Dispose A) |

## W7 기대값 확정 (33)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0124-0030 | A1 | FindButton(Search) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindButton(Search): 행 집계 — A1 1요소: REVIEW:1 |  | 1 (FindButton(Search)) |
| WK-SCP0124-0031 | A1 | PKG_SCP0124.P_SCP0124_GET_PLAN_GROUP_DAS | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0124.P_SCP0124_GET_PLAN_GROUP_DASHBOARD: 골든 비교 케이스 없음(PKG_SCP0124.P_SCP0124_GET_PLAN_GROUP_DASHBOARD — 팝업·보조 SP |  | 44 (ACT:SCP0124_PlanGroupDashboard.FindButto) |
| WK-SCP0124-0032 | A1 | cboCompleted | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboCompleted: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (cboCompleted) |
| WK-SCP0124-0033 | A1 | cboDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboDivision: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (cboDivision) |
| WK-SCP0124-0034 | A1 | cboPlanGroup | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboPlanGroup: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (cboPlanGroup) |
| WK-SCP0124-0035 | A1 | dCalendar | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — dCalendar: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (dCalendar) |
| WK-SCP0124-0036 | A1 | usrConditionPanel1 하위 ActivityCode | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — usrConditionPanel1 하위 ActivityCode: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (usrConditionPanel1 하위 ActivityCode) |
| WK-SCP0124-0037 | A1 | usrConditionPanel1 하위 ProcessCode | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — usrConditionPanel1 하위 ProcessCode: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (usrConditionPanel1 하위 ProcessCode) |
| WK-SCP0124-0038 | G1 | FindButton(Search) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — FindButton(Search): 행 집계 — G1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (FindButton(Search)) |
| WK-SCP0124-0039 | G1 | dCalendar | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — dCalendar: 행 집계 — G1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (dCalendar) |
| WK-SCP0124-0040 | G1 | usrConditionPanel1 하위 ActivityCode | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — usrConditionPanel1 하위 ActivityCode: 행 집계 — G1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (usrConditionPanel1 하위 ActivityCode) |
| WK-SCP0124-0041 | G1 | usrConditionPanel1 하위 ProcessCode | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — usrConditionPanel1 하위 ProcessCode: 행 집계 — G1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (usrConditionPanel1 하위 ProcessCode) |
| WK-SCP0124-0042 | X-LOC | Insert/Delete/Save | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Insert/Delete/Save: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Insert/Delete/Save) |
| WK-SCP0124-0043 | X-LOC | cboCompleted | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — cboCompleted: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (cboCompleted) |
| WK-SCP0124-0044 | X-LOC | cboPlanGroup | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — cboPlanGroup: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (cboPlanGroup) |
| WK-SCP0124-0045 | X-LOC | dCalendar | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — dCalendar: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (dCalendar) |
| WK-SCP0124-0046 | X-LOC | gridSignals#1 ChangeActiveSheet (line253 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — gridSignals#1 ChangeActiveSheet (line253): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (gridSignals#1 ChangeActiveSheet (line253) |
| WK-SCP0124-0047 | X-LOC | usrConditionPanel1 하위 ActivityCode | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — usrConditionPanel1 하위 ActivityCode: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (usrConditionPanel1 하위 ActivityCode) |
| WK-SCP0124-0048 | X-LOC | usrConditionPanel1 하위 ProcessCode | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — usrConditionPanel1 하위 ProcessCode: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (usrConditionPanel1 하위 ProcessCode) |
| WK-SCP0124-0049 | X-ROW | SCP0124_PlanGroupDashboard.CboPlanGroup_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0124_PlanGroupDashboard.CboPlanGroup_SelectedIn: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0124_PlanGroupDashboard.CboPlanGr) |
| WK-SCP0124-0050 | X-ROW | SCP0124_PlanGroupDashboard.ClbDivision_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0124_PlanGroupDashboard.ClbDivision_SelectedInd: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0124_PlanGroupDashboard.ClbDivisi) |
| WK-SCP0124-0051 | X-ROW | SCP0124_PlanGroupDashboard.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0124_PlanGroupDashboard.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0124_PlanGroupDashboard.CreateSpr) |
| WK-SCP0124-0052 | X-ROW | SCP0124_PlanGroupDashboard.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0124_PlanGroupDashboard.FindButton: 진입점 집계 3검사 — NOT_RUN:2 · REVIEW:1 |  | 1 (ACT:SCP0124_PlanGroupDashboard.FindButto) |
| WK-SCP0124-0053 | X-ROW | SCP0124_PlanGroupDashboard.FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0124_PlanGroupDashboard.FindData_Main: 진입점 집계 9검사 — NOT_RUN:7 · REVIEW:1 · PASS:1 |  | 8 (ACT:SCP0124_PlanGroupDashboard.FindData_) |
| WK-SCP0124-0054 | X-ROW | SCP0124_PlanGroupDashboard.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0124_PlanGroupDashboard.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0124_PlanGroupDashboard.Form_Load) |
| WK-SCP0124-0055 | X-ROW | SCP0124_PlanGroupDashboard.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0124_PlanGroupDashboard.GetDayRange: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0124_PlanGroupDashboard.GetDayRan) |
| WK-SCP0124-0056 | X-ROW | SCP0124_PlanGroupDashboard.GetSearchInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0124_PlanGroupDashboard.GetSearchInfo: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:1 · TODO:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0124_PlanGroupDashboard.GetSearch) |
| WK-SCP0124-0057 | X-ROW | SCP0124_PlanGroupDashboard.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0124_PlanGroupDashboard.InitControls: 진입점 집계 7검사 — NOT_RUN:7 (미실행 검사가 남아 판정필요) |  | 9 (ACT:SCP0124_PlanGroupDashboard.InitContr) |
| WK-SCP0124-0058 | X-ROW | SCP0124_PlanGroupDashboard.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0124_PlanGroupDashboard.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0124_PlanGroupDashboard.InitSprea) |
| WK-SCP0124-0059 | X-ROW | SCP0124_PlanGroupDashboard.RefreshPlanGr | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0124_PlanGroupDashboard.RefreshPlanGroupByDivis: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0124_PlanGroupDashboard.RefreshPl) |
| WK-SCP0124-0060 | X-ROW | SCP0124_PlanGroupDashboard.RefreshPlantI | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0124_PlanGroupDashboard.RefreshPlantIdByDivisio: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0124_PlanGroupDashboard.RefreshPl) |
| WK-SCP0124-0061 | X-ROW | SCP0124_PlanGroupDashboard.SetChangedCon | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0124_PlanGroupDashboard.SetChangedControl: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0124_PlanGroupDashboard.SetChange) |
| WK-SCP0124-0062 | X-ROW | SCP0124_PlanGroupDashboard.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0124_PlanGroupDashboard.SetSpreadInit: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0124_PlanGroupDashboard.SetSpread) |

## W8 구현 후 검증 (9)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0124-0063 | G4 | clbPlant / Plant | 선행 W1 완료 후 E2E | G4 — 대조표 미구현 행 clbPlant 구현 후 검증 · 대상 clbPlant / Plant |  | 1 (clbPlant) |
| WK-SCP0124-0064 | G4 | dCalendar | 선행 W1 완료 후 E2E | G4 — 대조표 미구현 행  구현 후 검증 · 대상 dCalendar |  | 1 (dCalendar) |
| WK-SCP0124-0065 | G4 | usrConditionPanel1 하위 ActivityCode | 선행 W1 완료 후 E2E | G4 — 대조표 미구현 행  구현 후 검증 · 대상 usrConditionPanel1 하위 ActivityCode |  | 1 (usrConditionPanel1 하위 ActivityCode) |
| WK-SCP0124-0066 | G4 | usrConditionPanel1 하위 ProcessCode | 선행 W1 완료 후 E2E | G4 — 대조표 미구현 행  구현 후 검증 · 대상 usrConditionPanel1 하위 ProcessCode |  | 1 (usrConditionPanel1 하위 ProcessCode) |
| WK-SCP0124-0067 | A1 | clbPlant | 선행 W1 완료 후 E2E | A1 — 대조표 미구현 행 clbPlant 구현 후 검증 · 대상 clbPlant |  | 1 (clbPlant) |
| WK-SCP0124-0068 | G6 | clbPlant / Plant | 선행 W1 완료 후 E2E | G6 — 대조표 미구현 행 clbPlant 구현 후 검증 · 대상 clbPlant / Plant |  | 1 (clbPlant) |
| WK-SCP0124-0069 | G6 | dCalendar | 선행 W1 완료 후 E2E | G6 — 대조표 미구현 행  구현 후 검증 · 대상 dCalendar |  | 1 (dCalendar) |
| WK-SCP0124-0070 | G6 | usrConditionPanel1 하위 ActivityCode | 선행 W1 완료 후 E2E | G6 — 대조표 미구현 행  구현 후 검증 · 대상 usrConditionPanel1 하위 ActivityCode |  | 1 (usrConditionPanel1 하위 ActivityCode) |
| WK-SCP0124-0071 | G6 | usrConditionPanel1 하위 ProcessCode | 선행 W1 완료 후 E2E | G6 — 대조표 미구현 행  구현 후 검증 · 대상 usrConditionPanel1 하위 ProcessCode |  | 1 (usrConditionPanel1 하위 ProcessCode) |
