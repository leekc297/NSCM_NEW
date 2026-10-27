# 작업 원장 — SCP0132 · 2026-10-26 12:55

> 검사 인스턴스 311건 중 PASS·NA 27건 외 **284건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 25 | 구현 위치 실존 |
| W3 | 동작 수정 | 1 | 재판정 PASS |
| W5 | 검사기 연결 | 7 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 103 | 실행 → PASS |
| W7 | 기대값 확정 | 148 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 148 · E2E 103 · 대조표 25 · 하네스 7 · FE 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 1건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-LOC | GEN |  | 25 |  |  |  |  | 9 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-ROW | GEN |  |  |  |  |  |  | 30 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| H2 | DESIGN |  |  |  |  |  | 8 | 14 |  |  | 배경·글자색 규칙 |
| A5 | DESIGN |  |  |  |  |  | 8 | 13 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H5 | DESIGN |  |  |  |  |  | 8 | 13 |  |  | 라벨 명칭 |
| G1 | GEN |  |  |  |  |  | 8 | 10 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| E4 | EDIT |  |  |  |  |  | 8 | 9 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| C3 | CASCADE |  |  |  |  |  | 6 | 7 |  |  | 연쇄 자동 채움 |
| D1 | EDIT |  |  |  |  |  | 6 | 7 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 6 | 7 |  |  | 행 값 기반 조건부 잠금 |
| A1 | GEN |  |  |  |  |  |  | 11 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| C2 | CASCADE |  |  |  |  |  | 6 | 4 |  |  | 그리드 셀 cascade 후보 |
| D4 | EDIT |  |  |  |  |  | 6 | 3 |  |  | 신규행 기본값·자동세팅·Insert 전제 |
| C1 | CASCADE |  |  |  |  |  | 7 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| C6 | CASCADE |  |  |  |  |  | 1 | 4 |  |  | 무변경 편집 종료 시 연쇄 미발동 |
| G4 | DESIGN |  |  |  |  | 1 | 2 | 1 |  |  | 조회조건 표시·라벨·활성 |
| F4 | DB |  |  |  |  |  | 3 | 1 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| M4 | POPUP |  |  |  |  |  | 3 | 1 |  |  | 팝업 선택값 반영 |
| G5 | POPUP |  |  |  |  | 2 |  | 1 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 1 | 1 | 1 |  |  | 팝업 표준·열림 |
| G6 | GEN |  |  |  |  |  | 2 | 1 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| A6 | GEN |  |  |  |  |  | 1 | 1 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| H10 | DESIGN |  |  | 1 |  |  |  |  |  |  | 메시지 표준(방식·코드 단일화) |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F3 | CRUD |  |  |  |  |  | 1 |  |  |  | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| H4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| E1 | EDIT |  |  |  |  |  | 1 |  |  |  | 숫자 소수자리·정수·부호·범위 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W2 구현 위치 확인 (25)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0132-0001 | X-LOC | COMMON:UC-01 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-01) |
| WK-SCP0132-0002 | X-LOC | COMMON:UC-02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-02) |
| WK-SCP0132-0003 | X-LOC | COMMON:UC-03 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-03) |
| WK-SCP0132-0004 | X-LOC | COMMON:UC-04 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-04) |
| WK-SCP0132-0005 | X-LOC | COMMON:UC-05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-05) |
| WK-SCP0132-0006 | X-LOC | COMMON:UC-06 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-06) |
| WK-SCP0132-0007 | X-LOC | COMMON:UC-07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-07) |
| WK-SCP0132-0008 | X-LOC | Delete(396) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Delete(396)) |
| WK-SCP0132-0009 | X-LOC | Insert(560) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Insert(560)) |
| WK-SCP0132-0010 | X-LOC | LockColumn(406) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (LockColumn(406)) |
| WK-SCP0132-0011 | X-LOC | LockColumn(408) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (LockColumn(408)) |
| WK-SCP0132-0012 | X-LOC | LockColumn(494) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (LockColumn(494)) |
| WK-SCP0132-0013 | X-LOC | LockRange(572) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (LockRange(572)) |
| WK-SCP0132-0014 | X-LOC | LockRange(573) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (LockRange(573)) |
| WK-SCP0132-0015 | X-LOC | Query(493) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Query(493)) |
| WK-SCP0132-0016 | X-LOC | SetSheetHeaderColumnSCP(344) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SetSheetHeaderColumnSCP(344)) |
| WK-SCP0132-0017 | X-LOC | SetText(1024) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SetText(1024)) |
| WK-SCP0132-0018 | X-LOC | SetText(1064) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SetText(1064)) |
| WK-SCP0132-0019 | X-LOC | SetText(1068) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SetText(1068)) |
| WK-SCP0132-0020 | X-LOC | SetText(1089) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SetText(1089)) |
| WK-SCP0132-0021 | X-LOC | SetText(1093) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SetText(1093)) |
| WK-SCP0132-0022 | X-LOC | SetValue(1114) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SetValue(1114)) |
| WK-SCP0132-0023 | X-LOC | SetValue(570) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SetValue(570)) |
| WK-SCP0132-0024 | X-LOC | SmartColMerge(929) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SmartColMerge(929)) |
| WK-SCP0132-0025 | X-LOC | SwitchLock(405) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SwitchLock(405)) |

## W3 동작 수정 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0132-0026 | H10 | SCP0132 화면 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | H10 FAIL 수정 — SCP0132 화면: 표준 메시지 대신 브라우저 alert/confirm 직접 호출: hooks/useConstraintOfShipmentQtyValidation.ts |  | 15 (1 2 3 4 5 7 6 9 COMMON:UC-01 COMMON:UC-0) |

## W5 검사기 연결 (7)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0132-0027 | F2 | SCP0132 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0132 화면 | 판단불가(대상 단위 SCREEN) | 178 (1 2 3 4 5 7 8 6 9 ACT:SCP0132_Constraint) |
| WK-SCP0132-0028 | F6 | SCP0132 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0132 화면 | 판단불가(대상 단위 SCREEN) | 169 (ACT:SCP0132_ConstraintOfShipmentQty.Save) |
| WK-SCP0132-0029 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 없음 | 2 (ACT:SCP0132_ConstraintOfShipmentQty.Init) |
| WK-SCP0132-0030 | G03-WIRE | SCP0132 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0132 화면 | 판단불가(대상 단위 SCREEN) | 12 (ACT:SCP0132_ConstraintOfShipmentQty..cto) |
| WK-SCP0132-0031 | G5 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 17 (SetText(1024) ACT:SCP0132_ConstraintOfSh) |
| WK-SCP0132-0032 | G5 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 2 (ACT:SCP0132_ConstraintOfShipmentQty.SpdM) |
| WK-SCP0132-0033 | H6 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 17 (SetText(1024) ACT:SCP0132_ConstraintOfSh) |

## W6 검증 실행 (103)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0132-0034 | J2 | SCP0132 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0132 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 34 (1 2 3 4 5 7 8 Delete(396) SwitchLock(405) |
| WK-SCP0132-0035 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0132_ConstraintOfShipmentQty.Init) |
| WK-SCP0132-0036 | C1 | cboValid / Valid / Active | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboValid / Valid / Active · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0132_ConstraintOfShipmentQty.Init) |
| WK-SCP0132-0037 | C1 | clbFromSite / From Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbFromSite / From Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0132_ConstraintOfShipmentQty.Refr) |
| WK-SCP0132-0038 | C1 | clbModelGroup / Model Group | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbModelGroup / Model Group · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0132_ConstraintOfShipmentQty.Refr) |
| WK-SCP0132-0039 | C1 | clbPlanGroup / Plan Group | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbPlanGroup / Plan Group · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0132_ConstraintOfShipmentQty.Refr) |
| WK-SCP0132-0040 | C1 | clbStage / Stage | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbStage / Stage · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0132_ConstraintOfShipmentQty.Refr) |
| WK-SCP0132-0041 | C1 | clbToSite / To Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbToSite / To Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0132_ConstraintOfShipmentQty.Refr) |
| WK-SCP0132-0042 | C2 | FROM_STE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — FROM_STE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0132_ConstraintOfShipmentQty.spdM) |
| WK-SCP0132-0043 | C2 | OPMZ_PLAN_GR_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — OPMZ_PLAN_GR_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:SCP0132_ConstraintOfShipmentQty.spdM) |
| WK-SCP0132-0044 | C2 | STAGE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — STAGE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0132_ConstraintOfShipmentQty.spdM) |
| WK-SCP0132-0045 | C2 | TO_STE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — TO_STE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0132_ConstraintOfShipmentQty.spdM) |
| WK-SCP0132-0046 | C2 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0132_ConstraintOfShipmentQty.spdM) |
| WK-SCP0132-0047 | C2 | VAL_TP_CD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — VAL_TP_CD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (SetText(1089)) |
| WK-SCP0132-0048 | C3 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SCP0132_ConstraintOfShipmentQty.Set_) |
| WK-SCP0132-0049 | C3 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCP0132_ConstraintOfShipmentQty.SpdM) |
| WK-SCP0132-0050 | C3 | OPMZ_PLAN_GR_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — OPMZ_PLAN_GR_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 5 (SetValue(1114) ACT:SCP0132_ConstraintOfS) |
| WK-SCP0132-0051 | C3 | SAT_SIPM_MAX_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SAT_SIPM_MAX_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0132_ConstraintOfShipmentQty.SpdM) |
| WK-SCP0132-0052 | C3 | SAT_SIPM_MIN_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SAT_SIPM_MIN_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0132_ConstraintOfShipmentQty.SpdM) |
| WK-SCP0132-0053 | C3 | VAL_TP_CD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — VAL_TP_CD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 5 (SetText(1089) ACT:SCP0132_ConstraintOfSh) |
| WK-SCP0132-0054 | C6 | VAL_TP_CD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — VAL_TP_CD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (SetText(1089)) |
| WK-SCP0132-0055 | G3 | SCP0132 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0132 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 7 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-03 C) |
| WK-SCP0132-0056 | K4 | SCP0132 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0132 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 19 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-03 C) |
| WK-SCP0132-0057 | F1 | SCP0132 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0132 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 184 (1 2 3 4 5 7 8 Delete(396) 6 9 ACT:SCP013) |
| WK-SCP0132-0058 | F3 | SCP0132 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F3 실행 — SCP0132 화면 · 검사기 있음(_trace.spec(@trace) W4b 붙여넣기 — Ctrl+C/Ctrl+V 로 셀 값 복사 후 값·연쇄) — 실행 필요: trace |  | 10 (SetValue(1114) ACT:SCP0132_ConstraintOfS) |
| WK-SCP0132-0059 | F5 | SCP0132 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0132 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 6 (Delete(396) ACT:SCP0132_ConstraintOfShip) |
| WK-SCP0132-0060 | F4 | PKG_SCP0132.P_SCP0132_GET_CONSTRAINT_OF_ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0132.P_SCP0132_GET_CONSTRAINT_OF_SHIPMENT_Q · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 219 (ACT:SCP0132_ConstraintOfShipmentQty.Find) |
| WK-SCP0132-0061 | F4 | PKG_SCP0132.P_SCP0132_GET_SEARCH_INFO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0132.P_SCP0132_GET_SEARCH_INFO · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: sm |  | 2 (ACT:SCP0132_ConstraintOfShipmentQty.GetS) |
| WK-SCP0132-0062 | F4 | PKG_SCP0132.P_SCP0132_SAVE_CONSTRAINT_OF | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0132.P_SCP0132_SAVE_CONSTRAINT_OF_SHIPMENT_ · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 169 (ACT:SCP0132_ConstraintOfShipmentQty.Save) |
| WK-SCP0132-0063 | A5 | DIVISION_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (LockColumn(406) SetValue(570) LockRange() |
| WK-SCP0132-0064 | A5 | ITEM_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (SetText(1024) ACT:SCP0132_ConstraintOfSh) |
| WK-SCP0132-0065 | A5 | LAST_UPDATE_DATE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (LockRange(573)) |
| WK-SCP0132-0066 | A5 | OPMZ_PLAN_GR_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — OPMZ_PLAN_GR_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (SetValue(1114)) |
| WK-SCP0132-0067 | A5 | PRE_KEY_VALUES | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PRE_KEY_VALUES · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (LockColumn(408) LockRange(573)) |
| WK-SCP0132-0068 | A5 | SIPM_MAX_QTY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SIPM_MAX_QTY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (SetText(1064)) |
| WK-SCP0132-0069 | A5 | SIPM_MIN_QYT | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SIPM_MIN_QYT · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (SetText(1064)) |
| WK-SCP0132-0070 | A5 | VAL_TP_CD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — VAL_TP_CD · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 6 (LockColumn(408) LockRange(573) SetText(1) |
| WK-SCP0132-0071 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0132_ConstraintOfShipmentQty.Init) |
| WK-SCP0132-0072 | G4 | cboValid / Valid / Active | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboValid / Valid / Active · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0132_ConstraintOfShipmentQty.Init) |
| WK-SCP0132-0073 | H2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (LockColumn(406) SetValue(570) LockRange() |
| WK-SCP0132-0074 | H2 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (SetText(1024)) |
| WK-SCP0132-0075 | H2 | LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (LockRange(573)) |
| WK-SCP0132-0076 | H2 | OPMZ_PLAN_GR_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — OPMZ_PLAN_GR_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (SetValue(1114)) |
| WK-SCP0132-0077 | H2 | PRE_KEY_VALUES | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — PRE_KEY_VALUES · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (LockColumn(408) LockRange(573)) |
| WK-SCP0132-0078 | H2 | SIPM_MAX_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SIPM_MAX_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (SetText(1064)) |
| WK-SCP0132-0079 | H2 | SIPM_MIN_QYT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SIPM_MIN_QYT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (SetText(1064)) |
| WK-SCP0132-0080 | H2 | VAL_TP_CD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — VAL_TP_CD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 6 (LockColumn(408) LockRange(573) SetText(1) |
| WK-SCP0132-0081 | H4 | SCP0132 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — SCP0132 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 5 (SmartColMerge(929) ACT:SCP0132_Constrain) |
| WK-SCP0132-0082 | H5 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — DIVISION_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (LockColumn(406) SetValue(570) LockRange() |
| WK-SCP0132-0083 | H5 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ITEM_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (SetText(1024)) |
| WK-SCP0132-0084 | H5 | LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (LockRange(573)) |
| WK-SCP0132-0085 | H5 | OPMZ_PLAN_GR_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — OPMZ_PLAN_GR_ID · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (SetValue(1114)) |
| WK-SCP0132-0086 | H5 | PRE_KEY_VALUES | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PRE_KEY_VALUES · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (LockColumn(408) LockRange(573)) |
| WK-SCP0132-0087 | H5 | SIPM_MAX_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SIPM_MAX_QTY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (SetText(1064)) |
| WK-SCP0132-0088 | H5 | SIPM_MIN_QYT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SIPM_MIN_QYT · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 1 (SetText(1064)) |
| WK-SCP0132-0089 | H5 | VAL_TP_CD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — VAL_TP_CD · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 6 (LockColumn(408) LockRange(573) SetText(1) |
| WK-SCP0132-0090 | I1 | SCP0132 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0132 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 17 (1 2 3 4 5 7 6 9 ACT:SCP0132_ConstraintOf) |
| WK-SCP0132-0091 | SC1 | SCP0132 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SCP0132 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 1 (COMMON:UC-06) |
| WK-SCP0132-0092 | D1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 6 (LockColumn(406) LockRange(572) ACT:SCP01) |
| WK-SCP0132-0093 | D1 | LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (LockRange(573) ACT:SCP0132_ConstraintOfS) |
| WK-SCP0132-0094 | D1 | PRE_KEY_VALUES | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PRE_KEY_VALUES · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (LockColumn(408) LockRange(573) ACT:SCP01) |
| WK-SCP0132-0095 | D1 | SIPM_MAX_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — SIPM_MAX_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (SetText(1064)) |
| WK-SCP0132-0096 | D1 | SIPM_MIN_QYT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — SIPM_MIN_QYT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (SetText(1064)) |
| WK-SCP0132-0097 | D1 | VAL_TP_CD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — VAL_TP_CD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 7 (LockColumn(408) LockRange(573) SetText(1) |
| WK-SCP0132-0098 | D3 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 6 (LockColumn(406) LockRange(572) ACT:SCP01) |
| WK-SCP0132-0099 | D3 | LAST_UPDATE_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LAST_UPDATE_DATE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (LockRange(573) ACT:SCP0132_ConstraintOfS) |
| WK-SCP0132-0100 | D3 | PRE_KEY_VALUES | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PRE_KEY_VALUES · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (LockColumn(408) LockRange(573) ACT:SCP01) |
| WK-SCP0132-0101 | D3 | SIPM_MAX_QTY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — SIPM_MAX_QTY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (SetText(1064)) |
| WK-SCP0132-0102 | D3 | SIPM_MIN_QYT | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — SIPM_MIN_QYT · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (SetText(1064)) |
| WK-SCP0132-0103 | D3 | VAL_TP_CD | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — VAL_TP_CD · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 7 (LockColumn(408) LockRange(573) SetText(1) |
| WK-SCP0132-0104 | D4 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (SetValue(570)) |
| WK-SCP0132-0105 | D4 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (SetText(1024)) |
| WK-SCP0132-0106 | D4 | OPMZ_PLAN_GR_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — OPMZ_PLAN_GR_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (SetValue(1114)) |
| WK-SCP0132-0107 | D4 | SIPM_MAX_QTY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — SIPM_MAX_QTY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (SetText(1064)) |
| WK-SCP0132-0108 | D4 | SIPM_MIN_QYT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — SIPM_MIN_QYT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (SetText(1064)) |
| WK-SCP0132-0109 | D4 | VAL_TP_CD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — VAL_TP_CD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 4 (SetText(1064) SetText(1068) SetText(1089) |
| WK-SCP0132-0110 | D6 | SCP0132 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0132 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 4 (Insert(560) COMMON:UC-01 ACT:SCP0132_Con) |
| WK-SCP0132-0111 | E1 | OPMZ_PLAN_GR_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — OPMZ_PLAN_GR_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 5 (SetValue(1114) ACT:SCP0132_ConstraintOfS) |
| WK-SCP0132-0112 | E4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SCP0132_ConstraintOfShipmentQty.Set_) |
| WK-SCP0132-0113 | E4 | MSG00001 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00001 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (2 ACT:SCP0132_ConstraintOfShipmentQty.Sa) |
| WK-SCP0132-0114 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (7 ACT:SCP0132_ConstraintOfShipmentQty.Sa) |
| WK-SCP0132-0115 | E4 | MSG00022 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00022 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (5 ACT:SCP0132_ConstraintOfShipmentQty.Sa) |
| WK-SCP0132-0116 | E4 | MSG00046 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00046 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (3 ACT:SCP0132_ConstraintOfShipmentQty.Sa) |
| WK-SCP0132-0117 | E4 | MSG00099 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00099 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (1 ACT:SCP0132_ConstraintOfShipmentQty.ch) |
| WK-SCP0132-0118 | E4 | MSG00219 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00219 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (4 ACT:SCP0132_ConstraintOfShipmentQty.Sa) |
| WK-SCP0132-0119 | E4 | MSG00458 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00458 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (6 ACT:SCP0132_ConstraintOfShipmentQty.Sa) |
| WK-SCP0132-0120 | A10 | SCP0132 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0132 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 39 (ACT:SCP0132_ConstraintOfShipmentQty.Form) |
| WK-SCP0132-0121 | A6 | PKG_SCP0132.P_SCP0132_GET_CONSTRAINT_OF_ | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0132.P_SCP0132_GET_CONSTRAINT_OF_SHIPMENT_Q · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOUR |  | 51 (ACT:SCP0132_ConstraintOfShipmentQty.Find) |
| WK-SCP0132-0122 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0132_ConstraintOfShipmentQty.Find) |
| WK-SCP0132-0123 | G1 | cboValid / Valid / Active | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboValid / Valid / Active · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0132_ConstraintOfShipmentQty.Find) |
| WK-SCP0132-0124 | G1 | clbFromSite / From Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbFromSite / From Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0132_ConstraintOfShipmentQty.Find) |
| WK-SCP0132-0125 | G1 | clbModelGroup / Model Group | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbModelGroup / Model Group · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0132_ConstraintOfShipmentQty.Find) |
| WK-SCP0132-0126 | G1 | clbPlanGroup / Plan Group | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbPlanGroup / Plan Group · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0132_ConstraintOfShipmentQty.Find) |
| WK-SCP0132-0127 | G1 | clbStage / Stage | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbStage / Stage · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0132_ConstraintOfShipmentQty.Find) |
| WK-SCP0132-0128 | G1 | clbToSite / To Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbToSite / To Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0132_ConstraintOfShipmentQty.Find) |
| WK-SCP0132-0129 | G1 | txtItemId / Model / Item Id / Model/Nick | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0132_ConstraintOfShipmentQty.Find) |
| WK-SCP0132-0130 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCP0132_ConstraintOfShipmentQty.Init) |
| WK-SCP0132-0131 | G6 | cboValid / Valid / Active | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboValid / Valid / Active · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0132_ConstraintOfShipmentQty.Init) |
| WK-SCP0132-0132 | X-REOPEN | SCP0132 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0132 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 7 (ACT:SCP0132_ConstraintOfShipmentQty.Disp) |
| WK-SCP0132-0133 | H6 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboDivision / Division · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 2 (ACT:SCP0132_ConstraintOfShipmentQty.SpdM) |
| WK-SCP0132-0134 | M4 | FROM_STE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — FROM_STE_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SCP0132_ConstraintOfShipmentQty.SpdM) |
| WK-SCP0132-0135 | M4 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 17 (SetText(1024) ACT:SCP0132_ConstraintOfSh) |
| WK-SCP0132-0136 | M4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SCP0132_ConstraintOfShipmentQty.SpdM) |

## W7 기대값 확정 (148)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0132-0137 | C2 | SCP0132_ConstraintOfShipmentQty.CboDivis | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0132_ConstraintOfShipmentQty.CboDivision_Select: 진입점 집계 — C2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0132_ConstraintOfShipmentQty.CboD) |
| WK-SCP0132-0138 | C2 | SCP0132_ConstraintOfShipmentQty.CboPlanG | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0132_ConstraintOfShipmentQty.CboPlanGroup_Selec: 진입점 집계 — C2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0132_ConstraintOfShipmentQty.CboP) |
| WK-SCP0132-0139 | C2 | SCP0132_ConstraintOfShipmentQty.CboPlanS | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0132_ConstraintOfShipmentQty.CboPlanSeq_Selecte: 진입점 집계 — C2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0132_ConstraintOfShipmentQty.CboP) |
| WK-SCP0132-0140 | C2 | SCP0132_ConstraintOfShipmentQty.ClbDivis | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0132_ConstraintOfShipmentQty.ClbDivision_Select: 진입점 집계 — C2 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0132_ConstraintOfShipmentQty.ClbD) |
| WK-SCP0132-0141 | C3 | SCP0132_ConstraintOfShipmentQty.CboDivis | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0132_ConstraintOfShipmentQty.CboDivision_Select: 진입점 집계 — C3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0132_ConstraintOfShipmentQty.CboD) |
| WK-SCP0132-0142 | C3 | SCP0132_ConstraintOfShipmentQty.CboPlanG | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0132_ConstraintOfShipmentQty.CboPlanGroup_Selec: 진입점 집계 — C3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0132_ConstraintOfShipmentQty.CboP) |
| WK-SCP0132-0143 | C3 | SCP0132_ConstraintOfShipmentQty.CboPlanS | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0132_ConstraintOfShipmentQty.CboPlanSeq_Selecte: 진입점 집계 — C3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0132_ConstraintOfShipmentQty.CboP) |
| WK-SCP0132-0144 | C3 | SCP0132_ConstraintOfShipmentQty.ClbDivis | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0132_ConstraintOfShipmentQty.ClbDivision_Select: 진입점 집계 — C3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0132_ConstraintOfShipmentQty.ClbD) |
| WK-SCP0132-0145 | C3 | SCP0132_ConstraintOfShipmentQty.SetChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0132_ConstraintOfShipmentQty.SetChangedControl: 진입점 집계 — C3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0132_ConstraintOfShipmentQty.SetC) |
| WK-SCP0132-0146 | C3 | SCP0132_ConstraintOfShipmentQty.Set_Meas | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0132_ConstraintOfShipmentQty.Set_MeasureColor: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0132_ConstraintOfShipmentQty.Set_) |
| WK-SCP0132-0147 | C3 | SCP0132_ConstraintOfShipmentQty.setPerio | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0132_ConstraintOfShipmentQty.setPeriod: 진입점 집계 — C3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0132_ConstraintOfShipmentQty.setP) |
| WK-SCP0132-0148 | C6 | SCP0132_ConstraintOfShipmentQty.CboDivis | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0132_ConstraintOfShipmentQty.CboDivision_Select: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0132_ConstraintOfShipmentQty.CboD) |
| WK-SCP0132-0149 | C6 | SCP0132_ConstraintOfShipmentQty.CboPlanG | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0132_ConstraintOfShipmentQty.CboPlanGroup_Selec: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0132_ConstraintOfShipmentQty.CboP) |
| WK-SCP0132-0150 | C6 | SCP0132_ConstraintOfShipmentQty.CboPlanS | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0132_ConstraintOfShipmentQty.CboPlanSeq_Selecte: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0132_ConstraintOfShipmentQty.CboP) |
| WK-SCP0132-0151 | C6 | SCP0132_ConstraintOfShipmentQty.ClbDivis | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0132_ConstraintOfShipmentQty.ClbDivision_Select: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0132_ConstraintOfShipmentQty.ClbD) |
| WK-SCP0132-0152 | F4 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 7: 행 집계 — F4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0132-0153 | A5 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 8: 행 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0132-0154 | A5 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-01: 행 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SCP0132-0155 | A5 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-02: 행 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0132-0156 | A5 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-05: 행 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0132-0157 | A5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-07: 행 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0132-0158 | A5 | Delete(396) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — Delete(396): 행 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (Delete(396)) |
| WK-SCP0132-0159 | A5 | Insert(560) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — Insert(560): 행 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (Insert(560)) |
| WK-SCP0132-0160 | A5 | LockColumn(494) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — LockColumn(494): 행 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (LockColumn(494)) |
| WK-SCP0132-0161 | A5 | Query(493) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — Query(493): 행 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (Query(493)) |
| WK-SCP0132-0162 | A5 | SCP0132_ConstraintOfShipmentQty.CreateSp | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0132_ConstraintOfShipmentQty.CreateSpread: 진입점 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0132_ConstraintOfShipmentQty.Crea) |
| WK-SCP0132-0163 | A5 | SetSheetHeaderColumnSCP(344) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SetSheetHeaderColumnSCP(344): 행 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (SetSheetHeaderColumnSCP(344)) |
| WK-SCP0132-0164 | A5 | SmartColMerge(929) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SmartColMerge(929): 행 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (SmartColMerge(929)) |
| WK-SCP0132-0165 | A5 | SwitchLock(405) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SwitchLock(405): 행 집계 — A5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (SwitchLock(405)) |
| WK-SCP0132-0166 | G4 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — COMMON:UC-06: 행 집계 — G4 3요소: NOT_RUN:2 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0132-0167 | H2 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 8: 행 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0132-0168 | H2 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-01: 행 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SCP0132-0169 | H2 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-02: 행 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0132-0170 | H2 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-05: 행 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0132-0171 | H2 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-07: 행 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0132-0172 | H2 | Delete(396) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — Delete(396): 행 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (Delete(396)) |
| WK-SCP0132-0173 | H2 | Insert(560) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — Insert(560): 행 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (Insert(560)) |
| WK-SCP0132-0174 | H2 | LockColumn(494) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — LockColumn(494): 행 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (LockColumn(494)) |
| WK-SCP0132-0175 | H2 | Query(493) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — Query(493): 행 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (Query(493)) |
| WK-SCP0132-0176 | H2 | SCP0132_ConstraintOfShipmentQty.CreateSp | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0132_ConstraintOfShipmentQty.CreateSpread: 진입점 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0132_ConstraintOfShipmentQty.Crea) |
| WK-SCP0132-0177 | H2 | SCP0132_ConstraintOfShipmentQty.Set_Meas | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0132_ConstraintOfShipmentQty.Set_MeasureColor: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0132_ConstraintOfShipmentQty.Set_) |
| WK-SCP0132-0178 | H2 | SetSheetHeaderColumnSCP(344) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SetSheetHeaderColumnSCP(344): 행 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (SetSheetHeaderColumnSCP(344)) |
| WK-SCP0132-0179 | H2 | SmartColMerge(929) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SmartColMerge(929): 행 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (SmartColMerge(929)) |
| WK-SCP0132-0180 | H2 | SwitchLock(405) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SwitchLock(405): 행 집계 — H2 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (SwitchLock(405)) |
| WK-SCP0132-0181 | H5 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 8: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0132-0182 | H5 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-01: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SCP0132-0183 | H5 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-02: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0132-0184 | H5 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-05: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0132-0185 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0132-0186 | H5 | Delete(396) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — Delete(396): 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (Delete(396)) |
| WK-SCP0132-0187 | H5 | Insert(560) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — Insert(560): 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (Insert(560)) |
| WK-SCP0132-0188 | H5 | LockColumn(494) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — LockColumn(494): 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (LockColumn(494)) |
| WK-SCP0132-0189 | H5 | Query(493) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — Query(493): 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (Query(493)) |
| WK-SCP0132-0190 | H5 | SCP0132_ConstraintOfShipmentQty.CreateSp | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0132_ConstraintOfShipmentQty.CreateSpread: 진입점 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0132_ConstraintOfShipmentQty.Crea) |
| WK-SCP0132-0191 | H5 | SetSheetHeaderColumnSCP(344) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SetSheetHeaderColumnSCP(344): 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (SetSheetHeaderColumnSCP(344)) |
| WK-SCP0132-0192 | H5 | SmartColMerge(929) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SmartColMerge(929): 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (SmartColMerge(929)) |
| WK-SCP0132-0193 | H5 | SwitchLock(405) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SwitchLock(405): 행 집계 — H5 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (SwitchLock(405)) |
| WK-SCP0132-0194 | D1 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 3: 행 집계 — D1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0132-0195 | D1 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 5: 행 집계 — D1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0132-0196 | D1 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 7: 행 집계 — D1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0132-0197 | D1 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 8: 행 집계 — D1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0132-0198 | D1 | LockColumn(494) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — LockColumn(494): 행 집계 — D1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (LockColumn(494)) |
| WK-SCP0132-0199 | D1 | SCP0132_ConstraintOfShipmentQty.EditButt | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SCP0132_ConstraintOfShipmentQty.EditButton: 진입점 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0132_ConstraintOfShipmentQty.Edit) |
| WK-SCP0132-0200 | D1 | SwitchLock(405) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SwitchLock(405): 행 집계 — D1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (SwitchLock(405)) |
| WK-SCP0132-0201 | D3 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 3: 행 집계 — D3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0132-0202 | D3 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 5: 행 집계 — D3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0132-0203 | D3 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 7: 행 집계 — D3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0132-0204 | D3 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 8: 행 집계 — D3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0132-0205 | D3 | LockColumn(494) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — LockColumn(494): 행 집계 — D3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (LockColumn(494)) |
| WK-SCP0132-0206 | D3 | SCP0132_ConstraintOfShipmentQty.EditButt | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SCP0132_ConstraintOfShipmentQty.EditButton: 진입점 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0132_ConstraintOfShipmentQty.Edit) |
| WK-SCP0132-0207 | D3 | SwitchLock(405) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SwitchLock(405): 행 집계 — D3 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (SwitchLock(405)) |
| WK-SCP0132-0208 | D4 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — 5: 행 집계 — D4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0132-0209 | D4 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — COMMON:UC-01: 행 집계 — D4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SCP0132-0210 | D4 | Insert(560) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — Insert(560): 행 집계 — D4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (Insert(560)) |
| WK-SCP0132-0211 | E4 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 2: 행 집계 — E4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0132-0212 | E4 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 3: 행 집계 — E4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0132-0213 | E4 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 8: 행 집계 — E4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (8) |
| WK-SCP0132-0214 | E4 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 9: 행 집계 — E4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (9) |
| WK-SCP0132-0215 | E4 | COMMON:UC-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — COMMON:UC-04: 행 집계 — E4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-04) |
| WK-SCP0132-0216 | E4 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — COMMON:UC-06: 행 집계 — E4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0132-0217 | E4 | SCP0132_ConstraintOfShipmentQty.SetChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0132_ConstraintOfShipmentQty.SetChangedControl: 진입점 집계 — E4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0132_ConstraintOfShipmentQty.SetC) |
| WK-SCP0132-0218 | E4 | SCP0132_ConstraintOfShipmentQty.Set_Meas | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0132_ConstraintOfShipmentQty.Set_MeasureColor: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0132_ConstraintOfShipmentQty.Set_) |
| WK-SCP0132-0219 | E4 | SCP0132_ConstraintOfShipmentQty.setPerio | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0132_ConstraintOfShipmentQty.setPeriod: 진입점 집계 — E4 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0132_ConstraintOfShipmentQty.setP) |
| WK-SCP0132-0220 | A1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1: 행 집계 — A1 2요소: REVIEW:2 |  | 0 () |
| WK-SCP0132-0221 | A1 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 5: 행 집계 — A1 2요소: REVIEW:2 |  | 0 () |
| WK-SCP0132-0222 | A1 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 7: 행 집계 — A1 2요소: REVIEW:2 |  | 0 () |
| WK-SCP0132-0223 | A1 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 8: 행 집계 — A1 2요소: REVIEW:2 |  | 0 () |
| WK-SCP0132-0224 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (COMMON:UC-02) |
| WK-SCP0132-0225 | A1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-03: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (COMMON:UC-03) |
| WK-SCP0132-0226 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (COMMON:UC-06) |
| WK-SCP0132-0227 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (COMMON:UC-07) |
| WK-SCP0132-0228 | A1 | LockColumn(494) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — LockColumn(494): 행 집계 — A1 2요소: REVIEW:2 |  | 1 (LockColumn(494)) |
| WK-SCP0132-0229 | A1 | PKG_SCP0132 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0132: 골든 비교 케이스 없음(PKG_SCP0132 — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 0 () |
| WK-SCP0132-0230 | A1 | PKG_SCP0132.P_SCP0132_GET_CONSTRAINT_OF_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0132.P_SCP0132_GET_CONSTRAINT_OF_SHIPMENT_Q: 골든 비교 케이스 없음(PKG_SCP0132.P_SCP0132_GET_CONSTRAINT_OF_SHIPMENT_QTY  |  | 51 (ACT:SCP0132_ConstraintOfShipmentQty.Find) |
| WK-SCP0132-0231 | A6 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 7: 행 집계 — A6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0132-0232 | G1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 1: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0132-0233 | G1 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 2: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0132-0234 | G1 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 5: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0132-0235 | G1 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 7: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0132-0236 | G1 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 8: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0132-0237 | G1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-02: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0132-0238 | G1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-03: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-SCP0132-0239 | G1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-06: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0132-0240 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0132-0241 | G1 | LockColumn(494) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — LockColumn(494): 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (LockColumn(494)) |
| WK-SCP0132-0242 | G6 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — COMMON:UC-06: 행 집계 — G6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0132-0243 | X-LOC | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (1) |
| WK-SCP0132-0244 | X-LOC | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (2) |
| WK-SCP0132-0245 | X-LOC | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (3) |
| WK-SCP0132-0246 | X-LOC | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (4) |
| WK-SCP0132-0247 | X-LOC | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (5) |
| WK-SCP0132-0248 | X-LOC | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 6: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (6) |
| WK-SCP0132-0249 | X-LOC | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 7: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (7) |
| WK-SCP0132-0250 | X-LOC | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 8: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (8) |
| WK-SCP0132-0251 | X-LOC | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 9: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (9) |
| WK-SCP0132-0252 | X-ROW | SCP0132_ConstraintOfShipmentQty.CboDivis | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0132_ConstraintOfShipmentQty.CboDivision_Select: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0132_ConstraintOfShipmentQty.CboD) |
| WK-SCP0132-0253 | X-ROW | SCP0132_ConstraintOfShipmentQty.CboPlanG | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0132_ConstraintOfShipmentQty.CboPlanGroup_Selec: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0132_ConstraintOfShipmentQty.CboP) |
| WK-SCP0132-0254 | X-ROW | SCP0132_ConstraintOfShipmentQty.CboPlanS | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0132_ConstraintOfShipmentQty.CboPlanSeq_Selecte: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0132_ConstraintOfShipmentQty.CboP) |
| WK-SCP0132-0255 | X-ROW | SCP0132_ConstraintOfShipmentQty.ClbDivis | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0132_ConstraintOfShipmentQty.ClbDivision_Select: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0132_ConstraintOfShipmentQty.ClbD) |
| WK-SCP0132-0256 | X-ROW | SCP0132_ConstraintOfShipmentQty.CreateSp | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0132_ConstraintOfShipmentQty.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0132_ConstraintOfShipmentQty.Crea) |
| WK-SCP0132-0257 | X-ROW | SCP0132_ConstraintOfShipmentQty.FindButt | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0132_ConstraintOfShipmentQty.FindButton: 진입점 집계 3검사 — NOT_RUN:2 · REVIEW:1 |  | 1 (ACT:SCP0132_ConstraintOfShipmentQty.Find) |
| WK-SCP0132-0258 | X-ROW | SCP0132_ConstraintOfShipmentQty.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0132_ConstraintOfShipmentQty.FindData_Main: 진입점 집계 13검사 — NOT_RUN:11 · REVIEW:1 · PASS:1 |  | 7 (ACT:SCP0132_ConstraintOfShipmentQty.Find) |
| WK-SCP0132-0259 | X-ROW | SCP0132_ConstraintOfShipmentQty.Form_Loa | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0132_ConstraintOfShipmentQty.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0132_ConstraintOfShipmentQty.Form) |
| WK-SCP0132-0260 | X-ROW | SCP0132_ConstraintOfShipmentQty.GetDivis | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0132_ConstraintOfShipmentQty.GetDivisionChecked: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0132_ConstraintOfShipmentQty.GetD) |
| WK-SCP0132-0261 | X-ROW | SCP0132_ConstraintOfShipmentQty.GetSearc | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0132_ConstraintOfShipmentQty.GetSearchInfo: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:1 · TODO:1 · PASS:1 (미실행 검사가 남아 판정필요 |  | 2 (ACT:SCP0132_ConstraintOfShipmentQty.GetS) |
| WK-SCP0132-0262 | X-ROW | SCP0132_ConstraintOfShipmentQty.InitCont | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0132_ConstraintOfShipmentQty.InitControls: 진입점 집계 7검사 — NOT_RUN:7 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0132_ConstraintOfShipmentQty.Init) |
| WK-SCP0132-0263 | X-ROW | SCP0132_ConstraintOfShipmentQty.InitSpre | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0132_ConstraintOfShipmentQty.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SCP0132_ConstraintOfShipmentQty.Init) |
| WK-SCP0132-0264 | X-ROW | SCP0132_ConstraintOfShipmentQty.InsertBu | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0132_ConstraintOfShipmentQty.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0132_ConstraintOfShipmentQty.Inse) |
| WK-SCP0132-0265 | X-ROW | SCP0132_ConstraintOfShipmentQty.Insert_R | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0132_ConstraintOfShipmentQty.Insert_Row: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 11 (ACT:SCP0132_ConstraintOfShipmentQty.Inse) |
| WK-SCP0132-0266 | X-ROW | SCP0132_ConstraintOfShipmentQty.RefreshI | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0132_ConstraintOfShipmentQty.RefreshItemByDivis: 진입점 동작 재현 시나리오 필요 — 문장 종류 DATA_OP/ENTRY/EXPR, 연결된 요소 검사 없음 |  | 3 (ACT:SCP0132_ConstraintOfShipmentQty.Refr) |
| WK-SCP0132-0267 | X-ROW | SCP0132_ConstraintOfShipmentQty.RefreshP | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0132_ConstraintOfShipmentQty.RefreshPlanGroupBy: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0132_ConstraintOfShipmentQty.Refr) |
| WK-SCP0132-0268 | X-ROW | SCP0132_ConstraintOfShipmentQty.RefreshS | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0132_ConstraintOfShipmentQty.RefreshSiteByDivis: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SCP0132_ConstraintOfShipmentQty.Refr) |
| WK-SCP0132-0269 | X-ROW | SCP0132_ConstraintOfShipmentQty.RefreshS | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0132_ConstraintOfShipmentQty.RefreshStageByDivi: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0132_ConstraintOfShipmentQty.Refr) |
| WK-SCP0132-0270 | X-ROW | SCP0132_ConstraintOfShipmentQty.RefreshS | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0132_ConstraintOfShipmentQty.RefreshStageByMode: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0132_ConstraintOfShipmentQty.Refr) |
| WK-SCP0132-0271 | X-ROW | SCP0132_ConstraintOfShipmentQty.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0132_ConstraintOfShipmentQty.SaveData: 진입점 집계 15검사 — NOT_RUN:11 · NOPATH:2 · PASS:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0132_ConstraintOfShipmentQty.Save) |
| WK-SCP0132-0272 | X-ROW | SCP0132_ConstraintOfShipmentQty.SetChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0132_ConstraintOfShipmentQty.SetChangedControl: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0132_ConstraintOfShipmentQty.SetC) |
| WK-SCP0132-0273 | X-ROW | SCP0132_ConstraintOfShipmentQty.SpdMain_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0132_ConstraintOfShipmentQty.SpdMain_CellDouble: 진입점 집계 12검사 — NOT_RUN:6 · NOPATH:3 · REVIEW:3 |  | 2 (ACT:SCP0132_ConstraintOfShipmentQty.SpdM) |
| WK-SCP0132-0274 | X-ROW | SCP0132_ConstraintOfShipmentQty.SpdMain_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0132_ConstraintOfShipmentQty.SpdMain_ClipboardP: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0132_ConstraintOfShipmentQty.SpdM) |
| WK-SCP0132-0275 | X-ROW | SCP0132_ConstraintOfShipmentQty.SpdMain_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0132_ConstraintOfShipmentQty.SpdMain_EditChange: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0132_ConstraintOfShipmentQty.SpdM) |
| WK-SCP0132-0276 | X-ROW | SCP0132_ConstraintOfShipmentQty.SpdMain_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0132_ConstraintOfShipmentQty.SpdMain_KeyDown: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SCP0132_ConstraintOfShipmentQty.SpdM) |
| WK-SCP0132-0277 | X-ROW | SCP0132_ConstraintOfShipmentQty.SpdMain_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0132_ConstraintOfShipmentQty.SpdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0132_ConstraintOfShipmentQty.SpdM) |
| WK-SCP0132-0278 | X-ROW | SCP0132_ConstraintOfShipmentQty.btnItemI | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0132_ConstraintOfShipmentQty.btnItemId_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0132_ConstraintOfShipmentQty.btnI) |
| WK-SCP0132-0279 | X-ROW | SCP0132_ConstraintOfShipmentQty.checkMin | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0132_ConstraintOfShipmentQty.checkMinMax: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SCP0132_ConstraintOfShipmentQty.chec) |
| WK-SCP0132-0280 | X-ROW | SCP0132_ConstraintOfShipmentQty.setPerio | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0132_ConstraintOfShipmentQty.setPeriod: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0132_ConstraintOfShipmentQty.setP) |
| WK-SCP0132-0281 | X-ROW | SCP0132_ConstraintOfShipmentQty.spdMain_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0132_ConstraintOfShipmentQty.spdMain_CellClick: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 21 (ACT:SCP0132_ConstraintOfShipmentQty.spdM) |
| WK-SCP0132-0282 | G5 | SCP0132_ConstraintOfShipmentQty.SpdMain_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCP0132_ConstraintOfShipmentQty.SpdMain_CellDouble: 진입점 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0132_ConstraintOfShipmentQty.SpdM) |
| WK-SCP0132-0283 | H6 | SCP0132_ConstraintOfShipmentQty.SpdMain_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCP0132_ConstraintOfShipmentQty.SpdMain_CellDouble: 진입점 집계 — H6 2요소: NOPATH:1 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0132_ConstraintOfShipmentQty.SpdM) |
| WK-SCP0132-0284 | M4 | SCP0132_ConstraintOfShipmentQty.SpdMain_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0132_ConstraintOfShipmentQty.SpdMain_CellDouble: 진입점 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0132_ConstraintOfShipmentQty.SpdM) |
