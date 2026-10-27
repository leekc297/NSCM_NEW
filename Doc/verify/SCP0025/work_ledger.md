# 작업 원장 — SCP0025 · 2026-10-26 12:53

> 검사 인스턴스 313건 중 PASS·NA 98건 외 **215건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W1 | 기능 구현 | 2 | 대조표 구현 + 위치 기입 → W8 실행 |
| W2 | 구현 위치 확인 | 12 | 구현 위치 실존 |
| W3 | 동작 수정 | 1 | 재판정 PASS |
| W4 | 검사기 구현 | 1 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 18 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 62 | 실행 → PASS |
| W7 | 기대값 확정 | 115 | 기대 확정 → PASS/FAIL |
| W8 | 구현 후 검증 | 4 | 선행 W1 → PASS |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 114 · E2E 62 · 하네스 19 · 대조표 13 · 선행 W1 완료 후 E2E 4 · FE 3
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 13건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 35 | 1 |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| X-LOC | GEN |  | 12 |  |  |  |  | 12 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| E4 | EDIT |  |  |  |  |  | 15 | 7 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| H5 | DESIGN |  |  |  |  |  | 3 | 14 |  |  | 라벨 명칭 |
| G1 | GEN |  |  |  |  |  | 5 | 7 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| A1 | GEN |  |  |  |  |  |  | 11 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| B3 | COMBO |  |  |  | 1 |  |  | 9 |  |  | 콤보 후보 정렬 = AS-IS |
| B4 | COMBO |  |  |  |  | 1 |  | 9 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| G4 | DESIGN |  |  |  |  | 5 | 4 | 1 |  |  | 조회조건 표시·라벨·활성 |
| F4 | DB |  |  |  |  |  | 7 | 2 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| DB-SYN | DB |  |  |  |  | 5 |  | 2 |  |  | BE 계정 시노님·권한·대상 객체 |
| C1 | CASCADE |  |  |  |  |  | 5 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| G6 | GEN |  |  |  |  |  | 4 | 1 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| G5 | POPUP |  |  |  |  | 2 |  | 1 | 1 |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 2 |  | 1 | 1 |  | 팝업 표준·열림 |
| A6 | GEN |  |  |  |  |  | 3 | 1 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| M4 | POPUP |  |  |  |  |  | 2 | 1 | 1 |  | 팝업 선택값 반영 |
| C4 | CASCADE |  |  |  |  |  | 3 |  |  |  | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| X-NOTIMPL | GEN | 2 |  |  |  |  |  |  |  |  | 대조표 상태 미구현 = 구현 대상(FAIL) |
| H10 | DESIGN |  |  | 1 |  |  |  |  |  |  | 메시지 표준(방식·코드 단일화) |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
| F6 | CRUD |  |  |  |  | 1 |  |  |  |  | 저장 후 값 보존 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  | 1 |  |  |  | 권한별 버튼·기능 |
| G3 | COMMON |  |  |  |  |  | 1 |  |  |  | 조회조건 저장·복원 |
| K4 | COMMON |  |  |  |  |  | 1 |  |  |  | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  | 1 |  |  |  | 저장 후 DB 반영(마커 행) |
| F5 | CRUD |  |  |  |  |  | 1 |  |  |  | CRUD Status 표시 정합 |
| H4 | DESIGN |  |  |  |  |  | 1 |  |  |  | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  | 1 |  |  |  | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  | 1 |  |  |  | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  | 1 |  |  |  | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  | 1 |  |  |  | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| X-REASON | DESIGN |  |  |  |  |  |  | 1 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |

## W1 기능 구현 (2)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0025-0001 | X-NOTIMPL | 5 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — 5 Data_SCP.Common PlanExecYn 765 1 `PlanExecYn_SCP`(@divisionId → PLAN_STATUS) — R3 게이트 데이터. Page useTabComboQuerie |  | 0 () |
| WK-SCP0025-0002 | X-NOTIMPL | 9 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — 9 spdMain.CellDoubleClick 446 SetDblClickColumnShowHide(드릴다운) 미구현(확인필요 §7-2) |  | 1 (9) |

## W2 구현 위치 확인 (12)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0025-0003 | X-LOC | 10 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (10) |
| WK-SCP0025-0004 | X-LOC | 8 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (8) |
| WK-SCP0025-0005 | X-LOC | R-A 3-span 기간헤더 + 요일색 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-A 3-span 기간헤더 + 요일색) |
| WK-SCP0025-0006 | X-LOC | R-B 동적 기간 숫자 celltype | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-B 동적 기간 숫자 celltype) |
| WK-SCP0025-0007 | X-LOC | R-C 정보컬럼 3행 헤더 span(rowSpan=3) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-C 정보컬럼 3행 헤더 span(rowSpan=3)) |
| WK-SCP0025-0008 | X-LOC | R-D 조건부 컬럼 visible(EE) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-D 조건부 컬럼 visible(EE)) |
| WK-SCP0025-0009 | X-LOC | R-E spdInfo 초기화(merge + 액션박스) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-E spdInfo 초기화(merge + 액션박스)) |
| WK-SCP0025-0010 | X-LOC | R-F MEASURE 고정(Freeze) + 병합 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-F MEASURE 고정(Freeze) + 병합) |
| WK-SCP0025-0011 | X-LOC | R-G 데이터바인딩 + 전 컬럼 잠금 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-G 데이터바인딩 + 전 컬럼 잠금) |
| WK-SCP0025-0012 | X-LOC | R-H 셀타입 텍스트 + FIX_REASON 세팅 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-H 셀타입 텍스트 + FIX_REASON 세팅) |
| WK-SCP0025-0013 | X-LOC | R-I 더블클릭 컬럼 토글 + TopChange 재병합 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-I 더블클릭 컬럼 토글 + TopChange 재병합) |
| WK-SCP0025-0014 | X-LOC | R-J SUM 컬럼 visible 토글(chkSum×bucket) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R-J SUM 컬럼 visible 토글(chkSum×bucket)) |

## W3 동작 수정 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0025-0015 | H10 | SCP0025 화면 | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | H10 FAIL 수정 — SCP0025 화면: 표준 메시지 대신 브라우저 alert/confirm 직접 호출: shipment-plan-fix.constants.ts, ShipmentPlanFix.tsx, hooks/useShipme |  | 14 (G1 G2 G3 M2 M5 M6 M7 M8 V1 EditButton (E) |

## W4 검사기 구현 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0025-0016 | B3 | cboDivision / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboDivision / Division | 있음(FE 소스) | 1 (ACT:SCP0025_ShipmentPlanFix.BtnUnfix_Cli) |

## W5 검사기 연결 (18)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0025-0017 | B4 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (ACT:SCP0025_ShipmentPlanFix.BtnUnfix_Cli) |
| WK-SCP0025-0018 | F2 | SCP0025 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0025 화면 | 판단불가(대상 단위 SCREEN) | 139 (G1 SaveButton (Save) EditButton (Edit) C) |
| WK-SCP0025-0019 | F6 | SCP0025 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0025 화면 | 판단불가(대상 단위 SCREEN) | 135 (ACT:SCP0025_ShipmentPlanFix.SaveData_Fix) |
| WK-SCP0025-0020 | DB-SYN | DM0003_GET_BUCKET_TYPE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DM0003_GET_BUCKET_TYPE_CODE | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0025_ShipmentPlanFix.GetBucketTyp) |
| WK-SCP0025-0021 | DB-SYN | FN_GET_DIVISION_DIV | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP FN_GET_DIVISION_DIV | 없음(PROC_M 대응 없음) | 1 (R-D 조건부 컬럼 visible(EE)) |
| WK-SCP0025-0022 | DB-SYN | SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0025_ShipmentPlanFix.GetLastRange) |
| WK-SCP0025-0023 | DB-SYN | SCP0025_GET_SHIPMENT_PLAN_FIX | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0025_GET_SHIPMENT_PLAN_FIX | 없음(PROC_M 대응 없음) | 4 (ACT:SCP0025_ShipmentPlanFix.FindData_Mai) |
| WK-SCP0025-0024 | DB-SYN | SCP0025_SAVE_SHIPMENT_PLAN_FIX_DATASET | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0025_SAVE_SHIPMENT_PLAN_FIX_DATASET | 없음(PROC_M 대응 없음) | 1 (ACT:SCP0025_ShipmentPlanFix.SaveData_Fix) |
| WK-SCP0025-0025 | G4 | btnItem | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItem | 없음 | 2 (ACT:SCP0025_ShipmentPlanFix.InitEvent AC) |
| WK-SCP0025-0026 | G4 | btnUnfix | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnUnfix | 있음(FE 소스) | 2 (ACT:SCP0025_ShipmentPlanFix.InitEvent AC) |
| WK-SCP0025-0027 | G4 | btnW26 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnW26 | 없음 | 2 (ACT:SCP0025_ShipmentPlanFix.InitEvent AC) |
| WK-SCP0025-0028 | G4 | btnW52 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnW52 | 없음 | 2 (ACT:SCP0025_ShipmentPlanFix.InitEvent AC) |
| WK-SCP0025-0029 | G4 | btnWLast | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnWLast | 없음 | 4 (ACT:SCP0025_ShipmentPlanFix.InitControls) |
| WK-SCP0025-0030 | G03-WIRE | SCP0025 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0025 화면 | 판단불가(대상 단위 SCREEN) | 13 (ACT:SCP0025_ShipmentPlanFix..ctor ACT:SC) |
| WK-SCP0025-0031 | G5 | btnW26 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnW26 | 없음 | 0 () |
| WK-SCP0025-0032 | G5 | btnW52 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnW52 | 없음 | 0 () |
| WK-SCP0025-0033 | H6 | btnW26 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnW26 | 없음 | 0 () |
| WK-SCP0025-0034 | H6 | btnW52 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnW52 | 없음 | 0 () |

## W6 검증 실행 (62)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0025-0035 | J2 | SCP0025 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0025 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 45 (G1 G3 M2 M5 R-G 데이터바인딩 + 전 컬럼 잠금 FindBut) |
| WK-SCP0025-0036 | C1 | cboBizType / Operation Group / Biz Type  | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboBizType / Operation Group / Biz Type / Operatio · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:SCP0025_ShipmentPlanFix.InitControls) |
| WK-SCP0025-0037 | C1 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0025_ShipmentPlanFix.InitControls) |
| WK-SCP0025-0038 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0025_ShipmentPlanFix.InitControls) |
| WK-SCP0025-0039 | C1 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (8) |
| WK-SCP0025-0040 | C1 | clbElecType / Electrode / Elec Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbElecType / Electrode / Elec Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0025_ShipmentPlanFix.InitControls) |
| WK-SCP0025-0041 | C4 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 0 () |
| WK-SCP0025-0042 | C4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 0 () |
| WK-SCP0025-0043 | C4 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (8) |
| WK-SCP0025-0044 | G3 | SCP0025 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0025 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 4 (COMMON:UC-04 COMMON:UC-05 COMMON:UC-06 C) |
| WK-SCP0025-0045 | K4 | SCP0025 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0025 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 37 (COMMON:UC-04 COMMON:UC-05 COMMON:UC-06 C) |
| WK-SCP0025-0046 | F1 | SCP0025 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0025 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 141 (G1 M5 SaveButton (Save) EditButton (Edit) |
| WK-SCP0025-0047 | F5 | SCP0025 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0025 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 3 (M5 EditButton (Edit) (Insert/Delete over) |
| WK-SCP0025-0048 | F4 | DM0003_GET_BUCKET_TYPE_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DM0003_GET_BUCKET_TYPE_CODE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:SCP0025_ShipmentPlanFix.GetBucketTyp) |
| WK-SCP0025-0049 | F4 | FN_GET_DIVISION_DIV | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — FN_GET_DIVISION_DIV · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (R-D 조건부 컬럼 visible(EE)) |
| WK-SCP0025-0050 | F4 | PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: |  | 2 (ACT:SCP0025_ShipmentPlanFix.GetDayRange:) |
| WK-SCP0025-0051 | F4 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) —  |  | 188 (ACT:SCP0025_ShipmentPlanFix.FindButton A) |
| WK-SCP0025-0052 | F4 | SCM0001_GET_SCP_DAILY_PLAN_PERIOD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_SCP_DAILY_PLAN_PERIOD · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke· |  | 2 (ACT:SCP0025_ShipmentPlanFix.GetLastRange) |
| WK-SCP0025-0053 | F4 | SCP0025_GET_SHIPMENT_PLAN_FIX | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0025_GET_SHIPMENT_PLAN_FIX · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trac |  | 188 (ACT:SCP0025_ShipmentPlanFix.FindButton A) |
| WK-SCP0025-0054 | F4 | SCP0025_SAVE_SHIPMENT_PLAN_FIX_DATASET | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0025_SAVE_SHIPMENT_PLAN_FIX_DATASET · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 135 (ACT:SCP0025_ShipmentPlanFix.SaveData_Fix) |
| WK-SCP0025-0055 | G4 | cboBizType / Operation Group / Biz Type  | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboBizType / Operation Group / Biz Type / Operatio · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0025_ShipmentPlanFix.InitControls) |
| WK-SCP0025-0056 | G4 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 6 (ACT:SCP0025_ShipmentPlanFix.DefineProper) |
| WK-SCP0025-0057 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 7 (ACT:SCP0025_ShipmentPlanFix.InitControls) |
| WK-SCP0025-0058 | G4 | clbElecType / Electrode / Elec Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbElecType / Electrode / Elec Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (ACT:SCP0025_ShipmentPlanFix.InitControls) |
| WK-SCP0025-0059 | H4 | SCP0025 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — SCP0025 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 6 (10 R-I 더블클릭 컬럼 토글 + TopChange 재병합 ACT:SC) |
| WK-SCP0025-0060 | H5 | cboBucketType / Bucket / Bucket Type | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) —  |  | 17 (ACT:SCP0025_ShipmentPlanFix.SetSpreadCol) |
| WK-SCP0025-0061 | H5 | cboDivision / Division | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — cboDivision / Division · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 0 () |
| WK-SCP0025-0062 | H5 | chkSum / Sum | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — chkSum / Sum · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (R-J SUM 컬럼 visible 토글(chkSum×bucket) ACT) |
| WK-SCP0025-0063 | I1 | SCP0025 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0025 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 20 (G1 G2 G3 M2 M5 M6 M7 M8 V1 EditButton (E) |
| WK-SCP0025-0064 | SC1 | SCP0025 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SCP0025 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 1 (COMMON:UC-06) |
| WK-SCP0025-0065 | D6 | SCP0025 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0025 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 2 (EditButton (Edit) (Insert/Delete overrid) |
| WK-SCP0025-0066 | E4 | MSG00003 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00003 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (M7 ACT:SCP0025_ShipmentPlanFix.SaveData_) |
| WK-SCP0025-0067 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (M6 ACT:SCP0025_ShipmentPlanFix.SaveData_) |
| WK-SCP0025-0068 | E4 | MSG00014 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00014 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (V1) |
| WK-SCP0025-0069 | E4 | MSG00016 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00016 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (M5 ACT:SCP0025_ShipmentPlanFix.SaveData_) |
| WK-SCP0025-0070 | E4 | MSG00046 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00046 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0025_ShipmentPlanFix.SaveData_Fix) |
| WK-SCP0025-0071 | E4 | MSG00096 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00096 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (G1 ACT:SCP0025_ShipmentPlanFix.BtnUnfix_) |
| WK-SCP0025-0072 | E4 | MSG00109 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00109 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (EditButton (Edit) ACT:SCP0025_ShipmentPl) |
| WK-SCP0025-0073 | E4 | MSG00134 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00134 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (V1 ACT:SCP0025_ShipmentPlanFix.SaveData_) |
| WK-SCP0025-0074 | E4 | MSG00304 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00304 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (G2 ACT:SCP0025_ShipmentPlanFix.BtnUnfix_) |
| WK-SCP0025-0075 | E4 | MSG00683 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00683 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (M5) |
| WK-SCP0025-0076 | E4 | cboBizType / Operation Group / Biz Type  | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboBizType / Operation Group / Biz Type / Operatio · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요 |  | 2 (ACT:SCP0025_ShipmentPlanFix.SetOperation) |
| WK-SCP0025-0077 | E4 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 |  | 17 (ACT:SCP0025_ShipmentPlanFix.SetSpreadCol) |
| WK-SCP0025-0078 | E4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 2 (ACT:SCP0025_ShipmentPlanFix.SetOperation) |
| WK-SCP0025-0079 | E4 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SCP0025_ShipmentPlanFix.SetSpreadCol) |
| WK-SCP0025-0080 | E4 | clbElecType / Electrode / Elec Type | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbElecType / Electrode / Elec Type · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장  |  | 4 (ACT:SCP0025_ShipmentPlanFix.SetOperation) |
| WK-SCP0025-0081 | A10 | SCP0025 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0025 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 143 (ACT:SCP0025_ShipmentPlanFix.DefineProper) |
| WK-SCP0025-0082 | A6 | FN_GET_DIVISION_DIV | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — FN_GET_DIVISION_DIV · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 1 (R-D 조건부 컬럼 visible(EE)) |
| WK-SCP0025-0083 | A6 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새 |  | 52 (ACT:SCP0025_ShipmentPlanFix.FindButton A) |
| WK-SCP0025-0084 | A6 | SCP0025_GET_SHIPMENT_PLAN_FIX | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SCP0025_GET_SHIPMENT_PLAN_FIX · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.sp |  | 54 (ACT:SCP0025_ShipmentPlanFix.FindButton A) |
| WK-SCP0025-0085 | G1 | cboBizType / Operation Group / Biz Type  | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboBizType / Operation Group / Biz Type / Operatio · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0025_ShipmentPlanFix.FindData_Mai) |
| WK-SCP0025-0086 | G1 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 0 () |
| WK-SCP0025-0087 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0025_ShipmentPlanFix.FindData_Mai) |
| WK-SCP0025-0088 | G1 | clbElecType / Electrode / Elec Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbElecType / Electrode / Elec Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0025_ShipmentPlanFix.FindData_Mai) |
| WK-SCP0025-0089 | G1 | txtItem_Id / Model / Item_Id / Model/Nic | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItem_Id / Model / Item_Id / Model/Nickname · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0025_ShipmentPlanFix.FindData_Mai) |
| WK-SCP0025-0090 | G6 | cboBizType / Operation Group / Biz Type  | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboBizType / Operation Group / Biz Type / Operatio · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0025_ShipmentPlanFix.InitControls) |
| WK-SCP0025-0091 | G6 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 6 (ACT:SCP0025_ShipmentPlanFix.DefineProper) |
| WK-SCP0025-0092 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 7 (ACT:SCP0025_ShipmentPlanFix.InitControls) |
| WK-SCP0025-0093 | G6 | clbElecType / Electrode / Elec Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbElecType / Electrode / Elec Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (ACT:SCP0025_ShipmentPlanFix.InitControls) |
| WK-SCP0025-0094 | X-REOPEN | SCP0025 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0025 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 12 (ACT:SCP0025_ShipmentPlanFix.Dispose ACT:) |
| WK-SCP0025-0095 | M4 | btnW26 | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnW26 · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 0 () |
| WK-SCP0025-0096 | M4 | btnW52 | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnW52 · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 0 () |

## W7 기대값 확정 (115)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0025-0097 | B3 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — 1: 행 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-SCP0025-0098 | B3 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — 2: 행 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 1 (2) |
| WK-SCP0025-0099 | B3 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — 3: 행 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 1 (3) |
| WK-SCP0025-0100 | B3 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — 4: 행 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 1 (4) |
| WK-SCP0025-0101 | B3 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — COMMON:UC-05: 행 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0025-0102 | B3 | SCP0025_ShipmentPlanFix.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0025_ShipmentPlanFix.GetBucketType: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0025_ShipmentPlanFix.GetBucketTyp) |
| WK-SCP0025-0103 | B3 | SCP0025_ShipmentPlanFix.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0025_ShipmentPlanFix.GetDayRange: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0025_ShipmentPlanFix.GetDayRange:) |
| WK-SCP0025-0104 | B3 | SCP0025_ShipmentPlanFix.GetLastRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0025_ShipmentPlanFix.GetLastRange: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0025_ShipmentPlanFix.GetLastRange) |
| WK-SCP0025-0105 | B3 | SCP0025_ShipmentPlanFix.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0025_ShipmentPlanFix.GetSpdTitle: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0025_ShipmentPlanFix.GetSpdTitle:) |
| WK-SCP0025-0106 | B4 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — 1: 행 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (1) |
| WK-SCP0025-0107 | B4 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — 2: 행 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (2) |
| WK-SCP0025-0108 | B4 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — 3: 행 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (3) |
| WK-SCP0025-0109 | B4 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — 4: 행 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (4) |
| WK-SCP0025-0110 | B4 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — COMMON:UC-05: 행 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0025-0111 | B4 | SCP0025_ShipmentPlanFix.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0025_ShipmentPlanFix.GetBucketType: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0025_ShipmentPlanFix.GetBucketTyp) |
| WK-SCP0025-0112 | B4 | SCP0025_ShipmentPlanFix.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0025_ShipmentPlanFix.GetDayRange: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0025_ShipmentPlanFix.GetDayRange:) |
| WK-SCP0025-0113 | B4 | SCP0025_ShipmentPlanFix.GetLastRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0025_ShipmentPlanFix.GetLastRange: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0025_ShipmentPlanFix.GetLastRange) |
| WK-SCP0025-0114 | B4 | SCP0025_ShipmentPlanFix.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0025_ShipmentPlanFix.GetSpdTitle: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 7 (ACT:SCP0025_ShipmentPlanFix.GetSpdTitle:) |
| WK-SCP0025-0115 | DB-SYN | M2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — M2: 행 집계 — DB-SYN 7요소: NOPATH:5 · PASS:2 (미실행 요소가 남아 판정필요) |  | 1 (M2) |
| WK-SCP0025-0116 | DB-SYN | SCP0025_ShipmentPlanFix.SCM_SYS_LOG_BATC | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SCP0025_ShipmentPlanFix.SCM_SYS_LOG_BATCH: 진입점 집계 — DB-SYN 7요소: NOPATH:5 · PASS:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0025_ShipmentPlanFix.SCM_SYS_LOG_) |
| WK-SCP0025-0117 | F4 | M2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — M2: 행 집계 — F4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (M2) |
| WK-SCP0025-0118 | F4 | SCP0025_ShipmentPlanFix.SCM_SYS_LOG_BATC | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0025_ShipmentPlanFix.SCM_SYS_LOG_BATCH: 진입점 집계 — F4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0025_ShipmentPlanFix.SCM_SYS_LOG_) |
| WK-SCP0025-0119 | G4 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — COMMON:UC-06: 행 집계 — G4 9요소: NOPATH:5 · NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0025-0120 | H5 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 10: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (10) |
| WK-SCP0025-0121 | H5 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 4: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (4) |
| WK-SCP0025-0122 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0025-0123 | H5 | R-A 3-span 기간헤더 + 요일색 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-A 3-span 기간헤더 + 요일색: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (R-A 3-span 기간헤더 + 요일색) |
| WK-SCP0025-0124 | H5 | R-B 동적 기간 숫자 celltype | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-B 동적 기간 숫자 celltype: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (R-B 동적 기간 숫자 celltype) |
| WK-SCP0025-0125 | H5 | R-C 정보컬럼 3행 헤더 span(rowSpan=3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-C 정보컬럼 3행 헤더 span(rowSpan=3): 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (R-C 정보컬럼 3행 헤더 span(rowSpan=3)) |
| WK-SCP0025-0126 | H5 | R-D 조건부 컬럼 visible(EE) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-D 조건부 컬럼 visible(EE): 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (R-D 조건부 컬럼 visible(EE)) |
| WK-SCP0025-0127 | H5 | R-E spdInfo 초기화(merge + 액션박스) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-E spdInfo 초기화(merge + 액션박스): 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (R-E spdInfo 초기화(merge + 액션박스)) |
| WK-SCP0025-0128 | H5 | R-F MEASURE 고정(Freeze) + 병합 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-F MEASURE 고정(Freeze) + 병합: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (R-F MEASURE 고정(Freeze) + 병합) |
| WK-SCP0025-0129 | H5 | R-G 데이터바인딩 + 전 컬럼 잠금 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-G 데이터바인딩 + 전 컬럼 잠금: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (R-G 데이터바인딩 + 전 컬럼 잠금) |
| WK-SCP0025-0130 | H5 | R-H 셀타입 텍스트 + FIX_REASON 세팅 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-H 셀타입 텍스트 + FIX_REASON 세팅: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (R-H 셀타입 텍스트 + FIX_REASON 세팅) |
| WK-SCP0025-0131 | H5 | R-I 더블클릭 컬럼 토글 + TopChange 재병합 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R-I 더블클릭 컬럼 토글 + TopChange 재병합: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (R-I 더블클릭 컬럼 토글 + TopChange 재병합) |
| WK-SCP0025-0132 | H5 | SCP0025_ShipmentPlanFix.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0025_ShipmentPlanFix.CreateSpread: 진입점 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0025_ShipmentPlanFix.CreateSpread) |
| WK-SCP0025-0133 | H5 | SCP0025_ShipmentPlanFix.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0025_ShipmentPlanFix.SetSpreadColumn: 진입점 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0025_ShipmentPlanFix.SetSpreadCol) |
| WK-SCP0025-0134 | X-REASON | COMMON:UC-02 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-02 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4)  해당없음 — 편집 기능  |  | 1 (COMMON:UC-02) |
| WK-SCP0025-0135 | E4 | G3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — G3: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (G3) |
| WK-SCP0025-0136 | E4 | M2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — M2: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (M2) |
| WK-SCP0025-0137 | E4 | M8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — M8: 행 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (M8) |
| WK-SCP0025-0138 | E4 | SCP0025_ShipmentPlanFix.SetOperationGrou | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0025_ShipmentPlanFix.SetOperationGroupByDivisio: 진입점 집계 — E4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0025_ShipmentPlanFix.SetOperation) |
| WK-SCP0025-0139 | E4 | SCP0025_ShipmentPlanFix.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0025_ShipmentPlanFix.SetSpreadColumn: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0025_ShipmentPlanFix.SetSpreadCol) |
| WK-SCP0025-0140 | E4 | SCP0025_ShipmentPlanFix.Set_FixReason | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0025_ShipmentPlanFix.Set_FixReason: 진입점 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 42 (ACT:SCP0025_ShipmentPlanFix.Set_FixReaso) |
| WK-SCP0025-0141 | E4 | SCP0025_ShipmentPlanFix.Set_SumValues | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0025_ShipmentPlanFix.Set_SumValues: 진입점 집계 — E4 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 25 (ACT:SCP0025_ShipmentPlanFix.Set_SumValue) |
| WK-SCP0025-0142 | A1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1: 행 집계 — A1 3요소: REVIEW:3 |  | 0 () |
| WK-SCP0025-0143 | A1 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 6: 행 집계 — A1 3요소: REVIEW:3 |  | 0 () |
| WK-SCP0025-0144 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (COMMON:UC-06) |
| WK-SCP0025-0145 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (COMMON:UC-07) |
| WK-SCP0025-0146 | A1 | EditButton (Edit) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — EditButton (Edit): 행 집계 — A1 3요소: REVIEW:3 |  | 1 (EditButton (Edit)) |
| WK-SCP0025-0147 | A1 | FN_GET_DIVISION_DIV | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FN_GET_DIVISION_DIV: 골든 비교 케이스 없음(FN_GET_DIVISION_DIV — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (R-D 조건부 컬럼 visible(EE)) |
| WK-SCP0025-0148 | A1 | FindButton (Search) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindButton (Search): 행 집계 — A1 3요소: REVIEW:3 |  | 1 (FindButton (Search)) |
| WK-SCP0025-0149 | A1 | G3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — G3: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (G3) |
| WK-SCP0025-0150 | A1 | M2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — M2: 행 집계 — A1 3요소: REVIEW:3 |  | 1 (M2) |
| WK-SCP0025-0151 | A1 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN: 골든 비교 케이스 없음(PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN — 팝업·보조 SP |  | 52 (ACT:SCP0025_ShipmentPlanFix.FindButton A) |
| WK-SCP0025-0152 | A1 | SCP0025_GET_SHIPMENT_PLAN_FIX | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0025_GET_SHIPMENT_PLAN_FIX: 골든 비교 케이스 없음(SCP0025_GET_SHIPMENT_PLAN_FIX — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 |  | 54 (ACT:SCP0025_ShipmentPlanFix.FindButton A) |
| WK-SCP0025-0153 | A6 | M2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — M2: 행 집계 — A6 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (M2) |
| WK-SCP0025-0154 | G1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 1: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0025-0155 | G1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-06: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0025-0156 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0025-0157 | G1 | EditButton (Edit) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — EditButton (Edit): 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (EditButton (Edit)) |
| WK-SCP0025-0158 | G1 | FindButton (Search) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — FindButton (Search): 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (FindButton (Search)) |
| WK-SCP0025-0159 | G1 | G3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — G3: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (G3) |
| WK-SCP0025-0160 | G1 | M2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — M2: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (M2) |
| WK-SCP0025-0161 | G6 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — COMMON:UC-06: 행 집계 — G6 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0025-0162 | X-LOC | (Insert/Delete override 없음) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — (Insert/Delete override 없음): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 ((Insert/Delete override 없음)) |
| WK-SCP0025-0163 | X-LOC | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (1) |
| WK-SCP0025-0164 | X-LOC | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (2) |
| WK-SCP0025-0165 | X-LOC | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (3) |
| WK-SCP0025-0166 | X-LOC | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (4) |
| WK-SCP0025-0167 | X-LOC | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (5) |
| WK-SCP0025-0168 | X-LOC | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 6: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (6) |
| WK-SCP0025-0169 | X-LOC | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 7: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (7) |
| WK-SCP0025-0170 | X-LOC | EditButton (Edit) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — EditButton (Edit): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (EditButton (Edit)) |
| WK-SCP0025-0171 | X-LOC | ExcelButton (Excel) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ExcelButton (Excel): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (ExcelButton (Excel)) |
| WK-SCP0025-0172 | X-LOC | FindButton (Search) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — FindButton (Search): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (FindButton (Search)) |
| WK-SCP0025-0173 | X-LOC | SaveButton (Save) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SaveButton (Save): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SaveButton (Save)) |
| WK-SCP0025-0174 | X-ROW | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 2: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 0 () |
| WK-SCP0025-0175 | X-ROW | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 6: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (6) |
| WK-SCP0025-0176 | X-ROW | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 7: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (7) |
| WK-SCP0025-0177 | X-ROW | ExcelButton (Excel) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — ExcelButton (Excel): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (ExcelButton (Excel)) |
| WK-SCP0025-0178 | X-ROW | SCP0025_ShipmentPlanFix.BtnItem_Id_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0025_ShipmentPlanFix.BtnItem_Id_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0025_ShipmentPlanFix.BtnItem_Id_C) |
| WK-SCP0025-0179 | X-ROW | SCP0025_ShipmentPlanFix.BtnW26_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0025_ShipmentPlanFix.BtnW26_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 0 () |
| WK-SCP0025-0180 | X-ROW | SCP0025_ShipmentPlanFix.BtnW52_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0025_ShipmentPlanFix.BtnW52_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 0 () |
| WK-SCP0025-0181 | X-ROW | SCP0025_ShipmentPlanFix.BtnWLast_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0025_ShipmentPlanFix.BtnWLast_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 0 () |
| WK-SCP0025-0182 | X-ROW | SCP0025_ShipmentPlanFix.CboDivision_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0025_ShipmentPlanFix.CboDivision_SelectedIndexC: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0025_ShipmentPlanFix.CboDivision_) |
| WK-SCP0025-0183 | X-ROW | SCP0025_ShipmentPlanFix.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0025_ShipmentPlanFix.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0025_ShipmentPlanFix.CreateSpread) |
| WK-SCP0025-0184 | X-ROW | SCP0025_ShipmentPlanFix.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0025_ShipmentPlanFix.DefineProperty: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0025_ShipmentPlanFix.DefineProper) |
| WK-SCP0025-0185 | X-ROW | SCP0025_ShipmentPlanFix.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0025_ShipmentPlanFix.EditButton: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0025_ShipmentPlanFix.EditButton) |
| WK-SCP0025-0186 | X-ROW | SCP0025_ShipmentPlanFix.ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0025_ShipmentPlanFix.ExcelButton: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/ENTRY/EXPR/LOCAL/THROW/UI_MISC/UI_PROP, 연결된 |  | 14 (ACT:SCP0025_ShipmentPlanFix.ExcelButton ) |
| WK-SCP0025-0187 | X-ROW | SCP0025_ShipmentPlanFix.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0025_ShipmentPlanFix.FindButton: 진입점 집계 6검사 — NOT_RUN:4 · REVIEW:2 |  | 1 (ACT:SCP0025_ShipmentPlanFix.FindButton) |
| WK-SCP0025-0188 | X-ROW | SCP0025_ShipmentPlanFix.FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0025_ShipmentPlanFix.FindData_Main: 진입점 집계 14검사 — NOT_RUN:10 · REVIEW:2 · NOPATH:1 · PASS:1 |  | 9 (ACT:SCP0025_ShipmentPlanFix.FindData_Mai) |
| WK-SCP0025-0189 | X-ROW | SCP0025_ShipmentPlanFix.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0025_ShipmentPlanFix.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0025_ShipmentPlanFix.Form_Load) |
| WK-SCP0025-0190 | X-ROW | SCP0025_ShipmentPlanFix.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0025_ShipmentPlanFix.GetBucketType: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0025_ShipmentPlanFix.GetBucketTyp) |
| WK-SCP0025-0191 | X-ROW | SCP0025_ShipmentPlanFix.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0025_ShipmentPlanFix.GetDayRange: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:1 · TODO:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0025_ShipmentPlanFix.GetDayRange) |
| WK-SCP0025-0192 | X-ROW | SCP0025_ShipmentPlanFix.GetLastRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0025_ShipmentPlanFix.GetLastRange: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0025_ShipmentPlanFix.GetLastRange) |
| WK-SCP0025-0193 | X-ROW | SCP0025_ShipmentPlanFix.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0025_ShipmentPlanFix.GetSpdTitle: 진입점 집계 5검사 — NOT_RUN:2 · PASS:1 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0025_ShipmentPlanFix.GetSpdTitle) |
| WK-SCP0025-0194 | X-ROW | SCP0025_ShipmentPlanFix.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0025_ShipmentPlanFix.InitControls: 진입점 집계 14검사 — NOT_RUN:13 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 9 (ACT:SCP0025_ShipmentPlanFix.InitControls) |
| WK-SCP0025-0195 | X-ROW | SCP0025_ShipmentPlanFix.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0025_ShipmentPlanFix.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0025_ShipmentPlanFix.InitSpread) |
| WK-SCP0025-0196 | X-ROW | SCP0025_ShipmentPlanFix.InitSpreadDateCo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0025_ShipmentPlanFix.InitSpreadDateColumn: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 16 (ACT:SCP0025_ShipmentPlanFix.InitSpreadDa) |
| WK-SCP0025-0197 | X-ROW | SCP0025_ShipmentPlanFix.InitSpread_2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0025_ShipmentPlanFix.InitSpread_2: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 9 (ACT:SCP0025_ShipmentPlanFix.InitSpread_2) |
| WK-SCP0025-0198 | X-ROW | SCP0025_ShipmentPlanFix.RetValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0025_ShipmentPlanFix.RetValue: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/EXPR/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 6 (ACT:SCP0025_ShipmentPlanFix.RetValue ACT) |
| WK-SCP0025-0199 | X-ROW | SCP0025_ShipmentPlanFix.SCM_SYS_LOG_BATC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0025_ShipmentPlanFix.SCM_SYS_LOG_BATCH: 진입점 집계 3검사 — NOT_RUN:2 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 12 (ACT:SCP0025_ShipmentPlanFix.SCM_SYS_LOG_) |
| WK-SCP0025-0200 | X-ROW | SCP0025_ShipmentPlanFix.SaveData_FixInfo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0025_ShipmentPlanFix.SaveData_FixInfo_U: 진입점 집계 16검사 — NOT_RUN:11 · NOPATH:4 · PASS:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0025_ShipmentPlanFix.SaveData_Fix) |
| WK-SCP0025-0201 | X-ROW | SCP0025_ShipmentPlanFix.SetOperationGrou | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0025_ShipmentPlanFix.SetOperationGroupByDivisio: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0025_ShipmentPlanFix.SetOperation) |
| WK-SCP0025-0202 | X-ROW | SCP0025_ShipmentPlanFix.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0025_ShipmentPlanFix.SetSpreadColumn: 진입점 집계 10검사 — NOT_RUN:10 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SCP0025_ShipmentPlanFix.SetSpreadCol) |
| WK-SCP0025-0203 | X-ROW | SCP0025_ShipmentPlanFix.Set_FixReason | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0025_ShipmentPlanFix.Set_FixReason: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0025_ShipmentPlanFix.Set_FixReaso) |
| WK-SCP0025-0204 | X-ROW | SCP0025_ShipmentPlanFix.Set_SumValues | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0025_ShipmentPlanFix.Set_SumValues: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0025_ShipmentPlanFix.Set_SumValue) |
| WK-SCP0025-0205 | X-ROW | SCP0025_ShipmentPlanFix.SpdMain_CellDoub | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0025_ShipmentPlanFix.SpdMain_CellDoubleClick: 진입점 집계 3검사 — NOPATH:2 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0025_ShipmentPlanFix.SpdMain_Cell) |
| WK-SCP0025-0206 | X-ROW | SCP0025_ShipmentPlanFix.SpdMain_TopChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0025_ShipmentPlanFix.SpdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0025_ShipmentPlanFix.SpdMain_TopC) |
| WK-SCP0025-0207 | X-ROW | SCP0025_ShipmentPlanFix.cboBucketType_Se | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0025_ShipmentPlanFix.cboBucketType_SelectedInde: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0025_ShipmentPlanFix.cboBucketTyp) |
| WK-SCP0025-0208 | X-ROW | SCP0025_ShipmentPlanFix.chkSum_CheckedCh | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0025_ShipmentPlanFix.chkSum_CheckedChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0025_ShipmentPlanFix.chkSum_Check) |
| WK-SCP0025-0209 | G5 | SCP0025_ShipmentPlanFix.SpdMain_CellDoub | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCP0025_ShipmentPlanFix.SpdMain_CellDoubleClick: 진입점 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0025_ShipmentPlanFix.SpdMain_Cell) |
| WK-SCP0025-0210 | H6 | SCP0025_ShipmentPlanFix.SpdMain_CellDoub | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCP0025_ShipmentPlanFix.SpdMain_CellDoubleClick: 진입점 집계 — H6 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0025_ShipmentPlanFix.SpdMain_Cell) |
| WK-SCP0025-0211 | M4 | SCP0025_ShipmentPlanFix.SpdMain_CellDoub | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0025_ShipmentPlanFix.SpdMain_CellDoubleClick: 진입점 집계 — M4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0025_ShipmentPlanFix.SpdMain_Cell) |

## W8 구현 후 검증 (4)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0025-0212 | X-ROW | 5 | 선행 W1 완료 후 E2E | X-ROW — 대조표 미구현 행  구현 후 검증 · 대상 5 |  | 1 (5) |
| WK-SCP0025-0213 | G5 | 9 | 선행 W1 완료 후 E2E | G5 — 대조표 미구현 행 9 구현 후 검증 · 대상 9 |  | 1 (9) |
| WK-SCP0025-0214 | H6 | 9 | 선행 W1 완료 후 E2E | H6 — 대조표 미구현 행 9 구현 후 검증 · 대상 9 |  | 1 (9) |
| WK-SCP0025-0215 | M4 | 9 | 선행 W1 완료 후 E2E | M4 — 대조표 미구현 행 9 구현 후 검증 · 대상 9 |  | 1 (9) |
