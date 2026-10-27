# 작업 원장 — SCP0024 · 2026-10-26 12:53

> 검사 인스턴스 418건 중 PASS·NA 49건 외 **369건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W1 | 기능 구현 | 1 | 대조표 구현 + 위치 기입 → W8 실행 |
| W2 | 구현 위치 확인 | 14 | 구현 위치 실존 |
| W3 | 동작 수정 | 1 | 재판정 PASS |
| W4 | 검사기 구현 | 7 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 34 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 96 | 실행 → PASS |
| W7 | 기대값 확정 | 212 | 기대 확정 → PASS/FAIL |
| W8 | 구현 후 검증 | 4 | 선행 W1 → PASS |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 208 · E2E 96 · 하네스 41 · 대조표 18 · 선행 W1 완료 후 E2E 4 · FE 2
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 12건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 40 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| X-LOC | GEN |  | 14 |  |  |  |  | 13 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| B4 | COMBO |  |  |  |  | 9 |  | 14 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| A5 | DESIGN |  |  |  |  |  | 6 | 16 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| B3 | COMBO |  |  |  | 7 |  |  | 14 |  |  | 콤보 후보 정렬 = AS-IS |
| G4 | DESIGN |  |  |  |  | 5 | 7 | 7 | 1 |  | 조회조건 표시·라벨·활성 |
| E4 | EDIT |  |  |  |  |  | 18 | 2 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| H2 | DESIGN |  |  |  |  |  | 4 | 15 |  |  | 배경·글자색 규칙 |
| H5 | DESIGN |  |  |  |  |  | 6 | 13 |  |  | 라벨 명칭 |
| A1 | GEN |  |  |  |  |  |  | 17 | 1 |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| G1 | GEN |  |  |  |  |  | 1 | 14 | 1 |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G6 | GEN |  |  |  |  |  | 7 | 7 | 1 |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| F4 | DB |  |  |  |  |  | 7 | 7 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| DB-SYN | DB |  |  |  |  | 5 |  | 7 |  |  | BE 계정 시노님·권한·대상 객체 |
| C3 | CASCADE |  |  |  |  |  | 3 | 7 |  |  | 연쇄 자동 채움 |
| C1 | CASCADE |  |  |  |  |  | 7 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| D3 | EDIT |  |  |  |  |  | 2 | 4 |  |  | 행 값 기반 조건부 잠금 |
| D5 | EDIT |  |  |  |  |  | 4 | 2 |  |  | 셀 에디터 유형 |
| G5 | POPUP |  |  |  |  | 3 |  | 2 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 3 |  | 2 |  |  | 팝업 표준·열림 |
| C4 | CASCADE |  |  |  |  |  | 5 |  |  |  | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| M4 | POPUP |  |  |  |  |  | 3 | 2 |  |  | 팝업 선택값 반영 |
| A6 | GEN |  |  |  |  |  | 2 | 2 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| X-REASON | DESIGN |  |  |  |  |  |  | 4 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| D4 | EDIT |  |  |  |  |  | 2 | 1 |  |  | 신규행 기본값·자동세팅·Insert 전제 |
| B1 | COMBO |  |  |  |  | 2 |  |  |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 2 |  |  |  |  | 콤보 후보 중복 없음 |
| E5 | EDIT |  |  |  |  | 2 |  |  |  |  | 콤보 셀 후보 외 값 차단 |
| X-NOTIMPL | GEN | 1 |  |  |  |  |  |  |  |  | 대조표 상태 미구현 = 구현 대상(FAIL) |
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

## W1 기능 구현 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0024-0001 | X-NOTIMPL | 5 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — 5 Data_SCP.CommonAll LineByOperationAddOSP1 287 `LineByOperationAddOSP1_SCP_ALL`(비EE pool) F4 = DIVISION_ID+SITE_ID |  | 0 () |

## W2 구현 위치 확인 (14)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0024-0002 | X-LOC | 10 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (10) |
| WK-SCP0024-0003 | X-LOC | 12 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (12) |
| WK-SCP0024-0004 | X-LOC | 9 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (9) |
| WK-SCP0024-0005 | X-LOC | COMMON:UC-02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: SearchArea.tsx 없음, SubTitle.tsx 없음 |  | 1 (COMMON:UC-02) |
| WK-SCP0024-0006 | X-LOC | COMMON:UC-05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: columns.ts 없음 |  | 1 (COMMON:UC-05) |
| WK-SCP0024-0007 | X-LOC | M13 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (M13) |
| WK-SCP0024-0008 | X-LOC | R-A 3-span 기간헤더 + 요일색 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-A 3-span 기간헤더 + 요일색) |
| WK-SCP0024-0009 | X-LOC | R-B spdInfo 초기화 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-B spdInfo 초기화) |
| WK-SCP0024-0010 | X-LOC | R-C 조건부 컬럼 visible(EE) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-C 조건부 컬럼 visible(EE)) |
| WK-SCP0024-0011 | X-LOC | R-D SUM 롤업 visible 토글 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-D SUM 롤업 visible 토글) |
| WK-SCP0024-0012 | X-LOC | R-E 데이터바인딩 + 전 컬럼 잠금 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-E 데이터바인딩 + 전 컬럼 잠금) |
| WK-SCP0024-0013 | X-LOC | R-F 인접 동일값 세로 병합 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-F 인접 동일값 세로 병합) |
| WK-SCP0024-0014 | X-LOC | R-G 셀 타입 텍스트 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-G 셀 타입 텍스트) |
| WK-SCP0024-0015 | X-LOC | R-H FIX_REASON 세팅 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-H FIX_REASON 세팅) |

## W3 동작 수정 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0024-0016 | H10 | SCP0024 화면 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | H10 FAIL 수정 — SCP0024 화면: 표준 메시지 대신 브라우저 alert/confirm 직접 호출: ProductionPlanFix.tsx, hooks/useProductionPlanFixValidation.ts |  | 12 (M4 M10 M12 M13 V16 V17 V18 COMMON:UC-02 ) |

## W4 검사기 구현 (7)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0024-0017 | B3 | ELECTRODE_TYPE | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 ELECTRODE_TYPE | 있음(SHEET_COLUMNS) | 1 (6) |
| WK-SCP0024-0018 | B3 | cboBucketType / Bucket / Bucket Type | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 2 (ACT:SCP0024_ProductionPlanFix.getBucketT) |
| WK-SCP0024-0019 | B3 | cboDivision / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboDivision / Division | 있음(FE 소스) | 2 (ACT:SCP0024_ProductionPlanFix.getDivisio) |
| WK-SCP0024-0020 | B3 | cboElectrode / Electrode | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboElectrode / Electrode | 있음(FE 소스) | 2 (ACT:SCP0024_ProductionPlanFix.getElectro) |
| WK-SCP0024-0021 | B3 | cboOperationGroup / Operation Group / Op | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboOperationGroup / Operation Group / Operation gr | 있음(FE 소스) | 2 (ACT:SCP0024_ProductionPlanFix.getOperati) |
| WK-SCP0024-0022 | B3 | clbPlantSite / Plant Site | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbPlantSite / Plant Site | 있음(FE 소스) | 4 (ACT:SCP0024_ProductionPlanFix.getLine AC) |
| WK-SCP0024-0023 | B3 | txtItemId / Material / Item Id | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 txtItemId / Material / Item Id | 있음(FE 소스) | 2 (ACT:SCP0024_ProductionPlanFix.getItemId ) |

## W5 검사기 연결 (34)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0024-0024 | B1 | OPERATION_GROUP | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL OPERATION_GROUP | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0024-0025 | B1 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0024-0026 | B2 | OPERATION_GROUP | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL OPERATION_GROUP | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0024-0027 | B2 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0024-0028 | B4 | ELECTRODE_TYPE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL ELECTRODE_TYPE | 있음(SHEET_COLUMNS) | 1 (6) |
| WK-SCP0024-0029 | B4 | OPERATION_GROUP | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL OPERATION_GROUP | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0024-0030 | B4 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0024-0031 | B4 | cboBucketType / Bucket / Bucket Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 2 (ACT:SCP0024_ProductionPlanFix.getBucketT) |
| WK-SCP0024-0032 | B4 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 2 (ACT:SCP0024_ProductionPlanFix.getDivisio) |
| WK-SCP0024-0033 | B4 | cboElectrode / Electrode | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboElectrode / Electrode | 있음(FE 소스) | 2 (ACT:SCP0024_ProductionPlanFix.getElectro) |
| WK-SCP0024-0034 | B4 | cboOperationGroup / Operation Group / Op | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboOperationGroup / Operation Group / Operation gr | 있음(FE 소스) | 2 (ACT:SCP0024_ProductionPlanFix.getOperati) |
| WK-SCP0024-0035 | B4 | clbPlantSite / Plant Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbPlantSite / Plant Site | 있음(FE 소스) | 4 (ACT:SCP0024_ProductionPlanFix.getLine AC) |
| WK-SCP0024-0036 | B4 | txtItemId / Material / Item Id | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND txtItemId / Material / Item Id | 있음(FE 소스) | 2 (ACT:SCP0024_ProductionPlanFix.getItemId ) |
| WK-SCP0024-0037 | F2 | SCP0024 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0024 화면 | 판단불가(대상 단위 SCREEN) | 351 (M4 M12 M13 R-H FIX_REASON 세팅 SaveButton ) |
| WK-SCP0024-0038 | F6 | SCP0024 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0024 화면 | 판단불가(대상 단위 SCREEN) | 349 (M10 M12 V16 SaveButton ACT:SCP0024_Produ) |
| WK-SCP0024-0039 | DB-SYN | DM0003_GET_BUCKET_TYPE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DM0003_GET_BUCKET_TYPE_CODE | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0024_ProductionPlanFix.GetBucketT) |
| WK-SCP0024-0040 | DB-SYN | SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0024_ProductionPlanFix.GetLastRan) |
| WK-SCP0024-0041 | DB-SYN | SCP0024_GET_PRODUCTION_PLAN_FIX | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0024_GET_PRODUCTION_PLAN_FIX | 없음(PROC_M 대응 없음) | 6 (ACT:SCP0024_ProductionPlanFix.FindData_M) |
| WK-SCP0024-0042 | DB-SYN | SCP0024_SAVE_PRODUCTION_PLAN_FIX | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0024_SAVE_PRODUCTION_PLAN_FIX | 없음(PROC_M 대응 없음) | 4 (ACT:SCP0024_ProductionPlanFix.SaveData:1) |
| WK-SCP0024-0043 | DB-SYN | SCP0024_SAVE_PRODUCTION_PLAN_FIX_DATASET | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0024_SAVE_PRODUCTION_PLAN_FIX_DATASET | 없음(PROC_M 대응 없음) | 1 (ACT:SCP0024_ProductionPlanFix.SaveData_F) |
| WK-SCP0024-0044 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 있음(FE 소스) | 2 (ACT:SCP0024_ProductionPlanFix.InitEvent ) |
| WK-SCP0024-0045 | G4 | btnUnfix | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnUnfix | 있음(FE 소스) | 2 (ACT:SCP0024_ProductionPlanFix.InitEvent ) |
| WK-SCP0024-0046 | G4 | btnW26 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnW26 | 없음 | 2 (ACT:SCP0024_ProductionPlanFix.InitEvent ) |
| WK-SCP0024-0047 | G4 | btnW52 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnW52 | 없음 | 2 (ACT:SCP0024_ProductionPlanFix.InitEvent ) |
| WK-SCP0024-0048 | G4 | btnWLast | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnWLast | 없음 | 4 (ACT:SCP0024_ProductionPlanFix.InitContro) |
| WK-SCP0024-0049 | E5 | OPERATION_GROUP | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL OPERATION_GROUP | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0024-0050 | E5 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0024-0051 | G03-WIRE | SCP0024 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0024 화면 | 판단불가(대상 단위 SCREEN) | 16 (ACT:SCP0024_ProductionPlanFix..ctor ACT:) |
| WK-SCP0024-0052 | G5 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnItemId | 있음(FE 소스) | 0 () |
| WK-SCP0024-0053 | G5 | btnW26 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnW26 | 없음 | 0 () |
| WK-SCP0024-0054 | G5 | btnW52 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnW52 | 없음 | 0 () |
| WK-SCP0024-0055 | H6 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnItemId | 있음(FE 소스) | 0 () |
| WK-SCP0024-0056 | H6 | btnW26 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnW26 | 없음 | 0 () |
| WK-SCP0024-0057 | H6 | btnW52 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnW52 | 없음 | 0 () |

## W6 검증 실행 (96)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0024-0058 | J2 | SCP0024 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0024 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 50 (1 2 3 4 5 6 7 8 M4 M10 M12 M13) |
| WK-SCP0024-0059 | C1 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0024_ProductionPlanFix.RefreshBuc) |
| WK-SCP0024-0060 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0024_ProductionPlanFix.RefreshDiv) |
| WK-SCP0024-0061 | C1 | cboElectrode / Electrode | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboElectrode / Electrode · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0024_ProductionPlanFix.InitContro) |
| WK-SCP0024-0062 | C1 | cboOperationGroup / Operation Group / Op | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboOperationGroup / Operation Group / Operation gr · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0024_ProductionPlanFix.RefreshOpe) |
| WK-SCP0024-0063 | C1 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (9) |
| WK-SCP0024-0064 | C1 | clbLine / Line | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbLine / Line · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0024_ProductionPlanFix.RefreshLin) |
| WK-SCP0024-0065 | C1 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (10 ACT:SCP0024_ProductionPlanFix.Refresh) |
| WK-SCP0024-0066 | C3 | ELECTRODE_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ELECTRODE_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0024_ProductionPlanFix.InitSpread) |
| WK-SCP0024-0067 | C3 | FIX_REASON | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — FIX_REASON · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCP0024_ProductionPlanFix.InitSpread) |
| WK-SCP0024-0068 | C3 | ORIGIN_DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ORIGIN_DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0024_ProductionPlanFix.InitSpread) |
| WK-SCP0024-0069 | C4 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 0 () |
| WK-SCP0024-0070 | C4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 0 () |
| WK-SCP0024-0071 | C4 | cboOperationGroup / Operation Group / Op | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboOperationGroup / Operation Group / Operation gr · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 0 () |
| WK-SCP0024-0072 | C4 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (9) |
| WK-SCP0024-0073 | C4 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (10) |
| WK-SCP0024-0074 | G3 | SCP0024 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0024 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 5 (COMMON:UC-02 COMMON:UC-04 COMMON:UC-05 C) |
| WK-SCP0024-0075 | K-SA | SCP0024 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCP0024 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 1 (COMMON:UC-02) |
| WK-SCP0024-0076 | K4 | SCP0024 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0024 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 30 (COMMON:UC-02 COMMON:UC-04 COMMON:UC-05 C) |
| WK-SCP0024-0077 | F1 | SCP0024 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0024 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 354 (M4 M10 M12 M13 V16 R-H FIX_REASON 세팅 Sav) |
| WK-SCP0024-0078 | F5 | SCP0024 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0024 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 3 (M10 V16 DeleteButton) |
| WK-SCP0024-0079 | F4 | DM0003_GET_BUCKET_TYPE_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DM0003_GET_BUCKET_TYPE_CODE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:SCP0024_ProductionPlanFix.GetBucketT) |
| WK-SCP0024-0080 | F4 | PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: |  | 2 (ACT:SCP0024_ProductionPlanFix.GetDayRang) |
| WK-SCP0024-0081 | F4 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) —  |  | 388 (ACT:SCP0024_ProductionPlanFix.FindButton) |
| WK-SCP0024-0082 | F4 | SCM0001_GET_SCP_DAILY_PLAN_PERIOD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_SCP_DAILY_PLAN_PERIOD · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke· |  | 2 (ACT:SCP0024_ProductionPlanFix.GetLastRan) |
| WK-SCP0024-0083 | F4 | SCP0024_GET_PRODUCTION_PLAN_FIX | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0024_GET_PRODUCTION_PLAN_FIX · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·tr |  | 388 (ACT:SCP0024_ProductionPlanFix.FindButton) |
| WK-SCP0024-0084 | F4 | SCP0024_SAVE_PRODUCTION_PLAN_FIX | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0024_SAVE_PRODUCTION_PLAN_FIX · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·t |  | 167 (ACT:SCP0024_ProductionPlanFix.SaveData A) |
| WK-SCP0024-0085 | F4 | SCP0024_SAVE_PRODUCTION_PLAN_FIX_DATASET | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0024_SAVE_PRODUCTION_PLAN_FIX_DATASET · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: |  | 178 (ACT:SCP0024_ProductionPlanFix.SaveData_F) |
| WK-SCP0024-0086 | A5 | ELECTRODE_TYPE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ELECTRODE_TYPE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 4 (R-C 조건부 컬럼 visible(EE) ACT:SCP0024_Produ) |
| WK-SCP0024-0087 | A5 | FIX_REASON | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — FIX_REASON · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (R-H FIX_REASON 세팅) |
| WK-SCP0024-0088 | A5 | MEASURE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — MEASURE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (R-H FIX_REASON 세팅) |
| WK-SCP0024-0089 | A5 | OPERATION_GROUP | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — OPERATION_GROUP · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (COMMON:UC-05) |
| WK-SCP0024-0090 | A5 | ORIGIN_DIVISION_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ORIGIN_DIVISION_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 4 (R-C 조건부 컬럼 visible(EE) ACT:SCP0024_Produ) |
| WK-SCP0024-0091 | A5 | SCM_SITE_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (COMMON:UC-05) |
| WK-SCP0024-0092 | G4 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0024_ProductionPlanFix.DefineProp) |
| WK-SCP0024-0093 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0024_ProductionPlanFix.InitEvent ) |
| WK-SCP0024-0094 | G4 | cboElectrode / Electrode | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboElectrode / Electrode · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0024_ProductionPlanFix.InitContro) |
| WK-SCP0024-0095 | G4 | cboOperationGroup / Operation Group / Op | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboOperationGroup / Operation Group / Operation gr · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0024_ProductionPlanFix.InitEvent ) |
| WK-SCP0024-0096 | G4 | chkSum / Sum | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkSum / Sum · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0024_ProductionPlanFix.DefineProp) |
| WK-SCP0024-0097 | G4 | clbPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbPlantSite / Plant Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0024_ProductionPlanFix.InitEvent ) |
| WK-SCP0024-0098 | G4 | txtItemId / Material / Item Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtItemId / Material / Item Id · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (COMMON:UC-06) |
| WK-SCP0024-0099 | H2 | ELECTRODE_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ELECTRODE_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (R-C 조건부 컬럼 visible(EE) ACT:SCP0024_Produ) |
| WK-SCP0024-0100 | H2 | FIX_REASON | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — FIX_REASON · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-H FIX_REASON 세팅) |
| WK-SCP0024-0101 | H2 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (R-H FIX_REASON 세팅) |
| WK-SCP0024-0102 | H2 | ORIGIN_DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ORIGIN_DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (R-C 조건부 컬럼 visible(EE) ACT:SCP0024_Produ) |
| WK-SCP0024-0103 | H4 | SCP0024 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — SCP0024 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 5 (12 ACT:SCP0024_ProductionPlanFix.SpdMain) |
| WK-SCP0024-0104 | H5 | ELECTRODE_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ELECTRODE_TYPE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (R-C 조건부 컬럼 visible(EE) ACT:SCP0024_Produ) |
| WK-SCP0024-0105 | H5 | FIX_REASON | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — FIX_REASON · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (R-H FIX_REASON 세팅) |
| WK-SCP0024-0106 | H5 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — MEASURE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (R-H FIX_REASON 세팅) |
| WK-SCP0024-0107 | H5 | ORIGIN_DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ORIGIN_DIVISION_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (R-C 조건부 컬럼 visible(EE) ACT:SCP0024_Produ) |
| WK-SCP0024-0108 | H5 | cboDivision / Division | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — cboDivision / Division · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 0 () |
| WK-SCP0024-0109 | H5 | chkSum / Sum | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — chkSum / Sum · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (R-D SUM 롤업 visible 토글 ACT:SCP0024_Produc) |
| WK-SCP0024-0110 | I1 | SCP0024 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0024 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 24 (M4 M10 M12 M13 V16 V17 V18 COMMON:UC-02 ) |
| WK-SCP0024-0111 | SC1 | SCP0024 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SCP0024 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 9 (1 2 3 4 5 6 7 8 COMMON:UC-06) |
| WK-SCP0024-0112 | D3 | ELECTRODE_TYPE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ELECTRODE_TYPE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (R-C 조건부 컬럼 visible(EE)) |
| WK-SCP0024-0113 | D3 | ORIGIN_DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ORIGIN_DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (R-C 조건부 컬럼 visible(EE)) |
| WK-SCP0024-0114 | D4 | FIX_REASON | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — FIX_REASON · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (R-H FIX_REASON 세팅) |
| WK-SCP0024-0115 | D4 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (R-H FIX_REASON 세팅) |
| WK-SCP0024-0116 | D5 | ELECTRODE_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ELECTRODE_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCP0024_ProductionPlanFix.InitSpread) |
| WK-SCP0024-0117 | D5 | OPERATION_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — OPERATION_GROUP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (COMMON:UC-05) |
| WK-SCP0024-0118 | D5 | ORIGIN_DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ORIGIN_DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCP0024_ProductionPlanFix.InitSpread) |
| WK-SCP0024-0119 | D5 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (COMMON:UC-05) |
| WK-SCP0024-0120 | D6 | SCP0024 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0024 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 3 (InsertButton ACT:SCP0024_ProductionPlanF) |
| WK-SCP0024-0121 | E4 | MSG00002 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00002 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (V17) |
| WK-SCP0024-0122 | E4 | MSG00003 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00003 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (M13 ACT:SCP0024_ProductionPlanFix.SaveDa) |
| WK-SCP0024-0123 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (M12 ACT:SCP0024_ProductionPlanFix.SaveDa) |
| WK-SCP0024-0124 | E4 | MSG00006 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00006 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (M12 ACT:SCP0024_ProductionPlanFix.SaveDa) |
| WK-SCP0024-0125 | E4 | MSG00016 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00016 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (M10 ACT:SCP0024_ProductionPlanFix.SaveDa) |
| WK-SCP0024-0126 | E4 | MSG00046 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00046 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0024_ProductionPlanFix.SaveData_F) |
| WK-SCP0024-0127 | E4 | MSG00049 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00049 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (V18) |
| WK-SCP0024-0128 | E4 | MSG00096 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00096 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (M4 ACT:SCP0024_ProductionPlanFix.BtnUnfi) |
| WK-SCP0024-0129 | E4 | MSG00108 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00108 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (V18) |
| WK-SCP0024-0130 | E4 | MSG00109 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00109 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0024_ProductionPlanFix.EditButton) |
| WK-SCP0024-0131 | E4 | MSG00134 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00134 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (V16 ACT:SCP0024_ProductionPlanFix.SaveDa) |
| WK-SCP0024-0132 | E4 | MSG00429 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00429 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (V17) |
| WK-SCP0024-0133 | E4 | MSG00672 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00672 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (M12) |
| WK-SCP0024-0134 | E4 | MSG00683 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00683 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (M10) |
| WK-SCP0024-0135 | E4 | MSG00703 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00703 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-02) |
| WK-SCP0024-0136 | E4 | MSG01438 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01438 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (M10) |
| WK-SCP0024-0137 | E4 | cboElectrode / Electrode | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboElectrode / Electrode · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 |  | 4 (ACT:SCP0024_ProductionPlanFix.SetChanged) |
| WK-SCP0024-0138 | E4 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SCP0024_ProductionPlanFix.SetSpreadC) |
| WK-SCP0024-0139 | A10 | SCP0024 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0024 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 114 (ACT:SCP0024_ProductionPlanFix.DefineProp) |
| WK-SCP0024-0140 | A6 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새 |  | 46 (ACT:SCP0024_ProductionPlanFix.FindButton) |
| WK-SCP0024-0141 | A6 | SCP0024_GET_PRODUCTION_PLAN_FIX | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SCP0024_GET_PRODUCTION_PLAN_FIX · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace. |  | 48 (ACT:SCP0024_ProductionPlanFix.FindButton) |
| WK-SCP0024-0142 | G1 | txtItemId / Material / Item Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemId / Material / Item Id · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (COMMON:UC-06) |
| WK-SCP0024-0143 | G6 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCP0024_ProductionPlanFix.DefineProp) |
| WK-SCP0024-0144 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0024_ProductionPlanFix.InitEvent ) |
| WK-SCP0024-0145 | G6 | cboElectrode / Electrode | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboElectrode / Electrode · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0024_ProductionPlanFix.InitContro) |
| WK-SCP0024-0146 | G6 | cboOperationGroup / Operation Group / Op | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboOperationGroup / Operation Group / Operation gr · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0024_ProductionPlanFix.InitEvent ) |
| WK-SCP0024-0147 | G6 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCP0024_ProductionPlanFix.DefineProp) |
| WK-SCP0024-0148 | G6 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0024_ProductionPlanFix.InitEvent ) |
| WK-SCP0024-0149 | G6 | txtItemId / Material / Item Id | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtItemId / Material / Item Id · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (COMMON:UC-06) |
| WK-SCP0024-0150 | X-REOPEN | SCP0024 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0024 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 13 (ACT:SCP0024_ProductionPlanFix.Dispose AC) |
| WK-SCP0024-0151 | M4 | btnItemId | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnItemId · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 0 () |
| WK-SCP0024-0152 | M4 | btnW26 | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnW26 · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 0 () |
| WK-SCP0024-0153 | M4 | btnW52 | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnW52 · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 0 () |

## W7 기대값 확정 (212)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0024-0154 | C3 | SCP0024_ProductionPlanFix.CboDivision_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0024_ProductionPlanFix.CboDivision_SelectedInde: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0024_ProductionPlanFix.CboDivisio) |
| WK-SCP0024-0155 | C3 | SCP0024_ProductionPlanFix.CboOperationGr | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0024_ProductionPlanFix.CboOperationGroup_Select: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0024_ProductionPlanFix.CboOperati) |
| WK-SCP0024-0156 | C3 | SCP0024_ProductionPlanFix.ClbPlantSite_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0024_ProductionPlanFix.ClbPlantSite_SelectedInd: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0024_ProductionPlanFix.ClbPlantSi) |
| WK-SCP0024-0157 | C3 | SCP0024_ProductionPlanFix.SetChangedCont | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0024_ProductionPlanFix.SetChangedControl: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0024_ProductionPlanFix.SetChanged) |
| WK-SCP0024-0158 | C3 | SCP0024_ProductionPlanFix.SetSpreadColum | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0024_ProductionPlanFix.SetSpreadColumn: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SCP0024_ProductionPlanFix.SetSpreadC) |
| WK-SCP0024-0159 | C3 | SCP0024_ProductionPlanFix.cboBucketType_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0024_ProductionPlanFix.cboBucketType_SelectedIn: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0024_ProductionPlanFix.cboBucketT) |
| WK-SCP0024-0160 | C3 | SCP0024_ProductionPlanFix.chkSum_Checked | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0024_ProductionPlanFix.chkSum_CheckedChanged: 진입점 집계 — C3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0024_ProductionPlanFix.chkSum_Che) |
| WK-SCP0024-0161 | B3 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — 1: 행 집계 — B3 7요소: TODO:7 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-SCP0024-0162 | B3 | SCP0024_ProductionPlanFix.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0024_ProductionPlanFix.GetBucketType: 진입점 집계 — B3 7요소: TODO:7 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0024_ProductionPlanFix.GetBucketT) |
| WK-SCP0024-0163 | B3 | SCP0024_ProductionPlanFix.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0024_ProductionPlanFix.GetDayRange: 진입점 집계 — B3 7요소: TODO:7 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SCP0024_ProductionPlanFix.GetDayRang) |
| WK-SCP0024-0164 | B3 | SCP0024_ProductionPlanFix.GetLastRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0024_ProductionPlanFix.GetLastRange: 진입점 집계 — B3 7요소: TODO:7 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0024_ProductionPlanFix.GetLastRan) |
| WK-SCP0024-0165 | B3 | SCP0024_ProductionPlanFix.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0024_ProductionPlanFix.GetSpdTitle: 진입점 집계 — B3 7요소: TODO:7 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0024_ProductionPlanFix.GetSpdTitl) |
| WK-SCP0024-0166 | B3 | SCP0024_ProductionPlanFix.getBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0024_ProductionPlanFix.getBucketType: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0024_ProductionPlanFix.getBucketT) |
| WK-SCP0024-0167 | B3 | SCP0024_ProductionPlanFix.getDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0024_ProductionPlanFix.getDivision: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0024_ProductionPlanFix.getDivisio) |
| WK-SCP0024-0168 | B3 | SCP0024_ProductionPlanFix.getElectrodeTy | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0024_ProductionPlanFix.getElectrodeType: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0024_ProductionPlanFix.getElectro) |
| WK-SCP0024-0169 | B3 | SCP0024_ProductionPlanFix.getFromYYYYMMD | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0024_ProductionPlanFix.getFromYYYYMMDD: 진입점 집계 — B3 7요소: TODO:7 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0024_ProductionPlanFix.getFromYYY) |
| WK-SCP0024-0170 | B3 | SCP0024_ProductionPlanFix.getItemId | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0024_ProductionPlanFix.getItemId: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0024_ProductionPlanFix.getItemId:) |
| WK-SCP0024-0171 | B3 | SCP0024_ProductionPlanFix.getLine | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0024_ProductionPlanFix.getLine: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0024_ProductionPlanFix.getLine:12) |
| WK-SCP0024-0172 | B3 | SCP0024_ProductionPlanFix.getOperationGr | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0024_ProductionPlanFix.getOperationGroup: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0024_ProductionPlanFix.getOperati) |
| WK-SCP0024-0173 | B3 | SCP0024_ProductionPlanFix.getPlantSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0024_ProductionPlanFix.getPlantSite: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0024_ProductionPlanFix.getPlantSi) |
| WK-SCP0024-0174 | B3 | SCP0024_ProductionPlanFix.getToYYYYMMDD | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0024_ProductionPlanFix.getToYYYYMMDD: 진입점 집계 — B3 7요소: TODO:7 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0024_ProductionPlanFix.getToYYYYM) |
| WK-SCP0024-0175 | B4 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — 1: 행 집계 — B4 9요소: NOPATH:9 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-SCP0024-0176 | B4 | SCP0024_ProductionPlanFix.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0024_ProductionPlanFix.GetBucketType: 진입점 집계 — B4 9요소: NOPATH:9 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0024_ProductionPlanFix.GetBucketT) |
| WK-SCP0024-0177 | B4 | SCP0024_ProductionPlanFix.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0024_ProductionPlanFix.GetDayRange: 진입점 집계 — B4 9요소: NOPATH:9 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SCP0024_ProductionPlanFix.GetDayRang) |
| WK-SCP0024-0178 | B4 | SCP0024_ProductionPlanFix.GetLastRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0024_ProductionPlanFix.GetLastRange: 진입점 집계 — B4 9요소: NOPATH:9 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0024_ProductionPlanFix.GetLastRan) |
| WK-SCP0024-0179 | B4 | SCP0024_ProductionPlanFix.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0024_ProductionPlanFix.GetSpdTitle: 진입점 집계 — B4 9요소: NOPATH:9 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0024_ProductionPlanFix.GetSpdTitl) |
| WK-SCP0024-0180 | B4 | SCP0024_ProductionPlanFix.getBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0024_ProductionPlanFix.getBucketType: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0024_ProductionPlanFix.getBucketT) |
| WK-SCP0024-0181 | B4 | SCP0024_ProductionPlanFix.getDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0024_ProductionPlanFix.getDivision: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0024_ProductionPlanFix.getDivisio) |
| WK-SCP0024-0182 | B4 | SCP0024_ProductionPlanFix.getElectrodeTy | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0024_ProductionPlanFix.getElectrodeType: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0024_ProductionPlanFix.getElectro) |
| WK-SCP0024-0183 | B4 | SCP0024_ProductionPlanFix.getFromYYYYMMD | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0024_ProductionPlanFix.getFromYYYYMMDD: 진입점 집계 — B4 9요소: NOPATH:9 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0024_ProductionPlanFix.getFromYYY) |
| WK-SCP0024-0184 | B4 | SCP0024_ProductionPlanFix.getItemId | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0024_ProductionPlanFix.getItemId: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0024_ProductionPlanFix.getItemId:) |
| WK-SCP0024-0185 | B4 | SCP0024_ProductionPlanFix.getLine | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0024_ProductionPlanFix.getLine: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0024_ProductionPlanFix.getLine:12) |
| WK-SCP0024-0186 | B4 | SCP0024_ProductionPlanFix.getOperationGr | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0024_ProductionPlanFix.getOperationGroup: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0024_ProductionPlanFix.getOperati) |
| WK-SCP0024-0187 | B4 | SCP0024_ProductionPlanFix.getPlantSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0024_ProductionPlanFix.getPlantSite: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0024_ProductionPlanFix.getPlantSi) |
| WK-SCP0024-0188 | B4 | SCP0024_ProductionPlanFix.getToYYYYMMDD | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0024_ProductionPlanFix.getToYYYYMMDD: 진입점 집계 — B4 9요소: NOPATH:9 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0024_ProductionPlanFix.getToYYYYM) |
| WK-SCP0024-0189 | DB-SYN | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 2: 행 집계 — DB-SYN 7요소: NOPATH:5 · PASS:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0024-0190 | DB-SYN | FindButton (Search) | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — FindButton (Search): 행 집계 — DB-SYN 7요소: NOPATH:5 · PASS:2 (미실행 요소가 남아 판정필요) |  | 1 (FindButton (Search)) |
| WK-SCP0024-0191 | DB-SYN | M10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — M10: 행 집계 — DB-SYN 7요소: NOPATH:5 · PASS:2 (미실행 요소가 남아 판정필요) |  | 1 (M10) |
| WK-SCP0024-0192 | DB-SYN | M12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — M12: 행 집계 — DB-SYN 7요소: NOPATH:5 · PASS:2 (미실행 요소가 남아 판정필요) |  | 1 (M12) |
| WK-SCP0024-0193 | DB-SYN | SCP0024_ProductionPlanFix.SCM_SYS_LOG_BA | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SCP0024_ProductionPlanFix.SCM_SYS_LOG_BATCH: 진입점 집계 — DB-SYN 7요소: NOPATH:5 · PASS:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0024_ProductionPlanFix.SCM_SYS_LO) |
| WK-SCP0024-0194 | DB-SYN | SaveButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SaveButton: 행 집계 — DB-SYN 7요소: NOPATH:5 · PASS:2 (미실행 요소가 남아 판정필요) |  | 1 (SaveButton) |
| WK-SCP0024-0195 | DB-SYN | V16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — V16: 행 집계 — DB-SYN 7요소: NOPATH:5 · PASS:2 (미실행 요소가 남아 판정필요) |  | 1 (V16) |
| WK-SCP0024-0196 | F4 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 2: 행 집계 — F4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0024-0197 | F4 | FindButton (Search) | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — FindButton (Search): 행 집계 — F4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (FindButton (Search)) |
| WK-SCP0024-0198 | F4 | M10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — M10: 행 집계 — F4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (M10) |
| WK-SCP0024-0199 | F4 | M12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — M12: 행 집계 — F4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (M12) |
| WK-SCP0024-0200 | F4 | SCP0024_ProductionPlanFix.SCM_SYS_LOG_BA | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0024_ProductionPlanFix.SCM_SYS_LOG_BATCH: 진입점 집계 — F4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0024_ProductionPlanFix.SCM_SYS_LO) |
| WK-SCP0024-0201 | F4 | SaveButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SaveButton: 행 집계 — F4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (SaveButton) |
| WK-SCP0024-0202 | F4 | V16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — V16: 행 집계 — F4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (V16) |
| WK-SCP0024-0203 | A5 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 11: 행 집계 — A5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (11) |
| WK-SCP0024-0204 | A5 | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 12: 행 집계 — A5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (12) |
| WK-SCP0024-0205 | A5 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 7: 행 집계 — A5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0024-0206 | A5 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-02: 행 집계 — A5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0024-0207 | A5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-07: 행 집계 — A5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0024-0208 | A5 | ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — ExcelButton: 행 집계 — A5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (ExcelButton) |
| WK-SCP0024-0209 | A5 | R-A 3-span 기간헤더 + 요일색 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-A 3-span 기간헤더 + 요일색: 행 집계 — A5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (R-A 3-span 기간헤더 + 요일색) |
| WK-SCP0024-0210 | A5 | R-B spdInfo 초기화 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-B spdInfo 초기화: 행 집계 — A5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (R-B spdInfo 초기화) |
| WK-SCP0024-0211 | A5 | R-D SUM 롤업 visible 토글 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-D SUM 롤업 visible 토글: 행 집계 — A5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (R-D SUM 롤업 visible 토글) |
| WK-SCP0024-0212 | A5 | R-E 데이터바인딩 + 전 컬럼 잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-E 데이터바인딩 + 전 컬럼 잠금: 행 집계 — A5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (R-E 데이터바인딩 + 전 컬럼 잠금) |
| WK-SCP0024-0213 | A5 | R-F 인접 동일값 세로 병합 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-F 인접 동일값 세로 병합: 행 집계 — A5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (R-F 인접 동일값 세로 병합) |
| WK-SCP0024-0214 | A5 | R-G 셀 타입 텍스트 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-G 셀 타입 텍스트: 행 집계 — A5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (R-G 셀 타입 텍스트) |
| WK-SCP0024-0215 | A5 | R-I 더블클릭 드릴다운 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — R-I 더블클릭 드릴다운: 행 집계 — A5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (R-I 더블클릭 드릴다운) |
| WK-SCP0024-0216 | A5 | SCP0024_ProductionPlanFix.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0024_ProductionPlanFix.CreateSpread: 진입점 집계 — A5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0024_ProductionPlanFix.CreateSpre) |
| WK-SCP0024-0217 | A5 | SCP0024_ProductionPlanFix.SetSpreadColum | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0024_ProductionPlanFix.SetSpreadColumn: 진입점 집계 — A5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SCP0024_ProductionPlanFix.SetSpreadC) |
| WK-SCP0024-0218 | A5 | SaveButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SaveButton: 행 집계 — A5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (SaveButton) |
| WK-SCP0024-0219 | G4 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 1: 행 집계 — G4 12요소: NOT_RUN:7 · NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-SCP0024-0220 | G4 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 2: 행 집계 — G4 12요소: NOT_RUN:7 · NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (2) |
| WK-SCP0024-0221 | G4 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 3: 행 집계 — G4 12요소: NOT_RUN:7 · NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (3) |
| WK-SCP0024-0222 | G4 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 4: 행 집계 — G4 12요소: NOT_RUN:7 · NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (4) |
| WK-SCP0024-0223 | G4 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 6: 행 집계 — G4 12요소: NOT_RUN:7 · NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (6) |
| WK-SCP0024-0224 | G4 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 7: 행 집계 — G4 12요소: NOT_RUN:7 · NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (7) |
| WK-SCP0024-0225 | G4 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 8: 행 집계 — G4 12요소: NOT_RUN:7 · NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (8) |
| WK-SCP0024-0226 | H2 | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 12: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (12) |
| WK-SCP0024-0227 | H2 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 7: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0024-0228 | H2 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-02: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0024-0229 | H2 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-07: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0024-0230 | H2 | ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — ExcelButton: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (ExcelButton) |
| WK-SCP0024-0231 | H2 | R-A 3-span 기간헤더 + 요일색 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-A 3-span 기간헤더 + 요일색: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (R-A 3-span 기간헤더 + 요일색) |
| WK-SCP0024-0232 | H2 | R-B spdInfo 초기화 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-B spdInfo 초기화: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (R-B spdInfo 초기화) |
| WK-SCP0024-0233 | H2 | R-D SUM 롤업 visible 토글 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-D SUM 롤업 visible 토글: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (R-D SUM 롤업 visible 토글) |
| WK-SCP0024-0234 | H2 | R-E 데이터바인딩 + 전 컬럼 잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-E 데이터바인딩 + 전 컬럼 잠금: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (R-E 데이터바인딩 + 전 컬럼 잠금) |
| WK-SCP0024-0235 | H2 | R-F 인접 동일값 세로 병합 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-F 인접 동일값 세로 병합: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (R-F 인접 동일값 세로 병합) |
| WK-SCP0024-0236 | H2 | R-G 셀 타입 텍스트 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-G 셀 타입 텍스트: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (R-G 셀 타입 텍스트) |
| WK-SCP0024-0237 | H2 | R-I 더블클릭 드릴다운 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — R-I 더블클릭 드릴다운: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (R-I 더블클릭 드릴다운) |
| WK-SCP0024-0238 | H2 | SCP0024_ProductionPlanFix.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0024_ProductionPlanFix.CreateSpread: 진입점 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0024_ProductionPlanFix.CreateSpre) |
| WK-SCP0024-0239 | H2 | SCP0024_ProductionPlanFix.SetSpreadColum | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0024_ProductionPlanFix.SetSpreadColumn: 진입점 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SCP0024_ProductionPlanFix.SetSpreadC) |
| WK-SCP0024-0240 | H2 | SaveButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SaveButton: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (SaveButton) |
| WK-SCP0024-0241 | H5 | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 12: 행 집계 — H5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (12) |
| WK-SCP0024-0242 | H5 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-02: 행 집계 — H5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0024-0243 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0024-0244 | H5 | ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — ExcelButton: 행 집계 — H5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (ExcelButton) |
| WK-SCP0024-0245 | H5 | R-A 3-span 기간헤더 + 요일색 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-A 3-span 기간헤더 + 요일색: 행 집계 — H5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (R-A 3-span 기간헤더 + 요일색) |
| WK-SCP0024-0246 | H5 | R-B spdInfo 초기화 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-B spdInfo 초기화: 행 집계 — H5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (R-B spdInfo 초기화) |
| WK-SCP0024-0247 | H5 | R-E 데이터바인딩 + 전 컬럼 잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-E 데이터바인딩 + 전 컬럼 잠금: 행 집계 — H5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (R-E 데이터바인딩 + 전 컬럼 잠금) |
| WK-SCP0024-0248 | H5 | R-F 인접 동일값 세로 병합 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-F 인접 동일값 세로 병합: 행 집계 — H5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (R-F 인접 동일값 세로 병합) |
| WK-SCP0024-0249 | H5 | R-G 셀 타입 텍스트 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-G 셀 타입 텍스트: 행 집계 — H5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (R-G 셀 타입 텍스트) |
| WK-SCP0024-0250 | H5 | R-I 더블클릭 드릴다운 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-I 더블클릭 드릴다운: 행 집계 — H5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (R-I 더블클릭 드릴다운) |
| WK-SCP0024-0251 | H5 | SCP0024_ProductionPlanFix.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0024_ProductionPlanFix.CreateSpread: 진입점 집계 — H5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0024_ProductionPlanFix.CreateSpre) |
| WK-SCP0024-0252 | H5 | SCP0024_ProductionPlanFix.SetSpreadColum | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0024_ProductionPlanFix.SetSpreadColumn: 진입점 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SCP0024_ProductionPlanFix.SetSpreadC) |
| WK-SCP0024-0253 | H5 | SaveButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SaveButton: 행 집계 — H5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (SaveButton) |
| WK-SCP0024-0254 | X-REASON | M3 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — M3 MSG00006 cs:1052 SaveData(Fix) 성공  해당없음 — M2 와 동일(Fix 경로 미이식, G20) 해당없음 |  | 1 (M3) |
| WK-SCP0024-0255 | X-REASON | M6 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — M6 MSG00004 cs:1502 Fix 결과(변경없음)  해당없음 — Fix 경로 미이식(G20) 해당없음 |  | 1 (M6) |
| WK-SCP0024-0256 | X-REASON | M7 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — M7 MSG00003 cs:1511 Fix 실패  해당없음 — Fix 경로 미이식(G20). Unfix 실패는 M13(useProcMutation 공용 onError) 해당없음 |  | 1 (M7) |
| WK-SCP0024-0257 | X-REASON | M8 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — M8 (예외) cs:1521 Fix 예외  해당없음 — Fix 경로 미이식(G20) 해당없음 |  | 1 (M8) |
| WK-SCP0024-0258 | D3 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — COMMON:UC-02: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0024-0259 | D3 | R-E 데이터바인딩 + 전 컬럼 잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — R-E 데이터바인딩 + 전 컬럼 잠금: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (R-E 데이터바인딩 + 전 컬럼 잠금) |
| WK-SCP0024-0260 | D3 | SCP0024_ProductionPlanFix.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SCP0024_ProductionPlanFix.EditButton: 진입점 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0024_ProductionPlanFix.EditButton) |
| WK-SCP0024-0261 | D3 | SaveButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SaveButton: 행 집계 — D3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (SaveButton) |
| WK-SCP0024-0262 | D4 | InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — InsertButton: 행 집계 — D4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (InsertButton) |
| WK-SCP0024-0263 | D5 | SCP0024_ProductionPlanFix.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0024_ProductionPlanFix.CreateSpread: 진입점 집계 — D5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0024_ProductionPlanFix.CreateSpre) |
| WK-SCP0024-0264 | D5 | SCP0024_ProductionPlanFix.SetSpreadColum | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0024_ProductionPlanFix.SetSpreadColumn: 진입점 집계 — D5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SCP0024_ProductionPlanFix.SetSpreadC) |
| WK-SCP0024-0265 | E4 | SCP0024_ProductionPlanFix.SetChangedCont | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0024_ProductionPlanFix.SetChangedControl: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0024_ProductionPlanFix.SetChanged) |
| WK-SCP0024-0266 | E4 | SCP0024_ProductionPlanFix.SetSpreadColum | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0024_ProductionPlanFix.SetSpreadColumn: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SCP0024_ProductionPlanFix.SetSpreadC) |
| WK-SCP0024-0267 | A1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (1) |
| WK-SCP0024-0268 | A1 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 2: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (2) |
| WK-SCP0024-0269 | A1 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 3: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (3) |
| WK-SCP0024-0270 | A1 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 4: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (4) |
| WK-SCP0024-0271 | A1 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 6: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (6) |
| WK-SCP0024-0272 | A1 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 7: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (7) |
| WK-SCP0024-0273 | A1 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 8: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (8) |
| WK-SCP0024-0274 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (COMMON:UC-02) |
| WK-SCP0024-0275 | A1 | COMMON:UC-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-04: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (COMMON:UC-04) |
| WK-SCP0024-0276 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (COMMON:UC-06) |
| WK-SCP0024-0277 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (COMMON:UC-07) |
| WK-SCP0024-0278 | A1 | FindButton (Search) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindButton (Search): 행 집계 — A1 2요소: REVIEW:2 |  | 1 (FindButton (Search)) |
| WK-SCP0024-0279 | A1 | M12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — M12: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (M12) |
| WK-SCP0024-0280 | A1 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN: 골든 비교 케이스 없음(PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN — 팝업·보조 SP |  | 46 (ACT:SCP0024_ProductionPlanFix.FindButton) |
| WK-SCP0024-0281 | A1 | SCP0024_GET_PRODUCTION_PLAN_FIX | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0024_GET_PRODUCTION_PLAN_FIX: 골든 비교 케이스 없음(SCP0024_GET_PRODUCTION_PLAN_FIX — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파 |  | 48 (ACT:SCP0024_ProductionPlanFix.FindButton) |
| WK-SCP0024-0282 | A1 | V17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — V17: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (V17) |
| WK-SCP0024-0283 | A1 | V18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — V18: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (V18) |
| WK-SCP0024-0284 | A6 | FindButton (Search) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — FindButton (Search): 행 집계 — A6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (FindButton (Search)) |
| WK-SCP0024-0285 | A6 | M12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — M12: 행 집계 — A6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (M12) |
| WK-SCP0024-0286 | G1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 1: 행 집계 — G1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-SCP0024-0287 | G1 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 2: 행 집계 — G1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (2) |
| WK-SCP0024-0288 | G1 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 3: 행 집계 — G1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (3) |
| WK-SCP0024-0289 | G1 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 4: 행 집계 — G1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (4) |
| WK-SCP0024-0290 | G1 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 6: 행 집계 — G1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (6) |
| WK-SCP0024-0291 | G1 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 7: 행 집계 — G1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (7) |
| WK-SCP0024-0292 | G1 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 8: 행 집계 — G1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (8) |
| WK-SCP0024-0293 | G1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-02: 행 집계 — G1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0024-0294 | G1 | COMMON:UC-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-04: 행 집계 — G1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-04) |
| WK-SCP0024-0295 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0024-0296 | G1 | FindButton (Search) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — FindButton (Search): 행 집계 — G1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (FindButton (Search)) |
| WK-SCP0024-0297 | G1 | M12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — M12: 행 집계 — G1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (M12) |
| WK-SCP0024-0298 | G1 | V17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — V17: 행 집계 — G1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (V17) |
| WK-SCP0024-0299 | G1 | V18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — V18: 행 집계 — G1 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (V18) |
| WK-SCP0024-0300 | G6 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 1: 행 집계 — G6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-SCP0024-0301 | G6 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 2: 행 집계 — G6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (2) |
| WK-SCP0024-0302 | G6 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 3: 행 집계 — G6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (3) |
| WK-SCP0024-0303 | G6 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 4: 행 집계 — G6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (4) |
| WK-SCP0024-0304 | G6 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 6: 행 집계 — G6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (6) |
| WK-SCP0024-0305 | G6 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 7: 행 집계 — G6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (7) |
| WK-SCP0024-0306 | G6 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 8: 행 집계 — G6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (8) |
| WK-SCP0024-0307 | X-LOC | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (1) |
| WK-SCP0024-0308 | X-LOC | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (2) |
| WK-SCP0024-0309 | X-LOC | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (3) |
| WK-SCP0024-0310 | X-LOC | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (4) |
| WK-SCP0024-0311 | X-LOC | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (5) |
| WK-SCP0024-0312 | X-LOC | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 6: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (6) |
| WK-SCP0024-0313 | X-LOC | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 7: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (7) |
| WK-SCP0024-0314 | X-LOC | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 8: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (8) |
| WK-SCP0024-0315 | X-LOC | DeleteButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — DeleteButton: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (DeleteButton) |
| WK-SCP0024-0316 | X-LOC | ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ExcelButton: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (ExcelButton) |
| WK-SCP0024-0317 | X-LOC | FindButton (Search) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — FindButton (Search): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (FindButton (Search)) |
| WK-SCP0024-0318 | X-LOC | InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — InsertButton: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (InsertButton) |
| WK-SCP0024-0319 | X-LOC | SaveButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SaveButton: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SaveButton) |
| WK-SCP0024-0320 | X-ROW | SCP0024_ProductionPlanFix.BtnW26_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0024_ProductionPlanFix.BtnW26_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 0 () |
| WK-SCP0024-0321 | X-ROW | SCP0024_ProductionPlanFix.BtnW52_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0024_ProductionPlanFix.BtnW52_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 0 () |
| WK-SCP0024-0322 | X-ROW | SCP0024_ProductionPlanFix.BtnWLast_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0024_ProductionPlanFix.BtnWLast_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 0 () |
| WK-SCP0024-0323 | X-ROW | SCP0024_ProductionPlanFix.CboDivision_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0024_ProductionPlanFix.CboDivision_SelectedInde: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0024_ProductionPlanFix.CboDivisio) |
| WK-SCP0024-0324 | X-ROW | SCP0024_ProductionPlanFix.CboOperationGr | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0024_ProductionPlanFix.CboOperationGroup_Select: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0024_ProductionPlanFix.CboOperati) |
| WK-SCP0024-0325 | X-ROW | SCP0024_ProductionPlanFix.ClbPlantSite_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0024_ProductionPlanFix.ClbPlantSite_SelectedInd: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0024_ProductionPlanFix.ClbPlantSi) |
| WK-SCP0024-0326 | X-ROW | SCP0024_ProductionPlanFix.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0024_ProductionPlanFix.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0024_ProductionPlanFix.CreateSpre) |
| WK-SCP0024-0327 | X-ROW | SCP0024_ProductionPlanFix.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0024_ProductionPlanFix.DefineProperty: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0024_ProductionPlanFix.DefineProp) |
| WK-SCP0024-0328 | X-ROW | SCP0024_ProductionPlanFix.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0024_ProductionPlanFix.EditButton: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0024_ProductionPlanFix.EditButton) |
| WK-SCP0024-0329 | X-ROW | SCP0024_ProductionPlanFix.ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0024_ProductionPlanFix.ExcelButton: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/ENTRY/EXPR/LOCAL/THROW/UI_MISC/UI_PROP, 연 |  | 15 (ACT:SCP0024_ProductionPlanFix.ExcelButto) |
| WK-SCP0024-0330 | X-ROW | SCP0024_ProductionPlanFix.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0024_ProductionPlanFix.FindButton: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:2 |  | 1 (ACT:SCP0024_ProductionPlanFix.FindButton) |
| WK-SCP0024-0331 | X-ROW | SCP0024_ProductionPlanFix.FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0024_ProductionPlanFix.FindData_Main: 진입점 집계 9검사 — NOT_RUN:5 · REVIEW:2 · PASS:1 · NOPATH:1 |  | 11 (ACT:SCP0024_ProductionPlanFix.FindData_M) |
| WK-SCP0024-0332 | X-ROW | SCP0024_ProductionPlanFix.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0024_ProductionPlanFix.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0024_ProductionPlanFix.Form_Load) |
| WK-SCP0024-0333 | X-ROW | SCP0024_ProductionPlanFix.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0024_ProductionPlanFix.GetBucketType: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0024_ProductionPlanFix.GetBucketT) |
| WK-SCP0024-0334 | X-ROW | SCP0024_ProductionPlanFix.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0024_ProductionPlanFix.GetDayRange: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:1 · TODO:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0024_ProductionPlanFix.GetDayRang) |
| WK-SCP0024-0335 | X-ROW | SCP0024_ProductionPlanFix.GetLastRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0024_ProductionPlanFix.GetLastRange: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0024_ProductionPlanFix.GetLastRan) |
| WK-SCP0024-0336 | X-ROW | SCP0024_ProductionPlanFix.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0024_ProductionPlanFix.GetSpdTitle: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:1 · TODO:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0024_ProductionPlanFix.GetSpdTitl) |
| WK-SCP0024-0337 | X-ROW | SCP0024_ProductionPlanFix.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0024_ProductionPlanFix.InitControls: 진입점 집계 5검사 — NOT_RUN:4 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0024_ProductionPlanFix.InitContro) |
| WK-SCP0024-0338 | X-ROW | SCP0024_ProductionPlanFix.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0024_ProductionPlanFix.InitSpread: 진입점 집계 11검사 — NOT_RUN:11 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0024_ProductionPlanFix.InitSpread) |
| WK-SCP0024-0339 | X-ROW | SCP0024_ProductionPlanFix.InitSpreadDate | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0024_ProductionPlanFix.InitSpreadDateColumn: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 14 (ACT:SCP0024_ProductionPlanFix.InitSpread) |
| WK-SCP0024-0340 | X-ROW | SCP0024_ProductionPlanFix.InitSpreadFixR | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0024_ProductionPlanFix.InitSpreadFixReason: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0024_ProductionPlanFix.InitSpread) |
| WK-SCP0024-0341 | X-ROW | SCP0024_ProductionPlanFix.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0024_ProductionPlanFix.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0024_ProductionPlanFix.InsertButt) |
| WK-SCP0024-0342 | X-ROW | SCP0024_ProductionPlanFix.RefreshBucketT | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0024_ProductionPlanFix.RefreshBucketType: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0024_ProductionPlanFix.RefreshBuc) |
| WK-SCP0024-0343 | X-ROW | SCP0024_ProductionPlanFix.RefreshDivisio | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0024_ProductionPlanFix.RefreshDivision: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0024_ProductionPlanFix.RefreshDiv) |
| WK-SCP0024-0344 | X-ROW | SCP0024_ProductionPlanFix.RefreshLine | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0024_ProductionPlanFix.RefreshLine: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SCP0024_ProductionPlanFix.RefreshLin) |
| WK-SCP0024-0345 | X-ROW | SCP0024_ProductionPlanFix.RefreshOperati | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0024_ProductionPlanFix.RefreshOperationGroup: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0024_ProductionPlanFix.RefreshOpe) |
| WK-SCP0024-0346 | X-ROW | SCP0024_ProductionPlanFix.RefreshPlantSi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0024_ProductionPlanFix.RefreshPlantSite: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0024_ProductionPlanFix.RefreshPla) |
| WK-SCP0024-0347 | X-ROW | SCP0024_ProductionPlanFix.SCM_SYS_LOG_BA | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0024_ProductionPlanFix.SCM_SYS_LOG_BATCH: 진입점 집계 3검사 — NOT_RUN:2 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 12 (ACT:SCP0024_ProductionPlanFix.SCM_SYS_LO) |
| WK-SCP0024-0348 | X-ROW | SCP0024_ProductionPlanFix.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0024_ProductionPlanFix.SaveData: 진입점 집계 13검사 — NOT_RUN:8 · NOPATH:4 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0024_ProductionPlanFix.SaveData:9) |
| WK-SCP0024-0349 | X-ROW | SCP0024_ProductionPlanFix.SaveData_FixIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0024_ProductionPlanFix.SaveData_FixInfo: 진입점 집계 16검사 — NOT_RUN:11 · NOPATH:4 · PASS:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0024_ProductionPlanFix.SaveData_F) |
| WK-SCP0024-0350 | X-ROW | SCP0024_ProductionPlanFix.SaveData_FixIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0024_ProductionPlanFix.SaveData_FixInfo_U: 진입점 집계 16검사 — NOT_RUN:11 · NOPATH:4 · PASS:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0024_ProductionPlanFix.SaveData_F) |
| WK-SCP0024-0351 | X-ROW | SCP0024_ProductionPlanFix.SetChangedCont | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0024_ProductionPlanFix.SetChangedControl: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0024_ProductionPlanFix.SetChanged) |
| WK-SCP0024-0352 | X-ROW | SCP0024_ProductionPlanFix.SetSpreadColum | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0024_ProductionPlanFix.SetSpreadColumn: 진입점 집계 8검사 — NOT_RUN:8 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SCP0024_ProductionPlanFix.SetSpreadC) |
| WK-SCP0024-0353 | X-ROW | SCP0024_ProductionPlanFix.SpdMain_CellDo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0024_ProductionPlanFix.SpdMain_CellDoubleClick: 진입점 집계 3검사 — NOPATH:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0024_ProductionPlanFix.SpdMain_Ce) |
| WK-SCP0024-0354 | X-ROW | SCP0024_ProductionPlanFix.SpdMain_TopCha | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0024_ProductionPlanFix.SpdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0024_ProductionPlanFix.SpdMain_To) |
| WK-SCP0024-0355 | X-ROW | SCP0024_ProductionPlanFix.btnItemId_Clic | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0024_ProductionPlanFix.btnItemId_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0024_ProductionPlanFix.btnItemId_) |
| WK-SCP0024-0356 | X-ROW | SCP0024_ProductionPlanFix.cboBucketType_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0024_ProductionPlanFix.cboBucketType_SelectedIn: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0024_ProductionPlanFix.cboBucketT) |
| WK-SCP0024-0357 | X-ROW | SCP0024_ProductionPlanFix.chkSum_Checked | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0024_ProductionPlanFix.chkSum_CheckedChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0024_ProductionPlanFix.chkSum_Che) |
| WK-SCP0024-0358 | X-ROW | SCP0024_ProductionPlanFix.getFromYYYYMMD | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0024_ProductionPlanFix.getFromYYYYMMDD: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0024_ProductionPlanFix.getFromYYY) |
| WK-SCP0024-0359 | X-ROW | SCP0024_ProductionPlanFix.getToYYYYMMDD | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0024_ProductionPlanFix.getToYYYYMMDD: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0024_ProductionPlanFix.getToYYYYM) |
| WK-SCP0024-0360 | G5 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — 11: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (11) |
| WK-SCP0024-0361 | G5 | SCP0024_ProductionPlanFix.SpdMain_CellDo | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCP0024_ProductionPlanFix.SpdMain_CellDoubleClick: 진입점 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0024_ProductionPlanFix.SpdMain_Ce) |
| WK-SCP0024-0362 | H6 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — 11: 행 집계 — H6 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (11) |
| WK-SCP0024-0363 | H6 | SCP0024_ProductionPlanFix.SpdMain_CellDo | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCP0024_ProductionPlanFix.SpdMain_CellDoubleClick: 진입점 집계 — H6 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0024_ProductionPlanFix.SpdMain_Ce) |
| WK-SCP0024-0364 | M4 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 11: 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (11) |
| WK-SCP0024-0365 | M4 | SCP0024_ProductionPlanFix.SpdMain_CellDo | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0024_ProductionPlanFix.SpdMain_CellDoubleClick: 진입점 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0024_ProductionPlanFix.SpdMain_Ce) |

## W8 구현 후 검증 (4)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0024-0366 | G4 | 5 | 선행 W1 완료 후 E2E | G4 — 대조표 미구현 행  구현 후 검증 · 대상 5 |  | 1 (5) |
| WK-SCP0024-0367 | A1 | 5 | 선행 W1 완료 후 E2E | A1 — 대조표 미구현 행  구현 후 검증 · 대상 5 |  | 1 (5) |
| WK-SCP0024-0368 | G1 | 5 | 선행 W1 완료 후 E2E | G1 — 대조표 미구현 행  구현 후 검증 · 대상 5 |  | 1 (5) |
| WK-SCP0024-0369 | G6 | 5 | 선행 W1 완료 후 E2E | G6 — 대조표 미구현 행  구현 후 검증 · 대상 5 |  | 1 (5) |
