# SCP0001 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0001_PlantSite\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0001_PlantSite\SCP0001_PlantSite.csproj | 37 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0001_PlantSite\SCP0001_PlantSite.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0001_PlantSite\SCP0001_PlantSite.csproj | 2274 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0001_PlantSite\SCP0001_PlantSite.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0001_PlantSite\SCP0001_PlantSite.csproj | 458 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:dsdm.Changed | Dsdm_Changed | 1596 | biz:CommonData.CommonDataList [code=SaleSiteByDivision] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_Main | 652 | SCP.SCP0001_GET_PLANT_SITE | MATCH | SP SCP0001_GET_PLANT_SITE |
| button:SaveButton | SaveButton > SaveData > FindData_Main | 652 | SCP.SCP0001_GET_PLANT_SITE | MATCH | SP SCP0001_GET_PLANT_SITE |
| button:SaveButton | SaveButton > SaveData > FindData_Sub | 747 | SCP.SCP0001_GET_LOCATION | MATCH | SP SCP0001_GET_LOCATION |
| button:SaveButton | SaveButton > SaveData > FindData_SubCustomer | 803 | DM.DM0004_GET_SALES_SITE_CUSTOMER_DATA | MATCH | SP DM0004_GET_SALES_SITE_CUSTOMER_DATA |
| button:SaveButton | SaveButton > SaveData > FindData_LocationOSP | 864 | SCP.SCP0001_GET_LOCATION_OSP | MATCH | SP SCP0001_GET_LOCATION_OSP |
| button:SaveButton | SaveButton > SaveData | 1001 | SCP.SCP0001_SAVE_PLANT_SITE | MATCH | SP SCP0001_SAVE_PLANT_SITE |
| button:SaveButton | SaveButton > SaveData | 1167 | SCP.SCP0001_SAVE_LOCATION | MATCH | SP SCP0001_SAVE_LOCATION |
| button:SaveButton | SaveButton > SaveData | 1294 | SCP.SCP0001_SAVE_PLANT_SITE_CUSTOMER_DATA | MATCH | SP SCP0001_SAVE_PLANT_SITE_CUSTOMER_DATA |
| button:SaveButton | SaveButton > SaveData | 1383 | SCP.SCP0001_SAVE_LOCATION_OSP | MATCH | SP SCP0001_SAVE_LOCATION_OSP |
| event:this.Load | Form_Load > InitControls | 266 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 267 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| event:this.spdMain.CellClick | SpdMain_CellClick | 1658 | biz:CommonData.CommonDataList_SCP_ALL [code=LINK_PLANT_SITE_CODE] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Sub | 747 | SCP.SCP0001_GET_LOCATION | MATCH | SP SCP0001_GET_LOCATION |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_SubCustomer | 803 | DM.DM0004_GET_SALES_SITE_CUSTOMER_DATA | MATCH | SP DM0004_GET_SALES_SITE_CUSTOMER_DATA |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_LocationOSP | 864 | SCP.SCP0001_GET_LOCATION_OSP | MATCH | SP SCP0001_GET_LOCATION_OSP |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick | 1680 | biz:CommonData.CommonDataList [code=BuildingByPlant] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick | 1691 | biz:CommonData.CommonDataList [code=StorageID] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick | 1693 | biz:CommonData.CommonDataList [code=Location] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick | 1695 | biz:CommonData.CommonDataList [code=OperationByBuilding] | BIZ_MATCH |  |
| event:this.spdSub.ComboSelChange | SpdSub_ComboSelChange | 1923 | biz:CommonData.CommonDataList [code=SaleSiteByDivision] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 52 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtCountryTypeCode> | 53 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtProdType> | 54 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtFPPlanPeriod> | 55 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtPlanPeriod> | 56 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtBuildingByPlant> | 57 | biz:CommonData.CommonDataList [code=BuildingByPlant] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtElectrodeType> | 59 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtStorage> | 60 | biz:CommonData.CommonDataList [code=StorageID] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtLocation> | 62 | biz:CommonData.CommonDataList [code=Location] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=BuildingByPlant] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_FACTORY_SN, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=Location] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 5 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=OperationByBuilding] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_LINE_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_OPERATION_SN, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=SaleSiteByDivision] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=StorageID] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SLOC, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList_SCP_ALL [code=LINK_PLANT_SITE_CODE] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList_SCP_ALL:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList_SCP_ALL:SELECT:SCM_MST_PLANT_SN |
| biz:CommonData.YesOrNo | BIZ_MATCH | 3 |  |  |  |
| DM.DM0004_GET_SALES_SITE_CUSTOMER_DATA | MATCH | 1 | SP DM0004_GET_SALES_SITE_CUSTOMER_DATA | EXEC:DM0004_GET_SALES_SITE_CUSTOMER_DATA, REF:FN_GET_DEPT_LIST, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:SCM_MST_CUSTOMER, SELECT:SCM_MST_SITE, SELECT:TB_FX_USER, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.SCP0001_GET_LOCATION | MATCH | 1 | SP SCP0001_GET_LOCATION | EXEC:SCP0001_GET_LOCATION, SELECT:SCM_MST_LOCATION, SELECT:SCM_MST_FACTORY_SN, SELECT:SCM_MST_OPERATION_SN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.SCP0001_GET_LOCATION_OSP | MATCH | 1 | SP SCP0001_GET_LOCATION_OSP | EXEC:SCP0001_GET_LOCATION_OSP, SELECT:SCM_MST_OSP_SLOC, SELECT:SCM_MST_SITE |  |
| SCP.SCP0001_GET_PLANT_SITE | MATCH | 1 | SP SCP0001_GET_PLANT_SITE | EXEC:SCP0001_GET_PLANT_SITE, SELECT:SCM_MST_SITE, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_PLANT_SN, SELECT:SCM_MST_VENDOR, SELECT:SCM_PLANT_M_SN, REF:STRING_SPLIT |  |
| SCP.SCP0001_SAVE_LOCATION | MATCH | 1 | SP SCP0001_SAVE_LOCATION | EXEC:SCP0001_SAVE_LOCATION, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, EXEC:PR_SCM_MST_LOCATION_HIST, MERGE:SCM_MST_LOCATION, INSERT:SCM_SYS_LOG_BATCH, INSERT:SCM_MST_LOCATION_H |  |
| SCP.SCP0001_SAVE_LOCATION_OSP | MATCH | 1 | SP SCP0001_SAVE_LOCATION_OSP | EXEC:SCP0001_SAVE_LOCATION_OSP, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, EXEC:PR_SCM_MST_LOCATION_OSP_HIST, MERGE:SCM_MST_OSP_SLOC, INSERT:SCM_SYS_LOG_BATCH, INSERT:SCM_MST_OSP_SLOC_H |  |
| SCP.SCP0001_SAVE_PLANT_SITE | MATCH | 1 | SP SCP0001_SAVE_PLANT_SITE | EXEC:SCP0001_SAVE_PLANT_SITE, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SCM_MST_SITE_SN, EXEC:PR_SCM_MST_SITE_HIST, EXEC:SCP0001_SAVE_SCM_MST_VENDOR, MERGE:SCM_MST_SITE, REF:FN_GET_CALC_SHIP_FROZEN_DAY_CNT, INSERT:SCM_SYS_LOG_BATCH, INSERT:SCM_MST_SITE_H, UPDATE:A, SELECT:SCM_MST_VENDOR, SELECT:SCM_PLANT_M_SN |  |
| SCP.SCP0001_SAVE_PLANT_SITE_CUSTOMER_DATA | MATCH | 1 | SP SCP0001_SAVE_PLANT_SITE_CUSTOMER_DATA | EXEC:SCP0001_SAVE_PLANT_SITE_CUSTOMER_DATA, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, EXEC:PR_DM_MST_SITE_CUSTOMER_HIST, SELECT:SCM_MST_SITE_CUSTOMER, UPDATE:SCM_MST_SITE_CUSTOMER, INSERT:SCM_MST_SITE_CUSTOMER, INSERT:SCM_SYS_LOG_BATCH, INSERT:SCM_MST_SITE_CUSTOMER_H |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| DefineProperty | drRow1 | CODE, NAME |
| DefineProperty | drRow2 | CODE, NAME |
| FindData_SubCustomer | UserInfoContext.Current | NowGroupID |
| InsertRow | dtPlanPeriod.Select().Where(c => c["code"].ToString() == DefColumns.SHIP_FROZEN).FirstOrDefault() | NAME |
| InsertRow | c | code |
| InsertRow | dtPlanPeriod.Select().Where(c => c["code"].ToString() == DefColumns.PROD_FROZEN).FirstOrDefault() | NAME |
| InsertRow | dtPlanPeriod.Select().Where(c => c["code"].ToString() == DefColumns.FP_PLAN_PERIOD).FirstOrDefault() | NAME |
| RefreshDetailSalesSite | UserInfoContext.Current | NowGroupID |
| SpdSub_ClipboardPasted | dtLocation.Select().Where(c => c["name"].ToString() == siSub.ActiveSheet.Cells[iRow, iCol].Text).FirstOrDefault() | CODE |
| SpdSub_ClipboardPasted | c | name |
| SpdSub_ClipboardPasted | dtBuildingByPlant.Select().Where(c => c["name"].ToString() == siSub.ActiveSheet.Cells[iRow, iCol].Text).FirstOrDefault() | CODE |
| SpdSub_ClipboardPasted | dtOperation.Select().Where(c => c["name"].ToString() == siSub.ActiveSheet.Cells[iRow, iCol].Text).FirstOrDefault() | CODE |
| SpdSub_ClipboardPasted | dtStorage.Select().Where(c => c["name"].ToString() == siSub.ActiveSheet.Cells[iRow, iCol].Text).FirstOrDefault() | CODE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| DataBind | InitControls:266, InitControls:267 | UsrComboBox.DataBind | CODE, NAME |
| GetCheckedListValue | RefreshPlantSite:280, RefreshPlant:286, RefreshOperation:292, RefreshDetailSalesSite:299, RefreshStorageByDivPlant:304, SetChangedControl:310, FindData_Main:636 | CString.GetCheckedListValue | CODE |
| SetSheetHeaderColumn | InitSpread:392, InitSpread:425, InitSpread:447, InitSpread:456 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| SaveData | SaveButton:616 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.spdSub | ActiveSheetChanging | spdSub_ActiveSheetChanging | InitializeComponent:349 |
| this.spdSub | CellDoubleClick | spdSub_CellDoubleClick | InitializeComponent:350 |
| this.spdSub | ComboSelChange | SpdSub_ComboSelChange | InitializeComponent:351 |
| this.spdSub | EditChange | spdSub_EditChange | InitializeComponent:352 |
| this.spdSub | TopChange | spdSub_TopChange | InitializeComponent:353 |
| this | Load | Form_Load | .ctor:187 |
| this.spdMain | CellClick | SpdMain_CellClick | .ctor:188 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | .ctor:189 |
| this.spdMain | ComboSelChange | SpdMain_ComboSelChange | .ctor:190 |
| this.spdMain | KeyPress | SpdMain_KeyPress | .ctor:191 |
| this.spdSub | CellClick | spdSub_CellClick | .ctor:193 |
| this.spdSub | ComboSelChange | SpdSub_ComboSelChange | .ctor:194 |
| this.spdSub | KeyPress | SpdMain_KeyPress | .ctor:195 |
| this.spdSub | ClipboardPasted | SpdSub_ClipboardPasted | .ctor:196 |
| dsdm | Changed | shtCustomerDataModel_Changed | InitEvent:227 |
| spdSub | ActiveSheetChanged | SpdSub_ActiveSheetChanged | InitEvent:229 |
| clbDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitControls:275 |
| dsdm | Changed | Dsdm_Changed | CreateSpread:350 |
| dsdmMain | Changed | spdMainDsdm_Changed | CreateSpread:353 |
| dsdm | Changed | Dsdm_Changed | SpdSub_ComboSelChange:1862 |
| dsdm | Changed | Dsdm_Changed | SpdSub_ComboSelChange:1942 |
| dsdmMain | Changed | spdMainDsdm_Changed | spdMainDsdm_Changed:2248 |
| dsdmMain | Changed | spdMainDsdm_Changed | spdMainDsdm_Changed:2264 |

## 6. 컨트롤 (21개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 5 | layoutControlItem6, layoutControlItem3, layoutControlItem1, layoutControlItem5, layoutControlItem2 |
| FpSpread | 2 | spdMain, spdSub |
| SheetView | 2 | spdMain_Sheet1, spdSub_Sheet1 |
| UsrComboBox | 2 | cboOutsourcing, cboValid |
| TextBox | 2 | txtPlantVendor, txtPlantSite |
| EmptySpaceItem | 2 | emptySpaceItem1, emptySpaceItem3 |
| SplitContainer | 1 | splitContainer1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl1 |
| UsrCheckedList | 1 | clbDivision |
| LayoutControlGroup | 1 | layoutControlGroup1 |
| ImageList | 1 | imageList1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 33 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 73 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 13 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 13 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 30 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0001 | Customer | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 |
| SCM_MST_SHEET_COLUMNS | SCP0001 | Location | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 |
| SCM_MST_SHEET_COLUMNS | SCP0001 | Location(OSP) | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 | 11/0 |
| SCM_MST_SHEET_COLUMNS | SCP0001 | Plant Site | 27/0 | 27/0 | 27/0 | 27/0 | 27/0 | 27/0 | 27/0 | 27/0 | 27/0 | 27/0 | 27/0 | 27/0 | 27/0 | 27/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Plant Site, Location, Customer, Location(OSP)
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:392, SetSheetHeaderColumn@InitSpread:425, SetSheetHeaderColumn@InitSpread:447, SetSheetHeaderColumn@InitSpread:456

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 120 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 121 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 122 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 123 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 369 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 370 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 371 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 372 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Customer | META+코드연결 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 |
| Location | META+코드연결 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 |
| Location(OSP) | META+코드연결 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 |
| Plant Site | META+코드연결 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 | 27 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
