# __asis-mapping__.md — design 번호 1:1 대사표 (asis-coverage-check §0.0/§0.1)

> 원천: `00_checklist.md` · 생성: asis_mapping_gate.py --init
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수 — 조회 전용 화면의 CRUD 행 등). 빈 칸 1개 = 게이트 실패.

## 이벤트·제약 (design 번호 1:1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-1-001 | §1 clbDivision / UsrCheckedList | ShipmentSemiDeptDayForm.tsx:96 (Division 다중 체크 CustomDropdown multiple allOption, Division_SCP) | - | 구현 |
| D00-1-002 | §1 txtItemId / TextBox | ShipmentSemiDeptDayForm.tsx:127 (Model InputField — prefix 직접입력, Enter 조회) | - | 구현 |
| D00-1-003 | §1 cboValidYN / UsrCombo | ShipmentSemiDeptDayForm.tsx:145 (Valid 단일 CustomDropdown, YesOrNo + ALL) | - | 구현 |
| D00-1-004 | §1 usrConditionPanel1 / UsrConditionPanel | ShipmentSemiDeptDay.tsx:327 (openSearchArea 조건부 렌더) + ShipmentSemiDeptDay.tsx:325 (MainTitle 접기/펼치기 토글) | - | 구현 |
| D00-1-005 | §1 layoutControlItem13 / LayoutControlItem | ShipmentSemiDeptDayForm.tsx:124 (Model 라벨 LBL00669 FormItem — AS-IS Text "Model", x247) | - | 구현 |
| D00-1-006 | §1 layoutControlItem3 / LayoutControlItem | ShipmentSemiDeptDayForm.tsx:142 (Valid 라벨 LBL00639 FormItem — x486) | - | 구현 |
| D00-1-007 | §1 layoutControlItem4 / LayoutControlItem | ShipmentSemiDeptDayForm.tsx:93 (Division 라벨 LBL00641 FormItem — x0) | - | 구현 |
| D00-1-008 | §1 layoutControlGroup1 / LayoutControlGroup |  | DevExpress 레이아웃 그룹 컨테이너 = 데드 스캐폴딩(design 01 §1 경고). 자체 visual 산출이 없고 TO-BE 는 공용 SearchArea + MUI Grid 가 배치를 담당해 대응 객체를 만들지 않는다(controls(16) 표 "미재현"). | 제외 |
| D00-1-009 | §1 layoutControlGroup2 / LayoutControlGroup |  | 동일 계열 컨테이너 전용 레이아웃 그룹(visual 산출 없음). TO-BE SearchArea/Grid 배치로 흡수 — 대응 객체 미생성. | 제외 |
| D00-1-010 | §1 usrLayoutControl1 / UsrLayoutControl |  | 조회영역 레이아웃 컨트롤(데드 스캐폴딩, design 01 §1). TO-BE 공용 SearchArea 가 대체하며 화면 코드에 대응 객체가 없다. | 제외 |
| D00-1-011 | §1 usrLayoutControl2 / UsrLayoutControl | ShipmentSemiDeptDayForm.tsx:74 (권한 division 상태의 단일 writer 효과) + ShipmentSemiDeptDayForm.tsx:54 (noDivisionAuth 판정 = AS-IS SetDivisionAuthCheck 대응) | 권한 division 0건이면 조회영역 3컨트롤을 disable 하고(ShipmentSemiDeptDayForm.tsx:101), 조회 경로(버튼/F5)도 차단한다(ShipmentSemiDeptDay.tsx:120 — MSG00667 alert 후 return). AS-IS 는 usrLayoutControl2.Enabled=false 로 조회영역만 무력화했으나 TO-BE 는 hotkey 경로가 별도라 페이지에서 한 번 더 막는다. 권한 상태의 writer 는 Form 의 콤보 효과 하나뿐이다 — 콤보 미도착(undefined)이면 reset(Form:76), 도착하면 set(Form:79). 페이지 mount 의 resetDivisionAuth 호출은 제거했다: React 가 자식 효과를 먼저 커밋해 set -> reset 으로 순서가 뒤집히면 캐시 재진입(gcTime 내)에서 효과가 다시 돌지 않아 조회가 영구히 막힌다. | 구현 |
| D00-1-012 | §1 emptySpaceItem3 / EmptySpaceItem |  | 레이아웃 여백 filler(정적, 기능 없음). TO-BE 는 MUI Grid size 배분으로 여백이 생성돼 대응 객체가 불필요. | 제외 |
| D00-1-013 | §1 spdMain / FpSpread | ShipmentSemiDeptDayGrid.tsx:138 (공용 DataGrid — 단일 메인 그리드) | - | 구현 |
| D00-1-014 | §1 spdMain_Sheet1 / SheetView | shipment-semi-dept-day.constants.ts:30 (ADMIN_SHEET_NAME = AS-IS SpdSheet 명 "Shipment Semi Dept Day") + shipment-semi-dept-day.constants.ts:16 (SHEETS.MAIN) | - | 구현 |
| D00-1-015 | §1 components / Container |  | WinForms Designer 의 비visual 컴포넌트 컨테이너 — 런타임 UI 산출이 없다. React 에 대응 개념 자체가 없어 이식 대상이 아니다. | 해당없음 |
| D00-1-016 | §1 imageList1 / ImageList |  | WinForms 아이콘 리소스 목록(비visual). TO-BE 아이콘은 공용 lges-icons 컴포넌트가 제공해 화면 자산으로 이식하지 않는다. | 해당없음 |
| D00-2-001 | §2 spdMain / CellClick | ShipmentSemiDeptDayGrid.tsx:103 (hostElement dblclick 핸들러 -> onItemCellDblClick) + ShipmentSemiDeptDay.tsx:166 (Item 팝업 오픈, 팝업 division = 조회 체크값 또는 권한 전체 전개) | - | 구현 |
| D00-2-002 | §2 spdMain / KeyPress | ShipmentSemiDeptDayGrid.tsx:97 (beginningEdit cancel) + shipmentSemiDeptDayEditLock.ts:47 (ITEM_ID 인라인 편집 불가 = 팝업 전용) | - | 구현 |
| D00-2-003 | §2 spdMain / TopChange | ShipmentSemiDeptDayGrid.tsx:146 (allowMerging All — 공용 CustomMergeManager sticky 가 스크롤 중 머지를 유지해 재머지 호출 불요) | - | 구현 |
| D00-3-001 | §3 SmartColMerge / () (TopChange 재머지) | ShipmentSemiDeptDayGrid.tsx:146 (allowMerging All + sticky merge — 스크롤 시 재적용 자동) | - | 구현 |
| D00-3-002 | §3 SmartColMerge / () (InitSpread 초기 머지) | ShipmentSemiDeptDayGrid.tsx:122 (DIVISION_ID allowMerging=true) + shipment-semi-dept-day.constants.ts:76 (MERGE_COLUMN) | - | 구현 |
| D00-3-003 | §3 VisibleTab / (true) |  | FpSpread 시트 탭 가시성 API. TO-BE 는 시트 탭 개념이 없는 단일 공용 DataGrid 라 대응 호출이 성립하지 않는다(그리드는 항상 표시). | 해당없음 |
| D00-3-004 | §3 Delete / () (DeleteButton — 신규행 삭제) | ShipmentSemiDeptDay.tsx:154 (GridAction.removeRow(grid, true) — 신규행만 제거) | - | 구현 |
| D00-3-005 | §3 Insert / () (InsertButton — 행 삽입) | ShipmentSemiDeptDay.tsx:142 (GridAction.addRow) + ShipmentSemiDeptDay.tsx:141 (편집모드 가드) | - | 구현 |
| D00-3-006 | §3 SetCellTypeCombo / (row, DIVISION_ID, dtMyDivision) — 신규행 Division 셀 콤보 | shipmentSemiDeptDayColumns.ts:20 (DIVISION_ID 셀 콤보 주입) + shipmentSemiDeptDayColumns.ts:21 (cellCboDataTp = Division_SCP) | - | 구현 |
| D00-3-007 | §3 SetValue / (insCell, defaultData: VALID_YN='Y') — 신규행 기본값 | ShipmentSemiDeptDay.tsx:145 (addRow VALID_YN 기본값) + shipment-semi-dept-day.constants.ts:83 (INSERT_DEFAULT_VALID_YN) | - | 구현 |
| D00-3-008 | §3 LockRange / (insCell, OPERATION_GROUP, OPERATION_GROUP, true) 신규행 잠금 | shipmentSemiDeptDayEditLock.ts:38 (신규행은 INSERT_SET 화이트리스트만 편집 = OPERATION_GROUP 잠금) + shipment-semi-dept-day.constants.ts:55 | - | 구현 |
| D00-3-009 | §3 LockRange / (insCell, NICK_NAME, NICK_NAME, true) 신규행 잠금 | shipmentSemiDeptDayEditLock.ts:38 (INSERT_SET 밖 = NICK_NAME 잠금) + shipment-semi-dept-day.constants.ts:55 | - | 구현 |
| D00-3-010 | §3 LockRange / (insCell, CREATED_BY..LAST_UPDATE_DATE, true) 신규행 감사컬럼 잠금 | shipmentSemiDeptDayEditLock.ts:38 (INSERT_SET 밖 = 감사 4컬럼 잠금) + shipment-semi-dept-day.constants.ts:55 | - | 구현 |
| D00-3-011 | §3 SwitchLock / () (EditButton — 편집모드 잠금 토글) | ShipmentSemiDeptDay.tsx:340 (Grid 에 isEditMode 상시 true 전달) + shipmentSemiDeptDayEditLock.ts:39 (열리는 셀 범위는 행상태로 판정) | **사용자 지시(2026-09-23)로 미재현**: Edit 버튼을 두지 않고 진입부터 상시 편집한다. AS-IS 의 SwitchLock 토글(전잠금<->개방) 단계 자체를 없앤 것이며, 개방 범위(기존행 DEPARTURE_DAY/VALID_YN, 신규행 +DIVISION_ID/ITEM_ID)는 그대로다. | 제외 |
| D00-3-012 | §3 LockColumn / (DIVISION_ID..NICK_NAME, true) Edit 시 조회컬럼 잠금 | shipmentSemiDeptDayEditLock.ts:39 (기존행은 EDIT_SET 만 편집) + shipment-semi-dept-day.constants.ts:51 (DEPARTURE_DAY/VALID_YN 한정) | - | 구현 |
| D00-3-013 | §3 LockColumn / (CREATED_BY..LAST_UPDATE_DATE, true) Edit 시 감사컬럼 잠금 | shipmentSemiDeptDayEditLock.ts:39 (EDIT_SET 밖 = 감사컬럼 잠금) + shipment-semi-dept-day.constants.ts:51 | - | 구현 |
| D00-3-014 | §3 Query / (ds) 조회결과 바인딩 | ShipmentSemiDeptDay.tsx:79 (useTabProcQuery) + ShipmentSemiDeptDay.tsx:88 (o_rc1 -> rows, S_VALUE_YN 별칭 정정) | - | 구현 |
| D00-3-015 | §3 LockColumn / (0, GetMaxColumnIndex(), true) 조회 후 전체 잠금 | shipmentSemiDeptDayEditLock.ts:39 (편집 범위 판정은 유지) | **사용자 지시(2026-09-23)로 미재현**: 상시 편집이라 조회 직후 전잠금 단계가 없다. 편집 가능 셀 화이트리스트(기존행 DEPARTURE_DAY/VALID_YN)는 그대로 적용된다. | 제외 |
| D00-3-016 | §3 SetValue / (e.Row, ITEM_ID, popItem.ItemID) 팝업 선택 반영 | ShipmentSemiDeptDay.tsx:188 (POPUP_FILL_MAP 루프 대입) + shipment-semi-dept-day.constants.ts:88 | - | 구현 |
| D00-3-017 | §3 SetValue / (e.Row, NICK_NAME, popItem.NickName) 팝업 선택 반영 | ShipmentSemiDeptDay.tsx:188 (동반 대입) + shipment-semi-dept-day.constants.ts:89 | - | 구현 |
| D00-4b-001 | §4b BLUtils.GetDivision / (false) / dtMyDivision | ShipmentSemiDeptDayForm.tsx:44 (조회조건 Division_SCP + mnuId 권한필터) + shipmentSemiDeptDayColumns.ts:21 (신규행 DIVISION_ID 셀 콤보 동일 소스) | - | 구현 |
| D00-4b-002 | §4b Data.Common / LookupCommon / dtDepartureDay | shipment-semi-dept-day.constants.ts:122 (DEPARTURE_DAY 셀 콤보 LookupCommon) + shipmentSemiDeptDayColumns.ts:55 (attribute1 = lookupType 전달) | - | 구현 |
| D00-4b-003 | §4b Data.Common / YesOrNo / dtYesOrNo | ShipmentSemiDeptDayForm.tsx:44 (조회조건 Valid = YesOrNo) + shipment-semi-dept-day.constants.ts:123 (그리드 VALID_YN 셀 콤보) | - | 구현 |
| D00-4d-001 | §4d DeleteButton / Delete | ShipmentSemiDeptDay.tsx:154 (removeRow deleteOnlyNew=true — 기존행 no-op, D 마킹 금지) | - | 구현 |
| D00-4d-002 | §4d SpdMain_KeyPress / (KeyPress) | ShipmentSemiDeptDayGrid.tsx:97 (beginningEdit 게이트) + shipmentSemiDeptDayEditLock.ts:43 (잠금 셀 편집 불가) | - | 구현 |
| D00-4d-003 | §4d SpdMain_KeyPress / (KeyPress) | shipmentSemiDeptDayEditLock.ts:47 (ITEM_ID 는 인라인 편집 불가) + shipment-semi-dept-day.constants.ts:73 (ITEM_POPUP_COLUMN) | - | 구현 |
| D00-4d-004 | §4d SpdMain_CellClick / (CellClick) | ShipmentSemiDeptDayGrid.tsx:105 (hitTest 결과가 데이터 셀이 아니면 return — 빈 그리드 클릭 무시) | - | 구현 |
| D00-4d-005 | §4d SpdMain_CellClick / (CellClick) | ShipmentSemiDeptDayGrid.tsx:110 (isCellEditable 게이트 = 편집 가능 상태에서만 팝업) | - | 구현 |
| D00-4d-006 | §4d SpdMain_CellClick / (CellClick) | ShipmentSemiDeptDayGrid.tsx:109 (isInsertRow 게이트) + shipmentSemiDeptDayEditLock.ts:18 | - | 구현 |
| D00-4d-007 | §4d SpdMain_CellClick / (CellClick) | ShipmentSemiDeptDayGrid.tsx:107 (isItemPopupColumn 게이트) + shipmentSemiDeptDayEditLock.ts:22 | - | 구현 |
| D00-4d-008 | §4d SpdMain_CellClick / (CellClick) | ShipmentSemiDeptDayGrid.tsx:111 (isDivisionRequired -> onDivisionRequired 후 팝업 미개방) + shipmentSemiDeptDayEditLock.ts:26 | - | 구현 |
| D00-4e-001 | §4e GMessageBoxForException / (FindData_Main catch) | ShipmentSemiDeptDay.tsx:79 (useTabProcQuery) | 조회 예외는 공용 query/apiClient 인터셉터가 표시한다 — 화면 개별 catch 를 두지 않는 것이 TO-BE 표준(직접 fetch 금지). | 구현 |
| D00-4e-002 | §4e MSG00059 / `RowCount <= 0` | ShipmentSemiDeptDay.tsx:287 (dirty 0 -> NO_DATA toast) + shipment-semi-dept-day.constants.ts:156 | AS-IS MSG00059 는 TO-BE 미등록이라 등록된 MSG00004 로 환원(iter-2 G9, 무변경 의미 정합). | 구현 |
| D00-4e-003 | §4e MSG00004 / `Rows[0][0]=="S"` | ShipmentSemiDeptDay.tsx:260 (저장 성공 toast — 건수는 .replace('{0}',…) 로 채운다. i18next 기본 보간자가 {{ }} 라 t() 인자로는 치환되지 않는다) + ShipmentSemiDeptDay.tsx:267 (성공 후 재조회) + shipment-semi-dept-day.constants.ts:154 | TO-BE 성공 문구는 MSG00672("{0} data saved."). | 구현 |
| D00-4e-004 | §4e MSG00006 / else(비"S") | ShipmentSemiDeptDay.tsx:252 (실패 alert 문구 = MSG.SAVE_FAIL) + ShipmentSemiDeptDay.tsx:249 (false-success 판정) | AS-IS MSG00006 은 TO-BE SCM_ADM_MSG_M 에 전 언어 0행(미등록, ora.py 실측)이라 EN/KO/CN 3언어로 같은 문구("Failed to save.")가 등록된 MSG00003 으로 환원했다. 미등록 코드를 두면 i18next 가 키를 못 찾아 KO/CN 사용자에게도 영문 defaultValue 가 노출된다(임의 INSERT 금지, convert-core §2.3). | 구현 |
| D00-4e-005 | §4e GMessageBoxForException / (SaveData_Main catch, iCount>0) | ShipmentSemiDeptDay.tsx:268 (doSave catch) + ShipmentSemiDeptDay.tsx:270 (예외 메시지 alert) | - | 구현 |
| D00-4e-006 | §4e MSG00093 / `IsNullOrEmpty(divisionId)` | ShipmentSemiDeptDay.tsx:367 (onDivisionRequired -> Division 선택 안내 alert) + ShipmentSemiDeptDayGrid.tsx:92 (beginningEdit 차단) | AS-IS MSG00093 -> TO-BE 는 문구 대조로 MSG00097 매핑(번호가 아니라 문구 기준). | 구현 |
| D00-4e-007 | §4e MSG00060 / `!isPass` (checkValid) | useShipmentSemiDeptDayValidation.ts:56 (DB 원장 ledgerSet 대비) + ShipmentSemiDeptDay.tsx:205 (저장 전 호출) + ShipmentSemiDeptDay.tsx:211 (alert — 등록 MSG00060 에 {0} 슬롯이 없어 대상 ITEM_ID 를 대괄호로 부기) | - | 구현 |
| D00-4e-008 | §4e MSG00060 / `!isPass` (checkValid1) | useShipmentSemiDeptDayValidation.ts:57 (그리드 내부 동일키 2건 이상) + ShipmentSemiDeptDay.tsx:205 | - | 구현 |

## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| MODAL:ItemByDivisionModal | FE 실존 모달 (components/modals/ItemByDivisionModal.tsx) — 분석 md 근거 확인 필요(FE 단독이면 사유 기입) | ItemByDivisionModal.tsx:47 (모달 본체) + ItemByDivisionModal.tsx:70 (팝업 SP 조회 SHEETS.POPUP) + ItemByDivisionModal.tsx:89 (OK 확정 -> setSelectedValue) | FE 단독 아님 — 분석 md 근거는 00_checklist §5 popups #2 `popItem` = AS-IS SCM0002_ItembyDivisionPopup. 공용 features/master 동명 모달을 쓰지 않고 화면 폴더에 로컬 구성한 것은 feature 간 직접 import 금지(Hard Boundary) 때문이며 자매 SSP0024/SSP0025 와 동일 방식. | 구현 |
| MODAL:ShowDialog | AS-IS 팝업 (분석 md) — TO-BE 모달 구현 위치 기입 의무 | ShipmentSemiDeptDay.tsx:375 (ItemByDivisionModal 마운트 = AS-IS popItem.ShowDialog 대응) + ShipmentSemiDeptDay.tsx:183 (확정 결과 -> 신규행 ITEM_ID/NICK_NAME 반영) | AS-IS 의 모달 호출 지점(ShowDialog)은 별도 팝업이 아니라 MODAL:ItemByDivisionModal 과 같은 팝업의 호출 축이다 — 추출기가 호출 메서드명을 모달명으로 잡아 행이 2개로 분리됐다. | 구현 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — --check 가 부재 행을 FAIL 처리한다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 **유지한 채** 추가 행이 보이도록 (keepRowVisibleUnderFilter — 필터 clear 금지, 1st 행3 + 2026-08-14 공통 수정사항①) | ShipmentSemiDeptDay.tsx:142 (신규행 추가는 공용 GridAction.addRow 경유) + ShipmentSemiDeptDayGrid.tsx:138 (공용 DataGrid 소비) | 공용 gridAction 의 addRow 가 신규행을 필터 예외로 등록해 필터 유지 상태에서 행이 보인다 — 화면 배선 불요. 이 화면 코드에는 필터를 clear 하는 경로가 없다(금지 위반 없음). | 구현 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703 — 1st 행4) | ShipmentSemiDeptDay.tsx:328 (공용 SubTitle 소비 — 조회 실행 전 dirty confirm 자동 래핑) + ShipmentSemiDeptDayForm.tsx:83 (공용 SearchArea 동일 경로) + ShipmentSemiDeptDayGrid.tsx:138 (공용 DataGrid 가 dirty 상태를 자동 등록) | dirty confirm 은 공용 SubTitle/SearchArea 가 조회 액션을 감싸 제공하고 dirty 등록은 공용 DataGrid 가 담당한다 — 화면 배선 불요. | 구현 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2 — 1st 행5) |  | 이 화면에는 Column/Measure 설정 진입점이 없다 — PIVOT 화면이 아니고 SHEET_MEASURE 미사용이며 SubTitle 에 customButtons 를 넘기지 않아(ShipmentSemiDeptDay.tsx:320) 설정 모달이 렌더되지 않는다. 따라서 "설정 적용 후 Reset" 상황 자체가 성립하지 않는다. 참고로 admin 컬럼 메타 변경은 mount 와 Search 마다 fetchStaticColumns 재조회(ShipmentSemiDeptDay.tsx:127)로 반영돼 stale 컬럼이 남지 않는다. | 해당없음 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 (LGES WDG 표준·hook #132 §3 — 1st 행6) | ShipmentSemiDeptDay.tsx:260 (저장 성공 = setToast success, MSG00672 건수) | 성공 알림은 Toast, 실패/검증 위반만 setAlert 로 분리했다(저장 실패 243·256, 중복 199, 필수누락 281). | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계 — 1st 행7) | ShipmentSemiDeptDay.tsx:333 (SubTitle excelFileName = 공용 엑셀 다운로드 경로) + shipmentSemiDeptDayColumns.ts:52 (콤보 컬럼 cellCboDataTp 지정 -> DataGrid dataMap 승계) | 콤보 4종(DIVISION_ID/OPERATION_GROUP/DEPARTURE_DAY/VALID_YN)이 전부 cellCboDataTp 를 갖고 있어 공용 엑셀이 dataMap 의 Name 을 출력한다. 런타임 확인은 콤보 SQL 과 GET SP 배포 후(convert-sp) 가능. | 구현 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 (1st 행8) |  | 이 화면의 유일한 key-in 조회조건은 Model(ITEM_ID)인데 GET SP 계약이 단일 prefix 매칭(`A.ITEM_ID LIKE @p_item_id + '%'`, design 02 §2.3 asis.py 실측)이라 FE 가 콤마로 분리해 보내도 전건 IN 조회가 되지 않는다 — 콤마 다중조회는 GET SP 개정(convert-sp 축) 선행이 필요하고 FE 단독으로는 충족 불가. 나머지 두 조건은 key-in 이 아니다(Division = 다중선택 콤보로 콤마 join 후 String_Split IN 조회 useShipmentSemiDeptDayStore.ts:92, Valid = 단일 드롭다운). | 해당없음 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 **필터도 그대로 적용** (rebindFilterColumns — 2026-08-14 공통 수정사항②) | ShipmentSemiDeptDayGrid.tsx:138 (공용 DataGrid 소비 — 재바인딩 시 필터-컬럼 재연결을 공용 그리드가 내부 수행) + ShipmentSemiDeptDay.tsx:128 (재조회는 filters 갱신만 수행) | 화면은 재조회 시 그리드 필터를 초기화하지 않는다 — 필터 복원은 공용 DataGrid 담당이라 화면 배선 불요. | 구현 |

## controls (16) — 영역 매핑

| AS-IS control | TO-BE | 근거 |
|---|---|---|
| clbDivision (UsrCheckedList) | ShipmentSemiDeptDayForm Division 다중 체크리스트 `CustomDropdown multiple` (Division_SCP) | Form.tsx |
| txtItemId (TextBox, "Model") | Form Model `InputField`(prefix, 팝업 없음) | Form.tsx |
| cboValidYN (UsrCombo) | Form Valid `CustomDropdown`(YesOrNo + ALL) | Form.tsx |
| usrConditionPanel1 (HidePanel) | 공용 SearchArea 접기/펼치기(openSearchArea, MainTitle 토글) | ShipmentSemiDeptDay.tsx |
| usrLayoutControl2 + SetDivisionAuthCheck | L1 권한게이트: Division_SCP 0건 -> noDivisionAuth disable + MSG00667("No authority assigned.") alert (MSG00097 선택안내와 분리, iter-2 G8) | Form.tsx |
| usrLayoutControl1 / layoutControlGroup1 | 미재현(데드 스캐폴딩, design 01 §1 경고) | — |
| layoutControlItem3/4/13 (라벨) | FormItem label (LBL00641/00669/00639) | Form.tsx |
| spdMain (FpSpread) / spdMain_Sheet1 | 공용 DataGrid (SHEETS.MAIN='main') | ShipmentSemiDeptDayGrid.tsx |
| emptySpaceItem3 / components / imageList1 | 정적/비visual — 미재현 | — |

## events (3)

| # | AS-IS | TO-BE | 근거 |
|---|---|---|---|
| 1 | spdMain.CellClick(신규행 ITEM_ID -> SCM0002 팝업) | Grid dblclick 핸들러 -> onItemCellDblClick -> ItemByDivisionModal (팝업 셀 더블클릭, nscm-patterns §5-16) | Grid.tsx |
| 2 | spdMain.KeyPress(ITEM_ID 키입력 차단 e.Handled) | beginningEdit `isInlineEditable`=false(ITEM_ID 팝업 전용) | editLock.ts / Grid.tsx |
| 3 | spdMain.TopChange(SmartColMerge 재적용) | 공용 DataGrid `allowMerging=All` + CustomMergeManager sticky(hook #69) | Grid.tsx |

## gridSignals (17)

| # | AS-IS call | TO-BE | 근거 |
|---|---|---|---|
| 1,2 | SmartColMerge (TopChange/InitSpread) | allowMerging=All + DIVISION_ID allowMerging=true(CustomMergeManager sticky, 신규행 제외) | Grid.tsx |
| 3 | VisibleTab(true) | 공용 DataGrid 기본 시트 표시 | — |
| 4 | Delete (DeleteButton) | handleDelete = GridAction.removeRow(grid, true) 신규행만 | Page |
| 5 | Insert (InsertButton) | handleInsert = GridAction.addRow(CRUD_TYPE 'I', 편집모드에서만) | Page |
| 6 | SetCellTypeCombo(DIVISION_ID, dtMyDivision) | buildColumns 가 DIVISION_ID 신규행 콤보(Division_SCP, attribute9) 주입 | columns.ts |
| 7 | SetValue(VALID_YN='Y') 신규행 기본 | handleInsert VALID_YN=INSERT_DEFAULT_VALID_YN | Page |
| 8,9,10 | LockRange(OPERATION_GROUP/NICK_NAME/CREATED_BY..LAST_UPDATE_DATE) 신규행 잠금 | INSERT_EDITABLE_COLUMNS 화이트리스트(그 외 잠금) editLock | editLock.ts |
| 11 | SwitchLock (EditButton) | 미재현 — 상시 편집(사용자 지시 2026-09-23). Edit 버튼·토글 없음 | Page |
| 12 | LockColumn(DIVISION_ID..NICK_NAME) Edit 잠금 | EDIT_EDITABLE_COLUMNS = DEPARTURE_DAY/VALID_YN 만(그 외 잠금) | editLock.ts |
| 13 | LockColumn(CREATED_BY..LAST_UPDATE_DATE) 감사 잠금 | editLock 화이트리스트 제외 | editLock.ts |
| 14 | Query(ds) Table[0] 바인딩 | useTabProcQuery o_rc1 -> rows | Page |
| 15 | LockColumn(0, max, true) 조회 후 전잠금 | 미재현 — 상시 편집이라 전잠금 단계 없음(사용자 지시 2026-09-23) | Page/editLock |
| 16,17 | SetValue(ITEM_ID/NICK_NAME) 팝업 선택 반영 | handleItemSelected POPUP_FILL_MAP -> ITEM_ID+NICK_NAME | Page |

## buttonGuards (8)

| # | AS-IS 가드 | TO-BE | 근거 |
|---|---|---|---|
| 1 | DeleteButton `action!='I' return` | handleDelete removeRow(grid,true) 신규행만(기존행 no-op) | Page |
| 2 | KeyPress `!Locked` | beginningEdit isInlineEditable 게이트 | Grid |
| 3 | KeyPress `ActiveColumn==ITEM_ID` -> Handled | ITEM_ID isInlineEditable=false(팝업 전용) | editLock |
| 4 | CellClick `Rows.Count<=0 return` | hitTest CellType.Cell 아니면 return | Grid |
| 5 | CellClick `IsLock==false`(편집모드) | dblClick isCellEditable(신규행) 게이트 | Grid |
| 6 | CellClick `GetText(row,0)=='I'` | isInsertRow(row) 게이트 | Grid |
| 7 | CellClick `Column==ITEM_ID` | isItemPopupColumn(binding) 게이트 | Grid |
| 8 | CellClick `IsNullOrEmpty(divisionId)` -> MSG00093 | isDivisionRequired(신규행 DIVISION_ID 공백) -> onDivisionRequired(MSG00097) | Grid/editLock |

## validations (8)

| # | AS-IS msgId | 조건 | TO-BE | 근거 |
|---|---|---|---|---|
| 1 | GMessageBoxForException | 조회 예외 | useTabProcQuery 에러 -> 공용 처리 | — |
| 2 | MSG00059 | 저장 RowCount<=0 | handleSave dirty 0 -> NO_DATA(MSG00004 "No changes to save.") toast — AS-IS MSG00059 는 TO-BE 미등록이라 환원(iter-2 G9, 무변경 의미 정합) | Page |
| 3 | MSG00004 | 저장 성공(Rows[0][0]=='S') | doSave 성공 -> MSG00672("{0} data saved") + refetch | Page |
| 4 | MSG00006 | 저장 실패(비'S') | doSave false-success 판정 -> MSG00006 alert | Page |
| 5 | GMessageBoxForException | 저장 예외 | doSave catch -> alert | Page |
| 6 | MSG00093(Division) | 신규행 ITEM_ID 셀 DIVISION_ID 공백 | isDivisionRequired -> MSG00097 alert | Grid |
| 7 | MSG00060 | 신규행 (Div+Item) DB 원장 중복 | findDuplicate(ledger=o_rc2) -> MSG00060 | validation.ts |
| 8 | MSG00060 | 신규행 (Div+Item) 그리드 내부 중복 | findDuplicate(grid count>1) -> MSG00060 | validation.ts |
| — | checkRequiredOfSpread(필수값) cs:318 | 라벨 * (DIVISION_ID/ITEM_ID) | findMissingRequired(dirty, REQUIRED_COLUMNS) 화면 커스텀 필수검증(inputTpCd 비의존, 빈값 alert MSG00429) + 공용 useSaveWithValidation 병행(§6-A INPUT_TP_CD 'S' 사문화 방지, G1 해소 iter-2) | validation.ts / Page |

## SP / 진입점 (spCalls 2, entryPoints 8)

| AS-IS | TO-BE | 상태 |
|---|---|---|
| SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY (Table[0] 그리드 / Table[1] 중복원장) | useTabProcQuery SHEETS.MAIN (o_rc1 rows / o_rc2 dupLedger) | SP 미배포(convert-sp 후속) |
| SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY (^-delim, I/M, D 미전송) | apiClient.post `/SCP0033/main/SAVE/call-proc` | SP 미배포(convert-sp 후속) |
| SCM0002_ItembyDivisionPopup | ItemByDivisionModal (SHEETS.POPUP) | SP 미배포(convert-sp 후속) |
| FindButton/SaveButton/DeleteButton/InsertButton | hotkeyConfig + hasButton | 05_register.sql 버튼 등록. EditButton 은 미재현(상시 편집, 사용자 지시 2026-09-23) — DB 의 main/EDIT 버튼 행은 남아 있으나 화면이 소비하지 않는다 |

## popups (2)

| AS-IS | TO-BE |
|---|---|
| prg (ProgressForm) | 공용 로딩(useTabProcQuery isFetching / ProgressIndicator 팝업) |
| popItem (SCM0002_ItembyDivisionPopup) | ItemByDivisionModal (신규행 ITEM_ID 셀, ItemID/NickName 반환) |

## 백본 밖 편입

| AS-IS | TO-BE | 근거 |
|---|---|---|
| GetAllDivisionCheckedElectrode(clbDivision) (팝업 division 재구성) | handleItemCellDblClick divisionId = 조회 체크 division join(전극 재구성은 팝업 SP 소관, 미배포) | Page §확인필요 |
| dsValiChkBinding = GET Table[1] | dupLedger = data.o_rc2 | Page |
| CString.GetCheckedListValue | store divisionIds.join(',') | Store |
| VALID_YN AS S_VALUE_YN (별칭 오타 §6-D) | rows useMemo S_VALUE_YN -> S_VALID_YN 정정 | Page |

## 커버리지 대사

- validations 8 / gridSignals 17 / buttonGuards 8 / events 3 / popups 2 / spCalls 2 / entryPoints 8 = 100% 매핑(누락 0).
- 확인 필요(런타임 축, SP 미배포): 조회/저장/팝업 C-U-D-R, OPERATION_GROUP 서버 파생, S_VALID_YN 이력 — convert-sp 배포 후 검증.
