# 작업 원장 — SCP0009 · 2026-10-26 12:52

> 검사 인스턴스 781건 중 PASS·NA 216건 외 **565건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W1 | 기능 구현 | 1 | 대조표 구현 + 위치 기입 → W8 실행 |
| W2 | 구현 위치 확인 | 22 | 구현 위치 실존 |
| W3 | 동작 수정 | 1 | 재판정 PASS |
| W4 | 검사기 구현 | 6 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 37 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 142 | 실행 → PASS |
| W7 | 기대값 확정 | 352 | 기대 확정 → PASS/FAIL |
| W8 | 구현 후 검증 | 4 | 선행 W1 → PASS |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 348 · E2E 142 · 하네스 43 · 대조표 26 · 선행 W1 완료 후 E2E 4 · FE 1 · DB 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 21건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 91 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| X-LOC | GEN |  | 22 |  |  |  |  | 55 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| A1 | GEN |  |  |  |  |  |  | 55 | 1 |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| E4 | EDIT |  |  |  |  |  | 32 | 21 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| G1 | GEN |  |  |  |  |  | 15 | 32 | 1 |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| H5 | DESIGN |  |  |  |  |  | 4 | 30 |  |  | 라벨 명칭 |
| G4 | DESIGN |  |  |  |  | 10 | 15 | 6 | 1 |  | 조회조건 표시·라벨·활성 |
| F4 | DB |  |  |  |  |  | 20 | 5 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| G6 | GEN |  |  |  |  |  | 15 | 6 | 1 |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| DB-SYN | DB |  |  |  |  | 16 |  | 5 |  |  | BE 계정 시노님·권한·대상 객체 |
| B3 | COMBO |  |  |  | 6 |  |  | 10 |  |  | 콤보 후보 정렬 = AS-IS |
| B4 | COMBO |  |  |  |  | 6 |  | 10 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| A6 | GEN |  |  |  |  |  | 14 |  |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| C1 | CASCADE |  |  |  |  |  | 11 | 1 |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| G5 | POPUP |  |  |  |  | 2 |  | 7 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  |  | 2 | 7 |  |  | 팝업 표준·열림 |
| M4 | POPUP |  |  |  |  |  | 2 | 7 |  |  | 팝업 선택값 반영 |
| X-REASON | DESIGN |  |  |  |  |  |  | 4 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
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
| WK-SCP0009-0001 | X-NOTIMPL | `ConditionNotUseList`(PlanDate/Type/Seq  | FE(가이드만 — repairScope=DB_ONLY · FE 직접 수정 | 대조표 미구현 행 구현 — `ConditionNotUseList`(PlanDate/Type/Seq 저장제외) 미구현(조회조건 저장/복원 기능 자체가 이 화면에 없음) **해당없음** |  | 1 (`ConditionNotUseList`(PlanDate/Type/Seq ) |

## W2 구현 위치 확인 (22)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0009-0002 | X-LOC | Bucket×chkSum→visible(§2.4) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Bucket×chkSum→visible(§2.4)) |
| WK-SCP0009-0003 | X-LOC | DB 권한 행 `SCP0009 / main / EDIT`(`API_ID` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (DB 권한 행 `SCP0009 / main / EDIT`(`API_ID`) |
| WK-SCP0009-0004 | X-LOC | Fix-잠금 불일치(AS-IS 기지결함) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (Fix-잠금 불일치(AS-IS 기지결함)) |
| WK-SCP0009-0005 | X-LOC | H2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: NewPlanBodModal.tsx 없음, newPlan.ts 없음 |  | 1 (H2) |
| WK-SCP0009-0006 | X-LOC | M9 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: procedures.d.ts 없음 |  | 1 (M9) |
| WK-SCP0009-0007 | X-LOC | SmartColMerge(R-I) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SmartColMerge(R-I)) |
| WK-SCP0009-0008 | X-LOC | `.cs:1040-1068` BtnFix_Click 가드체인 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`.cs:1040-1068` BtnFix_Click 가드체인) |
| WK-SCP0009-0009 | X-LOC | `.cs:1070-1102` BtnUnfix_Click(+MSG00016 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`.cs:1070-1102` BtnUnfix_Click(+MSG00016) |
| WK-SCP0009-0010 | X-LOC | `.cs:1261-1263` FindButton | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`.cs:1261-1263` FindButton) |
| WK-SCP0009-0011 | X-LOC | `.cs:1314-1316` SaveButton → `SaveData_M | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`.cs:1314-1316` SaveButton → `SaveData_M) |
| WK-SCP0009-0012 | X-LOC | `.cs:1318-1345` ExcelButton | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`.cs:1318-1345` ExcelButton) |
| WK-SCP0009-0013 | X-LOC | `.cs:3977-4004` Set_FixButtonEnabled | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`.cs:3977-4004` Set_FixButtonEnabled) |
| WK-SCP0009-0014 | X-LOC | `BlockCellsChecking`(R-K, 편집가능판정) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`BlockCellsChecking`(R-K, 편집가능판정)) |
| WK-SCP0009-0015 | X-LOC | `P_MAKE_PIVOT_COLUMNS`(값) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`P_MAKE_PIVOT_COLUMNS`(값)) |
| WK-SCP0009-0016 | X-LOC | `P_SCP0009_GET_SHEET_CALENDAR_3SPAN`(헤더) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`P_SCP0009_GET_SHEET_CALENDAR_3SPAN`(헤더)) |
| WK-SCP0009-0017 | X-LOC | `splitContainer1/2`(고정비율 425/581, 958),  | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`splitContainer1/2`(고정비율 425/581, 958), ) |
| WK-SCP0009-0018 | X-LOC | `usrConditionPanel1`(HidePanel) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`usrConditionPanel1`(HidePanel)) |
| WK-SCP0009-0019 | X-LOC | division 조건부 hidden(R-A/R-B, 19+12건) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (division 조건부 hidden(R-A/R-B, 19+12건)) |
| WK-SCP0009-0020 | X-LOC | 가드 메시지 ID(2026-10-06 정정) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (가드 메시지 ID(2026-10-06 정정)) |
| WK-SCP0009-0021 | X-LOC | 저장 검증(MSG00084/MSG00317) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (저장 검증(MSG00084/MSG00317)) |
| WK-SCP0009-0022 | X-LOC | 저장 성공 토스트 메시지 ID(2026-10-06 정정) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (저장 성공 토스트 메시지 ID(2026-10-06 정정)) |
| WK-SCP0009-0023 | X-LOC | 파일 삭제 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 구현 위치 실존 안 함: components/PeggingInfoModal.tsx 없음, components/PlanProblemModal.tsx 없음 |  | 1 (파일 삭제) |

## W3 동작 수정 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0009-0024 | H10 | SCP0009 화면 | DB(🛠️/🧯 적용 가능) | H10 FAIL 수정 — SCP0009 화면: 표준 메시지 대신 브라우저 alert/confirm 직접 호출: ShipmentPlanFg.tsx |  | 8 (`.cs:3661-3705` Get_IsSaveYn — Fix(1056)) |

## W4 검사기 구현 (6)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0009-0025 | B3 | cboDivision / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboDivision / Division | 있음(FE 소스) | 3 (ACT:SCP0009_Shipment_Plan_FG.Get_IsSaveY) |
| WK-SCP0009-0026 | B3 | cboPlanDate / Plan-date / Plan Date | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboPlanDate / Plan-date / Plan Date | 있음(FE 소스) | 4 (ACT:SCP0009_Shipment_Plan_FG.GetDayRange) |
| WK-SCP0009-0027 | B3 | cboPlanType / Plan-type / Plan Type | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboPlanType / Plan-type / Plan Type | 있음(FE 소스) | 2 (ACT:SCP0009_Shipment_Plan_FG.Get_IsSaveY) |
| WK-SCP0009-0028 | B3 | clbCustomer / lEnd Customer / Customer | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbCustomer / lEnd Customer / Customer | 있음(FE 소스) | 1 (ACT:SCP0009_Shipment_Plan_FG.clbTeam_Sel) |
| WK-SCP0009-0029 | B3 | clbElecType / Electrode / Elec Type | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbElecType / Electrode / Elec Type | 있음(FE 소스) | 1 (clbElecType) |
| WK-SCP0009-0030 | B3 | clbTeam / Team  / Team | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbTeam / Team  / Team | 있음(FE 소스) | 2 (ACT:SCP0009_Shipment_Plan_FG.clbTeam_Sel) |

## W5 검사기 연결 (37)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0009-0031 | B4 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 3 (ACT:SCP0009_Shipment_Plan_FG.Get_IsSaveY) |
| WK-SCP0009-0032 | B4 | cboPlanDate / Plan-date / Plan Date | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboPlanDate / Plan-date / Plan Date | 있음(FE 소스) | 4 (ACT:SCP0009_Shipment_Plan_FG.GetDayRange) |
| WK-SCP0009-0033 | B4 | cboPlanType / Plan-type / Plan Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboPlanType / Plan-type / Plan Type | 있음(FE 소스) | 2 (ACT:SCP0009_Shipment_Plan_FG.Get_IsSaveY) |
| WK-SCP0009-0034 | B4 | clbCustomer / lEnd Customer / Customer | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbCustomer / lEnd Customer / Customer | 있음(FE 소스) | 1 (ACT:SCP0009_Shipment_Plan_FG.clbTeam_Sel) |
| WK-SCP0009-0035 | B4 | clbElecType / Electrode / Elec Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbElecType / Electrode / Elec Type | 있음(FE 소스) | 1 (clbElecType) |
| WK-SCP0009-0036 | B4 | clbTeam / Team  / Team | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbTeam / Team  / Team | 있음(FE 소스) | 2 (ACT:SCP0009_Shipment_Plan_FG.clbTeam_Sel) |
| WK-SCP0009-0037 | F2 | SCP0009 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0009 화면 | 판단불가(대상 단위 SCREEN) | 701 (`.cs:1040-1068` BtnFix_Click 가드체인 `.cs:3) |
| WK-SCP0009-0038 | F6 | SCP0009 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F6(_verify.spec(@verify)) → 대상 SCREEN SCP0009 화면 | 판단불가(대상 단위 SCREEN) | 683 (`.cs:1040-1068` BtnFix_Click 가드체인 `.cs:3) |
| WK-SCP0009-0039 | DB-SYN | DM0003_GET_BUCKET_TYPE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DM0003_GET_BUCKET_TYPE_CODE | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0009_Shipment_Plan_FG.GetBucketTy) |
| WK-SCP0009-0040 | DB-SYN | P_ACTIVE_FLAG | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_ACTIVE_FLAG | 없음(PROC_M 대응 없음) | 1 (`.cs:4271-4293` SaveData_FixInfo 사유 팝업(`) |
| WK-SCP0009-0041 | DB-SYN | P_SCP0009_FIX_SAVE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SCP0009_FIX_SAVE | 없음(PROC_M 대응 없음) | 1 (H1) |
| WK-SCP0009-0042 | DB-SYN | P_SCP0009_GET_SHIPMENT_PLAN_FG_PEGGING | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SCP0009_GET_SHIPMENT_PLAN_FG_PEGGING | 없음(PROC_M 대응 없음) | 1 (`SCM_ADM_PROC_M`) |
| WK-SCP0009-0043 | DB-SYN | P_SCP0009_GET_SHIP_PLAN_FG_TITLE_PARAL | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SCP0009_GET_SHIP_PLAN_FG_TITLE_PARAL | 없음(PROC_M 대응 없음) | 1 (M8) |
| WK-SCP0009-0044 | DB-SYN | P_SCP0009_SAVE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SCP0009_SAVE | 없음(PROC_M 대응 없음) | 2 (H1 M7) |
| WK-SCP0009-0045 | DB-SYN | P_SCP0009_SAVE_ANL_SHIP_FG_FIX_DATASET | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SCP0009_SAVE_ANL_SHIP_FG_FIX_DATASET | 없음(PROC_M 대응 없음) | 1 (`.cs:4271-4293` SaveData_FixInfo 사유 팝업(`) |
| WK-SCP0009-0046 | DB-SYN | P_SCP0009_TITLE_GET | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SCP0009_TITLE_GET | 없음(PROC_M 대응 없음) | 2 (`P_SCP0009_GET_SHEET_CALENDAR_3SPAN`(헤더)) |
| WK-SCP0009-0047 | DB-SYN | P_SCP0013_SAVE_YN_GET | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP P_SCP0013_SAVE_YN_GET | 없음(PROC_M 대응 없음) | 1 (`.cs:3661-3705` Get_IsSaveYn — Fix(1056)) |
| WK-SCP0009-0048 | DB-SYN | SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0009_Shipment_Plan_FG.GetLastRang) |
| WK-SCP0009-0049 | DB-SYN | SCP0009_GET_SHIPMENT_PLAN_FG_PEGGING | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0009_GET_SHIPMENT_PLAN_FG_PEGGING | 없음(PROC_M 대응 없음) | 3 (ACT:SCP0009_Shipment_Plan_FG.FindData_Pe) |
| WK-SCP0009-0050 | DB-SYN | SCP0009_GET_SHIPMENT_PLAN_FG_PROBLEM | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0009_GET_SHIPMENT_PLAN_FG_PROBLEM | 없음(PROC_M 대응 없음) | 3 (ACT:SCP0009_Shipment_Plan_FG.FindData_Pl) |
| WK-SCP0009-0051 | DB-SYN | SCP0009_GET_SHIPMENT_PLAN_FG_TITLE_PARAL | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0009_GET_SHIPMENT_PLAN_FG_TITLE_PARAL | 없음(PROC_M 대응 없음) | 8 (ACT:SCP0009_Shipment_Plan_FG.FindData_Ma) |
| WK-SCP0009-0052 | DB-SYN | SCP0009_SAVE_ANL_SHIPMENT_PLAN_FG_FIX_DA | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0009_SAVE_ANL_SHIPMENT_PLAN_FG_FIX_DATASET | 없음(PROC_M 대응 없음) | 1 (ACT:SCP0009_Shipment_Plan_FG.SaveData_Fi) |
| WK-SCP0009-0053 | DB-SYN | SCP0009_SAVE_ANL_SHIPMENT_PLAN_FG_WEEKLY | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0009_SAVE_ANL_SHIPMENT_PLAN_FG_WEEKLY | 없음(PROC_M 대응 없음) | 1 (ACT:SCP0009_Shipment_Plan_FG.SaveData_Ma) |
| WK-SCP0009-0054 | DB-SYN | SCP0013_GET_PLAN_TYPE_SAVE_YN | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0013_GET_PLAN_TYPE_SAVE_YN | 없음(PROC_M 대응 없음) | 4 (M9 ACT:SCP0009_Shipment_Plan_FG.Get_IsSa) |
| WK-SCP0009-0055 | G4 | btnColumn | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnColumn | 있음(FE 소스) | 2 (ACT:SCP0009_Shipment_Plan_FG.InitEvent A) |
| WK-SCP0009-0056 | G4 | btnFix | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnFix | 없음 | 2 (ACT:SCP0009_Shipment_Plan_FG.InitEvent A) |
| WK-SCP0009-0057 | G4 | btnItem | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItem | 없음 | 3 (btnItem_Id/txtItem_Id ACT:SCP0009_Shipme) |
| WK-SCP0009-0058 | G4 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnMeasure | 있음(FE 소스) | 2 (ACT:SCP0009_Shipment_Plan_FG.InitEvent A) |
| WK-SCP0009-0059 | G4 | btnNew | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnNew | 있음(FE 소스) | 2 (ACT:SCP0009_Shipment_Plan_FG.InitEvent A) |
| WK-SCP0009-0060 | G4 | btnProject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnProject | 있음(FE 소스) | 3 (btnProject/txtProject ACT:SCP0009_Shipme) |
| WK-SCP0009-0061 | G4 | btnUnfix | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnUnfix | 없음 | 2 (ACT:SCP0009_Shipment_Plan_FG.InitEvent A) |
| WK-SCP0009-0062 | G4 | btnW26 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnW26 | 없음 | 2 (ACT:SCP0009_Shipment_Plan_FG.InitEvent A) |
| WK-SCP0009-0063 | G4 | btnW52 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnW52 | 없음 | 2 (ACT:SCP0009_Shipment_Plan_FG.InitEvent A) |
| WK-SCP0009-0064 | G4 | btnWLast | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnWLast | 있음(FE 소스) | 5 (ACT:SCP0009_Shipment_Plan_FG.InitControl) |
| WK-SCP0009-0065 | G03-WIRE | SCP0009 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0009 화면 | 판단불가(대상 단위 SCREEN) | 25 (ACT:SCP0009_Shipment_Plan_FG..ctor ACT:S) |
| WK-SCP0009-0066 | G5 | cboBucketType / Bucket / Bucket Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 3 (ACT:SCP0009_Shipment_Plan_FG.SpdMain_Cel) |
| WK-SCP0009-0067 | G5 | chkAll / ALL / All | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND chkAll / ALL / All | 있음(FE 소스) | 7 (`ShipmentPlanFg.tsx` `components/Shipmen) |

## W6 검증 실행 (142)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0009-0068 | J2 | SCP0009 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0009 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 184 (`.cs:1040-1068` BtnFix_Click 가드체인 `.cs:3) |
| WK-SCP0009-0069 | C1 | cboBizType / Operation Group / Biz Type  | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboBizType / Operation Group / Biz Type / Operatio · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 3 (ACT:SCP0009_Shipment_Plan_FG.InitControl) |
| WK-SCP0009-0070 | C1 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0009_Shipment_Plan_FG.InitControl) |
| WK-SCP0009-0071 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0009_Shipment_Plan_FG.InitControl) |
| WK-SCP0009-0072 | C1 | cboPlanDate / Plan-date / Plan Date | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0009_Shipment_Plan_FG.RefreshPlan) |
| WK-SCP0009-0073 | C1 | cboPlanSeq / Seq / Plan Seq / Seq. | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboPlanSeq / Seq / Plan Seq / Seq. · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0009_Shipment_Plan_FG.RefreshPlan) |
| WK-SCP0009-0074 | C1 | cboPlanType / Plan-type / Plan Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboPlanType / Plan-type / Plan Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0009_Shipment_Plan_FG.RefreshPlan) |
| WK-SCP0009-0075 | C1 | clbCustomer / lEnd Customer / Customer | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbCustomer / lEnd Customer / Customer · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:SCP0009_Shipment_Plan_FG.clbTeam_Sel) |
| WK-SCP0009-0076 | C1 | clbElecType / Electrode / Elec Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbElecType / Electrode / Elec Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0009_Shipment_Plan_FG.InitControl) |
| WK-SCP0009-0077 | C1 | clbFromSite / From Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbFromSite / From Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0009_Shipment_Plan_FG.RefreshFrom) |
| WK-SCP0009-0078 | C1 | clbTeam / Team  / Team | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbTeam / Team  / Team · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:SCP0009_Shipment_Plan_FG.InitControl) |
| WK-SCP0009-0079 | C1 | clbToSite / To Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbToSite / To Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:SCP0009_Shipment_Plan_FG.RefreshToSi) |
| WK-SCP0009-0080 | G3 | SCP0009 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0009 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 1 (`usrConditionPanel1`(HidePanel)) |
| WK-SCP0009-0081 | K-SA | SCP0009 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCP0009 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 1 (`usrConditionPanel1`(HidePanel)) |
| WK-SCP0009-0082 | K4 | SCP0009 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0009 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 112 (ACT:SCP0009_Shipment_Plan_FG.BtnColumn_C) |
| WK-SCP0009-0083 | F1 | SCP0009 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0009 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 712 (`.cs:1040-1068` BtnFix_Click 가드체인 `.cs:3) |
| WK-SCP0009-0084 | F5 | SCP0009 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0009 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 14 (`.cs:4271-4293` SaveData_FixInfo 사유 팝업(`) |
| WK-SCP0009-0085 | F4 | DM0003_GET_BUCKET_TYPE_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DM0003_GET_BUCKET_TYPE_CODE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:SCP0009_Shipment_Plan_FG.GetBucketTy) |
| WK-SCP0009-0086 | F4 | PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: |  | 3 (dCalendar + W26/W52/WLast ACT:SCP0009_Sh) |
| WK-SCP0009-0087 | F4 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) —  |  | 918 (`P_SCP0009_GET_SHEET_CALENDAR_3SPAN`(헤더)) |
| WK-SCP0009-0088 | F4 | PKG_SCP0009.P_SCP0009_GET_SHIPMENT_PLAN_ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0009.P_SCP0009_GET_SHIPMENT_PLAN_FG · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필 |  | 843 (H1 PROC_M(파라미터 메타) ACT:SCP0009_Shipment_) |
| WK-SCP0009-0089 | F4 | PKG_SCP0013.P_SCP0013_GET_PLAN_SAVE_YN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0013.P_SCP0013_GET_PLAN_SAVE_YN · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 2 (`.cs:3661-3705` Get_IsSaveYn — Fix(1056)) |
| WK-SCP0009-0090 | F4 | P_ACTIVE_FLAG | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_ACTIVE_FLAG · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (`.cs:4271-4293` SaveData_FixInfo 사유 팝업(`) |
| WK-SCP0009-0091 | F4 | P_SCP0009_FIX_SAVE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_SCP0009_FIX_SAVE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (H1) |
| WK-SCP0009-0092 | F4 | P_SCP0009_GET_SHIPMENT_PLAN_FG_PEGGING | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_SCP0009_GET_SHIPMENT_PLAN_FG_PEGGING · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 1 (`SCM_ADM_PROC_M`) |
| WK-SCP0009-0093 | F4 | P_SCP0009_GET_SHIP_PLAN_FG_TITLE_PARAL | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_SCP0009_GET_SHIP_PLAN_FG_TITLE_PARAL · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 1 (M8) |
| WK-SCP0009-0094 | F4 | P_SCP0009_SAVE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_SCP0009_SAVE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (H1 M7) |
| WK-SCP0009-0095 | F4 | P_SCP0009_SAVE_ANL_SHIP_FG_FIX_DATASET | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_SCP0009_SAVE_ANL_SHIP_FG_FIX_DATASET · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 1 (`.cs:4271-4293` SaveData_FixInfo 사유 팝업(`) |
| WK-SCP0009-0096 | F4 | P_SCP0009_TITLE_GET | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_SCP0009_TITLE_GET · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (`P_SCP0009_GET_SHEET_CALENDAR_3SPAN`(헤더)) |
| WK-SCP0009-0097 | F4 | P_SCP0013_SAVE_YN_GET | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — P_SCP0013_SAVE_YN_GET · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (`.cs:3661-3705` Get_IsSaveYn — Fix(1056)) |
| WK-SCP0009-0098 | F4 | SCM0001_GET_SCP_DAILY_PLAN_PERIOD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_SCP_DAILY_PLAN_PERIOD · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke· |  | 2 (ACT:SCP0009_Shipment_Plan_FG.GetLastRang) |
| WK-SCP0009-0099 | F4 | SCP0009_GET_SHIPMENT_PLAN_FG_PEGGING | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0009_GET_SHIPMENT_PLAN_FG_PEGGING · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smo |  | 44 (ACT:SCP0009_Shipment_Plan_FG.FindData_Pe) |
| WK-SCP0009-0100 | F4 | SCP0009_GET_SHIPMENT_PLAN_FG_PROBLEM | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0009_GET_SHIPMENT_PLAN_FG_PROBLEM · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smo |  | 37 (ACT:SCP0009_Shipment_Plan_FG.FindData_Pl) |
| WK-SCP0009-0101 | F4 | SCP0009_GET_SHIPMENT_PLAN_FG_TITLE_PARAL | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0009_GET_SHIPMENT_PLAN_FG_TITLE_PARAL · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: |  | 839 (ACT:SCP0009_Shipment_Plan_FG.FindButton ) |
| WK-SCP0009-0102 | F4 | SCP0009_SAVE_ANL_SHIPMENT_PLAN_FG_FIX_DA | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0009_SAVE_ANL_SHIPMENT_PLAN_FG_FIX_DATASET · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실 |  | 237 (ACT:SCP0009_Shipment_Plan_FG.SaveData_Fi) |
| WK-SCP0009-0103 | F4 | SCP0009_SAVE_ANL_SHIPMENT_PLAN_FG_WEEKLY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0009_SAVE_ANL_SHIPMENT_PLAN_FG_WEEKLY · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: |  | 435 (ACT:SCP0009_Shipment_Plan_FG.SaveButton ) |
| WK-SCP0009-0104 | F4 | SCP0013_GET_PLAN_TYPE_SAVE_YN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0013_GET_PLAN_TYPE_SAVE_YN · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trac |  | 437 (M9 ACT:SCP0009_Shipment_Plan_FG.Get_IsSa) |
| WK-SCP0009-0105 | G4 | cboBizType / Operation Group / Biz Type  | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboBizType / Operation Group / Biz Type / Operatio · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 7 (cboBizType ACT:SCP0009_Shipment_Plan_FG.) |
| WK-SCP0009-0106 | G4 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 7 (cboBucketType ACT:SCP0009_Shipment_Plan_) |
| WK-SCP0009-0107 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 8 (cboDivision ACT:SCP0009_Shipment_Plan_FG) |
| WK-SCP0009-0108 | G4 | cboPlanDate / Plan-date / Plan Date | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (cboPlanDate/Type/Seq ACT:SCP0009_Shipmen) |
| WK-SCP0009-0109 | G4 | cboPlanSeq / Seq / Plan Seq / Seq. | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboPlanSeq / Seq / Plan Seq / Seq. · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0009_Shipment_Plan_FG.InitControl) |
| WK-SCP0009-0110 | G4 | cboPlanType / Plan-type / Plan Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboPlanType / Plan-type / Plan Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0009_Shipment_Plan_FG.InitControl) |
| WK-SCP0009-0111 | G4 | chkAll / ALL / All | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkAll / ALL / All · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (chkAll) |
| WK-SCP0009-0112 | G4 | chkSum / Sum | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkSum / Sum · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (chkSum) |
| WK-SCP0009-0113 | G4 | clbCustomer / lEnd Customer / Customer | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbCustomer / lEnd Customer / Customer · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (clbCustomer) |
| WK-SCP0009-0114 | G4 | clbElecType / Electrode / Elec Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbElecType / Electrode / Elec Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (clbElecType ACT:SCP0009_Shipment_Plan_FG) |
| WK-SCP0009-0115 | G4 | clbFromSite / From Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbFromSite / From Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (clbFromSite) |
| WK-SCP0009-0116 | G4 | clbTeam / Team  / Team | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbTeam / Team  / Team · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (clbTeam ACT:SCP0009_Shipment_Plan_FG.Ini) |
| WK-SCP0009-0117 | G4 | clbToSite / To Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbToSite / To Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (clbToSite) |
| WK-SCP0009-0118 | G4 | txtItem_Id / Model / Item_Id / Model/Nic | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtItem_Id / Model / Item_Id / Model/Nickname · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (btnItem_Id/txtItem_Id) |
| WK-SCP0009-0119 | G4 | txtProject / Project / PJT | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtProject / Project / PJT · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (btnProject/txtProject) |
| WK-SCP0009-0120 | H4 | SCP0009 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — SCP0009 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 4 (ACT:SCP0009_Shipment_Plan_FG.SpdMain_Top) |
| WK-SCP0009-0121 | H5 | cboBucketType / Bucket / Bucket Type | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) —  |  | 18 (cboBucketType ACT:SCP0009_Shipment_Plan_) |
| WK-SCP0009-0122 | H5 | cboDivision / Division | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — cboDivision / Division · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCP0009_Shipment_Plan_FG.SetSpreadCo) |
| WK-SCP0009-0123 | H5 | chkAll / ALL / All | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — chkAll / ALL / All · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (chkAll off 시 그리드 비움+재조회 필요(§2.4 예외) H6 M) |
| WK-SCP0009-0124 | H5 | chkSum / Sum | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — chkSum / Sum · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 5 (chkSum Bucket×chkSum→visible(§2.4) ACT:S) |
| WK-SCP0009-0125 | I1 | SCP0009 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0009 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 42 (`.cs:3661-3705` Get_IsSaveYn — Fix(1056)) |
| WK-SCP0009-0126 | SC1 | SCP0009 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SCP0009 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 19 (`.cs:4296-4561` SaveData_FixInfo 대상 수집(2) |
| WK-SCP0009-0127 | D6 | SCP0009 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0009 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 4 (가드 메시지 ID(2026-10-06 정정) M3 A C) |
| WK-SCP0009-0128 | E4 | MSG00002 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00002 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (저장 성공 토스트 메시지 ID(2026-10-06 정정) 메시지 ID 정) |
| WK-SCP0009-0129 | E4 | MSG00003 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00003 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0009_Shipment_Plan_FG.SaveData_Fi) |
| WK-SCP0009-0130 | E4 | MSG00004 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00004 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (저장 성공 토스트 메시지 ID(2026-10-06 정정) 메시지 ID 정) |
| WK-SCP0009-0131 | E4 | MSG00010 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00010 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (가드 메시지 ID(2026-10-06 정정) 메시지 ID 정정 ACT:S) |
| WK-SCP0009-0132 | E4 | MSG00016 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00016 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (`.cs:1070-1102` BtnUnfix_Click(+MSG00016) |
| WK-SCP0009-0133 | E4 | MSG00017 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00017 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0009_Shipment_Plan_FG.ValidateUse) |
| WK-SCP0009-0134 | E4 | MSG00026 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00026 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0009_Shipment_Plan_FG.SaveData_Fi) |
| WK-SCP0009-0135 | E4 | MSG00046 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00046 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0009_Shipment_Plan_FG.SaveData_Fi) |
| WK-SCP0009-0136 | E4 | MSG00059 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00059 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0009_Shipment_Plan_FG.ValidateUse) |
| WK-SCP0009-0137 | E4 | MSG00084 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00084 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (저장 검증(MSG00084/MSG00317) ACT:SCP0009_Shi) |
| WK-SCP0009-0138 | E4 | MSG00096 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00096 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (가드 메시지 ID(2026-10-06 정정) `.cs:1105-1164`) |
| WK-SCP0009-0139 | E4 | MSG00134 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00134 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (`.cs:1070-1102` BtnUnfix_Click(+MSG00016) |
| WK-SCP0009-0140 | E4 | MSG00171 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00171 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0009_Shipment_Plan_FG.ValidateUse) |
| WK-SCP0009-0141 | E4 | MSG00172 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00172 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0009_Shipment_Plan_FG.ValidateUse) |
| WK-SCP0009-0142 | E4 | MSG00182 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00182 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (`.cs:3661-3705` Get_IsSaveYn — Fix(1056)) |
| WK-SCP0009-0143 | E4 | MSG00233 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00233 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0009_Shipment_Plan_FG.ValidateUse) |
| WK-SCP0009-0144 | E4 | MSG00252 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00252 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0009_Shipment_Plan_FG.SaveData_Fi) |
| WK-SCP0009-0145 | E4 | MSG00265 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00265 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0009_Shipment_Plan_FG.BtnNew_Clic) |
| WK-SCP0009-0146 | E4 | MSG00317 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00317 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (저장 검증(MSG00084/MSG00317) ACT:SCP0009_Shi) |
| WK-SCP0009-0147 | E4 | MSG00412 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00412 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0009_Shipment_Plan_FG.CheckMandat) |
| WK-SCP0009-0148 | E4 | MSG01046 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01046 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (가드 메시지 ID(2026-10-06 정정) 메시지 ID 정정) |
| WK-SCP0009-0149 | E4 | MSG01059 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01059 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (`.cs:4296-4561` SaveData_FixInfo 대상 수집(2) |
| WK-SCP0009-0150 | E4 | MSG01078 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01078 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (`.cs:1070-1102` BtnUnfix_Click(+MSG00016) |
| WK-SCP0009-0151 | E4 | MSG01273 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01273 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (`.cs:1105-1164` BtnNew_Click(+팝업)) |
| WK-SCP0009-0152 | E4 | MSG01438 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG01438 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (`.cs:1070-1102` BtnUnfix_Click(+MSG00016) |
| WK-SCP0009-0153 | E4 | cboBizType / Operation Group / Biz Type  | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboBizType / Operation Group / Biz Type / Operatio · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요 |  | 2 (ACT:SCP0009_Shipment_Plan_FG.SetOperatio) |
| WK-SCP0009-0154 | E4 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 |  | 26 (ACT:SCP0009_Shipment_Plan_FG.SaveData_Ma) |
| WK-SCP0009-0155 | E4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 13 (ACT:SCP0009_Shipment_Plan_FG.SetChangedC) |
| WK-SCP0009-0156 | E4 | cboPlanSeq / Seq / Plan Seq / Seq. | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboPlanSeq / Seq / Plan Seq / Seq. · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시 |  | 12 (ACT:SCP0009_Shipment_Plan_FG.Set_FixButt) |
| WK-SCP0009-0157 | E4 | cboPlanType / Plan-type / Plan Type | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboPlanType / Plan-type / Plan Type · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장  |  | 2 (ACT:SCP0009_Shipment_Plan_FG.Set_FixButt) |
| WK-SCP0009-0158 | E4 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SCP0009_Shipment_Plan_FG.SetSpreadCo) |
| WK-SCP0009-0159 | E4 | clbElecType / Electrode / Elec Type | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbElecType / Electrode / Elec Type · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장  |  | 4 (ACT:SCP0009_Shipment_Plan_FG.SetChangedC) |
| WK-SCP0009-0160 | A10 | SCP0009 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0009 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 168 (ACT:SCP0009_Shipment_Plan_FG.DefinePrope) |
| WK-SCP0009-0161 | A6 | PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회)  |  | 1 (dCalendar + W26/W52/WLast) |
| WK-SCP0009-0162 | A6 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새 |  | 246 (`P_SCP0009_GET_SHEET_CALENDAR_3SPAN`(헤더)) |
| WK-SCP0009-0163 | A6 | PKG_SCP0009.P_SCP0009_GET_SHIPMENT_PLAN_ | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0009.P_SCP0009_GET_SHIPMENT_PLAN_FG · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회 |  | 173 (H1 PROC_M(파라미터 메타) ACT:SCP0009_Shipment_) |
| WK-SCP0009-0164 | A6 | PKG_SCP0013.P_SCP0013_GET_PLAN_SAVE_YN | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0013.P_SCP0013_GET_PLAN_SAVE_YN · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) ·  |  | 2 (`.cs:3661-3705` Get_IsSaveYn — Fix(1056)) |
| WK-SCP0009-0165 | A6 | P_SCP0009_FIX_SAVE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_SCP0009_FIX_SAVE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 1 (H1) |
| WK-SCP0009-0166 | A6 | P_SCP0009_GET_SHIPMENT_PLAN_FG_PEGGING | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_SCP0009_GET_SHIPMENT_PLAN_FG_PEGGING · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) ·  |  | 1 (`SCM_ADM_PROC_M`) |
| WK-SCP0009-0167 | A6 | P_SCP0009_GET_SHIP_PLAN_FG_TITLE_PARAL | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_SCP0009_GET_SHIP_PLAN_FG_TITLE_PARAL · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) ·  |  | 1 (M8) |
| WK-SCP0009-0168 | A6 | P_SCP0009_SAVE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_SCP0009_SAVE · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 1 (H1) |
| WK-SCP0009-0169 | A6 | P_SCP0009_TITLE_GET | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_SCP0009_TITLE_GET · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 2 (`P_SCP0009_GET_SHEET_CALENDAR_3SPAN`(헤더)) |
| WK-SCP0009-0170 | A6 | P_SCP0013_SAVE_YN_GET | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — P_SCP0013_SAVE_YN_GET · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trac |  | 1 (`.cs:3661-3705` Get_IsSaveYn — Fix(1056)) |
| WK-SCP0009-0171 | A6 | SCP0009_GET_SHIPMENT_PLAN_FG_PEGGING | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SCP0009_GET_SHIPMENT_PLAN_FG_PEGGING · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _t |  | 44 (ACT:SCP0009_Shipment_Plan_FG.FindData_Pe) |
| WK-SCP0009-0172 | A6 | SCP0009_GET_SHIPMENT_PLAN_FG_PROBLEM | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SCP0009_GET_SHIPMENT_PLAN_FG_PROBLEM · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _t |  | 37 (ACT:SCP0009_Shipment_Plan_FG.FindData_Pl) |
| WK-SCP0009-0173 | A6 | SCP0009_GET_SHIPMENT_PLAN_FG_TITLE_PARAL | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SCP0009_GET_SHIPMENT_PLAN_FG_TITLE_PARAL · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회)  |  | 169 (ACT:SCP0009_Shipment_Plan_FG.FindButton ) |
| WK-SCP0009-0174 | A6 | SCP0013_GET_PLAN_TYPE_SAVE_YN | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SCP0013_GET_PLAN_TYPE_SAVE_YN · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.sp |  | 1 (M9) |
| WK-SCP0009-0175 | G1 | cboBizType / Operation Group / Biz Type  | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboBizType / Operation Group / Biz Type / Operatio · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (cboBizType ACT:SCP0009_Shipment_Plan_FG.) |
| WK-SCP0009-0176 | G1 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (cboBucketType ACT:SCP0009_Shipment_Plan_) |
| WK-SCP0009-0177 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (cboDivision ACT:SCP0009_Shipment_Plan_FG) |
| WK-SCP0009-0178 | G1 | cboPlanDate / Plan-date / Plan Date | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (cboPlanDate/Type/Seq ACT:SCP0009_Shipmen) |
| WK-SCP0009-0179 | G1 | cboPlanSeq / Seq / Plan Seq / Seq. | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboPlanSeq / Seq / Plan Seq / Seq. · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0009_Shipment_Plan_FG.FindData_Ma) |
| WK-SCP0009-0180 | G1 | cboPlanType / Plan-type / Plan Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboPlanType / Plan-type / Plan Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0009_Shipment_Plan_FG.FindData_Ma) |
| WK-SCP0009-0181 | G1 | chkAll / ALL / All | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — chkAll / ALL / All · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 7 (chkAll chkAll off 시 그리드 비움+재조회 필요(§2.4 예) |
| WK-SCP0009-0182 | G1 | chkSum / Sum | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — chkSum / Sum · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (chkSum) |
| WK-SCP0009-0183 | G1 | clbCustomer / lEnd Customer / Customer | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbCustomer / lEnd Customer / Customer · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (clbCustomer) |
| WK-SCP0009-0184 | G1 | clbElecType / Electrode / Elec Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbElecType / Electrode / Elec Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (clbElecType ACT:SCP0009_Shipment_Plan_FG) |
| WK-SCP0009-0185 | G1 | clbFromSite / From Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbFromSite / From Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (clbFromSite ACT:SCP0009_Shipment_Plan_FG) |
| WK-SCP0009-0186 | G1 | clbTeam / Team  / Team | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbTeam / Team  / Team · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (clbTeam ACT:SCP0009_Shipment_Plan_FG.Fin) |
| WK-SCP0009-0187 | G1 | clbToSite / To Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbToSite / To Site · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (clbToSite ACT:SCP0009_Shipment_Plan_FG.F) |
| WK-SCP0009-0188 | G1 | txtItem_Id / Model / Item_Id / Model/Nic | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItem_Id / Model / Item_Id / Model/Nickname · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (btnItem_Id/txtItem_Id ACT:SCP0009_Shipme) |
| WK-SCP0009-0189 | G1 | txtProject / Project / PJT | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtProject / Project / PJT · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (btnProject/txtProject ACT:SCP0009_Shipme) |
| WK-SCP0009-0190 | G6 | cboBizType / Operation Group / Biz Type  | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboBizType / Operation Group / Biz Type / Operatio · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 7 (cboBizType ACT:SCP0009_Shipment_Plan_FG.) |
| WK-SCP0009-0191 | G6 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 7 (cboBucketType ACT:SCP0009_Shipment_Plan_) |
| WK-SCP0009-0192 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 8 (cboDivision ACT:SCP0009_Shipment_Plan_FG) |
| WK-SCP0009-0193 | G6 | cboPlanDate / Plan-date / Plan Date | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (cboPlanDate/Type/Seq ACT:SCP0009_Shipmen) |
| WK-SCP0009-0194 | G6 | cboPlanSeq / Seq / Plan Seq / Seq. | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboPlanSeq / Seq / Plan Seq / Seq. · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCP0009_Shipment_Plan_FG.InitControl) |
| WK-SCP0009-0195 | G6 | cboPlanType / Plan-type / Plan Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboPlanType / Plan-type / Plan Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCP0009_Shipment_Plan_FG.InitControl) |
| WK-SCP0009-0196 | G6 | chkAll / ALL / All | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — chkAll / ALL / All · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (chkAll) |
| WK-SCP0009-0197 | G6 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (chkSum) |
| WK-SCP0009-0198 | G6 | clbCustomer / lEnd Customer / Customer | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbCustomer / lEnd Customer / Customer · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (clbCustomer) |
| WK-SCP0009-0199 | G6 | clbElecType / Electrode / Elec Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbElecType / Electrode / Elec Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (clbElecType ACT:SCP0009_Shipment_Plan_FG) |
| WK-SCP0009-0200 | G6 | clbFromSite / From Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbFromSite / From Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (clbFromSite) |
| WK-SCP0009-0201 | G6 | clbTeam / Team  / Team | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbTeam / Team  / Team · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (clbTeam ACT:SCP0009_Shipment_Plan_FG.Ini) |
| WK-SCP0009-0202 | G6 | clbToSite / To Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbToSite / To Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (clbToSite) |
| WK-SCP0009-0203 | G6 | txtItem_Id / Model / Item_Id / Model/Nic | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtItem_Id / Model / Item_Id / Model/Nickname · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (btnItem_Id/txtItem_Id) |
| WK-SCP0009-0204 | G6 | txtProject / Project / PJT | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtProject / Project / PJT · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (btnProject/txtProject) |
| WK-SCP0009-0205 | X-REOPEN | SCP0009 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0009 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 17 (ACT:SCP0009_Shipment_Plan_FG.Dispose ACT) |
| WK-SCP0009-0206 | H6 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 3 (ACT:SCP0009_Shipment_Plan_FG.SpdMain_Cel) |
| WK-SCP0009-0207 | H6 | chkAll / ALL / All | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — chkAll / ALL / All · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 7 (`ShipmentPlanFg.tsx` `components/Shipmen) |
| WK-SCP0009-0208 | M4 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (ACT:SCP0009_Shipment_Plan_FG.SpdMain_Cel) |
| WK-SCP0009-0209 | M4 | chkAll / ALL / All | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — chkAll / ALL / All · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 7 (`ShipmentPlanFg.tsx` `components/Shipmen) |

## W7 기대값 확정 (352)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0009-0210 | C1 | `.cs:1211-1218` CboDivision_SelectedInde | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — `.cs:1211-1218` CboDivision_SelectedIndexChanged→b: 행 집계 — C1 11요소: NOT_RUN:11 (미실행 요소가 남아 판정필요) |  | 1 (`.cs:1211-1218` CboDivision_SelectedInde) |
| WK-SCP0009-0211 | B3 | SCP0009_Shipment_Plan_FG.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0009_Shipment_Plan_FG.GetBucketType: 진입점 집계 — B3 6요소: TODO:6 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0009_Shipment_Plan_FG.GetBucketTy) |
| WK-SCP0009-0212 | B3 | SCP0009_Shipment_Plan_FG.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0009_Shipment_Plan_FG.GetDayRange: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0009_Shipment_Plan_FG.GetDayRange) |
| WK-SCP0009-0213 | B3 | SCP0009_Shipment_Plan_FG.GetErrorMandato | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0009_Shipment_Plan_FG.GetErrorMandatorySheetCol: 진입점 집계 — B3 6요소: TODO:6 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0009_Shipment_Plan_FG.GetErrorMan) |
| WK-SCP0009-0214 | B3 | SCP0009_Shipment_Plan_FG.GetFilterStr | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0009_Shipment_Plan_FG.GetFilterStr: 진입점 집계 — B3 6요소: TODO:6 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0009_Shipment_Plan_FG.GetFilterSt) |
| WK-SCP0009-0215 | B3 | SCP0009_Shipment_Plan_FG.GetIsEditable | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0009_Shipment_Plan_FG.GetIsEditable: 진입점 집계 — B3 6요소: TODO:6 (미실행 요소가 남아 판정필요) |  | 38 (ACT:SCP0009_Shipment_Plan_FG.GetIsEditab) |
| WK-SCP0009-0216 | B3 | SCP0009_Shipment_Plan_FG.GetLastRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0009_Shipment_Plan_FG.GetLastRange: 진입점 집계 — B3 6요소: TODO:6 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0009_Shipment_Plan_FG.GetLastRang) |
| WK-SCP0009-0217 | B3 | SCP0009_Shipment_Plan_FG.GetNewInsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0009_Shipment_Plan_FG.GetNewInsertRowIndex: 진입점 집계 — B3 6요소: TODO:6 (미실행 요소가 남아 판정필요) |  | 22 (ACT:SCP0009_Shipment_Plan_FG.GetNewInser) |
| WK-SCP0009-0218 | B3 | SCP0009_Shipment_Plan_FG.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0009_Shipment_Plan_FG.GetSpdTitle: 진입점 집계 — B3 6요소: TODO:6 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0009_Shipment_Plan_FG.GetSpdTitle) |
| WK-SCP0009-0219 | B3 | SCP0009_Shipment_Plan_FG.Get_IsSaveYn | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0009_Shipment_Plan_FG.Get_IsSaveYn: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SCP0009_Shipment_Plan_FG.Get_IsSaveY) |
| WK-SCP0009-0220 | B3 | 콤보/Lookup 메타(2.76) | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — 콤보/Lookup 메타(2.76): 행 집계 — B3 6요소: TODO:6 (미실행 요소가 남아 판정필요) |  | 1 (콤보/Lookup 메타(2.76)) |
| WK-SCP0009-0221 | B4 | SCP0009_Shipment_Plan_FG.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0009_Shipment_Plan_FG.GetBucketType: 진입점 집계 — B4 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0009_Shipment_Plan_FG.GetBucketTy) |
| WK-SCP0009-0222 | B4 | SCP0009_Shipment_Plan_FG.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0009_Shipment_Plan_FG.GetDayRange: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0009_Shipment_Plan_FG.GetDayRange) |
| WK-SCP0009-0223 | B4 | SCP0009_Shipment_Plan_FG.GetErrorMandato | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0009_Shipment_Plan_FG.GetErrorMandatorySheetCol: 진입점 집계 — B4 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0009_Shipment_Plan_FG.GetErrorMan) |
| WK-SCP0009-0224 | B4 | SCP0009_Shipment_Plan_FG.GetFilterStr | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0009_Shipment_Plan_FG.GetFilterStr: 진입점 집계 — B4 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0009_Shipment_Plan_FG.GetFilterSt) |
| WK-SCP0009-0225 | B4 | SCP0009_Shipment_Plan_FG.GetIsEditable | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0009_Shipment_Plan_FG.GetIsEditable: 진입점 집계 — B4 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 38 (ACT:SCP0009_Shipment_Plan_FG.GetIsEditab) |
| WK-SCP0009-0226 | B4 | SCP0009_Shipment_Plan_FG.GetLastRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0009_Shipment_Plan_FG.GetLastRange: 진입점 집계 — B4 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0009_Shipment_Plan_FG.GetLastRang) |
| WK-SCP0009-0227 | B4 | SCP0009_Shipment_Plan_FG.GetNewInsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0009_Shipment_Plan_FG.GetNewInsertRowIndex: 진입점 집계 — B4 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 22 (ACT:SCP0009_Shipment_Plan_FG.GetNewInser) |
| WK-SCP0009-0228 | B4 | SCP0009_Shipment_Plan_FG.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0009_Shipment_Plan_FG.GetSpdTitle: 진입점 집계 — B4 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0009_Shipment_Plan_FG.GetSpdTitle) |
| WK-SCP0009-0229 | B4 | SCP0009_Shipment_Plan_FG.Get_IsSaveYn | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0009_Shipment_Plan_FG.Get_IsSaveYn: 진입점 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SCP0009_Shipment_Plan_FG.Get_IsSaveY) |
| WK-SCP0009-0230 | B4 | 콤보/Lookup 메타(2.76) | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — 콤보/Lookup 메타(2.76): 행 집계 — B4 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (콤보/Lookup 메타(2.76)) |
| WK-SCP0009-0231 | DB-SYN | G2(구 H1) 저장 SP 실행 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — G2(구 H1) 저장 SP 실행: 행 집계 — DB-SYN 20요소: NOPATH:16 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (G2(구 H1) 저장 SP 실행) |
| WK-SCP0009-0232 | DB-SYN | SCP0009_Shipment_Plan_FG.SCM_SYS_LOG_BAT | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — SCP0009_Shipment_Plan_FG.SCM_SYS_LOG_BATCH: 진입점 집계 — DB-SYN 20요소: NOPATH:16 · PASS:4 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0009_Shipment_Plan_FG.SCM_SYS_LOG) |
| WK-SCP0009-0233 | DB-SYN | `.cs:1040-1068` BtnFix_Click 가드체인 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — `.cs:1040-1068` BtnFix_Click 가드체인: 행 집계 — DB-SYN 20요소: NOPATH:16 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (`.cs:1040-1068` BtnFix_Click 가드체인) |
| WK-SCP0009-0234 | DB-SYN | `.cs:1314-1316` SaveButton → `SaveData_M | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — `.cs:1314-1316` SaveButton → `SaveData_Main`(.cs:2: 행 집계 — DB-SYN 20요소: NOPATH:16 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (`.cs:1314-1316` SaveButton → `SaveData_M) |
| WK-SCP0009-0235 | DB-SYN | `.cs:4296-4561` SaveData_FixInfo 대상 수집(2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — `.cs:4296-4561` SaveData_FixInfo 대상 수집(2026-10-06): 행 집계 — DB-SYN 20요소: NOPATH:16 · PASS:4 (미실행 요소가 남아 판정필요) |  | 1 (`.cs:4296-4561` SaveData_FixInfo 대상 수집(2) |
| WK-SCP0009-0236 | F4 | G2(구 H1) 저장 SP 실행 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — G2(구 H1) 저장 SP 실행: 행 집계 — F4 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (G2(구 H1) 저장 SP 실행) |
| WK-SCP0009-0237 | F4 | SCP0009_Shipment_Plan_FG.SCM_SYS_LOG_BAT | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — SCP0009_Shipment_Plan_FG.SCM_SYS_LOG_BATCH: 진입점 집계 — F4 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0009_Shipment_Plan_FG.SCM_SYS_LOG) |
| WK-SCP0009-0238 | F4 | `.cs:1040-1068` BtnFix_Click 가드체인 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — `.cs:1040-1068` BtnFix_Click 가드체인: 행 집계 — F4 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (`.cs:1040-1068` BtnFix_Click 가드체인) |
| WK-SCP0009-0239 | F4 | `.cs:1314-1316` SaveButton → `SaveData_M | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — `.cs:1314-1316` SaveButton → `SaveData_Main`(.cs:2: 행 집계 — F4 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (`.cs:1314-1316` SaveButton → `SaveData_M) |
| WK-SCP0009-0240 | F4 | `.cs:4296-4561` SaveData_FixInfo 대상 수집(2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — `.cs:4296-4561` SaveData_FixInfo 대상 수집(2026-10-06): 행 집계 — F4 20요소: NOT_RUN:20 (미실행 요소가 남아 판정필요) |  | 1 (`.cs:4296-4561` SaveData_FixInfo 대상 수집(2) |
| WK-SCP0009-0241 | G4 | B | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — B: 행 집계 — G4 25요소: NOT_RUN:15 · NOPATH:10 (미실행 요소가 남아 판정필요) |  | 1 (B) |
| WK-SCP0009-0242 | G4 | `.cs:1105-1164` BtnNew_Click(+팝업) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — `.cs:1105-1164` BtnNew_Click(+팝업): 행 집계 — G4 25요소: NOT_RUN:15 · NOPATH:10 (미실행 요소가 남아 판정필요) |  | 1 (`.cs:1105-1164` BtnNew_Click(+팝업)) |
| WK-SCP0009-0243 | G4 | `.cs:4296-4561` SaveData_FixInfo 대상 수집(2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — `.cs:4296-4561` SaveData_FixInfo 대상 수집(2026-10-06): 행 집계 — G4 25요소: NOT_RUN:15 · NOPATH:10 (미실행 요소가 남아 판정필요) |  | 1 (`.cs:4296-4561` SaveData_FixInfo 대상 수집(2) |
| WK-SCP0009-0244 | G4 | dCalendar + W26/W52/WLast | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — dCalendar + W26/W52/WLast: 행 집계 — G4 25요소: NOT_RUN:15 · NOPATH:10 (미실행 요소가 남아 판정필요) |  | 1 (dCalendar + W26/W52/WLast) |
| WK-SCP0009-0245 | G4 | 가드 메시지 ID(2026-10-06 정정) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 가드 메시지 ID(2026-10-06 정정): 행 집계 — G4 25요소: NOT_RUN:15 · NOPATH:10 (미실행 요소가 남아 판정필요) |  | 1 (가드 메시지 ID(2026-10-06 정정)) |
| WK-SCP0009-0246 | G4 | 조회조건 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — 조회조건: 행 집계 — G4 25요소: NOT_RUN:15 · NOPATH:10 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0009-0247 | H5 | **버튼 등록(서브시트 SEARCH)** | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — **버튼 등록(서브시트 SEARCH)**: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (**버튼 등록(서브시트 SEARCH)**) |
| WK-SCP0009-0248 | H5 | API_M | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — API_M: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (API_M) |
| WK-SCP0009-0249 | H5 | C | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — C: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (C) |
| WK-SCP0009-0250 | H5 | Column/Measure 커스텀(btnColumn/btnMeasure) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — Column/Measure 커스텀(btnColumn/btnMeasure): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (Column/Measure 커스텀(btnColumn/btnMeasure)) |
| WK-SCP0009-0251 | H5 | Fix 하이라이트(O_RC3, §2.5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — Fix 하이라이트(O_RC3, §2.5): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (Fix 하이라이트(O_RC3, §2.5)) |
| WK-SCP0009-0252 | H5 | Fix-잠금 불일치(AS-IS 기지결함) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — Fix-잠금 불일치(AS-IS 기지결함): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (Fix-잠금 불일치(AS-IS 기지결함)) |
| WK-SCP0009-0253 | H5 | FrozenColumnCount | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — FrozenColumnCount: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (FrozenColumnCount) |
| WK-SCP0009-0254 | H5 | H1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — H1: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (H1) |
| WK-SCP0009-0255 | H5 | Lock 계열(LockColumn/LockRange/SwitchLock) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — Lock 계열(LockColumn/LockRange/SwitchLock): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (Lock 계열(LockColumn/LockRange/SwitchLock)) |
| WK-SCP0009-0256 | H5 | M1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — M1: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (M1) |
| WK-SCP0009-0257 | H5 | PROC_M(파라미터 메타) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — PROC_M(파라미터 메타): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (PROC_M(파라미터 메타)) |
| WK-SCP0009-0258 | H5 | SCP0009_Shipment_Plan_FG.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0009_Shipment_Plan_FG.CreateSpread: 진입점 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 10 (ACT:SCP0009_Shipment_Plan_FG.CreateSprea) |
| WK-SCP0009-0259 | H5 | SCP0009_Shipment_Plan_FG.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0009_Shipment_Plan_FG.SetSpreadColumn: 진입점 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SCP0009_Shipment_Plan_FG.SetSpreadCo) |
| WK-SCP0009-0260 | H5 | SmartColMerge(R-I) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SmartColMerge(R-I): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (SmartColMerge(R-I)) |
| WK-SCP0009-0261 | H5 | `.cs:1314-1316` SaveButton → `SaveData_M | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `.cs:1314-1316` SaveButton → `SaveData_Main`(.cs:2: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (`.cs:1314-1316` SaveButton → `SaveData_M) |
| WK-SCP0009-0262 | H5 | `BlockCellsChecking`(R-K, 편집가능판정) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `BlockCellsChecking`(R-K, 편집가능판정): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (`BlockCellsChecking`(R-K, 편집가능판정)) |
| WK-SCP0009-0263 | H5 | `P_MAKE_PIVOT_COLUMNS`(값) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `P_MAKE_PIVOT_COLUMNS`(값): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (`P_MAKE_PIVOT_COLUMNS`(값)) |
| WK-SCP0009-0264 | H5 | `P_SCP0009_GET_SHEET_CALENDAR_3SPAN`(헤더) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `P_SCP0009_GET_SHEET_CALENDAR_3SPAN`(헤더): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (`P_SCP0009_GET_SHEET_CALENDAR_3SPAN`(헤더)) |
| WK-SCP0009-0265 | H5 | `SCM_MST_SHEET_COLUMNS` | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `SCM_MST_SHEET_COLUMNS`: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (`SCM_MST_SHEET_COLUMNS`) |
| WK-SCP0009-0266 | H5 | `splitContainer1/2`(고정비율 425/581, 958),  | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `splitContainer1/2`(고정비율 425/581, 958), 하단 서브그리드 `: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (`splitContainer1/2`(고정비율 425/581, 958), ) |
| WK-SCP0009-0267 | H5 | `useShipmentPlanFgStore.ts` | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `useShipmentPlanFgStore.ts`: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (`useShipmentPlanFgStore.ts`) |
| WK-SCP0009-0268 | H5 | division 조건부 hidden(R-A/R-B, 19+12건) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — division 조건부 hidden(R-A/R-B, 19+12건): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (division 조건부 hidden(R-A/R-B, 19+12건)) |
| WK-SCP0009-0269 | H5 | 공통 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 공통: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (공통) |
| WK-SCP0009-0270 | H5 | 그리드 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 그리드: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (그리드) |
| WK-SCP0009-0271 | H5 | 버튼 등록(2.8, main 시트) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 버튼 등록(2.8, main 시트): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (버튼 등록(2.8, main 시트)) |
| WK-SCP0009-0272 | H5 | 셀 병합(SmartColMerge) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 셀 병합(SmartColMerge): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (셀 병합(SmartColMerge)) |
| WK-SCP0009-0273 | H5 | 저장 26필드 JSON 전송 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 저장 26필드 JSON 전송: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (저장 26필드 JSON 전송) |
| WK-SCP0009-0274 | H5 | 저장 검증(MSG00084/MSG00317) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 저장 검증(MSG00084/MSG00317): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (저장 검증(MSG00084/MSG00317)) |
| WK-SCP0009-0275 | H5 | 정보컬럼 44(§0 전건 INPUT_TP_CD='S') | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 정보컬럼 44(§0 전건 INPUT_TP_CD='S'): 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (정보컬럼 44(§0 전건 INPUT_TP_CD='S')) |
| WK-SCP0009-0276 | H5 | 조회조건 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 조회조건: 행 집계 — H5 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0009-0277 | X-REASON | Division/개인화 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — Division/개인화 숨김 컬럼 비노출 통과 division 조건부 hidden(EE 3건/40 10건) `infoColumns` useMemo |  | 0 () |
| WK-SCP0009-0278 | X-REASON | 그리드 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 그리드 CODE 아닌 NAME 표시 통과 콤보 SQL `CODE`/`NAME` 별칭 규약(design 02), 그리드 콤보 셀 자체가 0건(§0) |  | 0 () |
| WK-SCP0009-0279 | X-REASON | 셀 타입 콤보(SetCellTypeCombo) | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 셀 타입 콤보(SetCellTypeCombo) 0건(design 03 §0 DB 실측 — CELL_COMBO_DATA_TYPE 80행 전건 공백) 해당없음 |  | 1 (셀 타입 콤보(SetCellTypeCombo)) |
| WK-SCP0009-0280 | X-REASON | 조회조건 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — 조회조건 Condition 저장/Reset(Period 제외) 해당없음 이 화면은 조회조건 저장/복원 기능 자체가 없음(design 02 §4 `ConditionNotUseList`는 "저장 대상 제 |  | 1 (조회조건) |
| WK-SCP0009-0281 | E4 | Column/Measure 커스텀(btnColumn/btnMeasure) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — Column/Measure 커스텀(btnColumn/btnMeasure): 행 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (Column/Measure 커스텀(btnColumn/btnMeasure)) |
| WK-SCP0009-0282 | E4 | G2(구 H1) 저장 SP 실행 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — G2(구 H1) 저장 SP 실행: 행 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (G2(구 H1) 저장 SP 실행) |
| WK-SCP0009-0283 | E4 | H1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — H1: 행 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (H1) |
| WK-SCP0009-0284 | E4 | SCP0009_Shipment_Plan_FG.SetCellType | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0009_Shipment_Plan_FG.SetCellType: 진입점 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0009_Shipment_Plan_FG.SetCellType) |
| WK-SCP0009-0285 | E4 | SCP0009_Shipment_Plan_FG.SetChangedContr | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0009_Shipment_Plan_FG.SetChangedControl: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0009_Shipment_Plan_FG.SetChangedC) |
| WK-SCP0009-0286 | E4 | SCP0009_Shipment_Plan_FG.SetDataTableQty | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0009_Shipment_Plan_FG.SetDataTableQtyData: 진입점 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0009_Shipment_Plan_FG.SetDataTabl) |
| WK-SCP0009-0287 | E4 | SCP0009_Shipment_Plan_FG.SetFromSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0009_Shipment_Plan_FG.SetFromSite: 진입점 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0009_Shipment_Plan_FG.SetFromSite) |
| WK-SCP0009-0288 | E4 | SCP0009_Shipment_Plan_FG.SetOperationGro | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0009_Shipment_Plan_FG.SetOperationGroupByDivisi: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0009_Shipment_Plan_FG.SetOperatio) |
| WK-SCP0009-0289 | E4 | SCP0009_Shipment_Plan_FG.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0009_Shipment_Plan_FG.SetSpreadColumn: 진입점 집계 — E4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SCP0009_Shipment_Plan_FG.SetSpreadCo) |
| WK-SCP0009-0290 | E4 | SCP0009_Shipment_Plan_FG.SetToSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0009_Shipment_Plan_FG.SetToSite: 진입점 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0009_Shipment_Plan_FG.SetToSite:3) |
| WK-SCP0009-0291 | E4 | SCP0009_Shipment_Plan_FG.Set_FPOperation | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0009_Shipment_Plan_FG.Set_FPOperationColor: 진입점 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 14 (ACT:SCP0009_Shipment_Plan_FG.Set_FPOpera) |
| WK-SCP0009-0292 | E4 | SCP0009_Shipment_Plan_FG.Set_FixButtonEn | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0009_Shipment_Plan_FG.Set_FixButtonEnabled: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0009_Shipment_Plan_FG.Set_FixButt) |
| WK-SCP0009-0293 | E4 | SCP0009_Shipment_Plan_FG.Set_FixCellColo | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0009_Shipment_Plan_FG.Set_FixCellColor: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 29 (ACT:SCP0009_Shipment_Plan_FG.Set_FixCell) |
| WK-SCP0009-0294 | E4 | SCP0009_Shipment_Plan_FG.Set_InsertColum | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0009_Shipment_Plan_FG.Set_InsertColumnsFont: 진입점 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0009_Shipment_Plan_FG.Set_InsertC) |
| WK-SCP0009-0295 | E4 | SCP0009_Shipment_Plan_FG.Set_SumValues | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0009_Shipment_Plan_FG.Set_SumValues: 진입점 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 43 (ACT:SCP0009_Shipment_Plan_FG.Set_SumValu) |
| WK-SCP0009-0296 | E4 | `.cs:1040-1068` BtnFix_Click 가드체인 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — `.cs:1040-1068` BtnFix_Click 가드체인: 행 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (`.cs:1040-1068` BtnFix_Click 가드체인) |
| WK-SCP0009-0297 | E4 | `.cs:1261-1263` FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — `.cs:1261-1263` FindButton: 행 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (`.cs:1261-1263` FindButton) |
| WK-SCP0009-0298 | E4 | `.cs:1314-1316` SaveButton → `SaveData_M | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — `.cs:1314-1316` SaveButton → `SaveData_Main`(.cs:2: 행 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (`.cs:1314-1316` SaveButton → `SaveData_M) |
| WK-SCP0009-0299 | E4 | 저장 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 저장: 행 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0009-0300 | E4 | 저장 26필드 JSON 전송 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 저장 26필드 JSON 전송: 행 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 1 (저장 26필드 JSON 전송) |
| WK-SCP0009-0301 | E4 | 조회조건 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 조회조건: 행 집계 — E4 32요소: NOT_RUN:32 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0009-0302 | A1 | **버튼 등록(서브시트 SEARCH)** | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — **버튼 등록(서브시트 SEARCH)**: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (**버튼 등록(서브시트 SEARCH)**) |
| WK-SCP0009-0303 | A1 | 40 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 40: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (40) |
| WK-SCP0009-0304 | A1 | 81 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 81: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (81) |
| WK-SCP0009-0305 | A1 | 81/82 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 81/82: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (81/82) |
| WK-SCP0009-0306 | A1 | 82 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 82: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (82) |
| WK-SCP0009-0307 | A1 | B | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — B: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (B) |
| WK-SCP0009-0308 | A1 | C | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — C: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (C) |
| WK-SCP0009-0309 | A1 | COLUMN_SETUP | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COLUMN_SETUP: 골든 비교 케이스 없음(COLUMN_SETUP — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (버튼 등록(2.8, main 시트)) |
| WK-SCP0009-0310 | A1 | Column/Measure 커스텀(btnColumn/btnMeasure) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Column/Measure 커스텀(btnColumn/btnMeasure): 행 집계 — A1 19요소: REVIEW:19 |  | 1 (Column/Measure 커스텀(btnColumn/btnMeasure)) |
| WK-SCP0009-0311 | A1 | H2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — H2: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (H2) |
| WK-SCP0009-0312 | A1 | H6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — H6: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (H6) |
| WK-SCP0009-0313 | A1 | PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD: 골든 비교 케이스 없음(PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD — 팝업·보조 SP 는 golden_ca |  | 1 (dCalendar + W26/W52/WLast) |
| WK-SCP0009-0314 | A1 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN: 골든 비교 케이스 없음(PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN — 팝업·보조 SP |  | 246 (`P_SCP0009_GET_SHEET_CALENDAR_3SPAN`(헤더)) |
| WK-SCP0009-0315 | A1 | PKG_SCP0009.P_SCP0009_GET_SHIPMENT_PLAN_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0009.P_SCP0009_GET_SHIPMENT_PLAN_FG: 골든 비교 케이스 없음(PKG_SCP0009.P_SCP0009_GET_SHIPMENT_PLAN_FG — 팝업·보조 SP 는 golde |  | 173 (H1 PROC_M(파라미터 메타) ACT:SCP0009_Shipment_) |
| WK-SCP0009-0316 | A1 | PKG_SCP0013.P_SCP0013_GET_PLAN_SAVE_YN | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0013.P_SCP0013_GET_PLAN_SAVE_YN: 골든 비교 케이스 없음(PKG_SCP0013.P_SCP0013_GET_PLAN_SAVE_YN — 팝업·보조 SP 는 golden_cases. |  | 2 (`.cs:3661-3705` Get_IsSaveYn — Fix(1056)) |
| WK-SCP0009-0317 | A1 | P_CHK_ALL | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_CHK_ALL: 골든 비교 케이스 없음(P_CHK_ALL — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (chkAll) |
| WK-SCP0009-0318 | A1 | P_SCP0009_FIX_SAVE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_SCP0009_FIX_SAVE: 골든 비교 케이스 없음(P_SCP0009_FIX_SAVE — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 3 (H1 API_M API 연결) |
| WK-SCP0009-0319 | A1 | P_SCP0009_GET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_SCP0009_GET: 골든 비교 케이스 없음(P_SCP0009_GET — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (API_M) |
| WK-SCP0009-0320 | A1 | P_SCP0009_GET_SHIPMENT_PLAN_FG_PEGGING | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_SCP0009_GET_SHIPMENT_PLAN_FG_PEGGING: 골든 비교 케이스 없음(P_SCP0009_GET_SHIPMENT_PLAN_FG_PEGGING — 팝업·보조 SP 는 golden_cases. |  | 1 (`SCM_ADM_PROC_M`) |
| WK-SCP0009-0321 | A1 | P_SCP0009_GET_SHIP_PLAN_FG_TITLE_PARAL | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_SCP0009_GET_SHIP_PLAN_FG_TITLE_PARAL: 골든 비교 케이스 없음(P_SCP0009_GET_SHIP_PLAN_FG_TITLE_PARAL — 팝업·보조 SP 는 golden_cases. |  | 1 (M8) |
| WK-SCP0009-0322 | A1 | P_SCP0009_PEGGING_GET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_SCP0009_PEGGING_GET: 골든 비교 케이스 없음(P_SCP0009_PEGGING_GET — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (API_M) |
| WK-SCP0009-0323 | A1 | P_SCP0009_PROBLEM_GET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_SCP0009_PROBLEM_GET: 골든 비교 케이스 없음(P_SCP0009_PROBLEM_GET — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (API_M) |
| WK-SCP0009-0324 | A1 | P_SCP0009_SAVE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_SCP0009_SAVE: 골든 비교 케이스 없음(P_SCP0009_SAVE — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 4 (H1 M7 API_M API 연결) |
| WK-SCP0009-0325 | A1 | P_SCP0009_TITLE_GET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_SCP0009_TITLE_GET: 골든 비교 케이스 없음(P_SCP0009_TITLE_GET — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 3 (`P_SCP0009_GET_SHEET_CALENDAR_3SPAN`(헤더)) |
| WK-SCP0009-0326 | A1 | P_SCP0013_SAVE_YN_GET | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — P_SCP0013_SAVE_YN_GET: 골든 비교 케이스 없음(P_SCP0013_SAVE_YN_GET — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (`.cs:3661-3705` Get_IsSaveYn — Fix(1056)) |
| WK-SCP0009-0327 | A1 | SCP0009_GET_SHIPMENT_PLAN_FG_PEGGING | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0009_GET_SHIPMENT_PLAN_FG_PEGGING: 골든 비교 케이스 없음(SCP0009_GET_SHIPMENT_PLAN_FG_PEGGING — 팝업·보조 SP 는 golden_cases.csv  |  | 44 (ACT:SCP0009_Shipment_Plan_FG.FindData_Pe) |
| WK-SCP0009-0328 | A1 | SCP0009_GET_SHIPMENT_PLAN_FG_PROBLEM | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0009_GET_SHIPMENT_PLAN_FG_PROBLEM: 골든 비교 케이스 없음(SCP0009_GET_SHIPMENT_PLAN_FG_PROBLEM — 팝업·보조 SP 는 golden_cases.csv  |  | 37 (ACT:SCP0009_Shipment_Plan_FG.FindData_Pl) |
| WK-SCP0009-0329 | A1 | SCP0009_GET_SHIPMENT_PLAN_FG_TITLE_PARAL | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0009_GET_SHIPMENT_PLAN_FG_TITLE_PARAL: 골든 비교 케이스 없음(SCP0009_GET_SHIPMENT_PLAN_FG_TITLE_PARAL — 팝업·보조 SP 는 golden_ca |  | 169 (ACT:SCP0009_Shipment_Plan_FG.FindButton ) |
| WK-SCP0009-0330 | A1 | SCP0013_GET_PLAN_TYPE_SAVE_YN | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0013_GET_PLAN_TYPE_SAVE_YN: 골든 비교 케이스 없음(SCP0013_GET_PLAN_TYPE_SAVE_YN — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 |  | 1 (M9) |
| WK-SCP0009-0331 | A1 | `.cs:1040-1068` BtnFix_Click 가드체인 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `.cs:1040-1068` BtnFix_Click 가드체인: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (`.cs:1040-1068` BtnFix_Click 가드체인) |
| WK-SCP0009-0332 | A1 | `.cs:1070-1102` BtnUnfix_Click(+MSG00016 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `.cs:1070-1102` BtnUnfix_Click(+MSG00016 confirm): 행 집계 — A1 19요소: REVIEW:19 |  | 1 (`.cs:1070-1102` BtnUnfix_Click(+MSG00016) |
| WK-SCP0009-0333 | A1 | `.cs:1105-1164` BtnNew_Click(+팝업) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `.cs:1105-1164` BtnNew_Click(+팝업): 행 집계 — A1 19요소: REVIEW:19 |  | 1 (`.cs:1105-1164` BtnNew_Click(+팝업)) |
| WK-SCP0009-0334 | A1 | `.cs:1261-1263` FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `.cs:1261-1263` FindButton: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (`.cs:1261-1263` FindButton) |
| WK-SCP0009-0335 | A1 | `.cs:1314-1316` SaveButton → `SaveData_M | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `.cs:1314-1316` SaveButton → `SaveData_Main`(.cs:2: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (`.cs:1314-1316` SaveButton → `SaveData_M) |
| WK-SCP0009-0336 | A1 | `.cs:4296-4561` SaveData_FixInfo 대상 수집(2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `.cs:4296-4561` SaveData_FixInfo 대상 수집(2026-10-06): 행 집계 — A1 19요소: REVIEW:19 |  | 1 (`.cs:4296-4561` SaveData_FixInfo 대상 수집(2) |
| WK-SCP0009-0337 | A1 | btnItem_Id/txtItem_Id | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — btnItem_Id/txtItem_Id: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (btnItem_Id/txtItem_Id) |
| WK-SCP0009-0338 | A1 | btnProject/txtProject | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — btnProject/txtProject: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (btnProject/txtProject) |
| WK-SCP0009-0339 | A1 | cboBizType | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboBizType: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (cboBizType) |
| WK-SCP0009-0340 | A1 | cboBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboBucketType: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (cboBucketType) |
| WK-SCP0009-0341 | A1 | cboDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboDivision: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (cboDivision) |
| WK-SCP0009-0342 | A1 | cboPlanDate/Type/Seq | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboPlanDate/Type/Seq: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (cboPlanDate/Type/Seq) |
| WK-SCP0009-0343 | A1 | chkAll off 시 그리드 비움+재조회 필요(§2.4 예외) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — chkAll off 시 그리드 비움+재조회 필요(§2.4 예외): 행 집계 — A1 19요소: REVIEW:19 |  | 1 (chkAll off 시 그리드 비움+재조회 필요(§2.4 예외)) |
| WK-SCP0009-0344 | A1 | chkSum | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — chkSum: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (chkSum) |
| WK-SCP0009-0345 | A1 | clbCustomer | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbCustomer: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (clbCustomer) |
| WK-SCP0009-0346 | A1 | clbElecType | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbElecType: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (clbElecType) |
| WK-SCP0009-0347 | A1 | clbFromSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbFromSite: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (clbFromSite) |
| WK-SCP0009-0348 | A1 | clbTeam | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbTeam: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (clbTeam) |
| WK-SCP0009-0349 | A1 | clbToSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbToSite: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (clbToSite) |
| WK-SCP0009-0350 | A1 | 가드 메시지 ID(2026-10-06 정정) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 가드 메시지 ID(2026-10-06 정정): 행 집계 — A1 19요소: REVIEW:19 |  | 1 (가드 메시지 ID(2026-10-06 정정)) |
| WK-SCP0009-0351 | A1 | 메뉴 등록(2.7) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 메뉴 등록(2.7): 행 집계 — A1 19요소: REVIEW:19 |  | 1 (메뉴 등록(2.7)) |
| WK-SCP0009-0352 | A1 | 저장 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 저장: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (저장) |
| WK-SCP0009-0353 | A1 | 조회기간 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 조회기간: 행 집계 — A1 19요소: REVIEW:19 |  | 1 (조회기간) |
| WK-SCP0009-0354 | A1 | 조회조건 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 조회조건: 행 집계 — A1 19요소: REVIEW:19 |  | 0 () |
| WK-SCP0009-0355 | A1 | 컬럼/Measure 메타(2.75) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 컬럼/Measure 메타(2.75): 행 집계 — A1 19요소: REVIEW:19 |  | 1 (컬럼/Measure 메타(2.75)) |
| WK-SCP0009-0356 | A1 | 콤보/Lookup 메타(2.76) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 콤보/Lookup 메타(2.76): 행 집계 — A1 19요소: REVIEW:19 |  | 1 (콤보/Lookup 메타(2.76)) |
| WK-SCP0009-0357 | G1 | **버튼 등록(서브시트 SEARCH)** | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — **버튼 등록(서브시트 SEARCH)**: 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (**버튼 등록(서브시트 SEARCH)**) |
| WK-SCP0009-0358 | G1 | 40 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 40: 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (40) |
| WK-SCP0009-0359 | G1 | 81 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 81: 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (81) |
| WK-SCP0009-0360 | G1 | 81/82 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 81/82: 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (81/82) |
| WK-SCP0009-0361 | G1 | 82 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 82: 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (82) |
| WK-SCP0009-0362 | G1 | API 연결 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — API 연결: 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (API 연결) |
| WK-SCP0009-0363 | G1 | API_M | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — API_M: 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (API_M) |
| WK-SCP0009-0364 | G1 | B | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — B: 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (B) |
| WK-SCP0009-0365 | G1 | C | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — C: 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (C) |
| WK-SCP0009-0366 | G1 | Column/Measure 커스텀(btnColumn/btnMeasure) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — Column/Measure 커스텀(btnColumn/btnMeasure): 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (Column/Measure 커스텀(btnColumn/btnMeasure)) |
| WK-SCP0009-0367 | G1 | H2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — H2: 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (H2) |
| WK-SCP0009-0368 | G1 | M7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — M7: 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (M7) |
| WK-SCP0009-0369 | G1 | M8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — M8: 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (M8) |
| WK-SCP0009-0370 | G1 | M9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — M9: 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (M9) |
| WK-SCP0009-0371 | G1 | PROC_M(파라미터 메타) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — PROC_M(파라미터 메타): 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (PROC_M(파라미터 메타)) |
| WK-SCP0009-0372 | G1 | `.cs:1040-1068` BtnFix_Click 가드체인 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `.cs:1040-1068` BtnFix_Click 가드체인: 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (`.cs:1040-1068` BtnFix_Click 가드체인) |
| WK-SCP0009-0373 | G1 | `.cs:1070-1102` BtnUnfix_Click(+MSG00016 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `.cs:1070-1102` BtnUnfix_Click(+MSG00016 confirm): 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (`.cs:1070-1102` BtnUnfix_Click(+MSG00016) |
| WK-SCP0009-0374 | G1 | `.cs:1105-1164` BtnNew_Click(+팝업) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `.cs:1105-1164` BtnNew_Click(+팝업): 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (`.cs:1105-1164` BtnNew_Click(+팝업)) |
| WK-SCP0009-0375 | G1 | `.cs:1261-1263` FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `.cs:1261-1263` FindButton: 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (`.cs:1261-1263` FindButton) |
| WK-SCP0009-0376 | G1 | `.cs:1314-1316` SaveButton → `SaveData_M | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `.cs:1314-1316` SaveButton → `SaveData_Main`(.cs:2: 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (`.cs:1314-1316` SaveButton → `SaveData_M) |
| WK-SCP0009-0377 | G1 | `.cs:3661-3705` Get_IsSaveYn — Fix(1056) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `.cs:3661-3705` Get_IsSaveYn — Fix(1056)/Unfix(108: 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (`.cs:3661-3705` Get_IsSaveYn — Fix(1056)) |
| WK-SCP0009-0378 | G1 | `.cs:4296-4561` SaveData_FixInfo 대상 수집(2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `.cs:4296-4561` SaveData_FixInfo 대상 수집(2026-10-06): 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (`.cs:4296-4561` SaveData_FixInfo 대상 수집(2) |
| WK-SCP0009-0379 | G1 | `P_SCP0009_GET_SHEET_CALENDAR_3SPAN`(헤더) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `P_SCP0009_GET_SHEET_CALENDAR_3SPAN`(헤더): 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (`P_SCP0009_GET_SHEET_CALENDAR_3SPAN`(헤더)) |
| WK-SCP0009-0380 | G1 | dCalendar + W26/W52/WLast | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — dCalendar + W26/W52/WLast: 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (dCalendar + W26/W52/WLast) |
| WK-SCP0009-0381 | G1 | 가드 메시지 ID(2026-10-06 정정) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 가드 메시지 ID(2026-10-06 정정): 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (가드 메시지 ID(2026-10-06 정정)) |
| WK-SCP0009-0382 | G1 | 메뉴 등록(2.7) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 메뉴 등록(2.7): 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (메뉴 등록(2.7)) |
| WK-SCP0009-0383 | G1 | 버튼 등록(2.8, main 시트) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 버튼 등록(2.8, main 시트): 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (버튼 등록(2.8, main 시트)) |
| WK-SCP0009-0384 | G1 | 저장 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 저장: 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (저장) |
| WK-SCP0009-0385 | G1 | 조회기간 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 조회기간: 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (조회기간) |
| WK-SCP0009-0386 | G1 | 조회조건 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 조회조건: 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0009-0387 | G1 | 컬럼/Measure 메타(2.75) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 컬럼/Measure 메타(2.75): 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (컬럼/Measure 메타(2.75)) |
| WK-SCP0009-0388 | G1 | 콤보/Lookup 메타(2.76) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 콤보/Lookup 메타(2.76): 행 집계 — G1 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (콤보/Lookup 메타(2.76)) |
| WK-SCP0009-0389 | G6 | B | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — B: 행 집계 — G6 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (B) |
| WK-SCP0009-0390 | G6 | `.cs:1105-1164` BtnNew_Click(+팝업) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — `.cs:1105-1164` BtnNew_Click(+팝업): 행 집계 — G6 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (`.cs:1105-1164` BtnNew_Click(+팝업)) |
| WK-SCP0009-0391 | G6 | `.cs:4296-4561` SaveData_FixInfo 대상 수집(2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — `.cs:4296-4561` SaveData_FixInfo 대상 수집(2026-10-06): 행 집계 — G6 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (`.cs:4296-4561` SaveData_FixInfo 대상 수집(2) |
| WK-SCP0009-0392 | G6 | dCalendar + W26/W52/WLast | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — dCalendar + W26/W52/WLast: 행 집계 — G6 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (dCalendar + W26/W52/WLast) |
| WK-SCP0009-0393 | G6 | 가드 메시지 ID(2026-10-06 정정) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 가드 메시지 ID(2026-10-06 정정): 행 집계 — G6 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 1 (가드 메시지 ID(2026-10-06 정정)) |
| WK-SCP0009-0394 | G6 | 조회조건 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — 조회조건: 행 집계 — G6 15요소: NOT_RUN:15 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0009-0395 | X-LOC | 40 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 40: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (40) |
| WK-SCP0009-0396 | X-LOC | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 6: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (6) |
| WK-SCP0009-0397 | X-LOC | 81 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 81: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (81) |
| WK-SCP0009-0398 | X-LOC | 81/82 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 81/82: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (81/82) |
| WK-SCP0009-0399 | X-LOC | 82 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 82: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (82) |
| WK-SCP0009-0400 | X-LOC | A | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — A: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (A) |
| WK-SCP0009-0401 | X-LOC | API 연결 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — API 연결: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (API 연결) |
| WK-SCP0009-0402 | X-LOC | B | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — B: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (B) |
| WK-SCP0009-0403 | X-LOC | BE 바인딩 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — BE 바인딩: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (BE 바인딩) |
| WK-SCP0009-0404 | X-LOC | Division/개인화 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Division/개인화: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Division/개인화) |
| WK-SCP0009-0405 | X-LOC | FrozenColumnCount | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — FrozenColumnCount: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (FrozenColumnCount) |
| WK-SCP0009-0406 | X-LOC | G2(구 H1) 저장 SP 실행 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G2(구 H1) 저장 SP 실행: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G2(구 H1) 저장 SP 실행) |
| WK-SCP0009-0407 | X-LOC | H1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — H1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (H1) |
| WK-SCP0009-0408 | X-LOC | L3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L3) |
| WK-SCP0009-0409 | X-LOC | L3 Fix 하이라이트-잠금 불일치 재현 여부 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L3 Fix 하이라이트-잠금 불일치 재현 여부: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L3 Fix 하이라이트-잠금 불일치 재현 여부) |
| WK-SCP0009-0410 | X-LOC | L5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L5) |
| WK-SCP0009-0411 | X-LOC | L7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — L7: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (L7) |
| WK-SCP0009-0412 | X-LOC | Lock 계열(LockColumn/LockRange/SwitchLock) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Lock 계열(LockColumn/LockRange/SwitchLock): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Lock 계열(LockColumn/LockRange/SwitchLock)) |
| WK-SCP0009-0413 | X-LOC | M2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — M2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (M2) |
| WK-SCP0009-0414 | X-LOC | M4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — M4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (M4) |
| WK-SCP0009-0415 | X-LOC | M6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — M6: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (M6) |
| WK-SCP0009-0416 | X-LOC | M7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — M7: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (M7) |
| WK-SCP0009-0417 | X-LOC | M8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — M8: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (M8) |
| WK-SCP0009-0418 | X-LOC | PROC_M(파라미터 메타) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — PROC_M(파라미터 메타): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (PROC_M(파라미터 메타)) |
| WK-SCP0009-0419 | X-LOC | Weekly 응답의 `D_` 값 유무 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Weekly 응답의 `D_` 값 유무: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Weekly 응답의 `D_` 값 유무) |
| WK-SCP0009-0420 | X-LOC | `SCM_ADM_API_M` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `SCM_ADM_API_M`: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`SCM_ADM_API_M`) |
| WK-SCP0009-0421 | X-LOC | `SCM_ADM_MNU_BTN_MPG_M` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `SCM_ADM_MNU_BTN_MPG_M`: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`SCM_ADM_MNU_BTN_MPG_M`) |
| WK-SCP0009-0422 | X-LOC | `SCM_ADM_PROC_M` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `SCM_ADM_PROC_M`: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`SCM_ADM_PROC_M`) |
| WK-SCP0009-0423 | X-LOC | `SCM_ADM_USER_GR_MNU_BTN_MPG_M` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `SCM_ADM_USER_GR_MNU_BTN_MPG_M`: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`SCM_ADM_USER_GR_MNU_BTN_MPG_M`) |
| WK-SCP0009-0424 | X-LOC | `SCM_MST_SHEET_COLUMNS` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `SCM_MST_SHEET_COLUMNS`: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`SCM_MST_SHEET_COLUMNS`) |
| WK-SCP0009-0425 | X-LOC | `SCP0013_GET_PLAN_SAVE_YN` 실제 Y/N 반환, `K | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `SCP0013_GET_PLAN_SAVE_YN` 실제 Y/N 반환, `KEY_IDX` 응답: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`SCP0013_GET_PLAN_SAVE_YN` 실제 Y/N 반환, `K) |
| WK-SCP0009-0426 | X-LOC | `shipment-plan-semi` 의 같은 Fix/Unfix 결함(` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `shipment-plan-semi` 의 같은 Fix/Unfix 결함(`activeFlag: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`shipment-plan-semi` 의 같은 Fix/Unfix 결함(`) |
| WK-SCP0009-0427 | X-LOC | btnProject/txtProject | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — btnProject/txtProject: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (btnProject/txtProject) |
| WK-SCP0009-0428 | X-LOC | cboBizType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — cboBizType: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (cboBizType) |
| WK-SCP0009-0429 | X-LOC | cboBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — cboBucketType: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (cboBucketType) |
| WK-SCP0009-0430 | X-LOC | cboDivision | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — cboDivision: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (cboDivision) |
| WK-SCP0009-0431 | X-LOC | cboPlanDate/Type/Seq | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — cboPlanDate/Type/Seq: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (cboPlanDate/Type/Seq) |
| WK-SCP0009-0432 | X-LOC | chkSum | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — chkSum: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (chkSum) |
| WK-SCP0009-0433 | X-LOC | clbCustomer | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — clbCustomer: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (clbCustomer) |
| WK-SCP0009-0434 | X-LOC | clbElecType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — clbElecType: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (clbElecType) |
| WK-SCP0009-0435 | X-LOC | clbFromSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — clbFromSite: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (clbFromSite) |
| WK-SCP0009-0436 | X-LOC | clbTeam | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — clbTeam: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (clbTeam) |
| WK-SCP0009-0437 | X-LOC | clbToSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — clbToSite: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (clbToSite) |
| WK-SCP0009-0438 | X-LOC | 공통 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 공통: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (공통) |
| WK-SCP0009-0439 | X-LOC | 그 외 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 그 외: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (그 외) |
| WK-SCP0009-0440 | X-LOC | 그리드 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 그리드: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (그리드) |
| WK-SCP0009-0441 | X-LOC | 메뉴 등록(2.7) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 메뉴 등록(2.7): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (메뉴 등록(2.7)) |
| WK-SCP0009-0442 | X-LOC | 버튼 등록(2.8, main 시트) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 버튼 등록(2.8, main 시트): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (버튼 등록(2.8, main 시트)) |
| WK-SCP0009-0443 | X-LOC | 분기 조건 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 분기 조건: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (분기 조건) |
| WK-SCP0009-0444 | X-LOC | 셀 병합(SmartColMerge) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 셀 병합(SmartColMerge): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (셀 병합(SmartColMerge)) |
| WK-SCP0009-0445 | X-LOC | 저장 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 저장: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (저장) |
| WK-SCP0009-0446 | X-LOC | 제거 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 제거: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (제거) |
| WK-SCP0009-0447 | X-LOC | 조회조건 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 조회조건: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 0 () |
| WK-SCP0009-0448 | X-LOC | 컬럼/Measure 메타(2.75) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 컬럼/Measure 메타(2.75): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (컬럼/Measure 메타(2.75)) |
| WK-SCP0009-0449 | X-LOC | 콤보/Lookup 메타(2.76) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 콤보/Lookup 메타(2.76): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (콤보/Lookup 메타(2.76)) |
| WK-SCP0009-0450 | X-ROW | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 6: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (6) |
| WK-SCP0009-0451 | X-ROW | L1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — L1: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (L1) |
| WK-SCP0009-0452 | X-ROW | L4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — L4: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (L4) |
| WK-SCP0009-0453 | X-ROW | L5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — L5: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (L5) |
| WK-SCP0009-0454 | X-ROW | L7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — L7: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (L7) |
| WK-SCP0009-0455 | X-ROW | M4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — M4: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (M4) |
| WK-SCP0009-0456 | X-ROW | M6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — M6: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (M6) |
| WK-SCP0009-0457 | X-ROW | New 활성화·Seq 기준 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — New 활성화·Seq 기준: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (New 활성화·Seq 기준) |
| WK-SCP0009-0458 | X-ROW | SCP0009_Shipment_Plan_FG.BlockCellsCheck | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.BlockCellsChecking: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/DATA_OP/ENTRY/EXPR/FLOW/GRID |  | 79 (ACT:SCP0009_Shipment_Plan_FG.BlockCellsC) |
| WK-SCP0009-0459 | X-ROW | SCP0009_Shipment_Plan_FG.BtnColumn_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.BtnColumn_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0009_Shipment_Plan_FG.BtnColumn_C) |
| WK-SCP0009-0460 | X-ROW | SCP0009_Shipment_Plan_FG.BtnItem_Id_Clic | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.BtnItem_Id_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0009_Shipment_Plan_FG.BtnItem_Id_) |
| WK-SCP0009-0461 | X-ROW | SCP0009_Shipment_Plan_FG.BtnNew_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.BtnNew_Click: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 12 (ACT:SCP0009_Shipment_Plan_FG.BtnNew_Clic) |
| WK-SCP0009-0462 | X-ROW | SCP0009_Shipment_Plan_FG.BtnProject_Clic | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.BtnProject_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0009_Shipment_Plan_FG.BtnProject_) |
| WK-SCP0009-0463 | X-ROW | SCP0009_Shipment_Plan_FG.BtnW26_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.BtnW26_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 0 () |
| WK-SCP0009-0464 | X-ROW | SCP0009_Shipment_Plan_FG.BtnW52_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.BtnW52_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 0 () |
| WK-SCP0009-0465 | X-ROW | SCP0009_Shipment_Plan_FG.BtnWLast_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.BtnWLast_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 0 () |
| WK-SCP0009-0466 | X-ROW | SCP0009_Shipment_Plan_FG.CboBizType_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.CboBizType_SelectedIndexC: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0009_Shipment_Plan_FG.CboBizType_) |
| WK-SCP0009-0467 | X-ROW | SCP0009_Shipment_Plan_FG.CboDivision_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.CboDivision_SelectedIndex: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0009_Shipment_Plan_FG.CboDivision) |
| WK-SCP0009-0468 | X-ROW | SCP0009_Shipment_Plan_FG.CboPlanDate_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.CboPlanDate_SelectedIndex: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0009_Shipment_Plan_FG.CboPlanDate) |
| WK-SCP0009-0469 | X-ROW | SCP0009_Shipment_Plan_FG.CboPlanSeq_Sele | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.CboPlanSeq_SelectedIndexC: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0009_Shipment_Plan_FG.CboPlanSeq_) |
| WK-SCP0009-0470 | X-ROW | SCP0009_Shipment_Plan_FG.CboPlanType_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.CboPlanType_SelectedIndex: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0009_Shipment_Plan_FG.CboPlanType) |
| WK-SCP0009-0471 | X-ROW | SCP0009_Shipment_Plan_FG.CheckMandatoryS | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.CheckMandatorySheetColumn: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SCP0009_Shipment_Plan_FG.CheckMandat) |
| WK-SCP0009-0472 | X-ROW | SCP0009_Shipment_Plan_FG.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0009_Shipment_Plan_FG.CreateSprea) |
| WK-SCP0009-0473 | X-ROW | SCP0009_Shipment_Plan_FG.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.DefineProperty: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0009_Shipment_Plan_FG.DefinePrope) |
| WK-SCP0009-0474 | X-ROW | SCP0009_Shipment_Plan_FG.EditBlockChecki | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.EditBlockChecking: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/DATA_OP/ENTRY/EXPR/FLOW/LOCAL/RETURN,  |  | 23 (ACT:SCP0009_Shipment_Plan_FG.EditBlockCh) |
| WK-SCP0009-0475 | X-ROW | SCP0009_Shipment_Plan_FG.EditButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.EditButton: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0009_Shipment_Plan_FG.EditButton) |
| WK-SCP0009-0476 | X-ROW | SCP0009_Shipment_Plan_FG.ElectrodeDashRe | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.ElectrodeDashReplace: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 7 (ACT:SCP0009_Shipment_Plan_FG.ElectrodeDa) |
| WK-SCP0009-0477 | X-ROW | SCP0009_Shipment_Plan_FG.ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.ExcelButton: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/ENTRY/EXPR/LOCAL/THROW/UI_MISC/UI_PROP, 연결 |  | 15 (ACT:SCP0009_Shipment_Plan_FG.ExcelButton) |
| WK-SCP0009-0478 | X-ROW | SCP0009_Shipment_Plan_FG.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.FindButton: 진입점 집계 9검사 — NOT_RUN:6 · REVIEW:3 |  | 1 (ACT:SCP0009_Shipment_Plan_FG.FindButton) |
| WK-SCP0009-0479 | X-ROW | SCP0009_Shipment_Plan_FG.FindData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.FindData_Main: 진입점 집계 27검사 — NOT_RUN:21 · REVIEW:3 · PASS:2 · NOPATH:1 |  | 11 (ACT:SCP0009_Shipment_Plan_FG.FindData_Ma) |
| WK-SCP0009-0480 | X-ROW | SCP0009_Shipment_Plan_FG.FindData_Peggin | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.FindData_PeggingInfo: 진입점 집계 10검사 — NOT_RUN:6 · REVIEW:2 · PASS:1 · NOPATH:1 |  | 7 (ACT:SCP0009_Shipment_Plan_FG.FindData_Pe) |
| WK-SCP0009-0481 | X-ROW | SCP0009_Shipment_Plan_FG.FindData_PlanPr | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.FindData_PlanProblem: 진입점 집계 10검사 — NOT_RUN:6 · REVIEW:2 · PASS:1 · NOPATH:1 |  | 7 (ACT:SCP0009_Shipment_Plan_FG.FindData_Pl) |
| WK-SCP0009-0482 | X-ROW | SCP0009_Shipment_Plan_FG.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0009_Shipment_Plan_FG.Form_Load) |
| WK-SCP0009-0483 | X-ROW | SCP0009_Shipment_Plan_FG.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.GetBucketType: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0009_Shipment_Plan_FG.GetBucketTy) |
| WK-SCP0009-0484 | X-ROW | SCP0009_Shipment_Plan_FG.GetErrorMandato | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.GetErrorMandatorySheetCol: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0009_Shipment_Plan_FG.GetErrorMan) |
| WK-SCP0009-0485 | X-ROW | SCP0009_Shipment_Plan_FG.GetFilterStr | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.GetFilterStr: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0009_Shipment_Plan_FG.GetFilterSt) |
| WK-SCP0009-0486 | X-ROW | SCP0009_Shipment_Plan_FG.GetIsEditable | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.GetIsEditable: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0009_Shipment_Plan_FG.GetIsEditab) |
| WK-SCP0009-0487 | X-ROW | SCP0009_Shipment_Plan_FG.GetLastRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.GetLastRange: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0009_Shipment_Plan_FG.GetLastRang) |
| WK-SCP0009-0488 | X-ROW | SCP0009_Shipment_Plan_FG.GetNewInsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.GetNewInsertRowIndex: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0009_Shipment_Plan_FG.GetNewInser) |
| WK-SCP0009-0489 | X-ROW | SCP0009_Shipment_Plan_FG.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.GetSpdTitle: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:1 · TODO:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0009_Shipment_Plan_FG.GetSpdTitle) |
| WK-SCP0009-0490 | X-ROW | SCP0009_Shipment_Plan_FG.Get_IsSaveYn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.Get_IsSaveYn: 진입점 집계 13검사 — NOT_RUN:4 · NOPATH:4 · TODO:3 · REVIEW:2 |  | 1 (ACT:SCP0009_Shipment_Plan_FG.Get_IsSaveY) |
| WK-SCP0009-0491 | X-ROW | SCP0009_Shipment_Plan_FG.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.InitControls: 진입점 집계 23검사 — NOT_RUN:22 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 12 (ACT:SCP0009_Shipment_Plan_FG.InitControl) |
| WK-SCP0009-0492 | X-ROW | SCP0009_Shipment_Plan_FG.InitSpreadDateC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.InitSpreadDateColumn: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 15 (ACT:SCP0009_Shipment_Plan_FG.InitSpreadD) |
| WK-SCP0009-0493 | X-ROW | SCP0009_Shipment_Plan_FG.InitSpread_2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.InitSpread_2: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 42 (ACT:SCP0009_Shipment_Plan_FG.InitSpread_) |
| WK-SCP0009-0494 | X-ROW | SCP0009_Shipment_Plan_FG.InsertRow | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.InsertRow: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/CALL_LOCAL/DATA_OP/ENTRY/EXPR/FLOW/GR |  | 133 (ACT:SCP0009_Shipment_Plan_FG.InsertRow A) |
| WK-SCP0009-0495 | X-ROW | SCP0009_Shipment_Plan_FG.RefreshFromSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.RefreshFromSite: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SCP0009_Shipment_Plan_FG.RefreshFrom) |
| WK-SCP0009-0496 | X-ROW | SCP0009_Shipment_Plan_FG.RefreshOperatio | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.RefreshOperationGroup: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0009_Shipment_Plan_FG.RefreshOper) |
| WK-SCP0009-0497 | X-ROW | SCP0009_Shipment_Plan_FG.RefreshPlanDate | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.RefreshPlanDate: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0009_Shipment_Plan_FG.RefreshPlan) |
| WK-SCP0009-0498 | X-ROW | SCP0009_Shipment_Plan_FG.RefreshPlanSeq | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.RefreshPlanSeq: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0009_Shipment_Plan_FG.RefreshPlan) |
| WK-SCP0009-0499 | X-ROW | SCP0009_Shipment_Plan_FG.RefreshPlanType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.RefreshPlanType: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0009_Shipment_Plan_FG.RefreshPlan) |
| WK-SCP0009-0500 | X-ROW | SCP0009_Shipment_Plan_FG.RefreshTeam | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.RefreshTeam: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0009_Shipment_Plan_FG.RefreshTeam) |
| WK-SCP0009-0501 | X-ROW | SCP0009_Shipment_Plan_FG.RefreshToSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.RefreshToSite: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 12 (ACT:SCP0009_Shipment_Plan_FG.RefreshToSi) |
| WK-SCP0009-0502 | X-ROW | SCP0009_Shipment_Plan_FG.RetIntValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.RetIntValue: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/EXPR/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 5 (ACT:SCP0009_Shipment_Plan_FG.RetIntValue) |
| WK-SCP0009-0503 | X-ROW | SCP0009_Shipment_Plan_FG.SCM_SYS_LOG_BAT | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.SCM_SYS_LOG_BATCH: 진입점 집계 3검사 — NOT_RUN:2 · NOPATH:1 (미실행 검사가 남아 판정필요) |  | 12 (ACT:SCP0009_Shipment_Plan_FG.SCM_SYS_LOG) |
| WK-SCP0009-0504 | X-ROW | SCP0009_Shipment_Plan_FG.SaveData_FixInf | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.SaveData_FixInfo: 진입점 집계 19검사 — NOT_RUN:13 · NOPATH:4 · PASS:2 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SCP0009_Shipment_Plan_FG.SaveData_Fi) |
| WK-SCP0009-0505 | X-ROW | SCP0009_Shipment_Plan_FG.SaveData_Main | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.SaveData_Main: 진입점 집계 20검사 — NOT_RUN:13 · NOPATH:5 · PASS:2 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SCP0009_Shipment_Plan_FG.SaveData_Ma) |
| WK-SCP0009-0506 | X-ROW | SCP0009_Shipment_Plan_FG.SetCellType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.SetCellType: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0009_Shipment_Plan_FG.SetCellType) |
| WK-SCP0009-0507 | X-ROW | SCP0009_Shipment_Plan_FG.SetChangedContr | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.SetChangedControl: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0009_Shipment_Plan_FG.SetChangedC) |
| WK-SCP0009-0508 | X-ROW | SCP0009_Shipment_Plan_FG.SetDataTableQty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.SetDataTableQtyData: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0009_Shipment_Plan_FG.SetDataTabl) |
| WK-SCP0009-0509 | X-ROW | SCP0009_Shipment_Plan_FG.SetFromSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.SetFromSite: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0009_Shipment_Plan_FG.SetFromSite) |
| WK-SCP0009-0510 | X-ROW | SCP0009_Shipment_Plan_FG.SetOperationGro | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.SetOperationGroupByDivisi: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0009_Shipment_Plan_FG.SetOperatio) |
| WK-SCP0009-0511 | X-ROW | SCP0009_Shipment_Plan_FG.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.SetSpreadColumn: 진입점 집계 12검사 — NOT_RUN:12 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SCP0009_Shipment_Plan_FG.SetSpreadCo) |
| WK-SCP0009-0512 | X-ROW | SCP0009_Shipment_Plan_FG.SetToSite | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.SetToSite: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0009_Shipment_Plan_FG.SetToSite) |
| WK-SCP0009-0513 | X-ROW | SCP0009_Shipment_Plan_FG.Set_FPOperation | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.Set_FPOperationColor: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0009_Shipment_Plan_FG.Set_FPOpera) |
| WK-SCP0009-0514 | X-ROW | SCP0009_Shipment_Plan_FG.Set_FixButtonEn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.Set_FixButtonEnabled: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0009_Shipment_Plan_FG.Set_FixButt) |
| WK-SCP0009-0515 | X-ROW | SCP0009_Shipment_Plan_FG.Set_FixCellColo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.Set_FixCellColor: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0009_Shipment_Plan_FG.Set_FixCell) |
| WK-SCP0009-0516 | X-ROW | SCP0009_Shipment_Plan_FG.Set_InsertColum | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.Set_InsertColumnsFont: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0009_Shipment_Plan_FG.Set_InsertC) |
| WK-SCP0009-0517 | X-ROW | SCP0009_Shipment_Plan_FG.Set_SumValues | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.Set_SumValues: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 13 (ACT:SCP0009_Shipment_Plan_FG.Set_SumValu) |
| WK-SCP0009-0518 | X-ROW | SCP0009_Shipment_Plan_FG.SpdMain_CellCli | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.SpdMain_CellClick: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY/EXPR/RETURN, 연결된 요소 검사 없음 |  | 9 (ACT:SCP0009_Shipment_Plan_FG.SpdMain_Cel) |
| WK-SCP0009-0519 | X-ROW | SCP0009_Shipment_Plan_FG.SpdMain_KeyUp | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.SpdMain_KeyUp: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/ENTRY/EXPR/RETURN, 연결된 요소 검사 없음 |  | 8 (ACT:SCP0009_Shipment_Plan_FG.SpdMain_Key) |
| WK-SCP0009-0520 | X-ROW | SCP0009_Shipment_Plan_FG.SpdMain_TopChan | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.SpdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0009_Shipment_Plan_FG.SpdMain_Top) |
| WK-SCP0009-0521 | X-ROW | SCP0009_Shipment_Plan_FG.TotalCellsMerge | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.TotalCellsMerge: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/DATA_OP/ENTRY/EXPR/LOCAL/UI_PROP, 연결된 요소 |  | 49 (ACT:SCP0009_Shipment_Plan_FG.TotalCellsM) |
| WK-SCP0009-0522 | X-ROW | SCP0009_Shipment_Plan_FG.ValidateUserInp | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.ValidateUserInput: 진입점 집계 8검사 — NOT_RUN:8 (미실행 검사가 남아 판정필요) |  | 30 (ACT:SCP0009_Shipment_Plan_FG.ValidateUse) |
| WK-SCP0009-0523 | X-ROW | SCP0009_Shipment_Plan_FG.btnMeasure_Clic | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.btnMeasure_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0009_Shipment_Plan_FG.btnMeasure_) |
| WK-SCP0009-0524 | X-ROW | SCP0009_Shipment_Plan_FG.btnNewControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.btnNewControl: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/EXPR/STATE, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0009_Shipment_Plan_FG.btnNewContr) |
| WK-SCP0009-0525 | X-ROW | SCP0009_Shipment_Plan_FG.cboBucketType_S | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.cboBucketType_SelectedInd: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0009_Shipment_Plan_FG.cboBucketTy) |
| WK-SCP0009-0526 | X-ROW | SCP0009_Shipment_Plan_FG.chkSum_CheckedC | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.chkSum_CheckedChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0009_Shipment_Plan_FG.chkSum_Chec) |
| WK-SCP0009-0527 | X-ROW | SCP0009_Shipment_Plan_FG.clbTeam_Selecte | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0009_Shipment_Plan_FG.clbTeam_SelectedIndexChan: 진입점 집계 9검사 — NOT_RUN:5 · NOPATH:2 · TODO:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0009_Shipment_Plan_FG.clbTeam_Sel) |
| WK-SCP0009-0528 | X-ROW | Weekly 응답의 `D_` 값 유무 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — Weekly 응답의 `D_` 값 유무: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (Weekly 응답의 `D_` 값 유무) |
| WK-SCP0009-0529 | X-ROW | `.cs:1318-1345` ExcelButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `.cs:1318-1345` ExcelButton: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`.cs:1318-1345` ExcelButton) |
| WK-SCP0009-0530 | X-ROW | `.cs:3977-4004` Set_FixButtonEnabled | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `.cs:3977-4004` Set_FixButtonEnabled: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`.cs:3977-4004` Set_FixButtonEnabled) |
| WK-SCP0009-0531 | X-ROW | `.cs:3990` `dtPlanSeq.Max(CODE)` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `.cs:3990` `dtPlanSeq.Max(CODE)`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`.cs:3990` `dtPlanSeq.Max(CODE)`) |
| WK-SCP0009-0532 | X-ROW | `shipment-plan-fg.columns.ts`, `.types.t | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `shipment-plan-fg.columns.ts`, `.types.ts`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`shipment-plan-fg.columns.ts`, `.types.t) |
| WK-SCP0009-0533 | X-ROW | `shipment-plan-fg.constants.ts` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `shipment-plan-fg.constants.ts`: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`shipment-plan-fg.constants.ts`) |
| WK-SCP0009-0534 | X-ROW | `shipment-plan-semi` 의 같은 Fix/Unfix 결함(` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — `shipment-plan-semi` 의 같은 Fix/Unfix 결함(`activeFlag: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (`shipment-plan-semi` 의 같은 Fix/Unfix 결함(`) |
| WK-SCP0009-0535 | X-ROW | 그 외 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 그 외: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (그 외) |
| WK-SCP0009-0536 | X-ROW | 분기 조건 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 분기 조건: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (분기 조건) |
| WK-SCP0009-0537 | X-ROW | 이벤트·오버라이드 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 이벤트·오버라이드: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (이벤트·오버라이드) |
| WK-SCP0009-0538 | X-ROW | 제거 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 제거: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (제거) |
| WK-SCP0009-0539 | X-ROW | 테스트 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 테스트: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (테스트) |
| WK-SCP0009-0540 | X-ROW | 토글 계산(순수 함수) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 토글 계산(순수 함수): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (토글 계산(순수 함수)) |
| WK-SCP0009-0541 | G5 | Fix 사유 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — Fix 사유 팝업: 행 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (Fix 사유 팝업) |
| WK-SCP0009-0542 | G5 | H2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — H2: 행 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (H2) |
| WK-SCP0009-0543 | G5 | H2 New 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — H2 New 팝업: 행 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (H2 New 팝업) |
| WK-SCP0009-0544 | G5 | SCP0009_Shipment_Plan_FG.SpdMain_CellDou | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCP0009_Shipment_Plan_FG.SpdMain_CellDoubleClick: 진입점 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SCP0009_Shipment_Plan_FG.SpdMain_Cel) |
| WK-SCP0009-0545 | G5 | `.cs:1105-1164` BtnNew_Click(+팝업) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — `.cs:1105-1164` BtnNew_Click(+팝업): 행 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (`.cs:1105-1164` BtnNew_Click(+팝업)) |
| WK-SCP0009-0546 | G5 | `.cs:4271-4293` SaveData_FixInfo 사유 팝업(` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — `.cs:4271-4293` SaveData_FixInfo 사유 팝업(`SCM0002_Re: 행 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (`.cs:4271-4293` SaveData_FixInfo 사유 팝업(`) |
| WK-SCP0009-0547 | G5 | `.cs:4296-4561` SaveData_FixInfo 대상 수집(2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — `.cs:4296-4561` SaveData_FixInfo 대상 수집(2026-10-06): 행 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (`.cs:4296-4561` SaveData_FixInfo 대상 수집(2) |
| WK-SCP0009-0548 | H6 | Fix 사유 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — Fix 사유 팝업: 행 집계 — H6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (Fix 사유 팝업) |
| WK-SCP0009-0549 | H6 | H2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — H2: 행 집계 — H6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (H2) |
| WK-SCP0009-0550 | H6 | H2 New 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — H2 New 팝업: 행 집계 — H6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (H2 New 팝업) |
| WK-SCP0009-0551 | H6 | SCP0009_Shipment_Plan_FG.SpdMain_CellDou | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCP0009_Shipment_Plan_FG.SpdMain_CellDoubleClick: 진입점 집계 — H6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SCP0009_Shipment_Plan_FG.SpdMain_Cel) |
| WK-SCP0009-0552 | H6 | `.cs:1105-1164` BtnNew_Click(+팝업) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — `.cs:1105-1164` BtnNew_Click(+팝업): 행 집계 — H6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (`.cs:1105-1164` BtnNew_Click(+팝업)) |
| WK-SCP0009-0553 | H6 | `.cs:4271-4293` SaveData_FixInfo 사유 팝업(` | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — `.cs:4271-4293` SaveData_FixInfo 사유 팝업(`SCM0002_Re: 행 집계 — H6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (`.cs:4271-4293` SaveData_FixInfo 사유 팝업(`) |
| WK-SCP0009-0554 | H6 | `.cs:4296-4561` SaveData_FixInfo 대상 수집(2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — `.cs:4296-4561` SaveData_FixInfo 대상 수집(2026-10-06): 행 집계 — H6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (`.cs:4296-4561` SaveData_FixInfo 대상 수집(2) |
| WK-SCP0009-0555 | M4 | Fix 사유 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — Fix 사유 팝업: 행 집계 — M4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (Fix 사유 팝업) |
| WK-SCP0009-0556 | M4 | H2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — H2: 행 집계 — M4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (H2) |
| WK-SCP0009-0557 | M4 | H2 New 팝업 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — H2 New 팝업: 행 집계 — M4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (H2 New 팝업) |
| WK-SCP0009-0558 | M4 | SCP0009_Shipment_Plan_FG.SpdMain_CellDou | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0009_Shipment_Plan_FG.SpdMain_CellDoubleClick: 진입점 집계 — M4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 9 (ACT:SCP0009_Shipment_Plan_FG.SpdMain_Cel) |
| WK-SCP0009-0559 | M4 | `.cs:1105-1164` BtnNew_Click(+팝업) | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — `.cs:1105-1164` BtnNew_Click(+팝업): 행 집계 — M4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (`.cs:1105-1164` BtnNew_Click(+팝업)) |
| WK-SCP0009-0560 | M4 | `.cs:4271-4293` SaveData_FixInfo 사유 팝업(` | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — `.cs:4271-4293` SaveData_FixInfo 사유 팝업(`SCM0002_Re: 행 집계 — M4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (`.cs:4271-4293` SaveData_FixInfo 사유 팝업(`) |
| WK-SCP0009-0561 | M4 | `.cs:4296-4561` SaveData_FixInfo 대상 수집(2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — `.cs:4296-4561` SaveData_FixInfo 대상 수집(2026-10-06): 행 집계 — M4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (`.cs:4296-4561` SaveData_FixInfo 대상 수집(2) |

## W8 구현 후 검증 (4)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0009-0562 | G4 | `ConditionNotUseList`(PlanDate/Type/Seq  | 선행 W1 완료 후 E2E | G4 — 대조표 미구현 행 `ConditionNotUseList`(PlanDate/Type/Seq 저장제외) 구현 후 검증 · 대상 `ConditionNotUseList`(PlanDate/Type/Seq 저장제외) |  | 1 (`ConditionNotUseList`(PlanDate/Type/Seq ) |
| WK-SCP0009-0563 | A1 | `ConditionNotUseList`(PlanDate/Type/Seq  | 선행 W1 완료 후 E2E | A1 — 대조표 미구현 행 `ConditionNotUseList`(PlanDate/Type/Seq 저장제외) 구현 후 검증 · 대상 `ConditionNotUseList`(PlanDate/Type/Seq 저장제외) |  | 1 (`ConditionNotUseList`(PlanDate/Type/Seq ) |
| WK-SCP0009-0564 | G1 | `ConditionNotUseList`(PlanDate/Type/Seq  | 선행 W1 완료 후 E2E | G1 — 대조표 미구현 행 `ConditionNotUseList`(PlanDate/Type/Seq 저장제외) 구현 후 검증 · 대상 `ConditionNotUseList`(PlanDate/Type/Seq 저장제외) |  | 1 (`ConditionNotUseList`(PlanDate/Type/Seq ) |
| WK-SCP0009-0565 | G6 | `ConditionNotUseList`(PlanDate/Type/Seq  | 선행 W1 완료 후 E2E | G6 — 대조표 미구현 행 `ConditionNotUseList`(PlanDate/Type/Seq 저장제외) 구현 후 검증 · 대상 `ConditionNotUseList`(PlanDate/Type/Seq 저장제외) |  | 1 (`ConditionNotUseList`(PlanDate/Type/Seq ) |
