# 작업 원장 — SSP0003 · 2026-10-26 12:55

> 검사 인스턴스 316건 중 PASS·NA 12건 외 **304건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 12 | 구현 위치 실존 |
| W4 | 검사기 구현 | 4 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 22 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 161 | 실행 → PASS |
| W7 | 기대값 확정 | 105 | 기대 확정 → PASS/FAIL |

- 담당: E2E 161 · 사람 판정 / AS-IS 원문 확인 → 재판정 105 · 하네스 26 · 대조표 12
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 15건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 40 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| E4 | EDIT |  |  |  |  |  | 33 | 4 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| X-LOC | GEN |  | 12 |  |  |  |  | 20 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| A5 | DESIGN |  |  |  |  |  | 16 | 3 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H2 | DESIGN |  |  |  |  |  | 16 | 3 |  |  | 배경·글자색 규칙 |
| H5 | DESIGN |  |  |  |  |  | 15 | 2 |  |  | 라벨 명칭 |
| D5 | EDIT |  |  |  |  |  | 14 | 1 |  |  | 셀 에디터 유형 |
| F4 | DB |  |  |  |  |  | 13 |  |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| DB-SYN | DB |  |  |  |  | 10 |  |  |  |  | BE 계정 시노님·권한·대상 객체 |
| G4 | DESIGN |  |  |  |  | 5 | 4 | 1 |  |  | 조회조건 표시·라벨·활성 |
| C3 | CASCADE |  |  |  |  |  | 5 | 5 |  |  | 연쇄 자동 채움 |
| D3 | EDIT |  |  |  |  |  | 7 | 3 |  |  | 행 값 기반 조건부 잠금 |
| G1 | GEN |  |  |  |  |  | 7 | 3 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| M4 | POPUP |  |  |  |  |  | 6 | 3 |  |  | 팝업 선택값 반영 |
| B3 | COMBO |  |  |  | 4 |  |  | 4 |  |  | 콤보 후보 정렬 = AS-IS |
| B4 | COMBO |  |  |  |  | 4 |  | 4 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| D1 | EDIT |  |  |  |  |  | 5 | 3 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| G6 | GEN |  |  |  |  |  | 4 | 1 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| A1 | GEN |  |  |  |  |  |  | 5 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| C1 | CASCADE |  |  |  |  |  | 4 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| A6 | GEN |  |  |  |  |  | 2 |  |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K-SA | COMMON |  |  |  |  |  | 1 |  |  |  | 조회영역 토글 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| H4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W2 구현 위치 확인 (12)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0003-0001 | X-LOC | btnApproval/btnReject/btnSelfReject(우상단  | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (btnApproval/btnReject/btnSelfReject(우상단 ) |
| WK-SSP0003-0002 | X-LOC | cboChangeType(기본 ALL) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cboChangeType(기본 ALL)) |
| WK-SSP0003-0003 | X-LOC | cboStatus(기본 Q) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cboStatus(기본 Q)) |
| WK-SSP0003-0004 | X-LOC | clbDivision(다중+ALL) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (clbDivision(다중+ALL)) |
| WK-SSP0003-0005 | X-LOC | clbFromSite(다중+ALL) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (clbFromSite(다중+ALL)) |
| WK-SSP0003-0006 | X-LOC | drpPeriod(D-14) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (drpPeriod(D-14)) |
| WK-SSP0003-0007 | X-LOC | spdMain(siMain 22열) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (spdMain(siMain 22열)) |
| WK-SSP0003-0008 | X-LOC | txtApprovalDeptName(FpSpread=siSub 54열,  | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (txtApprovalDeptName(FpSpread=siSub 54열, ) |
| WK-SSP0003-0009 | X-LOC | txtItemID+btnItemId | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (txtItemID+btnItemId) |
| WK-SSP0003-0010 | X-LOC | txtRequest+btnRequestUser | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (txtRequest+btnRequestUser) |
| WK-SSP0003-0011 | X-LOC | usrConditionPanel1(조회조건 7종) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (usrConditionPanel1(조회조건 7종)) |
| WK-SSP0003-0012 | X-LOC | 디테일 폼 8필드 + txtRejectReason | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (디테일 폼 8필드 + txtRejectReason) |

## W4 검사기 구현 (4)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0003-0013 | B3 | CONFIRM_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 CONFIRM_ID | 있음(SHEET_COLUMNS) | 4 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0014 | B3 | cboChangeType / Change Type | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboChangeType / Change Type | 있음(FE 소스) | 1 (cboChangeType(기본 ALL)) |
| WK-SSP0003-0015 | B3 | cboStatus / Status | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboStatus / Status | 있음(FE 소스) | 1 (cboStatus(기본 Q)) |
| WK-SSP0003-0016 | B3 | txtRequestNo / Request No | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 txtRequestNo / Request No | 있음(FE 소스) | 4 (ACT:SSP0003_ShipmentChangeRequestConfirm) |

## W5 검사기 연결 (22)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0003-0017 | B4 | CONFIRM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL CONFIRM_ID | 있음(SHEET_COLUMNS) | 4 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0018 | B4 | cboChangeType / Change Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboChangeType / Change Type | 있음(FE 소스) | 1 (cboChangeType(기본 ALL)) |
| WK-SSP0003-0019 | B4 | cboStatus / Status | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboStatus / Status | 있음(FE 소스) | 1 (cboStatus(기본 Q)) |
| WK-SSP0003-0020 | B4 | txtRequestNo / Request No | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND txtRequestNo / Request No | 있음(FE 소스) | 4 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0021 | F2 | SSP0003 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SSP0003 화면 | 판단불가(대상 단위 SCREEN) | 158 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0022 | F6 | SSP0003 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SSP0003 화면 | 판단불가(대상 단위 SCREEN) | 158 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0023 | DB-SYN | SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONF | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM | 없음(PROC_M 대응 없음) | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0024 | DB-SYN | SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRA | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING | 없음(PROC_M 대응 없음) | 3 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0025 | DB-SYN | SSP0003_GET_SSP_PLAN_PROCESSING_CHECK | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0003_GET_SSP_PLAN_PROCESSING_CHECK | 없음(PROC_M 대응 없음) | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0026 | DB-SYN | SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM | 없음(PROC_M 대응 없음) | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0027 | DB-SYN | SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40 | 없음(PROC_M 대응 없음) | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0028 | DB-SYN | SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK | 없음(PROC_M 대응 없음) | 10 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0029 | DB-SYN | SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM | 없음(PROC_M 대응 없음) | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0030 | DB-SYN | SSP0200_GET_PLANT_SITE_BY_DIVISION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0200_GET_PLANT_SITE_BY_DIVISION | 없음(PROC_M 대응 없음) | 4 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0031 | DB-SYN | SSP0200_GET_SHIPMENT_DIVISION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0200_GET_SHIPMENT_DIVISION | 없음(PROC_M 대응 없음) | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0032 | DB-SYN | SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE | 없음(PROC_M 대응 없음) | 4 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0033 | G4 | btnApproval | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnApproval | 없음 | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0034 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 없음 | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0035 | G4 | btnReject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnReject | 없음 | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0036 | G4 | btnRequestUser | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnRequestUser | 없음 | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0037 | G4 | btnSelfReject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnSelfReject | 없음 | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0038 | G03-WIRE | SSP0003 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SSP0003 화면 | 판단불가(대상 단위 SCREEN) | 12 (ACT:SSP0003_ShipmentChangeRequestConfirm) |

## W6 검증 실행 (161)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0003-0039 | J2 | SSP0003 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SSP0003 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 105 (usrConditionPanel1(조회조건 7종) btnApproval/) |
| WK-SSP0003-0040 | C1 | cboChangeType / Change Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboChangeType / Change Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0041 | C1 | cboStatus / Status | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboStatus / Status · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0042 | C1 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0043 | C1 | clbFromSite / From Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbFromSite / From Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0044 | C3 | APPROVAL_USER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — APPROVAL_USER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0045 | C3 | CHANGE_REQ_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — CHANGE_REQ_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0046 | C3 | CHK | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — CHK · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 7 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0047 | C3 | ERP_SO_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ERP_SO_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0048 | C3 | REQUEST_USER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — REQUEST_USER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0049 | G3 | SSP0003 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SSP0003 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 2 (usrConditionPanel1(조회조건 7종) btnApproval/) |
| WK-SSP0003-0050 | K-SA | SSP0003 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SSP0003 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 2 (usrConditionPanel1(조회조건 7종) btnApproval/) |
| WK-SSP0003-0051 | K4 | SSP0003 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SSP0003 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 101 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0052 | F1 | SSP0003 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SSP0003 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 158 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0053 | F4 | PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: |  | 3 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0054 | F4 | PKG_SSP0003.P_SSP0003_GET_DELEGATEE_LOAD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0003.P_SSP0003_GET_DELEGATEE_LOAD · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: |  | 4 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0055 | F4 | PKG_SSP0200.P_SSP0200_GET_SHIPMENT_STATU | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0200.P_SSP0200_GET_SHIPMENT_STATUS · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요 |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0056 | F4 | SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONF | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행  |  | 199 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0057 | F4 | SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실 |  | 41 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0058 | F4 | SSP0003_GET_SSP_PLAN_PROCESSING_CHECK | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SSP0003_GET_SSP_PLAN_PROCESSING_CHECK · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: sm |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0059 | F4 | SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: sm |  | 157 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0060 | F4 | SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_40 · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: |  | 157 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0061 | F4 | SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SSP0003_SAVE_SHIPMENT_REQUEST_CONFIRM_IF_CHECK · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) —  |  | 10 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0062 | F4 | SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SSP0003_SAVE_SHIPMENT_REQUEST_DE_CONFIRM · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0063 | F4 | SSP0200_GET_PLANT_SITE_BY_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SSP0200_GET_PLANT_SITE_BY_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke |  | 4 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0064 | F4 | SSP0200_GET_SHIPMENT_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SSP0200_GET_SHIPMENT_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trac |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0065 | F4 | SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SSP0200_GET_SHIPMENT_PLAN_PLANT_SITE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smo |  | 4 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0066 | A5 | APPROVAL_USER | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — APPROVAL_USER · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (btnApproval/btnReject/btnSelfReject(우상단 ) |
| WK-SSP0003-0067 | A5 | CHK | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — CHK · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0068 | A5 | DELEGATEE_USER | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DELEGATEE_USER · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (btnApproval/btnReject/btnSelfReject(우상단 ) |
| WK-SSP0003-0069 | A5 | ERP_SO_NO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ERP_SO_NO · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 4 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0070 | A5 | ETA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ETA · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0071 | A5 | ETD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ETD · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0072 | A5 | LT_DAY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — LT_DAY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0073 | A5 | NEW_ETA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NEW_ETA · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0074 | A5 | NEW_ETD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NEW_ETD · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0075 | A5 | NEW_LT_DAY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NEW_LT_DAY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0076 | A5 | NEW_SHIPMENT_CONFIRM_QTY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NEW_SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0077 | A5 | NEW_SHIPMENT_DATE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NEW_SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0078 | A5 | NEW_TRANSPORT_MODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NEW_TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0079 | A5 | SHIPMENT_CONFIRM_QTY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Div |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0080 | A5 | SHIPMENT_DATE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0081 | A5 | TRANSPORT_MODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0082 | G4 | cboChangeType / Change Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboChangeType / Change Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0083 | G4 | cboStatus / Status | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboStatus / Status · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0084 | G4 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0085 | G4 | drpPeriod / Request Date / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — drpPeriod / Request Date / Period · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0086 | H2 | APPROVAL_USER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — APPROVAL_USER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (btnApproval/btnReject/btnSelfReject(우상단 ) |
| WK-SSP0003-0087 | H2 | CHK | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — CHK · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0088 | H2 | DELEGATEE_USER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DELEGATEE_USER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (btnApproval/btnReject/btnSelfReject(우상단 ) |
| WK-SSP0003-0089 | H2 | ERP_SO_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ERP_SO_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0090 | H2 | ETA | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ETA · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0091 | H2 | ETD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ETD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0092 | H2 | LT_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — LT_DAY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0093 | H2 | NEW_ETA | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NEW_ETA · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0094 | H2 | NEW_ETD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NEW_ETD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0095 | H2 | NEW_LT_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NEW_LT_DAY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0096 | H2 | NEW_SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NEW_SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0097 | H2 | NEW_SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NEW_SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0098 | H2 | NEW_TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NEW_TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0099 | H2 | SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0100 | H2 | SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0101 | H2 | TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0102 | H4 | SSP0003 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — SSP0003 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 3 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0103 | H5 | CHK | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — CHK · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0104 | H5 | ERP_SO_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ERP_SO_NO · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0105 | H5 | ETA | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ETA · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0106 | H5 | ETD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ETD · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0107 | H5 | LT_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — LT_DAY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0108 | H5 | NEW_ETA | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NEW_ETA · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0109 | H5 | NEW_ETD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NEW_ETD · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0110 | H5 | NEW_LT_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NEW_LT_DAY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0111 | H5 | NEW_SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NEW_SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0112 | H5 | NEW_SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NEW_SHIPMENT_DATE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0113 | H5 | NEW_TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NEW_TRANSPORT_MODE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0114 | H5 | SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0115 | H5 | SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SHIPMENT_DATE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0116 | H5 | TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — TRANSPORT_MODE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0117 | H5 | txtApprovalDeptName / Approval Dept Name | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — txtApprovalDeptName / Approval Dept Name · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective) |  | 4 (txtApprovalDeptName(FpSpread=siSub 54열, ) |
| WK-SSP0003-0118 | I1 | SSP0003 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SSP0003 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 31 (G4 G5 G6 G7~G11 G13 G15 G16 G17 ACT:SSP0) |
| WK-SSP0003-0119 | SC1 | SSP0003 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SSP0003 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 1 (usrConditionPanel1(조회조건 7종)) |
| WK-SSP0003-0120 | D1 | CHK | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CHK · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0121 | D1 | CONFIRM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CONFIRM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0122 | D1 | ERP_SO_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — ERP_SO_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0123 | D1 | NEW_SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — NEW_SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0124 | D1 | SHIPMENT_STATUS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — SHIPMENT_STATUS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0125 | D3 | APPROVAL_USER | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — APPROVAL_USER · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (btnApproval/btnReject/btnSelfReject(우상단 ) |
| WK-SSP0003-0126 | D3 | CHK | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CHK · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0127 | D3 | CONFIRM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CONFIRM_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0128 | D3 | DELEGATEE_USER | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DELEGATEE_USER · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (btnApproval/btnReject/btnSelfReject(우상단 ) |
| WK-SSP0003-0129 | D3 | ERP_SO_NO | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ERP_SO_NO · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0130 | D3 | NEW_SHIPMENT_CONFIRM_QTY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — NEW_SHIPMENT_CONFIRM_QTY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0131 | D3 | SHIPMENT_STATUS | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — SHIPMENT_STATUS · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0132 | D5 | CHK | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — CHK · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0133 | D5 | ERP_SO_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ERP_SO_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0134 | D5 | ETA | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ETA · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0135 | D5 | ETD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ETD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0136 | D5 | LT_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — LT_DAY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0137 | D5 | NEW_ETA | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NEW_ETA · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0138 | D5 | NEW_ETD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NEW_ETD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0139 | D5 | NEW_LT_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NEW_LT_DAY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0140 | D5 | NEW_SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NEW_SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0141 | D5 | NEW_SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NEW_SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0142 | D5 | NEW_TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NEW_TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0143 | D5 | SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0144 | D5 | SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0145 | D5 | TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0146 | E4 | APPROVAL_USER | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — APPROVAL_USER · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0147 | E4 | CHANGE_REQ_NO | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — CHANGE_REQ_NO · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0148 | E4 | MSG00109 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00109 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0149 | E4 | MSG00181 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00181 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 6 (G4 G7~G11 G16 ACT:SSP0003_ShipmentChange) |
| WK-SSP0003-0150 | E4 | MSG00190 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00190 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (G17 ACT:SSP0003_ShipmentChangeRequestCon) |
| WK-SSP0003-0151 | E4 | MSG00191 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00191 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0152 | E4 | MSG00192 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00192 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (G6 ACT:SSP0003_ShipmentChangeRequestConf) |
| WK-SSP0003-0153 | E4 | MSG00197 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00197 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0154 | E4 | MSG00204 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00204 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0155 | E4 | MSG00267 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00267 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0156 | E4 | MSG00284 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00284 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0157 | E4 | MSG00291 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00291 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (G13 ACT:SSP0003_ShipmentChangeRequestCon) |
| WK-SSP0003-0158 | E4 | MSG00306 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00306 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0159 | E4 | MSG00413 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00413 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (G15 ACT:SSP0003_ShipmentChangeRequestCon) |
| WK-SSP0003-0160 | E4 | MSG00420 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00420 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (G16 ACT:SSP0003_ShipmentChangeRequestCon) |
| WK-SSP0003-0161 | E4 | MSG00421 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00421 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (G7~G11 ACT:SSP0003_ShipmentChangeRequest) |
| WK-SSP0003-0162 | E4 | MSG00422 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00422 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (G5 ACT:SSP0003_ShipmentChangeRequestConf) |
| WK-SSP0003-0163 | E4 | MSG01203 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01203 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (G17) |
| WK-SSP0003-0164 | E4 | MSG01204 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01204 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (G7~G11) |
| WK-SSP0003-0165 | E4 | MSG01205 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01205 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (G6) |
| WK-SSP0003-0166 | E4 | REQUEST_USER | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — REQUEST_USER · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0167 | E4 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0168 | E4 | clbFromSite / From Site | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbFromSite / From Site · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행  |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0169 | E4 | drpPeriod / Request Date / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — drpPeriod / Request Date / Period · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 |  | 4 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0170 | E4 | txtAppDeptName / Dept Name / App Dept Na | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtAppDeptName / Dept Name / App Dept Name · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) →  |  | 4 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0171 | E4 | txtApproval / Approval | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtApproval / Approval · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 4 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0172 | E4 | txtChangeReason / Change Reason | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtChangeReason / Change Reason · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판 |  | 4 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0173 | E4 | txtReasonDetail / Reason Detail | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtReasonDetail / Reason Detail · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판 |  | 4 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0174 | E4 | txtRejectReason / Reject Reason | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtRejectReason / Reject Reason · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판 |  | 3 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0175 | E4 | txtRequestDeptName / Dept Name / Request | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtRequestDeptName / Dept Name / Request Dept Name · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요 |  | 4 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0176 | E4 | txtRequestNo / Request No | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtRequestNo / Request No · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실 |  | 4 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0177 | E4 | txtRequestor / Requestor | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtRequestor / Requestor · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 |  | 4 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0178 | E4 | txtTitle / Title | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtTitle / Title · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0179 | A10 | SSP0003 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SSP0003 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 105 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0180 | A6 | SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONF | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조 |  | 43 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0181 | A6 | SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRA | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 |  | 41 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0182 | G1 | cboChangeType / Change Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboChangeType / Change Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0183 | G1 | cboStatus / Status | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboStatus / Status · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0184 | G1 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0185 | G1 | clbFromSite / From Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbFromSite / From Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0186 | G1 | drpPeriod / Request Date / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — drpPeriod / Request Date / Period · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0187 | G1 | txtItemID / sItemId / Item ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemID / sItemId / Item ID · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0188 | G1 | txtRequest / strRequest.Substring(0, str | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtRequest / strRequest.Substring(0, strRequest.Le · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0189 | G6 | cboChangeType / Change Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboChangeType / Change Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0190 | G6 | cboStatus / Status | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboStatus / Status · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0191 | G6 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0192 | G6 | drpPeriod / Request Date / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — drpPeriod / Request Date / Period · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0193 | X-REOPEN | SSP0003 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SSP0003 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 22 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0194 | M4 | APPROVAL_USER | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — APPROVAL_USER · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0195 | M4 | CHANGE_TYPE | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — CHANGE_TYPE · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0196 | M4 | DELEGATEE_USER | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DELEGATEE_USER · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0197 | M4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0198 | M4 | REQUEST_USER | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — REQUEST_USER · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0199 | M4 | SHIPMENT_STATUS | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SHIPMENT_STATUS · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |

## W7 기대값 확정 (105)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0003-0200 | C3 | SSP0003_ShipmentChangeRequestConfirm.Clb | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.ClbDivision_S: 진입점 집계 — C3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0201 | C3 | SSP0003_ShipmentChangeRequestConfirm.Set | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.SetChangeCont: 진입점 집계 — C3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0202 | C3 | SSP0003_ShipmentChangeRequestConfirm.Set | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.SetChangeRequ: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0203 | C3 | SSP0003_ShipmentChangeRequestConfirm.Set | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.SetChangedCon: 진입점 집계 — C3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 13 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0204 | C3 | SSP0003_ShipmentChangeRequestConfirm.Set | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.SetChangedPer: 진입점 집계 — C3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0205 | B3 | SSP0003_ShipmentChangeRequestConfirm.Get | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.GetDayRange: 진입점 집계 — B3 4요소: TODO:4 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0206 | B3 | SSP0003_ShipmentChangeRequestConfirm.Get | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.GetErpIFCheck: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 28 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0207 | B3 | SSP0003_ShipmentChangeRequestConfirm.Get | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.GetErpIFCheck: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 78 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0208 | B3 | SSP0003_ShipmentChangeRequestConfirm.Get | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.GetShipmentSt: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0209 | B4 | SSP0003_ShipmentChangeRequestConfirm.Get | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.GetDayRange: 진입점 집계 — B4 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0210 | B4 | SSP0003_ShipmentChangeRequestConfirm.Get | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.GetErpIFCheck: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 28 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0211 | B4 | SSP0003_ShipmentChangeRequestConfirm.Get | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.GetErpIFCheck: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 78 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0212 | B4 | SSP0003_ShipmentChangeRequestConfirm.Get | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.GetShipmentSt: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0213 | A5 | SSP0003_ShipmentChangeRequestConfirm.Cre | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.CreateSpread: 진입점 집계 — A5 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0214 | A5 | spdMain(siMain 22열) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — spdMain(siMain 22열): 행 집계 — A5 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (spdMain(siMain 22열)) |
| WK-SSP0003-0215 | A5 | txtApprovalDeptName(FpSpread=siSub 54열,  | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — txtApprovalDeptName(FpSpread=siSub 54열, 오명명): 행 집계 — A5 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (txtApprovalDeptName(FpSpread=siSub 54열, ) |
| WK-SSP0003-0216 | G4 | usrConditionPanel1(조회조건 7종) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — usrConditionPanel1(조회조건 7종): 행 집계 — G4 9요소: NOPATH:5 · NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (usrConditionPanel1(조회조건 7종)) |
| WK-SSP0003-0217 | H2 | SSP0003_ShipmentChangeRequestConfirm.Cre | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.CreateSpread: 진입점 집계 — H2 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0218 | H2 | spdMain(siMain 22열) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — spdMain(siMain 22열): 행 집계 — H2 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (spdMain(siMain 22열)) |
| WK-SSP0003-0219 | H2 | txtApprovalDeptName(FpSpread=siSub 54열,  | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — txtApprovalDeptName(FpSpread=siSub 54열, 오명명): 행 집계 — H2 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (txtApprovalDeptName(FpSpread=siSub 54열, ) |
| WK-SSP0003-0220 | H5 | SSP0003_ShipmentChangeRequestConfirm.Cre | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.CreateSpread: 진입점 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0221 | H5 | spdMain(siMain 22열) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — spdMain(siMain 22열): 행 집계 — H5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (spdMain(siMain 22열)) |
| WK-SSP0003-0222 | D1 | G1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — G1: 행 집계 — D1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (G1) |
| WK-SSP0003-0223 | D1 | G2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — G2: 행 집계 — D1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (G2) |
| WK-SSP0003-0224 | D1 | SSP0003_ShipmentChangeRequestConfirm.Edi | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.EditButton: 진입점 집계 — D1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0225 | D3 | G1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — G1: 행 집계 — D3 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (G1) |
| WK-SSP0003-0226 | D3 | G2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — G2: 행 집계 — D3 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (G2) |
| WK-SSP0003-0227 | D3 | SSP0003_ShipmentChangeRequestConfirm.Edi | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.EditButton: 진입점 집계 — D3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0228 | D5 | SSP0003_ShipmentChangeRequestConfirm.Cre | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.CreateSpread: 진입점 집계 — D5 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0229 | E4 | SSP0003_ShipmentChangeRequestConfirm.Set | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.SetChangeCont: 진입점 집계 — E4 33요소: NOT_RUN:33 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0230 | E4 | SSP0003_ShipmentChangeRequestConfirm.Set | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.SetChangeRequ: 진입점 집계 — E4 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0231 | E4 | SSP0003_ShipmentChangeRequestConfirm.Set | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.SetChangedCon: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 13 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0232 | E4 | SSP0003_ShipmentChangeRequestConfirm.Set | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.SetChangedPer: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0233 | A1 | G2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — G2: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (G2) |
| WK-SSP0003-0234 | A1 | SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONF | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM: 골든 비교 케이스 없음(SSP0003_GET_SHIPMENT_CHANGE_REQUEST_CONFIRM — 팝업·보조 SP 는 gol |  | 43 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0235 | A1 | SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRA | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING: 골든 비교 케이스 없음(SSP0003_GET_SHIPMENT_REQUEST_CONFIRM_DRAFTING — 팝업·보조 SP 는 |  | 41 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0236 | A1 | btnApproval/btnReject/btnSelfReject(우상단  | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — btnApproval/btnReject/btnSelfReject(우상단 area1, 초기 : 행 집계 — A1 2요소: REVIEW:2 |  | 1 (btnApproval/btnReject/btnSelfReject(우상단 ) |
| WK-SSP0003-0237 | A1 | usrConditionPanel1(조회조건 7종) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — usrConditionPanel1(조회조건 7종): 행 집계 — A1 2요소: REVIEW:2 |  | 1 (usrConditionPanel1(조회조건 7종)) |
| WK-SSP0003-0238 | G1 | G2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — G2: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (G2) |
| WK-SSP0003-0239 | G1 | btnApproval/btnReject/btnSelfReject(우상단  | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — btnApproval/btnReject/btnSelfReject(우상단 area1, 초기 : 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (btnApproval/btnReject/btnSelfReject(우상단 ) |
| WK-SSP0003-0240 | G1 | usrConditionPanel1(조회조건 7종) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — usrConditionPanel1(조회조건 7종): 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (usrConditionPanel1(조회조건 7종)) |
| WK-SSP0003-0241 | G6 | usrConditionPanel1(조회조건 7종) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — usrConditionPanel1(조회조건 7종): 행 집계 — G6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (usrConditionPanel1(조회조건 7종)) |
| WK-SSP0003-0242 | X-LOC | Division | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Division: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Division) |
| WK-SSP0003-0243 | X-LOC | From Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — From Site: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (From Site) |
| WK-SSP0003-0244 | X-LOC | G1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G1) |
| WK-SSP0003-0245 | X-LOC | G12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G12: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G12) |
| WK-SSP0003-0246 | X-LOC | G13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G13: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G13) |
| WK-SSP0003-0247 | X-LOC | G14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G14: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G14) |
| WK-SSP0003-0248 | X-LOC | G15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G15: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G15) |
| WK-SSP0003-0249 | X-LOC | G16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G16: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G16) |
| WK-SSP0003-0250 | X-LOC | G17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G17: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G17) |
| WK-SSP0003-0251 | X-LOC | G2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G2) |
| WK-SSP0003-0252 | X-LOC | G2(E) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G2(E): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G2(E)) |
| WK-SSP0003-0253 | X-LOC | G3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G3) |
| WK-SSP0003-0254 | X-LOC | G3(E) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G3(E): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G3(E)) |
| WK-SSP0003-0255 | X-LOC | G4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G4) |
| WK-SSP0003-0256 | X-LOC | G5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G5) |
| WK-SSP0003-0257 | X-LOC | G6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G6: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G6) |
| WK-SSP0003-0258 | X-LOC | G7~G11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G7~G11: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G7~G11) |
| WK-SSP0003-0259 | X-LOC | PKG | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — PKG: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (PKG) |
| WK-SSP0003-0260 | X-LOC | ROUTE_PATH | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ROUTE_PATH: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (ROUTE_PATH) |
| WK-SSP0003-0261 | X-LOC | siSub 컬럼 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — siSub 컬럼: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (siSub 컬럼) |
| WK-SSP0003-0262 | X-ROW | Division | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — Division: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (Division) |
| WK-SSP0003-0263 | X-ROW | From Site | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — From Site: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (From Site) |
| WK-SSP0003-0264 | X-ROW | G12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — G12: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (G12) |
| WK-SSP0003-0265 | X-ROW | G14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — G14: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (G14) |
| WK-SSP0003-0266 | X-ROW | G2(E) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — G2(E): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (G2(E)) |
| WK-SSP0003-0267 | X-ROW | G3(E) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — G3(E): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (G3(E)) |
| WK-SSP0003-0268 | X-ROW | PKG | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — PKG: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (PKG) |
| WK-SSP0003-0269 | X-ROW | ROUTE_PATH | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — ROUTE_PATH: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (ROUTE_PATH) |
| WK-SSP0003-0270 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.Btn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.BtnRequestUse: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 9 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0271 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.Chk | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.ChkDraftingDa: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 27 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0272 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.Clb | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.ClbDivision_S: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0273 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.Cle | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.ClearRequestI: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/VALUE_CLEAR, 연결된 요소 검사 없음 |  | 9 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0274 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.Cre | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.CreateSpread: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0275 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.Del | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.Delegate_Load: 진입점 집계 3검사 — NOT_RUN:2 · PASS:1 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0276 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.Eng | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.EngProcessing: 진입점 집계 5검사 — NOT_RUN:4 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 15 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0277 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.Fin | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.FindButton: 진입점 집계 3검사 — NOT_RUN:2 · REVIEW:1 |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0278 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.Fin | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.FindData_Main: 진입점 집계 12검사 — NOT_RUN:10 · REVIEW:1 · NOPATH:1 |  | 4 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0279 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.Fin | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.FindData_Sub: 진입점 집계 8검사 — NOT_RUN:6 · REVIEW:1 · NOPATH:1 |  | 7 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0280 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.For | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0281 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.Get | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.GetDayRange: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:1 · TODO:1 · PASS:1 (미실행 검사가 남아 판 |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0282 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.Get | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.GetErpIFCheck: 진입점 집계 10검사 — NOT_RUN:5 · REVIEW:2 · NOPATH:2 · TODO:1 |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0283 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.Ini | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.InitControls: 진입점 집계 21검사 — NOT_RUN:17 · NOPATH:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0284 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.Ini | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.InitSpread: 진입점 집계 59검사 — NOT_RUN:59 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0285 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.Sav | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.SaveData: 진입점 집계 13검사 — NOT_RUN:8 · NOPATH:5 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0286 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.Sav | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.SaveDraftingD: 진입점 집계 8검사 — NOT_RUN:6 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 69 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0287 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.Set | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.SetChangeCont: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0288 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.Set | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.SetChangedCon: 진입점 집계 10검사 — NOT_RUN:8 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0289 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.Set | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.SetChangedPer: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0290 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.Set | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.SetConfirmInf: 진입점 집계 9검사 — NOT_RUN:9 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0291 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.Spd | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.SpdMain_CellD: 진입점 집계 9검사 — NOT_RUN:7 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0292 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.Spd | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.SpdMain_TopCh: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0293 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.btn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.btnItemId_Cli: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0294 | X-ROW | SSP0003_ShipmentChangeRequestConfirm.chk | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.chkERPIFBlock: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 13 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
| WK-SSP0003-0295 | X-ROW | clbDivision(다중+ALL) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — clbDivision(다중+ALL): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (clbDivision(다중+ALL)) |
| WK-SSP0003-0296 | X-ROW | clbFromSite(다중+ALL) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — clbFromSite(다중+ALL): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (clbFromSite(다중+ALL)) |
| WK-SSP0003-0297 | X-ROW | drpPeriod(D-14) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — drpPeriod(D-14): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (drpPeriod(D-14)) |
| WK-SSP0003-0298 | X-ROW | siSub 컬럼 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — siSub 컬럼: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (siSub 컬럼) |
| WK-SSP0003-0299 | X-ROW | txtItemID+btnItemId | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — txtItemID+btnItemId: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (txtItemID+btnItemId) |
| WK-SSP0003-0300 | X-ROW | txtRequest+btnRequestUser | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — txtRequest+btnRequestUser: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (txtRequest+btnRequestUser) |
| WK-SSP0003-0301 | X-ROW | 디테일 폼 8필드 + txtRejectReason | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 디테일 폼 8필드 + txtRejectReason: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (디테일 폼 8필드 + txtRejectReason) |
| WK-SSP0003-0302 | M4 | G2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — G2: 행 집계 — M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (G2) |
| WK-SSP0003-0303 | M4 | G3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — G3: 행 집계 — M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (G3) |
| WK-SSP0003-0304 | M4 | SSP0003_ShipmentChangeRequestConfirm.Spd | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SSP0003_ShipmentChangeRequestConfirm.SpdMain_CellD: 진입점 집계 — M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 11 (ACT:SSP0003_ShipmentChangeRequestConfirm) |
