# DMF0066 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0066_ShipmentRequest_JV\DMF0066_ShipmentRequest_JV.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0066_ShipmentRequest_JV\DMF0066_ShipmentRequest_JV.csproj | 2412 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0066_ShipmentRequest_JV\DMF0066_ShipmentRequest_JV.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0066_ShipmentRequest_JV\DMF0066_ShipmentRequest_JV.csproj | 1129 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0066_ShipmentRequest_JV\Properties\AssemblyInfo.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0066_ShipmentRequest_JV\DMF0066_ShipmentRequest_JV.csproj | 37 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0066_ShipmentRequest_JV\Properties\Resources.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0066_ShipmentRequest_JV\DMF0066_ShipmentRequest_JV.csproj | 72 |
| current | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0066_ShipmentRequest_JV\Properties\Settings.Designer.cs | 06.UIL\GSCM.DM.Forms.UIL\Plan\DMF0066_ShipmentRequest_JV\DMF0066_ShipmentRequest_JV.csproj | 31 |
| legacy | 06.UIL\GSCM.DM.Plan.UIL\DMF0066_ShipmentRequest_JV.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 2412 |
| legacy | 06.UIL\GSCM.DM.Plan.UIL\DMF0066_ShipmentRequest_JV.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 1129 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:dsdmCell.Changed | spdMain_Changed | 1824 | biz:CommonData.CommonDataList [code=DefaultBucketDay] | BIZ_MATCH |  |
| event:dsdmCell.Changed | spdMain_Changed | 1886 | biz:CommonData.CommonDataList [code=DefaultBucketDay] | BIZ_MATCH |  |
| event:dsdmPack.Changed | spdMain_Changed | 1824 | biz:CommonData.CommonDataList [code=DefaultBucketDay] | BIZ_MATCH |  |
| event:dsdmPack.Changed | spdMain_Changed | 1886 | biz:CommonData.CommonDataList [code=DefaultBucketDay] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData | 624 | biz:CommonData.CommonDataList [code=Measure] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData | 654 | DM.DMF0045_GET_SHIPMENT_REQUEST | MATCH | SP DMF0045_GET_SHIPMENT_REQUEST |
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle | 2324 | DM.DMF0045_GET_SPREAD_TITLE | MATCH | SP DMF0045_GET_SPREAD_TITLE |
| button:InsertButton | InsertButton > InsertRow | 1047 | biz:CommonData.CommonDataList [code=FCST_TYPE] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > InsertRow | 1050 | biz:CommonData.CommonDataList [code=Measure] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData > FindData | 624 | biz:CommonData.CommonDataList [code=Measure] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData > FindData | 654 | DM.DMF0045_GET_SHIPMENT_REQUEST | MATCH | SP DMF0045_GET_SHIPMENT_REQUEST |
| button:SaveButton | SaveButton > SaveData | 942 | DM.DMF0045_SAVE_SHIPMENT_REQUEST | MATCH | SP DMF0045_SAVE_SHIPMENT_REQUEST |
| button:SaveButton | SaveButton > SaveData > FindData > InitSpread > GetSpdTitle | 2324 | DM.DMF0045_GET_SPREAD_TITLE | MATCH | SP DMF0045_GET_SPREAD_TITLE |
| event:this.btnColumn.Click | btnColumn_Click > InitSpread > GetSpdTitle | 2324 | DM.DMF0045_GET_SPREAD_TITLE | MATCH | SP DMF0045_GET_SPREAD_TITLE |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread > GetSpdTitle | 2324 | DM.DMF0045_GET_SPREAD_TITLE | MATCH | SP DMF0045_GET_SPREAD_TITLE |
| event:this.cboDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged > InitSpread > GetSpdTitle | 2324 | DM.DMF0045_GET_SPREAD_TITLE | MATCH | SP DMF0045_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > FindData_Division > InitControls | 206 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData_Division > InitControls | 270 | biz:CommonData.CommonDataList [code=Measure] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 2324 | DM.DMF0045_GET_SPREAD_TITLE | MATCH | SP DMF0045_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > FindData_Division > InitControls > GetBucketType | 2341 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > FindData_Division | 2388 | SystemManager.UP_FX_GetUserGroupAuthExtentionList | MATCH | SP UP_FX_GetUserGroupAuthExtentionList |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 1269 | biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetBizTypebyDivision | 2353 | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=DefaultBucketDay] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=FCST_TYPE] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=Measure] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SHEET_MEASURE, UP_FX_GetCommonDataList:SELECT:DM_MST_CUSTOMER_FCST |
| biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:DM_MST_CUSTOMER_FCST |
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| DM.DMF0045_GET_SHIPMENT_REQUEST | MATCH | 1 | SP DMF0045_GET_SHIPMENT_REQUEST | EXEC:DMF0045_GET_SHIPMENT_REQUEST, SELECT:TB_FX_USER, CREATE:#TBL_LOC, INSERT:#TBL_LOC, CREATE:#TBLDYNAMIC_MEASURE, INSERT:#TBLDYNAMIC_MEASURE, SELECT:SCM_MST_TITLESET_USER, INSERT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_MEASURE, UPDATE:A, SELECT:#TBLDYNAMIC_MEASURE, CREATE:#TBLDYNAMIC_SHIP_REQ, CREATE:#TBLDYNAMIC_PLAN, CREATE:#TBLDYNAMIC_SHIP_ROW, CREATE:#TBLDYNAMIC_CAL_QTY, INSERT:#TBLDYNAMIC_SHIP_REQ, SELECT:DM_PLN_SHIPMENT_REQ, SELECT:SCM_MST_SITE, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_MST_SSO_DEPT_INFO, REF:STRING_SPLIT, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCP_PLAN_VERSION_V, INSERT:#TMP_SCP_ANL_SHIPMENT_PLAN_FG, SELECT:SCP_MST_BOD_N_V, SELECT:SCP_PLN_SHIPMENT_PLAN_PEGGING, SELECT:SCP_PLN_SHIPMENT_PLAN, INSERT:#TBLDYNAMIC_PLAN, SELECT:#TMP_SCP_ANL_SHIPMENT_PLAN_FG, SELECT:SCM_SYS_CALENDAR_M, REF:FN_GET_SSP_ETD_DATE, SELECT:SCP_MST_BOD_V, SELECT:DM_PLN_MKT_FCST, SELECT:SSP_ANL_SHIP_CONFIRM, SELECT:SCM_DNM_CELL_INHOUSE_PLAN_SN, SELECT:#TBLDYNAMIC_SHIP_REQ, SELECT:#TBLDYNAMIC_PLAN, SELECT:SSP_DNM_FP_PLAN_FROZEN, SELECT:SCP_ANL_PRODUCTION_PLAN, REF:FN_NEXT_DAY, INSERT:#TBLDYNAMIC_SHIP_ROW, SELECT:SSP_DNM_STOCK_C, SELECT:#TBLDYNAMIC_SHIP_ROW, SELECT:SCM_MST_LOCATION, SELECT:#TBL_LOC, SELECT:SCP_MST_FINAL_ITEM, SELECT:SSP_DNM_ESS_PACKER_STOCK_V, DELETE:A, INSERT:#TBLDYNAMIC_REQUESTOR, INSERT:#TBLDYNAMIC_SHIP_PIVOT, SELECT:#TBLDYNAMIC_SHIP_PIVOT, UPDATE:TOT, DYNAMIC@DMF0045_GET_SHIPMENT_REQUEST |  |
| DM.DMF0045_GET_SPREAD_TITLE | MATCH | 1 | SP DMF0045_GET_SPREAD_TITLE | EXEC:DMF0045_GET_SPREAD_TITLE, SELECT:SCM_MST_SHEET_COLUMNS, REF:STRING_SPLIT, SELECT:SCM_SYS_CALENDAR_M |  |
| DM.DMF0045_SAVE_SHIPMENT_REQUEST | MATCH | 1 | SP DMF0045_SAVE_SHIPMENT_REQUEST | EXEC:DMF0045_SAVE_SHIPMENT_REQUEST, CREATE:#TBLDYNAMIC_DMF0045_SHPIMENTREQ, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, INSERT:#TBLDYNAMIC_DMF0045_SHPIMENTREQ, UPDATE:A, SELECT:#TBLDYNAMIC_DMF0045_SHPIMENTREQ, SELECT:SCP_MST_BOD, SELECT:SCP_MST_DISTRIBUTION_ROUTE, SELECT:DM_PLN_SHIPMENT_REQ, INSERT:DM_PLN_SHIPMENT_REQ, INSERT:DM_PLN_SHIPMENT_REQ_H, INSERT:SCM_SYS_LOG_BATCH |  |
| SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | 1 | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION | EXEC:SCM0001_GET_BIZ_TYPE_BY_DIVISION, SELECT:SCM_MST_PROJECT, REF:VALUE, REF:NODES |  |
| SystemManager.UP_FX_GetUserGroupAuthExtentionList | MATCH | 1 | SP UP_FX_GetUserGroupAuthExtentionList | EXEC:UP_FX_GETUSERGROUPAUTHEXTENTIONLIST, SELECT:SCM_MST_DIVISION, SELECT:TB_FX_USERGROUPAUTHEXTENTION, SELECT:SCM_MST_PLANT_SN, SELECT:SCM_MST_VENDOR, SELECT:SCM_MST_SITE |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| cboDivision_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| cboDivision_SelectedIndexChanged | c | CODE |
| clbCustomer_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbTeam_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| FindData_Division | ds.Tables[0].Rows[i] | Code, JV_PLANT_ID |
| InitControls | UserInfoContext.Current | NowGroupID |
| InitControls | dtDivision.Rows[i] | CODE |
| InitControls | c | CODE |
| InsertRow | UserInfoContext.Current | NowGroupID |
| Set_SumValues | dsBinding.Tables[0].Columns | MEASURE |
| spdMain_ComboSelChange | UserInfoContext.Current | NowGroupID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| OnShown | OnShown:187 | BaseForm.OnShown | NowGroupID, USER_ID |
| GetCheckedListValue | OnShown:189, InitControls:213, InitControls:219, InitControls:223, FindButton:462, FindData:629, FindData:664, cboDivision_SelectedIndexChanged:1132 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:310 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| CreateSheetHeaderColumn | InitSpread:311 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |
| SaveData | SaveButton:614 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnMeasure | Click | btnMeasure_Click | InitializeComponent:208 |
| this.cboDivision | SelectedIndexChanged | cboDivision_SelectedIndexChanged | InitializeComponent:243 |
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitializeComponent:280 |
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:357 |
| this.btnProject | Click | btnProject_Click | InitializeComponent:393 |
| this.btnItemId | Click | btnItemId_Click | InitializeComponent:463 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitializeComponent:500 |
| this.clbCustomer | SelectedIndexChanged | clbCustomer_SelectedIndexChanged | InitializeComponent:655 |
| this.clbTeam | SelectedIndexChanged | clbTeam_SelectedIndexChanged | InitializeComponent:695 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:980 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:981 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:982 |
| this.spdMain | KeyUp | spdMain_KeyUp | InitializeComponent:983 |
| this | Load | Form_Load | .ctor:169 |
| dsdmPack | Changed | spdMain_Changed | InitEvent:430 |
| dsdmCell | Changed | spdMain_Changed | InitEvent:433 |

## 6. 컨트롤 (45개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 17 | lblItemType, layoutControlItem5, layoutControlItem6, layoutControlItem2, layoutControlItem7, lblTeam, lblCustomer, Period, lblSalesSite, lblModel, lblProject, layoutControlItem3, layoutControlItem1, lblPlantSite, clbDivision … |
| EmptySpaceItem | 6 | emptySpaceItem8, emptySpaceItem1, emptySpaceItem12, emptySpaceItem2, emptySpaceItem3, emptySpaceItem6 |
| UsrButton | 4 | btnMeasure, btnColumn, btnProject, btnItemId |
| UsrCheckedList | 4 | clbPlantSite, clbSalesSite, clbCustomer, clbTeam |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrCombo | 2 | cboDivision, cboBucketType |
| UsrMultiLineEditor | 2 | txtProject, txtItemId |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrCheckBox | 1 | chkSum |
| UsrDateRangePicker | 1 | drpPeriod |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |
| ImageList | 1 | imageList1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 32 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 22 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.SCM_MST_TITLESET_USER | 12 | dbmeta_dbo_SCM_MST_TITLESET_USER.csv |
| dbo.TB_FX_GroupMenuAuth | 5 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | DMF0066 | Cell Biz | · | 13/0 | · | · | · | · | 13/0 | 13/0 | · | · | · | · | · | · |
| SCM_MST_SHEET_COLUMNS | DMF0066 | Pack Biz | · | 13/0 | · | · | · | · | 13/0 | 13/0 | · | · | · | · | · | · |
| SCM_MST_SHEET_MEASURE | DMF0066 | Cell Biz | · | 12/0 | · | · | · | · | 12/0 | 12/0 | · | · | · | · | · | · |
| SCM_MST_SHEET_MEASURE | DMF0066 | Pack Biz | · | 10/0 | · | · | · | · | 10/0 | 10/0 | · | · | · | · | · | · |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Pack Biz, Cell Biz
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumn@InitSpread:311
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): SetSpreadHeaderSpan, SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetSpreadHeaderSpan |  | 374 | 표시/라벨 변경 | VisibleColumns | 0 |  | foreach(dr in dt.Rows) ⟫ else!("0"<= iSmallStartCol) ⟫ if(dr["COLUMN_NAME"].ToString().IndexOf("B_") > 0) |
| SetSpreadHeaderSpan |  | 385 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?dr["DAY_CODE"].ToString() == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dt.Rows) ⟫ else!("0"<= iSmallStartCol) ⟫ else!(dr["COLUMN_NAME"].ToString().IndexOf("B_") > 0) ⟫ if(dr["DAY_CODE"].ToString() == "SAT"\|\| dr["DAY_CODE"].ToString() == "SUN") |
| spdMain_CellDoubleClick |  | 1286 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ for(iCol < siMain.GetMaxColumnIndex()) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| spdMain_CellDoubleClick |  | 1292 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ for(iCol < siMain.GetMaxColumnIndex()) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siMain.ActiveSheet.Columns[iCol].Visible) |
| spdMain_CellDoubleClick |  | 1308 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ else!(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("W_") == 0) ⟫ for(iCol < siMain.GetMaxColumnIndex()) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 2227 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 2232 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 2239 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 2243 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 2248 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 2255 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 2259 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| InitializeComponent |  | 999 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1000 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1001 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1002 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Cell Biz | META+코드연결 | · | 13 | · | · | · | · | 13 | 13 | · | · | · | · | · | · |
| Pack Biz | META+코드연결 | · | 13 | · | · | · | · | 13 | 13 | · | · | · | · | · | · |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
