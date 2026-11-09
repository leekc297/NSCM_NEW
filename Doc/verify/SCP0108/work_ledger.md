# 작업 원장 — SCP0108 · 2026-11-09 10:49

> 검사 인스턴스 543건 중 PASS·NA 344건 외 **199건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 14 | 재판정 PASS |
| W5 | 검사기 연결 | 27 | 원장 항목/엔진 연결 → 실행 PASS |
| W7 | 기대값 확정 | 73 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 85 | 원인 해소 → 재판정 |

- 담당: 하네스·환경 85 · 사람 판정 / AS-IS 원문 확인 → 재판정 73 · 하네스 27 · FE 14
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 1건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| X-LOC | GEN |  |  |  |  |  |  | 51 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| X-ROW | GEN |  |  | 1 |  |  |  | 10 |  | 20 | 대조표 행이 서술한 동작을 화면에서 재현 |
| G1 | GEN |  |  |  |  |  |  |  |  | 21 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| H2 | DESIGN |  |  |  |  |  |  |  |  | 18 | 배경·글자색 규칙 |
| B4 | COMBO |  |  |  |  | 11 |  | 5 |  |  | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| G4 | DESIGN |  |  | 12 |  | 2 |  |  |  |  | 조회조건 표시·라벨·활성 |
| B3 | COMBO |  |  |  |  | 11 |  |  |  |  | 콤보 후보 정렬 = AS-IS |
| C2 | CASCADE |  |  |  |  |  |  |  |  | 10 | 그리드 셀 cascade 후보 |
| D1 | EDIT |  |  |  |  |  |  |  |  | 8 | 컬럼 편집 가능 여부(신규행·기존행) |
| M4 | POPUP |  |  |  |  |  |  | 3 |  | 3 | 팝업 선택값 반영 |
| H6 | POPUP |  |  |  |  | 1 |  | 4 |  |  | 팝업 표준·열림 |
| F5 | CRUD |  |  | 1 |  |  |  |  |  |  | CRUD Status 표시 정합 |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| G5 | POPUP |  |  |  |  | 1 |  |  |  |  | 팝업 조건 연동(인자) |
| K4 | COMMON |  |  |  |  |  |  |  |  | 1 | 버튼 구성·조건별 노출 |
| F6 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 값 보존 |
| I1 | DESIGN |  |  |  |  |  |  |  |  | 1 | LBL/MSG 언어별 등록 |
| D6 | EDIT |  |  |  |  |  |  |  |  | 1 | Insert 위치·상태 유지 |
| M3 | POPUP |  |  |  |  |  |  |  |  | 1 | 팝업 내부 기능(조회·CRUD) · 팝업 목록 행수(조회조건 변경 후 포함) |

## W3 동작 수정 (14)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0108-0001 | F5 | SCP0108 화면 | FE(repairScope=DB_ONLY — 이번 범위 밖) | F5 FAIL 수정 — SCP0108 화면: 원장 V-6316517e RULE_SCREEN / 원장 V-c2748f5d RULE_SCREEN / 원장 V-601ffa40 RULE_SCREEN / 원장 V-bbf02416 DEFECT  |  | 22 (gridSignals entryPoints buttonGuards `Ca) |
| WK-SCP0108-0002 | G4 | `components/CapaLobReportForm.tsx` | FE(repairScope=DB_ONLY — 이번 범위 밖) | G4 FAIL 수정 — `components/CapaLobReportForm.tsx`: 행 집계 — 대조표 `components/CapaLobReportForm.tsx` '`usrConditionPanel1`(dsn:133~141)  |  | 1 (`components/CapaLobReportForm.tsx`) |
| WK-SCP0108-0003 | G4 | cboDivision / Division / Div / Div. | FE(repairScope=DB_ONLY — 이번 범위 밖) | G4 FAIL 수정 — cboDivision / Division / Div / Div.: 원장 V-bc1fc362 SEARCH / E2E smoke labels |  | 2 (ACT:SCP0108_CAPA_LOB_Report.InitEvent AC) |
| WK-SCP0108-0004 | G4 | cboVersion / Plan Month / Version / Ver. | FE(repairScope=DB_ONLY — 이번 범위 밖) | G4 FAIL 수정 — cboVersion / Plan Month / Version / Ver.: 원장 V-3c4cbfdf SEARCH / 원장 V-06170cb1 SEARCH / E2E smoke labels |  | 2 (ACT:SCP0108_CAPA_LOB_Report.InitEvent AC) |
| WK-SCP0108-0005 | G4 | cboVersionSeq / Version / Version Seq /  | FE(repairScope=DB_ONLY — 이번 범위 밖) | G4 FAIL 수정 — cboVersionSeq / Version / Version Seq / Ver. / Version.: 원장 V-06170cb1 SEARCH / E2E smoke labels |  | 2 (ACT:SCP0108_CAPA_LOB_Report.InitEvent AC) |
| WK-SCP0108-0006 | G4 | clbFactory / Building / Factory | FE(repairScope=DB_ONLY — 이번 범위 밖) | G4 FAIL 수정 — clbFactory / Building / Factory: 원장 V-a7f8eb15 SEARCH / E2E smoke labels |  | 2 (ACT:SCP0108_CAPA_LOB_Report.InitEvent AC) |
| WK-SCP0108-0007 | G4 | clbLine / Line | FE(repairScope=DB_ONLY — 이번 범위 밖) | G4 FAIL 수정 — clbLine / Line: 원장 V-151cf204 SEARCH / E2E smoke labels |  | 2 (ACT:SCP0108_CAPA_LOB_Report.InitEvent AC) |
| WK-SCP0108-0008 | G4 | clbOperation / Operation | FE(repairScope=DB_ONLY — 이번 범위 밖) | G4 FAIL 수정 — clbOperation / Operation: 원장 V-35b893a0 SEARCH / E2E smoke labels |  | 2 (ACT:SCP0108_CAPA_LOB_Report.InitEvent AC) |
| WK-SCP0108-0009 | G4 | clbPlant / Plant | FE(repairScope=DB_ONLY — 이번 범위 밖) | G4 FAIL 수정 — clbPlant / Plant: 원장 V-c1db73c0 SEARCH / E2E smoke labels |  | 2 (ACT:SCP0108_CAPA_LOB_Report.InitEvent AC) |
| WK-SCP0108-0010 | G4 | clbSite / Site | FE(repairScope=DB_ONLY — 이번 범위 밖) | G4 FAIL 수정 — clbSite / Site: 원장 V-8fc61407 SEARCH / E2E smoke labels |  | 2 (ACT:SCP0108_CAPA_LOB_Report.InitEvent AC) |
| WK-SCP0108-0011 | G4 | entryPoints | FE(repairScope=DB_ONLY — 이번 범위 밖) | G4 FAIL 수정 — entryPoints: 행 집계 — 대조표 entryPoints '15' 의 G4 11요소: FAIL:9 · NOPATH:2 · FAIL 요소: rgrpDivisionType / Division Ty — 원장  |  | 1 (entryPoints) |
| WK-SCP0108-0012 | G4 | rgrpDivisionType / Division Type / Opera | FE(repairScope=DB_ONLY — 이번 범위 밖) | G4 FAIL 수정 — rgrpDivisionType / Division Type / Operation group: 원장 V-03c504d5 SEARCH / E2E smoke labels |  | 4 (ACT:SCP0108_CAPA_LOB_Report.Form_Load AC) |
| WK-SCP0108-0013 | G4 | 필수 조회조건 UI(`*`) · Search 전 alert | FE(repairScope=DB_ONLY — 이번 범위 밖) | G4 FAIL 수정 — 필수 조회조건 UI(`*`) · Search 전 alert: 행 집계 — 대조표 필수 조회조건 UI(`*`) · Search 전 alert '`DataUtil.InitCheck`(DataUtil:370~622) |  | 1 (필수 조회조건 UI(`*`) · Search 전 alert) |
| WK-SCP0108-0014 | X-ROW | SCP0108_CAPA_LOB_Report.Form_Load | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SCP0108_CAPA_LOB_Report.Form_Load: 진입점 집계 3검사 — PASS:2 · FAIL:1 |  | 1 (ACT:SCP0108_CAPA_LOB_Report.Form_Load:97) |

## W5 검사기 연결 (27)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0108-0015 | B3 | COMPANY_ID / Company | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL COMPANY_ID / Company | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrCompa) |
| WK-SCP0108-0016 | B3 | DIVISION_ID / Div | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL DIVISION_ID / Div | 있음(SHEET_COLUMNS) | 4 (ACT:SCP0108_CAPA_LOB_Report.GetCurrVersi) |
| WK-SCP0108-0017 | B3 | ELTR_LN_TP_CD / Line Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL ELTR_LN_TP_CD / Line Type | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrElect) |
| WK-SCP0108-0018 | B3 | FACTORY_ID / Building | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL FACTORY_ID / Building | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrFacto) |
| WK-SCP0108-0019 | B3 | LINE_ID / Line | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL LINE_ID / Line | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrLine ) |
| WK-SCP0108-0020 | B3 | NICK_NAME / Basic Nickname | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL NICK_NAME / Basic Nickname | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrNickn) |
| WK-SCP0108-0021 | B3 | OPERATION_ID / Operation | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL OPERATION_ID / Operation | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrOpera) |
| WK-SCP0108-0022 | B3 | PLANT_ID / Plant | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL PLANT_ID / Plant | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrPlant) |
| WK-SCP0108-0023 | B3 | SITE_ID / Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL SITE_ID / Site | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrSite ) |
| WK-SCP0108-0024 | B3 | VER_SEQ / Seq | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL VER_SEQ / Seq | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0108_CAPA_LOB_Report.GetCurrVersi) |
| WK-SCP0108-0025 | B3 | txtItem / Basic Nickname / Item | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COND txtItem / Basic Nickname / Item | 있음(FE 소스) | 2 (ACT:SCP0108_CAPA_LOB_Report.getItemId AC) |
| WK-SCP0108-0026 | B4 | COMPANY_ID / Company | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL COMPANY_ID / Company | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrCompa) |
| WK-SCP0108-0027 | B4 | DIVISION_ID / Div | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DIVISION_ID / Div | 있음(SHEET_COLUMNS) | 4 (ACT:SCP0108_CAPA_LOB_Report.GetCurrVersi) |
| WK-SCP0108-0028 | B4 | ELTR_LN_TP_CD / Line Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL ELTR_LN_TP_CD / Line Type | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrElect) |
| WK-SCP0108-0029 | B4 | FACTORY_ID / Building | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL FACTORY_ID / Building | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrFacto) |
| WK-SCP0108-0030 | B4 | LINE_ID / Line | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL LINE_ID / Line | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrLine ) |
| WK-SCP0108-0031 | B4 | NICK_NAME / Basic Nickname | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL NICK_NAME / Basic Nickname | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrNickn) |
| WK-SCP0108-0032 | B4 | OPERATION_ID / Operation | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL OPERATION_ID / Operation | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrOpera) |
| WK-SCP0108-0033 | B4 | PLANT_ID / Plant | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL PLANT_ID / Plant | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrPlant) |
| WK-SCP0108-0034 | B4 | SITE_ID / Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL SITE_ID / Site | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0108_CAPA_LOB_Report.getCurrSite ) |
| WK-SCP0108-0035 | B4 | VER_SEQ / Seq | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL VER_SEQ / Seq | 있음(SHEET_COLUMNS) | 2 (ACT:SCP0108_CAPA_LOB_Report.GetCurrVersi) |
| WK-SCP0108-0036 | B4 | txtItem / Basic Nickname / Item | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COND txtItem / Basic Nickname / Item | 있음(FE 소스) | 2 (ACT:SCP0108_CAPA_LOB_Report.getItemId AC) |
| WK-SCP0108-0037 | G4 | btnItem | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItem | 없음 | 2 (ACT:SCP0108_CAPA_LOB_Report.InitEvent AC) |
| WK-SCP0108-0038 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 있음(FE 소스) | 2 (ACT:SCP0108_CAPA_LOB_Report.InitEvent AC) |
| WK-SCP0108-0039 | G03-WIRE | SCP0108 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0108 화면 | 판단불가(대상 단위 SCREEN) | 15 (ACT:SCP0108_CAPA_LOB_Report..ctor ACT:SC) |
| WK-SCP0108-0040 | G5 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 BTN btnItemId | 있음(FE 소스) | 0 () |
| WK-SCP0108-0041 | H6 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 BTN btnItemId | 있음(FE 소스) | 0 () |

## W7 기대값 확정 (73)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0108-0042 | B4 | SCP0108_CAPA_LOB_Report.GetSpdTitle | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0108_CAPA_LOB_Report.GetSpdTitle: 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.GetSpdTitle 의 B4 23요소: NOPATH:11 · NA:11 · R |  | 7 (ACT:SCP0108_CAPA_LOB_Report.GetSpdTitle:) |
| WK-SCP0108-0043 | B4 | SCP0108_CAPA_LOB_Report.getBottleneck | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0108_CAPA_LOB_Report.getBottleneck: 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.getBottleneck 의 B4 1요소: REVIEW:1 · FAIL 요소 |  | 3 (ACT:SCP0108_CAPA_LOB_Report.getBottlenec) |
| WK-SCP0108-0044 | B4 | SCP0108_CAPA_LOB_Report.getPlanType | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0108_CAPA_LOB_Report.getPlanType: 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.getPlanType 의 B4 23요소: NOPATH:11 · NA:11 · R |  | 1 (ACT:SCP0108_CAPA_LOB_Report.getPlanType:) |
| WK-SCP0108-0045 | B4 | SCP0108_CAPA_LOB_Report.getShopGroup | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — SCP0108_CAPA_LOB_Report.getShopGroup: 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.getShopGroup 의 B4 23요소: NOPATH:11 · NA:11 · |  | 1 (ACT:SCP0108_CAPA_LOB_Report.getShopGroup) |
| WK-SCP0108-0046 | B4 | cboBottleneck / Bottleneck | 사람 판정 / AS-IS 원문 확인 → 재판정 | B4 기대값 확정 — cboBottleneck / Bottleneck: 원장 V-d15a8ae3 SEARCH |  | 2 (ACT:SCP0108_CAPA_LOB_Report.getBottlenec) |
| WK-SCP0108-0047 | X-LOC | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (2) |
| WK-SCP0108-0048 | X-LOC | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (3) |
| WK-SCP0108-0049 | X-LOC | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (4) |
| WK-SCP0108-0050 | X-LOC | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (5) |
| WK-SCP0108-0051 | X-LOC | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 6: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (6) |
| WK-SCP0108-0052 | X-LOC | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 7: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (7) |
| WK-SCP0108-0053 | X-LOC | ADMIN | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — ADMIN: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (ADMIN) |
| WK-SCP0108-0054 | X-LOC | AS-IS 빈 `catch`(`_from_yyyymm` 파싱 실패) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — AS-IS 빈 `catch`(`_from_yyyymm` 파싱 실패): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (AS-IS 빈 `catch`(`_from_yyyymm` 파싱 실패)) |
| WK-SCP0108-0055 | X-LOC | AS-IS 헤더 높이 75px(1단 35 + 2·3단 20) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — AS-IS 헤더 높이 75px(1단 35 + 2·3단 20): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (AS-IS 헤더 높이 75px(1단 35 + 2·3단 20)) |
| WK-SCP0108-0056 | X-LOC | Bottleneck **행 인덱스** 대응 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Bottleneck **행 인덱스** 대응: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Bottleneck **행 인덱스** 대응) |
| WK-SCP0108-0057 | X-LOC | CAPA Planner | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — CAPA Planner: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (CAPA Planner) |
| WK-SCP0108-0058 | X-LOC | Edit 버튼(`customButtons`) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Edit 버튼(`customButtons`): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Edit 버튼(`customButtons`)) |
| WK-SCP0108-0059 | X-LOC | FP Planner | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — FP Planner: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (FP Planner) |
| WK-SCP0108-0060 | X-LOC | FP Viewer | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — FP Viewer: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (FP Viewer) |
| WK-SCP0108-0061 | X-LOC | Formation(`AFFFF`) **전역** 제외 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Formation(`AFFFF`) **전역** 제외: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Formation(`AFFFF`) **전역** 제외) |
| WK-SCP0108-0062 | X-LOC | G1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G1) |
| WK-SCP0108-0063 | X-LOC | G2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G2) |
| WK-SCP0108-0064 | X-LOC | G3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G3) |
| WK-SCP0108-0065 | X-LOC | G4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G4) |
| WK-SCP0108-0066 | X-LOC | G5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G5) |
| WK-SCP0108-0067 | X-LOC | G6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G6: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G6) |
| WK-SCP0108-0068 | X-LOC | SCM PI Admin | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SCM PI Admin: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SCM PI Admin) |
| WK-SCP0108-0069 | X-LOC | SCM Viewer | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SCM Viewer: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SCM Viewer) |
| WK-SCP0108-0070 | X-LOC | SCP Planner | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SCP Planner: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SCP Planner) |
| WK-SCP0108-0071 | X-LOC | SCP Tester | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SCP Tester: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SCP Tester) |
| WK-SCP0108-0072 | X-LOC | `CapaLineMasterEE_SCP_ALL` 콤보 스왑 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `CapaLineMasterEE_SCP_ALL` 콤보 스왑: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`CapaLineMasterEE_SCP_ALL` 콤보 스왑) |
| WK-SCP0108-0073 | X-LOC | `LockColumn` 컬럼명 상수 배열 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `LockColumn` 컬럼명 상수 배열: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`LockColumn` 컬럼명 상수 배열) |
| WK-SCP0108-0074 | X-LOC | `ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용 시트" 로 구현: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용) |
| WK-SCP0108-0075 | X-LOC | `_ASSIGN_PRIORITY` 제외 필터 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `_ASSIGN_PRIORITY` 제외 필터: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`_ASSIGN_PRIORITY` 제외 필터) |
| WK-SCP0108-0076 | X-LOC | `_dateStartColIdx` / `_dateEndColIdx` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `_dateStartColIdx` / `_dateEndColIdx`: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`_dateStartColIdx` / `_dateEndColIdx`) |
| WK-SCP0108-0077 | X-LOC | `dtFromYYYY`(`YearFromThisYear_SCP_ALL`) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `dtFromYYYY`(`YearFromThisYear_SCP_ALL`): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`dtFromYYYY`(`YearFromThisYear_SCP_ALL`)) |
| WK-SCP0108-0078 | X-LOC | `dtYesOrNo` 필드 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `dtYesOrNo` 필드: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`dtYesOrNo` 필드) |
| WK-SCP0108-0079 | X-LOC | `fetchStaticMeasures` / `staticMeasures` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `fetchStaticMeasures` / `staticMeasures`: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`fetchStaticMeasures` / `staticMeasures`) |
| WK-SCP0108-0080 | X-LOC | `frozenColumns={1}` 하드코딩 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `frozenColumns={1}` 하드코딩: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`frozenColumns={1}` 하드코딩) |
| WK-SCP0108-0081 | X-LOC | `imageList1` | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `imageList1`: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`imageList1`) |
| WK-SCP0108-0082 | X-LOC | `isEditMode` state | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `isEditMode` state: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`isEditMode` state) |
| WK-SCP0108-0083 | X-LOC | `spdMain_TopChange` 스크롤 핸들러 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `spdMain_TopChange` 스크롤 핸들러: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`spdMain_TopChange` 스크롤 핸들러) |
| WK-SCP0108-0084 | X-LOC | `statusIdx = UIUtils.GetIndexByCode(...) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `statusIdx = UIUtils.GetIndexByCode(...)`: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`statusIdx = UIUtils.GetIndexByCode(...)) |
| WK-SCP0108-0085 | X-LOC | `useProcMutation`/`useSaveWithValidation | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `useProcMutation`/`useSaveWithValidation`/`EditTra: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`useProcMutation`/`useSaveWithValidation) |
| WK-SCP0108-0086 | X-LOC | `usrLayoutControl1` / `layoutControlGrou | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — `usrLayoutControl1` / `layoutControlGroup1`: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (`usrLayoutControl1` / `layoutControlGrou) |
| WK-SCP0108-0087 | X-LOC | buttonGuards | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — buttonGuards: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (buttonGuards) |
| WK-SCP0108-0088 | X-LOC | comboCalls | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — comboCalls: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (comboCalls) |
| WK-SCP0108-0089 | X-LOC | entryPoints | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — entryPoints: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (entryPoints) |
| WK-SCP0108-0090 | X-LOC | events | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — events: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (events) |
| WK-SCP0108-0091 | X-LOC | extractionLimits | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — extractionLimits: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (extractionLimits) |
| WK-SCP0108-0092 | X-LOC | gridColumns | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — gridColumns: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (gridColumns) |
| WK-SCP0108-0093 | X-LOC | gridSignals | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — gridSignals: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (gridSignals) |
| WK-SCP0108-0094 | X-LOC | validations | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — validations: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (validations) |
| WK-SCP0108-0095 | X-LOC | 데드 핸들러 `cboSheetType_SelectedIndexChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 데드 핸들러 `cboSheetType_SelectedIndexChanged` / `cboF: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (데드 핸들러 `cboSheetType_SelectedIndexChange) |
| WK-SCP0108-0096 | X-LOC | 시트 탭 UI(`TabWrapper`/`TabPanel`) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 시트 탭 UI(`TabWrapper`/`TabPanel`): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (시트 탭 UI(`TabWrapper`/`TabPanel`)) |
| WK-SCP0108-0097 | X-LOC | 필수 조회조건 UI(`*`) · Search 전 alert | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 필수 조회조건 UI(`*`) · Search 전 alert: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (필수 조회조건 UI(`*`) · Search 전 alert) |
| WK-SCP0108-0098 | X-ROW | SCP0108_CAPA_LOB_Report.BeforeFindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.BeforeFindData: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0108_CAPA_LOB_Report.BeforeFindDa) |
| WK-SCP0108-0099 | X-ROW | SCP0108_CAPA_LOB_Report.ChangeColumnName | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.ChangeColumnNameToCodeName: 진입점 동작 재현 시나리오 필요 — 문장 종류 DATA_OP/ENTRY/GRID_SET, 연결된 요소 검사 없음 |  | 5 (ACT:SCP0108_CAPA_LOB_Report.ChangeColumn) |
| WK-SCP0108-0100 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.RefreshAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 7 (ACT:SCP0108_CAPA_LOB_Report.RefreshAll A) |
| WK-SCP0108-0101 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshDateColum | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.RefreshDateColumnStatus: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/CALL_EXT/ENTRY/EXPR/LOCAL/UI_MISC |  | 16 (ACT:SCP0108_CAPA_LOB_Report.RefreshDateC) |
| WK-SCP0108-0102 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshFactoryAl | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.RefreshFactoryAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0108_CAPA_LOB_Report.RefreshFacto) |
| WK-SCP0108-0103 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshLineAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.RefreshLineAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0108_CAPA_LOB_Report.RefreshLineA) |
| WK-SCP0108-0104 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshPlanType | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.RefreshPlanType: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/VALUE_SET, 연결된 요소 검사 없음 |  | 2 (ACT:SCP0108_CAPA_LOB_Report.RefreshPlanT) |
| WK-SCP0108-0105 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshPlantAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.RefreshPlantAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0108_CAPA_LOB_Report.RefreshPlant) |
| WK-SCP0108-0106 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshSheetHead | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.RefreshSheetHeader: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY/GRID_INIT, 연결된 요소 검 |  | 5 (ACT:SCP0108_CAPA_LOB_Report.RefreshSheet) |
| WK-SCP0108-0107 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshSiteAll | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0108_CAPA_LOB_Report.RefreshSiteAll: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_EXT/CALL_LOCAL/ENTRY, 연결된 요소 검사 없음 |  | 4 (ACT:SCP0108_CAPA_LOB_Report.RefreshSiteA) |
| WK-SCP0108-0108 | H6 | `components/modals/CapaLobReportItemPopu | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — `components/modals/CapaLobReportItemPopup.tsx`: 행 집계 — 대조표 `components/modals/CapaLobReportItemPopup.tsx` '`ShowItem`( |  | 1 (`components/modals/CapaLobReportItemPopu) |
| WK-SCP0108-0109 | H6 | entryPoints | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — entryPoints: 행 집계 — 대조표 entryPoints '15' 의 H6 7요소: NA:5 · WARN:1 · NOPATH:1 |  | 1 (entryPoints) |
| WK-SCP0108-0110 | H6 | popups | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — popups: 행 집계 — 대조표 popups '2' 의 H6 7요소: NA:5 · WARN:1 · NOPATH:1 |  | 1 (popups) |
| WK-SCP0108-0111 | H6 | txtItem / Basic Nickname / Item | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — txtItem / Basic Nickname / Item: E2E smoke cond popup / 실측[T-8477c6ee]: E2E smoke cond popup / 실측[T-8477c6ee]: E2E smo |  | 0 () |
| WK-SCP0108-0112 | M4 | btnColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — btnColumn: 검증 엔진이 실행됐으나 이 대상(BTN btnColumn)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 1 (`components/modals/CapaLobReportColumnMo) |
| WK-SCP0108-0113 | M4 | btnItemId | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — btnItemId: 검증 엔진이 실행됐으나 이 대상(BTN btnItemId)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 0 () |
| WK-SCP0108-0114 | M4 | txtItem / Basic Nickname / Item | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — txtItem / Basic Nickname / Item: 검증 엔진이 실행됐으나 이 대상(COND txtItem)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확인 또는 엔진 확장 |  | 0 () |

## W9 도구 오류 (85)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0108-0115 | C2 | SCP0108_CAPA_LOB_Report.cboDivision_Sele | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.cboDivision_SelectedIndexChanged 의 C2 1요소: ERROR:1 |  | 6 (ACT:SCP0108_CAPA_LOB_Report.cboDivision_) |
| WK-SCP0108-0116 | C2 | SCP0108_CAPA_LOB_Report.cboVersionSeq_Se | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.cboVersionSeq_SelectedIndexChanged 의 C2 1요소: ERROR:1 |  | 4 (ACT:SCP0108_CAPA_LOB_Report.cboVersionSe) |
| WK-SCP0108-0117 | C2 | SCP0108_CAPA_LOB_Report.cboVersion_Selec | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.cboVersion_SelectedIndexChanged 의 C2 1요소: ERROR:1 |  | 5 (ACT:SCP0108_CAPA_LOB_Report.cboVersion_S) |
| WK-SCP0108-0118 | C2 | SCP0108_CAPA_LOB_Report.clbFactory_Selec | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.clbFactory_SelectedIndexChanged 의 C2 1요소: ERROR:1 |  | 2 (ACT:SCP0108_CAPA_LOB_Report.clbFactory_S) |
| WK-SCP0108-0119 | C2 | SCP0108_CAPA_LOB_Report.clbLine_Selected | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.clbLine_SelectedIndexChanged 의 C2 1요소: ERROR:1 |  | 1 (ACT:SCP0108_CAPA_LOB_Report.clbLine_Sele) |
| WK-SCP0108-0120 | C2 | SCP0108_CAPA_LOB_Report.clbOperation_Sel | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.clbOperation_SelectedIndexChanged 의 C2 1요소: ERROR:1 |  | 1 (ACT:SCP0108_CAPA_LOB_Report.clbOperation) |
| WK-SCP0108-0121 | C2 | SCP0108_CAPA_LOB_Report.clbPlant_Selecte | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.clbPlant_SelectedIndexChanged 의 C2 1요소: ERROR:1 |  | 3 (ACT:SCP0108_CAPA_LOB_Report.clbPlant_Sel) |
| WK-SCP0108-0122 | C2 | SCP0108_CAPA_LOB_Report.clbSite_Selected | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.clbSite_SelectedIndexChanged 의 C2 1요소: ERROR:1 |  | 4 (ACT:SCP0108_CAPA_LOB_Report.clbSite_Sele) |
| WK-SCP0108-0123 | C2 | SCP0108_CAPA_LOB_Report.rgrpDivisionType | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.rgrpDivisionType_SelectedIndexChanged 의 C2 1요소: ERROR:1 |  | 2 (ACT:SCP0108_CAPA_LOB_Report.rgrpDivision) |
| WK-SCP0108-0124 | C2 | VER_SEQ / Seq | 하네스·환경 | C2 도구 오류 — 실측[T-b4d406d5]: [측정 경로 없음] Insert 가 대화상자를 띄움(신규 행 직접 생성 아님) '수정모드가 아니므로 추가할 수 없습니다.
Confirm' |  | 1 (ACT:SCP0108_CAPA_LOB_Report.RefreshVersi) |
| WK-SCP0108-0125 | K4 | SCP0108 화면 | 하네스·환경 | K4 도구 오류 — 원장 V-dad03d7f GENERAL / 원장 V-200c362c GENERAL / 원장 V-1814b1bd GENERAL / 원장 V-2811f159 GENERAL / 원장 V-43fd03d9 GENERAL / |  | 9 (ACT:SCP0108_CAPA_LOB_Report.btnColumn_Cl) |
| WK-SCP0108-0126 | F6 | SCP0108 화면 | 하네스·환경 | F6 도구 오류 — 원장 V-07b3c280 RULE_SCREEN / 원장 V-1900776b RULE_SCREEN / 원장 V-c7365d8a GENERAL / 원장 V-28a2308e GENERAL / 원장 V-2a9b5eca G |  | 1 (`useProcMutation`/`useSaveWithValidation) |
| WK-SCP0108-0127 | H2 | (2) **버튼 ACL** | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 (2) **버튼 ACL** '`BaseForm:3023~3032`(Select) · `3171~3231`(C/U/D)' 의 H2 1요소: ERROR:1 |  | 1 ((2) **버튼 ACL**) |
| WK-SCP0108-0128 | H2 | (3) **시트 잠금** | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 (3) **시트 잠금** '`BaseForm:3302~3340`(`CheckValidation`)' 의 H2 1요소: ERROR:1 |  | 1 ((3) **시트 잠금**) |
| WK-SCP0108-0129 | H2 | ELTR_LN_TP_CD / Line Type | 하네스·환경 | H2 도구 오류 — 원장 V-a12d903f COLUMN / 원장 V-c768cca5 COLUMN / 실측[T-6417257d]: [측정 경로 없음] Insert 가 대화상자를 띄움(신규 행 직접 생성 아님) '수정모드가 아니므로 추 |  | 2 (G1 `frozenColumns={1}` 하드코딩) |
| WK-SCP0108-0130 | H2 | G2 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 G2 '`_si.Delete()` (신규행 한정)' 의 H2 1요소: ERROR:1 |  | 1 (G2) |
| WK-SCP0108-0131 | H2 | G3 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 G3 '`SetRowFormat(r,c,1,"###,##0.0","",false,columnCol' 의 H2 1요소: ERROR:1 |  | 1 (G3) |
| WK-SCP0108-0132 | H2 | G4 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 G4 '`_si.Query(ds)` + `ds.Tables[1].Copy()`' 의 H2 1요소: ERROR:1 |  | 1 (G4) |
| WK-SCP0108-0133 | H2 | G5 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 G5 '`_si.LockColumn(0, GetMaxColumnIndex(), true)`' 의 H2 1요소: ERROR:1 |  | 1 (G5) |
| WK-SCP0108-0134 | H2 | G6 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 G6 '`SetSheetMerge()` → `RightColMerge2()` (3경로: cs:12' 의 H2 1요소: ERROR:1 |  | 1 (G6) |
| WK-SCP0108-0135 | H2 | SCP0108_CAPA_LOB_Report.CreateSpread | 하네스·환경 | H2 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.CreateSpread 의 H2 1요소: ERROR:1 |  | 4 (ACT:SCP0108_CAPA_LOB_Report.CreateSpread) |
| WK-SCP0108-0136 | H2 | `ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 `ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용 시트" 로 구현 'cs:1131. 소비처는 `SetFilterALLCancel` **한 곳뿐**(`BaseF' 의 H2  |  | 1 (`ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용) |
| WK-SCP0108-0137 | H2 | `capa-lob-report.constants.ts` | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 `capa-lob-report.constants.ts` '`SpdSheet`·`DateColumns`·`ProgressStatusType`(CAPA' 의 H2 1요소: ERROR:1 |  | 1 (`capa-lob-report.constants.ts`) |
| WK-SCP0108-0138 | H2 | `components/CapaLobReportGrid.tsx` | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 `components/CapaLobReportGrid.tsx` '`spdMain` + `RefreshDateColumnStatus`(cs:1351~1396' 의 H2 1요소: ERROR:1 |  | 1 (`components/CapaLobReportGrid.tsx`) |
| WK-SCP0108-0139 | H2 | `hooks/useCapaLobReportConditionEffects. | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 `hooks/useCapaLobReportConditionEffects.ts` '`BeforeFindData`(cs:1312~1319) · `GetSpdTitle`(cs:' 의 H2 1요소: E |  | 1 (`hooks/useCapaLobReportConditionEffects.) |
| WK-SCP0108-0140 | H2 | `spdMain_TopChange` 스크롤 핸들러 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 `spdMain_TopChange` 스크롤 핸들러 'cs:1252~1259' 의 H2 1요소: ERROR:1 |  | 1 (`spdMain_TopChange` 스크롤 핸들러) |
| WK-SCP0108-0141 | H2 | events | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 events '12' 의 H2 1요소: ERROR:1 |  | 1 (events) |
| WK-SCP0108-0142 | H2 | gridSignals | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 gridSignals '6' 의 H2 1요소: ERROR:1 |  | 1 (gridSignals) |
| WK-SCP0108-0143 | H2 | spCalls | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 spCalls '3' 의 H2 1요소: ERROR:1 |  | 1 (spCalls) |
| WK-SCP0108-0144 | H2 | 시트 탭 UI(`TabWrapper`/`TabPanel`) | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 시트 탭 UI(`TabWrapper`/`TabPanel`) '`TabStripPolicy.Never`(cs:1197)' 의 H2 1요소: ERROR:1 |  | 1 (시트 탭 UI(`TabWrapper`/`TabPanel`)) |
| WK-SCP0108-0145 | I1 | SCP0108 화면 | 하네스·환경 | I1 도구 오류 — 원장 V-57353fcb RULE_SCREEN / 원장 V-297a1cf6 RULE_SCREEN / 원장 V-fa27cccd DEFECT / 원장 V-b47bef5e DEFECT / 원장 V-d76239af DEF |  | 10 (validations (1) **Division 권한 0건** (2) *) |
| WK-SCP0108-0146 | D1 | (3) **시트 잠금** | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 (3) **시트 잠금** '`BaseForm:3302~3340`(`CheckValidation`)' 의 D1 1요소: ERROR:1 |  | 1 ((3) **시트 잠금**) |
| WK-SCP0108-0147 | D1 | Edit 버튼(`customButtons`) | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 Edit 버튼(`customButtons`) '`EditButton` override 0건 → 베이스 빈 구현' 의 D1 1요소: ERROR:1 |  | 1 (Edit 버튼(`customButtons`)) |
| WK-SCP0108-0148 | D1 | G5 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 G5 '`_si.LockColumn(0, GetMaxColumnIndex(), true)`' 의 D1 1요소: ERROR:1 |  | 1 (G5) |
| WK-SCP0108-0149 | D1 | _si.LockColumn | 하네스·환경 | D1 도구 오류 — 원장 V-03468942 |  | 1 (ACT:SCP0108_CAPA_LOB_Report.AfterFindDat) |
| WK-SCP0108-0150 | D1 | `LockColumn` 컬럼명 상수 배열 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 `LockColumn` 컬럼명 상수 배열 'cs:1406' 의 D1 1요소: ERROR:1 |  | 1 (`LockColumn` 컬럼명 상수 배열) |
| WK-SCP0108-0151 | D1 | `ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 `ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용 시트" 로 구현 'cs:1131. 소비처는 `SetFilterALLCancel` **한 곳뿐**(`BaseF' 의 D1  |  | 1 (`ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용) |
| WK-SCP0108-0152 | D1 | `isEditMode` state | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 `isEditMode` state '01 L-33. `IsEditMode` true 세팅 경로 0건' 의 D1 1요소: ERROR:1 |  | 1 (`isEditMode` state) |
| WK-SCP0108-0153 | D1 | gridSignals | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 gridSignals '6' 의 D1 1요소: ERROR:1 |  | 1 (gridSignals) |
| WK-SCP0108-0154 | D6 | SCP0108 화면 | 하네스·환경 | D6 도구 오류 — 원장 V-679f3896 RULE_SCREEN / 원장 V-e81ce84d RULE_SCREEN / 원장 V-a97a7393 RULE_SCREEN / 원장 V-edd3b04a GENERAL / 원장 V-f76669 |  | 9 (entryPoints `CapaLobReport.tsx` (1) **Di) |
| WK-SCP0108-0155 | G1 | (1) **Division 권한 0건** | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 (1) **Division 권한 0건** '`cs:1133~1134` → `BaseForm:5269~5277`' 의 G1 3요소: PASS:1 · ERROR:1 · NA:1 |  | 1 ((1) **Division 권한 0건**) |
| WK-SCP0108-0156 | G1 | 1 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 1 'Site/Plant/Building/Line 변경 시 Line Type **후보 목록** ' 의 G1 3요소: PASS:1 · ERROR:1 · NA:1 |  | 0 () |
| WK-SCP0108-0157 | G1 | 6 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 6 'AS-IS 는 콤보 조회 실패와 Division 권한 0건을 구분하지 않는다(동기 로드라 ' 의 G1 3요소: PASS:1 · ERROR:1 · NA:1 |  | 1 (6) |
| WK-SCP0108-0158 | G1 | 7 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 7 'AS-IS 는 컬럼 메타 조회 실패를 별도로 알리지 않는다' 의 G1 3요소: PASS:1 · ERROR:1 · NA:1 |  | 1 (7) |
| WK-SCP0108-0159 | G1 | ADMIN | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 ADMIN 'True' 의 G1 3요소: PASS:1 · ERROR:1 · NA:1 |  | 1 (ADMIN) |
| WK-SCP0108-0160 | G1 | AS-IS 빈 `catch`(`_from_yyyymm` 파싱 실패) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 AS-IS 빈 `catch`(`_from_yyyymm` 파싱 실패) 'cs:291~312' 의 G1 3요소: PASS:1 · ERROR:1 · NA:1 |  | 1 (AS-IS 빈 `catch`(`_from_yyyymm` 파싱 실패)) |
| WK-SCP0108-0161 | G1 | FP Planner | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 FP Planner 'True' 의 G1 3요소: PASS:1 · ERROR:1 · NA:1 |  | 1 (FP Planner) |
| WK-SCP0108-0162 | G1 | FP Viewer | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 FP Viewer 'True' 의 G1 3요소: PASS:1 · ERROR:1 · NA:1 |  | 1 (FP Viewer) |
| WK-SCP0108-0163 | G1 | SCM PI Admin | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 SCM PI Admin 'True' 의 G1 3요소: PASS:1 · ERROR:1 · NA:1 |  | 1 (SCM PI Admin) |
| WK-SCP0108-0164 | G1 | SCM Viewer | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 SCM Viewer 'True' 의 G1 3요소: PASS:1 · ERROR:1 · NA:1 |  | 1 (SCM Viewer) |
| WK-SCP0108-0165 | G1 | SCP Planner | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 SCP Planner 'True' 의 G1 3요소: PASS:1 · ERROR:1 · NA:1 |  | 1 (SCP Planner) |
| WK-SCP0108-0166 | G1 | SCP0108_CAPA_LOB_Report.FindData | 하네스·환경 | G1 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.FindData 의 G1 3요소: PASS:1 · ERROR:1 · NA:1 |  | 1 (ACT:SCP0108_CAPA_LOB_Report.FindData:148) |
| WK-SCP0108-0167 | G1 | SCP0108_CAPA_LOB_Report.FindDataMain | 하네스·환경 | G1 도구 오류 — 진입점 집계 — 대조표 SCP0108_CAPA_LOB_Report.FindDataMain 의 G1 3요소: PASS:1 · ERROR:1 · NA:1 |  | 1 (ACT:SCP0108_CAPA_LOB_Report.FindDataMain) |
| WK-SCP0108-0168 | G1 | `CapaLobReport.tsx` | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 `CapaLobReport.tsx` '`Form_Load`(cs:965~976) · `FindButton`(cs:1267~128' 의 G1 3요소: PASS:1 · ERROR:1 · NA:1 |  | 1 (`CapaLobReport.tsx`) |
| WK-SCP0108-0169 | G1 | `ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 `ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용 시트" 로 구현 'cs:1131. 소비처는 `SetFilterALLCancel` **한 곳뿐**(`BaseF' 의 G1  |  | 1 (`ReadOnlySheetList.Add(CURRENT)` 를 "읽기전용) |
| WK-SCP0108-0170 | G1 | `capa-lob-report.types.ts` | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 `capa-lob-report.types.ts` 'GET SP 반환 형상(03 §4.2/§4.4)' 의 G1 3요소: PASS:1 · ERROR:1 · NA:1 |  | 1 (`capa-lob-report.types.ts`) |
| WK-SCP0108-0171 | G1 | `components/CapaLobReportForm.tsx` | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 `components/CapaLobReportForm.tsx` '`usrConditionPanel1`(dsn:133~141) + LayoutControlI' 의 G1 3요소: PASS:1 · E |  | 1 (`components/CapaLobReportForm.tsx`) |
| WK-SCP0108-0172 | G1 | clbLine / Line | 하네스·환경 | G1 도구 오류 — 원장 V-a1dd972f SEARCH / E2E smoke cond combo |  | 1 (2) |
| WK-SCP0108-0173 | G1 | entryPoints | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 entryPoints '15' 의 G1 3요소: PASS:1 · ERROR:1 · NA:1 |  | 1 (entryPoints) |
| WK-SCP0108-0174 | G1 | validations | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 validations '1' 의 G1 3요소: PASS:1 · ERROR:1 · NA:1 |  | 1 (validations) |
| WK-SCP0108-0175 | G1 | 필수 조회조건 UI(`*`) · Search 전 alert | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 필수 조회조건 UI(`*`) · Search 전 alert '`DataUtil.InitCheck`(DataUtil:370~622) 전문 read' 의 G1 3요소: PASS:1 · ERROR:1 |  | 1 (필수 조회조건 UI(`*`) · Search 전 alert) |
| WK-SCP0108-0176 | X-ROW | SCP0108_CAPA_LOB_Report.AfterFindData | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOPATH:1 · ERROR:1 |  | 10 (ACT:SCP0108_CAPA_LOB_Report.AfterFindDat) |
| WK-SCP0108-0177 | X-ROW | SCP0108_CAPA_LOB_Report.CreateSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · NA:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.CreateSpread) |
| WK-SCP0108-0178 | X-ROW | SCP0108_CAPA_LOB_Report.FindButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 8검사 — NA:4 · NOT_RUN:2 · NOPATH:1 · ERROR:1 |  | 2 (ACT:SCP0108_CAPA_LOB_Report.FindButton A) |
| WK-SCP0108-0179 | X-ROW | SCP0108_CAPA_LOB_Report.RefreshVersionSe | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NA:1 · ERROR:1 |  | 4 (ACT:SCP0108_CAPA_LOB_Report.RefreshVersi) |
| WK-SCP0108-0180 | X-ROW | SCP0108_CAPA_LOB_Report.SetQueryInfoGet | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 6 (ACT:SCP0108_CAPA_LOB_Report.SetQueryInfo) |
| WK-SCP0108-0181 | X-ROW | SCP0108_CAPA_LOB_Report.SetSheetMerge | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.SetSheetMerg) |
| WK-SCP0108-0182 | X-ROW | SCP0108_CAPA_LOB_Report.SetVisibleElectr | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0108_CAPA_LOB_Report.SetVisibleEl) |
| WK-SCP0108-0183 | X-ROW | SCP0108_CAPA_LOB_Report.SetVisibleOperat | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 3 (ACT:SCP0108_CAPA_LOB_Report.SetVisibleOp) |
| WK-SCP0108-0184 | X-ROW | SCP0108_CAPA_LOB_Report.SetVisibleSheetC | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · NA:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.SetVisibleSh) |
| WK-SCP0108-0185 | X-ROW | SCP0108_CAPA_LOB_Report.btnColumn_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 7검사 — NA:3 · PASS:2 · ERROR:2 |  | 3 (ACT:SCP0108_CAPA_LOB_Report.btnColumn_Cl) |
| WK-SCP0108-0186 | X-ROW | SCP0108_CAPA_LOB_Report.btnItem_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — PASS:1 · ERROR:1 |  | 1 (ACT:SCP0108_CAPA_LOB_Report.btnItem_Clic) |
| WK-SCP0108-0187 | X-ROW | SCP0108_CAPA_LOB_Report.cboDivision_Sele | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.cboDivision_) |
| WK-SCP0108-0188 | X-ROW | SCP0108_CAPA_LOB_Report.cboVersionSeq_Se | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.cboVersionSe) |
| WK-SCP0108-0189 | X-ROW | SCP0108_CAPA_LOB_Report.cboVersion_Selec | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.cboVersion_S) |
| WK-SCP0108-0190 | X-ROW | SCP0108_CAPA_LOB_Report.clbFactory_Selec | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.clbFactory_S) |
| WK-SCP0108-0191 | X-ROW | SCP0108_CAPA_LOB_Report.clbLine_Selected | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.clbLine_Sele) |
| WK-SCP0108-0192 | X-ROW | SCP0108_CAPA_LOB_Report.clbOperation_Sel | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.clbOperation) |
| WK-SCP0108-0193 | X-ROW | SCP0108_CAPA_LOB_Report.clbPlant_Selecte | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.clbPlant_Sel) |
| WK-SCP0108-0194 | X-ROW | SCP0108_CAPA_LOB_Report.clbSite_Selected | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.clbSite_Sele) |
| WK-SCP0108-0195 | X-ROW | SCP0108_CAPA_LOB_Report.rgrpDivisionType | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:3 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0108_CAPA_LOB_Report.rgrpDivision) |
| WK-SCP0108-0196 | M3 | new SCM002_CAPAColumnPopup("SCP0108", th | 하네스·환경 | M3 도구 오류 — 원장 V-7d095d23 |  | 1 (ACT:SCP0108_CAPA_LOB_Report.btnColumn_Cl) |
| WK-SCP0108-0197 | M4 | `components/modals/CapaLobReportItemPopu | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 `components/modals/CapaLobReportItemPopup.tsx` '`ShowItem`(cs:1580~1602) → `SCM0002_CAPAItemPopup`' 의 M4 3요소 |  | 1 (`components/modals/CapaLobReportItemPopu) |
| WK-SCP0108-0198 | M4 | entryPoints | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 entryPoints '15' 의 M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (entryPoints) |
| WK-SCP0108-0199 | M4 | popups | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 popups '2' 의 M4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (popups) |
