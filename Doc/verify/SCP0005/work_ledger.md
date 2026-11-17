# 작업 원장 — SCP0005 · 2026-11-14 07:33

> 검사 인스턴스 565건 중 PASS·NA 330건 외 **235건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W1 | 기능 구현 | 1 | 대조표 구현 + 위치 기입 → W8 실행 |
| W3 | 동작 수정 | 4 | 재판정 PASS |
| W5 | 검사기 연결 | 17 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 2 | 실행 → PASS |
| W7 | 기대값 확정 | 21 | 기대 확정 → PASS/FAIL |
| W8 | 구현 후 검증 | 3 | 선행 W1 → PASS |
| W9 | 도구 오류 | 187 | 원인 해소 → 재판정 |

- 담당: 하네스·환경 187 · 사람 판정 / AS-IS 원문 확인 → 재판정 19 · 하네스 17 · 선행 W1 완료 후 E2E 3 · 화면 FE 2 · DB 객체 2 · E2E 2 · 대조표 2 · FE 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 6건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| C3 | CASCADE |  |  |  |  |  |  |  |  | 28 | 연쇄 자동 채움 |
| C2 | CASCADE |  |  |  |  |  |  |  |  | 25 | 그리드 셀 cascade 후보 |
| X-ROW | GEN |  |  | 1 |  |  |  |  |  | 23 | 대조표 행이 서술한 동작을 화면에서 재현 |
| H6 | POPUP |  |  |  |  | 3 | 2 | 1 |  | 12 | 팝업 표준·열림 |
| C6 | CASCADE |  |  |  |  |  |  |  |  | 17 | 무변경 편집 종료 시 연쇄 미발동 |
| G5 | POPUP |  |  |  |  | 7 |  |  |  | 9 | 팝업 조건 연동(인자) |
| A1 | GEN |  |  |  |  |  |  | 13 | 1 |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| H2 | DESIGN |  |  |  |  |  |  |  |  | 11 | 배경·글자색 규칙 |
| G4 | DESIGN |  |  |  |  | 3 |  |  | 1 | 6 | 조회조건 표시·라벨·활성 |
| H5 | DESIGN |  |  |  |  |  |  |  |  | 9 | 라벨 명칭 |
| G1 | GEN |  |  |  |  |  |  |  | 1 | 7 | 조회조건 값 변경 → 조회 인자·결과 반영 |
| A5 | DESIGN |  |  |  |  |  |  |  |  | 8 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| E4 | EDIT |  |  | 2 |  |  |  |  |  | 5 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| D1 | EDIT |  |  |  |  |  |  |  |  | 7 | 컬럼 편집 가능 여부(신규행·기존행) |
| M4 | POPUP |  |  |  |  |  |  | 1 |  | 5 | 팝업 선택값 반영 |
| E3 | EDIT |  |  |  |  |  |  | 4 |  |  | 필수 입력 검증 |
| F4 | DB |  |  |  |  |  |  |  |  | 4 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| A6 | GEN |  |  |  |  |  |  |  |  | 4 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| DB-SYN | DB |  |  |  |  | 3 |  |  |  |  | BE 계정 시노님·권한·대상 객체 |
| X-REASON | DESIGN |  |  |  |  |  |  | 2 |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| M3 | POPUP |  |  |  |  |  |  |  |  | 2 | 팝업 내부 기능(조회·CRUD) · 팝업 목록 행수(조회조건 변경 후 포함) |
| X-NOTIMPL | GEN | 1 |  |  |  |  |  |  |  |  | 대조표 상태 미구현 = 구현 대상(FAIL) |
| F2 | CRUD |  |  | 1 |  |  |  |  |  |  | 1회 저장(변경 감지) |
| G03-WIRE | GEN |  |  |  |  | 1 |  |  |  |  | AS-IS 이벤트가 TO-BE 대조표·핸들러로 전부 연결 |
| K4 | COMMON |  |  |  |  |  |  |  |  | 1 | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 DB 반영(마커 행) |
| F6 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 값 보존 |
| I1 | DESIGN |  |  |  |  |  |  |  |  | 1 | LBL/MSG 언어별 등록 |
| SC1 | DESIGN |  |  |  |  |  |  |  |  | 1 | 조회조건 순서 = 기준표 |

## W1 기능 구현 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0005-0001 | X-NOTIMPL | dead 콤보(Division/Site/BodType/dtFromCoun | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — dead 콤보(Division/Site/BodType/dtFromCountry/dtToCountry/dtYesOrNo) 미구현(신설 금지) design 02 §2.4 |  | 1 (dead 콤보(Division/Site/BodType/dtFromCoun) |

## W3 동작 수정 (4)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0005-0002 | F2 | SCP0005 화면 | 화면 FE(범위 밖(가이드만)) | F2 FAIL 수정 — SCP0005 화면: 원장 V-c3ce3016 RULE_SCREEN / 원장 V-3aecb21a RULE_SCREEN / 원장 V-5b084571 RULE_SCREEN / 원장 V-91202d1b GENERAL |  | 195 (R14/R15 저장응답 색칠(99010/99020) SaveButton ) |
| WK-SCP0005-0003 | E4 | MSG00043 | DB 객체(PKG/SP)(적용 예정) | E4 FAIL 수정 — MSG00043: 원장 V-3134fc3e / 실측[T-ece1c98b]: MSG00043: AS-IS 는 저장 실패 응답의 오류코드(99010 중복·99020/99030/99040 검증 실패)에 따라 문제가  |  | 1 (ACT:SCP0005_DistributionRoute.SaveData:8) |
| WK-SCP0005-0004 | E4 | MSG00043 | DB 객체(PKG/SP)(적용 예정) | E4 FAIL 수정 — MSG00043: 원장 V-3134fc3e ASIS / 실측[T-f048d4a9]: MSG00043: AS-IS 는 저장 실패 응답의 오류코드(99010 중복·99020/99030/99040 검증 실패)에 따라 |  | 1 (ACT:SCP0005_DistributionRoute.SaveData:8) |
| WK-SCP0005-0005 | X-ROW | SCP0005_DistributionRoute.SaveData | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0005_DistributionRoute.SaveData: 진입점 집계 33검사 — PASS:18 · NA:7 · ERROR:4 · FAIL:3 · NOPATH:1 (FX-SCP0005-057) |  | 3 (ACT:SCP0005_DistributionRoute.SaveData:6) |

## W5 검사기 연결 (17)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0005-0006 | DB-SYN | SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID | 없음(PROC_M 대응 없음) | 3 (ACT:SCP0005_DistributionRoutePopup.FindD) |
| WK-SCP0005-0007 | DB-SYN | SCP0005_GET_DISTRIBUTION_ROUTEID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0005_GET_DISTRIBUTION_ROUTEID | 없음(PROC_M 대응 없음) | 3 (ACT:SCP0005_DistributionRoute.FindDataRe) |
| WK-SCP0005-0008 | DB-SYN | SCP0005_SAVE_DISTRIBUTION_ROUTE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0005_SAVE_DISTRIBUTION_ROUTE | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0005_DistributionRoute.SaveData:7) |
| WK-SCP0005-0009 | G4 | btnEaxel | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnEaxel | 없음 | 2 (ACT:SCP0005_DistributionRoute.InitEvent ) |
| WK-SCP0005-0010 | G4 | btnFromSrch | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnFromSrch | 없음 | 1 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0011 | G4 | btnToSrch | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 G4(smoke 화면 열림(labels)·_verify) → 대상 BTN btnToSrch | 없음 | 1 (txtToCountry/txtToCity + btnToSrch) |
| WK-SCP0005-0012 | G03-WIRE | SCP0005 화면 | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G03-WIRE(check.js G03) → 대상 SCREEN SCP0005 화면 | 판단불가(대상 단위 SCREEN) | 15 (ACT:SCP0005_DistributionRoute..ctor ACT:) |
| WK-SCP0005-0013 | G5 | FROM_CITY_NAME / City Name | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL FROM_CITY_NAME / City Name | 있음(SHEET_COLUMNS) | 4 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0014 | G5 | TO_CITY / City | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL TO_CITY / City | 있음(SHEET_COLUMNS) | 5 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0015 | G5 | TO_CITY_NAME / City Name | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL TO_CITY_NAME / City Name | 있음(SHEET_COLUMNS) | 3 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0016 | G5 | txtFromCity / From City | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COND txtFromCity / From City | 있음(FE 소스) | 5 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0017 | G5 | txtFromCountry / From Country | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COND txtFromCountry / From Country | 있음(FE 소스) | 5 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0018 | G5 | txtToCity / To City | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COND txtToCity / To City | 있음(FE 소스) | 5 (txtToCountry/txtToCity + btnToSrch ACT:S) |
| WK-SCP0005-0019 | G5 | txtToCountry / To Country | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COND txtToCountry / To Country | 있음(FE 소스) | 5 (txtToCountry/txtToCity + btnToSrch ACT:S) |
| WK-SCP0005-0020 | H6 | FROM_CITY_NAME / City Name | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL FROM_CITY_NAME / City Name | 있음(SHEET_COLUMNS) | 4 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0021 | H6 | TO_CITY / City | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL TO_CITY / City | 있음(SHEET_COLUMNS) | 5 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0022 | H6 | TO_CITY_NAME / City Name | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL TO_CITY_NAME / City Name | 있음(SHEET_COLUMNS) | 3 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |

## W6 검증 실행 (2)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0005-0023 | H6 | txtFromCountry / From Country | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtFromCountry / From Country · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 5 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0024 | H6 | txtToCountry / To Country | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtToCountry / To Country · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 5 (txtToCountry/txtToCity + btnToSrch ACT:S) |

## W7 기대값 확정 (21)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0005-0025 | X-REASON | COMMON:UC-03 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-03 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 데이터 Reset 후 재조회  Measure 0(정적 39컬럼, SHEET_MEASURE 실측 0). Colum |  | 1 (COMMON:UC-03) |
| WK-SCP0005-0026 | X-REASON | COMMON:UC-06 | 대조표(사유 열: 룰·지시·AS-IS 원문·이동 위치) | 제외·해당없음 사유 근거 보강 — COMMON:UC-06 Key-in 조회조건 콤마 다중입력 전건 조회  TransMode 는 GET SP UF_FX_STRING_SPLIT 콤마 다중(design 03 §4.1) 지원. From/To |  | 1 (COMMON:UC-06) |
| WK-SCP0005-0027 | E3 | DAYS / Departure Days | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — DAYS / Departure Days: AS-IS 필수 표시(grid_rule 라벨 *) 정보 없음 — TO-BE 필수=False |  | 1 (DAYS 최소 1 (MSG00223)) |
| WK-SCP0005-0028 | E3 | R16/R17 클라 검증 색칠 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — R16/R17 클라 검증 색칠: 행 집계 — 대조표 R16/R17 클라 검증 색칠 '`validateRows`(전 편집행 누적, iter-2 G4) → `invalidCell' 의 E3 4요소: PASS:3 ·  |  | 1 (R16/R17 클라 검증 색칠) |
| WK-SCP0005-0029 | E3 | SaveButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — SaveButton: 행 집계 — 대조표 SaveButton '`hotkeyConfig.save`=handleSave (validate→saveWithV' 의 E3 4요소: PASS:3 · REVIEW:1 · F |  | 1 (SaveButton) |
| WK-SCP0005-0030 | E3 | 메타 필수(INPUT_TP_CD=M/IM) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — 메타 필수(INPUT_TP_CD=M/IM): 행 집계 — 대조표 메타 필수(INPUT_TP_CD=M/IM) '`useSaveWithValidation`' 의 E3 4요소: PASS:3 · REVIEW:1 · FA |  | 1 (메타 필수(INPUT_TP_CD=M/IM)) |
| WK-SCP0005-0031 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — 대조표 COMMON:UC-07 '필터 걸린 상태 재조회해도 조회되고 필터도 유지(rebindFilterColumns)' 의 A1 4요소: REVIEW:3 · PASS:1 ·  |  | 1 (COMMON:UC-07) |
| WK-SCP0005-0032 | A1 | FindButton(Search) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindButton(Search): 행 집계 — 대조표 FindButton(Search) '`hotkeyConfig.search`=handleSearch (hasButton)' 의 A1 4요소: REVIEW:3  |  | 1 (FindButton(Search)) |
| WK-SCP0005-0033 | A1 | FindDataMain 파라미터 6종 'ALL'→'' | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindDataMain 파라미터 6종 'ALL'→'': 행 집계 — 대조표 FindDataMain 파라미터 6종 'ALL'→'' 'store `setFilter()` `orEmpty()`' 의 A1 4요소: RE |  | 1 (FindDataMain 파라미터 6종 'ALL'→'') |
| WK-SCP0005-0034 | A1 | PKG_SCP0005.P_SCP0005_GET_COUNTRY_CITY | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — PKG_SCP0005.P_SCP0005_GET_COUNTRY_CITY: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0005/SCP0005_GET_COUNTRY_CITY |  | 7 (ACT:SCP0005_DistributionRoute.FindButton) |
| WK-SCP0005-0035 | A1 | R7 조회 databind | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R7 조회 databind: 행 집계 — 대조표 R7 조회 databind '`useTabProcQuery` o_rc1' 의 A1 4요소: REVIEW:3 · PASS:1 · FAIL 요소: PKG_SCP0005 |  | 1 (R7 조회 databind) |
| WK-SCP0005-0036 | A1 | SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID: 골든 비교 케이스 없음(SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID — 팝업·보조 SP 는 golden_ca |  | 14 (ACT:SCP0005_DistributionRoutePopup.FindB) |
| WK-SCP0005-0037 | A1 | SCP0005_GET_DISTRIBUTION_ROUTEID | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0005_GET_DISTRIBUTION_ROUTEID: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0005/SCP0005_GET_DISTRIBUTION_ROUTE |  | 34 (ACT:SCP0005_DistributionRoute.FindButton) |
| WK-SCP0005-0038 | A1 | btnEaxel_Upload → ExcelUploadForm2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — btnEaxel_Upload → ExcelUploadForm2: 행 집계 — 대조표 btnEaxel_Upload → ExcelUploadForm2 "customButton 'Excel Upload' → `Exce |  | 1 (btnEaxel_Upload → ExcelUploadForm2) |
| WK-SCP0005-0039 | A1 | cascade(clbFromCountry→City) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cascade(clbFromCountry→City): 행 집계 — 대조표 cascade(clbFromCountry→City) '없음(주석 폐기) — 무cascade' 의 A1 4요소: REVIEW:3 · PASS |  | 1 (cascade(clbFromCountry→City)) |
| WK-SCP0005-0040 | A1 | cboValidYN (UsrCombo) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboValidYN (UsrCombo): 행 집계 — 대조표 cboValidYN (UsrCombo) 'Form `CustomDropdown` 정적 ALL/Y/N (`VALID_OPTIONS`)' 의 A1 4요소: |  | 1 (cboValidYN (UsrCombo)) |
| WK-SCP0005-0041 | A1 | clbTransMode (UsrCheckedList **다중 체크** — | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbTransMode (UsrCheckedList **다중 체크** — Designer : 행 집계 — 대조표 clbTransMode (UsrCheckedList **다중 체크** — Designer ItemS |  | 1 (clbTransMode (UsrCheckedList **다중 체크** —) |
| WK-SCP0005-0042 | A1 | txtFromCountry/txtFromCity + btnFromSrch | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — txtFromCountry/txtFromCity + btnFromSrch: 행 집계 — 대조표 txtFromCountry/txtFromCity + btnFromSrch 'Form `InputField` 2 + 돋 |  | 1 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0043 | A1 | txtToCountry/txtToCity + btnToSrch | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — txtToCountry/txtToCity + btnToSrch: 행 집계 — 대조표 txtToCountry/txtToCity + btnToSrch 'Form `InputField` 2 + 돋보기 → `Region |  | 1 (txtToCountry/txtToCity + btnToSrch) |
| WK-SCP0005-0044 | H6 | txtToCity / To City | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — txtToCity / To City: E2E smoke cond popup |  | 5 (txtToCountry/txtToCity + btnToSrch ACT:S) |
| WK-SCP0005-0045 | M4 | SCP0005_DistributionRoutePopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0005_DistributionRoutePopup: 검증 엔진이 실행됐으나 이 대상(POPUP SCP0005_DistributionRoutePopup)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확 |  | 2 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |

## W8 구현 후 검증 (3)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0005-0046 | G4 | dead 콤보(Division/Site/BodType/dtFromCoun | 선행 W1 완료 후 E2E | G4 — 대조표 미구현 행 dead 콤보(Division/Site/BodType/dtFromCountry/dtToCountry/dtYe 구현 후 검증 · 대상 dead 콤보(Division/Site/BodType/dtFromCount |  | 1 (dead 콤보(Division/Site/BodType/dtFromCoun) |
| WK-SCP0005-0047 | A1 | dead 콤보(Division/Site/BodType/dtFromCoun | 선행 W1 완료 후 E2E | A1 — 대조표 미구현 행 dead 콤보(Division/Site/BodType/dtFromCountry/dtToCountry/dtYe 구현 후 검증 · 대상 dead 콤보(Division/Site/BodType/dtFromCount |  | 1 (dead 콤보(Division/Site/BodType/dtFromCoun) |
| WK-SCP0005-0048 | G1 | dead 콤보(Division/Site/BodType/dtFromCoun | 선행 W1 완료 후 E2E | G1 — 대조표 미구현 행 dead 콤보(Division/Site/BodType/dtFromCountry/dtToCountry/dtYe 구현 후 검증 · 대상 dead 콤보(Division/Site/BodType/dtFromCount |  | 1 (dead 콤보(Division/Site/BodType/dtFromCoun) |

## W9 도구 오류 (187)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0005-0049 | C2 | A_COUNTRY / Country | 하네스·환경 | C2 도구 오류 — 실측[T-6e161066]: A_COUNTRY 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0050 | C2 | A_PORT_CODE / Port Code | 하네스·환경 | C2 도구 오류 — 실측[T-6a6f8160]: A_PORT_CODE 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0051 | C2 | A_PORT_NAME / Port | 하네스·환경 | C2 도구 오류 — 실측[T-83feba7d]: A_PORT_NAME 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0052 | C2 | DAYS / Departure Days | 하네스·환경 | C2 도구 오류 — 실측[T-c7a43f16]: DAYS 연쇄 원천 해석 불가 — AS-IS  — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] 검 |  | 1 (R9 TRK/AIR→DAYS 7 'Y') |
| WK-SCP0005-0053 | C2 | DAYS_FRI / Fri | 하네스·환경 | C2 도구 오류 — 실측[T-bd0af4bd]: TRANSPORT_MODE='AIR' → DAYS_FRI 후보 2건 · TRANSPORT_MODE='FERRY' → DAYS_FRI 후보 2건 · TRANSPORT_MODE='TRUCK |  | 2 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0054 | C2 | DAYS_MON / Mon | 하네스·환경 | C2 도구 오류 — 실측[T-f2ca4bd1]: TRANSPORT_MODE='AIR' → DAYS_MON 후보 2건 · TRANSPORT_MODE='FERRY' → DAYS_MON 후보 2건 · TRANSPORT_MODE='TRUCK |  | 3 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0055 | C2 | DAYS_SAT / Sat | 하네스·환경 | C2 도구 오류 — 실측[T-840a1fc6]: TRANSPORT_MODE='AIR' → DAYS_SAT 후보 2건 · TRANSPORT_MODE='FERRY' → DAYS_SAT 후보 2건 · TRANSPORT_MODE='TRUCK |  | 2 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0056 | C2 | DAYS_SUN / Sun | 하네스·환경 | C2 도구 오류 — 실측[T-b03141a1]: TRANSPORT_MODE='AIR' → DAYS_SUN 후보 2건 · TRANSPORT_MODE='FERRY' → DAYS_SUN 후보 2건 · TRANSPORT_MODE='TRUCK |  | 2 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0057 | C2 | DAYS_THU / Thu | 하네스·환경 | C2 도구 오류 — 실측[T-ea99683c]: TRANSPORT_MODE='AIR' → DAYS_THU 후보 2건 · TRANSPORT_MODE='FERRY' → DAYS_THU 후보 2건 · TRANSPORT_MODE='TRUCK |  | 2 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0058 | C2 | DAYS_TUE / Tue | 하네스·환경 | C2 도구 오류 — 실측[T-9e2ec614]: TRANSPORT_MODE='AIR' → DAYS_TUE 후보 2건 · TRANSPORT_MODE='FERRY' → DAYS_TUE 후보 2건 · TRANSPORT_MODE='TRUCK |  | 3 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0059 | C2 | DAYS_WED / Wed | 하네스·환경 | C2 도구 오류 — 실측[T-58285076]: TRANSPORT_MODE='AIR' → DAYS_WED 후보 2건 · TRANSPORT_MODE='FERRY' → DAYS_WED 후보 2건 · TRANSPORT_MODE='TRUCK |  | 2 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0060 | C2 | D_COUNTRY / Country | 하네스·환경 | C2 도구 오류 — 실측[T-d11b8eec]: D_COUNTRY 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 2 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0061 | C2 | D_PORT_CODE / Port Code | 하네스·환경 | C2 도구 오류 — 실측[T-87cfd2b2]: D_PORT_CODE 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0062 | C2 | D_PORT_NAME / Port | 하네스·환경 | C2 도구 오류 — 실측[T-e44d0b2b]: D_PORT_NAME 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0063 | C2 | LT_ARRIVAL_INLAND / Arrival Inland | 하네스·환경 | C2 도구 오류 — 실측[T-31aa93b0]: LT_ARRIVAL_INLAND 연쇄 원천 해석 불가 — AS-IS spdMainDataModel_Changed:983 siMain.GetColumnIndex(DefColumns.LT_ |  | 58 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0064 | C2 | LT_DEPARTURE_INLAND / Departure Inland | 하네스·환경 | C2 도구 오류 — 실측[T-de53b6fd]: LT_DEPARTURE_INLAND 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 4 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0065 | C2 | LT_LAY_OFF_CLEARANCE / Lay Off/Customs C | 하네스·환경 | C2 도구 오류 — 실측[T-6feb4248]: LT_LAY_OFF_CLEARANCE 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 4 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0066 | C2 | LT_SUM / Total L/T | 하네스·환경 | C2 도구 오류 — 실측[T-765c437b]: LT_SUM 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 3 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0067 | C2 | LT_VOYAGE / Voyage | 하네스·환경 | C2 도구 오류 — 실측[T-23ec1123]: LT_VOYAGE 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 4 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0068 | C2 | LT_WAIT_SHIPPING / Waiting For Shipping | 하네스·환경 | C2 도구 오류 — 실측[T-46b9927d]: LT_WAIT_SHIPPING 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 4 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0069 | C2 | PRIORITY / Priority | 하네스·환경 | C2 도구 오류 — 실측[T-6e75e40a]: PRIORITY 연쇄 원천 해석 불가 — AS-IS  — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검 |  | 1 (R1 숫자셀 범위(cellType)) |
| WK-SCP0005-0070 | C2 | R10 TRK→港/Forwarder 7 '-' | 하네스·환경 | C2 도구 오류 — 행 집계 — 대조표 R10 TRK→港/Forwarder 7 '-' '`portsDash()` cellEditEnded' 의 C2 25요소: ERROR:23 · NA:2 |  | 1 (R10 TRK→港/Forwarder 7 '-') |
| WK-SCP0005-0071 | C2 | SCP0005_DistributionRoute.spdMainDataMod | 하네스·환경 | C2 도구 오류 — 진입점 집계 — 대조표 SCP0005_DistributionRoute.spdMainDataModel_Changed 의 C2 23요소: ERROR:21 · NA:2 |  | 10 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0072 | C2 | SHIPPING_COMPANY / Forwarder | 하네스·환경 | C2 도구 오류 — 실측[T-745157a9]: SHIPPING_COMPANY 콤보(dataMap) 아님 — 후보 변화 비교 불가(값 채움은 C3) → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0073 | C2 | TRANSPORT_MODE / Trans Mode | 하네스·환경 | C2 도구 오류 — 실측[T-32b3d098]: TRANSPORT_MODE 연쇄 원천 해석 불가 — AS-IS spdMainDataModel_Changed:1040 siMain.GetColumnIndex(DefColumns.TRANS |  | 3 (ACT:SCP0005_DistributionRoute.spdMainDat) |
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
| WK-SCP0005-0084 | C3 | PRIORITY / Priority | 하네스·환경 | C3 도구 오류 — 실측[T-cba30dde]: PRIORITY 연쇄 원천 컬럼 해석 불가 — AS-IS  → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (R1 숫자셀 범위(cellType)) |
| WK-SCP0005-0085 | C3 | R10 TRK→港/Forwarder 7 '-' | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 R10 TRK→港/Forwarder 7 '-' '`portsDash()` cellEditEnded' 의 C3 52요소: PASS:29 · ERROR:23 |  | 1 (R10 TRK→港/Forwarder 7 '-') |
| WK-SCP0005-0086 | C3 | ROUTE_ID / Route Id | 하네스·환경 | C3 도구 오류 — 실측[T-79ecb025]: ROUTE_ID 연쇄 원천 컬럼 해석 불가 — AS-IS  → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 4 (ACT:SCP0005_DistributionRoute.SetSpreadC) |
| WK-SCP0005-0087 | C3 | SCP0005_DistributionRoute.SetCityCode | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0005_DistributionRoute.SetCityCode 의 C3 6요소: ERROR:6 |  | 4 (ACT:SCP0005_DistributionRoute.SetCityCod) |
| WK-SCP0005-0088 | C3 | SCP0005_DistributionRoute.SetImageCell | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0005_DistributionRoute.SetImageCell 의 C3 5요소: ERROR:5 |  | 4 (ACT:SCP0005_DistributionRoute.SetImageCe) |
| WK-SCP0005-0089 | C3 | SCP0005_DistributionRoute.SetSpreadColum | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0005_DistributionRoute.SetSpreadColumn 의 C3 1요소: ERROR:1 |  | 9 (ACT:SCP0005_DistributionRoute.SetSpreadC) |
| WK-SCP0005-0090 | C3 | SCP0005_DistributionRoute.spdMainDataMod | 하네스·환경 | C3 도구 오류 — 원장 V-a24da326 ASIS / 원장 V-11fc9455 ASIS / 원장 V-980834ad ASIS / 원장 V-bda800bf ASIS / 원장 V-ec443a6e ASIS / 원장 V-8447aae1  |  | 10 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0091 | C3 | TO_CITY / City | 하네스·환경 | C3 도구 오류 — 실측[T-653f2a16]: [전제 미충족 T300] TO_CITY: 원천 Site 후보 입력 실패(From '' · To '') — 연쇄 재현 불가 |  | 8 (ACT:SCP0005_DistributionRoute.SetCityCod) |
| WK-SCP0005-0092 | C3 | TO_CITY_NAME / City Name | 하네스·환경 | C3 도구 오류 — 실측[T-0803d2d0]: TO_CITY_NAME: 원천 TO_CITY 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) → 기계 판정 불가 — 수동 검수 대상(작업 원장 |  | 5 (ACT:SCP0005_DistributionRoute.SetCityCod) |
| WK-SCP0005-0093 | C3 | TO_COUNTRY / Country | 하네스·환경 | C3 도구 오류 — 실측[T-38e03b62]: [전제 미충족 T300] TO_COUNTRY: 원천 Site 후보 입력 실패(From '' · To '') — 연쇄 재현 불가 |  | 8 (ACT:SCP0005_DistributionRoute.SetCityCod) |
| WK-SCP0005-0094 | C3 | VALID_YN / Valid | 하네스·환경 | C3 도구 오류 — 실측[T-8b3ad504]: VALID_YN 연쇄 원천 컬럼 해석 불가 — AS-IS InsertRow:947 siMain.SetValue(siMain.ActiveRowIndex, siMain.GetColumnIn |  | 1 (ACT:SCP0005_DistributionRoute.InsertRow:) |
| WK-SCP0005-0095 | C3 | dt.Rows[nRow][DefColumns.LT_ARRIVAL_INLA | 하네스·환경 | C3 도구 오류 — 원장 V-a24da326 |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0096 | C3 | dt.Rows[nRow][DefColumns.LT_DEPARTURE_IN | 하네스·환경 | C3 도구 오류 — 원장 V-980834ad |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0097 | C3 | dt.Rows[nRow][DefColumns.LT_LAY_OFF_CLEA | 하네스·환경 | C3 도구 오류 — 원장 V-bda800bf |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0098 | C3 | dt.Rows[nRow][DefColumns.LT_SUM] | 하네스·환경 | C3 도구 오류 — 원장 V-8447aae1 |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0099 | C3 | dt.Rows[nRow][DefColumns.LT_SUM] | 하네스·환경 | C3 도구 오류 — 원장 V-95abdd8e |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0100 | C3 | dt.Rows[nRow][DefColumns.LT_VOYAGE] | 하네스·환경 | C3 도구 오류 — 원장 V-ec443a6e |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0101 | C3 | dt.Rows[nRow][DefColumns.LT_WAIT_SHIPPIN | 하네스·환경 | C3 도구 오류 — 원장 V-11fc9455 |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0102 | C6 | DAYS / Departure Days | 하네스·환경 | C6 도구 오류 — 실측[T-dc040561]: DAYS 연쇄 원천 해석 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] 검사기(_verif |  | 1 (R9 TRK/AIR→DAYS 7 'Y') |
| WK-SCP0005-0103 | C6 | LT_ARRIVAL_INLAND / Arrival Inland | 하네스·환경 | C6 도구 오류 — 원장 V-eef89e27 ASIS / 원장 V-5580d731 ASIS / 원장 V-e99b3a48 ASIS / 원장 V-94daba6e ASIS / 원장 V-74b7f3ca ASIS / 원장 V-0adb17b9  |  | 58 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0104 | C6 | LT_DEPARTURE_INLAND / Departure Inland | 하네스·환경 | C6 도구 오류 — 원장 V-e99b3a48 ASIS / 원장 V-94daba6e ASIS / 원장 V-74b7f3ca ASIS / 실측[T-39282451]: LT_ARRIVAL_INLAND 셀을 열었다가 값을 바꾸지 않고 닫음(더 |  | 4 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0105 | C6 | LT_LAY_OFF_CLEARANCE / Lay Off/Customs C | 하네스·환경 | C6 도구 오류 — 원장 V-94daba6e ASIS / 원장 V-74b7f3ca ASIS / 실측[T-07dc1388]: LT_ARRIVAL_INLAND 셀을 열었다가 값을 바꾸지 않고 닫음(더블클릭+Esc) → LT_LAY_OFF |  | 4 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0106 | C6 | LT_SUM / Total L/T | 하네스·환경 | C6 도구 오류 — 원장 V-0adb17b9 ASIS / 원장 V-156b0f5d ASIS / 실측[T-ba174192]: LT_ARRIVAL_INLAND 셀을 열었다가 값을 바꾸지 않고 닫음(더블클릭+Esc) → LT_SUM '0' |  | 3 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0107 | C6 | LT_VOYAGE / Voyage | 하네스·환경 | C6 도구 오류 — 원장 V-74b7f3ca ASIS / 실측[T-44ab1176]: LT_ARRIVAL_INLAND 셀을 열었다가 값을 바꾸지 않고 닫음(더블클릭+Esc) → LT_VOYAGE '0'→'0' — 값 유지(정상) |  | 4 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0108 | C6 | LT_WAIT_SHIPPING / Waiting For Shipping | 하네스·환경 | C6 도구 오류 — 원장 V-5580d731 ASIS / 원장 V-e99b3a48 ASIS / 원장 V-94daba6e ASIS / 원장 V-74b7f3ca ASIS / 실측[T-488e25b7]: LT_ARRIVAL_INLAND 셀 |  | 4 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0109 | C6 | PRIORITY / Priority | 하네스·환경 | C6 도구 오류 — 실측[T-6e2ef7c8]: PRIORITY 연쇄 원천 해석 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] 검사기(_v |  | 1 (R1 숫자셀 범위(cellType)) |
| WK-SCP0005-0110 | C6 | R10 TRK→港/Forwarder 7 '-' | 하네스·환경 | C6 도구 오류 — 행 집계 — 대조표 R10 TRK→港/Forwarder 7 '-' '`portsDash()` cellEditEnded' 의 C6 46요소: PASS:29 · ERROR:15 · NA:2 |  | 1 (R10 TRK→港/Forwarder 7 '-') |
| WK-SCP0005-0111 | C6 | SCP0005_DistributionRoute.spdMainDataMod | 하네스·환경 | C6 도구 오류 — 원장 V-eef89e27 ASIS / 원장 V-5580d731 ASIS / 원장 V-e99b3a48 ASIS / 원장 V-94daba6e ASIS / 원장 V-74b7f3ca ASIS / 원장 V-0adb17b9  |  | 10 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0112 | C6 | dt.Rows[nRow][DefColumns.LT_ARRIVAL_INLA | 하네스·환경 | C6 도구 오류 — 원장 V-eef89e27 |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0113 | C6 | dt.Rows[nRow][DefColumns.LT_DEPARTURE_IN | 하네스·환경 | C6 도구 오류 — 원장 V-e99b3a48 |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0114 | C6 | dt.Rows[nRow][DefColumns.LT_LAY_OFF_CLEA | 하네스·환경 | C6 도구 오류 — 원장 V-94daba6e |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0115 | C6 | dt.Rows[nRow][DefColumns.LT_SUM] | 하네스·환경 | C6 도구 오류 — 원장 V-0adb17b9 |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0116 | C6 | dt.Rows[nRow][DefColumns.LT_SUM] | 하네스·환경 | C6 도구 오류 — 원장 V-156b0f5d |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0117 | C6 | dt.Rows[nRow][DefColumns.LT_VOYAGE] | 하네스·환경 | C6 도구 오류 — 원장 V-74b7f3ca |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0118 | C6 | dt.Rows[nRow][DefColumns.LT_WAIT_SHIPPIN | 하네스·환경 | C6 도구 오류 — 원장 V-5580d731 |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0119 | K4 | SCP0005 화면 | 하네스·환경 | K4 도구 오류 — 원장 V-4da2eeab GENERAL / 원장 V-971d34fe GENERAL / 원장 V-df84cd6a GENERAL / 원장 V-88b2cf80 GENERAL / 원장 V-7990c634 GENERAL / |  | 33 (COMMON:UC-01 COMMON:UC-04 COMMON:UC-05 C) |
| WK-SCP0005-0120 | F1 | SCP0005 화면 | 하네스·환경 | F1 도구 오류 — 원장 V-c9c3b04a RULE_SCREEN / 원장 V-4e4af2a4 RULE_SCREEN / 원장 V-ed1875e6 RULE_SCREEN / 원장 V-26d2974c RULE_SCREEN / 원장 V-69 |  | 202 (R14/R15 저장응답 색칠(99010/99020) R18 Insert/) |
| WK-SCP0005-0121 | F6 | SCP0005 화면 | 하네스·환경 | F6 도구 오류 — 원장 V-77a721bf RULE_SCREEN / 원장 V-337cb2f9 RULE_SCREEN / 원장 V-189ec7ae RULE_SCREEN / 원장 V-72fbb5b2 RULE_SCREEN / 원장 V-71 |  | 193 (ACT:SCP0005_DistributionRoute.SaveButton) |
| WK-SCP0005-0122 | F4 | FindDataMain 파라미터 6종 'ALL'→'' | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 FindDataMain 파라미터 6종 'ALL'→'' 'store `setFilter()` `orEmpty()`' 의 F4 5요소: ERROR:3 · PASS:1 · NA:1 |  | 1 (FindDataMain 파라미터 6종 'ALL'→'') |
| WK-SCP0005-0123 | F4 | PKG_SCP0005.P_SCP0005_GET_COUNTRY_CITY | 하네스·환경 | F4 도구 오류 — 실측[T-829cf301]: PKG_SCP0005.P_SCP0005_GET_COUNTRY_CITY: SCP0005/route/SEARCH_CITY — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회 경로 — 해 |  | 10 (ACT:SCP0005_DistributionRoute.FindButton) |
| WK-SCP0005-0124 | F4 | SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID | 하네스·환경 | F4 도구 오류 — 실측[T-ea530cd5]: SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID: SCP0005/route/SEARCH_ROUTEID — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회 경 |  | 14 (ACT:SCP0005_DistributionRoutePopup.FindB) |
| WK-SCP0005-0125 | F4 | SCP0005_GET_DISTRIBUTION_ROUTEID | 하네스·환경 | F4 도구 오류 — 실측[T-719d403c]: SCP0005_GET_DISTRIBUTION_ROUTEID: SCP0005/route/SEARCH_ROUTEID — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회 경로 — 해당 시 |  | 34 (ACT:SCP0005_DistributionRoute.FindButton) |
| WK-SCP0005-0126 | A5 | COMMON:UC-07 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터 걸린 상태 재조회해도 조회되고 필터도 유지(rebindFilterColumns)' 의 A5 16요소: PASS:15 · ERROR:1 |  | 1 (COMMON:UC-07) |
| WK-SCP0005-0127 | A5 | DAYS / Departure Days | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-aa4e2eb2]: DAYS: [측정 경로 없음] AS-IS 시트 ? 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 여부 미측정(T203) |  | 1 (R9 TRK/AIR→DAYS 7 'Y') |
| WK-SCP0005-0128 | A5 | DB메타 구동(gridColumns=[]) | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 DB메타 구동(gridColumns=[]) "`staticColumns` admin fetch(`ADMIN_SHEET_NAME`='Di" 의 A5 16요소: PASS:15 · ERROR:1 |  | 1 (DB메타 구동(gridColumns=[])) |
| WK-SCP0005-0129 | A5 | R10 TRK→港/Forwarder 7 '-' | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 R10 TRK→港/Forwarder 7 '-' '`portsDash()` cellEditEnded' 의 A5 16요소: PASS:15 · ERROR:1 |  | 1 (R10 TRK→港/Forwarder 7 '-') |
| WK-SCP0005-0130 | A5 | R11/R12 FROM/TO 셀 더블클릭→도시팝업 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 R11/R12 FROM/TO 셀 더블클릭→도시팝업 '`onFromCellDblClick`/`onToCellDblClick`→`RegionMod' 의 A5 16요소: PASS:15 · ERROR: |  | 1 (R11/R12 FROM/TO 셀 더블클릭→도시팝업) |
| WK-SCP0005-0131 | A5 | R16/R17 클라 검증 색칠 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 R16/R17 클라 검증 색칠 '`validateRows`(전 편집행 누적, iter-2 G4) → `invalidCell' 의 A5 16요소: PASS:15 · ERROR:1 |  | 1 (R16/R17 클라 검증 색칠) |
| WK-SCP0005-0132 | A5 | R18 Insert/Delete | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 R18 Insert/Delete '`GridAction.addRow` / `removeRow(grid, true)`(신규만)' 의 A5 16요소: PASS:15 · ERROR:1 |  | 1 (R18 Insert/Delete) |
| WK-SCP0005-0133 | A5 | R7 조회 databind | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 R7 조회 databind '`useTabProcQuery` o_rc1' 의 A5 16요소: PASS:15 · ERROR:1 |  | 1 (R7 조회 databind) |
| WK-SCP0005-0134 | G4 | FindDataMain 파라미터 6종 'ALL'→'' | 하네스·환경 | G4 도구 오류 — 행 집계 — 대조표 FindDataMain 파라미터 6종 'ALL'→'' 'store `setFilter()` `orEmpty()`' 의 G4 9요소: ERROR:4 · NOPATH:3 · PASS:2 |  | 1 (FindDataMain 파라미터 6종 'ALL'→'') |
| WK-SCP0005-0135 | G4 | cascade(clbFromCountry→City) | 하네스·환경 | G4 도구 오류 — 행 집계 — 대조표 cascade(clbFromCountry→City) '없음(주석 폐기) — 무cascade' 의 G4 9요소: ERROR:4 · NOPATH:3 · PASS:2 |  | 1 (cascade(clbFromCountry→City)) |
| WK-SCP0005-0136 | G4 | txtFromCity / From City | 하네스·환경 | G4 도구 오류 — E2E smoke labels / 실측[T-88891164]: r0 ROUTE_ID 더블클릭 → 팝업 열림 감지 실패(검사기 미검증) |  | 1 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0137 | G4 | txtFromCountry / From Country | 하네스·환경 | G4 도구 오류 — E2E smoke labels / 실측[T-9b463365]: r0 ROUTE_ID 더블클릭 → 팝업 열림 감지 실패(검사기 미검증) |  | 1 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0138 | G4 | txtToCity / To City | 하네스·환경 | G4 도구 오류 — E2E smoke labels / 실측[T-90d2d30f]: r0 ROUTE_ID 더블클릭 → 팝업 열림 감지 실패(검사기 미검증) |  | 1 (txtToCountry/txtToCity + btnToSrch) |
| WK-SCP0005-0139 | G4 | txtToCountry / To Country | 하네스·환경 | G4 도구 오류 — E2E smoke labels / 실측[T-6d65f303]: r0 ROUTE_ID 더블클릭 → 팝업 열림 감지 실패(검사기 미검증) |  | 1 (txtToCountry/txtToCity + btnToSrch) |
| WK-SCP0005-0140 | H2 | COMMON:UC-07 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터 걸린 상태 재조회해도 조회되고 필터도 유지(rebindFilterColumns)' 의 H2 31요소: PASS:27 · ERROR:3 · NA:1 |  | 1 (COMMON:UC-07) |
| WK-SCP0005-0141 | H2 | DB메타 구동(gridColumns=[]) | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 DB메타 구동(gridColumns=[]) "`staticColumns` admin fetch(`ADMIN_SHEET_NAME`='Di" 의 H2 31요소: PASS:27 · ERROR:3 ·  |  | 1 (DB메타 구동(gridColumns=[])) |
| WK-SCP0005-0142 | H2 | PRIORITY / Priority | 하네스·환경 | H2 도구 오류 — 원장 V-e43b6ce9 COLUMN / 원장 V-b4651880 ASIS / 원장 V-fa71e89c ASIS / 실측[T-a86cad2c]: PRIORITY: 신규행 편집=true 표시 일치 |  | 7 (R1 숫자셀 범위(cellType) R14/R15 저장응답 색칠(9901) |
| WK-SCP0005-0143 | H2 | R10 TRK→港/Forwarder 7 '-' | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 R10 TRK→港/Forwarder 7 '-' '`portsDash()` cellEditEnded' 의 H2 31요소: PASS:27 · ERROR:3 · NA:1 |  | 1 (R10 TRK→港/Forwarder 7 '-') |
| WK-SCP0005-0144 | H2 | R11/R12 FROM/TO 셀 더블클릭→도시팝업 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 R11/R12 FROM/TO 셀 더블클릭→도시팝업 '`onFromCellDblClick`/`onToCellDblClick`→`RegionMod' 의 H2 31요소: PASS:27 · ERROR: |  | 1 (R11/R12 FROM/TO 셀 더블클릭→도시팝업) |
| WK-SCP0005-0145 | H2 | R16/R17 클라 검증 색칠 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 R16/R17 클라 검증 색칠 '`validateRows`(전 편집행 누적, iter-2 G4) → `invalidCell' 의 H2 31요소: PASS:27 · ERROR:3 · NA:1 |  | 1 (R16/R17 클라 검증 색칠) |
| WK-SCP0005-0146 | H2 | R18 Insert/Delete | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 R18 Insert/Delete '`GridAction.addRow` / `removeRow(grid, true)`(신규만)' 의 H2 31요소: PASS:27 · ERROR:3 · NA:1 |  | 1 (R18 Insert/Delete) |
| WK-SCP0005-0147 | H2 | R7 조회 databind | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 R7 조회 databind '`useTabProcQuery` o_rc1' 의 H2 31요소: PASS:27 · ERROR:3 · NA:1 |  | 1 (R7 조회 databind) |
| WK-SCP0005-0148 | H2 | SCP0005_DistributionRoute.CreateSpread | 하네스·환경 | H2 도구 오류 — 진입점 집계 — 대조표 SCP0005_DistributionRoute.CreateSpread 의 H2 31요소: PASS:27 · ERROR:3 · NA:1 |  | 5 (ACT:SCP0005_DistributionRoute.CreateSpre) |
| WK-SCP0005-0149 | H2 | siMain.SetBGColor | 하네스·환경 | H2 도구 오류 — 원장 V-c56bdc72 |  | 1 (ACT:SCP0005_DistributionRoute.CheckValid) |
| WK-SCP0005-0150 | H2 | siMain.SetBGColor | 하네스·환경 | H2 도구 오류 — 원장 V-b4651880 |  | 1 (ACT:SCP0005_DistributionRoute.CheckValid) |
| WK-SCP0005-0151 | H5 | COMMON:UC-07 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터 걸린 상태 재조회해도 조회되고 필터도 유지(rebindFilterColumns)' 의 H5 16요소: PASS:15 · ERROR:1 |  | 1 (COMMON:UC-07) |
| WK-SCP0005-0152 | H5 | DAYS / Departure Days | 하네스·환경 | H5 도구 오류 — 실측[T-d786155a]: DAYS 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (R9 TRK/AIR→DAYS 7 'Y') |
| WK-SCP0005-0153 | H5 | DB메타 구동(gridColumns=[]) | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 DB메타 구동(gridColumns=[]) "`staticColumns` admin fetch(`ADMIN_SHEET_NAME`='Di" 의 H5 16요소: PASS:15 · ERROR:1 |  | 1 (DB메타 구동(gridColumns=[])) |
| WK-SCP0005-0154 | H5 | R10 TRK→港/Forwarder 7 '-' | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 R10 TRK→港/Forwarder 7 '-' '`portsDash()` cellEditEnded' 의 H5 16요소: PASS:15 · ERROR:1 |  | 1 (R10 TRK→港/Forwarder 7 '-') |
| WK-SCP0005-0155 | H5 | R11/R12 FROM/TO 셀 더블클릭→도시팝업 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 R11/R12 FROM/TO 셀 더블클릭→도시팝업 '`onFromCellDblClick`/`onToCellDblClick`→`RegionMod' 의 H5 16요소: PASS:15 · ERROR: |  | 1 (R11/R12 FROM/TO 셀 더블클릭→도시팝업) |
| WK-SCP0005-0156 | H5 | R16/R17 클라 검증 색칠 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 R16/R17 클라 검증 색칠 '`validateRows`(전 편집행 누적, iter-2 G4) → `invalidCell' 의 H5 16요소: PASS:15 · ERROR:1 |  | 1 (R16/R17 클라 검증 색칠) |
| WK-SCP0005-0157 | H5 | R18 Insert/Delete | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 R18 Insert/Delete '`GridAction.addRow` / `removeRow(grid, true)`(신규만)' 의 H5 16요소: PASS:15 · ERROR:1 |  | 1 (R18 Insert/Delete) |
| WK-SCP0005-0158 | H5 | R7 조회 databind | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 R7 조회 databind '`useTabProcQuery` o_rc1' 의 H5 16요소: PASS:15 · ERROR:1 |  | 1 (R7 조회 databind) |
| WK-SCP0005-0159 | H5 | SCP0005_DistributionRoute.CreateSpread | 하네스·환경 | H5 도구 오류 — 진입점 집계 — 대조표 SCP0005_DistributionRoute.CreateSpread 의 H5 16요소: PASS:15 · ERROR:1 |  | 5 (ACT:SCP0005_DistributionRoute.CreateSpre) |
| WK-SCP0005-0160 | I1 | SCP0005 화면 | 하네스·환경 | I1 도구 오류 — 원장 V-29c34a39 RULE_SCREEN / 원장 V-38472e83 RULE_SCREEN / 원장 V-cad0bff9 RULE_SCREEN / 원장 V-27f623b5 DEFECT / 원장 V-49e2564 |  | 15 (PRIORITY>=1 (MSG00107) FROM/TO City Name) |
| WK-SCP0005-0161 | SC1 | SCP0005 화면 | 하네스·환경 | SC1 도구 오류 — 원장 V-fa81dfc5 RULE_SCREEN / 원장 V-963fba19 CONFIRMED |  | 7 (clbTransMode (UsrCheckedList **다중 체크** —) |
| WK-SCP0005-0162 | D1 | EditButton (SwitchLock 편집모드) | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 EditButton (SwitchLock 편집모드) 'NSCM 상시편집 표준으로 대체(Edit 토글 없음) — 셀별 editLock 판정' 의 D1 8요소: ERROR:4 · PASS:2 · N |  | 1 (EditButton (SwitchLock 편집모드)) |
| WK-SCP0005-0163 | D1 | FROM_CITY_NAME / City Name | 하네스·환경 | D1 도구 오류 — 원장 V-efd885dd COLUMN / 원장 V-a2b3892f COLUMN / 실측[T-174d521f]: 기존행 r0 FROM_CITY_NAME 편집=false (AS-IS 잠금) / 신규행 r0 FROM_C |  | 3 (ACT:SCP0005_DistributionRoute.EditButton) |
| WK-SCP0005-0164 | D1 | LT_SUM / Total L/T | 하네스·환경 | D1 도구 오류 — 원장 V-d72694b1 COLUMN / 원장 V-ef2c44ae COLUMN / 실측[T-4758369b]: 기존행 r0 LT_SUM 편집=false (AS-IS 잠금) / 신규행 r0 LT_SUM 편집=fals |  | 4 (R3/R4/R5 편집잠금(ROUTE_ID/CITY_NAME/LT_SUM/) |
| WK-SCP0005-0165 | D1 | R16/R17 클라 검증 색칠 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 R16/R17 클라 검증 색칠 '`validateRows`(전 편집행 누적, iter-2 G4) → `invalidCell' 의 D1 8요소: ERROR:4 · PASS:2 · NA:2 |  | 1 (R16/R17 클라 검증 색칠) |
| WK-SCP0005-0166 | D1 | ROUTE_ID / Route Id | 하네스·환경 | D1 도구 오류 — 원장 V-f069cc0b COLUMN / 원장 V-b6684398 COLUMN / 실측[T-159af0ae]: 기존행 r0 ROUTE_ID 편집=false (AS-IS 잠금) / 신규행 r0 ROUTE_ID 편집= |  | 7 (R3/R4/R5 편집잠금(ROUTE_ID/CITY_NAME/LT_SUM/) |
| WK-SCP0005-0167 | D1 | SCP0005_DistributionRoute.EditButton | 하네스·환경 | D1 도구 오류 — 진입점 집계 — 대조표 SCP0005_DistributionRoute.EditButton 의 D1 6요소: ERROR:4 · PASS:2 |  | 1 (ACT:SCP0005_DistributionRoute.EditButton) |
| WK-SCP0005-0168 | D1 | TO_CITY_NAME / City Name | 하네스·환경 | D1 도구 오류 — 원장 V-5f5baa0d COLUMN / 원장 V-6d214120 COLUMN / 실측[T-2360259a]: 기존행 r0 TO_CITY_NAME 편집=false (AS-IS 잠금) / 신규행 r0 TO_CITY_ |  | 3 (ACT:SCP0005_DistributionRoute.EditButton) |
| WK-SCP0005-0169 | E4 | LT_ARRIVAL_INLAND / Arrival Inland | 하네스·환경 | E4 도구 오류 — 원장 V-3e95d2be ASIS / 실측[T-eea49685]: MSG00209 — spdMainDataModel_Changed 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작  |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0170 | E4 | MSG00209 | 하네스·환경 | E4 도구 오류 — 원장 V-3e95d2be / 실측[T-dba493fd]: MSG00209 — spdMainDataModel_Changed 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오( |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0171 | E4 | MSG00209 | 하네스·환경 | E4 도구 오류 — 원장 V-3e95d2be ASIS / 실측[T-6a512ae5]: MSG00209 — spdMainDataModel_Changed 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작  |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0172 | E4 | MSG00265 | 하네스·환경 | E4 도구 오류 — 원장 V-4a0b6271 / 실측[T-2c4e7c8a]: MSG00265 — btnEaxel_Upload_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(btn |  | 1 (ACT:SCP0005_DistributionRoute.btnEaxel_U) |
| WK-SCP0005-0173 | E4 | MSG00265 | 하네스·환경 | E4 도구 오류 — 원장 V-4a0b6271 ASIS / 실측[T-e19b6757]: MSG00265 — btnEaxel_Upload_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리 |  | 1 (ACT:SCP0005_DistributionRoute.btnEaxel_U) |
| WK-SCP0005-0174 | A6 | FindDataMain 파라미터 6종 'ALL'→'' | 하네스·환경 | A6 도구 오류 — 행 집계 — 대조표 FindDataMain 파라미터 6종 'ALL'→'' 'store `setFilter()` `orEmpty()`' 의 A6 4요소: ERROR:3 · PASS:1 |  | 1 (FindDataMain 파라미터 6종 'ALL'→'') |
| WK-SCP0005-0175 | A6 | PKG_SCP0005.P_SCP0005_GET_COUNTRY_CITY | 하네스·환경 | A6 도구 오류 — 원장 V-dbaedd29 SP / 정렬대조 PASS 분기 키 순서 동일 / 실측[T-f0f809e9]: PKG_SCP0005.P_SCP0005_GET_COUNTRY_CITY: 화면 진입·조회 경로에서 이 SP 가  |  | 7 (ACT:SCP0005_DistributionRoute.FindButton) |
| WK-SCP0005-0176 | A6 | SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID | 하네스·환경 | A6 도구 오류 — 원장 V-f574c4a3 SP / 정렬대조 REVIEW TO-BE 프로시저 배선(PROC_M) 없음 — 대응 프로시저 확인 / 실측[T-336fa068]: SCP0005_GET_DISTRIBUTION_HISTORY |  | 14 (ACT:SCP0005_DistributionRoutePopup.FindB) |
| WK-SCP0005-0177 | A6 | SCP0005_GET_DISTRIBUTION_ROUTEID | 하네스·환경 | A6 도구 오류 — 원장 V-fc7cfdc8 SP / 정렬대조 REVIEW TO-BE 프로시저 배선(PROC_M) 없음 — 대응 프로시저 확인 / 실측[T-2f7778bd]: SCP0005_GET_DISTRIBUTION_ROUTEID |  | 34 (ACT:SCP0005_DistributionRoute.FindButton) |
| WK-SCP0005-0178 | G1 | COMMON:UC-07 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터 걸린 상태 재조회해도 조회되고 필터도 유지(rebindFilterColumns)' 의 G1 8요소: NA:4 · PASS:3 · ERROR:1 |  | 1 (COMMON:UC-07) |
| WK-SCP0005-0179 | G1 | FindButton(Search) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 FindButton(Search) '`hotkeyConfig.search`=handleSearch (hasButton)' 의 G1 8요소: NA:4 · PASS:3 · ERROR:1 |  | 1 (FindButton(Search)) |
| WK-SCP0005-0180 | G1 | FindDataMain 파라미터 6종 'ALL'→'' | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 FindDataMain 파라미터 6종 'ALL'→'' 'store `setFilter()` `orEmpty()`' 의 G1 8요소: NA:4 · PASS:3 · ERROR:1 |  | 1 (FindDataMain 파라미터 6종 'ALL'→'') |
| WK-SCP0005-0181 | G1 | R7 조회 databind | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 R7 조회 databind '`useTabProcQuery` o_rc1' 의 G1 8요소: NA:4 · PASS:3 · ERROR:1 |  | 1 (R7 조회 databind) |
| WK-SCP0005-0182 | G1 | btnEaxel_Upload → ExcelUploadForm2 | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 btnEaxel_Upload → ExcelUploadForm2 "customButton 'Excel Upload' → `ExcelUploadModal` →" 의 G1 8요소: NA:4 · PAS |  | 1 (btnEaxel_Upload → ExcelUploadForm2) |
| WK-SCP0005-0183 | G1 | cascade(clbFromCountry→City) | 하네스·환경 | G1 도구 오류 — 행 집계 — 대조표 cascade(clbFromCountry→City) '없음(주석 폐기) — 무cascade' 의 G1 8요소: NA:4 · PASS:3 · ERROR:1 |  | 1 (cascade(clbFromCountry→City)) |
| WK-SCP0005-0184 | G1 | clbTransMode / Trans Mode | 하네스·환경 | G1 도구 오류 — 원장 V-43efa55d SEARCH / E2E smoke cond combo |  | 3 (clbTransMode (UsrCheckedList **다중 체크** —) |
| WK-SCP0005-0185 | X-ROW | SCP0005_DistributionRoute.CheckValid | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 14검사 — PASS:9 · ERROR:3 · NA:2 |  | 39 (ACT:SCP0005_DistributionRoute.CheckValid) |
| WK-SCP0005-0186 | X-ROW | SCP0005_DistributionRoute.CreateSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — NOT_RUN:3 · PASS:1 (미실행 검사가 남아 판정필요) |  | 1 (ACT:SCP0005_DistributionRoute.CreateSpre) |
| WK-SCP0005-0187 | X-ROW | SCP0005_DistributionRoute.FindButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — ERROR:4 · PASS:3 · REVIEW:2 |  | 1 (ACT:SCP0005_DistributionRoute.FindButton) |
| WK-SCP0005-0188 | X-ROW | SCP0005_DistributionRoute.FindDataMain | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 14검사 — PASS:8 · NA:4 · ERROR:2 |  | 6 (ACT:SCP0005_DistributionRoute.FindDataMa) |
| WK-SCP0005-0189 | X-ROW | SCP0005_DistributionRoute.FindDataReceiv | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 8검사 — ERROR:3 · NA:2 · REVIEW:1 · PASS:1 · NOPATH:1 |  | 7 (ACT:SCP0005_DistributionRoute.FindDataRe) |
| WK-SCP0005-0190 | X-ROW | SCP0005_DistributionRoute.GetData_Countr | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 5검사 — NOPATH:2 · PASS:2 · ERROR:1 |  | 2 (ACT:SCP0005_DistributionRoute.GetData_Co) |
| WK-SCP0005-0191 | X-ROW | SCP0005_DistributionRoute.InitSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 29검사 — PASS:28 · ERROR:1 |  | 1 (ACT:SCP0005_DistributionRoute.InitSpread) |
| WK-SCP0005-0192 | X-ROW | SCP0005_DistributionRoute.InsertRow | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 18검사 — PASS:13 · ERROR:5 |  | 13 (ACT:SCP0005_DistributionRoute.InsertRow ) |
| WK-SCP0005-0193 | X-ROW | SCP0005_DistributionRoute.SetImageCell | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 36검사 — PASS:20 · NA:10 · ERROR:6 |  | 4 (ACT:SCP0005_DistributionRoute.SetImageCe) |
| WK-SCP0005-0194 | X-ROW | SCP0005_DistributionRoute.SetSpreadColum | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 12검사 — PASS:5 · NOT_RUN:4 · NA:2 · ERROR:1 |  | 3 (ACT:SCP0005_DistributionRoute.SetSpreadC) |
| WK-SCP0005-0195 | X-ROW | SCP0005_DistributionRoute.btnEaxel_Uploa | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 7검사 — ERROR:6 · PASS:1 |  | 4 (ACT:SCP0005_DistributionRoute.btnEaxel_U) |
| WK-SCP0005-0196 | X-ROW | SCP0005_DistributionRoute.btnFromSrch_Cl | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 15검사 — ERROR:8 · PASS:4 · NOPATH:2 · NOT_RUN:1 |  | 3 (ACT:SCP0005_DistributionRoute.btnFromSrc) |
| WK-SCP0005-0197 | X-ROW | SCP0005_DistributionRoute.btnToSrch_Clic | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 15검사 — ERROR:8 · PASS:3 · NOPATH:2 · NOT_RUN:1 · WARN:1 |  | 3 (ACT:SCP0005_DistributionRoute.btnToSrch_) |
| WK-SCP0005-0198 | X-ROW | SCP0005_DistributionRoute.spdMainDataMod | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 119검사 — PASS:58 · ERROR:56 · NA:4 · NOPATH:1 |  | 21 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0199 | X-ROW | SCP0005_DistributionRoute.spdMain_CellDo | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 44검사 — ERROR:13 · PASS:12 · NA:11 · NOPATH:7 · NOT_RUN:1 |  | 11 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0200 | X-ROW | SCP0005_DistributionRoutePopup..ctor | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NOPATH:1 · ERROR:1 |  | 2 (ACT:SCP0005_DistributionRoutePopup..ctor) |
| WK-SCP0005-0201 | X-ROW | SCP0005_DistributionRoutePopup.CreateSpr | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 6 (ACT:SCP0005_DistributionRoutePopup.Creat) |
| WK-SCP0005-0202 | X-ROW | SCP0005_DistributionRoutePopup.DefinePro | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — PASS:1 · ERROR:1 |  | 2 (ACT:SCP0005_DistributionRoutePopup.Defin) |
| WK-SCP0005-0203 | X-ROW | SCP0005_DistributionRoutePopup.Dispose | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — PASS:1 · ERROR:1 |  | 3 (ACT:SCP0005_DistributionRoutePopup.Dispo) |
| WK-SCP0005-0204 | X-ROW | SCP0005_DistributionRoutePopup.FindButto | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — ERROR:3 · REVIEW:1 |  | 2 (ACT:SCP0005_DistributionRoutePopup.FindB) |
| WK-SCP0005-0205 | X-ROW | SCP0005_DistributionRoutePopup.FindData | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — ERROR:3 · REVIEW:1 · NOPATH:1 · PASS:1 |  | 12 (ACT:SCP0005_DistributionRoutePopup.FindD) |
| WK-SCP0005-0206 | X-ROW | SCP0005_DistributionRoutePopup.Form_Load | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — PASS:1 · ERROR:1 |  | 5 (ACT:SCP0005_DistributionRoutePopup.Form_) |
| WK-SCP0005-0207 | X-ROW | SCP0005_DistributionRoutePopup.InitSprea | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 30검사 — PASS:28 · ERROR:2 |  | 12 (ACT:SCP0005_DistributionRoutePopup.InitS) |
| WK-SCP0005-0208 | G5 | ProgressForm | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 ProgressForm 'react-query isFetching(별도 팝업 불요)' 의 G5 22요소: NA:8 · NOPATH:7 · ERROR:7 |  | 1 (ProgressForm) |
| WK-SCP0005-0209 | G5 | R11/R12 FROM/TO 셀 더블클릭→도시팝업 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 R11/R12 FROM/TO 셀 더블클릭→도시팝업 '`onFromCellDblClick`/`onToCellDblClick`→`RegionMod' 의 G5 22요소: NA:8 · NOPATH:7  |  | 1 (R11/R12 FROM/TO 셀 더블클릭→도시팝업) |
| WK-SCP0005-0210 | G5 | btnFromSrch | 하네스·환경 | G5 도구 오류 — 원장 V-2e28bbf0 ASIS / 원장 V-c6dd7839 ASIS |  | 2 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0211 | G5 | btnToSrch | 하네스·환경 | G5 도구 오류 — 원장 V-b16a17a1 ASIS / 원장 V-595a9098 ASIS |  | 2 (txtToCountry/txtToCity + btnToSrch ACT:S) |
| WK-SCP0005-0212 | G5 | frm.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-a6bb7234 |  | 1 (ACT:SCP0005_DistributionRoute.btnEaxel_U) |
| WK-SCP0005-0213 | G5 | popCity.Form_Load(true, sCountry, sCity) | 하네스·환경 | G5 도구 오류 — 원장 V-2e28bbf0 |  | 1 (ACT:SCP0005_DistributionRoute.btnFromSrc) |
| WK-SCP0005-0214 | G5 | popCity.Form_Load(true, sCountry, sCity) | 하네스·환경 | G5 도구 오류 — 원장 V-b16a17a1 |  | 1 (ACT:SCP0005_DistributionRoute.btnToSrch_) |
| WK-SCP0005-0215 | G5 | popCity.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-c6dd7839 |  | 1 (ACT:SCP0005_DistributionRoute.btnFromSrc) |
| WK-SCP0005-0216 | G5 | popCity.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-595a9098 |  | 1 (ACT:SCP0005_DistributionRoute.btnToSrch_) |
| WK-SCP0005-0217 | H6 | ProgressForm | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 ProgressForm 'react-query isFetching(별도 팝업 불요)' 의 H6 22요소: ERROR:9 · PASS:7 · NOPATH:3 · NOT_RUN:2 · WARN:1 |  | 1 (ProgressForm) |
| WK-SCP0005-0218 | H6 | R11/R12 FROM/TO 셀 더블클릭→도시팝업 | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 R11/R12 FROM/TO 셀 더블클릭→도시팝업 '`onFromCellDblClick`/`onToCellDblClick`→`RegionMod' 의 H6 22요소: ERROR:9 · PASS:7 |  | 1 (R11/R12 FROM/TO 셀 더블클릭→도시팝업) |
| WK-SCP0005-0219 | H6 | ROUTE_ID / Route Id | 하네스·환경 | H6 도구 오류 — 원장 V-0e9099ba ASIS / 원장 V-4cfc72f5 ASIS |  | 9 (R8 ROUTE_ID ACT:SCP0005_DistributionRout) |
| WK-SCP0005-0220 | H6 | SCP0005_DistributionRoute.spdMain_CellDo | 하네스·환경 | H6 도구 오류 — 원장 V-0e9099ba ASIS / 원장 V-4cfc72f5 ASIS / 원장 V-cca901cb ASIS / 원장 V-c9dc5aa7 ASIS |  | 3 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0221 | H6 | SCP0005_DistributionRoutePopup | 하네스·환경 | H6 도구 오류 — 원장 V-0e9099ba ASIS |  | 2 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0222 | H6 | btnFromSrch | 하네스·환경 | H6 도구 오류 — 원장 V-718e1a16 ASIS / 원장 V-7cdbda05 ASIS |  | 2 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0223 | H6 | btnToSrch | 하네스·환경 | H6 도구 오류 — 원장 V-616b4d31 ASIS / 원장 V-ac0769f6 ASIS |  | 2 (txtToCountry/txtToCity + btnToSrch ACT:S) |
| WK-SCP0005-0224 | H6 | frm.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-e14533b1 |  | 1 (ACT:SCP0005_DistributionRoute.btnEaxel_U) |
| WK-SCP0005-0225 | H6 | new GSCM.SCM.PopUp.UIL.SCP0005_Distribut | 하네스·환경 | H6 도구 오류 — 원장 V-0e9099ba |  | 1 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0226 | H6 | popCity.Form_Load(true, sCountry, sCity) | 하네스·환경 | H6 도구 오류 — 원장 V-718e1a16 |  | 1 (ACT:SCP0005_DistributionRoute.btnFromSrc) |
| WK-SCP0005-0227 | H6 | popCity.Form_Load(true, sCountry, sCity) | 하네스·환경 | H6 도구 오류 — 원장 V-616b4d31 |  | 1 (ACT:SCP0005_DistributionRoute.btnToSrch_) |
| WK-SCP0005-0228 | H6 | popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-4cfc72f5 |  | 1 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0229 | M3 | SCP0005_DistributionRoutePopup | 하네스·환경 | M3 도구 오류 — 원장 V-a46588cb ASIS / 실측[T-6d14c72c]: [검사기 미검증] ROUTE_ID 더블클릭 → 팝업 열림 감지 실패 |  | 8 (ACT:SCP0005_DistributionRoutePopup..ctor) |
| WK-SCP0005-0230 | M3 | new GSCM.SCM.PopUp.UIL.SCP0005_Distribut | 하네스·환경 | M3 도구 오류 — 원장 V-a46588cb |  | 1 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0231 | M4 | SCP0005_DistributionRoute.spdMain_CellDo | 하네스·환경 | M4 도구 오류 — 진입점 집계 — 대조표 SCP0005_DistributionRoute.spdMain_CellDoubleClick 의 M4 8요소: PASS:5 · NA:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0232 | M4 | txtFromCity / From City | 하네스·환경 | M4 도구 오류 — 실측[T-47ab9353]: r0 ROUTE_ID 더블클릭 → 팝업 열림 감지 실패(검사기 미검증) |  | 5 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0233 | M4 | txtFromCountry / From Country | 하네스·환경 | M4 도구 오류 — 실측[T-3d44d32d]: r0 ROUTE_ID 더블클릭 → 팝업 열림 감지 실패(검사기 미검증) |  | 5 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0234 | M4 | txtToCity / To City | 하네스·환경 | M4 도구 오류 — 실측[T-26aaaaf4]: r0 ROUTE_ID 더블클릭 → 팝업 열림 감지 실패(검사기 미검증) |  | 5 (txtToCountry/txtToCity + btnToSrch ACT:S) |
| WK-SCP0005-0235 | M4 | txtToCountry / To Country | 하네스·환경 | M4 도구 오류 — 실측[T-ef2618be]: r0 ROUTE_ID 더블클릭 → 팝업 열림 감지 실패(검사기 미검증) |  | 5 (txtToCountry/txtToCity + btnToSrch ACT:S) |
