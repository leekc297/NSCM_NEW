# 작업 원장 — SCP0108 · 2026-10-26 12:55

> 검사 인스턴스 522건 중 PASS·NA 124건 외 **398건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 4 | 구현 위치 실존 |
| W4 | 검사기 구현 | 22 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 32 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 63 | 실행 → PASS |
| W7 | 기대값 확정 | 277 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 277 · E2E 63 · 하네스 54 · 대조표 4
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 1건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 83 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| X-LOC | GEN |  | 4 |  |  |  |  | 51 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| B3 | COMBO |  |  |  | 22 |  |  | 26 |  |  | 콤보 후보 정렬 = AS-IS |
| B4 | COMBO |  |  |  |  | 22 |  | 26 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| G1 | GEN |  |  |  |  |  | 2 | 21 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| E4 | EDIT |  |  |  |  |  | 12 | 7 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| H2 | DESIGN |  |  |  |  |  | 1 | 17 |  |  | 배경·글자색 규칙 |
| G4 | DESIGN |  |  |  |  | 2 | 9 | 3 |  |  | 조회조건 표시·라벨·활성 |
| A5 | DESIGN |  |  |  |  |  | 1 | 12 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H5 | DESIGN |  |  |  |  |  | 1 | 12 |  |  | 라벨 명칭 |
| C1 | CASCADE |  |  |  |  |  | 11 | 1 |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| G6 | GEN |  |  |  |  |  | 9 | 3 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| F4 | DB |  |  |  |  |  | 1 | 6 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| G5 | POPUP |  |  |  |  | 3 |  | 3 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 2 | 1 | 3 |  |  | 팝업 표준·열림 |
| M4 | POPUP |  |  |  |  |  | 3 | 3 |  |  | 팝업 선택값 반영 |
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

## W2 구현 위치 확인 (4)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0108-0001 | X-LOC | (1) **Division 권한 0건** | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 ((1) **Division 권한 0건**) |
| WK-SCP0108-0002 | X-LOC | (2) **버튼 ACL** | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 ((2) **버튼 ACL**) |
| WK-SCP0108-0003 | X-LOC | (3) **시트 잠금** | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 ((3) **시트 잠금**) |
| WK-SCP0108-0004 | X-LOC | spCalls | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: procedures.d.ts 없음 |  | 1 (spCalls) |

## W4 검사기 구현 (22)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0108-0005 | B3 | COMPANY_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 COMPANY_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrCompa) |
| WK-SCP0108-0006 | B3 | DIVISION_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 DIVISION_ID | 있음(SHEET_COLUMNS) | 4 (ACT:SCP0108_CAPA_LOB_Report.GetCurrVersi) |
| WK-SCP0108-0007 | B3 | ELTR_LN_TP_CD | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 ELTR_LN_TP_CD | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrElect) |
| WK-SCP0108-0008 | B3 | FACTORY_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 FACTORY_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrFacto) |
| WK-SCP0108-0009 | B3 | LINE_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 LINE_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrLine ) |
| WK-SCP0108-0010 | B3 | NICK_NAME | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 NICK_NAME | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrNickn) |
| WK-SCP0108-0011 | B3 | OPERATION_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 OPERATION_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrOpera) |
| WK-SCP0108-0012 | B3 | PLANT_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 PLANT_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrPlant) |
| WK-SCP0108-0013 | B3 | SITE_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 SITE_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrSite ) |
| WK-SCP0108-0014 | B3 | cboBottleneck / Bottleneck | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboBottleneck / Bottleneck | 있음(FE 소스) | 2 (ACT:SCP0108_CAPA_LOB_Report.getBottlenec) |
| WK-SCP0108-0015 | B3 | cboDivision / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboDivision / Division | 있음(FE 소스) | 2 (ACT:SCP0108_CAPA_LOB_Report.getDivision ) |
| WK-SCP0108-0016 | B3 | cboProgressStatus / Status / Progress St | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboProgressStatus / Status / Progress Status | 있음(FE 소스) | 2 (ACT:SCP0108_CAPA_LOB_Report.getProgressS) |
| WK-SCP0108-0017 | B3 | cboVersion / Plan Month / Version / Ver. | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboVersion / Plan Month / Version / Ver. | 있음(FE 소스) | 3 (ACT:SCP0108_CAPA_LOB_Report.getVersion A) |
| WK-SCP0108-0018 | B3 | cboVersionSeq / Version / Version Seq /  | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboVersionSeq / Version / Version Seq / Ver. | 있음(FE 소스) | 2 (ACT:SCP0108_CAPA_LOB_Report.getVersionSe) |
| WK-SCP0108-0019 | B3 | clbElectrodeType / Line Type / Electrode | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbElectrodeType / Line Type / Electrode Type | 있음(FE 소스) | 2 (ACT:SCP0108_CAPA_LOB_Report.getElectrode) |
| WK-SCP0108-0020 | B3 | clbFactory / Building / Factory | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbFactory / Building / Factory | 있음(FE 소스) | 2 (ACT:SCP0108_CAPA_LOB_Report.getFactory A) |
| WK-SCP0108-0021 | B3 | clbLine / Line | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbLine / Line | 있음(FE 소스) | 2 (ACT:SCP0108_CAPA_LOB_Report.getLine ACT:) |
| WK-SCP0108-0022 | B3 | clbOperation / Operation | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbOperation / Operation | 있음(FE 소스) | 2 (ACT:SCP0108_CAPA_LOB_Report.getOperation) |
| WK-SCP0108-0023 | B3 | clbPlant / Plant | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbPlant / Plant | 있음(FE 소스) | 2 (ACT:SCP0108_CAPA_LOB_Report.getPlant ACT) |
| WK-SCP0108-0024 | B3 | clbSite / Site | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbSite / Site | 있음(FE 소스) | 2 (ACT:SCP0108_CAPA_LOB_Report.getSite ACT:) |
| WK-SCP0108-0025 | B3 | rgrpDivisionType / Division Type | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 rgrpDivisionType / Division Type | 있음(FE 소스) | 2 (ACT:SCP0108_CAPA_LOB_Report.getDivisionT) |
| WK-SCP0108-0026 | B3 | txtItem / Basic Nickname / Item | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 txtItem / Basic Nickname / Item | 있음(FE 소스) | 2 (ACT:SCP0108_CAPA_LOB_Report.getItemId AC) |

## W5 검사기 연결 (32)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0108-0027 | B4 | COMPANY_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL COMPANY_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrCompa) |
| WK-SCP0108-0028 | B4 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 4 (ACT:SCP0108_CAPA_LOB_Report.GetCurrVersi) |
| WK-SCP0108-0029 | B4 | ELTR_LN_TP_CD | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL ELTR_LN_TP_CD | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrElect) |
| WK-SCP0108-0030 | B4 | FACTORY_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL FACTORY_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrFacto) |
| WK-SCP0108-0031 | B4 | LINE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL LINE_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrLine ) |
| WK-SCP0108-0032 | B4 | NICK_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL NICK_NAME | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrNickn) |
| WK-SCP0108-0033 | B4 | OPERATION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL OPERATION_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrOpera) |
| WK-SCP0108-0034 | B4 | PLANT_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL PLANT_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrPlant) |
| WK-SCP0108-0035 | B4 | SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL SITE_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrSite ) |
| WK-SCP0108-0036 | B4 | cboBottleneck / Bottleneck | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboBottleneck / Bottleneck | 있음(FE 소스) | 2 (ACT:SCP0108_CAPA_LOB_Report.getBottlenec) |
| WK-SCP0108-0037 | B4 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 2 (ACT:SCP0108_CAPA_LOB_Report.getDivision ) |
| WK-SCP0108-0038 | B4 | cboProgressStatus / Status / Progress St | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboProgressStatus / Status / Progress Status | 있음(FE 소스) | 2 (ACT:SCP0108_CAPA_LOB_Report.getProgressS) |
| WK-SCP0108-0039 | B4 | cboVersion / Plan Month / Version / Ver. | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboVersion / Plan Month / Version / Ver. | 있음(FE 소스) | 3 (ACT:SCP0108_CAPA_LOB_Report.getVersion A) |
| WK-SCP0108-0040 | B4 | cboVersionSeq / Version / Version Seq /  | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboVersionSeq / Version / Version Seq / Ver. | 있음(FE 소스) | 2 (ACT:SCP0108_CAPA_LOB_Report.getVersionSe) |
| WK-SCP0108-0041 | B4 | clbElectrodeType / Line Type / Electrode | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbElectrodeType / Line Type / Electrode Type | 있음(FE 소스) | 2 (ACT:SCP0108_CAPA_LOB_Report.getElectrode) |
| WK-SCP0108-0042 | B4 | clbFactory / Building / Factory | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbFactory / Building / Factory | 있음(FE 소스) | 2 (ACT:SCP0108_CAPA_LOB_Report.getFactory A) |
| WK-SCP0108-0043 | B4 | clbLine / Line | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbLine / Line | 있음(FE 소스) | 2 (ACT:SCP0108_CAPA_LOB_Report.getLine ACT:) |
| WK-SCP0108-0044 | B4 | clbOperation / Operation | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbOperation / Operation | 있음(FE 소스) | 2 (ACT:SCP0108_CAPA_LOB_Report.getOperation) |
| WK-SCP0108-0045 | B4 | clbPlant / Plant | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbPlant / Plant | 있음(FE 소스) | 2 (ACT:SCP0108_CAPA_LOB_Report.getPlant ACT) |
| WK-SCP0108-0046 | B4 | clbSite / Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbSite / Site | 있음(FE 소스) | 2 (ACT:SCP0108_CAPA_LOB_Report.getSite ACT:) |
| WK-SCP0108-0047 | B4 | rgrpDivisionType / Division Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND rgrpDivisionType / Division Type | 있음(FE 소스) | 2 (ACT:SCP0108_CAPA_LOB_Report.getDivisionT) |
| WK-SCP0108-0048 | B4 | txtItem / Basic Nickname / Item | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND txtItem / Basic Nickname / Item | 있음(FE 소스) | 2 (ACT:SCP0108_CAPA_LOB_Report.getItemId AC) |
| WK-SCP0108-0049 | F2 | SCP0108 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0108 화면 | 판단불가(대상 단위 SCREEN) | 2 ((3) **시트 잠금** `useProcMutation`/`useSave) |
| WK-SCP0108-0050 | F6 | SCP0108 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0108 화면 | 판단불가(대상 단위 SCREEN) | 1 (`useProcMutation`/`useSaveWithValidation) |
| WK-SCP0108-0051 | G4 | btnItem | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItem | 없음 | 2 (ACT:SCP0108_CAPA_LOB_Report.InitEvent AC) |
| WK-SCP0108-0052 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 있음(FE 소스) | 2 (ACT:SCP0108_CAPA_LOB_Report.InitEvent AC) |
| WK-SCP0108-0053 | G03-WIRE | SCP0108 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0108 화면 | 판단불가(대상 단위 SCREEN) | 15 (ACT:SCP0108_CAPA_LOB_Report..ctor ACT:SC) |
| WK-SCP0108-0054 | G5 | btnColumn | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnColumn | 있음(FE 소스) | 1 (`components/modals/CapaLobReportColumnMo) |
| WK-SCP0108-0055 | G5 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnItemId | 있음(FE 소스) | 0 () |
| WK-SCP0108-0056 | G5 | txtItem / Basic Nickname / Item | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND txtItem / Basic Nickname / Item | 있음(FE 소스) | 0 () |
| WK-SCP0108-0057 | H6 | btnColumn | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnColumn | 있음(FE 소스) | 1 (`components/modals/CapaLobReportColumnMo) |
| WK-SCP0108-0058 | H6 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnItemId | 있음(FE 소스) | 0 () |

## W6 검증 실행 (63)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0108-0059 | J2 | SCP0108 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0108 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 37 (validations gridSignals entryPoints butt) |
| WK-SCP0108-0060 | C1 | cboBottleneck / Bottleneck | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboBottleneck / Bottleneck · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0108_CAPA_LOB_Report.RefreshBottl) |
| WK-SCP0108-0061 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0108_CAPA_LOB_Report.RefreshDivis) |
| WK-SCP0108-0062 | C1 | cboProgressStatus / Status / Progress St | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboProgressStatus / Status / Progress Status · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0108_CAPA_LOB_Report.RefreshProgr) |
| WK-SCP0108-0063 | C1 | cboVersion / Plan Month / Version / Ver. | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboVersion / Plan Month / Version / Ver. · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0108_CAPA_LOB_Report.RefreshVersi) |
| WK-SCP0108-0064 | C1 | cboVersionSeq / Version / Version Seq /  | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboVersionSeq / Version / Version Seq / Ver. · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0108_CAPA_LOB_Report.RefreshVersi) |
| WK-SCP0108-0065 | C1 | clbElectrodeType / Line Type / Electrode | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbElectrodeType / Line Type / Electrode Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0108_CAPA_LOB_Report.RefreshElect) |
| WK-SCP0108-0066 | C1 | clbFactory / Building / Factory | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbFactory / Building / Factory · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0108_CAPA_LOB_Report.RefreshFacto) |
| WK-SCP0108-0067 | C1 | clbLine / Line | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbLine / Line · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0108_CAPA_LOB_Report.RefreshLine:) |
| WK-SCP0108-0068 | C1 | clbOperation / Operation | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbOperation / Operation · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0108_CAPA_LOB_Report.RefreshOpera) |
| WK-SCP0108-0069 | C1 | clbPlant / Plant | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbPlant / Plant · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0108_CAPA_LOB_Report.RefreshPlant) |
| WK-SCP0108-0070 | C1 | clbSite / Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbSite / Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0108_CAPA_LOB_Report.RefreshSite:) |
| WK-SCP0108-0071 | G3 | SCP0108 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0108 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 1 (`components/CapaLobReportForm.tsx`) |
| WK-SCP0108-0072 | K-SA | SCP0108 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCP0108 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 1 (`components/CapaLobReportForm.tsx`) |
| WK-SCP0108-0073 | K4 | SCP0108 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0108 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 9 (ACT:SCP0108_CAPA_LOB_Report.btnColumn_Cl) |
| WK-SCP0108-0074 | F1 | SCP0108 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0108 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 23 (gridSignals entryPoints buttonGuards `Ca) |
| WK-SCP0108-0075 | F5 | SCP0108 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0108 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 22 (gridSignals entryPoints buttonGuards `Ca) |
| WK-SCP0108-0076 | F4 | PKG_SCP0104.P_SCP0104_GET_SPREAD_TITLE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0104.P_SCP0104_GET_SPREAD_TITLE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 2 (ACT:SCP0108_CAPA_LOB_Report.GetSpdTitle:) |
| WK-SCP0108-0077 | A5 | ELTR_LN_TP_CD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ELTR_LN_TP_CD · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (G1 `frozenColumns={1}` 하드코딩) |
| WK-SCP0108-0078 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0108_CAPA_LOB_Report.InitEvent AC) |
| WK-SCP0108-0079 | G4 | cboVersion / Plan Month / Version / Ver. | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboVersion / Plan Month / Version / Ver. · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0108_CAPA_LOB_Report.InitEvent AC) |
| WK-SCP0108-0080 | G4 | cboVersionSeq / Version / Version Seq /  | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboVersionSeq / Version / Version Seq / Ver. · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0108_CAPA_LOB_Report.InitEvent AC) |
| WK-SCP0108-0081 | G4 | clbFactory / Building / Factory | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbFactory / Building / Factory · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0108_CAPA_LOB_Report.InitEvent AC) |
| WK-SCP0108-0082 | G4 | clbLine / Line | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbLine / Line · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0108_CAPA_LOB_Report.InitEvent AC) |
| WK-SCP0108-0083 | G4 | clbOperation / Operation | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbOperation / Operation · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0108_CAPA_LOB_Report.InitEvent AC) |
| WK-SCP0108-0084 | G4 | clbPlant / Plant | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbPlant / Plant · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0108_CAPA_LOB_Report.InitEvent AC) |
| WK-SCP0108-0085 | G4 | clbSite / Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbSite / Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0108_CAPA_LOB_Report.InitEvent AC) |
| WK-SCP0108-0086 | G4 | rgrpDivisionType / Division Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — rgrpDivisionType / Division Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0108_CAPA_LOB_Report.Form_Load AC) |
| WK-SCP0108-0087 | H2 | ELTR_LN_TP_CD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ELTR_LN_TP_CD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (G1 `frozenColumns={1}` 하드코딩) |
| WK-SCP0108-0088 | H4 | SCP0108 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — SCP0108 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 6 (events `spdMain_TopChange` 스크롤 핸들러 ACT:S) |
| WK-SCP0108-0089 | H5 | ELTR_LN_TP_CD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ELTR_LN_TP_CD · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (G1 `frozenColumns={1}` 하드코딩) |
| WK-SCP0108-0090 | I1 | SCP0108 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0108 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 10 (validations (1) **Division 권한 0건** (2) *) |
| WK-SCP0108-0091 | SC1 | SCP0108 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SCP0108 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 3 (entryPoints `components/CapaLobReportFor) |
| WK-SCP0108-0092 | D6 | SCP0108 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0108 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 9 (entryPoints `CapaLobReport.tsx` (1) **Di) |
| WK-SCP0108-0093 | E4 | MSG00008 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00008 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 ((3) **시트 잠금**) |
| WK-SCP0108-0094 | E4 | MSG00009 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00009 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 ((3) **시트 잠금**) |
| WK-SCP0108-0095 | E4 | MSG00010 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00010 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 ((3) **시트 잠금**) |
| WK-SCP0108-0096 | E4 | MSG00096 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00096 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 ((2) **버튼 ACL** 3) |
| WK-SCP0108-0097 | E4 | MSG00097 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00097 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 ((1) **Division 권한 0건**) |
| WK-SCP0108-0098 | E4 | MSG00423 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00423 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (validations ACT:SCP0108_CAPA_LOB_Report.) |
| WK-SCP0108-0099 | E4 | MSG00667 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00667 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 ((1) **Division 권한 0건** 6) |
| WK-SCP0108-0100 | E4 | MSG01044 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01044 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 ((3) **시트 잠금**) |
| WK-SCP0108-0101 | E4 | MSG01045 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01045 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 ((3) **시트 잠금**) |
| WK-SCP0108-0102 | E4 | MSG01052 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01052 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (7) |
| WK-SCP0108-0103 | E4 | MSG01390 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01390 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (6) |
| WK-SCP0108-0104 | E4 | MSG01410 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01410 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (validations 5) |
| WK-SCP0108-0105 | A10 | SCP0108 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0108 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 46 (ACT:SCP0108_CAPA_LOB_Report.Form_Load AC) |
| WK-SCP0108-0106 | G1 | clbLine / Line | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbLine / Line · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (2) |
| WK-SCP0108-0107 | G1 | clbSite / Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbSite / Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (2) |
| WK-SCP0108-0108 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0108_CAPA_LOB_Report.InitEvent AC) |
| WK-SCP0108-0109 | G6 | cboVersion / Plan Month / Version / Ver. | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboVersion / Plan Month / Version / Ver. · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0108_CAPA_LOB_Report.InitEvent AC) |
| WK-SCP0108-0110 | G6 | cboVersionSeq / Version / Version Seq /  | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboVersionSeq / Version / Version Seq / Ver. · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0108_CAPA_LOB_Report.InitEvent AC) |
| WK-SCP0108-0111 | G6 | clbFactory / Building / Factory | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbFactory / Building / Factory · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0108_CAPA_LOB_Report.InitEvent AC) |
| WK-SCP0108-0112 | G6 | clbLine / Line | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbLine / Line · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0108_CAPA_LOB_Report.InitEvent AC) |
| WK-SCP0108-0113 | G6 | clbOperation / Operation | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbOperation / Operation · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0108_CAPA_LOB_Report.InitEvent AC) |
| WK-SCP0108-0114 | G6 | clbPlant / Plant | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbPlant / Plant · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0108_CAPA_LOB_Report.InitEvent AC) |
| WK-SCP0108-0115 | G6 | clbSite / Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbSite / Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0108_CAPA_LOB_Report.InitEvent AC) |
| WK-SCP0108-0116 | G6 | rgrpDivisionType / Division Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — rgrpDivisionType / Division Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCP0108_CAPA_LOB_Report.Form_Load AC) |
| WK-SCP0108-0117 | X-REOPEN | SCP0108 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0108 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 5 (ACT:SCP0108_CAPA_LOB_Report.Dispose ACT:) |
| WK-SCP0108-0118 | H6 | txtItem / Basic Nickname / Item | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtItem / Basic Nickname / Item · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 0 () |
| WK-SCP0108-0119 | M4 | btnColumn | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnColumn · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (`components/modals/CapaLobReportColumnMo) |
| WK-SCP0108-0120 | M4 | btnItemId | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnItemId · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 0 () |
| WK-SCP0108-0121 | M4 | txtItem / Basic Nickname / Item | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtItem / Basic Nickname / Item · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 0 () |

## W7 기대값 확정 (277)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0108-0122 | C1 | 데드 핸들러 `cboSheetType_SelectedIndexChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 데드 핸들러 `cboSheetType_SelectedIndexChanged` / `cboF: 행 집계 — C1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (데드 핸들러 `cboSheetType_SelectedIndexChange) |
| WK-SCP0108-0123 | B3 | SCP0108_CAPA_LOB_Report.GetCurrVersionPr | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0108_CAPA_LOB_Report.GetCurrVersionProgessStatu: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0108_CAPA_LOB_Report.GetCurrVersi) |
| WK-SCP0108-0124 | B3 | SCP0108_CAPA_LOB_Report.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0108_CAPA_LOB_Report.GetSpdTitle: 진입점 집계 — B3 22요소: TODO:22 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0108_CAPA_LOB_Report.GetSpdTitle:) |
| WK-SCP0108-0125 | B3 | SCP0108_CAPA_LOB_Report.getBottleneck | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0108_CAPA_LOB_Report.getBottleneck: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0108_CAPA_LOB_Report.getBottlenec) |
| WK-SCP0108-0126 | B3 | SCP0108_CAPA_LOB_Report.getCurrCompany | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0108_CAPA_LOB_Report.getCurrCompany: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrCompa) |
| WK-SCP0108-0127 | B3 | SCP0108_CAPA_LOB_Report.getCurrDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0108_CAPA_LOB_Report.getCurrDivision: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrDivis) |
| WK-SCP0108-0128 | B3 | SCP0108_CAPA_LOB_Report.getCurrElectrode | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0108_CAPA_LOB_Report.getCurrElectrodeType: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrElect) |
| WK-SCP0108-0129 | B3 | SCP0108_CAPA_LOB_Report.getCurrFactory | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0108_CAPA_LOB_Report.getCurrFactory: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrFacto) |
| WK-SCP0108-0130 | B3 | SCP0108_CAPA_LOB_Report.getCurrLine | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0108_CAPA_LOB_Report.getCurrLine: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrLine:) |
| WK-SCP0108-0131 | B3 | SCP0108_CAPA_LOB_Report.getCurrNickname | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0108_CAPA_LOB_Report.getCurrNickname: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrNickn) |
| WK-SCP0108-0132 | B3 | SCP0108_CAPA_LOB_Report.getCurrOperation | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0108_CAPA_LOB_Report.getCurrOperation: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrOpera) |
| WK-SCP0108-0133 | B3 | SCP0108_CAPA_LOB_Report.getCurrPlant | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0108_CAPA_LOB_Report.getCurrPlant: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrPlant) |
| WK-SCP0108-0134 | B3 | SCP0108_CAPA_LOB_Report.getCurrSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0108_CAPA_LOB_Report.getCurrSite: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrSite:) |
| WK-SCP0108-0135 | B3 | SCP0108_CAPA_LOB_Report.getDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0108_CAPA_LOB_Report.getDivision: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getDivision:) |
| WK-SCP0108-0136 | B3 | SCP0108_CAPA_LOB_Report.getDivisionType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0108_CAPA_LOB_Report.getDivisionType: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getDivisionT) |
| WK-SCP0108-0137 | B3 | SCP0108_CAPA_LOB_Report.getElectrodeType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0108_CAPA_LOB_Report.getElectrodeType: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getElectrode) |
| WK-SCP0108-0138 | B3 | SCP0108_CAPA_LOB_Report.getFactory | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0108_CAPA_LOB_Report.getFactory: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getFactory:4) |
| WK-SCP0108-0139 | B3 | SCP0108_CAPA_LOB_Report.getItemId | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0108_CAPA_LOB_Report.getItemId: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getItemId:54) |
| WK-SCP0108-0140 | B3 | SCP0108_CAPA_LOB_Report.getLine | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0108_CAPA_LOB_Report.getLine: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getLine:492:) |
| WK-SCP0108-0141 | B3 | SCP0108_CAPA_LOB_Report.getOperation | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0108_CAPA_LOB_Report.getOperation: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getOperation) |
| WK-SCP0108-0142 | B3 | SCP0108_CAPA_LOB_Report.getPlanType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0108_CAPA_LOB_Report.getPlanType: 진입점 집계 — B3 22요소: TODO:22 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.getPlanType:) |
| WK-SCP0108-0143 | B3 | SCP0108_CAPA_LOB_Report.getPlant | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0108_CAPA_LOB_Report.getPlant: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getPlant:444) |
| WK-SCP0108-0144 | B3 | SCP0108_CAPA_LOB_Report.getProgressStatu | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0108_CAPA_LOB_Report.getProgressStatus: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getProgressS) |
| WK-SCP0108-0145 | B3 | SCP0108_CAPA_LOB_Report.getShopGroup | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0108_CAPA_LOB_Report.getShopGroup: 진입점 집계 — B3 22요소: TODO:22 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.getShopGroup) |
| WK-SCP0108-0146 | B3 | SCP0108_CAPA_LOB_Report.getSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0108_CAPA_LOB_Report.getSite: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getSite:406:) |
| WK-SCP0108-0147 | B3 | SCP0108_CAPA_LOB_Report.getVersion | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0108_CAPA_LOB_Report.getVersion: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getVersion:2) |
| WK-SCP0108-0148 | B3 | SCP0108_CAPA_LOB_Report.getVersionSeq | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0108_CAPA_LOB_Report.getVersionSeq: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getVersionSe) |
| WK-SCP0108-0149 | B4 | SCP0108_CAPA_LOB_Report.GetCurrVersionPr | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0108_CAPA_LOB_Report.GetCurrVersionProgessStatu: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0108_CAPA_LOB_Report.GetCurrVersi) |
| WK-SCP0108-0150 | B4 | SCP0108_CAPA_LOB_Report.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0108_CAPA_LOB_Report.GetSpdTitle: 진입점 집계 — B4 22요소: NOPATH:22 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0108_CAPA_LOB_Report.GetSpdTitle:) |
| WK-SCP0108-0151 | B4 | SCP0108_CAPA_LOB_Report.getBottleneck | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0108_CAPA_LOB_Report.getBottleneck: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0108_CAPA_LOB_Report.getBottlenec) |
| WK-SCP0108-0152 | B4 | SCP0108_CAPA_LOB_Report.getCurrCompany | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0108_CAPA_LOB_Report.getCurrCompany: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrCompa) |
| WK-SCP0108-0153 | B4 | SCP0108_CAPA_LOB_Report.getCurrDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0108_CAPA_LOB_Report.getCurrDivision: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrDivis) |
| WK-SCP0108-0154 | B4 | SCP0108_CAPA_LOB_Report.getCurrElectrode | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0108_CAPA_LOB_Report.getCurrElectrodeType: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrElect) |
| WK-SCP0108-0155 | B4 | SCP0108_CAPA_LOB_Report.getCurrFactory | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0108_CAPA_LOB_Report.getCurrFactory: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrFacto) |
| WK-SCP0108-0156 | B4 | SCP0108_CAPA_LOB_Report.getCurrLine | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0108_CAPA_LOB_Report.getCurrLine: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrLine:) |
| WK-SCP0108-0157 | B4 | SCP0108_CAPA_LOB_Report.getCurrNickname | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0108_CAPA_LOB_Report.getCurrNickname: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrNickn) |
| WK-SCP0108-0158 | B4 | SCP0108_CAPA_LOB_Report.getCurrOperation | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0108_CAPA_LOB_Report.getCurrOperation: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrOpera) |
| WK-SCP0108-0159 | B4 | SCP0108_CAPA_LOB_Report.getCurrPlant | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0108_CAPA_LOB_Report.getCurrPlant: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrPlant) |
| WK-SCP0108-0160 | B4 | SCP0108_CAPA_LOB_Report.getCurrSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0108_CAPA_LOB_Report.getCurrSite: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrSite:) |
| WK-SCP0108-0161 | B4 | SCP0108_CAPA_LOB_Report.getDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0108_CAPA_LOB_Report.getDivision: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getDivision:) |
| WK-SCP0108-0162 | B4 | SCP0108_CAPA_LOB_Report.getDivisionType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0108_CAPA_LOB_Report.getDivisionType: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getDivisionT) |
| WK-SCP0108-0163 | B4 | SCP0108_CAPA_LOB_Report.getElectrodeType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0108_CAPA_LOB_Report.getElectrodeType: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getElectrode) |
| WK-SCP0108-0164 | B4 | SCP0108_CAPA_LOB_Report.getFactory | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0108_CAPA_LOB_Report.getFactory: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getFactory:4) |
| WK-SCP0108-0165 | B4 | SCP0108_CAPA_LOB_Report.getItemId | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0108_CAPA_LOB_Report.getItemId: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getItemId:54) |
| WK-SCP0108-0166 | B4 | SCP0108_CAPA_LOB_Report.getLine | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0108_CAPA_LOB_Report.getLine: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getLine:492:) |
| WK-SCP0108-0167 | B4 | SCP0108_CAPA_LOB_Report.getOperation | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0108_CAPA_LOB_Report.getOperation: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getOperation) |
| WK-SCP0108-0168 | B4 | SCP0108_CAPA_LOB_Report.getPlanType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0108_CAPA_LOB_Report.getPlanType: 진입점 집계 — B4 22요소: NOPATH:22 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.getPlanType:) |
| WK-SCP0108-0169 | B4 | SCP0108_CAPA_LOB_Report.getPlant | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0108_CAPA_LOB_Report.getPlant: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getPlant:444) |
| WK-SCP0108-0170 | B4 | SCP0108_CAPA_LOB_Report.getProgressStatu | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0108_CAPA_LOB_Report.getProgressStatus: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getProgressS) |
| WK-SCP0108-0171 | B4 | SCP0108_CAPA_LOB_Report.getShopGroup | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0108_CAPA_LOB_Report.getShopGroup: 진입점 집계 — B4 22요소: NOPATH:22 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.getShopGroup) |
| WK-SCP0108-0172 | B4 | SCP0108_CAPA_LOB_Report.getSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0108_CAPA_LOB_Report.getSite: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getSite:406:) |
| WK-SCP0108-0173 | B4 | SCP0108_CAPA_LOB_Report.getVersion | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0108_CAPA_LOB_Report.getVersion: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getVersion:2) |
| WK-SCP0108-0174 | B4 | SCP0108_CAPA_LOB_Report.getVersionSeq | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0108_CAPA_LOB_Report.getVersionSeq: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getVersionSe) |
| WK-SCP0108-0175 | F4 | SCP0108_CAPA_LOB_Report.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0108_CAPA_LOB_Report.FindButton: 진입점 집계 — F4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0108_CAPA_LOB_Report.FindButton A) |
| WK-SCP0108-0176 | F4 | SCP0108_CAPA_LOB_Report.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0108_CAPA_LOB_Report.FindData: 진입점 집계 — F4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.FindData ACT) |
| WK-SCP0108-0177 | F4 | SCP0108_CAPA_LOB_Report.FindDataMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0108_CAPA_LOB_Report.FindDataMain: 진입점 집계 — F4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.FindDataMain) |
| WK-SCP0108-0178 | F4 | `CapaLobReport.tsx` | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — `CapaLobReport.tsx`: 행 집계 — F4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (`CapaLobReport.tsx`) |
| WK-SCP0108-0179 | F4 | `hooks/useCapaLobReportConditionEffects. | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — `hooks/useCapaLobReportConditionEffects.ts`: 행 집계 — F4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (`hooks/useCapaLobReportConditionEffects.) |
| WK-SCP0108-0180 | F4 | `useProcMutation`/`useSaveWithValidation | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — `useProcMutation`/`useSaveWithValidation`/`EditTra: 행 집계 — F4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (`useProcMutation`/`useSaveWithValidation) |
| WK-SCP0108-0181 | A5 | (3) **시트 잠금** | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — (3) **시트 잠금**: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 ((3) **시트 잠금**) |
| WK-SCP0108-0182 | A5 | G2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — G2: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (G2) |
| WK-SCP0108-0183 | A5 | G3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — G3: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (G3) |
| WK-SCP0108-0184 | A5 | G4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — G4: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (G4) |
| WK-SCP0108-0185 | A5 | G5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — G5: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (G5) |
| WK-SCP0108-0186 | A5 | G6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — G6: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (G6) |
| WK-SCP0108-0187 | A5 | SCP0108_CAPA_LOB_Report.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0108_CAPA_LOB_Report.CreateSpread: 진입점 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0108_CAPA_LOB_Report.CreateSpread) |
| WK-SCP0108-0188 | A5 | `ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — `ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용 시트" 로 구현: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (`ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용) |
| WK-SCP0108-0189 | A5 | `capa-lob-report.constants.ts` | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — `capa-lob-report.constants.ts`: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (`capa-lob-report.constants.ts`) |
| WK-SCP0108-0190 | A5 | `hooks/useCapaLobReportConditionEffects. | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — `hooks/useCapaLobReportConditionEffects.ts`: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (`hooks/useCapaLobReportConditionEffects.) |
| WK-SCP0108-0191 | A5 | spCalls | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — spCalls: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (spCalls) |
| WK-SCP0108-0192 | A5 | 시트 탭 UI(`TabWrapper`/`TabPanel`) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 시트 탭 UI(`TabWrapper`/`TabPanel`): 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (시트 탭 UI(`TabWrapper`/`TabPanel`)) |
| WK-SCP0108-0193 | G4 | `components/CapaLobReportForm.tsx` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — `components/CapaLobReportForm.tsx`: 행 집계 — G4 11요소: NOT_RUN:9 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (`components/CapaLobReportForm.tsx`) |
| WK-SCP0108-0194 | G4 | entryPoints | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — entryPoints: 행 집계 — G4 11요소: NOT_RUN:9 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (entryPoints) |
| WK-SCP0108-0195 | G4 | 필수 조회조건 UI(`*`) · Search 전 alert | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 필수 조회조건 UI(`*`) · Search 전 alert: 행 집계 — G4 11요소: NOT_RUN:9 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (필수 조회조건 UI(`*`) · Search 전 alert) |
| WK-SCP0108-0196 | H2 | (2) **버튼 ACL** | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — (2) **버튼 ACL**: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 ((2) **버튼 ACL**) |
| WK-SCP0108-0197 | H2 | (3) **시트 잠금** | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — (3) **시트 잠금**: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 ((3) **시트 잠금**) |
| WK-SCP0108-0198 | H2 | G2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — G2: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (G2) |
| WK-SCP0108-0199 | H2 | G3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — G3: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (G3) |
| WK-SCP0108-0200 | H2 | G4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — G4: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (G4) |
| WK-SCP0108-0201 | H2 | G5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — G5: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (G5) |
| WK-SCP0108-0202 | H2 | G6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — G6: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (G6) |
| WK-SCP0108-0203 | H2 | SCP0108_CAPA_LOB_Report.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0108_CAPA_LOB_Report.CreateSpread: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0108_CAPA_LOB_Report.CreateSpread) |
| WK-SCP0108-0204 | H2 | `ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — `ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용 시트" 로 구현: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (`ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용) |
| WK-SCP0108-0205 | H2 | `capa-lob-report.constants.ts` | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — `capa-lob-report.constants.ts`: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (`capa-lob-report.constants.ts`) |
| WK-SCP0108-0206 | H2 | `components/CapaLobReportGrid.tsx` | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — `components/CapaLobReportGrid.tsx`: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (`components/CapaLobReportGrid.tsx`) |
| WK-SCP0108-0207 | H2 | `hooks/useCapaLobReportConditionEffects. | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — `hooks/useCapaLobReportConditionEffects.ts`: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (`hooks/useCapaLobReportConditionEffects.) |
| WK-SCP0108-0208 | H2 | `spdMain_TopChange` 스크롤 핸들러 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — `spdMain_TopChange` 스크롤 핸들러: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (`spdMain_TopChange` 스크롤 핸들러) |
| WK-SCP0108-0209 | H2 | events | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — events: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (events) |
| WK-SCP0108-0210 | H2 | gridSignals | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — gridSignals: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (gridSignals) |
| WK-SCP0108-0211 | H2 | spCalls | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — spCalls: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (spCalls) |
| WK-SCP0108-0212 | H2 | 시트 탭 UI(`TabWrapper`/`TabPanel`) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 시트 탭 UI(`TabWrapper`/`TabPanel`): 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (시트 탭 UI(`TabWrapper`/`TabPanel`)) |
| WK-SCP0108-0213 | H5 | (3) **시트 잠금** | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — (3) **시트 잠금**: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 ((3) **시트 잠금**) |
| WK-SCP0108-0214 | H5 | G2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — G2: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (G2) |
| WK-SCP0108-0215 | H5 | G3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — G3: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (G3) |
| WK-SCP0108-0216 | H5 | G4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — G4: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (G4) |
| WK-SCP0108-0217 | H5 | G5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — G5: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (G5) |
| WK-SCP0108-0218 | H5 | G6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — G6: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (G6) |
| WK-SCP0108-0219 | H5 | SCP0108_CAPA_LOB_Report.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0108_CAPA_LOB_Report.CreateSpread: 진입점 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0108_CAPA_LOB_Report.CreateSpread) |
| WK-SCP0108-0220 | H5 | `ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용 시트" 로 구현: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (`ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용) |
| WK-SCP0108-0221 | H5 | `capa-lob-report.constants.ts` | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `capa-lob-report.constants.ts`: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (`capa-lob-report.constants.ts`) |
| WK-SCP0108-0222 | H5 | `hooks/useCapaLobReportConditionEffects. | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `hooks/useCapaLobReportConditionEffects.ts`: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (`hooks/useCapaLobReportConditionEffects.) |
| WK-SCP0108-0223 | H5 | spCalls | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — spCalls: 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (spCalls) |
| WK-SCP0108-0224 | H5 | 시트 탭 UI(`TabWrapper`/`TabPanel`) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 시트 탭 UI(`TabWrapper`/`TabPanel`): 행 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (시트 탭 UI(`TabWrapper`/`TabPanel`)) |
| WK-SCP0108-0225 | E4 | Edit 버튼(`customButtons`) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — Edit 버튼(`customButtons`): 행 집계 — E4 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (Edit 버튼(`customButtons`)) |
| WK-SCP0108-0226 | E4 | SCP0108_CAPA_LOB_Report.SetQueryInfoGet | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0108_CAPA_LOB_Report.SetQueryInfoGet: 진입점 집계 — E4 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 20 (ACT:SCP0108_CAPA_LOB_Report.SetQueryInfo) |
| WK-SCP0108-0227 | E4 | SCP0108_CAPA_LOB_Report.SetSheetMerge | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0108_CAPA_LOB_Report.SetSheetMerge: 진입점 집계 — E4 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.SetSheetMerg) |
| WK-SCP0108-0228 | E4 | SCP0108_CAPA_LOB_Report.SetVisibleElectr | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0108_CAPA_LOB_Report.SetVisibleElectrodeType: 진입점 집계 — E4 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.SetVisibleEl) |
| WK-SCP0108-0229 | E4 | SCP0108_CAPA_LOB_Report.SetVisibleOperat | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0108_CAPA_LOB_Report.SetVisibleOperation: 진입점 집계 — E4 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.SetVisibleOp) |
| WK-SCP0108-0230 | E4 | SCP0108_CAPA_LOB_Report.SetVisibleSheetC | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0108_CAPA_LOB_Report.SetVisibleSheetColumns: 진입점 집계 — E4 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.SetVisibleSh) |
| WK-SCP0108-0231 | E4 | `useProcMutation`/`useSaveWithValidation | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — `useProcMutation`/`useSaveWithValidation`/`EditTra: 행 집계 — E4 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (`useProcMutation`/`useSaveWithValidation) |
| WK-SCP0108-0232 | G1 | (1) **Division 권한 0건** | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — (1) **Division 권한 0건**: 행 집계 — G1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 ((1) **Division 권한 0건**) |
| WK-SCP0108-0233 | G1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 1: 행 집계 — G1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0108-0234 | G1 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 6: 행 집계 — G1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (6) |
| WK-SCP0108-0235 | G1 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 7: 행 집계 — G1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (7) |
| WK-SCP0108-0236 | G1 | ADMIN | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — ADMIN: 행 집계 — G1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ADMIN) |
| WK-SCP0108-0237 | G1 | AS-IS 빈 `catch`(`_from_yyyymm` 파싱 실패) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — AS-IS 빈 `catch`(`_from_yyyymm` 파싱 실패): 행 집계 — G1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (AS-IS 빈 `catch`(`_from_yyyymm` 파싱 실패)) |
| WK-SCP0108-0238 | G1 | FP Planner | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — FP Planner: 행 집계 — G1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (FP Planner) |
| WK-SCP0108-0239 | G1 | FP Viewer | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — FP Viewer: 행 집계 — G1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (FP Viewer) |
| WK-SCP0108-0240 | G1 | SCM PI Admin | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SCM PI Admin: 행 집계 — G1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (SCM PI Admin) |
| WK-SCP0108-0241 | G1 | SCM Viewer | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SCM Viewer: 행 집계 — G1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (SCM Viewer) |
| WK-SCP0108-0242 | G1 | SCP Planner | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SCP Planner: 행 집계 — G1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (SCP Planner) |
| WK-SCP0108-0243 | G1 | SCP0108_CAPA_LOB_Report.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SCP0108_CAPA_LOB_Report.FindButton: 진입점 집계 — G1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0108_CAPA_LOB_Report.FindButton:1) |
| WK-SCP0108-0244 | G1 | SCP0108_CAPA_LOB_Report.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SCP0108_CAPA_LOB_Report.FindData: 진입점 집계 — G1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.FindData:148) |
| WK-SCP0108-0245 | G1 | SCP0108_CAPA_LOB_Report.FindDataMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SCP0108_CAPA_LOB_Report.FindDataMain: 진입점 집계 — G1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.FindDataMain) |
| WK-SCP0108-0246 | G1 | `CapaLobReport.tsx` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `CapaLobReport.tsx`: 행 집계 — G1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (`CapaLobReport.tsx`) |
| WK-SCP0108-0247 | G1 | `ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용 시트" 로 구현: 행 집계 — G1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (`ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용) |
| WK-SCP0108-0248 | G1 | `capa-lob-report.types.ts` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `capa-lob-report.types.ts`: 행 집계 — G1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (`capa-lob-report.types.ts`) |
| WK-SCP0108-0249 | G1 | `components/CapaLobReportForm.tsx` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `components/CapaLobReportForm.tsx`: 행 집계 — G1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (`components/CapaLobReportForm.tsx`) |
| WK-SCP0108-0250 | G1 | entryPoints | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — entryPoints: 행 집계 — G1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (entryPoints) |
| WK-SCP0108-0251 | G1 | validations | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — validations: 행 집계 — G1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (validations) |
| WK-SCP0108-0252 | G1 | 필수 조회조건 UI(`*`) · Search 전 alert | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 필수 조회조건 UI(`*`) · Search 전 alert: 행 집계 — G1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (필수 조회조건 UI(`*`) · Search 전 alert) |
| WK-SCP0108-0253 | G6 | `components/CapaLobReportForm.tsx` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — `components/CapaLobReportForm.tsx`: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (`components/CapaLobReportForm.tsx`) |
| WK-SCP0108-0254 | G6 | entryPoints | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — entryPoints: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (entryPoints) |
| WK-SCP0108-0255 | G6 | 필수 조회조건 UI(`*`) · Search 전 alert | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 필수 조회조건 UI(`*`) · Search 전 alert: 행 집계 — G6 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (필수 조회조건 UI(`*`) · Search 전 alert) |
| WK-SCP0108-0256 | X-LOC | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (2) |
| WK-SCP0108-0257 | X-LOC | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (3) |
| WK-SCP0108-0258 | X-LOC | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (4) |
| WK-SCP0108-0259 | X-LOC | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (5) |
| WK-SCP0108-0260 | X-LOC | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 6: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (6) |
| WK-SCP0108-0261 | X-LOC | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 7: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (7) |
| WK-SCP0108-0262 | X-LOC | ADMIN | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ADMIN: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (ADMIN) |
| WK-SCP0108-0263 | X-LOC | AS-IS 빈 `catch`(`_from_yyyymm` 파싱 실패) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — AS-IS 빈 `catch`(`_from_yyyymm` 파싱 실패): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (AS-IS 빈 `catch`(`_from_yyyymm` 파싱 실패)) |
| WK-SCP0108-0264 | X-LOC | AS-IS 헤더 높이 75px(1단 35 + 2·3단 20) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — AS-IS 헤더 높이 75px(1단 35 + 2·3단 20): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (AS-IS 헤더 높이 75px(1단 35 + 2·3단 20)) |
| WK-SCP0108-0265 | X-LOC | Bottleneck **행 인덱스** 대응 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Bottleneck **행 인덱스** 대응: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Bottleneck **행 인덱스** 대응) |
| WK-SCP0108-0266 | X-LOC | CAPA Planner | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — CAPA Planner: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (CAPA Planner) |
| WK-SCP0108-0267 | X-LOC | Edit 버튼(`customButtons`) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Edit 버튼(`customButtons`): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Edit 버튼(`customButtons`)) |
| WK-SCP0108-0268 | X-LOC | FP Planner | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — FP Planner: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (FP Planner) |
| WK-SCP0108-0269 | X-LOC | FP Viewer | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — FP Viewer: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (FP Viewer) |
| WK-SCP0108-0270 | X-LOC | Formation(`AFFFF`) **전역** 제외 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Formation(`AFFFF`) **전역** 제외: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Formation(`AFFFF`) **전역** 제외) |
| WK-SCP0108-0271 | X-LOC | G1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G1) |
| WK-SCP0108-0272 | X-LOC | G2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G2) |
| WK-SCP0108-0273 | X-LOC | G3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G3) |
| WK-SCP0108-0274 | X-LOC | G4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G4) |
| WK-SCP0108-0275 | X-LOC | G5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G5) |
| WK-SCP0108-0276 | X-LOC | G6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G6: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G6) |
| WK-SCP0108-0277 | X-LOC | SCM PI Admin | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SCM PI Admin: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SCM PI Admin) |
| WK-SCP0108-0278 | X-LOC | SCM Viewer | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SCM Viewer: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SCM Viewer) |
| WK-SCP0108-0279 | X-LOC | SCP Planner | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SCP Planner: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SCP Planner) |
| WK-SCP0108-0280 | X-LOC | SCP Tester | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SCP Tester: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SCP Tester) |
| WK-SCP0108-0281 | X-LOC | `CapaLineMasterEE_SCP_ALL` 콤보 스왑 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `CapaLineMasterEE_SCP_ALL` 콤보 스왑: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`CapaLineMasterEE_SCP_ALL` 콤보 스왑) |
| WK-SCP0108-0282 | X-LOC | `LockColumn` 컬럼명 상수 배열 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `LockColumn` 컬럼명 상수 배열: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`LockColumn` 컬럼명 상수 배열) |
| WK-SCP0108-0283 | X-LOC | `ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용 시트" 로 구현: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용) |
| WK-SCP0108-0284 | X-LOC | `_ASSIGN_PRIORITY` 제외 필터 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `_ASSIGN_PRIORITY` 제외 필터: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`_ASSIGN_PRIORITY` 제외 필터) |
| WK-SCP0108-0285 | X-LOC | `_dateStartColIdx` / `_dateEndColIdx` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `_dateStartColIdx` / `_dateEndColIdx`: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`_dateStartColIdx` / `_dateEndColIdx`) |
| WK-SCP0108-0286 | X-LOC | `dtFromYYYY`(`YearFromThisYear_SCP_ALL`) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `dtFromYYYY`(`YearFromThisYear_SCP_ALL`): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`dtFromYYYY`(`YearFromThisYear_SCP_ALL`)) |
| WK-SCP0108-0287 | X-LOC | `dtYesOrNo` 필드 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `dtYesOrNo` 필드: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`dtYesOrNo` 필드) |
| WK-SCP0108-0288 | X-LOC | `fetchStaticMeasures` / `staticMeasures` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `fetchStaticMeasures` / `staticMeasures`: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`fetchStaticMeasures` / `staticMeasures`) |
| WK-SCP0108-0289 | X-LOC | `frozenColumns={1}` 하드코딩 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `frozenColumns={1}` 하드코딩: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`frozenColumns={1}` 하드코딩) |
| WK-SCP0108-0290 | X-LOC | `imageList1` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `imageList1`: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`imageList1`) |
| WK-SCP0108-0291 | X-LOC | `isEditMode` state | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `isEditMode` state: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`isEditMode` state) |
| WK-SCP0108-0292 | X-LOC | `spdMain_TopChange` 스크롤 핸들러 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `spdMain_TopChange` 스크롤 핸들러: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`spdMain_TopChange` 스크롤 핸들러) |
| WK-SCP0108-0293 | X-LOC | `statusIdx = UIUtils.GetIndexByCode(...) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `statusIdx = UIUtils.GetIndexByCode(...)`: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`statusIdx = UIUtils.GetIndexByCode(...)) |
| WK-SCP0108-0294 | X-LOC | `useProcMutation`/`useSaveWithValidation | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `useProcMutation`/`useSaveWithValidation`/`EditTra: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`useProcMutation`/`useSaveWithValidation) |
| WK-SCP0108-0295 | X-LOC | `usrLayoutControl1` / `layoutControlGrou | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `usrLayoutControl1` / `layoutControlGroup1`: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`usrLayoutControl1` / `layoutControlGrou) |
| WK-SCP0108-0296 | X-LOC | buttonGuards | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — buttonGuards: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (buttonGuards) |
| WK-SCP0108-0297 | X-LOC | comboCalls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — comboCalls: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (comboCalls) |
| WK-SCP0108-0298 | X-LOC | entryPoints | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — entryPoints: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (entryPoints) |
| WK-SCP0108-0299 | X-LOC | events | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — events: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (events) |
| WK-SCP0108-0300 | X-LOC | extractionLimits | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — extractionLimits: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (extractionLimits) |
| WK-SCP0108-0301 | X-LOC | gridColumns | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — gridColumns: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (gridColumns) |
| WK-SCP0108-0302 | X-LOC | gridSignals | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — gridSignals: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (gridSignals) |
| WK-SCP0108-0303 | X-LOC | validations | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — validations: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (validations) |
| WK-SCP0108-0304 | X-LOC | 데드 핸들러 `cboSheetType_SelectedIndexChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 데드 핸들러 `cboSheetType_SelectedIndexChanged` / `cboF: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (데드 핸들러 `cboSheetType_SelectedIndexChange) |
| WK-SCP0108-0305 | X-LOC | 시트 탭 UI(`TabWrapper`/`TabPanel`) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 시트 탭 UI(`TabWrapper`/`TabPanel`): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (시트 탭 UI(`TabWrapper`/`TabPanel`)) |
| WK-SCP0108-0306 | X-LOC | 필수 조회조건 UI(`*`) · Search 전 alert | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 필수 조회조건 UI(`*`) · Search 전 alert: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (필수 조회조건 UI(`*`) · Search 전 alert) |
| WK-SCP0108-0307 | X-ROW | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 1: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (1) |
| WK-SCP0108-0308 | X-ROW | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 2: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 0 () |
| WK-SCP0108-0309 | X-ROW | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 4: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (4) |
| WK-SCP0108-0310 | X-ROW | AS-IS 헤더 높이 75px(1단 35 + 2·3단 20) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AS-IS 헤더 높이 75px(1단 35 + 2·3단 20): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (AS-IS 헤더 높이 75px(1단 35 + 2·3단 20)) |
| WK-SCP0108-0311 | X-ROW | Bottleneck **행 인덱스** 대응 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — Bottleneck **행 인덱스** 대응: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (Bottleneck **행 인덱스** 대응) |
| WK-SCP0108-0312 | X-ROW | CAPA Planner | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — CAPA Planner: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (CAPA Planner) |
| WK-SCP0108-0313 | X-ROW | Formation(`AFFFF`) **전역** 제외 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — Formation(`AFFFF`) **전역** 제외: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (Formation(`AFFFF`) **전역** 제외) |
| WK-SCP0108-0314 | X-ROW | SCP Tester | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP Tester: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (SCP Tester) |
| WK-SCP0108-0315 | X-ROW | SCP0108_CAPA_LOB_Report.AfterFindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.AfterFindData: 진입점 집계 1검사 — NOPATH:1 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SCP0108_CAPA_LOB_Report.AfterFindDat) |
| WK-SCP0108-0316 | X-ROW | SCP0108_CAPA_LOB_Report.BeforeFindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.BeforeFindData: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0108_CAPA_LOB_Report.BeforeFindDa) |
| WK-SCP0108-0317 | X-ROW | SCP0108_CAPA_LOB_Report.ChangeColumnName | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.ChangeColumnNameToCodeName: 진입점 동작 재현 시나리오 필요 — 문장 종류 DATA_OP/ENTRY/GRID_SET, 연결된 요소 검사 없음 |  | 5 (ACT:SCP0108_CAPA_LOB_Report.ChangeColumn) |
| WK-SCP0108-0318 | X-ROW | SCP0108_CAPA_LOB_Report.ClearUsrCheckedL | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.ClearUsrCheckedList: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/LIST_REBIND/STATE_RESET, 연결된 요소 |  | 4 (ACT:SCP0108_CAPA_LOB_Report.ClearUsrChec) |
| WK-SCP0108-0319 | X-ROW | SCP0108_CAPA_LOB_Report.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.CreateSpread) |
| WK-SCP0108-0320 | X-ROW | SCP0108_CAPA_LOB_Report.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.FindButton: 진입점 집계 6검사 — NOT_RUN:4 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.FindButton A) |
| WK-SCP0108-0321 | X-ROW | SCP0108_CAPA_LOB_Report.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.FindData: 진입점 집계 4검사 — NOPATH:2 · NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.FindData) |
| WK-SCP0108-0322 | X-ROW | SCP0108_CAPA_LOB_Report.FindDataMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.FindDataMain: 진입점 집계 5검사 — NOPATH:3 · NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.FindDataMain) |
| WK-SCP0108-0323 | X-ROW | SCP0108_CAPA_LOB_Report.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.Form_Load: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.Form_Load:97) |
| WK-SCP0108-0324 | X-ROW | SCP0108_CAPA_LOB_Report.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.GetSpdTitle: 진입점 집계 5검사 — NOT_RUN:2 · PASS:1 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.GetSpdTitle) |
| WK-SCP0108-0325 | X-ROW | SCP0108_CAPA_LOB_Report.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.InitControls: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.InitControls) |
| WK-SCP0108-0326 | X-ROW | SCP0108_CAPA_LOB_Report.InitDatasAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.InitDatasAll: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.InitDatasAll) |
| WK-SCP0108-0327 | X-ROW | SCP0108_CAPA_LOB_Report.InitQueryDics | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.InitQueryDics: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.InitQueryDic) |
| WK-SCP0108-0328 | X-ROW | SCP0108_CAPA_LOB_Report.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.InitSpread) |
| WK-SCP0108-0329 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.RefreshAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 7 (ACT:SCP0108_CAPA_LOB_Report.RefreshAll A) |
| WK-SCP0108-0330 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshBottlenec | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.RefreshBottleneck: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.RefreshBottl) |
| WK-SCP0108-0331 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshDateColum | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.RefreshDateColumnStatus: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/ENTRY/EXPR/LOCAL/UI_MISC |  | 16 (ACT:SCP0108_CAPA_LOB_Report.RefreshDateC) |
| WK-SCP0108-0332 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.RefreshDivision: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0108_CAPA_LOB_Report.RefreshDivis) |
| WK-SCP0108-0333 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshElectrode | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.RefreshElectrodeType: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SCP0108_CAPA_LOB_Report.RefreshElect) |
| WK-SCP0108-0334 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshElectrode | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.RefreshElectrodeTypeAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/DATA_OP/ENTRY, 연결된 요 |  | 5 (ACT:SCP0108_CAPA_LOB_Report.RefreshElect) |
| WK-SCP0108-0335 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshFactory | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.RefreshFactory: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0108_CAPA_LOB_Report.RefreshFacto) |
| WK-SCP0108-0336 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshFactoryAl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.RefreshFactoryAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0108_CAPA_LOB_Report.RefreshFacto) |
| WK-SCP0108-0337 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshLine | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.RefreshLine: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0108_CAPA_LOB_Report.RefreshLine ) |
| WK-SCP0108-0338 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshLineAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.RefreshLineAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0108_CAPA_LOB_Report.RefreshLineA) |
| WK-SCP0108-0339 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshOperation | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.RefreshOperation: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SCP0108_CAPA_LOB_Report.RefreshOpera) |
| WK-SCP0108-0340 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshOperation | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.RefreshOperationAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/DATA_OP/ENTRY, 연결된 요소 검사 |  | 5 (ACT:SCP0108_CAPA_LOB_Report.RefreshOpera) |
| WK-SCP0108-0341 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshPlanType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.RefreshPlanType: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/VALUE_SET, 연결된 요소 검사 없음 |  | 2 (ACT:SCP0108_CAPA_LOB_Report.RefreshPlanT) |
| WK-SCP0108-0342 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshPlant | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.RefreshPlant: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0108_CAPA_LOB_Report.RefreshPlant) |
| WK-SCP0108-0343 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshPlantAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.RefreshPlantAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0108_CAPA_LOB_Report.RefreshPlant) |
| WK-SCP0108-0344 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshProgressS | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.RefreshProgressStatus: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 13 (ACT:SCP0108_CAPA_LOB_Report.RefreshProgr) |
| WK-SCP0108-0345 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshSheetHead | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.RefreshSheetHeader: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY/GRID_INIT, 연결된 요소 검 |  | 5 (ACT:SCP0108_CAPA_LOB_Report.RefreshSheet) |
| WK-SCP0108-0346 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.RefreshSite: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0108_CAPA_LOB_Report.RefreshSite ) |
| WK-SCP0108-0347 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshSiteAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.RefreshSiteAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0108_CAPA_LOB_Report.RefreshSiteA) |
| WK-SCP0108-0348 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshVersion | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.RefreshVersion: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0108_CAPA_LOB_Report.RefreshVersi) |
| WK-SCP0108-0349 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshVersionSe | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.RefreshVersionSeq: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0108_CAPA_LOB_Report.RefreshVersi) |
| WK-SCP0108-0350 | X-ROW | SCP0108_CAPA_LOB_Report.SetQueryInfoGet | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.SetQueryInfoGet: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SCP0108_CAPA_LOB_Report.SetQueryInfo) |
| WK-SCP0108-0351 | X-ROW | SCP0108_CAPA_LOB_Report.SetSheetMerge | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.SetSheetMerge: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.SetSheetMerg) |
| WK-SCP0108-0352 | X-ROW | SCP0108_CAPA_LOB_Report.SetVisibleElectr | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.SetVisibleElectrodeType: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0108_CAPA_LOB_Report.SetVisibleEl) |
| WK-SCP0108-0353 | X-ROW | SCP0108_CAPA_LOB_Report.SetVisibleOperat | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.SetVisibleOperation: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0108_CAPA_LOB_Report.SetVisibleOp) |
| WK-SCP0108-0354 | X-ROW | SCP0108_CAPA_LOB_Report.SetVisibleSheetC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.SetVisibleSheetColumns: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.SetVisibleSh) |
| WK-SCP0108-0355 | X-ROW | SCP0108_CAPA_LOB_Report.ShowItem | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.ShowItem: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/ENTRY/LOCAL/POPUP/RETURN/UI_PROP, 연결된 요소 검사 없음 |  | 9 (ACT:SCP0108_CAPA_LOB_Report.ShowItem ACT) |
| WK-SCP0108-0356 | X-ROW | SCP0108_CAPA_LOB_Report.btnColumn_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.btnColumn_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0108_CAPA_LOB_Report.btnColumn_Cl) |
| WK-SCP0108-0357 | X-ROW | SCP0108_CAPA_LOB_Report.btnItem_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.btnItem_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.btnItem_Clic) |
| WK-SCP0108-0358 | X-ROW | SCP0108_CAPA_LOB_Report.cboDivision_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.cboDivision_SelectedIndexC: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.cboDivision_) |
| WK-SCP0108-0359 | X-ROW | SCP0108_CAPA_LOB_Report.cboFromYYYY_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.cboFromYYYY_SelectedIndexC: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.cboFromYYYY_) |
| WK-SCP0108-0360 | X-ROW | SCP0108_CAPA_LOB_Report.cboSheetType_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.cboSheetType_SelectedIndex: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.cboSheetType) |
| WK-SCP0108-0361 | X-ROW | SCP0108_CAPA_LOB_Report.cboVersionSeq_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.cboVersionSeq_SelectedInde: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.cboVersionSe) |
| WK-SCP0108-0362 | X-ROW | SCP0108_CAPA_LOB_Report.cboVersion_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.cboVersion_SelectedIndexCh: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.cboVersion_S) |
| WK-SCP0108-0363 | X-ROW | SCP0108_CAPA_LOB_Report.clbFactory_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.clbFactory_SelectedIndexCh: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.clbFactory_S) |
| WK-SCP0108-0364 | X-ROW | SCP0108_CAPA_LOB_Report.clbLine_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.clbLine_SelectedIndexChang: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.clbLine_Sele) |
| WK-SCP0108-0365 | X-ROW | SCP0108_CAPA_LOB_Report.clbOperation_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.clbOperation_SelectedIndex: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.clbOperation) |
| WK-SCP0108-0366 | X-ROW | SCP0108_CAPA_LOB_Report.clbPlant_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.clbPlant_SelectedIndexChan: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.clbPlant_Sel) |
| WK-SCP0108-0367 | X-ROW | SCP0108_CAPA_LOB_Report.clbSite_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.clbSite_SelectedIndexChang: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.clbSite_Sele) |
| WK-SCP0108-0368 | X-ROW | SCP0108_CAPA_LOB_Report.getPlanType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.getPlanType: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.getPlanType) |
| WK-SCP0108-0369 | X-ROW | SCP0108_CAPA_LOB_Report.getShopGroup | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.getShopGroup: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.getShopGroup) |
| WK-SCP0108-0370 | X-ROW | SCP0108_CAPA_LOB_Report.rgrpDivisionType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.rgrpDivisionType_SelectedI: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.rgrpDivision) |
| WK-SCP0108-0371 | X-ROW | SCP0108_CAPA_LOB_Report.spdMain_TopChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.spdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.spdMain_TopC) |
| WK-SCP0108-0372 | X-ROW | `_ASSIGN_PRIORITY` 제외 필터 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `_ASSIGN_PRIORITY` 제외 필터: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`_ASSIGN_PRIORITY` 제외 필터) |
| WK-SCP0108-0373 | X-ROW | `_dateStartColIdx` / `_dateEndColIdx` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `_dateStartColIdx` / `_dateEndColIdx`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`_dateStartColIdx` / `_dateEndColIdx`) |
| WK-SCP0108-0374 | X-ROW | `dtFromYYYY`(`YearFromThisYear_SCP_ALL`) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `dtFromYYYY`(`YearFromThisYear_SCP_ALL`): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`dtFromYYYY`(`YearFromThisYear_SCP_ALL`)) |
| WK-SCP0108-0375 | X-ROW | `dtYesOrNo` 필드 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `dtYesOrNo` 필드: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`dtYesOrNo` 필드) |
| WK-SCP0108-0376 | X-ROW | `fetchStaticMeasures` / `staticMeasures` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `fetchStaticMeasures` / `staticMeasures`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`fetchStaticMeasures` / `staticMeasures`) |
| WK-SCP0108-0377 | X-ROW | `hooks/useCapaLobReportCombos.ts` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `hooks/useCapaLobReportCombos.ts`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`hooks/useCapaLobReportCombos.ts`) |
| WK-SCP0108-0378 | X-ROW | `imageList1` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `imageList1`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`imageList1`) |
| WK-SCP0108-0379 | X-ROW | `statusIdx = UIUtils.GetIndexByCode(...) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `statusIdx = UIUtils.GetIndexByCode(...)`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`statusIdx = UIUtils.GetIndexByCode(...)) |
| WK-SCP0108-0380 | X-ROW | `useCapaLobReportStore.ts` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `useCapaLobReportStore.ts`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`useCapaLobReportStore.ts`) |
| WK-SCP0108-0381 | X-ROW | `usrLayoutControl1` / `layoutControlGrou | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `usrLayoutControl1` / `layoutControlGroup1`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`usrLayoutControl1` / `layoutControlGrou) |
| WK-SCP0108-0382 | X-ROW | `utils/capaLobReport.combos.ts` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `utils/capaLobReport.combos.ts`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`utils/capaLobReport.combos.ts`) |
| WK-SCP0108-0383 | X-ROW | `utils/capaLobReport.cursors.ts` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `utils/capaLobReport.cursors.ts`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`utils/capaLobReport.cursors.ts`) |
| WK-SCP0108-0384 | X-ROW | `utils/capaLobReport.dateColumns.ts` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `utils/capaLobReport.dateColumns.ts`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`utils/capaLobReport.dateColumns.ts`) |
| WK-SCP0108-0385 | X-ROW | comboCalls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — comboCalls: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (comboCalls) |
| WK-SCP0108-0386 | X-ROW | controls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — controls: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (controls) |
| WK-SCP0108-0387 | X-ROW | extractionLimits | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — extractionLimits: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (extractionLimits) |
| WK-SCP0108-0388 | X-ROW | filterCalls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — filterCalls: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (filterCalls) |
| WK-SCP0108-0389 | X-ROW | gridColumns | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — gridColumns: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (gridColumns) |
| WK-SCP0108-0390 | G5 | `components/modals/CapaLobReportItemPopu | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — `components/modals/CapaLobReportItemPopup.tsx`: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (`components/modals/CapaLobReportItemPopu) |
| WK-SCP0108-0391 | G5 | entryPoints | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — entryPoints: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (entryPoints) |
| WK-SCP0108-0392 | G5 | popups | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — popups: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (popups) |
| WK-SCP0108-0393 | H6 | `components/modals/CapaLobReportItemPopu | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — `components/modals/CapaLobReportItemPopup.tsx`: 행 집계 — H6 3요소: NOPATH:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (`components/modals/CapaLobReportItemPopu) |
| WK-SCP0108-0394 | H6 | entryPoints | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — entryPoints: 행 집계 — H6 3요소: NOPATH:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (entryPoints) |
| WK-SCP0108-0395 | H6 | popups | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — popups: 행 집계 — H6 3요소: NOPATH:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (popups) |
| WK-SCP0108-0396 | M4 | `components/modals/CapaLobReportItemPopu | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — `components/modals/CapaLobReportItemPopup.tsx`: 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (`components/modals/CapaLobReportItemPopu) |
| WK-SCP0108-0397 | M4 | entryPoints | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — entryPoints: 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (entryPoints) |
| WK-SCP0108-0398 | M4 | popups | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — popups: 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (popups) |
