# __asis-mapping__.md — design 번호 1:1 대사표 (asis-coverage-check §0.0/§0.1)

> 원천: `00_checklist.md`, `01_layout.md`, `02_search-combo.md`, `03_grid-columns.md` · 생성: asis_mapping_gate.py --init
> 상태 허용값: 미구현(초기) / 구현(구현 위치 필수) / 제외(사유 필수) / 해당없음(사유 필수 — 조회 전용 화면의 CRUD 행 등). 빈 칸 1개 = 게이트 실패.

## 이벤트·제약 (design 번호 1:1)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| D00-1-001 | §1 Division / LayoutControlItem | StockOspForm.tsx:198-213 (Division FormItem) |  | 구현 |
| D00-1-002 | §1 cboDivision / UsrCombo | StockOspForm.tsx:205-210 (CustomDropdown divisionOptions) |  | 구현 |
| D00-1-003 | §1 layoutControlItem7 / LayoutControlItem | StockOspForm.tsx:215 (Plant Site FormItem 레이아웃) |  | 구현 |
| D00-1-004 | §1 clbPlantSite / UsrCheckedList | StockOspForm.tsx:221-231 (CustomDropdown multiple plantSiteOptions) |  | 구현 |
| D00-1-005 | §1 lblItemId / LayoutControlItem | StockOspForm.tsx:113-115 (Model FormItem label) |  | 구현 |
| D00-1-006 | §1 txtItemId / UsrMultiLineEditor | StockOspForm.tsx:120-137 (Model InputField sc.itemId) |  | 구현 |
| D00-1-007 | §1 layoutControlItem4 / LayoutControlItem | StockOspForm.tsx:112-140 (Model Grid size=3) |  | 구현 |
| D00-1-008 | §1 btnItemId / UsrButton | StockOspForm.tsx:125-132 (돋보기 Button onItemSearch) |  | 구현 |
| D00-1-009 | §1 layoutControlItem5 / LayoutControlItem | StockOspForm.tsx:238-244 (Period 레이아웃) |  | 구현 |
| D00-1-010 | §1 dCalendar / UsrDateRangePicker3 | StockOspForm.tsx:238-244 (PeriodField from/to) |  | 구현 |
| D00-1-011 | §1 layoutControlItem1 / LayoutControlItem | StockOspForm.tsx:146-161 (Inspection 레이아웃, Pack extra) |  | 구현 |
| D00-1-012 | §1 btnExcelUpload / UsrButton | StockOspPage.tsx:179-189 (customButtons Excel Upload, !isPack) |  | 구현 |
| D00-1-013 | §1 layoutControlItem2 / LayoutControlItem | — | AS-IS formDown(Form Download) 레이아웃 아이템 — 버튼 DB 미등록으로 미이식(§5, R7) | 제외 |
| D00-1-014 | §1 formDown / UsrButton | — | Form Download 버튼 — SCM_ADM_MNU_BTN_MPG_M 미등록(hasButton false), AS-IS 근거만으론 미러 금지 | 제외 |
| D00-1-015 | §1 layoutInspection / LayoutControlItem | StockOspForm.tsx:146-161 (Inspection FormItem, Pack extra) |  | 구현 |
| D00-1-016 | §1 txtInspection / UsrMultiLineEditor | StockOspForm.tsx:151-158 (Inspection InputField sc.inspectionId) |  | 구현 |
| D00-1-017 | §1 layStatus / LayoutControlItem | StockOspForm.tsx:162-178 (Status FormItem, Pack extra) |  | 구현 |
| D00-1-018 | §1 cboStatus / UsrCombo | StockOspForm.tsx:168-175 (Status CustomDropdown statusOptions) |  | 구현 |
| D00-1-019 | §1 layoutCutoffDate / LayoutControlItem | StockOspForm.tsx:179-185 (Cutoff Date 레이아웃, Pack extra) |  | 구현 |
| D00-1-020 | §1 dCalendarCutoff / UsrDateRangePicker3 | StockOspForm.tsx:179-185 (Cutoff PeriodField) |  | 구현 |
| D00-1-021 | §1 emptySpaceItem1 / EmptySpaceItem | — | Designer 여백 아이템 — 시각 스페이서, TO-BE Grid 레이아웃에 상응 UI 없음(순수 여백) | 해당없음 |
| D00-1-022 | §1 spdMain / FpSpread | StockOspPage.tsx:219-245 (TabWrapper 2탭 그리드 컨테이너) |  | 구현 |
| D00-1-023 | §1 spdMain_Sheet1 / SheetView | StockOspPage.tsx:225-233 (OspStockGrid), :234-244 (PackHoldStockGrid) |  | 구현 |
| D00-1-024 | §1 usrConditionPanel1 / UsrConditionPanel | StockOspForm.tsx:190-247 (SearchArea 조건 패널) |  | 구현 |
| D00-1-025 | §1 usrLayoutControl2 / UsrLayoutControl | StockOspForm.tsx:195-246 (conditions 레이아웃 컨테이너) |  | 구현 |
| D00-1-026 | §1 layoutControlGroup2 / LayoutControlGroup | StockOspForm.tsx:144-187 (packExtra 조건 그룹) |  | 구현 |
| D00-1-027 | §1 usrButton1 / UsrButton | — | 어떤 Controls 컬렉션에도 add 안 된 dead control(01_layout §5-D) — 미표시 dead 라 미이식 | 제외 |
| D00-1-028 | §1 components / Container | — | Designer IContainer(컴포넌트 트레이) — 런타임 UI 아님, React 대응 없음 | 해당없음 |
| D00-2-001 | §2 ActiveSheet / CellChanged | PackHoldStockGrid.tsx:74-101 (cellEditEnding/Ended 역전검증), OspStockGrid 조회전용(이벤트 없음) |  | 구현 |
| D00-2-002 | §2 btnExcelUpload / Click | StockOspPage.tsx:184 (action setOpenExcelUpload(true)) |  | 구현 |
| D00-2-003 | §2 btnItemId / Click | StockOspPage.tsx:202 (onItemSearch setOpenItem(true)) → ItemByDivisionModal |  | 구현 |
| D00-2-004 | §2 cboDivision / SelectedIndexChanged | StockOspForm.tsx:107-109 (onDivisionChange cascade + PlantSite 초기화) |  | 구현 |
| D00-2-005 | §2 formDown / Click | — | Form Download 버튼 미이식(D00-1-014)에 종속 — 이벤트도 미이식 | 제외 |
| D00-2-006 | §2 spdMain / EditChange | PackHoldStockGrid.tsx:84-100 (cellEditEnded 편집 반영) |  | 구현 |
| D00-2-007 | §2 spdMain / SheetTabClick | StockOspPage.tsx:104-106,222 (handleTabChange setActiveTab) |  | 구현 |
| D00-3-001 | §3 ChangeActiveSheet / (SpdSheet.shtMain) | StockOspPage.tsx:60-61 (isPack/activeSheet 파생), :207-209 (활성 탭 라우팅) |  | 구현 |
| D00-3-002 | §3 VisibleTab / (true) | StockOspPage.tsx:219-245 (2탭 상시 표시 TabWrapper) |  | 구현 |
| D00-3-003 | §3 SwitchLock / () — EditButton 편집토글 | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23). 그리드 상시 편집 default ON(convert-core §2.1(11)) — 행 편집가부는 D00-3-005~010 코드게이트로 재현 | 제외 |
| D00-3-004 | §3 LockRange / (전체셀 잠금 iRowStart..iColEnd, true) | PackHoldStockGrid.tsx:63 (EDITABLE 외 컬럼은 공용 DataGrid 가 INPUT_TP_CD='S' 로 전셀 잠금) |  | 구현 |
| D00-3-005 | §3 LockRange / (iRow, iCol_QTY, false) — HOLD 행 편집허용 | PackHoldStockGrid.tsx:57-70 (beginningEdit: HOLD 행 QTY e.cancel=false), editLock.ts:15-18 |  | 구현 |
| D00-3-006 | §3 LockRange / (iRow, DATE_FORECAST_START, false) — HOLD 행 | PackHoldStockGrid.tsx:57-70 (HOLD 행 START e.cancel=false) |  | 구현 |
| D00-3-007 | §3 LockRange / (iRow, DATE_FORECAST_FINISH, false) — HOLD 행 | PackHoldStockGrid.tsx:57-70 (HOLD 행 FINISH e.cancel=false) |  | 구현 |
| D00-3-008 | §3 LockRange / (iRow, iCol_QTY, true) — 非HOLD 행 잠금 | PackHoldStockGrid.tsx:66 (`e.cancel = !isHoldRow(row)` — 非HOLD 잠금 유지) |  | 구현 |
| D00-3-009 | §3 LockRange / (iRow, DATE_FORECAST_START, true) — 非HOLD | PackHoldStockGrid.tsx:66 (非HOLD START e.cancel=true) |  | 구현 |
| D00-3-010 | §3 LockRange / (iRow, DATE_FORECAST_FINISH, true) — 非HOLD | PackHoldStockGrid.tsx:66 (非HOLD FINISH e.cancel=true) |  | 구현 |
| D00-3-011 | §3 BackColor= / Cells[i, DATE_FORECAST_START].BackColor = LightPink | PackHoldStockGrid.tsx:106-121 (formatItem 역전행 START LightPink), constants:70 |  | 구현 |
| D00-3-012 | §3 BackColor= / Cells[i, DATE_FORECAST_FINISH].BackColor = LightPink | PackHoldStockGrid.tsx:106-121 (formatItem 역전행 FINISH LightPink) |  | 구현 |
| D00-3-013 | §3 Query / (ds) — FindData_Main 결과 바인딩 | StockOspPage.tsx:68-74,83 (useTabProcQuery OSP → ospRows), OspStockGrid rows |  | 구현 |
| D00-3-014 | §3 LockColumn / (1, GetMaxColumnIndex, true) — 조회 후 전열 잠금 | — | AS-IS 조회모드 전열잠금 = EditButton 모드토글의 일부(R12/R13). 그리드 상시 편집 default ON 이라 미이식(convert-core §2.1(11)) — Osp 시트는 메타 전건 INPUT_TP_CD='S' 로 실질 조회전용 | 제외 |
| D00-3-015 | §3 Query / (ds) — FindData_Pack 결과 바인딩 | StockOspPage.tsx:75-81,84 (useTabProcQuery PACK → packRows), PackHoldStockGrid rows |  | 구현 |
| D00-3-016 | §3 LockColumn / (1, GetMaxColumnIndex, true) — 조회 후 전열 잠금 | — | D00-3-014 와 동일 — 조회모드 전열잠금(R12/R13)은 EditButton 모드토글 미이식에 종속 | 제외 |
| D00-3-017 | §3 SetValue / (e.Row, DATE_FORECAST_START, FINISH_ORG) — 역전 되돌림 | PackHoldStockGrid.tsx:74-101 (cellEditEnding prevValue 보관 → Ended 역전 시 원복) |  | 구현 |
| D00-3-018 | §3 SetValue / (e.Row, DATE_FORECAST_FINISH, START_ORG) — 역전 되돌림 | PackHoldStockGrid.tsx:74-101 (동일 원복 경로 — 편집 컬럼 값 되돌림) |  | 구현 |
| D00-4b-001 | §4b Data.CallBizCommonData / MyDivision / dtDivision | StockOspForm.tsx:58-65 (COMBO.DIVISION Division_SCP), constants:42 |  | 구현 |
| D00-4b-002 | §4b Data.Common / PlantSiteByDivisionOSP / dtPlantSiteByDivision | StockOspForm.tsx:58-65 (COMBO.PLANT_SITE_OSP), constants:43 |  | 구현 |
| D00-4b-003 | §4b Data.Common / SaleSiteByDivision / dtSalesSiteByDivision | StockOspForm.tsx:58-65 (COMBO.SALE_SITE_OSP), constants:44 |  | 구현 |
| D00-4b-004 | §4b Data_SCP.Common / PlantSitePackerHoldStock / dtPlantSiteByDivision | StockOspForm.tsx:58-65 (COMBO.PLANT_SITE_PACK), constants:45 |  | 구현 |
| D00-4b-005 | §4b Data.CallBizCommonData / PERIOD_DEFAULT / dt | — | AS-IS 기간 기본값(PERIOD_DEFAULT) 프리셋 — TO-BE PeriodField 는 사용자 입력 기간만 사용, 기본값 자동세팅 근거 분석 md 부재로 미이식 | 제외 |
| D00-4c-001 | §4c DBUtils.Filter / dtPlantSiteByDivision | StockOspForm.tsx:79-84 (plantSiteOptions 합집합 중복제거), 콤보 SQL 내부 divisionId INSTR |  | 구현 |
| D00-4c-002 | §4c DBUtils.Filter / dtSalesSiteByDivision | StockOspForm.tsx:79-84 (SaleSite merge 필터) |  | 구현 |
| D00-4c-003 | §4c DBUtils.Filter / dtPlantSiteByDivision | StockOspForm.tsx:79-80 (Pack 탭 plantPack 단독) |  | 구현 |
| D00-4d-001 | §4d EditButton / Edit | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) — 그리드 상시 편집 default ON, 행 편집가부는 isHoldRow 코드게이트(D00-3-005~010) | 제외 |
| D00-4d-002 | §4d EditButton / Edit | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) | 제외 |
| D00-4d-003 | §4d EditButton / Edit | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) | 제외 |
| D00-4d-004 | §4d EditButton / Edit | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) | 제외 |
| D00-4d-005 | §4d EditButton / Edit | — | EditButton 토글 어포던스 자체는 전 화면 미이식 결정(asis_to_tobe.md §11, 2026-09-23) | 제외 |
| D00-4d-006 | §4d ActiveSheet_CellChanged / (검증) | PackHoldStockGrid.tsx:84-101 (cellEditEnded 역전검증), useStockOspValidation.ts:20-25 |  | 구현 |
| D00-4d-007 | §4d ActiveSheet_CellChanged / (검증) | useStockOspValidation.ts:28-38 (validateBeforeSave R4 저장직전 재검증) |  | 구현 |
| D00-4d-008 | §4d ActiveSheet_CellChanged / (검증) | PackHoldStockGrid.tsx:106-121 (formatItem 역전행 LightPink 표기 R4) |  | 구현 |

## CRUD·모달 매트릭스 (2026-08-07 축 — MAIN UI 와 모달의 CRUD 누락 0)

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| MODAL:ExcelUploadModal | AS-IS btnExcel_Upload → ExcelUploadForm2("SCP0041","Osp Stock") 파일선택 팝업 (design 01 §2 / R7) | components/modals/ExcelUploadModal.tsx:38-192, StockOspPage.tsx:261-265 |  | 구현 |
| MODAL:FPModal | AS-IS 화면에 별도 FPModal(범용 조회 팝업) 사용 없음 — Model 조회는 ItemByDivisionModal(COM0008) 단일 | — | AS-IS SCP0041_StockOSP 에 FPModal 계열 팝업 호출 없음(분석 md 근거). __init__ 자동생성 자리표시 행 — 실 대상 아님 | 해당없음 |
| MODAL:ItemByDivisionModal | AS-IS txtItemId/btnItemId Item 조회 팝업 (COM0008, design 02 §popup) | StockOspPage.tsx:249-258 (ItemByDivisionModal, setSelectedValue→itemId) |  | 구현 |

## UI 공통(통합테스트) 체크 축 (2026-08-12 — 전 화면 상시 6항목)

> 원천: `Doc/단위테스트_보완대상/통합테스트 사전점검_1st_20260806_공유용.xlsx` 구분='Common' 6행.
> 화면 분석 md 에 없는 전 UI 공통 요구 — --check 가 부재 행을 FAIL 처리한다.

| ID | 요지 (원천 md 1줄) | 구현 위치 (파일:라인) | 사유 (미구현/제외/해당없음 시 필수) | 상태 |
|---|---|---|---|---|
| COMMON:UC-01 | 필터링 상태에서 신규행 Insert 시 필터를 유지한 채 추가 행이 보이도록 (keepRowVisibleUnderFilter) | — | INSERT 버튼 DB 미등록(hasButton('INSERT')=false 미노출, StockOspPage.tsx:171). 신규행 Insert 경로 자체 부재 — Osp=조회전용, Pack=기존 HOLD 행 셀 편집만 | 해당없음 |
| COMMON:UC-02 | 데이터 수정 중 다른 데이터 조회 시도 = '수정 중인 데이터가 있습니다. 새로 조회하시겠습니까?' confirm (MSG00703) | — | AS-IS SCP0041_StockOSP.cs 에 FindButton 재조회 시 수정중 confirm 로직 없음(dirty 확인 부재). 편집 pending 은 탭 전환 시에도 보존(handleTabChange, 자동 재조회 없음) — 재조회는 Search 버튼 명시 클릭만이라 원 화면 동작상 해당 UC 미적용 | 해당없음 |
| COMMON:UC-03 | 컬럼 추가/제외(Column/Measure 설정) 적용 시 기존 조회 데이터 Reset 후 재조회 유도 (hook #132 §2-2) | 공용 SubTitle/DataGrid 위임 | PIVOT/Measure 설정 없는 정적 컬럼 그리드(SCM_MST_SHEET_COLUMNS staticColumns). Column 설정 UI 는 공용 SubTitle 위임 — 화면 고유 override 없음(DMF0045 iter-2 판정 원칙 동일) | 해당없음 |
| COMMON:UC-04 | CRUD 완료 알림 = Alert 아닌 하단 중앙 Toast 후 자동 소멸 | StockOspPage.tsx:122-128,151 |  | 구현 |
| COMMON:UC-05 | Excel Download 시 콤보 컬럼 데이터가 Code 아닌 Name 으로 출력 (gridAction dataMap 승계) | 공용 SubTitle excelFileName 위임 | Excel Download 는 공용 SubTitle(excelFileName='StockOsp', StockOspPage.tsx:210) 의 gridAction 경로 위임 — 화면 고유 dataMap override 없음 | 해당없음 |
| COMMON:UC-06 | Key-in 조회조건 = 콤마 구분 다중 입력 시 전건 조회 | StockOspForm.tsx:34-37,221-231 (pickMulti 콤마 분해 + Plant Site 다중선택) |  | 구현 |
| COMMON:UC-07 | 필터가 걸린 상태에서 재조회해도 조회되고 필터도 그대로 적용 (rebindFilterColumns) | 공용 DataGrid gridFilterRef 위임 | 필터 유지·rebind 는 공용 DataGrid(gridFilterRef: ospFilterRef/packFilterRef, StockOspPage.tsx:208) 위임 — 화면 고유 rebind override 없음 | 해당없음 |

## 1. 화면 구조 (Designer → React)

| AS-IS | TO-BE | 비고 |
|---|---|---|
| `SCP0041_StockOSP` Form | `StockOspPage.tsx` | features/supply/src/pages/stock-osp |
| `usrConditionPanel1` (조건 패널) | `<SearchArea>` (StockOspForm) | HidePanel → 접기 토글 |
| `spdMain` FpSpread 2시트 | `<TabWrapper>` 2탭 (Osp Stock / Pack Hold Stock) | 시트=탭, tabId QueryKey 분리 |
| `sheet[0] shtMain "Osp Stock"` | `<OspStockGrid>` (조회 전용 14컬럼) | |
| `sheet[1] shtPacker "Pack Hold Stock"` | `<PackHoldStockGrid>` (15컬럼, HOLD행 편집) | |

## 2. 조회조건 (5층 대조 — 02_search-combo)

| AS-IS 컨트롤 | 데이터소스(cs) | TO-BE | 콤보 SQL_ID |
|---|---|---|---|
| cboDivision (필수) | `GetDivisionWithoutEE(false,"")` cs:48 | Division CustomDropdown | Division_SCP + FE 필터 ATTRIBUTE3!=='EE' |
| clbPlantSite (Osp) | `CommonAll(...OSP1)` cs:50 + `SaleSiteByDivision1` cs:53 | Plant Site 다중 (합집합) | PlantSiteByDivisionOSP1_SCP_ALL ∪ SaleSiteByDivision1_SCP_ALL |
| clbPlantSite (Pack) | `CommonAll(...PackerHoldStock1)` cs:51 | Plant Site 다중 | PlantSitePackerHoldStock1_SCP_ALL |
| txtItemId + btnItemId | Item 팝업 | Model InputField + ItemByDivisionModal | COM0008 |
| dCalendar (필수) | 기간 | Period (PeriodField) | — |
| txtInspection (Pack) | 텍스트 | Inspection InputField (extraConditions) | — |
| cboStatus (Pack) | PACKER_HOLD_STATUS | Status CustomDropdown (extraConditions) | lookup PACKER_HOLD_STATUS (SEGMENT1=code / SEGMENT2=meaning) |
| dCalendarCutoff (Pack) | 기간 | Cutoff Date PeriodField (extraConditions) | — |

- cascade: Division 변경 → Plant Site 콤보 divisionId 파라미터 자동 재조회 + 선택 초기화. TO-BE 표준(값 필터 아님, 재쿼리).
- comma-multi(Osp OSP1/SaleSite INSTR) vs single-=(Pack PackerHoldStock) 분기는 콤보 SQL 내부 처리 — FE 는 동일하게 콤마결합 전달, 미선택/전체선택 시 빈 문자열(NULL=전체).

## 3. 동적 규칙 (01_layout §2 R1~R13)

> 참조 요약 — 정본 판정은 위 정식 대사표(D00-*)에 있다. ID 셀은 게이트 오인 방지로 대괄호 표기.

| 규칙 | AS-IS | TO-BE 구현 | 상태 |
|---|---|---|---|
| [R1] | dtDivision 0건 → SetDivisionAuthCheck 조회영역 잠금 | `noDivisionAuth` 게이트 → 조건 disabled + handleSearch alert | 반영 |
| [R2] | FindButton 탭분기 조회 | `hotkeyConfig.search=handleSearch` (활성 탭 라우팅) | 반영 |
| [R3] | SaveButton Pack 탭만 SaveDataPacker | `hotkeyConfig.save` Pack 탭 게이트 (`isPack && hasButton('SAVE')`) | 반영 |
| [R4] | InsertButton NO-OP `{ }` | `insert: hasButton('INSERT') ? () => undefined : false` (DB 미등록 → 미노출) | 반영 |
| [R5] | DeleteButton NO-OP `{ }` | `delete: hasButton('DELETE') ? () => undefined : false` (DB 미등록 → 미노출) | 반영 |
| [R6] | EditButton 모드토글 | 미이식 (convert-core §2.1(11)). editMode 상태 없음. DB 미등록 → 미노출 | 반영 |
| [R7] | btnExcelUpload / formDown (Osp 탭) | Excel Upload = customButtons + ExcelUploadModal(hasButton('UPLOAD') 게이트). Form Download = DB 미등록 미이식 | 반영(Upload) / 미이식(FormDown) |
| [R8] | 탭0: Excel 버튼 표시 / Inspection·Status·Cutoff 숨김 | Osp 탭: extraConditions 미표시 (packExtra=undefined) + Excel Upload 버튼 노출(!isPack customButtons) | 반영 |
| [R9] | 탭1: Excel 숨김 / Inspection·Status·Cutoff 표시 | Pack 탭: packExtra extraConditions 노출 | 반영 |
| [R10] | 탭 전환 시 조건세트/기간 재계산 | 탭 전환 = setActiveTab (자동 재조회 없음, Search 버튼만). 편집 pending 보존 | 반영 |
| [R11] | HOLD 행만 QTY/DATE_FORECAST_START/FINISH 편집 | `beginningEdit` + `isHoldRow` (hook #130, INPUT_TP_CD 메타 기반 — LockRange 상수 미이식) | 반영 |
| [R12/R13] | 조회 후 전열 LockColumn (조회모드) | 미이식 (모드토글 흔적, convert-core §2.1(11)) | 반영 |

## 4. validation / expressions 매핑

- **날짜 역전(R3 CellChanged cs:801-842, SetValue cs:834/838)**: `useStockOspValidation.isReversed` (DATE_FORECAST_START > DATE_FORECAST_FINISH). 셀 편집 종료 시 원복(PackHoldStockGrid cellEditEnding/Ended) + alert MSG00108. 저장 직전 재검증(R4) `validateBeforeSave`.
- **저장 실패행 BackColor LightPink(cs:449-450)**: PackHoldStockGrid formatItem → `VALIDATION_ERROR_BG='#ffb6c1'`, 역전 행의 날짜 2컬럼만 강조.
- **SaveDataPacker(action='M' 만)**: `buildSavePayload` — dirty HOLD 행만 activeFlag='M' '^' bulk. INSERT/DELETE 분기 SP 부재(R7 데이터 조작 버튼 미등록과 정합).

## 5. 미이식/보류 (사유 명시 — skill §3 예외조항)

- **Excel Upload (R7, Osp 탭)**: DB 버튼 등록됨(UPLOAD/UPLOAD_SAVE — SCM_ADM_MNU_BTN_MPG_M 실측 USE_YN=Y, 권한 각 2행, 2026-09-27 재실측 gap-resolve). SP `P_SCP0041_STOCK_OSP_EXCEL_UPLOAD` 존재. `customButtons` + `ExcelUploadModal`(파일선택 팝업 1-Step, DistributionRoute 선례)로 배선 완료 — `!isPack && hasButton('UPLOAD')` 게이트(StockOspPage.tsx:179-189). 공용 `hotkeyConfig.upload` 훅은 미사용(upload=false)이나 이는 훅 경로 미사용일 뿐 버튼은 customButtons 경로로 노출된다. GAP-03 해소.
- **Form Download (R7, Osp 탭)**: AS-IS `formDown` — DB 버튼 미등록. 미이식.
- **SaveData / SCP0040_SAVE_CHARACTERISTIC_CAPA (01_layout §5-F)**: AS-IS 정의만 존재, 호출 경로 없음(dead) → 미이식.
- **usrButton1 dead control (01_layout §5-D)**: 어떤 Controls 컬렉션에도 add 안 됨 → 미표시 dead → 미이식.
- **EditButton 모드토글(R6) / 조회모드 전열잠금(R12/R13)**: convert-core §2.1(11) 미이식 — 그리드 상시 편집 default ON.

## 6. 시트명 케이싱 (memory sht-nm-case-sensitive-per-screen)

DB SHT_NM = `Osp Stock` / `Pack Hold Stock` (실측 2026-09-27). FE `SHEETS` enum 값을 이 케이싱에 정확히 맞춤 — BE 버튼권한 검증이 대소문자 구분이므로 필수.
