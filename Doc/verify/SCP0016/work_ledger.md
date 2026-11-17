# 작업 원장 — SCP0016 · 2026-11-14 11:09

> 검사 인스턴스 658건 중 PASS·NA 451건 외 **207건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 4 | 재판정 PASS |
| W5 | 검사기 연결 | 13 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 1 | 실행 → PASS |
| W7 | 기대값 확정 | 68 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 121 | 원인 해소 → 재판정 |

- 담당: 하네스·환경 121 · 사람 판정 / AS-IS 원문 확인 → 재판정 65 · 하네스 13 · 화면 FE 3 · 대조표 3 · 사람판정 1 · E2E 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 4건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| A1 | GEN |  |  |  |  |  |  | 28 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| A5 | DESIGN |  |  |  |  |  |  |  |  | 27 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| X-LOC | GEN |  |  |  |  |  |  | 26 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-ROW | GEN |  |  | 2 |  |  |  | 2 |  | 18 | 대조표 행이 서술한 동작을 화면에서 재현 |
| M4 | POPUP |  |  |  |  |  |  | 7 |  | 12 | 팝업 선택값 반영 |
| C3 | CASCADE |  |  |  |  |  |  |  |  | 19 | 연쇄 자동 채움 |
| G5 | POPUP |  |  |  |  | 4 |  |  |  | 13 | 팝업 조건 연동(인자) |
| B4 | COMBO |  |  |  |  |  |  |  |  | 9 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| D3 | EDIT |  |  |  |  |  |  |  |  | 6 | 행 값 기반 조건부 잠금 |
| H6 | POPUP |  |  |  |  | 3 | 1 |  |  | 1 | 팝업 표준·열림 |
| G4 | DESIGN |  |  |  |  | 4 |  |  |  |  | 조회조건 표시·라벨·활성 |
| A6 | GEN |  |  |  |  |  |  | 1 |  | 3 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| X-REASON | DESIGN |  |  |  |  |  |  | 3 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| C1 | CASCADE |  |  |  |  |  |  |  |  | 3 | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| F4 | DB |  |  |  |  |  |  |  |  | 3 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| H4 | DESIGN |  |  | 1 |  |  |  |  |  |  | 레이아웃·스크롤·크기 |
| G6 | GEN |  |  | 1 |  |  |  |  |  |  | 조회조건 초기 기본값 = AS-IS Form_Load |
| DB-SYN | DB |  |  |  |  | 1 |  |  |  |  | BE 계정 시노님·권한·대상 객체 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| G3 | COMMON |  |  |  |  |  |  | 1 |  |  | 조회조건 저장·복원 |
| J2 | AUTH |  |  |  |  |  |  |  |  | 1 | 권한별 버튼·기능 |
| C4 | CASCADE |  |  |  |  |  |  |  |  | 1 | 조회조건 변경 시 그리드 상태(초기화·유지) = AS-IS |
| B1 | COMBO |  |  |  |  |  |  |  |  | 1 | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  |  |  |  |  | 1 | 콤보 후보 중복 없음 |
| B6 | COMBO |  |  |  |  |  |  |  |  | 1 | ALL 옵션·다중선택 사양 |
| I1 | DESIGN |  |  |  |  |  |  |  |  | 1 | LBL/MSG 언어별 등록 |
| E4 | EDIT |  |  |  |  |  |  |  |  | 1 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |

## W3 동작 수정 (4)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0016-0001 | H4 | SCP0016 화면 | 사람판정(사람판정 대기) | H4 FAIL 수정 — SCP0016 화면: 원장 V-df2bc27f RULE_SCREEN / 원장 V-04d96ea0 RULE_SCREEN / 원장 V-44cb39ca RULE_SCREEN / 원장 V-34521981 RULE_SC |  | 8 (D00-2-011 D00-4b-010 11 TopChange sticky) |
| WK-SCP0016-0002 | G6 | clbVersion / Version / Ver. / Version. | 화면 FE(범위 밖(가이드만)) | G6 FAIL 수정 — clbVersion / Version / Ver. / Version.: 실측[T-d79b6bed]: [사용자판정] FAIL — 16번 Version 초기값 — 사용자 확인 오류 맞음(AS-IS 선택 없음 = 전 |  | 5 (D00-1-009 ACT:SCP0016_WaterfallShipmentP) |
| WK-SCP0016-0003 | X-ROW | SCP0016_WaterfallShipmentPlanFG.InitCont | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0016_WaterfallShipmentPlanFG.InitControls: 진입점 집계 18검사 — PASS:14 · NA:2 · FAIL:1 · ERROR:1 (FX-SCP0016-066) |  | 6 (ACT:SCP0016_WaterfallShipmentPlanFG.Init) |
| WK-SCP0016-0004 | X-ROW | SCP0016_WaterfallShipmentPlanFG.SpdMain_ | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0016_WaterfallShipmentPlanFG.SpdMain_TopChange: 진입점 집계 1검사 — FAIL:1 (FX-SCP0016-067) |  | 2 (ACT:SCP0016_WaterfallShipmentPlanFG.SpdM) |

## W5 검사기 연결 (13)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0016-0005 | DB-SYN | SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_T | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_TITLE_PARAL | 없음(PROC_M 대응 없음) | 6 (D00-4a-002 ACT:SCP0016_WaterfallShipment) |
| WK-SCP0016-0006 | G4 | btnColumn | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnColumn | 있음(FE 소스) | 2 (ACT:SCP0016_WaterfallShipmentPlanFG.Init) |
| WK-SCP0016-0007 | G4 | btnItem | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItem | 없음 | 2 (ACT:SCP0016_WaterfallShipmentPlanFG.Init) |
| WK-SCP0016-0008 | G4 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnMeasure | 있음(FE 소스) | 2 (ACT:SCP0016_WaterfallShipmentPlanFG.Init) |
| WK-SCP0016-0009 | G4 | btnProject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnProject | 있음(FE 소스) | 2 (ACT:SCP0016_WaterfallShipmentPlanFG.Init) |
| WK-SCP0016-0010 | G03-WIRE | SCP0016 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0016 화면 | 판단불가(대상 단위 SCREEN) | 15 (ACT:SCP0016_WaterfallShipmentPlanFG..cto) |
| WK-SCP0016-0011 | G5 | btnColumn | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 BTN btnColumn | 있음(FE 소스) | 2 (D00-4e-001 SCM0002_TitleSetForm 'C'(btnC) |
| WK-SCP0016-0012 | G5 | btnItem | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 BTN btnItem | 없음 | 1 (D00-1-007) |
| WK-SCP0016-0013 | G5 | btnProject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 BTN btnProject | 있음(FE 소스) | 1 (D00-1-004) |
| WK-SCP0016-0014 | G5 | cboBucketType / Bucket / Bucket Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COND cboBucketType / Bucket / Bucket Type | 있음(FE 소스) | 3 (ACT:SCP0016_WaterfallShipmentPlanFG.SpdM) |
| WK-SCP0016-0015 | H6 | btnColumn | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnColumn | 있음(FE 소스) | 2 (D00-4e-001 SCM0002_TitleSetForm 'C'(btnC) |
| WK-SCP0016-0016 | H6 | btnItem | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnItem | 없음 | 1 (D00-1-007) |
| WK-SCP0016-0017 | H6 | btnProject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnProject | 있음(FE 소스) | 1 (D00-1-004) |

## W6 검증 실행 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0016-0018 | H6 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 3 (ACT:SCP0016_WaterfallShipmentPlanFG.SpdM) |

## W7 기대값 확정 (68)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0016-0019 | G3 | SCP0016 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G3 기대값 확정 — SCP0016 화면: 원장 V-2f0e8ec3 RULE_SCREEN / 원장 V-a5f53cb1 GENERAL / 원장 V-aa8aa61b GENERAL / 원장 V-32c9ca27 GENERAL / 원장 V-5 |  | 4 (D00-1-012 COMMON:UC-03 COMMON:UC-06 COMM) |
| WK-SCP0016-0020 | X-REASON | COMMON:UC-05 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-05 Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7)  그리드 셀 콤보 0건(전 FPT |  | 1 (COMMON:UC-05) |
| WK-SCP0016-0021 | X-REASON | CRUD:D00-4b-003:SAVE | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — CRUD:D00-4b-003:SAVE [SAVE] §4b SaveButton / toolbarOverride / Save  조회전용 화면 — AS-IS NO-OP/미노출, DB 버튼 메타 미등록 해당 |  | 1 (CRUD:D00-4b-003:SAVE) |
| WK-SCP0016-0022 | X-REASON | D00-4b-003 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — D00-4b-003 §4b SaveButton / toolbarOverride / Save  조회전용 화면 — AS-IS NO-OP/미노출, DB 버튼 메타 미등록 해당없음 |  | 1 (D00-4b-003) |
| WK-SCP0016-0023 | A1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1: 행 집계 — 대조표 1 'MSG00109 EditButton 읽기전용 가드(644)' 의 A1 4요소: PASS:2 · REVIEW:2 · FAIL 요소: SCP0016_GET_SHIPMENT_PLAN_FG |  | 0 () |
| WK-SCP0016-0024 | A1 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 2: 행 집계 — 대조표 2 'GMessageBoxForException SetOperationGroupByDivisio' 의 A1 4요소: PASS:2 · REVIEW:2 · FAIL 요소: SCP0016_GE |  | 1 (2) |
| WK-SCP0016-0025 | A1 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 3: 행 집계 — 대조표 3 'BtnProject_Click(1304)' 의 A1 4요소: PASS:2 · REVIEW:2 · FAIL 요소: SCP0016_GET_SHIPMENT_PLAN_FG_W — golde |  | 1 (3) |
| WK-SCP0016-0026 | A1 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 4: 행 집계 — 대조표 4 'BtnItem_Id_Click(1283)' 의 A1 4요소: PASS:2 · REVIEW:2 · FAIL 요소: SCP0016_GET_SHIPMENT_PLAN_FG_W — golde |  | 1 (4) |
| WK-SCP0016-0027 | A1 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 9: 행 집계 — 대조표 9 'dCalendar_ValueChanged(1351)' 의 A1 4요소: PASS:2 · REVIEW:2 · FAIL 요소: SCP0016_GET_SHIPMENT_PLAN_FG_W — |  | 1 (9) |
| WK-SCP0016-0028 | A1 | BucketISO(221) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — BucketISO(221): 행 집계 — 대조표 BucketISO(221) '`BucketISO_SCP`' 의 A1 4요소: PASS:2 · REVIEW:2 · FAIL 요소: SCP0016_GET_SHIPMEN |  | 1 (BucketISO(221)) |
| WK-SCP0016-0029 | A1 | COMMON:UC-03 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-03: 행 집계 — 대조표 COMMON:UC-03 '컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후' 의 A1 4요소: PASS:2 · REVIEW:2 |  | 1 (COMMON:UC-03) |
| WK-SCP0016-0030 | A1 | COMMON:UC-06 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-06: 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)' 의 A1 4요소: PASS:2 · REVIEW:2 · FAIL  |  | 1 (COMMON:UC-06) |
| WK-SCP0016-0031 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 A1 4요소: PASS:2 · REVIEW:2 |  | 1 (COMMON:UC-07) |
| WK-SCP0016-0032 | A1 | CRUD:D00-4b-001:SEARCH | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — CRUD:D00-4b-001:SEARCH: 행 집계 — 대조표 CRUD:D00-4b-001:SEARCH '[SEARCH] §4b FindButton / toolbarOverride / Search' 의 A1 4요 |  | 1 (CRUD:D00-4b-001:SEARCH) |
| WK-SCP0016-0033 | A1 | D00-1-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-004: 행 집계 — 대조표 D00-1-004 '§1 btnProject / UsrButton' 의 A1 4요소: PASS:2 · REVIEW:2 · FAIL 요소: SCP0016_GET_SHIPMEN |  | 1 (D00-1-004) |
| WK-SCP0016-0034 | A1 | D00-1-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-1-007: 행 집계 — 대조표 D00-1-007 '§1 btnItem_Id / UsrButton' 의 A1 4요소: PASS:2 · REVIEW:2 · FAIL 요소: SCP0016_GET_SHIPMEN |  | 1 (D00-1-007) |
| WK-SCP0016-0035 | A1 | D00-2-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-003: 행 집계 — 대조표 D00-2-003 '§2 btnProject / Click' 의 A1 4요소: PASS:2 · REVIEW:2 · FAIL 요소: SCP0016_GET_SHIPMENT_PL |  | 1 (D00-2-003) |
| WK-SCP0016-0036 | A1 | D00-2-004 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-2-004: 행 집계 — 대조표 D00-2-004 '§2 btnItem_Id / Click' 의 A1 4요소: PASS:2 · REVIEW:2 · FAIL 요소: SCP0016_GET_SHIPMENT_PL |  | 1 (D00-2-004) |
| WK-SCP0016-0037 | A1 | D00-4a-003 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4a-003: 행 집계 — 대조표 D00-4a-003 '§4a (localConst, 빈 sp명) / GetSpdTitle(1120)' 의 A1 4요소: PASS:2 · REVIEW:2 · FAIL 요소: |  | 1 (D00-4a-003) |
| WK-SCP0016-0038 | A1 | D00-4b-001 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4b-001: 행 집계 — 대조표 D00-4b-001 '§4b FindButton / toolbarOverride / Search' 의 A1 4요소: PASS:2 · REVIEW:2 · FAIL 요소: S |  | 1 (D00-4b-001) |
| WK-SCP0016-0039 | A1 | D00-4b-005 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4b-005: 행 집계 — 대조표 D00-4b-005 '§4b BtnItem_Id_Click / event / btnItem_Id' 의 A1 4요소: PASS:2 · REVIEW:2 · FAIL 요소: S |  | 1 (D00-4b-005) |
| WK-SCP0016-0040 | A1 | D00-4b-006 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4b-006: 행 집계 — 대조표 D00-4b-006 '§4b BtnProject_Click / event / btnProject' 의 A1 4요소: PASS:2 · REVIEW:2 · FAIL 요소: S |  | 1 (D00-4b-006) |
| WK-SCP0016-0041 | A1 | D00-4b-007 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — D00-4b-007: 행 집계 — 대조표 D00-4b-007 '§4b CboDivision_SelectedIndexChanged / event / cbo' 의 A1 4요소: PASS:2 · REVIEW:2 · F |  | 1 (D00-4b-007) |
| WK-SCP0016-0042 | A1 | FindButton(636) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindButton(636): 행 집계 — 대조표 FindButton(636) 'FindData_Main() 실동작' 의 A1 4요소: PASS:2 · REVIEW:2 · FAIL 요소: SCP0016_GET_S |  | 1 (FindButton(636)) |
| WK-SCP0016-0043 | A1 | LookupCommon ELECTRODE_TYPE(206) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — LookupCommon ELECTRODE_TYPE(206): 행 집계 — 대조표 LookupCommon ELECTRODE_TYPE(206) 'lookup `ELECTRODE_TYPE`(다중)' 의 A1 4요소:  |  | 1 (LookupCommon ELECTRODE_TYPE(206)) |
| WK-SCP0016-0044 | A1 | LookupCommon OPERATION_GROUP(203) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — LookupCommon OPERATION_GROUP(203): 행 집계 — 대조표 LookupCommon OPERATION_GROUP(203) 'lookup(초기 P/A/E)' 의 A1 4요소: PASS:2 ·  |  | 1 (LookupCommon OPERATION_GROUP(203)) |
| WK-SCP0016-0045 | A1 | MyDivisionInEE(49) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — MyDivisionInEE(49): 행 집계 — 대조표 MyDivisionInEE(49) '`MyDivisionInEE_SCP`(@mnuId)' 의 A1 4요소: PASS:2 · REVIEW:2 · FAIL 요소 |  | 1 (MyDivisionInEE(49)) |
| WK-SCP0016-0046 | A1 | OperationGroup(928) / OperationGroupEE(9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — OperationGroup(928) / OperationGroupEE(932): 행 집계 — 대조표 OperationGroup(928) / OperationGroupEE(932) '`OperationGroup_S |  | 1 (OperationGroup(928) / OperationGroupEE(9) |
| WK-SCP0016-0047 | A1 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0016/SCP0009_GET_ |  | 106 (ACT:SCP0016_WaterfallShipmentPlanFG.Find) |
| WK-SCP0016-0048 | A1 | SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_T | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_TITLE_PARAL: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0016/SCP0016_GET_ |  | 109 (D00-4a-002 ACT:SCP0016_WaterfallShipment) |
| WK-SCP0016-0049 | A1 | SaveButton(648) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SaveButton(648): 행 집계 — 대조표 SaveButton(648) 'NO-OP 빈 `{}`' 의 A1 4요소: PASS:2 · REVIEW:2 · FAIL 요소: SCP0016_GET_SHIPMENT |  | 1 (SaveButton(648)) |
| WK-SCP0016-0050 | A1 | WaterfallVer_FG2(234) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — WaterfallVer_FG2(234): 행 집계 — 대조표 WaterfallVer_FG2(234) '`WaterfallVer_FG2_SCP`(@divisionId)' 의 A1 4요소: PASS:2 · REVIE |  | 1 (WaterfallVer_FG2(234)) |
| WK-SCP0016-0051 | A6 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | 사람 판정 / AS-IS 원문 확인 → 재판정 | A6 기대값 확정 — PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO: 검증 엔진이 실행됐으나 이 대상(SP PKG_COM0000.P_SCP0009_GET_SHEE)을 판정하지 못함 — 결과 |  | 106 (ACT:SCP0016_WaterfallShipmentPlanFG.Find) |
| WK-SCP0016-0052 | X-LOC | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 10: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (10) |
| WK-SCP0016-0053 | X-LOC | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 11: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (11) |
| WK-SCP0016-0054 | X-LOC | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (3) |
| WK-SCP0016-0055 | X-LOC | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (4) |
| WK-SCP0016-0056 | X-LOC | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (5) |
| WK-SCP0016-0057 | X-LOC | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 6: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (6) |
| WK-SCP0016-0058 | X-LOC | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 7: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (7) |
| WK-SCP0016-0059 | X-LOC | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 8: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (8) |
| WK-SCP0016-0060 | X-LOC | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 9: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (9) |
| WK-SCP0016-0061 | X-LOC | BucketISO(221) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — BucketISO(221): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (BucketISO(221)) |
| WK-SCP0016-0062 | X-LOC | BucketType×chkSum visible 8분기(#33~40, R1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — BucketType×chkSum visible 8분기(#33~40, R12): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (BucketType×chkSum visible 8분기(#33~40, R1) |
| WK-SCP0016-0063 | X-LOC | LookupCommon ELECTRODE_TYPE(206) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — LookupCommon ELECTRODE_TYPE(206): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (LookupCommon ELECTRODE_TYPE(206)) |
| WK-SCP0016-0064 | X-LOC | LookupCommon OPERATION_GROUP(203) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — LookupCommon OPERATION_GROUP(203): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (LookupCommon OPERATION_GROUP(203)) |
| WK-SCP0016-0065 | X-LOC | MyDivisionInEE(49) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — MyDivisionInEE(49): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (MyDivisionInEE(49)) |
| WK-SCP0016-0066 | X-LOC | OperationGroup(928) / OperationGroupEE(9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — OperationGroup(928) / OperationGroupEE(932): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (OperationGroup(928) / OperationGroupEE(9) |
| WK-SCP0016-0067 | X-LOC | SmartColMerge 세로병합(#1/#19/#22, R2) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SmartColMerge 세로병합(#1/#19/#22, R2): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SmartColMerge 세로병합(#1/#19/#22, R2)) |
| WK-SCP0016-0068 | X-LOC | TopChange sticky(#19) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — TopChange sticky(#19): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (TopChange sticky(#19)) |
| WK-SCP0016-0069 | X-LOC | WaterfallVer_FG2(234) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — WaterfallVer_FG2(234): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (WaterfallVer_FG2(234)) |
| WK-SCP0016-0070 | X-LOC | 그리드 바인딩(#20, R3) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 그리드 바인딩(#20, R3): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (그리드 바인딩(#20, R3)) |
| WK-SCP0016-0071 | X-LOC | 다단 헤더 span 3단(#3~18, R5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 다단 헤더 span 3단(#3~18, R5): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (다단 헤더 span 3단(#3~18, R5)) |
| WK-SCP0016-0072 | X-LOC | 더블클릭 펼침/접기(#31, R10) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 더블클릭 펼침/접기(#31, R10): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (더블클릭 펼침/접기(#31, R10)) |
| WK-SCP0016-0073 | X-LOC | 숫자 셀타입(#2/#6/#7, R4) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 숫자 셀타입(#2/#6/#7, R4): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (숫자 셀타입(#2/#6/#7, R4)) |
| WK-SCP0016-0074 | X-LOC | 요일 헤더색(#8, R9) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 요일 헤더색(#8, R9): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (요일 헤더색(#8, R9)) |
| WK-SCP0016-0075 | X-LOC | 월/주합 파생 SetValue(#23~30, R6~R8) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 월/주합 파생 SetValue(#23~30, R6~R8): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (월/주합 파생 SetValue(#23~30, R6~R8)) |
| WK-SCP0016-0076 | X-LOC | 전 컬럼 Lock(#21, R1) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 전 컬럼 Lock(#21, R1): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (전 컬럼 Lock(#21, R1)) |
| WK-SCP0016-0077 | X-LOC | 헤더높이(#32, R11) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 헤더높이(#32, R11): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (헤더높이(#32, R11)) |
| WK-SCP0016-0078 | X-ROW | SCP0016_WaterfallShipmentPlanFG.RetValue | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.RetValue: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/EXPR/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 5 (ACT:SCP0016_WaterfallShipmentPlanFG.RetV) |
| WK-SCP0016-0079 | X-ROW | SCP0016_WaterfallShipmentPlanFG.SetVisib | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0016_WaterfallShipmentPlanFG.SetVisibleMontColu: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/GRID_INIT, 연결된 요소 검사 없음 |  | 2 (ACT:SCP0016_WaterfallShipmentPlanFG.SetV) |
| WK-SCP0016-0080 | M4 | btnColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — btnColumn: 검증 엔진이 실행됐으나 이 대상(BTN btnColumn)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 2 (D00-4e-001 SCM0002_TitleSetForm 'C'(btnC) |
| WK-SCP0016-0081 | M4 | btnItem | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — btnItem: 검증 엔진이 실행됐으나 이 대상(BTN btnItem)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 1 (D00-1-007) |
| WK-SCP0016-0082 | M4 | btnMeasure | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — btnMeasure: 검증 엔진이 실행됐으나 이 대상(BTN btnMeasure)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 2 (D00-4e-002 SCM0002_TitleSetForm 'M'(btnM) |
| WK-SCP0016-0083 | M4 | btnProject | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — btnProject: 검증 엔진이 실행됐으나 이 대상(BTN btnProject)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 1 (D00-1-004) |
| WK-SCP0016-0084 | M4 | cboBucketType / Bucket / Bucket Type | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — cboBucketType / Bucket / Bucket Type: 검증 엔진이 실행됐으나 이 대상(COND cboBucketType)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 3 (ACT:SCP0016_WaterfallShipmentPlanFG.SpdM) |
| WK-SCP0016-0085 | M4 | txtItem_Id / Model / Item_Id / Model/Nic | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — txtItem_Id / Model / Item_Id / Model/Nickname / Ni: 검증 엔진이 실행됐으나 이 대상(COND txtItem_Id)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 |  | 2 (D00-1-005 4) |
| WK-SCP0016-0086 | M4 | txtProject / Project / PJT | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — txtProject / Project / PJT: 검증 엔진이 실행됐으나 이 대상(COND txtProject)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 2 (D00-1-003 3) |

## W9 도구 오류 (121)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0016-0087 | J2 | SCP0016 화면 | 하네스·환경 | J2 도구 오류 — 원장 V-2e2a7392 RULE_SCREEN / 원장 V-b83e76e2 DEFECT / 원장 V-2a980db0 GENERAL / 원장 V-f3c46fad GENERAL / 원장 V-d934ccf8 GENERA |  | 67 (D00-1-004 D00-1-007 D00-2-003 D00-2-004 ) |
| WK-SCP0016-0088 | C1 | cboBucketType / Bucket / Bucket Type | 하네스·환경 | C1 도구 오류 — 실측[T-c527a1d9]: 'Bucket' → 'Weekly' 변경 · 콤보 재요청 0건 · 하위 (없음) · AS-IS 핸들러 cboBucketType_SelectedIndexChanged · AS-IS 하위  |  | 4 (D00-2-007 D00-4b-012 9 ACT:SCP0016_Water) |
| WK-SCP0016-0089 | C1 | chkSum / Sum | 하네스·환경 | C1 도구 오류 — 실측[T-b2c1e1ba]: 상위 조건 'Sum' 이 콤보가 아님(checkbox) — 이 유형 변경 프로브 미구현 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (D00-2-008 D00-4b-013 8) |
| WK-SCP0016-0090 | C1 | clbVersion / Version / Ver. / Version. | 하네스·환경 | C1 도구 오류 — 실측[T-384b47a7]: 'Ver.' → 'SP_W_20260824 (W35)' 변경 · 콤보 재요청 0건 · 하위 (없음) · AS-IS 핸들러 ClbVersion_SelectedIndexChanged · A |  | 3 (D00-2-002 D00-4b-008 ACT:SCP0016_Waterfa) |
| WK-SCP0016-0091 | C3 | D00-3-023 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-3-023 '§3 SetValue / (iRow, bef_month_idx, sum_month) 월합 ' 의 C3 4요소: ERROR:2 · NA:2 |  | 1 (D00-3-023) |
| WK-SCP0016-0092 | C3 | D00-3-024 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-3-024 '§3 SetValue / (iRow, bef_month_idx, val)' 의 C3 4요소: ERROR:2 · NA:2 |  | 1 (D00-3-024) |
| WK-SCP0016-0093 | C3 | D00-3-025 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-3-025 '§3 SetValue / (iRow, bef_week_idx, sum_week) 주합 파생' 의 C3 4요소: ERROR:2 · NA:2 |  | 1 (D00-3-025) |
| WK-SCP0016-0094 | C3 | D00-3-026 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-3-026 '§3 SetValue / (iRow, bef_week_idx, val)' 의 C3 4요소: ERROR:2 · NA:2 |  | 1 (D00-3-026) |
| WK-SCP0016-0095 | C3 | D00-3-027 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-3-027 '§3 SetValue / (iRow, bef_week_idx, sum_week)' 의 C3 4요소: ERROR:2 · NA:2 |  | 1 (D00-3-027) |
| WK-SCP0016-0096 | C3 | D00-3-028 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-3-028 '§3 SetValue / (iRow, bef_month_idx, sum_month)' 의 C3 4요소: ERROR:2 · NA:2 |  | 1 (D00-3-028) |
| WK-SCP0016-0097 | C3 | D00-3-029 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-3-029 '§3 SetValue / (iRow, bef_week_idx, val)' 의 C3 4요소: ERROR:2 · NA:2 |  | 1 (D00-3-029) |
| WK-SCP0016-0098 | C3 | D00-3-030 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 D00-3-030 '§3 SetValue / (iRow, bef_month_idx, val)' 의 C3 4요소: ERROR:2 · NA:2 |  | 1 (D00-3-030) |
| WK-SCP0016-0099 | C3 | DIVISION_ID / Division | 하네스·환경 | C3 도구 오류 — 실측[T-c87b1c05]: DIVISION_ID 연쇄 원천 컬럼 해석 불가 — AS-IS  → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SCP0016_WaterfallShipmentPlanFG.SetC) |
| WK-SCP0016-0100 | C3 | SCP0016_WaterfallShipmentPlanFG.CboDivis | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0016_WaterfallShipmentPlanFG.CboDivision_SelectedIndexChanged 의 C3 4요소: ERROR:2 · NA:2 |  | 2 (ACT:SCP0016_WaterfallShipmentPlanFG.CboD) |
| WK-SCP0016-0101 | C3 | SCP0016_WaterfallShipmentPlanFG.ClbVersi | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0016_WaterfallShipmentPlanFG.ClbVersion_SelectedIndexChanged 의 C3 4요소: ERROR:2 · NA:2 |  | 1 (ACT:SCP0016_WaterfallShipmentPlanFG.ClbV) |
| WK-SCP0016-0102 | C3 | SCP0016_WaterfallShipmentPlanFG.SetChang | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0016_WaterfallShipmentPlanFG.SetChangedControl 의 C3 1요소: ERROR:1 |  | 1 (ACT:SCP0016_WaterfallShipmentPlanFG.SetC) |
| WK-SCP0016-0103 | C3 | SCP0016_WaterfallShipmentPlanFG.SetDataT | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0016_WaterfallShipmentPlanFG.SetDataTableQtyData 의 C3 4요소: ERROR:2 · NA:2 |  | 5 (ACT:SCP0016_WaterfallShipmentPlanFG.SetD) |
| WK-SCP0016-0104 | C3 | SCP0016_WaterfallShipmentPlanFG.SetOpera | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0016_WaterfallShipmentPlanFG.SetOperationGroupByDivision 의 C3 4요소: ERROR:2 · NA:2 |  | 3 (ACT:SCP0016_WaterfallShipmentPlanFG.SetO) |
| WK-SCP0016-0105 | C3 | SCP0016_WaterfallShipmentPlanFG.Set_SumV | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0016_WaterfallShipmentPlanFG.Set_SumValues 의 C3 2요소: ERROR:1 · NA:1 |  | 19 (ACT:SCP0016_WaterfallShipmentPlanFG.Set_) |
| WK-SCP0016-0106 | C3 | SCP0016_WaterfallShipmentPlanFG.cboBucke | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0016_WaterfallShipmentPlanFG.cboBucketType_SelectedIndexChanged 의 C3 4요소: ERROR:2 · NA:2 |  | 5 (ACT:SCP0016_WaterfallShipmentPlanFG.cboB) |
| WK-SCP0016-0107 | C3 | SCP0016_WaterfallShipmentPlanFG.chkSum_C | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0016_WaterfallShipmentPlanFG.chkSum_CheckedChanged 의 C3 4요소: ERROR:2 · NA:2 |  | 2 (ACT:SCP0016_WaterfallShipmentPlanFG.chkS) |
| WK-SCP0016-0108 | C3 | SCP0016_WaterfallShipmentPlanFG.dCalenda | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0016_WaterfallShipmentPlanFG.dCalendar_ValueChanged 의 C3 4요소: ERROR:2 · NA:2 |  | 1 (ACT:SCP0016_WaterfallShipmentPlanFG.dCal) |
| WK-SCP0016-0109 | C3 | measure | 하네스·환경 | C3 도구 오류 — 실측[T-1a61e8b0]: measure 연쇄 원천 컬럼 해석 불가 — AS-IS  → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 12 (ACT:SCP0016_WaterfallShipmentPlanFG.Set_) |
| WK-SCP0016-0110 | C4 | clbVersion / Version / Ver. / Version. | 하네스·환경 | C4 도구 오류 — 실측[T-c0ffa291]: 상위 'Ver.' 에서 바꿀 옵션 없음(옵션 1개 또는 ALL 만) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (D00-2-002 D00-4b-008) |
| WK-SCP0016-0111 | B1 | clbElecType / Electrode / Elec Type | 하네스·환경 | B1 도구 오류 — 원장 V-ebca0f18 SEARCH |  | 1 (D00-1-006) |
| WK-SCP0016-0112 | B2 | clbElecType / Electrode / Elec Type | 하네스·환경 | B2 도구 오류 — 원장 V-f1a3d69c SEARCH |  | 1 (D00-1-006) |
| WK-SCP0016-0113 | B4 | BucketISO(221) | 하네스·환경 | B4 도구 오류 — 행 집계 — 대조표 BucketISO(221) '`BucketISO_SCP`' 의 B4 6요소: ERROR:3 · PASS:2 · NA:1 |  | 1 (BucketISO(221)) |
| WK-SCP0016-0114 | B4 | LookupCommon OPERATION_GROUP(203) | 하네스·환경 | B4 도구 오류 — 행 집계 — 대조표 LookupCommon OPERATION_GROUP(203) 'lookup(초기 P/A/E)' 의 B4 6요소: ERROR:3 · PASS:2 · NA:1 |  | 1 (LookupCommon OPERATION_GROUP(203)) |
| WK-SCP0016-0115 | B4 | OperationGroup(928) / OperationGroupEE(9 | 하네스·환경 | B4 도구 오류 — 행 집계 — 대조표 OperationGroup(928) / OperationGroupEE(932) '`OperationGroup_SCP`{P,A} / `OperationGroupEE_SCP`' 의 B4 6요소: E |  | 1 (OperationGroup(928) / OperationGroupEE(9) |
| WK-SCP0016-0116 | B4 | SCP0016_WaterfallShipmentPlanFG.GetBucke | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SCP0016_WaterfallShipmentPlanFG.GetBucketType 의 B4 6요소: ERROR:3 · PASS:2 · NA:1 |  | 3 (ACT:SCP0016_WaterfallShipmentPlanFG.GetB) |
| WK-SCP0016-0117 | B4 | SCP0016_WaterfallShipmentPlanFG.GetDayRa | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 SCP0016_WaterfallShipmentPlanFG.GetDayRange 의 B4 3요소: PASS:2 · ERROR:1 |  | 4 (ACT:SCP0016_WaterfallShipmentPlanFG.GetD) |
| WK-SCP0016-0118 | B4 | WaterfallVer_FG2(234) | 하네스·환경 | B4 도구 오류 — 행 집계 — 대조표 WaterfallVer_FG2(234) '`WaterfallVer_FG2_SCP`(@divisionId)' 의 B4 6요소: ERROR:3 · PASS:2 · NA:1 |  | 1 (WaterfallVer_FG2(234)) |
| WK-SCP0016-0119 | B4 | cboBizType / Operation Group / Biz Type  | 하네스·환경 | B4 도구 오류 — 원장 V-72ef7746 SEARCH |  | 1 (D00-1-002) |
| WK-SCP0016-0120 | B4 | clbElecType / Electrode / Elec Type | 하네스·환경 | B4 도구 오류 — 원장 V-67cf86e1 SEARCH |  | 1 (D00-1-006) |
| WK-SCP0016-0121 | B4 | clbVersion / Version / Ver. / Version. | 하네스·환경 | B4 도구 오류 — 원장 V-e19a4461 SEARCH |  | 3 (D00-1-009 ACT:SCP0016_WaterfallShipmentP) |
| WK-SCP0016-0122 | B6 | clbElecType / Electrode / Elec Type | 하네스·환경 | B6 도구 오류 — 원장 V-29192f21 SEARCH |  | 1 (D00-1-006) |
| WK-SCP0016-0123 | F4 | D00-4a-003 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 D00-4a-003 '§4a (localConst, 빈 sp명) / GetSpdTitle(1120)' 의 F4 4요소: PASS:3 · ERROR:1 |  | 1 (D00-4a-003) |
| WK-SCP0016-0124 | F4 | FindButton(636) | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 FindButton(636) 'FindData_Main() 실동작' 의 F4 4요소: PASS:3 · ERROR:1 |  | 1 (FindButton(636)) |
| WK-SCP0016-0125 | F4 | PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR | 하네스·환경 | F4 도구 오류 — 실측[T-15899452]: PKG_COM0000.P_SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO: SCP0016/spreadTitleIso/SEARCH, SCP0018/spreadTitleI |  | 108 (ACT:SCP0016_WaterfallShipmentPlanFG.Find) |
| WK-SCP0016-0126 | A5 | 7 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 7 'cboBucketType_SelectedIndexChanged(1193)' 의 A5 2요소: PASS:1 · ERROR:1 |  | 1 (7) |
| WK-SCP0016-0127 | A5 | 9 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 9 'dCalendar_ValueChanged(1351)' 의 A5 2요소: PASS:1 · ERROR:1 |  | 1 (9) |
| WK-SCP0016-0128 | A5 | BucketType×chkSum visible 8분기(#33~40, R1 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 BucketType×chkSum visible 8분기(#33~40, R12) '`baseVisibleOf`' 의 A5 2요소: PASS:1 · ERROR:1 |  | 1 (BucketType×chkSum visible 8분기(#33~40, R1) |
| WK-SCP0016-0129 | A5 | COMMON:UC-07 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilte' 의 A5 2요소: PASS:1 · ERROR:1 |  | 1 (COMMON:UC-07) |
| WK-SCP0016-0130 | A5 | D00-1-011 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-1-011 '§1 chkSum / UsrCheckBox' 의 A5 2요소: PASS:1 · ERROR:1 |  | 1 (D00-1-011) |
| WK-SCP0016-0131 | A5 | D00-1-013 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-1-013 '§1 spdMain / FpSpread' 의 A5 2요소: PASS:1 · ERROR:1 |  | 1 (D00-1-013) |
| WK-SCP0016-0132 | A5 | D00-1-016 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-1-016 '§1 spdMain_Sheet1 / SheetView' 의 A5 2요소: PASS:1 · ERROR:1 |  | 1 (D00-1-016) |
| WK-SCP0016-0133 | A5 | D00-3-020 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-3-020 '§3 Query / (dsBinding) 그리드 바인딩' 의 A5 2요소: PASS:1 · ERROR:1 |  | 1 (D00-3-020) |
| WK-SCP0016-0134 | A5 | D00-3-021 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-3-021 '§3 LockColumn / (0, GetMaxColumnIndex, true) 전 컬럼 ' 의 A5 2요소: PASS:1 · ERROR:1 |  | 1 (D00-3-021) |
| WK-SCP0016-0135 | A5 | D00-3-033 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-3-033 '§3 Visible= / Daily: isDaily/isWeekly → true' 의 A5 2요소: PASS:1 · ERROR:1 |  | 1 (D00-3-033) |
| WK-SCP0016-0136 | A5 | D00-3-034 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-3-034 '§3 Visible= / Daily: isMonthly/isWeekly → chkSum.C' 의 A5 2요소: PASS:1 · ERROR:1 |  | 1 (D00-3-034) |
| WK-SCP0016-0137 | A5 | D00-3-035 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-3-035 '§3 Visible= / Weekly: isDaily → false' 의 A5 2요소: PASS:1 · ERROR:1 |  | 1 (D00-3-035) |
| WK-SCP0016-0138 | A5 | D00-3-036 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-3-036 '§3 Visible= / Weekly: isWeekly → true' 의 A5 2요소: PASS:1 · ERROR:1 |  | 1 (D00-3-036) |
| WK-SCP0016-0139 | A5 | D00-3-037 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-3-037 '§3 Visible= / Weekly: isMonthly → chkSum.Checked' 의 A5 2요소: PASS:1 · ERROR:1 |  | 1 (D00-3-037) |
| WK-SCP0016-0140 | A5 | D00-3-038 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-3-038 '§3 Visible= / WeeklyISO: isWeeklyISO' 의 A5 2요소: PASS:1 · ERROR:1 |  | 1 (D00-3-038) |
| WK-SCP0016-0141 | A5 | D00-3-039 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-3-039 '§3 Visible= / Monthly: isDaily/isWeekly → false' 의 A5 2요소: PASS:1 · ERROR:1 |  | 1 (D00-3-039) |
| WK-SCP0016-0142 | A5 | D00-3-040 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 D00-3-040 '§3 Visible= / Monthly: else → true' 의 A5 2요소: PASS:1 · ERROR:1 |  | 1 (D00-3-040) |
| WK-SCP0016-0143 | A5 | TO_YYYYMMDD | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-14fa8c37]: TO_YYYYMMDD 표시=N — AS-IS Division 별 표시 정보 없음(grid_effective) → 기계 판정 불가 — 수동 검수 대상( |  | 2 (ACT:SCP0016_WaterfallShipmentPlanFG.SetS) |
| WK-SCP0016-0144 | A5 | TopChange sticky(#19) | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 TopChange sticky(#19) 'scrollPositionChanged → invalidate' 의 A5 2요소: PASS:1 · ERROR:1 |  | 1 (TopChange sticky(#19)) |
| WK-SCP0016-0145 | A5 | 그리드 바인딩(#20, R3) | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 그리드 바인딩(#20, R3) 'useTabProcQuery → DataGrid itemsSource(derivePerio' 의 A5 2요소: PASS:1 · ERROR:1 |  | 1 (그리드 바인딩(#20, R3)) |
| WK-SCP0016-0146 | A5 | 다단 헤더 span 3단(#3~18, R5) | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 다단 헤더 span 3단(#3~18, R5) '`buildDynamicColumns`(월/주/SUM) + WaterfallMergeMan' 의 A5 2요소: PASS:1 · ERROR:1 |  | 1 (다단 헤더 span 3단(#3~18, R5)) |
| WK-SCP0016-0147 | A5 | 더블클릭 펼침/접기(#31, R10) | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 더블클릭 펼침/접기(#31, R10) 'Grid onDblClick 드릴 + WeeklyISO 가드' 의 A5 2요소: PASS:1 · ERROR:1 |  | 1 (더블클릭 펼침/접기(#31, R10)) |
| WK-SCP0016-0148 | A5 | 숫자 셀타입(#2/#6/#7, R4) | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 숫자 셀타입(#2/#6/#7, R4) 'dynamicColumns format `#,##0`(정수)' 의 A5 2요소: PASS:1 · ERROR:1 |  | 1 (숫자 셀타입(#2/#6/#7, R4)) |
| WK-SCP0016-0149 | A5 | 요일 헤더색(#8, R9) | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 요일 헤더색(#8, R9) 'formatItem SAT=Blue/SUN=Red(HEADER_COLORS)' 의 A5 2요소: PASS:1 · ERROR:1 |  | 1 (요일 헤더색(#8, R9)) |
| WK-SCP0016-0150 | A5 | 월/주합 파생 SetValue(#23~30, R6~R8) | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 월/주합 파생 SetValue(#23~30, R6~R8) '`derivePeriodSums`(utils/waterfall.derive) — D_ 만 ' 의 A5 2요소: PASS:1 · ERRO |  | 1 (월/주합 파생 SetValue(#23~30, R6~R8)) |
| WK-SCP0016-0151 | A5 | 전 컬럼 Lock(#21, R1) | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 전 컬럼 Lock(#21, R1) 'DataGrid `isReadOnly={true}`' 의 A5 2요소: PASS:1 · ERROR:1 |  | 1 (전 컬럼 Lock(#21, R1)) |
| WK-SCP0016-0152 | A5 | 헤더높이(#32, R11) | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 헤더높이(#32, R11) 'headerRowHeight 48/tier' 의 A5 2요소: PASS:1 · ERROR:1 |  | 1 (헤더높이(#32, R11)) |
| WK-SCP0016-0153 | I1 | SCP0016 화면 | 하네스·환경 | I1 도구 오류 — 원장 V-470d544d RULE_SCREEN / 원장 V-0d84bf6d RULE_SCREEN / 원장 V-51ba81ed DEFECT / 원장 V-a1b8bf35 DEFECT / 원장 V-55cf9c43 DEF |  | 5 (1 2 EditButton(641) ACT:SCP0016_Waterfal) |
| WK-SCP0016-0154 | D3 | 1 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 1 'MSG00109 EditButton 읽기전용 가드(644)' 의 D3 1요소: ERROR:1 |  | 1 (1) |
| WK-SCP0016-0155 | D3 | D00-3-021 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 D00-3-021 '§3 LockColumn / (0, GetMaxColumnIndex, true) 전 컬럼 ' 의 D3 1요소: ERROR:1 |  | 1 (D00-3-021) |
| WK-SCP0016-0156 | D3 | EditButton(641) | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 EditButton(641) 'MSG00109 "읽기 전용입니다" 후 return' 의 D3 1요소: ERROR:1 |  | 1 (EditButton(641)) |
| WK-SCP0016-0157 | D3 | SCP0016_WaterfallShipmentPlanFG.EditButt | 하네스·환경 | D3 도구 오류 — 진입점 집계 — 대조표 SCP0016_WaterfallShipmentPlanFG.EditButton 의 D3 1요소: ERROR:1 |  | 1 (ACT:SCP0016_WaterfallShipmentPlanFG.Edit) |
| WK-SCP0016-0158 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-d4144bf0 / 실측[T-8fcebaba]: siMain.LockColumn: AS-IS 에 행 조건 잠금(lock_rules ROW_COND) 없음 — 편집 가능 여부는 D1 에서 판정 |  | 1 (ACT:SCP0016_WaterfallShipmentPlanFG.Find) |
| WK-SCP0016-0159 | D3 | 전 컬럼 Lock(#21, R1) | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 전 컬럼 Lock(#21, R1) 'DataGrid `isReadOnly={true}`' 의 D3 1요소: ERROR:1 |  | 1 (전 컬럼 Lock(#21, R1)) |
| WK-SCP0016-0160 | E4 | DateUtil.Check_PeriodDate | 하네스·환경 | E4 도구 오류 — 원장 V-901f4886 / 실측[T-445b6016]: DateUtil.Check_PeriodDate: 이 대상에 연결된 AS-IS 메시지 문장 없음 — 업무 검증 메시지 대상 아님 |  | 2 (ACT:SCP0016_WaterfallShipmentPlanFG.Find) |
| WK-SCP0016-0161 | A6 | D00-4a-003 | 하네스·환경 | A6 도구 오류 — 행 집계 — 대조표 D00-4a-003 '§4a (localConst, 빈 sp명) / GetSpdTitle(1120)' 의 A6 4요소: PASS:2 · ERROR:1 · NOT_RUN:1 |  | 1 (D00-4a-003) |
| WK-SCP0016-0162 | A6 | FindButton(636) | 하네스·환경 | A6 도구 오류 — 행 집계 — 대조표 FindButton(636) 'FindData_Main() 실동작' 의 A6 4요소: PASS:2 · ERROR:1 · NOT_RUN:1 |  | 1 (FindButton(636)) |
| WK-SCP0016-0163 | A6 | SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_T | 하네스·환경 | A6 도구 오류 — 원장 V-f293b53b SP / 원장 V-98799425 SP / 원장 V-4d18f292 SP / 정렬대조 REVIEW TO-BE 프로시저 배선(PROC_M) 없음 — 대응 프로시저 확인 / 실측[T-dc867 |  | 109 (D00-4a-002 ACT:SCP0016_WaterfallShipment) |
| WK-SCP0016-0164 | X-ROW | SCP0016_WaterfallShipmentPlanFG.BtnColum | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 7검사 — PASS:5 · ERROR:1 · NA:1 |  | 3 (ACT:SCP0016_WaterfallShipmentPlanFG.BtnC) |
| WK-SCP0016-0165 | X-ROW | SCP0016_WaterfallShipmentPlanFG.BtnItem_ | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — PASS:6 · NA:2 · ERROR:1 |  | 5 (ACT:SCP0016_WaterfallShipmentPlanFG.BtnI) |
| WK-SCP0016-0166 | X-ROW | SCP0016_WaterfallShipmentPlanFG.BtnProje | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — PASS:6 · NA:2 · ERROR:1 |  | 5 (ACT:SCP0016_WaterfallShipmentPlanFG.BtnP) |
| WK-SCP0016-0167 | X-ROW | SCP0016_WaterfallShipmentPlanFG.CboDivis | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0016_WaterfallShipmentPlanFG.CboD) |
| WK-SCP0016-0168 | X-ROW | SCP0016_WaterfallShipmentPlanFG.ClbVersi | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0016_WaterfallShipmentPlanFG.ClbV) |
| WK-SCP0016-0169 | X-ROW | SCP0016_WaterfallShipmentPlanFG.CreateSp | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0016_WaterfallShipmentPlanFG.Crea) |
| WK-SCP0016-0170 | X-ROW | SCP0016_WaterfallShipmentPlanFG.EditButt | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — NOT_RUN:2 · NA:2 · ERROR:1 |  | 1 (ACT:SCP0016_WaterfallShipmentPlanFG.Edit) |
| WK-SCP0016-0171 | X-ROW | SCP0016_WaterfallShipmentPlanFG.FindButt | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 12검사 — PASS:7 · REVIEW:2 · ERROR:2 · NOT_RUN:1 |  | 1 (ACT:SCP0016_WaterfallShipmentPlanFG.Find) |
| WK-SCP0016-0172 | X-ROW | SCP0016_WaterfallShipmentPlanFG.FindData | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 29검사 — PASS:16 · ERROR:5 · NA:4 · REVIEW:2 · NOT_RUN:1 · NOPATH:1 |  | 10 (ACT:SCP0016_WaterfallShipmentPlanFG.Find) |
| WK-SCP0016-0173 | X-ROW | SCP0016_WaterfallShipmentPlanFG.SetChang | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — NA:5 · ERROR:2 · NOT_RUN:1 · PASS:1 |  | 1 (ACT:SCP0016_WaterfallShipmentPlanFG.SetC) |
| WK-SCP0016-0174 | X-ROW | SCP0016_WaterfallShipmentPlanFG.SetDataT | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0016_WaterfallShipmentPlanFG.SetD) |
| WK-SCP0016-0175 | X-ROW | SCP0016_WaterfallShipmentPlanFG.SetOpera | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — NA:3 · PASS:1 · NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:SCP0016_WaterfallShipmentPlanFG.SetO) |
| WK-SCP0016-0176 | X-ROW | SCP0016_WaterfallShipmentPlanFG.SetSprea | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 16검사 — NA:11 · PASS:4 · ERROR:1 |  | 8 (ACT:SCP0016_WaterfallShipmentPlanFG.SetS) |
| WK-SCP0016-0177 | X-ROW | SCP0016_WaterfallShipmentPlanFG.Set_SumV | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — NA:4 · ERROR:2 |  | 8 (ACT:SCP0016_WaterfallShipmentPlanFG.Set_) |
| WK-SCP0016-0178 | X-ROW | SCP0016_WaterfallShipmentPlanFG.btnMeasu | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 7검사 — PASS:4 · NA:2 · ERROR:1 |  | 5 (ACT:SCP0016_WaterfallShipmentPlanFG.btnM) |
| WK-SCP0016-0179 | X-ROW | SCP0016_WaterfallShipmentPlanFG.cboBucke | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0016_WaterfallShipmentPlanFG.cboB) |
| WK-SCP0016-0180 | X-ROW | SCP0016_WaterfallShipmentPlanFG.chkSum_C | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0016_WaterfallShipmentPlanFG.chkS) |
| WK-SCP0016-0181 | X-ROW | SCP0016_WaterfallShipmentPlanFG.dCalenda | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0016_WaterfallShipmentPlanFG.dCal) |
| WK-SCP0016-0182 | G5 | 10 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 10 'SpdMain_CellDoubleClick(1051)' 의 G5 17요소: NA:8 · NOPATH:4 · PASS:3 · ERROR:2 |  | 1 (10) |
| WK-SCP0016-0183 | G5 | COMMON:UC-06 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)' 의 G5 17요소: NA:8 · NOPATH:4 · PASS:3 · ERROR:2 |  | 1 (COMMON:UC-06) |
| WK-SCP0016-0184 | G5 | D00-2-010 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 D00-2-010 '§2 spdMain / CellDoubleClick' 의 G5 17요소: NA:8 · NOPATH:4 · PASS:3 · ERROR:2 |  | 1 (D00-2-010) |
| WK-SCP0016-0185 | G5 | D00-4b-009 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 D00-4b-009 '§4b SpdMain_CellDoubleClick / event / spdMain' 의 G5 17요소: NA:8 · NOPATH:4 · PASS:3 · ERROR:2 |  | 1 (D00-4b-009) |
| WK-SCP0016-0186 | G5 | D00-4d-001 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 D00-4d-001 '§4d SpdMain_CellDoubleClick / (grid dblclick)' 의 G5 17요소: NA:8 · NOPATH:4 · PASS:3 · ERROR:2 |  | 1 (D00-4d-001) |
| WK-SCP0016-0187 | G5 | D00-4e-003 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 D00-4e-003 '§4e SCM0002_ItembyDivisionPopup / ShowDialog(modal' 의 G5 17요소: NA:8 · NOPATH:4 · PASS:3 · ERROR: |  | 1 (D00-4e-003) |
| WK-SCP0016-0188 | G5 | D00-4e-004 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 D00-4e-004 '§4e SCM0002_ProjectbyDivisionPopup / ShowDialog(mo' 의 G5 17요소: NA:8 · NOPATH:4 · PASS:3 · ERROR: |  | 1 (D00-4e-004) |
| WK-SCP0016-0189 | G5 | MODAL:ShowDialog | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 MODAL:ShowDialog 'AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무' 의 G5 17요소: NA:8 · NOPATH:4 · PASS:3 · ERROR:2 |  | 1 (MODAL:ShowDialog) |
| WK-SCP0016-0190 | G5 | ProgressForm(로딩) | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 ProgressForm(로딩) 'react-query isLoading/isFetching(별도 토스트 미추가)' 의 G5 17요소: NA:8 · NOPATH:4 · PASS:3 · ERROR: |  | 1 (ProgressForm(로딩)) |
| WK-SCP0016-0191 | G5 | SCM0002_ItembyDivisionPopup | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 SCM0002_ItembyDivisionPopup '`ItemByDivisionModal` (공용, div 필터)' 의 G5 17요소: NA:8 · NOPATH:4 · PASS:3 · ERROR |  | 1 (SCM0002_ItembyDivisionPopup) |
| WK-SCP0016-0192 | G5 | SCM0002_ProjectbyDivisionPopup | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 SCM0002_ProjectbyDivisionPopup '`ProjectByDivisionModal` (공용, div 필터)' 의 G5 17요소: NA:8 · NOPATH:4 · PASS:3 · |  | 1 (SCM0002_ProjectbyDivisionPopup) |
| WK-SCP0016-0193 | G5 | txtItem_Id / Model / Item_Id / Model/Nic | 하네스·환경 | G5 도구 오류 — 원장 V-d35cb779 SEARCH |  | 2 (D00-1-005 4) |
| WK-SCP0016-0194 | G5 | txtProject / Project / PJT | 하네스·환경 | G5 도구 오류 — 원장 V-2079185b SEARCH |  | 2 (D00-1-003 3) |
| WK-SCP0016-0195 | H6 | SCP0016_WaterfallShipmentPlanFG.SpdMain_ | 하네스·환경 | H6 도구 오류 — 진입점 집계 — 대조표 SCP0016_WaterfallShipmentPlanFG.SpdMain_CellDoubleClick 의 H6 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0016_WaterfallShipmentPlanFG.SpdM) |
| WK-SCP0016-0196 | M4 | 10 | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 10 'SpdMain_CellDoubleClick(1051)' 의 M4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (10) |
| WK-SCP0016-0197 | M4 | COMMON:UC-06 | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 COMMON:UC-06 'Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8)' 의 M4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (COMMON:UC-06) |
| WK-SCP0016-0198 | M4 | D00-2-010 | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 D00-2-010 '§2 spdMain / CellDoubleClick' 의 M4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-2-010) |
| WK-SCP0016-0199 | M4 | D00-4b-009 | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 D00-4b-009 '§4b SpdMain_CellDoubleClick / event / spdMain' 의 M4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4b-009) |
| WK-SCP0016-0200 | M4 | D00-4d-001 | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 D00-4d-001 '§4d SpdMain_CellDoubleClick / (grid dblclick)' 의 M4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4d-001) |
| WK-SCP0016-0201 | M4 | D00-4e-003 | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 D00-4e-003 '§4e SCM0002_ItembyDivisionPopup / ShowDialog(modal' 의 M4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-003) |
| WK-SCP0016-0202 | M4 | D00-4e-004 | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 D00-4e-004 '§4e SCM0002_ProjectbyDivisionPopup / ShowDialog(mo' 의 M4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (D00-4e-004) |
| WK-SCP0016-0203 | M4 | MODAL:ShowDialog | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 MODAL:ShowDialog 'AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무' 의 M4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (MODAL:ShowDialog) |
| WK-SCP0016-0204 | M4 | ProgressForm(로딩) | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 ProgressForm(로딩) 'react-query isLoading/isFetching(별도 토스트 미추가)' 의 M4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (ProgressForm(로딩)) |
| WK-SCP0016-0205 | M4 | SCM0002_ItembyDivisionPopup | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 SCM0002_ItembyDivisionPopup '`ItemByDivisionModal` (공용, div 필터)' 의 M4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (SCM0002_ItembyDivisionPopup) |
| WK-SCP0016-0206 | M4 | SCM0002_ProjectbyDivisionPopup | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 SCM0002_ProjectbyDivisionPopup '`ProjectByDivisionModal` (공용, div 필터)' 의 M4 7요소: NOT_RUN:7 (미실행 요소가 남아 판정필요) |  | 1 (SCM0002_ProjectbyDivisionPopup) |
| WK-SCP0016-0207 | M4 | SCP0016_WaterfallShipmentPlanFG.SpdMain_ | 하네스·환경 | M4 도구 오류 — 진입점 집계 — 대조표 SCP0016_WaterfallShipmentPlanFG.SpdMain_CellDoubleClick 의 M4 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 1 (ACT:SCP0016_WaterfallShipmentPlanFG.SpdM) |
