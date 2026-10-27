# 작업 원장 — SSP0202 · 2026-10-26 13:00

> 검사 인스턴스 376건 중 PASS·NA 37건 외 **339건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 12 | 구현 위치 실존 |
| W4 | 검사기 구현 | 5 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 20 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 150 | 실행 → PASS |
| W7 | 기대값 확정 | 152 | 기대 확정 → PASS/FAIL |

- 담당: E2E 150 · 사람 판정 / AS-IS 원문 확인 → 재판정 146 · 하네스 25 · 대조표 18
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 6건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| E4 | EDIT |  |  |  |  |  | 34 | 5 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| X-ROW | GEN |  |  |  |  |  |  | 36 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| X-LOC | GEN |  | 12 |  |  |  |  | 23 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| A5 | DESIGN |  |  |  |  |  | 15 | 8 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H2 | DESIGN |  |  |  |  |  | 15 | 8 |  |  | 배경·글자색 규칙 |
| G1 | GEN |  |  |  |  |  | 7 | 15 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| H5 | DESIGN |  |  |  |  |  | 16 | 5 |  |  | 라벨 명칭 |
| A1 | GEN |  |  |  |  |  |  | 17 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| D5 | EDIT |  |  |  |  |  | 15 | 1 |  |  | 셀 에디터 유형 |
| G4 | DESIGN |  |  |  |  | 5 | 4 | 2 |  |  | 조회조건 표시·라벨·활성 |
| F4 | DB |  |  |  |  |  | 10 | 1 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| C3 | CASCADE |  |  |  |  |  | 4 | 5 |  |  | 연쇄 자동 채움 |
| M4 | POPUP |  |  |  |  |  | 6 | 3 |  |  | 팝업 선택값 반영 |
| B3 | COMBO |  |  |  | 5 |  |  | 2 |  |  | 콤보 후보 정렬 = AS-IS |
| B4 | COMBO |  |  |  |  | 5 |  | 2 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| D3 | EDIT |  |  |  |  |  | 1 | 6 |  |  | 행 값 기반 조건부 잠금 |
| G6 | GEN |  |  |  |  |  | 4 | 2 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| X-REASON | DESIGN |  |  |  |  |  |  | 6 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| D1 | EDIT |  |  |  |  |  | 1 | 4 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| C1 | CASCADE |  |  |  |  |  | 4 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| A6 | GEN |  |  |  |  |  | 3 |  |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| B1 | COMBO |  |  |  |  | 2 |  |  |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 2 |  |  |  |  | 콤보 후보 중복 없음 |
| DB-SYN | DB |  |  |  |  | 1 |  | 1 |  |  | BE 계정 시노님·권한·대상 객체 |
| E5 | EDIT |  |  |  |  | 2 |  |  |  |  | 콤보 셀 후보 외 값 차단 |
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
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W2 구현 위치 확인 (12)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0202-0001 | X-LOC | btnApproval/btnReject/btnSelfReject(초기 숨 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (btnApproval/btnReject/btnSelfReject(초기 숨) |
| WK-SSP0202-0002 | X-LOC | cboChangeType(기본 ALL) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cboChangeType(기본 ALL)) |
| WK-SSP0202-0003 | X-LOC | cboStatus(기본 Q) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cboStatus(기본 Q)) |
| WK-SSP0202-0004 | X-LOC | clbDivision('40' 고정·disable) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (clbDivision('40' 고정·disable)) |
| WK-SSP0202-0005 | X-LOC | clbFromSite(다중+ALL) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (clbFromSite(다중+ALL)) |
| WK-SSP0202-0006 | X-LOC | drpPeriod(D-14) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (drpPeriod(D-14)) |
| WK-SSP0202-0007 | X-LOC | spdMain(siMain 22열) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (spdMain(siMain 22열)) |
| WK-SSP0202-0008 | X-LOC | txtApprovalDeptName(FpSpread=siSub 50열,  | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (txtApprovalDeptName(FpSpread=siSub 50열, ) |
| WK-SSP0202-0009 | X-LOC | txtItemID+btnItemId | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (txtItemID+btnItemId) |
| WK-SSP0202-0010 | X-LOC | txtRequest+btnRequestUser | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (txtRequest+btnRequestUser) |
| WK-SSP0202-0011 | X-LOC | usrConditionPanel1(조회조건 7종) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (usrConditionPanel1(조회조건 7종)) |
| WK-SSP0202-0012 | X-LOC | 디테일 폼 8필드 + txtRejectReason | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (디테일 폼 8필드 + txtRejectReason) |

## W4 검사기 구현 (5)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0202-0013 | B3 | CHANGE_TYPE | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 CHANGE_TYPE | 있음(SHEET_COLUMNS) | 1 (Q-1) |
| WK-SSP0202-0014 | B3 | SHIPMENT_STATUS | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 SHIPMENT_STATUS | 있음(SHEET_COLUMNS) | 1 (Q-1) |
| WK-SSP0202-0015 | B3 | cboChangeType / Change Type | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboChangeType / Change Type | 있음(FE 소스) | 1 (cboChangeType(기본 ALL)) |
| WK-SSP0202-0016 | B3 | cboStatus / Status | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboStatus / Status | 있음(FE 소스) | 1 (cboStatus(기본 Q)) |
| WK-SSP0202-0017 | B3 | txtRequestNo / Request No | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 txtRequestNo / Request No | 있음(FE 소스) | 2 (ACT:SSP0202_ShipmentChangeRequestConfirm) |

## W5 검사기 연결 (20)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0202-0018 | B1 | CHANGE_TYPE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL CHANGE_TYPE | 있음(SHEET_COLUMNS) | 2 (COMMON:UC-05 Q-1) |
| WK-SSP0202-0019 | B1 | SHIPMENT_STATUS | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL SHIPMENT_STATUS | 있음(SHEET_COLUMNS) | 2 (COMMON:UC-05 Q-1) |
| WK-SSP0202-0020 | B2 | CHANGE_TYPE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL CHANGE_TYPE | 있음(SHEET_COLUMNS) | 2 (COMMON:UC-05 Q-1) |
| WK-SSP0202-0021 | B2 | SHIPMENT_STATUS | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL SHIPMENT_STATUS | 있음(SHEET_COLUMNS) | 2 (COMMON:UC-05 Q-1) |
| WK-SSP0202-0022 | B4 | CHANGE_TYPE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL CHANGE_TYPE | 있음(SHEET_COLUMNS) | 2 (COMMON:UC-05 Q-1) |
| WK-SSP0202-0023 | B4 | SHIPMENT_STATUS | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL SHIPMENT_STATUS | 있음(SHEET_COLUMNS) | 2 (COMMON:UC-05 Q-1) |
| WK-SSP0202-0024 | B4 | cboChangeType / Change Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboChangeType / Change Type | 있음(FE 소스) | 1 (cboChangeType(기본 ALL)) |
| WK-SSP0202-0025 | B4 | cboStatus / Status | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboStatus / Status | 있음(FE 소스) | 1 (cboStatus(기본 Q)) |
| WK-SSP0202-0026 | B4 | txtRequestNo / Request No | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND txtRequestNo / Request No | 있음(FE 소스) | 2 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0027 | F2 | SSP0202 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SSP0202 화면 | 판단불가(대상 단위 SCREEN) | 130 (버튼메타 Q-3 ACT:SSP0202_ShipmentChangeReque) |
| WK-SSP0202-0028 | F6 | SSP0202 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SSP0202 화면 | 판단불가(대상 단위 SCREEN) | 129 (`PKG_SSP0202` ACT:SSP0202_ShipmentChange) |
| WK-SSP0202-0029 | DB-SYN | PKG_SSP0202 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP PKG_SSP0202 | 없음(PROC_M 대응 없음) | 1 (`PKG_SSP0202`) |
| WK-SSP0202-0030 | G4 | btnApproval | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnApproval | 없음 | 2 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0031 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 없음 | 2 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0032 | G4 | btnReject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnReject | 없음 | 2 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0033 | G4 | btnRequestUser | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnRequestUser | 없음 | 2 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0034 | G4 | btnSelfReject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnSelfReject | 없음 | 2 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0035 | E5 | CHANGE_TYPE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL CHANGE_TYPE | 있음(SHEET_COLUMNS) | 2 (COMMON:UC-05 Q-1) |
| WK-SSP0202-0036 | E5 | SHIPMENT_STATUS | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL SHIPMENT_STATUS | 있음(SHEET_COLUMNS) | 2 (COMMON:UC-05 Q-1) |
| WK-SSP0202-0037 | G03-WIRE | SSP0202 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SSP0202 화면 | 판단불가(대상 단위 SCREEN) | 12 (ACT:SSP0202_ShipmentChangeRequestConfirm) |

## W6 검증 실행 (150)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0202-0038 | J2 | SSP0202 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SSP0202 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 87 (usrConditionPanel1(조회조건 7종) clbDivision() |
| WK-SSP0202-0039 | C1 | cboChangeType / Change Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboChangeType / Change Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0040 | C1 | cboStatus / Status | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboStatus / Status · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0041 | C1 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0042 | C1 | clbFromSite / From Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbFromSite / From Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0043 | C3 | APPROVAL_USER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — APPROVAL_USER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0044 | C3 | CHANGE_REQ_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — CHANGE_REQ_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0045 | C3 | ERP_SO_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ERP_SO_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0046 | C3 | REQUEST_USER | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — REQUEST_USER · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0047 | G3 | SSP0202 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SSP0202 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 5 (usrConditionPanel1(조회조건 7종) COMMON:UC-04) |
| WK-SSP0202-0048 | K-SA | SSP0202 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SSP0202 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 1 (usrConditionPanel1(조회조건 7종)) |
| WK-SSP0202-0049 | K4 | SSP0202 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SSP0202 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 82 (COMMON:UC-04 COMMON:UC-05 COMMON:UC-06 C) |
| WK-SSP0202-0050 | F1 | SSP0202 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SSP0202 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 131 (`PKG_SSP0202` 버튼메타 Q-3 ACT:SSP0202_Shipm) |
| WK-SSP0202-0051 | F4 | PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: |  | 2 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0052 | F4 | PKG_SSP0202 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0202 · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (`PKG_SSP0202`) |
| WK-SSP0202-0053 | F4 | PKG_SSP0202.P_SSP0202_GET_DELEGATEE_LOAD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0202.P_SSP0202_GET_DELEGATEE_LOAD · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: |  | 4 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0054 | F4 | PKG_SSP0202.P_SSP0202_GET_SCS_CONFIRM_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0202.P_SSP0202_GET_SCS_CONFIRM_ID_CHECK · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) —  |  | 2 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0055 | F4 | PKG_SSP0202.P_SSP0202_GET_SHIPMENT_CHANG | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0202.P_SSP0202_GET_SHIPMENT_CHANGE_REQUEST_ · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 169 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0056 | F4 | PKG_SSP0202.P_SSP0202_GET_SHIPMENT_REQUE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0202.P_SSP0202_GET_SHIPMENT_REQUEST_CONFIRM · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 23 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0057 | F4 | PKG_SSP0202.P_SSP0202_GET_SSP_PLAN_PROCE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0202.P_SSP0202_GET_SSP_PLAN_PROCESSING_CHEC · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 2 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0058 | F4 | PKG_SSP0202.P_SSP0202_SAVE_SHIPMENT_REQU | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0202.P_SSP0202_SAVE_SHIPMENT_REQUEST_CONFIR · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 127 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0059 | F4 | PKG_SSP0202.P_SSP0202_SAVE_SHIPMENT_REQU | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0202.P_SSP0202_SAVE_SHIPMENT_REQUEST_CONFIR · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 127 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0060 | F4 | PKG_SSP0202.P_SSP0202_SAVE_SHIPMENT_REQU | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0202.P_SSP0202_SAVE_SHIPMENT_REQUEST_CONFIR · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 2 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0061 | A5 | CHANGE_TYPE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — CHANGE_TYPE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (COMMON:UC-05 Q-1) |
| WK-SSP0202-0062 | A5 | ERP_SO_NO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ERP_SO_NO · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 4 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0063 | A5 | ETA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ETA · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 5 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0064 | A5 | ETD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ETD · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 5 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0065 | A5 | LT_DAY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — LT_DAY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 5 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0066 | A5 | NEW_ETA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NEW_ETA · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0067 | A5 | NEW_ETD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NEW_ETD · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0068 | A5 | NEW_LT_DAY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NEW_LT_DAY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 5 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0069 | A5 | NEW_SHIPMENT_CONFIRM_QTY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NEW_SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective |  | 3 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0070 | A5 | NEW_SHIPMENT_DATE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NEW_SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0071 | A5 | NEW_TRANSPORT_MODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NEW_TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0072 | A5 | SHIPMENT_CONFIRM_QTY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Div |  | 3 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0073 | A5 | SHIPMENT_DATE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0074 | A5 | SHIPMENT_STATUS | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SHIPMENT_STATUS · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (COMMON:UC-05 Q-1) |
| WK-SSP0202-0075 | A5 | TRANSPORT_MODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0076 | G4 | cboChangeType / Change Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboChangeType / Change Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0077 | G4 | cboStatus / Status | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboStatus / Status · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0078 | G4 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0079 | G4 | drpPeriod / Request Date / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — drpPeriod / Request Date / Period · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0080 | H2 | CHANGE_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — CHANGE_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (COMMON:UC-05 Q-1) |
| WK-SSP0202-0081 | H2 | ERP_SO_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ERP_SO_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0082 | H2 | ETA | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ETA · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0083 | H2 | ETD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ETD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0084 | H2 | LT_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — LT_DAY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0085 | H2 | NEW_ETA | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NEW_ETA · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0086 | H2 | NEW_ETD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NEW_ETD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0087 | H2 | NEW_LT_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NEW_LT_DAY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0088 | H2 | NEW_SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NEW_SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0089 | H2 | NEW_SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NEW_SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0090 | H2 | NEW_TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NEW_TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0091 | H2 | SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0092 | H2 | SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0093 | H2 | SHIPMENT_STATUS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SHIPMENT_STATUS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (COMMON:UC-05 Q-1) |
| WK-SSP0202-0094 | H2 | TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0095 | H4 | SSP0202 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — SSP0202 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 4 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0096 | H5 | CHANGE_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — CHANGE_TYPE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (COMMON:UC-05 Q-1) |
| WK-SSP0202-0097 | H5 | ERP_SO_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ERP_SO_NO · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0098 | H5 | ETA | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ETA · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 5 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0099 | H5 | ETD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ETD · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 5 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0100 | H5 | LT_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — LT_DAY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 5 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0101 | H5 | NEW_ETA | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NEW_ETA · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0102 | H5 | NEW_ETD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NEW_ETD · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0103 | H5 | NEW_LT_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NEW_LT_DAY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 5 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0104 | H5 | NEW_SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NEW_SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0105 | H5 | NEW_SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NEW_SHIPMENT_DATE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0106 | H5 | NEW_TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NEW_TRANSPORT_MODE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0107 | H5 | SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0108 | H5 | SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SHIPMENT_DATE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0109 | H5 | SHIPMENT_STATUS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SHIPMENT_STATUS · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (COMMON:UC-05 Q-1) |
| WK-SSP0202-0110 | H5 | TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — TRANSPORT_MODE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0111 | H5 | txtApprovalDeptName / Approval Dept Name | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — txtApprovalDeptName / Approval Dept Name · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective) |  | 4 (txtApprovalDeptName(FpSpread=siSub 50열, ) |
| WK-SSP0202-0112 | I1 | SSP0202 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SSP0202 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 20 (4 6 7 10 11 13 14 16 ACT:SSP0202_Shipmen) |
| WK-SSP0202-0113 | SC1 | SSP0202 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SSP0202 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 2 (usrConditionPanel1(조회조건 7종) COMMON:UC-06) |
| WK-SSP0202-0114 | D1 | SHIPMENT_STATUS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — SHIPMENT_STATUS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0115 | D3 | SHIPMENT_STATUS | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — SHIPMENT_STATUS · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0116 | D5 | CHANGE_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — CHANGE_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (COMMON:UC-05 Q-1) |
| WK-SSP0202-0117 | D5 | ERP_SO_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ERP_SO_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0118 | D5 | ETA | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ETA · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 5 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0119 | D5 | ETD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ETD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 5 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0120 | D5 | LT_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — LT_DAY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 5 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0121 | D5 | NEW_ETA | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NEW_ETA · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0122 | D5 | NEW_ETD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NEW_ETD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0123 | D5 | NEW_LT_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NEW_LT_DAY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 5 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0124 | D5 | NEW_SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NEW_SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0125 | D5 | NEW_SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NEW_SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0126 | D5 | NEW_TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NEW_TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0127 | D5 | SHIPMENT_CONFIRM_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SHIPMENT_CONFIRM_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0128 | D5 | SHIPMENT_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SHIPMENT_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0129 | D5 | SHIPMENT_STATUS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SHIPMENT_STATUS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (COMMON:UC-05 Q-1) |
| WK-SSP0202-0130 | D5 | TRANSPORT_MODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — TRANSPORT_MODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0131 | D6 | SSP0202 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SSP0202 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 2 (버튼메타 Q-3) |
| WK-SSP0202-0132 | E4 | APPROVAL_USER | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — APPROVAL_USER · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0133 | E4 | CHANGE_REQ_NO | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — CHANGE_REQ_NO · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0134 | E4 | CONFIRM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — CONFIRM_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (13) |
| WK-SSP0202-0135 | E4 | MSG00003 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00003 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 0 () |
| WK-SSP0202-0136 | E4 | MSG00109 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00109 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0137 | E4 | MSG00181 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00181 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (7 11 ACT:SSP0202_ShipmentChangeRequestCo) |
| WK-SSP0202-0138 | E4 | MSG00190 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00190 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (16 ACT:SSP0202_ShipmentChangeRequestConf) |
| WK-SSP0202-0139 | E4 | MSG00191 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00191 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (10 ACT:SSP0202_ShipmentChangeRequestConf) |
| WK-SSP0202-0140 | E4 | MSG00192 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00192 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (6 ACT:SSP0202_ShipmentChangeRequestConfi) |
| WK-SSP0202-0141 | E4 | MSG00204 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00204 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0142 | E4 | MSG00267 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00267 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0143 | E4 | MSG00284 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00284 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0144 | E4 | MSG00291 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00291 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0145 | E4 | MSG00362 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00362 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0146 | E4 | MSG01203 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01203 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (16) |
| WK-SSP0202-0147 | E4 | MSG01204 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01204 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (10) |
| WK-SSP0202-0148 | E4 | MSG01205 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01205 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (6) |
| WK-SSP0202-0149 | E4 | MSG01215 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01215 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 0 () |
| WK-SSP0202-0150 | E4 | MSG01294 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01294 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (14) |
| WK-SSP0202-0151 | E4 | MSG01356 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01356 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (13) |
| WK-SSP0202-0152 | E4 | MSG01395 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01395 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 0 () |
| WK-SSP0202-0153 | E4 | REQUEST_USER | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — REQUEST_USER · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0154 | E4 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 4 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0155 | E4 | clbFromSite / From Site | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbFromSite / From Site · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행  |  | 2 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0156 | E4 | drpPeriod / Request Date / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — drpPeriod / Request Date / Period · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 |  | 4 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0157 | E4 | txtAppDeptName / Dept Name / App Dept Na | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtAppDeptName / Dept Name / App Dept Name · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) →  |  | 4 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0158 | E4 | txtApproval / Approval | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtApproval / Approval · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 4 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0159 | E4 | txtChangeReason / Change Reason | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtChangeReason / Change Reason · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판 |  | 4 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0160 | E4 | txtReasonDetail / Reason Detail | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtReasonDetail / Reason Detail · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판 |  | 4 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0161 | E4 | txtRejectReason / Reject Reason | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtRejectReason / Reject Reason · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판 |  | 2 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0162 | E4 | txtRequestDeptName / Dept Name / Request | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtRequestDeptName / Dept Name / Request Dept Name · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요 |  | 4 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0163 | E4 | txtRequestNo / Request No | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtRequestNo / Request No · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실 |  | 4 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0164 | E4 | txtRequestor / Requestor | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtRequestor / Requestor · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 |  | 4 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0165 | E4 | txtTitle / Title | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — txtTitle / Title · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0166 | A10 | SSP0202 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SSP0202 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 83 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0167 | A6 | PKG_SSP0202 | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0202 · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 1 (`PKG_SSP0202`) |
| WK-SSP0202-0168 | A6 | PKG_SSP0202.P_SSP0202_GET_SHIPMENT_CHANG | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0202.P_SSP0202_GET_SHIPMENT_CHANGE_REQUEST_ · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOUR |  | 44 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0169 | A6 | PKG_SSP0202.P_SSP0202_GET_SHIPMENT_REQUE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0202.P_SSP0202_GET_SHIPMENT_REQUEST_CONFIRM · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOUR |  | 23 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0170 | G1 | cboChangeType / Change Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboChangeType / Change Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0171 | G1 | cboStatus / Status | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboStatus / Status · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0172 | G1 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (clbDivision('40' 고정·disable) ACT:SSP0202) |
| WK-SSP0202-0173 | G1 | clbFromSite / From Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbFromSite / From Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0174 | G1 | drpPeriod / Request Date / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — drpPeriod / Request Date / Period · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0175 | G1 | txtItemID / sItemId / Item ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemID / sItemId / Item ID · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0176 | G1 | txtRequest / strRequest.Substring(0, str | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtRequest / strRequest.Substring(0, strRequest.Le · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0177 | G6 | cboChangeType / Change Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboChangeType / Change Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0178 | G6 | cboStatus / Status | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboStatus / Status · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0179 | G6 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0180 | G6 | drpPeriod / Request Date / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — drpPeriod / Request Date / Period · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0181 | X-REOPEN | SSP0202 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SSP0202 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 12 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0182 | M4 | APPROVAL_USER | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — APPROVAL_USER · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0183 | M4 | CHANGE_TYPE | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — CHANGE_TYPE · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0184 | M4 | DELEGATEE_USER | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DELEGATEE_USER · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0185 | M4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0186 | M4 | REQUEST_USER | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — REQUEST_USER · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0187 | M4 | SHIPMENT_STATUS | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SHIPMENT_STATUS · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SSP0202_ShipmentChangeRequestConfirm) |

## W7 기대값 확정 (152)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0202-0188 | C3 | SSP0202_ShipmentChangeRequestConfirm.Clb | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.ClbDivision_S: 진입점 집계 — C3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0189 | C3 | SSP0202_ShipmentChangeRequestConfirm.Set | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.SetChangeCont: 진입점 집계 — C3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0190 | C3 | SSP0202_ShipmentChangeRequestConfirm.Set | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.SetChangeRequ: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0191 | C3 | SSP0202_ShipmentChangeRequestConfirm.Set | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.SetChangedCon: 진입점 집계 — C3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0202-0192 | C3 | SSP0202_ShipmentChangeRequestConfirm.Set | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.SetChangedPer: 진입점 집계 — C3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0193 | B3 | SSP0202_ShipmentChangeRequestConfirm.Get | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.GetDayRange: 진입점 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0194 | B3 | SSP0202_ShipmentChangeRequestConfirm.Get | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.GetErpIFCheck: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 18 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0195 | B4 | SSP0202_ShipmentChangeRequestConfirm.Get | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.GetDayRange: 진입점 집계 — B4 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0196 | B4 | SSP0202_ShipmentChangeRequestConfirm.Get | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.GetErpIFCheck: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 18 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0197 | DB-SYN | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 3: 행 집계 — DB-SYN 10요소: PASS:9 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0202-0198 | F4 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 3: 행 집계 — F4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0202-0199 | A5 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 2: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (2) |
| WK-SSP0202-0200 | A5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-07: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0202-0201 | A5 | Q-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — Q-2: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (Q-2) |
| WK-SSP0202-0202 | A5 | Q-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — Q-3: 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (Q-3) |
| WK-SSP0202-0203 | A5 | SSP0202_ShipmentChangeRequestConfirm.Cre | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.CreateSpread: 진입점 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0204 | A5 | btnApproval/btnReject/btnSelfReject(초기 숨 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — btnApproval/btnReject/btnSelfReject(초기 숨김): 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (btnApproval/btnReject/btnSelfReject(초기 숨) |
| WK-SSP0202-0205 | A5 | spdMain(siMain 22열) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — spdMain(siMain 22열): 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (spdMain(siMain 22열)) |
| WK-SSP0202-0206 | A5 | txtApprovalDeptName(FpSpread=siSub 50열,  | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — txtApprovalDeptName(FpSpread=siSub 50열, 오명명): 행 집계 — A5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (txtApprovalDeptName(FpSpread=siSub 50열, ) |
| WK-SSP0202-0207 | G4 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — COMMON:UC-06: 행 집계 — G4 9요소: NOPATH:5 · NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SSP0202-0208 | G4 | usrConditionPanel1(조회조건 7종) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — usrConditionPanel1(조회조건 7종): 행 집계 — G4 9요소: NOPATH:5 · NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (usrConditionPanel1(조회조건 7종)) |
| WK-SSP0202-0209 | H2 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 2: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (2) |
| WK-SSP0202-0210 | H2 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-07: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0202-0211 | H2 | Q-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — Q-2: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (Q-2) |
| WK-SSP0202-0212 | H2 | Q-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — Q-3: 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (Q-3) |
| WK-SSP0202-0213 | H2 | SSP0202_ShipmentChangeRequestConfirm.Cre | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.CreateSpread: 진입점 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0214 | H2 | btnApproval/btnReject/btnSelfReject(초기 숨 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — btnApproval/btnReject/btnSelfReject(초기 숨김): 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (btnApproval/btnReject/btnSelfReject(초기 숨) |
| WK-SSP0202-0215 | H2 | spdMain(siMain 22열) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — spdMain(siMain 22열): 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (spdMain(siMain 22열)) |
| WK-SSP0202-0216 | H2 | txtApprovalDeptName(FpSpread=siSub 50열,  | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — txtApprovalDeptName(FpSpread=siSub 50열, 오명명): 행 집계 — H2 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (txtApprovalDeptName(FpSpread=siSub 50열, ) |
| WK-SSP0202-0217 | H5 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 2: 행 집계 — H5 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (2) |
| WK-SSP0202-0218 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0202-0219 | H5 | Q-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — Q-3: 행 집계 — H5 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (Q-3) |
| WK-SSP0202-0220 | H5 | SSP0202_ShipmentChangeRequestConfirm.Cre | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.CreateSpread: 진입점 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0221 | H5 | spdMain(siMain 22열) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — spdMain(siMain 22열): 행 집계 — H5 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (spdMain(siMain 22열)) |
| WK-SSP0202-0222 | X-REASON | **CHK 컬럼 + 행단위 승인/반려 상태기계** | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — **CHK 컬럼 + 행단위 승인/반려 상태기계** 있음(siSub CHK, `checkedIds`·`isChkEditable`·`decideChangeStatus`·DE_CONFIRM 이중 SP) * |  | 1 (**CHK 컬럼 + 행단위 승인/반려 상태기계**) |
| WK-SSP0202-0223 | X-REASON | **Status 기본값 `D`(Drafting)** | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — **Status 기본값 `D`(Drafting)** Q→D 로 교정(AS-IS SelectedIndex=2 가 CODE 정렬상 Drafting) `cboStatus.SelectedIndex = 2`( |  | 1 (**Status 기본값 `D`(Drafting)**) |
| WK-SSP0202-0224 | X-REASON | **조회조건 콤보 `'ALL'` 전송** | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — **조회조건 콤보 `'ALL'` 전송** 8c440da7 에서 division/from/status/changeType 을 `'ALL'` 로 교정 — **미이식(이식하면 결함)**. `PKG_SSP0 |  | 1 (**조회조건 콤보 `'ALL'` 전송**) |
| WK-SSP0202-0225 | X-REASON | COMMON:UC-01 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-01 필터링 상태 신규행 Insert 시 필터 유지한 채 추가 행 노출(keepRowVisibleUnderFilter) - 두 그리드 전열 읽기전용(isReadOnly). Inser |  | 1 (COMMON:UC-01) |
| WK-SSP0202-0226 | X-REASON | COMMON:UC-02 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-02 데이터 수정 중 다른 데이터 조회 시 'MSG00703' confirm - 편집 컬럼 0(전열 INPUT_TP_CD='S'). 그리드 인라인 편집 없음 — 미저장 수정 상태 부 |  | 1 (COMMON:UC-02) |
| WK-SSP0202-0227 | X-REASON | COMMON:UC-03 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-03 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 데이터 Reset 후 재조회 - Column/Measure 설정 버튼 없음(Measure 0, GridColum |  | 1 (COMMON:UC-03) |
| WK-SSP0202-0228 | D1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 1: 행 집계 — D1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-SSP0202-0229 | D1 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 2: 행 집계 — D1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (2) |
| WK-SSP0202-0230 | D1 | SSP0202_ShipmentChangeRequestConfirm.Edi | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.EditButton: 진입점 집계 — D1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0231 | D1 | 버튼메타 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 버튼메타: 행 집계 — D1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (버튼메타) |
| WK-SSP0202-0232 | D3 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 1: 행 집계 — D3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-SSP0202-0233 | D3 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 2: 행 집계 — D3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (2) |
| WK-SSP0202-0234 | D3 | Q-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — Q-2: 행 집계 — D3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (Q-2) |
| WK-SSP0202-0235 | D3 | SSP0202_ShipmentChangeRequestConfirm.Edi | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.EditButton: 진입점 집계 — D3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0236 | D3 | btnApproval/btnReject/btnSelfReject(초기 숨 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — btnApproval/btnReject/btnSelfReject(초기 숨김): 행 집계 — D3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (btnApproval/btnReject/btnSelfReject(초기 숨) |
| WK-SSP0202-0237 | D3 | 버튼메타 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 버튼메타: 행 집계 — D3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (버튼메타) |
| WK-SSP0202-0238 | D5 | SSP0202_ShipmentChangeRequestConfirm.Cre | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.CreateSpread: 진입점 집계 — D5 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0239 | E4 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 4: 행 집계 — E4 34요소: NOT_RUN:34 (미실행 요소가 남아 판정필요) |  | 1 (4) |
| WK-SSP0202-0240 | E4 | SSP0202_ShipmentChangeRequestConfirm.Set | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.SetChangeCont: 진입점 집계 — E4 34요소: NOT_RUN:34 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0241 | E4 | SSP0202_ShipmentChangeRequestConfirm.Set | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.SetChangeRequ: 진입점 집계 — E4 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0242 | E4 | SSP0202_ShipmentChangeRequestConfirm.Set | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.SetChangedCon: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0202-0243 | E4 | SSP0202_ShipmentChangeRequestConfirm.Set | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.SetChangedPer: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0244 | A1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1: 행 집계 — A1 4요소: REVIEW:4 |  | 0 () |
| WK-SSP0202-0245 | A1 | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 12: 행 집계 — A1 4요소: REVIEW:4 |  | 0 () |
| WK-SSP0202-0246 | A1 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 2: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (2) |
| WK-SSP0202-0247 | A1 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 3: 행 집계 — A1 4요소: REVIEW:4 |  | 0 () |
| WK-SSP0202-0248 | A1 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 4: 행 집계 — A1 4요소: REVIEW:4 |  | 0 () |
| WK-SSP0202-0249 | A1 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 5: 행 집계 — A1 4요소: REVIEW:4 |  | 0 () |
| WK-SSP0202-0250 | A1 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 7: 행 집계 — A1 4요소: REVIEW:4 |  | 0 () |
| WK-SSP0202-0251 | A1 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 9: 행 집계 — A1 4요소: REVIEW:4 |  | 0 () |
| WK-SSP0202-0252 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (COMMON:UC-06) |
| WK-SSP0202-0253 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (COMMON:UC-07) |
| WK-SSP0202-0254 | A1 | PKG_SSP0202 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0202: 골든 비교 케이스 없음(PKG_SSP0202 — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (`PKG_SSP0202`) |
| WK-SSP0202-0255 | A1 | PKG_SSP0202.P_SSP0202_GET_SHIPMENT_CHANG | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0202.P_SSP0202_GET_SHIPMENT_CHANGE_REQUEST_: 골든 비교 케이스 없음(PKG_SSP0202.P_SSP0202_GET_SHIPMENT_CHANGE_REQUEST_CON |  | 44 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0256 | A1 | PKG_SSP0202.P_SSP0202_GET_SHIPMENT_REQUE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0202.P_SSP0202_GET_SHIPMENT_REQUEST_CONFIRM: 골든 비교 케이스 없음(PKG_SSP0202.P_SSP0202_GET_SHIPMENT_REQUEST_CONFIRM_DR |  | 23 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0257 | A1 | PLAN_CHECK | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PLAN_CHECK: 골든 비교 케이스 없음(PLAN_CHECK — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (버튼메타) |
| WK-SSP0202-0258 | A1 | Q-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Q-1: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (Q-1) |
| WK-SSP0202-0259 | A1 | clbDivision('40' 고정·disable) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbDivision('40' 고정·disable): 행 집계 — A1 4요소: REVIEW:4 |  | 1 (clbDivision('40' 고정·disable)) |
| WK-SSP0202-0260 | A1 | usrConditionPanel1(조회조건 7종) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — usrConditionPanel1(조회조건 7종): 행 집계 — A1 4요소: REVIEW:4 |  | 1 (usrConditionPanel1(조회조건 7종)) |
| WK-SSP0202-0261 | G1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 1: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0202-0262 | G1 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 11: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0202-0263 | G1 | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 12: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0202-0264 | G1 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 2: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (2) |
| WK-SSP0202-0265 | G1 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 3: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0202-0266 | G1 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 4: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0202-0267 | G1 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 5: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0202-0268 | G1 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 6: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0202-0269 | G1 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 7: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0202-0270 | G1 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 9: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SSP0202-0271 | G1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-06: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SSP0202-0272 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0202-0273 | G1 | Q-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Q-1: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (Q-1) |
| WK-SSP0202-0274 | G1 | usrConditionPanel1(조회조건 7종) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — usrConditionPanel1(조회조건 7종): 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (usrConditionPanel1(조회조건 7종)) |
| WK-SSP0202-0275 | G1 | 버튼메타 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 버튼메타: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (버튼메타) |
| WK-SSP0202-0276 | G6 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — COMMON:UC-06: 행 집계 — G6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SSP0202-0277 | G6 | usrConditionPanel1(조회조건 7종) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — usrConditionPanel1(조회조건 7종): 행 집계 — G6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (usrConditionPanel1(조회조건 7종)) |
| WK-SSP0202-0278 | X-LOC | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (1) |
| WK-SSP0202-0279 | X-LOC | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 10: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (10) |
| WK-SSP0202-0280 | X-LOC | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 11: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (11) |
| WK-SSP0202-0281 | X-LOC | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 12: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (12) |
| WK-SSP0202-0282 | X-LOC | 13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 13: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (13) |
| WK-SSP0202-0283 | X-LOC | 14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 14: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (14) |
| WK-SSP0202-0284 | X-LOC | 15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 15: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (15) |
| WK-SSP0202-0285 | X-LOC | 16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 16: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (16) |
| WK-SSP0202-0286 | X-LOC | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (2) |
| WK-SSP0202-0287 | X-LOC | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (3) |
| WK-SSP0202-0288 | X-LOC | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (4) |
| WK-SSP0202-0289 | X-LOC | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (5) |
| WK-SSP0202-0290 | X-LOC | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 6: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (6) |
| WK-SSP0202-0291 | X-LOC | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 7: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (7) |
| WK-SSP0202-0292 | X-LOC | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 8: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (8) |
| WK-SSP0202-0293 | X-LOC | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 9: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (9) |
| WK-SSP0202-0294 | X-LOC | Q-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Q-1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Q-1) |
| WK-SSP0202-0295 | X-LOC | Q-2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Q-2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Q-2) |
| WK-SSP0202-0296 | X-LOC | Q-3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Q-3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Q-3) |
| WK-SSP0202-0297 | X-LOC | `PKG_SSP0202` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `PKG_SSP0202`: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`PKG_SSP0202`) |
| WK-SSP0202-0298 | X-LOC | main `Shipment Change Request Confirm` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — main `Shipment Change Request Confirm`: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (main `Shipment Change Request Confirm`) |
| WK-SSP0202-0299 | X-LOC | sub `…Confirm Detail` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — sub `…Confirm Detail`: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (sub `…Confirm Detail`) |
| WK-SSP0202-0300 | X-LOC | 버튼메타 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 버튼메타: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (버튼메타) |
| WK-SSP0202-0301 | X-ROW | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 12: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (12) |
| WK-SSP0202-0302 | X-ROW | 15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 15: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (15) |
| WK-SSP0202-0303 | X-ROW | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 5: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (5) |
| WK-SSP0202-0304 | X-ROW | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 8: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (8) |
| WK-SSP0202-0305 | X-ROW | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 9: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (9) |
| WK-SSP0202-0306 | X-ROW | SSP0202_ShipmentChangeRequestConfirm.Btn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.BtnRequestUse: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 9 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0307 | X-ROW | SSP0202_ShipmentChangeRequestConfirm.Clb | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.ClbDivision_S: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0308 | X-ROW | SSP0202_ShipmentChangeRequestConfirm.Cle | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.ClearRequestI: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/VALUE_CLEAR, 연결된 요소 검사 없음 |  | 9 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0309 | X-ROW | SSP0202_ShipmentChangeRequestConfirm.Cre | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.CreateSpread: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0310 | X-ROW | SSP0202_ShipmentChangeRequestConfirm.Del | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.Delegate_Load: 진입점 집계 3검사 — NOT_RUN:2 · PASS:1 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0311 | X-ROW | SSP0202_ShipmentChangeRequestConfirm.Edi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.EditButton: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0312 | X-ROW | SSP0202_ShipmentChangeRequestConfirm.Eng | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.EngProcessing: 진입점 집계 5검사 — NOT_RUN:4 · PASS:1 (미실행 검사가 남아 판정필요) |  | 15 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0313 | X-ROW | SSP0202_ShipmentChangeRequestConfirm.Fin | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.FindButton: 진입점 집계 3검사 — NOT_RUN:2 · REVIEW:1 |  | 1 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0314 | X-ROW | SSP0202_ShipmentChangeRequestConfirm.Fin | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.FindData_Main: 진입점 집계 12검사 — NOT_RUN:10 · REVIEW:1 · PASS:1 |  | 5 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0315 | X-ROW | SSP0202_ShipmentChangeRequestConfirm.Fin | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.FindData_Sub: 진입점 집계 5검사 — NOT_RUN:3 · REVIEW:1 · PASS:1 |  | 3 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0316 | X-ROW | SSP0202_ShipmentChangeRequestConfirm.For | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0317 | X-ROW | SSP0202_ShipmentChangeRequestConfirm.Get | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.GetDayRange: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:1 · TODO:1 · PASS:1 (미실행 검사가 남아 판 |  | 1 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0318 | X-ROW | SSP0202_ShipmentChangeRequestConfirm.Ini | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.InitControls: 진입점 집계 12검사 — NOT_RUN:12 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0319 | X-ROW | SSP0202_ShipmentChangeRequestConfirm.Ini | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.InitSpread: 진입점 집계 54검사 — NOT_RUN:54 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0320 | X-ROW | SSP0202_ShipmentChangeRequestConfirm.Sav | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.SaveData: 진입점 집계 13검사 — NOT_RUN:8 · PASS:3 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0321 | X-ROW | SSP0202_ShipmentChangeRequestConfirm.Set | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.SetChangeCont: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0322 | X-ROW | SSP0202_ShipmentChangeRequestConfirm.Set | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.SetChangedCon: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0323 | X-ROW | SSP0202_ShipmentChangeRequestConfirm.Set | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.SetChangedPer: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0324 | X-ROW | SSP0202_ShipmentChangeRequestConfirm.Set | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.SetConfirmInf: 진입점 집계 9검사 — NOT_RUN:9 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0325 | X-ROW | SSP0202_ShipmentChangeRequestConfirm.Spd | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.SpdMain_CellD: 진입점 집계 9검사 — NOT_RUN:7 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0326 | X-ROW | SSP0202_ShipmentChangeRequestConfirm.Spd | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.SpdMain_TopCh: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0327 | X-ROW | SSP0202_ShipmentChangeRequestConfirm.btn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.btnItemId_Cli: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0328 | X-ROW | SSP0202_ShipmentChangeRequestConfirm.chk | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.chkERPIFBlock: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 13 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0329 | X-ROW | SSP0202_ShipmentChangeRequestConfirm.chk | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.chkSaveYN: 진입점 집계 3검사 — NOT_RUN:2 · PASS:1 (미실행 검사가 남아 판정필요) |  | 21 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
| WK-SSP0202-0330 | X-ROW | clbFromSite(다중+ALL) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — clbFromSite(다중+ALL): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (clbFromSite(다중+ALL)) |
| WK-SSP0202-0331 | X-ROW | drpPeriod(D-14) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — drpPeriod(D-14): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (drpPeriod(D-14)) |
| WK-SSP0202-0332 | X-ROW | main `Shipment Change Request Confirm` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — main `Shipment Change Request Confirm`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (main `Shipment Change Request Confirm`) |
| WK-SSP0202-0333 | X-ROW | sub `…Confirm Detail` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — sub `…Confirm Detail`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (sub `…Confirm Detail`) |
| WK-SSP0202-0334 | X-ROW | txtItemID+btnItemId | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — txtItemID+btnItemId: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (txtItemID+btnItemId) |
| WK-SSP0202-0335 | X-ROW | txtRequest+btnRequestUser | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — txtRequest+btnRequestUser: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (txtRequest+btnRequestUser) |
| WK-SSP0202-0336 | X-ROW | 디테일 폼 8필드 + txtRejectReason | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 디테일 폼 8필드 + txtRejectReason: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (디테일 폼 8필드 + txtRejectReason) |
| WK-SSP0202-0337 | M4 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 2: 행 집계 — M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (2) |
| WK-SSP0202-0338 | M4 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 3: 행 집계 — M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (3) |
| WK-SSP0202-0339 | M4 | SSP0202_ShipmentChangeRequestConfirm.Spd | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SSP0202_ShipmentChangeRequestConfirm.SpdMain_CellD: 진입점 집계 — M4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SSP0202_ShipmentChangeRequestConfirm) |
