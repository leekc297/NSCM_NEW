# 작업 원장 — SCP0133 · 2026-10-26 12:55

> 검사 인스턴스 184건 중 PASS·NA 12건 외 **172건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W5 | 검사기 연결 | 10 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 89 | 실행 → PASS |
| W7 | 기대값 확정 | 73 | 기대 확정 → PASS/FAIL |

- 담당: E2E 89 · 사람 판정 / AS-IS 원문 확인 → 재판정 73 · 하네스 10
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 4건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 39 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| C3 | CASCADE |  |  |  |  |  | 9 | 10 |  |  | 연쇄 자동 채움 |
| E4 | EDIT |  |  |  |  |  | 10 | 5 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| C2 | CASCADE |  |  |  |  |  | 7 | 5 |  |  | 그리드 셀 cascade 후보 |
| C6 | CASCADE |  |  |  |  |  | 7 | 5 |  |  | 무변경 편집 종료 시 연쇄 미발동 |
| E1 | EDIT |  |  |  |  |  | 7 |  |  |  | 숫자 소수자리·정수·부호·범위 |
| G1 | GEN |  |  |  |  |  | 7 |  |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| C1 | CASCADE |  |  |  |  |  | 6 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| F4 | DB |  |  |  |  |  | 5 |  |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| D1 | EDIT |  |  |  |  |  | 4 | 1 |  |  | 컬럼 편집 가능 여부(신규행·기존행) |
| D3 | EDIT |  |  |  |  |  | 4 | 1 |  |  | 행 값 기반 조건부 잠금 |
| G4 | DESIGN |  |  |  |  | 1 | 3 |  |  |  | 조회조건 표시·라벨·활성 |
| M4 | POPUP |  |  |  |  |  | 3 | 1 |  |  | 팝업 선택값 반영 |
| DB-SYN | DB |  |  |  |  | 3 |  |  |  |  | BE 계정 시노님·권한·대상 객체 |
| G5 | POPUP |  |  |  |  | 2 |  | 1 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 1 | 1 | 1 |  |  | 팝업 표준·열림 |
| A5 | DESIGN |  |  |  |  |  | 1 | 2 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| G6 | GEN |  |  |  |  |  | 3 |  |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| A6 | GEN |  |  |  |  |  | 2 |  |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| A1 | GEN |  |  |  |  |  |  | 2 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F3 | CRUD |  |  |  |  |  | 1 |  |  |  | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| H4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |

## W5 검사기 연결 (10)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0133-0001 | F2 | SCP0133 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0133 화면 | 판단불가(대상 단위 SCREEN) | 244 (ACT:SCP0133_WarehouseCapacity.SaveButton) |
| WK-SCP0133-0002 | F6 | SCP0133 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0133 화면 | 판단불가(대상 단위 SCREEN) | 244 (ACT:SCP0133_WarehouseCapacity.SaveButton) |
| WK-SCP0133-0003 | DB-SYN | SCP0133_GET_SEARCH_INFO | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0133_GET_SEARCH_INFO | 없음(PROC_M 대응 없음) | 3 (ACT:SCP0133_WarehouseCapacity.GetSearchI) |
| WK-SCP0133-0004 | DB-SYN | SCP0133_GET_WAREHOUSE_ITEM_MAPPING | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0133_GET_WAREHOUSE_ITEM_MAPPING | 없음(PROC_M 대응 없음) | 5 (ACT:SCP0133_WarehouseCapacity.FindData_M) |
| WK-SCP0133-0005 | DB-SYN | SCP0133_SAVE_WAREHOUSE_ITEM_MAPPING | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0133_SAVE_WAREHOUSE_ITEM_MAPPING | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0133_WarehouseCapacity.SaveData_I) |
| WK-SCP0133-0006 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 없음 | 5 (ACT:SCP0133_WarehouseCapacity.InitContro) |
| WK-SCP0133-0007 | G03-WIRE | SCP0133 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0133 화면 | 판단불가(대상 단위 SCREEN) | 20 (ACT:SCP0133_WarehouseCapacity..ctor ACT:) |
| WK-SCP0133-0008 | G5 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 16 (ACT:SCP0133_WarehouseCapacity.SpdMain_Ce) |
| WK-SCP0133-0009 | G5 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 2 (ACT:SCP0133_WarehouseCapacity.SpdMain_Ce) |
| WK-SCP0133-0010 | H6 | ITEM_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL ITEM_ID | 있음(SHEET_COLUMNS) | 16 (ACT:SCP0133_WarehouseCapacity.SpdMain_Ce) |

## W6 검증 실행 (89)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0133-0011 | J2 | SCP0133 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0133 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 12 (ACT:SCP0133_WarehouseCapacity.btnItemId_) |
| WK-SCP0133-0012 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0133_WarehouseCapacity.InitContro) |
| WK-SCP0133-0013 | C1 | cboStage / Stage | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboStage / Stage · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0133_WarehouseCapacity.RefreshSta) |
| WK-SCP0133-0014 | C1 | cboValid / Valid / Active | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboValid / Valid / Active · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0133_WarehouseCapacity.InitContro) |
| WK-SCP0133-0015 | C1 | clbPlanGroup / Plan Group | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbPlanGroup / Plan Group · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0133_WarehouseCapacity.RefreshPla) |
| WK-SCP0133-0016 | C1 | clbSite / SCM Site / Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbSite / SCM Site / Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:SCP0133_WarehouseCapacity.RefreshSit) |
| WK-SCP0133-0017 | C1 | clbWarehouse / Name / Warehouse / WH Nam | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbWarehouse / Name / Warehouse / WH Name · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0133_WarehouseCapacity.RefreshWar) |
| WK-SCP0133-0018 | C2 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0133_WarehouseCapacity.SpdMain_Co) |
| WK-SCP0133-0019 | C2 | OPMZ_PLAN_GR_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — OPMZ_PLAN_GR_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 9 (ACT:SCP0133_WarehouseCapacity.SpdMain_Co) |
| WK-SCP0133-0020 | C2 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 9 (ACT:SCP0133_WarehouseCapacity.SpdMain_Co) |
| WK-SCP0133-0021 | C2 | STAGE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — STAGE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 5 (ACT:SCP0133_WarehouseCapacity.SpdMain_Co) |
| WK-SCP0133-0022 | C2 | STOR_LOC | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — STOR_LOC · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0133_WarehouseCapacity.SpdMain_Co) |
| WK-SCP0133-0023 | C2 | STOR_LOC_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — STOR_LOC_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0133_WarehouseCapacity.SpdMain_Co) |
| WK-SCP0133-0024 | C2 | WH_NM | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — WH_NM · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 22 (ACT:SCP0133_WarehouseCapacity.SpdMain_Co) |
| WK-SCP0133-0025 | C3 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 8 (ACT:SCP0133_WarehouseCapacity.SpdMain_Cl) |
| WK-SCP0133-0026 | C3 | ITEM_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCP0133_WarehouseCapacity.SpdMain_Ce) |
| WK-SCP0133-0027 | C3 | MAX_CAPA | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — MAX_CAPA · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:SCP0133_WarehouseCapacity.CheckDigit) |
| WK-SCP0133-0028 | C3 | OPMZ_PLAN_GR_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — OPMZ_PLAN_GR_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 9 (ACT:SCP0133_WarehouseCapacity.SpdMain_Cl) |
| WK-SCP0133-0029 | C3 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 8 (ACT:SCP0133_WarehouseCapacity.SpdMain_Cl) |
| WK-SCP0133-0030 | C3 | STAGE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — STAGE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 8 (ACT:SCP0133_WarehouseCapacity.SpdMain_Cl) |
| WK-SCP0133-0031 | C3 | STOR_LOC | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — STOR_LOC · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:SCP0133_WarehouseCapacity.SpdMain_Cl) |
| WK-SCP0133-0032 | C3 | STOR_LOC_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — STOR_LOC_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 10 (ACT:SCP0133_WarehouseCapacity.SetVisible) |
| WK-SCP0133-0033 | C3 | WH_NM | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — WH_NM · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 24 (ACT:SCP0133_WarehouseCapacity.SpdMain_Cl) |
| WK-SCP0133-0034 | C6 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0133_WarehouseCapacity.SpdMain_Co) |
| WK-SCP0133-0035 | C6 | OPMZ_PLAN_GR_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — OPMZ_PLAN_GR_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCP0133_WarehouseCapacity.SpdMain_Co) |
| WK-SCP0133-0036 | C6 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0133_WarehouseCapacity.SpdMain_Co) |
| WK-SCP0133-0037 | C6 | STAGE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — STAGE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:SCP0133_WarehouseCapacity.SpdMain_Co) |
| WK-SCP0133-0038 | C6 | STOR_LOC | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — STOR_LOC · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0133_WarehouseCapacity.SpdMain_Co) |
| WK-SCP0133-0039 | C6 | STOR_LOC_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — STOR_LOC_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:SCP0133_WarehouseCapacity.SpdMain_Co) |
| WK-SCP0133-0040 | C6 | WH_NM | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — WH_NM · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 21 (ACT:SCP0133_WarehouseCapacity.SpdMain_Co) |
| WK-SCP0133-0041 | K4 | SCP0133 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0133 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 12 (ACT:SCP0133_WarehouseCapacity.btnItemId_) |
| WK-SCP0133-0042 | F1 | SCP0133 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0133 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 249 (ACT:SCP0133_WarehouseCapacity.DeleteButt) |
| WK-SCP0133-0043 | F3 | SCP0133 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F3 실행 — SCP0133 화면 · 검사기 있음(_trace.spec(@trace) W4b 붙여넣기 — Ctrl+C/Ctrl+V 로 셀 값 복사 후 값·연쇄) — 실행 필요: trace |  | 29 (ACT:SCP0133_WarehouseCapacity.SpdMain_Cl) |
| WK-SCP0133-0044 | F5 | SCP0133 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0133 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 5 (ACT:SCP0133_WarehouseCapacity.DeleteButt) |
| WK-SCP0133-0045 | F4 | PKG_SCP0133.P_SCP0133_GET_WAREHOUSE_CAPA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0133.P_SCP0133_GET_WAREHOUSE_CAPACITY · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 |  | 304 (ACT:SCP0133_WarehouseCapacity.FindButton) |
| WK-SCP0133-0046 | F4 | PKG_SCP0133.P_SCP0133_SAVE_WAREHOUSE_CAP | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0133.P_SCP0133_SAVE_WAREHOUSE_CAPACITY · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실 |  | 135 (ACT:SCP0133_WarehouseCapacity.SaveButton) |
| WK-SCP0133-0047 | F4 | SCP0133_GET_SEARCH_INFO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0133_GET_SEARCH_INFO · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 136 (ACT:SCP0133_WarehouseCapacity.GetSearchI) |
| WK-SCP0133-0048 | F4 | SCP0133_GET_WAREHOUSE_ITEM_MAPPING | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0133_GET_WAREHOUSE_ITEM_MAPPING · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke |  | 304 (ACT:SCP0133_WarehouseCapacity.FindButton) |
| WK-SCP0133-0049 | F4 | SCP0133_SAVE_WAREHOUSE_ITEM_MAPPING | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0133_SAVE_WAREHOUSE_ITEM_MAPPING · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smok |  | 114 (ACT:SCP0133_WarehouseCapacity.SaveButton) |
| WK-SCP0133-0050 | A5 | ITEM_ID | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ITEM_ID · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 1 (ACT:SCP0133_WarehouseCapacity.SpdMain_Ce) |
| WK-SCP0133-0051 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0133_WarehouseCapacity.InitContro) |
| WK-SCP0133-0052 | G4 | cboValid / Valid / Active | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboValid / Valid / Active · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0133_WarehouseCapacity.InitContro) |
| WK-SCP0133-0053 | G4 | clbPlanGroup / Plan Group | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbPlanGroup / Plan Group · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0133_WarehouseCapacity.InitEvent ) |
| WK-SCP0133-0054 | H4 | SCP0133 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — SCP0133 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 4 (ACT:SCP0133_WarehouseCapacity.SpdMain_To) |
| WK-SCP0133-0055 | I1 | SCP0133 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0133 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 14 (ACT:SCP0133_WarehouseCapacity.SaveData_I) |
| WK-SCP0133-0056 | D1 | CREATED_BY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — CREATED_BY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 4 (ACT:SCP0133_WarehouseCapacity.EditButton) |
| WK-SCP0133-0057 | D1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 5 (ACT:SCP0133_WarehouseCapacity.EditButton) |
| WK-SCP0133-0058 | D1 | LAST_UPDATE_DATE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — LAST_UPDATE_DATE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 2 (ACT:SCP0133_WarehouseCapacity.Insert_Row) |
| WK-SCP0133-0059 | D1 | PRE_KEY_VALUES | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D1 실행 — PRE_KEY_VALUES · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace |  | 1 (ACT:SCP0133_WarehouseCapacity.EditButton) |
| WK-SCP0133-0060 | D3 | CREATED_BY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CREATED_BY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:SCP0133_WarehouseCapacity.EditButton) |
| WK-SCP0133-0061 | D3 | DIVISION_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DIVISION_ID · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 5 (ACT:SCP0133_WarehouseCapacity.EditButton) |
| WK-SCP0133-0062 | D3 | LAST_UPDATE_DATE | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — LAST_UPDATE_DATE · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:SCP0133_WarehouseCapacity.Insert_Row) |
| WK-SCP0133-0063 | D3 | PRE_KEY_VALUES | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — PRE_KEY_VALUES · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:SCP0133_WarehouseCapacity.EditButton) |
| WK-SCP0133-0064 | D6 | SCP0133 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0133 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 2 (ACT:SCP0133_WarehouseCapacity.InsertButt) |
| WK-SCP0133-0065 | E1 | DIVISION_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — DIVISION_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 4 (ACT:SCP0133_WarehouseCapacity.SpdMain_Cl) |
| WK-SCP0133-0066 | E1 | OPMZ_PLAN_GR_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — OPMZ_PLAN_GR_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 6 (ACT:SCP0133_WarehouseCapacity.SpdMain_Cl) |
| WK-SCP0133-0067 | E1 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 4 (ACT:SCP0133_WarehouseCapacity.SpdMain_Cl) |
| WK-SCP0133-0068 | E1 | STAGE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — STAGE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 4 (ACT:SCP0133_WarehouseCapacity.SpdMain_Cl) |
| WK-SCP0133-0069 | E1 | STOR_LOC | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — STOR_LOC · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 2 (ACT:SCP0133_WarehouseCapacity.SpdMain_Cl) |
| WK-SCP0133-0070 | E1 | STOR_LOC_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — STOR_LOC_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 3 (ACT:SCP0133_WarehouseCapacity.SpdMain_Cl) |
| WK-SCP0133-0071 | E1 | WH_NM | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | E1 실행 — WH_NM · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(cell_rules)) — 실행 필요: trace |  | 3 (ACT:SCP0133_WarehouseCapacity.SpdMain_Cl) |
| WK-SCP0133-0072 | E4 | MSG00001 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00001 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0133_WarehouseCapacity.SaveData_I) |
| WK-SCP0133-0073 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0133_WarehouseCapacity.SaveData_I) |
| WK-SCP0133-0074 | E4 | MSG00046 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00046 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0133_WarehouseCapacity.SaveData_W) |
| WK-SCP0133-0075 | E4 | MSG00085 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00085 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0133_WarehouseCapacity.ValidateUs) |
| WK-SCP0133-0076 | E4 | MSG00129 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00129 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0133_WarehouseCapacity.spdSub_Act) |
| WK-SCP0133-0077 | E4 | MSG00160 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00160 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0133_WarehouseCapacity.ValidateUs) |
| WK-SCP0133-0078 | E4 | MSG00193 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00193 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0133_WarehouseCapacity.ValidateUs) |
| WK-SCP0133-0079 | E4 | MSG00219 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00219 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0133_WarehouseCapacity.SaveData_W) |
| WK-SCP0133-0080 | E4 | STOR_LOC_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — STOR_LOC_NAME · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (ACT:SCP0133_WarehouseCapacity.SetVisible) |
| WK-SCP0133-0081 | E4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 2 (ACT:SCP0133_WarehouseCapacity.SetVisible) |
| WK-SCP0133-0082 | A10 | SCP0133 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0133 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 81 (ACT:SCP0133_WarehouseCapacity.DefineProp) |
| WK-SCP0133-0083 | A6 | PKG_SCP0133.P_SCP0133_GET_WAREHOUSE_CAPA | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0133.P_SCP0133_GET_WAREHOUSE_CAPACITY · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로  |  | 62 (ACT:SCP0133_WarehouseCapacity.FindButton) |
| WK-SCP0133-0084 | A6 | SCP0133_GET_WAREHOUSE_ITEM_MAPPING | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SCP0133_GET_WAREHOUSE_ITEM_MAPPING · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _tra |  | 62 (ACT:SCP0133_WarehouseCapacity.FindButton) |
| WK-SCP0133-0085 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0133_WarehouseCapacity.FindData_M) |
| WK-SCP0133-0086 | G1 | cboStage / Stage | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboStage / Stage · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0133_WarehouseCapacity.FindData_M) |
| WK-SCP0133-0087 | G1 | cboValid / Valid / Active | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboValid / Valid / Active · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0133_WarehouseCapacity.FindData_M) |
| WK-SCP0133-0088 | G1 | clbPlanGroup / Plan Group | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbPlanGroup / Plan Group · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0133_WarehouseCapacity.FindData_M) |
| WK-SCP0133-0089 | G1 | clbSite / SCM Site / Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbSite / SCM Site / Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0133_WarehouseCapacity.FindData_M) |
| WK-SCP0133-0090 | G1 | clbWarehouse / Name / Warehouse / WH Nam | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbWarehouse / Name / Warehouse / WH Name · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (ACT:SCP0133_WarehouseCapacity.FindData_M) |
| WK-SCP0133-0091 | G1 | txtItemId / Model / Item Id / Model/Nick | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemId / Model / Item Id / Model/Nickname · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0133_WarehouseCapacity.FindData_M) |
| WK-SCP0133-0092 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCP0133_WarehouseCapacity.InitContro) |
| WK-SCP0133-0093 | G6 | cboValid / Valid / Active | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboValid / Valid / Active · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0133_WarehouseCapacity.InitContro) |
| WK-SCP0133-0094 | G6 | clbPlanGroup / Plan Group | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbPlanGroup / Plan Group · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0133_WarehouseCapacity.InitEvent ) |
| WK-SCP0133-0095 | X-REOPEN | SCP0133 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0133 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 8 (ACT:SCP0133_WarehouseCapacity.Dispose AC) |
| WK-SCP0133-0096 | H6 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboDivision / Division · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 2 (ACT:SCP0133_WarehouseCapacity.SpdMain_Ce) |
| WK-SCP0133-0097 | M4 | ITEM_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — ITEM_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 16 (ACT:SCP0133_WarehouseCapacity.SpdMain_Ce) |
| WK-SCP0133-0098 | M4 | SCM_SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SCM_SITE_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SCP0133_WarehouseCapacity.SpdMain_Ce) |
| WK-SCP0133-0099 | M4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SCP0133_WarehouseCapacity.SpdMain_Ce) |

## W7 기대값 확정 (73)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0133-0100 | C2 | SCP0133_WarehouseCapacity.CboPlanGroup_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0133_WarehouseCapacity.CboPlanGroup_SelectedInd: 진입점 집계 — C2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0133_WarehouseCapacity.CboPlanGro) |
| WK-SCP0133-0101 | C2 | SCP0133_WarehouseCapacity.ClbDivision_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0133_WarehouseCapacity.ClbDivision_SelectedInde: 진입점 집계 — C2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0133_WarehouseCapacity.ClbDivisio) |
| WK-SCP0133-0102 | C2 | SCP0133_WarehouseCapacity.SpdMain_Active | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0133_WarehouseCapacity.SpdMain_ActiveSheetChang: 진입점 집계 — C2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 16 (ACT:SCP0133_WarehouseCapacity.SpdMain_Ac) |
| WK-SCP0133-0103 | C2 | SCP0133_WarehouseCapacity.SpdMain_Change | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0133_WarehouseCapacity.SpdMain_Changed: 진입점 집계 — C2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0133_WarehouseCapacity.SpdMain_Ch) |
| WK-SCP0133-0104 | C2 | SCP0133_WarehouseCapacity.SpdMain_ComboS | 사람 판정 / AS-IS 원문 확인 → 재판정 | C2 기대값 확정 — SCP0133_WarehouseCapacity.SpdMain_ComboSelChange: 진입점 집계 — C2 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0133_WarehouseCapacity.SpdMain_Co) |
| WK-SCP0133-0105 | C3 | SCP0133_WarehouseCapacity.CboPlanGroup_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0133_WarehouseCapacity.CboPlanGroup_SelectedInd: 진입점 집계 — C3 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0133_WarehouseCapacity.CboPlanGro) |
| WK-SCP0133-0106 | C3 | SCP0133_WarehouseCapacity.ClbDivision_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0133_WarehouseCapacity.ClbDivision_SelectedInde: 진입점 집계 — C3 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0133_WarehouseCapacity.ClbDivisio) |
| WK-SCP0133-0107 | C3 | SCP0133_WarehouseCapacity.SetCellFocus_E | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0133_WarehouseCapacity.SetCellFocus_ERROR: 진입점 집계 — C3 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0133_WarehouseCapacity.SetCellFoc) |
| WK-SCP0133-0108 | C3 | SCP0133_WarehouseCapacity.SetChangedCont | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0133_WarehouseCapacity.SetChangedControl: 진입점 집계 — C3 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0133_WarehouseCapacity.SetChanged) |
| WK-SCP0133-0109 | C3 | SCP0133_WarehouseCapacity.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0133_WarehouseCapacity.SetSpreadInit: 진입점 집계 — C3 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0133_WarehouseCapacity.SetSpreadI) |
| WK-SCP0133-0110 | C3 | SCP0133_WarehouseCapacity.SetVisibleShee | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0133_WarehouseCapacity.SetVisibleSheetColumns: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0133_WarehouseCapacity.SetVisible) |
| WK-SCP0133-0111 | C3 | SCP0133_WarehouseCapacity.SpdMain_Active | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0133_WarehouseCapacity.SpdMain_ActiveSheetChang: 진입점 집계 — C3 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 16 (ACT:SCP0133_WarehouseCapacity.SpdMain_Ac) |
| WK-SCP0133-0112 | C3 | SCP0133_WarehouseCapacity.SpdMain_Change | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0133_WarehouseCapacity.SpdMain_Changed: 진입점 집계 — C3 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0133_WarehouseCapacity.SpdMain_Ch) |
| WK-SCP0133-0113 | C3 | SCP0133_WarehouseCapacity.SpdMain_ComboS | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0133_WarehouseCapacity.SpdMain_ComboSelChange: 진입점 집계 — C3 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0133_WarehouseCapacity.SpdMain_Co) |
| WK-SCP0133-0114 | C3 | SCP0133_WarehouseCapacity.setPeriod | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0133_WarehouseCapacity.setPeriod: 진입점 집계 — C3 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0133_WarehouseCapacity.setPeriod:) |
| WK-SCP0133-0115 | C6 | SCP0133_WarehouseCapacity.CboPlanGroup_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0133_WarehouseCapacity.CboPlanGroup_SelectedInd: 진입점 집계 — C6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0133_WarehouseCapacity.CboPlanGro) |
| WK-SCP0133-0116 | C6 | SCP0133_WarehouseCapacity.ClbDivision_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0133_WarehouseCapacity.ClbDivision_SelectedInde: 진입점 집계 — C6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0133_WarehouseCapacity.ClbDivisio) |
| WK-SCP0133-0117 | C6 | SCP0133_WarehouseCapacity.SpdMain_Active | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0133_WarehouseCapacity.SpdMain_ActiveSheetChang: 진입점 집계 — C6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 16 (ACT:SCP0133_WarehouseCapacity.SpdMain_Ac) |
| WK-SCP0133-0118 | C6 | SCP0133_WarehouseCapacity.SpdMain_Change | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0133_WarehouseCapacity.SpdMain_Changed: 진입점 집계 — C6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0133_WarehouseCapacity.SpdMain_Ch) |
| WK-SCP0133-0119 | C6 | SCP0133_WarehouseCapacity.SpdMain_ComboS | 사람 판정 / AS-IS 원문 확인 → 재판정 | C6 기대값 확정 — SCP0133_WarehouseCapacity.SpdMain_ComboSelChange: 진입점 집계 — C6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0133_WarehouseCapacity.SpdMain_Co) |
| WK-SCP0133-0120 | A5 | SCP0133_WarehouseCapacity.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0133_WarehouseCapacity.CreateSpread: 진입점 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0133_WarehouseCapacity.CreateSpre) |
| WK-SCP0133-0121 | A5 | SCP0133_WarehouseCapacity.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0133_WarehouseCapacity.SetSpreadInit: 진입점 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0133_WarehouseCapacity.SetSpreadI) |
| WK-SCP0133-0122 | D1 | SCP0133_WarehouseCapacity.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D1 기대값 확정 — SCP0133_WarehouseCapacity.EditButton: 진입점 집계 — D1 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0133_WarehouseCapacity.EditButton) |
| WK-SCP0133-0123 | D3 | SCP0133_WarehouseCapacity.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | D3 기대값 확정 — SCP0133_WarehouseCapacity.EditButton: 진입점 집계 — D3 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0133_WarehouseCapacity.EditButton) |
| WK-SCP0133-0124 | E4 | SCP0133_WarehouseCapacity.SetCellFocus_E | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0133_WarehouseCapacity.SetCellFocus_ERROR: 진입점 집계 — E4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0133_WarehouseCapacity.SetCellFoc) |
| WK-SCP0133-0125 | E4 | SCP0133_WarehouseCapacity.SetChangedCont | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0133_WarehouseCapacity.SetChangedControl: 진입점 집계 — E4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0133_WarehouseCapacity.SetChanged) |
| WK-SCP0133-0126 | E4 | SCP0133_WarehouseCapacity.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0133_WarehouseCapacity.SetSpreadInit: 진입점 집계 — E4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0133_WarehouseCapacity.SetSpreadI) |
| WK-SCP0133-0127 | E4 | SCP0133_WarehouseCapacity.SetVisibleShee | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0133_WarehouseCapacity.SetVisibleSheetColumns: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0133_WarehouseCapacity.SetVisible) |
| WK-SCP0133-0128 | E4 | SCP0133_WarehouseCapacity.setPeriod | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0133_WarehouseCapacity.setPeriod: 진입점 집계 — E4 10요소: NOT_RUN:10 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0133_WarehouseCapacity.setPeriod:) |
| WK-SCP0133-0129 | A1 | PKG_SCP0133.P_SCP0133_GET_WAREHOUSE_CAPA | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0133.P_SCP0133_GET_WAREHOUSE_CAPACITY: 골든 비교 케이스 없음(PKG_SCP0133.P_SCP0133_GET_WAREHOUSE_CAPACITY — 팝업·보조 SP 는 g |  | 62 (ACT:SCP0133_WarehouseCapacity.FindButton) |
| WK-SCP0133-0130 | A1 | SCP0133_GET_WAREHOUSE_ITEM_MAPPING | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0133_GET_WAREHOUSE_ITEM_MAPPING: 골든 비교 케이스 없음(SCP0133_GET_WAREHOUSE_ITEM_MAPPING — 팝업·보조 SP 는 golden_cases.csv 에 FE |  | 62 (ACT:SCP0133_WarehouseCapacity.FindButton) |
| WK-SCP0133-0131 | X-ROW | SCP0133_WarehouseCapacity.CboPlanGroup_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0133_WarehouseCapacity.CboPlanGroup_SelectedInd: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0133_WarehouseCapacity.CboPlanGro) |
| WK-SCP0133-0132 | X-ROW | SCP0133_WarehouseCapacity.CheckDigitValu | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0133_WarehouseCapacity.CheckDigitValueEntered: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 14 (ACT:SCP0133_WarehouseCapacity.CheckDigit) |
| WK-SCP0133-0133 | X-ROW | SCP0133_WarehouseCapacity.ClbDivision_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0133_WarehouseCapacity.ClbDivision_SelectedInde: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0133_WarehouseCapacity.ClbDivisio) |
| WK-SCP0133-0134 | X-ROW | SCP0133_WarehouseCapacity.CopyPlantSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0133_WarehouseCapacity.CopyPlantSite: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/DATA_OP/ENTRY/FLAG/LOCAL, 연결된 요소 검사 없음 |  | 11 (ACT:SCP0133_WarehouseCapacity.CopyPlantS) |
| WK-SCP0133-0135 | X-ROW | SCP0133_WarehouseCapacity.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0133_WarehouseCapacity.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0133_WarehouseCapacity.CreateSpre) |
| WK-SCP0133-0136 | X-ROW | SCP0133_WarehouseCapacity.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0133_WarehouseCapacity.DefineProperty: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0133_WarehouseCapacity.DefineProp) |
| WK-SCP0133-0137 | X-ROW | SCP0133_WarehouseCapacity.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0133_WarehouseCapacity.FindButton: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:2 |  | 1 (ACT:SCP0133_WarehouseCapacity.FindButton) |
| WK-SCP0133-0138 | X-ROW | SCP0133_WarehouseCapacity.FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0133_WarehouseCapacity.FindData_Main: 진입점 집계 16검사 — NOT_RUN:12 · REVIEW:2 · PASS:1 · NOPATH:1 |  | 8 (ACT:SCP0133_WarehouseCapacity.FindData_M) |
| WK-SCP0133-0139 | X-ROW | SCP0133_WarehouseCapacity.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0133_WarehouseCapacity.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0133_WarehouseCapacity.Form_Load) |
| WK-SCP0133-0140 | X-ROW | SCP0133_WarehouseCapacity.GetDivisionChe | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0133_WarehouseCapacity.GetDivisionChecked: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0133_WarehouseCapacity.GetDivisio) |
| WK-SCP0133-0141 | X-ROW | SCP0133_WarehouseCapacity.GetSearchInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0133_WarehouseCapacity.GetSearchInfo: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0133_WarehouseCapacity.GetSearchI) |
| WK-SCP0133-0142 | X-ROW | SCP0133_WarehouseCapacity.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0133_WarehouseCapacity.InitControls: 진입점 집계 8검사 — NOT_RUN:7 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SCP0133_WarehouseCapacity.InitContro) |
| WK-SCP0133-0143 | X-ROW | SCP0133_WarehouseCapacity.InitCurrentCel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0133_WarehouseCapacity.InitCurrentCellFocusInde: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0133_WarehouseCapacity.InitCurren) |
| WK-SCP0133-0144 | X-ROW | SCP0133_WarehouseCapacity.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0133_WarehouseCapacity.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 9 (ACT:SCP0133_WarehouseCapacity.InitSpread) |
| WK-SCP0133-0145 | X-ROW | SCP0133_WarehouseCapacity.InsertButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0133_WarehouseCapacity.InsertButton: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0133_WarehouseCapacity.InsertButt) |
| WK-SCP0133-0146 | X-ROW | SCP0133_WarehouseCapacity.Insert_Row | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0133_WarehouseCapacity.Insert_Row: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 17 (ACT:SCP0133_WarehouseCapacity.Insert_Row) |
| WK-SCP0133-0147 | X-ROW | SCP0133_WarehouseCapacity.RefreshPlanGro | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0133_WarehouseCapacity.RefreshPlanGroupByDivisi: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SCP0133_WarehouseCapacity.RefreshPla) |
| WK-SCP0133-0148 | X-ROW | SCP0133_WarehouseCapacity.RefreshSiteByD | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0133_WarehouseCapacity.RefreshSiteByDivision: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SCP0133_WarehouseCapacity.RefreshSit) |
| WK-SCP0133-0149 | X-ROW | SCP0133_WarehouseCapacity.RefreshSiteByP | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0133_WarehouseCapacity.RefreshSiteByPlanGroup: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 9 (ACT:SCP0133_WarehouseCapacity.RefreshSit) |
| WK-SCP0133-0150 | X-ROW | SCP0133_WarehouseCapacity.RefreshStageBy | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0133_WarehouseCapacity.RefreshStageByDivision: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0133_WarehouseCapacity.RefreshSta) |
| WK-SCP0133-0151 | X-ROW | SCP0133_WarehouseCapacity.RefreshWarehou | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0133_WarehouseCapacity.RefreshWarehouse: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SCP0133_WarehouseCapacity.RefreshWar) |
| WK-SCP0133-0152 | X-ROW | SCP0133_WarehouseCapacity.SaveData_ItemM | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0133_WarehouseCapacity.SaveData_ItemMapping: 진입점 집계 13검사 — NOT_RUN:8 · NOPATH:4 · PASS:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SCP0133_WarehouseCapacity.SaveData_I) |
| WK-SCP0133-0153 | X-ROW | SCP0133_WarehouseCapacity.SaveData_WhCap | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0133_WarehouseCapacity.SaveData_WhCapa: 진입점 집계 17검사 — NOT_RUN:11 · NOPATH:4 · PASS:2 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SCP0133_WarehouseCapacity.SaveData_W) |
| WK-SCP0133-0154 | X-ROW | SCP0133_WarehouseCapacity.SetCellFocus_E | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0133_WarehouseCapacity.SetCellFocus_ERROR: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0133_WarehouseCapacity.SetCellFoc) |
| WK-SCP0133-0155 | X-ROW | SCP0133_WarehouseCapacity.SetChangedCont | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0133_WarehouseCapacity.SetChangedControl: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0133_WarehouseCapacity.SetChanged) |
| WK-SCP0133-0156 | X-ROW | SCP0133_WarehouseCapacity.SetSpreadInit | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0133_WarehouseCapacity.SetSpreadInit: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0133_WarehouseCapacity.SetSpreadI) |
| WK-SCP0133-0157 | X-ROW | SCP0133_WarehouseCapacity.SpdMain_Active | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0133_WarehouseCapacity.SpdMain_ActiveSheetChang: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 9 (ACT:SCP0133_WarehouseCapacity.SpdMain_Ac) |
| WK-SCP0133-0158 | X-ROW | SCP0133_WarehouseCapacity.SpdMain_CellDo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0133_WarehouseCapacity.SpdMain_CellDoubleClick: 진입점 집계 12검사 — NOT_RUN:6 · NOPATH:3 · REVIEW:3 |  | 2 (ACT:SCP0133_WarehouseCapacity.SpdMain_Ce) |
| WK-SCP0133-0159 | X-ROW | SCP0133_WarehouseCapacity.SpdMain_Change | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0133_WarehouseCapacity.SpdMain_Changed: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0133_WarehouseCapacity.SpdMain_Ch) |
| WK-SCP0133-0160 | X-ROW | SCP0133_WarehouseCapacity.SpdMain_Clipbo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0133_WarehouseCapacity.SpdMain_ClipboardPasted: 진입점 집계 15검사 — NOT_RUN:15 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0133_WarehouseCapacity.SpdMain_Cl) |
| WK-SCP0133-0161 | X-ROW | SCP0133_WarehouseCapacity.SpdMain_ComboS | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0133_WarehouseCapacity.SpdMain_ComboSelChange: 진입점 집계 24검사 — NOT_RUN:21 · REVIEW:3 |  | 3 (ACT:SCP0133_WarehouseCapacity.SpdMain_Co) |
| WK-SCP0133-0162 | X-ROW | SCP0133_WarehouseCapacity.SpdMain_EditCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0133_WarehouseCapacity.SpdMain_EditChange: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/FLAG, 연결된 요소 검사 없음 |  | 3 (ACT:SCP0133_WarehouseCapacity.SpdMain_Ed) |
| WK-SCP0133-0163 | X-ROW | SCP0133_WarehouseCapacity.SpdMain_EditMo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0133_WarehouseCapacity.SpdMain_EditModeOff: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_LOCAL/ENTRY/RETURN, 연결된 요소 검사  |  | 4 (ACT:SCP0133_WarehouseCapacity.SpdMain_Ed) |
| WK-SCP0133-0164 | X-ROW | SCP0133_WarehouseCapacity.SpdMain_TopCha | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0133_WarehouseCapacity.SpdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0133_WarehouseCapacity.SpdMain_To) |
| WK-SCP0133-0165 | X-ROW | SCP0133_WarehouseCapacity.ValidateUserIn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0133_WarehouseCapacity.ValidateUserInput: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SCP0133_WarehouseCapacity.ValidateUs) |
| WK-SCP0133-0166 | X-ROW | SCP0133_WarehouseCapacity.btnItemId_Clic | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0133_WarehouseCapacity.btnItemId_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0133_WarehouseCapacity.btnItemId_) |
| WK-SCP0133-0167 | X-ROW | SCP0133_WarehouseCapacity.setPeriod | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0133_WarehouseCapacity.setPeriod: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0133_WarehouseCapacity.setPeriod ) |
| WK-SCP0133-0168 | X-ROW | SCP0133_WarehouseCapacity.spdMain_CellCl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0133_WarehouseCapacity.spdMain_CellClick: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 29 (ACT:SCP0133_WarehouseCapacity.spdMain_Ce) |
| WK-SCP0133-0169 | X-ROW | SCP0133_WarehouseCapacity.spdSub_ActiveS | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0133_WarehouseCapacity.spdSub_ActiveSheetChangi: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0133_WarehouseCapacity.spdSub_Act) |
| WK-SCP0133-0170 | G5 | SCP0133_WarehouseCapacity.SpdMain_CellDo | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCP0133_WarehouseCapacity.SpdMain_CellDoubleClick: 진입점 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0133_WarehouseCapacity.SpdMain_Ce) |
| WK-SCP0133-0171 | H6 | SCP0133_WarehouseCapacity.SpdMain_CellDo | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCP0133_WarehouseCapacity.SpdMain_CellDoubleClick: 진입점 집계 — H6 2요소: NOT_RUN:1 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0133_WarehouseCapacity.SpdMain_Ce) |
| WK-SCP0133-0172 | M4 | SCP0133_WarehouseCapacity.SpdMain_CellDo | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0133_WarehouseCapacity.SpdMain_CellDoubleClick: 진입점 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0133_WarehouseCapacity.SpdMain_Ce) |
