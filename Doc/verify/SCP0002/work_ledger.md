# 작업 원장 — SCP0002 · 2026-10-26 12:52

> 검사 인스턴스 398건 중 PASS·NA 14건 외 **384건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 7 | 구현 위치 실존 |
| W3 | 동작 수정 | 6 | 재판정 PASS |
| W4 | 검사기 구현 | 8 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 27 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 115 | 실행 → PASS |
| W7 | 기대값 확정 | 221 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 217 · E2E 115 · 하네스 35 · 대조표 11 · FE 6
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-LOC | GEN |  | 7 |  |  |  |  | 41 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-ROW | GEN |  |  | 3 |  |  |  | 29 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| C3 | CASCADE |  |  |  |  |  | 6 | 16 |  |  | 연쇄 자동 채움 |
| H2 | DESIGN |  |  |  |  |  | 4 | 16 |  |  | 배경·글자색 규칙 |
| H5 | DESIGN |  |  |  |  |  | 7 | 13 |  |  | 라벨 명칭 |
| A5 | DESIGN |  |  |  |  |  | 4 | 15 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| E4 | EDIT |  |  |  |  |  | 12 | 5 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| C2 | CASCADE |  |  |  |  |  | 6 | 10 |  |  | 그리드 셀 cascade 후보 |
| C6 | CASCADE |  |  |  |  |  | 6 | 10 |  |  | 무변경 편집 종료 시 연쇄 미발동 |
| D3 | EDIT |  |  |  |  |  | 6 | 10 |  |  | 행 값 기반 조건부 잠금 |
| D4 | EDIT |  |  |  |  |  | 6 | 10 |  |  | 신규행 기본값·자동세팅·Insert 전제 |
| D1 | EDIT |  |  |  |  |  | 6 | 9 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| G1 | GEN |  |  |  |  |  | 6 | 6 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| B4 | COMBO |  |  |  |  | 10 |  | 1 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| A1 | GEN |  |  |  |  |  |  | 11 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| C1 | CASCADE |  |  |  |  |  | 6 | 4 |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| D5 | EDIT |  |  |  |  |  | 6 | 3 |  |  | 셀 에디터 유형 |
| E1 | EDIT |  |  |  |  |  | 5 | 4 |  |  | 숫자 소수자리·정수·부호·범위 |
| B3 | COMBO |  |  |  | 8 |  |  |  |  |  | 콤보 후보 정렬 = AS-IS |
| B1 | COMBO |  |  |  |  | 5 |  | 1 |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 5 |  | 1 |  |  | 콤보 후보 중복 없음 |
| E5 | EDIT |  |  |  |  | 5 |  | 1 |  |  | 콤보 셀 후보 외 값 차단 |
| G4 | DESIGN |  |  |  |  |  | 6 |  |  |  | 조회조건 표시·라벨·활성 |
| G6 | GEN |  |  |  |  |  | 6 |  |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| X-REASON | DESIGN |  |  |  |  |  |  | 4 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| DB-SYN | DB |  |  | 3 |  |  |  |  |  |  | BE 계정 시노님·권한·대상 객체 |
| F4 | DB |  |  |  |  |  | 3 |  |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| A6 | GEN |  |  |  |  |  | 2 |  |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
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
| G03-WIRE | GEN |  |  |  |  |  |  | 1 |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |

## W2 구현 위치 확인 (7)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0002-0001 | X-LOC | COMMON:UC-02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-02) |
| WK-SCP0002-0002 | X-LOC | COMMON:UC-04 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-04) |
| WK-SCP0002-0003 | X-LOC | COMMON:UC-05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-05) |
| WK-SCP0002-0004 | X-LOC | COMMON:UC-07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-07) |
| WK-SCP0002-0005 | X-LOC | `SCP0002_GET_LINE_MASTER_OSP` (500, para | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`SCP0002_GET_LINE_MASTER_OSP` (500, para) |
| WK-SCP0002-0006 | X-LOC | `SCP0002_GET_LINE_MASTER` (424, params 7 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`SCP0002_GET_LINE_MASTER` (424, params 7) |
| WK-SCP0002-0007 | X-LOC | `SCP0002_SAVE_LINE_MASTER_OSP` (628, par | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`SCP0002_SAVE_LINE_MASTER_OSP` (628, par) |

## W3 동작 수정 (6)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0002-0008 | DB-SYN | PKG_SCP0002.P_SCP0002_GET_LINE_MASTER | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | DB-SYN FAIL 수정 — PKG_SCP0002.P_SCP0002_GET_LINE_MASTER: 시노님검사 SYN_MISSING |  | 5 (`SCP0002_GET_LINE_MASTER` (424, params 7) |
| WK-SCP0002-0009 | DB-SYN | PKG_SCP0002.P_SCP0002_GET_LINE_MASTER_OS | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | DB-SYN FAIL 수정 — PKG_SCP0002.P_SCP0002_GET_LINE_MASTER_OSP: 시노님검사 SYN_MISSING |  | 5 (`SCP0002_GET_LINE_MASTER_OSP` (500, para) |
| WK-SCP0002-0010 | DB-SYN | PKG_SCP0002.P_SCP0002_SAVE_LINE_MASTER_O | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | DB-SYN FAIL 수정 — PKG_SCP0002.P_SCP0002_SAVE_LINE_MASTER_OSP: 시노님검사 SYN_MISSING |  | 3 (`SCP0002_SAVE_LINE_MASTER_OSP` (628, par) |
| WK-SCP0002-0011 | X-ROW | SCP0002_LineMaster.FindData_Plant | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | X-ROW FAIL 수정 — SCP0002_LineMaster.FindData_Plant: 진입점 집계 11검사 — NOT_RUN:9 · REVIEW:1 · FAIL:1 |  | 8 (ACT:SCP0002_LineMaster.FindData_Plant:43) |
| WK-SCP0002-0012 | X-ROW | SCP0002_LineMaster.Find_Packer | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | X-ROW FAIL 수정 — SCP0002_LineMaster.Find_Packer: 진입점 집계 4검사 — NOT_RUN:2 · REVIEW:1 · FAIL:1 |  | 35 (ACT:SCP0002_LineMaster.Find_Packer ACT:S) |
| WK-SCP0002-0013 | X-ROW | SCP0002_LineMaster.Save_Data | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | X-ROW FAIL 수정 — SCP0002_LineMaster.Save_Data: 진입점 집계 10검사 — NOT_RUN:7 · FAIL:3 |  | 57 (ACT:SCP0002_LineMaster.Save_Data ACT:SCP) |

## W4 검사기 구현 (8)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0002-0014 | B3 | RACK_YN | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 RACK_YN | 있음(SHEET_COLUMNS) | 1 (2) |
| WK-SCP0002-0015 | B3 | SCS_PROD_AMEND | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 SCS_PROD_AMEND | 있음(SHEET_COLUMNS) | 1 (2) |
| WK-SCP0002-0016 | B3 | VALID_YN | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 VALID_YN | 있음(SHEET_COLUMNS) | 2 (1 2) |
| WK-SCP0002-0017 | B3 | cboDivision / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboDivision / Division | 있음(FE 소스) | 1 (1) |
| WK-SCP0002-0018 | B3 | cboValid / Valid / Active | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboValid / Valid / Active | 있음(FE 소스) | 1 (2) |
| WK-SCP0002-0019 | B3 | clbBuilding / Building | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbBuilding / Building | 있음(FE 소스) | 1 (5) |
| WK-SCP0002-0020 | B3 | clbLine / Line | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbLine / Line | 있음(FE 소스) | 1 (7) |
| WK-SCP0002-0021 | B3 | clbOperation / Operation | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbOperation / Operation | 있음(FE 소스) | 1 (6) |

## W5 검사기 연결 (27)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0002-0022 | B1 | NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL NAME | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0002-0023 | B1 | RACK_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL RACK_YN | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0002-0024 | B1 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 3 (23 COMMON:UC-05 ACT:SCP0002_LineMaster.I) |
| WK-SCP0002-0025 | B1 | SCS_PROD_AMEND | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL SCS_PROD_AMEND | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0002-0026 | B1 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0002-0027 | B2 | NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL NAME | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0002-0028 | B2 | RACK_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL RACK_YN | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0002-0029 | B2 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 3 (23 COMMON:UC-05 ACT:SCP0002_LineMaster.I) |
| WK-SCP0002-0030 | B2 | SCS_PROD_AMEND | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL SCS_PROD_AMEND | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0002-0031 | B2 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0002-0032 | B4 | NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL NAME | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0002-0033 | B4 | RACK_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL RACK_YN | 있음(SHEET_COLUMNS) | 2 (2 COMMON:UC-05) |
| WK-SCP0002-0034 | B4 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 3 (23 COMMON:UC-05 ACT:SCP0002_LineMaster.I) |
| WK-SCP0002-0035 | B4 | SCS_PROD_AMEND | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL SCS_PROD_AMEND | 있음(SHEET_COLUMNS) | 2 (2 COMMON:UC-05) |
| WK-SCP0002-0036 | B4 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 3 (1 2 COMMON:UC-05) |
| WK-SCP0002-0037 | B4 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (1) |
| WK-SCP0002-0038 | B4 | cboValid / Valid / Active | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboValid / Valid / Active | 있음(FE 소스) | 1 (2) |
| WK-SCP0002-0039 | B4 | clbBuilding / Building | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbBuilding / Building | 있음(FE 소스) | 1 (5) |
| WK-SCP0002-0040 | B4 | clbLine / Line | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbLine / Line | 있음(FE 소스) | 1 (7) |
| WK-SCP0002-0041 | B4 | clbOperation / Operation | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbOperation / Operation | 있음(FE 소스) | 1 (6) |
| WK-SCP0002-0042 | F2 | SCP0002 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0002 화면 | 판단불가(대상 단위 SCREEN) | 9 (`SCP0002_GET_LINE_MASTER` (424, params 7) |
| WK-SCP0002-0043 | F6 | SCP0002 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0002 화면 | 판단불가(대상 단위 SCREEN) | 5 (`SCP0002_SAVE_LINE_MASTER_OSP` (628, par) |
| WK-SCP0002-0044 | E5 | NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL NAME | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0002-0045 | E5 | RACK_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL RACK_YN | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0002-0046 | E5 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 2 (23 COMMON:UC-05) |
| WK-SCP0002-0047 | E5 | SCS_PROD_AMEND | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL SCS_PROD_AMEND | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |
| WK-SCP0002-0048 | E5 | VALID_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E5(_verify.spec(@verify)) → 대상 COL VALID_YN | 있음(SHEET_COLUMNS) | 1 (COMMON:UC-05) |

## W6 검증 실행 (115)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0002-0049 | J2 | SCP0002 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0002 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 23 (2 10 12 `SetDivisionAuthCheck(usrLayoutC) |
| WK-SCP0002-0050 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0002_LineMaster.InitControls:145:) |
| WK-SCP0002-0051 | C1 | cboValid / Valid / Active | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboValid / Valid / Active · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0002_LineMaster.InitControls:146:) |
| WK-SCP0002-0052 | C1 | clbBuilding / Building | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbBuilding / Building · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0002_LineMaster.RefreshBuildingBy) |
| WK-SCP0002-0053 | C1 | clbLine / Line | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbLine / Line · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:SCP0002_LineMaster.RefreshLine:205:1) |
| WK-SCP0002-0054 | C1 | clbOperation / Operation | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbOperation / Operation · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0002_LineMaster.RefreshOperationB) |
| WK-SCP0002-0055 | C1 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:SCP0002_LineMaster.RefreshPlantSiteB) |
| WK-SCP0002-0056 | C2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (ACT:SCP0002_LineMaster.SpdMain_ComboSelC) |
| WK-SCP0002-0057 | C2 | NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCP0002_LineMaster.InitControls:145:) |
| WK-SCP0002-0058 | C2 | OPERATION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — OPERATION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 10 (2·3 8·9 ACT:SCP0002_LineMaster.SpdMain_C) |
| WK-SCP0002-0059 | C2 | RACK_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — RACK_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCP0002_LineMaster.SpdMain_ComboSelC) |
| WK-SCP0002-0060 | C2 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 22 (2·3 ACT:SCP0002_LineMaster.SpdMain_Combo) |
| WK-SCP0002-0061 | C2 | SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (2·3 8·9 ACT:SCP0002_LineMaster.SpdMain_C) |
| WK-SCP0002-0062 | C3 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 12 (ACT:SCP0002_LineMaster.SetChangedControl) |
| WK-SCP0002-0063 | C3 | NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 9 (ACT:SCP0002_LineMaster.SetChangedControl) |
| WK-SCP0002-0064 | C3 | OPERATION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — OPERATION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 14 (2·3 8·9 ACT:SCP0002_LineMaster.SpdMain_C) |
| WK-SCP0002-0065 | C3 | RACK_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — RACK_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SCP0002_LineMaster.SpdMain_ComboSelC) |
| WK-SCP0002-0066 | C3 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 27 (2·3 ACT:SCP0002_LineMaster.SpdMain_Clipb) |
| WK-SCP0002-0067 | C3 | SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 12 (2·3 8·9 ACT:SCP0002_LineMaster.SetSpread) |
| WK-SCP0002-0068 | C6 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (ACT:SCP0002_LineMaster.SpdMain_ComboSelC) |
| WK-SCP0002-0069 | C6 | NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0002_LineMaster.SpdMain_ComboSelC) |
| WK-SCP0002-0070 | C6 | OPERATION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — OPERATION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 10 (2·3 8·9 ACT:SCP0002_LineMaster.SpdMain_C) |
| WK-SCP0002-0071 | C6 | RACK_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — RACK_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCP0002_LineMaster.SpdMain_ComboSelC) |
| WK-SCP0002-0072 | C6 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 22 (2·3 ACT:SCP0002_LineMaster.SpdMain_Combo) |
| WK-SCP0002-0073 | C6 | SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (2·3 8·9 ACT:SCP0002_LineMaster.SpdMain_C) |
| WK-SCP0002-0074 | G3 | SCP0002 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0002 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 7 (`SetDivisionAuthCheck(usrLayoutControl2)) |
| WK-SCP0002-0075 | K-SA | SCP0002 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCP0002 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 3 (`SetDivisionAuthCheck(usrLayoutControl2)) |
| WK-SCP0002-0076 | K4 | SCP0002 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0002 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 5 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-04 C) |
| WK-SCP0002-0077 | F1 | SCP0002 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0002 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 24 (27 28 29 30 31 `SCP0002_GET_LINE_MASTER`) |
| WK-SCP0002-0078 | F3 | SCP0002 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F3 실행 — SCP0002 화면 · 검사기 있음(_trace.spec(@trace) W4b 붙여넣기 — Ctrl+C/Ctrl+V 로 셀 값 복사 후 값·연쇄) — 실행 필요: trace |  | 20 (10 11 8·9 10·11 ACT:SCP0002_LineMaster.S) |
| WK-SCP0002-0079 | F5 | SCP0002 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0002 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 15 (27 28 29 30 31 ACT:SCP0002_LineMaster.De) |
| WK-SCP0002-0080 | F4 | PKG_SCP0002.P_SCP0002_GET_LINE_MASTER | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0002.P_SCP0002_GET_LINE_MASTER · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: sm |  | 47 (`SCP0002_GET_LINE_MASTER` (424, params 7) |
| WK-SCP0002-0081 | F4 | PKG_SCP0002.P_SCP0002_GET_LINE_MASTER_OS | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0002.P_SCP0002_GET_LINE_MASTER_OSP · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요 |  | 11 (`SCP0002_GET_LINE_MASTER_OSP` (500, para) |
| WK-SCP0002-0082 | F4 | PKG_SCP0002.P_SCP0002_SAVE_LINE_MASTER_O | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0002.P_SCP0002_SAVE_LINE_MASTER_OSP · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필 |  | 7 (`SCP0002_SAVE_LINE_MASTER_OSP` (628, par) |
| WK-SCP0002-0083 | A5 | RACK_YN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — RACK_YN · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (2) |
| WK-SCP0002-0084 | A5 | SCS_PROD_AMEND | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SCS_PROD_AMEND · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (2) |
| WK-SCP0002-0085 | A5 | SITE_DESCRIPTION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCP0002_LineMaster.SetSpreadInit ACT) |
| WK-SCP0002-0086 | A5 | VALID_YN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (2) |
| WK-SCP0002-0087 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (조회조건 6 (`cboDivision`, `cboValid`, `clbP) |
| WK-SCP0002-0088 | G4 | cboValid / Valid / Active | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboValid / Valid / Active · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (2 조회조건 6 (`cboDivision`, `cboValid`, `cl) |
| WK-SCP0002-0089 | G4 | clbBuilding / Building | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbBuilding / Building · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (조회조건 6 (`cboDivision`, `cboValid`, `clbP) |
| WK-SCP0002-0090 | G4 | clbLine / Line | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbLine / Line · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (조회조건 6 (`cboDivision`, `cboValid`, `clbP) |
| WK-SCP0002-0091 | G4 | clbOperation / Operation | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbOperation / Operation · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (조회조건 6 (`cboDivision`, `cboValid`, `clbP) |
| WK-SCP0002-0092 | G4 | clbPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbPlantSite / Plant Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (조회조건 6 (`cboDivision`, `cboValid`, `clbP) |
| WK-SCP0002-0093 | H2 | RACK_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — RACK_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (2) |
| WK-SCP0002-0094 | H2 | SCS_PROD_AMEND | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SCS_PROD_AMEND · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (2) |
| WK-SCP0002-0095 | H2 | SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0002_LineMaster.SetSpreadInit ACT) |
| WK-SCP0002-0096 | H2 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (2 `SetDivisionAuthCheck(usrLayoutControl) |
| WK-SCP0002-0097 | H5 | RACK_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — RACK_YN · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (2) |
| WK-SCP0002-0098 | H5 | SCS_PROD_AMEND | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SCS_PROD_AMEND · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (2) |
| WK-SCP0002-0099 | H5 | SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SITE_DESCRIPTION · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCP0002_LineMaster.SetSpreadInit ACT) |
| WK-SCP0002-0100 | H5 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — VALID_YN · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (2) |
| WK-SCP0002-0101 | H5 | cboValid / Valid / Active | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — cboValid / Valid / Active · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trac |  | 1 (2) |
| WK-SCP0002-0102 | H5 | clbLine / Line | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — clbLine / Line · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (7 8) |
| WK-SCP0002-0103 | H5 | clbPlantSite / Plant Site | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — clbPlantSite / Plant Site · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trac |  | 2 (4 —) |
| WK-SCP0002-0104 | I1 | SCP0002 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0002 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 6 (`SetDivisionAuthCheck(usrLayoutControl2)) |
| WK-SCP0002-0105 | SC1 | SCP0002 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SCP0002 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 3 (2 조회조건 6 (`cboDivision`, `cboValid`, `cl) |
| WK-SCP0002-0106 | D1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 5 (13 19 ACT:SCP0002_LineMaster.EditButton ) |
| WK-SCP0002-0107 | D1 | LINE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LINE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (13 ACT:SCP0002_LineMaster.EditButton:379) |
| WK-SCP0002-0108 | D1 | OPERATION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — OPERATION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 5 (14 20 ACT:SCP0002_LineMaster.EditButton ) |
| WK-SCP0002-0109 | D1 | RACK_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — RACK_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (15 ACT:SCP0002_LineMaster.EditButton ACT) |
| WK-SCP0002-0110 | D1 | SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (18 ACT:SCP0002_LineMaster.Insert_Row:615) |
| WK-SCP0002-0111 | D1 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (`SetDivisionAuthCheck(usrLayoutControl2)) |
| WK-SCP0002-0112 | D3 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 5 (13 19 ACT:SCP0002_LineMaster.EditButton ) |
| WK-SCP0002-0113 | D3 | LINE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LINE_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (13 ACT:SCP0002_LineMaster.EditButton:379) |
| WK-SCP0002-0114 | D3 | OPERATION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — OPERATION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 5 (14 20 ACT:SCP0002_LineMaster.EditButton ) |
| WK-SCP0002-0115 | D3 | RACK_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — RACK_YN · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (15 ACT:SCP0002_LineMaster.EditButton ACT) |
| WK-SCP0002-0116 | D3 | SITE_DESCRIPTION | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — SITE_DESCRIPTION · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (18 ACT:SCP0002_LineMaster.Insert_Row:615) |
| WK-SCP0002-0117 | D3 | VALID_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — VALID_YN · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (`SetDivisionAuthCheck(usrLayoutControl2)) |
| WK-SCP0002-0118 | D4 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 0 () |
| WK-SCP0002-0119 | D4 | OPERATION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — OPERATION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 3 (2·3 4·5 8·9) |
| WK-SCP0002-0120 | D4 | RACK_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — RACK_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 0 () |
| WK-SCP0002-0121 | D4 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 2 (2·3 23) |
| WK-SCP0002-0122 | D4 | SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 3 (2·3 4·5 8·9) |
| WK-SCP0002-0123 | D4 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 0 () |
| WK-SCP0002-0124 | D5 | NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (COMMON:UC-05) |
| WK-SCP0002-0125 | D5 | RACK_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — RACK_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (COMMON:UC-05) |
| WK-SCP0002-0126 | D5 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (23 COMMON:UC-05 ACT:SCP0002_LineMaster.I) |
| WK-SCP0002-0127 | D5 | SCS_PROD_AMEND | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SCS_PROD_AMEND · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (COMMON:UC-05) |
| WK-SCP0002-0128 | D5 | SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCP0002_LineMaster.SetSpreadInit ACT) |
| WK-SCP0002-0129 | D5 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (COMMON:UC-05) |
| WK-SCP0002-0130 | D6 | SCP0002 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0002 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 9 (23 27 28 29 30 31 COMMON:UC-01 ACT:SCP00) |
| WK-SCP0002-0131 | E1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 4 (ACT:SCP0002_LineMaster.SpdMain_Clipboard) |
| WK-SCP0002-0132 | E1 | NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 3 (ACT:SCP0002_LineMaster.SpdMain_Clipboard) |
| WK-SCP0002-0133 | E1 | OPERATION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — OPERATION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 5 (8·9 ACT:SCP0002_LineMaster.SpdMain_Clipb) |
| WK-SCP0002-0134 | E1 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 5 (ACT:SCP0002_LineMaster.SpdMain_Clipboard) |
| WK-SCP0002-0135 | E1 | SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 5 (8·9 ACT:SCP0002_LineMaster.SpdMain_Clipb) |
| WK-SCP0002-0136 | E4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0002_LineMaster.SetChangedControl) |
| WK-SCP0002-0137 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (COMMON:UC-04 ACT:SCP0002_LineMaster.Save) |
| WK-SCP0002-0138 | E4 | MSG00006 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00006 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0002_LineMaster.Save_Data:714:56) |
| WK-SCP0002-0139 | E4 | MSG00097 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00097 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (`SetDivisionAuthCheck(usrLayoutControl2)) |
| WK-SCP0002-0140 | E4 | MSG00109 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00109 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (COMMON:UC-04 ACT:SCP0002_LineMaster.Edit) |
| WK-SCP0002-0141 | E4 | MSG00429 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00429 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-04) |
| WK-SCP0002-0142 | E4 | MSG00703 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00703 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-02) |
| WK-SCP0002-0143 | E4 | NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — NAME · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SCP0002_LineMaster.SetChangedControl) |
| WK-SCP0002-0144 | E4 | SITE_DESCRIPTION | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — SITE_DESCRIPTION · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0002_LineMaster.SetSpreadInit ACT) |
| WK-SCP0002-0145 | E4 | VALID_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — VALID_YN · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (`SetDivisionAuthCheck(usrLayoutControl2)) |
| WK-SCP0002-0146 | E4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 2 (ACT:SCP0002_LineMaster.SetChangedControl) |
| WK-SCP0002-0147 | E4 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실 |  | 2 (ACT:SCP0002_LineMaster.SetChangedControl) |
| WK-SCP0002-0148 | A10 | SCP0002 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0002 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 29 (ACT:SCP0002_LineMaster.DefineProperty AC) |
| WK-SCP0002-0149 | A6 | PKG_SCP0002.P_SCP0002_GET_LINE_MASTER | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0002.P_SCP0002_GET_LINE_MASTER · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _ |  | 42 (`SCP0002_GET_LINE_MASTER` (424, params 7) |
| WK-SCP0002-0150 | A6 | PKG_SCP0002.P_SCP0002_GET_LINE_MASTER_OS | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0002.P_SCP0002_GET_LINE_MASTER_OSP · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) |  | 3 (`SCP0002_GET_LINE_MASTER_OSP` (500, para) |
| WK-SCP0002-0151 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (조회조건 6 (`cboDivision`, `cboValid`, `clbP) |
| WK-SCP0002-0152 | G1 | cboValid / Valid / Active | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboValid / Valid / Active · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (2 조회조건 6 (`cboDivision`, `cboValid`, `cl) |
| WK-SCP0002-0153 | G1 | clbBuilding / Building | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbBuilding / Building · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (조회조건 6 (`cboDivision`, `cboValid`, `clbP) |
| WK-SCP0002-0154 | G1 | clbLine / Line | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbLine / Line · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (조회조건 6 (`cboDivision`, `cboValid`, `clbP) |
| WK-SCP0002-0155 | G1 | clbOperation / Operation | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbOperation / Operation · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (조회조건 6 (`cboDivision`, `cboValid`, `clbP) |
| WK-SCP0002-0156 | G1 | clbPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbPlantSite / Plant Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (조회조건 6 (`cboDivision`, `cboValid`, `clbP) |
| WK-SCP0002-0157 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (조회조건 6 (`cboDivision`, `cboValid`, `clbP) |
| WK-SCP0002-0158 | G6 | cboValid / Valid / Active | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboValid / Valid / Active · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (2 조회조건 6 (`cboDivision`, `cboValid`, `cl) |
| WK-SCP0002-0159 | G6 | clbBuilding / Building | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbBuilding / Building · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (조회조건 6 (`cboDivision`, `cboValid`, `clbP) |
| WK-SCP0002-0160 | G6 | clbLine / Line | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbLine / Line · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (조회조건 6 (`cboDivision`, `cboValid`, `clbP) |
| WK-SCP0002-0161 | G6 | clbOperation / Operation | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbOperation / Operation · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (조회조건 6 (`cboDivision`, `cboValid`, `clbP) |
| WK-SCP0002-0162 | G6 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (조회조건 6 (`cboDivision`, `cboValid`, `clbP) |
| WK-SCP0002-0163 | X-REOPEN | SCP0002 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0002 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 7 (ACT:SCP0002_LineMaster.Dispose ACT:SCP00) |

## W7 기대값 확정 (221)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0002-0164 | C1 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 6: 행 집계 — C1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0002-0165 | C1 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 7: 행 집계 — C1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0002-0166 | C1 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 8: 행 집계 — C1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0002-0167 | C1 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 9: 행 집계 — C1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0002-0168 | C2 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — 11: 행 집계 — C2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (11) |
| WK-SCP0002-0169 | C2 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — 7: 행 집계 — C2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0002-0170 | C2 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — 8: 행 집계 — C2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0002-0171 | C2 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — 9: 행 집계 — C2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (9) |
| WK-SCP0002-0172 | C2 | SCP0002_LineMaster.ClbBuilding_SelectedI | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0002_LineMaster.ClbBuilding_SelectedIndexChange: 진입점 집계 — C2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0002_LineMaster.ClbBuilding_Selec) |
| WK-SCP0002-0173 | C2 | SCP0002_LineMaster.ClbDivision_SelectedI | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0002_LineMaster.ClbDivision_SelectedIndexChange: 진입점 집계 — C2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0002_LineMaster.ClbDivision_Selec) |
| WK-SCP0002-0174 | C2 | SCP0002_LineMaster.ClbOperation_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0002_LineMaster.ClbOperation_SelectedIndexChang: 진입점 집계 — C2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0002_LineMaster.ClbOperation_Sele) |
| WK-SCP0002-0175 | C2 | SCP0002_LineMaster.ClbPlantSite_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0002_LineMaster.ClbPlantSite_SelectedIndexChang: 진입점 집계 — C2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0002_LineMaster.ClbPlantSite_Sele) |
| WK-SCP0002-0176 | C2 | SCP0002_LineMaster.SpdMain_ActiveSheetCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0002_LineMaster.SpdMain_ActiveSheetChanged: 진입점 집계 — C2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0002_LineMaster.SpdMain_ActiveShe) |
| WK-SCP0002-0177 | C2 | SCP0002_LineMaster.SpdMain_ComboSelChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0002_LineMaster.SpdMain_ComboSelChange: 진입점 집계 — C2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0002_LineMaster.SpdMain_ComboSelC) |
| WK-SCP0002-0178 | C3 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — 10: 행 집계 — C3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (10) |
| WK-SCP0002-0179 | C3 | 10·11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — 10·11: 행 집계 — C3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (10·11) |
| WK-SCP0002-0180 | C3 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — 11: 행 집계 — C3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (11) |
| WK-SCP0002-0181 | C3 | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — 12: 행 집계 — C3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0002-0182 | C3 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — 7: 행 집계 — C3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0002-0183 | C3 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — 8: 행 집계 — C3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0002-0184 | C3 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — 9: 행 집계 — C3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (9) |
| WK-SCP0002-0185 | C3 | SCP0002_LineMaster.ClbBuilding_SelectedI | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0002_LineMaster.ClbBuilding_SelectedIndexChange: 진입점 집계 — C3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0002_LineMaster.ClbBuilding_Selec) |
| WK-SCP0002-0186 | C3 | SCP0002_LineMaster.ClbDivision_SelectedI | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0002_LineMaster.ClbDivision_SelectedIndexChange: 진입점 집계 — C3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0002_LineMaster.ClbDivision_Selec) |
| WK-SCP0002-0187 | C3 | SCP0002_LineMaster.ClbOperation_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0002_LineMaster.ClbOperation_SelectedIndexChang: 진입점 집계 — C3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0002_LineMaster.ClbOperation_Sele) |
| WK-SCP0002-0188 | C3 | SCP0002_LineMaster.ClbPlantSite_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0002_LineMaster.ClbPlantSite_SelectedIndexChang: 진입점 집계 — C3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0002_LineMaster.ClbPlantSite_Sele) |
| WK-SCP0002-0189 | C3 | SCP0002_LineMaster.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0002_LineMaster.SetChangedControl: 진입점 집계 — C3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0002_LineMaster.SetChangedControl) |
| WK-SCP0002-0190 | C3 | SCP0002_LineMaster.SetChangedControl_Osp | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0002_LineMaster.SetChangedControl_Osp: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0002_LineMaster.SetChangedControl) |
| WK-SCP0002-0191 | C3 | SCP0002_LineMaster.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0002_LineMaster.SetSpreadInit: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0002_LineMaster.SetSpreadInit:277) |
| WK-SCP0002-0192 | C3 | SCP0002_LineMaster.SpdMain_ActiveSheetCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0002_LineMaster.SpdMain_ActiveSheetChanged: 진입점 집계 — C3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0002_LineMaster.SpdMain_ActiveShe) |
| WK-SCP0002-0193 | C3 | SCP0002_LineMaster.SpdMain_ComboSelChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0002_LineMaster.SpdMain_ComboSelChange: 진입점 집계 — C3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0002_LineMaster.SpdMain_ComboSelC) |
| WK-SCP0002-0194 | C6 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — 11: 행 집계 — C6 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (11) |
| WK-SCP0002-0195 | C6 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — 7: 행 집계 — C6 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0002-0196 | C6 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — 8: 행 집계 — C6 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0002-0197 | C6 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — 9: 행 집계 — C6 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (9) |
| WK-SCP0002-0198 | C6 | SCP0002_LineMaster.ClbBuilding_SelectedI | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0002_LineMaster.ClbBuilding_SelectedIndexChange: 진입점 집계 — C6 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0002_LineMaster.ClbBuilding_Selec) |
| WK-SCP0002-0199 | C6 | SCP0002_LineMaster.ClbDivision_SelectedI | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0002_LineMaster.ClbDivision_SelectedIndexChange: 진입점 집계 — C6 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0002_LineMaster.ClbDivision_Selec) |
| WK-SCP0002-0200 | C6 | SCP0002_LineMaster.ClbOperation_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0002_LineMaster.ClbOperation_SelectedIndexChang: 진입점 집계 — C6 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0002_LineMaster.ClbOperation_Sele) |
| WK-SCP0002-0201 | C6 | SCP0002_LineMaster.ClbPlantSite_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0002_LineMaster.ClbPlantSite_SelectedIndexChang: 진입점 집계 — C6 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0002_LineMaster.ClbPlantSite_Sele) |
| WK-SCP0002-0202 | C6 | SCP0002_LineMaster.SpdMain_ActiveSheetCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0002_LineMaster.SpdMain_ActiveSheetChanged: 진입점 집계 — C6 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0002_LineMaster.SpdMain_ActiveShe) |
| WK-SCP0002-0203 | C6 | SCP0002_LineMaster.SpdMain_ComboSelChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0002_LineMaster.SpdMain_ComboSelChange: 진입점 집계 — C6 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0002_LineMaster.SpdMain_ComboSelC) |
| WK-SCP0002-0204 | B1 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — 3: 행 집계 — B1 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (3) |
| WK-SCP0002-0205 | B2 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — 3: 행 집계 — B2 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (3) |
| WK-SCP0002-0206 | B4 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — 3: 행 집계 — B4 10요소: NOPATH:10 (미실행 요소가 남아 판정필요) |  | 1 (3) |
| WK-SCP0002-0207 | A5 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 1: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0002-0208 | A5 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 10: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0002-0209 | A5 | 16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 16: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (16) |
| WK-SCP0002-0210 | A5 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 2: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0002-0211 | A5 | 25 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 25: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (25) |
| WK-SCP0002-0212 | A5 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 4: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (4) |
| WK-SCP0002-0213 | A5 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 6: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0002-0214 | A5 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 7: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (7) |
| WK-SCP0002-0215 | A5 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 8: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (8) |
| WK-SCP0002-0216 | A5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-07: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0002-0217 | A5 | Layout 11 (`usrLayoutControl1/2`, `layou | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — Layout 11 (`usrLayoutControl1/2`, `layoutControlGr: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (Layout 11 (`usrLayoutControl1/2`, `layou) |
| WK-SCP0002-0218 | A5 | SCP0002_LineMaster.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0002_LineMaster.CreateSpread: 진입점 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0002_LineMaster.CreateSpread:255:) |
| WK-SCP0002-0219 | A5 | SCP0002_LineMaster.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0002_LineMaster.SetSpreadInit: 진입점 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0002_LineMaster.SetSpreadInit:277) |
| WK-SCP0002-0220 | A5 | — | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — —: 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (—) |
| WK-SCP0002-0221 | A5 | 그리드 3 (`spdMain`, `spdMain_Sheet1`, Pack | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 그리드 3 (`spdMain`, `spdMain_Sheet1`, Packer 런타임 시트): 행 집계 — A5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (그리드 3 (`spdMain`, `spdMain_Sheet1`, Pack) |
| WK-SCP0002-0222 | H2 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 1: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0002-0223 | H2 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 10: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0002-0224 | H2 | 16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 16: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (16) |
| WK-SCP0002-0225 | H2 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 2: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0002-0226 | H2 | 25 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 25: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (25) |
| WK-SCP0002-0227 | H2 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 4: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (4) |
| WK-SCP0002-0228 | H2 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 6: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0002-0229 | H2 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 7: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (7) |
| WK-SCP0002-0230 | H2 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 8: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (8) |
| WK-SCP0002-0231 | H2 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-07: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0002-0232 | H2 | Layout 11 (`usrLayoutControl1/2`, `layou | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — Layout 11 (`usrLayoutControl1/2`, `layoutControlGr: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (Layout 11 (`usrLayoutControl1/2`, `layou) |
| WK-SCP0002-0233 | H2 | SCP0002_LineMaster.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0002_LineMaster.CreateSpread: 진입점 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0002_LineMaster.CreateSpread:255:) |
| WK-SCP0002-0234 | H2 | SCP0002_LineMaster.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0002_LineMaster.SetSpreadInit: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0002_LineMaster.SetSpreadInit:277) |
| WK-SCP0002-0235 | H2 | — | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — —: 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (—) |
| WK-SCP0002-0236 | H2 | 그리드 3 (`spdMain`, `spdMain_Sheet1`, Pack | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 그리드 3 (`spdMain`, `spdMain_Sheet1`, Packer 런타임 시트): 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (그리드 3 (`spdMain`, `spdMain_Sheet1`, Pack) |
| WK-SCP0002-0237 | H2 | 브라우저 시각·조작감(셀 색/드롭다운/토스트/freeze) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 브라우저 시각·조작감(셀 색/드롭다운/토스트/freeze): 행 집계 — H2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (브라우저 시각·조작감(셀 색/드롭다운/토스트/freeze)) |
| WK-SCP0002-0238 | H5 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 1: 행 집계 — H5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0002-0239 | H5 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 10: 행 집계 — H5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0002-0240 | H5 | 16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 16: 행 집계 — H5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (16) |
| WK-SCP0002-0241 | H5 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 2: 행 집계 — H5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0002-0242 | H5 | 25 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 25: 행 집계 — H5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (25) |
| WK-SCP0002-0243 | H5 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 4: 행 집계 — H5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0002-0244 | H5 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 6: 행 집계 — H5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0002-0245 | H5 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 8: 행 집계 — H5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0002-0246 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0002-0247 | H5 | Layout 11 (`usrLayoutControl1/2`, `layou | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — Layout 11 (`usrLayoutControl1/2`, `layoutControlGr: 행 집계 — H5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (Layout 11 (`usrLayoutControl1/2`, `layou) |
| WK-SCP0002-0248 | H5 | SCP0002_LineMaster.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0002_LineMaster.CreateSpread: 진입점 집계 — H5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0002_LineMaster.CreateSpread:255:) |
| WK-SCP0002-0249 | H5 | SCP0002_LineMaster.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0002_LineMaster.SetSpreadInit: 진입점 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0002_LineMaster.SetSpreadInit:277) |
| WK-SCP0002-0250 | H5 | 그리드 3 (`spdMain`, `spdMain_Sheet1`, Pack | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 그리드 3 (`spdMain`, `spdMain_Sheet1`, Packer 런타임 시트): 행 집계 — H5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (그리드 3 (`spdMain`, `spdMain_Sheet1`, Pack) |
| WK-SCP0002-0251 | X-REASON | 1 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 1 MyDivision (Data.Common) cboDivision `COMBO.DIVISION='MyDivision'` + 화면 ATTRIBUTE3<>'EE' + VALID_YN='Y' 필터 구현 |  | 0 () |
| WK-SCP0002-0252 | X-REASON | COMMON:UC-03 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-03 Column 설정 적용 시 Reset 후 재조회 해당없음 — 이 화면 Column Settings UI 없음(`layoutKey` 미전달). Measure `SCM_MST_SH |  | 1 (COMMON:UC-03) |
| WK-SCP0002-0253 | X-REASON | COMMON:UC-06 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-06 Key-in 콤마 다중조회 해당없음 — 조회조건 전부 드롭다운(단일 Division/Valid + 다중 PlantSite/Building/Operation/Line). 텍스트  |  | 1 (COMMON:UC-06) |
| WK-SCP0002-0254 | X-REASON | static 3 (`components`, `imageList1`, `e | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — static 3 (`components`, `imageList1`, `emptySpaceItem`) 비시각 — 매핑 대상 아님 해당없음 |  | 1 (static 3 (`components`, `imageList1`, `e) |
| WK-SCP0002-0255 | D1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 1: 행 집계 — D1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0002-0256 | D1 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 10: 행 집계 — D1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (10) |
| WK-SCP0002-0257 | D1 | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 12: 행 집계 — D1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (12) |
| WK-SCP0002-0258 | D1 | 16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 16: 행 집계 — D1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (16) |
| WK-SCP0002-0259 | D1 | 17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 17: 행 집계 — D1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (17) |
| WK-SCP0002-0260 | D1 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 2: 행 집계 — D1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0002-0261 | D1 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 4: 행 집계 — D1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0002-0262 | D1 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 7: 행 집계 — D1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0002-0263 | D1 | SCP0002_LineMaster.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SCP0002_LineMaster.EditButton: 진입점 집계 — D1 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0002_LineMaster.EditButton:366:1 ) |
| WK-SCP0002-0264 | D3 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 1: 행 집계 — D3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0002-0265 | D3 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 10: 행 집계 — D3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (10) |
| WK-SCP0002-0266 | D3 | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 12: 행 집계 — D3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (12) |
| WK-SCP0002-0267 | D3 | 16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 16: 행 집계 — D3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (16) |
| WK-SCP0002-0268 | D3 | 17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 17: 행 집계 — D3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (17) |
| WK-SCP0002-0269 | D3 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 2: 행 집계 — D3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0002-0270 | D3 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 4: 행 집계 — D3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0002-0271 | D3 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 7: 행 집계 — D3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0002-0272 | D3 | Layout 11 (`usrLayoutControl1/2`, `layou | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — Layout 11 (`usrLayoutControl1/2`, `layoutControlGr: 행 집계 — D3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (Layout 11 (`usrLayoutControl1/2`, `layou) |
| WK-SCP0002-0273 | D3 | SCP0002_LineMaster.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SCP0002_LineMaster.EditButton: 진입점 집계 — D3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0002_LineMaster.EditButton:366:1 ) |
| WK-SCP0002-0274 | D4 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — 1: 행 집계 — D4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0002-0275 | D4 | 10·11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — 10·11: 행 집계 — D4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (10·11) |
| WK-SCP0002-0276 | D4 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — 2: 행 집계 — D4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0002-0277 | D4 | 27 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — 27: 행 집계 — D4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (27) |
| WK-SCP0002-0278 | D4 | 28 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — 28: 행 집계 — D4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (28) |
| WK-SCP0002-0279 | D4 | 29 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — 29: 행 집계 — D4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (29) |
| WK-SCP0002-0280 | D4 | 30 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — 30: 행 집계 — D4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (30) |
| WK-SCP0002-0281 | D4 | 31 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — 31: 행 집계 — D4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (31) |
| WK-SCP0002-0282 | D4 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — 5: 행 집계 — D4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0002-0283 | D4 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — COMMON:UC-01: 행 집계 — D4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SCP0002-0284 | D5 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — 3: 행 집계 — D5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (3) |
| WK-SCP0002-0285 | D5 | SCP0002_LineMaster.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0002_LineMaster.CreateSpread: 진입점 집계 — D5 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0002_LineMaster.CreateSpread:255:) |
| WK-SCP0002-0286 | D5 | SCP0002_LineMaster.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0002_LineMaster.SetSpreadInit: 진입점 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0002_LineMaster.SetSpreadInit:277) |
| WK-SCP0002-0287 | E1 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E1 기대값 확정 — 10: 행 집계 — E1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (10) |
| WK-SCP0002-0288 | E1 | 10·11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E1 기대값 확정 — 10·11: 행 집계 — E1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (10·11) |
| WK-SCP0002-0289 | E1 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E1 기대값 확정 — 11: 행 집계 — E1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (11) |
| WK-SCP0002-0290 | E1 | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E1 기대값 확정 — 12: 행 집계 — E1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0002-0291 | E4 | SCP0002_LineMaster.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0002_LineMaster.SetChangedControl: 진입점 집계 — E4 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0002_LineMaster.SetChangedControl) |
| WK-SCP0002-0292 | E4 | SCP0002_LineMaster.SetChangedControl_Osp | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0002_LineMaster.SetChangedControl_Osp: 진입점 집계 — E4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0002_LineMaster.SetChangedControl) |
| WK-SCP0002-0293 | E4 | SCP0002_LineMaster.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0002_LineMaster.SetSpreadInit: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0002_LineMaster.SetSpreadInit:277) |
| WK-SCP0002-0294 | E4 | `SCP0002_SAVE_LINE_MASTER_OSP` (628, par | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — `SCP0002_SAVE_LINE_MASTER_OSP` (628, params 8, I/M: 행 집계 — E4 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (`SCP0002_SAVE_LINE_MASTER_OSP` (628, par) |
| WK-SCP0002-0295 | E4 | 브라우저 시각·조작감(셀 색/드롭다운/토스트/freeze) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 브라우저 시각·조작감(셀 색/드롭다운/토스트/freeze): 행 집계 — E4 12요소: NOT_RUN:12 (미실행 요소가 남아 판정필요) |  | 1 (브라우저 시각·조작감(셀 색/드롭다운/토스트/freeze)) |
| WK-SCP0002-0296 | E5 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E5 기대값 확정 — 3: 행 집계 — E5 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (3) |
| WK-SCP0002-0297 | A1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1: 행 집계 — A1 2요소: REVIEW:2 |  | 0 () |
| WK-SCP0002-0298 | A1 | 16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 16: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (16) |
| WK-SCP0002-0299 | A1 | 17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 17: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (17) |
| WK-SCP0002-0300 | A1 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 2: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (2) |
| WK-SCP0002-0301 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (COMMON:UC-02) |
| WK-SCP0002-0302 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (COMMON:UC-07) |
| WK-SCP0002-0303 | A1 | PKG_SCP0002.P_SCP0002_GET_LINE_MASTER | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0002.P_SCP0002_GET_LINE_MASTER: 골든 비교 케이스 없음(PKG_SCP0002.P_SCP0002_GET_LINE_MASTER — 팝업·보조 SP 는 golden_cases.cs |  | 42 (`SCP0002_GET_LINE_MASTER` (424, params 7) |
| WK-SCP0002-0304 | A1 | PKG_SCP0002.P_SCP0002_GET_LINE_MASTER_OS | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0002.P_SCP0002_GET_LINE_MASTER_OSP: 골든 비교 케이스 없음(PKG_SCP0002.P_SCP0002_GET_LINE_MASTER_OSP — 팝업·보조 SP 는 golden_ |  | 4 (`SCP0002_GET_LINE_MASTER_OSP` (500, para) |
| WK-SCP0002-0305 | A1 | `SetDivisionAuthCheck(usrLayoutControl2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `SetDivisionAuthCheck(usrLayoutControl2)` (cs:142~: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (`SetDivisionAuthCheck(usrLayoutControl2)) |
| WK-SCP0002-0306 | A1 | — | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — —: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (—) |
| WK-SCP0002-0307 | A1 | 조회조건 6 (`cboDivision`, `cboValid`, `clbP | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 조회조건 6 (`cboDivision`, `cboValid`, `clbPlantSite`,: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (조회조건 6 (`cboDivision`, `cboValid`, `clbP) |
| WK-SCP0002-0308 | G03-WIRE | SCP0002 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G03-WIRE 기대값 확정 — SCP0002 화면: 게이트 G03 As-is 이벤트 this.Load → Form_Load 매핑표 §2 에 / 게이트 G03 As-is 이벤트 cboDivision.SelectedIndexChang  |  | 11 (ACT:SCP0002_LineMaster..ctor ACT:SCP0002) |
| WK-SCP0002-0309 | G1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 1: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0002-0310 | G1 | 16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 16: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (16) |
| WK-SCP0002-0311 | G1 | 17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 17: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (17) |
| WK-SCP0002-0312 | G1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-02: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0002-0313 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0002-0314 | G1 | `SetDivisionAuthCheck(usrLayoutControl2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `SetDivisionAuthCheck(usrLayoutControl2)` (cs:142~: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (`SetDivisionAuthCheck(usrLayoutControl2)) |
| WK-SCP0002-0315 | X-LOC | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (1) |
| WK-SCP0002-0316 | X-LOC | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 10: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (10) |
| WK-SCP0002-0317 | X-LOC | 10·11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 10·11: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (10·11) |
| WK-SCP0002-0318 | X-LOC | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 11: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (11) |
| WK-SCP0002-0319 | X-LOC | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 12: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (12) |
| WK-SCP0002-0320 | X-LOC | 13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 13: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (13) |
| WK-SCP0002-0321 | X-LOC | 14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 14: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (14) |
| WK-SCP0002-0322 | X-LOC | 15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 15: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (15) |
| WK-SCP0002-0323 | X-LOC | 16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 16: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (16) |
| WK-SCP0002-0324 | X-LOC | 17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 17: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (17) |
| WK-SCP0002-0325 | X-LOC | 18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 18: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (18) |
| WK-SCP0002-0326 | X-LOC | 19 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 19: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (19) |
| WK-SCP0002-0327 | X-LOC | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (2) |
| WK-SCP0002-0328 | X-LOC | 20 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 20: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (20) |
| WK-SCP0002-0329 | X-LOC | 21 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 21: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (21) |
| WK-SCP0002-0330 | X-LOC | 22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 22: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (22) |
| WK-SCP0002-0331 | X-LOC | 23 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 23: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (23) |
| WK-SCP0002-0332 | X-LOC | 24 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 24: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (24) |
| WK-SCP0002-0333 | X-LOC | 25 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 25: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (25) |
| WK-SCP0002-0334 | X-LOC | 27 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 27: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (27) |
| WK-SCP0002-0335 | X-LOC | 28 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 28: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (28) |
| WK-SCP0002-0336 | X-LOC | 29 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 29: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (29) |
| WK-SCP0002-0337 | X-LOC | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (3) |
| WK-SCP0002-0338 | X-LOC | 30 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 30: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (30) |
| WK-SCP0002-0339 | X-LOC | 31 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 31: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (31) |
| WK-SCP0002-0340 | X-LOC | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (4) |
| WK-SCP0002-0341 | X-LOC | 4·5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 4·5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (4·5) |
| WK-SCP0002-0342 | X-LOC | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (5) |
| WK-SCP0002-0343 | X-LOC | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 6: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (6) |
| WK-SCP0002-0344 | X-LOC | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 7: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (7) |
| WK-SCP0002-0345 | X-LOC | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 8: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (8) |
| WK-SCP0002-0346 | X-LOC | 8·9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 8·9: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (8·9) |
| WK-SCP0002-0347 | X-LOC | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 9: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (9) |
| WK-SCP0002-0348 | X-LOC | Layout 11 (`usrLayoutControl1/2`, `layou | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Layout 11 (`usrLayoutControl1/2`, `layoutControlGr: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Layout 11 (`usrLayoutControl1/2`, `layou) |
| WK-SCP0002-0349 | X-LOC | `PKG_SCP0002` GET/GET_OSP/SAVE 런타임 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `PKG_SCP0002` GET/GET_OSP/SAVE 런타임: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`PKG_SCP0002` GET/GET_OSP/SAVE 런타임) |
| WK-SCP0002-0350 | X-LOC | `SCM_MST_SHEET_COLUMNS` Plant 17 / Packe | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `SCM_MST_SHEET_COLUMNS` Plant 17 / Packer 9: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`SCM_MST_SHEET_COLUMNS` Plant 17 / Packe) |
| WK-SCP0002-0351 | X-LOC | `SetDivisionAuthCheck(usrLayoutControl2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `SetDivisionAuthCheck(usrLayoutControl2)` (cs:142~: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`SetDivisionAuthCheck(usrLayoutControl2)) |
| WK-SCP0002-0352 | X-LOC | — | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — —: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (—) |
| WK-SCP0002-0353 | X-LOC | 그리드 3 (`spdMain`, `spdMain_Sheet1`, Pack | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 그리드 3 (`spdMain`, `spdMain_Sheet1`, Packer 런타임 시트): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (그리드 3 (`spdMain`, `spdMain_Sheet1`, Pack) |
| WK-SCP0002-0354 | X-LOC | 브라우저 시각·조작감(셀 색/드롭다운/토스트/freeze) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 브라우저 시각·조작감(셀 색/드롭다운/토스트/freeze): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (브라우저 시각·조작감(셀 색/드롭다운/토스트/freeze)) |
| WK-SCP0002-0355 | X-LOC | 조회조건 6 (`cboDivision`, `cboValid`, `clbP | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 조회조건 6 (`cboDivision`, `cboValid`, `clbPlantSite`,: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (조회조건 6 (`cboDivision`, `cboValid`, `clbP) |
| WK-SCP0002-0356 | X-ROW | 21 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 21: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (21) |
| WK-SCP0002-0357 | X-ROW | 22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 22: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (22) |
| WK-SCP0002-0358 | X-ROW | 24 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 24: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (24) |
| WK-SCP0002-0359 | X-ROW | SCP0002_LineMaster.ClbBuilding_SelectedI | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0002_LineMaster.ClbBuilding_SelectedIndexChange: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0002_LineMaster.ClbBuilding_Selec) |
| WK-SCP0002-0360 | X-ROW | SCP0002_LineMaster.ClbDivision_SelectedI | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0002_LineMaster.ClbDivision_SelectedIndexChange: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0002_LineMaster.ClbDivision_Selec) |
| WK-SCP0002-0361 | X-ROW | SCP0002_LineMaster.ClbOperation_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0002_LineMaster.ClbOperation_SelectedIndexChang: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0002_LineMaster.ClbOperation_Sele) |
| WK-SCP0002-0362 | X-ROW | SCP0002_LineMaster.ClbPlantSite_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0002_LineMaster.ClbPlantSite_SelectedIndexChang: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0002_LineMaster.ClbPlantSite_Sele) |
| WK-SCP0002-0363 | X-ROW | SCP0002_LineMaster.ClearUsrCheckedList | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0002_LineMaster.ClearUsrCheckedList: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/LIST_REBIND/STATE_RESET, 연결된 요소 검사 없 |  | 4 (ACT:SCP0002_LineMaster.ClearUsrCheckedLi) |
| WK-SCP0002-0364 | X-ROW | SCP0002_LineMaster.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0002_LineMaster.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0002_LineMaster.CreateSpread) |
| WK-SCP0002-0365 | X-ROW | SCP0002_LineMaster.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0002_LineMaster.DefineProperty: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0002_LineMaster.DefineProperty AC) |
| WK-SCP0002-0366 | X-ROW | SCP0002_LineMaster.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0002_LineMaster.FindButton: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:2 |  | 1 (ACT:SCP0002_LineMaster.FindButton) |
| WK-SCP0002-0367 | X-ROW | SCP0002_LineMaster.Find_Data | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0002_LineMaster.Find_Data: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 5 (ACT:SCP0002_LineMaster.Find_Data ACT:SCP) |
| WK-SCP0002-0368 | X-ROW | SCP0002_LineMaster.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0002_LineMaster.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0002_LineMaster.Form_Load) |
| WK-SCP0002-0369 | X-ROW | SCP0002_LineMaster.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0002_LineMaster.InitControls: 진입점 집계 8검사 — NOT_RUN:8 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0002_LineMaster.InitControls:143:) |
| WK-SCP0002-0370 | X-ROW | SCP0002_LineMaster.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0002_LineMaster.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0002_LineMaster.InitSpread) |
| WK-SCP0002-0371 | X-ROW | SCP0002_LineMaster.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0002_LineMaster.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0002_LineMaster.InsertButton) |
| WK-SCP0002-0372 | X-ROW | SCP0002_LineMaster.Insert_Row | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0002_LineMaster.Insert_Row: 진입점 집계 10검사 — NOT_RUN:7 · NOPATH:3 (미실행 검사가 남아 판정필요) |  | 23 (ACT:SCP0002_LineMaster.Insert_Row ACT:SC) |
| WK-SCP0002-0373 | X-ROW | SCP0002_LineMaster.RefreshBuildingByPlan | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0002_LineMaster.RefreshBuildingByPlantSite: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0002_LineMaster.RefreshBuildingBy) |
| WK-SCP0002-0374 | X-ROW | SCP0002_LineMaster.RefreshLine | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0002_LineMaster.RefreshLine: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 13 (ACT:SCP0002_LineMaster.RefreshLine ACT:S) |
| WK-SCP0002-0375 | X-ROW | SCP0002_LineMaster.RefreshOperationByBui | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0002_LineMaster.RefreshOperationByBuilding: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0002_LineMaster.RefreshOperationB) |
| WK-SCP0002-0376 | X-ROW | SCP0002_LineMaster.RefreshPlantSiteByDiv | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0002_LineMaster.RefreshPlantSiteByDivision: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0002_LineMaster.RefreshPlantSiteB) |
| WK-SCP0002-0377 | X-ROW | SCP0002_LineMaster.RefreshtLineByPlantPa | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0002_LineMaster.RefreshtLineByPlantPacker: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SCP0002_LineMaster.RefreshtLineByPla) |
| WK-SCP0002-0378 | X-ROW | SCP0002_LineMaster.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0002_LineMaster.SetChangedControl: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0002_LineMaster.SetChangedControl) |
| WK-SCP0002-0379 | X-ROW | SCP0002_LineMaster.SetChangedControl_Osp | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0002_LineMaster.SetChangedControl_Osp: 진입점 집계 9검사 — NOT_RUN:7 · REVIEW:2 |  | 1 (ACT:SCP0002_LineMaster.SetChangedControl) |
| WK-SCP0002-0380 | X-ROW | SCP0002_LineMaster.SpdMain_ActiveSheetCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0002_LineMaster.SpdMain_ActiveSheetChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 9 (ACT:SCP0002_LineMaster.SpdMain_ActiveShe) |
| WK-SCP0002-0381 | X-ROW | SCP0002_LineMaster.SpdMain_ClipboardPast | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0002_LineMaster.SpdMain_ClipboardPasted: 진입점 집계 11검사 — NOT_RUN:11 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0002_LineMaster.SpdMain_Clipboard) |
| WK-SCP0002-0382 | X-ROW | SCP0002_LineMaster.SpdMain_ComboSelChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0002_LineMaster.SpdMain_ComboSelChange: 진입점 집계 21검사 — NOT_RUN:18 · REVIEW:3 |  | 6 (ACT:SCP0002_LineMaster.SpdMain_ComboSelC) |
| WK-SCP0002-0383 | X-ROW | `SCM_ADM_MNU_M` 등록(ROUTE_PATH='supply/li | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `SCM_ADM_MNU_M` 등록(ROUTE_PATH='supply/line-master': 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`SCM_ADM_MNU_M` 등록(ROUTE_PATH='supply/li) |
| WK-SCP0002-0384 | X-ROW | `SCM_MST_SHEET_COLUMNS` Plant 17 / Packe | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `SCM_MST_SHEET_COLUMNS` Plant 17 / Packer 9: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`SCM_MST_SHEET_COLUMNS` Plant 17 / Packe) |
