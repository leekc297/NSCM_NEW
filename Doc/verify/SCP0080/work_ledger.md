# 작업 원장 — SCP0080 · 2026-10-26 12:54

> 검사 인스턴스 324건 중 PASS·NA 45건 외 **279건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 15 | 구현 위치 실존 |
| W3 | 동작 수정 | 5 | 재판정 PASS |
| W4 | 검사기 구현 | 12 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 21 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 64 | 실행 → PASS |
| W7 | 기대값 확정 | 162 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 159 · E2E 64 · 하네스 33 · 대조표 18 · FE 4 · DB 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 3건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  | 1 |  |  |  | 47 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| E4 | EDIT |  |  |  |  |  | 10 | 10 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| X-LOC | GEN |  | 15 |  |  |  |  | 2 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| B4 | COMBO |  |  |  |  | 12 |  | 5 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| C3 | CASCADE |  |  |  |  |  | 6 | 11 |  |  | 연쇄 자동 채움 |
| B3 | COMBO |  |  |  | 12 |  |  | 4 |  |  | 콤보 후보 정렬 = AS-IS |
| A1 | GEN |  |  |  |  |  |  | 15 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| A5 | DESIGN |  |  |  |  |  | 4 | 8 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H2 | DESIGN |  |  |  |  |  | 5 | 7 |  |  | 배경·글자색 규칙 |
| G4 | DESIGN |  |  |  |  |  | 5 | 6 |  |  | 조회조건 표시·라벨·활성 |
| H5 | DESIGN |  |  |  |  |  | 4 | 7 |  |  | 라벨 명칭 |
| G6 | GEN |  |  |  |  |  | 5 | 6 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| F4 | DB |  |  |  |  |  | 4 | 6 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| M4 | POPUP |  |  |  |  |  | 4 | 4 |  |  | 팝업 선택값 반영 |
| DB-SYN | DB |  |  | 3 |  | 3 |  |  |  |  | BE 계정 시노님·권한·대상 객체 |
| G5 | POPUP |  |  |  |  | 2 |  | 4 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 2 |  | 4 |  |  | 팝업 표준·열림 |
| D1 | EDIT |  |  |  |  |  | 2 | 4 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 2 | 4 |  |  | 행 값 기반 조건부 잠금 |
| A6 | GEN |  |  |  |  |  | 2 | 3 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| X-REASON | DESIGN |  |  |  |  |  |  | 3 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| C1 | CASCADE |  |  |  |  |  | 2 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| H10 | DESIGN |  |  | 1 |  |  |  |  |  |  | 메시지 표준(방식·코드 단일화) |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| SC1 | DESIGN |  |  |  |  |  |  | 1 |  |  | 조회조건 순서 = 기준표 |
| G03-WIRE | GEN |  |  |  |  |  |  | 1 |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |

## W2 구현 위치 확인 (15)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0080-0001 | X-LOC | DELETE | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (DELETE) |
| WK-SCP0080-0002 | X-LOC | EDIT | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EDIT) |
| WK-SCP0080-0003 | X-LOC | EXCEL | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EXCEL) |
| WK-SCP0080-0004 | X-LOC | FCST/Production/Active/BOM Y/N | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (FCST/Production/Active/BOM Y/N) |
| WK-SCP0080-0005 | X-LOC | INSERT | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (INSERT) |
| WK-SCP0080-0006 | X-LOC | Model → p_model_id | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: Form.tsx 없음 |  | 1 (Model → p_model_id) |
| WK-SCP0080-0007 | X-LOC | NickName → p_nick_name | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: Form.tsx 없음 |  | 1 (NickName → p_nick_name) |
| WK-SCP0080-0008 | X-LOC | SAVE | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SAVE) |
| WK-SCP0080-0009 | X-LOC | SCP0080_SAVE (40 params, SaveData_Main l | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SCP0080_SAVE (40 params, SaveData_Main l) |
| WK-SCP0080-0010 | X-LOC | SEARCH | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SEARCH) |
| WK-SCP0080-0011 | X-LOC | UserInfoPopup PIC 검색(div=82) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (UserInfoPopup PIC 검색(div=82)) |
| WK-SCP0080-0012 | X-LOC | spdMain_CellDoubleClick RTFGubun 팝업(div= | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: Grid.tsx 없음 |  | 1 (spdMain_CellDoubleClick RTFGubun 팝업(div=) |
| WK-SCP0080-0013 | X-LOC | spdMain_KeyPress R-KEYBLOCK(RTFGubun 셀 직 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: Grid.tsx 없음 |  | 1 (spdMain_KeyPress R-KEYBLOCK(RTFGubun 셀 직) |
| WK-SCP0080-0014 | X-LOC | 컬럼 메타 (division 별 40/81계열/82 레이아웃) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (컬럼 메타 (division 별 40/81계열/82 레이아웃)) |
| WK-SCP0080-0015 | X-LOC | 편집 가능 컬럼 (base GROUP_CODE1~5/REMARK + 레이 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: Grid.tsx 없음 |  | 1 (편집 가능 컬럼 (base GROUP_CODE1~5/REMARK + 레이) |

## W3 동작 수정 (5)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0080-0016 | DB-SYN | PKG_SCP0080.P_SCP0050_GET_CAPA_PIC_USERI | DB(🛠️/🧯 적용 가능) | DB-SYN FAIL 수정 — PKG_SCP0080.P_SCP0050_GET_CAPA_PIC_USERINFO_POPUP: 시노님검사 SYN_MISSING |  | 4 (SCP0050_GET_CAPA_PIC_USERINFO_POPUP (Che) |
| WK-SCP0080-0017 | DB-SYN | SCP0080_GroupCodeManagement.FindDataMain | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | DB-SYN FAIL 수정 — SCP0080_GroupCodeManagement.FindDataMain: 진입점 집계 — DB-SYN 4요소: NOPATH:3 · FAIL:1 |  | 1 (ACT:SCP0080_GroupCodeManagement.FindData) |
| WK-SCP0080-0018 | DB-SYN | SCP0080_GroupCodeManagement.SaveData | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | DB-SYN FAIL 수정 — SCP0080_GroupCodeManagement.SaveData: 진입점 집계 — DB-SYN 4요소: NOPATH:3 · FAIL:1 |  | 1 (ACT:SCP0080_GroupCodeManagement.SaveData) |
| WK-SCP0080-0019 | H10 | SCP0080 화면 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | H10 FAIL 수정 — SCP0080 화면: 표준 메시지 대신 브라우저 alert/confirm 직접 호출: components/GroupCodeRtfGubunModal.tsx |  | 10 (MSG00048 날짜 순서 검증(line 975) MSG00251 PIC) |
| WK-SCP0080-0020 | X-ROW | SCP0080_GroupCodeManagement.CheckUser | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | X-ROW FAIL 수정 — SCP0080_GroupCodeManagement.CheckUser: 진입점 집계 7검사 — NOT_RUN:6 · FAIL:1 |  | 18 (ACT:SCP0080_GroupCodeManagement.CheckUse) |

## W4 검사기 구현 (12)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0080-0021 | B3 | DIVISION_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 DIVISION_ID | 있음(SHEET_COLUMNS) | 4 (ACT:SCP0080_GroupCodeManagement.GetProdu) |
| WK-SCP0080-0022 | B3 | ITEM_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 ITEM_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0080_GroupCodeManagement.GetProdu) |
| WK-SCP0080-0023 | B3 | OPERATION_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 OPERATION_ID | 있음(SHEET_COLUMNS) | 4 (ACT:SCP0080_GroupCodeManagement.GetProdu) |
| WK-SCP0080-0024 | B3 | SALES_PRIORITY | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 SALES_PRIORITY | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0080_GroupCodeManagement.GetSales) |
| WK-SCP0080-0025 | B3 | cboDivision / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboDivision / Division | 있음(FE 소스) | 2 (ACT:SCP0080_GroupCodeManagement.getDivis) |
| WK-SCP0080-0026 | B3 | chkActive / Active / Model Attribute | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 chkActive / Active / Model Attribute | 있음(FE 소스) | 2 (ACT:SCP0080_GroupCodeManagement.getActiv) |
| WK-SCP0080-0027 | B3 | chkBOM / BOM / Model Attribute | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 chkBOM / BOM / Model Attribute | 있음(FE 소스) | 2 (ACT:SCP0080_GroupCodeManagement.getBOMCh) |
| WK-SCP0080-0028 | B3 | chkFCST / FCST / Model Attribute | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 chkFCST / FCST / Model Attribute | 있음(FE 소스) | 2 (ACT:SCP0080_GroupCodeManagement.getFCSTC) |
| WK-SCP0080-0029 | B3 | chkProduction / Production / Model Attri | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 chkProduction / Production / Model Attribute | 있음(FE 소스) | 2 (ACT:SCP0080_GroupCodeManagement.getProdu) |
| WK-SCP0080-0030 | B3 | clbOperation / Operation | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbOperation / Operation | 있음(FE 소스) | 2 (ACT:SCP0080_GroupCodeManagement.getOpera) |
| WK-SCP0080-0031 | B3 | txtModel / Model / Model/Nickname | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 txtModel / Model / Model/Nickname | 있음(FE 소스) | 2 (ACT:SCP0080_GroupCodeManagement.getModel) |
| WK-SCP0080-0032 | B3 | txtNickname / NickName / Nickname / Mode | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 txtNickname / NickName / Nickname / Model/Nickname | 있음(FE 소스) | 2 (ACT:SCP0080_GroupCodeManagement.getNickn) |

## W5 검사기 연결 (21)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0080-0033 | B4 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 4 (ACT:SCP0080_GroupCodeManagement.GetProdu) |
| WK-SCP0080-0034 | B4 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0080_GroupCodeManagement.GetProdu) |
| WK-SCP0080-0035 | B4 | OPERATION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL OPERATION_ID | 있음(SHEET_COLUMNS) | 4 (ACT:SCP0080_GroupCodeManagement.GetProdu) |
| WK-SCP0080-0036 | B4 | SALES_PRIORITY | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL SALES_PRIORITY | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0080_GroupCodeManagement.GetSales) |
| WK-SCP0080-0037 | B4 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 2 (ACT:SCP0080_GroupCodeManagement.getDivis) |
| WK-SCP0080-0038 | B4 | chkActive / Active / Model Attribute | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND chkActive / Active / Model Attribute | 있음(FE 소스) | 2 (ACT:SCP0080_GroupCodeManagement.getActiv) |
| WK-SCP0080-0039 | B4 | chkBOM / BOM / Model Attribute | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND chkBOM / BOM / Model Attribute | 있음(FE 소스) | 2 (ACT:SCP0080_GroupCodeManagement.getBOMCh) |
| WK-SCP0080-0040 | B4 | chkFCST / FCST / Model Attribute | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND chkFCST / FCST / Model Attribute | 있음(FE 소스) | 2 (ACT:SCP0080_GroupCodeManagement.getFCSTC) |
| WK-SCP0080-0041 | B4 | chkProduction / Production / Model Attri | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND chkProduction / Production / Model Attribute | 있음(FE 소스) | 2 (ACT:SCP0080_GroupCodeManagement.getProdu) |
| WK-SCP0080-0042 | B4 | clbOperation / Operation | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbOperation / Operation | 있음(FE 소스) | 2 (ACT:SCP0080_GroupCodeManagement.getOpera) |
| WK-SCP0080-0043 | B4 | txtModel / Model / Model/Nickname | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND txtModel / Model / Model/Nickname | 있음(FE 소스) | 2 (ACT:SCP0080_GroupCodeManagement.getModel) |
| WK-SCP0080-0044 | B4 | txtNickname / NickName / Nickname / Mode | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND txtNickname / NickName / Nickname / Model/Nickname | 있음(FE 소스) | 2 (ACT:SCP0080_GroupCodeManagement.getNickn) |
| WK-SCP0080-0045 | F2 | SCP0080 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0080 화면 | 판단불가(대상 단위 SCREEN) | 29 (MSG00048 날짜 순서 검증(line 975) MSG00251 PIC) |
| WK-SCP0080-0046 | F6 | SCP0080 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0080 화면 | 판단불가(대상 단위 SCREEN) | 21 (SCP0080_SAVE (40 params, SaveData_Main l) |
| WK-SCP0080-0047 | DB-SYN | PKG_SCP0080 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP PKG_SCP0080 | 없음(PROC_M 대응 없음) | 1 (SCP0050_GET_CAPA_PIC_USERINFO_POPUP (Che) |
| WK-SCP0080-0048 | DB-SYN | P_SCP0080_SAVE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SCP0080_SAVE | 없음(PROC_M 대응 없음) | 1 (SCP0080_SAVE (40 params, SaveData_Main l) |
| WK-SCP0080-0049 | DB-SYN | SCP0080_SAVE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0080_SAVE | 없음(PROC_M 대응 없음) | 1 (SCP0080_SAVE (40 params, SaveData_Main l) |
| WK-SCP0080-0050 | G5 | GROUP_CODE5 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL GROUP_CODE5 | 있음(SHEET_COLUMNS) | 1 (spdMain_CellDoubleClick RTFGubun 팝업(div=) |
| WK-SCP0080-0051 | G5 | PIC_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL PIC_ID | 있음(SHEET_COLUMNS) | 1 (SpdMain_Change PIC_ID guard) |
| WK-SCP0080-0052 | H6 | GROUP_CODE5 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL GROUP_CODE5 | 있음(SHEET_COLUMNS) | 1 (spdMain_CellDoubleClick RTFGubun 팝업(div=) |
| WK-SCP0080-0053 | H6 | PIC_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL PIC_ID | 있음(SHEET_COLUMNS) | 1 (SpdMain_Change PIC_ID guard) |

## W6 검증 실행 (64)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0080-0054 | J2 | SCP0080 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0080 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 22 (Division (BLUtils.GetDivisionWithoutEE) ) |
| WK-SCP0080-0055 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0080_GroupCodeManagement.InitCont) |
| WK-SCP0080-0056 | C1 | clbOperation / Operation | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbOperation / Operation · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:SCP0080_GroupCodeManagement.InitCont) |
| WK-SCP0080-0057 | C3 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0080_GroupCodeManagement.SetChang) |
| WK-SCP0080-0058 | C3 | GROUP_CODE1 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — GROUP_CODE1 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SCP0080_GroupCodeManagement.SetColum) |
| WK-SCP0080-0059 | C3 | GROUP_CODE5 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — GROUP_CODE5 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SCP0080_GroupCodeManagement.spdMain_) |
| WK-SCP0080-0060 | C3 | PIC_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PIC_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0080_GroupCodeManagement.spdMain_) |
| WK-SCP0080-0061 | C3 | PIC_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PIC_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCP0080_GroupCodeManagement.spdMain_) |
| WK-SCP0080-0062 | C3 | STATUS_MASS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — STATUS_MASS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0080_GroupCodeManagement.SetColum) |
| WK-SCP0080-0063 | G3 | SCP0080 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0080 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 5 (COMMON:UC-02 COMMON:UC-04 COMMON:UC-05 C) |
| WK-SCP0080-0064 | K4 | SCP0080 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0080 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 5 (COMMON:UC-02 COMMON:UC-04 COMMON:UC-05 C) |
| WK-SCP0080-0065 | F1 | SCP0080 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0080 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 30 (MSG00048 날짜 순서 검증(line 975) MSG00251 PIC) |
| WK-SCP0080-0066 | F5 | SCP0080 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0080 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 1 (DELETE) |
| WK-SCP0080-0067 | F4 | PKG_SCP0080 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0080 · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (SCP0050_GET_CAPA_PIC_USERINFO_POPUP (Che) |
| WK-SCP0080-0068 | F4 | PKG_SCP0080.P_SCP0050_GET_CAPA_PIC_USERI | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0080.P_SCP0050_GET_CAPA_PIC_USERINFO_POPUP · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) |  | 4 (SCP0050_GET_CAPA_PIC_USERINFO_POPUP (Che) |
| WK-SCP0080-0069 | F4 | P_SCP0080_SAVE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_SCP0080_SAVE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (SCP0080_SAVE (40 params, SaveData_Main l) |
| WK-SCP0080-0070 | F4 | SCP0080_SAVE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0080_SAVE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (SCP0080_SAVE (40 params, SaveData_Main l) |
| WK-SCP0080-0071 | A5 | GROUP_CODE1 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — GROUP_CODE1 · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (편집 가능 컬럼 (base GROUP_CODE1~5/REMARK + 레이) |
| WK-SCP0080-0072 | A5 | GROUP_CODE5 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — GROUP_CODE5 · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 12 (spdMain_CellDoubleClick RTFGubun 팝업(div=) |
| WK-SCP0080-0073 | A5 | PIC_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PIC_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 5 (SpdMain_Change PIC_ID guard ACT:SCP0080_) |
| WK-SCP0080-0074 | A5 | REMARK | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — REMARK · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (편집 가능 컬럼 (base GROUP_CODE1~5/REMARK + 레이) |
| WK-SCP0080-0075 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0080_GroupCodeManagement.InitCont) |
| WK-SCP0080-0076 | G4 | chkActive / Active / Model Attribute | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkActive / Active / Model Attribute · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0080_GroupCodeManagement.InitCont) |
| WK-SCP0080-0077 | G4 | chkFCST / FCST / Model Attribute | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkFCST / FCST / Model Attribute · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0080_GroupCodeManagement.InitCont) |
| WK-SCP0080-0078 | G4 | chkProduction / Production / Model Attri | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkProduction / Production / Model Attribute · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0080_GroupCodeManagement.InitCont) |
| WK-SCP0080-0079 | G4 | clbOperation / Operation | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbOperation / Operation · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0080_GroupCodeManagement.InitCont) |
| WK-SCP0080-0080 | H2 | GROUP_CODE1 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — GROUP_CODE1 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (편집 가능 컬럼 (base GROUP_CODE1~5/REMARK + 레이) |
| WK-SCP0080-0081 | H2 | GROUP_CODE5 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — GROUP_CODE5 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (spdMain_CellDoubleClick RTFGubun 팝업(div=) |
| WK-SCP0080-0082 | H2 | PIC_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PIC_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (SpdMain_Change PIC_ID guard) |
| WK-SCP0080-0083 | H2 | REMARK | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — REMARK · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (편집 가능 컬럼 (base GROUP_CODE1~5/REMARK + 레이) |
| WK-SCP0080-0084 | H2 | STATUS_MASS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — STATUS_MASS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0080_GroupCodeManagement.AlarmByS) |
| WK-SCP0080-0085 | H5 | GROUP_CODE1 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — GROUP_CODE1 · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (편집 가능 컬럼 (base GROUP_CODE1~5/REMARK + 레이) |
| WK-SCP0080-0086 | H5 | GROUP_CODE5 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — GROUP_CODE5 · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (spdMain_CellDoubleClick RTFGubun 팝업(div=) |
| WK-SCP0080-0087 | H5 | PIC_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PIC_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (SpdMain_Change PIC_ID guard) |
| WK-SCP0080-0088 | H5 | REMARK | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — REMARK · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (편집 가능 컬럼 (base GROUP_CODE1~5/REMARK + 레이) |
| WK-SCP0080-0089 | I1 | SCP0080 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0080 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 13 (MSG00048 날짜 순서 검증(line 975) MSG00251 PIC) |
| WK-SCP0080-0090 | D1 | GROUP_CODE1 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — GROUP_CODE1 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (편집 가능 컬럼 (base GROUP_CODE1~5/REMARK + 레이) |
| WK-SCP0080-0091 | D1 | REMARK | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — REMARK · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (편집 가능 컬럼 (base GROUP_CODE1~5/REMARK + 레이) |
| WK-SCP0080-0092 | D3 | GROUP_CODE1 | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — GROUP_CODE1 · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (편집 가능 컬럼 (base GROUP_CODE1~5/REMARK + 레이) |
| WK-SCP0080-0093 | D3 | REMARK | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — REMARK · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (편집 가능 컬럼 (base GROUP_CODE1~5/REMARK + 레이) |
| WK-SCP0080-0094 | D6 | SCP0080 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0080 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 3 (INSERT ACT:SCP0080_GroupCodeManagement.I) |
| WK-SCP0080-0095 | E4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0080_GroupCodeManagement.SetChang) |
| WK-SCP0080-0096 | E4 | GROUP_CODE1 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — GROUP_CODE1 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SCP0080_GroupCodeManagement.SetColum) |
| WK-SCP0080-0097 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00004 저장 성공 ACT:SCP0080_GroupCodeMana) |
| WK-SCP0080-0098 | E4 | MSG00048 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00048 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00048 날짜 순서 검증(line 975) ACT:SCP0080_) |
| WK-SCP0080-0099 | E4 | MSG00133 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00133 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00133 무변경(line) ACT:SCP0080_GroupCode) |
| WK-SCP0080-0100 | E4 | MSG00251 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00251 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00251 PIC 미검증(line 1436) → TO-BE MSG0) |
| WK-SCP0080-0101 | E4 | MSG00284 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00284 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00284 저장 결과 ACT:SCP0080_GroupCodeMana) |
| WK-SCP0080-0102 | E4 | MSG01261 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01261 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (MSG00251 PIC 미검증(line 1436) → TO-BE MSG0) |
| WK-SCP0080-0103 | E4 | STATUS_MASS | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — STATUS_MASS · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0080_GroupCodeManagement.SetColum) |
| WK-SCP0080-0104 | E4 | clbOperation / Operation | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbOperation / Operation · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 |  | 2 (ACT:SCP0080_GroupCodeManagement.SetChang) |
| WK-SCP0080-0105 | A10 | SCP0080 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0080 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 56 (ACT:SCP0080_GroupCodeManagement.Form_Loa) |
| WK-SCP0080-0106 | A6 | PKG_SCP0080 | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0080 · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 1 (SCP0050_GET_CAPA_PIC_USERINFO_POPUP (Che) |
| WK-SCP0080-0107 | A6 | PKG_SCP0080.P_SCP0050_GET_CAPA_PIC_USERI | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0080.P_SCP0050_GET_CAPA_PIC_USERINFO_POPUP · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURC |  | 1 (SCP0050_GET_CAPA_PIC_USERINFO_POPUP (Che) |
| WK-SCP0080-0108 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCP0080_GroupCodeManagement.InitCont) |
| WK-SCP0080-0109 | G6 | chkActive / Active / Model Attribute | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — chkActive / Active / Model Attribute · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0080_GroupCodeManagement.InitCont) |
| WK-SCP0080-0110 | G6 | chkFCST / FCST / Model Attribute | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — chkFCST / FCST / Model Attribute · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0080_GroupCodeManagement.InitCont) |
| WK-SCP0080-0111 | G6 | chkProduction / Production / Model Attri | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — chkProduction / Production / Model Attribute · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0080_GroupCodeManagement.InitCont) |
| WK-SCP0080-0112 | G6 | clbOperation / Operation | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbOperation / Operation · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0080_GroupCodeManagement.InitCont) |
| WK-SCP0080-0113 | X-REOPEN | SCP0080 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0080 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 5 (ACT:SCP0080_GroupCodeManagement.CheckUse) |
| WK-SCP0080-0114 | M4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SCP0080_GroupCodeManagement.spdMain_) |
| WK-SCP0080-0115 | M4 | GROUP_CODE5 | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — GROUP_CODE5 · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 31 (spdMain_CellDoubleClick RTFGubun 팝업(div=) |
| WK-SCP0080-0116 | M4 | PIC_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — PIC_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 13 (SpdMain_Change PIC_ID guard ACT:SCP0080_) |
| WK-SCP0080-0117 | M4 | PIC_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — PIC_NAME · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (ACT:SCP0080_GroupCodeManagement.spdMain_) |

## W7 기대값 확정 (162)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0080-0118 | C3 | SCP0080_GroupCodeManagement.SetChangedCo | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0080_GroupCodeManagement.SetChangedControl: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0080_GroupCodeManagement.SetChang) |
| WK-SCP0080-0119 | C3 | SCP0080_GroupCodeManagement.SetColumnCon | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0080_GroupCodeManagement.SetColumnCondition81: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0080_GroupCodeManagement.SetColum) |
| WK-SCP0080-0120 | C3 | SCP0080_GroupCodeManagement.SetLockColum | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0080_GroupCodeManagement.SetLockColumns: 진입점 집계 — C3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0080_GroupCodeManagement.SetLockC) |
| WK-SCP0080-0121 | C3 | SCP0080_GroupCodeManagement.SetNotEitabl | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0080_GroupCodeManagement.SetNotEitableColumns: 진입점 집계 — C3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0080_GroupCodeManagement.SetNotEi) |
| WK-SCP0080-0122 | C3 | SCP0080_GroupCodeManagement.SetNotEitabl | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0080_GroupCodeManagement.SetNotEitableColumns40: 진입점 집계 — C3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0080_GroupCodeManagement.SetNotEi) |
| WK-SCP0080-0123 | C3 | SCP0080_GroupCodeManagement.SetNotEitabl | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0080_GroupCodeManagement.SetNotEitableColumns81: 진입점 집계 — C3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0080_GroupCodeManagement.SetNotEi) |
| WK-SCP0080-0124 | C3 | SCP0080_GroupCodeManagement.SetNotEitabl | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0080_GroupCodeManagement.SetNotEitableColumns82: 진입점 집계 — C3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0080_GroupCodeManagement.SetNotEi) |
| WK-SCP0080-0125 | C3 | SCP0080_GroupCodeManagement.SetQueryInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0080_GroupCodeManagement.SetQueryInfoGet: 진입점 집계 — C3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 14 (ACT:SCP0080_GroupCodeManagement.SetQuery) |
| WK-SCP0080-0126 | C3 | SCP0080_GroupCodeManagement.SetQueryInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0080_GroupCodeManagement.SetQueryInfoSave: 진입점 집계 — C3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 43 (ACT:SCP0080_GroupCodeManagement.SetQuery) |
| WK-SCP0080-0127 | C3 | SCP0080_GroupCodeManagement.SetVisibleSh | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0080_GroupCodeManagement.SetVisibleSheet: 진입점 집계 — C3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 22 (ACT:SCP0080_GroupCodeManagement.SetVisib) |
| WK-SCP0080-0128 | C3 | SCP0080_GroupCodeManagement.cboDivision_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0080_GroupCodeManagement.cboDivision_SelectedIn: 진입점 집계 — C3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0080_GroupCodeManagement.cboDivis) |
| WK-SCP0080-0129 | B3 | Division (BLUtils.GetDivisionWithoutEE) | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — Division (BLUtils.GetDivisionWithoutEE): 행 집계 — B3 12요소: TODO:12 (미실행 요소가 남아 판정필요) |  | 1 (Division (BLUtils.GetDivisionWithoutEE)) |
| WK-SCP0080-0130 | B3 | SCP0080_GroupCodeManagement.GetColumnVal | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0080_GroupCodeManagement.GetColumnValue: 진입점 집계 — B3 12요소: TODO:12 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0080_GroupCodeManagement.GetColum) |
| WK-SCP0080-0131 | B3 | SCP0080_GroupCodeManagement.GetProductio | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0080_GroupCodeManagement.GetProductionModels: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SCP0080_GroupCodeManagement.GetProdu) |
| WK-SCP0080-0132 | B3 | SCP0080_GroupCodeManagement.GetSalesMode | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0080_GroupCodeManagement.GetSalesModelPrioritys: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0080_GroupCodeManagement.GetSales) |
| WK-SCP0080-0133 | B4 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — COMMON:UC-05: 행 집계 — B4 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0080-0134 | B4 | Division (BLUtils.GetDivisionWithoutEE) | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — Division (BLUtils.GetDivisionWithoutEE): 행 집계 — B4 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 1 (Division (BLUtils.GetDivisionWithoutEE)) |
| WK-SCP0080-0135 | B4 | SCP0080_GroupCodeManagement.GetColumnVal | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0080_GroupCodeManagement.GetColumnValue: 진입점 집계 — B4 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0080_GroupCodeManagement.GetColum) |
| WK-SCP0080-0136 | B4 | SCP0080_GroupCodeManagement.GetProductio | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0080_GroupCodeManagement.GetProductionModels: 진입점 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SCP0080_GroupCodeManagement.GetProdu) |
| WK-SCP0080-0137 | B4 | SCP0080_GroupCodeManagement.GetSalesMode | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0080_GroupCodeManagement.GetSalesModelPrioritys: 진입점 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0080_GroupCodeManagement.GetSales) |
| WK-SCP0080-0138 | F4 | SCP0080_GroupCodeManagement.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0080_GroupCodeManagement.FindButton: 진입점 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0080_GroupCodeManagement.FindButt) |
| WK-SCP0080-0139 | F4 | SCP0080_GroupCodeManagement.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0080_GroupCodeManagement.FindData: 진입점 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0080_GroupCodeManagement.FindData) |
| WK-SCP0080-0140 | F4 | SCP0080_GroupCodeManagement.FindDataMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0080_GroupCodeManagement.FindDataMain: 진입점 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0080_GroupCodeManagement.FindData) |
| WK-SCP0080-0141 | F4 | SCP0080_GroupCodeManagement.SaveButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0080_GroupCodeManagement.SaveButton: 진입점 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0080_GroupCodeManagement.SaveButt) |
| WK-SCP0080-0142 | F4 | SCP0080_GroupCodeManagement.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0080_GroupCodeManagement.SaveData: 진입점 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0080_GroupCodeManagement.SaveData) |
| WK-SCP0080-0143 | F4 | SCP0080_GroupCodeManagement.SaveData_Mai | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0080_GroupCodeManagement.SaveData_Main: 진입점 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0080_GroupCodeManagement.SaveData) |
| WK-SCP0080-0144 | A5 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-02: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0080-0145 | A5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-07: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0080-0146 | A5 | SCP0080_GroupCodeManagement.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0080_GroupCodeManagement.CreateSpread: 진입점 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 28 (ACT:SCP0080_GroupCodeManagement.CreateSp) |
| WK-SCP0080-0147 | A5 | UserInfoPopup PIC 검색(div=82) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — UserInfoPopup PIC 검색(div=82): 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (UserInfoPopup PIC 검색(div=82)) |
| WK-SCP0080-0148 | A5 | chkActive/BOM (Visible=false) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — chkActive/BOM (Visible=false): 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (chkActive/BOM (Visible=false)) |
| WK-SCP0080-0149 | A5 | spd40 / spd81 / spdEtc(FpSpread 3종) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — spd40 / spd81 / spdEtc(FpSpread 3종): 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (spd40 / spd81 / spdEtc(FpSpread 3종)) |
| WK-SCP0080-0150 | A5 | spdMain_KeyPress R-KEYBLOCK(RTFGubun 셀 직 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — spdMain_KeyPress R-KEYBLOCK(RTFGubun 셀 직접입력 차단): 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (spdMain_KeyPress R-KEYBLOCK(RTFGubun 셀 직) |
| WK-SCP0080-0151 | A5 | 컬럼 메타 (division 별 40/81계열/82 레이아웃) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 컬럼 메타 (division 별 40/81계열/82 레이아웃): 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (컬럼 메타 (division 별 40/81계열/82 레이아웃)) |
| WK-SCP0080-0152 | G4 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — COMMON:UC-06: 행 집계 — G4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0080-0153 | G4 | Division (BLUtils.GetDivisionWithoutEE) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — Division (BLUtils.GetDivisionWithoutEE): 행 집계 — G4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (Division (BLUtils.GetDivisionWithoutEE)) |
| WK-SCP0080-0154 | G4 | FCST/Production/Active/BOM Y/N | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — FCST/Production/Active/BOM Y/N: 행 집계 — G4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (FCST/Production/Active/BOM Y/N) |
| WK-SCP0080-0155 | G4 | Model → p_model_id | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — Model → p_model_id: 행 집계 — G4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (Model → p_model_id) |
| WK-SCP0080-0156 | G4 | NickName → p_nick_name | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — NickName → p_nick_name: 행 집계 — G4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (NickName → p_nick_name) |
| WK-SCP0080-0157 | G4 | Operation (Data_SCP.Common OperationForP | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — Operation (Data_SCP.Common OperationForPlanDivisio: 행 집계 — G4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (Operation (Data_SCP.Common OperationForP) |
| WK-SCP0080-0158 | H2 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-02: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0080-0159 | H2 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-07: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0080-0160 | H2 | SCP0080_GroupCodeManagement.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0080_GroupCodeManagement.CreateSpread: 진입점 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 28 (ACT:SCP0080_GroupCodeManagement.CreateSp) |
| WK-SCP0080-0161 | H2 | UserInfoPopup PIC 검색(div=82) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — UserInfoPopup PIC 검색(div=82): 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (UserInfoPopup PIC 검색(div=82)) |
| WK-SCP0080-0162 | H2 | spd40 / spd81 / spdEtc(FpSpread 3종) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — spd40 / spd81 / spdEtc(FpSpread 3종): 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (spd40 / spd81 / spdEtc(FpSpread 3종)) |
| WK-SCP0080-0163 | H2 | spdMain_KeyPress R-KEYBLOCK(RTFGubun 셀 직 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — spdMain_KeyPress R-KEYBLOCK(RTFGubun 셀 직접입력 차단): 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (spdMain_KeyPress R-KEYBLOCK(RTFGubun 셀 직) |
| WK-SCP0080-0164 | H2 | 컬럼 메타 (division 별 40/81계열/82 레이아웃) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 컬럼 메타 (division 별 40/81계열/82 레이아웃): 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (컬럼 메타 (division 별 40/81계열/82 레이아웃)) |
| WK-SCP0080-0165 | H5 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-02: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0080-0166 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0080-0167 | H5 | SCP0080_GroupCodeManagement.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0080_GroupCodeManagement.CreateSpread: 진입점 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 28 (ACT:SCP0080_GroupCodeManagement.CreateSp) |
| WK-SCP0080-0168 | H5 | UserInfoPopup PIC 검색(div=82) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — UserInfoPopup PIC 검색(div=82): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (UserInfoPopup PIC 검색(div=82)) |
| WK-SCP0080-0169 | H5 | spd40 / spd81 / spdEtc(FpSpread 3종) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — spd40 / spd81 / spdEtc(FpSpread 3종): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (spd40 / spd81 / spdEtc(FpSpread 3종)) |
| WK-SCP0080-0170 | H5 | spdMain_KeyPress R-KEYBLOCK(RTFGubun 셀 직 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — spdMain_KeyPress R-KEYBLOCK(RTFGubun 셀 직접입력 차단): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (spdMain_KeyPress R-KEYBLOCK(RTFGubun 셀 직) |
| WK-SCP0080-0171 | H5 | 컬럼 메타 (division 별 40/81계열/82 레이아웃) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 컬럼 메타 (division 별 40/81계열/82 레이아웃): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (컬럼 메타 (division 별 40/81계열/82 레이아웃)) |
| WK-SCP0080-0172 | SC1 | SCP0080 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | SC1 기대값 확정 — SCP0080 화면: 게이트 SC1 조회조건 순서가 기준표(SCP SCP_화면별 조회조건 정리_260731_ |  | 6 (Division (BLUtils.GetDivisionWithoutEE) ) |
| WK-SCP0080-0173 | X-REASON | COMMON:UC-01 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-01 필터링 상태에서 신규행 Insert 시 필터 유지(keepRowVisibleUnderFilter — 필터 clear 금지) — 해당없음: INSERT 무동작(AS-IS 미구현, |  | 1 (COMMON:UC-01) |
| WK-SCP0080-0174 | X-REASON | COMMON:UC-03 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-03 컬럼 추가/제외(Column/Measure 설정) 적용 시 Reset 후 재조회 — 해당없음: Column/Measure 설정 UI(ColumnLayoutModal/Measur |  | 1 (COMMON:UC-03) |
| WK-SCP0080-0175 | X-REASON | MANUAL/UPLOAD | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — MANUAL/UPLOAD 없음 false 해당없음 |  | 1 (MANUAL/UPLOAD) |
| WK-SCP0080-0176 | D1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — COMMON:UC-02: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0080-0177 | D1 | EDIT | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — EDIT: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (EDIT) |
| WK-SCP0080-0178 | D1 | SAVE | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SAVE: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (SAVE) |
| WK-SCP0080-0179 | D1 | SCP0080_GroupCodeManagement.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SCP0080_GroupCodeManagement.EditButton: 진입점 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 11 (ACT:SCP0080_GroupCodeManagement.EditButt) |
| WK-SCP0080-0180 | D3 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — COMMON:UC-02: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0080-0181 | D3 | EDIT | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — EDIT: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (EDIT) |
| WK-SCP0080-0182 | D3 | SAVE | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SAVE: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (SAVE) |
| WK-SCP0080-0183 | D3 | SCP0080_GroupCodeManagement.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SCP0080_GroupCodeManagement.EditButton: 진입점 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 11 (ACT:SCP0080_GroupCodeManagement.EditButt) |
| WK-SCP0080-0184 | E4 | SCP0080_GroupCodeManagement.SetChangedCo | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0080_GroupCodeManagement.SetChangedControl: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0080_GroupCodeManagement.SetChang) |
| WK-SCP0080-0185 | E4 | SCP0080_GroupCodeManagement.SetColumnCon | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0080_GroupCodeManagement.SetColumnCondition81: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0080_GroupCodeManagement.SetColum) |
| WK-SCP0080-0186 | E4 | SCP0080_GroupCodeManagement.SetLockColum | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0080_GroupCodeManagement.SetLockColumns: 진입점 집계 — E4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0080_GroupCodeManagement.SetLockC) |
| WK-SCP0080-0187 | E4 | SCP0080_GroupCodeManagement.SetNotEitabl | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0080_GroupCodeManagement.SetNotEitableColumns: 진입점 집계 — E4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0080_GroupCodeManagement.SetNotEi) |
| WK-SCP0080-0188 | E4 | SCP0080_GroupCodeManagement.SetNotEitabl | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0080_GroupCodeManagement.SetNotEitableColumns40: 진입점 집계 — E4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0080_GroupCodeManagement.SetNotEi) |
| WK-SCP0080-0189 | E4 | SCP0080_GroupCodeManagement.SetNotEitabl | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0080_GroupCodeManagement.SetNotEitableColumns81: 진입점 집계 — E4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0080_GroupCodeManagement.SetNotEi) |
| WK-SCP0080-0190 | E4 | SCP0080_GroupCodeManagement.SetNotEitabl | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0080_GroupCodeManagement.SetNotEitableColumns82: 진입점 집계 — E4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0080_GroupCodeManagement.SetNotEi) |
| WK-SCP0080-0191 | E4 | SCP0080_GroupCodeManagement.SetQueryInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0080_GroupCodeManagement.SetQueryInfoGet: 진입점 집계 — E4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 14 (ACT:SCP0080_GroupCodeManagement.SetQuery) |
| WK-SCP0080-0192 | E4 | SCP0080_GroupCodeManagement.SetQueryInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0080_GroupCodeManagement.SetQueryInfoSave: 진입점 집계 — E4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 43 (ACT:SCP0080_GroupCodeManagement.SetQuery) |
| WK-SCP0080-0193 | E4 | SCP0080_GroupCodeManagement.SetVisibleSh | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0080_GroupCodeManagement.SetVisibleSheet: 진입점 집계 — E4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 22 (ACT:SCP0080_GroupCodeManagement.SetVisib) |
| WK-SCP0080-0194 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (COMMON:UC-02) |
| WK-SCP0080-0195 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (COMMON:UC-06) |
| WK-SCP0080-0196 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (COMMON:UC-07) |
| WK-SCP0080-0197 | A1 | Division (BLUtils.GetDivisionWithoutEE) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Division (BLUtils.GetDivisionWithoutEE): 행 집계 — A1 2요소: REVIEW:2 |  | 1 (Division (BLUtils.GetDivisionWithoutEE)) |
| WK-SCP0080-0198 | A1 | FCST/Production/Active/BOM Y/N | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FCST/Production/Active/BOM Y/N: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (FCST/Production/Active/BOM Y/N) |
| WK-SCP0080-0199 | A1 | Model → p_model_id | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Model → p_model_id: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (Model → p_model_id) |
| WK-SCP0080-0200 | A1 | NickName → p_nick_name | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — NickName → p_nick_name: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (NickName → p_nick_name) |
| WK-SCP0080-0201 | A1 | Operation (Data_SCP.Common OperationForP | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Operation (Data_SCP.Common OperationForPlanDivisio: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (Operation (Data_SCP.Common OperationForP) |
| WK-SCP0080-0202 | A1 | PKG_SCP0080 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0080: 골든 비교 케이스 없음(PKG_SCP0080 — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (SCP0050_GET_CAPA_PIC_USERINFO_POPUP (Che) |
| WK-SCP0080-0203 | A1 | PKG_SCP0080.P_SCP0050_GET_CAPA_PIC_USERI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0080.P_SCP0050_GET_CAPA_PIC_USERINFO_POPUP: 골든 비교 케이스 없음(PKG_SCP0080.P_SCP0050_GET_CAPA_PIC_USERINFO_POPUP — 팝업 |  | 1 (SCP0050_GET_CAPA_PIC_USERINFO_POPUP (Che) |
| WK-SCP0080-0204 | A1 | SCP0080_GroupCodeManagement.AfterFindDat | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0080_GroupCodeManagement.AfterFindData: 진입점 집계 — A1 2요소: REVIEW:2 |  | 1 (ACT:SCP0080_GroupCodeManagement.AfterFin) |
| WK-SCP0080-0205 | A1 | SCP0080_GroupCodeManagement.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0080_GroupCodeManagement.FindButton: 진입점 집계 — A1 2요소: REVIEW:2 |  | 2 (ACT:SCP0080_GroupCodeManagement.FindButt) |
| WK-SCP0080-0206 | A1 | SCP0080_GroupCodeManagement.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0080_GroupCodeManagement.FindData: 진입점 집계 — A1 2요소: REVIEW:2 |  | 2 (ACT:SCP0080_GroupCodeManagement.FindData) |
| WK-SCP0080-0207 | A1 | SCP0080_GroupCodeManagement.FindDataMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0080_GroupCodeManagement.FindDataMain: 진입점 집계 — A1 2요소: REVIEW:2 |  | 2 (ACT:SCP0080_GroupCodeManagement.FindData) |
| WK-SCP0080-0208 | A1 | SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SEARCH: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (SEARCH) |
| WK-SCP0080-0209 | A6 | SCP0080_GroupCodeManagement.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — SCP0080_GroupCodeManagement.FindButton: 진입점 집계 — A6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0080_GroupCodeManagement.FindButt) |
| WK-SCP0080-0210 | A6 | SCP0080_GroupCodeManagement.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — SCP0080_GroupCodeManagement.FindData: 진입점 집계 — A6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0080_GroupCodeManagement.FindData) |
| WK-SCP0080-0211 | A6 | SCP0080_GroupCodeManagement.FindDataMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — SCP0080_GroupCodeManagement.FindDataMain: 진입점 집계 — A6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0080_GroupCodeManagement.FindData) |
| WK-SCP0080-0212 | G03-WIRE | SCP0080 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G03-WIRE 기대값 확정 — SCP0080 화면: 게이트 G03 As-is 이벤트 this.Load → Form_Load 매핑표 §2 에 / 게이트 G03 As-is 이벤트 cboDivision.SelectedIndexChang  |  | 17 (ACT:SCP0080_GroupCodeManagement..ctor AC) |
| WK-SCP0080-0213 | G6 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — COMMON:UC-06: 행 집계 — G6 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0080-0214 | G6 | Division (BLUtils.GetDivisionWithoutEE) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — Division (BLUtils.GetDivisionWithoutEE): 행 집계 — G6 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (Division (BLUtils.GetDivisionWithoutEE)) |
| WK-SCP0080-0215 | G6 | FCST/Production/Active/BOM Y/N | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — FCST/Production/Active/BOM Y/N: 행 집계 — G6 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (FCST/Production/Active/BOM Y/N) |
| WK-SCP0080-0216 | G6 | Model → p_model_id | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — Model → p_model_id: 행 집계 — G6 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (Model → p_model_id) |
| WK-SCP0080-0217 | G6 | NickName → p_nick_name | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — NickName → p_nick_name: 행 집계 — G6 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (NickName → p_nick_name) |
| WK-SCP0080-0218 | G6 | Operation (Data_SCP.Common OperationForP | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — Operation (Data_SCP.Common OperationForPlanDivisio: 행 집계 — G6 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (Operation (Data_SCP.Common OperationForP) |
| WK-SCP0080-0219 | X-LOC | chkActive/BOM (Visible=false) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — chkActive/BOM (Visible=false): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (chkActive/BOM (Visible=false)) |
| WK-SCP0080-0220 | X-LOC | spd40 / spd81 / spdEtc(FpSpread 3종) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — spd40 / spd81 / spdEtc(FpSpread 3종): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (spd40 / spd81 / spdEtc(FpSpread 3종)) |
| WK-SCP0080-0221 | X-ROW | EXCEL | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EXCEL: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (EXCEL) |
| WK-SCP0080-0222 | X-ROW | SCP0080_GroupCodeManagement.AfterFindDat | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0080_GroupCodeManagement.AfterFindData: 진입점 집계 1검사 — NOPATH:1 (미실행 검사가 남아 판정필요) |  | 9 (ACT:SCP0080_GroupCodeManagement.AfterFin) |
| WK-SCP0080-0223 | X-ROW | SCP0080_GroupCodeManagement.AfterSaveDat | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0080_GroupCodeManagement.AfterSaveData: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0080_GroupCodeManagement.AfterSav) |
| WK-SCP0080-0224 | X-ROW | SCP0080_GroupCodeManagement.AlarmByStatu | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0080_GroupCodeManagement.AlarmByStatusMass: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 13 (ACT:SCP0080_GroupCodeManagement.AlarmByS) |
| WK-SCP0080-0225 | X-ROW | SCP0080_GroupCodeManagement.ChangeColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0080_GroupCodeManagement.ChangeColumnTitle: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/GRID_SET, 연결된 요소 검사 없음 |  | 2 (ACT:SCP0080_GroupCodeManagement.ChangeCo) |
| WK-SCP0080-0226 | X-ROW | SCP0080_GroupCodeManagement.CheckChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0080_GroupCodeManagement.CheckChangedValues: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 198 (ACT:SCP0080_GroupCodeManagement.CheckCha) |
| WK-SCP0080-0227 | X-ROW | SCP0080_GroupCodeManagement.CheckValidBa | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0080_GroupCodeManagement.CheckValidBasicEndCust: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/ENTRY/EXPR/LOCAL/RE |  | 9 (ACT:SCP0080_GroupCodeManagement.CheckVal) |
| WK-SCP0080-0228 | X-ROW | SCP0080_GroupCodeManagement.CheckValidSa | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0080_GroupCodeManagement.CheckValidSalesModel: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/DATA_OP/ENTRY/EXPR/LOCAL/RET |  | 11 (ACT:SCP0080_GroupCodeManagement.CheckVal) |
| WK-SCP0080-0229 | X-ROW | SCP0080_GroupCodeManagement.CheckValidSa | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0080_GroupCodeManagement.CheckValidSalesModelPr: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY/EXPR/LOCAL/RETURN, 연 |  | 9 (ACT:SCP0080_GroupCodeManagement.CheckVal) |
| WK-SCP0080-0230 | X-ROW | SCP0080_GroupCodeManagement.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0080_GroupCodeManagement.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0080_GroupCodeManagement.CreateSp) |
| WK-SCP0080-0231 | X-ROW | SCP0080_GroupCodeManagement.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0080_GroupCodeManagement.EditButton: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0080_GroupCodeManagement.EditButt) |
| WK-SCP0080-0232 | X-ROW | SCP0080_GroupCodeManagement.ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0080_GroupCodeManagement.ExcelButton: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_BASE/ENTRY, 연결된 요소 검사 없음 |  | 2 (ACT:SCP0080_GroupCodeManagement.ExcelBut) |
| WK-SCP0080-0233 | X-ROW | SCP0080_GroupCodeManagement.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0080_GroupCodeManagement.FindButton: 진입점 집계 4검사 — NOPATH:2 · NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0080_GroupCodeManagement.FindButt) |
| WK-SCP0080-0234 | X-ROW | SCP0080_GroupCodeManagement.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0080_GroupCodeManagement.FindData: 진입점 집계 4검사 — NOPATH:2 · NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0080_GroupCodeManagement.FindData) |
| WK-SCP0080-0235 | X-ROW | SCP0080_GroupCodeManagement.FindDataMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0080_GroupCodeManagement.FindDataMain: 진입점 집계 5검사 — NOPATH:3 · NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0080_GroupCodeManagement.FindData) |
| WK-SCP0080-0236 | X-ROW | SCP0080_GroupCodeManagement.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0080_GroupCodeManagement.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0080_GroupCodeManagement.Form_Loa) |
| WK-SCP0080-0237 | X-ROW | SCP0080_GroupCodeManagement.GetColumnVal | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0080_GroupCodeManagement.GetColumnValue: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0080_GroupCodeManagement.GetColum) |
| WK-SCP0080-0238 | X-ROW | SCP0080_GroupCodeManagement.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0080_GroupCodeManagement.InitControls: 진입점 집계 13검사 — NOT_RUN:13 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SCP0080_GroupCodeManagement.InitCont) |
| WK-SCP0080-0239 | X-ROW | SCP0080_GroupCodeManagement.InitQueryDic | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0080_GroupCodeManagement.InitQueryDics: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0080_GroupCodeManagement.InitQuer) |
| WK-SCP0080-0240 | X-ROW | SCP0080_GroupCodeManagement.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0080_GroupCodeManagement.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0080_GroupCodeManagement.InitSpre) |
| WK-SCP0080-0241 | X-ROW | SCP0080_GroupCodeManagement.InitSpread40 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0080_GroupCodeManagement.InitSpread40: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0080_GroupCodeManagement.InitSpre) |
| WK-SCP0080-0242 | X-ROW | SCP0080_GroupCodeManagement.InitSpread81 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0080_GroupCodeManagement.InitSpread81: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0080_GroupCodeManagement.InitSpre) |
| WK-SCP0080-0243 | X-ROW | SCP0080_GroupCodeManagement.InitSpread82 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0080_GroupCodeManagement.InitSpread82: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0080_GroupCodeManagement.InitSpre) |
| WK-SCP0080-0244 | X-ROW | SCP0080_GroupCodeManagement.InitSpreadEt | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0080_GroupCodeManagement.InitSpreadEtc: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0080_GroupCodeManagement.InitSpre) |
| WK-SCP0080-0245 | X-ROW | SCP0080_GroupCodeManagement.InitSpreadMa | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0080_GroupCodeManagement.InitSpreadMain: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0080_GroupCodeManagement.InitSpre) |
| WK-SCP0080-0246 | X-ROW | SCP0080_GroupCodeManagement.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0080_GroupCodeManagement.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0080_GroupCodeManagement.InsertBu) |
| WK-SCP0080-0247 | X-ROW | SCP0080_GroupCodeManagement.IsESSEdit | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0080_GroupCodeManagement.IsESSEdit: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/EXPR/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 9 (ACT:SCP0080_GroupCodeManagement.IsESSEdi) |
| WK-SCP0080-0248 | X-ROW | SCP0080_GroupCodeManagement.SaveData_Mai | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0080_GroupCodeManagement.SaveData_Main: 진입점 집계 6검사 — NOT_RUN:3 · NOPATH:2 · REVIEW:1 |  | 1 (ACT:SCP0080_GroupCodeManagement.SaveData) |
| WK-SCP0080-0249 | X-ROW | SCP0080_GroupCodeManagement.SetChangedCo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0080_GroupCodeManagement.SetChangedControl: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:2 |  | 1 (ACT:SCP0080_GroupCodeManagement.SetChang) |
| WK-SCP0080-0250 | X-ROW | SCP0080_GroupCodeManagement.SetLockColum | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0080_GroupCodeManagement.SetLockColumns: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0080_GroupCodeManagement.SetLockC) |
| WK-SCP0080-0251 | X-ROW | SCP0080_GroupCodeManagement.SetNotEitabl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0080_GroupCodeManagement.SetNotEitableColumns: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0080_GroupCodeManagement.SetNotEi) |
| WK-SCP0080-0252 | X-ROW | SCP0080_GroupCodeManagement.SetNotEitabl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0080_GroupCodeManagement.SetNotEitableColumns40: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0080_GroupCodeManagement.SetNotEi) |
| WK-SCP0080-0253 | X-ROW | SCP0080_GroupCodeManagement.SetNotEitabl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0080_GroupCodeManagement.SetNotEitableColumns81: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0080_GroupCodeManagement.SetNotEi) |
| WK-SCP0080-0254 | X-ROW | SCP0080_GroupCodeManagement.SetNotEitabl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0080_GroupCodeManagement.SetNotEitableColumns82: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0080_GroupCodeManagement.SetNotEi) |
| WK-SCP0080-0255 | X-ROW | SCP0080_GroupCodeManagement.SetQueryInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0080_GroupCodeManagement.SetQueryInfoGet: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0080_GroupCodeManagement.SetQuery) |
| WK-SCP0080-0256 | X-ROW | SCP0080_GroupCodeManagement.SetQueryInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0080_GroupCodeManagement.SetQueryInfoSave: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0080_GroupCodeManagement.SetQuery) |
| WK-SCP0080-0257 | X-ROW | SCP0080_GroupCodeManagement.SetSheetLock | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0080_GroupCodeManagement.SetSheetLock: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/GRID_LOCK, 연결된 요소 검사 없음 |  | 2 (ACT:SCP0080_GroupCodeManagement.SetSheet) |
| WK-SCP0080-0258 | X-ROW | SCP0080_GroupCodeManagement.SetVisibleSh | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0080_GroupCodeManagement.SetVisibleSheet: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 15 (ACT:SCP0080_GroupCodeManagement.SetVisib) |
| WK-SCP0080-0259 | X-ROW | SCP0080_GroupCodeManagement.SpdMain_Chan | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0080_GroupCodeManagement.SpdMain_Change: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY/EXPR/RETURN, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0080_GroupCodeManagement.SpdMain_) |
| WK-SCP0080-0260 | X-ROW | SCP0080_GroupCodeManagement.cboDivision_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0080_GroupCodeManagement.cboDivision_SelectedIn: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0080_GroupCodeManagement.cboDivis) |
| WK-SCP0080-0261 | X-ROW | SCP0080_GroupCodeManagement.spdMain_Cell | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0080_GroupCodeManagement.spdMain_CellDoubleClic: 진입점 집계 12검사 — NOT_RUN:10 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 15 (ACT:SCP0080_GroupCodeManagement.spdMain_) |
| WK-SCP0080-0262 | X-ROW | SCP0080_GroupCodeManagement.spdMain_KeyP | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0080_GroupCodeManagement.spdMain_KeyPress: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY/UI_PROP, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0080_GroupCodeManagement.spdMain_) |
| WK-SCP0080-0263 | X-ROW | cboDivision(단일 필수) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — cboDivision(단일 필수): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (cboDivision(단일 필수)) |
| WK-SCP0080-0264 | X-ROW | chkFCST/Production | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — chkFCST/Production: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (chkFCST/Production) |
| WK-SCP0080-0265 | X-ROW | clbOperation(다중 체크리스트) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — clbOperation(다중 체크리스트): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (clbOperation(다중 체크리스트)) |
| WK-SCP0080-0266 | X-ROW | txtModel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — txtModel: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (txtModel) |
| WK-SCP0080-0267 | X-ROW | txtNickname | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — txtNickname: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (txtNickname) |
| WK-SCP0080-0268 | G5 | MSG00251 PIC 미검증(line 1436) → TO-BE MSG0 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MSG00251 PIC 미검증(line 1436) → TO-BE MSG01261(SSP P: 행 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (MSG00251 PIC 미검증(line 1436) → TO-BE MSG0) |
| WK-SCP0080-0269 | G5 | SCP0050_GET_CAPA_PIC_USERINFO_POPUP (Che | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCP0050_GET_CAPA_PIC_USERINFO_POPUP (CheckUser lin: 행 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (SCP0050_GET_CAPA_PIC_USERINFO_POPUP (Che) |
| WK-SCP0080-0270 | G5 | SCP0080_GroupCodeManagement.spdMain_Cell | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCP0080_GroupCodeManagement.spdMain_CellDoubleClic: 진입점 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0080_GroupCodeManagement.spdMain_) |
| WK-SCP0080-0271 | G5 | UserInfoPopup PIC 검색(div=82) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — UserInfoPopup PIC 검색(div=82): 행 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (UserInfoPopup PIC 검색(div=82)) |
| WK-SCP0080-0272 | H6 | MSG00251 PIC 미검증(line 1436) → TO-BE MSG0 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MSG00251 PIC 미검증(line 1436) → TO-BE MSG01261(SSP P: 행 집계 — H6 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (MSG00251 PIC 미검증(line 1436) → TO-BE MSG0) |
| WK-SCP0080-0273 | H6 | SCP0050_GET_CAPA_PIC_USERINFO_POPUP (Che | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCP0050_GET_CAPA_PIC_USERINFO_POPUP (CheckUser lin: 행 집계 — H6 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (SCP0050_GET_CAPA_PIC_USERINFO_POPUP (Che) |
| WK-SCP0080-0274 | H6 | SCP0080_GroupCodeManagement.spdMain_Cell | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCP0080_GroupCodeManagement.spdMain_CellDoubleClic: 진입점 집계 — H6 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0080_GroupCodeManagement.spdMain_) |
| WK-SCP0080-0275 | H6 | UserInfoPopup PIC 검색(div=82) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — UserInfoPopup PIC 검색(div=82): 행 집계 — H6 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (UserInfoPopup PIC 검색(div=82)) |
| WK-SCP0080-0276 | M4 | MSG00251 PIC 미검증(line 1436) → TO-BE MSG0 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MSG00251 PIC 미검증(line 1436) → TO-BE MSG01261(SSP P: 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (MSG00251 PIC 미검증(line 1436) → TO-BE MSG0) |
| WK-SCP0080-0277 | M4 | SCP0050_GET_CAPA_PIC_USERINFO_POPUP (Che | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0050_GET_CAPA_PIC_USERINFO_POPUP (CheckUser lin: 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (SCP0050_GET_CAPA_PIC_USERINFO_POPUP (Che) |
| WK-SCP0080-0278 | M4 | SCP0080_GroupCodeManagement.spdMain_Cell | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0080_GroupCodeManagement.spdMain_CellDoubleClic: 진입점 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0080_GroupCodeManagement.spdMain_) |
| WK-SCP0080-0279 | M4 | UserInfoPopup PIC 검색(div=82) | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — UserInfoPopup PIC 검색(div=82): 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (UserInfoPopup PIC 검색(div=82)) |
