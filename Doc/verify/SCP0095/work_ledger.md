# 작업 원장 — SCP0095 · 2026-10-26 12:54

> 검사 인스턴스 488건 중 PASS·NA 189건 외 **299건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 28 | 구현 위치 실존 |
| W4 | 검사기 구현 | 6 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 27 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 56 | 실행 → PASS |
| W7 | 기대값 확정 | 182 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 178 · E2E 56 · 하네스 33 · 대조표 32
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 4건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 53 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| X-LOC | GEN |  | 28 |  |  |  |  | 1 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| H5 | DESIGN |  |  |  |  |  | 2 | 21 |  |  | 라벨 명칭 |
| G1 | GEN |  |  |  |  |  | 5 | 16 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| A1 | GEN |  |  |  |  |  |  | 20 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| B4 | COMBO |  |  |  |  | 6 |  | 13 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| B3 | COMBO |  |  |  | 6 |  |  | 12 |  |  | 콤보 후보 정렬 = AS-IS |
| G4 | DESIGN |  |  |  |  | 2 | 7 | 9 |  |  | 조회조건 표시·라벨·활성 |
| G6 | GEN |  |  |  |  |  | 7 | 9 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| E4 | EDIT |  |  |  |  |  | 4 | 7 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| G5 | POPUP |  |  |  |  | 3 |  | 3 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 1 | 2 | 3 |  |  | 팝업 표준·열림 |
| F4 | DB |  |  |  |  |  | 4 | 2 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| M4 | POPUP |  |  |  |  |  | 3 | 3 |  |  | 팝업 선택값 반영 |
| B1 | COMBO |  |  |  |  | 4 |  | 1 |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 4 |  | 1 |  |  | 콤보 후보 중복 없음 |
| C1 | CASCADE |  |  |  |  |  | 5 |  |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| B6 | COMBO |  |  |  |  | 4 |  |  |  |  | ALL 옵션·다중선택 사양 |
| A6 | GEN |  |  |  |  |  | 2 | 2 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| X-REASON | DESIGN |  |  |  |  |  |  | 4 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| DB-SYN | DB |  |  |  |  | 1 |  | 2 |  |  | BE 계정 시노님·권한·대상 객체 |
| C4 | CASCADE |  |  |  |  |  | 3 |  |  |  | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| F2 | CRUD |  |  |  |  | 1 |  |  |  |  | 1회 저장(변경 감지) |
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

## W2 구현 위치 확인 (28)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0095-0001 | X-LOC | DeleteButton | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (DeleteButton) |
| WK-SCP0095-0002 | X-LOC | EditButton | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EditButton) |
| WK-SCP0095-0003 | X-LOC | FindButton | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (FindButton) |
| WK-SCP0095-0004 | X-LOC | InsertButton | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (InsertButton) |
| WK-SCP0095-0005 | X-LOC | R1/R18 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R1/R18) |
| WK-SCP0095-0006 | X-LOC | R15 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R15) |
| WK-SCP0095-0007 | X-LOC | R16 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R16) |
| WK-SCP0095-0008 | X-LOC | R17 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R17) |
| WK-SCP0095-0009 | X-LOC | R19 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R19) |
| WK-SCP0095-0010 | X-LOC | R20 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R20) |
| WK-SCP0095-0011 | X-LOC | R21 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R21) |
| WK-SCP0095-0012 | X-LOC | R22~R28 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R22~R28) |
| WK-SCP0095-0013 | X-LOC | R29 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R29) |
| WK-SCP0095-0014 | X-LOC | R3 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R3) |
| WK-SCP0095-0015 | X-LOC | R30 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R30) |
| WK-SCP0095-0016 | X-LOC | R4 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R4) |
| WK-SCP0095-0017 | X-LOC | R5~R14 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (R5~R14) |
| WK-SCP0095-0018 | X-LOC | SaveButton | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SaveButton) |
| WK-SCP0095-0019 | X-LOC | `Data.Common(Type.COMPANY_EE,false)` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`Data.Common(Type.COMPANY_EE,false)`) |
| WK-SCP0095-0020 | X-LOC | `Data.Common(Type.DATE_WEEKLY,false,_div | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`Data.Common(Type.DATE_WEEKLY,false,_div) |
| WK-SCP0095-0021 | X-LOC | `GetBucketType()` FoxDataRequest(DM0003) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`GetBucketType()` FoxDataRequest(DM0003)) |
| WK-SCP0095-0022 | X-LOC | `SCM0002_ItembyDivisionPopupEE` (btnItem | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`SCM0002_ItembyDivisionPopupEE` (btnItem) |
| WK-SCP0095-0023 | X-LOC | `SetChangedControl()` (Div→Company/PlanD | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`SetChangedControl()` (Div→Company/PlanD) |
| WK-SCP0095-0024 | X-LOC | `checkRequired(usrConditionPanel1)` + `C | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`checkRequired(usrConditionPanel1)` + `C) |
| WK-SCP0095-0025 | X-LOC | `dCalendar.InitValue=GetDayRange("52")` | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`dCalendar.InitValue=GetDayRange("52")`) |
| WK-SCP0095-0026 | X-LOC | `dtDivision = BLUtils.GetDivisionEE(fals | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (`dtDivision = BLUtils.GetDivisionEE(fals) |
| WK-SCP0095-0027 | X-LOC | cboPlanDate Changed → 기간 재계산 + 그리드 clear | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (cboPlanDate Changed → 기간 재계산 + 그리드 clear) |
| WK-SCP0095-0028 | X-LOC | drilldown | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (drilldown) |

## W4 검사기 구현 (6)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0095-0029 | B3 | cboBucketType / Bucket / Bucket Type | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 2 (ACT:SCP0095_GlobalPSI_Elec.getBucketType) |
| WK-SCP0095-0030 | B3 | cboCompany / Company | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboCompany / Company | 있음(FE 소스) | 2 (ACT:SCP0095_GlobalPSI_Elec.getCompany AC) |
| WK-SCP0095-0031 | B3 | cboDivision / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboDivision / Division | 있음(FE 소스) | 2 (ACT:SCP0095_GlobalPSI_Elec.getDivision A) |
| WK-SCP0095-0032 | B3 | cboPlanDate / Plan-date / Plan Date | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboPlanDate / Plan-date / Plan Date | 있음(FE 소스) | 2 (ACT:SCP0095_GlobalPSI_Elec.getPlanDate A) |
| WK-SCP0095-0033 | B3 | cboPlanType / Report Type / Plan Type | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboPlanType / Report Type / Plan Type | 있음(FE 소스) | 2 (ACT:SCP0095_GlobalPSI_Elec.getPlanType A) |
| WK-SCP0095-0034 | B3 | txtItem_Id / Elec Material / Item_Id / M | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 txtItem_Id / Elec Material / Item_Id / Meterial | 있음(FE 소스) | 2 (ACT:SCP0095_GlobalPSI_Elec.getItemId ACT) |

## W5 검사기 연결 (27)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0095-0035 | B1 | cboBucketType / Bucket / Bucket Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 1 (D00-1-013) |
| WK-SCP0095-0036 | B1 | cboCompany / Company | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboCompany / Company | 있음(FE 소스) | 1 (D00-1-005) |
| WK-SCP0095-0037 | B1 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (D00-1-002) |
| WK-SCP0095-0038 | B1 | cboPlanDate / Plan-date / Plan Date | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboPlanDate / Plan-date / Plan Date | 있음(FE 소스) | 1 (D00-1-009) |
| WK-SCP0095-0039 | B2 | cboBucketType / Bucket / Bucket Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 1 (D00-1-013) |
| WK-SCP0095-0040 | B2 | cboCompany / Company | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboCompany / Company | 있음(FE 소스) | 1 (D00-1-005) |
| WK-SCP0095-0041 | B2 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (D00-1-002) |
| WK-SCP0095-0042 | B2 | cboPlanDate / Plan-date / Plan Date | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboPlanDate / Plan-date / Plan Date | 있음(FE 소스) | 1 (D00-1-009) |
| WK-SCP0095-0043 | B4 | cboBucketType / Bucket / Bucket Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 3 (D00-1-013 ACT:SCP0095_GlobalPSI_Elec.get) |
| WK-SCP0095-0044 | B4 | cboCompany / Company | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboCompany / Company | 있음(FE 소스) | 3 (D00-1-005 ACT:SCP0095_GlobalPSI_Elec.get) |
| WK-SCP0095-0045 | B4 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 3 (D00-1-002 ACT:SCP0095_GlobalPSI_Elec.get) |
| WK-SCP0095-0046 | B4 | cboPlanDate / Plan-date / Plan Date | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboPlanDate / Plan-date / Plan Date | 있음(FE 소스) | 3 (D00-1-009 ACT:SCP0095_GlobalPSI_Elec.get) |
| WK-SCP0095-0047 | B4 | cboPlanType / Report Type / Plan Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboPlanType / Report Type / Plan Type | 있음(FE 소스) | 2 (ACT:SCP0095_GlobalPSI_Elec.getPlanType A) |
| WK-SCP0095-0048 | B4 | txtItem_Id / Elec Material / Item_Id / M | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND txtItem_Id / Elec Material / Item_Id / Meterial | 있음(FE 소스) | 2 (ACT:SCP0095_GlobalPSI_Elec.getItemId ACT) |
| WK-SCP0095-0049 | B6 | cboBucketType / Bucket / Bucket Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 1 (D00-1-013) |
| WK-SCP0095-0050 | B6 | cboCompany / Company | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboCompany / Company | 있음(FE 소스) | 1 (D00-1-005) |
| WK-SCP0095-0051 | B6 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (D00-1-002) |
| WK-SCP0095-0052 | B6 | cboPlanDate / Plan-date / Plan Date | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboPlanDate / Plan-date / Plan Date | 있음(FE 소스) | 1 (D00-1-009) |
| WK-SCP0095-0053 | F2 | SCP0095 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0095 화면 | 판단불가(대상 단위 SCREEN) | 1 (SaveButton) |
| WK-SCP0095-0054 | DB-SYN | DM0003_GET_BUCKET_TYPE_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DM0003_GET_BUCKET_TYPE_CODE | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0095_GlobalPSI_Elec.GetBucketType) |
| WK-SCP0095-0055 | G4 | btnItem | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItem | 없음 | 2 (ACT:SCP0095_GlobalPSI_Elec.InitEvent ACT) |
| WK-SCP0095-0056 | G4 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnMeasure | 있음(FE 소스) | 2 (ACT:SCP0095_GlobalPSI_Elec.InitEvent ACT) |
| WK-SCP0095-0057 | G03-WIRE | SCP0095 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0095 화면 | 판단불가(대상 단위 SCREEN) | 12 (ACT:SCP0095_GlobalPSI_Elec..ctor ACT:SCP) |
| WK-SCP0095-0058 | G5 | btnItem | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnItem | 없음 | 3 (D00-1-006 D00-2-005 `SCM0002_ItembyDivis) |
| WK-SCP0095-0059 | G5 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 2 (ACT:SCP0095_GlobalPSI_Elec.spdMain_CellD) |
| WK-SCP0095-0060 | G5 | cboPlanDate / Plan-date / Plan Date | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND cboPlanDate / Plan-date / Plan Date | 있음(FE 소스) | 2 (ACT:SCP0095_GlobalPSI_Elec.spdMain_CellD) |
| WK-SCP0095-0061 | H6 | btnItem | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnItem | 없음 | 3 (D00-1-006 D00-2-005 `SCM0002_ItembyDivis) |

## W6 검증 실행 (56)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0095-0062 | J2 | SCP0095 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0095 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 36 (D00-1-006 D00-1-017 D00-1-018 D00-3-016 ) |
| WK-SCP0095-0063 | C1 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-003 ACT:SCP0095_GlobalPSI_Elec.Ini) |
| WK-SCP0095-0064 | C1 | cboCompany / Company | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboCompany / Company · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0095_GlobalPSI_Elec.SetChangedCon) |
| WK-SCP0095-0065 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-001 ACT:SCP0095_GlobalPSI_Elec.Ini) |
| WK-SCP0095-0066 | C1 | cboPlanDate / Plan-date / Plan Date | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (D00-2-002 ACT:SCP0095_GlobalPSI_Elec.Set) |
| WK-SCP0095-0067 | C1 | cboPlanType / Report Type / Plan Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboPlanType / Report Type / Plan Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0095_GlobalPSI_Elec.InitPlanType:) |
| WK-SCP0095-0068 | C4 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-003) |
| WK-SCP0095-0069 | C4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-001) |
| WK-SCP0095-0070 | C4 | cboPlanDate / Plan-date / Plan Date | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 1 (D00-2-002) |
| WK-SCP0095-0071 | G3 | SCP0095 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0095 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 7 (D00-1-008 D00-1-017 D00-1-018 D00-1-019 ) |
| WK-SCP0095-0072 | K-SA | SCP0095 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCP0095 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 5 (D00-1-008 D00-1-017 D00-1-018 D00-1-019 ) |
| WK-SCP0095-0073 | K4 | SCP0095 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0095 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 18 (COMMON:UC-05 COMMON:UC-07 ACT:SCP0095_Gl) |
| WK-SCP0095-0074 | F1 | SCP0095 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0095 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 2 (SaveButton DeleteButton) |
| WK-SCP0095-0075 | F5 | SCP0095 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0095 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 1 (DeleteButton) |
| WK-SCP0095-0076 | F4 | DM0003_GET_BUCKET_TYPE_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DM0003_GET_BUCKET_TYPE_CODE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:SCP0095_GlobalPSI_Elec.GetBucketType) |
| WK-SCP0095-0077 | F4 | PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: |  | 3 (`dCalendar.InitValue=GetDayRange("52")` ) |
| WK-SCP0095-0078 | F4 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) —  |  | 2 (ACT:SCP0095_GlobalPSI_Elec.GetSpdTitle:9) |
| WK-SCP0095-0079 | F4 | PKG_SCP0095.P_SCP0095_GET_GLOBAL_PSI_ELE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0095.P_SCP0095_GET_GLOBAL_PSI_ELEC · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요 |  | 53 (ACT:SCP0095_GlobalPSI_Elec.FindButton AC) |
| WK-SCP0095-0080 | G4 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 7 (D00-1-013 ACT:SCP0095_GlobalPSI_Elec.Def) |
| WK-SCP0095-0081 | G4 | cboCompany / Company | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboCompany / Company · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-005) |
| WK-SCP0095-0082 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (D00-1-002 ACT:SCP0095_GlobalPSI_Elec.Ini) |
| WK-SCP0095-0083 | G4 | cboPlanDate / Plan-date / Plan Date | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (D00-1-009 cboPlanDate Changed → 기간 재계산 +) |
| WK-SCP0095-0084 | G4 | cboPlanType / Report Type / Plan Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboPlanType / Report Type / Plan Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 4 (ACT:SCP0095_GlobalPSI_Elec.InitPlanType ) |
| WK-SCP0095-0085 | G4 | chkSum / Sum | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkSum / Sum · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 2 (ACT:SCP0095_GlobalPSI_Elec.InitEvent ACT) |
| WK-SCP0095-0086 | G4 | txtItem_Id / Elec Material / Item_Id / M | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtItem_Id / Elec Material / Item_Id / Meterial · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-004) |
| WK-SCP0095-0087 | H4 | SCP0095 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — SCP0095 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 5 (D00-2-007 ACT:SCP0095_GlobalPSI_Elec.Spd) |
| WK-SCP0095-0088 | H5 | cboPlanDate / Plan-date / Plan Date | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실 |  | 1 (cboPlanDate Changed → 기간 재계산 + 그리드 clear) |
| WK-SCP0095-0089 | H5 | chkSum / Sum | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — chkSum / Sum · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (R22~R28 ACT:SCP0095_GlobalPSI_Elec.SetSp) |
| WK-SCP0095-0090 | I1 | SCP0095 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0095 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 1 (ACT:SCP0095_GlobalPSI_Elec.btnMeasure_Cl) |
| WK-SCP0095-0091 | SC1 | SCP0095 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SCP0095 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 15 (D00-1-002 D00-1-004 D00-1-005 D00-1-009 ) |
| WK-SCP0095-0092 | D6 | SCP0095 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0095 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 3 (`dtDivision = BLUtils.GetDivisionEE(fals) |
| WK-SCP0095-0093 | E4 | MSG00007 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00007 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (ACT:SCP0095_GlobalPSI_Elec.btnMeasure_Cl) |
| WK-SCP0095-0094 | E4 | cboCompany / Company | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboCompany / Company · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요: |  | 2 (ACT:SCP0095_GlobalPSI_Elec.SetChangedCon) |
| WK-SCP0095-0095 | E4 | cboPlanDate / Plan-date / Plan Date | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장  |  | 2 (ACT:SCP0095_GlobalPSI_Elec.SetChangedCon) |
| WK-SCP0095-0096 | E4 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (ACT:SCP0095_GlobalPSI_Elec.SetSpreadColu) |
| WK-SCP0095-0097 | A10 | SCP0095 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0095 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 106 (ACT:SCP0095_GlobalPSI_Elec.DefinePropert) |
| WK-SCP0095-0098 | A6 | PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회)  |  | 1 (`dCalendar.InitValue=GetDayRange("52")`) |
| WK-SCP0095-0099 | A6 | PKG_SCP0095.P_SCP0095_GET_GLOBAL_PSI_ELE | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0095.P_SCP0095_GET_GLOBAL_PSI_ELEC · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) |  | 53 (ACT:SCP0095_GlobalPSI_Elec.FindButton AC) |
| WK-SCP0095-0100 | G1 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-013) |
| WK-SCP0095-0101 | G1 | cboCompany / Company | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboCompany / Company · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-005) |
| WK-SCP0095-0102 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-002) |
| WK-SCP0095-0103 | G1 | cboPlanDate / Plan-date / Plan Date | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 2 (D00-1-009 cboPlanDate Changed → 기간 재계산 +) |
| WK-SCP0095-0104 | G1 | txtItem_Id / Elec Material / Item_Id / M | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItem_Id / Elec Material / Item_Id / Meterial · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-004) |
| WK-SCP0095-0105 | G6 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 7 (D00-1-013 ACT:SCP0095_GlobalPSI_Elec.Def) |
| WK-SCP0095-0106 | G6 | cboCompany / Company | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboCompany / Company · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-005) |
| WK-SCP0095-0107 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (D00-1-002 ACT:SCP0095_GlobalPSI_Elec.Ini) |
| WK-SCP0095-0108 | G6 | cboPlanDate / Plan-date / Plan Date | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (D00-1-009 cboPlanDate Changed → 기간 재계산 +) |
| WK-SCP0095-0109 | G6 | cboPlanType / Report Type / Plan Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboPlanType / Report Type / Plan Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 4 (ACT:SCP0095_GlobalPSI_Elec.InitPlanType ) |
| WK-SCP0095-0110 | G6 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:SCP0095_GlobalPSI_Elec.InitEvent ACT) |
| WK-SCP0095-0111 | G6 | txtItem_Id / Elec Material / Item_Id / M | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtItem_Id / Elec Material / Item_Id / Meterial · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-004) |
| WK-SCP0095-0112 | X-REOPEN | SCP0095 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0095 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 7 (ACT:SCP0095_GlobalPSI_Elec.Dispose ACT:S) |
| WK-SCP0095-0113 | H6 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboDivision / Division · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 2 (ACT:SCP0095_GlobalPSI_Elec.spdMain_CellD) |
| WK-SCP0095-0114 | H6 | cboPlanDate / Plan-date / Plan Date | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 2 (ACT:SCP0095_GlobalPSI_Elec.spdMain_CellD) |
| WK-SCP0095-0115 | M4 | btnItem | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnItem · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (D00-1-006 D00-2-005 `SCM0002_ItembyDivis) |
| WK-SCP0095-0116 | M4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SCP0095_GlobalPSI_Elec.spdMain_CellD) |
| WK-SCP0095-0117 | M4 | cboPlanDate / Plan-date / Plan Date | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — cboPlanDate / Plan-date / Plan Date · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:SCP0095_GlobalPSI_Elec.spdMain_CellD) |

## W7 기대값 확정 (182)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0095-0118 | B1 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B1 기대값 확정 — COMMON:UC-05: 행 집계 — B1 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0095-0119 | B2 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B2 기대값 확정 — COMMON:UC-05: 행 집계 — B2 4요소: NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0095-0120 | B3 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — D00-4b-001: 행 집계 — B3 6요소: TODO:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-001) |
| WK-SCP0095-0121 | B3 | D00-4b-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — D00-4b-002: 행 집계 — B3 6요소: TODO:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-002) |
| WK-SCP0095-0122 | B3 | D00-4b-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — D00-4b-003: 행 집계 — B3 6요소: TODO:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-003) |
| WK-SCP0095-0123 | B3 | SCP0095_GlobalPSI_Elec.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0095_GlobalPSI_Elec.GetBucketType: 진입점 집계 — B3 6요소: TODO:6 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0095_GlobalPSI_Elec.GetBucketType) |
| WK-SCP0095-0124 | B3 | SCP0095_GlobalPSI_Elec.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0095_GlobalPSI_Elec.GetDayRange: 진입점 집계 — B3 6요소: TODO:6 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0095_GlobalPSI_Elec.GetDayRange:8) |
| WK-SCP0095-0125 | B3 | SCP0095_GlobalPSI_Elec.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0095_GlobalPSI_Elec.GetSpdTitle: 진입점 집계 — B3 6요소: TODO:6 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0095_GlobalPSI_Elec.GetSpdTitle:9) |
| WK-SCP0095-0126 | B3 | SCP0095_GlobalPSI_Elec.getCellValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0095_GlobalPSI_Elec.getCellValue: 진입점 집계 — B3 6요소: TODO:6 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0095_GlobalPSI_Elec.getCellValue:) |
| WK-SCP0095-0127 | B3 | SCP0095_GlobalPSI_Elec.getFromYYYYMMDD | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0095_GlobalPSI_Elec.getFromYYYYMMDD: 진입점 집계 — B3 6요소: TODO:6 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0095_GlobalPSI_Elec.getFromYYYYMM) |
| WK-SCP0095-0128 | B3 | SCP0095_GlobalPSI_Elec.getToYYYYMMDD | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0095_GlobalPSI_Elec.getToYYYYMMDD: 진입점 집계 — B3 6요소: TODO:6 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0095_GlobalPSI_Elec.getToYYYYMMDD) |
| WK-SCP0095-0129 | B3 | `Data.Common(Type.COMPANY_EE,false)` | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — `Data.Common(Type.COMPANY_EE,false)`: 행 집계 — B3 6요소: TODO:6 (미실행 요소가 남아 판정필요) |  | 1 (`Data.Common(Type.COMPANY_EE,false)`) |
| WK-SCP0095-0130 | B3 | `Data.Common(Type.DATE_WEEKLY,false,_div | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — `Data.Common(Type.DATE_WEEKLY,false,_division)`: 행 집계 — B3 6요소: TODO:6 (미실행 요소가 남아 판정필요) |  | 1 (`Data.Common(Type.DATE_WEEKLY,false,_div) |
| WK-SCP0095-0131 | B3 | `dtDivision = BLUtils.GetDivisionEE(fals | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — `dtDivision = BLUtils.GetDivisionEE(false)` (Divis: 행 집계 — B3 6요소: TODO:6 (미실행 요소가 남아 판정필요) |  | 1 (`dtDivision = BLUtils.GetDivisionEE(fals) |
| WK-SCP0095-0132 | B4 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — COMMON:UC-05: 행 집계 — B4 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0095-0133 | B4 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — D00-4b-001: 행 집계 — B4 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-001) |
| WK-SCP0095-0134 | B4 | D00-4b-002 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — D00-4b-002: 행 집계 — B4 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-002) |
| WK-SCP0095-0135 | B4 | D00-4b-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — D00-4b-003: 행 집계 — B4 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-003) |
| WK-SCP0095-0136 | B4 | SCP0095_GlobalPSI_Elec.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0095_GlobalPSI_Elec.GetBucketType: 진입점 집계 — B4 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0095_GlobalPSI_Elec.GetBucketType) |
| WK-SCP0095-0137 | B4 | SCP0095_GlobalPSI_Elec.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0095_GlobalPSI_Elec.GetDayRange: 진입점 집계 — B4 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0095_GlobalPSI_Elec.GetDayRange:8) |
| WK-SCP0095-0138 | B4 | SCP0095_GlobalPSI_Elec.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0095_GlobalPSI_Elec.GetSpdTitle: 진입점 집계 — B4 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0095_GlobalPSI_Elec.GetSpdTitle:9) |
| WK-SCP0095-0139 | B4 | SCP0095_GlobalPSI_Elec.getCellValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0095_GlobalPSI_Elec.getCellValue: 진입점 집계 — B4 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0095_GlobalPSI_Elec.getCellValue:) |
| WK-SCP0095-0140 | B4 | SCP0095_GlobalPSI_Elec.getFromYYYYMMDD | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0095_GlobalPSI_Elec.getFromYYYYMMDD: 진입점 집계 — B4 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0095_GlobalPSI_Elec.getFromYYYYMM) |
| WK-SCP0095-0141 | B4 | SCP0095_GlobalPSI_Elec.getToYYYYMMDD | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0095_GlobalPSI_Elec.getToYYYYMMDD: 진입점 집계 — B4 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0095_GlobalPSI_Elec.getToYYYYMMDD) |
| WK-SCP0095-0142 | B4 | `Data.Common(Type.COMPANY_EE,false)` | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — `Data.Common(Type.COMPANY_EE,false)`: 행 집계 — B4 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (`Data.Common(Type.COMPANY_EE,false)`) |
| WK-SCP0095-0143 | B4 | `Data.Common(Type.DATE_WEEKLY,false,_div | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — `Data.Common(Type.DATE_WEEKLY,false,_division)`: 행 집계 — B4 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (`Data.Common(Type.DATE_WEEKLY,false,_div) |
| WK-SCP0095-0144 | B4 | `dtDivision = BLUtils.GetDivisionEE(fals | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — `dtDivision = BLUtils.GetDivisionEE(false)` (Divis: 행 집계 — B4 6요소: NOPATH:6 (미실행 요소가 남아 판정필요) |  | 1 (`dtDivision = BLUtils.GetDivisionEE(fals) |
| WK-SCP0095-0145 | DB-SYN | FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — FindButton: 행 집계 — DB-SYN 4요소: PASS:3 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (FindButton) |
| WK-SCP0095-0146 | DB-SYN | R16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — R16: 행 집계 — DB-SYN 4요소: PASS:3 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (R16) |
| WK-SCP0095-0147 | F4 | FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — FindButton: 행 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (FindButton) |
| WK-SCP0095-0148 | F4 | R16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — R16: 행 집계 — F4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (R16) |
| WK-SCP0095-0149 | G4 | D00-1-018 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-1-018: 행 집계 — G4 9요소: NOT_RUN:7 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-018) |
| WK-SCP0095-0150 | G4 | D00-1-019 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-1-019: 행 집계 — G4 9요소: NOT_RUN:7 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-019) |
| WK-SCP0095-0151 | G4 | `Data.Common(Type.COMPANY_EE,false)` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — `Data.Common(Type.COMPANY_EE,false)`: 행 집계 — G4 9요소: NOT_RUN:7 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (`Data.Common(Type.COMPANY_EE,false)`) |
| WK-SCP0095-0152 | G4 | `Data.Common(Type.DATE_WEEKLY,false,_div | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — `Data.Common(Type.DATE_WEEKLY,false,_division)`: 행 집계 — G4 9요소: NOT_RUN:7 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (`Data.Common(Type.DATE_WEEKLY,false,_div) |
| WK-SCP0095-0153 | G4 | `GetBucketType()` FoxDataRequest(DM0003) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — `GetBucketType()` FoxDataRequest(DM0003): 행 집계 — G4 9요소: NOT_RUN:7 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (`GetBucketType()` FoxDataRequest(DM0003)) |
| WK-SCP0095-0154 | G4 | `SetChangedControl()` (Div→Company/PlanD | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — `SetChangedControl()` (Div→Company/PlanDate 재적재): 행 집계 — G4 9요소: NOT_RUN:7 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (`SetChangedControl()` (Div→Company/PlanD) |
| WK-SCP0095-0155 | G4 | `checkRequired(usrConditionPanel1)` + `C | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — `checkRequired(usrConditionPanel1)` + `Check_Perio: 행 집계 — G4 9요소: NOT_RUN:7 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (`checkRequired(usrConditionPanel1)` + `C) |
| WK-SCP0095-0156 | G4 | `dCalendar.InitValue=GetDayRange("52")` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — `dCalendar.InitValue=GetDayRange("52")`: 행 집계 — G4 9요소: NOT_RUN:7 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (`dCalendar.InitValue=GetDayRange("52")`) |
| WK-SCP0095-0157 | G4 | `dtDivision = BLUtils.GetDivisionEE(fals | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — `dtDivision = BLUtils.GetDivisionEE(false)` (Divis: 행 집계 — G4 9요소: NOT_RUN:7 · NOPATH:2 (미실행 요소가 남아 판정필요) |  | 1 (`dtDivision = BLUtils.GetDivisionEE(fals) |
| WK-SCP0095-0158 | H5 | COMMON:UC-05 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-05: 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-05) |
| WK-SCP0095-0159 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0095-0160 | H5 | D00-1-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-1-020: 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-020) |
| WK-SCP0095-0161 | H5 | D00-1-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-1-021: 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-021) |
| WK-SCP0095-0162 | H5 | D00-2-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-2-007: 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-007) |
| WK-SCP0095-0163 | H5 | R1/R18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R1/R18: 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (R1/R18) |
| WK-SCP0095-0164 | H5 | R15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R15: 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (R15) |
| WK-SCP0095-0165 | H5 | R16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R16: 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (R16) |
| WK-SCP0095-0166 | H5 | R17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R17: 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (R17) |
| WK-SCP0095-0167 | H5 | R19 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R19: 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (R19) |
| WK-SCP0095-0168 | H5 | R20 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R20: 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (R20) |
| WK-SCP0095-0169 | H5 | R21 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R21: 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (R21) |
| WK-SCP0095-0170 | H5 | R29 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R29: 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (R29) |
| WK-SCP0095-0171 | H5 | R3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R3: 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (R3) |
| WK-SCP0095-0172 | H5 | R30 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R30: 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (R30) |
| WK-SCP0095-0173 | H5 | R4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R4: 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (R4) |
| WK-SCP0095-0174 | H5 | R5~R14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — R5~R14: 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (R5~R14) |
| WK-SCP0095-0175 | H5 | SCP0095_GlobalPSI_Elec.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0095_GlobalPSI_Elec.CreateSpread: 진입점 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0095_GlobalPSI_Elec.CreateSpread:) |
| WK-SCP0095-0176 | H5 | SCP0095_GlobalPSI_Elec.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0095_GlobalPSI_Elec.SetSpreadColumn: 진입점 집계 — H5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 11 (ACT:SCP0095_GlobalPSI_Elec.SetSpreadColu) |
| WK-SCP0095-0177 | H5 | `SetChangedControl()` (Div→Company/PlanD | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — `SetChangedControl()` (Div→Company/PlanDate 재적재): 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (`SetChangedControl()` (Div→Company/PlanD) |
| WK-SCP0095-0178 | H5 | drilldown | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — drilldown: 행 집계 — H5 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (drilldown) |
| WK-SCP0095-0179 | X-REASON | COMMON:UC-02 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-02 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4)  편집모드/수정 상태 자체 |  | 1 (COMMON:UC-02) |
| WK-SCP0095-0180 | X-REASON | COMMON:UC-06 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-06 Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)  조회조건이 콤보 단일/다중선택·Model 팝업·기간 픽커로 구성 — key-in 자유입력 텍스트  |  | 1 (COMMON:UC-06) |
| WK-SCP0095-0181 | X-REASON | D00-1-015 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-1-015 §1 chkSum / UsrCheckBox  AS-IS Visible=false 미노출(기본 off) — SUM 컬럼 추가표시 없이 활성버킷 접두만(design 03 §2.2). 별 |  | 1 (D00-1-015) |
| WK-SCP0095-0182 | X-REASON | D00-2-004 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-2-004 §2 chkSum / CheckedChanged  AS-IS chkSum Visible=false 미노출(기본 off) — SUM 토글 컨트롤 미도입, 활성버킷 접두만(design  |  | 1 (D00-2-004) |
| WK-SCP0095-0183 | E4 | SCP0095_GlobalPSI_Elec.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0095_GlobalPSI_Elec.SetChangedControl: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0095_GlobalPSI_Elec.SetChangedCon) |
| WK-SCP0095-0184 | E4 | SCP0095_GlobalPSI_Elec.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0095_GlobalPSI_Elec.SetSpreadColumn: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 11 (ACT:SCP0095_GlobalPSI_Elec.SetSpreadColu) |
| WK-SCP0095-0185 | E4 | SCP0095_GlobalPSI_Elec.Set_CellType | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0095_GlobalPSI_Elec.Set_CellType: 진입점 집계 — E4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SCP0095_GlobalPSI_Elec.Set_CellType:) |
| WK-SCP0095-0186 | E4 | SCP0095_GlobalPSI_Elec.Set_FPOperationCo | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0095_GlobalPSI_Elec.Set_FPOperationColor: 진입점 집계 — E4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 17 (ACT:SCP0095_GlobalPSI_Elec.Set_FPOperati) |
| WK-SCP0095-0187 | E4 | SCP0095_GlobalPSI_Elec.Set_SumValues | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0095_GlobalPSI_Elec.Set_SumValues: 진입점 집계 — E4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 8 (ACT:SCP0095_GlobalPSI_Elec.Set_SumValues) |
| WK-SCP0095-0188 | E4 | `checkRequired(usrConditionPanel1)` + `C | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — `checkRequired(usrConditionPanel1)` + `Check_Perio: 행 집계 — E4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (`checkRequired(usrConditionPanel1)` + `C) |
| WK-SCP0095-0189 | E4 | `dCalendar.InitValue=GetDayRange("52")` | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — `dCalendar.InitValue=GetDayRange("52")`: 행 집계 — E4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (`dCalendar.InitValue=GetDayRange("52")`) |
| WK-SCP0095-0190 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (COMMON:UC-07) |
| WK-SCP0095-0191 | A1 | D00-1-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-006: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (D00-1-006) |
| WK-SCP0095-0192 | A1 | D00-1-017 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-017: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (D00-1-017) |
| WK-SCP0095-0193 | A1 | D00-1-018 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-018: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (D00-1-018) |
| WK-SCP0095-0194 | A1 | D00-3-016 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-016: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (D00-3-016) |
| WK-SCP0095-0195 | A1 | D00-3-017 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-3-017: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (D00-3-017) |
| WK-SCP0095-0196 | A1 | FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindButton: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (FindButton) |
| WK-SCP0095-0197 | A1 | PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD: 골든 비교 케이스 없음(PKG_COM0000.P_SCM0001_GET_SCP_DAY_PERIOD — 팝업·보조 SP 는 golden_ca |  | 1 (`dCalendar.InitValue=GetDayRange("52")`) |
| WK-SCP0095-0198 | A1 | PKG_SCP0095.P_SCP0095_GET_GLOBAL_PSI_ELE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0095.P_SCP0095_GET_GLOBAL_PSI_ELEC: 골든 비교 케이스 없음(PKG_SCP0095.P_SCP0095_GET_GLOBAL_PSI_ELEC — 팝업·보조 SP 는 golden_ |  | 53 (ACT:SCP0095_GlobalPSI_Elec.FindButton AC) |
| WK-SCP0095-0199 | A1 | R16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R16: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (R16) |
| WK-SCP0095-0200 | A1 | R17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R17: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (R17) |
| WK-SCP0095-0201 | A1 | SCP0095_GlobalPSI_Elec.AfterFindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0095_GlobalPSI_Elec.AfterFindData: 진입점 집계 — A1 2요소: REVIEW:2 |  | 1 (ACT:SCP0095_GlobalPSI_Elec.AfterFindData) |
| WK-SCP0095-0202 | A1 | SCP0095_GlobalPSI_Elec.AfterFindDataPara | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0095_GlobalPSI_Elec.AfterFindDataParallel: 진입점 집계 — A1 2요소: REVIEW:2 |  | 1 (ACT:SCP0095_GlobalPSI_Elec.AfterFindData) |
| WK-SCP0095-0203 | A1 | `Data.Common(Type.COMPANY_EE,false)` | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `Data.Common(Type.COMPANY_EE,false)`: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (`Data.Common(Type.COMPANY_EE,false)`) |
| WK-SCP0095-0204 | A1 | `Data.Common(Type.DATE_WEEKLY,false,_div | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `Data.Common(Type.DATE_WEEKLY,false,_division)`: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (`Data.Common(Type.DATE_WEEKLY,false,_div) |
| WK-SCP0095-0205 | A1 | `GetBucketType()` FoxDataRequest(DM0003) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `GetBucketType()` FoxDataRequest(DM0003): 행 집계 — A1 2요소: REVIEW:2 |  | 1 (`GetBucketType()` FoxDataRequest(DM0003)) |
| WK-SCP0095-0206 | A1 | `SetChangedControl()` (Div→Company/PlanD | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `SetChangedControl()` (Div→Company/PlanDate 재적재): 행 집계 — A1 2요소: REVIEW:2 |  | 1 (`SetChangedControl()` (Div→Company/PlanD) |
| WK-SCP0095-0207 | A1 | `checkRequired(usrConditionPanel1)` + `C | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `checkRequired(usrConditionPanel1)` + `Check_Perio: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (`checkRequired(usrConditionPanel1)` + `C) |
| WK-SCP0095-0208 | A1 | `dtDivision = BLUtils.GetDivisionEE(fals | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — `dtDivision = BLUtils.GetDivisionEE(false)` (Divis: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (`dtDivision = BLUtils.GetDivisionEE(fals) |
| WK-SCP0095-0209 | A1 | cboPlanDate Changed → 기간 재계산 + 그리드 clear | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboPlanDate Changed → 기간 재계산 + 그리드 clear: 행 집계 — A1 2요소: REVIEW:2 |  | 1 (cboPlanDate Changed → 기간 재계산 + 그리드 clear) |
| WK-SCP0095-0210 | A6 | FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — FindButton: 행 집계 — A6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (FindButton) |
| WK-SCP0095-0211 | A6 | R16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — R16: 행 집계 — A6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (R16) |
| WK-SCP0095-0212 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0095-0213 | G1 | D00-1-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-006: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-006) |
| WK-SCP0095-0214 | G1 | D00-1-017 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-017: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-017) |
| WK-SCP0095-0215 | G1 | D00-1-018 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-018: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-018) |
| WK-SCP0095-0216 | G1 | D00-1-019 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-019: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-019) |
| WK-SCP0095-0217 | G1 | D00-3-016 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-3-016: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-016) |
| WK-SCP0095-0218 | G1 | D00-3-017 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-3-017: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-017) |
| WK-SCP0095-0219 | G1 | FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — FindButton: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (FindButton) |
| WK-SCP0095-0220 | G1 | R17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — R17: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (R17) |
| WK-SCP0095-0221 | G1 | `Data.Common(Type.COMPANY_EE,false)` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `Data.Common(Type.COMPANY_EE,false)`: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`Data.Common(Type.COMPANY_EE,false)`) |
| WK-SCP0095-0222 | G1 | `Data.Common(Type.DATE_WEEKLY,false,_div | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `Data.Common(Type.DATE_WEEKLY,false,_division)`: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`Data.Common(Type.DATE_WEEKLY,false,_div) |
| WK-SCP0095-0223 | G1 | `GetBucketType()` FoxDataRequest(DM0003) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `GetBucketType()` FoxDataRequest(DM0003): 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`GetBucketType()` FoxDataRequest(DM0003)) |
| WK-SCP0095-0224 | G1 | `SetChangedControl()` (Div→Company/PlanD | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `SetChangedControl()` (Div→Company/PlanDate 재적재): 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`SetChangedControl()` (Div→Company/PlanD) |
| WK-SCP0095-0225 | G1 | `checkRequired(usrConditionPanel1)` + `C | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `checkRequired(usrConditionPanel1)` + `Check_Perio: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`checkRequired(usrConditionPanel1)` + `C) |
| WK-SCP0095-0226 | G1 | `dCalendar.InitValue=GetDayRange("52")` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `dCalendar.InitValue=GetDayRange("52")`: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`dCalendar.InitValue=GetDayRange("52")`) |
| WK-SCP0095-0227 | G1 | `dtDivision = BLUtils.GetDivisionEE(fals | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — `dtDivision = BLUtils.GetDivisionEE(false)` (Divis: 행 집계 — G1 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (`dtDivision = BLUtils.GetDivisionEE(fals) |
| WK-SCP0095-0228 | G6 | D00-1-018 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-1-018: 행 집계 — G6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-018) |
| WK-SCP0095-0229 | G6 | D00-1-019 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-1-019: 행 집계 — G6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-019) |
| WK-SCP0095-0230 | G6 | `Data.Common(Type.COMPANY_EE,false)` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — `Data.Common(Type.COMPANY_EE,false)`: 행 집계 — G6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (`Data.Common(Type.COMPANY_EE,false)`) |
| WK-SCP0095-0231 | G6 | `Data.Common(Type.DATE_WEEKLY,false,_div | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — `Data.Common(Type.DATE_WEEKLY,false,_division)`: 행 집계 — G6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (`Data.Common(Type.DATE_WEEKLY,false,_div) |
| WK-SCP0095-0232 | G6 | `GetBucketType()` FoxDataRequest(DM0003) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — `GetBucketType()` FoxDataRequest(DM0003): 행 집계 — G6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (`GetBucketType()` FoxDataRequest(DM0003)) |
| WK-SCP0095-0233 | G6 | `SetChangedControl()` (Div→Company/PlanD | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — `SetChangedControl()` (Div→Company/PlanDate 재적재): 행 집계 — G6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (`SetChangedControl()` (Div→Company/PlanD) |
| WK-SCP0095-0234 | G6 | `checkRequired(usrConditionPanel1)` + `C | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — `checkRequired(usrConditionPanel1)` + `Check_Perio: 행 집계 — G6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (`checkRequired(usrConditionPanel1)` + `C) |
| WK-SCP0095-0235 | G6 | `dCalendar.InitValue=GetDayRange("52")` | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — `dCalendar.InitValue=GetDayRange("52")`: 행 집계 — G6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (`dCalendar.InitValue=GetDayRange("52")`) |
| WK-SCP0095-0236 | G6 | `dtDivision = BLUtils.GetDivisionEE(fals | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — `dtDivision = BLUtils.GetDivisionEE(false)` (Divis: 행 집계 — G6 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (`dtDivision = BLUtils.GetDivisionEE(fals) |
| WK-SCP0095-0237 | X-LOC | B_ 접두 칼럼 분기 (R2, cs L394~398) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — B_ 접두 칼럼 분기 (R2, cs L394~398): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (B_ 접두 칼럼 분기 (R2, cs L394~398)) |
| WK-SCP0095-0238 | X-ROW | B_ 접두 칼럼 분기 (R2, cs L394~398) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — B_ 접두 칼럼 분기 (R2, cs L394~398): 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (B_ 접두 칼럼 분기 (R2, cs L394~398)) |
| WK-SCP0095-0239 | X-ROW | D00-1-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-001: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-001) |
| WK-SCP0095-0240 | X-ROW | D00-1-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-003: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-003) |
| WK-SCP0095-0241 | X-ROW | D00-1-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-007: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-007) |
| WK-SCP0095-0242 | X-ROW | D00-1-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-010: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-010) |
| WK-SCP0095-0243 | X-ROW | D00-1-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-011: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-011) |
| WK-SCP0095-0244 | X-ROW | D00-1-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-012: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-012) |
| WK-SCP0095-0245 | X-ROW | D00-1-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-014: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-014) |
| WK-SCP0095-0246 | X-ROW | D00-3-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-005: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-005) |
| WK-SCP0095-0247 | X-ROW | D00-3-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-006: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-006) |
| WK-SCP0095-0248 | X-ROW | D00-3-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-007: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-007) |
| WK-SCP0095-0249 | X-ROW | D00-3-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-008: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-008) |
| WK-SCP0095-0250 | X-ROW | D00-3-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-009: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-009) |
| WK-SCP0095-0251 | X-ROW | D00-3-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-010: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-010) |
| WK-SCP0095-0252 | X-ROW | D00-3-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-011: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-011) |
| WK-SCP0095-0253 | X-ROW | D00-3-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-012: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-012) |
| WK-SCP0095-0254 | X-ROW | D00-3-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-013: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-013) |
| WK-SCP0095-0255 | X-ROW | D00-3-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-014: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-014) |
| WK-SCP0095-0256 | X-ROW | D00-3-029 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-029: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-029) |
| WK-SCP0095-0257 | X-ROW | SCP0095_GlobalPSI_Elec.AfterFindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0095_GlobalPSI_Elec.AfterFindData: 진입점 집계 1검사 — NOPATH:1 (미실행 검사가 남아 판정필요) |  | 10 (ACT:SCP0095_GlobalPSI_Elec.AfterFindData) |
| WK-SCP0095-0258 | X-ROW | SCP0095_GlobalPSI_Elec.AfterFindDataPara | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0095_GlobalPSI_Elec.AfterFindDataParallel: 진입점 집계 1검사 — NOPATH:1 (미실행 검사가 남아 판정필요) |  | 35 (ACT:SCP0095_GlobalPSI_Elec.AfterFindData) |
| WK-SCP0095-0259 | X-ROW | SCP0095_GlobalPSI_Elec.CboBucketType_Sel | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0095_GlobalPSI_Elec.CboBucketType_SelectedIndex: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0095_GlobalPSI_Elec.CboBucketType) |
| WK-SCP0095-0260 | X-ROW | SCP0095_GlobalPSI_Elec.CboDivision_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0095_GlobalPSI_Elec.CboDivision_SelectedIndexCh: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0095_GlobalPSI_Elec.CboDivision_S) |
| WK-SCP0095-0261 | X-ROW | SCP0095_GlobalPSI_Elec.CboPlanDate_Selec | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0095_GlobalPSI_Elec.CboPlanDate_SelectedIndexCh: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0095_GlobalPSI_Elec.CboPlanDate_S) |
| WK-SCP0095-0262 | X-ROW | SCP0095_GlobalPSI_Elec.CheckKeyColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0095_GlobalPSI_Elec.CheckKeyColumn: 진입점 동작 재현 시나리오 필요 — 문장 종류 DATA_OP/ENTRY, 연결된 요소 검사 없음 |  | 3 (ACT:SCP0095_GlobalPSI_Elec.CheckKeyColum) |
| WK-SCP0095-0263 | X-ROW | SCP0095_GlobalPSI_Elec.CreateSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0095_GlobalPSI_Elec.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0095_GlobalPSI_Elec.CreateSpread) |
| WK-SCP0095-0264 | X-ROW | SCP0095_GlobalPSI_Elec.DefineProperty | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0095_GlobalPSI_Elec.DefineProperty: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0095_GlobalPSI_Elec.DefinePropert) |
| WK-SCP0095-0265 | X-ROW | SCP0095_GlobalPSI_Elec.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0095_GlobalPSI_Elec.FindButton: 진입점 집계 3검사 — NOT_RUN:2 · REVIEW:1 |  | 1 (ACT:SCP0095_GlobalPSI_Elec.FindButton) |
| WK-SCP0095-0266 | X-ROW | SCP0095_GlobalPSI_Elec.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0095_GlobalPSI_Elec.FindData: 진입점 집계 3검사 — NOT_RUN:2 · REVIEW:1 |  | 3 (ACT:SCP0095_GlobalPSI_Elec.FindData ACT:) |
| WK-SCP0095-0267 | X-ROW | SCP0095_GlobalPSI_Elec.FindDataMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0095_GlobalPSI_Elec.FindDataMain: 진입점 집계 4검사 — NOT_RUN:2 · REVIEW:1 · PASS:1 |  | 5 (ACT:SCP0095_GlobalPSI_Elec.FindDataMain ) |
| WK-SCP0095-0268 | X-ROW | SCP0095_GlobalPSI_Elec.FindDataMainParal | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0095_GlobalPSI_Elec.FindDataMainParallel: 진입점 집계 4검사 — NOT_RUN:2 · REVIEW:1 · PASS:1 |  | 5 (ACT:SCP0095_GlobalPSI_Elec.FindDataMainP) |
| WK-SCP0095-0269 | X-ROW | SCP0095_GlobalPSI_Elec.Form_Load | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0095_GlobalPSI_Elec.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0095_GlobalPSI_Elec.Form_Load) |
| WK-SCP0095-0270 | X-ROW | SCP0095_GlobalPSI_Elec.GetBucketType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0095_GlobalPSI_Elec.GetBucketType: 진입점 집계 5검사 — NOPATH:2 · NOT_RUN:2 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0095_GlobalPSI_Elec.GetBucketType) |
| WK-SCP0095-0271 | X-ROW | SCP0095_GlobalPSI_Elec.GetDayRange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0095_GlobalPSI_Elec.GetDayRange: 진입점 집계 5검사 — NOT_RUN:2 · NOPATH:1 · TODO:1 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0095_GlobalPSI_Elec.GetDayRange) |
| WK-SCP0095-0272 | X-ROW | SCP0095_GlobalPSI_Elec.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0095_GlobalPSI_Elec.GetSpdTitle: 진입점 집계 5검사 — NOT_RUN:2 · PASS:1 · NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0095_GlobalPSI_Elec.GetSpdTitle) |
| WK-SCP0095-0273 | X-ROW | SCP0095_GlobalPSI_Elec.InitControls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0095_GlobalPSI_Elec.InitControls: 진입점 집계 7검사 — NOT_RUN:7 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0095_GlobalPSI_Elec.InitControls:) |
| WK-SCP0095-0274 | X-ROW | SCP0095_GlobalPSI_Elec.InitPlanType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0095_GlobalPSI_Elec.InitPlanType: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0095_GlobalPSI_Elec.InitPlanType:) |
| WK-SCP0095-0275 | X-ROW | SCP0095_GlobalPSI_Elec.InitQueryDics | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0095_GlobalPSI_Elec.InitQueryDics: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0095_GlobalPSI_Elec.InitQueryDics) |
| WK-SCP0095-0276 | X-ROW | SCP0095_GlobalPSI_Elec.InitSpread | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0095_GlobalPSI_Elec.InitSpread: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0095_GlobalPSI_Elec.InitSpread) |
| WK-SCP0095-0277 | X-ROW | SCP0095_GlobalPSI_Elec.InitSpreadDateCol | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0095_GlobalPSI_Elec.InitSpreadDateColumn: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 16 (ACT:SCP0095_GlobalPSI_Elec.InitSpreadDat) |
| WK-SCP0095-0278 | X-ROW | SCP0095_GlobalPSI_Elec.InitSpread_2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0095_GlobalPSI_Elec.InitSpread_2: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0095_GlobalPSI_Elec.InitSpread_2 ) |
| WK-SCP0095-0279 | X-ROW | SCP0095_GlobalPSI_Elec.SetChangedControl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0095_GlobalPSI_Elec.SetChangedControl: 진입점 집계 6검사 — NOT_RUN:6 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0095_GlobalPSI_Elec.SetChangedCon) |
| WK-SCP0095-0280 | X-ROW | SCP0095_GlobalPSI_Elec.SetSpreadColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0095_GlobalPSI_Elec.SetSpreadColumn: 진입점 집계 8검사 — NOT_RUN:8 (미실행 검사가 남아 판정필요) |  | 8 (ACT:SCP0095_GlobalPSI_Elec.SetSpreadColu) |
| WK-SCP0095-0281 | X-ROW | SCP0095_GlobalPSI_Elec.Set_CellType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0095_GlobalPSI_Elec.Set_CellType: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0095_GlobalPSI_Elec.Set_CellType ) |
| WK-SCP0095-0282 | X-ROW | SCP0095_GlobalPSI_Elec.Set_FPOperationCo | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0095_GlobalPSI_Elec.Set_FPOperationColor: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0095_GlobalPSI_Elec.Set_FPOperati) |
| WK-SCP0095-0283 | X-ROW | SCP0095_GlobalPSI_Elec.Set_SumValues | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0095_GlobalPSI_Elec.Set_SumValues: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0095_GlobalPSI_Elec.Set_SumValues) |
| WK-SCP0095-0284 | X-ROW | SCP0095_GlobalPSI_Elec.SpdMain_TopChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0095_GlobalPSI_Elec.SpdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0095_GlobalPSI_Elec.SpdMain_TopCh) |
| WK-SCP0095-0285 | X-ROW | SCP0095_GlobalPSI_Elec.btnItem_Id_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0095_GlobalPSI_Elec.btnItem_Id_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0095_GlobalPSI_Elec.btnItem_Id_Cl) |
| WK-SCP0095-0286 | X-ROW | SCP0095_GlobalPSI_Elec.btnMeasure_Click | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0095_GlobalPSI_Elec.btnMeasure_Click: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0095_GlobalPSI_Elec.btnMeasure_Cl) |
| WK-SCP0095-0287 | X-ROW | SCP0095_GlobalPSI_Elec.chkSum_CheckedCha | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0095_GlobalPSI_Elec.chkSum_CheckedChanged: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0095_GlobalPSI_Elec.chkSum_Checke) |
| WK-SCP0095-0288 | X-ROW | SCP0095_GlobalPSI_Elec.getCellValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0095_GlobalPSI_Elec.getCellValue: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0095_GlobalPSI_Elec.getCellValue) |
| WK-SCP0095-0289 | X-ROW | SCP0095_GlobalPSI_Elec.getFromYYYYMMDD | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0095_GlobalPSI_Elec.getFromYYYYMMDD: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0095_GlobalPSI_Elec.getFromYYYYMM) |
| WK-SCP0095-0290 | X-ROW | SCP0095_GlobalPSI_Elec.getToYYYYMMDD | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0095_GlobalPSI_Elec.getToYYYYMMDD: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0095_GlobalPSI_Elec.getToYYYYMMDD) |
| WK-SCP0095-0291 | G5 | D00-2-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-2-006: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-006) |
| WK-SCP0095-0292 | G5 | SCP0095_GlobalPSI_Elec.spdMain_CellDoubl | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCP0095_GlobalPSI_Elec.spdMain_CellDoubleClick: 진입점 집계 — G5 2요소: NOPATH:2 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SCP0095_GlobalPSI_Elec.spdMain_CellD) |
| WK-SCP0095-0293 | G5 | drilldown | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — drilldown: 행 집계 — G5 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 1 (drilldown) |
| WK-SCP0095-0294 | H6 | D00-2-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-2-006: 행 집계 — H6 3요소: NOT_RUN:2 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-006) |
| WK-SCP0095-0295 | H6 | SCP0095_GlobalPSI_Elec.spdMain_CellDoubl | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCP0095_GlobalPSI_Elec.spdMain_CellDoubleClick: 진입점 집계 — H6 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SCP0095_GlobalPSI_Elec.spdMain_CellD) |
| WK-SCP0095-0296 | H6 | drilldown | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — drilldown: 행 집계 — H6 3요소: NOT_RUN:2 · NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (drilldown) |
| WK-SCP0095-0297 | M4 | D00-2-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-2-006: 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-006) |
| WK-SCP0095-0298 | M4 | SCP0095_GlobalPSI_Elec.spdMain_CellDoubl | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0095_GlobalPSI_Elec.spdMain_CellDoubleClick: 진입점 집계 — M4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 12 (ACT:SCP0095_GlobalPSI_Elec.spdMain_CellD) |
| WK-SCP0095-0299 | M4 | drilldown | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — drilldown: 행 집계 — M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (drilldown) |
