# 작업 원장 — SCP0128 · 2026-10-26 12:55

> 검사 인스턴스 325건 중 PASS·NA 33건 외 **292건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 7 | 구현 위치 실존 |
| W4 | 검사기 구현 | 2 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 14 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 104 | 실행 → PASS |
| W7 | 기대값 확정 | 165 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 161 · E2E 104 · 하네스 16 · 대조표 11
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 0건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-LOC | GEN |  | 7 |  |  |  |  | 27 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-ROW | GEN |  |  |  |  |  |  | 30 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| E4 | EDIT |  |  |  |  |  | 13 | 7 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| H2 | DESIGN |  |  |  |  |  | 7 | 11 |  |  | 배경·글자색 규칙 |
| A5 | DESIGN |  |  |  |  |  | 7 | 9 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H5 | DESIGN |  |  |  |  |  | 7 | 9 |  |  | 라벨 명칭 |
| G1 | GEN |  |  |  |  |  | 7 | 9 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| D1 | EDIT |  |  |  |  |  | 5 | 7 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 5 | 7 |  |  | 행 값 기반 조건부 잠금 |
| C3 | CASCADE |  |  |  |  |  | 4 | 7 |  |  | 연쇄 자동 채움 |
| D4 | EDIT |  |  |  |  |  | 6 | 5 |  |  | 신규행 기본값·자동세팅·Insert 전제 |
| C2 | CASCADE |  |  |  |  |  | 5 | 4 |  |  | 그리드 셀 cascade 후보 |
| A1 | GEN |  |  |  |  |  |  | 9 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| M4 | POPUP |  |  |  |  |  | 4 | 3 |  |  | 팝업 선택값 반영 |
| G4 | DESIGN |  |  |  |  | 1 | 3 | 2 |  |  | 조회조건 표시·라벨·활성 |
| G5 | POPUP |  |  |  |  | 3 |  | 3 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 2 | 1 | 3 |  |  | 팝업 표준·열림 |
| C1 | CASCADE |  |  |  |  |  | 6 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| F4 | DB |  |  |  |  |  | 3 | 2 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| G6 | GEN |  |  |  |  |  | 3 | 2 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| B3 | COMBO |  |  |  | 2 |  |  | 2 |  |  | 콤보 후보 정렬 = AS-IS |
| B4 | COMBO |  |  |  |  | 2 |  | 2 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| X-REASON | DESIGN |  |  |  |  |  |  | 4 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| E2 | EDIT |  |  |  |  | 3 |  |  |  |  | 날짜 형식·유효성 |
| A6 | GEN |  |  |  |  |  | 2 | 1 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| E1 | EDIT |  |  |  |  |  | 2 |  |  |  | 숫자 소수자리·정수·부호·범위 |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| C4 | CASCADE |  |  |  |  |  | 1 |  |  |  | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K-SA | COMMON |  |  |  |  |  | 1 |  |  |  | 조회영역 토글 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F3 | CRUD |  |  |  |  |  | 1 |  |  |  | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| H4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W2 구현 위치 확인 (7)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0128-0001 | X-LOC | COMMON:UC-01 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-01) |
| WK-SCP0128-0002 | X-LOC | COMMON:UC-02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-02) |
| WK-SCP0128-0003 | X-LOC | COMMON:UC-04 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-04) |
| WK-SCP0128-0004 | X-LOC | COMMON:UC-05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-05) |
| WK-SCP0128-0005 | X-LOC | COMMON:UC-07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-07) |
| WK-SCP0128-0006 | X-LOC | `SCP0128_GET_SAFETY_STOCK`(파라미터 9종) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`SCP0128_GET_SAFETY_STOCK`(파라미터 9종)) |
| WK-SCP0128-0007 | X-LOC | `SCP0128_GET_SEARCH_INFO`(l1, 파라미터 `p_di | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`SCP0128_GET_SEARCH_INFO`(l1, 파라미터 `p_di) |

## W4 검사기 구현 (2)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0128-0008 | B3 | cboDivision / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboDivision / Division | 있음(FE 소스) | 1 (1) |
| WK-SCP0128-0009 | B3 | cboStage / Stage | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboStage / Stage | 있음(FE 소스) | 0 () |

## W5 검사기 연결 (14)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0128-0010 | B4 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (1) |
| WK-SCP0128-0011 | B4 | cboStage / Stage | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboStage / Stage | 있음(FE 소스) | 0 () |
| WK-SCP0128-0012 | F2 | SCP0128 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0128 화면 | 판단불가(대상 단위 SCREEN) | 202 (MSG00001(643) MSG00260(690) MSG00046(711) |
| WK-SCP0128-0013 | F6 | SCP0128 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0128 화면 | 판단불가(대상 단위 SCREEN) | 193 (`SCP0128_SAVE_SAFETY_STOCK`(업무값 11+user_) |
| WK-SCP0128-0014 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 있음(FE 소스) | 2 (ACT:SCP0128_SafetyStock.InitEvent ACT:SC) |
| WK-SCP0128-0015 | E2 | FROM_YYYYMMDD | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E2(_verify.spec(@verify)) → 대상 COL FROM_YYYYMMDD | 있음(SHEET_COLUMNS) | 2 (MSG00046(711) MSG00219(719)) |
| WK-SCP0128-0016 | E2 | OPMZ_PLAN_GR_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E2(_verify.spec(@verify)) → 대상 COL OPMZ_PLAN_GR_ID | 있음(SHEET_COLUMNS) | 0 () |
| WK-SCP0128-0017 | E2 | TO_YYYYMMDD | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E2(_verify.spec(@verify)) → 대상 COL TO_YYYYMMDD | 있음(SHEET_COLUMNS) | 2 (MSG00046(711) MSG00219(719)) |
| WK-SCP0128-0018 | G03-WIRE | SCP0128 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0128 화면 | 판단불가(대상 단위 SCREEN) | 10 (ACT:SCP0128_SafetyStock..ctor ACT:SCP012) |
| WK-SCP0128-0019 | G5 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 16 (ACT:SCP0128_SafetyStock.SpdMain_CellDoub) |
| WK-SCP0128-0020 | G5 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnItemId | 있음(FE 소스) | 1 (10) |
| WK-SCP0128-0021 | G5 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 2 (ACT:SCP0128_SafetyStock.SpdMain_CellDoub) |
| WK-SCP0128-0022 | H6 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 16 (ACT:SCP0128_SafetyStock.SpdMain_CellDoub) |
| WK-SCP0128-0023 | H6 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnItemId | 있음(FE 소스) | 1 (10) |

## W6 검증 실행 (104)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0128-0024 | J2 | SCP0128 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0128 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 34 (2 3 6 7 MSG00001(643) MSG00260(690) MSG0) |
| WK-SCP0128-0025 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0128_SafetyStock.InitControls:162) |
| WK-SCP0128-0026 | C1 | cboStage / Stage | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboStage / Stage · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0128_SafetyStock.RefreshStageByDi) |
| WK-SCP0128-0027 | C1 | cboType / Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboType / Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0128_SafetyStock.InitControls:173) |
| WK-SCP0128-0028 | C1 | cboValid / Valid / Active | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboValid / Valid / Active · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0128_SafetyStock.InitControls:176) |
| WK-SCP0128-0029 | C1 | clbPlanGroup / Plan Group | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbPlanGroup / Plan Group · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0128_SafetyStock.RefreshPlanGroup) |
| WK-SCP0128-0030 | C1 | clbSite / SCM Site / Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbSite / SCM Site / Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0128_SafetyStock.RefreshSiteByDiv) |
| WK-SCP0128-0031 | C2 | OPMZ_PLAN_GR_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — OPMZ_PLAN_GR_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:SCP0128_SafetyStock.spdMain_CellClic) |
| WK-SCP0128-0032 | C2 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0128_SafetyStock.spdMain_CellClic) |
| WK-SCP0128-0033 | C2 | STAGE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — STAGE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0128_SafetyStock.spdMain_CellClic) |
| WK-SCP0128-0034 | C2 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0128_SafetyStock.spdMain_CellClic) |
| WK-SCP0128-0035 | C2 | VALUE_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — VALUE_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0128_SafetyStock.spdMain_CellClic) |
| WK-SCP0128-0036 | C3 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SCP0128_SafetyStock.Set_MeasureColor) |
| WK-SCP0128-0037 | C3 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCP0128_SafetyStock.SpdMain_CellDoub) |
| WK-SCP0128-0038 | C3 | OPMZ_PLAN_GR_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — OPMZ_PLAN_GR_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 5 (14 ACT:SCP0128_SafetyStock.SpdMain_Clipb) |
| WK-SCP0128-0039 | C3 | TO_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — TO_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCP0128_SafetyStock.SpdMain_EditChan) |
| WK-SCP0128-0040 | C4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 0 () |
| WK-SCP0128-0041 | G3 | SCP0128 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0128 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 6 (Layout 2(`usrLayoutControl2`,`layoutCont) |
| WK-SCP0128-0042 | K-SA | SCP0128 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCP0128 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 2 (Layout 2(`usrLayoutControl2`,`layoutCont) |
| WK-SCP0128-0043 | K4 | SCP0128 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0128 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 17 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-04 C) |
| WK-SCP0128-0044 | F1 | SCP0128 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0128 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 208 (2 MSG00001(643) MSG00260(690) MSG00046(7) |
| WK-SCP0128-0045 | F3 | SCP0128 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F3 실행 — SCP0128 화면 · 검사기 있음(_trace.spec(@trace) W4b 붙여넣기 — Ctrl+C/Ctrl+V 로 셀 값 복사 후 값·연쇄) — 실행 필요: trace |  | 10 (14 ACT:SCP0128_SafetyStock.SpdMain_Clipb) |
| WK-SCP0128-0046 | F5 | SCP0128 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0128 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 7 (2 MSG00260(690) ACT:SCP0128_SafetyStock.) |
| WK-SCP0128-0047 | F4 | PKG_SCP0128.P_SCP0128_GET_SAFETY_STOCK | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0128.P_SCP0128_GET_SAFETY_STOCK · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 244 (`SCP0128_GET_SAFETY_STOCK`(파라미터 9종) ACT:) |
| WK-SCP0128-0048 | F4 | PKG_SCP0128.P_SCP0128_GET_SEARCH_INFO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0128.P_SCP0128_GET_SEARCH_INFO · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: sm |  | 196 (`SCP0128_GET_SEARCH_INFO`(l1, 파라미터 `p_di) |
| WK-SCP0128-0049 | F4 | PKG_SCP0128.P_SCP0128_SAVE_SAFETY_STOCK | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0128.P_SCP0128_SAVE_SAFETY_STOCK · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요:  |  | 193 (`SCP0128_SAVE_SAFETY_STOCK`(업무값 11+user_) |
| WK-SCP0128-0050 | A5 | CREATED_BY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — CREATED_BY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (3·4 9·10) |
| WK-SCP0128-0051 | A5 | DIVISION_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 4 (6 8 3·4 9·10) |
| WK-SCP0128-0052 | A5 | ITEM_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (12 ACT:SCP0128_SafetyStock.SpdMain_CellD) |
| WK-SCP0128-0053 | A5 | LAST_UPDATE_DATE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (9·10) |
| WK-SCP0128-0054 | A5 | OPMZ_PLAN_GR_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — OPMZ_PLAN_GR_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (14) |
| WK-SCP0128-0055 | A5 | PRE_KEY_VALUES | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PRE_KEY_VALUES · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (3·4) |
| WK-SCP0128-0056 | A5 | VALID_YN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (8 —) |
| WK-SCP0128-0057 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0128_SafetyStock.InitControls ACT) |
| WK-SCP0128-0058 | G4 | cboType / Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboType / Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0128_SafetyStock.InitControls ACT) |
| WK-SCP0128-0059 | G4 | cboValid / Valid / Active | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboValid / Valid / Active · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0128_SafetyStock.InitControls ACT) |
| WK-SCP0128-0060 | H2 | CREATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — CREATED_BY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (3·4 9·10) |
| WK-SCP0128-0061 | H2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 7 (6 8 3·4 9·10 ACT:SCP0128_SafetyStock.Set) |
| WK-SCP0128-0062 | H2 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (12) |
| WK-SCP0128-0063 | H2 | LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (9·10) |
| WK-SCP0128-0064 | H2 | OPMZ_PLAN_GR_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — OPMZ_PLAN_GR_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (14) |
| WK-SCP0128-0065 | H2 | PRE_KEY_VALUES | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PRE_KEY_VALUES · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (3·4) |
| WK-SCP0128-0066 | H2 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (8 —) |
| WK-SCP0128-0067 | H4 | SCP0128 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — SCP0128 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 6 (9 11 ACT:SCP0128_SafetyStock.SpdMain_Top) |
| WK-SCP0128-0068 | H5 | CREATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — CREATED_BY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (3·4 9·10) |
| WK-SCP0128-0069 | H5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — DIVISION_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (6 8 3·4 9·10) |
| WK-SCP0128-0070 | H5 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ITEM_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (12) |
| WK-SCP0128-0071 | H5 | LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (9·10) |
| WK-SCP0128-0072 | H5 | OPMZ_PLAN_GR_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — OPMZ_PLAN_GR_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (14) |
| WK-SCP0128-0073 | H5 | PRE_KEY_VALUES | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PRE_KEY_VALUES · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (3·4) |
| WK-SCP0128-0074 | H5 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — VALID_YN · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (8 —) |
| WK-SCP0128-0075 | I1 | SCP0128 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0128 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 19 (MSG00001(643) MSG00260(690) MSG00046(711) |
| WK-SCP0128-0076 | SC1 | SCP0128 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SCP0128 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 2 (조회조건 8개 논리조건(19 컨트롤+라벨) Site/Type/Stage ) |
| WK-SCP0128-0077 | D1 | CREATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CREATED_BY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 5 (3·4 9·10 ACT:SCP0128_SafetyStock.EditBut) |
| WK-SCP0128-0078 | D1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 7 (6 3·4 9·10 ACT:SCP0128_SafetyStock.EditB) |
| WK-SCP0128-0079 | D1 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 0 () |
| WK-SCP0128-0080 | D1 | LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (9·10 ACT:SCP0128_SafetyStock.Insert_Row:) |
| WK-SCP0128-0081 | D1 | PRE_KEY_VALUES | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PRE_KEY_VALUES · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (3·4 ACT:SCP0128_SafetyStock.EditButton:3) |
| WK-SCP0128-0082 | D3 | CREATED_BY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CREATED_BY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 5 (3·4 9·10 ACT:SCP0128_SafetyStock.EditBut) |
| WK-SCP0128-0083 | D3 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 7 (6 3·4 9·10 ACT:SCP0128_SafetyStock.EditB) |
| WK-SCP0128-0084 | D3 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 0 () |
| WK-SCP0128-0085 | D3 | LAST_UPDATE_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LAST_UPDATE_DATE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (9·10 ACT:SCP0128_SafetyStock.Insert_Row:) |
| WK-SCP0128-0086 | D3 | PRE_KEY_VALUES | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PRE_KEY_VALUES · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (3·4 ACT:SCP0128_SafetyStock.EditButton:3) |
| WK-SCP0128-0087 | D4 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (8) |
| WK-SCP0128-0088 | D4 | FROM_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — FROM_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (MSG00046(711)) |
| WK-SCP0128-0089 | D4 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (12) |
| WK-SCP0128-0090 | D4 | OPMZ_PLAN_GR_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — OPMZ_PLAN_GR_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (14) |
| WK-SCP0128-0091 | D4 | TO_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — TO_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (MSG00046(711)) |
| WK-SCP0128-0092 | D4 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (8) |
| WK-SCP0128-0093 | D6 | SCP0128 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0128 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 6 (7 MSG00046(711) InsertButton 사전조건 가드 COM) |
| WK-SCP0128-0094 | E1 | OPMZ_PLAN_GR_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — OPMZ_PLAN_GR_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 5 (14 ACT:SCP0128_SafetyStock.SpdMain_Clipb) |
| WK-SCP0128-0095 | E1 | TO_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — TO_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 0 () |
| WK-SCP0128-0096 | E4 | APL_QTY | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — APL_QTY · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00085(728) ACT:SCP0128_SafetyStock.Sp) |
| WK-SCP0128-0097 | E4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SCP0128_SafetyStock.Set_MeasureColor) |
| WK-SCP0128-0098 | E4 | FROM_YYYYMMDD | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — FROM_YYYYMMDD · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (MSG00046(711) MSG00219(719) ACT:SCP0128_) |
| WK-SCP0128-0099 | E4 | MSG00001 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00001 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00001(643) ACT:SCP0128_SafetyStock.Sa) |
| WK-SCP0128-0100 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0128_SafetyStock.SaveData:843:181) |
| WK-SCP0128-0101 | E4 | MSG00046 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00046 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00046(711) ACT:SCP0128_SafetyStock.Sa) |
| WK-SCP0128-0102 | E4 | MSG00049 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00049 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0128_SafetyStock.SpdMain_EditChan) |
| WK-SCP0128-0103 | E4 | MSG00085 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00085 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (MSG00085(728) ACT:SCP0128_SafetyStock.Sa) |
| WK-SCP0128-0104 | E4 | MSG00219 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00219 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (MSG00046(711) MSG00219(719) ACT:SCP0128_) |
| WK-SCP0128-0105 | E4 | MSG00260 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00260 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00260(690) ACT:SCP0128_SafetyStock.Sa) |
| WK-SCP0128-0106 | E4 | MSG00458 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00458 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00458(747) ACT:SCP0128_SafetyStock.Sa) |
| WK-SCP0128-0107 | E4 | TO_YYYYMMDD | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — TO_YYYYMMDD · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (MSG00046(711) MSG00219(719) ACT:SCP0128_) |
| WK-SCP0128-0108 | E4 | clbPlanGroup / Plan Group | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbPlanGroup / Plan Group · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실 |  | 0 () |
| WK-SCP0128-0109 | A10 | SCP0128 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0128 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 40 (ACT:SCP0128_SafetyStock.DefineProperty A) |
| WK-SCP0128-0110 | A6 | PKG_SCP0128.P_SCP0128_GET_SAFETY_STOCK | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0128.P_SCP0128_GET_SAFETY_STOCK · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) ·  |  | 53 (`SCP0128_GET_SAFETY_STOCK`(파라미터 9종) ACT:) |
| WK-SCP0128-0111 | A6 | PKG_SCP0128.P_SCP0128_GET_SEARCH_INFO | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0128.P_SCP0128_GET_SEARCH_INFO · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _ |  | 3 (`SCP0128_GET_SEARCH_INFO`(l1, 파라미터 `p_di) |
| WK-SCP0128-0112 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0128_SafetyStock.FindData_Main AC) |
| WK-SCP0128-0113 | G1 | cboStage / Stage | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboStage / Stage · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0128_SafetyStock.FindData_Main AC) |
| WK-SCP0128-0114 | G1 | cboType / Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboType / Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0128_SafetyStock.FindData_Main AC) |
| WK-SCP0128-0115 | G1 | cboValid / Valid / Active | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboValid / Valid / Active · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0128_SafetyStock.FindData_Main AC) |
| WK-SCP0128-0116 | G1 | clbPlanGroup / Plan Group | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbPlanGroup / Plan Group · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0128_SafetyStock.FindData_Main AC) |
| WK-SCP0128-0117 | G1 | clbSite / SCM Site / Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbSite / SCM Site / Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0128_SafetyStock.FindData_Main AC) |
| WK-SCP0128-0118 | G1 | txtItemId / Model / Item Id / Model/Nick | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0128_SafetyStock.FindData_Main AC) |
| WK-SCP0128-0119 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCP0128_SafetyStock.InitControls ACT) |
| WK-SCP0128-0120 | G6 | cboType / Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboType / Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0128_SafetyStock.InitControls ACT) |
| WK-SCP0128-0121 | G6 | cboValid / Valid / Active | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboValid / Valid / Active · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0128_SafetyStock.InitControls ACT) |
| WK-SCP0128-0122 | X-REOPEN | SCP0128 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0128 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 7 (ACT:SCP0128_SafetyStock.Dispose ACT:SCP0) |
| WK-SCP0128-0123 | H6 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboDivision / Division · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 2 (ACT:SCP0128_SafetyStock.SpdMain_CellDoub) |
| WK-SCP0128-0124 | M4 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 16 (ACT:SCP0128_SafetyStock.SpdMain_CellDoub) |
| WK-SCP0128-0125 | M4 | SCM_SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SCM_SITE_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SCP0128_SafetyStock.SpdMain_CellDoub) |
| WK-SCP0128-0126 | M4 | btnItemId | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnItemId · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (10) |
| WK-SCP0128-0127 | M4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SCP0128_SafetyStock.SpdMain_CellDoub) |

## W7 기대값 확정 (165)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0128-0128 | C2 | SCP0128_SafetyStock.CboDivision_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0128_SafetyStock.CboDivision_SelectedIndexChang: 진입점 집계 — C2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0128_SafetyStock.CboDivision_Sele) |
| WK-SCP0128-0129 | C2 | SCP0128_SafetyStock.CboPlanGroup_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0128_SafetyStock.CboPlanGroup_SelectedIndexChan: 진입점 집계 — C2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0128_SafetyStock.CboPlanGroup_Sel) |
| WK-SCP0128-0130 | C2 | SCP0128_SafetyStock.CboPlanSeq_SelectedI | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0128_SafetyStock.CboPlanSeq_SelectedIndexChange: 진입점 집계 — C2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0128_SafetyStock.CboPlanSeq_Selec) |
| WK-SCP0128-0131 | C2 | SCP0128_SafetyStock.ClbDivision_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0128_SafetyStock.ClbDivision_SelectedIndexChang: 진입점 집계 — C2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0128_SafetyStock.ClbDivision_Sele) |
| WK-SCP0128-0132 | C3 | SCP0128_SafetyStock.CboDivision_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0128_SafetyStock.CboDivision_SelectedIndexChang: 진입점 집계 — C3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0128_SafetyStock.CboDivision_Sele) |
| WK-SCP0128-0133 | C3 | SCP0128_SafetyStock.CboPlanGroup_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0128_SafetyStock.CboPlanGroup_SelectedIndexChan: 진입점 집계 — C3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0128_SafetyStock.CboPlanGroup_Sel) |
| WK-SCP0128-0134 | C3 | SCP0128_SafetyStock.CboPlanSeq_SelectedI | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0128_SafetyStock.CboPlanSeq_SelectedIndexChange: 진입점 집계 — C3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0128_SafetyStock.CboPlanSeq_Selec) |
| WK-SCP0128-0135 | C3 | SCP0128_SafetyStock.ClbDivision_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0128_SafetyStock.ClbDivision_SelectedIndexChang: 진입점 집계 — C3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0128_SafetyStock.ClbDivision_Sele) |
| WK-SCP0128-0136 | C3 | SCP0128_SafetyStock.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0128_SafetyStock.SetChangedControl: 진입점 집계 — C3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0128_SafetyStock.SetChangedContro) |
| WK-SCP0128-0137 | C3 | SCP0128_SafetyStock.Set_MeasureColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0128_SafetyStock.Set_MeasureColor: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0128_SafetyStock.Set_MeasureColor) |
| WK-SCP0128-0138 | C3 | SCP0128_SafetyStock.setPeriod | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0128_SafetyStock.setPeriod: 진입점 집계 — C3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0128_SafetyStock.setPeriod:877:1 ) |
| WK-SCP0128-0139 | B3 | SCP0128_SafetyStock.GetDivisionChecked | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0128_SafetyStock.GetDivisionChecked: 진입점 집계 — B3 2요소: TODO:2 (미실행 요소가 남아 판정필요) |  | 15 (ACT:SCP0128_SafetyStock.GetDivisionCheck) |
| WK-SCP0128-0140 | B3 | SCP0128_SafetyStock.GetSearchInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0128_SafetyStock.GetSearchInfo: 진입점 집계 — B3 2요소: TODO:2 (미실행 요소가 남아 판정필요) |  | 11 (ACT:SCP0128_SafetyStock.GetSearchInfo:19) |
| WK-SCP0128-0141 | B4 | SCP0128_SafetyStock.GetDivisionChecked | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0128_SafetyStock.GetDivisionChecked: 진입점 집계 — B4 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 15 (ACT:SCP0128_SafetyStock.GetDivisionCheck) |
| WK-SCP0128-0142 | B4 | SCP0128_SafetyStock.GetSearchInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0128_SafetyStock.GetSearchInfo: 진입점 집계 — B4 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 11 (ACT:SCP0128_SafetyStock.GetSearchInfo:19) |
| WK-SCP0128-0143 | F4 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 1: 행 집계 — F4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0128-0144 | F4 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 2: 행 집계 — F4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0128-0145 | A5 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 11: 행 집계 — A5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (11) |
| WK-SCP0128-0146 | A5 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 2: 행 집계 — A5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (2) |
| WK-SCP0128-0147 | A5 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 5: 행 집계 — A5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (5) |
| WK-SCP0128-0148 | A5 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 7: 행 집계 — A5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (7) |
| WK-SCP0128-0149 | A5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-07: 행 집계 — A5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0128-0150 | A5 | InsertButton 사전조건 가드 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — InsertButton 사전조건 가드: 행 집계 — A5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (InsertButton 사전조건 가드) |
| WK-SCP0128-0151 | A5 | SCP0128_SafetyStock.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0128_SafetyStock.CreateSpread: 진입점 집계 — A5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0128_SafetyStock.CreateSpread:286) |
| WK-SCP0128-0152 | A5 | `SCP0128_GET_SEARCH_INFO`(l1, 파라미터 `p_di | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — `SCP0128_GET_SEARCH_INFO`(l1, 파라미터 `p_division_id`: 행 집계 — A5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (`SCP0128_GET_SEARCH_INFO`(l1, 파라미터 `p_di) |
| WK-SCP0128-0153 | A5 | 그리드 2(`spdMain`,`spdMain_Sheet1`) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 그리드 2(`spdMain`,`spdMain_Sheet1`): 행 집계 — A5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (그리드 2(`spdMain`,`spdMain_Sheet1`)) |
| WK-SCP0128-0154 | G4 | Site/Type/Stage 3개 조회조건 — 데이터 배선 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — Site/Type/Stage 3개 조회조건 — 데이터 배선: 행 집계 — G4 4요소: NOT_RUN:3 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (Site/Type/Stage 3개 조회조건 — 데이터 배선) |
| WK-SCP0128-0155 | G4 | 조회조건 8개 논리조건(19 컨트롤+라벨) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 조회조건 8개 논리조건(19 컨트롤+라벨): 행 집계 — G4 4요소: NOT_RUN:3 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (조회조건 8개 논리조건(19 컨트롤+라벨)) |
| WK-SCP0128-0156 | H2 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 11: 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (11) |
| WK-SCP0128-0157 | H2 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 2: 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (2) |
| WK-SCP0128-0158 | H2 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 5: 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (5) |
| WK-SCP0128-0159 | H2 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 7: 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (7) |
| WK-SCP0128-0160 | H2 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 9: 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (9) |
| WK-SCP0128-0161 | H2 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-07: 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0128-0162 | H2 | InsertButton 사전조건 가드 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — InsertButton 사전조건 가드: 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (InsertButton 사전조건 가드) |
| WK-SCP0128-0163 | H2 | SCP0128_SafetyStock.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0128_SafetyStock.CreateSpread: 진입점 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0128_SafetyStock.CreateSpread:286) |
| WK-SCP0128-0164 | H2 | SCP0128_SafetyStock.Set_MeasureColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0128_SafetyStock.Set_MeasureColor: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0128_SafetyStock.Set_MeasureColor) |
| WK-SCP0128-0165 | H2 | `SCP0128_GET_SEARCH_INFO`(l1, 파라미터 `p_di | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — `SCP0128_GET_SEARCH_INFO`(l1, 파라미터 `p_division_id`: 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (`SCP0128_GET_SEARCH_INFO`(l1, 파라미터 `p_di) |
| WK-SCP0128-0166 | H2 | 그리드 2(`spdMain`,`spdMain_Sheet1`) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 그리드 2(`spdMain`,`spdMain_Sheet1`): 행 집계 — H2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (그리드 2(`spdMain`,`spdMain_Sheet1`)) |
| WK-SCP0128-0167 | H5 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 11: 행 집계 — H5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (11) |
| WK-SCP0128-0168 | H5 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 2: 행 집계 — H5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (2) |
| WK-SCP0128-0169 | H5 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 5: 행 집계 — H5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (5) |
| WK-SCP0128-0170 | H5 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 7: 행 집계 — H5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (7) |
| WK-SCP0128-0171 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0128-0172 | H5 | InsertButton 사전조건 가드 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — InsertButton 사전조건 가드: 행 집계 — H5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (InsertButton 사전조건 가드) |
| WK-SCP0128-0173 | H5 | SCP0128_SafetyStock.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0128_SafetyStock.CreateSpread: 진입점 집계 — H5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0128_SafetyStock.CreateSpread:286) |
| WK-SCP0128-0174 | H5 | `SCP0128_GET_SEARCH_INFO`(l1, 파라미터 `p_di | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `SCP0128_GET_SEARCH_INFO`(l1, 파라미터 `p_division_id`: 행 집계 — H5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (`SCP0128_GET_SEARCH_INFO`(l1, 파라미터 `p_di) |
| WK-SCP0128-0175 | H5 | 그리드 2(`spdMain`,`spdMain_Sheet1`) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 그리드 2(`spdMain`,`spdMain_Sheet1`): 행 집계 — H5 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (그리드 2(`spdMain`,`spdMain_Sheet1`)) |
| WK-SCP0128-0176 | X-REASON | 1 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 1 `BLUtils.GetDivision(false,"")`(44) cboDivision `COMBO.DIVISION='Division_SCP'`(EE 포함, WithoutEE 아님) 구현 |  | 0 () |
| WK-SCP0128-0177 | X-REASON | COMMON:UC-06 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-06 Key-in 콤마 다중조회 해당없음 — Item ID 는 팝업 단일선택(콤마 다중검색 없음) 해당없음 |  | 1 (COMMON:UC-06) |
| WK-SCP0128-0178 | X-REASON | static 5(`components`,`emptySpaceItem*`) | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — static 5(`components`,`emptySpaceItem*`) 비시각 — 매핑 대상 아님 해당없음 |  | 1 (static 5(`components`,`emptySpaceItem*`)) |
| WK-SCP0128-0179 | X-REASON | — | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — — `GetSearchInfo` Table[4](190~215) 그리드 셀 VALID_YN 콤보 **미배선** — SP 배포 후 배선(현재 `SCM_ADM_CMBO_SQL_M` 전건 미등록, desi |  | 0 () |
| WK-SCP0128-0180 | D1 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 11: 행 집계 — D1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0128-0181 | D1 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 2: 행 집계 — D1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0128-0182 | D1 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 3: 행 집계 — D1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (3) |
| WK-SCP0128-0183 | D1 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 4: 행 집계 — D1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0128-0184 | D1 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 5: 행 집계 — D1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0128-0185 | D1 | InsertButton 사전조건 가드 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — InsertButton 사전조건 가드: 행 집계 — D1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (InsertButton 사전조건 가드) |
| WK-SCP0128-0186 | D1 | SCP0128_SafetyStock.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SCP0128_SafetyStock.EditButton: 진입점 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0128_SafetyStock.EditButton:368:2) |
| WK-SCP0128-0187 | D3 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 11: 행 집계 — D3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0128-0188 | D3 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 2: 행 집계 — D3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0128-0189 | D3 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 3: 행 집계 — D3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (3) |
| WK-SCP0128-0190 | D3 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 4: 행 집계 — D3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0128-0191 | D3 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 5: 행 집계 — D3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0128-0192 | D3 | InsertButton 사전조건 가드 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — InsertButton 사전조건 가드: 행 집계 — D3 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (InsertButton 사전조건 가드) |
| WK-SCP0128-0193 | D3 | SCP0128_SafetyStock.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SCP0128_SafetyStock.EditButton: 진입점 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0128_SafetyStock.EditButton:368:2) |
| WK-SCP0128-0194 | D4 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — 5: 행 집계 — D4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0128-0195 | D4 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — 7: 행 집계 — D4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (7) |
| WK-SCP0128-0196 | D4 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — COMMON:UC-01: 행 집계 — D4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SCP0128-0197 | D4 | InsertButton 사전조건 가드 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — InsertButton 사전조건 가드: 행 집계 — D4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (InsertButton 사전조건 가드) |
| WK-SCP0128-0198 | D4 | `SCP0128_GET_SEARCH_INFO`(l1, 파라미터 `p_di | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — `SCP0128_GET_SEARCH_INFO`(l1, 파라미터 `p_division_id`: 행 집계 — D4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (`SCP0128_GET_SEARCH_INFO`(l1, 파라미터 `p_di) |
| WK-SCP0128-0199 | E4 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 2: 행 집계 — E4 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0128-0200 | E4 | COMMON:UC-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — COMMON:UC-04: 행 집계 — E4 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-04) |
| WK-SCP0128-0201 | E4 | SCP0128_SafetyStock.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0128_SafetyStock.SetChangedControl: 진입점 집계 — E4 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0128_SafetyStock.SetChangedContro) |
| WK-SCP0128-0202 | E4 | SCP0128_SafetyStock.Set_MeasureColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0128_SafetyStock.Set_MeasureColor: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0128_SafetyStock.Set_MeasureColor) |
| WK-SCP0128-0203 | E4 | SCP0128_SafetyStock.setPeriod | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0128_SafetyStock.setPeriod: 진입점 집계 — E4 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0128_SafetyStock.setPeriod:877:1 ) |
| WK-SCP0128-0204 | E4 | `SCP0128_SAVE_SAFETY_STOCK`(업무값 11+user_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — `SCP0128_SAVE_SAFETY_STOCK`(업무값 11+user_id+PRE_* 8: 행 집계 — E4 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (`SCP0128_SAVE_SAFETY_STOCK`(업무값 11+user_) |
| WK-SCP0128-0205 | E4 | 브라우저 시각·조작감 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 브라우저 시각·조작감: 행 집계 — E4 13요소: NOT_RUN:13 (미실행 요소가 남아 판정필요) |  | 1 (브라우저 시각·조작감) |
| WK-SCP0128-0206 | A1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1: 행 집계 — A1 2요소: REVIEW:2 |  | 0 () |
| WK-SCP0128-0207 | A1 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 6: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (6) |
| WK-SCP0128-0208 | A1 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 8: 행 집계 — A1 2요소: REVIEW:2 |  | 0 () |
| WK-SCP0128-0209 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (COMMON:UC-02) |
| WK-SCP0128-0210 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (COMMON:UC-07) |
| WK-SCP0128-0211 | A1 | PKG_SCP0128.P_SCP0128_GET_SAFETY_STOCK | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0128.P_SCP0128_GET_SAFETY_STOCK: 골든 비교 케이스 없음(PKG_SCP0128.P_SCP0128_GET_SAFETY_STOCK — 팝업·보조 SP 는 golden_cases. |  | 53 (`SCP0128_GET_SAFETY_STOCK`(파라미터 9종) ACT:) |
| WK-SCP0128-0212 | A1 | PKG_SCP0128.P_SCP0128_GET_SEARCH_INFO | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0128.P_SCP0128_GET_SEARCH_INFO: 골든 비교 케이스 없음(PKG_SCP0128.P_SCP0128_GET_SEARCH_INFO — 팝업·보조 SP 는 golden_cases.cs |  | 3 (`SCP0128_GET_SEARCH_INFO`(l1, 파라미터 `p_di) |
| WK-SCP0128-0213 | A1 | — | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — —: 행 집계 — A1 2요소: REVIEW:2 |  | 0 () |
| WK-SCP0128-0214 | A1 | 조회조건 8개 논리조건(19 컨트롤+라벨) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 조회조건 8개 논리조건(19 컨트롤+라벨): 행 집계 — A1 2요소: REVIEW:2 |  | 1 (조회조건 8개 논리조건(19 컨트롤+라벨)) |
| WK-SCP0128-0215 | A6 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 1: 행 집계 — A6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0128-0216 | G1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 1: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0128-0217 | G1 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 6: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (6) |
| WK-SCP0128-0218 | G1 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 8: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0128-0219 | G1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-02: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0128-0220 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0128-0221 | G1 | Plan Group 콤보 최종 교체(`GET_SEARCH_INFO` Ta | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Plan Group 콤보 최종 교체(`GET_SEARCH_INFO` Table[0]): 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (Plan Group 콤보 최종 교체(`GET_SEARCH_INFO` Ta) |
| WK-SCP0128-0222 | G1 | Site/Type/Stage 3개 조회조건 — 데이터 배선 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Site/Type/Stage 3개 조회조건 — 데이터 배선: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (Site/Type/Stage 3개 조회조건 — 데이터 배선) |
| WK-SCP0128-0223 | G1 | `SCP0128_GET_SEARCH_INFO`(l1, 파라미터 `p_di | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `SCP0128_GET_SEARCH_INFO`(l1, 파라미터 `p_division_id`: 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (`SCP0128_GET_SEARCH_INFO`(l1, 파라미터 `p_di) |
| WK-SCP0128-0224 | G1 | 조회조건 8개 논리조건(19 컨트롤+라벨) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 조회조건 8개 논리조건(19 컨트롤+라벨): 행 집계 — G1 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (조회조건 8개 논리조건(19 컨트롤+라벨)) |
| WK-SCP0128-0225 | G6 | Site/Type/Stage 3개 조회조건 — 데이터 배선 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — Site/Type/Stage 3개 조회조건 — 데이터 배선: 행 집계 — G6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (Site/Type/Stage 3개 조회조건 — 데이터 배선) |
| WK-SCP0128-0226 | G6 | 조회조건 8개 논리조건(19 컨트롤+라벨) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 조회조건 8개 논리조건(19 컨트롤+라벨): 행 집계 — G6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (조회조건 8개 논리조건(19 컨트롤+라벨)) |
| WK-SCP0128-0227 | X-LOC | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (1) |
| WK-SCP0128-0228 | X-LOC | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 10: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (10) |
| WK-SCP0128-0229 | X-LOC | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 11: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (11) |
| WK-SCP0128-0230 | X-LOC | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 12: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (12) |
| WK-SCP0128-0231 | X-LOC | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (2) |
| WK-SCP0128-0232 | X-LOC | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (3) |
| WK-SCP0128-0233 | X-LOC | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (4) |
| WK-SCP0128-0234 | X-LOC | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (5) |
| WK-SCP0128-0235 | X-LOC | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 6: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (6) |
| WK-SCP0128-0236 | X-LOC | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 7: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (7) |
| WK-SCP0128-0237 | X-LOC | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 8: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (8) |
| WK-SCP0128-0238 | X-LOC | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 9: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (9) |
| WK-SCP0128-0239 | X-LOC | 9·10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 9·10: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (9·10) |
| WK-SCP0128-0240 | X-LOC | InsertButton 사전조건 가드 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — InsertButton 사전조건 가드: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (InsertButton 사전조건 가드) |
| WK-SCP0128-0241 | X-LOC | Layout 2(`usrLayoutControl2`,`layoutCont | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Layout 2(`usrLayoutControl2`,`layoutControlGroup2`: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Layout 2(`usrLayoutControl2`,`layoutCont) |
| WK-SCP0128-0242 | X-LOC | MSG00085(728) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00085(728): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00085(728)) |
| WK-SCP0128-0243 | X-LOC | MSG00219(719) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00219(719): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00219(719)) |
| WK-SCP0128-0244 | X-LOC | MSG00260(690) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00260(690): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00260(690)) |
| WK-SCP0128-0245 | X-LOC | MSG00458(747) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00458(747): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00458(747)) |
| WK-SCP0128-0246 | X-LOC | Site/Type/Stage 3개 조회조건 — 데이터 배선 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Site/Type/Stage 3개 조회조건 — 데이터 배선: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Site/Type/Stage 3개 조회조건 — 데이터 배선) |
| WK-SCP0128-0247 | X-LOC | SmartColMerge 병합 대상 컬럼 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SmartColMerge 병합 대상 컬럼: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SmartColMerge 병합 대상 컬럼) |
| WK-SCP0128-0248 | X-LOC | `PKG_SCP0128` GET_SEARCH_INFO/GET_SAFETY | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `PKG_SCP0128` GET_SEARCH_INFO/GET_SAFETY_STOCK/SAV: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`PKG_SCP0128` GET_SEARCH_INFO/GET_SAFETY) |
| WK-SCP0128-0249 | X-LOC | `usrButton1`(x0/y0/tab0) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `usrButton1`(x0/y0/tab0): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`usrButton1`(x0/y0/tab0)) |
| WK-SCP0128-0250 | X-LOC | — | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — —: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (—) |
| WK-SCP0128-0251 | X-LOC | 그리드 2(`spdMain`,`spdMain_Sheet1`) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 그리드 2(`spdMain`,`spdMain_Sheet1`): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (그리드 2(`spdMain`,`spdMain_Sheet1`)) |
| WK-SCP0128-0252 | X-LOC | 브라우저 시각·조작감 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 브라우저 시각·조작감: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (브라우저 시각·조작감) |
| WK-SCP0128-0253 | X-LOC | 조회조건 8개 논리조건(19 컨트롤+라벨) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 조회조건 8개 논리조건(19 컨트롤+라벨): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (조회조건 8개 논리조건(19 컨트롤+라벨)) |
| WK-SCP0128-0254 | X-ROW | SCP0128_SafetyStock.CboDivision_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0128_SafetyStock.CboDivision_SelectedIndexChang: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0128_SafetyStock.CboDivision_Sele) |
| WK-SCP0128-0255 | X-ROW | SCP0128_SafetyStock.CboPlanGroup_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0128_SafetyStock.CboPlanGroup_SelectedIndexChan: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0128_SafetyStock.CboPlanGroup_Sel) |
| WK-SCP0128-0256 | X-ROW | SCP0128_SafetyStock.CboPlanSeq_SelectedI | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0128_SafetyStock.CboPlanSeq_SelectedIndexChange: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0128_SafetyStock.CboPlanSeq_Selec) |
| WK-SCP0128-0257 | X-ROW | SCP0128_SafetyStock.ClbDivision_Selected | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0128_SafetyStock.ClbDivision_SelectedIndexChang: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0128_SafetyStock.ClbDivision_Sele) |
| WK-SCP0128-0258 | X-ROW | SCP0128_SafetyStock.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0128_SafetyStock.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0128_SafetyStock.CreateSpread) |
| WK-SCP0128-0259 | X-ROW | SCP0128_SafetyStock.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0128_SafetyStock.DefineProperty: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0128_SafetyStock.DefineProperty A) |
| WK-SCP0128-0260 | X-ROW | SCP0128_SafetyStock.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0128_SafetyStock.FindButton: 진입점 집계 3검사 — NOT_RUN:2 · REVIEW:1 |  | 1 (ACT:SCP0128_SafetyStock.FindButton) |
| WK-SCP0128-0261 | X-ROW | SCP0128_SafetyStock.FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0128_SafetyStock.FindData_Main: 진입점 집계 12검사 — NOT_RUN:10 · REVIEW:1 · PASS:1 |  | 7 (ACT:SCP0128_SafetyStock.FindData_Main:39) |
| WK-SCP0128-0262 | X-ROW | SCP0128_SafetyStock.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0128_SafetyStock.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0128_SafetyStock.Form_Load) |
| WK-SCP0128-0263 | X-ROW | SCP0128_SafetyStock.GetDivisionChecked | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0128_SafetyStock.GetDivisionChecked: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0128_SafetyStock.GetDivisionCheck) |
| WK-SCP0128-0264 | X-ROW | SCP0128_SafetyStock.GetSearchInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0128_SafetyStock.GetSearchInfo: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:1 · TODO:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0128_SafetyStock.GetSearchInfo AC) |
| WK-SCP0128-0265 | X-ROW | SCP0128_SafetyStock.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0128_SafetyStock.InitControls: 진입점 집계 10검사 — NOT_RUN:10 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0128_SafetyStock.InitControls:159) |
| WK-SCP0128-0266 | X-ROW | SCP0128_SafetyStock.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0128_SafetyStock.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SCP0128_SafetyStock.InitSpread ACT:S) |
| WK-SCP0128-0267 | X-ROW | SCP0128_SafetyStock.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0128_SafetyStock.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0128_SafetyStock.InsertButton) |
| WK-SCP0128-0268 | X-ROW | SCP0128_SafetyStock.Insert_Row | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0128_SafetyStock.Insert_Row: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SCP0128_SafetyStock.Insert_Row ACT:S) |
| WK-SCP0128-0269 | X-ROW | SCP0128_SafetyStock.RefreshPlanGroupByDi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0128_SafetyStock.RefreshPlanGroupByDivision: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0128_SafetyStock.RefreshPlanGroup) |
| WK-SCP0128-0270 | X-ROW | SCP0128_SafetyStock.RefreshSiteByDivisio | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0128_SafetyStock.RefreshSiteByDivision: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SCP0128_SafetyStock.RefreshSiteByDiv) |
| WK-SCP0128-0271 | X-ROW | SCP0128_SafetyStock.RefreshStageByDivisi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0128_SafetyStock.RefreshStageByDivision: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0128_SafetyStock.RefreshStageByDi) |
| WK-SCP0128-0272 | X-ROW | SCP0128_SafetyStock.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0128_SafetyStock.SaveData: 진입점 집계 18검사 — NOT_RUN:13 · PASS:3 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0128_SafetyStock.SaveData:795:149) |
| WK-SCP0128-0273 | X-ROW | SCP0128_SafetyStock.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0128_SafetyStock.SetChangedControl: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0128_SafetyStock.SetChangedContro) |
| WK-SCP0128-0274 | X-ROW | SCP0128_SafetyStock.SpdMain_CellDoubleCl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0128_SafetyStock.SpdMain_CellDoubleClick: 진입점 집계 12검사 — NOT_RUN:6 · NOPATH:3 · REVIEW:3 |  | 2 (ACT:SCP0128_SafetyStock.SpdMain_CellDoub) |
| WK-SCP0128-0275 | X-ROW | SCP0128_SafetyStock.SpdMain_ClipboardPas | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0128_SafetyStock.SpdMain_ClipboardPasted: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0128_SafetyStock.SpdMain_Clipboar) |
| WK-SCP0128-0276 | X-ROW | SCP0128_SafetyStock.SpdMain_EditChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0128_SafetyStock.SpdMain_EditChange: 진입점 집계 8검사 — NOT_RUN:8 (미실행 검사가 남아 판정필요) |  | 38 (ACT:SCP0128_SafetyStock.SpdMain_EditChan) |
| WK-SCP0128-0277 | X-ROW | SCP0128_SafetyStock.SpdMain_TopChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0128_SafetyStock.SpdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0128_SafetyStock.SpdMain_TopChang) |
| WK-SCP0128-0278 | X-ROW | SCP0128_SafetyStock.btnItemId_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0128_SafetyStock.btnItemId_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0128_SafetyStock.btnItemId_Click:) |
| WK-SCP0128-0279 | X-ROW | SCP0128_SafetyStock.setPeriod | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0128_SafetyStock.setPeriod: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0128_SafetyStock.setPeriod ACT:SC) |
| WK-SCP0128-0280 | X-ROW | SCP0128_SafetyStock.spdMain_CellClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0128_SafetyStock.spdMain_CellClick: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 20 (ACT:SCP0128_SafetyStock.spdMain_CellClic) |
| WK-SCP0128-0281 | X-ROW | `PKG_SCP0128` GET_SEARCH_INFO/GET_SAFETY | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `PKG_SCP0128` GET_SEARCH_INFO/GET_SAFETY_STOCK/SAV: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`PKG_SCP0128` GET_SEARCH_INFO/GET_SAFETY) |
| WK-SCP0128-0282 | X-ROW | `usrButton1`(x0/y0/tab0) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `usrButton1`(x0/y0/tab0): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`usrButton1`(x0/y0/tab0)) |
| WK-SCP0128-0283 | X-ROW | — | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — —: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 0 () |
| WK-SCP0128-0284 | G5 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — 4: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (4) |
| WK-SCP0128-0285 | G5 | SCP0128_SafetyStock.SpdMain_CellDoubleCl | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCP0128_SafetyStock.SpdMain_CellDoubleClick: 진입점 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0128_SafetyStock.SpdMain_CellDoub) |
| WK-SCP0128-0286 | G5 | 조회조건 8개 논리조건(19 컨트롤+라벨) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — 조회조건 8개 논리조건(19 컨트롤+라벨): 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (조회조건 8개 논리조건(19 컨트롤+라벨)) |
| WK-SCP0128-0287 | H6 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — 4: 행 집계 — H6 3요소: NOPATH:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (4) |
| WK-SCP0128-0288 | H6 | SCP0128_SafetyStock.SpdMain_CellDoubleCl | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCP0128_SafetyStock.SpdMain_CellDoubleClick: 진입점 집계 — H6 2요소: NOPATH:1 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0128_SafetyStock.SpdMain_CellDoub) |
| WK-SCP0128-0289 | H6 | 조회조건 8개 논리조건(19 컨트롤+라벨) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — 조회조건 8개 논리조건(19 컨트롤+라벨): 행 집계 — H6 3요소: NOPATH:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (조회조건 8개 논리조건(19 컨트롤+라벨)) |
| WK-SCP0128-0290 | M4 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 4: 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (4) |
| WK-SCP0128-0291 | M4 | SCP0128_SafetyStock.SpdMain_CellDoubleCl | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0128_SafetyStock.SpdMain_CellDoubleClick: 진입점 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0128_SafetyStock.SpdMain_CellDoub) |
| WK-SCP0128-0292 | M4 | 조회조건 8개 논리조건(19 컨트롤+라벨) | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 조회조건 8개 논리조건(19 컨트롤+라벨): 행 집계 — M4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (조회조건 8개 논리조건(19 컨트롤+라벨)) |
