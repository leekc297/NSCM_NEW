# SSP0025 Shipment Requestor PIC — AS-IS ↔ TO-BE 매핑 매트릭스

> convert-core §2.1 #11 (As-Is 검증·표현식·gridSignals·buttonGuards 100% 매핑).
> AS-IS: `GSCM/06.UIL/GSCM.SSP.Plan.UIL/SSP0025_ShipmentRequestorPIC.cs`(+`.Designer.cs`), `Popup/SSP0025_ItembyDivisionPopup.cs`.
> 설계: `.atlas/gscm-design/SSP0025/design/00~03,07`. 준거 자매: SSP0024(shipment-master-electrode, 편집·셀콤보·Item팝업) + SSP0014(shipment-model-pic, User 이미지셀).
> SP 미배포(PKG_SSP0025 all_objects 0건) — 런타임 실행체인 미완(convert-sp 후속). FE 배선 완비.

## 1. 컨트롤/레이아웃 (영역1·2)

| AS-IS 컨트롤 | cs/designer | TO-BE |
|---|---|---|
| usrConditionPanel1(HidePanel) | designer:116 | `SearchArea`(접기 토글) — ShipmentRequestorPicForm |
| cboDivision(UsrCombo, MyDivision) | cs:45,133 | Form Division 드롭다운 `useTabComboQueries(MyDivision)` |
| clbFromSite(UsrCheckedList, PlantCell) | cs:140~141 | Form Plant Site 다중 CustomDropdown `PlantCell @divisionId` |
| txtItemId(다건) + btnItemId | cs:260,704~720 | Form Material InputField + 돋보기 → ItemByDivisionModal(ITEM) |
| txtNickName | cs:261 | Form Nick Name InputField |
| txtModelId(다건) + btnModelId | cs:262,722~738 | Form Model InputField + 돋보기 → ItemByDivisionModal(MODEL) |
| spdMain(FpSpread) | designer:539 | `DataGrid` — ShipmentRequestorPicGrid |
| usrButton1 | (미배치) | dead control — 미이식(design 01 §1) |

## 2. 이벤트/버튼 (영역1·2)

| AS-IS | cs | TO-BE |
|---|---|---|
| FindButton → FindData_Main | cs:185,249~284 | `handleSearch` → setFilter → useTabProcQuery(GET) |
| EditButton(SwitchLock) + GetSSPUserCheck | cs:204~228,505 | **버튼권한(SAVE) 갈음 + 저장 전 User 검증**(NSCM 표준, 자매 SSP0014 EDIT API 공란). AS-IS SSP0002 서버게이트 미배선 — 04 §C2 확인필요 |
| InsertButton(IsLock=false 가드) | cs:308~330 | `handleInsert` — 빈행+기본값(DIVISION_ID=searchParams, VALID_YN='Y'). GridAction.addRow |
| DeleteButton(action='I'만 제거) | cs:195~202,332~345 | `handleDelete` — 신규행 removeRow(deleteOnlyNew) + 기존행 VALID_YN='N'+'M' (#138) |
| SaveButton → SaveData | cs:382~422 | `handleSave` → useSaveWithValidation → doSave(^-delim, apiClient.post SAVE) |
| CboDivision_SelectedIndexChanged → SetChangedControl | cs:699~702,137~142 | Form Division onChange → plantSiteIds 초기화 + PlantCell 재조회(cascade) |

## 3. gridSignals 39건 — white-list R1~R21 (design 03 §3 전건 소진)

| R | AS-IS cs | TO-BE 구현 위치 |
|--:|---|---|
| R1 초기 전체잠금 | cs:292 | Grid beginningEdit — 편집칸 외 e.cancel(editLock) |
| R2 편집권한 게이트 | cs:206~214 | (버튼권한 갈음 + 저장 전 checkUsersRegistered) — 04 §C2 |
| R3 기존행 편집칸 | cs:221~227 | `EDIT_EDITABLE_COLUMNS`(USER_ID/PART/TEAM/VALID_YN) + editLock.isCellEditable |
| R4 신규행 편집칸 | cs:319~325 | `INSERT_EDITABLE_COLUMNS`(DIVISION/SITE/ITEM + 기존편집칸) + editLock |
| R5 신규행 DIVISION 셀콤보 | cs:318 | 컬럼메타 DIVISION_ID=FPComboBox MyDivision(PARAM9, 05_register.sql) |
| R6 신규행 SITE 셀콤보 | cs:320 | 컬럼메타 SITE_DESCRIPTION=FPComboBox PlantCell(PARAM10='D', 05_register.sql) |
| R7 신규행 VALID 기본값 | cs:327 | `handleInsert` VALID_YN='Y'(INSERT_DEFAULT_VALID_YN) |
| R8 CellClick 가드(행0) | cs:619 | Grid dblClick/beginningEdit — row 없으면 return(순수가드) |
| R9 CellClick 가드(편집모드) | cs:622 | editLock.isCellEditable(모드×행상태) |
| R10 CellClick 가드(Division 선점) | cs:628~633 | (신규행 SITE/ITEM 상호작용 전 Division 필요 — 셀콤보 division 컨텍스트) |
| R11 신규행 SITE 재조회 | cs:637~641 | PlantCell cascade PARAM10='D'(행 division) — admin 메타 useRowParamCombos |
| R12 신규행 ITEM 팝업 | cs:642~666 | Grid dblClick(ITEM_ID) → `handleItemCellDblClick` → ItemByDivisionModal(CELL) → 6칸 채움(POPUP_FILL_COLUMNS). PlantSite 공백 MSG(REQUIRED_FIELD) |
| R13 SITE→TO_SITE 파생 | cs:679~682 | Grid cellEditEnded(SITE_DESCRIPTION) → TO_SITE=값 |
| R14 신규행 Division 변경 reset | cs:683~695 | Grid cellEditEnded(DIVISION_ID, 신규행) → DIVISION_CASCADE_CLEAR 7칸 '' |
| R15 ComboSelChange 가드(행0) | cs:674 | cellEditEnded — row 없으면 return |
| R16 USER_ID 더블클릭 팝업 | cs:543~561 | Grid dblClick(USER_ID) → `handleUserCellDblClick` → SsoUserModal → USER_ID |
| R17 PART_LEADER 더블클릭 | cs:567~585 | 동일 → PART_LEADER |
| R18 TEAM_LEADER 더블클릭 | cs:591~609 | 동일 → TEAM_LEADER |
| R19 삭제=신규행만 | cs:332~345 | `handleDelete`(#138) |
| R20 셀 병합 | cs:160,297,534 | Grid AllowMerging.All + col.allowMerging(CustomMergeManager, 'I' 제외) |
| R21 이미지셀 아이콘 | cs:162~164,347~353 | 컬럼메타 USER/PART/TEAM=FPTextModal(팝업 아이콘) |

## 4. validations 6 / buttonGuards 8 (영역별)

| 축 | AS-IS cs | TO-BE |
|---|---|---|
| checkRequiredOfSearch(Division 필수) | cs:249 | `handleSearch` divisionId 가드(MSG REQUIRE_DIVISION) |
| checkRequiredOfSpread(필수 4칸) | cs:364 | `useSaveWithValidation`(라벨 * — SITE/ITEM/USER_ID/VALID) |
| GetUserIDChk(USER_ID_CHECK) | cs:400~408,491~498 | `useShipmentRequestorPicValidation.checkUsersRegistered`(USER_CHECK proc) → **MSG01261**(AS-IS MSG00251 의 TO-BE 등가 — AS-IS 번호는 TO-BE 미등록, ora.py 실측) |
| CellClick 순수가드(619/674) | cs:619,674 | Grid dblClick/cellEditEnded row 가드(R8/R15) |
| CellClick Division/PlantSite 선점(628/642) | cs:628,642 | R10/R12 가드(MSG REQUIRE_DIVISION/REQUIRED_FIELD) |
| Save 응답판정(S/건수/에러) | cs:415~422 | doSave false-success 분기(res.status/code) + SAVE_SUCCESS/SAVE_FAIL |

## 5. comboCalls 4 / popups / lookup

| AS-IS | code/param | TO-BE |
|---|---|---|
| cboDivision | Data.Common(MyDivision, NowGroupID, UserId) | CMBO `MyDivision`(등록확인, design 03 §1.4) |
| clbFromSite | Data.Common(PlantCell, divisionId, "") | CMBO `PlantCell`(@divisionId, 등록확인) |
| 셀 VALID_YN | dtYesOrNo(cs:47) | CMBO `YesOrNo` |
| 셀 SITE_DESCRIPTION | dtToSite=PlantCell(cs:320,639) | 셀콤보 PlantCell(**미이관→05_register.sql**) |
| 셀 DIVISION_ID | dtMyDivision(cs:318) | 셀콤보 MyDivision PARAM9(**미이관→05_register.sql**) |
| SSP0025_ItembyDivisionPopup | ITEM/MODEL/CELL | 화면전용 `ItemByDivisionModal`(SSP0025 전용 SP) |
| UserInfoPopup(User/Part/Team) | cs:543~609 | 공용 `SsoUserModal`(ssoUserYn='N') |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — --check 가 부재 행을 FAIL 처리한다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지, 1st 행3 + 2026-08-14 공통 수정사항①) | ShipmentRequestorPic.tsx:273 `GridAction.addRow` → 공용 `packages/foundation/src/utils/gridAction.ts:832~837`(splice 후 신규행마다 keepRowVisibleUnderFilter 등록, 필터 clear 없음) |  | 구현 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4) | ShipmentRequestorPic.tsx:399~400 `hotkeyConfig.search`(= Hotkeys.F5, hotkey.ts:9) → 공용 `SubTitle.tsx:196~202` confirmIfDirtyKey(tabDirtyKey, 'search') + 공용 DataGrid dirty 등록 — 화면 배선 불요 |  | 구현 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5) | — | Column/Measure 설정 모달 미보유 — 고정 19열(`SCM_MST_SHEET_COLUMNS` 19행)·동적 pivot 없음(`SCM_MST_SHEET_MEASURE` 0행, ora.py 실측). AS-IS 에도 컬럼 설정 UI 없음(cs 전건) | 해당없음 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준·hook #132 §3 — 1st 행6) | ShipmentRequestorPic.tsx:360~363(저장 성공 setToast success MSG00672 건수) · :382(변경없음 Toast MSG00004). 실패·검증 차단만 setAlert |  | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7) | ShipmentRequestorPic.tsx:428 SubTitle excelFileName + components/ShipmentRequestorPicGrid.tsx:63 buildColumns(admin 메타 그대로) — 콤보 셀 3종(DIVISION_ID=MyDivision·SITE_DESCRIPTION=PlantCell·VALID_YN=YesOrNo)이 `cellCboDataTp` dataMap 을 승계해 NAME 출력 |  | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) | useShipmentRequestorPicStore.ts:57~64 `multi()`(Material·Model 개행/콤마 다건 → 콤마 join) · :67 `joinOrEmpty()`(Plant Site 다중 체크 → 콤마) → GET `dbo.String_Split(,',')` 콤마 IN(07 보완2) |  | 구현 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns — 2026-08-14 공통 수정사항②) | components/ShipmentRequestorPicGrid.tsx:184 `gridFilterRef` → 공용 DataGrid 내장 rebindFilterColumns(`packages/foundation/src/utils/gridAction.ts:91`) — 화면 배선 불요(자매 SSP0014 동일) |  | 구현 |

## 6. 미매핑/보류 (침묵 누락 방지 — skill 2.5)

- 없음. gridSignals 39 · validations 6 · buttonGuards 8 전건 위 표에 매핑.
- 런타임 실행(C/U/D/R)·팝업 조회·User 검증·다국어 라벨 실측은 **PKG_SSP0025 배포(convert-sp) 후** 검증 — 현재 미완(정직 보고). 상세 04_react-gap.md §확인필요.
