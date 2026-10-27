# 작업 원장 — SSP0019 · 2026-10-26 12:56

> 검사 인스턴스 422건 중 PASS·NA 102건 외 **320건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 14 | 구현 위치 실존 |
| W4 | 검사기 구현 | 1 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 28 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 83 | 실행 → PASS |
| W7 | 기대값 확정 | 194 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 187 · E2E 83 · 하네스 29 · 대조표 21
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 3건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-LOC | GEN |  | 14 |  |  |  |  | 22 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-ROW | GEN |  |  |  |  |  |  | 27 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| G1 | GEN |  |  |  |  |  | 10 | 9 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| H2 | DESIGN |  |  |  |  |  | 4 | 13 |  |  | 배경·글자색 규칙 |
| A5 | DESIGN |  |  |  |  |  | 3 | 12 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| G5 | POPUP |  |  |  |  | 3 |  | 11 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 2 | 1 | 11 |  |  | 팝업 표준·열림 |
| H5 | DESIGN |  |  |  |  |  | 4 | 10 |  |  | 라벨 명칭 |
| E4 | EDIT |  |  |  |  |  | 9 | 5 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| M4 | POPUP |  |  |  |  |  | 3 | 11 |  |  | 팝업 선택값 반영 |
| A1 | GEN |  |  |  |  |  |  | 14 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| G4 | DESIGN |  |  |  |  | 1 | 10 | 2 |  |  | 조회조건 표시·라벨·활성 |
| G6 | GEN |  |  |  |  |  | 10 | 2 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| B4 | COMBO |  |  |  |  | 5 |  | 6 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| B1 | COMBO |  |  |  |  | 5 |  | 4 |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 5 |  | 4 |  |  | 콤보 후보 중복 없음 |
| C1 | CASCADE |  |  |  |  |  | 6 | 2 |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| C3 | CASCADE |  |  |  |  |  | 3 | 5 |  |  | 연쇄 자동 채움 |
| D5 | EDIT |  |  |  |  |  | 2 | 5 |  |  | 셀 에디터 유형 |
| X-REASON | DESIGN |  |  |  |  |  |  | 7 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| B3 | COMBO |  |  |  | 1 |  |  | 5 |  |  | 콤보 후보 정렬 = AS-IS |
| F4 | DB |  |  |  |  |  | 3 | 3 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| B6 | COMBO |  |  |  |  | 5 |  |  |  |  | ALL 옵션·다중선택 사양 |
| A6 | GEN |  |  |  |  |  | 3 | 2 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| C4 | CASCADE |  |  |  |  |  | 2 | 2 |  |  | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| H4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 레이아웃·스크롤·크기 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W2 구현 위치 확인 (14)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0019-0001 | X-LOC | D00-4e-002 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: components/modals/ItemByDivisionModal.tsx 없음 |  | 1 (D00-4e-002) |
| WK-SSP0019-0002 | X-LOC | D00-4e-003 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: components/modals/ItemByDivisionModal.tsx 없음 |  | 1 (D00-4e-003) |
| WK-SSP0019-0003 | X-LOC | Division | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Division) |
| WK-SSP0019-0004 | X-LOC | From Site 사전필터 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (From Site 사전필터) |
| WK-SSP0019-0005 | X-LOC | MODAL:ItemByDivisionModal | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: components/modals/ItemByDivisionModal.tsx 없음 |  | 1 (MODAL:ItemByDivisionModal) |
| WK-SSP0019-0006 | X-LOC | MODAL:ShowDialog | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: components/modals/ItemByDivisionModal.tsx 없음 |  | 1 (MODAL:ShowDialog) |
| WK-SSP0019-0007 | X-LOC | ProgressForm (376) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (ProgressForm (376)) |
| WK-SSP0019-0008 | X-LOC | Project | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Project) |
| WK-SSP0019-0009 | X-LOC | SCM0002_GET_ITEM_BY_DIVISION_POPUP (Mode | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SCM0002_GET_ITEM_BY_DIVISION_POPUP (Mode) |
| WK-SSP0019-0010 | X-LOC | SCM0002_ItembyDivisionPopup (Model, 221) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SCM0002_ItembyDivisionPopup (Model, 221)) |
| WK-SSP0019-0011 | X-LOC | SCM0002_ShipmentPlanRequestPopup (REQUES | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SCM0002_ShipmentPlanRequestPopup (REQUES) |
| WK-SSP0019-0012 | X-LOC | SSP0019_GET_SHIPMENT_CHANGE_HISTORY (12파 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SSP0019_GET_SHIPMENT_CHANGE_HISTORY (12파) |
| WK-SSP0019-0013 | X-LOC | `scpModuleType` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`scpModuleType`) |
| WK-SSP0019-0014 | X-LOC | 조회 SP | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (조회 SP) |

## W4 검사기 구현 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0019-0015 | B3 | clbDivision / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbDivision / Division | 있음(FE 소스) | 1 (ACT:SSP0019_ShipmentChangeHistory.SetCha) |

## W5 검사기 연결 (28)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0019-0016 | B1 | clbDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbDivision / Division | 있음(FE 소스) | 1 (D00-1-008) |
| WK-SSP0019-0017 | B1 | clbFromSite / From Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbFromSite / From Site | 있음(FE 소스) | 1 (D00-1-009) |
| WK-SSP0019-0018 | B1 | clbIncomterms / Incoterms / Incomterms | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbIncomterms / Incoterms / Incomterms | 있음(FE 소스) | 1 (D00-1-010) |
| WK-SSP0019-0019 | B1 | clbToSite / To Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbToSite / To Site | 있음(FE 소스) | 1 (D00-1-011) |
| WK-SSP0019-0020 | B1 | clbTransportMode / Transport Mode / Tran | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbTransportMode / Transport Mode / TransportMode | 있음(FE 소스) | 1 (D00-1-012) |
| WK-SSP0019-0021 | B2 | clbDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbDivision / Division | 있음(FE 소스) | 1 (D00-1-008) |
| WK-SSP0019-0022 | B2 | clbFromSite / From Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbFromSite / From Site | 있음(FE 소스) | 1 (D00-1-009) |
| WK-SSP0019-0023 | B2 | clbIncomterms / Incoterms / Incomterms | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbIncomterms / Incoterms / Incomterms | 있음(FE 소스) | 1 (D00-1-010) |
| WK-SSP0019-0024 | B2 | clbToSite / To Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbToSite / To Site | 있음(FE 소스) | 1 (D00-1-011) |
| WK-SSP0019-0025 | B2 | clbTransportMode / Transport Mode / Tran | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbTransportMode / Transport Mode / TransportMode | 있음(FE 소스) | 1 (D00-1-012) |
| WK-SSP0019-0026 | B4 | clbDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbDivision / Division | 있음(FE 소스) | 2 (D00-1-008 ACT:SSP0019_ShipmentChangeHist) |
| WK-SSP0019-0027 | B4 | clbFromSite / From Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbFromSite / From Site | 있음(FE 소스) | 1 (D00-1-009) |
| WK-SSP0019-0028 | B4 | clbIncomterms / Incoterms / Incomterms | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbIncomterms / Incoterms / Incomterms | 있음(FE 소스) | 1 (D00-1-010) |
| WK-SSP0019-0029 | B4 | clbToSite / To Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbToSite / To Site | 있음(FE 소스) | 1 (D00-1-011) |
| WK-SSP0019-0030 | B4 | clbTransportMode / Transport Mode / Tran | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbTransportMode / Transport Mode / TransportMode | 있음(FE 소스) | 1 (D00-1-012) |
| WK-SSP0019-0031 | B6 | clbDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbDivision / Division | 있음(FE 소스) | 1 (D00-1-008) |
| WK-SSP0019-0032 | B6 | clbFromSite / From Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbFromSite / From Site | 있음(FE 소스) | 1 (D00-1-009) |
| WK-SSP0019-0033 | B6 | clbIncomterms / Incoterms / Incomterms | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbIncomterms / Incoterms / Incomterms | 있음(FE 소스) | 1 (D00-1-010) |
| WK-SSP0019-0034 | B6 | clbToSite / To Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbToSite / To Site | 있음(FE 소스) | 1 (D00-1-011) |
| WK-SSP0019-0035 | B6 | clbTransportMode / Transport Mode / Tran | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbTransportMode / Transport Mode / TransportMode | 있음(FE 소스) | 1 (D00-1-012) |
| WK-SSP0019-0036 | F2 | SSP0019 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SSP0019 화면 | 판단불가(대상 단위 SCREEN) | 1 (InsertButton/DeleteButton/EditButton/Sav) |
| WK-SSP0019-0037 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 없음 | 2 (ACT:SSP0019_ShipmentChangeHistory.InitEv) |
| WK-SSP0019-0038 | G03-WIRE | SSP0019 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SSP0019 화면 | 판단불가(대상 단위 SCREEN) | 9 (ACT:SSP0019_ShipmentChangeHistory..ctor ) |
| WK-SSP0019-0039 | G5 | REQUEST_NO | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL REQUEST_NO | 있음(SHEET_COLUMNS) | 6 (D00-4e-001 MODAL:ShipmentPlanRequestModa) |
| WK-SSP0019-0040 | G5 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnItemId | 없음 | 4 (D00-1-006 D00-2-001 D00-4b-002 btnItemId) |
| WK-SSP0019-0041 | G5 | clbDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND clbDivision / Division | 있음(FE 소스) | 1 (Division) |
| WK-SSP0019-0042 | H6 | REQUEST_NO | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL REQUEST_NO | 있음(SHEET_COLUMNS) | 6 (D00-4e-001 MODAL:ShipmentPlanRequestModa) |
| WK-SSP0019-0043 | H6 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnItemId | 없음 | 4 (D00-1-006 D00-2-001 D00-4b-002 btnItemId) |

## W6 검증 실행 (83)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0019-0044 | J2 | SSP0019 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SSP0019 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 23 (D00-2-003 D00-4b-001 D00-4b-010 CRUD:D00) |
| WK-SSP0019-0045 | C1 | chkCurrent / Current / Delegatee Model | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — chkCurrent / Current / Delegatee Model · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-002 D00-4b-007) |
| WK-SSP0019-0046 | C1 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 3 (D00-2-003 D00-4b-010 ACT:SSP0019_Shipmen) |
| WK-SSP0019-0047 | C1 | clbFromSite / From Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbFromSite / From Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0019_ShipmentChangeHistory.SetCha) |
| WK-SSP0019-0048 | C1 | clbIncomterms / Incoterms / Incomterms | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbIncomterms / Incoterms / Incomterms · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0019_ShipmentChangeHistory.SetCha) |
| WK-SSP0019-0049 | C1 | clbToSite / To Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbToSite / To Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0019_ShipmentChangeHistory.SetCha) |
| WK-SSP0019-0050 | C1 | clbTransportMode / Transport Mode / Tran | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbTransportMode / Transport Mode / TransportMode · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SSP0019_ShipmentChangeHistory.SetCha) |
| WK-SSP0019-0051 | C3 | LAST_SEQ | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — LAST_SEQ · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 11 (ACT:SSP0019_ShipmentChangeHistory.SetChe) |
| WK-SSP0019-0052 | C3 | REQUEST_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — REQUEST_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SSP0019_ShipmentChangeHistory.InitSp) |
| WK-SSP0019-0053 | C3 | SEQ | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SEQ · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SSP0019_ShipmentChangeHistory.SetChe) |
| WK-SSP0019-0054 | C4 | chkCurrent / Current / Delegatee Model | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — chkCurrent / Current / Delegatee Model · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 2 (D00-2-002 D00-4b-007) |
| WK-SSP0019-0055 | C4 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 2 (D00-2-003 D00-4b-010) |
| WK-SSP0019-0056 | G3 | SSP0019 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SSP0019 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 3 (COMMON:UC-05 COMMON:UC-06 COMMON:UC-07) |
| WK-SSP0019-0057 | K4 | SSP0019 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SSP0019 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 15 (COMMON:UC-05 COMMON:UC-06 COMMON:UC-07 A) |
| WK-SSP0019-0058 | F1 | SSP0019 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SSP0019 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 1 (InsertButton/DeleteButton/EditButton/Sav) |
| WK-SSP0019-0059 | F5 | SSP0019 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SSP0019 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 1 (InsertButton/DeleteButton/EditButton/Sav) |
| WK-SSP0019-0060 | F4 | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISI | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP))  |  | 2 (SCM0002_GET_ITEM_BY_DIVISION_POPUP (Mode) |
| WK-SSP0019-0061 | F4 | PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DI | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) —  |  | 2 (SCM0002_GET_ITEM_BY_DIVISION_POPUP (Mode) |
| WK-SSP0019-0062 | F4 | PKG_SSP0019.P_SSP0019_GET_SHIPMENT_CHANG | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SSP0019.P_SSP0019_GET_SHIPMENT_CHANGE_HISTORY · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) |  | 51 (D00-4a-001 SSP0019_GET_SHIPMENT_CHANGE_H) |
| WK-SSP0019-0063 | A5 | CONFIRM_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — CONFIRM_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 4 (D00-3-001 Freeze(0, CONFIRM_ID+1) (336) ) |
| WK-SSP0019-0064 | A5 | LAST_SEQ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — LAST_SEQ · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (SetBGColor LightSkyBlue (471,487)) |
| WK-SSP0019-0065 | A5 | REQUEST_NO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — REQUEST_NO · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 5 (REQUEST_NO cellTypeImage (339) + 가드(201,) |
| WK-SSP0019-0066 | G4 | chkCurrent / Current / Delegatee Model | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkCurrent / Current / Delegatee Model · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-007 ACT:SSP0019_ShipmentChangeHist) |
| WK-SSP0019-0067 | G4 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (D00-1-008 ACT:SSP0019_ShipmentChangeHist) |
| WK-SSP0019-0068 | G4 | clbFromSite / From Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbFromSite / From Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-009) |
| WK-SSP0019-0069 | G4 | clbIncomterms / Incoterms / Incomterms | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbIncomterms / Incoterms / Incomterms · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-010) |
| WK-SSP0019-0070 | G4 | clbToSite / To Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbToSite / To Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-011) |
| WK-SSP0019-0071 | G4 | clbTransportMode / Transport Mode / Tran | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbTransportMode / Transport Mode / TransportMode · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-012) |
| WK-SSP0019-0072 | G4 | drpPeriod / Shipment Date / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — drpPeriod / Shipment Date / Period · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (D00-1-014 ACT:SSP0019_ShipmentChangeHist) |
| WK-SSP0019-0073 | G4 | txtConfirmId / Confirm ID / Confirm Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtConfirmId / Confirm ID / Confirm Id · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-029) |
| WK-SSP0019-0074 | G4 | txtItemId / Model / Item Id / Model/Nick | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-030) |
| WK-SSP0019-0075 | G4 | txtSoNo / SO No / So No | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtSoNo / SO No / So No · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-031) |
| WK-SSP0019-0076 | H2 | CONFIRM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — CONFIRM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (D00-3-001 Freeze(0, CONFIRM_ID+1) (336) ) |
| WK-SSP0019-0077 | H2 | LAST_SEQ | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — LAST_SEQ · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (D00-3-006 SetBGColor LightSkyBlue (471,4) |
| WK-SSP0019-0078 | H2 | REQUEST_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — REQUEST_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (REQUEST_NO cellTypeImage (339) + 가드(201,) |
| WK-SSP0019-0079 | H2 | SEQ | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SEQ · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (D00-3-006 D00-3-010 ACT:SSP0019_Shipment) |
| WK-SSP0019-0080 | H4 | SSP0019 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — SSP0019 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 8 (D00-2-005 D00-3-011 D00-4b-009 SpdMain_T) |
| WK-SSP0019-0081 | H5 | CONFIRM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — CONFIRM_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (D00-3-001 Freeze(0, CONFIRM_ID+1) (336) ) |
| WK-SSP0019-0082 | H5 | LAST_SEQ | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — LAST_SEQ · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (SetBGColor LightSkyBlue (471,487)) |
| WK-SSP0019-0083 | H5 | REQUEST_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — REQUEST_NO · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (REQUEST_NO cellTypeImage (339) + 가드(201,) |
| WK-SSP0019-0084 | H5 | chkCurrent / Current / Delegatee Model | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — chkCurrent / Current / Delegatee Model · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective))  |  | 1 (VisibleRow (472,476,482)) |
| WK-SSP0019-0085 | SC1 | SSP0019 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SSP0019 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 12 (D00-1-007 D00-1-008 D00-1-009 D00-1-010 ) |
| WK-SSP0019-0086 | D5 | CONFIRM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — CONFIRM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0019_ShipmentChangeHistory.InitSp) |
| WK-SSP0019-0087 | D5 | REQUEST_NO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — REQUEST_NO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SSP0019_ShipmentChangeHistory.InitSp) |
| WK-SSP0019-0088 | D6 | SSP0019 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SSP0019 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 1 (InsertButton/DeleteButton/EditButton/Sav) |
| WK-SSP0019-0089 | E4 | LAST_SEQ | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — LAST_SEQ · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 11 (ACT:SSP0019_ShipmentChangeHistory.SetChe) |
| WK-SSP0019-0090 | E4 | SEQ | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — SEQ · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SSP0019_ShipmentChangeHistory.SetChe) |
| WK-SSP0019-0091 | E4 | chkCurrent / Current / Delegatee Model | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — chkCurrent / Current / Delegatee Model · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지· |  | 12 (ACT:SSP0019_ShipmentChangeHistory.SetChe) |
| WK-SSP0019-0092 | E4 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 3 (ACT:SSP0019_ShipmentChangeHistory.SetCha) |
| WK-SSP0019-0093 | E4 | clbFromSite / From Site | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbFromSite / From Site · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행  |  | 2 (ACT:SSP0019_ShipmentChangeHistory.SetCha) |
| WK-SSP0019-0094 | E4 | clbIncomterms / Incoterms / Incomterms | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbIncomterms / Incoterms / Incomterms · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지· |  | 2 (ACT:SSP0019_ShipmentChangeHistory.SetCha) |
| WK-SSP0019-0095 | E4 | clbToSite / To Site | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbToSite / To Site · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SSP0019_ShipmentChangeHistory.SetCha) |
| WK-SSP0019-0096 | E4 | clbTransportMode / Transport Mode / Tran | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbTransportMode / Transport Mode / TransportMode · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 |  | 2 (ACT:SSP0019_ShipmentChangeHistory.SetCha) |
| WK-SSP0019-0097 | E4 | drpPeriod / Shipment Date / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — drpPeriod / Shipment Date / Period · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시 |  | 5 (ACT:SSP0019_ShipmentChangeHistory.FindDa) |
| WK-SSP0019-0098 | A10 | SSP0019 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SSP0019 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 41 (ACT:SSP0019_ShipmentChangeHistory.Define) |
| WK-SSP0019-0099 | A6 | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISI | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE |  | 2 (SCM0002_GET_ITEM_BY_DIVISION_POPUP (Mode) |
| WK-SSP0019-0100 | A6 | PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DI | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DIVISION · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새 |  | 2 (SCM0002_GET_ITEM_BY_DIVISION_POPUP (Mode) |
| WK-SSP0019-0101 | A6 | PKG_SSP0019.P_SSP0019_GET_SHIPMENT_CHANG | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SSP0019.P_SSP0019_GET_SHIPMENT_CHANGE_HISTORY · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURC |  | 51 (D00-4a-001 SSP0019_GET_SHIPMENT_CHANGE_H) |
| WK-SSP0019-0102 | G1 | chkCurrent / Current / Delegatee Model | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — chkCurrent / Current / Delegatee Model · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-007) |
| WK-SSP0019-0103 | G1 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 5 (D00-1-008 D00-2-003 D00-4b-010 ACT:SSP00) |
| WK-SSP0019-0104 | G1 | clbFromSite / From Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbFromSite / From Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-009 ACT:SSP0019_ShipmentChangeHist) |
| WK-SSP0019-0105 | G1 | clbIncomterms / Incoterms / Incomterms | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbIncomterms / Incoterms / Incomterms · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-010 ACT:SSP0019_ShipmentChangeHist) |
| WK-SSP0019-0106 | G1 | clbToSite / To Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbToSite / To Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-011 ACT:SSP0019_ShipmentChangeHist) |
| WK-SSP0019-0107 | G1 | clbTransportMode / Transport Mode / Tran | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbTransportMode / Transport Mode / TransportMode · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-012 ACT:SSP0019_ShipmentChangeHist) |
| WK-SSP0019-0108 | G1 | drpPeriod / Shipment Date / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — drpPeriod / Shipment Date / Period · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 6 (D00-1-014 ACT:SSP0019_ShipmentChangeHist) |
| WK-SSP0019-0109 | G1 | txtConfirmId / Confirm ID / Confirm Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtConfirmId / Confirm ID / Confirm Id · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-029 ACT:SSP0019_ShipmentChangeHist) |
| WK-SSP0019-0110 | G1 | txtItemId / Model / Item Id / Model/Nick | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-030 ACT:SSP0019_ShipmentChangeHist) |
| WK-SSP0019-0111 | G1 | txtSoNo / SO No / So No | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtSoNo / SO No / So No · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-031 ACT:SSP0019_ShipmentChangeHist) |
| WK-SSP0019-0112 | G6 | chkCurrent / Current / Delegatee Model | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — chkCurrent / Current / Delegatee Model · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-007 ACT:SSP0019_ShipmentChangeHist) |
| WK-SSP0019-0113 | G6 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (D00-1-008 ACT:SSP0019_ShipmentChangeHist) |
| WK-SSP0019-0114 | G6 | clbFromSite / From Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbFromSite / From Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-009) |
| WK-SSP0019-0115 | G6 | clbIncomterms / Incoterms / Incomterms | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbIncomterms / Incoterms / Incomterms · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-010) |
| WK-SSP0019-0116 | G6 | clbToSite / To Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbToSite / To Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-011) |
| WK-SSP0019-0117 | G6 | clbTransportMode / Transport Mode / Tran | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbTransportMode / Transport Mode / TransportMode · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-012) |
| WK-SSP0019-0118 | G6 | drpPeriod / Shipment Date / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — drpPeriod / Shipment Date / Period · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (D00-1-014 ACT:SSP0019_ShipmentChangeHist) |
| WK-SSP0019-0119 | G6 | txtConfirmId / Confirm ID / Confirm Id | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtConfirmId / Confirm ID / Confirm Id · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-029) |
| WK-SSP0019-0120 | G6 | txtItemId / Model / Item Id / Model/Nick | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-030) |
| WK-SSP0019-0121 | G6 | txtSoNo / SO No / So No | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtSoNo / SO No / So No · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-031) |
| WK-SSP0019-0122 | X-REOPEN | SSP0019 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SSP0019 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 6 (ACT:SSP0019_ShipmentChangeHistory.Dispos) |
| WK-SSP0019-0123 | H6 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — clbDivision / Division · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (Division) |
| WK-SSP0019-0124 | M4 | REQUEST_NO | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — REQUEST_NO · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (D00-4e-001 MODAL:ShipmentPlanRequestModa) |
| WK-SSP0019-0125 | M4 | btnItemId | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnItemId · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (D00-1-006 D00-2-001 D00-4b-002 btnItemId) |
| WK-SSP0019-0126 | M4 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (Division) |

## W7 기대값 확정 (194)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SSP0019-0127 | C1 | ChkCurrent_CheckedChanged (241) `SetChec | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — ChkCurrent_CheckedChanged (241) `SetCheckRow`: 행 집계 — C1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (ChkCurrent_CheckedChanged (241) `SetChec) |
| WK-SSP0019-0128 | C1 | clbDivision_SelectedIndexChanged (235) ` | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — clbDivision_SelectedIndexChanged (235) `SetChanged: 행 집계 — C1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (clbDivision_SelectedIndexChanged (235) `) |
| WK-SSP0019-0129 | C3 | SSP0019_ShipmentChangeHistory.ChkCurrent | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0019_ShipmentChangeHistory.ChkCurrent_CheckedCh: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0019_ShipmentChangeHistory.ChkCur) |
| WK-SSP0019-0130 | C3 | SSP0019_ShipmentChangeHistory.SetChangeC | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0019_ShipmentChangeHistory.SetChangeControl: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SSP0019_ShipmentChangeHistory.SetCha) |
| WK-SSP0019-0131 | C3 | SSP0019_ShipmentChangeHistory.SetChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0019_ShipmentChangeHistory.SetChangedControl: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0019_ShipmentChangeHistory.SetCha) |
| WK-SSP0019-0132 | C3 | SSP0019_ShipmentChangeHistory.SetChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0019_ShipmentChangeHistory.SetChangedPeriod: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0019_ShipmentChangeHistory.SetCha) |
| WK-SSP0019-0133 | C3 | SSP0019_ShipmentChangeHistory.clbDivisio | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SSP0019_ShipmentChangeHistory.clbDivision_Selected: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0019_ShipmentChangeHistory.clbDiv) |
| WK-SSP0019-0134 | C4 | ChkCurrent_CheckedChanged (241) `SetChec | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — ChkCurrent_CheckedChanged (241) `SetCheckRow`: 행 집계 — C4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ChkCurrent_CheckedChanged (241) `SetChec) |
| WK-SSP0019-0135 | C4 | clbDivision_SelectedIndexChanged (235) ` | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — clbDivision_SelectedIndexChanged (235) `SetChanged: 행 집계 — C4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (clbDivision_SelectedIndexChanged (235) `) |
| WK-SSP0019-0136 | B1 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — COMMON:UC-05: 행 집계 — B1 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SSP0019-0137 | B1 | 셀콤보 CHANGE_REASON_CODE_ALL (334) | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — 셀콤보 CHANGE_REASON_CODE_ALL (334): 행 집계 — B1 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (셀콤보 CHANGE_REASON_CODE_ALL (334)) |
| WK-SSP0019-0138 | B1 | 셀콤보 FCST_TYPE (LookupCommon SALES_TYPE_C | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — 셀콤보 FCST_TYPE (LookupCommon SALES_TYPE_CODE): 행 집계 — B1 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (셀콤보 FCST_TYPE (LookupCommon SALES_TYPE_C) |
| WK-SSP0019-0139 | B1 | 셀콤보 dataMap (334) | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — 셀콤보 dataMap (334): 행 집계 — B1 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (셀콤보 dataMap (334)) |
| WK-SSP0019-0140 | B2 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — COMMON:UC-05: 행 집계 — B2 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SSP0019-0141 | B2 | 셀콤보 CHANGE_REASON_CODE_ALL (334) | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — 셀콤보 CHANGE_REASON_CODE_ALL (334): 행 집계 — B2 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (셀콤보 CHANGE_REASON_CODE_ALL (334)) |
| WK-SSP0019-0142 | B2 | 셀콤보 FCST_TYPE (LookupCommon SALES_TYPE_C | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — 셀콤보 FCST_TYPE (LookupCommon SALES_TYPE_CODE): 행 집계 — B2 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (셀콤보 FCST_TYPE (LookupCommon SALES_TYPE_C) |
| WK-SSP0019-0143 | B2 | 셀콤보 dataMap (334) | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — 셀콤보 dataMap (334): 행 집계 — B2 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (셀콤보 dataMap (334)) |
| WK-SSP0019-0144 | B3 | SSP0019_ShipmentChangeHistory.GetDayRang | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SSP0019_ShipmentChangeHistory.GetDayRange: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SSP0019_ShipmentChangeHistory.GetDay) |
| WK-SSP0019-0145 | B3 | 셀콤보 CHANGE_REASON_CODE_ALL (334) | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — 셀콤보 CHANGE_REASON_CODE_ALL (334): 행 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 1 (셀콤보 CHANGE_REASON_CODE_ALL (334)) |
| WK-SSP0019-0146 | B3 | 셀콤보 DIVISION_ID (Division) | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — 셀콤보 DIVISION_ID (Division): 행 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 1 (셀콤보 DIVISION_ID (Division)) |
| WK-SSP0019-0147 | B3 | 셀콤보 FCST_TYPE (LookupCommon SALES_TYPE_C | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — 셀콤보 FCST_TYPE (LookupCommon SALES_TYPE_CODE): 행 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 1 (셀콤보 FCST_TYPE (LookupCommon SALES_TYPE_C) |
| WK-SSP0019-0148 | B3 | 셀콤보 dataMap (334) | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — 셀콤보 dataMap (334): 행 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 1 (셀콤보 dataMap (334)) |
| WK-SSP0019-0149 | B4 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — COMMON:UC-05: 행 집계 — B4 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SSP0019-0150 | B4 | SSP0019_ShipmentChangeHistory.GetDayRang | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SSP0019_ShipmentChangeHistory.GetDayRange: 진입점 집계 — B4 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SSP0019_ShipmentChangeHistory.GetDay) |
| WK-SSP0019-0151 | B4 | 셀콤보 CHANGE_REASON_CODE_ALL (334) | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — 셀콤보 CHANGE_REASON_CODE_ALL (334): 행 집계 — B4 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (셀콤보 CHANGE_REASON_CODE_ALL (334)) |
| WK-SSP0019-0152 | B4 | 셀콤보 DIVISION_ID (Division) | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — 셀콤보 DIVISION_ID (Division): 행 집계 — B4 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (셀콤보 DIVISION_ID (Division)) |
| WK-SSP0019-0153 | B4 | 셀콤보 FCST_TYPE (LookupCommon SALES_TYPE_C | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — 셀콤보 FCST_TYPE (LookupCommon SALES_TYPE_CODE): 행 집계 — B4 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (셀콤보 FCST_TYPE (LookupCommon SALES_TYPE_C) |
| WK-SSP0019-0154 | B4 | 셀콤보 dataMap (334) | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — 셀콤보 dataMap (334): 행 집계 — B4 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (셀콤보 dataMap (334)) |
| WK-SSP0019-0155 | F4 | D00-4a-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — D00-4a-002: 행 집계 — F4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4a-002) |
| WK-SSP0019-0156 | F4 | FindButton (347) `FindData_Main()` | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — FindButton (347) `FindData_Main()`: 행 집계 — F4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (FindButton (347) `FindData_Main()`) |
| WK-SSP0019-0157 | F4 | SSP0019_ShipmentChangeHistory.GetDayRang | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SSP0019_ShipmentChangeHistory.GetDayRange: 진입점 집계 — F4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SSP0019_ShipmentChangeHistory.GetDay) |
| WK-SSP0019-0158 | A5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-07: 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0019-0159 | A5 | D00-1-026 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-026: 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-026) |
| WK-SSP0019-0160 | A5 | D00-2-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-2-005: 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-005) |
| WK-SSP0019-0161 | A5 | D00-3-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-3-003: 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-003) |
| WK-SSP0019-0162 | A5 | D00-3-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-3-004: 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-004) |
| WK-SSP0019-0163 | A5 | D00-3-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-3-008: 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-008) |
| WK-SSP0019-0164 | A5 | LockColumn(0,max,true) (438) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — LockColumn(0,max,true) (438): 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (LockColumn(0,max,true) (438)) |
| WK-SSP0019-0165 | A5 | SSP0019_ShipmentChangeHistory.CreateSpre | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SSP0019_ShipmentChangeHistory.CreateSpread: 진입점 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0019_ShipmentChangeHistory.Create) |
| WK-SSP0019-0166 | A5 | SmartColMerge (440,536) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SmartColMerge (440,536): 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (SmartColMerge (440,536)) |
| WK-SSP0019-0167 | A5 | SpdMain_TopChange (533) SmartColMerge 재적 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SpdMain_TopChange (533) SmartColMerge 재적용: 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (SpdMain_TopChange (533) SmartColMerge 재적) |
| WK-SSP0019-0168 | A5 | VisibleRow (472,476,482) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — VisibleRow (472,476,482): 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (VisibleRow (472,476,482)) |
| WK-SSP0019-0169 | A5 | 셀콤보 dataMap (334) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 셀콤보 dataMap (334): 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (셀콤보 dataMap (334)) |
| WK-SSP0019-0170 | G4 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — COMMON:UC-06: 행 집계 — G4 11요소: NOT_RUN:10 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SSP0019-0171 | G4 | MODAL:ItemByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — MODAL:ItemByDivisionModal: 행 집계 — G4 11요소: NOT_RUN:10 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ItemByDivisionModal) |
| WK-SSP0019-0172 | H2 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-07: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0019-0173 | H2 | D00-1-026 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-1-026: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-026) |
| WK-SSP0019-0174 | H2 | D00-2-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-2-005: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-005) |
| WK-SSP0019-0175 | H2 | D00-3-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-3-003: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-003) |
| WK-SSP0019-0176 | H2 | D00-3-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-3-004: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-004) |
| WK-SSP0019-0177 | H2 | D00-3-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-3-011: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-011) |
| WK-SSP0019-0178 | H2 | D00-4b-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-4b-009: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-009) |
| WK-SSP0019-0179 | H2 | LockColumn(0,max,true) (438) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — LockColumn(0,max,true) (438): 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (LockColumn(0,max,true) (438)) |
| WK-SSP0019-0180 | H2 | SSP0019_ShipmentChangeHistory.CreateSpre | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SSP0019_ShipmentChangeHistory.CreateSpread: 진입점 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0019_ShipmentChangeHistory.Create) |
| WK-SSP0019-0181 | H2 | SmartColMerge (440,536) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SmartColMerge (440,536): 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (SmartColMerge (440,536)) |
| WK-SSP0019-0182 | H2 | SpdMain_TopChange (533) SmartColMerge 재적 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SpdMain_TopChange (533) SmartColMerge 재적용: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (SpdMain_TopChange (533) SmartColMerge 재적) |
| WK-SSP0019-0183 | H2 | VisibleRow (472,476,482) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — VisibleRow (472,476,482): 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (VisibleRow (472,476,482)) |
| WK-SSP0019-0184 | H2 | 셀콤보 dataMap (334) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 셀콤보 dataMap (334): 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (셀콤보 dataMap (334)) |
| WK-SSP0019-0185 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0019-0186 | H5 | D00-1-026 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-1-026: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-026) |
| WK-SSP0019-0187 | H5 | D00-2-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-2-005: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-005) |
| WK-SSP0019-0188 | H5 | D00-3-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-3-003: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-003) |
| WK-SSP0019-0189 | H5 | D00-3-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-3-004: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-004) |
| WK-SSP0019-0190 | H5 | LockColumn(0,max,true) (438) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — LockColumn(0,max,true) (438): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (LockColumn(0,max,true) (438)) |
| WK-SSP0019-0191 | H5 | SSP0019_ShipmentChangeHistory.CreateSpre | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SSP0019_ShipmentChangeHistory.CreateSpread: 진입점 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0019_ShipmentChangeHistory.Create) |
| WK-SSP0019-0192 | H5 | SmartColMerge (440,536) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SmartColMerge (440,536): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (SmartColMerge (440,536)) |
| WK-SSP0019-0193 | H5 | SpdMain_TopChange (533) SmartColMerge 재적 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SpdMain_TopChange (533) SmartColMerge 재적용: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (SpdMain_TopChange (533) SmartColMerge 재적) |
| WK-SSP0019-0194 | H5 | 셀콤보 dataMap (334) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 셀콤보 dataMap (334): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (셀콤보 dataMap (334)) |
| WK-SSP0019-0195 | X-REASON | COMMON:UC-02 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-02 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4) — 조회전용 inquiry |  | 1 (COMMON:UC-02) |
| WK-SSP0019-0196 | X-REASON | CRUD:D00-4b-003:DELETE | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CRUD:D00-4b-003:DELETE [DELETE] §4b DeleteButton / toolbarOverride / Delete ShipmentChangeHistory.tsx:140 조회전용  |  | 1 (CRUD:D00-4b-003:DELETE) |
| WK-SSP0019-0197 | X-REASON | CRUD:D00-4b-005:INSERT | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CRUD:D00-4b-005:INSERT [INSERT] §4b InsertButton / toolbarOverride / Insert ShipmentChangeHistory.tsx:139 조회전용  |  | 1 (CRUD:D00-4b-005:INSERT) |
| WK-SSP0019-0198 | X-REASON | CRUD:D00-4b-006:SAVE | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CRUD:D00-4b-006:SAVE [SAVE] §4b SaveButton / toolbarOverride / Save ShipmentChangeHistory.tsx:141 조회전용 inquiry  |  | 1 (CRUD:D00-4b-006:SAVE) |
| WK-SSP0019-0199 | X-REASON | D00-4b-003 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-4b-003 §4b DeleteButton / toolbarOverride / Delete ShipmentChangeHistory.tsx:140 조회전용 inquiry — AS-IS NO-OP |  | 1 (D00-4b-003) |
| WK-SSP0019-0200 | X-REASON | D00-4b-005 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-4b-005 §4b InsertButton / toolbarOverride / Insert ShipmentChangeHistory.tsx:139 조회전용 inquiry — AS-IS NO-OP |  | 1 (D00-4b-005) |
| WK-SSP0019-0201 | X-REASON | D00-4b-006 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-4b-006 §4b SaveButton / toolbarOverride / Save ShipmentChangeHistory.tsx:141 조회전용 inquiry — AS-IS NO-OP 공백, |  | 1 (D00-4b-006) |
| WK-SSP0019-0202 | D5 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — COMMON:UC-05: 행 집계 — D5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SSP0019-0203 | D5 | SSP0019_ShipmentChangeHistory.CreateSpre | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SSP0019_ShipmentChangeHistory.CreateSpread: 진입점 집계 — D5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0019_ShipmentChangeHistory.Create) |
| WK-SSP0019-0204 | D5 | 셀콤보 CHANGE_REASON_CODE_ALL (334) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — 셀콤보 CHANGE_REASON_CODE_ALL (334): 행 집계 — D5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (셀콤보 CHANGE_REASON_CODE_ALL (334)) |
| WK-SSP0019-0205 | D5 | 셀콤보 FCST_TYPE (LookupCommon SALES_TYPE_C | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — 셀콤보 FCST_TYPE (LookupCommon SALES_TYPE_CODE): 행 집계 — D5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (셀콤보 FCST_TYPE (LookupCommon SALES_TYPE_C) |
| WK-SSP0019-0206 | D5 | 셀콤보 dataMap (334) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — 셀콤보 dataMap (334): 행 집계 — D5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (셀콤보 dataMap (334)) |
| WK-SSP0019-0207 | E4 | CRUD:D00-4b-001:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — CRUD:D00-4b-001:SEARCH: 행 집계 — E4 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:D00-4b-001:SEARCH) |
| WK-SSP0019-0208 | E4 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D00-4b-001: 행 집계 — E4 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-001) |
| WK-SSP0019-0209 | E4 | SSP0019_ShipmentChangeHistory.SetChangeC | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0019_ShipmentChangeHistory.SetChangeControl: 진입점 집계 — E4 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SSP0019_ShipmentChangeHistory.SetCha) |
| WK-SSP0019-0210 | E4 | SSP0019_ShipmentChangeHistory.SetChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0019_ShipmentChangeHistory.SetChangedControl: 진입점 집계 — E4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SSP0019_ShipmentChangeHistory.SetCha) |
| WK-SSP0019-0211 | E4 | SSP0019_ShipmentChangeHistory.SetChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SSP0019_ShipmentChangeHistory.SetChangedPeriod: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SSP0019_ShipmentChangeHistory.SetCha) |
| WK-SSP0019-0212 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (COMMON:UC-06) |
| WK-SSP0019-0213 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (COMMON:UC-07) |
| WK-SSP0019-0214 | A1 | CRUD:D00-4b-001:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:D00-4b-001:SEARCH: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (CRUD:D00-4b-001:SEARCH) |
| WK-SSP0019-0215 | A1 | D00-2-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-003: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-2-003) |
| WK-SSP0019-0216 | A1 | D00-4a-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4a-002: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-4a-002) |
| WK-SSP0019-0217 | A1 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4b-001: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-4b-001) |
| WK-SSP0019-0218 | A1 | D00-4b-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4b-010: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (D00-4b-010) |
| WK-SSP0019-0219 | A1 | FindButton (347) `FindData_Main()` | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindButton (347) `FindData_Main()`: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (FindButton (347) `FindData_Main()`) |
| WK-SSP0019-0220 | A1 | InsertButton/DeleteButton/EditButton/Sav | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — InsertButton/DeleteButton/EditButton/SaveButton (3: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (InsertButton/DeleteButton/EditButton/Sav) |
| WK-SSP0019-0221 | A1 | MODAL:ItemByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — MODAL:ItemByDivisionModal: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (MODAL:ItemByDivisionModal) |
| WK-SSP0019-0222 | A1 | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP: 골든 비교 케이스 없음(PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP — 팝업·보 |  | 2 (SCM0002_GET_ITEM_BY_DIVISION_POPUP (Mode) |
| WK-SSP0019-0223 | A1 | PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DIVISION: 골든 비교 케이스 없음(PKG_SCM0002.P_SCM0002_GET_MATERIAL_BY_DIVISION — 팝업·보조 SP |  | 2 (SCM0002_GET_ITEM_BY_DIVISION_POPUP (Mode) |
| WK-SSP0019-0224 | A1 | PKG_SSP0019.P_SSP0019_GET_SHIPMENT_CHANG | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SSP0019.P_SSP0019_GET_SHIPMENT_CHANGE_HISTORY: 골든 비교 케이스 없음(PKG_SSP0019.P_SSP0019_GET_SHIPMENT_CHANGE_HISTORY — 팝업 |  | 51 (D00-4a-001 SSP0019_GET_SHIPMENT_CHANGE_H) |
| WK-SSP0019-0225 | A1 | clbDivision_SelectedIndexChanged (235) ` | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbDivision_SelectedIndexChanged (235) `SetChanged: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (clbDivision_SelectedIndexChanged (235) `) |
| WK-SSP0019-0226 | A6 | D00-4a-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — D00-4a-002: 행 집계 — A6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4a-002) |
| WK-SSP0019-0227 | A6 | FindButton (347) `FindData_Main()` | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — FindButton (347) `FindData_Main()`: 행 집계 — A6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (FindButton (347) `FindData_Main()`) |
| WK-SSP0019-0228 | G1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-06: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SSP0019-0229 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SSP0019-0230 | G1 | CRUD:D00-4b-001:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — CRUD:D00-4b-001:SEARCH: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:D00-4b-001:SEARCH) |
| WK-SSP0019-0231 | G1 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-4b-001: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-001) |
| WK-SSP0019-0232 | G1 | FindButton (347) `FindData_Main()` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — FindButton (347) `FindData_Main()`: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (FindButton (347) `FindData_Main()`) |
| WK-SSP0019-0233 | G1 | InsertButton/DeleteButton/EditButton/Sav | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — InsertButton/DeleteButton/EditButton/SaveButton (3: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (InsertButton/DeleteButton/EditButton/Sav) |
| WK-SSP0019-0234 | G1 | MODAL:ItemByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — MODAL:ItemByDivisionModal: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ItemByDivisionModal) |
| WK-SSP0019-0235 | G1 | clbDivision_SelectedIndexChanged (235) ` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — clbDivision_SelectedIndexChanged (235) `SetChanged: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (clbDivision_SelectedIndexChanged (235) `) |
| WK-SSP0019-0236 | G1 | 조회 SP | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 조회 SP: 행 집계 — G1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (조회 SP) |
| WK-SSP0019-0237 | G6 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — COMMON:UC-06: 행 집계 — G6 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SSP0019-0238 | G6 | MODAL:ItemByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — MODAL:ItemByDivisionModal: 행 집계 — G6 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ItemByDivisionModal) |
| WK-SSP0019-0239 | X-LOC | ChkCurrent_CheckedChanged (241) `SetChec | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ChkCurrent_CheckedChanged (241) `SetCheckRow`: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (ChkCurrent_CheckedChanged (241) `SetChec) |
| WK-SSP0019-0240 | X-LOC | FindButton (347) `FindData_Main()` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — FindButton (347) `FindData_Main()`: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (FindButton (347) `FindData_Main()`) |
| WK-SSP0019-0241 | X-LOC | GET_DATE_RANGE_1MONTH (284,522) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — GET_DATE_RANGE_1MONTH (284,522): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (GET_DATE_RANGE_1MONTH (284,522)) |
| WK-SSP0019-0242 | X-LOC | InsertButton/DeleteButton/EditButton/Sav | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — InsertButton/DeleteButton/EditButton/SaveButton (3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (InsertButton/DeleteButton/EditButton/Sav) |
| WK-SSP0019-0243 | X-LOC | LockColumn(0,max,true) (438) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — LockColumn(0,max,true) (438): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (LockColumn(0,max,true) (438)) |
| WK-SSP0019-0244 | X-LOC | MyDivision inner-table (170,273) + EE li | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MyDivision inner-table (170,273) + EE literal 제외: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MyDivision inner-table (170,273) + EE li) |
| WK-SSP0019-0245 | X-LOC | PlantSiteByDivision (297, 비-EE) / Shipme | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — PlantSiteByDivision (297, 비-EE) / ShipmentPlanPlan: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (PlantSiteByDivision (297, 비-EE) / Shipme) |
| WK-SSP0019-0246 | X-LOC | REQUEST_NO cellTypeImage (339) + 가드(201, | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — REQUEST_NO cellTypeImage (339) + 가드(201,205): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (REQUEST_NO cellTypeImage (339) + 가드(201,) |
| WK-SSP0019-0247 | X-LOC | SSPToSiteByDivision (298, 비-EE) / Shipme | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SSPToSiteByDivision (298, 비-EE) / ShipmentPlanToSi: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SSPToSiteByDivision (298, 비-EE) / Shipme) |
| WK-SSP0019-0248 | X-LOC | SetBGColor LightSkyBlue (471,487) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SetBGColor LightSkyBlue (471,487): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SetBGColor LightSkyBlue (471,487)) |
| WK-SSP0019-0249 | X-LOC | SmartColMerge (440,536) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SmartColMerge (440,536): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SmartColMerge (440,536)) |
| WK-SSP0019-0250 | X-LOC | SpdMain_CellClick (199) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SpdMain_CellClick (199): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SpdMain_CellClick (199)) |
| WK-SSP0019-0251 | X-LOC | SpdMain_TopChange (533) SmartColMerge 재적 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SpdMain_TopChange (533) SmartColMerge 재적용: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SpdMain_TopChange (533) SmartColMerge 재적) |
| WK-SSP0019-0252 | X-LOC | VisibleRow (472,476,482) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — VisibleRow (472,476,482): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (VisibleRow (472,476,482)) |
| WK-SSP0019-0253 | X-LOC | btnItemId_Click (214) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — btnItemId_Click (214): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (btnItemId_Click (214)) |
| WK-SSP0019-0254 | X-LOC | clbDivision_SelectedIndexChanged (235) ` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — clbDivision_SelectedIndexChanged (235) `SetChanged: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (clbDivision_SelectedIndexChanged (235) `) |
| WK-SSP0019-0255 | X-LOC | ssp0019_Incoterms (306) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ssp0019_Incoterms (306): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (ssp0019_Incoterms (306)) |
| WK-SSP0019-0256 | X-LOC | ssp0019_TransportMode (307) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ssp0019_TransportMode (307): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (ssp0019_TransportMode (307)) |
| WK-SSP0019-0257 | X-LOC | 셀콤보 CHANGE_REASON_CODE_ALL (334) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 셀콤보 CHANGE_REASON_CODE_ALL (334): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (셀콤보 CHANGE_REASON_CODE_ALL (334)) |
| WK-SSP0019-0258 | X-LOC | 셀콤보 DIVISION_ID (Division) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 셀콤보 DIVISION_ID (Division): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (셀콤보 DIVISION_ID (Division)) |
| WK-SSP0019-0259 | X-LOC | 셀콤보 FCST_TYPE (LookupCommon SALES_TYPE_C | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 셀콤보 FCST_TYPE (LookupCommon SALES_TYPE_CODE): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (셀콤보 FCST_TYPE (LookupCommon SALES_TYPE_C) |
| WK-SSP0019-0260 | X-LOC | 셀콤보 dataMap (334) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 셀콤보 dataMap (334): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (셀콤보 dataMap (334)) |
| WK-SSP0019-0261 | X-ROW | D00-2-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-2-004: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-2-004) |
| WK-SSP0019-0262 | X-ROW | D00-3-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-007: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-007) |
| WK-SSP0019-0263 | X-ROW | D00-3-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-009: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-009) |
| WK-SSP0019-0264 | X-ROW | D00-4b-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4b-008: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4b-008) |
| WK-SSP0019-0265 | X-ROW | GET_DATE_RANGE_1MONTH (284,522) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GET_DATE_RANGE_1MONTH (284,522): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (GET_DATE_RANGE_1MONTH (284,522)) |
| WK-SSP0019-0266 | X-ROW | MyDivision inner-table (170,273) + EE li | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — MyDivision inner-table (170,273) + EE literal 제외: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (MyDivision inner-table (170,273) + EE li) |
| WK-SSP0019-0267 | X-ROW | PlantSiteByDivision (297, 비-EE) / Shipme | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — PlantSiteByDivision (297, 비-EE) / ShipmentPlanPlan: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (PlantSiteByDivision (297, 비-EE) / Shipme) |
| WK-SSP0019-0268 | X-ROW | SSP0019_ShipmentChangeHistory.ChkCurrent | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0019_ShipmentChangeHistory.ChkCurrent_CheckedCh: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0019_ShipmentChangeHistory.ChkCur) |
| WK-SSP0019-0269 | X-ROW | SSP0019_ShipmentChangeHistory.CreateSpre | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0019_ShipmentChangeHistory.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0019_ShipmentChangeHistory.Create) |
| WK-SSP0019-0270 | X-ROW | SSP0019_ShipmentChangeHistory.DefineProp | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0019_ShipmentChangeHistory.DefineProperty: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SSP0019_ShipmentChangeHistory.Define) |
| WK-SSP0019-0271 | X-ROW | SSP0019_ShipmentChangeHistory.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0019_ShipmentChangeHistory.FindButton: 진입점 집계 3검사 — NOT_RUN:2 · REVIEW:1 |  | 1 (ACT:SSP0019_ShipmentChangeHistory.FindBu) |
| WK-SSP0019-0272 | X-ROW | SSP0019_ShipmentChangeHistory.FindData_M | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0019_ShipmentChangeHistory.FindData_Main: 진입점 집계 15검사 — NOT_RUN:13 · REVIEW:1 · PASS:1 |  | 7 (ACT:SSP0019_ShipmentChangeHistory.FindDa) |
| WK-SSP0019-0273 | X-ROW | SSP0019_ShipmentChangeHistory.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0019_ShipmentChangeHistory.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0019_ShipmentChangeHistory.Form_L) |
| WK-SSP0019-0274 | X-ROW | SSP0019_ShipmentChangeHistory.GetDayRang | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0019_ShipmentChangeHistory.GetDayRange: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0019_ShipmentChangeHistory.GetDay) |
| WK-SSP0019-0275 | X-ROW | SSP0019_ShipmentChangeHistory.InitContro | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0019_ShipmentChangeHistory.InitControls: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0019_ShipmentChangeHistory.InitCo) |
| WK-SSP0019-0276 | X-ROW | SSP0019_ShipmentChangeHistory.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0019_ShipmentChangeHistory.InitSpread: 진입점 집계 10검사 — NOT_RUN:10 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SSP0019_ShipmentChangeHistory.InitSp) |
| WK-SSP0019-0277 | X-ROW | SSP0019_ShipmentChangeHistory.SetChangeC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0019_ShipmentChangeHistory.SetChangeControl: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SSP0019_ShipmentChangeHistory.SetCha) |
| WK-SSP0019-0278 | X-ROW | SSP0019_ShipmentChangeHistory.SetChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0019_ShipmentChangeHistory.SetChangedControl: 진입점 집계 13검사 — NOT_RUN:11 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SSP0019_ShipmentChangeHistory.SetCha) |
| WK-SSP0019-0279 | X-ROW | SSP0019_ShipmentChangeHistory.SetChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0019_ShipmentChangeHistory.SetChangedPeriod: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SSP0019_ShipmentChangeHistory.SetCha) |
| WK-SSP0019-0280 | X-ROW | SSP0019_ShipmentChangeHistory.SpdMain_Ce | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0019_ShipmentChangeHistory.SpdMain_CellClick: 진입점 집계 3검사 — NOPATH:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 9 (ACT:SSP0019_ShipmentChangeHistory.SpdMai) |
| WK-SSP0019-0281 | X-ROW | SSP0019_ShipmentChangeHistory.SpdMain_To | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0019_ShipmentChangeHistory.SpdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SSP0019_ShipmentChangeHistory.SpdMai) |
| WK-SSP0019-0282 | X-ROW | SSP0019_ShipmentChangeHistory.btnItemId_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0019_ShipmentChangeHistory.btnItemId_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SSP0019_ShipmentChangeHistory.btnIte) |
| WK-SSP0019-0283 | X-ROW | SSP0019_ShipmentChangeHistory.clbDivisio | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSP0019_ShipmentChangeHistory.clbDivision_Selected: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SSP0019_ShipmentChangeHistory.clbDiv) |
| WK-SSP0019-0284 | X-ROW | SSPToSiteByDivision (298, 비-EE) / Shipme | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SSPToSiteByDivision (298, 비-EE) / ShipmentPlanToSi: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (SSPToSiteByDivision (298, 비-EE) / Shipme) |
| WK-SSP0019-0285 | X-ROW | SpdMain_CellClick (199) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SpdMain_CellClick (199): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (SpdMain_CellClick (199)) |
| WK-SSP0019-0286 | X-ROW | ssp0019_Incoterms (306) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — ssp0019_Incoterms (306): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (ssp0019_Incoterms (306)) |
| WK-SSP0019-0287 | X-ROW | ssp0019_TransportMode (307) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — ssp0019_TransportMode (307): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (ssp0019_TransportMode (307)) |
| WK-SSP0019-0288 | G5 | D00-4e-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-4e-002: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-002) |
| WK-SSP0019-0289 | G5 | D00-4e-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-4e-003: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-003) |
| WK-SSP0019-0290 | G5 | From Site 사전필터 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — From Site 사전필터: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (From Site 사전필터) |
| WK-SSP0019-0291 | G5 | MODAL:ItemByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MODAL:ItemByDivisionModal: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ItemByDivisionModal) |
| WK-SSP0019-0292 | G5 | MODAL:ShowDialog | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MODAL:ShowDialog: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ShowDialog) |
| WK-SSP0019-0293 | G5 | ProgressForm (376) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — ProgressForm (376): 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (ProgressForm (376)) |
| WK-SSP0019-0294 | G5 | Project | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — Project: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (Project) |
| WK-SSP0019-0295 | G5 | SCM0002_GET_ITEM_BY_DIVISION_POPUP (Mode | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCM0002_GET_ITEM_BY_DIVISION_POPUP (Model 팝업): 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (SCM0002_GET_ITEM_BY_DIVISION_POPUP (Mode) |
| WK-SSP0019-0296 | G5 | SCM0002_ItembyDivisionPopup (Model, 221) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCM0002_ItembyDivisionPopup (Model, 221): 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (SCM0002_ItembyDivisionPopup (Model, 221)) |
| WK-SSP0019-0297 | G5 | `scpModuleType` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — `scpModuleType`: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (`scpModuleType`) |
| WK-SSP0019-0298 | G5 | 조회 SP | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — 조회 SP: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (조회 SP) |
| WK-SSP0019-0299 | H6 | D00-4e-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-4e-002: 행 집계 — H6 3요소: NOPATH:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-002) |
| WK-SSP0019-0300 | H6 | D00-4e-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-4e-003: 행 집계 — H6 3요소: NOPATH:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-003) |
| WK-SSP0019-0301 | H6 | From Site 사전필터 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — From Site 사전필터: 행 집계 — H6 3요소: NOPATH:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (From Site 사전필터) |
| WK-SSP0019-0302 | H6 | MODAL:ItemByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MODAL:ItemByDivisionModal: 행 집계 — H6 3요소: NOPATH:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ItemByDivisionModal) |
| WK-SSP0019-0303 | H6 | MODAL:ShowDialog | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MODAL:ShowDialog: 행 집계 — H6 3요소: NOPATH:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ShowDialog) |
| WK-SSP0019-0304 | H6 | ProgressForm (376) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — ProgressForm (376): 행 집계 — H6 3요소: NOPATH:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ProgressForm (376)) |
| WK-SSP0019-0305 | H6 | Project | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — Project: 행 집계 — H6 3요소: NOPATH:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (Project) |
| WK-SSP0019-0306 | H6 | SCM0002_GET_ITEM_BY_DIVISION_POPUP (Mode | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCM0002_GET_ITEM_BY_DIVISION_POPUP (Model 팝업): 행 집계 — H6 3요소: NOPATH:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (SCM0002_GET_ITEM_BY_DIVISION_POPUP (Mode) |
| WK-SSP0019-0307 | H6 | SCM0002_ItembyDivisionPopup (Model, 221) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCM0002_ItembyDivisionPopup (Model, 221): 행 집계 — H6 3요소: NOPATH:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (SCM0002_ItembyDivisionPopup (Model, 221)) |
| WK-SSP0019-0308 | H6 | `scpModuleType` | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — `scpModuleType`: 행 집계 — H6 3요소: NOPATH:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (`scpModuleType`) |
| WK-SSP0019-0309 | H6 | 조회 SP | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — 조회 SP: 행 집계 — H6 3요소: NOPATH:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (조회 SP) |
| WK-SSP0019-0310 | M4 | D00-4e-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-4e-002: 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-002) |
| WK-SSP0019-0311 | M4 | D00-4e-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-4e-003: 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-003) |
| WK-SSP0019-0312 | M4 | From Site 사전필터 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — From Site 사전필터: 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (From Site 사전필터) |
| WK-SSP0019-0313 | M4 | MODAL:ItemByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MODAL:ItemByDivisionModal: 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ItemByDivisionModal) |
| WK-SSP0019-0314 | M4 | MODAL:ShowDialog | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MODAL:ShowDialog: 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ShowDialog) |
| WK-SSP0019-0315 | M4 | ProgressForm (376) | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — ProgressForm (376): 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (ProgressForm (376)) |
| WK-SSP0019-0316 | M4 | Project | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — Project: 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (Project) |
| WK-SSP0019-0317 | M4 | SCM0002_GET_ITEM_BY_DIVISION_POPUP (Mode | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCM0002_GET_ITEM_BY_DIVISION_POPUP (Model 팝업): 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (SCM0002_GET_ITEM_BY_DIVISION_POPUP (Mode) |
| WK-SSP0019-0318 | M4 | SCM0002_ItembyDivisionPopup (Model, 221) | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCM0002_ItembyDivisionPopup (Model, 221): 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (SCM0002_ItembyDivisionPopup (Model, 221)) |
| WK-SSP0019-0319 | M4 | `scpModuleType` | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — `scpModuleType`: 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`scpModuleType`) |
| WK-SSP0019-0320 | M4 | 조회 SP | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 조회 SP: 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (조회 SP) |
