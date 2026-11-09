# 작업 원장 — SCP0037 · 2026-11-08 11:49

> 검사 인스턴스 337건 중 PASS·NA 268건 외 **69건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 2 | 재판정 PASS |
| W5 | 검사기 연결 | 16 | 원장 항목/엔진 연결 → 실행 PASS |
| W7 | 기대값 확정 | 31 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 20 | 원인 해소 → 재판정 |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 31 · 하네스·환경 20 · 하네스 16 · FE 1 · 화면 FE 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 1건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-LOC | GEN |  |  |  |  |  |  | 11 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-ROW | GEN |  |  |  |  |  |  | 3 |  | 7 | 대조표 행이 서술한 동작을 화면에서 재현 |
| A1 | GEN |  |  |  |  |  |  | 9 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| G1 | GEN |  |  |  |  |  |  |  |  | 9 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| A5 | DESIGN |  |  |  |  |  |  | 7 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| B1 | COMBO |  |  |  |  | 3 |  |  |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 3 |  |  |  |  | 콤보 후보 중복 없음 |
| B4 | COMBO |  |  |  |  | 3 |  |  |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| E5 | EDIT |  |  |  |  | 3 |  |  |  |  | 콤보 셀 후보 외 값 차단 |
| M4 | POPUP |  |  |  |  |  |  | 1 |  | 1 | 팝업 선택값 반영 |
| H10 | DESIGN |  |  | 1 |  |  |  |  |  |  | 메시지 표준(방식·코드 단일화) |
| SC1 | DESIGN |  |  | 1 |  |  |  |  |  |  | 조회조건 순서 = 기준표 |
| G4 | DESIGN |  |  |  |  | 1 |  |  |  |  | 조회조건 표시·라벨·활성 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| G5 | POPUP |  |  |  |  | 1 |  |  |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 1 |  |  |  |  | 팝업 표준·열림 |
| F3 | CRUD |  |  |  |  |  |  |  |  | 1 | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F6 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 값 보존 |
| I1 | DESIGN |  |  |  |  |  |  |  |  | 1 | LBL/MSG 언어별 등록 |

## W3 동작 수정 (2)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0037-0001 | H10 | SCP0037 화면 | FE(repairScope=DB_ONLY — 이번 범위 밖) | H10 FAIL 수정 — SCP0037 화면: 표준 메시지 대신 브라우저 alert/confirm 직접 호출: components/OperationLTGrid.tsx, hooks/useOperationLTValidation.ts |  | 7 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-03 C) |
| WK-SCP0037-0002 | SC1 | SCP0037 화면 | 화면 FE(범위 밖(가이드만)) | SC1 FAIL 수정 — SCP0037 화면: 원장 V-d73d9696 RULE_SCREEN / E2E smoke cond order (FX-SCP0037-015) |  | 1 (COMMON:UC-06) |

## W5 검사기 연결 (16)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0037-0003 | B1 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 3 (16,17,18,19,43,44,45,35 ACT:SCP0037_Oper) |
| WK-SCP0037-0004 | B1 | LT_OPERATION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL LT_OPERATION | 있음(SHEET_COLUMNS) | 1 (16,17,18,19,43,44,45,35) |
| WK-SCP0037-0005 | B1 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 7 (16,17,18,19,43,44,45,35 ACT:SCP0037_Oper) |
| WK-SCP0037-0006 | B2 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 3 (16,17,18,19,43,44,45,35 ACT:SCP0037_Oper) |
| WK-SCP0037-0007 | B2 | LT_OPERATION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL LT_OPERATION | 있음(SHEET_COLUMNS) | 1 (16,17,18,19,43,44,45,35) |
| WK-SCP0037-0008 | B2 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 7 (16,17,18,19,43,44,45,35 ACT:SCP0037_Oper) |
| WK-SCP0037-0009 | B4 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 3 (16,17,18,19,43,44,45,35 ACT:SCP0037_Oper) |
| WK-SCP0037-0010 | B4 | LT_OPERATION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL LT_OPERATION | 있음(SHEET_COLUMNS) | 1 (16,17,18,19,43,44,45,35) |
| WK-SCP0037-0011 | B4 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 7 (16,17,18,19,43,44,45,35 ACT:SCP0037_Oper) |
| WK-SCP0037-0012 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 없음 | 2 (ACT:SCP0037_OperationLT.InitEvent ACT:SC) |
| WK-SCP0037-0013 | E5 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 1 (16,17,18,19,43,44,45,35) |
| WK-SCP0037-0014 | E5 | LT_OPERATION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL LT_OPERATION | 있음(SHEET_COLUMNS) | 1 (16,17,18,19,43,44,45,35) |
| WK-SCP0037-0015 | E5 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 1 (16,17,18,19,43,44,45,35) |
| WK-SCP0037-0016 | G03-WIRE | SCP0037 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0037 화면 | 판단불가(대상 단위 SCREEN) | 11 (ACT:SCP0037_OperationLT..ctor ACT:SCP003) |
| WK-SCP0037-0017 | G5 | NICK_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL NICK_NAME | 있음(SHEET_COLUMNS) | 1 (22,23) |
| WK-SCP0037-0018 | H6 | NICK_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL NICK_NAME | 있음(SHEET_COLUMNS) | 1 (22,23) |

## W7 기대값 확정 (31)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0037-0019 | A5 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 2: 행 집계 — 대조표 2 'cboDivision.SelectedIndexChanged' 의 A5 3요소: PASS:2 · REVIEW:1 · FAIL 요소: INV_FLAG — E2E smoke columns |  | 0 () |
| WK-SCP0037-0020 | A5 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 8: 행 집계 — 대조표 8 'dataSource' 의 A5 3요소: PASS:2 · REVIEW:1 · FAIL 요소: INV_FLAG — E2E smoke columns / 실측[T-7127b90c]: INV |  | 1 (8) |
| WK-SCP0037-0021 | A5 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-01: 행 집계 — 대조표 COMMON:UC-01 '필터링 상태 신규행 Insert 시 필터 유지한 채 추가 행 표시(keepRowVisibl' 의 A5 3요소: PASS:2 · REVIEW:1 |  | 1 (COMMON:UC-01) |
| WK-SCP0037-0022 | A5 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-02: 행 집계 — 대조표 COMMON:UC-02 "데이터 수정 중 다른 데이터 조회 시 '수정 중...조회?' confirm(MSG00703" 의 A5 3요소: PASS:2 · REVIEW:1 |  | 1 (COMMON:UC-02) |
| WK-SCP0037-0023 | A5 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-05: 행 집계 — 대조표 COMMON:UC-05 'Excel Download 시 콤보 컬럼 Code 아닌 Name 출력(dataMap 승계)' 의 A5 3요소: PASS:2 · REVIEW:1 |  | 1 (COMMON:UC-05) |
| WK-SCP0037-0024 | A5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-07: 행 집계 — 대조표 COMMON:UC-07 '필터 걸린 상태 재조회 시 조회+필터 유지(rebindFilterColumns)' 의 A5 3요소: PASS:2 · REVIEW:1 · FAI |  | 1 (COMMON:UC-07) |
| WK-SCP0037-0025 | A5 | INV_FLAG | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — INV_FLAG: E2E smoke columns / 실측[T-7127b90c]: INV_FLAG: AS-IS(Div 81) '기본 →숨김 →표시? →표시? →숨김?' — 표시 여부가 조건 분기(원문 미해석 '? |  | 2 (ACT:SCP0037_OperationLT.InitSpread ACT:S) |
| WK-SCP0037-0026 | A1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1: 행 집계 — 대조표 1 'cellType' 의 A1 1요소: REVIEW:1 · FAIL 요소: PKG_SCP0037.P_SCP0037_GET_OPER — golden SKIP AS-IS -1행 ↔ TO-B |  | 0 () |
| WK-SCP0037-0027 | A1 | 20 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 20: 행 집계 — 대조표 20 'cellType' 의 A1 1요소: REVIEW:1 · FAIL 요소: PKG_SCP0037.P_SCP0037_GET_OPER — golden SKIP AS-IS -1행 ↔ TO |  | 1 (20) |
| WK-SCP0037-0028 | A1 | 3,9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 3,9: 행 집계 — 대조표 3,9 'lock' 의 A1 1요소: REVIEW:1 · FAIL 요소: PKG_SCP0037.P_SCP0037_GET_OPER — golden SKIP AS-IS -1행 ↔ TO-B |  | 1 (3,9) |
| WK-SCP0037-0029 | A1 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 8: 행 집계 — 대조표 8 'dataSource' 의 A1 1요소: REVIEW:1 · FAIL 요소: PKG_SCP0037.P_SCP0037_GET_OPER — golden SKIP AS-IS -1행 ↔ TO |  | 1 (8) |
| WK-SCP0037-0030 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — 대조표 COMMON:UC-02 "데이터 수정 중 다른 데이터 조회 시 '수정 중...조회?' confirm(MSG00703" 의 A1 1요소: REVIEW:1 · FAIL 요 |  | 1 (COMMON:UC-02) |
| WK-SCP0037-0031 | A1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-03: 행 집계 — 대조표 COMMON:UC-03 '컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 Reset 후 재조회' 의 A1 1요소: REVIEW:1 · FAIL 요 |  | 1 (COMMON:UC-03) |
| WK-SCP0037-0032 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 콤마 다중 입력 시 전건 조회' 의 A1 1요소: REVIEW:1 · FAIL 요소: PKG_SCP0037.P_SCP00 |  | 1 (COMMON:UC-06) |
| WK-SCP0037-0033 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — 대조표 COMMON:UC-07 '필터 걸린 상태 재조회 시 조회+필터 유지(rebindFilterColumns)' 의 A1 1요소: REVIEW:1 · FAIL 요소: PKG |  | 1 (COMMON:UC-07) |
| WK-SCP0037-0034 | A1 | PKG_SCP0037.P_SCP0037_GET_OPERATION_LT | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0037.P_SCP0037_GET_OPERATION_LT: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0037/SCP0037_GET_OPERATION_LT |  | 37 (ACT:SCP0037_OperationLT.FindButton ACT:S) |
| WK-SCP0037-0035 | X-LOC | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 10: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (10) |
| WK-SCP0037-0036 | X-LOC | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 11: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (11) |
| WK-SCP0037-0037 | X-LOC | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 12: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (12) |
| WK-SCP0037-0038 | X-LOC | 13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 13: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (13) |
| WK-SCP0037-0039 | X-LOC | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (2) |
| WK-SCP0037-0040 | X-LOC | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (3) |
| WK-SCP0037-0041 | X-LOC | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (4) |
| WK-SCP0037-0042 | X-LOC | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (5) |
| WK-SCP0037-0043 | X-LOC | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 6: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (6) |
| WK-SCP0037-0044 | X-LOC | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 7: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (7) |
| WK-SCP0037-0045 | X-LOC | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 9: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (9) |
| WK-SCP0037-0046 | X-ROW | SCP0037_OperationLT.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0037_OperationLT.FindButton: 진입점 집계 3검사 — PASS:2 · REVIEW:1 |  | 1 (ACT:SCP0037_OperationLT.FindButton) |
| WK-SCP0037-0047 | X-ROW | SCP0037_OperationLT.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0037_OperationLT.InitSpread: 진입점 집계 10검사 — PASS:5 · NA:4 · REVIEW:1 |  | 3 (ACT:SCP0037_OperationLT.InitSpread ACT:S) |
| WK-SCP0037-0048 | X-ROW | SCP0037_OperationLT.SpdMain_KeyPress | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0037_OperationLT.SpdMain_KeyPress: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/RETURN/UI_PROP, 연결된 요소 검사 없음 |  | 5 (ACT:SCP0037_OperationLT.SpdMain_KeyPress) |
| WK-SCP0037-0049 | M4 | ITEM_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — ITEM_ID: 검증 엔진이 실행됐으나 이 대상(COL ITEM_ID)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 3 (4 11 22,23) |

## W9 도구 오류 (20)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0037-0050 | F3 | SCP0037 화면 | 하네스·환경 | F3 도구 오류 — 원장 V-f2e01a78 RULE_SCREEN / 원장 V-d488067a RULE_SCREEN / 원장 V-29e26416 RULE_SCREEN / 원장 V-1816310a RULE_SCREEN / 원장 V-73 |  | 37 (5 12 13 31~40 ACT:SCP0037_OperationLT.Sp) |
| WK-SCP0037-0051 | F6 | SCP0037 화면 | 하네스·환경 | F6 도구 오류 — 원장 V-a2f16f7c RULE_SCREEN / 원장 V-85e2e594 RULE_SCREEN / 원장 V-3ed5cc00 RULE_SCREEN / 원장 V-6d30ddef RULE_SCREEN / 원장 V-00 |  | 66 (ACT:SCP0037_OperationLT.SaveButton ACT:S) |
| WK-SCP0037-0052 | I1 | SCP0037 화면 | 하네스·환경 | I1 도구 오류 — 원장 V-fb9d8ff6 RULE_SCREEN / 원장 V-50589bf0 RULE_SCREEN / 원장 V-04376111 RULE_SCREEN / 원장 V-4a203145 DEFECT / 원장 V-5fa1a25 |  | 8 (COMMON:UC-02 ACT:SCP0037_OperationLT.Sav) |
| WK-SCP0037-0053 | G1 | 1 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 1 'cellType' 의 G1 5요소: PASS:3 · ERROR:1 · NA:1 |  | 0 () |
| WK-SCP0037-0054 | G1 | 20 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 20 'cellType' 의 G1 5요소: PASS:3 · ERROR:1 · NA:1 |  | 1 (20) |
| WK-SCP0037-0055 | G1 | 3,9 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 3,9 'lock' 의 G1 5요소: PASS:3 · ERROR:1 · NA:1 |  | 1 (3,9) |
| WK-SCP0037-0056 | G1 | 8 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 8 'dataSource' 의 G1 5요소: PASS:3 · ERROR:1 · NA:1 |  | 1 (8) |
| WK-SCP0037-0057 | G1 | COMMON:UC-02 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-02 "데이터 수정 중 다른 데이터 조회 시 '수정 중...조회?' confirm(MSG00703" 의 G1 5요소: PASS:3 · ERROR:1 · NA:1 |  | 1 (COMMON:UC-02) |
| WK-SCP0037-0058 | G1 | COMMON:UC-03 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-03 '컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 Reset 후 재조회' 의 G1 5요소: PASS:3 · ERROR:1 · NA:1 |  | 1 (COMMON:UC-03) |
| WK-SCP0037-0059 | G1 | COMMON:UC-06 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 콤마 다중 입력 시 전건 조회' 의 G1 5요소: PASS:3 · ERROR:1 · NA:1 |  | 1 (COMMON:UC-06) |
| WK-SCP0037-0060 | G1 | COMMON:UC-07 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터 걸린 상태 재조회 시 조회+필터 유지(rebindFilterColumns)' 의 G1 5요소: PASS:3 · ERROR:1 · NA:1 |  | 1 (COMMON:UC-07) |
| WK-SCP0037-0061 | G1 | clbPlantSite / Plant Site | 하네스·환경 | G1 도구 오류 — 원장 V-bef622ab SEARCH / E2E smoke cond combo |  | 2 (ACT:SCP0037_OperationLT.FindData ACT:SCP) |
| WK-SCP0037-0062 | X-ROW | SCP0037_OperationLT.CreateSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0037_OperationLT.CreateSpread) |
| WK-SCP0037-0063 | X-ROW | SCP0037_OperationLT.FindData | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 13검사 — PASS:7 · NA:4 · REVIEW:1 · ERROR:1 |  | 7 (ACT:SCP0037_OperationLT.FindData:313:1 A) |
| WK-SCP0037-0064 | X-ROW | SCP0037_OperationLT.SaveData | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 15검사 — PASS:11 · ERROR:2 · NA:2 |  | 2 (ACT:SCP0037_OperationLT.SaveData:422:5 A) |
| WK-SCP0037-0065 | X-ROW | SCP0037_OperationLT.SetChangedControl | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — PASS:6 · NA:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0037_OperationLT.SetChangedContro) |
| WK-SCP0037-0066 | X-ROW | SCP0037_OperationLT.SpdMain_CellClick | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 33검사 — NA:17 · PASS:9 · NOPATH:6 · ERROR:1 |  | 82 (ACT:SCP0037_OperationLT.SpdMain_CellClic) |
| WK-SCP0037-0067 | X-ROW | SCP0037_OperationLT.SpdMain_ClipboardPas | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 36검사 — NA:20 · PASS:9 · NOPATH:6 · ERROR:1 |  | 9 (ACT:SCP0037_OperationLT.SpdMain_Clipboar) |
| WK-SCP0037-0068 | X-ROW | SCP0037_OperationLT.checkValidN1 | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — ERROR:1 · NA:1 · PASS:1 |  | 15 (ACT:SCP0037_OperationLT.checkValidN1 ACT) |
| WK-SCP0037-0069 | M4 | NICK_NAME | 하네스·환경 | M4 도구 오류 — 실측[T-af09997b]: [검사기 미검증] NICK_NAME: SCM_SITE_ID 더블클릭 → 팝업 열림 감지 실패(H6) — 팝업에서 가져온 값이 행에 하나도 반영되지 않음 |  | 1 (22,23) |
