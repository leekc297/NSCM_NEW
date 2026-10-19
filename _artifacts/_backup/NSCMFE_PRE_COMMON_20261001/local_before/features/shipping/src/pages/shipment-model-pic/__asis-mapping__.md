# __asis-mapping__.md — design 번호 1:1 대사표 (asis-coverage-check §0.0/§0.1)

> 원천: `00_checklist.md` · 생성: asis_mapping_gate.py --init · 대사: convert-gap-resolve iter-1
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수 — 조회 전용 화면의 CRUD 행 등). 빈 칸 1개 = 게이트 실패.
> 구현 위치 라인은 대사 시점(convert-gap-resolve iter-1) 기준. 경로 접두 `features/shipping/src/pages/shipment-model-pic/` 생략.

## 이벤트·제약 (design 번호 1:1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-1-001 | §1 usrLayoutControl2 / UsrLayoutControl | ShipmentModelPic.tsx:250~304 (화면 셸 root fragment — layout 컨테이너 등가) |  | 구현 |
| D00-1-002 | §1 layoutControlGroup2 / LayoutControlGroup | ShipmentModelPic.tsx:250~304 (root group — 별도 border 없는 컨테이너, MainTitle+Form+SubTitle+Grid 배치) |  | 구현 |
| D00-1-003 | §1 usrConditionPanel1 / UsrConditionPanel(HidePanel) | ShipmentModelPic.tsx:258~260 (openSearchArea 토글) + components/ShipmentModelPicForm.tsx:67~69 (SearchArea isHidden) |  | 구현 |
| D00-1-004 | §1 Division / LayoutControlItem(라벨) | components/ShipmentModelPicForm.tsx:77 (FormItem label LBL00641) |  | 구현 |
| D00-1-005 | §1 layoutControlItem1 / LayoutControlItem(Operation Group 라벨) | components/ShipmentModelPicForm.tsx:96 (label LBL00027) |  | 구현 |
| D00-1-006 | §1 layoutControlItem7 / LayoutControlItem(From Site 라벨) | components/ShipmentModelPicForm.tsx:113 (label LBL00022) |  | 구현 |
| D00-1-007 | §1 layoutControlItem3 / LayoutControlItem(Valid 라벨) | components/ShipmentModelPicForm.tsx:140 (label LBL00639) |  | 구현 |
| D00-1-008 | §1 lblItemId / LayoutControlItem(Model 라벨) | components/ShipmentModelPicForm.tsx:157 (label LBL00669) |  | 구현 |
| D00-1-009 | §1 layoutControlItem4 / LayoutControlItem(btnItemId 셀, TextVisible=false) | components/ShipmentModelPicForm.tsx:164~173 (InputField endAdornment — 라벨 없는 버튼 셀) |  | 구현 |
| D00-1-010 | §1 layoutControlItem2 / LayoutControlItem(User ID 라벨) | components/ShipmentModelPicForm.tsx:186 (label LBL00339) |  | 구현 |
| D00-1-011 | §1 emptySpaceItem1 / EmptySpaceItem(스페이서) | — | WinForms 좌표 레이아웃 스페이서. MUI Grid size 자동 정렬로 불필요(패딩 등가). | 해당없음 |
| D00-1-012 | §1 emptySpaceItem2 / EmptySpaceItem(스페이서) | — | 동 D00-1-011 — 좌표 스페이서, React 레이아웃에서 불요. | 해당없음 |
| D00-1-013 | §1 cboDivision / UsrCombo | components/ShipmentModelPicForm.tsx:80~88 (CustomDropdown divisionOptions, 필수) |  | 구현 |
| D00-1-014 | §1 cboOperationGroup / UsrCombo | components/ShipmentModelPicForm.tsx:99~105 (CustomDropdown allOption, P/A/E+W) |  | 구현 |
| D00-1-015 | §1 clbFromSite / UsrCheckedList(다중) | components/ShipmentModelPicForm.tsx:116~131 (CustomDropdown multiple allOption) |  | 구현 |
| D00-1-016 | §1 cboValidYN / UsrCombo | components/ShipmentModelPicForm.tsx:143~148 (CustomDropdown allOption YesOrNo) |  | 구현 |
| D00-1-017 | §1 txtItemId / UsrMultiLineEditor(^다건) | components/ShipmentModelPicForm.tsx:160~177 (InputField) + useShipmentModelPicStore.ts:70~77 (multiItem 다건 분해) |  | 구현 |
| D00-1-018 | §1 btnItemId / UsrButton(SCM0002) | components/ShipmentModelPicForm.tsx:168~171 (FunctionSearchIcon onClick=onItemSearch) → ShipmentModelPic.tsx:259,296~302 |  | 구현 |
| D00-1-019 | §1 txtUser / TextBox(User ID(Name) LIKE) | components/ShipmentModelPicForm.tsx:189~194 (InputField) |  | 구현 |
| D00-1-020 | §1 spdMain / FpSpread(메인 그리드) | components/ShipmentModelPicGrid.tsx:124~136 (DataGrid, staticColumns 21열) |  | 구현 |
| D00-1-021 | §1 spdMain_Sheet1 / SheetView(시트) | shipment-model-pic.constants.ts:12~14 (SHEETS.MAIN='main' 단일 시트) + ADMIN_SHEET_NAME:24~26 |  | 구현 |
| D00-1-022 | §1 usrButton1 / UsrButton(ButtonAccessType=None, 미배치) | — | AS-IS 렌더 안 함(미배치 헬퍼 버튼). TO-BE 대상 아님(00 §1 근거). | 제외 |
| D00-1-023 | §1 components / Container(디자이너 컨테이너) | — | WinForms 디자이너 IContainer — React 무관(비 UI 요소). | 해당없음 |
| D00-1-024 | §1 imageList1 / ImageList("edit.png" 팝업셀 아이콘) | components/ShipmentModelPicGrid.tsx:112~122 (팝업셀 더블클릭 오픈) | AS-IS cellTypeImage(edit.png) 이미지버튼 → TO-BE 는 셀 더블클릭 오픈으로 대체(이미지 아이콘 미사용, nscm-patterns §5-16). | 해당없음 |
| D00-2-001 | §2 cboDivision / SelectedIndexChanged(FromSite 재조회) | components/ShipmentModelPicForm.tsx:84~86 (onChange set fromSiteIds:[]) + :45~49 (fromSiteFilter @divisionId 재조회) |  | 구현 |
| D00-2-002 | §2 btnItemId / Click(SCM0002 팝업) | ShipmentModelPic.tsx:259 (onItemSearch) + :296~302 (ItemByDivisionModal division/itemId 컨텍스트) |  | 구현 |
| D00-2-003 | §2 spdMain / CellDoubleClick(UserInfoPopup) | components/ShipmentModelPicGrid.tsx:112~122 (handleDblClick USER 7셀) → ShipmentModelPic.tsx:99~102,288~293 (SsoUserModal) |  | 구현 |
| D00-2-004 | §2 spdMain / TopChange(스크롤 재병합) | components/ShipmentModelPicGrid.tsx:124~136 (공용 DataGrid 스크롤 병합 관장) | 스크롤 재병합은 공용 DataGrid 내부 처리. 신규행 없어 재병합 노이즈 없음. 시각 파리티는 사용자 육안 축. | 해당없음 |
| D00-3-001 | §3 SmartColMerge / 223 (InitSpread 초기병합) | components/ShipmentModelPicGrid.tsx:124~136 (공용 DataGrid 병합) | 초기 병합은 공용 DataGrid 관장(화면 미배선). 시각 파리티 사용자 육안 축. | 해당없음 |
| D00-3-002 | §3 SwitchLock / 272 (EditButton 편집토글) | 제외 — 사용자 지시로 Edit 토글 제거, 그리드 조회 직후 기본 편집 가능(components/ShipmentModelPicGrid.tsx isReadOnly={false}) | AS-IS EditButton(SwitchLock) 미이관 결정. 편집셀(팝업7+VALID_YN)은 조회 직후 바로 편집 가능. | 제외 |
| D00-3-003 | §3 LockColumn / 274 (DIVISION..NICK_NAME lock) | shipment-model-pic.constants.ts:67~71 (DIVISION_ID/OPERATION_GROUP/FROM_SITE/ITEM_ID/NICK_NAME _inputEditType:'S') |  | 구현 |
| D00-3-004 | §3 LockColumn / 275 (USER_NAME lock) | shipment-model-pic.constants.ts:73 (USER_NAME _inputEditType:'S') |  | 구현 |
| D00-3-005 | §3 LockColumn / 276 (PART_LEADER_NAME lock) | shipment-model-pic.constants.ts:75 (PART_LEADER_NAME _inputEditType:'S') |  | 구현 |
| D00-3-006 | §3 LockColumn / 277 (TEAM_LEADER_NAME lock) | shipment-model-pic.constants.ts:77 (TEAM_LEADER_NAME _inputEditType:'S') |  | 구현 |
| D00-3-007 | §3 LockColumn / 278 (CREATED_BY..LAST_UPDATE_DATE lock) | shipment-model-pic.constants.ts:84~87 (CREATED_BY/CREATION_DATE/LAST_UPDATED_BY/LAST_UPDATE_DATE _inputEditType:'S') |  | 구현 |
| D00-3-008 | §3 Query / 346 (GET SP 바인딩) | ShipmentModelPic.tsx:60~68 (useTabProcQuery → data.o_rc1) |  | 구현 |
| D00-3-009 | §3 LockColumn / 348 ((0,max) 조회=전체 lock 뷰) | 제외 — Edit 토글 제거로 조회 후 뷰 lock 없음. lock 은 컬럼메타(13열 'S')로만 유지 | 조회 직후 전체 lock(뷰 모드) 미이관(Edit 토글 제거). 키/이름/감사 13열은 여전히 컬럼메타 lock. | 제외 |
| D00-3-010 | §3 SetCellTypeText / 357 (OPERATION_GROUP=='W' 텍스트셀) | components/ShipmentModelPicGrid.tsx:75~87 (formatItem OPERATION_GROUP 표시 재정의) |  | 구현 |
| D00-3-011 | §3 SetValue / 358 (OPERATION_GROUP "W"→"Warranty") | components/ShipmentModelPicGrid.tsx:84 (opGroupNameMap) + shipment-model-pic.constants.ts:47~48 (W=Warranty) |  | 구현 |
| D00-3-012 | §3 SetHAlign / 359 (OPERATION_GROUP center) | components/ShipmentModelPicGrid.tsx:85 (e.cell.style.textAlign='center') |  | 구현 |
| D00-3-013 | §3 SmartColMerge / 364 (조회 후 병합) | components/ShipmentModelPicGrid.tsx:124~136 (공용 DataGrid 병합) | 조회 후 병합은 공용 DataGrid 관장(화면 미배선). 시각 파리티 사용자 육안 축. | 해당없음 |
| D00-3-014 | §3 SmartColMerge / 622 (TopChange 재병합) | components/ShipmentModelPicGrid.tsx:124~136 (공용 DataGrid 병합) | 스크롤 재병합 공용 DataGrid 관장. 신규행 없어 노이즈 없음. 시각 사용자 육안 축. | 해당없음 |
| D00-3-015 | §3 SetValue / 649 (USER_ID ← 팝업) | ShipmentModelPic.tsx:105~116 (handleUserSelected storeChange+SetValue) + components/ShipmentModelPicGrid.tsx:112~122 |  | 구현 |
| D00-3-016 | §3 SetValue / 674 (PART_LEADER ← 팝업) | ShipmentModelPic.tsx:105~116 (동일 경로) + shipment-model-pic.constants.ts:30~39 (USER_POPUP_COLUMNS PART_LEADER) |  | 구현 |
| D00-3-017 | §3 SetValue / 699 (TEAM_LEADER ← 팝업) | ShipmentModelPic.tsx:105~116 + shipment-model-pic.constants.ts:30~39 (TEAM_LEADER) |  | 구현 |
| D00-3-018 | §3 SetValue / 724 (MAIL_USER1 ← 팝업) | ShipmentModelPic.tsx:105~116 + shipment-model-pic.constants.ts:30~39 (MAIL_USER1) |  | 구현 |
| D00-3-019 | §3 SetValue / 749 (MAIL_USER2 ← 팝업) | ShipmentModelPic.tsx:105~116 + shipment-model-pic.constants.ts:30~39 (MAIL_USER2) |  | 구현 |
| D00-3-020 | §3 SetValue / 774 (MAIL_USER3 ← 팝업) | ShipmentModelPic.tsx:105~116 + shipment-model-pic.constants.ts:30~39 (MAIL_USER3) |  | 구현 |
| D00-3-021 | §3 SetValue / 799 (MAIL_USER4 ← 팝업) | ShipmentModelPic.tsx:105~116 + shipment-model-pic.constants.ts:30~39 (MAIL_USER4) |  | 구현 |
| D00-3-022 | §3 SetValue / 824 (MAIL_USER5 ← 팝업) | ShipmentModelPic.tsx:105~116 + shipment-model-pic.constants.ts:30~39 (MAIL_USER5) |  | 구현 |

## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| CRUD:SEARCH | 조회(FindButton→GET SP) | ShipmentModelPic.tsx:77~89 (handleSearch, Division 가드+setFilter) + :60~68 (useTabProcQuery) |  | 구현 |
| CRUD:SAVE | 저장(SaveButton→^-delim UPSERT) | ShipmentModelPic.tsx:210~222 (handleSave) + :119~208 (doSave, USER_CHECK 후 SAVE call-proc) |  | 구현 |
| CRUD:EDIT | 편집 진입(EditButton SwitchLock) | 제외 — 사용자 지시로 Edit 토글 제거, 그리드 조회 직후 기본 편집 가능 | AS-IS EditButton 미이관 결정. 편집셀은 별도 진입 없이 바로 편집(팝업7+VALID_YN). | 제외 |
| CRUD:INSERT | 신규행(InsertButton) | ShipmentModelPic.tsx hotkeyConfig `insert: () => undefined` | AS-IS InsertButton override 공란(no-op, //InsertRow() 주석 — 첨부 실측). 버튼은 노출하되 클릭 무동작으로 재현(사용자 지시). 주의: hotkeyConfig 생략 시 SubTitle 기본 addRow 가 살아 실동작하므로 명시 no-op 필수. | 구현 |
| CRUD:DELETE | 행 삭제(DeleteButton) | ShipmentModelPic.tsx hotkeyConfig `delete: () => undefined` | AS-IS DeleteButton override 공란(no-op). 버튼 노출 + 클릭 무동작 재현(사용자 지시). 생략 시 SubTitle 기본 removeRow 실동작 — 명시 no-op 필수. 논리 삭제는 VALID_YN 플래그. | 구현 |
| MODAL:SsoUserModal | AS-IS UserInfoPopup(이미지셀 7 공유, SingleSelectYn) | ShipmentModelPic.tsx:288~293 (SsoUserModal setSelectedValue→handleUserSelected) |  | 구현 |
| MODAL:ItemByDivisionModal | AS-IS SCM0002_ItembyDivisionPopup(Model 검색, division/site 컨텍스트) | ShipmentModelPic.tsx:296~302 (ItemByDivisionModal preSearchParams division/itemId) |  | 구현 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — --check 가 부재 행을 FAIL 처리한다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지, 1st 행3 + 2026-08-14 공통 수정사항①) | — | 이 화면은 Insert 기능 없음(AS-IS InsertButton 빈 override cs:254, hotkeyConfig.insert 미등록). 필터×신규행 상호작용 미성립. | 해당없음 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4) | 공용 SubTitle.tsx:198 · SearchArea.tsx:115 (조회 전 confirmIfDirtyKey('search', MSG00704)) + 공용 DataGrid 자동 dirty 등록(useDirtyRegistry) — 화면 배선 불요 |  | 구현 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5) | — | Column/Measure 설정 모달 미보유(고정 21열, 동적 pivot 없음·SHEET_MEASURE 0행). AS-IS 도 컬럼 설정 UI 없음. | 해당없음 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준·hook #132 §3 — 1st 행6) | ShipmentModelPic.tsx:194~197 (저장 성공 setToast success, MSG00672 건수) — Alert 아닌 하단 Toast. 실패만 setAlert |  | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7) | ShipmentModelPic.tsx:266 (SubTitle excelFileName) + components/ShipmentModelPicGrid.tsx:34~39 (FROM_SITE/VALID_YN 콤보 셀 cellCboDataTp dataMap 승계→Name). OPERATION_GROUP 은 formatItem 표시 파생(코드 원장값 P/A/E/W, AS-IS SetCellTypeText 동일) |  | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) | useShipmentModelPicStore.ts:70~77 (multiItem — Model ^·콤마·개행 다건 → 콤마 join) + GET P_ITEM_ID 콤마 IN. User ID(Name) 은 LIKE 6필드 OR |  | 구현 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns — 2026-08-14 공통 수정사항②) | components/ShipmentModelPicGrid.tsx:124~136 (공용 DataGrid 소비 — rebindFilterColumns 는 packages/shared 공용 DataGrid 내장, 화면 배선 불요) |  | 구현 |

---

## 부록. 사람이 읽는 매핑 요약 (design 3영역 — 위 번호표의 서술본)

### A. 이벤트 (events 4)

| # | AS-IS 컨트롤/이벤트 | cs 라인 | TO-BE 매핑 | 상태 |
|---|---|---|---|---|
| 1 | cboDivision.SelectedIndexChanged → SetChangedControl(FromSite 재조회) | 833-836 | `ShipmentModelPicForm` Division onChange → `set({divisionId, fromSiteIds:[]})` + Form 콤보 `@divisionId` param 재조회(cascade) | 매핑 |
| 2 | btnItemId.Click → SCM0002 팝업 | 838-859 | `ShipmentModelPic` `onItemSearch` → `ItemByDivisionModal`(preSearchParams division/itemId) | 매핑 |
| 3 | spdMain.CellDoubleClick → UserInfoPopup | 626-829 | `ShipmentModelPicGrid.handleDblClick`(USER 계열 7 셀) → `SsoUserModal` | 매핑 |
| 4 | spdMain.TopChange → 스크롤 재병합 | 619-622 | 공용 DataGrid 자체 병합/렌더 관리. 신규행 없어 재병합 노이즈 없음 | 패턴(wrapper) |

### B. Validation (validations 3) — TO-BE 메시지 ID 는 SCM_ADM_MSG_M 문구 역조회 실측(Hook #114)

| # | AS-IS(번호=AS-IS) | cs 라인 | TO-BE 매핑 (실측 MSG ID) | 상태 |
|---|---|---|---|---|
| 1 | AS-IS MSG00004 저장 성공(건수) — "{0}개의 데이터가 저장되었습니다." | 520-525 | `doSave` 성공 시 `setToast(MSG.SAVE_SUCCESS=**MSG00672** "{0} data saved.", {0: dirty.length})`. TO-BE MSG00004 는 "No changes to save." 라 재사용 금지 | 매핑(실측) |
| 2 | AS-IS MSG00284 저장 실패 | 542-543 | `doSave` false-success/예외 시 `setAlert(MSG.SAVE_FAIL=**MSG00003** "Failed to save.")`. TO-BE MSG00284 는 "The grid is not ready." 라 재사용 금지 | 매핑(실측) |
| 3 | AS-IS MSG00251 미등록 사용자 — "GSCM 시스템에 등록되지 않은 사용자 입니다. User ID : {0}" | 441-495, 554-607 | `useShipmentModelPicValidation.checkUsersRegistered`(CHECK proc o_rc1=등록 통과 목록, 입력−통과=미등록) → `setAlert(MSG00251, {0:미등록목록})`. TO-BE MSG00251 미등록(역조회 0건) → defaultValue fallback. R3: 메시지 신규 등록 대기 | 매핑(코드) · MSG 미등록 |
| + | checkRequiredOfSearch(Division 필수) | 300 | `handleSearch` division 가드 → `setAlert(**MSG00097** "Please select Division.")` | 매핑(실측) |
| + | checkRequiredOfSpread | 393 | `useSaveWithValidation`(메타 M/IM). SHEET_COLUMNS 전행 'S'라 현재 차단 대상 0 | 패턴 |

### C. gridSignals (22) — white-list (위 D00-3-001~022 서술본)

| # | AS-IS call | cs 라인 | TO-BE 매핑 | 상태 |
|---|---|---|---|---|
| 1 | SmartColMerge(InitSpread) | 223 | 공용 DataGrid 병합(초기 렌더) — 시각 사용자 축 | 패턴 |
| 2 | SwitchLock(EditButton) | 272 | `isEditMode` 토글(customButtons Edit) + DataGrid `isReadOnly={!editMode}` | 매핑 |
| 3-7 | LockColumn(DIVISION..감사) | 274-278 | 키/이름/감사 13열 `_inputEditType:'S'`(constants MAIN_COLUMNS) + `isInlineEditable` 판정 | 매핑 |
| 8 | Query(GET 바인딩) | 346 | `useTabProcQuery` o_rc1 → rows | 매핑 |
| 9 | LockColumn(0,max 전체) | 348 | 조회 시 `setEditMode(false)` → 그리드 전체 readonly | 매핑 |
| 10-12 | OPERATION_GROUP=='W' 텍스트/SetValue/center | 355-359 | Grid `formatItem` W→"Warranty" + center(opGroupNameMap) | 매핑 |
| 13-14 | SmartColMerge(조회후/TopChange) | 364,622 | 공용 DataGrid 병합 — 시각 사용자 축 | 패턴 |
| 15-22 | SetValue USER_ID/PART/TEAM/MAIL1~5 ← 팝업 | 649-824 | `handleUserSelected` → `storeChange` + row[binding]=userId | 매핑 |

### D. 팝업 (popups 11)

| AS-IS | 횟수 | TO-BE 매핑 | 상태 |
|---|---|---|---|
| UserInfoPopup(USER_ID/PART/TEAM/MAIL1~5) | 8 | `SsoUserModal`(SingleSelect) — 셀 8종 공유, `popupTargetRef` 로 대상 셀 write | 매핑 |
| SCM0002_ItembyDivisionPopup | 1 | `ItemByDivisionModal`(division/itemId 컨텍스트) | 매핑 |
| ProgressForm(FindData/SaveData) | 2 | react-query isFetching / savingRef — 로딩 스피너 대체 | 패턴 |

### E. 편집제어 상태기계 (01_layout §2.1) — 사용자 지시로 단순화(Edit 토글 제거)

- 조회(FindButton) → 그리드 기본 편집 가능(뷰/편집 토글 없음). AS-IS 조회 후 전체 lock(cs:348)·Edit(SwitchLock, cs:272)·Save 후 뷰 복귀(cs:520-525)는 미이관 결정.
- 편집 대상: 팝업 7(USER 계열) + VALID_YN 콤보. 나머지 13열은 컬럼메타(`_inputEditType:'S'`)로 lock 유지.
- Save 성공 → refetch(뷰 전환 없음).
- Insert/Delete = NO-OP(cs:254/259 override 공란) → 버튼 노출 + 클릭 무동작(hotkeyConfig insert/delete = `() => undefined`) [R5/R6]. 생략 시 SubTitle 기본 addRow/removeRow 가 실동작하므로 명시 no-op 필수.

### F. 콤보 의미 패리티 (convert-core §2.6) — TO-BE Oracle 실측(convert-gap-resolve iter-1)

| 조회조건 | AS-IS | TO-BE(실측 존재) | 재현 필터 |
|---|---|---|---|
| Division* | GetSSPInnerTable("MyDivisionCMM") | CMBO `MyDivision`(USE_YN=Y 실측) | ATTRIBUTE3<>'EE'(CMBO WHERE + 화면 방어) |
| Operation Group | GetSSPInnerTable("OPERATION_GROUP")+하드코딩 W | Lookup `OPERATION_GROUP`(P/A/E 실측 3행) + 클라 W=Warranty | W 클라 추가(cs:183-187) |
| From Site | Data_SCP.Common(PlantSiteByDivision) 다중 | CMBO `PlantSiteByDivision`(USE_YN=Y 실측) @divisionId 다중 | 서버 cascade |
| Valid | Data.Common(YesOrNo) | CMBO `YesOrNo`(USE_YN=Y 실측) | — |

### G. 커버리지 대사

- events 4/4, validations 3/3(+가드 2), gridSignals 22/22, popups 11/11, controls 24/24 매핑.
- 미매핑 0. DB 실측 완료(convert-gap-resolve iter-1, `ora.py`): 메뉴/버튼/권한/API/proc 메타(05_register.sql) 등록·검증, 컬럼메타 21행, 콤보/lookup, MSG i18n 역조회 확정.
- 잔여(R3): AS-IS MSG00251(미등록 사용자) TO-BE 메시지 미등록 → defaultValue fallback. 상세 `design/04_react-gap.md`, `gap-resolve/iter-1/notes.md`.
