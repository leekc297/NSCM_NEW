# SCP0005 Distribution Route — AS-IS ↔ TO-BE 매핑 매트릭스

> AS-IS: `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0005_DistributionRoute/SCP0005_DistributionRoute.cs`(+Designer)
> 설계: `.atlas/gscm-design/SCP0005/design/00~03`. 전환: convert-react (신규 생성, 2026-09-21).
> reference 표준: `features/supply/src/pages/tact-time`(SCP0020, sister single-grid) + `features/master/src/pages/sales-site`(RegionModal 셀팝업).

## 1. 조회조건 (design 02)

| AS-IS | TO-BE | 근거 |
|---|---|---|
| clbTransMode (UsrCheckedList, SelectionMode.One) | Form `CustomDropdown` 단일 + ALL, comboId `LookupCommon` @lookupType='TRANSPORT_MODE_CODE' | cs:49,203 / design 02 §2.1 |
| cboValidYN (UsrCombo) | Form `CustomDropdown` 정적 ALL/Y/N (`VALID_OPTIONS`) | cs:51 / design 02 §2.2 |
| txtFromCountry/txtFromCity + btnFromSrch | Form `InputField` 2 + 돋보기 → `RegionModal`(search-from) | cs:338~354 / design 02 §4.6 |
| txtToCountry/txtToCity + btnToSrch | Form `InputField` 2 + 돋보기 → `RegionModal`(search-to) | cs:356~371 / design 02 §4.6 |
| dead 콤보(Division/Site/BodType/dtFromCountry/dtToCountry/dtYesOrNo) | 미구현(신설 금지) | design 02 §2.4 |
| cascade(clbFromCountry→City) | 없음(주석 폐기) — 무cascade | design 02 §3 |
| FindDataMain 파라미터 6종 'ALL'→'' | store `setFilter()` `orEmpty()` | cs:399~409 / design 02 §4 |

## 2. 그리드 (design 03 — 39 칼럼)

| AS-IS gridSignals | TO-BE | 근거 |
|---|---|---|
| DB메타 구동(gridColumns=[]) | `staticColumns` admin fetch(`ADMIN_SHEET_NAME`='Distribution Route') + `ROUTE_COLUMNS` fallback | design 03 §0/§1 |
| R1 숫자셀 범위(cellType) | 컬럼 `_ctrlType` FPNumberText/FPNumber (min/max 는 admin 메타) | cs:249~255 |
| R3/R4/R5 편집잠금(ROUTE_ID/CITY_NAME/LT_SUM/감사) | `ALWAYS_LOCKED` + `beginningEdit` cancel | cs:319~325,443,512,950~954 |
| R6 신규행 VALID_YN='Y' | `routeInsertDefaults()` | cs:947 |
| R8 ROUTE_ID 링크셀 더블클릭→이력팝업 | `onRouteIdDblClick`(트리거만 — 상세팝업 별도 activity 위임) | cs:569,1093 / design 03 §6 #3 |
| R9 TRK/AIR→DAYS 7 'Y' | `daysAllYes()` cellEditEnded | cs:1045~1051 |
| R10 TRK→港/Forwarder 7 '-' | `portsDash()` cellEditEnded | cs:1055~1061 |
| R11/R12 FROM/TO 셀 더블클릭→도시팝업 | `onFromCellDblClick`/`onToCellDblClick`→`RegionModal`(cell-from/to)→`setRegion` | cs:1152~1160 |
| R13 LT 5종→LT_SUM, >999 차단·리셋 | `sumLeadTime()` + 0 리셋 + toast | cs:1004,1031 |
| R7 조회 databind | `useTabProcQuery` o_rc1 | cs:442,511 |
| R14~R17 검증 색칠 | 클라 검증(useDistributionRouteValidation) — invalid 색칠은 미구현(사용자 확인 축) | cs:858~863,1276~1314 |
| R18 Insert/Delete | `GridAction.addRow` / `removeRow(grid, true)`(신규만) | cs:307,944 |

## 3. 진입점/버튼 (design 01)

| AS-IS | TO-BE | 근거 |
|---|---|---|
| FindButton(Search) | `hotkeyConfig.search`=handleSearch (hasButton) | cs:270 |
| InsertButton | `hotkeyConfig.insert`=handleInsert | cs:295 |
| EditButton (SwitchLock 편집모드) | NSCM 상시편집 표준으로 대체(Edit 토글 없음) — 셀별 editLock 판정 | cs:311 / sister SCP0020 선례 |
| DeleteButton(action!=FlagI return) | `hotkeyConfig.delete`=handleDelete (removeRow deleteOnlyNew) | cs:302~308 (buttonGuard#1) |
| SaveButton | `hotkeyConfig.save`=handleSave (validate→saveWithValidation) | cs:331 |
| btnEaxel_Upload → ExcelUploadForm2 | customButton 'Excel Upload' → `ExcelUploadModal` → 재조회 | cs:373~385 / design 01 E1 |
| btnExcel_Form (Visibility=Never) | 미노출(렌더 안 함) | cs:1383 / design 01 R1 |
| ProgressForm | react-query isFetching(별도 팝업 불요) | design 01 P2/P3 |

## 4. 검증 (design 03 §4.3)

| AS-IS | TO-BE | 근거 |
|---|---|---|
| PRIORITY>=1 (MSG00107) | `validateRows` PRIORITY_MIN | cs:1297 |
| FROM/TO City Name 비공백 (MSG00167) | `validateRows` FROM/TO_CITY_NAME | cs:1306,1314 |
| DAYS 최소 1 (MSG00223) | `validateRows` DAYS hasDay | cs:736 |
| 메타 필수(INPUT_TP_CD=M/IM) | `useSaveWithValidation` | 전 화면 공통 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common'.
> 화면 분석 md 에 없는 전 UI 공통 요구 — asis_mapping_gate --check 가 부재 행을 FAIL 처리한다.
> gap-resolve iter-1(2026-09-21)에 축 추가 — 각 행 공통 인프라/화면 배선 실측 대사.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터 상태에서 신규행 Insert 시 필터 유지한 채 추가 행 노출(keepRowVisibleUnderFilter) | DistributionRoute.tsx:85 handleInsert→GridAction.addRow → packages/foundation/src/utils/gridAction.ts:835 keepRowVisibleUnderFilter |  | 구현 |
| COMMON:UC-02 | 데이터 수정 중 다른 조회 시 '수정 중…새로 조회?' confirm(MSG00703) | | 공통 re-search(useTabProcQuery)·useDirtyRegistry 미통합 = 공통 인프라 과제(화면 Hard Boundary 밖, convert-core §2.2). 자매 SCP0020(merged) 동일 미배선 | 제외 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 데이터 Reset 후 재조회 | | Measure 0(정적 39컬럼, SHEET_MEASURE 실측 0). Column 설정 변경 시 재조회는 handleSearch→fetchStaticColumns(store)로 반영 — 별도 Reset 축 미해당 | 해당없음 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 Toast 자동소멸 | DistributionRoute.tsx:101,105 setToast(공통 useMessageStore) + useProcMutation 공통 성공 Toast |  | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼이 Code 아닌 Name 출력 | DistributionRoute.tsx:196 SubTitle(공통 excel) — gridAction dataMap Name 승계 |  | 구현 |
| COMMON:UC-06 | Key-in 조회조건 콤마 다중입력 전건 조회 | | TransMode 는 GET SP UF_FX_STRING_SPLIT 콤마 다중(design 03 §4.1) 지원. From/To Country·City 는 AS-IS 도 단일 LIKE(콤마 다중 아님, design 03 §4.1 WHERE) — key-in 콤마 다중 대상 조건 없음 | 해당없음 |
| COMMON:UC-07 | 필터 걸린 상태 재조회해도 조회되고 필터도 유지(rebindFilterColumns) | packages/foundation/src/utils/gridAction.ts:90 rebindFilterColumns + :137 captureGridFilter/restoreGridFilter (공통 DataGrid.tsx 자동 적용) |  | 구현 |

## 5. 의도적 변경(AS-IS 미완전 재현 — 정직 기록)

- **Edit 모드 게이트(M1~M4) → 상시편집 + 셀별 잠금**: AS-IS 는 조회 후 read-only → Edit 진입 unlock. TO-BE(NSCM 표준·sister SCP0020)는 상시편집 + `ALWAYS_LOCKED` 컬럼만 고정 잠금. design 01 §4 체크 #3/#5(read-only after search, Insert only after Edit)는 이 표준 변경으로 대체.
- **CITY 직접 타이핑 시 city_name 파생(SetCityCode)**: 도시팝업 경로(R11/R12)는 구현. CITY 셀 직접 편집 → name 파생은 `GET_COUNTRY_CITY` SP 조회가 필요해 미구현(design 03 §6 #5 — convert 단계 위임). 사용자 확인 축.
- **저장 실패 색칠(R14~R17 invalid color)**: 클라 검증 alert·차단은 구현, 셀 invalid 배경색 하이라이트는 미구현(사용자 확인 축·브라우저 육안).
- **컬럼 편집타입 메타 정정(gap-resolve iter-1)**: `SCM_MST_SHEET_COLUMNS` SCP0005 39컬럼 전건 `INPUT_TP_CD='S'`(SEARCH_ONLY) 실측 → admin 메타 구동 시 전 셀 편집불가(그리드 read-only)로 Insert/Edit/Save 불가(HIGH). 정정 SQL(31 편집컬럼 'O')은 `design/05_register.sql` BLOCK 7 — UPDATE 라 사용자 승인 대기(미적용). FE 리터럴 덮어쓰기 금지(CLAUDE.md admin 동적속성)라 코드가 아닌 메타로 정정. gap-resolve evidence G1.
