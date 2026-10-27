# 작업 원장 — SCP0131 · 2026-10-26 12:55

> 검사 인스턴스 328건 중 PASS·NA 40건 외 **288건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 21 | 구현 위치 실존 |
| W3 | 동작 수정 | 1 | 재판정 PASS |
| W5 | 검사기 연결 | 10 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 90 | 실행 → PASS |
| W7 | 기대값 확정 | 166 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 166 · E2E 90 · 대조표 21 · 하네스 10 · FE 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 2건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-LOC | GEN |  | 21 |  |  |  |  | 11 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-ROW | GEN |  |  |  |  |  |  | 27 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| E4 | EDIT |  |  |  |  |  | 17 | 8 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| A1 | GEN |  |  |  |  |  |  | 18 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| F4 | DB |  |  |  |  |  | 4 | 10 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| H2 | DESIGN |  |  |  |  |  | 2 | 12 |  |  | 배경·글자색 규칙 |
| D1 | EDIT |  |  |  |  |  | 8 | 6 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 8 | 6 |  |  | 행 값 기반 조건부 잠금 |
| A6 | GEN |  |  |  |  |  | 2 | 10 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| DB-SYN | DB |  |  |  |  | 1 |  | 10 |  |  | BE 계정 시노님·권한·대상 객체 |
| C3 | CASCADE |  |  |  |  |  | 4 | 7 |  |  | 연쇄 자동 채움 |
| G1 | GEN |  |  |  |  |  | 5 | 6 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| A5 | DESIGN |  |  |  |  |  | 1 | 9 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| D4 | EDIT |  |  |  |  |  | 7 | 2 |  |  | 신규행 기본값·자동세팅·Insert 전제 |
| C2 | CASCADE |  |  |  |  |  | 4 | 4 |  |  | 그리드 셀 cascade 후보 |
| M4 | POPUP |  |  |  |  |  | 3 | 4 |  |  | 팝업 선택값 반영 |
| G5 | POPUP |  |  |  |  | 2 |  | 4 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 1 | 1 | 4 |  |  | 팝업 표준·열림 |
| G4 | DESIGN |  |  |  |  | 1 | 2 | 2 |  |  | 조회조건 표시·라벨·활성 |
| C6 | CASCADE |  |  |  |  |  | 1 | 4 |  |  | 무변경 편집 종료 시 연쇄 미발동 |
| C1 | CASCADE |  |  |  |  |  | 4 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| G6 | GEN |  |  |  |  |  | 2 | 2 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| E2 | EDIT |  |  |  |  | 2 |  |  |  |  | 날짜 형식·유효성 |
| E1 | EDIT |  |  |  |  |  | 2 |  |  |  | 숫자 소수자리·정수·부호·범위 |
| H10 | DESIGN |  |  | 1 |  |  |  |  |  |  | 메시지 표준(방식·코드 단일화) |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| C4 | CASCADE |  |  |  |  |  | 1 |  |  |  | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
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

## W2 구현 위치 확인 (21)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0131-0001 | X-LOC | COMMON:UC-02 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-02) |
| WK-SCP0131-0002 | X-LOC | COMMON:UC-03 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-03) |
| WK-SCP0131-0003 | X-LOC | COMMON:UC-04 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-04) |
| WK-SCP0131-0004 | X-LOC | COMMON:UC-05 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-05) |
| WK-SCP0131-0005 | X-LOC | COMMON:UC-06 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-06) |
| WK-SCP0131-0006 | X-LOC | COMMON:UC-07 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (COMMON:UC-07) |
| WK-SCP0131-0007 | X-LOC | Delete(365) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Delete(365)) |
| WK-SCP0131-0008 | X-LOC | Insert(507) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Insert(507)) |
| WK-SCP0131-0009 | X-LOC | LockColumn(375) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (LockColumn(375)) |
| WK-SCP0131-0010 | X-LOC | LockColumn(377) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (LockColumn(377)) |
| WK-SCP0131-0011 | X-LOC | LockColumn(462) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (LockColumn(462)) |
| WK-SCP0131-0012 | X-LOC | LockRange(518) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (LockRange(518)) |
| WK-SCP0131-0013 | X-LOC | LockRange(519) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (LockRange(519)) |
| WK-SCP0131-0014 | X-LOC | Query(461, dataSource) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Query(461, dataSource)) |
| WK-SCP0131-0015 | X-LOC | SetSheetHeaderColumnSCP(315) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SetSheetHeaderColumnSCP(315)) |
| WK-SCP0131-0016 | X-LOC | SetText(945) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SetText(945)) |
| WK-SCP0131-0017 | X-LOC | SetValue(1004) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SetValue(1004)) |
| WK-SCP0131-0018 | X-LOC | SetValue(1064) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SetValue(1064)) |
| WK-SCP0131-0019 | X-LOC | SetValue(516) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SetValue(516)) |
| WK-SCP0131-0020 | X-LOC | SmartColMerge(854) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SmartColMerge(854)) |
| WK-SCP0131-0021 | X-LOC | SwitchLock(374) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SwitchLock(374)) |

## W3 동작 수정 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0131-0022 | H10 | SCP0131 화면 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | H10 FAIL 수정 — SCP0131 화면: 표준 메시지 대신 브라우저 alert/confirm 직접 호출: hooks/useSalesSitePriorityValidation.ts |  | 13 (7 8 9 10 11 12 COMMON:UC-01 COMMON:UC-02) |

## W5 검사기 연결 (10)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0131-0023 | F2 | SCP0131 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0131 화면 | 판단불가(대상 단위 SCREEN) | 165 (7 8 11 ACT:SCP0131_SalesSitePriority.Sav) |
| WK-SCP0131-0024 | F6 | SCP0131 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0131 화면 | 판단불가(대상 단위 SCREEN) | 162 (ACT:SCP0131_SalesSitePriority.SaveButton) |
| WK-SCP0131-0025 | DB-SYN | PKG_SCP0131 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP PKG_SCP0131 | 없음(PROC_M 대응 없음) | 0 () |
| WK-SCP0131-0026 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 없음 | 2 (ACT:SCP0131_SalesSitePriority.InitEvent ) |
| WK-SCP0131-0027 | E2 | FROM_YYYYMMDD | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E2(_verify.spec(@verify)) → 대상 COL FROM_YYYYMMDD | 있음(SHEET_COLUMNS) | 1 (12) |
| WK-SCP0131-0028 | E2 | TO_YYYYMMDD | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 E2(_verify.spec(@verify)) → 대상 COL TO_YYYYMMDD | 있음(SHEET_COLUMNS) | 3 (10 11 SetValue(1004)) |
| WK-SCP0131-0029 | G03-WIRE | SCP0131 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0131 화면 | 판단불가(대상 단위 SCREEN) | 10 (ACT:SCP0131_SalesSitePriority..ctor ACT:) |
| WK-SCP0131-0030 | G5 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 18 (4 SetText(945) ACT:SCP0131_SalesSitePrio) |
| WK-SCP0131-0031 | G5 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 2 (ACT:SCP0131_SalesSitePriority.SpdMain_Ce) |
| WK-SCP0131-0032 | H6 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 18 (4 SetText(945) ACT:SCP0131_SalesSitePrio) |

## W6 검증 실행 (90)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0131-0033 | J2 | SCP0131 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0131 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 30 (7 8 10 11 12 - Delete(365) SwitchLock(37) |
| WK-SCP0131-0034 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (2 ACT:SCP0131_SalesSitePriority.InitCont) |
| WK-SCP0131-0035 | C1 | cboValid / Valid / Active | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboValid / Valid / Active · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0131_SalesSitePriority.InitContro) |
| WK-SCP0131-0036 | C1 | clbPlanGroup / Plan Group | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbPlanGroup / Plan Group · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0131_SalesSitePriority.RefreshPla) |
| WK-SCP0131-0037 | C1 | clbSite / SCM Site / Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbSite / SCM Site / Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0131_SalesSitePriority.RefreshSit) |
| WK-SCP0131-0038 | C2 | OPMZ_PLAN_GR_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — OPMZ_PLAN_GR_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCP0131_SalesSitePriority.spdMain_Ce) |
| WK-SCP0131-0039 | C2 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0131_SalesSitePriority.spdMain_Ce) |
| WK-SCP0131-0040 | C2 | TO_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — TO_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (11) |
| WK-SCP0131-0041 | C2 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (ACT:SCP0131_SalesSitePriority.spdMain_Ce) |
| WK-SCP0131-0042 | C3 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (ACT:SCP0131_SalesSitePriority.Set_Measur) |
| WK-SCP0131-0043 | C3 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCP0131_SalesSitePriority.SpdMain_Ce) |
| WK-SCP0131-0044 | C3 | OPMZ_PLAN_GR_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — OPMZ_PLAN_GR_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 6 (5 SetValue(1064) ACT:SCP0131_SalesSitePr) |
| WK-SCP0131-0045 | C3 | TO_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — TO_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 3 (10 11 ACT:SCP0131_SalesSitePriority.SpdM) |
| WK-SCP0131-0046 | C4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (2) |
| WK-SCP0131-0047 | C6 | TO_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — TO_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (11) |
| WK-SCP0131-0048 | G3 | SCP0131 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0131 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 7 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-03 C) |
| WK-SCP0131-0049 | K4 | SCP0131 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0131 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 19 (COMMON:UC-01 COMMON:UC-02 COMMON:UC-03 C) |
| WK-SCP0131-0050 | F1 | SCP0131 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0131 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 171 (7 8 11 Delete(365) ACT:SCP0131_SalesSite) |
| WK-SCP0131-0051 | F3 | SCP0131 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F3 실행 — SCP0131 화면 · 검사기 있음(_trace.spec(@trace) W4b 붙여넣기 — Ctrl+C/Ctrl+V 로 셀 값 복사 후 값·연쇄) — 실행 필요: trace |  | 12 (5 10 SetValue(1064) ACT:SCP0131_SalesSit) |
| WK-SCP0131-0052 | F5 | SCP0131 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0131 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 6 (Delete(365) ACT:SCP0131_SalesSitePriorit) |
| WK-SCP0131-0053 | F4 | PKG_SCP0128.P_SCP0128_GET_SEARCH_INFO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0128.P_SCP0128_GET_SEARCH_INFO · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: sm |  | 163 (ACT:SCP0131_SalesSitePriority.GetSearchI) |
| WK-SCP0131-0054 | F4 | PKG_SCP0131 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0131 · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 0 () |
| WK-SCP0131-0055 | F4 | PKG_SCP0131.P_SCP0131_GET_SALES_SITE_PRI | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0131.P_SCP0131_GET_SALES_SITE_PRIORITY · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실 |  | 207 (ACT:SCP0131_SalesSitePriority.FindButton) |
| WK-SCP0131-0056 | F4 | PKG_SCP0131.P_SCP0131_SAVE_SALES_SITE_PR | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0131.P_SCP0131_SAVE_SALES_SITE_PRIORITY · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) —  |  | 162 (ACT:SCP0131_SalesSitePriority.SaveButton) |
| WK-SCP0131-0057 | A5 | ITEM_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:SCP0131_SalesSitePriority.SpdMain_Ce) |
| WK-SCP0131-0058 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0131_SalesSitePriority.InitContro) |
| WK-SCP0131-0059 | G4 | cboValid / Valid / Active | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboValid / Valid / Active · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0131_SalesSitePriority.InitContro) |
| WK-SCP0131-0060 | H2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (- ACT:SCP0131_SalesSitePriority.Set_Meas) |
| WK-SCP0131-0061 | H2 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (-) |
| WK-SCP0131-0062 | H4 | SCP0131 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — SCP0131 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 6 (6 SmartColMerge(854) ACT:SCP0131_SalesSi) |
| WK-SCP0131-0063 | I1 | SCP0131 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0131 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 18 (7 8 9 10 11 12 ACT:SCP0131_SalesSitePrio) |
| WK-SCP0131-0064 | SC1 | SCP0131 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SCP0131 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 2 (- COMMON:UC-06) |
| WK-SCP0131-0065 | D1 | CREATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CREATED_BY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (ACT:SCP0131_SalesSitePriority.EditButton) |
| WK-SCP0131-0066 | D1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 7 (- LockColumn(375) LockRange(518) ACT:SCP) |
| WK-SCP0131-0067 | D1 | FROM_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — FROM_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (12) |
| WK-SCP0131-0068 | D1 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 0 () |
| WK-SCP0131-0069 | D1 | LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SCP0131_SalesSitePriority.Insert_Row) |
| WK-SCP0131-0070 | D1 | PRE_KEY_VALUES | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PRE_KEY_VALUES · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (LockColumn(377) ACT:SCP0131_SalesSitePri) |
| WK-SCP0131-0071 | D1 | TO_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — TO_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 3 (10 11 SetValue(1004)) |
| WK-SCP0131-0072 | D1 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (-) |
| WK-SCP0131-0073 | D3 | CREATED_BY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CREATED_BY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:SCP0131_SalesSitePriority.EditButton) |
| WK-SCP0131-0074 | D3 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 7 (- LockColumn(375) LockRange(518) ACT:SCP) |
| WK-SCP0131-0075 | D3 | FROM_YYYYMMDD | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — FROM_YYYYMMDD · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (12) |
| WK-SCP0131-0076 | D3 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 0 () |
| WK-SCP0131-0077 | D3 | LAST_UPDATE_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LAST_UPDATE_DATE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SCP0131_SalesSitePriority.Insert_Row) |
| WK-SCP0131-0078 | D3 | PRE_KEY_VALUES | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PRE_KEY_VALUES · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (LockColumn(377) ACT:SCP0131_SalesSitePri) |
| WK-SCP0131-0079 | D3 | TO_YYYYMMDD | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — TO_YYYYMMDD · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (10 11 SetValue(1004)) |
| WK-SCP0131-0080 | D3 | VALID_YN | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — VALID_YN · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (-) |
| WK-SCP0131-0081 | D4 | CREATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — CREATED_BY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 0 () |
| WK-SCP0131-0082 | D4 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 2 (- SetValue(516)) |
| WK-SCP0131-0083 | D4 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (SetText(945)) |
| WK-SCP0131-0084 | D4 | OPMZ_PLAN_GR_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — OPMZ_PLAN_GR_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (SetValue(1064)) |
| WK-SCP0131-0085 | D4 | PRE_KEY_VALUES | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — PRE_KEY_VALUES · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 0 () |
| WK-SCP0131-0086 | D4 | TO_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — TO_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 2 (11 SetValue(1004)) |
| WK-SCP0131-0087 | D4 | VALID_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — VALID_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 2 (- SetValue(516)) |
| WK-SCP0131-0088 | D6 | SCP0131 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0131 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 6 (11 - Insert(507) COMMON:UC-01 ACT:SCP013) |
| WK-SCP0131-0089 | E1 | OPMZ_PLAN_GR_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — OPMZ_PLAN_GR_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 6 (5 SetValue(1064) ACT:SCP0131_SalesSitePr) |
| WK-SCP0131-0090 | E1 | TO_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — TO_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 1 (10) |
| WK-SCP0131-0091 | E4 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SCP0131_SalesSitePriority.Set_Measur) |
| WK-SCP0131-0092 | E4 | FROM_YYYYMMDD | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — FROM_YYYYMMDD · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (12 ACT:SCP0131_SalesSitePriority.SpdMain) |
| WK-SCP0131-0093 | E4 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 0 () |
| WK-SCP0131-0094 | E4 | MSG00001 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00001 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0131_SalesSitePriority.SaveData:6) |
| WK-SCP0131-0095 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (7 ACT:SCP0131_SalesSitePriority.SaveData) |
| WK-SCP0131-0096 | E4 | MSG00013 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00013 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 0 () |
| WK-SCP0131-0097 | E4 | MSG00046 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00046 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0131_SalesSitePriority.SaveData:6) |
| WK-SCP0131-0098 | E4 | MSG00049 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00049 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (10 12 ACT:SCP0131_SalesSitePriority.SpdM) |
| WK-SCP0131-0099 | E4 | MSG00175 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00175 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0131_SalesSitePriority.SaveData:6) |
| WK-SCP0131-0100 | E4 | MSG00219 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00219 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (11 ACT:SCP0131_SalesSitePriority.SaveDat) |
| WK-SCP0131-0101 | E4 | MSG00260 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00260 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0131_SalesSitePriority.SaveData:6) |
| WK-SCP0131-0102 | E4 | MSG00458 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00458 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0131_SalesSitePriority.SaveData:6) |
| WK-SCP0131-0103 | E4 | MSG00672 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00672 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (7) |
| WK-SCP0131-0104 | E4 | MSG00699 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00699 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 0 () |
| WK-SCP0131-0105 | E4 | MSG01135 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01135 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 0 () |
| WK-SCP0131-0106 | E4 | PRIO_RANK | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — PRIO_RANK · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 0 () |
| WK-SCP0131-0107 | E4 | TO_YYYYMMDD | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — TO_YYYYMMDD · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (10 11 SetValue(1004) ACT:SCP0131_SalesSi) |
| WK-SCP0131-0108 | A10 | SCP0131 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0131 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 35 (ACT:SCP0131_SalesSitePriority.Form_Load ) |
| WK-SCP0131-0109 | A6 | PKG_SCP0131 | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0131 · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 0 () |
| WK-SCP0131-0110 | A6 | PKG_SCP0131.P_SCP0131_GET_SALES_SITE_PRI | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0131.P_SCP0131_GET_SALES_SITE_PRIORITY · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 |  | 46 (ACT:SCP0131_SalesSitePriority.FindButton) |
| WK-SCP0131-0111 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0131_SalesSitePriority.FindData_M) |
| WK-SCP0131-0112 | G1 | cboValid / Valid / Active | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboValid / Valid / Active · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0131_SalesSitePriority.FindData_M) |
| WK-SCP0131-0113 | G1 | clbPlanGroup / Plan Group | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbPlanGroup / Plan Group · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0131_SalesSitePriority.FindData_M) |
| WK-SCP0131-0114 | G1 | clbSite / SCM Site / Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbSite / SCM Site / Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0131_SalesSitePriority.FindData_M) |
| WK-SCP0131-0115 | G1 | txtItemId / Model / Item Id / Model/Nick | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0131_SalesSitePriority.FindData_M) |
| WK-SCP0131-0116 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCP0131_SalesSitePriority.InitContro) |
| WK-SCP0131-0117 | G6 | cboValid / Valid / Active | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboValid / Valid / Active · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0131_SalesSitePriority.InitContro) |
| WK-SCP0131-0118 | X-REOPEN | SCP0131 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0131 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 7 (ACT:SCP0131_SalesSitePriority.Dispose AC) |
| WK-SCP0131-0119 | H6 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboDivision / Division · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 2 (ACT:SCP0131_SalesSitePriority.SpdMain_Ce) |
| WK-SCP0131-0120 | M4 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 18 (4 SetText(945) ACT:SCP0131_SalesSitePrio) |
| WK-SCP0131-0121 | M4 | SCM_SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SCM_SITE_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SCP0131_SalesSitePriority.SpdMain_Ce) |
| WK-SCP0131-0122 | M4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SCP0131_SalesSitePriority.SpdMain_Ce) |

## W7 기대값 확정 (166)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0131-0123 | C2 | SCP0131_SalesSitePriority.CboDivision_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0131_SalesSitePriority.CboDivision_SelectedInde: 진입점 집계 — C2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0131_SalesSitePriority.CboDivisio) |
| WK-SCP0131-0124 | C2 | SCP0131_SalesSitePriority.CboPlanGroup_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0131_SalesSitePriority.CboPlanGroup_SelectedInd: 진입점 집계 — C2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0131_SalesSitePriority.CboPlanGro) |
| WK-SCP0131-0125 | C2 | SCP0131_SalesSitePriority.CboPlanSeq_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0131_SalesSitePriority.CboPlanSeq_SelectedIndex: 진입점 집계 — C2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0131_SalesSitePriority.CboPlanSeq) |
| WK-SCP0131-0126 | C2 | SCP0131_SalesSitePriority.ClbDivision_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0131_SalesSitePriority.ClbDivision_SelectedInde: 진입점 집계 — C2 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0131_SalesSitePriority.ClbDivisio) |
| WK-SCP0131-0127 | C3 | SCP0131_SalesSitePriority.CboDivision_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0131_SalesSitePriority.CboDivision_SelectedInde: 진입점 집계 — C3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0131_SalesSitePriority.CboDivisio) |
| WK-SCP0131-0128 | C3 | SCP0131_SalesSitePriority.CboPlanGroup_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0131_SalesSitePriority.CboPlanGroup_SelectedInd: 진입점 집계 — C3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0131_SalesSitePriority.CboPlanGro) |
| WK-SCP0131-0129 | C3 | SCP0131_SalesSitePriority.CboPlanSeq_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0131_SalesSitePriority.CboPlanSeq_SelectedIndex: 진입점 집계 — C3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0131_SalesSitePriority.CboPlanSeq) |
| WK-SCP0131-0130 | C3 | SCP0131_SalesSitePriority.ClbDivision_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0131_SalesSitePriority.ClbDivision_SelectedInde: 진입점 집계 — C3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0131_SalesSitePriority.ClbDivisio) |
| WK-SCP0131-0131 | C3 | SCP0131_SalesSitePriority.SetChangedCont | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0131_SalesSitePriority.SetChangedControl: 진입점 집계 — C3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0131_SalesSitePriority.SetChanged) |
| WK-SCP0131-0132 | C3 | SCP0131_SalesSitePriority.Set_MeasureCol | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0131_SalesSitePriority.Set_MeasureColor: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0131_SalesSitePriority.Set_Measur) |
| WK-SCP0131-0133 | C3 | SCP0131_SalesSitePriority.setPeriod | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0131_SalesSitePriority.setPeriod: 진입점 집계 — C3 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0131_SalesSitePriority.setPeriod:) |
| WK-SCP0131-0134 | C6 | SCP0131_SalesSitePriority.CboDivision_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0131_SalesSitePriority.CboDivision_SelectedInde: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0131_SalesSitePriority.CboDivisio) |
| WK-SCP0131-0135 | C6 | SCP0131_SalesSitePriority.CboPlanGroup_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0131_SalesSitePriority.CboPlanGroup_SelectedInd: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0131_SalesSitePriority.CboPlanGro) |
| WK-SCP0131-0136 | C6 | SCP0131_SalesSitePriority.CboPlanSeq_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0131_SalesSitePriority.CboPlanSeq_SelectedIndex: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0131_SalesSitePriority.CboPlanSeq) |
| WK-SCP0131-0137 | C6 | SCP0131_SalesSitePriority.ClbDivision_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0131_SalesSitePriority.ClbDivision_SelectedInde: 진입점 집계 — C6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0131_SalesSitePriority.ClbDivisio) |
| WK-SCP0131-0138 | DB-SYN | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 1: 행 집계 — DB-SYN 4요소: PASS:3 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0131-0139 | DB-SYN | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 10: 행 집계 — DB-SYN 4요소: PASS:3 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (10) |
| WK-SCP0131-0140 | DB-SYN | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 11: 행 집계 — DB-SYN 4요소: PASS:3 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (11) |
| WK-SCP0131-0141 | DB-SYN | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 12: 행 집계 — DB-SYN 4요소: PASS:3 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (12) |
| WK-SCP0131-0142 | DB-SYN | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 3: 행 집계 — DB-SYN 4요소: PASS:3 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0131-0143 | DB-SYN | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 4: 행 집계 — DB-SYN 4요소: PASS:3 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0131-0144 | DB-SYN | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 5: 행 집계 — DB-SYN 4요소: PASS:3 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0131-0145 | DB-SYN | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 7: 행 집계 — DB-SYN 4요소: PASS:3 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (7) |
| WK-SCP0131-0146 | DB-SYN | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 8: 행 집계 — DB-SYN 4요소: PASS:3 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (8) |
| WK-SCP0131-0147 | DB-SYN | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 9: 행 집계 — DB-SYN 4요소: PASS:3 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (9) |
| WK-SCP0131-0148 | F4 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 1: 행 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0131-0149 | F4 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 10: 행 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (10) |
| WK-SCP0131-0150 | F4 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 11: 행 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (11) |
| WK-SCP0131-0151 | F4 | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 12: 행 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (12) |
| WK-SCP0131-0152 | F4 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 3: 행 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0131-0153 | F4 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 4: 행 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0131-0154 | F4 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 5: 행 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0131-0155 | F4 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 7: 행 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (7) |
| WK-SCP0131-0156 | F4 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 8: 행 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (8) |
| WK-SCP0131-0157 | F4 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 9: 행 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (9) |
| WK-SCP0131-0158 | A5 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 4: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0131-0159 | A5 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-01: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SCP0131-0160 | A5 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-02: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0131-0161 | A5 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-05: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0131-0162 | A5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-07: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0131-0163 | A5 | Query(461, dataSource) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — Query(461, dataSource): 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (Query(461, dataSource)) |
| WK-SCP0131-0164 | A5 | SCP0131_SalesSitePriority.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0131_SalesSitePriority.CreateSpread: 진입점 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0131_SalesSitePriority.CreateSpre) |
| WK-SCP0131-0165 | A5 | SetSheetHeaderColumnSCP(315) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SetSheetHeaderColumnSCP(315): 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (SetSheetHeaderColumnSCP(315)) |
| WK-SCP0131-0166 | A5 | SwitchLock(374) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SwitchLock(374): 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (SwitchLock(374)) |
| WK-SCP0131-0167 | G4 | - | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — -: 행 집계 — G4 3요소: NOT_RUN:2 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (-) |
| WK-SCP0131-0168 | G4 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — COMMON:UC-06: 행 집계 — G4 3요소: NOT_RUN:2 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0131-0169 | H2 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 4: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0131-0170 | H2 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 6: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (6) |
| WK-SCP0131-0171 | H2 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-01: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SCP0131-0172 | H2 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-02: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0131-0173 | H2 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-05: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0131-0174 | H2 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-07: 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0131-0175 | H2 | Query(461, dataSource) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — Query(461, dataSource): 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (Query(461, dataSource)) |
| WK-SCP0131-0176 | H2 | SCP0131_SalesSitePriority.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0131_SalesSitePriority.CreateSpread: 진입점 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0131_SalesSitePriority.CreateSpre) |
| WK-SCP0131-0177 | H2 | SCP0131_SalesSitePriority.Set_MeasureCol | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0131_SalesSitePriority.Set_MeasureColor: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0131_SalesSitePriority.Set_Measur) |
| WK-SCP0131-0178 | H2 | SetSheetHeaderColumnSCP(315) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SetSheetHeaderColumnSCP(315): 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (SetSheetHeaderColumnSCP(315)) |
| WK-SCP0131-0179 | H2 | SmartColMerge(854) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SmartColMerge(854): 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (SmartColMerge(854)) |
| WK-SCP0131-0180 | H2 | SwitchLock(374) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SwitchLock(374): 행 집계 — H2 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (SwitchLock(374)) |
| WK-SCP0131-0181 | D1 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 2: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0131-0182 | D1 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — 5: 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0131-0183 | D1 | LockColumn(462) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — LockColumn(462): 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (LockColumn(462)) |
| WK-SCP0131-0184 | D1 | LockRange(519) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — LockRange(519): 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (LockRange(519)) |
| WK-SCP0131-0185 | D1 | SCP0131_SalesSitePriority.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SCP0131_SalesSitePriority.EditButton: 진입점 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0131_SalesSitePriority.EditButton) |
| WK-SCP0131-0186 | D1 | SwitchLock(374) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SwitchLock(374): 행 집계 — D1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (SwitchLock(374)) |
| WK-SCP0131-0187 | D3 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 2: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0131-0188 | D3 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — 5: 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0131-0189 | D3 | LockColumn(462) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — LockColumn(462): 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (LockColumn(462)) |
| WK-SCP0131-0190 | D3 | LockRange(519) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — LockRange(519): 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (LockRange(519)) |
| WK-SCP0131-0191 | D3 | SCP0131_SalesSitePriority.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SCP0131_SalesSitePriority.EditButton: 진입점 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0131_SalesSitePriority.EditButton) |
| WK-SCP0131-0192 | D3 | SwitchLock(374) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SwitchLock(374): 행 집계 — D3 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (SwitchLock(374)) |
| WK-SCP0131-0193 | D4 | COMMON:UC-01 | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — COMMON:UC-01: 행 집계 — D4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-01) |
| WK-SCP0131-0194 | D4 | Insert(507) | 사람 판정 / AS-IS 원문 확인 → 재판정 | D4 기대값 확정 — Insert(507): 행 집계 — D4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (Insert(507)) |
| WK-SCP0131-0195 | E4 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 1: 행 집계 — E4 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0131-0196 | E4 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 8: 행 집계 — E4 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (8) |
| WK-SCP0131-0197 | E4 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 9: 행 집계 — E4 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (9) |
| WK-SCP0131-0198 | E4 | COMMON:UC-04 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — COMMON:UC-04: 행 집계 — E4 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-04) |
| WK-SCP0131-0199 | E4 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — COMMON:UC-06: 행 집계 — E4 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0131-0200 | E4 | SCP0131_SalesSitePriority.SetChangedCont | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0131_SalesSitePriority.SetChangedControl: 진입점 집계 — E4 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0131_SalesSitePriority.SetChanged) |
| WK-SCP0131-0201 | E4 | SCP0131_SalesSitePriority.Set_MeasureCol | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0131_SalesSitePriority.Set_MeasureColor: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0131_SalesSitePriority.Set_Measur) |
| WK-SCP0131-0202 | E4 | SCP0131_SalesSitePriority.setPeriod | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0131_SalesSitePriority.setPeriod: 진입점 집계 — E4 17요소: NOT_RUN:17 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0131_SalesSitePriority.setPeriod:) |
| WK-SCP0131-0203 | A1 | - | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — -: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (-) |
| WK-SCP0131-0204 | A1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1: 행 집계 — A1 2요소: REVIEW:2 |  | 0 () |
| WK-SCP0131-0205 | A1 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 10: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (10) |
| WK-SCP0131-0206 | A1 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 11: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (11) |
| WK-SCP0131-0207 | A1 | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 12: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (12) |
| WK-SCP0131-0208 | A1 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 3: 행 집계 — A1 2요소: REVIEW:2 |  | 0 () |
| WK-SCP0131-0209 | A1 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 4: 행 집계 — A1 2요소: REVIEW:2 |  | 0 () |
| WK-SCP0131-0210 | A1 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 5: 행 집계 — A1 2요소: REVIEW:2 |  | 0 () |
| WK-SCP0131-0211 | A1 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 7: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (7) |
| WK-SCP0131-0212 | A1 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 8: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (8) |
| WK-SCP0131-0213 | A1 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 9: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (9) |
| WK-SCP0131-0214 | A1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-02: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (COMMON:UC-02) |
| WK-SCP0131-0215 | A1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-03: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (COMMON:UC-03) |
| WK-SCP0131-0216 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (COMMON:UC-06) |
| WK-SCP0131-0217 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (COMMON:UC-07) |
| WK-SCP0131-0218 | A1 | LockColumn(462) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — LockColumn(462): 행 집계 — A1 2요소: REVIEW:2 |  | 1 (LockColumn(462)) |
| WK-SCP0131-0219 | A1 | PKG_SCP0131 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0131: 골든 비교 케이스 없음(PKG_SCP0131 — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 0 () |
| WK-SCP0131-0220 | A1 | PKG_SCP0131.P_SCP0131_GET_SALES_SITE_PRI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0131.P_SCP0131_GET_SALES_SITE_PRIORITY: 골든 비교 케이스 없음(PKG_SCP0131.P_SCP0131_GET_SALES_SITE_PRIORITY — 팝업·보조 SP 는 |  | 46 (ACT:SCP0131_SalesSitePriority.FindButton) |
| WK-SCP0131-0221 | A6 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 1: 행 집계 — A6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0131-0222 | A6 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 10: 행 집계 — A6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (10) |
| WK-SCP0131-0223 | A6 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 11: 행 집계 — A6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (11) |
| WK-SCP0131-0224 | A6 | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 12: 행 집계 — A6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (12) |
| WK-SCP0131-0225 | A6 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 3: 행 집계 — A6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0131-0226 | A6 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 4: 행 집계 — A6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0131-0227 | A6 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 5: 행 집계 — A6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0131-0228 | A6 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 7: 행 집계 — A6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (7) |
| WK-SCP0131-0229 | A6 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 8: 행 집계 — A6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (8) |
| WK-SCP0131-0230 | A6 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 9: 행 집계 — A6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (9) |
| WK-SCP0131-0231 | G1 | - | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — -: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (-) |
| WK-SCP0131-0232 | G1 | COMMON:UC-02 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-02: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-02) |
| WK-SCP0131-0233 | G1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-03: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-SCP0131-0234 | G1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-06: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0131-0235 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0131-0236 | G1 | LockColumn(462) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — LockColumn(462): 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (LockColumn(462)) |
| WK-SCP0131-0237 | G6 | - | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — -: 행 집계 — G6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (-) |
| WK-SCP0131-0238 | G6 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — COMMON:UC-06: 행 집계 — G6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0131-0239 | X-LOC | - | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — -: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (-) |
| WK-SCP0131-0240 | X-LOC | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (1) |
| WK-SCP0131-0241 | X-LOC | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 10: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (10) |
| WK-SCP0131-0242 | X-LOC | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 11: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (11) |
| WK-SCP0131-0243 | X-LOC | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 12: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (12) |
| WK-SCP0131-0244 | X-LOC | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (2) |
| WK-SCP0131-0245 | X-LOC | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (4) |
| WK-SCP0131-0246 | X-LOC | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 6: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (6) |
| WK-SCP0131-0247 | X-LOC | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 7: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (7) |
| WK-SCP0131-0248 | X-LOC | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 8: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (8) |
| WK-SCP0131-0249 | X-LOC | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 9: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (9) |
| WK-SCP0131-0250 | X-ROW | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 1: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (1) |
| WK-SCP0131-0251 | X-ROW | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 3: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (3) |
| WK-SCP0131-0252 | X-ROW | SCP0131_SalesSitePriority.CboDivision_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0131_SalesSitePriority.CboDivision_SelectedInde: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0131_SalesSitePriority.CboDivisio) |
| WK-SCP0131-0253 | X-ROW | SCP0131_SalesSitePriority.CboPlanGroup_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0131_SalesSitePriority.CboPlanGroup_SelectedInd: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0131_SalesSitePriority.CboPlanGro) |
| WK-SCP0131-0254 | X-ROW | SCP0131_SalesSitePriority.CboPlanSeq_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0131_SalesSitePriority.CboPlanSeq_SelectedIndex: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0131_SalesSitePriority.CboPlanSeq) |
| WK-SCP0131-0255 | X-ROW | SCP0131_SalesSitePriority.ClbDivision_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0131_SalesSitePriority.ClbDivision_SelectedInde: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0131_SalesSitePriority.ClbDivisio) |
| WK-SCP0131-0256 | X-ROW | SCP0131_SalesSitePriority.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0131_SalesSitePriority.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0131_SalesSitePriority.CreateSpre) |
| WK-SCP0131-0257 | X-ROW | SCP0131_SalesSitePriority.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0131_SalesSitePriority.FindButton: 진입점 집계 3검사 — NOT_RUN:2 · REVIEW:1 |  | 1 (ACT:SCP0131_SalesSitePriority.FindButton) |
| WK-SCP0131-0258 | X-ROW | SCP0131_SalesSitePriority.FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0131_SalesSitePriority.FindData_Main: 진입점 집계 10검사 — NOT_RUN:8 · REVIEW:1 · PASS:1 |  | 7 (ACT:SCP0131_SalesSitePriority.FindData_M) |
| WK-SCP0131-0259 | X-ROW | SCP0131_SalesSitePriority.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0131_SalesSitePriority.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0131_SalesSitePriority.Form_Load) |
| WK-SCP0131-0260 | X-ROW | SCP0131_SalesSitePriority.GetDivisionChe | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0131_SalesSitePriority.GetDivisionChecked: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0131_SalesSitePriority.GetDivisio) |
| WK-SCP0131-0261 | X-ROW | SCP0131_SalesSitePriority.GetSearchInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0131_SalesSitePriority.GetSearchInfo: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:1 · TODO:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0131_SalesSitePriority.GetSearchI) |
| WK-SCP0131-0262 | X-ROW | SCP0131_SalesSitePriority.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0131_SalesSitePriority.InitControls: 진입점 집계 7검사 — NOT_RUN:7 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0131_SalesSitePriority.InitContro) |
| WK-SCP0131-0263 | X-ROW | SCP0131_SalesSitePriority.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0131_SalesSitePriority.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0131_SalesSitePriority.InitSpread) |
| WK-SCP0131-0264 | X-ROW | SCP0131_SalesSitePriority.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0131_SalesSitePriority.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0131_SalesSitePriority.InsertButt) |
| WK-SCP0131-0265 | X-ROW | SCP0131_SalesSitePriority.Insert_Row | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0131_SalesSitePriority.Insert_Row: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SCP0131_SalesSitePriority.Insert_Row) |
| WK-SCP0131-0266 | X-ROW | SCP0131_SalesSitePriority.RefreshPlanGro | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0131_SalesSitePriority.RefreshPlanGroupByDivisi: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0131_SalesSitePriority.RefreshPla) |
| WK-SCP0131-0267 | X-ROW | SCP0131_SalesSitePriority.RefreshSiteByD | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0131_SalesSitePriority.RefreshSiteByDivision: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SCP0131_SalesSitePriority.RefreshSit) |
| WK-SCP0131-0268 | X-ROW | SCP0131_SalesSitePriority.SaveData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0131_SalesSitePriority.SaveData: 진입점 집계 18검사 — NOT_RUN:13 · PASS:3 · NOPATH:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0131_SalesSitePriority.SaveData:7) |
| WK-SCP0131-0269 | X-ROW | SCP0131_SalesSitePriority.SetChangedCont | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0131_SalesSitePriority.SetChangedControl: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0131_SalesSitePriority.SetChanged) |
| WK-SCP0131-0270 | X-ROW | SCP0131_SalesSitePriority.SpdMain_CellDo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0131_SalesSitePriority.SpdMain_CellDoubleClick: 진입점 집계 12검사 — NOT_RUN:6 · NOPATH:3 · REVIEW:3 |  | 2 (ACT:SCP0131_SalesSitePriority.SpdMain_Ce) |
| WK-SCP0131-0271 | X-ROW | SCP0131_SalesSitePriority.SpdMain_Clipbo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0131_SalesSitePriority.SpdMain_ClipboardPasted: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0131_SalesSitePriority.SpdMain_Cl) |
| WK-SCP0131-0272 | X-ROW | SCP0131_SalesSitePriority.SpdMain_EditCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0131_SalesSitePriority.SpdMain_EditChange: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 31 (ACT:SCP0131_SalesSitePriority.SpdMain_Ed) |
| WK-SCP0131-0273 | X-ROW | SCP0131_SalesSitePriority.SpdMain_TopCha | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0131_SalesSitePriority.SpdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0131_SalesSitePriority.SpdMain_To) |
| WK-SCP0131-0274 | X-ROW | SCP0131_SalesSitePriority.btnItemId_Clic | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0131_SalesSitePriority.btnItemId_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0131_SalesSitePriority.btnItemId_) |
| WK-SCP0131-0275 | X-ROW | SCP0131_SalesSitePriority.setPeriod | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0131_SalesSitePriority.setPeriod: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0131_SalesSitePriority.setPeriod ) |
| WK-SCP0131-0276 | X-ROW | SCP0131_SalesSitePriority.spdMain_CellCl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0131_SalesSitePriority.spdMain_CellClick: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 17 (ACT:SCP0131_SalesSitePriority.spdMain_Ce) |
| WK-SCP0131-0277 | G5 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — 3: 행 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0131-0278 | G5 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — 4: 행 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0131-0279 | G5 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — 5: 행 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0131-0280 | G5 | SCP0131_SalesSitePriority.SpdMain_CellDo | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCP0131_SalesSitePriority.SpdMain_CellDoubleClick: 진입점 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0131_SalesSitePriority.SpdMain_Ce) |
| WK-SCP0131-0281 | H6 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — 3: 행 집계 — H6 2요소: NOPATH:1 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0131-0282 | H6 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — 4: 행 집계 — H6 2요소: NOPATH:1 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0131-0283 | H6 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — 5: 행 집계 — H6 2요소: NOPATH:1 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0131-0284 | H6 | SCP0131_SalesSitePriority.SpdMain_CellDo | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCP0131_SalesSitePriority.SpdMain_CellDoubleClick: 진입점 집계 — H6 2요소: NOPATH:1 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0131_SalesSitePriority.SpdMain_Ce) |
| WK-SCP0131-0285 | M4 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 3: 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0131-0286 | M4 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 4: 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0131-0287 | M4 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 5: 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0131-0288 | M4 | SCP0131_SalesSitePriority.SpdMain_CellDo | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0131_SalesSitePriority.SpdMain_CellDoubleClick: 진입점 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0131_SalesSitePriority.SpdMain_Ce) |
