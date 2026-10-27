# 작업 원장 — SCP0016 · 2026-10-26 12:53

> 검사 인스턴스 633건 중 PASS·NA 179건 외 **454건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 가이드만(직접 수정 금지). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W2 | 구현 위치 확인 | 10 | 구현 위치 실존 |
| W4 | 검사기 구현 | 3 | 검사기 구현 → 실행 PASS |
| W5 | 검사기 연결 | 40 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 85 | 실행 → PASS |
| W7 | 기대값 확정 | 316 | 기대 확정 → PASS/FAIL |

- 담당: 사람 판정 / AS-IS 원문 확인 → 재판정 312 · E2E 85 · 하네스 43 · 대조표 14
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 6건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-ROW | GEN |  |  |  |  |  |  | 43 |  |  | 대조표 행이 서술한 동작을 화면에서 재현 |
| X-LOC | GEN |  | 10 |  |  |  |  | 26 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| G1 | GEN |  |  |  |  |  | 8 | 23 |  |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| A1 | GEN |  |  |  |  |  |  | 31 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| A5 | DESIGN |  |  |  |  |  | 1 | 29 |  |  | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| H2 | DESIGN |  |  |  |  |  | 1 | 23 |  |  | 배경·글자색 규칙 |
| G4 | DESIGN |  |  |  |  | 4 | 8 | 8 |  |  | 조회조건 표시·라벨·활성 |
| C3 | CASCADE |  |  |  |  |  | 2 | 18 |  |  | 연쇄 자동 채움 |
| H5 | DESIGN |  |  |  |  |  | 3 | 17 |  |  | 라벨 명칭 |
| E4 | EDIT |  |  |  |  |  | 9 | 11 |  |  | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| G5 | POPUP |  |  |  |  | 7 |  | 12 |  |  | 팝업 조건 연동(인자) |
| H6 | POPUP |  |  |  |  | 4 | 3 | 12 |  |  | 팝업 표준·열림 |
| M4 | POPUP |  |  |  |  |  | 7 | 12 |  |  | 팝업 선택값 반영 |
| G6 | GEN |  |  |  |  |  | 8 | 8 |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| B4 | COMBO |  |  |  |  | 5 |  | 9 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| B3 | COMBO |  |  |  | 3 |  |  | 9 |  |  | 콤보 후보 정렬 = AS-IS |
| C1 | CASCADE |  |  |  |  |  | 6 | 5 |  |  | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| C4 | CASCADE |  |  |  |  |  | 4 | 5 |  |  | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| F4 | DB |  |  |  |  |  | 5 | 2 |  |  | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| A6 | GEN |  |  |  |  |  | 5 | 2 |  |  | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| B1 | COMBO |  |  |  |  | 5 |  |  |  |  | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 5 |  |  |  |  | 콤보 후보 중복 없음 |
| B6 | COMBO |  |  |  |  | 5 |  |  |  |  | ALL 옵션·다중선택 사양 |
| DB-SYN | DB |  |  |  |  | 3 |  | 2 |  |  | BE 계정 시노님·권한·대상 객체 |
| M3 | POPUP |  |  |  |  |  | 2 | 3 |  |  | 팝업 내부 기능(조회·CRUD) |
| X-REASON | DESIGN |  |  |  |  |  |  | 4 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| D5 | EDIT |  |  |  |  |  | 1 | 2 |  |  | 셀 에디터 유형 |
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

## W2 구현 위치 확인 (10)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0016-0001 | X-LOC | 1 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (1) |
| WK-SCP0016-0002 | X-LOC | 2 | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (2) |
| WK-SCP0016-0003 | X-LOC | EditButton(641) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (EditButton(641)) |
| WK-SCP0016-0004 | X-LOC | FindButton(636) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (FindButton(636)) |
| WK-SCP0016-0005 | X-LOC | ProgressForm(로딩) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (ProgressForm(로딩)) |
| WK-SCP0016-0006 | X-LOC | SCM0002_ItembyDivisionPopup | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SCM0002_ItembyDivisionPopup) |
| WK-SCP0016-0007 | X-LOC | SCM0002_ProjectbyDivisionPopup | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SCM0002_ProjectbyDivisionPopup) |
| WK-SCP0016-0008 | X-LOC | SCM0002_TitleSetForm 'C'(btnColumn) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SCM0002_TitleSetForm 'C'(btnColumn)) |
| WK-SCP0016-0009 | X-LOC | SCM0002_TitleSetForm 'M'(btnMeasure) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SCM0002_TitleSetForm 'M'(btnMeasure)) |
| WK-SCP0016-0010 | X-LOC | SaveButton(648) | 대조표(FE __asis-mapping__.md) | 구현 위치 확인·대조표 보강 — 상태 구현인데 구현 위치(파일:라인) 칸이 비어 있음 — 대조표 보강 또는 구현 확인 |  | 1 (SaveButton(648)) |

## W4 검사기 구현 (3)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0016-0011 | B3 | cboBucketType / Bucket / Bucket Type | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 7 (ACT:SCP0016_WaterfallShipmentPlanFG.GetD) |
| WK-SCP0016-0012 | B3 | cboDivision / Division | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 cboDivision / Division | 있음(FE 소스) | 2 (ACT:SCP0016_WaterfallShipmentPlanFG.GetD) |
| WK-SCP0016-0013 | B3 | clbVersion / Version / Ver. | 하네스(검증 엔진 _trace.spec.ts) | 검사기 구현 B3 — 콤보 후보 정렬 = AS-IS · 대상 clbVersion / Version / Ver. | 있음(FE 소스) | 2 (ACT:SCP0016_WaterfallShipmentPlanFG.GetD) |

## W5 검사기 연결 (40)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0016-0014 | B1 | cboBizType / Operation Group / Biz Type  | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboBizType / Operation Group / Biz Type / Operatio | 있음(FE 소스) | 1 (D00-1-002) |
| WK-SCP0016-0015 | B1 | cboBucketType / Bucket / Bucket Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 1 (D00-1-010) |
| WK-SCP0016-0016 | B1 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (D00-1-001) |
| WK-SCP0016-0017 | B1 | clbElecType / Electrode / Elec Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbElecType / Electrode / Elec Type | 있음(FE 소스) | 1 (D00-1-006) |
| WK-SCP0016-0018 | B1 | clbVersion / Version / Ver. | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COND clbVersion / Version / Ver. | 있음(FE 소스) | 1 (D00-1-009) |
| WK-SCP0016-0019 | B2 | cboBizType / Operation Group / Biz Type  | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboBizType / Operation Group / Biz Type / Operatio | 있음(FE 소스) | 1 (D00-1-002) |
| WK-SCP0016-0020 | B2 | cboBucketType / Bucket / Bucket Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 1 (D00-1-010) |
| WK-SCP0016-0021 | B2 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (D00-1-001) |
| WK-SCP0016-0022 | B2 | clbElecType / Electrode / Elec Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbElecType / Electrode / Elec Type | 있음(FE 소스) | 1 (D00-1-006) |
| WK-SCP0016-0023 | B2 | clbVersion / Version / Ver. | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COND clbVersion / Version / Ver. | 있음(FE 소스) | 1 (D00-1-009) |
| WK-SCP0016-0024 | B4 | cboBizType / Operation Group / Biz Type  | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboBizType / Operation Group / Biz Type / Operatio | 있음(FE 소스) | 1 (D00-1-002) |
| WK-SCP0016-0025 | B4 | cboBucketType / Bucket / Bucket Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 8 (D00-1-010 ACT:SCP0016_WaterfallShipmentP) |
| WK-SCP0016-0026 | B4 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 3 (D00-1-001 ACT:SCP0016_WaterfallShipmentP) |
| WK-SCP0016-0027 | B4 | clbElecType / Electrode / Elec Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbElecType / Electrode / Elec Type | 있음(FE 소스) | 1 (D00-1-006) |
| WK-SCP0016-0028 | B4 | clbVersion / Version / Ver. | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND clbVersion / Version / Ver. | 있음(FE 소스) | 3 (D00-1-009 ACT:SCP0016_WaterfallShipmentP) |
| WK-SCP0016-0029 | B6 | cboBizType / Operation Group / Biz Type  | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboBizType / Operation Group / Biz Type / Operatio | 있음(FE 소스) | 1 (D00-1-002) |
| WK-SCP0016-0030 | B6 | cboBucketType / Bucket / Bucket Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 1 (D00-1-010) |
| WK-SCP0016-0031 | B6 | cboDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND cboDivision / Division | 있음(FE 소스) | 1 (D00-1-001) |
| WK-SCP0016-0032 | B6 | clbElecType / Electrode / Elec Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbElecType / Electrode / Elec Type | 있음(FE 소스) | 1 (D00-1-006) |
| WK-SCP0016-0033 | B6 | clbVersion / Version / Ver. | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B6(_verify.spec(@verify)) → 대상 COND clbVersion / Version / Ver. | 있음(FE 소스) | 1 (D00-1-009) |
| WK-SCP0016-0034 | F2 | SCP0016 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 F2(_verify.spec(@verify)) → 대상 SCREEN SCP0016 화면 | 판단불가(대상 단위 SCREEN) | 5 (1 6 EditButton(641) SaveButton(648) Wate) |
| WK-SCP0016-0035 | DB-SYN | PKG_SCP0016 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP PKG_SCP0016 | 없음(PROC_M 대응 없음) | 1 (D00-4a-001) |
| WK-SCP0016-0036 | DB-SYN | SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO | 없음(PROC_M 대응 없음) | 6 (ACT:SCP0016_WaterfallShipmentPlanFG.Find) |
| WK-SCP0016-0037 | DB-SYN | SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_T | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_TITLE_PARAL | 없음(PROC_M 대응 없음) | 6 (D00-4a-002 ACT:SCP0016_WaterfallShipment) |
| WK-SCP0016-0038 | G4 | btnColumn | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnColumn | 있음(FE 소스) | 2 (ACT:SCP0016_WaterfallShipmentPlanFG.Init) |
| WK-SCP0016-0039 | G4 | btnItem | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItem | 없음 | 2 (ACT:SCP0016_WaterfallShipmentPlanFG.Init) |
| WK-SCP0016-0040 | G4 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnMeasure | 있음(FE 소스) | 2 (ACT:SCP0016_WaterfallShipmentPlanFG.Init) |
| WK-SCP0016-0041 | G4 | btnProject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnProject | 있음(FE 소스) | 2 (ACT:SCP0016_WaterfallShipmentPlanFG.Init) |
| WK-SCP0016-0042 | G03-WIRE | SCP0016 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0016 화면 | 판단불가(대상 단위 SCREEN) | 15 (ACT:SCP0016_WaterfallShipmentPlanFG..cto) |
| WK-SCP0016-0043 | G5 | btnColumn | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnColumn | 있음(FE 소스) | 2 (D00-4e-001 SCM0002_TitleSetForm 'C'(btnC) |
| WK-SCP0016-0044 | G5 | btnItem | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnItem | 없음 | 1 (D00-1-007) |
| WK-SCP0016-0045 | G5 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnMeasure | 있음(FE 소스) | 2 (D00-4e-002 SCM0002_TitleSetForm 'M'(btnM) |
| WK-SCP0016-0046 | G5 | btnProject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 BTN btnProject | 있음(FE 소스) | 1 (D00-1-004) |
| WK-SCP0016-0047 | G5 | cboBucketType / Bucket / Bucket Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 3 (ACT:SCP0016_WaterfallShipmentPlanFG.SpdM) |
| WK-SCP0016-0048 | G5 | txtItem_Id / Model / Item_Id / Model/Nic | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND txtItem_Id / Model / Item_Id / Model/Nickname | 있음(FE 소스) | 2 (D00-1-005 4) |
| WK-SCP0016-0049 | G5 | txtProject / Project / PJT | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(_verify.spec(@verify)) → 대상 COND txtProject / Project / PJT | 있음(FE 소스) | 2 (D00-1-003 3) |
| WK-SCP0016-0050 | H6 | btnColumn | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnColumn | 있음(FE 소스) | 2 (D00-4e-001 SCM0002_TitleSetForm 'C'(btnC) |
| WK-SCP0016-0051 | H6 | btnItem | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnItem | 없음 | 1 (D00-1-007) |
| WK-SCP0016-0052 | H6 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnMeasure | 있음(FE 소스) | 2 (D00-4e-002 SCM0002_TitleSetForm 'M'(btnM) |
| WK-SCP0016-0053 | H6 | btnProject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnProject | 있음(FE 소스) | 1 (D00-1-004) |

## W6 검증 실행 (85)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0016-0054 | J2 | SCP0016 화면 | E2E(auth/authcrud 스펙 생성·실행) | J2 실행 — SCP0016 화면 · 검사기 있음(auth·authcrud spec) — 실행 필요: auth |  | 67 (D00-1-004 D00-1-007 D00-2-003 D00-2-004 ) |
| WK-SCP0016-0055 | C1 | cboBizType / Operation Group / Biz Type  | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboBizType / Operation Group / Biz Type / Operatio · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 2 (ACT:SCP0016_WaterfallShipmentPlanFG.Init) |
| WK-SCP0016-0056 | C1 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 4 (D00-2-007 D00-4b-012 9 ACT:SCP0016_Water) |
| WK-SCP0016-0057 | C1 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 4 (D00-2-001 D00-4b-007 ACT:SCP0016_Waterfa) |
| WK-SCP0016-0058 | C1 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 3 (D00-2-008 D00-4b-013 8) |
| WK-SCP0016-0059 | C1 | clbElecType / Electrode / Elec Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbElecType / Electrode / Elec Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 1 (ACT:SCP0016_WaterfallShipmentPlanFG.Init) |
| WK-SCP0016-0060 | C1 | clbVersion / Version / Ver. | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbVersion / Version / Ver. · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 3 (D00-2-002 D00-4b-008 ACT:SCP0016_Waterfa) |
| WK-SCP0016-0061 | C3 | MEASURE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — MEASURE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0016_WaterfallShipmentPlanFG.Set_) |
| WK-SCP0016-0062 | C3 | TO_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — TO_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:SCP0016_WaterfallShipmentPlanFG.SetS) |
| WK-SCP0016-0063 | C4 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 3 (D00-2-007 D00-4b-012 9) |
| WK-SCP0016-0064 | C4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 2 (D00-2-001 D00-4b-007) |
| WK-SCP0016-0065 | C4 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 3 (D00-2-008 D00-4b-013 8) |
| WK-SCP0016-0066 | C4 | clbVersion / Version / Ver. | E2E(검증 엔진 @trace 재실행(run_verify)) | C4 실행 — clbVersion / Version / Ver. · 검사기 있음(_trace.spec(@trace) 조건 변경→그리드 상태) — 실행 필요: trace |  | 2 (D00-2-002 D00-4b-008) |
| WK-SCP0016-0067 | G3 | SCP0016 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | G3 실행 — SCP0016 화면 · 검사기 있음(smoke 공통 기능(Condition·Reset)) — 실행 필요: smoke |  | 4 (D00-1-012 COMMON:UC-03 COMMON:UC-06 COMM) |
| WK-SCP0016-0068 | K-SA | SCP0016 화면 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke)) | K-SA 실행 — SCP0016 화면 · 검사기 있음(smoke 공통 기능(Search Area)) — 실행 필요: smoke |  | 1 (D00-1-012) |
| WK-SCP0016-0069 | K4 | SCP0016 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | K4 실행 — SCP0016 화면 · 검사기 있음(_trace.spec(@trace) 버튼 구성) — 실행 필요: trace |  | 41 (COMMON:UC-03 COMMON:UC-06 COMMON:UC-07 A) |
| WK-SCP0016-0070 | F1 | SCP0016 화면 | E2E(@verify 재실행(run_verify) / crud 스펙 생성 | F1 실행 — SCP0016 화면 · 검사기 있음(_verify.spec(@verify) 실저장·crud spec) — 실행 필요: crud |  | 5 (1 6 EditButton(641) SaveButton(648) Wate) |
| WK-SCP0016-0071 | F5 | SCP0016 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | F5 실행 — SCP0016 화면 · 검사기 있음(_trace.spec(@trace) W4b CRUD 상태 — Insert 행 CRUD_TYPE=I·편집 행 M 표시) — 실행 필요: trace |  | 2 (1 EditButton(641)) |
| WK-SCP0016-0072 | F4 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) —  |  | 108 (ACT:SCP0016_WaterfallShipmentPlanFG.Find) |
| WK-SCP0016-0073 | F4 | PKG_SCP0016 | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0016 · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 1 (D00-4a-001) |
| WK-SCP0016-0074 | F4 | PKG_SCP0016.P_SCP0016_GET_SHIPMENT_PLAN_ | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_SCP0016.P_SCP0016_GET_SHIPMENT_PLAN_FG_WATERFA · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 109 (D00-4a-001 ACT:SCP0016_WaterfallShipment) |
| WK-SCP0016-0075 | F4 | SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smo |  | 108 (ACT:SCP0016_WaterfallShipmentPlanFG.Find) |
| WK-SCP0016-0076 | F4 | SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_T | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_TITLE_PARAL · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 109 (D00-4a-002 ACT:SCP0016_WaterfallShipment) |
| WK-SCP0016-0077 | A5 | TO_YYYYMMDD | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — TO_YYYYMMDD · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:SCP0016_WaterfallShipmentPlanFG.SetS) |
| WK-SCP0016-0078 | G4 | cboBizType / Operation Group / Biz Type  | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboBizType / Operation Group / Biz Type / Operatio · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-002 ACT:SCP0016_WaterfallShipmentP) |
| WK-SCP0016-0079 | G4 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 12 (D00-1-010 ACT:SCP0016_WaterfallShipmentP) |
| WK-SCP0016-0080 | G4 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (D00-1-001 ACT:SCP0016_WaterfallShipmentP) |
| WK-SCP0016-0081 | G4 | chkSum / Sum | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkSum / Sum · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-011 ACT:SCP0016_WaterfallShipmentP) |
| WK-SCP0016-0082 | G4 | clbElecType / Electrode / Elec Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbElecType / Electrode / Elec Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (D00-1-006 ACT:SCP0016_WaterfallShipmentP) |
| WK-SCP0016-0083 | G4 | clbVersion / Version / Ver. | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbVersion / Version / Ver. · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (D00-1-009 ACT:SCP0016_WaterfallShipmentP) |
| WK-SCP0016-0084 | G4 | txtItem_Id / Model / Item_Id / Model/Nic | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtItem_Id / Model / Item_Id / Model/Nickname · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-005) |
| WK-SCP0016-0085 | G4 | txtProject / Project / PJT | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtProject / Project / PJT · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 1 (D00-1-003) |
| WK-SCP0016-0086 | H2 | TO_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — TO_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:SCP0016_WaterfallShipmentPlanFG.SetS) |
| WK-SCP0016-0087 | H4 | SCP0016 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | H4 실행 — SCP0016 화면 · 검사기 있음(_trace.spec(@trace) W4b 레이아웃 — 가로 스크롤·그리드 높이·컬럼 폭 실측(기대 = AS-IS 폭 메타)) — 실행 필요: trace |  | 8 (D00-2-011 D00-4b-010 11 TopChange sticky) |
| WK-SCP0016-0088 | H5 | TO_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — TO_YYYYMMDD · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:SCP0016_WaterfallShipmentPlanFG.SetS) |
| WK-SCP0016-0089 | H5 | cboBucketType / Bucket / Bucket Type | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) —  |  | 21 (9 ACT:SCP0016_WaterfallShipmentPlanFG.Se) |
| WK-SCP0016-0090 | H5 | chkSum / Sum | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — chkSum / Sum · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 6 (BucketType×chkSum visible 8분기(#33~40, R1) |
| WK-SCP0016-0091 | I1 | SCP0016 화면 | E2E(judge.py META 판정(DB 접속)) | I1 실행 — SCP0016 화면 · 검사기 있음(judge(DB 조회)·하네스 I18N1) — 실행 필요: meta |  | 5 (1 2 EditButton(641) ACT:SCP0016_Waterfal) |
| WK-SCP0016-0092 | SC1 | SCP0016 화면 | E2E(mapping_trace.py 재실행 / smoke 스펙 생성·실 | SC1 실행 — SCP0016 화면 · 검사기 있음(check.js SC1·smoke 기준표 순서) — 실행 필요: smoke |  | 16 (D00-1-001 D00-1-002 D00-1-003 D00-1-005 ) |
| WK-SCP0016-0093 | D5 | TO_YYYYMMDD | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — TO_YYYYMMDD · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:SCP0016_WaterfallShipmentPlanFG.SetS) |
| WK-SCP0016-0094 | D6 | SCP0016 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | D6 실행 — SCP0016 화면 · 검사기 있음(_trace.spec(@trace) Insert 위치) — 실행 필요: trace |  | 4 (COMMON:UC-03 1 EditButton(641) ProgressF) |
| WK-SCP0016-0095 | E4 | MEASURE | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MEASURE · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0016_WaterfallShipmentPlanFG.Set_) |
| WK-SCP0016-0096 | E4 | MSG00109 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00109 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 3 (1 EditButton(641) ACT:SCP0016_WaterfallS) |
| WK-SCP0016-0097 | E4 | TO_YYYYMMDD | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — TO_YYYYMMDD · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (ACT:SCP0016_WaterfallShipmentPlanFG.SetS) |
| WK-SCP0016-0098 | E4 | cboBizType / Operation Group / Biz Type  | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboBizType / Operation Group / Biz Type / Operatio · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요 |  | 2 (ACT:SCP0016_WaterfallShipmentPlanFG.SetO) |
| WK-SCP0016-0099 | E4 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 |  | 22 (ACT:SCP0016_WaterfallShipmentPlanFG.SetS) |
| WK-SCP0016-0100 | E4 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 7 (ACT:SCP0016_WaterfallShipmentPlanFG.SetC) |
| WK-SCP0016-0101 | E4 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (ACT:SCP0016_WaterfallShipmentPlanFG.SetS) |
| WK-SCP0016-0102 | E4 | clbElecType / Electrode / Elec Type | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbElecType / Electrode / Elec Type · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장  |  | 4 (ACT:SCP0016_WaterfallShipmentPlanFG.SetC) |
| WK-SCP0016-0103 | E4 | clbVersion / Version / Ver. | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbVersion / Version / Ver. · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — |  | 2 (ACT:SCP0016_WaterfallShipmentPlanFG.SetC) |
| WK-SCP0016-0104 | A10 | SCP0016 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | A10 실행 — SCP0016 화면 · 검사기 있음(_trace.spec(@trace) 조회 전 그리드) — 실행 필요: trace |  | 108 (ACT:SCP0016_WaterfallShipmentPlanFG.Defi) |
| WK-SCP0016-0105 | A6 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새 |  | 106 (ACT:SCP0016_WaterfallShipmentPlanFG.Find) |
| WK-SCP0016-0106 | A6 | PKG_SCP0016 | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0016 · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _trace.spec(@trace) |  | 1 (D00-4a-001) |
| WK-SCP0016-0107 | A6 | PKG_SCP0016.P_SCP0016_GET_SHIPMENT_PLAN_ | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — PKG_SCP0016.P_SCP0016_GET_SHIPMENT_PLAN_FG_WATERFA · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOUR |  | 109 (D00-4a-001 ACT:SCP0016_WaterfallShipment) |
| WK-SCP0016-0108 | A6 | SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOURCE 새로 조회) · _t |  | 106 (ACT:SCP0016_WaterfallShipmentPlanFG.Find) |
| WK-SCP0016-0109 | A6 | SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_T | E2E(mapping_trace.py 재실행 / 검증 엔진 @trace  | A6 실행 — SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_TITLE_PARAL · 검사기 있음(sort_check.py(AS-IS SP ORDER BY ↔ TO-BE PKG ORDER BY, ALL_SOUR |  | 109 (D00-4a-002 ACT:SCP0016_WaterfallShipment) |
| WK-SCP0016-0110 | G1 | cboBizType / Operation Group / Biz Type  | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboBizType / Operation Group / Biz Type / Operatio · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-002 ACT:SCP0016_WaterfallShipmentP) |
| WK-SCP0016-0111 | G1 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (D00-1-010 9 ACT:SCP0016_WaterfallShipmen) |
| WK-SCP0016-0112 | G1 | cboDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — cboDivision / Division · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (D00-1-001 D00-4b-007 ACT:SCP0016_Waterfa) |
| WK-SCP0016-0113 | G1 | chkSum / Sum | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — chkSum / Sum · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 1 (D00-1-011) |
| WK-SCP0016-0114 | G1 | clbElecType / Electrode / Elec Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbElecType / Electrode / Elec Type · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-006 ACT:SCP0016_WaterfallShipmentP) |
| WK-SCP0016-0115 | G1 | clbVersion / Version / Ver. | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — clbVersion / Version / Ver. · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (D00-1-009 ACT:SCP0016_WaterfallShipmentP) |
| WK-SCP0016-0116 | G1 | txtItem_Id / Model / Item_Id / Model/Nic | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItem_Id / Model / Item_Id / Model/Nickname · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (D00-1-005 4 ACT:SCP0016_WaterfallShipmen) |
| WK-SCP0016-0117 | G1 | txtProject / Project / PJT | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtProject / Project / PJT · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 4 (D00-1-003 3 ACT:SCP0016_WaterfallShipmen) |
| WK-SCP0016-0118 | G6 | cboBizType / Operation Group / Biz Type  | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboBizType / Operation Group / Biz Type / Operatio · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-002 ACT:SCP0016_WaterfallShipmentP) |
| WK-SCP0016-0119 | G6 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 11 (D00-1-010 ACT:SCP0016_WaterfallShipmentP) |
| WK-SCP0016-0120 | G6 | cboDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (D00-1-001 ACT:SCP0016_WaterfallShipmentP) |
| WK-SCP0016-0121 | G6 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-011 ACT:SCP0016_WaterfallShipmentP) |
| WK-SCP0016-0122 | G6 | clbElecType / Electrode / Elec Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbElecType / Electrode / Elec Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 3 (D00-1-006 ACT:SCP0016_WaterfallShipmentP) |
| WK-SCP0016-0123 | G6 | clbVersion / Version / Ver. | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbVersion / Version / Ver. · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (D00-1-009 ACT:SCP0016_WaterfallShipmentP) |
| WK-SCP0016-0124 | G6 | txtItem_Id / Model / Item_Id / Model/Nic | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtItem_Id / Model / Item_Id / Model/Nickname · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-005) |
| WK-SCP0016-0125 | G6 | txtProject / Project / PJT | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtProject / Project / PJT · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 1 (D00-1-003) |
| WK-SCP0016-0126 | X-REOPEN | SCP0016 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — SCP0016 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 7 (ACT:SCP0016_WaterfallShipmentPlanFG.Disp) |
| WK-SCP0016-0127 | H6 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 3 (ACT:SCP0016_WaterfallShipmentPlanFG.SpdM) |
| WK-SCP0016-0128 | H6 | txtItem_Id / Model / Item_Id / Model/Nic | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtItem_Id / Model / Item_Id / Model/Nickname · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 2 (D00-1-005 4) |
| WK-SCP0016-0129 | H6 | txtProject / Project / PJT | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtProject / Project / PJT · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 2 (D00-1-003 3) |
| WK-SCP0016-0130 | M3 | btnColumn | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — btnColumn · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 1 (D00-4e-001) |
| WK-SCP0016-0131 | M3 | btnMeasure | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — btnMeasure · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류)) — 실행 필요: trace |  | 1 (D00-4e-002) |
| WK-SCP0016-0132 | M4 | btnColumn | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnColumn · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (D00-4e-001 SCM0002_TitleSetForm 'C'(btnC) |
| WK-SCP0016-0133 | M4 | btnItem | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnItem · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (D00-1-007) |
| WK-SCP0016-0134 | M4 | btnMeasure | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnMeasure · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (D00-4e-002 SCM0002_TitleSetForm 'M'(btnM) |
| WK-SCP0016-0135 | M4 | btnProject | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnProject · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (D00-1-004) |
| WK-SCP0016-0136 | M4 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (ACT:SCP0016_WaterfallShipmentPlanFG.SpdM) |
| WK-SCP0016-0137 | M4 | txtItem_Id / Model / Item_Id / Model/Nic | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtItem_Id / Model / Item_Id / Model/Nickname · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (D00-1-005 4) |
| WK-SCP0016-0138 | M4 | txtProject / Project / PJT | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtProject / Project / PJT · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (D00-1-003 3) |

## W7 기대값 확정 (316)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0016-0139 | C1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 1: 행 집계 — C1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0016-0140 | C1 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 2: 행 집계 — C1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0016-0141 | C1 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — 7: 행 집계 — C1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (7) |
| WK-SCP0016-0142 | C1 | D00-2-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — D00-2-009: 행 집계 — C1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-009) |
| WK-SCP0016-0143 | C1 | D00-4b-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C1 기대값 확정 — D00-4b-014: 행 집계 — C1 6요소: NOT_RUN:6 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-014) |
| WK-SCP0016-0144 | C3 | D00-3-023 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-3-023: 행 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-023) |
| WK-SCP0016-0145 | C3 | D00-3-024 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-3-024: 행 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-024) |
| WK-SCP0016-0146 | C3 | D00-3-025 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-3-025: 행 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-025) |
| WK-SCP0016-0147 | C3 | D00-3-026 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-3-026: 행 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-026) |
| WK-SCP0016-0148 | C3 | D00-3-027 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-3-027: 행 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-027) |
| WK-SCP0016-0149 | C3 | D00-3-028 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-3-028: 행 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-028) |
| WK-SCP0016-0150 | C3 | D00-3-029 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-3-029: 행 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-029) |
| WK-SCP0016-0151 | C3 | D00-3-030 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — D00-3-030: 행 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-030) |
| WK-SCP0016-0152 | C3 | SCP0016_WaterfallShipmentPlanFG.CboDivis | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.CboDivision_Select: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0016_WaterfallShipmentPlanFG.CboD) |
| WK-SCP0016-0153 | C3 | SCP0016_WaterfallShipmentPlanFG.ClbVersi | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.ClbVersion_Selecte: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0016_WaterfallShipmentPlanFG.ClbV) |
| WK-SCP0016-0154 | C3 | SCP0016_WaterfallShipmentPlanFG.SetChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.SetChangedControl: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0016_WaterfallShipmentPlanFG.SetC) |
| WK-SCP0016-0155 | C3 | SCP0016_WaterfallShipmentPlanFG.SetDataT | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.SetDataTableQtyDat: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0016_WaterfallShipmentPlanFG.SetD) |
| WK-SCP0016-0156 | C3 | SCP0016_WaterfallShipmentPlanFG.SetOpera | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.SetOperationGroupB: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0016_WaterfallShipmentPlanFG.SetO) |
| WK-SCP0016-0157 | C3 | SCP0016_WaterfallShipmentPlanFG.SetSprea | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.SetSpreadColumn: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0016_WaterfallShipmentPlanFG.SetS) |
| WK-SCP0016-0158 | C3 | SCP0016_WaterfallShipmentPlanFG.Set_SumV | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.Set_SumValues: 진입점 집계 — C3 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 28 (ACT:SCP0016_WaterfallShipmentPlanFG.Set_) |
| WK-SCP0016-0159 | C3 | SCP0016_WaterfallShipmentPlanFG.cboBucke | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.cboBucketType_Sele: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0016_WaterfallShipmentPlanFG.cboB) |
| WK-SCP0016-0160 | C3 | SCP0016_WaterfallShipmentPlanFG.chkSum_C | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.chkSum_CheckedChan: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 2 (ACT:SCP0016_WaterfallShipmentPlanFG.chkS) |
| WK-SCP0016-0161 | C3 | SCP0016_WaterfallShipmentPlanFG.dCalenda | 사람 판정 / AS-IS 원문 확인 → 재판정 | C3 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.dCalendar_ValueCha: 진입점 집계 — C3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0016_WaterfallShipmentPlanFG.dCal) |
| WK-SCP0016-0162 | C4 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — 1: 행 집계 — C4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0016-0163 | C4 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — 2: 행 집계 — C4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0016-0164 | C4 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — 7: 행 집계 — C4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (7) |
| WK-SCP0016-0165 | C4 | D00-2-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — D00-2-009: 행 집계 — C4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-009) |
| WK-SCP0016-0166 | C4 | D00-4b-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | C4 기대값 확정 — D00-4b-014: 행 집계 — C4 4요소: NOT_RUN:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-014) |
| WK-SCP0016-0167 | B3 | BucketISO(221) | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — BucketISO(221): 행 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 1 (BucketISO(221)) |
| WK-SCP0016-0168 | B3 | LookupCommon ELECTRODE_TYPE(206) | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — LookupCommon ELECTRODE_TYPE(206): 행 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 1 (LookupCommon ELECTRODE_TYPE(206)) |
| WK-SCP0016-0169 | B3 | LookupCommon OPERATION_GROUP(203) | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — LookupCommon OPERATION_GROUP(203): 행 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 1 (LookupCommon OPERATION_GROUP(203)) |
| WK-SCP0016-0170 | B3 | MyDivisionInEE(49) | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — MyDivisionInEE(49): 행 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 1 (MyDivisionInEE(49)) |
| WK-SCP0016-0171 | B3 | OperationGroup(928) / OperationGroupEE(9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — OperationGroup(928) / OperationGroupEE(932): 행 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 1 (OperationGroup(928) / OperationGroupEE(9) |
| WK-SCP0016-0172 | B3 | SCP0016_WaterfallShipmentPlanFG.GetBucke | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.GetBucketType: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0016_WaterfallShipmentPlanFG.GetB) |
| WK-SCP0016-0173 | B3 | SCP0016_WaterfallShipmentPlanFG.GetDayRa | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.GetDayRange: 진입점 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0016_WaterfallShipmentPlanFG.GetD) |
| WK-SCP0016-0174 | B3 | SCP0016_WaterfallShipmentPlanFG.GetSpdTi | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.GetSpdTitle: 진입점 집계 — B3 1요소: TODO:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0016_WaterfallShipmentPlanFG.GetS) |
| WK-SCP0016-0175 | B3 | WaterfallVer_FG2(234) | 사람 판정 / AS-IS 원문 확인 → 재판정 | B3 기대값 확정 — WaterfallVer_FG2(234): 행 집계 — B3 3요소: TODO:3 (미실행 요소가 남아 판정필요) |  | 1 (WaterfallVer_FG2(234)) |
| WK-SCP0016-0176 | B4 | BucketISO(221) | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — BucketISO(221): 행 집계 — B4 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (BucketISO(221)) |
| WK-SCP0016-0177 | B4 | LookupCommon ELECTRODE_TYPE(206) | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — LookupCommon ELECTRODE_TYPE(206): 행 집계 — B4 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (LookupCommon ELECTRODE_TYPE(206)) |
| WK-SCP0016-0178 | B4 | LookupCommon OPERATION_GROUP(203) | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — LookupCommon OPERATION_GROUP(203): 행 집계 — B4 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (LookupCommon OPERATION_GROUP(203)) |
| WK-SCP0016-0179 | B4 | MyDivisionInEE(49) | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — MyDivisionInEE(49): 행 집계 — B4 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (MyDivisionInEE(49)) |
| WK-SCP0016-0180 | B4 | OperationGroup(928) / OperationGroupEE(9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — OperationGroup(928) / OperationGroupEE(932): 행 집계 — B4 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (OperationGroup(928) / OperationGroupEE(9) |
| WK-SCP0016-0181 | B4 | SCP0016_WaterfallShipmentPlanFG.GetBucke | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.GetBucketType: 진입점 집계 — B4 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0016_WaterfallShipmentPlanFG.GetB) |
| WK-SCP0016-0182 | B4 | SCP0016_WaterfallShipmentPlanFG.GetDayRa | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.GetDayRange: 진입점 집계 — B4 3요소: NOPATH:3 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0016_WaterfallShipmentPlanFG.GetD) |
| WK-SCP0016-0183 | B4 | SCP0016_WaterfallShipmentPlanFG.GetSpdTi | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.GetSpdTitle: 진입점 집계 — B4 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0016_WaterfallShipmentPlanFG.GetS) |
| WK-SCP0016-0184 | B4 | WaterfallVer_FG2(234) | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — WaterfallVer_FG2(234): 행 집계 — B4 5요소: NOPATH:5 (미실행 요소가 남아 판정필요) |  | 1 (WaterfallVer_FG2(234)) |
| WK-SCP0016-0185 | DB-SYN | D00-4a-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — D00-4a-003: 행 집계 — DB-SYN 5요소: NOPATH:3 · PASS:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4a-003) |
| WK-SCP0016-0186 | DB-SYN | FindButton(636) | 사람 판정 / AS-IS 원문 확인 → 재판정 | DB-SYN 기대값 확정 — FindButton(636): 행 집계 — DB-SYN 5요소: NOPATH:3 · PASS:2 (미실행 요소가 남아 판정필요) |  | 1 (FindButton(636)) |
| WK-SCP0016-0187 | F4 | D00-4a-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — D00-4a-003: 행 집계 — F4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-4a-003) |
| WK-SCP0016-0188 | F4 | FindButton(636) | 사람 판정 / AS-IS 원문 확인 → 재판정 | F4 기대값 확정 — FindButton(636): 행 집계 — F4 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (FindButton(636)) |
| WK-SCP0016-0189 | A5 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 7: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (7) |
| WK-SCP0016-0190 | A5 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 9: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (9) |
| WK-SCP0016-0191 | A5 | BucketType×chkSum visible 8분기(#33~40, R1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — BucketType×chkSum visible 8분기(#33~40, R12): 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (BucketType×chkSum visible 8분기(#33~40, R1) |
| WK-SCP0016-0192 | A5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — COMMON:UC-07: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0016-0193 | A5 | D00-1-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-011: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-011) |
| WK-SCP0016-0194 | A5 | D00-1-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-013: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-013) |
| WK-SCP0016-0195 | A5 | D00-1-016 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-1-016: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-016) |
| WK-SCP0016-0196 | A5 | D00-3-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-3-020: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-020) |
| WK-SCP0016-0197 | A5 | D00-3-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-3-021: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-021) |
| WK-SCP0016-0198 | A5 | D00-3-033 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-3-033: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-033) |
| WK-SCP0016-0199 | A5 | D00-3-034 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-3-034: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-034) |
| WK-SCP0016-0200 | A5 | D00-3-035 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-3-035: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-035) |
| WK-SCP0016-0201 | A5 | D00-3-036 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-3-036: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-036) |
| WK-SCP0016-0202 | A5 | D00-3-037 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-3-037: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-037) |
| WK-SCP0016-0203 | A5 | D00-3-038 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-3-038: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-038) |
| WK-SCP0016-0204 | A5 | D00-3-039 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-3-039: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-039) |
| WK-SCP0016-0205 | A5 | D00-3-040 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — D00-3-040: 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-040) |
| WK-SCP0016-0206 | A5 | SCP0016_WaterfallShipmentPlanFG.CreateSp | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.CreateSpread: 진입점 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0016_WaterfallShipmentPlanFG.Crea) |
| WK-SCP0016-0207 | A5 | SCP0016_WaterfallShipmentPlanFG.SetSprea | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.SetSpreadColumn: 진입점 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0016_WaterfallShipmentPlanFG.SetS) |
| WK-SCP0016-0208 | A5 | SmartColMerge 세로병합(#1/#19/#22, R2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — SmartColMerge 세로병합(#1/#19/#22, R2): 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (SmartColMerge 세로병합(#1/#19/#22, R2)) |
| WK-SCP0016-0209 | A5 | TopChange sticky(#19) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — TopChange sticky(#19): 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (TopChange sticky(#19)) |
| WK-SCP0016-0210 | A5 | 그리드 바인딩(#20, R3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 그리드 바인딩(#20, R3): 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (그리드 바인딩(#20, R3)) |
| WK-SCP0016-0211 | A5 | 다단 헤더 span 3단(#3~18, R5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 다단 헤더 span 3단(#3~18, R5): 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (다단 헤더 span 3단(#3~18, R5)) |
| WK-SCP0016-0212 | A5 | 더블클릭 펼침/접기(#31, R10) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 더블클릭 펼침/접기(#31, R10): 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (더블클릭 펼침/접기(#31, R10)) |
| WK-SCP0016-0213 | A5 | 숫자 셀타입(#2/#6/#7, R4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 숫자 셀타입(#2/#6/#7, R4): 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (숫자 셀타입(#2/#6/#7, R4)) |
| WK-SCP0016-0214 | A5 | 요일 헤더색(#8, R9) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 요일 헤더색(#8, R9): 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (요일 헤더색(#8, R9)) |
| WK-SCP0016-0215 | A5 | 월/주합 파생 SetValue(#23~30, R6~R8) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 월/주합 파생 SetValue(#23~30, R6~R8): 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (월/주합 파생 SetValue(#23~30, R6~R8)) |
| WK-SCP0016-0216 | A5 | 전 컬럼 Lock(#21, R1) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 전 컬럼 Lock(#21, R1): 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (전 컬럼 Lock(#21, R1)) |
| WK-SCP0016-0217 | A5 | 헤더높이(#32, R11) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A5 기대값 확정 — 헤더높이(#32, R11): 행 집계 — A5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (헤더높이(#32, R11)) |
| WK-SCP0016-0218 | G4 | BucketISO(221) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — BucketISO(221): 행 집계 — G4 12요소: NOT_RUN:8 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (BucketISO(221)) |
| WK-SCP0016-0219 | G4 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — COMMON:UC-06: 행 집계 — G4 12요소: NOT_RUN:8 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0016-0220 | G4 | D00-1-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — D00-1-012: 행 집계 — G4 12요소: NOT_RUN:8 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-012) |
| WK-SCP0016-0221 | G4 | LookupCommon ELECTRODE_TYPE(206) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — LookupCommon ELECTRODE_TYPE(206): 행 집계 — G4 12요소: NOT_RUN:8 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (LookupCommon ELECTRODE_TYPE(206)) |
| WK-SCP0016-0222 | G4 | LookupCommon OPERATION_GROUP(203) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — LookupCommon OPERATION_GROUP(203): 행 집계 — G4 12요소: NOT_RUN:8 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (LookupCommon OPERATION_GROUP(203)) |
| WK-SCP0016-0223 | G4 | MyDivisionInEE(49) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — MyDivisionInEE(49): 행 집계 — G4 12요소: NOT_RUN:8 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (MyDivisionInEE(49)) |
| WK-SCP0016-0224 | G4 | OperationGroup(928) / OperationGroupEE(9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — OperationGroup(928) / OperationGroupEE(932): 행 집계 — G4 12요소: NOT_RUN:8 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (OperationGroup(928) / OperationGroupEE(9) |
| WK-SCP0016-0225 | G4 | WaterfallVer_FG2(234) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G4 기대값 확정 — WaterfallVer_FG2(234): 행 집계 — G4 12요소: NOT_RUN:8 · NOPATH:4 (미실행 요소가 남아 판정필요) |  | 1 (WaterfallVer_FG2(234)) |
| WK-SCP0016-0226 | H2 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 11: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (11) |
| WK-SCP0016-0227 | H2 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 9: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (9) |
| WK-SCP0016-0228 | H2 | BucketType×chkSum visible 8분기(#33~40, R1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — BucketType×chkSum visible 8분기(#33~40, R12): 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (BucketType×chkSum visible 8분기(#33~40, R1) |
| WK-SCP0016-0229 | H2 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — COMMON:UC-07: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0016-0230 | H2 | D00-1-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-1-013: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-013) |
| WK-SCP0016-0231 | H2 | D00-1-016 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-1-016: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-016) |
| WK-SCP0016-0232 | H2 | D00-2-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-2-011: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-011) |
| WK-SCP0016-0233 | H2 | D00-3-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-3-008: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-008) |
| WK-SCP0016-0234 | H2 | D00-3-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-3-020: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-020) |
| WK-SCP0016-0235 | H2 | D00-3-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-3-021: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-021) |
| WK-SCP0016-0236 | H2 | D00-4b-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — D00-4b-010: 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-010) |
| WK-SCP0016-0237 | H2 | SCP0016_WaterfallShipmentPlanFG.CreateSp | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.CreateSpread: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0016_WaterfallShipmentPlanFG.Crea) |
| WK-SCP0016-0238 | H2 | SCP0016_WaterfallShipmentPlanFG.SetSprea | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.SetSpreadColumn: 진입점 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0016_WaterfallShipmentPlanFG.SetS) |
| WK-SCP0016-0239 | H2 | SmartColMerge 세로병합(#1/#19/#22, R2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — SmartColMerge 세로병합(#1/#19/#22, R2): 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (SmartColMerge 세로병합(#1/#19/#22, R2)) |
| WK-SCP0016-0240 | H2 | TopChange sticky(#19) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — TopChange sticky(#19): 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (TopChange sticky(#19)) |
| WK-SCP0016-0241 | H2 | 그리드 바인딩(#20, R3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 그리드 바인딩(#20, R3): 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (그리드 바인딩(#20, R3)) |
| WK-SCP0016-0242 | H2 | 다단 헤더 span 3단(#3~18, R5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 다단 헤더 span 3단(#3~18, R5): 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (다단 헤더 span 3단(#3~18, R5)) |
| WK-SCP0016-0243 | H2 | 더블클릭 펼침/접기(#31, R10) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 더블클릭 펼침/접기(#31, R10): 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (더블클릭 펼침/접기(#31, R10)) |
| WK-SCP0016-0244 | H2 | 숫자 셀타입(#2/#6/#7, R4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 숫자 셀타입(#2/#6/#7, R4): 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (숫자 셀타입(#2/#6/#7, R4)) |
| WK-SCP0016-0245 | H2 | 요일 헤더색(#8, R9) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 요일 헤더색(#8, R9): 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (요일 헤더색(#8, R9)) |
| WK-SCP0016-0246 | H2 | 월/주합 파생 SetValue(#23~30, R6~R8) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 월/주합 파생 SetValue(#23~30, R6~R8): 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (월/주합 파생 SetValue(#23~30, R6~R8)) |
| WK-SCP0016-0247 | H2 | 전 컬럼 Lock(#21, R1) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 전 컬럼 Lock(#21, R1): 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (전 컬럼 Lock(#21, R1)) |
| WK-SCP0016-0248 | H2 | 헤더높이(#32, R11) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H2 기대값 확정 — 헤더높이(#32, R11): 행 집계 — H2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (헤더높이(#32, R11)) |
| WK-SCP0016-0249 | H5 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — COMMON:UC-07: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0016-0250 | H5 | D00-1-013 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-1-013: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-013) |
| WK-SCP0016-0251 | H5 | D00-1-016 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-1-016: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-016) |
| WK-SCP0016-0252 | H5 | D00-3-020 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-3-020: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-020) |
| WK-SCP0016-0253 | H5 | D00-3-021 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — D00-3-021: 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-3-021) |
| WK-SCP0016-0254 | H5 | SCP0016_WaterfallShipmentPlanFG.CreateSp | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.CreateSpread: 진입점 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0016_WaterfallShipmentPlanFG.Crea) |
| WK-SCP0016-0255 | H5 | SCP0016_WaterfallShipmentPlanFG.SetSprea | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.SetSpreadColumn: 진입점 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0016_WaterfallShipmentPlanFG.SetS) |
| WK-SCP0016-0256 | H5 | SmartColMerge 세로병합(#1/#19/#22, R2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — SmartColMerge 세로병합(#1/#19/#22, R2): 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (SmartColMerge 세로병합(#1/#19/#22, R2)) |
| WK-SCP0016-0257 | H5 | TopChange sticky(#19) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — TopChange sticky(#19): 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (TopChange sticky(#19)) |
| WK-SCP0016-0258 | H5 | 그리드 바인딩(#20, R3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 그리드 바인딩(#20, R3): 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (그리드 바인딩(#20, R3)) |
| WK-SCP0016-0259 | H5 | 다단 헤더 span 3단(#3~18, R5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 다단 헤더 span 3단(#3~18, R5): 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (다단 헤더 span 3단(#3~18, R5)) |
| WK-SCP0016-0260 | H5 | 더블클릭 펼침/접기(#31, R10) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 더블클릭 펼침/접기(#31, R10): 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (더블클릭 펼침/접기(#31, R10)) |
| WK-SCP0016-0261 | H5 | 숫자 셀타입(#2/#6/#7, R4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 숫자 셀타입(#2/#6/#7, R4): 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (숫자 셀타입(#2/#6/#7, R4)) |
| WK-SCP0016-0262 | H5 | 요일 헤더색(#8, R9) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 요일 헤더색(#8, R9): 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (요일 헤더색(#8, R9)) |
| WK-SCP0016-0263 | H5 | 월/주합 파생 SetValue(#23~30, R6~R8) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 월/주합 파생 SetValue(#23~30, R6~R8): 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (월/주합 파생 SetValue(#23~30, R6~R8)) |
| WK-SCP0016-0264 | H5 | 전 컬럼 Lock(#21, R1) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 전 컬럼 Lock(#21, R1): 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (전 컬럼 Lock(#21, R1)) |
| WK-SCP0016-0265 | H5 | 헤더높이(#32, R11) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H5 기대값 확정 — 헤더높이(#32, R11): 행 집계 — H5 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (헤더높이(#32, R11)) |
| WK-SCP0016-0266 | X-REASON | COMMON:UC-02 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-02 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4)  조회전용 화면 — 편집  |  | 1 (COMMON:UC-02) |
| WK-SCP0016-0267 | X-REASON | COMMON:UC-05 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-05 Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7)  그리드 셀 콤보 0건(전 FPT |  | 1 (COMMON:UC-05) |
| WK-SCP0016-0268 | X-REASON | CRUD:D00-4b-003:SAVE | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CRUD:D00-4b-003:SAVE [SAVE] §4b SaveButton / toolbarOverride / Save  조회전용 화면 — AS-IS NO-OP/미노출, DB 버튼 메타 미등록 해당 |  | 1 (CRUD:D00-4b-003:SAVE) |
| WK-SCP0016-0269 | X-REASON | D00-4b-003 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-4b-003 §4b SaveButton / toolbarOverride / Save  조회전용 화면 — AS-IS NO-OP/미노출, DB 버튼 메타 미등록 해당없음 |  | 1 (D00-4b-003) |
| WK-SCP0016-0270 | D5 | SCP0016_WaterfallShipmentPlanFG.CreateSp | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.CreateSpread: 진입점 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 4 (ACT:SCP0016_WaterfallShipmentPlanFG.Crea) |
| WK-SCP0016-0271 | D5 | SCP0016_WaterfallShipmentPlanFG.SetSprea | 사람 판정 / AS-IS 원문 확인 → 재판정 | D5 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.SetSpreadColumn: 진입점 집계 — D5 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0016_WaterfallShipmentPlanFG.SetS) |
| WK-SCP0016-0272 | E4 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 11: 행 집계 — E4 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (11) |
| WK-SCP0016-0273 | E4 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 2: 행 집계 — E4 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (2) |
| WK-SCP0016-0274 | E4 | D00-2-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D00-2-011: 행 집계 — E4 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-011) |
| WK-SCP0016-0275 | E4 | D00-4b-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — D00-4b-010: 행 집계 — E4 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-010) |
| WK-SCP0016-0276 | E4 | SCP0016_WaterfallShipmentPlanFG.SetChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.SetChangedControl: 진입점 집계 — E4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0016_WaterfallShipmentPlanFG.SetC) |
| WK-SCP0016-0277 | E4 | SCP0016_WaterfallShipmentPlanFG.SetDataT | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.SetDataTableQtyDat: 진입점 집계 — E4 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 5 (ACT:SCP0016_WaterfallShipmentPlanFG.SetD) |
| WK-SCP0016-0278 | E4 | SCP0016_WaterfallShipmentPlanFG.SetOpera | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.SetOperationGroupB: 진입점 집계 — E4 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0016_WaterfallShipmentPlanFG.SetO) |
| WK-SCP0016-0279 | E4 | SCP0016_WaterfallShipmentPlanFG.SetSprea | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.SetSpreadColumn: 진입점 집계 — E4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 6 (ACT:SCP0016_WaterfallShipmentPlanFG.SetS) |
| WK-SCP0016-0280 | E4 | SCP0016_WaterfallShipmentPlanFG.Set_SumV | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.Set_SumValues: 진입점 집계 — E4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 28 (ACT:SCP0016_WaterfallShipmentPlanFG.Set_) |
| WK-SCP0016-0281 | E4 | TopChange sticky(#19) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — TopChange sticky(#19): 행 집계 — E4 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (TopChange sticky(#19)) |
| WK-SCP0016-0282 | E4 | 그리드 바인딩(#20, R3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E4 기대값 확정 — 그리드 바인딩(#20, R3): 행 집계 — E4 9요소: NOT_RUN:9 (미실행 요소가 남아 판정필요) |  | 1 (그리드 바인딩(#20, R3)) |
| WK-SCP0016-0283 | A1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1: 행 집계 — A1 5요소: REVIEW:5 |  | 0 () |
| WK-SCP0016-0284 | A1 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 2: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (2) |
| WK-SCP0016-0285 | A1 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 3: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (3) |
| WK-SCP0016-0286 | A1 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 4: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (4) |
| WK-SCP0016-0287 | A1 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 9: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (9) |
| WK-SCP0016-0288 | A1 | BucketISO(221) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — BucketISO(221): 행 집계 — A1 5요소: REVIEW:5 |  | 1 (BucketISO(221)) |
| WK-SCP0016-0289 | A1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-03: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (COMMON:UC-03) |
| WK-SCP0016-0290 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (COMMON:UC-06) |
| WK-SCP0016-0291 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (COMMON:UC-07) |
| WK-SCP0016-0292 | A1 | CRUD:D00-4b-001:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:D00-4b-001:SEARCH: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (CRUD:D00-4b-001:SEARCH) |
| WK-SCP0016-0293 | A1 | D00-1-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-004: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (D00-1-004) |
| WK-SCP0016-0294 | A1 | D00-1-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-007: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (D00-1-007) |
| WK-SCP0016-0295 | A1 | D00-2-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-003: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (D00-2-003) |
| WK-SCP0016-0296 | A1 | D00-2-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-004: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (D00-2-004) |
| WK-SCP0016-0297 | A1 | D00-4a-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4a-003: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (D00-4a-003) |
| WK-SCP0016-0298 | A1 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4b-001: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (D00-4b-001) |
| WK-SCP0016-0299 | A1 | D00-4b-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4b-005: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (D00-4b-005) |
| WK-SCP0016-0300 | A1 | D00-4b-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4b-006: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (D00-4b-006) |
| WK-SCP0016-0301 | A1 | D00-4b-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4b-007: 행 집계 — A1 5요소: REVIEW:5 |  | 1 (D00-4b-007) |
| WK-SCP0016-0302 | A1 | FindButton(636) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindButton(636): 행 집계 — A1 5요소: REVIEW:5 |  | 1 (FindButton(636)) |
| WK-SCP0016-0303 | A1 | LookupCommon ELECTRODE_TYPE(206) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — LookupCommon ELECTRODE_TYPE(206): 행 집계 — A1 5요소: REVIEW:5 |  | 1 (LookupCommon ELECTRODE_TYPE(206)) |
| WK-SCP0016-0304 | A1 | LookupCommon OPERATION_GROUP(203) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — LookupCommon OPERATION_GROUP(203): 행 집계 — A1 5요소: REVIEW:5 |  | 1 (LookupCommon OPERATION_GROUP(203)) |
| WK-SCP0016-0305 | A1 | MyDivisionInEE(49) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — MyDivisionInEE(49): 행 집계 — A1 5요소: REVIEW:5 |  | 1 (MyDivisionInEE(49)) |
| WK-SCP0016-0306 | A1 | OperationGroup(928) / OperationGroupEE(9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — OperationGroup(928) / OperationGroupEE(932): 행 집계 — A1 5요소: REVIEW:5 |  | 1 (OperationGroup(928) / OperationGroupEE(9) |
| WK-SCP0016-0307 | A1 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN: 골든 비교 케이스 없음(PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN — 팝업·보조 SP |  | 106 (ACT:SCP0016_WaterfallShipmentPlanFG.Find) |
| WK-SCP0016-0308 | A1 | PKG_SCP0016 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0016: 골든 비교 케이스 없음(PKG_SCP0016 — 팝업·보조 SP 는 golden_cases.csv 에 FE 실전송 파라미터로 케이스 추가 필요) |  | 1 (D00-4a-001) |
| WK-SCP0016-0309 | A1 | PKG_SCP0016.P_SCP0016_GET_SHIPMENT_PLAN_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0016.P_SCP0016_GET_SHIPMENT_PLAN_FG_WATERFA: 골든 비교 케이스 없음(PKG_SCP0016.P_SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL  |  | 109 (D00-4a-001 ACT:SCP0016_WaterfallShipment) |
| WK-SCP0016-0310 | A1 | SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO: 골든 비교 케이스 없음(SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO — 팝업·보조 SP 는 golden_cases.csv  |  | 106 (ACT:SCP0016_WaterfallShipmentPlanFG.Find) |
| WK-SCP0016-0311 | A1 | SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_T | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_TITLE_PARAL: 골든 비교 케이스 없음(SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_TITLE_PARAL —  |  | 109 (D00-4a-002 ACT:SCP0016_WaterfallShipment) |
| WK-SCP0016-0312 | A1 | SaveButton(648) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SaveButton(648): 행 집계 — A1 5요소: REVIEW:5 |  | 1 (SaveButton(648)) |
| WK-SCP0016-0313 | A1 | WaterfallVer_FG2(234) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — WaterfallVer_FG2(234): 행 집계 — A1 5요소: REVIEW:5 |  | 1 (WaterfallVer_FG2(234)) |
| WK-SCP0016-0314 | A6 | D00-4a-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — D00-4a-003: 행 집계 — A6 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (D00-4a-003) |
| WK-SCP0016-0315 | A6 | FindButton(636) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — FindButton(636): 행 집계 — A6 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 1 (FindButton(636)) |
| WK-SCP0016-0316 | G1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 1: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-SCP0016-0317 | G1 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — 2: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (2) |
| WK-SCP0016-0318 | G1 | BucketISO(221) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — BucketISO(221): 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (BucketISO(221)) |
| WK-SCP0016-0319 | G1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-03: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-03) |
| WK-SCP0016-0320 | G1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-06: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0016-0321 | G1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — COMMON:UC-07: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-07) |
| WK-SCP0016-0322 | G1 | CRUD:D00-4b-001:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — CRUD:D00-4b-001:SEARCH: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (CRUD:D00-4b-001:SEARCH) |
| WK-SCP0016-0323 | G1 | D00-1-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-004: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-004) |
| WK-SCP0016-0324 | G1 | D00-1-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-007: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-007) |
| WK-SCP0016-0325 | G1 | D00-1-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-1-012: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-012) |
| WK-SCP0016-0326 | G1 | D00-2-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-2-003: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-003) |
| WK-SCP0016-0327 | G1 | D00-2-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-2-004: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-004) |
| WK-SCP0016-0328 | G1 | D00-4a-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-4a-001: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4a-001) |
| WK-SCP0016-0329 | G1 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-4b-001: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-001) |
| WK-SCP0016-0330 | G1 | D00-4b-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-4b-005: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-005) |
| WK-SCP0016-0331 | G1 | D00-4b-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — D00-4b-006: 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-006) |
| WK-SCP0016-0332 | G1 | FindButton(636) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — FindButton(636): 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (FindButton(636)) |
| WK-SCP0016-0333 | G1 | LookupCommon ELECTRODE_TYPE(206) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — LookupCommon ELECTRODE_TYPE(206): 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (LookupCommon ELECTRODE_TYPE(206)) |
| WK-SCP0016-0334 | G1 | LookupCommon OPERATION_GROUP(203) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — LookupCommon OPERATION_GROUP(203): 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (LookupCommon OPERATION_GROUP(203)) |
| WK-SCP0016-0335 | G1 | MyDivisionInEE(49) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — MyDivisionInEE(49): 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (MyDivisionInEE(49)) |
| WK-SCP0016-0336 | G1 | OperationGroup(928) / OperationGroupEE(9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — OperationGroup(928) / OperationGroupEE(932): 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (OperationGroup(928) / OperationGroupEE(9) |
| WK-SCP0016-0337 | G1 | SaveButton(648) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — SaveButton(648): 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (SaveButton(648)) |
| WK-SCP0016-0338 | G1 | WaterfallVer_FG2(234) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G1 기대값 확정 — WaterfallVer_FG2(234): 행 집계 — G1 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (WaterfallVer_FG2(234)) |
| WK-SCP0016-0339 | G6 | BucketISO(221) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — BucketISO(221): 행 집계 — G6 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (BucketISO(221)) |
| WK-SCP0016-0340 | G6 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — COMMON:UC-06: 행 집계 — G6 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0016-0341 | G6 | D00-1-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — D00-1-012: 행 집계 — G6 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (D00-1-012) |
| WK-SCP0016-0342 | G6 | LookupCommon ELECTRODE_TYPE(206) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — LookupCommon ELECTRODE_TYPE(206): 행 집계 — G6 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (LookupCommon ELECTRODE_TYPE(206)) |
| WK-SCP0016-0343 | G6 | LookupCommon OPERATION_GROUP(203) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — LookupCommon OPERATION_GROUP(203): 행 집계 — G6 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (LookupCommon OPERATION_GROUP(203)) |
| WK-SCP0016-0344 | G6 | MyDivisionInEE(49) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — MyDivisionInEE(49): 행 집계 — G6 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (MyDivisionInEE(49)) |
| WK-SCP0016-0345 | G6 | OperationGroup(928) / OperationGroupEE(9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — OperationGroup(928) / OperationGroupEE(932): 행 집계 — G6 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (OperationGroup(928) / OperationGroupEE(9) |
| WK-SCP0016-0346 | G6 | WaterfallVer_FG2(234) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G6 기대값 확정 — WaterfallVer_FG2(234): 행 집계 — G6 8요소: NOT_RUN:8 (미실행 요소가 남아 판정필요) |  | 1 (WaterfallVer_FG2(234)) |
| WK-SCP0016-0347 | X-LOC | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 10: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (10) |
| WK-SCP0016-0348 | X-LOC | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 11: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (11) |
| WK-SCP0016-0349 | X-LOC | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (3) |
| WK-SCP0016-0350 | X-LOC | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (4) |
| WK-SCP0016-0351 | X-LOC | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (5) |
| WK-SCP0016-0352 | X-LOC | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 6: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (6) |
| WK-SCP0016-0353 | X-LOC | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 7: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (7) |
| WK-SCP0016-0354 | X-LOC | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 8: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (8) |
| WK-SCP0016-0355 | X-LOC | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 9: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (9) |
| WK-SCP0016-0356 | X-LOC | BucketISO(221) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — BucketISO(221): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (BucketISO(221)) |
| WK-SCP0016-0357 | X-LOC | BucketType×chkSum visible 8분기(#33~40, R1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — BucketType×chkSum visible 8분기(#33~40, R12): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (BucketType×chkSum visible 8분기(#33~40, R1) |
| WK-SCP0016-0358 | X-LOC | LookupCommon ELECTRODE_TYPE(206) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — LookupCommon ELECTRODE_TYPE(206): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (LookupCommon ELECTRODE_TYPE(206)) |
| WK-SCP0016-0359 | X-LOC | LookupCommon OPERATION_GROUP(203) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — LookupCommon OPERATION_GROUP(203): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (LookupCommon OPERATION_GROUP(203)) |
| WK-SCP0016-0360 | X-LOC | MyDivisionInEE(49) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MyDivisionInEE(49): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MyDivisionInEE(49)) |
| WK-SCP0016-0361 | X-LOC | OperationGroup(928) / OperationGroupEE(9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — OperationGroup(928) / OperationGroupEE(932): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (OperationGroup(928) / OperationGroupEE(9) |
| WK-SCP0016-0362 | X-LOC | SmartColMerge 세로병합(#1/#19/#22, R2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SmartColMerge 세로병합(#1/#19/#22, R2): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SmartColMerge 세로병합(#1/#19/#22, R2)) |
| WK-SCP0016-0363 | X-LOC | TopChange sticky(#19) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — TopChange sticky(#19): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (TopChange sticky(#19)) |
| WK-SCP0016-0364 | X-LOC | WaterfallVer_FG2(234) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — WaterfallVer_FG2(234): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (WaterfallVer_FG2(234)) |
| WK-SCP0016-0365 | X-LOC | 그리드 바인딩(#20, R3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 그리드 바인딩(#20, R3): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (그리드 바인딩(#20, R3)) |
| WK-SCP0016-0366 | X-LOC | 다단 헤더 span 3단(#3~18, R5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 다단 헤더 span 3단(#3~18, R5): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (다단 헤더 span 3단(#3~18, R5)) |
| WK-SCP0016-0367 | X-LOC | 더블클릭 펼침/접기(#31, R10) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 더블클릭 펼침/접기(#31, R10): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (더블클릭 펼침/접기(#31, R10)) |
| WK-SCP0016-0368 | X-LOC | 숫자 셀타입(#2/#6/#7, R4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 숫자 셀타입(#2/#6/#7, R4): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (숫자 셀타입(#2/#6/#7, R4)) |
| WK-SCP0016-0369 | X-LOC | 요일 헤더색(#8, R9) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 요일 헤더색(#8, R9): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (요일 헤더색(#8, R9)) |
| WK-SCP0016-0370 | X-LOC | 월/주합 파생 SetValue(#23~30, R6~R8) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 월/주합 파생 SetValue(#23~30, R6~R8): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (월/주합 파생 SetValue(#23~30, R6~R8)) |
| WK-SCP0016-0371 | X-LOC | 전 컬럼 Lock(#21, R1) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 전 컬럼 Lock(#21, R1): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (전 컬럼 Lock(#21, R1)) |
| WK-SCP0016-0372 | X-LOC | 헤더높이(#32, R11) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 헤더높이(#32, R11): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (헤더높이(#32, R11)) |
| WK-SCP0016-0373 | X-ROW | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — 5: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (5) |
| WK-SCP0016-0374 | X-ROW | D00-1-008 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-008: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-008) |
| WK-SCP0016-0375 | X-ROW | D00-1-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-014: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-014) |
| WK-SCP0016-0376 | X-ROW | D00-1-015 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-1-015: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-1-015) |
| WK-SCP0016-0377 | X-ROW | D00-2-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-2-005: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-2-005) |
| WK-SCP0016-0378 | X-ROW | D00-2-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-2-006: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-2-006) |
| WK-SCP0016-0379 | X-ROW | D00-3-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-005: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-005) |
| WK-SCP0016-0380 | X-ROW | D00-3-012 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-012: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-012) |
| WK-SCP0016-0381 | X-ROW | D00-3-014 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-014: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-014) |
| WK-SCP0016-0382 | X-ROW | D00-3-016 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-016: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-016) |
| WK-SCP0016-0383 | X-ROW | D00-3-031 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-031: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-031) |
| WK-SCP0016-0384 | X-ROW | D00-3-032 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-3-032: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-3-032) |
| WK-SCP0016-0385 | X-ROW | D00-4b-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4b-004: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4b-004) |
| WK-SCP0016-0386 | X-ROW | D00-4b-011 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — D00-4b-011: 진입점 동작 재현 시나리오 필요 — 문장 종류 , 연결된 요소 검사 없음 |  | 1 (D00-4b-011) |
| WK-SCP0016-0387 | X-ROW | SCP0016_WaterfallShipmentPlanFG.BtnColum | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.BtnColumn_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0016_WaterfallShipmentPlanFG.BtnC) |
| WK-SCP0016-0388 | X-ROW | SCP0016_WaterfallShipmentPlanFG.BtnItem_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.BtnItem_Id_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0016_WaterfallShipmentPlanFG.BtnI) |
| WK-SCP0016-0389 | X-ROW | SCP0016_WaterfallShipmentPlanFG.BtnProje | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.BtnProject_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0016_WaterfallShipmentPlanFG.BtnP) |
| WK-SCP0016-0390 | X-ROW | SCP0016_WaterfallShipmentPlanFG.CboDivis | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.CboDivision_Select: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0016_WaterfallShipmentPlanFG.CboD) |
| WK-SCP0016-0391 | X-ROW | SCP0016_WaterfallShipmentPlanFG.ClbVersi | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.ClbVersion_Selecte: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0016_WaterfallShipmentPlanFG.ClbV) |
| WK-SCP0016-0392 | X-ROW | SCP0016_WaterfallShipmentPlanFG.CreateSp | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.CreateSpread: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0016_WaterfallShipmentPlanFG.Crea) |
| WK-SCP0016-0393 | X-ROW | SCP0016_WaterfallShipmentPlanFG.DefinePr | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.DefineProperty: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0016_WaterfallShipmentPlanFG.Defi) |
| WK-SCP0016-0394 | X-ROW | SCP0016_WaterfallShipmentPlanFG.EditButt | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.EditButton: 진입점 집계 4검사 — NOT_RUN:4 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0016_WaterfallShipmentPlanFG.Edit) |
| WK-SCP0016-0395 | X-ROW | SCP0016_WaterfallShipmentPlanFG.FindButt | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.FindButton: 진입점 집계 12검사 — NOT_RUN:8 · REVIEW:4 |  | 1 (ACT:SCP0016_WaterfallShipmentPlanFG.Find) |
| WK-SCP0016-0396 | X-ROW | SCP0016_WaterfallShipmentPlanFG.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.FindData_Main: 진입점 집계 25검사 — NOT_RUN:17 · REVIEW:4 · PASS:2 · NOPATH:2 |  | 10 (ACT:SCP0016_WaterfallShipmentPlanFG.Find) |
| WK-SCP0016-0397 | X-ROW | SCP0016_WaterfallShipmentPlanFG.Form_Loa | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.Form_Load: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0016_WaterfallShipmentPlanFG.Form) |
| WK-SCP0016-0398 | X-ROW | SCP0016_WaterfallShipmentPlanFG.GetBucke | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.GetBucketType: 진입점 집계 2검사 — NOPATH:1 · TODO:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0016_WaterfallShipmentPlanFG.GetB) |
| WK-SCP0016-0399 | X-ROW | SCP0016_WaterfallShipmentPlanFG.InitCont | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.InitControls: 진입점 집계 15검사 — NOT_RUN:15 (미실행 검사가 남아 판정필요) |  | 7 (ACT:SCP0016_WaterfallShipmentPlanFG.Init) |
| WK-SCP0016-0400 | X-ROW | SCP0016_WaterfallShipmentPlanFG.InitSpre | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.InitSpreadDateColu: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SCP0016_WaterfallShipmentPlanFG.Init) |
| WK-SCP0016-0401 | X-ROW | SCP0016_WaterfallShipmentPlanFG.InitSpre | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.InitSpreadDateColu: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 16 (ACT:SCP0016_WaterfallShipmentPlanFG.Init) |
| WK-SCP0016-0402 | X-ROW | SCP0016_WaterfallShipmentPlanFG.InitSpre | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.InitSpread_2: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:SCP0016_WaterfallShipmentPlanFG.Init) |
| WK-SCP0016-0403 | X-ROW | SCP0016_WaterfallShipmentPlanFG.RetValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.RetValue: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/EXPR/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 5 (ACT:SCP0016_WaterfallShipmentPlanFG.RetV) |
| WK-SCP0016-0404 | X-ROW | SCP0016_WaterfallShipmentPlanFG.SetChang | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.SetChangedControl: 진입점 집계 7검사 — NOT_RUN:7 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0016_WaterfallShipmentPlanFG.SetC) |
| WK-SCP0016-0405 | X-ROW | SCP0016_WaterfallShipmentPlanFG.SetDataT | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.SetDataTableQtyDat: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0016_WaterfallShipmentPlanFG.SetD) |
| WK-SCP0016-0406 | X-ROW | SCP0016_WaterfallShipmentPlanFG.SetOpera | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.SetOperationGroupB: 진입점 집계 5검사 — NOT_RUN:5 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0016_WaterfallShipmentPlanFG.SetO) |
| WK-SCP0016-0407 | X-ROW | SCP0016_WaterfallShipmentPlanFG.SetSprea | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.SetSpreadColumn: 진입점 집계 16검사 — NOT_RUN:10 · REVIEW:6 |  | 8 (ACT:SCP0016_WaterfallShipmentPlanFG.SetS) |
| WK-SCP0016-0408 | X-ROW | SCP0016_WaterfallShipmentPlanFG.SetVisib | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.SetVisibleMontColu: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/GRID_INIT, 연결된 요소 검사 없음 |  | 2 (ACT:SCP0016_WaterfallShipmentPlanFG.SetV) |
| WK-SCP0016-0409 | X-ROW | SCP0016_WaterfallShipmentPlanFG.SetVisib | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.SetVisibleSum: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0016_WaterfallShipmentPlanFG.SetV) |
| WK-SCP0016-0410 | X-ROW | SCP0016_WaterfallShipmentPlanFG.Set_SumV | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.Set_SumValues: 진입점 집계 4검사 — REVIEW:2 · NOT_RUN:2 |  | 8 (ACT:SCP0016_WaterfallShipmentPlanFG.Set_) |
| WK-SCP0016-0411 | X-ROW | SCP0016_WaterfallShipmentPlanFG.SpdMain_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.SpdMain_TopChange: 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0016_WaterfallShipmentPlanFG.SpdM) |
| WK-SCP0016-0412 | X-ROW | SCP0016_WaterfallShipmentPlanFG.btnMeasu | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.btnMeasure_Click: 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 5 (ACT:SCP0016_WaterfallShipmentPlanFG.btnM) |
| WK-SCP0016-0413 | X-ROW | SCP0016_WaterfallShipmentPlanFG.cboBucke | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.cboBucketType_Sele: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0016_WaterfallShipmentPlanFG.cboB) |
| WK-SCP0016-0414 | X-ROW | SCP0016_WaterfallShipmentPlanFG.chkSum_C | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.chkSum_CheckedChan: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0016_WaterfallShipmentPlanFG.chkS) |
| WK-SCP0016-0415 | X-ROW | SCP0016_WaterfallShipmentPlanFG.dCalenda | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.dCalendar_ValueCha: 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0016_WaterfallShipmentPlanFG.dCal) |
| WK-SCP0016-0416 | G5 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — 10: 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (10) |
| WK-SCP0016-0417 | G5 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — COMMON:UC-06: 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0016-0418 | G5 | D00-2-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-2-010: 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-010) |
| WK-SCP0016-0419 | G5 | D00-4b-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-4b-009: 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-009) |
| WK-SCP0016-0420 | G5 | D00-4d-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-4d-001: 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-001) |
| WK-SCP0016-0421 | G5 | D00-4e-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-4e-003: 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-003) |
| WK-SCP0016-0422 | G5 | D00-4e-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — D00-4e-004: 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-004) |
| WK-SCP0016-0423 | G5 | MODAL:ShowDialog | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — MODAL:ShowDialog: 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ShowDialog) |
| WK-SCP0016-0424 | G5 | ProgressForm(로딩) | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — ProgressForm(로딩): 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (ProgressForm(로딩)) |
| WK-SCP0016-0425 | G5 | SCM0002_ItembyDivisionPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCM0002_ItembyDivisionPopup: 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (SCM0002_ItembyDivisionPopup) |
| WK-SCP0016-0426 | G5 | SCM0002_ProjectbyDivisionPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCM0002_ProjectbyDivisionPopup: 행 집계 — G5 7요소: NOPATH:7 (미실행 요소가 남아 판정필요) |  | 1 (SCM0002_ProjectbyDivisionPopup) |
| WK-SCP0016-0427 | G5 | SCP0016_WaterfallShipmentPlanFG.SpdMain_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | G5 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.SpdMain_CellDouble: 진입점 집계 — G5 1요소: NOPATH:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0016_WaterfallShipmentPlanFG.SpdM) |
| WK-SCP0016-0428 | H6 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — 10: 행 집계 — H6 7요소: NOPATH:4 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (10) |
| WK-SCP0016-0429 | H6 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — COMMON:UC-06: 행 집계 — H6 7요소: NOPATH:4 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0016-0430 | H6 | D00-2-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-2-010: 행 집계 — H6 7요소: NOPATH:4 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-010) |
| WK-SCP0016-0431 | H6 | D00-4b-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-4b-009: 행 집계 — H6 7요소: NOPATH:4 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-009) |
| WK-SCP0016-0432 | H6 | D00-4d-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-4d-001: 행 집계 — H6 7요소: NOPATH:4 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-001) |
| WK-SCP0016-0433 | H6 | D00-4e-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-4e-003: 행 집계 — H6 7요소: NOPATH:4 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-003) |
| WK-SCP0016-0434 | H6 | D00-4e-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — D00-4e-004: 행 집계 — H6 7요소: NOPATH:4 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-004) |
| WK-SCP0016-0435 | H6 | MODAL:ShowDialog | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — MODAL:ShowDialog: 행 집계 — H6 7요소: NOPATH:4 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ShowDialog) |
| WK-SCP0016-0436 | H6 | ProgressForm(로딩) | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — ProgressForm(로딩): 행 집계 — H6 7요소: NOPATH:4 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (ProgressForm(로딩)) |
| WK-SCP0016-0437 | H6 | SCM0002_ItembyDivisionPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCM0002_ItembyDivisionPopup: 행 집계 — H6 7요소: NOPATH:4 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (SCM0002_ItembyDivisionPopup) |
| WK-SCP0016-0438 | H6 | SCM0002_ProjectbyDivisionPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCM0002_ProjectbyDivisionPopup: 행 집계 — H6 7요소: NOPATH:4 · NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (SCM0002_ProjectbyDivisionPopup) |
| WK-SCP0016-0439 | H6 | SCP0016_WaterfallShipmentPlanFG.SpdMain_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.SpdMain_CellDouble: 진입점 집계 — H6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0016_WaterfallShipmentPlanFG.SpdM) |
| WK-SCP0016-0440 | M3 | D00-4e-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M3 기대값 확정 — D00-4e-003: 행 집계 — M3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-003) |
| WK-SCP0016-0441 | M3 | D00-4e-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M3 기대값 확정 — D00-4e-004: 행 집계 — M3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-004) |
| WK-SCP0016-0442 | M3 | MODAL:ShowDialog | 사람 판정 / AS-IS 원문 확인 → 재판정 | M3 기대값 확정 — MODAL:ShowDialog: 행 집계 — M3 2요소: NOT_RUN:2 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ShowDialog) |
| WK-SCP0016-0443 | M4 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — 10: 행 집계 — M4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (10) |
| WK-SCP0016-0444 | M4 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — COMMON:UC-06: 행 집계 — M4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0016-0445 | M4 | D00-2-010 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-2-010: 행 집계 — M4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-010) |
| WK-SCP0016-0446 | M4 | D00-4b-009 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-4b-009: 행 집계 — M4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-009) |
| WK-SCP0016-0447 | M4 | D00-4d-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-4d-001: 행 집계 — M4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-001) |
| WK-SCP0016-0448 | M4 | D00-4e-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-4e-003: 행 집계 — M4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-003) |
| WK-SCP0016-0449 | M4 | D00-4e-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — D00-4e-004: 행 집계 — M4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-004) |
| WK-SCP0016-0450 | M4 | MODAL:ShowDialog | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — MODAL:ShowDialog: 행 집계 — M4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ShowDialog) |
| WK-SCP0016-0451 | M4 | ProgressForm(로딩) | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — ProgressForm(로딩): 행 집계 — M4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (ProgressForm(로딩)) |
| WK-SCP0016-0452 | M4 | SCM0002_ItembyDivisionPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCM0002_ItembyDivisionPopup: 행 집계 — M4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (SCM0002_ItembyDivisionPopup) |
| WK-SCP0016-0453 | M4 | SCM0002_ProjectbyDivisionPopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCM0002_ProjectbyDivisionPopup: 행 집계 — M4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (SCM0002_ProjectbyDivisionPopup) |
| WK-SCP0016-0454 | M4 | SCP0016_WaterfallShipmentPlanFG.SpdMain_ | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.SpdMain_CellDouble: 진입점 집계 — M4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0016_WaterfallShipmentPlanFG.SpdM) |
