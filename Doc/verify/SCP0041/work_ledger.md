# 작업 원장 — SCP0041 · 2026-10-26 12:53

> 검사 인스턴스 382건 중 PASS·NA 156건 외 **226건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 15 | 구현 위치 실존 |
| W4 | 검사기 구현 | 2 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 23 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 46 | 실행 → PASS |
| W7 | 기대값 확정 | 140 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 131 · E2E 46 · 하네스 25 · 대조표 24
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 7건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 48 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| X-LOC | GEN |  | 15 |  |  |  |  | 12 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| A1 | GEN |  |  |  |  |  |  | 22 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| G1 | GEN |  |  |  |  |  | 5 | 13 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| E4 | EDIT |  |  |  |  |  | 5 | 10 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| G4 | DESIGN |  |  |  |  | 1 | 5 | 5 |  |  | 조회조건 표시·라벨·활성 |
| G6 | GEN |  |  |  |  |  | 5 | 5 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| X-REASON | DESIGN |  |  |  |  |  |  | 9 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| F4 | DB |  |  |  |  |  | 5 | 3 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| B4 | COMBO |  |  |  |  | 3 |  | 4 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| B3 | COMBO |  |  |  | 2 |  |  | 4 |  |  | 콤보 후보 정렬 = AS-IS |
| DB-SYN | DB |  |  |  |  | 2 |  | 3 |  |  | BE 계정 시노님·권한·대상 객체 |
| A6 | GEN |  |  |  |  |  | 2 | 2 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| B1 | COMBO |  |  |  |  | 3 |  |  |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 3 |  |  |  |  | 콤보 후보 중복 없음 |
| B6 | COMBO |  |  |  |  | 3 |  |  |  |  | ALL 옵션·다중선택 사양 |
| G5 | POPUP |  |  |  |  | 3 |  |  |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 2 | 1 |  |  |  | 팝업 표준·열림 |
| C1 | CASCADE |  |  |  |  |  | 3 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| M4 | POPUP |  |  |  |  |  | 3 |  |  |  | 팝업 선택값 반영 |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| C4 | CASCADE |  |  |  |  |  | 1 |  |  |  | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K-SA | COMMON |  |  |  |  |  | 1 |  |  |  | 조회영역 토글 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W2 구현 위치 확인 (15)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0041-0001 | X-LOC | D00-1-013 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-013) |
| WK-SCP0041-0002 | X-LOC | D00-1-014 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-1-014) |
| WK-SCP0041-0003 | X-LOC | D00-2-005 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (D00-2-005) |
| WK-SCP0041-0004 | X-LOC | `sheet[0] shtMain "Osp Stock"` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`sheet[0] shtMain "Osp Stock"`) |
| WK-SCP0041-0005 | X-LOC | `sheet[1] shtPacker "Pack Hold Stock"` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`sheet[1] shtPacker "Pack Hold Stock"`) |
| WK-SCP0041-0006 | X-LOC | `spdMain` FpSpread 2시트 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`spdMain` FpSpread 2시트) |
| WK-SCP0041-0007 | X-LOC | `usrConditionPanel1` (조건 패널) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`usrConditionPanel1` (조건 패널)) |
| WK-SCP0041-0008 | X-LOC | cboDivision (필수) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cboDivision (필수)) |
| WK-SCP0041-0009 | X-LOC | cboStatus (Pack) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cboStatus (Pack)) |
| WK-SCP0041-0010 | X-LOC | clbPlantSite (Osp) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (clbPlantSite (Osp)) |
| WK-SCP0041-0011 | X-LOC | clbPlantSite (Pack) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (clbPlantSite (Pack)) |
| WK-SCP0041-0012 | X-LOC | dCalendar (필수) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (dCalendar (필수)) |
| WK-SCP0041-0013 | X-LOC | dCalendarCutoff (Pack) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (dCalendarCutoff (Pack)) |
| WK-SCP0041-0014 | X-LOC | txtInspection (Pack) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (txtInspection (Pack)) |
| WK-SCP0041-0015 | X-LOC | txtItemId + btnItemId | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (txtItemId + btnItemId) |

## W4 검사기 구현 (2)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0041-0016 | B3 | cboDivision / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboDivision / Division | 있음(FE 소스) | 1 (cboDivision (필수)) |
| WK-SCP0041-0017 | B3 | cboStatus / Status | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboStatus / Status | 있음(FE 소스) | 1 (cboStatus (Pack)) |

## W5 검사기 연결 (23)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0041-0018 | B1 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (D00-1-002) |
| WK-SCP0041-0019 | B1 | cboStatus / Status | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboStatus / Status | 있음(FE 소스) | 1 (D00-1-018) |
| WK-SCP0041-0020 | B1 | clbPlantSite / Plant Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbPlantSite / Plant Site | 있음(FE 소스) | 1 (D00-1-004) |
| WK-SCP0041-0021 | B2 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (D00-1-002) |
| WK-SCP0041-0022 | B2 | cboStatus / Status | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboStatus / Status | 있음(FE 소스) | 1 (D00-1-018) |
| WK-SCP0041-0023 | B2 | clbPlantSite / Plant Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbPlantSite / Plant Site | 있음(FE 소스) | 1 (D00-1-004) |
| WK-SCP0041-0024 | B4 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 2 (D00-1-002 cboDivision (필수)) |
| WK-SCP0041-0025 | B4 | cboStatus / Status | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboStatus / Status | 있음(FE 소스) | 2 (D00-1-018 cboStatus (Pack)) |
| WK-SCP0041-0026 | B4 | clbPlantSite / Plant Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbPlantSite / Plant Site | 있음(FE 소스) | 1 (D00-1-004) |
| WK-SCP0041-0027 | B6 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (D00-1-002) |
| WK-SCP0041-0028 | B6 | cboStatus / Status | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboStatus / Status | 있음(FE 소스) | 1 (D00-1-018) |
| WK-SCP0041-0029 | B6 | clbPlantSite / Plant Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbPlantSite / Plant Site | 있음(FE 소스) | 1 (D00-1-004) |
| WK-SCP0041-0030 | F2 | SCP0041 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0041 화면 | 판단불가(대상 단위 SCREEN) | 130 (D00-4d-007 [R3] ACT:SCP0041_StockOSP.Sav) |
| WK-SCP0041-0031 | F6 | SCP0041 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0041 화면 | 판단불가(대상 단위 SCREEN) | 129 ([R3] ACT:SCP0041_StockOSP.SaveButton ACT) |
| WK-SCP0041-0032 | DB-SYN | SCM0001_GET_LOOKUP_VALUES | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_LOOKUP_VALUES | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0041_StockOSP.GetLookupData:165:3) |
| WK-SCP0041-0033 | DB-SYN | SCP0040_SAVE_CHARACTERISTIC_CAPA | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0040_SAVE_CHARACTERISTIC_CAPA | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0041_StockOSP.SaveData:354:20 ACT) |
| WK-SCP0041-0034 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 없음 | 3 (txtItemId + btnItemId ACT:SCP0041_StockO) |
| WK-SCP0041-0035 | G03-WIRE | SCP0041 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0041 화면 | 판단불가(대상 단위 SCREEN) | 9 (ACT:SCP0041_StockOSP..ctor ACT:SCP0041_S) |
| WK-SCP0041-0036 | G5 | btnExcel | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnExcel | 없음 | 1 (MODAL:ExcelUploadModal) |
| WK-SCP0041-0037 | G5 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnItemId | 없음 | 2 (MODAL:ItemByDivisionModal txtItemId + bt) |
| WK-SCP0041-0038 | G5 | txtItemId / Model / Item Id / Model/Nick | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND txtItemId / Model / Item Id / Model/Nickname | 있음(FE 소스) | 2 (MODAL:ItemByDivisionModal txtItemId + bt) |
| WK-SCP0041-0039 | H6 | btnExcel | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnExcel | 없음 | 1 (MODAL:ExcelUploadModal) |
| WK-SCP0041-0040 | H6 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnItemId | 없음 | 2 (MODAL:ItemByDivisionModal txtItemId + bt) |

## W6 검증 실행 (46)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0041-0041 | J2 | SCP0041 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0041 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 47 (D00-1-008 D00-2-001 D00-2-003 D00-2-006 ) |
| WK-SCP0041-0042 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-004 ACT:SCP0041_StockOSP.InitContr) |
| WK-SCP0041-0043 | C1 | cboStatus / Status | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboStatus / Status · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0041_StockOSP.InitControls:150:8) |
| WK-SCP0041-0044 | C1 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0041_StockOSP.SetChangedControl:5) |
| WK-SCP0041-0045 | C4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-004) |
| WK-SCP0041-0046 | G3 | SCP0041 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0041 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 4 (D00-1-024 COMMON:UC-04 COMMON:UC-06 `usr) |
| WK-SCP0041-0047 | K-SA | SCP0041 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCP0041 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 2 (D00-1-024 `usrConditionPanel1` (조건 패널)) |
| WK-SCP0041-0048 | K4 | SCP0041 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0041 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 21 (COMMON:UC-04 COMMON:UC-06 ACT:SCP0041_St) |
| WK-SCP0041-0049 | F1 | SCP0041 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0041 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 131 (D00-4d-007 [R3] [R5] ACT:SCP0041_StockOS) |
| WK-SCP0041-0050 | F5 | SCP0041 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0041 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 1 ([R5]) |
| WK-SCP0041-0051 | F4 | PKG_SCP0041.P_SCP0041_GET_PACK_HOLD_STOC | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0041.P_SCP0041_GET_PACK_HOLD_STOCK · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요 |  | 142 (ACT:SCP0041_StockOSP.FindButton ACT:SCP0) |
| WK-SCP0041-0052 | F4 | PKG_SCP0041.P_SCP0041_GET_STOCK_OSP | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0041.P_SCP0041_GET_STOCK_OSP · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smok |  | 79 (ACT:SCP0041_StockOSP.FindButton ACT:SCP0) |
| WK-SCP0041-0053 | F4 | PKG_SCP0041.P_SCP0041_SAVE_PACKER_HOLD_S | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0041.P_SCP0041_SAVE_PACKER_HOLD_STOCK · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 |  | 91 (ACT:SCP0041_StockOSP.SaveButton ACT:SCP0) |
| WK-SCP0041-0054 | F4 | SCM0001_GET_LOOKUP_VALUES | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_LOOKUP_VALUES · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:SCP0041_StockOSP.GetLookupData:165:3) |
| WK-SCP0041-0055 | F4 | SCP0040_SAVE_CHARACTERISTIC_CAPA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0040_SAVE_CHARACTERISTIC_CAPA · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·t |  | 37 (ACT:SCP0041_StockOSP.SaveData ACT:SCP004) |
| WK-SCP0041-0056 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 6 (D00-1-002 cboDivision (필수) ACT:SCP0041_S) |
| WK-SCP0041-0057 | G4 | cboStatus / Status | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboStatus / Status · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (D00-1-018 cboStatus (Pack) ACT:SCP0041_S) |
| WK-SCP0041-0058 | G4 | clbPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbPlantSite / Plant Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-004 clbPlantSite (Osp) clbPlantSit) |
| WK-SCP0041-0059 | G4 | txtInspection / DefPackLabel.INSEPECTION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtInspection / DefPackLabel.INSEPECTION_ID / Insp · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (D00-1-016 txtInspection (Pack)) |
| WK-SCP0041-0060 | G4 | txtItemId / Model / Item Id / Model/Nick | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (D00-1-006 txtItemId + btnItemId) |
| WK-SCP0041-0061 | I1 | SCP0041 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0041 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 10 (ACT:SCP0041_StockOSP.ActiveSheet_CellCha) |
| WK-SCP0041-0062 | SC1 | SCP0041 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SCP0041 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 16 (D00-1-002 D00-1-004 D00-1-006 D00-1-016 ) |
| WK-SCP0041-0063 | D6 | SCP0041 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0041 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 1 ([R4]) |
| WK-SCP0041-0064 | E4 | MSG00012 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00012 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0041_StockOSP.SaveButton:315:2) |
| WK-SCP0041-0065 | E4 | MSG00020 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00020 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0041_StockOSP.SaveData:373:35 ACT) |
| WK-SCP0041-0066 | E4 | MSG00108 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00108 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0041_StockOSP.ActiveSheet_CellCha) |
| WK-SCP0041-0067 | E4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 2 (ACT:SCP0041_StockOSP.SetChangedControl A) |
| WK-SCP0041-0068 | E4 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실 |  | 2 (ACT:SCP0041_StockOSP.SetChangedControl A) |
| WK-SCP0041-0069 | A10 | SCP0041 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0041 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 31 (ACT:SCP0041_StockOSP.DefineProperty ACT:) |
| WK-SCP0041-0070 | A6 | PKG_SCP0041.P_SCP0041_GET_PACK_HOLD_STOC | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0041.P_SCP0041_GET_PACK_HOLD_STOCK · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) |  | 52 (ACT:SCP0041_StockOSP.FindButton ACT:SCP0) |
| WK-SCP0041-0071 | A6 | PKG_SCP0041.P_SCP0041_GET_STOCK_OSP | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0041.P_SCP0041_GET_STOCK_OSP · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _tr |  | 44 (ACT:SCP0041_StockOSP.FindButton ACT:SCP0) |
| WK-SCP0041-0072 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 6 (D00-1-002 cboDivision (필수) ACT:SCP0041_S) |
| WK-SCP0041-0073 | G1 | cboStatus / Status | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboStatus / Status · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (D00-1-018 cboStatus (Pack) ACT:SCP0041_S) |
| WK-SCP0041-0074 | G1 | clbPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbPlantSite / Plant Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 7 (D00-1-004 clbPlantSite (Osp) clbPlantSit) |
| WK-SCP0041-0075 | G1 | txtInspection / DefPackLabel.INSEPECTION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtInspection / DefPackLabel.INSEPECTION_ID / Insp · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (D00-1-016 txtInspection (Pack) ACT:SCP00) |
| WK-SCP0041-0076 | G1 | txtItemId / Model / Item Id / Model/Nick | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 7 (D00-1-006 MODAL:ItemByDivisionModal txtI) |
| WK-SCP0041-0077 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 6 (D00-1-002 cboDivision (필수) ACT:SCP0041_S) |
| WK-SCP0041-0078 | G6 | cboStatus / Status | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboStatus / Status · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (D00-1-018 cboStatus (Pack) ACT:SCP0041_S) |
| WK-SCP0041-0079 | G6 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-004 clbPlantSite (Osp) clbPlantSit) |
| WK-SCP0041-0080 | G6 | txtInspection / DefPackLabel.INSEPECTION | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtInspection / DefPackLabel.INSEPECTION_ID / Insp · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (D00-1-016 txtInspection (Pack)) |
| WK-SCP0041-0081 | G6 | txtItemId / Model / Item Id / Model/Nick | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (D00-1-006 txtItemId + btnItemId) |
| WK-SCP0041-0082 | X-REOPEN | SCP0041 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0041 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 9 (ACT:SCP0041_StockOSP.Dispose ACT:SCP0041) |
| WK-SCP0041-0083 | H6 | txtItemId / Model / Item Id / Model/Nick | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 2 (MODAL:ItemByDivisionModal txtItemId + bt) |
| WK-SCP0041-0084 | M4 | btnExcel | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnExcel · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (MODAL:ExcelUploadModal) |
| WK-SCP0041-0085 | M4 | btnItemId | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnItemId · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (MODAL:ItemByDivisionModal txtItemId + bt) |
| WK-SCP0041-0086 | M4 | txtItemId / Model / Item Id / Model/Nick | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (MODAL:ItemByDivisionModal txtItemId + bt) |

## W7 기대값 확정 (140)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0041-0087 | B3 | D00-4b-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — D00-4b-002: 행 집계 — B3 2요소: TODO:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-002) |
| WK-SCP0041-0088 | B3 | D00-4b-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — D00-4b-003: 행 집계 — B3 2요소: TODO:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-003) |
| WK-SCP0041-0089 | B3 | SCP0041_StockOSP.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0041_StockOSP.GetDayRange: 진입점 집계 — B3 2요소: TODO:2 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SCP0041_StockOSP.GetDayRange:571:1 A) |
| WK-SCP0041-0090 | B3 | SCP0041_StockOSP.GetLookupData | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0041_StockOSP.GetLookupData: 진입점 집계 — B3 2요소: TODO:2 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0041_StockOSP.GetLookupData:161:1) |
| WK-SCP0041-0091 | B4 | D00-4b-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — D00-4b-002: 행 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-002) |
| WK-SCP0041-0092 | B4 | D00-4b-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — D00-4b-003: 행 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-003) |
| WK-SCP0041-0093 | B4 | SCP0041_StockOSP.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0041_StockOSP.GetDayRange: 진입점 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SCP0041_StockOSP.GetDayRange:571:1 A) |
| WK-SCP0041-0094 | B4 | SCP0041_StockOSP.GetLookupData | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0041_StockOSP.GetLookupData: 진입점 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0041_StockOSP.GetLookupData:161:1) |
| WK-SCP0041-0095 | DB-SYN | D00-3-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — D00-3-013: 행 집계 — DB-SYN 5요소: PASS:3 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-013) |
| WK-SCP0041-0096 | DB-SYN | D00-3-015 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — D00-3-015: 행 집계 — DB-SYN 5요소: PASS:3 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-015) |
| WK-SCP0041-0097 | DB-SYN | [R3] | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — [R3]: 행 집계 — DB-SYN 5요소: PASS:3 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 ([R3]) |
| WK-SCP0041-0098 | F4 | D00-3-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — D00-3-013: 행 집계 — F4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-013) |
| WK-SCP0041-0099 | F4 | D00-3-015 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — D00-3-015: 행 집계 — F4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-015) |
| WK-SCP0041-0100 | F4 | [R3] | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — [R3]: 행 집계 — F4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 ([R3]) |
| WK-SCP0041-0101 | G4 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — COMMON:UC-06: 행 집계 — G4 6요소: NOT_RUN:5 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0041-0102 | G4 | D00-1-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-1-024: 행 집계 — G4 6요소: NOT_RUN:5 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-024) |
| WK-SCP0041-0103 | G4 | D00-1-025 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-1-025: 행 집계 — G4 6요소: NOT_RUN:5 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-025) |
| WK-SCP0041-0104 | G4 | dCalendar (필수) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — dCalendar (필수): 행 집계 — G4 6요소: NOT_RUN:5 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (dCalendar (필수)) |
| WK-SCP0041-0105 | G4 | dCalendarCutoff (Pack) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — dCalendarCutoff (Pack): 행 집계 — G4 6요소: NOT_RUN:5 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (dCalendarCutoff (Pack)) |
| WK-SCP0041-0106 | X-REASON | COMMON:UC-01 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-01 필터링 상태에서 신규행 Insert 시 필터를 유지한 채 추가 행이 보이도록 (keepRowVisibleUnderFilter) — INSERT 버튼 DB 미등록(hasButto |  | 1 (COMMON:UC-01) |
| WK-SCP0041-0107 | X-REASON | COMMON:UC-02 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-02 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703) — AS-IS SCP0041_StockOS |  | 1 (COMMON:UC-02) |
| WK-SCP0041-0108 | X-REASON | COMMON:UC-05 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-05 Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계) 공용 SubTitle excelFileName 위 |  | 1 (COMMON:UC-05) |
| WK-SCP0041-0109 | X-REASON | COMMON:UC-07 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-07 필터가 걸린 상태에서 재조회해도 조회되고 필터도 그대로 적용 (rebindFilterColumns) 공용 DataGrid gridFilterRef 위임 필터 유지·rebind  |  | 1 (COMMON:UC-07) |
| WK-SCP0041-0110 | X-REASON | D00-1-028 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-028 §1 components / Container — Designer IContainer(컴포넌트 트레이) — 런타임 UI 아님, React 대응 없음 해당없음 |  | 1 (D00-1-028) |
| WK-SCP0041-0111 | X-REASON | D00-3-014 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-014 §3 LockColumn / (1, GetMaxColumnIndex, true) — 조회 후 전열 잠금 — AS-IS 조회모드 전열잠금 = EditButton 모드토글의 일부(R12 |  | 1 (D00-3-014) |
| WK-SCP0041-0112 | X-REASON | D00-3-016 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-016 §3 LockColumn / (1, GetMaxColumnIndex, true) — 조회 후 전열 잠금 — D00-3-014 와 동일 — 조회모드 전열잠금(R12/R13)은 Edit |  | 1 (D00-3-016) |
| WK-SCP0041-0113 | X-REASON | D00-4b-005 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-4b-005 §4b Data.CallBizCommonData / PERIOD_DEFAULT / dt — AS-IS 기간 기본값(PERIOD_DEFAULT) 프리셋 — TO-BE PeriodFi |  | 1 (D00-4b-005) |
| WK-SCP0041-0114 | X-REASON | MODAL:FPModal | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — MODAL:FPModal AS-IS 화면에 별도 FPModal(범용 조회 팝업) 사용 없음 — Model 조회는 ItemByDivisionModal(COM0008) 단일 — AS-IS SCP0041_ |  | 1 (MODAL:FPModal) |
| WK-SCP0041-0115 | E4 | D00-2-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D00-2-001: 행 집계 — E4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-001) |
| WK-SCP0041-0116 | E4 | D00-4d-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D00-4d-006: 행 집계 — E4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-006) |
| WK-SCP0041-0117 | E4 | D00-4d-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D00-4d-007: 행 집계 — E4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-007) |
| WK-SCP0041-0118 | E4 | D00-4d-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D00-4d-008: 행 집계 — E4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-008) |
| WK-SCP0041-0119 | E4 | SCP0041_StockOSP.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0041_StockOSP.SetChangedControl: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0041_StockOSP.SetChangedControl:5) |
| WK-SCP0041-0120 | E4 | SCP0041_StockOSP.SetSelectMenu | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0041_StockOSP.SetSelectMenu: 진입점 집계 — E4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0041_StockOSP.SetSelectMenu:600:3) |
| WK-SCP0041-0121 | E4 | SCP0041_StockOSP.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0041_StockOSP.SetSpreadInit: 진입점 집계 — E4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0041_StockOSP.SetSpreadInit:201:1) |
| WK-SCP0041-0122 | E4 | SCP0041_StockOSP.SetTabIndex | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0041_StockOSP.SetTabIndex: 진입점 집계 — E4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0041_StockOSP.SetTabIndex:516:1) |
| WK-SCP0041-0123 | E4 | SCP0041_StockOSP.setPeriod | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0041_StockOSP.setPeriod: 진입점 집계 — E4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 15 (ACT:SCP0041_StockOSP.setPeriod:540:1 ACT) |
| WK-SCP0041-0124 | E4 | [R7] | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — [R7]: 행 집계 — E4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 ([R7]) |
| WK-SCP0041-0125 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (COMMON:UC-06) |
| WK-SCP0041-0126 | A1 | D00-1-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-008: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (D00-1-008) |
| WK-SCP0041-0127 | A1 | D00-2-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-001: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (D00-2-001) |
| WK-SCP0041-0128 | A1 | D00-2-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-003: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (D00-2-003) |
| WK-SCP0041-0129 | A1 | D00-3-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-013: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (D00-3-013) |
| WK-SCP0041-0130 | A1 | D00-3-015 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-015: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (D00-3-015) |
| WK-SCP0041-0131 | A1 | MODAL:ItemByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — MODAL:ItemByDivisionModal: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (MODAL:ItemByDivisionModal) |
| WK-SCP0041-0132 | A1 | PKG_SCP0041.P_SCP0041_GET_PACK_HOLD_STOC | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0041.P_SCP0041_GET_PACK_HOLD_STOCK: 골든 비교 케이스 없음(PKG_SCP0041.P_SCP0041_GET_PACK_HOLD_STOCK — 팝업·보조 SP 는 golden_ |  | 52 (ACT:SCP0041_StockOSP.FindButton ACT:SCP0) |
| WK-SCP0041-0133 | A1 | PKG_SCP0041.P_SCP0041_GET_STOCK_OSP | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0041.P_SCP0041_GET_STOCK_OSP: 골든 비교 케이스 없음(PKG_SCP0041.P_SCP0041_GET_STOCK_OSP — 팝업·보조 SP 는 golden_cases.csv 에  |  | 44 (ACT:SCP0041_StockOSP.FindButton ACT:SCP0) |
| WK-SCP0041-0134 | A1 | [R10] | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — [R10]: 행 집계 — A1 2요소: REVIEW:2 |  | 1 ([R10]) |
| WK-SCP0041-0135 | A1 | [R12/R13] | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — [R12/R13]: 행 집계 — A1 2요소: REVIEW:2 |  | 1 ([R12/R13]) |
| WK-SCP0041-0136 | A1 | [R1] | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — [R1]: 행 집계 — A1 2요소: REVIEW:2 |  | 1 ([R1]) |
| WK-SCP0041-0137 | A1 | [R2] | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — [R2]: 행 집계 — A1 2요소: REVIEW:2 |  | 1 ([R2]) |
| WK-SCP0041-0138 | A1 | `sheet[0] shtMain "Osp Stock"` | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `sheet[0] shtMain "Osp Stock"`: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (`sheet[0] shtMain "Osp Stock"`) |
| WK-SCP0041-0139 | A1 | cboDivision (필수) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboDivision (필수): 행 집계 — A1 2요소: REVIEW:2 |  | 1 (cboDivision (필수)) |
| WK-SCP0041-0140 | A1 | cboStatus (Pack) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboStatus (Pack): 행 집계 — A1 2요소: REVIEW:2 |  | 1 (cboStatus (Pack)) |
| WK-SCP0041-0141 | A1 | clbPlantSite (Osp) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbPlantSite (Osp): 행 집계 — A1 2요소: REVIEW:2 |  | 1 (clbPlantSite (Osp)) |
| WK-SCP0041-0142 | A1 | clbPlantSite (Pack) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbPlantSite (Pack): 행 집계 — A1 2요소: REVIEW:2 |  | 1 (clbPlantSite (Pack)) |
| WK-SCP0041-0143 | A1 | dCalendar (필수) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — dCalendar (필수): 행 집계 — A1 2요소: REVIEW:2 |  | 1 (dCalendar (필수)) |
| WK-SCP0041-0144 | A1 | dCalendarCutoff (Pack) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — dCalendarCutoff (Pack): 행 집계 — A1 2요소: REVIEW:2 |  | 1 (dCalendarCutoff (Pack)) |
| WK-SCP0041-0145 | A1 | txtInspection (Pack) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — txtInspection (Pack): 행 집계 — A1 2요소: REVIEW:2 |  | 1 (txtInspection (Pack)) |
| WK-SCP0041-0146 | A1 | txtItemId + btnItemId | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — txtItemId + btnItemId: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (txtItemId + btnItemId) |
| WK-SCP0041-0147 | A6 | D00-3-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — D00-3-013: 행 집계 — A6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-013) |
| WK-SCP0041-0148 | A6 | D00-3-015 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — D00-3-015: 행 집계 — A6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-015) |
| WK-SCP0041-0149 | G1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-06: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0041-0150 | G1 | D00-1-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-008: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-008) |
| WK-SCP0041-0151 | G1 | D00-1-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-024: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-024) |
| WK-SCP0041-0152 | G1 | D00-1-025 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-025: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-025) |
| WK-SCP0041-0153 | G1 | D00-2-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-2-001: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-001) |
| WK-SCP0041-0154 | G1 | D00-2-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-2-003: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-003) |
| WK-SCP0041-0155 | G1 | [R10] | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — [R10]: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 ([R10]) |
| WK-SCP0041-0156 | G1 | [R12/R13] | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — [R12/R13]: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 ([R12/R13]) |
| WK-SCP0041-0157 | G1 | [R1] | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — [R1]: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 ([R1]) |
| WK-SCP0041-0158 | G1 | [R2] | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — [R2]: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 ([R2]) |
| WK-SCP0041-0159 | G1 | `sheet[0] shtMain "Osp Stock"` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `sheet[0] shtMain "Osp Stock"`: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`sheet[0] shtMain "Osp Stock"`) |
| WK-SCP0041-0160 | G1 | dCalendar (필수) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — dCalendar (필수): 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (dCalendar (필수)) |
| WK-SCP0041-0161 | G1 | dCalendarCutoff (Pack) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — dCalendarCutoff (Pack): 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (dCalendarCutoff (Pack)) |
| WK-SCP0041-0162 | G6 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — COMMON:UC-06: 행 집계 — G6 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0041-0163 | G6 | D00-1-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-1-024: 행 집계 — G6 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-024) |
| WK-SCP0041-0164 | G6 | D00-1-025 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-1-025: 행 집계 — G6 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-025) |
| WK-SCP0041-0165 | G6 | dCalendar (필수) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — dCalendar (필수): 행 집계 — G6 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (dCalendar (필수)) |
| WK-SCP0041-0166 | G6 | dCalendarCutoff (Pack) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — dCalendarCutoff (Pack): 행 집계 — G6 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (dCalendarCutoff (Pack)) |
| WK-SCP0041-0167 | X-LOC | [R10] | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — [R10]: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ([R10]) |
| WK-SCP0041-0168 | X-LOC | [R11] | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — [R11]: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ([R11]) |
| WK-SCP0041-0169 | X-LOC | [R12/R13] | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — [R12/R13]: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ([R12/R13]) |
| WK-SCP0041-0170 | X-LOC | [R1] | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — [R1]: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ([R1]) |
| WK-SCP0041-0171 | X-LOC | [R2] | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — [R2]: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ([R2]) |
| WK-SCP0041-0172 | X-LOC | [R3] | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — [R3]: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ([R3]) |
| WK-SCP0041-0173 | X-LOC | [R4] | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — [R4]: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ([R4]) |
| WK-SCP0041-0174 | X-LOC | [R5] | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — [R5]: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ([R5]) |
| WK-SCP0041-0175 | X-LOC | [R6] | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — [R6]: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ([R6]) |
| WK-SCP0041-0176 | X-LOC | [R7] | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — [R7]: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ([R7]) |
| WK-SCP0041-0177 | X-LOC | [R8] | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — [R8]: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ([R8]) |
| WK-SCP0041-0178 | X-LOC | [R9] | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — [R9]: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ([R9]) |
| WK-SCP0041-0179 | X-ROW | D00-1-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-001: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-001) |
| WK-SCP0041-0180 | X-ROW | D00-1-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-003: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-003) |
| WK-SCP0041-0181 | X-ROW | D00-1-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-005: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-005) |
| WK-SCP0041-0182 | X-ROW | D00-1-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-007: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-007) |
| WK-SCP0041-0183 | X-ROW | D00-1-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-009: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-009) |
| WK-SCP0041-0184 | X-ROW | D00-1-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-010: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-010) |
| WK-SCP0041-0185 | X-ROW | D00-1-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-011: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-011) |
| WK-SCP0041-0186 | X-ROW | D00-1-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-012: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-012) |
| WK-SCP0041-0187 | X-ROW | D00-1-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-013: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-013) |
| WK-SCP0041-0188 | X-ROW | D00-1-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-014: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-014) |
| WK-SCP0041-0189 | X-ROW | D00-1-015 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-015: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-015) |
| WK-SCP0041-0190 | X-ROW | D00-1-017 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-017: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-017) |
| WK-SCP0041-0191 | X-ROW | D00-1-019 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-019: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-019) |
| WK-SCP0041-0192 | X-ROW | D00-1-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-020: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-020) |
| WK-SCP0041-0193 | X-ROW | D00-1-026 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-026: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-026) |
| WK-SCP0041-0194 | X-ROW | D00-2-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-2-002: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-2-002) |
| WK-SCP0041-0195 | X-ROW | D00-2-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-2-005: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-2-005) |
| WK-SCP0041-0196 | X-ROW | D00-2-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-2-007: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-2-007) |
| WK-SCP0041-0197 | X-ROW | D00-3-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-001: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-001) |
| WK-SCP0041-0198 | X-ROW | D00-3-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-002: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-002) |
| WK-SCP0041-0199 | X-ROW | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4b-001: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4b-001) |
| WK-SCP0041-0200 | X-ROW | D00-4b-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4b-004: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4b-004) |
| WK-SCP0041-0201 | X-ROW | D00-4c-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-001: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-001) |
| WK-SCP0041-0202 | X-ROW | D00-4c-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-003: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-003) |
| WK-SCP0041-0203 | X-ROW | SCP0041_StockOSP.ActiveSheet_CellChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0041_StockOSP.ActiveSheet_CellChanged: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0041_StockOSP.ActiveSheet_CellCha) |
| WK-SCP0041-0204 | X-ROW | SCP0041_StockOSP.BtnItemId_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0041_StockOSP.BtnItemId_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0041_StockOSP.BtnItemId_Click:872) |
| WK-SCP0041-0205 | X-ROW | SCP0041_StockOSP.CboDivision_SelectedInd | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0041_StockOSP.CboDivision_SelectedIndexChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0041_StockOSP.CboDivision_Selecte) |
| WK-SCP0041-0206 | X-ROW | SCP0041_StockOSP.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0041_StockOSP.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0041_StockOSP.CreateSpread) |
| WK-SCP0041-0207 | X-ROW | SCP0041_StockOSP.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0041_StockOSP.DefineProperty: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0041_StockOSP.DefineProperty ACT:) |
| WK-SCP0041-0208 | X-ROW | SCP0041_StockOSP.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0041_StockOSP.EditButton: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0041_StockOSP.EditButton) |
| WK-SCP0041-0209 | X-ROW | SCP0041_StockOSP.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0041_StockOSP.FindButton: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:2 |  | 1 (ACT:SCP0041_StockOSP.FindButton) |
| WK-SCP0041-0210 | X-ROW | SCP0041_StockOSP.FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0041_StockOSP.FindData_Main: 진입점 집계 9검사 — NOT_RUN:7 · REVIEW:1 · PASS:1 |  | 7 (ACT:SCP0041_StockOSP.FindData_Main:631:1) |
| WK-SCP0041-0211 | X-ROW | SCP0041_StockOSP.FindData_Pack | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0041_StockOSP.FindData_Pack: 진입점 집계 11검사 — NOT_RUN:9 · REVIEW:1 · PASS:1 |  | 7 (ACT:SCP0041_StockOSP.FindData_Pack:704:1) |
| WK-SCP0041-0212 | X-ROW | SCP0041_StockOSP.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0041_StockOSP.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0041_StockOSP.Form_Load) |
| WK-SCP0041-0213 | X-ROW | SCP0041_StockOSP.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0041_StockOSP.GetDayRange: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0041_StockOSP.GetDayRange) |
| WK-SCP0041-0214 | X-ROW | SCP0041_StockOSP.GetLookupData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0041_StockOSP.GetLookupData: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0041_StockOSP.GetLookupData) |
| WK-SCP0041-0215 | X-ROW | SCP0041_StockOSP.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0041_StockOSP.InitControls: 진입점 집계 7검사 — NOT_RUN:7 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0041_StockOSP.InitControls:143:3 ) |
| WK-SCP0041-0216 | X-ROW | SCP0041_StockOSP.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0041_StockOSP.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0041_StockOSP.InitSpread) |
| WK-SCP0041-0217 | X-ROW | SCP0041_StockOSP.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0041_StockOSP.SaveData: 진입점 집계 10검사 — NOT_RUN:6 · NOPATH:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0041_StockOSP.SaveData:356:22) |
| WK-SCP0041-0218 | X-ROW | SCP0041_StockOSP.SaveDataPacker | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0041_StockOSP.SaveDataPacker: 진입점 집계 11검사 — NOT_RUN:7 · NOPATH:2 · PASS:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0041_StockOSP.SaveDataPacker:449:) |
| WK-SCP0041-0219 | X-ROW | SCP0041_StockOSP.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0041_StockOSP.SetChangedControl: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0041_StockOSP.SetChangedControl A) |
| WK-SCP0041-0220 | X-ROW | SCP0041_StockOSP.SetSelectMenu | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0041_StockOSP.SetSelectMenu: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 16 (ACT:SCP0041_StockOSP.SetSelectMenu ACT:S) |
| WK-SCP0041-0221 | X-ROW | SCP0041_StockOSP.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0041_StockOSP.SetSpreadInit: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0041_StockOSP.SetSpreadInit) |
| WK-SCP0041-0222 | X-ROW | SCP0041_StockOSP.SetTabIndex | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0041_StockOSP.SetTabIndex: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0041_StockOSP.SetTabIndex) |
| WK-SCP0041-0223 | X-ROW | SCP0041_StockOSP.SpdMain_SheetTabClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0041_StockOSP.SpdMain_SheetTabClick: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0041_StockOSP.SpdMain_SheetTabCli) |
| WK-SCP0041-0224 | X-ROW | SCP0041_StockOSP.btnExcelUpload_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0041_StockOSP.btnExcelUpload_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0041_StockOSP.btnExcelUpload_Clic) |
| WK-SCP0041-0225 | X-ROW | SCP0041_StockOSP.setPeriod | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0041_StockOSP.setPeriod: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0041_StockOSP.setPeriod ACT:SCP00) |
| WK-SCP0041-0226 | X-ROW | `SCP0041_StockOSP` Form | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `SCP0041_StockOSP` Form: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`SCP0041_StockOSP` Form) |
