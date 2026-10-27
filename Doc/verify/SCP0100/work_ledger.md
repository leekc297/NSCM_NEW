# 작업 원장 — SCP0100 · 2026-10-26 12:54

> 검사 인스턴스 527건 중 PASS·NA 97건 외 **430건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 5 | 구현 위치 실존 |
| W3 | 동작 수정 | 1 | 재판정 PASS |
| W4 | 검사기 구현 | 14 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 36 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 85 | 실행 → PASS |
| W7 | 기대값 확정 | 289 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 284 · E2E 85 · 하네스 50 · 대조표 10 · FE 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 5건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 70 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| A1 | GEN |  |  |  |  |  |  | 36 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| B3 | COMBO |  |  |  | 14 |  |  | 19 |  |  | 콤보 후보 정렬 = AS-IS |
| B4 | COMBO |  |  |  |  | 14 |  | 19 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| X-LOC | GEN |  | 5 |  |  |  |  | 21 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| G1 | GEN |  |  |  |  |  | 8 | 18 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G6 | GEN |  |  |  |  |  | 13 | 11 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| G5 | POPUP |  |  |  |  | 10 |  | 12 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 2 | 8 | 12 |  |  | 팝업 표준·열림 |
| M4 | POPUP |  |  |  |  |  | 10 | 12 |  |  | 팝업 선택값 반영 |
| C3 | CASCADE |  |  |  |  |  | 2 | 14 |  |  | 연쇄 자동 채움 |
| G4 | DESIGN |  |  |  |  | 4 |  | 11 |  |  | 조회조건 표시·라벨·활성 |
| F4 | DB |  |  |  |  |  | 11 | 2 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| E4 | EDIT |  |  |  |  |  | 4 | 9 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| C1 | CASCADE |  |  |  |  |  | 9 | 1 |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| A6 | GEN |  |  |  |  |  | 10 |  |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| H2 | DESIGN |  |  |  |  |  | 2 | 7 |  |  | 배경·글자색 규칙 |
| DB-SYN | DB |  |  |  |  | 5 |  | 2 |  |  | BE 계정 시노님·권한·대상 객체 |
| H5 | DESIGN |  |  |  |  |  | 1 | 6 |  |  | 라벨 명칭 |
| X-REASON | DESIGN |  |  |  |  |  |  | 5 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| H10 | DESIGN |  |  | 1 |  |  |  |  |  |  | 메시지 표준(방식·코드 단일화) |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| I1 | DESIGN |  |  |  |  |  |  | 1 |  |  | LBL/MSG 언어별 등록 |
| G03-WIRE | GEN |  |  |  |  |  |  | 1 |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |

## W2 구현 위치 확인 (5)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0100-0001 | X-LOC | COMMON:UC-05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-05) |
| WK-SCP0100-0002 | X-LOC | ExcelButton | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (ExcelButton) |
| WK-SCP0100-0003 | X-LOC | FindButton | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (FindButton) |
| WK-SCP0100-0004 | X-LOC | SaveButton/InsertButton/DeleteButton/Man | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SaveButton/InsertButton/DeleteButton/Man) |
| WK-SCP0100-0005 | X-LOC | usrButton1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (usrButton1) |

## W3 동작 수정 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0100-0006 | H10 | SCP0100 화면 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | H10 FAIL 수정 — SCP0100 화면: 표준 메시지 대신 브라우저 alert/confirm 직접 호출: components/GlobalPsiReportForm.tsx |  | 4 (COMMON:UC-03 COMMON:UC-05 COMMON:UC-06 C) |

## W4 검사기 구현 (14)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0100-0007 | B3 | cboBucketType / Bucket / Bucket Type | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 2 (ACT:SCP0100_Global_PSI_Report.getBucketT) |
| WK-SCP0100-0008 | B3 | cboDisplay / Display | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboDisplay / Display | 있음(FE 소스) | 1 (cboDisplay) |
| WK-SCP0100-0009 | B3 | cboPlanDate / Plan date / Plan Date | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboPlanDate / Plan date / Plan Date | 있음(FE 소스) | 6 (ACT:SCP0100_Global_PSI_Report.GetDayRang) |
| WK-SCP0100-0010 | B3 | cboPlanType / Plan-type / Plan Type | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboPlanType / Plan-type / Plan Type | 있음(FE 소스) | 3 (cboPlanType ACT:SCP0100_Global_PSI_Repor) |
| WK-SCP0100-0011 | B3 | cboSearchLevel / Search Level | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboSearchLevel / Search Level | 있음(FE 소스) | 3 (cboSearchLevel ACT:SCP0100_Global_PSI_Re) |
| WK-SCP0100-0012 | B3 | chkAS / A/S / AS | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 chkAS / A/S / AS | 있음(FE 소스) | 2 (ACT:SCP0100_Global_PSI_Report.getAS ACT:) |
| WK-SCP0100-0013 | B3 | chkCellQty / Cell Qty | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 chkCellQty / Cell Qty | 있음(FE 소스) | 2 (ACT:SCP0100_Global_PSI_Report.getCellQty) |
| WK-SCP0100-0014 | B3 | clbDivision / Div / Division / Div. | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbDivision / Div / Division / Div. | 있음(FE 소스) | 2 (ACT:SCP0100_Global_PSI_Report.getDivisio) |
| WK-SCP0100-0015 | B3 | clbFromSite / From Site | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbFromSite / From Site | 있음(FE 소스) | 2 (ACT:SCP0100_Global_PSI_Report.getFromSit) |
| WK-SCP0100-0016 | B3 | clbToSite / To Site | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbToSite / To Site | 있음(FE 소스) | 2 (ACT:SCP0100_Global_PSI_Report.getToSite ) |
| WK-SCP0100-0017 | B3 | rgrpSearchLevel / Search Level / Search  | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 rgrpSearchLevel / Search Level / Search Mode | 있음(FE 소스) | 2 (ACT:SCP0100_Global_PSI_Report.getIsDetai) |
| WK-SCP0100-0018 | B3 | txtCellGroup / Cell Group | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 txtCellGroup / Cell Group | 있음(FE 소스) | 2 (ACT:SCP0100_Global_PSI_Report.getCellGro) |
| WK-SCP0100-0019 | B3 | txtItemId / Model / Nick Name / Item Id  | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 txtItemId / Model / Nick Name / Item Id / Model/Ni | 있음(FE 소스) | 2 (ACT:SCP0100_Global_PSI_Report.getItemId ) |
| WK-SCP0100-0020 | B3 | txtProject / Project / PJT | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 txtProject / Project / PJT | 있음(FE 소스) | 2 (ACT:SCP0100_Global_PSI_Report.getProject) |

## W5 검사기 연결 (36)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0100-0021 | B4 | cboBucketType / Bucket / Bucket Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 2 (ACT:SCP0100_Global_PSI_Report.getBucketT) |
| WK-SCP0100-0022 | B4 | cboDisplay / Display | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDisplay / Display | 있음(FE 소스) | 1 (cboDisplay) |
| WK-SCP0100-0023 | B4 | cboPlanDate / Plan date / Plan Date | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboPlanDate / Plan date / Plan Date | 있음(FE 소스) | 6 (ACT:SCP0100_Global_PSI_Report.GetDayRang) |
| WK-SCP0100-0024 | B4 | cboPlanType / Plan-type / Plan Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboPlanType / Plan-type / Plan Type | 있음(FE 소스) | 3 (cboPlanType ACT:SCP0100_Global_PSI_Repor) |
| WK-SCP0100-0025 | B4 | cboSearchLevel / Search Level | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboSearchLevel / Search Level | 있음(FE 소스) | 3 (cboSearchLevel ACT:SCP0100_Global_PSI_Re) |
| WK-SCP0100-0026 | B4 | chkAS / A/S / AS | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND chkAS / A/S / AS | 있음(FE 소스) | 2 (ACT:SCP0100_Global_PSI_Report.getAS ACT:) |
| WK-SCP0100-0027 | B4 | chkCellQty / Cell Qty | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND chkCellQty / Cell Qty | 있음(FE 소스) | 2 (ACT:SCP0100_Global_PSI_Report.getCellQty) |
| WK-SCP0100-0028 | B4 | clbDivision / Div / Division / Div. | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbDivision / Div / Division / Div. | 있음(FE 소스) | 2 (ACT:SCP0100_Global_PSI_Report.getDivisio) |
| WK-SCP0100-0029 | B4 | clbFromSite / From Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbFromSite / From Site | 있음(FE 소스) | 2 (ACT:SCP0100_Global_PSI_Report.getFromSit) |
| WK-SCP0100-0030 | B4 | clbToSite / To Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbToSite / To Site | 있음(FE 소스) | 2 (ACT:SCP0100_Global_PSI_Report.getToSite ) |
| WK-SCP0100-0031 | B4 | rgrpSearchLevel / Search Level / Search  | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND rgrpSearchLevel / Search Level / Search Mode | 있음(FE 소스) | 2 (ACT:SCP0100_Global_PSI_Report.getIsDetai) |
| WK-SCP0100-0032 | B4 | txtCellGroup / Cell Group | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND txtCellGroup / Cell Group | 있음(FE 소스) | 2 (ACT:SCP0100_Global_PSI_Report.getCellGro) |
| WK-SCP0100-0033 | B4 | txtItemId / Model / Nick Name / Item Id  | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND txtItemId / Model / Nick Name / Item Id / Model/Ni | 있음(FE 소스) | 2 (ACT:SCP0100_Global_PSI_Report.getItemId ) |
| WK-SCP0100-0034 | B4 | txtProject / Project / PJT | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND txtProject / Project / PJT | 있음(FE 소스) | 2 (ACT:SCP0100_Global_PSI_Report.getProject) |
| WK-SCP0100-0035 | F2 | SCP0100 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0100 화면 | 판단불가(대상 단위 SCREEN) | 3 (CA-104 COMMON:UC-03 SaveButton/InsertBut) |
| WK-SCP0100-0036 | DB-SYN | P_BUCKET | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_BUCKET | 없음(PROC_M 대응 없음) | 1 (cboBucket) |
| WK-SCP0100-0037 | DB-SYN | P_FROM_SITE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_FROM_SITE | 없음(PROC_M 대응 없음) | 1 (cboFromSite) |
| WK-SCP0100-0038 | DB-SYN | P_PLAN_START_YYYYMMDD | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_PLAN_START_YYYYMMDD | 없음(PROC_M 대응 없음) | 1 (cboPlanDate) |
| WK-SCP0100-0039 | DB-SYN | P_SCM0002 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SCM0002 | 없음(PROC_M 대응 없음) | 1 (MODAL:ItemByDivisionModal) |
| WK-SCP0100-0040 | DB-SYN | P_TO_SITE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_TO_SITE | 없음(PROC_M 대응 없음) | 1 (cboToSite) |
| WK-SCP0100-0041 | G4 | btnColumn | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnColumn | 있음(FE 소스) | 2 (ACT:SCP0100_Global_PSI_Report.InitEvent ) |
| WK-SCP0100-0042 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 있음(FE 소스) | 3 (txtItemId ACT:SCP0100_Global_PSI_Report.) |
| WK-SCP0100-0043 | G4 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnMeasure | 있음(FE 소스) | 2 (ACT:SCP0100_Global_PSI_Report.InitEvent ) |
| WK-SCP0100-0044 | G4 | btnProject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnProject | 있음(FE 소스) | 3 (txtProject ACT:SCP0100_Global_PSI_Report) |
| WK-SCP0100-0045 | G5 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnItemId | 있음(FE 소스) | 2 (MODAL:ItemByDivisionModal txtItemId) |
| WK-SCP0100-0046 | G5 | btnProject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnProject | 있음(FE 소스) | 2 (MODAL:ProjectByDivisionModal txtProject) |
| WK-SCP0100-0047 | G5 | cboDisplay / Display | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND cboDisplay / Display | 있음(FE 소스) | 1 (cboDisplay) |
| WK-SCP0100-0048 | G5 | cboPlanDate / Plan date / Plan Date | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND cboPlanDate / Plan date / Plan Date | 있음(FE 소스) | 1 (cboPlanDate) |
| WK-SCP0100-0049 | G5 | cboPlanType / Plan-type / Plan Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND cboPlanType / Plan-type / Plan Type | 있음(FE 소스) | 1 (cboPlanType) |
| WK-SCP0100-0050 | G5 | cboSearchLevel / Search Level | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND cboSearchLevel / Search Level | 있음(FE 소스) | 1 (cboSearchLevel) |
| WK-SCP0100-0051 | G5 | chkAS / A/S / AS | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND chkAS / A/S / AS | 있음(FE 소스) | 1 (chkAS) |
| WK-SCP0100-0052 | G5 | chkCellQty / Cell Qty | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND chkCellQty / Cell Qty | 있음(FE 소스) | 1 (chkCellQty) |
| WK-SCP0100-0053 | G5 | txtItemId / Model / Nick Name / Item Id  | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND txtItemId / Model / Nick Name / Item Id / Model/Ni | 있음(FE 소스) | 2 (CB-112 txtItemId) |
| WK-SCP0100-0054 | G5 | txtProject / Project / PJT | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND txtProject / Project / PJT | 있음(FE 소스) | 2 (CB-114 txtProject) |
| WK-SCP0100-0055 | H6 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnItemId | 있음(FE 소스) | 2 (MODAL:ItemByDivisionModal txtItemId) |
| WK-SCP0100-0056 | H6 | btnProject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnProject | 있음(FE 소스) | 2 (MODAL:ProjectByDivisionModal txtProject) |

## W6 검증 실행 (85)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0100-0057 | C1 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0100_Global_PSI_Report.InitContro) |
| WK-SCP0100-0058 | C1 | cboDisplay / Display | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDisplay / Display · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0100_Global_PSI_Report.RefreshDis) |
| WK-SCP0100-0059 | C1 | cboPlanDate / Plan date / Plan Date | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboPlanDate / Plan date / Plan Date · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:SCP0100_Global_PSI_Report.InitContro) |
| WK-SCP0100-0060 | C1 | cboPlanType / Plan-type / Plan Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboPlanType / Plan-type / Plan Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0100_Global_PSI_Report.RefreshPla) |
| WK-SCP0100-0061 | C1 | cboSearchLevel / Search Level | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboSearchLevel / Search Level · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0100_Global_PSI_Report.RefreshSea) |
| WK-SCP0100-0062 | C1 | cboUnitQty / Unit (Qty) / Unit Qty / Sca | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboUnitQty / Unit (Qty) / Unit Qty / Scale / Unit · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0100_Global_PSI_Report.InitContro) |
| WK-SCP0100-0063 | C1 | clbDivision / Div / Division / Div. | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbDivision / Div / Division / Div. · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0100_Global_PSI_Report.InitContro) |
| WK-SCP0100-0064 | C1 | clbFromSite / From Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbFromSite / From Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0100_Global_PSI_Report.RefreshFro) |
| WK-SCP0100-0065 | C1 | clbToSite / To Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbToSite / To Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0100_Global_PSI_Report.RefreshToS) |
| WK-SCP0100-0066 | C3 | COLUMN_LABEL_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — COLUMN_LABEL_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCP0100_Global_PSI_Report.SetBackCol) |
| WK-SCP0100-0067 | C3 | DAY_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DAY_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCP0100_Global_PSI_Report.SetBackCol) |
| WK-SCP0100-0068 | G3 | SCP0100 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0100 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 4 (COMMON:UC-03 COMMON:UC-05 COMMON:UC-06 C) |
| WK-SCP0100-0069 | K4 | SCP0100 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0100 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 41 (COMMON:UC-03 COMMON:UC-05 COMMON:UC-06 C) |
| WK-SCP0100-0070 | F5 | SCP0100 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0100 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 2 (CA-104 SaveButton/InsertButton/DeleteBut) |
| WK-SCP0100-0071 | F4 | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISI | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP))  |  | 1 (MODAL:ItemByDivisionModal) |
| WK-SCP0100-0072 | F4 | PKG_SCM0002.P_SCM0002_GET_PROJECT_BY_DIV | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCM0002.P_SCM0002_GET_PROJECT_BY_DIVISION_POPU · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 1 (MODAL:ProjectByDivisionModal) |
| WK-SCP0100-0073 | F4 | PKG_SCP0100.P_SCP0100_GET_GLOBAL_PSI_REP | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0100.P_SCP0100_GET_GLOBAL_PSI_REPORT · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행  |  | 35 (ACT:SCP0100_Global_PSI_Report.FindButton) |
| WK-SCP0100-0074 | F4 | PKG_SCP0100.P_SCP0100_GET_PLAN_DATE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0100.P_SCP0100_GET_PLAN_DATE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smok |  | 3 (cboPlanDate ACT:SCP0100_Global_PSI_Repor) |
| WK-SCP0100-0075 | F4 | PKG_SCP0100.P_SCP0100_GET_SHEET_CALENDAR | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0100.P_SCP0100_GET_SHEET_CALENDAR_3SPAN · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) —  |  | 2 (ACT:SCP0100_Global_PSI_Report.GetSpdTitl) |
| WK-SCP0100-0076 | F4 | PKG_SCP0100.P_SCP0100_GET_SITE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0100.P_SCP0100_GET_SITE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·tra |  | 4 (cboFromSite cboToSite ACT:SCP0100_Global) |
| WK-SCP0100-0077 | F4 | P_BUCKET | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_BUCKET · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (cboBucket) |
| WK-SCP0100-0078 | F4 | P_FROM_SITE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_FROM_SITE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (cboFromSite) |
| WK-SCP0100-0079 | F4 | P_PLAN_START_YYYYMMDD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_PLAN_START_YYYYMMDD · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (cboPlanDate) |
| WK-SCP0100-0080 | F4 | P_SCM0002 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_SCM0002 · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (MODAL:ItemByDivisionModal) |
| WK-SCP0100-0081 | F4 | P_TO_SITE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_TO_SITE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (cboToSite) |
| WK-SCP0100-0082 | H2 | COLUMN_LABEL_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — COLUMN_LABEL_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0100_Global_PSI_Report.SetBackCol) |
| WK-SCP0100-0083 | H2 | DAY_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DAY_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0100_Global_PSI_Report.SetBackCol) |
| WK-SCP0100-0084 | H5 | cboSearchLevel / Search Level | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — cboSearchLevel / Search Level · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요:  |  | 15 (ACT:SCP0100_Global_PSI_Report.SetLayout:) |
| WK-SCP0100-0085 | SC1 | SCP0100 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SCP0100 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 20 (CB-108 COMMON:UC-06 cboDivision dtpFrom ) |
| WK-SCP0100-0086 | D6 | SCP0100 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0100 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 3 (CA-104 COMMON:UC-03 SaveButton/InsertBut) |
| WK-SCP0100-0087 | E4 | COLUMN_LABEL_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — COLUMN_LABEL_NAME · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0100_Global_PSI_Report.SetBackCol) |
| WK-SCP0100-0088 | E4 | DAY_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DAY_CODE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0100_Global_PSI_Report.SetBackCol) |
| WK-SCP0100-0089 | E4 | cboSearchLevel / Search Level | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboSearchLevel / Search Level · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) |  | 23 (ACT:SCP0100_Global_PSI_Report.SetLayout ) |
| WK-SCP0100-0090 | E4 | cboUnitQty / Unit (Qty) / Unit Qty / Sca | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboUnitQty / Unit (Qty) / Unit Qty / Scale / Unit · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 |  | 16 (ACT:SCP0100_Global_PSI_Report.SetCalcula) |
| WK-SCP0100-0091 | A10 | SCP0100 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0100 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 124 (ACT:SCP0100_Global_PSI_Report.DefineProp) |
| WK-SCP0100-0092 | A6 | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISI | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE |  | 1 (MODAL:ItemByDivisionModal) |
| WK-SCP0100-0093 | A6 | PKG_SCM0002.P_SCM0002_GET_PROJECT_BY_DIV | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCM0002.P_SCM0002_GET_PROJECT_BY_DIVISION_POPU · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOUR |  | 1 (MODAL:ProjectByDivisionModal) |
| WK-SCP0100-0094 | A6 | PKG_SCP0100.P_SCP0100_GET_GLOBAL_PSI_REP | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0100.P_SCP0100_GET_GLOBAL_PSI_REPORT · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조 |  | 35 (ACT:SCP0100_Global_PSI_Report.FindButton) |
| WK-SCP0100-0095 | A6 | PKG_SCP0100.P_SCP0100_GET_PLAN_DATE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0100.P_SCP0100_GET_PLAN_DATE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _tr |  | 1 (cboPlanDate) |
| WK-SCP0100-0096 | A6 | PKG_SCP0100.P_SCP0100_GET_SITE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0100.P_SCP0100_GET_SITE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.s |  | 2 (cboFromSite cboToSite) |
| WK-SCP0100-0097 | A6 | P_BUCKET | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_BUCKET · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 1 (cboBucket) |
| WK-SCP0100-0098 | A6 | P_FROM_SITE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_FROM_SITE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 1 (cboFromSite) |
| WK-SCP0100-0099 | A6 | P_PLAN_START_YYYYMMDD | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_PLAN_START_YYYYMMDD · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trac |  | 1 (cboPlanDate) |
| WK-SCP0100-0100 | A6 | P_SCM0002 | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_SCM0002 · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 1 (MODAL:ItemByDivisionModal) |
| WK-SCP0100-0101 | A6 | P_TO_SITE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_TO_SITE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 1 (cboToSite) |
| WK-SCP0100-0102 | G1 | cboDisplay / Display | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDisplay / Display · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (CB-108 cboDisplay) |
| WK-SCP0100-0103 | G1 | cboPlanDate / Plan date / Plan Date | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboPlanDate / Plan date / Plan Date · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (cboPlanDate) |
| WK-SCP0100-0104 | G1 | cboPlanType / Plan-type / Plan Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboPlanType / Plan-type / Plan Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (cboPlanType) |
| WK-SCP0100-0105 | G1 | cboSearchLevel / Search Level | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboSearchLevel / Search Level · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (cboSearchLevel) |
| WK-SCP0100-0106 | G1 | chkAS / A/S / AS | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — chkAS / A/S / AS · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (chkAS) |
| WK-SCP0100-0107 | G1 | chkCellQty / Cell Qty | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — chkCellQty / Cell Qty · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (chkCellQty) |
| WK-SCP0100-0108 | G1 | txtItemId / Model / Nick Name / Item Id  | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemId / Model / Nick Name / Item Id / Model/Ni · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (CB-112 txtItemId) |
| WK-SCP0100-0109 | G1 | txtProject / Project / PJT | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtProject / Project / PJT · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (CB-114 txtProject) |
| WK-SCP0100-0110 | G6 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (ACT:SCP0100_Global_PSI_Report.InitContro) |
| WK-SCP0100-0111 | G6 | cboDisplay / Display | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDisplay / Display · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 6 (CB-108 cboDisplay ACT:SCP0100_Global_PSI) |
| WK-SCP0100-0112 | G6 | cboGraphType / Graph / Graph Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboGraphType / Graph / Graph Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0100_Global_PSI_Report.InitEvent ) |
| WK-SCP0100-0113 | G6 | cboPlanDate / Plan date / Plan Date | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboPlanDate / Plan date / Plan Date · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (cboPlanDate ACT:SCP0100_Global_PSI_Repor) |
| WK-SCP0100-0114 | G6 | cboPlanType / Plan-type / Plan Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboPlanType / Plan-type / Plan Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 7 (cboPlanType ACT:SCP0100_Global_PSI_Repor) |
| WK-SCP0100-0115 | G6 | cboSearchLevel / Search Level | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboSearchLevel / Search Level · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 6 (cboSearchLevel ACT:SCP0100_Global_PSI_Re) |
| WK-SCP0100-0116 | G6 | cboUnitQty / Unit (Qty) / Unit Qty / Sca | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboUnitQty / Unit (Qty) / Unit Qty / Scale / Unit · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCP0100_Global_PSI_Report.InitContro) |
| WK-SCP0100-0117 | G6 | chkAS / A/S / AS | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — chkAS / A/S / AS · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (chkAS ACT:SCP0100_Global_PSI_Report.Init) |
| WK-SCP0100-0118 | G6 | chkCellQty / Cell Qty | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — chkCellQty / Cell Qty · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (chkCellQty ACT:SCP0100_Global_PSI_Report) |
| WK-SCP0100-0119 | G6 | clbDivision / Div / Division / Div. | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbDivision / Div / Division / Div. · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCP0100_Global_PSI_Report.InitContro) |
| WK-SCP0100-0120 | G6 | rgrpSearchLevel / Search Level / Search  | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — rgrpSearchLevel / Search Level / Search Mode · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCP0100_Global_PSI_Report.DefineProp) |
| WK-SCP0100-0121 | G6 | txtItemId / Model / Nick Name / Item Id  | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtItemId / Model / Nick Name / Item Id / Model/Ni · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (txtItemId) |
| WK-SCP0100-0122 | G6 | txtProject / Project / PJT | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtProject / Project / PJT · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (txtProject) |
| WK-SCP0100-0123 | X-REOPEN | SCP0100 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0100 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 7 (ACT:SCP0100_Global_PSI_Report.Dispose AC) |
| WK-SCP0100-0124 | H6 | cboDisplay / Display | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboDisplay / Display · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (cboDisplay) |
| WK-SCP0100-0125 | H6 | cboPlanDate / Plan date / Plan Date | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboPlanDate / Plan date / Plan Date · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (cboPlanDate) |
| WK-SCP0100-0126 | H6 | cboPlanType / Plan-type / Plan Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboPlanType / Plan-type / Plan Type · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (cboPlanType) |
| WK-SCP0100-0127 | H6 | cboSearchLevel / Search Level | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboSearchLevel / Search Level · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (cboSearchLevel) |
| WK-SCP0100-0128 | H6 | chkAS / A/S / AS | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — chkAS / A/S / AS · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (chkAS) |
| WK-SCP0100-0129 | H6 | chkCellQty / Cell Qty | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — chkCellQty / Cell Qty · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (chkCellQty) |
| WK-SCP0100-0130 | H6 | txtItemId / Model / Nick Name / Item Id  | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtItemId / Model / Nick Name / Item Id / Model/Ni · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 2 (CB-112 txtItemId) |
| WK-SCP0100-0131 | H6 | txtProject / Project / PJT | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtProject / Project / PJT · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 2 (CB-114 txtProject) |
| WK-SCP0100-0132 | M4 | btnItemId | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnItemId · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (MODAL:ItemByDivisionModal txtItemId) |
| WK-SCP0100-0133 | M4 | btnProject | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnProject · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (MODAL:ProjectByDivisionModal txtProject) |
| WK-SCP0100-0134 | M4 | cboDisplay / Display | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — cboDisplay / Display · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (cboDisplay) |
| WK-SCP0100-0135 | M4 | cboPlanDate / Plan date / Plan Date | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — cboPlanDate / Plan date / Plan Date · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (cboPlanDate) |
| WK-SCP0100-0136 | M4 | cboPlanType / Plan-type / Plan Type | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — cboPlanType / Plan-type / Plan Type · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (cboPlanType) |
| WK-SCP0100-0137 | M4 | cboSearchLevel / Search Level | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — cboSearchLevel / Search Level · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (cboSearchLevel) |
| WK-SCP0100-0138 | M4 | chkAS / A/S / AS | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — chkAS / A/S / AS · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (chkAS) |
| WK-SCP0100-0139 | M4 | chkCellQty / Cell Qty | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — chkCellQty / Cell Qty · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (chkCellQty) |
| WK-SCP0100-0140 | M4 | txtItemId / Model / Nick Name / Item Id  | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtItemId / Model / Nick Name / Item Id / Model/Ni · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요:  |  | 2 (CB-112 txtItemId) |
| WK-SCP0100-0141 | M4 | txtProject / Project / PJT | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtProject / Project / PJT · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (CB-114 txtProject) |

## W7 기대값 확정 (289)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0100-0142 | C1 | cboBucket | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — cboBucket: 행 집계 — C1 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (cboBucket) |
| WK-SCP0100-0143 | C3 | SCP0100_Global_PSI_Report.CboBucketType_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0100_Global_PSI_Report.CboBucketType_SelectedIn: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0100_Global_PSI_Report.CboBucketT) |
| WK-SCP0100-0144 | C3 | SCP0100_Global_PSI_Report.CboDisplay_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0100_Global_PSI_Report.CboDisplay_SelectedIndex: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0100_Global_PSI_Report.CboDisplay) |
| WK-SCP0100-0145 | C3 | SCP0100_Global_PSI_Report.CboPlanDate_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0100_Global_PSI_Report.CboPlanDate_SelectedInde: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0100_Global_PSI_Report.CboPlanDat) |
| WK-SCP0100-0146 | C3 | SCP0100_Global_PSI_Report.CboSearchLevel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0100_Global_PSI_Report.CboSearchLevel_SelectedI: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0100_Global_PSI_Report.CboSearchL) |
| WK-SCP0100-0147 | C3 | SCP0100_Global_PSI_Report.CboUnitQty_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0100_Global_PSI_Report.CboUnitQty_SelectedIndex: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0100_Global_PSI_Report.CboUnitQty) |
| WK-SCP0100-0148 | C3 | SCP0100_Global_PSI_Report.ClbDivision_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0100_Global_PSI_Report.ClbDivision_SelectedInde: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0100_Global_PSI_Report.ClbDivisio) |
| WK-SCP0100-0149 | C3 | SCP0100_Global_PSI_Report.DCalendar_Valu | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0100_Global_PSI_Report.DCalendar_ValueChanged: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0100_Global_PSI_Report.DCalendar_) |
| WK-SCP0100-0150 | C3 | SCP0100_Global_PSI_Report.SetBackColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0100_Global_PSI_Report.SetBackColor: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 117 (ACT:SCP0100_Global_PSI_Report.SetBackCol) |
| WK-SCP0100-0151 | C3 | SCP0100_Global_PSI_Report.SetCalculating | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0100_Global_PSI_Report.SetCalculating: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 33 (ACT:SCP0100_Global_PSI_Report.SetCalcula) |
| WK-SCP0100-0152 | C3 | SCP0100_Global_PSI_Report.SetCalendar | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0100_Global_PSI_Report.SetCalendar: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.SetCalenda) |
| WK-SCP0100-0153 | C3 | SCP0100_Global_PSI_Report.SetGridClear | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0100_Global_PSI_Report.SetGridClear: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0100_Global_PSI_Report.SetGridCle) |
| WK-SCP0100-0154 | C3 | SCP0100_Global_PSI_Report.SetSpreadColum | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0100_Global_PSI_Report.SetSpreadColumn: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SCP0100_Global_PSI_Report.SetSpreadC) |
| WK-SCP0100-0155 | C3 | SCP0100_Global_PSI_Report.SetVisibleColu | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0100_Global_PSI_Report.SetVisibleColumnCycle: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0100_Global_PSI_Report.SetVisible) |
| WK-SCP0100-0156 | C3 | SCP0100_Global_PSI_Report.rgrpSearchLeve | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0100_Global_PSI_Report.rgrpSearchLevel_Selected: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0100_Global_PSI_Report.rgrpSearch) |
| WK-SCP0100-0157 | B3 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — COMMON:UC-05: 행 집계 — B3 14요소: TODO:14 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0100-0158 | B3 | SCP0100_Global_PSI_Report.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0100_Global_PSI_Report.GetDayRange: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 28 (ACT:SCP0100_Global_PSI_Report.GetDayRang) |
| WK-SCP0100-0159 | B3 | SCP0100_Global_PSI_Report.GetMeasureData | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0100_Global_PSI_Report.GetMeasureDataType: 진입점 집계 — B3 14요소: TODO:14 (미실행 요소가 남아 판정필요) |  | 15 (ACT:SCP0100_Global_PSI_Report.GetMeasure) |
| WK-SCP0100-0160 | B3 | SCP0100_Global_PSI_Report.GetPlanDate | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0100_Global_PSI_Report.GetPlanDate: 진입점 집계 — B3 14요소: TODO:14 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SCP0100_Global_PSI_Report.GetPlanDat) |
| WK-SCP0100-0161 | B3 | SCP0100_Global_PSI_Report.GetPlanEndDate | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0100_Global_PSI_Report.GetPlanEndDate: 진입점 집계 — B3 14요소: TODO:14 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0100_Global_PSI_Report.GetPlanEnd) |
| WK-SCP0100-0162 | B3 | SCP0100_Global_PSI_Report.GetSiteList | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0100_Global_PSI_Report.GetSiteList: 진입점 집계 — B3 14요소: TODO:14 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SCP0100_Global_PSI_Report.GetSiteLis) |
| WK-SCP0100-0163 | B3 | SCP0100_Global_PSI_Report.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0100_Global_PSI_Report.GetSpdTitle: 진입점 집계 — B3 14요소: TODO:14 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0100_Global_PSI_Report.GetSpdTitl) |
| WK-SCP0100-0164 | B3 | SCP0100_Global_PSI_Report.GetUnitDivide | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0100_Global_PSI_Report.GetUnitDivide: 진입점 집계 — B3 14요소: TODO:14 (미실행 요소가 남아 판정필요) |  | 14 (ACT:SCP0100_Global_PSI_Report.GetUnitDiv) |
| WK-SCP0100-0165 | B3 | SCP0100_Global_PSI_Report.getDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0100_Global_PSI_Report.getDivision: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0100_Global_PSI_Report.getDivisio) |
| WK-SCP0100-0166 | B3 | SCP0100_Global_PSI_Report.getEndYYYYMMDD | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0100_Global_PSI_Report.getEndYYYYMMDD: 진입점 집계 — B3 14요소: TODO:14 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.getEndYYYY) |
| WK-SCP0100-0167 | B3 | SCP0100_Global_PSI_Report.getFromSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0100_Global_PSI_Report.getFromSite: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0100_Global_PSI_Report.getFromSit) |
| WK-SCP0100-0168 | B3 | SCP0100_Global_PSI_Report.getFromYYYYMMD | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0100_Global_PSI_Report.getFromYYYYMMDD: 진입점 집계 — B3 14요소: TODO:14 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.getFromYYY) |
| WK-SCP0100-0169 | B3 | SCP0100_Global_PSI_Report.getIsDetail | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0100_Global_PSI_Report.getIsDetail: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0100_Global_PSI_Report.getIsDetai) |
| WK-SCP0100-0170 | B3 | SCP0100_Global_PSI_Report.getSearchLevel | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0100_Global_PSI_Report.getSearchLevel: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0100_Global_PSI_Report.getSearchL) |
| WK-SCP0100-0171 | B3 | SCP0100_Global_PSI_Report.getStartYYYYMM | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0100_Global_PSI_Report.getStartYYYYMMDD: 진입점 집계 — B3 14요소: TODO:14 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.getStartYY) |
| WK-SCP0100-0172 | B3 | SCP0100_Global_PSI_Report.getToSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0100_Global_PSI_Report.getToSite: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0100_Global_PSI_Report.getToSite:) |
| WK-SCP0100-0173 | B3 | SCP0100_Global_PSI_Report.getToYYYYMMDD | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0100_Global_PSI_Report.getToYYYYMMDD: 진입점 집계 — B3 14요소: TODO:14 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.getToYYYYM) |
| WK-SCP0100-0174 | B3 | cboFromSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — cboFromSite: 행 집계 — B3 14요소: TODO:14 (미실행 요소가 남아 판정필요) |  | 1 (cboFromSite) |
| WK-SCP0100-0175 | B3 | cboToSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — cboToSite: 행 집계 — B3 14요소: TODO:14 (미실행 요소가 남아 판정필요) |  | 1 (cboToSite) |
| WK-SCP0100-0176 | B4 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — COMMON:UC-05: 행 집계 — B4 14요소: NOPATH:14 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0100-0177 | B4 | SCP0100_Global_PSI_Report.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0100_Global_PSI_Report.GetDayRange: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 28 (ACT:SCP0100_Global_PSI_Report.GetDayRang) |
| WK-SCP0100-0178 | B4 | SCP0100_Global_PSI_Report.GetMeasureData | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0100_Global_PSI_Report.GetMeasureDataType: 진입점 집계 — B4 14요소: NOPATH:14 (미실행 요소가 남아 판정필요) |  | 15 (ACT:SCP0100_Global_PSI_Report.GetMeasure) |
| WK-SCP0100-0179 | B4 | SCP0100_Global_PSI_Report.GetPlanDate | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0100_Global_PSI_Report.GetPlanDate: 진입점 집계 — B4 14요소: NOPATH:14 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SCP0100_Global_PSI_Report.GetPlanDat) |
| WK-SCP0100-0180 | B4 | SCP0100_Global_PSI_Report.GetPlanEndDate | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0100_Global_PSI_Report.GetPlanEndDate: 진입점 집계 — B4 14요소: NOPATH:14 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0100_Global_PSI_Report.GetPlanEnd) |
| WK-SCP0100-0181 | B4 | SCP0100_Global_PSI_Report.GetSiteList | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0100_Global_PSI_Report.GetSiteList: 진입점 집계 — B4 14요소: NOPATH:14 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SCP0100_Global_PSI_Report.GetSiteLis) |
| WK-SCP0100-0182 | B4 | SCP0100_Global_PSI_Report.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0100_Global_PSI_Report.GetSpdTitle: 진입점 집계 — B4 14요소: NOPATH:14 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0100_Global_PSI_Report.GetSpdTitl) |
| WK-SCP0100-0183 | B4 | SCP0100_Global_PSI_Report.GetUnitDivide | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0100_Global_PSI_Report.GetUnitDivide: 진입점 집계 — B4 14요소: NOPATH:14 (미실행 요소가 남아 판정필요) |  | 14 (ACT:SCP0100_Global_PSI_Report.GetUnitDiv) |
| WK-SCP0100-0184 | B4 | SCP0100_Global_PSI_Report.getDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0100_Global_PSI_Report.getDivision: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0100_Global_PSI_Report.getDivisio) |
| WK-SCP0100-0185 | B4 | SCP0100_Global_PSI_Report.getEndYYYYMMDD | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0100_Global_PSI_Report.getEndYYYYMMDD: 진입점 집계 — B4 14요소: NOPATH:14 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.getEndYYYY) |
| WK-SCP0100-0186 | B4 | SCP0100_Global_PSI_Report.getFromSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0100_Global_PSI_Report.getFromSite: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0100_Global_PSI_Report.getFromSit) |
| WK-SCP0100-0187 | B4 | SCP0100_Global_PSI_Report.getFromYYYYMMD | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0100_Global_PSI_Report.getFromYYYYMMDD: 진입점 집계 — B4 14요소: NOPATH:14 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.getFromYYY) |
| WK-SCP0100-0188 | B4 | SCP0100_Global_PSI_Report.getIsDetail | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0100_Global_PSI_Report.getIsDetail: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0100_Global_PSI_Report.getIsDetai) |
| WK-SCP0100-0189 | B4 | SCP0100_Global_PSI_Report.getSearchLevel | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0100_Global_PSI_Report.getSearchLevel: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0100_Global_PSI_Report.getSearchL) |
| WK-SCP0100-0190 | B4 | SCP0100_Global_PSI_Report.getStartYYYYMM | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0100_Global_PSI_Report.getStartYYYYMMDD: 진입점 집계 — B4 14요소: NOPATH:14 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.getStartYY) |
| WK-SCP0100-0191 | B4 | SCP0100_Global_PSI_Report.getToSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0100_Global_PSI_Report.getToSite: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0100_Global_PSI_Report.getToSite:) |
| WK-SCP0100-0192 | B4 | SCP0100_Global_PSI_Report.getToYYYYMMDD | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0100_Global_PSI_Report.getToYYYYMMDD: 진입점 집계 — B4 14요소: NOPATH:14 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.getToYYYYM) |
| WK-SCP0100-0193 | B4 | cboFromSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — cboFromSite: 행 집계 — B4 14요소: NOPATH:14 (미실행 요소가 남아 판정필요) |  | 1 (cboFromSite) |
| WK-SCP0100-0194 | B4 | cboToSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — cboToSite: 행 집계 — B4 14요소: NOPATH:14 (미실행 요소가 남아 판정필요) |  | 1 (cboToSite) |
| WK-SCP0100-0195 | DB-SYN | SCP0100_Global_PSI_Report.GetPlanEndDate | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SCP0100_Global_PSI_Report.GetPlanEndDate: 진입점 집계 — DB-SYN 11요소: PASS:6 · NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.GetPlanEnd) |
| WK-SCP0100-0196 | DB-SYN | SCP0100_Global_PSI_Report.SetBackColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SCP0100_Global_PSI_Report.SetBackColor: 진입점 집계 — DB-SYN 11요소: PASS:6 · NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.SetBackCol) |
| WK-SCP0100-0197 | F4 | SCP0100_Global_PSI_Report.GetPlanEndDate | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0100_Global_PSI_Report.GetPlanEndDate: 진입점 집계 — F4 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.GetPlanEnd) |
| WK-SCP0100-0198 | F4 | SCP0100_Global_PSI_Report.SetBackColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0100_Global_PSI_Report.SetBackColor: 진입점 집계 — F4 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.SetBackCol) |
| WK-SCP0100-0199 | G4 | (CELL_GROUP) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — (CELL_GROUP): 행 집계 — G4 17요소: PASS:13 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 ((CELL_GROUP)) |
| WK-SCP0100-0200 | G4 | (세션) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — (세션): 행 집계 — G4 17요소: PASS:13 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 ((세션)) |
| WK-SCP0100-0201 | G4 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — COMMON:UC-06: 행 집계 — G4 17요소: PASS:13 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0100-0202 | G4 | CboGraphType | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — CboGraphType: 행 집계 — G4 17요소: PASS:13 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (CboGraphType) |
| WK-SCP0100-0203 | G4 | cboBucket | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — cboBucket: 행 집계 — G4 17요소: PASS:13 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (cboBucket) |
| WK-SCP0100-0204 | G4 | cboDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — cboDivision: 행 집계 — G4 17요소: PASS:13 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (cboDivision) |
| WK-SCP0100-0205 | G4 | cboFromSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — cboFromSite: 행 집계 — G4 17요소: PASS:13 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (cboFromSite) |
| WK-SCP0100-0206 | G4 | cboToSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — cboToSite: 행 집계 — G4 17요소: PASS:13 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (cboToSite) |
| WK-SCP0100-0207 | G4 | dtpFrom | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — dtpFrom: 행 집계 — G4 17요소: PASS:13 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (dtpFrom) |
| WK-SCP0100-0208 | G4 | dtpTo | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — dtpTo: 행 집계 — G4 17요소: PASS:13 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (dtpTo) |
| WK-SCP0100-0209 | G4 | ~~txtNickName~~ | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — ~~txtNickName~~: 행 집계 — G4 17요소: PASS:13 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (~~txtNickName~~) |
| WK-SCP0100-0210 | H2 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-07: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0100-0211 | H2 | SCP0100_Global_PSI_Report.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0100_Global_PSI_Report.CreateSpread: 진입점 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCP0100_Global_PSI_Report.CreateSpre) |
| WK-SCP0100-0212 | H2 | SCP0100_Global_PSI_Report.SetBackColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0100_Global_PSI_Report.SetBackColor: 진입점 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 117 (ACT:SCP0100_Global_PSI_Report.SetBackCol) |
| WK-SCP0100-0213 | H2 | SCP0100_Global_PSI_Report.SetSpreadColum | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0100_Global_PSI_Report.SetSpreadColumn: 진입점 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SCP0100_Global_PSI_Report.SetSpreadC) |
| WK-SCP0100-0214 | H2 | spdDetail | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — spdDetail: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (spdDetail) |
| WK-SCP0100-0215 | H2 | spdSearchLevel | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — spdSearchLevel: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (spdSearchLevel) |
| WK-SCP0100-0216 | H2 | spdSearchLevelDetail | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — spdSearchLevelDetail: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (spdSearchLevelDetail) |
| WK-SCP0100-0217 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0100-0218 | H5 | SCP0100_Global_PSI_Report.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0100_Global_PSI_Report.CreateSpread: 진입점 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCP0100_Global_PSI_Report.CreateSpre) |
| WK-SCP0100-0219 | H5 | SCP0100_Global_PSI_Report.SetSpreadColum | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0100_Global_PSI_Report.SetSpreadColumn: 진입점 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SCP0100_Global_PSI_Report.SetSpreadC) |
| WK-SCP0100-0220 | H5 | spdDetail | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — spdDetail: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (spdDetail) |
| WK-SCP0100-0221 | H5 | spdSearchLevel | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — spdSearchLevel: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (spdSearchLevel) |
| WK-SCP0100-0222 | H5 | spdSearchLevelDetail | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — spdSearchLevelDetail: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (spdSearchLevelDetail) |
| WK-SCP0100-0223 | I1 | SCP0100 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | I1 기대값 확정 — SCP0100 화면: 게이트 I18N2 다국어 미적용(영문 고정 'Search Mode'): 코드 '' (빈 키 / 게이트 I18N2 다국어 미적용(영문 고정 'A/S'): 코드 LBL01167 가 msg_ /  |  | 1 (ACT:SCP0100_Global_PSI_Report.DCalendar_) |
| WK-SCP0100-0224 | X-REASON | CA-101 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CA-101 §1 [원문 무번호] AS-IS / TO-BE — 표 헤더 행(실제 항목 아님) 해당없음 |  | 1 (CA-101) |
| WK-SCP0100-0225 | X-REASON | CB-101 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CB-101 §2 [원문 무번호] AS-IS 컨트롤 / TO-BE searchCondition — 표 헤더 행(실제 항목 아님) 해당없음 |  | 1 (CB-101) |
| WK-SCP0100-0226 | X-REASON | CB-119 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CB-119 §2 [원문 무번호] CboGraphType / 미배선 — AS-IS 핸들러 본문 공백(NO-OP, screen-analysis.json events) + LBL 미등록(design 02 |  | 1 (CB-119) |
| WK-SCP0100-0227 | X-REASON | CC-101 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CC-101 §3 [원문 무번호] AS-IS FpSpread / TO-BE SHEETS — 표 헤더 행(실제 항목 아님) 해당없음 |  | 1 (CC-101) |
| WK-SCP0100-0228 | X-REASON | COMMON:UC-02 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-02 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4)  해당없음 — 편집 기능  |  | 1 (COMMON:UC-02) |
| WK-SCP0100-0229 | E4 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — COMMON:UC-03: 행 집계 — E4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-SCP0100-0230 | E4 | MODAL:GlobalPsiReportModals | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — MODAL:GlobalPsiReportModals: 행 집계 — E4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:GlobalPsiReportModals) |
| WK-SCP0100-0231 | E4 | SCP0100_Global_PSI_Report.SetBackColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0100_Global_PSI_Report.SetBackColor: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 117 (ACT:SCP0100_Global_PSI_Report.SetBackCol) |
| WK-SCP0100-0232 | E4 | SCP0100_Global_PSI_Report.SetCalculating | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0100_Global_PSI_Report.SetCalculating: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 33 (ACT:SCP0100_Global_PSI_Report.SetCalcula) |
| WK-SCP0100-0233 | E4 | SCP0100_Global_PSI_Report.SetCalendar | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0100_Global_PSI_Report.SetCalendar: 진입점 집계 — E4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.SetCalenda) |
| WK-SCP0100-0234 | E4 | SCP0100_Global_PSI_Report.SetGridClear | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0100_Global_PSI_Report.SetGridClear: 진입점 집계 — E4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0100_Global_PSI_Report.SetGridCle) |
| WK-SCP0100-0235 | E4 | SCP0100_Global_PSI_Report.SetSpreadColum | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0100_Global_PSI_Report.SetSpreadColumn: 진입점 집계 — E4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SCP0100_Global_PSI_Report.SetSpreadC) |
| WK-SCP0100-0236 | E4 | SCP0100_Global_PSI_Report.SetVisibleColu | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0100_Global_PSI_Report.SetVisibleColumnCycle: 진입점 집계 — E4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0100_Global_PSI_Report.SetVisible) |
| WK-SCP0100-0237 | E4 | dtpFrom | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — dtpFrom: 행 집계 — E4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (dtpFrom) |
| WK-SCP0100-0238 | A1 | CA-102 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CA-102: 행 집계 — A1 23요소: REVIEW:23 |  | 1 (CA-102) |
| WK-SCP0100-0239 | A1 | CB-108 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CB-108: 행 집계 — A1 23요소: REVIEW:23 |  | 1 (CB-108) |
| WK-SCP0100-0240 | A1 | CB-112 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CB-112: 행 집계 — A1 23요소: REVIEW:23 |  | 1 (CB-112) |
| WK-SCP0100-0241 | A1 | CB-114 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CB-114: 행 집계 — A1 23요소: REVIEW:23 |  | 1 (CB-114) |
| WK-SCP0100-0242 | A1 | COLUMN_SETUP | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COLUMN_SETUP: 골든 비교 케이스 없음(COLUMN_SETUP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (MODAL:GlobalPsiReportModals) |
| WK-SCP0100-0243 | A1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-03: 행 집계 — A1 23요소: REVIEW:23 |  | 1 (COMMON:UC-03) |
| WK-SCP0100-0244 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — A1 23요소: REVIEW:23 |  | 1 (COMMON:UC-06) |
| WK-SCP0100-0245 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 23요소: REVIEW:23 |  | 1 (COMMON:UC-07) |
| WK-SCP0100-0246 | A1 | CboGraphType | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CboGraphType: 행 집계 — A1 23요소: REVIEW:23 |  | 1 (CboGraphType) |
| WK-SCP0100-0247 | A1 | FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindButton: 행 집계 — A1 23요소: REVIEW:23 |  | 1 (FindButton) |
| WK-SCP0100-0248 | A1 | PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP: 골든 비교 케이스 없음(PKG_SCM0002.P_SCM0002_GET_ITEM_BY_DIVISION_POPUP — 팝업·보 |  | 1 (MODAL:ItemByDivisionModal) |
| WK-SCP0100-0249 | A1 | PKG_SCM0002.P_SCM0002_GET_PROJECT_BY_DIV | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCM0002.P_SCM0002_GET_PROJECT_BY_DIVISION_POPU: 골든 비교 케이스 없음(PKG_SCM0002.P_SCM0002_GET_PROJECT_BY_DIVISION_POPUP — |  | 1 (MODAL:ProjectByDivisionModal) |
| WK-SCP0100-0250 | A1 | PKG_SCP0100.P_SCP0100_GET_GLOBAL_PSI_REP | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0100.P_SCP0100_GET_GLOBAL_PSI_REPORT: 골든 비교 케이스 없음(PKG_SCP0100.P_SCP0100_GET_GLOBAL_PSI_REPORT — 팝업·보조 SP 는 gol |  | 35 (ACT:SCP0100_Global_PSI_Report.FindButton) |
| WK-SCP0100-0251 | A1 | PKG_SCP0100.P_SCP0100_GET_PLAN_DATE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0100.P_SCP0100_GET_PLAN_DATE: 골든 비교 케이스 없음(PKG_SCP0100.P_SCP0100_GET_PLAN_DATE — 팝업·보조 SP 는 golden_cases.csv 에  |  | 1 (cboPlanDate) |
| WK-SCP0100-0252 | A1 | PKG_SCP0100.P_SCP0100_GET_SITE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0100.P_SCP0100_GET_SITE: 골든 비교 케이스 없음(PKG_SCP0100.P_SCP0100_GET_SITE — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미 |  | 2 (cboFromSite cboToSite) |
| WK-SCP0100-0253 | A1 | P_BUCKET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_BUCKET: 골든 비교 케이스 없음(P_BUCKET — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (cboBucket) |
| WK-SCP0100-0254 | A1 | P_CELL_GROUP | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_CELL_GROUP: 골든 비교 케이스 없음(P_CELL_GROUP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 ((CELL_GROUP)) |
| WK-SCP0100-0255 | A1 | P_CHK_AS | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_CHK_AS: 골든 비교 케이스 없음(P_CHK_AS — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (chkAS) |
| WK-SCP0100-0256 | A1 | P_CHK_CELL_QTY | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_CHK_CELL_QTY: 골든 비교 케이스 없음(P_CHK_CELL_QTY — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (chkCellQty) |
| WK-SCP0100-0257 | A1 | P_DIVISION_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_DIVISION_ID: 골든 비교 케이스 없음(P_DIVISION_ID — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (cboDivision) |
| WK-SCP0100-0258 | A1 | P_FROM_SITE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_FROM_SITE: 골든 비교 케이스 없음(P_FROM_SITE — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (cboFromSite) |
| WK-SCP0100-0259 | A1 | P_FROM_YYYYMMDD | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_FROM_YYYYMMDD: 골든 비교 케이스 없음(P_FROM_YYYYMMDD — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (dtpFrom) |
| WK-SCP0100-0260 | A1 | P_ITEM_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_ITEM_ID: 골든 비교 케이스 없음(P_ITEM_ID — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (txtItemId) |
| WK-SCP0100-0261 | A1 | P_NICK_NAME | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_NICK_NAME: 골든 비교 케이스 없음(P_NICK_NAME — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (~~txtNickName~~) |
| WK-SCP0100-0262 | A1 | P_PLAN_START_YYYYMMDD | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_PLAN_START_YYYYMMDD: 골든 비교 케이스 없음(P_PLAN_START_YYYYMMDD — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (cboPlanDate) |
| WK-SCP0100-0263 | A1 | P_PLAN_TYPE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_PLAN_TYPE: 골든 비교 케이스 없음(P_PLAN_TYPE — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (cboPlanType) |
| WK-SCP0100-0264 | A1 | P_PROJECT | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_PROJECT: 골든 비교 케이스 없음(P_PROJECT — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (txtProject) |
| WK-SCP0100-0265 | A1 | P_SCM0002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_SCM0002: 골든 비교 케이스 없음(P_SCM0002 — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (MODAL:ItemByDivisionModal) |
| WK-SCP0100-0266 | A1 | P_SEARCH_LEVEL | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_SEARCH_LEVEL: 골든 비교 케이스 없음(P_SEARCH_LEVEL — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (cboSearchLevel) |
| WK-SCP0100-0267 | A1 | P_TO_SITE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_TO_SITE: 골든 비교 케이스 없음(P_TO_SITE — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (cboToSite) |
| WK-SCP0100-0268 | A1 | P_TO_YYYYMMDD | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_TO_YYYYMMDD: 골든 비교 케이스 없음(P_TO_YYYYMMDD — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (dtpTo) |
| WK-SCP0100-0269 | A1 | P_USER_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_USER_ID: 골든 비교 케이스 없음(P_USER_ID — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 ((세션)) |
| WK-SCP0100-0270 | A1 | SCP0100_Global_PSI_Report.AfterFindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0100_Global_PSI_Report.AfterFindData: 진입점 집계 — A1 23요소: REVIEW:23 |  | 1 (ACT:SCP0100_Global_PSI_Report.AfterFindD) |
| WK-SCP0100-0271 | A1 | cboDisplay | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboDisplay: 행 집계 — A1 23요소: REVIEW:23 |  | 1 (cboDisplay) |
| WK-SCP0100-0272 | A1 | spdSearchLevel | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — spdSearchLevel: 행 집계 — A1 23요소: REVIEW:23 |  | 1 (spdSearchLevel) |
| WK-SCP0100-0273 | A1 | spdSearchLevelDetail | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — spdSearchLevelDetail: 행 집계 — A1 23요소: REVIEW:23 |  | 1 (spdSearchLevelDetail) |
| WK-SCP0100-0274 | G03-WIRE | SCP0100 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G03-WIRE 기대값 확정 — SCP0100 화면: 게이트 G03 As-is 이벤트 this.Load → Form_Load 매핑표 §2 에 / 게이트 G03 As-is 이벤트 this.Shown → SCP0100_Global_PS  |  | 21 (ACT:SCP0100_Global_PSI_Report..ctor ACT:) |
| WK-SCP0100-0275 | G1 | (CELL_GROUP) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — (CELL_GROUP): 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 ((CELL_GROUP)) |
| WK-SCP0100-0276 | G1 | (세션) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — (세션): 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 ((세션)) |
| WK-SCP0100-0277 | G1 | CA-102 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — CA-102: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (CA-102) |
| WK-SCP0100-0278 | G1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-03: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-SCP0100-0279 | G1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-06: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0100-0280 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0100-0281 | G1 | CboGraphType | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — CboGraphType: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (CboGraphType) |
| WK-SCP0100-0282 | G1 | FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — FindButton: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (FindButton) |
| WK-SCP0100-0283 | G1 | MODAL:GlobalPsiReportModals | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — MODAL:GlobalPsiReportModals: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:GlobalPsiReportModals) |
| WK-SCP0100-0284 | G1 | cboBucket | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — cboBucket: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (cboBucket) |
| WK-SCP0100-0285 | G1 | cboDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — cboDivision: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (cboDivision) |
| WK-SCP0100-0286 | G1 | cboFromSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — cboFromSite: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (cboFromSite) |
| WK-SCP0100-0287 | G1 | cboToSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — cboToSite: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (cboToSite) |
| WK-SCP0100-0288 | G1 | dtpFrom | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — dtpFrom: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (dtpFrom) |
| WK-SCP0100-0289 | G1 | dtpTo | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — dtpTo: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (dtpTo) |
| WK-SCP0100-0290 | G1 | spdSearchLevel | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — spdSearchLevel: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (spdSearchLevel) |
| WK-SCP0100-0291 | G1 | spdSearchLevelDetail | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — spdSearchLevelDetail: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (spdSearchLevelDetail) |
| WK-SCP0100-0292 | G1 | ~~txtNickName~~ | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — ~~txtNickName~~: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (~~txtNickName~~) |
| WK-SCP0100-0293 | G6 | (CELL_GROUP) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — (CELL_GROUP): 행 집계 — G6 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 ((CELL_GROUP)) |
| WK-SCP0100-0294 | G6 | (세션) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — (세션): 행 집계 — G6 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 ((세션)) |
| WK-SCP0100-0295 | G6 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — COMMON:UC-06: 행 집계 — G6 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0100-0296 | G6 | CboGraphType | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — CboGraphType: 행 집계 — G6 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (CboGraphType) |
| WK-SCP0100-0297 | G6 | cboBucket | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — cboBucket: 행 집계 — G6 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (cboBucket) |
| WK-SCP0100-0298 | G6 | cboDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — cboDivision: 행 집계 — G6 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (cboDivision) |
| WK-SCP0100-0299 | G6 | cboFromSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — cboFromSite: 행 집계 — G6 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (cboFromSite) |
| WK-SCP0100-0300 | G6 | cboToSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — cboToSite: 행 집계 — G6 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (cboToSite) |
| WK-SCP0100-0301 | G6 | dtpFrom | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — dtpFrom: 행 집계 — G6 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (dtpFrom) |
| WK-SCP0100-0302 | G6 | dtpTo | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — dtpTo: 행 집계 — G6 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (dtpTo) |
| WK-SCP0100-0303 | G6 | ~~txtNickName~~ | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — ~~txtNickName~~: 행 집계 — G6 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (~~txtNickName~~) |
| WK-SCP0100-0304 | X-LOC | (CELL_GROUP) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — (CELL_GROUP): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ((CELL_GROUP)) |
| WK-SCP0100-0305 | X-LOC | (세션) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — (세션): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ((세션)) |
| WK-SCP0100-0306 | X-LOC | CboGraphType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — CboGraphType: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (CboGraphType) |
| WK-SCP0100-0307 | X-LOC | cboBucket | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — cboBucket: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (cboBucket) |
| WK-SCP0100-0308 | X-LOC | cboDisplay | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — cboDisplay: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (cboDisplay) |
| WK-SCP0100-0309 | X-LOC | cboDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — cboDivision: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (cboDivision) |
| WK-SCP0100-0310 | X-LOC | cboFromSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — cboFromSite: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (cboFromSite) |
| WK-SCP0100-0311 | X-LOC | cboPlanDate | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — cboPlanDate: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (cboPlanDate) |
| WK-SCP0100-0312 | X-LOC | cboPlanType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — cboPlanType: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (cboPlanType) |
| WK-SCP0100-0313 | X-LOC | cboSearchLevel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — cboSearchLevel: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (cboSearchLevel) |
| WK-SCP0100-0314 | X-LOC | cboToSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — cboToSite: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (cboToSite) |
| WK-SCP0100-0315 | X-LOC | chkAS | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — chkAS: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (chkAS) |
| WK-SCP0100-0316 | X-LOC | chkCellQty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — chkCellQty: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (chkCellQty) |
| WK-SCP0100-0317 | X-LOC | dtpFrom | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — dtpFrom: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (dtpFrom) |
| WK-SCP0100-0318 | X-LOC | dtpTo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — dtpTo: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (dtpTo) |
| WK-SCP0100-0319 | X-LOC | spdDetail | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — spdDetail: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (spdDetail) |
| WK-SCP0100-0320 | X-LOC | spdSearchLevel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — spdSearchLevel: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (spdSearchLevel) |
| WK-SCP0100-0321 | X-LOC | spdSearchLevelDetail | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — spdSearchLevelDetail: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (spdSearchLevelDetail) |
| WK-SCP0100-0322 | X-LOC | txtItemId | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — txtItemId: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (txtItemId) |
| WK-SCP0100-0323 | X-LOC | txtProject | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — txtProject: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (txtProject) |
| WK-SCP0100-0324 | X-LOC | ~~txtNickName~~ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ~~txtNickName~~: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (~~txtNickName~~) |
| WK-SCP0100-0325 | X-ROW | CA-103 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CA-103: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CA-103) |
| WK-SCP0100-0326 | X-ROW | CB-102 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CB-102: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CB-102) |
| WK-SCP0100-0327 | X-ROW | CB-106 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CB-106: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CB-106) |
| WK-SCP0100-0328 | X-ROW | CB-107 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CB-107: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CB-107) |
| WK-SCP0100-0329 | X-ROW | CB-109 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CB-109: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CB-109) |
| WK-SCP0100-0330 | X-ROW | CB-110 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CB-110: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CB-110) |
| WK-SCP0100-0331 | X-ROW | CB-111 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CB-111: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CB-111) |
| WK-SCP0100-0332 | X-ROW | CB-115 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CB-115: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CB-115) |
| WK-SCP0100-0333 | X-ROW | CB-116 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CB-116: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CB-116) |
| WK-SCP0100-0334 | X-ROW | CB-117 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CB-117: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CB-117) |
| WK-SCP0100-0335 | X-ROW | CB-118 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CB-118: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CB-118) |
| WK-SCP0100-0336 | X-ROW | CC-102 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CC-102: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CC-102) |
| WK-SCP0100-0337 | X-ROW | CC-103 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CC-103: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CC-103) |
| WK-SCP0100-0338 | X-ROW | CC-104 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CC-104: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CC-104) |
| WK-SCP0100-0339 | X-ROW | ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — ExcelButton: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (ExcelButton) |
| WK-SCP0100-0340 | X-ROW | SCP0100_Global_PSI_Report.AfterFindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.AfterFindData: 진입점 집계 1검사 — NOPATH:1 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SCP0100_Global_PSI_Report.AfterFindD) |
| WK-SCP0100-0341 | X-ROW | SCP0100_Global_PSI_Report.BeforeFindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.BeforeFindData: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 3 (ACT:SCP0100_Global_PSI_Report.BeforeFind) |
| WK-SCP0100-0342 | X-ROW | SCP0100_Global_PSI_Report.BtnColumn_Clic | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.BtnColumn_Click: 진입점 집계 2검사 — PASS:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0100_Global_PSI_Report.BtnColumn_) |
| WK-SCP0100-0343 | X-ROW | SCP0100_Global_PSI_Report.BtnItemId_Clic | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.BtnItemId_Click: 진입점 집계 2검사 — PASS:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0100_Global_PSI_Report.BtnItemId_) |
| WK-SCP0100-0344 | X-ROW | SCP0100_Global_PSI_Report.BtnProject_Cli | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.BtnProject_Click: 진입점 집계 2검사 — PASS:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0100_Global_PSI_Report.BtnProject) |
| WK-SCP0100-0345 | X-ROW | SCP0100_Global_PSI_Report.CboBucketType_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.CboBucketType_SelectedIn: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.CboBucketT) |
| WK-SCP0100-0346 | X-ROW | SCP0100_Global_PSI_Report.CboDisplay_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.CboDisplay_SelectedIndex: 진입점 집계 4검사 — NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SCP0100_Global_PSI_Report.CboDisplay) |
| WK-SCP0100-0347 | X-ROW | SCP0100_Global_PSI_Report.CboPlanDate_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.CboPlanDate_SelectedInde: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.CboPlanDat) |
| WK-SCP0100-0348 | X-ROW | SCP0100_Global_PSI_Report.CboSearchLevel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.CboSearchLevel_SelectedI: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.CboSearchL) |
| WK-SCP0100-0349 | X-ROW | SCP0100_Global_PSI_Report.CboUnitQty_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.CboUnitQty_SelectedIndex: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.CboUnitQty) |
| WK-SCP0100-0350 | X-ROW | SCP0100_Global_PSI_Report.ClbDivision_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.ClbDivision_SelectedInde: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.ClbDivisio) |
| WK-SCP0100-0351 | X-ROW | SCP0100_Global_PSI_Report.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.CreateSpre) |
| WK-SCP0100-0352 | X-ROW | SCP0100_Global_PSI_Report.DCalendar_Valu | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.DCalendar_ValueChanged: 진입점 집계 4검사 — NOT_RUN:3 · WARN:1 |  | 2 (ACT:SCP0100_Global_PSI_Report.DCalendar_) |
| WK-SCP0100-0353 | X-ROW | SCP0100_Global_PSI_Report.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.DefineProperty: 진입점 집계 5검사 — NOT_RUN:3 · PASS:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0100_Global_PSI_Report.DefineProp) |
| WK-SCP0100-0354 | X-ROW | SCP0100_Global_PSI_Report.EnableSearchLe | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.EnableSearchLevel: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/STATE, 연결된 요소 검사 없음 |  | 2 (ACT:SCP0100_Global_PSI_Report.EnableSear) |
| WK-SCP0100-0355 | X-ROW | SCP0100_Global_PSI_Report.ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.ExcelButton: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/ENTRY/EXPR/LOCAL/THROW/UI_MISC/UI_PROP, 연 |  | 16 (ACT:SCP0100_Global_PSI_Report.ExcelButto) |
| WK-SCP0100-0356 | X-ROW | SCP0100_Global_PSI_Report.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.FindButton: 진입점 집계 3검사 — NOT_RUN:2 · REVIEW:1 |  | 1 (ACT:SCP0100_Global_PSI_Report.FindButton) |
| WK-SCP0100-0357 | X-ROW | SCP0100_Global_PSI_Report.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.FindData: 진입점 집계 3검사 — NOT_RUN:2 · REVIEW:1 |  | 1 (ACT:SCP0100_Global_PSI_Report.FindData) |
| WK-SCP0100-0358 | X-ROW | SCP0100_Global_PSI_Report.FindDataMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.FindDataMain: 진입점 집계 4검사 — NOT_RUN:2 · REVIEW:1 · PASS:1 |  | 5 (ACT:SCP0100_Global_PSI_Report.FindDataMa) |
| WK-SCP0100-0359 | X-ROW | SCP0100_Global_PSI_Report.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.Form_Load) |
| WK-SCP0100-0360 | X-ROW | SCP0100_Global_PSI_Report.GetMeasureData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.GetMeasureDataType: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.GetMeasure) |
| WK-SCP0100-0361 | X-ROW | SCP0100_Global_PSI_Report.GetPlanDate | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.GetPlanDate: 진입점 집계 5검사 — NOT_RUN:2 · PASS:1 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.GetPlanDat) |
| WK-SCP0100-0362 | X-ROW | SCP0100_Global_PSI_Report.GetPlanEndDate | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.GetPlanEndDate: 진입점 집계 4검사 — NOPATH:2 · TODO:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.GetPlanEnd) |
| WK-SCP0100-0363 | X-ROW | SCP0100_Global_PSI_Report.GetSiteList | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.GetSiteList: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:1 · TODO:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0100_Global_PSI_Report.GetSiteLis) |
| WK-SCP0100-0364 | X-ROW | SCP0100_Global_PSI_Report.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.GetSpdTitle: 진입점 집계 5검사 — NOT_RUN:2 · PASS:1 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.GetSpdTitl) |
| WK-SCP0100-0365 | X-ROW | SCP0100_Global_PSI_Report.GetUnitDivide | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.GetUnitDivide: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.GetUnitDiv) |
| WK-SCP0100-0366 | X-ROW | SCP0100_Global_PSI_Report.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.InitControls: 진입점 집계 13검사 — NOT_RUN:9 · PASS:4 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SCP0100_Global_PSI_Report.InitContro) |
| WK-SCP0100-0367 | X-ROW | SCP0100_Global_PSI_Report.InitControlsAf | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.InitControlsAfter: 진입점 집계 5검사 — NOT_RUN:3 · PASS:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0100_Global_PSI_Report.InitContro) |
| WK-SCP0100-0368 | X-ROW | SCP0100_Global_PSI_Report.InitQueryDics | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.InitQueryDics: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.InitQueryD) |
| WK-SCP0100-0369 | X-ROW | SCP0100_Global_PSI_Report.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.InitSpread) |
| WK-SCP0100-0370 | X-ROW | SCP0100_Global_PSI_Report.InitSpreadDate | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.InitSpreadDateColumn: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 18 (ACT:SCP0100_Global_PSI_Report.InitSpread) |
| WK-SCP0100-0371 | X-ROW | SCP0100_Global_PSI_Report.OnShown | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.OnShown: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0100_Global_PSI_Report.OnShown AC) |
| WK-SCP0100-0372 | X-ROW | SCP0100_Global_PSI_Report.RefreshDisplay | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.RefreshDisplay: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0100_Global_PSI_Report.RefreshDis) |
| WK-SCP0100-0373 | X-ROW | SCP0100_Global_PSI_Report.RefreshFromSit | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.RefreshFromSite: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0100_Global_PSI_Report.RefreshFro) |
| WK-SCP0100-0374 | X-ROW | SCP0100_Global_PSI_Report.RefreshPlant | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.RefreshPlant: 진입점 동작 재현 시나리오 필요 — 문장 종류 COMBO_DATA/ENTRY, 연결된 요소 검사 없음 |  | 2 (ACT:SCP0100_Global_PSI_Report.RefreshPla) |
| WK-SCP0100-0375 | X-ROW | SCP0100_Global_PSI_Report.RefreshPlantTy | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.RefreshPlantType: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0100_Global_PSI_Report.RefreshPla) |
| WK-SCP0100-0376 | X-ROW | SCP0100_Global_PSI_Report.RefreshSearchL | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.RefreshSearchLevel: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0100_Global_PSI_Report.RefreshSea) |
| WK-SCP0100-0377 | X-ROW | SCP0100_Global_PSI_Report.RefreshToSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.RefreshToSite: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0100_Global_PSI_Report.RefreshToS) |
| WK-SCP0100-0378 | X-ROW | SCP0100_Global_PSI_Report.SCP0100_Global | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.SCP0100_Global_PSI_Repor: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY/FLAG, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0100_Global_PSI_Report.SCP0100_Gl) |
| WK-SCP0100-0379 | X-ROW | SCP0100_Global_PSI_Report.SetBackColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.SetBackColor: 진입점 집계 11검사 — NOT_RUN:10 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 23 (ACT:SCP0100_Global_PSI_Report.SetBackCol) |
| WK-SCP0100-0380 | X-ROW | SCP0100_Global_PSI_Report.SetCalculating | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.SetCalculating: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0100_Global_PSI_Report.SetCalcula) |
| WK-SCP0100-0381 | X-ROW | SCP0100_Global_PSI_Report.SetCalendar | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.SetCalendar: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.SetCalenda) |
| WK-SCP0100-0382 | X-ROW | SCP0100_Global_PSI_Report.SetGridClear | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.SetGridClear: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.SetGridCle) |
| WK-SCP0100-0383 | X-ROW | SCP0100_Global_PSI_Report.SetLayout | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.SetLayout: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 16 (ACT:SCP0100_Global_PSI_Report.SetLayout ) |
| WK-SCP0100-0384 | X-ROW | SCP0100_Global_PSI_Report.SetSpreadColum | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.SetSpreadColumn: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0100_Global_PSI_Report.SetSpreadC) |
| WK-SCP0100-0385 | X-ROW | SCP0100_Global_PSI_Report.SetUnitQty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.SetUnitQty: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.SetUnitQty) |
| WK-SCP0100-0386 | X-ROW | SCP0100_Global_PSI_Report.SetVisibleColu | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.SetVisibleColumnCycle: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0100_Global_PSI_Report.SetVisible) |
| WK-SCP0100-0387 | X-ROW | SCP0100_Global_PSI_Report.VisibleSheet | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.VisibleSheet: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/STATE, 연결된 요소 검사 없음 |  | 11 (ACT:SCP0100_Global_PSI_Report.VisibleShe) |
| WK-SCP0100-0388 | X-ROW | SCP0100_Global_PSI_Report.btnMeasure_Cli | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.btnMeasure_Click: 진입점 집계 2검사 — PASS:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0100_Global_PSI_Report.btnMeasure) |
| WK-SCP0100-0389 | X-ROW | SCP0100_Global_PSI_Report.getEndYYYYMMDD | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.getEndYYYYMMDD: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.getEndYYYY) |
| WK-SCP0100-0390 | X-ROW | SCP0100_Global_PSI_Report.getFromYYYYMMD | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.getFromYYYYMMDD: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.getFromYYY) |
| WK-SCP0100-0391 | X-ROW | SCP0100_Global_PSI_Report.getStartYYYYMM | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.getStartYYYYMMDD: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.getStartYY) |
| WK-SCP0100-0392 | X-ROW | SCP0100_Global_PSI_Report.getToYYYYMMDD | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.getToYYYYMMDD: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.getToYYYYM) |
| WK-SCP0100-0393 | X-ROW | SCP0100_Global_PSI_Report.rgrpSearchLeve | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0100_Global_PSI_Report.rgrpSearchLevel_Selected: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0100_Global_PSI_Report.rgrpSearch) |
| WK-SCP0100-0394 | X-ROW | usrButton1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — usrButton1: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (usrButton1) |
| WK-SCP0100-0395 | G5 | (CELL_GROUP) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — (CELL_GROUP): 행 집계 — G5 10요소: NOPATH:10 (미실행 요소가 남아 판정필요) |  | 1 ((CELL_GROUP)) |
| WK-SCP0100-0396 | G5 | (세션) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — (세션): 행 집계 — G5 10요소: NOPATH:10 (미실행 요소가 남아 판정필요) |  | 1 ((세션)) |
| WK-SCP0100-0397 | G5 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — COMMON:UC-06: 행 집계 — G5 10요소: NOPATH:10 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0100-0398 | G5 | CboGraphType | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — CboGraphType: 행 집계 — G5 10요소: NOPATH:10 (미실행 요소가 남아 판정필요) |  | 1 (CboGraphType) |
| WK-SCP0100-0399 | G5 | MODAL:GlobalPsiReportModals | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MODAL:GlobalPsiReportModals: 행 집계 — G5 10요소: NOPATH:10 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:GlobalPsiReportModals) |
| WK-SCP0100-0400 | G5 | cboBucket | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — cboBucket: 행 집계 — G5 10요소: NOPATH:10 (미실행 요소가 남아 판정필요) |  | 1 (cboBucket) |
| WK-SCP0100-0401 | G5 | cboDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — cboDivision: 행 집계 — G5 10요소: NOPATH:10 (미실행 요소가 남아 판정필요) |  | 1 (cboDivision) |
| WK-SCP0100-0402 | G5 | cboFromSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — cboFromSite: 행 집계 — G5 10요소: NOPATH:10 (미실행 요소가 남아 판정필요) |  | 1 (cboFromSite) |
| WK-SCP0100-0403 | G5 | cboToSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — cboToSite: 행 집계 — G5 10요소: NOPATH:10 (미실행 요소가 남아 판정필요) |  | 1 (cboToSite) |
| WK-SCP0100-0404 | G5 | dtpFrom | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — dtpFrom: 행 집계 — G5 10요소: NOPATH:10 (미실행 요소가 남아 판정필요) |  | 1 (dtpFrom) |
| WK-SCP0100-0405 | G5 | dtpTo | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — dtpTo: 행 집계 — G5 10요소: NOPATH:10 (미실행 요소가 남아 판정필요) |  | 1 (dtpTo) |
| WK-SCP0100-0406 | G5 | ~~txtNickName~~ | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — ~~txtNickName~~: 행 집계 — G5 10요소: NOPATH:10 (미실행 요소가 남아 판정필요) |  | 1 (~~txtNickName~~) |
| WK-SCP0100-0407 | H6 | (CELL_GROUP) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — (CELL_GROUP): 행 집계 — H6 10요소: NOT_RUN:8 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 ((CELL_GROUP)) |
| WK-SCP0100-0408 | H6 | (세션) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — (세션): 행 집계 — H6 10요소: NOT_RUN:8 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 ((세션)) |
| WK-SCP0100-0409 | H6 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — COMMON:UC-06: 행 집계 — H6 10요소: NOT_RUN:8 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0100-0410 | H6 | CboGraphType | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — CboGraphType: 행 집계 — H6 10요소: NOT_RUN:8 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (CboGraphType) |
| WK-SCP0100-0411 | H6 | MODAL:GlobalPsiReportModals | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MODAL:GlobalPsiReportModals: 행 집계 — H6 10요소: NOT_RUN:8 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:GlobalPsiReportModals) |
| WK-SCP0100-0412 | H6 | cboBucket | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — cboBucket: 행 집계 — H6 10요소: NOT_RUN:8 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (cboBucket) |
| WK-SCP0100-0413 | H6 | cboDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — cboDivision: 행 집계 — H6 10요소: NOT_RUN:8 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (cboDivision) |
| WK-SCP0100-0414 | H6 | cboFromSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — cboFromSite: 행 집계 — H6 10요소: NOT_RUN:8 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (cboFromSite) |
| WK-SCP0100-0415 | H6 | cboToSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — cboToSite: 행 집계 — H6 10요소: NOT_RUN:8 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (cboToSite) |
| WK-SCP0100-0416 | H6 | dtpFrom | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — dtpFrom: 행 집계 — H6 10요소: NOT_RUN:8 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (dtpFrom) |
| WK-SCP0100-0417 | H6 | dtpTo | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — dtpTo: 행 집계 — H6 10요소: NOT_RUN:8 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (dtpTo) |
| WK-SCP0100-0418 | H6 | ~~txtNickName~~ | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — ~~txtNickName~~: 행 집계 — H6 10요소: NOT_RUN:8 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (~~txtNickName~~) |
| WK-SCP0100-0419 | M4 | (CELL_GROUP) | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — (CELL_GROUP): 행 집계 — M4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 ((CELL_GROUP)) |
| WK-SCP0100-0420 | M4 | (세션) | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — (세션): 행 집계 — M4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 ((세션)) |
| WK-SCP0100-0421 | M4 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — COMMON:UC-06: 행 집계 — M4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0100-0422 | M4 | CboGraphType | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — CboGraphType: 행 집계 — M4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (CboGraphType) |
| WK-SCP0100-0423 | M4 | MODAL:GlobalPsiReportModals | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MODAL:GlobalPsiReportModals: 행 집계 — M4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:GlobalPsiReportModals) |
| WK-SCP0100-0424 | M4 | cboBucket | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — cboBucket: 행 집계 — M4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (cboBucket) |
| WK-SCP0100-0425 | M4 | cboDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — cboDivision: 행 집계 — M4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (cboDivision) |
| WK-SCP0100-0426 | M4 | cboFromSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — cboFromSite: 행 집계 — M4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (cboFromSite) |
| WK-SCP0100-0427 | M4 | cboToSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — cboToSite: 행 집계 — M4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (cboToSite) |
| WK-SCP0100-0428 | M4 | dtpFrom | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — dtpFrom: 행 집계 — M4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (dtpFrom) |
| WK-SCP0100-0429 | M4 | dtpTo | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — dtpTo: 행 집계 — M4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (dtpTo) |
| WK-SCP0100-0430 | M4 | ~~txtNickName~~ | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — ~~txtNickName~~: 행 집계 — M4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (~~txtNickName~~) |
