# 작업 원장 — DMF0042 · 2026-11-17 15:12

> 검사 인스턴스 2338건 중 PASS·NA 398건 외 **1940건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W3 | 동작 수정 | 23 | 재판정 PASS |
| W5 | 검사기 연결 | 27 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 241 | 실행 → PASS |
| W7 | 기대값 확정 | 90 | 기대 확정 → PASS/FAIL |
| W9 | 도구 오류 | 1559 | 원인 해소 → 재판정 |

- 담당: 하네스·환경 1559 · E2E 241 · 사람 판정 / AS-IS 원문 확인 → 재판정 90 · 하네스 27 · FE 13 · DB 10
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 6건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| D3 | EDIT |  |  |  |  |  | 13 |  |  | 358 | 행 값 기반 조건부 잠금 |
| X-ROW | GEN |  |  | 12 |  |  |  | 6 |  | 293 | 대조표 행이 서술한 동작을 화면에서 재현 |
| C6 | CASCADE |  |  |  |  |  | 7 |  |  | 180 | 무변경 편집 종료 시 연쇄 미발동 |
| H6 | POPUP |  |  |  |  | 1 | 4 |  |  | 149 | 팝업 표준·열림 |
| E4 | EDIT |  |  |  |  |  | 19 |  |  | 113 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| C2 | CASCADE |  |  |  |  |  | 11 |  |  | 74 | 그리드 셀 cascade 후보 |
| M3 | POPUP |  |  |  |  |  | 2 |  |  | 58 | 팝업 내부 기능(조회·CRUD) · 팝업 목록 행수(조회조건 변경 후 포함) |
| C3 | CASCADE |  |  |  |  |  | 18 |  |  | 37 | 연쇄 자동 채움 |
| G1 | GEN |  |  |  |  |  | 2 |  |  | 52 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| M4 | POPUP |  |  |  |  |  | 49 |  |  | 3 | 팝업 선택값 반영 |
| F4 | DB |  |  |  |  |  | 14 |  |  | 35 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| D1 | EDIT |  |  |  |  |  |  |  |  | 45 | 컬럼 편집 가능 여부(신규행·기존행) |
| A1 | GEN |  |  |  |  |  |  | 44 |  |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| X-LOC | GEN |  |  |  |  |  |  | 39 |  |  | 대조표 상태 구현 행의 구현 위치(파일:라인)가 TO-BE 소스에 실존 |
| H2 | DESIGN |  |  |  |  |  | 9 |  |  | 29 | 배경·글자색 규칙 |
| G5 | POPUP |  |  |  |  | 3 |  |  |  | 30 | 팝업 조건 연동(인자) |
| D5 | EDIT |  |  |  |  |  | 17 |  |  | 9 | 셀 에디터 유형 |
| A5 | DESIGN |  |  |  |  |  | 17 |  |  | 8 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| B4 | COMBO |  |  |  |  | 4 |  |  |  | 20 | 콤보 후보 집합 = AS-IS 원천+필터(같은 데이터에 AS-IS 논리 적용) |
| G4 | DESIGN |  |  |  |  | 6 | 17 |  |  |  | 조회조건 표시·라벨·활성 |
| H5 | DESIGN |  |  |  |  |  | 14 |  |  | 9 | 라벨 명칭 |
| G6 | GEN |  |  |  |  |  | 16 |  |  | 1 | 조회조건 초기 기본값 = AS-IS Form_Load |
| B3 | COMBO |  |  |  |  | 1 |  |  |  | 15 | 콤보 후보 정렬 = AS-IS |
| C1 | CASCADE |  |  |  |  |  | 8 |  |  | 6 | 상위 조회조건 변경 → 하위 후보 재조회·선택 초기화 |
| A6 | GEN |  |  | 11 |  |  |  |  |  | 1 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| B1 | COMBO |  |  |  |  | 4 |  |  |  | 8 | 콤보 후보 빈 행 없음 |
| B2 | COMBO |  |  |  |  | 4 |  |  |  | 8 | 콤보 후보 중복 없음 |
| D4 | EDIT |  |  |  |  |  | 3 |  |  | 2 | 신규행 기본값·자동세팅·Insert 전제 |
| DB-SYN | DB |  |  |  |  | 4 |  |  |  |  | BE 계정 시노님·권한·대상 객체 |
| E5 | EDIT |  |  |  |  |  |  |  |  | 3 | 콤보 셀 후보 외 값 차단 |
| X-REOPEN | GEN |  |  |  |  |  | 1 |  |  |  | 화면 닫기·재오픈 시 오류·잔존 상태 없음 |
| G03-WIRE | GEN |  |  |  |  |  |  | 1 |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| J2 | AUTH |  |  |  |  |  |  |  |  | 1 | 권한별 버튼·기능 |
| K4 | COMMON |  |  |  |  |  |  |  |  | 1 | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 DB 반영(마커 행) |
| F2 | CRUD |  |  |  |  |  |  |  |  | 1 | 1회 저장(변경 감지) |
| F3 | CRUD |  |  |  |  |  |  |  |  | 1 | 붙여넣기 경로 → 값·검증·연쇄·저장 |
| F5 | CRUD |  |  |  |  |  |  |  |  | 1 | CRUD Status 표시 정합 |
| F6 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 값 보존 |
| H10 | DESIGN |  |  |  |  |  |  |  |  | 1 | 메시지 표준(방식·코드 단일화) |
| H4 | DESIGN |  |  |  |  |  |  |  |  | 1 | 레이아웃·스크롤·크기 |
| I1 | DESIGN |  |  |  |  |  |  |  |  | 1 | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  |  |  |  | 1 | 조회조건 순서 = 기준표 |
| D6 | EDIT |  |  |  |  |  |  |  |  | 1 | Insert 위치·상태 유지 |
| A10 | GEN |  |  |  |  |  |  |  |  | 1 | 조회 전 그리드 초기 상태(빈 그리드·헤더) = AS-IS |

## W3 동작 수정 (23)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0042-0001 | A6 | 20 | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — 20: 행 집계 — 대조표 20 'FindButton → FindData (L684~799)' 의 A6 5요소: NA:2 · FAIL:1 · PASS:1 · ERROR:1 · FAIL 요소: PKG_DMF004 |  | 1 (20) |
| WK-DMF0042-0002 | A6 | 25 | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — 25: 행 집계 — 대조표 25 'btnSetPrice_Click (L3115~3136)' 의 A6 5요소: NA:2 · FAIL:1 · PASS:1 · ERROR:1 · FAIL 요소: PKG_DMF0042. |  | 1 (25) |
| WK-DMF0042-0003 | A6 | 9 | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — 9: 행 집계 — 대조표 9 'btnProject_Click (L2762~2782)' 의 A6 5요소: NA:2 · FAIL:1 · PASS:1 · ERROR:1 · FAIL 요소: PKG_DMF0042.P_D |  | 0 () |
| WK-DMF0042-0004 | A6 | DMF0042_1_RTF.FindData | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — DMF0042_1_RTF.FindData: 진입점 집계 — 대조표 DMF0042_1_RTF.FindData 의 A6 5요소: NA:2 · FAIL:1 · PASS:1 · ERROR:1 · FAIL 요소: PKG |  | 1 (ACT:DMF0042_1_RTF.FindData) |
| WK-DMF0042-0005 | A6 | DMF0042_1_RTF.FindDataMain | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — DMF0042_1_RTF.FindDataMain: 진입점 집계 — 대조표 DMF0042_1_RTF.FindDataMain 의 A6 5요소: NA:2 · FAIL:1 · PASS:1 · ERROR:1 · FAIL |  | 1 (ACT:DMF0042_1_RTF.FindDataMain) |
| WK-DMF0042-0006 | A6 | DMF0042_2_BizPlan.FindButton | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — DMF0042_2_BizPlan.FindButton: 진입점 집계 — 대조표 DMF0042_2_BizPlan.FindButton 의 A6 5요소: NA:2 · FAIL:1 · PASS:1 · ERROR:1 ·  |  | 2 (ACT:DMF0042_2_BizPlan.FindButton ACT:DMF) |
| WK-DMF0042-0007 | A6 | DMF0042_2_BizPlan.FindData | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — DMF0042_2_BizPlan.FindData: 진입점 집계 — 대조표 DMF0042_2_BizPlan.FindData 의 A6 5요소: NA:2 · FAIL:1 · PASS:1 · ERROR:1 · FAIL |  | 34 (ACT:DMF0042_2_BizPlan.FindData ACT:DMF00) |
| WK-DMF0042-0008 | A6 | DMF0042_3_BizPlan.FindButton | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — DMF0042_3_BizPlan.FindButton: 진입점 집계 — 대조표 DMF0042_3_BizPlan.FindButton 의 A6 5요소: NA:2 · FAIL:1 · PASS:1 · ERROR:1 ·  |  | 1 (ACT:DMF0042_3_BizPlan.FindButton) |
| WK-DMF0042-0009 | A6 | DMF0042_3_BizPlan.FindData | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — DMF0042_3_BizPlan.FindData: 진입점 집계 — 대조표 DMF0042_3_BizPlan.FindData 의 A6 5요소: NA:2 · FAIL:1 · PASS:1 · ERROR:1 · FAIL |  | 1 (ACT:DMF0042_3_BizPlan.FindData) |
| WK-DMF0042-0010 | A6 | Division 분기 33 (사업부분기 전수) | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — Division 분기 33 (사업부분기 전수): 행 집계 — 대조표 Division 분기 33 (사업부분기 전수) 'InitControls(3)/EditButton(4)/FindData(1)/InsertRo'  |  | 1 (Division 분기 33 (사업부분기 전수)) |
| WK-DMF0042-0011 | A6 | PKG_DMF0042.P_DMF0042_GET_DM_PLN_BUSINES | FE(repairScope=DB_ONLY — 이번 범위 밖) | A6 FAIL 수정 — PKG_DMF0042.P_DMF0042_GET_DM_PLN_BUSINESS_PLAN_DATA: 원장 V-9d782ebf SP / 원장 V-88a4c378 SP / 원장 V-163776c3 SP / 원장 V-ff |  | 192 (ACT:DMF0042_1_BizPlan.FindButton ACT:DMF) |
| WK-DMF0042-0012 | X-ROW | DMF0042_1_BizPlan.FindButton | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.FindButton: 진입점 집계 4검사 — ERROR:1 · REVIEW:1 · FAIL:1 · NOT_RUN:1 |  | 2 (ACT:DMF0042_1_BizPlan.FindButton ACT:DMF) |
| WK-DMF0042-0013 | X-ROW | DMF0042_1_BizPlan.FindData | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_BizPlan.FindData: 진입점 집계 29검사 — ERROR:16 · NOT_RUN:8 · NA:2 · REVIEW:1 · FAIL:1 · PASS:1 |  | 64 (ACT:DMF0042_1_BizPlan.FindData:686:1 ACT) |
| WK-DMF0042-0014 | X-ROW | DMF0042_1_RTF.FindData | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_RTF.FindData: 진입점 집계 7검사 — NOT_RUN:2 · NA:2 · REVIEW:1 · FAIL:1 · ERROR:1 |  | 15 (ACT:DMF0042_1_RTF.FindData ACT:DMF0042_1) |
| WK-DMF0042-0015 | X-ROW | DMF0042_1_RTF.FindDataMain | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_1_RTF.FindDataMain: 진입점 집계 4검사 — NOT_RUN:1 · REVIEW:1 · FAIL:1 · ERROR:1 |  | 6 (ACT:DMF0042_1_RTF.FindDataMain ACT:DMF00) |
| WK-DMF0042-0016 | X-ROW | DMF0042_2_BizPlan.FindButton | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_2_BizPlan.FindButton: 진입점 집계 4검사 — ERROR:2 · REVIEW:1 · FAIL:1 |  | 1 (ACT:DMF0042_2_BizPlan.FindButton) |
| WK-DMF0042-0017 | X-ROW | DMF0042_2_BizPlan.FindData | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_2_BizPlan.FindData: 진입점 집계 30검사 — ERROR:17 · NOT_RUN:7 · NA:4 · REVIEW:1 · FAIL:1 |  | 10 (ACT:DMF0042_2_BizPlan.FindData:651:2 ACT) |
| WK-DMF0042-0018 | X-ROW | DMF0042_3_BizPlan.FindButton | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.FindButton: 진입점 집계 4검사 — ERROR:2 · REVIEW:1 · FAIL:1 |  | 2 (ACT:DMF0042_3_BizPlan.FindButton ACT:DMF) |
| WK-DMF0042-0019 | X-ROW | DMF0042_3_BizPlan.FindData | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_3_BizPlan.FindData: 진입점 집계 29검사 — ERROR:17 · NOT_RUN:7 · NA:3 · REVIEW:1 · FAIL:1 |  | 64 (ACT:DMF0042_3_BizPlan.FindData:712:1 ACT) |
| WK-DMF0042-0020 | X-ROW | DMF0042_BizPlan.FindButton | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.FindButton: 진입점 집계 7검사 — REVIEW:2 · NOT_RUN:2 · FAIL:1 · PASS:1 · ERROR:1 |  | 2 (ACT:DMF0042_BizPlan.FindButton ACT:DMF00) |
| WK-DMF0042-0021 | X-ROW | DMF0042_BizPlan.FindData | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan.FindData: 진입점 집계 33검사 — ERROR:16 · NOT_RUN:9 · PASS:3 · REVIEW:2 · NA:2 · FAIL:1 |  | 64 (ACT:DMF0042_BizPlan.FindData:747:1 ACT:D) |
| WK-DMF0042-0022 | X-ROW | DMF0042_BizPlan_old.FindButton | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.FindButton: 진입점 집계 8검사 — REVIEW:2 · NOT_RUN:2 · ERROR:2 · FAIL:1 · PASS:1 |  | 2 (ACT:DMF0042_BizPlan_old.FindButton ACT:D) |
| WK-DMF0042-0023 | X-ROW | DMF0042_BizPlan_old.FindData | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — DMF0042_BizPlan_old.FindData: 진입점 집계 33검사 — ERROR:16 · NOT_RUN:9 · PASS:3 · REVIEW:2 · NA:2 · FAIL:1 |  | 55 (ACT:DMF0042_BizPlan_old.FindData:584:1 A) |

## W5 검사기 연결 (27)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0042-0024 | B1 | BIZ_TYPE_NAME81 / Biz.Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL BIZ_TYPE_NAME81 / Biz.Type | 있음(SHEET_COLUMNS) | 3 (ACT:DMF0042_1_BizPlan.InsertRow:1210:41 ) |
| WK-DMF0042-0025 | B1 | DEPT_NAME_KO | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL DEPT_NAME_KO | 있음(SHEET_COLUMNS) | 1 (ACT:DMF0042_2_BizPlan.InsertRow:1348:20) |
| WK-DMF0042-0026 | B1 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 3 (ACT:DMF0042_2_BizPlan.InsertRow:1352:24 ) |
| WK-DMF0042-0027 | B1 | SCM_SITE_ID82 / Sales Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B1(_verify.spec(@verify)) → 대상 COL SCM_SITE_ID82 / Sales Site | 있음(SHEET_COLUMNS) | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1206:37 ) |
| WK-DMF0042-0028 | B2 | BIZ_TYPE_NAME81 / Biz.Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL BIZ_TYPE_NAME81 / Biz.Type | 있음(SHEET_COLUMNS) | 3 (ACT:DMF0042_1_BizPlan.InsertRow:1210:41 ) |
| WK-DMF0042-0029 | B2 | DEPT_NAME_KO | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL DEPT_NAME_KO | 있음(SHEET_COLUMNS) | 1 (ACT:DMF0042_2_BizPlan.InsertRow:1348:20) |
| WK-DMF0042-0030 | B2 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 3 (ACT:DMF0042_2_BizPlan.InsertRow:1352:24 ) |
| WK-DMF0042-0031 | B2 | SCM_SITE_ID82 / Sales Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B2(_verify.spec(@verify)) → 대상 COL SCM_SITE_ID82 / Sales Site | 있음(SHEET_COLUMNS) | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1206:37 ) |
| WK-DMF0042-0032 | B3 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B3(combo_oracle order_check — AS-IS ORDER B) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 1 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0033 | B4 | BIZ_TYPE_NAME81 / Biz.Type | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL BIZ_TYPE_NAME81 / Biz.Type | 있음(SHEET_COLUMNS) | 3 (ACT:DMF0042_1_BizPlan.InsertRow:1210:41 ) |
| WK-DMF0042-0034 | B4 | DEPT_NAME_KO | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL DEPT_NAME_KO | 있음(SHEET_COLUMNS) | 1 (ACT:DMF0042_2_BizPlan.InsertRow:1348:20) |
| WK-DMF0042-0035 | B4 | SCM_SITE_ID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL SCM_SITE_ID | 있음(SHEET_COLUMNS) | 4 (ACT:DMF0042_2_BizPlan.InsertRow:1352:24 ) |
| WK-DMF0042-0036 | B4 | SCM_SITE_ID82 / Sales Site | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 B4(combo_oracle.py(W1)) → 대상 COL SCM_SITE_ID82 / Sales Site | 있음(SHEET_COLUMNS) | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1206:37 ) |
| WK-DMF0042-0037 | DB-SYN | DMF0009_GET_CODE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DMF0009_GET_CODE | 없음(PROC_M 대응 없음) | 2 (ACT:DMF0042_3_BizPlan.GetComboData:2951:) |
| WK-DMF0042-0038 | DB-SYN | DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE | 없음(PROC_M 대응 없음) | 4 (ACT:DMF0042_ExchangeRatePopup.FindData:4) |
| WK-DMF0042-0039 | DB-SYN | SCM0001_GET_BIZ_TYPE_BY_DIVISION | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_BIZ_TYPE_BY_DIVISION | 없음(PROC_M 대응 없음) | 10 (ACT:DMF0042_1_BizPlan.GetBizTypebyDivisi) |
| WK-DMF0042-0040 | DB-SYN | SCM0001_GET_LOOKUP_VALUES | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCM0001_GET_LOOKUP_VALUES | 없음(PROC_M 대응 없음) | 10 (ACT:DMF0042_1_BizPlan.GetLookupData:2907) |
| WK-DMF0042-0041 | G4 | btnColumn | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnColumn | 있음(FE 소스) | 5 (ACT:DMF0042_1_BizPlan.InitControls:314:4) |
| WK-DMF0042-0042 | G4 | btnCutOff | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnCutOff | 있음(FE 소스) | 30 (ACT:DMF0042_1_BizPlan.DefineProperty ACT) |
| WK-DMF0042-0043 | G4 | btnItemId | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnItemId | 없음 | 0 () |
| WK-DMF0042-0044 | G4 | btnMeasure | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnMeasure | 있음(FE 소스) | 5 (ACT:DMF0042_1_BizPlan.InitControls:315:4) |
| WK-DMF0042-0045 | G4 | btnOwner | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnOwner | 없음 | 0 () |
| WK-DMF0042-0046 | G4 | btnProject | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnProject | 있음(FE 소스) | 20 (ACT:DMF0042_1_BizPlan.InitControls ACT:D) |
| WK-DMF0042-0047 | G5 | BIZ_TYPE_NAME82 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 PCOL BIZ_TYPE_NAME82 | 판단불가(대상 단위 PCOL) | 8 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0048 | G5 | clbDivision / Division | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COND clbDivision / Division | 있음(FE 소스) | 20 (ACT:DMF0042_1_BizPlan.btnColumn_Click:28) |
| WK-DMF0042-0049 | G5 | txtItemId / Model / Item Id | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COND txtItemId / Model / Item Id | 있음(FE 소스) | 1 (10) |
| WK-DMF0042-0050 | H6 | BIZ_TYPE_NAME82 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 PCOL BIZ_TYPE_NAME82 | 판단불가(대상 단위 PCOL) | 8 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |

## W6 검증 실행 (241)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0042-0051 | C1 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 10 (ACT:DMF0042_1_BizPlan.InitControls:306:4) |
| WK-DMF0042-0052 | C1 | cboClosed / Closed | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — cboClosed / Closed · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 4 (ACT:DMF0042_1_BizPlan.InitControls:244:8) |
| WK-DMF0042-0053 | C1 | clbBizType / Biz Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbBizType / Biz Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 30 (ACT:DMF0042_1_BizPlan.InitControls:255:1) |
| WK-DMF0042-0054 | C1 | clbCustomer / End Customer / Customer | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbCustomer / End Customer / Customer · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 20 (ACT:DMF0042_1_BizPlan.InitControls:295:3) |
| WK-DMF0042-0055 | C1 | clbItemType / Item Type | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbItemType / Item Type · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 10 (ACT:DMF0042_1_BizPlan.InitControls:311:4) |
| WK-DMF0042-0056 | C1 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 10 (ACT:DMF0042_1_BizPlan.InitControls:303:4) |
| WK-DMF0042-0057 | C1 | clbSalesSite / Sales Site | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbSalesSite / Sales Site · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 20 (ACT:DMF0042_1_BizPlan.InitControls:299:3) |
| WK-DMF0042-0058 | C1 | clbTeam / Team | E2E(검증 엔진 @trace 재실행(run_verify)) | C1 실행 — clbTeam / Team · 검사기 있음(_trace.spec(@trace) 상위 변경→하위 후보) — 실행 필요: trace |  | 10 (ACT:DMF0042_1_BizPlan.InitControls:241:6) |
| WK-DMF0042-0059 | C2 | CITY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — CITY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0060 | C2 | COUNTRY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — COUNTRY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0061 | C2 | DEMAND_OPERATION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — DEMAND_OPERATION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 18 (ACT:DMF0042_1_RTF.spdMain_ComboCloseUp A) |
| WK-DMF0042-0062 | C2 | IMPUTATION_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — IMPUTATION_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 33 (ACT:DMF0042_1_RTF.spdMain_ComboCloseUp:1) |
| WK-DMF0042-0063 | C2 | MEASURE / Measure | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — MEASURE / Measure · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 38 (ACT:DMF0042_1_BizPlan.spdMain_Changed AC) |
| WK-DMF0042-0064 | C2 | SHIPTO_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — SHIPTO_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0065 | C2 | SHIPTO_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — SHIPTO_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0066 | C2 | SOLDTO_CODE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — SOLDTO_CODE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0067 | C2 | SOLDTO_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — SOLDTO_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0068 | C2 | UNIT_ENERGY / Energy | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — UNIT_ENERGY / Energy · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 18 (ACT:DMF0042_1_BizPlan.spdMain_Changed:18) |
| WK-DMF0042-0069 | C2 | VARIATION_FACTOR | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C2 실행 — VARIATION_FACTOR · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:DMF0042_1_RTF.spdMain_ComboCloseUp A) |
| WK-DMF0042-0070 | C3 | BIZ_TYPE | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — BIZ_TYPE · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0071 | C3 | BIZ_TYPE_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — BIZ_TYPE_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0072 | C3 | BIZ_TYPE_NAME81 / Biz.Type | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — BIZ_TYPE_NAME81 / Biz.Type · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 4 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0073 | C3 | BIZ_UNIT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — BIZ_UNIT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0074 | C3 | CELL_PER_MODULE / Cell/Module | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — CELL_PER_MODULE / Cell/Module · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0075 | C3 | CELL_PER_PACK / Cell/Pack | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — CELL_PER_PACK / Cell/Pack · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0076 | C3 | COLUMN_LABEL_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — COLUMN_LABEL_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 19 (ACT:DMF0042_1_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-0077 | C3 | COLUMN_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — COLUMN_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 41 (ACT:DMF0042_1_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-0078 | C3 | COMPANY_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — COMPANY_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0079 | C3 | DIVISION_ID / Division | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — DIVISION_ID / Division · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 7 (ACT:DMF0042_1_BizPlan.InsertRow:1222:46 ) |
| WK-DMF0042-0080 | C3 | LARGE_CLASS_LABEL_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — LARGE_CLASS_LABEL_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 22 (ACT:DMF0042_1_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-0081 | C3 | MODULE_PER_PACK / Module/Pack | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — MODULE_PER_PACK / Module/Pack · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 2 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0082 | C3 | PRODUCT_GROUP | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PRODUCT_GROUP · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0083 | C3 | PRODUCT_GROUP_NAME / Product Group Name | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PRODUCT_GROUP_NAME / Product Group Name · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trac |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0084 | C3 | PROJECT_CODE / Project Code | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PROJECT_CODE / Project Code · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 24 (ACT:DMF0042_1_BizPlan.InsertRow:1176:12 ) |
| WK-DMF0042-0085 | C3 | PROJECT_CODE82 / Project Code | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PROJECT_CODE82 / Project Code · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 16 (ACT:DMF0042_1_BizPlan.InsertRow:1178:14 ) |
| WK-DMF0042-0086 | C3 | PROJECT_NAME / Project | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — PROJECT_NAME / Project · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 16 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0087 | C3 | SMALL_CLASS_LABEL_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C3 실행 — SMALL_CLASS_LABEL_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace |  | 30 (ACT:DMF0042_1_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-0088 | C6 | DEMAND_OPERATION | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — DEMAND_OPERATION · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 18 (ACT:DMF0042_1_RTF.spdMain_ComboCloseUp A) |
| WK-DMF0042-0089 | C6 | DEPT_ID40 / Team | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — DEPT_ID40 / Team · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 34 (16 ACT:DMF0042_1_BizPlan.spdMain_ComboSe) |
| WK-DMF0042-0090 | C6 | DIVISION_ID / Division | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — DIVISION_ID / Division · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:DMF0042_BizPlan_old.spdMain_ComboSel) |
| WK-DMF0042-0091 | C6 | END_CUSTOMER40 / End Customer | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — END_CUSTOMER40 / End Customer · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 49 (16 ACT:DMF0042_1_BizPlan.spdMain_ComboSe) |
| WK-DMF0042-0092 | C6 | IMPUTATION_YN | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — IMPUTATION_YN · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 33 (ACT:DMF0042_1_RTF.spdMain_ComboCloseUp:1) |
| WK-DMF0042-0093 | C6 | SCM_SITE_ID40 / Sales Site | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — SCM_SITE_ID40 / Sales Site · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 10 (16 ACT:DMF0042_1_BizPlan.spdMain_ComboSe) |
| WK-DMF0042-0094 | C6 | VARIATION_FACTOR | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | C6 실행 — VARIATION_FACTOR · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:DMF0042_1_RTF.spdMain_ComboCloseUp A) |
| WK-DMF0042-0095 | F4 | DMF0009_GET_CODE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DMF0009_GET_CODE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 2 (ACT:DMF0042_3_BizPlan.GetComboData:2951:) |
| WK-DMF0042-0096 | F4 | DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요:  |  | 129 (ACT:DMF0042_ExchangeRatePopup.FindButton) |
| WK-DMF0042-0097 | F4 | PKG_DMF0003.P_DMF0003_GET_DM_ANL_MKT_PSI | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0003.P_DMF0003_GET_DM_ANL_MKT_PSI_DPINIT · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — |  | 3 (ACT:DMF0042_1_RTF.Select_DpInit_Data:103) |
| WK-DMF0042-0098 | F4 | PKG_DMF0003.P_DMF0003_GET_DM_ANL_MKT_PSI | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0003.P_DMF0003_GET_DM_ANL_MKT_PSI_DPRESULT · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) |  | 3 (ACT:DMF0042_1_RTF.Select_DpResult_Data:1) |
| WK-DMF0042-0099 | F4 | PKG_DMF0042.P_DMF0042_GET_DM_PLN_BUSINES | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0042.P_DMF0042_GET_DM_PLN_BUSINESS_PLAN_DAT · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 730 (ACT:DMF0042_1_BizPlan.FindButton ACT:DMF) |
| WK-DMF0042-0100 | F4 | PKG_DMF0042.P_DMF0042_GET_EXCHANGE_PRICE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0042.P_DMF0042_GET_EXCHANGE_PRICE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: |  | 10 (ACT:DMF0042_1_BizPlan.GetFuturePriceInfo) |
| WK-DMF0042-0101 | F4 | PKG_DMF0042.P_DMF0042_GET_SCM_MST_FUTURE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0042.P_DMF0042_GET_SCM_MST_FUTURE_PRICE_POP · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 129 (ACT:DMF0042_ExchangeRatePopup.FindButton) |
| WK-DMF0042-0102 | F4 | PKG_DMF0042.P_DMF0042_GET_SCM_MST_FUTURE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0042.P_DMF0042_GET_SCM_MST_FUTURE_PRICE_POP · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 129 (ACT:DMF0042_ExchangeRatePopup.FindButton) |
| WK-DMF0042-0103 | F4 | PKG_DMF0042.P_DMF0042_GET_SPREAD_TITLE | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0042.P_DMF0042_GET_SPREAD_TITLE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: s |  | 480 (ACT:DMF0042_BizPlan.FindButton ACT:DMF00) |
| WK-DMF0042-0104 | F4 | PKG_DMF0042.P_DMF0042_SAVE_DM_BP_EXCHANG | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0042.P_DMF0042_SAVE_DM_BP_EXCHANGE_RATE · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) —  |  | 89 (ACT:DMF0042_ExchangeRatePopup.SaveButton) |
| WK-DMF0042-0105 | F4 | PKG_DMF0042.P_DMF0042_SAVE_DM_PLN_BP_FCS | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0042.P_DMF0042_SAVE_DM_PLN_BP_FCST · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요 |  | 728 (ACT:DMF0042_1_BizPlan.SaveButton ACT:DMF) |
| WK-DMF0042-0106 | F4 | PKG_DMF0042.P_DMF0042_SAVE_DM_PLN_BP_FCS | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — PKG_DMF0042.P_DMF0042_SAVE_DM_PLN_BP_FCST_PRICE_CO · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP) |  | 8 (ACT:DMF0042_1_BizPlan.btnSetPrice_Click:) |
| WK-DMF0042-0107 | F4 | SCM0001_GET_BIZ_TYPE_BY_DIVISION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_BIZ_TYPE_BY_DIVISION · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·t |  | 10 (ACT:DMF0042_1_BizPlan.GetBizTypebyDivisi) |
| WK-DMF0042-0108 | F4 | SCM0001_GET_LOOKUP_VALUES | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | F4 실행 — SCM0001_GET_LOOKUP_VALUES · 검사기 있음(smoke calls·dberr·_verify · _trace.spec(@trace) W5(SP 호출 HTTP)) — 실행 필요: smoke·trace |  | 10 (ACT:DMF0042_1_BizPlan.GetLookupData:2907) |
| WK-DMF0042-0109 | A5 | CELL_PROD_SITE / Cell Prod Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — CELL_PROD_SITE / Cell Prod Site · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_ef |  | 4 (ACT:DMF0042_BizPlan.InitSpread ACT:DMF00) |
| WK-DMF0042-0110 | A5 | COLUMN_LABEL_NAME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — COLUMN_LABEL_NAME · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 21 (ACT:DMF0042_1_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-0111 | A5 | COLUMN_NAME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — COLUMN_NAME · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 41 (ACT:DMF0042_1_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-0112 | A5 | CURRENCY / Currency | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — CURRENCY / Currency · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:DMF0042_ExchangeRatePopup.InitSpread) |
| WK-DMF0042-0113 | A5 | CURRENCY_UNITCURRENCY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — CURRENCY_UNITCURRENCY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Di |  | 4 (ACT:DMF0042_ExchangeRatePopup.InitSpread) |
| WK-DMF0042-0114 | A5 | DEMAND_OPERATION | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DEMAND_OPERATION · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 18 (ACT:DMF0042_1_RTF.spdMain_CellClick:931:) |
| WK-DMF0042-0115 | A5 | DIVISION_ID / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — DIVISION_ID / Division · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective D |  | 4 (ACT:DMF0042_1_RTF.InitSpread ACT:DMF0042) |
| WK-DMF0042-0116 | A5 | EXT_INT | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — EXT_INT · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 2 (ACT:DMF0042_1_RTF.InitSpread ACT:DMF0042) |
| WK-DMF0042-0117 | A5 | IMPUTATION_YN | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — IMPUTATION_YN · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 12 (ACT:DMF0042_1_RTF.spdMain_ComboCloseUp:1) |
| WK-DMF0042-0118 | A5 | ITEM_ID / Model | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ITEM_ID / Model · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 7 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0119 | A5 | ITEM_ID40 / Model | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — ITEM_ID40 / Model · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 4 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0120 | A5 | LARGE_CLASS_LABEL_NAME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — LARGE_CLASS_LABEL_NAME · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective D |  | 24 (ACT:DMF0042_1_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-0121 | A5 | PROJECT_CODE / Project Code | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PROJECT_CODE / Project Code · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effect |  | 7 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0122 | A5 | PROJECT_CODE82 / Project Code | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — PROJECT_CODE82 / Project Code · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effe |  | 4 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0123 | A5 | SMALL_CLASS_LABEL_NAME | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — SMALL_CLASS_LABEL_NAME · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective D |  | 32 (ACT:DMF0042_1_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-0124 | A5 | UNIT_CURRENCY | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — UNIT_CURRENCY · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 3 (ACT:DMF0042_ExchangeRatePopup.InitSpread) |
| WK-DMF0042-0125 | A5 | VARIATION_FACTOR | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | A5 실행 — VARIATION_FACTOR · 검사기 있음(_verify.spec(@verify)·smoke columns · _trace.spec(@trace) W5 컬럼 표시·그리드 구성(grid_effective Divi |  | 6 (ACT:DMF0042_1_RTF.spdMain_CellClick:966:) |
| WK-DMF0042-0126 | G4 | cboBucketType / Bucket / Bucket Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 15 (ACT:DMF0042_1_BizPlan.DefineProperty ACT) |
| WK-DMF0042-0127 | G4 | cboClosed / Closed | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboClosed / Closed · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 16 (ACT:DMF0042_1_BizPlan.InitControls ACT:D) |
| WK-DMF0042-0128 | G4 | cboQty / . / Qty | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — cboQty / . / Qty · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 0 () |
| WK-DMF0042-0129 | G4 | chkSum / Sum | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — chkSum / Sum · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 0 () |
| WK-DMF0042-0130 | G4 | clbBizType / Biz Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbBizType / Biz Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 30 (ACT:DMF0042_1_BizPlan.InitControls ACT:D) |
| WK-DMF0042-0131 | G4 | clbCustomer / End Customer / Customer | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbCustomer / End Customer / Customer · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 15 (ACT:DMF0042_1_BizPlan.InitControls ACT:D) |
| WK-DMF0042-0132 | G4 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbDivision / Division · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 39 (ACT:DMF0042_1_BizPlan.DefineProperty ACT) |
| WK-DMF0042-0133 | G4 | clbItemType / Item Type | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbItemType / Item Type · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (ACT:DMF0042_1_BizPlan.InitControls:311:4) |
| WK-DMF0042-0134 | G4 | clbPlantSite / Plant Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbPlantSite / Plant Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 6 (ACT:DMF0042_1_BizPlan.InitControls:303:4) |
| WK-DMF0042-0135 | G4 | clbSalesSite / Sales Site | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbSalesSite / Sales Site · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 9 (ACT:DMF0042_1_BizPlan.InitControls ACT:D) |
| WK-DMF0042-0136 | G4 | clbTeam / Team | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — clbTeam / Team · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 15 (ACT:DMF0042_1_BizPlan.InitControls ACT:D) |
| WK-DMF0042-0137 | G4 | drpPeriod / Period | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — drpPeriod / Period · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 5 (ACT:DMF0042_1_BizPlan.FindData:712:14 AC) |
| WK-DMF0042-0138 | G4 | txtItemId / Model / Item Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtItemId / Model / Item Id · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 0 () |
| WK-DMF0042-0139 | G4 | txtOwner / Owner | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtOwner / Owner · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 0 () |
| WK-DMF0042-0140 | G4 | txtProject / Project | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — txtProject / Project · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 0 () |
| WK-DMF0042-0141 | G4 | usrMonthFrom / Period / Month From | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — usrMonthFrom / Period / Month From · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0042_ExchangeRatePopup.InitSpread) |
| WK-DMF0042-0142 | G4 | usrMonthTo / ~ / Month To | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G4 실행 — usrMonthTo / ~ / Month To · 검사기 있음(smoke 화면 열림(labels)·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0042_ExchangeRatePopup.InitSpread) |
| WK-DMF0042-0143 | H2 | COLUMN_LABEL_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — COLUMN_LABEL_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 21 (ACT:DMF0042_1_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-0144 | H2 | COLUMN_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — COLUMN_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 41 (ACT:DMF0042_1_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-0145 | H2 | CURRENCY_UNITCURRENCY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — CURRENCY_UNITCURRENCY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 4 (ACT:DMF0042_ExchangeRatePopup.InitSpread) |
| WK-DMF0042-0146 | H2 | EDIT_FLAG / Edit Flag | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — EDIT_FLAG / Edit Flag · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (InsertRow 메타 잠금 42 (#14~55)) |
| WK-DMF0042-0147 | H2 | EXT_INT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — EXT_INT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 2 (ACT:DMF0042_1_RTF.InitSpread ACT:DMF0042) |
| WK-DMF0042-0148 | H2 | LARGE_CLASS_LABEL_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — LARGE_CLASS_LABEL_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 24 (ACT:DMF0042_1_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-0149 | H2 | REPORT_GROUP8 | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — REPORT_GROUP8 · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 1 (InsertRow 메타 잠금 42 (#14~55)) |
| WK-DMF0042-0150 | H2 | SMALL_CLASS_LABEL_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — SMALL_CLASS_LABEL_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 32 (ACT:DMF0042_1_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-0151 | H2 | UNIT_CURRENCY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H2 실행 — UNIT_CURRENCY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5) — 실행 필요: trace |  | 3 (ACT:DMF0042_ExchangeRatePopup.InitSpread) |
| WK-DMF0042-0152 | H5 | CELL_PROD_SITE / Cell Prod Site | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — CELL_PROD_SITE / Cell Prod Site · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요 |  | 4 (ACT:DMF0042_BizPlan.InitSpread ACT:DMF00) |
| WK-DMF0042-0153 | H5 | COLUMN_LABEL_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — COLUMN_LABEL_NAME · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 21 (ACT:DMF0042_1_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-0154 | H5 | COLUMN_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — COLUMN_NAME · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 41 (ACT:DMF0042_1_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-0155 | H5 | CURRENCY / Currency | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — CURRENCY / Currency · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:DMF0042_ExchangeRatePopup.InitSpread) |
| WK-DMF0042-0156 | H5 | CURRENCY_UNITCURRENCY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — CURRENCY_UNITCURRENCY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (ACT:DMF0042_ExchangeRatePopup.InitSpread) |
| WK-DMF0042-0157 | H5 | DIVISION_ID / Division | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — DIVISION_ID / Division · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 4 (ACT:DMF0042_1_RTF.InitSpread ACT:DMF0042) |
| WK-DMF0042-0158 | H5 | EXT_INT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — EXT_INT · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:DMF0042_1_RTF.InitSpread ACT:DMF0042) |
| WK-DMF0042-0159 | H5 | ITEM_ID / Model | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — ITEM_ID / Model · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 2 (ACT:DMF0042_1_RTF.InitSpread ACT:DMF0042) |
| WK-DMF0042-0160 | H5 | LARGE_CLASS_LABEL_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — LARGE_CLASS_LABEL_NAME · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 24 (ACT:DMF0042_1_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-0161 | H5 | MEASURE / Measure | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — MEASURE / Measure · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 32 (ACT:DMF0042_1_BizPlan.SetSpreadColumn AC) |
| WK-DMF0042-0162 | H5 | PROJECT_CODE / Project Code | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — PROJECT_CODE / Project Code · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: tr |  | 2 (ACT:DMF0042_1_RTF.InitSpread ACT:DMF0042) |
| WK-DMF0042-0163 | H5 | SMALL_CLASS_LABEL_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — SMALL_CLASS_LABEL_NAME · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 32 (ACT:DMF0042_1_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-0164 | H5 | UNIT_CURRENCY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — UNIT_CURRENCY · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 필요: trace |  | 3 (ACT:DMF0042_ExchangeRatePopup.InitSpread) |
| WK-DMF0042-0165 | H5 | usrMonthFrom / Period / Month From | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | H5 실행 — usrMonthFrom / Period / Month From · 검사기 있음(_verify·SC 게이트 · _trace.spec(@trace) W5 컬럼 헤더 ↔ AS-IS 라벨(grid_effective)) — 실행 |  | 2 (ACT:DMF0042_ExchangeRatePopup.InitSpread) |
| WK-DMF0042-0166 | D3 | BIZ_TYPE_NAME82 | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — BIZ_TYPE_NAME82 · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1246:61 ) |
| WK-DMF0042-0167 | D3 | CELL_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CELL_NAME · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1309:75) |
| WK-DMF0042-0168 | D3 | CURRENCY_UNITCURRENCY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — CURRENCY_UNITCURRENCY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 3 (ACT:DMF0042_ExchangeRatePopup.EditButton) |
| WK-DMF0042-0169 | D3 | DEPT_ID40 / Team | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — DEPT_ID40 / Team · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (16) |
| WK-DMF0042-0170 | D3 | EDI_QTY | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — EDI_QTY · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:DMF0042_1_RTF.Select_DpInit_Data:130) |
| WK-DMF0042-0171 | D3 | END_CUSTOMER40 / End Customer | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — END_CUSTOMER40 / End Customer · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: tra |  | 1 (16) |
| WK-DMF0042-0172 | D3 | GAP | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — GAP · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:DMF0042_1_RTF.Select_DpInit_Data:130) |
| WK-DMF0042-0173 | D3 | KWH | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — KWH · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1307:73) |
| WK-DMF0042-0174 | D3 | MKT_FCST | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — MKT_FCST · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:DMF0042_1_RTF.Select_DpInit_Data:130) |
| WK-DMF0042-0175 | D3 | REPORT_GROUP7 | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — REPORT_GROUP7 · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1315:122) |
| WK-DMF0042-0176 | D3 | REPORT_GROUP8 | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — REPORT_GROUP8 · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 5 (InsertRow 메타 잠금 42 (#14~55) ACT:DMF0042_) |
| WK-DMF0042-0177 | D3 | RESULT | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — RESULT · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 2 (ACT:DMF0042_1_RTF.Select_DpInit_Data:130) |
| WK-DMF0042-0178 | D3 | SCM_SITE_ID40 / Sales Site | E2E(검증 엔진 @trace 재실행(run_verify)) | D3 실행 — SCM_SITE_ID40 / Sales Site · 검사기 있음(_trace.spec(@trace) W4 행 조건 잠금 — lock_rules ROW_COND guard 를 행 값으로 계산) — 실행 필요: trace |  | 1 (16) |
| WK-DMF0042-0179 | D4 | FCST_TYPE / FCST Type | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — FCST_TYPE / FCST Type · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: trace |  | 1 (G8) |
| WK-DMF0042-0180 | D4 | INCOTERMS / Rep. Incoterms | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — INCOTERMS / Rep. Incoterms · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: tr |  | 1 (G8) |
| WK-DMF0042-0181 | D4 | PROJECT_CODE82 / Project Code | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D4 실행 — PROJECT_CODE82 / Project Code · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(InsertButton SetValue 리터럴)) — 실행 필요: |  | 1 (G8) |
| WK-DMF0042-0182 | D5 | BIZ_TYPE_NAME81 / Biz.Type | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — BIZ_TYPE_NAME81 / Biz.Type · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:DMF0042_1_BizPlan.InsertRow:1210:41 ) |
| WK-DMF0042-0183 | D5 | CELL_PROD_SITE / Cell Prod Site | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — CELL_PROD_SITE / Cell Prod Site · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:DMF0042_BizPlan.InitSpread ACT:DMF00) |
| WK-DMF0042-0184 | D5 | COLUMN_LABEL_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — COLUMN_LABEL_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 21 (ACT:DMF0042_1_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-0185 | D5 | COLUMN_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — COLUMN_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 41 (ACT:DMF0042_1_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-0186 | D5 | CURRENCY / Currency | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — CURRENCY / Currency · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 12 (ACT:DMF0042_1_BizPlan.InsertRow:1184:20 ) |
| WK-DMF0042-0187 | D5 | CURRENCY_UNITCURRENCY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — CURRENCY_UNITCURRENCY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:DMF0042_ExchangeRatePopup.InitSpread) |
| WK-DMF0042-0188 | D5 | DEPT_NAME_KO | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — DEPT_NAME_KO · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 1 (ACT:DMF0042_2_BizPlan.InsertRow:1348:20) |
| WK-DMF0042-0189 | D5 | DIVISION_ID / Division | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — DIVISION_ID / Division · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 5 (ACT:DMF0042_1_RTF.InitSpread ACT:DMF0042) |
| WK-DMF0042-0190 | D5 | EXT_INT | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — EXT_INT · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:DMF0042_1_RTF.InitSpread ACT:DMF0042) |
| WK-DMF0042-0191 | D5 | ITEM_ID / Model | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — ITEM_ID / Model · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:DMF0042_1_RTF.InitSpread ACT:DMF0042) |
| WK-DMF0042-0192 | D5 | LARGE_CLASS_LABEL_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — LARGE_CLASS_LABEL_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 24 (ACT:DMF0042_1_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-0193 | D5 | PROJECT_CODE / Project Code | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — PROJECT_CODE / Project Code · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 2 (ACT:DMF0042_1_RTF.InitSpread ACT:DMF0042) |
| WK-DMF0042-0194 | D5 | SCM_SITE_ID | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SCM_SITE_ID · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:DMF0042_2_BizPlan.InsertRow:1352:24 ) |
| WK-DMF0042-0195 | D5 | SCM_SITE_ID81 / Sales Site | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SCM_SITE_ID81 / Sales Site · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1204:35 ) |
| WK-DMF0042-0196 | D5 | SCM_SITE_ID82 / Sales Site | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SCM_SITE_ID82 / Sales Site · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1206:37 ) |
| WK-DMF0042-0197 | D5 | SMALL_CLASS_LABEL_NAME | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — SMALL_CLASS_LABEL_NAME · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 32 (ACT:DMF0042_1_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-0198 | D5 | UNIT_CURRENCY | E2E(@verify 재실행(run_verify) / 검증 엔진 @tra | D5 실행 — UNIT_CURRENCY · 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(AS-IS 셀 타입 문장)) — 실행 필요: trace |  | 3 (ACT:DMF0042_ExchangeRatePopup.InitSpread) |
| WK-DMF0042-0199 | E4 | COLUMN_LABEL_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — COLUMN_LABEL_NAME · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 19 (ACT:DMF0042_1_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-0200 | E4 | COLUMN_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — COLUMN_NAME · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 41 (ACT:DMF0042_1_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-0201 | E4 | LARGE_CLASS_LABEL_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — LARGE_CLASS_LABEL_NAME · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 22 (ACT:DMF0042_1_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-0202 | E4 | MSG00097 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00097 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 7 (20 조회 검증 4 (#9~12) ACT:DMF0042_1_BizPlan) |
| WK-DMF0042-0203 | E4 | MSG00108 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00108 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 6 (조회 검증 4 (#9~12) ACT:DMF0042_1_BizPlan.Fi) |
| WK-DMF0042-0204 | E4 | MSG00276 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00276 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 6 (조회 검증 4 (#9~12) ACT:DMF0042_1_BizPlan.Fi) |
| WK-DMF0042-0205 | E4 | MSG00429 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00429 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (24 저장 검증 8 (#13~20)) |
| WK-DMF0042-0206 | E4 | MSG00675 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00675 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (27) |
| WK-DMF0042-0207 | E4 | MSG00676 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00676 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (저장 검증 8 (#13~20)) |
| WK-DMF0042-0208 | E4 | MSG00677 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00677 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (조회 검증 4 (#9~12)) |
| WK-DMF0042-0209 | E4 | MSG00678 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00678 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (btnSetPrice (가격환산) 25) |
| WK-DMF0042-0210 | E4 | MSG00679 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00679 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 2 (14 Grid 입력 4 (#39~40/41/44)) |
| WK-DMF0042-0211 | E4 | MSG00680 | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — MSG00680 · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 4 (G5 btnExchangeRate 26 버튼 가드 6 (#42/43/45) |
| WK-DMF0042-0212 | E4 | SMALL_CLASS_LABEL_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — SMALL_CLASS_LABEL_NAME · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필 |  | 30 (ACT:DMF0042_1_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-0213 | E4 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 |  | 92 (ACT:DMF0042_1_BizPlan.SetSpreadColumn AC) |
| WK-DMF0042-0214 | E4 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 12 (ACT:DMF0042_1_BizPlan.SetSpreadColumn AC) |
| WK-DMF0042-0215 | E4 | clbCustomer / End Customer / Customer | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbCustomer / End Customer / Customer · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저 |  | 1 (Division 분기 33 (사업부분기 전수)) |
| WK-DMF0042-0216 | E4 | clbTeam / Team | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — clbTeam / Team · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 1 (Division 분기 33 (사업부분기 전수)) |
| WK-DMF0042-0217 | E4 | drpPeriod / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | E4 실행 — drpPeriod / Period · 검사기 있음(_trace.spec(@trace) W4 위반 입력 자동 생성(빈값·FROM>TO·요일·바이트) + Save(요청 차단) → 메시지·저장 시도 판정) — 실행 필요:  |  | 5 (ACT:DMF0042_1_BizPlan.FindData:711:13 AC) |
| WK-DMF0042-0218 | G1 | txtItemId / Model / Item Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — txtItemId / Model / Item Id · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 10 (ACT:DMF0042_1_BizPlan.FindData ACT:DMF00) |
| WK-DMF0042-0219 | G1 | usrMonthFrom / Period / Month From | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | G1 실행 — usrMonthFrom / Period / Month From · 검사기 있음(smoke 조회조건 동작·_verify) — 실행 필요: smoke |  | 3 (ACT:DMF0042_ExchangeRatePopup.FindData A) |
| WK-DMF0042-0220 | G6 | cboBucketType / Bucket / Bucket Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboBucketType / Bucket / Bucket Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 15 (ACT:DMF0042_1_BizPlan.DefineProperty ACT) |
| WK-DMF0042-0221 | G6 | cboClosed / Closed | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — cboClosed / Closed · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 16 (ACT:DMF0042_1_BizPlan.InitControls ACT:D) |
| WK-DMF0042-0222 | G6 | chkSum / Sum | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — chkSum / Sum · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 0 () |
| WK-DMF0042-0223 | G6 | clbBizType / Biz Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbBizType / Biz Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 30 (ACT:DMF0042_1_BizPlan.InitControls ACT:D) |
| WK-DMF0042-0224 | G6 | clbCustomer / End Customer / Customer | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbCustomer / End Customer / Customer · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 15 (ACT:DMF0042_1_BizPlan.InitControls ACT:D) |
| WK-DMF0042-0225 | G6 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 39 (ACT:DMF0042_1_BizPlan.DefineProperty ACT) |
| WK-DMF0042-0226 | G6 | clbItemType / Item Type | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbItemType / Item Type · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 5 (ACT:DMF0042_1_BizPlan.InitControls:311:4) |
| WK-DMF0042-0227 | G6 | clbPlantSite / Plant Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbPlantSite / Plant Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 6 (ACT:DMF0042_1_BizPlan.InitControls:303:4) |
| WK-DMF0042-0228 | G6 | clbSalesSite / Sales Site | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbSalesSite / Sales Site · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 9 (ACT:DMF0042_1_BizPlan.InitControls ACT:D) |
| WK-DMF0042-0229 | G6 | clbTeam / Team | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — clbTeam / Team · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 15 (ACT:DMF0042_1_BizPlan.InitControls ACT:D) |
| WK-DMF0042-0230 | G6 | drpPeriod / Period | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — drpPeriod / Period · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 0 () |
| WK-DMF0042-0231 | G6 | txtItemId / Model / Item Id | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtItemId / Model / Item Id · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 0 () |
| WK-DMF0042-0232 | G6 | txtOwner / Owner | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtOwner / Owner · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 0 () |
| WK-DMF0042-0233 | G6 | txtProject / Project | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — txtProject / Project · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 0 () |
| WK-DMF0042-0234 | G6 | usrMonthFrom / Period / Month From | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — usrMonthFrom / Period / Month From · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:DMF0042_ExchangeRatePopup.InitSpread) |
| WK-DMF0042-0235 | G6 | usrMonthTo / ~ / Month To | E2E(검증 엔진 @trace 재실행(run_verify)) | G6 실행 — usrMonthTo / ~ / Month To · 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace |  | 2 (ACT:DMF0042_ExchangeRatePopup.InitSpread) |
| WK-DMF0042-0236 | X-REOPEN | DMF0042 화면 | E2E(검증 엔진 @trace 재실행(run_verify)) | X-REOPEN 실행 — DMF0042 화면 · 검사기 있음(_trace.spec(@trace) 닫기·재오픈) — 실행 필요: trace |  | 85 (ACT:DMF0042_1_BizPlan.Dispose ACT:DMF004) |
| WK-DMF0042-0237 | H6 | clbDivision / Division | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — clbDivision / Division · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 20 (ACT:DMF0042_1_BizPlan.btnColumn_Click:28) |
| WK-DMF0042-0238 | H6 | txtItemId / Model / Item Id | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtItemId / Model / Item Id · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (10) |
| WK-DMF0042-0239 | H6 | txtOwner / Owner | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtOwner / Owner · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (11) |
| WK-DMF0042-0240 | H6 | txtProject / Project | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtProject / Project · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 1 (9) |
| WK-DMF0042-0241 | M3 | DMF0042_1_RTF | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — DMF0042_1_RTF · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류 · 셀 더블클릭 팝업) · popup_data_check.py(개인화 팝업 목록 = |  | 25 (ACT:DMF0042_1_RTF..ctor ACT:DMF0042_1_RT) |
| WK-DMF0042-0242 | M3 | btnSetPrice | E2E(검증 엔진 @trace 재실행(run_verify)) | M3 실행 — btnSetPrice · 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류 · 셀 더블클릭 팝업) · popup_data_check.py(개인화 팝업 목록 = |  | 4 (ACT:DMF0042_1_BizPlan.btnSetPrice_Click ) |
| WK-DMF0042-0243 | M4 | BIZ_TYPE | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — BIZ_TYPE · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0244 | M4 | BIZ_TYPE_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — BIZ_TYPE_NAME · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0245 | M4 | BIZ_TYPE_NAME81 / Biz.Type | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — BIZ_TYPE_NAME81 / Biz.Type · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 8 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0246 | M4 | BIZ_TYPE_NAME82 | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — BIZ_TYPE_NAME82 · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 8 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0247 | M4 | BIZ_UNIT | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — BIZ_UNIT · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0248 | M4 | CELL_CAPA | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — CELL_CAPA · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0249 | M4 | CELL_CORP_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — CELL_CORP_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0250 | M4 | CELL_NICK_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — CELL_NICK_NAME · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0251 | M4 | CELL_PER_MODULE / Cell/Module | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — CELL_PER_MODULE / Cell/Module · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0252 | M4 | CELL_PER_PACK / Cell/Pack | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — CELL_PER_PACK / Cell/Pack · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0253 | M4 | COMPANY_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — COMPANY_NAME · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0254 | M4 | DEPT_ID / Team | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DEPT_ID / Team · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 33 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0255 | M4 | DIVISION_ID / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DIVISION_ID / Division · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 12 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0256 | M4 | DMF0042_1_BizPlan | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DMF0042_1_BizPlan · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0257 | M4 | DMF0042_3_BizPlan | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DMF0042_3_BizPlan · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0258 | M4 | DMF0042_BizPlan | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DMF0042_BizPlan · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:DMF0042_BizPlan.spdMain_CellDoubleCl) |
| WK-DMF0042-0259 | M4 | DMF0042_BizPlan_old | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — DMF0042_BizPlan_old · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_CellDoub) |
| WK-DMF0042-0260 | M4 | EE_CORP_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — EE_CORP_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0261 | M4 | END_CUSTOMER / End Customer | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — END_CUSTOMER / End Customer · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 37 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0262 | M4 | END_CUSTOMER40 / End Customer | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — END_CUSTOMER40 / End Customer · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 12 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0263 | M4 | INCOTERMS / Rep. Incoterms | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — INCOTERMS / Rep. Incoterms · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0264 | M4 | ITEM_ID / Model | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — ITEM_ID / Model · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 271 (15 ACT:DMF0042_1_BizPlan.spdMain_CellDou) |
| WK-DMF0042-0265 | M4 | ITEM_ID40 / Model | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — ITEM_ID40 / Model · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 166 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0266 | M4 | ITEM_NAME / Model Name | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — ITEM_NAME / Model Name · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 12 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0267 | M4 | ITEM_NICK_NAME | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — ITEM_NICK_NAME · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0268 | M4 | MEASURE / Measure | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — MEASURE / Measure · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 11 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0269 | M4 | MODULE_PER_PACK / Module/Pack | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — MODULE_PER_PACK / Module/Pack · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 4 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0270 | M4 | PACK_CORP_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — PACK_CORP_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 3 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0271 | M4 | PRODUCT_GROUP | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — PRODUCT_GROUP · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0272 | M4 | PRODUCT_GROUP_NAME / Product Group Name | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — PRODUCT_GROUP_NAME / Product Group Name · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0273 | M4 | PROJECT_CODE / Project Code | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — PROJECT_CODE / Project Code · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 215 (15 ACT:DMF0042_1_BizPlan.spdMain_CellDou) |
| WK-DMF0042-0274 | M4 | PROJECT_CODE82 / Project Code | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — PROJECT_CODE82 / Project Code · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 134 (15 ACT:DMF0042_1_BizPlan.spdMain_CellDou) |
| WK-DMF0042-0275 | M4 | PROJECT_NAME / Project | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — PROJECT_NAME / Project · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 34 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0276 | M4 | SCM_SITE_ID | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SCM_SITE_ID · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 5 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0277 | M4 | SCM_SITE_ID40 / Sales Site | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SCM_SITE_ID40 / Sales Site · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 12 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0278 | M4 | SCM_SITE_ID81 / Sales Site | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SCM_SITE_ID81 / Sales Site · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 16 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0279 | M4 | SCM_SITE_ID82 / Sales Site | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — SCM_SITE_ID82 / Sales Site · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 16 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0280 | M4 | btnColumn | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnColumn · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (12) |
| WK-DMF0042-0281 | M4 | btnCutOff | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnCutOff · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (27) |
| WK-DMF0042-0282 | M4 | btnExchangeRate | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnExchangeRate · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (26) |
| WK-DMF0042-0283 | M4 | btnItemId | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnItemId · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (10 btnProject/btnItemId/btnOwner) |
| WK-DMF0042-0284 | M4 | btnMeasure | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnMeasure · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (13) |
| WK-DMF0042-0285 | M4 | btnOwner | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnOwner · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (11 btnProject/btnItemId/btnOwner) |
| WK-DMF0042-0286 | M4 | btnProject | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnProject · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 2 (9 btnProject/btnItemId/btnOwner) |
| WK-DMF0042-0287 | M4 | btnReplace | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — btnReplace · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (28) |
| WK-DMF0042-0288 | M4 | clbDivision / Division | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — clbDivision / Division · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 10 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0289 | M4 | txtItemId / Model / Item Id | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtItemId / Model / Item Id · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (10) |
| WK-DMF0042-0290 | M4 | txtOwner / Owner | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtOwner / Owner · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (11) |
| WK-DMF0042-0291 | M4 | txtProject / Project | E2E(검증 엔진 @trace 재실행(run_verify)) | M4 실행 — txtProject / Project · 검사기 있음(_trace.spec(@trace) W4 트리거 셀 더블클릭 → 팝업 선택 → 대상 셀 채움) — 실행 필요: trace |  | 1 (9) |

## W7 기대값 확정 (90)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0042-0292 | A1 | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 1: 행 집계 — 대조표 1 'Edit(F2) 토글 제거 — 상시편집 + editLock' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — gold |  | 0 () |
| WK-DMF0042-0293 | A1 | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 10: 행 집계 — 대조표 10 'btnItemId_Click (L2784~2805)' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — golden |  | 0 () |
| WK-DMF0042-0294 | A1 | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 11: 행 집계 — 대조표 11 'btnOwner_Click (L2942~2961)' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — golden  |  | 0 () |
| WK-DMF0042-0295 | A1 | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 12: 행 집계 — 대조표 12 'btnColumn_Click (L2807~2817)' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — golden |  | 0 () |
| WK-DMF0042-0296 | A1 | 13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 13: 행 집계 — 대조표 13 'btnMeasure_Click (L2819~2830)' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — golde |  | 1 (13) |
| WK-DMF0042-0297 | A1 | 14 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 14: 행 집계 — 대조표 14 'spdMain_Changed (L1800~2723) ⭐' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — gold |  | 0 () |
| WK-DMF0042-0298 | A1 | 15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 15: 행 집계 — 대조표 15 'spdMain_CellDoubleClick (L1598~1798)' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P  |  | 0 () |
| WK-DMF0042-0299 | A1 | 16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 16: 행 집계 — 대조표 16 'spdMain_ComboSelChange (L1565~1596)' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — |  | 1 (16) |
| WK-DMF0042-0300 | A1 | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 2: 행 집계 — 대조표 2 'SAVE = PKG 판 21 IN (AS-IS standalone 27p 중 TO-BE 미' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF00 |  | 0 () |
| WK-DMF0042-0301 | A1 | 20 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 20: 행 집계 — 대조표 20 'FindButton → FindData (L684~799)' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — go |  | 1 (20) |
| WK-DMF0042-0302 | A1 | 24 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 24: 행 집계 — 대조표 24 'SaveButton → SaveData (L801~1148)' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — g |  | 1 (24) |
| WK-DMF0042-0303 | A1 | 25 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 25: 행 집계 — 대조표 25 'btnSetPrice_Click (L3115~3136)' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — gold |  | 1 (25) |
| WK-DMF0042-0304 | A1 | 26 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 26: 행 집계 — 대조표 26 'btnExchangeRate_Click (L2985~3005)' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P —  |  | 1 (26) |
| WK-DMF0042-0305 | A1 | 27 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 27: 행 집계 — 대조표 27 'btnCutOff_Click (L2840~2866)' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — golden |  | 1 (27) |
| WK-DMF0042-0306 | A1 | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 3: 행 집계 — 대조표 3 'Bucket 표시 규칙 — Monthly 시 Q_ 도 sumYn 토글 (AS-IS 는 Q_' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF00 |  | 0 () |
| WK-DMF0042-0307 | A1 | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 4: 행 집계 — 대조표 4 'MSG 재매핑 — 00310→00429 / 00275→00676 / 00276→00677 ' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF00 |  | 0 () |
| WK-DMF0042-0308 | A1 | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 5: 행 집계 — 대조표 5 "cboQty 비노출 + 'N' 고정" 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — golden SKIP AS-IS |  | 0 () |
| WK-DMF0042-0309 | A1 | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 6: 행 집계 — 대조표 6 'Exchange Rate 모달 = 표준 CustomDialog+DataGrid 재구성 (A' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF00 |  | 1 (6) |
| WK-DMF0042-0310 | A1 | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 7: 행 집계 — 대조표 7 'Ver.Cutoff/Replace 모달 = 목록조회+실행 표준 재구성' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P  |  | 1 (7) |
| WK-DMF0042-0311 | A1 | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 8: 행 집계 — 대조표 8 "MEASURE 컬럼 VISIBLE_FLAG='N' (사내 실측) — FE 메타 그대로 반영" 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF00 |  | 0 () |
| WK-DMF0042-0312 | A1 | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 9: 행 집계 — 대조표 9 'btnProject_Click (L2762~2782)' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM_P — golden  |  | 0 () |
| WK-DMF0042-0313 | A1 | DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE: 골든 비교 케이스 없음(DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE — 팝업·보조 SP 는 golden_case |  | 40 (ACT:DMF0042_ExchangeRatePopup.FindButton) |
| WK-DMF0042-0314 | A1 | DMF0042_1_RTF.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0042_1_RTF.FindData: 진입점 집계 — 대조표 DMF0042_1_RTF.FindData 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF0042_GET_DM |  | 1 (ACT:DMF0042_1_RTF.FindData) |
| WK-DMF0042-0315 | A1 | DMF0042_1_RTF.FindDataMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0042_1_RTF.FindDataMain: 진입점 집계 — 대조표 DMF0042_1_RTF.FindDataMain 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF004 |  | 1 (ACT:DMF0042_1_RTF.FindDataMain) |
| WK-DMF0042-0316 | A1 | DMF0042_2_BizPlan.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0042_2_BizPlan.FindButton: 진입점 집계 — 대조표 DMF0042_2_BizPlan.FindButton 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DM |  | 2 (ACT:DMF0042_2_BizPlan.FindButton ACT:DMF) |
| WK-DMF0042-0317 | A1 | DMF0042_2_BizPlan.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0042_2_BizPlan.FindData: 진입점 집계 — 대조표 DMF0042_2_BizPlan.FindData 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF004 |  | 34 (ACT:DMF0042_2_BizPlan.FindData ACT:DMF00) |
| WK-DMF0042-0318 | A1 | DMF0042_3_BizPlan.FindButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0042_3_BizPlan.FindButton: 진입점 집계 — 대조표 DMF0042_3_BizPlan.FindButton 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DM |  | 1 (ACT:DMF0042_3_BizPlan.FindButton) |
| WK-DMF0042-0319 | A1 | DMF0042_3_BizPlan.FindData | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — DMF0042_3_BizPlan.FindData: 진입점 집계 — 대조표 DMF0042_3_BizPlan.FindData 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF004 |  | 1 (ACT:DMF0042_3_BizPlan.FindData) |
| WK-DMF0042-0320 | A1 | Division 분기 33 (사업부분기 전수) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Division 분기 33 (사업부분기 전수): 행 집계 — 대조표 Division 분기 33 (사업부분기 전수) 'InitControls(3)/EditButton(4)/FindData(1)/InsertRo' 의 |  | 1 (Division 분기 33 (사업부분기 전수)) |
| WK-DMF0042-0321 | A1 | Find (F5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — Find (F5): 행 집계 — 대조표 Find (F5) 'hotkeyConfig.search → handleSearch (V-S1~S3 + setF' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG |  | 1 (Find (F5)) |
| WK-DMF0042-0322 | A1 | G9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — G9: 행 집계 — 대조표 G9 '**CELL_PROD_SITE 콤보(40)** — 조회 표시 코드→한글(ALL)+신규행 유' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF |  | 1 (G9) |
| WK-DMF0042-0323 | A1 | PKG_DMF0003.P_DMF0003_GET_DM_ANL_MKT_PSI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0003.P_DMF0003_GET_DM_ANL_MKT_PSI_DPINIT: 골든 비교 케이스 없음(PKG_DMF0003.P_DMF0003_GET_DM_ANL_MKT_PSI_DPINIT — 팝업·보조  |  | 1 (ACT:DMF0042_1_RTF.Select_DpInit_Data:114) |
| WK-DMF0042-0324 | A1 | PKG_DMF0003.P_DMF0003_GET_DM_ANL_MKT_PSI | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0003.P_DMF0003_GET_DM_ANL_MKT_PSI_DPRESULT: 골든 비교 케이스 없음(PKG_DMF0003.P_DMF0003_GET_DM_ANL_MKT_PSI_DPRESULT — 팝업 |  | 1 (ACT:DMF0042_1_RTF.Select_DpResult_Data:1) |
| WK-DMF0042-0325 | A1 | PKG_DMF0042.P_DMF0042_GET_DM_PLN_BUSINES | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0042.P_DMF0042_GET_DM_PLN_BUSINESS_PLAN_DAT: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/DMF0042/DMF0042_GET_ |  | 192 (ACT:DMF0042_1_BizPlan.FindButton ACT:DMF) |
| WK-DMF0042-0326 | A1 | PKG_DMF0042.P_DMF0042_GET_SCM_MST_FUTURE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0042.P_DMF0042_GET_SCM_MST_FUTURE_PRICE_POP: 골든 비교 케이스 없음(PKG_DMF0042.P_DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP  |  | 42 (ACT:DMF0042_ExchangeRatePopup.FindButton) |
| WK-DMF0042-0327 | A1 | PKG_DMF0042.P_DMF0042_GET_SCM_MST_FUTURE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0042.P_DMF0042_GET_SCM_MST_FUTURE_PRICE_POP: 골든 비교 케이스 없음(PKG_DMF0042.P_DMF0042_GET_SCM_MST_FUTURE_PRICE_POPUP_ |  | 42 (ACT:DMF0042_ExchangeRatePopup.FindButton) |
| WK-DMF0042-0328 | A1 | PKG_DMF0042.P_DMF0042_GET_SPREAD_TITLE | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_DMF0042.P_DMF0042_GET_SPREAD_TITLE: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/DMF0042/DMF0042_GET_SPREAD_TITLE |  | 121 (ACT:DMF0042_BizPlan.FindButton ACT:DMF00) |
| WK-DMF0042-0329 | A1 | btnExchangeRate | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — btnExchangeRate: 행 집계 — 대조표 btnExchangeRate '커스텀 버튼(LBL00661) → pending 차단(MSG00680 — AS-IS MSG' 의 A1 7요소: REVIEW:7 ·  |  | 1 (btnExchangeRate) |
| WK-DMF0042-0330 | A1 | btnMeasure 'Measure' | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — btnMeasure 'Measure': 행 집계 — 대조표 btnMeasure 'Measure' "커스텀 버튼(icon) → MeasureSelectModal + saveTitleSet('" 의 A1 7요소: R |  | 1 (btnMeasure 'Measure') |
| WK-DMF0042-0331 | A1 | btnReplace (ADMIN/DM ADMIN) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — btnReplace (ADMIN/DM ADMIN): 행 집계 — 대조표 btnReplace (ADMIN/DM ADMIN) "커스텀 버튼 'Replace' — hasButton('REPLACE') 게이트 + pen |  | 1 (btnReplace (ADMIN/DM ADMIN)) |
| WK-DMF0042-0332 | A1 | btnSetPrice (가격환산) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — btnSetPrice (가격환산): 행 집계 — 대조표 btnSetPrice (가격환산) "커스텀 버튼 'Set Price' → MSG00678 confirm → SET_PRICE(" 의 A1 7요소: REVIE |  | 1 (btnSetPrice (가격환산)) |
| WK-DMF0042-0333 | A1 | — | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — —: 행 집계 — 대조표 — '파리티 확인(무변경): 분모0 가드 기구현 / Cutoff 재조회 없음=파리티·Replac' 의 A1 7요소: REVIEW:7 · FAIL 요소: PKG_DMF0042.P_DMF00 |  | 1 (—) |
| WK-DMF0042-0334 | A1 | 버튼 가드 6 (#42/43/45/97~99) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 버튼 가드 6 (#42/43/45/97~99): 행 집계 — 대조표 버튼 가드 6 (#42/43/45/97~99) 'CutOff·Replace 인라인 "Edit Mode is not allowed."×3 /' 의 |  | 1 (버튼 가드 6 (#42/43/45/97~99)) |
| WK-DMF0042-0335 | A1 | 조회 검증 4 (#9~12) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — 조회 검증 4 (#9~12): 행 집계 — 대조표 조회 검증 4 (#9~12) 'MSG00097(Division)/MSG00108(역전)/MSG00276(6년 초과+보정)' 의 A1 7요소: REVIEW:7 ·  |  | 1 (조회 검증 4 (#9~12)) |
| WK-DMF0042-0336 | G03-WIRE | DMF0042 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | G03-WIRE 기대값 확정 — DMF0042 화면: 게이트 G03 As-is 이벤트 spdMain.CellDoubleClick → spdM / 게이트 G03 As-is 이벤트 spdMain.ComboSelChange → spdMa  |  | 41 (ACT:DMF0042_1_BizPlan..ctor ACT:DMF0042_) |
| WK-DMF0042-0337 | X-LOC | 1 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 1: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (1) |
| WK-DMF0042-0338 | X-LOC | 10 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 10: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (10) |
| WK-DMF0042-0339 | X-LOC | 11 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 11: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (11) |
| WK-DMF0042-0340 | X-LOC | 12 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 12: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (12) |
| WK-DMF0042-0341 | X-LOC | 13 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 13: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (13) |
| WK-DMF0042-0342 | X-LOC | 15 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 15: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (15) |
| WK-DMF0042-0343 | X-LOC | 16 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 16: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (16) |
| WK-DMF0042-0344 | X-LOC | 17 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 17: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (17) |
| WK-DMF0042-0345 | X-LOC | 18 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 18: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (18) |
| WK-DMF0042-0346 | X-LOC | 19 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 19: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (19) |
| WK-DMF0042-0347 | X-LOC | 2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 2: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (2) |
| WK-DMF0042-0348 | X-LOC | 20 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 20: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (20) |
| WK-DMF0042-0349 | X-LOC | 21 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 21: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (21) |
| WK-DMF0042-0350 | X-LOC | 22 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 22: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (22) |
| WK-DMF0042-0351 | X-LOC | 23 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 23: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (23) |
| WK-DMF0042-0352 | X-LOC | 24 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 24: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (24) |
| WK-DMF0042-0353 | X-LOC | 25 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 25: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (25) |
| WK-DMF0042-0354 | X-LOC | 26 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 26: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (26) |
| WK-DMF0042-0355 | X-LOC | 27 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 27: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (27) |
| WK-DMF0042-0356 | X-LOC | 28 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 28: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (28) |
| WK-DMF0042-0357 | X-LOC | 3 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 3: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (3) |
| WK-DMF0042-0358 | X-LOC | 4 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 4: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (4) |
| WK-DMF0042-0359 | X-LOC | 5 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 5: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (5) |
| WK-DMF0042-0360 | X-LOC | 6 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 6: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (6) |
| WK-DMF0042-0361 | X-LOC | 7 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 7: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (7) |
| WK-DMF0042-0362 | X-LOC | 8 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 8: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (8) |
| WK-DMF0042-0363 | X-LOC | 9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 9: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (9) |
| WK-DMF0042-0364 | X-LOC | Division 분기 33 (사업부분기 전수) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Division 분기 33 (사업부분기 전수): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Division 분기 33 (사업부분기 전수)) |
| WK-DMF0042-0365 | X-LOC | EditButton 잠금 8 (#6~13) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — EditButton 잠금 8 (#6~13): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (EditButton 잠금 8 (#6~13)) |
| WK-DMF0042-0366 | X-LOC | G9 | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — G9: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (G9) |
| WK-DMF0042-0367 | X-LOC | Grid 입력 4 (#39~40/41/44) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — Grid 입력 4 (#39~40/41/44): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (Grid 입력 4 (#39~40/41/44)) |
| WK-DMF0042-0368 | X-LOC | InsertRow Measure/수량 잠금 11 (#56~66) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — InsertRow Measure/수량 잠금 11 (#56~66): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (InsertRow Measure/수량 잠금 11 (#56~66)) |
| WK-DMF0042-0369 | X-LOC | InsertRow 메타 잠금 42 (#14~55) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — InsertRow 메타 잠금 42 (#14~55): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (InsertRow 메타 잠금 42 (#14~55)) |
| WK-DMF0042-0370 | X-LOC | SUM 헤더 5 (#1~5) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — SUM 헤더 5 (#1~5): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (SUM 헤더 5 (#1~5)) |
| WK-DMF0042-0371 | X-LOC | — | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — —: 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (—) |
| WK-DMF0042-0372 | X-LOC | 버튼 가드 6 (#42/43/45/97~99) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 버튼 가드 6 (#42/43/45/97~99): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (버튼 가드 6 (#42/43/45/97~99)) |
| WK-DMF0042-0373 | X-LOC | 저장 검증 8 (#13~20) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 저장 검증 8 (#13~20): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (저장 검증 8 (#13~20)) |
| WK-DMF0042-0374 | X-LOC | 조회 검증 4 (#9~12) | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 조회 검증 4 (#9~12): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (조회 검증 4 (#9~12)) |
| WK-DMF0042-0375 | X-LOC | 필수 컬럼 존재 44 (fnValidation 22 + MinColumn | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-LOC 기대값 확정 — 필수 컬럼 존재 44 (fnValidation 22 + MinColumnChk 22): 이 표에 구현 위치 열이 없고 행에도 파일 참조 없음 — 구현 위치 기입(대조표 서술 보강) 필요 |  | 1 (필수 컬럼 존재 44 (fnValidation 22 + MinColumn) |
| WK-DMF0042-0376 | X-ROW | DMF0042_1_RTF..ctor | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0042_1_RTF..ctor: 진입점 집계 2검사 — WARN:1 · NOT_RUN:1 |  | 2 (ACT:DMF0042_1_RTF..ctor:106:1 ACT:DMF004) |
| WK-DMF0042-0377 | X-ROW | DMF0042_2_BizPlan.MinColumnChk | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0042_2_BizPlan.MinColumnChk: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/EXPR/RETURN, 연결된 요소 검사 없음 |  | 5 (ACT:DMF0042_2_BizPlan.MinColumnChk ACT:D) |
| WK-DMF0042-0378 | X-ROW | DMF0042_2_BizPlan.OnShown | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0042_2_BizPlan.OnShown: 진입점 동작 재현 시나리오 필요 — 문장 종류 CALL_LOCAL/ENTRY/EXPR, 연결된 요소 검사 없음 |  | 3 (ACT:DMF0042_2_BizPlan.OnShown ACT:DMF004) |
| WK-DMF0042-0379 | X-ROW | DMF0042_2_BizPlan.ParameterString | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0042_2_BizPlan.ParameterString: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 17 (ACT:DMF0042_2_BizPlan.ParameterString AC) |
| WK-DMF0042-0380 | X-ROW | DMF0042_2_BizPlan.fnValidation | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0042_2_BizPlan.fnValidation: 진입점 동작 재현 시나리오 필요 — 문장 종류 BRANCH/ENTRY/EXPR/FLOW/LOCAL/RETURN, 연결된 요소 검사 없음 |  | 37 (ACT:DMF0042_2_BizPlan.fnValidation ACT:D) |
| WK-DMF0042-0381 | X-ROW | DMF0042_2_BizPlan.spdMain_EditChange | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — DMF0042_2_BizPlan.spdMain_EditChange: 진입점 동작 재현 시나리오 필요 — 문장 종류 ENTRY/EXPR/FLAG/RETURN, 연결된 요소 검사 없음 |  | 4 (ACT:DMF0042_2_BizPlan.spdMain_EditChange) |

## W9 도구 오류 (1559)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-DMF0042-0382 | J2 | DMF0042 화면 | 하네스·환경 | J2 도구 오류 — 원장 V-02d642c4 RULE_SCREEN / 원장 V-22a4a892 DEFECT / 원장 V-fcbc1908 GENERAL / 원장 V-49ea4cea GENERAL / 원장 V-afc361fb GENERA |  | 721 (G1 G2 G4 G8 G9 — 1 2 6 7 13 Find (F5)) |
| WK-DMF0042-0383 | C1 | 3 | 하네스·환경 | C1 도구 오류 — 행 집계 — 대조표 3 'Bucket 표시 규칙 — Monthly 시 Q_ 도 sumYn 토글 (AS-IS 는 Q_' 의 C1 9요소: NOT_RUN:8 · ERROR:1 |  | 0 () |
| WK-DMF0042-0384 | C1 | 4 | 하네스·환경 | C1 도구 오류 — 행 집계 — 대조표 4 'MSG 재매핑 — 00310→00429 / 00275→00676 / 00276→00677 ' 의 C1 9요소: NOT_RUN:8 · ERROR:1 |  | 0 () |
| WK-DMF0042-0385 | C1 | 5 | 하네스·환경 | C1 도구 오류 — 행 집계 — 대조표 5 "cboQty 비노출 + 'N' 고정" 의 C1 9요소: NOT_RUN:8 · ERROR:1 |  | 0 () |
| WK-DMF0042-0386 | C1 | 6 | 하네스·환경 | C1 도구 오류 — 행 집계 — 대조표 6 'Exchange Rate 모달 = 표준 CustomDialog+DataGrid 재구성 (A' 의 C1 9요소: NOT_RUN:8 · ERROR:1 |  | 0 () |
| WK-DMF0042-0387 | C1 | 8 | 하네스·환경 | C1 도구 오류 — 행 집계 — 대조표 8 "MEASURE 컬럼 VISIBLE_FLAG='N' (사내 실측) — FE 메타 그대로 반영" 의 C1 9요소: NOT_RUN:8 · ERROR:1 |  | 0 () |
| WK-DMF0042-0388 | C1 | clbDivision / Division | 하네스·환경 | C1 도구 오류 — 원장 V-dcb820f9 SEARCH |  | 6 (ACT:DMF0042_1_BizPlan.InitControls:237:3) |
| WK-DMF0042-0389 | C2 | 14 | 하네스·환경 | C2 도구 오류 — 행 집계 — 대조표 14 'spdMain_Changed (L1800~2723) ⭐' 의 C2 75요소: ERROR:64 · NOT_RUN:11 |  | 1 (14) |
| WK-DMF0042-0390 | C2 | 17 | 하네스·환경 | C2 도구 오류 — 행 집계 — 대조표 17 'spdMain_EditChange (L2975~2982)' 의 C2 75요소: ERROR:64 · NOT_RUN:11 |  | 1 (17) |
| WK-DMF0042-0391 | C2 | BIZ_TYPE_NAME81 | 하네스·환경 | C2 도구 오류 — 원장 V-16f24a4c |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1210:41) |
| WK-DMF0042-0392 | C2 | BIZ_TYPE_NAME81 | 하네스·환경 | C2 도구 오류 — 원장 V-bc528860 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1271:41) |
| WK-DMF0042-0393 | C2 | BIZ_TYPE_NAME81 | 하네스·환경 | C2 도구 오류 — 원장 V-57706630 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:993:37) |
| WK-DMF0042-0394 | C2 | CELL_PROD_SITE | 하네스·환경 | C2 도구 오류 — 원장 V-eafb5927 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1214:43) |
| WK-DMF0042-0395 | C2 | CELL_PROD_SITE | 하네스·환경 | C2 도구 오류 — 원장 V-6a338f10 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1259:41) |
| WK-DMF0042-0396 | C2 | CELL_PROD_SITE | 하네스·환경 | C2 도구 오류 — 원장 V-b4a06a5e |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1277:43) |
| WK-DMF0042-0397 | C2 | CURRENCY | 하네스·환경 | C2 도구 오류 — 원장 V-edbdad1a |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1184:20) |
| WK-DMF0042-0398 | C2 | CURRENCY | 하네스·환경 | C2 도구 오류 — 원장 V-74649ca6 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1208:39) |
| WK-DMF0042-0399 | C2 | CURRENCY | 하네스·환경 | C2 도구 오류 — 원장 V-12b2a8fa |  | 1 (ACT:DMF0042_2_BizPlan.InsertRow:1336:15) |
| WK-DMF0042-0400 | C2 | CURRENCY | 하네스·환경 | C2 도구 오류 — 원장 V-1d558d3a |  | 1 (ACT:DMF0042_2_BizPlan.InsertRow:1354:26) |
| WK-DMF0042-0401 | C2 | CURRENCY | 하네스·환경 | C2 도구 오류 — 원장 V-23b2ae22 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1227:20) |
| WK-DMF0042-0402 | C2 | CURRENCY | 하네스·환경 | C2 도구 오류 — 원장 V-9f2c0cc5 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1251:39) |
| WK-DMF0042-0403 | C2 | CURRENCY | 하네스·환경 | C2 도구 오류 — 원장 V-7cd3a1cf |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1245:20) |
| WK-DMF0042-0404 | C2 | CURRENCY | 하네스·환경 | C2 도구 오류 — 원장 V-88e25df3 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1269:39) |
| WK-DMF0042-0405 | C2 | CURRENCY | 하네스·환경 | C2 도구 오류 — 원장 V-4c266218 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:971:20) |
| WK-DMF0042-0406 | C2 | CURRENCY | 하네스·환경 | C2 도구 오류 — 원장 V-9eb33426 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:991:35) |
| WK-DMF0042-0407 | C2 | DEPT_ID | 하네스·환경 | C2 도구 오류 — 원장 V-bcf69618 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1196:27) |
| WK-DMF0042-0408 | C2 | DEPT_ID | 하네스·환경 | C2 도구 오류 — 원장 V-30492e9e |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1239:27) |
| WK-DMF0042-0409 | C2 | DEPT_ID | 하네스·환경 | C2 도구 오류 — 원장 V-96ed3c12 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1257:27) |
| WK-DMF0042-0410 | C2 | DEPT_ID | 하네스·환경 | C2 도구 오류 — 원장 V-71889896 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:977:23) |
| WK-DMF0042-0411 | C2 | DEPT_ID40 | 하네스·환경 | C2 도구 오류 — 원장 V-00a512a7 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1194:25) |
| WK-DMF0042-0412 | C2 | DEPT_ID40 | 하네스·환경 | C2 도구 오류 — 원장 V-b9f3c79d |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1237:25) |
| WK-DMF0042-0413 | C2 | DEPT_ID40 | 하네스·환경 | C2 도구 오류 — 원장 V-618f33e6 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1255:25) |
| WK-DMF0042-0414 | C2 | DEPT_ID40 / Team | 하네스·환경 | C2 도구 오류 — 원장 V-00a512a7 ASIS / 원장 V-7ce487e9 ASIS / 원장 V-2e0bc043 ASIS / 원장 V-b9f3c79d ASIS / 원장 V-eaed62c2 ASIS / 원장 V-8171f79d  |  | 34 (16 ACT:DMF0042_1_BizPlan.spdMain_ComboSe) |
| WK-DMF0042-0415 | C2 | DEPT_NAME_KO | 하네스·환경 | C2 도구 오류 — 원장 V-0f4cf892 |  | 1 (ACT:DMF0042_2_BizPlan.InsertRow:1348:20) |
| WK-DMF0042-0416 | C2 | DIVISION_ID | 하네스·환경 | C2 도구 오류 — 원장 V-68f00b95 |  | 1 (ACT:DMF0042_ExchangeRatePopup.InsertRow:) |
| WK-DMF0042-0417 | C2 | DIVISION_ID / Division | 하네스·환경 | C2 도구 오류 — 원장 V-68f00b95 ASIS |  | 2 (ACT:DMF0042_BizPlan_old.spdMain_ComboSel) |
| WK-DMF0042-0418 | C2 | DMF0042_2_BizPlan.cboBucketType_Selected | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.cboBucketType_SelectedIndexChanged 의 C2 75요소: ERROR:64 · NOT_RUN:11 |  | 5 (ACT:DMF0042_2_BizPlan.cboBucketType_Sele) |
| WK-DMF0042-0419 | C2 | DMF0042_2_BizPlan.cboDivision_SelectedIn | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.cboDivision_SelectedIndexChanged 의 C2 75요소: ERROR:64 · NOT_RUN:11 |  | 30 (ACT:DMF0042_2_BizPlan.cboDivision_Select) |
| WK-DMF0042-0420 | C2 | DMF0042_2_BizPlan.chkSum_CheckedChanged | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.chkSum_CheckedChanged 의 C2 75요소: ERROR:64 · NOT_RUN:11 |  | 2 (ACT:DMF0042_2_BizPlan.chkSum_CheckedChan) |
| WK-DMF0042-0421 | C2 | DMF0042_2_BizPlan.clbCustomer_SelectedIn | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.clbCustomer_SelectedIndexChanged 의 C2 75요소: ERROR:64 · NOT_RUN:11 |  | 1 (ACT:DMF0042_2_BizPlan.clbCustomer_Select) |
| WK-DMF0042-0422 | C2 | DMF0042_2_BizPlan.clbTeam_SelectedIndexC | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.clbTeam_SelectedIndexChanged 의 C2 75요소: ERROR:64 · NOT_RUN:11 |  | 5 (ACT:DMF0042_2_BizPlan.clbTeam_SelectedIn) |
| WK-DMF0042-0423 | C2 | DMF0042_2_BizPlan.spdMain_Changed | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.spdMain_Changed 의 C2 1요소: NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 384 (ACT:DMF0042_2_BizPlan.spdMain_Changed:20) |
| WK-DMF0042-0424 | C2 | DMF0042_2_BizPlan.spdMain_ComboSelChange | 하네스·환경 | C2 도구 오류 — 원장 V-5a9af464 ASIS / 원장 V-e316719e ASIS |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0425 | C2 | Division 분기 33 (사업부분기 전수) | 하네스·환경 | C2 도구 오류 — 행 집계 — 대조표 Division 분기 33 (사업부분기 전수) 'InitControls(3)/EditButton(4)/FindData(1)/InsertRo' 의 C2 75요소: ERROR:64 · NOT_RUN |  | 1 (Division 분기 33 (사업부분기 전수)) |
| WK-DMF0042-0426 | C2 | END_CUSTOMER | 하네스·환경 | C2 도구 오류 — 원장 V-2b5ecc16 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1198:29) |
| WK-DMF0042-0427 | C2 | END_CUSTOMER | 하네스·환경 | C2 도구 오류 — 원장 V-f7d398ae |  | 1 (ACT:DMF0042_2_BizPlan.InsertRow:1350:22) |
| WK-DMF0042-0428 | C2 | END_CUSTOMER | 하네스·환경 | C2 도구 오류 — 원장 V-67527be1 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1241:29) |
| WK-DMF0042-0429 | C2 | END_CUSTOMER | 하네스·환경 | C2 도구 오류 — 원장 V-482c21d4 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1259:29) |
| WK-DMF0042-0430 | C2 | END_CUSTOMER | 하네스·환경 | C2 도구 오류 — 원장 V-837516a9 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:981:25) |
| WK-DMF0042-0431 | C2 | END_CUSTOMER / End Customer | 하네스·환경 | C2 도구 오류 — 원장 V-2b5ecc16 ASIS / 원장 V-f7d398ae ASIS / 원장 V-5a9af464 ASIS / 원장 V-e316719e ASIS / 원장 V-67527be1 ASIS / 원장 V-482c21d4  |  | 43 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0432 | C2 | END_CUSTOMER40 | 하네스·환경 | C2 도구 오류 — 원장 V-0db507c9 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1200:31) |
| WK-DMF0042-0433 | C2 | END_CUSTOMER40 | 하네스·환경 | C2 도구 오류 — 원장 V-7ce487e9 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0434 | C2 | END_CUSTOMER40 | 하네스·환경 | C2 도구 오류 — 원장 V-883d5fc3 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1243:31) |
| WK-DMF0042-0435 | C2 | END_CUSTOMER40 | 하네스·환경 | C2 도구 오류 — 원장 V-eaed62c2 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0436 | C2 | END_CUSTOMER40 | 하네스·환경 | C2 도구 오류 — 원장 V-dfec9ce3 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1261:31) |
| WK-DMF0042-0437 | C2 | END_CUSTOMER40 | 하네스·환경 | C2 도구 오류 — 원장 V-352cec4e |  | 1 (ACT:DMF0042_BizPlan.spdMain_ComboSelChan) |
| WK-DMF0042-0438 | C2 | END_CUSTOMER40 | 하네스·환경 | C2 도구 오류 — 원장 V-ed8628c3 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:983:27) |
| WK-DMF0042-0439 | C2 | END_CUSTOMER40 / End Customer | 하네스·환경 | C2 도구 오류 — 원장 V-0db507c9 ASIS / 원장 V-b05a3528 ASIS / 원장 V-7ce487e9 ASIS / 원장 V-2e0bc043 ASIS / 원장 V-883d5fc3 ASIS / 원장 V-6b239e3a  |  | 49 (16 ACT:DMF0042_1_BizPlan.spdMain_ComboSe) |
| WK-DMF0042-0440 | C2 | SCM_SITE_ID | 하네스·환경 | C2 도구 오류 — 원장 V-cb714874 |  | 1 (ACT:DMF0042_2_BizPlan.InsertRow:1352:24) |
| WK-DMF0042-0441 | C2 | SCM_SITE_ID | 하네스·환경 | C2 도구 오류 — 원장 V-cb714874 ASIS / 원장 V-5a9af464 ASIS / 원장 V-e316719e ASIS |  | 39 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0442 | C2 | SCM_SITE_ID | 하네스·환경 | C2 도구 오류 — 원장 V-5a9af464 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0443 | C2 | SCM_SITE_ID | 하네스·환경 | C2 도구 오류 — 원장 V-e316719e |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0444 | C2 | SCM_SITE_ID40 | 하네스·환경 | C2 도구 오류 — 원장 V-ca1484f6 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1202:33) |
| WK-DMF0042-0445 | C2 | SCM_SITE_ID40 | 하네스·환경 | C2 도구 오류 — 원장 V-b05a3528 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0446 | C2 | SCM_SITE_ID40 | 하네스·환경 | C2 도구 오류 — 원장 V-2e0bc043 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0447 | C2 | SCM_SITE_ID40 | 하네스·환경 | C2 도구 오류 — 원장 V-a023207f |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1245:33) |
| WK-DMF0042-0448 | C2 | SCM_SITE_ID40 | 하네스·환경 | C2 도구 오류 — 원장 V-6b239e3a |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0449 | C2 | SCM_SITE_ID40 | 하네스·환경 | C2 도구 오류 — 원장 V-8171f79d |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0450 | C2 | SCM_SITE_ID40 | 하네스·환경 | C2 도구 오류 — 원장 V-22c6c547 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1263:33) |
| WK-DMF0042-0451 | C2 | SCM_SITE_ID40 | 하네스·환경 | C2 도구 오류 — 원장 V-b0a7c3a7 |  | 1 (ACT:DMF0042_BizPlan.spdMain_ComboSelChan) |
| WK-DMF0042-0452 | C2 | SCM_SITE_ID40 | 하네스·환경 | C2 도구 오류 — 원장 V-b01e8ad8 |  | 1 (ACT:DMF0042_BizPlan.spdMain_ComboSelChan) |
| WK-DMF0042-0453 | C2 | SCM_SITE_ID40 | 하네스·환경 | C2 도구 오류 — 원장 V-ca95afc3 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:985:29) |
| WK-DMF0042-0454 | C2 | SCM_SITE_ID40 / Sales Site | 하네스·환경 | C2 도구 오류 — 원장 V-ca1484f6 ASIS / 원장 V-b05a3528 ASIS / 원장 V-2e0bc043 ASIS / 원장 V-a023207f ASIS / 원장 V-6b239e3a ASIS / 원장 V-8171f79d  |  | 10 (16 ACT:DMF0042_1_BizPlan.spdMain_ComboSe) |
| WK-DMF0042-0455 | C2 | SCM_SITE_ID81 | 하네스·환경 | C2 도구 오류 — 원장 V-0a94fc5c |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1204:35) |
| WK-DMF0042-0456 | C2 | SCM_SITE_ID81 | 하네스·환경 | C2 도구 오류 — 원장 V-8c171624 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1247:35) |
| WK-DMF0042-0457 | C2 | SCM_SITE_ID81 | 하네스·환경 | C2 도구 오류 — 원장 V-cc060c9c |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1265:35) |
| WK-DMF0042-0458 | C2 | SCM_SITE_ID81 | 하네스·환경 | C2 도구 오류 — 원장 V-20184eda |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:987:31) |
| WK-DMF0042-0459 | C2 | SCM_SITE_ID82 | 하네스·환경 | C2 도구 오류 — 원장 V-5fd584a1 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1206:37) |
| WK-DMF0042-0460 | C2 | SCM_SITE_ID82 | 하네스·환경 | C2 도구 오류 — 원장 V-996ba14d |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1249:37) |
| WK-DMF0042-0461 | C2 | SCM_SITE_ID82 | 하네스·환경 | C2 도구 오류 — 원장 V-c9358c4d |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1267:37) |
| WK-DMF0042-0462 | C2 | SCM_SITE_ID82 | 하네스·환경 | C2 도구 오류 — 원장 V-d7bd3496 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:989:33) |
| WK-DMF0042-0463 | C3 | 14 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 14 'spdMain_Changed (L1800~2723) ⭐' 의 C3 155요소: NA:112 · ERROR:25 · NOT_RUN:18 |  | 1 (14) |
| WK-DMF0042-0464 | C3 | 17 | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 17 'spdMain_EditChange (L2975~2982)' 의 C3 155요소: NA:112 · ERROR:25 · NOT_RUN:18 |  | 1 (17) |
| WK-DMF0042-0465 | C3 | BIZ_TYPE_NAME82 | 하네스·환경 | C3 도구 오류 — 실측[T-279cef19]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace / [미검증] 검사기(_verify.s |  | 4 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0466 | C3 | CELL_CAPA | 하네스·환경 | C3 도구 오류 — 실측[T-081eb941]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace / [미검증] 검사기(_verify.s |  | 2 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0467 | C3 | CELL_CORP_ID | 하네스·환경 | C3 도구 오류 — 실측[T-1336a78a]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace / [미검증] 검사기(_verify.s |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0468 | C3 | CELL_NICK_NAME | 하네스·환경 | C3 도구 오류 — 실측[T-cb316bce]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace / [미검증] 검사기(_verify.s |  | 2 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0469 | C3 | DEMAND_OPERATION | 하네스·환경 | C3 도구 오류 — 실측[T-0abd02d5]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace / [미검증] 검사기(_verify.s |  | 24 (ACT:DMF0042_1_RTF.Select_DpInit_Data:119) |
| WK-DMF0042-0470 | C3 | DEPT_ID40 / Team | 하네스·환경 | C3 도구 오류 — 실측[T-75bd86e8]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace / [미검증] 검사기(_verify.s |  | 34 (16 ACT:DMF0042_1_BizPlan.spdMain_ComboSe) |
| WK-DMF0042-0471 | C3 | DESC | 하네스·환경 | C3 도구 오류 — 실측[T-317de482]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace / [미검증] 검사기(_verify.s |  | 1 (ACT:DMF0042_1_RTF.sheetSetting:1640:3) |
| WK-DMF0042-0472 | C3 | DMF0042_2_BizPlan.SetCellColor | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.SetCellColor 의 C3 155요소: NA:112 · ERROR:25 · NOT_RUN:18 |  | 3 (ACT:DMF0042_2_BizPlan.SetCellColor:3493:) |
| WK-DMF0042-0473 | C3 | DMF0042_2_BizPlan.SetSpreadHeaderSpan | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.SetSpreadHeaderSpan 의 C3 5요소: NOT_RUN:4 · NA:1 (미실행 요소가 남아 판정필요) |  | 13 (ACT:DMF0042_2_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-0474 | C3 | DMF0042_2_BizPlan.cboBucketType_Selected | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.cboBucketType_SelectedIndexChanged 의 C3 155요소: NA:112 · ERROR:25 · NOT_RUN:18 |  | 5 (ACT:DMF0042_2_BizPlan.cboBucketType_Sele) |
| WK-DMF0042-0475 | C3 | DMF0042_2_BizPlan.cboDivision_SelectedIn | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.cboDivision_SelectedIndexChanged 의 C3 155요소: NA:112 · ERROR:25 · NOT_RUN:18 |  | 30 (ACT:DMF0042_2_BizPlan.cboDivision_Select) |
| WK-DMF0042-0476 | C3 | DMF0042_2_BizPlan.chkSum_CheckedChanged | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.chkSum_CheckedChanged 의 C3 155요소: NA:112 · ERROR:25 · NOT_RUN:18 |  | 2 (ACT:DMF0042_2_BizPlan.chkSum_CheckedChan) |
| WK-DMF0042-0477 | C3 | DMF0042_2_BizPlan.clbCustomer_SelectedIn | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.clbCustomer_SelectedIndexChanged 의 C3 155요소: NA:112 · ERROR:25 · NOT_RUN:18 |  | 1 (ACT:DMF0042_2_BizPlan.clbCustomer_Select) |
| WK-DMF0042-0478 | C3 | DMF0042_2_BizPlan.clbTeam_SelectedIndexC | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.clbTeam_SelectedIndexChanged 의 C3 155요소: NA:112 · ERROR:25 · NOT_RUN:18 |  | 5 (ACT:DMF0042_2_BizPlan.clbTeam_SelectedIn) |
| WK-DMF0042-0479 | C3 | DMF0042_2_BizPlan.spdMain_Changed | 하네스·환경 | C3 도구 오류 — 원장 V-46afa1eb ASIS / 원장 V-5d8b4218 ASIS / 원장 V-5ca822f9 ASIS / 원장 V-ab59fdc8 ASIS / 원장 V-0fa3bab9 ASIS / 원장 V-fe9dcbd8  |  | 384 (ACT:DMF0042_2_BizPlan.spdMain_Changed:20) |
| WK-DMF0042-0480 | C3 | Division 분기 33 (사업부분기 전수) | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 Division 분기 33 (사업부분기 전수) 'InitControls(3)/EditButton(4)/FindData(1)/InsertRo' 의 C3 155요소: NA:112 · ERROR:25 |  | 1 (Division 분기 33 (사업부분기 전수)) |
| WK-DMF0042-0481 | C3 | EDI_QTY | 하네스·환경 | C3 도구 오류 — 실측[T-c21ced0a]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace / [미검증] 검사기(_verify.s |  | 2 (ACT:DMF0042_1_RTF.Select_DpInit_Data:131) |
| WK-DMF0042-0482 | C3 | EE_CORP_ID | 하네스·환경 | C3 도구 오류 — 실측[T-aac0e59a]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace / [미검증] 검사기(_verify.s |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0483 | C3 | END_CUSTOMER40 / End Customer | 하네스·환경 | C3 도구 오류 — 실측[T-b096e40a]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace / [미검증] 검사기(_verify.s |  | 49 (16 ACT:DMF0042_1_BizPlan.spdMain_ComboSe) |
| WK-DMF0042-0484 | C3 | GAP | 하네스·환경 | C3 도구 오류 — 실측[T-81437270]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace / [미검증] 검사기(_verify.s |  | 2 (ACT:DMF0042_1_RTF.Select_In_De_Demand:16) |
| WK-DMF0042-0485 | C3 | Grid 입력 4 (#39~40/41/44) | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 Grid 입력 4 (#39~40/41/44) 'Red 셀 가드/MSG00289(소수)/MSG00002(paste 재검증)/EditChan' 의 C3 155요소: NA:112 · ERROR:25  |  | 1 (Grid 입력 4 (#39~40/41/44)) |
| WK-DMF0042-0486 | C3 | IMPUTATION_YN | 하네스·환경 | C3 도구 오류 — 실측[T-a91c8920]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace / [미검증] 검사기(_verify.s |  | 35 (ACT:DMF0042_1_RTF.Select_DpInit_Data:118) |
| WK-DMF0042-0487 | C3 | ITEM_ID / Model | 하네스·환경 | C3 도구 오류 — 실측[T-76862cea]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace / [미검증] 검사기(_verify.s |  | 39 (ACT:DMF0042_1_BizPlan.InsertRow:1180:16 ) |
| WK-DMF0042-0488 | C3 | ITEM_ID40 / Model | 하네스·환경 | C3 도구 오류 — 실측[T-ff106c46]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace / [미검증] 검사기(_verify.s |  | 20 (ACT:DMF0042_1_BizPlan.InsertRow:1182:18 ) |
| WK-DMF0042-0489 | C3 | ITEM_NAME / Model Name | 하네스·환경 | C3 도구 오류 — 실측[T-d5e50a61]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace / [미검증] 검사기(_verify.s |  | 4 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0490 | C3 | ITEM_NICK_NAME | 하네스·환경 | C3 도구 오류 — 실측[T-bb52b9f9]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace / [미검증] 검사기(_verify.s |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0491 | C3 | MKT_FCST | 하네스·환경 | C3 도구 오류 — 실측[T-99f78711]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace / [미검증] 검사기(_verify.s |  | 2 (ACT:DMF0042_1_RTF.Select_DpInit_Data:131) |
| WK-DMF0042-0492 | C3 | PACK_CORP_ID | 하네스·환경 | C3 도구 오류 — 실측[T-1d9464b5]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace / [미검증] 검사기(_verify.s |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0493 | C3 | RESULT | 하네스·환경 | C3 도구 오류 — 실측[T-aa11a670]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace / [미검증] 검사기(_verify.s |  | 2 (ACT:DMF0042_1_RTF.Select_In_De_Demand:16) |
| WK-DMF0042-0494 | C3 | SCM_SITE_ID40 / Sales Site | 하네스·환경 | C3 도구 오류 — 실측[T-c8fda0ae]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace / [미검증] 검사기(_verify.s |  | 10 (16 ACT:DMF0042_1_BizPlan.spdMain_ComboSe) |
| WK-DMF0042-0495 | C3 | VARIATION_FACTOR | 하네스·환경 | C3 도구 오류 — 실측[T-0c4fa8fa]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(값 대입 문장 원천)) — 실행 필요: trace / [미검증] 검사기(_verify.s |  | 7 (ACT:DMF0042_1_RTF.Select_DpInit_Data:120) |
| WK-DMF0042-0496 | C3 | siMain.SetValue | 하네스·환경 | C3 도구 오류 — 원장 V-b3cdb1c2 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:18) |
| WK-DMF0042-0497 | C3 | siMain.SetValue | 하네스·환경 | C3 도구 오류 — 원장 V-46afa1eb |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:20) |
| WK-DMF0042-0498 | C3 | siMain.SetValue | 하네스·환경 | C3 도구 오류 — 원장 V-288260e0 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:18) |
| WK-DMF0042-0499 | C3 | siMain.SetValue | 하네스·환경 | C3 도구 오류 — 원장 V-11d2b717 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:1873) |
| WK-DMF0042-0500 | C6 | 14 | 하네스·환경 | C6 도구 오류 — 행 집계 — 대조표 14 'spdMain_Changed (L1800~2723) ⭐' 의 C6 177요소: ERROR:170 · NOT_RUN:7 |  | 1 (14) |
| WK-DMF0042-0501 | C6 | 17 | 하네스·환경 | C6 도구 오류 — 행 집계 — 대조표 17 'spdMain_EditChange (L2975~2982)' 의 C6 177요소: ERROR:170 · NOT_RUN:7 |  | 1 (17) |
| WK-DMF0042-0502 | C6 | CITY | 하네스·환경 | C6 도구 오류 — 원장 V-187364fa ASIS |  | 3 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0503 | C6 | CITY | 하네스·환경 | C6 도구 오류 — 원장 V-187364fa |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0504 | C6 | COUNTRY | 하네스·환경 | C6 도구 오류 — 원장 V-6e5a1f04 ASIS |  | 3 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0505 | C6 | COUNTRY | 하네스·환경 | C6 도구 오류 — 원장 V-6e5a1f04 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0506 | C6 | DMF0042_2_BizPlan.cboBucketType_Selected | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.cboBucketType_SelectedIndexChanged 의 C6 177요소: ERROR:170 · NOT_RUN:7 |  | 5 (ACT:DMF0042_2_BizPlan.cboBucketType_Sele) |
| WK-DMF0042-0507 | C6 | DMF0042_2_BizPlan.cboDivision_SelectedIn | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.cboDivision_SelectedIndexChanged 의 C6 177요소: ERROR:170 · NOT_RUN:7 |  | 30 (ACT:DMF0042_2_BizPlan.cboDivision_Select) |
| WK-DMF0042-0508 | C6 | DMF0042_2_BizPlan.chkSum_CheckedChanged | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.chkSum_CheckedChanged 의 C6 177요소: ERROR:170 · NOT_RUN:7 |  | 2 (ACT:DMF0042_2_BizPlan.chkSum_CheckedChan) |
| WK-DMF0042-0509 | C6 | DMF0042_2_BizPlan.clbCustomer_SelectedIn | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.clbCustomer_SelectedIndexChanged 의 C6 177요소: ERROR:170 · NOT_RUN:7 |  | 1 (ACT:DMF0042_2_BizPlan.clbCustomer_Select) |
| WK-DMF0042-0510 | C6 | DMF0042_2_BizPlan.clbTeam_SelectedIndexC | 하네스·환경 | C6 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.clbTeam_SelectedIndexChanged 의 C6 177요소: ERROR:170 · NOT_RUN:7 |  | 5 (ACT:DMF0042_2_BizPlan.clbTeam_SelectedIn) |
| WK-DMF0042-0511 | C6 | DMF0042_2_BizPlan.spdMain_Changed | 하네스·환경 | C6 도구 오류 — 원장 V-0a1d518f ASIS / 원장 V-d23130f7 ASIS / 원장 V-adbaa1ff ASIS / 원장 V-fb2c9dc5 ASIS / 원장 V-c3cce468 ASIS / 원장 V-29e59967  |  | 384 (ACT:DMF0042_2_BizPlan.spdMain_Changed:20) |
| WK-DMF0042-0512 | C6 | DMF0042_2_BizPlan.spdMain_ComboSelChange | 하네스·환경 | C6 도구 오류 — 원장 V-6e5a1f04 ASIS / 원장 V-187364fa ASIS / 원장 V-172913c2 ASIS / 원장 V-dd620832 ASIS / 원장 V-560baf7f ASIS / 원장 V-1b319d46  |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0513 | C6 | Division 분기 33 (사업부분기 전수) | 하네스·환경 | C6 도구 오류 — 행 집계 — 대조표 Division 분기 33 (사업부분기 전수) 'InitControls(3)/EditButton(4)/FindData(1)/InsertRo' 의 C6 177요소: ERROR:170 · NOT_R |  | 1 (Division 분기 33 (사업부분기 전수)) |
| WK-DMF0042-0514 | C6 | END_CUSTOMER / End Customer | 하네스·환경 | C6 도구 오류 — 원장 V-6e5a1f04 ASIS / 원장 V-187364fa ASIS / 원장 V-172913c2 ASIS / 원장 V-dd620832 ASIS / 원장 V-560baf7f ASIS / 원장 V-1b319d46  |  | 43 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0515 | C6 | MEASURE / Measure | 하네스·환경 | C6 도구 오류 — 원장 V-53d87686 ASIS / 원장 V-cadc2ede ASIS / 원장 V-2399d393 ASIS / 원장 V-e0b2a706 ASIS |  | 38 (ACT:DMF0042_1_BizPlan.spdMain_Changed AC) |
| WK-DMF0042-0516 | C6 | SCM_SITE_ID | 하네스·환경 | C6 도구 오류 — 원장 V-6e5a1f04 ASIS / 원장 V-187364fa ASIS / 원장 V-172913c2 ASIS / 원장 V-dd620832 ASIS / 원장 V-560baf7f ASIS / 원장 V-1b319d46  |  | 39 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0517 | C6 | SHIPTO_CODE | 하네스·환경 | C6 도구 오류 — 원장 V-560baf7f ASIS |  | 3 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0518 | C6 | SHIPTO_CODE | 하네스·환경 | C6 도구 오류 — 원장 V-560baf7f |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0519 | C6 | SHIPTO_NAME | 하네스·환경 | C6 도구 오류 — 원장 V-1b319d46 ASIS |  | 3 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0520 | C6 | SHIPTO_NAME | 하네스·환경 | C6 도구 오류 — 원장 V-1b319d46 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0521 | C6 | SOLDTO_CODE | 하네스·환경 | C6 도구 오류 — 원장 V-172913c2 ASIS |  | 3 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0522 | C6 | SOLDTO_CODE | 하네스·환경 | C6 도구 오류 — 원장 V-172913c2 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0523 | C6 | SOLDTO_NAME | 하네스·환경 | C6 도구 오류 — 원장 V-dd620832 ASIS |  | 3 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0524 | C6 | SOLDTO_NAME | 하네스·환경 | C6 도구 오류 — 원장 V-dd620832 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0525 | C6 | UNIT_ENERGY / Energy | 하네스·환경 | C6 도구 오류 — 원장 V-53d87686 ASIS / 원장 V-cadc2ede ASIS / 원장 V-2399d393 ASIS |  | 18 (ACT:DMF0042_1_BizPlan.spdMain_Changed:18) |
| WK-DMF0042-0526 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-7614fc19 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:18) |
| WK-DMF0042-0527 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-98094696 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:19) |
| WK-DMF0042-0528 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-7d70355d |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:19) |
| WK-DMF0042-0529 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-7f1911d3 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:20) |
| WK-DMF0042-0530 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-c3bbdde2 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:20) |
| WK-DMF0042-0531 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-0852f630 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:20) |
| WK-DMF0042-0532 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-2658ad65 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:21) |
| WK-DMF0042-0533 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-330f2268 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:21) |
| WK-DMF0042-0534 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-7077f3fe |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:21) |
| WK-DMF0042-0535 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-642d797d |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:21) |
| WK-DMF0042-0536 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-5885f41e |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:22) |
| WK-DMF0042-0537 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-3dca26aa |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:22) |
| WK-DMF0042-0538 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-6df9e6f9 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:22) |
| WK-DMF0042-0539 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-dad7414b |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:22) |
| WK-DMF0042-0540 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-473071e0 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:23) |
| WK-DMF0042-0541 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-694ec72d |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:23) |
| WK-DMF0042-0542 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-f6711b82 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:24) |
| WK-DMF0042-0543 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-29675b46 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:24) |
| WK-DMF0042-0544 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-fadef0b2 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:24) |
| WK-DMF0042-0545 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-160972e4 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:25) |
| WK-DMF0042-0546 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-7b2de9cc |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:25) |
| WK-DMF0042-0547 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-6ca601d9 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:26) |
| WK-DMF0042-0548 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-019de781 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:26) |
| WK-DMF0042-0549 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-2406551a |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:26) |
| WK-DMF0042-0550 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-1d253b7e |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:26) |
| WK-DMF0042-0551 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-cf59e1f5 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:26) |
| WK-DMF0042-0552 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-4d7dfec1 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:26) |
| WK-DMF0042-0553 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-f908c1b1 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:27) |
| WK-DMF0042-0554 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-d23130f7 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:21) |
| WK-DMF0042-0555 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-adbaa1ff |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:21) |
| WK-DMF0042-0556 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-fb2c9dc5 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:22) |
| WK-DMF0042-0557 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-c3cce468 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:22) |
| WK-DMF0042-0558 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-1fd7a706 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:22) |
| WK-DMF0042-0559 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-041c5afa |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:22) |
| WK-DMF0042-0560 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-d2cd269a |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:23) |
| WK-DMF0042-0561 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-d7c80802 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:23) |
| WK-DMF0042-0562 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-6ac15ddb |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:24) |
| WK-DMF0042-0563 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-5ea410a2 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:24) |
| WK-DMF0042-0564 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-8e39c458 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:24) |
| WK-DMF0042-0565 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-f7feb5f4 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:24) |
| WK-DMF0042-0566 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-19289a65 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:24) |
| WK-DMF0042-0567 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-73930660 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:25) |
| WK-DMF0042-0568 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-14e709cb |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:25) |
| WK-DMF0042-0569 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-ee9f83fd |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:25) |
| WK-DMF0042-0570 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-b55a59f2 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:26) |
| WK-DMF0042-0571 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-c5a505ce |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:26) |
| WK-DMF0042-0572 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-74199cad |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:26) |
| WK-DMF0042-0573 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-4cba64eb |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:27) |
| WK-DMF0042-0574 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-40a8e25b |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:28) |
| WK-DMF0042-0575 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-6105b03a |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:28) |
| WK-DMF0042-0576 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-7d23ad76 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:28) |
| WK-DMF0042-0577 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-65cc0471 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:28) |
| WK-DMF0042-0578 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-c095fb25 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:28) |
| WK-DMF0042-0579 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-48bb1499 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:29) |
| WK-DMF0042-0580 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-2f42a298 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:29) |
| WK-DMF0042-0581 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-8942b873 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:29) |
| WK-DMF0042-0582 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-61e12d37 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:19) |
| WK-DMF0042-0583 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-90113d18 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:19) |
| WK-DMF0042-0584 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-9c16c17d |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:20) |
| WK-DMF0042-0585 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-c365120a |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:20) |
| WK-DMF0042-0586 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-e967da30 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:21) |
| WK-DMF0042-0587 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-9728dfd9 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:21) |
| WK-DMF0042-0588 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-b3fa48b7 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:22) |
| WK-DMF0042-0589 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-ea340dc9 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:22) |
| WK-DMF0042-0590 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-059b533a |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:22) |
| WK-DMF0042-0591 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-55d99ff9 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:22) |
| WK-DMF0042-0592 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-acbc1fe9 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:22) |
| WK-DMF0042-0593 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-47aed639 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:23) |
| WK-DMF0042-0594 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-046281af |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:23) |
| WK-DMF0042-0595 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-fa1dc537 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:23) |
| WK-DMF0042-0596 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-554e903c |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:23) |
| WK-DMF0042-0597 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-a7af497a |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:24) |
| WK-DMF0042-0598 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-d131e2b9 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:24) |
| WK-DMF0042-0599 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-de007a20 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:24) |
| WK-DMF0042-0600 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-40a7fcd4 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:25) |
| WK-DMF0042-0601 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-cefdc65b |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:25) |
| WK-DMF0042-0602 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-df828ae0 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:26) |
| WK-DMF0042-0603 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-9ae37f47 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:26) |
| WK-DMF0042-0604 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-7f10ecf1 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:26) |
| WK-DMF0042-0605 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-631f8106 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:26) |
| WK-DMF0042-0606 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-88eb7a48 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:27) |
| WK-DMF0042-0607 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-0be994b5 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:27) |
| WK-DMF0042-0608 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-71cbba48 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:27) |
| WK-DMF0042-0609 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-c5cabeaa |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:27) |
| WK-DMF0042-0610 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-4bd8e0bf |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:1950) |
| WK-DMF0042-0611 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-083eb5a4 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:1977) |
| WK-DMF0042-0612 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-d50d66de |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2057) |
| WK-DMF0042-0613 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-34d893af |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2063) |
| WK-DMF0042-0614 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-b3d0c504 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2104) |
| WK-DMF0042-0615 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-5d90aae0 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2140) |
| WK-DMF0042-0616 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-cc1e2799 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2225) |
| WK-DMF0042-0617 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-2200f2f9 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2231) |
| WK-DMF0042-0618 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-6881513f |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2247) |
| WK-DMF0042-0619 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-ea2ece32 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2253) |
| WK-DMF0042-0620 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-0ea8234c |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2275) |
| WK-DMF0042-0621 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-9d6199e0 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2310) |
| WK-DMF0042-0622 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-7ab7c182 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2315) |
| WK-DMF0042-0623 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-d73d2f8b |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2344) |
| WK-DMF0042-0624 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-2e69e89c |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2382) |
| WK-DMF0042-0625 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-1ba2e0b3 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2409) |
| WK-DMF0042-0626 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-2bdba5c7 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2489) |
| WK-DMF0042-0627 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-0df0b7a4 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2495) |
| WK-DMF0042-0628 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-6fb4bd9f |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2536) |
| WK-DMF0042-0629 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-88dabf64 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2572) |
| WK-DMF0042-0630 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-0b83abe8 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2657) |
| WK-DMF0042-0631 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-4a2bdfba |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2663) |
| WK-DMF0042-0632 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-d02ffbd7 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2679) |
| WK-DMF0042-0633 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-da7b8e60 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2685) |
| WK-DMF0042-0634 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-cfb1baae |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2707) |
| WK-DMF0042-0635 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-8da318ca |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2742) |
| WK-DMF0042-0636 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-ca792127 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2747) |
| WK-DMF0042-0637 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-ef473002 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2776) |
| WK-DMF0042-0638 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-1d844f60 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_Changed:) |
| WK-DMF0042-0639 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-dd488d85 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_Changed:) |
| WK-DMF0042-0640 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-51cfc3cb |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_Changed:) |
| WK-DMF0042-0641 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-2877e7b4 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_Changed:) |
| WK-DMF0042-0642 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-56b8d905 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_Changed:) |
| WK-DMF0042-0643 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-be707f86 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_Changed:) |
| WK-DMF0042-0644 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-196afbfd |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_Changed:) |
| WK-DMF0042-0645 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-5f0d2805 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_Changed:) |
| WK-DMF0042-0646 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-a26ecce8 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_Changed:) |
| WK-DMF0042-0647 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-df60eef3 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_Changed:) |
| WK-DMF0042-0648 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-31c22614 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_Changed:) |
| WK-DMF0042-0649 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-c42f4056 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_Changed:) |
| WK-DMF0042-0650 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-d7b22526 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_Changed:) |
| WK-DMF0042-0651 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-859503bd |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_Changed:) |
| WK-DMF0042-0652 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-547ec5d7 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_Changed:) |
| WK-DMF0042-0653 | C6 | siMain.SetText | 하네스·환경 | C6 도구 오류 — 원장 V-7718b4d4 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_Changed:) |
| WK-DMF0042-0654 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-47393edc |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:18) |
| WK-DMF0042-0655 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-53d87686 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:18) |
| WK-DMF0042-0656 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-1d9e1a39 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:20) |
| WK-DMF0042-0657 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-c54b23c8 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:20) |
| WK-DMF0042-0658 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-35b1f359 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:24) |
| WK-DMF0042-0659 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-37deac1d |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:24) |
| WK-DMF0042-0660 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-0a1d518f |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:20) |
| WK-DMF0042-0661 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-29e59967 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:22) |
| WK-DMF0042-0662 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-b4166d47 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:22) |
| WK-DMF0042-0663 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-f7cc2d95 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:26) |
| WK-DMF0042-0664 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-18d92c80 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_Changed:26) |
| WK-DMF0042-0665 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-2e038f64 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:18) |
| WK-DMF0042-0666 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-cadc2ede |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:19) |
| WK-DMF0042-0667 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-661042ac |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:20) |
| WK-DMF0042-0668 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-9443bc6e |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:20) |
| WK-DMF0042-0669 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-13e5e006 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:25) |
| WK-DMF0042-0670 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-553cd448 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:25) |
| WK-DMF0042-0671 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-1bf77ea9 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:1873) |
| WK-DMF0042-0672 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-2399d393 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:1915) |
| WK-DMF0042-0673 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-2ec3951a |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2077) |
| WK-DMF0042-0674 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-7a6b582c |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2083) |
| WK-DMF0042-0675 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-299ad2ce |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2509) |
| WK-DMF0042-0676 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-90e9acc7 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:2515) |
| WK-DMF0042-0677 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-e0b2a706 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_Changed:) |
| WK-DMF0042-0678 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-2b5b23ae |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_Changed:) |
| WK-DMF0042-0679 | C6 | siMain.SetValue | 하네스·환경 | C6 도구 오류 — 원장 V-6931a814 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_Changed:) |
| WK-DMF0042-0680 | B1 | CELL_PROD_SITE / Cell Prod Site | 하네스·환경 | B1 도구 오류 — 원장 V-4ea14758 COLUMN |  | 0 () |
| WK-DMF0042-0681 | B1 | CURRENCY / Currency | 하네스·환경 | B1 도구 오류 — 원장 V-cd883794 COLUMN |  | 10 (ACT:DMF0042_1_BizPlan.InsertRow:1184:20 ) |
| WK-DMF0042-0682 | B1 | DEPT_ID / Team | 하네스·환경 | B1 도구 오류 — 원장 V-d51669b3 COLUMN |  | 5 (ACT:DMF0042_1_BizPlan.InsertRow:1196:27 ) |
| WK-DMF0042-0683 | B1 | DEPT_ID40 / Team | 하네스·환경 | B1 도구 오류 — 원장 V-e56876d0 COLUMN |  | 10 (16 ACT:DMF0042_1_BizPlan.InsertRow:1194:) |
| WK-DMF0042-0684 | B1 | END_CUSTOMER / End Customer | 하네스·환경 | B1 도구 오류 — 원장 V-82fa7fcd COLUMN |  | 7 (ACT:DMF0042_1_BizPlan.InsertRow:1198:29 ) |
| WK-DMF0042-0685 | B1 | END_CUSTOMER40 / End Customer | 하네스·환경 | B1 도구 오류 — 원장 V-fdae61e5 COLUMN |  | 14 (16 ACT:DMF0042_1_BizPlan.InsertRow:1200:) |
| WK-DMF0042-0686 | B1 | SCM_SITE_ID40 / Sales Site | 하네스·환경 | B1 도구 오류 — 원장 V-d711fd0b COLUMN |  | 11 (16 ACT:DMF0042_1_BizPlan.InsertRow:1202:) |
| WK-DMF0042-0687 | B1 | SCM_SITE_ID81 / Sales Site | 하네스·환경 | B1 도구 오류 — 원장 V-1ed1e67b COLUMN |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1204:35 ) |
| WK-DMF0042-0688 | B2 | CELL_PROD_SITE / Cell Prod Site | 하네스·환경 | B2 도구 오류 — 원장 V-df1ece50 COLUMN |  | 0 () |
| WK-DMF0042-0689 | B2 | CURRENCY / Currency | 하네스·환경 | B2 도구 오류 — 원장 V-04582ef0 COLUMN |  | 10 (ACT:DMF0042_1_BizPlan.InsertRow:1184:20 ) |
| WK-DMF0042-0690 | B2 | DEPT_ID / Team | 하네스·환경 | B2 도구 오류 — 원장 V-e484d215 COLUMN |  | 5 (ACT:DMF0042_1_BizPlan.InsertRow:1196:27 ) |
| WK-DMF0042-0691 | B2 | DEPT_ID40 / Team | 하네스·환경 | B2 도구 오류 — 원장 V-2f93baa7 COLUMN |  | 10 (16 ACT:DMF0042_1_BizPlan.InsertRow:1194:) |
| WK-DMF0042-0692 | B2 | END_CUSTOMER / End Customer | 하네스·환경 | B2 도구 오류 — 원장 V-630f12f5 COLUMN |  | 7 (ACT:DMF0042_1_BizPlan.InsertRow:1198:29 ) |
| WK-DMF0042-0693 | B2 | END_CUSTOMER40 / End Customer | 하네스·환경 | B2 도구 오류 — 원장 V-37ae74e3 COLUMN |  | 14 (16 ACT:DMF0042_1_BizPlan.InsertRow:1200:) |
| WK-DMF0042-0694 | B2 | SCM_SITE_ID40 / Sales Site | 하네스·환경 | B2 도구 오류 — 원장 V-b3befc22 COLUMN |  | 11 (16 ACT:DMF0042_1_BizPlan.InsertRow:1202:) |
| WK-DMF0042-0695 | B2 | SCM_SITE_ID81 / Sales Site | 하네스·환경 | B2 도구 오류 — 원장 V-5fd779d3 COLUMN |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1204:35 ) |
| WK-DMF0042-0696 | B3 | 4 | 하네스·환경 | B3 도구 오류 — 행 집계 — 대조표 4 'MSG 재매핑 — 00310→00429 / 00275→00676 / 00276→00677 ' 의 B3 8요소: ERROR:6 · NA:1 · NOPATH:1 |  | 0 () |
| WK-DMF0042-0697 | B3 | DEPT_ID40 / Team | 하네스·환경 | B3 도구 오류 — 원장 V-f876020c COLUMN |  | 6 (ACT:DMF0042_1_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0698 | B3 | DMF0042_2_BizPlan.GetBizTypebyDivision | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetBizTypebyDivision 의 B3 8요소: ERROR:6 · NA:1 · NOPATH:1 |  | 3 (ACT:DMF0042_2_BizPlan.GetBizTypebyDivisi) |
| WK-DMF0042-0699 | B3 | DMF0042_2_BizPlan.GetCellColor | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetCellColor 의 B3 8요소: ERROR:6 · NA:1 · NOPATH:1 |  | 5 (ACT:DMF0042_2_BizPlan.GetCellColor:3482:) |
| WK-DMF0042-0700 | B3 | DMF0042_2_BizPlan.GetCellIndexBySpanRowC | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetCellIndexBySpanRowCells 의 B3 8요소: ERROR:6 · NA:1 · NOPATH:1 |  | 4 (ACT:DMF0042_2_BizPlan.GetCellIndexBySpan) |
| WK-DMF0042-0701 | B3 | DMF0042_2_BizPlan.GetCellNumbersByRow | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetCellNumbersByRow 의 B3 8요소: ERROR:6 · NA:1 · NOPATH:1 |  | 14 (ACT:DMF0042_2_BizPlan.GetCellNumbersByRo) |
| WK-DMF0042-0702 | B3 | DMF0042_2_BizPlan.GetCellProdSite | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetCellProdSite 의 B3 8요소: ERROR:6 · NA:1 · NOPATH:1 |  | 8 (ACT:DMF0042_2_BizPlan.GetCellProdSite:35) |
| WK-DMF0042-0703 | B3 | DMF0042_2_BizPlan.GetDayRange | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetDayRange 의 B3 8요소: ERROR:6 · NA:1 · NOPATH:1 |  | 6 (ACT:DMF0042_2_BizPlan.GetDayRange:3091:1) |
| WK-DMF0042-0704 | B3 | DMF0042_2_BizPlan.GetLookupData | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetLookupData 의 B3 8요소: ERROR:6 · NA:1 · NOPATH:1 |  | 3 (ACT:DMF0042_2_BizPlan.GetLookupData:3127) |
| WK-DMF0042-0705 | B3 | DMF0042_2_BizPlan.GetSpdTitle | 하네스·환경 | B3 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetSpdTitle 의 B3 2요소: NA:1 · ERROR:1 |  | 3 (ACT:DMF0042_2_BizPlan.GetSpdTitle:3116:4) |
| WK-DMF0042-0706 | B3 | END_CUSTOMER / End Customer | 하네스·환경 | B3 도구 오류 — 원장 V-e541dbde COLUMN |  | 2 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0707 | B3 | END_CUSTOMER40 / End Customer | 하네스·환경 | B3 도구 오류 — 원장 V-48303ef9 COLUMN |  | 9 (ACT:DMF0042_1_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0708 | B3 | clbCustomer / End Customer / Customer | 하네스·환경 | B3 도구 오류 — 원장 V-c230410d SEARCH |  | 16 (Division 분기 33 (사업부분기 전수) ACT:DMF0042_1_) |
| WK-DMF0042-0709 | B3 | clbDivision / Division | 하네스·환경 | B3 도구 오류 — 원장 V-b750d715 SEARCH |  | 20 (ACT:DMF0042_1_BizPlan.GetSpdTitle ACT:DM) |
| WK-DMF0042-0710 | B3 | clbTeam / Team | 하네스·환경 | B3 도구 오류 — 원장 V-b1993e7e SEARCH |  | 16 (Division 분기 33 (사업부분기 전수) ACT:DMF0042_1_) |
| WK-DMF0042-0711 | B4 | 4 | 하네스·환경 | B4 도구 오류 — 행 집계 — 대조표 4 'MSG 재매핑 — 00310→00429 / 00275→00676 / 00276→00677 ' 의 B4 17요소: ERROR:11 · NOPATH:4 · NA:2 |  | 0 () |
| WK-DMF0042-0712 | B4 | CELL_PROD_SITE / Cell Prod Site | 하네스·환경 | B4 도구 오류 — 원장 V-736e5e45 COLUMN |  | 0 () |
| WK-DMF0042-0713 | B4 | CURRENCY / Currency | 하네스·환경 | B4 도구 오류 — 원장 V-4fe30a25 COLUMN |  | 10 (ACT:DMF0042_1_BizPlan.InsertRow:1184:20 ) |
| WK-DMF0042-0714 | B4 | DEPT_ID / Team | 하네스·환경 | B4 도구 오류 — 원장 V-1654c4da COLUMN |  | 5 (ACT:DMF0042_1_BizPlan.InsertRow:1196:27 ) |
| WK-DMF0042-0715 | B4 | DEPT_ID40 / Team | 하네스·환경 | B4 도구 오류 — 원장 V-77065082 COLUMN |  | 16 (16 ACT:DMF0042_1_BizPlan.InsertRow:1194:) |
| WK-DMF0042-0716 | B4 | DMF0042_2_BizPlan.GetBizTypebyDivision | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetBizTypebyDivision 의 B4 17요소: ERROR:11 · NOPATH:4 · NA:2 |  | 3 (ACT:DMF0042_2_BizPlan.GetBizTypebyDivisi) |
| WK-DMF0042-0717 | B4 | DMF0042_2_BizPlan.GetCellColor | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetCellColor 의 B4 17요소: ERROR:11 · NOPATH:4 · NA:2 |  | 5 (ACT:DMF0042_2_BizPlan.GetCellColor:3482:) |
| WK-DMF0042-0718 | B4 | DMF0042_2_BizPlan.GetCellIndexBySpanRowC | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetCellIndexBySpanRowCells 의 B4 17요소: ERROR:11 · NOPATH:4 · NA:2 |  | 4 (ACT:DMF0042_2_BizPlan.GetCellIndexBySpan) |
| WK-DMF0042-0719 | B4 | DMF0042_2_BizPlan.GetCellNumbersByRow | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetCellNumbersByRow 의 B4 17요소: ERROR:11 · NOPATH:4 · NA:2 |  | 14 (ACT:DMF0042_2_BizPlan.GetCellNumbersByRo) |
| WK-DMF0042-0720 | B4 | DMF0042_2_BizPlan.GetCellProdSite | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetCellProdSite 의 B4 17요소: ERROR:11 · NOPATH:4 · NA:2 |  | 8 (ACT:DMF0042_2_BizPlan.GetCellProdSite:35) |
| WK-DMF0042-0721 | B4 | DMF0042_2_BizPlan.GetDayRange | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetDayRange 의 B4 17요소: ERROR:11 · NOPATH:4 · NA:2 |  | 6 (ACT:DMF0042_2_BizPlan.GetDayRange:3091:1) |
| WK-DMF0042-0722 | B4 | DMF0042_2_BizPlan.GetLookupData | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetLookupData 의 B4 17요소: ERROR:11 · NOPATH:4 · NA:2 |  | 3 (ACT:DMF0042_2_BizPlan.GetLookupData:3127) |
| WK-DMF0042-0723 | B4 | DMF0042_2_BizPlan.GetSpdTitle | 하네스·환경 | B4 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetSpdTitle 의 B4 2요소: NA:1 · ERROR:1 |  | 3 (ACT:DMF0042_2_BizPlan.GetSpdTitle:3116:4) |
| WK-DMF0042-0724 | B4 | END_CUSTOMER / End Customer | 하네스·환경 | B4 도구 오류 — 원장 V-7b1dc135 COLUMN |  | 9 (ACT:DMF0042_1_BizPlan.InsertRow:1198:29 ) |
| WK-DMF0042-0725 | B4 | END_CUSTOMER40 / End Customer | 하네스·환경 | B4 도구 오류 — 원장 V-98c561ed COLUMN |  | 23 (16 ACT:DMF0042_1_BizPlan.InsertRow:1200:) |
| WK-DMF0042-0726 | B4 | SCM_SITE_ID40 / Sales Site | 하네스·환경 | B4 도구 오류 — 원장 V-d95983fd COLUMN |  | 11 (16 ACT:DMF0042_1_BizPlan.InsertRow:1202:) |
| WK-DMF0042-0727 | B4 | SCM_SITE_ID81 / Sales Site | 하네스·환경 | B4 도구 오류 — 원장 V-0a93c616 COLUMN |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1204:35 ) |
| WK-DMF0042-0728 | B4 | clbCustomer / End Customer / Customer | 하네스·환경 | B4 도구 오류 — 원장 V-b7925626 SEARCH |  | 16 (Division 분기 33 (사업부분기 전수) ACT:DMF0042_1_) |
| WK-DMF0042-0729 | B4 | clbDivision / Division | 하네스·환경 | B4 도구 오류 — 원장 V-cae3ba60 SEARCH |  | 20 (ACT:DMF0042_1_BizPlan.GetSpdTitle ACT:DM) |
| WK-DMF0042-0730 | B4 | clbTeam / Team | 하네스·환경 | B4 도구 오류 — 원장 V-7110b583 SEARCH |  | 16 (Division 분기 33 (사업부분기 전수) ACT:DMF0042_1_) |
| WK-DMF0042-0731 | K4 | DMF0042 화면 | 하네스·환경 | K4 도구 오류 — 원장 V-9293cc64 DEFECT / 원장 V-12eb1e56 GENERAL / 원장 V-7957f9fb GENERAL / 원장 V-3730a306 GENERAL / 원장 V-9bd9600e GENERAL /  |  | 685 (ACT:DMF0042_1_BizPlan.btnColumn_Click AC) |
| WK-DMF0042-0732 | F1 | DMF0042 화면 | 하네스·환경 | F1 도구 오류 — 원장 V-1f2afd11 RULE_SCREEN / 원장 V-eb3408a8 RULE_SCREEN / 원장 V-ef57270d RULE_SCREEN / 원장 V-48f42d7f RULE_SCREEN / 원장 V-26 |  | 1186 (G8 2 6 Delete (F9) Save (F7) 22 24 27 저장) |
| WK-DMF0042-0733 | F2 | DMF0042 화면 | 하네스·환경 | F2 도구 오류 — 원장 V-3ea1f174 RULE_SCREEN / 원장 V-a84bf383 RULE_SCREEN / 원장 V-d54f8c25 GENERAL / 원장 V-8724bb86 GENERAL / 원장 V-3c7ace07 G |  | 1143 (2 6 Save (F7) 24 27 저장 검증 8 (#13~20) ACT) |
| WK-DMF0042-0734 | F3 | DMF0042 화면 | 하네스·환경 | F3 도구 오류 — 원장 V-71d9bb1a RULE_SCREEN / 원장 V-08ebae1c RULE_SCREEN / 원장 V-78dce8d4 RULE_SCREEN / 원장 V-a033d198 RULE_SCREEN / 원장 V-10 |  | 2 (17 Grid 입력 4 (#39~40/41/44)) |
| WK-DMF0042-0735 | F5 | DMF0042 화면 | 하네스·환경 | F5 도구 오류 — 원장 V-749baf1a RULE_SCREEN / 원장 V-a8211de7 RULE_SCREEN / 원장 V-dc85b250 RULE_SCREEN / 원장 V-7215060e DEFECT / 원장 V-f2173d6 |  | 42 (Delete (F9) 22 ACT:DMF0042_1_BizPlan.Del) |
| WK-DMF0042-0736 | F6 | DMF0042 화면 | 하네스·환경 | F6 도구 오류 — 원장 V-18392b92 RULE_SCREEN / 원장 V-ca74260c RULE_SCREEN / 원장 V-d40ea7a4 RULE_SCREEN / 원장 V-c1acddbc RULE_SCREEN / 원장 V-4d |  | 1139 (G8 24 ACT:DMF0042_1_BizPlan.SaveButton A) |
| WK-DMF0042-0737 | F4 | 1 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 1 'Edit(F2) 토글 제거 — 상시편집 + editLock' 의 F4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0042-0738 | F4 | 20 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 20 'FindButton → FindData (L684~799)' 의 F4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (20) |
| WK-DMF0042-0739 | F4 | 24 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 24 'SaveButton → SaveData (L801~1148)' 의 F4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (24) |
| WK-DMF0042-0740 | F4 | 25 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 25 'btnSetPrice_Click (L3115~3136)' 의 F4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (25) |
| WK-DMF0042-0741 | F4 | 9 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 9 'btnProject_Click (L2762~2782)' 의 F4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 0 () |
| WK-DMF0042-0742 | F4 | DMF0042_1_BizPlan.GetCellProdSite | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_1_BizPlan.GetCellProdSite 의 F4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0042_1_BizPlan.GetCellProdSite:33) |
| WK-DMF0042-0743 | F4 | DMF0042_1_BizPlan.GetDayRange | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_1_BizPlan.GetDayRange 의 F4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0042_1_BizPlan.GetDayRange:2874:3) |
| WK-DMF0042-0744 | F4 | DMF0042_1_BizPlan.GetSpdTitle | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_1_BizPlan.GetSpdTitle 의 F4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0042_1_BizPlan.GetSpdTitle:2890:3) |
| WK-DMF0042-0745 | F4 | DMF0042_1_RTF.FindData | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_1_RTF.FindData 의 F4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0042_1_RTF.FindData) |
| WK-DMF0042-0746 | F4 | DMF0042_1_RTF.FindDataMain | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_1_RTF.FindDataMain 의 F4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0042_1_RTF.FindDataMain) |
| WK-DMF0042-0747 | F4 | DMF0042_1_RTF.GetSLOC | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_1_RTF.GetSLOC 의 F4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0042_1_RTF.GetSLOC:823:3 ACT:DMF0) |
| WK-DMF0042-0748 | F4 | DMF0042_1_RTF.GetSPlant | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_1_RTF.GetSPlant 의 F4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0042_1_RTF.GetSPlant:805:3 ACT:DM) |
| WK-DMF0042-0749 | F4 | DMF0042_1_RTF.SaveButton | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_1_RTF.SaveButton 의 F4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0042_1_RTF.SaveButton) |
| WK-DMF0042-0750 | F4 | DMF0042_1_RTF.SaveData | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_1_RTF.SaveData 의 F4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0042_1_RTF.SaveData) |
| WK-DMF0042-0751 | F4 | DMF0042_2_BizPlan.FindButton | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.FindButton 의 F4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0042_2_BizPlan.FindButton ACT:DMF) |
| WK-DMF0042-0752 | F4 | DMF0042_2_BizPlan.FindData | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.FindData 의 F4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 34 (ACT:DMF0042_2_BizPlan.FindData ACT:DMF00) |
| WK-DMF0042-0753 | F4 | DMF0042_2_BizPlan.GetCellProdSite | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetCellProdSite 의 F4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0042_2_BizPlan.GetCellProdSite:35) |
| WK-DMF0042-0754 | F4 | DMF0042_2_BizPlan.GetDayRange | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetDayRange 의 F4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0042_2_BizPlan.GetDayRange:3098:5) |
| WK-DMF0042-0755 | F4 | DMF0042_2_BizPlan.GetSpdTitle | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetSpdTitle 의 F4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0042_2_BizPlan.GetSpdTitle:3114:3) |
| WK-DMF0042-0756 | F4 | DMF0042_2_BizPlan.SaveButton | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.SaveButton 의 F4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0042_2_BizPlan.SaveButton) |
| WK-DMF0042-0757 | F4 | DMF0042_2_BizPlan.SaveData | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.SaveData 의 F4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0042_2_BizPlan.SaveData) |
| WK-DMF0042-0758 | F4 | DMF0042_2_BizPlan.btnSetPrice_Click | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.btnSetPrice_Click 의 F4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0042_2_BizPlan.btnSetPrice_Click:) |
| WK-DMF0042-0759 | F4 | DMF0042_2_BizPlan.spdMain_CellDoubleClic | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.spdMain_CellDoubleClick 의 F4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 14 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-0760 | F4 | DMF0042_2_BizPlan.spdMain_ComboSelChange | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.spdMain_ComboSelChange 의 F4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 8 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-0761 | F4 | DMF0042_3_BizPlan.FindButton | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_3_BizPlan.FindButton 의 F4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0042_3_BizPlan.FindButton) |
| WK-DMF0042-0762 | F4 | DMF0042_3_BizPlan.FindData | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_3_BizPlan.FindData 의 F4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0042_3_BizPlan.FindData) |
| WK-DMF0042-0763 | F4 | DMF0042_3_BizPlan.GetCellProdSite | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_3_BizPlan.GetCellProdSite 의 F4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0042_3_BizPlan.GetCellProdSite:34) |
| WK-DMF0042-0764 | F4 | DMF0042_3_BizPlan.GetDayRange | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_3_BizPlan.GetDayRange 의 F4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0042_3_BizPlan.GetDayRange:2988:3) |
| WK-DMF0042-0765 | F4 | DMF0042_3_BizPlan.GetSpdTitle | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_3_BizPlan.GetSpdTitle 의 F4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0042_3_BizPlan.GetSpdTitle:3004:3) |
| WK-DMF0042-0766 | F4 | DMF0042_BizPlan.GetCellProdSite | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_BizPlan.GetCellProdSite 의 F4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0042_BizPlan.GetCellProdSite:3457) |
| WK-DMF0042-0767 | F4 | DMF0042_BizPlan.GetDayRange | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_BizPlan.GetDayRange 의 F4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0042_BizPlan.GetDayRange:2937:3 A) |
| WK-DMF0042-0768 | F4 | DMF0042_BizPlan_old.GetDayRange | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_BizPlan_old.GetDayRange 의 F4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 2 (ACT:DMF0042_BizPlan_old.GetDayRange:2142) |
| WK-DMF0042-0769 | F4 | DMF0042_ExchangeRatePopup.InitSpread_X | 하네스·환경 | F4 도구 오류 — 진입점 집계 — 대조표 DMF0042_ExchangeRatePopup.InitSpread_X 의 F4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (ACT:DMF0042_ExchangeRatePopup.InitSpread) |
| WK-DMF0042-0770 | F4 | Division 분기 33 (사업부분기 전수) | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 Division 분기 33 (사업부분기 전수) 'InitControls(3)/EditButton(4)/FindData(1)/InsertRo' 의 F4 14요소: NOT_RUN:14 (미실행 요소 |  | 1 (Division 분기 33 (사업부분기 전수)) |
| WK-DMF0042-0771 | F4 | G8 | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 G8 '필수값 — **81 에 FCST_TYPE/INCOTERMS 추가**, **82 의 PROJ' 의 F4 14요소: NOT_RUN:14 (미실행 요소가 남아 판정필요) |  | 1 (G8) |
| WK-DMF0042-0772 | A5 | 14 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 14 'spdMain_Changed (L1800~2723) ⭐' 의 A5 18요소: NOT_RUN:17 · ERROR:1 |  | 0 () |
| WK-DMF0042-0773 | A5 | 5 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 5 "cboQty 비노출 + 'N' 고정" 의 A5 18요소: NOT_RUN:17 · ERROR:1 |  | 1 (5) |
| WK-DMF0042-0774 | A5 | 6 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 6 'Exchange Rate 모달 = 표준 CustomDialog+DataGrid 재구성 (A' 의 A5 18요소: NOT_RUN:17 · ERROR:1 |  | 1 (6) |
| WK-DMF0042-0775 | A5 | 9 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 9 'btnProject_Click (L2762~2782)' 의 A5 18요소: NOT_RUN:17 · ERROR:1 |  | 0 () |
| WK-DMF0042-0776 | A5 | DMF0042_2_BizPlan.CreateSpread | 하네스·환경 | A5 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.CreateSpread 의 A5 18요소: NOT_RUN:17 · ERROR:1 |  | 4 (ACT:DMF0042_2_BizPlan.CreateSpread:355:1) |
| WK-DMF0042-0777 | A5 | DMF0042_2_BizPlan.SetSpreadColumn | 하네스·환경 | A5 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.SetSpreadColumn 의 A5 1요소: ERROR:1 |  | 1 (ACT:DMF0042_2_BizPlan.SetSpreadColumn:46) |
| WK-DMF0042-0778 | A5 | DMF0042_2_BizPlan.SetSpreadHeaderSpan | 하네스·환경 | A5 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.SetSpreadHeaderSpan 의 A5 5요소: NOT_RUN:4 · ERROR:1 |  | 13 (ACT:DMF0042_2_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-0779 | A5 | MEASURE / Measure | 하네스·환경 | A5 도구 오류 — 원장 V-8bd1e823 COLUMN |  | 33 (ACT:DMF0042_1_BizPlan.SetSpreadColumn AC) |
| WK-DMF0042-0780 | H10 | DMF0042 화면 | 하네스·환경 | H10 도구 오류 — 브라우저 alert/confirm 직접 호출 0 · 공용 메시지 API 사용 |  | 14 (G5 14 Insert (F8) btnSetPrice (가격환산) btn) |
| WK-DMF0042-0781 | H2 | 18 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 18 'spdMain_TopChange (L2736~2741)' 의 H2 28요소: ERROR:19 · NOT_RUN:9 |  | 1 (18) |
| WK-DMF0042-0782 | H2 | 6 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 6 'Exchange Rate 모달 = 표준 CustomDialog+DataGrid 재구성 (A' 의 H2 28요소: ERROR:19 · NOT_RUN:9 |  | 1 (6) |
| WK-DMF0042-0783 | H2 | 9 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 9 'btnProject_Click (L2762~2782)' 의 H2 28요소: ERROR:19 · NOT_RUN:9 |  | 0 () |
| WK-DMF0042-0784 | H2 | CELL_PER_CAR / Cell/Car | 하네스·환경 | H2 도구 오류 — 원장 V-dca3be64 COLUMN |  | 1 (InsertRow 메타 잠금 42 (#14~55)) |
| WK-DMF0042-0785 | H2 | CELL_PROD_SITE / Cell Prod Site | 하네스·환경 | H2 도구 오류 — 원장 V-a38fa898 COLUMN |  | 4 (ACT:DMF0042_BizPlan.InitSpread ACT:DMF00) |
| WK-DMF0042-0786 | H2 | CURRENCY / Currency | 하네스·환경 | H2 도구 오류 — 원장 V-2ea05ec2 COLUMN / 원장 V-01895b79 ASIS |  | 2 (ACT:DMF0042_ExchangeRatePopup.InitSpread) |
| WK-DMF0042-0787 | H2 | DIVISION_ID / Division | 하네스·환경 | H2 도구 오류 — 원장 V-a9e54fd5 COLUMN / 원장 V-01895b79 ASIS |  | 5 (InsertRow 메타 잠금 42 (#14~55) ACT:DMF0042_) |
| WK-DMF0042-0788 | H2 | DMF0042_2_BizPlan.CreateSpread | 하네스·환경 | H2 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.CreateSpread 의 H2 28요소: ERROR:19 · NOT_RUN:9 |  | 4 (ACT:DMF0042_2_BizPlan.CreateSpread:355:1) |
| WK-DMF0042-0789 | H2 | DMF0042_2_BizPlan.GetCellColor | 하네스·환경 | H2 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.GetCellColor 의 H2 28요소: ERROR:19 · NOT_RUN:9 |  | 5 (ACT:DMF0042_2_BizPlan.GetCellColor:3482:) |
| WK-DMF0042-0790 | H2 | DMF0042_2_BizPlan.SetCellColor | 하네스·환경 | H2 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.SetCellColor 의 H2 28요소: ERROR:19 · NOT_RUN:9 |  | 3 (ACT:DMF0042_2_BizPlan.SetCellColor:3493:) |
| WK-DMF0042-0791 | H2 | DMF0042_2_BizPlan.SetSpreadColumn | 하네스·환경 | H2 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.SetSpreadColumn 의 H2 1요소: ERROR:1 |  | 1 (ACT:DMF0042_2_BizPlan.SetSpreadColumn:46) |
| WK-DMF0042-0792 | H2 | DMF0042_2_BizPlan.SetSpreadHeaderSpan | 하네스·환경 | H2 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.SetSpreadHeaderSpan 의 H2 5요소: NOT_RUN:4 · ERROR:1 |  | 13 (ACT:DMF0042_2_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-0793 | H2 | EditButton 잠금 8 (#6~13) | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 EditButton 잠금 8 (#6~13) '좌측 키 잠금 / Incoterms·FcstType 조건 개방/잠금 / 금년 이전 잠금 /' 의 H2 28요소: ERROR:19 · NOT_RUN:9 |  | 1 (EditButton 잠금 8 (#6~13)) |
| WK-DMF0042-0794 | H2 | ITEM_ID / Model | 하네스·환경 | H2 도구 오류 — 원장 V-c9d214cf COLUMN |  | 2 (ACT:DMF0042_1_RTF.InitSpread ACT:DMF0042) |
| WK-DMF0042-0795 | H2 | MEASURE / Measure | 하네스·환경 | H2 도구 오류 — 원장 V-a9402bf5 COLUMN |  | 33 (InsertRow Measure/수량 잠금 11 (#56~66) ACT:) |
| WK-DMF0042-0796 | H2 | MODULE_PER_CAR / Module/Car | 하네스·환경 | H2 도구 오류 — 원장 V-7eb5dba9 COLUMN |  | 1 (InsertRow 메타 잠금 42 (#14~55)) |
| WK-DMF0042-0797 | H2 | PROJECT_CODE / Project Code | 하네스·환경 | H2 도구 오류 — 원장 V-1e083ee1 COLUMN |  | 2 (ACT:DMF0042_1_RTF.InitSpread ACT:DMF0042) |
| WK-DMF0042-0798 | H2 | SUM 헤더 5 (#1~5) | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 SUM 헤더 5 (#1~5) 'SetSpreadHeaderSpan — Y_ 연 SUM(2단 세로 span) + Q_ 분기' 의 H2 28요소: ERROR:19 · NOT_RUN:9 |  | 1 (SUM 헤더 5 (#1~5)) |
| WK-DMF0042-0799 | H2 | siMain.SpreadObject.ActiveSheet.SetActiv | 하네스·환경 | H2 도구 오류 — 원장 V-1646da51 |  | 1 (ACT:DMF0042_1_BizPlan.DeleteButton:534:5) |
| WK-DMF0042-0800 | H2 | siMain.SpreadObject.ActiveSheet.SetActiv | 하네스·환경 | H2 도구 오류 — 원장 V-9bc5f9e9 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1157:4) |
| WK-DMF0042-0801 | H2 | siMain.SpreadObject.ActiveSheet.SetActiv | 하네스·환경 | H2 도구 오류 — 원장 V-354f5a34 |  | 1 (ACT:DMF0042_2_BizPlan.DeleteButton:530:5) |
| WK-DMF0042-0802 | H2 | siMain.SpreadObject.ActiveSheet.SetActiv | 하네스·환경 | H2 도구 오류 — 원장 V-4dcf777c |  | 1 (ACT:DMF0042_2_BizPlan.InsertRow:1309:4) |
| WK-DMF0042-0803 | H2 | siMain.SpreadObject.ActiveSheet.SetActiv | 하네스·환경 | H2 도구 오류 — 원장 V-13a04bd9 |  | 1 (ACT:DMF0042_3_BizPlan.DeleteButton:560:5) |
| WK-DMF0042-0804 | H2 | siMain.SpreadObject.ActiveSheet.SetActiv | 하네스·환경 | H2 도구 오류 — 원장 V-065768b7 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1200:4) |
| WK-DMF0042-0805 | H2 | siMain.SpreadObject.ActiveSheet.SetActiv | 하네스·환경 | H2 도구 오류 — 원장 V-6124c5b9 |  | 1 (ACT:DMF0042_BizPlan.DeleteButton:558:5) |
| WK-DMF0042-0806 | H2 | siMain.SpreadObject.ActiveSheet.SetActiv | 하네스·환경 | H2 도구 오류 — 원장 V-bd1900e1 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1218:4) |
| WK-DMF0042-0807 | H2 | siMain.SpreadObject.ActiveSheet.SetActiv | 하네스·환경 | H2 도구 오류 — 원장 V-bf6cee0c |  | 1 (ACT:DMF0042_BizPlan_old.DeleteButton:505) |
| WK-DMF0042-0808 | H2 | siMain.SpreadObject.ActiveSheet.SetActiv | 하네스·환경 | H2 도구 오류 — 원장 V-48e07650 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:944:4) |
| WK-DMF0042-0809 | H2 | siMain.SpreadObject.ActiveSheet.SetActiv | 하네스·환경 | H2 도구 오류 — 원장 V-01895b79 |  | 1 (ACT:DMF0042_ExchangeRatePopup.SaveData:4) |
| WK-DMF0042-0810 | H4 | DMF0042 화면 | 하네스·환경 | H4 도구 오류 — 원장 V-988babf4 RULE_SCREEN / 원장 V-66450783 RULE_SCREEN / 원장 V-d06c548b RULE_SCREEN / 원장 V-a04d6c13 RULE_SCREEN / 원장 V-e9 |  | 25 (18 ACT:DMF0042_1_BizPlan.spdMain_TopChan) |
| WK-DMF0042-0811 | H5 | 6 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 6 'Exchange Rate 모달 = 표준 CustomDialog+DataGrid 재구성 (A' 의 H5 19요소: NOT_RUN:14 · ERROR:5 |  | 1 (6) |
| WK-DMF0042-0812 | H5 | DMF0042_2_BizPlan.CreateSpread | 하네스·환경 | H5 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.CreateSpread 의 H5 19요소: NOT_RUN:14 · ERROR:5 |  | 4 (ACT:DMF0042_2_BizPlan.CreateSpread:355:1) |
| WK-DMF0042-0813 | H5 | DMF0042_2_BizPlan.SetSpreadColumn | 하네스·환경 | H5 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.SetSpreadColumn 의 H5 2요소: ERROR:1 · NOT_RUN:1 |  | 1 (ACT:DMF0042_2_BizPlan.SetSpreadColumn:46) |
| WK-DMF0042-0814 | H5 | DMF0042_2_BizPlan.SetSpreadHeaderSpan | 하네스·환경 | H5 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.SetSpreadHeaderSpan 의 H5 5요소: NOT_RUN:5 (미실행 요소가 남아 판정필요) |  | 13 (ACT:DMF0042_2_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-0815 | H5 | cboBucketType / Bucket / Bucket Type | 하네스·환경 | H5 도구 오류 — 원장 V-051a5abd SEARCH |  | 92 (ACT:DMF0042_1_BizPlan.SetSpreadColumn AC) |
| WK-DMF0042-0816 | H5 | chkSum / Sum | 하네스·환경 | H5 도구 오류 — 원장 V-96012b16 SEARCH |  | 12 (ACT:DMF0042_1_BizPlan.SetSpreadColumn AC) |
| WK-DMF0042-0817 | H5 | clbDivision / Division | 하네스·환경 | H5 도구 오류 — 원장 V-b4da3f22 SEARCH |  | 12 (ACT:DMF0042_1_BizPlan.InitSpread ACT:DMF) |
| WK-DMF0042-0818 | H5 | drpPeriod / Period | 하네스·환경 | H5 도구 오류 — 원장 V-e923a2ac SEARCH |  | 0 () |
| WK-DMF0042-0819 | H5 | usrMonthTo / ~ / Month To | 하네스·환경 | H5 도구 오류 — 원장 V-bddc7642 SEARCH |  | 2 (ACT:DMF0042_ExchangeRatePopup.InitSpread) |
| WK-DMF0042-0820 | I1 | DMF0042 화면 | 하네스·환경 | I1 도구 오류 — 원장 V-1d90ef75 RULE_SCREEN / 원장 V-6da678ff RULE_SCREEN / 원장 V-21dba107 RULE_SCREEN / 원장 V-672efd02 DEFECT / 원장 V-b98184d |  | 129 (G5 14 Insert (F8) btnSetPrice (가격환산) btn) |
| WK-DMF0042-0821 | SC1 | DMF0042 화면 | 하네스·환경 | SC1 도구 오류 — 원장 V-dda86c6e RULE_SCREEN |  | 0 () |
| WK-DMF0042-0822 | D1 | 1 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 1 'Edit(F2) 토글 제거 — 상시편집 + editLock' 의 D1 76요소: NA:46 · ERROR:30 |  | 1 (1) |
| WK-DMF0042-0823 | D1 | 17 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 17 'spdMain_EditChange (L2975~2982)' 의 D1 76요소: NA:46 · ERROR:30 |  | 1 (17) |
| WK-DMF0042-0824 | D1 | 21 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 21 'InsertButton → InsertRow (L1150~1417)' 의 D1 76요소: NA:46 · ERROR:30 |  | 1 (21) |
| WK-DMF0042-0825 | D1 | 26 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 26 'btnExchangeRate_Click (L2985~3005)' 의 D1 76요소: NA:46 · ERROR:30 |  | 1 (26) |
| WK-DMF0042-0826 | D1 | 27 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 27 'btnCutOff_Click (L2840~2866)' 의 D1 76요소: NA:46 · ERROR:30 |  | 1 (27) |
| WK-DMF0042-0827 | D1 | 28 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 28 'btnReplace_Click (L3382~3474)' 의 D1 76요소: NA:46 · ERROR:30 |  | 1 (28) |
| WK-DMF0042-0828 | D1 | 6 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 6 'Exchange Rate 모달 = 표준 CustomDialog+DataGrid 재구성 (A' 의 D1 76요소: NA:46 · ERROR:30 |  | 1 (6) |
| WK-DMF0042-0829 | D1 | ALT_SIM_YN | 하네스·환경 | D1 도구 오류 — 실측[T-a73927c3]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace / [미검증] 검사기(_verify. |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1305:71) |
| WK-DMF0042-0830 | D1 | APPLICATION / Applicaion | 하네스·환경 | D1 도구 오류 — 실측[T-888c75e2]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace / [미검증] 검사기(_verify. |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1240:57 ) |
| WK-DMF0042-0831 | D1 | BIZ_TYPE_NAME82 | 하네스·환경 | D1 도구 오류 — 실측[T-12834546]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace / [미검증] 검사기(_verify. |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1246:61 ) |
| WK-DMF0042-0832 | D1 | CELL_CODE | 하네스·환경 | D1 도구 오류 — 실측[T-4d082daa]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace / [미검증] 검사기(_verify. |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1311:77) |
| WK-DMF0042-0833 | D1 | CELL_NAME | 하네스·환경 | D1 도구 오류 — 실측[T-7ed20e73]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace / [미검증] 검사기(_verify. |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1309:75) |
| WK-DMF0042-0834 | D1 | CURRENCY_UNITCURRENCY | 하네스·환경 | D1 도구 오류 — 실측[T-d3a5412e]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace / [미검증] 검사기(_verify. |  | 3 (ACT:DMF0042_ExchangeRatePopup.EditButton) |
| WK-DMF0042-0835 | D1 | CUST_GROUP_DTL / Cust Group Dtl | 하네스·환경 | D1 도구 오류 — 실측[T-accb4fb8]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace / [미검증] 검사기(_verify. |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1236:53 ) |
| WK-DMF0042-0836 | D1 | Division 분기 33 (사업부분기 전수) | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 Division 분기 33 (사업부분기 전수) 'InitControls(3)/EditButton(4)/FindData(1)/InsertRo' 의 D1 76요소: NA:46 · ERROR:30 |  | 1 (Division 분기 33 (사업부분기 전수)) |
| WK-DMF0042-0837 | D1 | EDIT_FLAG / Edit Flag | 하네스·환경 | D1 도구 오류 — 실측[T-5a8289d1]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace / [미검증] 검사기(_verify. |  | 17 (23 InsertRow 메타 잠금 42 (#14~55) ACT:DMF00) |
| WK-DMF0042-0838 | D1 | EDI_QTY | 하네스·환경 | D1 도구 오류 — 실측[T-26d346b6]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace / [미검증] 검사기(_verify. |  | 2 (ACT:DMF0042_1_RTF.Select_DpInit_Data:130) |
| WK-DMF0042-0839 | D1 | EDI_QTY,EDI_QTY | 하네스·환경 | D1 도구 오류 — 원장 V-92805dff |  | 1 (ACT:DMF0042_1_RTF.Select_DpInit_Data:130) |
| WK-DMF0042-0840 | D1 | EDI_QTY,EDI_QTY | 하네스·환경 | D1 도구 오류 — 원장 V-b7798bea |  | 1 (ACT:DMF0042_1_RTF.Select_DpResult_Data:1) |
| WK-DMF0042-0841 | D1 | Edit (F2) | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 Edit (F2) '등록 제외 — 상시편집 + editLock R1~R7 대체 (DMF0021 선례)' 의 D1 76요소: NA:46 · ERROR:30 |  | 1 (Edit (F2)) |
| WK-DMF0042-0842 | D1 | EditButton 잠금 8 (#6~13) | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 EditButton 잠금 8 (#6~13) '좌측 키 잠금 / Incoterms·FcstType 조건 개방/잠금 / 금년 이전 잠금 /' 의 D1 76요소: NA:46 · ERROR:30 |  | 1 (EditButton 잠금 8 (#6~13)) |
| WK-DMF0042-0843 | D1 | G1 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 G1 "**비40/무효창 Q_/Y_ 직접입력 잠금** (구현이 개방하던 과잉 교정 — R4' 버킷" 의 D1 76요소: NA:46 · ERROR:30 |  | 1 (G1) |
| WK-DMF0042-0844 | D1 | G2 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 G2 '**구 R6 제거** — 기존행 INCO/FCST 조건 개방 블록은 신정본 L651~667' 의 D1 76요소: NA:46 · ERROR:30 |  | 1 (G2) |
| WK-DMF0042-0845 | D1 | G4 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 G4 'Monthly LOC 편집 시 **Q_ 롤업 = 편집셀값 Int copy** (합산·0 아' 의 D1 76요소: NA:46 · ERROR:30 |  | 1 (G4) |
| WK-DMF0042-0846 | D1 | GAP | 하네스·환경 | D1 도구 오류 — 실측[T-e9b25b72]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace / [미검증] 검사기(_verify. |  | 2 (ACT:DMF0042_1_RTF.Select_DpInit_Data:130) |
| WK-DMF0042-0847 | D1 | GAP,GAP | 하네스·환경 | D1 도구 오류 — 원장 V-c62a7850 |  | 1 (ACT:DMF0042_1_RTF.Select_DpInit_Data:130) |
| WK-DMF0042-0848 | D1 | GAP,GAP | 하네스·환경 | D1 도구 오류 — 원장 V-d83c4a10 |  | 1 (ACT:DMF0042_1_RTF.Select_DpResult_Data:1) |
| WK-DMF0042-0849 | D1 | KWH | 하네스·환경 | D1 도구 오류 — 실측[T-6ef93bb2]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace / [미검증] 검사기(_verify. |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1307:73) |
| WK-DMF0042-0850 | D1 | MKT_FCST | 하네스·환경 | D1 도구 오류 — 실측[T-ccad4d9a]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace / [미검증] 검사기(_verify. |  | 2 (ACT:DMF0042_1_RTF.Select_DpInit_Data:130) |
| WK-DMF0042-0851 | D1 | MKT_FCST,MKT_FCST | 하네스·환경 | D1 도구 오류 — 원장 V-9b172993 |  | 1 (ACT:DMF0042_1_RTF.Select_DpInit_Data:130) |
| WK-DMF0042-0852 | D1 | MKT_FCST,MKT_FCST | 하네스·환경 | D1 도구 오류 — 원장 V-0dbb8dd1 |  | 1 (ACT:DMF0042_1_RTF.Select_DpResult_Data:1) |
| WK-DMF0042-0853 | D1 | REPORT_GROUP1 / Application Gr. | 하네스·환경 | D1 도구 오류 — 실측[T-196eb582]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace / [미검증] 검사기(_verify. |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1303:110) |
| WK-DMF0042-0854 | D1 | REPORT_GROUP2 / Cust. (Report | 하네스·환경 | D1 도구 오류 — 실측[T-79a0a33b]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace / [미검증] 검사기(_verify. |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1305:112) |
| WK-DMF0042-0855 | D1 | REPORT_GROUP3 / Product Gr.(Report | 하네스·환경 | D1 도구 오류 — 실측[T-802fa72b]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace / [미검증] 검사기(_verify. |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1307:114) |
| WK-DMF0042-0856 | D1 | REPORT_GROUP4 / Product Details.(Report | 하네스·환경 | D1 도구 오류 — 실측[T-29ccfbc0]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace / [미검증] 검사기(_verify. |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1309:116) |
| WK-DMF0042-0857 | D1 | REPORT_GROUP5 / Cyl Gr. (Report | 하네스·환경 | D1 도구 오류 — 실측[T-2227ddf8]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace / [미검증] 검사기(_verify. |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1311:118) |
| WK-DMF0042-0858 | D1 | REPORT_GROUP6 / Cell Model Info | 하네스·환경 | D1 도구 오류 — 실측[T-62a2249d]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace / [미검증] 검사기(_verify. |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1313:120) |
| WK-DMF0042-0859 | D1 | REPORT_GROUP7 | 하네스·환경 | D1 도구 오류 — 실측[T-229e2cb1]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace / [미검증] 검사기(_verify. |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1315:122) |
| WK-DMF0042-0860 | D1 | REPORT_GROUP8 | 하네스·환경 | D1 도구 오류 — 실측[T-3d0b4c9f]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace / [미검증] 검사기(_verify. |  | 5 (InsertRow 메타 잠금 42 (#14~55) ACT:DMF0042_) |
| WK-DMF0042-0861 | D1 | RESULT | 하네스·환경 | D1 도구 오류 — 실측[T-df0473f3]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace / [미검증] 검사기(_verify. |  | 2 (ACT:DMF0042_1_RTF.Select_DpInit_Data:130) |
| WK-DMF0042-0862 | D1 | RESULT,RESULT | 하네스·환경 | D1 도구 오류 — 원장 V-867ab49c |  | 1 (ACT:DMF0042_1_RTF.Select_DpInit_Data:130) |
| WK-DMF0042-0863 | D1 | RESULT,RESULT | 하네스·환경 | D1 도구 오류 — 원장 V-1c2cc8de |  | 1 (ACT:DMF0042_1_RTF.Select_DpResult_Data:1) |
| WK-DMF0042-0864 | D1 | ROUTE / Route | 하네스·환경 | D1 도구 오류 — 실측[T-fcce2b91]: 검사기 있음(_verify.spec(@verify) · _trace.spec(@trace) W5(edit_expect)) — 실행 필요: trace / [미검증] 검사기(_verify. |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1242:59 ) |
| WK-DMF0042-0865 | D1 | SUM 헤더 5 (#1~5) | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 SUM 헤더 5 (#1~5) 'SetSpreadHeaderSpan — Y_ 연 SUM(2단 세로 span) + Q_ 분기' 의 D1 76요소: NA:46 · ERROR:30 |  | 1 (SUM 헤더 5 (#1~5)) |
| WK-DMF0042-0866 | D1 | 버튼 가드 6 (#42/43/45/97~99) | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 버튼 가드 6 (#42/43/45/97~99) 'CutOff·Replace 인라인 "Edit Mode is not allowed."×3 /' 의 D1 76요소: NA:46 · ERROR:30 |  | 1 (버튼 가드 6 (#42/43/45/97~99)) |
| WK-DMF0042-0867 | D3 | 1 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 1 'Edit(F2) 토글 제거 — 상시편집 + editLock' 의 D3 355요소: ERROR:342 · NOT_RUN:13 |  | 1 (1) |
| WK-DMF0042-0868 | D3 | 17 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 17 'spdMain_EditChange (L2975~2982)' 의 D3 355요소: ERROR:342 · NOT_RUN:13 |  | 1 (17) |
| WK-DMF0042-0869 | D3 | 21 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 21 'InsertButton → InsertRow (L1150~1417)' 의 D3 355요소: ERROR:342 · NOT_RUN:13 |  | 1 (21) |
| WK-DMF0042-0870 | D3 | 26 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 26 'btnExchangeRate_Click (L2985~3005)' 의 D3 355요소: ERROR:342 · NOT_RUN:13 |  | 1 (26) |
| WK-DMF0042-0871 | D3 | 27 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 27 'btnCutOff_Click (L2840~2866)' 의 D3 355요소: ERROR:342 · NOT_RUN:13 |  | 1 (27) |
| WK-DMF0042-0872 | D3 | 28 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 28 'btnReplace_Click (L3382~3474)' 의 D3 355요소: ERROR:342 · NOT_RUN:13 |  | 1 (28) |
| WK-DMF0042-0873 | D3 | 6 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 6 'Exchange Rate 모달 = 표준 CustomDialog+DataGrid 재구성 (A' 의 D3 355요소: ERROR:342 · NOT_RUN:13 |  | 1 (6) |
| WK-DMF0042-0874 | D3 | ALT_SIM_YN | 하네스·환경 | D3 도구 오류 — 원장 V-3c68f552 ASIS |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1305:71) |
| WK-DMF0042-0875 | D3 | ALT_SIM_YN,ALT_SIM_YN | 하네스·환경 | D3 도구 오류 — 원장 V-3c68f552 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1305:71) |
| WK-DMF0042-0876 | D3 | APPLICATION / Applicaion | 하네스·환경 | D3 도구 오류 — 원장 V-1d51f8e3 ASIS / 원장 V-0ef8b73e ASIS / 원장 V-ba149f1d ASIS / 원장 V-05a40d09 ASIS |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1240:57 ) |
| WK-DMF0042-0877 | D3 | APPLICATION,APPLICATION | 하네스·환경 | D3 도구 오류 — 원장 V-1d51f8e3 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1240:57) |
| WK-DMF0042-0878 | D3 | APPLICATION,APPLICATION | 하네스·환경 | D3 도구 오류 — 원장 V-0ef8b73e |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1285:55) |
| WK-DMF0042-0879 | D3 | APPLICATION,APPLICATION | 하네스·환경 | D3 도구 오류 — 원장 V-ba149f1d |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1303:57) |
| WK-DMF0042-0880 | D3 | APPLICATION,APPLICATION | 하네스·환경 | D3 도구 오류 — 원장 V-05a40d09 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1018:5) |
| WK-DMF0042-0881 | D3 | BIZ_TYPE_NAME40 / Biz.Type | 하네스·환경 | D3 도구 오류 — 원장 V-4472d4e5 ASIS / 원장 V-56553955 ASIS / 원장 V-8e706c56 ASIS / 원장 V-8d8067ec ASIS |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1248:63 ) |
| WK-DMF0042-0882 | D3 | BIZ_TYPE_NAME40,BIZ_TYPE_NAME40 | 하네스·환경 | D3 도구 오류 — 원장 V-4472d4e5 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1248:63) |
| WK-DMF0042-0883 | D3 | BIZ_TYPE_NAME40,BIZ_TYPE_NAME40 | 하네스·환경 | D3 도구 오류 — 원장 V-56553955 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1293:61) |
| WK-DMF0042-0884 | D3 | BIZ_TYPE_NAME40,BIZ_TYPE_NAME40 | 하네스·환경 | D3 도구 오류 — 원장 V-8e706c56 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1311:63) |
| WK-DMF0042-0885 | D3 | BIZ_TYPE_NAME40,BIZ_TYPE_NAME40 | 하네스·환경 | D3 도구 오류 — 원장 V-8d8067ec |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1026:5) |
| WK-DMF0042-0886 | D3 | BIZ_TYPE_NAME82,BIZ_TYPE_NAME82 | 하네스·환경 | D3 도구 오류 — 원장 V-e598ffa6 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1246:61) |
| WK-DMF0042-0887 | D3 | BIZ_TYPE_NAME82,BIZ_TYPE_NAME82 | 하네스·환경 | D3 도구 오류 — 원장 V-f0c56291 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1291:59) |
| WK-DMF0042-0888 | D3 | BIZ_TYPE_NAME82,BIZ_TYPE_NAME82 | 하네스·환경 | D3 도구 오류 — 원장 V-b7995b55 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1309:61) |
| WK-DMF0042-0889 | D3 | BIZ_TYPE_NAME82,BIZ_TYPE_NAME82 | 하네스·환경 | D3 도구 오류 — 원장 V-6280cccd |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1024:5) |
| WK-DMF0042-0890 | D3 | CELL_CODE | 하네스·환경 | D3 도구 오류 — 원장 V-39fa15d9 ASIS |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1311:77) |
| WK-DMF0042-0891 | D3 | CELL_CODE,CELL_CODE | 하네스·환경 | D3 도구 오류 — 원장 V-39fa15d9 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1311:77) |
| WK-DMF0042-0892 | D3 | CELL_NAME,CELL_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-0e00d3fa |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1309:75) |
| WK-DMF0042-0893 | D3 | CELL_PER_CAR / Cell/Car | 하네스·환경 | D3 도구 오류 — 원장 V-9e4f5b6e ASIS / 원장 V-1e7f5552 ASIS / 원장 V-c3aa5d2c ASIS |  | 4 (InsertRow 메타 잠금 42 (#14~55) ACT:DMF0042_) |
| WK-DMF0042-0894 | D3 | CELL_PER_CAR,CELL_PER_CAR | 하네스·환경 | D3 도구 오류 — 원장 V-9e4f5b6e |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1323:128) |
| WK-DMF0042-0895 | D3 | CELL_PER_CAR,CELL_PER_CAR | 하네스·환경 | D3 도구 오류 — 원장 V-1e7f5552 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1389:141) |
| WK-DMF0042-0896 | D3 | CELL_PER_CAR,CELL_PER_CAR | 하네스·환경 | D3 도구 오류 — 원장 V-c3aa5d2c |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1386:128) |
| WK-DMF0042-0897 | D3 | CELL_PER_MODULE / Cell/Module | 하네스·환경 | D3 도구 오류 — 원장 V-3a302120 ASIS |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1315:80) |
| WK-DMF0042-0898 | D3 | CELL_PER_MODULE,CELL_PER_MODULE | 하네스·환경 | D3 도구 오류 — 원장 V-3a302120 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1315:80) |
| WK-DMF0042-0899 | D3 | CELL_PER_PACK / Cell/Pack | 하네스·환경 | D3 도구 오류 — 원장 V-09a46590 ASIS |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1317:82) |
| WK-DMF0042-0900 | D3 | CELL_PER_PACK,CELL_PER_PACK | 하네스·환경 | D3 도구 오류 — 원장 V-09a46590 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1317:82) |
| WK-DMF0042-0901 | D3 | CELL_TYPE / Product Group | 하네스·환경 | D3 도구 오류 — 원장 V-9e3e08a6 ASIS / 원장 V-a9cb9213 ASIS / 원장 V-24717eb6 ASIS / 원장 V-a1dc0498 ASIS |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1273:86 ) |
| WK-DMF0042-0902 | D3 | CELL_TYPE,CELL_TYPE | 하네스·환경 | D3 도구 오류 — 원장 V-9e3e08a6 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1273:86) |
| WK-DMF0042-0903 | D3 | CELL_TYPE,CELL_TYPE | 하네스·환경 | D3 도구 오류 — 원장 V-a9cb9213 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1339:99) |
| WK-DMF0042-0904 | D3 | CELL_TYPE,CELL_TYPE | 하네스·환경 | D3 도구 오류 — 원장 V-24717eb6 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1336:86) |
| WK-DMF0042-0905 | D3 | CELL_TYPE,CELL_TYPE | 하네스·환경 | D3 도구 오류 — 원장 V-a1dc0498 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1048:7) |
| WK-DMF0042-0906 | D3 | CITY_NAME / City | 하네스·환경 | D3 도구 오류 — 원장 V-e85aea8e ASIS / 원장 V-a0db4200 ASIS / 원장 V-8ea76ab5 ASIS / 원장 V-2939924d ASIS |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1279:92 ) |
| WK-DMF0042-0907 | D3 | CITY_NAME,CITY_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-e85aea8e |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1279:92) |
| WK-DMF0042-0908 | D3 | CITY_NAME,CITY_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-a0db4200 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1345:105) |
| WK-DMF0042-0909 | D3 | CITY_NAME,CITY_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-8ea76ab5 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1342:92) |
| WK-DMF0042-0910 | D3 | CITY_NAME,CITY_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-2939924d |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1054:8) |
| WK-DMF0042-0911 | D3 | COUNTRY_NAME / Country | 하네스·환경 | D3 도구 오류 — 원장 V-f1cc012a ASIS / 원장 V-63cd2b88 ASIS / 원장 V-63ee327c ASIS / 원장 V-890aea0a ASIS |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1277:90 ) |
| WK-DMF0042-0912 | D3 | COUNTRY_NAME,COUNTRY_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-f1cc012a |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1277:90) |
| WK-DMF0042-0913 | D3 | COUNTRY_NAME,COUNTRY_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-63cd2b88 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1343:103) |
| WK-DMF0042-0914 | D3 | COUNTRY_NAME,COUNTRY_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-63ee327c |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1340:90) |
| WK-DMF0042-0915 | D3 | COUNTRY_NAME,COUNTRY_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-890aea0a |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1052:8) |
| WK-DMF0042-0916 | D3 | CURRENCY | 하네스·환경 | D3 도구 오류 — 원장 V-ffb147a3 |  | 1 (ACT:DMF0042_ExchangeRatePopup.EditButton) |
| WK-DMF0042-0917 | D3 | CURRENCY | 하네스·환경 | D3 도구 오류 — 원장 V-ce02db1d |  | 1 (ACT:DMF0042_ExchangeRatePopup.EditButton) |
| WK-DMF0042-0918 | D3 | CURRENCY / Currency | 하네스·환경 | D3 도구 오류 — 원장 V-ffb147a3 ASIS / 원장 V-ce02db1d ASIS / 원장 V-77167e5f ASIS |  | 6 (ACT:DMF0042_ExchangeRatePopup.EditButton) |
| WK-DMF0042-0919 | D3 | CURRENCY,CURRENCY | 하네스·환경 | D3 도구 오류 — 원장 V-77167e5f |  | 1 (ACT:DMF0042_ExchangeRatePopup.InsertRow:) |
| WK-DMF0042-0920 | D3 | CURRENCY_UNITCURRENCY | 하네스·환경 | D3 도구 오류 — 원장 V-0e51f7d4 |  | 1 (ACT:DMF0042_ExchangeRatePopup.InsertRow:) |
| WK-DMF0042-0921 | D3 | CUST_GROUP / Cust Group | 하네스·환경 | D3 도구 오류 — 원장 V-544ee1e9 ASIS / 원장 V-7bc2022f ASIS / 원장 V-97a51494 ASIS / 원장 V-427fc956 ASIS |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1234:51 ) |
| WK-DMF0042-0922 | D3 | CUST_GROUP,CUST_GROUP | 하네스·환경 | D3 도구 오류 — 원장 V-544ee1e9 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1234:51) |
| WK-DMF0042-0923 | D3 | CUST_GROUP,CUST_GROUP | 하네스·환경 | D3 도구 오류 — 원장 V-7bc2022f |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1279:49) |
| WK-DMF0042-0924 | D3 | CUST_GROUP,CUST_GROUP | 하네스·환경 | D3 도구 오류 — 원장 V-97a51494 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1297:51) |
| WK-DMF0042-0925 | D3 | CUST_GROUP,CUST_GROUP | 하네스·환경 | D3 도구 오류 — 원장 V-427fc956 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1012:4) |
| WK-DMF0042-0926 | D3 | CUST_GROUP_DTL / Cust Group Dtl | 하네스·환경 | D3 도구 오류 — 원장 V-9331f408 ASIS / 원장 V-37dd1366 ASIS / 원장 V-af524574 ASIS / 원장 V-0cf1835d ASIS |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1236:53 ) |
| WK-DMF0042-0927 | D3 | CUST_GROUP_DTL,CUST_GROUP_DTL | 하네스·환경 | D3 도구 오류 — 원장 V-9331f408 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1236:53) |
| WK-DMF0042-0928 | D3 | CUST_GROUP_DTL,CUST_GROUP_DTL | 하네스·환경 | D3 도구 오류 — 원장 V-37dd1366 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1281:51) |
| WK-DMF0042-0929 | D3 | CUST_GROUP_DTL,CUST_GROUP_DTL | 하네스·환경 | D3 도구 오류 — 원장 V-af524574 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1299:53) |
| WK-DMF0042-0930 | D3 | CUST_GROUP_DTL,CUST_GROUP_DTL | 하네스·환경 | D3 도구 오류 — 원장 V-0cf1835d |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1014:4) |
| WK-DMF0042-0931 | D3 | DIVISION_ID | 하네스·환경 | D3 도구 오류 — 원장 V-a1605031 |  | 1 (ACT:DMF0042_ExchangeRatePopup.EditButton) |
| WK-DMF0042-0932 | D3 | DIVISION_ID / Division | 하네스·환경 | D3 도구 오류 — 원장 V-35df44f8 ASIS / 원장 V-59dd251d ASIS / 원장 V-c0adc08f ASIS / 원장 V-8aabe71e ASIS / 원장 V-1fc4b415 ASIS / 원장 V-a1605031  |  | 8 (InsertRow 메타 잠금 42 (#14~55) ACT:DMF0042_) |
| WK-DMF0042-0933 | D3 | DIVISION_ID,DIVISION_ID | 하네스·환경 | D3 도구 오류 — 원장 V-35df44f8 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1223:47) |
| WK-DMF0042-0934 | D3 | DIVISION_ID,DIVISION_ID | 하네스·환경 | D3 도구 오류 — 원장 V-59dd251d |  | 1 (ACT:DMF0042_2_BizPlan.InsertRow:1366:30) |
| WK-DMF0042-0935 | D3 | DIVISION_ID,DIVISION_ID | 하네스·환경 | D3 도구 오류 — 원장 V-c0adc08f |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1268:45) |
| WK-DMF0042-0936 | D3 | DIVISION_ID,DIVISION_ID | 하네스·환경 | D3 도구 오류 — 원장 V-8aabe71e |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1286:47) |
| WK-DMF0042-0937 | D3 | DIVISION_ID,DIVISION_ID | 하네스·환경 | D3 도구 오류 — 원장 V-1fc4b415 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1001:4) |
| WK-DMF0042-0938 | D3 | DMF0042_2_BizPlan.EditButton | 하네스·환경 | D3 도구 오류 — 원장 V-412a0479 ASIS / 원장 V-b5eb95a2 ASIS / 원장 V-45a867d9 ASIS / 원장 V-7cab4105 ASIS / 원장 V-18ad7fc4 ASIS / 원장 V-9395d93c  |  | 17 (ACT:DMF0042_2_BizPlan.EditButton:537:1 A) |
| WK-DMF0042-0939 | D3 | DMS_CUSTOMER / End Customer(Report | 하네스·환경 | D3 도구 오류 — 원장 V-bbece189 ASIS / 원장 V-d7540b20 ASIS / 원장 V-f52331b7 ASIS / 원장 V-1fa05ae0 ASIS |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1301:108) |
| WK-DMF0042-0940 | D3 | DMS_CUSTOMER,DMS_CUSTOMER | 하네스·환경 | D3 도구 오류 — 원장 V-bbece189 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1301:108) |
| WK-DMF0042-0941 | D3 | DMS_CUSTOMER,DMS_CUSTOMER | 하네스·환경 | D3 도구 오류 — 원장 V-d7540b20 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1367:121) |
| WK-DMF0042-0942 | D3 | DMS_CUSTOMER,DMS_CUSTOMER | 하네스·환경 | D3 도구 오류 — 원장 V-f52331b7 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1364:108) |
| WK-DMF0042-0943 | D3 | DMS_CUSTOMER,DMS_CUSTOMER | 하네스·환경 | D3 도구 오류 — 원장 V-1fa05ae0 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1076:1) |
| WK-DMF0042-0944 | D3 | DMS_SALES / Sold To Cust(Report | 하네스·환경 | D3 도구 오류 — 원장 V-2c8afc22 ASIS / 원장 V-35849caf ASIS / 원장 V-243b066e ASIS / 원장 V-18c12ac8 ASIS |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1299:106) |
| WK-DMF0042-0945 | D3 | DMS_SALES,DMS_SALES | 하네스·환경 | D3 도구 오류 — 원장 V-2c8afc22 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1299:106) |
| WK-DMF0042-0946 | D3 | DMS_SALES,DMS_SALES | 하네스·환경 | D3 도구 오류 — 원장 V-35849caf |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1365:119) |
| WK-DMF0042-0947 | D3 | DMS_SALES,DMS_SALES | 하네스·환경 | D3 도구 오류 — 원장 V-243b066e |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1362:106) |
| WK-DMF0042-0948 | D3 | DMS_SALES,DMS_SALES | 하네스·환경 | D3 도구 오류 — 원장 V-18c12ac8 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1074:9) |
| WK-DMF0042-0949 | D3 | Division 분기 33 (사업부분기 전수) | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 Division 분기 33 (사업부분기 전수) 'InitControls(3)/EditButton(4)/FindData(1)/InsertRo' 의 D3 355요소: ERROR:342 · NOT_R |  | 1 (Division 분기 33 (사업부분기 전수)) |
| WK-DMF0042-0950 | D3 | EDIT_FLAG / Edit Flag | 하네스·환경 | D3 도구 오류 — 원장 V-ecb223e9 ASIS / 원장 V-030af756 ASIS / 원장 V-f7804a04 ASIS / 원장 V-99adf32c ASIS / 원장 V-1f3693ef ASIS |  | 17 (23 InsertRow 메타 잠금 42 (#14~55) ACT:DMF00) |
| WK-DMF0042-0951 | D3 | EDIT_FLAG,EDIT_FLAG | 하네스·환경 | D3 도구 오류 — 원장 V-ecb223e9 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1319:126) |
| WK-DMF0042-0952 | D3 | EDIT_FLAG,EDIT_FLAG | 하네스·환경 | D3 도구 오류 — 원장 V-030af756 |  | 1 (ACT:DMF0042_2_BizPlan.InsertRow:1462:34) |
| WK-DMF0042-0953 | D3 | EDIT_FLAG,EDIT_FLAG | 하네스·환경 | D3 도구 오류 — 원장 V-f7804a04 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1385:139) |
| WK-DMF0042-0954 | D3 | EDIT_FLAG,EDIT_FLAG | 하네스·환경 | D3 도구 오류 — 원장 V-99adf32c |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1382:126) |
| WK-DMF0042-0955 | D3 | EDIT_FLAG,EDIT_FLAG | 하네스·환경 | D3 도구 오류 — 원장 V-1f3693ef |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1094:1) |
| WK-DMF0042-0956 | D3 | Edit (F2) | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 Edit (F2) '등록 제외 — 상시편집 + editLock R1~R7 대체 (DMF0021 선례)' 의 D3 355요소: ERROR:342 · NOT_RUN:13 |  | 1 (Edit (F2)) |
| WK-DMF0042-0957 | D3 | EditButton 잠금 8 (#6~13) | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 EditButton 잠금 8 (#6~13) '좌측 키 잠금 / Incoterms·FcstType 조건 개방/잠금 / 금년 이전 잠금 /' 의 D3 355요소: ERROR:342 · NOT_RUN |  | 1 (EditButton 잠금 8 (#6~13)) |
| WK-DMF0042-0958 | D3 | FCST_TYPE / FCST Type | 하네스·환경 | D3 도구 오류 — 원장 V-d0f1c254 ASIS / 원장 V-5d7ebf53 ASIS / 원장 V-c8f6840e ASIS / 원장 V-41b9e6f8 ASIS |  | 8 (ACT:DMF0042_1_BizPlan.EditButton ACT:DMF) |
| WK-DMF0042-0959 | D3 | FCST_TYPE,FCST_TYPE | 하네스·환경 | D3 도구 오류 — 원장 V-d0f1c254 |  | 1 (ACT:DMF0042_1_BizPlan.EditButton:635:35) |
| WK-DMF0042-0960 | D3 | FCST_TYPE,FCST_TYPE | 하네스·환경 | D3 도구 오류 — 원장 V-5d7ebf53 |  | 1 (ACT:DMF0042_1_BizPlan.EditButton:642:39) |
| WK-DMF0042-0961 | D3 | FCST_TYPE,FCST_TYPE | 하네스·환경 | D3 도구 오류 — 원장 V-c8f6840e |  | 1 (ACT:DMF0042_3_BizPlan.EditButton:661:35) |
| WK-DMF0042-0962 | D3 | FCST_TYPE,FCST_TYPE | 하네스·환경 | D3 도구 오류 — 원장 V-41b9e6f8 |  | 1 (ACT:DMF0042_3_BizPlan.EditButton:668:39) |
| WK-DMF0042-0963 | D3 | FORECAST_INFO_CELL_MODEL / Cell Model | 하네스·환경 | D3 도구 오류 — 원장 V-a8015b5a ASIS / 원장 V-cffefd2b ASIS / 원장 V-612b6b9f ASIS / 원장 V-42141938 ASIS |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1281:94 ) |
| WK-DMF0042-0964 | D3 | FORECAST_INFO_CELL_MODEL,FORECAST_INFO_C | 하네스·환경 | D3 도구 오류 — 원장 V-a8015b5a |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1281:94) |
| WK-DMF0042-0965 | D3 | FORECAST_INFO_CELL_MODEL,FORECAST_INFO_C | 하네스·환경 | D3 도구 오류 — 원장 V-cffefd2b |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1347:107) |
| WK-DMF0042-0966 | D3 | FORECAST_INFO_CELL_MODEL,FORECAST_INFO_C | 하네스·환경 | D3 도구 오류 — 원장 V-612b6b9f |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1344:94) |
| WK-DMF0042-0967 | D3 | FORECAST_INFO_CELL_MODEL,FORECAST_INFO_C | 하네스·환경 | D3 도구 오류 — 원장 V-42141938 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1056:8) |
| WK-DMF0042-0968 | D3 | FORECAST_INFO_CELL_PACK_COUNT / Cell Pac | 하네스·환경 | D3 도구 오류 — 원장 V-b1da5a43 ASIS / 원장 V-5daea270 ASIS / 원장 V-29035ddb ASIS / 원장 V-9a167a98 ASIS |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1267:80 ) |
| WK-DMF0042-0969 | D3 | FORECAST_INFO_CELL_PACK_COUNT,FORECAST_I | 하네스·환경 | D3 도구 오류 — 원장 V-b1da5a43 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1267:80) |
| WK-DMF0042-0970 | D3 | FORECAST_INFO_CELL_PACK_COUNT,FORECAST_I | 하네스·환경 | D3 도구 오류 — 원장 V-5daea270 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1333:93) |
| WK-DMF0042-0971 | D3 | FORECAST_INFO_CELL_PACK_COUNT,FORECAST_I | 하네스·환경 | D3 도구 오류 — 원장 V-29035ddb |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1330:80) |
| WK-DMF0042-0972 | D3 | FORECAST_INFO_CELL_PACK_COUNT,FORECAST_I | 하네스·환경 | D3 도구 오류 — 원장 V-9a167a98 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1042:7) |
| WK-DMF0042-0973 | D3 | FORECAST_INFO_PRODUCT_GROUP / Product Gr | 하네스·환경 | D3 도구 오류 — 원장 V-a7ff7075 ASIS / 원장 V-cd28df71 ASIS / 원장 V-6e9c3a44 ASIS / 원장 V-9687ca5f ASIS |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1265:78 ) |
| WK-DMF0042-0974 | D3 | FORECAST_INFO_PRODUCT_GROUP,FORECAST_INF | 하네스·환경 | D3 도구 오류 — 원장 V-a7ff7075 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1265:78) |
| WK-DMF0042-0975 | D3 | FORECAST_INFO_PRODUCT_GROUP,FORECAST_INF | 하네스·환경 | D3 도구 오류 — 원장 V-cd28df71 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1331:91) |
| WK-DMF0042-0976 | D3 | FORECAST_INFO_PRODUCT_GROUP,FORECAST_INF | 하네스·환경 | D3 도구 오류 — 원장 V-6e9c3a44 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1328:78) |
| WK-DMF0042-0977 | D3 | FORECAST_INFO_PRODUCT_GROUP,FORECAST_INF | 하네스·환경 | D3 도구 오류 — 원장 V-9687ca5f |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1040:7) |
| WK-DMF0042-0978 | D3 | FORECAST_INFO_SPEC / Spec & Version | 하네스·환경 | D3 도구 오류 — 원장 V-50e61286 ASIS / 원장 V-a1f7751a ASIS / 원장 V-c21d758e ASIS / 원장 V-0e00ba65 ASIS |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1283:96 ) |
| WK-DMF0042-0979 | D3 | FORECAST_INFO_SPEC,FORECAST_INFO_SPEC | 하네스·환경 | D3 도구 오류 — 원장 V-50e61286 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1283:96) |
| WK-DMF0042-0980 | D3 | FORECAST_INFO_SPEC,FORECAST_INFO_SPEC | 하네스·환경 | D3 도구 오류 — 원장 V-a1f7751a |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1349:109) |
| WK-DMF0042-0981 | D3 | FORECAST_INFO_SPEC,FORECAST_INFO_SPEC | 하네스·환경 | D3 도구 오류 — 원장 V-c21d758e |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1346:96) |
| WK-DMF0042-0982 | D3 | FORECAST_INFO_SPEC,FORECAST_INFO_SPEC | 하네스·환경 | D3 도구 오류 — 원장 V-0e00ba65 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1058:8) |
| WK-DMF0042-0983 | D3 | G1 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 G1 "**비40/무효창 Q_/Y_ 직접입력 잠금** (구현이 개방하던 과잉 교정 — R4' 버킷" 의 D3 355요소: ERROR:342 · NOT_RUN:13 |  | 1 (G1) |
| WK-DMF0042-0984 | D3 | G2 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 G2 '**구 R6 제거** — 기존행 INCO/FCST 조건 개방 블록은 신정본 L651~667' 의 D3 355요소: ERROR:342 · NOT_RUN:13 |  | 1 (G2) |
| WK-DMF0042-0985 | D3 | G4 | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 G4 'Monthly LOC 편집 시 **Q_ 롤업 = 편집셀값 Int copy** (합산·0 아' 의 D3 355요소: ERROR:342 · NOT_RUN:13 |  | 1 (G4) |
| WK-DMF0042-0986 | D3 | INCOTERMS / Rep. Incoterms | 하네스·환경 | D3 도구 오류 — 원장 V-44f1ee40 ASIS / 원장 V-399b852b ASIS / 원장 V-3668a3dd ASIS / 원장 V-17d057f6 ASIS |  | 10 (ACT:DMF0042_1_BizPlan.EditButton ACT:DMF) |
| WK-DMF0042-0987 | D3 | INCOTERMS,INCOTERMS | 하네스·환경 | D3 도구 오류 — 원장 V-44f1ee40 |  | 1 (ACT:DMF0042_1_BizPlan.EditButton:634:34) |
| WK-DMF0042-0988 | D3 | INCOTERMS,INCOTERMS | 하네스·환경 | D3 도구 오류 — 원장 V-399b852b |  | 1 (ACT:DMF0042_1_BizPlan.EditButton:640:37) |
| WK-DMF0042-0989 | D3 | INCOTERMS,INCOTERMS | 하네스·환경 | D3 도구 오류 — 원장 V-3668a3dd |  | 1 (ACT:DMF0042_3_BizPlan.EditButton:660:34) |
| WK-DMF0042-0990 | D3 | INCOTERMS,INCOTERMS | 하네스·환경 | D3 도구 오류 — 원장 V-17d057f6 |  | 1 (ACT:DMF0042_3_BizPlan.EditButton:666:37) |
| WK-DMF0042-0991 | D3 | INTERNAL_YN / Internal Txn | 하네스·환경 | D3 도구 오류 — 원장 V-ed09585e ASIS / 원장 V-0631b851 ASIS / 원장 V-fc49dde8 ASIS / 원장 V-fd94ec64 ASIS |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1275:88 ) |
| WK-DMF0042-0992 | D3 | INTERNAL_YN,INTERNAL_YN | 하네스·환경 | D3 도구 오류 — 원장 V-ed09585e |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1275:88) |
| WK-DMF0042-0993 | D3 | INTERNAL_YN,INTERNAL_YN | 하네스·환경 | D3 도구 오류 — 원장 V-0631b851 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1341:101) |
| WK-DMF0042-0994 | D3 | INTERNAL_YN,INTERNAL_YN | 하네스·환경 | D3 도구 오류 — 원장 V-fc49dde8 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1338:88) |
| WK-DMF0042-0995 | D3 | INTERNAL_YN,INTERNAL_YN | 하네스·환경 | D3 도구 오류 — 원장 V-fd94ec64 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1050:8) |
| WK-DMF0042-0996 | D3 | ITEM_CLASS_NAME / Model Type | 하네스·환경 | D3 도구 오류 — 원장 V-8d22101b ASIS / 원장 V-c4b82561 ASIS / 원장 V-970b172c ASIS / 원장 V-782bc8b5 ASIS |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1250:65 ) |
| WK-DMF0042-0997 | D3 | ITEM_CLASS_NAME,ITEM_CLASS_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-8d22101b |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1250:65) |
| WK-DMF0042-0998 | D3 | ITEM_CLASS_NAME,ITEM_CLASS_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-c4b82561 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1295:63) |
| WK-DMF0042-0999 | D3 | ITEM_CLASS_NAME,ITEM_CLASS_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-970b172c |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1313:65) |
| WK-DMF0042-1000 | D3 | ITEM_CLASS_NAME,ITEM_CLASS_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-782bc8b5 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1028:5) |
| WK-DMF0042-1001 | D3 | ITEM_NAME / Model Name | 하네스·환경 | D3 도구 오류 — 원장 V-2a15cc0b ASIS / 원장 V-e1b4fd41 ASIS / 원장 V-235329a4 ASIS / 원장 V-0bc20709 ASIS |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1252:67 ) |
| WK-DMF0042-1002 | D3 | ITEM_NAME,ITEM_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-2a15cc0b |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1252:67) |
| WK-DMF0042-1003 | D3 | ITEM_NAME,ITEM_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-e1b4fd41 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1297:65) |
| WK-DMF0042-1004 | D3 | ITEM_NAME,ITEM_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-235329a4 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1315:67) |
| WK-DMF0042-1005 | D3 | ITEM_NAME,ITEM_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-0bc20709 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1030:6) |
| WK-DMF0042-1006 | D3 | ITEM_TYPE / Item Type | 하네스·환경 | D3 도구 오류 — 원장 V-9f5f35bf ASIS / 원장 V-bcef4902 ASIS / 원장 V-eeca69ad ASIS / 원장 V-7a4bea94 ASIS |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1254:69 ) |
| WK-DMF0042-1007 | D3 | ITEM_TYPE,ITEM_TYPE | 하네스·환경 | D3 도구 오류 — 원장 V-9f5f35bf |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1254:69) |
| WK-DMF0042-1008 | D3 | ITEM_TYPE,ITEM_TYPE | 하네스·환경 | D3 도구 오류 — 원장 V-bcef4902 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1299:67) |
| WK-DMF0042-1009 | D3 | ITEM_TYPE,ITEM_TYPE | 하네스·환경 | D3 도구 오류 — 원장 V-eeca69ad |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1317:69) |
| WK-DMF0042-1010 | D3 | ITEM_TYPE,ITEM_TYPE | 하네스·환경 | D3 도구 오류 — 원장 V-7a4bea94 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1032:6) |
| WK-DMF0042-1011 | D3 | KWH,KWH | 하네스·환경 | D3 도구 오류 — 원장 V-0099668d |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1307:73) |
| WK-DMF0042-1012 | D3 | MDM_PROJECT_NAME / Project Name | 하네스·환경 | D3 도구 오류 — 원장 V-3d0894f1 ASIS / 원장 V-c44471f2 ASIS / 원장 V-8052d91a ASIS / 원장 V-a8b2ddf3 ASIS |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1285:98 ) |
| WK-DMF0042-1013 | D3 | MDM_PROJECT_NAME,MDM_PROJECT_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-3d0894f1 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1285:98) |
| WK-DMF0042-1014 | D3 | MDM_PROJECT_NAME,MDM_PROJECT_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-c44471f2 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1351:111) |
| WK-DMF0042-1015 | D3 | MDM_PROJECT_NAME,MDM_PROJECT_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-8052d91a |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1348:98) |
| WK-DMF0042-1016 | D3 | MDM_PROJECT_NAME,MDM_PROJECT_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-a8b2ddf3 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1060:9) |
| WK-DMF0042-1017 | D3 | MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-a0155f8f |  | 1 (ACT:DMF0042_1_BizPlan.EditButton:625:32) |
| WK-DMF0042-1018 | D3 | MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-e90bf7ea |  | 1 (ACT:DMF0042_1_BizPlan.EditButton:664:46) |
| WK-DMF0042-1019 | D3 | MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-84cd4e69 |  | 1 (ACT:DMF0042_1_BizPlan.EditButton:670:48) |
| WK-DMF0042-1020 | D3 | MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-351944d8 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1336:136) |
| WK-DMF0042-1021 | D3 | MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-ba862c36 |  | 1 (ACT:DMF0042_2_BizPlan.EditButton:589:24) |
| WK-DMF0042-1022 | D3 | MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-3fbfc321 |  | 1 (ACT:DMF0042_2_BizPlan.EditButton:627:32) |
| WK-DMF0042-1023 | D3 | MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-7a695f0e |  | 1 (ACT:DMF0042_2_BizPlan.EditButton:633:34) |
| WK-DMF0042-1024 | D3 | MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-751c9e1c |  | 1 (ACT:DMF0042_2_BizPlan.InsertRow:1472:40) |
| WK-DMF0042-1025 | D3 | MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-c1a64ecd |  | 1 (ACT:DMF0042_3_BizPlan.EditButton:651:32) |
| WK-DMF0042-1026 | D3 | MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-724297c9 |  | 1 (ACT:DMF0042_3_BizPlan.EditButton:690:46) |
| WK-DMF0042-1027 | D3 | MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-4f782b7a |  | 1 (ACT:DMF0042_3_BizPlan.EditButton:696:48) |
| WK-DMF0042-1028 | D3 | MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-714a9f09 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1400:149) |
| WK-DMF0042-1029 | D3 | MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-5b71d96f |  | 1 (ACT:DMF0042_BizPlan.EditButton:649:29) |
| WK-DMF0042-1030 | D3 | MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-89038ff4 |  | 1 (ACT:DMF0042_BizPlan.EditButton:688:36) |
| WK-DMF0042-1031 | D3 | MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-faea4617 |  | 1 (ACT:DMF0042_BizPlan.EditButton:694:38) |
| WK-DMF0042-1032 | D3 | MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-2cba6272 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1399:136) |
| WK-DMF0042-1033 | D3 | MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-0fdedc9b |  | 1 (ACT:DMF0042_BizPlan_old.EditButton:548:2) |
| WK-DMF0042-1034 | D3 | MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-177dc1f8 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1105:1) |
| WK-DMF0042-1035 | D3 | MEASURE / Measure | 하네스·환경 | D3 도구 오류 — 원장 V-a0155f8f ASIS / 원장 V-e90bf7ea ASIS / 원장 V-84cd4e69 ASIS / 원장 V-2c915447 ASIS / 원장 V-351944d8 ASIS / 원장 V-b2f12416  |  | 53 (InsertRow Measure/수량 잠금 11 (#56~66) ACT:) |
| WK-DMF0042-1036 | D3 | MEASURE,MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-2c915447 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1329:133) |
| WK-DMF0042-1037 | D3 | MEASURE,MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-a2177e2d |  | 1 (ACT:DMF0042_2_BizPlan.InsertRow:1467:37) |
| WK-DMF0042-1038 | D3 | MEASURE,MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-d5b6ec2d |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1395:146) |
| WK-DMF0042-1039 | D3 | MEASURE,MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-39a1c0c6 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1392:133) |
| WK-DMF0042-1040 | D3 | MEASURE,MEASURE | 하네스·환경 | D3 도구 오류 — 원장 V-c9a77af4 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1099:1) |
| WK-DMF0042-1041 | D3 | MIN_CAPACITY / Min Capacity | 하네스·환경 | D3 도구 오류 — 원장 V-e1c9e21d ASIS / 원장 V-ed14de64 ASIS / 원장 V-15665443 ASIS / 원장 V-41fb6514 ASIS |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1287:100) |
| WK-DMF0042-1042 | D3 | MIN_CAPACITY,MIN_CAPACITY | 하네스·환경 | D3 도구 오류 — 원장 V-e1c9e21d |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1287:100) |
| WK-DMF0042-1043 | D3 | MIN_CAPACITY,MIN_CAPACITY | 하네스·환경 | D3 도구 오류 — 원장 V-ed14de64 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1353:113) |
| WK-DMF0042-1044 | D3 | MIN_CAPACITY,MIN_CAPACITY | 하네스·환경 | D3 도구 오류 — 원장 V-15665443 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1350:100) |
| WK-DMF0042-1045 | D3 | MIN_CAPACITY,MIN_CAPACITY | 하네스·환경 | D3 도구 오류 — 원장 V-41fb6514 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1062:9) |
| WK-DMF0042-1046 | D3 | MODULE_PER_CAR / Module/Car | 하네스·환경 | D3 도구 오류 — 원장 V-28c4c136 ASIS / 원장 V-4cb7603b ASIS / 원장 V-09d17701 ASIS |  | 4 (InsertRow 메타 잠금 42 (#14~55) ACT:DMF0042_) |
| WK-DMF0042-1047 | D3 | MODULE_PER_CAR,MODULE_PER_CAR | 하네스·환경 | D3 도구 오류 — 원장 V-28c4c136 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1325:130) |
| WK-DMF0042-1048 | D3 | MODULE_PER_CAR,MODULE_PER_CAR | 하네스·환경 | D3 도구 오류 — 원장 V-4cb7603b |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1391:143) |
| WK-DMF0042-1049 | D3 | MODULE_PER_CAR,MODULE_PER_CAR | 하네스·환경 | D3 도구 오류 — 원장 V-09d17701 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1388:130) |
| WK-DMF0042-1050 | D3 | MODULE_PER_PACK / Module/Pack | 하네스·환경 | D3 도구 오류 — 원장 V-075030e7 ASIS |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1319:84) |
| WK-DMF0042-1051 | D3 | MODULE_PER_PACK,MODULE_PER_PACK | 하네스·환경 | D3 도구 오류 — 원장 V-075030e7 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1319:84) |
| WK-DMF0042-1052 | D3 | NICK_NAME / Nick Name | 하네스·환경 | D3 도구 오류 — 원장 V-05cc7b00 ASIS / 원장 V-c26cf45f ASIS / 원장 V-b3ff4396 ASIS / 원장 V-5189ca5e ASIS |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1256:71 ) |
| WK-DMF0042-1053 | D3 | NICK_NAME,NICK_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-05cc7b00 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1256:71) |
| WK-DMF0042-1054 | D3 | NICK_NAME,NICK_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-c26cf45f |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1301:69) |
| WK-DMF0042-1055 | D3 | NICK_NAME,NICK_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-b3ff4396 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1319:71) |
| WK-DMF0042-1056 | D3 | NICK_NAME,NICK_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-5189ca5e |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1034:6) |
| WK-DMF0042-1057 | D3 | OWNER / Owner | 하네스·환경 | D3 도구 오류 — 원장 V-9f6dc653 ASIS / 원장 V-785bc64d ASIS / 원장 V-20671d62 ASIS / 원장 V-f9310ca8 ASIS |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1238:55 ) |
| WK-DMF0042-1058 | D3 | OWNER,OWNER | 하네스·환경 | D3 도구 오류 — 원장 V-9f6dc653 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1238:55) |
| WK-DMF0042-1059 | D3 | OWNER,OWNER | 하네스·환경 | D3 도구 오류 — 원장 V-785bc64d |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1283:53) |
| WK-DMF0042-1060 | D3 | OWNER,OWNER | 하네스·환경 | D3 도구 오류 — 원장 V-20671d62 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1301:55) |
| WK-DMF0042-1061 | D3 | OWNER,OWNER | 하네스·환경 | D3 도구 오류 — 원장 V-f9310ca8 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1016:4) |
| WK-DMF0042-1062 | D3 | PLANT_SITE_ID / Plant Site | 하네스·환경 | D3 도구 오류 — 원장 V-cb187025 ASIS / 원장 V-df6ad4cd ASIS / 원장 V-d86bfeaf ASIS / 원장 V-a1af73f4 ASIS |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1260:74 ) |
| WK-DMF0042-1063 | D3 | PLANT_SITE_ID,PLANT_SITE_ID | 하네스·환경 | D3 도구 오류 — 원장 V-cb187025 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1260:74) |
| WK-DMF0042-1064 | D3 | PLANT_SITE_ID,PLANT_SITE_ID | 하네스·환경 | D3 도구 오류 — 원장 V-df6ad4cd |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1326:87) |
| WK-DMF0042-1065 | D3 | PLANT_SITE_ID,PLANT_SITE_ID | 하네스·환경 | D3 도구 오류 — 원장 V-d86bfeaf |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1323:74) |
| WK-DMF0042-1066 | D3 | PLANT_SITE_ID,PLANT_SITE_ID | 하네스·환경 | D3 도구 오류 — 원장 V-a1af73f4 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1036:6) |
| WK-DMF0042-1067 | D3 | PRIORITY / Priority | 하네스·환경 | D3 도구 오류 — 원장 V-c9d3ede6 ASIS / 원장 V-e42a1dc7 ASIS / 원장 V-b593741e ASIS / 원장 V-4ab3656e ASIS |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1297:104) |
| WK-DMF0042-1068 | D3 | PRIORITY,PRIORITY | 하네스·환경 | D3 도구 오류 — 원장 V-c9d3ede6 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1297:104) |
| WK-DMF0042-1069 | D3 | PRIORITY,PRIORITY | 하네스·환경 | D3 도구 오류 — 원장 V-e42a1dc7 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1363:117) |
| WK-DMF0042-1070 | D3 | PRIORITY,PRIORITY | 하네스·환경 | D3 도구 오류 — 원장 V-b593741e |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1360:104) |
| WK-DMF0042-1071 | D3 | PRIORITY,PRIORITY | 하네스·환경 | D3 도구 오류 — 원장 V-4ab3656e |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1072:9) |
| WK-DMF0042-1072 | D3 | PRODUCT_GROUP_NAME / Product Group Name | 하네스·환경 | D3 도구 오류 — 원장 V-3d74f8e5 ASIS / 원장 V-3696216c ASIS / 원장 V-653bb94f ASIS / 원장 V-bfb38f64 ASIS |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1269:82 ) |
| WK-DMF0042-1073 | D3 | PRODUCT_GROUP_NAME,PRODUCT_GROUP_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-3d74f8e5 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1269:82) |
| WK-DMF0042-1074 | D3 | PRODUCT_GROUP_NAME,PRODUCT_GROUP_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-3696216c |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1335:95) |
| WK-DMF0042-1075 | D3 | PRODUCT_GROUP_NAME,PRODUCT_GROUP_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-653bb94f |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1332:82) |
| WK-DMF0042-1076 | D3 | PRODUCT_GROUP_NAME,PRODUCT_GROUP_NAME | 하네스·환경 | D3 도구 오류 — 원장 V-bfb38f64 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1044:7) |
| WK-DMF0042-1077 | D3 | PROJECT_CODE / Project Code | 하네스·환경 | D3 도구 오류 — 원장 V-a6c1f595 ASIS / 원장 V-989e15cf ASIS / 원장 V-3a364fa4 ASIS / 원장 V-35c0b257 ASIS / 원장 V-83df1cdf ASIS |  | 5 (ACT:DMF0042_1_BizPlan.InsertRow:1230:49 ) |
| WK-DMF0042-1078 | D3 | PROJECT_CODE,PROJECT_CODE | 하네스·환경 | D3 도구 오류 — 원장 V-a6c1f595 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1230:49) |
| WK-DMF0042-1079 | D3 | PROJECT_CODE,PROJECT_CODE | 하네스·환경 | D3 도구 오류 — 원장 V-989e15cf |  | 1 (ACT:DMF0042_2_BizPlan.InsertRow:1373:32) |
| WK-DMF0042-1080 | D3 | PROJECT_CODE,PROJECT_CODE | 하네스·환경 | D3 도구 오류 — 원장 V-3a364fa4 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1275:47) |
| WK-DMF0042-1081 | D3 | PROJECT_CODE,PROJECT_CODE | 하네스·환경 | D3 도구 오류 — 원장 V-35c0b257 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1293:49) |
| WK-DMF0042-1082 | D3 | PROJECT_CODE,PROJECT_CODE | 하네스·환경 | D3 도구 오류 — 원장 V-83df1cdf |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1008:4) |
| WK-DMF0042-1083 | D3 | REPORT_GROUP1 / Application Gr. | 하네스·환경 | D3 도구 오류 — 원장 V-26387f91 ASIS / 원장 V-f191bccd ASIS / 원장 V-3a2d9c41 ASIS / 원장 V-3184e58e ASIS |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1303:110) |
| WK-DMF0042-1084 | D3 | REPORT_GROUP1,REPORT_GROUP1 | 하네스·환경 | D3 도구 오류 — 원장 V-26387f91 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1303:110) |
| WK-DMF0042-1085 | D3 | REPORT_GROUP1,REPORT_GROUP1 | 하네스·환경 | D3 도구 오류 — 원장 V-f191bccd |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1369:123) |
| WK-DMF0042-1086 | D3 | REPORT_GROUP1,REPORT_GROUP1 | 하네스·환경 | D3 도구 오류 — 원장 V-3a2d9c41 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1366:110) |
| WK-DMF0042-1087 | D3 | REPORT_GROUP1,REPORT_GROUP1 | 하네스·환경 | D3 도구 오류 — 원장 V-3184e58e |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1078:1) |
| WK-DMF0042-1088 | D3 | REPORT_GROUP2 / Cust. (Report | 하네스·환경 | D3 도구 오류 — 원장 V-009626f1 ASIS / 원장 V-2def49d9 ASIS / 원장 V-627a5b35 ASIS / 원장 V-ff9466de ASIS |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1305:112) |
| WK-DMF0042-1089 | D3 | REPORT_GROUP2,REPORT_GROUP2 | 하네스·환경 | D3 도구 오류 — 원장 V-009626f1 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1305:112) |
| WK-DMF0042-1090 | D3 | REPORT_GROUP2,REPORT_GROUP2 | 하네스·환경 | D3 도구 오류 — 원장 V-2def49d9 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1371:125) |
| WK-DMF0042-1091 | D3 | REPORT_GROUP2,REPORT_GROUP2 | 하네스·환경 | D3 도구 오류 — 원장 V-627a5b35 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1368:112) |
| WK-DMF0042-1092 | D3 | REPORT_GROUP2,REPORT_GROUP2 | 하네스·환경 | D3 도구 오류 — 원장 V-ff9466de |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1080:1) |
| WK-DMF0042-1093 | D3 | REPORT_GROUP3 / Product Gr.(Report | 하네스·환경 | D3 도구 오류 — 원장 V-acee7688 ASIS / 원장 V-0c7d515b ASIS / 원장 V-2a129cf7 ASIS / 원장 V-dd7349fe ASIS |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1307:114) |
| WK-DMF0042-1094 | D3 | REPORT_GROUP3,REPORT_GROUP3 | 하네스·환경 | D3 도구 오류 — 원장 V-acee7688 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1307:114) |
| WK-DMF0042-1095 | D3 | REPORT_GROUP3,REPORT_GROUP3 | 하네스·환경 | D3 도구 오류 — 원장 V-0c7d515b |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1373:127) |
| WK-DMF0042-1096 | D3 | REPORT_GROUP3,REPORT_GROUP3 | 하네스·환경 | D3 도구 오류 — 원장 V-2a129cf7 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1370:114) |
| WK-DMF0042-1097 | D3 | REPORT_GROUP3,REPORT_GROUP3 | 하네스·환경 | D3 도구 오류 — 원장 V-dd7349fe |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1082:1) |
| WK-DMF0042-1098 | D3 | REPORT_GROUP4 / Product Details.(Report | 하네스·환경 | D3 도구 오류 — 원장 V-83f1c624 ASIS / 원장 V-964cfe20 ASIS / 원장 V-8b902401 ASIS / 원장 V-c8fd9b5c ASIS |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1309:116) |
| WK-DMF0042-1099 | D3 | REPORT_GROUP4,REPORT_GROUP4 | 하네스·환경 | D3 도구 오류 — 원장 V-83f1c624 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1309:116) |
| WK-DMF0042-1100 | D3 | REPORT_GROUP4,REPORT_GROUP4 | 하네스·환경 | D3 도구 오류 — 원장 V-964cfe20 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1375:129) |
| WK-DMF0042-1101 | D3 | REPORT_GROUP4,REPORT_GROUP4 | 하네스·환경 | D3 도구 오류 — 원장 V-8b902401 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1372:116) |
| WK-DMF0042-1102 | D3 | REPORT_GROUP4,REPORT_GROUP4 | 하네스·환경 | D3 도구 오류 — 원장 V-c8fd9b5c |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1084:1) |
| WK-DMF0042-1103 | D3 | REPORT_GROUP5 / Cyl Gr. (Report | 하네스·환경 | D3 도구 오류 — 원장 V-ca8d2269 ASIS / 원장 V-71d9b608 ASIS / 원장 V-89d56c4a ASIS / 원장 V-1f3c1331 ASIS |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1311:118) |
| WK-DMF0042-1104 | D3 | REPORT_GROUP5,REPORT_GROUP5 | 하네스·환경 | D3 도구 오류 — 원장 V-ca8d2269 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1311:118) |
| WK-DMF0042-1105 | D3 | REPORT_GROUP5,REPORT_GROUP5 | 하네스·환경 | D3 도구 오류 — 원장 V-71d9b608 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1377:131) |
| WK-DMF0042-1106 | D3 | REPORT_GROUP5,REPORT_GROUP5 | 하네스·환경 | D3 도구 오류 — 원장 V-89d56c4a |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1374:118) |
| WK-DMF0042-1107 | D3 | REPORT_GROUP5,REPORT_GROUP5 | 하네스·환경 | D3 도구 오류 — 원장 V-1f3c1331 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1086:1) |
| WK-DMF0042-1108 | D3 | REPORT_GROUP6 / Cell Model Info | 하네스·환경 | D3 도구 오류 — 원장 V-e3aad76c ASIS / 원장 V-ad5123e2 ASIS / 원장 V-0df6c30a ASIS / 원장 V-0f94ad4e ASIS |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1313:120) |
| WK-DMF0042-1109 | D3 | REPORT_GROUP6,REPORT_GROUP6 | 하네스·환경 | D3 도구 오류 — 원장 V-e3aad76c |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1313:120) |
| WK-DMF0042-1110 | D3 | REPORT_GROUP6,REPORT_GROUP6 | 하네스·환경 | D3 도구 오류 — 원장 V-ad5123e2 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1379:133) |
| WK-DMF0042-1111 | D3 | REPORT_GROUP6,REPORT_GROUP6 | 하네스·환경 | D3 도구 오류 — 원장 V-0df6c30a |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1376:120) |
| WK-DMF0042-1112 | D3 | REPORT_GROUP6,REPORT_GROUP6 | 하네스·환경 | D3 도구 오류 — 원장 V-0f94ad4e |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1088:1) |
| WK-DMF0042-1113 | D3 | REPORT_GROUP7,REPORT_GROUP7 | 하네스·환경 | D3 도구 오류 — 원장 V-7241f60b |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1315:122) |
| WK-DMF0042-1114 | D3 | REPORT_GROUP7,REPORT_GROUP7 | 하네스·환경 | D3 도구 오류 — 원장 V-dafde4cc |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1381:135) |
| WK-DMF0042-1115 | D3 | REPORT_GROUP7,REPORT_GROUP7 | 하네스·환경 | D3 도구 오류 — 원장 V-f064c63e |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1378:122) |
| WK-DMF0042-1116 | D3 | REPORT_GROUP7,REPORT_GROUP7 | 하네스·환경 | D3 도구 오류 — 원장 V-570efe83 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1090:1) |
| WK-DMF0042-1117 | D3 | REPORT_GROUP8,REPORT_GROUP8 | 하네스·환경 | D3 도구 오류 — 원장 V-6a268c09 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1317:124) |
| WK-DMF0042-1118 | D3 | REPORT_GROUP8,REPORT_GROUP8 | 하네스·환경 | D3 도구 오류 — 원장 V-9cdb17e7 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1383:137) |
| WK-DMF0042-1119 | D3 | REPORT_GROUP8,REPORT_GROUP8 | 하네스·환경 | D3 도구 오류 — 원장 V-6d987603 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1380:124) |
| WK-DMF0042-1120 | D3 | REPORT_GROUP8,REPORT_GROUP8 | 하네스·환경 | D3 도구 오류 — 원장 V-ca2a7a46 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1092:1) |
| WK-DMF0042-1121 | D3 | ROUTE / Route | 하네스·환경 | D3 도구 오류 — 원장 V-6d5663da ASIS / 원장 V-4bf17a94 ASIS / 원장 V-fe8e9952 ASIS / 원장 V-209dc917 ASIS |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1242:59 ) |
| WK-DMF0042-1122 | D3 | ROUTE,ROUTE | 하네스·환경 | D3 도구 오류 — 원장 V-6d5663da |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1242:59) |
| WK-DMF0042-1123 | D3 | ROUTE,ROUTE | 하네스·환경 | D3 도구 오류 — 원장 V-4bf17a94 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1287:57) |
| WK-DMF0042-1124 | D3 | ROUTE,ROUTE | 하네스·환경 | D3 도구 오류 — 원장 V-fe8e9952 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1305:59) |
| WK-DMF0042-1125 | D3 | ROUTE,ROUTE | 하네스·환경 | D3 도구 오류 — 원장 V-209dc917 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1020:5) |
| WK-DMF0042-1126 | D3 | SHIPTO_DESCRIPTION / Ship To Description | 하네스·환경 | D3 도구 오류 — 원장 V-67dd5ea3 ASIS / 원장 V-de09a2ea ASIS / 원장 V-fec48d73 ASIS / 원장 V-dd6c8aab ASIS |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1271:84 ) |
| WK-DMF0042-1127 | D3 | SHIPTO_DESCRIPTION,SHIPTO_DESCRIPTION | 하네스·환경 | D3 도구 오류 — 원장 V-67dd5ea3 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1271:84) |
| WK-DMF0042-1128 | D3 | SHIPTO_DESCRIPTION,SHIPTO_DESCRIPTION | 하네스·환경 | D3 도구 오류 — 원장 V-de09a2ea |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1337:97) |
| WK-DMF0042-1129 | D3 | SHIPTO_DESCRIPTION,SHIPTO_DESCRIPTION | 하네스·환경 | D3 도구 오류 — 원장 V-fec48d73 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1334:84) |
| WK-DMF0042-1130 | D3 | SHIPTO_DESCRIPTION,SHIPTO_DESCRIPTION | 하네스·환경 | D3 도구 오류 — 원장 V-dd6c8aab |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1046:7) |
| WK-DMF0042-1131 | D3 | SUM 헤더 5 (#1~5) | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 SUM 헤더 5 (#1~5) 'SetSpreadHeaderSpan — Y_ 연 SUM(2단 세로 span) + Q_ 분기' 의 D3 355요소: ERROR:342 · NOT_RUN:13 |  | 1 (SUM 헤더 5 (#1~5)) |
| WK-DMF0042-1132 | D3 | VERSION_NO / Version | 하네스·환경 | D3 도구 오류 — 원장 V-e8878792 ASIS / 원장 V-8ab94674 ASIS / 원장 V-4c527254 ASIS / 원장 V-76947a02 ASIS |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1263:76 ) |
| WK-DMF0042-1133 | D3 | VERSION_NO,VERSION_NO | 하네스·환경 | D3 도구 오류 — 원장 V-e8878792 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1263:76) |
| WK-DMF0042-1134 | D3 | VERSION_NO,VERSION_NO | 하네스·환경 | D3 도구 오류 — 원장 V-8ab94674 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1329:89) |
| WK-DMF0042-1135 | D3 | VERSION_NO,VERSION_NO | 하네스·환경 | D3 도구 오류 — 원장 V-4c527254 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1326:76) |
| WK-DMF0042-1136 | D3 | VERSION_NO,VERSION_NO | 하네스·환경 | D3 도구 오류 — 원장 V-76947a02 |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1038:6) |
| WK-DMF0042-1137 | D3 | VMI_YN / VMI | 하네스·환경 | D3 도구 오류 — 원장 V-1f73066c ASIS / 원장 V-43855815 ASIS / 원장 V-9dbc3120 ASIS / 원장 V-57f8e51f ASIS |  | 4 (ACT:DMF0042_1_BizPlan.InsertRow:1289:102) |
| WK-DMF0042-1138 | D3 | VMI_YN,VMI_YN | 하네스·환경 | D3 도구 오류 — 원장 V-1f73066c |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1289:102) |
| WK-DMF0042-1139 | D3 | VMI_YN,VMI_YN | 하네스·환경 | D3 도구 오류 — 원장 V-43855815 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1355:115) |
| WK-DMF0042-1140 | D3 | VMI_YN,VMI_YN | 하네스·환경 | D3 도구 오류 — 원장 V-9dbc3120 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1352:102) |
| WK-DMF0042-1141 | D3 | VMI_YN,VMI_YN | 하네스·환경 | D3 도구 오류 — 원장 V-57f8e51f |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1064:9) |
| WK-DMF0042-1142 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-e326549b |  | 1 (ACT:DMF0042_1_BizPlan.EditButton:561:11) |
| WK-DMF0042-1143 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-6034d283 |  | 1 (ACT:DMF0042_1_BizPlan.EditButton:569:14) |
| WK-DMF0042-1144 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-363e14bc |  | 1 (ACT:DMF0042_1_BizPlan.EditButton:577:17) |
| WK-DMF0042-1145 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-fab6bc61 |  | 1 (ACT:DMF0042_1_BizPlan.EditButton:585:20) |
| WK-DMF0042-1146 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-92a7fbc9 |  | 1 (ACT:DMF0042_1_BizPlan.EditButton:590:21) |
| WK-DMF0042-1147 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-77a5a56b |  | 1 (ACT:DMF0042_1_BizPlan.EditButton:597:24) |
| WK-DMF0042-1148 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-ffa97ddf |  | 1 (ACT:DMF0042_1_BizPlan.EditButton:605:27) |
| WK-DMF0042-1149 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-02c37671 |  | 1 (ACT:DMF0042_1_BizPlan.EditButton:610:28) |
| WK-DMF0042-1150 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-af42cc69 |  | 1 (ACT:DMF0042_1_RTF.Select_DpInit_Data:129) |
| WK-DMF0042-1151 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-770aab80 |  | 1 (ACT:DMF0042_1_RTF.Select_DpResult_Data:1) |
| WK-DMF0042-1152 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-b5eb95a2 |  | 1 (ACT:DMF0042_2_BizPlan.EditButton:557:11) |
| WK-DMF0042-1153 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-45a867d9 |  | 1 (ACT:DMF0042_2_BizPlan.EditButton:563:15) |
| WK-DMF0042-1154 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-7cab4105 |  | 1 (ACT:DMF0042_2_BizPlan.EditButton:566:16) |
| WK-DMF0042-1155 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-18ad7fc4 |  | 1 (ACT:DMF0042_2_BizPlan.EditButton:572:19) |
| WK-DMF0042-1156 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-9395d93c |  | 1 (ACT:DMF0042_2_BizPlan.EditButton:575:20) |
| WK-DMF0042-1157 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-1877323e |  | 1 (ACT:DMF0042_3_BizPlan.EditButton:587:11) |
| WK-DMF0042-1158 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-f5ef5906 |  | 1 (ACT:DMF0042_3_BizPlan.EditButton:595:14) |
| WK-DMF0042-1159 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-35b9641a |  | 1 (ACT:DMF0042_3_BizPlan.EditButton:603:17) |
| WK-DMF0042-1160 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-a43d2526 |  | 1 (ACT:DMF0042_3_BizPlan.EditButton:611:20) |
| WK-DMF0042-1161 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-ecd9625c |  | 1 (ACT:DMF0042_3_BizPlan.EditButton:616:21) |
| WK-DMF0042-1162 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-8cb9df36 |  | 1 (ACT:DMF0042_3_BizPlan.EditButton:623:24) |
| WK-DMF0042-1163 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-3d7ded35 |  | 1 (ACT:DMF0042_3_BizPlan.EditButton:631:27) |
| WK-DMF0042-1164 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-462f92ad |  | 1 (ACT:DMF0042_3_BizPlan.EditButton:636:28) |
| WK-DMF0042-1165 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-f7af37e1 |  | 1 (ACT:DMF0042_BizPlan.EditButton:585:8) |
| WK-DMF0042-1166 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-d327cc68 |  | 1 (ACT:DMF0042_BizPlan.EditButton:593:11) |
| WK-DMF0042-1167 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-504cddb6 |  | 1 (ACT:DMF0042_BizPlan.EditButton:601:14) |
| WK-DMF0042-1168 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-c15b5f82 |  | 1 (ACT:DMF0042_BizPlan.EditButton:609:17) |
| WK-DMF0042-1169 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-67544cbf |  | 1 (ACT:DMF0042_BizPlan.EditButton:614:18) |
| WK-DMF0042-1170 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-f54ca620 |  | 1 (ACT:DMF0042_BizPlan.EditButton:621:21) |
| WK-DMF0042-1171 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-ff842882 |  | 1 (ACT:DMF0042_BizPlan.EditButton:629:24) |
| WK-DMF0042-1172 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-cd2ca248 |  | 1 (ACT:DMF0042_BizPlan.EditButton:634:25) |
| WK-DMF0042-1173 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-ea268706 |  | 1 (ACT:DMF0042_BizPlan_old.EditButton:530:1) |
| WK-DMF0042-1174 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-c490a7a9 |  | 1 (ACT:DMF0042_BizPlan_old.EditButton:535:1) |
| WK-DMF0042-1175 | D3 | siMain.LockColumn | 하네스·환경 | D3 도구 오류 — 원장 V-ca712f4a |  | 1 (ACT:DMF0042_BizPlan_old.EditButton:540:1) |
| WK-DMF0042-1176 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-a8a42c6a |  | 1 (ACT:DMF0042_1_BizPlan.EditButton:656:45) |
| WK-DMF0042-1177 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-b869716e |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1346:140) |
| WK-DMF0042-1178 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-0cefb37e |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1354:143) |
| WK-DMF0042-1179 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-94b41182 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1362:146) |
| WK-DMF0042-1180 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-d2a94b62 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1370:149) |
| WK-DMF0042-1181 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-a7668366 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1375:150) |
| WK-DMF0042-1182 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-341fe976 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1382:153) |
| WK-DMF0042-1183 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-e1f381b3 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1390:156) |
| WK-DMF0042-1184 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-10275333 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1395:157) |
| WK-DMF0042-1185 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-b2f12416 |  | 1 (ACT:DMF0042_1_BizPlan.InsertRow:1406:162) |
| WK-DMF0042-1186 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-22b95950 |  | 1 (ACT:DMF0042_2_BizPlan.EditButton:605:31) |
| WK-DMF0042-1187 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-d0c9b7a4 |  | 1 (ACT:DMF0042_2_BizPlan.InsertRow:1482:44) |
| WK-DMF0042-1188 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-8b4b3e70 |  | 1 (ACT:DMF0042_2_BizPlan.InsertRow:1488:47) |
| WK-DMF0042-1189 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-a7705144 |  | 1 (ACT:DMF0042_2_BizPlan.InsertRow:1493:48) |
| WK-DMF0042-1190 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-6b30d62b |  | 1 (ACT:DMF0042_2_BizPlan.InsertRow:1500:51) |
| WK-DMF0042-1191 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-362e38a7 |  | 1 (ACT:DMF0042_2_BizPlan.InsertRow:1505:52) |
| WK-DMF0042-1192 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-60014812 |  | 1 (ACT:DMF0042_2_BizPlan.InsertRow:1518:58) |
| WK-DMF0042-1193 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-8c87cf7f |  | 1 (ACT:DMF0042_3_BizPlan.EditButton:682:45) |
| WK-DMF0042-1194 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-74f78bd1 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1410:153) |
| WK-DMF0042-1195 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-d30e9cb3 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1418:156) |
| WK-DMF0042-1196 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-a0084413 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1426:159) |
| WK-DMF0042-1197 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-a622a2a8 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1434:162) |
| WK-DMF0042-1198 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-a5a16a23 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1439:163) |
| WK-DMF0042-1199 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-b76a9bf9 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1446:166) |
| WK-DMF0042-1200 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-66fb1927 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1454:169) |
| WK-DMF0042-1201 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-c48d01f8 |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1459:170) |
| WK-DMF0042-1202 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-61b90dcd |  | 1 (ACT:DMF0042_3_BizPlan.InsertRow:1470:175) |
| WK-DMF0042-1203 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-5b798614 |  | 1 (ACT:DMF0042_BizPlan.EditButton:680:35) |
| WK-DMF0042-1204 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-7355779d |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1409:140) |
| WK-DMF0042-1205 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-5d8eb272 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1417:143) |
| WK-DMF0042-1206 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-a9a92c1e |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1425:146) |
| WK-DMF0042-1207 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-910b4706 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1433:149) |
| WK-DMF0042-1208 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-6f4157d9 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1438:150) |
| WK-DMF0042-1209 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-349ba015 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1445:153) |
| WK-DMF0042-1210 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-31ba5170 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1453:156) |
| WK-DMF0042-1211 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-26b2f700 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1458:157) |
| WK-DMF0042-1212 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-5eea7981 |  | 1 (ACT:DMF0042_BizPlan.InsertRow:1469:162) |
| WK-DMF0042-1213 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-c91585f3 |  | 1 (ACT:DMF0042_BizPlan_old.EditButton:560:2) |
| WK-DMF0042-1214 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-6131c08d |  | 1 (ACT:DMF0042_BizPlan_old.EditButton:567:2) |
| WK-DMF0042-1215 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-b317b3cb |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1115:1) |
| WK-DMF0042-1216 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-514d937b |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1121:1) |
| WK-DMF0042-1217 | D3 | siMain.LockRange | 하네스·환경 | D3 도구 오류 — 원장 V-fe3265fe |  | 1 (ACT:DMF0042_BizPlan_old.InsertRow:1127:1) |
| WK-DMF0042-1218 | D3 | siMain.SwitchLock | 하네스·환경 | D3 도구 오류 — 원장 V-5c68d53e |  | 1 (ACT:DMF0042_1_BizPlan.EditButton:553:7) |
| WK-DMF0042-1219 | D3 | siMain.SwitchLock | 하네스·환경 | D3 도구 오류 — 원장 V-412a0479 |  | 1 (ACT:DMF0042_2_BizPlan.EditButton:549:7) |
| WK-DMF0042-1220 | D3 | siMain.SwitchLock | 하네스·환경 | D3 도구 오류 — 원장 V-99c87338 |  | 1 (ACT:DMF0042_3_BizPlan.EditButton:579:7) |
| WK-DMF0042-1221 | D3 | siMain.SwitchLock | 하네스·환경 | D3 도구 오류 — 원장 V-82d47962 |  | 1 (ACT:DMF0042_BizPlan.EditButton:577:4) |
| WK-DMF0042-1222 | D3 | siMain.SwitchLock | 하네스·환경 | D3 도구 오류 — 원장 V-f67463ac |  | 1 (ACT:DMF0042_BizPlan_old.EditButton:522:6) |
| WK-DMF0042-1223 | D3 | siMain.SwitchLock | 하네스·환경 | D3 도구 오류 — 원장 V-9399c6e3 |  | 1 (ACT:DMF0042_ExchangeRatePopup.EditButton) |
| WK-DMF0042-1224 | D3 | 버튼 가드 6 (#42/43/45/97~99) | 하네스·환경 | D3 도구 오류 — 행 집계 — 대조표 버튼 가드 6 (#42/43/45/97~99) 'CutOff·Replace 인라인 "Edit Mode is not allowed."×3 /' 의 D3 355요소: ERROR:342 · NOT_R |  | 1 (버튼 가드 6 (#42/43/45/97~99)) |
| WK-DMF0042-1225 | D4 | 21 | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 21 'InsertButton → InsertRow (L1150~1417)' 의 D4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (21) |
| WK-DMF0042-1226 | D4 | Insert (F8) | 하네스·환경 | D4 도구 오류 — 행 집계 — 대조표 Insert (F8) 'hotkeyConfig.insert → handleInsert (Measure 블록 삽입 ' 의 D4 3요소: NOT_RUN:3 (미실행 요소가 남아 판정필요) |  | 1 (Insert (F8)) |
| WK-DMF0042-1227 | D5 | DEPT_ID / Team | 하네스·환경 | D5 도구 오류 — 원장 V-eda6f709 COLUMN |  | 5 (ACT:DMF0042_1_BizPlan.InsertRow:1196:27 ) |
| WK-DMF0042-1228 | D5 | DEPT_ID40 / Team | 하네스·환경 | D5 도구 오류 — 원장 V-3c3af6ad COLUMN |  | 10 (16 ACT:DMF0042_1_BizPlan.InsertRow:1194:) |
| WK-DMF0042-1229 | D5 | DMF0042_2_BizPlan.CreateSpread | 하네스·환경 | D5 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.CreateSpread 의 D5 23요소: NOT_RUN:17 · ERROR:6 |  | 4 (ACT:DMF0042_2_BizPlan.CreateSpread:355:1) |
| WK-DMF0042-1230 | D5 | DMF0042_2_BizPlan.SetSpreadColumn | 하네스·환경 | D5 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.SetSpreadColumn 의 D5 1요소: ERROR:1 |  | 1 (ACT:DMF0042_2_BizPlan.SetSpreadColumn:46) |
| WK-DMF0042-1231 | D5 | DMF0042_2_BizPlan.SetSpreadHeaderSpan | 하네스·환경 | D5 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.SetSpreadHeaderSpan 의 D5 5요소: NOT_RUN:4 · ERROR:1 |  | 13 (ACT:DMF0042_2_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-1232 | D5 | END_CUSTOMER / End Customer | 하네스·환경 | D5 도구 오류 — 원장 V-1dac9a5c COLUMN |  | 7 (ACT:DMF0042_1_BizPlan.InsertRow:1198:29 ) |
| WK-DMF0042-1233 | D5 | END_CUSTOMER40 / End Customer | 하네스·환경 | D5 도구 오류 — 원장 V-b5d71235 COLUMN |  | 14 (16 ACT:DMF0042_1_BizPlan.InsertRow:1200:) |
| WK-DMF0042-1234 | D5 | MEASURE / Measure | 하네스·환경 | D5 도구 오류 — 원장 V-281c4075 COLUMN |  | 32 (ACT:DMF0042_1_BizPlan.SetSpreadColumn AC) |
| WK-DMF0042-1235 | D5 | SCM_SITE_ID40 / Sales Site | 하네스·환경 | D5 도구 오류 — 원장 V-96c3bfd6 COLUMN |  | 11 (16 ACT:DMF0042_1_BizPlan.InsertRow:1202:) |
| WK-DMF0042-1236 | D6 | DMF0042 화면 | 하네스·환경 | D6 도구 오류 — 원장 V-8f6f77e2 RULE_SCREEN / 원장 V-7bef41b0 RULE_SCREEN / 원장 V-0d56a371 RULE_SCREEN / 원장 V-84bbc1ac DEFECT / 원장 V-43a5504 |  | 15 (G8 Insert (F8) 21 ACT:DMF0042_1_BizPlan.) |
| WK-DMF0042-1237 | E4 | (동적 메시지) | 하네스·환경 | E4 도구 오류 — 원장 V-e5ff6942 |  | 1 (ACT:DMF0042_1_BizPlan.SaveData:1138:177) |
| WK-DMF0042-1238 | E4 | (동적 메시지) | 하네스·환경 | E4 도구 오류 — 원장 V-a6250c91 |  | 1 (ACT:DMF0042_1_BizPlan.btnCutOff_Click:28) |
| WK-DMF0042-1239 | E4 | (동적 메시지) | 하네스·환경 | E4 도구 오류 — 원장 V-e454dd3e |  | 1 (ACT:DMF0042_1_BizPlan.btnReplace_Click:3) |
| WK-DMF0042-1240 | E4 | (동적 메시지) | 하네스·환경 | E4 도구 오류 — 원장 V-091c56e6 |  | 1 (ACT:DMF0042_1_BizPlan.btnReplace_Click:3) |
| WK-DMF0042-1241 | E4 | (동적 메시지) | 하네스·환경 | E4 도구 오류 — 원장 V-1c747249 |  | 1 (ACT:DMF0042_1_BizPlan.btnReplace_Click:3) |
| WK-DMF0042-1242 | E4 | (동적 메시지) | 하네스·환경 | E4 도구 오류 — 원장 V-c89b6499 |  | 1 (ACT:DMF0042_1_BizPlan.btnSetPrice_Click:) |
| WK-DMF0042-1243 | E4 | (동적 메시지) | 하네스·환경 | E4 도구 오류 — 원장 V-5ee5ef4b |  | 1 (ACT:DMF0042_2_BizPlan.SaveData:1290:248) |
| WK-DMF0042-1244 | E4 | (동적 메시지) | 하네스·환경 | E4 도구 오류 — 원장 V-bb14bf07 |  | 1 (ACT:DMF0042_2_BizPlan.btnCutOff_Click:30) |
| WK-DMF0042-1245 | E4 | (동적 메시지) | 하네스·환경 | E4 도구 오류 — 원장 V-eaf8b6ef |  | 1 (ACT:DMF0042_2_BizPlan.btnReplace_Click:3) |
| WK-DMF0042-1246 | E4 | (동적 메시지) | 하네스·환경 | E4 도구 오류 — 원장 V-1a3b5c71 |  | 1 (ACT:DMF0042_2_BizPlan.btnReplace_Click:3) |
| WK-DMF0042-1247 | E4 | (동적 메시지) | 하네스·환경 | E4 도구 오류 — 원장 V-cc4e3859 |  | 1 (ACT:DMF0042_2_BizPlan.btnReplace_Click:3) |
| WK-DMF0042-1248 | E4 | (동적 메시지) | 하네스·환경 | E4 도구 오류 — 원장 V-52305e72 |  | 1 (ACT:DMF0042_2_BizPlan.btnSetPrice_Click:) |
| WK-DMF0042-1249 | E4 | (동적 메시지) | 하네스·환경 | E4 도구 오류 — 원장 V-a3ac22c5 |  | 1 (ACT:DMF0042_3_BizPlan.SaveData:1181:184) |
| WK-DMF0042-1250 | E4 | (동적 메시지) | 하네스·환경 | E4 도구 오류 — 원장 V-612f7792 |  | 1 (ACT:DMF0042_3_BizPlan.btnCutOff_Click:29) |
| WK-DMF0042-1251 | E4 | (동적 메시지) | 하네스·환경 | E4 도구 오류 — 원장 V-a97d204a |  | 1 (ACT:DMF0042_3_BizPlan.btnReplace_Click:3) |
| WK-DMF0042-1252 | E4 | (동적 메시지) | 하네스·환경 | E4 도구 오류 — 원장 V-6e4b8edf |  | 1 (ACT:DMF0042_3_BizPlan.btnReplace_Click:3) |
| WK-DMF0042-1253 | E4 | (동적 메시지) | 하네스·환경 | E4 도구 오류 — 원장 V-b0df0bcd |  | 1 (ACT:DMF0042_3_BizPlan.btnReplace_Click:3) |
| WK-DMF0042-1254 | E4 | (동적 메시지) | 하네스·환경 | E4 도구 오류 — 원장 V-15eafc65 |  | 1 (ACT:DMF0042_3_BizPlan.btnSetPrice_Click:) |
| WK-DMF0042-1255 | E4 | (동적 메시지) | 하네스·환경 | E4 도구 오류 — 원장 V-9fd8f05b |  | 1 (ACT:DMF0042_BizPlan.SaveData:1199:177) |
| WK-DMF0042-1256 | E4 | (동적 메시지) | 하네스·환경 | E4 도구 오류 — 원장 V-5df0cf8c |  | 1 (ACT:DMF0042_BizPlan.btnCutOff_Click:2907) |
| WK-DMF0042-1257 | E4 | (동적 메시지) | 하네스·환경 | E4 도구 오류 — 원장 V-c7b144bd |  | 1 (ACT:DMF0042_BizPlan.btnReplace_Click:347) |
| WK-DMF0042-1258 | E4 | (동적 메시지) | 하네스·환경 | E4 도구 오류 — 원장 V-63be5ae3 |  | 1 (ACT:DMF0042_BizPlan.btnReplace_Click:348) |
| WK-DMF0042-1259 | E4 | (동적 메시지) | 하네스·환경 | E4 도구 오류 — 원장 V-3248beb4 |  | 1 (ACT:DMF0042_BizPlan.btnReplace_Click:349) |
| WK-DMF0042-1260 | E4 | (동적 메시지) | 하네스·환경 | E4 도구 오류 — 원장 V-8036b7b1 |  | 1 (ACT:DMF0042_BizPlan.btnSetPrice_Click:31) |
| WK-DMF0042-1261 | E4 | (동적 메시지) | 하네스·환경 | E4 도구 오류 — 원장 V-1c93a899 |  | 1 (ACT:DMF0042_BizPlan_old.SaveData:925:166) |
| WK-DMF0042-1262 | E4 | (동적 메시지) | 하네스·환경 | E4 도구 오류 — 원장 V-de3f1269 |  | 1 (ACT:DMF0042_BizPlan_old.btnCutOff_Click:) |
| WK-DMF0042-1263 | E4 | (동적 메시지) | 하네스·환경 | E4 도구 오류 — 원장 V-e1652bd3 |  | 1 (ACT:DMF0042_BizPlan_old.btnSetPrice_Clic) |
| WK-DMF0042-1264 | E4 | (동적 메시지) | 하네스·환경 | E4 도구 오류 — 원장 V-c9196fb6 |  | 1 (ACT:DMF0042_ExchangeRatePopup.EditButton) |
| WK-DMF0042-1265 | E4 | (동적 메시지) | 하네스·환경 | E4 도구 오류 — 원장 V-67d0edbd |  | 1 (ACT:DMF0042_ExchangeRatePopup.SaveData:5) |
| WK-DMF0042-1266 | E4 | 13 | 하네스·환경 | E4 도구 오류 — 행 집계 — 대조표 13 'btnMeasure_Click (L2819~2830)' 의 E4 127요소: ERROR:105 · NOT_RUN:19 · NA:3 |  | 1 (13) |
| WK-DMF0042-1267 | E4 | 17 | 하네스·환경 | E4 도구 오류 — 행 집계 — 대조표 17 'spdMain_EditChange (L2975~2982)' 의 E4 127요소: ERROR:105 · NOT_RUN:19 · NA:3 |  | 1 (17) |
| WK-DMF0042-1268 | E4 | 18 | 하네스·환경 | E4 도구 오류 — 행 집계 — 대조표 18 'spdMain_TopChange (L2736~2741)' 의 E4 127요소: ERROR:105 · NOT_RUN:19 · NA:3 |  | 1 (18) |
| WK-DMF0042-1269 | E4 | DMF0042_2_BizPlan.SetCellColor | 하네스·환경 | E4 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.SetCellColor 의 E4 127요소: ERROR:105 · NOT_RUN:19 · NA:3 |  | 3 (ACT:DMF0042_2_BizPlan.SetCellColor:3493:) |
| WK-DMF0042-1270 | E4 | DMF0042_2_BizPlan.SetSpreadColumn | 하네스·환경 | E4 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.SetSpreadColumn 의 E4 2요소: NOT_RUN:1 · ERROR:1 |  | 1 (ACT:DMF0042_2_BizPlan.SetSpreadColumn:46) |
| WK-DMF0042-1271 | E4 | DMF0042_2_BizPlan.SetSpreadHeaderSpan | 하네스·환경 | E4 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.SetSpreadHeaderSpan 의 E4 5요소: NOT_RUN:4 · ERROR:1 |  | 13 (ACT:DMF0042_2_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-1272 | E4 | MEASURE / Measure | 하네스·환경 | E4 도구 오류 — 원장 V-584f49e4 ASIS / 원장 V-b64b7fd8 ASIS / 원장 V-b8eeaeb8 ASIS / 원장 V-545c61a8 ASIS |  | 36 (ACT:DMF0042_1_BizPlan.SetSpreadColumn AC) |
| WK-DMF0042-1273 | E4 | MSG00002 | 하네스·환경 | E4 도구 오류 — 원장 V-e02c62bd ASIS / 원장 V-86dcf637 ASIS / 원장 V-82c08dd4 ASIS / 원장 V-aa9f4ac3 ASIS / 원장 V-64ccae99 ASIS / 원장 V-11ab8740  |  | 9 (저장 검증 8 (#13~20) Grid 입력 4 (#39~40/41/44) |
| WK-DMF0042-1274 | E4 | MSG00002 | 하네스·환경 | E4 도구 오류 — 원장 V-e02c62bd |  | 1 (ACT:DMF0042_1_BizPlan.ValidationCheck:27) |
| WK-DMF0042-1275 | E4 | MSG00002 | 하네스·환경 | E4 도구 오류 — 원장 V-86dcf637 |  | 1 (ACT:DMF0042_2_BizPlan.ValidationCheck:29) |
| WK-DMF0042-1276 | E4 | MSG00002 | 하네스·환경 | E4 도구 오류 — 원장 V-82c08dd4 |  | 1 (ACT:DMF0042_3_BizPlan.ValidationCheck:27) |
| WK-DMF0042-1277 | E4 | MSG00002 | 하네스·환경 | E4 도구 오류 — 원장 V-aa9f4ac3 |  | 1 (ACT:DMF0042_BizPlan.ValidationCheck:2791) |
| WK-DMF0042-1278 | E4 | MSG00002 | 하네스·환경 | E4 도구 오류 — 원장 V-64ccae99 |  | 1 (ACT:DMF0042_BizPlan_old.ValidationCheck:) |
| WK-DMF0042-1279 | E4 | MSG00002 | 하네스·환경 | E4 도구 오류 — 원장 V-11ab8740 |  | 1 (ACT:DMF0042_ExchangeRatePopup.SaveData:4) |
| WK-DMF0042-1280 | E4 | MSG00002 | 하네스·환경 | E4 도구 오류 — 원장 V-92830b3d |  | 1 (ACT:DMF0042_ExchangeRatePopup.SaveData:5) |
| WK-DMF0042-1281 | E4 | MSG00004 | 하네스·환경 | E4 도구 오류 — 원장 V-9ac1dcbf ASIS / 원장 V-c9457d29 ASIS / 원장 V-49247b0f ASIS / 원장 V-ba4a4e6b ASIS / 원장 V-8a7111a9 ASIS / 원장 V-bde38c44  |  | 7 (저장 검증 8 (#13~20) ACT:DMF0042_1_BizPlan.S) |
| WK-DMF0042-1282 | E4 | MSG00004 | 하네스·환경 | E4 도구 오류 — 원장 V-9ac1dcbf |  | 1 (ACT:DMF0042_1_BizPlan.SaveData:1143:179) |
| WK-DMF0042-1283 | E4 | MSG00004 | 하네스·환경 | E4 도구 오류 — 원장 V-c9457d29 |  | 1 (ACT:DMF0042_2_BizPlan.SaveData:1295:250) |
| WK-DMF0042-1284 | E4 | MSG00004 | 하네스·환경 | E4 도구 오류 — 원장 V-49247b0f |  | 1 (ACT:DMF0042_3_BizPlan.SaveData:1186:186) |
| WK-DMF0042-1285 | E4 | MSG00004 | 하네스·환경 | E4 도구 오류 — 원장 V-ba4a4e6b |  | 1 (ACT:DMF0042_BizPlan.SaveData:1204:179) |
| WK-DMF0042-1286 | E4 | MSG00004 | 하네스·환경 | E4 도구 오류 — 원장 V-8a7111a9 |  | 1 (ACT:DMF0042_BizPlan_old.SaveData:930:168) |
| WK-DMF0042-1287 | E4 | MSG00004 | 하네스·환경 | E4 도구 오류 — 원장 V-bde38c44 |  | 1 (ACT:DMF0042_ExchangeRatePopup.SaveData:5) |
| WK-DMF0042-1288 | E4 | MSG00043 | 하네스·환경 | E4 도구 오류 — 원장 V-f94b3ae0 ASIS / 원장 V-0061079c ASIS / 원장 V-5b412dc3 ASIS / 원장 V-d536761c ASIS / 원장 V-ead4c1e1 ASIS |  | 7 (24 저장 검증 8 (#13~20) ACT:DMF0042_1_BizPla) |
| WK-DMF0042-1289 | E4 | MSG00043 | 하네스·환경 | E4 도구 오류 — 원장 V-f94b3ae0 |  | 1 (ACT:DMF0042_1_BizPlan.SaveData:1093:149) |
| WK-DMF0042-1290 | E4 | MSG00043 | 하네스·환경 | E4 도구 오류 — 원장 V-0061079c |  | 1 (ACT:DMF0042_2_BizPlan.SaveData:1225:194) |
| WK-DMF0042-1291 | E4 | MSG00043 | 하네스·환경 | E4 도구 오류 — 원장 V-5b412dc3 |  | 1 (ACT:DMF0042_3_BizPlan.SaveData:1136:156) |
| WK-DMF0042-1292 | E4 | MSG00043 | 하네스·환경 | E4 도구 오류 — 원장 V-d536761c |  | 1 (ACT:DMF0042_BizPlan.SaveData:1154:149) |
| WK-DMF0042-1293 | E4 | MSG00043 | 하네스·환경 | E4 도구 오류 — 원장 V-ead4c1e1 |  | 1 (ACT:DMF0042_BizPlan_old.SaveData:885:137) |
| WK-DMF0042-1294 | E4 | MSG00096 | 하네스·환경 | E4 도구 오류 — 원장 V-6df9806b |  | 1 (ACT:DMF0042_ExchangeRatePopup.SaveButton) |
| WK-DMF0042-1295 | E4 | MSG00096 | 하네스·환경 | E4 도구 오류 — 원장 V-6df9806b ASIS |  | 1 (ACT:DMF0042_ExchangeRatePopup.SaveButton) |
| WK-DMF0042-1296 | E4 | MSG00113 | 하네스·환경 | E4 도구 오류 — 원장 V-78f9b9a5 ASIS / 원장 V-e3a95858 ASIS / 원장 V-44c6fbdc ASIS / 원장 V-efd838b0 ASIS / 원장 V-8b380a5c ASIS / 원장 V-0cb9d4fa  |  | 11 (Insert (F8) 저장 검증 8 (#13~20) ACT:DMF0042) |
| WK-DMF0042-1297 | E4 | MSG00113 | 하네스·환경 | E4 도구 오류 — 원장 V-78f9b9a5 |  | 1 (ACT:DMF0042_1_BizPlan.EditButton:548:4) |
| WK-DMF0042-1298 | E4 | MSG00113 | 하네스·환경 | E4 도구 오류 — 원장 V-e3a95858 |  | 1 (ACT:DMF0042_1_BizPlan.SaveData:810:4) |
| WK-DMF0042-1299 | E4 | MSG00113 | 하네스·환경 | E4 도구 오류 — 원장 V-44c6fbdc |  | 1 (ACT:DMF0042_2_BizPlan.EditButton:544:4) |
| WK-DMF0042-1300 | E4 | MSG00113 | 하네스·환경 | E4 도구 오류 — 원장 V-efd838b0 |  | 1 (ACT:DMF0042_2_BizPlan.SaveData:788:4) |
| WK-DMF0042-1301 | E4 | MSG00113 | 하네스·환경 | E4 도구 오류 — 원장 V-8b380a5c |  | 1 (ACT:DMF0042_3_BizPlan.EditButton:574:4) |
| WK-DMF0042-1302 | E4 | MSG00113 | 하네스·환경 | E4 도구 오류 — 원장 V-0cb9d4fa |  | 1 (ACT:DMF0042_3_BizPlan.SaveData:836:4) |
| WK-DMF0042-1303 | E4 | MSG00113 | 하네스·환경 | E4 도구 오류 — 원장 V-54761c50 |  | 1 (ACT:DMF0042_BizPlan.SaveData:871:4) |
| WK-DMF0042-1304 | E4 | MSG00113 | 하네스·환경 | E4 도구 오류 — 원장 V-1ca62479 |  | 1 (ACT:DMF0042_BizPlan_old.EditButton:517:3) |
| WK-DMF0042-1305 | E4 | MSG00113 | 하네스·환경 | E4 도구 오류 — 원장 V-eefa930d |  | 1 (ACT:DMF0042_BizPlan_old.SaveData:696:4) |
| WK-DMF0042-1306 | E4 | MSG00142 | 하네스·환경 | E4 도구 오류 — 원장 V-a7450372 ASIS / 원장 V-e83fd292 ASIS / 원장 V-76e7b693 ASIS / 원장 V-7dfd4189 ASIS / 원장 V-ed525b64 ASIS |  | 8 (btnExchangeRate 26 버튼 가드 6 (#42/43/45/97) |
| WK-DMF0042-1307 | E4 | MSG00142 | 하네스·환경 | E4 도구 오류 — 원장 V-a7450372 |  | 1 (ACT:DMF0042_1_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1308 | E4 | MSG00142 | 하네스·환경 | E4 도구 오류 — 원장 V-e83fd292 |  | 1 (ACT:DMF0042_2_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1309 | E4 | MSG00142 | 하네스·환경 | E4 도구 오류 — 원장 V-76e7b693 |  | 1 (ACT:DMF0042_3_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1310 | E4 | MSG00142 | 하네스·환경 | E4 도구 오류 — 원장 V-7dfd4189 |  | 1 (ACT:DMF0042_BizPlan.btnExchangeRate_Clic) |
| WK-DMF0042-1311 | E4 | MSG00142 | 하네스·환경 | E4 도구 오류 — 원장 V-ed525b64 |  | 1 (ACT:DMF0042_BizPlan_old.btnExchangeRate_) |
| WK-DMF0042-1312 | E4 | MSG00227 | 하네스·환경 | E4 도구 오류 — 원장 V-57c69aef ASIS / 원장 V-034982a8 ASIS / 원장 V-61fabbab ASIS / 원장 V-394a8240 ASIS / 원장 V-29f09ecf ASIS |  | 6 (버튼 가드 6 (#42/43/45/97~99) ACT:DMF0042_1_) |
| WK-DMF0042-1313 | E4 | MSG00227 | 하네스·환경 | E4 도구 오류 — 원장 V-57c69aef |  | 1 (ACT:DMF0042_1_BizPlan.cboBucketType_Clic) |
| WK-DMF0042-1314 | E4 | MSG00227 | 하네스·환경 | E4 도구 오류 — 원장 V-034982a8 |  | 1 (ACT:DMF0042_2_BizPlan.cboBucketType_Clic) |
| WK-DMF0042-1315 | E4 | MSG00227 | 하네스·환경 | E4 도구 오류 — 원장 V-61fabbab |  | 1 (ACT:DMF0042_3_BizPlan.cboBucketType_Clic) |
| WK-DMF0042-1316 | E4 | MSG00227 | 하네스·환경 | E4 도구 오류 — 원장 V-394a8240 |  | 1 (ACT:DMF0042_BizPlan.cboBucketType_Click:) |
| WK-DMF0042-1317 | E4 | MSG00227 | 하네스·환경 | E4 도구 오류 — 원장 V-29f09ecf |  | 1 (ACT:DMF0042_BizPlan_old.cboBucketType_Cl) |
| WK-DMF0042-1318 | E4 | MSG00275 | 하네스·환경 | E4 도구 오류 — 원장 V-9e32aa7e ASIS / 원장 V-c148f2fc ASIS / 원장 V-1e24d9fe ASIS / 원장 V-6b3077b3 ASIS / 원장 V-421dc349 ASIS |  | 6 (저장 검증 8 (#13~20) ACT:DMF0042_1_BizPlan.S) |
| WK-DMF0042-1319 | E4 | MSG00275 | 하네스·환경 | E4 도구 오류 — 원장 V-9e32aa7e |  | 1 (ACT:DMF0042_1_BizPlan.SaveData:1087:146) |
| WK-DMF0042-1320 | E4 | MSG00275 | 하네스·환경 | E4 도구 오류 — 원장 V-c148f2fc |  | 1 (ACT:DMF0042_2_BizPlan.SaveData:1219:191) |
| WK-DMF0042-1321 | E4 | MSG00275 | 하네스·환경 | E4 도구 오류 — 원장 V-1e24d9fe |  | 1 (ACT:DMF0042_3_BizPlan.SaveData:1130:153) |
| WK-DMF0042-1322 | E4 | MSG00275 | 하네스·환경 | E4 도구 오류 — 원장 V-6b3077b3 |  | 1 (ACT:DMF0042_BizPlan.SaveData:1148:146) |
| WK-DMF0042-1323 | E4 | MSG00275 | 하네스·환경 | E4 도구 오류 — 원장 V-421dc349 |  | 1 (ACT:DMF0042_BizPlan_old.SaveData:879:134) |
| WK-DMF0042-1324 | E4 | MSG00282 | 하네스·환경 | E4 도구 오류 — 원장 V-95e5681c ASIS / 원장 V-f4ac478f ASIS / 원장 V-b9c0d3fe ASIS / 원장 V-0abb450a ASIS / 원장 V-1281d0e8 ASIS |  | 6 (25 ACT:DMF0042_1_BizPlan.btnSetPrice_Cli) |
| WK-DMF0042-1325 | E4 | MSG00282 | 하네스·환경 | E4 도구 오류 — 원장 V-95e5681c |  | 1 (ACT:DMF0042_1_BizPlan.btnSetPrice_Click:) |
| WK-DMF0042-1326 | E4 | MSG00282 | 하네스·환경 | E4 도구 오류 — 원장 V-f4ac478f |  | 1 (ACT:DMF0042_2_BizPlan.btnSetPrice_Click:) |
| WK-DMF0042-1327 | E4 | MSG00282 | 하네스·환경 | E4 도구 오류 — 원장 V-b9c0d3fe |  | 1 (ACT:DMF0042_3_BizPlan.btnSetPrice_Click:) |
| WK-DMF0042-1328 | E4 | MSG00282 | 하네스·환경 | E4 도구 오류 — 원장 V-0abb450a |  | 1 (ACT:DMF0042_BizPlan.btnSetPrice_Click:31) |
| WK-DMF0042-1329 | E4 | MSG00282 | 하네스·환경 | E4 도구 오류 — 원장 V-1281d0e8 |  | 1 (ACT:DMF0042_BizPlan_old.btnSetPrice_Clic) |
| WK-DMF0042-1330 | E4 | MSG00289 | 하네스·환경 | E4 도구 오류 — 원장 V-584f49e4 ASIS / 원장 V-b64b7fd8 ASIS / 원장 V-b8eeaeb8 ASIS / 원장 V-545c61a8 ASIS |  | 6 (14 Grid 입력 4 (#39~40/41/44) ACT:DMF0042_) |
| WK-DMF0042-1331 | E4 | MSG00289 | 하네스·환경 | E4 도구 오류 — 원장 V-584f49e4 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_Changed:18) |
| WK-DMF0042-1332 | E4 | MSG00289 | 하네스·환경 | E4 도구 오류 — 원장 V-b64b7fd8 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_Changed:19) |
| WK-DMF0042-1333 | E4 | MSG00289 | 하네스·환경 | E4 도구 오류 — 원장 V-b8eeaeb8 |  | 1 (ACT:DMF0042_BizPlan.spdMain_Changed:1916) |
| WK-DMF0042-1334 | E4 | MSG00289 | 하네스·환경 | E4 도구 오류 — 원장 V-545c61a8 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_Changed:) |
| WK-DMF0042-1335 | E4 | MSG00310 | 하네스·환경 | E4 도구 오류 — 원장 V-3e41b595 ASIS / 원장 V-119e9de9 ASIS / 원장 V-a097e1c2 ASIS / 원장 V-e3630fbf ASIS / 원장 V-87e8f4da ASIS / 원장 V-d9b2a1c2  |  | 13 (24 저장 검증 8 (#13~20) ACT:DMF0042_1_BizPla) |
| WK-DMF0042-1336 | E4 | MSG00310 | 하네스·환경 | E4 도구 오류 — 원장 V-3e41b595 |  | 1 (ACT:DMF0042_1_BizPlan.SaveData:912:59) |
| WK-DMF0042-1337 | E4 | MSG00310 | 하네스·환경 | E4 도구 오류 — 원장 V-119e9de9 |  | 1 (ACT:DMF0042_1_BizPlan.SaveData:943:71) |
| WK-DMF0042-1338 | E4 | MSG00310 | 하네스·환경 | E4 도구 오류 — 원장 V-a097e1c2 |  | 1 (ACT:DMF0042_1_BizPlan.SaveData:967:82) |
| WK-DMF0042-1339 | E4 | MSG00310 | 하네스·환경 | E4 도구 오류 — 원장 V-e3630fbf |  | 1 (ACT:DMF0042_2_BizPlan.SaveData:912:82) |
| WK-DMF0042-1340 | E4 | MSG00310 | 하네스·환경 | E4 도구 오류 — 원장 V-87e8f4da |  | 1 (ACT:DMF0042_2_BizPlan.SaveData:1071:137) |
| WK-DMF0042-1341 | E4 | MSG00310 | 하네스·환경 | E4 도구 오류 — 원장 V-d9b2a1c2 |  | 1 (ACT:DMF0042_3_BizPlan.SaveData:955:66) |
| WK-DMF0042-1342 | E4 | MSG00310 | 하네스·환경 | E4 도구 오류 — 원장 V-10fd120c |  | 1 (ACT:DMF0042_3_BizPlan.SaveData:986:78) |
| WK-DMF0042-1343 | E4 | MSG00310 | 하네스·환경 | E4 도구 오류 — 원장 V-bca54e32 |  | 1 (ACT:DMF0042_3_BizPlan.SaveData:1010:89) |
| WK-DMF0042-1344 | E4 | MSG00310 | 하네스·환경 | E4 도구 오류 — 원장 V-05ed2d14 |  | 1 (ACT:DMF0042_BizPlan.SaveData:973:59) |
| WK-DMF0042-1345 | E4 | MSG00310 | 하네스·환경 | E4 도구 오류 — 원장 V-a8a9ff28 |  | 1 (ACT:DMF0042_BizPlan.SaveData:1004:71) |
| WK-DMF0042-1346 | E4 | MSG00310 | 하네스·환경 | E4 도구 오류 — 원장 V-f0299336 |  | 1 (ACT:DMF0042_BizPlan.SaveData:1028:82) |
| WK-DMF0042-1347 | E4 | UNIT_ENERGY / Energy | 하네스·환경 | E4 도구 오류 — 원장 V-584f49e4 ASIS / 원장 V-b64b7fd8 ASIS / 원장 V-b8eeaeb8 ASIS |  | 3 (ACT:DMF0042_1_BizPlan.spdMain_Changed:18) |
| WK-DMF0042-1348 | E4 | btnMeasure 'Measure' | 하네스·환경 | E4 도구 오류 — 행 집계 — 대조표 btnMeasure 'Measure' "커스텀 버튼(icon) → MeasureSelectModal + saveTitleSet('" 의 E4 127요소: ERROR:105 · NOT_RUN:19 |  | 1 (btnMeasure 'Measure') |
| WK-DMF0042-1349 | E4 | 필수 컬럼 존재 44 (fnValidation 22 + MinColumn | 하네스·환경 | E4 도구 오류 — 행 집계 — 대조표 필수 컬럼 존재 44 (fnValidation 22 + MinColumnChk 22) 'Grid 내 필수 컬럼 인덱스 존재 여부 (division별 컬럼셋)' 의 E4 127요소: ERROR:1 |  | 1 (필수 컬럼 존재 44 (fnValidation 22 + MinColumn) |
| WK-DMF0042-1350 | E5 | DEPT_ID40 / Team | 하네스·환경 | E5 도구 오류 — 원장 V-ee3daccd COLUMN |  | 1 (16) |
| WK-DMF0042-1351 | E5 | END_CUSTOMER40 / End Customer | 하네스·환경 | E5 도구 오류 — 원장 V-253fda98 COLUMN |  | 1 (16) |
| WK-DMF0042-1352 | E5 | SCM_SITE_ID40 / Sales Site | 하네스·환경 | E5 도구 오류 — 원장 V-80284167 COLUMN |  | 1 (16) |
| WK-DMF0042-1353 | A10 | DMF0042 화면 | 하네스·환경 | A10 도구 오류 — 원장 V-6d535c97 RULE_SCREEN / 원장 V-4f907055 GENERAL |  | 620 (ACT:DMF0042_1_BizPlan.DefineProperty ACT) |
| WK-DMF0042-1354 | A6 | DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE | 하네스·환경 | A6 도구 오류 — 원장 V-52ebe44f SP / 정렬대조 REVIEW TO-BE 프로시저 배선(PROC_M) 없음 — 대응 프로시저 확인 |  | 40 (ACT:DMF0042_ExchangeRatePopup.FindButton) |
| WK-DMF0042-1355 | G1 | 1 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 1 'Edit(F2) 토글 제거 — 상시편집 + editLock' 의 G1 37요소: ERROR:30 · NA:5 · NOT_RUN:2 |  | 0 () |
| WK-DMF0042-1356 | G1 | 13 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 13 'btnMeasure_Click (L2819~2830)' 의 G1 37요소: ERROR:30 · NA:5 · NOT_RUN:2 |  | 1 (13) |
| WK-DMF0042-1357 | G1 | 16 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 16 'spdMain_ComboSelChange (L1565~1596)' 의 G1 37요소: ERROR:30 · NA:5 · NOT_RUN:2 |  | 1 (16) |
| WK-DMF0042-1358 | G1 | 20 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 20 'FindButton → FindData (L684~799)' 의 G1 37요소: ERROR:30 · NA:5 · NOT_RUN:2 |  | 1 (20) |
| WK-DMF0042-1359 | G1 | 24 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 24 'SaveButton → SaveData (L801~1148)' 의 G1 37요소: ERROR:30 · NA:5 · NOT_RUN:2 |  | 1 (24) |
| WK-DMF0042-1360 | G1 | 26 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 26 'btnExchangeRate_Click (L2985~3005)' 의 G1 37요소: ERROR:30 · NA:5 · NOT_RUN:2 |  | 1 (26) |
| WK-DMF0042-1361 | G1 | 27 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 27 'btnCutOff_Click (L2840~2866)' 의 G1 37요소: ERROR:30 · NA:5 · NOT_RUN:2 |  | 1 (27) |
| WK-DMF0042-1362 | G1 | 4 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 4 'MSG 재매핑 — 00310→00429 / 00275→00676 / 00276→00677 ' 의 G1 37요소: ERROR:30 · NA:5 · NOT_RUN:2 |  | 0 () |
| WK-DMF0042-1363 | G1 | 5 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 5 "cboQty 비노출 + 'N' 고정" 의 G1 37요소: ERROR:30 · NA:5 · NOT_RUN:2 |  | 0 () |
| WK-DMF0042-1364 | G1 | 6 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 6 'Exchange Rate 모달 = 표준 CustomDialog+DataGrid 재구성 (A' 의 G1 37요소: ERROR:30 · NA:5 · NOT_RUN:2 |  | 1 (6) |
| WK-DMF0042-1365 | G1 | 7 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 7 'Ver.Cutoff/Replace 모달 = 목록조회+실행 표준 재구성' 의 G1 37요소: ERROR:30 · NA:5 · NOT_RUN:2 |  | 1 (7) |
| WK-DMF0042-1366 | G1 | DMF0042_2_BizPlan.FindButton | 하네스·환경 | G1 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.FindButton 의 G1 37요소: ERROR:30 · NA:5 · NOT_RUN:2 |  | 1 (ACT:DMF0042_2_BizPlan.FindButton:513:1) |
| WK-DMF0042-1367 | G1 | DMF0042_2_BizPlan.FindData | 하네스·환경 | G1 도구 오류 — 원장 V-94f9af94 ASIS / 원장 V-d5c81478 ASIS / 원장 V-e72422d9 ASIS / 원장 V-19257fab ASIS |  | 33 (ACT:DMF0042_2_BizPlan.FindData:649:1 ACT) |
| WK-DMF0042-1368 | G1 | Find (F5) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 Find (F5) 'hotkeyConfig.search → handleSearch (V-S1~S3 + setF' 의 G1 37요소: ERROR:30 · NA:5 · NOT_RUN:2 |  | 1 (Find (F5)) |
| WK-DMF0042-1369 | G1 | G9 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 G9 '**CELL_PROD_SITE 콤보(40)** — 조회 표시 코드→한글(ALL)+신규행 유' 의 G1 37요소: ERROR:30 · NA:5 · NOT_RUN:2 |  | 1 (G9) |
| WK-DMF0042-1370 | G1 | MSG00097 | 하네스·환경 | G1 도구 오류 — 원장 V-16b773e6 |  | 1 (ACT:DMF0042_1_BizPlan.FindData:697:6) |
| WK-DMF0042-1371 | G1 | MSG00097 | 하네스·환경 | G1 도구 오류 — 원장 V-94f9af94 |  | 1 (ACT:DMF0042_2_BizPlan.FindData:660:6) |
| WK-DMF0042-1372 | G1 | MSG00097 | 하네스·환경 | G1 도구 오류 — 원장 V-a9b5158e |  | 1 (ACT:DMF0042_3_BizPlan.FindData:723:6) |
| WK-DMF0042-1373 | G1 | MSG00097 | 하네스·환경 | G1 도구 오류 — 원장 V-30437554 |  | 1 (ACT:DMF0042_BizPlan.FindData:758:6) |
| WK-DMF0042-1374 | G1 | MSG00097 | 하네스·환경 | G1 도구 오류 — 원장 V-ddec28e1 |  | 1 (ACT:DMF0042_BizPlan_old.FindData:595:6) |
| WK-DMF0042-1375 | G1 | MSG00108 | 하네스·환경 | G1 도구 오류 — 원장 V-2e9eedeb |  | 1 (ACT:DMF0042_1_BizPlan.FindData:705:10) |
| WK-DMF0042-1376 | G1 | MSG00108 | 하네스·환경 | G1 도구 오류 — 원장 V-d5c81478 |  | 1 (ACT:DMF0042_2_BizPlan.FindData:668:10) |
| WK-DMF0042-1377 | G1 | MSG00108 | 하네스·환경 | G1 도구 오류 — 원장 V-48fe12e3 |  | 1 (ACT:DMF0042_3_BizPlan.FindData:731:10) |
| WK-DMF0042-1378 | G1 | MSG00108 | 하네스·환경 | G1 도구 오류 — 원장 V-0b438463 |  | 1 (ACT:DMF0042_BizPlan.FindData:766:10) |
| WK-DMF0042-1379 | G1 | MSG00108 | 하네스·환경 | G1 도구 오류 — 원장 V-50db9387 |  | 1 (ACT:DMF0042_BizPlan_old.FindData:603:10) |
| WK-DMF0042-1380 | G1 | MSG00276 | 하네스·환경 | G1 도구 오류 — 원장 V-d5eba555 |  | 1 (ACT:DMF0042_1_BizPlan.FindData:711:13) |
| WK-DMF0042-1381 | G1 | MSG00276 | 하네스·환경 | G1 도구 오류 — 원장 V-e72422d9 |  | 1 (ACT:DMF0042_2_BizPlan.FindData:674:13) |
| WK-DMF0042-1382 | G1 | MSG00276 | 하네스·환경 | G1 도구 오류 — 원장 V-c621a149 |  | 1 (ACT:DMF0042_3_BizPlan.FindData:737:13) |
| WK-DMF0042-1383 | G1 | MSG00276 | 하네스·환경 | G1 도구 오류 — 원장 V-53ee84c8 |  | 1 (ACT:DMF0042_BizPlan.FindData:772:13) |
| WK-DMF0042-1384 | G1 | MSG00276 | 하네스·환경 | G1 도구 오류 — 원장 V-c6fad0ce |  | 1 (ACT:DMF0042_BizPlan_old.FindData:609:13) |
| WK-DMF0042-1385 | G1 | btnExchangeRate | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 btnExchangeRate '커스텀 버튼(LBL00661) → pending 차단(MSG00680 — AS-IS MSG' 의 G1 37요소: ERROR:30 · NA:5 · NOT_RUN:2 |  | 1 (btnExchangeRate) |
| WK-DMF0042-1386 | G1 | btnMeasure 'Measure' | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 btnMeasure 'Measure' "커스텀 버튼(icon) → MeasureSelectModal + saveTitleSet('" 의 G1 37요소: ERROR:30 · NA:5 · NOT_R |  | 1 (btnMeasure 'Measure') |
| WK-DMF0042-1387 | G1 | btnReplace (ADMIN/DM ADMIN) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 btnReplace (ADMIN/DM ADMIN) "커스텀 버튼 'Replace' — hasButton('REPLACE') 게이트 + pend" 의 G1 37요소: ERROR:30 · NA:5  |  | 1 (btnReplace (ADMIN/DM ADMIN)) |
| WK-DMF0042-1388 | G1 | btnSetPrice (가격환산) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 btnSetPrice (가격환산) "커스텀 버튼 'Set Price' → MSG00678 confirm → SET_PRICE(" 의 G1 37요소: ERROR:30 · NA:5 · NOT_RUN |  | 1 (btnSetPrice (가격환산)) |
| WK-DMF0042-1389 | G1 | cboBucketType / Bucket / Bucket Type | 하네스·환경 | G1 도구 오류 — 원장 V-8a20762e SEARCH |  | 0 () |
| WK-DMF0042-1390 | G1 | cboClosed / Closed | 하네스·환경 | G1 도구 오류 — 원장 V-5fd5e439 SEARCH |  | 0 () |
| WK-DMF0042-1391 | G1 | cboQty / . / Qty | 하네스·환경 | G1 도구 오류 — 원장 V-47d0fa5c SEARCH |  | 8 (ACT:DMF0042_1_BizPlan.FindData ACT:DMF00) |
| WK-DMF0042-1392 | G1 | chkSum / Sum | 하네스·환경 | G1 도구 오류 — 원장 V-3003995f SEARCH |  | 0 () |
| WK-DMF0042-1393 | G1 | clbBizType / Biz Type | 하네스·환경 | G1 도구 오류 — 원장 V-ca5ef439 SEARCH |  | 10 (ACT:DMF0042_1_BizPlan.FindData ACT:DMF00) |
| WK-DMF0042-1394 | G1 | clbCustomer / End Customer / Customer | 하네스·환경 | G1 도구 오류 — 원장 V-fb2332bd SEARCH |  | 10 (ACT:DMF0042_1_BizPlan.FindData ACT:DMF00) |
| WK-DMF0042-1395 | G1 | clbDivision / Division | 하네스·환경 | G1 도구 오류 — 원장 V-23176ba3 SEARCH |  | 14 (ACT:DMF0042_1_BizPlan.FindData ACT:DMF00) |
| WK-DMF0042-1396 | G1 | clbItemType / Item Type | 하네스·환경 | G1 도구 오류 — 원장 V-98fffe63 SEARCH |  | 10 (ACT:DMF0042_1_BizPlan.FindData ACT:DMF00) |
| WK-DMF0042-1397 | G1 | clbPlantSite / Plant Site | 하네스·환경 | G1 도구 오류 — 원장 V-5de2413f SEARCH |  | 10 (ACT:DMF0042_1_BizPlan.FindData ACT:DMF00) |
| WK-DMF0042-1398 | G1 | clbSalesSite / Sales Site | 하네스·환경 | G1 도구 오류 — 원장 V-7c19a4f5 SEARCH |  | 10 (ACT:DMF0042_1_BizPlan.FindData ACT:DMF00) |
| WK-DMF0042-1399 | G1 | clbTeam / Team | 하네스·환경 | G1 도구 오류 — 원장 V-05dfb57c SEARCH |  | 15 (ACT:DMF0042_1_BizPlan.FindData ACT:DMF00) |
| WK-DMF0042-1400 | G1 | drpPeriod / Period | 하네스·환경 | G1 도구 오류 — 원장 V-95d4ea5a SEARCH |  | 50 (ACT:DMF0042_1_BizPlan.FindData ACT:DMF00) |
| WK-DMF0042-1401 | G1 | txtOwner / Owner | 하네스·환경 | G1 도구 오류 — 원장 V-35491d16 SEARCH |  | 10 (ACT:DMF0042_1_BizPlan.FindData ACT:DMF00) |
| WK-DMF0042-1402 | G1 | txtProject / Project | 하네스·환경 | G1 도구 오류 — 원장 V-82cee496 SEARCH |  | 10 (ACT:DMF0042_1_BizPlan.FindData ACT:DMF00) |
| WK-DMF0042-1403 | G1 | usrMonthTo / ~ / Month To | 하네스·환경 | G1 도구 오류 — 원장 V-47d0fa5c SEARCH |  | 3 (ACT:DMF0042_ExchangeRatePopup.FindData A) |
| WK-DMF0042-1404 | G1 | — | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 — '파리티 확인(무변경): 분모0 가드 기구현 / Cutoff 재조회 없음=파리티·Replac' 의 G1 37요소: ERROR:30 · NA:5 · NOT_RUN:2 |  | 1 (—) |
| WK-DMF0042-1405 | G1 | 버튼 가드 6 (#42/43/45/97~99) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 버튼 가드 6 (#42/43/45/97~99) 'CutOff·Replace 인라인 "Edit Mode is not allowed."×3 /' 의 G1 37요소: ERROR:30 · NA:5 ·  |  | 1 (버튼 가드 6 (#42/43/45/97~99)) |
| WK-DMF0042-1406 | G1 | 조회 검증 4 (#9~12) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 조회 검증 4 (#9~12) 'MSG00097(Division)/MSG00108(역전)/MSG00276(6년 초과+보정)' 의 G1 37요소: ERROR:30 · NA:5 · NOT_RUN:2 |  | 1 (조회 검증 4 (#9~12)) |
| WK-DMF0042-1407 | G6 | cboQty / . / Qty | 하네스·환경 | G6 도구 오류 — 실측[T-4e6d48d4]: 검사기 있음(_trace.spec(@trace) 초기값) — 실행 필요: trace / [미검증] 검사기(_trace.spec(@trace) 초기값)가 이 대상을 실행하지 못함 — 검증 |  | 0 () |
| WK-DMF0042-1408 | X-ROW | DMF0042_1_BizPlan..ctor | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — WARN:1 · ERROR:1 |  | 3 (ACT:DMF0042_1_BizPlan..ctor:201:1 ACT:DM) |
| WK-DMF0042-1409 | X-ROW | DMF0042_1_BizPlan.CreateSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 5 (ACT:DMF0042_1_BizPlan.CreateSpread ACT:D) |
| WK-DMF0042-1410 | X-ROW | DMF0042_1_BizPlan.DefineProperty | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — NOT_RUN:4 · ERROR:3 · NOPATH:1 · WARN:1 |  | 13 (ACT:DMF0042_1_BizPlan.DefineProperty:327) |
| WK-DMF0042-1411 | X-ROW | DMF0042_1_BizPlan.DeleteButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — ERROR:4 |  | 6 (ACT:DMF0042_1_BizPlan.DeleteButton:527:1) |
| WK-DMF0042-1412 | X-ROW | DMF0042_1_BizPlan.Dispose | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:1 · NOT_RUN:1 |  | 3 (ACT:DMF0042_1_BizPlan.Dispose:16:1 ACT:D) |
| WK-DMF0042-1413 | X-ROW | DMF0042_1_BizPlan.EditButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 29검사 — ERROR:26 · NA:3 |  | 48 (ACT:DMF0042_1_BizPlan.EditButton:541:1 A) |
| WK-DMF0042-1414 | X-ROW | DMF0042_1_BizPlan.Form_Load | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:2 |  | 7 (ACT:DMF0042_1_BizPlan.Form_Load ACT:DMF0) |
| WK-DMF0042-1415 | X-ROW | DMF0042_1_BizPlan.GetBizTypebyDivision | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:2 · NOPATH:1 · ERROR:1 |  | 7 (ACT:DMF0042_1_BizPlan.GetBizTypebyDivisi) |
| WK-DMF0042-1416 | X-ROW | DMF0042_1_BizPlan.GetCellColor | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 6 (ACT:DMF0042_1_BizPlan.GetCellColor ACT:D) |
| WK-DMF0042-1417 | X-ROW | DMF0042_1_BizPlan.GetCellIndexBySpanRowC | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 5 (ACT:DMF0042_1_BizPlan.GetCellIndexBySpan) |
| WK-DMF0042-1418 | X-ROW | DMF0042_1_BizPlan.GetCellNumbersByRow | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 15 (ACT:DMF0042_1_BizPlan.GetCellNumbersByRo) |
| WK-DMF0042-1419 | X-ROW | DMF0042_1_BizPlan.GetCellProdSite | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — ERROR:2 · NOT_RUN:1 · NA:1 |  | 12 (ACT:DMF0042_1_BizPlan.GetCellProdSite AC) |
| WK-DMF0042-1420 | X-ROW | DMF0042_1_BizPlan.GetDayRange | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — ERROR:2 · NA:1 · NOT_RUN:1 |  | 8 (ACT:DMF0042_1_BizPlan.GetDayRange ACT:DM) |
| WK-DMF0042-1421 | X-ROW | DMF0042_1_BizPlan.GetFuturePriceInfo | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — NOT_RUN:2 · NA:2 · PASS:1 · ERROR:1 |  | 9 (ACT:DMF0042_1_BizPlan.GetFuturePriceInfo) |
| WK-DMF0042-1422 | X-ROW | DMF0042_1_BizPlan.GetLookupData | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:2 · NOPATH:1 · ERROR:1 |  | 7 (ACT:DMF0042_1_BizPlan.GetLookupData ACT:) |
| WK-DMF0042-1423 | X-ROW | DMF0042_1_BizPlan.GetSpdTitle | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 8검사 — ERROR:4 · NA:3 · NOT_RUN:1 |  | 8 (ACT:DMF0042_1_BizPlan.GetSpdTitle:2886:1) |
| WK-DMF0042-1424 | X-ROW | DMF0042_1_BizPlan.GetThisWeekMonday | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NA:2 · ERROR:1 |  | 10 (ACT:DMF0042_1_BizPlan.GetThisWeekMonday ) |
| WK-DMF0042-1425 | X-ROW | DMF0042_1_BizPlan.InitControls | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 37검사 — NOT_RUN:28 · ERROR:6 · NOPATH:3 |  | 48 (ACT:DMF0042_1_BizPlan.InitControls:234:1) |
| WK-DMF0042-1426 | X-ROW | DMF0042_1_BizPlan.InitSaveDataTable | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:2 |  | 6 (ACT:DMF0042_1_BizPlan.InitSaveDataTable ) |
| WK-DMF0042-1427 | X-ROW | DMF0042_1_BizPlan.InitSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — ERROR:3 · NOT_RUN:2 |  | 6 (ACT:DMF0042_1_BizPlan.InitSpread ACT:DMF) |
| WK-DMF0042-1428 | X-ROW | DMF0042_1_BizPlan.InsertButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:2 |  | 2 (ACT:DMF0042_1_BizPlan.InsertButton ACT:D) |
| WK-DMF0042-1429 | X-ROW | DMF0042_1_BizPlan.InsertRow | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 198검사 — ERROR:150 · NA:31 · NOT_RUN:11 · NOPATH:6 |  | 165 (ACT:DMF0042_1_BizPlan.InsertRow ACT:DMF0) |
| WK-DMF0042-1430 | X-ROW | DMF0042_1_BizPlan.MinColumnChk | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 10 (ACT:DMF0042_1_BizPlan.MinColumnChk ACT:D) |
| WK-DMF0042-1431 | X-ROW | DMF0042_1_BizPlan.OnShown | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 3 (ACT:DMF0042_1_BizPlan.OnShown ACT:DMF004) |
| WK-DMF0042-1432 | X-ROW | DMF0042_1_BizPlan.ParameterString | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 17 (ACT:DMF0042_1_BizPlan.ParameterString AC) |
| WK-DMF0042-1433 | X-ROW | DMF0042_1_BizPlan.SaveButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — ERROR:4 · NOT_RUN:2 |  | 1 (ACT:DMF0042_1_BizPlan.SaveButton:677:1) |
| WK-DMF0042-1434 | X-ROW | DMF0042_1_BizPlan.SaveData | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 23검사 — ERROR:18 · NOT_RUN:3 · PASS:2 |  | 180 (ACT:DMF0042_1_BizPlan.SaveData:803:1 ACT) |
| WK-DMF0042-1435 | X-ROW | DMF0042_1_BizPlan.SetCellColor | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 5 (ACT:DMF0042_1_BizPlan.SetCellColor ACT:D) |
| WK-DMF0042-1436 | X-ROW | DMF0042_1_BizPlan.SetSpreadColumn | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 11검사 — ERROR:7 · NOT_RUN:3 · NA:1 |  | 19 (ACT:DMF0042_1_BizPlan.SetSpreadColumn:46) |
| WK-DMF0042-1437 | X-ROW | DMF0042_1_BizPlan.SetSpreadHeaderSpan | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 31검사 — NOT_RUN:25 · ERROR:5 · NA:1 |  | 53 (ACT:DMF0042_1_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-1438 | X-ROW | DMF0042_1_BizPlan.ValidationCheck | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — ERROR:4 |  | 7 (ACT:DMF0042_1_BizPlan.ValidationCheck AC) |
| WK-DMF0042-1439 | X-ROW | DMF0042_1_BizPlan.btnColumn_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 11검사 — ERROR:7 · NA:2 · NOT_RUN:1 · NOPATH:1 |  | 5 (ACT:DMF0042_1_BizPlan.btnColumn_Click:28) |
| WK-DMF0042-1440 | X-ROW | DMF0042_1_BizPlan.btnCutOff_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 8검사 — ERROR:8 |  | 11 (ACT:DMF0042_1_BizPlan.btnCutOff_Click:28) |
| WK-DMF0042-1441 | X-ROW | DMF0042_1_BizPlan.btnExchangeRate_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 15검사 — ERROR:15 |  | 9 (ACT:DMF0042_1_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1442 | X-ROW | DMF0042_1_BizPlan.btnItemId_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 11검사 — ERROR:8 · NA:3 |  | 13 (ACT:DMF0042_1_BizPlan.btnItemId_Click:27) |
| WK-DMF0042-1443 | X-ROW | DMF0042_1_BizPlan.btnMeasure_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 11검사 — ERROR:7 · NA:2 · NOT_RUN:1 · NOPATH:1 |  | 5 (ACT:DMF0042_1_BizPlan.btnMeasure_Click:2) |
| WK-DMF0042-1444 | X-ROW | DMF0042_1_BizPlan.btnOwner_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 11검사 — ERROR:8 · NA:3 |  | 12 (ACT:DMF0042_1_BizPlan.btnOwner_Click:294) |
| WK-DMF0042-1445 | X-ROW | DMF0042_1_BizPlan.btnProject_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 11검사 — ERROR:8 · NA:3 |  | 13 (ACT:DMF0042_1_BizPlan.btnProject_Click:2) |
| WK-DMF0042-1446 | X-ROW | DMF0042_1_BizPlan.btnReplace_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 10검사 — ERROR:10 |  | 44 (ACT:DMF0042_1_BizPlan.btnReplace_Click:3) |
| WK-DMF0042-1447 | X-ROW | DMF0042_1_BizPlan.btnSetPrice_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 13검사 — ERROR:7 · NOT_RUN:4 · PASS:2 |  | 11 (ACT:DMF0042_1_BizPlan.btnSetPrice_Click:) |
| WK-DMF0042-1448 | X-ROW | DMF0042_1_BizPlan.cboBucketType_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — ERROR:6 |  | 4 (ACT:DMF0042_1_BizPlan.cboBucketType_Clic) |
| WK-DMF0042-1449 | X-ROW | DMF0042_1_BizPlan.cboBucketType_Selected | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 6 (ACT:DMF0042_1_BizPlan.cboBucketType_Sele) |
| WK-DMF0042-1450 | X-ROW | DMF0042_1_BizPlan.cboDivision_SelectedIn | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 11검사 — NOT_RUN:7 · ERROR:4 |  | 47 (ACT:DMF0042_1_BizPlan.cboDivision_Select) |
| WK-DMF0042-1451 | X-ROW | DMF0042_1_BizPlan.chkSum_CheckedChanged | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 3 (ACT:DMF0042_1_BizPlan.chkSum_CheckedChan) |
| WK-DMF0042-1452 | X-ROW | DMF0042_1_BizPlan.clbCustomer_SelectedIn | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 8검사 — ERROR:7 · NOT_RUN:1 |  | 5 (ACT:DMF0042_1_BizPlan.clbCustomer_Select) |
| WK-DMF0042-1453 | X-ROW | DMF0042_1_BizPlan.clbTeam_SelectedIndexC | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 7검사 — ERROR:5 · NOT_RUN:2 |  | 13 (ACT:DMF0042_1_BizPlan.clbTeam_SelectedIn) |
| WK-DMF0042-1454 | X-ROW | DMF0042_1_BizPlan.fnValidation | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 48 (ACT:DMF0042_1_BizPlan.fnValidation ACT:D) |
| WK-DMF0042-1455 | X-ROW | DMF0042_1_BizPlan.spdMain_CellDoubleClic | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 61검사 — NOT_RUN:26 · ERROR:21 · NA:11 · NOPATH:3 |  | 120 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1456 | X-ROW | DMF0042_1_BizPlan.spdMain_Changed | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 68검사 — ERROR:43 · NA:23 · NOT_RUN:2 |  | 425 (ACT:DMF0042_1_BizPlan.spdMain_Changed:18) |
| WK-DMF0042-1457 | X-ROW | DMF0042_1_BizPlan.spdMain_ComboSelChange | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 27검사 — ERROR:24 · NOT_RUN:3 |  | 16 (ACT:DMF0042_1_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-1458 | X-ROW | DMF0042_1_BizPlan.spdMain_EditChange | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 4 (ACT:DMF0042_1_BizPlan.spdMain_EditChange) |
| WK-DMF0042-1459 | X-ROW | DMF0042_1_BizPlan.spdMain_TopChange | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:2 |  | 4 (ACT:DMF0042_1_BizPlan.spdMain_TopChange ) |
| WK-DMF0042-1460 | X-ROW | DMF0042_1_RTF.CreateSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:DMF0042_1_RTF.CreateSpread ACT:DMF00) |
| WK-DMF0042-1461 | X-ROW | DMF0042_1_RTF.DMF0003_CustDemandAnalysis | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0042_1_RTF.DMF0003_CustDemandAnal) |
| WK-DMF0042-1462 | X-ROW | DMF0042_1_RTF.DefineProperty | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — ERROR:1 · NOT_RUN:1 · WARN:1 |  | 3 (ACT:DMF0042_1_RTF.DefineProperty ACT:DMF) |
| WK-DMF0042-1463 | X-ROW | DMF0042_1_RTF.Dispose | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:2 (미실행 검사가 남아 판정필요) |  | 3 (ACT:DMF0042_1_RTF.Dispose:16:1 ACT:DMF00) |
| WK-DMF0042-1464 | X-ROW | DMF0042_1_RTF.EditButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 4 (ACT:DMF0042_1_RTF.EditButton ACT:DMF0042) |
| WK-DMF0042-1465 | X-ROW | DMF0042_1_RTF.Form_Load | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:1 · NOT_RUN:1 |  | 12 (ACT:DMF0042_1_RTF.Form_Load ACT:DMF0042_) |
| WK-DMF0042-1466 | X-ROW | DMF0042_1_RTF.GetSLOC | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:2 · ERROR:1 · NA:1 |  | 12 (ACT:DMF0042_1_RTF.GetSLOC ACT:DMF0042_1_) |
| WK-DMF0042-1467 | X-ROW | DMF0042_1_RTF.GetSPlant | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:2 · ERROR:1 · NA:1 |  | 12 (ACT:DMF0042_1_RTF.GetSPlant ACT:DMF0042_) |
| WK-DMF0042-1468 | X-ROW | DMF0042_1_RTF.GetSplit | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 5 (ACT:DMF0042_1_RTF.GetSplit ACT:DMF0042_1) |
| WK-DMF0042-1469 | X-ROW | DMF0042_1_RTF.InitControls | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:1 · NOT_RUN:1 |  | 2 (ACT:DMF0042_1_RTF.InitControls ACT:DMF00) |
| WK-DMF0042-1470 | X-ROW | DMF0042_1_RTF.InitSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 38검사 — NOT_RUN:31 · ERROR:7 |  | 36 (ACT:DMF0042_1_RTF.InitSpread ACT:DMF0042) |
| WK-DMF0042-1471 | X-ROW | DMF0042_1_RTF.SaveButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — ERROR:4 · NOT_RUN:1 |  | 1 (ACT:DMF0042_1_RTF.SaveButton:379:1) |
| WK-DMF0042-1472 | X-ROW | DMF0042_1_RTF.SaveData | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — ERROR:5 · NA:2 · NOT_RUN:2 |  | 63 (ACT:DMF0042_1_RTF.SaveData:388:1 ACT:DMF) |
| WK-DMF0042-1473 | X-ROW | DMF0042_1_RTF.Select_DpInit_Data | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 25검사 — ERROR:15 · NOT_RUN:7 · NA:1 · PASS:1 · REVIEW:1 |  | 59 (ACT:DMF0042_1_RTF.Select_DpInit_Data ACT) |
| WK-DMF0042-1474 | X-ROW | DMF0042_1_RTF.Select_DpResult_Data | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 25검사 — ERROR:15 · NOT_RUN:7 · PASS:1 · REVIEW:1 · NA:1 |  | 58 (ACT:DMF0042_1_RTF.Select_DpResult_Data A) |
| WK-DMF0042-1475 | X-ROW | DMF0042_1_RTF.Select_In_De_Demand | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — ERROR:2 · NOT_RUN:1 |  | 24 (ACT:DMF0042_1_RTF.Select_In_De_Demand AC) |
| WK-DMF0042-1476 | X-ROW | DMF0042_1_RTF.btnButtonList_UsrButtonLis | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — ERROR:2 · NOT_RUN:1 |  | 11 (ACT:DMF0042_1_RTF.btnButtonList_UsrButto) |
| WK-DMF0042-1477 | X-ROW | DMF0042_1_RTF.sheetSetting | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:1 · NOT_RUN:1 |  | 4 (ACT:DMF0042_1_RTF.sheetSetting ACT:DMF00) |
| WK-DMF0042-1478 | X-ROW | DMF0042_1_RTF.spdMain_CellClick | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — NOT_RUN:3 · ERROR:2 |  | 38 (ACT:DMF0042_1_RTF.spdMain_CellClick ACT:) |
| WK-DMF0042-1479 | X-ROW | DMF0042_1_RTF.spdMain_ComboCloseUp | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 12검사 — NOT_RUN:9 · ERROR:3 |  | 35 (ACT:DMF0042_1_RTF.spdMain_ComboCloseUp:1) |
| WK-DMF0042-1480 | X-ROW | DMF0042_1_RTF.spdMain_KeyUp | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0042_1_RTF.spdMain_KeyUp ACT:DMF0) |
| WK-DMF0042-1481 | X-ROW | DMF0042_1_RTF.spdMain_LeaveCell | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — NOT_RUN:1 (미실행 검사가 남아 판정필요) |  | 2 (ACT:DMF0042_1_RTF.spdMain_LeaveCell ACT:) |
| WK-DMF0042-1482 | X-ROW | DMF0042_2_BizPlan.CreateSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — ERROR:4 |  | 1 (ACT:DMF0042_2_BizPlan.CreateSpread) |
| WK-DMF0042-1483 | X-ROW | DMF0042_2_BizPlan.DefineProperty | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 7검사 — NOT_RUN:4 · ERROR:1 · NOPATH:1 · WARN:1 |  | 5 (ACT:DMF0042_2_BizPlan.DefineProperty:318) |
| WK-DMF0042-1484 | X-ROW | DMF0042_2_BizPlan.DeleteButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — ERROR:3 |  | 1 (ACT:DMF0042_2_BizPlan.DeleteButton:530:5) |
| WK-DMF0042-1485 | X-ROW | DMF0042_2_BizPlan.Form_Load | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 1 (ACT:DMF0042_2_BizPlan.Form_Load) |
| WK-DMF0042-1486 | X-ROW | DMF0042_2_BizPlan.GetBizTypebyDivision | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — NOT_RUN:2 · ERROR:2 · NOPATH:1 |  | 1 (ACT:DMF0042_2_BizPlan.GetBizTypebyDivisi) |
| WK-DMF0042-1487 | X-ROW | DMF0042_2_BizPlan.GetCellColor | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — ERROR:3 |  | 1 (ACT:DMF0042_2_BizPlan.GetCellColor) |
| WK-DMF0042-1488 | X-ROW | DMF0042_2_BizPlan.GetCellIndexBySpanRowC | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:2 |  | 1 (ACT:DMF0042_2_BizPlan.GetCellIndexBySpan) |
| WK-DMF0042-1489 | X-ROW | DMF0042_2_BizPlan.GetCellNumbersByRow | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:2 |  | 1 (ACT:DMF0042_2_BizPlan.GetCellNumbersByRo) |
| WK-DMF0042-1490 | X-ROW | DMF0042_2_BizPlan.GetCellProdSite | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — ERROR:3 · NA:1 · NOT_RUN:1 |  | 1 (ACT:DMF0042_2_BizPlan.GetCellProdSite) |
| WK-DMF0042-1491 | X-ROW | DMF0042_2_BizPlan.GetDayRange | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — ERROR:3 · NOT_RUN:1 · NA:1 |  | 1 (ACT:DMF0042_2_BizPlan.GetDayRange) |
| WK-DMF0042-1492 | X-ROW | DMF0042_2_BizPlan.GetLookupData | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — NOT_RUN:2 · ERROR:2 · NOPATH:1 |  | 1 (ACT:DMF0042_2_BizPlan.GetLookupData) |
| WK-DMF0042-1493 | X-ROW | DMF0042_2_BizPlan.InitControls | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 33검사 — NOT_RUN:28 · NOPATH:3 · ERROR:2 |  | 24 (ACT:DMF0042_2_BizPlan.InitControls:228:1) |
| WK-DMF0042-1494 | X-ROW | DMF0042_2_BizPlan.InitSaveDataTable | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 1 (ACT:DMF0042_2_BizPlan.InitSaveDataTable) |
| WK-DMF0042-1495 | X-ROW | DMF0042_2_BizPlan.InitSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:2 · ERROR:2 |  | 1 (ACT:DMF0042_2_BizPlan.InitSpread) |
| WK-DMF0042-1496 | X-ROW | DMF0042_2_BizPlan.InsertButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 1 (ACT:DMF0042_2_BizPlan.InsertButton) |
| WK-DMF0042-1497 | X-ROW | DMF0042_2_BizPlan.InsertRow | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 49검사 — ERROR:34 · NOPATH:6 · NOT_RUN:5 · NA:4 |  | 60 (ACT:DMF0042_2_BizPlan.InsertRow ACT:DMF0) |
| WK-DMF0042-1498 | X-ROW | DMF0042_2_BizPlan.SaveData | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 19검사 — ERROR:17 · NA:1 · NOT_RUN:1 |  | 1 (ACT:DMF0042_2_BizPlan.SaveData:1290:248) |
| WK-DMF0042-1499 | X-ROW | DMF0042_2_BizPlan.SetCellColor | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — ERROR:3 |  | 2 (ACT:DMF0042_2_BizPlan.SetCellColor ACT:D) |
| WK-DMF0042-1500 | X-ROW | DMF0042_2_BizPlan.SetSpreadColumn | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 14검사 — ERROR:10 · NOT_RUN:2 · NA:2 |  | 8 (ACT:DMF0042_2_BizPlan.SetSpreadColumn:46) |
| WK-DMF0042-1501 | X-ROW | DMF0042_2_BizPlan.ValidationCheck | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — ERROR:3 |  | 7 (ACT:DMF0042_2_BizPlan.ValidationCheck AC) |
| WK-DMF0042-1502 | X-ROW | DMF0042_2_BizPlan.btnColumn_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — ERROR:5 · NA:2 · NOT_RUN:1 · NOPATH:1 |  | 2 (ACT:DMF0042_2_BizPlan.btnColumn_Click:30) |
| WK-DMF0042-1503 | X-ROW | DMF0042_2_BizPlan.btnCutOff_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — ERROR:6 |  | 4 (ACT:DMF0042_2_BizPlan.btnCutOff_Click:30) |
| WK-DMF0042-1504 | X-ROW | DMF0042_2_BizPlan.btnExchangeRate_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 12검사 — ERROR:12 |  | 2 (ACT:DMF0042_2_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1505 | X-ROW | DMF0042_2_BizPlan.btnItemId_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — ERROR:6 · NA:3 |  | 5 (ACT:DMF0042_2_BizPlan.btnItemId_Click:30) |
| WK-DMF0042-1506 | X-ROW | DMF0042_2_BizPlan.btnMeasure_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — ERROR:5 · NA:2 · NOT_RUN:1 · NOPATH:1 |  | 2 (ACT:DMF0042_2_BizPlan.btnMeasure_Click:3) |
| WK-DMF0042-1507 | X-ROW | DMF0042_2_BizPlan.btnOwner_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — ERROR:6 · NA:3 |  | 5 (ACT:DMF0042_2_BizPlan.btnOwner_Click:317) |
| WK-DMF0042-1508 | X-ROW | DMF0042_2_BizPlan.btnProject_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — ERROR:6 · NA:3 |  | 5 (ACT:DMF0042_2_BizPlan.btnProject_Click:2) |
| WK-DMF0042-1509 | X-ROW | DMF0042_2_BizPlan.btnReplace_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 8검사 — ERROR:8 |  | 6 (ACT:DMF0042_2_BizPlan.btnReplace_Click:3) |
| WK-DMF0042-1510 | X-ROW | DMF0042_2_BizPlan.btnSetPrice_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — ERROR:7 · NOT_RUN:1 · NA:1 |  | 2 (ACT:DMF0042_2_BizPlan.btnSetPrice_Click:) |
| WK-DMF0042-1511 | X-ROW | DMF0042_2_BizPlan.cboBucketType_Selected | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — ERROR:3 |  | 1 (ACT:DMF0042_2_BizPlan.cboBucketType_Sele) |
| WK-DMF0042-1512 | X-ROW | DMF0042_2_BizPlan.cboDivision_SelectedIn | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 10검사 — NOT_RUN:7 · ERROR:3 |  | 13 (ACT:DMF0042_2_BizPlan.cboDivision_Select) |
| WK-DMF0042-1513 | X-ROW | DMF0042_2_BizPlan.chkSum_CheckedChanged | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — ERROR:3 |  | 1 (ACT:DMF0042_2_BizPlan.chkSum_CheckedChan) |
| WK-DMF0042-1514 | X-ROW | DMF0042_2_BizPlan.clbCustomer_SelectedIn | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 10검사 — ERROR:9 · NOT_RUN:1 |  | 1 (ACT:DMF0042_2_BizPlan.clbCustomer_Select) |
| WK-DMF0042-1515 | X-ROW | DMF0042_2_BizPlan.clbTeam_SelectedIndexC | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — ERROR:7 · NOT_RUN:2 |  | 3 (ACT:DMF0042_2_BizPlan.clbTeam_SelectedIn) |
| WK-DMF0042-1516 | X-ROW | DMF0042_2_BizPlan.spdMain_CellDoubleClic | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 76검사 — NOT_RUN:40 · ERROR:23 · NA:12 · NOPATH:1 |  | 31 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1517 | X-ROW | DMF0042_2_BizPlan.spdMain_Changed | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 60검사 — ERROR:38 · NA:21 · NOT_RUN:1 |  | 33 (ACT:DMF0042_2_BizPlan.spdMain_Changed:20) |
| WK-DMF0042-1518 | X-ROW | DMF0042_2_BizPlan.spdMain_ComboSelChange | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 54검사 — ERROR:26 · NA:16 · NOT_RUN:8 · NOPATH:4 |  | 6 (ACT:DMF0042_2_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-1519 | X-ROW | DMF0042_2_BizPlan.spdMain_TopChange | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 2 (ACT:DMF0042_2_BizPlan.spdMain_TopChange ) |
| WK-DMF0042-1520 | X-ROW | DMF0042_3_BizPlan..ctor | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — WARN:1 · ERROR:1 |  | 3 (ACT:DMF0042_3_BizPlan..ctor:226:1 ACT:DM) |
| WK-DMF0042-1521 | X-ROW | DMF0042_3_BizPlan.CreateSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 5 (ACT:DMF0042_3_BizPlan.CreateSpread ACT:D) |
| WK-DMF0042-1522 | X-ROW | DMF0042_3_BizPlan.DefineProperty | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — NOT_RUN:4 · ERROR:3 · WARN:1 · NOPATH:1 |  | 13 (ACT:DMF0042_3_BizPlan.DefineProperty:352) |
| WK-DMF0042-1523 | X-ROW | DMF0042_3_BizPlan.DeleteButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — ERROR:4 |  | 6 (ACT:DMF0042_3_BizPlan.DeleteButton:553:1) |
| WK-DMF0042-1524 | X-ROW | DMF0042_3_BizPlan.Dispose | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · ERROR:1 |  | 3 (ACT:DMF0042_3_BizPlan.Dispose:16:1 ACT:D) |
| WK-DMF0042-1525 | X-ROW | DMF0042_3_BizPlan.EditButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 29검사 — ERROR:26 · NA:3 |  | 48 (ACT:DMF0042_3_BizPlan.EditButton:567:1 A) |
| WK-DMF0042-1526 | X-ROW | DMF0042_3_BizPlan.Form_Load | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:2 |  | 7 (ACT:DMF0042_3_BizPlan.Form_Load ACT:DMF0) |
| WK-DMF0042-1527 | X-ROW | DMF0042_3_BizPlan.GetBizTypebyDivision | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:2 · NOPATH:1 · ERROR:1 |  | 7 (ACT:DMF0042_3_BizPlan.GetBizTypebyDivisi) |
| WK-DMF0042-1528 | X-ROW | DMF0042_3_BizPlan.GetCellColor | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 6 (ACT:DMF0042_3_BizPlan.GetCellColor ACT:D) |
| WK-DMF0042-1529 | X-ROW | DMF0042_3_BizPlan.GetCellIndexBySpanRowC | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 5 (ACT:DMF0042_3_BizPlan.GetCellIndexBySpan) |
| WK-DMF0042-1530 | X-ROW | DMF0042_3_BizPlan.GetCellNumbersByRow | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 15 (ACT:DMF0042_3_BizPlan.GetCellNumbersByRo) |
| WK-DMF0042-1531 | X-ROW | DMF0042_3_BizPlan.GetCellProdSite | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — ERROR:2 · NA:1 · NOT_RUN:1 |  | 12 (ACT:DMF0042_3_BizPlan.GetCellProdSite AC) |
| WK-DMF0042-1532 | X-ROW | DMF0042_3_BizPlan.GetComboData | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:2 · ERROR:1 · NOPATH:1 |  | 10 (ACT:DMF0042_3_BizPlan.GetComboData ACT:D) |
| WK-DMF0042-1533 | X-ROW | DMF0042_3_BizPlan.GetDayRange | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — ERROR:2 · NA:1 · NOT_RUN:1 |  | 8 (ACT:DMF0042_3_BizPlan.GetDayRange ACT:DM) |
| WK-DMF0042-1534 | X-ROW | DMF0042_3_BizPlan.GetFuturePriceInfo | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — NA:2 · NOT_RUN:2 · ERROR:1 · PASS:1 |  | 9 (ACT:DMF0042_3_BizPlan.GetFuturePriceInfo) |
| WK-DMF0042-1535 | X-ROW | DMF0042_3_BizPlan.GetLookupData | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:2 · NOPATH:1 · ERROR:1 |  | 7 (ACT:DMF0042_3_BizPlan.GetLookupData ACT:) |
| WK-DMF0042-1536 | X-ROW | DMF0042_3_BizPlan.GetSpdTitle | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 8검사 — ERROR:4 · NA:3 · NOT_RUN:1 |  | 8 (ACT:DMF0042_3_BizPlan.GetSpdTitle:3000:1) |
| WK-DMF0042-1537 | X-ROW | DMF0042_3_BizPlan.GetThisWeekMonday | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NA:2 · ERROR:1 |  | 10 (ACT:DMF0042_3_BizPlan.GetThisWeekMonday ) |
| WK-DMF0042-1538 | X-ROW | DMF0042_3_BizPlan.InitControls | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 37검사 — NOT_RUN:28 · ERROR:6 · NOPATH:3 |  | 48 (ACT:DMF0042_3_BizPlan.InitControls:259:1) |
| WK-DMF0042-1539 | X-ROW | DMF0042_3_BizPlan.InitSaveDataTable | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:2 |  | 6 (ACT:DMF0042_3_BizPlan.InitSaveDataTable ) |
| WK-DMF0042-1540 | X-ROW | DMF0042_3_BizPlan.InitSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — ERROR:3 · NOT_RUN:2 |  | 7 (ACT:DMF0042_3_BizPlan.InitSpread ACT:DMF) |
| WK-DMF0042-1541 | X-ROW | DMF0042_3_BizPlan.InsertButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:2 |  | 2 (ACT:DMF0042_3_BizPlan.InsertButton ACT:D) |
| WK-DMF0042-1542 | X-ROW | DMF0042_3_BizPlan.InsertRow | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 214검사 — ERROR:165 · NA:34 · NOT_RUN:12 · NOPATH:3 |  | 178 (ACT:DMF0042_3_BizPlan.InsertRow ACT:DMF0) |
| WK-DMF0042-1543 | X-ROW | DMF0042_3_BizPlan.MinColumnChk | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 10 (ACT:DMF0042_3_BizPlan.MinColumnChk ACT:D) |
| WK-DMF0042-1544 | X-ROW | DMF0042_3_BizPlan.OnShown | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 3 (ACT:DMF0042_3_BizPlan.OnShown ACT:DMF004) |
| WK-DMF0042-1545 | X-ROW | DMF0042_3_BizPlan.ParameterString | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 17 (ACT:DMF0042_3_BizPlan.ParameterString AC) |
| WK-DMF0042-1546 | X-ROW | DMF0042_3_BizPlan.SaveButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — ERROR:4 · NOT_RUN:1 |  | 1 (ACT:DMF0042_3_BizPlan.SaveButton:703:1) |
| WK-DMF0042-1547 | X-ROW | DMF0042_3_BizPlan.SaveData | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 21검사 — ERROR:18 · NOT_RUN:2 · PASS:1 |  | 187 (ACT:DMF0042_3_BizPlan.SaveData:829:1 ACT) |
| WK-DMF0042-1548 | X-ROW | DMF0042_3_BizPlan.SetCellColor | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 5 (ACT:DMF0042_3_BizPlan.SetCellColor ACT:D) |
| WK-DMF0042-1549 | X-ROW | DMF0042_3_BizPlan.SetComboCol | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 15 (ACT:DMF0042_3_BizPlan.SetComboCol ACT:DM) |
| WK-DMF0042-1550 | X-ROW | DMF0042_3_BizPlan.SetComboColumn | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — ERROR:2 · NOT_RUN:2 · NA:1 |  | 6 (ACT:DMF0042_3_BizPlan.SetComboColumn:293) |
| WK-DMF0042-1551 | X-ROW | DMF0042_3_BizPlan.SetSpreadColumn | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 11검사 — ERROR:7 · NOT_RUN:3 · NA:1 |  | 19 (ACT:DMF0042_3_BizPlan.SetSpreadColumn:49) |
| WK-DMF0042-1552 | X-ROW | DMF0042_3_BizPlan.SetSpreadHeaderSpan | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 31검사 — NOT_RUN:25 · ERROR:5 · NA:1 |  | 53 (ACT:DMF0042_3_BizPlan.SetSpreadHeaderSpa) |
| WK-DMF0042-1553 | X-ROW | DMF0042_3_BizPlan.ValidationCheck | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — ERROR:4 |  | 7 (ACT:DMF0042_3_BizPlan.ValidationCheck AC) |
| WK-DMF0042-1554 | X-ROW | DMF0042_3_BizPlan.btnColumn_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 11검사 — ERROR:7 · NA:2 · NOT_RUN:1 · NOPATH:1 |  | 5 (ACT:DMF0042_3_BizPlan.btnColumn_Click:28) |
| WK-DMF0042-1555 | X-ROW | DMF0042_3_BizPlan.btnCutOff_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 8검사 — ERROR:8 |  | 11 (ACT:DMF0042_3_BizPlan.btnCutOff_Click:29) |
| WK-DMF0042-1556 | X-ROW | DMF0042_3_BizPlan.btnExchangeRate_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 15검사 — ERROR:15 |  | 9 (ACT:DMF0042_3_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1557 | X-ROW | DMF0042_3_BizPlan.btnItemId_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 11검사 — ERROR:8 · NA:3 |  | 13 (ACT:DMF0042_3_BizPlan.btnItemId_Click:28) |
| WK-DMF0042-1558 | X-ROW | DMF0042_3_BizPlan.btnMeasure_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 11검사 — ERROR:7 · NA:2 · NOT_RUN:1 · NOPATH:1 |  | 5 (ACT:DMF0042_3_BizPlan.btnMeasure_Click:2) |
| WK-DMF0042-1559 | X-ROW | DMF0042_3_BizPlan.btnOwner_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 11검사 — ERROR:8 · NA:3 |  | 12 (ACT:DMF0042_3_BizPlan.btnOwner_Click:305) |
| WK-DMF0042-1560 | X-ROW | DMF0042_3_BizPlan.btnProject_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 11검사 — ERROR:8 · NA:3 |  | 13 (ACT:DMF0042_3_BizPlan.btnProject_Click:2) |
| WK-DMF0042-1561 | X-ROW | DMF0042_3_BizPlan.btnReplace_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 10검사 — ERROR:10 |  | 44 (ACT:DMF0042_3_BizPlan.btnReplace_Click:3) |
| WK-DMF0042-1562 | X-ROW | DMF0042_3_BizPlan.btnSetPrice_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 11검사 — ERROR:7 · NOT_RUN:3 · PASS:1 |  | 11 (ACT:DMF0042_3_BizPlan.btnSetPrice_Click:) |
| WK-DMF0042-1563 | X-ROW | DMF0042_3_BizPlan.cboBucketType_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — ERROR:6 |  | 4 (ACT:DMF0042_3_BizPlan.cboBucketType_Clic) |
| WK-DMF0042-1564 | X-ROW | DMF0042_3_BizPlan.cboBucketType_Selected | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 6 (ACT:DMF0042_3_BizPlan.cboBucketType_Sele) |
| WK-DMF0042-1565 | X-ROW | DMF0042_3_BizPlan.cboDivision_SelectedIn | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 11검사 — NOT_RUN:7 · ERROR:4 |  | 47 (ACT:DMF0042_3_BizPlan.cboDivision_Select) |
| WK-DMF0042-1566 | X-ROW | DMF0042_3_BizPlan.chkSum_CheckedChanged | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 3 (ACT:DMF0042_3_BizPlan.chkSum_CheckedChan) |
| WK-DMF0042-1567 | X-ROW | DMF0042_3_BizPlan.clbCustomer_SelectedIn | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 8검사 — ERROR:7 · NOT_RUN:1 |  | 5 (ACT:DMF0042_3_BizPlan.clbCustomer_Select) |
| WK-DMF0042-1568 | X-ROW | DMF0042_3_BizPlan.clbTeam_SelectedIndexC | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 7검사 — ERROR:5 · NOT_RUN:2 |  | 13 (ACT:DMF0042_3_BizPlan.clbTeam_SelectedIn) |
| WK-DMF0042-1569 | X-ROW | DMF0042_3_BizPlan.fnValidation | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 48 (ACT:DMF0042_3_BizPlan.fnValidation ACT:D) |
| WK-DMF0042-1570 | X-ROW | DMF0042_3_BizPlan.spdMain_CellDoubleClic | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 61검사 — NOT_RUN:26 · ERROR:21 · NA:11 · NOPATH:3 |  | 120 (ACT:DMF0042_3_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1571 | X-ROW | DMF0042_3_BizPlan.spdMain_Changed | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 68검사 — ERROR:43 · NA:23 · NOT_RUN:2 |  | 425 (ACT:DMF0042_3_BizPlan.spdMain_Changed:18) |
| WK-DMF0042-1572 | X-ROW | DMF0042_3_BizPlan.spdMain_ComboSelChange | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 27검사 — ERROR:24 · NOT_RUN:3 |  | 16 (ACT:DMF0042_3_BizPlan.spdMain_ComboSelCh) |
| WK-DMF0042-1573 | X-ROW | DMF0042_3_BizPlan.spdMain_EditChange | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 4 (ACT:DMF0042_3_BizPlan.spdMain_EditChange) |
| WK-DMF0042-1574 | X-ROW | DMF0042_3_BizPlan.spdMain_TopChange | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:2 |  | 4 (ACT:DMF0042_3_BizPlan.spdMain_TopChange ) |
| WK-DMF0042-1575 | X-ROW | DMF0042_BizPlan..ctor | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — WARN:1 · ERROR:1 |  | 3 (ACT:DMF0042_BizPlan..ctor:215:1 ACT:DMF0) |
| WK-DMF0042-1576 | X-ROW | DMF0042_BizPlan.CreateSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 5 (ACT:DMF0042_BizPlan.CreateSpread ACT:DMF) |
| WK-DMF0042-1577 | X-ROW | DMF0042_BizPlan.DefineProperty | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — NOT_RUN:4 · ERROR:3 · WARN:1 · NOPATH:1 |  | 13 (ACT:DMF0042_BizPlan.DefineProperty:341:1) |
| WK-DMF0042-1578 | X-ROW | DMF0042_BizPlan.DeleteButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — ERROR:4 |  | 6 (ACT:DMF0042_BizPlan.DeleteButton:551:1 A) |
| WK-DMF0042-1579 | X-ROW | DMF0042_BizPlan.Dispose | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · ERROR:1 |  | 3 (ACT:DMF0042_BizPlan.Dispose:16:1 ACT:DMF) |
| WK-DMF0042-1580 | X-ROW | DMF0042_BizPlan.EditButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 18검사 — ERROR:17 · NA:1 |  | 38 (ACT:DMF0042_BizPlan.EditButton:565:1 ACT) |
| WK-DMF0042-1581 | X-ROW | DMF0042_BizPlan.ExcelButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 15 (ACT:DMF0042_BizPlan.ExcelButton ACT:DMF0) |
| WK-DMF0042-1582 | X-ROW | DMF0042_BizPlan.Form_Load | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:2 |  | 7 (ACT:DMF0042_BizPlan.Form_Load ACT:DMF004) |
| WK-DMF0042-1583 | X-ROW | DMF0042_BizPlan.GetBizTypebyDivision | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:2 · NOPATH:1 · ERROR:1 |  | 7 (ACT:DMF0042_BizPlan.GetBizTypebyDivision) |
| WK-DMF0042-1584 | X-ROW | DMF0042_BizPlan.GetCellColor | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 6 (ACT:DMF0042_BizPlan.GetCellColor ACT:DMF) |
| WK-DMF0042-1585 | X-ROW | DMF0042_BizPlan.GetCellIndexBySpanRowCel | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 5 (ACT:DMF0042_BizPlan.GetCellIndexBySpanRo) |
| WK-DMF0042-1586 | X-ROW | DMF0042_BizPlan.GetCellNumbersByRow | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 15 (ACT:DMF0042_BizPlan.GetCellNumbersByRow ) |
| WK-DMF0042-1587 | X-ROW | DMF0042_BizPlan.GetCellProdSite | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — ERROR:2 · NA:1 · NOT_RUN:1 |  | 12 (ACT:DMF0042_BizPlan.GetCellProdSite ACT:) |
| WK-DMF0042-1588 | X-ROW | DMF0042_BizPlan.GetDayRange | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — ERROR:2 · NA:1 · NOT_RUN:1 |  | 8 (ACT:DMF0042_BizPlan.GetDayRange ACT:DMF0) |
| WK-DMF0042-1589 | X-ROW | DMF0042_BizPlan.GetFuturePriceInfo | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — NOT_RUN:2 · NA:2 · PASS:1 · ERROR:1 |  | 9 (ACT:DMF0042_BizPlan.GetFuturePriceInfo:3) |
| WK-DMF0042-1590 | X-ROW | DMF0042_BizPlan.GetLookupData | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:2 · NOPATH:1 · ERROR:1 |  | 7 (ACT:DMF0042_BizPlan.GetLookupData ACT:DM) |
| WK-DMF0042-1591 | X-ROW | DMF0042_BizPlan.GetSpdTitle | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 8검사 — ERROR:3 · NOT_RUN:2 · NA:2 · PASS:1 |  | 8 (ACT:DMF0042_BizPlan.GetSpdTitle:2949:1 A) |
| WK-DMF0042-1592 | X-ROW | DMF0042_BizPlan.GetThisWeekMonday | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NA:2 · ERROR:1 |  | 10 (ACT:DMF0042_BizPlan.GetThisWeekMonday AC) |
| WK-DMF0042-1593 | X-ROW | DMF0042_BizPlan.InitControls | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 37검사 — NOT_RUN:28 · ERROR:6 · NOPATH:3 |  | 48 (ACT:DMF0042_BizPlan.InitControls:248:1 A) |
| WK-DMF0042-1594 | X-ROW | DMF0042_BizPlan.InitSaveDataTable | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:2 |  | 6 (ACT:DMF0042_BizPlan.InitSaveDataTable AC) |
| WK-DMF0042-1595 | X-ROW | DMF0042_BizPlan.InitSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — NOT_RUN:5 · ERROR:4 |  | 9 (ACT:DMF0042_BizPlan.InitSpread:387:1 ACT) |
| WK-DMF0042-1596 | X-ROW | DMF0042_BizPlan.InsertButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:2 |  | 2 (ACT:DMF0042_BizPlan.InsertButton ACT:DMF) |
| WK-DMF0042-1597 | X-ROW | DMF0042_BizPlan.InsertRow | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 198검사 — ERROR:150 · NA:31 · NOT_RUN:11 · NOPATH:6 |  | 165 (ACT:DMF0042_BizPlan.InsertRow ACT:DMF004) |
| WK-DMF0042-1598 | X-ROW | DMF0042_BizPlan.MinColumnChk | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 10 (ACT:DMF0042_BizPlan.MinColumnChk ACT:DMF) |
| WK-DMF0042-1599 | X-ROW | DMF0042_BizPlan.OnShown | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 3 (ACT:DMF0042_BizPlan.OnShown ACT:DMF0042_) |
| WK-DMF0042-1600 | X-ROW | DMF0042_BizPlan.ParameterString | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 17 (ACT:DMF0042_BizPlan.ParameterString ACT:) |
| WK-DMF0042-1601 | X-ROW | DMF0042_BizPlan.SaveButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 7검사 — ERROR:4 · NOT_RUN:3 |  | 1 (ACT:DMF0042_BizPlan.SaveButton:701:1) |
| WK-DMF0042-1602 | X-ROW | DMF0042_BizPlan.SaveData | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 25검사 — ERROR:18 · NOT_RUN:4 · PASS:3 |  | 180 (ACT:DMF0042_BizPlan.SaveData:864:1 ACT:D) |
| WK-DMF0042-1603 | X-ROW | DMF0042_BizPlan.SetCellColor | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 5 (ACT:DMF0042_BizPlan.SetCellColor ACT:DMF) |
| WK-DMF0042-1604 | X-ROW | DMF0042_BizPlan.SetComboCol | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 15 (ACT:DMF0042_BizPlan.SetComboCol ACT:DMF0) |
| WK-DMF0042-1605 | X-ROW | DMF0042_BizPlan.SetSpreadColumn | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 11검사 — ERROR:7 · NOT_RUN:3 · NA:1 |  | 19 (ACT:DMF0042_BizPlan.SetSpreadColumn:492:) |
| WK-DMF0042-1606 | X-ROW | DMF0042_BizPlan.SetSpreadHeaderSpan | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 31검사 — NOT_RUN:25 · ERROR:5 · NA:1 |  | 53 (ACT:DMF0042_BizPlan.SetSpreadHeaderSpan:) |
| WK-DMF0042-1607 | X-ROW | DMF0042_BizPlan.ValidationCheck | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — ERROR:4 |  | 7 (ACT:DMF0042_BizPlan.ValidationCheck ACT:) |
| WK-DMF0042-1608 | X-ROW | DMF0042_BizPlan.btnColumn_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 11검사 — ERROR:7 · NA:2 · NOT_RUN:1 · NOPATH:1 |  | 5 (ACT:DMF0042_BizPlan.btnColumn_Click:2872) |
| WK-DMF0042-1609 | X-ROW | DMF0042_BizPlan.btnCutOff_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 8검사 — ERROR:8 |  | 11 (ACT:DMF0042_BizPlan.btnCutOff_Click:2905) |
| WK-DMF0042-1610 | X-ROW | DMF0042_BizPlan.btnExchangeRate_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 15검사 — ERROR:15 |  | 9 (ACT:DMF0042_BizPlan.btnExchangeRate_Clic) |
| WK-DMF0042-1611 | X-ROW | DMF0042_BizPlan.btnItemId_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 11검사 — ERROR:8 · NA:3 |  | 13 (ACT:DMF0042_BizPlan.btnItemId_Click:2849) |
| WK-DMF0042-1612 | X-ROW | DMF0042_BizPlan.btnMeasure_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 11검사 — ERROR:7 · NA:2 · NOT_RUN:1 · NOPATH:1 |  | 5 (ACT:DMF0042_BizPlan.btnMeasure_Click:288) |
| WK-DMF0042-1613 | X-ROW | DMF0042_BizPlan.btnOwner_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 11검사 — ERROR:8 · NA:3 |  | 12 (ACT:DMF0042_BizPlan.btnOwner_Click:3008:) |
| WK-DMF0042-1614 | X-ROW | DMF0042_BizPlan.btnProject_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 11검사 — ERROR:8 · NA:3 |  | 13 (ACT:DMF0042_BizPlan.btnProject_Click:282) |
| WK-DMF0042-1615 | X-ROW | DMF0042_BizPlan.btnReplace_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 10검사 — ERROR:10 |  | 44 (ACT:DMF0042_BizPlan.btnReplace_Click:347) |
| WK-DMF0042-1616 | X-ROW | DMF0042_BizPlan.btnSetPrice_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 15검사 — ERROR:7 · NOT_RUN:5 · PASS:3 |  | 11 (ACT:DMF0042_BizPlan.btnSetPrice_Click:31) |
| WK-DMF0042-1617 | X-ROW | DMF0042_BizPlan.cboBucketType_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — ERROR:6 |  | 4 (ACT:DMF0042_BizPlan.cboBucketType_Click:) |
| WK-DMF0042-1618 | X-ROW | DMF0042_BizPlan.cboBucketType_SelectedIn | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 6 (ACT:DMF0042_BizPlan.cboBucketType_Select) |
| WK-DMF0042-1619 | X-ROW | DMF0042_BizPlan.cboDivision_SelectedInde | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 11검사 — NOT_RUN:7 · ERROR:4 |  | 47 (ACT:DMF0042_BizPlan.cboDivision_Selected) |
| WK-DMF0042-1620 | X-ROW | DMF0042_BizPlan.chkSum_CheckedChanged | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 3 (ACT:DMF0042_BizPlan.chkSum_CheckedChange) |
| WK-DMF0042-1621 | X-ROW | DMF0042_BizPlan.clbCustomer_SelectedInde | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 8검사 — ERROR:7 · NOT_RUN:1 |  | 5 (ACT:DMF0042_BizPlan.clbCustomer_Selected) |
| WK-DMF0042-1622 | X-ROW | DMF0042_BizPlan.clbTeam_SelectedIndexCha | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 7검사 — ERROR:5 · NOT_RUN:2 |  | 13 (ACT:DMF0042_BizPlan.clbTeam_SelectedInde) |
| WK-DMF0042-1623 | X-ROW | DMF0042_BizPlan.fnValidation | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 48 (ACT:DMF0042_BizPlan.fnValidation ACT:DMF) |
| WK-DMF0042-1624 | X-ROW | DMF0042_BizPlan.spdMain_CellDoubleClick | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 61검사 — NOT_RUN:26 · ERROR:21 · NA:11 · NOPATH:3 |  | 120 (ACT:DMF0042_BizPlan.spdMain_CellDoubleCl) |
| WK-DMF0042-1625 | X-ROW | DMF0042_BizPlan.spdMain_Changed | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 68검사 — ERROR:43 · NA:23 · NOT_RUN:2 |  | 425 (ACT:DMF0042_BizPlan.spdMain_Changed:1865) |
| WK-DMF0042-1626 | X-ROW | DMF0042_BizPlan.spdMain_ComboSelChange | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 27검사 — ERROR:24 · NOT_RUN:3 |  | 16 (ACT:DMF0042_BizPlan.spdMain_ComboSelChan) |
| WK-DMF0042-1627 | X-ROW | DMF0042_BizPlan.spdMain_EditChange | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 4 (ACT:DMF0042_BizPlan.spdMain_EditChange A) |
| WK-DMF0042-1628 | X-ROW | DMF0042_BizPlan.spdMain_TopChange | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:2 |  | 4 (ACT:DMF0042_BizPlan.spdMain_TopChange AC) |
| WK-DMF0042-1629 | X-ROW | DMF0042_BizPlan_old..ctor | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — ERROR:2 · WARN:1 |  | 2 (ACT:DMF0042_BizPlan_old..ctor:187:1 ACT:) |
| WK-DMF0042-1630 | X-ROW | DMF0042_BizPlan_old.CreateSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:2 |  | 5 (ACT:DMF0042_BizPlan_old.CreateSpread ACT) |
| WK-DMF0042-1631 | X-ROW | DMF0042_BizPlan_old.DefineProperty | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 10검사 — NOT_RUN:4 · ERROR:4 · WARN:1 · NOPATH:1 |  | 17 (ACT:DMF0042_BizPlan_old.DefineProperty:2) |
| WK-DMF0042-1632 | X-ROW | DMF0042_BizPlan_old.DeleteButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — ERROR:5 |  | 6 (ACT:DMF0042_BizPlan_old.DeleteButton:498) |
| WK-DMF0042-1633 | X-ROW | DMF0042_BizPlan_old.Dispose | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — ERROR:2 · NOT_RUN:1 |  | 3 (ACT:DMF0042_BizPlan_old.Dispose:16:1 ACT) |
| WK-DMF0042-1634 | X-ROW | DMF0042_BizPlan_old.EditButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 16검사 — ERROR:15 · NA:1 |  | 27 (ACT:DMF0042_BizPlan_old.EditButton:512:1) |
| WK-DMF0042-1635 | X-ROW | DMF0042_BizPlan_old.Form_Load | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — ERROR:3 |  | 7 (ACT:DMF0042_BizPlan_old.Form_Load ACT:DM) |
| WK-DMF0042-1636 | X-ROW | DMF0042_BizPlan_old.GetBizTypebyDivision | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — NOT_RUN:2 · ERROR:2 · NOPATH:1 |  | 7 (ACT:DMF0042_BizPlan_old.GetBizTypebyDivi) |
| WK-DMF0042-1637 | X-ROW | DMF0042_BizPlan_old.GetCellColor | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:2 |  | 6 (ACT:DMF0042_BizPlan_old.GetCellColor ACT) |
| WK-DMF0042-1638 | X-ROW | DMF0042_BizPlan_old.GetCellIndexBySpanRo | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:2 |  | 5 (ACT:DMF0042_BizPlan_old.GetCellIndexBySp) |
| WK-DMF0042-1639 | X-ROW | DMF0042_BizPlan_old.GetCellNumbersByRow | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:2 |  | 15 (ACT:DMF0042_BizPlan_old.GetCellNumbersBy) |
| WK-DMF0042-1640 | X-ROW | DMF0042_BizPlan_old.GetDayRange | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — ERROR:3 · NA:1 · NOT_RUN:1 |  | 8 (ACT:DMF0042_BizPlan_old.GetDayRange ACT:) |
| WK-DMF0042-1641 | X-ROW | DMF0042_BizPlan_old.GetFuturePriceInfo | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 7검사 — NA:2 · ERROR:2 · NOT_RUN:2 · PASS:1 |  | 9 (ACT:DMF0042_BizPlan_old.GetFuturePriceIn) |
| WK-DMF0042-1642 | X-ROW | DMF0042_BizPlan_old.GetLookupData | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — NOT_RUN:2 · ERROR:2 · NOPATH:1 |  | 7 (ACT:DMF0042_BizPlan_old.GetLookupData AC) |
| WK-DMF0042-1643 | X-ROW | DMF0042_BizPlan_old.GetSpdTitle | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — ERROR:4 · NA:2 · NOT_RUN:2 · PASS:1 |  | 8 (ACT:DMF0042_BizPlan_old.GetSpdTitle:2154) |
| WK-DMF0042-1644 | X-ROW | DMF0042_BizPlan_old.GetThisWeekMonday | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — ERROR:2 · NA:2 |  | 10 (ACT:DMF0042_BizPlan_old.GetThisWeekMonda) |
| WK-DMF0042-1645 | X-ROW | DMF0042_BizPlan_old.InitControls | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 35검사 — NOT_RUN:25 · ERROR:7 · NOPATH:3 |  | 42 (ACT:DMF0042_BizPlan_old.InitControls:217) |
| WK-DMF0042-1646 | X-ROW | DMF0042_BizPlan_old.InitSaveDataTable | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — ERROR:3 |  | 6 (ACT:DMF0042_BizPlan_old.InitSaveDataTabl) |
| WK-DMF0042-1647 | X-ROW | DMF0042_BizPlan_old.InitSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — ERROR:3 |  | 6 (ACT:DMF0042_BizPlan_old.InitSpread ACT:D) |
| WK-DMF0042-1648 | X-ROW | DMF0042_BizPlan_old.InsertButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — ERROR:3 |  | 2 (ACT:DMF0042_BizPlan_old.InsertButton ACT) |
| WK-DMF0042-1649 | X-ROW | DMF0042_BizPlan_old.InsertRow | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 177검사 — ERROR:132 · NA:29 · NOT_RUN:10 · NOPATH:6 |  | 136 (ACT:DMF0042_BizPlan_old.InsertRow ACT:DM) |
| WK-DMF0042-1650 | X-ROW | DMF0042_BizPlan_old.MinColumnChk | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:2 |  | 10 (ACT:DMF0042_BizPlan_old.MinColumnChk ACT) |
| WK-DMF0042-1651 | X-ROW | DMF0042_BizPlan_old.OnShown | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:2 |  | 3 (ACT:DMF0042_BizPlan_old.OnShown ACT:DMF0) |
| WK-DMF0042-1652 | X-ROW | DMF0042_BizPlan_old.ParameterString | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:2 |  | 17 (ACT:DMF0042_BizPlan_old.ParameterString ) |
| WK-DMF0042-1653 | X-ROW | DMF0042_BizPlan_old.SaveButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 8검사 — ERROR:5 · NOT_RUN:3 |  | 1 (ACT:DMF0042_BizPlan_old.SaveButton:575:1) |
| WK-DMF0042-1654 | X-ROW | DMF0042_BizPlan_old.SaveData | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 22검사 — ERROR:15 · NOT_RUN:4 · PASS:3 |  | 169 (ACT:DMF0042_BizPlan_old.SaveData:689:1 A) |
| WK-DMF0042-1655 | X-ROW | DMF0042_BizPlan_old.SetCellColor | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:2 |  | 5 (ACT:DMF0042_BizPlan_old.SetCellColor ACT) |
| WK-DMF0042-1656 | X-ROW | DMF0042_BizPlan_old.SetSpreadColumn | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 12검사 — ERROR:8 · NOT_RUN:3 · NA:1 |  | 19 (ACT:DMF0042_BizPlan_old.SetSpreadColumn:) |
| WK-DMF0042-1657 | X-ROW | DMF0042_BizPlan_old.SetSpreadHeaderSpan | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 32검사 — NOT_RUN:25 · ERROR:6 · NA:1 |  | 53 (ACT:DMF0042_BizPlan_old.SetSpreadHeaderS) |
| WK-DMF0042-1658 | X-ROW | DMF0042_BizPlan_old.ValidationCheck | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — ERROR:5 |  | 7 (ACT:DMF0042_BizPlan_old.ValidationCheck ) |
| WK-DMF0042-1659 | X-ROW | DMF0042_BizPlan_old.btnColumn_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 12검사 — ERROR:8 · NA:2 · NOT_RUN:1 · NOPATH:1 |  | 5 (ACT:DMF0042_BizPlan_old.btnColumn_Click:) |
| WK-DMF0042-1660 | X-ROW | DMF0042_BizPlan_old.btnCutOff_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — ERROR:9 |  | 10 (ACT:DMF0042_BizPlan_old.btnCutOff_Click:) |
| WK-DMF0042-1661 | X-ROW | DMF0042_BizPlan_old.btnExchangeRate_Clic | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 10검사 — ERROR:10 |  | 10 (ACT:DMF0042_BizPlan_old.btnExchangeRate_) |
| WK-DMF0042-1662 | X-ROW | DMF0042_BizPlan_old.btnIncotermsChg_Clic | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 12검사 — ERROR:9 · NA:3 |  | 9 (ACT:DMF0042_BizPlan_old.btnIncotermsChg_) |
| WK-DMF0042-1663 | X-ROW | DMF0042_BizPlan_old.btnItemId_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 12검사 — ERROR:9 · NA:3 |  | 13 (ACT:DMF0042_BizPlan_old.btnItemId_Click:) |
| WK-DMF0042-1664 | X-ROW | DMF0042_BizPlan_old.btnMeasure_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 12검사 — ERROR:8 · NA:2 · NOT_RUN:1 · NOPATH:1 |  | 5 (ACT:DMF0042_BizPlan_old.btnMeasure_Click) |
| WK-DMF0042-1665 | X-ROW | DMF0042_BizPlan_old.btnOwner_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 12검사 — ERROR:9 · NA:3 |  | 12 (ACT:DMF0042_BizPlan_old.btnOwner_Click:2) |
| WK-DMF0042-1666 | X-ROW | DMF0042_BizPlan_old.btnProject_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 12검사 — ERROR:9 · NA:3 |  | 13 (ACT:DMF0042_BizPlan_old.btnProject_Click) |
| WK-DMF0042-1667 | X-ROW | DMF0042_BizPlan_old.btnSetPrice_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 16검사 — ERROR:8 · NOT_RUN:5 · PASS:3 |  | 11 (ACT:DMF0042_BizPlan_old.btnSetPrice_Clic) |
| WK-DMF0042-1668 | X-ROW | DMF0042_BizPlan_old.cboBucketType_Click | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 7검사 — ERROR:7 |  | 4 (ACT:DMF0042_BizPlan_old.cboBucketType_Cl) |
| WK-DMF0042-1669 | X-ROW | DMF0042_BizPlan_old.cboBucketType_Select | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:2 |  | 6 (ACT:DMF0042_BizPlan_old.cboBucketType_Se) |
| WK-DMF0042-1670 | X-ROW | DMF0042_BizPlan_old.cboDivision_Selected | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 12검사 — NOT_RUN:7 · ERROR:5 |  | 46 (ACT:DMF0042_BizPlan_old.cboDivision_Sele) |
| WK-DMF0042-1671 | X-ROW | DMF0042_BizPlan_old.chkSum_CheckedChange | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:2 |  | 3 (ACT:DMF0042_BizPlan_old.chkSum_CheckedCh) |
| WK-DMF0042-1672 | X-ROW | DMF0042_BizPlan_old.clbCustomer_Selected | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — ERROR:8 · NOT_RUN:1 |  | 5 (ACT:DMF0042_BizPlan_old.clbCustomer_Sele) |
| WK-DMF0042-1673 | X-ROW | DMF0042_BizPlan_old.clbTeam_SelectedInde | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 8검사 — ERROR:6 · NOT_RUN:2 |  | 12 (ACT:DMF0042_BizPlan_old.clbTeam_Selected) |
| WK-DMF0042-1674 | X-ROW | DMF0042_BizPlan_old.fnValidation | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:2 |  | 52 (ACT:DMF0042_BizPlan_old.fnValidation ACT) |
| WK-DMF0042-1675 | X-ROW | DMF0042_BizPlan_old.spdMain_CellDoubleCl | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 65검사 — NOT_RUN:27 · ERROR:24 · NA:11 · NOPATH:3 |  | 118 (ACT:DMF0042_BizPlan_old.spdMain_CellDoub) |
| WK-DMF0042-1676 | X-ROW | DMF0042_BizPlan_old.spdMain_Changed | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 41검사 — ERROR:26 · NA:14 · NOT_RUN:1 |  | 236 (ACT:DMF0042_BizPlan_old.spdMain_Changed:) |
| WK-DMF0042-1677 | X-ROW | DMF0042_BizPlan_old.spdMain_ComboSelChan | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — ERROR:3 · NOT_RUN:2 |  | 4 (ACT:DMF0042_BizPlan_old.spdMain_ComboSel) |
| WK-DMF0042-1678 | X-ROW | DMF0042_BizPlan_old.spdMain_EditChange | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:2 |  | 4 (ACT:DMF0042_BizPlan_old.spdMain_EditChan) |
| WK-DMF0042-1679 | X-ROW | DMF0042_BizPlan_old.spdMain_TopChange | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — ERROR:3 |  | 4 (ACT:DMF0042_BizPlan_old.spdMain_TopChang) |
| WK-DMF0042-1680 | X-ROW | DMF0042_ExchangeRatePopup..ctor | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — WARN:1 · ERROR:1 |  | 2 (ACT:DMF0042_ExchangeRatePopup..ctor:74:1) |
| WK-DMF0042-1681 | X-ROW | DMF0042_ExchangeRatePopup.CreateSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 5 (ACT:DMF0042_ExchangeRatePopup.CreateSpre) |
| WK-DMF0042-1682 | X-ROW | DMF0042_ExchangeRatePopup.DefineProperty | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:2 |  | 10 (ACT:DMF0042_ExchangeRatePopup.DefineProp) |
| WK-DMF0042-1683 | X-ROW | DMF0042_ExchangeRatePopup.DeleteButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — ERROR:3 |  | 4 (ACT:DMF0042_ExchangeRatePopup.DeleteButt) |
| WK-DMF0042-1684 | X-ROW | DMF0042_ExchangeRatePopup.Dispose | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOT_RUN:1 · ERROR:1 |  | 3 (ACT:DMF0042_ExchangeRatePopup.Dispose:16) |
| WK-DMF0042-1685 | X-ROW | DMF0042_ExchangeRatePopup.EditButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 13검사 — ERROR:10 · NA:2 · NOT_RUN:1 |  | 25 (ACT:DMF0042_ExchangeRatePopup.EditButton) |
| WK-DMF0042-1686 | X-ROW | DMF0042_ExchangeRatePopup.FindButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 10검사 — REVIEW:3 · NOT_RUN:3 · ERROR:2 · NA:2 |  | 3 (ACT:DMF0042_ExchangeRatePopup.FindButton) |
| WK-DMF0042-1687 | X-ROW | DMF0042_ExchangeRatePopup.FindData | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 17검사 — ERROR:4 · NOT_RUN:4 · REVIEW:3 · NA:3 · PASS:2 · NOPATH:1 |  | 39 (ACT:DMF0042_ExchangeRatePopup.FindData:3) |
| WK-DMF0042-1688 | X-ROW | DMF0042_ExchangeRatePopup.Form_Load | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:2 |  | 8 (ACT:DMF0042_ExchangeRatePopup.Form_Load ) |
| WK-DMF0042-1689 | X-ROW | DMF0042_ExchangeRatePopup.GetCellColor | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 6 (ACT:DMF0042_ExchangeRatePopup.GetCellCol) |
| WK-DMF0042-1690 | X-ROW | DMF0042_ExchangeRatePopup.InitControls | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — ERROR:3 · NOT_RUN:2 |  | 5 (ACT:DMF0042_ExchangeRatePopup.InitContro) |
| WK-DMF0042-1691 | X-ROW | DMF0042_ExchangeRatePopup.InitSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 27검사 — NOT_RUN:21 · ERROR:5 · NOPATH:1 |  | 30 (ACT:DMF0042_ExchangeRatePopup.InitSpread) |
| WK-DMF0042-1692 | X-ROW | DMF0042_ExchangeRatePopup.InitSpread_X | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — ERROR:3 · NOT_RUN:2 · NA:1 |  | 35 (ACT:DMF0042_ExchangeRatePopup.InitSpread) |
| WK-DMF0042-1693 | X-ROW | DMF0042_ExchangeRatePopup.InsertButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:2 |  | 2 (ACT:DMF0042_ExchangeRatePopup.InsertButt) |
| WK-DMF0042-1694 | X-ROW | DMF0042_ExchangeRatePopup.InsertRow | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 12검사 — ERROR:6 · NA:4 · NOT_RUN:2 |  | 18 (ACT:DMF0042_ExchangeRatePopup.InsertRow ) |
| WK-DMF0042-1695 | X-ROW | DMF0042_ExchangeRatePopup.LoadData | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NOT_RUN:2 · ERROR:1 |  | 5 (ACT:DMF0042_ExchangeRatePopup.LoadData A) |
| WK-DMF0042-1696 | X-ROW | DMF0042_ExchangeRatePopup.SaveButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 11검사 — ERROR:7 · NOT_RUN:4 |  | 5 (ACT:DMF0042_ExchangeRatePopup.SaveButton) |
| WK-DMF0042-1697 | X-ROW | DMF0042_ExchangeRatePopup.SaveData | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 21검사 — ERROR:12 · NOT_RUN:5 · PASS:3 · NOPATH:1 |  | 82 (ACT:DMF0042_ExchangeRatePopup.SaveData:4) |
| WK-DMF0042-1698 | X-ROW | DMF0042_ExchangeRatePopup.btnButtonList_ | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — ERROR:3 |  | 18 (ACT:DMF0042_ExchangeRatePopup.btnButtonL) |
| WK-DMF0042-1699 | X-ROW | DMF0042_ExchangeRatePopup.mOK | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 2 (ACT:DMF0042_ExchangeRatePopup.mOK ACT:DM) |
| WK-DMF0042-1700 | X-ROW | DMF0042_ExchangeRatePopup.spdMain_TopCha | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — ERROR:2 |  | 4 (ACT:DMF0042_ExchangeRatePopup.spdMain_To) |
| WK-DMF0042-1701 | G5 | 21 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 21 'InsertButton → InsertRow (L1150~1417)' 의 G5 151요소: NA:120 · ERROR:28 · NOPATH:3 |  | 1 (21) |
| WK-DMF0042-1702 | G5 | 6 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 6 'Exchange Rate 모달 = 표준 CustomDialog+DataGrid 재구성 (A' 의 G5 151요소: NA:120 · ERROR:28 · NOPATH:3 |  | 1 (6) |
| WK-DMF0042-1703 | G5 | DMF0042_1_BizPlan | 하네스·환경 | G5 도구 오류 — 원장 V-8304b5b2 ASIS / 원장 V-a18cedef ASIS / 원장 V-8c22dd59 ASIS / 원장 V-d287ea11 ASIS / 원장 V-b0b18d13 ASIS / 원장 V-34b78b6b  |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1704 | G5 | DMF0042_3_BizPlan | 하네스·환경 | G5 도구 오류 — 원장 V-67e1d2b3 ASIS / 원장 V-533fa8e8 ASIS / 원장 V-09514ccd ASIS / 원장 V-efc55908 ASIS / 원장 V-8a21db8f ASIS / 원장 V-fa48bf61  |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1705 | G5 | DMF0042_BizPlan | 하네스·환경 | G5 도구 오류 — 원장 V-09b2354c ASIS / 원장 V-a562dbe3 ASIS / 원장 V-40972618 ASIS / 원장 V-d0b478c2 ASIS / 원장 V-1cef95c2 ASIS / 원장 V-4b221c76  |  | 2 (ACT:DMF0042_BizPlan.spdMain_CellDoubleCl) |
| WK-DMF0042-1706 | G5 | DMF0042_BizPlan_old | 하네스·환경 | G5 도구 오류 — 원장 V-bd913a0f ASIS / 원장 V-26080023 ASIS / 원장 V-7ca5414e ASIS / 원장 V-ec8f7299 ASIS / 원장 V-96b128c7 ASIS / 원장 V-9e1eb29d  |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_CellDoub) |
| WK-DMF0042-1707 | G5 | DMF0042_ExchangeRatePopup | 하네스·환경 | G5 도구 오류 — 원장 V-d287ea11 ASIS / 원장 V-b0060baf ASIS / 원장 V-efc55908 ASIS / 원장 V-d0b478c2 ASIS |  | 4 (ACT:DMF0042_1_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1708 | G5 | btnCutOff | 하네스·환경 | G5 도구 오류 — 원장 V-8c22dd59 ASIS / 원장 V-1c078df1 ASIS / 원장 V-09514ccd ASIS / 원장 V-40972618 ASIS / 원장 V-7ca5414e ASIS |  | 1 (27) |
| WK-DMF0042-1709 | G5 | btnExchangeRate | 하네스·환경 | G5 도구 오류 — 원장 V-d287ea11 ASIS / 원장 V-b0b18d13 ASIS / 원장 V-b0060baf ASIS / 원장 V-549f5646 ASIS / 원장 V-efc55908 ASIS / 원장 V-8a21db8f  |  | 1 (26) |
| WK-DMF0042-1710 | G5 | btnReplace | 하네스·환경 | G5 도구 오류 — 원장 V-eea1d3ba ASIS / 원장 V-731389b5 ASIS / 원장 V-546e5d43 ASIS / 원장 V-5f26da35 ASIS |  | 1 (28) |
| WK-DMF0042-1711 | G5 | new POPUP.DMF0042_ExchangeRatePopup() | 하네스·환경 | G5 도구 오류 — 원장 V-d287ea11 |  | 1 (ACT:DMF0042_1_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1712 | G5 | new POPUP.DMF0042_ExchangeRatePopup() | 하네스·환경 | G5 도구 오류 — 원장 V-b0060baf |  | 1 (ACT:DMF0042_2_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1713 | G5 | new POPUP.DMF0042_ExchangeRatePopup() | 하네스·환경 | G5 도구 오류 — 원장 V-efc55908 |  | 1 (ACT:DMF0042_3_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1714 | G5 | new POPUP.DMF0042_ExchangeRatePopup() | 하네스·환경 | G5 도구 오류 — 원장 V-d0b478c2 |  | 1 (ACT:DMF0042_BizPlan.btnExchangeRate_Clic) |
| WK-DMF0042-1715 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-8c22dd59 |  | 1 (ACT:DMF0042_1_BizPlan.btnCutOff_Click:28) |
| WK-DMF0042-1716 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-b0b18d13 |  | 1 (ACT:DMF0042_1_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1717 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-eea1d3ba |  | 1 (ACT:DMF0042_1_BizPlan.btnReplace_Click:3) |
| WK-DMF0042-1718 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-1c078df1 |  | 1 (ACT:DMF0042_2_BizPlan.btnCutOff_Click:30) |
| WK-DMF0042-1719 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-549f5646 |  | 1 (ACT:DMF0042_2_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1720 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-731389b5 |  | 1 (ACT:DMF0042_2_BizPlan.btnReplace_Click:3) |
| WK-DMF0042-1721 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-09514ccd |  | 1 (ACT:DMF0042_3_BizPlan.btnCutOff_Click:29) |
| WK-DMF0042-1722 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-8a21db8f |  | 1 (ACT:DMF0042_3_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1723 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-546e5d43 |  | 1 (ACT:DMF0042_3_BizPlan.btnReplace_Click:3) |
| WK-DMF0042-1724 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-40972618 |  | 1 (ACT:DMF0042_BizPlan.btnCutOff_Click:2923) |
| WK-DMF0042-1725 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-1cef95c2 |  | 1 (ACT:DMF0042_BizPlan.btnExchangeRate_Clic) |
| WK-DMF0042-1726 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-5f26da35 |  | 1 (ACT:DMF0042_BizPlan.btnReplace_Click:355) |
| WK-DMF0042-1727 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-7ca5414e |  | 1 (ACT:DMF0042_BizPlan_old.btnCutOff_Click:) |
| WK-DMF0042-1728 | G5 | popup.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-ec8f7299 |  | 1 (ACT:DMF0042_BizPlan_old.btnExchangeRate_) |
| WK-DMF0042-1729 | G5 | txtOwner / Owner | 하네스·환경 | G5 도구 오류 — 원장 V-a3967a98 SEARCH |  | 1 (11) |
| WK-DMF0042-1730 | G5 | txtProject / Project | 하네스·환경 | G5 도구 오류 — 원장 V-5fddf3df SEARCH |  | 1 (9) |
| WK-DMF0042-1731 | H6 | 21 | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 21 'InsertButton → InsertRow (L1150~1417)' 의 H6 151요소: ERROR:146 · NOT_RUN:4 · NOPATH:1 |  | 1 (21) |
| WK-DMF0042-1732 | H6 | 6 | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 6 'Exchange Rate 모달 = 표준 CustomDialog+DataGrid 재구성 (A' 의 H6 151요소: ERROR:146 · NOT_RUN:4 · NOPATH:1 |  | 1 (6) |
| WK-DMF0042-1733 | H6 | DMF0042_1_BizPlan | 하네스·환경 | H6 도구 오류 — 원장 V-1417ed28 ASIS / 원장 V-699254bf ASIS / 원장 V-1dd724bf ASIS / 원장 V-7ef290e8 ASIS / 원장 V-c02d48d9 ASIS / 원장 V-8f152d01  |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1734 | H6 | DMF0042_2_BizPlan.spdMain_CellDoubleClic | 하네스·환경 | H6 도구 오류 — 원장 V-6bbd9c1f ASIS / 원장 V-6cecd4cf ASIS / 원장 V-5448b137 ASIS / 원장 V-26c433fa ASIS / 원장 V-7880f905 ASIS / 원장 V-831155be  |  | 14 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1735 | H6 | DMF0042_3_BizPlan | 하네스·환경 | H6 도구 오류 — 원장 V-b0a534ca ASIS / 원장 V-dd4b851f ASIS / 원장 V-38555156 ASIS / 원장 V-41d355a1 ASIS / 원장 V-03ff3146 ASIS / 원장 V-c7c1bd4d  |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1736 | H6 | DMF0042_BizPlan | 하네스·환경 | H6 도구 오류 — 원장 V-903e172f ASIS / 원장 V-6b20b2e7 ASIS / 원장 V-f2abcf20 ASIS / 원장 V-b56c42ad ASIS / 원장 V-f2c4be03 ASIS / 원장 V-39cdf70a  |  | 2 (ACT:DMF0042_BizPlan.spdMain_CellDoubleCl) |
| WK-DMF0042-1737 | H6 | DMF0042_BizPlan_old | 하네스·환경 | H6 도구 오류 — 원장 V-e8df2085 ASIS / 원장 V-926f8038 ASIS / 원장 V-be24c7f2 ASIS / 원장 V-32aec8b9 ASIS / 원장 V-cf027b3b ASIS / 원장 V-1dc2dcf5  |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_CellDoub) |
| WK-DMF0042-1738 | H6 | DMF0042_ExchangeRatePopup | 하네스·환경 | H6 도구 오류 — 원장 V-7ef290e8 ASIS / 원장 V-d7dd8ff5 ASIS / 원장 V-41d355a1 ASIS / 원장 V-b56c42ad ASIS |  | 4 (ACT:DMF0042_1_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1739 | H6 | ITEM_ID / Model | 하네스·환경 | H6 도구 오류 — 원장 V-d9ba3d99 ASIS / 원장 V-1b89c571 ASIS / 원장 V-1841845a ASIS / 원장 V-6bbd9c1f ASIS / 원장 V-5448b137 ASIS / 원장 V-26c433fa  |  | 271 (15 ACT:DMF0042_1_BizPlan.spdMain_CellDou) |
| WK-DMF0042-1740 | H6 | PROJECT_CODE / Project Code | 하네스·환경 | H6 도구 오류 — 원장 V-94591724 ASIS / 원장 V-addb38a8 ASIS / 원장 V-da6826d9 ASIS / 원장 V-6bbd9c1f ASIS / 원장 V-831155be ASIS / 원장 V-3bf44110  |  | 215 (15 ACT:DMF0042_1_BizPlan.spdMain_CellDou) |
| WK-DMF0042-1741 | H6 | PROJECT_CODE82 / Project Code | 하네스·환경 | H6 도구 오류 — 원장 V-5c44599d ASIS / 원장 V-a24593e0 ASIS / 원장 V-88f0ade7 ASIS / 원장 V-93cdbd29 ASIS / 원장 V-01698a4b ASIS / 원장 V-9806662b  |  | 1 (15) |
| WK-DMF0042-1742 | H6 | btnColumn | 하네스·환경 | H6 도구 오류 — 원장 V-1417ed28 ASIS / 원장 V-699254bf ASIS / 원장 V-45279408 ASIS / 원장 V-fc4fe308 ASIS / 원장 V-b0a534ca ASIS / 원장 V-dd4b851f  |  | 1 (12) |
| WK-DMF0042-1743 | H6 | btnCutOff | 하네스·환경 | H6 도구 오류 — 원장 V-1dd724bf ASIS / 원장 V-538d180a ASIS / 원장 V-38555156 ASIS / 원장 V-f2abcf20 ASIS / 원장 V-be24c7f2 ASIS |  | 1 (27) |
| WK-DMF0042-1744 | H6 | btnExchangeRate | 하네스·환경 | H6 도구 오류 — 원장 V-7ef290e8 ASIS / 원장 V-c02d48d9 ASIS / 원장 V-d7dd8ff5 ASIS / 원장 V-9f2b5927 ASIS / 원장 V-41d355a1 ASIS / 원장 V-03ff3146  |  | 1 (26) |
| WK-DMF0042-1745 | H6 | btnItemId | 하네스·환경 | H6 도구 오류 — 원장 V-8f152d01 ASIS / 원장 V-d9e8d469 ASIS / 원장 V-1210bb26 ASIS / 원장 V-0e2a72bd ASIS / 원장 V-70c4b471 ASIS / 원장 V-868f5891  |  | 2 (10 btnProject/btnItemId/btnOwner) |
| WK-DMF0042-1746 | H6 | btnMeasure | 하네스·환경 | H6 도구 오류 — 원장 V-4b1c80ee ASIS / 원장 V-b86820b8 ASIS / 원장 V-4da2cca0 ASIS / 원장 V-acc6e1f9 ASIS / 원장 V-e0049a61 ASIS / 원장 V-744d90a3  |  | 1 (13) |
| WK-DMF0042-1747 | H6 | btnOwner | 하네스·환경 | H6 도구 오류 — 원장 V-d830ece8 ASIS / 원장 V-164c2875 ASIS / 원장 V-ad991fd0 ASIS / 원장 V-1d196413 ASIS / 원장 V-b38b55d4 ASIS / 원장 V-12fa1b10  |  | 2 (11 btnProject/btnItemId/btnOwner) |
| WK-DMF0042-1748 | H6 | btnProject | 하네스·환경 | H6 도구 오류 — 원장 V-926405f0 ASIS / 원장 V-99d60d99 ASIS / 원장 V-260c75c6 ASIS / 원장 V-1af3bc3d ASIS / 원장 V-127be395 ASIS / 원장 V-68a856f1  |  | 2 (9 btnProject/btnItemId/btnOwner) |
| WK-DMF0042-1749 | H6 | btnReplace | 하네스·환경 | H6 도구 오류 — 원장 V-9f2394e9 ASIS / 원장 V-8c9c8509 ASIS / 원장 V-b603d031 ASIS / 원장 V-e1c57710 ASIS |  | 1 (28) |
| WK-DMF0042-1750 | H6 | frm.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-699254bf |  | 1 (ACT:DMF0042_1_BizPlan.btnColumn_Click:28) |
| WK-DMF0042-1751 | H6 | frm.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-b86820b8 |  | 1 (ACT:DMF0042_1_BizPlan.btnMeasure_Click:2) |
| WK-DMF0042-1752 | H6 | frm.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-fc4fe308 |  | 1 (ACT:DMF0042_2_BizPlan.btnColumn_Click:30) |
| WK-DMF0042-1753 | H6 | frm.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-acc6e1f9 |  | 1 (ACT:DMF0042_2_BizPlan.btnMeasure_Click:3) |
| WK-DMF0042-1754 | H6 | frm.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-dd4b851f |  | 1 (ACT:DMF0042_3_BizPlan.btnColumn_Click:28) |
| WK-DMF0042-1755 | H6 | frm.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-744d90a3 |  | 1 (ACT:DMF0042_3_BizPlan.btnMeasure_Click:2) |
| WK-DMF0042-1756 | H6 | frm.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-6b20b2e7 |  | 1 (ACT:DMF0042_BizPlan.btnColumn_Click:2874) |
| WK-DMF0042-1757 | H6 | frm.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-b06510fe |  | 1 (ACT:DMF0042_BizPlan.btnMeasure_Click:288) |
| WK-DMF0042-1758 | H6 | frm.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-926f8038 |  | 1 (ACT:DMF0042_BizPlan_old.btnColumn_Click:) |
| WK-DMF0042-1759 | H6 | frm.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-4b02cfbd |  | 1 (ACT:DMF0042_BizPlan_old.btnMeasure_Click) |
| WK-DMF0042-1760 | H6 | new DM0002_ItembyDivisionPopupEx() | 하네스·환경 | H6 도구 오류 — 원장 V-8f152d01 |  | 1 (ACT:DMF0042_1_BizPlan.btnItemId_Click:27) |
| WK-DMF0042-1761 | H6 | new DM0002_ItembyDivisionPopupEx() | 하네스·환경 | H6 도구 오류 — 원장 V-d9ba3d99 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1762 | H6 | new DM0002_ItembyDivisionPopupEx() | 하네스·환경 | H6 도구 오류 — 원장 V-0e2a72bd |  | 1 (ACT:DMF0042_2_BizPlan.btnItemId_Click:30) |
| WK-DMF0042-1763 | H6 | new DM0002_ItembyDivisionPopupEx() | 하네스·환경 | H6 도구 오류 — 원장 V-5448b137 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1764 | H6 | new DM0002_ItembyDivisionPopupEx() | 하네스·환경 | H6 도구 오류 — 원장 V-c7c1bd4d |  | 1 (ACT:DMF0042_3_BizPlan.btnItemId_Click:28) |
| WK-DMF0042-1765 | H6 | new DM0002_ItembyDivisionPopupEx() | 하네스·환경 | H6 도구 오류 — 원장 V-25aabeee |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1766 | H6 | new DM0002_ItembyDivisionPopupEx() | 하네스·환경 | H6 도구 오류 — 원장 V-39cdf70a |  | 1 (ACT:DMF0042_BizPlan.btnItemId_Click:2856) |
| WK-DMF0042-1767 | H6 | new DM0002_ItembyDivisionPopupEx() | 하네스·환경 | H6 도구 오류 — 원장 V-3da3fdc9 |  | 1 (ACT:DMF0042_BizPlan.spdMain_CellDoubleCl) |
| WK-DMF0042-1768 | H6 | new DM0002_ItembyDivisionPopupEx() | 하네스·환경 | H6 도구 오류 — 원장 V-f6b8b38e |  | 1 (ACT:DMF0042_BizPlan_old.btnItemId_Click:) |
| WK-DMF0042-1769 | H6 | new DM0002_ItembyDivisionPopupEx() | 하네스·환경 | H6 도구 오류 — 원장 V-27143bcc |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_CellDoub) |
| WK-DMF0042-1770 | H6 | new DM0002_MatsterChgPopup() | 하네스·환경 | H6 도구 오류 — 원장 V-cf027b3b |  | 1 (ACT:DMF0042_BizPlan_old.btnIncotermsChg_) |
| WK-DMF0042-1771 | H6 | new DM0002_TitleSetForm_Popup("DMF0042", | 하네스·환경 | H6 도구 오류 — 원장 V-4b1c80ee |  | 1 (ACT:DMF0042_1_BizPlan.btnMeasure_Click:2) |
| WK-DMF0042-1772 | H6 | new DM0002_TitleSetForm_Popup("DMF0042", | 하네스·환경 | H6 도구 오류 — 원장 V-5d5860b8 |  | 1 (ACT:DMF0042_BizPlan.btnMeasure_Click:288) |
| WK-DMF0042-1773 | H6 | new DM0002_TitleSetForm_Popup("DMF0042", | 하네스·환경 | H6 도구 오류 — 원장 V-e55b2383 |  | 1 (ACT:DMF0042_BizPlan_old.btnMeasure_Click) |
| WK-DMF0042-1774 | H6 | new DM0002_TitleSetForm_Popup("DMF0042", | 하네스·환경 | H6 도구 오류 — 원장 V-1417ed28 |  | 1 (ACT:DMF0042_1_BizPlan.btnColumn_Click:28) |
| WK-DMF0042-1775 | H6 | new DM0002_TitleSetForm_Popup("DMF0042", | 하네스·환경 | H6 도구 오류 — 원장 V-903e172f |  | 1 (ACT:DMF0042_BizPlan.btnColumn_Click:2872) |
| WK-DMF0042-1776 | H6 | new DM0002_TitleSetForm_Popup("DMF0042", | 하네스·환경 | H6 도구 오류 — 원장 V-e8df2085 |  | 1 (ACT:DMF0042_BizPlan_old.btnColumn_Click:) |
| WK-DMF0042-1777 | H6 | new DM0002_TitleSetForm_Popup("DMF0042_1 | 하네스·환경 | H6 도구 오류 — 원장 V-4da2cca0 |  | 1 (ACT:DMF0042_2_BizPlan.btnMeasure_Click:3) |
| WK-DMF0042-1778 | H6 | new DM0002_TitleSetForm_Popup("DMF0042_1 | 하네스·환경 | H6 도구 오류 — 원장 V-45279408 |  | 1 (ACT:DMF0042_2_BizPlan.btnColumn_Click:30) |
| WK-DMF0042-1779 | H6 | new DM0002_TitleSetForm_Popup("DMF0042_3 | 하네스·환경 | H6 도구 오류 — 원장 V-e0049a61 |  | 1 (ACT:DMF0042_3_BizPlan.btnMeasure_Click:2) |
| WK-DMF0042-1780 | H6 | new DM0002_TitleSetForm_Popup("DMF0042_3 | 하네스·환경 | H6 도구 오류 — 원장 V-b0a534ca |  | 1 (ACT:DMF0042_3_BizPlan.btnColumn_Click:28) |
| WK-DMF0042-1781 | H6 | new DM0020_OwnerbyDivisionPopup() | 하네스·환경 | H6 도구 오류 — 원장 V-d830ece8 |  | 1 (ACT:DMF0042_1_BizPlan.btnOwner_Click:295) |
| WK-DMF0042-1782 | H6 | new DM0020_OwnerbyDivisionPopup() | 하네스·환경 | H6 도구 오류 — 원장 V-1d196413 |  | 1 (ACT:DMF0042_2_BizPlan.btnOwner_Click:317) |
| WK-DMF0042-1783 | H6 | new DM0020_OwnerbyDivisionPopup() | 하네스·환경 | H6 도구 오류 — 원장 V-e3661a2a |  | 1 (ACT:DMF0042_3_BizPlan.btnOwner_Click:306) |
| WK-DMF0042-1784 | H6 | new DM0020_OwnerbyDivisionPopup() | 하네스·환경 | H6 도구 오류 — 원장 V-8fd84844 |  | 1 (ACT:DMF0042_BizPlan.btnOwner_Click:3016:) |
| WK-DMF0042-1785 | H6 | new DM0020_OwnerbyDivisionPopup() | 하네스·환경 | H6 도구 오류 — 원장 V-95e84325 |  | 1 (ACT:DMF0042_BizPlan_old.btnOwner_Click:2) |
| WK-DMF0042-1786 | H6 | new POPUP.DMF0042_ExchangeRatePopup() | 하네스·환경 | H6 도구 오류 — 원장 V-7ef290e8 |  | 1 (ACT:DMF0042_1_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1787 | H6 | new POPUP.DMF0042_ExchangeRatePopup() | 하네스·환경 | H6 도구 오류 — 원장 V-d7dd8ff5 |  | 1 (ACT:DMF0042_2_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1788 | H6 | new POPUP.DMF0042_ExchangeRatePopup() | 하네스·환경 | H6 도구 오류 — 원장 V-41d355a1 |  | 1 (ACT:DMF0042_3_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1789 | H6 | new POPUP.DMF0042_ExchangeRatePopup() | 하네스·환경 | H6 도구 오류 — 원장 V-b56c42ad |  | 1 (ACT:DMF0042_BizPlan.btnExchangeRate_Clic) |
| WK-DMF0042-1790 | H6 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | H6 도구 오류 — 원장 V-926405f0 |  | 1 (ACT:DMF0042_1_BizPlan.btnProject_Click:2) |
| WK-DMF0042-1791 | H6 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | H6 도구 오류 — 원장 V-94591724 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1792 | H6 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | H6 도구 오류 — 원장 V-5c44599d |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1793 | H6 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | H6 도구 오류 — 원장 V-1af3bc3d |  | 1 (ACT:DMF0042_2_BizPlan.btnProject_Click:2) |
| WK-DMF0042-1794 | H6 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | H6 도구 오류 — 원장 V-831155be |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1795 | H6 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | H6 도구 오류 — 원장 V-fc39508c |  | 1 (ACT:DMF0042_3_BizPlan.btnProject_Click:2) |
| WK-DMF0042-1796 | H6 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | H6 도구 오류 — 원장 V-0fe103d1 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1797 | H6 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | H6 도구 오류 — 원장 V-93cdbd29 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1798 | H6 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | H6 도구 오류 — 원장 V-ad3cf845 |  | 1 (ACT:DMF0042_BizPlan.btnProject_Click:283) |
| WK-DMF0042-1799 | H6 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | H6 도구 오류 — 원장 V-f0013a5a |  | 1 (ACT:DMF0042_BizPlan.spdMain_CellDoubleCl) |
| WK-DMF0042-1800 | H6 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | H6 도구 오류 — 원장 V-ae045e5c |  | 1 (ACT:DMF0042_BizPlan.spdMain_CellDoubleCl) |
| WK-DMF0042-1801 | H6 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | H6 도구 오류 — 원장 V-fecea1f5 |  | 1 (ACT:DMF0042_BizPlan_old.btnProject_Click) |
| WK-DMF0042-1802 | H6 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | H6 도구 오류 — 원장 V-27791849 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_CellDoub) |
| WK-DMF0042-1803 | H6 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | H6 도구 오류 — 원장 V-add7124d |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_CellDoub) |
| WK-DMF0042-1804 | H6 | popAdjst.Form_Load(true, sDivision, sTea | 하네스·환경 | H6 도구 오류 — 원장 V-1dc2dcf5 |  | 1 (ACT:DMF0042_BizPlan_old.btnIncotermsChg_) |
| WK-DMF0042-1805 | H6 | popAdjst.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-bce797b1 |  | 1 (ACT:DMF0042_BizPlan_old.btnIncotermsChg_) |
| WK-DMF0042-1806 | H6 | popItem.Form_Load(false, sDivision, sTea | 하네스·환경 | H6 도구 오류 — 원장 V-1b89c571 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1807 | H6 | popItem.Form_Load(false, sDivision, sTea | 하네스·환경 | H6 도구 오류 — 원장 V-26c433fa |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1808 | H6 | popItem.Form_Load(false, sDivision, sTea | 하네스·환경 | H6 도구 오류 — 원장 V-6d74450e |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1809 | H6 | popItem.Form_Load(false, sDivision, sTea | 하네스·환경 | H6 도구 오류 — 원장 V-10d1a11a |  | 1 (ACT:DMF0042_BizPlan.spdMain_CellDoubleCl) |
| WK-DMF0042-1810 | H6 | popItem.Form_Load(false, sDivision, sTea | 하네스·환경 | H6 도구 오류 — 원장 V-273c7005 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_CellDoub) |
| WK-DMF0042-1811 | H6 | popItem.Form_Load(true, sDivision, sTeam | 하네스·환경 | H6 도구 오류 — 원장 V-164c2875 |  | 1 (ACT:DMF0042_1_BizPlan.btnOwner_Click:295) |
| WK-DMF0042-1812 | H6 | popItem.Form_Load(true, sDivision, sTeam | 하네스·환경 | H6 도구 오류 — 원장 V-b38b55d4 |  | 1 (ACT:DMF0042_2_BizPlan.btnOwner_Click:318) |
| WK-DMF0042-1813 | H6 | popItem.Form_Load(true, sDivision, sTeam | 하네스·환경 | H6 도구 오류 — 원장 V-e9fba552 |  | 1 (ACT:DMF0042_3_BizPlan.btnOwner_Click:307) |
| WK-DMF0042-1814 | H6 | popItem.Form_Load(true, sDivision, sTeam | 하네스·환경 | H6 도구 오류 — 원장 V-07e182b0 |  | 1 (ACT:DMF0042_BizPlan.btnOwner_Click:3019:) |
| WK-DMF0042-1815 | H6 | popItem.Form_Load(true, sDivision, sTeam | 하네스·환경 | H6 도구 오류 — 원장 V-81cfdc94 |  | 1 (ACT:DMF0042_BizPlan_old.btnOwner_Click:2) |
| WK-DMF0042-1816 | H6 | popItem.Form_Load(true, sdivision, sTeam | 하네스·환경 | H6 도구 오류 — 원장 V-d9e8d469 |  | 1 (ACT:DMF0042_1_BizPlan.btnItemId_Click:27) |
| WK-DMF0042-1817 | H6 | popItem.Form_Load(true, sdivision, sTeam | 하네스·환경 | H6 도구 오류 — 원장 V-70c4b471 |  | 1 (ACT:DMF0042_2_BizPlan.btnItemId_Click:30) |
| WK-DMF0042-1818 | H6 | popItem.Form_Load(true, sdivision, sTeam | 하네스·환경 | H6 도구 오류 — 원장 V-8b285a32 |  | 1 (ACT:DMF0042_3_BizPlan.btnItemId_Click:28) |
| WK-DMF0042-1819 | H6 | popItem.Form_Load(true, sdivision, sTeam | 하네스·환경 | H6 도구 오류 — 원장 V-bb1b832d |  | 1 (ACT:DMF0042_BizPlan.btnItemId_Click:2858) |
| WK-DMF0042-1820 | H6 | popItem.Form_Load(true, sdivision, sTeam | 하네스·환경 | H6 도구 오류 — 원장 V-e239fb10 |  | 1 (ACT:DMF0042_BizPlan_old.btnItemId_Click:) |
| WK-DMF0042-1821 | H6 | popItem.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-1210bb26 |  | 1 (ACT:DMF0042_1_BizPlan.btnItemId_Click:27) |
| WK-DMF0042-1822 | H6 | popItem.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-ad991fd0 |  | 1 (ACT:DMF0042_1_BizPlan.btnOwner_Click:295) |
| WK-DMF0042-1823 | H6 | popItem.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-1841845a |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1824 | H6 | popItem.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-868f5891 |  | 1 (ACT:DMF0042_2_BizPlan.btnItemId_Click:30) |
| WK-DMF0042-1825 | H6 | popItem.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-12fa1b10 |  | 1 (ACT:DMF0042_2_BizPlan.btnOwner_Click:318) |
| WK-DMF0042-1826 | H6 | popItem.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-7880f905 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1827 | H6 | popItem.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-5179558f |  | 1 (ACT:DMF0042_3_BizPlan.btnItemId_Click:28) |
| WK-DMF0042-1828 | H6 | popItem.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-883a7df0 |  | 1 (ACT:DMF0042_3_BizPlan.btnOwner_Click:307) |
| WK-DMF0042-1829 | H6 | popItem.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-75dbe2b3 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1830 | H6 | popItem.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-de1d5f8b |  | 1 (ACT:DMF0042_BizPlan.btnItemId_Click:2860) |
| WK-DMF0042-1831 | H6 | popItem.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-5163b15e |  | 1 (ACT:DMF0042_BizPlan.btnOwner_Click:3021:) |
| WK-DMF0042-1832 | H6 | popItem.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-9b10cb34 |  | 1 (ACT:DMF0042_BizPlan.spdMain_CellDoubleCl) |
| WK-DMF0042-1833 | H6 | popItem.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-816e6798 |  | 1 (ACT:DMF0042_BizPlan_old.btnItemId_Click:) |
| WK-DMF0042-1834 | H6 | popItem.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-78ed1abd |  | 1 (ACT:DMF0042_BizPlan_old.btnOwner_Click:2) |
| WK-DMF0042-1835 | H6 | popItem.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-3fa3b8d3 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_CellDoub) |
| WK-DMF0042-1836 | H6 | popProject.Form_Load(false, sDivision, s | 하네스·환경 | H6 도구 오류 — 원장 V-addb38a8 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1837 | H6 | popProject.Form_Load(false, sDivision, s | 하네스·환경 | H6 도구 오류 — 원장 V-a24593e0 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1838 | H6 | popProject.Form_Load(false, sDivision, s | 하네스·환경 | H6 도구 오류 — 원장 V-3bf44110 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1839 | H6 | popProject.Form_Load(false, sDivision, s | 하네스·환경 | H6 도구 오류 — 원장 V-9cfaf9f4 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1840 | H6 | popProject.Form_Load(false, sDivision, s | 하네스·환경 | H6 도구 오류 — 원장 V-01698a4b |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1841 | H6 | popProject.Form_Load(false, sDivision, s | 하네스·환경 | H6 도구 오류 — 원장 V-a0df5abc |  | 1 (ACT:DMF0042_BizPlan.spdMain_CellDoubleCl) |
| WK-DMF0042-1842 | H6 | popProject.Form_Load(false, sDivision, s | 하네스·환경 | H6 도구 오류 — 원장 V-24a743ce |  | 1 (ACT:DMF0042_BizPlan.spdMain_CellDoubleCl) |
| WK-DMF0042-1843 | H6 | popProject.Form_Load(false, sDivision, s | 하네스·환경 | H6 도구 오류 — 원장 V-8435df85 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_CellDoub) |
| WK-DMF0042-1844 | H6 | popProject.Form_Load(false, sDivision, s | 하네스·환경 | H6 도구 오류 — 원장 V-37a0d36c |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_CellDoub) |
| WK-DMF0042-1845 | H6 | popProject.Form_Load(true, sDivision, sT | 하네스·환경 | H6 도구 오류 — 원장 V-99d60d99 |  | 1 (ACT:DMF0042_1_BizPlan.btnProject_Click:2) |
| WK-DMF0042-1846 | H6 | popProject.Form_Load(true, sDivision, sT | 하네스·환경 | H6 도구 오류 — 원장 V-127be395 |  | 1 (ACT:DMF0042_2_BizPlan.btnProject_Click:2) |
| WK-DMF0042-1847 | H6 | popProject.Form_Load(true, sDivision, sT | 하네스·환경 | H6 도구 오류 — 원장 V-c1eeb83b |  | 1 (ACT:DMF0042_3_BizPlan.btnProject_Click:2) |
| WK-DMF0042-1848 | H6 | popProject.Form_Load(true, sDivision, sT | 하네스·환경 | H6 도구 오류 — 원장 V-ac6948f9 |  | 1 (ACT:DMF0042_BizPlan.btnProject_Click:283) |
| WK-DMF0042-1849 | H6 | popProject.Form_Load(true, sDivision, sT | 하네스·환경 | H6 도구 오류 — 원장 V-f42f338b |  | 1 (ACT:DMF0042_BizPlan_old.btnProject_Click) |
| WK-DMF0042-1850 | H6 | popProject.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-260c75c6 |  | 1 (ACT:DMF0042_1_BizPlan.btnProject_Click:2) |
| WK-DMF0042-1851 | H6 | popProject.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-da6826d9 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1852 | H6 | popProject.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-88f0ade7 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1853 | H6 | popProject.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-68a856f1 |  | 1 (ACT:DMF0042_2_BizPlan.btnProject_Click:2) |
| WK-DMF0042-1854 | H6 | popProject.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-14b9b3fb |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1855 | H6 | popProject.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-99c4b743 |  | 1 (ACT:DMF0042_3_BizPlan.btnProject_Click:2) |
| WK-DMF0042-1856 | H6 | popProject.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-983f0408 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1857 | H6 | popProject.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-9806662b |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1858 | H6 | popProject.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-404870f2 |  | 1 (ACT:DMF0042_BizPlan.btnProject_Click:283) |
| WK-DMF0042-1859 | H6 | popProject.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-c9035f1f |  | 1 (ACT:DMF0042_BizPlan.spdMain_CellDoubleCl) |
| WK-DMF0042-1860 | H6 | popProject.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-24ba7a9a |  | 1 (ACT:DMF0042_BizPlan.spdMain_CellDoubleCl) |
| WK-DMF0042-1861 | H6 | popProject.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-6da216e3 |  | 1 (ACT:DMF0042_BizPlan_old.btnProject_Click) |
| WK-DMF0042-1862 | H6 | popProject.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-26d4c6d6 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_CellDoub) |
| WK-DMF0042-1863 | H6 | popProject.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-03456d5d |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_CellDoub) |
| WK-DMF0042-1864 | H6 | popup.Form_Load(sDIVISION_ID, sPROJECT_C | 하네스·환경 | H6 도구 오류 — 원장 V-6bbd9c1f |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1865 | H6 | popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-1dd724bf |  | 1 (ACT:DMF0042_1_BizPlan.btnCutOff_Click:28) |
| WK-DMF0042-1866 | H6 | popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-c02d48d9 |  | 1 (ACT:DMF0042_1_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1867 | H6 | popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-9f2394e9 |  | 1 (ACT:DMF0042_1_BizPlan.btnReplace_Click:3) |
| WK-DMF0042-1868 | H6 | popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-538d180a |  | 1 (ACT:DMF0042_2_BizPlan.btnCutOff_Click:30) |
| WK-DMF0042-1869 | H6 | popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-9f2b5927 |  | 1 (ACT:DMF0042_2_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1870 | H6 | popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-8c9c8509 |  | 1 (ACT:DMF0042_2_BizPlan.btnReplace_Click:3) |
| WK-DMF0042-1871 | H6 | popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-6cecd4cf |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1872 | H6 | popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-38555156 |  | 1 (ACT:DMF0042_3_BizPlan.btnCutOff_Click:29) |
| WK-DMF0042-1873 | H6 | popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-03ff3146 |  | 1 (ACT:DMF0042_3_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1874 | H6 | popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-b603d031 |  | 1 (ACT:DMF0042_3_BizPlan.btnReplace_Click:3) |
| WK-DMF0042-1875 | H6 | popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-f2abcf20 |  | 1 (ACT:DMF0042_BizPlan.btnCutOff_Click:2923) |
| WK-DMF0042-1876 | H6 | popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-f2c4be03 |  | 1 (ACT:DMF0042_BizPlan.btnExchangeRate_Clic) |
| WK-DMF0042-1877 | H6 | popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-e1c57710 |  | 1 (ACT:DMF0042_BizPlan.btnReplace_Click:355) |
| WK-DMF0042-1878 | H6 | popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-be24c7f2 |  | 1 (ACT:DMF0042_BizPlan_old.btnCutOff_Click:) |
| WK-DMF0042-1879 | H6 | popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-32aec8b9 |  | 1 (ACT:DMF0042_BizPlan_old.btnExchangeRate_) |
| WK-DMF0042-1880 | M3 | DMF0042_1_BizPlan | 하네스·환경 | M3 도구 오류 — 원장 V-fa946da2 ASIS / 원장 V-61b1b3e0 ASIS / 원장 V-d0296cf9 ASIS / 원장 V-675768c9 ASIS / 원장 V-1c96c6d6 ASIS / 원장 V-f32309f8  |  | 54 (ACT:DMF0042_1_BizPlan..ctor ACT:DMF0042_) |
| WK-DMF0042-1881 | M3 | DMF0042_3_BizPlan | 하네스·환경 | M3 도구 오류 — 원장 V-31ccdc9f ASIS / 원장 V-d5b20abe ASIS / 원장 V-56c78e2b ASIS / 원장 V-1b4aec2a ASIS / 원장 V-8b49f48e ASIS / 원장 V-02175830  |  | 57 (ACT:DMF0042_3_BizPlan..ctor ACT:DMF0042_) |
| WK-DMF0042-1882 | M3 | DMF0042_BizPlan | 하네스·환경 | M3 도구 오류 — 원장 V-084a9f65 ASIS / 원장 V-47ddfba8 ASIS / 원장 V-2534f49c ASIS / 원장 V-7189d831 ASIS / 원장 V-4c454807 ASIS / 원장 V-0679fe5e  |  | 109 (ACT:DMF0042_BizPlan..ctor ACT:DMF0042_Bi) |
| WK-DMF0042-1883 | M3 | DMF0042_BizPlan_old | 하네스·환경 | M3 도구 오류 — 원장 V-9e2dfac9 ASIS / 원장 V-7e9fa75c ASIS / 원장 V-41d0eafc ASIS / 원장 V-7b310ef6 ASIS / 원장 V-39fc6309 ASIS / 원장 V-41d17e31  |  | 53 (ACT:DMF0042_BizPlan_old..ctor ACT:DMF004) |
| WK-DMF0042-1884 | M3 | DMF0042_ExchangeRatePopup | 하네스·환경 | M3 도구 오류 — 원장 V-61b1b3e0 ASIS / 원장 V-d9311d6a ASIS / 원장 V-d5b20abe ASIS / 원장 V-47ddfba8 ASIS |  | 27 (ACT:DMF0042_1_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1885 | M3 | btnColumn | 하네스·환경 | M3 도구 오류 — 원장 V-fa946da2 ASIS / 원장 V-cb73350f ASIS / 원장 V-31ccdc9f ASIS / 원장 V-084a9f65 ASIS / 원장 V-9e2dfac9 ASIS |  | 12 (ACT:DMF0042_1_BizPlan.InitControls:314:4) |
| WK-DMF0042-1886 | M3 | btnCutOff | 하네스·환경 | M3 도구 오류 — 실측[T-cda03135]: 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류 · 셀 더블클릭 팝업) · popup_data_check.py(개인화 팝업 목록 = TO |  | 28 (ACT:DMF0042_1_BizPlan.DefineProperty ACT) |
| WK-DMF0042-1887 | M3 | btnExchangeRate | 하네스·환경 | M3 도구 오류 — 원장 V-61b1b3e0 ASIS / 원장 V-d9311d6a ASIS / 원장 V-d5b20abe ASIS / 원장 V-47ddfba8 ASIS |  | 4 (ACT:DMF0042_1_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1888 | M3 | btnIncotermsChg | 하네스·환경 | M3 도구 오류 — 원장 V-7e9fa75c ASIS |  | 1 (ACT:DMF0042_BizPlan_old.btnIncotermsChg_) |
| WK-DMF0042-1889 | M3 | btnItemId | 하네스·환경 | M3 도구 오류 — 원장 V-d0296cf9 ASIS / 원장 V-07843a25 ASIS / 원장 V-56c78e2b ASIS / 원장 V-2534f49c ASIS / 원장 V-41d0eafc ASIS |  | 4 (ACT:DMF0042_1_BizPlan.btnItemId_Click AC) |
| WK-DMF0042-1890 | M3 | btnMeasure | 하네스·환경 | M3 도구 오류 — 원장 V-675768c9 ASIS / 원장 V-a61baf50 ASIS / 원장 V-1b4aec2a ASIS / 원장 V-7189d831 ASIS / 원장 V-7b310ef6 ASIS |  | 12 (ACT:DMF0042_1_BizPlan.InitControls:315:4) |
| WK-DMF0042-1891 | M3 | btnOwner | 하네스·환경 | M3 도구 오류 — 원장 V-1c96c6d6 ASIS / 원장 V-2a3cca60 ASIS / 원장 V-8b49f48e ASIS / 원장 V-4c454807 ASIS / 원장 V-39fc6309 ASIS |  | 4 (ACT:DMF0042_1_BizPlan.btnOwner_Click ACT) |
| WK-DMF0042-1892 | M3 | btnProject | 하네스·환경 | M3 도구 오류 — 원장 V-f32309f8 ASIS / 원장 V-e2d3e239 ASIS / 원장 V-02175830 ASIS / 원장 V-0679fe5e ASIS / 원장 V-41d17e31 ASIS |  | 36 (ACT:DMF0042_1_BizPlan.InitControls ACT:D) |
| WK-DMF0042-1893 | M3 | btnReplace | 하네스·환경 | M3 도구 오류 — 실측[T-d5a5689b]: 검사기 있음(_trace.spec(@trace) W4b 팝업 내부 조회(Search → 행·오류 · 셀 더블클릭 팝업) · popup_data_check.py(개인화 팝업 목록 = TO |  | 3 (ACT:DMF0042_1_BizPlan.btnReplace_Click A) |
| WK-DMF0042-1894 | M3 | new DM0002_ItembyDivisionPopupEx() | 하네스·환경 | M3 도구 오류 — 원장 V-d0296cf9 |  | 1 (ACT:DMF0042_1_BizPlan.btnItemId_Click:27) |
| WK-DMF0042-1895 | M3 | new DM0002_ItembyDivisionPopupEx() | 하네스·환경 | M3 도구 오류 — 원장 V-ec1c0834 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1896 | M3 | new DM0002_ItembyDivisionPopupEx() | 하네스·환경 | M3 도구 오류 — 원장 V-07843a25 |  | 1 (ACT:DMF0042_2_BizPlan.btnItemId_Click:30) |
| WK-DMF0042-1897 | M3 | new DM0002_ItembyDivisionPopupEx() | 하네스·환경 | M3 도구 오류 — 원장 V-64bd6e80 |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1898 | M3 | new DM0002_ItembyDivisionPopupEx() | 하네스·환경 | M3 도구 오류 — 원장 V-56c78e2b |  | 1 (ACT:DMF0042_3_BizPlan.btnItemId_Click:28) |
| WK-DMF0042-1899 | M3 | new DM0002_ItembyDivisionPopupEx() | 하네스·환경 | M3 도구 오류 — 원장 V-1804cd2e |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1900 | M3 | new DM0002_ItembyDivisionPopupEx() | 하네스·환경 | M3 도구 오류 — 원장 V-2534f49c |  | 1 (ACT:DMF0042_BizPlan.btnItemId_Click:2856) |
| WK-DMF0042-1901 | M3 | new DM0002_ItembyDivisionPopupEx() | 하네스·환경 | M3 도구 오류 — 원장 V-b6d2f17d |  | 1 (ACT:DMF0042_BizPlan.spdMain_CellDoubleCl) |
| WK-DMF0042-1902 | M3 | new DM0002_ItembyDivisionPopupEx() | 하네스·환경 | M3 도구 오류 — 원장 V-41d0eafc |  | 1 (ACT:DMF0042_BizPlan_old.btnItemId_Click:) |
| WK-DMF0042-1903 | M3 | new DM0002_ItembyDivisionPopupEx() | 하네스·환경 | M3 도구 오류 — 원장 V-a08c02de |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_CellDoub) |
| WK-DMF0042-1904 | M3 | new DM0002_MatsterChgPopup() | 하네스·환경 | M3 도구 오류 — 원장 V-7e9fa75c |  | 1 (ACT:DMF0042_BizPlan_old.btnIncotermsChg_) |
| WK-DMF0042-1905 | M3 | new DM0002_TitleSetForm_Popup("DMF0042", | 하네스·환경 | M3 도구 오류 — 원장 V-675768c9 |  | 1 (ACT:DMF0042_1_BizPlan.btnMeasure_Click:2) |
| WK-DMF0042-1906 | M3 | new DM0002_TitleSetForm_Popup("DMF0042", | 하네스·환경 | M3 도구 오류 — 원장 V-7189d831 |  | 1 (ACT:DMF0042_BizPlan.btnMeasure_Click:288) |
| WK-DMF0042-1907 | M3 | new DM0002_TitleSetForm_Popup("DMF0042", | 하네스·환경 | M3 도구 오류 — 원장 V-7b310ef6 |  | 1 (ACT:DMF0042_BizPlan_old.btnMeasure_Click) |
| WK-DMF0042-1908 | M3 | new DM0002_TitleSetForm_Popup("DMF0042", | 하네스·환경 | M3 도구 오류 — 원장 V-fa946da2 |  | 1 (ACT:DMF0042_1_BizPlan.btnColumn_Click:28) |
| WK-DMF0042-1909 | M3 | new DM0002_TitleSetForm_Popup("DMF0042", | 하네스·환경 | M3 도구 오류 — 원장 V-084a9f65 |  | 1 (ACT:DMF0042_BizPlan.btnColumn_Click:2872) |
| WK-DMF0042-1910 | M3 | new DM0002_TitleSetForm_Popup("DMF0042", | 하네스·환경 | M3 도구 오류 — 원장 V-9e2dfac9 |  | 1 (ACT:DMF0042_BizPlan_old.btnColumn_Click:) |
| WK-DMF0042-1911 | M3 | new DM0002_TitleSetForm_Popup("DMF0042_1 | 하네스·환경 | M3 도구 오류 — 원장 V-a61baf50 |  | 1 (ACT:DMF0042_2_BizPlan.btnMeasure_Click:3) |
| WK-DMF0042-1912 | M3 | new DM0002_TitleSetForm_Popup("DMF0042_1 | 하네스·환경 | M3 도구 오류 — 원장 V-cb73350f |  | 1 (ACT:DMF0042_2_BizPlan.btnColumn_Click:30) |
| WK-DMF0042-1913 | M3 | new DM0002_TitleSetForm_Popup("DMF0042_3 | 하네스·환경 | M3 도구 오류 — 원장 V-1b4aec2a |  | 1 (ACT:DMF0042_3_BizPlan.btnMeasure_Click:2) |
| WK-DMF0042-1914 | M3 | new DM0002_TitleSetForm_Popup("DMF0042_3 | 하네스·환경 | M3 도구 오류 — 원장 V-31ccdc9f |  | 1 (ACT:DMF0042_3_BizPlan.btnColumn_Click:28) |
| WK-DMF0042-1915 | M3 | new DM0020_OwnerbyDivisionPopup() | 하네스·환경 | M3 도구 오류 — 원장 V-1c96c6d6 |  | 1 (ACT:DMF0042_1_BizPlan.btnOwner_Click:295) |
| WK-DMF0042-1916 | M3 | new DM0020_OwnerbyDivisionPopup() | 하네스·환경 | M3 도구 오류 — 원장 V-2a3cca60 |  | 1 (ACT:DMF0042_2_BizPlan.btnOwner_Click:317) |
| WK-DMF0042-1917 | M3 | new DM0020_OwnerbyDivisionPopup() | 하네스·환경 | M3 도구 오류 — 원장 V-8b49f48e |  | 1 (ACT:DMF0042_3_BizPlan.btnOwner_Click:306) |
| WK-DMF0042-1918 | M3 | new DM0020_OwnerbyDivisionPopup() | 하네스·환경 | M3 도구 오류 — 원장 V-4c454807 |  | 1 (ACT:DMF0042_BizPlan.btnOwner_Click:3016:) |
| WK-DMF0042-1919 | M3 | new DM0020_OwnerbyDivisionPopup() | 하네스·환경 | M3 도구 오류 — 원장 V-39fc6309 |  | 1 (ACT:DMF0042_BizPlan_old.btnOwner_Click:2) |
| WK-DMF0042-1920 | M3 | new POPUP.DMF0042_ExchangeRatePopup() | 하네스·환경 | M3 도구 오류 — 원장 V-61b1b3e0 |  | 1 (ACT:DMF0042_1_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1921 | M3 | new POPUP.DMF0042_ExchangeRatePopup() | 하네스·환경 | M3 도구 오류 — 원장 V-d9311d6a |  | 1 (ACT:DMF0042_2_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1922 | M3 | new POPUP.DMF0042_ExchangeRatePopup() | 하네스·환경 | M3 도구 오류 — 원장 V-d5b20abe |  | 1 (ACT:DMF0042_3_BizPlan.btnExchangeRate_Cl) |
| WK-DMF0042-1923 | M3 | new POPUP.DMF0042_ExchangeRatePopup() | 하네스·환경 | M3 도구 오류 — 원장 V-47ddfba8 |  | 1 (ACT:DMF0042_BizPlan.btnExchangeRate_Clic) |
| WK-DMF0042-1924 | M3 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | M3 도구 오류 — 원장 V-f32309f8 |  | 1 (ACT:DMF0042_1_BizPlan.btnProject_Click:2) |
| WK-DMF0042-1925 | M3 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | M3 도구 오류 — 원장 V-a1e299fa |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1926 | M3 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | M3 도구 오류 — 원장 V-9bea4449 |  | 1 (ACT:DMF0042_1_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1927 | M3 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | M3 도구 오류 — 원장 V-e2d3e239 |  | 1 (ACT:DMF0042_2_BizPlan.btnProject_Click:2) |
| WK-DMF0042-1928 | M3 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | M3 도구 오류 — 원장 V-8bcd645c |  | 1 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1929 | M3 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | M3 도구 오류 — 원장 V-02175830 |  | 1 (ACT:DMF0042_3_BizPlan.btnProject_Click:2) |
| WK-DMF0042-1930 | M3 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | M3 도구 오류 — 원장 V-55e298ba |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1931 | M3 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | M3 도구 오류 — 원장 V-d1823927 |  | 1 (ACT:DMF0042_3_BizPlan.spdMain_CellDouble) |
| WK-DMF0042-1932 | M3 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | M3 도구 오류 — 원장 V-0679fe5e |  | 1 (ACT:DMF0042_BizPlan.btnProject_Click:283) |
| WK-DMF0042-1933 | M3 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | M3 도구 오류 — 원장 V-1d043b2b |  | 1 (ACT:DMF0042_BizPlan.spdMain_CellDoubleCl) |
| WK-DMF0042-1934 | M3 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | M3 도구 오류 — 원장 V-ac72aa62 |  | 1 (ACT:DMF0042_BizPlan.spdMain_CellDoubleCl) |
| WK-DMF0042-1935 | M3 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | M3 도구 오류 — 원장 V-41d17e31 |  | 1 (ACT:DMF0042_BizPlan_old.btnProject_Click) |
| WK-DMF0042-1936 | M3 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | M3 도구 오류 — 원장 V-1eb70f98 |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_CellDoub) |
| WK-DMF0042-1937 | M3 | new SCM0002_ProjectbyDivisionPopupEx() | 하네스·환경 | M3 도구 오류 — 원장 V-0092a45a |  | 1 (ACT:DMF0042_BizPlan_old.spdMain_CellDoub) |
| WK-DMF0042-1938 | M4 | 21 | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 21 'InsertButton → InsertRow (L1150~1417)' 의 M4 49요소: NOT_RUN:49 (미실행 요소가 남아 판정필요) |  | 1 (21) |
| WK-DMF0042-1939 | M4 | 6 | 하네스·환경 | M4 도구 오류 — 행 집계 — 대조표 6 'Exchange Rate 모달 = 표준 CustomDialog+DataGrid 재구성 (A' 의 M4 49요소: NOT_RUN:49 (미실행 요소가 남아 판정필요) |  | 1 (6) |
| WK-DMF0042-1940 | M4 | DMF0042_2_BizPlan.spdMain_CellDoubleClic | 하네스·환경 | M4 도구 오류 — 진입점 집계 — 대조표 DMF0042_2_BizPlan.spdMain_CellDoubleClick 의 M4 25요소: NOT_RUN:25 (미실행 요소가 남아 판정필요) |  | 14 (ACT:DMF0042_2_BizPlan.spdMain_CellDouble) |
