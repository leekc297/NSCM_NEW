# 작업 원장 — SCP0055 · 2026-10-26 12:54

> 검사 인스턴스 264건 중 PASS·NA 49건 외 **215건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 4 | 구현 위치 실존 |
| W4 | 검사기 구현 | 3 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 29 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 78 | 실행 → PASS |
| W7 | 기대값 확정 | 101 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 101 · E2E 78 · 하네스 32 · 대조표 4
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 23건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 43 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| F4 | DB |  |  |  |  |  | 24 | 5 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| DB-SYN | DB |  |  |  |  | 21 |  | 5 |  |  | BE 계정 시노님·권한·대상 객체 |
| A1 | GEN |  |  |  |  |  |  | 25 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| A6 | GEN |  |  |  |  |  | 21 | 3 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| X-LOC | GEN |  | 4 |  |  |  |  | 5 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| E4 | EDIT |  |  |  |  |  | 6 | 3 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| C1 | CASCADE |  |  |  |  |  | 8 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| B3 | COMBO |  |  |  | 3 |  |  | 4 |  |  | 콤보 후보 정렬 = AS-IS |
| B4 | COMBO |  |  |  |  | 3 |  | 4 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| G4 | DESIGN |  |  |  |  | 2 | 5 |  |  |  | 조회조건 표시·라벨·활성 |
| G1 | GEN |  |  |  |  |  | 2 | 4 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| G6 | GEN |  |  |  |  |  | 5 |  |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| H4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W2 구현 위치 확인 (4)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0055-0001 | X-LOC | EditButton(Edit) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EditButton(Edit)) |
| WK-SCP0055-0002 | X-LOC | ExcelButton(Excel) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (ExcelButton(Excel)) |
| WK-SCP0055-0003 | X-LOC | FindButton(Search) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (FindButton(Search)) |
| WK-SCP0055-0004 | X-LOC | SaveButton(Save) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SaveButton(Save)) |

## W4 검사기 구현 (3)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0055-0005 | B3 | cboBucketType / Bucket / Bucket Type | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 2 (ACT:SCP0055_Shipment_Allo_Report.GetDayR) |
| WK-SCP0055-0006 | B3 | cboDivision / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboDivision / Division | 있음(FE 소스) | 2 (ACT:SCP0055_Shipment_Allo_Report.GetDayR) |
| WK-SCP0055-0007 | B3 | cboPlanDate / Plan Date | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboPlanDate / Plan Date | 있음(FE 소스) | 2 (ACT:SCP0055_Shipment_Allo_Report.GetDayR) |

## W5 검사기 연결 (29)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0055-0008 | B4 | cboBucketType / Bucket / Bucket Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 2 (ACT:SCP0055_Shipment_Allo_Report.GetDayR) |
| WK-SCP0055-0009 | B4 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 2 (ACT:SCP0055_Shipment_Allo_Report.GetDayR) |
| WK-SCP0055-0010 | B4 | cboPlanDate / Plan Date | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboPlanDate / Plan Date | 있음(FE 소스) | 2 (ACT:SCP0055_Shipment_Allo_Report.GetDayR) |
| WK-SCP0055-0011 | F2 | SCP0055 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0055 화면 | 판단불가(대상 단위 SCREEN) | 54 (9 10 SaveButton(Save) ACT:SCP0055_Shipme) |
| WK-SCP0055-0012 | F6 | SCP0055 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0055 화면 | 판단불가(대상 단위 SCREEN) | 52 (9 ACT:SCP0055_Shipment_Allo_Report.SaveB) |
| WK-SCP0055-0013 | DB-SYN | DM0003_GET_BUCKET_TYPE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DM0003_GET_BUCKET_TYPE_CODE | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0055_Shipment_Allo_Report.GetBuck) |
| WK-SCP0055-0014 | DB-SYN | P_BIZ_TYPE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_BIZ_TYPE | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0055_Shipment_Allo_Report.Refresh) |
| WK-SCP0055-0015 | DB-SYN | P_CELL_TYPE_GR | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_CELL_TYPE_GR | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0055_Shipment_Allo_Report.Refresh) |
| WK-SCP0055-0016 | DB-SYN | P_DEPT_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DEPT_ID | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0055_Shipment_Allo_Report.Refresh) |
| WK-SCP0055-0017 | DB-SYN | P_DIVISION_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_DIVISION_ID | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0055_Shipment_Allo_Report.Refresh) |
| WK-SCP0055-0018 | DB-SYN | P_FCST_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_FCST_YN | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0055_Shipment_Allo_Report.Refresh) |
| WK-SCP0055-0019 | DB-SYN | P_FROMSITE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_FROMSITE | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0055_Shipment_Allo_Report.Refresh) |
| WK-SCP0055-0020 | DB-SYN | P_FROM_YYYYMMDD | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_FROM_YYYYMMDD | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0055_Shipment_Allo_Report.Refresh) |
| WK-SCP0055-0021 | DB-SYN | P_GAP_DATE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_GAP_DATE | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0055_Shipment_Allo_Report.Refresh) |
| WK-SCP0055-0022 | DB-SYN | P_ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_ITEM_ID | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0055_Shipment_Allo_Report.Refresh) |
| WK-SCP0055-0023 | DB-SYN | P_NICKNAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_NICKNAME | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0055_Shipment_Allo_Report.Refresh) |
| WK-SCP0055-0024 | DB-SYN | P_NICK_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_NICK_NAME | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0055_Shipment_Allo_Report.Refresh) |
| WK-SCP0055-0025 | DB-SYN | P_NOTE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_NOTE | 없음(PROC_M 대응 없음) | 1 (ACT:SCP0055_Shipment_Allo_Report.SaveDat) |
| WK-SCP0055-0026 | DB-SYN | P_PLAN_DATE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_PLAN_DATE | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0055_Shipment_Allo_Report.Refresh) |
| WK-SCP0055-0027 | DB-SYN | P_PLAN_START_YYYYMMDD | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_PLAN_START_YYYYMMDD | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0055_Shipment_Allo_Report.Refresh) |
| WK-SCP0055-0028 | DB-SYN | P_PROGRAM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_PROGRAM_ID | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0055_Shipment_Allo_Report.Refresh) |
| WK-SCP0055-0029 | DB-SYN | P_SHEET_NAME | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SHEET_NAME | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0055_Shipment_Allo_Report.Refresh) |
| WK-SCP0055-0030 | DB-SYN | P_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SITE_ID | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0055_Shipment_Allo_Report.Refresh) |
| WK-SCP0055-0031 | DB-SYN | P_TEAM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_TEAM_ID | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0055_Shipment_Allo_Report.Refresh) |
| WK-SCP0055-0032 | DB-SYN | P_TO_YYYYMMDD | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_TO_YYYYMMDD | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0055_Shipment_Allo_Report.Refresh) |
| WK-SCP0055-0033 | DB-SYN | P_USER_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_USER_ID | 없음(PROC_M 대응 없음) | 3 (ACT:SCP0055_Shipment_Allo_Report.Refresh) |
| WK-SCP0055-0034 | G4 | btnModel | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnModel | 없음 | 2 (ACT:SCP0055_Shipment_Allo_Report.InitEve) |
| WK-SCP0055-0035 | G4 | btnNickName | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnNickName | 없음 | 2 (ACT:SCP0055_Shipment_Allo_Report.InitEve) |
| WK-SCP0055-0036 | G03-WIRE | SCP0055 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0055 화면 | 판단불가(대상 단위 SCREEN) | 12 (ACT:SCP0055_Shipment_Allo_Report..ctor A) |

## W6 검증 실행 (78)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0055-0037 | J2 | SCP0055 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0055 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 36 (1 2 3 9 10 FindButton(Search) EditButton) |
| WK-SCP0055-0038 | C1 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0055_Shipment_Allo_Report.InitCon) |
| WK-SCP0055-0039 | C1 | cboCellTypeGr / Cell Type GR / Cell Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboCellTypeGr / Cell Type GR / Cell Type Gr · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0055_Shipment_Allo_Report.InitCon) |
| WK-SCP0055-0040 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0055_Shipment_Allo_Report.InitCon) |
| WK-SCP0055-0041 | C1 | cboGapDate / Gap Date | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboGapDate / Gap Date · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0055_Shipment_Allo_Report.Refresh) |
| WK-SCP0055-0042 | C1 | cboOperationGroup / Operation Group / Op | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboOperationGroup / Operation Group / Operation gr · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:SCP0055_Shipment_Allo_Report.InitCon) |
| WK-SCP0055-0043 | C1 | cboPlanDate / Plan Date | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboPlanDate / Plan Date · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0055_Shipment_Allo_Report.Refresh) |
| WK-SCP0055-0044 | C1 | clbFromSite / From Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbFromSite / From Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0055_Shipment_Allo_Report.Refresh) |
| WK-SCP0055-0045 | C1 | clbTeam / Team  / Team | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbTeam / Team  / Team · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0055_Shipment_Allo_Report.Refresh) |
| WK-SCP0055-0046 | K4 | SCP0055 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0055 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 28 (ACT:SCP0055_Shipment_Allo_Report.btnMode) |
| WK-SCP0055-0047 | F1 | SCP0055 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0055 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 54 (9 10 SaveButton(Save) ACT:SCP0055_Shipme) |
| WK-SCP0055-0048 | F4 | DM0003_GET_BUCKET_TYPE_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DM0003_GET_BUCKET_TYPE_CODE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:SCP0055_Shipment_Allo_Report.GetBuck) |
| WK-SCP0055-0049 | F4 | PKG_SCP0055.P_SCP0055_GET_SHIPMENT_ALLO_ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0055.P_SCP0055_GET_SHIPMENT_ALLO_NOTE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 |  | 84 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0050 | F4 | PKG_SCP0055.P_SCP0055_GET_SHIPMENT_ALLO_ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0055.P_SCP0055_GET_SHIPMENT_ALLO_PLAN · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 |  | 84 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0051 | F4 | PKG_SCP0055.P_SCP0055_SAVE_SHIPMENT_ALLO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0055.P_SCP0055_SAVE_SHIPMENT_ALLO_PLAN · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실 |  | 43 (ACT:SCP0055_Shipment_Allo_Report.SaveBut) |
| WK-SCP0055-0052 | F4 | P_BIZ_TYPE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_BIZ_TYPE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 83 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0053 | F4 | P_CELL_TYPE_GR | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_CELL_TYPE_GR · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 83 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0054 | F4 | P_DEPT_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DEPT_ID · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 85 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0055 | F4 | P_DIVISION_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_DIVISION_ID · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 83 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0056 | F4 | P_FCST_YN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_FCST_YN · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 83 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0057 | F4 | P_FROMSITE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_FROMSITE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 83 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0058 | F4 | P_FROM_YYYYMMDD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_FROM_YYYYMMDD · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 83 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0059 | F4 | P_GAP_DATE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_GAP_DATE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 85 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0060 | F4 | P_ITEM_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_ITEM_ID · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 83 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0061 | F4 | P_NICKNAME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_NICKNAME · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 83 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0062 | F4 | P_NICK_NAME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_NICK_NAME · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 85 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0063 | F4 | P_NOTE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_NOTE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 43 (ACT:SCP0055_Shipment_Allo_Report.SaveBut) |
| WK-SCP0055-0064 | F4 | P_PLAN_DATE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_PLAN_DATE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 85 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0065 | F4 | P_PLAN_START_YYYYMMDD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_PLAN_START_YYYYMMDD · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 83 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0066 | F4 | P_PROGRAM_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_PROGRAM_ID · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 85 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0067 | F4 | P_SHEET_NAME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_SHEET_NAME · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 83 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0068 | F4 | P_SITE_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_SITE_ID · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 85 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0069 | F4 | P_TEAM_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_TEAM_ID · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 83 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0070 | F4 | P_TO_YYYYMMDD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_TO_YYYYMMDD · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 83 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0071 | F4 | P_USER_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_USER_ID · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 86 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0072 | G4 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 6 (ACT:SCP0055_Shipment_Allo_Report.DefineP) |
| WK-SCP0055-0073 | G4 | cboCellTypeGr / Cell Type GR / Cell Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboCellTypeGr / Cell Type GR / Cell Type Gr · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0055_Shipment_Allo_Report.DefineP) |
| WK-SCP0055-0074 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0055_Shipment_Allo_Report.InitCon) |
| WK-SCP0055-0075 | G4 | cboOperationGroup / Operation Group / Op | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboOperationGroup / Operation Group / Operation gr · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0055_Shipment_Allo_Report.InitCon) |
| WK-SCP0055-0076 | G4 | cboPlanDate / Plan Date | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboPlanDate / Plan Date · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (ACT:SCP0055_Shipment_Allo_Report.InitCon) |
| WK-SCP0055-0077 | H4 | SCP0055 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — SCP0055 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 4 (ACT:SCP0055_Shipment_Allo_Report.SpdMain) |
| WK-SCP0055-0078 | I1 | SCP0055 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0055 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 16 (1 2 3 4-8 9 10 ACT:SCP0055_Shipment_Allo) |
| WK-SCP0055-0079 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (9 ACT:SCP0055_Shipment_Allo_Report.SaveD) |
| WK-SCP0055-0080 | E4 | MSG00100 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00100 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (10 ACT:SCP0055_Shipment_Allo_Report.Exce) |
| WK-SCP0055-0081 | E4 | MSG00344 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00344 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (1 ACT:SCP0055_Shipment_Allo_Report.FindD) |
| WK-SCP0055-0082 | E4 | MSG00345 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00345 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (2 ACT:SCP0055_Shipment_Allo_Report.FindD) |
| WK-SCP0055-0083 | E4 | MSG00348 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00348 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (3 ACT:SCP0055_Shipment_Allo_Report.FindD) |
| WK-SCP0055-0084 | E4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 7 (ACT:SCP0055_Shipment_Allo_Report.SetChan) |
| WK-SCP0055-0085 | A10 | SCP0055 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0055 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 90 (ACT:SCP0055_Shipment_Allo_Report.DefineP) |
| WK-SCP0055-0086 | A6 | PKG_SCP0055.P_SCP0055_GET_SHIPMENT_ALLO_ | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0055.P_SCP0055_GET_SHIPMENT_ALLO_NOTE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로  |  | 41 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0087 | A6 | PKG_SCP0055.P_SCP0055_GET_SHIPMENT_ALLO_ | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0055.P_SCP0055_GET_SHIPMENT_ALLO_PLAN · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로  |  | 41 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0088 | A6 | P_BIZ_TYPE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_BIZ_TYPE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 41 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0089 | A6 | P_CELL_TYPE_GR | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_CELL_TYPE_GR · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 41 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0090 | A6 | P_DEPT_ID | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_DEPT_ID · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 41 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0091 | A6 | P_DIVISION_ID | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_DIVISION_ID · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 41 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0092 | A6 | P_FCST_YN | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_FCST_YN · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 41 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0093 | A6 | P_FROMSITE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_FROMSITE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 41 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0094 | A6 | P_FROM_YYYYMMDD | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_FROM_YYYYMMDD · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 41 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0095 | A6 | P_GAP_DATE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_GAP_DATE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 41 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0096 | A6 | P_ITEM_ID | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_ITEM_ID · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 41 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0097 | A6 | P_NICKNAME | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_NICKNAME · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 41 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0098 | A6 | P_NICK_NAME | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_NICK_NAME · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 41 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0099 | A6 | P_PLAN_DATE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_PLAN_DATE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 41 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0100 | A6 | P_PLAN_START_YYYYMMDD | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_PLAN_START_YYYYMMDD · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trac |  | 41 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0101 | A6 | P_PROGRAM_ID | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_PROGRAM_ID · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 41 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0102 | A6 | P_SHEET_NAME | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_SHEET_NAME · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 41 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0103 | A6 | P_SITE_ID | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_SITE_ID · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 41 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0104 | A6 | P_TEAM_ID | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_TEAM_ID · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 41 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0105 | A6 | P_TO_YYYYMMDD | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_TO_YYYYMMDD · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 41 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0106 | A6 | P_USER_ID | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_USER_ID · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 41 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0107 | G1 | cboGapDate / Gap Date | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboGapDate / Gap Date · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0055_Shipment_Allo_Report.FindDat) |
| WK-SCP0055-0108 | G1 | cboPlanDate / Plan Date | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboPlanDate / Plan Date · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0055_Shipment_Allo_Report.FindDat) |
| WK-SCP0055-0109 | G6 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 6 (ACT:SCP0055_Shipment_Allo_Report.DefineP) |
| WK-SCP0055-0110 | G6 | cboCellTypeGr / Cell Type GR / Cell Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboCellTypeGr / Cell Type GR / Cell Type Gr · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCP0055_Shipment_Allo_Report.DefineP) |
| WK-SCP0055-0111 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCP0055_Shipment_Allo_Report.InitCon) |
| WK-SCP0055-0112 | G6 | cboOperationGroup / Operation Group / Op | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboOperationGroup / Operation Group / Operation gr · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCP0055_Shipment_Allo_Report.InitCon) |
| WK-SCP0055-0113 | G6 | cboPlanDate / Plan Date | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboPlanDate / Plan Date · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (ACT:SCP0055_Shipment_Allo_Report.InitCon) |
| WK-SCP0055-0114 | X-REOPEN | SCP0055 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0055 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 9 (ACT:SCP0055_Shipment_Allo_Report.Dispose) |

## W7 기대값 확정 (101)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0055-0115 | B3 | SCP0055_Shipment_Allo_Report.GetBucketTy | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0055_Shipment_Allo_Report.GetBucketType: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0055_Shipment_Allo_Report.GetBuck) |
| WK-SCP0055-0116 | B3 | SCP0055_Shipment_Allo_Report.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0055_Shipment_Allo_Report.GetDayRange: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0055_Shipment_Allo_Report.GetDayR) |
| WK-SCP0055-0117 | B3 | SCP0055_Shipment_Allo_Report.GetIsEditab | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0055_Shipment_Allo_Report.GetIsEditable: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0055_Shipment_Allo_Report.GetIsEd) |
| WK-SCP0055-0118 | B3 | SCP0055_Shipment_Allo_Report.Get_IsSaveY | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0055_Shipment_Allo_Report.Get_IsSaveYn: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0055_Shipment_Allo_Report.Get_IsS) |
| WK-SCP0055-0119 | B4 | SCP0055_Shipment_Allo_Report.GetBucketTy | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0055_Shipment_Allo_Report.GetBucketType: 진입점 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0055_Shipment_Allo_Report.GetBuck) |
| WK-SCP0055-0120 | B4 | SCP0055_Shipment_Allo_Report.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0055_Shipment_Allo_Report.GetDayRange: 진입점 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0055_Shipment_Allo_Report.GetDayR) |
| WK-SCP0055-0121 | B4 | SCP0055_Shipment_Allo_Report.GetIsEditab | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0055_Shipment_Allo_Report.GetIsEditable: 진입점 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0055_Shipment_Allo_Report.GetIsEd) |
| WK-SCP0055-0122 | B4 | SCP0055_Shipment_Allo_Report.Get_IsSaveY | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0055_Shipment_Allo_Report.Get_IsSaveYn: 진입점 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0055_Shipment_Allo_Report.Get_IsS) |
| WK-SCP0055-0123 | DB-SYN | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 1: 행 집계 — DB-SYN 24요소: NOPATH:21 · PASS:3 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-SCP0055-0124 | DB-SYN | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 2: 행 집계 — DB-SYN 24요소: NOPATH:21 · PASS:3 (미실행 요소가 남아 판정필요) |  | 1 (2) |
| WK-SCP0055-0125 | DB-SYN | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 3: 행 집계 — DB-SYN 24요소: NOPATH:21 · PASS:3 (미실행 요소가 남아 판정필요) |  | 1 (3) |
| WK-SCP0055-0126 | DB-SYN | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — 9: 행 집계 — DB-SYN 24요소: NOPATH:21 · PASS:3 (미실행 요소가 남아 판정필요) |  | 1 (9) |
| WK-SCP0055-0127 | DB-SYN | SCP0055_Shipment_Allo_Report.SCM_SYS_LOG | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SCP0055_Shipment_Allo_Report.SCM_SYS_LOG_BATCH: 진입점 집계 — DB-SYN 24요소: NOPATH:21 · PASS:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0055_Shipment_Allo_Report.SCM_SYS) |
| WK-SCP0055-0128 | F4 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 1: 행 집계 — F4 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-SCP0055-0129 | F4 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 2: 행 집계 — F4 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (2) |
| WK-SCP0055-0130 | F4 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 3: 행 집계 — F4 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (3) |
| WK-SCP0055-0131 | F4 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — 9: 행 집계 — F4 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 1 (9) |
| WK-SCP0055-0132 | F4 | SCP0055_Shipment_Allo_Report.SCM_SYS_LOG | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0055_Shipment_Allo_Report.SCM_SYS_LOG_BATCH: 진입점 집계 — F4 24요소: NOT_RUN:24 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0055_Shipment_Allo_Report.SCM_SYS) |
| WK-SCP0055-0133 | E4 | 4-8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 4-8: 행 집계 — E4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (4-8) |
| WK-SCP0055-0134 | E4 | SCP0055_Shipment_Allo_Report.SetChangedC | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0055_Shipment_Allo_Report.SetChangedControl: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0055_Shipment_Allo_Report.SetChan) |
| WK-SCP0055-0135 | E4 | SCP0055_Shipment_Allo_Report.SetSpreadIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0055_Shipment_Allo_Report.SetSpreadInit: 진입점 집계 — E4 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0055_Shipment_Allo_Report.SetSpre) |
| WK-SCP0055-0136 | A1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1: 행 집계 — A1 21요소: REVIEW:21 |  | 1 (1) |
| WK-SCP0055-0137 | A1 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 2: 행 집계 — A1 21요소: REVIEW:21 |  | 1 (2) |
| WK-SCP0055-0138 | A1 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 3: 행 집계 — A1 21요소: REVIEW:21 |  | 1 (3) |
| WK-SCP0055-0139 | A1 | FindButton(Search) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindButton(Search): 행 집계 — A1 21요소: REVIEW:21 |  | 1 (FindButton(Search)) |
| WK-SCP0055-0140 | A1 | PKG_SCP0055.P_SCP0055_GET_SHIPMENT_ALLO_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0055.P_SCP0055_GET_SHIPMENT_ALLO_NOTE: 골든 비교 케이스 없음(PKG_SCP0055.P_SCP0055_GET_SHIPMENT_ALLO_NOTE — 팝업·보조 SP 는 g |  | 41 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0141 | A1 | PKG_SCP0055.P_SCP0055_GET_SHIPMENT_ALLO_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0055.P_SCP0055_GET_SHIPMENT_ALLO_PLAN: 골든 비교 케이스 없음(PKG_SCP0055.P_SCP0055_GET_SHIPMENT_ALLO_PLAN — 팝업·보조 SP 는 g |  | 41 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0142 | A1 | P_BIZ_TYPE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_BIZ_TYPE: 골든 비교 케이스 없음(P_BIZ_TYPE — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 41 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0143 | A1 | P_CELL_TYPE_GR | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_CELL_TYPE_GR: 골든 비교 케이스 없음(P_CELL_TYPE_GR — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 41 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0144 | A1 | P_DEPT_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_DEPT_ID: 골든 비교 케이스 없음(P_DEPT_ID — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 41 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0145 | A1 | P_DIVISION_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_DIVISION_ID: 골든 비교 케이스 없음(P_DIVISION_ID — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 41 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0146 | A1 | P_FCST_YN | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_FCST_YN: 골든 비교 케이스 없음(P_FCST_YN — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 41 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0147 | A1 | P_FROMSITE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_FROMSITE: 골든 비교 케이스 없음(P_FROMSITE — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 41 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0148 | A1 | P_FROM_YYYYMMDD | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_FROM_YYYYMMDD: 골든 비교 케이스 없음(P_FROM_YYYYMMDD — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 41 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0149 | A1 | P_GAP_DATE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_GAP_DATE: 골든 비교 케이스 없음(P_GAP_DATE — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 41 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0150 | A1 | P_ITEM_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_ITEM_ID: 골든 비교 케이스 없음(P_ITEM_ID — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 41 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0151 | A1 | P_NICKNAME | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_NICKNAME: 골든 비교 케이스 없음(P_NICKNAME — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 41 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0152 | A1 | P_NICK_NAME | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_NICK_NAME: 골든 비교 케이스 없음(P_NICK_NAME — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 41 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0153 | A1 | P_PLAN_DATE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_PLAN_DATE: 골든 비교 케이스 없음(P_PLAN_DATE — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 41 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0154 | A1 | P_PLAN_START_YYYYMMDD | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_PLAN_START_YYYYMMDD: 골든 비교 케이스 없음(P_PLAN_START_YYYYMMDD — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 41 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0155 | A1 | P_PROGRAM_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_PROGRAM_ID: 골든 비교 케이스 없음(P_PROGRAM_ID — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 41 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0156 | A1 | P_SHEET_NAME | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_SHEET_NAME: 골든 비교 케이스 없음(P_SHEET_NAME — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 41 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0157 | A1 | P_SITE_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_SITE_ID: 골든 비교 케이스 없음(P_SITE_ID — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 41 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0158 | A1 | P_TEAM_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_TEAM_ID: 골든 비교 케이스 없음(P_TEAM_ID — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 41 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0159 | A1 | P_TO_YYYYMMDD | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_TO_YYYYMMDD: 골든 비교 케이스 없음(P_TO_YYYYMMDD — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 41 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0160 | A1 | P_USER_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_USER_ID: 골든 비교 케이스 없음(P_USER_ID — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 41 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0161 | A6 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 1: 행 집계 — A6 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-SCP0055-0162 | A6 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 2: 행 집계 — A6 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (2) |
| WK-SCP0055-0163 | A6 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — 3: 행 집계 — A6 21요소: NOT_RUN:21 (미실행 요소가 남아 판정필요) |  | 1 (3) |
| WK-SCP0055-0164 | G1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 1: 행 집계 — G1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-SCP0055-0165 | G1 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 2: 행 집계 — G1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (2) |
| WK-SCP0055-0166 | G1 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 3: 행 집계 — G1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (3) |
| WK-SCP0055-0167 | G1 | FindButton(Search) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — FindButton(Search): 행 집계 — G1 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (FindButton(Search)) |
| WK-SCP0055-0168 | X-LOC | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 10: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (10) |
| WK-SCP0055-0169 | X-LOC | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (2) |
| WK-SCP0055-0170 | X-LOC | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (3) |
| WK-SCP0055-0171 | X-LOC | 4-8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 4-8: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (4-8) |
| WK-SCP0055-0172 | X-LOC | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 9: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (9) |
| WK-SCP0055-0173 | X-ROW | ExcelButton(Excel) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — ExcelButton(Excel): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (ExcelButton(Excel)) |
| WK-SCP0055-0174 | X-ROW | SCP0055_Shipment_Allo_Report.CboBizType_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0055_Shipment_Allo_Report.CboBizType_SelectedIn: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0055_Shipment_Allo_Report.CboBizT) |
| WK-SCP0055-0175 | X-ROW | SCP0055_Shipment_Allo_Report.CboDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0055_Shipment_Allo_Report.CboDivision_SelectedI: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0055_Shipment_Allo_Report.CboDivi) |
| WK-SCP0055-0176 | X-ROW | SCP0055_Shipment_Allo_Report.CboPlanDate | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0055_Shipment_Allo_Report.CboPlanDate_SelectedI: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0055_Shipment_Allo_Report.CboPlan) |
| WK-SCP0055-0177 | X-ROW | SCP0055_Shipment_Allo_Report.CboPlanType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0055_Shipment_Allo_Report.CboPlanType_SelectedI: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0055_Shipment_Allo_Report.CboPlan) |
| WK-SCP0055-0178 | X-ROW | SCP0055_Shipment_Allo_Report.CreateSprea | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0055_Shipment_Allo_Report.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0055_Shipment_Allo_Report.CreateS) |
| WK-SCP0055-0179 | X-ROW | SCP0055_Shipment_Allo_Report.DefinePrope | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0055_Shipment_Allo_Report.DefineProperty: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0055_Shipment_Allo_Report.DefineP) |
| WK-SCP0055-0180 | X-ROW | SCP0055_Shipment_Allo_Report.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0055_Shipment_Allo_Report.EditButton: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0055_Shipment_Allo_Report.EditBut) |
| WK-SCP0055-0181 | X-ROW | SCP0055_Shipment_Allo_Report.ElectrodeDa | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0055_Shipment_Allo_Report.ElectrodeDashReplace: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/LOCAL/RETURN, 연결된 요소 검사 없 |  | 7 (ACT:SCP0055_Shipment_Allo_Report.Electro) |
| WK-SCP0055-0182 | X-ROW | SCP0055_Shipment_Allo_Report.ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0055_Shipment_Allo_Report.ExcelButton: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SCP0055_Shipment_Allo_Report.ExcelBu) |
| WK-SCP0055-0183 | X-ROW | SCP0055_Shipment_Allo_Report.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0055_Shipment_Allo_Report.FindButton: 진입점 집계 63검사 — NOT_RUN:42 · REVIEW:21 |  | 1 (ACT:SCP0055_Shipment_Allo_Report.FindBut) |
| WK-SCP0055-0184 | X-ROW | SCP0055_Shipment_Allo_Report.FindData_Ma | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0055_Shipment_Allo_Report.FindData_Main: 진입점 집계 69검사 — NOT_RUN:48 · REVIEW:21 |  | 5 (ACT:SCP0055_Shipment_Allo_Report.FindDat) |
| WK-SCP0055-0185 | X-ROW | SCP0055_Shipment_Allo_Report.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0055_Shipment_Allo_Report.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0055_Shipment_Allo_Report.Form_Lo) |
| WK-SCP0055-0186 | X-ROW | SCP0055_Shipment_Allo_Report.GetBucketTy | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0055_Shipment_Allo_Report.GetBucketType: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0055_Shipment_Allo_Report.GetBuck) |
| WK-SCP0055-0187 | X-ROW | SCP0055_Shipment_Allo_Report.GetIsEditab | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0055_Shipment_Allo_Report.GetIsEditable: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0055_Shipment_Allo_Report.GetIsEd) |
| WK-SCP0055-0188 | X-ROW | SCP0055_Shipment_Allo_Report.Get_IsSaveY | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0055_Shipment_Allo_Report.Get_IsSaveYn: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0055_Shipment_Allo_Report.Get_IsS) |
| WK-SCP0055-0189 | X-ROW | SCP0055_Shipment_Allo_Report.InitControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0055_Shipment_Allo_Report.InitControls: 진입점 집계 15검사 — NOT_RUN:15 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SCP0055_Shipment_Allo_Report.InitCon) |
| WK-SCP0055-0190 | X-ROW | SCP0055_Shipment_Allo_Report.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0055_Shipment_Allo_Report.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0055_Shipment_Allo_Report.InitSpr) |
| WK-SCP0055-0191 | X-ROW | SCP0055_Shipment_Allo_Report.InitSpreadD | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0055_Shipment_Allo_Report.InitSpreadDateColumn: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 34 (ACT:SCP0055_Shipment_Allo_Report.InitSpr) |
| WK-SCP0055-0192 | X-ROW | SCP0055_Shipment_Allo_Report.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0055_Shipment_Allo_Report.InsertRow: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/LOCAL, 연결된 요소 검사 없음 |  | 3 (ACT:SCP0055_Shipment_Allo_Report.InsertR) |
| WK-SCP0055-0193 | X-ROW | SCP0055_Shipment_Allo_Report.MergeGrid | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0055_Shipment_Allo_Report.MergeGrid: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 47 (ACT:SCP0055_Shipment_Allo_Report.MergeGr) |
| WK-SCP0055-0194 | X-ROW | SCP0055_Shipment_Allo_Report.OnShown | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0055_Shipment_Allo_Report.OnShown: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY/STATE, 연결된 요소 검사 없음 |  | 10 (ACT:SCP0055_Shipment_Allo_Report.OnShown) |
| WK-SCP0055-0195 | X-ROW | SCP0055_Shipment_Allo_Report.RefreshFrom | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0055_Shipment_Allo_Report.RefreshFromSite: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SCP0055_Shipment_Allo_Report.Refresh) |
| WK-SCP0055-0196 | X-ROW | SCP0055_Shipment_Allo_Report.RefreshGapD | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0055_Shipment_Allo_Report.RefreshGapDate: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0055_Shipment_Allo_Report.Refresh) |
| WK-SCP0055-0197 | X-ROW | SCP0055_Shipment_Allo_Report.RefreshGrid | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0055_Shipment_Allo_Report.RefreshGrid: 진입점 집계 32검사 — NOT_RUN:17 · NOPATH:14 · PASS:1 (미실행 검사가 남아 판정필요) |  | 151 (ACT:SCP0055_Shipment_Allo_Report.Refresh) |
| WK-SCP0055-0198 | X-ROW | SCP0055_Shipment_Allo_Report.RefreshGrid | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0055_Shipment_Allo_Report.RefreshGridGAP: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 76 (ACT:SCP0055_Shipment_Allo_Report.Refresh) |
| WK-SCP0055-0199 | X-ROW | SCP0055_Shipment_Allo_Report.RefreshNote | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0055_Shipment_Allo_Report.RefreshNote: 진입점 집계 15검사 — NOT_RUN:8 · NOPATH:6 · PASS:1 (미실행 검사가 남아 판정필요) |  | 45 (ACT:SCP0055_Shipment_Allo_Report.Refresh) |
| WK-SCP0055-0200 | X-ROW | SCP0055_Shipment_Allo_Report.RefreshOper | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0055_Shipment_Allo_Report.RefreshOperationGroup: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SCP0055_Shipment_Allo_Report.Refresh) |
| WK-SCP0055-0201 | X-ROW | SCP0055_Shipment_Allo_Report.RefreshPlan | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0055_Shipment_Allo_Report.RefreshPlanDate: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0055_Shipment_Allo_Report.Refresh) |
| WK-SCP0055-0202 | X-ROW | SCP0055_Shipment_Allo_Report.RefreshTeam | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0055_Shipment_Allo_Report.RefreshTeam: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SCP0055_Shipment_Allo_Report.Refresh) |
| WK-SCP0055-0203 | X-ROW | SCP0055_Shipment_Allo_Report.RetIntValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0055_Shipment_Allo_Report.RetIntValue: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/EXPR/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 5 (ACT:SCP0055_Shipment_Allo_Report.RetIntV) |
| WK-SCP0055-0204 | X-ROW | SCP0055_Shipment_Allo_Report.SCM_SYS_LOG | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0055_Shipment_Allo_Report.SCM_SYS_LOG_BATCH: 진입점 집계 3검사 — NOT_RUN:2 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 12 (ACT:SCP0055_Shipment_Allo_Report.SCM_SYS) |
| WK-SCP0055-0205 | X-ROW | SCP0055_Shipment_Allo_Report.SaveData_Ma | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0055_Shipment_Allo_Report.SaveData_Main: 진입점 집계 52검사 — NOT_RUN:27 · NOPATH:22 · PASS:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0055_Shipment_Allo_Report.SaveDat) |
| WK-SCP0055-0206 | X-ROW | SCP0055_Shipment_Allo_Report.SelectCombo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0055_Shipment_Allo_Report.SelectCombo: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/FLOW/LOCAL/VALUE_SET, 연결된 요소  |  | 10 (ACT:SCP0055_Shipment_Allo_Report.SelectC) |
| WK-SCP0055-0207 | X-ROW | SCP0055_Shipment_Allo_Report.SetChangedC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0055_Shipment_Allo_Report.SetChangedControl: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0055_Shipment_Allo_Report.SetChan) |
| WK-SCP0055-0208 | X-ROW | SCP0055_Shipment_Allo_Report.SetSpreadIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0055_Shipment_Allo_Report.SetSpreadInit: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0055_Shipment_Allo_Report.SetSpre) |
| WK-SCP0055-0209 | X-ROW | SCP0055_Shipment_Allo_Report.SpdMain_Top | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0055_Shipment_Allo_Report.SpdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0055_Shipment_Allo_Report.SpdMain) |
| WK-SCP0055-0210 | X-ROW | SCP0055_Shipment_Allo_Report.btnModel_ID | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0055_Shipment_Allo_Report.btnModel_ID_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0055_Shipment_Allo_Report.btnMode) |
| WK-SCP0055-0211 | X-ROW | SCP0055_Shipment_Allo_Report.btnNickName | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0055_Shipment_Allo_Report.btnNickName_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0055_Shipment_Allo_Report.btnNick) |
| WK-SCP0055-0212 | X-ROW | SCP0055_Shipment_Allo_Report.cboBucketTy | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0055_Shipment_Allo_Report.cboBucketType_Selecte: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0055_Shipment_Allo_Report.cboBuck) |
| WK-SCP0055-0213 | X-ROW | SCP0055_Shipment_Allo_Report.cboPlanDate | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0055_Shipment_Allo_Report.cboPlanDate_SelectedI: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0055_Shipment_Allo_Report.cboPlan) |
| WK-SCP0055-0214 | X-ROW | SCP0055_Shipment_Allo_Report.chkSum_Chec | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0055_Shipment_Allo_Report.chkSum_CheckedChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0055_Shipment_Allo_Report.chkSum_) |
| WK-SCP0055-0215 | X-ROW | SCP0055_Shipment_Allo_Report.clbTeam_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0055_Shipment_Allo_Report.clbTeam_SelectedIndex: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0055_Shipment_Allo_Report.clbTeam) |
