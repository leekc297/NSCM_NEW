# 작업 원장 — SCP0106 · 2026-10-26 12:55

> 검사 인스턴스 1102건 중 PASS·NA 201건 외 **901건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 16 | 구현 위치 실존 |
| W4 | 검사기 구현 | 27 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 73 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 149 | 실행 → PASS |
| W7 | 기대값 확정 | 636 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 626 · E2E 149 · 하네스 100 · 대조표 26
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 4건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 218 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| B3 | COMBO |  |  |  | 27 |  |  | 38 |  |  | 콤보 후보 정렬 = AS-IS |
| B4 | COMBO |  |  |  |  | 27 |  | 38 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| C3 | CASCADE |  |  |  |  |  | 14 | 44 |  |  | 연쇄 자동 채움 |
| E4 | EDIT |  |  |  |  |  | 26 | 17 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| D3 | EDIT |  |  |  |  |  | 2 | 33 |  |  | 행 값 기반 조건부 잠금 |
| G1 | GEN |  |  |  |  |  | 15 | 20 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| C2 | CASCADE |  |  |  |  |  | 2 | 28 |  |  | 그리드 셀 cascade 후보 |
| H2 | DESIGN |  |  |  |  |  | 3 | 27 |  |  | 배경·글자색 규칙 |
| D1 | EDIT |  |  |  |  |  | 2 | 28 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| C6 | CASCADE |  |  |  |  |  | 1 | 28 |  |  | 무변경 편집 종료 시 연쇄 미발동 |
| A5 | DESIGN |  |  |  |  |  | 1 | 28 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| X-LOC | GEN |  | 16 |  |  |  |  | 9 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| G4 | DESIGN |  |  |  |  | 2 | 15 | 8 |  |  | 조회조건 표시·라벨·활성 |
| G6 | GEN |  |  |  |  |  | 15 | 8 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| H5 | DESIGN |  |  |  |  |  | 4 | 15 |  |  | 라벨 명칭 |
| F4 | DB |  |  |  |  |  | 1 | 15 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| C1 | CASCADE |  |  |  |  |  | 13 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| B1 | COMBO |  |  |  |  | 12 |  |  |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 12 |  |  |  |  | 콤보 후보 중복 없음 |
| C4 | CASCADE |  |  |  |  |  | 12 |  |  |  | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| B6 | COMBO |  |  |  |  | 11 |  |  |  |  | ALL 옵션·다중선택 사양 |
| G5 | POPUP |  |  |  |  | 3 |  | 7 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 2 | 1 | 7 |  |  | 팝업 표준·열림 |
| M4 | POPUP |  |  |  |  |  | 3 | 7 |  |  | 팝업 선택값 반영 |
| X-REASON | DESIGN |  |  |  |  |  |  | 10 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| M3 | POPUP |  |  |  |  |  | 6 | 2 |  |  | 팝업 내부 기능(조회·CRUD) |
| D5 | EDIT |  |  |  |  |  | 1 | 1 |  |  | 셀 에디터 유형 |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| E5 | EDIT |  |  |  |  | 1 |  |  |  |  | 콤보 셀 후보 외 값 차단 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K-SA | COMMON |  |  |  |  |  | 1 |  |  |  | 조회영역 토글 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F3 | CRUD |  |  |  |  |  | 1 |  |  |  | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W2 구현 위치 확인 (16)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0106-0001 | X-LOC | 1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (1) |
| WK-SCP0106-0002 | X-LOC | 10 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (10) |
| WK-SCP0106-0003 | X-LOC | 11 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (11) |
| WK-SCP0106-0004 | X-LOC | 12 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (12) |
| WK-SCP0106-0005 | X-LOC | 2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (2) |
| WK-SCP0106-0006 | X-LOC | 3 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (3) |
| WK-SCP0106-0007 | X-LOC | 4 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (4) |
| WK-SCP0106-0008 | X-LOC | 5 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (5) |
| WK-SCP0106-0009 | X-LOC | 6 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (6) |
| WK-SCP0106-0010 | X-LOC | 7 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (7) |
| WK-SCP0106-0011 | X-LOC | 8 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (8) |
| WK-SCP0106-0012 | X-LOC | 9 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (9) |
| WK-SCP0106-0013 | X-LOC | COMMON:UC-02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: CapaLossPlan.tsx:354-364 > 351줄 |  | 1 (COMMON:UC-02) |
| WK-SCP0106-0014 | X-LOC | COMMON:UC-05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: CapaLossPlan.tsx:359-359 > 351줄 |  | 1 (COMMON:UC-05) |
| WK-SCP0106-0015 | X-LOC | D00-4e-001 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: CapaLossPlan.tsx:389-389 > 351줄 |  | 1 (D00-4e-001) |
| WK-SCP0106-0016 | X-LOC | D00-4e-002 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: CapaLossPlan.tsx:382-382 > 351줄 |  | 1 (D00-4e-002) |

## W4 검사기 구현 (27)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0106-0017 | B3 | BASE_QTY | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 BASE_QTY | 있음(SHEET_COLUMNS) | 6 (ACT:AssemblyCurrentCapaMeasureSet.GetBas) |
| WK-SCP0106-0018 | B3 | COMPANY_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 COMPANY_ID | 있음(SHEET_COLUMNS) | 6 (ACT:AssemblyCurrentCapaMeasureSet.GetVal) |
| WK-SCP0106-0019 | B3 | DIVISION_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 DIVISION_ID | 있음(SHEET_COLUMNS) | 8 (ACT:AssemblyCurrentCapaMeasureSet.GetVal) |
| WK-SCP0106-0020 | B3 | ELTR_LN_TP_CD | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 ELTR_LN_TP_CD | 있음(SHEET_COLUMNS) | 4 (ACT:AssemblyCurrentCapaMeasureSet.GetVal) |
| WK-SCP0106-0021 | B3 | FACTORY_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 FACTORY_ID | 있음(SHEET_COLUMNS) | 4 (ACT:AssemblyCurrentCapaMeasureSet.GetVal) |
| WK-SCP0106-0022 | B3 | LINE_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 LINE_ID | 있음(SHEET_COLUMNS) | 4 (ACT:AssemblyCurrentCapaMeasureSet.GetVal) |
| WK-SCP0106-0023 | B3 | MEASURE | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 MEASURE | 있음(SHEET_COLUMNS) | 13 (ACT:AssemblyCapaMeasureSet.GetLineValue ) |
| WK-SCP0106-0024 | B3 | NICK_NAME | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 NICK_NAME | 있음(SHEET_COLUMNS) | 6 (ACT:AssemblyCurrentCapaMeasureSet.GetVal) |
| WK-SCP0106-0025 | B3 | OPERATION_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 OPERATION_ID | 있음(SHEET_COLUMNS) | 4 (ACT:AssemblyCurrentCapaMeasureSet.GetVal) |
| WK-SCP0106-0026 | B3 | PFRSLT_QTY | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 PFRSLT_QTY | 있음(SHEET_COLUMNS) | 6 (ACT:AssemblyCurrentCapaMeasureSet.GetRes) |
| WK-SCP0106-0027 | B3 | PLANT_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 PLANT_ID | 있음(SHEET_COLUMNS) | 4 (ACT:AssemblyCurrentCapaMeasureSet.GetVal) |
| WK-SCP0106-0028 | B3 | SITE_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 SITE_ID | 있음(SHEET_COLUMNS) | 4 (ACT:AssemblyCurrentCapaMeasureSet.GetVal) |
| WK-SCP0106-0029 | B3 | VER_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 VER_ID | 있음(SHEET_COLUMNS) | 4 (ACT:AssemblyCurrentCapaMeasureSet.GetVal) |
| WK-SCP0106-0030 | B3 | VER_SEQ | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 VER_SEQ | 있음(SHEET_COLUMNS) | 6 (ACT:AssemblyCurrentCapaMeasureSet.GetVal) |
| WK-SCP0106-0031 | B3 | cboDivision / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboDivision / Division | 있음(FE 소스) | 2 (ACT:SCP0106_CAPA_Loss_Plan.getDivision A) |
| WK-SCP0106-0032 | B3 | cboProgressStatus / Status / Progress St | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboProgressStatus / Status / Progress Status | 있음(FE 소스) | 2 (ACT:SCP0106_CAPA_Loss_Plan.getProgressSt) |
| WK-SCP0106-0033 | B3 | cboSheetType / Status / Sheet Type | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboSheetType / Status / Sheet Type | 있음(FE 소스) | 2 (ACT:SCP0106_CAPA_Loss_Plan.getSheetType ) |
| WK-SCP0106-0034 | B3 | cboVersion / Plan Month / Version / Ver. | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboVersion / Plan Month / Version / Ver. | 있음(FE 소스) | 3 (ACT:SCP0106_CAPA_Loss_Plan.getVersion AC) |
| WK-SCP0106-0035 | B3 | cboVersionSeq / Version / Version Seq /  | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboVersionSeq / Version / Version Seq / Ver. | 있음(FE 소스) | 2 (ACT:SCP0106_CAPA_Loss_Plan.getVersionSeq) |
| WK-SCP0106-0036 | B3 | clbElectrodeType / Line Type / Electrode | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbElectrodeType / Line Type / Electrode Type | 있음(FE 소스) | 2 (ACT:SCP0106_CAPA_Loss_Plan.getElectrodeT) |
| WK-SCP0106-0037 | B3 | clbFactory / Building / Factory | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbFactory / Building / Factory | 있음(FE 소스) | 2 (ACT:SCP0106_CAPA_Loss_Plan.getFactory AC) |
| WK-SCP0106-0038 | B3 | clbLine / Line | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbLine / Line | 있음(FE 소스) | 2 (ACT:SCP0106_CAPA_Loss_Plan.getLine ACT:S) |
| WK-SCP0106-0039 | B3 | clbOperation / Operation | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbOperation / Operation | 있음(FE 소스) | 2 (ACT:SCP0106_CAPA_Loss_Plan.getOperation ) |
| WK-SCP0106-0040 | B3 | clbPlant / Plant | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbPlant / Plant | 있음(FE 소스) | 2 (ACT:SCP0106_CAPA_Loss_Plan.getPlant ACT:) |
| WK-SCP0106-0041 | B3 | clbSite / Site | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbSite / Site | 있음(FE 소스) | 2 (ACT:SCP0106_CAPA_Loss_Plan.getSite ACT:S) |
| WK-SCP0106-0042 | B3 | rgrpDivisionType / Division Type | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 rgrpDivisionType / Division Type | 있음(FE 소스) | 2 (ACT:SCP0106_CAPA_Loss_Plan.getDivisionTy) |
| WK-SCP0106-0043 | B3 | txtItem / ItemNames.MODEL / Item | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 txtItem / ItemNames.MODEL / Item | 있음(FE 소스) | 2 (ACT:SCP0106_CAPA_Loss_Plan.getItemId ACT) |

## W5 검사기 연결 (73)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0106-0044 | B1 | OPERATION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL OPERATION_ID | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0106-0045 | B1 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (D00-1-008) |
| WK-SCP0106-0046 | B1 | cboProgressStatus / Status / Progress St | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboProgressStatus / Status / Progress Status | 있음(FE 소스) | 1 (D00-1-009) |
| WK-SCP0106-0047 | B1 | cboSheetType / Status / Sheet Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboSheetType / Status / Sheet Type | 있음(FE 소스) | 1 (D00-1-010) |
| WK-SCP0106-0048 | B1 | cboVersion / Plan Month / Version / Ver. | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboVersion / Plan Month / Version / Ver. | 있음(FE 소스) | 1 (D00-1-011) |
| WK-SCP0106-0049 | B1 | cboVersionSeq / Version / Version Seq /  | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboVersionSeq / Version / Version Seq / Ver. | 있음(FE 소스) | 1 (D00-1-012) |
| WK-SCP0106-0050 | B1 | clbElectrodeType / Line Type / Electrode | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbElectrodeType / Line Type / Electrode Type | 있음(FE 소스) | 1 (D00-1-014) |
| WK-SCP0106-0051 | B1 | clbFactory / Building / Factory | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbFactory / Building / Factory | 있음(FE 소스) | 1 (D00-1-015) |
| WK-SCP0106-0052 | B1 | clbLine / Line | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbLine / Line | 있음(FE 소스) | 1 (D00-1-016) |
| WK-SCP0106-0053 | B1 | clbOperation / Operation | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbOperation / Operation | 있음(FE 소스) | 1 (D00-1-017) |
| WK-SCP0106-0054 | B1 | clbPlant / Plant | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbPlant / Plant | 있음(FE 소스) | 1 (D00-1-018) |
| WK-SCP0106-0055 | B1 | clbSite / Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbSite / Site | 있음(FE 소스) | 1 (D00-1-019) |
| WK-SCP0106-0056 | B2 | OPERATION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL OPERATION_ID | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0106-0057 | B2 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (D00-1-008) |
| WK-SCP0106-0058 | B2 | cboProgressStatus / Status / Progress St | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboProgressStatus / Status / Progress Status | 있음(FE 소스) | 1 (D00-1-009) |
| WK-SCP0106-0059 | B2 | cboSheetType / Status / Sheet Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboSheetType / Status / Sheet Type | 있음(FE 소스) | 1 (D00-1-010) |
| WK-SCP0106-0060 | B2 | cboVersion / Plan Month / Version / Ver. | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboVersion / Plan Month / Version / Ver. | 있음(FE 소스) | 1 (D00-1-011) |
| WK-SCP0106-0061 | B2 | cboVersionSeq / Version / Version Seq /  | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboVersionSeq / Version / Version Seq / Ver. | 있음(FE 소스) | 1 (D00-1-012) |
| WK-SCP0106-0062 | B2 | clbElectrodeType / Line Type / Electrode | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbElectrodeType / Line Type / Electrode Type | 있음(FE 소스) | 1 (D00-1-014) |
| WK-SCP0106-0063 | B2 | clbFactory / Building / Factory | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbFactory / Building / Factory | 있음(FE 소스) | 1 (D00-1-015) |
| WK-SCP0106-0064 | B2 | clbLine / Line | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbLine / Line | 있음(FE 소스) | 1 (D00-1-016) |
| WK-SCP0106-0065 | B2 | clbOperation / Operation | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbOperation / Operation | 있음(FE 소스) | 1 (D00-1-017) |
| WK-SCP0106-0066 | B2 | clbPlant / Plant | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbPlant / Plant | 있음(FE 소스) | 1 (D00-1-018) |
| WK-SCP0106-0067 | B2 | clbSite / Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbSite / Site | 있음(FE 소스) | 1 (D00-1-019) |
| WK-SCP0106-0068 | B4 | BASE_QTY | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL BASE_QTY | 있음(SHEET_COLUMNS) | 6 (ACT:AssemblyCurrentCapaMeasureSet.GetBas) |
| WK-SCP0106-0069 | B4 | COMPANY_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL COMPANY_ID | 있음(SHEET_COLUMNS) | 6 (ACT:AssemblyCurrentCapaMeasureSet.GetVal) |
| WK-SCP0106-0070 | B4 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 8 (ACT:AssemblyCurrentCapaMeasureSet.GetVal) |
| WK-SCP0106-0071 | B4 | ELTR_LN_TP_CD | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL ELTR_LN_TP_CD | 있음(SHEET_COLUMNS) | 4 (ACT:AssemblyCurrentCapaMeasureSet.GetVal) |
| WK-SCP0106-0072 | B4 | FACTORY_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL FACTORY_ID | 있음(SHEET_COLUMNS) | 4 (ACT:AssemblyCurrentCapaMeasureSet.GetVal) |
| WK-SCP0106-0073 | B4 | LINE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL LINE_ID | 있음(SHEET_COLUMNS) | 4 (ACT:AssemblyCurrentCapaMeasureSet.GetVal) |
| WK-SCP0106-0074 | B4 | MEASURE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL MEASURE | 있음(SHEET_COLUMNS) | 13 (ACT:AssemblyCapaMeasureSet.GetLineValue ) |
| WK-SCP0106-0075 | B4 | NICK_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL NICK_NAME | 있음(SHEET_COLUMNS) | 6 (ACT:AssemblyCurrentCapaMeasureSet.GetVal) |
| WK-SCP0106-0076 | B4 | OPERATION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL OPERATION_ID | 있음(SHEET_COLUMNS) | 5 (COMMON:UC-05 ACT:AssemblyCurrentCapaMeas) |
| WK-SCP0106-0077 | B4 | PFRSLT_QTY | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL PFRSLT_QTY | 있음(SHEET_COLUMNS) | 6 (ACT:AssemblyCurrentCapaMeasureSet.GetRes) |
| WK-SCP0106-0078 | B4 | PLANT_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL PLANT_ID | 있음(SHEET_COLUMNS) | 4 (ACT:AssemblyCurrentCapaMeasureSet.GetVal) |
| WK-SCP0106-0079 | B4 | SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL SITE_ID | 있음(SHEET_COLUMNS) | 4 (ACT:AssemblyCurrentCapaMeasureSet.GetVal) |
| WK-SCP0106-0080 | B4 | VER_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL VER_ID | 있음(SHEET_COLUMNS) | 4 (ACT:AssemblyCurrentCapaMeasureSet.GetVal) |
| WK-SCP0106-0081 | B4 | VER_SEQ | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL VER_SEQ | 있음(SHEET_COLUMNS) | 6 (ACT:AssemblyCurrentCapaMeasureSet.GetVal) |
| WK-SCP0106-0082 | B4 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 3 (D00-1-008 ACT:SCP0106_CAPA_Loss_Plan.get) |
| WK-SCP0106-0083 | B4 | cboProgressStatus / Status / Progress St | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboProgressStatus / Status / Progress Status | 있음(FE 소스) | 3 (D00-1-009 ACT:SCP0106_CAPA_Loss_Plan.get) |
| WK-SCP0106-0084 | B4 | cboSheetType / Status / Sheet Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboSheetType / Status / Sheet Type | 있음(FE 소스) | 3 (D00-1-010 ACT:SCP0106_CAPA_Loss_Plan.get) |
| WK-SCP0106-0085 | B4 | cboVersion / Plan Month / Version / Ver. | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboVersion / Plan Month / Version / Ver. | 있음(FE 소스) | 4 (D00-1-011 ACT:SCP0106_CAPA_Loss_Plan.get) |
| WK-SCP0106-0086 | B4 | cboVersionSeq / Version / Version Seq /  | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboVersionSeq / Version / Version Seq / Ver. | 있음(FE 소스) | 3 (D00-1-012 ACT:SCP0106_CAPA_Loss_Plan.get) |
| WK-SCP0106-0087 | B4 | clbElectrodeType / Line Type / Electrode | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbElectrodeType / Line Type / Electrode Type | 있음(FE 소스) | 3 (D00-1-014 ACT:SCP0106_CAPA_Loss_Plan.get) |
| WK-SCP0106-0088 | B4 | clbFactory / Building / Factory | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbFactory / Building / Factory | 있음(FE 소스) | 3 (D00-1-015 ACT:SCP0106_CAPA_Loss_Plan.get) |
| WK-SCP0106-0089 | B4 | clbLine / Line | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbLine / Line | 있음(FE 소스) | 3 (D00-1-016 ACT:SCP0106_CAPA_Loss_Plan.get) |
| WK-SCP0106-0090 | B4 | clbOperation / Operation | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbOperation / Operation | 있음(FE 소스) | 3 (D00-1-017 ACT:SCP0106_CAPA_Loss_Plan.get) |
| WK-SCP0106-0091 | B4 | clbPlant / Plant | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbPlant / Plant | 있음(FE 소스) | 3 (D00-1-018 ACT:SCP0106_CAPA_Loss_Plan.get) |
| WK-SCP0106-0092 | B4 | clbSite / Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbSite / Site | 있음(FE 소스) | 3 (D00-1-019 ACT:SCP0106_CAPA_Loss_Plan.get) |
| WK-SCP0106-0093 | B4 | rgrpDivisionType / Division Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND rgrpDivisionType / Division Type | 있음(FE 소스) | 2 (ACT:SCP0106_CAPA_Loss_Plan.getDivisionTy) |
| WK-SCP0106-0094 | B4 | txtItem / ItemNames.MODEL / Item | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND txtItem / ItemNames.MODEL / Item | 있음(FE 소스) | 2 (ACT:SCP0106_CAPA_Loss_Plan.getItemId ACT) |
| WK-SCP0106-0095 | B6 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (D00-1-008) |
| WK-SCP0106-0096 | B6 | cboProgressStatus / Status / Progress St | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboProgressStatus / Status / Progress Status | 있음(FE 소스) | 1 (D00-1-009) |
| WK-SCP0106-0097 | B6 | cboSheetType / Status / Sheet Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboSheetType / Status / Sheet Type | 있음(FE 소스) | 1 (D00-1-010) |
| WK-SCP0106-0098 | B6 | cboVersion / Plan Month / Version / Ver. | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboVersion / Plan Month / Version / Ver. | 있음(FE 소스) | 1 (D00-1-011) |
| WK-SCP0106-0099 | B6 | cboVersionSeq / Version / Version Seq /  | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboVersionSeq / Version / Version Seq / Ver. | 있음(FE 소스) | 1 (D00-1-012) |
| WK-SCP0106-0100 | B6 | clbElectrodeType / Line Type / Electrode | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbElectrodeType / Line Type / Electrode Type | 있음(FE 소스) | 1 (D00-1-014) |
| WK-SCP0106-0101 | B6 | clbFactory / Building / Factory | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbFactory / Building / Factory | 있음(FE 소스) | 1 (D00-1-015) |
| WK-SCP0106-0102 | B6 | clbLine / Line | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbLine / Line | 있음(FE 소스) | 1 (D00-1-016) |
| WK-SCP0106-0103 | B6 | clbOperation / Operation | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbOperation / Operation | 있음(FE 소스) | 1 (D00-1-017) |
| WK-SCP0106-0104 | B6 | clbPlant / Plant | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbPlant / Plant | 있음(FE 소스) | 1 (D00-1-018) |
| WK-SCP0106-0105 | B6 | clbSite / Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbSite / Site | 있음(FE 소스) | 1 (D00-1-019) |
| WK-SCP0106-0106 | F2 | SCP0106 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0106 화면 | 판단불가(대상 단위 SCREEN) | 38 (D00-4d-011 D00-4d-012 D00-4d-013 D00-4d-) |
| WK-SCP0106-0107 | F6 | SCP0106 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0106 화면 | 판단불가(대상 단위 SCREEN) | 26 (ACT:SCP0106_CAPA_Loss_Plan.SaveButton AC) |
| WK-SCP0106-0108 | G4 | btnItem | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItem | 없음 | 2 (ACT:SCP0106_CAPA_Loss_Plan.InitEvent ACT) |
| WK-SCP0106-0109 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 없음 | 2 (ACT:SCP0106_CAPA_Loss_Plan.InitEvent ACT) |
| WK-SCP0106-0110 | E5 | OPERATION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL OPERATION_ID | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0106-0111 | G03-WIRE | SCP0106 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0106 화면 | 판단불가(대상 단위 SCREEN) | 71 (ACT:AssemblyCapaMeasureSet..ctor ACT:Ass) |
| WK-SCP0106-0112 | G5 | btnColumn | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnColumn | 있음(FE 소스) | 1 (`components/CapaLossPlanColumnModal.tsx`) |
| WK-SCP0106-0113 | G5 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnItemId | 없음 | 3 (D00-1-007 D00-2-003 `components/CapaLoss) |
| WK-SCP0106-0114 | G5 | txtItem / ItemNames.MODEL / Item | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND txtItem / ItemNames.MODEL / Item | 있음(FE 소스) | 1 (D00-1-040) |
| WK-SCP0106-0115 | H6 | btnColumn | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnColumn | 있음(FE 소스) | 1 (`components/CapaLossPlanColumnModal.tsx`) |
| WK-SCP0106-0116 | H6 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnItemId | 없음 | 3 (D00-1-007 D00-2-003 `components/CapaLoss) |

## W6 검증 실행 (149)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0106-0117 | J2 | SCP0106 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0106 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 64 (D00-1-006 D00-1-025 D00-1-040 D00-1-043 ) |
| WK-SCP0106-0118 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-004 ACT:SCP0106_CAPA_Loss_Plan.Ref) |
| WK-SCP0106-0119 | C1 | cboProgressStatus / Status / Progress St | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboProgressStatus / Status / Progress Status · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-005 ACT:SCP0106_CAPA_Loss_Plan.Ref) |
| WK-SCP0106-0120 | C1 | cboSheetType / Status / Sheet Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboSheetType / Status / Sheet Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (D00-2-006) |
| WK-SCP0106-0121 | C1 | cboVersion / Plan Month / Version / Ver. | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboVersion / Plan Month / Version / Ver. · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-007 ACT:SCP0106_CAPA_Loss_Plan.Ref) |
| WK-SCP0106-0122 | C1 | cboVersionSeq / Version / Version Seq /  | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboVersionSeq / Version / Version Seq / Ver. · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-008 ACT:SCP0106_CAPA_Loss_Plan.Ref) |
| WK-SCP0106-0123 | C1 | chkShowRate / Show Rate Columns / Show R | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — chkShowRate / Show Rate Columns / Show Rate · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-009 events) |
| WK-SCP0106-0124 | C1 | clbElectrodeType / Line Type / Electrode | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbElectrodeType / Line Type / Electrode Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.RefreshElectr) |
| WK-SCP0106-0125 | C1 | clbFactory / Building / Factory | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbFactory / Building / Factory · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-010 ACT:SCP0106_CAPA_Loss_Plan.Ref) |
| WK-SCP0106-0126 | C1 | clbLine / Line | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbLine / Line · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-011 ACT:SCP0106_CAPA_Loss_Plan.Ref) |
| WK-SCP0106-0127 | C1 | clbOperation / Operation | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbOperation / Operation · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-012 ACT:SCP0106_CAPA_Loss_Plan.Ref) |
| WK-SCP0106-0128 | C1 | clbPlant / Plant | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbPlant / Plant · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-013 ACT:SCP0106_CAPA_Loss_Plan.Ref) |
| WK-SCP0106-0129 | C1 | clbSite / Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbSite / Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-014 ACT:SCP0106_CAPA_Loss_Plan.Ref) |
| WK-SCP0106-0130 | C1 | rgrpDivisionType / Division Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — rgrpDivisionType / Division Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (D00-2-015) |
| WK-SCP0106-0131 | C2 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0106_CAPA_Loss_Plan._defaultDataM) |
| WK-SCP0106-0132 | C2 | VER_SEQ | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — VER_SEQ · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.RefreshVersio) |
| WK-SCP0106-0133 | C3 | BASE_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — BASE_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 10 (ACT:SCP0106_CAPA_Loss_Plan.SetLockColumn) |
| WK-SCP0106-0134 | C3 | COMPANY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — COMPANY_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 10 (ACT:SCP0106_CAPA_Loss_Plan.SetQueryInfoS) |
| WK-SCP0106-0135 | C3 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 10 (ACT:SCP0106_CAPA_Loss_Plan.SetQueryInfoS) |
| WK-SCP0106-0136 | C3 | ELTR_LN_TP_CD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ELTR_LN_TP_CD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 8 (ACT:SCP0106_CAPA_Loss_Plan.SetQueryInfoS) |
| WK-SCP0106-0137 | C3 | FACTORY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — FACTORY_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 8 (ACT:SCP0106_CAPA_Loss_Plan.SetQueryInfoS) |
| WK-SCP0106-0138 | C3 | LINE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — LINE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 8 (ACT:SCP0106_CAPA_Loss_Plan.SetQueryInfoS) |
| WK-SCP0106-0139 | C3 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 12 (ACT:SCP0106_CAPA_Loss_Plan.SetLockColumn) |
| WK-SCP0106-0140 | C3 | MEASURE_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — MEASURE_GROUP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0106_CAPA_Loss_Plan.SetQueryInfoS) |
| WK-SCP0106-0141 | C3 | MEASURE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — MEASURE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 11 (ACT:SCP0106_CAPA_Loss_Plan.SetLockColumn) |
| WK-SCP0106-0142 | C3 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 11 (ACT:SCP0106_CAPA_Loss_Plan.SetQueryInfoS) |
| WK-SCP0106-0143 | C3 | OPERATION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — OPERATION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 12 (ACT:SCP0106_CAPA_Loss_Plan.SetLockColumn) |
| WK-SCP0106-0144 | C3 | PFRSLT_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PFRSLT_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 10 (ACT:SCP0106_CAPA_Loss_Plan.SetLockColumn) |
| WK-SCP0106-0145 | C3 | PLANT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PLANT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 8 (ACT:SCP0106_CAPA_Loss_Plan.SetQueryInfoS) |
| WK-SCP0106-0146 | C3 | SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 10 (ACT:SCP0106_CAPA_Loss_Plan.SetQueryInfoS) |
| WK-SCP0106-0147 | C4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-004) |
| WK-SCP0106-0148 | C4 | cboProgressStatus / Status / Progress St | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboProgressStatus / Status / Progress Status · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-005) |
| WK-SCP0106-0149 | C4 | cboSheetType / Status / Sheet Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboSheetType / Status / Sheet Type · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-006) |
| WK-SCP0106-0150 | C4 | cboVersion / Plan Month / Version / Ver. | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboVersion / Plan Month / Version / Ver. · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-007) |
| WK-SCP0106-0151 | C4 | cboVersionSeq / Version / Version Seq /  | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboVersionSeq / Version / Version Seq / Ver. · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-008) |
| WK-SCP0106-0152 | C4 | chkShowRate / Show Rate Columns / Show R | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — chkShowRate / Show Rate Columns / Show Rate · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 2 (D00-2-009 events) |
| WK-SCP0106-0153 | C4 | clbFactory / Building / Factory | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — clbFactory / Building / Factory · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-010) |
| WK-SCP0106-0154 | C4 | clbLine / Line | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — clbLine / Line · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-011) |
| WK-SCP0106-0155 | C4 | clbOperation / Operation | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — clbOperation / Operation · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-012) |
| WK-SCP0106-0156 | C4 | clbPlant / Plant | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — clbPlant / Plant · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-013) |
| WK-SCP0106-0157 | C4 | clbSite / Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — clbSite / Site · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-014) |
| WK-SCP0106-0158 | C4 | rgrpDivisionType / Division Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — rgrpDivisionType / Division Type · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-015) |
| WK-SCP0106-0159 | C6 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0106_CAPA_Loss_Plan._defaultDataM) |
| WK-SCP0106-0160 | G3 | SCP0106 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0106 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 9 (D00-1-025 D00-1-043 COMMON:UC-02 COMMON:) |
| WK-SCP0106-0161 | K-SA | SCP0106 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCP0106 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 4 (D00-1-025 D00-1-043 COMMON:UC-02 `compon) |
| WK-SCP0106-0162 | K4 | SCP0106 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0106 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 15 (COMMON:UC-02 COMMON:UC-03 COMMON:UC-04 C) |
| WK-SCP0106-0163 | F1 | SCP0106 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0106 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 57 (D00-2-016 D00-3-010 D00-3-015 D00-4d-008) |
| WK-SCP0106-0164 | F3 | SCP0106 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F3 실행 — SCP0106 화면 · 검사기 있음(_trace.spec(@trace) W4b 붙여넣기 — Ctrl+C/Ctrl+V 로 셀 값 복사 후 값·연쇄) — 실행 필요: trace |  | 1 (gridSignals) |
| WK-SCP0106-0165 | F5 | SCP0106 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0106 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 20 (D00-2-016 D00-3-010 D00-3-015 D00-4d-008) |
| WK-SCP0106-0166 | F4 | PKG_SCP0104.P_SCP0104_GET_SPREAD_TITLE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0104.P_SCP0104_GET_SPREAD_TITLE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.GetSpdTitle:1) |
| WK-SCP0106-0167 | A5 | OPERATION_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — OPERATION_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (COMMON:UC-05) |
| WK-SCP0106-0168 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-008 ACT:SCP0106_CAPA_Loss_Plan.Ini) |
| WK-SCP0106-0169 | G4 | cboProgressStatus / Status / Progress St | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboProgressStatus / Status / Progress Status · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-009 ACT:SCP0106_CAPA_Loss_Plan.Ini) |
| WK-SCP0106-0170 | G4 | cboSheetType / Status / Sheet Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboSheetType / Status / Sheet Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 9 (D00-1-010 ACT:SCP0106_CAPA_Loss_Plan.Ini) |
| WK-SCP0106-0171 | G4 | cboVersion / Plan Month / Version / Ver. | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboVersion / Plan Month / Version / Ver. · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-011 ACT:SCP0106_CAPA_Loss_Plan.Ini) |
| WK-SCP0106-0172 | G4 | cboVersionSeq / Version / Version Seq /  | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboVersionSeq / Version / Version Seq / Ver. · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-012 ACT:SCP0106_CAPA_Loss_Plan.Ini) |
| WK-SCP0106-0173 | G4 | chkShowRate / Show Rate Columns / Show R | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkShowRate / Show Rate Columns / Show Rate · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-013 ACT:SCP0106_CAPA_Loss_Plan.Ini) |
| WK-SCP0106-0174 | G4 | clbElectrodeType / Line Type / Electrode | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbElectrodeType / Line Type / Electrode Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-014) |
| WK-SCP0106-0175 | G4 | clbFactory / Building / Factory | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbFactory / Building / Factory · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-015 ACT:SCP0106_CAPA_Loss_Plan.Ini) |
| WK-SCP0106-0176 | G4 | clbLine / Line | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbLine / Line · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-016 ACT:SCP0106_CAPA_Loss_Plan.Ini) |
| WK-SCP0106-0177 | G4 | clbOperation / Operation | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbOperation / Operation · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-017 ACT:SCP0106_CAPA_Loss_Plan.Ini) |
| WK-SCP0106-0178 | G4 | clbPlant / Plant | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbPlant / Plant · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-018 ACT:SCP0106_CAPA_Loss_Plan.Ini) |
| WK-SCP0106-0179 | G4 | clbSite / Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbSite / Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-019 ACT:SCP0106_CAPA_Loss_Plan.Ini) |
| WK-SCP0106-0180 | G4 | rgrpDivisionType / Division Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — rgrpDivisionType / Division Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-037 ACT:SCP0106_CAPA_Loss_Plan.Ini) |
| WK-SCP0106-0181 | G4 | txtItem / ItemNames.MODEL / Item | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtItem / ItemNames.MODEL / Item · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-040) |
| WK-SCP0106-0182 | G4 | txtPlanType / _plan_type / Plan Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtPlanType / _plan_type / Plan Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-041) |
| WK-SCP0106-0183 | H2 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (D00-3-018 3) |
| WK-SCP0106-0184 | H2 | MEASURE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — MEASURE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 9 (D00-3-018 3 ACT:SCP0106_CAPA_Loss_Plan.S) |
| WK-SCP0106-0185 | H2 | OPERATION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — OPERATION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (COMMON:UC-05) |
| WK-SCP0106-0186 | H5 | OPERATION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — OPERATION_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (COMMON:UC-05) |
| WK-SCP0106-0187 | H5 | cboProgressStatus / Status / Progress St | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — cboProgressStatus / Status / Progress Status · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effect |  | 1 (D00-2-005) |
| WK-SCP0106-0188 | H5 | cboVersion / Plan Month / Version / Ver. | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — cboVersion / Plan Month / Version / Ver. · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective) |  | 1 (D00-2-007) |
| WK-SCP0106-0189 | H5 | rgrpDivisionType / Division Type | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — rgrpDivisionType / Division Type · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필 |  | 1 (D00-2-015) |
| WK-SCP0106-0190 | I1 | SCP0106 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0106 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 10 (D00-1-045 COMMON:UC-02 COMMON:UC-04 12 A) |
| WK-SCP0106-0191 | SC1 | SCP0106 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SCP0106 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 23 (D00-1-008 D00-1-009 D00-1-010 D00-1-011 ) |
| WK-SCP0106-0192 | D1 | BASE_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — BASE_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 5 (D00-3-012 ACT:SCP0106_CAPA_Loss_Plan.Edi) |
| WK-SCP0106-0193 | D1 | PFRSLT_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PFRSLT_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:SCP0106_CAPA_Loss_Plan.EditButton AC) |
| WK-SCP0106-0194 | D3 | BASE_QTY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — BASE_QTY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 5 (D00-3-012 ACT:SCP0106_CAPA_Loss_Plan.Edi) |
| WK-SCP0106-0195 | D3 | PFRSLT_QTY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PFRSLT_QTY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:SCP0106_CAPA_Loss_Plan.EditButton AC) |
| WK-SCP0106-0196 | D5 | OPERATION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — OPERATION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (COMMON:UC-05) |
| WK-SCP0106-0197 | D6 | SCP0106 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0106 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 3 (D00-1-040 D00-3-015 COMMON:UC-03) |
| WK-SCP0106-0198 | E4 | BASE_QTY | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — BASE_QTY · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 10 (ACT:SCP0106_CAPA_Loss_Plan.SetLockColumn) |
| WK-SCP0106-0199 | E4 | COMPANY_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — COMPANY_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 10 (ACT:SCP0106_CAPA_Loss_Plan.SetQueryInfoS) |
| WK-SCP0106-0200 | E4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 10 (ACT:SCP0106_CAPA_Loss_Plan.SetQueryInfoS) |
| WK-SCP0106-0201 | E4 | ELTR_LN_TP_CD | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ELTR_LN_TP_CD · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 8 (ACT:SCP0106_CAPA_Loss_Plan.SetQueryInfoS) |
| WK-SCP0106-0202 | E4 | FACTORY_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — FACTORY_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 8 (ACT:SCP0106_CAPA_Loss_Plan.SetQueryInfoS) |
| WK-SCP0106-0203 | E4 | LINE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — LINE_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 8 (ACT:SCP0106_CAPA_Loss_Plan.SetQueryInfoS) |
| WK-SCP0106-0204 | E4 | MEASURE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MEASURE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 10 (ACT:SCP0106_CAPA_Loss_Plan.SetLockColumn) |
| WK-SCP0106-0205 | E4 | MEASURE_GROUP | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MEASURE_GROUP · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SCP0106_CAPA_Loss_Plan.SetQueryInfoS) |
| WK-SCP0106-0206 | E4 | MEASURE_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MEASURE_NAME · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 11 (ACT:SCP0106_CAPA_Loss_Plan.SetLockColumn) |
| WK-SCP0106-0207 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (COMMON:UC-04 12 ACT:SCP0106_CAPA_Loss_Pl) |
| WK-SCP0106-0208 | E4 | MSG00006 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00006 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.AfterSaveData) |
| WK-SCP0106-0209 | E4 | MSG00097 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00097 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (D00-1-045 12) |
| WK-SCP0106-0210 | E4 | MSG00109 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00109 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (12 ACT:SCP0106_CAPA_Loss_Plan.EditButton) |
| WK-SCP0106-0211 | E4 | MSG00133 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00133 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (COMMON:UC-04 ACT:SCP0106_CAPA_Loss_Plan.) |
| WK-SCP0106-0212 | E4 | MSG00419 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00419 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (12 ACT:SCP0106_CAPA_Loss_Plan.EditButton) |
| WK-SCP0106-0213 | E4 | MSG00667 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00667 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (D00-1-045 12) |
| WK-SCP0106-0214 | E4 | MSG00672 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00672 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (COMMON:UC-04 12) |
| WK-SCP0106-0215 | E4 | MSG00703 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00703 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-02) |
| WK-SCP0106-0216 | E4 | MSG01406 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01406 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (12) |
| WK-SCP0106-0217 | E4 | MSG01454 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01454 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (12) |
| WK-SCP0106-0218 | E4 | NICK_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — NICK_NAME · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 11 (ACT:SCP0106_CAPA_Loss_Plan.SetQueryInfoS) |
| WK-SCP0106-0219 | E4 | OPERATION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — OPERATION_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 12 (ACT:SCP0106_CAPA_Loss_Plan.SetLockColumn) |
| WK-SCP0106-0220 | E4 | PFRSLT_QTY | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — PFRSLT_QTY · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 10 (ACT:SCP0106_CAPA_Loss_Plan.SetLockColumn) |
| WK-SCP0106-0221 | E4 | PLANT_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — PLANT_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 8 (ACT:SCP0106_CAPA_Loss_Plan.SetQueryInfoS) |
| WK-SCP0106-0222 | E4 | SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — SITE_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 10 (ACT:SCP0106_CAPA_Loss_Plan.SetQueryInfoS) |
| WK-SCP0106-0223 | E4 | chkShowRate / Show Rate Columns / Show R | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — chkShowRate / Show Rate Columns / Show Rate · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.SetVisibleShe) |
| WK-SCP0106-0224 | A10 | SCP0106 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0106 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 183 (ACT:AssemblyCapaMeasureSet.Init ACT:Asse) |
| WK-SCP0106-0225 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-008) |
| WK-SCP0106-0226 | G1 | cboProgressStatus / Status / Progress St | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboProgressStatus / Status / Progress Status · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-009) |
| WK-SCP0106-0227 | G1 | cboSheetType / Status / Sheet Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboSheetType / Status / Sheet Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-010) |
| WK-SCP0106-0228 | G1 | cboVersion / Plan Month / Version / Ver. | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboVersion / Plan Month / Version / Ver. · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-011) |
| WK-SCP0106-0229 | G1 | cboVersionSeq / Version / Version Seq /  | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboVersionSeq / Version / Version Seq / Ver. · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-012) |
| WK-SCP0106-0230 | G1 | chkShowRate / Show Rate Columns / Show R | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — chkShowRate / Show Rate Columns / Show Rate · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-013) |
| WK-SCP0106-0231 | G1 | clbElectrodeType / Line Type / Electrode | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbElectrodeType / Line Type / Electrode Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-014) |
| WK-SCP0106-0232 | G1 | clbFactory / Building / Factory | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbFactory / Building / Factory · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-015) |
| WK-SCP0106-0233 | G1 | clbLine / Line | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbLine / Line · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-016) |
| WK-SCP0106-0234 | G1 | clbOperation / Operation | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbOperation / Operation · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-017) |
| WK-SCP0106-0235 | G1 | clbPlant / Plant | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbPlant / Plant · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-018) |
| WK-SCP0106-0236 | G1 | clbSite / Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbSite / Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-019) |
| WK-SCP0106-0237 | G1 | rgrpDivisionType / Division Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — rgrpDivisionType / Division Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (D00-1-037 D00-2-015) |
| WK-SCP0106-0238 | G1 | txtItem / ItemNames.MODEL / Item | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItem / ItemNames.MODEL / Item · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-040) |
| WK-SCP0106-0239 | G1 | txtPlanType / _plan_type / Plan Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtPlanType / _plan_type / Plan Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-041) |
| WK-SCP0106-0240 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-008 ACT:SCP0106_CAPA_Loss_Plan.Ini) |
| WK-SCP0106-0241 | G6 | cboProgressStatus / Status / Progress St | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboProgressStatus / Status / Progress Status · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-009 ACT:SCP0106_CAPA_Loss_Plan.Ini) |
| WK-SCP0106-0242 | G6 | cboSheetType / Status / Sheet Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboSheetType / Status / Sheet Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 9 (D00-1-010 ACT:SCP0106_CAPA_Loss_Plan.Ini) |
| WK-SCP0106-0243 | G6 | cboVersion / Plan Month / Version / Ver. | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboVersion / Plan Month / Version / Ver. · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-011 ACT:SCP0106_CAPA_Loss_Plan.Ini) |
| WK-SCP0106-0244 | G6 | cboVersionSeq / Version / Version Seq /  | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboVersionSeq / Version / Version Seq / Ver. · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-012 ACT:SCP0106_CAPA_Loss_Plan.Ini) |
| WK-SCP0106-0245 | G6 | chkShowRate / Show Rate Columns / Show R | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — chkShowRate / Show Rate Columns / Show Rate · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-013 ACT:SCP0106_CAPA_Loss_Plan.Ini) |
| WK-SCP0106-0246 | G6 | clbElectrodeType / Line Type / Electrode | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbElectrodeType / Line Type / Electrode Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-014) |
| WK-SCP0106-0247 | G6 | clbFactory / Building / Factory | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbFactory / Building / Factory · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-015 ACT:SCP0106_CAPA_Loss_Plan.Ini) |
| WK-SCP0106-0248 | G6 | clbLine / Line | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbLine / Line · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-016 ACT:SCP0106_CAPA_Loss_Plan.Ini) |
| WK-SCP0106-0249 | G6 | clbOperation / Operation | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbOperation / Operation · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-017 ACT:SCP0106_CAPA_Loss_Plan.Ini) |
| WK-SCP0106-0250 | G6 | clbPlant / Plant | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbPlant / Plant · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-018 ACT:SCP0106_CAPA_Loss_Plan.Ini) |
| WK-SCP0106-0251 | G6 | clbSite / Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbSite / Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-019 ACT:SCP0106_CAPA_Loss_Plan.Ini) |
| WK-SCP0106-0252 | G6 | rgrpDivisionType / Division Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — rgrpDivisionType / Division Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-037 ACT:SCP0106_CAPA_Loss_Plan.Ini) |
| WK-SCP0106-0253 | G6 | txtItem / ItemNames.MODEL / Item | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtItem / ItemNames.MODEL / Item · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-040) |
| WK-SCP0106-0254 | G6 | txtPlanType / _plan_type / Plan Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtPlanType / _plan_type / Plan Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-041) |
| WK-SCP0106-0255 | X-REOPEN | SCP0106 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0106 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 5 (ACT:SCP0106_CAPA_Loss_Plan.Dispose ACT:S) |
| WK-SCP0106-0256 | H6 | txtItem / ItemNames.MODEL / Item | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtItem / ItemNames.MODEL / Item · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (D00-1-040) |
| WK-SCP0106-0257 | M3 | AssemblyCapaMeasureSet | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — AssemblyCapaMeasureSet · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 15 (ACT:AssemblyCapaMeasureSet..ctor ACT:Ass) |
| WK-SCP0106-0258 | M3 | AssemblyCapaMeasureSetLine | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — AssemblyCapaMeasureSetLine · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 2 (ACT:AssemblyCapaMeasureSetLine..ctor ACT) |
| WK-SCP0106-0259 | M3 | AssemblyCurrentCapaMeasureSet | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — AssemblyCurrentCapaMeasureSet · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 25 (ACT:AssemblyCurrentCapaMeasureSet..ctor ) |
| WK-SCP0106-0260 | M3 | EltrCapaMeasureSet | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — EltrCapaMeasureSet · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 24 (ACT:EltrCapaMeasureSet..ctor ACT:EltrCap) |
| WK-SCP0106-0261 | M3 | EltrCapaMeasureSetLine | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — EltrCapaMeasureSetLine · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 5 (ACT:EltrCapaMeasureSetLine..ctor ACT:Elt) |
| WK-SCP0106-0262 | M3 | EltrCurrentCapaMeasureSet | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — EltrCurrentCapaMeasureSet · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 29 (ACT:EltrCurrentCapaMeasureSet..ctor ACT:) |
| WK-SCP0106-0263 | M4 | btnColumn | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnColumn · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (`components/CapaLossPlanColumnModal.tsx`) |
| WK-SCP0106-0264 | M4 | btnItemId | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnItemId · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (D00-1-007 D00-2-003 `components/CapaLoss) |
| WK-SCP0106-0265 | M4 | txtItem / ItemNames.MODEL / Item | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtItem / ItemNames.MODEL / Item · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (D00-1-040) |

## W7 기대값 확정 (636)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0106-0266 | C2 | D00-2-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-2-001: 행 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-001) |
| WK-SCP0106-0267 | C2 | D00-4d-015 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-4d-015: 행 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-015) |
| WK-SCP0106-0268 | C2 | D00-4d-016 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-4d-016: 행 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-016) |
| WK-SCP0106-0269 | C2 | D00-4d-017 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-4d-017: 행 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-017) |
| WK-SCP0106-0270 | C2 | D00-4d-018 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-4d-018: 행 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-018) |
| WK-SCP0106-0271 | C2 | D00-4d-019 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-4d-019: 행 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-019) |
| WK-SCP0106-0272 | C2 | D00-4d-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-4d-020: 행 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-020) |
| WK-SCP0106-0273 | C2 | D00-4d-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-4d-021: 행 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-021) |
| WK-SCP0106-0274 | C2 | D00-4d-022 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-4d-022: 행 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-022) |
| WK-SCP0106-0275 | C2 | D00-4d-023 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-4d-023: 행 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-023) |
| WK-SCP0106-0276 | C2 | D00-4d-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-4d-024: 행 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-024) |
| WK-SCP0106-0277 | C2 | SCP0106_CAPA_Loss_Plan._defaultDataModel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0106_CAPA_Loss_Plan._defaultDataModel_Changed: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 23 (ACT:SCP0106_CAPA_Loss_Plan._defaultDataM) |
| WK-SCP0106-0278 | C2 | SCP0106_CAPA_Loss_Plan.cboDivision_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0106_CAPA_Loss_Plan.cboDivision_SelectedIndexCh: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0106_CAPA_Loss_Plan.cboDivision_S) |
| WK-SCP0106-0279 | C2 | SCP0106_CAPA_Loss_Plan.cboFromYYYY_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0106_CAPA_Loss_Plan.cboFromYYYY_SelectedIndexCh: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0106_CAPA_Loss_Plan.cboFromYYYY_S) |
| WK-SCP0106-0280 | C2 | SCP0106_CAPA_Loss_Plan.cboProgressStatus | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0106_CAPA_Loss_Plan.cboProgressStatus_SelectedI: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.cboProgressSt) |
| WK-SCP0106-0281 | C2 | SCP0106_CAPA_Loss_Plan.cboSheetType_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0106_CAPA_Loss_Plan.cboSheetType_SelectedIndexC: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0106_CAPA_Loss_Plan.cboSheetType_) |
| WK-SCP0106-0282 | C2 | SCP0106_CAPA_Loss_Plan.cboVersionSeq_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0106_CAPA_Loss_Plan.cboVersionSeq_SelectedIndex: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0106_CAPA_Loss_Plan.cboVersionSeq) |
| WK-SCP0106-0283 | C2 | SCP0106_CAPA_Loss_Plan.cboVersion_Select | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0106_CAPA_Loss_Plan.cboVersion_SelectedIndexCha: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0106_CAPA_Loss_Plan.cboVersion_Se) |
| WK-SCP0106-0284 | C2 | SCP0106_CAPA_Loss_Plan.chkShowRate_Check | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0106_CAPA_Loss_Plan.chkShowRate_CheckedChanged: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.chkShowRate_C) |
| WK-SCP0106-0285 | C2 | SCP0106_CAPA_Loss_Plan.clbFactory_Select | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0106_CAPA_Loss_Plan.clbFactory_SelectedIndexCha: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.clbFactory_Se) |
| WK-SCP0106-0286 | C2 | SCP0106_CAPA_Loss_Plan.clbLine_SelectedI | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0106_CAPA_Loss_Plan.clbLine_SelectedIndexChange: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.clbLine_Selec) |
| WK-SCP0106-0287 | C2 | SCP0106_CAPA_Loss_Plan.clbOperation_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0106_CAPA_Loss_Plan.clbOperation_SelectedIndexC: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.clbOperation_) |
| WK-SCP0106-0288 | C2 | SCP0106_CAPA_Loss_Plan.clbPlant_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0106_CAPA_Loss_Plan.clbPlant_SelectedIndexChang: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0106_CAPA_Loss_Plan.clbPlant_Sele) |
| WK-SCP0106-0289 | C2 | SCP0106_CAPA_Loss_Plan.clbSite_SelectedI | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0106_CAPA_Loss_Plan.clbSite_SelectedIndexChange: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0106_CAPA_Loss_Plan.clbSite_Selec) |
| WK-SCP0106-0290 | C2 | SCP0106_CAPA_Loss_Plan.rgrpDivisionType_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0106_CAPA_Loss_Plan.rgrpDivisionType_SelectedIn: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0106_CAPA_Loss_Plan.rgrpDivisionT) |
| WK-SCP0106-0291 | C2 | SCP0106_CAPA_Loss_Plan.spdMain_Clipboard | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0106_CAPA_Loss_Plan.spdMain_ClipboardChanged: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.spdMain_Clipb) |
| WK-SCP0106-0292 | C2 | SCP0106_CAPA_Loss_Plan.spdMain_Selection | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0106_CAPA_Loss_Plan.spdMain_SelectionChanged: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0106_CAPA_Loss_Plan.spdMain_Selec) |
| WK-SCP0106-0293 | C2 | `hooks/useCapaLossPlanCellEdit.ts` | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — `hooks/useCapaLossPlanCellEdit.ts`: 행 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (`hooks/useCapaLossPlanCellEdit.ts`) |
| WK-SCP0106-0294 | C3 | D00-2-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-2-001: 행 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-001) |
| WK-SCP0106-0295 | C3 | D00-4d-015 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-4d-015: 행 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-015) |
| WK-SCP0106-0296 | C3 | D00-4d-016 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-4d-016: 행 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-016) |
| WK-SCP0106-0297 | C3 | D00-4d-017 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-4d-017: 행 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-017) |
| WK-SCP0106-0298 | C3 | D00-4d-018 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-4d-018: 행 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-018) |
| WK-SCP0106-0299 | C3 | D00-4d-019 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-4d-019: 행 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-019) |
| WK-SCP0106-0300 | C3 | D00-4d-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-4d-020: 행 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-020) |
| WK-SCP0106-0301 | C3 | D00-4d-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-4d-021: 행 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-021) |
| WK-SCP0106-0302 | C3 | D00-4d-022 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-4d-022: 행 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-022) |
| WK-SCP0106-0303 | C3 | D00-4d-023 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-4d-023: 행 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-023) |
| WK-SCP0106-0304 | C3 | D00-4d-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-4d-024: 행 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-024) |
| WK-SCP0106-0305 | C3 | SCP0106_CAPA_Loss_Plan.SetEditableMeasur | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetEditableMeasures: 진입점 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 11 (ACT:SCP0106_CAPA_Loss_Plan.SetEditableMe) |
| WK-SCP0106-0306 | C3 | SCP0106_CAPA_Loss_Plan.SetLockColumns | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetLockColumns: 진입점 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.SetLockColumn) |
| WK-SCP0106-0307 | C3 | SCP0106_CAPA_Loss_Plan.SetLockColumnsAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetLockColumnsAll: 진입점 집계 — C3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 64 (ACT:SCP0106_CAPA_Loss_Plan.SetLockColumn) |
| WK-SCP0106-0308 | C3 | SCP0106_CAPA_Loss_Plan.SetLockColumnsOne | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetLockColumnsOneRow: 진입점 집계 — C3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 59 (ACT:SCP0106_CAPA_Loss_Plan.SetLockColumn) |
| WK-SCP0106-0309 | C3 | SCP0106_CAPA_Loss_Plan.SetMeasureColorOn | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetMeasureColorOneRow: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 15 (ACT:SCP0106_CAPA_Loss_Plan.SetMeasureCol) |
| WK-SCP0106-0310 | C3 | SCP0106_CAPA_Loss_Plan.SetQueryInfoGet | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetQueryInfoGet: 진입점 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 19 (ACT:SCP0106_CAPA_Loss_Plan.SetQueryInfoG) |
| WK-SCP0106-0311 | C3 | SCP0106_CAPA_Loss_Plan.SetQueryInfoSaveL | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetQueryInfoSaveLine: 진입점 집계 — C3 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 27 (ACT:SCP0106_CAPA_Loss_Plan.SetQueryInfoS) |
| WK-SCP0106-0312 | C3 | SCP0106_CAPA_Loss_Plan.SetQueryInfoSaveM | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetQueryInfoSaveModel: 진입점 집계 — C3 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 28 (ACT:SCP0106_CAPA_Loss_Plan.SetQueryInfoS) |
| WK-SCP0106-0313 | C3 | SCP0106_CAPA_Loss_Plan.SetSheetMerge | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetSheetMerge: 진입점 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.SetSheetMerge) |
| WK-SCP0106-0314 | C3 | SCP0106_CAPA_Loss_Plan.SetSheetNumericCo | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetSheetNumericColumnFormat: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0106_CAPA_Loss_Plan.SetSheetNumer) |
| WK-SCP0106-0315 | C3 | SCP0106_CAPA_Loss_Plan.SetSheetNumericCo | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetSheetNumericColumnFormat: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.SetSheetNumer) |
| WK-SCP0106-0316 | C3 | SCP0106_CAPA_Loss_Plan.SetSheetRangeValu | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetSheetRangeValue: 진입점 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.SetSheetRange) |
| WK-SCP0106-0317 | C3 | SCP0106_CAPA_Loss_Plan.SetVisibleElectro | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetVisibleElectrodeType: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.SetVisibleEle) |
| WK-SCP0106-0318 | C3 | SCP0106_CAPA_Loss_Plan.SetVisibleOperati | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetVisibleOperation: 진입점 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.SetVisibleOpe) |
| WK-SCP0106-0319 | C3 | SCP0106_CAPA_Loss_Plan.Set_MeasureColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0106_CAPA_Loss_Plan.Set_MeasureColor: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 15 (ACT:SCP0106_CAPA_Loss_Plan.Set_MeasureCo) |
| WK-SCP0106-0320 | C3 | SCP0106_CAPA_Loss_Plan._defaultDataModel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0106_CAPA_Loss_Plan._defaultDataModel_Changed: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 23 (ACT:SCP0106_CAPA_Loss_Plan._defaultDataM) |
| WK-SCP0106-0321 | C3 | SCP0106_CAPA_Loss_Plan.cboDivision_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0106_CAPA_Loss_Plan.cboDivision_SelectedIndexCh: 진입점 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0106_CAPA_Loss_Plan.cboDivision_S) |
| WK-SCP0106-0322 | C3 | SCP0106_CAPA_Loss_Plan.cboFromYYYY_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0106_CAPA_Loss_Plan.cboFromYYYY_SelectedIndexCh: 진입점 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0106_CAPA_Loss_Plan.cboFromYYYY_S) |
| WK-SCP0106-0323 | C3 | SCP0106_CAPA_Loss_Plan.cboProgressStatus | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0106_CAPA_Loss_Plan.cboProgressStatus_SelectedI: 진입점 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.cboProgressSt) |
| WK-SCP0106-0324 | C3 | SCP0106_CAPA_Loss_Plan.cboSheetType_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0106_CAPA_Loss_Plan.cboSheetType_SelectedIndexC: 진입점 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0106_CAPA_Loss_Plan.cboSheetType_) |
| WK-SCP0106-0325 | C3 | SCP0106_CAPA_Loss_Plan.cboVersionSeq_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0106_CAPA_Loss_Plan.cboVersionSeq_SelectedIndex: 진입점 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0106_CAPA_Loss_Plan.cboVersionSeq) |
| WK-SCP0106-0326 | C3 | SCP0106_CAPA_Loss_Plan.cboVersion_Select | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0106_CAPA_Loss_Plan.cboVersion_SelectedIndexCha: 진입점 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0106_CAPA_Loss_Plan.cboVersion_Se) |
| WK-SCP0106-0327 | C3 | SCP0106_CAPA_Loss_Plan.chkShowRate_Check | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0106_CAPA_Loss_Plan.chkShowRate_CheckedChanged: 진입점 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.chkShowRate_C) |
| WK-SCP0106-0328 | C3 | SCP0106_CAPA_Loss_Plan.clbFactory_Select | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0106_CAPA_Loss_Plan.clbFactory_SelectedIndexCha: 진입점 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.clbFactory_Se) |
| WK-SCP0106-0329 | C3 | SCP0106_CAPA_Loss_Plan.clbLine_SelectedI | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0106_CAPA_Loss_Plan.clbLine_SelectedIndexChange: 진입점 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.clbLine_Selec) |
| WK-SCP0106-0330 | C3 | SCP0106_CAPA_Loss_Plan.clbOperation_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0106_CAPA_Loss_Plan.clbOperation_SelectedIndexC: 진입점 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.clbOperation_) |
| WK-SCP0106-0331 | C3 | SCP0106_CAPA_Loss_Plan.clbPlant_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0106_CAPA_Loss_Plan.clbPlant_SelectedIndexChang: 진입점 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0106_CAPA_Loss_Plan.clbPlant_Sele) |
| WK-SCP0106-0332 | C3 | SCP0106_CAPA_Loss_Plan.clbSite_SelectedI | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0106_CAPA_Loss_Plan.clbSite_SelectedIndexChange: 진입점 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0106_CAPA_Loss_Plan.clbSite_Selec) |
| WK-SCP0106-0333 | C3 | SCP0106_CAPA_Loss_Plan.rgrpDivisionType_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0106_CAPA_Loss_Plan.rgrpDivisionType_SelectedIn: 진입점 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0106_CAPA_Loss_Plan.rgrpDivisionT) |
| WK-SCP0106-0334 | C3 | SCP0106_CAPA_Loss_Plan.spdMain_Clipboard | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0106_CAPA_Loss_Plan.spdMain_ClipboardChanged: 진입점 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.spdMain_Clipb) |
| WK-SCP0106-0335 | C3 | SCP0106_CAPA_Loss_Plan.spdMain_Selection | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0106_CAPA_Loss_Plan.spdMain_SelectionChanged: 진입점 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0106_CAPA_Loss_Plan.spdMain_Selec) |
| WK-SCP0106-0336 | C3 | `hooks/useCapaLossPlanCellEdit.ts` | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — `hooks/useCapaLossPlanCellEdit.ts`: 행 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (`hooks/useCapaLossPlanCellEdit.ts`) |
| WK-SCP0106-0337 | C3 | gridSignals | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — gridSignals: 행 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (gridSignals) |
| WK-SCP0106-0338 | C6 | D00-2-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — D00-2-001: 행 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-001) |
| WK-SCP0106-0339 | C6 | D00-4d-015 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — D00-4d-015: 행 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-015) |
| WK-SCP0106-0340 | C6 | D00-4d-016 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — D00-4d-016: 행 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-016) |
| WK-SCP0106-0341 | C6 | D00-4d-017 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — D00-4d-017: 행 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-017) |
| WK-SCP0106-0342 | C6 | D00-4d-018 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — D00-4d-018: 행 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-018) |
| WK-SCP0106-0343 | C6 | D00-4d-019 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — D00-4d-019: 행 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-019) |
| WK-SCP0106-0344 | C6 | D00-4d-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — D00-4d-020: 행 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-020) |
| WK-SCP0106-0345 | C6 | D00-4d-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — D00-4d-021: 행 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-021) |
| WK-SCP0106-0346 | C6 | D00-4d-022 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — D00-4d-022: 행 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-022) |
| WK-SCP0106-0347 | C6 | D00-4d-023 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — D00-4d-023: 행 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-023) |
| WK-SCP0106-0348 | C6 | D00-4d-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — D00-4d-024: 행 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-024) |
| WK-SCP0106-0349 | C6 | SCP0106_CAPA_Loss_Plan._defaultDataModel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0106_CAPA_Loss_Plan._defaultDataModel_Changed: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 23 (ACT:SCP0106_CAPA_Loss_Plan._defaultDataM) |
| WK-SCP0106-0350 | C6 | SCP0106_CAPA_Loss_Plan.cboDivision_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0106_CAPA_Loss_Plan.cboDivision_SelectedIndexCh: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0106_CAPA_Loss_Plan.cboDivision_S) |
| WK-SCP0106-0351 | C6 | SCP0106_CAPA_Loss_Plan.cboFromYYYY_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0106_CAPA_Loss_Plan.cboFromYYYY_SelectedIndexCh: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0106_CAPA_Loss_Plan.cboFromYYYY_S) |
| WK-SCP0106-0352 | C6 | SCP0106_CAPA_Loss_Plan.cboProgressStatus | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0106_CAPA_Loss_Plan.cboProgressStatus_SelectedI: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.cboProgressSt) |
| WK-SCP0106-0353 | C6 | SCP0106_CAPA_Loss_Plan.cboSheetType_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0106_CAPA_Loss_Plan.cboSheetType_SelectedIndexC: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0106_CAPA_Loss_Plan.cboSheetType_) |
| WK-SCP0106-0354 | C6 | SCP0106_CAPA_Loss_Plan.cboVersionSeq_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0106_CAPA_Loss_Plan.cboVersionSeq_SelectedIndex: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0106_CAPA_Loss_Plan.cboVersionSeq) |
| WK-SCP0106-0355 | C6 | SCP0106_CAPA_Loss_Plan.cboVersion_Select | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0106_CAPA_Loss_Plan.cboVersion_SelectedIndexCha: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0106_CAPA_Loss_Plan.cboVersion_Se) |
| WK-SCP0106-0356 | C6 | SCP0106_CAPA_Loss_Plan.chkShowRate_Check | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0106_CAPA_Loss_Plan.chkShowRate_CheckedChanged: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.chkShowRate_C) |
| WK-SCP0106-0357 | C6 | SCP0106_CAPA_Loss_Plan.clbFactory_Select | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0106_CAPA_Loss_Plan.clbFactory_SelectedIndexCha: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.clbFactory_Se) |
| WK-SCP0106-0358 | C6 | SCP0106_CAPA_Loss_Plan.clbLine_SelectedI | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0106_CAPA_Loss_Plan.clbLine_SelectedIndexChange: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.clbLine_Selec) |
| WK-SCP0106-0359 | C6 | SCP0106_CAPA_Loss_Plan.clbOperation_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0106_CAPA_Loss_Plan.clbOperation_SelectedIndexC: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.clbOperation_) |
| WK-SCP0106-0360 | C6 | SCP0106_CAPA_Loss_Plan.clbPlant_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0106_CAPA_Loss_Plan.clbPlant_SelectedIndexChang: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0106_CAPA_Loss_Plan.clbPlant_Sele) |
| WK-SCP0106-0361 | C6 | SCP0106_CAPA_Loss_Plan.clbSite_SelectedI | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0106_CAPA_Loss_Plan.clbSite_SelectedIndexChange: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0106_CAPA_Loss_Plan.clbSite_Selec) |
| WK-SCP0106-0362 | C6 | SCP0106_CAPA_Loss_Plan.rgrpDivisionType_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0106_CAPA_Loss_Plan.rgrpDivisionType_SelectedIn: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0106_CAPA_Loss_Plan.rgrpDivisionT) |
| WK-SCP0106-0363 | C6 | SCP0106_CAPA_Loss_Plan.spdMain_Clipboard | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0106_CAPA_Loss_Plan.spdMain_ClipboardChanged: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.spdMain_Clipb) |
| WK-SCP0106-0364 | C6 | SCP0106_CAPA_Loss_Plan.spdMain_Selection | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0106_CAPA_Loss_Plan.spdMain_SelectionChanged: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0106_CAPA_Loss_Plan.spdMain_Selec) |
| WK-SCP0106-0365 | C6 | `hooks/useCapaLossPlanCellEdit.ts` | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — `hooks/useCapaLossPlanCellEdit.ts`: 행 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (`hooks/useCapaLossPlanCellEdit.ts`) |
| WK-SCP0106-0366 | B3 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — D00-4b-001: 행 집계 — B3 27요소: TODO:27 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-001) |
| WK-SCP0106-0367 | B3 | D00-4b-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — D00-4b-004: 행 집계 — B3 27요소: TODO:27 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-004) |
| WK-SCP0106-0368 | B3 | D00-4c-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — D00-4c-003: 행 집계 — B3 27요소: TODO:27 (미실행 요소가 남아 판정필요) |  | 1 (D00-4c-003) |
| WK-SCP0106-0369 | B3 | SCP0106_CAPA_Loss_Plan.GetCalcAssemblyRt | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0106_CAPA_Loss_Plan.GetCalcAssemblyRt: 진입점 집계 — B3 27요소: TODO:27 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0106_CAPA_Loss_Plan.GetCalcAssemb) |
| WK-SCP0106-0370 | B3 | SCP0106_CAPA_Loss_Plan.GetCalcEltrRt | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0106_CAPA_Loss_Plan.GetCalcEltrRt: 진입점 집계 — B3 27요소: TODO:27 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0106_CAPA_Loss_Plan.GetCalcEltrRt) |
| WK-SCP0106-0371 | B3 | SCP0106_CAPA_Loss_Plan.GetCalcRt | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0106_CAPA_Loss_Plan.GetCalcRt: 진입점 집계 — B3 27요소: TODO:27 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCP0106_CAPA_Loss_Plan.GetCalcRt:371) |
| WK-SCP0106-0372 | B3 | SCP0106_CAPA_Loss_Plan.GetCurrSheetValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0106_CAPA_Loss_Plan.GetCurrSheetValue: 진입점 집계 — B3 27요소: TODO:27 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0106_CAPA_Loss_Plan.GetCurrSheetV) |
| WK-SCP0106-0373 | B3 | SCP0106_CAPA_Loss_Plan.GetCurrVersionPro | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0106_CAPA_Loss_Plan.GetCurrVersionProgessStatus: 진입점 집계 — B3 2요소: TODO:2 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0106_CAPA_Loss_Plan.GetCurrVersio) |
| WK-SCP0106-0374 | B3 | SCP0106_CAPA_Loss_Plan.GetMeasureIdx | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0106_CAPA_Loss_Plan.GetMeasureIdx: 진입점 집계 — B3 27요소: TODO:27 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0106_CAPA_Loss_Plan.GetMeasureIdx) |
| WK-SCP0106-0375 | B3 | SCP0106_CAPA_Loss_Plan.GetRowIdxOfMeasur | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0106_CAPA_Loss_Plan.GetRowIdxOfMeasure: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SCP0106_CAPA_Loss_Plan.GetRowIdxOfMe) |
| WK-SCP0106-0376 | B3 | SCP0106_CAPA_Loss_Plan.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0106_CAPA_Loss_Plan.GetSpdTitle: 진입점 집계 — B3 2요소: TODO:2 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SCP0106_CAPA_Loss_Plan.GetSpdTitle:1) |
| WK-SCP0106-0377 | B3 | SCP0106_CAPA_Loss_Plan.getCurrCompany | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0106_CAPA_Loss_Plan.getCurrCompany: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getCurrCompan) |
| WK-SCP0106-0378 | B3 | SCP0106_CAPA_Loss_Plan.getCurrDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0106_CAPA_Loss_Plan.getCurrDivision: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getCurrDivisi) |
| WK-SCP0106-0379 | B3 | SCP0106_CAPA_Loss_Plan.getCurrElectrodeT | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0106_CAPA_Loss_Plan.getCurrElectrodeType: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getCurrElectr) |
| WK-SCP0106-0380 | B3 | SCP0106_CAPA_Loss_Plan.getCurrFactory | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0106_CAPA_Loss_Plan.getCurrFactory: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getCurrFactor) |
| WK-SCP0106-0381 | B3 | SCP0106_CAPA_Loss_Plan.getCurrLine | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0106_CAPA_Loss_Plan.getCurrLine: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getCurrLine:9) |
| WK-SCP0106-0382 | B3 | SCP0106_CAPA_Loss_Plan.getCurrMeasure | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0106_CAPA_Loss_Plan.getCurrMeasure: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getCurrMeasur) |
| WK-SCP0106-0383 | B3 | SCP0106_CAPA_Loss_Plan.getCurrNickname | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0106_CAPA_Loss_Plan.getCurrNickname: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getCurrNickna) |
| WK-SCP0106-0384 | B3 | SCP0106_CAPA_Loss_Plan.getCurrOperation | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0106_CAPA_Loss_Plan.getCurrOperation: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getCurrOperat) |
| WK-SCP0106-0385 | B3 | SCP0106_CAPA_Loss_Plan.getCurrPlant | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0106_CAPA_Loss_Plan.getCurrPlant: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getCurrPlant:) |
| WK-SCP0106-0386 | B3 | SCP0106_CAPA_Loss_Plan.getCurrSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0106_CAPA_Loss_Plan.getCurrSite: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getCurrSite:9) |
| WK-SCP0106-0387 | B3 | SCP0106_CAPA_Loss_Plan.getDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0106_CAPA_Loss_Plan.getDivision: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getDivision:2) |
| WK-SCP0106-0388 | B3 | SCP0106_CAPA_Loss_Plan.getDivisionType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0106_CAPA_Loss_Plan.getDivisionType: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getDivisionTy) |
| WK-SCP0106-0389 | B3 | SCP0106_CAPA_Loss_Plan.getElectrodeType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0106_CAPA_Loss_Plan.getElectrodeType: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getElectrodeT) |
| WK-SCP0106-0390 | B3 | SCP0106_CAPA_Loss_Plan.getFactory | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0106_CAPA_Loss_Plan.getFactory: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getFactory:68) |
| WK-SCP0106-0391 | B3 | SCP0106_CAPA_Loss_Plan.getItemId | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0106_CAPA_Loss_Plan.getItemId: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getItemId:753) |
| WK-SCP0106-0392 | B3 | SCP0106_CAPA_Loss_Plan.getLine | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0106_CAPA_Loss_Plan.getLine: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getLine:705:1) |
| WK-SCP0106-0393 | B3 | SCP0106_CAPA_Loss_Plan.getOperation | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0106_CAPA_Loss_Plan.getOperation: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getOperation:) |
| WK-SCP0106-0394 | B3 | SCP0106_CAPA_Loss_Plan.getPlanType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0106_CAPA_Loss_Plan.getPlanType: 진입점 집계 — B3 27요소: TODO:27 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.getPlanType:3) |
| WK-SCP0106-0395 | B3 | SCP0106_CAPA_Loss_Plan.getPlant | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0106_CAPA_Loss_Plan.getPlant: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getPlant:657:) |
| WK-SCP0106-0396 | B3 | SCP0106_CAPA_Loss_Plan.getProgressStatus | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0106_CAPA_Loss_Plan.getProgressStatus: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getProgressSt) |
| WK-SCP0106-0397 | B3 | SCP0106_CAPA_Loss_Plan.getSheetType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0106_CAPA_Loss_Plan.getSheetType: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getSheetType:) |
| WK-SCP0106-0398 | B3 | SCP0106_CAPA_Loss_Plan.getShopGroup | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0106_CAPA_Loss_Plan.getShopGroup: 진입점 집계 — B3 27요소: TODO:27 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.getShopGroup:) |
| WK-SCP0106-0399 | B3 | SCP0106_CAPA_Loss_Plan.getSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0106_CAPA_Loss_Plan.getSite: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getSite:619:1) |
| WK-SCP0106-0400 | B3 | SCP0106_CAPA_Loss_Plan.getVersion | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0106_CAPA_Loss_Plan.getVersion: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getVersion:24) |
| WK-SCP0106-0401 | B3 | SCP0106_CAPA_Loss_Plan.getVersionSeq | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0106_CAPA_Loss_Plan.getVersionSeq: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getVersionSeq) |
| WK-SCP0106-0402 | B3 | `utils/capaLossPlan.sheetKey.ts` | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — `utils/capaLossPlan.sheetKey.ts`: 행 집계 — B3 27요소: TODO:27 (미실행 요소가 남아 판정필요) |  | 1 (`utils/capaLossPlan.sheetKey.ts`) |
| WK-SCP0106-0403 | B3 | comboCalls | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — comboCalls: 행 집계 — B3 27요소: TODO:27 (미실행 요소가 남아 판정필요) |  | 1 (comboCalls) |
| WK-SCP0106-0404 | B4 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — D00-4b-001: 행 집계 — B4 27요소: NOPATH:27 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-001) |
| WK-SCP0106-0405 | B4 | D00-4b-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — D00-4b-004: 행 집계 — B4 27요소: NOPATH:27 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-004) |
| WK-SCP0106-0406 | B4 | D00-4c-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — D00-4c-003: 행 집계 — B4 27요소: NOPATH:27 (미실행 요소가 남아 판정필요) |  | 1 (D00-4c-003) |
| WK-SCP0106-0407 | B4 | SCP0106_CAPA_Loss_Plan.GetCalcAssemblyRt | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0106_CAPA_Loss_Plan.GetCalcAssemblyRt: 진입점 집계 — B4 27요소: NOPATH:27 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0106_CAPA_Loss_Plan.GetCalcAssemb) |
| WK-SCP0106-0408 | B4 | SCP0106_CAPA_Loss_Plan.GetCalcEltrRt | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0106_CAPA_Loss_Plan.GetCalcEltrRt: 진입점 집계 — B4 27요소: NOPATH:27 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0106_CAPA_Loss_Plan.GetCalcEltrRt) |
| WK-SCP0106-0409 | B4 | SCP0106_CAPA_Loss_Plan.GetCalcRt | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0106_CAPA_Loss_Plan.GetCalcRt: 진입점 집계 — B4 27요소: NOPATH:27 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCP0106_CAPA_Loss_Plan.GetCalcRt:371) |
| WK-SCP0106-0410 | B4 | SCP0106_CAPA_Loss_Plan.GetCurrSheetValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0106_CAPA_Loss_Plan.GetCurrSheetValue: 진입점 집계 — B4 27요소: NOPATH:27 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0106_CAPA_Loss_Plan.GetCurrSheetV) |
| WK-SCP0106-0411 | B4 | SCP0106_CAPA_Loss_Plan.GetCurrVersionPro | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0106_CAPA_Loss_Plan.GetCurrVersionProgessStatus: 진입점 집계 — B4 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0106_CAPA_Loss_Plan.GetCurrVersio) |
| WK-SCP0106-0412 | B4 | SCP0106_CAPA_Loss_Plan.GetMeasureIdx | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0106_CAPA_Loss_Plan.GetMeasureIdx: 진입점 집계 — B4 27요소: NOPATH:27 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0106_CAPA_Loss_Plan.GetMeasureIdx) |
| WK-SCP0106-0413 | B4 | SCP0106_CAPA_Loss_Plan.GetRowIdxOfMeasur | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0106_CAPA_Loss_Plan.GetRowIdxOfMeasure: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SCP0106_CAPA_Loss_Plan.GetRowIdxOfMe) |
| WK-SCP0106-0414 | B4 | SCP0106_CAPA_Loss_Plan.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0106_CAPA_Loss_Plan.GetSpdTitle: 진입점 집계 — B4 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SCP0106_CAPA_Loss_Plan.GetSpdTitle:1) |
| WK-SCP0106-0415 | B4 | SCP0106_CAPA_Loss_Plan.getCurrCompany | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0106_CAPA_Loss_Plan.getCurrCompany: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getCurrCompan) |
| WK-SCP0106-0416 | B4 | SCP0106_CAPA_Loss_Plan.getCurrDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0106_CAPA_Loss_Plan.getCurrDivision: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getCurrDivisi) |
| WK-SCP0106-0417 | B4 | SCP0106_CAPA_Loss_Plan.getCurrElectrodeT | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0106_CAPA_Loss_Plan.getCurrElectrodeType: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getCurrElectr) |
| WK-SCP0106-0418 | B4 | SCP0106_CAPA_Loss_Plan.getCurrFactory | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0106_CAPA_Loss_Plan.getCurrFactory: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getCurrFactor) |
| WK-SCP0106-0419 | B4 | SCP0106_CAPA_Loss_Plan.getCurrLine | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0106_CAPA_Loss_Plan.getCurrLine: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getCurrLine:9) |
| WK-SCP0106-0420 | B4 | SCP0106_CAPA_Loss_Plan.getCurrMeasure | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0106_CAPA_Loss_Plan.getCurrMeasure: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getCurrMeasur) |
| WK-SCP0106-0421 | B4 | SCP0106_CAPA_Loss_Plan.getCurrNickname | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0106_CAPA_Loss_Plan.getCurrNickname: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getCurrNickna) |
| WK-SCP0106-0422 | B4 | SCP0106_CAPA_Loss_Plan.getCurrOperation | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0106_CAPA_Loss_Plan.getCurrOperation: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getCurrOperat) |
| WK-SCP0106-0423 | B4 | SCP0106_CAPA_Loss_Plan.getCurrPlant | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0106_CAPA_Loss_Plan.getCurrPlant: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getCurrPlant:) |
| WK-SCP0106-0424 | B4 | SCP0106_CAPA_Loss_Plan.getCurrSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0106_CAPA_Loss_Plan.getCurrSite: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getCurrSite:9) |
| WK-SCP0106-0425 | B4 | SCP0106_CAPA_Loss_Plan.getDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0106_CAPA_Loss_Plan.getDivision: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getDivision:2) |
| WK-SCP0106-0426 | B4 | SCP0106_CAPA_Loss_Plan.getDivisionType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0106_CAPA_Loss_Plan.getDivisionType: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getDivisionTy) |
| WK-SCP0106-0427 | B4 | SCP0106_CAPA_Loss_Plan.getElectrodeType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0106_CAPA_Loss_Plan.getElectrodeType: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getElectrodeT) |
| WK-SCP0106-0428 | B4 | SCP0106_CAPA_Loss_Plan.getFactory | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0106_CAPA_Loss_Plan.getFactory: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getFactory:68) |
| WK-SCP0106-0429 | B4 | SCP0106_CAPA_Loss_Plan.getItemId | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0106_CAPA_Loss_Plan.getItemId: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getItemId:753) |
| WK-SCP0106-0430 | B4 | SCP0106_CAPA_Loss_Plan.getLine | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0106_CAPA_Loss_Plan.getLine: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getLine:705:1) |
| WK-SCP0106-0431 | B4 | SCP0106_CAPA_Loss_Plan.getOperation | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0106_CAPA_Loss_Plan.getOperation: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getOperation:) |
| WK-SCP0106-0432 | B4 | SCP0106_CAPA_Loss_Plan.getPlanType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0106_CAPA_Loss_Plan.getPlanType: 진입점 집계 — B4 27요소: NOPATH:27 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.getPlanType:3) |
| WK-SCP0106-0433 | B4 | SCP0106_CAPA_Loss_Plan.getPlant | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0106_CAPA_Loss_Plan.getPlant: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getPlant:657:) |
| WK-SCP0106-0434 | B4 | SCP0106_CAPA_Loss_Plan.getProgressStatus | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0106_CAPA_Loss_Plan.getProgressStatus: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getProgressSt) |
| WK-SCP0106-0435 | B4 | SCP0106_CAPA_Loss_Plan.getSheetType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0106_CAPA_Loss_Plan.getSheetType: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getSheetType:) |
| WK-SCP0106-0436 | B4 | SCP0106_CAPA_Loss_Plan.getShopGroup | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0106_CAPA_Loss_Plan.getShopGroup: 진입점 집계 — B4 27요소: NOPATH:27 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.getShopGroup:) |
| WK-SCP0106-0437 | B4 | SCP0106_CAPA_Loss_Plan.getSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0106_CAPA_Loss_Plan.getSite: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getSite:619:1) |
| WK-SCP0106-0438 | B4 | SCP0106_CAPA_Loss_Plan.getVersion | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0106_CAPA_Loss_Plan.getVersion: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getVersion:24) |
| WK-SCP0106-0439 | B4 | SCP0106_CAPA_Loss_Plan.getVersionSeq | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0106_CAPA_Loss_Plan.getVersionSeq: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.getVersionSeq) |
| WK-SCP0106-0440 | B4 | `utils/capaLossPlan.sheetKey.ts` | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — `utils/capaLossPlan.sheetKey.ts`: 행 집계 — B4 27요소: NOPATH:27 (미실행 요소가 남아 판정필요) |  | 1 (`utils/capaLossPlan.sheetKey.ts`) |
| WK-SCP0106-0441 | B4 | comboCalls | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — comboCalls: 행 집계 — B4 27요소: NOPATH:27 (미실행 요소가 남아 판정필요) |  | 1 (comboCalls) |
| WK-SCP0106-0442 | F4 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — COMMON:UC-03: 행 집계 — F4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-SCP0106-0443 | F4 | D00-2-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — D00-2-001: 행 집계 — F4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-001) |
| WK-SCP0106-0444 | F4 | D00-2-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — D00-2-002: 행 집계 — F4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-002) |
| WK-SCP0106-0445 | F4 | D00-2-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — D00-2-008: 행 집계 — F4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-008) |
| WK-SCP0106-0446 | F4 | D00-3-017 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — D00-3-017: 행 집계 — F4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-017) |
| WK-SCP0106-0447 | F4 | D00-3-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — D00-3-020: 행 집계 — F4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-020) |
| WK-SCP0106-0448 | F4 | SCP0106_CAPA_Loss_Plan.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0106_CAPA_Loss_Plan.FindButton: 진입점 집계 — F4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0106_CAPA_Loss_Plan.FindButton AC) |
| WK-SCP0106-0449 | F4 | SCP0106_CAPA_Loss_Plan.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0106_CAPA_Loss_Plan.FindData: 진입점 집계 — F4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.FindData ACT:) |
| WK-SCP0106-0450 | F4 | SCP0106_CAPA_Loss_Plan.FindDataMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0106_CAPA_Loss_Plan.FindDataMain: 진입점 집계 — F4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.FindDataMain ) |
| WK-SCP0106-0451 | F4 | SCP0106_CAPA_Loss_Plan.RecalcSheetSelfLi | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0106_CAPA_Loss_Plan.RecalcSheetSelfLineAssembly: 진입점 집계 — F4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.RecalcSheetSe) |
| WK-SCP0106-0452 | F4 | SCP0106_CAPA_Loss_Plan.RecalcSheetSelfLi | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0106_CAPA_Loss_Plan.RecalcSheetSelfLineEltr: 진입점 집계 — F4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.RecalcSheetSe) |
| WK-SCP0106-0453 | F4 | SCP0106_CAPA_Loss_Plan.SaveButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0106_CAPA_Loss_Plan.SaveButton: 진입점 집계 — F4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.SaveButton) |
| WK-SCP0106-0454 | F4 | SCP0106_CAPA_Loss_Plan.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0106_CAPA_Loss_Plan.SaveData: 진입점 집계 — F4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.SaveData) |
| WK-SCP0106-0455 | F4 | SCP0106_CAPA_Loss_Plan.SaveDataMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0106_CAPA_Loss_Plan.SaveDataMain: 진입점 집계 — F4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.SaveDataMain) |
| WK-SCP0106-0456 | F4 | `CapaLossPlan.tsx` | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — `CapaLossPlan.tsx`: 행 집계 — F4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (`CapaLossPlan.tsx`) |
| WK-SCP0106-0457 | A5 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 1: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-SCP0106-0458 | A5 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 5: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (5) |
| WK-SCP0106-0459 | A5 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 6: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (6) |
| WK-SCP0106-0460 | A5 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-02: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0106-0461 | A5 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-03: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-SCP0106-0462 | A5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-07: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0106-0463 | A5 | D00-1-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-004: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-004) |
| WK-SCP0106-0464 | A5 | D00-1-026 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-026: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-026) |
| WK-SCP0106-0465 | A5 | D00-1-027 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-027: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-027) |
| WK-SCP0106-0466 | A5 | D00-1-032 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-032: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-032) |
| WK-SCP0106-0467 | A5 | D00-1-033 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-033: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-033) |
| WK-SCP0106-0468 | A5 | D00-1-035 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-035: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-035) |
| WK-SCP0106-0469 | A5 | D00-1-036 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-036: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-036) |
| WK-SCP0106-0470 | A5 | D00-1-038 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-038: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-038) |
| WK-SCP0106-0471 | A5 | D00-1-042 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-042: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-042) |
| WK-SCP0106-0472 | A5 | D00-1-043 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-043: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-043) |
| WK-SCP0106-0473 | A5 | D00-2-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-2-002: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-002) |
| WK-SCP0106-0474 | A5 | D00-2-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-2-005: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-005) |
| WK-SCP0106-0475 | A5 | D00-2-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-2-007: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-007) |
| WK-SCP0106-0476 | A5 | D00-2-015 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-2-015: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-015) |
| WK-SCP0106-0477 | A5 | D00-3-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-3-001: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-001) |
| WK-SCP0106-0478 | A5 | D00-4d-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-4d-012: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-012) |
| WK-SCP0106-0479 | A5 | D00-4d-015 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-4d-015: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-015) |
| WK-SCP0106-0480 | A5 | D00-4d-018 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-4d-018: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-018) |
| WK-SCP0106-0481 | A5 | SCP0106_CAPA_Loss_Plan.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0106_CAPA_Loss_Plan.CreateSpread: 진입점 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0106_CAPA_Loss_Plan.CreateSpread:) |
| WK-SCP0106-0482 | A5 | `components/CapaLossPlanGrid.tsx` | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — `components/CapaLossPlanGrid.tsx`: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (`components/CapaLossPlanGrid.tsx`) |
| WK-SCP0106-0483 | A5 | controls | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — controls: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (controls) |
| WK-SCP0106-0484 | A5 | validations | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — validations: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (validations) |
| WK-SCP0106-0485 | G4 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — COMMON:UC-06: 행 집계 — G4 17요소: NOT_RUN:15 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0106-0486 | G4 | D00-1-025 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-1-025: 행 집계 — G4 17요소: NOT_RUN:15 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-025) |
| WK-SCP0106-0487 | G4 | D00-1-043 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-1-043: 행 집계 — G4 17요소: NOT_RUN:15 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-043) |
| WK-SCP0106-0488 | G4 | D00-1-045 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-1-045: 행 집계 — G4 17요소: NOT_RUN:15 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-045) |
| WK-SCP0106-0489 | G4 | D00-3-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-3-001: 행 집계 — G4 17요소: NOT_RUN:15 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-001) |
| WK-SCP0106-0490 | G4 | D00-4d-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-4d-001: 행 집계 — G4 17요소: NOT_RUN:15 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-001) |
| WK-SCP0106-0491 | G4 | `components/CapaLossPlanForm.tsx` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — `components/CapaLossPlanForm.tsx`: 행 집계 — G4 17요소: NOT_RUN:15 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (`components/CapaLossPlanForm.tsx`) |
| WK-SCP0106-0492 | G4 | controls | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — controls: 행 집계 — G4 17요소: NOT_RUN:15 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (controls) |
| WK-SCP0106-0493 | H2 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 1: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-SCP0106-0494 | H2 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 11: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (11) |
| WK-SCP0106-0495 | H2 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 5: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (5) |
| WK-SCP0106-0496 | H2 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-02: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0106-0497 | H2 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-03: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-SCP0106-0498 | H2 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-07: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0106-0499 | H2 | D00-1-033 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-1-033: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-033) |
| WK-SCP0106-0500 | H2 | D00-1-035 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-1-035: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-035) |
| WK-SCP0106-0501 | H2 | D00-1-036 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-1-036: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-036) |
| WK-SCP0106-0502 | H2 | D00-1-038 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-1-038: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-038) |
| WK-SCP0106-0503 | H2 | D00-1-042 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-1-042: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-042) |
| WK-SCP0106-0504 | H2 | D00-2-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-2-002: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-002) |
| WK-SCP0106-0505 | H2 | D00-2-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-2-005: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-005) |
| WK-SCP0106-0506 | H2 | D00-2-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-2-007: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-007) |
| WK-SCP0106-0507 | H2 | D00-2-015 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-2-015: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-015) |
| WK-SCP0106-0508 | H2 | D00-3-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-3-001: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-001) |
| WK-SCP0106-0509 | H2 | D00-4b-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-4b-004: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-004) |
| WK-SCP0106-0510 | H2 | D00-4d-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-4d-012: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-012) |
| WK-SCP0106-0511 | H2 | D00-4d-015 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-4d-015: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-015) |
| WK-SCP0106-0512 | H2 | D00-4d-018 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-4d-018: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-018) |
| WK-SCP0106-0513 | H2 | SCP0106_CAPA_Loss_Plan.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0106_CAPA_Loss_Plan.CreateSpread: 진입점 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0106_CAPA_Loss_Plan.CreateSpread:) |
| WK-SCP0106-0514 | H2 | SCP0106_CAPA_Loss_Plan.SetMeasureColorOn | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetMeasureColorOneRow: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 15 (ACT:SCP0106_CAPA_Loss_Plan.SetMeasureCol) |
| WK-SCP0106-0515 | H2 | SCP0106_CAPA_Loss_Plan.Set_MeasureColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0106_CAPA_Loss_Plan.Set_MeasureColor: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 15 (ACT:SCP0106_CAPA_Loss_Plan.Set_MeasureCo) |
| WK-SCP0106-0516 | H2 | `components/CapaLossPlanGrid.tsx` | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — `components/CapaLossPlanGrid.tsx`: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`components/CapaLossPlanGrid.tsx`) |
| WK-SCP0106-0517 | H2 | controls | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — controls: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (controls) |
| WK-SCP0106-0518 | H2 | gridSignals | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — gridSignals: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (gridSignals) |
| WK-SCP0106-0519 | H2 | validations | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — validations: 행 집계 — H2 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (validations) |
| WK-SCP0106-0520 | H5 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 1: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-SCP0106-0521 | H5 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 5: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (5) |
| WK-SCP0106-0522 | H5 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-02: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0106-0523 | H5 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-03: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-SCP0106-0524 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0106-0525 | H5 | D00-1-038 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-1-038: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-038) |
| WK-SCP0106-0526 | H5 | D00-2-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-2-002: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-002) |
| WK-SCP0106-0527 | H5 | D00-3-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-3-001: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-001) |
| WK-SCP0106-0528 | H5 | D00-4d-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-4d-012: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-012) |
| WK-SCP0106-0529 | H5 | D00-4d-015 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-4d-015: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-015) |
| WK-SCP0106-0530 | H5 | D00-4d-018 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-4d-018: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-018) |
| WK-SCP0106-0531 | H5 | SCP0106_CAPA_Loss_Plan.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0106_CAPA_Loss_Plan.CreateSpread: 진입점 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0106_CAPA_Loss_Plan.CreateSpread:) |
| WK-SCP0106-0532 | H5 | `components/CapaLossPlanGrid.tsx` | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `components/CapaLossPlanGrid.tsx`: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (`components/CapaLossPlanGrid.tsx`) |
| WK-SCP0106-0533 | H5 | controls | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — controls: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (controls) |
| WK-SCP0106-0534 | H5 | validations | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — validations: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (validations) |
| WK-SCP0106-0535 | X-REASON | D00-3-007 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-007 §3 setColumnWidth / `(c, DEF_DATE_COL_WIDTH)` — `M_00`(개선율) 블록은 TVF 가 **0건 생성하는 전면 사문**이라 미이식 확정(03 § |  | 1 (D00-3-007) |
| WK-SCP0106-0536 | X-REASON | D00-3-008 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-008 §3 setColumnWidth / `(c, 0)` — 위 D00-3-007 과 같은 `M_00` 사문 블록의 미체크 분기 — 대상 컬럼 0건이라 도달 불가(03 §2.2 C-09, |  | 1 (D00-3-008) |
| WK-SCP0106-0537 | X-REASON | D00-4b-002 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-4b-002 §4b Data_SCP.CommonAll / YearFromThisYear / dtFromYYYY — 선언(cs:74) 외 참조 **0건**인 데드 콤보 `dtFromYYYY` — |  | 1 (D00-4b-002) |
| WK-SCP0106-0538 | X-REASON | MODAL:FPModal | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — MODAL:FPModal AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 — 추출 오탐 — `FPModal` 은 팝업명이 아니라 `SCM_MST_SHEET_COLUMNS.CEL |  | 1 (MODAL:FPModal) |
| WK-SCP0106-0539 | X-REASON | MODAL:ShowDialog | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — MODAL:ShowDialog AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 — 추출 오탐 — `ShowDialog` 는 모달명이 아니라 00 §4e 팝업표의 **trigge |  | 1 (MODAL:ShowDialog) |
| WK-SCP0106-0540 | X-REASON | `M_00`(개선율) 컬럼 계열 · `GetCalcRt` · `IsGoa | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `M_00`(개선율) 컬럼 계열 · `GetCalcRt` · `IsGoal` TVF 가 0건 생성하는 전면 사문(03 C-09, R-10) |  | 1 (`M_00`(개선율) 컬럼 계열 · `GetCalcRt` · `IsGoa) |
| WK-SCP0106-0541 | X-REASON | `ReadOnlySheetList` 를 "읽기전용 시트"로 구현 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `ReadOnlySheetList` 를 "읽기전용 시트"로 구현 유일 소비처가 필터 일괄해제 skip 이라 편집 차단 기능이 아니다(L-28 정정본, C-03). **`CURRENT_ASSEMBLY` |  | 1 (`ReadOnlySheetList` 를 "읽기전용 시트"로 구현) |
| WK-SCP0106-0542 | X-REASON | `chkShowRate` 실동작 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `chkShowRate` 실동작 토글 대상(`M_00`)이 0건이라 **무동작이 파리티**(R-02, V-19). 체크박스는 노출·초기체크(dec §B-3) |  | 1 (`chkShowRate` 실동작) |
| WK-SCP0106-0543 | X-REASON | 데드 콤보 2건(`dtFromYYYY`/`dtYesOrNo`) | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 데드 콤보 2건(`dtFromYYYY`/`dtYesOrNo`) 선언 외 참조 0건(02 §2.7, F-32) |  | 1 (데드 콤보 2건(`dtFromYYYY`/`dtYesOrNo`)) |
| WK-SCP0106-0544 | X-REASON | 셀 콤보 `OperationByLine` | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 셀 콤보 `OperationByLine` 대상 컬럼이 폭0 + 코드 숨김 이중 은닉 = AS-IS 에서 렌더된 적 없음(C-07, dec §A BLK-17) |  | 1 (셀 콤보 `OperationByLine`) |
| WK-SCP0106-0545 | D1 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 7: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (7) |
| WK-SCP0106-0546 | D1 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 8: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (8) |
| WK-SCP0106-0547 | D1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — COMMON:UC-02: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0106-0548 | D1 | D00-2-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-2-001: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-001) |
| WK-SCP0106-0549 | D1 | D00-3-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-006: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-006) |
| WK-SCP0106-0550 | D1 | D00-3-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-009: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-009) |
| WK-SCP0106-0551 | D1 | D00-3-017 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-017: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-017) |
| WK-SCP0106-0552 | D1 | D00-3-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-020: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-020) |
| WK-SCP0106-0553 | D1 | D00-3-022 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-022: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-022) |
| WK-SCP0106-0554 | D1 | D00-4c-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4c-002: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4c-002) |
| WK-SCP0106-0555 | D1 | D00-4c-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4c-008: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4c-008) |
| WK-SCP0106-0556 | D1 | D00-4d-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4d-012: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-012) |
| WK-SCP0106-0557 | D1 | D00-4d-015 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4d-015: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-015) |
| WK-SCP0106-0558 | D1 | D00-4d-017 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4d-017: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-017) |
| WK-SCP0106-0559 | D1 | D00-4d-018 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4d-018: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-018) |
| WK-SCP0106-0560 | D1 | D00-4d-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4d-020: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-020) |
| WK-SCP0106-0561 | D1 | D00-4d-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4d-021: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-021) |
| WK-SCP0106-0562 | D1 | D00-4d-022 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4d-022: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-022) |
| WK-SCP0106-0563 | D1 | D00-4d-023 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4d-023: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-023) |
| WK-SCP0106-0564 | D1 | D00-4d-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4d-024: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-024) |
| WK-SCP0106-0565 | D1 | SCP0106_CAPA_Loss_Plan.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SCP0106_CAPA_Loss_Plan.EditButton: 진입점 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 22 (ACT:SCP0106_CAPA_Loss_Plan.EditButton:24) |
| WK-SCP0106-0566 | D1 | `components/CapaLossPlanGrid.tsx` | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — `components/CapaLossPlanGrid.tsx`: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (`components/CapaLossPlanGrid.tsx`) |
| WK-SCP0106-0567 | D1 | `hooks/useCapaLossPlanCellEdit.ts` | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — `hooks/useCapaLossPlanCellEdit.ts`: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (`hooks/useCapaLossPlanCellEdit.ts`) |
| WK-SCP0106-0568 | D1 | `utils/capaLossPlan.editLock.ts` | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — `utils/capaLossPlan.editLock.ts`: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (`utils/capaLossPlan.editLock.ts`) |
| WK-SCP0106-0569 | D1 | `utils/capaLossPlan.sheetKey.ts` | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — `utils/capaLossPlan.sheetKey.ts`: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (`utils/capaLossPlan.sheetKey.ts`) |
| WK-SCP0106-0570 | D1 | buttonGuards | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — buttonGuards: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (buttonGuards) |
| WK-SCP0106-0571 | D1 | gridSignals | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — gridSignals: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (gridSignals) |
| WK-SCP0106-0572 | D1 | validations | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — validations: 행 집계 — D1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (validations) |
| WK-SCP0106-0573 | D3 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 7: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (7) |
| WK-SCP0106-0574 | D3 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 8: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (8) |
| WK-SCP0106-0575 | D3 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — COMMON:UC-02: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0106-0576 | D3 | D00-1-033 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-1-033: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-033) |
| WK-SCP0106-0577 | D3 | D00-1-035 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-1-035: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-035) |
| WK-SCP0106-0578 | D3 | D00-1-036 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-1-036: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-036) |
| WK-SCP0106-0579 | D3 | D00-1-042 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-1-042: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-042) |
| WK-SCP0106-0580 | D3 | D00-2-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-2-001: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-001) |
| WK-SCP0106-0581 | D3 | D00-3-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-006: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-006) |
| WK-SCP0106-0582 | D3 | D00-3-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-009: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-009) |
| WK-SCP0106-0583 | D3 | D00-3-017 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-017: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-017) |
| WK-SCP0106-0584 | D3 | D00-3-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-020: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-020) |
| WK-SCP0106-0585 | D3 | D00-3-022 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-022: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-022) |
| WK-SCP0106-0586 | D3 | D00-4b-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4b-004: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-004) |
| WK-SCP0106-0587 | D3 | D00-4c-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4c-002: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4c-002) |
| WK-SCP0106-0588 | D3 | D00-4c-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4c-008: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4c-008) |
| WK-SCP0106-0589 | D3 | D00-4d-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4d-012: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-012) |
| WK-SCP0106-0590 | D3 | D00-4d-015 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4d-015: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-015) |
| WK-SCP0106-0591 | D3 | D00-4d-017 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4d-017: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-017) |
| WK-SCP0106-0592 | D3 | D00-4d-018 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4d-018: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-018) |
| WK-SCP0106-0593 | D3 | D00-4d-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4d-020: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-020) |
| WK-SCP0106-0594 | D3 | D00-4d-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4d-021: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-021) |
| WK-SCP0106-0595 | D3 | D00-4d-022 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4d-022: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-022) |
| WK-SCP0106-0596 | D3 | D00-4d-023 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4d-023: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-023) |
| WK-SCP0106-0597 | D3 | D00-4d-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4d-024: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-024) |
| WK-SCP0106-0598 | D3 | SCP0106_CAPA_Loss_Plan.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SCP0106_CAPA_Loss_Plan.EditButton: 진입점 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 22 (ACT:SCP0106_CAPA_Loss_Plan.EditButton:24) |
| WK-SCP0106-0599 | D3 | `components/CapaLossPlanGrid.tsx` | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — `components/CapaLossPlanGrid.tsx`: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (`components/CapaLossPlanGrid.tsx`) |
| WK-SCP0106-0600 | D3 | `hooks/useCapaLossPlanCellEdit.ts` | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — `hooks/useCapaLossPlanCellEdit.ts`: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (`hooks/useCapaLossPlanCellEdit.ts`) |
| WK-SCP0106-0601 | D3 | `utils/capaLossPlan.editLock.ts` | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — `utils/capaLossPlan.editLock.ts`: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (`utils/capaLossPlan.editLock.ts`) |
| WK-SCP0106-0602 | D3 | `utils/capaLossPlan.sheetKey.ts` | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — `utils/capaLossPlan.sheetKey.ts`: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (`utils/capaLossPlan.sheetKey.ts`) |
| WK-SCP0106-0603 | D3 | buttonGuards | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — buttonGuards: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (buttonGuards) |
| WK-SCP0106-0604 | D3 | gridSignals | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — gridSignals: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (gridSignals) |
| WK-SCP0106-0605 | D3 | validations | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — validations: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (validations) |
| WK-SCP0106-0606 | D5 | SCP0106_CAPA_Loss_Plan.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0106_CAPA_Loss_Plan.CreateSpread: 진입점 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0106_CAPA_Loss_Plan.CreateSpread:) |
| WK-SCP0106-0607 | E4 | D00-4d-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D00-4d-014: 행 집계 — E4 26요소: NOT_RUN:26 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-014) |
| WK-SCP0106-0608 | E4 | SCP0106_CAPA_Loss_Plan.SetEditableMeasur | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetEditableMeasures: 진입점 집계 — E4 26요소: NOT_RUN:26 (미실행 요소가 남아 판정필요) |  | 11 (ACT:SCP0106_CAPA_Loss_Plan.SetEditableMe) |
| WK-SCP0106-0609 | E4 | SCP0106_CAPA_Loss_Plan.SetLockColumns | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetLockColumns: 진입점 집계 — E4 26요소: NOT_RUN:26 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.SetLockColumn) |
| WK-SCP0106-0610 | E4 | SCP0106_CAPA_Loss_Plan.SetLockColumnsAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetLockColumnsAll: 진입점 집계 — E4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 64 (ACT:SCP0106_CAPA_Loss_Plan.SetLockColumn) |
| WK-SCP0106-0611 | E4 | SCP0106_CAPA_Loss_Plan.SetLockColumnsOne | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetLockColumnsOneRow: 진입점 집계 — E4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 59 (ACT:SCP0106_CAPA_Loss_Plan.SetLockColumn) |
| WK-SCP0106-0612 | E4 | SCP0106_CAPA_Loss_Plan.SetMeasureColorOn | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetMeasureColorOneRow: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 15 (ACT:SCP0106_CAPA_Loss_Plan.SetMeasureCol) |
| WK-SCP0106-0613 | E4 | SCP0106_CAPA_Loss_Plan.SetQueryInfoGet | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetQueryInfoGet: 진입점 집계 — E4 26요소: NOT_RUN:26 (미실행 요소가 남아 판정필요) |  | 19 (ACT:SCP0106_CAPA_Loss_Plan.SetQueryInfoG) |
| WK-SCP0106-0614 | E4 | SCP0106_CAPA_Loss_Plan.SetQueryInfoSaveL | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetQueryInfoSaveLine: 진입점 집계 — E4 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 27 (ACT:SCP0106_CAPA_Loss_Plan.SetQueryInfoS) |
| WK-SCP0106-0615 | E4 | SCP0106_CAPA_Loss_Plan.SetQueryInfoSaveM | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetQueryInfoSaveModel: 진입점 집계 — E4 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 28 (ACT:SCP0106_CAPA_Loss_Plan.SetQueryInfoS) |
| WK-SCP0106-0616 | E4 | SCP0106_CAPA_Loss_Plan.SetSheetMerge | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetSheetMerge: 진입점 집계 — E4 26요소: NOT_RUN:26 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.SetSheetMerge) |
| WK-SCP0106-0617 | E4 | SCP0106_CAPA_Loss_Plan.SetSheetNumericCo | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetSheetNumericColumnFormat: 진입점 집계 — E4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0106_CAPA_Loss_Plan.SetSheetNumer) |
| WK-SCP0106-0618 | E4 | SCP0106_CAPA_Loss_Plan.SetSheetNumericCo | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetSheetNumericColumnFormat: 진입점 집계 — E4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.SetSheetNumer) |
| WK-SCP0106-0619 | E4 | SCP0106_CAPA_Loss_Plan.SetSheetRangeValu | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetSheetRangeValue: 진입점 집계 — E4 26요소: NOT_RUN:26 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.SetSheetRange) |
| WK-SCP0106-0620 | E4 | SCP0106_CAPA_Loss_Plan.SetVisibleElectro | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetVisibleElectrodeType: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.SetVisibleEle) |
| WK-SCP0106-0621 | E4 | SCP0106_CAPA_Loss_Plan.SetVisibleOperati | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetVisibleOperation: 진입점 집계 — E4 26요소: NOT_RUN:26 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.SetVisibleOpe) |
| WK-SCP0106-0622 | E4 | SCP0106_CAPA_Loss_Plan.Set_MeasureColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0106_CAPA_Loss_Plan.Set_MeasureColor: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 15 (ACT:SCP0106_CAPA_Loss_Plan.Set_MeasureCo) |
| WK-SCP0106-0623 | E4 | validations | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — validations: 행 집계 — E4 26요소: NOT_RUN:26 (미실행 요소가 남아 판정필요) |  | 1 (validations) |
| WK-SCP0106-0624 | G1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-02: 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0106-0625 | G1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-03: 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-SCP0106-0626 | G1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-06: 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0106-0627 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0106-0628 | G1 | D00-1-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-006: 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-006) |
| WK-SCP0106-0629 | G1 | D00-1-025 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-025: 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-025) |
| WK-SCP0106-0630 | G1 | D00-1-043 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-043: 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-043) |
| WK-SCP0106-0631 | G1 | D00-1-045 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-045: 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-045) |
| WK-SCP0106-0632 | G1 | D00-2-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-2-002: 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-002) |
| WK-SCP0106-0633 | G1 | D00-3-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-3-001: 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-001) |
| WK-SCP0106-0634 | G1 | D00-3-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-3-009: 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-009) |
| WK-SCP0106-0635 | G1 | D00-3-017 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-3-017: 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-017) |
| WK-SCP0106-0636 | G1 | D00-3-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-3-020: 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-020) |
| WK-SCP0106-0637 | G1 | D00-4b-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-4b-004: 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-004) |
| WK-SCP0106-0638 | G1 | D00-4d-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-4d-001: 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-001) |
| WK-SCP0106-0639 | G1 | SCP0106_CAPA_Loss_Plan.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SCP0106_CAPA_Loss_Plan.FindButton: 진입점 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.FindButton:20) |
| WK-SCP0106-0640 | G1 | SCP0106_CAPA_Loss_Plan.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SCP0106_CAPA_Loss_Plan.FindData: 진입점 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.FindData:3359) |
| WK-SCP0106-0641 | G1 | SCP0106_CAPA_Loss_Plan.FindDataMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SCP0106_CAPA_Loss_Plan.FindDataMain: 진입점 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.FindDataMain:) |
| WK-SCP0106-0642 | G1 | `components/CapaLossPlanForm.tsx` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `components/CapaLossPlanForm.tsx`: 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (`components/CapaLossPlanForm.tsx`) |
| WK-SCP0106-0643 | G1 | controls | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — controls: 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (controls) |
| WK-SCP0106-0644 | G6 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — COMMON:UC-06: 행 집계 — G6 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0106-0645 | G6 | D00-1-025 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-1-025: 행 집계 — G6 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-025) |
| WK-SCP0106-0646 | G6 | D00-1-043 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-1-043: 행 집계 — G6 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-043) |
| WK-SCP0106-0647 | G6 | D00-1-045 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-1-045: 행 집계 — G6 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-045) |
| WK-SCP0106-0648 | G6 | D00-3-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-3-001: 행 집계 — G6 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-001) |
| WK-SCP0106-0649 | G6 | D00-4d-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-4d-001: 행 집계 — G6 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-001) |
| WK-SCP0106-0650 | G6 | `components/CapaLossPlanForm.tsx` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — `components/CapaLossPlanForm.tsx`: 행 집계 — G6 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (`components/CapaLossPlanForm.tsx`) |
| WK-SCP0106-0651 | G6 | controls | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — controls: 행 집계 — G6 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (controls) |
| WK-SCP0106-0652 | X-LOC | buttonGuards | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — buttonGuards: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (buttonGuards) |
| WK-SCP0106-0653 | X-LOC | comboCalls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — comboCalls: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (comboCalls) |
| WK-SCP0106-0654 | X-LOC | entryPoints | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — entryPoints: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (entryPoints) |
| WK-SCP0106-0655 | X-LOC | events | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — events: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (events) |
| WK-SCP0106-0656 | X-LOC | extractionLimits | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — extractionLimits: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (extractionLimits) |
| WK-SCP0106-0657 | X-LOC | gridColumns | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — gridColumns: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (gridColumns) |
| WK-SCP0106-0658 | X-LOC | gridSignals | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — gridSignals: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (gridSignals) |
| WK-SCP0106-0659 | X-LOC | popups | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — popups: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (popups) |
| WK-SCP0106-0660 | X-LOC | spCalls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — spCalls: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (spCalls) |
| WK-SCP0106-0661 | X-ROW | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 10: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (10) |
| WK-SCP0106-0662 | X-ROW | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 2: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (2) |
| WK-SCP0106-0663 | X-ROW | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 4: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (4) |
| WK-SCP0106-0664 | X-ROW | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 9: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (9) |
| WK-SCP0106-0665 | X-ROW | AssemblyCapaMeasureSet..ctor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AssemblyCapaMeasureSet..ctor: 진입점 집계 2검사 — NOPATH:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 9 (ACT:AssemblyCapaMeasureSet..ctor:997:1 A) |
| WK-SCP0106-0666 | X-ROW | AssemblyCapaMeasureSet.GeFilterModel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AssemblyCapaMeasureSet.GeFilterModel: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:AssemblyCapaMeasureSet.GeFilterModel) |
| WK-SCP0106-0667 | X-ROW | AssemblyCapaMeasureSet.GetCurrSheetValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AssemblyCapaMeasureSet.GetCurrSheetValue: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:AssemblyCapaMeasureSet.GetCurrSheetV) |
| WK-SCP0106-0668 | X-ROW | AssemblyCapaMeasureSet.GetDayCount | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AssemblyCapaMeasureSet.GetDayCount: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:AssemblyCapaMeasureSet.GetDayCount A) |
| WK-SCP0106-0669 | X-ROW | AssemblyCapaMeasureSet.GetLineValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AssemblyCapaMeasureSet.GetLineValue: 진입점 집계 3검사 — NOT_RUN:1 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:AssemblyCapaMeasureSet.GetLineValue:) |
| WK-SCP0106-0670 | X-ROW | AssemblyCapaMeasureSet.GetMeasureRowInde | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AssemblyCapaMeasureSet.GetMeasureRowIndex: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:AssemblyCapaMeasureSet.GetMeasureRow) |
| WK-SCP0106-0671 | X-ROW | AssemblyCapaMeasureSet.GetMeasureValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AssemblyCapaMeasureSet.GetMeasureValue: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:AssemblyCapaMeasureSet.GetMeasureVal) |
| WK-SCP0106-0672 | X-ROW | AssemblyCapaMeasureSet.GetMonthList | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AssemblyCapaMeasureSet.GetMonthList: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:AssemblyCapaMeasureSet.GetMonthList ) |
| WK-SCP0106-0673 | X-ROW | AssemblyCapaMeasureSet.GetSheetRowIndex | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AssemblyCapaMeasureSet.GetSheetRowIndex: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 12 (ACT:AssemblyCapaMeasureSet.GetSheetRowIn) |
| WK-SCP0106-0674 | X-ROW | AssemblyCapaMeasureSet.GetValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AssemblyCapaMeasureSet.GetValue: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:AssemblyCapaMeasureSet.GetValue ACT:) |
| WK-SCP0106-0675 | X-ROW | AssemblyCapaMeasureSet.Init | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AssemblyCapaMeasureSet.Init: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 16 (ACT:AssemblyCapaMeasureSet.Init ACT:Asse) |
| WK-SCP0106-0676 | X-ROW | AssemblyCapaMeasureSet.SetSheetEditStatu | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AssemblyCapaMeasureSet.SetSheetEditStatus: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:AssemblyCapaMeasureSet.SetSheetEditS) |
| WK-SCP0106-0677 | X-ROW | AssemblyCapaMeasureSet.SetValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AssemblyCapaMeasureSet.SetValue: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 7 (ACT:AssemblyCapaMeasureSet.SetValue ACT:) |
| WK-SCP0106-0678 | X-ROW | AssemblyCapaMeasureSetLine..ctor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AssemblyCapaMeasureSetLine..ctor: 진입점 집계 3검사 — NOT_RUN:2 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:AssemblyCapaMeasureSetLine..ctor:168) |
| WK-SCP0106-0679 | X-ROW | AssemblyCapaMeasureSetLine.Refresh | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AssemblyCapaMeasureSetLine.Refresh: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:AssemblyCapaMeasureSetLine.Refresh A) |
| WK-SCP0106-0680 | X-ROW | AssemblyCurrentCapaMeasureSet..ctor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AssemblyCurrentCapaMeasureSet..ctor: 진입점 집계 2검사 — NOPATH:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 9 (ACT:AssemblyCurrentCapaMeasureSet..ctor:) |
| WK-SCP0106-0681 | X-ROW | AssemblyCurrentCapaMeasureSet.ApplyToShe | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AssemblyCurrentCapaMeasureSet.ApplyToSheet: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:AssemblyCurrentCapaMeasureSet.ApplyT) |
| WK-SCP0106-0682 | X-ROW | AssemblyCurrentCapaMeasureSet.ApplyToShe | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AssemblyCurrentCapaMeasureSet.ApplyToSheetOnlyEdit: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:AssemblyCurrentCapaMeasureSet.ApplyT) |
| WK-SCP0106-0683 | X-ROW | AssemblyCurrentCapaMeasureSet.ApplyToShe | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AssemblyCurrentCapaMeasureSet.ApplyToSheetOnlyEdit: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 19 (ACT:AssemblyCurrentCapaMeasureSet.ApplyT) |
| WK-SCP0106-0684 | X-ROW | AssemblyCurrentCapaMeasureSet.GetBaseCol | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AssemblyCurrentCapaMeasureSet.GetBaseColumnIndex: 진입점 집계 3검사 — NOT_RUN:1 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:AssemblyCurrentCapaMeasureSet.GetBas) |
| WK-SCP0106-0685 | X-ROW | AssemblyCurrentCapaMeasureSet.GetDayCoun | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AssemblyCurrentCapaMeasureSet.GetDayCount: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:AssemblyCurrentCapaMeasureSet.GetDay) |
| WK-SCP0106-0686 | X-ROW | AssemblyCurrentCapaMeasureSet.GetIGofTab | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AssemblyCurrentCapaMeasureSet.GetIGofTable: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:AssemblyCurrentCapaMeasureSet.GetIGo) |
| WK-SCP0106-0687 | X-ROW | AssemblyCurrentCapaMeasureSet.GetLossCol | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AssemblyCurrentCapaMeasureSet.GetLossColumnIndex: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 9 (ACT:AssemblyCurrentCapaMeasureSet.GetLos) |
| WK-SCP0106-0688 | X-ROW | AssemblyCurrentCapaMeasureSet.GetMeasure | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AssemblyCurrentCapaMeasureSet.GetMeasureIndexOfTab: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:AssemblyCurrentCapaMeasureSet.GetMea) |
| WK-SCP0106-0689 | X-ROW | AssemblyCurrentCapaMeasureSet.GetMonthLi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AssemblyCurrentCapaMeasureSet.GetMonthList: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:AssemblyCurrentCapaMeasureSet.GetMon) |
| WK-SCP0106-0690 | X-ROW | AssemblyCurrentCapaMeasureSet.GetPlanCol | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AssemblyCurrentCapaMeasureSet.GetPlanColumnIndex: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 9 (ACT:AssemblyCurrentCapaMeasureSet.GetPla) |
| WK-SCP0106-0691 | X-ROW | AssemblyCurrentCapaMeasureSet.GetResultC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AssemblyCurrentCapaMeasureSet.GetResultColumnIndex: 진입점 집계 3검사 — NOPATH:1 · TODO:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:AssemblyCurrentCapaMeasureSet.GetRes) |
| WK-SCP0106-0692 | X-ROW | AssemblyCurrentCapaMeasureSet.GetRowInde | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AssemblyCurrentCapaMeasureSet.GetRowIndexOfMeasure: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 14 (ACT:AssemblyCurrentCapaMeasureSet.GetRow) |
| WK-SCP0106-0693 | X-ROW | AssemblyCurrentCapaMeasureSet.GetValueFr | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AssemblyCurrentCapaMeasureSet.GetValueFromDayCntTa: 진입점 집계 23검사 — NOPATH:11 · TODO:11 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 11 (ACT:AssemblyCurrentCapaMeasureSet.GetVal) |
| WK-SCP0106-0694 | X-ROW | AssemblyCurrentCapaMeasureSet.GetValueFr | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AssemblyCurrentCapaMeasureSet.GetValueFromMeasureT: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 8 (ACT:AssemblyCurrentCapaMeasureSet.GetVal) |
| WK-SCP0106-0695 | X-ROW | AssemblyCurrentCapaMeasureSet.Init | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AssemblyCurrentCapaMeasureSet.Init: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 12 (ACT:AssemblyCurrentCapaMeasureSet.Init A) |
| WK-SCP0106-0696 | X-ROW | AssemblyCurrentCapaMeasureSet.RecalcSelf | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AssemblyCurrentCapaMeasureSet.RecalcSelf: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 8 (ACT:AssemblyCurrentCapaMeasureSet.Recalc) |
| WK-SCP0106-0697 | X-ROW | AssemblyCurrentCapaMeasureSet.recalcLD_R | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AssemblyCurrentCapaMeasureSet.recalcLD_RT: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:AssemblyCurrentCapaMeasureSet.recalc) |
| WK-SCP0106-0698 | X-ROW | AssemblyCurrentCapaMeasureSet.recalcOP_R | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AssemblyCurrentCapaMeasureSet.recalcOP_RT: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:AssemblyCurrentCapaMeasureSet.recalc) |
| WK-SCP0106-0699 | X-ROW | AssemblyCurrentCapaMeasureSet.recalcPROD | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AssemblyCurrentCapaMeasureSet.recalcPROD_CAPA_D: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:AssemblyCurrentCapaMeasureSet.recalc) |
| WK-SCP0106-0700 | X-ROW | AssemblyCurrentCapaMeasureSet.recalcPROD | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AssemblyCurrentCapaMeasureSet.recalcPROD_CAPA_M: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:AssemblyCurrentCapaMeasureSet.recalc) |
| WK-SCP0106-0701 | X-ROW | AssemblyCurrentCapaMeasureSet.recalcPROD | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AssemblyCurrentCapaMeasureSet.recalcPROD_OP_RT: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:AssemblyCurrentCapaMeasureSet.recalc) |
| WK-SCP0106-0702 | X-ROW | AssemblyCurrentCapaMeasureSet.recalcTEEP | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AssemblyCurrentCapaMeasureSet.recalcTEEP: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:AssemblyCurrentCapaMeasureSet.recalc) |
| WK-SCP0106-0703 | X-ROW | AssemblyCurrentCapaMeasureSet.recalcTHRY | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AssemblyCurrentCapaMeasureSet.recalcTHRY_CAPA_D: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:AssemblyCurrentCapaMeasureSet.recalc) |
| WK-SCP0106-0704 | X-ROW | AssemblyCurrentCapaMeasureSet.recalcWT_R | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AssemblyCurrentCapaMeasureSet.recalcWT_RT: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:AssemblyCurrentCapaMeasureSet.recalc) |
| WK-SCP0106-0705 | X-ROW | D00-1-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-001: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-001) |
| WK-SCP0106-0706 | X-ROW | D00-1-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-002: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-002) |
| WK-SCP0106-0707 | X-ROW | D00-1-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-003: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-003) |
| WK-SCP0106-0708 | X-ROW | D00-1-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-005: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-005) |
| WK-SCP0106-0709 | X-ROW | D00-1-028 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-028: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-028) |
| WK-SCP0106-0710 | X-ROW | D00-1-029 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-029: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-029) |
| WK-SCP0106-0711 | X-ROW | D00-1-030 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-030: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-030) |
| WK-SCP0106-0712 | X-ROW | D00-1-031 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-031: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-031) |
| WK-SCP0106-0713 | X-ROW | D00-1-034 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-034: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-034) |
| WK-SCP0106-0714 | X-ROW | D00-3-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-002: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-002) |
| WK-SCP0106-0715 | X-ROW | D00-3-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-003: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-003) |
| WK-SCP0106-0716 | X-ROW | D00-3-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-004: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-004) |
| WK-SCP0106-0717 | X-ROW | D00-3-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-005: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-005) |
| WK-SCP0106-0718 | X-ROW | D00-3-016 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-016: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-016) |
| WK-SCP0106-0719 | X-ROW | D00-4c-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-001: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-001) |
| WK-SCP0106-0720 | X-ROW | D00-4c-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-004: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-004) |
| WK-SCP0106-0721 | X-ROW | D00-4c-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-005: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-005) |
| WK-SCP0106-0722 | X-ROW | D00-4c-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-006: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-006) |
| WK-SCP0106-0723 | X-ROW | D00-4c-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-007: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-007) |
| WK-SCP0106-0724 | X-ROW | EltrCapaMeasureSet..ctor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCapaMeasureSet..ctor: 진입점 집계 2검사 — NOPATH:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 9 (ACT:EltrCapaMeasureSet..ctor:1586:1 ACT:) |
| WK-SCP0106-0725 | X-ROW | EltrCapaMeasureSet.GeFilterModel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCapaMeasureSet.GeFilterModel: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:EltrCapaMeasureSet.GeFilterModel ACT) |
| WK-SCP0106-0726 | X-ROW | EltrCapaMeasureSet.GetCurrSheetValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCapaMeasureSet.GetCurrSheetValue: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:EltrCapaMeasureSet.GetCurrSheetValue) |
| WK-SCP0106-0727 | X-ROW | EltrCapaMeasureSet.GetDayCount | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCapaMeasureSet.GetDayCount: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:EltrCapaMeasureSet.GetDayCount ACT:E) |
| WK-SCP0106-0728 | X-ROW | EltrCapaMeasureSet.GetIGofTable | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCapaMeasureSet.GetIGofTable: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:EltrCapaMeasureSet.GetIGofTable ACT:) |
| WK-SCP0106-0729 | X-ROW | EltrCapaMeasureSet.GetItemValues | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCapaMeasureSet.GetItemValues: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 10 (ACT:EltrCapaMeasureSet.GetItemValues ACT) |
| WK-SCP0106-0730 | X-ROW | EltrCapaMeasureSet.GetLineValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCapaMeasureSet.GetLineValue: 진입점 집계 3검사 — NOPATH:1 · TODO:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:EltrCapaMeasureSet.GetLineValue:1817) |
| WK-SCP0106-0731 | X-ROW | EltrCapaMeasureSet.GetMeasureIndexOfTabl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCapaMeasureSet.GetMeasureIndexOfTable: 진입점 집계 3검사 — NOPATH:1 · TODO:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 7 (ACT:EltrCapaMeasureSet.GetMeasureIndexOf) |
| WK-SCP0106-0732 | X-ROW | EltrCapaMeasureSet.GetMeasureRowIndex | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCapaMeasureSet.GetMeasureRowIndex: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 7 (ACT:EltrCapaMeasureSet.GetMeasureRowInde) |
| WK-SCP0106-0733 | X-ROW | EltrCapaMeasureSet.GetMeasureValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCapaMeasureSet.GetMeasureValue: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:EltrCapaMeasureSet.GetMeasureValue A) |
| WK-SCP0106-0734 | X-ROW | EltrCapaMeasureSet.GetMonthList | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCapaMeasureSet.GetMonthList: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:EltrCapaMeasureSet.GetMonthList ACT:) |
| WK-SCP0106-0735 | X-ROW | EltrCapaMeasureSet.GetRowIndexOfMeasure | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCapaMeasureSet.GetRowIndexOfMeasure: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 14 (ACT:EltrCapaMeasureSet.GetRowIndexOfMeas) |
| WK-SCP0106-0736 | X-ROW | EltrCapaMeasureSet.GetSheetRowIndex | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCapaMeasureSet.GetSheetRowIndex: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 12 (ACT:EltrCapaMeasureSet.GetSheetRowIndex ) |
| WK-SCP0106-0737 | X-ROW | EltrCapaMeasureSet.GetValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCapaMeasureSet.GetValue: 진입점 집계 5검사 — NOPATH:2 · TODO:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 10 (ACT:EltrCapaMeasureSet.GetValue:1779:1 A) |
| WK-SCP0106-0738 | X-ROW | EltrCapaMeasureSet.GetValueFromMeasureTa | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCapaMeasureSet.GetValueFromMeasureTable: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 8 (ACT:EltrCapaMeasureSet.GetValueFromMeasu) |
| WK-SCP0106-0739 | X-ROW | EltrCapaMeasureSet.Init | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCapaMeasureSet.Init: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 16 (ACT:EltrCapaMeasureSet.Init ACT:EltrCapa) |
| WK-SCP0106-0740 | X-ROW | EltrCapaMeasureSet.SetItemValues | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCapaMeasureSet.SetItemValues: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 10 (ACT:EltrCapaMeasureSet.SetItemValues ACT) |
| WK-SCP0106-0741 | X-ROW | EltrCapaMeasureSet.SetSheetEditStatus | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCapaMeasureSet.SetSheetEditStatus: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:EltrCapaMeasureSet.SetSheetEditStatu) |
| WK-SCP0106-0742 | X-ROW | EltrCapaMeasureSet.SetValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCapaMeasureSet.SetValue: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 13 (ACT:EltrCapaMeasureSet.SetValue ACT:Eltr) |
| WK-SCP0106-0743 | X-ROW | EltrCapaMeasureSetLine..ctor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCapaMeasureSetLine..ctor: 진입점 집계 3검사 — NOT_RUN:2 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:EltrCapaMeasureSetLine..ctor:2423:1 ) |
| WK-SCP0106-0744 | X-ROW | EltrCapaMeasureSetLine.Init | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCapaMeasureSetLine.Init: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 21 (ACT:EltrCapaMeasureSetLine.Init ACT:Eltr) |
| WK-SCP0106-0745 | X-ROW | EltrCapaMeasureSetLine.InitLineInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCapaMeasureSetLine.InitLineInfo: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 14 (ACT:EltrCapaMeasureSetLine.InitLineInfo ) |
| WK-SCP0106-0746 | X-ROW | EltrCapaMeasureSetLine.PROD_CAPA_D | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCapaMeasureSetLine.PROD_CAPA_D: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 7 (ACT:EltrCapaMeasureSetLine.PROD_CAPA_D A) |
| WK-SCP0106-0747 | X-ROW | EltrCapaMeasureSetLine.Refresh | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCapaMeasureSetLine.Refresh: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 10 (ACT:EltrCapaMeasureSetLine.Refresh ACT:E) |
| WK-SCP0106-0748 | X-ROW | EltrCurrentCapaMeasureSet..ctor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCurrentCapaMeasureSet..ctor: 진입점 집계 2검사 — NOPATH:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 9 (ACT:EltrCurrentCapaMeasureSet..ctor:1361) |
| WK-SCP0106-0749 | X-ROW | EltrCurrentCapaMeasureSet.ApplyToSheet | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCurrentCapaMeasureSet.ApplyToSheet: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 8 (ACT:EltrCurrentCapaMeasureSet.ApplyToShe) |
| WK-SCP0106-0750 | X-ROW | EltrCurrentCapaMeasureSet.ApplyToSheetOn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCurrentCapaMeasureSet.ApplyToSheetOnlyEditMode: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:EltrCurrentCapaMeasureSet.ApplyToShe) |
| WK-SCP0106-0751 | X-ROW | EltrCurrentCapaMeasureSet.ApplyToSheetOn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCurrentCapaMeasureSet.ApplyToSheetOnlyEditMode: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 19 (ACT:EltrCurrentCapaMeasureSet.ApplyToShe) |
| WK-SCP0106-0752 | X-ROW | EltrCurrentCapaMeasureSet.GetBaseColumnI | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCurrentCapaMeasureSet.GetBaseColumnIndex: 진입점 집계 3검사 — NOPATH:1 · TODO:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:EltrCurrentCapaMeasureSet.GetBaseCol) |
| WK-SCP0106-0753 | X-ROW | EltrCurrentCapaMeasureSet.GetDayCount | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCurrentCapaMeasureSet.GetDayCount: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:EltrCurrentCapaMeasureSet.GetDayCoun) |
| WK-SCP0106-0754 | X-ROW | EltrCurrentCapaMeasureSet.GetIGofTable | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCurrentCapaMeasureSet.GetIGofTable: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:EltrCurrentCapaMeasureSet.GetIGofTab) |
| WK-SCP0106-0755 | X-ROW | EltrCurrentCapaMeasureSet.GetItemPPMs | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCurrentCapaMeasureSet.GetItemPPMs: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 12 (ACT:EltrCurrentCapaMeasureSet.GetItemPPM) |
| WK-SCP0106-0756 | X-ROW | EltrCurrentCapaMeasureSet.GetItemValues | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCurrentCapaMeasureSet.GetItemValues: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 10 (ACT:EltrCurrentCapaMeasureSet.GetItemVal) |
| WK-SCP0106-0757 | X-ROW | EltrCurrentCapaMeasureSet.GetLossColumnI | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCurrentCapaMeasureSet.GetLossColumnIndex: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 9 (ACT:EltrCurrentCapaMeasureSet.GetLossCol) |
| WK-SCP0106-0758 | X-ROW | EltrCurrentCapaMeasureSet.GetMeasureInde | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCurrentCapaMeasureSet.GetMeasureIndexOfTable: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 8 (ACT:EltrCurrentCapaMeasureSet.GetMeasure) |
| WK-SCP0106-0759 | X-ROW | EltrCurrentCapaMeasureSet.GetMonthList | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCurrentCapaMeasureSet.GetMonthList: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:EltrCurrentCapaMeasureSet.GetMonthLi) |
| WK-SCP0106-0760 | X-ROW | EltrCurrentCapaMeasureSet.GetPlanColumnI | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCurrentCapaMeasureSet.GetPlanColumnIndex: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 9 (ACT:EltrCurrentCapaMeasureSet.GetPlanCol) |
| WK-SCP0106-0761 | X-ROW | EltrCurrentCapaMeasureSet.GetResultColum | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCurrentCapaMeasureSet.GetResultColumnIndex: 진입점 집계 3검사 — NOPATH:1 · TODO:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:EltrCurrentCapaMeasureSet.GetResultC) |
| WK-SCP0106-0762 | X-ROW | EltrCurrentCapaMeasureSet.GetRowIndexOfM | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCurrentCapaMeasureSet.GetRowIndexOfMeasure: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 14 (ACT:EltrCurrentCapaMeasureSet.GetRowInde) |
| WK-SCP0106-0763 | X-ROW | EltrCurrentCapaMeasureSet.GetValueFromDa | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCurrentCapaMeasureSet.GetValueFromDayCntTableB: 진입점 집계 23검사 — NOPATH:11 · TODO:11 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 12 (ACT:EltrCurrentCapaMeasureSet.GetValueFr) |
| WK-SCP0106-0764 | X-ROW | EltrCurrentCapaMeasureSet.GetValueFromMe | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCurrentCapaMeasureSet.GetValueFromMeasureTable: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 8 (ACT:EltrCurrentCapaMeasureSet.GetValueFr) |
| WK-SCP0106-0765 | X-ROW | EltrCurrentCapaMeasureSet.Init | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCurrentCapaMeasureSet.Init: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 21 (ACT:EltrCurrentCapaMeasureSet.Init ACT:E) |
| WK-SCP0106-0766 | X-ROW | EltrCurrentCapaMeasureSet.InitLineInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCurrentCapaMeasureSet.InitLineInfo: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 14 (ACT:EltrCurrentCapaMeasureSet.InitLineIn) |
| WK-SCP0106-0767 | X-ROW | EltrCurrentCapaMeasureSet.RecalcSelf | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCurrentCapaMeasureSet.RecalcSelf: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 8 (ACT:EltrCurrentCapaMeasureSet.RecalcSelf) |
| WK-SCP0106-0768 | X-ROW | EltrCurrentCapaMeasureSet.SetItemValues | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCurrentCapaMeasureSet.SetItemValues: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 10 (ACT:EltrCurrentCapaMeasureSet.SetItemVal) |
| WK-SCP0106-0769 | X-ROW | EltrCurrentCapaMeasureSet.recalcLD_RT | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCurrentCapaMeasureSet.recalcLD_RT: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:EltrCurrentCapaMeasureSet.recalcLD_R) |
| WK-SCP0106-0770 | X-ROW | EltrCurrentCapaMeasureSet.recalcOP_RT | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCurrentCapaMeasureSet.recalcOP_RT: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:EltrCurrentCapaMeasureSet.recalcOP_R) |
| WK-SCP0106-0771 | X-ROW | EltrCurrentCapaMeasureSet.recalcPROD_CAP | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCurrentCapaMeasureSet.recalcPROD_CAPA_D: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:EltrCurrentCapaMeasureSet.recalcPROD) |
| WK-SCP0106-0772 | X-ROW | EltrCurrentCapaMeasureSet.recalcPROD_CAP | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCurrentCapaMeasureSet.recalcPROD_CAPA_M: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:EltrCurrentCapaMeasureSet.recalcPROD) |
| WK-SCP0106-0773 | X-ROW | EltrCurrentCapaMeasureSet.recalcPROD_OP_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCurrentCapaMeasureSet.recalcPROD_OP_RT: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:EltrCurrentCapaMeasureSet.recalcPROD) |
| WK-SCP0106-0774 | X-ROW | EltrCurrentCapaMeasureSet.recalcTEEP | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCurrentCapaMeasureSet.recalcTEEP: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:EltrCurrentCapaMeasureSet.recalcTEEP) |
| WK-SCP0106-0775 | X-ROW | EltrCurrentCapaMeasureSet.recalcTHRY_CAP | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCurrentCapaMeasureSet.recalcTHRY_CAPA_D: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:EltrCurrentCapaMeasureSet.recalcTHRY) |
| WK-SCP0106-0776 | X-ROW | EltrCurrentCapaMeasureSet.recalcWT_RT | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — EltrCurrentCapaMeasureSet.recalcWT_RT: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:EltrCurrentCapaMeasureSet.recalcWT_R) |
| WK-SCP0106-0777 | X-ROW | SCP0106_CAPA_Loss_Plan.AfterFindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.AfterFindData: 진입점 집계 2검사 — NOPATH:2 (미실행 검사가 남아 판정필요) |  | 26 (ACT:SCP0106_CAPA_Loss_Plan.AfterFindData) |
| WK-SCP0106-0778 | X-ROW | SCP0106_CAPA_Loss_Plan.AfterSaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.AfterSaveData: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SCP0106_CAPA_Loss_Plan.AfterSaveData) |
| WK-SCP0106-0779 | X-ROW | SCP0106_CAPA_Loss_Plan.BeforeFindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.BeforeFindData: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0106_CAPA_Loss_Plan.BeforeFindDat) |
| WK-SCP0106-0780 | X-ROW | SCP0106_CAPA_Loss_Plan.ChangeColumnNameT | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.ChangeColumnNameToCodeName: 진입점 동작 재현 시나리오 필요 — 문장 종류 DATA_OP/ENTRY/GRID_SET, 연결된 요소 검사 없음 |  | 5 (ACT:SCP0106_CAPA_Loss_Plan.ChangeColumnN) |
| WK-SCP0106-0781 | X-ROW | SCP0106_CAPA_Loss_Plan.CheckChangedValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.CheckChangedValues: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/DATA_OP/ENTRY/EXPR/FLOW/LOCAL/RETURN, 연 |  | 18 (ACT:SCP0106_CAPA_Loss_Plan.CheckChangedV) |
| WK-SCP0106-0782 | X-ROW | SCP0106_CAPA_Loss_Plan.ClearUsrCheckedLi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.ClearUsrCheckedList: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/LIST_REBIND/STATE_RESET, 연결된 요소  |  | 4 (ACT:SCP0106_CAPA_Loss_Plan.ClearUsrCheck) |
| WK-SCP0106-0783 | X-ROW | SCP0106_CAPA_Loss_Plan.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.CreateSpread) |
| WK-SCP0106-0784 | X-ROW | SCP0106_CAPA_Loss_Plan.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.FindButton: 진입점 집계 4검사 — NOPATH:2 · NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.FindButton AC) |
| WK-SCP0106-0785 | X-ROW | SCP0106_CAPA_Loss_Plan.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.FindData: 진입점 집계 4검사 — NOPATH:2 · NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.FindData) |
| WK-SCP0106-0786 | X-ROW | SCP0106_CAPA_Loss_Plan.FindDataMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.FindDataMain: 진입점 집계 5검사 — NOPATH:3 · NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.FindDataMain) |
| WK-SCP0106-0787 | X-ROW | SCP0106_CAPA_Loss_Plan.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.Form_Load) |
| WK-SCP0106-0788 | X-ROW | SCP0106_CAPA_Loss_Plan.GetCalcAssemblyRt | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.GetCalcAssemblyRt: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.GetCalcAssemb) |
| WK-SCP0106-0789 | X-ROW | SCP0106_CAPA_Loss_Plan.GetCalcEltrRt | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.GetCalcEltrRt: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.GetCalcEltrRt) |
| WK-SCP0106-0790 | X-ROW | SCP0106_CAPA_Loss_Plan.GetCalcRt | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.GetCalcRt: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.GetCalcRt) |
| WK-SCP0106-0791 | X-ROW | SCP0106_CAPA_Loss_Plan.GetCurrSheetValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.GetCurrSheetValue: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.GetCurrSheetV) |
| WK-SCP0106-0792 | X-ROW | SCP0106_CAPA_Loss_Plan.GetMeasureIdx | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.GetMeasureIdx: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.GetMeasureIdx) |
| WK-SCP0106-0793 | X-ROW | SCP0106_CAPA_Loss_Plan.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.InitControls: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.InitControls:) |
| WK-SCP0106-0794 | X-ROW | SCP0106_CAPA_Loss_Plan.InitDatasAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.InitDatasAll: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.InitDatasAll) |
| WK-SCP0106-0795 | X-ROW | SCP0106_CAPA_Loss_Plan.InitQueryDics | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.InitQueryDics: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.InitQueryDics) |
| WK-SCP0106-0796 | X-ROW | SCP0106_CAPA_Loss_Plan.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.InitSpread AC) |
| WK-SCP0106-0797 | X-ROW | SCP0106_CAPA_Loss_Plan.IsFormationChagne | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.IsFormationChagned: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/EXPR/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 10 (ACT:SCP0106_CAPA_Loss_Plan.IsFormationCh) |
| WK-SCP0106-0798 | X-ROW | SCP0106_CAPA_Loss_Plan.IsGoal | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.IsGoal: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 5 (ACT:SCP0106_CAPA_Loss_Plan.IsGoal ACT:SC) |
| WK-SCP0106-0799 | X-ROW | SCP0106_CAPA_Loss_Plan.IsLockClipboardRa | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.IsLockClipboardRange: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/ENTRY/LOCAL/RETURN, 연결된 요소 검 |  | 9 (ACT:SCP0106_CAPA_Loss_Plan.IsLockClipboa) |
| WK-SCP0106-0800 | X-ROW | SCP0106_CAPA_Loss_Plan.MergeKeyColumns | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.MergeKeyColumns: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/DATA_OP/ENTRY/EXPR/GRID_INIT/LOCA |  | 14 (ACT:SCP0106_CAPA_Loss_Plan.MergeKeyColum) |
| WK-SCP0106-0801 | X-ROW | SCP0106_CAPA_Loss_Plan.RecalcSheetLossCo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.RecalcSheetLossColumnAllAss: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/ENTRY/EXPR/LOCAL/RETU |  | 16 (ACT:SCP0106_CAPA_Loss_Plan.RecalcSheetLo) |
| WK-SCP0106-0802 | X-ROW | SCP0106_CAPA_Loss_Plan.RecalcSheetLossCo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.RecalcSheetLossColumnAllElt: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/ENTRY/EXPR/LOCAL/RETU |  | 16 (ACT:SCP0106_CAPA_Loss_Plan.RecalcSheetLo) |
| WK-SCP0106-0803 | X-ROW | SCP0106_CAPA_Loss_Plan.RecalcSheetPlanCo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.RecalcSheetPlanColumnAllAss: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/CALL_LOCAL/DATA_OP/EN |  | 27 (ACT:SCP0106_CAPA_Loss_Plan.RecalcSheetPl) |
| WK-SCP0106-0804 | X-ROW | SCP0106_CAPA_Loss_Plan.RecalcSheetPlanCo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.RecalcSheetPlanColumnAllElt: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/CALL_LOCAL/DATA_OP/EN |  | 27 (ACT:SCP0106_CAPA_Loss_Plan.RecalcSheetPl) |
| WK-SCP0106-0805 | X-ROW | SCP0106_CAPA_Loss_Plan.RecalcSheetPlanCo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.RecalcSheetPlanColumnOneAss: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY/EXPR/LOCAL/ |  | 38 (ACT:SCP0106_CAPA_Loss_Plan.RecalcSheetPl) |
| WK-SCP0106-0806 | X-ROW | SCP0106_CAPA_Loss_Plan.RecalcSheetPlanCo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.RecalcSheetPlanColumnOneElt: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY/EXPR/LOCAL/ |  | 38 (ACT:SCP0106_CAPA_Loss_Plan.RecalcSheetPl) |
| WK-SCP0106-0807 | X-ROW | SCP0106_CAPA_Loss_Plan.RecalcSheetSelfCu | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.RecalcSheetSelfCurrent: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0106_CAPA_Loss_Plan.RecalcSheetSe) |
| WK-SCP0106-0808 | X-ROW | SCP0106_CAPA_Loss_Plan.RecalcSheetSelfCu | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.RecalcSheetSelfCurrentAssem: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY/EXPR/FLAG,  |  | 36 (ACT:SCP0106_CAPA_Loss_Plan.RecalcSheetSe) |
| WK-SCP0106-0809 | X-ROW | SCP0106_CAPA_Loss_Plan.RecalcSheetSelfCu | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.RecalcSheetSelfCurrentEltr: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY/EXPR/FLAG, 연 |  | 36 (ACT:SCP0106_CAPA_Loss_Plan.RecalcSheetSe) |
| WK-SCP0106-0810 | X-ROW | SCP0106_CAPA_Loss_Plan.RecalcSheetSelfLi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.RecalcSheetSelfLine: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0106_CAPA_Loss_Plan.RecalcSheetSe) |
| WK-SCP0106-0811 | X-ROW | SCP0106_CAPA_Loss_Plan.RecalcSheetSelfLi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.RecalcSheetSelfLineAssembly: 진입점 집계 2검사 — NOT_RUN:1 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0106_CAPA_Loss_Plan.RecalcSheetSe) |
| WK-SCP0106-0812 | X-ROW | SCP0106_CAPA_Loss_Plan.RecalcSheetSelfLi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.RecalcSheetSelfLineEltr: 진입점 집계 2검사 — NOT_RUN:1 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0106_CAPA_Loss_Plan.RecalcSheetSe) |
| WK-SCP0106-0813 | X-ROW | SCP0106_CAPA_Loss_Plan.RefreshAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.RefreshAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 7 (ACT:SCP0106_CAPA_Loss_Plan.RefreshAll AC) |
| WK-SCP0106-0814 | X-ROW | SCP0106_CAPA_Loss_Plan.RefreshAllPre | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.RefreshAllPre: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 8 (ACT:SCP0106_CAPA_Loss_Plan.RefreshAllPre) |
| WK-SCP0106-0815 | X-ROW | SCP0106_CAPA_Loss_Plan.RefreshColumnsVis | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.RefreshColumnsVisible: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/DATA_OP/ENTRY/EXPR/GRID_SET |  | 17 (ACT:SCP0106_CAPA_Loss_Plan.RefreshColumn) |
| WK-SCP0106-0816 | X-ROW | SCP0106_CAPA_Loss_Plan.RefreshDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.RefreshDivision: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.RefreshDivisi) |
| WK-SCP0106-0817 | X-ROW | SCP0106_CAPA_Loss_Plan.RefreshElectrodeT | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.RefreshElectrodeType: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SCP0106_CAPA_Loss_Plan.RefreshElectr) |
| WK-SCP0106-0818 | X-ROW | SCP0106_CAPA_Loss_Plan.RefreshElectrodeT | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.RefreshElectrodeTypeAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/DATA_OP/ENTRY, 연결된 요소 |  | 5 (ACT:SCP0106_CAPA_Loss_Plan.RefreshElectr) |
| WK-SCP0106-0819 | X-ROW | SCP0106_CAPA_Loss_Plan.RefreshFactory | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.RefreshFactory: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0106_CAPA_Loss_Plan.RefreshFactor) |
| WK-SCP0106-0820 | X-ROW | SCP0106_CAPA_Loss_Plan.RefreshFactoryAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.RefreshFactoryAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0106_CAPA_Loss_Plan.RefreshFactor) |
| WK-SCP0106-0821 | X-ROW | SCP0106_CAPA_Loss_Plan.RefreshLine | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.RefreshLine: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 35 (ACT:SCP0106_CAPA_Loss_Plan.RefreshLine A) |
| WK-SCP0106-0822 | X-ROW | SCP0106_CAPA_Loss_Plan.RefreshLineAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.RefreshLineAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0106_CAPA_Loss_Plan.RefreshLineAl) |
| WK-SCP0106-0823 | X-ROW | SCP0106_CAPA_Loss_Plan.RefreshOperation | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.RefreshOperation: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 21 (ACT:SCP0106_CAPA_Loss_Plan.RefreshOperat) |
| WK-SCP0106-0824 | X-ROW | SCP0106_CAPA_Loss_Plan.RefreshOperationA | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.RefreshOperationAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/DATA_OP/ENTRY, 연결된 요소 검사  |  | 5 (ACT:SCP0106_CAPA_Loss_Plan.RefreshOperat) |
| WK-SCP0106-0825 | X-ROW | SCP0106_CAPA_Loss_Plan.RefreshPlanType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.RefreshPlanType: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/VALUE_SET, 연결된 요소 검사 없음 |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.RefreshPlanTy) |
| WK-SCP0106-0826 | X-ROW | SCP0106_CAPA_Loss_Plan.RefreshPlant | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.RefreshPlant: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0106_CAPA_Loss_Plan.RefreshPlant ) |
| WK-SCP0106-0827 | X-ROW | SCP0106_CAPA_Loss_Plan.RefreshPlantAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.RefreshPlantAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0106_CAPA_Loss_Plan.RefreshPlantA) |
| WK-SCP0106-0828 | X-ROW | SCP0106_CAPA_Loss_Plan.RefreshProgressSt | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.RefreshProgressStatus: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 13 (ACT:SCP0106_CAPA_Loss_Plan.RefreshProgre) |
| WK-SCP0106-0829 | X-ROW | SCP0106_CAPA_Loss_Plan.RefreshSheetHeade | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.RefreshSheetHeader: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY/GRID_INIT, 연결된 요소 검사 |  | 6 (ACT:SCP0106_CAPA_Loss_Plan.RefreshSheetH) |
| WK-SCP0106-0830 | X-ROW | SCP0106_CAPA_Loss_Plan.RefreshSheetType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.RefreshSheetType: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/UI_PROP, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0106_CAPA_Loss_Plan.RefreshSheetT) |
| WK-SCP0106-0831 | X-ROW | SCP0106_CAPA_Loss_Plan.RefreshSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.RefreshSite: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0106_CAPA_Loss_Plan.RefreshSite A) |
| WK-SCP0106-0832 | X-ROW | SCP0106_CAPA_Loss_Plan.RefreshSiteAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.RefreshSiteAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0106_CAPA_Loss_Plan.RefreshSiteAl) |
| WK-SCP0106-0833 | X-ROW | SCP0106_CAPA_Loss_Plan.RefreshVersion | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.RefreshVersion: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0106_CAPA_Loss_Plan.RefreshVersio) |
| WK-SCP0106-0834 | X-ROW | SCP0106_CAPA_Loss_Plan.RefreshVersionSeq | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.RefreshVersionSeq: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0106_CAPA_Loss_Plan.RefreshVersio) |
| WK-SCP0106-0835 | X-ROW | SCP0106_CAPA_Loss_Plan.SaveButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.SaveButton: 진입점 집계 4검사 — NOPATH:2 · NOT_RUN:1 · REVIEW:1 |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.SaveButton:26) |
| WK-SCP0106-0836 | X-ROW | SCP0106_CAPA_Loss_Plan.SetEditableMeasur | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetEditableMeasures: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.SetEditableMe) |
| WK-SCP0106-0837 | X-ROW | SCP0106_CAPA_Loss_Plan.SetLockColumns | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetLockColumns: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.SetLockColumn) |
| WK-SCP0106-0838 | X-ROW | SCP0106_CAPA_Loss_Plan.SetLockColumnsAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetLockColumnsAll: 진입점 집계 12검사 — NOT_RUN:10 · REVIEW:2 |  | 5 (ACT:SCP0106_CAPA_Loss_Plan.SetLockColumn) |
| WK-SCP0106-0839 | X-ROW | SCP0106_CAPA_Loss_Plan.SetLockColumnsOne | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetLockColumnsOneRow: 진입점 집계 12검사 — NOT_RUN:10 · REVIEW:2 |  | 4 (ACT:SCP0106_CAPA_Loss_Plan.SetLockColumn) |
| WK-SCP0106-0840 | X-ROW | SCP0106_CAPA_Loss_Plan.SetQueryInfoGet | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetQueryInfoGet: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0106_CAPA_Loss_Plan.SetQueryInfoG) |
| WK-SCP0106-0841 | X-ROW | SCP0106_CAPA_Loss_Plan.SetQueryInfoSaveL | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetQueryInfoSaveLine: 진입점 집계 24검사 — NOT_RUN:22 · REVIEW:2 |  | 4 (ACT:SCP0106_CAPA_Loss_Plan.SetQueryInfoS) |
| WK-SCP0106-0842 | X-ROW | SCP0106_CAPA_Loss_Plan.SetQueryInfoSaveM | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetQueryInfoSaveModel: 진입점 집계 28검사 — NOT_RUN:26 · REVIEW:2 |  | 4 (ACT:SCP0106_CAPA_Loss_Plan.SetQueryInfoS) |
| WK-SCP0106-0843 | X-ROW | SCP0106_CAPA_Loss_Plan.SetSheetMerge | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetSheetMerge: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.SetSheetMerge) |
| WK-SCP0106-0844 | X-ROW | SCP0106_CAPA_Loss_Plan.SetSheetNumericCo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetSheetNumericColumnFormat: 진입점 집계 8검사 — NOT_RUN:8 (미실행 검사가 남아 판정필요) |  | 53 (ACT:SCP0106_CAPA_Loss_Plan.SetSheetNumer) |
| WK-SCP0106-0845 | X-ROW | SCP0106_CAPA_Loss_Plan.SetSheetNumericCo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetSheetNumericColumnFormat: 진입점 집계 8검사 — NOT_RUN:8 (미실행 검사가 남아 판정필요) |  | 53 (ACT:SCP0106_CAPA_Loss_Plan.SetSheetNumer) |
| WK-SCP0106-0846 | X-ROW | SCP0106_CAPA_Loss_Plan.SetSheetRangeValu | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetSheetRangeValue: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.SetSheetRange) |
| WK-SCP0106-0847 | X-ROW | SCP0106_CAPA_Loss_Plan.SetVisibleElectro | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetVisibleElectrodeType: 진입점 집계 4검사 — NOT_RUN:2 · REVIEW:2 |  | 2 (ACT:SCP0106_CAPA_Loss_Plan.SetVisibleEle) |
| WK-SCP0106-0848 | X-ROW | SCP0106_CAPA_Loss_Plan.SetVisibleOperati | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetVisibleOperation: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0106_CAPA_Loss_Plan.SetVisibleOpe) |
| WK-SCP0106-0849 | X-ROW | SCP0106_CAPA_Loss_Plan.SetVisibleSheetCo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.SetVisibleSheetColumns: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.SetVisibleShe) |
| WK-SCP0106-0850 | X-ROW | SCP0106_CAPA_Loss_Plan.ShowItem | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.ShowItem: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/ENTRY/LOCAL/POPUP/RETURN/UI_PROP, 연결된 요소 |  | 12 (ACT:SCP0106_CAPA_Loss_Plan.ShowItem ACT:) |
| WK-SCP0106-0851 | X-ROW | SCP0106_CAPA_Loss_Plan.btnColumn_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.btnColumn_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0106_CAPA_Loss_Plan.btnColumn_Cli) |
| WK-SCP0106-0852 | X-ROW | SCP0106_CAPA_Loss_Plan.btnItem_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.btnItem_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.btnItem_Click) |
| WK-SCP0106-0853 | X-ROW | SCP0106_CAPA_Loss_Plan.cboDivision_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.cboDivision_SelectedIndexCh: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.cboDivision_S) |
| WK-SCP0106-0854 | X-ROW | SCP0106_CAPA_Loss_Plan.cboFromYYYY_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.cboFromYYYY_SelectedIndexCh: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.cboFromYYYY_S) |
| WK-SCP0106-0855 | X-ROW | SCP0106_CAPA_Loss_Plan.cboProgressStatus | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.cboProgressStatus_SelectedI: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.cboProgressSt) |
| WK-SCP0106-0856 | X-ROW | SCP0106_CAPA_Loss_Plan.cboSheetType_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.cboSheetType_SelectedIndexC: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0106_CAPA_Loss_Plan.cboSheetType_) |
| WK-SCP0106-0857 | X-ROW | SCP0106_CAPA_Loss_Plan.cboVersionSeq_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.cboVersionSeq_SelectedIndex: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.cboVersionSeq) |
| WK-SCP0106-0858 | X-ROW | SCP0106_CAPA_Loss_Plan.cboVersion_Select | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.cboVersion_SelectedIndexCha: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.cboVersion_Se) |
| WK-SCP0106-0859 | X-ROW | SCP0106_CAPA_Loss_Plan.chkShowRate_Check | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.chkShowRate_CheckedChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.chkShowRate_C) |
| WK-SCP0106-0860 | X-ROW | SCP0106_CAPA_Loss_Plan.clbFactory_Select | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.clbFactory_SelectedIndexCha: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.clbFactory_Se) |
| WK-SCP0106-0861 | X-ROW | SCP0106_CAPA_Loss_Plan.clbLine_SelectedI | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.clbLine_SelectedIndexChange: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.clbLine_Selec) |
| WK-SCP0106-0862 | X-ROW | SCP0106_CAPA_Loss_Plan.clbOperation_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.clbOperation_SelectedIndexC: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.clbOperation_) |
| WK-SCP0106-0863 | X-ROW | SCP0106_CAPA_Loss_Plan.clbPlant_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.clbPlant_SelectedIndexChang: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.clbPlant_Sele) |
| WK-SCP0106-0864 | X-ROW | SCP0106_CAPA_Loss_Plan.clbSite_SelectedI | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.clbSite_SelectedIndexChange: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.clbSite_Selec) |
| WK-SCP0106-0865 | X-ROW | SCP0106_CAPA_Loss_Plan.getPlanType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.getPlanType: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.getPlanType) |
| WK-SCP0106-0866 | X-ROW | SCP0106_CAPA_Loss_Plan.getShopGroup | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.getShopGroup: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.getShopGroup) |
| WK-SCP0106-0867 | X-ROW | SCP0106_CAPA_Loss_Plan.rgrpDivisionType_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.rgrpDivisionType_SelectedIn: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.rgrpDivisionT) |
| WK-SCP0106-0868 | X-ROW | SCP0106_CAPA_Loss_Plan.spdMain_Clipboard | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.spdMain_ClipboardChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.spdMain_Clipb) |
| WK-SCP0106-0869 | X-ROW | SCP0106_CAPA_Loss_Plan.spdMain_Clipboard | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.spdMain_ClipboardPasting: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/ENTRY/RETURN/UI_PROP,  |  | 9 (ACT:SCP0106_CAPA_Loss_Plan.spdMain_Clipb) |
| WK-SCP0106-0870 | X-ROW | SCP0106_CAPA_Loss_Plan.spdMain_KeyDown | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.spdMain_KeyDown: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/ENTRY/UI_PROP, 연결된 요소 검사 없음 |  | 6 (ACT:SCP0106_CAPA_Loss_Plan.spdMain_KeyDo) |
| WK-SCP0106-0871 | X-ROW | SCP0106_CAPA_Loss_Plan.spdMain_Selection | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0106_CAPA_Loss_Plan.spdMain_SelectionChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0106_CAPA_Loss_Plan.spdMain_Selec) |
| WK-SCP0106-0872 | X-ROW | `hooks/useCapaLossPlanCombos.ts` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `hooks/useCapaLossPlanCombos.ts`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`hooks/useCapaLossPlanCombos.ts`) |
| WK-SCP0106-0873 | X-ROW | `utils/capaLossPlan.combos.ts` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `utils/capaLossPlan.combos.ts`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`utils/capaLossPlan.combos.ts`) |
| WK-SCP0106-0874 | X-ROW | `utils/capaLossPlan.dateColumns.ts` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `utils/capaLossPlan.dateColumns.ts`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`utils/capaLossPlan.dateColumns.ts`) |
| WK-SCP0106-0875 | X-ROW | `utils/capaLossPlan.recalc.ts` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `utils/capaLossPlan.recalc.ts`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`utils/capaLossPlan.recalc.ts`) |
| WK-SCP0106-0876 | X-ROW | extractionLimits | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — extractionLimits: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (extractionLimits) |
| WK-SCP0106-0877 | X-ROW | filterCalls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — filterCalls: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (filterCalls) |
| WK-SCP0106-0878 | X-ROW | gridColumns | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — gridColumns: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (gridColumns) |
| WK-SCP0106-0879 | G5 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — COMMON:UC-06: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0106-0880 | G5 | D00-4e-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-4e-001: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-001) |
| WK-SCP0106-0881 | G5 | D00-4e-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-4e-002: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-002) |
| WK-SCP0106-0882 | G5 | MODAL:CapaLossPlanColumnModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MODAL:CapaLossPlanColumnModal: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:CapaLossPlanColumnModal) |
| WK-SCP0106-0883 | G5 | entryPoints | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — entryPoints: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (entryPoints) |
| WK-SCP0106-0884 | G5 | popups | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — popups: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (popups) |
| WK-SCP0106-0885 | G5 | spCalls | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — spCalls: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (spCalls) |
| WK-SCP0106-0886 | H6 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — COMMON:UC-06: 행 집계 — H6 3요소: NOPATH:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0106-0887 | H6 | D00-4e-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-4e-001: 행 집계 — H6 3요소: NOPATH:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-001) |
| WK-SCP0106-0888 | H6 | D00-4e-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-4e-002: 행 집계 — H6 3요소: NOPATH:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-002) |
| WK-SCP0106-0889 | H6 | MODAL:CapaLossPlanColumnModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MODAL:CapaLossPlanColumnModal: 행 집계 — H6 3요소: NOPATH:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:CapaLossPlanColumnModal) |
| WK-SCP0106-0890 | H6 | entryPoints | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — entryPoints: 행 집계 — H6 3요소: NOPATH:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (entryPoints) |
| WK-SCP0106-0891 | H6 | popups | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — popups: 행 집계 — H6 3요소: NOPATH:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (popups) |
| WK-SCP0106-0892 | H6 | spCalls | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — spCalls: 행 집계 — H6 3요소: NOPATH:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (spCalls) |
| WK-SCP0106-0893 | M3 | D00-4e-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M3 기대값 확정 — D00-4e-001: 행 집계 — M3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-001) |
| WK-SCP0106-0894 | M3 | D00-4e-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M3 기대값 확정 — D00-4e-002: 행 집계 — M3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-002) |
| WK-SCP0106-0895 | M4 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — COMMON:UC-06: 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0106-0896 | M4 | D00-4e-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-4e-001: 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-001) |
| WK-SCP0106-0897 | M4 | D00-4e-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-4e-002: 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-002) |
| WK-SCP0106-0898 | M4 | MODAL:CapaLossPlanColumnModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MODAL:CapaLossPlanColumnModal: 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:CapaLossPlanColumnModal) |
| WK-SCP0106-0899 | M4 | entryPoints | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — entryPoints: 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (entryPoints) |
| WK-SCP0106-0900 | M4 | popups | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — popups: 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (popups) |
| WK-SCP0106-0901 | M4 | spCalls | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — spCalls: 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (spCalls) |
