# 작업 원장 — SCP0107 · 2026-10-26 12:55

> 검사 인스턴스 868건 중 PASS·NA 126건 외 **742건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 20 | 구현 위치 실존 |
| W4 | 검사기 구현 | 25 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 65 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 113 | 실행 → PASS |
| W7 | 기대값 확정 | 519 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 480 · E2E 113 · 하네스 90 · 대조표 59
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 5건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 114 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| X-LOC | GEN |  | 20 |  |  |  |  | 40 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| B3 | COMBO |  |  |  | 25 |  |  | 26 |  |  | 콤보 후보 정렬 = AS-IS |
| B4 | COMBO |  |  |  |  | 25 |  | 26 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| A1 | GEN |  |  |  |  |  |  | 45 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| G1 | GEN |  |  |  |  |  | 11 | 31 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| X-REASON | DESIGN |  |  |  |  |  |  | 39 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| G4 | DESIGN |  |  |  |  | 1 | 11 | 18 |  |  | 조회조건 표시·라벨·활성 |
| G6 | GEN |  |  |  |  |  | 11 | 18 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| C3 | CASCADE |  |  |  |  |  | 8 | 19 |  |  | 연쇄 자동 채움 |
| H2 | DESIGN |  |  |  |  |  | 2 | 24 |  |  | 배경·글자색 규칙 |
| E4 | EDIT |  |  |  |  |  | 16 | 9 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| A5 | DESIGN |  |  |  |  |  | 2 | 18 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| C1 | CASCADE |  |  |  |  |  | 10 | 9 |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| C4 | CASCADE |  |  |  |  |  | 9 | 9 |  |  | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| H5 | DESIGN |  |  |  |  |  | 3 | 13 |  |  | 라벨 명칭 |
| G5 | POPUP |  |  |  |  | 3 |  | 12 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 3 |  | 12 |  |  | 팝업 표준·열림 |
| M4 | POPUP |  |  |  |  |  | 3 | 12 |  |  | 팝업 선택값 반영 |
| C2 | CASCADE |  |  |  |  |  | 1 | 11 |  |  | 그리드 셀 cascade 후보 |
| F4 | DB |  |  |  |  |  | 6 | 5 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| A6 | GEN |  |  |  |  |  | 5 | 5 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| B1 | COMBO |  |  |  |  | 9 |  |  |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 9 |  |  |  |  | 콤보 후보 중복 없음 |
| B6 | COMBO |  |  |  |  | 9 |  |  |  |  | ALL 옵션·다중선택 사양 |
| DB-SYN | DB |  |  |  |  | 5 |  | 3 |  |  | BE 계정 시노님·권한·대상 객체 |
| M3 | POPUP |  |  |  |  |  | 3 | 1 |  |  | 팝업 내부 기능(조회·CRUD) |
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

## W2 구현 위치 확인 (20)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0107-0001 | X-LOC | 13 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (13) |
| WK-SCP0107-0002 | X-LOC | 14 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (14) |
| WK-SCP0107-0003 | X-LOC | 22 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (22) |
| WK-SCP0107-0004 | X-LOC | 24 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (24) |
| WK-SCP0107-0005 | X-LOC | 25 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (25) |
| WK-SCP0107-0006 | X-LOC | 26 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (26) |
| WK-SCP0107-0007 | X-LOC | 27 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (27) |
| WK-SCP0107-0008 | X-LOC | 28 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (28) |
| WK-SCP0107-0009 | X-LOC | 29 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (29) |
| WK-SCP0107-0010 | X-LOC | 2~5 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (2~5) |
| WK-SCP0107-0011 | X-LOC | 30 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (30) |
| WK-SCP0107-0012 | X-LOC | 31 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (31) |
| WK-SCP0107-0013 | X-LOC | 34 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (34) |
| WK-SCP0107-0014 | X-LOC | 35 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (35) |
| WK-SCP0107-0015 | X-LOC | 37 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (37) |
| WK-SCP0107-0016 | X-LOC | 7 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: useCustomQueryClient.ts 없음 |  | 1 (7) |
| WK-SCP0107-0017 | X-LOC | 9~13 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (9~13) |
| WK-SCP0107-0018 | X-LOC | `SCM002_CAPAColumnPopup("SCP0107", _divi | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`SCM002_CAPAColumnPopup("SCP0107", _divi) |
| WK-SCP0107-0019 | X-LOC | `SCP.SCP0104_GET_SPREAD_TITLE` (`GetSpdT | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`SCP.SCP0104_GET_SPREAD_TITLE` (`GetSpdT) |
| WK-SCP0107-0020 | X-LOC | `SCP.SCP0107_GET_CAPA_TEEP_{ASSEMBLY\ | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`SCP.SCP0107_GET_CAPA_TEEP_{ASSEMBLY\) |

## W4 검사기 구현 (25)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0107-0021 | B3 | BASE_QTY | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 BASE_QTY | 있음(SHEET_COLUMNS) | 1 (ACT:SCP0107_CAPA_TEEP_Report.GetSpdTitle) |
| WK-SCP0107-0022 | B3 | BIZ_QTY | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 BIZ_QTY | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0107_CAPA_TEEP_Report.GetSpdTitle) |
| WK-SCP0107-0023 | B3 | COMPANY_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 COMPANY_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0107_CAPA_TEEP_Report.getCurrComp) |
| WK-SCP0107-0024 | B3 | DIVISION_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 DIVISION_ID | 있음(SHEET_COLUMNS) | 4 (ACT:SCP0107_CAPA_TEEP_Report.GetCurrVers) |
| WK-SCP0107-0025 | B3 | ELTR_LN_TP_CD | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 ELTR_LN_TP_CD | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0107_CAPA_TEEP_Report.getCurrElec) |
| WK-SCP0107-0026 | B3 | FACTORY_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 FACTORY_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0107_CAPA_TEEP_Report.getCurrFact) |
| WK-SCP0107-0027 | B3 | LINE_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 LINE_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0107_CAPA_TEEP_Report.getCurrLine) |
| WK-SCP0107-0028 | B3 | MEASURE | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 MEASURE | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0107_CAPA_TEEP_Report.getCurrMeas) |
| WK-SCP0107-0029 | B3 | NICK_NAME | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 NICK_NAME | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0107_CAPA_TEEP_Report.getCurrNick) |
| WK-SCP0107-0030 | B3 | OPERATION_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 OPERATION_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0107_CAPA_TEEP_Report.getCurrOper) |
| WK-SCP0107-0031 | B3 | PFRSLT_QTY | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 PFRSLT_QTY | 있음(SHEET_COLUMNS) | 1 (ACT:SCP0107_CAPA_TEEP_Report.GetSpdTitle) |
| WK-SCP0107-0032 | B3 | PLANT_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 PLANT_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0107_CAPA_TEEP_Report.getCurrPlan) |
| WK-SCP0107-0033 | B3 | PRE_QTY | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 PRE_QTY | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0107_CAPA_TEEP_Report.GetSpdTitle) |
| WK-SCP0107-0034 | B3 | SITE_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 SITE_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0107_CAPA_TEEP_Report.getCurrSite) |
| WK-SCP0107-0035 | B3 | VER_SEQ | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 VER_SEQ | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0107_CAPA_TEEP_Report.GetCurrVers) |
| WK-SCP0107-0036 | B3 | cboVersion / Plan Month / Version / Ver. | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboVersion / Plan Month / Version / Ver. | 있음(FE 소스) | 3 (ACT:SCP0107_CAPA_TEEP_Report.getVersion ) |
| WK-SCP0107-0037 | B3 | cboVersionSeq / Version / Version Seq /  | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboVersionSeq / Version / Version Seq / Ver. | 있음(FE 소스) | 2 (ACT:SCP0107_CAPA_TEEP_Report.getVersionS) |
| WK-SCP0107-0038 | B3 | clbDivision / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbDivision / Division | 있음(FE 소스) | 2 (ACT:SCP0107_CAPA_TEEP_Report.getDivision) |
| WK-SCP0107-0039 | B3 | clbElectrodeType / Line Type / Electrode | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbElectrodeType / Line Type / Electrode Type | 있음(FE 소스) | 2 (ACT:SCP0107_CAPA_TEEP_Report.getElectrod) |
| WK-SCP0107-0040 | B3 | clbFactory / Building / Factory | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbFactory / Building / Factory | 있음(FE 소스) | 2 (ACT:SCP0107_CAPA_TEEP_Report.getFactory ) |
| WK-SCP0107-0041 | B3 | clbLine / Line | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbLine / Line | 있음(FE 소스) | 2 (ACT:SCP0107_CAPA_TEEP_Report.getLine ACT) |
| WK-SCP0107-0042 | B3 | clbOperation / Operation | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbOperation / Operation | 있음(FE 소스) | 2 (ACT:SCP0107_CAPA_TEEP_Report.getOperatio) |
| WK-SCP0107-0043 | B3 | clbPlant / Plant | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbPlant / Plant | 있음(FE 소스) | 2 (ACT:SCP0107_CAPA_TEEP_Report.getPlant AC) |
| WK-SCP0107-0044 | B3 | clbSite / Site | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbSite / Site | 있음(FE 소스) | 2 (ACT:SCP0107_CAPA_TEEP_Report.getSite ACT) |
| WK-SCP0107-0045 | B3 | rgrpDivisionType / Division Type | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 rgrpDivisionType / Division Type | 있음(FE 소스) | 4 (ACT:SCP0107_CAPA_TEEP_Report.GetSpdTitle) |

## W5 검사기 연결 (65)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0107-0046 | B1 | cboVersion / Plan Month / Version / Ver. | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboVersion / Plan Month / Version / Ver. | 있음(FE 소스) | 1 (D00-1-006) |
| WK-SCP0107-0047 | B1 | cboVersionSeq / Version / Version Seq /  | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboVersionSeq / Version / Version Seq / Ver. | 있음(FE 소스) | 1 (D00-1-007) |
| WK-SCP0107-0048 | B1 | clbDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbDivision / Division | 있음(FE 소스) | 1 (D00-1-008) |
| WK-SCP0107-0049 | B1 | clbElectrodeType / Line Type / Electrode | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbElectrodeType / Line Type / Electrode Type | 있음(FE 소스) | 1 (D00-1-009) |
| WK-SCP0107-0050 | B1 | clbFactory / Building / Factory | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbFactory / Building / Factory | 있음(FE 소스) | 1 (D00-1-010) |
| WK-SCP0107-0051 | B1 | clbLine / Line | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbLine / Line | 있음(FE 소스) | 1 (D00-1-011) |
| WK-SCP0107-0052 | B1 | clbOperation / Operation | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbOperation / Operation | 있음(FE 소스) | 1 (D00-1-012) |
| WK-SCP0107-0053 | B1 | clbPlant / Plant | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbPlant / Plant | 있음(FE 소스) | 1 (D00-1-013) |
| WK-SCP0107-0054 | B1 | clbSite / Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbSite / Site | 있음(FE 소스) | 1 (D00-1-014) |
| WK-SCP0107-0055 | B2 | cboVersion / Plan Month / Version / Ver. | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboVersion / Plan Month / Version / Ver. | 있음(FE 소스) | 1 (D00-1-006) |
| WK-SCP0107-0056 | B2 | cboVersionSeq / Version / Version Seq /  | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboVersionSeq / Version / Version Seq / Ver. | 있음(FE 소스) | 1 (D00-1-007) |
| WK-SCP0107-0057 | B2 | clbDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbDivision / Division | 있음(FE 소스) | 1 (D00-1-008) |
| WK-SCP0107-0058 | B2 | clbElectrodeType / Line Type / Electrode | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbElectrodeType / Line Type / Electrode Type | 있음(FE 소스) | 1 (D00-1-009) |
| WK-SCP0107-0059 | B2 | clbFactory / Building / Factory | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbFactory / Building / Factory | 있음(FE 소스) | 1 (D00-1-010) |
| WK-SCP0107-0060 | B2 | clbLine / Line | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbLine / Line | 있음(FE 소스) | 1 (D00-1-011) |
| WK-SCP0107-0061 | B2 | clbOperation / Operation | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbOperation / Operation | 있음(FE 소스) | 1 (D00-1-012) |
| WK-SCP0107-0062 | B2 | clbPlant / Plant | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbPlant / Plant | 있음(FE 소스) | 1 (D00-1-013) |
| WK-SCP0107-0063 | B2 | clbSite / Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbSite / Site | 있음(FE 소스) | 1 (D00-1-014) |
| WK-SCP0107-0064 | B4 | BASE_QTY | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL BASE_QTY | 있음(SHEET_COLUMNS) | 1 (ACT:SCP0107_CAPA_TEEP_Report.GetSpdTitle) |
| WK-SCP0107-0065 | B4 | BIZ_QTY | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL BIZ_QTY | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0107_CAPA_TEEP_Report.GetSpdTitle) |
| WK-SCP0107-0066 | B4 | COMPANY_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL COMPANY_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0107_CAPA_TEEP_Report.getCurrComp) |
| WK-SCP0107-0067 | B4 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 4 (ACT:SCP0107_CAPA_TEEP_Report.GetCurrVers) |
| WK-SCP0107-0068 | B4 | ELTR_LN_TP_CD | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL ELTR_LN_TP_CD | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0107_CAPA_TEEP_Report.getCurrElec) |
| WK-SCP0107-0069 | B4 | FACTORY_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL FACTORY_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0107_CAPA_TEEP_Report.getCurrFact) |
| WK-SCP0107-0070 | B4 | LINE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL LINE_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0107_CAPA_TEEP_Report.getCurrLine) |
| WK-SCP0107-0071 | B4 | MEASURE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL MEASURE | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0107_CAPA_TEEP_Report.getCurrMeas) |
| WK-SCP0107-0072 | B4 | NICK_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL NICK_NAME | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0107_CAPA_TEEP_Report.getCurrNick) |
| WK-SCP0107-0073 | B4 | OPERATION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL OPERATION_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0107_CAPA_TEEP_Report.getCurrOper) |
| WK-SCP0107-0074 | B4 | PFRSLT_QTY | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL PFRSLT_QTY | 있음(SHEET_COLUMNS) | 1 (ACT:SCP0107_CAPA_TEEP_Report.GetSpdTitle) |
| WK-SCP0107-0075 | B4 | PLANT_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL PLANT_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0107_CAPA_TEEP_Report.getCurrPlan) |
| WK-SCP0107-0076 | B4 | PRE_QTY | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL PRE_QTY | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0107_CAPA_TEEP_Report.GetSpdTitle) |
| WK-SCP0107-0077 | B4 | SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL SITE_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0107_CAPA_TEEP_Report.getCurrSite) |
| WK-SCP0107-0078 | B4 | VER_SEQ | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL VER_SEQ | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0107_CAPA_TEEP_Report.GetCurrVers) |
| WK-SCP0107-0079 | B4 | cboVersion / Plan Month / Version / Ver. | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboVersion / Plan Month / Version / Ver. | 있음(FE 소스) | 4 (D00-1-006 ACT:SCP0107_CAPA_TEEP_Report.g) |
| WK-SCP0107-0080 | B4 | cboVersionSeq / Version / Version Seq /  | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboVersionSeq / Version / Version Seq / Ver. | 있음(FE 소스) | 3 (D00-1-007 ACT:SCP0107_CAPA_TEEP_Report.g) |
| WK-SCP0107-0081 | B4 | clbDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbDivision / Division | 있음(FE 소스) | 3 (D00-1-008 ACT:SCP0107_CAPA_TEEP_Report.g) |
| WK-SCP0107-0082 | B4 | clbElectrodeType / Line Type / Electrode | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbElectrodeType / Line Type / Electrode Type | 있음(FE 소스) | 3 (D00-1-009 ACT:SCP0107_CAPA_TEEP_Report.g) |
| WK-SCP0107-0083 | B4 | clbFactory / Building / Factory | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbFactory / Building / Factory | 있음(FE 소스) | 3 (D00-1-010 ACT:SCP0107_CAPA_TEEP_Report.g) |
| WK-SCP0107-0084 | B4 | clbLine / Line | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbLine / Line | 있음(FE 소스) | 3 (D00-1-011 ACT:SCP0107_CAPA_TEEP_Report.g) |
| WK-SCP0107-0085 | B4 | clbOperation / Operation | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbOperation / Operation | 있음(FE 소스) | 3 (D00-1-012 ACT:SCP0107_CAPA_TEEP_Report.g) |
| WK-SCP0107-0086 | B4 | clbPlant / Plant | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbPlant / Plant | 있음(FE 소스) | 3 (D00-1-013 ACT:SCP0107_CAPA_TEEP_Report.g) |
| WK-SCP0107-0087 | B4 | clbSite / Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbSite / Site | 있음(FE 소스) | 3 (D00-1-014 ACT:SCP0107_CAPA_TEEP_Report.g) |
| WK-SCP0107-0088 | B4 | rgrpDivisionType / Division Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND rgrpDivisionType / Division Type | 있음(FE 소스) | 4 (ACT:SCP0107_CAPA_TEEP_Report.GetSpdTitle) |
| WK-SCP0107-0089 | B6 | cboVersion / Plan Month / Version / Ver. | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboVersion / Plan Month / Version / Ver. | 있음(FE 소스) | 1 (D00-1-006) |
| WK-SCP0107-0090 | B6 | cboVersionSeq / Version / Version Seq /  | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboVersionSeq / Version / Version Seq / Ver. | 있음(FE 소스) | 1 (D00-1-007) |
| WK-SCP0107-0091 | B6 | clbDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbDivision / Division | 있음(FE 소스) | 1 (D00-1-008) |
| WK-SCP0107-0092 | B6 | clbElectrodeType / Line Type / Electrode | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbElectrodeType / Line Type / Electrode Type | 있음(FE 소스) | 1 (D00-1-009) |
| WK-SCP0107-0093 | B6 | clbFactory / Building / Factory | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbFactory / Building / Factory | 있음(FE 소스) | 1 (D00-1-010) |
| WK-SCP0107-0094 | B6 | clbLine / Line | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbLine / Line | 있음(FE 소스) | 1 (D00-1-011) |
| WK-SCP0107-0095 | B6 | clbOperation / Operation | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbOperation / Operation | 있음(FE 소스) | 1 (D00-1-012) |
| WK-SCP0107-0096 | B6 | clbPlant / Plant | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbPlant / Plant | 있음(FE 소스) | 1 (D00-1-013) |
| WK-SCP0107-0097 | B6 | clbSite / Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbSite / Site | 있음(FE 소스) | 1 (D00-1-014) |
| WK-SCP0107-0098 | DB-SYN | P_SCP0107_GET_ASSEMBLY | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SCP0107_GET_ASSEMBLY | 없음(PROC_M 대응 없음) | 1 (`SCP.SCP0107_GET_CAPA_TEEP_{ASSEMBLY\) |
| WK-SCP0107-0099 | DB-SYN | P_SCP0107_TITLE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SCP0107_TITLE | 없음(PROC_M 대응 없음) | 1 (`SCP.SCP0104_GET_SPREAD_TITLE` (`GetSpdT) |
| WK-SCP0107-0100 | DB-SYN | SCM0002_GET_TITLESET_POPUP | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0002_GET_TITLESET_POPUP | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0107_CAPAReportPopup.GetTitleSet:) |
| WK-SCP0107-0101 | DB-SYN | SCP0083_GET_DIO_REPORT_H | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0083_GET_DIO_REPORT_H | 없음(PROC_M 대응 없음) | 4 (`POPUP/SCP0107_CAPAReportPopup.cs`(479행)) |
| WK-SCP0107-0102 | DB-SYN | SCP0107_GET_CAPA_TEEP_ | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0107_GET_CAPA_TEEP_ | 없음(PROC_M 대응 없음) | 1 (`SCP.SCP0107_GET_CAPA_TEEP_{ASSEMBLY\) |
| WK-SCP0107-0103 | G4 | btnColumn | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnColumn | 있음(FE 소스) | 2 (ACT:SCP0107_CAPA_TEEP_Report.InitEvent A) |
| WK-SCP0107-0104 | G03-WIRE | SCP0107 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0107 화면 | 판단불가(대상 단위 SCREEN) | 18 (ACT:SCP0107_CAPAReportPopup..ctor ACT:SC) |
| WK-SCP0107-0105 | G5 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 1 (D00-4c-005) |
| WK-SCP0107-0106 | G5 | OPERATION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL OPERATION_ID | 있음(SHEET_COLUMNS) | 2 (D00-4b-004 D00-4c-005) |
| WK-SCP0107-0107 | G5 | SCP0107_CAPAReportPopup | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 POPUP SCP0107_CAPAReportPopup | 판단불가(대상 단위 POPUP) | 2 (`POPUP/SCP0107_CAPAReportPopup.cs`(479행)) |
| WK-SCP0107-0108 | H6 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 1 (D00-4c-005) |
| WK-SCP0107-0109 | H6 | OPERATION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL OPERATION_ID | 있음(SHEET_COLUMNS) | 2 (D00-4b-004 D00-4c-005) |
| WK-SCP0107-0110 | H6 | SCP0107_CAPAReportPopup | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 POPUP SCP0107_CAPAReportPopup | 판단불가(대상 단위 POPUP) | 2 (`POPUP/SCP0107_CAPAReportPopup.cs`(479행)) |

## W6 검증 실행 (113)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0107-0111 | J2 | SCP0107 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0107 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 39 (34 31 14 13 10 12 2 3 27 24 25 26) |
| WK-SCP0107-0112 | C1 | cboVersion / Plan Month / Version / Ver. | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboVersion / Plan Month / Version / Ver. · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 3 (2~5 D00-2-002 ACT:SCP0107_CAPA_TEEP_Repo) |
| WK-SCP0107-0113 | C1 | cboVersionSeq / Version / Version Seq /  | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboVersionSeq / Version / Version Seq / Ver. · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 3 (2~5 D00-2-003 ACT:SCP0107_CAPA_TEEP_Repo) |
| WK-SCP0107-0114 | C1 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 3 (2~5 D00-2-004 ACT:SCP0107_CAPA_TEEP_Repo) |
| WK-SCP0107-0115 | C1 | clbElectrodeType / Line Type / Electrode | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbElectrodeType / Line Type / Electrode Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.RefreshElec) |
| WK-SCP0107-0116 | C1 | clbFactory / Building / Factory | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbFactory / Building / Factory · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 3 (9~13 D00-2-005 ACT:SCP0107_CAPA_TEEP_Rep) |
| WK-SCP0107-0117 | C1 | clbLine / Line | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbLine / Line · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 3 (9~13 D00-2-006 ACT:SCP0107_CAPA_TEEP_Rep) |
| WK-SCP0107-0118 | C1 | clbOperation / Operation | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbOperation / Operation · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 3 (9~13 D00-2-007 ACT:SCP0107_CAPA_TEEP_Rep) |
| WK-SCP0107-0119 | C1 | clbPlant / Plant | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbPlant / Plant · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 3 (9~13 D00-2-008 ACT:SCP0107_CAPA_TEEP_Rep) |
| WK-SCP0107-0120 | C1 | clbSite / Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbSite / Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-009 ACT:SCP0107_CAPA_TEEP_Report.R) |
| WK-SCP0107-0121 | C1 | rgrpDivisionType / Division Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — rgrpDivisionType / Division Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (D00-2-010) |
| WK-SCP0107-0122 | C2 | VER_SEQ | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — VER_SEQ · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.RefreshVers) |
| WK-SCP0107-0123 | C3 | BASE_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — BASE_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.SetBaseToDa) |
| WK-SCP0107-0124 | C3 | FACTORY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — FACTORY_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.SetVisibleS) |
| WK-SCP0107-0125 | C3 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.SetSheetNum) |
| WK-SCP0107-0126 | C3 | MEASURE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — MEASURE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0107_CAPA_TEEP_Report.Set_Measure) |
| WK-SCP0107-0127 | C3 | PLANT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PLANT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.SetVisibleS) |
| WK-SCP0107-0128 | C3 | SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.SetVisibleS) |
| WK-SCP0107-0129 | C3 | VER_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — VER_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.SetVisibleS) |
| WK-SCP0107-0130 | C3 | VER_SEQ | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — VER_SEQ · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.SetVisibleS) |
| WK-SCP0107-0131 | C4 | cboVersion / Plan Month / Version / Ver. | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboVersion / Plan Month / Version / Ver. · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 2 (2~5 D00-2-002) |
| WK-SCP0107-0132 | C4 | cboVersionSeq / Version / Version Seq /  | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboVersionSeq / Version / Version Seq / Ver. · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 2 (2~5 D00-2-003) |
| WK-SCP0107-0133 | C4 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 2 (2~5 D00-2-004) |
| WK-SCP0107-0134 | C4 | clbFactory / Building / Factory | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — clbFactory / Building / Factory · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 2 (9~13 D00-2-005) |
| WK-SCP0107-0135 | C4 | clbLine / Line | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — clbLine / Line · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 2 (9~13 D00-2-006) |
| WK-SCP0107-0136 | C4 | clbOperation / Operation | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — clbOperation / Operation · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 2 (9~13 D00-2-007) |
| WK-SCP0107-0137 | C4 | clbPlant / Plant | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — clbPlant / Plant · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 2 (9~13 D00-2-008) |
| WK-SCP0107-0138 | C4 | clbSite / Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — clbSite / Site · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-009) |
| WK-SCP0107-0139 | C4 | rgrpDivisionType / Division Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — rgrpDivisionType / Division Type · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-010) |
| WK-SCP0107-0140 | G3 | SCP0107 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0107 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 8 (35 37 22 D00-1-022 D00-1-035 D00-1-037 C) |
| WK-SCP0107-0141 | K-SA | SCP0107 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCP0107 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 6 (35 37 22 D00-1-022 D00-1-035 D00-1-037) |
| WK-SCP0107-0142 | K4 | SCP0107 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0107 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 11 (COMMON:UC-03 COMMON:UC-07 ACT:SCP0107_CA) |
| WK-SCP0107-0143 | F1 | SCP0107 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0107 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 13 (2 Insert/Delete **메시지 재현** ACT:SCP0107_C) |
| WK-SCP0107-0144 | F3 | SCP0107 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F3 실행 — SCP0107 화면 · 검사기 있음(_trace.spec(@trace) W4b 붙여넣기 — Ctrl+C/Ctrl+V 로 셀 값 복사 후 값·연쇄) — 실행 필요: trace |  | 1 (데드 핸들러 3종(`cboSheetType_` / `cboFromYYYY) |
| WK-SCP0107-0145 | F5 | SCP0107 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0107 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 13 (2 Insert/Delete **메시지 재현** ACT:SCP0107_C) |
| WK-SCP0107-0146 | F4 | PKG_SCP0104.P_SCP0104_GET_SPREAD_TITLE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0104.P_SCP0104_GET_SPREAD_TITLE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 3 (`SCP.SCP0104_GET_SPREAD_TITLE` (`GetSpdT) |
| WK-SCP0107-0147 | F4 | P_SCP0107_GET_ASSEMBLY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_SCP0107_GET_ASSEMBLY · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (`SCP.SCP0107_GET_CAPA_TEEP_{ASSEMBLY\) |
| WK-SCP0107-0148 | F4 | P_SCP0107_TITLE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_SCP0107_TITLE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (`SCP.SCP0104_GET_SPREAD_TITLE` (`GetSpdT) |
| WK-SCP0107-0149 | F4 | SCM0002_GET_TITLESET_POPUP | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0002_GET_TITLESET_POPUP · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:SCP0107_CAPAReportPopup.GetTitleSet:) |
| WK-SCP0107-0150 | F4 | SCP0083_GET_DIO_REPORT_H | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0083_GET_DIO_REPORT_H · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 22 (`POPUP/SCP0107_CAPAReportPopup.cs`(479행)) |
| WK-SCP0107-0151 | F4 | SCP0107_GET_CAPA_TEEP_ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0107_GET_CAPA_TEEP_ · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (`SCP.SCP0107_GET_CAPA_TEEP_{ASSEMBLY\) |
| WK-SCP0107-0152 | A5 | NICK_NAME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (`DefColumns` 29종 중 SP 미반환 4종(`NICK_NAME`) |
| WK-SCP0107-0153 | A5 | SEL_COLUMN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SEL_COLUMN · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:SCP0107_CAPAReportPopup.FindData:437) |
| WK-SCP0107-0154 | G4 | cboVersion / Plan Month / Version / Ver. | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboVersion / Plan Month / Version / Ver. · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-006 ACT:SCP0107_CAPA_TEEP_Report.I) |
| WK-SCP0107-0155 | G4 | cboVersionSeq / Version / Version Seq /  | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboVersionSeq / Version / Version Seq / Ver. · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-007 ACT:SCP0107_CAPA_TEEP_Report.I) |
| WK-SCP0107-0156 | G4 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-008 ACT:SCP0107_CAPA_TEEP_Report.I) |
| WK-SCP0107-0157 | G4 | clbElectrodeType / Line Type / Electrode | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbElectrodeType / Line Type / Electrode Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-009) |
| WK-SCP0107-0158 | G4 | clbFactory / Building / Factory | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbFactory / Building / Factory · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-010 ACT:SCP0107_CAPA_TEEP_Report.I) |
| WK-SCP0107-0159 | G4 | clbLine / Line | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbLine / Line · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-011 ACT:SCP0107_CAPA_TEEP_Report.I) |
| WK-SCP0107-0160 | G4 | clbOperation / Operation | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbOperation / Operation · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-012 ACT:SCP0107_CAPA_TEEP_Report.I) |
| WK-SCP0107-0161 | G4 | clbPlant / Plant | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbPlant / Plant · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (13 D00-1-013 ACT:SCP0107_CAPA_TEEP_Repor) |
| WK-SCP0107-0162 | G4 | clbSite / Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbSite / Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (14 D00-1-014 ACT:SCP0107_CAPA_TEEP_Repor) |
| WK-SCP0107-0163 | G4 | rgrpDivisionType / Division Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — rgrpDivisionType / Division Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (31 D00-1-031 ACT:SCP0107_CAPA_TEEP_Repor) |
| WK-SCP0107-0164 | G4 | txtPlanType / _plan_type / Plan Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtPlanType / _plan_type / Plan Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (34 D00-1-034) |
| WK-SCP0107-0165 | H2 | MEASURE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — MEASURE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0107_CAPA_TEEP_Report.Set_Measure) |
| WK-SCP0107-0166 | H2 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (`DefColumns` 29종 중 SP 미반환 4종(`NICK_NAME`) |
| WK-SCP0107-0167 | H5 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NICK_NAME · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (`DefColumns` 29종 중 SP 미반환 4종(`NICK_NAME`) |
| WK-SCP0107-0168 | H5 | SEL_COLUMN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SEL_COLUMN · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (ACT:SCP0107_CAPAReportPopup.FindData:437) |
| WK-SCP0107-0169 | H5 | rgrpDivisionType / Division Type | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — rgrpDivisionType / Division Type · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필 |  | 2 (1 `rgrpDivisionType` 초기 `-1` (L-19)) |
| WK-SCP0107-0170 | I1 | SCP0107 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0107 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 7 (12 2 `_currVersionProgressStatus != _2ND) |
| WK-SCP0107-0171 | SC1 | SCP0107 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SCP0107 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 28 (34 31 14 13 10 27 24 25 26 30 29 28) |
| WK-SCP0107-0172 | D6 | SCP0107 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0107 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 4 (2 비율 measure `×100` Insert/Delete **메시지 ) |
| WK-SCP0107-0173 | E4 | BASE_QTY | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — BASE_QTY · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.SetBaseToDa) |
| WK-SCP0107-0174 | E4 | FACTORY_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — FACTORY_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.SetVisibleS) |
| WK-SCP0107-0175 | E4 | MEASURE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MEASURE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.SetSheetNum) |
| WK-SCP0107-0176 | E4 | MEASURE_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MEASURE_NAME · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SCP0107_CAPA_TEEP_Report.Set_Measure) |
| WK-SCP0107-0177 | E4 | MSG00008 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00008 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (2) |
| WK-SCP0107-0178 | E4 | MSG00009 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00009 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (2) |
| WK-SCP0107-0179 | E4 | MSG00097 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00097 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (12) |
| WK-SCP0107-0180 | E4 | MSG00423 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00423 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (12 `_currVersionProgressStatus != _2ND_C) |
| WK-SCP0107-0181 | E4 | MSG00667 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00667 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (12 D00-4d-002) |
| WK-SCP0107-0182 | E4 | MSG01044 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01044 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 0 () |
| WK-SCP0107-0183 | E4 | MSG01045 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01045 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 0 () |
| WK-SCP0107-0184 | E4 | MSG01410 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01410 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (12 `_currVersionProgressStatus != _2ND_C) |
| WK-SCP0107-0185 | E4 | PLANT_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — PLANT_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.SetVisibleS) |
| WK-SCP0107-0186 | E4 | SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — SITE_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.SetVisibleS) |
| WK-SCP0107-0187 | E4 | VER_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — VER_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.SetVisibleS) |
| WK-SCP0107-0188 | E4 | VER_SEQ | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — VER_SEQ · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.SetVisibleS) |
| WK-SCP0107-0189 | A10 | SCP0107 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0107 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 79 (ACT:SCP0107_CAPAReportPopup.DefineProper) |
| WK-SCP0107-0190 | A6 | PKG_SCP0104.P_SCP0104_GET_SPREAD_TITLE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0104.P_SCP0104_GET_SPREAD_TITLE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) ·  |  | 1 (`SCP.SCP0104_GET_SPREAD_TITLE` (`GetSpdT) |
| WK-SCP0107-0191 | A6 | P_SCP0107_GET_ASSEMBLY | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_SCP0107_GET_ASSEMBLY · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@tra |  | 1 (`SCP.SCP0107_GET_CAPA_TEEP_{ASSEMBLY\) |
| WK-SCP0107-0192 | A6 | P_SCP0107_TITLE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_SCP0107_TITLE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 1 (`SCP.SCP0104_GET_SPREAD_TITLE` (`GetSpdT) |
| WK-SCP0107-0193 | A6 | SCP0083_GET_DIO_REPORT_H | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SCP0083_GET_DIO_REPORT_H · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@t |  | 22 (`POPUP/SCP0107_CAPAReportPopup.cs`(479행)) |
| WK-SCP0107-0194 | A6 | SCP0107_GET_CAPA_TEEP_ | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SCP0107_GET_CAPA_TEEP_ · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@tra |  | 1 (`SCP.SCP0107_GET_CAPA_TEEP_{ASSEMBLY\) |
| WK-SCP0107-0195 | G1 | cboVersion / Plan Month / Version / Ver. | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboVersion / Plan Month / Version / Ver. · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-006) |
| WK-SCP0107-0196 | G1 | cboVersionSeq / Version / Version Seq /  | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboVersionSeq / Version / Version Seq / Ver. · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-007) |
| WK-SCP0107-0197 | G1 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-008) |
| WK-SCP0107-0198 | G1 | clbElectrodeType / Line Type / Electrode | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbElectrodeType / Line Type / Electrode Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-009) |
| WK-SCP0107-0199 | G1 | clbFactory / Building / Factory | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbFactory / Building / Factory · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-010) |
| WK-SCP0107-0200 | G1 | clbLine / Line | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbLine / Line · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-011) |
| WK-SCP0107-0201 | G1 | clbOperation / Operation | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbOperation / Operation · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-012) |
| WK-SCP0107-0202 | G1 | clbPlant / Plant | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbPlant / Plant · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (13 D00-1-013) |
| WK-SCP0107-0203 | G1 | clbSite / Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbSite / Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (14 D00-1-014) |
| WK-SCP0107-0204 | G1 | rgrpDivisionType / Division Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — rgrpDivisionType / Division Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (31 D00-1-031 D00-2-010) |
| WK-SCP0107-0205 | G1 | txtPlanType / _plan_type / Plan Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtPlanType / _plan_type / Plan Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (34 D00-1-034) |
| WK-SCP0107-0206 | G6 | cboVersion / Plan Month / Version / Ver. | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboVersion / Plan Month / Version / Ver. · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-006 ACT:SCP0107_CAPA_TEEP_Report.I) |
| WK-SCP0107-0207 | G6 | cboVersionSeq / Version / Version Seq /  | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboVersionSeq / Version / Version Seq / Ver. · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-007 ACT:SCP0107_CAPA_TEEP_Report.I) |
| WK-SCP0107-0208 | G6 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-008 ACT:SCP0107_CAPA_TEEP_Report.I) |
| WK-SCP0107-0209 | G6 | clbElectrodeType / Line Type / Electrode | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbElectrodeType / Line Type / Electrode Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-009) |
| WK-SCP0107-0210 | G6 | clbFactory / Building / Factory | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbFactory / Building / Factory · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-010 ACT:SCP0107_CAPA_TEEP_Report.I) |
| WK-SCP0107-0211 | G6 | clbLine / Line | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbLine / Line · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-011 ACT:SCP0107_CAPA_TEEP_Report.I) |
| WK-SCP0107-0212 | G6 | clbOperation / Operation | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbOperation / Operation · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-012 ACT:SCP0107_CAPA_TEEP_Report.I) |
| WK-SCP0107-0213 | G6 | clbPlant / Plant | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbPlant / Plant · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (13 D00-1-013 ACT:SCP0107_CAPA_TEEP_Repor) |
| WK-SCP0107-0214 | G6 | clbSite / Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbSite / Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (14 D00-1-014 ACT:SCP0107_CAPA_TEEP_Repor) |
| WK-SCP0107-0215 | G6 | rgrpDivisionType / Division Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — rgrpDivisionType / Division Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (31 D00-1-031 ACT:SCP0107_CAPA_TEEP_Repor) |
| WK-SCP0107-0216 | G6 | txtPlanType / _plan_type / Plan Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtPlanType / _plan_type / Plan Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (34 D00-1-034) |
| WK-SCP0107-0217 | X-REOPEN | SCP0107 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0107 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 11 (ACT:SCP0107_CAPAReportPopup.Dispose ACT:) |
| WK-SCP0107-0218 | M3 | SCP0107_CAPAReportPopup | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — SCP0107_CAPAReportPopup · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 17 (MODAL:ShowDialog ACT:SCP0107_CAPAReportP) |
| WK-SCP0107-0219 | M3 | btnLeft | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — btnLeft · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 1 (ACT:SCP0107_CAPAReportPopup.btnLeft_Clic) |
| WK-SCP0107-0220 | M3 | btnRight | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — btnRight · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 1 (ACT:SCP0107_CAPAReportPopup.btnRight_Cli) |
| WK-SCP0107-0221 | M4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (D00-4c-005) |
| WK-SCP0107-0222 | M4 | OPERATION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — OPERATION_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (D00-4b-004 D00-4c-005) |
| WK-SCP0107-0223 | M4 | SCP0107_CAPAReportPopup | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SCP0107_CAPAReportPopup · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (`POPUP/SCP0107_CAPAReportPopup.cs`(479행)) |

## W7 기대값 확정 (519)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0107-0224 | C1 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 10: 행 집계 — C1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0225 | C1 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 2: 행 집계 — C1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0226 | C1 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 3: 행 집계 — C1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0227 | C1 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 4: 행 집계 — C1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0228 | C1 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 5: 행 집계 — C1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0229 | C1 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 6: 행 집계 — C1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0230 | C1 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 7: 행 집계 — C1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0231 | C1 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 8: 행 집계 — C1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0232 | C1 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 9: 행 집계 — C1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0233 | C2 | SCP0107_CAPA_TEEP_Report.cboFromYYYY_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0107_CAPA_TEEP_Report.cboFromYYYY_SelectedIndex: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0107_CAPA_TEEP_Report.cboFromYYYY) |
| WK-SCP0107-0234 | C2 | SCP0107_CAPA_TEEP_Report.cboSheetType_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0107_CAPA_TEEP_Report.cboSheetType_SelectedInde: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.cboSheetTyp) |
| WK-SCP0107-0235 | C2 | SCP0107_CAPA_TEEP_Report.cboVersionSeq_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0107_CAPA_TEEP_Report.cboVersionSeq_SelectedInd: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0107_CAPA_TEEP_Report.cboVersionS) |
| WK-SCP0107-0236 | C2 | SCP0107_CAPA_TEEP_Report.cboVersion_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0107_CAPA_TEEP_Report.cboVersion_SelectedIndexC: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0107_CAPA_TEEP_Report.cboVersion_) |
| WK-SCP0107-0237 | C2 | SCP0107_CAPA_TEEP_Report.clbDivision_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0107_CAPA_TEEP_Report.clbDivision_SelectedIndex: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0107_CAPA_TEEP_Report.clbDivision) |
| WK-SCP0107-0238 | C2 | SCP0107_CAPA_TEEP_Report.clbFactory_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0107_CAPA_TEEP_Report.clbFactory_SelectedIndexC: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.clbFactory_) |
| WK-SCP0107-0239 | C2 | SCP0107_CAPA_TEEP_Report.clbLine_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0107_CAPA_TEEP_Report.clbLine_SelectedIndexChan: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.clbLine_Sel) |
| WK-SCP0107-0240 | C2 | SCP0107_CAPA_TEEP_Report.clbOperation_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0107_CAPA_TEEP_Report.clbOperation_SelectedInde: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.clbOperatio) |
| WK-SCP0107-0241 | C2 | SCP0107_CAPA_TEEP_Report.clbPlant_Select | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0107_CAPA_TEEP_Report.clbPlant_SelectedIndexCha: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0107_CAPA_TEEP_Report.clbPlant_Se) |
| WK-SCP0107-0242 | C2 | SCP0107_CAPA_TEEP_Report.clbSite_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0107_CAPA_TEEP_Report.clbSite_SelectedIndexChan: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0107_CAPA_TEEP_Report.clbSite_Sel) |
| WK-SCP0107-0243 | C2 | SCP0107_CAPA_TEEP_Report.rgrpDivisionTyp | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0107_CAPA_TEEP_Report.rgrpDivisionType_Selected: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0107_CAPA_TEEP_Report.rgrpDivisio) |
| WK-SCP0107-0244 | C3 | SCP0107_CAPA_TEEP_Report.SetBaseToDateCo | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0107_CAPA_TEEP_Report.SetBaseToDateColumns: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SCP0107_CAPA_TEEP_Report.SetBaseToDa) |
| WK-SCP0107-0245 | C3 | SCP0107_CAPA_TEEP_Report.SetQueryInfoGet | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0107_CAPA_TEEP_Report.SetQueryInfoGet: 진입점 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 17 (ACT:SCP0107_CAPA_TEEP_Report.SetQueryInf) |
| WK-SCP0107-0246 | C3 | SCP0107_CAPA_TEEP_Report.SetSheetMerge | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0107_CAPA_TEEP_Report.SetSheetMerge: 진입점 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.SetSheetMer) |
| WK-SCP0107-0247 | C3 | SCP0107_CAPA_TEEP_Report.SetSheetNumeric | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0107_CAPA_TEEP_Report.SetSheetNumericColumnForm: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0107_CAPA_TEEP_Report.SetSheetNum) |
| WK-SCP0107-0248 | C3 | SCP0107_CAPA_TEEP_Report.SetVisibleElect | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0107_CAPA_TEEP_Report.SetVisibleElectrodeType: 진입점 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.SetVisibleE) |
| WK-SCP0107-0249 | C3 | SCP0107_CAPA_TEEP_Report.SetVisibleOpera | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0107_CAPA_TEEP_Report.SetVisibleOperation: 진입점 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.SetVisibleO) |
| WK-SCP0107-0250 | C3 | SCP0107_CAPA_TEEP_Report.Set_MeasureColo | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0107_CAPA_TEEP_Report.Set_MeasureColor: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 15 (ACT:SCP0107_CAPA_TEEP_Report.Set_Measure) |
| WK-SCP0107-0251 | C3 | SCP0107_CAPA_TEEP_Report.cboFromYYYY_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0107_CAPA_TEEP_Report.cboFromYYYY_SelectedIndex: 진입점 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0107_CAPA_TEEP_Report.cboFromYYYY) |
| WK-SCP0107-0252 | C3 | SCP0107_CAPA_TEEP_Report.cboSheetType_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0107_CAPA_TEEP_Report.cboSheetType_SelectedInde: 진입점 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.cboSheetTyp) |
| WK-SCP0107-0253 | C3 | SCP0107_CAPA_TEEP_Report.cboVersionSeq_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0107_CAPA_TEEP_Report.cboVersionSeq_SelectedInd: 진입점 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0107_CAPA_TEEP_Report.cboVersionS) |
| WK-SCP0107-0254 | C3 | SCP0107_CAPA_TEEP_Report.cboVersion_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0107_CAPA_TEEP_Report.cboVersion_SelectedIndexC: 진입점 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0107_CAPA_TEEP_Report.cboVersion_) |
| WK-SCP0107-0255 | C3 | SCP0107_CAPA_TEEP_Report.clbDivision_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0107_CAPA_TEEP_Report.clbDivision_SelectedIndex: 진입점 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0107_CAPA_TEEP_Report.clbDivision) |
| WK-SCP0107-0256 | C3 | SCP0107_CAPA_TEEP_Report.clbFactory_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0107_CAPA_TEEP_Report.clbFactory_SelectedIndexC: 진입점 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.clbFactory_) |
| WK-SCP0107-0257 | C3 | SCP0107_CAPA_TEEP_Report.clbLine_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0107_CAPA_TEEP_Report.clbLine_SelectedIndexChan: 진입점 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.clbLine_Sel) |
| WK-SCP0107-0258 | C3 | SCP0107_CAPA_TEEP_Report.clbOperation_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0107_CAPA_TEEP_Report.clbOperation_SelectedInde: 진입점 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.clbOperatio) |
| WK-SCP0107-0259 | C3 | SCP0107_CAPA_TEEP_Report.clbPlant_Select | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0107_CAPA_TEEP_Report.clbPlant_SelectedIndexCha: 진입점 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0107_CAPA_TEEP_Report.clbPlant_Se) |
| WK-SCP0107-0260 | C3 | SCP0107_CAPA_TEEP_Report.clbSite_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0107_CAPA_TEEP_Report.clbSite_SelectedIndexChan: 진입점 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0107_CAPA_TEEP_Report.clbSite_Sel) |
| WK-SCP0107-0261 | C3 | SCP0107_CAPA_TEEP_Report.rgrpDivisionTyp | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0107_CAPA_TEEP_Report.rgrpDivisionType_Selected: 진입점 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0107_CAPA_TEEP_Report.rgrpDivisio) |
| WK-SCP0107-0262 | C3 | 데드 핸들러 3종(`cboSheetType_` / `cboFromYYYY | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — 데드 핸들러 3종(`cboSheetType_` / `cboFromYYYY_` / `spdM: 행 집계 — C3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (데드 핸들러 3종(`cboSheetType_` / `cboFromYYYY) |
| WK-SCP0107-0263 | C4 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — 10: 행 집계 — C4 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0264 | C4 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — 2: 행 집계 — C4 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0265 | C4 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — 3: 행 집계 — C4 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0266 | C4 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — 4: 행 집계 — C4 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0267 | C4 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — 5: 행 집계 — C4 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0268 | C4 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — 6: 행 집계 — C4 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0269 | C4 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — 7: 행 집계 — C4 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0270 | C4 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — 8: 행 집계 — C4 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0271 | C4 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — 9: 행 집계 — C4 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0272 | B3 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — D00-4b-001: 행 집계 — B3 25요소: TODO:25 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-001) |
| WK-SCP0107-0273 | B3 | SCP0107_CAPA_TEEP_Report.GetCurrVersionP | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0107_CAPA_TEEP_Report.GetCurrVersionProgessStat: 진입점 집계 — B3 2요소: TODO:2 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0107_CAPA_TEEP_Report.GetCurrVers) |
| WK-SCP0107-0274 | B3 | SCP0107_CAPA_TEEP_Report.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0107_CAPA_TEEP_Report.GetSpdTitle: 진입점 집계 — B3 5요소: TODO:5 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0107_CAPA_TEEP_Report.GetSpdTitle) |
| WK-SCP0107-0275 | B3 | SCP0107_CAPA_TEEP_Report.getCurrCompany | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0107_CAPA_TEEP_Report.getCurrCompany: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.getCurrComp) |
| WK-SCP0107-0276 | B3 | SCP0107_CAPA_TEEP_Report.getCurrDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0107_CAPA_TEEP_Report.getCurrDivision: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.getCurrDivi) |
| WK-SCP0107-0277 | B3 | SCP0107_CAPA_TEEP_Report.getCurrElectrod | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0107_CAPA_TEEP_Report.getCurrElectrodeType: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.getCurrElec) |
| WK-SCP0107-0278 | B3 | SCP0107_CAPA_TEEP_Report.getCurrFactory | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0107_CAPA_TEEP_Report.getCurrFactory: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.getCurrFact) |
| WK-SCP0107-0279 | B3 | SCP0107_CAPA_TEEP_Report.getCurrLine | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0107_CAPA_TEEP_Report.getCurrLine: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.getCurrLine) |
| WK-SCP0107-0280 | B3 | SCP0107_CAPA_TEEP_Report.getCurrMeasure | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0107_CAPA_TEEP_Report.getCurrMeasure: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.getCurrMeas) |
| WK-SCP0107-0281 | B3 | SCP0107_CAPA_TEEP_Report.getCurrNickname | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0107_CAPA_TEEP_Report.getCurrNickname: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.getCurrNick) |
| WK-SCP0107-0282 | B3 | SCP0107_CAPA_TEEP_Report.getCurrOperatio | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0107_CAPA_TEEP_Report.getCurrOperation: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.getCurrOper) |
| WK-SCP0107-0283 | B3 | SCP0107_CAPA_TEEP_Report.getCurrPlant | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0107_CAPA_TEEP_Report.getCurrPlant: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.getCurrPlan) |
| WK-SCP0107-0284 | B3 | SCP0107_CAPA_TEEP_Report.getCurrSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0107_CAPA_TEEP_Report.getCurrSite: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.getCurrSite) |
| WK-SCP0107-0285 | B3 | SCP0107_CAPA_TEEP_Report.getDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0107_CAPA_TEEP_Report.getDivision: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.getDivision) |
| WK-SCP0107-0286 | B3 | SCP0107_CAPA_TEEP_Report.getDivisionType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0107_CAPA_TEEP_Report.getDivisionType: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.getDivision) |
| WK-SCP0107-0287 | B3 | SCP0107_CAPA_TEEP_Report.getElectrodeTyp | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0107_CAPA_TEEP_Report.getElectrodeType: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.getElectrod) |
| WK-SCP0107-0288 | B3 | SCP0107_CAPA_TEEP_Report.getFactory | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0107_CAPA_TEEP_Report.getFactory: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.getFactory:) |
| WK-SCP0107-0289 | B3 | SCP0107_CAPA_TEEP_Report.getLine | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0107_CAPA_TEEP_Report.getLine: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.getLine:445) |
| WK-SCP0107-0290 | B3 | SCP0107_CAPA_TEEP_Report.getOperation | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0107_CAPA_TEEP_Report.getOperation: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.getOperatio) |
| WK-SCP0107-0291 | B3 | SCP0107_CAPA_TEEP_Report.getPlanType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0107_CAPA_TEEP_Report.getPlanType: 진입점 집계 — B3 25요소: TODO:25 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.getPlanType) |
| WK-SCP0107-0292 | B3 | SCP0107_CAPA_TEEP_Report.getPlant | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0107_CAPA_TEEP_Report.getPlant: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.getPlant:39) |
| WK-SCP0107-0293 | B3 | SCP0107_CAPA_TEEP_Report.getShopGroup | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0107_CAPA_TEEP_Report.getShopGroup: 진입점 집계 — B3 25요소: TODO:25 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.getShopGrou) |
| WK-SCP0107-0294 | B3 | SCP0107_CAPA_TEEP_Report.getSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0107_CAPA_TEEP_Report.getSite: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.getSite:359) |
| WK-SCP0107-0295 | B3 | SCP0107_CAPA_TEEP_Report.getVersion | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0107_CAPA_TEEP_Report.getVersion: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.getVersion:) |
| WK-SCP0107-0296 | B3 | SCP0107_CAPA_TEEP_Report.getVersionSeq | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0107_CAPA_TEEP_Report.getVersionSeq: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.getVersionS) |
| WK-SCP0107-0297 | B3 | `_currVersionProgressStatus != _2ND_CUTO | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — `_currVersionProgressStatus != _2ND_CUTOFF` -> `MS: 행 집계 — B3 25요소: TODO:25 (미실행 요소가 남아 판정필요) |  | 1 (`_currVersionProgressStatus != _2ND_CUTO) |
| WK-SCP0107-0298 | B4 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — D00-4b-001: 행 집계 — B4 25요소: NOPATH:25 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-001) |
| WK-SCP0107-0299 | B4 | SCP0107_CAPA_TEEP_Report.GetCurrVersionP | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0107_CAPA_TEEP_Report.GetCurrVersionProgessStat: 진입점 집계 — B4 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0107_CAPA_TEEP_Report.GetCurrVers) |
| WK-SCP0107-0300 | B4 | SCP0107_CAPA_TEEP_Report.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0107_CAPA_TEEP_Report.GetSpdTitle: 진입점 집계 — B4 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0107_CAPA_TEEP_Report.GetSpdTitle) |
| WK-SCP0107-0301 | B4 | SCP0107_CAPA_TEEP_Report.getCurrCompany | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0107_CAPA_TEEP_Report.getCurrCompany: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.getCurrComp) |
| WK-SCP0107-0302 | B4 | SCP0107_CAPA_TEEP_Report.getCurrDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0107_CAPA_TEEP_Report.getCurrDivision: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.getCurrDivi) |
| WK-SCP0107-0303 | B4 | SCP0107_CAPA_TEEP_Report.getCurrElectrod | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0107_CAPA_TEEP_Report.getCurrElectrodeType: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.getCurrElec) |
| WK-SCP0107-0304 | B4 | SCP0107_CAPA_TEEP_Report.getCurrFactory | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0107_CAPA_TEEP_Report.getCurrFactory: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.getCurrFact) |
| WK-SCP0107-0305 | B4 | SCP0107_CAPA_TEEP_Report.getCurrLine | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0107_CAPA_TEEP_Report.getCurrLine: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.getCurrLine) |
| WK-SCP0107-0306 | B4 | SCP0107_CAPA_TEEP_Report.getCurrMeasure | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0107_CAPA_TEEP_Report.getCurrMeasure: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.getCurrMeas) |
| WK-SCP0107-0307 | B4 | SCP0107_CAPA_TEEP_Report.getCurrNickname | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0107_CAPA_TEEP_Report.getCurrNickname: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.getCurrNick) |
| WK-SCP0107-0308 | B4 | SCP0107_CAPA_TEEP_Report.getCurrOperatio | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0107_CAPA_TEEP_Report.getCurrOperation: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.getCurrOper) |
| WK-SCP0107-0309 | B4 | SCP0107_CAPA_TEEP_Report.getCurrPlant | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0107_CAPA_TEEP_Report.getCurrPlant: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.getCurrPlan) |
| WK-SCP0107-0310 | B4 | SCP0107_CAPA_TEEP_Report.getCurrSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0107_CAPA_TEEP_Report.getCurrSite: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.getCurrSite) |
| WK-SCP0107-0311 | B4 | SCP0107_CAPA_TEEP_Report.getDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0107_CAPA_TEEP_Report.getDivision: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.getDivision) |
| WK-SCP0107-0312 | B4 | SCP0107_CAPA_TEEP_Report.getDivisionType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0107_CAPA_TEEP_Report.getDivisionType: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.getDivision) |
| WK-SCP0107-0313 | B4 | SCP0107_CAPA_TEEP_Report.getElectrodeTyp | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0107_CAPA_TEEP_Report.getElectrodeType: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.getElectrod) |
| WK-SCP0107-0314 | B4 | SCP0107_CAPA_TEEP_Report.getFactory | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0107_CAPA_TEEP_Report.getFactory: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.getFactory:) |
| WK-SCP0107-0315 | B4 | SCP0107_CAPA_TEEP_Report.getLine | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0107_CAPA_TEEP_Report.getLine: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.getLine:445) |
| WK-SCP0107-0316 | B4 | SCP0107_CAPA_TEEP_Report.getOperation | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0107_CAPA_TEEP_Report.getOperation: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.getOperatio) |
| WK-SCP0107-0317 | B4 | SCP0107_CAPA_TEEP_Report.getPlanType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0107_CAPA_TEEP_Report.getPlanType: 진입점 집계 — B4 25요소: NOPATH:25 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.getPlanType) |
| WK-SCP0107-0318 | B4 | SCP0107_CAPA_TEEP_Report.getPlant | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0107_CAPA_TEEP_Report.getPlant: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.getPlant:39) |
| WK-SCP0107-0319 | B4 | SCP0107_CAPA_TEEP_Report.getShopGroup | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0107_CAPA_TEEP_Report.getShopGroup: 진입점 집계 — B4 25요소: NOPATH:25 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.getShopGrou) |
| WK-SCP0107-0320 | B4 | SCP0107_CAPA_TEEP_Report.getSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0107_CAPA_TEEP_Report.getSite: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.getSite:359) |
| WK-SCP0107-0321 | B4 | SCP0107_CAPA_TEEP_Report.getVersion | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0107_CAPA_TEEP_Report.getVersion: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.getVersion:) |
| WK-SCP0107-0322 | B4 | SCP0107_CAPA_TEEP_Report.getVersionSeq | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0107_CAPA_TEEP_Report.getVersionSeq: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.getVersionS) |
| WK-SCP0107-0323 | B4 | `_currVersionProgressStatus != _2ND_CUTO | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — `_currVersionProgressStatus != _2ND_CUTOFF` -> `MS: 행 집계 — B4 25요소: NOPATH:25 (미실행 요소가 남아 판정필요) |  | 1 (`_currVersionProgressStatus != _2ND_CUTO) |
| WK-SCP0107-0324 | DB-SYN | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 4: 행 집계 — DB-SYN 6요소: NOPATH:5 · PASS:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0325 | DB-SYN | SCP0107_CAPA_TEEP_Report.FindDataMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SCP0107_CAPA_TEEP_Report.FindDataMain: 진입점 집계 — DB-SYN 6요소: NOPATH:5 · PASS:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.FindDataMai) |
| WK-SCP0107-0326 | DB-SYN | `Form_Load` 초기화 순서(cs:913~926, 생성자 배선) | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — `Form_Load` 초기화 순서(cs:913~926, 생성자 배선): 행 집계 — DB-SYN 6요소: NOPATH:5 · PASS:1 (미실행 요소가 남아 판정필요) |  | 1 (`Form_Load` 초기화 순서(cs:913~926, 생성자 배선)) |
| WK-SCP0107-0327 | F4 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 4: 행 집계 — F4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0328 | F4 | SCP0107_CAPA_TEEP_Report.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0107_CAPA_TEEP_Report.FindButton: 진입점 집계 — F4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0107_CAPA_TEEP_Report.FindButton ) |
| WK-SCP0107-0329 | F4 | SCP0107_CAPA_TEEP_Report.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0107_CAPA_TEEP_Report.FindData: 진입점 집계 — F4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.FindData AC) |
| WK-SCP0107-0330 | F4 | SCP0107_CAPA_TEEP_Report.FindDataMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0107_CAPA_TEEP_Report.FindDataMain: 진입점 집계 — F4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.FindDataMai) |
| WK-SCP0107-0331 | F4 | `Form_Load` 초기화 순서(cs:913~926, 생성자 배선) | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — `Form_Load` 초기화 순서(cs:913~926, 생성자 배선): 행 집계 — F4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (`Form_Load` 초기화 순서(cs:913~926, 생성자 배선)) |
| WK-SCP0107-0332 | A5 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 1: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-SCP0107-0333 | A5 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 11: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (11) |
| WK-SCP0107-0334 | A5 | 23 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 23: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0335 | A5 | 28 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 28: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (28) |
| WK-SCP0107-0336 | A5 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 3: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0337 | A5 | 32 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 32: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (32) |
| WK-SCP0107-0338 | A5 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 4: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0339 | A5 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 5: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0340 | A5 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 9: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0341 | A5 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-03: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-SCP0107-0342 | A5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-07: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0107-0343 | A5 | D00-1-032 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-032: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-032) |
| WK-SCP0107-0344 | A5 | D00-3-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-3-001: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-001) |
| WK-SCP0107-0345 | A5 | D00-3-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-3-011: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-011) |
| WK-SCP0107-0346 | A5 | SCP0107_CAPA_TEEP_Report.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0107_CAPA_TEEP_Report.CreateSpread: 진입점 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0107_CAPA_TEEP_Report.CreateSprea) |
| WK-SCP0107-0347 | A5 | `rgrpDivisionType` 초기 `-1` (L-19) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — `rgrpDivisionType` 초기 `-1` (L-19): 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (`rgrpDivisionType` 초기 `-1` (L-19)) |
| WK-SCP0107-0348 | A5 | `spreadTitle` 시트명 규약 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — `spreadTitle` 시트명 규약: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (`spreadTitle` 시트명 규약) |
| WK-SCP0107-0349 | A5 | – | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — –: 행 집계 — A5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0350 | G4 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 1: 행 집계 — G4 12요소: NOT_RUN:11 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0351 | G4 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 10: 행 집계 — G4 12요소: NOT_RUN:11 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (10) |
| WK-SCP0107-0352 | G4 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 2: 행 집계 — G4 12요소: NOT_RUN:11 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0353 | G4 | 22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 22: 행 집계 — G4 12요소: NOT_RUN:11 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (22) |
| WK-SCP0107-0354 | G4 | 24 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 24: 행 집계 — G4 12요소: NOT_RUN:11 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (24) |
| WK-SCP0107-0355 | G4 | 25 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 25: 행 집계 — G4 12요소: NOT_RUN:11 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (25) |
| WK-SCP0107-0356 | G4 | 26 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 26: 행 집계 — G4 12요소: NOT_RUN:11 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (26) |
| WK-SCP0107-0357 | G4 | 27 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 27: 행 집계 — G4 12요소: NOT_RUN:11 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (27) |
| WK-SCP0107-0358 | G4 | 28 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 28: 행 집계 — G4 12요소: NOT_RUN:11 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (28) |
| WK-SCP0107-0359 | G4 | 29 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 29: 행 집계 — G4 12요소: NOT_RUN:11 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (29) |
| WK-SCP0107-0360 | G4 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 3: 행 집계 — G4 12요소: NOT_RUN:11 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0361 | G4 | 30 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 30: 행 집계 — G4 12요소: NOT_RUN:11 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (30) |
| WK-SCP0107-0362 | G4 | 35 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 35: 행 집계 — G4 12요소: NOT_RUN:11 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (35) |
| WK-SCP0107-0363 | G4 | 37 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 37: 행 집계 — G4 12요소: NOT_RUN:11 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (37) |
| WK-SCP0107-0364 | G4 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 4: 행 집계 — G4 12요소: NOT_RUN:11 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0365 | G4 | D00-1-035 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-1-035: 행 집계 — G4 12요소: NOT_RUN:11 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-035) |
| WK-SCP0107-0366 | G4 | D00-1-037 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-1-037: 행 집계 — G4 12요소: NOT_RUN:11 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-037) |
| WK-SCP0107-0367 | G4 | – | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — –: 행 집계 — G4 12요소: NOT_RUN:11 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0368 | H2 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 1: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-SCP0107-0369 | H2 | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 12: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0370 | H2 | 23 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 23: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0371 | H2 | 29 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 29: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (29) |
| WK-SCP0107-0372 | H2 | 30 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 30: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (30) |
| WK-SCP0107-0373 | H2 | 32 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 32: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (32) |
| WK-SCP0107-0374 | H2 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 4: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0375 | H2 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 5: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0376 | H2 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 7: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (7) |
| WK-SCP0107-0377 | H2 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 9: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0378 | H2 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-03: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-SCP0107-0379 | H2 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-07: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0107-0380 | H2 | D00-1-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-1-009: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-009) |
| WK-SCP0107-0381 | H2 | D00-1-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-1-012: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-012) |
| WK-SCP0107-0382 | H2 | D00-1-032 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-1-032: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-032) |
| WK-SCP0107-0383 | H2 | D00-3-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-3-001: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-001) |
| WK-SCP0107-0384 | H2 | D00-3-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-3-009: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-009) |
| WK-SCP0107-0385 | H2 | D00-3-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-3-011: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-011) |
| WK-SCP0107-0386 | H2 | SCP0107_CAPA_TEEP_Report.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0107_CAPA_TEEP_Report.CreateSpread: 진입점 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0107_CAPA_TEEP_Report.CreateSprea) |
| WK-SCP0107-0387 | H2 | SCP0107_CAPA_TEEP_Report.Set_MeasureColo | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0107_CAPA_TEEP_Report.Set_MeasureColor: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 15 (ACT:SCP0107_CAPA_TEEP_Report.Set_Measure) |
| WK-SCP0107-0388 | H2 | `rgrpDivisionType` 초기 `-1` (L-19) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — `rgrpDivisionType` 초기 `-1` (L-19): 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (`rgrpDivisionType` 초기 `-1` (L-19)) |
| WK-SCP0107-0389 | H2 | `spreadTitle` 시트명 규약 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — `spreadTitle` 시트명 규약: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (`spreadTitle` 시트명 규약) |
| WK-SCP0107-0390 | H2 | – | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — –: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0391 | H2 | 조회 결과 0건 시 색칠 미수행(cs:1519) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 조회 결과 0건 시 색칠 미수행(cs:1519): 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (조회 결과 0건 시 색칠 미수행(cs:1519)) |
| WK-SCP0107-0392 | H5 | 23 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 23: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0393 | H5 | 32 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 32: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (32) |
| WK-SCP0107-0394 | H5 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 4: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0395 | H5 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 5: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0396 | H5 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 9: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0397 | H5 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-03: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-SCP0107-0398 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0107-0399 | H5 | D00-1-032 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-1-032: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-032) |
| WK-SCP0107-0400 | H5 | D00-3-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-3-001: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-001) |
| WK-SCP0107-0401 | H5 | D00-3-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-3-011: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-011) |
| WK-SCP0107-0402 | H5 | SCP0107_CAPA_TEEP_Report.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0107_CAPA_TEEP_Report.CreateSpread: 진입점 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0107_CAPA_TEEP_Report.CreateSprea) |
| WK-SCP0107-0403 | H5 | `spreadTitle` 시트명 규약 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `spreadTitle` 시트명 규약: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`spreadTitle` 시트명 규약) |
| WK-SCP0107-0404 | H5 | – | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — –: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0405 | X-REASON | **L-12** | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — **L-12** Delete + `IsLock==true` -> **`MSG00009`** 후 차단 `handleDelete` = **`MSG01045`** alert (D-2) |  | 1 (**L-12**) |
| WK-SCP0107-0406 | X-REASON | **L-14** | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — **L-14** Insert + `IsLock==true` -> **`MSG00008`** 후 차단 `handleInsert` = **`MSG01044`** alert (D-2) |  | 1 (**L-14**) |
| WK-SCP0107-0407 | X-REASON | 1 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 1 `rgrpDivisionType` 기본값 `-1` -> **`ELTR` 명시** 사용자 확정 **D-1**. AS-IS 헤더/시트 축 불일치(L-19) 및 `shop_group='P'` 잠재 결함 |  | 0 () |
| WK-SCP0107-0408 | X-REASON | 2 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 2 Insert/Delete 가 alert 를 띄운다 사용자 확정 **D-2**. AS-IS 베이스 게이트가 실제로 `MSG00008`/`MSG00009` 를 띄우므로 오히려 파리티다 |  | 0 () |
| WK-SCP0107-0409 | X-REASON | 21 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 21 `layoutControlGroup1` **사장 노드** — Root 지정만 되고 `Items.AddRange` 0건. L-05 와 한 쌍 L-06 / V-14 |  | 1 (21) |
| WK-SCP0107-0410 | X-REASON | 3 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 3 ~~Division 권한 0건 안내가 **Load 1회**~~ -> **철회(iter-2 R-05)**. Load 1회 + **Search 클릭마다** 안내 둘 다 띄운다 = AS-IS 파리티 A |  | 0 () |
| WK-SCP0107-0411 | X-REASON | 4 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 4 Line 후보 0건에서 예외 대신 빈 목록 AS-IS 결함 교정(**A-5 / S-17**) — 예외만 제거, 기능 축소 아님 |  | 0 () |
| WK-SCP0107-0412 | X-REASON | 5 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 5 헤더 SP `p_sheet_name` 을 `divisionType` **단일 파생**으로 통일 AS-IS ternary(`SelectedIndex==0?ELTR:ASSEMBLY`)와 `_sheet |  | 0 () |
| WK-SCP0107-0413 | X-REASON | COMMON:UC-05 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-05 Excel Download 시 콤보 컬럼이 Code 아닌 Name 으로 출력  그리드 셀 콤보 0건(CELL_CONTROL_OBJECT_TYPE_CODE='FPComboBox' |  | 1 (COMMON:UC-05) |
| WK-SCP0107-0414 | X-REASON | COMMON:UC-06 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-06 Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회  자유입력(Key-in) 조회조건이 0건이다 — 9필드 전부 콤보·라디오·읽기전용 파생표시이고 Plan Type 은 |  | 1 (COMMON:UC-06) |
| WK-SCP0107-0415 | X-REASON | D00-1-036 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-036 §1 usrLayoutControl1 / UsrLayoutControl  사장 노드 — Form.Controls 미추가 + cs 참조 0건(L-05 / §1-3) 제외 |  | 1 (D00-1-036) |
| WK-SCP0107-0416 | X-REASON | D00-3-002 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-002 §3 ColumnHeaderSpan / 1단  데드 — MergeKeyColumns 참조 0건(§9 G-02). 이식하면 AS-IS 에 없는 키컬럼 헤더 가로병합이 생긴다 제외 |  | 1 (D00-3-002) |
| WK-SCP0107-0417 | X-REASON | D00-3-003 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-003 §3 ColumnHeaderSpan / 2단  동 데드(§9 G-03) 제외 |  | 1 (D00-3-003) |
| WK-SCP0107-0418 | X-REASON | D00-3-004 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-004 §3 ColumnHeaderSpan / 3단  동 데드(§9 G-04). 3단 헤더 근거는 SetSheetHeaderColumnSCP + RefreshSpreadDateColumn  |  | 1 (D00-3-004) |
| WK-SCP0107-0419 | X-REASON | D00-4d-004 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-4d-004 §4d DeleteButton / Delete (RowCount 0 가드)  동 도달 불가(§8 #4) 제외 |  | 1 (D00-4d-004) |
| WK-SCP0107-0420 | X-REASON | D00-4d-005 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-4d-005 §4d DeleteButton / Delete (ActiveRow null 가드)  동 도달 불가(§8 #5) 제외 |  | 1 (D00-4d-005) |
| WK-SCP0107-0421 | X-REASON | L-10/L-13/L-15 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — L-10/L-13/L-15 `SecurityContext.CanDelete/CanInsert/CanSelect == false` -> `MSG00096` `useTabBtnPermissions().h |  | 1 (L-10/L-13/L-15) |
| WK-SCP0107-0422 | X-REASON | `G-01` | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `G-01` `Sheets[i].Visible = (i == _sheet_idx)` 1229~1232 **O** `sheetName` 파생 1개로 `DataGrid` 1개 스위치. 탭·CSS 숨김 금 |  | 1 (`G-01`) |
| WK-SCP0107-0423 | X-REASON | `G-02` | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `G-02` `ColumnHeaderSpan(0,…)` (`MergeKeyColumns`) 1265 **X** **데드** — `MergeKeyColumns` 참조 0건(SCP0106 은 호출). 이 |  | 1 (`G-02`) |
| WK-SCP0107-0424 | X-REASON | `G-03` | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `G-03` `ColumnHeaderSpan(1,…)` 1266 **X** 동 |  | 1 (`G-03`) |
| WK-SCP0107-0425 | X-REASON | `G-04` | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `G-04` `ColumnHeaderSpan(2,…)` 1267 **X** 동. 헤더 3단 근거는 이 데드 코드가 아니라 G-05 + `RefreshSpreadDateColumn` |  | 1 (`G-04`) |
| WK-SCP0107-0426 | X-REASON | `G-06` | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `G-06` `_si.Delete()` 1369~1374 **X** 도달 불가(L-12). `hotkeyConfig.delete` = alert 핸들러 |  | 1 (`G-06`) |
| WK-SCP0107-0427 | X-REASON | `G-07` | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `G-07` `_si.Query(ds)` 1506 **O(일부)** 데이터 바인딩만 재현. `_tblOriginal` 스냅샷은 **이식 금지**(유일 소비처 `CheckChangedValues` 참조 |  | 1 (`G-07`) |
| WK-SCP0107-0428 | X-REASON | `G-08` | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `G-08` `LockColumn(0,max,true)` 1510 **메타** `INPUT_TP_CD='S'` 50행 전건 -> 공용 판정만으로 AS-IS 일치. **화면 고유 `canEdit` 오버 |  | 1 (`G-08`) |
| WK-SCP0107-0429 | X-REASON | `G-09` | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `G-09` `Set_MeasureColor` (`MEASURE_NAME` 문자열 19종) 1523~1575 **O(코드 기준 변환)** `MEASURE_COLOR_BY_CODE` 19종 4색 + S |  | 1 (`G-09`) |
| WK-SCP0107-0430 | X-REASON | `G-10` | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `G-10` `ToggleMerge(sheet,true)` 1581 **O** `AllowMerging.All` 상시(편집모드 부재) |  | 1 (`G-10`) |
| WK-SCP0107-0431 | X-REASON | `G-13` | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `G-13` 행 단위 소수 자릿수(`SetNumericColumnFormat`, measure 5종 -> 0자리) **O** `CapaTeepReportGrid#formatItem`. `DATA_SC |  | 1 (`G-13`) |
| WK-SCP0107-0432 | X-REASON | `G-15` | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `G-15` 숨김 컬럼 코드 배열 13종(`SetVisibleSheetColumn`) **메타** `colWth===0 \ \ visible===false` 이중 판정(store). 배열 이식 금지( |  | 1 (`G-15`) |
| WK-SCP0107-0433 | X-REASON | `G-16` | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `G-16` 기간 목록 `ASSIGN_PRIORITY` 제외 **X(무효)** TVF 가 SCP0107 에 그 컬럼을 0건 생성 -> 항상 무동작. 이식하면 죽은 코드 |  | 1 (`G-16`) |
| WK-SCP0107-0434 | X-REASON | `G-17` | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `G-17` `SetSearchCount(ds)` **O** `SubTitle dataCount={rows.length}` |  | 1 (`G-17`) |
| WK-SCP0107-0435 | X-REASON | `G-18` | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `G-18` freeze(`FIXED_FLAG` **마지막** 'Y' 기준) **O** 공용 `DataGrid` 가 `findLastIndex(_fixed)+1` 로 계산 -> `BASE_QTY` 까 |  | 1 (`G-18`) |
| WK-SCP0107-0436 | X-REASON | `L-11` | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `L-11` `CheckValidation` `fps == null` -> `MSG00007` 미이식 — TO-BE 에 `fps`(활성 spread 선택) 개념이 없다. 문구 일치본은 `MSG0104 |  | 1 (`L-11`) |
| WK-SCP0107-0437 | X-REASON | `L-16` | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `L-16` Search + `IsChange==true` -> `MSG00127` 확인 미이식 — 편집 경로가 없어 **조건 미발생** |  | 1 (`L-16`) |
| WK-SCP0107-0438 | X-REASON | `L-17` | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `L-17` Search 시 `IsEditMode/IsSort/IsSortChange=false` 강제 실효는 정렬 리셋뿐 — 공용 `SubTitle`/`DataGrid` 소관 |  | 1 (`L-17`) |
| WK-SCP0107-0439 | X-REASON | `L-18` | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `L-18` `SetFilterALLCancel` + `ReadOnlySheetList` 미이식 — `ReadOnlySheetList` 는 **읽기전용과 무관**(필터 전체해제 스킵용)이고 Wijmo |  | 1 (`L-18`) |
| WK-SCP0107-0440 | X-REASON | `ScpCapaBL.GetCapaLineMasterAll(division | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `ScpCapaBL.GetCapaLineMasterAll(divisionType)` (cs:799, 1152) `CapaLineMaster_SCP_ALL` ↔ `CapaLineMasterEE_SCP_ |  | 1 (`ScpCapaBL.GetCapaLineMasterAll(division) |
| WK-SCP0107-0441 | X-REASON | `ScpCapaBL.GetPlanType(...)` (cs:297) | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `ScpCapaBL.GetPlanType(...)` (cs:297) `derivePlanType` (`BIZ_PLAN_USE_YN='Y'` -> BP / else RP) O |  | 1 (`ScpCapaBL.GetPlanType(...)` (cs:297)) |
| WK-SCP0107-0442 | X-REASON | `ScpCapaBL.GetProgressStatusAll()` (cs:4 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `ScpCapaBL.GetProgressStatusAll()` (cs:49) `CapaProgressStatus_SCP_ALL` **X** — `dtProgressStatusAll`/`dtProgre |  | 1 (`ScpCapaBL.GetProgressStatusAll()` (cs:4) |
| WK-SCP0107-0443 | X-REASON | `ScpCapaBL.GetVersionAll()` (cs:46) | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `ScpCapaBL.GetVersionAll()` (cs:46) `CapaVersion_SCP_ALL` 1건에서 4파생(Plan Month / Ver. / Plan Type / 조회 게이트값) O |  | 1 (`ScpCapaBL.GetVersionAll()` (cs:46)) |
| WK-SCP0107-0444 | E4 | Insert/Delete **메시지 재현** | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — Insert/Delete **메시지 재현**: 행 집계 — E4 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (Insert/Delete **메시지 재현**) |
| WK-SCP0107-0445 | E4 | SCP0107_CAPA_TEEP_Report.SetBaseToDateCo | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0107_CAPA_TEEP_Report.SetBaseToDateColumns: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SCP0107_CAPA_TEEP_Report.SetBaseToDa) |
| WK-SCP0107-0446 | E4 | SCP0107_CAPA_TEEP_Report.SetQueryInfoGet | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0107_CAPA_TEEP_Report.SetQueryInfoGet: 진입점 집계 — E4 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 17 (ACT:SCP0107_CAPA_TEEP_Report.SetQueryInf) |
| WK-SCP0107-0447 | E4 | SCP0107_CAPA_TEEP_Report.SetSheetMerge | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0107_CAPA_TEEP_Report.SetSheetMerge: 진입점 집계 — E4 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.SetSheetMer) |
| WK-SCP0107-0448 | E4 | SCP0107_CAPA_TEEP_Report.SetSheetNumeric | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0107_CAPA_TEEP_Report.SetSheetNumericColumnForm: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0107_CAPA_TEEP_Report.SetSheetNum) |
| WK-SCP0107-0449 | E4 | SCP0107_CAPA_TEEP_Report.SetVisibleElect | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0107_CAPA_TEEP_Report.SetVisibleElectrodeType: 진입점 집계 — E4 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.SetVisibleE) |
| WK-SCP0107-0450 | E4 | SCP0107_CAPA_TEEP_Report.SetVisibleOpera | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0107_CAPA_TEEP_Report.SetVisibleOperation: 진입점 집계 — E4 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.SetVisibleO) |
| WK-SCP0107-0451 | E4 | SCP0107_CAPA_TEEP_Report.Set_MeasureColo | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0107_CAPA_TEEP_Report.Set_MeasureColor: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 15 (ACT:SCP0107_CAPA_TEEP_Report.Set_Measure) |
| WK-SCP0107-0452 | E4 | validations | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — validations: 행 집계 — E4 16요소: NOT_RUN:16 (미실행 요소가 남아 판정필요) |  | 1 (validations) |
| WK-SCP0107-0453 | A1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1: 행 집계 — A1 5요소: REVIEW:5 |  | 0 () |
| WK-SCP0107-0454 | A1 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 10: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (10) |
| WK-SCP0107-0455 | A1 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 11: 행 집계 — A1 5요소: REVIEW:5 |  | 0 () |
| WK-SCP0107-0456 | A1 | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 12: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (12) |
| WK-SCP0107-0457 | A1 | 13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 13: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (13) |
| WK-SCP0107-0458 | A1 | 14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 14: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (14) |
| WK-SCP0107-0459 | A1 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 2: 행 집계 — A1 5요소: REVIEW:5 |  | 0 () |
| WK-SCP0107-0460 | A1 | 22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 22: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (22) |
| WK-SCP0107-0461 | A1 | 24 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 24: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (24) |
| WK-SCP0107-0462 | A1 | 25 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 25: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (25) |
| WK-SCP0107-0463 | A1 | 26 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 26: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (26) |
| WK-SCP0107-0464 | A1 | 27 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 27: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (27) |
| WK-SCP0107-0465 | A1 | 28 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 28: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (28) |
| WK-SCP0107-0466 | A1 | 29 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 29: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (29) |
| WK-SCP0107-0467 | A1 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 3: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (3) |
| WK-SCP0107-0468 | A1 | 30 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 30: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (30) |
| WK-SCP0107-0469 | A1 | 31 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 31: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (31) |
| WK-SCP0107-0470 | A1 | 34 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 34: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (34) |
| WK-SCP0107-0471 | A1 | 35 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 35: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (35) |
| WK-SCP0107-0472 | A1 | 37 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 37: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (37) |
| WK-SCP0107-0473 | A1 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 4: 행 집계 — A1 5요소: REVIEW:5 |  | 0 () |
| WK-SCP0107-0474 | A1 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 5: 행 집계 — A1 5요소: REVIEW:5 |  | 0 () |
| WK-SCP0107-0475 | A1 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 6: 행 집계 — A1 5요소: REVIEW:5 |  | 0 () |
| WK-SCP0107-0476 | A1 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 7: 행 집계 — A1 5요소: REVIEW:5 |  | 0 () |
| WK-SCP0107-0477 | A1 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 8: 행 집계 — A1 5요소: REVIEW:5 |  | 0 () |
| WK-SCP0107-0478 | A1 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 9: 행 집계 — A1 5요소: REVIEW:5 |  | 0 () |
| WK-SCP0107-0479 | A1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-03: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (COMMON:UC-03) |
| WK-SCP0107-0480 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (COMMON:UC-07) |
| WK-SCP0107-0481 | A1 | D00-2-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-010: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (D00-2-010) |
| WK-SCP0107-0482 | A1 | D00-4d-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4d-001: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (D00-4d-001) |
| WK-SCP0107-0483 | A1 | D00-4d-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4d-002: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (D00-4d-002) |
| WK-SCP0107-0484 | A1 | PKG_SCP0104.P_SCP0104_GET_SPREAD_TITLE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0104.P_SCP0104_GET_SPREAD_TITLE: 골든 비교 케이스 없음(PKG_SCP0104.P_SCP0104_GET_SPREAD_TITLE — 팝업·보조 SP 는 golden_cases. |  | 1 (`SCP.SCP0104_GET_SPREAD_TITLE` (`GetSpdT) |
| WK-SCP0107-0485 | A1 | P_SCP0107_GET_ASSEMBLY | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_SCP0107_GET_ASSEMBLY: 골든 비교 케이스 없음(P_SCP0107_GET_ASSEMBLY — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (`SCP.SCP0107_GET_CAPA_TEEP_{ASSEMBLY\) |
| WK-SCP0107-0486 | A1 | P_SCP0107_TITLE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_SCP0107_TITLE: 골든 비교 케이스 없음(P_SCP0107_TITLE — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (`SCP.SCP0104_GET_SPREAD_TITLE` (`GetSpdT) |
| WK-SCP0107-0487 | A1 | SCP0083_GET_DIO_REPORT_H | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0083_GET_DIO_REPORT_H: 골든 비교 케이스 없음(SCP0083_GET_DIO_REPORT_H — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요 |  | 22 (`POPUP/SCP0107_CAPAReportPopup.cs`(479행)) |
| WK-SCP0107-0488 | A1 | SCP0107_CAPAReportPopup.SetTitleSet | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0107_CAPAReportPopup.SetTitleSet: 진입점 집계 — A1 5요소: REVIEW:5 |  | 2 (ACT:SCP0107_CAPAReportPopup.SetTitleSet:) |
| WK-SCP0107-0489 | A1 | SCP0107_CAPA_TEEP_Report.AfterFindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0107_CAPA_TEEP_Report.AfterFindData: 진입점 집계 — A1 5요소: REVIEW:5 |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.AfterFindDa) |
| WK-SCP0107-0490 | A1 | SCP0107_CAPA_TEEP_Report.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0107_CAPA_TEEP_Report.FindButton: 진입점 집계 — A1 5요소: REVIEW:5 |  | 5 (ACT:SCP0107_CAPA_TEEP_Report.FindButton ) |
| WK-SCP0107-0491 | A1 | SCP0107_CAPA_TEEP_Report.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0107_CAPA_TEEP_Report.FindData: 진입점 집계 — A1 5요소: REVIEW:5 |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.FindData AC) |
| WK-SCP0107-0492 | A1 | SCP0107_CAPA_TEEP_Report.FindDataMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0107_CAPA_TEEP_Report.FindDataMain: 진입점 집계 — A1 5요소: REVIEW:5 |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.FindDataMai) |
| WK-SCP0107-0493 | A1 | SCP0107_GET_CAPA_TEEP_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0107_GET_CAPA_TEEP_: 골든 비교 케이스 없음(SCP0107_GET_CAPA_TEEP_ — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (`SCP.SCP0107_GET_CAPA_TEEP_{ASSEMBLY\) |
| WK-SCP0107-0494 | A1 | `Form_Load` 초기화 순서(cs:913~926, 생성자 배선) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `Form_Load` 초기화 순서(cs:913~926, 생성자 배선): 행 집계 — A1 5요소: REVIEW:5 |  | 1 (`Form_Load` 초기화 순서(cs:913~926, 생성자 배선)) |
| WK-SCP0107-0495 | A1 | `_currVersionProgressStatus != _2ND_CUTO | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `_currVersionProgressStatus != _2ND_CUTOFF` -> `MS: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (`_currVersionProgressStatus != _2ND_CUTO) |
| WK-SCP0107-0496 | A1 | – | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — –: 행 집계 — A1 5요소: REVIEW:5 |  | 0 () |
| WK-SCP0107-0497 | A1 | 조회 결과 0건 시 색칠 미수행(cs:1519) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 조회 결과 0건 시 색칠 미수행(cs:1519): 행 집계 — A1 5요소: REVIEW:5 |  | 1 (조회 결과 0건 시 색칠 미수행(cs:1519)) |
| WK-SCP0107-0498 | A6 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 4: 행 집계 — A6 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0499 | A6 | SCP0107_CAPA_TEEP_Report.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — SCP0107_CAPA_TEEP_Report.FindButton: 진입점 집계 — A6 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0107_CAPA_TEEP_Report.FindButton ) |
| WK-SCP0107-0500 | A6 | SCP0107_CAPA_TEEP_Report.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — SCP0107_CAPA_TEEP_Report.FindData: 진입점 집계 — A6 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.FindData AC) |
| WK-SCP0107-0501 | A6 | SCP0107_CAPA_TEEP_Report.FindDataMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — SCP0107_CAPA_TEEP_Report.FindDataMain: 진입점 집계 — A6 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.FindDataMai) |
| WK-SCP0107-0502 | A6 | `Form_Load` 초기화 순서(cs:913~926, 생성자 배선) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — `Form_Load` 초기화 순서(cs:913~926, 생성자 배선): 행 집계 — A6 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`Form_Load` 초기화 순서(cs:913~926, 생성자 배선)) |
| WK-SCP0107-0503 | G1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 1: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0504 | G1 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 10: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (10) |
| WK-SCP0107-0505 | G1 | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 12: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (12) |
| WK-SCP0107-0506 | G1 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 2: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0507 | G1 | 22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 22: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (22) |
| WK-SCP0107-0508 | G1 | 24 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 24: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (24) |
| WK-SCP0107-0509 | G1 | 25 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 25: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (25) |
| WK-SCP0107-0510 | G1 | 26 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 26: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (26) |
| WK-SCP0107-0511 | G1 | 27 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 27: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (27) |
| WK-SCP0107-0512 | G1 | 28 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 28: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (28) |
| WK-SCP0107-0513 | G1 | 29 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 29: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (29) |
| WK-SCP0107-0514 | G1 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 3: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (3) |
| WK-SCP0107-0515 | G1 | 30 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 30: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (30) |
| WK-SCP0107-0516 | G1 | 35 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 35: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (35) |
| WK-SCP0107-0517 | G1 | 37 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 37: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (37) |
| WK-SCP0107-0518 | G1 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 4: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0519 | G1 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 5: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0520 | G1 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 6: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0521 | G1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-03: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-SCP0107-0522 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0107-0523 | G1 | D00-1-035 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-035: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-035) |
| WK-SCP0107-0524 | G1 | D00-1-037 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-037: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-037) |
| WK-SCP0107-0525 | G1 | D00-4d-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-4d-001: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-001) |
| WK-SCP0107-0526 | G1 | D00-4d-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-4d-002: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-002) |
| WK-SCP0107-0527 | G1 | SCP0107_CAPA_TEEP_Report.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SCP0107_CAPA_TEEP_Report.FindButton: 진입점 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0107_CAPA_TEEP_Report.FindButton:) |
| WK-SCP0107-0528 | G1 | SCP0107_CAPA_TEEP_Report.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SCP0107_CAPA_TEEP_Report.FindData: 진입점 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.FindData:16) |
| WK-SCP0107-0529 | G1 | SCP0107_CAPA_TEEP_Report.FindDataMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SCP0107_CAPA_TEEP_Report.FindDataMain: 진입점 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.FindDataMai) |
| WK-SCP0107-0530 | G1 | `Form_Load` 초기화 순서(cs:913~926, 생성자 배선) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `Form_Load` 초기화 순서(cs:913~926, 생성자 배선): 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (`Form_Load` 초기화 순서(cs:913~926, 생성자 배선)) |
| WK-SCP0107-0531 | G1 | `_currVersionProgressStatus != _2ND_CUTO | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `_currVersionProgressStatus != _2ND_CUTOFF` -> `MS: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (`_currVersionProgressStatus != _2ND_CUTO) |
| WK-SCP0107-0532 | G1 | – | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — –: 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0533 | G1 | 조회 결과 0건 시 색칠 미수행(cs:1519) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 조회 결과 0건 시 색칠 미수행(cs:1519): 행 집계 — G1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (조회 결과 0건 시 색칠 미수행(cs:1519)) |
| WK-SCP0107-0534 | G6 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 1: 행 집계 — G6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0535 | G6 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 10: 행 집계 — G6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (10) |
| WK-SCP0107-0536 | G6 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 2: 행 집계 — G6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0537 | G6 | 22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 22: 행 집계 — G6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (22) |
| WK-SCP0107-0538 | G6 | 24 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 24: 행 집계 — G6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (24) |
| WK-SCP0107-0539 | G6 | 25 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 25: 행 집계 — G6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (25) |
| WK-SCP0107-0540 | G6 | 26 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 26: 행 집계 — G6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (26) |
| WK-SCP0107-0541 | G6 | 27 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 27: 행 집계 — G6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (27) |
| WK-SCP0107-0542 | G6 | 28 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 28: 행 집계 — G6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (28) |
| WK-SCP0107-0543 | G6 | 29 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 29: 행 집계 — G6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (29) |
| WK-SCP0107-0544 | G6 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 3: 행 집계 — G6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0545 | G6 | 30 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 30: 행 집계 — G6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (30) |
| WK-SCP0107-0546 | G6 | 35 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 35: 행 집계 — G6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (35) |
| WK-SCP0107-0547 | G6 | 37 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 37: 행 집계 — G6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (37) |
| WK-SCP0107-0548 | G6 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 4: 행 집계 — G6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0549 | G6 | D00-1-035 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-1-035: 행 집계 — G6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-035) |
| WK-SCP0107-0550 | G6 | D00-1-037 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-1-037: 행 집계 — G6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-037) |
| WK-SCP0107-0551 | G6 | – | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — –: 행 집계 — G6 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0107-0552 | X-LOC | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (1) |
| WK-SCP0107-0553 | X-LOC | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 10: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (10) |
| WK-SCP0107-0554 | X-LOC | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 11: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (11) |
| WK-SCP0107-0555 | X-LOC | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (2) |
| WK-SCP0107-0556 | X-LOC | 23 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 23: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 0 () |
| WK-SCP0107-0557 | X-LOC | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (3) |
| WK-SCP0107-0558 | X-LOC | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (4) |
| WK-SCP0107-0559 | X-LOC | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (5) |
| WK-SCP0107-0560 | X-LOC | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 6: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (6) |
| WK-SCP0107-0561 | X-LOC | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 8: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (8) |
| WK-SCP0107-0562 | X-LOC | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 9: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (9) |
| WK-SCP0107-0563 | X-LOC | Designer `tabIndex` 숫자(5/7/8/9/30/48/50/ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Designer `tabIndex` 숫자(5/7/8/9/30/48/50/52): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Designer `tabIndex` 숫자(5/7/8/9/30/48/50/) |
| WK-SCP0107-0564 | X-LOC | Insert/Delete **메시지 재현** | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Insert/Delete **메시지 재현**: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Insert/Delete **메시지 재현**) |
| WK-SCP0107-0565 | X-LOC | SP 서버 정렬(`ORDER BY` 4단) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SP 서버 정렬(`ORDER BY` 4단): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SP 서버 정렬(`ORDER BY` 4단)) |
| WK-SCP0107-0566 | X-LOC | `DAY_CODE`/`SORT_ORDER_NO`(헤더 SP 반환) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `DAY_CODE`/`SORT_ORDER_NO`(헤더 SP 반환): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`DAY_CODE`/`SORT_ORDER_NO`(헤더 SP 반환)) |
| WK-SCP0107-0567 | X-LOC | `DefColumns` 29종 중 SP 미반환 4종(`NICK_NAME` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `DefColumns` 29종 중 SP 미반환 4종(`NICK_NAME`/`MSR_NVL`: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`DefColumns` 29종 중 SP 미반환 4종(`NICK_NAME`) |
| WK-SCP0107-0568 | X-LOC | `Form_Load` 초기화 순서(cs:913~926, 생성자 배선) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `Form_Load` 초기화 순서(cs:913~926, 생성자 배선): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`Form_Load` 초기화 순서(cs:913~926, 생성자 배선)) |
| WK-SCP0107-0569 | X-LOC | `InitEvent()` 가 `InitControls()` 뒤 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `InitEvent()` 가 `InitControls()` 뒤: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`InitEvent()` 가 `InitControls()` 뒤) |
| WK-SCP0107-0570 | X-LOC | `POPUP/SCP0107_CAPAReportPopup.cs`(479행) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `POPUP/SCP0107_CAPAReportPopup.cs`(479행): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`POPUP/SCP0107_CAPAReportPopup.cs`(479행)) |
| WK-SCP0107-0571 | X-LOC | `rgrpDivisionType` 초기 `-1` (L-19) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `rgrpDivisionType` 초기 `-1` (L-19): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`rgrpDivisionType` 초기 `-1` (L-19)) |
| WK-SCP0107-0572 | X-LOC | `spreadTitle` 시트명 규약 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `spreadTitle` 시트명 규약: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`spreadTitle` 시트명 규약) |
| WK-SCP0107-0573 | X-LOC | buttonGuards | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — buttonGuards: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (buttonGuards) |
| WK-SCP0107-0574 | X-LOC | comboCalls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — comboCalls: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (comboCalls) |
| WK-SCP0107-0575 | X-LOC | controls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — controls: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (controls) |
| WK-SCP0107-0576 | X-LOC | entryPoints | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — entryPoints: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (entryPoints) |
| WK-SCP0107-0577 | X-LOC | events | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — events: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (events) |
| WK-SCP0107-0578 | X-LOC | filterCalls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — filterCalls: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (filterCalls) |
| WK-SCP0107-0579 | X-LOC | gridSignals | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — gridSignals: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (gridSignals) |
| WK-SCP0107-0580 | X-LOC | popups | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — popups: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (popups) |
| WK-SCP0107-0581 | X-LOC | spCalls (+ 백본밖 1) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — spCalls (+ 백본밖 1): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (spCalls (+ 백본밖 1)) |
| WK-SCP0107-0582 | X-LOC | validations | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — validations: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (validations) |
| WK-SCP0107-0583 | X-LOC | – | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — –: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 0 () |
| WK-SCP0107-0584 | X-LOC | 데드 메서드 4종(`MergeKeyColumns` / `SetBaseTo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 데드 메서드 4종(`MergeKeyColumns` / `SetBaseToDateColumn: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (데드 메서드 4종(`MergeKeyColumns` / `SetBaseTo) |
| WK-SCP0107-0585 | X-LOC | 데드 핸들러 3종(`cboSheetType_` / `cboFromYYYY | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 데드 핸들러 3종(`cboSheetType_` / `cboFromYYYY_` / `spdM: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (데드 핸들러 3종(`cboSheetType_` / `cboFromYYYY) |
| WK-SCP0107-0586 | X-LOC | 라디오 -> 드롭다운 전환 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 라디오 -> 드롭다운 전환: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (라디오 -> 드롭다운 전환) |
| WK-SCP0107-0587 | X-LOC | 백본 밖 편입 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 백본 밖 편입: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (백본 밖 편입) |
| WK-SCP0107-0588 | X-LOC | 비율 measure `×100` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 비율 measure `×100`: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (비율 measure `×100`) |
| WK-SCP0107-0589 | X-LOC | 선언만 존재 필드(`_editableMeasures`/`_currMeas | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 선언만 존재 필드(`_editableMeasures`/`_currMeasureSet`/`_: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (선언만 존재 필드(`_editableMeasures`/`_currMeas) |
| WK-SCP0107-0590 | X-LOC | 숨겨진 Operation/Line Type 값 유지 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 숨겨진 Operation/Line Type 값 유지: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (숨겨진 Operation/Line Type 값 유지) |
| WK-SCP0107-0591 | X-LOC | 조회 결과 0건 시 색칠 미수행(cs:1519) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 조회 결과 0건 시 색칠 미수행(cs:1519): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (조회 결과 0건 시 색칠 미수행(cs:1519)) |
| WK-SCP0107-0592 | X-ROW | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 1: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 0 () |
| WK-SCP0107-0593 | X-ROW | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 2: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 0 () |
| WK-SCP0107-0594 | X-ROW | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 3: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 0 () |
| WK-SCP0107-0595 | X-ROW | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 4: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (4) |
| WK-SCP0107-0596 | X-ROW | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 5: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (5) |
| WK-SCP0107-0597 | X-ROW | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 6: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (6) |
| WK-SCP0107-0598 | X-ROW | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 8: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (8) |
| WK-SCP0107-0599 | X-ROW | D00-1-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-001: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-001) |
| WK-SCP0107-0600 | X-ROW | D00-1-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-002: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-002) |
| WK-SCP0107-0601 | X-ROW | D00-1-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-003: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-003) |
| WK-SCP0107-0602 | X-ROW | D00-1-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-004: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-004) |
| WK-SCP0107-0603 | X-ROW | D00-1-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-005: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-005) |
| WK-SCP0107-0604 | X-ROW | D00-1-016 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-016: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-016) |
| WK-SCP0107-0605 | X-ROW | D00-1-017 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-017: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-017) |
| WK-SCP0107-0606 | X-ROW | D00-1-018 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-018: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-018) |
| WK-SCP0107-0607 | X-ROW | D00-1-019 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-019: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-019) |
| WK-SCP0107-0608 | X-ROW | D00-1-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-024: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-024) |
| WK-SCP0107-0609 | X-ROW | D00-1-025 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-025: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-025) |
| WK-SCP0107-0610 | X-ROW | D00-1-026 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-026: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-026) |
| WK-SCP0107-0611 | X-ROW | D00-1-027 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-027: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-027) |
| WK-SCP0107-0612 | X-ROW | D00-1-028 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-028: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-028) |
| WK-SCP0107-0613 | X-ROW | D00-1-029 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-029: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-029) |
| WK-SCP0107-0614 | X-ROW | D00-1-030 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-030: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-030) |
| WK-SCP0107-0615 | X-ROW | D00-2-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-2-001: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-2-001) |
| WK-SCP0107-0616 | X-ROW | D00-3-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-005: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-005) |
| WK-SCP0107-0617 | X-ROW | D00-3-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-007: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-007) |
| WK-SCP0107-0618 | X-ROW | Designer `tabIndex` 숫자(5/7/8/9/30/48/50/ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — Designer `tabIndex` 숫자(5/7/8/9/30/48/50/52): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (Designer `tabIndex` 숫자(5/7/8/9/30/48/50/) |
| WK-SCP0107-0619 | X-ROW | SCP0107_CAPAReportPopup..ctor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPAReportPopup..ctor: 진입점 집계 2검사 — NOPATH:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0107_CAPAReportPopup..ctor:78:1 A) |
| WK-SCP0107-0620 | X-ROW | SCP0107_CAPAReportPopup.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPAReportPopup.CreateSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SCP0107_CAPAReportPopup.CreateSpread) |
| WK-SCP0107-0621 | X-ROW | SCP0107_CAPAReportPopup.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPAReportPopup.DefineProperty: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0107_CAPAReportPopup.DefineProper) |
| WK-SCP0107-0622 | X-ROW | SCP0107_CAPAReportPopup.Dispose | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPAReportPopup.Dispose: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0107_CAPAReportPopup.Dispose:16:1) |
| WK-SCP0107-0623 | X-ROW | SCP0107_CAPAReportPopup.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPAReportPopup.FindButton: 진입점 집계 4검사 — NOT_RUN:3 · REVIEW:1 |  | 2 (ACT:SCP0107_CAPAReportPopup.FindButton A) |
| WK-SCP0107-0624 | X-ROW | SCP0107_CAPAReportPopup.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPAReportPopup.FindData: 진입점 집계 8검사 — NOT_RUN:6 · REVIEW:1 · NOPATH:1 |  | 19 (ACT:SCP0107_CAPAReportPopup.FindData ACT) |
| WK-SCP0107-0625 | X-ROW | SCP0107_CAPAReportPopup.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPAReportPopup.Form_Load: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SCP0107_CAPAReportPopup.Form_Load AC) |
| WK-SCP0107-0626 | X-ROW | SCP0107_CAPAReportPopup.GetTitleSet | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPAReportPopup.GetTitleSet: 진입점 집계 4검사 — NOT_RUN:3 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SCP0107_CAPAReportPopup.GetTitleSet ) |
| WK-SCP0107-0627 | X-ROW | SCP0107_CAPAReportPopup.InitControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPAReportPopup.InitControl: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SCP0107_CAPAReportPopup.InitControl ) |
| WK-SCP0107-0628 | X-ROW | SCP0107_CAPAReportPopup.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPAReportPopup.InitSpread: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 9 (ACT:SCP0107_CAPAReportPopup.InitSpread A) |
| WK-SCP0107-0629 | X-ROW | SCP0107_CAPAReportPopup.IsFixedColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPAReportPopup.IsFixedColumn: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SCP0107_CAPAReportPopup.IsFixedColum) |
| WK-SCP0107-0630 | X-ROW | SCP0107_CAPAReportPopup.ResetWidth | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPAReportPopup.ResetWidth: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 11 (ACT:SCP0107_CAPAReportPopup.ResetWidth A) |
| WK-SCP0107-0631 | X-ROW | SCP0107_CAPAReportPopup.SetFixColumnStat | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPAReportPopup.SetFixColumnStatus: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SCP0107_CAPAReportPopup.SetFixColumn) |
| WK-SCP0107-0632 | X-ROW | SCP0107_CAPAReportPopup.SetTitleSet | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPAReportPopup.SetTitleSet: 진입점 집계 2검사 — NOT_RUN:1 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 73 (ACT:SCP0107_CAPAReportPopup.SetTitleSet ) |
| WK-SCP0107-0633 | X-ROW | SCP0107_CAPAReportPopup.btnLeft_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPAReportPopup.btnLeft_Click: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0107_CAPAReportPopup.btnLeft_Clic) |
| WK-SCP0107-0634 | X-ROW | SCP0107_CAPAReportPopup.btnRight_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPAReportPopup.btnRight_Click: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0107_CAPAReportPopup.btnRight_Cli) |
| WK-SCP0107-0635 | X-ROW | SCP0107_CAPA_TEEP_Report.AfterFindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.AfterFindData: 진입점 집계 1검사 — NOPATH:1 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SCP0107_CAPA_TEEP_Report.AfterFindDa) |
| WK-SCP0107-0636 | X-ROW | SCP0107_CAPA_TEEP_Report.BeforeFindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.BeforeFindData: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0107_CAPA_TEEP_Report.BeforeFindD) |
| WK-SCP0107-0637 | X-ROW | SCP0107_CAPA_TEEP_Report.ChangeColumnNam | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.ChangeColumnNameToCodeNam: 진입점 동작 재현 시나리오 필요 — 문장 종류 DATA_OP/ENTRY/GRID_SET, 연결된 요소 검사 없음 |  | 5 (ACT:SCP0107_CAPA_TEEP_Report.ChangeColum) |
| WK-SCP0107-0638 | X-ROW | SCP0107_CAPA_TEEP_Report.CheckChangedVal | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.CheckChangedValues: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/DATA_OP/ENTRY/EXPR/FLOW/LOCAL/RETURN, |  | 18 (ACT:SCP0107_CAPA_TEEP_Report.CheckChange) |
| WK-SCP0107-0639 | X-ROW | SCP0107_CAPA_TEEP_Report.ClearUsrChecked | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.ClearUsrCheckedList: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/LIST_REBIND/STATE_RESET, 연결된 요 |  | 4 (ACT:SCP0107_CAPA_TEEP_Report.ClearUsrChe) |
| WK-SCP0107-0640 | X-ROW | SCP0107_CAPA_TEEP_Report.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.CreateSprea) |
| WK-SCP0107-0641 | X-ROW | SCP0107_CAPA_TEEP_Report.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.FindButton: 진입점 집계 6검사 — NOT_RUN:4 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.FindButton ) |
| WK-SCP0107-0642 | X-ROW | SCP0107_CAPA_TEEP_Report.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.FindData: 진입점 집계 4검사 — NOPATH:2 · NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.FindData) |
| WK-SCP0107-0643 | X-ROW | SCP0107_CAPA_TEEP_Report.FindDataMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.FindDataMain: 진입점 집계 5검사 — NOPATH:3 · NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.FindDataMai) |
| WK-SCP0107-0644 | X-ROW | SCP0107_CAPA_TEEP_Report.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.Form_Load) |
| WK-SCP0107-0645 | X-ROW | SCP0107_CAPA_TEEP_Report.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.InitControls: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.InitControl) |
| WK-SCP0107-0646 | X-ROW | SCP0107_CAPA_TEEP_Report.InitDatasAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.InitDatasAll: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.InitDatasAl) |
| WK-SCP0107-0647 | X-ROW | SCP0107_CAPA_TEEP_Report.InitQueryDics | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.InitQueryDics: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.InitQueryDi) |
| WK-SCP0107-0648 | X-ROW | SCP0107_CAPA_TEEP_Report.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.InitSpread ) |
| WK-SCP0107-0649 | X-ROW | SCP0107_CAPA_TEEP_Report.MergeKeyColumns | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.MergeKeyColumns: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/DATA_OP/ENTRY/EXPR/GRID_INIT/LO |  | 14 (ACT:SCP0107_CAPA_TEEP_Report.MergeKeyCol) |
| WK-SCP0107-0650 | X-ROW | SCP0107_CAPA_TEEP_Report.RefreshAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.RefreshAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 7 (ACT:SCP0107_CAPA_TEEP_Report.RefreshAll ) |
| WK-SCP0107-0651 | X-ROW | SCP0107_CAPA_TEEP_Report.RefreshAllPre | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.RefreshAllPre: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 8 (ACT:SCP0107_CAPA_TEEP_Report.RefreshAllP) |
| WK-SCP0107-0652 | X-ROW | SCP0107_CAPA_TEEP_Report.RefreshDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.RefreshDivision: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.RefreshDivi) |
| WK-SCP0107-0653 | X-ROW | SCP0107_CAPA_TEEP_Report.RefreshElectrod | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.RefreshElectrodeAssemblyA: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/DATA_OP/ENTRY, 연결 |  | 5 (ACT:SCP0107_CAPA_TEEP_Report.RefreshElec) |
| WK-SCP0107-0654 | X-ROW | SCP0107_CAPA_TEEP_Report.RefreshElectrod | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.RefreshElectrodeType: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SCP0107_CAPA_TEEP_Report.RefreshElec) |
| WK-SCP0107-0655 | X-ROW | SCP0107_CAPA_TEEP_Report.RefreshElectrod | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.RefreshElectrodeTypeAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0107_CAPA_TEEP_Report.RefreshElec) |
| WK-SCP0107-0656 | X-ROW | SCP0107_CAPA_TEEP_Report.RefreshElectrod | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.RefreshElectrodeeEltrAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/COMBO_DATA/DATA_OP/ENTRY/LOCA |  | 5 (ACT:SCP0107_CAPA_TEEP_Report.RefreshElec) |
| WK-SCP0107-0657 | X-ROW | SCP0107_CAPA_TEEP_Report.RefreshFactory | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.RefreshFactory: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0107_CAPA_TEEP_Report.RefreshFact) |
| WK-SCP0107-0658 | X-ROW | SCP0107_CAPA_TEEP_Report.RefreshFactoryA | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.RefreshFactoryAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0107_CAPA_TEEP_Report.RefreshFact) |
| WK-SCP0107-0659 | X-ROW | SCP0107_CAPA_TEEP_Report.RefreshLine | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.RefreshLine: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 34 (ACT:SCP0107_CAPA_TEEP_Report.RefreshLine) |
| WK-SCP0107-0660 | X-ROW | SCP0107_CAPA_TEEP_Report.RefreshLineAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.RefreshLineAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0107_CAPA_TEEP_Report.RefreshLine) |
| WK-SCP0107-0661 | X-ROW | SCP0107_CAPA_TEEP_Report.RefreshOperatio | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.RefreshOperation: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 11 (ACT:SCP0107_CAPA_TEEP_Report.RefreshOper) |
| WK-SCP0107-0662 | X-ROW | SCP0107_CAPA_TEEP_Report.RefreshOperatio | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.RefreshOperationAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/DATA_OP/ENTRY, 연결된 요소 검 |  | 5 (ACT:SCP0107_CAPA_TEEP_Report.RefreshOper) |
| WK-SCP0107-0663 | X-ROW | SCP0107_CAPA_TEEP_Report.RefreshPlanType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.RefreshPlanType: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/VALUE_SET, 연결된 요소 검사 없음 |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.RefreshPlan) |
| WK-SCP0107-0664 | X-ROW | SCP0107_CAPA_TEEP_Report.RefreshPlant | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.RefreshPlant: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0107_CAPA_TEEP_Report.RefreshPlan) |
| WK-SCP0107-0665 | X-ROW | SCP0107_CAPA_TEEP_Report.RefreshPlantAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.RefreshPlantAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0107_CAPA_TEEP_Report.RefreshPlan) |
| WK-SCP0107-0666 | X-ROW | SCP0107_CAPA_TEEP_Report.RefreshSheetHea | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.RefreshSheetHeader: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY/GRID_INIT/LOCAL, 연 |  | 9 (ACT:SCP0107_CAPA_TEEP_Report.RefreshShee) |
| WK-SCP0107-0667 | X-ROW | SCP0107_CAPA_TEEP_Report.RefreshSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.RefreshSite: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0107_CAPA_TEEP_Report.RefreshSite) |
| WK-SCP0107-0668 | X-ROW | SCP0107_CAPA_TEEP_Report.RefreshSiteAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.RefreshSiteAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0107_CAPA_TEEP_Report.RefreshSite) |
| WK-SCP0107-0669 | X-ROW | SCP0107_CAPA_TEEP_Report.RefreshVersion | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.RefreshVersion: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0107_CAPA_TEEP_Report.RefreshVers) |
| WK-SCP0107-0670 | X-ROW | SCP0107_CAPA_TEEP_Report.RefreshVersionS | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.RefreshVersionSeq: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0107_CAPA_TEEP_Report.RefreshVers) |
| WK-SCP0107-0671 | X-ROW | SCP0107_CAPA_TEEP_Report.SetBaseToDateCo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.SetBaseToDateColumns: 진입점 집계 4검사 — NOT_RUN:2 · REVIEW:2 |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.SetBaseToDa) |
| WK-SCP0107-0672 | X-ROW | SCP0107_CAPA_TEEP_Report.SetQueryInfoGet | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.SetQueryInfoGet: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0107_CAPA_TEEP_Report.SetQueryInf) |
| WK-SCP0107-0673 | X-ROW | SCP0107_CAPA_TEEP_Report.SetSheetMerge | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.SetSheetMerge: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0107_CAPA_TEEP_Report.SetSheetMer) |
| WK-SCP0107-0674 | X-ROW | SCP0107_CAPA_TEEP_Report.SetSheetNumeric | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.SetSheetNumericColumnForm: 진입점 집계 4검사 — REVIEW:2 · NOT_RUN:2 |  | 5 (ACT:SCP0107_CAPA_TEEP_Report.SetSheetNum) |
| WK-SCP0107-0675 | X-ROW | SCP0107_CAPA_TEEP_Report.SetVisibleElect | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.SetVisibleElectrodeType: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0107_CAPA_TEEP_Report.SetVisibleE) |
| WK-SCP0107-0676 | X-ROW | SCP0107_CAPA_TEEP_Report.SetVisibleOpera | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.SetVisibleOperation: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0107_CAPA_TEEP_Report.SetVisibleO) |
| WK-SCP0107-0677 | X-ROW | SCP0107_CAPA_TEEP_Report.btnColumn_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.btnColumn_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0107_CAPA_TEEP_Report.btnColumn_C) |
| WK-SCP0107-0678 | X-ROW | SCP0107_CAPA_TEEP_Report.cboFromYYYY_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.cboFromYYYY_SelectedIndex: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.cboFromYYYY) |
| WK-SCP0107-0679 | X-ROW | SCP0107_CAPA_TEEP_Report.cboSheetType_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.cboSheetType_SelectedInde: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.cboSheetTyp) |
| WK-SCP0107-0680 | X-ROW | SCP0107_CAPA_TEEP_Report.cboVersionSeq_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.cboVersionSeq_SelectedInd: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.cboVersionS) |
| WK-SCP0107-0681 | X-ROW | SCP0107_CAPA_TEEP_Report.cboVersion_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.cboVersion_SelectedIndexC: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.cboVersion_) |
| WK-SCP0107-0682 | X-ROW | SCP0107_CAPA_TEEP_Report.clbDivision_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.clbDivision_SelectedIndex: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.clbDivision) |
| WK-SCP0107-0683 | X-ROW | SCP0107_CAPA_TEEP_Report.clbFactory_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.clbFactory_SelectedIndexC: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.clbFactory_) |
| WK-SCP0107-0684 | X-ROW | SCP0107_CAPA_TEEP_Report.clbLine_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.clbLine_SelectedIndexChan: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.clbLine_Sel) |
| WK-SCP0107-0685 | X-ROW | SCP0107_CAPA_TEEP_Report.clbOperation_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.clbOperation_SelectedInde: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.clbOperatio) |
| WK-SCP0107-0686 | X-ROW | SCP0107_CAPA_TEEP_Report.clbPlant_Select | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.clbPlant_SelectedIndexCha: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.clbPlant_Se) |
| WK-SCP0107-0687 | X-ROW | SCP0107_CAPA_TEEP_Report.clbSite_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.clbSite_SelectedIndexChan: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.clbSite_Sel) |
| WK-SCP0107-0688 | X-ROW | SCP0107_CAPA_TEEP_Report.getPlanType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.getPlanType: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.getPlanType) |
| WK-SCP0107-0689 | X-ROW | SCP0107_CAPA_TEEP_Report.getShopGroup | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.getShopGroup: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.getShopGrou) |
| WK-SCP0107-0690 | X-ROW | SCP0107_CAPA_TEEP_Report.rgrpDivisionTyp | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0107_CAPA_TEEP_Report.rgrpDivisionType_Selected: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0107_CAPA_TEEP_Report.rgrpDivisio) |
| WK-SCP0107-0691 | X-ROW | SP 서버 정렬(`ORDER BY` 4단) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SP 서버 정렬(`ORDER BY` 4단): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (SP 서버 정렬(`ORDER BY` 4단)) |
| WK-SCP0107-0692 | X-ROW | `DAY_CODE`/`SORT_ORDER_NO`(헤더 SP 반환) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `DAY_CODE`/`SORT_ORDER_NO`(헤더 SP 반환): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`DAY_CODE`/`SORT_ORDER_NO`(헤더 SP 반환)) |
| WK-SCP0107-0693 | X-ROW | `InitEvent()` 가 `InitControls()` 뒤 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `InitEvent()` 가 `InitControls()` 뒤: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`InitEvent()` 가 `InitControls()` 뒤) |
| WK-SCP0107-0694 | X-ROW | buttonGuards | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — buttonGuards: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (buttonGuards) |
| WK-SCP0107-0695 | X-ROW | comboCalls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — comboCalls: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (comboCalls) |
| WK-SCP0107-0696 | X-ROW | controls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — controls: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (controls) |
| WK-SCP0107-0697 | X-ROW | entryPoints | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — entryPoints: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (entryPoints) |
| WK-SCP0107-0698 | X-ROW | events | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — events: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (events) |
| WK-SCP0107-0699 | X-ROW | filterCalls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — filterCalls: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (filterCalls) |
| WK-SCP0107-0700 | X-ROW | gridSignals | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — gridSignals: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (gridSignals) |
| WK-SCP0107-0701 | X-ROW | spCalls (+ 백본밖 1) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — spCalls (+ 백본밖 1): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (spCalls (+ 백본밖 1)) |
| WK-SCP0107-0702 | X-ROW | 라디오 -> 드롭다운 전환 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 라디오 -> 드롭다운 전환: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (라디오 -> 드롭다운 전환) |
| WK-SCP0107-0703 | X-ROW | 백본 밖 편입 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 백본 밖 편입: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (백본 밖 편입) |
| WK-SCP0107-0704 | X-ROW | 선언만 존재 필드(`_editableMeasures`/`_currMeas | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 선언만 존재 필드(`_editableMeasures`/`_currMeasureSet`/`_: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (선언만 존재 필드(`_editableMeasures`/`_currMeas) |
| WK-SCP0107-0705 | X-ROW | 숨겨진 Operation/Line Type 값 유지 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 숨겨진 Operation/Line Type 값 유지: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (숨겨진 Operation/Line Type 값 유지) |
| WK-SCP0107-0706 | G5 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — 9: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (9) |
| WK-SCP0107-0707 | G5 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-4b-001: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-001) |
| WK-SCP0107-0708 | G5 | D00-4c-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-4c-001: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4c-001) |
| WK-SCP0107-0709 | G5 | D00-4c-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-4c-002: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4c-002) |
| WK-SCP0107-0710 | G5 | D00-4c-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-4c-003: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4c-003) |
| WK-SCP0107-0711 | G5 | D00-4c-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-4c-004: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4c-004) |
| WK-SCP0107-0712 | G5 | D00-4d-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-4d-001: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-001) |
| WK-SCP0107-0713 | G5 | D00-4d-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-4d-002: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-002) |
| WK-SCP0107-0714 | G5 | D00-4e-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-4e-001: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-001) |
| WK-SCP0107-0715 | G5 | MODAL:CapaTeepReportColumnModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MODAL:CapaTeepReportColumnModal: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:CapaTeepReportColumnModal) |
| WK-SCP0107-0716 | G5 | `SCM002_CAPAColumnPopup("SCP0107", _divi | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — `SCM002_CAPAColumnPopup("SCP0107", _division_type_: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (`SCM002_CAPAColumnPopup("SCP0107", _divi) |
| WK-SCP0107-0717 | G5 | popups | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — popups: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (popups) |
| WK-SCP0107-0718 | H6 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — 9: 행 집계 — H6 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (9) |
| WK-SCP0107-0719 | H6 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-4b-001: 행 집계 — H6 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-001) |
| WK-SCP0107-0720 | H6 | D00-4c-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-4c-001: 행 집계 — H6 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4c-001) |
| WK-SCP0107-0721 | H6 | D00-4c-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-4c-002: 행 집계 — H6 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4c-002) |
| WK-SCP0107-0722 | H6 | D00-4c-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-4c-003: 행 집계 — H6 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4c-003) |
| WK-SCP0107-0723 | H6 | D00-4c-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-4c-004: 행 집계 — H6 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4c-004) |
| WK-SCP0107-0724 | H6 | D00-4d-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-4d-001: 행 집계 — H6 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-001) |
| WK-SCP0107-0725 | H6 | D00-4d-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-4d-002: 행 집계 — H6 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-002) |
| WK-SCP0107-0726 | H6 | D00-4e-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-4e-001: 행 집계 — H6 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-001) |
| WK-SCP0107-0727 | H6 | MODAL:CapaTeepReportColumnModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MODAL:CapaTeepReportColumnModal: 행 집계 — H6 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:CapaTeepReportColumnModal) |
| WK-SCP0107-0728 | H6 | `SCM002_CAPAColumnPopup("SCP0107", _divi | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — `SCM002_CAPAColumnPopup("SCP0107", _division_type_: 행 집계 — H6 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (`SCM002_CAPAColumnPopup("SCP0107", _divi) |
| WK-SCP0107-0729 | H6 | popups | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — popups: 행 집계 — H6 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (popups) |
| WK-SCP0107-0730 | M3 | D00-4e-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M3 기대값 확정 — D00-4e-001: 행 집계 — M3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-001) |
| WK-SCP0107-0731 | M4 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 9: 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (9) |
| WK-SCP0107-0732 | M4 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-4b-001: 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-001) |
| WK-SCP0107-0733 | M4 | D00-4c-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-4c-001: 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4c-001) |
| WK-SCP0107-0734 | M4 | D00-4c-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-4c-002: 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4c-002) |
| WK-SCP0107-0735 | M4 | D00-4c-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-4c-003: 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4c-003) |
| WK-SCP0107-0736 | M4 | D00-4c-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-4c-004: 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4c-004) |
| WK-SCP0107-0737 | M4 | D00-4d-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-4d-001: 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-001) |
| WK-SCP0107-0738 | M4 | D00-4d-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-4d-002: 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-002) |
| WK-SCP0107-0739 | M4 | D00-4e-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-4e-001: 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-001) |
| WK-SCP0107-0740 | M4 | MODAL:CapaTeepReportColumnModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MODAL:CapaTeepReportColumnModal: 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:CapaTeepReportColumnModal) |
| WK-SCP0107-0741 | M4 | `SCM002_CAPAColumnPopup("SCP0107", _divi | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — `SCM002_CAPAColumnPopup("SCP0107", _division_type_: 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`SCM002_CAPAColumnPopup("SCP0107", _divi) |
| WK-SCP0107-0742 | M4 | popups | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — popups: 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (popups) |
