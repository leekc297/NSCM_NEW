# SCP0005 Distribution Route — AS-IS ↔ TO-BE 매핑 매트릭스

> AS-IS: `GSCM/06.UIL/GSCM.SCP.Forms.UIL/Master/SCP0005_DistributionRoute/SCP0005_DistributionRoute.cs`(+Designer)
> 설계: `.atlas/gscm-design/SCP0005/design/00~03`. 전환: convert-react (신규 재작성, domain=SSP/Shipping, 2026-09-25).
> TO-BE 배치: `features/shipping/src/pages/distribution-route` (alias `@shipping`, ROUTE_PATH `shipping/shipping-master/distribution-route`).
>   메뉴코드 접두어(SCP)와 트리 도메인(SSP)이 어긋나는 SCM0008 유형 — 자매 SCP0006/13/20/22 는 Supply_Master 트리이나 SCP0005 만 Shipping_Master.
> reference 표준: `features/supply/src/pages/tact-time`(SCP0020, sister single-grid 편집 그리드) + `features/master/src/pages/sales-site`(RegionModal 셀팝업).

## 1. 조회조건 (design 02)

| AS-IS | TO-BE | 근거 |
|---|---|---|
| clbTransMode (UsrCheckedList **다중 체크** — Designer ItemSelectionMode=One 은 하이라이트 방식일 뿐 체크 제한 아님, 단일 강제 OneItemCheckFlag 미설정) | Form `CustomDropdown` **multiple + allOption**(콤마 조인, 'ALL'=무필터), comboId `TransportModeCode`(전용, 무파라미터). GET SP UF_FX_STRING_SPLIT 콤마 다중 지원(2026-09-28 DB 실측) | cs:49,203 / Designer:195 / UsrCheckedList.cs:40,717 / design 02 §2.1(v4 정정) |
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
| R1 숫자셀 범위(cellType) | 컬럼 `_ctrlType` FPNumberText/FPNumber + cellEditEnded `clampIntRange`(PRIORITY 0~99, SHIP_DOC·LT5 0~999 정수 강제 — DB DATA_MAX_LENGTH 공란 대체, iter-2 G7) | cs:249~255 |
| R3/R4/R5 편집잠금(ROUTE_ID/CITY_NAME/LT_SUM/감사) | `ALWAYS_LOCKED` + `beginningEdit` cancel (DB 메타 8 'S' 정합) | cs:319~325,443,512,950~954 |
| R6 신규행 VALID_YN='Y' | `routeInsertDefaults()` | cs:947 |
| R8 ROUTE_ID | 링크/이력팝업 기능 없음 — 일반 잠금 텍스트 셀(편집잠금은 R3/R4/R5). AS-IS 에 해당 기능 부재 확인(2026-09-27) | design 03 §1 |
| R9 TRK/AIR→DAYS 7 'Y' | `daysAllYes()` cellEditEnded | cs:1045~1051 |
| R10 TRK→港/Forwarder 7 '-' | `portsDash()` cellEditEnded | cs:1055~1061 |
| R11/R12 FROM/TO 셀 더블클릭→도시팝업 | `onFromCellDblClick`/`onToCellDblClick`→`RegionModal`(cell-from/to)→`setRegion` | cs:1152~1160 |
| R13 LT 5종→LT_SUM, >999 차단·리셋 | `sumLeadTime()` + 0 리셋 + toast | cs:1004,1031 |
| R7 조회 databind | `useTabProcQuery` o_rc1 | cs:442,511 |
| R16/R17 클라 검증 색칠 | `validateRows`(전 편집행 누적, iter-2 G4) → `invalidCells` state → grid `formatItem` 영속 색칠(#ffd7d7, iter-2 G3) | cs:1276~1314 |
| R14/R15 저장응답 색칠(99010/99020) | saveRequest cause→errCode/errorRow 회수 → `buildSaveErrorCells`(R14 DUP DATA / R15 DUP PRIORITY 구간) → `formatItem` 색칠(iter-2 G2) | cs:858~863 / SP body L1322·L1346·L1388~1406 |
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
| PRIORITY>=1 (MSG00107) | `validateRows` PRIORITY_MIN (MSG01134 — MSG00107 과 문구 동일한 TO-BE 등재 코드 사용, MSG00107 도 등재됨) | cs:1297 |
| FROM/TO City Name 비공백 (MSG00167) | `validateRows` FROM/TO_CITY_NAME (MSG00429 등재 대체) | cs:1306,1314 |
| DAYS 최소 1 (MSG00223) | `validateRows` DAYS hasDay (MSG00429 등재 대체) | cs:736 |
| 메타 필수(INPUT_TP_CD=M/IM) | `useSaveWithValidation` | 전 화면 공통 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common'.
> 화면 분석 md 에 없는 전 UI 공통 요구 — asis_mapping_gate --check 가 부재 행을 FAIL 처리한다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터 상태에서 신규행 Insert 시 필터 유지한 채 추가 행 노출(keepRowVisibleUnderFilter) | DistributionRoute.tsx handleInsert→GridAction.addRow → packages/foundation/src/utils/gridAction.ts keepRowVisibleUnderFilter |  | 구현 |
| COMMON:UC-02 | 데이터 수정 중 다른 조회 시 '수정 중…새로 조회?' confirm(MSG00703) | | 공통 re-search(useTabProcQuery)·useDirtyRegistry 미통합 = 공통 인프라 과제(화면 Hard Boundary 밖, convert-core §2.2). 자매 SCP0020(merged) 동일 미배선 | 제외 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 데이터 Reset 후 재조회 | | Measure 0(정적 39컬럼, SHEET_MEASURE 실측 0). Column 설정 변경 시 재조회는 handleSearch→fetchStaticColumns(store)로 반영 — 별도 Reset 축 미해당 | 해당없음 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 Toast 자동소멸 | DistributionRoute.tsx setToast(공통 useMessageStore) + useProcMutation 공통 성공 Toast |  | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼이 Code 아닌 Name 출력 | DistributionRoute.tsx SubTitle(공통 excel) — gridAction dataMap Name 승계 |  | 구현 |
| COMMON:UC-06 | Key-in 조회조건 콤마 다중입력 전건 조회 | | TransMode 는 GET SP UF_FX_STRING_SPLIT 콤마 다중(design 03 §4.1) 지원. From/To Country·City 는 AS-IS 도 단일 LIKE(콤마 다중 아님) — key-in 콤마 다중 대상 조건 없음 | 해당없음 |
| COMMON:UC-07 | 필터 걸린 상태 재조회해도 조회되고 필터도 유지(rebindFilterColumns) | packages/foundation/src/utils/gridAction.ts rebindFilterColumns + captureGridFilter/restoreGridFilter (공통 DataGrid.tsx 자동 적용) |  | 구현 |

## 5. 의도적 변경 / 미완전 재현 (AS-IS 대비 — 정직 기록)

- **Edit 모드 게이트(M1~M4) → 상시편집 + 셀별 잠금**: AS-IS 는 조회 후 read-only → Edit 진입 unlock. TO-BE(NSCM 표준·sister SCP0020)는 상시편집 + `ALWAYS_LOCKED` 컬럼만 고정 잠금. design 01 §4 체크 #3/#5(read-only after search, Insert only after Edit)는 이 표준 변경으로 대체. 브라우저 육안 축(사용자 확인).
- **CITY 직접 타이핑 시 city_name 파생(SetCityCode) — iter-2 구현(G1)**: 도시팝업 경로(R11/R12)에 더해 CITY 셀 직접 편집 → `utils/distributionRoute.cityLookup.ts`(SEARCH_CITY call-proc, GET_COUNTRY_CITY) async 조회로 FROM/TO_CITY_NAME 파생. 매칭 없으면 name 비워 저장검증에서 차단. SP·PROC_M·버튼/API/권한 전건 등록 확인(05_register.sql iter-2 블록). 실 async 반영·잠금컬럼 갱신 육안은 사용자 확인 축.
- **저장 검증/응답 색칠(R14~R17) — iter-2 구현(G2/G3/G4)**: 클라 검증(R16/R17)은 `validateRows` 전 편집행 누적(G4) + `invalidCells` state → grid `formatItem` 영속 색칠(#ffd7d7, G3 — DOM 직접 set 비영속 방식 폐기). 저장 응답색 R14/R15(99010/99020)는 인터셉터 throw cause 에서 errCode/위반행 회수 → `buildSaveErrorCells` 로 위반행 해당 구간 색칠(G2). 색 육안·실 저장 중복 재현은 사용자 확인 축.
- **컬럼 편집타입 메타(INPUT_TP_CD) — 해소 확인(2026-09-25 재실측)**: `SCM_MST_SHEET_COLUMNS` PROGRAM_ID=SCP0005, SHEET_NAME='Distribution Route' 39행 = **31 'O'(편집) + 8 'S'(표시/감사)** 로 O/S 분화 등록 실측. 과거 gap-resolve iter-1 이 지적한 "39컬럼 전건 'S'(read-only)" 블로커는 해소됨(당시는 `route` 시트 33 전건 'S' 를 렌더 원천으로 오인). 현재 fetchStaticColumns 키 = 'Distribution Route' 이므로 admin 메타 구동 시 편집 컬럼 정상. FE 리터럴 덮어쓰기 금지(CLAUDE.md admin 동적속성) 준수.
