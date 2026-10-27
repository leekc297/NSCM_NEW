# 작업 원장 — SCP0027 · 2026-10-26 12:53

> 검사 인스턴스 406건 중 PASS·NA 38건 외 **368건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 24 | 구현 위치 실존 |
| W4 | 검사기 구현 | 6 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 30 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 163 | 실행 → PASS |
| W7 | 기대값 확정 | 145 | 기대 확정 → PASS/FAIL |

- 담당: E2E 163 · 사람 판정 / AS-IS 원문 확인 → 재판정 144 · 하네스 36 · 대조표 25
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 2건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-LOC | GEN |  | 24 |  |  |  |  | 20 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| E4 | EDIT |  |  |  |  |  | 38 | 6 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| X-ROW | GEN |  |  |  |  |  |  | 38 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| C3 | CASCADE |  |  |  |  |  | 19 | 7 |  |  | 연쇄 자동 채움 |
| A5 | DESIGN |  |  |  |  |  | 9 | 9 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H2 | DESIGN |  |  |  |  |  | 9 | 9 |  |  | 배경·글자색 규칙 |
| H5 | DESIGN |  |  |  |  |  | 9 | 9 |  |  | 라벨 명칭 |
| D1 | EDIT |  |  |  |  |  | 12 | 5 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 12 | 5 |  |  | 행 값 기반 조건부 잠금 |
| G1 | GEN |  |  |  |  |  | 5 | 11 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| B4 | COMBO |  |  |  |  | 9 |  | 2 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| B3 | COMBO |  |  |  | 6 |  |  | 2 |  |  | 콤보 후보 정렬 = AS-IS |
| C2 | CASCADE |  |  |  |  |  | 6 | 2 |  |  | 그리드 셀 cascade 후보 |
| C6 | CASCADE |  |  |  |  |  | 6 | 2 |  |  | 무변경 편집 종료 시 연쇄 미발동 |
| G4 | DESIGN |  |  |  |  | 1 | 5 |  |  |  | 조회조건 표시·라벨·활성 |
| F4 | DB |  |  |  |  |  | 3 | 3 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| D4 | EDIT |  |  |  |  |  | 2 | 4 |  |  | 신규행 기본값·자동세팅·Insert 전제 |
| D5 | EDIT |  |  |  |  |  | 4 | 2 |  |  | 셀 에디터 유형 |
| E2 | EDIT |  |  |  |  | 4 |  | 1 |  |  | 날짜 형식·유효성 |
| G6 | GEN |  |  |  |  |  | 5 |  |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| C1 | CASCADE |  |  |  |  |  | 4 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| M4 | POPUP |  |  |  |  |  | 2 | 2 |  |  | 팝업 선택값 반영 |
| B1 | COMBO |  |  |  |  | 3 |  |  |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 3 |  |  |  |  | 콤보 후보 중복 없음 |
| DB-SYN | DB |  |  |  |  | 2 |  | 1 |  |  | BE 계정 시노님·권한·대상 객체 |
| E5 | EDIT |  |  |  |  | 3 |  |  |  |  | 콤보 셀 후보 외 값 차단 |
| G5 | POPUP |  |  |  |  | 1 |  | 2 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 1 |  | 2 |  |  | 팝업 표준·열림 |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
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
| E1 | EDIT |  |  |  |  |  | 1 |  |  |  | 숫자 소수자리·정수·부호·범위 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| X-REASON | DESIGN |  |  |  |  |  |  | 1 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |

## W2 구현 위치 확인 (24)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0027-0001 | X-LOC | (자매 SCP0048 R-D6 div=81 SalesSite 셀 팝업) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 ((자매 SCP0048 R-D6 div=81 SalesSite 셀 팝업)) |
| WK-SCP0027-0002 | X-LOC | ALWAYS_LOCK 감사·파생·키 컬럼 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (ALWAYS_LOCK 감사·파생·키 컬럼) |
| WK-SCP0027-0003 | X-LOC | COMMON:UC-02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: SearchArea.tsx 없음, SubTitle.tsx 없음 |  | 1 (COMMON:UC-02) |
| WK-SCP0027-0004 | X-LOC | DIVISION_ID 셀콤보(신규행 MyDivision) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (DIVISION_ID 셀콤보(신규행 MyDivision)) |
| WK-SCP0027-0005 | X-LOC | PLANT_SITE_ID 셀콤보(ElecRoutePlantByOperat | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (PLANT_SITE_ID 셀콤보(ElecRoutePlantByOperat) |
| WK-SCP0027-0006 | X-LOC | R-AUTH 권한 division 0건 → SetDivisionAuthC | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-AUTH 권한 division 0건 → SetDivisionAuthC) |
| WK-SCP0027-0007 | X-LOC | R-COMBO-DIV DIVISION_ID 신규행만 MyDivision | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-COMBO-DIV DIVISION_ID 신규행만 MyDivision) |
| WK-SCP0027-0008 | X-LOC | R-DBLCLICK ITEM_ID 셀 더블클릭 → ElectrodeIte | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-DBLCLICK ITEM_ID 셀 더블클릭 → ElectrodeIte) |
| WK-SCP0027-0009 | X-LOC | R-DIV-CLEAR DIVISION_ID 변경 → PLANT_SITE_ | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-DIV-CLEAR DIVISION_ID 변경 → PLANT_SITE_) |
| WK-SCP0027-0010 | X-LOC | R-EDIT-TOGGLE off → 전셀 잠금 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-EDIT-TOGGLE off → 전셀 잠금) |
| WK-SCP0027-0011 | X-LOC | R-LOCK opGroup=E & PRIORITY_SEQ≠"" 기존행 → | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-LOCK opGroup=E & PRIORITY_SEQ≠"" 기존행 →) |
| WK-SCP0027-0012 | X-LOC | R-LOCK-EXIST-ROW opGroup≠E → PLANT_SITE_ | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-LOCK-EXIST-ROW opGroup≠E → PLANT_SITE_) |
| WK-SCP0027-0013 | X-LOC | R-TACT PLANT_SITE_ID → TACT_TIME_FLAG(표시 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-TACT PLANT_SITE_ID → TACT_TIME_FLAG(표시) |
| WK-SCP0027-0014 | X-LOC | R-VALID VALID_YN 되돌림(opGroup≠E & Y & org | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-VALID VALID_YN 되돌림(opGroup≠E & Y & org) |
| WK-SCP0027-0015 | X-LOC | VALID_YN 셀콤보(YesOrNo) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (VALID_YN 셀콤보(YesOrNo)) |
| WK-SCP0027-0016 | X-LOC | cboOperationGroup (LookupCommon P/A/E, A | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cboOperationGroup (LookupCommon P/A/E, A) |
| WK-SCP0027-0017 | X-LOC | cboValid (YesOrNo, ALL) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cboValid (YesOrNo, ALL)) |
| WK-SCP0027-0018 | X-LOC | clbDivision (`MyDivision`, EE·권한 SQL 내재, | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (clbDivision (`MyDivision`, EE·권한 SQL 내재,) |
| WK-SCP0027-0019 | X-LOC | clbPlantSite (division cascade, 다중선택, AL | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (clbPlantSite (division cascade, 다중선택, AL) |
| WK-SCP0027-0020 | X-LOC | spdMain gridColumns=0 → DB 메타 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (spdMain gridColumns=0 → DB 메타) |
| WK-SCP0027-0021 | X-LOC | spdMain(FpSpread 단일 시트) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (spdMain(FpSpread 단일 시트)) |
| WK-SCP0027-0022 | X-LOC | txtItemId + btnItemId (Model) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (txtItemId + btnItemId (Model)) |
| WK-SCP0027-0023 | X-LOC | usrConditionPanel(HidePanel) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (usrConditionPanel(HidePanel)) |
| WK-SCP0027-0024 | X-LOC | 툴바 Search/Insert/Save/Delete/Excel + Edi | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (툴바 Search/Insert/Save/Delete/Excel + Edi) |

## W4 검사기 구현 (6)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0027-0025 | B3 | OPERATION_GROUP | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 OPERATION_GROUP | 있음(SHEET_COLUMNS) | 2 (cboOperationGroup (LookupCommon P/A/E, A) |
| WK-SCP0027-0026 | B3 | cboOperationGroup / Operation Group / Op | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboOperationGroup / Operation Group / Operation gr | 있음(FE 소스) | 3 (cboOperationGroup (LookupCommon P/A/E, A) |
| WK-SCP0027-0027 | B3 | cboValid / Valid / Active | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboValid / Valid / Active | 있음(FE 소스) | 2 (ACT:SCP0027_ProjectRoute_Electrode.getVa) |
| WK-SCP0027-0028 | B3 | clbDivision / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbDivision / Division | 있음(FE 소스) | 2 (ACT:SCP0027_ProjectRoute_Electrode.getDi) |
| WK-SCP0027-0029 | B3 | clbPlantSite / Plant Site | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbPlantSite / Plant Site | 있음(FE 소스) | 2 (ACT:SCP0027_ProjectRoute_Electrode.getPl) |
| WK-SCP0027-0030 | B3 | txtItemId / Model / Item Id / Model/Nick | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 txtItemId / Model / Item Id / Model/Nickname | 있음(FE 소스) | 2 (ACT:SCP0027_ProjectRoute_Electrode.getIt) |

## W5 검사기 연결 (30)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0027-0031 | B1 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 3 (DIVISION_ID 셀콤보(신규행 MyDivision) COMMON:U) |
| WK-SCP0027-0032 | B1 | PLANT_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL PLANT_SITE_ID | 있음(SHEET_COLUMNS) | 2 (COMMON:UC-05 ACT:SCP0027_ProjectRoute_El) |
| WK-SCP0027-0033 | B1 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0027-0034 | B2 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 3 (DIVISION_ID 셀콤보(신규행 MyDivision) COMMON:U) |
| WK-SCP0027-0035 | B2 | PLANT_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL PLANT_SITE_ID | 있음(SHEET_COLUMNS) | 2 (COMMON:UC-05 ACT:SCP0027_ProjectRoute_El) |
| WK-SCP0027-0036 | B2 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0027-0037 | B4 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 3 (DIVISION_ID 셀콤보(신규행 MyDivision) COMMON:U) |
| WK-SCP0027-0038 | B4 | OPERATION_GROUP | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL OPERATION_GROUP | 있음(SHEET_COLUMNS) | 2 (cboOperationGroup (LookupCommon P/A/E, A) |
| WK-SCP0027-0039 | B4 | PLANT_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL PLANT_SITE_ID | 있음(SHEET_COLUMNS) | 2 (COMMON:UC-05 ACT:SCP0027_ProjectRoute_El) |
| WK-SCP0027-0040 | B4 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0027-0041 | B4 | cboOperationGroup / Operation Group / Op | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboOperationGroup / Operation Group / Operation gr | 있음(FE 소스) | 3 (cboOperationGroup (LookupCommon P/A/E, A) |
| WK-SCP0027-0042 | B4 | cboValid / Valid / Active | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboValid / Valid / Active | 있음(FE 소스) | 2 (ACT:SCP0027_ProjectRoute_Electrode.getVa) |
| WK-SCP0027-0043 | B4 | clbDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbDivision / Division | 있음(FE 소스) | 2 (ACT:SCP0027_ProjectRoute_Electrode.getDi) |
| WK-SCP0027-0044 | B4 | clbPlantSite / Plant Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbPlantSite / Plant Site | 있음(FE 소스) | 2 (ACT:SCP0027_ProjectRoute_Electrode.getPl) |
| WK-SCP0027-0045 | B4 | txtItemId / Model / Item Id / Model/Nick | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND txtItemId / Model / Item Id / Model/Nickname | 있음(FE 소스) | 2 (ACT:SCP0027_ProjectRoute_Electrode.getIt) |
| WK-SCP0027-0046 | F2 | SCP0027 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0027 화면 | 판단불가(대상 단위 SCREEN) | 133 (툴바 Search/Insert/Save/Delete/Excel + Edi) |
| WK-SCP0027-0047 | F6 | SCP0027 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0027 화면 | 판단불가(대상 단위 SCREEN) | 116 (PKG_SCP0027.P_SAVE_ProjectRoute_Electrod) |
| WK-SCP0027-0048 | DB-SYN | PKG_SCP0027 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP PKG_SCP0027 | 없음(PROC_M 대응 없음) | 1 (PKG_SCP0027.P_SAVE_ProjectRoute_Electrod) |
| WK-SCP0027-0049 | DB-SYN | P_DEBUG_MODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DEBUG_MODE | 없음(PROC_M 대응 없음) | 1 (PKG_SCP0027.P_SAVE_ProjectRoute_Electrod) |
| WK-SCP0027-0050 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 있음(FE 소스) | 3 (txtItemId + btnItemId (Model) ACT:SCP002) |
| WK-SCP0027-0051 | E2 | PLANT_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E2(_verify.spec(@verify)) → 대상 COL PLANT_SITE_ID | 있음(SHEET_COLUMNS) | 1 (R-LOCK-EXIST-ROW opGroup≠E → PLANT_SITE_) |
| WK-SCP0027-0052 | E2 | PRIORITY | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E2(_verify.spec(@verify)) → 대상 COL PRIORITY | 있음(SHEET_COLUMNS) | 1 (R-LOCK-EXIST-ROW opGroup≠E → PLANT_SITE_) |
| WK-SCP0027-0053 | E2 | TO_YYYYMMDD | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E2(_verify.spec(@verify)) → 대상 COL TO_YYYYMMDD | 있음(SHEET_COLUMNS) | 1 (R-LOCK-EXIST-ROW opGroup≠E → PLANT_SITE_) |
| WK-SCP0027-0054 | E2 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E2(_verify.spec(@verify)) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 1 (R-LOCK-EXIST-ROW opGroup≠E → PLANT_SITE_) |
| WK-SCP0027-0055 | E5 | DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL DIVISION_ID | 있음(SHEET_COLUMNS) | 2 (DIVISION_ID 셀콤보(신규행 MyDivision) COMMON:U) |
| WK-SCP0027-0056 | E5 | PLANT_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL PLANT_SITE_ID | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0027-0057 | E5 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0027-0058 | G03-WIRE | SCP0027 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0027 화면 | 판단불가(대상 단위 SCREEN) | 17 (ACT:SCP0027_ProjectRoute_Electrode..ctor) |
| WK-SCP0027-0059 | G5 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 15 (R-DBLCLICK ITEM_ID 셀 더블클릭 → ElectrodeIte) |
| WK-SCP0027-0060 | H6 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 15 (R-DBLCLICK ITEM_ID 셀 더블클릭 → ElectrodeIte) |

## W6 검증 실행 (163)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0027-0061 | J2 | SCP0027 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0027 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 50 (툴바 Search/Insert/Save/Delete/Excel + Edi) |
| WK-SCP0027-0062 | C1 | cboOperationGroup / Operation Group / Op | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboOperationGroup / Operation Group / Operation gr · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0027_ProjectRoute_Electrode.InitC) |
| WK-SCP0027-0063 | C1 | cboValid / Valid / Active | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboValid / Valid / Active · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0027_ProjectRoute_Electrode.InitC) |
| WK-SCP0027-0064 | C1 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0027_ProjectRoute_Electrode.InitC) |
| WK-SCP0027-0065 | C1 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0027_ProjectRoute_Electrode.SetCh) |
| WK-SCP0027-0066 | C2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-DIV-CLEAR DIVISION_ID 변경 → PLANT_SITE_) |
| WK-SCP0027-0067 | C2 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-DIV-CLEAR DIVISION_ID 변경 → PLANT_SITE_) |
| WK-SCP0027-0068 | C2 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-DIV-CLEAR DIVISION_ID 변경 → PLANT_SITE_) |
| WK-SCP0027-0069 | C2 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (R-TACT PLANT_SITE_ID → TACT_TIME_FLAG(표시) |
| WK-SCP0027-0070 | C2 | TACT_TIME_FLAG | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — TACT_TIME_FLAG · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-TACT PLANT_SITE_ID → TACT_TIME_FLAG(표시) |
| WK-SCP0027-0071 | C2 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-VALID VALID_YN 되돌림(opGroup≠E & Y & org) |
| WK-SCP0027-0072 | C3 | ACTION_FLAG_DIV | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ACTION_FLAG_DIV · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0027_ProjectRoute_Electrode.set_V) |
| WK-SCP0027-0073 | C3 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 8 (R-DIV-CLEAR DIVISION_ID 변경 → PLANT_SITE_) |
| WK-SCP0027-0074 | C3 | FROM_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — FROM_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0027_ProjectRoute_Electrode.SetOr) |
| WK-SCP0027-0075 | C3 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 17 (R-DIV-CLEAR DIVISION_ID 변경 → PLANT_SITE_) |
| WK-SCP0027-0076 | C3 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (R-DIV-CLEAR DIVISION_ID 변경 → PLANT_SITE_) |
| WK-SCP0027-0077 | C3 | OPERATION_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — OPERATION_GROUP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0027_ProjectRoute_Electrode.set_V) |
| WK-SCP0027-0078 | C3 | ORG_FROM_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ORG_FROM_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0027_ProjectRoute_Electrode.SetOr) |
| WK-SCP0027-0079 | C3 | ORG_TO_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ORG_TO_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0027_ProjectRoute_Electrode.SetOr) |
| WK-SCP0027-0080 | C3 | ORG_VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ORG_VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SCP0027_ProjectRoute_Electrode.set_V) |
| WK-SCP0027-0081 | C3 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 17 (R-TACT PLANT_SITE_ID → TACT_TIME_FLAG(표시) |
| WK-SCP0027-0082 | C3 | PLANT_SITE_ID_B | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PLANT_SITE_ID_B · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0027_ProjectRoute_Electrode.set_V) |
| WK-SCP0027-0083 | C3 | PRIORITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PRIORITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0027_ProjectRoute_Electrode.set_V) |
| WK-SCP0027-0084 | C3 | PRIORITY_SEQ | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PRIORITY_SEQ · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 6 (ACT:SCP0027_ProjectRoute_Electrode.set_V) |
| WK-SCP0027-0085 | C3 | PROJECT_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PROJECT_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0027_ProjectRoute_Electrode.set_V) |
| WK-SCP0027-0086 | C3 | ROW_COLOR_INDEX | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ROW_COLOR_INDEX · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0027_ProjectRoute_Electrode.set_V) |
| WK-SCP0027-0087 | C3 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0027_ProjectRoute_Electrode.set_V) |
| WK-SCP0027-0088 | C3 | TACT_TIME_FLAG | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — TACT_TIME_FLAG · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (R-TACT PLANT_SITE_ID → TACT_TIME_FLAG(표시) |
| WK-SCP0027-0089 | C3 | TO_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — TO_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0027_ProjectRoute_Electrode.SetOr) |
| WK-SCP0027-0090 | C3 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 5 (R-VALID VALID_YN 되돌림(opGroup≠E & Y & org) |
| WK-SCP0027-0091 | C6 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-DIV-CLEAR DIVISION_ID 변경 → PLANT_SITE_) |
| WK-SCP0027-0092 | C6 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-DIV-CLEAR DIVISION_ID 변경 → PLANT_SITE_) |
| WK-SCP0027-0093 | C6 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-DIV-CLEAR DIVISION_ID 변경 → PLANT_SITE_) |
| WK-SCP0027-0094 | C6 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (R-TACT PLANT_SITE_ID → TACT_TIME_FLAG(표시) |
| WK-SCP0027-0095 | C6 | TACT_TIME_FLAG | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — TACT_TIME_FLAG · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-TACT PLANT_SITE_ID → TACT_TIME_FLAG(표시) |
| WK-SCP0027-0096 | C6 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-VALID VALID_YN 되돌림(opGroup≠E & Y & org) |
| WK-SCP0027-0097 | G3 | SCP0027 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0027 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 6 (usrConditionPanel(HidePanel) COMMON:UC-0) |
| WK-SCP0027-0098 | K-SA | SCP0027 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCP0027 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 2 (usrConditionPanel(HidePanel) COMMON:UC-0) |
| WK-SCP0027-0099 | K4 | SCP0027 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0027 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 17 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-04 C) |
| WK-SCP0027-0100 | F1 | SCP0027 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0027 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 143 (툴바 Search/Insert/Save/Delete/Excel + Edi) |
| WK-SCP0027-0101 | F3 | SCP0027 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F3 실행 — SCP0027 화면 · 검사기 있음(_trace.spec(@trace) W4b 붙여넣기 — Ctrl+C/Ctrl+V 로 셀 값 복사 후 값·연쇄) — 실행 필요: trace |  | 13 (ACT:SCP0027_ProjectRoute_Electrode.SpdMa) |
| WK-SCP0027-0102 | F5 | SCP0027 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0027 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 12 (툴바 Search/Insert/Save/Delete/Excel + Edi) |
| WK-SCP0027-0103 | F4 | PKG_SCP0027 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0027 · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (PKG_SCP0027.P_SAVE_ProjectRoute_Electrod) |
| WK-SCP0027-0104 | F4 | PKG_SCP0027.P_SCP0027_SAVE_PROJECTROUTE_ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0027.P_SCP0027_SAVE_PROJECTROUTE_ELECTRODE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) |  | 115 (ACT:SCP0027_ProjectRoute_Electrode.SaveB) |
| WK-SCP0027-0105 | F4 | P_DEBUG_MODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DEBUG_MODE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (PKG_SCP0027.P_SAVE_ProjectRoute_Electrod) |
| WK-SCP0027-0106 | A5 | DIVISION_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (DIVISION_ID 셀콤보(신규행 MyDivision) R-COMBO-) |
| WK-SCP0027-0107 | A5 | ITEM_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 6 (R-DIV-CLEAR DIVISION_ID 변경 → PLANT_SITE_) |
| WK-SCP0027-0108 | A5 | NICK_NAME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (R-DIV-CLEAR DIVISION_ID 변경 → PLANT_SITE_) |
| WK-SCP0027-0109 | A5 | PLANT_SITE_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 5 (PLANT_SITE_ID 셀콤보(ElecRoutePlantByOperat) |
| WK-SCP0027-0110 | A5 | PRIORITY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PRIORITY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (R-LOCK-EXIST-ROW opGroup≠E → PLANT_SITE_) |
| WK-SCP0027-0111 | A5 | PRIORITY_SEQ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PRIORITY_SEQ · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (R-LOCK opGroup=E & PRIORITY_SEQ≠"" 기존행 →) |
| WK-SCP0027-0112 | A5 | TACT_TIME_FLAG | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — TACT_TIME_FLAG · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (R-TACT PLANT_SITE_ID → TACT_TIME_FLAG(표시) |
| WK-SCP0027-0113 | A5 | TO_YYYYMMDD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — TO_YYYYMMDD · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (R-LOCK-EXIST-ROW opGroup≠E → PLANT_SITE_) |
| WK-SCP0027-0114 | A5 | VALID_YN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (VALID_YN 셀콤보(YesOrNo) R-VALID VALID_YN 되) |
| WK-SCP0027-0115 | G4 | cboOperationGroup / Operation Group / Op | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboOperationGroup / Operation Group / Operation gr · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (cboOperationGroup (LookupCommon P/A/E, A) |
| WK-SCP0027-0116 | G4 | cboValid / Valid / Active | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboValid / Valid / Active · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (cboValid (YesOrNo, ALL) ACT:SCP0027_Proj) |
| WK-SCP0027-0117 | G4 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (clbDivision (`MyDivision`, EE·권한 SQL 내재,) |
| WK-SCP0027-0118 | G4 | clbPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbPlantSite / Plant Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (clbPlantSite (division cascade, 다중선택, AL) |
| WK-SCP0027-0119 | G4 | txtItemId / Model / Item Id / Model/Nick | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (txtItemId + btnItemId (Model)) |
| WK-SCP0027-0120 | H2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (DIVISION_ID 셀콤보(신규행 MyDivision) R-COMBO-) |
| WK-SCP0027-0121 | H2 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (R-DIV-CLEAR DIVISION_ID 변경 → PLANT_SITE_) |
| WK-SCP0027-0122 | H2 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-DIV-CLEAR DIVISION_ID 변경 → PLANT_SITE_) |
| WK-SCP0027-0123 | H2 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (PLANT_SITE_ID 셀콤보(ElecRoutePlantByOperat) |
| WK-SCP0027-0124 | H2 | PRIORITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PRIORITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-LOCK-EXIST-ROW opGroup≠E → PLANT_SITE_) |
| WK-SCP0027-0125 | H2 | PRIORITY_SEQ | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PRIORITY_SEQ · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-LOCK opGroup=E & PRIORITY_SEQ≠"" 기존행 →) |
| WK-SCP0027-0126 | H2 | TACT_TIME_FLAG | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — TACT_TIME_FLAG · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-TACT PLANT_SITE_ID → TACT_TIME_FLAG(표시) |
| WK-SCP0027-0127 | H2 | TO_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — TO_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-LOCK-EXIST-ROW opGroup≠E → PLANT_SITE_) |
| WK-SCP0027-0128 | H2 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (VALID_YN 셀콤보(YesOrNo) R-VALID VALID_YN 되) |
| WK-SCP0027-0129 | H5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — DIVISION_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (DIVISION_ID 셀콤보(신규행 MyDivision) R-COMBO-) |
| WK-SCP0027-0130 | H5 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ITEM_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 5 (R-DIV-CLEAR DIVISION_ID 변경 → PLANT_SITE_) |
| WK-SCP0027-0131 | H5 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — NICK_NAME · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (R-DIV-CLEAR DIVISION_ID 변경 → PLANT_SITE_) |
| WK-SCP0027-0132 | H5 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PLANT_SITE_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 5 (PLANT_SITE_ID 셀콤보(ElecRoutePlantByOperat) |
| WK-SCP0027-0133 | H5 | PRIORITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PRIORITY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (R-LOCK-EXIST-ROW opGroup≠E → PLANT_SITE_) |
| WK-SCP0027-0134 | H5 | PRIORITY_SEQ | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PRIORITY_SEQ · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (R-LOCK opGroup=E & PRIORITY_SEQ≠"" 기존행 →) |
| WK-SCP0027-0135 | H5 | TACT_TIME_FLAG | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — TACT_TIME_FLAG · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (R-TACT PLANT_SITE_ID → TACT_TIME_FLAG(표시) |
| WK-SCP0027-0136 | H5 | TO_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — TO_YYYYMMDD · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (R-LOCK-EXIST-ROW opGroup≠E → PLANT_SITE_) |
| WK-SCP0027-0137 | H5 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — VALID_YN · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (VALID_YN 셀콤보(YesOrNo) R-VALID VALID_YN 되) |
| WK-SCP0027-0138 | I1 | SCP0027 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0027 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 29 (R-AUTH 권한 division 0건 → SetDivisionAuthC) |
| WK-SCP0027-0139 | SC1 | SCP0027 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SCP0027 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 5 (clbDivision (`MyDivision`, EE·권한 SQL 내재,) |
| WK-SCP0027-0140 | D1 | CREATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CREATED_BY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SCP0027_ProjectRoute_Electrode.EditB) |
| WK-SCP0027-0141 | D1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (R-COMBO-DIV DIVISION_ID 신규행만 MyDivision ) |
| WK-SCP0027-0142 | D1 | LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SCP0027_ProjectRoute_Electrode.EditB) |
| WK-SCP0027-0143 | D1 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SCP0027_ProjectRoute_Electrode.EditB) |
| WK-SCP0027-0144 | D1 | OPERATION_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — OPERATION_GROUP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 7 (ACT:SCP0027_ProjectRoute_Electrode.EditB) |
| WK-SCP0027-0145 | D1 | OPERATION_GROUP_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — OPERATION_GROUP_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SCP0027_ProjectRoute_Electrode.Inser) |
| WK-SCP0027-0146 | D1 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 5 (R-LOCK-EXIST-ROW opGroup≠E → PLANT_SITE_) |
| WK-SCP0027-0147 | D1 | PRIORITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PRIORITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (R-LOCK-EXIST-ROW opGroup≠E → PLANT_SITE_) |
| WK-SCP0027-0148 | D1 | PRIORITY_SEQ | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PRIORITY_SEQ · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (R-LOCK opGroup=E & PRIORITY_SEQ≠"" 기존행 →) |
| WK-SCP0027-0149 | D1 | TACT_TIME_FLAG | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — TACT_TIME_FLAG · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SCP0027_ProjectRoute_Electrode.EditB) |
| WK-SCP0027-0150 | D1 | TO_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — TO_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (R-LOCK-EXIST-ROW opGroup≠E → PLANT_SITE_) |
| WK-SCP0027-0151 | D1 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (R-LOCK-EXIST-ROW opGroup≠E → PLANT_SITE_) |
| WK-SCP0027-0152 | D3 | CREATED_BY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CREATED_BY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SCP0027_ProjectRoute_Electrode.EditB) |
| WK-SCP0027-0153 | D3 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (R-COMBO-DIV DIVISION_ID 신규행만 MyDivision ) |
| WK-SCP0027-0154 | D3 | LAST_UPDATE_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LAST_UPDATE_DATE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SCP0027_ProjectRoute_Electrode.EditB) |
| WK-SCP0027-0155 | D3 | NICK_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — NICK_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SCP0027_ProjectRoute_Electrode.EditB) |
| WK-SCP0027-0156 | D3 | OPERATION_GROUP | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — OPERATION_GROUP · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 7 (ACT:SCP0027_ProjectRoute_Electrode.EditB) |
| WK-SCP0027-0157 | D3 | OPERATION_GROUP_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — OPERATION_GROUP_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SCP0027_ProjectRoute_Electrode.Inser) |
| WK-SCP0027-0158 | D3 | PLANT_SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PLANT_SITE_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 5 (R-LOCK-EXIST-ROW opGroup≠E → PLANT_SITE_) |
| WK-SCP0027-0159 | D3 | PRIORITY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PRIORITY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (R-LOCK-EXIST-ROW opGroup≠E → PLANT_SITE_) |
| WK-SCP0027-0160 | D3 | PRIORITY_SEQ | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PRIORITY_SEQ · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (R-LOCK opGroup=E & PRIORITY_SEQ≠"" 기존행 →) |
| WK-SCP0027-0161 | D3 | TACT_TIME_FLAG | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — TACT_TIME_FLAG · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SCP0027_ProjectRoute_Electrode.EditB) |
| WK-SCP0027-0162 | D3 | TO_YYYYMMDD | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — TO_YYYYMMDD · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (R-LOCK-EXIST-ROW opGroup≠E → PLANT_SITE_) |
| WK-SCP0027-0163 | D3 | VALID_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — VALID_YN · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (R-LOCK-EXIST-ROW opGroup≠E → PLANT_SITE_) |
| WK-SCP0027-0164 | D4 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (DIVISION_ID 셀콤보(신규행 MyDivision)) |
| WK-SCP0027-0165 | D4 | PRIORITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — PRIORITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (Insert(신규행, opGroup P/A silent 차단, 6종 기본) |
| WK-SCP0027-0166 | D5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (DIVISION_ID 셀콤보(신규행 MyDivision) COMMON:U) |
| WK-SCP0027-0167 | D5 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCP0027_ProjectRoute_Electrode.SetIm) |
| WK-SCP0027-0168 | D5 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (COMMON:UC-05 ACT:SCP0027_ProjectRoute_El) |
| WK-SCP0027-0169 | D5 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (COMMON:UC-05) |
| WK-SCP0027-0170 | D6 | SCP0027 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0027 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 7 (툴바 Search/Insert/Save/Delete/Excel + Edi) |
| WK-SCP0027-0171 | E1 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 2 (ACT:SCP0027_ProjectRoute_Electrode.SpdMa) |
| WK-SCP0027-0172 | E4 | ACTION_FLAG_DIV | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ACTION_FLAG_DIV · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0027_ProjectRoute_Electrode.set_V) |
| WK-SCP0027-0173 | E4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SCP0027_ProjectRoute_Electrode.SetCh) |
| WK-SCP0027-0174 | E4 | FROM_YYYYMMDD | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — FROM_YYYYMMDD · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0027_ProjectRoute_Electrode.SetOr) |
| WK-SCP0027-0175 | E4 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 6 (MSG00257 ACT:SCP0027_ProjectRoute_Electr) |
| WK-SCP0027-0176 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0027_ProjectRoute_Electrode.SaveD) |
| WK-SCP0027-0177 | E4 | MSG00006 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00006 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0027_ProjectRoute_Electrode.SaveD) |
| WK-SCP0027-0178 | E4 | MSG00048 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00048 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00048/MSG00219 ACT:SCP0027_ProjectRou) |
| WK-SCP0027-0179 | E4 | MSG00093 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00093 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0027_ProjectRoute_Electrode.SpdMa) |
| WK-SCP0027-0180 | E4 | MSG00097 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00097 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (R-AUTH 권한 division 0건 → SetDivisionAuthC) |
| WK-SCP0027-0181 | E4 | MSG00107 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00107 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00107 ACT:SCP0027_ProjectRoute_Electr) |
| WK-SCP0027-0182 | E4 | MSG00211 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00211 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (R-VALID VALID_YN 되돌림(opGroup≠E & Y & org) |
| WK-SCP0027-0183 | E4 | MSG00212 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00212 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00212 ACT:SCP0027_ProjectRoute_Electr) |
| WK-SCP0027-0184 | E4 | MSG00213 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00213 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00213 ACT:SCP0027_ProjectRoute_Electr) |
| WK-SCP0027-0185 | E4 | MSG00214 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00214 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00214 ACT:SCP0027_ProjectRoute_Electr) |
| WK-SCP0027-0186 | E4 | MSG00215 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00215 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00215 ACT:SCP0027_ProjectRoute_Electr) |
| WK-SCP0027-0187 | E4 | MSG00216 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00216 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00216 ACT:SCP0027_ProjectRoute_Electr) |
| WK-SCP0027-0188 | E4 | MSG00217 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00217 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00217 ACT:SCP0027_ProjectRoute_Electr) |
| WK-SCP0027-0189 | E4 | MSG00219 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00219 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00048/MSG00219 ACT:SCP0027_ProjectRou) |
| WK-SCP0027-0190 | E4 | MSG00220 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00220 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00220 ACT:SCP0027_ProjectRoute_Electr) |
| WK-SCP0027-0191 | E4 | MSG00257 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00257 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00257 ACT:SCP0027_ProjectRoute_Electr) |
| WK-SCP0027-0192 | E4 | MSG00259 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00259 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0027_ProjectRoute_Electrode.EditB) |
| WK-SCP0027-0193 | E4 | MSG00703 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00703 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-02) |
| WK-SCP0027-0194 | E4 | MSG00704 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00704 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-02) |
| WK-SCP0027-0195 | E4 | MSG01222 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01222 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (R-VALID VALID_YN 되돌림(opGroup≠E & Y & org) |
| WK-SCP0027-0196 | E4 | OPERATION_GROUP | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — OPERATION_GROUP · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0027_ProjectRoute_Electrode.set_V) |
| WK-SCP0027-0197 | E4 | ORG_FROM_YYYYMMDD | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ORG_FROM_YYYYMMDD · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SCP0027_ProjectRoute_Electrode.SetOr) |
| WK-SCP0027-0198 | E4 | ORG_TO_YYYYMMDD | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ORG_TO_YYYYMMDD · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SCP0027_ProjectRoute_Electrode.SetOr) |
| WK-SCP0027-0199 | E4 | ORG_VALID_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ORG_VALID_YN · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SCP0027_ProjectRoute_Electrode.set_V) |
| WK-SCP0027-0200 | E4 | PLANT_SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — PLANT_SITE_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (ACT:SCP0027_ProjectRoute_Electrode.SpdMa) |
| WK-SCP0027-0201 | E4 | PLANT_SITE_ID_B | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — PLANT_SITE_ID_B · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0027_ProjectRoute_Electrode.set_V) |
| WK-SCP0027-0202 | E4 | PRIORITY | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — PRIORITY · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0027_ProjectRoute_Electrode.set_V) |
| WK-SCP0027-0203 | E4 | PRIORITY_SEQ | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — PRIORITY_SEQ · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 6 (ACT:SCP0027_ProjectRoute_Electrode.set_V) |
| WK-SCP0027-0204 | E4 | PROJECT_CODE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — PROJECT_CODE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0027_ProjectRoute_Electrode.set_V) |
| WK-SCP0027-0205 | E4 | ROW_COLOR_INDEX | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ROW_COLOR_INDEX · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0027_ProjectRoute_Electrode.set_V) |
| WK-SCP0027-0206 | E4 | SCM_SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — SCM_SITE_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0027_ProjectRoute_Electrode.set_V) |
| WK-SCP0027-0207 | E4 | TO_YYYYMMDD | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — TO_YYYYMMDD · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0027_ProjectRoute_Electrode.SetOr) |
| WK-SCP0027-0208 | E4 | VALID_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — VALID_YN · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (R-VALID VALID_YN 되돌림(opGroup≠E & Y & org) |
| WK-SCP0027-0209 | E4 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실 |  | 2 (ACT:SCP0027_ProjectRoute_Electrode.SetCh) |
| WK-SCP0027-0210 | A10 | SCP0027 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0027 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 35 (ACT:SCP0027_ProjectRoute_Electrode.Defin) |
| WK-SCP0027-0211 | G1 | cboOperationGroup / Operation Group / Op | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboOperationGroup / Operation Group / Operation gr · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (cboOperationGroup (LookupCommon P/A/E, A) |
| WK-SCP0027-0212 | G1 | cboValid / Valid / Active | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboValid / Valid / Active · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (cboValid (YesOrNo, ALL)) |
| WK-SCP0027-0213 | G1 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (clbDivision (`MyDivision`, EE·권한 SQL 내재,) |
| WK-SCP0027-0214 | G1 | clbPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbPlantSite / Plant Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (clbPlantSite (division cascade, 다중선택, AL) |
| WK-SCP0027-0215 | G1 | txtItemId / Model / Item Id / Model/Nick | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (txtItemId + btnItemId (Model)) |
| WK-SCP0027-0216 | G6 | cboOperationGroup / Operation Group / Op | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboOperationGroup / Operation Group / Operation gr · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (cboOperationGroup (LookupCommon P/A/E, A) |
| WK-SCP0027-0217 | G6 | cboValid / Valid / Active | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboValid / Valid / Active · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (cboValid (YesOrNo, ALL) ACT:SCP0027_Proj) |
| WK-SCP0027-0218 | G6 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (clbDivision (`MyDivision`, EE·권한 SQL 내재,) |
| WK-SCP0027-0219 | G6 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (clbPlantSite (division cascade, 다중선택, AL) |
| WK-SCP0027-0220 | G6 | txtItemId / Model / Item Id / Model/Nick | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (txtItemId + btnItemId (Model)) |
| WK-SCP0027-0221 | X-REOPEN | SCP0027 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0027 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 5 (ACT:SCP0027_ProjectRoute_Electrode.Dispo) |
| WK-SCP0027-0222 | M4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (ACT:SCP0027_ProjectRoute_Electrode.spdMa) |
| WK-SCP0027-0223 | M4 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 15 (R-DBLCLICK ITEM_ID 셀 더블클릭 → ElectrodeIte) |

## W7 기대값 확정 (145)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0027-0224 | C2 | SCP0027_ProjectRoute_Electrode.ClbDivisi | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0027_ProjectRoute_Electrode.ClbDivision_Selecte: 진입점 집계 — C2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0027_ProjectRoute_Electrode.ClbDi) |
| WK-SCP0027-0225 | C2 | SCP0027_ProjectRoute_Electrode.cboOperat | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0027_ProjectRoute_Electrode.cboOperationGroup_S: 진입점 집계 — C2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0027_ProjectRoute_Electrode.cboOp) |
| WK-SCP0027-0226 | C3 | SCP0027_ProjectRoute_Electrode.ClbDivisi | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0027_ProjectRoute_Electrode.ClbDivision_Selecte: 진입점 집계 — C3 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0027_ProjectRoute_Electrode.ClbDi) |
| WK-SCP0027-0227 | C3 | SCP0027_ProjectRoute_Electrode.SetChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0027_ProjectRoute_Electrode.SetChangedControl: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0027_ProjectRoute_Electrode.SetCh) |
| WK-SCP0027-0228 | C3 | SCP0027_ProjectRoute_Electrode.SetChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0027_ProjectRoute_Electrode.SetChangedPeriod: 진입점 집계 — C3 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0027_ProjectRoute_Electrode.SetCh) |
| WK-SCP0027-0229 | C3 | SCP0027_ProjectRoute_Electrode.SetImageC | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0027_ProjectRoute_Electrode.SetImageCell: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0027_ProjectRoute_Electrode.SetIm) |
| WK-SCP0027-0230 | C3 | SCP0027_ProjectRoute_Electrode.SetOrgDat | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0027_ProjectRoute_Electrode.SetOrgData: 진입점 집계 — C3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0027_ProjectRoute_Electrode.SetOr) |
| WK-SCP0027-0231 | C3 | SCP0027_ProjectRoute_Electrode.cboOperat | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0027_ProjectRoute_Electrode.cboOperationGroup_S: 진입점 집계 — C3 19요소: NOT_RUN:19 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0027_ProjectRoute_Electrode.cboOp) |
| WK-SCP0027-0232 | C3 | SCP0027_ProjectRoute_Electrode.set_Valid | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0027_ProjectRoute_Electrode.set_ValidDataSet: 진입점 집계 — C3 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 11 (ACT:SCP0027_ProjectRoute_Electrode.set_V) |
| WK-SCP0027-0233 | C6 | SCP0027_ProjectRoute_Electrode.ClbDivisi | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0027_ProjectRoute_Electrode.ClbDivision_Selecte: 진입점 집계 — C6 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0027_ProjectRoute_Electrode.ClbDi) |
| WK-SCP0027-0234 | C6 | SCP0027_ProjectRoute_Electrode.cboOperat | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0027_ProjectRoute_Electrode.cboOperationGroup_S: 진입점 집계 — C6 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0027_ProjectRoute_Electrode.cboOp) |
| WK-SCP0027-0235 | B3 | SCP0027_ProjectRoute_Electrode.getCellVa | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0027_ProjectRoute_Electrode.getCellValue: 진입점 집계 — B3 6요소: TODO:6 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0027_ProjectRoute_Electrode.getCe) |
| WK-SCP0027-0236 | B3 | SCP0027_ProjectRoute_Electrode.getValid | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0027_ProjectRoute_Electrode.getValid: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0027_ProjectRoute_Electrode.getVa) |
| WK-SCP0027-0237 | B4 | SCP0027_ProjectRoute_Electrode.getCellVa | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0027_ProjectRoute_Electrode.getCellValue: 진입점 집계 — B4 9요소: NOPATH:9 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0027_ProjectRoute_Electrode.getCe) |
| WK-SCP0027-0238 | B4 | SCP0027_ProjectRoute_Electrode.getValid | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0027_ProjectRoute_Electrode.getValid: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0027_ProjectRoute_Electrode.getVa) |
| WK-SCP0027-0239 | DB-SYN | SCP0027_ProjectRoute_Electrode.FindDataM | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SCP0027_ProjectRoute_Electrode.FindDataMain: 진입점 집계 — DB-SYN 3요소: NOPATH:2 · PASS:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0027_ProjectRoute_Electrode.FindD) |
| WK-SCP0027-0240 | F4 | SCP0027_ProjectRoute_Electrode.FindButto | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0027_ProjectRoute_Electrode.FindButton: 진입점 집계 — F4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0027_ProjectRoute_Electrode.FindB) |
| WK-SCP0027-0241 | F4 | SCP0027_ProjectRoute_Electrode.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0027_ProjectRoute_Electrode.FindData: 진입점 집계 — F4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0027_ProjectRoute_Electrode.FindD) |
| WK-SCP0027-0242 | F4 | SCP0027_ProjectRoute_Electrode.FindDataM | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0027_ProjectRoute_Electrode.FindDataMain: 진입점 집계 — F4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SCP0027_ProjectRoute_Electrode.FindD) |
| WK-SCP0027-0243 | A5 | (자매 SCP0048 R-D6 div=81 SalesSite 셀 팝업) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — (자매 SCP0048 R-D6 div=81 SalesSite 셀 팝업): 행 집계 — A5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 ((자매 SCP0048 R-D6 div=81 SalesSite 셀 팝업)) |
| WK-SCP0027-0244 | A5 | ALWAYS_LOCK 감사·파생·키 컬럼 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — ALWAYS_LOCK 감사·파생·키 컬럼: 행 집계 — A5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (ALWAYS_LOCK 감사·파생·키 컬럼) |
| WK-SCP0027-0245 | A5 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-02: 행 집계 — A5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0027-0246 | A5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-07: 행 집계 — A5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0027-0247 | A5 | R-EDIT-TOGGLE off → 전셀 잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-EDIT-TOGGLE off → 전셀 잠금: 행 집계 — A5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (R-EDIT-TOGGLE off → 전셀 잠금) |
| WK-SCP0027-0248 | A5 | SCP0027_ProjectRoute_Electrode.CreateSpr | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0027_ProjectRoute_Electrode.CreateSpread: 진입점 집계 — A5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0027_ProjectRoute_Electrode.Creat) |
| WK-SCP0027-0249 | A5 | SCP0027_ProjectRoute_Electrode.SetImageC | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0027_ProjectRoute_Electrode.SetImageCell: 진입점 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0027_ProjectRoute_Electrode.SetIm) |
| WK-SCP0027-0250 | A5 | spdMain gridColumns=0 → DB 메타 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — spdMain gridColumns=0 → DB 메타: 행 집계 — A5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (spdMain gridColumns=0 → DB 메타) |
| WK-SCP0027-0251 | A5 | spdMain(FpSpread 단일 시트) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — spdMain(FpSpread 단일 시트): 행 집계 — A5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (spdMain(FpSpread 단일 시트)) |
| WK-SCP0027-0252 | H2 | (자매 SCP0048 R-D6 div=81 SalesSite 셀 팝업) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — (자매 SCP0048 R-D6 div=81 SalesSite 셀 팝업): 행 집계 — H2 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 ((자매 SCP0048 R-D6 div=81 SalesSite 셀 팝업)) |
| WK-SCP0027-0253 | H2 | ALWAYS_LOCK 감사·파생·키 컬럼 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — ALWAYS_LOCK 감사·파생·키 컬럼: 행 집계 — H2 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (ALWAYS_LOCK 감사·파생·키 컬럼) |
| WK-SCP0027-0254 | H2 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-02: 행 집계 — H2 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0027-0255 | H2 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-07: 행 집계 — H2 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0027-0256 | H2 | R-EDIT-TOGGLE off → 전셀 잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-EDIT-TOGGLE off → 전셀 잠금: 행 집계 — H2 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (R-EDIT-TOGGLE off → 전셀 잠금) |
| WK-SCP0027-0257 | H2 | SCP0027_ProjectRoute_Electrode.CreateSpr | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0027_ProjectRoute_Electrode.CreateSpread: 진입점 집계 — H2 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0027_ProjectRoute_Electrode.Creat) |
| WK-SCP0027-0258 | H2 | SCP0027_ProjectRoute_Electrode.SetImageC | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0027_ProjectRoute_Electrode.SetImageCell: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0027_ProjectRoute_Electrode.SetIm) |
| WK-SCP0027-0259 | H2 | spdMain gridColumns=0 → DB 메타 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — spdMain gridColumns=0 → DB 메타: 행 집계 — H2 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (spdMain gridColumns=0 → DB 메타) |
| WK-SCP0027-0260 | H2 | spdMain(FpSpread 단일 시트) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — spdMain(FpSpread 단일 시트): 행 집계 — H2 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (spdMain(FpSpread 단일 시트)) |
| WK-SCP0027-0261 | H5 | (자매 SCP0048 R-D6 div=81 SalesSite 셀 팝업) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — (자매 SCP0048 R-D6 div=81 SalesSite 셀 팝업): 행 집계 — H5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 ((자매 SCP0048 R-D6 div=81 SalesSite 셀 팝업)) |
| WK-SCP0027-0262 | H5 | ALWAYS_LOCK 감사·파생·키 컬럼 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — ALWAYS_LOCK 감사·파생·키 컬럼: 행 집계 — H5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (ALWAYS_LOCK 감사·파생·키 컬럼) |
| WK-SCP0027-0263 | H5 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-02: 행 집계 — H5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0027-0264 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0027-0265 | H5 | R-EDIT-TOGGLE off → 전셀 잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-EDIT-TOGGLE off → 전셀 잠금: 행 집계 — H5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (R-EDIT-TOGGLE off → 전셀 잠금) |
| WK-SCP0027-0266 | H5 | SCP0027_ProjectRoute_Electrode.CreateSpr | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0027_ProjectRoute_Electrode.CreateSpread: 진입점 집계 — H5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0027_ProjectRoute_Electrode.Creat) |
| WK-SCP0027-0267 | H5 | SCP0027_ProjectRoute_Electrode.SetImageC | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0027_ProjectRoute_Electrode.SetImageCell: 진입점 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0027_ProjectRoute_Electrode.SetIm) |
| WK-SCP0027-0268 | H5 | spdMain gridColumns=0 → DB 메타 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — spdMain gridColumns=0 → DB 메타: 행 집계 — H5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (spdMain gridColumns=0 → DB 메타) |
| WK-SCP0027-0269 | H5 | spdMain(FpSpread 단일 시트) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — spdMain(FpSpread 단일 시트): 행 집계 — H5 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (spdMain(FpSpread 단일 시트)) |
| WK-SCP0027-0270 | X-REASON | COMMON:UC-06 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-06 Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) — 해당없음: 조회조건 Model 은 단일 품번 픽커(ItemByDivisionModal, call |  | 1 (COMMON:UC-06) |
| WK-SCP0027-0271 | D1 | ALWAYS_LOCK 감사·파생·키 컬럼 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — ALWAYS_LOCK 감사·파생·키 컬럼: 행 집계 — D1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (ALWAYS_LOCK 감사·파생·키 컬럼) |
| WK-SCP0027-0272 | D1 | Edit 토글(SwitchLock, R-EDIT) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — Edit 토글(SwitchLock, R-EDIT): 행 집계 — D1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (Edit 토글(SwitchLock, R-EDIT)) |
| WK-SCP0027-0273 | D1 | R-EDIT-TOGGLE off → 전셀 잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — R-EDIT-TOGGLE off → 전셀 잠금: 행 집계 — D1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (R-EDIT-TOGGLE off → 전셀 잠금) |
| WK-SCP0027-0274 | D1 | SCP0027_ProjectRoute_Electrode.EditButto | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SCP0027_ProjectRoute_Electrode.EditButton: 진입점 집계 — D1 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0027_ProjectRoute_Electrode.EditB) |
| WK-SCP0027-0275 | D1 | 툴바 Search/Insert/Save/Delete/Excel + Edi | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 툴바 Search/Insert/Save/Delete/Excel + Edit 토글(Switc: 행 집계 — D1 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (툴바 Search/Insert/Save/Delete/Excel + Edi) |
| WK-SCP0027-0276 | D3 | ALWAYS_LOCK 감사·파생·키 컬럼 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — ALWAYS_LOCK 감사·파생·키 컬럼: 행 집계 — D3 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (ALWAYS_LOCK 감사·파생·키 컬럼) |
| WK-SCP0027-0277 | D3 | Edit 토글(SwitchLock, R-EDIT) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — Edit 토글(SwitchLock, R-EDIT): 행 집계 — D3 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (Edit 토글(SwitchLock, R-EDIT)) |
| WK-SCP0027-0278 | D3 | R-EDIT-TOGGLE off → 전셀 잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — R-EDIT-TOGGLE off → 전셀 잠금: 행 집계 — D3 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (R-EDIT-TOGGLE off → 전셀 잠금) |
| WK-SCP0027-0279 | D3 | SCP0027_ProjectRoute_Electrode.EditButto | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SCP0027_ProjectRoute_Electrode.EditButton: 진입점 집계 — D3 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0027_ProjectRoute_Electrode.EditB) |
| WK-SCP0027-0280 | D3 | 툴바 Search/Insert/Save/Delete/Excel + Edi | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 툴바 Search/Insert/Save/Delete/Excel + Edit 토글(Switc: 행 집계 — D3 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (툴바 Search/Insert/Save/Delete/Excel + Edi) |
| WK-SCP0027-0281 | D4 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — COMMON:UC-01: 행 집계 — D4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SCP0027-0282 | D4 | Edit 토글(SwitchLock, R-EDIT) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — Edit 토글(SwitchLock, R-EDIT): 행 집계 — D4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (Edit 토글(SwitchLock, R-EDIT)) |
| WK-SCP0027-0283 | D4 | clbDivision (`MyDivision`, EE·권한 SQL 내재, | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — clbDivision (`MyDivision`, EE·권한 SQL 내재, 다중선택): 행 집계 — D4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (clbDivision (`MyDivision`, EE·권한 SQL 내재,) |
| WK-SCP0027-0284 | D4 | 툴바 Search/Insert/Save/Delete/Excel + Edi | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — 툴바 Search/Insert/Save/Delete/Excel + Edit 토글(Switc: 행 집계 — D4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (툴바 Search/Insert/Save/Delete/Excel + Edi) |
| WK-SCP0027-0285 | D5 | SCP0027_ProjectRoute_Electrode.CreateSpr | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0027_ProjectRoute_Electrode.CreateSpread: 진입점 집계 — D5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0027_ProjectRoute_Electrode.Creat) |
| WK-SCP0027-0286 | D5 | SCP0027_ProjectRoute_Electrode.SetImageC | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0027_ProjectRoute_Electrode.SetImageCell: 진입점 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0027_ProjectRoute_Electrode.SetIm) |
| WK-SCP0027-0287 | E2 | MSG00048/MSG00219 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E2 기대값 확정 — MSG00048/MSG00219: 행 집계 — E2 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (MSG00048/MSG00219) |
| WK-SCP0027-0288 | E4 | SCP0027_ProjectRoute_Electrode.SetChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0027_ProjectRoute_Electrode.SetChangedControl: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0027_ProjectRoute_Electrode.SetCh) |
| WK-SCP0027-0289 | E4 | SCP0027_ProjectRoute_Electrode.SetChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0027_ProjectRoute_Electrode.SetChangedPeriod: 진입점 집계 — E4 38요소: NOT_RUN:38 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0027_ProjectRoute_Electrode.SetCh) |
| WK-SCP0027-0290 | E4 | SCP0027_ProjectRoute_Electrode.SetImageC | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0027_ProjectRoute_Electrode.SetImageCell: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0027_ProjectRoute_Electrode.SetIm) |
| WK-SCP0027-0291 | E4 | SCP0027_ProjectRoute_Electrode.SetOrgDat | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0027_ProjectRoute_Electrode.SetOrgData: 진입점 집계 — E4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0027_ProjectRoute_Electrode.SetOr) |
| WK-SCP0027-0292 | E4 | SCP0027_ProjectRoute_Electrode.set_Valid | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0027_ProjectRoute_Electrode.set_ValidDataSet: 진입점 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 11 (ACT:SCP0027_ProjectRoute_Electrode.set_V) |
| WK-SCP0027-0293 | E4 | Save | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — Save: 행 집계 — E4 38요소: NOT_RUN:38 (미실행 요소가 남아 판정필요) |  | 1 (Save) |
| WK-SCP0027-0294 | G1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-02: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0027-0295 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0027-0296 | G1 | Edit 토글(SwitchLock, R-EDIT) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Edit 토글(SwitchLock, R-EDIT): 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (Edit 토글(SwitchLock, R-EDIT)) |
| WK-SCP0027-0297 | G1 | PLANT_SITE_ID 셀콤보(ElecRoutePlantByOperat | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — PLANT_SITE_ID 셀콤보(ElecRoutePlantByOperation_SCP 3-: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (PLANT_SITE_ID 셀콤보(ElecRoutePlantByOperat) |
| WK-SCP0027-0298 | G1 | R-AUTH 권한 division 0건 → SetDivisionAuthC | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — R-AUTH 권한 division 0건 → SetDivisionAuthCheck: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (R-AUTH 권한 division 0건 → SetDivisionAuthC) |
| WK-SCP0027-0299 | G1 | SCP0027_ProjectRoute_Electrode.FindButto | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SCP0027_ProjectRoute_Electrode.FindButton: 진입점 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0027_ProjectRoute_Electrode.FindB) |
| WK-SCP0027-0300 | G1 | SCP0027_ProjectRoute_Electrode.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SCP0027_ProjectRoute_Electrode.FindData: 진입점 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0027_ProjectRoute_Electrode.FindD) |
| WK-SCP0027-0301 | G1 | SCP0027_ProjectRoute_Electrode.FindDataM | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SCP0027_ProjectRoute_Electrode.FindDataMain: 진입점 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 11 (ACT:SCP0027_ProjectRoute_Electrode.FindD) |
| WK-SCP0027-0302 | G1 | Search(F5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Search(F5): 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (Search(F5)) |
| WK-SCP0027-0303 | G1 | spdMain gridColumns=0 → DB 메타 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — spdMain gridColumns=0 → DB 메타: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (spdMain gridColumns=0 → DB 메타) |
| WK-SCP0027-0304 | G1 | 툴바 Search/Insert/Save/Delete/Excel + Edi | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 툴바 Search/Insert/Save/Delete/Excel + Edit 토글(Switc: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (툴바 Search/Insert/Save/Delete/Excel + Edi) |
| WK-SCP0027-0305 | X-LOC | Delete('I'행만, 알림 없음) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Delete('I'행만, 알림 없음): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Delete('I'행만, 알림 없음)) |
| WK-SCP0027-0306 | X-LOC | Edit 토글(SwitchLock, R-EDIT) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Edit 토글(SwitchLock, R-EDIT): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Edit 토글(SwitchLock, R-EDIT)) |
| WK-SCP0027-0307 | X-LOC | Excel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Excel: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Excel) |
| WK-SCP0027-0308 | X-LOC | ITEM_ID `.ToUpper()` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ITEM_ID `.ToUpper()`: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (ITEM_ID `.ToUpper()`) |
| WK-SCP0027-0309 | X-LOC | Insert(신규행, opGroup P/A silent 차단, 6종 기본 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Insert(신규행, opGroup P/A silent 차단, 6종 기본값·PRIORITY: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Insert(신규행, opGroup P/A silent 차단, 6종 기본) |
| WK-SCP0027-0310 | X-LOC | MSG00048/MSG00219 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00048/MSG00219: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00048/MSG00219) |
| WK-SCP0027-0311 | X-LOC | MSG00107 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00107: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00107) |
| WK-SCP0027-0312 | X-LOC | MSG00212 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00212: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00212) |
| WK-SCP0027-0313 | X-LOC | MSG00213 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00213: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00213) |
| WK-SCP0027-0314 | X-LOC | MSG00214 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00214: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00214) |
| WK-SCP0027-0315 | X-LOC | MSG00215 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00215: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00215) |
| WK-SCP0027-0316 | X-LOC | MSG00216 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00216: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00216) |
| WK-SCP0027-0317 | X-LOC | MSG00217 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00217: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00217) |
| WK-SCP0027-0318 | X-LOC | MSG00220 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00220: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00220) |
| WK-SCP0027-0319 | X-LOC | MSG00257 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00257: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00257) |
| WK-SCP0027-0320 | X-LOC | PKG_SCP0027.P_SAVE_ProjectRoute_Electrod | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — PKG_SCP0027.P_SAVE_ProjectRoute_Electrode(18 args : 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (PKG_SCP0027.P_SAVE_ProjectRoute_Electrod) |
| WK-SCP0027-0321 | X-LOC | PLANT_SITE_ID 저장 = 원본 PLANT_SITE_ID_B(표시 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — PLANT_SITE_ID 저장 = 원본 PLANT_SITE_ID_B(표시 합성값 아님): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (PLANT_SITE_ID 저장 = 원본 PLANT_SITE_ID_B(표시) |
| WK-SCP0027-0322 | X-LOC | PRIORITY_SEQ 빈값 → 'M'→'I' 승격 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — PRIORITY_SEQ 빈값 → 'M'→'I' 승격: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (PRIORITY_SEQ 빈값 → 'M'→'I' 승격) |
| WK-SCP0027-0323 | X-LOC | Save | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Save: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Save) |
| WK-SCP0027-0324 | X-LOC | Search(F5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Search(F5): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Search(F5)) |
| WK-SCP0027-0325 | X-ROW | Excel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — Excel: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (Excel) |
| WK-SCP0027-0326 | X-ROW | SCP0027_ProjectRoute_Electrode.AfterFind | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0027_ProjectRoute_Electrode.AfterFindData: 진입점 집계 2검사 — NOPATH:2 (미실행 검사가 남아 판정필요) |  | 12 (ACT:SCP0027_ProjectRoute_Electrode.After) |
| WK-SCP0027-0327 | X-ROW | SCP0027_ProjectRoute_Electrode.BeforeFin | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0027_ProjectRoute_Electrode.BeforeFindData: 진입점 집계 1검사 — NOPATH:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0027_ProjectRoute_Electrode.Befor) |
| WK-SCP0027-0328 | X-ROW | SCP0027_ProjectRoute_Electrode.ClbDivisi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0027_ProjectRoute_Electrode.ClbDivision_Selecte: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0027_ProjectRoute_Electrode.ClbDi) |
| WK-SCP0027-0329 | X-ROW | SCP0027_ProjectRoute_Electrode.ClearUsrC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0027_ProjectRoute_Electrode.ClearUsrCheckedList: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/LIST_REBIND/STATE_RESET, |  | 4 (ACT:SCP0027_ProjectRoute_Electrode.Clear) |
| WK-SCP0027-0330 | X-ROW | SCP0027_ProjectRoute_Electrode.CreateSpr | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0027_ProjectRoute_Electrode.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0027_ProjectRoute_Electrode.Creat) |
| WK-SCP0027-0331 | X-ROW | SCP0027_ProjectRoute_Electrode.DefinePro | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0027_ProjectRoute_Electrode.DefineProperty: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0027_ProjectRoute_Electrode.Defin) |
| WK-SCP0027-0332 | X-ROW | SCP0027_ProjectRoute_Electrode.FindButto | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0027_ProjectRoute_Electrode.FindButton: 진입점 집계 4검사 — NOPATH:2 · NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0027_ProjectRoute_Electrode.FindB) |
| WK-SCP0027-0333 | X-ROW | SCP0027_ProjectRoute_Electrode.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0027_ProjectRoute_Electrode.FindData: 진입점 집계 4검사 — NOPATH:2 · NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0027_ProjectRoute_Electrode.FindD) |
| WK-SCP0027-0334 | X-ROW | SCP0027_ProjectRoute_Electrode.FindDataM | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0027_ProjectRoute_Electrode.FindDataMain: 진입점 집계 5검사 — NOPATH:3 · NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0027_ProjectRoute_Electrode.FindD) |
| WK-SCP0027-0335 | X-ROW | SCP0027_ProjectRoute_Electrode.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0027_ProjectRoute_Electrode.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0027_ProjectRoute_Electrode.Form_) |
| WK-SCP0027-0336 | X-ROW | SCP0027_ProjectRoute_Electrode.InitContr | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0027_ProjectRoute_Electrode.InitControls: 진입점 집계 14검사 — NOT_RUN:10 · NOPATH:3 · TODO:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0027_ProjectRoute_Electrode.InitC) |
| WK-SCP0027-0337 | X-ROW | SCP0027_ProjectRoute_Electrode.InitQuery | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0027_ProjectRoute_Electrode.InitQueryDics: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0027_ProjectRoute_Electrode.InitQ) |
| WK-SCP0027-0338 | X-ROW | SCP0027_ProjectRoute_Electrode.InitSprea | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0027_ProjectRoute_Electrode.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0027_ProjectRoute_Electrode.InitS) |
| WK-SCP0027-0339 | X-ROW | SCP0027_ProjectRoute_Electrode.InsertBut | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0027_ProjectRoute_Electrode.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0027_ProjectRoute_Electrode.Inser) |
| WK-SCP0027-0340 | X-ROW | SCP0027_ProjectRoute_Electrode.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0027_ProjectRoute_Electrode.InsertRow: 진입점 집계 14검사 — NOT_RUN:11 · NOPATH:3 (미실행 검사가 남아 판정필요) |  | 24 (ACT:SCP0027_ProjectRoute_Electrode.Inser) |
| WK-SCP0027-0341 | X-ROW | SCP0027_ProjectRoute_Electrode.RefreshPl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0027_ProjectRoute_Electrode.RefreshPlantSiteFor: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/CALL_LOCAL/DATA_OP/EN |  | 8 (ACT:SCP0027_ProjectRoute_Electrode.Refre) |
| WK-SCP0027-0342 | X-ROW | SCP0027_ProjectRoute_Electrode.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0027_ProjectRoute_Electrode.SaveData: 진입점 집계 9검사 — NOT_RUN:6 · NOPATH:2 · PASS:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0027_ProjectRoute_Electrode.SaveD) |
| WK-SCP0027-0343 | X-ROW | SCP0027_ProjectRoute_Electrode.SetChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0027_ProjectRoute_Electrode.SetChangedControl: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:2 |  | 1 (ACT:SCP0027_ProjectRoute_Electrode.SetCh) |
| WK-SCP0027-0344 | X-ROW | SCP0027_ProjectRoute_Electrode.SetChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0027_ProjectRoute_Electrode.SetChangedPeriod: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0027_ProjectRoute_Electrode.SetCh) |
| WK-SCP0027-0345 | X-ROW | SCP0027_ProjectRoute_Electrode.SetImageC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0027_ProjectRoute_Electrode.SetImageCell: 진입점 집계 12검사 — REVIEW:6 · NOT_RUN:6 |  | 1 (ACT:SCP0027_ProjectRoute_Electrode.SetIm) |
| WK-SCP0027-0346 | X-ROW | SCP0027_ProjectRoute_Electrode.SetOrgDat | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0027_ProjectRoute_Electrode.SetOrgData: 진입점 집계 10검사 — NOT_RUN:8 · REVIEW:2 |  | 2 (ACT:SCP0027_ProjectRoute_Electrode.SetOr) |
| WK-SCP0027-0347 | X-ROW | SCP0027_ProjectRoute_Electrode.SpdMain_C | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0027_ProjectRoute_Electrode.SpdMain_CellClick: 진입점 집계 9검사 — NOT_RUN:5 · NOPATH:4 (미실행 검사가 남아 판정필요) |  | 14 (ACT:SCP0027_ProjectRoute_Electrode.SpdMa) |
| WK-SCP0027-0348 | X-ROW | SCP0027_ProjectRoute_Electrode.btnItemId | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0027_ProjectRoute_Electrode.btnItemId_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0027_ProjectRoute_Electrode.btnIt) |
| WK-SCP0027-0349 | X-ROW | SCP0027_ProjectRoute_Electrode.cboOperat | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0027_ProjectRoute_Electrode.cboOperationGroup_S: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0027_ProjectRoute_Electrode.cboOp) |
| WK-SCP0027-0350 | X-ROW | SCP0027_ProjectRoute_Electrode.checkVali | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0027_ProjectRoute_Electrode.checkValidN0: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 14 (ACT:SCP0027_ProjectRoute_Electrode.check) |
| WK-SCP0027-0351 | X-ROW | SCP0027_ProjectRoute_Electrode.checkVali | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0027_ProjectRoute_Electrode.checkValidN1: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 36 (ACT:SCP0027_ProjectRoute_Electrode.check) |
| WK-SCP0027-0352 | X-ROW | SCP0027_ProjectRoute_Electrode.checkVali | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0027_ProjectRoute_Electrode.checkValidN2: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 36 (ACT:SCP0027_ProjectRoute_Electrode.check) |
| WK-SCP0027-0353 | X-ROW | SCP0027_ProjectRoute_Electrode.checkVali | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0027_ProjectRoute_Electrode.checkValidN3: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 38 (ACT:SCP0027_ProjectRoute_Electrode.check) |
| WK-SCP0027-0354 | X-ROW | SCP0027_ProjectRoute_Electrode.checkVali | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0027_ProjectRoute_Electrode.checkValidN4: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 38 (ACT:SCP0027_ProjectRoute_Electrode.check) |
| WK-SCP0027-0355 | X-ROW | SCP0027_ProjectRoute_Electrode.checkVali | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0027_ProjectRoute_Electrode.checkValidN5: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 50 (ACT:SCP0027_ProjectRoute_Electrode.check) |
| WK-SCP0027-0356 | X-ROW | SCP0027_ProjectRoute_Electrode.checkVali | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0027_ProjectRoute_Electrode.checkValidN6: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 52 (ACT:SCP0027_ProjectRoute_Electrode.check) |
| WK-SCP0027-0357 | X-ROW | SCP0027_ProjectRoute_Electrode.checkVali | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0027_ProjectRoute_Electrode.checkValidN7: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 26 (ACT:SCP0027_ProjectRoute_Electrode.check) |
| WK-SCP0027-0358 | X-ROW | SCP0027_ProjectRoute_Electrode.checkVali | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0027_ProjectRoute_Electrode.checkValidN8: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 45 (ACT:SCP0027_ProjectRoute_Electrode.check) |
| WK-SCP0027-0359 | X-ROW | SCP0027_ProjectRoute_Electrode.checkVali | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0027_ProjectRoute_Electrode.checkValidN9: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 28 (ACT:SCP0027_ProjectRoute_Electrode.check) |
| WK-SCP0027-0360 | X-ROW | SCP0027_ProjectRoute_Electrode.getCellVa | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0027_ProjectRoute_Electrode.getCellValue: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0027_ProjectRoute_Electrode.getCe) |
| WK-SCP0027-0361 | X-ROW | SCP0027_ProjectRoute_Electrode.spdMain_C | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0027_ProjectRoute_Electrode.spdMain_CellDoubleC: 진입점 집계 10검사 — NOT_RUN:5 · REVIEW:3 · NOPATH:2 |  | 4 (ACT:SCP0027_ProjectRoute_Electrode.spdMa) |
| WK-SCP0027-0362 | X-ROW | SCP0027_ProjectRoute_Electrode.spdMain_C | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0027_ProjectRoute_Electrode.spdMain_Change: 진입점 집계 11검사 — NOT_RUN:11 (미실행 검사가 남아 판정필요) |  | 55 (ACT:SCP0027_ProjectRoute_Electrode.spdMa) |
| WK-SCP0027-0363 | G5 | (자매 SCP0048 R-D6 div=81 SalesSite 셀 팝업) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — (자매 SCP0048 R-D6 div=81 SalesSite 셀 팝업): 행 집계 — G5 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 ((자매 SCP0048 R-D6 div=81 SalesSite 셀 팝업)) |
| WK-SCP0027-0364 | G5 | SCP0027_ProjectRoute_Electrode.spdMain_C | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCP0027_ProjectRoute_Electrode.spdMain_CellDoubleC: 진입점 집계 — G5 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0027_ProjectRoute_Electrode.spdMa) |
| WK-SCP0027-0365 | H6 | (자매 SCP0048 R-D6 div=81 SalesSite 셀 팝업) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — (자매 SCP0048 R-D6 div=81 SalesSite 셀 팝업): 행 집계 — H6 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 ((자매 SCP0048 R-D6 div=81 SalesSite 셀 팝업)) |
| WK-SCP0027-0366 | H6 | SCP0027_ProjectRoute_Electrode.spdMain_C | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCP0027_ProjectRoute_Electrode.spdMain_CellDoubleC: 진입점 집계 — H6 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0027_ProjectRoute_Electrode.spdMa) |
| WK-SCP0027-0367 | M4 | (자매 SCP0048 R-D6 div=81 SalesSite 셀 팝업) | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — (자매 SCP0048 R-D6 div=81 SalesSite 셀 팝업): 행 집계 — M4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 ((자매 SCP0048 R-D6 div=81 SalesSite 셀 팝업)) |
| WK-SCP0027-0368 | M4 | SCP0027_ProjectRoute_Electrode.spdMain_C | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0027_ProjectRoute_Electrode.spdMain_CellDoubleC: 진입점 집계 — M4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0027_ProjectRoute_Electrode.spdMa) |
