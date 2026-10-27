# 작업 원장 — SCP0011 · 2026-10-26 12:52

> 검사 인스턴스 480건 중 PASS·NA 32건 외 **448건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 25 | 구현 위치 실존 |
| W4 | 검사기 구현 | 12 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 30 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 123 | 실행 → PASS |
| W7 | 기대값 확정 | 258 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 258 · E2E 123 · 하네스 42 · 대조표 25
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 8건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 62 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| C3 | CASCADE |  |  |  |  |  | 12 | 26 |  |  | 연쇄 자동 채움 |
| X-LOC | GEN |  | 25 |  |  |  |  | 12 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| E4 | EDIT |  |  |  |  |  | 19 | 18 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| H5 | DESIGN |  |  |  |  |  | 10 | 16 |  |  | 라벨 명칭 |
| G1 | GEN |  |  |  |  |  | 12 | 14 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| H2 | DESIGN |  |  |  |  |  | 6 | 19 |  |  | 배경·글자색 규칙 |
| B3 | COMBO |  |  |  | 12 |  |  | 11 |  |  | 콤보 후보 정렬 = AS-IS |
| B4 | COMBO |  |  |  |  | 12 |  | 11 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| A5 | DESIGN |  |  |  |  |  | 5 | 18 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| A1 | GEN |  |  |  |  |  |  | 20 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| G4 | DESIGN |  |  |  |  | 4 | 7 |  |  |  | 조회조건 표시·라벨·활성 |
| F4 | DB |  |  |  |  |  | 10 | 1 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| DB-SYN | DB |  |  |  |  | 7 |  | 1 |  |  | BE 계정 시노님·권한·대상 객체 |
| G5 | POPUP |  |  |  |  | 4 |  | 4 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 1 | 3 | 4 |  |  | 팝업 표준·열림 |
| C1 | CASCADE |  |  |  |  |  | 8 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| G6 | GEN |  |  |  |  |  | 7 | 1 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| M4 | POPUP |  |  |  |  |  | 4 | 4 |  |  | 팝업 선택값 반영 |
| D1 | EDIT |  |  |  |  |  | 1 | 6 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 1 | 6 |  |  | 행 값 기반 조건부 잠금 |
| D5 | EDIT |  |  |  |  |  | 5 | 2 |  |  | 셀 에디터 유형 |
| A6 | GEN |  |  |  |  |  | 4 |  |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| H4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| SC1 | DESIGN |  |  |  |  |  |  | 1 |  |  | 조회조건 순서 = 기준표 |
| G03-WIRE | GEN |  |  |  |  |  |  | 1 |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |

## W2 구현 위치 확인 (25)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0011-0001 | X-LOC | DeleteButton override `//siMain.Delete() | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (DeleteButton override `//siMain.Delete()) |
| WK-SCP0011-0002 | X-LOC | EditButton 편집모드 토글(SwitchLock/LockRange) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EditButton 편집모드 토글(SwitchLock/LockRange)) |
| WK-SCP0011-0003 | X-LOC | FindButton | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (FindButton) |
| WK-SCP0011-0004 | X-LOC | InsertButton override `//InsertRow();` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (InsertButton override `//InsertRow();`) |
| WK-SCP0011-0005 | X-LOC | R1 SmartColMerge | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R1 SmartColMerge) |
| WK-SCP0011-0006 | X-LOC | R12 Bucket/Sum 가시성 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R12 Bucket/Sum 가시성) |
| WK-SCP0011-0007 | X-LOC | R13 소수2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R13 소수2) |
| WK-SCP0011-0008 | X-LOC | R15 음수차단 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R15 음수차단) |
| WK-SCP0011-0009 | X-LOC | R16 LINE_TOTAL<100 적색 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R16 LINE_TOTAL<100 적색) |
| WK-SCP0011-0010 | X-LOC | R17 과거/실적 회색 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R17 과거/실적 회색) |
| WK-SCP0011-0011 | X-LOC | R18/R19 헤더 더블클릭 접기 + chkAll 게이트 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R18/R19 헤더 더블클릭 접기 + chkAll 게이트) |
| WK-SCP0011-0012 | X-LOC | R19 편집모드 lock 토글 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R19 편집모드 lock 토글) |
| WK-SCP0011-0013 | X-LOC | R2 EE 컬럼 visible | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R2 EE 컬럼 visible) |
| WK-SCP0011-0014 | X-LOC | R5 수치셀 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R5 수치셀) |
| WK-SCP0011-0015 | X-LOC | R6 토/일 색 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R6 토/일 색) |
| WK-SCP0011-0016 | X-LOC | R7 3단 헤더 span+SUM | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R7 3단 헤더 span+SUM) |
| WK-SCP0011-0017 | X-LOC | R8 SUM 열 잠금 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R8 SUM 열 잠금) |
| WK-SCP0011-0018 | X-LOC | R9/R10 조회후 전열잠금→편집구간 unlock | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R9/R10 조회후 전열잠금→편집구간 unlock) |
| WK-SCP0011-0019 | X-LOC | SaveButton→SaveData_Line | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SaveButton→SaveData_Line) |
| WK-SCP0011-0020 | X-LOC | btnCal "Calculate"(btnRun) Amend | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (btnCal "Calculate"(btnRun) Amend) |
| WK-SCP0011-0021 | X-LOC | btnMeasure(SCM0002_TitleSetForm_Popup) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (btnMeasure(SCM0002_TitleSetForm_Popup)) |
| WK-SCP0011-0022 | X-LOC | usrButton1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (usrButton1) |
| WK-SCP0011-0023 | X-LOC | §2.4 W_/M_ SUM 파생 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (§2.4 W_/M_ SUM 파생) |
| WK-SCP0011-0024 | X-LOC | §2.5 편집가능 4조건 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (§2.5 편집가능 4조건) |
| WK-SCP0011-0025 | X-LOC | §4.2 master drill | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (§4.2 master drill) |

## W4 검사기 구현 (12)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0011-0026 | B3 | DIVISION_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 DIVISION_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0011_ProductionPlan.Get_IsEditInf) |
| WK-SCP0011-0027 | B3 | ELECTRODE_TYPE | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 ELECTRODE_TYPE | 있음(SHEET_COLUMNS) | 1 (Electrode(다중)) |
| WK-SCP0011-0028 | B3 | ORIGIN_DIVISION_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 ORIGIN_DIVISION_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0011_ProductionPlan.Get_IsEditInf) |
| WK-SCP0011-0029 | B3 | PLAN_SEQ | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 PLAN_SEQ | 있음(SHEET_COLUMNS) | 6 (ACT:SCP0011_ProductionPlan.GetLastPlanVe) |
| WK-SCP0011-0030 | B3 | PLAN_START_YYYYMMDD | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 PLAN_START_YYYYMMDD | 있음(SHEET_COLUMNS) | 7 (ACT:SCP0011_ProductionPlan.GetLastPlanVe) |
| WK-SCP0011-0031 | B3 | PLAN_TYPE | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 PLAN_TYPE | 있음(SHEET_COLUMNS) | 7 (ACT:SCP0011_ProductionPlan.GetLastPlanVe) |
| WK-SCP0011-0032 | B3 | SCM_SITE_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 SCM_SITE_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0011_ProductionPlan.Get_IsEditInf) |
| WK-SCP0011-0033 | B3 | cboBucketType / Bucket / Bucket Type | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 2 (ACT:SCP0011_ProductionPlan.GetDayRange A) |
| WK-SCP0011-0034 | B3 | cboDivision / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboDivision / Division | 있음(FE 소스) | 4 (ACT:SCP0011_ProductionPlan.GetDayRange A) |
| WK-SCP0011-0035 | B3 | cboPlanDate / Plan-date / Plan Date | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboPlanDate / Plan-date / Plan Date | 있음(FE 소스) | 6 (ACT:SCP0011_ProductionPlan.GetDayRange A) |
| WK-SCP0011-0036 | B3 | cboPlanSeq / Seq / Plan Seq / Seq. | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboPlanSeq / Seq / Plan Seq / Seq. | 있음(FE 소스) | 4 (ACT:SCP0011_ProductionPlan.GetLastPlanVe) |
| WK-SCP0011-0037 | B3 | cboPlanType / Plan-type / Plan Type | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboPlanType / Plan-type / Plan Type | 있음(FE 소스) | 4 (ACT:SCP0011_ProductionPlan.GetLastPlanVe) |

## W5 검사기 연결 (30)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0011-0038 | B4 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0011_ProductionPlan.Get_IsEditInf) |
| WK-SCP0011-0039 | B4 | ELECTRODE_TYPE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL ELECTRODE_TYPE | 있음(SHEET_COLUMNS) | 1 (Electrode(다중)) |
| WK-SCP0011-0040 | B4 | ORIGIN_DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL ORIGIN_DIVISION_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0011_ProductionPlan.Get_IsEditInf) |
| WK-SCP0011-0041 | B4 | PLAN_SEQ | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL PLAN_SEQ | 있음(SHEET_COLUMNS) | 6 (ACT:SCP0011_ProductionPlan.GetLastPlanVe) |
| WK-SCP0011-0042 | B4 | PLAN_START_YYYYMMDD | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL PLAN_START_YYYYMMDD | 있음(SHEET_COLUMNS) | 7 (ACT:SCP0011_ProductionPlan.GetLastPlanVe) |
| WK-SCP0011-0043 | B4 | PLAN_TYPE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL PLAN_TYPE | 있음(SHEET_COLUMNS) | 7 (ACT:SCP0011_ProductionPlan.GetLastPlanVe) |
| WK-SCP0011-0044 | B4 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0011_ProductionPlan.Get_IsEditInf) |
| WK-SCP0011-0045 | B4 | cboBucketType / Bucket / Bucket Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 2 (ACT:SCP0011_ProductionPlan.GetDayRange A) |
| WK-SCP0011-0046 | B4 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 4 (ACT:SCP0011_ProductionPlan.GetDayRange A) |
| WK-SCP0011-0047 | B4 | cboPlanDate / Plan-date / Plan Date | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboPlanDate / Plan-date / Plan Date | 있음(FE 소스) | 6 (ACT:SCP0011_ProductionPlan.GetDayRange A) |
| WK-SCP0011-0048 | B4 | cboPlanSeq / Seq / Plan Seq / Seq. | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboPlanSeq / Seq / Plan Seq / Seq. | 있음(FE 소스) | 4 (ACT:SCP0011_ProductionPlan.GetLastPlanVe) |
| WK-SCP0011-0049 | B4 | cboPlanType / Plan-type / Plan Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboPlanType / Plan-type / Plan Type | 있음(FE 소스) | 4 (ACT:SCP0011_ProductionPlan.GetLastPlanVe) |
| WK-SCP0011-0050 | F2 | SCP0011 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0011 화면 | 판단불가(대상 단위 SCREEN) | 107 (btnCal "Calculate"(btnRun) Amend EditBut) |
| WK-SCP0011-0051 | F6 | SCP0011 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0011 화면 | 판단불가(대상 단위 SCREEN) | 104 (SaveButton→SaveData_Line ACT:SCP0011_Pro) |
| WK-SCP0011-0052 | DB-SYN | DM0003_GET_BUCKET_TYPE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DM0003_GET_BUCKET_TYPE_CODE | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0011_ProductionPlan.GetBucketType) |
| WK-SCP0011-0053 | DB-SYN | SCP0011_GET_LAST_PLAN_VERSION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0011_GET_LAST_PLAN_VERSION | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0011_ProductionPlan.GetLastPlanVe) |
| WK-SCP0011-0054 | DB-SYN | SCP0011_GET_PRODUCTION_PLAN_LINE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0011_GET_PRODUCTION_PLAN_LINE | 없음(PROC_M 대응 없음) | 13 (ACT:SCP0011_ProductionPlan.FindData_Line) |
| WK-SCP0011-0055 | DB-SYN | SCP0011_GET_PRODUCTION_PLAN_MODEL | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0011_GET_PRODUCTION_PLAN_MODEL | 없음(PROC_M 대응 없음) | 13 (ACT:SCP0011_ProductionPlan.FindData_Mode) |
| WK-SCP0011-0056 | DB-SYN | SCP0011_GET_PRODUCTION_PLAN_MODEL_TITLE_ | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0011_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL | 없음(PROC_M 대응 없음) | 9 (ACT:SCP0011_ProductionPlan.FindData_Mode) |
| WK-SCP0011-0057 | DB-SYN | SCP0011_SAVE_PRODUCTIO | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0011_SAVE_PRODUCTIO | 없음(PROC_M 대응 없음) | 1 (ACT:SCP0011_ProductionPlan.SaveData_Line) |
| WK-SCP0011-0058 | DB-SYN | SCP0011_SAVE_PRODUCTION_PLAN_LINE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0011_SAVE_PRODUCTION_PLAN_LINE | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0011_ProductionPlan.SaveData_Line) |
| WK-SCP0011-0059 | G4 | btnCal | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnCal | 있음(FE 소스) | 1 (btnCal "Calculate"(btnRun) Amend) |
| WK-SCP0011-0060 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 있음(FE 소스) | 2 (ACT:SCP0011_ProductionPlan.InitEvent ACT) |
| WK-SCP0011-0061 | G4 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnMeasure | 있음(FE 소스) | 2 (ACT:SCP0011_ProductionPlan.InitEvent ACT) |
| WK-SCP0011-0062 | G4 | btnRun | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnRun | 없음 | 1 (btnCal "Calculate"(btnRun) Amend) |
| WK-SCP0011-0063 | G5 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnMeasure | 있음(FE 소스) | 1 (btnMeasure(SCM0002_TitleSetForm_Popup)) |
| WK-SCP0011-0064 | G5 | cboBucketType / Bucket / Bucket Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 3 (ACT:SCP0011_ProductionPlan.SpdMain_CellD) |
| WK-SCP0011-0065 | G5 | chkAll / All / ALL | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND chkAll / All / ALL | 있음(FE 소스) | 5 (ACT:SCP0011_ProductionPlan.SpdMain_CellD) |
| WK-SCP0011-0066 | G5 | txtItemId / Material / Item Id | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND txtItemId / Material / Item Id | 있음(FE 소스) | 1 (Model(Item)) |
| WK-SCP0011-0067 | H6 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnMeasure | 있음(FE 소스) | 1 (btnMeasure(SCM0002_TitleSetForm_Popup)) |

## W6 검증 실행 (123)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0011-0068 | J2 | SCP0011 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0011 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 68 (btnCal "Calculate"(btnRun) Amend EditBut) |
| WK-SCP0011-0069 | C1 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0011_ProductionPlan.InitControls:) |
| WK-SCP0011-0070 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0011_ProductionPlan.RefreshDivsio) |
| WK-SCP0011-0071 | C1 | cboElectrode / Electrode | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboElectrode / Electrode · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0011_ProductionPlan.RefreshElectr) |
| WK-SCP0011-0072 | C1 | cboOperationGroup / Operation Group / Op | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboOperationGroup / Operation Group / Operation gr · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0011_ProductionPlan.RefreshOperat) |
| WK-SCP0011-0073 | C1 | cboPlanDate / Plan-date / Plan Date | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0011_ProductionPlan.RefreshPlanDa) |
| WK-SCP0011-0074 | C1 | cboPlanSeq / Seq / Plan Seq / Seq. | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboPlanSeq / Seq / Plan Seq / Seq. · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0011_ProductionPlan.RefreshPlanSe) |
| WK-SCP0011-0075 | C1 | cboPlanType / Plan-type / Plan Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboPlanType / Plan-type / Plan Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0011_ProductionPlan.RefreshPlanTy) |
| WK-SCP0011-0076 | C1 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0011_ProductionPlan.RefreshPlantS) |
| WK-SCP0011-0077 | C3 | COLUMN_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — COLUMN_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SCP0011_ProductionPlan.SetDataTableD) |
| WK-SCP0011-0078 | C3 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0011_ProductionPlan.SetPlantSiteB) |
| WK-SCP0011-0079 | C3 | ELECTRODE_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ELECTRODE_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0011_ProductionPlan.InitSpread:35) |
| WK-SCP0011-0080 | C3 | KEY_IDX | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — KEY_IDX · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SCP0011_ProductionPlan.Set_OnHandEOH) |
| WK-SCP0011-0081 | C3 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 65 (ACT:SCP0011_ProductionPlan.Set_FPOperati) |
| WK-SCP0011-0082 | C3 | MEASURE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — MEASURE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 10 (ACT:SCP0011_ProductionPlan.SetFormationY) |
| WK-SCP0011-0083 | C3 | MODEL_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — MODEL_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0011_ProductionPlan.SetColumnMode) |
| WK-SCP0011-0084 | C3 | OPERATION_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — OPERATION_GROUP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0011_ProductionPlan.SetPlantSiteB) |
| WK-SCP0011-0085 | C3 | ORIGIN_DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ORIGIN_DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0011_ProductionPlan.InitSpread:34) |
| WK-SCP0011-0086 | C3 | PLAN_SEQ | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PLAN_SEQ · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCP0011_ProductionPlan.GetLastPlanVe) |
| WK-SCP0011-0087 | C3 | PLAN_START_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PLAN_START_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCP0011_ProductionPlan.GetLastPlanVe) |
| WK-SCP0011-0088 | C3 | PLAN_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PLAN_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCP0011_ProductionPlan.GetLastPlanVe) |
| WK-SCP0011-0089 | K4 | SCP0011 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0011 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 45 (ACT:SCP0011_ProductionPlan.btnCal_Click ) |
| WK-SCP0011-0090 | F1 | SCP0011 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0011 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 108 (btnCal "Calculate"(btnRun) Amend EditBut) |
| WK-SCP0011-0091 | F5 | SCP0011 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0011 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 1 (DeleteButton override `//siMain.Delete()) |
| WK-SCP0011-0092 | F4 | DM0003_GET_BUCKET_TYPE_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DM0003_GET_BUCKET_TYPE_CODE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:SCP0011_ProductionPlan.GetBucketType) |
| WK-SCP0011-0093 | F4 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) —  |  | 409 (ACT:SCP0011_ProductionPlan.FindButton AC) |
| WK-SCP0011-0094 | F4 | PKG_SCP0011.P_SCP0011_GET_PLAN_EDIT_INFO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0011.P_SCP0011_GET_PLAN_EDIT_INFO · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: |  | 3 (ACT:SCP0011_ProductionPlan.Get_IsEditInf) |
| WK-SCP0011-0095 | F4 | SCM0001_GET_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:SCP0011_ProductionPlan.GetDivision:3) |
| WK-SCP0011-0096 | F4 | SCP0011_GET_LAST_PLAN_VERSION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0011_GET_LAST_PLAN_VERSION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trac |  | 2 (ACT:SCP0011_ProductionPlan.GetLastPlanVe) |
| WK-SCP0011-0097 | F4 | SCP0011_GET_PRODUCTION_PLAN_LINE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0011_GET_PRODUCTION_PLAN_LINE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·t |  | 409 (ACT:SCP0011_ProductionPlan.FindButton AC) |
| WK-SCP0011-0098 | F4 | SCP0011_GET_PRODUCTION_PLAN_MODEL | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0011_GET_PRODUCTION_PLAN_MODEL · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke· |  | 340 (ACT:SCP0011_ProductionPlan.FindButton AC) |
| WK-SCP0011-0099 | F4 | SCP0011_GET_PRODUCTION_PLAN_MODEL_TITLE_ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0011_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실 |  | 275 (ACT:SCP0011_ProductionPlan.FindButton AC) |
| WK-SCP0011-0100 | F4 | SCP0011_SAVE_PRODUCTIO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0011_SAVE_PRODUCTIO · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 102 (ACT:SCP0011_ProductionPlan.SaveButton AC) |
| WK-SCP0011-0101 | F4 | SCP0011_SAVE_PRODUCTION_PLAN_LINE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0011_SAVE_PRODUCTION_PLAN_LINE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke· |  | 102 (ACT:SCP0011_ProductionPlan.SaveButton AC) |
| WK-SCP0011-0102 | A5 | ELECTRODE_TYPE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ELECTRODE_TYPE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 8 (R2 EE 컬럼 visible ACT:SCP0011_ProductionP) |
| WK-SCP0011-0103 | A5 | KEY_IDX | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — KEY_IDX · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:SCP0011_ProductionPlan.InitSpread:28) |
| WK-SCP0011-0104 | A5 | MEASURE_NAME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — MEASURE_NAME · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 4 (ACT:SCP0011_ProductionPlan.InitSpread AC) |
| WK-SCP0011-0105 | A5 | ORIGIN_DIVISION_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ORIGIN_DIVISION_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 8 (R2 EE 컬럼 visible ACT:SCP0011_ProductionP) |
| WK-SCP0011-0106 | A5 | PLAN_START_YYYYMMDD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PLAN_START_YYYYMMDD · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:SCP0011_ProductionPlan.InitSpread:35) |
| WK-SCP0011-0107 | G4 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 6 (ACT:SCP0011_ProductionPlan.DefinePropert) |
| WK-SCP0011-0108 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0011_ProductionPlan.InitEvent ACT) |
| WK-SCP0011-0109 | G4 | cboOperationGroup / Operation Group / Op | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboOperationGroup / Operation Group / Operation gr · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0011_ProductionPlan.InitEvent ACT) |
| WK-SCP0011-0110 | G4 | cboPlanDate / Plan-date / Plan Date | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0011_ProductionPlan.InitControls ) |
| WK-SCP0011-0111 | G4 | cboPlanSeq / Seq / Plan Seq / Seq. | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboPlanSeq / Seq / Plan Seq / Seq. · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0011_ProductionPlan.InitControls ) |
| WK-SCP0011-0112 | G4 | cboPlanType / Plan-type / Plan Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboPlanType / Plan-type / Plan Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0011_ProductionPlan.InitControls ) |
| WK-SCP0011-0113 | G4 | chkSum / Sum | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkSum / Sum · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0011_ProductionPlan.DefinePropert) |
| WK-SCP0011-0114 | H2 | ELECTRODE_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ELECTRODE_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 8 (R2 EE 컬럼 visible ACT:SCP0011_ProductionP) |
| WK-SCP0011-0115 | H2 | KEY_IDX | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — KEY_IDX · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0011_ProductionPlan.InitSpread:28) |
| WK-SCP0011-0116 | H2 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0011_ProductionPlan.Set_FPOperati) |
| WK-SCP0011-0117 | H2 | MEASURE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — MEASURE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0011_ProductionPlan.InitSpread AC) |
| WK-SCP0011-0118 | H2 | ORIGIN_DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ORIGIN_DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 8 (R2 EE 컬럼 visible ACT:SCP0011_ProductionP) |
| WK-SCP0011-0119 | H2 | PLAN_START_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PLAN_START_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0011_ProductionPlan.InitSpread:35) |
| WK-SCP0011-0120 | H4 | SCP0011 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — SCP0011 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 8 (ACT:SCP0011_ProductionPlan.SpdLine_TopCh) |
| WK-SCP0011-0121 | H5 | ELECTRODE_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ELECTRODE_TYPE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 8 (R2 EE 컬럼 visible ACT:SCP0011_ProductionP) |
| WK-SCP0011-0122 | H5 | KEY_IDX | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — KEY_IDX · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:SCP0011_ProductionPlan.InitSpread:28) |
| WK-SCP0011-0123 | H5 | MEASURE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — MEASURE_NAME · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (ACT:SCP0011_ProductionPlan.InitSpread AC) |
| WK-SCP0011-0124 | H5 | ORIGIN_DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ORIGIN_DIVISION_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 8 (R2 EE 컬럼 visible ACT:SCP0011_ProductionP) |
| WK-SCP0011-0125 | H5 | PLAN_START_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PLAN_START_YYYYMMDD · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:SCP0011_ProductionPlan.InitSpread:35) |
| WK-SCP0011-0126 | H5 | cboBucketType / Bucket / Bucket Type | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) —  |  | 18 (ACT:SCP0011_ProductionPlan.SetSpreadColu) |
| WK-SCP0011-0127 | H5 | cboDivision / Division | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — cboDivision / Division · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCP0011_ProductionPlan.InitSpread AC) |
| WK-SCP0011-0128 | H5 | cboOperationGroup / Operation Group / Op | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — cboOperationGroup / Operation Group / Operation gr · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_ |  | 2 (ACT:SCP0011_ProductionPlan.InitSpread AC) |
| WK-SCP0011-0129 | H5 | chkAll / All / ALL | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — chkAll / All / ALL · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (R18/R19 헤더 더블클릭 접기 + chkAll 게이트) |
| WK-SCP0011-0130 | H5 | chkSum / Sum | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — chkSum / Sum · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (R12 Bucket/Sum 가시성 ACT:SCP0011_Productio) |
| WK-SCP0011-0131 | I1 | SCP0011 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0011 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 16 (btnCal "Calculate"(btnRun) Amend R15 음수차) |
| WK-SCP0011-0132 | D1 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 37 (ACT:SCP0011_ProductionPlan.EditButton AC) |
| WK-SCP0011-0133 | D3 | MEASURE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — MEASURE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 37 (ACT:SCP0011_ProductionPlan.EditButton AC) |
| WK-SCP0011-0134 | D5 | ELECTRODE_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ELECTRODE_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 7 (ACT:SCP0011_ProductionPlan.InitSpread AC) |
| WK-SCP0011-0135 | D5 | KEY_IDX | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — KEY_IDX · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (ACT:SCP0011_ProductionPlan.InitSpread:28) |
| WK-SCP0011-0136 | D5 | MEASURE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — MEASURE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:SCP0011_ProductionPlan.InitSpread AC) |
| WK-SCP0011-0137 | D5 | ORIGIN_DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ORIGIN_DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 7 (ACT:SCP0011_ProductionPlan.InitSpread AC) |
| WK-SCP0011-0138 | D5 | PLAN_START_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — PLAN_START_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (ACT:SCP0011_ProductionPlan.InitSpread:35) |
| WK-SCP0011-0139 | D6 | SCP0011 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0011 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 1 (InsertButton override `//InsertRow();`) |
| WK-SCP0011-0140 | E4 | COLUMN_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — COLUMN_NAME · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SCP0011_ProductionPlan.SetDataTableD) |
| WK-SCP0011-0141 | E4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0011_ProductionPlan.SetPlantSiteB) |
| WK-SCP0011-0142 | E4 | KEY_IDX | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — KEY_IDX · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SCP0011_ProductionPlan.Set_OnHandEOH) |
| WK-SCP0011-0143 | E4 | MEASURE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MEASURE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 65 (ACT:SCP0011_ProductionPlan.Set_FPOperati) |
| WK-SCP0011-0144 | E4 | MEASURE_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MEASURE_NAME · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 10 (ACT:SCP0011_ProductionPlan.SetFormationY) |
| WK-SCP0011-0145 | E4 | MODEL_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MODEL_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0011_ProductionPlan.SetColumnMode) |
| WK-SCP0011-0146 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0011_ProductionPlan.SaveData_Line) |
| WK-SCP0011-0147 | E4 | MSG00006 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00006 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0011_ProductionPlan.SaveChage_Cal) |
| WK-SCP0011-0148 | E4 | MSG00007 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00007 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0011_ProductionPlan.btnMeasure_Cl) |
| WK-SCP0011-0149 | E4 | MSG00084 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00084 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (R15 음수차단 ACT:SCP0011_ProductionPlan.Save) |
| WK-SCP0011-0150 | E4 | MSG00096 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00096 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0011_ProductionPlan.btnCal_Click:) |
| WK-SCP0011-0151 | E4 | MSG00109 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00109 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0011_ProductionPlan.EditButton:63) |
| WK-SCP0011-0152 | E4 | MSG00206 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00206 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (btnCal "Calculate"(btnRun) Amend ACT:SCP) |
| WK-SCP0011-0153 | E4 | OPERATION_GROUP | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — OPERATION_GROUP · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0011_ProductionPlan.SetPlantSiteB) |
| WK-SCP0011-0154 | E4 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 |  | 18 (ACT:SCP0011_ProductionPlan.SetSpreadColu) |
| WK-SCP0011-0155 | E4 | cboOperationGroup / Operation Group / Op | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboOperationGroup / Operation Group / Operation gr · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요 |  | 2 (ACT:SCP0011_ProductionPlan.SetColumnMode) |
| WK-SCP0011-0156 | E4 | cboPlanDate / Plan-date / Plan Date | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장  |  | 4 (ACT:SCP0011_ProductionPlan.SetChangedPer) |
| WK-SCP0011-0157 | E4 | cboPlanType / Plan-type / Plan Type | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboPlanType / Plan-type / Plan Type · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장  |  | 2 (ACT:SCP0011_ProductionPlan.Set_FPOperati) |
| WK-SCP0011-0158 | E4 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SCP0011_ProductionPlan.SetSpreadColu) |
| WK-SCP0011-0159 | A10 | SCP0011 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0011 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 118 (ACT:SCP0011_ProductionPlan.DefinePropert) |
| WK-SCP0011-0160 | A6 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새 |  | 304 (ACT:SCP0011_ProductionPlan.FindButton AC) |
| WK-SCP0011-0161 | A6 | SCP0011_GET_PRODUCTION_PLAN_LINE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SCP0011_GET_PRODUCTION_PLAN_LINE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace |  | 306 (ACT:SCP0011_ProductionPlan.FindButton AC) |
| WK-SCP0011-0162 | A6 | SCP0011_GET_PRODUCTION_PLAN_MODEL | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SCP0011_GET_PRODUCTION_PLAN_MODEL · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trac |  | 237 (ACT:SCP0011_ProductionPlan.FindButton AC) |
| WK-SCP0011-0163 | A6 | SCP0011_GET_PRODUCTION_PLAN_MODEL_TITLE_ | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SCP0011_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 |  | 172 (ACT:SCP0011_ProductionPlan.FindButton AC) |
| WK-SCP0011-0164 | G1 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0011_ProductionPlan.FindData_Mode) |
| WK-SCP0011-0165 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0011_ProductionPlan.FindData_Mode) |
| WK-SCP0011-0166 | G1 | cboElectrode / Electrode | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboElectrode / Electrode · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0011_ProductionPlan.FindData_Mode) |
| WK-SCP0011-0167 | G1 | cboOperationGroup / Operation Group / Op | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboOperationGroup / Operation Group / Operation gr · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0011_ProductionPlan.FindData_Mode) |
| WK-SCP0011-0168 | G1 | cboPlanDate / Plan-date / Plan Date | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0011_ProductionPlan.FindData_Mode) |
| WK-SCP0011-0169 | G1 | cboPlanSeq / Seq / Plan Seq / Seq. | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboPlanSeq / Seq / Plan Seq / Seq. · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0011_ProductionPlan.FindData_Mode) |
| WK-SCP0011-0170 | G1 | cboPlanType / Plan-type / Plan Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboPlanType / Plan-type / Plan Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0011_ProductionPlan.FindData_Mode) |
| WK-SCP0011-0171 | G1 | chkAll / All / ALL | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — chkAll / All / ALL · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0011_ProductionPlan.FindData_Mode) |
| WK-SCP0011-0172 | G1 | clbPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbPlantSite / Plant Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0011_ProductionPlan.FindData_Mode) |
| WK-SCP0011-0173 | G1 | txtItemId / Material / Item Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemId / Material / Item Id · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 5 (Model(Item) ACT:SCP0011_ProductionPlan.F) |
| WK-SCP0011-0174 | G1 | txtModelId / Model / Model Id / Model/Ni | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtModelId / Model / Model Id / Model/Nickname · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0011_ProductionPlan.FindData_Mode) |
| WK-SCP0011-0175 | G1 | txtNickName / Nick Name / Model/Nickname | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtNickName / Nick Name / Model/Nickname · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (Nick Name ACT:SCP0011_ProductionPlan.Fin) |
| WK-SCP0011-0176 | G6 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 6 (ACT:SCP0011_ProductionPlan.DefinePropert) |
| WK-SCP0011-0177 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCP0011_ProductionPlan.InitEvent ACT) |
| WK-SCP0011-0178 | G6 | cboOperationGroup / Operation Group / Op | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboOperationGroup / Operation Group / Operation gr · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCP0011_ProductionPlan.InitEvent ACT) |
| WK-SCP0011-0179 | G6 | cboPlanDate / Plan-date / Plan Date | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCP0011_ProductionPlan.InitControls ) |
| WK-SCP0011-0180 | G6 | cboPlanSeq / Seq / Plan Seq / Seq. | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboPlanSeq / Seq / Plan Seq / Seq. · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCP0011_ProductionPlan.InitControls ) |
| WK-SCP0011-0181 | G6 | cboPlanType / Plan-type / Plan Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboPlanType / Plan-type / Plan Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCP0011_ProductionPlan.InitControls ) |
| WK-SCP0011-0182 | G6 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCP0011_ProductionPlan.DefinePropert) |
| WK-SCP0011-0183 | X-REOPEN | SCP0011 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0011 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 16 (ACT:SCP0011_ProductionPlan.Dispose ACT:S) |
| WK-SCP0011-0184 | H6 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 3 (ACT:SCP0011_ProductionPlan.SpdMain_CellD) |
| WK-SCP0011-0185 | H6 | chkAll / All / ALL | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — chkAll / All / ALL · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 5 (ACT:SCP0011_ProductionPlan.SpdMain_CellD) |
| WK-SCP0011-0186 | H6 | txtItemId / Material / Item Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtItemId / Material / Item Id · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (Model(Item)) |
| WK-SCP0011-0187 | M4 | btnMeasure | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnMeasure · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (btnMeasure(SCM0002_TitleSetForm_Popup)) |
| WK-SCP0011-0188 | M4 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (ACT:SCP0011_ProductionPlan.SpdMain_CellD) |
| WK-SCP0011-0189 | M4 | chkAll / All / ALL | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — chkAll / All / ALL · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 5 (ACT:SCP0011_ProductionPlan.SpdMain_CellD) |
| WK-SCP0011-0190 | M4 | txtItemId / Material / Item Id | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtItemId / Material / Item Id · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (Model(Item)) |

## W7 기대값 확정 (258)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0011-0191 | C3 | SCP0011_ProductionPlan.CboDivision_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0011_ProductionPlan.CboDivision_SelectedIndexCh: 진입점 집계 — C3 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0011_ProductionPlan.CboDivision_S) |
| WK-SCP0011-0192 | C3 | SCP0011_ProductionPlan.CboOperationGroup | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0011_ProductionPlan.CboOperationGroup_SelectedI: 진입점 집계 — C3 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0011_ProductionPlan.CboOperationG) |
| WK-SCP0011-0193 | C3 | SCP0011_ProductionPlan.CboPlanDate_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0011_ProductionPlan.CboPlanDate_SelectedIndexCh: 진입점 집계 — C3 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0011_ProductionPlan.CboPlanDate_S) |
| WK-SCP0011-0194 | C3 | SCP0011_ProductionPlan.CboPlanSeq_Select | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0011_ProductionPlan.CboPlanSeq_SelectedIndexCha: 진입점 집계 — C3 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0011_ProductionPlan.CboPlanSeq_Se) |
| WK-SCP0011-0195 | C3 | SCP0011_ProductionPlan.CboPlanType_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0011_ProductionPlan.CboPlanType_SelectedIndexCh: 진입점 집계 — C3 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0011_ProductionPlan.CboPlanType_S) |
| WK-SCP0011-0196 | C3 | SCP0011_ProductionPlan.ClbPlantSite_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0011_ProductionPlan.ClbPlantSite_SelectedIndexC: 진입점 집계 — C3 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SCP0011_ProductionPlan.ClbPlantSite_) |
| WK-SCP0011-0197 | C3 | SCP0011_ProductionPlan.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0011_ProductionPlan.SetChangedControl: 진입점 집계 — C3 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0011_ProductionPlan.SetChangedCon) |
| WK-SCP0011-0198 | C3 | SCP0011_ProductionPlan.SetChangedPeriod | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0011_ProductionPlan.SetChangedPeriod: 진입점 집계 — C3 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0011_ProductionPlan.SetChangedPer) |
| WK-SCP0011-0199 | C3 | SCP0011_ProductionPlan.SetColumnModelVis | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0011_ProductionPlan.SetColumnModelVisible: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0011_ProductionPlan.SetColumnMode) |
| WK-SCP0011-0200 | C3 | SCP0011_ProductionPlan.SetDataTableDateC | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0011_ProductionPlan.SetDataTableDateColumn: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0011_ProductionPlan.SetDataTableD) |
| WK-SCP0011-0201 | C3 | SCP0011_ProductionPlan.SetDataTableQtyDa | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0011_ProductionPlan.SetDataTableQtyData: 진입점 집계 — C3 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0011_ProductionPlan.SetDataTableQ) |
| WK-SCP0011-0202 | C3 | SCP0011_ProductionPlan.SetFormationYield | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0011_ProductionPlan.SetFormationYield: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 50 (ACT:SCP0011_ProductionPlan.SetFormationY) |
| WK-SCP0011-0203 | C3 | SCP0011_ProductionPlan.SetFormationYield | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0011_ProductionPlan.SetFormationYield1: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCP0011_ProductionPlan.SetFormationY) |
| WK-SCP0011-0204 | C3 | SCP0011_ProductionPlan.SetLockSumColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0011_ProductionPlan.SetLockSumColumn: 진입점 집계 — C3 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0011_ProductionPlan.SetLockSumCol) |
| WK-SCP0011-0205 | C3 | SCP0011_ProductionPlan.SetOperationGroup | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0011_ProductionPlan.SetOperationGroupByDivision: 진입점 집계 — C3 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0011_ProductionPlan.SetOperationG) |
| WK-SCP0011-0206 | C3 | SCP0011_ProductionPlan.SetPlanDataTableQ | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0011_ProductionPlan.SetPlanDataTableQtyData: 진입점 집계 — C3 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 32 (ACT:SCP0011_ProductionPlan.SetPlanDataTa) |
| WK-SCP0011-0207 | C3 | SCP0011_ProductionPlan.SetPlantSiteByDiv | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0011_ProductionPlan.SetPlantSiteByDivision: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0011_ProductionPlan.SetPlantSiteB) |
| WK-SCP0011-0208 | C3 | SCP0011_ProductionPlan.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0011_ProductionPlan.SetSpreadColumn: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0011_ProductionPlan.SetSpreadColu) |
| WK-SCP0011-0209 | C3 | SCP0011_ProductionPlan.Set_FPOperationCo | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0011_ProductionPlan.Set_FPOperationColor: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 44 (ACT:SCP0011_ProductionPlan.Set_FPOperati) |
| WK-SCP0011-0210 | C3 | SCP0011_ProductionPlan.Set_OnHandEOH | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0011_ProductionPlan.Set_OnHandEOH: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 22 (ACT:SCP0011_ProductionPlan.Set_OnHandEOH) |
| WK-SCP0011-0211 | C3 | SCP0011_ProductionPlan.Set_OnHandEOH_Par | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0011_ProductionPlan.Set_OnHandEOH_Parallel: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 22 (ACT:SCP0011_ProductionPlan.Set_OnHandEOH) |
| WK-SCP0011-0212 | C3 | SCP0011_ProductionPlan.Set_ProductResult | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0011_ProductionPlan.Set_ProductResult: 진입점 집계 — C3 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0011_ProductionPlan.Set_ProductRe) |
| WK-SCP0011-0213 | C3 | SCP0011_ProductionPlan.SpdLine_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0011_ProductionPlan.SpdLine_Changed: 진입점 집계 — C3 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 16 (ACT:SCP0011_ProductionPlan.SpdLine_Chang) |
| WK-SCP0011-0214 | C3 | SCP0011_ProductionPlan.SpdLine_Selection | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0011_ProductionPlan.SpdLine_SelectionChanged: 진입점 집계 — C3 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0011_ProductionPlan.SpdLine_Selec) |
| WK-SCP0011-0215 | C3 | SCP0011_ProductionPlan.cboBucketType_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0011_ProductionPlan.cboBucketType_SelectedIndex: 진입점 집계 — C3 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 11 (ACT:SCP0011_ProductionPlan.cboBucketType) |
| WK-SCP0011-0216 | C3 | SCP0011_ProductionPlan.chkSum_CheckedCha | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0011_ProductionPlan.chkSum_CheckedChanged: 진입점 집계 — C3 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0011_ProductionPlan.chkSum_Checke) |
| WK-SCP0011-0217 | B3 | Plant Site(다중) | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — Plant Site(다중): 행 집계 — B3 12요소: TODO:12 (미실행 요소가 남아 판정필요) |  | 1 (Plant Site(다중)) |
| WK-SCP0011-0218 | B3 | SCP0011_ProductionPlan.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0011_ProductionPlan.GetBucketType: 진입점 집계 — B3 12요소: TODO:12 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0011_ProductionPlan.GetBucketType) |
| WK-SCP0011-0219 | B3 | SCP0011_ProductionPlan.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0011_ProductionPlan.GetDayRange: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0011_ProductionPlan.GetDayRange:3) |
| WK-SCP0011-0220 | B3 | SCP0011_ProductionPlan.GetDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0011_ProductionPlan.GetDivision: 진입점 집계 — B3 12요소: TODO:12 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0011_ProductionPlan.GetDivision:3) |
| WK-SCP0011-0221 | B3 | SCP0011_ProductionPlan.GetEventField | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0011_ProductionPlan.GetEventField: 진입점 집계 — B3 12요소: TODO:12 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCP0011_ProductionPlan.GetEventField) |
| WK-SCP0011-0222 | B3 | SCP0011_ProductionPlan.GetLastPlanVersio | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0011_ProductionPlan.GetLastPlanVersion: 진입점 집계 — B3 7요소: TODO:7 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0011_ProductionPlan.GetLastPlanVe) |
| WK-SCP0011-0223 | B3 | SCP0011_ProductionPlan.GetShipToParty | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0011_ProductionPlan.GetShipToParty: 진입점 집계 — B3 12요소: TODO:12 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0011_ProductionPlan.GetShipToPart) |
| WK-SCP0011-0224 | B3 | SCP0011_ProductionPlan.GetShipType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0011_ProductionPlan.GetShipType: 진입점 집계 — B3 12요소: TODO:12 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0011_ProductionPlan.GetShipType:3) |
| WK-SCP0011-0225 | B3 | SCP0011_ProductionPlan.GetSoldToParty | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0011_ProductionPlan.GetSoldToParty: 진입점 집계 — B3 12요소: TODO:12 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0011_ProductionPlan.GetSoldToPart) |
| WK-SCP0011-0226 | B3 | SCP0011_ProductionPlan.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0011_ProductionPlan.GetSpdTitle: 진입점 집계 — B3 12요소: TODO:12 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0011_ProductionPlan.GetSpdTitle:3) |
| WK-SCP0011-0227 | B3 | SCP0011_ProductionPlan.Get_IsEditInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0011_ProductionPlan.Get_IsEditInfo: 진입점 집계 — B3 6요소: TODO:6 (미실행 요소가 남아 판정필요) |  | 13 (ACT:SCP0011_ProductionPlan.Get_IsEditInf) |
| WK-SCP0011-0228 | B4 | Plant Site(다중) | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — Plant Site(다중): 행 집계 — B4 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 1 (Plant Site(다중)) |
| WK-SCP0011-0229 | B4 | SCP0011_ProductionPlan.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0011_ProductionPlan.GetBucketType: 진입점 집계 — B4 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0011_ProductionPlan.GetBucketType) |
| WK-SCP0011-0230 | B4 | SCP0011_ProductionPlan.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0011_ProductionPlan.GetDayRange: 진입점 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0011_ProductionPlan.GetDayRange:3) |
| WK-SCP0011-0231 | B4 | SCP0011_ProductionPlan.GetDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0011_ProductionPlan.GetDivision: 진입점 집계 — B4 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0011_ProductionPlan.GetDivision:3) |
| WK-SCP0011-0232 | B4 | SCP0011_ProductionPlan.GetEventField | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0011_ProductionPlan.GetEventField: 진입점 집계 — B4 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCP0011_ProductionPlan.GetEventField) |
| WK-SCP0011-0233 | B4 | SCP0011_ProductionPlan.GetLastPlanVersio | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0011_ProductionPlan.GetLastPlanVersion: 진입점 집계 — B4 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0011_ProductionPlan.GetLastPlanVe) |
| WK-SCP0011-0234 | B4 | SCP0011_ProductionPlan.GetShipToParty | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0011_ProductionPlan.GetShipToParty: 진입점 집계 — B4 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0011_ProductionPlan.GetShipToPart) |
| WK-SCP0011-0235 | B4 | SCP0011_ProductionPlan.GetShipType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0011_ProductionPlan.GetShipType: 진입점 집계 — B4 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0011_ProductionPlan.GetShipType:3) |
| WK-SCP0011-0236 | B4 | SCP0011_ProductionPlan.GetSoldToParty | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0011_ProductionPlan.GetSoldToParty: 진입점 집계 — B4 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0011_ProductionPlan.GetSoldToPart) |
| WK-SCP0011-0237 | B4 | SCP0011_ProductionPlan.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0011_ProductionPlan.GetSpdTitle: 진입점 집계 — B4 12요소: NOPATH:12 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0011_ProductionPlan.GetSpdTitle:3) |
| WK-SCP0011-0238 | B4 | SCP0011_ProductionPlan.Get_IsEditInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0011_ProductionPlan.Get_IsEditInfo: 진입점 집계 — B4 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 13 (ACT:SCP0011_ProductionPlan.Get_IsEditInf) |
| WK-SCP0011-0239 | DB-SYN | SaveButton→SaveData_Line | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SaveButton→SaveData_Line: 행 집계 — DB-SYN 10요소: NOPATH:7 · PASS:3 (미실행 요소가 남아 판정필요) |  | 1 (SaveButton→SaveData_Line) |
| WK-SCP0011-0240 | F4 | SaveButton→SaveData_Line | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SaveButton→SaveData_Line: 행 집계 — F4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (SaveButton→SaveData_Line) |
| WK-SCP0011-0241 | A5 | R1 SmartColMerge | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R1 SmartColMerge: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (R1 SmartColMerge) |
| WK-SCP0011-0242 | A5 | R12 Bucket/Sum 가시성 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R12 Bucket/Sum 가시성: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (R12 Bucket/Sum 가시성) |
| WK-SCP0011-0243 | A5 | R13 소수2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R13 소수2: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (R13 소수2) |
| WK-SCP0011-0244 | A5 | R15 음수차단 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R15 음수차단: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (R15 음수차단) |
| WK-SCP0011-0245 | A5 | R16 LINE_TOTAL<100 적색 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R16 LINE_TOTAL<100 적색: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (R16 LINE_TOTAL<100 적색) |
| WK-SCP0011-0246 | A5 | R17 과거/실적 회색 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R17 과거/실적 회색: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (R17 과거/실적 회색) |
| WK-SCP0011-0247 | A5 | R18/R19 헤더 더블클릭 접기 + chkAll 게이트 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R18/R19 헤더 더블클릭 접기 + chkAll 게이트: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (R18/R19 헤더 더블클릭 접기 + chkAll 게이트) |
| WK-SCP0011-0248 | A5 | R19 편집모드 lock 토글 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R19 편집모드 lock 토글: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (R19 편집모드 lock 토글) |
| WK-SCP0011-0249 | A5 | R5 수치셀 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R5 수치셀: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (R5 수치셀) |
| WK-SCP0011-0250 | A5 | R6 토/일 색 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R6 토/일 색: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (R6 토/일 색) |
| WK-SCP0011-0251 | A5 | R7 3단 헤더 span+SUM | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R7 3단 헤더 span+SUM: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (R7 3단 헤더 span+SUM) |
| WK-SCP0011-0252 | A5 | R8 SUM 열 잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R8 SUM 열 잠금: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (R8 SUM 열 잠금) |
| WK-SCP0011-0253 | A5 | R9/R10 조회후 전열잠금→편집구간 unlock | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R9/R10 조회후 전열잠금→편집구간 unlock: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (R9/R10 조회후 전열잠금→편집구간 unlock) |
| WK-SCP0011-0254 | A5 | SCP0011_ProductionPlan.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0011_ProductionPlan.CreateSpread: 진입점 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0011_ProductionPlan.CreateSpread:) |
| WK-SCP0011-0255 | A5 | SCP0011_ProductionPlan.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0011_ProductionPlan.SetSpreadColumn: 진입점 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0011_ProductionPlan.SetSpreadColu) |
| WK-SCP0011-0256 | A5 | §2.4 W_/M_ SUM 파생 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — §2.4 W_/M_ SUM 파생: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (§2.4 W_/M_ SUM 파생) |
| WK-SCP0011-0257 | A5 | §2.5 편집가능 4조건 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — §2.5 편집가능 4조건: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (§2.5 편집가능 4조건) |
| WK-SCP0011-0258 | A5 | §4.2 master drill | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — §4.2 master drill: 행 집계 — A5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (§4.2 master drill) |
| WK-SCP0011-0259 | H2 | R1 SmartColMerge | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R1 SmartColMerge: 행 집계 — H2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (R1 SmartColMerge) |
| WK-SCP0011-0260 | H2 | R12 Bucket/Sum 가시성 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R12 Bucket/Sum 가시성: 행 집계 — H2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (R12 Bucket/Sum 가시성) |
| WK-SCP0011-0261 | H2 | R13 소수2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R13 소수2: 행 집계 — H2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (R13 소수2) |
| WK-SCP0011-0262 | H2 | R15 음수차단 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R15 음수차단: 행 집계 — H2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (R15 음수차단) |
| WK-SCP0011-0263 | H2 | R16 LINE_TOTAL<100 적색 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R16 LINE_TOTAL<100 적색: 행 집계 — H2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (R16 LINE_TOTAL<100 적색) |
| WK-SCP0011-0264 | H2 | R17 과거/실적 회색 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R17 과거/실적 회색: 행 집계 — H2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (R17 과거/실적 회색) |
| WK-SCP0011-0265 | H2 | R18/R19 헤더 더블클릭 접기 + chkAll 게이트 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R18/R19 헤더 더블클릭 접기 + chkAll 게이트: 행 집계 — H2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (R18/R19 헤더 더블클릭 접기 + chkAll 게이트) |
| WK-SCP0011-0266 | H2 | R19 편집모드 lock 토글 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R19 편집모드 lock 토글: 행 집계 — H2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (R19 편집모드 lock 토글) |
| WK-SCP0011-0267 | H2 | R5 수치셀 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R5 수치셀: 행 집계 — H2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (R5 수치셀) |
| WK-SCP0011-0268 | H2 | R6 토/일 색 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R6 토/일 색: 행 집계 — H2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (R6 토/일 색) |
| WK-SCP0011-0269 | H2 | R7 3단 헤더 span+SUM | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R7 3단 헤더 span+SUM: 행 집계 — H2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (R7 3단 헤더 span+SUM) |
| WK-SCP0011-0270 | H2 | R8 SUM 열 잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R8 SUM 열 잠금: 행 집계 — H2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (R8 SUM 열 잠금) |
| WK-SCP0011-0271 | H2 | R9/R10 조회후 전열잠금→편집구간 unlock | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R9/R10 조회후 전열잠금→편집구간 unlock: 행 집계 — H2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (R9/R10 조회후 전열잠금→편집구간 unlock) |
| WK-SCP0011-0272 | H2 | SCP0011_ProductionPlan.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0011_ProductionPlan.CreateSpread: 진입점 집계 — H2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0011_ProductionPlan.CreateSpread:) |
| WK-SCP0011-0273 | H2 | SCP0011_ProductionPlan.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0011_ProductionPlan.SetSpreadColumn: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0011_ProductionPlan.SetSpreadColu) |
| WK-SCP0011-0274 | H2 | SCP0011_ProductionPlan.Set_FPOperationCo | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0011_ProductionPlan.Set_FPOperationColor: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 44 (ACT:SCP0011_ProductionPlan.Set_FPOperati) |
| WK-SCP0011-0275 | H2 | §2.4 W_/M_ SUM 파생 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — §2.4 W_/M_ SUM 파생: 행 집계 — H2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (§2.4 W_/M_ SUM 파생) |
| WK-SCP0011-0276 | H2 | §2.5 편집가능 4조건 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — §2.5 편집가능 4조건: 행 집계 — H2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (§2.5 편집가능 4조건) |
| WK-SCP0011-0277 | H2 | §4.2 master drill | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — §4.2 master drill: 행 집계 — H2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (§4.2 master drill) |
| WK-SCP0011-0278 | H5 | R1 SmartColMerge | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R1 SmartColMerge: 행 집계 — H5 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (R1 SmartColMerge) |
| WK-SCP0011-0279 | H5 | R13 소수2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R13 소수2: 행 집계 — H5 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (R13 소수2) |
| WK-SCP0011-0280 | H5 | R15 음수차단 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R15 음수차단: 행 집계 — H5 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (R15 음수차단) |
| WK-SCP0011-0281 | H5 | R16 LINE_TOTAL<100 적색 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R16 LINE_TOTAL<100 적색: 행 집계 — H5 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (R16 LINE_TOTAL<100 적색) |
| WK-SCP0011-0282 | H5 | R17 과거/실적 회색 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R17 과거/실적 회색: 행 집계 — H5 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (R17 과거/실적 회색) |
| WK-SCP0011-0283 | H5 | R19 편집모드 lock 토글 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R19 편집모드 lock 토글: 행 집계 — H5 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (R19 편집모드 lock 토글) |
| WK-SCP0011-0284 | H5 | R5 수치셀 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R5 수치셀: 행 집계 — H5 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (R5 수치셀) |
| WK-SCP0011-0285 | H5 | R6 토/일 색 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R6 토/일 색: 행 집계 — H5 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (R6 토/일 색) |
| WK-SCP0011-0286 | H5 | R7 3단 헤더 span+SUM | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R7 3단 헤더 span+SUM: 행 집계 — H5 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (R7 3단 헤더 span+SUM) |
| WK-SCP0011-0287 | H5 | R8 SUM 열 잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R8 SUM 열 잠금: 행 집계 — H5 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (R8 SUM 열 잠금) |
| WK-SCP0011-0288 | H5 | R9/R10 조회후 전열잠금→편집구간 unlock | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R9/R10 조회후 전열잠금→편집구간 unlock: 행 집계 — H5 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (R9/R10 조회후 전열잠금→편집구간 unlock) |
| WK-SCP0011-0289 | H5 | SCP0011_ProductionPlan.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0011_ProductionPlan.CreateSpread: 진입점 집계 — H5 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0011_ProductionPlan.CreateSpread:) |
| WK-SCP0011-0290 | H5 | SCP0011_ProductionPlan.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0011_ProductionPlan.SetSpreadColumn: 진입점 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0011_ProductionPlan.SetSpreadColu) |
| WK-SCP0011-0291 | H5 | §2.4 W_/M_ SUM 파생 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — §2.4 W_/M_ SUM 파생: 행 집계 — H5 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (§2.4 W_/M_ SUM 파생) |
| WK-SCP0011-0292 | H5 | §2.5 편집가능 4조건 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — §2.5 편집가능 4조건: 행 집계 — H5 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (§2.5 편집가능 4조건) |
| WK-SCP0011-0293 | H5 | §4.2 master drill | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — §4.2 master drill: 행 집계 — H5 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (§4.2 master drill) |
| WK-SCP0011-0294 | SC1 | SCP0011 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | SC1 기대값 확정 — SCP0011 화면: 게이트 SC1 조회조건 순서가 기준표(SCP SCP_화면별 조회조건 정리_260731_ |  | 1 (btnCal "Calculate"(btnRun) Amend) |
| WK-SCP0011-0295 | D1 | EditButton 편집모드 토글(SwitchLock/LockRange) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — EditButton 편집모드 토글(SwitchLock/LockRange): 행 집계 — D1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (EditButton 편집모드 토글(SwitchLock/LockRange)) |
| WK-SCP0011-0296 | D1 | R19 편집모드 lock 토글 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — R19 편집모드 lock 토글: 행 집계 — D1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (R19 편집모드 lock 토글) |
| WK-SCP0011-0297 | D1 | R8 SUM 열 잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — R8 SUM 열 잠금: 행 집계 — D1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (R8 SUM 열 잠금) |
| WK-SCP0011-0298 | D1 | R9/R10 조회후 전열잠금→편집구간 unlock | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — R9/R10 조회후 전열잠금→편집구간 unlock: 행 집계 — D1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (R9/R10 조회후 전열잠금→편집구간 unlock) |
| WK-SCP0011-0299 | D1 | SCP0011_ProductionPlan.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SCP0011_ProductionPlan.EditButton: 진입점 집계 — D1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 17 (ACT:SCP0011_ProductionPlan.EditButton:63) |
| WK-SCP0011-0300 | D1 | §2.5 편집가능 4조건 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — §2.5 편집가능 4조건: 행 집계 — D1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (§2.5 편집가능 4조건) |
| WK-SCP0011-0301 | D3 | EditButton 편집모드 토글(SwitchLock/LockRange) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — EditButton 편집모드 토글(SwitchLock/LockRange): 행 집계 — D3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (EditButton 편집모드 토글(SwitchLock/LockRange)) |
| WK-SCP0011-0302 | D3 | R19 편집모드 lock 토글 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — R19 편집모드 lock 토글: 행 집계 — D3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (R19 편집모드 lock 토글) |
| WK-SCP0011-0303 | D3 | R8 SUM 열 잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — R8 SUM 열 잠금: 행 집계 — D3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (R8 SUM 열 잠금) |
| WK-SCP0011-0304 | D3 | R9/R10 조회후 전열잠금→편집구간 unlock | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — R9/R10 조회후 전열잠금→편집구간 unlock: 행 집계 — D3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (R9/R10 조회후 전열잠금→편집구간 unlock) |
| WK-SCP0011-0305 | D3 | SCP0011_ProductionPlan.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SCP0011_ProductionPlan.EditButton: 진입점 집계 — D3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 17 (ACT:SCP0011_ProductionPlan.EditButton:63) |
| WK-SCP0011-0306 | D3 | §2.5 편집가능 4조건 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — §2.5 편집가능 4조건: 행 집계 — D3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (§2.5 편집가능 4조건) |
| WK-SCP0011-0307 | D5 | SCP0011_ProductionPlan.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0011_ProductionPlan.CreateSpread: 진입점 집계 — D5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0011_ProductionPlan.CreateSpread:) |
| WK-SCP0011-0308 | D5 | SCP0011_ProductionPlan.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0011_ProductionPlan.SetSpreadColumn: 진입점 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0011_ProductionPlan.SetSpreadColu) |
| WK-SCP0011-0309 | E4 | R5 수치셀 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — R5 수치셀: 행 집계 — E4 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 1 (R5 수치셀) |
| WK-SCP0011-0310 | E4 | SCP0011_ProductionPlan.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0011_ProductionPlan.SetChangedControl: 진입점 집계 — E4 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0011_ProductionPlan.SetChangedCon) |
| WK-SCP0011-0311 | E4 | SCP0011_ProductionPlan.SetChangedPeriod | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0011_ProductionPlan.SetChangedPeriod: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0011_ProductionPlan.SetChangedPer) |
| WK-SCP0011-0312 | E4 | SCP0011_ProductionPlan.SetColumnModelVis | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0011_ProductionPlan.SetColumnModelVisible: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0011_ProductionPlan.SetColumnMode) |
| WK-SCP0011-0313 | E4 | SCP0011_ProductionPlan.SetDataTableDateC | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0011_ProductionPlan.SetDataTableDateColumn: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0011_ProductionPlan.SetDataTableD) |
| WK-SCP0011-0314 | E4 | SCP0011_ProductionPlan.SetDataTableQtyDa | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0011_ProductionPlan.SetDataTableQtyData: 진입점 집계 — E4 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0011_ProductionPlan.SetDataTableQ) |
| WK-SCP0011-0315 | E4 | SCP0011_ProductionPlan.SetFormationYield | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0011_ProductionPlan.SetFormationYield: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 50 (ACT:SCP0011_ProductionPlan.SetFormationY) |
| WK-SCP0011-0316 | E4 | SCP0011_ProductionPlan.SetFormationYield | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0011_ProductionPlan.SetFormationYield1: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCP0011_ProductionPlan.SetFormationY) |
| WK-SCP0011-0317 | E4 | SCP0011_ProductionPlan.SetLockSumColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0011_ProductionPlan.SetLockSumColumn: 진입점 집계 — E4 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0011_ProductionPlan.SetLockSumCol) |
| WK-SCP0011-0318 | E4 | SCP0011_ProductionPlan.SetOperationGroup | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0011_ProductionPlan.SetOperationGroupByDivision: 진입점 집계 — E4 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0011_ProductionPlan.SetOperationG) |
| WK-SCP0011-0319 | E4 | SCP0011_ProductionPlan.SetPlanDataTableQ | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0011_ProductionPlan.SetPlanDataTableQtyData: 진입점 집계 — E4 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 32 (ACT:SCP0011_ProductionPlan.SetPlanDataTa) |
| WK-SCP0011-0320 | E4 | SCP0011_ProductionPlan.SetPlantSiteByDiv | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0011_ProductionPlan.SetPlantSiteByDivision: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0011_ProductionPlan.SetPlantSiteB) |
| WK-SCP0011-0321 | E4 | SCP0011_ProductionPlan.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0011_ProductionPlan.SetSpreadColumn: 진입점 집계 — E4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0011_ProductionPlan.SetSpreadColu) |
| WK-SCP0011-0322 | E4 | SCP0011_ProductionPlan.Set_FPOperationCo | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0011_ProductionPlan.Set_FPOperationColor: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 44 (ACT:SCP0011_ProductionPlan.Set_FPOperati) |
| WK-SCP0011-0323 | E4 | SCP0011_ProductionPlan.Set_OnHandEOH | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0011_ProductionPlan.Set_OnHandEOH: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 22 (ACT:SCP0011_ProductionPlan.Set_OnHandEOH) |
| WK-SCP0011-0324 | E4 | SCP0011_ProductionPlan.Set_OnHandEOH_Par | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0011_ProductionPlan.Set_OnHandEOH_Parallel: 진입점 집계 — E4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 22 (ACT:SCP0011_ProductionPlan.Set_OnHandEOH) |
| WK-SCP0011-0325 | E4 | SCP0011_ProductionPlan.Set_ProductResult | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0011_ProductionPlan.Set_ProductResult: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0011_ProductionPlan.Set_ProductRe) |
| WK-SCP0011-0326 | E4 | SaveButton→SaveData_Line | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SaveButton→SaveData_Line: 행 집계 — E4 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 1 (SaveButton→SaveData_Line) |
| WK-SCP0011-0327 | A1 | Division | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Division: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (Division) |
| WK-SCP0011-0328 | A1 | Electrode(다중) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Electrode(다중): 행 집계 — A1 4요소: REVIEW:4 |  | 1 (Electrode(다중)) |
| WK-SCP0011-0329 | A1 | FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindButton: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (FindButton) |
| WK-SCP0011-0330 | A1 | Model(Item) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Model(Item): 행 집계 — A1 4요소: REVIEW:4 |  | 1 (Model(Item)) |
| WK-SCP0011-0331 | A1 | Model(Item) 팝업 division | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Model(Item) 팝업 division: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (Model(Item) 팝업 division) |
| WK-SCP0011-0332 | A1 | Nick Name | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Nick Name: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (Nick Name) |
| WK-SCP0011-0333 | A1 | Operation Group | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Operation Group: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (Operation Group) |
| WK-SCP0011-0334 | A1 | PERIOD 동적콤보(#10/#11) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PERIOD 동적콤보(#10/#11): 행 집계 — A1 4요소: REVIEW:4 |  | 1 (PERIOD 동적콤보(#10/#11)) |
| WK-SCP0011-0335 | A1 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN: 골든 비교 케이스 없음(PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN — 팝업·보조 SP |  | 304 (ACT:SCP0011_ProductionPlan.FindButton AC) |
| WK-SCP0011-0336 | A1 | Period | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Period: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (Period) |
| WK-SCP0011-0337 | A1 | Plan Date | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Plan Date: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (Plan Date) |
| WK-SCP0011-0338 | A1 | Plan Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Plan Type: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (Plan Type) |
| WK-SCP0011-0339 | A1 | Plant Site(다중) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Plant Site(다중): 행 집계 — A1 4요소: REVIEW:4 |  | 1 (Plant Site(다중)) |
| WK-SCP0011-0340 | A1 | R9/R10 조회후 전열잠금→편집구간 unlock | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R9/R10 조회후 전열잠금→편집구간 unlock: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (R9/R10 조회후 전열잠금→편집구간 unlock) |
| WK-SCP0011-0341 | A1 | SCP0011_GET_PRODUCTION_PLAN_LINE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0011_GET_PRODUCTION_PLAN_LINE: 골든 비교 케이스 없음(SCP0011_GET_PRODUCTION_PLAN_LINE — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 |  | 306 (ACT:SCP0011_ProductionPlan.FindButton AC) |
| WK-SCP0011-0342 | A1 | SCP0011_GET_PRODUCTION_PLAN_MODEL | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0011_GET_PRODUCTION_PLAN_MODEL: 골든 비교 케이스 없음(SCP0011_GET_PRODUCTION_PLAN_MODEL — 팝업·보조 SP 는 golden_cases.csv 에 FE 실 |  | 237 (ACT:SCP0011_ProductionPlan.FindButton AC) |
| WK-SCP0011-0343 | A1 | SCP0011_GET_PRODUCTION_PLAN_MODEL_TITLE_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0011_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL: 골든 비교 케이스 없음(SCP0011_GET_PRODUCTION_PLAN_MODEL_TITLE_PARAL — 팝업·보조 SP 는 |  | 172 (ACT:SCP0011_ProductionPlan.FindButton AC) |
| WK-SCP0011-0344 | A1 | SaveButton→SaveData_Line | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SaveButton→SaveData_Line: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (SaveButton→SaveData_Line) |
| WK-SCP0011-0345 | A1 | Seq | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Seq: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (Seq) |
| WK-SCP0011-0346 | A1 | btnCal "Calculate"(btnRun) Amend | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — btnCal "Calculate"(btnRun) Amend: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (btnCal "Calculate"(btnRun) Amend) |
| WK-SCP0011-0347 | G03-WIRE | SCP0011 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G03-WIRE 기대값 확정 — SCP0011 화면: 게이트 G03 As-is 이벤트 btnCal.Click → btnCal_Click 매핑 / 게이트 G03 As-is 이벤트 this.Load → SCP0011_Production  |  | 38 (ACT:SCP0011_ProductionPlan..ctor ACT:SCP) |
| WK-SCP0011-0348 | G1 | Division | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Division: 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (Division) |
| WK-SCP0011-0349 | G1 | Electrode(다중) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Electrode(다중): 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (Electrode(다중)) |
| WK-SCP0011-0350 | G1 | FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — FindButton: 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (FindButton) |
| WK-SCP0011-0351 | G1 | Model(Item) 팝업 division | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Model(Item) 팝업 division: 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (Model(Item) 팝업 division) |
| WK-SCP0011-0352 | G1 | Operation Group | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Operation Group: 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (Operation Group) |
| WK-SCP0011-0353 | G1 | PERIOD 동적콤보(#10/#11) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — PERIOD 동적콤보(#10/#11): 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (PERIOD 동적콤보(#10/#11)) |
| WK-SCP0011-0354 | G1 | Period | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Period: 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (Period) |
| WK-SCP0011-0355 | G1 | Plan Date | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Plan Date: 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (Plan Date) |
| WK-SCP0011-0356 | G1 | Plan Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Plan Type: 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (Plan Type) |
| WK-SCP0011-0357 | G1 | Plant Site(다중) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Plant Site(다중): 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (Plant Site(다중)) |
| WK-SCP0011-0358 | G1 | R9/R10 조회후 전열잠금→편집구간 unlock | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — R9/R10 조회후 전열잠금→편집구간 unlock: 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (R9/R10 조회후 전열잠금→편집구간 unlock) |
| WK-SCP0011-0359 | G1 | SaveButton→SaveData_Line | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SaveButton→SaveData_Line: 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (SaveButton→SaveData_Line) |
| WK-SCP0011-0360 | G1 | Seq | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Seq: 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (Seq) |
| WK-SCP0011-0361 | G1 | btnCal "Calculate"(btnRun) Amend | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — btnCal "Calculate"(btnRun) Amend: 행 집계 — G1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (btnCal "Calculate"(btnRun) Amend) |
| WK-SCP0011-0362 | G6 | btnCal "Calculate"(btnRun) Amend | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — btnCal "Calculate"(btnRun) Amend: 행 집계 — G6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (btnCal "Calculate"(btnRun) Amend) |
| WK-SCP0011-0363 | X-LOC | Division | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Division: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Division) |
| WK-SCP0011-0364 | X-LOC | Electrode(다중) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Electrode(다중): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Electrode(다중)) |
| WK-SCP0011-0365 | X-LOC | Model(Item) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Model(Item): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Model(Item)) |
| WK-SCP0011-0366 | X-LOC | Model(Item) 팝업 division | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Model(Item) 팝업 division: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Model(Item) 팝업 division) |
| WK-SCP0011-0367 | X-LOC | Nick Name | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Nick Name: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Nick Name) |
| WK-SCP0011-0368 | X-LOC | Operation Group | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Operation Group: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Operation Group) |
| WK-SCP0011-0369 | X-LOC | PERIOD 동적콤보(#10/#11) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — PERIOD 동적콤보(#10/#11): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (PERIOD 동적콤보(#10/#11)) |
| WK-SCP0011-0370 | X-LOC | Period | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Period: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Period) |
| WK-SCP0011-0371 | X-LOC | Plan Date | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Plan Date: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Plan Date) |
| WK-SCP0011-0372 | X-LOC | Plan Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Plan Type: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Plan Type) |
| WK-SCP0011-0373 | X-LOC | Plant Site(다중) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Plant Site(다중): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Plant Site(다중)) |
| WK-SCP0011-0374 | X-LOC | Seq | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Seq: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Seq) |
| WK-SCP0011-0375 | X-ROW | SCP0011_ProductionPlan.CalculateSum | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.CalculateSum: 진입점 집계 1검사 — WARN:1 |  | 110 (ACT:SCP0011_ProductionPlan.CalculateSum ) |
| WK-SCP0011-0376 | X-ROW | SCP0011_ProductionPlan.CboDivision_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.CboDivision_SelectedIndexCh: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0011_ProductionPlan.CboDivision_S) |
| WK-SCP0011-0377 | X-ROW | SCP0011_ProductionPlan.CboOperationGroup | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.CboOperationGroup_SelectedI: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0011_ProductionPlan.CboOperationG) |
| WK-SCP0011-0378 | X-ROW | SCP0011_ProductionPlan.CboPlanDate_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.CboPlanDate_SelectedIndexCh: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0011_ProductionPlan.CboPlanDate_S) |
| WK-SCP0011-0379 | X-ROW | SCP0011_ProductionPlan.CboPlanSeq_Select | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.CboPlanSeq_SelectedIndexCha: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0011_ProductionPlan.CboPlanSeq_Se) |
| WK-SCP0011-0380 | X-ROW | SCP0011_ProductionPlan.CboPlanType_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.CboPlanType_SelectedIndexCh: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0011_ProductionPlan.CboPlanType_S) |
| WK-SCP0011-0381 | X-ROW | SCP0011_ProductionPlan.ClbPlantSite_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.ClbPlantSite_SelectedIndexC: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0011_ProductionPlan.ClbPlantSite_) |
| WK-SCP0011-0382 | X-ROW | SCP0011_ProductionPlan.ClearAllSheets | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.ClearAllSheets: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/GRID_CLEAR, 연결된 요소 검사 없음 |  | 3 (ACT:SCP0011_ProductionPlan.ClearAllSheet) |
| WK-SCP0011-0383 | X-ROW | SCP0011_ProductionPlan.ClearEventInvocat | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.ClearEventInvocations: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/ENTRY/GRID_SET/RETURN, 연결 |  | 5 (ACT:SCP0011_ProductionPlan.ClearEventInv) |
| WK-SCP0011-0384 | X-ROW | SCP0011_ProductionPlan.ClearUsrCheckedLi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.ClearUsrCheckedList: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/LIST_REBIND/STATE_RESET, 연결된 요소  |  | 4 (ACT:SCP0011_ProductionPlan.ClearUsrCheck) |
| WK-SCP0011-0385 | X-ROW | SCP0011_ProductionPlan.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0011_ProductionPlan.CreateSpread) |
| WK-SCP0011-0386 | X-ROW | SCP0011_ProductionPlan.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.DefineProperty: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0011_ProductionPlan.DefinePropert) |
| WK-SCP0011-0387 | X-ROW | SCP0011_ProductionPlan.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.EditButton: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:2 |  | 1 (ACT:SCP0011_ProductionPlan.EditButton:65) |
| WK-SCP0011-0388 | X-ROW | SCP0011_ProductionPlan.ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.ExcelButton: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/ENTRY/EXPR/LOCAL/THROW/UI_MISC/UI_PROP, 연결된  |  | 15 (ACT:SCP0011_ProductionPlan.ExcelButton A) |
| WK-SCP0011-0389 | X-ROW | SCP0011_ProductionPlan.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.FindButton: 진입점 집계 12검사 — NOT_RUN:8 · REVIEW:4 |  | 1 (ACT:SCP0011_ProductionPlan.FindButton) |
| WK-SCP0011-0390 | X-ROW | SCP0011_ProductionPlan.FindData_Line | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.FindData_Line: 진입점 집계 10검사 — NOT_RUN:6 · REVIEW:2 · PASS:1 · NOPATH:1 |  | 10 (ACT:SCP0011_ProductionPlan.FindData_Line) |
| WK-SCP0011-0391 | X-ROW | SCP0011_ProductionPlan.FindData_Model | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.FindData_Model: 진입점 집계 22검사 — NOT_RUN:16 · REVIEW:3 · NOPATH:2 · PASS:1 |  | 10 (ACT:SCP0011_ProductionPlan.FindData_Mode) |
| WK-SCP0011-0392 | X-ROW | SCP0011_ProductionPlan.FindData_Model_Pa | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.FindData_Model_Parallel: 진입점 집계 30검사 — NOT_RUN:22 · REVIEW:4 · NOPATH:3 · PASS:1 |  | 11 (ACT:SCP0011_ProductionPlan.FindData_Mode) |
| WK-SCP0011-0393 | X-ROW | SCP0011_ProductionPlan.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0011_ProductionPlan.Form_Load) |
| WK-SCP0011-0394 | X-ROW | SCP0011_ProductionPlan.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.GetBucketType: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0011_ProductionPlan.GetBucketType) |
| WK-SCP0011-0395 | X-ROW | SCP0011_ProductionPlan.GetDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.GetDivision: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:1 · TODO:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0011_ProductionPlan.GetDivision) |
| WK-SCP0011-0396 | X-ROW | SCP0011_ProductionPlan.GetEventField | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.GetEventField: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0011_ProductionPlan.GetEventField) |
| WK-SCP0011-0397 | X-ROW | SCP0011_ProductionPlan.GetShipToParty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.GetShipToParty: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0011_ProductionPlan.GetShipToPart) |
| WK-SCP0011-0398 | X-ROW | SCP0011_ProductionPlan.GetShipType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.GetShipType: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0011_ProductionPlan.GetShipType) |
| WK-SCP0011-0399 | X-ROW | SCP0011_ProductionPlan.GetSoldToParty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.GetSoldToParty: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0011_ProductionPlan.GetSoldToPart) |
| WK-SCP0011-0400 | X-ROW | SCP0011_ProductionPlan.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.GetSpdTitle: 진입점 집계 5검사 — NOT_RUN:2 · PASS:1 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0011_ProductionPlan.GetSpdTitle) |
| WK-SCP0011-0401 | X-ROW | SCP0011_ProductionPlan.Get_IsEditInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.Get_IsEditInfo: 진입점 집계 17검사 — NOPATH:6 · TODO:6 · REVIEW:2 · NOT_RUN:2 · PASS:1 |  | 1 (ACT:SCP0011_ProductionPlan.Get_IsEditInf) |
| WK-SCP0011-0402 | X-ROW | SCP0011_ProductionPlan.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.InitControls: 진입점 집계 10검사 — NOT_RUN:10 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0011_ProductionPlan.InitControls:) |
| WK-SCP0011-0403 | X-ROW | SCP0011_ProductionPlan.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.InitSpread: 진입점 집계 29검사 — NOT_RUN:29 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SCP0011_ProductionPlan.InitSpread:34) |
| WK-SCP0011-0404 | X-ROW | SCP0011_ProductionPlan.InitSpreadDateCol | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.InitSpreadDateColumn: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 15 (ACT:SCP0011_ProductionPlan.InitSpreadDat) |
| WK-SCP0011-0405 | X-ROW | SCP0011_ProductionPlan.RefreshDivsion | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.RefreshDivsion: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0011_ProductionPlan.RefreshDivsio) |
| WK-SCP0011-0406 | X-ROW | SCP0011_ProductionPlan.RefreshElectrodeT | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.RefreshElectrodeType: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0011_ProductionPlan.RefreshElectr) |
| WK-SCP0011-0407 | X-ROW | SCP0011_ProductionPlan.RefreshOperationG | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.RefreshOperationGroup: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0011_ProductionPlan.RefreshOperat) |
| WK-SCP0011-0408 | X-ROW | SCP0011_ProductionPlan.RefreshPlanDate | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.RefreshPlanDate: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0011_ProductionPlan.RefreshPlanDa) |
| WK-SCP0011-0409 | X-ROW | SCP0011_ProductionPlan.RefreshPlanSeq | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.RefreshPlanSeq: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0011_ProductionPlan.RefreshPlanSe) |
| WK-SCP0011-0410 | X-ROW | SCP0011_ProductionPlan.RefreshPlanType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.RefreshPlanType: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0011_ProductionPlan.RefreshPlanTy) |
| WK-SCP0011-0411 | X-ROW | SCP0011_ProductionPlan.RefreshPlantSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.RefreshPlantSite: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0011_ProductionPlan.RefreshPlantS) |
| WK-SCP0011-0412 | X-ROW | SCP0011_ProductionPlan.SaveChage_CalData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.SaveChage_CalData: 진입점 집계 11검사 — NOT_RUN:7 · NOPATH:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 33 (ACT:SCP0011_ProductionPlan.SaveChage_Cal) |
| WK-SCP0011-0413 | X-ROW | SCP0011_ProductionPlan.SaveData_Line | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.SaveData_Line: 진입점 집계 20검사 — NOT_RUN:12 · NOPATH:7 · PASS:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0011_ProductionPlan.SaveData_Line) |
| WK-SCP0011-0414 | X-ROW | SCP0011_ProductionPlan.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.SetChangedControl: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0011_ProductionPlan.SetChangedCon) |
| WK-SCP0011-0415 | X-ROW | SCP0011_ProductionPlan.SetChangedPeriod | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.SetChangedPeriod: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0011_ProductionPlan.SetChangedPer) |
| WK-SCP0011-0416 | X-ROW | SCP0011_ProductionPlan.SetColumnModelVis | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.SetColumnModelVisible: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0011_ProductionPlan.SetColumnMode) |
| WK-SCP0011-0417 | X-ROW | SCP0011_ProductionPlan.SetDataTableQtyDa | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.SetDataTableQtyData: 진입점 집계 3검사 — NOT_RUN:2 · WARN:1 |  | 2 (ACT:SCP0011_ProductionPlan.SetDataTableQ) |
| WK-SCP0011-0418 | X-ROW | SCP0011_ProductionPlan.SetLockSumColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.SetLockSumColumn: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0011_ProductionPlan.SetLockSumCol) |
| WK-SCP0011-0419 | X-ROW | SCP0011_ProductionPlan.SetOperationGroup | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.SetOperationGroupByDivision: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0011_ProductionPlan.SetOperationG) |
| WK-SCP0011-0420 | X-ROW | SCP0011_ProductionPlan.SetPlanDataTableQ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.SetPlanDataTableQtyData: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0011_ProductionPlan.SetPlanDataTa) |
| WK-SCP0011-0421 | X-ROW | SCP0011_ProductionPlan.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.SetSpreadColumn: 진입점 집계 16검사 — NOT_RUN:10 · REVIEW:6 |  | 7 (ACT:SCP0011_ProductionPlan.SetSpreadColu) |
| WK-SCP0011-0422 | X-ROW | SCP0011_ProductionPlan.Set_FPOperationCo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.Set_FPOperationColor: 진입점 집계 7검사 — NOT_RUN:4 · REVIEW:3 |  | 1 (ACT:SCP0011_ProductionPlan.Set_FPOperati) |
| WK-SCP0011-0423 | X-ROW | SCP0011_ProductionPlan.Set_OnHandEOH | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.Set_OnHandEOH: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:2 |  | 2 (ACT:SCP0011_ProductionPlan.Set_OnHandEOH) |
| WK-SCP0011-0424 | X-ROW | SCP0011_ProductionPlan.Set_OnHandEOH_Par | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.Set_OnHandEOH_Parallel: 진입점 집계 8검사 — NOT_RUN:6 · REVIEW:2 |  | 3 (ACT:SCP0011_ProductionPlan.Set_OnHandEOH) |
| WK-SCP0011-0425 | X-ROW | SCP0011_ProductionPlan.Set_ProductResult | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.Set_ProductResult: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0011_ProductionPlan.Set_ProductRe) |
| WK-SCP0011-0426 | X-ROW | SCP0011_ProductionPlan.SpdLine_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.SpdLine_Changed: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0011_ProductionPlan.SpdLine_Chang) |
| WK-SCP0011-0427 | X-ROW | SCP0011_ProductionPlan.SpdLine_Selection | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.SpdLine_SelectionChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0011_ProductionPlan.SpdLine_Selec) |
| WK-SCP0011-0428 | X-ROW | SCP0011_ProductionPlan.SpdLine_TopChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.SpdLine_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0011_ProductionPlan.SpdLine_TopCh) |
| WK-SCP0011-0429 | X-ROW | SCP0011_ProductionPlan.SpdMain_TopChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.SpdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0011_ProductionPlan.SpdMain_TopCh) |
| WK-SCP0011-0430 | X-ROW | SCP0011_ProductionPlan.btnCal_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.btnCal_Click: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0011_ProductionPlan.btnCal_Click:) |
| WK-SCP0011-0431 | X-ROW | SCP0011_ProductionPlan.btnItemId_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.btnItemId_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0011_ProductionPlan.btnItemId_Cli) |
| WK-SCP0011-0432 | X-ROW | SCP0011_ProductionPlan.btnMeasure_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.btnMeasure_Click: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0011_ProductionPlan.btnMeasure_Cl) |
| WK-SCP0011-0433 | X-ROW | SCP0011_ProductionPlan.cboBucketType_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.cboBucketType_SelectedIndex: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0011_ProductionPlan.cboBucketType) |
| WK-SCP0011-0434 | X-ROW | SCP0011_ProductionPlan.chkSum_CheckedCha | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.chkSum_CheckedChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0011_ProductionPlan.chkSum_Checke) |
| WK-SCP0011-0435 | X-ROW | SCP0011_ProductionPlan.spdLine_CellDoubl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0011_ProductionPlan.spdLine_CellDoubleClick: 진입점 집계 3검사 — NOPATH:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0011_ProductionPlan.spdLine_CellD) |
| WK-SCP0011-0436 | X-ROW | usrButton1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — usrButton1: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (usrButton1) |
| WK-SCP0011-0437 | G5 | Model(Item) 팝업 division | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — Model(Item) 팝업 division: 행 집계 — G5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (Model(Item) 팝업 division) |
| WK-SCP0011-0438 | G5 | SCP0011_ProductionPlan.SpdMain_CellDoubl | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCP0011_ProductionPlan.SpdMain_CellDoubleClick: 진입점 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0011_ProductionPlan.SpdMain_CellD) |
| WK-SCP0011-0439 | G5 | SCP0011_ProductionPlan.spdLine_CellDoubl | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCP0011_ProductionPlan.spdLine_CellDoubleClick: 진입점 집계 — G5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0011_ProductionPlan.spdLine_CellD) |
| WK-SCP0011-0440 | G5 | §4.2 master drill | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — §4.2 master drill: 행 집계 — G5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (§4.2 master drill) |
| WK-SCP0011-0441 | H6 | Model(Item) 팝업 division | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — Model(Item) 팝업 division: 행 집계 — H6 4요소: NOT_RUN:3 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (Model(Item) 팝업 division) |
| WK-SCP0011-0442 | H6 | SCP0011_ProductionPlan.SpdMain_CellDoubl | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCP0011_ProductionPlan.SpdMain_CellDoubleClick: 진입점 집계 — H6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0011_ProductionPlan.SpdMain_CellD) |
| WK-SCP0011-0443 | H6 | SCP0011_ProductionPlan.spdLine_CellDoubl | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCP0011_ProductionPlan.spdLine_CellDoubleClick: 진입점 집계 — H6 4요소: NOT_RUN:3 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0011_ProductionPlan.spdLine_CellD) |
| WK-SCP0011-0444 | H6 | §4.2 master drill | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — §4.2 master drill: 행 집계 — H6 4요소: NOT_RUN:3 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (§4.2 master drill) |
| WK-SCP0011-0445 | M4 | Model(Item) 팝업 division | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — Model(Item) 팝업 division: 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (Model(Item) 팝업 division) |
| WK-SCP0011-0446 | M4 | SCP0011_ProductionPlan.SpdMain_CellDoubl | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0011_ProductionPlan.SpdMain_CellDoubleClick: 진입점 집계 — M4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0011_ProductionPlan.SpdMain_CellD) |
| WK-SCP0011-0447 | M4 | SCP0011_ProductionPlan.spdLine_CellDoubl | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0011_ProductionPlan.spdLine_CellDoubleClick: 진입점 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0011_ProductionPlan.spdLine_CellD) |
| WK-SCP0011-0448 | M4 | §4.2 master drill | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — §4.2 master drill: 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (§4.2 master drill) |
