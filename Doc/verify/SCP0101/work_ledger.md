# 작업 원장 — SCP0101 · 2026-10-26 12:54

> 검사 인스턴스 223건 중 PASS·NA 73건 외 **150건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 32 | 구현 위치 실존 |
| W5 | 검사기 연결 | 7 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 37 | 실행 → PASS |
| W7 | 기대값 확정 | 74 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 74 · E2E 37 · 대조표 32 · 하네스 7
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 3건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-LOC | GEN |  | 32 |  |  |  |  | 5 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-ROW | GEN |  |  |  |  |  |  | 37 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| E4 | EDIT |  |  |  |  |  | 9 | 8 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| A1 | GEN |  |  |  |  |  |  | 11 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| C1 | CASCADE |  |  |  |  |  | 3 | 2 |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| G4 | DESIGN |  |  |  |  | 2 | 2 |  |  |  | 조회조건 표시·라벨·활성 |
| F4 | DB |  |  |  |  |  | 3 | 1 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| DB-SYN | DB |  |  |  |  | 2 |  | 1 |  |  | BE 계정 시노님·권한·대상 객체 |
| C4 | CASCADE |  |  |  |  |  | 1 | 2 |  |  | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| D1 | EDIT |  |  |  |  |  | 1 | 2 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 1 | 2 |  |  | 행 값 기반 조건부 잠금 |
| A6 | GEN |  |  |  |  |  | 3 |  |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| G5 | POPUP |  |  |  |  | 1 |  | 1 |  |  | 팝업 조건 연동(인자) |
| G6 | GEN |  |  |  |  |  | 2 |  |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| H6 | POPUP |  |  |  |  |  | 1 | 1 |  |  | 팝업 표준·열림 |
| M4 | POPUP |  |  |  |  |  | 1 | 1 |  |  | 팝업 선택값 반영 |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K-SA | COMMON |  |  |  |  |  | 1 |  |  |  | 조회영역 토글 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W2 구현 위치 확인 (32)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0101-0001 | X-LOC | (조회 로그성 호출) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 ((조회 로그성 호출)) |
| WK-SCP0101-0002 | X-LOC | BtnColumn_Click → InitSpread(TitleSet) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (BtnColumn_Click → InitSpread(TitleSet)) |
| WK-SCP0101-0003 | X-LOC | BtnItem_Id_Click → ItembyDivisionPopup | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (BtnItem_Id_Click → ItembyDivisionPopup) |
| WK-SCP0101-0004 | X-LOC | CboDivision_SelectedIndexChanged → SetCh | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CboDivision_SelectedIndexChanged → SetCh) |
| WK-SCP0101-0005 | X-LOC | ChkDetail_CheckedChanged → SetLayout | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (ChkDetail_CheckedChanged → SetLayout) |
| WK-SCP0101-0006 | X-LOC | ExcelButton 조회 0건 확인(MSG00100) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (ExcelButton 조회 0건 확인(MSG00100)) |
| WK-SCP0101-0007 | X-LOC | LockColumn 조회후 전 컬럼 잠금(R7) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (LockColumn 조회후 전 컬럼 잠금(R7)) |
| WK-SCP0101-0008 | X-LOC | MonthPicker_ValueChanged → SetSpreadHead | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (MonthPicker_ValueChanged → SetSpreadHead) |
| WK-SCP0101-0009 | X-LOC | SCP0084_GET_MONTH_RANGE(월범위 초기화) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SCP0084_GET_MONTH_RANGE(월범위 초기화)) |
| WK-SCP0101-0010 | X-LOC | SCP0101_GET_INVENTORY_TREND(Find) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SCP0101_GET_INVENTORY_TREND(Find)) |
| WK-SCP0101-0011 | X-LOC | SetBackColor — LongTerm 행 음영(R1) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SetBackColor — LongTerm 행 음영(R1)) |
| WK-SCP0101-0012 | X-LOC | SetCellColor — CHK_QTY 40/30/20/10 → INV | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SetCellColor — CHK_QTY 40/30/20/10 → INV) |
| WK-SCP0101-0013 | X-LOC | SetSpreadHeader — INV_STATUS row0="{focu | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SetSpreadHeader — INV_STATUS row0="{focu) |
| WK-SCP0101-0014 | X-LOC | SetSpreadHeader — LONG_TERM_STOCK_AMOUNT | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SetSpreadHeader — LONG_TERM_STOCK_AMOUNT) |
| WK-SCP0101-0015 | X-LOC | SetSpreadHeader — QTY_MONTH1..5 = -5..-1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SetSpreadHeader — QTY_MONTH1..5 = -5..-1) |
| WK-SCP0101-0016 | X-LOC | SetSpreadHeader — QTY_MONTH_FOCUS = 선택월  | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SetSpreadHeader — QTY_MONTH_FOCUS = 선택월 ) |
| WK-SCP0101-0017 | X-LOC | SmartColMerge — 반복 셀 세로 병합(R4) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SmartColMerge — 반복 셀 세로 병합(R4)) |
| WK-SCP0101-0018 | X-LOC | `*` 접미 필수필드(MSG00002) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`*` 접미 필수필드(MSG00002)) |
| WK-SCP0101-0019 | X-LOC | btnColumn (Column 설정) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (btnColumn (Column 설정)) |
| WK-SCP0101-0020 | X-LOC | btnItem_Id (UsrButton) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (btnItem_Id (UsrButton)) |
| WK-SCP0101-0021 | X-LOC | cboDivision (UsrCheckedList2) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cboDivision (UsrCheckedList2)) |
| WK-SCP0101-0022 | X-LOC | checkRequiredOfSearch — 권한 Division 0건 → | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (checkRequiredOfSearch — 권한 Division 0건 →) |
| WK-SCP0101-0023 | X-LOC | chkDetail (상세토글) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (chkDetail (상세토글)) |
| WK-SCP0101-0024 | X-LOC | clbPlant (UsrCheckedList2) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (clbPlant (UsrCheckedList2)) |
| WK-SCP0101-0025 | X-LOC | emptySpaceItem1/2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (emptySpaceItem1/2) |
| WK-SCP0101-0026 | X-LOC | emptySpaceItem6 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (emptySpaceItem6) |
| WK-SCP0101-0027 | X-LOC | layoutControlGroup2 / usrLayoutControl2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (layoutControlGroup2 / usrLayoutControl2) |
| WK-SCP0101-0028 | X-LOC | monthPicker (UsrMonthPicker) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (monthPicker (UsrMonthPicker)) |
| WK-SCP0101-0029 | X-LOC | spdMain (FpSpread) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (spdMain (FpSpread)) |
| WK-SCP0101-0030 | X-LOC | txtItem_Id (UsrMultiLineEditor) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (txtItem_Id (UsrMultiLineEditor)) |
| WK-SCP0101-0031 | X-LOC | usrConditionPanel1 (HidePanel) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (usrConditionPanel1 (HidePanel)) |
| WK-SCP0101-0032 | X-LOC | 셀 콤보 0 / measure 0 / lookup 바인딩 0 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (셀 콤보 0 / measure 0 / lookup 바인딩 0) |

## W5 검사기 연결 (7)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0101-0033 | F2 | SCP0101 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0101 화면 | 판단불가(대상 단위 SCREEN) | 1 (SaveButton (빈 본문 NO-OP)) |
| WK-SCP0101-0034 | DB-SYN | PKG_SCP0101 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP PKG_SCP0101 | 없음(PROC_M 대응 없음) | 1 (SCP0101_GET_INVENTORY_TREND(Find)) |
| WK-SCP0101-0035 | DB-SYN | SCP0084_GET_MONTH_RANGE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0084_GET_MONTH_RANGE | 없음(PROC_M 대응 없음) | 2 (SCP0084_GET_MONTH_RANGE(월범위 초기화) ACT:SCP) |
| WK-SCP0101-0036 | G4 | btnColumn | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnColumn | 있음(FE 소스) | 2 (ACT:SCP0101_InventoryTrend.InitEvent ACT) |
| WK-SCP0101-0037 | G4 | btnItem | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItem | 없음 | 2 (ACT:SCP0101_InventoryTrend.InitEvent ACT) |
| WK-SCP0101-0038 | G03-WIRE | SCP0101 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0101 화면 | 판단불가(대상 단위 SCREEN) | 9 (ACT:SCP0101_InventoryTrend..ctor ACT:SCP) |
| WK-SCP0101-0039 | G5 | txtItem_Id / Material / Item_Id / Meteri | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND txtItem_Id / Material / Item_Id / Meterial | 있음(FE 소스) | 1 (txtItem_Id (UsrMultiLineEditor)) |

## W6 검증 실행 (37)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0101-0040 | J2 | SCP0101 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0101 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 30 (CboDivision_SelectedIndexChanged → SetCh) |
| WK-SCP0101-0041 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0101_InventoryTrend.InitControls:) |
| WK-SCP0101-0042 | C1 | chkDetail / Detail | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — chkDetail / Detail · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ChkDetail_CheckedChanged → SetLayout) |
| WK-SCP0101-0043 | C1 | clbPlant / Plant | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbPlant / Plant · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0101_InventoryTrend.SetChangedCon) |
| WK-SCP0101-0044 | C4 | chkDetail / Detail | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — chkDetail / Detail · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (ChkDetail_CheckedChanged → SetLayout) |
| WK-SCP0101-0045 | G3 | SCP0101 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0101 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 3 (usrConditionPanel1 (HidePanel) layoutCon) |
| WK-SCP0101-0046 | K-SA | SCP0101 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCP0101 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 3 (usrConditionPanel1 (HidePanel) layoutCon) |
| WK-SCP0101-0047 | K4 | SCP0101 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0101 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 19 (ACT:SCP0101_InventoryTrend.BtnColumn_Cli) |
| WK-SCP0101-0048 | F1 | SCP0101 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0101 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 2 (SaveButton (빈 본문 NO-OP) insert/delete/ma) |
| WK-SCP0101-0049 | F5 | SCP0101 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0101 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 1 (insert/delete/manual/upload) |
| WK-SCP0101-0050 | F4 | PKG_SCP0101 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0101 · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (SCP0101_GET_INVENTORY_TREND(Find)) |
| WK-SCP0101-0051 | F4 | PKG_SCP0101.P_SCP0101_GET_INVENTORY_TREN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0101.P_SCP0101_GET_INVENTORY_TREND · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요 |  | 6 (SCP0101_GET_INVENTORY_TREND(Find) ACT:SC) |
| WK-SCP0101-0052 | F4 | SCP0084_GET_MONTH_RANGE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0084_GET_MONTH_RANGE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (SCP0084_GET_MONTH_RANGE(월범위 초기화) ACT:SCP) |
| WK-SCP0101-0053 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0101_InventoryTrend.InitControls ) |
| WK-SCP0101-0054 | G4 | chkDetail / Detail | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkDetail / Detail · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0101_InventoryTrend.InitEvent ACT) |
| WK-SCP0101-0055 | I1 | SCP0101 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0101 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 6 (checkRequiredOfSearch — 권한 Division 0건 →) |
| WK-SCP0101-0056 | D1 | MEMO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — MEMO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (EditButton (SwitchLock→전체잠금→MEMO unlock)) |
| WK-SCP0101-0057 | D3 | MEMO | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — MEMO · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (EditButton (SwitchLock→전체잠금→MEMO unlock)) |
| WK-SCP0101-0058 | D6 | SCP0101 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0101 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 2 (SaveButton (빈 본문 NO-OP) insert/delete/ma) |
| WK-SCP0101-0059 | E4 | MSG00002 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00002 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (`*` 접미 필수필드(MSG00002)) |
| WK-SCP0101-0060 | E4 | MSG00003 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00003 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0101_InventoryTrend.ExportExcelDa) |
| WK-SCP0101-0061 | E4 | MSG00097 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00097 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (checkRequiredOfSearch — 권한 Division 0건 →) |
| WK-SCP0101-0062 | E4 | MSG00100 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00100 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ExcelButton 조회 0건 확인(MSG00100) ACT:SCP01) |
| WK-SCP0101-0063 | E4 | MSG00667 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00667 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (checkRequiredOfSearch — 권한 Division 0건 →) |
| WK-SCP0101-0064 | E4 | MSG00719 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00719 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ExcelButton 조회 0건 확인(MSG00100)) |
| WK-SCP0101-0065 | E4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 2 (ACT:SCP0101_InventoryTrend.SetChangedCon) |
| WK-SCP0101-0066 | E4 | chkDetail / Detail | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — chkDetail / Detail · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0101_InventoryTrend.SetLayout ACT) |
| WK-SCP0101-0067 | E4 | clbPlant / Plant | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbPlant / Plant · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0101_InventoryTrend.SetChangedCon) |
| WK-SCP0101-0068 | A10 | SCP0101 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0101 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 25 (ACT:SCP0101_InventoryTrend.Form_Load ACT) |
| WK-SCP0101-0069 | A6 | PKG_SCP0101 | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0101 · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 1 (SCP0101_GET_INVENTORY_TREND(Find)) |
| WK-SCP0101-0070 | A6 | PKG_SCP0101.P_SCP0101_GET_INVENTORY_TREN | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0101.P_SCP0101_GET_INVENTORY_TREND · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) |  | 3 (SCP0101_GET_INVENTORY_TREND(Find) ACT:SC) |
| WK-SCP0101-0071 | A6 | SCP0084_GET_MONTH_RANGE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SCP0084_GET_MONTH_RANGE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@tr |  | 1 (SCP0084_GET_MONTH_RANGE(월범위 초기화)) |
| WK-SCP0101-0072 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCP0101_InventoryTrend.InitControls ) |
| WK-SCP0101-0073 | G6 | chkDetail / Detail | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — chkDetail / Detail · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0101_InventoryTrend.InitEvent ACT) |
| WK-SCP0101-0074 | X-REOPEN | SCP0101 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0101 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 7 (ACT:SCP0101_InventoryTrend.Dispose ACT:S) |
| WK-SCP0101-0075 | H6 | txtItem_Id / Material / Item_Id / Meteri | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtItem_Id / Material / Item_Id / Meterial · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (txtItem_Id (UsrMultiLineEditor)) |
| WK-SCP0101-0076 | M4 | txtItem_Id / Material / Item_Id / Meteri | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtItem_Id / Material / Item_Id / Meterial · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (txtItem_Id (UsrMultiLineEditor)) |

## W7 기대값 확정 (74)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0101-0077 | C1 | CboDivision_SelectedIndexChanged → SetCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — CboDivision_SelectedIndexChanged → SetChangedContr: 행 집계 — C1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (CboDivision_SelectedIndexChanged → SetCh) |
| WK-SCP0101-0078 | C1 | MonthPicker_ValueChanged → SetSpreadHead | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — MonthPicker_ValueChanged → SetSpreadHeader: 행 집계 — C1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (MonthPicker_ValueChanged → SetSpreadHead) |
| WK-SCP0101-0079 | C4 | CboDivision_SelectedIndexChanged → SetCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — CboDivision_SelectedIndexChanged → SetChangedContr: 행 집계 — C4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (CboDivision_SelectedIndexChanged → SetCh) |
| WK-SCP0101-0080 | C4 | MonthPicker_ValueChanged → SetSpreadHead | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — MonthPicker_ValueChanged → SetSpreadHeader: 행 집계 — C4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MonthPicker_ValueChanged → SetSpreadHead) |
| WK-SCP0101-0081 | DB-SYN | SCP0101_InventoryTrend.SCM_SYS_LOG_BATCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SCP0101_InventoryTrend.SCM_SYS_LOG_BATCH: 진입점 집계 — DB-SYN 3요소: NOPATH:2 · PASS:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0101_InventoryTrend.SCM_SYS_LOG_B) |
| WK-SCP0101-0082 | F4 | SCP0101_InventoryTrend.SCM_SYS_LOG_BATCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0101_InventoryTrend.SCM_SYS_LOG_BATCH: 진입점 집계 — F4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0101_InventoryTrend.SCM_SYS_LOG_B) |
| WK-SCP0101-0083 | D1 | LockColumn 조회후 전 컬럼 잠금(R7) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — LockColumn 조회후 전 컬럼 잠금(R7): 행 집계 — D1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (LockColumn 조회후 전 컬럼 잠금(R7)) |
| WK-SCP0101-0084 | D1 | SCP0101_InventoryTrend.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SCP0101_InventoryTrend.EditButton: 진입점 집계 — D1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 13 (ACT:SCP0101_InventoryTrend.EditButton:22) |
| WK-SCP0101-0085 | D3 | LockColumn 조회후 전 컬럼 잠금(R7) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — LockColumn 조회후 전 컬럼 잠금(R7): 행 집계 — D3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (LockColumn 조회후 전 컬럼 잠금(R7)) |
| WK-SCP0101-0086 | D3 | SCP0101_InventoryTrend.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SCP0101_InventoryTrend.EditButton: 진입점 집계 — D3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 13 (ACT:SCP0101_InventoryTrend.EditButton:22) |
| WK-SCP0101-0087 | E4 | SCP0101_InventoryTrend.SetBackColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0101_InventoryTrend.SetBackColor: 진입점 집계 — E4 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SCP0101_InventoryTrend.SetBackColor:) |
| WK-SCP0101-0088 | E4 | SCP0101_InventoryTrend.SetCellColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0101_InventoryTrend.SetCellColor: 진입점 집계 — E4 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 17 (ACT:SCP0101_InventoryTrend.SetCellColor:) |
| WK-SCP0101-0089 | E4 | SCP0101_InventoryTrend.SetCellColorOLD | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0101_InventoryTrend.SetCellColorOLD: 진입점 집계 — E4 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 39 (ACT:SCP0101_InventoryTrend.SetCellColorO) |
| WK-SCP0101-0090 | E4 | SCP0101_InventoryTrend.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0101_InventoryTrend.SetChangedControl: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0101-0091 | E4 | SCP0101_InventoryTrend.SetColumnFooterDa | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0101_InventoryTrend.SetColumnFooterData: 진입점 집계 — E4 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0101_InventoryTrend.SetColumnFoot) |
| WK-SCP0101-0092 | E4 | SCP0101_InventoryTrend.SetMonthRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0101_InventoryTrend.SetMonthRange: 진입점 집계 — E4 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0101_InventoryTrend.SetMonthRange) |
| WK-SCP0101-0093 | E4 | SCP0101_InventoryTrend.SetSpreadHeader | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0101_InventoryTrend.SetSpreadHeader: 진입점 집계 — E4 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 19 (ACT:SCP0101_InventoryTrend.SetSpreadHead) |
| WK-SCP0101-0094 | E4 | SCP0101_InventoryTrend.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0101_InventoryTrend.SetSpreadInit: 진입점 집계 — E4 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0101_InventoryTrend.SetSpreadInit) |
| WK-SCP0101-0095 | A1 | (조회 로그성 호출) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — (조회 로그성 호출): 행 집계 — A1 3요소: REVIEW:3 |  | 1 ((조회 로그성 호출)) |
| WK-SCP0101-0096 | A1 | BtnItem_Id_Click → ItembyDivisionPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — BtnItem_Id_Click → ItembyDivisionPopup: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (BtnItem_Id_Click → ItembyDivisionPopup) |
| WK-SCP0101-0097 | A1 | CboDivision_SelectedIndexChanged → SetCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CboDivision_SelectedIndexChanged → SetChangedContr: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (CboDivision_SelectedIndexChanged → SetCh) |
| WK-SCP0101-0098 | A1 | ExcelButton 조회 0건 확인(MSG00100) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — ExcelButton 조회 0건 확인(MSG00100): 행 집계 — A1 3요소: REVIEW:3 |  | 1 (ExcelButton 조회 0건 확인(MSG00100)) |
| WK-SCP0101-0099 | A1 | FindButton → Find_Data | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindButton → Find_Data: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (FindButton → Find_Data) |
| WK-SCP0101-0100 | A1 | LockColumn 조회후 전 컬럼 잠금(R7) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — LockColumn 조회후 전 컬럼 잠금(R7): 행 집계 — A1 3요소: REVIEW:3 |  | 1 (LockColumn 조회후 전 컬럼 잠금(R7)) |
| WK-SCP0101-0101 | A1 | MonthPicker_ValueChanged → SetSpreadHead | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — MonthPicker_ValueChanged → SetSpreadHeader: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (MonthPicker_ValueChanged → SetSpreadHead) |
| WK-SCP0101-0102 | A1 | PKG_SCP0101 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0101: 골든 비교 케이스 없음(PKG_SCP0101 — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (SCP0101_GET_INVENTORY_TREND(Find)) |
| WK-SCP0101-0103 | A1 | PKG_SCP0101.P_SCP0101_GET_INVENTORY_TREN | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0101.P_SCP0101_GET_INVENTORY_TREND: 골든 비교 케이스 없음(PKG_SCP0101.P_SCP0101_GET_INVENTORY_TREND — 팝업·보조 SP 는 golden_ |  | 4 (SCP0101_GET_INVENTORY_TREND(Find) ACT:SC) |
| WK-SCP0101-0104 | A1 | SCP0084_GET_MONTH_RANGE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0084_GET_MONTH_RANGE: 골든 비교 케이스 없음(SCP0084_GET_MONTH_RANGE — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (SCP0084_GET_MONTH_RANGE(월범위 초기화)) |
| WK-SCP0101-0105 | A1 | checkRequiredOfSearch — 권한 Division 0건 → | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — checkRequiredOfSearch — 권한 Division 0건 → 권한없음 조회차단: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (checkRequiredOfSearch — 권한 Division 0건 →) |
| WK-SCP0101-0106 | X-LOC | EditButton (SwitchLock→전체잠금→MEMO unlock) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — EditButton (SwitchLock→전체잠금→MEMO unlock): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (EditButton (SwitchLock→전체잠금→MEMO unlock)) |
| WK-SCP0101-0107 | X-LOC | ExcelButton → ExportExcelData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ExcelButton → ExportExcelData: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (ExcelButton → ExportExcelData) |
| WK-SCP0101-0108 | X-LOC | FindButton → Find_Data | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — FindButton → Find_Data: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (FindButton → Find_Data) |
| WK-SCP0101-0109 | X-LOC | SaveButton (빈 본문 NO-OP) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SaveButton (빈 본문 NO-OP): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SaveButton (빈 본문 NO-OP)) |
| WK-SCP0101-0110 | X-LOC | insert/delete/manual/upload | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — insert/delete/manual/upload: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (insert/delete/manual/upload) |
| WK-SCP0101-0111 | X-ROW | ExcelButton → ExportExcelData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — ExcelButton → ExportExcelData: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (ExcelButton → ExportExcelData) |
| WK-SCP0101-0112 | X-ROW | SCP0101_InventoryTrend.BtnColumn_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0101_InventoryTrend.BtnColumn_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0101_InventoryTrend.BtnColumn_Cli) |
| WK-SCP0101-0113 | X-ROW | SCP0101_InventoryTrend.BtnItem_Id_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0101_InventoryTrend.BtnItem_Id_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0101_InventoryTrend.BtnItem_Id_Cl) |
| WK-SCP0101-0114 | X-ROW | SCP0101_InventoryTrend.CboDivision_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0101_InventoryTrend.CboDivision_SelectedIndexCh: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0101_InventoryTrend.CboDivision_S) |
| WK-SCP0101-0115 | X-ROW | SCP0101_InventoryTrend.ChkDetail_Checked | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0101_InventoryTrend.ChkDetail_CheckedChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0101_InventoryTrend.ChkDetail_Che) |
| WK-SCP0101-0116 | X-ROW | SCP0101_InventoryTrend.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0101_InventoryTrend.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0101_InventoryTrend.CreateSpread) |
| WK-SCP0101-0117 | X-ROW | SCP0101_InventoryTrend.ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0101_InventoryTrend.ExcelButton: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SCP0101_InventoryTrend.ExcelButton A) |
| WK-SCP0101-0118 | X-ROW | SCP0101_InventoryTrend.ExportExcelData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0101_InventoryTrend.ExportExcelData: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 105 (ACT:SCP0101_InventoryTrend.ExportExcelDa) |
| WK-SCP0101-0119 | X-ROW | SCP0101_InventoryTrend.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0101_InventoryTrend.FindButton: 진입점 집계 3검사 — NOT_RUN:2 · REVIEW:1 |  | 1 (ACT:SCP0101_InventoryTrend.FindButton) |
| WK-SCP0101-0120 | X-ROW | SCP0101_InventoryTrend.Find_Data | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0101_InventoryTrend.Find_Data: 진입점 집계 5검사 — NOT_RUN:3 · PASS:1 · REVIEW:1 |  | 38 (ACT:SCP0101_InventoryTrend.Find_Data ACT) |
| WK-SCP0101-0121 | X-ROW | SCP0101_InventoryTrend.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0101_InventoryTrend.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0101_InventoryTrend.Form_Load) |
| WK-SCP0101-0122 | X-ROW | SCP0101_InventoryTrend.GetMonthRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0101_InventoryTrend.GetMonthRange: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0101_InventoryTrend.GetMonthRange) |
| WK-SCP0101-0123 | X-ROW | SCP0101_InventoryTrend.GetToday | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0101_InventoryTrend.GetToday: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0101_InventoryTrend.GetToday) |
| WK-SCP0101-0124 | X-ROW | SCP0101_InventoryTrend.GetYYMM | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0101_InventoryTrend.GetYYMM: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0101_InventoryTrend.GetYYMM) |
| WK-SCP0101-0125 | X-ROW | SCP0101_InventoryTrend.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0101_InventoryTrend.InitControls: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0101_InventoryTrend.InitControls:) |
| WK-SCP0101-0126 | X-ROW | SCP0101_InventoryTrend.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0101_InventoryTrend.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0101_InventoryTrend.InitSpread) |
| WK-SCP0101-0127 | X-ROW | SCP0101_InventoryTrend.MonthPicker_Value | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0101_InventoryTrend.MonthPicker_ValueChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0101_InventoryTrend.MonthPicker_V) |
| WK-SCP0101-0128 | X-ROW | SCP0101_InventoryTrend.SCM_SYS_LOG_BATCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0101_InventoryTrend.SCM_SYS_LOG_BATCH: 진입점 집계 3검사 — NOT_RUN:2 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 12 (ACT:SCP0101_InventoryTrend.SCM_SYS_LOG_B) |
| WK-SCP0101-0129 | X-ROW | SCP0101_InventoryTrend.SetBackColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0101_InventoryTrend.SetBackColor: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0101_InventoryTrend.SetBackColor ) |
| WK-SCP0101-0130 | X-ROW | SCP0101_InventoryTrend.SetCellColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0101_InventoryTrend.SetCellColor: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 16 (ACT:SCP0101_InventoryTrend.SetCellColor ) |
| WK-SCP0101-0131 | X-ROW | SCP0101_InventoryTrend.SetCellColorOLD | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0101_InventoryTrend.SetCellColorOLD: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0101_InventoryTrend.SetCellColorO) |
| WK-SCP0101-0132 | X-ROW | SCP0101_InventoryTrend.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0101_InventoryTrend.SetChangedControl: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0101_InventoryTrend.SetChangedCon) |
| WK-SCP0101-0133 | X-ROW | SCP0101_InventoryTrend.SetColumnFooterDa | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0101_InventoryTrend.SetColumnFooterData: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SCP0101_InventoryTrend.SetColumnFoot) |
| WK-SCP0101-0134 | X-ROW | SCP0101_InventoryTrend.SetLayout | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0101_InventoryTrend.SetLayout: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 23 (ACT:SCP0101_InventoryTrend.SetLayout ACT) |
| WK-SCP0101-0135 | X-ROW | SCP0101_InventoryTrend.SetMonthRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0101_InventoryTrend.SetMonthRange: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0101_InventoryTrend.SetMonthRange) |
| WK-SCP0101-0136 | X-ROW | SCP0101_InventoryTrend.SetSpreadHeader | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0101_InventoryTrend.SetSpreadHeader: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 12 (ACT:SCP0101_InventoryTrend.SetSpreadHead) |
| WK-SCP0101-0137 | X-ROW | SCP0101_InventoryTrend.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0101_InventoryTrend.SetSpreadInit: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0101_InventoryTrend.SetSpreadInit) |
| WK-SCP0101-0138 | X-ROW | SetSpreadHeader — INV_STATUS row0="{focu | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SetSpreadHeader — INV_STATUS row0="{focus월} Invent: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (SetSpreadHeader — INV_STATUS row0="{focu) |
| WK-SCP0101-0139 | X-ROW | SetSpreadHeader — LONG_TERM_STOCK_AMOUNT | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SetSpreadHeader — LONG_TERM_STOCK_AMOUNT row1=focu: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (SetSpreadHeader — LONG_TERM_STOCK_AMOUNT) |
| WK-SCP0101-0140 | X-ROW | SetSpreadHeader — QTY_MONTH1..5 = -5..-1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SetSpreadHeader — QTY_MONTH1..5 = -5..-1개월 yy.MM: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (SetSpreadHeader — QTY_MONTH1..5 = -5..-1) |
| WK-SCP0101-0141 | X-ROW | SetSpreadHeader — QTY_MONTH_FOCUS = 선택월  | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SetSpreadHeader — QTY_MONTH_FOCUS = 선택월 yy.MM + Re: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (SetSpreadHeader — QTY_MONTH_FOCUS = 선택월 ) |
| WK-SCP0101-0142 | X-ROW | btnItem_Id (UsrButton) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — btnItem_Id (UsrButton): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (btnItem_Id (UsrButton)) |
| WK-SCP0101-0143 | X-ROW | cboDivision (UsrCheckedList2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — cboDivision (UsrCheckedList2): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (cboDivision (UsrCheckedList2)) |
| WK-SCP0101-0144 | X-ROW | clbPlant (UsrCheckedList2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — clbPlant (UsrCheckedList2): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (clbPlant (UsrCheckedList2)) |
| WK-SCP0101-0145 | X-ROW | emptySpaceItem1/2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — emptySpaceItem1/2: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (emptySpaceItem1/2) |
| WK-SCP0101-0146 | X-ROW | emptySpaceItem6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — emptySpaceItem6: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (emptySpaceItem6) |
| WK-SCP0101-0147 | X-ROW | monthPicker (UsrMonthPicker) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — monthPicker (UsrMonthPicker): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (monthPicker (UsrMonthPicker)) |
| WK-SCP0101-0148 | G5 | BtnItem_Id_Click → ItembyDivisionPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — BtnItem_Id_Click → ItembyDivisionPopup: 행 집계 — G5 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (BtnItem_Id_Click → ItembyDivisionPopup) |
| WK-SCP0101-0149 | H6 | BtnItem_Id_Click → ItembyDivisionPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — BtnItem_Id_Click → ItembyDivisionPopup: 행 집계 — H6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (BtnItem_Id_Click → ItembyDivisionPopup) |
| WK-SCP0101-0150 | M4 | BtnItem_Id_Click → ItembyDivisionPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — BtnItem_Id_Click → ItembyDivisionPopup: 행 집계 — M4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (BtnItem_Id_Click → ItembyDivisionPopup) |
