# 작업 원장 — SSP0012 · 2026-10-26 12:55

> 검사 인스턴스 239건 중 PASS·NA 39건 외 **200건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W1 | 기능 구현 | 1 | 대조표 구현 + 위치 기입 → W8 실행 |
| W2 | 구현 위치 확인 | 27 | 구현 위치 실존 |
| W5 | 검사기 연결 | 9 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 61 | 실행 → PASS |
| W7 | 기대값 확정 | 99 | 기대 확정 → PASS/FAIL |
| W8 | 구현 후 검증 | 3 | 선행 W1 → PASS |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 96 · E2E 61 · 대조표 30 · 하네스 9 · 선행 W1 완료 후 E2E 2 · FE 1 · 선행 W1 완료 후 검증 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 1건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-LOC | GEN |  | 27 |  |  |  |  |  |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-ROW | GEN |  |  |  |  |  |  | 25 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| G1 | GEN |  |  |  |  |  | 6 | 10 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| A5 | DESIGN |  |  |  |  |  | 5 | 9 | 1 |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H2 | DESIGN |  |  |  |  |  | 5 | 9 | 1 |  | 배경·글자색 규칙 |
| H5 | DESIGN |  |  |  |  |  | 5 | 9 | 1 |  | 라벨 명칭 |
| A1 | GEN |  |  |  |  |  |  | 14 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| G4 | DESIGN |  |  |  |  | 2 | 4 | 5 |  |  | 조회조건 표시·라벨·활성 |
| E4 | EDIT |  |  |  |  |  | 8 | 3 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| G6 | GEN |  |  |  |  |  | 4 | 5 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| C3 | CASCADE |  |  |  |  |  | 2 | 5 |  |  | 연쇄 자동 채움 |
| D5 | EDIT |  |  |  |  |  | 2 | 2 |  |  | 셀 에디터 유형 |
| G5 | POPUP |  |  |  |  | 3 |  |  |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 2 | 1 |  |  |  | 팝업 표준·열림 |
| X-REASON | DESIGN |  |  |  |  |  |  | 3 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| C1 | CASCADE |  |  |  |  |  | 2 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| F4 | DB |  |  |  |  |  | 2 |  |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| A6 | GEN |  |  |  |  |  | 2 |  |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| X-NOTIMPL | GEN | 1 |  |  |  |  |  |  |  |  | 대조표 상태 미구현 = 구현 대상(FAIL) |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K-SA | COMMON |  |  |  |  |  | 1 |  |  |  | 조회영역 토글 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| H4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| M4 | POPUP |  |  |  |  |  | 1 |  |  |  | 팝업 선택값 반영 |

## W1 기능 구현 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0012-0001 | X-NOTIMPL | W4 SetLockSumColumn(dead) / 동적 PIVOT | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — W4 SetLockSumColumn(dead) / 동적 PIVOT cs:353-362(호출부 없음) 미구현(반증, 구현 시 AS-IS 초과 결함) |  | 1 (W4 SetLockSumColumn(dead) / 동적 PIVOT) |

## W2 구현 위치 확인 (27)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0012-0002 | X-LOC | 2단 머지 헤더(Departure Port/Arrival Port/Dep | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (2단 머지 헤더(Departure Port/Arrival Port/Dep) |
| WK-SSP0012-0003 | X-LOC | 47컬럼 고정 스키마 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (47컬럼 고정 스키마) |
| WK-SSP0012-0004 | X-LOC | Division 변경 = Period 리셋 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Division 변경 = Period 리셋) |
| WK-SSP0012-0005 | X-LOC | Division(clbDivision) MyDivisionInEE + E | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Division(clbDivision) MyDivisionInEE + E) |
| WK-SSP0012-0006 | X-LOC | FCST_TYPE 코드→표시(SALES_TYPE_CODE) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (FCST_TYPE 코드→표시(SALES_TYPE_CODE)) |
| WK-SSP0012-0007 | X-LOC | From Site(clbPlantSite) EE/비-EE 분기 재조회 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (From Site(clbPlantSite) EE/비-EE 분기 재조회) |
| WK-SSP0012-0008 | X-LOC | G1 빈 그리드 가드 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G1 빈 그리드 가드) |
| WK-SSP0012-0009 | X-LOC | G2 컬럼 판정 가드 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G2 컬럼 판정 가드) |
| WK-SSP0012-0010 | X-LOC | G3 공백 CHANGE_REQ_NO 가드 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (G3 공백 CHANGE_REQ_NO 가드) |
| WK-SSP0012-0011 | X-LOC | INCOTERMS 좌측 고정(FIXED_FLAG=Y) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (INCOTERMS 좌측 고정(FIXED_FLAG=Y)) |
| WK-SSP0012-0012 | X-LOC | L1 권한 게이트(dtMyDivision 0건) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (L1 권한 게이트(dtMyDivision 0건)) |
| WK-SSP0012-0013 | X-LOC | L2 Insert = NO-OP | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (L2 Insert = NO-OP) |
| WK-SSP0012-0014 | X-LOC | L3 Delete = NO-OP | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (L3 Delete = NO-OP) |
| WK-SSP0012-0015 | X-LOC | L4 Save = NO-OP | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (L4 Save = NO-OP) |
| WK-SSP0012-0016 | X-LOC | L5 Edit = MSG00109 안내(읽기전용 가드) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (L5 Edit = MSG00109 안내(읽기전용 가드)) |
| WK-SSP0012-0017 | X-LOC | L6 Find = 조회 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (L6 Find = 조회) |
| WK-SSP0012-0018 | X-LOC | L7 btnColumn(컬럼설정) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (L7 btnColumn(컬럼설정)) |
| WK-SSP0012-0019 | X-LOC | LABEL 6종 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (LABEL 6종) |
| WK-SSP0012-0020 | X-LOC | Model(txtItemId) 팝업 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Model(txtItemId) 팝업) |
| WK-SSP0012-0021 | X-LOC | Sold To / Ship To Party | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Sold To / Ship To Party) |
| WK-SSP0012-0022 | X-LOC | W1/W3/W7 세로 머지 sticky | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (W1/W3/W7 세로 머지 sticky) |
| WK-SSP0012-0023 | X-LOC | W10 CHANGE_REQ_NO 셀 클릭 → 변경요청 상세 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (W10 CHANGE_REQ_NO 셀 클릭 → 변경요청 상세) |
| WK-SSP0012-0024 | X-LOC | W5 조회 바인딩 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (W5 조회 바인딩) |
| WK-SSP0012-0025 | X-LOC | W6 전열 읽기전용 잠금 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (W6 전열 읽기전용 잠금) |
| WK-SSP0012-0026 | X-LOC | W9 INCOTERMS 셀 클릭 → BOD 상세 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: Grid.tsx 없음 |  | 1 (W9 INCOTERMS 셀 클릭 → BOD 상세) |
| WK-SSP0012-0027 | X-LOC | hidden 4컬럼(PLAN_QTY/BOD_ID/ORIGIN_FROM_D | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (hidden 4컬럼(PLAN_QTY/BOD_ID/ORIGIN_FROM_D) |
| WK-SSP0012-0028 | X-LOC | usrConditionPanel1(HidePanel) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (usrConditionPanel1(HidePanel)) |

## W5 검사기 연결 (9)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0012-0029 | F2 | SSP0012 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SSP0012 화면 | 판단불가(대상 단위 SCREEN) | 2 (L4 Save = NO-OP COMMON:UC-03) |
| WK-SSP0012-0030 | G4 | btnColumn | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnColumn | 있음(FE 소스) | 2 (ACT:SSP0012_ShipmentPlanConfirmDetail.In) |
| WK-SSP0012-0031 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 없음 | 2 (ACT:SSP0012_ShipmentPlanConfirmDetail.In) |
| WK-SSP0012-0032 | G03-WIRE | SSP0012 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SSP0012 화면 | 판단불가(대상 단위 SCREEN) | 9 (ACT:SSP0012_ShipmentPlanConfirmDetail..c) |
| WK-SSP0012-0033 | G5 | CHANGE_REQ_NO | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL CHANGE_REQ_NO | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0012_ShipmentPlanConfirmDetail.Sp) |
| WK-SSP0012-0034 | G5 | INCOTERMS | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL INCOTERMS | 있음(SHEET_COLUMNS) | 4 (ACT:SSP0012_ShipmentPlanConfirmDetail.Sp) |
| WK-SSP0012-0035 | G5 | txtItemId / Model / Item Id / Model/Nick | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND txtItemId / Model / Item Id / Model/Nickname | 있음(FE 소스) | 1 (Model(txtItemId) 팝업) |
| WK-SSP0012-0036 | H6 | CHANGE_REQ_NO | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL CHANGE_REQ_NO | 있음(SHEET_COLUMNS) | 2 (ACT:SSP0012_ShipmentPlanConfirmDetail.Sp) |
| WK-SSP0012-0037 | H6 | INCOTERMS | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL INCOTERMS | 있음(SHEET_COLUMNS) | 4 (ACT:SSP0012_ShipmentPlanConfirmDetail.Sp) |

## W6 검증 실행 (61)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0012-0038 | J2 | SSP0012 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SSP0012 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 36 (L1 권한 게이트(dtMyDivision 0건) L2 Insert = N) |
| WK-SSP0012-0039 | C1 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0012_ShipmentPlanConfirmDetail.In) |
| WK-SSP0012-0040 | C1 | clbPlantSite / From Site / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbPlantSite / From Site / Plant Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0012_ShipmentPlanConfirmDetail.Se) |
| WK-SSP0012-0041 | C3 | CHANGE_REQ_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — CHANGE_REQ_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SSP0012_ShipmentPlanConfirmDetail.In) |
| WK-SSP0012-0042 | C3 | INCOTERMS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — INCOTERMS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 5 (ACT:SSP0012_ShipmentPlanConfirmDetail.In) |
| WK-SSP0012-0043 | G3 | SSP0012 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SSP0012 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 5 (usrConditionPanel1(HidePanel) COMMON:UC-) |
| WK-SSP0012-0044 | K-SA | SSP0012 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SSP0012 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 1 (usrConditionPanel1(HidePanel)) |
| WK-SSP0012-0045 | K4 | SSP0012 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SSP0012 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 22 (COMMON:UC-03 COMMON:UC-05 COMMON:UC-06 C) |
| WK-SSP0012-0046 | F1 | SSP0012 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SSP0012 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 3 (L3 Delete = NO-OP L4 Save = NO-OP COMMON) |
| WK-SSP0012-0047 | F5 | SSP0012 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SSP0012 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 1 (L3 Delete = NO-OP) |
| WK-SSP0012-0048 | F4 | PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: |  | 3 (Period* 기본값(오늘~+55영업일) ACT:SSP0012_Shipm) |
| WK-SSP0012-0049 | F4 | PKG_SSP0012.P_SSP0012_GET_SHIPMENT_PLAN_ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0012.P_SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 45 (ACT:SSP0012_ShipmentPlanConfirmDetail.Fi) |
| WK-SSP0012-0050 | A5 | BOD_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — BOD_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (hidden 4컬럼(PLAN_QTY/BOD_ID/ORIGIN_FROM_D) |
| WK-SSP0012-0051 | A5 | CHANGE_REQ_NO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — CHANGE_REQ_NO · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 10 (W10 CHANGE_REQ_NO 셀 클릭 → 변경요청 상세 G2 컬럼 판) |
| WK-SSP0012-0052 | A5 | DIVISION_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (W9 INCOTERMS 셀 클릭 → BOD 상세) |
| WK-SSP0012-0053 | A5 | INCOTERMS | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — INCOTERMS · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 14 (INCOTERMS 좌측 고정(FIXED_FLAG=Y) W9 INCOTER) |
| WK-SSP0012-0054 | A5 | ORIGIN_FROM_DIVISION_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ORIGIN_FROM_DIVISION_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective  |  | 2 (W9 INCOTERMS 셀 클릭 → BOD 상세 hidden 4컬럼(PL) |
| WK-SSP0012-0055 | G4 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (Division(clbDivision) MyDivisionInEE + E) |
| WK-SSP0012-0056 | G4 | clbPlantSite / From Site / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbPlantSite / From Site / Plant Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (From Site(clbPlantSite) EE/비-EE 분기 재조회) |
| WK-SSP0012-0057 | G4 | drpPeriod / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — drpPeriod / Period · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SSP0012_ShipmentPlanConfirmDetail.In) |
| WK-SSP0012-0058 | G4 | txtItemId / Model / Item Id / Model/Nick | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (Model(txtItemId) 팝업) |
| WK-SSP0012-0059 | H2 | BOD_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — BOD_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (hidden 4컬럼(PLAN_QTY/BOD_ID/ORIGIN_FROM_D) |
| WK-SSP0012-0060 | H2 | CHANGE_REQ_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — CHANGE_REQ_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 8 (W10 CHANGE_REQ_NO 셀 클릭 → 변경요청 상세 G2 컬럼 판) |
| WK-SSP0012-0061 | H2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (W9 INCOTERMS 셀 클릭 → BOD 상세) |
| WK-SSP0012-0062 | H2 | INCOTERMS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — INCOTERMS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 9 (INCOTERMS 좌측 고정(FIXED_FLAG=Y) W9 INCOTER) |
| WK-SSP0012-0063 | H2 | ORIGIN_FROM_DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ORIGIN_FROM_DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (W9 INCOTERMS 셀 클릭 → BOD 상세 hidden 4컬럼(PL) |
| WK-SSP0012-0064 | H4 | SSP0012 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — SSP0012 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 4 (ACT:SSP0012_ShipmentPlanConfirmDetail.Sp) |
| WK-SSP0012-0065 | H5 | BOD_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — BOD_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (hidden 4컬럼(PLAN_QTY/BOD_ID/ORIGIN_FROM_D) |
| WK-SSP0012-0066 | H5 | CHANGE_REQ_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — CHANGE_REQ_NO · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 8 (W10 CHANGE_REQ_NO 셀 클릭 → 변경요청 상세 G2 컬럼 판) |
| WK-SSP0012-0067 | H5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — DIVISION_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (W9 INCOTERMS 셀 클릭 → BOD 상세) |
| WK-SSP0012-0068 | H5 | INCOTERMS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — INCOTERMS · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 9 (INCOTERMS 좌측 고정(FIXED_FLAG=Y) W9 INCOTER) |
| WK-SSP0012-0069 | H5 | ORIGIN_FROM_DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ORIGIN_FROM_DIVISION_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (W9 INCOTERMS 셀 클릭 → BOD 상세 hidden 4컬럼(PL) |
| WK-SSP0012-0070 | I1 | SSP0012 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SSP0012 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 3 (L1 권한 게이트(dtMyDivision 0건) L5 Edit = MSG) |
| WK-SSP0012-0071 | SC1 | SSP0012 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SSP0012 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 8 (Division(clbDivision) MyDivisionInEE + E) |
| WK-SSP0012-0072 | D5 | CHANGE_REQ_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — CHANGE_REQ_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 5 (ACT:SSP0012_ShipmentPlanConfirmDetail.In) |
| WK-SSP0012-0073 | D5 | INCOTERMS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — INCOTERMS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 6 (ACT:SSP0012_ShipmentPlanConfirmDetail.In) |
| WK-SSP0012-0074 | D6 | SSP0012 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SSP0012 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 2 (L2 Insert = NO-OP COMMON:UC-03) |
| WK-SSP0012-0075 | E4 | CHANGE_REQ_NO | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — CHANGE_REQ_NO · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SSP0012_ShipmentPlanConfirmDetail.Se) |
| WK-SSP0012-0076 | E4 | INCOTERMS | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — INCOTERMS · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SSP0012_ShipmentPlanConfirmDetail.Se) |
| WK-SSP0012-0077 | E4 | MSG00097 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00097 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (L1 권한 게이트(dtMyDivision 0건)) |
| WK-SSP0012-0078 | E4 | MSG00109 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00109 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (L5 Edit = MSG00109 안내(읽기전용 가드) ACT:SSP00) |
| WK-SSP0012-0079 | E4 | MSG00667 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00667 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (L1 권한 게이트(dtMyDivision 0건)) |
| WK-SSP0012-0080 | E4 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 2 (ACT:SSP0012_ShipmentPlanConfirmDetail.Se) |
| WK-SSP0012-0081 | E4 | clbPlantSite / From Site / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbPlantSite / From Site / Plant Site · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저 |  | 2 (ACT:SSP0012_ShipmentPlanConfirmDetail.Se) |
| WK-SSP0012-0082 | E4 | drpPeriod / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — drpPeriod / Period · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 6 (ACT:SSP0012_ShipmentPlanConfirmDetail.Fi) |
| WK-SSP0012-0083 | A10 | SSP0012 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SSP0012 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 38 (ACT:SSP0012_ShipmentPlanConfirmDetail.De) |
| WK-SSP0012-0084 | A6 | PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회)  |  | 1 (Period* 기본값(오늘~+55영업일)) |
| WK-SSP0012-0085 | A6 | PKG_SSP0012.P_SSP0012_GET_SHIPMENT_PLAN_ | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0012.P_SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOUR |  | 45 (ACT:SSP0012_ShipmentPlanConfirmDetail.Fi) |
| WK-SSP0012-0086 | G1 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (Division(clbDivision) MyDivisionInEE + E) |
| WK-SSP0012-0087 | G1 | clbPlantSite / From Site / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbPlantSite / From Site / Plant Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (From Site(clbPlantSite) EE/비-EE 분기 재조회 A) |
| WK-SSP0012-0088 | G1 | drpPeriod / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — drpPeriod / Period · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 5 (ACT:SSP0012_ShipmentPlanConfirmDetail.Fi) |
| WK-SSP0012-0089 | G1 | txtItemId / Model / Item Id / Model/Nick | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (Model(txtItemId) 팝업 ACT:SSP0012_Shipment) |
| WK-SSP0012-0090 | G1 | txtShipToParty / Ship To Party / Ship to | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtShipToParty / Ship To Party / Ship to Party · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0012_ShipmentPlanConfirmDetail.Fi) |
| WK-SSP0012-0091 | G1 | txtSoldToParty / Sold To Party | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtSoldToParty / Sold To Party · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0012_ShipmentPlanConfirmDetail.Fi) |
| WK-SSP0012-0092 | G6 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (Division(clbDivision) MyDivisionInEE + E) |
| WK-SSP0012-0093 | G6 | clbPlantSite / From Site / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbPlantSite / From Site / Plant Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (From Site(clbPlantSite) EE/비-EE 분기 재조회) |
| WK-SSP0012-0094 | G6 | drpPeriod / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — drpPeriod / Period · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SSP0012_ShipmentPlanConfirmDetail.In) |
| WK-SSP0012-0095 | G6 | txtItemId / Model / Item Id / Model/Nick | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (Model(txtItemId) 팝업) |
| WK-SSP0012-0096 | X-REOPEN | SSP0012 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SSP0012 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 6 (ACT:SSP0012_ShipmentPlanConfirmDetail.Di) |
| WK-SSP0012-0097 | H6 | txtItemId / Model / Item Id / Model/Nick | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (Model(txtItemId) 팝업) |
| WK-SSP0012-0098 | M4 | txtItemId / Model / Item Id / Model/Nick | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (Model(txtItemId) 팝업) |

## W7 기대값 확정 (99)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0012-0099 | C3 | SSP0012_ShipmentPlanConfirmDetail.CboPla | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0012_ShipmentPlanConfirmDetail.CboPlanDate_Sele: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0012_ShipmentPlanConfirmDetail.Cb) |
| WK-SSP0012-0100 | C3 | SSP0012_ShipmentPlanConfirmDetail.SetCha | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0012_ShipmentPlanConfirmDetail.SetChangedContro: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0012_ShipmentPlanConfirmDetail.Se) |
| WK-SSP0012-0101 | C3 | SSP0012_ShipmentPlanConfirmDetail.SetCha | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0012_ShipmentPlanConfirmDetail.SetChangedPeriod: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0012_ShipmentPlanConfirmDetail.Se) |
| WK-SSP0012-0102 | C3 | SSP0012_ShipmentPlanConfirmDetail.SetLoc | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0012_ShipmentPlanConfirmDetail.SetLockSumColumn: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0012_ShipmentPlanConfirmDetail.Se) |
| WK-SSP0012-0103 | C3 | SSP0012_ShipmentPlanConfirmDetail.clbDiv | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0012_ShipmentPlanConfirmDetail.clbDivision_Sele: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0012_ShipmentPlanConfirmDetail.cl) |
| WK-SSP0012-0104 | A5 | 2단 머지 헤더(Departure Port/Arrival Port/Dep | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 2단 머지 헤더(Departure Port/Arrival Port/Departure day: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (2단 머지 헤더(Departure Port/Arrival Port/Dep) |
| WK-SSP0012-0105 | A5 | 47컬럼 고정 스키마 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 47컬럼 고정 스키마: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (47컬럼 고정 스키마) |
| WK-SSP0012-0106 | A5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-07: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0012-0107 | A5 | FCST_TYPE 코드→표시(SALES_TYPE_CODE) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — FCST_TYPE 코드→표시(SALES_TYPE_CODE): 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (FCST_TYPE 코드→표시(SALES_TYPE_CODE)) |
| WK-SSP0012-0108 | A5 | G1 빈 그리드 가드 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — G1 빈 그리드 가드: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (G1 빈 그리드 가드) |
| WK-SSP0012-0109 | A5 | SSP0012_ShipmentPlanConfirmDetail.Create | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SSP0012_ShipmentPlanConfirmDetail.CreateSpread: 진입점 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0012_ShipmentPlanConfirmDetail.Cr) |
| WK-SSP0012-0110 | A5 | W1/W3/W7 세로 머지 sticky | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — W1/W3/W7 세로 머지 sticky: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (W1/W3/W7 세로 머지 sticky) |
| WK-SSP0012-0111 | A5 | W5 조회 바인딩 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — W5 조회 바인딩: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (W5 조회 바인딩) |
| WK-SSP0012-0112 | A5 | W6 전열 읽기전용 잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — W6 전열 읽기전용 잠금: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (W6 전열 읽기전용 잠금) |
| WK-SSP0012-0113 | G4 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — COMMON:UC-06: 행 집계 — G4 6요소: NOT_RUN:4 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SSP0012-0114 | G4 | Division 변경 = Period 리셋 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — Division 변경 = Period 리셋: 행 집계 — G4 6요소: NOT_RUN:4 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (Division 변경 = Period 리셋) |
| WK-SSP0012-0115 | G4 | LABEL 6종 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — LABEL 6종: 행 집계 — G4 6요소: NOT_RUN:4 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (LABEL 6종) |
| WK-SSP0012-0116 | G4 | Period* 기본값(오늘~+55영업일) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — Period* 기본값(오늘~+55영업일): 행 집계 — G4 6요소: NOT_RUN:4 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (Period* 기본값(오늘~+55영업일)) |
| WK-SSP0012-0117 | G4 | Sold To / Ship To Party | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — Sold To / Ship To Party: 행 집계 — G4 6요소: NOT_RUN:4 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (Sold To / Ship To Party) |
| WK-SSP0012-0118 | H2 | 2단 머지 헤더(Departure Port/Arrival Port/Dep | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 2단 머지 헤더(Departure Port/Arrival Port/Departure day: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (2단 머지 헤더(Departure Port/Arrival Port/Dep) |
| WK-SSP0012-0119 | H2 | 47컬럼 고정 스키마 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 47컬럼 고정 스키마: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (47컬럼 고정 스키마) |
| WK-SSP0012-0120 | H2 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-07: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0012-0121 | H2 | FCST_TYPE 코드→표시(SALES_TYPE_CODE) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — FCST_TYPE 코드→표시(SALES_TYPE_CODE): 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (FCST_TYPE 코드→표시(SALES_TYPE_CODE)) |
| WK-SSP0012-0122 | H2 | G1 빈 그리드 가드 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — G1 빈 그리드 가드: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (G1 빈 그리드 가드) |
| WK-SSP0012-0123 | H2 | SSP0012_ShipmentPlanConfirmDetail.Create | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SSP0012_ShipmentPlanConfirmDetail.CreateSpread: 진입점 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0012_ShipmentPlanConfirmDetail.Cr) |
| WK-SSP0012-0124 | H2 | W1/W3/W7 세로 머지 sticky | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — W1/W3/W7 세로 머지 sticky: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (W1/W3/W7 세로 머지 sticky) |
| WK-SSP0012-0125 | H2 | W5 조회 바인딩 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — W5 조회 바인딩: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (W5 조회 바인딩) |
| WK-SSP0012-0126 | H2 | W6 전열 읽기전용 잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — W6 전열 읽기전용 잠금: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (W6 전열 읽기전용 잠금) |
| WK-SSP0012-0127 | H5 | 2단 머지 헤더(Departure Port/Arrival Port/Dep | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 2단 머지 헤더(Departure Port/Arrival Port/Departure day: 행 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (2단 머지 헤더(Departure Port/Arrival Port/Dep) |
| WK-SSP0012-0128 | H5 | 47컬럼 고정 스키마 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 47컬럼 고정 스키마: 행 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (47컬럼 고정 스키마) |
| WK-SSP0012-0129 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0012-0130 | H5 | FCST_TYPE 코드→표시(SALES_TYPE_CODE) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — FCST_TYPE 코드→표시(SALES_TYPE_CODE): 행 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (FCST_TYPE 코드→표시(SALES_TYPE_CODE)) |
| WK-SSP0012-0131 | H5 | G1 빈 그리드 가드 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — G1 빈 그리드 가드: 행 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (G1 빈 그리드 가드) |
| WK-SSP0012-0132 | H5 | SSP0012_ShipmentPlanConfirmDetail.Create | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SSP0012_ShipmentPlanConfirmDetail.CreateSpread: 진입점 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0012_ShipmentPlanConfirmDetail.Cr) |
| WK-SSP0012-0133 | H5 | W1/W3/W7 세로 머지 sticky | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — W1/W3/W7 세로 머지 sticky: 행 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (W1/W3/W7 세로 머지 sticky) |
| WK-SSP0012-0134 | H5 | W5 조회 바인딩 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — W5 조회 바인딩: 행 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (W5 조회 바인딩) |
| WK-SSP0012-0135 | H5 | W6 전열 읽기전용 잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — W6 전열 읽기전용 잠금: 행 집계 — H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (W6 전열 읽기전용 잠금) |
| WK-SSP0012-0136 | X-REASON | COMMON:UC-01 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-01 필터링 상태 신규행 Insert 시 필터 유지한 채 추가 행 노출(keepRowVisibleUnderFilter) — 조회전용 inquiry — 신규행 Insert 없음(hot |  | 1 (COMMON:UC-01) |
| WK-SSP0012-0137 | X-REASON | COMMON:UC-02 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-02 데이터 수정 중 다른 조회 시도 = confirm(MSG00703) — 조회전용 inquiry — 편집 없음(전열 isReadOnly, ShipmentPlanConfirmDet |  | 1 (COMMON:UC-02) |
| WK-SSP0012-0138 | X-REASON | COMMON:UC-04 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-04 CRUD 완료 알림 = 하단 중앙 Toast 자동 소멸 — 조회전용 inquiry — CRUD 완료 이벤트 없음(SEARCH 만 동작). 완료 Toast 대상 미해당 해당없음 |  | 1 (COMMON:UC-04) |
| WK-SSP0012-0139 | D5 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — COMMON:UC-05: 행 집계 — D5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SSP0012-0140 | D5 | SSP0012_ShipmentPlanConfirmDetail.Create | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SSP0012_ShipmentPlanConfirmDetail.CreateSpread: 진입점 집계 — D5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0012_ShipmentPlanConfirmDetail.Cr) |
| WK-SSP0012-0141 | E4 | SSP0012_ShipmentPlanConfirmDetail.SetCha | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0012_ShipmentPlanConfirmDetail.SetChangedContro: 진입점 집계 — E4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0012_ShipmentPlanConfirmDetail.Se) |
| WK-SSP0012-0142 | E4 | SSP0012_ShipmentPlanConfirmDetail.SetCha | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0012_ShipmentPlanConfirmDetail.SetChangedPeriod: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0012_ShipmentPlanConfirmDetail.Se) |
| WK-SSP0012-0143 | E4 | SSP0012_ShipmentPlanConfirmDetail.SetLoc | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0012_ShipmentPlanConfirmDetail.SetLockSumColumn: 진입점 집계 — E4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0012_ShipmentPlanConfirmDetail.Se) |
| WK-SSP0012-0144 | A1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-03: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (COMMON:UC-03) |
| WK-SSP0012-0145 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (COMMON:UC-06) |
| WK-SSP0012-0146 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (COMMON:UC-07) |
| WK-SSP0012-0147 | A1 | Division 변경 = Period 리셋 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Division 변경 = Period 리셋: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (Division 변경 = Period 리셋) |
| WK-SSP0012-0148 | A1 | Division(clbDivision) MyDivisionInEE + E | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Division(clbDivision) MyDivisionInEE + EE 제외: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (Division(clbDivision) MyDivisionInEE + E) |
| WK-SSP0012-0149 | A1 | From Site(clbPlantSite) EE/비-EE 분기 재조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — From Site(clbPlantSite) EE/비-EE 분기 재조회: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (From Site(clbPlantSite) EE/비-EE 분기 재조회) |
| WK-SSP0012-0150 | A1 | L1 권한 게이트(dtMyDivision 0건) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — L1 권한 게이트(dtMyDivision 0건): 행 집계 — A1 2요소: REVIEW:2 |  | 1 (L1 권한 게이트(dtMyDivision 0건)) |
| WK-SSP0012-0151 | A1 | L6 Find = 조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — L6 Find = 조회: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (L6 Find = 조회) |
| WK-SSP0012-0152 | A1 | LABEL 6종 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — LABEL 6종: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (LABEL 6종) |
| WK-SSP0012-0153 | A1 | Model(txtItemId) 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Model(txtItemId) 팝업: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (Model(txtItemId) 팝업) |
| WK-SSP0012-0154 | A1 | PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD: 골든 비교 케이스 없음(PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD — 팝업·보조 SP 는 golden_ca |  | 1 (Period* 기본값(오늘~+55영업일)) |
| WK-SSP0012-0155 | A1 | PKG_SSP0012.P_SSP0012_GET_SHIPMENT_PLAN_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0012.P_SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DE: 골든 비교 케이스 없음(PKG_SSP0012.P_SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAI |  | 45 (ACT:SSP0012_ShipmentPlanConfirmDetail.Fi) |
| WK-SSP0012-0156 | A1 | Sold To / Ship To Party | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Sold To / Ship To Party: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (Sold To / Ship To Party) |
| WK-SSP0012-0157 | A1 | W5 조회 바인딩 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — W5 조회 바인딩: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (W5 조회 바인딩) |
| WK-SSP0012-0158 | G1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-03: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-SSP0012-0159 | G1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-06: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SSP0012-0160 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0012-0161 | G1 | Division 변경 = Period 리셋 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Division 변경 = Period 리셋: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (Division 변경 = Period 리셋) |
| WK-SSP0012-0162 | G1 | L1 권한 게이트(dtMyDivision 0건) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — L1 권한 게이트(dtMyDivision 0건): 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (L1 권한 게이트(dtMyDivision 0건)) |
| WK-SSP0012-0163 | G1 | L6 Find = 조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — L6 Find = 조회: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (L6 Find = 조회) |
| WK-SSP0012-0164 | G1 | LABEL 6종 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — LABEL 6종: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (LABEL 6종) |
| WK-SSP0012-0165 | G1 | Period* 기본값(오늘~+55영업일) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Period* 기본값(오늘~+55영업일): 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (Period* 기본값(오늘~+55영업일)) |
| WK-SSP0012-0166 | G1 | Sold To / Ship To Party | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Sold To / Ship To Party: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (Sold To / Ship To Party) |
| WK-SSP0012-0167 | G1 | W5 조회 바인딩 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — W5 조회 바인딩: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (W5 조회 바인딩) |
| WK-SSP0012-0168 | G6 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — COMMON:UC-06: 행 집계 — G6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SSP0012-0169 | G6 | Division 변경 = Period 리셋 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — Division 변경 = Period 리셋: 행 집계 — G6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (Division 변경 = Period 리셋) |
| WK-SSP0012-0170 | G6 | LABEL 6종 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — LABEL 6종: 행 집계 — G6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (LABEL 6종) |
| WK-SSP0012-0171 | G6 | Period* 기본값(오늘~+55영업일) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — Period* 기본값(오늘~+55영업일): 행 집계 — G6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (Period* 기본값(오늘~+55영업일)) |
| WK-SSP0012-0172 | G6 | Sold To / Ship To Party | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — Sold To / Ship To Party: 행 집계 — G6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (Sold To / Ship To Party) |
| WK-SSP0012-0173 | X-ROW | Form(BaseFormAsync) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — Form(BaseFormAsync): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (Form(BaseFormAsync)) |
| WK-SSP0012-0174 | X-ROW | L7 btnColumn(컬럼설정) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — L7 btnColumn(컬럼설정): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (L7 btnColumn(컬럼설정)) |
| WK-SSP0012-0175 | X-ROW | SSP0012_ShipmentPlanConfirmDetail.BtnCol | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0012_ShipmentPlanConfirmDetail.BtnColumn_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SSP0012_ShipmentPlanConfirmDetail.Bt) |
| WK-SSP0012-0176 | X-ROW | SSP0012_ShipmentPlanConfirmDetail.CboPla | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0012_ShipmentPlanConfirmDetail.CboPlanDate_Sele: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0012_ShipmentPlanConfirmDetail.Cb) |
| WK-SSP0012-0177 | X-ROW | SSP0012_ShipmentPlanConfirmDetail.ClearU | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0012_ShipmentPlanConfirmDetail.ClearUsrCheckedL: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/LIST_REBIND/STATE_RESET, |  | 4 (ACT:SSP0012_ShipmentPlanConfirmDetail.Cl) |
| WK-SSP0012-0178 | X-ROW | SSP0012_ShipmentPlanConfirmDetail.Create | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0012_ShipmentPlanConfirmDetail.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0012_ShipmentPlanConfirmDetail.Cr) |
| WK-SSP0012-0179 | X-ROW | SSP0012_ShipmentPlanConfirmDetail.Define | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0012_ShipmentPlanConfirmDetail.DefineProperty: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SSP0012_ShipmentPlanConfirmDetail.De) |
| WK-SSP0012-0180 | X-ROW | SSP0012_ShipmentPlanConfirmDetail.EditBu | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0012_ShipmentPlanConfirmDetail.EditButton: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0012_ShipmentPlanConfirmDetail.Ed) |
| WK-SSP0012-0181 | X-ROW | SSP0012_ShipmentPlanConfirmDetail.FindBu | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0012_ShipmentPlanConfirmDetail.FindButton: 진입점 집계 3검사 — NOT_RUN:2 · REVIEW:1 |  | 1 (ACT:SSP0012_ShipmentPlanConfirmDetail.Fi) |
| WK-SSP0012-0182 | X-ROW | SSP0012_ShipmentPlanConfirmDetail.FindDa | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0012_ShipmentPlanConfirmDetail.FindData_Main: 진입점 집계 12검사 — NOT_RUN:10 · REVIEW:1 · PASS:1 |  | 8 (ACT:SSP0012_ShipmentPlanConfirmDetail.Fi) |
| WK-SSP0012-0183 | X-ROW | SSP0012_ShipmentPlanConfirmDetail.Form_L | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0012_ShipmentPlanConfirmDetail.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0012_ShipmentPlanConfirmDetail.Fo) |
| WK-SSP0012-0184 | X-ROW | SSP0012_ShipmentPlanConfirmDetail.GetDay | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0012_ShipmentPlanConfirmDetail.GetDayRange: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:1 · TODO:1 · PASS:1 (미실행 검사가 남아 판정필요 |  | 1 (ACT:SSP0012_ShipmentPlanConfirmDetail.Ge) |
| WK-SSP0012-0185 | X-ROW | SSP0012_ShipmentPlanConfirmDetail.GetShi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0012_ShipmentPlanConfirmDetail.GetShipToParty: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0012_ShipmentPlanConfirmDetail.Ge) |
| WK-SSP0012-0186 | X-ROW | SSP0012_ShipmentPlanConfirmDetail.GetShi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0012_ShipmentPlanConfirmDetail.GetShipType: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0012_ShipmentPlanConfirmDetail.Ge) |
| WK-SSP0012-0187 | X-ROW | SSP0012_ShipmentPlanConfirmDetail.GetSol | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0012_ShipmentPlanConfirmDetail.GetSoldToParty: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0012_ShipmentPlanConfirmDetail.Ge) |
| WK-SSP0012-0188 | X-ROW | SSP0012_ShipmentPlanConfirmDetail.InitCo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0012_ShipmentPlanConfirmDetail.InitControls: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0012_ShipmentPlanConfirmDetail.In) |
| WK-SSP0012-0189 | X-ROW | SSP0012_ShipmentPlanConfirmDetail.InitSp | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0012_ShipmentPlanConfirmDetail.InitSpread: 진입점 집계 11검사 — NOT_RUN:11 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SSP0012_ShipmentPlanConfirmDetail.In) |
| WK-SSP0012-0190 | X-ROW | SSP0012_ShipmentPlanConfirmDetail.SetCha | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0012_ShipmentPlanConfirmDetail.SetChangedContro: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SSP0012_ShipmentPlanConfirmDetail.Se) |
| WK-SSP0012-0191 | X-ROW | SSP0012_ShipmentPlanConfirmDetail.SetCha | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0012_ShipmentPlanConfirmDetail.SetChangedPeriod: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SSP0012_ShipmentPlanConfirmDetail.Se) |
| WK-SSP0012-0192 | X-ROW | SSP0012_ShipmentPlanConfirmDetail.SetIma | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0012_ShipmentPlanConfirmDetail.SetImageCell: 진입점 집계 12검사 — NOT_RUN:12 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0012_ShipmentPlanConfirmDetail.Se) |
| WK-SSP0012-0193 | X-ROW | SSP0012_ShipmentPlanConfirmDetail.SetLoc | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0012_ShipmentPlanConfirmDetail.SetLockSumColumn: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0012_ShipmentPlanConfirmDetail.Se) |
| WK-SSP0012-0194 | X-ROW | SSP0012_ShipmentPlanConfirmDetail.SpdMai | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0012_ShipmentPlanConfirmDetail.SpdMain_CellClic: 진입점 집계 6검사 — NOPATH:4 · NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 23 (ACT:SSP0012_ShipmentPlanConfirmDetail.Sp) |
| WK-SSP0012-0195 | X-ROW | SSP0012_ShipmentPlanConfirmDetail.SpdMai | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0012_ShipmentPlanConfirmDetail.SpdMain_TopChang: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0012_ShipmentPlanConfirmDetail.Sp) |
| WK-SSP0012-0196 | X-ROW | SSP0012_ShipmentPlanConfirmDetail.btnIte | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0012_ShipmentPlanConfirmDetail.btnItemId_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SSP0012_ShipmentPlanConfirmDetail.bt) |
| WK-SSP0012-0197 | X-ROW | SSP0012_ShipmentPlanConfirmDetail.clbDiv | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0012_ShipmentPlanConfirmDetail.clbDivision_Sele: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0012_ShipmentPlanConfirmDetail.cl) |

## W8 구현 후 검증 (3)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0012-0198 | A5 | W4 SetLockSumColumn(dead) / 동적 PIVOT | 선행 W1 완료 후 E2E | A5 — 대조표 미구현 행 W4 SetLockSumColumn(dead) / 동적 PIVOT 구현 후 검증 · 대상 W4 SetLockSumColumn(dead) / 동적 PIVOT |  | 1 (W4 SetLockSumColumn(dead) / 동적 PIVOT) |
| WK-SSP0012-0199 | H2 | W4 SetLockSumColumn(dead) / 동적 PIVOT | 선행 W1 완료 후 E2E | H2 — 대조표 미구현 행 W4 SetLockSumColumn(dead) / 동적 PIVOT 구현 후 검증 · 대상 W4 SetLockSumColumn(dead) / 동적 PIVOT |  | 1 (W4 SetLockSumColumn(dead) / 동적 PIVOT) |
| WK-SSP0012-0200 | H5 | W4 SetLockSumColumn(dead) / 동적 PIVOT | 선행 W1 완료 후 검증 | H5 — 대조표 미구현 행 W4 SetLockSumColumn(dead) / 동적 PIVOT 구현 후 검증 · 대상 W4 SetLockSumColumn(dead) / 동적 PIVOT |  | 1 (W4 SetLockSumColumn(dead) / 동적 PIVOT) |
