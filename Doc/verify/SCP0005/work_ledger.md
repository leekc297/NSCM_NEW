# 작업 원장 — SCP0005 · 2026-11-20 08:12

> 검사 인스턴스 565건 중 PASS·NA 369건 외 **196건 전부가 할 일**이다(판정과 별도 대기열 없음). 0건이 될 때까지 화면 미완료(VC1·G11).
> 보완 범위 repairScope = **DB_ONLY** — FE 항목은 이번 범위 밖(DB_ONLY). 이 원장은 코드를 고치지 않는다.

| 유형 | 할 일 | 건수 | 완료 조건 |
|---|---|---|---|
| W1 | 기능 구현 | 1 | 대조표 구현 + 위치 기입 → W8 실행 |
| W3 | 동작 수정 | 5 | 재판정 PASS |
| W5 | 검사기 연결 | 9 | 원장 항목/엔진 연결 → 실행 PASS |
| W6 | 검증 실행 | 2 | 실행 → PASS |
| W7 | 기대값 확정 | 21 | 기대 확정 → PASS/FAIL |
| W8 | 구현 후 검증 | 3 | 선행 W1 → PASS |
| W9 | 도구 오류 | 155 | 원인 해소 → 재판정 |

- 담당: 하네스·환경 155 · 사람 판정 / AS-IS 원문 확인 → 재판정 21 · 하네스 9 · 선행 W1 완료 후 E2E 3 · 사람판정 2 · DB 객체 2 · E2E 2 · FE 1 · 화면 FE 1
- **구현 의심**(검사기 없음/경로 없음인데 TO-BE 흔적도 없음): 3건 — 검증 전에 구현 여부부터 확인

## 검사별 할 일 분포

| 검사 | 층 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 | W9 | 검사 방법 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| H2 | DESIGN |  |  |  |  |  |  |  |  | 28 | 배경·글자색 규칙 |
| X-ROW | GEN |  |  | 1 |  |  |  | 1 |  | 21 | 대조표 행이 서술한 동작을 화면에서 재현 |
| C3 | CASCADE |  |  |  |  |  |  |  |  | 21 | 연쇄 자동 채움 |
| H6 | POPUP |  |  |  |  | 3 | 2 | 2 |  | 12 | 팝업 표준·열림 |
| A1 | GEN |  |  |  |  |  |  | 12 | 1 |  | 같은 조건으로 AS-IS SP 논리를 TO-BE 데이터에 적용한 행수·키 집합과 비교 |
| C6 | CASCADE |  |  |  |  |  |  |  |  | 11 | 무변경 편집 종료 시 연쇄 미발동 |
| G4 | DESIGN |  |  |  |  |  |  |  | 1 | 9 | 조회조건 표시·라벨·활성 |
| H5 | DESIGN |  |  |  |  |  |  |  |  | 9 | 라벨 명칭 |
| A5 | DESIGN |  |  |  |  |  |  |  |  | 8 | 표시 컬럼 구성 = 메타·AS-IS(Div·개인화·필수) |
| D1 | EDIT |  |  |  |  |  |  |  |  | 8 | 컬럼 편집 가능 여부(신규행·기존행) |
| E4 | EDIT |  |  | 2 |  |  |  |  |  | 5 | 업무 검증·메시지 발생 조건(조건부 필수·중복·관계) |
| G5 | POPUP |  |  |  |  | 3 |  |  |  | 3 | 팝업 조건 연동(인자) |
| M4 | POPUP |  |  |  |  |  |  | 1 |  | 5 | 팝업 선택값 반영 |
| E3 | EDIT |  |  |  |  |  |  | 4 |  |  | 필수 입력 검증 |
| DB-SYN | DB |  |  |  |  | 3 |  |  |  |  | BE 계정 시노님·권한·대상 객체 |
| C2 | CASCADE |  |  |  |  |  |  |  |  | 3 | 그리드 셀 cascade 후보 |
| F4 | DB |  |  |  |  |  |  |  |  | 3 | 저장·조회 SQL 오류 0(BE 로그 DB 오류 0) |
| A6 | GEN |  |  |  |  |  |  |  |  | 3 | 결과 행 정렬 순서 — AS-IS 정렬 방식(SQL ORDER BY / 그리드·코드 정렬) 그대로 · 분기별 키 순서 동일 · |
| X-REASON | DESIGN |  |  | 2 |  |  |  |  |  |  | 제외·해당없음 사유·근거(룰·지시·원문·이동 위치) 존재 — 근거 없으면 사람 확인 |
| M3 | POPUP |  |  |  |  |  |  |  |  | 2 | 팝업 내부 기능(조회·CRUD) · 팝업 목록 행수(조회조건 변경 후 포함) |
| X-NOTIMPL | GEN | 1 |  |  |  |  |  |  |  |  | 대조표 상태 미구현 = 구현 대상(FAIL) |
| I1 | DESIGN |  |  |  |  |  |  | 1 |  |  | LBL/MSG 언어별 등록 |
| G1 | GEN |  |  |  |  |  |  |  | 1 |  | 조회조건 값 변경 → 조회 인자·결과 반영 |
| J2 | AUTH |  |  |  |  |  |  |  |  | 1 | 권한별 버튼·기능 |
| K4 | COMMON |  |  |  |  |  |  |  |  | 1 | 버튼 구성·조건별 노출 |
| F1 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 DB 반영(마커 행) |
| F6 | CRUD |  |  |  |  |  |  |  |  | 1 | 저장 후 값 보존 |

## W1 기능 구현 (1)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0005-0001 | X-NOTIMPL | dead 콤보(Division/Site/BodType/dtFromCoun | FE(repairScope=DB_ONLY — 이번 범위 밖) | 대조표 미구현 행 구현 — dead 콤보(Division/Site/BodType/dtFromCountry/dtToCountry/dtYesOrNo) 미구현(신설 금지) design 02 §2.4 |  | 1 (dead 콤보(Division/Site/BodType/dtFromCoun) |

## W3 동작 수정 (5)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0005-0002 | X-REASON | COMMON:UC-03 | 사람판정(사람판정 대기) | X-REASON FAIL 수정 — COMMON:UC-03: [대조표 근거 없음] 요소 '컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 데이터 Reset 후 재조회' 제외 사유 'Measure 0(정적 39컬럼, SH |  | 1 (COMMON:UC-03) |
| WK-SCP0005-0003 | X-REASON | COMMON:UC-06 | 사람판정(사람판정 대기) | X-REASON FAIL 수정 — COMMON:UC-06: [대조표 근거 없음] 요소 'Key-in 조회조건 콤마 다중입력 전건 조회' 제외 사유 'TransMode 는 GET SP UF_FX_STRING_SPLIT 콤마 다중(des |  | 1 (COMMON:UC-06) |
| WK-SCP0005-0004 | E4 | MSG00043 | DB 객체(PKG/SP)(적용 예정) | E4 FAIL 수정 — MSG00043: 원장 V-3134fc3e (FX-SCP0005-017) |  | 1 (ACT:SCP0005_DistributionRoute.SaveData:8) |
| WK-SCP0005-0005 | E4 | MSG00043 | DB 객체(PKG/SP)(적용 예정) | E4 FAIL 수정 — MSG00043: 원장 V-3134fc3e ASIS (FX-SCP0005-017) |  | 1 (ACT:SCP0005_DistributionRoute.SaveData:8) |
| WK-SCP0005-0006 | X-ROW | SCP0005_DistributionRoute.SaveData | 화면 FE(범위 밖(가이드만)) | X-ROW FAIL 수정 — SCP0005_DistributionRoute.SaveData: 진입점 집계 33검사 — ERROR:15 · PASS:8 · NA:6 · FAIL:2 · NOPATH:1 · WARN:1 (FX-SCP000 |  | 3 (ACT:SCP0005_DistributionRoute.SaveData:6) |

## W5 검사기 연결 (9)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0005-0007 | DB-SYN | SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID | 없음(PROC_M 대응 없음) | 3 (ACT:SCP0005_DistributionRoutePopup.FindD) |
| WK-SCP0005-0008 | DB-SYN | SCP0005_GET_DISTRIBUTION_ROUTEID | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0005_GET_DISTRIBUTION_ROUTEID | 없음(PROC_M 대응 없음) | 3 (ACT:SCP0005_DistributionRoute.FindDataRe) |
| WK-SCP0005-0009 | DB-SYN | SCP0005_SAVE_DISTRIBUTION_ROUTE | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) + 구 | 검사기 연결 DB-SYN(syn_check.py·fixture dberr) → 대상 SP SCP0005_SAVE_DISTRIBUTION_ROUTE | 없음(PROC_M 대응 없음) | 2 (ACT:SCP0005_DistributionRoute.SaveData:7) |
| WK-SCP0005-0010 | G5 | FROM_CITY_NAME / City Name | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL FROM_CITY_NAME / City Name | 있음(SHEET_COLUMNS) | 4 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0011 | G5 | TO_CITY / City | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL TO_CITY / City | 있음(SHEET_COLUMNS) | 5 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0012 | G5 | TO_CITY_NAME / City Name | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 G5(popup_args_check.py · _verify.spec(@veri) → 대상 COL TO_CITY_NAME / City Name | 있음(SHEET_COLUMNS) | 3 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0013 | H6 | FROM_CITY_NAME / City Name | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL FROM_CITY_NAME / City Name | 있음(SHEET_COLUMNS) | 4 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0014 | H6 | TO_CITY / City | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL TO_CITY / City | 있음(SHEET_COLUMNS) | 5 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0015 | H6 | TO_CITY_NAME / City Name | 하네스(ledger.py 원장 항목 생성 또는 @trace 확장) | 검사기 연결 H6(_verify.spec(@verify)·smoke popup) → 대상 COL TO_CITY_NAME / City Name | 있음(SHEET_COLUMNS) | 3 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |

## W6 검증 실행 (2)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0005-0016 | H6 | txtFromCountry / From Country | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtFromCountry / From Country · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 5 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0017 | H6 | txtToCountry / To Country | E2E(smoke 스펙 생성·실행(🧪 E2E smoke) / @verif | H6 실행 — txtToCountry / To Country · 검사기 있음(_verify.spec(@verify)·smoke popup) — 실행 필요: smoke |  | 5 (txtToCountry/txtToCity + btnToSrch ACT:S) |

## W7 기대값 확정 (21)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0005-0018 | I1 | SCP0005 화면 | 사람 판정 / AS-IS 원문 확인 → 재판정 | I1 기대값 확정 — SCP0005 화면: 원장 V-29c34a39 RULE_SCREEN / 원장 V-38472e83 RULE_SCREEN / 원장 V-cad0bff9 RULE_SCREEN / 원장 V-27f623b5 DEFECT / |  | 15 (PRIORITY>=1 (MSG00107) FROM/TO City Name) |
| WK-SCP0005-0019 | E3 | DAYS / Departure Days | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — DAYS / Departure Days: AS-IS 필수 표시(grid_rule 라벨 *) 정보 없음 — TO-BE 필수=False |  | 1 (DAYS 최소 1 (MSG00223)) |
| WK-SCP0005-0020 | E3 | R16/R17 클라 검증 색칠 | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — R16/R17 클라 검증 색칠: 행 집계 — 대조표 R16/R17 클라 검증 색칠 '`validateRows`(전 편집행 누적, iter-2 G4) → `invalidCell' 의 E3 4요소: PASS:3 ·  |  | 1 (R16/R17 클라 검증 색칠) |
| WK-SCP0005-0021 | E3 | SaveButton | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — SaveButton: 행 집계 — 대조표 SaveButton '`hotkeyConfig.save`=handleSave (validate→saveWithV' 의 E3 4요소: PASS:3 · REVIEW:1 · F |  | 1 (SaveButton) |
| WK-SCP0005-0022 | E3 | 메타 필수(INPUT_TP_CD=M/IM) | 사람 판정 / AS-IS 원문 확인 → 재판정 | E3 기대값 확정 — 메타 필수(INPUT_TP_CD=M/IM): 행 집계 — 대조표 메타 필수(INPUT_TP_CD=M/IM) '`useSaveWithValidation`' 의 E3 4요소: PASS:3 · REVIEW:1 · FA |  | 1 (메타 필수(INPUT_TP_CD=M/IM)) |
| WK-SCP0005-0023 | A1 | COMMON:UC-07 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — COMMON:UC-07: 행 집계 — 대조표 COMMON:UC-07 '필터 걸린 상태 재조회해도 조회되고 필터도 유지(rebindFilterColumns)' 의 A1 4요소: PASS:2 · REVIEW:2 ·  |  | 1 (COMMON:UC-07) |
| WK-SCP0005-0024 | A1 | FindButton(Search) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindButton(Search): 행 집계 — 대조표 FindButton(Search) '`hotkeyConfig.search`=handleSearch (hasButton)' 의 A1 4요소: PASS:2 ·  |  | 1 (FindButton(Search)) |
| WK-SCP0005-0025 | A1 | FindDataMain 파라미터 6종 'ALL'→'' | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — FindDataMain 파라미터 6종 'ALL'→'': 행 집계 — 대조표 FindDataMain 파라미터 6종 'ALL'→'' 'store `setFilter()` `orEmpty()`' 의 A1 4요소: PA |  | 1 (FindDataMain 파라미터 6종 'ALL'→'') |
| WK-SCP0005-0026 | A1 | R7 조회 databind | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — R7 조회 databind: 행 집계 — 대조표 R7 조회 databind '`useTabProcQuery` o_rc1' 의 A1 4요소: PASS:2 · REVIEW:2 · FAIL 요소: SCP0005_GET |  | 1 (R7 조회 databind) |
| WK-SCP0005-0027 | A1 | SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID: 골든 비교 케이스 없음(SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID — 팝업·보조 SP 는 golden_ca |  | 14 (ACT:SCP0005_DistributionRoutePopup.FindB) |
| WK-SCP0005-0028 | A1 | SCP0005_GET_DISTRIBUTION_ROUTEID | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — SCP0005_GET_DISTRIBUTION_ROUTEID: golden SKIP AS-IS -1행 ↔ TO-BE -1행: Doc/golden/SCP0005/SCP0005_GET_DISTRIBUTION_ROUTE |  | 34 (ACT:SCP0005_DistributionRoute.FindButton) |
| WK-SCP0005-0029 | A1 | btnEaxel_Upload → ExcelUploadForm2 | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — btnEaxel_Upload → ExcelUploadForm2: 행 집계 — 대조표 btnEaxel_Upload → ExcelUploadForm2 "customButton 'Excel Upload' → `Exce |  | 1 (btnEaxel_Upload → ExcelUploadForm2) |
| WK-SCP0005-0030 | A1 | cascade(clbFromCountry→City) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cascade(clbFromCountry→City): 행 집계 — 대조표 cascade(clbFromCountry→City) '없음(주석 폐기) — 무cascade' 의 A1 4요소: PASS:2 · REVIEW |  | 1 (cascade(clbFromCountry→City)) |
| WK-SCP0005-0031 | A1 | cboValidYN (UsrCombo) | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — cboValidYN (UsrCombo): 행 집계 — 대조표 cboValidYN (UsrCombo) 'Form `CustomDropdown` 정적 ALL/Y/N (`VALID_OPTIONS`)' 의 A1 4요소: |  | 1 (cboValidYN (UsrCombo)) |
| WK-SCP0005-0032 | A1 | clbTransMode (UsrCheckedList **다중 체크** — | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — clbTransMode (UsrCheckedList **다중 체크** — Designer : 행 집계 — 대조표 clbTransMode (UsrCheckedList **다중 체크** — Designer ItemS |  | 1 (clbTransMode (UsrCheckedList **다중 체크** —) |
| WK-SCP0005-0033 | A1 | txtFromCountry/txtFromCity + btnFromSrch | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — txtFromCountry/txtFromCity + btnFromSrch: 행 집계 — 대조표 txtFromCountry/txtFromCity + btnFromSrch 'Form `InputField` 2 + 돋 |  | 1 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0034 | A1 | txtToCountry/txtToCity + btnToSrch | 사람 판정 / AS-IS 원문 확인 → 재판정 | A1 기대값 확정 — txtToCountry/txtToCity + btnToSrch: 행 집계 — 대조표 txtToCountry/txtToCity + btnToSrch 'Form `InputField` 2 + 돋보기 → `Region |  | 1 (txtToCountry/txtToCity + btnToSrch) |
| WK-SCP0005-0035 | X-ROW | SCP0005_DistributionRoute.FindDataMain | 사람 판정 / AS-IS 원문 확인 → 재판정 | X-ROW 기대값 확정 — SCP0005_DistributionRoute.FindDataMain: 진입점 집계 14검사 — PASS:9 · NA:4 · WARN:1 |  | 6 (ACT:SCP0005_DistributionRoute.FindDataMa) |
| WK-SCP0005-0036 | H6 | txtFromCity / From City | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — txtFromCity / From City: E2E smoke cond popup |  | 5 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0037 | H6 | txtToCity / To City | 사람 판정 / AS-IS 원문 확인 → 재판정 | H6 기대값 확정 — txtToCity / To City: E2E smoke cond popup |  | 5 (txtToCountry/txtToCity + btnToSrch ACT:S) |
| WK-SCP0005-0038 | M4 | SCP0005_DistributionRoutePopup | 사람 판정 / AS-IS 원문 확인 → 재판정 | M4 기대값 확정 — SCP0005_DistributionRoutePopup: 검증 엔진이 실행됐으나 이 대상(POPUP SCP0005_DistributionRoutePopup)을 판정하지 못함 — 팝업 선택값 반영 시나리오 수동 확 |  | 2 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |

## W8 구현 후 검증 (3)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0005-0039 | G4 | dead 콤보(Division/Site/BodType/dtFromCoun | 선행 W1 완료 후 E2E | G4 — 대조표 미구현 행 dead 콤보(Division/Site/BodType/dtFromCountry/dtToCountry/dtYe 구현 후 검증 · 대상 dead 콤보(Division/Site/BodType/dtFromCount |  | 1 (dead 콤보(Division/Site/BodType/dtFromCoun) |
| WK-SCP0005-0040 | A1 | dead 콤보(Division/Site/BodType/dtFromCoun | 선행 W1 완료 후 E2E | A1 — 대조표 미구현 행 dead 콤보(Division/Site/BodType/dtFromCountry/dtToCountry/dtYe 구현 후 검증 · 대상 dead 콤보(Division/Site/BodType/dtFromCount |  | 1 (dead 콤보(Division/Site/BodType/dtFromCoun) |
| WK-SCP0005-0041 | G1 | dead 콤보(Division/Site/BodType/dtFromCoun | 선행 W1 완료 후 E2E | G1 — 대조표 미구현 행 dead 콤보(Division/Site/BodType/dtFromCountry/dtToCountry/dtYe 구현 후 검증 · 대상 dead 콤보(Division/Site/BodType/dtFromCount |  | 1 (dead 콤보(Division/Site/BodType/dtFromCoun) |

## W9 도구 오류 (155)

| ID | 검사 | 대상 | 담당 | 할 일 | TO-BE 흔적 | 대조표 행 |
|---|---|---|---|---|---|---|
| WK-SCP0005-0042 | J2 | SCP0005 화면 | 하네스·환경 | J2 도구 오류 — 원장 V-69fd04d9 RULE_SCREEN / 원장 V-bbf3693b DEFECT / 원장 V-5eb41b96 GENERAL / 원장 V-f8acd0f3 GENERAL / 원장 V-d55bf254 GENERA |  | 50 (clbTransMode (UsrCheckedList **다중 체크** —) |
| WK-SCP0005-0043 | C2 | DAYS / Departure Days | 하네스·환경 | C2 도구 오류 — 실측[T-c7a43f16]: DAYS 연쇄 원천 해석 불가 — AS-IS  — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] 검 |  | 1 (R9 TRK/AIR→DAYS 7 'Y') |
| WK-SCP0005-0044 | C2 | PRIORITY / Priority | 하네스·환경 | C2 도구 오류 — 실측[T-6e75e40a]: PRIORITY 연쇄 원천 해석 불가 — AS-IS  — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검 |  | 1 (R1 숫자셀 범위(cellType)) |
| WK-SCP0005-0045 | C2 | R10 TRK→港/Forwarder 7 '-' | 하네스·환경 | C2 도구 오류 — 행 집계 — 대조표 R10 TRK→港/Forwarder 7 '-' '`portsDash()` cellEditEnded' 의 C2 25요소: NA:23 · ERROR:2 |  | 1 (R10 TRK→港/Forwarder 7 '-') |
| WK-SCP0005-0046 | C3 | DAYS / Departure Days | 하네스·환경 | C3 도구 오류 — 실측[T-4dd85db6]: DAYS 연쇄 원천 컬럼 해석 불가 — AS-IS  → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (R9 TRK/AIR→DAYS 7 'Y') |
| WK-SCP0005-0047 | C3 | FROM_CITY / City | 하네스·환경 | C3 도구 오류 — 실측[T-5edb7122]: [전제 미충족 T300] FROM_CITY: 원천 Site 후보 입력 실패(From '' · To '') — 연쇄 재현 불가 |  | 13 (ACT:SCP0005_DistributionRoute.SetCityCod) |
| WK-SCP0005-0048 | C3 | FROM_CITY_NAME / City Name | 하네스·환경 | C3 도구 오류 — 실측[T-1d878a60]: FROM_CITY_NAME: 원천 TO_CITY/FROM_CITY 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) → 기계 판정 불가 — 수동 |  | 6 (ACT:SCP0005_DistributionRoute.SetCityCod) |
| WK-SCP0005-0049 | C3 | FROM_COUNTRY / Country | 하네스·환경 | C3 도구 오류 — 실측[T-b82f895f]: [전제 미충족 T300] FROM_COUNTRY: 원천 Site 후보 입력 실패(From '' · To '') — 연쇄 재현 불가 |  | 14 (ACT:SCP0005_DistributionRoute.SetCityCod) |
| WK-SCP0005-0050 | C3 | LT_ARRIVAL_INLAND / Arrival Inland | 하네스·환경 | C3 도구 오류 — 원장 V-45774e2b ASIS / 원장 V-0bbfc3d1 ASIS / 원장 V-83ed8bd4 ASIS / 원장 V-11349024 ASIS / 원장 V-eab82e73 ASIS / 원장 V-03851efe  |  | 58 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0051 | C3 | LT_DEPARTURE_INLAND / Departure Inland | 하네스·환경 | C3 도구 오류 — 원장 V-83ed8bd4 ASIS / 원장 V-11349024 ASIS / 원장 V-eab82e73 ASIS / 실측[T-8953d4ba]: LT_DEPARTURE_INLAND: AS-IS 값 대입이 자기 칸 대입 |  | 4 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0052 | C3 | LT_LAY_OFF_CLEARANCE / Lay Off/Customs C | 하네스·환경 | C3 도구 오류 — 원장 V-11349024 ASIS / 원장 V-eab82e73 ASIS / 실측[T-305e2727]: LT_LAY_OFF_CLEARANCE: AS-IS 값 대입이 자기 칸 대입뿐(자기 칸 입력 거부 — 메시지 뒤 |  | 4 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0053 | C3 | LT_SUM | 하네스·환경 | C3 도구 오류 — 원장 V-03851efe |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0054 | C3 | LT_SUM | 하네스·환경 | C3 도구 오류 — 원장 V-63a7bd27 |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0055 | C3 | LT_SUM / Total L/T | 하네스·환경 | C3 도구 오류 — 원장 V-03851efe ASIS / 원장 V-63a7bd27 ASIS |  | 3 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0056 | C3 | LT_VOYAGE | 하네스·환경 | C3 도구 오류 — 원장 V-eab82e73 |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0057 | C3 | LT_VOYAGE / Voyage | 하네스·환경 | C3 도구 오류 — 원장 V-eab82e73 ASIS / 실측[T-a9cf4fcb]: LT_VOYAGE: AS-IS 값 대입이 자기 칸 대입뿐(자기 칸 입력 거부 — 메시지 뒤 고정 값으로 되돌림 · 메시지는 E4 에서 판정(T367 |  | 4 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0058 | C3 | LT_WAIT_SHIPPING / Waiting For Shipping | 하네스·환경 | C3 도구 오류 — 원장 V-0bbfc3d1 ASIS / 원장 V-83ed8bd4 ASIS / 원장 V-11349024 ASIS / 원장 V-eab82e73 ASIS / 실측[T-e776edc2]: LT_WAIT_SHIPPING: A |  | 4 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0059 | C3 | R10 TRK→港/Forwarder 7 '-' | 하네스·환경 | C3 도구 오류 — 행 집계 — 대조표 R10 TRK→港/Forwarder 7 '-' '`portsDash()` cellEditEnded' 의 C3 52요소: PASS:29 · ERROR:17 · NA:6 |  | 1 (R10 TRK→港/Forwarder 7 '-') |
| WK-SCP0005-0060 | C3 | SCP0005_DistributionRoute.SetCityCode | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0005_DistributionRoute.SetCityCode 의 C3 6요소: ERROR:6 |  | 4 (ACT:SCP0005_DistributionRoute.SetCityCod) |
| WK-SCP0005-0061 | C3 | SCP0005_DistributionRoute.SetImageCell | 하네스·환경 | C3 도구 오류 — 진입점 집계 — 대조표 SCP0005_DistributionRoute.SetImageCell 의 C3 5요소: ERROR:5 |  | 4 (ACT:SCP0005_DistributionRoute.SetImageCe) |
| WK-SCP0005-0062 | C3 | SCP0005_DistributionRoute.spdMainDataMod | 하네스·환경 | C3 도구 오류 — 원장 V-45774e2b ASIS / 원장 V-0bbfc3d1 ASIS / 원장 V-83ed8bd4 ASIS / 원장 V-11349024 ASIS / 원장 V-eab82e73 ASIS / 원장 V-03851efe  |  | 10 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0063 | C3 | TO_CITY / City | 하네스·환경 | C3 도구 오류 — 실측[T-653f2a16]: [전제 미충족 T300] TO_CITY: 원천 Site 후보 입력 실패(From '' · To '') — 연쇄 재현 불가 |  | 8 (ACT:SCP0005_DistributionRoute.SetCityCod) |
| WK-SCP0005-0064 | C3 | TO_CITY_NAME / City Name | 하네스·환경 | C3 도구 오류 — 실측[T-0803d2d0]: TO_CITY_NAME: 원천 TO_CITY 이 팝업을 여는 셀 — 값은 팝업 선택으로 채워진다(M4 팝업 선택값 반영 검사에서 판정) → 기계 판정 불가 — 수동 검수 대상(작업 원장 |  | 5 (ACT:SCP0005_DistributionRoute.SetCityCod) |
| WK-SCP0005-0065 | C3 | TO_COUNTRY / Country | 하네스·환경 | C3 도구 오류 — 실측[T-38e03b62]: [전제 미충족 T300] TO_COUNTRY: 원천 Site 후보 입력 실패(From '' · To '') — 연쇄 재현 불가 |  | 8 (ACT:SCP0005_DistributionRoute.SetCityCod) |
| WK-SCP0005-0066 | C3 | VALID_YN / Valid | 하네스·환경 | C3 도구 오류 — 실측[T-8b3ad504]: VALID_YN 연쇄 원천 컬럼 해석 불가 — AS-IS InsertRow:947 siMain.SetValue(siMain.ActiveRowIndex, siMain.GetColumnIn |  | 1 (ACT:SCP0005_DistributionRoute.InsertRow:) |
| WK-SCP0005-0067 | C6 | DAYS / Departure Days | 하네스·환경 | C6 도구 오류 — 실측[T-dc040561]: DAYS 연쇄 원천 해석 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] 검사기(_verif |  | 1 (R9 TRK/AIR→DAYS 7 'Y') |
| WK-SCP0005-0068 | C6 | LT_ARRIVAL_INLAND / Arrival Inland | 하네스·환경 | C6 도구 오류 — 원장 V-a043bf5c ASIS / 원장 V-4ce029f5 ASIS / 원장 V-4ad20009 ASIS / 원장 V-3fa9771e ASIS / 원장 V-fe2b3762 ASIS / 원장 V-1bfaee71  |  | 58 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0069 | C6 | LT_DEPARTURE_INLAND | 하네스·환경 | C6 도구 오류 — 원장 V-4ad20009 |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0070 | C6 | LT_DEPARTURE_INLAND / Departure Inland | 하네스·환경 | C6 도구 오류 — 원장 V-4ad20009 ASIS / 원장 V-3fa9771e ASIS / 원장 V-fe2b3762 ASIS / 실측[T-39282451]: LT_ARRIVAL_INLAND 셀을 열었다가 값을 바꾸지 않고 닫음(더 |  | 4 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0071 | C6 | LT_LAY_OFF_CLEARANCE | 하네스·환경 | C6 도구 오류 — 원장 V-3fa9771e |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0072 | C6 | LT_LAY_OFF_CLEARANCE / Lay Off/Customs C | 하네스·환경 | C6 도구 오류 — 원장 V-3fa9771e ASIS / 원장 V-fe2b3762 ASIS / 실측[T-07dc1388]: LT_ARRIVAL_INLAND 셀을 열었다가 값을 바꾸지 않고 닫음(더블클릭+Esc) → LT_LAY_OFF |  | 4 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0073 | C6 | LT_WAIT_SHIPPING | 하네스·환경 | C6 도구 오류 — 원장 V-4ce029f5 |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0074 | C6 | LT_WAIT_SHIPPING / Waiting For Shipping | 하네스·환경 | C6 도구 오류 — 원장 V-4ce029f5 ASIS / 원장 V-4ad20009 ASIS / 원장 V-3fa9771e ASIS / 원장 V-fe2b3762 ASIS / 실측[T-488e25b7]: LT_ARRIVAL_INLAND 셀 |  | 4 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0075 | C6 | PRIORITY / Priority | 하네스·환경 | C6 도구 오류 — 실측[T-6e2ef7c8]: PRIORITY 연쇄 원천 해석 불가 — 검사기가 원천 셀을 열 수 없어 측정하지 못함(검사기 한계 · 화면 오류 아님) → 수동 검수 대상(작업 원장 W7) / [미검증] 검사기(_v |  | 1 (R1 숫자셀 범위(cellType)) |
| WK-SCP0005-0076 | C6 | R10 TRK→港/Forwarder 7 '-' | 하네스·환경 | C6 도구 오류 — 행 집계 — 대조표 R10 TRK→港/Forwarder 7 '-' '`portsDash()` cellEditEnded' 의 C6 46요소: PASS:35 · ERROR:9 · NA:2 |  | 1 (R10 TRK→港/Forwarder 7 '-') |
| WK-SCP0005-0077 | C6 | SCP0005_DistributionRoute.spdMainDataMod | 하네스·환경 | C6 도구 오류 — 원장 V-a043bf5c ASIS / 원장 V-4ce029f5 ASIS / 원장 V-4ad20009 ASIS / 원장 V-3fa9771e ASIS / 원장 V-fe2b3762 ASIS / 원장 V-1bfaee71  |  | 10 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0078 | K4 | SCP0005 화면 | 하네스·환경 | K4 도구 오류 — 원장 V-4da2eeab GENERAL / 원장 V-971d34fe GENERAL / 원장 V-df84cd6a GENERAL / 원장 V-88b2cf80 GENERAL / 원장 V-7990c634 GENERAL / |  | 33 (COMMON:UC-01 COMMON:UC-04 COMMON:UC-05 C) |
| WK-SCP0005-0079 | F1 | SCP0005 화면 | 하네스·환경 | F1 도구 오류 — 원장 V-c9c3b04a RULE_SCREEN / 원장 V-4e4af2a4 RULE_SCREEN / 원장 V-ed1875e6 RULE_SCREEN / 원장 V-26d2974c RULE_SCREEN / 원장 V-69 |  | 202 (R14/R15 저장응답 색칠(99010/99020) R18 Insert/) |
| WK-SCP0005-0080 | F6 | SCP0005 화면 | 하네스·환경 | F6 도구 오류 — 원장 V-77a721bf RULE_SCREEN / 원장 V-337cb2f9 RULE_SCREEN / 원장 V-189ec7ae RULE_SCREEN / 원장 V-72fbb5b2 RULE_SCREEN / 원장 V-71 |  | 193 (ACT:SCP0005_DistributionRoute.SaveButton) |
| WK-SCP0005-0081 | F4 | FindDataMain 파라미터 6종 'ALL'→'' | 하네스·환경 | F4 도구 오류 — 행 집계 — 대조표 FindDataMain 파라미터 6종 'ALL'→'' 'store `setFilter()` `orEmpty()`' 의 F4 5요소: PASS:3 · ERROR:2 |  | 1 (FindDataMain 파라미터 6종 'ALL'→'') |
| WK-SCP0005-0082 | F4 | SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID | 하네스·환경 | F4 도구 오류 — 실측[T-ea530cd5]: SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID: SCP0005/route/SEARCH_ROUTEID — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회 경 |  | 14 (ACT:SCP0005_DistributionRoutePopup.FindB) |
| WK-SCP0005-0083 | F4 | SCP0005_GET_DISTRIBUTION_ROUTEID | 하네스·환경 | F4 도구 오류 — 실측[T-719d403c]: SCP0005_GET_DISTRIBUTION_ROUTEID: SCP0005/route/SEARCH_ROUTEID — 화면 진입·조회 중 호출 없음(셀 이벤트·팝업 조회 경로 — 해당 시 |  | 34 (ACT:SCP0005_DistributionRoute.FindButton) |
| WK-SCP0005-0084 | A5 | COMMON:UC-07 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터 걸린 상태 재조회해도 조회되고 필터도 유지(rebindFilterColumns)' 의 A5 16요소: PASS:15 · ERROR:1 |  | 1 (COMMON:UC-07) |
| WK-SCP0005-0085 | A5 | DAYS / Departure Days | 하네스·환경 | A5 도구 오류 — E2E smoke columns / 실측[T-aa4e2eb2]: DAYS: [측정 경로 없음] AS-IS 시트 ? 의 TO-BE 그리드를 화면에서 찾지 못함 — 표시 여부 미측정(T203) |  | 1 (R9 TRK/AIR→DAYS 7 'Y') |
| WK-SCP0005-0086 | A5 | DB메타 구동(gridColumns=[]) | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 DB메타 구동(gridColumns=[]) "`staticColumns` admin fetch(`ADMIN_SHEET_NAME`='Di" 의 A5 16요소: PASS:15 · ERROR:1 |  | 1 (DB메타 구동(gridColumns=[])) |
| WK-SCP0005-0087 | A5 | R10 TRK→港/Forwarder 7 '-' | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 R10 TRK→港/Forwarder 7 '-' '`portsDash()` cellEditEnded' 의 A5 16요소: PASS:15 · ERROR:1 |  | 1 (R10 TRK→港/Forwarder 7 '-') |
| WK-SCP0005-0088 | A5 | R11/R12 FROM/TO 셀 더블클릭→도시팝업 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 R11/R12 FROM/TO 셀 더블클릭→도시팝업 '`onFromCellDblClick`/`onToCellDblClick`→`RegionMod' 의 A5 16요소: PASS:15 · ERROR: |  | 1 (R11/R12 FROM/TO 셀 더블클릭→도시팝업) |
| WK-SCP0005-0089 | A5 | R16/R17 클라 검증 색칠 | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 R16/R17 클라 검증 색칠 '`validateRows`(전 편집행 누적, iter-2 G4) → `invalidCell' 의 A5 16요소: PASS:15 · ERROR:1 |  | 1 (R16/R17 클라 검증 색칠) |
| WK-SCP0005-0090 | A5 | R18 Insert/Delete | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 R18 Insert/Delete '`GridAction.addRow` / `removeRow(grid, true)`(신규만)' 의 A5 16요소: PASS:15 · ERROR:1 |  | 1 (R18 Insert/Delete) |
| WK-SCP0005-0091 | A5 | R7 조회 databind | 하네스·환경 | A5 도구 오류 — 행 집계 — 대조표 R7 조회 databind '`useTabProcQuery` o_rc1' 의 A5 16요소: PASS:15 · ERROR:1 |  | 1 (R7 조회 databind) |
| WK-SCP0005-0092 | G4 | FindDataMain 파라미터 6종 'ALL'→'' | 하네스·환경 | G4 도구 오류 — 행 집계 — 대조표 FindDataMain 파라미터 6종 'ALL'→'' 'store `setFilter()` `orEmpty()`' 의 G4 9요소: ERROR:7 · PASS:2 |  | 1 (FindDataMain 파라미터 6종 'ALL'→'') |
| WK-SCP0005-0093 | G4 | btnEaxel | 하네스·환경 | G4 도구 오류 — 실측[T-eb5343b6]: [측정 경로 없음] AS-IS btnEaxel 클릭 메서드가 popup_args.csv 에 없음(팝업을 여는 버튼인지 미확인) |  | 2 (ACT:SCP0005_DistributionRoute.InitEvent ) |
| WK-SCP0005-0094 | G4 | btnFromSrch | 하네스·환경 | G4 도구 오류 — 실측[T-85f3a8bb]: [측정 경로 없음] AS-IS btnFromSrch 클릭 메서드가 popup_args.csv 에 없음(팝업을 여는 버튼인지 미확인) |  | 1 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0095 | G4 | btnToSrch | 하네스·환경 | G4 도구 오류 — 실측[T-7e1a41bb]: [측정 경로 없음] AS-IS btnToSrch 클릭 메서드가 popup_args.csv 에 없음(팝업을 여는 버튼인지 미확인) |  | 1 (txtToCountry/txtToCity + btnToSrch) |
| WK-SCP0005-0096 | G4 | cascade(clbFromCountry→City) | 하네스·환경 | G4 도구 오류 — 행 집계 — 대조표 cascade(clbFromCountry→City) '없음(주석 폐기) — 무cascade' 의 G4 9요소: ERROR:7 · PASS:2 |  | 1 (cascade(clbFromCountry→City)) |
| WK-SCP0005-0097 | G4 | txtFromCity / From City | 하네스·환경 | G4 도구 오류 — E2E smoke labels / 실측[T-88891164]: r0 ROUTE_ID 더블클릭 → 팝업 열림 감지 실패(검사기 미검증) |  | 1 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0098 | G4 | txtFromCountry / From Country | 하네스·환경 | G4 도구 오류 — E2E smoke labels / 실측[T-9b463365]: r0 ROUTE_ID 더블클릭 → 팝업 열림 감지 실패(검사기 미검증) |  | 1 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0099 | G4 | txtToCity / To City | 하네스·환경 | G4 도구 오류 — E2E smoke labels / 실측[T-90d2d30f]: r0 ROUTE_ID 더블클릭 → 팝업 열림 감지 실패(검사기 미검증) |  | 1 (txtToCountry/txtToCity + btnToSrch) |
| WK-SCP0005-0100 | G4 | txtToCountry / To Country | 하네스·환경 | G4 도구 오류 — E2E smoke labels / 실측[T-6d65f303]: r0 ROUTE_ID 더블클릭 → 팝업 열림 감지 실패(검사기 미검증) |  | 1 (txtToCountry/txtToCity + btnToSrch) |
| WK-SCP0005-0101 | H2 | COMMON:UC-07 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터 걸린 상태 재조회해도 조회되고 필터도 유지(rebindFilterColumns)' 의 H2 31요소: ERROR:19 · PASS:11 · NA:1 |  | 1 (COMMON:UC-07) |
| WK-SCP0005-0102 | H2 | DB메타 구동(gridColumns=[]) | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 DB메타 구동(gridColumns=[]) "`staticColumns` admin fetch(`ADMIN_SHEET_NAME`='Di" 의 H2 31요소: ERROR:19 · PASS:11 · |  | 1 (DB메타 구동(gridColumns=[])) |
| WK-SCP0005-0103 | H2 | D_PORT_NAME / Port | 하네스·환경 | H2 도구 오류 — 원장 V-0bef758e COLUMN / 원장 V-0271c876 COLUMN / 원장 V-bc631885 ASIS / 실측[T-ef596679]: D_PORT_NAME: 기존행 편집=true 표시 일치 · 신규행 |  | 1 (ACT:SCP0005_DistributionRoute.SaveData:8) |
| WK-SCP0005-0104 | H2 | D_PORT_NAME,TO_CITY | 하네스·환경 | H2 도구 오류 — 원장 V-bc631885 |  | 1 (ACT:SCP0005_DistributionRoute.SaveData:8) |
| WK-SCP0005-0105 | H2 | FROM_CITY | 하네스·환경 | H2 도구 오류 — 원장 V-0810a59e |  | 1 (ACT:SCP0005_DistributionRoute.CheckValid) |
| WK-SCP0005-0106 | H2 | FROM_CITY | 하네스·환경 | H2 도구 오류 — 원장 V-17e451a7 |  | 1 (ACT:SCP0005_DistributionRoute.CheckValid) |
| WK-SCP0005-0107 | H2 | FROM_CITY / City | 하네스·환경 | H2 도구 오류 — 원장 V-a15f8422 COLUMN / 원장 V-8854335a COLUMN / 원장 V-0810a59e ASIS / 원장 V-17e451a7 ASIS / 원장 V-06e7dec2 ASIS / 실측[T-44723 |  | 5 (ACT:SCP0005_DistributionRoute.CheckValid) |
| WK-SCP0005-0108 | H2 | FROM_CITY_NAME / City Name | 하네스·환경 | H2 도구 오류 — 원장 V-db9114d5 COLUMN / 원장 V-6a920d4c COLUMN / 원장 V-06e7dec2 ASIS / 실측[T-8edcf6b2]: FROM_CITY_NAME: 기존행 편집=false 표시 일치 · |  | 2 (ACT:SCP0005_DistributionRoute.SaveData:8) |
| WK-SCP0005-0109 | H2 | FROM_CITY_NAME,FROM_CITY | 하네스·환경 | H2 도구 오류 — 원장 V-06e7dec2 |  | 1 (ACT:SCP0005_DistributionRoute.SaveData:8) |
| WK-SCP0005-0110 | H2 | LT_TYPE / L/T Type | 하네스·환경 | H2 도구 오류 — 원장 V-cf9f292a COLUMN / 원장 V-ce0c227b COLUMN / 원장 V-b6f27092 ASIS / 실측[T-f5ade244]: LT_TYPE: 신규행 편집=true 표시 일치 |  | 1 (ACT:SCP0005_DistributionRoute.SaveData:8) |
| WK-SCP0005-0111 | H2 | LT_TYPE,TRANSPORT_MODE | 하네스·환경 | H2 도구 오류 — 원장 V-b6f27092 |  | 1 (ACT:SCP0005_DistributionRoute.SaveData:8) |
| WK-SCP0005-0112 | H2 | PRIORITY / Priority | 하네스·환경 | H2 도구 오류 — 원장 V-a4b02e55 COLUMN / 원장 V-e43b6ce9 COLUMN / 원장 V-b4651880 ASIS / 원장 V-fa71e89c ASIS / 실측[T-a86cad2c]: PRIORITY: 신규행 편 |  | 7 (R1 숫자셀 범위(cellType) R14/R15 저장응답 색칠(9901) |
| WK-SCP0005-0113 | H2 | PRIORITY,PRIORITY | 하네스·환경 | H2 도구 오류 — 원장 V-fa71e89c |  | 1 (ACT:SCP0005_DistributionRoute.SaveData:8) |
| WK-SCP0005-0114 | H2 | R10 TRK→港/Forwarder 7 '-' | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 R10 TRK→港/Forwarder 7 '-' '`portsDash()` cellEditEnded' 의 H2 31요소: ERROR:19 · PASS:11 · NA:1 |  | 1 (R10 TRK→港/Forwarder 7 '-') |
| WK-SCP0005-0115 | H2 | R11/R12 FROM/TO 셀 더블클릭→도시팝업 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 R11/R12 FROM/TO 셀 더블클릭→도시팝업 '`onFromCellDblClick`/`onToCellDblClick`→`RegionMod' 의 H2 31요소: ERROR:19 · PASS: |  | 1 (R11/R12 FROM/TO 셀 더블클릭→도시팝업) |
| WK-SCP0005-0116 | H2 | R16/R17 클라 검증 색칠 | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 R16/R17 클라 검증 색칠 '`validateRows`(전 편집행 누적, iter-2 G4) → `invalidCell' 의 H2 31요소: ERROR:19 · PASS:11 · NA:1 |  | 1 (R16/R17 클라 검증 색칠) |
| WK-SCP0005-0117 | H2 | R18 Insert/Delete | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 R18 Insert/Delete '`GridAction.addRow` / `removeRow(grid, true)`(신규만)' 의 H2 31요소: ERROR:19 · PASS:11 · NA:1 |  | 1 (R18 Insert/Delete) |
| WK-SCP0005-0118 | H2 | R7 조회 databind | 하네스·환경 | H2 도구 오류 — 행 집계 — 대조표 R7 조회 databind '`useTabProcQuery` o_rc1' 의 H2 31요소: ERROR:19 · PASS:11 · NA:1 |  | 1 (R7 조회 databind) |
| WK-SCP0005-0119 | H2 | SCP0005_DistributionRoute.CreateSpread | 하네스·환경 | H2 도구 오류 — 진입점 집계 — 대조표 SCP0005_DistributionRoute.CreateSpread 의 H2 31요소: ERROR:19 · PASS:11 · NA:1 |  | 5 (ACT:SCP0005_DistributionRoute.CreateSpre) |
| WK-SCP0005-0120 | H2 | SCP0005_DistributionRoute.SetImageCell | 하네스·환경 | H2 도구 오류 — 진입점 집계 — 대조표 SCP0005_DistributionRoute.SetImageCell 의 H2 5요소: ERROR:3 · PASS:2 |  | 4 (ACT:SCP0005_DistributionRoute.SetImageCe) |
| WK-SCP0005-0121 | H2 | TO_CITY | 하네스·환경 | H2 도구 오류 — 원장 V-c099fa4f |  | 1 (ACT:SCP0005_DistributionRoute.CheckValid) |
| WK-SCP0005-0122 | H2 | TO_CITY | 하네스·환경 | H2 도구 오류 — 원장 V-e63ff383 |  | 1 (ACT:SCP0005_DistributionRoute.CheckValid) |
| WK-SCP0005-0123 | H2 | TO_CITY / City | 하네스·환경 | H2 도구 오류 — 원장 V-2c0c4c1d COLUMN / 원장 V-a613e1d5 COLUMN / 원장 V-c099fa4f ASIS / 원장 V-e63ff383 ASIS / 원장 V-bc631885 ASIS / 원장 V-dc54e |  | 6 (ACT:SCP0005_DistributionRoute.CheckValid) |
| WK-SCP0005-0124 | H2 | TO_CITY_NAME / City Name | 하네스·환경 | H2 도구 오류 — 원장 V-706ad28d COLUMN / 원장 V-b8e610ca COLUMN / 원장 V-dc54eed4 ASIS / 실측[T-910b4f21]: TO_CITY_NAME: 신규행 편집=false 표시 일치 |  | 1 (ACT:SCP0005_DistributionRoute.SaveData:8) |
| WK-SCP0005-0125 | H2 | TO_CITY_NAME,TO_CITY | 하네스·환경 | H2 도구 오류 — 원장 V-dc54eed4 |  | 1 (ACT:SCP0005_DistributionRoute.SaveData:8) |
| WK-SCP0005-0126 | H2 | TRANSPORT_MODE / Trans Mode | 하네스·환경 | H2 도구 오류 — 원장 V-8ccd91b6 COLUMN / 원장 V-b6f27092 ASIS / 실측[T-87ff0355]: TRANSPORT_MODE: 기존행 편집=true 표시 일치 · 신규행 편집=true 표시 일치 |  | 1 (ACT:SCP0005_DistributionRoute.SaveData:8) |
| WK-SCP0005-0127 | H2 | siMain.SetBGColor | 하네스·환경 | H2 도구 오류 — 원장 V-c56bdc72 |  | 1 (ACT:SCP0005_DistributionRoute.CheckValid) |
| WK-SCP0005-0128 | H2 | siMain.SetBGColor | 하네스·환경 | H2 도구 오류 — 원장 V-b4651880 |  | 1 (ACT:SCP0005_DistributionRoute.CheckValid) |
| WK-SCP0005-0129 | H5 | COMMON:UC-07 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 COMMON:UC-07 '필터 걸린 상태 재조회해도 조회되고 필터도 유지(rebindFilterColumns)' 의 H5 16요소: PASS:15 · ERROR:1 |  | 1 (COMMON:UC-07) |
| WK-SCP0005-0130 | H5 | DAYS / Departure Days | 하네스·환경 | H5 도구 오류 — 실측[T-d786155a]: DAYS 현재 그리드에 없음 — 표시 여부는 A5 → 기계 판정 불가 — 수동 검수 대상(작업 원장 W7) |  | 1 (R9 TRK/AIR→DAYS 7 'Y') |
| WK-SCP0005-0131 | H5 | DB메타 구동(gridColumns=[]) | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 DB메타 구동(gridColumns=[]) "`staticColumns` admin fetch(`ADMIN_SHEET_NAME`='Di" 의 H5 16요소: PASS:15 · ERROR:1 |  | 1 (DB메타 구동(gridColumns=[])) |
| WK-SCP0005-0132 | H5 | R10 TRK→港/Forwarder 7 '-' | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 R10 TRK→港/Forwarder 7 '-' '`portsDash()` cellEditEnded' 의 H5 16요소: PASS:15 · ERROR:1 |  | 1 (R10 TRK→港/Forwarder 7 '-') |
| WK-SCP0005-0133 | H5 | R11/R12 FROM/TO 셀 더블클릭→도시팝업 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 R11/R12 FROM/TO 셀 더블클릭→도시팝업 '`onFromCellDblClick`/`onToCellDblClick`→`RegionMod' 의 H5 16요소: PASS:15 · ERROR: |  | 1 (R11/R12 FROM/TO 셀 더블클릭→도시팝업) |
| WK-SCP0005-0134 | H5 | R16/R17 클라 검증 색칠 | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 R16/R17 클라 검증 색칠 '`validateRows`(전 편집행 누적, iter-2 G4) → `invalidCell' 의 H5 16요소: PASS:15 · ERROR:1 |  | 1 (R16/R17 클라 검증 색칠) |
| WK-SCP0005-0135 | H5 | R18 Insert/Delete | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 R18 Insert/Delete '`GridAction.addRow` / `removeRow(grid, true)`(신규만)' 의 H5 16요소: PASS:15 · ERROR:1 |  | 1 (R18 Insert/Delete) |
| WK-SCP0005-0136 | H5 | R7 조회 databind | 하네스·환경 | H5 도구 오류 — 행 집계 — 대조표 R7 조회 databind '`useTabProcQuery` o_rc1' 의 H5 16요소: PASS:15 · ERROR:1 |  | 1 (R7 조회 databind) |
| WK-SCP0005-0137 | H5 | SCP0005_DistributionRoute.CreateSpread | 하네스·환경 | H5 도구 오류 — 진입점 집계 — 대조표 SCP0005_DistributionRoute.CreateSpread 의 H5 16요소: PASS:15 · ERROR:1 |  | 5 (ACT:SCP0005_DistributionRoute.CreateSpre) |
| WK-SCP0005-0138 | D1 | EditButton (SwitchLock 편집모드) | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 EditButton (SwitchLock 편집모드) 'NSCM 상시편집 표준으로 대체(Edit 토글 없음) — 셀별 editLock 판정' 의 D1 8요소: ERROR:5 · NA:2 · PAS |  | 1 (EditButton (SwitchLock 편집모드)) |
| WK-SCP0005-0139 | D1 | FROM_CITY_NAME / City Name | 하네스·환경 | D1 도구 오류 — 원장 V-df2c464d COLUMN / 원장 V-a0234e02 COLUMN / 원장 V-efd885dd COLUMN / 원장 V-a2b3892f COLUMN / 실측[T-174d521f]: 기존행 r0 FROM |  | 3 (ACT:SCP0005_DistributionRoute.EditButton) |
| WK-SCP0005-0140 | D1 | LAST_UPDATE_DATE / Last Update Date | 하네스·환경 | D1 도구 오류 — 원장 V-56bec2fe COLUMN / 원장 V-e47bace2 COLUMN / 원장 V-1afc1aeb COLUMN / 원장 V-ae463842 COLUMN / 실측[T-6e051073]: 기존행 r0 LAST |  | 2 (ACT:SCP0005_DistributionRoute.EditButton) |
| WK-SCP0005-0141 | D1 | LT_SUM / Total L/T | 하네스·환경 | D1 도구 오류 — 원장 V-746e5bbe COLUMN / 원장 V-8da4b077 COLUMN / 원장 V-c7abf566 COLUMN / 원장 V-df790ade COLUMN / 원장 V-d72694b1 COLUMN / 원장 V |  | 4 (R3/R4/R5 편집잠금(ROUTE_ID/CITY_NAME/LT_SUM/) |
| WK-SCP0005-0142 | D1 | R16/R17 클라 검증 색칠 | 하네스·환경 | D1 도구 오류 — 행 집계 — 대조표 R16/R17 클라 검증 색칠 '`validateRows`(전 편집행 누적, iter-2 G4) → `invalidCell' 의 D1 8요소: ERROR:5 · NA:2 · PASS:1 |  | 1 (R16/R17 클라 검증 색칠) |
| WK-SCP0005-0143 | D1 | ROUTE_ID / Route Id | 하네스·환경 | D1 도구 오류 — 원장 V-d98f259a COLUMN / 원장 V-954cbe66 COLUMN / 원장 V-e8602478 COLUMN / 원장 V-c09178ce COLUMN / 원장 V-f069cc0b COLUMN / 원장 V |  | 7 (R3/R4/R5 편집잠금(ROUTE_ID/CITY_NAME/LT_SUM/) |
| WK-SCP0005-0144 | D1 | SCP0005_DistributionRoute.EditButton | 하네스·환경 | D1 도구 오류 — 진입점 집계 — 대조표 SCP0005_DistributionRoute.EditButton 의 D1 6요소: ERROR:5 · PASS:1 |  | 1 (ACT:SCP0005_DistributionRoute.EditButton) |
| WK-SCP0005-0145 | D1 | TO_CITY_NAME / City Name | 하네스·환경 | D1 도구 오류 — 원장 V-0039c48a COLUMN / 원장 V-56c2ac4f COLUMN / 원장 V-5f5baa0d COLUMN / 원장 V-6d214120 COLUMN / 실측[T-2360259a]: 기존행 r0 TO_C |  | 3 (ACT:SCP0005_DistributionRoute.EditButton) |
| WK-SCP0005-0146 | E4 | LT_ARRIVAL_INLAND / Arrival Inland | 하네스·환경 | E4 도구 오류 — 원장 V-3e95d2be ASIS / 실측[T-eea49685]: MSG00209 — spdMainDataModel_Changed 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작  |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0147 | E4 | MSG00209 | 하네스·환경 | E4 도구 오류 — 원장 V-3e95d2be / 실측[T-dba493fd]: MSG00209 — spdMainDataModel_Changed 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오( |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0148 | E4 | MSG00209 | 하네스·환경 | E4 도구 오류 — 원장 V-3e95d2be ASIS / 실측[T-6a512ae5]: MSG00209 — spdMainDataModel_Changed 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작  |  | 1 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0149 | E4 | MSG00265 | 하네스·환경 | E4 도구 오류 — 원장 V-4a0b6271 / 실측[T-2c4e7c8a]: MSG00265 — btnEaxel_Upload_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리오(btn |  | 1 (ACT:SCP0005_DistributionRoute.btnEaxel_U) |
| WK-SCP0005-0150 | E4 | MSG00265 | 하네스·환경 | E4 도구 오류 — 원장 V-4a0b6271 ASIS / 실측[T-e19b6757]: MSG00265 — btnEaxel_Upload_Click 경로 메시지(저장 전 검증 아님 · Save 진입점에서 닿지 않음) — 해당 동작 시나리 |  | 1 (ACT:SCP0005_DistributionRoute.btnEaxel_U) |
| WK-SCP0005-0151 | A6 | FindDataMain 파라미터 6종 'ALL'→'' | 하네스·환경 | A6 도구 오류 — 행 집계 — 대조표 FindDataMain 파라미터 6종 'ALL'→'' 'store `setFilter()` `orEmpty()`' 의 A6 4요소: PASS:2 · ERROR:2 |  | 1 (FindDataMain 파라미터 6종 'ALL'→'') |
| WK-SCP0005-0152 | A6 | SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID | 하네스·환경 | A6 도구 오류 — 원장 V-f574c4a3 SP / 정렬대조 REVIEW TO-BE 프로시저 배선(PROC_M) 없음 — 대응 프로시저 확인 / 실측[T-336fa068]: SCP0005_GET_DISTRIBUTION_HISTORY |  | 14 (ACT:SCP0005_DistributionRoutePopup.FindB) |
| WK-SCP0005-0153 | A6 | SCP0005_GET_DISTRIBUTION_ROUTEID | 하네스·환경 | A6 도구 오류 — 원장 V-fc7cfdc8 SP / 정렬대조 REVIEW TO-BE 프로시저 배선(PROC_M) 없음 — 대응 프로시저 확인 / 실측[T-2f7778bd]: SCP0005_GET_DISTRIBUTION_ROUTEID |  | 34 (ACT:SCP0005_DistributionRoute.FindButton) |
| WK-SCP0005-0154 | X-ROW | SCP0005_DistributionRoute.CheckValid | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 14검사 — ERROR:8 · PASS:3 · NA:2 · WARN:1 |  | 39 (ACT:SCP0005_DistributionRoute.CheckValid) |
| WK-SCP0005-0155 | X-ROW | SCP0005_DistributionRoute.CreateSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — PASS:2 · ERROR:2 |  | 1 (ACT:SCP0005_DistributionRoute.CreateSpre) |
| WK-SCP0005-0156 | X-ROW | SCP0005_DistributionRoute.FindButton | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 9검사 — PASS:6 · ERROR:2 · REVIEW:1 |  | 1 (ACT:SCP0005_DistributionRoute.FindButton) |
| WK-SCP0005-0157 | X-ROW | SCP0005_DistributionRoute.FindDataReceiv | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 8검사 — ERROR:2 · NA:2 · REVIEW:1 · NOPATH:1 · PASS:1 · WARN:1 |  | 7 (ACT:SCP0005_DistributionRoute.FindDataRe) |
| WK-SCP0005-0158 | X-ROW | SCP0005_DistributionRoute.InitEvent | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 3검사 — NA:1 · PASS:1 · ERROR:1 |  | 1 (ACT:SCP0005_DistributionRoute.InitEvent) |
| WK-SCP0005-0159 | X-ROW | SCP0005_DistributionRoute.InitSpread | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 29검사 — PASS:28 · ERROR:1 |  | 1 (ACT:SCP0005_DistributionRoute.InitSpread) |
| WK-SCP0005-0160 | X-ROW | SCP0005_DistributionRoute.InsertRow | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 18검사 — PASS:12 · ERROR:6 |  | 13 (ACT:SCP0005_DistributionRoute.InsertRow ) |
| WK-SCP0005-0161 | X-ROW | SCP0005_DistributionRoute.SetImageCell | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 36검사 — PASS:16 · ERROR:10 · NA:10 |  | 4 (ACT:SCP0005_DistributionRoute.SetImageCe) |
| WK-SCP0005-0162 | X-ROW | SCP0005_DistributionRoute.btnEaxel_Uploa | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 7검사 — ERROR:6 · WARN:1 |  | 4 (ACT:SCP0005_DistributionRoute.btnEaxel_U) |
| WK-SCP0005-0163 | X-ROW | SCP0005_DistributionRoute.btnFromSrch_Cl | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 15검사 — ERROR:6 · PASS:6 · NOT_RUN:1 · NA:1 · WARN:1 |  | 3 (ACT:SCP0005_DistributionRoute.btnFromSrc) |
| WK-SCP0005-0164 | X-ROW | SCP0005_DistributionRoute.btnToSrch_Clic | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 15검사 — ERROR:6 · PASS:6 · NOT_RUN:1 · WARN:1 · NA:1 |  | 3 (ACT:SCP0005_DistributionRoute.btnToSrch_) |
| WK-SCP0005-0165 | X-ROW | SCP0005_DistributionRoute.spdMainDataMod | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 119검사 — PASS:64 · NA:31 · ERROR:23 · WARN:1 |  | 21 (ACT:SCP0005_DistributionRoute.spdMainDat) |
| WK-SCP0005-0166 | X-ROW | SCP0005_DistributionRoute.spdMain_CellDo | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 44검사 — ERROR:13 · PASS:12 · NA:12 · NOPATH:6 · NOT_RUN:1 |  | 11 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0167 | X-ROW | SCP0005_DistributionRoutePopup..ctor | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — NA:1 · ERROR:1 |  | 2 (ACT:SCP0005_DistributionRoutePopup..ctor) |
| WK-SCP0005-0168 | X-ROW | SCP0005_DistributionRoutePopup.CreateSpr | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 1검사 — ERROR:1 |  | 6 (ACT:SCP0005_DistributionRoutePopup.Creat) |
| WK-SCP0005-0169 | X-ROW | SCP0005_DistributionRoutePopup.DefinePro | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — PASS:1 · ERROR:1 |  | 2 (ACT:SCP0005_DistributionRoutePopup.Defin) |
| WK-SCP0005-0170 | X-ROW | SCP0005_DistributionRoutePopup.Dispose | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — PASS:1 · ERROR:1 |  | 3 (ACT:SCP0005_DistributionRoutePopup.Dispo) |
| WK-SCP0005-0171 | X-ROW | SCP0005_DistributionRoutePopup.FindButto | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 4검사 — ERROR:3 · REVIEW:1 |  | 2 (ACT:SCP0005_DistributionRoutePopup.FindB) |
| WK-SCP0005-0172 | X-ROW | SCP0005_DistributionRoutePopup.FindData | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 6검사 — ERROR:3 · REVIEW:1 · NOPATH:1 · PASS:1 |  | 12 (ACT:SCP0005_DistributionRoutePopup.FindD) |
| WK-SCP0005-0173 | X-ROW | SCP0005_DistributionRoutePopup.Form_Load | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 2검사 — PASS:1 · ERROR:1 |  | 5 (ACT:SCP0005_DistributionRoutePopup.Form_) |
| WK-SCP0005-0174 | X-ROW | SCP0005_DistributionRoutePopup.InitSprea | 하네스·환경 | X-ROW 도구 오류 — 진입점 집계 30검사 — PASS:28 · ERROR:2 |  | 12 (ACT:SCP0005_DistributionRoutePopup.InitS) |
| WK-SCP0005-0175 | G5 | ProgressForm | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 ProgressForm 'react-query isFetching(별도 팝업 불요)' 의 G5 22요소: NA:10 · PASS:8 · NOPATH:3 · ERROR:1 |  | 1 (ProgressForm) |
| WK-SCP0005-0176 | G5 | R11/R12 FROM/TO 셀 더블클릭→도시팝업 | 하네스·환경 | G5 도구 오류 — 행 집계 — 대조표 R11/R12 FROM/TO 셀 더블클릭→도시팝업 '`onFromCellDblClick`/`onToCellDblClick`→`RegionMod' 의 G5 22요소: NA:10 · PASS:8 · |  | 1 (R11/R12 FROM/TO 셀 더블클릭→도시팝업) |
| WK-SCP0005-0177 | G5 | frm.ShowDialog() | 하네스·환경 | G5 도구 오류 — 원장 V-a6bb7234 |  | 1 (ACT:SCP0005_DistributionRoute.btnEaxel_U) |
| WK-SCP0005-0178 | H6 | ProgressForm | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 ProgressForm 'react-query isFetching(별도 팝업 불요)' 의 H6 22요소: ERROR:9 · PASS:6 · NOPATH:3 · NOT_RUN:2 · WARN:2 |  | 1 (ProgressForm) |
| WK-SCP0005-0179 | H6 | R11/R12 FROM/TO 셀 더블클릭→도시팝업 | 하네스·환경 | H6 도구 오류 — 행 집계 — 대조표 R11/R12 FROM/TO 셀 더블클릭→도시팝업 '`onFromCellDblClick`/`onToCellDblClick`→`RegionMod' 의 H6 22요소: ERROR:9 · PASS:6 |  | 1 (R11/R12 FROM/TO 셀 더블클릭→도시팝업) |
| WK-SCP0005-0180 | H6 | ROUTE_ID / Route Id | 하네스·환경 | H6 도구 오류 — 원장 V-0e9099ba ASIS / 원장 V-4cfc72f5 ASIS |  | 9 (R8 ROUTE_ID ACT:SCP0005_DistributionRout) |
| WK-SCP0005-0181 | H6 | SCP0005_DistributionRoute.spdMain_CellDo | 하네스·환경 | H6 도구 오류 — 원장 V-0e9099ba ASIS / 원장 V-4cfc72f5 ASIS / 원장 V-cca901cb ASIS / 원장 V-c9dc5aa7 ASIS |  | 3 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0182 | H6 | SCP0005_DistributionRoutePopup | 하네스·환경 | H6 도구 오류 — 원장 V-0e9099ba ASIS |  | 2 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0183 | H6 | btnFromSrch | 하네스·환경 | H6 도구 오류 — 원장 V-718e1a16 ASIS / 원장 V-7cdbda05 ASIS |  | 2 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0184 | H6 | btnToSrch | 하네스·환경 | H6 도구 오류 — 원장 V-616b4d31 ASIS / 원장 V-ac0769f6 ASIS |  | 2 (txtToCountry/txtToCity + btnToSrch ACT:S) |
| WK-SCP0005-0185 | H6 | frm.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-e14533b1 |  | 1 (ACT:SCP0005_DistributionRoute.btnEaxel_U) |
| WK-SCP0005-0186 | H6 | new GSCM.SCM.PopUp.UIL.SCP0005_Distribut | 하네스·환경 | H6 도구 오류 — 원장 V-0e9099ba |  | 1 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0187 | H6 | popCity.Form_Load(true, sCountry, sCity) | 하네스·환경 | H6 도구 오류 — 원장 V-718e1a16 |  | 1 (ACT:SCP0005_DistributionRoute.btnFromSrc) |
| WK-SCP0005-0188 | H6 | popCity.Form_Load(true, sCountry, sCity) | 하네스·환경 | H6 도구 오류 — 원장 V-616b4d31 |  | 1 (ACT:SCP0005_DistributionRoute.btnToSrch_) |
| WK-SCP0005-0189 | H6 | popup.ShowDialog() | 하네스·환경 | H6 도구 오류 — 원장 V-4cfc72f5 |  | 1 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0190 | M3 | SCP0005_DistributionRoutePopup | 하네스·환경 | M3 도구 오류 — 원장 V-a46588cb ASIS / 실측[T-6d14c72c]: [검사기 미검증] ROUTE_ID 더블클릭 → 팝업 열림 감지 실패 |  | 8 (ACT:SCP0005_DistributionRoutePopup..ctor) |
| WK-SCP0005-0191 | M3 | new GSCM.SCM.PopUp.UIL.SCP0005_Distribut | 하네스·환경 | M3 도구 오류 — 원장 V-a46588cb |  | 1 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0192 | M4 | SCP0005_DistributionRoute.spdMain_CellDo | 하네스·환경 | M4 도구 오류 — 진입점 집계 — 대조표 SCP0005_DistributionRoute.spdMain_CellDoubleClick 의 M4 8요소: PASS:5 · NA:2 · NOT_RUN:1 (미실행 요소가 남아 판정필요) |  | 3 (ACT:SCP0005_DistributionRoute.spdMain_Ce) |
| WK-SCP0005-0193 | M4 | txtFromCity / From City | 하네스·환경 | M4 도구 오류 — 실측[T-47ab9353]: r0 ROUTE_ID 더블클릭 → 팝업 열림 감지 실패(검사기 미검증) |  | 5 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0194 | M4 | txtFromCountry / From Country | 하네스·환경 | M4 도구 오류 — 실측[T-3d44d32d]: r0 ROUTE_ID 더블클릭 → 팝업 열림 감지 실패(검사기 미검증) |  | 5 (txtFromCountry/txtFromCity + btnFromSrch) |
| WK-SCP0005-0195 | M4 | txtToCity / To City | 하네스·환경 | M4 도구 오류 — 실측[T-26aaaaf4]: r0 ROUTE_ID 더블클릭 → 팝업 열림 감지 실패(검사기 미검증) |  | 5 (txtToCountry/txtToCity + btnToSrch ACT:S) |
| WK-SCP0005-0196 | M4 | txtToCountry / To Country | 하네스·환경 | M4 도구 오류 — 실측[T-ef2618be]: r0 ROUTE_ID 더블클릭 → 팝업 열림 감지 실패(검사기 미검증) |  | 5 (txtToCountry/txtToCity + btnToSrch ACT:S) |
