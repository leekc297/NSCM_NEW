# 작업 원장 — SCP0033 · 2026-10-26 12:53

> 검사 인스턴스 407건 중 PASS·NA 77건 외 **330건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 37 | 구현 위치 실존 |
| W3 | 동작 수정 | 1 | 재판정 PASS |
| W4 | 검사기 구현 | 3 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 33 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 88 | 실행 → PASS |
| W7 | 기대값 확정 | 168 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 166 · E2E 88 · 대조표 39 · 하네스 36 · DB 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-LOC | GEN |  | 37 |  |  |  |  |  |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-ROW | GEN |  |  |  |  |  |  | 29 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| H2 | DESIGN |  |  |  |  |  | 4 | 15 |  |  | 배경·글자색 규칙 |
| D3 | EDIT |  |  |  |  |  | 8 | 11 |  |  | 행 값 기반 조건부 잠금 |
| D1 | EDIT |  |  |  |  |  | 8 | 10 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| G1 | GEN |  |  |  |  |  | 3 | 15 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| A5 | DESIGN |  |  |  |  |  | 5 | 12 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| E4 | EDIT |  |  |  |  |  | 13 | 4 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| A1 | GEN |  |  |  |  |  |  | 17 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| H5 | DESIGN |  |  |  |  |  | 4 | 12 |  |  | 라벨 명칭 |
| D4 | EDIT |  |  |  |  |  | 7 | 5 |  |  | 신규행 기본값·자동세팅·Insert 전제 |
| G5 | POPUP |  |  |  |  | 4 |  | 7 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 2 | 2 | 7 |  |  | 팝업 표준·열림 |
| M4 | POPUP |  |  |  |  |  | 4 | 7 |  |  | 팝업 선택값 반영 |
| G4 | DESIGN |  |  |  |  |  | 3 | 4 |  |  | 조회조건 표시·라벨·활성 |
| G6 | GEN |  |  |  |  |  | 3 | 4 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| B1 | COMBO |  |  |  |  | 6 |  |  |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 6 |  |  |  |  | 콤보 후보 중복 없음 |
| B4 | COMBO |  |  |  |  | 6 |  |  |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| D5 | EDIT |  |  |  |  |  | 4 | 1 |  |  | 셀 에디터 유형 |
| E5 | EDIT |  |  |  |  | 4 |  |  |  |  | 콤보 셀 후보 외 값 차단 |
| F4 | DB |  |  |  |  |  | 2 | 2 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| H3 | DESIGN |  |  |  |  |  | 1 | 3 |  |  | 셀 병합 = AS-IS |
| B3 | COMBO |  |  |  | 3 |  |  |  |  |  | 콤보 후보 정렬 = AS-IS |
| B6 | COMBO |  |  |  |  | 2 |  |  |  |  | ALL 옵션·다중선택 사양 |
| C1 | CASCADE |  |  |  |  |  | 2 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| C3 | CASCADE |  |  |  |  |  | 2 |  |  |  | 연쇄 자동 채움 |
| A6 | GEN |  |  |  |  |  | 1 | 1 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| X-REASON | DESIGN |  |  |  |  |  |  | 2 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| H10 | DESIGN |  |  | 1 |  |  |  |  |  |  | 메시지 표준(방식·코드 단일화) |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
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

## W2 구현 위치 확인 (37)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0033-0001 | X-LOC | 1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (1) |
| WK-SCP0033-0002 | X-LOC | 1,2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (1,2) |
| WK-SCP0033-0003 | X-LOC | 11 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (11) |
| WK-SCP0033-0004 | X-LOC | 12 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (12) |
| WK-SCP0033-0005 | X-LOC | 13 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (13) |
| WK-SCP0033-0006 | X-LOC | 14 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (14) |
| WK-SCP0033-0007 | X-LOC | 15 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (15) |
| WK-SCP0033-0008 | X-LOC | 16,17 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (16,17) |
| WK-SCP0033-0009 | X-LOC | 2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (2) |
| WK-SCP0033-0010 | X-LOC | 3 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (3) |
| WK-SCP0033-0011 | X-LOC | 4 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (4) |
| WK-SCP0033-0012 | X-LOC | 5 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (5) |
| WK-SCP0033-0013 | X-LOC | 6 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (6) |
| WK-SCP0033-0014 | X-LOC | 7 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (7) |
| WK-SCP0033-0015 | X-LOC | 8 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (8) |
| WK-SCP0033-0016 | X-LOC | 8,9,10 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (8,9,10) |
| WK-SCP0033-0017 | X-LOC | CString.GetCheckedListValue | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (CString.GetCheckedListValue) |
| WK-SCP0033-0018 | X-LOC | FindButton/SaveButton/DeleteButton/Inser | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (FindButton/SaveButton/DeleteButton/Inser) |
| WK-SCP0033-0019 | X-LOC | GetAllDivisionCheckedElectrode(clbDivisi | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (GetAllDivisionCheckedElectrode(clbDivisi) |
| WK-SCP0033-0020 | X-LOC | MODAL:ItemByDivisionModal | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: ItemByDivisionModal.tsx 없음, ItemByDivisionModal.tsx 없음, ItemByDivisionModal.tsx 없음 |  | 1 (MODAL:ItemByDivisionModal) |
| WK-SCP0033-0021 | X-LOC | SCM0002_ItembyDivisionPopup | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SCM0002_ItembyDivisionPopup) |
| WK-SCP0033-0022 | X-LOC | SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY (Tabl | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY (Tabl) |
| WK-SCP0033-0023 | X-LOC | SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY (^-d | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY (^-d) |
| WK-SCP0033-0024 | X-LOC | VALID_YN AS S_VALUE_YN (별칭 오타 §6-D) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (VALID_YN AS S_VALUE_YN (별칭 오타 §6-D)) |
| WK-SCP0033-0025 | X-LOC | cboValidYN (UsrCombo) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cboValidYN (UsrCombo)) |
| WK-SCP0033-0026 | X-LOC | clbDivision (UsrCheckedList) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (clbDivision (UsrCheckedList)) |
| WK-SCP0033-0027 | X-LOC | dsValiChkBinding = GET Table[1] | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (dsValiChkBinding = GET Table[1]) |
| WK-SCP0033-0028 | X-LOC | emptySpaceItem3 / components / imageList | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (emptySpaceItem3 / components / imageList) |
| WK-SCP0033-0029 | X-LOC | layoutControlItem3/4/13 (라벨) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (layoutControlItem3/4/13 (라벨)) |
| WK-SCP0033-0030 | X-LOC | popItem (SCM0002_ItembyDivisionPopup) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (popItem (SCM0002_ItembyDivisionPopup)) |
| WK-SCP0033-0031 | X-LOC | prg (ProgressForm) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (prg (ProgressForm)) |
| WK-SCP0033-0032 | X-LOC | spdMain (FpSpread) / spdMain_Sheet1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (spdMain (FpSpread) / spdMain_Sheet1) |
| WK-SCP0033-0033 | X-LOC | txtItemId (TextBox, "Model") | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (txtItemId (TextBox, "Model")) |
| WK-SCP0033-0034 | X-LOC | usrConditionPanel1 (HidePanel) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (usrConditionPanel1 (HidePanel)) |
| WK-SCP0033-0035 | X-LOC | usrLayoutControl1 / layoutControlGroup1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (usrLayoutControl1 / layoutControlGroup1) |
| WK-SCP0033-0036 | X-LOC | usrLayoutControl2 + SetDivisionAuthCheck | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (usrLayoutControl2 + SetDivisionAuthCheck) |
| WK-SCP0033-0037 | X-LOC | — | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (—) |

## W3 동작 수정 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0033-0038 | H10 | SCP0033 화면 | DB(🛠️/🧯 적용 가능) | H10 FAIL 수정 — SCP0033 화면: 표준 메시지 대신 브라우저 alert/confirm 직접 호출: components/ShipmentSemiDeptDayGrid.tsx |  | 24 (D00-1-011 D00-4e-001 D00-4e-002 D00-4e-0) |

## W4 검사기 구현 (3)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0033-0039 | B3 | DEPARTURE_DAY | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 DEPARTURE_DAY | 있음(SHEET_COLUMNS) | 1 (D00-4b-002) |
| WK-SCP0033-0040 | B3 | DIVISION_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 DIVISION_ID | 있음(SHEET_COLUMNS) | 1 (D00-4b-001) |
| WK-SCP0033-0041 | B3 | VALID_YN | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 VALID_YN | 있음(SHEET_COLUMNS) | 1 (D00-4b-003) |

## W5 검사기 연결 (33)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0033-0042 | B1 | DEPARTURE_DAY | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL DEPARTURE_DAY | 있음(SHEET_COLUMNS) | 2 (D00-4b-002 COMMON:UC-05) |
| WK-SCP0033-0043 | B1 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 4 (D00-3-006 D00-4b-001 COMMON:UC-05 ACT:SC) |
| WK-SCP0033-0044 | B1 | OPERATION_GROUP | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL OPERATION_GROUP | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0033-0045 | B1 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 2 (D00-4b-003 COMMON:UC-05) |
| WK-SCP0033-0046 | B1 | cboValidYN / Valid / Valid YN / Active | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboValidYN / Valid / Valid YN / Active | 있음(FE 소스) | 1 (D00-1-003) |
| WK-SCP0033-0047 | B1 | clbDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbDivision / Division | 있음(FE 소스) | 1 (D00-1-001) |
| WK-SCP0033-0048 | B2 | DEPARTURE_DAY | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL DEPARTURE_DAY | 있음(SHEET_COLUMNS) | 2 (D00-4b-002 COMMON:UC-05) |
| WK-SCP0033-0049 | B2 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 4 (D00-3-006 D00-4b-001 COMMON:UC-05 ACT:SC) |
| WK-SCP0033-0050 | B2 | OPERATION_GROUP | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL OPERATION_GROUP | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0033-0051 | B2 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 2 (D00-4b-003 COMMON:UC-05) |
| WK-SCP0033-0052 | B2 | cboValidYN / Valid / Valid YN / Active | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboValidYN / Valid / Valid YN / Active | 있음(FE 소스) | 1 (D00-1-003) |
| WK-SCP0033-0053 | B2 | clbDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbDivision / Division | 있음(FE 소스) | 1 (D00-1-001) |
| WK-SCP0033-0054 | B4 | DEPARTURE_DAY | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DEPARTURE_DAY | 있음(SHEET_COLUMNS) | 2 (D00-4b-002 COMMON:UC-05) |
| WK-SCP0033-0055 | B4 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 4 (D00-3-006 D00-4b-001 COMMON:UC-05 ACT:SC) |
| WK-SCP0033-0056 | B4 | OPERATION_GROUP | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL OPERATION_GROUP | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0033-0057 | B4 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 2 (D00-4b-003 COMMON:UC-05) |
| WK-SCP0033-0058 | B4 | cboValidYN / Valid / Valid YN / Active | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboValidYN / Valid / Valid YN / Active | 있음(FE 소스) | 1 (D00-1-003) |
| WK-SCP0033-0059 | B4 | clbDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbDivision / Division | 있음(FE 소스) | 1 (D00-1-001) |
| WK-SCP0033-0060 | B6 | cboValidYN / Valid / Valid YN / Active | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboValidYN / Valid / Valid YN / Active | 있음(FE 소스) | 1 (D00-1-003) |
| WK-SCP0033-0061 | B6 | clbDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbDivision / Division | 있음(FE 소스) | 1 (D00-1-001) |
| WK-SCP0033-0062 | F2 | SCP0033 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0033 화면 | 판단불가(대상 단위 SCREEN) | 80 (D00-4e-003 D00-4e-004 D00-4e-005 D00-4e-) |
| WK-SCP0033-0063 | F6 | SCP0033 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0033 화면 | 판단불가(대상 단위 SCREEN) | 71 (D00-4e-005 SCP0033_SAVE_SHIPMENT_SEMI_DE) |
| WK-SCP0033-0064 | E5 | DEPARTURE_DAY | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL DEPARTURE_DAY | 있음(SHEET_COLUMNS) | 2 (D00-4b-002 COMMON:UC-05) |
| WK-SCP0033-0065 | E5 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 3 (D00-3-006 D00-4b-001 COMMON:UC-05) |
| WK-SCP0033-0066 | E5 | OPERATION_GROUP | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL OPERATION_GROUP | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0033-0067 | E5 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 2 (D00-4b-003 COMMON:UC-05) |
| WK-SCP0033-0068 | G03-WIRE | SCP0033 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0033 화면 | 판단불가(대상 단위 SCREEN) | 7 (ACT:SCP0033_Shipment_semi_dept_day..ctor) |
| WK-SCP0033-0069 | G5 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 9 (D00-2-002 D00-3-016 D00-4d-003 MODAL:Sho) |
| WK-SCP0033-0070 | G5 | NICK_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL NICK_NAME | 있음(SHEET_COLUMNS) | 3 (D00-3-017 MODAL:ShowDialog 16,17) |
| WK-SCP0033-0071 | G5 | clbDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND clbDivision / Division | 있음(FE 소스) | 1 (GetAllDivisionCheckedElectrode(clbDivisi) |
| WK-SCP0033-0072 | G5 | txtItemId / Model / Item Id / Model/Nick | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND txtItemId / Model / Item Id / Model/Nickname | 있음(FE 소스) | 1 (txtItemId (TextBox, "Model")) |
| WK-SCP0033-0073 | H6 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 9 (D00-2-002 D00-3-016 D00-4d-003 MODAL:Sho) |
| WK-SCP0033-0074 | H6 | NICK_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL NICK_NAME | 있음(SHEET_COLUMNS) | 3 (D00-3-017 MODAL:ShowDialog 16,17) |

## W6 검증 실행 (88)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0033-0075 | J2 | SCP0033 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0033 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 39 (D00-1-002 D00-1-011 D00-2-001 D00-2-002 ) |
| WK-SCP0033-0076 | C1 | cboValidYN / Valid / Valid YN / Active | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboValidYN / Valid / Valid YN / Active · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0033_Shipment_semi_dept_day.InitC) |
| WK-SCP0033-0077 | C1 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0033_Shipment_semi_dept_day.InitC) |
| WK-SCP0033-0078 | C3 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (D00-3-016 ACT:SCP0033_Shipment_semi_dept) |
| WK-SCP0033-0079 | C3 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (D00-3-017 ACT:SCP0033_Shipment_semi_dept) |
| WK-SCP0033-0080 | G3 | SCP0033 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0033 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 7 (D00-1-004 COMMON:UC-01 COMMON:UC-02 COMM) |
| WK-SCP0033-0081 | K-SA | SCP0033 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCP0033 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 3 (D00-1-004 COMMON:UC-02 usrConditionPanel) |
| WK-SCP0033-0082 | K4 | SCP0033 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0033 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 5 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-04 C) |
| WK-SCP0033-0083 | F1 | SCP0033 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0033 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 87 (D00-3-004 D00-4d-001 D00-4e-003 D00-4e-0) |
| WK-SCP0033-0084 | F5 | SCP0033 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0033 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 8 (D00-3-004 D00-4d-001 FindButton/SaveButt) |
| WK-SCP0033-0085 | F4 | PKG_SCP0033.P_SCP0033_GET_SHIPMENT_SEMI_ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0033.P_SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP))  |  | 104 (SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY (Tabl) |
| WK-SCP0033-0086 | F4 | PKG_SCP0033.P_SCP0033_SAVE_SHIPMENT_SEMI | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0033.P_SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) |  | 70 (SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY (^-d) |
| WK-SCP0033-0087 | A5 | DEPARTURE_DAY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DEPARTURE_DAY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (COMMON:UC-05) |
| WK-SCP0033-0088 | A5 | DIVISION_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (COMMON:UC-05) |
| WK-SCP0033-0089 | A5 | ITEM_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:SCP0033_Shipment_semi_dept_day.SpdMa) |
| WK-SCP0033-0090 | A5 | OPERATION_GROUP | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — OPERATION_GROUP · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (COMMON:UC-05) |
| WK-SCP0033-0091 | A5 | VALID_YN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (D00-4b-003 COMMON:UC-05) |
| WK-SCP0033-0092 | G4 | cboValidYN / Valid / Valid YN / Active | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboValidYN / Valid / Valid YN / Active · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-003 ACT:SCP0033_Shipment_semi_dept) |
| WK-SCP0033-0093 | G4 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-001 ACT:SCP0033_Shipment_semi_dept) |
| WK-SCP0033-0094 | G4 | txtItemId / Model / Item Id / Model/Nick | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-002) |
| WK-SCP0033-0095 | H2 | DEPARTURE_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DEPARTURE_DAY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (COMMON:UC-05) |
| WK-SCP0033-0096 | H2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (COMMON:UC-05 1,2) |
| WK-SCP0033-0097 | H2 | OPERATION_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — OPERATION_GROUP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (COMMON:UC-05) |
| WK-SCP0033-0098 | H2 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (D00-4b-003 COMMON:UC-05) |
| WK-SCP0033-0099 | H3 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | H3 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4b 셀 병합 — 컬럼 allowMerging 실측 ↔ AS-IS SmartColMerge 대상) — 실행 필요: trace |  | 2 (D00-3-002 1,2) |
| WK-SCP0033-0100 | H4 | SCP0033 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — SCP0033 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 7 (D00-2-003 D00-3-001 1,2 ACT:SCP0033_Ship) |
| WK-SCP0033-0101 | H5 | DEPARTURE_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — DEPARTURE_DAY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (COMMON:UC-05) |
| WK-SCP0033-0102 | H5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — DIVISION_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (COMMON:UC-05) |
| WK-SCP0033-0103 | H5 | OPERATION_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — OPERATION_GROUP · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (COMMON:UC-05) |
| WK-SCP0033-0104 | H5 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — VALID_YN · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (D00-4b-003 COMMON:UC-05) |
| WK-SCP0033-0105 | I1 | SCP0033 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0033 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 29 (D00-1-011 D00-4e-001 D00-4e-002 D00-4e-0) |
| WK-SCP0033-0106 | SC1 | SCP0033 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SCP0033 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 7 (D00-1-001 D00-1-002 D00-1-003 D00-1-004 ) |
| WK-SCP0033-0107 | D1 | CREATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CREATED_BY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 7 (D00-3-010 D00-3-013 8,9,10 13 ACT:SCP003) |
| WK-SCP0033-0108 | D1 | DEPARTURE_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DEPARTURE_DAY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (D00-3-012 12) |
| WK-SCP0033-0109 | D1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (D00-3-012 12 ACT:SCP0033_Shipment_semi_d) |
| WK-SCP0033-0110 | D1 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (D00-2-002 D00-4d-003) |
| WK-SCP0033-0111 | D1 | LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 6 (D00-3-010 D00-3-013 8,9,10 13 ACT:SCP003) |
| WK-SCP0033-0112 | D1 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 6 (D00-3-009 D00-3-012 8,9,10 12 ACT:SCP003) |
| WK-SCP0033-0113 | D1 | OPERATION_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — OPERATION_GROUP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (D00-3-008 8,9,10 ACT:SCP0033_Shipment_se) |
| WK-SCP0033-0114 | D1 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (D00-3-012 12) |
| WK-SCP0033-0115 | D3 | CREATED_BY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CREATED_BY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 7 (D00-3-010 D00-3-013 8,9,10 13 ACT:SCP003) |
| WK-SCP0033-0116 | D3 | DEPARTURE_DAY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DEPARTURE_DAY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (D00-3-012 12) |
| WK-SCP0033-0117 | D3 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (D00-3-012 12 ACT:SCP0033_Shipment_semi_d) |
| WK-SCP0033-0118 | D3 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (D00-2-002 D00-4d-003) |
| WK-SCP0033-0119 | D3 | LAST_UPDATE_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LAST_UPDATE_DATE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 6 (D00-3-010 D00-3-013 8,9,10 13 ACT:SCP003) |
| WK-SCP0033-0120 | D3 | NICK_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — NICK_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 6 (D00-3-009 D00-3-012 8,9,10 12 ACT:SCP003) |
| WK-SCP0033-0121 | D3 | OPERATION_GROUP | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — OPERATION_GROUP · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (D00-3-008 8,9,10 ACT:SCP0033_Shipment_se) |
| WK-SCP0033-0122 | D3 | VALID_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — VALID_YN · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (D00-3-012 12) |
| WK-SCP0033-0123 | D4 | CREATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — CREATED_BY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 2 (ACT:SCP0033_Shipment_semi_dept_day.Inser) |
| WK-SCP0033-0124 | D4 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 2 (ACT:SCP0033_Shipment_semi_dept_day.Inser) |
| WK-SCP0033-0125 | D4 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 2 (D00-3-016 16,17) |
| WK-SCP0033-0126 | D4 | LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (ACT:SCP0033_Shipment_semi_dept_day.Inser) |
| WK-SCP0033-0127 | D4 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 4 (D00-3-017 16,17 ACT:SCP0033_Shipment_sem) |
| WK-SCP0033-0128 | D4 | OPERATION_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — OPERATION_GROUP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 2 (ACT:SCP0033_Shipment_semi_dept_day.Inser) |
| WK-SCP0033-0129 | D4 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 3 (D00-3-007 ACT:SCP0033_Shipment_semi_dept) |
| WK-SCP0033-0130 | D5 | DEPARTURE_DAY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — DEPARTURE_DAY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (D00-4b-002 COMMON:UC-05) |
| WK-SCP0033-0131 | D5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (D00-3-006 D00-4b-001 COMMON:UC-05 ACT:SC) |
| WK-SCP0033-0132 | D5 | OPERATION_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — OPERATION_GROUP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (COMMON:UC-05) |
| WK-SCP0033-0133 | D5 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (D00-4b-003 COMMON:UC-05) |
| WK-SCP0033-0134 | D6 | SCP0033 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0033 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 17 (D00-3-005 D00-3-007 D00-4e-004 COMMON:UC) |
| WK-SCP0033-0135 | E4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (6 —) |
| WK-SCP0033-0136 | E4 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (D00-4e-007 6 — ACT:SCP0033_Shipment_semi) |
| WK-SCP0033-0137 | E4 | MSG00003 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00003 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (D00-4e-004) |
| WK-SCP0033-0138 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (D00-4e-002 D00-4e-003 2 3 ACT:SCP0033_Sh) |
| WK-SCP0033-0139 | E4 | MSG00006 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00006 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (D00-4e-004 4 ACT:SCP0033_Shipment_semi_d) |
| WK-SCP0033-0140 | E4 | MSG00059 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00059 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (D00-4e-002 2 ACT:SCP0033_Shipment_semi_d) |
| WK-SCP0033-0141 | E4 | MSG00060 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00060 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 6 (D00-4e-007 D00-4e-008 7 8 ACT:SCP0033_Sh) |
| WK-SCP0033-0142 | E4 | MSG00093 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00093 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (D00-4e-006 6 ACT:SCP0033_Shipment_semi_d) |
| WK-SCP0033-0143 | E4 | MSG00097 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00097 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (D00-4e-006 usrLayoutControl2 + SetDivisi) |
| WK-SCP0033-0144 | E4 | MSG00429 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00429 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (—) |
| WK-SCP0033-0145 | E4 | MSG00667 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00667 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (D00-1-011 usrLayoutControl2 + SetDivisio) |
| WK-SCP0033-0146 | E4 | MSG00672 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00672 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (D00-4e-003 COMMON:UC-04 3) |
| WK-SCP0033-0147 | E4 | MSG00703 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00703 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-02) |
| WK-SCP0033-0148 | A10 | SCP0033 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0033 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 20 (ACT:SCP0033_Shipment_semi_dept_day.Form_) |
| WK-SCP0033-0149 | A6 | PKG_SCP0033.P_SCP0033_GET_SHIPMENT_SEMI_ | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0033.P_SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE |  | 37 (SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY (Tabl) |
| WK-SCP0033-0150 | G1 | cboValidYN / Valid / Valid YN / Active | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboValidYN / Valid / Valid YN / Active · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-003 ACT:SCP0033_Shipment_semi_dept) |
| WK-SCP0033-0151 | G1 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 5 (D00-1-001 GetAllDivisionCheckedElectrode) |
| WK-SCP0033-0152 | G1 | txtItemId / Model / Item Id / Model/Nick | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-002 ACT:SCP0033_Shipment_semi_dept) |
| WK-SCP0033-0153 | G6 | cboValidYN / Valid / Valid YN / Active | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboValidYN / Valid / Valid YN / Active · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-003 ACT:SCP0033_Shipment_semi_dept) |
| WK-SCP0033-0154 | G6 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-001 ACT:SCP0033_Shipment_semi_dept) |
| WK-SCP0033-0155 | G6 | txtItemId / Model / Item Id / Model/Nick | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-002) |
| WK-SCP0033-0156 | X-REOPEN | SCP0033 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0033 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 6 (ACT:SCP0033_Shipment_semi_dept_day.Dispo) |
| WK-SCP0033-0157 | H6 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — clbDivision / Division · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (GetAllDivisionCheckedElectrode(clbDivisi) |
| WK-SCP0033-0158 | H6 | txtItemId / Model / Item Id / Model/Nick | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (txtItemId (TextBox, "Model")) |
| WK-SCP0033-0159 | M4 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 6 (D00-2-002 D00-3-016 D00-4d-003 MODAL:Sho) |
| WK-SCP0033-0160 | M4 | NICK_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — NICK_NAME · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (D00-3-017 MODAL:ShowDialog 16,17) |
| WK-SCP0033-0161 | M4 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (GetAllDivisionCheckedElectrode(clbDivisi) |
| WK-SCP0033-0162 | M4 | txtItemId / Model / Item Id / Model/Nick | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (txtItemId (TextBox, "Model")) |

## W7 기대값 확정 (168)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0033-0163 | F4 | D00-4e-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — D00-4e-001: 행 집계 — F4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-001) |
| WK-SCP0033-0164 | F4 | D00-4e-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — D00-4e-005: 행 집계 — F4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-005) |
| WK-SCP0033-0165 | A5 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 3: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0033-0166 | A5 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 8: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (8) |
| WK-SCP0033-0167 | A5 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-01: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SCP0033-0168 | A5 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-02: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0033-0169 | A5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-07: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0033-0170 | A5 | D00-1-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-013: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-013) |
| WK-SCP0033-0171 | A5 | D00-1-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-014: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-014) |
| WK-SCP0033-0172 | A5 | D00-4d-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-4d-004: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-004) |
| WK-SCP0033-0173 | A5 | D00-4e-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-4e-008: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-008) |
| WK-SCP0033-0174 | A5 | SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY (Tabl | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY (Table[0] 그리드 /: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY (Tabl) |
| WK-SCP0033-0175 | A5 | SCP0033_Shipment_semi_dept_day.CreateSpr | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0033_Shipment_semi_dept_day.CreateSpread: 진입점 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0033_Shipment_semi_dept_day.Creat) |
| WK-SCP0033-0176 | A5 | spdMain (FpSpread) / spdMain_Sheet1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — spdMain (FpSpread) / spdMain_Sheet1: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (spdMain (FpSpread) / spdMain_Sheet1) |
| WK-SCP0033-0177 | G4 | D00-1-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-1-004: 행 집계 — G4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-004) |
| WK-SCP0033-0178 | G4 | D00-1-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-1-011: 행 집계 — G4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-011) |
| WK-SCP0033-0179 | G4 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-4b-001: 행 집계 — G4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-001) |
| WK-SCP0033-0180 | G4 | D00-4b-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-4b-003: 행 집계 — G4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-003) |
| WK-SCP0033-0181 | H2 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 3: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0033-0182 | H2 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 8: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (8) |
| WK-SCP0033-0183 | H2 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-01: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SCP0033-0184 | H2 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-02: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0033-0185 | H2 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-07: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0033-0186 | H2 | D00-1-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-1-004: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-004) |
| WK-SCP0033-0187 | H2 | D00-1-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-1-013: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-013) |
| WK-SCP0033-0188 | H2 | D00-1-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-1-014: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-014) |
| WK-SCP0033-0189 | H2 | D00-2-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-2-003: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-003) |
| WK-SCP0033-0190 | H2 | D00-3-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-3-001: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-001) |
| WK-SCP0033-0191 | H2 | D00-4d-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-4d-004: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-004) |
| WK-SCP0033-0192 | H2 | D00-4e-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-4e-008: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-008) |
| WK-SCP0033-0193 | H2 | SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY (Tabl | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY (Table[0] 그리드 /: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY (Tabl) |
| WK-SCP0033-0194 | H2 | SCP0033_Shipment_semi_dept_day.CreateSpr | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0033_Shipment_semi_dept_day.CreateSpread: 진입점 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0033_Shipment_semi_dept_day.Creat) |
| WK-SCP0033-0195 | H2 | spdMain (FpSpread) / spdMain_Sheet1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — spdMain (FpSpread) / spdMain_Sheet1: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (spdMain (FpSpread) / spdMain_Sheet1) |
| WK-SCP0033-0196 | H3 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H3 기대값 확정 — 3: 행 집계 — H3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0033-0197 | H3 | D00-2-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H3 기대값 확정 — D00-2-003: 행 집계 — H3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-003) |
| WK-SCP0033-0198 | H3 | D00-3-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H3 기대값 확정 — D00-3-001: 행 집계 — H3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-001) |
| WK-SCP0033-0199 | H5 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 3: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0033-0200 | H5 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 8: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (8) |
| WK-SCP0033-0201 | H5 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-01: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SCP0033-0202 | H5 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-02: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0033-0203 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0033-0204 | H5 | D00-1-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-1-013: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-013) |
| WK-SCP0033-0205 | H5 | D00-1-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-1-014: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-014) |
| WK-SCP0033-0206 | H5 | D00-4d-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-4d-004: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-004) |
| WK-SCP0033-0207 | H5 | D00-4e-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-4e-008: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-008) |
| WK-SCP0033-0208 | H5 | SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY (Tabl | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY (Table[0] 그리드 /: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY (Tabl) |
| WK-SCP0033-0209 | H5 | SCP0033_Shipment_semi_dept_day.CreateSpr | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0033_Shipment_semi_dept_day.CreateSpread: 진입점 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0033_Shipment_semi_dept_day.Creat) |
| WK-SCP0033-0210 | H5 | spdMain (FpSpread) / spdMain_Sheet1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — spdMain (FpSpread) / spdMain_Sheet1: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (spdMain (FpSpread) / spdMain_Sheet1) |
| WK-SCP0033-0211 | X-REASON | COMMON:UC-06 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-06 Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)  이 화면의 유일한 key-in 조회조건은 Model(ITEM_ID)인데 GET SP 계약이 단일  |  | 1 (COMMON:UC-06) |
| WK-SCP0033-0212 | X-REASON | D00-3-003 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-003 §3 VisibleTab / (true)  FpSpread 시트 탭 가시성 API. TO-BE 는 시트 탭 개념이 없는 단일 공용 DataGrid 라 대응 호출이 성립하지 않는다(그 |  | 1 (D00-3-003) |
| WK-SCP0033-0213 | D1 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 11: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (11) |
| WK-SCP0033-0214 | D1 | 15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 15: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (15) |
| WK-SCP0033-0215 | D1 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 2: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0033-0216 | D1 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 5: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0033-0217 | D1 | D00-3-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-005: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-005) |
| WK-SCP0033-0218 | D1 | D00-4d-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4d-002: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-002) |
| WK-SCP0033-0219 | D1 | D00-4d-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4d-005: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-005) |
| WK-SCP0033-0220 | D1 | D00-4e-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4e-006: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-006) |
| WK-SCP0033-0221 | D1 | FindButton/SaveButton/DeleteButton/Inser | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — FindButton/SaveButton/DeleteButton/InsertButton: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (FindButton/SaveButton/DeleteButton/Inser) |
| WK-SCP0033-0222 | D1 | SCP0033_Shipment_semi_dept_day.EditButto | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SCP0033_Shipment_semi_dept_day.EditButton: 진입점 집계 — D1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0033_Shipment_semi_dept_day.EditB) |
| WK-SCP0033-0223 | D3 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 11: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (11) |
| WK-SCP0033-0224 | D3 | 15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 15: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (15) |
| WK-SCP0033-0225 | D3 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 2: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0033-0226 | D3 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 5: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0033-0227 | D3 | D00-1-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-1-004: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-004) |
| WK-SCP0033-0228 | D3 | D00-3-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-005: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-005) |
| WK-SCP0033-0229 | D3 | D00-4d-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4d-002: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-002) |
| WK-SCP0033-0230 | D3 | D00-4d-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4d-005: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-005) |
| WK-SCP0033-0231 | D3 | D00-4e-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4e-006: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-006) |
| WK-SCP0033-0232 | D3 | FindButton/SaveButton/DeleteButton/Inser | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — FindButton/SaveButton/DeleteButton/InsertButton: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (FindButton/SaveButton/DeleteButton/Inser) |
| WK-SCP0033-0233 | D3 | SCP0033_Shipment_semi_dept_day.EditButto | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SCP0033_Shipment_semi_dept_day.EditButton: 진입점 집계 — D3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0033_Shipment_semi_dept_day.EditB) |
| WK-SCP0033-0234 | D4 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — 5: 행 집계 — D4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0033-0235 | D4 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — COMMON:UC-01: 행 집계 — D4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SCP0033-0236 | D4 | D00-3-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — D00-3-005: 행 집계 — D4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-005) |
| WK-SCP0033-0237 | D4 | D00-4e-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — D00-4e-004: 행 집계 — D4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-004) |
| WK-SCP0033-0238 | D4 | FindButton/SaveButton/DeleteButton/Inser | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — FindButton/SaveButton/DeleteButton/InsertButton: 행 집계 — D4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (FindButton/SaveButton/DeleteButton/Inser) |
| WK-SCP0033-0239 | D5 | SCP0033_Shipment_semi_dept_day.CreateSpr | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0033_Shipment_semi_dept_day.CreateSpread: 진입점 집계 — D5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0033_Shipment_semi_dept_day.Creat) |
| WK-SCP0033-0240 | E4 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 1: 행 집계 — E4 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-SCP0033-0241 | E4 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 5: 행 집계 — E4 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (5) |
| WK-SCP0033-0242 | E4 | D00-4e-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D00-4e-001: 행 집계 — E4 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-001) |
| WK-SCP0033-0243 | E4 | D00-4e-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D00-4e-005: 행 집계 — E4 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-005) |
| WK-SCP0033-0244 | A1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (1) |
| WK-SCP0033-0245 | A1 | 15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 15: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (15) |
| WK-SCP0033-0246 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (COMMON:UC-02) |
| WK-SCP0033-0247 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (COMMON:UC-07) |
| WK-SCP0033-0248 | A1 | D00-1-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-002: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (D00-1-002) |
| WK-SCP0033-0249 | A1 | D00-1-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-011: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (D00-1-011) |
| WK-SCP0033-0250 | A1 | D00-2-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-001: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (D00-2-001) |
| WK-SCP0033-0251 | A1 | D00-3-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-014: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (D00-3-014) |
| WK-SCP0033-0252 | A1 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4b-001: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (D00-4b-001) |
| WK-SCP0033-0253 | A1 | D00-4b-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4b-003: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (D00-4b-003) |
| WK-SCP0033-0254 | A1 | D00-4e-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4e-001: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (D00-4e-001) |
| WK-SCP0033-0255 | A1 | D00-4e-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4e-003: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (D00-4e-003) |
| WK-SCP0033-0256 | A1 | EDIT_SET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — EDIT_SET: 골든 비교 케이스 없음(EDIT_SET — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (D00-3-012) |
| WK-SCP0033-0257 | A1 | FindButton/SaveButton/DeleteButton/Inser | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindButton/SaveButton/DeleteButton/InsertButton: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (FindButton/SaveButton/DeleteButton/Inser) |
| WK-SCP0033-0258 | A1 | GetAllDivisionCheckedElectrode(clbDivisi | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — GetAllDivisionCheckedElectrode(clbDivision) (팝업 di: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (GetAllDivisionCheckedElectrode(clbDivisi) |
| WK-SCP0033-0259 | A1 | MODAL:ItemByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — MODAL:ItemByDivisionModal: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (MODAL:ItemByDivisionModal) |
| WK-SCP0033-0260 | A1 | PKG_SCP0033.P_SCP0033_GET_SHIPMENT_SEMI_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0033.P_SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY: 골든 비교 케이스 없음(PKG_SCP0033.P_SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY — 팝업·보 |  | 37 (SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY (Tabl) |
| WK-SCP0033-0261 | A6 | D00-4e-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — D00-4e-001: 행 집계 — A6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-001) |
| WK-SCP0033-0262 | G1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 1: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-SCP0033-0263 | G1 | 15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 15: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (15) |
| WK-SCP0033-0264 | G1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-02: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0033-0265 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0033-0266 | G1 | D00-1-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-004: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-004) |
| WK-SCP0033-0267 | G1 | D00-1-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-011: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-011) |
| WK-SCP0033-0268 | G1 | D00-2-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-2-001: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-001) |
| WK-SCP0033-0269 | G1 | D00-3-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-3-012: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-012) |
| WK-SCP0033-0270 | G1 | D00-3-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-3-014: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-014) |
| WK-SCP0033-0271 | G1 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-4b-001: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-001) |
| WK-SCP0033-0272 | G1 | D00-4b-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-4b-003: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-003) |
| WK-SCP0033-0273 | G1 | D00-4e-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-4e-001: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-001) |
| WK-SCP0033-0274 | G1 | D00-4e-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-4e-003: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-003) |
| WK-SCP0033-0275 | G1 | FindButton/SaveButton/DeleteButton/Inser | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — FindButton/SaveButton/DeleteButton/InsertButton: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (FindButton/SaveButton/DeleteButton/Inser) |
| WK-SCP0033-0276 | G1 | MODAL:ItemByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — MODAL:ItemByDivisionModal: 행 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ItemByDivisionModal) |
| WK-SCP0033-0277 | G6 | D00-1-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-1-004: 행 집계 — G6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-004) |
| WK-SCP0033-0278 | G6 | D00-1-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-1-011: 행 집계 — G6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-011) |
| WK-SCP0033-0279 | G6 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-4b-001: 행 집계 — G6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-001) |
| WK-SCP0033-0280 | G6 | D00-4b-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-4b-003: 행 집계 — G6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-003) |
| WK-SCP0033-0281 | X-ROW | 14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 14: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (14) |
| WK-SCP0033-0282 | X-ROW | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 4: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 0 () |
| WK-SCP0033-0283 | X-ROW | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 6: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 0 () |
| WK-SCP0033-0284 | X-ROW | CString.GetCheckedListValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CString.GetCheckedListValue: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CString.GetCheckedListValue) |
| WK-SCP0033-0285 | X-ROW | D00-1-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-005: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-005) |
| WK-SCP0033-0286 | X-ROW | D00-1-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-006: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-006) |
| WK-SCP0033-0287 | X-ROW | D00-1-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-007: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-007) |
| WK-SCP0033-0288 | X-ROW | D00-4d-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4d-006: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4d-006) |
| WK-SCP0033-0289 | X-ROW | SCP0033_Shipment_semi_dept_day.CreateSpr | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0033_Shipment_semi_dept_day.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0033_Shipment_semi_dept_day.Creat) |
| WK-SCP0033-0290 | X-ROW | SCP0033_Shipment_semi_dept_day.FindButto | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0033_Shipment_semi_dept_day.FindButton: 진입점 집계 3검사 — NOT_RUN:2 · REVIEW:1 |  | 1 (ACT:SCP0033_Shipment_semi_dept_day.FindB) |
| WK-SCP0033-0291 | X-ROW | SCP0033_Shipment_semi_dept_day.FindData_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0033_Shipment_semi_dept_day.FindData_Main: 진입점 집계 9검사 — NOT_RUN:7 · REVIEW:1 · PASS:1 |  | 7 (ACT:SCP0033_Shipment_semi_dept_day.FindD) |
| WK-SCP0033-0292 | X-ROW | SCP0033_Shipment_semi_dept_day.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0033_Shipment_semi_dept_day.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0033_Shipment_semi_dept_day.Form_) |
| WK-SCP0033-0293 | X-ROW | SCP0033_Shipment_semi_dept_day.InitContr | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0033_Shipment_semi_dept_day.InitControls: 진입점 집계 7검사 — NOT_RUN:7 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0033_Shipment_semi_dept_day.InitC) |
| WK-SCP0033-0294 | X-ROW | SCP0033_Shipment_semi_dept_day.InitEvent | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0033_Shipment_semi_dept_day.InitEvent: 진입점 집계 2검사 — NOPATH:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0033_Shipment_semi_dept_day.InitE) |
| WK-SCP0033-0295 | X-ROW | SCP0033_Shipment_semi_dept_day.InitSprea | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0033_Shipment_semi_dept_day.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0033_Shipment_semi_dept_day.InitS) |
| WK-SCP0033-0296 | X-ROW | SCP0033_Shipment_semi_dept_day.InsertBut | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0033_Shipment_semi_dept_day.InsertButton: 진입점 집계 19검사 — NOT_RUN:16 · NOPATH:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0033_Shipment_semi_dept_day.Inser) |
| WK-SCP0033-0297 | X-ROW | SCP0033_Shipment_semi_dept_day.SaveData_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0033_Shipment_semi_dept_day.SaveData_Main: 진입점 집계 12검사 — NOT_RUN:8 · NOPATH:2 · PASS:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0033_Shipment_semi_dept_day.SaveD) |
| WK-SCP0033-0298 | X-ROW | SCP0033_Shipment_semi_dept_day.SpdMain_C | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0033_Shipment_semi_dept_day.SpdMain_CellClick: 진입점 집계 8검사 — NOT_RUN:6 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 22 (ACT:SCP0033_Shipment_semi_dept_day.SpdMa) |
| WK-SCP0033-0299 | X-ROW | SCP0033_Shipment_semi_dept_day.SpdMain_K | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0033_Shipment_semi_dept_day.SpdMain_KeyPress: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/RETURN/UI_PROP, 연결된 요소 |  | 5 (ACT:SCP0033_Shipment_semi_dept_day.SpdMa) |
| WK-SCP0033-0300 | X-ROW | SCP0033_Shipment_semi_dept_day.SpdMain_T | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0033_Shipment_semi_dept_day.SpdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0033_Shipment_semi_dept_day.SpdMa) |
| WK-SCP0033-0301 | X-ROW | SCP0033_Shipment_semi_dept_day.checkVali | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0033_Shipment_semi_dept_day.checkValid: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 20 (ACT:SCP0033_Shipment_semi_dept_day.check) |
| WK-SCP0033-0302 | X-ROW | SCP0033_Shipment_semi_dept_day.checkVali | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0033_Shipment_semi_dept_day.checkValid1: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 20 (ACT:SCP0033_Shipment_semi_dept_day.check) |
| WK-SCP0033-0303 | X-ROW | VALID_YN AS S_VALUE_YN (별칭 오타 §6-D) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — VALID_YN AS S_VALUE_YN (별칭 오타 §6-D): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (VALID_YN AS S_VALUE_YN (별칭 오타 §6-D)) |
| WK-SCP0033-0304 | X-ROW | cboValidYN (UsrCombo) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — cboValidYN (UsrCombo): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (cboValidYN (UsrCombo)) |
| WK-SCP0033-0305 | X-ROW | clbDivision (UsrCheckedList) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — clbDivision (UsrCheckedList): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (clbDivision (UsrCheckedList)) |
| WK-SCP0033-0306 | X-ROW | dsValiChkBinding = GET Table[1] | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — dsValiChkBinding = GET Table[1]: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (dsValiChkBinding = GET Table[1]) |
| WK-SCP0033-0307 | X-ROW | emptySpaceItem3 / components / imageList | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — emptySpaceItem3 / components / imageList1: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (emptySpaceItem3 / components / imageList) |
| WK-SCP0033-0308 | X-ROW | layoutControlItem3/4/13 (라벨) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — layoutControlItem3/4/13 (라벨): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (layoutControlItem3/4/13 (라벨)) |
| WK-SCP0033-0309 | X-ROW | usrLayoutControl1 / layoutControlGroup1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — usrLayoutControl1 / layoutControlGroup1: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (usrLayoutControl1 / layoutControlGroup1) |
| WK-SCP0033-0310 | G5 | D00-2-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-2-001: 행 집계 — G5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-001) |
| WK-SCP0033-0311 | G5 | D00-4d-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-4d-005: 행 집계 — G5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-005) |
| WK-SCP0033-0312 | G5 | D00-4d-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-4d-007: 행 집계 — G5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-007) |
| WK-SCP0033-0313 | G5 | D00-4d-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-4d-008: 행 집계 — G5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-008) |
| WK-SCP0033-0314 | G5 | MODAL:ItemByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MODAL:ItemByDivisionModal: 행 집계 — G5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ItemByDivisionModal) |
| WK-SCP0033-0315 | G5 | SCM0002_ItembyDivisionPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCM0002_ItembyDivisionPopup: 행 집계 — G5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (SCM0002_ItembyDivisionPopup) |
| WK-SCP0033-0316 | G5 | prg (ProgressForm) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — prg (ProgressForm): 행 집계 — G5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (prg (ProgressForm)) |
| WK-SCP0033-0317 | H6 | D00-2-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-2-001: 행 집계 — H6 4요소: NOPATH:2 · NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-001) |
| WK-SCP0033-0318 | H6 | D00-4d-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-4d-005: 행 집계 — H6 4요소: NOPATH:2 · NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-005) |
| WK-SCP0033-0319 | H6 | D00-4d-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-4d-007: 행 집계 — H6 4요소: NOPATH:2 · NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-007) |
| WK-SCP0033-0320 | H6 | D00-4d-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-4d-008: 행 집계 — H6 4요소: NOPATH:2 · NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-008) |
| WK-SCP0033-0321 | H6 | MODAL:ItemByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MODAL:ItemByDivisionModal: 행 집계 — H6 4요소: NOPATH:2 · NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ItemByDivisionModal) |
| WK-SCP0033-0322 | H6 | SCM0002_ItembyDivisionPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCM0002_ItembyDivisionPopup: 행 집계 — H6 4요소: NOPATH:2 · NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (SCM0002_ItembyDivisionPopup) |
| WK-SCP0033-0323 | H6 | prg (ProgressForm) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — prg (ProgressForm): 행 집계 — H6 4요소: NOPATH:2 · NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (prg (ProgressForm)) |
| WK-SCP0033-0324 | M4 | D00-2-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-2-001: 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-001) |
| WK-SCP0033-0325 | M4 | D00-4d-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-4d-005: 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-005) |
| WK-SCP0033-0326 | M4 | D00-4d-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-4d-007: 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-007) |
| WK-SCP0033-0327 | M4 | D00-4d-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-4d-008: 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-008) |
| WK-SCP0033-0328 | M4 | MODAL:ItemByDivisionModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MODAL:ItemByDivisionModal: 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ItemByDivisionModal) |
| WK-SCP0033-0329 | M4 | SCM0002_ItembyDivisionPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCM0002_ItembyDivisionPopup: 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (SCM0002_ItembyDivisionPopup) |
| WK-SCP0033-0330 | M4 | prg (ProgressForm) | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — prg (ProgressForm): 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (prg (ProgressForm)) |
