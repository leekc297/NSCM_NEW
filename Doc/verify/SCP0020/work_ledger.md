# 작업 원장 — SCP0020 · 2026-10-26 12:53

> 검사 인스턴스 401건 중 PASS·NA 28건 외 **373건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 4 | 구현 위치 실존 |
| W3 | 동작 수정 | 9 | 재판정 PASS |
| W4 | 검사기 구현 | 1 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 9 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 184 | 실행 → PASS |
| W7 | 기대값 확정 | 166 | 기대 확정 → PASS/FAIL |

- 담당: E2E 184 · 사람 판정 / AS-IS 원문 확인 → 재판정 164 · 하네스 10 · FE 8 · 대조표 6 · DB 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 2건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 46 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| E4 | EDIT |  |  |  |  |  | 28 | 5 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| C3 | CASCADE |  |  |  |  |  | 20 | 10 |  |  | 연쇄 자동 채움 |
| D4 | EDIT |  |  |  |  |  | 24 | 4 |  |  | 신규행 기본값·자동세팅·Insert 전제 |
| X-LOC | GEN |  | 4 |  |  |  |  | 21 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| D1 | EDIT |  |  |  |  |  | 18 | 2 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 18 | 2 |  |  | 행 값 기반 조건부 잠금 |
| H2 | DESIGN |  |  |  |  |  | 9 | 8 |  |  | 배경·글자색 규칙 |
| G1 | GEN |  |  |  |  |  | 6 | 9 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| C2 | CASCADE |  |  |  |  |  | 5 | 7 |  |  | 그리드 셀 cascade 후보 |
| C6 | CASCADE |  |  |  |  |  | 5 | 7 |  |  | 무변경 편집 종료 시 연쇄 미발동 |
| F4 | DB |  |  |  |  |  | 8 | 3 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| A5 | DESIGN |  |  |  |  |  | 3 | 8 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| A1 | GEN |  |  |  |  |  |  | 11 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| H5 | DESIGN |  |  |  |  |  | 3 | 7 |  |  | 라벨 명칭 |
| E3 | EDIT |  |  | 8 |  |  |  |  |  |  | 필수 입력 검증 |
| C1 | CASCADE |  |  |  |  |  | 5 | 2 |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| D5 | EDIT |  |  |  |  |  | 4 | 3 |  |  | 셀 에디터 유형 |
| A6 | GEN |  |  |  |  |  | 4 | 3 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| DB-SYN | DB |  |  |  |  | 2 |  | 3 |  |  | BE 계정 시노님·권한·대상 객체 |
| G4 | DESIGN |  |  |  |  |  | 4 |  |  |  | 조회조건 표시·라벨·활성 |
| E1 | EDIT |  |  |  |  |  | 4 |  |  |  | 숫자 소수자리·정수·부호·범위 |
| G6 | GEN |  |  |  |  |  | 4 |  |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| B4 | COMBO |  |  |  |  | 2 |  | 1 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| B1 | COMBO |  |  |  |  | 1 |  | 1 |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 1 |  | 1 |  |  | 콤보 후보 중복 없음 |
| X-REASON | DESIGN |  |  |  |  |  |  | 2 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| H10 | DESIGN |  |  | 1 |  |  |  |  |  |  | 메시지 표준(방식·코드 단일화) |
| B3 | COMBO |  |  |  | 1 |  |  |  |  |  | 콤보 후보 정렬 = AS-IS |
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
| H4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W2 구현 위치 확인 (4)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0020-0001 | X-LOC | 2 조회 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: modals/ItemSearchModal.tsx 없음 |  | 1 (2 조회) |
| WK-SCP0020-0002 | X-LOC | COMMON:UC-01 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: DataGrid.tsx 없음 |  | 1 (COMMON:UC-01) |
| WK-SCP0020-0003 | X-LOC | COMMON:UC-05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-05) |
| WK-SCP0020-0004 | X-LOC | COMMON:UC-07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-07) |

## W3 동작 수정 (9)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0020-0005 | H10 | SCP0020 화면 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | H10 FAIL 수정 — SCP0020 화면: 표준 메시지 대신 브라우저 alert/confirm 직접 호출: hooks/useTactTimeValidation.ts |  | 15 (MSG00193 MSG00085 / MSG00072 MSG00002 MS) |
| WK-SCP0020-0006 | E3 | COMMON:UC-04 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — COMMON:UC-04: 행 집계 — E3 5요소: PASS:4 · FAIL:1 |  | 1 (COMMON:UC-04) |
| WK-SCP0020-0007 | E3 | LINE_ID | DB(🛠️/🧯 적용 가능) | E3 FAIL 수정 — LINE_ID: 필수 표시 AS-IS *('Line*') ↔ TO-BE -('Line' INPUT_TP_CD=S) — 필수 여부 불일치(저장 검증 checkRequiredOfSpread 대상 차이) |  | 1 (MSG00002) |
| WK-SCP0020-0008 | E3 | MSG00048 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — MSG00048: 행 집계 — E3 5요소: PASS:4 · FAIL:1 |  | 1 (MSG00048) |
| WK-SCP0020-0009 | E3 | MSG00049 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — MSG00049: 행 집계 — E3 5요소: PASS:4 · FAIL:1 |  | 1 (MSG00049) |
| WK-SCP0020-0010 | E3 | MSG00105 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — MSG00105: 행 집계 — E3 5요소: PASS:4 · FAIL:1 |  | 1 (MSG00105) |
| WK-SCP0020-0011 | E3 | MSG00108 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — MSG00108: 행 집계 — E3 5요소: PASS:4 · FAIL:1 |  | 1 (MSG00108) |
| WK-SCP0020-0012 | E3 | MSG00109/00199/00161/00004/00006/00043 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — MSG00109/00199/00161/00004/00006/00043: 행 집계 — E3 5요소: PASS:4 · FAIL:1 |  | 1 (MSG00109/00199/00161/00004/00006/00043) |
| WK-SCP0020-0013 | E3 | static 8 (GMessageBoxForException) | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | E3 FAIL 수정 — static 8 (GMessageBoxForException): 행 집계 — E3 5요소: PASS:4 · FAIL:1 |  | 1 (static 8 (GMessageBoxForException)) |

## W4 검사기 구현 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0020-0014 | B3 | cboOperationGroup / Operation Group / Op | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboOperationGroup / Operation Group / Operation gr | 있음(FE 소스) | 0 () |

## W5 검사기 연결 (9)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0020-0015 | B1 | LINE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL LINE_ID | 있음(SHEET_COLUMNS) | 3 (ACT:SCP0020_TactTime.EditButton:641:44 A) |
| WK-SCP0020-0016 | B2 | LINE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL LINE_ID | 있음(SHEET_COLUMNS) | 3 (ACT:SCP0020_TactTime.EditButton:641:44 A) |
| WK-SCP0020-0017 | B4 | LINE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL LINE_ID | 있음(SHEET_COLUMNS) | 3 (ACT:SCP0020_TactTime.EditButton:641:44 A) |
| WK-SCP0020-0018 | B4 | cboOperationGroup / Operation Group / Op | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboOperationGroup / Operation Group / Operation gr | 있음(FE 소스) | 0 () |
| WK-SCP0020-0019 | F2 | SCP0020 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0020 화면 | 판단불가(대상 단위 SCREEN) | 511 (MSG00109/00199/00161/00004/00006/00043 S) |
| WK-SCP0020-0020 | F6 | SCP0020 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0020 화면 | 판단불가(대상 단위 SCREEN) | 510 (SCP0020_GET_TACT_TIME / _SAVE_TACT_TIME ) |
| WK-SCP0020-0021 | DB-SYN | SCP0020_GET_TACT_TIME_EXCEPT | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0020_GET_TACT_TIME_EXCEPT | 없음(PROC_M 대응 없음) | 5 (SCP0020_GET_TACT_TIME_EXCEPT(_OSP) / _SA) |
| WK-SCP0020-0022 | DB-SYN | SCP0020_SAVE_TACT_TIME_EXCEPT | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0020_SAVE_TACT_TIME_EXCEPT | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0020_TactTime.SaveData_Except:222) |
| WK-SCP0020-0023 | G03-WIRE | SCP0020 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0020 화면 | 판단불가(대상 단위 SCREEN) | 18 (ACT:SCP0020_TactTime..ctor ACT:SCP0020_T) |

## W6 검증 실행 (184)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0020-0024 | J2 | SCP0020 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0020 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 24 (2 조회 btnItemId_Click MSG00109/00199/0016) |
| WK-SCP0020-0025 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0020_TactTime.InitControls:217:4) |
| WK-SCP0020-0026 | C1 | cboOperationGroup / Operation Group / Op | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboOperationGroup / Operation Group / Operation gr · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0020_TactTime.InitControls:221:7) |
| WK-SCP0020-0027 | C1 | cboValid / Valid | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboValid / Valid · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0020_TactTime.InitControls:218:5) |
| WK-SCP0020-0028 | C1 | clbLine / Line | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbLine / Line · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:SCP0020_TactTime.RefreshLineByOperat) |
| WK-SCP0020-0029 | C1 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:SCP0020_TactTime.RefreshPlantSiteByD) |
| WK-SCP0020-0030 | C2 | DAILY_CAPACITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — DAILY_CAPACITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:SCP0020_TactTime.SpdExcept_Changed A) |
| WK-SCP0020-0031 | C2 | JUMBO_MIN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — JUMBO_MIN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0020_TactTime.SpdMain_Changed ACT) |
| WK-SCP0020-0032 | C2 | LANE_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — LANE_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCP0020_TactTime.SpdMain_Changed ACT) |
| WK-SCP0020-0033 | C2 | OPERATION_GROUP_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — OPERATION_GROUP_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCP0020_TactTime.SpdMain_Changed ACT) |
| WK-SCP0020-0034 | C2 | TACT_TIME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — TACT_TIME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 10 (MSG00203 ACT:SCP0020_TactTime.SpdExcept_) |
| WK-SCP0020-0035 | C3 | DAILY_CAPACITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DAILY_CAPACITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 7 (ACT:SCP0020_TactTime.InitSpread:410:8 AC) |
| WK-SCP0020-0036 | C3 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 9 (ACT:SCP0020_TactTime.InsertButton:781:19) |
| WK-SCP0020-0037 | C3 | EXCEPT_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — EXCEPT_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0020_TactTime.InsertButton:844:55) |
| WK-SCP0020-0038 | C3 | INPUT_STATUS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — INPUT_STATUS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCP0020_TactTime.InsertButton:843:54) |
| WK-SCP0020-0039 | C3 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 6 (ACT:SCP0020_TactTime.InsertButton:784:22) |
| WK-SCP0020-0040 | C3 | JUMBO_MIN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — JUMBO_MIN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0020_TactTime.SpdMain_Changed ACT) |
| WK-SCP0020-0041 | C3 | LANE_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — LANE_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SCP0020_TactTime.SpdMain_Changed ACT) |
| WK-SCP0020-0042 | C3 | LINE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — LINE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0020_TactTime.InsertButton:923:10) |
| WK-SCP0020-0043 | C3 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SCP0020_TactTime.InsertButton:788:25) |
| WK-SCP0020-0044 | C3 | OPERATION_GROUP_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — OPERATION_GROUP_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0020_TactTime.InsertButton:795:29) |
| WK-SCP0020-0045 | C3 | OPERATION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — OPERATION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 7 (ACT:SCP0020_TactTime.InsertButton:785:23) |
| WK-SCP0020-0046 | C3 | OPERATION_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — OPERATION_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0020_TactTime.InitSpread:411:9 AC) |
| WK-SCP0020-0047 | C3 | OSP_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — OSP_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCP0020_TactTime.InsertButton:845:56) |
| WK-SCP0020-0048 | C3 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 5 (ACT:SCP0020_TactTime.InsertButton:782:20) |
| WK-SCP0020-0049 | C3 | PLANT_SITE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PLANT_SITE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0020_TactTime.InsertButton:783:21) |
| WK-SCP0020-0050 | C3 | PRIORITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PRIORITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SCP0020_TactTime.SetSpreadInit ACT:S) |
| WK-SCP0020-0051 | C3 | SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCP0020_TactTime.InsertButton:838:49) |
| WK-SCP0020-0052 | C3 | TACT_TIME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — TACT_TIME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 14 (MSG00203 ACT:SCP0020_TactTime.CheckDigit) |
| WK-SCP0020-0053 | C3 | USE_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — USE_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCP0020_TactTime.InsertButton:925:10) |
| WK-SCP0020-0054 | C3 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCP0020_TactTime.InsertButton:789:26) |
| WK-SCP0020-0055 | C6 | DAILY_CAPACITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — DAILY_CAPACITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:SCP0020_TactTime.SpdExcept_Changed A) |
| WK-SCP0020-0056 | C6 | JUMBO_MIN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — JUMBO_MIN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0020_TactTime.SpdMain_Changed ACT) |
| WK-SCP0020-0057 | C6 | LANE_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — LANE_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCP0020_TactTime.SpdMain_Changed ACT) |
| WK-SCP0020-0058 | C6 | OPERATION_GROUP_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — OPERATION_GROUP_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCP0020_TactTime.SpdMain_Changed ACT) |
| WK-SCP0020-0059 | C6 | TACT_TIME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — TACT_TIME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 10 (MSG00203 ACT:SCP0020_TactTime.SpdExcept_) |
| WK-SCP0020-0060 | G3 | SCP0020 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0020 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 5 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-04 C) |
| WK-SCP0020-0061 | K-SA | SCP0020 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCP0020 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 0 () |
| WK-SCP0020-0062 | K4 | SCP0020 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0020 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 17 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-04 C) |
| WK-SCP0020-0063 | F1 | SCP0020 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0020 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 526 (MSG00109/00199/00161/00004/00006/00043 S) |
| WK-SCP0020-0064 | F3 | SCP0020 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F3 실행 — SCP0020 화면 · 검사기 있음(_trace.spec(@trace) W4b 붙여넣기 — Ctrl+C/Ctrl+V 로 셀 값 복사 후 값·연쇄) — 실행 필요: trace |  | 28 (ACT:SCP0020_TactTime.SpdMain_ClipboardPa) |
| WK-SCP0020-0065 | F5 | SCP0020 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0020 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 15 (ACT:SCP0020_TactTime.DeleteButton ACT:SC) |
| WK-SCP0020-0066 | F4 | PKG_SCP0020.P_SCP0020_GET_TACT_TIME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0020.P_SCP0020_GET_TACT_TIME · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smok |  | 184 (SCP0020_GET_TACT_TIME / _SAVE_TACT_TIME ) |
| WK-SCP0020-0067 | F4 | PKG_SCP0020.P_SCP0020_GET_TACT_TIME_EXCE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0020.P_SCP0020_GET_TACT_TIME_EXCEPT_OSP · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) —  |  | 175 (ACT:SCP0020_TactTime.FindData_Except_Pac) |
| WK-SCP0020-0068 | F4 | PKG_SCP0020.P_SCP0020_GET_TACT_TIME_OSP | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0020.P_SCP0020_GET_TACT_TIME_OSP · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요:  |  | 129 (SCP0020_GET_TACT_TIME_OSP / _SAVE_TACT_T) |
| WK-SCP0020-0069 | F4 | PKG_SCP0020.P_SCP0020_SAVE_TACT_TIME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0020.P_SCP0020_SAVE_TACT_TIME · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smo |  | 138 (ACT:SCP0020_TactTime.SaveButton ACT:SCP0) |
| WK-SCP0020-0070 | F4 | PKG_SCP0020.P_SCP0020_SAVE_TACT_TIME_EXC | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0020.P_SCP0020_SAVE_TACT_TIME_EXCEPT_OSP · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — |  | 142 (ACT:SCP0020_TactTime.SaveButton ACT:SCP0) |
| WK-SCP0020-0071 | F4 | PKG_SCP0020.P_SCP0020_SAVE_TACT_TIME_OSP | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0020.P_SCP0020_SAVE_TACT_TIME_OSP · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: |  | 124 (ACT:SCP0020_TactTime.SaveButton ACT:SCP0) |
| WK-SCP0020-0072 | F4 | SCP0020_GET_TACT_TIME_EXCEPT | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0020_GET_TACT_TIME_EXCEPT · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 173 (SCP0020_GET_TACT_TIME_EXCEPT(_OSP) / _SA) |
| WK-SCP0020-0073 | F4 | SCP0020_SAVE_TACT_TIME_EXCEPT | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0020_SAVE_TACT_TIME_EXCEPT · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trac |  | 139 (ACT:SCP0020_TactTime.SaveButton ACT:SCP0) |
| WK-SCP0020-0074 | A5 | DAILY_CAPACITY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DAILY_CAPACITY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 4 (ACT:SCP0020_TactTime.InitSpread ACT:SCP0) |
| WK-SCP0020-0075 | A5 | OPERATION_NAME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — OPERATION_NAME · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCP0020_TactTime.InitSpread ACT:SCP0) |
| WK-SCP0020-0076 | A5 | PRIORITY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PRIORITY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:SCP0020_TactTime.SetSpreadInit ACT:S) |
| WK-SCP0020-0077 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 6 (ACT:SCP0020_TactTime.DefineProperty ACT:) |
| WK-SCP0020-0078 | G4 | cboOperationGroup / Operation Group / Op | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboOperationGroup / Operation Group / Operation gr · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0020_TactTime.InitControls ACT:SC) |
| WK-SCP0020-0079 | G4 | cboValid / Valid | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboValid / Valid · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0020_TactTime.InitControls ACT:SC) |
| WK-SCP0020-0080 | G4 | clbPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbPlantSite / Plant Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0020_TactTime.InitEvent ACT:SCP00) |
| WK-SCP0020-0081 | H2 | DAILY_CAPACITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DAILY_CAPACITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0020_TactTime.InitSpread ACT:SCP0) |
| WK-SCP0020-0082 | H2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0020_TactTime.SaveData_Main:1866:) |
| WK-SCP0020-0083 | H2 | EXCEPT_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — EXCEPT_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCP0020_TactTime.setExceptYnColor AC) |
| WK-SCP0020-0084 | H2 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCP0020_TactTime.setExceptYnColor AC) |
| WK-SCP0020-0085 | H2 | LINE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — LINE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0020_TactTime.SaveData_Main:1866:) |
| WK-SCP0020-0086 | H2 | OPERATION_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — OPERATION_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCP0020_TactTime.InitSpread ACT:SCP0) |
| WK-SCP0020-0087 | H2 | PRIORITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PRIORITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCP0020_TactTime.SetSpreadInit ACT:S) |
| WK-SCP0020-0088 | H2 | TACT_TIME_END_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — TACT_TIME_END_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0020_TactTime.SaveData_Except:228) |
| WK-SCP0020-0089 | H2 | TACT_TIME_START_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — TACT_TIME_START_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0020_TactTime.SaveData_Except:228) |
| WK-SCP0020-0090 | H4 | SCP0020 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — SCP0020 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 8 (ACT:SCP0020_TactTime.SpdExcept_TopChange) |
| WK-SCP0020-0091 | H5 | DAILY_CAPACITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — DAILY_CAPACITY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (ACT:SCP0020_TactTime.InitSpread ACT:SCP0) |
| WK-SCP0020-0092 | H5 | OPERATION_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — OPERATION_NAME · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCP0020_TactTime.InitSpread ACT:SCP0) |
| WK-SCP0020-0093 | H5 | PRIORITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PRIORITY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:SCP0020_TactTime.SetSpreadInit ACT:S) |
| WK-SCP0020-0094 | I1 | SCP0020 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0020 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 58 (MSG00193 MSG00085 / MSG00072 MSG00002 MS) |
| WK-SCP0020-0095 | D1 | BIG_LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — BIG_LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SCP0020_TactTime.EditButton:569:10 A) |
| WK-SCP0020-0096 | D1 | CREATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CREATED_BY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SCP0020_TactTime.EditButton:677:60 A) |
| WK-SCP0020-0097 | D1 | DAILY_CAPACITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DAILY_CAPACITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 6 (ACT:SCP0020_TactTime.EditButton ACT:SCP0) |
| WK-SCP0020-0098 | D1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 9 (ACT:SCP0020_TactTime.EditButton ACT:SCP0) |
| WK-SCP0020-0099 | D1 | EXCEPT_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — EXCEPT_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SCP0020_TactTime.InsertButton:848:58) |
| WK-SCP0020-0100 | D1 | INPUT_STATUS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — INPUT_STATUS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 6 (ACT:SCP0020_TactTime.EditButton ACT:SCP0) |
| WK-SCP0020-0101 | D1 | ITEM_UOM | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — ITEM_UOM · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:SCP0020_TactTime.EditButton ACT:SCP0) |
| WK-SCP0020-0102 | D1 | JUMBO_MIN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — JUMBO_MIN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SCP0020_TactTime.EditButton ACT:SCP0) |
| WK-SCP0020-0103 | D1 | LANE_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LANE_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:SCP0020_TactTime.EditButton ACT:SCP0) |
| WK-SCP0020-0104 | D1 | LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SCP0020_TactTime.EditButton:677:60 A) |
| WK-SCP0020-0105 | D1 | LINE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LINE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 7 (ACT:SCP0020_TactTime.EditButton ACT:SCP0) |
| WK-SCP0020-0106 | D1 | MODEL_SITE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — MODEL_SITE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:SCP0020_TactTime.EditButton ACT:SCP0) |
| WK-SCP0020-0107 | D1 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:SCP0020_TactTime.EditButton:568:9 AC) |
| WK-SCP0020-0108 | D1 | OPERATION_GROUP_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — OPERATION_GROUP_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 5 (ACT:SCP0020_TactTime.EditButton ACT:SCP0) |
| WK-SCP0020-0109 | D1 | OSP_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — OSP_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SCP0020_TactTime.EditButton:611:27 A) |
| WK-SCP0020-0110 | D1 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SCP0020_TactTime.EditButton ACT:SCP0) |
| WK-SCP0020-0111 | D1 | TACT_TIME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — TACT_TIME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 9 (ACT:SCP0020_TactTime.EditButton ACT:SCP0) |
| WK-SCP0020-0112 | D1 | UOM_CONVERT_VALUE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — UOM_CONVERT_VALUE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SCP0020_TactTime.EditButton:577:13 A) |
| WK-SCP0020-0113 | D3 | BIG_LAST_UPDATE_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — BIG_LAST_UPDATE_DATE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SCP0020_TactTime.EditButton:569:10 A) |
| WK-SCP0020-0114 | D3 | CREATED_BY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CREATED_BY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SCP0020_TactTime.EditButton:677:60 A) |
| WK-SCP0020-0115 | D3 | DAILY_CAPACITY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DAILY_CAPACITY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 6 (ACT:SCP0020_TactTime.EditButton ACT:SCP0) |
| WK-SCP0020-0116 | D3 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 9 (ACT:SCP0020_TactTime.EditButton ACT:SCP0) |
| WK-SCP0020-0117 | D3 | EXCEPT_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — EXCEPT_YN · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SCP0020_TactTime.InsertButton:848:58) |
| WK-SCP0020-0118 | D3 | INPUT_STATUS | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — INPUT_STATUS · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 6 (ACT:SCP0020_TactTime.EditButton ACT:SCP0) |
| WK-SCP0020-0119 | D3 | ITEM_UOM | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ITEM_UOM · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:SCP0020_TactTime.EditButton ACT:SCP0) |
| WK-SCP0020-0120 | D3 | JUMBO_MIN | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — JUMBO_MIN · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SCP0020_TactTime.EditButton ACT:SCP0) |
| WK-SCP0020-0121 | D3 | LANE_QTY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LANE_QTY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:SCP0020_TactTime.EditButton ACT:SCP0) |
| WK-SCP0020-0122 | D3 | LAST_UPDATE_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LAST_UPDATE_DATE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SCP0020_TactTime.EditButton:677:60 A) |
| WK-SCP0020-0123 | D3 | LINE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LINE_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 7 (ACT:SCP0020_TactTime.EditButton ACT:SCP0) |
| WK-SCP0020-0124 | D3 | MODEL_SITE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — MODEL_SITE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:SCP0020_TactTime.EditButton ACT:SCP0) |
| WK-SCP0020-0125 | D3 | NICK_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — NICK_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:SCP0020_TactTime.EditButton:568:9 AC) |
| WK-SCP0020-0126 | D3 | OPERATION_GROUP_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — OPERATION_GROUP_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 5 (ACT:SCP0020_TactTime.EditButton ACT:SCP0) |
| WK-SCP0020-0127 | D3 | OSP_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — OSP_YN · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SCP0020_TactTime.EditButton:611:27 A) |
| WK-SCP0020-0128 | D3 | PLANT_SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PLANT_SITE_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SCP0020_TactTime.EditButton ACT:SCP0) |
| WK-SCP0020-0129 | D3 | TACT_TIME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — TACT_TIME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 9 (ACT:SCP0020_TactTime.EditButton ACT:SCP0) |
| WK-SCP0020-0130 | D3 | UOM_CONVERT_VALUE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — UOM_CONVERT_VALUE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SCP0020_TactTime.EditButton:577:13 A) |
| WK-SCP0020-0131 | D4 | BIG_LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — BIG_LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (ACT:SCP0020_TactTime.InsertButton:792:28) |
| WK-SCP0020-0132 | D4 | CREATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — CREATED_BY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (ACT:SCP0020_TactTime.InsertButton:929:10) |
| WK-SCP0020-0133 | D4 | DAILY_CAPACITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — DAILY_CAPACITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 4 (ACT:SCP0020_TactTime.InsertButton ACT:SC) |
| WK-SCP0020-0134 | D4 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 11 (ACT:SCP0020_TactTime.InsertButton ACT:SC) |
| WK-SCP0020-0135 | D4 | EXCEPT_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — EXCEPT_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 2 (ACT:SCP0020_TactTime.InsertButton:844:55) |
| WK-SCP0020-0136 | D4 | INPUT_STATUS | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — INPUT_STATUS · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (ACT:SCP0020_TactTime.InsertButton:843:54) |
| WK-SCP0020-0137 | D4 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 7 (ACT:SCP0020_TactTime.InsertButton ACT:SC) |
| WK-SCP0020-0138 | D4 | ITEM_UOM | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — ITEM_UOM · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 3 (ACT:SCP0020_TactTime.InsertButton ACT:SC) |
| WK-SCP0020-0139 | D4 | JUMBO_MIN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — JUMBO_MIN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 2 (ACT:SCP0020_TactTime.InsertButton ACT:SC) |
| WK-SCP0020-0140 | D4 | LANE_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — LANE_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 3 (ACT:SCP0020_TactTime.InsertButton ACT:SC) |
| WK-SCP0020-0141 | D4 | LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (ACT:SCP0020_TactTime.InsertButton:929:10) |
| WK-SCP0020-0142 | D4 | LINE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — LINE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 4 (ACT:SCP0020_TactTime.InsertButton:864:69) |
| WK-SCP0020-0143 | D4 | NICK_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — NICK_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 9 (ACT:SCP0020_TactTime.InsertButton ACT:SC) |
| WK-SCP0020-0144 | D4 | OPERATION_GROUP_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — OPERATION_GROUP_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 4 (ACT:SCP0020_TactTime.InsertButton ACT:SC) |
| WK-SCP0020-0145 | D4 | OPERATION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — OPERATION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 7 (ACT:SCP0020_TactTime.InsertButton ACT:SC) |
| WK-SCP0020-0146 | D4 | OPERATION_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — OPERATION_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 6 (ACT:SCP0020_TactTime.InsertButton ACT:SC) |
| WK-SCP0020-0147 | D4 | OSP_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — OSP_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 2 (ACT:SCP0020_TactTime.InsertButton:845:56) |
| WK-SCP0020-0148 | D4 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 7 (ACT:SCP0020_TactTime.InsertButton ACT:SC) |
| WK-SCP0020-0149 | D4 | PLANT_SITE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — PLANT_SITE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 6 (ACT:SCP0020_TactTime.InsertButton ACT:SC) |
| WK-SCP0020-0150 | D4 | SITE_DESCRIPTION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — SITE_DESCRIPTION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 5 (ACT:SCP0020_TactTime.InsertButton ACT:SC) |
| WK-SCP0020-0151 | D4 | TACT_TIME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — TACT_TIME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 5 (ACT:SCP0020_TactTime.InsertButton:800:31) |
| WK-SCP0020-0152 | D4 | UOM_CONVERT_VALUE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — UOM_CONVERT_VALUE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (ACT:SCP0020_TactTime.InsertButton:806:33) |
| WK-SCP0020-0153 | D4 | USE_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — USE_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (ACT:SCP0020_TactTime.InsertButton:925:10) |
| WK-SCP0020-0154 | D4 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 2 (ACT:SCP0020_TactTime.InsertButton ACT:SC) |
| WK-SCP0020-0155 | D5 | DAILY_CAPACITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — DAILY_CAPACITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:SCP0020_TactTime.InitSpread ACT:SCP0) |
| WK-SCP0020-0156 | D5 | LINE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — LINE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCP0020_TactTime.EditButton:641:44 A) |
| WK-SCP0020-0157 | D5 | OPERATION_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — OPERATION_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCP0020_TactTime.InitSpread ACT:SCP0) |
| WK-SCP0020-0158 | D5 | PRIORITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — PRIORITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:SCP0020_TactTime.SetSpreadInit ACT:S) |
| WK-SCP0020-0159 | D6 | SCP0020 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0020 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 115 (MSG00109/00199/00161/00004/00006/00043 S) |
| WK-SCP0020-0160 | E1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 4 (ACT:SCP0020_TactTime.SpdMain_ClipboardPa) |
| WK-SCP0020-0161 | E1 | LINE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — LINE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 3 (ACT:SCP0020_TactTime.SpdMain_ClipboardPa) |
| WK-SCP0020-0162 | E1 | OPERATION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — OPERATION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 4 (ACT:SCP0020_TactTime.SpdMain_ClipboardPa) |
| WK-SCP0020-0163 | E1 | PLANT_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — PLANT_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 2 (ACT:SCP0020_TactTime.SpdMain_ClipboardPa) |
| WK-SCP0020-0164 | E4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0020_TactTime.SetChangedControl_O) |
| WK-SCP0020-0165 | E4 | EXCEPT_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — EXCEPT_YN · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SCP0020_TactTime.setExceptYnColor AC) |
| WK-SCP0020-0166 | E4 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SCP0020_TactTime.setExceptYnColor AC) |
| WK-SCP0020-0167 | E4 | LANE_QTY | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — LANE_QTY · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (MSG00002) |
| WK-SCP0020-0168 | E4 | LINE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — LINE_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (MSG00002) |
| WK-SCP0020-0169 | E4 | MSG00002 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00002 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (MSG00002 ACT:SCP0020_TactTime.InsertButt) |
| WK-SCP0020-0170 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SCP0020_TactTime.SaveData_Except:226) |
| WK-SCP0020-0171 | E4 | MSG00006 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00006 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SCP0020_TactTime.SaveData_Except:229) |
| WK-SCP0020-0172 | E4 | MSG00043 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00043 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SCP0020_TactTime.SaveData_Except:227) |
| WK-SCP0020-0173 | E4 | MSG00048 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00048 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00048 ACT:SCP0020_TactTime.checkValid) |
| WK-SCP0020-0174 | E4 | MSG00049 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00049 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (MSG00049 ACT:SCP0020_TactTime.checkValid) |
| WK-SCP0020-0175 | E4 | MSG00072 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00072 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (MSG00085 / MSG00072 ACT:SCP0020_TactTime) |
| WK-SCP0020-0176 | E4 | MSG00085 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00085 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (MSG00085 / MSG00072 ACT:SCP0020_TactTime) |
| WK-SCP0020-0177 | E4 | MSG00105 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00105 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00105 ACT:SCP0020_TactTime.checkValid) |
| WK-SCP0020-0178 | E4 | MSG00108 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00108 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (MSG00108 ACT:SCP0020_TactTime.checkValid) |
| WK-SCP0020-0179 | E4 | MSG00109 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00109 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (MSG00109/00199/00161/00004/00006/00043 A) |
| WK-SCP0020-0180 | E4 | MSG00161 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00161 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0020_TactTime.InsertButton:875:73) |
| WK-SCP0020-0181 | E4 | MSG00193 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00193 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 7 (MSG00193 ACT:SCP0020_TactTime.SaveData_E) |
| WK-SCP0020-0182 | E4 | MSG00199 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00199 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0020_TactTime.EditButton:659:51) |
| WK-SCP0020-0183 | E4 | MSG00203 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00203 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (MSG00203 ACT:SCP0020_TactTime.CheckDigit) |
| WK-SCP0020-0184 | E4 | MSG00704 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00704 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (COMMON:UC-02) |
| WK-SCP0020-0185 | E4 | PRIORITY | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — PRIORITY · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (MSG00193 ACT:SCP0020_TactTime.SetSpreadI) |
| WK-SCP0020-0186 | E4 | TACT_TIME | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — TACT_TIME · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (MSG00193 MSG00203 ACT:SCP0020_TactTime.C) |
| WK-SCP0020-0187 | E4 | TACT_TIME_END_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — TACT_TIME_END_DATE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0020_TactTime.checkValidN0:2352:1) |
| WK-SCP0020-0188 | E4 | TACT_TIME_START_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — TACT_TIME_START_DATE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: |  | 1 (ACT:SCP0020_TactTime.checkValidN0:2341:1) |
| WK-SCP0020-0189 | E4 | YIELD | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — YIELD · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (MSG00085 / MSG00072) |
| WK-SCP0020-0190 | E4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 9 (ACT:SCP0020_TactTime.SetChangedControl A) |
| WK-SCP0020-0191 | E4 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실 |  | 2 (ACT:SCP0020_TactTime.SetChangedControl_O) |
| WK-SCP0020-0192 | A10 | SCP0020 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0020 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 54 (ACT:SCP0020_TactTime.DefineProperty ACT:) |
| WK-SCP0020-0193 | A6 | PKG_SCP0020.P_SCP0020_GET_TACT_TIME | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0020.P_SCP0020_GET_TACT_TIME · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _tr |  | 47 (SCP0020_GET_TACT_TIME / _SAVE_TACT_TIME ) |
| WK-SCP0020-0194 | A6 | PKG_SCP0020.P_SCP0020_GET_TACT_TIME_EXCE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0020.P_SCP0020_GET_TACT_TIME_EXCEPT_OSP · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새 |  | 34 (ACT:SCP0020_TactTime.FindData_Except_Pac) |
| WK-SCP0020-0195 | A6 | PKG_SCP0020.P_SCP0020_GET_TACT_TIME_OSP | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0020.P_SCP0020_GET_TACT_TIME_OSP · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · |  | 3 (SCP0020_GET_TACT_TIME_OSP / _SAVE_TACT_T) |
| WK-SCP0020-0196 | A6 | SCP0020_GET_TACT_TIME_EXCEPT | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SCP0020_GET_TACT_TIME_EXCEPT · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spe |  | 35 (SCP0020_GET_TACT_TIME_EXCEPT(_OSP) / _SA) |
| WK-SCP0020-0197 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 6 (ACT:SCP0020_TactTime.FindData_Main ACT:S) |
| WK-SCP0020-0198 | G1 | cboOperationGroup / Operation Group / Op | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboOperationGroup / Operation Group / Operation gr · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0020_TactTime.FindData_Main ACT:S) |
| WK-SCP0020-0199 | G1 | cboValid / Valid | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboValid / Valid · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0020_TactTime.FindData_Main ACT:S) |
| WK-SCP0020-0200 | G1 | clbLine / Line | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbLine / Line · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0020_TactTime.FindData_Main ACT:S) |
| WK-SCP0020-0201 | G1 | clbPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbPlantSite / Plant Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 6 (ACT:SCP0020_TactTime.FindData_Main ACT:S) |
| WK-SCP0020-0202 | G1 | txtItemId / Model / Item Id / Model/Nick | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (2 조회 ACT:SCP0020_TactTime.FindData_Main ) |
| WK-SCP0020-0203 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 6 (ACT:SCP0020_TactTime.DefineProperty ACT:) |
| WK-SCP0020-0204 | G6 | cboOperationGroup / Operation Group / Op | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboOperationGroup / Operation Group / Operation gr · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0020_TactTime.InitControls ACT:SC) |
| WK-SCP0020-0205 | G6 | cboValid / Valid | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboValid / Valid · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0020_TactTime.InitControls ACT:SC) |
| WK-SCP0020-0206 | G6 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0020_TactTime.InitEvent ACT:SCP00) |
| WK-SCP0020-0207 | X-REOPEN | SCP0020 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0020 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 12 (ACT:SCP0020_TactTime.Dispose ACT:SCP0020) |

## W7 기대값 확정 (166)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0020-0208 | C1 | ClbDivision_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — ClbDivision_SelectedIndexChanged: 행 집계 — C1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (ClbDivision_SelectedIndexChanged) |
| WK-SCP0020-0209 | C1 | ClbPlantSite_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — ClbPlantSite_SelectedIndexChanged: 행 집계 — C1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (ClbPlantSite_SelectedIndexChanged) |
| WK-SCP0020-0210 | C2 | SCP0020_TactTime.ClbDivision_SelectedInd | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0020_TactTime.ClbDivision_SelectedIndexChanged: 진입점 집계 — C2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0020_TactTime.ClbDivision_Selecte) |
| WK-SCP0020-0211 | C2 | SCP0020_TactTime.ClbPlantSite_SelectedIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0020_TactTime.ClbPlantSite_SelectedIndexChanged: 진입점 집계 — C2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0020_TactTime.ClbPlantSite_Select) |
| WK-SCP0020-0212 | C2 | SCP0020_TactTime.SpdExcept_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0020_TactTime.SpdExcept_Changed: 진입점 집계 — C2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 11 (ACT:SCP0020_TactTime.SpdExcept_Changed:2) |
| WK-SCP0020-0213 | C2 | SCP0020_TactTime.SpdMain_ActiveSheetChan | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0020_TactTime.SpdMain_ActiveSheetChanged: 진입점 집계 — C2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0020_TactTime.SpdMain_ActiveSheet) |
| WK-SCP0020-0214 | C2 | SCP0020_TactTime.SpdMain_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0020_TactTime.SpdMain_Changed: 진입점 집계 — C2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 11 (ACT:SCP0020_TactTime.SpdMain_Changed:260) |
| WK-SCP0020-0215 | C2 | SpdMain_EditChange / EditModeOff | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SpdMain_EditChange / EditModeOff: 행 집계 — C2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (SpdMain_EditChange / EditModeOff) |
| WK-SCP0020-0216 | C2 | spdExcept_EditChange / EditModeOff | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — spdExcept_EditChange / EditModeOff: 행 집계 — C2 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (spdExcept_EditChange / EditModeOff) |
| WK-SCP0020-0217 | C3 | SCP0020_TactTime.ClbDivision_SelectedInd | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0020_TactTime.ClbDivision_SelectedIndexChanged: 진입점 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0020_TactTime.ClbDivision_Selecte) |
| WK-SCP0020-0218 | C3 | SCP0020_TactTime.ClbPlantSite_SelectedIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0020_TactTime.ClbPlantSite_SelectedIndexChanged: 진입점 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0020_TactTime.ClbPlantSite_Select) |
| WK-SCP0020-0219 | C3 | SCP0020_TactTime.SetChangedControl_Osp | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0020_TactTime.SetChangedControl_Osp: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0020_TactTime.SetChangedControl_O) |
| WK-SCP0020-0220 | C3 | SCP0020_TactTime.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0020_TactTime.SetSpreadInit: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCP0020_TactTime.SetSpreadInit:433:1) |
| WK-SCP0020-0221 | C3 | SCP0020_TactTime.SpdExcept_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0020_TactTime.SpdExcept_Changed: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 11 (ACT:SCP0020_TactTime.SpdExcept_Changed:2) |
| WK-SCP0020-0222 | C3 | SCP0020_TactTime.SpdMain_ActiveSheetChan | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0020_TactTime.SpdMain_ActiveSheetChanged: 진입점 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0020_TactTime.SpdMain_ActiveSheet) |
| WK-SCP0020-0223 | C3 | SCP0020_TactTime.SpdMain_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0020_TactTime.SpdMain_Changed: 진입점 집계 — C3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 11 (ACT:SCP0020_TactTime.SpdMain_Changed:260) |
| WK-SCP0020-0224 | C3 | SCP0020_TactTime.setExceptYnColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0020_TactTime.setExceptYnColor: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0020_TactTime.setExceptYnColor:25) |
| WK-SCP0020-0225 | C3 | SpdMain_EditChange / EditModeOff | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SpdMain_EditChange / EditModeOff: 행 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (SpdMain_EditChange / EditModeOff) |
| WK-SCP0020-0226 | C3 | spdExcept_EditChange / EditModeOff | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — spdExcept_EditChange / EditModeOff: 행 집계 — C3 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (spdExcept_EditChange / EditModeOff) |
| WK-SCP0020-0227 | C6 | SCP0020_TactTime.ClbDivision_SelectedInd | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0020_TactTime.ClbDivision_SelectedIndexChanged: 진입점 집계 — C6 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0020_TactTime.ClbDivision_Selecte) |
| WK-SCP0020-0228 | C6 | SCP0020_TactTime.ClbPlantSite_SelectedIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0020_TactTime.ClbPlantSite_SelectedIndexChanged: 진입점 집계 — C6 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0020_TactTime.ClbPlantSite_Select) |
| WK-SCP0020-0229 | C6 | SCP0020_TactTime.SpdExcept_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0020_TactTime.SpdExcept_Changed: 진입점 집계 — C6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 11 (ACT:SCP0020_TactTime.SpdExcept_Changed:2) |
| WK-SCP0020-0230 | C6 | SCP0020_TactTime.SpdMain_ActiveSheetChan | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0020_TactTime.SpdMain_ActiveSheetChanged: 진입점 집계 — C6 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0020_TactTime.SpdMain_ActiveSheet) |
| WK-SCP0020-0231 | C6 | SCP0020_TactTime.SpdMain_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0020_TactTime.SpdMain_Changed: 진입점 집계 — C6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 11 (ACT:SCP0020_TactTime.SpdMain_Changed:260) |
| WK-SCP0020-0232 | C6 | SpdMain_EditChange / EditModeOff | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SpdMain_EditChange / EditModeOff: 행 집계 — C6 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (SpdMain_EditChange / EditModeOff) |
| WK-SCP0020-0233 | C6 | spdExcept_EditChange / EditModeOff | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — spdExcept_EditChange / EditModeOff: 행 집계 — C6 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (spdExcept_EditChange / EditModeOff) |
| WK-SCP0020-0234 | B1 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — COMMON:UC-05: 행 집계 — B1 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0020-0235 | B2 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — COMMON:UC-05: 행 집계 — B2 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0020-0236 | B4 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — COMMON:UC-05: 행 집계 — B4 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0020-0237 | DB-SYN | SCM0002 Item 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SCM0002 Item 팝업: 행 집계 — DB-SYN 8요소: PASS:6 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (SCM0002 Item 팝업) |
| WK-SCP0020-0238 | DB-SYN | SCP0020_TactTime.FindData_Main_MaxValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SCP0020_TactTime.FindData_Main_MaxValue: 진입점 집계 — DB-SYN 8요소: PASS:6 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0020_TactTime.FindData_Main_MaxVa) |
| WK-SCP0020-0239 | DB-SYN | SCP0020_TactTime.FindData_Packer_MaxValu | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SCP0020_TactTime.FindData_Packer_MaxValue: 진입점 집계 — DB-SYN 8요소: PASS:6 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0020_TactTime.FindData_Packer_Max) |
| WK-SCP0020-0240 | F4 | SCM0002 Item 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCM0002 Item 팝업: 행 집계 — F4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (SCM0002 Item 팝업) |
| WK-SCP0020-0241 | F4 | SCP0020_TactTime.FindData_Main_MaxValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0020_TactTime.FindData_Main_MaxValue: 진입점 집계 — F4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 27 (ACT:SCP0020_TactTime.FindData_Main_MaxVa) |
| WK-SCP0020-0242 | F4 | SCP0020_TactTime.FindData_Packer_MaxValu | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0020_TactTime.FindData_Packer_MaxValue: 진입점 집계 — F4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 23 (ACT:SCP0020_TactTime.FindData_Packer_Max) |
| WK-SCP0020-0243 | A5 | 2 조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 2 조회: 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0020-0244 | A5 | 3 그리드 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 3 그리드: 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (3 그리드) |
| WK-SCP0020-0245 | A5 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-01: 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SCP0020-0246 | A5 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-05: 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0020-0247 | A5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-07: 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0020-0248 | A5 | SCP0020_TactTime.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0020_TactTime.CreateSpread: 진입점 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCP0020_TactTime.CreateSpread:374:1 ) |
| WK-SCP0020-0249 | A5 | SCP0020_TactTime.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0020_TactTime.SetSpreadInit: 진입점 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCP0020_TactTime.SetSpreadInit:433:1) |
| WK-SCP0020-0250 | A5 | SmartColMerge | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SmartColMerge: 행 집계 — A5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (SmartColMerge) |
| WK-SCP0020-0251 | H2 | 3 그리드 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 3 그리드: 행 집계 — H2 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (3 그리드) |
| WK-SCP0020-0252 | H2 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-01: 행 집계 — H2 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SCP0020-0253 | H2 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-05: 행 집계 — H2 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0020-0254 | H2 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-07: 행 집계 — H2 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0020-0255 | H2 | SCP0020_TactTime.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0020_TactTime.CreateSpread: 진입점 집계 — H2 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCP0020_TactTime.CreateSpread:374:1 ) |
| WK-SCP0020-0256 | H2 | SCP0020_TactTime.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0020_TactTime.SetSpreadInit: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCP0020_TactTime.SetSpreadInit:433:1) |
| WK-SCP0020-0257 | H2 | SCP0020_TactTime.setExceptYnColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0020_TactTime.setExceptYnColor: 진입점 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0020_TactTime.setExceptYnColor:25) |
| WK-SCP0020-0258 | H2 | SmartColMerge | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SmartColMerge: 행 집계 — H2 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (SmartColMerge) |
| WK-SCP0020-0259 | H5 | 3 그리드 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 3 그리드: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (3 그리드) |
| WK-SCP0020-0260 | H5 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-01: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SCP0020-0261 | H5 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-05: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0020-0262 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0020-0263 | H5 | SCP0020_TactTime.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0020_TactTime.CreateSpread: 진입점 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCP0020_TactTime.CreateSpread:374:1 ) |
| WK-SCP0020-0264 | H5 | SCP0020_TactTime.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0020_TactTime.SetSpreadInit: 진입점 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCP0020_TactTime.SetSpreadInit:433:1) |
| WK-SCP0020-0265 | H5 | SmartColMerge | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SmartColMerge: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (SmartColMerge) |
| WK-SCP0020-0266 | X-REASON | COMMON:UC-03 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-03 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도  해당없음 — SCP0020 은 SHEET_COLUMNS 메타 구동 정적 |  | 1 (COMMON:UC-03) |
| WK-SCP0020-0267 | X-REASON | COMMON:UC-06 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-06 Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회  해당없음 — SCP0020 조회조건에 자유 텍스트 key-in 필드 없음. txtItemId 는 AS-IS Usr |  | 1 (COMMON:UC-06) |
| WK-SCP0020-0268 | D1 | LockColumn/LockRange (편집잠금 white-list) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — LockColumn/LockRange (편집잠금 white-list): 행 집계 — D1 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (LockColumn/LockRange (편집잠금 white-list)) |
| WK-SCP0020-0269 | D1 | SCP0020_TactTime.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SCP0020_TactTime.EditButton: 진입점 집계 — D1 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 30 (ACT:SCP0020_TactTime.EditButton:550:1 AC) |
| WK-SCP0020-0270 | D3 | LockColumn/LockRange (편집잠금 white-list) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — LockColumn/LockRange (편집잠금 white-list): 행 집계 — D3 18요소: NOT_RUN:18 (미실행 요소가 남아 판정필요) |  | 1 (LockColumn/LockRange (편집잠금 white-list)) |
| WK-SCP0020-0271 | D3 | SCP0020_TactTime.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SCP0020_TactTime.EditButton: 진입점 집계 — D3 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 30 (ACT:SCP0020_TactTime.EditButton:550:1 AC) |
| WK-SCP0020-0272 | D4 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — COMMON:UC-01: 행 집계 — D4 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SCP0020-0273 | D4 | MSG00109/00199/00161/00004/00006/00043 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — MSG00109/00199/00161/00004/00006/00043: 행 집계 — D4 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (MSG00109/00199/00161/00004/00006/00043) |
| WK-SCP0020-0274 | D4 | SetValue Insert 기본값 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — SetValue Insert 기본값: 행 집계 — D4 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (SetValue Insert 기본값) |
| WK-SCP0020-0275 | D4 | SetValue 파생 Auto-Sync | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — SetValue 파생 Auto-Sync: 행 집계 — D4 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (SetValue 파생 Auto-Sync) |
| WK-SCP0020-0276 | D5 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — COMMON:UC-05: 행 집계 — D5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0020-0277 | D5 | SCP0020_TactTime.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0020_TactTime.CreateSpread: 진입점 집계 — D5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCP0020_TactTime.CreateSpread:374:1 ) |
| WK-SCP0020-0278 | D5 | SCP0020_TactTime.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0020_TactTime.SetSpreadInit: 진입점 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCP0020_TactTime.SetSpreadInit:433:1) |
| WK-SCP0020-0279 | E4 | COMMON:UC-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — COMMON:UC-04: 행 집계 — E4 28요소: NOT_RUN:28 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-04) |
| WK-SCP0020-0280 | E4 | SCP0020_TactTime.SetChangedControl_Osp | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0020_TactTime.SetChangedControl_Osp: 진입점 집계 — E4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0020_TactTime.SetChangedControl_O) |
| WK-SCP0020-0281 | E4 | SCP0020_TactTime.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0020_TactTime.SetSpreadInit: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCP0020_TactTime.SetSpreadInit:433:1) |
| WK-SCP0020-0282 | E4 | SCP0020_TactTime.setExceptYnColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0020_TactTime.setExceptYnColor: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0020_TactTime.setExceptYnColor:25) |
| WK-SCP0020-0283 | E4 | static 8 (GMessageBoxForException) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — static 8 (GMessageBoxForException): 행 집계 — E4 28요소: NOT_RUN:28 (미실행 요소가 남아 판정필요) |  | 1 (static 8 (GMessageBoxForException)) |
| WK-SCP0020-0284 | A1 | 2 조회 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 2 조회: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (2 조회) |
| WK-SCP0020-0285 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (COMMON:UC-02) |
| WK-SCP0020-0286 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (COMMON:UC-07) |
| WK-SCP0020-0287 | A1 | PKG_SCP0020.P_SCP0020_GET_TACT_TIME | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0020.P_SCP0020_GET_TACT_TIME: 골든 비교 케이스 없음(PKG_SCP0020.P_SCP0020_GET_TACT_TIME — 팝업·보조 SP 는 golden_cases.csv 에  |  | 47 (SCP0020_GET_TACT_TIME / _SAVE_TACT_TIME ) |
| WK-SCP0020-0288 | A1 | PKG_SCP0020.P_SCP0020_GET_TACT_TIME_EXCE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0020.P_SCP0020_GET_TACT_TIME_EXCEPT_OSP: 골든 비교 케이스 없음(PKG_SCP0020.P_SCP0020_GET_TACT_TIME_EXCEPT_OSP — 팝업·보조 SP |  | 34 (ACT:SCP0020_TactTime.FindData_Except_Pac) |
| WK-SCP0020-0289 | A1 | PKG_SCP0020.P_SCP0020_GET_TACT_TIME_OSP | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0020.P_SCP0020_GET_TACT_TIME_OSP: 골든 비교 케이스 없음(PKG_SCP0020.P_SCP0020_GET_TACT_TIME_OSP — 팝업·보조 SP 는 golden_case |  | 4 (SCP0020_GET_TACT_TIME_OSP / _SAVE_TACT_T) |
| WK-SCP0020-0290 | A1 | SCM0002 Item 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCM0002 Item 팝업: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (SCM0002 Item 팝업) |
| WK-SCP0020-0291 | A1 | SCP0020_GET_TACT_TIME_EXCEPT | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0020_GET_TACT_TIME_EXCEPT: 골든 비교 케이스 없음(SCP0020_GET_TACT_TIME_EXCEPT — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케 |  | 35 (SCP0020_GET_TACT_TIME_EXCEPT(_OSP) / _SA) |
| WK-SCP0020-0292 | A1 | SCP0020_TactTime.FindData_Main_MaxValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0020_TactTime.FindData_Main_MaxValue: 진입점 집계 — A1 4요소: REVIEW:4 |  | 27 (ACT:SCP0020_TactTime.FindData_Main_MaxVa) |
| WK-SCP0020-0293 | A1 | SCP0020_TactTime.FindData_Packer_MaxValu | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0020_TactTime.FindData_Packer_MaxValue: 진입점 집계 — A1 4요소: REVIEW:4 |  | 23 (ACT:SCP0020_TactTime.FindData_Packer_Max) |
| WK-SCP0020-0294 | A1 | btnItemId_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — btnItemId_Click: 행 집계 — A1 4요소: REVIEW:4 |  | 1 (btnItemId_Click) |
| WK-SCP0020-0295 | A6 | SCM0002 Item 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — SCM0002 Item 팝업: 행 집계 — A6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (SCM0002 Item 팝업) |
| WK-SCP0020-0296 | A6 | SCP0020_TactTime.FindData_Main_MaxValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — SCP0020_TactTime.FindData_Main_MaxValue: 진입점 집계 — A6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 27 (ACT:SCP0020_TactTime.FindData_Main_MaxVa) |
| WK-SCP0020-0297 | A6 | SCP0020_TactTime.FindData_Packer_MaxValu | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — SCP0020_TactTime.FindData_Packer_MaxValue: 진입점 집계 — A6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 23 (ACT:SCP0020_TactTime.FindData_Packer_Max) |
| WK-SCP0020-0298 | G1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-02: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0020-0299 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0020-0300 | G1 | SCM0002 Item 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SCM0002 Item 팝업: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (SCM0002 Item 팝업) |
| WK-SCP0020-0301 | G1 | SCP0020_GET_TACT_TIME / _SAVE_TACT_TIME | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SCP0020_GET_TACT_TIME / _SAVE_TACT_TIME: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (SCP0020_GET_TACT_TIME / _SAVE_TACT_TIME) |
| WK-SCP0020-0302 | G1 | SCP0020_GET_TACT_TIME_EXCEPT(_OSP) / _SA | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SCP0020_GET_TACT_TIME_EXCEPT(_OSP) / _SAVE_TACT_TI: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (SCP0020_GET_TACT_TIME_EXCEPT(_OSP) / _SA) |
| WK-SCP0020-0303 | G1 | SCP0020_GET_TACT_TIME_OSP / _SAVE_TACT_T | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SCP0020_GET_TACT_TIME_OSP / _SAVE_TACT_TIME_OSP: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (SCP0020_GET_TACT_TIME_OSP / _SAVE_TACT_T) |
| WK-SCP0020-0304 | G1 | SCP0020_TactTime.FindData_Main_MaxValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SCP0020_TactTime.FindData_Main_MaxValue: 진입점 집계 — G1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 26 (ACT:SCP0020_TactTime.FindData_Main_MaxVa) |
| WK-SCP0020-0305 | G1 | SCP0020_TactTime.FindData_Packer_MaxValu | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SCP0020_TactTime.FindData_Packer_MaxValue: 진입점 집계 — G1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 22 (ACT:SCP0020_TactTime.FindData_Packer_Max) |
| WK-SCP0020-0306 | G1 | btnItemId_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — btnItemId_Click: 행 집계 — G1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (btnItemId_Click) |
| WK-SCP0020-0307 | X-LOC | 1 Layout | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 1 Layout: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (1 Layout) |
| WK-SCP0020-0308 | X-LOC | ClbDivision_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ClbDivision_SelectedIndexChanged: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (ClbDivision_SelectedIndexChanged) |
| WK-SCP0020-0309 | X-LOC | ClbPlantSite_SelectedIndexChanged | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ClbPlantSite_SelectedIndexChanged: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (ClbPlantSite_SelectedIndexChanged) |
| WK-SCP0020-0310 | X-LOC | MSG00002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00002: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00002) |
| WK-SCP0020-0311 | X-LOC | MSG00048 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00048: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00048) |
| WK-SCP0020-0312 | X-LOC | MSG00049 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00049: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00049) |
| WK-SCP0020-0313 | X-LOC | MSG00085 / MSG00072 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00085 / MSG00072: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00085 / MSG00072) |
| WK-SCP0020-0314 | X-LOC | MSG00105 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00105: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00105) |
| WK-SCP0020-0315 | X-LOC | MSG00108 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00108: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00108) |
| WK-SCP0020-0316 | X-LOC | MSG00109/00199/00161/00004/00006/00043 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00109/00199/00161/00004/00006/00043: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00109/00199/00161/00004/00006/00043) |
| WK-SCP0020-0317 | X-LOC | MSG00193 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00193: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00193) |
| WK-SCP0020-0318 | X-LOC | MSG00203 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MSG00203: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MSG00203) |
| WK-SCP0020-0319 | X-LOC | SCM0002 Item 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SCM0002 Item 팝업: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SCM0002 Item 팝업) |
| WK-SCP0020-0320 | X-LOC | SCP0020_GET_TACT_TIME / _SAVE_TACT_TIME | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SCP0020_GET_TACT_TIME / _SAVE_TACT_TIME: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SCP0020_GET_TACT_TIME / _SAVE_TACT_TIME) |
| WK-SCP0020-0321 | X-LOC | SCP0020_GET_TACT_TIME_EXCEPT(_OSP) / _SA | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SCP0020_GET_TACT_TIME_EXCEPT(_OSP) / _SAVE_TACT_TI: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SCP0020_GET_TACT_TIME_EXCEPT(_OSP) / _SA) |
| WK-SCP0020-0322 | X-LOC | SCP0020_GET_TACT_TIME_OSP / _SAVE_TACT_T | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SCP0020_GET_TACT_TIME_OSP / _SAVE_TACT_TIME_OSP: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SCP0020_GET_TACT_TIME_OSP / _SAVE_TACT_T) |
| WK-SCP0020-0323 | X-LOC | SmartColMerge | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SmartColMerge: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SmartColMerge) |
| WK-SCP0020-0324 | X-LOC | SpdMain_EditChange / EditModeOff | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SpdMain_EditChange / EditModeOff: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SpdMain_EditChange / EditModeOff) |
| WK-SCP0020-0325 | X-LOC | btnItemId_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — btnItemId_Click: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (btnItemId_Click) |
| WK-SCP0020-0326 | X-LOC | spdExcept_EditChange / EditModeOff | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — spdExcept_EditChange / EditModeOff: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (spdExcept_EditChange / EditModeOff) |
| WK-SCP0020-0327 | X-LOC | static 8 (GMessageBoxForException) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — static 8 (GMessageBoxForException): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (static 8 (GMessageBoxForException)) |
| WK-SCP0020-0328 | X-ROW | 1 Layout | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 1 Layout: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (1 Layout) |
| WK-SCP0020-0329 | X-ROW | SCP0020_TactTime.CheckDigitValueEntered | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.CheckDigitValueEntered: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 21 (ACT:SCP0020_TactTime.CheckDigitValueEnte) |
| WK-SCP0020-0330 | X-ROW | SCP0020_TactTime.ClbDivision_SelectedInd | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.ClbDivision_SelectedIndexChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0020_TactTime.ClbDivision_Selecte) |
| WK-SCP0020-0331 | X-ROW | SCP0020_TactTime.ClbPlantSite_SelectedIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.ClbPlantSite_SelectedIndexChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0020_TactTime.ClbPlantSite_Select) |
| WK-SCP0020-0332 | X-ROW | SCP0020_TactTime.ClearUsrCheckedList | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.ClearUsrCheckedList: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/LIST_REBIND/STATE_RESET, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0020_TactTime.ClearUsrCheckedList) |
| WK-SCP0020-0333 | X-ROW | SCP0020_TactTime.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0020_TactTime.CreateSpread) |
| WK-SCP0020-0334 | X-ROW | SCP0020_TactTime.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.DefineProperty: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0020_TactTime.DefineProperty:199:) |
| WK-SCP0020-0335 | X-ROW | SCP0020_TactTime.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.FindButton: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:2 |  | 1 (ACT:SCP0020_TactTime.FindButton) |
| WK-SCP0020-0336 | X-ROW | SCP0020_TactTime.FindData_Except | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.FindData_Except: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:1 · NOPATH:1 |  | 7 (ACT:SCP0020_TactTime.FindData_Except ACT) |
| WK-SCP0020-0337 | X-ROW | SCP0020_TactTime.FindData_Except_Packer | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.FindData_Except_Packer: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:1 · PASS:1 |  | 7 (ACT:SCP0020_TactTime.FindData_Except_Pac) |
| WK-SCP0020-0338 | X-ROW | SCP0020_TactTime.FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.FindData_Main: 진입점 집계 12검사 — NOT_RUN:10 · REVIEW:1 · PASS:1 |  | 10 (ACT:SCP0020_TactTime.FindData_Main:1030:) |
| WK-SCP0020-0339 | X-ROW | SCP0020_TactTime.FindData_Main_MaxValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.FindData_Main_MaxValue: 진입점 집계 9검사 — NOT_RUN:4 · REVIEW:3 · NOPATH:2 |  | 4 (ACT:SCP0020_TactTime.FindData_Main_MaxVa) |
| WK-SCP0020-0340 | X-ROW | SCP0020_TactTime.FindData_Packer_MaxValu | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.FindData_Packer_MaxValue: 진입점 집계 8검사 — NOT_RUN:3 · REVIEW:3 · NOPATH:2 |  | 4 (ACT:SCP0020_TactTime.FindData_Packer_Max) |
| WK-SCP0020-0341 | X-ROW | SCP0020_TactTime.Find_Data | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.Find_Data: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 7 (ACT:SCP0020_TactTime.Find_Data ACT:SCP00) |
| WK-SCP0020-0342 | X-ROW | SCP0020_TactTime.Find_Packer | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.Find_Packer: 진입점 집계 5검사 — NOT_RUN:3 · PASS:1 · REVIEW:1 |  | 41 (ACT:SCP0020_TactTime.Find_Packer ACT:SCP) |
| WK-SCP0020-0343 | X-ROW | SCP0020_TactTime.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0020_TactTime.Form_Load) |
| WK-SCP0020-0344 | X-ROW | SCP0020_TactTime.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.InitControls: 진입점 집계 10검사 — NOT_RUN:10 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0020_TactTime.InitControls:215:3 ) |
| WK-SCP0020-0345 | X-ROW | SCP0020_TactTime.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.InitSpread: 진입점 집계 11검사 — NOT_RUN:11 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SCP0020_TactTime.InitSpread ACT:SCP0) |
| WK-SCP0020-0346 | X-ROW | SCP0020_TactTime.RefreshLineByOperation | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.RefreshLineByOperation: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 9 (ACT:SCP0020_TactTime.RefreshLineByOperat) |
| WK-SCP0020-0347 | X-ROW | SCP0020_TactTime.RefreshLineByOperationO | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.RefreshLineByOperationOfSpd: 진입점 동작 재현 시나리오 필요 — 문장 종류 DATA_OP/ENTRY/EXPR/LOCAL, 연결된 요소 검사 없음 |  | 8 (ACT:SCP0020_TactTime.RefreshLineByOperat) |
| WK-SCP0020-0348 | X-ROW | SCP0020_TactTime.RefreshLineByPlantPacke | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.RefreshLineByPlantPacker: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SCP0020_TactTime.RefreshLineByPlantP) |
| WK-SCP0020-0349 | X-ROW | SCP0020_TactTime.RefreshPlantSiteByDivis | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.RefreshPlantSiteByDivision: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0020_TactTime.RefreshPlantSiteByD) |
| WK-SCP0020-0350 | X-ROW | SCP0020_TactTime.SaveData_Except | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.SaveData_Except: 진입점 집계 17검사 — NOT_RUN:13 · NOPATH:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0020_TactTime.SaveData_Except:215) |
| WK-SCP0020-0351 | X-ROW | SCP0020_TactTime.SaveData_Except_Packer | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.SaveData_Except_Packer: 진입점 집계 17검사 — NOT_RUN:13 · NOPATH:2 · PASS:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0020_TactTime.SaveData_Except_Pac) |
| WK-SCP0020-0352 | X-ROW | SCP0020_TactTime.SaveData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.SaveData_Main: 진입점 집계 18검사 — NOT_RUN:14 · NOPATH:2 · PASS:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0020_TactTime.SaveData_Main:1687:) |
| WK-SCP0020-0353 | X-ROW | SCP0020_TactTime.SaveData_Packer | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.SaveData_Packer: 진입점 집계 17검사 — NOT_RUN:13 · NOPATH:2 · PASS:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0020_TactTime.SaveData_Packer:147) |
| WK-SCP0020-0354 | X-ROW | SCP0020_TactTime.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.SetChangedControl: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0020_TactTime.SetChangedControl) |
| WK-SCP0020-0355 | X-ROW | SCP0020_TactTime.SetChangedControl_Osp | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.SetChangedControl_Osp: 진입점 집계 7검사 — NOT_RUN:5 · REVIEW:2 |  | 1 (ACT:SCP0020_TactTime.SetChangedControl_O) |
| WK-SCP0020-0356 | X-ROW | SCP0020_TactTime.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.SetSpreadInit: 진입점 집계 12검사 — NOT_RUN:6 · REVIEW:6 |  | 3 (ACT:SCP0020_TactTime.SetSpreadInit:437:4) |
| WK-SCP0020-0357 | X-ROW | SCP0020_TactTime.SpdExcept_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.SpdExcept_Changed: 진입점 집계 9검사 — NOT_RUN:6 · REVIEW:3 |  | 2 (ACT:SCP0020_TactTime.SpdExcept_Changed:2) |
| WK-SCP0020-0358 | X-ROW | SCP0020_TactTime.SpdExcept_TopChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.SpdExcept_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0020_TactTime.SpdExcept_TopChange) |
| WK-SCP0020-0359 | X-ROW | SCP0020_TactTime.SpdMain_ActiveSheetChan | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.SpdMain_ActiveSheetChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0020_TactTime.SpdMain_ActiveSheet) |
| WK-SCP0020-0360 | X-ROW | SCP0020_TactTime.SpdMain_CellClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.SpdMain_CellClick: 진입점 집계 4검사 — NOPATH:3 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 11 (ACT:SCP0020_TactTime.SpdMain_CellClick A) |
| WK-SCP0020-0361 | X-ROW | SCP0020_TactTime.SpdMain_CellDoubleClick | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.SpdMain_CellDoubleClick: 진입점 집계 3검사 — NOPATH:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0020_TactTime.SpdMain_CellDoubleC) |
| WK-SCP0020-0362 | X-ROW | SCP0020_TactTime.SpdMain_Changed | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.SpdMain_Changed: 진입점 집계 15검사 — NOT_RUN:12 · REVIEW:3 |  | 2 (ACT:SCP0020_TactTime.SpdMain_Changed:263) |
| WK-SCP0020-0363 | X-ROW | SCP0020_TactTime.SpdMain_Changed_Packer | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.SpdMain_Changed_Packer: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 16 (ACT:SCP0020_TactTime.SpdMain_Changed_Pac) |
| WK-SCP0020-0364 | X-ROW | SCP0020_TactTime.SpdMain_ClipboardPasted | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.SpdMain_ClipboardPasted: 진입점 집계 9검사 — NOT_RUN:9 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0020_TactTime.SpdMain_ClipboardPa) |
| WK-SCP0020-0365 | X-ROW | SCP0020_TactTime.SpdMain_EditChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.SpdMain_EditChange: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/FLAG, 연결된 요소 검사 없음 |  | 3 (ACT:SCP0020_TactTime.SpdMain_EditChange ) |
| WK-SCP0020-0366 | X-ROW | SCP0020_TactTime.SpdMain_TopChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.SpdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0020_TactTime.SpdMain_TopChange A) |
| WK-SCP0020-0367 | X-ROW | SCP0020_TactTime.UnLockOnlyOSP | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.UnLockOnlyOSP: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/GRID_SET/LOCAL, 연결된 요소 검사 없음 |  | 8 (ACT:SCP0020_TactTime.UnLockOnlyOSP ACT:S) |
| WK-SCP0020-0368 | X-ROW | SCP0020_TactTime.btnItemId_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.btnItemId_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0020_TactTime.btnItemId_Click:255) |
| WK-SCP0020-0369 | X-ROW | SCP0020_TactTime.checkValidN0 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.checkValidN0: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 24 (ACT:SCP0020_TactTime.checkValidN0 ACT:SC) |
| WK-SCP0020-0370 | X-ROW | SCP0020_TactTime.checkValidN5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.checkValidN5: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 47 (ACT:SCP0020_TactTime.checkValidN5 ACT:SC) |
| WK-SCP0020-0371 | X-ROW | SCP0020_TactTime.checkValidN8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.checkValidN8: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 25 (ACT:SCP0020_TactTime.checkValidN8 ACT:SC) |
| WK-SCP0020-0372 | X-ROW | SCP0020_TactTime.setExceptYnColor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.setExceptYnColor: 진입점 집계 9검사 — NOT_RUN:6 · REVIEW:3 |  | 1 (ACT:SCP0020_TactTime.setExceptYnColor:25) |
| WK-SCP0020-0373 | X-ROW | SCP0020_TactTime.spdExcept_EditChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0020_TactTime.spdExcept_EditChange: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/FLAG, 연결된 요소 검사 없음 |  | 3 (ACT:SCP0020_TactTime.spdExcept_EditChang) |
