# 작업 원장 — SCP0005 · 2026-11-19 17:08

> 검사 인스턴스 565건 중 PASS·NA 316건 외 **249건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W1 | 기능 구현 | 1 | 대조표 구현 + 위치 기입 → W8 실행 |
| W3 | 동작 수정 | 10 | 재판정 PASS |
| W5 | 검사기 연결 | 13 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 2 | 실행 → PASS |
| W7 | 기대값 확정 | 19 | 기대 확정 → PASS/FAIL |
| W8 | 구현 후 검증 | 3 | 선행 W1 → PASS |
| W9 | 도구 오류 | 201 | 원인 해소 → 재판정 |

- 담당: 하네스·환경 201 · 사람 판정 / AS-IS 원문 확인 → 재판정 19 · 하네스 13 · FE 5 · 선행 W1 완료 후 E2E 3 · 화면 FE 2 · DB 객체 2 · DB 2 · E2E 2
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 3건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| H2 | DESIGN |  |  |  |  |  |  |  |  | 28 | 배경·글자색 규칙 |
| C3 | CASCADE |  |  |  |  |  |  |  |  | 25 | 연쇄 자동 채움 |
| X-ROW | GEN |  |  | 3 |  |  |  |  |  | 21 | 대조표 행이 서술한 동작을 화면에서 재현 |
| C2 | CASCADE |  |  |  |  |  |  |  |  | 24 | 그리드 셀 cascade 후보 |
| H6 | POPUP |  |  |  |  | 3 | 2 | 2 |  | 12 | 팝업 표준·열림 |
| C6 | CASCADE |  |  |  |  |  |  |  |  | 17 | 무변경 편집 종료 시 연쇄 미발동 |
| G5 | POPUP |  |  |  |  | 7 |  |  |  | 9 | 팝업 조건 연동(인자) |
| A1 | GEN |  |  |  |  |  |  | 12 | 1 |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| G4 | DESIGN |  |  |  |  |  |  |  | 1 | 9 | 조회조건 표시·라벨·활성 |
| H5 | DESIGN |  |  |  |  |  |  |  |  | 9 | 라벨 명칭 |
| G1 | GEN |  |  |  |  |  |  |  | 1 | 7 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| A5 | DESIGN |  |  |  |  |  |  |  |  | 8 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| D1 | EDIT |  |  |  |  |  |  |  |  | 8 | 컬럼 편집 가능 여부(신규행·기존행) |
| E4 | EDIT |  |  | 2 |  |  |  |  |  | 5 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| M4 | POPUP |  |  |  |  |  |  | 1 |  | 5 | 팝업 선택값 반영 |
| A6 | GEN |  |  | 2 |  |  |  |  |  | 3 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| E3 | EDIT |  |  |  |  |  |  | 4 |  |  | 필수 입력 검증 |
| F4 | DB |  |  |  |  |  |  |  |  | 4 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| DB-SYN | DB |  |  |  |  | 3 |  |  |  |  | BE 계정 시노님·권한·대상 객체 |
| X-REASON | DESIGN |  |  | 2 |  |  |  |  |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| M3 | POPUP |  |  |  |  |  |  |  |  | 2 | 팝업 내부 기능(조회·CRUD) · 팝업 목록 행수(조회조건 변경 후 포함) |
| X-NOTIMPL | GEN | 1 |  |  |  |  |  |  |  |  | 대조표 상태 미구현 = 구현 대상(FAIL) |
| F2 | CRUD |  |  | 1 |  |  |  |  |  |  | 1회 저장(변경 감지) |
| J2 | AUTH |  |  |  |  |  |  |  |  | 1 | 권한별 버튼·기능 |
| K4 | COMMON |  |  |  |  |  |  |  |  | 1 | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 DB 반영(마커 행) |
| F6 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 값 보존 |
| I1 | DESIGN |  |  |  |  |  |  |  |  | 1 | LBL/MSG 언어별 등록 |

## W1 기능 구현 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0005-0001 | X-NOTIMPL | dead 콤보(Division/Site/BodType/dtFromCoun | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — dead 콤보(Division/Site/BodType/dtFromCountry/dtToCountry/dtYesOrNo) 미구현(신설 금지) design 02 §2.4 |  | 1 (dead 콤보(Division/Site/BodType/dtFromCoun) |

## W3 동작 수정 (10)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0005-0002 | F2 | SCP0005 화면 | 화면 FE(범위 밖(가이드만)) | F2 FAIL 수정 — SCP0005 화면: 원장 V-c3ce3016 RULE_SCREEN / 원장 V-3aecb21a RULE_SCREEN / 원장 V-5b084571 RULE_SCREEN / 원장 V-91202d1b GENERAL |  | 195 (R14/R15 저장응답 색칠(99010/99020) SaveButton ) |
| WK-SCP0005-0003 | X-REASON | COMMON:UC-03 | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-REASON FAIL 수정 — COMMON:UC-03: [대조표 근거 없음] 요소 '컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 데이터 Reset 후 재조회' 제외 사유 'Measure 0(정적 39컬럼, SH |  | 1 (COMMON:UC-03) |
| WK-SCP0005-0004 | X-REASON | COMMON:UC-06 | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-REASON FAIL 수정 — COMMON:UC-06: [대조표 근거 없음] 요소 'Key-in 조회조건 콤마 다중입력 전건 조회' 제외 사유 'TransMode 는 GET SP UF_FX_STRING_SPLIT 콤마 다중(des |  | 1 (COMMON:UC-06) |
| WK-SCP0005-0005 | E4 | MSG00043 | DB 객체(PKG/SP)(적용 예정) | E4 FAIL 수정 — MSG00043: 원장 V-3134fc3e / 실측[T-ece1c98b]: MSG00043: AS-IS 는 저장 실패 응답의 오류코드(99010 중복·99020/99030/99040 검증 실패)에 따라 문제가  |  | 1 (ACT:SCP0005_DistributionRoute.SaveData:8) |
| WK-SCP0005-0006 | E4 | MSG00043 | DB 객체(PKG/SP)(적용 예정) | E4 FAIL 수정 — MSG00043: 원장 V-3134fc3e ASIS / 실측[T-f048d4a9]: MSG00043: AS-IS 는 저장 실패 응답의 오류코드(99010 중복·99020/99030/99040 검증 실패)에 따라 |  | 1 (ACT:SCP0005_DistributionRoute.SaveData:8) |
| WK-SCP0005-0007 | A6 | FindDataMain 파라미터 6종 'ALL'→'' | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — FindDataMain 파라미터 6종 'ALL'→'': 행 집계 — 대조표 FindDataMain 파라미터 6종 'ALL'→'' 'store `setFilter()` `orEmpty()`' 의 A6 4요소: E |  | 1 (FindDataMain 파라미터 6종 'ALL'→'') |
| WK-SCP0005-0008 | A6 | PKG_SCP0005.P_SCP0005_GET_DISTRIBUTION_R | DB(🛠️/🧯 적용 가능) | A6 FAIL 수정 — PKG_SCP0005.P_SCP0005_GET_DISTRIBUTION_ROUTE: 원장 V-3f21e469 SP / 정렬대조 PASS AS-IS 키 뒤에 동률 고정 키 추가 ['ROUTE_ID'] — 순서 보장 |  | 50 (ACT:SCP0005_DistributionRoute.FindButton) |
| WK-SCP0005-0009 | X-ROW | SCP0005_DistributionRoute.FindButton | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SCP0005_DistributionRoute.FindButton: 진입점 집계 9검사 — ERROR:4 · PASS:3 · REVIEW:1 · FAIL:1 |  | 1 (ACT:SCP0005_DistributionRoute.FindButton) |
| WK-SCP0005-0010 | X-ROW | SCP0005_DistributionRoute.FindDataMain | FE(repairScope=DB_ONLY — 이번 범위 밖) | X-ROW FAIL 수정 — SCP0005_DistributionRoute.FindDataMain: 진입점 집계 14검사 — PASS:7 · NA:4 · ERROR:2 · FAIL:1 |  | 6 (ACT:SCP0005_DistributionRoute.FindDataMa) |
| WK-SCP0005-0011 | X-ROW | SCP0005_DistributionRoute.SaveData | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0005_DistributionRoute.SaveData: 진입점 집계 33검사 — ERROR:16 · NA:7 · PASS:6 · FAIL:3 · NOPATH:1 (FX-SCP0005-056) |  | 3 (ACT:SCP0005_DistributionRoute.SaveData:6) |

## W5 검사기 연결 (13)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0005-0012 | DB-SYN | SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID | 없음(PROC_M 대응 없음) | 3 (ACT:SCP0005_DistributionRoutePopup.FindD) |
| WK-SCP0005-0013 | DB-SYN | SCP0005_GET_DISTRIBUTION_ROUTEID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0005_GET_DISTRIBUTION_ROUTEID | 없음(PROC_M 대응 없음) | 3 (ACT:SCP0005_DistributionRoute.FindDataRe) |
| WK-SCP0005-0014 | DB-SYN | SCP0005_SAVE_DISTRIBUTION_ROUTE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0005_SAVE_DISTRIBUTION_ROUTE | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0005_DistributionRoute.SaveData:7) |
| WK-SCP0005-0015 | G5 | FROM_CITY_NAME / City Name | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL FROM_CITY_NAME / City Name | 있음(SHEET_COLUMNS) | 4 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0016 | G5 | TO_CITY / City | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL TO_CITY / City | 있음(SHEET_COLUMNS) | 5 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0017 | G5 | TO_CITY_NAME / City Name | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL TO_CITY_NAME / City Name | 있음(SHEET_COLUMNS) | 3 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0018 | G5 | txtFromCity / From City | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COND txtFromCity / From City | 있음(FE 소스) | 5 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0019 | G5 | txtFromCountry / From Country | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COND txtFromCountry / From Country | 있음(FE 소스) | 5 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0020 | G5 | txtToCity / To City | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COND txtToCity / To City | 있음(FE 소스) | 5 (txtToCountry/txtToCity + btnToSrch ACT:S) |
| WK-SCP0005-0021 | G5 | txtToCountry / To Country | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COND txtToCountry / To Country | 있음(FE 소스) | 5 (txtToCountry/txtToCity + btnToSrch ACT:S) |
| WK-SCP0005-0022 | H6 | FROM_CITY_NAME / City Name | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL FROM_CITY_NAME / City Name | 있음(SHEET_COLUMNS) | 4 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0023 | H6 | TO_CITY / City | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL TO_CITY / City | 있음(SHEET_COLUMNS) | 5 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0024 | H6 | TO_CITY_NAME / City Name | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL TO_CITY_NAME / City Name | 있음(SHEET_COLUMNS) | 3 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |

## W6 검증 실행 (2)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0005-0025 | H6 | txtFromCountry / From Country | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtFromCountry / From Country · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 5 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0026 | H6 | txtToCountry / To Country | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtToCountry / To Country · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 5 (txtToCountry/txtToCity + btnToSrch ACT:S) |

## W7 기대값 확정 (19)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0005-0027 | E3 | DAYS / Departure Days | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — DAYS / Departure Days: AS-IS 필수 표시(grid_rule 라벨 *) 정보 없음 — TO-BE 필수=False |  | 1 (DAYS 최소 1 (MSG00223)) |
| WK-SCP0005-0028 | E3 | R16/R17 클라 검증 색칠 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — R16/R17 클라 검증 색칠: 행 집계 — 대조표 R16/R17 클라 검증 색칠 '`validateRows`(전 편집행 누적, iter-2 G4) → `invalidCell' 의 E3 4요소: PASS:3 ·  |  | 1 (R16/R17 클라 검증 색칠) |
| WK-SCP0005-0029 | E3 | SaveButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — SaveButton: 행 집계 — 대조표 SaveButton '`hotkeyConfig.save`=handleSave (validate→saveWithV' 의 E3 4요소: PASS:3 · REVIEW:1 · F |  | 1 (SaveButton) |
| WK-SCP0005-0030 | E3 | 메타 필수(INPUT_TP_CD=M/IM) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — 메타 필수(INPUT_TP_CD=M/IM): 행 집계 — 대조표 메타 필수(INPUT_TP_CD=M/IM) '`useSaveWithValidation`' 의 E3 4요소: PASS:3 · REVIEW:1 · FA |  | 1 (메타 필수(INPUT_TP_CD=M/IM)) |
| WK-SCP0005-0031 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — 대조표 COMMON:UC-07 '필터 걸린 상태 재조회해도 조회되고 필터도 유지(rebindFilterColumns)' 의 A1 4요소: PASS:2 · REVIEW:2 ·  |  | 1 (COMMON:UC-07) |
| WK-SCP0005-0032 | A1 | FindButton(Search) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindButton(Search): 행 집계 — 대조표 FindButton(Search) '`hotkeyConfig.search`=handleSearch (hasButton)' 의 A1 4요소: PASS:2 ·  |  | 1 (FindButton(Search)) |
| WK-SCP0005-0033 | A1 | FindDataMain 파라미터 6종 'ALL'→'' | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindDataMain 파라미터 6종 'ALL'→'': 행 집계 — 대조표 FindDataMain 파라미터 6종 'ALL'→'' 'store `setFilter()` `orEmpty()`' 의 A1 4요소: PA |  | 1 (FindDataMain 파라미터 6종 'ALL'→'') |
| WK-SCP0005-0034 | A1 | R7 조회 databind | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R7 조회 databind: 행 집계 — 대조표 R7 조회 databind '`useTabProcQuery` o_rc1' 의 A1 4요소: PASS:2 · REVIEW:2 · FAIL 요소: SCP0005_GET |  | 1 (R7 조회 databind) |
| WK-SCP0005-0035 | A1 | SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID: 골든 비교 케이스 없음(SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID — 팝업·보조 SP 는 golden_ca |  | 14 (ACT:SCP0005_DistributionRoutePopup.FindB) |
| WK-SCP0005-0036 | A1 | SCP0005_GET_DISTRIBUTION_ROUTEID | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0005_GET_DISTRIBUTION_ROUTEID: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0005/SCP0005_GET_DISTRIBUTION_ROUTE |  | 34 (ACT:SCP0005_DistributionRoute.FindButton) |
| WK-SCP0005-0037 | A1 | btnEaxel_Upload → ExcelUploadForm2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — btnEaxel_Upload → ExcelUploadForm2: 행 집계 — 대조표 btnEaxel_Upload → ExcelUploadForm2 "customButton 'Excel Upload' → `Exce |  | 1 (btnEaxel_Upload → ExcelUploadForm2) |
| WK-SCP0005-0038 | A1 | cascade(clbFromCountry→City) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cascade(clbFromCountry→City): 행 집계 — 대조표 cascade(clbFromCountry→City) '없음(주석 폐기) — 무cascade' 의 A1 4요소: PASS:2 · REVIEW |  | 1 (cascade(clbFromCountry→City)) |
| WK-SCP0005-0039 | A1 | cboValidYN (UsrCombo) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboValidYN (UsrCombo): 행 집계 — 대조표 cboValidYN (UsrCombo) 'Form `CustomDropdown` 정적 ALL/Y/N (`VALID_OPTIONS`)' 의 A1 4요소: |  | 1 (cboValidYN (UsrCombo)) |
| WK-SCP0005-0040 | A1 | clbTransMode (UsrCheckedList **다중 체크** — | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbTransMode (UsrCheckedList **다중 체크** — Designer : 행 집계 — 대조표 clbTransMode (UsrCheckedList **다중 체크** — Designer ItemS |  | 1 (clbTransMode (UsrCheckedList **다중 체크** —) |
| WK-SCP0005-0041 | A1 | txtFromCountry/txtFromCity + btnFromSrch | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — txtFromCountry/txtFromCity + btnFromSrch: 행 집계 — 대조표 txtFromCountry/txtFromCity + btnFromSrch 'Form `InputField` 2 + 돋 |  | 1 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0042 | A1 | txtToCountry/txtToCity + btnToSrch | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — txtToCountry/txtToCity + btnToSrch: 행 집계 — 대조표 txtToCountry/txtToCity + btnToSrch 'Form `InputField` 2 + 돋보기 → `Region |  | 1 (txtToCountry/txtToCity + btnToSrch) |
| WK-SCP0005-0043 | H6 | txtFromCity / From City | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — txtFromCity / From City: E2E smoke cond popup |  | 5 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0044 | H6 | txtToCity / To City | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — txtToCity / To City: E2E smoke cond popup |  | 5 (txtToCountry/txtToCity + btnToSrch ACT:S) |
| WK-SCP0005-0045 | M4 | SCP0005_DistributionRoutePopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0005_DistributionRoutePopup: 검증 엔진이 실행됐으나 이 대상(POPUP SCP0005_DistributionRoutePopup)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확 |  | 2 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |

## W8 구현 후 검증 (3)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0005-0046 | G4 | dead 콤보(Division/Site/BodType/dtFromCoun | 선행 W1 완료 후 E2E | G4 — 대조표 미구현 행 dead 콤보(Division/Site/BodType/dtFromCountry/dtToCountry/dtYe 구현 후 검증 · 대상 dead 콤보(Division/Site/BodType/dtFromCount |  | 1 (dead 콤보(Division/Site/BodType/dtFromCoun) |
| WK-SCP0005-0047 | A1 | dead 콤보(Division/Site/BodType/dtFromCoun | 선행 W1 완료 후 E2E | A1 — 대조표 미구현 행 dead 콤보(Division/Site/BodType/dtFromCountry/dtToCountry/dtYe 구현 후 검증 · 대상 dead 콤보(Division/Site/BodType/dtFromCount |  | 1 (dead 콤보(Division/Site/BodType/dtFromCoun) |
| WK-SCP0005-0048 | G1 | dead 콤보(Division/Site/BodType/dtFromCoun | 선행 W1 완료 후 E2E | G1 — 대조표 미구현 행 dead 콤보(Division/Site/BodType/dtFromCountry/dtToCountry/dtYe 구현 후 검증 · 대상 dead 콤보(Division/Site/BodType/dtFromCount |  | 1 (dead 콤보(Division/Site/BodType/dtFromCoun) |

## W9 도구 오류 (201)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0005-0049 | J2 | SCP0005 화면 | 하네스·환경 | J2 도구 오류 — 원장 V-69fd04d9 RULE_SCREEN / 원장 V-bbf3693b DEFECT / 원장 V-5eb41b96 GENERAL / 원장 V-f8acd0f3 GENERAL / 원장 V-d55bf254 GENERA |  | 50 (clbTransMode (UsrCheckedList **다중 체크** —) |
| WK-SCP0005-0050 | C2 | A_COUNTRY / Country | 하네스·환경 | C2 도구 오류 — 실측[T-6e161066]: A_COUNTRY 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0051 | C2 | A_PORT_CODE / Port Code | 하네스·환경 | C2 도구 오류 — 실측[T-6a6f8160]: A_PORT_CODE 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0052 | C2 | A_PORT_NAME / Port | 하네스·환경 | C2 도구 오류 — 실측[T-83feba7d]: A_PORT_NAME 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0053 | C2 | DAYS / Departure Days | 하네스·환경 | C2 도구 오류 — 실측[T-c7a43f16]: DAYS 연쇄 원천 해석 불가 — AS-IS  — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] 검 |  | 1 (R9 TRK/AIR→DAYS 7 'Y') |
| WK-SCP0005-0054 | C2 | DAYS_FRI / Fri | 하네스·환경 | C2 도구 오류 — 실측[T-bd0af4bd]: TRANSPORT_MODE='AIR' → DAYS_FRI 후보 2건 · TRANSPORT_MODE='FERRY' → DAYS_FRI 후보 2건 · TRANSPORT_MODE='TRUCK |  | 2 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0055 | C2 | DAYS_MON / Mon | 하네스·환경 | C2 도구 오류 — 실측[T-f2ca4bd1]: TRANSPORT_MODE='AIR' → DAYS_MON 후보 2건 · TRANSPORT_MODE='FERRY' → DAYS_MON 후보 2건 · TRANSPORT_MODE='TRUCK |  | 3 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0056 | C2 | DAYS_SAT / Sat | 하네스·환경 | C2 도구 오류 — 실측[T-840a1fc6]: TRANSPORT_MODE='AIR' → DAYS_SAT 후보 2건 · TRANSPORT_MODE='FERRY' → DAYS_SAT 후보 2건 · TRANSPORT_MODE='TRUCK |  | 2 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0057 | C2 | DAYS_SUN / Sun | 하네스·환경 | C2 도구 오류 — 실측[T-b03141a1]: TRANSPORT_MODE='AIR' → DAYS_SUN 후보 2건 · TRANSPORT_MODE='FERRY' → DAYS_SUN 후보 2건 · TRANSPORT_MODE='TRUCK |  | 2 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0058 | C2 | DAYS_THU / Thu | 하네스·환경 | C2 도구 오류 — 실측[T-ea99683c]: TRANSPORT_MODE='AIR' → DAYS_THU 후보 2건 · TRANSPORT_MODE='FERRY' → DAYS_THU 후보 2건 · TRANSPORT_MODE='TRUCK |  | 2 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0059 | C2 | DAYS_TUE / Tue | 하네스·환경 | C2 도구 오류 — 실측[T-9e2ec614]: TRANSPORT_MODE='AIR' → DAYS_TUE 후보 2건 · TRANSPORT_MODE='FERRY' → DAYS_TUE 후보 2건 · TRANSPORT_MODE='TRUCK |  | 3 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0060 | C2 | DAYS_WED / Wed | 하네스·환경 | C2 도구 오류 — 실측[T-58285076]: TRANSPORT_MODE='AIR' → DAYS_WED 후보 2건 · TRANSPORT_MODE='FERRY' → DAYS_WED 후보 2건 · TRANSPORT_MODE='TRUCK |  | 2 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0061 | C2 | D_COUNTRY / Country | 하네스·환경 | C2 도구 오류 — 실측[T-d11b8eec]: D_COUNTRY 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0062 | C2 | D_PORT_CODE / Port Code | 하네스·환경 | C2 도구 오류 — 실측[T-87cfd2b2]: D_PORT_CODE 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0063 | C2 | D_PORT_NAME / Port | 하네스·환경 | C2 도구 오류 — 실측[T-e44d0b2b]: D_PORT_NAME 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0064 | C2 | LT_ARRIVAL_INLAND / Arrival Inland | 하네스·환경 | C2 도구 오류 — 실측[T-31aa93b0]: LT_ARRIVAL_INLAND 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 58 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0065 | C2 | LT_DEPARTURE_INLAND / Departure Inland | 하네스·환경 | C2 도구 오류 — 실측[T-de53b6fd]: LT_DEPARTURE_INLAND 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 4 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0066 | C2 | LT_LAY_OFF_CLEARANCE / Lay Off/Customs C | 하네스·환경 | C2 도구 오류 — 실측[T-6feb4248]: LT_LAY_OFF_CLEARANCE 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 4 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0067 | C2 | LT_SUM / Total L/T | 하네스·환경 | C2 도구 오류 — 실측[T-765c437b]: LT_SUM 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0068 | C2 | LT_VOYAGE / Voyage | 하네스·환경 | C2 도구 오류 — 실측[T-23ec1123]: LT_VOYAGE 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 4 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0069 | C2 | LT_WAIT_SHIPPING / Waiting For Shipping | 하네스·환경 | C2 도구 오류 — 실측[T-46b9927d]: LT_WAIT_SHIPPING 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 4 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0070 | C2 | PRIORITY / Priority | 하네스·환경 | C2 도구 오류 — 실측[T-6e75e40a]: PRIORITY 연쇄 원천 해석 불가 — AS-IS  — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검 |  | 1 (R1 숫자셀 범위(cellType)) |
| WK-SCP0005-0071 | C2 | R10 TRK→港/Forwarder 7 '-' | 하네스·환경 | C2 도구 오류 — 행 집계 — 대조표 R10 TRK→港/Forwarder 7 '-' '`portsDash()` cellEditEnded' 의 C2 25요소: ERROR:22 · NA:3 |  | 1 (R10 TRK→港/Forwarder 7 '-') |
| WK-SCP0005-0072 | C2 | SCP0005_DistributionRoute.spdMainDataMod | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SCP0005_DistributionRoute.spdMainDataModel_Changed 의 C2 23요소: ERROR:20 · NA:3 |  | 10 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0073 | C2 | SHIPPING_COMPANY / Forwarder | 하네스·환경 | C2 도구 오류 — 실측[T-745157a9]: SHIPPING_COMPANY 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0074 | C3 | DAYS / Departure Days | 하네스·환경 | C3 도구 오류 — 실측[T-4dd85db6]: DAYS 연쇄 원천 컬럼 해석 불가 — AS-IS  → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (R9 TRK/AIR→DAYS 7 'Y') |
| WK-SCP0005-0075 | C3 | FROM_CITY / City | 하네스·환경 | C3 도구 오류 — 실측[T-5edb7122]: [전제 미충족 T300] FROM_CITY: 원천 Site 후보 입력 실패(From '' · To '') — 연쇄 재현 불가 |  | 13 (ACT:SCP0005_DistributionRoute.SetCityCod) |
| WK-SCP0005-0076 | C3 | FROM_CITY_NAME / City Name | 하네스·환경 | C3 도구 오류 — 실측[T-1d878a60]: FROM_CITY_NAME: 원천 TO_CITY/FROM_CITY 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) → 기계 판정 불가 — 수동 |  | 6 (ACT:SCP0005_DistributionRoute.SetCityCod) |
| WK-SCP0005-0077 | C3 | FROM_COUNTRY / Country | 하네스·환경 | C3 도구 오류 — 실측[T-b82f895f]: [전제 미충족 T300] FROM_COUNTRY: 원천 Site 후보 입력 실패(From '' · To '') — 연쇄 재현 불가 |  | 14 (ACT:SCP0005_DistributionRoute.SetCityCod) |
| WK-SCP0005-0078 | C3 | LT_ARRIVAL_INLAND / Arrival Inland | 하네스·환경 | C3 도구 오류 — 원장 V-a24da326 ASIS / 원장 V-11fc9455 ASIS / 원장 V-980834ad ASIS / 원장 V-bda800bf ASIS / 원장 V-ec443a6e ASIS / 원장 V-8447aae1  |  | 58 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0079 | C3 | LT_DEPARTURE_INLAND / Departure Inland | 하네스·환경 | C3 도구 오류 — 원장 V-980834ad ASIS / 원장 V-bda800bf ASIS / 원장 V-ec443a6e ASIS / 실측[T-8953d4ba]: LT_DEPARTURE_INLAND 연쇄 원천 컬럼 해석 불가 — AS- |  | 4 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0080 | C3 | LT_LAY_OFF_CLEARANCE / Lay Off/Customs C | 하네스·환경 | C3 도구 오류 — 원장 V-bda800bf ASIS / 원장 V-ec443a6e ASIS / 실측[T-305e2727]: LT_LAY_OFF_CLEARANCE 연쇄 원천 컬럼 해석 불가 — AS-IS spdMainDataModel_ |  | 4 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0081 | C3 | LT_SUM / Total L/T | 하네스·환경 | C3 도구 오류 — 원장 V-8447aae1 ASIS / 원장 V-95abdd8e ASIS |  | 3 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0082 | C3 | LT_VOYAGE / Voyage | 하네스·환경 | C3 도구 오류 — 원장 V-ec443a6e ASIS / 실측[T-a9cf4fcb]: LT_VOYAGE 연쇄 원천 컬럼 해석 불가 — AS-IS spdMainDataModel_Changed:996 dt.Rows[nRow][DefCol |  | 4 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0083 | C3 | LT_WAIT_SHIPPING / Waiting For Shipping | 하네스·환경 | C3 도구 오류 — 원장 V-11fc9455 ASIS / 원장 V-980834ad ASIS / 원장 V-bda800bf ASIS / 원장 V-ec443a6e ASIS / 실측[T-e776edc2]: LT_WAIT_SHIPPING 연쇄 |  | 4 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0084 | C3 | R10 TRK→港/Forwarder 7 '-' | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 R10 TRK→港/Forwarder 7 '-' '`portsDash()` cellEditEnded' 의 C3 52요소: PASS:29 · ERROR:21 · NA:2 |  | 1 (R10 TRK→港/Forwarder 7 '-') |
| WK-SCP0005-0085 | C3 | SCP0005_DistributionRoute.SetCityCode | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0005_DistributionRoute.SetCityCode 의 C3 6요소: ERROR:6 |  | 4 (ACT:SCP0005_DistributionRoute.SetCityCod) |
| WK-SCP0005-0086 | C3 | SCP0005_DistributionRoute.SetImageCell | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0005_DistributionRoute.SetImageCell 의 C3 5요소: ERROR:5 |  | 4 (ACT:SCP0005_DistributionRoute.SetImageCe) |
| WK-SCP0005-0087 | C3 | SCP0005_DistributionRoute.spdMainDataMod | 하네스·환경 | C3 도구 오류 — 원장 V-a24da326 ASIS / 원장 V-11fc9455 ASIS / 원장 V-980834ad ASIS / 원장 V-bda800bf ASIS / 원장 V-ec443a6e ASIS / 원장 V-8447aae1  |  | 10 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0088 | C3 | TO_CITY / City | 하네스·환경 | C3 도구 오류 — 실측[T-653f2a16]: [전제 미충족 T300] TO_CITY: 원천 Site 후보 입력 실패(From '' · To '') — 연쇄 재현 불가 |  | 8 (ACT:SCP0005_DistributionRoute.SetCityCod) |
| WK-SCP0005-0089 | C3 | TO_CITY_NAME / City Name | 하네스·환경 | C3 도구 오류 — 실측[T-0803d2d0]: TO_CITY_NAME: 원천 TO_CITY 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) → 기계 판정 불가 — 수동 검수 대상(작업 원장 |  | 5 (ACT:SCP0005_DistributionRoute.SetCityCod) |
| WK-SCP0005-0090 | C3 | TO_COUNTRY / Country | 하네스·환경 | C3 도구 오류 — 실측[T-38e03b62]: [전제 미충족 T300] TO_COUNTRY: 원천 Site 후보 입력 실패(From '' · To '') — 연쇄 재현 불가 |  | 8 (ACT:SCP0005_DistributionRoute.SetCityCod) |
| WK-SCP0005-0091 | C3 | VALID_YN / Valid | 하네스·환경 | C3 도구 오류 — 실측[T-8b3ad504]: VALID_YN 연쇄 원천 컬럼 해석 불가 — AS-IS InsertRow:947 siMain.SetValue(siMain.ActiveRowIndex, siMain.GetColumnIn |  | 1 (ACT:SCP0005_DistributionRoute.InsertRow:) |
| WK-SCP0005-0092 | C3 | dt.Rows[nRow][DefColumns.LT_ARRIVAL_INLA | 하네스·환경 | C3 도구 오류 — 원장 V-a24da326 |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0093 | C3 | dt.Rows[nRow][DefColumns.LT_DEPARTURE_IN | 하네스·환경 | C3 도구 오류 — 원장 V-980834ad |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0094 | C3 | dt.Rows[nRow][DefColumns.LT_LAY_OFF_CLEA | 하네스·환경 | C3 도구 오류 — 원장 V-bda800bf |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0095 | C3 | dt.Rows[nRow][DefColumns.LT_SUM] | 하네스·환경 | C3 도구 오류 — 원장 V-8447aae1 |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0096 | C3 | dt.Rows[nRow][DefColumns.LT_SUM] | 하네스·환경 | C3 도구 오류 — 원장 V-95abdd8e |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0097 | C3 | dt.Rows[nRow][DefColumns.LT_VOYAGE] | 하네스·환경 | C3 도구 오류 — 원장 V-ec443a6e |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0098 | C3 | dt.Rows[nRow][DefColumns.LT_WAIT_SHIPPIN | 하네스·환경 | C3 도구 오류 — 원장 V-11fc9455 |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0099 | C6 | DAYS / Departure Days | 하네스·환경 | C6 도구 오류 — 실측[T-dc040561]: DAYS 연쇄 원천 해석 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] 검사기(_verif |  | 1 (R9 TRK/AIR→DAYS 7 'Y') |
| WK-SCP0005-0100 | C6 | LT_ARRIVAL_INLAND / Arrival Inland | 하네스·환경 | C6 도구 오류 — 원장 V-eef89e27 ASIS / 원장 V-5580d731 ASIS / 원장 V-e99b3a48 ASIS / 원장 V-94daba6e ASIS / 원장 V-74b7f3ca ASIS / 원장 V-0adb17b9  |  | 58 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0101 | C6 | LT_DEPARTURE_INLAND / Departure Inland | 하네스·환경 | C6 도구 오류 — 원장 V-e99b3a48 ASIS / 원장 V-94daba6e ASIS / 원장 V-74b7f3ca ASIS / 실측[T-39282451]: LT_ARRIVAL_INLAND 셀을 열었다가 값을 바꾸지 않고 닫음(더 |  | 4 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0102 | C6 | LT_LAY_OFF_CLEARANCE / Lay Off/Customs C | 하네스·환경 | C6 도구 오류 — 원장 V-94daba6e ASIS / 원장 V-74b7f3ca ASIS / 실측[T-07dc1388]: LT_ARRIVAL_INLAND 셀을 열었다가 값을 바꾸지 않고 닫음(더블클릭+Esc) → LT_LAY_OFF |  | 4 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0103 | C6 | LT_SUM / Total L/T | 하네스·환경 | C6 도구 오류 — 원장 V-0adb17b9 ASIS / 원장 V-156b0f5d ASIS / 실측[T-ba174192]: LT_ARRIVAL_INLAND 셀을 열었다가 값을 바꾸지 않고 닫음(더블클릭+Esc) → LT_SUM '0' |  | 3 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0104 | C6 | LT_VOYAGE / Voyage | 하네스·환경 | C6 도구 오류 — 원장 V-74b7f3ca ASIS / 실측[T-44ab1176]: LT_ARRIVAL_INLAND 셀을 열었다가 값을 바꾸지 않고 닫음(더블클릭+Esc) → LT_VOYAGE '0'→'0' — 값 유지(정상) |  | 4 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0105 | C6 | LT_WAIT_SHIPPING / Waiting For Shipping | 하네스·환경 | C6 도구 오류 — 원장 V-5580d731 ASIS / 원장 V-e99b3a48 ASIS / 원장 V-94daba6e ASIS / 원장 V-74b7f3ca ASIS / 실측[T-488e25b7]: LT_ARRIVAL_INLAND 셀 |  | 4 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0106 | C6 | PRIORITY / Priority | 하네스·환경 | C6 도구 오류 — 실측[T-6e2ef7c8]: PRIORITY 연쇄 원천 해석 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] 검사기(_v |  | 1 (R1 숫자셀 범위(cellType)) |
| WK-SCP0005-0107 | C6 | R10 TRK→港/Forwarder 7 '-' | 하네스·환경 | C6 도구 오류 — 행 집계 — 대조표 R10 TRK→港/Forwarder 7 '-' '`portsDash()` cellEditEnded' 의 C6 46요소: PASS:29 · ERROR:15 · NA:2 |  | 1 (R10 TRK→港/Forwarder 7 '-') |
| WK-SCP0005-0108 | C6 | SCP0005_DistributionRoute.spdMainDataMod | 하네스·환경 | C6 도구 오류 — 원장 V-eef89e27 ASIS / 원장 V-5580d731 ASIS / 원장 V-e99b3a48 ASIS / 원장 V-94daba6e ASIS / 원장 V-74b7f3ca ASIS / 원장 V-0adb17b9  |  | 10 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0109 | C6 | dt.Rows[nRow][DefColumns.LT_ARRIVAL_INLA | 하네스·환경 | C6 도구 오류 — 원장 V-eef89e27 |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0110 | C6 | dt.Rows[nRow][DefColumns.LT_DEPARTURE_IN | 하네스·환경 | C6 도구 오류 — 원장 V-e99b3a48 |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0111 | C6 | dt.Rows[nRow][DefColumns.LT_LAY_OFF_CLEA | 하네스·환경 | C6 도구 오류 — 원장 V-94daba6e |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0112 | C6 | dt.Rows[nRow][DefColumns.LT_SUM] | 하네스·환경 | C6 도구 오류 — 원장 V-0adb17b9 |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0113 | C6 | dt.Rows[nRow][DefColumns.LT_SUM] | 하네스·환경 | C6 도구 오류 — 원장 V-156b0f5d |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0114 | C6 | dt.Rows[nRow][DefColumns.LT_VOYAGE] | 하네스·환경 | C6 도구 오류 — 원장 V-74b7f3ca |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0115 | C6 | dt.Rows[nRow][DefColumns.LT_WAIT_SHIPPIN | 하네스·환경 | C6 도구 오류 — 원장 V-5580d731 |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0116 | K4 | SCP0005 화면 | 하네스·환경 | K4 도구 오류 — 원장 V-4da2eeab GENERAL / 원장 V-971d34fe GENERAL / 원장 V-df84cd6a GENERAL / 원장 V-88b2cf80 GENERAL / 원장 V-7990c634 GENERAL / |  | 33 (COMMON:UC-01 COMMON:UC-04 COMMON:UC-05 C) |
| WK-SCP0005-0117 | F1 | SCP0005 화면 | 하네스·환경 | F1 도구 오류 — 원장 V-c9c3b04a RULE_SCREEN / 원장 V-4e4af2a4 RULE_SCREEN / 원장 V-ed1875e6 RULE_SCREEN / 원장 V-26d2974c RULE_SCREEN / 원장 V-69 |  | 202 (R14/R15 저장응답 색칠(99010/99020) R18 Insert/) |
| WK-SCP0005-0118 | F6 | SCP0005 화면 | 하네스·환경 | F6 도구 오류 — 원장 V-77a721bf RULE_SCREEN / 원장 V-337cb2f9 RULE_SCREEN / 원장 V-189ec7ae RULE_SCREEN / 원장 V-72fbb5b2 RULE_SCREEN / 원장 V-71 |  | 193 (ACT:SCP0005_DistributionRoute.SaveButton) |
| WK-SCP0005-0119 | F4 | FindDataMain 파라미터 6종 'ALL'→'' | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 FindDataMain 파라미터 6종 'ALL'→'' 'store `setFilter()` `orEmpty()`' 의 F4 5요소: ERROR:3 · PASS:1 · NA:1 |  | 1 (FindDataMain 파라미터 6종 'ALL'→'') |
| WK-SCP0005-0120 | F4 | PKG_SCP0005.P_SCP0005_GET_COUNTRY_CITY | 하네스·환경 | F4 도구 오류 — 실측[T-829cf301]: PKG_SCP0005.P_SCP0005_GET_COUNTRY_CITY: SCP0005/route/SEARCH_CITY — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회 경로 — 해 |  | 10 (ACT:SCP0005_DistributionRoute.FindButton) |
| WK-SCP0005-0121 | F4 | SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID | 하네스·환경 | F4 도구 오류 — 실측[T-ea530cd5]: SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID: SCP0005/route/SEARCH_ROUTEID — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회 경 |  | 14 (ACT:SCP0005_DistributionRoutePopup.FindB) |
| WK-SCP0005-0122 | F4 | SCP0005_GET_DISTRIBUTION_ROUTEID | 하네스·환경 | F4 도구 오류 — 실측[T-719d403c]: SCP0005_GET_DISTRIBUTION_ROUTEID: SCP0005/route/SEARCH_ROUTEID — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회 경로 — 해당 시 |  | 34 (ACT:SCP0005_DistributionRoute.FindButton) |
| WK-SCP0005-0123 | A5 | COMMON:UC-07 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터 걸린 상태 재조회해도 조회되고 필터도 유지(rebindFilterColumns)' 의 A5 16요소: PASS:15 · ERROR:1 |  | 1 (COMMON:UC-07) |
| WK-SCP0005-0124 | A5 | DAYS / Departure Days | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-aa4e2eb2]: DAYS: [측정 경로 없음] AS-IS 시트 ? 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 여부 미측정(T203) |  | 1 (R9 TRK/AIR→DAYS 7 'Y') |
| WK-SCP0005-0125 | A5 | DB메타 구동(gridColumns=[]) | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 DB메타 구동(gridColumns=[]) "`staticColumns` admin fetch(`ADMIN_SHEET_NAME`='Di" 의 A5 16요소: PASS:15 · ERROR:1 |  | 1 (DB메타 구동(gridColumns=[])) |
| WK-SCP0005-0126 | A5 | R10 TRK→港/Forwarder 7 '-' | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 R10 TRK→港/Forwarder 7 '-' '`portsDash()` cellEditEnded' 의 A5 16요소: PASS:15 · ERROR:1 |  | 1 (R10 TRK→港/Forwarder 7 '-') |
| WK-SCP0005-0127 | A5 | R11/R12 FROM/TO 셀 더블클릭→도시팝업 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 R11/R12 FROM/TO 셀 더블클릭→도시팝업 '`onFromCellDblClick`/`onToCellDblClick`→`RegionMod' 의 A5 16요소: PASS:15 · ERROR: |  | 1 (R11/R12 FROM/TO 셀 더블클릭→도시팝업) |
| WK-SCP0005-0128 | A5 | R16/R17 클라 검증 색칠 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 R16/R17 클라 검증 색칠 '`validateRows`(전 편집행 누적, iter-2 G4) → `invalidCell' 의 A5 16요소: PASS:15 · ERROR:1 |  | 1 (R16/R17 클라 검증 색칠) |
| WK-SCP0005-0129 | A5 | R18 Insert/Delete | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 R18 Insert/Delete '`GridAction.addRow` / `removeRow(grid, true)`(신규만)' 의 A5 16요소: PASS:15 · ERROR:1 |  | 1 (R18 Insert/Delete) |
| WK-SCP0005-0130 | A5 | R7 조회 databind | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 R7 조회 databind '`useTabProcQuery` o_rc1' 의 A5 16요소: PASS:15 · ERROR:1 |  | 1 (R7 조회 databind) |
| WK-SCP0005-0131 | G4 | FindDataMain 파라미터 6종 'ALL'→'' | 하네스·환경 | G4 도구 오류 — 행 집계 — 대조표 FindDataMain 파라미터 6종 'ALL'→'' 'store `setFilter()` `orEmpty()`' 의 G4 9요소: ERROR:7 · PASS:2 |  | 1 (FindDataMain 파라미터 6종 'ALL'→'') |
| WK-SCP0005-0132 | G4 | btnEaxel | 하네스·환경 | G4 도구 오류 — 실측[T-eb5343b6]: [측정 경로 없음] AS-IS btnEaxel 클릭 메서드가 popup_args.csv 에 없음(팝업을 여는 버튼인지 미확인) |  | 2 (ACT:SCP0005_DistributionRoute.InitEvent ) |
| WK-SCP0005-0133 | G4 | btnFromSrch | 하네스·환경 | G4 도구 오류 — 실측[T-85f3a8bb]: [측정 경로 없음] AS-IS btnFromSrch 클릭 메서드가 popup_args.csv 에 없음(팝업을 여는 버튼인지 미확인) |  | 1 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0134 | G4 | btnToSrch | 하네스·환경 | G4 도구 오류 — 실측[T-7e1a41bb]: [측정 경로 없음] AS-IS btnToSrch 클릭 메서드가 popup_args.csv 에 없음(팝업을 여는 버튼인지 미확인) |  | 1 (txtToCountry/txtToCity + btnToSrch) |
| WK-SCP0005-0135 | G4 | cascade(clbFromCountry→City) | 하네스·환경 | G4 도구 오류 — 행 집계 — 대조표 cascade(clbFromCountry→City) '없음(주석 폐기) — 무cascade' 의 G4 9요소: ERROR:7 · PASS:2 |  | 1 (cascade(clbFromCountry→City)) |
| WK-SCP0005-0136 | G4 | txtFromCity / From City | 하네스·환경 | G4 도구 오류 — E2E smoke labels / 실측[T-88891164]: r0 ROUTE_ID 더블클릭 → 팝업 열림 감지 실패(검사기 미검증) |  | 1 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0137 | G4 | txtFromCountry / From Country | 하네스·환경 | G4 도구 오류 — E2E smoke labels / 실측[T-9b463365]: r0 ROUTE_ID 더블클릭 → 팝업 열림 감지 실패(검사기 미검증) |  | 1 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0138 | G4 | txtToCity / To City | 하네스·환경 | G4 도구 오류 — E2E smoke labels / 실측[T-90d2d30f]: r0 ROUTE_ID 더블클릭 → 팝업 열림 감지 실패(검사기 미검증) |  | 1 (txtToCountry/txtToCity + btnToSrch) |
| WK-SCP0005-0139 | G4 | txtToCountry / To Country | 하네스·환경 | G4 도구 오류 — E2E smoke labels / 실측[T-6d65f303]: r0 ROUTE_ID 더블클릭 → 팝업 열림 감지 실패(검사기 미검증) |  | 1 (txtToCountry/txtToCity + btnToSrch) |
| WK-SCP0005-0140 | H2 | COMMON:UC-07 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터 걸린 상태 재조회해도 조회되고 필터도 유지(rebindFilterColumns)' 의 H2 31요소: ERROR:19 · PASS:11 · NA:1 |  | 1 (COMMON:UC-07) |
| WK-SCP0005-0141 | H2 | DB메타 구동(gridColumns=[]) | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 DB메타 구동(gridColumns=[]) "`staticColumns` admin fetch(`ADMIN_SHEET_NAME`='Di" 의 H2 31요소: ERROR:19 · PASS:11 · |  | 1 (DB메타 구동(gridColumns=[])) |
| WK-SCP0005-0142 | H2 | D_PORT_NAME / Port | 하네스·환경 | H2 도구 오류 — 원장 V-0bef758e COLUMN / 원장 V-0271c876 COLUMN / 원장 V-bc631885 ASIS / 실측[T-ef596679]: D_PORT_NAME: 기존행 편집=true 표시 일치 · 신규행 |  | 1 (ACT:SCP0005_DistributionRoute.SaveData:8) |
| WK-SCP0005-0143 | H2 | D_PORT_NAME,TO_CITY | 하네스·환경 | H2 도구 오류 — 원장 V-bc631885 |  | 1 (ACT:SCP0005_DistributionRoute.SaveData:8) |
| WK-SCP0005-0144 | H2 | FROM_CITY | 하네스·환경 | H2 도구 오류 — 원장 V-0810a59e |  | 1 (ACT:SCP0005_DistributionRoute.CheckValid) |
| WK-SCP0005-0145 | H2 | FROM_CITY | 하네스·환경 | H2 도구 오류 — 원장 V-17e451a7 |  | 1 (ACT:SCP0005_DistributionRoute.CheckValid) |
| WK-SCP0005-0146 | H2 | FROM_CITY / City | 하네스·환경 | H2 도구 오류 — 원장 V-a15f8422 COLUMN / 원장 V-8854335a COLUMN / 원장 V-0810a59e ASIS / 원장 V-17e451a7 ASIS / 원장 V-06e7dec2 ASIS / 실측[T-44723 |  | 5 (ACT:SCP0005_DistributionRoute.CheckValid) |
| WK-SCP0005-0147 | H2 | FROM_CITY_NAME / City Name | 하네스·환경 | H2 도구 오류 — 원장 V-db9114d5 COLUMN / 원장 V-6a920d4c COLUMN / 원장 V-06e7dec2 ASIS / 실측[T-8edcf6b2]: FROM_CITY_NAME: 기존행 편집=false 표시 일치 · |  | 2 (ACT:SCP0005_DistributionRoute.SaveData:8) |
| WK-SCP0005-0148 | H2 | FROM_CITY_NAME,FROM_CITY | 하네스·환경 | H2 도구 오류 — 원장 V-06e7dec2 |  | 1 (ACT:SCP0005_DistributionRoute.SaveData:8) |
| WK-SCP0005-0149 | H2 | LT_TYPE / L/T Type | 하네스·환경 | H2 도구 오류 — 원장 V-cf9f292a COLUMN / 원장 V-ce0c227b COLUMN / 원장 V-b6f27092 ASIS / 실측[T-f5ade244]: LT_TYPE: 신규행 편집=true 표시 일치 |  | 1 (ACT:SCP0005_DistributionRoute.SaveData:8) |
| WK-SCP0005-0150 | H2 | LT_TYPE,TRANSPORT_MODE | 하네스·환경 | H2 도구 오류 — 원장 V-b6f27092 |  | 1 (ACT:SCP0005_DistributionRoute.SaveData:8) |
| WK-SCP0005-0151 | H2 | PRIORITY / Priority | 하네스·환경 | H2 도구 오류 — 원장 V-a4b02e55 COLUMN / 원장 V-e43b6ce9 COLUMN / 원장 V-b4651880 ASIS / 원장 V-fa71e89c ASIS / 실측[T-a86cad2c]: PRIORITY: 신규행 편 |  | 7 (R1 숫자셀 범위(cellType) R14/R15 저장응답 색칠(9901) |
| WK-SCP0005-0152 | H2 | PRIORITY,PRIORITY | 하네스·환경 | H2 도구 오류 — 원장 V-fa71e89c |  | 1 (ACT:SCP0005_DistributionRoute.SaveData:8) |
| WK-SCP0005-0153 | H2 | R10 TRK→港/Forwarder 7 '-' | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 R10 TRK→港/Forwarder 7 '-' '`portsDash()` cellEditEnded' 의 H2 31요소: ERROR:19 · PASS:11 · NA:1 |  | 1 (R10 TRK→港/Forwarder 7 '-') |
| WK-SCP0005-0154 | H2 | R11/R12 FROM/TO 셀 더블클릭→도시팝업 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 R11/R12 FROM/TO 셀 더블클릭→도시팝업 '`onFromCellDblClick`/`onToCellDblClick`→`RegionMod' 의 H2 31요소: ERROR:19 · PASS: |  | 1 (R11/R12 FROM/TO 셀 더블클릭→도시팝업) |
| WK-SCP0005-0155 | H2 | R16/R17 클라 검증 색칠 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 R16/R17 클라 검증 색칠 '`validateRows`(전 편집행 누적, iter-2 G4) → `invalidCell' 의 H2 31요소: ERROR:19 · PASS:11 · NA:1 |  | 1 (R16/R17 클라 검증 색칠) |
| WK-SCP0005-0156 | H2 | R18 Insert/Delete | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 R18 Insert/Delete '`GridAction.addRow` / `removeRow(grid, true)`(신규만)' 의 H2 31요소: ERROR:19 · PASS:11 · NA:1 |  | 1 (R18 Insert/Delete) |
| WK-SCP0005-0157 | H2 | R7 조회 databind | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 R7 조회 databind '`useTabProcQuery` o_rc1' 의 H2 31요소: ERROR:19 · PASS:11 · NA:1 |  | 1 (R7 조회 databind) |
| WK-SCP0005-0158 | H2 | SCP0005_DistributionRoute.CreateSpread | 하네스·환경 | H2 도구 오류 — 진입점 집계 — 대조표 SCP0005_DistributionRoute.CreateSpread 의 H2 31요소: ERROR:19 · PASS:11 · NA:1 |  | 5 (ACT:SCP0005_DistributionRoute.CreateSpre) |
| WK-SCP0005-0159 | H2 | SCP0005_DistributionRoute.SetImageCell | 하네스·환경 | H2 도구 오류 — 진입점 집계 — 대조표 SCP0005_DistributionRoute.SetImageCell 의 H2 5요소: ERROR:3 · PASS:2 |  | 4 (ACT:SCP0005_DistributionRoute.SetImageCe) |
| WK-SCP0005-0160 | H2 | TO_CITY | 하네스·환경 | H2 도구 오류 — 원장 V-c099fa4f |  | 1 (ACT:SCP0005_DistributionRoute.CheckValid) |
| WK-SCP0005-0161 | H2 | TO_CITY | 하네스·환경 | H2 도구 오류 — 원장 V-e63ff383 |  | 1 (ACT:SCP0005_DistributionRoute.CheckValid) |
| WK-SCP0005-0162 | H2 | TO_CITY / City | 하네스·환경 | H2 도구 오류 — 원장 V-2c0c4c1d COLUMN / 원장 V-a613e1d5 COLUMN / 원장 V-c099fa4f ASIS / 원장 V-e63ff383 ASIS / 원장 V-bc631885 ASIS / 원장 V-dc54e |  | 6 (ACT:SCP0005_DistributionRoute.CheckValid) |
| WK-SCP0005-0163 | H2 | TO_CITY_NAME / City Name | 하네스·환경 | H2 도구 오류 — 원장 V-706ad28d COLUMN / 원장 V-b8e610ca COLUMN / 원장 V-dc54eed4 ASIS / 실측[T-910b4f21]: TO_CITY_NAME: 신규행 편집=false 표시 일치 |  | 1 (ACT:SCP0005_DistributionRoute.SaveData:8) |
| WK-SCP0005-0164 | H2 | TO_CITY_NAME,TO_CITY | 하네스·환경 | H2 도구 오류 — 원장 V-dc54eed4 |  | 1 (ACT:SCP0005_DistributionRoute.SaveData:8) |
| WK-SCP0005-0165 | H2 | TRANSPORT_MODE / Trans Mode | 하네스·환경 | H2 도구 오류 — 원장 V-8ccd91b6 COLUMN / 원장 V-b6f27092 ASIS / 실측[T-87ff0355]: TRANSPORT_MODE: 기존행 편집=true 표시 일치 · 신규행 편집=true 표시 일치 |  | 1 (ACT:SCP0005_DistributionRoute.SaveData:8) |
| WK-SCP0005-0166 | H2 | siMain.SetBGColor | 하네스·환경 | H2 도구 오류 — 원장 V-c56bdc72 |  | 1 (ACT:SCP0005_DistributionRoute.CheckValid) |
| WK-SCP0005-0167 | H2 | siMain.SetBGColor | 하네스·환경 | H2 도구 오류 — 원장 V-b4651880 |  | 1 (ACT:SCP0005_DistributionRoute.CheckValid) |
| WK-SCP0005-0168 | H5 | COMMON:UC-07 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터 걸린 상태 재조회해도 조회되고 필터도 유지(rebindFilterColumns)' 의 H5 16요소: PASS:15 · ERROR:1 |  | 1 (COMMON:UC-07) |
| WK-SCP0005-0169 | H5 | DAYS / Departure Days | 하네스·환경 | H5 도구 오류 — 실측[T-d786155a]: DAYS 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (R9 TRK/AIR→DAYS 7 'Y') |
| WK-SCP0005-0170 | H5 | DB메타 구동(gridColumns=[]) | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 DB메타 구동(gridColumns=[]) "`staticColumns` admin fetch(`ADMIN_SHEET_NAME`='Di" 의 H5 16요소: PASS:15 · ERROR:1 |  | 1 (DB메타 구동(gridColumns=[])) |
| WK-SCP0005-0171 | H5 | R10 TRK→港/Forwarder 7 '-' | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 R10 TRK→港/Forwarder 7 '-' '`portsDash()` cellEditEnded' 의 H5 16요소: PASS:15 · ERROR:1 |  | 1 (R10 TRK→港/Forwarder 7 '-') |
| WK-SCP0005-0172 | H5 | R11/R12 FROM/TO 셀 더블클릭→도시팝업 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 R11/R12 FROM/TO 셀 더블클릭→도시팝업 '`onFromCellDblClick`/`onToCellDblClick`→`RegionMod' 의 H5 16요소: PASS:15 · ERROR: |  | 1 (R11/R12 FROM/TO 셀 더블클릭→도시팝업) |
| WK-SCP0005-0173 | H5 | R16/R17 클라 검증 색칠 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 R16/R17 클라 검증 색칠 '`validateRows`(전 편집행 누적, iter-2 G4) → `invalidCell' 의 H5 16요소: PASS:15 · ERROR:1 |  | 1 (R16/R17 클라 검증 색칠) |
| WK-SCP0005-0174 | H5 | R18 Insert/Delete | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 R18 Insert/Delete '`GridAction.addRow` / `removeRow(grid, true)`(신규만)' 의 H5 16요소: PASS:15 · ERROR:1 |  | 1 (R18 Insert/Delete) |
| WK-SCP0005-0175 | H5 | R7 조회 databind | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 R7 조회 databind '`useTabProcQuery` o_rc1' 의 H5 16요소: PASS:15 · ERROR:1 |  | 1 (R7 조회 databind) |
| WK-SCP0005-0176 | H5 | SCP0005_DistributionRoute.CreateSpread | 하네스·환경 | H5 도구 오류 — 진입점 집계 — 대조표 SCP0005_DistributionRoute.CreateSpread 의 H5 16요소: PASS:15 · ERROR:1 |  | 5 (ACT:SCP0005_DistributionRoute.CreateSpre) |
| WK-SCP0005-0177 | I1 | SCP0005 화면 | 하네스·환경 | I1 도구 오류 — 원장 V-29c34a39 RULE_SCREEN / 원장 V-38472e83 RULE_SCREEN / 원장 V-cad0bff9 RULE_SCREEN / 원장 V-27f623b5 DEFECT / 원장 V-49e2564 |  | 15 (PRIORITY>=1 (MSG00107) FROM/TO City Name) |
| WK-SCP0005-0178 | D1 | EditButton (SwitchLock 편집모드) | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 EditButton (SwitchLock 편집모드) 'NSCM 상시편집 표준으로 대체(Edit 토글 없음) — 셀별 editLock 판정' 의 D1 8요소: ERROR:5 · NA:2 · PAS |  | 1 (EditButton (SwitchLock 편집모드)) |
| WK-SCP0005-0179 | D1 | FROM_CITY_NAME / City Name | 하네스·환경 | D1 도구 오류 — 원장 V-df2c464d COLUMN / 원장 V-a0234e02 COLUMN / 원장 V-efd885dd COLUMN / 원장 V-a2b3892f COLUMN / 실측[T-174d521f]: 기존행 r0 FROM |  | 3 (ACT:SCP0005_DistributionRoute.EditButton) |
| WK-SCP0005-0180 | D1 | LAST_UPDATE_DATE / Last Update Date | 하네스·환경 | D1 도구 오류 — 원장 V-56bec2fe COLUMN / 원장 V-e47bace2 COLUMN / 원장 V-1afc1aeb COLUMN / 원장 V-ae463842 COLUMN / 실측[T-6e051073]: 기존행 r0 LAST |  | 2 (ACT:SCP0005_DistributionRoute.EditButton) |
| WK-SCP0005-0181 | D1 | LT_SUM / Total L/T | 하네스·환경 | D1 도구 오류 — 원장 V-746e5bbe COLUMN / 원장 V-8da4b077 COLUMN / 원장 V-c7abf566 COLUMN / 원장 V-df790ade COLUMN / 원장 V-d72694b1 COLUMN / 원장 V |  | 4 (R3/R4/R5 편집잠금(ROUTE_ID/CITY_NAME/LT_SUM/) |
| WK-SCP0005-0182 | D1 | R16/R17 클라 검증 색칠 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 R16/R17 클라 검증 색칠 '`validateRows`(전 편집행 누적, iter-2 G4) → `invalidCell' 의 D1 8요소: ERROR:5 · NA:2 · PASS:1 |  | 1 (R16/R17 클라 검증 색칠) |
| WK-SCP0005-0183 | D1 | ROUTE_ID / Route Id | 하네스·환경 | D1 도구 오류 — 원장 V-d98f259a COLUMN / 원장 V-954cbe66 COLUMN / 원장 V-e8602478 COLUMN / 원장 V-c09178ce COLUMN / 원장 V-f069cc0b COLUMN / 원장 V |  | 7 (R3/R4/R5 편집잠금(ROUTE_ID/CITY_NAME/LT_SUM/) |
| WK-SCP0005-0184 | D1 | SCP0005_DistributionRoute.EditButton | 하네스·환경 | D1 도구 오류 — 진입점 집계 — 대조표 SCP0005_DistributionRoute.EditButton 의 D1 6요소: ERROR:5 · PASS:1 |  | 1 (ACT:SCP0005_DistributionRoute.EditButton) |
| WK-SCP0005-0185 | D1 | TO_CITY_NAME / City Name | 하네스·환경 | D1 도구 오류 — 원장 V-0039c48a COLUMN / 원장 V-56c2ac4f COLUMN / 원장 V-5f5baa0d COLUMN / 원장 V-6d214120 COLUMN / 실측[T-2360259a]: 기존행 r0 TO_C |  | 3 (ACT:SCP0005_DistributionRoute.EditButton) |
| WK-SCP0005-0186 | E4 | LT_ARRIVAL_INLAND / Arrival Inland | 하네스·환경 | E4 도구 오류 — 원장 V-3e95d2be ASIS / 실측[T-eea49685]: MSG00209 — spdMainDataModel_Changed 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작  |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0187 | E4 | MSG00209 | 하네스·환경 | E4 도구 오류 — 원장 V-3e95d2be / 실측[T-dba493fd]: MSG00209 — spdMainDataModel_Changed 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오( |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0188 | E4 | MSG00209 | 하네스·환경 | E4 도구 오류 — 원장 V-3e95d2be ASIS / 실측[T-6a512ae5]: MSG00209 — spdMainDataModel_Changed 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작  |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0189 | E4 | MSG00265 | 하네스·환경 | E4 도구 오류 — 원장 V-4a0b6271 / 실측[T-2c4e7c8a]: MSG00265 — btnEaxel_Upload_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(btn |  | 1 (ACT:SCP0005_DistributionRoute.btnEaxel_U) |
| WK-SCP0005-0190 | E4 | MSG00265 | 하네스·환경 | E4 도구 오류 — 원장 V-4a0b6271 ASIS / 실측[T-e19b6757]: MSG00265 — btnEaxel_Upload_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리 |  | 1 (ACT:SCP0005_DistributionRoute.btnEaxel_U) |
| WK-SCP0005-0191 | A6 | PKG_SCP0005.P_SCP0005_GET_COUNTRY_CITY | 하네스·환경 | A6 도구 오류 — 원장 V-dbaedd29 SP / 정렬대조 PASS 분기 키 순서 동일 / 실측[T-f0f809e9]: PKG_SCP0005.P_SCP0005_GET_COUNTRY_CITY: 화면 진입·조회 경로에서 이 SP 가  |  | 7 (ACT:SCP0005_DistributionRoute.FindButton) |
| WK-SCP0005-0192 | A6 | SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID | 하네스·환경 | A6 도구 오류 — 원장 V-f574c4a3 SP / 정렬대조 REVIEW TO-BE 프로시저 배선(PROC_M) 없음 — 대응 프로시저 확인 / 실측[T-336fa068]: SCP0005_GET_DISTRIBUTION_HISTORY |  | 14 (ACT:SCP0005_DistributionRoutePopup.FindB) |
| WK-SCP0005-0193 | A6 | SCP0005_GET_DISTRIBUTION_ROUTEID | 하네스·환경 | A6 도구 오류 — 원장 V-fc7cfdc8 SP / 정렬대조 REVIEW TO-BE 프로시저 배선(PROC_M) 없음 — 대응 프로시저 확인 / 실측[T-2f7778bd]: SCP0005_GET_DISTRIBUTION_ROUTEID |  | 34 (ACT:SCP0005_DistributionRoute.FindButton) |
| WK-SCP0005-0194 | G1 | COMMON:UC-07 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터 걸린 상태 재조회해도 조회되고 필터도 유지(rebindFilterColumns)' 의 G1 8요소: NA:4 · PASS:3 · ERROR:1 |  | 1 (COMMON:UC-07) |
| WK-SCP0005-0195 | G1 | FindButton(Search) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 FindButton(Search) '`hotkeyConfig.search`=handleSearch (hasButton)' 의 G1 8요소: NA:4 · PASS:3 · ERROR:1 |  | 1 (FindButton(Search)) |
| WK-SCP0005-0196 | G1 | FindDataMain 파라미터 6종 'ALL'→'' | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 FindDataMain 파라미터 6종 'ALL'→'' 'store `setFilter()` `orEmpty()`' 의 G1 8요소: NA:4 · PASS:3 · ERROR:1 |  | 1 (FindDataMain 파라미터 6종 'ALL'→'') |
| WK-SCP0005-0197 | G1 | R7 조회 databind | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 R7 조회 databind '`useTabProcQuery` o_rc1' 의 G1 8요소: NA:4 · PASS:3 · ERROR:1 |  | 1 (R7 조회 databind) |
| WK-SCP0005-0198 | G1 | btnEaxel_Upload → ExcelUploadForm2 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 btnEaxel_Upload → ExcelUploadForm2 "customButton 'Excel Upload' → `ExcelUploadModal` →" 의 G1 8요소: NA:4 · PAS |  | 1 (btnEaxel_Upload → ExcelUploadForm2) |
| WK-SCP0005-0199 | G1 | cascade(clbFromCountry→City) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 cascade(clbFromCountry→City) '없음(주석 폐기) — 무cascade' 의 G1 8요소: NA:4 · PASS:3 · ERROR:1 |  | 1 (cascade(clbFromCountry→City)) |
| WK-SCP0005-0200 | G1 | clbTransMode / Trans Mode | 하네스·환경 | G1 도구 오류 — 원장 V-43efa55d SEARCH / E2E smoke cond combo |  | 3 (clbTransMode (UsrCheckedList **다중 체크** —) |
| WK-SCP0005-0201 | X-ROW | SCP0005_DistributionRoute.CheckValid | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 14검사 — ERROR:9 · PASS:3 · NA:2 |  | 39 (ACT:SCP0005_DistributionRoute.CheckValid) |
| WK-SCP0005-0202 | X-ROW | SCP0005_DistributionRoute.CreateSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — PASS:2 · ERROR:2 |  | 1 (ACT:SCP0005_DistributionRoute.CreateSpre) |
| WK-SCP0005-0203 | X-ROW | SCP0005_DistributionRoute.FindDataReceiv | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 8검사 — ERROR:3 · NA:2 · REVIEW:1 · NOPATH:1 · PASS:1 |  | 7 (ACT:SCP0005_DistributionRoute.FindDataRe) |
| WK-SCP0005-0204 | X-ROW | SCP0005_DistributionRoute.GetData_Countr | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — NA:2 · PASS:2 · ERROR:1 |  | 2 (ACT:SCP0005_DistributionRoute.GetData_Co) |
| WK-SCP0005-0205 | X-ROW | SCP0005_DistributionRoute.InitEvent | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NA:1 · PASS:1 · ERROR:1 |  | 1 (ACT:SCP0005_DistributionRoute.InitEvent) |
| WK-SCP0005-0206 | X-ROW | SCP0005_DistributionRoute.InitSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 29검사 — PASS:28 · ERROR:1 |  | 1 (ACT:SCP0005_DistributionRoute.InitSpread) |
| WK-SCP0005-0207 | X-ROW | SCP0005_DistributionRoute.InsertRow | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 18검사 — PASS:12 · ERROR:6 |  | 13 (ACT:SCP0005_DistributionRoute.InsertRow ) |
| WK-SCP0005-0208 | X-ROW | SCP0005_DistributionRoute.SetImageCell | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 36검사 — PASS:16 · ERROR:10 · NA:10 |  | 4 (ACT:SCP0005_DistributionRoute.SetImageCe) |
| WK-SCP0005-0209 | X-ROW | SCP0005_DistributionRoute.btnEaxel_Uploa | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 7검사 — ERROR:7 |  | 4 (ACT:SCP0005_DistributionRoute.btnEaxel_U) |
| WK-SCP0005-0210 | X-ROW | SCP0005_DistributionRoute.btnFromSrch_Cl | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 15검사 — ERROR:9 · NOPATH:2 · PASS:2 · WARN:1 · NOT_RUN:1 |  | 3 (ACT:SCP0005_DistributionRoute.btnFromSrc) |
| WK-SCP0005-0211 | X-ROW | SCP0005_DistributionRoute.btnToSrch_Clic | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 15검사 — ERROR:9 · NOPATH:2 · PASS:2 · NOT_RUN:1 · WARN:1 |  | 3 (ACT:SCP0005_DistributionRoute.btnToSrch_) |
| WK-SCP0005-0212 | X-ROW | SCP0005_DistributionRoute.spdMainDataMod | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 119검사 — PASS:58 · ERROR:55 · NA:6 |  | 21 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0213 | X-ROW | SCP0005_DistributionRoute.spdMain_CellDo | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 44검사 — ERROR:13 · PASS:12 · NA:12 · NOPATH:6 · NOT_RUN:1 |  | 11 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0214 | X-ROW | SCP0005_DistributionRoutePopup..ctor | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NA:1 · ERROR:1 |  | 2 (ACT:SCP0005_DistributionRoutePopup..ctor) |
| WK-SCP0005-0215 | X-ROW | SCP0005_DistributionRoutePopup.CreateSpr | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 6 (ACT:SCP0005_DistributionRoutePopup.Creat) |
| WK-SCP0005-0216 | X-ROW | SCP0005_DistributionRoutePopup.DefinePro | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — PASS:1 · ERROR:1 |  | 2 (ACT:SCP0005_DistributionRoutePopup.Defin) |
| WK-SCP0005-0217 | X-ROW | SCP0005_DistributionRoutePopup.Dispose | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — PASS:1 · ERROR:1 |  | 3 (ACT:SCP0005_DistributionRoutePopup.Dispo) |
| WK-SCP0005-0218 | X-ROW | SCP0005_DistributionRoutePopup.FindButto | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — ERROR:3 · REVIEW:1 |  | 2 (ACT:SCP0005_DistributionRoutePopup.FindB) |
| WK-SCP0005-0219 | X-ROW | SCP0005_DistributionRoutePopup.FindData | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — ERROR:3 · REVIEW:1 · NOPATH:1 · PASS:1 |  | 12 (ACT:SCP0005_DistributionRoutePopup.FindD) |
| WK-SCP0005-0220 | X-ROW | SCP0005_DistributionRoutePopup.Form_Load | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — PASS:1 · ERROR:1 |  | 5 (ACT:SCP0005_DistributionRoutePopup.Form_) |
| WK-SCP0005-0221 | X-ROW | SCP0005_DistributionRoutePopup.InitSprea | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 30검사 — PASS:28 · ERROR:2 |  | 12 (ACT:SCP0005_DistributionRoutePopup.InitS) |
| WK-SCP0005-0222 | G5 | ProgressForm | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 ProgressForm 'react-query isFetching(별도 팝업 불요)' 의 G5 22요소: NA:8 · NOPATH:7 · ERROR:7 |  | 1 (ProgressForm) |
| WK-SCP0005-0223 | G5 | R11/R12 FROM/TO 셀 더블클릭→도시팝업 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 R11/R12 FROM/TO 셀 더블클릭→도시팝업 '`onFromCellDblClick`/`onToCellDblClick`→`RegionMod' 의 G5 22요소: NA:8 · NOPATH:7  |  | 1 (R11/R12 FROM/TO 셀 더블클릭→도시팝업) |
| WK-SCP0005-0224 | G5 | btnFromSrch | 하네스·환경 | G5 도구 오류 — 원장 V-2e28bbf0 ASIS / 원장 V-c6dd7839 ASIS |  | 2 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0225 | G5 | btnToSrch | 하네스·환경 | G5 도구 오류 — 원장 V-b16a17a1 ASIS / 원장 V-595a9098 ASIS |  | 2 (txtToCountry/txtToCity + btnToSrch ACT:S) |
| WK-SCP0005-0226 | G5 | frm.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-a6bb7234 |  | 1 (ACT:SCP0005_DistributionRoute.btnEaxel_U) |
| WK-SCP0005-0227 | G5 | popCity.Form_Load(true, sCountry, sCity) | 하네스·환경 | G5 도구 오류 — 원장 V-2e28bbf0 |  | 1 (ACT:SCP0005_DistributionRoute.btnFromSrc) |
| WK-SCP0005-0228 | G5 | popCity.Form_Load(true, sCountry, sCity) | 하네스·환경 | G5 도구 오류 — 원장 V-b16a17a1 |  | 1 (ACT:SCP0005_DistributionRoute.btnToSrch_) |
| WK-SCP0005-0229 | G5 | popCity.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-c6dd7839 |  | 1 (ACT:SCP0005_DistributionRoute.btnFromSrc) |
| WK-SCP0005-0230 | G5 | popCity.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-595a9098 |  | 1 (ACT:SCP0005_DistributionRoute.btnToSrch_) |
| WK-SCP0005-0231 | H6 | ProgressForm | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 ProgressForm 'react-query isFetching(별도 팝업 불요)' 의 H6 22요소: ERROR:9 · PASS:6 · NOPATH:3 · NOT_RUN:2 · WARN:2 |  | 1 (ProgressForm) |
| WK-SCP0005-0232 | H6 | R11/R12 FROM/TO 셀 더블클릭→도시팝업 | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 R11/R12 FROM/TO 셀 더블클릭→도시팝업 '`onFromCellDblClick`/`onToCellDblClick`→`RegionMod' 의 H6 22요소: ERROR:9 · PASS:6 |  | 1 (R11/R12 FROM/TO 셀 더블클릭→도시팝업) |
| WK-SCP0005-0233 | H6 | ROUTE_ID / Route Id | 하네스·환경 | H6 도구 오류 — 원장 V-0e9099ba ASIS / 원장 V-4cfc72f5 ASIS |  | 9 (R8 ROUTE_ID ACT:SCP0005_DistributionRout) |
| WK-SCP0005-0234 | H6 | SCP0005_DistributionRoute.spdMain_CellDo | 하네스·환경 | H6 도구 오류 — 원장 V-0e9099ba ASIS / 원장 V-4cfc72f5 ASIS / 원장 V-cca901cb ASIS / 원장 V-c9dc5aa7 ASIS |  | 3 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0235 | H6 | SCP0005_DistributionRoutePopup | 하네스·환경 | H6 도구 오류 — 원장 V-0e9099ba ASIS |  | 2 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0236 | H6 | btnFromSrch | 하네스·환경 | H6 도구 오류 — 원장 V-718e1a16 ASIS / 원장 V-7cdbda05 ASIS |  | 2 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0237 | H6 | btnToSrch | 하네스·환경 | H6 도구 오류 — 원장 V-616b4d31 ASIS / 원장 V-ac0769f6 ASIS |  | 2 (txtToCountry/txtToCity + btnToSrch ACT:S) |
| WK-SCP0005-0238 | H6 | frm.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-e14533b1 |  | 1 (ACT:SCP0005_DistributionRoute.btnEaxel_U) |
| WK-SCP0005-0239 | H6 | new GSCM.SCM.PopUp.UIL.SCP0005_Distribut | 하네스·환경 | H6 도구 오류 — 원장 V-0e9099ba |  | 1 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0240 | H6 | popCity.Form_Load(true, sCountry, sCity) | 하네스·환경 | H6 도구 오류 — 원장 V-718e1a16 |  | 1 (ACT:SCP0005_DistributionRoute.btnFromSrc) |
| WK-SCP0005-0241 | H6 | popCity.Form_Load(true, sCountry, sCity) | 하네스·환경 | H6 도구 오류 — 원장 V-616b4d31 |  | 1 (ACT:SCP0005_DistributionRoute.btnToSrch_) |
| WK-SCP0005-0242 | H6 | popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-4cfc72f5 |  | 1 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0243 | M3 | SCP0005_DistributionRoutePopup | 하네스·환경 | M3 도구 오류 — 원장 V-a46588cb ASIS / 실측[T-6d14c72c]: [검사기 미검증] ROUTE_ID 더블클릭 → 팝업 열림 감지 실패 |  | 8 (ACT:SCP0005_DistributionRoutePopup..ctor) |
| WK-SCP0005-0244 | M3 | new GSCM.SCM.PopUp.UIL.SCP0005_Distribut | 하네스·환경 | M3 도구 오류 — 원장 V-a46588cb |  | 1 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0245 | M4 | SCP0005_DistributionRoute.spdMain_CellDo | 하네스·환경 | M4 도구 오류 — 진입점 집계 — 대조표 SCP0005_DistributionRoute.spdMain_CellDoubleClick 의 M4 8요소: PASS:5 · NA:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0246 | M4 | txtFromCity / From City | 하네스·환경 | M4 도구 오류 — 실측[T-47ab9353]: r0 ROUTE_ID 더블클릭 → 팝업 열림 감지 실패(검사기 미검증) |  | 5 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0247 | M4 | txtFromCountry / From Country | 하네스·환경 | M4 도구 오류 — 실측[T-3d44d32d]: r0 ROUTE_ID 더블클릭 → 팝업 열림 감지 실패(검사기 미검증) |  | 5 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0248 | M4 | txtToCity / To City | 하네스·환경 | M4 도구 오류 — 실측[T-26aaaaf4]: r0 ROUTE_ID 더블클릭 → 팝업 열림 감지 실패(검사기 미검증) |  | 5 (txtToCountry/txtToCity + btnToSrch ACT:S) |
| WK-SCP0005-0249 | M4 | txtToCountry / To Country | 하네스·환경 | M4 도구 오류 — 실측[T-ef2618be]: r0 ROUTE_ID 더블클릭 → 팝업 열림 감지 실패(검사기 미검증) |  | 5 (txtToCountry/txtToCity + btnToSrch ACT:S) |
