# 작업 원장 — SCP0105 · 2026-10-26 12:55

> 검사 인스턴스 1388건 중 PASS·NA 330건 외 **1058건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 7 | 구현 위치 실존 |
| W4 | 검사기 구현 | 25 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 70 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 166 | 실행 → PASS |
| W7 | 기대값 확정 | 790 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 767 · E2E 166 · 하네스 95 · 대조표 30
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 6건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 169 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| B4 | COMBO |  |  |  |  | 25 |  | 38 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| B3 | COMBO |  |  |  | 25 |  |  | 34 |  |  | 콤보 후보 정렬 = AS-IS |
| D1 | EDIT |  |  |  |  |  | 8 | 51 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 8 | 51 |  |  | 행 값 기반 조건부 잠금 |
| C3 | CASCADE |  |  |  |  |  | 20 | 34 |  |  | 연쇄 자동 채움 |
| E4 | EDIT |  |  |  |  |  | 31 | 19 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| A5 | DESIGN |  |  |  |  |  | 4 | 45 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H2 | DESIGN |  |  |  |  |  | 5 | 44 |  |  | 배경·글자색 규칙 |
| G1 | GEN |  |  |  |  |  | 13 | 36 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| H5 | DESIGN |  |  |  |  |  | 8 | 37 |  |  | 라벨 명칭 |
| A1 | GEN |  |  |  |  |  |  | 42 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| X-LOC | GEN |  | 7 |  |  |  |  | 22 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| G4 | DESIGN |  |  |  |  | 2 | 13 | 10 |  |  | 조회조건 표시·라벨·활성 |
| C1 | CASCADE |  |  |  |  |  | 11 | 12 |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| G6 | GEN |  |  |  |  |  | 13 | 10 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| X-REASON | DESIGN |  |  |  |  |  |  | 23 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| C4 | CASCADE |  |  |  |  |  | 10 | 12 |  |  | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| C2 | CASCADE |  |  |  |  |  | 1 | 20 |  |  | 그리드 셀 cascade 후보 |
| F4 | DB |  |  |  |  |  | 1 | 17 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| B1 | COMBO |  |  |  |  | 11 |  | 4 |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 11 |  | 4 |  |  | 콤보 후보 중복 없음 |
| G5 | POPUP |  |  |  |  | 4 |  | 9 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 3 | 1 | 9 |  |  | 팝업 표준·열림 |
| D4 | EDIT |  |  |  |  |  | 2 | 11 |  |  | 신규행 기본값·자동세팅·Insert 전제 |
| M4 | POPUP |  |  |  |  |  | 4 | 9 |  |  | 팝업 선택값 반영 |
| B6 | COMBO |  |  |  |  | 10 |  |  |  |  | ALL 옵션·다중선택 사양 |
| A6 | GEN |  |  |  |  |  | 1 | 9 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| D5 | EDIT |  |  |  |  |  | 1 | 5 |  |  | 셀 에디터 유형 |
| E5 | EDIT |  |  |  |  | 1 |  | 4 |  |  | 콤보 셀 후보 외 값 차단 |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
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

## W2 구현 위치 확인 (7)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0105-0001 | X-LOC | COMMON:UC-05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: CapaSpeedPlan.tsx:316-316 > 306줄 |  | 1 (COMMON:UC-05) |
| WK-SCP0105-0002 | X-LOC | D00-1-042 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: CapaSpeedPlan.tsx:307-307 > 306줄 |  | 1 (D00-1-042) |
| WK-SCP0105-0003 | X-LOC | Division 권한 0건 게이트 `SetDivisionAuthCheck | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: CapaSpeedPlan.tsx:307-307 > 306줄 |  | 1 (Division 권한 0건 게이트 `SetDivisionAuthCheck) |
| WK-SCP0105-0004 | X-LOC | `*_ASSIGN_PRIORITY` 숨김 방식 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`*_ASSIGN_PRIORITY` 숨김 방식) |
| WK-SCP0105-0005 | X-LOC | `IsModelDummy` 판정 컬럼 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`IsModelDummy` 판정 컬럼) |
| WK-SCP0105-0006 | X-LOC | `usrConditionPanel1` / `usrLayoutControl | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: CapaSpeedPlan.tsx:302-309 > 306줄 |  | 1 (`usrConditionPanel1` / `usrLayoutControl) |
| WK-SCP0105-0007 | X-LOC | 설비유형 동기화 시 `M` 마킹 범위 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (설비유형 동기화 시 `M` 마킹 범위) |

## W4 검사기 구현 (25)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0105-0008 | B3 | BASE_QTY | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 BASE_QTY | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0105_CAPA_Speed_Plan.GetSpdTitle ) |
| WK-SCP0105-0009 | B3 | COMPANY_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 COMPANY_ID | 있음(SHEET_COLUMNS) | 8 (ACT:SCP0105_CAPA_Speed_Plan.GetExistsDif) |
| WK-SCP0105-0010 | B3 | DIVISION_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 DIVISION_ID | 있음(SHEET_COLUMNS) | 11 (ACT:SCP0105_CAPA_Speed_Plan.GetCurrVersi) |
| WK-SCP0105-0011 | B3 | ELTR_LN_TP_CD | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 ELTR_LN_TP_CD | 있음(SHEET_COLUMNS) | 5 (ACT:SCP0105_CAPA_Speed_Plan.GetExistsDif) |
| WK-SCP0105-0012 | B3 | FACTORY_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 FACTORY_ID | 있음(SHEET_COLUMNS) | 6 (ACT:SCP0105_CAPA_Speed_Plan.GetExistsDif) |
| WK-SCP0105-0013 | B3 | ITEM_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 ITEM_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0105_CAPA_Speed_Plan.getCurrItemI) |
| WK-SCP0105-0014 | B3 | LINE_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 LINE_ID | 있음(SHEET_COLUMNS) | 6 (ACT:SCP0105_CAPA_Speed_Plan.GetExistsDif) |
| WK-SCP0105-0015 | B3 | MSR_TP_CD | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 MSR_TP_CD | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0105_CAPA_Speed_Plan.getCurrMeasu) |
| WK-SCP0105-0016 | B3 | NICK_NAME | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 NICK_NAME | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0105_CAPA_Speed_Plan.getCurrNickn) |
| WK-SCP0105-0017 | B3 | OPERATION_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 OPERATION_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0105_CAPA_Speed_Plan.getCurrOpera) |
| WK-SCP0105-0018 | B3 | PFRSLT_QTY | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 PFRSLT_QTY | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0105_CAPA_Speed_Plan.GetSpdTitle ) |
| WK-SCP0105-0019 | B3 | PLANT_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 PLANT_ID | 있음(SHEET_COLUMNS) | 7 (ACT:SCP0105_CAPA_Speed_Plan.GetExistsDif) |
| WK-SCP0105-0020 | B3 | SITE_ID | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 SITE_ID | 있음(SHEET_COLUMNS) | 8 (ACT:SCP0105_CAPA_Speed_Plan.GetExistsDif) |
| WK-SCP0105-0021 | B3 | cboDivision / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboDivision / Division | 있음(FE 소스) | 2 (ACT:SCP0105_CAPA_Speed_Plan.getDivision ) |
| WK-SCP0105-0022 | B3 | cboProgressStatus / Status / Progress St | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboProgressStatus / Status / Progress Status | 있음(FE 소스) | 2 (ACT:SCP0105_CAPA_Speed_Plan.getProgressS) |
| WK-SCP0105-0023 | B3 | cboVersion / Plan Month / Version / Ver. | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboVersion / Plan Month / Version / Ver. | 있음(FE 소스) | 3 (ACT:SCP0105_CAPA_Speed_Plan.getVersion A) |
| WK-SCP0105-0024 | B3 | cboVersionSeq / Version / Version Seq /  | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboVersionSeq / Version / Version Seq / Ver. | 있음(FE 소스) | 2 (ACT:SCP0105_CAPA_Speed_Plan.getVersionSe) |
| WK-SCP0105-0025 | B3 | clbElectrodeType / Line Type / Electrode | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbElectrodeType / Line Type / Electrode Type | 있음(FE 소스) | 3 (D00-1-012 ACT:SCP0105_CAPA_Speed_Plan.ge) |
| WK-SCP0105-0026 | B3 | clbFactory / Building / Factory | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbFactory / Building / Factory | 있음(FE 소스) | 2 (ACT:SCP0105_CAPA_Speed_Plan.getFactory A) |
| WK-SCP0105-0027 | B3 | clbLine / Line | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbLine / Line | 있음(FE 소스) | 2 (ACT:SCP0105_CAPA_Speed_Plan.getLine ACT:) |
| WK-SCP0105-0028 | B3 | clbOperation / Operation | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbOperation / Operation | 있음(FE 소스) | 2 (ACT:SCP0105_CAPA_Speed_Plan.getOperation) |
| WK-SCP0105-0029 | B3 | clbPlant / Plant | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbPlant / Plant | 있음(FE 소스) | 2 (ACT:SCP0105_CAPA_Speed_Plan.getPlant ACT) |
| WK-SCP0105-0030 | B3 | clbSite / Site | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbSite / Site | 있음(FE 소스) | 2 (ACT:SCP0105_CAPA_Speed_Plan.getSite ACT:) |
| WK-SCP0105-0031 | B3 | rgrpDivisionType / Division Type | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 rgrpDivisionType / Division Type | 있음(FE 소스) | 2 (ACT:SCP0105_CAPA_Speed_Plan.getDivisionT) |
| WK-SCP0105-0032 | B3 | txtItem / ItemNames.MODEL / Item | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 txtItem / ItemNames.MODEL / Item | 있음(FE 소스) | 2 (ACT:SCP0105_CAPA_Speed_Plan.getItemId AC) |

## W5 검사기 연결 (70)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0105-0033 | B1 | ELTR_LN_TP_CD | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL ELTR_LN_TP_CD | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0105-0034 | B1 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (D00-1-008) |
| WK-SCP0105-0035 | B1 | cboProgressStatus / Status / Progress St | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboProgressStatus / Status / Progress Status | 있음(FE 소스) | 1 (D00-1-009) |
| WK-SCP0105-0036 | B1 | cboVersion / Plan Month / Version / Ver. | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboVersion / Plan Month / Version / Ver. | 있음(FE 소스) | 1 (D00-1-010) |
| WK-SCP0105-0037 | B1 | cboVersionSeq / Version / Version Seq /  | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboVersionSeq / Version / Version Seq / Ver. | 있음(FE 소스) | 1 (D00-1-011) |
| WK-SCP0105-0038 | B1 | clbElectrodeType / Line Type / Electrode | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbElectrodeType / Line Type / Electrode Type | 있음(FE 소스) | 1 (D00-1-012) |
| WK-SCP0105-0039 | B1 | clbFactory / Building / Factory | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbFactory / Building / Factory | 있음(FE 소스) | 1 (D00-1-013) |
| WK-SCP0105-0040 | B1 | clbLine / Line | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbLine / Line | 있음(FE 소스) | 1 (D00-1-014) |
| WK-SCP0105-0041 | B1 | clbOperation / Operation | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbOperation / Operation | 있음(FE 소스) | 1 (D00-1-015) |
| WK-SCP0105-0042 | B1 | clbPlant / Plant | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbPlant / Plant | 있음(FE 소스) | 1 (D00-1-016) |
| WK-SCP0105-0043 | B1 | clbSite / Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbSite / Site | 있음(FE 소스) | 1 (D00-1-017) |
| WK-SCP0105-0044 | B2 | ELTR_LN_TP_CD | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL ELTR_LN_TP_CD | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0105-0045 | B2 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (D00-1-008) |
| WK-SCP0105-0046 | B2 | cboProgressStatus / Status / Progress St | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboProgressStatus / Status / Progress Status | 있음(FE 소스) | 1 (D00-1-009) |
| WK-SCP0105-0047 | B2 | cboVersion / Plan Month / Version / Ver. | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboVersion / Plan Month / Version / Ver. | 있음(FE 소스) | 1 (D00-1-010) |
| WK-SCP0105-0048 | B2 | cboVersionSeq / Version / Version Seq /  | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboVersionSeq / Version / Version Seq / Ver. | 있음(FE 소스) | 1 (D00-1-011) |
| WK-SCP0105-0049 | B2 | clbElectrodeType / Line Type / Electrode | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbElectrodeType / Line Type / Electrode Type | 있음(FE 소스) | 1 (D00-1-012) |
| WK-SCP0105-0050 | B2 | clbFactory / Building / Factory | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbFactory / Building / Factory | 있음(FE 소스) | 1 (D00-1-013) |
| WK-SCP0105-0051 | B2 | clbLine / Line | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbLine / Line | 있음(FE 소스) | 1 (D00-1-014) |
| WK-SCP0105-0052 | B2 | clbOperation / Operation | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbOperation / Operation | 있음(FE 소스) | 1 (D00-1-015) |
| WK-SCP0105-0053 | B2 | clbPlant / Plant | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbPlant / Plant | 있음(FE 소스) | 1 (D00-1-016) |
| WK-SCP0105-0054 | B2 | clbSite / Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbSite / Site | 있음(FE 소스) | 1 (D00-1-017) |
| WK-SCP0105-0055 | B4 | BASE_QTY | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL BASE_QTY | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0105_CAPA_Speed_Plan.GetSpdTitle ) |
| WK-SCP0105-0056 | B4 | COMPANY_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL COMPANY_ID | 있음(SHEET_COLUMNS) | 8 (ACT:SCP0105_CAPA_Speed_Plan.GetExistsDif) |
| WK-SCP0105-0057 | B4 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 11 (ACT:SCP0105_CAPA_Speed_Plan.GetCurrVersi) |
| WK-SCP0105-0058 | B4 | ELTR_LN_TP_CD | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL ELTR_LN_TP_CD | 있음(SHEET_COLUMNS) | 6 (COMMON:UC-05 ACT:SCP0105_CAPA_Speed_Plan) |
| WK-SCP0105-0059 | B4 | FACTORY_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL FACTORY_ID | 있음(SHEET_COLUMNS) | 6 (ACT:SCP0105_CAPA_Speed_Plan.GetExistsDif) |
| WK-SCP0105-0060 | B4 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0105_CAPA_Speed_Plan.getCurrItemI) |
| WK-SCP0105-0061 | B4 | LINE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL LINE_ID | 있음(SHEET_COLUMNS) | 6 (ACT:SCP0105_CAPA_Speed_Plan.GetExistsDif) |
| WK-SCP0105-0062 | B4 | MSR_TP_CD | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL MSR_TP_CD | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0105_CAPA_Speed_Plan.getCurrMeasu) |
| WK-SCP0105-0063 | B4 | NICK_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL NICK_NAME | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0105_CAPA_Speed_Plan.getCurrNickn) |
| WK-SCP0105-0064 | B4 | OPERATION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL OPERATION_ID | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0105_CAPA_Speed_Plan.getCurrOpera) |
| WK-SCP0105-0065 | B4 | PFRSLT_QTY | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL PFRSLT_QTY | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0105_CAPA_Speed_Plan.GetSpdTitle ) |
| WK-SCP0105-0066 | B4 | PLANT_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL PLANT_ID | 있음(SHEET_COLUMNS) | 7 (ACT:SCP0105_CAPA_Speed_Plan.GetExistsDif) |
| WK-SCP0105-0067 | B4 | SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL SITE_ID | 있음(SHEET_COLUMNS) | 8 (ACT:SCP0105_CAPA_Speed_Plan.GetExistsDif) |
| WK-SCP0105-0068 | B4 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 3 (D00-1-008 ACT:SCP0105_CAPA_Speed_Plan.ge) |
| WK-SCP0105-0069 | B4 | cboProgressStatus / Status / Progress St | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboProgressStatus / Status / Progress Status | 있음(FE 소스) | 3 (D00-1-009 ACT:SCP0105_CAPA_Speed_Plan.ge) |
| WK-SCP0105-0070 | B4 | cboVersion / Plan Month / Version / Ver. | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboVersion / Plan Month / Version / Ver. | 있음(FE 소스) | 4 (D00-1-010 ACT:SCP0105_CAPA_Speed_Plan.ge) |
| WK-SCP0105-0071 | B4 | cboVersionSeq / Version / Version Seq /  | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboVersionSeq / Version / Version Seq / Ver. | 있음(FE 소스) | 3 (D00-1-011 ACT:SCP0105_CAPA_Speed_Plan.ge) |
| WK-SCP0105-0072 | B4 | clbElectrodeType / Line Type / Electrode | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbElectrodeType / Line Type / Electrode Type | 있음(FE 소스) | 3 (D00-1-012 ACT:SCP0105_CAPA_Speed_Plan.ge) |
| WK-SCP0105-0073 | B4 | clbFactory / Building / Factory | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbFactory / Building / Factory | 있음(FE 소스) | 3 (D00-1-013 ACT:SCP0105_CAPA_Speed_Plan.ge) |
| WK-SCP0105-0074 | B4 | clbLine / Line | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbLine / Line | 있음(FE 소스) | 3 (D00-1-014 ACT:SCP0105_CAPA_Speed_Plan.ge) |
| WK-SCP0105-0075 | B4 | clbOperation / Operation | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbOperation / Operation | 있음(FE 소스) | 3 (D00-1-015 ACT:SCP0105_CAPA_Speed_Plan.ge) |
| WK-SCP0105-0076 | B4 | clbPlant / Plant | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbPlant / Plant | 있음(FE 소스) | 3 (D00-1-016 ACT:SCP0105_CAPA_Speed_Plan.ge) |
| WK-SCP0105-0077 | B4 | clbSite / Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbSite / Site | 있음(FE 소스) | 3 (D00-1-017 ACT:SCP0105_CAPA_Speed_Plan.ge) |
| WK-SCP0105-0078 | B4 | rgrpDivisionType / Division Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND rgrpDivisionType / Division Type | 있음(FE 소스) | 2 (ACT:SCP0105_CAPA_Speed_Plan.getDivisionT) |
| WK-SCP0105-0079 | B4 | txtItem / ItemNames.MODEL / Item | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND txtItem / ItemNames.MODEL / Item | 있음(FE 소스) | 2 (ACT:SCP0105_CAPA_Speed_Plan.getItemId AC) |
| WK-SCP0105-0080 | B6 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (D00-1-008) |
| WK-SCP0105-0081 | B6 | cboProgressStatus / Status / Progress St | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboProgressStatus / Status / Progress Status | 있음(FE 소스) | 1 (D00-1-009) |
| WK-SCP0105-0082 | B6 | cboVersion / Plan Month / Version / Ver. | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboVersion / Plan Month / Version / Ver. | 있음(FE 소스) | 1 (D00-1-010) |
| WK-SCP0105-0083 | B6 | cboVersionSeq / Version / Version Seq /  | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboVersionSeq / Version / Version Seq / Ver. | 있음(FE 소스) | 1 (D00-1-011) |
| WK-SCP0105-0084 | B6 | clbElectrodeType / Line Type / Electrode | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbElectrodeType / Line Type / Electrode Type | 있음(FE 소스) | 1 (D00-1-012) |
| WK-SCP0105-0085 | B6 | clbFactory / Building / Factory | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbFactory / Building / Factory | 있음(FE 소스) | 1 (D00-1-013) |
| WK-SCP0105-0086 | B6 | clbLine / Line | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbLine / Line | 있음(FE 소스) | 1 (D00-1-014) |
| WK-SCP0105-0087 | B6 | clbOperation / Operation | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbOperation / Operation | 있음(FE 소스) | 1 (D00-1-015) |
| WK-SCP0105-0088 | B6 | clbPlant / Plant | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbPlant / Plant | 있음(FE 소스) | 1 (D00-1-016) |
| WK-SCP0105-0089 | B6 | clbSite / Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbSite / Site | 있음(FE 소스) | 1 (D00-1-017) |
| WK-SCP0105-0090 | F2 | SCP0105 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0105 화면 | 판단불가(대상 단위 SCREEN) | 56 (D00-3-009 D00-4d-012 D00-4d-013 D00-4d-0) |
| WK-SCP0105-0091 | F6 | SCP0105 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0105 화면 | 판단불가(대상 단위 SCREEN) | 28 (`SaveData()` 변경 0건 가드 `SaveDataMain()` —) |
| WK-SCP0105-0092 | G4 | btnItem | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItem | 없음 | 2 (ACT:SCP0105_CAPA_Speed_Plan.InitEvent AC) |
| WK-SCP0105-0093 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 없음 | 2 (ACT:SCP0105_CAPA_Speed_Plan.InitEvent AC) |
| WK-SCP0105-0094 | E5 | ELTR_LN_TP_CD | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL ELTR_LN_TP_CD | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0105-0095 | G03-WIRE | SCP0105 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0105 화면 | 판단불가(대상 단위 SCREEN) | 18 (ACT:SCP0105_CAPA_Speed_Plan..ctor ACT:SC) |
| WK-SCP0105-0096 | G5 | btnColumn | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnColumn | 있음(FE 소스) | 1 (`btnColumn_Click` → `SCM002_CAPAColumnPo) |
| WK-SCP0105-0097 | G5 | btnItem | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnItem | 없음 | 1 (`txtItem` + `btnItemId`) |
| WK-SCP0105-0098 | G5 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnItemId | 없음 | 4 (D00-1-007 D00-2-003 `txtItem` + `btnItem) |
| WK-SCP0105-0099 | G5 | txtItem / ItemNames.MODEL / Item | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND txtItem / ItemNames.MODEL / Item | 있음(FE 소스) | 2 (D00-1-038 `txtItem` + `btnItemId`) |
| WK-SCP0105-0100 | H6 | btnColumn | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnColumn | 있음(FE 소스) | 1 (`btnColumn_Click` → `SCM002_CAPAColumnPo) |
| WK-SCP0105-0101 | H6 | btnItem | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnItem | 없음 | 1 (`txtItem` + `btnItemId`) |
| WK-SCP0105-0102 | H6 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnItemId | 없음 | 4 (D00-1-007 D00-2-003 `txtItem` + `btnItem) |

## W6 검증 실행 (166)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0105-0103 | J2 | SCP0105 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0105 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 128 (D00-1-011 D00-1-025 D00-1-026 D00-1-042 ) |
| WK-SCP0105-0104 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-004 ACT:SCP0105_CAPA_Speed_Plan.Re) |
| WK-SCP0105-0105 | C1 | cboProgressStatus / Status / Progress St | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboProgressStatus / Status / Progress Status · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-005 ACT:SCP0105_CAPA_Speed_Plan.Re) |
| WK-SCP0105-0106 | C1 | cboVersion / Plan Month / Version / Ver. | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboVersion / Plan Month / Version / Ver. · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-006 ACT:SCP0105_CAPA_Speed_Plan.Re) |
| WK-SCP0105-0107 | C1 | cboVersionSeq / Version / Version Seq /  | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboVersionSeq / Version / Version Seq / Ver. · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-007 ACT:SCP0105_CAPA_Speed_Plan.Re) |
| WK-SCP0105-0108 | C1 | clbElectrodeType / Line Type / Electrode | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbElectrodeType / Line Type / Electrode Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.RefreshElect) |
| WK-SCP0105-0109 | C1 | clbFactory / Building / Factory | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbFactory / Building / Factory · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-008 ACT:SCP0105_CAPA_Speed_Plan.Re) |
| WK-SCP0105-0110 | C1 | clbLine / Line | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbLine / Line · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-009 ACT:SCP0105_CAPA_Speed_Plan.Re) |
| WK-SCP0105-0111 | C1 | clbOperation / Operation | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbOperation / Operation · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-010 ACT:SCP0105_CAPA_Speed_Plan.Re) |
| WK-SCP0105-0112 | C1 | clbPlant / Plant | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbPlant / Plant · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-011 ACT:SCP0105_CAPA_Speed_Plan.Re) |
| WK-SCP0105-0113 | C1 | clbSite / Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbSite / Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-012 ACT:SCP0105_CAPA_Speed_Plan.Re) |
| WK-SCP0105-0114 | C1 | rgrpDivisionType / Division Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — rgrpDivisionType / Division Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (D00-2-013) |
| WK-SCP0105-0115 | C2 | ELTR_LN_TP_CD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — ELTR_LN_TP_CD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.SpdMain_Cell) |
| WK-SCP0105-0116 | C3 | BASE_EDITABLE_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — BASE_EDITABLE_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.SetLockColum) |
| WK-SCP0105-0117 | C3 | BASE_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — BASE_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 11 (ACT:SCP0105_CAPA_Speed_Plan.SetBaseToDat) |
| WK-SCP0105-0118 | C3 | COMPANY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — COMPANY_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 7 (ACT:SCP0105_CAPA_Speed_Plan.CheckEltrEqu) |
| WK-SCP0105-0119 | C3 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 7 (ACT:SCP0105_CAPA_Speed_Plan.CheckEltrEqu) |
| WK-SCP0105-0120 | C3 | EDITABLE_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — EDITABLE_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.SetLockColum) |
| WK-SCP0105-0121 | C3 | ELTR_LN_TP_CD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ELTR_LN_TP_CD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 7 (ACT:SCP0105_CAPA_Speed_Plan.CheckEltrEqu) |
| WK-SCP0105-0122 | C3 | EQUIPMENT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — EQUIPMENT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.SetLockColum) |
| WK-SCP0105-0123 | C3 | FACTORY_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — FACTORY_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0105_CAPA_Speed_Plan.SetQueryInfo) |
| WK-SCP0105-0124 | C3 | IDX | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — IDX · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.SetLockColum) |
| WK-SCP0105-0125 | C3 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0105_CAPA_Speed_Plan.SetQueryInfo) |
| WK-SCP0105-0126 | C3 | LINE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — LINE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0105_CAPA_Speed_Plan.SetQueryInfo) |
| WK-SCP0105-0127 | C3 | MEASURE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — MEASURE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.Set_MeasureC) |
| WK-SCP0105-0128 | C3 | MSR_TP_CD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — MSR_TP_CD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 14 (ACT:SCP0105_CAPA_Speed_Plan.SetLockColum) |
| WK-SCP0105-0129 | C3 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 7 (ACT:SCP0105_CAPA_Speed_Plan.SetQueryInfo) |
| WK-SCP0105-0130 | C3 | NICK_NAME_DUMMY_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — NICK_NAME_DUMMY_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0105_CAPA_Speed_Plan.SetLockColum) |
| WK-SCP0105-0131 | C3 | OPERATION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — OPERATION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 8 (ACT:SCP0105_CAPA_Speed_Plan.SetLockColum) |
| WK-SCP0105-0132 | C3 | PFRSLT_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PFRSLT_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0105_CAPA_Speed_Plan.SetQueryInfo) |
| WK-SCP0105-0133 | C3 | PLANT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PLANT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0105_CAPA_Speed_Plan.SetQueryInfo) |
| WK-SCP0105-0134 | C3 | SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 7 (ACT:SCP0105_CAPA_Speed_Plan.CheckEltrEqu) |
| WK-SCP0105-0135 | C3 | UI_UPD_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — UI_UPD_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 6 (ACT:SCP0105_CAPA_Speed_Plan.SetLockColum) |
| WK-SCP0105-0136 | C4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-004) |
| WK-SCP0105-0137 | C4 | cboProgressStatus / Status / Progress St | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboProgressStatus / Status / Progress Status · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-005) |
| WK-SCP0105-0138 | C4 | cboVersion / Plan Month / Version / Ver. | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboVersion / Plan Month / Version / Ver. · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-006) |
| WK-SCP0105-0139 | C4 | cboVersionSeq / Version / Version Seq /  | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboVersionSeq / Version / Version Seq / Ver. · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-007) |
| WK-SCP0105-0140 | C4 | clbFactory / Building / Factory | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — clbFactory / Building / Factory · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-008) |
| WK-SCP0105-0141 | C4 | clbLine / Line | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — clbLine / Line · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-009) |
| WK-SCP0105-0142 | C4 | clbOperation / Operation | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — clbOperation / Operation · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-010) |
| WK-SCP0105-0143 | C4 | clbPlant / Plant | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — clbPlant / Plant · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-011) |
| WK-SCP0105-0144 | C4 | clbSite / Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — clbSite / Site · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-012) |
| WK-SCP0105-0145 | C4 | rgrpDivisionType / Division Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — rgrpDivisionType / Division Type · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-013) |
| WK-SCP0105-0146 | G3 | SCP0105 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0105 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 9 (D00-1-040 COMMON:UC-02 COMMON:UC-03 COMM) |
| WK-SCP0105-0147 | K-SA | SCP0105 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCP0105 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 3 (D00-1-040 `usrConditionPanel1` / `usrLay) |
| WK-SCP0105-0148 | K4 | SCP0105 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0105 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 15 (COMMON:UC-02 COMMON:UC-03 COMMON:UC-04 C) |
| WK-SCP0105-0149 | F1 | SCP0105 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0105 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 73 (D00-3-008 D00-3-009 D00-4d-009 D00-4d-01) |
| WK-SCP0105-0150 | F5 | SCP0105 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0105 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 16 (D00-3-008 D00-4d-009 D00-4d-010 D00-4d-0) |
| WK-SCP0105-0151 | F4 | PKG_SCP0104.P_SCP0104_GET_SPREAD_TITLE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0104.P_SCP0104_GET_SPREAD_TITLE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 3 (기간 헤더 행 스키마 ACT:SCP0105_CAPA_Speed_Plan.) |
| WK-SCP0105-0152 | A5 | EDITABLE_YN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — EDITABLE_YN · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (행 스키마 (두 시트 공통 + 시트별 확장)) |
| WK-SCP0105-0153 | A5 | IDX | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — IDX · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (`_fixed_column_idx` 좌측 고정 행 스키마 (두 시트 공통) |
| WK-SCP0105-0154 | A5 | MEASURE_NAME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — MEASURE_NAME · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (`Set_MeasureColor()` — Measure 행 배경색) |
| WK-SCP0105-0155 | A5 | MMS_CF | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — MMS_CF · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (행 스키마 (두 시트 공통 + 시트별 확장)) |
| WK-SCP0105-0156 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-008 ACT:SCP0105_CAPA_Speed_Plan.In) |
| WK-SCP0105-0157 | G4 | cboProgressStatus / Status / Progress St | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboProgressStatus / Status / Progress Status · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-009 ACT:SCP0105_CAPA_Speed_Plan.In) |
| WK-SCP0105-0158 | G4 | cboVersion / Plan Month / Version / Ver. | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboVersion / Plan Month / Version / Ver. · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-010 ACT:SCP0105_CAPA_Speed_Plan.In) |
| WK-SCP0105-0159 | G4 | cboVersionSeq / Version / Version Seq /  | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboVersionSeq / Version / Version Seq / Ver. · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-011 ACT:SCP0105_CAPA_Speed_Plan.In) |
| WK-SCP0105-0160 | G4 | clbElectrodeType / Line Type / Electrode | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbElectrodeType / Line Type / Electrode Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-012) |
| WK-SCP0105-0161 | G4 | clbFactory / Building / Factory | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbFactory / Building / Factory · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-013 ACT:SCP0105_CAPA_Speed_Plan.In) |
| WK-SCP0105-0162 | G4 | clbLine / Line | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbLine / Line · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-014 ACT:SCP0105_CAPA_Speed_Plan.In) |
| WK-SCP0105-0163 | G4 | clbOperation / Operation | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbOperation / Operation · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-015 ACT:SCP0105_CAPA_Speed_Plan.In) |
| WK-SCP0105-0164 | G4 | clbPlant / Plant | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbPlant / Plant · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-016 ACT:SCP0105_CAPA_Speed_Plan.In) |
| WK-SCP0105-0165 | G4 | clbSite / Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbSite / Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-017 ACT:SCP0105_CAPA_Speed_Plan.In) |
| WK-SCP0105-0166 | G4 | rgrpDivisionType / Division Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — rgrpDivisionType / Division Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-035 ACT:SCP0105_CAPA_Speed_Plan.In) |
| WK-SCP0105-0167 | G4 | txtItem / ItemNames.MODEL / Item | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtItem / ItemNames.MODEL / Item · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-038) |
| WK-SCP0105-0168 | G4 | txtPlanType / _plan_type / Plan Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtPlanType / _plan_type / Plan Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-039) |
| WK-SCP0105-0169 | H2 | EDITABLE_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — EDITABLE_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (행 스키마 (두 시트 공통 + 시트별 확장)) |
| WK-SCP0105-0170 | H2 | IDX | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — IDX · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (`_fixed_column_idx` 좌측 고정 행 스키마 (두 시트 공통) |
| WK-SCP0105-0171 | H2 | MEASURE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — MEASURE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (`Set_MeasureColor()` — Measure 행 배경색 ACT) |
| WK-SCP0105-0172 | H2 | MMS_CF | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — MMS_CF · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (행 스키마 (두 시트 공통 + 시트별 확장)) |
| WK-SCP0105-0173 | H2 | MSR_TP_CD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — MSR_TP_CD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.Set_MeasureC) |
| WK-SCP0105-0174 | H5 | EDITABLE_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — EDITABLE_YN · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (행 스키마 (두 시트 공통 + 시트별 확장)) |
| WK-SCP0105-0175 | H5 | IDX | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — IDX · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (`_fixed_column_idx` 좌측 고정 행 스키마 (두 시트 공통) |
| WK-SCP0105-0176 | H5 | MEASURE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — MEASURE_NAME · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (`Set_MeasureColor()` — Measure 행 배경색) |
| WK-SCP0105-0177 | H5 | MMS_CF | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — MMS_CF · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (행 스키마 (두 시트 공통 + 시트별 확장)) |
| WK-SCP0105-0178 | H5 | cboDivision / Division | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — cboDivision / Division · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (D00-2-004) |
| WK-SCP0105-0179 | H5 | cboVersion / Plan Month / Version / Ver. | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — cboVersion / Plan Month / Version / Ver. · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective) |  | 1 (D00-2-006) |
| WK-SCP0105-0180 | H5 | clbElectrodeType / Line Type / Electrode | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — clbElectrodeType / Line Type / Electrode Type · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effec |  | 1 (`clbElectrodeType` (Line Type)) |
| WK-SCP0105-0181 | H5 | rgrpDivisionType / Division Type | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — rgrpDivisionType / Division Type · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필 |  | 1 (10) |
| WK-SCP0105-0182 | I1 | SCP0105 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0105 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 16 (D00-1-042 D00-4d-005 D00-4d-008 COMMON:U) |
| WK-SCP0105-0183 | SC1 | SCP0105 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SCP0105 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 23 (D00-1-008 D00-1-009 D00-1-010 D00-1-011 ) |
| WK-SCP0105-0184 | D1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (`RefreshElectrodeTypeSpread()` — 행 기준 후보) |
| WK-SCP0105-0185 | D1 | EDITABLE_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — EDITABLE_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (`SetLockColumnsELTR()` `EDITABLE_YN` 소비 ) |
| WK-SCP0105-0186 | D1 | ELTR_LN_TP_CD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — ELTR_LN_TP_CD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (D00-3-021 `ELTR_LN_TP_CD` 편집 조건 (03 R-08) |
| WK-SCP0105-0187 | D1 | EQUIPMENT_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — EQUIPMENT_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (`ELTR_LN_TP_CD` 편집 조건 (03 R-08)) |
| WK-SCP0105-0188 | D1 | IDX | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — IDX · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (D00-3-005 `_fixed_column_idx` 좌측 고정 `IsM) |
| WK-SCP0105-0189 | D1 | NICK_NAME_DUMMY_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — NICK_NAME_DUMMY_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (`IsModelDummy()` — 더미 모델 스킵) |
| WK-SCP0105-0190 | D1 | OPERATION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — OPERATION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (`RefreshElectrodeTypeSpread()` — 행 기준 후보) |
| WK-SCP0105-0191 | D1 | UI_UPD_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — UI_UPD_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (`ELTR_LN_TP_CD` 편집 조건 (03 R-08)) |
| WK-SCP0105-0192 | D3 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (`RefreshElectrodeTypeSpread()` — 행 기준 후보) |
| WK-SCP0105-0193 | D3 | EDITABLE_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — EDITABLE_YN · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (`SetLockColumnsELTR()` `EDITABLE_YN` 소비 ) |
| WK-SCP0105-0194 | D3 | ELTR_LN_TP_CD | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ELTR_LN_TP_CD · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (D00-3-021 `ELTR_LN_TP_CD` 편집 조건 (03 R-08) |
| WK-SCP0105-0195 | D3 | EQUIPMENT_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — EQUIPMENT_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (`ELTR_LN_TP_CD` 편집 조건 (03 R-08)) |
| WK-SCP0105-0196 | D3 | IDX | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — IDX · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (D00-3-005 `_fixed_column_idx` 좌측 고정 `IsM) |
| WK-SCP0105-0197 | D3 | NICK_NAME_DUMMY_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — NICK_NAME_DUMMY_YN · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (`IsModelDummy()` — 더미 모델 스킵) |
| WK-SCP0105-0198 | D3 | OPERATION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — OPERATION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (`RefreshElectrodeTypeSpread()` — 행 기준 후보) |
| WK-SCP0105-0199 | D3 | UI_UPD_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — UI_UPD_YN · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (`ELTR_LN_TP_CD` 편집 조건 (03 R-08)) |
| WK-SCP0105-0200 | D4 | EDITABLE_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — EDITABLE_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (`SetLockColumnsELTR()`) |
| WK-SCP0105-0201 | D4 | ELTR_LN_TP_CD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — ELTR_LN_TP_CD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (D00-3-021) |
| WK-SCP0105-0202 | D5 | ELTR_LN_TP_CD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ELTR_LN_TP_CD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (COMMON:UC-05) |
| WK-SCP0105-0203 | D6 | SCP0105 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0105 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 6 (D00-3-008 COMMON:UC-03 `SetLockColumnsEL) |
| WK-SCP0105-0204 | E4 | BASE_EDITABLE_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — BASE_EDITABLE_YN · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.SetLockColum) |
| WK-SCP0105-0205 | E4 | BASE_QTY | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — BASE_QTY · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 11 (ACT:SCP0105_CAPA_Speed_Plan.SetBaseToDat) |
| WK-SCP0105-0206 | E4 | COMPANY_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — COMPANY_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (ACT:SCP0105_CAPA_Speed_Plan.SetQueryInfo) |
| WK-SCP0105-0207 | E4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (ACT:SCP0105_CAPA_Speed_Plan.SetQueryInfo) |
| WK-SCP0105-0208 | E4 | EDITABLE_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — EDITABLE_YN · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.SetLockColum) |
| WK-SCP0105-0209 | E4 | ELTR_LN_TP_CD | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ELTR_LN_TP_CD · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 6 (ACT:SCP0105_CAPA_Speed_Plan.SetLockColum) |
| WK-SCP0105-0210 | E4 | EQUIPMENT_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — EQUIPMENT_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.SetLockColum) |
| WK-SCP0105-0211 | E4 | FACTORY_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — FACTORY_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SCP0105_CAPA_Speed_Plan.SetQueryInfo) |
| WK-SCP0105-0212 | E4 | IDX | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — IDX · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.SetLockColum) |
| WK-SCP0105-0213 | E4 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SCP0105_CAPA_Speed_Plan.SetQueryInfo) |
| WK-SCP0105-0214 | E4 | LINE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — LINE_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SCP0105_CAPA_Speed_Plan.SetQueryInfo) |
| WK-SCP0105-0215 | E4 | MEASURE_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MEASURE_NAME · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.Set_MeasureC) |
| WK-SCP0105-0216 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (저장 성공 메시지 `MSG00004` ACT:SCP0105_CAPA_Sp) |
| WK-SCP0105-0217 | E4 | MSG00006 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00006 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.AfterSaveDat) |
| WK-SCP0105-0218 | E4 | MSG00096 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00096 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (버튼 권한 게이트 (`CanUpdate`, `MSG00096`)) |
| WK-SCP0105-0219 | E4 | MSG00097 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00097 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (Division 권한 0건 게이트 `SetDivisionAuthCheck) |
| WK-SCP0105-0220 | E4 | MSG00109 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00109 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (D00-4d-008 Edit 차단 메시지 `MSG00109` ACT:SC) |
| WK-SCP0105-0221 | E4 | MSG00133 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00133 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (`SaveData()` 변경 0건 가드 ACT:SCP0105_CAPA_S) |
| WK-SCP0105-0222 | E4 | MSG00426 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00426 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (12 ACT:SCP0105_CAPA_Speed_Plan.AfterSave) |
| WK-SCP0105-0223 | E4 | MSG00667 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00667 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (D00-1-042 Division 권한 0건 게이트 `SetDivisio) |
| WK-SCP0105-0224 | E4 | MSG00672 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00672 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (COMMON:UC-04 저장 성공 메시지 `MSG00004`) |
| WK-SCP0105-0225 | E4 | MSG00703 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00703 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-02) |
| WK-SCP0105-0226 | E4 | MSG00704 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00704 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-02) |
| WK-SCP0105-0227 | E4 | MSR_TP_CD | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSR_TP_CD · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 14 (ACT:SCP0105_CAPA_Speed_Plan.SetLockColum) |
| WK-SCP0105-0228 | E4 | NICK_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — NICK_NAME · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 7 (ACT:SCP0105_CAPA_Speed_Plan.SetQueryInfo) |
| WK-SCP0105-0229 | E4 | NICK_NAME_DUMMY_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — NICK_NAME_DUMMY_YN · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SCP0105_CAPA_Speed_Plan.SetLockColum) |
| WK-SCP0105-0230 | E4 | OPERATION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — OPERATION_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 8 (ACT:SCP0105_CAPA_Speed_Plan.SetLockColum) |
| WK-SCP0105-0231 | E4 | PFRSLT_QTY | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — PFRSLT_QTY · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SCP0105_CAPA_Speed_Plan.SetQueryInfo) |
| WK-SCP0105-0232 | E4 | PLANT_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — PLANT_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SCP0105_CAPA_Speed_Plan.SetQueryInfo) |
| WK-SCP0105-0233 | E4 | SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — SITE_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (ACT:SCP0105_CAPA_Speed_Plan.SetQueryInfo) |
| WK-SCP0105-0234 | E4 | UI_UPD_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — UI_UPD_YN · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 6 (ACT:SCP0105_CAPA_Speed_Plan.SetLockColum) |
| WK-SCP0105-0235 | A10 | SCP0105 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0105 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 52 (ACT:SCP0105_CAPA_Speed_Plan.Form_Load AC) |
| WK-SCP0105-0236 | A6 | PKG_SCP0104.P_SCP0104_GET_SPREAD_TITLE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0104.P_SCP0104_GET_SPREAD_TITLE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) ·  |  | 1 (기간 헤더 행 스키마) |
| WK-SCP0105-0237 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (D00-1-008 D00-2-004) |
| WK-SCP0105-0238 | G1 | cboProgressStatus / Status / Progress St | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboProgressStatus / Status / Progress Status · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-009) |
| WK-SCP0105-0239 | G1 | cboVersion / Plan Month / Version / Ver. | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboVersion / Plan Month / Version / Ver. · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (D00-1-010 D00-2-006) |
| WK-SCP0105-0240 | G1 | cboVersionSeq / Version / Version Seq /  | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboVersionSeq / Version / Version Seq / Ver. · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-011) |
| WK-SCP0105-0241 | G1 | clbElectrodeType / Line Type / Electrode | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbElectrodeType / Line Type / Electrode Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-012) |
| WK-SCP0105-0242 | G1 | clbFactory / Building / Factory | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbFactory / Building / Factory · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-013) |
| WK-SCP0105-0243 | G1 | clbLine / Line | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbLine / Line · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-014) |
| WK-SCP0105-0244 | G1 | clbOperation / Operation | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbOperation / Operation · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-015) |
| WK-SCP0105-0245 | G1 | clbPlant / Plant | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbPlant / Plant · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-016) |
| WK-SCP0105-0246 | G1 | clbSite / Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbSite / Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-017) |
| WK-SCP0105-0247 | G1 | rgrpDivisionType / Division Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — rgrpDivisionType / Division Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (D00-1-035 D00-2-013) |
| WK-SCP0105-0248 | G1 | txtItem / ItemNames.MODEL / Item | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItem / ItemNames.MODEL / Item · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-038) |
| WK-SCP0105-0249 | G1 | txtPlanType / _plan_type / Plan Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtPlanType / _plan_type / Plan Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-039) |
| WK-SCP0105-0250 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-008 ACT:SCP0105_CAPA_Speed_Plan.In) |
| WK-SCP0105-0251 | G6 | cboProgressStatus / Status / Progress St | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboProgressStatus / Status / Progress Status · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-009 ACT:SCP0105_CAPA_Speed_Plan.In) |
| WK-SCP0105-0252 | G6 | cboVersion / Plan Month / Version / Ver. | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboVersion / Plan Month / Version / Ver. · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-010 ACT:SCP0105_CAPA_Speed_Plan.In) |
| WK-SCP0105-0253 | G6 | cboVersionSeq / Version / Version Seq /  | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboVersionSeq / Version / Version Seq / Ver. · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-011 ACT:SCP0105_CAPA_Speed_Plan.In) |
| WK-SCP0105-0254 | G6 | clbElectrodeType / Line Type / Electrode | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbElectrodeType / Line Type / Electrode Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-012) |
| WK-SCP0105-0255 | G6 | clbFactory / Building / Factory | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbFactory / Building / Factory · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-013 ACT:SCP0105_CAPA_Speed_Plan.In) |
| WK-SCP0105-0256 | G6 | clbLine / Line | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbLine / Line · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-014 ACT:SCP0105_CAPA_Speed_Plan.In) |
| WK-SCP0105-0257 | G6 | clbOperation / Operation | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbOperation / Operation · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-015 ACT:SCP0105_CAPA_Speed_Plan.In) |
| WK-SCP0105-0258 | G6 | clbPlant / Plant | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbPlant / Plant · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-016 ACT:SCP0105_CAPA_Speed_Plan.In) |
| WK-SCP0105-0259 | G6 | clbSite / Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbSite / Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-017 ACT:SCP0105_CAPA_Speed_Plan.In) |
| WK-SCP0105-0260 | G6 | rgrpDivisionType / Division Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — rgrpDivisionType / Division Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-035 ACT:SCP0105_CAPA_Speed_Plan.In) |
| WK-SCP0105-0261 | G6 | txtItem / ItemNames.MODEL / Item | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtItem / ItemNames.MODEL / Item · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-038) |
| WK-SCP0105-0262 | G6 | txtPlanType / _plan_type / Plan Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtPlanType / _plan_type / Plan Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-039) |
| WK-SCP0105-0263 | X-REOPEN | SCP0105 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0105 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 5 (ACT:SCP0105_CAPA_Speed_Plan.Dispose ACT:) |
| WK-SCP0105-0264 | H6 | txtItem / ItemNames.MODEL / Item | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtItem / ItemNames.MODEL / Item · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 2 (D00-1-038 `txtItem` + `btnItemId`) |
| WK-SCP0105-0265 | M4 | btnColumn | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnColumn · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (`btnColumn_Click` → `SCM002_CAPAColumnPo) |
| WK-SCP0105-0266 | M4 | btnItem | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnItem · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (`txtItem` + `btnItemId`) |
| WK-SCP0105-0267 | M4 | btnItemId | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnItemId · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (D00-1-007 D00-2-003 `txtItem` + `btnItem) |
| WK-SCP0105-0268 | M4 | txtItem / ItemNames.MODEL / Item | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtItem / ItemNames.MODEL / Item · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (D00-1-038 `txtItem` + `btnItemId`) |

## W7 기대값 확정 (790)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0105-0269 | C1 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 6: 행 집계 — C1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (6) |
| WK-SCP0105-0270 | C1 | Division 변경 시 그리드·컬럼셋 초기화 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — Division 변경 시 그리드·컬럼셋 초기화: 행 집계 — C1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (Division 변경 시 그리드·컬럼셋 초기화) |
| WK-SCP0105-0271 | C1 | `cboDivision_SelectedIndexChanged` | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — `cboDivision_SelectedIndexChanged`: 행 집계 — C1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (`cboDivision_SelectedIndexChanged`) |
| WK-SCP0105-0272 | C1 | `cboProgressStatus_SelectedIndexChanged` | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — `cboProgressStatus_SelectedIndexChanged`: 행 집계 — C1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (`cboProgressStatus_SelectedIndexChanged`) |
| WK-SCP0105-0273 | C1 | `cboVersionSeq_SelectedIndexChanged` | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — `cboVersionSeq_SelectedIndexChanged`: 행 집계 — C1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (`cboVersionSeq_SelectedIndexChanged`) |
| WK-SCP0105-0274 | C1 | `cboVersion_SelectedIndexChanged` | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — `cboVersion_SelectedIndexChanged`: 행 집계 — C1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (`cboVersion_SelectedIndexChanged`) |
| WK-SCP0105-0275 | C1 | `clbFactory_SelectedIndexChanged` | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — `clbFactory_SelectedIndexChanged`: 행 집계 — C1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (`clbFactory_SelectedIndexChanged`) |
| WK-SCP0105-0276 | C1 | `clbLine_SelectedIndexChanged` | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — `clbLine_SelectedIndexChanged`: 행 집계 — C1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (`clbLine_SelectedIndexChanged`) |
| WK-SCP0105-0277 | C1 | `clbOperation_SelectedIndexChanged` | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — `clbOperation_SelectedIndexChanged`: 행 집계 — C1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (`clbOperation_SelectedIndexChanged`) |
| WK-SCP0105-0278 | C1 | `clbPlant_SelectedIndexChanged` | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — `clbPlant_SelectedIndexChanged`: 행 집계 — C1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (`clbPlant_SelectedIndexChanged`) |
| WK-SCP0105-0279 | C1 | `clbSite_SelectedIndexChanged` | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — `clbSite_SelectedIndexChanged`: 행 집계 — C1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (`clbSite_SelectedIndexChanged`) |
| WK-SCP0105-0280 | C1 | `rgrpDivisionType_SelectedIndexChanged` | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — `rgrpDivisionType_SelectedIndexChanged`: 행 집계 — C1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (`rgrpDivisionType_SelectedIndexChanged`) |
| WK-SCP0105-0281 | C2 | D00-4d-016 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-4d-016: 행 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-016) |
| WK-SCP0105-0282 | C2 | D00-4d-017 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-4d-017: 행 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-017) |
| WK-SCP0105-0283 | C2 | D00-4d-018 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-4d-018: 행 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-018) |
| WK-SCP0105-0284 | C2 | D00-4d-019 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-4d-019: 행 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-019) |
| WK-SCP0105-0285 | C2 | D00-4d-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-4d-020: 행 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-020) |
| WK-SCP0105-0286 | C2 | D00-4d-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — D00-4d-021: 행 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-021) |
| WK-SCP0105-0287 | C2 | SCP0105_CAPA_Speed_Plan._defaultDataMode | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0105_CAPA_Speed_Plan._defaultDataModel_Changed: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 15 (ACT:SCP0105_CAPA_Speed_Plan._defaultData) |
| WK-SCP0105-0288 | C2 | SCP0105_CAPA_Speed_Plan.cboDivision_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0105_CAPA_Speed_Plan.cboDivision_SelectedIndexC: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0105_CAPA_Speed_Plan.cboDivision_) |
| WK-SCP0105-0289 | C2 | SCP0105_CAPA_Speed_Plan.cboFromYYYY_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0105_CAPA_Speed_Plan.cboFromYYYY_SelectedIndexC: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0105_CAPA_Speed_Plan.cboFromYYYY_) |
| WK-SCP0105-0290 | C2 | SCP0105_CAPA_Speed_Plan.cboProgressStatu | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0105_CAPA_Speed_Plan.cboProgressStatus_Selected: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.cboProgressS) |
| WK-SCP0105-0291 | C2 | SCP0105_CAPA_Speed_Plan.cboVersionSeq_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0105_CAPA_Speed_Plan.cboVersionSeq_SelectedInde: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0105_CAPA_Speed_Plan.cboVersionSe) |
| WK-SCP0105-0292 | C2 | SCP0105_CAPA_Speed_Plan.cboVersion_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0105_CAPA_Speed_Plan.cboVersion_SelectedIndexCh: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0105_CAPA_Speed_Plan.cboVersion_S) |
| WK-SCP0105-0293 | C2 | SCP0105_CAPA_Speed_Plan.clbFactory_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0105_CAPA_Speed_Plan.clbFactory_SelectedIndexCh: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.clbFactory_S) |
| WK-SCP0105-0294 | C2 | SCP0105_CAPA_Speed_Plan.clbLine_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0105_CAPA_Speed_Plan.clbLine_SelectedIndexChang: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.clbLine_Sele) |
| WK-SCP0105-0295 | C2 | SCP0105_CAPA_Speed_Plan.clbOperation_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0105_CAPA_Speed_Plan.clbOperation_SelectedIndex: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.clbOperation) |
| WK-SCP0105-0296 | C2 | SCP0105_CAPA_Speed_Plan.clbPlant_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0105_CAPA_Speed_Plan.clbPlant_SelectedIndexChan: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0105_CAPA_Speed_Plan.clbPlant_Sel) |
| WK-SCP0105-0297 | C2 | SCP0105_CAPA_Speed_Plan.clbSite_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0105_CAPA_Speed_Plan.clbSite_SelectedIndexChang: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0105_CAPA_Speed_Plan.clbSite_Sele) |
| WK-SCP0105-0298 | C2 | SCP0105_CAPA_Speed_Plan.rgrpDivisionType | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0105_CAPA_Speed_Plan.rgrpDivisionType_SelectedI: 진입점 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0105_CAPA_Speed_Plan.rgrpDivision) |
| WK-SCP0105-0299 | C2 | `InitEvent()` — 이벤트 배선 13건 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — `InitEvent()` — 이벤트 배선 13건: 행 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (`InitEvent()` — 이벤트 배선 13건) |
| WK-SCP0105-0300 | C2 | `_defaultDataModel_Changed` — 셀 변경 후속 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — `_defaultDataModel_Changed` — 셀 변경 후속: 행 집계 — C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (`_defaultDataModel_Changed` — 셀 변경 후속) |
| WK-SCP0105-0301 | C3 | D00-4d-016 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-4d-016: 행 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-016) |
| WK-SCP0105-0302 | C3 | D00-4d-017 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-4d-017: 행 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-017) |
| WK-SCP0105-0303 | C3 | D00-4d-018 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-4d-018: 행 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-018) |
| WK-SCP0105-0304 | C3 | D00-4d-019 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-4d-019: 행 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-019) |
| WK-SCP0105-0305 | C3 | D00-4d-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-4d-020: 행 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-020) |
| WK-SCP0105-0306 | C3 | D00-4d-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-4d-021: 행 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-021) |
| WK-SCP0105-0307 | C3 | SCP0105_CAPA_Speed_Plan.SetBaseToDateCol | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0105_CAPA_Speed_Plan.SetBaseToDateColumns: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCP0105_CAPA_Speed_Plan.SetBaseToDat) |
| WK-SCP0105-0308 | C3 | SCP0105_CAPA_Speed_Plan.SetLockColumns | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0105_CAPA_Speed_Plan.SetLockColumns: 진입점 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0105_CAPA_Speed_Plan.SetLockColum) |
| WK-SCP0105-0309 | C3 | SCP0105_CAPA_Speed_Plan.SetLockColumnsAS | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0105_CAPA_Speed_Plan.SetLockColumnsASSEMBLY: 진입점 집계 — C3 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 32 (ACT:SCP0105_CAPA_Speed_Plan.SetLockColum) |
| WK-SCP0105-0310 | C3 | SCP0105_CAPA_Speed_Plan.SetLockColumnsEL | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0105_CAPA_Speed_Plan.SetLockColumnsELTR: 진입점 집계 — C3 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 46 (ACT:SCP0105_CAPA_Speed_Plan.SetLockColum) |
| WK-SCP0105-0311 | C3 | SCP0105_CAPA_Speed_Plan.SetQueryInfoGet | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0105_CAPA_Speed_Plan.SetQueryInfoGet: 진입점 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 19 (ACT:SCP0105_CAPA_Speed_Plan.SetQueryInfo) |
| WK-SCP0105-0312 | C3 | SCP0105_CAPA_Speed_Plan.SetQueryInfoSave | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0105_CAPA_Speed_Plan.SetQueryInfoSave: 진입점 집계 — C3 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 23 (ACT:SCP0105_CAPA_Speed_Plan.SetQueryInfo) |
| WK-SCP0105-0313 | C3 | SCP0105_CAPA_Speed_Plan.SetSheetMerge | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0105_CAPA_Speed_Plan.SetSheetMerge: 진입점 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.SetSheetMerg) |
| WK-SCP0105-0314 | C3 | SCP0105_CAPA_Speed_Plan.SetSheetNumericC | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0105_CAPA_Speed_Plan.SetSheetNumericColumnForma: 진입점 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0105_CAPA_Speed_Plan.SetSheetNume) |
| WK-SCP0105-0315 | C3 | SCP0105_CAPA_Speed_Plan.SetSheetNumericC | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0105_CAPA_Speed_Plan.SetSheetNumericColumnForma: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0105_CAPA_Speed_Plan.SetSheetNume) |
| WK-SCP0105-0316 | C3 | SCP0105_CAPA_Speed_Plan.SetSheetNumericC | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0105_CAPA_Speed_Plan.SetSheetNumericColumnForma: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0105_CAPA_Speed_Plan.SetSheetNume) |
| WK-SCP0105-0317 | C3 | SCP0105_CAPA_Speed_Plan.SetVisibleElectr | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0105_CAPA_Speed_Plan.SetVisibleElectrodeType: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.SetVisibleEl) |
| WK-SCP0105-0318 | C3 | SCP0105_CAPA_Speed_Plan.SetVisibleOperat | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0105_CAPA_Speed_Plan.SetVisibleOperation: 진입점 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.SetVisibleOp) |
| WK-SCP0105-0319 | C3 | SCP0105_CAPA_Speed_Plan.SetVisibleSheetC | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0105_CAPA_Speed_Plan.SetVisibleSheetColumns: 진입점 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.SetVisibleSh) |
| WK-SCP0105-0320 | C3 | SCP0105_CAPA_Speed_Plan.Set_MeasureColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0105_CAPA_Speed_Plan.Set_MeasureColor: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SCP0105_CAPA_Speed_Plan.Set_MeasureC) |
| WK-SCP0105-0321 | C3 | SCP0105_CAPA_Speed_Plan._defaultDataMode | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0105_CAPA_Speed_Plan._defaultDataModel_Changed: 진입점 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 15 (ACT:SCP0105_CAPA_Speed_Plan._defaultData) |
| WK-SCP0105-0322 | C3 | SCP0105_CAPA_Speed_Plan.cboDivision_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0105_CAPA_Speed_Plan.cboDivision_SelectedIndexC: 진입점 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0105_CAPA_Speed_Plan.cboDivision_) |
| WK-SCP0105-0323 | C3 | SCP0105_CAPA_Speed_Plan.cboFromYYYY_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0105_CAPA_Speed_Plan.cboFromYYYY_SelectedIndexC: 진입점 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0105_CAPA_Speed_Plan.cboFromYYYY_) |
| WK-SCP0105-0324 | C3 | SCP0105_CAPA_Speed_Plan.cboProgressStatu | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0105_CAPA_Speed_Plan.cboProgressStatus_Selected: 진입점 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.cboProgressS) |
| WK-SCP0105-0325 | C3 | SCP0105_CAPA_Speed_Plan.cboVersionSeq_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0105_CAPA_Speed_Plan.cboVersionSeq_SelectedInde: 진입점 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0105_CAPA_Speed_Plan.cboVersionSe) |
| WK-SCP0105-0326 | C3 | SCP0105_CAPA_Speed_Plan.cboVersion_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0105_CAPA_Speed_Plan.cboVersion_SelectedIndexCh: 진입점 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0105_CAPA_Speed_Plan.cboVersion_S) |
| WK-SCP0105-0327 | C3 | SCP0105_CAPA_Speed_Plan.clbFactory_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0105_CAPA_Speed_Plan.clbFactory_SelectedIndexCh: 진입점 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.clbFactory_S) |
| WK-SCP0105-0328 | C3 | SCP0105_CAPA_Speed_Plan.clbLine_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0105_CAPA_Speed_Plan.clbLine_SelectedIndexChang: 진입점 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.clbLine_Sele) |
| WK-SCP0105-0329 | C3 | SCP0105_CAPA_Speed_Plan.clbOperation_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0105_CAPA_Speed_Plan.clbOperation_SelectedIndex: 진입점 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.clbOperation) |
| WK-SCP0105-0330 | C3 | SCP0105_CAPA_Speed_Plan.clbPlant_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0105_CAPA_Speed_Plan.clbPlant_SelectedIndexChan: 진입점 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0105_CAPA_Speed_Plan.clbPlant_Sel) |
| WK-SCP0105-0331 | C3 | SCP0105_CAPA_Speed_Plan.clbSite_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0105_CAPA_Speed_Plan.clbSite_SelectedIndexChang: 진입점 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0105_CAPA_Speed_Plan.clbSite_Sele) |
| WK-SCP0105-0332 | C3 | SCP0105_CAPA_Speed_Plan.rgrpDivisionType | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0105_CAPA_Speed_Plan.rgrpDivisionType_SelectedI: 진입점 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0105_CAPA_Speed_Plan.rgrpDivision) |
| WK-SCP0105-0333 | C3 | `InitEvent()` — 이벤트 배선 13건 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — `InitEvent()` — 이벤트 배선 13건: 행 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (`InitEvent()` — 이벤트 배선 13건) |
| WK-SCP0105-0334 | C3 | `_defaultDataModel_Changed` — 셀 변경 후속 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — `_defaultDataModel_Changed` — 셀 변경 후속: 행 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (`_defaultDataModel_Changed` — 셀 변경 후속) |
| WK-SCP0105-0335 | C4 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — 6: 행 집계 — C4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (6) |
| WK-SCP0105-0336 | C4 | Division 변경 시 그리드·컬럼셋 초기화 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — Division 변경 시 그리드·컬럼셋 초기화: 행 집계 — C4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (Division 변경 시 그리드·컬럼셋 초기화) |
| WK-SCP0105-0337 | C4 | `cboDivision_SelectedIndexChanged` | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — `cboDivision_SelectedIndexChanged`: 행 집계 — C4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (`cboDivision_SelectedIndexChanged`) |
| WK-SCP0105-0338 | C4 | `cboProgressStatus_SelectedIndexChanged` | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — `cboProgressStatus_SelectedIndexChanged`: 행 집계 — C4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (`cboProgressStatus_SelectedIndexChanged`) |
| WK-SCP0105-0339 | C4 | `cboVersionSeq_SelectedIndexChanged` | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — `cboVersionSeq_SelectedIndexChanged`: 행 집계 — C4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (`cboVersionSeq_SelectedIndexChanged`) |
| WK-SCP0105-0340 | C4 | `cboVersion_SelectedIndexChanged` | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — `cboVersion_SelectedIndexChanged`: 행 집계 — C4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (`cboVersion_SelectedIndexChanged`) |
| WK-SCP0105-0341 | C4 | `clbFactory_SelectedIndexChanged` | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — `clbFactory_SelectedIndexChanged`: 행 집계 — C4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (`clbFactory_SelectedIndexChanged`) |
| WK-SCP0105-0342 | C4 | `clbLine_SelectedIndexChanged` | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — `clbLine_SelectedIndexChanged`: 행 집계 — C4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (`clbLine_SelectedIndexChanged`) |
| WK-SCP0105-0343 | C4 | `clbOperation_SelectedIndexChanged` | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — `clbOperation_SelectedIndexChanged`: 행 집계 — C4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (`clbOperation_SelectedIndexChanged`) |
| WK-SCP0105-0344 | C4 | `clbPlant_SelectedIndexChanged` | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — `clbPlant_SelectedIndexChanged`: 행 집계 — C4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (`clbPlant_SelectedIndexChanged`) |
| WK-SCP0105-0345 | C4 | `clbSite_SelectedIndexChanged` | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — `clbSite_SelectedIndexChanged`: 행 집계 — C4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (`clbSite_SelectedIndexChanged`) |
| WK-SCP0105-0346 | C4 | `rgrpDivisionType_SelectedIndexChanged` | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — `rgrpDivisionType_SelectedIndexChanged`: 행 집계 — C4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (`rgrpDivisionType_SelectedIndexChanged`) |
| WK-SCP0105-0347 | B1 | D00-2-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — D00-2-014: 행 집계 — B1 11요소: NOPATH:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-014) |
| WK-SCP0105-0348 | B1 | D00-4b-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — D00-4b-004: 행 집계 — B1 11요소: NOPATH:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-004) |
| WK-SCP0105-0349 | B1 | D00-4d-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — D00-4d-001: 행 집계 — B1 11요소: NOPATH:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-001) |
| WK-SCP0105-0350 | B1 | `SpdMain_CellClick` + `SheetUtils.SetCom | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — `SpdMain_CellClick` + `SheetUtils.SetComboDataRow`: 행 집계 — B1 11요소: NOPATH:11 (미실행 요소가 남아 판정필요) |  | 1 (`SpdMain_CellClick` + `SheetUtils.SetCom) |
| WK-SCP0105-0351 | B2 | D00-2-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — D00-2-014: 행 집계 — B2 11요소: NOPATH:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-014) |
| WK-SCP0105-0352 | B2 | D00-4b-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — D00-4b-004: 행 집계 — B2 11요소: NOPATH:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-004) |
| WK-SCP0105-0353 | B2 | D00-4d-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — D00-4d-001: 행 집계 — B2 11요소: NOPATH:11 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-001) |
| WK-SCP0105-0354 | B2 | `SpdMain_CellClick` + `SheetUtils.SetCom | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — `SpdMain_CellClick` + `SheetUtils.SetComboDataRow`: 행 집계 — B2 11요소: NOPATH:11 (미실행 요소가 남아 판정필요) |  | 1 (`SpdMain_CellClick` + `SheetUtils.SetCom) |
| WK-SCP0105-0355 | B3 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — D00-4b-001: 행 집계 — B3 25요소: TODO:25 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-001) |
| WK-SCP0105-0356 | B3 | SCP0105_CAPA_Speed_Plan.GetCurrVersionPr | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0105_CAPA_Speed_Plan.GetCurrVersionProgessStatu: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0105_CAPA_Speed_Plan.GetCurrVersi) |
| WK-SCP0105-0357 | B3 | SCP0105_CAPA_Speed_Plan.GetExistsDiffere | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0105_CAPA_Speed_Plan.GetExistsDifferentEquipmen: 진입점 집계 — B3 7요소: TODO:7 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0105_CAPA_Speed_Plan.GetExistsDif) |
| WK-SCP0105-0358 | B3 | SCP0105_CAPA_Speed_Plan.GetPPMRowIndex | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0105_CAPA_Speed_Plan.GetPPMRowIndex: 진입점 집계 — B3 25요소: TODO:25 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.GetPPMRowInd) |
| WK-SCP0105-0359 | B3 | SCP0105_CAPA_Speed_Plan.GetQtyRowIndex | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0105_CAPA_Speed_Plan.GetQtyRowIndex: 진입점 집계 — B3 25요소: TODO:25 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SCP0105_CAPA_Speed_Plan.GetQtyRowInd) |
| WK-SCP0105-0360 | B3 | SCP0105_CAPA_Speed_Plan.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0105_CAPA_Speed_Plan.GetSpdTitle: 진입점 집계 — B3 2요소: TODO:2 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SCP0105_CAPA_Speed_Plan.GetSpdTitle:) |
| WK-SCP0105-0361 | B3 | SCP0105_CAPA_Speed_Plan.GetSpeedRowIndex | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0105_CAPA_Speed_Plan.GetSpeedRowIndex: 진입점 집계 — B3 25요소: TODO:25 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.GetSpeedRowI) |
| WK-SCP0105-0362 | B3 | SCP0105_CAPA_Speed_Plan.getCurrCompany | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0105_CAPA_Speed_Plan.getCurrCompany: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getCurrCompa) |
| WK-SCP0105-0363 | B3 | SCP0105_CAPA_Speed_Plan.getCurrDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0105_CAPA_Speed_Plan.getCurrDivision: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getCurrDivis) |
| WK-SCP0105-0364 | B3 | SCP0105_CAPA_Speed_Plan.getCurrElectrode | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0105_CAPA_Speed_Plan.getCurrElectrodeType: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getCurrElect) |
| WK-SCP0105-0365 | B3 | SCP0105_CAPA_Speed_Plan.getCurrFactory | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0105_CAPA_Speed_Plan.getCurrFactory: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getCurrFacto) |
| WK-SCP0105-0366 | B3 | SCP0105_CAPA_Speed_Plan.getCurrItemId | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0105_CAPA_Speed_Plan.getCurrItemId: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getCurrItemI) |
| WK-SCP0105-0367 | B3 | SCP0105_CAPA_Speed_Plan.getCurrLine | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0105_CAPA_Speed_Plan.getCurrLine: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getCurrLine:) |
| WK-SCP0105-0368 | B3 | SCP0105_CAPA_Speed_Plan.getCurrMeasure | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0105_CAPA_Speed_Plan.getCurrMeasure: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getCurrMeasu) |
| WK-SCP0105-0369 | B3 | SCP0105_CAPA_Speed_Plan.getCurrNickname | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0105_CAPA_Speed_Plan.getCurrNickname: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getCurrNickn) |
| WK-SCP0105-0370 | B3 | SCP0105_CAPA_Speed_Plan.getCurrOperation | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0105_CAPA_Speed_Plan.getCurrOperation: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getCurrOpera) |
| WK-SCP0105-0371 | B3 | SCP0105_CAPA_Speed_Plan.getCurrPlant | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0105_CAPA_Speed_Plan.getCurrPlant: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getCurrPlant) |
| WK-SCP0105-0372 | B3 | SCP0105_CAPA_Speed_Plan.getCurrSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0105_CAPA_Speed_Plan.getCurrSite: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getCurrSite:) |
| WK-SCP0105-0373 | B3 | SCP0105_CAPA_Speed_Plan.getDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0105_CAPA_Speed_Plan.getDivision: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getDivision:) |
| WK-SCP0105-0374 | B3 | SCP0105_CAPA_Speed_Plan.getDivisionType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0105_CAPA_Speed_Plan.getDivisionType: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getDivisionT) |
| WK-SCP0105-0375 | B3 | SCP0105_CAPA_Speed_Plan.getElectrodeType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0105_CAPA_Speed_Plan.getElectrodeType: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getElectrode) |
| WK-SCP0105-0376 | B3 | SCP0105_CAPA_Speed_Plan.getFactory | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0105_CAPA_Speed_Plan.getFactory: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getFactory:4) |
| WK-SCP0105-0377 | B3 | SCP0105_CAPA_Speed_Plan.getItemId | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0105_CAPA_Speed_Plan.getItemId: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getItemId:49) |
| WK-SCP0105-0378 | B3 | SCP0105_CAPA_Speed_Plan.getLine | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0105_CAPA_Speed_Plan.getLine: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getLine:443:) |
| WK-SCP0105-0379 | B3 | SCP0105_CAPA_Speed_Plan.getOperation | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0105_CAPA_Speed_Plan.getOperation: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getOperation) |
| WK-SCP0105-0380 | B3 | SCP0105_CAPA_Speed_Plan.getPlanType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0105_CAPA_Speed_Plan.getPlanType: 진입점 집계 — B3 25요소: TODO:25 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.getPlanType:) |
| WK-SCP0105-0381 | B3 | SCP0105_CAPA_Speed_Plan.getPlant | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0105_CAPA_Speed_Plan.getPlant: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getPlant:395) |
| WK-SCP0105-0382 | B3 | SCP0105_CAPA_Speed_Plan.getProgressStatu | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0105_CAPA_Speed_Plan.getProgressStatus: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getProgressS) |
| WK-SCP0105-0383 | B3 | SCP0105_CAPA_Speed_Plan.getShopGroup | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0105_CAPA_Speed_Plan.getShopGroup: 진입점 집계 — B3 25요소: TODO:25 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.getShopGroup) |
| WK-SCP0105-0384 | B3 | SCP0105_CAPA_Speed_Plan.getSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0105_CAPA_Speed_Plan.getSite: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getSite:357:) |
| WK-SCP0105-0385 | B3 | SCP0105_CAPA_Speed_Plan.getVersion | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0105_CAPA_Speed_Plan.getVersion: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getVersion:2) |
| WK-SCP0105-0386 | B3 | SCP0105_CAPA_Speed_Plan.getVersionSeq | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0105_CAPA_Speed_Plan.getVersionSeq: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getVersionSe) |
| WK-SCP0105-0387 | B3 | `BLUtils.GetDivisionWithoutEE` — `ATTRIB | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — `BLUtils.GetDivisionWithoutEE` — `ATTRIBUTE3 <> 'E: 행 집계 — B3 25요소: TODO:25 (미실행 요소가 남아 판정필요) |  | 1 (`BLUtils.GetDivisionWithoutEE` — `ATTRIB) |
| WK-SCP0105-0388 | B3 | `_division_type_name` — `ScpCapa.GetDivi | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — `_division_type_name` — `ScpCapa.GetDivisionTypeNa: 행 집계 — B3 25요소: TODO:25 (미실행 요소가 남아 판정필요) |  | 1 (`_division_type_name` — `ScpCapa.GetDivi) |
| WK-SCP0105-0389 | B4 | D00-2-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — D00-2-014: 행 집계 — B4 25요소: NOPATH:25 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-014) |
| WK-SCP0105-0390 | B4 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — D00-4b-001: 행 집계 — B4 25요소: NOPATH:25 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-001) |
| WK-SCP0105-0391 | B4 | D00-4b-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — D00-4b-004: 행 집계 — B4 25요소: NOPATH:25 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-004) |
| WK-SCP0105-0392 | B4 | D00-4d-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — D00-4d-001: 행 집계 — B4 25요소: NOPATH:25 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-001) |
| WK-SCP0105-0393 | B4 | SCP0105_CAPA_Speed_Plan.GetCurrVersionPr | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0105_CAPA_Speed_Plan.GetCurrVersionProgessStatu: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0105_CAPA_Speed_Plan.GetCurrVersi) |
| WK-SCP0105-0394 | B4 | SCP0105_CAPA_Speed_Plan.GetExistsDiffere | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0105_CAPA_Speed_Plan.GetExistsDifferentEquipmen: 진입점 집계 — B4 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0105_CAPA_Speed_Plan.GetExistsDif) |
| WK-SCP0105-0395 | B4 | SCP0105_CAPA_Speed_Plan.GetPPMRowIndex | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0105_CAPA_Speed_Plan.GetPPMRowIndex: 진입점 집계 — B4 25요소: NOPATH:25 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.GetPPMRowInd) |
| WK-SCP0105-0396 | B4 | SCP0105_CAPA_Speed_Plan.GetQtyRowIndex | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0105_CAPA_Speed_Plan.GetQtyRowIndex: 진입점 집계 — B4 25요소: NOPATH:25 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SCP0105_CAPA_Speed_Plan.GetQtyRowInd) |
| WK-SCP0105-0397 | B4 | SCP0105_CAPA_Speed_Plan.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0105_CAPA_Speed_Plan.GetSpdTitle: 진입점 집계 — B4 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SCP0105_CAPA_Speed_Plan.GetSpdTitle:) |
| WK-SCP0105-0398 | B4 | SCP0105_CAPA_Speed_Plan.GetSpeedRowIndex | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0105_CAPA_Speed_Plan.GetSpeedRowIndex: 진입점 집계 — B4 25요소: NOPATH:25 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.GetSpeedRowI) |
| WK-SCP0105-0399 | B4 | SCP0105_CAPA_Speed_Plan.getCurrCompany | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0105_CAPA_Speed_Plan.getCurrCompany: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getCurrCompa) |
| WK-SCP0105-0400 | B4 | SCP0105_CAPA_Speed_Plan.getCurrDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0105_CAPA_Speed_Plan.getCurrDivision: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getCurrDivis) |
| WK-SCP0105-0401 | B4 | SCP0105_CAPA_Speed_Plan.getCurrElectrode | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0105_CAPA_Speed_Plan.getCurrElectrodeType: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getCurrElect) |
| WK-SCP0105-0402 | B4 | SCP0105_CAPA_Speed_Plan.getCurrFactory | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0105_CAPA_Speed_Plan.getCurrFactory: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getCurrFacto) |
| WK-SCP0105-0403 | B4 | SCP0105_CAPA_Speed_Plan.getCurrItemId | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0105_CAPA_Speed_Plan.getCurrItemId: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getCurrItemI) |
| WK-SCP0105-0404 | B4 | SCP0105_CAPA_Speed_Plan.getCurrLine | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0105_CAPA_Speed_Plan.getCurrLine: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getCurrLine:) |
| WK-SCP0105-0405 | B4 | SCP0105_CAPA_Speed_Plan.getCurrMeasure | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0105_CAPA_Speed_Plan.getCurrMeasure: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getCurrMeasu) |
| WK-SCP0105-0406 | B4 | SCP0105_CAPA_Speed_Plan.getCurrNickname | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0105_CAPA_Speed_Plan.getCurrNickname: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getCurrNickn) |
| WK-SCP0105-0407 | B4 | SCP0105_CAPA_Speed_Plan.getCurrOperation | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0105_CAPA_Speed_Plan.getCurrOperation: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getCurrOpera) |
| WK-SCP0105-0408 | B4 | SCP0105_CAPA_Speed_Plan.getCurrPlant | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0105_CAPA_Speed_Plan.getCurrPlant: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getCurrPlant) |
| WK-SCP0105-0409 | B4 | SCP0105_CAPA_Speed_Plan.getCurrSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0105_CAPA_Speed_Plan.getCurrSite: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getCurrSite:) |
| WK-SCP0105-0410 | B4 | SCP0105_CAPA_Speed_Plan.getDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0105_CAPA_Speed_Plan.getDivision: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getDivision:) |
| WK-SCP0105-0411 | B4 | SCP0105_CAPA_Speed_Plan.getDivisionType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0105_CAPA_Speed_Plan.getDivisionType: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getDivisionT) |
| WK-SCP0105-0412 | B4 | SCP0105_CAPA_Speed_Plan.getElectrodeType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0105_CAPA_Speed_Plan.getElectrodeType: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getElectrode) |
| WK-SCP0105-0413 | B4 | SCP0105_CAPA_Speed_Plan.getFactory | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0105_CAPA_Speed_Plan.getFactory: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getFactory:4) |
| WK-SCP0105-0414 | B4 | SCP0105_CAPA_Speed_Plan.getItemId | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0105_CAPA_Speed_Plan.getItemId: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getItemId:49) |
| WK-SCP0105-0415 | B4 | SCP0105_CAPA_Speed_Plan.getLine | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0105_CAPA_Speed_Plan.getLine: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getLine:443:) |
| WK-SCP0105-0416 | B4 | SCP0105_CAPA_Speed_Plan.getOperation | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0105_CAPA_Speed_Plan.getOperation: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getOperation) |
| WK-SCP0105-0417 | B4 | SCP0105_CAPA_Speed_Plan.getPlanType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0105_CAPA_Speed_Plan.getPlanType: 진입점 집계 — B4 25요소: NOPATH:25 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.getPlanType:) |
| WK-SCP0105-0418 | B4 | SCP0105_CAPA_Speed_Plan.getPlant | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0105_CAPA_Speed_Plan.getPlant: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getPlant:395) |
| WK-SCP0105-0419 | B4 | SCP0105_CAPA_Speed_Plan.getProgressStatu | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0105_CAPA_Speed_Plan.getProgressStatus: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getProgressS) |
| WK-SCP0105-0420 | B4 | SCP0105_CAPA_Speed_Plan.getShopGroup | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0105_CAPA_Speed_Plan.getShopGroup: 진입점 집계 — B4 25요소: NOPATH:25 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.getShopGroup) |
| WK-SCP0105-0421 | B4 | SCP0105_CAPA_Speed_Plan.getSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0105_CAPA_Speed_Plan.getSite: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getSite:357:) |
| WK-SCP0105-0422 | B4 | SCP0105_CAPA_Speed_Plan.getVersion | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0105_CAPA_Speed_Plan.getVersion: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getVersion:2) |
| WK-SCP0105-0423 | B4 | SCP0105_CAPA_Speed_Plan.getVersionSeq | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0105_CAPA_Speed_Plan.getVersionSeq: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.getVersionSe) |
| WK-SCP0105-0424 | B4 | `BLUtils.GetDivisionWithoutEE` — `ATTRIB | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — `BLUtils.GetDivisionWithoutEE` — `ATTRIBUTE3 <> 'E: 행 집계 — B4 25요소: NOPATH:25 (미실행 요소가 남아 판정필요) |  | 1 (`BLUtils.GetDivisionWithoutEE` — `ATTRIB) |
| WK-SCP0105-0425 | B4 | `SpdMain_CellClick` + `SheetUtils.SetCom | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — `SpdMain_CellClick` + `SheetUtils.SetComboDataRow`: 행 집계 — B4 25요소: NOPATH:25 (미실행 요소가 남아 판정필요) |  | 1 (`SpdMain_CellClick` + `SheetUtils.SetCom) |
| WK-SCP0105-0426 | B4 | `_division_type_name` — `ScpCapa.GetDivi | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — `_division_type_name` — `ScpCapa.GetDivisionTypeNa: 행 집계 — B4 25요소: NOPATH:25 (미실행 요소가 남아 판정필요) |  | 1 (`_division_type_name` — `ScpCapa.GetDivi) |
| WK-SCP0105-0427 | F4 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 5: 행 집계 — F4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (5) |
| WK-SCP0105-0428 | F4 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 8: 행 집계 — F4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (8) |
| WK-SCP0105-0429 | F4 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — COMMON:UC-03: 행 집계 — F4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-SCP0105-0430 | F4 | D00-2-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — D00-2-002: 행 집계 — F4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-002) |
| WK-SCP0105-0431 | F4 | D00-3-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — D00-3-013: 행 집계 — F4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-013) |
| WK-SCP0105-0432 | F4 | SCP0105_CAPA_Speed_Plan.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0105_CAPA_Speed_Plan.FindButton: 진입점 집계 — F4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0105_CAPA_Speed_Plan.FindButton A) |
| WK-SCP0105-0433 | F4 | SCP0105_CAPA_Speed_Plan.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0105_CAPA_Speed_Plan.FindData: 진입점 집계 — F4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.FindData ACT) |
| WK-SCP0105-0434 | F4 | SCP0105_CAPA_Speed_Plan.FindDataMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0105_CAPA_Speed_Plan.FindDataMain: 진입점 집계 — F4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.FindDataMain) |
| WK-SCP0105-0435 | F4 | SCP0105_CAPA_Speed_Plan.SaveButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0105_CAPA_Speed_Plan.SaveButton: 진입점 집계 — F4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.SaveButton) |
| WK-SCP0105-0436 | F4 | SCP0105_CAPA_Speed_Plan.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0105_CAPA_Speed_Plan.SaveData: 진입점 집계 — F4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.SaveData) |
| WK-SCP0105-0437 | F4 | SCP0105_CAPA_Speed_Plan.SaveDataMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0105_CAPA_Speed_Plan.SaveDataMain: 진입점 집계 — F4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.SaveDataMain) |
| WK-SCP0105-0438 | F4 | `AfterSaveData()` — 응답 판정 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — `AfterSaveData()` — 응답 판정: 행 집계 — F4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (`AfterSaveData()` — 응답 판정) |
| WK-SCP0105-0439 | F4 | `SaveData()` 변경 0건 가드 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — `SaveData()` 변경 0건 가드: 행 집계 — F4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (`SaveData()` 변경 0건 가드) |
| WK-SCP0105-0440 | F4 | `SaveDataMain()` — SAVE → GET 연쇄 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — `SaveDataMain()` — SAVE → GET 연쇄: 행 집계 — F4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (`SaveDataMain()` — SAVE → GET 연쇄) |
| WK-SCP0105-0441 | F4 | 저장/조회 성공 시 `IsEditMode=false` (01 L-27) | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 저장/조회 성공 시 `IsEditMode=false` (01 L-27): 행 집계 — F4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (저장/조회 성공 시 `IsEditMode=false` (01 L-27)) |
| WK-SCP0105-0442 | F4 | 진입 자동조회 없음 (Form_Load 에 `FindData` 호출 0건 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 진입 자동조회 없음 (Form_Load 에 `FindData` 호출 0건): 행 집계 — F4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (진입 자동조회 없음 (Form_Load 에 `FindData` 호출 0건) |
| WK-SCP0105-0443 | F4 | 팝업 OK 후 `BeforeFindData()` (시트 비우고 헤더 재구 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 팝업 OK 후 `BeforeFindData()` (시트 비우고 헤더 재구성): 행 집계 — F4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (팝업 OK 후 `BeforeFindData()` (시트 비우고 헤더 재구) |
| WK-SCP0105-0444 | A5 | **BLK-4** DivisionType 초기값 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — **BLK-4** DivisionType 초기값: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (**BLK-4** DivisionType 초기값) |
| WK-SCP0105-0445 | A5 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 10: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (10) |
| WK-SCP0105-0446 | A5 | 3단 그룹 조립 (Large > Small > Column) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 3단 그룹 조립 (Large > Small > Column): 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (3단 그룹 조립 (Large > Small > Column)) |
| WK-SCP0105-0447 | A5 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-02: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0105-0448 | A5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-07: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0105-0449 | A5 | D00-1-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-004: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-004) |
| WK-SCP0105-0450 | A5 | D00-1-031 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-031: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-031) |
| WK-SCP0105-0451 | A5 | D00-1-034 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-034: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-034) |
| WK-SCP0105-0452 | A5 | D00-1-036 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-036: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-036) |
| WK-SCP0105-0453 | A5 | D00-2-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-2-002: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-002) |
| WK-SCP0105-0454 | A5 | D00-2-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-2-004: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-004) |
| WK-SCP0105-0455 | A5 | D00-2-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-2-006: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-006) |
| WK-SCP0105-0456 | A5 | D00-3-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-3-001: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-001) |
| WK-SCP0105-0457 | A5 | D00-3-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-3-006: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-006) |
| WK-SCP0105-0458 | A5 | D00-4b-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-4b-004: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-004) |
| WK-SCP0105-0459 | A5 | D00-4d-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-4d-001: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-001) |
| WK-SCP0105-0460 | A5 | D00-4d-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-4d-005: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-005) |
| WK-SCP0105-0461 | A5 | D00-4d-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-4d-006: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-006) |
| WK-SCP0105-0462 | A5 | D00-4d-019 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-4d-019: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-019) |
| WK-SCP0105-0463 | A5 | D00-4d-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-4d-020: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-020) |
| WK-SCP0105-0464 | A5 | Division 변경 시 그리드·컬럼셋 초기화 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — Division 변경 시 그리드·컬럼셋 초기화: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (Division 변경 시 그리드·컬럼셋 초기화) |
| WK-SCP0105-0465 | A5 | Measure 코드 7종 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — Measure 코드 7종: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (Measure 코드 7종) |
| WK-SCP0105-0466 | A5 | SCP0105_CAPA_Speed_Plan.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0105_CAPA_Speed_Plan.CreateSpread: 진입점 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0105_CAPA_Speed_Plan.CreateSpread) |
| WK-SCP0105-0467 | A5 | `*_ASSIGN_PRIORITY` 숨김 방식 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — `*_ASSIGN_PRIORITY` 숨김 방식: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (`*_ASSIGN_PRIORITY` 숨김 방식) |
| WK-SCP0105-0468 | A5 | `CreateSpread()` — `AddSheet` ×2 (ASSEMB | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — `CreateSpread()` — `AddSheet` ×2 (ASSEMBLY/ELTR): 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (`CreateSpread()` — `AddSheet` ×2 (ASSEMB) |
| WK-SCP0105-0469 | A5 | `GetSpdTitle()` — 기간 헤더 SP 호출 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — `GetSpdTitle()` — 기간 헤더 SP 호출: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (`GetSpdTitle()` — 기간 헤더 SP 호출) |
| WK-SCP0105-0470 | A5 | `InitEvent()` — 이벤트 배선 13건 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — `InitEvent()` — 이벤트 배선 13건: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (`InitEvent()` — 이벤트 배선 13건) |
| WK-SCP0105-0471 | A5 | `InitSpread()` — 시트 가시성 전환 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — `InitSpread()` — 시트 가시성 전환: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (`InitSpread()` — 시트 가시성 전환) |
| WK-SCP0105-0472 | A5 | `RefreshColumnsVisible()` — `*_ASSIGN_PR | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — `RefreshColumnsVisible()` — `*_ASSIGN_PRIORITY` 폭0: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (`RefreshColumnsVisible()` — `*_ASSIGN_PR) |
| WK-SCP0105-0473 | A5 | `RefreshSheetHeader()` / `SetSheetHeader | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — `RefreshSheetHeader()` / `SetSheetHeaderColumnSCP(: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (`RefreshSheetHeader()` / `SetSheetHeader) |
| WK-SCP0105-0474 | A5 | `SetLockColumns()` — 시트별 분기 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — `SetLockColumns()` — 시트별 분기: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (`SetLockColumns()` — 시트별 분기) |
| WK-SCP0105-0475 | A5 | `SetSheetMerge()` — 조회모드 병합 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — `SetSheetMerge()` — 조회모드 병합: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (`SetSheetMerge()` — 조회모드 병합) |
| WK-SCP0105-0476 | A5 | `SetSheetNumericColumnFormat()` 분기 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — `SetSheetNumericColumnFormat()` 분기: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (`SetSheetNumericColumnFormat()` 분기) |
| WK-SCP0105-0477 | A5 | `SetSheetNumericColumnFormatASSEMBLY()`  | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — `SetSheetNumericColumnFormatASSEMBLY()` — measure별: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (`SetSheetNumericColumnFormatASSEMBLY()` ) |
| WK-SCP0105-0478 | A5 | `_sheetDateColumns` — `_ASSIGN_PRIORITY` | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — `_sheetDateColumns` — `_ASSIGN_PRIORITY` 제외 목록: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (`_sheetDateColumns` — `_ASSIGN_PRIORITY`) |
| WK-SCP0105-0479 | A5 | `_sheet_idx` — DivisionType → 시트 인덱스 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — `_sheet_idx` — DivisionType → 시트 인덱스: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (`_sheet_idx` — DivisionType → 시트 인덱스) |
| WK-SCP0105-0480 | A5 | `_si.Query(ds)` — 결과 바인딩 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — `_si.Query(ds)` — 결과 바인딩: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (`_si.Query(ds)` — 결과 바인딩) |
| WK-SCP0105-0481 | A5 | `btnColumn_Click` → `SCM002_CAPAColumnPo | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — `btnColumn_Click` → `SCM002_CAPAColumnPopup("SCP01: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (`btnColumn_Click` → `SCM002_CAPAColumnPo) |
| WK-SCP0105-0482 | A5 | `clbElectrodeType` (Line Type) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — `clbElectrodeType` (Line Type): 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (`clbElectrodeType` (Line Type)) |
| WK-SCP0105-0483 | A5 | `spdMain` (FpSpread, 2시트) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — `spdMain` (FpSpread, 2시트): 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (`spdMain` (FpSpread, 2시트)) |
| WK-SCP0105-0484 | A5 | 기간 컬럼명 규약 `M_01yyyymm` / `Y_yyyy` | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 기간 컬럼명 규약 `M_01yyyymm` / `Y_yyyy`: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (기간 컬럼명 규약 `M_01yyyymm` / `Y_yyyy`) |
| WK-SCP0105-0485 | A5 | 기간 헤더 행 스키마 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 기간 헤더 행 스키마: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (기간 헤더 행 스키마) |
| WK-SCP0105-0486 | A5 | 컬럼 개인화 적용 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 컬럼 개인화 적용: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (컬럼 개인화 적용) |
| WK-SCP0105-0487 | A5 | 컬럼 키 상수 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 컬럼 키 상수: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (컬럼 키 상수) |
| WK-SCP0105-0488 | A5 | 팝업 OK 후 `BeforeFindData()` (시트 비우고 헤더 재구 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 팝업 OK 후 `BeforeFindData()` (시트 비우고 헤더 재구성): 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (팝업 OK 후 `BeforeFindData()` (시트 비우고 헤더 재구) |
| WK-SCP0105-0489 | G4 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — COMMON:UC-06: 행 집계 — G4 15요소: NOT_RUN:13 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0105-0490 | G4 | D00-1-025 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-1-025: 행 집계 — G4 15요소: NOT_RUN:13 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-025) |
| WK-SCP0105-0491 | G4 | D00-1-026 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-1-026: 행 집계 — G4 15요소: NOT_RUN:13 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-026) |
| WK-SCP0105-0492 | G4 | D00-1-040 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-1-040: 행 집계 — G4 15요소: NOT_RUN:13 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-040) |
| WK-SCP0105-0493 | G4 | D00-1-042 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-1-042: 행 집계 — G4 15요소: NOT_RUN:13 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-042) |
| WK-SCP0105-0494 | G4 | D00-3-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-3-001: 행 집계 — G4 15요소: NOT_RUN:13 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-001) |
| WK-SCP0105-0495 | G4 | D00-4b-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-4b-004: 행 집계 — G4 15요소: NOT_RUN:13 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-004) |
| WK-SCP0105-0496 | G4 | `InitSpread()` — 시트 가시성 전환 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — `InitSpread()` — 시트 가시성 전환: 행 집계 — G4 15요소: NOT_RUN:13 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (`InitSpread()` — 시트 가시성 전환) |
| WK-SCP0105-0497 | G4 | `RefreshElectrodeTypeSpread()` — 행 기준 후보 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — `RefreshElectrodeTypeSpread()` — 행 기준 후보 좁힘: 행 집계 — G4 15요소: NOT_RUN:13 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (`RefreshElectrodeTypeSpread()` — 행 기준 후보) |
| WK-SCP0105-0498 | G4 | 조회조건 13필드 타입 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 조회조건 13필드 타입: 행 집계 — G4 15요소: NOT_RUN:13 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (조회조건 13필드 타입) |
| WK-SCP0105-0499 | H2 | **BLK-4** DivisionType 초기값 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — **BLK-4** DivisionType 초기값: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (**BLK-4** DivisionType 초기값) |
| WK-SCP0105-0500 | H2 | **BLK-7** Measure 행 배경색 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — **BLK-7** Measure 행 배경색: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (**BLK-7** Measure 행 배경색) |
| WK-SCP0105-0501 | H2 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 10: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (10) |
| WK-SCP0105-0502 | H2 | 3단 그룹 조립 (Large > Small > Column) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 3단 그룹 조립 (Large > Small > Column): 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (3단 그룹 조립 (Large > Small > Column)) |
| WK-SCP0105-0503 | H2 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-02: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0105-0504 | H2 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-07: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0105-0505 | H2 | D00-1-036 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-1-036: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-036) |
| WK-SCP0105-0506 | H2 | D00-2-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-2-002: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-002) |
| WK-SCP0105-0507 | H2 | D00-2-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-2-004: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-004) |
| WK-SCP0105-0508 | H2 | D00-2-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-2-006: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-006) |
| WK-SCP0105-0509 | H2 | D00-3-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-3-001: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-001) |
| WK-SCP0105-0510 | H2 | D00-3-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-3-006: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-006) |
| WK-SCP0105-0511 | H2 | D00-3-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-3-012: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-012) |
| WK-SCP0105-0512 | H2 | D00-4b-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-4b-004: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-004) |
| WK-SCP0105-0513 | H2 | D00-4d-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-4d-001: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-001) |
| WK-SCP0105-0514 | H2 | D00-4d-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-4d-005: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-005) |
| WK-SCP0105-0515 | H2 | D00-4d-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-4d-006: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-006) |
| WK-SCP0105-0516 | H2 | D00-4d-019 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-4d-019: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-019) |
| WK-SCP0105-0517 | H2 | D00-4d-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-4d-020: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-020) |
| WK-SCP0105-0518 | H2 | Division 변경 시 그리드·컬럼셋 초기화 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — Division 변경 시 그리드·컬럼셋 초기화: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (Division 변경 시 그리드·컬럼셋 초기화) |
| WK-SCP0105-0519 | H2 | Measure 코드 7종 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — Measure 코드 7종: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (Measure 코드 7종) |
| WK-SCP0105-0520 | H2 | SCP0105_CAPA_Speed_Plan.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0105_CAPA_Speed_Plan.CreateSpread: 진입점 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0105_CAPA_Speed_Plan.CreateSpread) |
| WK-SCP0105-0521 | H2 | SCP0105_CAPA_Speed_Plan.Set_MeasureColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0105_CAPA_Speed_Plan.Set_MeasureColor: 진입점 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SCP0105_CAPA_Speed_Plan.Set_MeasureC) |
| WK-SCP0105-0522 | H2 | `CreateSpread()` — `AddSheet` ×2 (ASSEMB | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — `CreateSpread()` — `AddSheet` ×2 (ASSEMBLY/ELTR): 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`CreateSpread()` — `AddSheet` ×2 (ASSEMB) |
| WK-SCP0105-0523 | H2 | `GetSpdTitle()` — 기간 헤더 SP 호출 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — `GetSpdTitle()` — 기간 헤더 SP 호출: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`GetSpdTitle()` — 기간 헤더 SP 호출) |
| WK-SCP0105-0524 | H2 | `InitEvent()` — 이벤트 배선 13건 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — `InitEvent()` — 이벤트 배선 13건: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`InitEvent()` — 이벤트 배선 13건) |
| WK-SCP0105-0525 | H2 | `InitSpread()` — 시트 가시성 전환 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — `InitSpread()` — 시트 가시성 전환: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`InitSpread()` — 시트 가시성 전환) |
| WK-SCP0105-0526 | H2 | `RefreshColumnsVisible()` — `*_ASSIGN_PR | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — `RefreshColumnsVisible()` — `*_ASSIGN_PRIORITY` 폭0: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`RefreshColumnsVisible()` — `*_ASSIGN_PR) |
| WK-SCP0105-0527 | H2 | `RefreshSheetHeader()` / `SetSheetHeader | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — `RefreshSheetHeader()` / `SetSheetHeaderColumnSCP(: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`RefreshSheetHeader()` / `SetSheetHeader) |
| WK-SCP0105-0528 | H2 | `SetLockColumns()` — 시트별 분기 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — `SetLockColumns()` — 시트별 분기: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`SetLockColumns()` — 시트별 분기) |
| WK-SCP0105-0529 | H2 | `SetSheetMerge()` — 조회모드 병합 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — `SetSheetMerge()` — 조회모드 병합: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`SetSheetMerge()` — 조회모드 병합) |
| WK-SCP0105-0530 | H2 | `SetSheetNumericColumnFormat()` 분기 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — `SetSheetNumericColumnFormat()` 분기: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`SetSheetNumericColumnFormat()` 분기) |
| WK-SCP0105-0531 | H2 | `SetSheetNumericColumnFormatASSEMBLY()`  | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — `SetSheetNumericColumnFormatASSEMBLY()` — measure별: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`SetSheetNumericColumnFormatASSEMBLY()` ) |
| WK-SCP0105-0532 | H2 | `_sheetDateColumns` — `_ASSIGN_PRIORITY` | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — `_sheetDateColumns` — `_ASSIGN_PRIORITY` 제외 목록: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`_sheetDateColumns` — `_ASSIGN_PRIORITY`) |
| WK-SCP0105-0533 | H2 | `_sheet_idx` — DivisionType → 시트 인덱스 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — `_sheet_idx` — DivisionType → 시트 인덱스: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`_sheet_idx` — DivisionType → 시트 인덱스) |
| WK-SCP0105-0534 | H2 | `_si.Query(ds)` — 결과 바인딩 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — `_si.Query(ds)` — 결과 바인딩: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`_si.Query(ds)` — 결과 바인딩) |
| WK-SCP0105-0535 | H2 | `btnColumn_Click` → `SCM002_CAPAColumnPo | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — `btnColumn_Click` → `SCM002_CAPAColumnPopup("SCP01: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`btnColumn_Click` → `SCM002_CAPAColumnPo) |
| WK-SCP0105-0536 | H2 | `clbElectrodeType` (Line Type) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — `clbElectrodeType` (Line Type): 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`clbElectrodeType` (Line Type)) |
| WK-SCP0105-0537 | H2 | `spdMain` (FpSpread, 2시트) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — `spdMain` (FpSpread, 2시트): 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`spdMain` (FpSpread, 2시트)) |
| WK-SCP0105-0538 | H2 | 기간 컬럼명 규약 `M_01yyyymm` / `Y_yyyy` | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 기간 컬럼명 규약 `M_01yyyymm` / `Y_yyyy`: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (기간 컬럼명 규약 `M_01yyyymm` / `Y_yyyy`) |
| WK-SCP0105-0539 | H2 | 기간 헤더 행 스키마 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 기간 헤더 행 스키마: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (기간 헤더 행 스키마) |
| WK-SCP0105-0540 | H2 | 컬럼 개인화 적용 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 컬럼 개인화 적용: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (컬럼 개인화 적용) |
| WK-SCP0105-0541 | H2 | 컬럼 키 상수 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 컬럼 키 상수: 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (컬럼 키 상수) |
| WK-SCP0105-0542 | H2 | 팝업 OK 후 `BeforeFindData()` (시트 비우고 헤더 재구 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 팝업 OK 후 `BeforeFindData()` (시트 비우고 헤더 재구성): 행 집계 — H2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (팝업 OK 후 `BeforeFindData()` (시트 비우고 헤더 재구) |
| WK-SCP0105-0543 | H5 | **BLK-4** DivisionType 초기값 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — **BLK-4** DivisionType 초기값: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (**BLK-4** DivisionType 초기값) |
| WK-SCP0105-0544 | H5 | 3단 그룹 조립 (Large > Small > Column) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 3단 그룹 조립 (Large > Small > Column): 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (3단 그룹 조립 (Large > Small > Column)) |
| WK-SCP0105-0545 | H5 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-02: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0105-0546 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0105-0547 | H5 | D00-1-036 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-1-036: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-036) |
| WK-SCP0105-0548 | H5 | D00-2-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-2-002: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-002) |
| WK-SCP0105-0549 | H5 | D00-3-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-3-001: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-001) |
| WK-SCP0105-0550 | H5 | D00-3-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-3-006: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-006) |
| WK-SCP0105-0551 | H5 | D00-4b-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-4b-004: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-004) |
| WK-SCP0105-0552 | H5 | D00-4d-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-4d-001: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-001) |
| WK-SCP0105-0553 | H5 | D00-4d-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-4d-005: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-005) |
| WK-SCP0105-0554 | H5 | D00-4d-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-4d-006: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-006) |
| WK-SCP0105-0555 | H5 | D00-4d-019 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-4d-019: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-019) |
| WK-SCP0105-0556 | H5 | D00-4d-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-4d-020: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-020) |
| WK-SCP0105-0557 | H5 | Division 변경 시 그리드·컬럼셋 초기화 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — Division 변경 시 그리드·컬럼셋 초기화: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (Division 변경 시 그리드·컬럼셋 초기화) |
| WK-SCP0105-0558 | H5 | Measure 코드 7종 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — Measure 코드 7종: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (Measure 코드 7종) |
| WK-SCP0105-0559 | H5 | SCP0105_CAPA_Speed_Plan.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0105_CAPA_Speed_Plan.CreateSpread: 진입점 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0105_CAPA_Speed_Plan.CreateSpread) |
| WK-SCP0105-0560 | H5 | `CreateSpread()` — `AddSheet` ×2 (ASSEMB | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `CreateSpread()` — `AddSheet` ×2 (ASSEMBLY/ELTR): 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`CreateSpread()` — `AddSheet` ×2 (ASSEMB) |
| WK-SCP0105-0561 | H5 | `GetSpdTitle()` — 기간 헤더 SP 호출 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `GetSpdTitle()` — 기간 헤더 SP 호출: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`GetSpdTitle()` — 기간 헤더 SP 호출) |
| WK-SCP0105-0562 | H5 | `InitEvent()` — 이벤트 배선 13건 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `InitEvent()` — 이벤트 배선 13건: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`InitEvent()` — 이벤트 배선 13건) |
| WK-SCP0105-0563 | H5 | `InitSpread()` — 시트 가시성 전환 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `InitSpread()` — 시트 가시성 전환: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`InitSpread()` — 시트 가시성 전환) |
| WK-SCP0105-0564 | H5 | `RefreshColumnsVisible()` — `*_ASSIGN_PR | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `RefreshColumnsVisible()` — `*_ASSIGN_PRIORITY` 폭0: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`RefreshColumnsVisible()` — `*_ASSIGN_PR) |
| WK-SCP0105-0565 | H5 | `RefreshSheetHeader()` / `SetSheetHeader | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `RefreshSheetHeader()` / `SetSheetHeaderColumnSCP(: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`RefreshSheetHeader()` / `SetSheetHeader) |
| WK-SCP0105-0566 | H5 | `SetLockColumns()` — 시트별 분기 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `SetLockColumns()` — 시트별 분기: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`SetLockColumns()` — 시트별 분기) |
| WK-SCP0105-0567 | H5 | `SetSheetMerge()` — 조회모드 병합 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `SetSheetMerge()` — 조회모드 병합: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`SetSheetMerge()` — 조회모드 병합) |
| WK-SCP0105-0568 | H5 | `SetSheetNumericColumnFormat()` 분기 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `SetSheetNumericColumnFormat()` 분기: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`SetSheetNumericColumnFormat()` 분기) |
| WK-SCP0105-0569 | H5 | `SetSheetNumericColumnFormatASSEMBLY()`  | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `SetSheetNumericColumnFormatASSEMBLY()` — measure별: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`SetSheetNumericColumnFormatASSEMBLY()` ) |
| WK-SCP0105-0570 | H5 | `_sheetDateColumns` — `_ASSIGN_PRIORITY` | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `_sheetDateColumns` — `_ASSIGN_PRIORITY` 제외 목록: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`_sheetDateColumns` — `_ASSIGN_PRIORITY`) |
| WK-SCP0105-0571 | H5 | `_sheet_idx` — DivisionType → 시트 인덱스 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `_sheet_idx` — DivisionType → 시트 인덱스: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`_sheet_idx` — DivisionType → 시트 인덱스) |
| WK-SCP0105-0572 | H5 | `_si.Query(ds)` — 결과 바인딩 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `_si.Query(ds)` — 결과 바인딩: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`_si.Query(ds)` — 결과 바인딩) |
| WK-SCP0105-0573 | H5 | `btnColumn_Click` → `SCM002_CAPAColumnPo | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `btnColumn_Click` → `SCM002_CAPAColumnPopup("SCP01: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`btnColumn_Click` → `SCM002_CAPAColumnPo) |
| WK-SCP0105-0574 | H5 | `spdMain` (FpSpread, 2시트) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `spdMain` (FpSpread, 2시트): 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`spdMain` (FpSpread, 2시트)) |
| WK-SCP0105-0575 | H5 | 기간 컬럼명 규약 `M_01yyyymm` / `Y_yyyy` | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 기간 컬럼명 규약 `M_01yyyymm` / `Y_yyyy`: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (기간 컬럼명 규약 `M_01yyyymm` / `Y_yyyy`) |
| WK-SCP0105-0576 | H5 | 기간 헤더 행 스키마 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 기간 헤더 행 스키마: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (기간 헤더 행 스키마) |
| WK-SCP0105-0577 | H5 | 컬럼 개인화 적용 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 컬럼 개인화 적용: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (컬럼 개인화 적용) |
| WK-SCP0105-0578 | H5 | 컬럼 키 상수 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 컬럼 키 상수: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (컬럼 키 상수) |
| WK-SCP0105-0579 | H5 | 팝업 OK 후 `BeforeFindData()` (시트 비우고 헤더 재구 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 팝업 OK 후 `BeforeFindData()` (시트 비우고 헤더 재구성): 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (팝업 OK 후 `BeforeFindData()` (시트 비우고 헤더 재구) |
| WK-SCP0105-0580 | X-REASON | D00-1-018 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-018 §1 emptySpaceItem1 / EmptySpaceItem — DevExpress LayoutControl 의 여백 노드. TO-BE 는 CSS Grid(`Grid size`) |  | 1 (D00-1-018) |
| WK-SCP0105-0581 | X-REASON | D00-1-019 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-019 §1 emptySpaceItem11 / EmptySpaceItem — DevExpress LayoutControl 의 여백 노드. TO-BE 는 CSS Grid(`Grid size` |  | 1 (D00-1-019) |
| WK-SCP0105-0582 | X-REASON | D00-1-020 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-020 §1 emptySpaceItem6 / EmptySpaceItem — DevExpress LayoutControl 의 여백 노드. TO-BE 는 CSS Grid(`Grid size`) |  | 1 (D00-1-020) |
| WK-SCP0105-0583 | X-REASON | D00-1-023 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-023 §1 layoutControlGroup1 / LayoutControlGroup — `usrLayoutControl1` 의 Root 라 함께 사장 — `Items.AddRange` 0 |  | 1 (D00-1-023) |
| WK-SCP0105-0584 | X-REASON | D00-1-041 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-041 §1 usrLayoutControl1 / UsrLayoutControl — `Controls.Add(usrLayoutControl1)` grep 0건 = Form 에 붙지 않는 사장 |  | 1 (D00-1-041) |
| WK-SCP0105-0585 | X-REASON | D00-3-015 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-015 §3 Insert / `()` — AS-IS `InsertButton()` 본문이 빈 구현이라 `Insert_Row`(cs:2367) 호출부 0건 = 도달 불가. TO-BE 는 버튼 |  | 1 (D00-3-015) |
| WK-SCP0105-0586 | X-REASON | D00-3-016 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-3-016 §3 SetValue / `(newCell, dic)` — 행 추가 경로가 없어 신규행 기본값 세팅에 도달할 수 없다(03 R-16) 제외 |  | 1 (D00-3-016) |
| WK-SCP0105-0587 | X-REASON | D00-4b-002 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-4b-002 §4b Data_SCP.CommonAll / YearFromThisYear / dtFromYYYY — `dtFromYYYY` 는 선언(cs:73) 외 참조 0건 — 짝인 `cboF |  | 1 (D00-4b-002) |
| WK-SCP0105-0588 | X-REASON | D00-4b-003 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-4b-003 §4b Data.Common / YesOrNo / dtYesOrNo — `dtYesOrNo` 는 선언(cs:74) 외 참조 0건(02 F-25) 제외 |  | 1 (D00-4b-003) |
| WK-SCP0105-0589 | X-REASON | Item 팝업 다중선택 / `OPERATION_GROUP` 필터 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — Item 팝업 다중선택 / `OPERATION_GROUP` 필터 cs:3130 (`pop.Init(multiSelect=true, dtDivision, _division, _shop_group, _i |  | 1 (Item 팝업 다중선택 / `OPERATION_GROUP` 필터) |
| WK-SCP0105-0590 | X-REASON | `2ND_CUTOFF` GET SP 변형 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `2ND_CUTOFF` GET SP 변형 cs:552~573 (`'2'` 분기 없음) `constants.ts:136` (빈 문자열) AS-IS `_sheet_status` 에 `'2'` 분기가 없고 |  | 1 (`2ND_CUTOFF` GET SP 변형) |
| WK-SCP0105-0591 | X-REASON | `DataUtil.checkRequiredOfSearch(this.Con | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `DataUtil.checkRequiredOfSearch(this.Controls)` cs:1457 (DataUtil.cs:67~92†) 없음 이 화면은 `Required` 지정 0건 / 라벨 `*` |  | 1 (`DataUtil.checkRequiredOfSearch(this.Con) |
| WK-SCP0105-0592 | X-REASON | `Insert_Row()` | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `Insert_Row()` cs:2367~2390 없음 호출부 0건(grep 실측). `InsertButton()` 이 빈 구현이라 도달 불가. 03 R-15 |  | 1 (`Insert_Row()`) |
| WK-SCP0105-0593 | X-REASON | `ReadOnlySheetList.Add(SHEETS.ASSEMBLY)` | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `ReadOnlySheetList.Add(SHEETS.ASSEMBLY)` cs:1239 없음 BaseForm 이 이 목록으로 하는 일은 **필터 해제 스킵**뿐이고 시트를 읽기전용으로 만들지 않는다( |  | 1 (`ReadOnlySheetList.Add(SHEETS.ASSEMBLY)`) |
| WK-SCP0105-0594 | X-REASON | `SetSheetNumericColumnFormatELTR()` | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `SetSheetNumericColumnFormatELTR()` cs:1744~1776 (키 cs:1756·1764†) 없음 AS-IS 가 키를 `EQP_QTY` 로 넣는데 실제 measure 는 ` |  | 1 (`SetSheetNumericColumnFormatELTR()`) |
| WK-SCP0105-0595 | X-REASON | `_si.LockColumn(...)` 2줄 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `_si.LockColumn(...)` 2줄 cs:1810~1811 (주석) 없음 주석 상태 |  | 1 (`_si.LockColumn(...)` 2줄) |
| WK-SCP0105-0596 | X-REASON | `cboFromYYYY_SelectedIndexChanged` | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `cboFromYYYY_SelectedIndexChanged` cs:2531~ (끝줄 확인필요) 없음 짝이 되는 컨트롤 `cboFromYYYY` 가 Designer 에 없고 `InitEvent`(cs |  | 1 (`cboFromYYYY_SelectedIndexChanged`) |
| WK-SCP0105-0597 | X-REASON | `dtFromYYYY` (`YearFromThisYear_SCP_ALL` | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `dtFromYYYY` (`YearFromThisYear_SCP_ALL`) cs:73 없음 선언 1건 외 참조 0건(grep 실측). 02 §2.6 / F-25 |  | 1 (`dtFromYYYY` (`YearFromThisYear_SCP_ALL`) |
| WK-SCP0105-0598 | X-REASON | `dtYesOrNo` (`YesOrNo`) | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `dtYesOrNo` (`YesOrNo`) cs:74 없음 선언 1건 외 참조 0건(grep 실측). 02 §2.6 / F-25 |  | 1 (`dtYesOrNo` (`YesOrNo`)) |
| WK-SCP0105-0599 | X-REASON | `layoutControlGroup1` | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `layoutControlGroup1` dsn:33, 118~124, 1052 없음 `usrLayoutControl1` 의 Root 라 함께 사장. `Items.AddRange` 0건. 01 L-07 |  | 1 (`layoutControlGroup1`) |
| WK-SCP0105-0600 | X-REASON | `spdMain.TabStripPolicy = Never` | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `spdMain.TabStripPolicy = Never` cs:1339 없음 시트 탭 UI 자체를 만들지 않으므로 숨길 대상이 없다 |  | 1 (`spdMain.TabStripPolicy = Never`) |
| WK-SCP0105-0601 | X-REASON | `spdMain_Change` | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `spdMain_Change` cs:2933~2943 없음 `InitEvent` 배선 0건(grep 실측 — 정의 1건뿐). 실제 경로는 `_defaultDataModel_Changed`(cs:308 |  | 1 (`spdMain_Change`) |
| WK-SCP0105-0602 | X-REASON | `usrLayoutControl1` | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — `usrLayoutControl1` dsn:32, 108~116, 1051 없음 `Controls.Add(this.usrLayoutControl1)` grep 0건 — Form 에 붙지 않는 사장 노 |  | 1 (`usrLayoutControl1`) |
| WK-SCP0105-0603 | D1 | 0 방어 `eltr_qty==0→1`, `mms_cf==0→1` | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 0 방어 `eltr_qty==0→1`, `mms_cf==0→1`: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (0 방어 `eltr_qty==0→1`, `mms_cf==0→1`) |
| WK-SCP0105-0604 | D1 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 11: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (11) |
| WK-SCP0105-0605 | D1 | D00-2-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-2-001: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-001) |
| WK-SCP0105-0606 | D1 | D00-2-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-2-014: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-014) |
| WK-SCP0105-0607 | D1 | D00-3-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-004: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-004) |
| WK-SCP0105-0608 | D1 | D00-3-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-006: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-006) |
| WK-SCP0105-0609 | D1 | D00-3-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-011: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-011) |
| WK-SCP0105-0610 | D1 | D00-3-018 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-018: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-018) |
| WK-SCP0105-0611 | D1 | D00-3-019 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-019: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-019) |
| WK-SCP0105-0612 | D1 | D00-3-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-020: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-020) |
| WK-SCP0105-0613 | D1 | D00-3-022 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-022: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-022) |
| WK-SCP0105-0614 | D1 | D00-3-023 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-3-023: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-023) |
| WK-SCP0105-0615 | D1 | D00-4c-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4c-004: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4c-004) |
| WK-SCP0105-0616 | D1 | D00-4d-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4d-002: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-002) |
| WK-SCP0105-0617 | D1 | D00-4d-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4d-005: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-005) |
| WK-SCP0105-0618 | D1 | D00-4d-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4d-006: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-006) |
| WK-SCP0105-0619 | D1 | D00-4d-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4d-007: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-007) |
| WK-SCP0105-0620 | D1 | D00-4d-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4d-008: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-008) |
| WK-SCP0105-0621 | D1 | D00-4d-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4d-013: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-013) |
| WK-SCP0105-0622 | D1 | D00-4d-019 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4d-019: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-019) |
| WK-SCP0105-0623 | D1 | D00-4d-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4d-020: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-020) |
| WK-SCP0105-0624 | D1 | D00-4d-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — D00-4d-021: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-021) |
| WK-SCP0105-0625 | D1 | Edit 버튼 노출 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — Edit 버튼 노출: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (Edit 버튼 노출) |
| WK-SCP0105-0626 | D1 | Edit 차단 대상 상태 `-`/`1`/`2` | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — Edit 차단 대상 상태 `-`/`1`/`2`: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (Edit 차단 대상 상태 `-`/`1`/`2`) |
| WK-SCP0105-0627 | D1 | Edit 차단 메시지 `MSG00109` | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — Edit 차단 메시지 `MSG00109`: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (Edit 차단 메시지 `MSG00109`) |
| WK-SCP0105-0628 | D1 | PPM 기입 + 자동 `M` 마킹 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — PPM 기입 + 자동 `M` 마킹: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (PPM 기입 + 자동 `M` 마킹) |
| WK-SCP0105-0629 | D1 | SCP0105_CAPA_Speed_Plan.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SCP0105_CAPA_Speed_Plan.EditButton: 진입점 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 13 (ACT:SCP0105_CAPA_Speed_Plan.EditButton:1) |
| WK-SCP0105-0630 | D1 | `*_ASSIGN_PRIORITY` 0/공백 잠금 `SheetUtils. | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — `*_ASSIGN_PRIORITY` 0/공백 잠금 `SheetUtils.IsCurrPrio: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`*_ASSIGN_PRIORITY` 0/공백 잠금 `SheetUtils.) |
| WK-SCP0105-0631 | D1 | `CheckEltrEquipmentType()` — 설비유형 라인 일괄  | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — `CheckEltrEquipmentType()` — 설비유형 라인 일괄 동기화: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`CheckEltrEquipmentType()` — 설비유형 라인 일괄 ) |
| WK-SCP0105-0632 | D1 | `EditButton()` 가드 4단 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — `EditButton()` 가드 4단: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`EditButton()` 가드 4단) |
| WK-SCP0105-0633 | D1 | `GetCurrVersionProgessStatus()` | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — `GetCurrVersionProgessStatus()`: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`GetCurrVersionProgessStatus()`) |
| WK-SCP0105-0634 | D1 | `GetQtyRowIndex()` — 행 오프셋 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — `GetQtyRowIndex()` — 행 오프셋: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`GetQtyRowIndex()` — 행 오프셋) |
| WK-SCP0105-0635 | D1 | `GetSpeedRowIndex()` / `GetPPMRowIndex() | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — `GetSpeedRowIndex()` / `GetPPMRowIndex()`: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`GetSpeedRowIndex()` / `GetPPMRowIndex()) |
| WK-SCP0105-0636 | D1 | `InitEvent()` — 이벤트 배선 13건 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — `InitEvent()` — 이벤트 배선 13건: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`InitEvent()` — 이벤트 배선 13건) |
| WK-SCP0105-0637 | D1 | `RecalcSheet(currRowIdx, qtyColIdx, curr | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — `RecalcSheet(currRowIdx, qtyColIdx, currMeasure)` : 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`RecalcSheet(currRowIdx, qtyColIdx, curr) |
| WK-SCP0105-0638 | D1 | `RecalcSheet(rowIdx, colIdx)` — 진입 게이트 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — `RecalcSheet(rowIdx, colIdx)` — 진입 게이트: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`RecalcSheet(rowIdx, colIdx)` — 진입 게이트) |
| WK-SCP0105-0639 | D1 | `SaveButton()` 가드 3종 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — `SaveButton()` 가드 3종: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`SaveButton()` 가드 3종) |
| WK-SCP0105-0640 | D1 | `SetLockColumns()` — 시트별 분기 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — `SetLockColumns()` — 시트별 분기: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`SetLockColumns()` — 시트별 분기) |
| WK-SCP0105-0641 | D1 | `SetLockColumnsASSEMBLY()` | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — `SetLockColumnsASSEMBLY()`: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`SetLockColumnsASSEMBLY()`) |
| WK-SCP0105-0642 | D1 | `SetSheetMerge()` — 조회모드 병합 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — `SetSheetMerge()` — 조회모드 병합: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`SetSheetMerge()` — 조회모드 병합) |
| WK-SCP0105-0643 | D1 | `SetSheetNumericColumnFormatASSEMBLY()`  | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — `SetSheetNumericColumnFormatASSEMBLY()` — measure별: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`SetSheetNumericColumnFormatASSEMBLY()` ) |
| WK-SCP0105-0644 | D1 | `SpdMain_CellClick` + `SheetUtils.SetCom | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — `SpdMain_CellClick` + `SheetUtils.SetComboDataRow`: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`SpdMain_CellClick` + `SheetUtils.SetCom) |
| WK-SCP0105-0645 | D1 | `_defaultDataModel_Changed` — 셀 변경 후속 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — `_defaultDataModel_Changed` — 셀 변경 후속: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`_defaultDataModel_Changed` — 셀 변경 후속) |
| WK-SCP0105-0646 | D1 | `_si.SwitchLock()` — 편집모드 토글 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — `_si.SwitchLock()` — 편집모드 토글: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`_si.SwitchLock()` — 편집모드 토글) |
| WK-SCP0105-0647 | D1 | `decimal.Parse` 실패를 catch 로 삼키고 0 유지 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — `decimal.Parse` 실패를 catch 로 삼키고 0 유지: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`decimal.Parse` 실패를 catch 로 삼키고 0 유지) |
| WK-SCP0105-0648 | D1 | `hooks/useCapaSpeedPlanCellEdit.ts` | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — `hooks/useCapaSpeedPlanCellEdit.ts`: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`hooks/useCapaSpeedPlanCellEdit.ts`) |
| WK-SCP0105-0649 | D1 | 고정영역 전 행 잠금 `LockRange2(0, 0, rowCnt-1,  | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 고정영역 전 행 잠금 `LockRange2(0, 0, rowCnt-1, _fixed_col: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (고정영역 전 행 잠금 `LockRange2(0, 0, rowCnt-1, ) |
| WK-SCP0105-0650 | D1 | 조회 직후 전열 잠금 `_si.LockColumn(0, GetMaxCol | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 조회 직후 전열 잠금 `_si.LockColumn(0, GetMaxColumnIndex(): 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (조회 직후 전열 잠금 `_si.LockColumn(0, GetMaxCol) |
| WK-SCP0105-0651 | D1 | 편집 게이트 적용점 (`IsLockCell`) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 편집 게이트 적용점 (`IsLockCell`): 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (편집 게이트 적용점 (`IsLockCell`)) |
| WK-SCP0105-0652 | D1 | 편집모드 토글 시 재렌더 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 편집모드 토글 시 재렌더: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (편집모드 토글 시 재렌더) |
| WK-SCP0105-0653 | D1 | 후속 호출 순서 `CheckEltrEquipmentType` → `Rec | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 후속 호출 순서 `CheckEltrEquipmentType` → `RecalcSheet`: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (후속 호출 순서 `CheckEltrEquipmentType` → `Rec) |
| WK-SCP0105-0654 | D3 | 0 방어 `eltr_qty==0→1`, `mms_cf==0→1` | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 0 방어 `eltr_qty==0→1`, `mms_cf==0→1`: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (0 방어 `eltr_qty==0→1`, `mms_cf==0→1`) |
| WK-SCP0105-0655 | D3 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 11: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (11) |
| WK-SCP0105-0656 | D3 | D00-2-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-2-001: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-001) |
| WK-SCP0105-0657 | D3 | D00-2-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-2-014: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-014) |
| WK-SCP0105-0658 | D3 | D00-3-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-004: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-004) |
| WK-SCP0105-0659 | D3 | D00-3-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-006: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-006) |
| WK-SCP0105-0660 | D3 | D00-3-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-011: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-011) |
| WK-SCP0105-0661 | D3 | D00-3-018 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-018: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-018) |
| WK-SCP0105-0662 | D3 | D00-3-019 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-019: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-019) |
| WK-SCP0105-0663 | D3 | D00-3-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-020: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-020) |
| WK-SCP0105-0664 | D3 | D00-3-022 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-022: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-022) |
| WK-SCP0105-0665 | D3 | D00-3-023 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-3-023: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-023) |
| WK-SCP0105-0666 | D3 | D00-4c-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4c-004: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4c-004) |
| WK-SCP0105-0667 | D3 | D00-4d-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4d-002: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-002) |
| WK-SCP0105-0668 | D3 | D00-4d-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4d-005: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-005) |
| WK-SCP0105-0669 | D3 | D00-4d-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4d-006: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-006) |
| WK-SCP0105-0670 | D3 | D00-4d-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4d-007: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-007) |
| WK-SCP0105-0671 | D3 | D00-4d-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4d-008: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-008) |
| WK-SCP0105-0672 | D3 | D00-4d-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4d-013: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-013) |
| WK-SCP0105-0673 | D3 | D00-4d-019 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4d-019: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-019) |
| WK-SCP0105-0674 | D3 | D00-4d-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4d-020: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-020) |
| WK-SCP0105-0675 | D3 | D00-4d-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — D00-4d-021: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-021) |
| WK-SCP0105-0676 | D3 | Edit 버튼 노출 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — Edit 버튼 노출: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (Edit 버튼 노출) |
| WK-SCP0105-0677 | D3 | Edit 차단 대상 상태 `-`/`1`/`2` | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — Edit 차단 대상 상태 `-`/`1`/`2`: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (Edit 차단 대상 상태 `-`/`1`/`2`) |
| WK-SCP0105-0678 | D3 | Edit 차단 메시지 `MSG00109` | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — Edit 차단 메시지 `MSG00109`: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (Edit 차단 메시지 `MSG00109`) |
| WK-SCP0105-0679 | D3 | PPM 기입 + 자동 `M` 마킹 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — PPM 기입 + 자동 `M` 마킹: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (PPM 기입 + 자동 `M` 마킹) |
| WK-SCP0105-0680 | D3 | SCP0105_CAPA_Speed_Plan.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SCP0105_CAPA_Speed_Plan.EditButton: 진입점 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 13 (ACT:SCP0105_CAPA_Speed_Plan.EditButton:1) |
| WK-SCP0105-0681 | D3 | `*_ASSIGN_PRIORITY` 0/공백 잠금 `SheetUtils. | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — `*_ASSIGN_PRIORITY` 0/공백 잠금 `SheetUtils.IsCurrPrio: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`*_ASSIGN_PRIORITY` 0/공백 잠금 `SheetUtils.) |
| WK-SCP0105-0682 | D3 | `CheckEltrEquipmentType()` — 설비유형 라인 일괄  | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — `CheckEltrEquipmentType()` — 설비유형 라인 일괄 동기화: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`CheckEltrEquipmentType()` — 설비유형 라인 일괄 ) |
| WK-SCP0105-0683 | D3 | `EditButton()` 가드 4단 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — `EditButton()` 가드 4단: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`EditButton()` 가드 4단) |
| WK-SCP0105-0684 | D3 | `GetCurrVersionProgessStatus()` | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — `GetCurrVersionProgessStatus()`: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`GetCurrVersionProgessStatus()`) |
| WK-SCP0105-0685 | D3 | `GetQtyRowIndex()` — 행 오프셋 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — `GetQtyRowIndex()` — 행 오프셋: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`GetQtyRowIndex()` — 행 오프셋) |
| WK-SCP0105-0686 | D3 | `GetSpeedRowIndex()` / `GetPPMRowIndex() | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — `GetSpeedRowIndex()` / `GetPPMRowIndex()`: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`GetSpeedRowIndex()` / `GetPPMRowIndex()) |
| WK-SCP0105-0687 | D3 | `InitEvent()` — 이벤트 배선 13건 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — `InitEvent()` — 이벤트 배선 13건: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`InitEvent()` — 이벤트 배선 13건) |
| WK-SCP0105-0688 | D3 | `RecalcSheet(currRowIdx, qtyColIdx, curr | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — `RecalcSheet(currRowIdx, qtyColIdx, currMeasure)` : 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`RecalcSheet(currRowIdx, qtyColIdx, curr) |
| WK-SCP0105-0689 | D3 | `RecalcSheet(rowIdx, colIdx)` — 진입 게이트 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — `RecalcSheet(rowIdx, colIdx)` — 진입 게이트: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`RecalcSheet(rowIdx, colIdx)` — 진입 게이트) |
| WK-SCP0105-0690 | D3 | `SaveButton()` 가드 3종 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — `SaveButton()` 가드 3종: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`SaveButton()` 가드 3종) |
| WK-SCP0105-0691 | D3 | `SetLockColumns()` — 시트별 분기 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — `SetLockColumns()` — 시트별 분기: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`SetLockColumns()` — 시트별 분기) |
| WK-SCP0105-0692 | D3 | `SetLockColumnsASSEMBLY()` | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — `SetLockColumnsASSEMBLY()`: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`SetLockColumnsASSEMBLY()`) |
| WK-SCP0105-0693 | D3 | `SetSheetMerge()` — 조회모드 병합 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — `SetSheetMerge()` — 조회모드 병합: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`SetSheetMerge()` — 조회모드 병합) |
| WK-SCP0105-0694 | D3 | `SetSheetNumericColumnFormatASSEMBLY()`  | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — `SetSheetNumericColumnFormatASSEMBLY()` — measure별: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`SetSheetNumericColumnFormatASSEMBLY()` ) |
| WK-SCP0105-0695 | D3 | `SpdMain_CellClick` + `SheetUtils.SetCom | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — `SpdMain_CellClick` + `SheetUtils.SetComboDataRow`: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`SpdMain_CellClick` + `SheetUtils.SetCom) |
| WK-SCP0105-0696 | D3 | `_defaultDataModel_Changed` — 셀 변경 후속 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — `_defaultDataModel_Changed` — 셀 변경 후속: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`_defaultDataModel_Changed` — 셀 변경 후속) |
| WK-SCP0105-0697 | D3 | `_si.SwitchLock()` — 편집모드 토글 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — `_si.SwitchLock()` — 편집모드 토글: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`_si.SwitchLock()` — 편집모드 토글) |
| WK-SCP0105-0698 | D3 | `decimal.Parse` 실패를 catch 로 삼키고 0 유지 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — `decimal.Parse` 실패를 catch 로 삼키고 0 유지: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`decimal.Parse` 실패를 catch 로 삼키고 0 유지) |
| WK-SCP0105-0699 | D3 | `hooks/useCapaSpeedPlanCellEdit.ts` | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — `hooks/useCapaSpeedPlanCellEdit.ts`: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (`hooks/useCapaSpeedPlanCellEdit.ts`) |
| WK-SCP0105-0700 | D3 | 고정영역 전 행 잠금 `LockRange2(0, 0, rowCnt-1,  | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 고정영역 전 행 잠금 `LockRange2(0, 0, rowCnt-1, _fixed_col: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (고정영역 전 행 잠금 `LockRange2(0, 0, rowCnt-1, ) |
| WK-SCP0105-0701 | D3 | 조회 직후 전열 잠금 `_si.LockColumn(0, GetMaxCol | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 조회 직후 전열 잠금 `_si.LockColumn(0, GetMaxColumnIndex(): 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (조회 직후 전열 잠금 `_si.LockColumn(0, GetMaxCol) |
| WK-SCP0105-0702 | D3 | 편집 게이트 적용점 (`IsLockCell`) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 편집 게이트 적용점 (`IsLockCell`): 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (편집 게이트 적용점 (`IsLockCell`)) |
| WK-SCP0105-0703 | D3 | 편집모드 토글 시 재렌더 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 편집모드 토글 시 재렌더: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (편집모드 토글 시 재렌더) |
| WK-SCP0105-0704 | D3 | 후속 호출 순서 `CheckEltrEquipmentType` → `Rec | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 후속 호출 순서 `CheckEltrEquipmentType` → `RecalcSheet`: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (후속 호출 순서 `CheckEltrEquipmentType` → `Rec) |
| WK-SCP0105-0705 | D4 | **BLK-6** INSERT 버튼 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — **BLK-6** INSERT 버튼: 행 집계 — D4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (**BLK-6** INSERT 버튼) |
| WK-SCP0105-0706 | D4 | 13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — 13: 행 집계 — D4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (13) |
| WK-SCP0105-0707 | D4 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — COMMON:UC-03: 행 집계 — D4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-SCP0105-0708 | D4 | D00-3-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — D00-3-008: 행 집계 — D4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-008) |
| WK-SCP0105-0709 | D4 | D00-3-018 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — D00-3-018: 행 집계 — D4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-018) |
| WK-SCP0105-0710 | D4 | D00-3-019 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — D00-3-019: 행 집계 — D4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-019) |
| WK-SCP0105-0711 | D4 | D00-3-022 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — D00-3-022: 행 집계 — D4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-022) |
| WK-SCP0105-0712 | D4 | D00-4e-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — D00-4e-001: 행 집계 — D4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-001) |
| WK-SCP0105-0713 | D4 | `DeleteButton()` 가드 3종 + 신규행만 제거 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — `DeleteButton()` 가드 3종 + 신규행만 제거: 행 집계 — D4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (`DeleteButton()` 가드 3종 + 신규행만 제거) |
| WK-SCP0105-0714 | D4 | `InsertButton()` (빈 구현) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — `InsertButton()` (빈 구현): 행 집계 — D4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (`InsertButton()` (빈 구현)) |
| WK-SCP0105-0715 | D4 | 설비유형 동기화 시 `M` 마킹 범위 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — 설비유형 동기화 시 `M` 마킹 범위: 행 집계 — D4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (설비유형 동기화 시 `M` 마킹 범위) |
| WK-SCP0105-0716 | D5 | D00-2-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — D00-2-014: 행 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-014) |
| WK-SCP0105-0717 | D5 | D00-4b-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — D00-4b-004: 행 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-004) |
| WK-SCP0105-0718 | D5 | D00-4d-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — D00-4d-001: 행 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-001) |
| WK-SCP0105-0719 | D5 | SCP0105_CAPA_Speed_Plan.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0105_CAPA_Speed_Plan.CreateSpread: 진입점 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0105_CAPA_Speed_Plan.CreateSpread) |
| WK-SCP0105-0720 | D5 | `SpdMain_CellClick` + `SheetUtils.SetCom | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — `SpdMain_CellClick` + `SheetUtils.SetComboDataRow`: 행 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (`SpdMain_CellClick` + `SheetUtils.SetCom) |
| WK-SCP0105-0721 | E4 | **BLK-10** 필수검증 무발동 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — **BLK-10** 필수검증 무발동: 행 집계 — E4 31요소: NOT_RUN:31 (미실행 요소가 남아 판정필요) |  | 1 (**BLK-10** 필수검증 무발동) |
| WK-SCP0105-0722 | E4 | D00-4d-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D00-4d-005: 행 집계 — E4 31요소: NOT_RUN:31 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-005) |
| WK-SCP0105-0723 | E4 | D00-4d-015 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D00-4d-015: 행 집계 — E4 31요소: NOT_RUN:31 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-015) |
| WK-SCP0105-0724 | E4 | SCP0105_CAPA_Speed_Plan.SetBaseToDateCol | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0105_CAPA_Speed_Plan.SetBaseToDateColumns: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCP0105_CAPA_Speed_Plan.SetBaseToDat) |
| WK-SCP0105-0725 | E4 | SCP0105_CAPA_Speed_Plan.SetLockColumns | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0105_CAPA_Speed_Plan.SetLockColumns: 진입점 집계 — E4 31요소: NOT_RUN:31 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0105_CAPA_Speed_Plan.SetLockColum) |
| WK-SCP0105-0726 | E4 | SCP0105_CAPA_Speed_Plan.SetLockColumnsAS | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0105_CAPA_Speed_Plan.SetLockColumnsASSEMBLY: 진입점 집계 — E4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 32 (ACT:SCP0105_CAPA_Speed_Plan.SetLockColum) |
| WK-SCP0105-0727 | E4 | SCP0105_CAPA_Speed_Plan.SetLockColumnsEL | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0105_CAPA_Speed_Plan.SetLockColumnsELTR: 진입점 집계 — E4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 46 (ACT:SCP0105_CAPA_Speed_Plan.SetLockColum) |
| WK-SCP0105-0728 | E4 | SCP0105_CAPA_Speed_Plan.SetQueryInfoGet | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0105_CAPA_Speed_Plan.SetQueryInfoGet: 진입점 집계 — E4 31요소: NOT_RUN:31 (미실행 요소가 남아 판정필요) |  | 19 (ACT:SCP0105_CAPA_Speed_Plan.SetQueryInfo) |
| WK-SCP0105-0729 | E4 | SCP0105_CAPA_Speed_Plan.SetQueryInfoSave | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0105_CAPA_Speed_Plan.SetQueryInfoSave: 진입점 집계 — E4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 23 (ACT:SCP0105_CAPA_Speed_Plan.SetQueryInfo) |
| WK-SCP0105-0730 | E4 | SCP0105_CAPA_Speed_Plan.SetSheetMerge | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0105_CAPA_Speed_Plan.SetSheetMerge: 진입점 집계 — E4 31요소: NOT_RUN:31 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.SetSheetMerg) |
| WK-SCP0105-0731 | E4 | SCP0105_CAPA_Speed_Plan.SetSheetNumericC | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0105_CAPA_Speed_Plan.SetSheetNumericColumnForma: 진입점 집계 — E4 31요소: NOT_RUN:31 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0105_CAPA_Speed_Plan.SetSheetNume) |
| WK-SCP0105-0732 | E4 | SCP0105_CAPA_Speed_Plan.SetSheetNumericC | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0105_CAPA_Speed_Plan.SetSheetNumericColumnForma: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0105_CAPA_Speed_Plan.SetSheetNume) |
| WK-SCP0105-0733 | E4 | SCP0105_CAPA_Speed_Plan.SetSheetNumericC | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0105_CAPA_Speed_Plan.SetSheetNumericColumnForma: 진입점 집계 — E4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0105_CAPA_Speed_Plan.SetSheetNume) |
| WK-SCP0105-0734 | E4 | SCP0105_CAPA_Speed_Plan.SetVisibleElectr | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0105_CAPA_Speed_Plan.SetVisibleElectrodeType: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.SetVisibleEl) |
| WK-SCP0105-0735 | E4 | SCP0105_CAPA_Speed_Plan.SetVisibleOperat | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0105_CAPA_Speed_Plan.SetVisibleOperation: 진입점 집계 — E4 31요소: NOT_RUN:31 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.SetVisibleOp) |
| WK-SCP0105-0736 | E4 | SCP0105_CAPA_Speed_Plan.SetVisibleSheetC | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0105_CAPA_Speed_Plan.SetVisibleSheetColumns: 진입점 집계 — E4 31요소: NOT_RUN:31 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.SetVisibleSh) |
| WK-SCP0105-0737 | E4 | SCP0105_CAPA_Speed_Plan.Set_MeasureColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0105_CAPA_Speed_Plan.Set_MeasureColor: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SCP0105_CAPA_Speed_Plan.Set_MeasureC) |
| WK-SCP0105-0738 | E4 | `DataUtil.checkRequiredOfSpread(_si)` | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — `DataUtil.checkRequiredOfSpread(_si)`: 행 집계 — E4 31요소: NOT_RUN:31 (미실행 요소가 남아 판정필요) |  | 1 (`DataUtil.checkRequiredOfSpread(_si)`) |
| WK-SCP0105-0739 | E4 | 편집모드 토글 시 재렌더 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 편집모드 토글 시 재렌더: 행 집계 — E4 31요소: NOT_RUN:31 (미실행 요소가 남아 판정필요) |  | 1 (편집모드 토글 시 재렌더) |
| WK-SCP0105-0740 | E5 | D00-2-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E5 기대값 확정 — D00-2-014: 행 집계 — E5 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-014) |
| WK-SCP0105-0741 | E5 | D00-4b-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E5 기대값 확정 — D00-4b-004: 행 집계 — E5 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-004) |
| WK-SCP0105-0742 | E5 | D00-4d-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E5 기대값 확정 — D00-4d-001: 행 집계 — E5 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-001) |
| WK-SCP0105-0743 | E5 | `SpdMain_CellClick` + `SheetUtils.SetCom | 사람 판정 / AS-IS 원문 확인 → 재판정 | E5 기대값 확정 — `SpdMain_CellClick` + `SheetUtils.SetComboDataRow`: 행 집계 — E5 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (`SpdMain_CellClick` + `SheetUtils.SetCom) |
| WK-SCP0105-0744 | A1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (1) |
| WK-SCP0105-0745 | A1 | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 12: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (12) |
| WK-SCP0105-0746 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (COMMON:UC-02) |
| WK-SCP0105-0747 | A1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-03: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (COMMON:UC-03) |
| WK-SCP0105-0748 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (COMMON:UC-06) |
| WK-SCP0105-0749 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (COMMON:UC-07) |
| WK-SCP0105-0750 | A1 | D00-1-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-011: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (D00-1-011) |
| WK-SCP0105-0751 | A1 | D00-1-025 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-025: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (D00-1-025) |
| WK-SCP0105-0752 | A1 | D00-1-026 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-026: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (D00-1-026) |
| WK-SCP0105-0753 | A1 | D00-1-042 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-042: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (D00-1-042) |
| WK-SCP0105-0754 | A1 | D00-2-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-002: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (D00-2-002) |
| WK-SCP0105-0755 | A1 | D00-2-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-004: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (D00-2-004) |
| WK-SCP0105-0756 | A1 | D00-2-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-006: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (D00-2-006) |
| WK-SCP0105-0757 | A1 | D00-2-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-013: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (D00-2-013) |
| WK-SCP0105-0758 | A1 | D00-3-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-001: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (D00-3-001) |
| WK-SCP0105-0759 | A1 | D00-3-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-013: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (D00-3-013) |
| WK-SCP0105-0760 | A1 | D00-4b-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4b-004: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (D00-4b-004) |
| WK-SCP0105-0761 | A1 | D00-4d-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4d-004: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (D00-4d-004) |
| WK-SCP0105-0762 | A1 | D00-4d-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4d-007: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (D00-4d-007) |
| WK-SCP0105-0763 | A1 | PKG_SCP0104.P_SCP0104_GET_SPREAD_TITLE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0104.P_SCP0104_GET_SPREAD_TITLE: 골든 비교 케이스 없음(PKG_SCP0104.P_SCP0104_GET_SPREAD_TITLE — 팝업·보조 SP 는 golden_cases. |  | 1 (기간 헤더 행 스키마) |
| WK-SCP0105-0764 | A1 | SCP0105_CAPA_Speed_Plan.AfterFindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0105_CAPA_Speed_Plan.AfterFindData: 진입점 집계 — A1 1요소: REVIEW:1 |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.AfterFindDat) |
| WK-SCP0105-0765 | A1 | SCP0105_CAPA_Speed_Plan.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0105_CAPA_Speed_Plan.FindButton: 진입점 집계 — A1 1요소: REVIEW:1 |  | 3 (ACT:SCP0105_CAPA_Speed_Plan.FindButton A) |
| WK-SCP0105-0766 | A1 | SCP0105_CAPA_Speed_Plan.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0105_CAPA_Speed_Plan.FindData: 진입점 집계 — A1 1요소: REVIEW:1 |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.FindData ACT) |
| WK-SCP0105-0767 | A1 | SCP0105_CAPA_Speed_Plan.FindDataMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0105_CAPA_Speed_Plan.FindDataMain: 진입점 집계 — A1 1요소: REVIEW:1 |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.FindDataMain) |
| WK-SCP0105-0768 | A1 | `FindButton()` (F5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `FindButton()` (F5): 행 집계 — A1 1요소: REVIEW:1 |  | 1 (`FindButton()` (F5)) |
| WK-SCP0105-0769 | A1 | `GetQtyRowIndex()` — 행 오프셋 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `GetQtyRowIndex()` — 행 오프셋: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (`GetQtyRowIndex()` — 행 오프셋) |
| WK-SCP0105-0770 | A1 | `InitSpread()` — 시트 가시성 전환 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `InitSpread()` — 시트 가시성 전환: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (`InitSpread()` — 시트 가시성 전환) |
| WK-SCP0105-0771 | A1 | `RefreshAllPre()` — 마스터 전량 재수신 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `RefreshAllPre()` — 마스터 전량 재수신: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (`RefreshAllPre()` — 마스터 전량 재수신) |
| WK-SCP0105-0772 | A1 | `RefreshElectrodeTypeSpread()` — 행 기준 후보 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `RefreshElectrodeTypeSpread()` — 행 기준 후보 좁힘: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (`RefreshElectrodeTypeSpread()` — 행 기준 후보) |
| WK-SCP0105-0773 | A1 | `SetSheetMerge()` — 조회모드 병합 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `SetSheetMerge()` — 조회모드 병합: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (`SetSheetMerge()` — 조회모드 병합) |
| WK-SCP0105-0774 | A1 | `SetSheetNumericColumnFormatASSEMBLY()`  | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `SetSheetNumericColumnFormatASSEMBLY()` — measure별: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (`SetSheetNumericColumnFormatASSEMBLY()` ) |
| WK-SCP0105-0775 | A1 | `btnColumn` (조회영역 우측 아이콘) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `btnColumn` (조회영역 우측 아이콘): 행 집계 — A1 1요소: REVIEW:1 |  | 1 (`btnColumn` (조회영역 우측 아이콘)) |
| WK-SCP0105-0776 | A1 | `rgrpDivisionType_SelectedIndexChanged` | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `rgrpDivisionType_SelectedIndexChanged`: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (`rgrpDivisionType_SelectedIndexChanged`) |
| WK-SCP0105-0777 | A1 | `usrConditionPanel1` / `usrLayoutControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `usrConditionPanel1` / `usrLayoutControl2` — 조회영역: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (`usrConditionPanel1` / `usrLayoutControl) |
| WK-SCP0105-0778 | A1 | admin 컬럼/Measure 메타 동적 fetch | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — admin 컬럼/Measure 메타 동적 fetch: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (admin 컬럼/Measure 메타 동적 fetch) |
| WK-SCP0105-0779 | A1 | 설계 02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 설계 02: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (설계 02) |
| WK-SCP0105-0780 | A1 | 저장/조회 성공 시 `IsEditMode=false` (01 L-27) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 저장/조회 성공 시 `IsEditMode=false` (01 L-27): 행 집계 — A1 1요소: REVIEW:1 |  | 1 (저장/조회 성공 시 `IsEditMode=false` (01 L-27)) |
| WK-SCP0105-0781 | A1 | 조회 직후 전열 잠금 `_si.LockColumn(0, GetMaxCol | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 조회 직후 전열 잠금 `_si.LockColumn(0, GetMaxColumnIndex(): 행 집계 — A1 1요소: REVIEW:1 |  | 1 (조회 직후 전열 잠금 `_si.LockColumn(0, GetMaxCol) |
| WK-SCP0105-0782 | A1 | 조회영역 접기 토글 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 조회영역 접기 토글: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (조회영역 접기 토글) |
| WK-SCP0105-0783 | A1 | 조회조건 13필드 타입 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 조회조건 13필드 타입: 행 집계 — A1 1요소: REVIEW:1 |  | 1 (조회조건 13필드 타입) |
| WK-SCP0105-0784 | A1 | 진입 자동조회 없음 (Form_Load 에 `FindData` 호출 0건 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 진입 자동조회 없음 (Form_Load 에 `FindData` 호출 0건): 행 집계 — A1 1요소: REVIEW:1 |  | 1 (진입 자동조회 없음 (Form_Load 에 `FindData` 호출 0건) |
| WK-SCP0105-0785 | A1 | 팝업 OK 후 `BeforeFindData()` (시트 비우고 헤더 재구 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 팝업 OK 후 `BeforeFindData()` (시트 비우고 헤더 재구성): 행 집계 — A1 1요소: REVIEW:1 |  | 1 (팝업 OK 후 `BeforeFindData()` (시트 비우고 헤더 재구) |
| WK-SCP0105-0786 | A6 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — COMMON:UC-03: 행 집계 — A6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-SCP0105-0787 | A6 | D00-2-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — D00-2-002: 행 집계 — A6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-002) |
| WK-SCP0105-0788 | A6 | D00-3-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — D00-3-013: 행 집계 — A6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-013) |
| WK-SCP0105-0789 | A6 | SCP0105_CAPA_Speed_Plan.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — SCP0105_CAPA_Speed_Plan.FindButton: 진입점 집계 — A6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0105_CAPA_Speed_Plan.FindButton A) |
| WK-SCP0105-0790 | A6 | SCP0105_CAPA_Speed_Plan.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — SCP0105_CAPA_Speed_Plan.FindData: 진입점 집계 — A6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.FindData ACT) |
| WK-SCP0105-0791 | A6 | SCP0105_CAPA_Speed_Plan.FindDataMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — SCP0105_CAPA_Speed_Plan.FindDataMain: 진입점 집계 — A6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.FindDataMain) |
| WK-SCP0105-0792 | A6 | 저장/조회 성공 시 `IsEditMode=false` (01 L-27) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 저장/조회 성공 시 `IsEditMode=false` (01 L-27): 행 집계 — A6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (저장/조회 성공 시 `IsEditMode=false` (01 L-27)) |
| WK-SCP0105-0793 | A6 | 진입 자동조회 없음 (Form_Load 에 `FindData` 호출 0건 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 진입 자동조회 없음 (Form_Load 에 `FindData` 호출 0건): 행 집계 — A6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (진입 자동조회 없음 (Form_Load 에 `FindData` 호출 0건) |
| WK-SCP0105-0794 | A6 | 팝업 OK 후 `BeforeFindData()` (시트 비우고 헤더 재구 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 팝업 OK 후 `BeforeFindData()` (시트 비우고 헤더 재구성): 행 집계 — A6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (팝업 OK 후 `BeforeFindData()` (시트 비우고 헤더 재구) |
| WK-SCP0105-0795 | G1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 1: 행 집계 — G1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-SCP0105-0796 | G1 | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 12: 행 집계 — G1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (12) |
| WK-SCP0105-0797 | G1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-02: 행 집계 — G1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0105-0798 | G1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-03: 행 집계 — G1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-SCP0105-0799 | G1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-06: 행 집계 — G1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0105-0800 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0105-0801 | G1 | D00-1-025 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-025: 행 집계 — G1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-025) |
| WK-SCP0105-0802 | G1 | D00-1-026 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-026: 행 집계 — G1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-026) |
| WK-SCP0105-0803 | G1 | D00-1-040 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-040: 행 집계 — G1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-040) |
| WK-SCP0105-0804 | G1 | D00-1-042 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-042: 행 집계 — G1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-042) |
| WK-SCP0105-0805 | G1 | D00-3-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-3-001: 행 집계 — G1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-001) |
| WK-SCP0105-0806 | G1 | D00-3-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-3-013: 행 집계 — G1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-013) |
| WK-SCP0105-0807 | G1 | D00-4b-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-4b-004: 행 집계 — G1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-004) |
| WK-SCP0105-0808 | G1 | D00-4d-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-4d-004: 행 집계 — G1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-004) |
| WK-SCP0105-0809 | G1 | D00-4d-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-4d-007: 행 집계 — G1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-007) |
| WK-SCP0105-0810 | G1 | SCP0105_CAPA_Speed_Plan.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SCP0105_CAPA_Speed_Plan.FindButton: 진입점 집계 — G1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.FindButton:1) |
| WK-SCP0105-0811 | G1 | SCP0105_CAPA_Speed_Plan.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SCP0105_CAPA_Speed_Plan.FindData: 진입점 집계 — G1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.FindData:236) |
| WK-SCP0105-0812 | G1 | SCP0105_CAPA_Speed_Plan.FindDataMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SCP0105_CAPA_Speed_Plan.FindDataMain: 진입점 집계 — G1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.FindDataMain) |
| WK-SCP0105-0813 | G1 | `FindButton()` (F5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `FindButton()` (F5): 행 집계 — G1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (`FindButton()` (F5)) |
| WK-SCP0105-0814 | G1 | `GetQtyRowIndex()` — 행 오프셋 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `GetQtyRowIndex()` — 행 오프셋: 행 집계 — G1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (`GetQtyRowIndex()` — 행 오프셋) |
| WK-SCP0105-0815 | G1 | `InitSpread()` — 시트 가시성 전환 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `InitSpread()` — 시트 가시성 전환: 행 집계 — G1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (`InitSpread()` — 시트 가시성 전환) |
| WK-SCP0105-0816 | G1 | `RefreshAllPre()` — 마스터 전량 재수신 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `RefreshAllPre()` — 마스터 전량 재수신: 행 집계 — G1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (`RefreshAllPre()` — 마스터 전량 재수신) |
| WK-SCP0105-0817 | G1 | `RefreshElectrodeTypeSpread()` — 행 기준 후보 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `RefreshElectrodeTypeSpread()` — 행 기준 후보 좁힘: 행 집계 — G1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (`RefreshElectrodeTypeSpread()` — 행 기준 후보) |
| WK-SCP0105-0818 | G1 | `SetSheetMerge()` — 조회모드 병합 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `SetSheetMerge()` — 조회모드 병합: 행 집계 — G1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (`SetSheetMerge()` — 조회모드 병합) |
| WK-SCP0105-0819 | G1 | `SetSheetNumericColumnFormatASSEMBLY()`  | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `SetSheetNumericColumnFormatASSEMBLY()` — measure별: 행 집계 — G1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (`SetSheetNumericColumnFormatASSEMBLY()` ) |
| WK-SCP0105-0820 | G1 | `btnColumn` (조회영역 우측 아이콘) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `btnColumn` (조회영역 우측 아이콘): 행 집계 — G1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (`btnColumn` (조회영역 우측 아이콘)) |
| WK-SCP0105-0821 | G1 | `rgrpDivisionType_SelectedIndexChanged` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `rgrpDivisionType_SelectedIndexChanged`: 행 집계 — G1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (`rgrpDivisionType_SelectedIndexChanged`) |
| WK-SCP0105-0822 | G1 | `usrConditionPanel1` / `usrLayoutControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `usrConditionPanel1` / `usrLayoutControl2` — 조회영역: 행 집계 — G1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (`usrConditionPanel1` / `usrLayoutControl) |
| WK-SCP0105-0823 | G1 | admin 컬럼/Measure 메타 동적 fetch | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — admin 컬럼/Measure 메타 동적 fetch: 행 집계 — G1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (admin 컬럼/Measure 메타 동적 fetch) |
| WK-SCP0105-0824 | G1 | 설계 02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 설계 02: 행 집계 — G1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (설계 02) |
| WK-SCP0105-0825 | G1 | 저장/조회 성공 시 `IsEditMode=false` (01 L-27) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 저장/조회 성공 시 `IsEditMode=false` (01 L-27): 행 집계 — G1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (저장/조회 성공 시 `IsEditMode=false` (01 L-27)) |
| WK-SCP0105-0826 | G1 | 조회 직후 전열 잠금 `_si.LockColumn(0, GetMaxCol | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 조회 직후 전열 잠금 `_si.LockColumn(0, GetMaxColumnIndex(): 행 집계 — G1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (조회 직후 전열 잠금 `_si.LockColumn(0, GetMaxCol) |
| WK-SCP0105-0827 | G1 | 조회영역 접기 토글 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 조회영역 접기 토글: 행 집계 — G1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (조회영역 접기 토글) |
| WK-SCP0105-0828 | G1 | 조회조건 13필드 타입 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 조회조건 13필드 타입: 행 집계 — G1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (조회조건 13필드 타입) |
| WK-SCP0105-0829 | G1 | 진입 자동조회 없음 (Form_Load 에 `FindData` 호출 0건 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 진입 자동조회 없음 (Form_Load 에 `FindData` 호출 0건): 행 집계 — G1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (진입 자동조회 없음 (Form_Load 에 `FindData` 호출 0건) |
| WK-SCP0105-0830 | G1 | 팝업 OK 후 `BeforeFindData()` (시트 비우고 헤더 재구 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 팝업 OK 후 `BeforeFindData()` (시트 비우고 헤더 재구성): 행 집계 — G1 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (팝업 OK 후 `BeforeFindData()` (시트 비우고 헤더 재구) |
| WK-SCP0105-0831 | G6 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — COMMON:UC-06: 행 집계 — G6 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0105-0832 | G6 | D00-1-025 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-1-025: 행 집계 — G6 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-025) |
| WK-SCP0105-0833 | G6 | D00-1-026 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-1-026: 행 집계 — G6 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-026) |
| WK-SCP0105-0834 | G6 | D00-1-040 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-1-040: 행 집계 — G6 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-040) |
| WK-SCP0105-0835 | G6 | D00-1-042 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-1-042: 행 집계 — G6 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-042) |
| WK-SCP0105-0836 | G6 | D00-3-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-3-001: 행 집계 — G6 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-001) |
| WK-SCP0105-0837 | G6 | D00-4b-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-4b-004: 행 집계 — G6 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-004) |
| WK-SCP0105-0838 | G6 | `InitSpread()` — 시트 가시성 전환 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — `InitSpread()` — 시트 가시성 전환: 행 집계 — G6 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (`InitSpread()` — 시트 가시성 전환) |
| WK-SCP0105-0839 | G6 | `RefreshElectrodeTypeSpread()` — 행 기준 후보 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — `RefreshElectrodeTypeSpread()` — 행 기준 후보 좁힘: 행 집계 — G6 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (`RefreshElectrodeTypeSpread()` — 행 기준 후보) |
| WK-SCP0105-0840 | G6 | 조회조건 13필드 타입 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 조회조건 13필드 타입: 행 집계 — G6 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (조회조건 13필드 타입) |
| WK-SCP0105-0841 | X-LOC | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (1) |
| WK-SCP0105-0842 | X-LOC | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 10: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (10) |
| WK-SCP0105-0843 | X-LOC | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 11: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (11) |
| WK-SCP0105-0844 | X-LOC | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 12: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (12) |
| WK-SCP0105-0845 | X-LOC | 13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 13: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (13) |
| WK-SCP0105-0846 | X-LOC | 14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 14: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (14) |
| WK-SCP0105-0847 | X-LOC | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (2) |
| WK-SCP0105-0848 | X-LOC | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (3) |
| WK-SCP0105-0849 | X-LOC | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (4) |
| WK-SCP0105-0850 | X-LOC | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (5) |
| WK-SCP0105-0851 | X-LOC | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 6: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (6) |
| WK-SCP0105-0852 | X-LOC | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 7: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (7) |
| WK-SCP0105-0853 | X-LOC | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 8: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (8) |
| WK-SCP0105-0854 | X-LOC | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 9: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (9) |
| WK-SCP0105-0855 | X-LOC | AS-IS Designer | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — AS-IS Designer: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (AS-IS Designer) |
| WK-SCP0105-0856 | X-LOC | AS-IS 원소스 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — AS-IS 원소스: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (AS-IS 원소스) |
| WK-SCP0105-0857 | X-LOC | 설계 00 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 설계 00: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (설계 00) |
| WK-SCP0105-0858 | X-LOC | 설계 01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 설계 01: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (설계 01) |
| WK-SCP0105-0859 | X-LOC | 설계 02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 설계 02: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (설계 02) |
| WK-SCP0105-0860 | X-LOC | 설계 03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 설계 03: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (설계 03) |
| WK-SCP0105-0861 | X-LOC | 설계 07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 설계 07: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (설계 07) |
| WK-SCP0105-0862 | X-LOC | 필드 배치 순서 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 필드 배치 순서: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (필드 배치 순서) |
| WK-SCP0105-0863 | X-ROW | 14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 14: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (14) |
| WK-SCP0105-0864 | X-ROW | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 2: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (2) |
| WK-SCP0105-0865 | X-ROW | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 4: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (4) |
| WK-SCP0105-0866 | X-ROW | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 9: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (9) |
| WK-SCP0105-0867 | X-ROW | AS-IS Designer | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AS-IS Designer: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (AS-IS Designer) |
| WK-SCP0105-0868 | X-ROW | AS-IS 원소스 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — AS-IS 원소스: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (AS-IS 원소스) |
| WK-SCP0105-0869 | X-ROW | D00-1-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-001: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-001) |
| WK-SCP0105-0870 | X-ROW | D00-1-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-002: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-002) |
| WK-SCP0105-0871 | X-ROW | D00-1-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-003: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-003) |
| WK-SCP0105-0872 | X-ROW | D00-1-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-005: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-005) |
| WK-SCP0105-0873 | X-ROW | D00-1-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-006: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-006) |
| WK-SCP0105-0874 | X-ROW | D00-1-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-024: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-024) |
| WK-SCP0105-0875 | X-ROW | D00-1-027 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-027: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-027) |
| WK-SCP0105-0876 | X-ROW | D00-1-028 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-028: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-028) |
| WK-SCP0105-0877 | X-ROW | D00-1-029 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-029: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-029) |
| WK-SCP0105-0878 | X-ROW | D00-1-030 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-030: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-030) |
| WK-SCP0105-0879 | X-ROW | D00-1-032 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-032: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-032) |
| WK-SCP0105-0880 | X-ROW | D00-1-033 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-033: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-033) |
| WK-SCP0105-0881 | X-ROW | D00-3-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-002: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-002) |
| WK-SCP0105-0882 | X-ROW | D00-3-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-003: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-003) |
| WK-SCP0105-0883 | X-ROW | D00-3-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-010: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-010) |
| WK-SCP0105-0884 | X-ROW | D00-4c-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-001: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-001) |
| WK-SCP0105-0885 | X-ROW | D00-4c-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-002: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-002) |
| WK-SCP0105-0886 | X-ROW | D00-4c-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-003: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-003) |
| WK-SCP0105-0887 | X-ROW | D00-4c-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-005: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-005) |
| WK-SCP0105-0888 | X-ROW | D00-4c-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4c-006: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4c-006) |
| WK-SCP0105-0889 | X-ROW | D00-4d-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4d-003: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4d-003) |
| WK-SCP0105-0890 | X-ROW | Excel / Upload / Manual | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — Excel / Upload / Manual: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (Excel / Upload / Manual) |
| WK-SCP0105-0891 | X-ROW | GET QueryId 조립 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — GET QueryId 조립: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (GET QueryId 조립) |
| WK-SCP0105-0892 | X-ROW | Item 라벨 동적 치환 (01 L-03) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — Item 라벨 동적 치환 (01 L-03): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (Item 라벨 동적 치환 (01 L-03)) |
| WK-SCP0105-0893 | X-ROW | SCP0105_CAPA_Speed_Plan.AfterFindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.AfterFindData: 진입점 집계 2검사 — NOPATH:2 (미실행 검사가 남아 판정필요) |  | 23 (ACT:SCP0105_CAPA_Speed_Plan.AfterFindDat) |
| WK-SCP0105-0894 | X-ROW | SCP0105_CAPA_Speed_Plan.AfterSaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.AfterSaveData: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 30 (ACT:SCP0105_CAPA_Speed_Plan.AfterSaveDat) |
| WK-SCP0105-0895 | X-ROW | SCP0105_CAPA_Speed_Plan.BeforeFindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.BeforeFindData: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0105_CAPA_Speed_Plan.BeforeFindDa) |
| WK-SCP0105-0896 | X-ROW | SCP0105_CAPA_Speed_Plan.ChangeColumnName | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.ChangeColumnNameToCodeName: 진입점 동작 재현 시나리오 필요 — 문장 종류 DATA_OP/ENTRY/GRID_SET, 연결된 요소 검사 없음 |  | 5 (ACT:SCP0105_CAPA_Speed_Plan.ChangeColumn) |
| WK-SCP0105-0897 | X-ROW | SCP0105_CAPA_Speed_Plan.CheckChangedValu | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.CheckChangedValues: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/DATA_OP/ENTRY/EXPR/FLOW/LOCAL/RETURN,  |  | 18 (ACT:SCP0105_CAPA_Speed_Plan.CheckChanged) |
| WK-SCP0105-0898 | X-ROW | SCP0105_CAPA_Speed_Plan.CheckEltrEquipme | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.CheckEltrEquipmentType: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 40 (ACT:SCP0105_CAPA_Speed_Plan.CheckEltrEqu) |
| WK-SCP0105-0899 | X-ROW | SCP0105_CAPA_Speed_Plan.ClearUsrCheckedL | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.ClearUsrCheckedList: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/LIST_REBIND/STATE_RESET, 연결된 요소 |  | 4 (ACT:SCP0105_CAPA_Speed_Plan.ClearUsrChec) |
| WK-SCP0105-0900 | X-ROW | SCP0105_CAPA_Speed_Plan.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.CreateSpread) |
| WK-SCP0105-0901 | X-ROW | SCP0105_CAPA_Speed_Plan.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.EditButton: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.EditButton) |
| WK-SCP0105-0902 | X-ROW | SCP0105_CAPA_Speed_Plan.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.FindButton: 진입점 집계 4검사 — NOPATH:2 · NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.FindButton A) |
| WK-SCP0105-0903 | X-ROW | SCP0105_CAPA_Speed_Plan.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.FindData: 진입점 집계 4검사 — NOPATH:2 · NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.FindData) |
| WK-SCP0105-0904 | X-ROW | SCP0105_CAPA_Speed_Plan.FindDataMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.FindDataMain: 진입점 집계 5검사 — NOPATH:3 · NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.FindDataMain) |
| WK-SCP0105-0905 | X-ROW | SCP0105_CAPA_Speed_Plan.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.Form_Load) |
| WK-SCP0105-0906 | X-ROW | SCP0105_CAPA_Speed_Plan.GetPPMRowIndex | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.GetPPMRowIndex: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.GetPPMRowInd) |
| WK-SCP0105-0907 | X-ROW | SCP0105_CAPA_Speed_Plan.GetQtyRowIndex | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.GetQtyRowIndex: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.GetQtyRowInd) |
| WK-SCP0105-0908 | X-ROW | SCP0105_CAPA_Speed_Plan.GetSpeedRowIndex | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.GetSpeedRowIndex: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.GetSpeedRowI) |
| WK-SCP0105-0909 | X-ROW | SCP0105_CAPA_Speed_Plan.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.InitControls: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.InitControls) |
| WK-SCP0105-0910 | X-ROW | SCP0105_CAPA_Speed_Plan.InitDatasAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.InitDatasAll: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.InitDatasAll) |
| WK-SCP0105-0911 | X-ROW | SCP0105_CAPA_Speed_Plan.InitQueryDics | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.InitQueryDics: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.InitQueryDic) |
| WK-SCP0105-0912 | X-ROW | SCP0105_CAPA_Speed_Plan.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.InitSpread A) |
| WK-SCP0105-0913 | X-ROW | SCP0105_CAPA_Speed_Plan.Insert_Row | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.Insert_Row: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/DATA_OP/ENTRY/GRID_SET/LOCAL, 연결된 요소 검사 없음 |  | 9 (ACT:SCP0105_CAPA_Speed_Plan.Insert_Row A) |
| WK-SCP0105-0914 | X-ROW | SCP0105_CAPA_Speed_Plan.IsDummy | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.IsDummy: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 8 (ACT:SCP0105_CAPA_Speed_Plan.IsDummy ACT:) |
| WK-SCP0105-0915 | X-ROW | SCP0105_CAPA_Speed_Plan.IsExistsDifferen | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.IsExistsDifferentEquipment: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/ENTRY/LOCAL/RETURN, |  | 15 (ACT:SCP0105_CAPA_Speed_Plan.IsExistsDiff) |
| WK-SCP0105-0916 | X-ROW | SCP0105_CAPA_Speed_Plan.IsModelDummy | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.IsModelDummy: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 8 (ACT:SCP0105_CAPA_Speed_Plan.IsModelDummy) |
| WK-SCP0105-0917 | X-ROW | SCP0105_CAPA_Speed_Plan.RecalcSheet | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.RecalcSheet: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/CALL_LOCAL/ENTRY/EXPR/GRID_SET/LOCAL |  | 74 (ACT:SCP0105_CAPA_Speed_Plan.RecalcSheet ) |
| WK-SCP0105-0918 | X-ROW | SCP0105_CAPA_Speed_Plan.RefreshAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.RefreshAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 7 (ACT:SCP0105_CAPA_Speed_Plan.RefreshAll A) |
| WK-SCP0105-0919 | X-ROW | SCP0105_CAPA_Speed_Plan.RefreshAllPre | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.RefreshAllPre: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 8 (ACT:SCP0105_CAPA_Speed_Plan.RefreshAllPr) |
| WK-SCP0105-0920 | X-ROW | SCP0105_CAPA_Speed_Plan.RefreshColumnsVi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.RefreshColumnsVisible: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/DATA_OP/ENTRY/EXPR/GRID_SET/GRID_ |  | 8 (ACT:SCP0105_CAPA_Speed_Plan.RefreshColum) |
| WK-SCP0105-0921 | X-ROW | SCP0105_CAPA_Speed_Plan.RefreshDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.RefreshDivision: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.RefreshDivis) |
| WK-SCP0105-0922 | X-ROW | SCP0105_CAPA_Speed_Plan.RefreshElectrode | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.RefreshElectrodeAssemblyAl: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/DATA_OP/ENTRY, 연결 |  | 5 (ACT:SCP0105_CAPA_Speed_Plan.RefreshElect) |
| WK-SCP0105-0923 | X-ROW | SCP0105_CAPA_Speed_Plan.RefreshElectrode | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.RefreshElectrodeType: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SCP0105_CAPA_Speed_Plan.RefreshElect) |
| WK-SCP0105-0924 | X-ROW | SCP0105_CAPA_Speed_Plan.RefreshElectrode | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.RefreshElectrodeTypeAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0105_CAPA_Speed_Plan.RefreshElect) |
| WK-SCP0105-0925 | X-ROW | SCP0105_CAPA_Speed_Plan.RefreshElectrode | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.RefreshElectrodeTypeSpread: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/ENTRY, 연결된 요소 검사 없음 |  | 3 (ACT:SCP0105_CAPA_Speed_Plan.RefreshElect) |
| WK-SCP0105-0926 | X-ROW | SCP0105_CAPA_Speed_Plan.RefreshElectrode | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.RefreshElectrodeeEltrAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/COMBO_DATA/DATA_OP/ENTRY/LOCAL |  | 5 (ACT:SCP0105_CAPA_Speed_Plan.RefreshElect) |
| WK-SCP0105-0927 | X-ROW | SCP0105_CAPA_Speed_Plan.RefreshFactory | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.RefreshFactory: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0105_CAPA_Speed_Plan.RefreshFacto) |
| WK-SCP0105-0928 | X-ROW | SCP0105_CAPA_Speed_Plan.RefreshFactoryAl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.RefreshFactoryAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0105_CAPA_Speed_Plan.RefreshFacto) |
| WK-SCP0105-0929 | X-ROW | SCP0105_CAPA_Speed_Plan.RefreshLine | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.RefreshLine: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 34 (ACT:SCP0105_CAPA_Speed_Plan.RefreshLine ) |
| WK-SCP0105-0930 | X-ROW | SCP0105_CAPA_Speed_Plan.RefreshLineAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.RefreshLineAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0105_CAPA_Speed_Plan.RefreshLineA) |
| WK-SCP0105-0931 | X-ROW | SCP0105_CAPA_Speed_Plan.RefreshOperation | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.RefreshOperation: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SCP0105_CAPA_Speed_Plan.RefreshOpera) |
| WK-SCP0105-0932 | X-ROW | SCP0105_CAPA_Speed_Plan.RefreshOperation | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.RefreshOperationAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/DATA_OP/ENTRY, 연결된 요소 검사 |  | 7 (ACT:SCP0105_CAPA_Speed_Plan.RefreshOpera) |
| WK-SCP0105-0933 | X-ROW | SCP0105_CAPA_Speed_Plan.RefreshPlanType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.RefreshPlanType: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/VALUE_SET, 연결된 요소 검사 없음 |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.RefreshPlanT) |
| WK-SCP0105-0934 | X-ROW | SCP0105_CAPA_Speed_Plan.RefreshPlant | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.RefreshPlant: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0105_CAPA_Speed_Plan.RefreshPlant) |
| WK-SCP0105-0935 | X-ROW | SCP0105_CAPA_Speed_Plan.RefreshPlantAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.RefreshPlantAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0105_CAPA_Speed_Plan.RefreshPlant) |
| WK-SCP0105-0936 | X-ROW | SCP0105_CAPA_Speed_Plan.RefreshProgressS | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.RefreshProgressStatus: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 13 (ACT:SCP0105_CAPA_Speed_Plan.RefreshProgr) |
| WK-SCP0105-0937 | X-ROW | SCP0105_CAPA_Speed_Plan.RefreshSheetHead | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.RefreshSheetHeader: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY/GRID_INIT, 연결된 요소 검 |  | 5 (ACT:SCP0105_CAPA_Speed_Plan.RefreshSheet) |
| WK-SCP0105-0938 | X-ROW | SCP0105_CAPA_Speed_Plan.RefreshSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.RefreshSite: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0105_CAPA_Speed_Plan.RefreshSite ) |
| WK-SCP0105-0939 | X-ROW | SCP0105_CAPA_Speed_Plan.RefreshSiteAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.RefreshSiteAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0105_CAPA_Speed_Plan.RefreshSiteA) |
| WK-SCP0105-0940 | X-ROW | SCP0105_CAPA_Speed_Plan.RefreshVersion | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.RefreshVersion: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0105_CAPA_Speed_Plan.RefreshVersi) |
| WK-SCP0105-0941 | X-ROW | SCP0105_CAPA_Speed_Plan.RefreshVersionSe | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.RefreshVersionSeq: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0105_CAPA_Speed_Plan.RefreshVersi) |
| WK-SCP0105-0942 | X-ROW | SCP0105_CAPA_Speed_Plan.SaveButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.SaveButton: 진입점 집계 4검사 — NOPATH:2 · NOT_RUN:1 · REVIEW:1 |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.SaveButton:2) |
| WK-SCP0105-0943 | X-ROW | SCP0105_CAPA_Speed_Plan.SetBaseToDateCol | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.SetBaseToDateColumns: 진입점 집계 4검사 — REVIEW:2 · NOT_RUN:2 |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.SetBaseToDat) |
| WK-SCP0105-0944 | X-ROW | SCP0105_CAPA_Speed_Plan.SetLockColumns | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.SetLockColumns: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.SetLockColum) |
| WK-SCP0105-0945 | X-ROW | SCP0105_CAPA_Speed_Plan.SetLockColumnsAS | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.SetLockColumnsASSEMBLY: 진입점 집계 16검사 — NOT_RUN:14 · REVIEW:2 |  | 3 (ACT:SCP0105_CAPA_Speed_Plan.SetLockColum) |
| WK-SCP0105-0946 | X-ROW | SCP0105_CAPA_Speed_Plan.SetLockColumnsEL | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.SetLockColumnsELTR: 진입점 집계 16검사 — NOT_RUN:14 · REVIEW:2 |  | 5 (ACT:SCP0105_CAPA_Speed_Plan.SetLockColum) |
| WK-SCP0105-0947 | X-ROW | SCP0105_CAPA_Speed_Plan.SetQueryInfoGet | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.SetQueryInfoGet: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0105_CAPA_Speed_Plan.SetQueryInfo) |
| WK-SCP0105-0948 | X-ROW | SCP0105_CAPA_Speed_Plan.SetQueryInfoSave | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.SetQueryInfoSave: 진입점 집계 30검사 — NOT_RUN:28 · REVIEW:2 |  | 4 (ACT:SCP0105_CAPA_Speed_Plan.SetQueryInfo) |
| WK-SCP0105-0949 | X-ROW | SCP0105_CAPA_Speed_Plan.SetSheetMerge | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.SetSheetMerge: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.SetSheetMerg) |
| WK-SCP0105-0950 | X-ROW | SCP0105_CAPA_Speed_Plan.SetSheetNumericC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.SetSheetNumericColumnForma: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.SetSheetNume) |
| WK-SCP0105-0951 | X-ROW | SCP0105_CAPA_Speed_Plan.SetSheetNumericC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.SetSheetNumericColumnForma: 진입점 집계 4검사 — REVIEW:2 · NOT_RUN:2 |  | 10 (ACT:SCP0105_CAPA_Speed_Plan.SetSheetNume) |
| WK-SCP0105-0952 | X-ROW | SCP0105_CAPA_Speed_Plan.SetSheetNumericC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.SetSheetNumericColumnForma: 진입점 집계 8검사 — NOT_RUN:6 · REVIEW:2 |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.SetSheetNume) |
| WK-SCP0105-0953 | X-ROW | SCP0105_CAPA_Speed_Plan.SetVisibleElectr | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.SetVisibleElectrodeType: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0105_CAPA_Speed_Plan.SetVisibleEl) |
| WK-SCP0105-0954 | X-ROW | SCP0105_CAPA_Speed_Plan.SetVisibleOperat | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.SetVisibleOperation: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0105_CAPA_Speed_Plan.SetVisibleOp) |
| WK-SCP0105-0955 | X-ROW | SCP0105_CAPA_Speed_Plan.SetVisibleSheetC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.SetVisibleSheetColumns: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.SetVisibleSh) |
| WK-SCP0105-0956 | X-ROW | SCP0105_CAPA_Speed_Plan.ShowItem | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.ShowItem: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/ENTRY/LOCAL/POPUP/RETURN/UI_PROP, 연결된 요 |  | 12 (ACT:SCP0105_CAPA_Speed_Plan.ShowItem ACT) |
| WK-SCP0105-0957 | X-ROW | SCP0105_CAPA_Speed_Plan.SpdMain_CellClic | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.SpdMain_CellClick: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 11 (ACT:SCP0105_CAPA_Speed_Plan.SpdMain_Cell) |
| WK-SCP0105-0958 | X-ROW | SCP0105_CAPA_Speed_Plan._defaultDataMode | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan._defaultDataModel_Changed: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan._defaultData) |
| WK-SCP0105-0959 | X-ROW | SCP0105_CAPA_Speed_Plan.btnColumn_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.btnColumn_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0105_CAPA_Speed_Plan.btnColumn_Cl) |
| WK-SCP0105-0960 | X-ROW | SCP0105_CAPA_Speed_Plan.btnItem_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.btnItem_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.btnItem_Clic) |
| WK-SCP0105-0961 | X-ROW | SCP0105_CAPA_Speed_Plan.cboDivision_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.cboDivision_SelectedIndexC: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.cboDivision_) |
| WK-SCP0105-0962 | X-ROW | SCP0105_CAPA_Speed_Plan.cboFromYYYY_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.cboFromYYYY_SelectedIndexC: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.cboFromYYYY_) |
| WK-SCP0105-0963 | X-ROW | SCP0105_CAPA_Speed_Plan.cboProgressStatu | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.cboProgressStatus_Selected: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.cboProgressS) |
| WK-SCP0105-0964 | X-ROW | SCP0105_CAPA_Speed_Plan.cboVersionSeq_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.cboVersionSeq_SelectedInde: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.cboVersionSe) |
| WK-SCP0105-0965 | X-ROW | SCP0105_CAPA_Speed_Plan.cboVersion_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.cboVersion_SelectedIndexCh: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.cboVersion_S) |
| WK-SCP0105-0966 | X-ROW | SCP0105_CAPA_Speed_Plan.clbFactory_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.clbFactory_SelectedIndexCh: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.clbFactory_S) |
| WK-SCP0105-0967 | X-ROW | SCP0105_CAPA_Speed_Plan.clbLine_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.clbLine_SelectedIndexChang: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.clbLine_Sele) |
| WK-SCP0105-0968 | X-ROW | SCP0105_CAPA_Speed_Plan.clbOperation_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.clbOperation_SelectedIndex: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.clbOperation) |
| WK-SCP0105-0969 | X-ROW | SCP0105_CAPA_Speed_Plan.clbPlant_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.clbPlant_SelectedIndexChan: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.clbPlant_Sel) |
| WK-SCP0105-0970 | X-ROW | SCP0105_CAPA_Speed_Plan.clbSite_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.clbSite_SelectedIndexChang: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.clbSite_Sele) |
| WK-SCP0105-0971 | X-ROW | SCP0105_CAPA_Speed_Plan.getPlanType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.getPlanType: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.getPlanType) |
| WK-SCP0105-0972 | X-ROW | SCP0105_CAPA_Speed_Plan.getShopGroup | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.getShopGroup: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.getShopGroup) |
| WK-SCP0105-0973 | X-ROW | SCP0105_CAPA_Speed_Plan.rgrpDivisionType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.rgrpDivisionType_SelectedI: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0105_CAPA_Speed_Plan.rgrpDivision) |
| WK-SCP0105-0974 | X-ROW | SCP0105_CAPA_Speed_Plan.spdMain_Change | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0105_CAPA_Speed_Plan.spdMain_Change: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/ENTRY/EXPR/RETURN, 연결된 요소 검사 없음 |  | 6 (ACT:SCP0105_CAPA_Speed_Plan.spdMain_Chan) |
| WK-SCP0105-0975 | X-ROW | Status 기본선택 `UIUtils.GetIndexByCode` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — Status 기본선택 `UIUtils.GetIndexByCode`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (Status 기본선택 `UIUtils.GetIndexByCode`) |
| WK-SCP0105-0976 | X-ROW | `CString.GetCheckedListValueNone` — 다중선택 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `CString.GetCheckedListValueNone` — 다중선택 전개: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`CString.GetCheckedListValueNone` — 다중선택) |
| WK-SCP0105-0977 | X-ROW | `CapaSpeedPlan.tsx` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `CapaSpeedPlan.tsx`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`CapaSpeedPlan.tsx`) |
| WK-SCP0105-0978 | X-ROW | `DBUtils.DeleteEmptyName` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `DBUtils.DeleteEmptyName`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`DBUtils.DeleteEmptyName`) |
| WK-SCP0105-0979 | X-ROW | `GetElectrodeOperationFilter` — `OPERATI | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `GetElectrodeOperationFilter` — `OPERATION_ID` 접두: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`GetElectrodeOperationFilter` — `OPERATI) |
| WK-SCP0105-0980 | X-ROW | `GetSortedCode` — `DMY_` 후치 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `GetSortedCode` — `DMY_` 후치: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`GetSortedCode` — `DMY_` 후치) |
| WK-SCP0105-0981 | X-ROW | `InitControls()` — 진입 시 컨트롤·콤보 일괄 초기화 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `InitControls()` — 진입 시 컨트롤·콤보 일괄 초기화: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`InitControls()` — 진입 시 컨트롤·콤보 일괄 초기화) |
| WK-SCP0105-0982 | X-ROW | `IsModelDummy` 판정 컬럼 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `IsModelDummy` 판정 컬럼: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`IsModelDummy` 판정 컬럼) |
| WK-SCP0105-0983 | X-ROW | `RefreshAll()` — 6축 재계산 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `RefreshAll()` — 6축 재계산: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`RefreshAll()` — 6축 재계산) |
| WK-SCP0105-0984 | X-ROW | `ScpCapa.GetShopGroupId` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `ScpCapa.GetShopGroupId`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`ScpCapa.GetShopGroupId`) |
| WK-SCP0105-0985 | X-ROW | `ScpCapaBL.GetFilteredPackCell` — `SHOP_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `ScpCapaBL.GetFilteredPackCell` — `SHOP_GROUP_ID`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`ScpCapaBL.GetFilteredPackCell` — `SHOP_) |
| WK-SCP0105-0986 | X-ROW | `SetQueryInfoGet()` — GET payload 15건 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `SetQueryInfoGet()` — GET payload 15건: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`SetQueryInfoGet()` — GET payload 15건) |
| WK-SCP0105-0987 | X-ROW | `SetVisibleElectrodeType()` (01 L-02) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `SetVisibleElectrodeType()` (01 L-02): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`SetVisibleElectrodeType()` (01 L-02)) |
| WK-SCP0105-0988 | X-ROW | `SetVisibleOperation()` (01 L-01) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `SetVisibleOperation()` (01 L-01): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`SetVisibleOperation()` (01 L-01)) |
| WK-SCP0105-0989 | X-ROW | `_division_type` getter — `rgrpDivisionT | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `_division_type` getter — `rgrpDivisionType.Select: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`_division_type` getter — `rgrpDivisionT) |
| WK-SCP0105-0990 | X-ROW | `_division` getter | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `_division` getter: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`_division` getter) |
| WK-SCP0105-0991 | X-ROW | `_fixed_column_name` = `DefColumns.IDX` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `_fixed_column_name` = `DefColumns.IDX`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`_fixed_column_name` = `DefColumns.IDX`) |
| WK-SCP0105-0992 | X-ROW | `_from_yyyymm` — 선택 Plan Month +1개월 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `_from_yyyymm` — 선택 Plan Month +1개월: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`_from_yyyymm` — 선택 Plan Month +1개월) |
| WK-SCP0105-0993 | X-ROW | `_sheet_name` — QueryId 접미 조립 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `_sheet_name` — QueryId 접미 조립: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`_sheet_name` — QueryId 접미 조립) |
| WK-SCP0105-0994 | X-ROW | `_sheet_status` — GET SP 변형 선택자 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `_sheet_status` — GET SP 변형 선택자: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`_sheet_status` — GET SP 변형 선택자) |
| WK-SCP0105-0995 | X-ROW | `capa-speed-plan.constants.ts` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `capa-speed-plan.constants.ts`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`capa-speed-plan.constants.ts`) |
| WK-SCP0105-0996 | X-ROW | `capa-speed-plan.types.ts` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `capa-speed-plan.types.ts`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`capa-speed-plan.types.ts`) |
| WK-SCP0105-0997 | X-ROW | `cboDivision` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `cboDivision`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`cboDivision`) |
| WK-SCP0105-0998 | X-ROW | `cboProgressStatus` (Status) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `cboProgressStatus` (Status): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`cboProgressStatus` (Status)) |
| WK-SCP0105-0999 | X-ROW | `cboVersionSeq` (Version) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `cboVersionSeq` (Version): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`cboVersionSeq` (Version)) |
| WK-SCP0105-1000 | X-ROW | `cboVersion` (Plan Month) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `cboVersion` (Plan Month): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`cboVersion` (Plan Month)) |
| WK-SCP0105-1001 | X-ROW | `clbFactory` (표기 "Building") | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `clbFactory` (표기 "Building"): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`clbFactory` (표기 "Building")) |
| WK-SCP0105-1002 | X-ROW | `clbLine` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `clbLine`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`clbLine`) |
| WK-SCP0105-1003 | X-ROW | `clbOperation` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `clbOperation`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`clbOperation`) |
| WK-SCP0105-1004 | X-ROW | `clbPlant` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `clbPlant`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`clbPlant`) |
| WK-SCP0105-1005 | X-ROW | `clbSite` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `clbSite`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`clbSite`) |
| WK-SCP0105-1006 | X-ROW | `components/CapaSpeedPlanColumnModal.tsx | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `components/CapaSpeedPlanColumnModal.tsx`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`components/CapaSpeedPlanColumnModal.tsx) |
| WK-SCP0105-1007 | X-ROW | `components/CapaSpeedPlanForm.tsx` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `components/CapaSpeedPlanForm.tsx`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`components/CapaSpeedPlanForm.tsx`) |
| WK-SCP0105-1008 | X-ROW | `components/CapaSpeedPlanGrid.module.scs | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `components/CapaSpeedPlanGrid.module.scss`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`components/CapaSpeedPlanGrid.module.scs) |
| WK-SCP0105-1009 | X-ROW | `components/CapaSpeedPlanGrid.tsx` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `components/CapaSpeedPlanGrid.tsx`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`components/CapaSpeedPlanGrid.tsx`) |
| WK-SCP0105-1010 | X-ROW | `hooks/useCapaSpeedPlanCombos.ts` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `hooks/useCapaSpeedPlanCombos.ts`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`hooks/useCapaSpeedPlanCombos.ts`) |
| WK-SCP0105-1011 | X-ROW | `hooks/useCapaSpeedPlanConditionEffects. | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `hooks/useCapaSpeedPlanConditionEffects.ts`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`hooks/useCapaSpeedPlanConditionEffects.) |
| WK-SCP0105-1012 | X-ROW | `index.ts` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `index.ts`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`index.ts`) |
| WK-SCP0105-1013 | X-ROW | `layoutControlGroup2` 12-column 배치 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `layoutControlGroup2` 12-column 배치: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`layoutControlGroup2` 12-column 배치) |
| WK-SCP0105-1014 | X-ROW | `rgrpDivisionType` (라디오 3옵션) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `rgrpDivisionType` (라디오 3옵션): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`rgrpDivisionType` (라디오 3옵션)) |
| WK-SCP0105-1015 | X-ROW | `txtPlanType` (읽기전용 파생) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `txtPlanType` (읽기전용 파생): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`txtPlanType` (읽기전용 파생)) |
| WK-SCP0105-1016 | X-ROW | `useCapaSpeedPlanStore.ts` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `useCapaSpeedPlanStore.ts`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`useCapaSpeedPlanStore.ts`) |
| WK-SCP0105-1017 | X-ROW | `utils/capaSpeedPlan.combos.test.ts` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `utils/capaSpeedPlan.combos.test.ts`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`utils/capaSpeedPlan.combos.test.ts`) |
| WK-SCP0105-1018 | X-ROW | `utils/capaSpeedPlan.combos.ts` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `utils/capaSpeedPlan.combos.ts`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`utils/capaSpeedPlan.combos.ts`) |
| WK-SCP0105-1019 | X-ROW | `utils/capaSpeedPlan.dateColumns.ts` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `utils/capaSpeedPlan.dateColumns.ts`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`utils/capaSpeedPlan.dateColumns.ts`) |
| WK-SCP0105-1020 | X-ROW | `utils/capaSpeedPlan.editLock.test.ts` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `utils/capaSpeedPlan.editLock.test.ts`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`utils/capaSpeedPlan.editLock.test.ts`) |
| WK-SCP0105-1021 | X-ROW | `utils/capaSpeedPlan.editLock.ts` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `utils/capaSpeedPlan.editLock.ts`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`utils/capaSpeedPlan.editLock.ts`) |
| WK-SCP0105-1022 | X-ROW | `utils/capaSpeedPlan.recalc.test.ts` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `utils/capaSpeedPlan.recalc.test.ts`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`utils/capaSpeedPlan.recalc.test.ts`) |
| WK-SCP0105-1023 | X-ROW | `utils/capaSpeedPlan.recalc.ts` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `utils/capaSpeedPlan.recalc.ts`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`utils/capaSpeedPlan.recalc.ts`) |
| WK-SCP0105-1024 | X-ROW | 라우트 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 라우트: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (라우트) |
| WK-SCP0105-1025 | X-ROW | 설계 00 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 설계 00: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (설계 00) |
| WK-SCP0105-1026 | X-ROW | 설계 01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 설계 01: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (설계 01) |
| WK-SCP0105-1027 | X-ROW | 설계 03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 설계 03: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (설계 03) |
| WK-SCP0105-1028 | X-ROW | 설계 07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 설계 07: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (설계 07) |
| WK-SCP0105-1029 | X-ROW | 콤보 SQL_ID 6종 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 콤보 SQL_ID 6종: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (콤보 SQL_ID 6종) |
| WK-SCP0105-1030 | X-ROW | 필드 배치 순서 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 필드 배치 순서: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (필드 배치 순서) |
| WK-SCP0105-1031 | X-ROW | 화면 제목 / 건수 표시 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 화면 제목 / 건수 표시: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (화면 제목 / 건수 표시) |
| WK-SCP0105-1032 | G5 | 13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — 13: 행 집계 — G5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (13) |
| WK-SCP0105-1033 | G5 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — 3: 행 집계 — G5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (3) |
| WK-SCP0105-1034 | G5 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — COMMON:UC-06: 행 집계 — G5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0105-1035 | G5 | D00-4e-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-4e-001: 행 집계 — G5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-001) |
| WK-SCP0105-1036 | G5 | D00-4e-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-4e-002: 행 집계 — G5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-002) |
| WK-SCP0105-1037 | G5 | MODAL:CapaSpeedPlanColumnModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MODAL:CapaSpeedPlanColumnModal: 행 집계 — G5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:CapaSpeedPlanColumnModal) |
| WK-SCP0105-1038 | G5 | MODAL:ShowDialog | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MODAL:ShowDialog: 행 집계 — G5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ShowDialog) |
| WK-SCP0105-1039 | G5 | `components/CapaSpeedPlanItemPopup.tsx` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — `components/CapaSpeedPlanItemPopup.tsx`: 행 집계 — G5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (`components/CapaSpeedPlanItemPopup.tsx`) |
| WK-SCP0105-1040 | G5 | 팝업 OK 후 `BeforeFindData()` (시트 비우고 헤더 재구 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — 팝업 OK 후 `BeforeFindData()` (시트 비우고 헤더 재구성): 행 집계 — G5 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (팝업 OK 후 `BeforeFindData()` (시트 비우고 헤더 재구) |
| WK-SCP0105-1041 | H6 | 13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — 13: 행 집계 — H6 4요소: NOPATH:3 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (13) |
| WK-SCP0105-1042 | H6 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — 3: 행 집계 — H6 4요소: NOPATH:3 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (3) |
| WK-SCP0105-1043 | H6 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — COMMON:UC-06: 행 집계 — H6 4요소: NOPATH:3 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0105-1044 | H6 | D00-4e-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-4e-001: 행 집계 — H6 4요소: NOPATH:3 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-001) |
| WK-SCP0105-1045 | H6 | D00-4e-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-4e-002: 행 집계 — H6 4요소: NOPATH:3 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-002) |
| WK-SCP0105-1046 | H6 | MODAL:CapaSpeedPlanColumnModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MODAL:CapaSpeedPlanColumnModal: 행 집계 — H6 4요소: NOPATH:3 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:CapaSpeedPlanColumnModal) |
| WK-SCP0105-1047 | H6 | MODAL:ShowDialog | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MODAL:ShowDialog: 행 집계 — H6 4요소: NOPATH:3 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ShowDialog) |
| WK-SCP0105-1048 | H6 | `components/CapaSpeedPlanItemPopup.tsx` | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — `components/CapaSpeedPlanItemPopup.tsx`: 행 집계 — H6 4요소: NOPATH:3 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (`components/CapaSpeedPlanItemPopup.tsx`) |
| WK-SCP0105-1049 | H6 | 팝업 OK 후 `BeforeFindData()` (시트 비우고 헤더 재구 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — 팝업 OK 후 `BeforeFindData()` (시트 비우고 헤더 재구성): 행 집계 — H6 4요소: NOPATH:3 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (팝업 OK 후 `BeforeFindData()` (시트 비우고 헤더 재구) |
| WK-SCP0105-1050 | M4 | 13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 13: 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (13) |
| WK-SCP0105-1051 | M4 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 3: 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (3) |
| WK-SCP0105-1052 | M4 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — COMMON:UC-06: 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0105-1053 | M4 | D00-4e-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-4e-001: 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-001) |
| WK-SCP0105-1054 | M4 | D00-4e-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-4e-002: 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-002) |
| WK-SCP0105-1055 | M4 | MODAL:CapaSpeedPlanColumnModal | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MODAL:CapaSpeedPlanColumnModal: 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:CapaSpeedPlanColumnModal) |
| WK-SCP0105-1056 | M4 | MODAL:ShowDialog | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MODAL:ShowDialog: 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ShowDialog) |
| WK-SCP0105-1057 | M4 | `components/CapaSpeedPlanItemPopup.tsx` | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — `components/CapaSpeedPlanItemPopup.tsx`: 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (`components/CapaSpeedPlanItemPopup.tsx`) |
| WK-SCP0105-1058 | M4 | 팝업 OK 후 `BeforeFindData()` (시트 비우고 헤더 재구 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 팝업 OK 후 `BeforeFindData()` (시트 비우고 헤더 재구성): 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (팝업 OK 후 `BeforeFindData()` (시트 비우고 헤더 재구) |
