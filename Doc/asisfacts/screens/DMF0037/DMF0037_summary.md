# DMF0037 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.DM.Plan.UIL\DMF0037_SalesPlanReport.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 1711 |
| only | 06.UIL\GSCM.DM.Plan.UIL\DMF0037_SalesPlanReport.Designer.cs | 06.UIL\GSCM.DM.Plan.UIL\GSCM.DM.Plan.UIL.csproj | 1629 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > InitSpread > InitSpread_X | 381 | DM.DMF0037_GET_SPREAD_TITLE_DATE | MATCH | SP DMF0037_GET_SPREAD_TITLE_DATE |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged | 795 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged | 796 | biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > InitSpread > GetSpdTitle | 1176 | DM.DMF0037_GET_SPREAD_TITLE | MATCH | SP DMF0037_GET_SPREAD_TITLE |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > GetBizTypebyDivisionAsync | 1293 | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION |
| button:FindButton | FindButton > FindData > InitSpread > InitSpread_X | 381 | DM.DMF0037_GET_SPREAD_TITLE_DATE | MATCH | SP DMF0037_GET_SPREAD_TITLE_DATE |
| button:FindButton | FindButton > FindData | 611 | DM.DMF0037_GET_DM_PLN_SALES_PLAN_DATAEx_REPORT | MATCH | SP DMF0037_GET_DM_PLN_SALES_PLAN_DATAEx_REPORT |
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle | 1176 | DM.DMF0037_GET_SPREAD_TITLE | MATCH | SP DMF0037_GET_SPREAD_TITLE |
| event:this.btnColumn.Click | btnColumn_Click > InitSpread > InitSpread_X | 381 | DM.DMF0037_GET_SPREAD_TITLE_DATE | MATCH | SP DMF0037_GET_SPREAD_TITLE_DATE |
| event:this.btnColumn.Click | btnColumn_Click > InitSpread > GetSpdTitle | 1176 | DM.DMF0037_GET_SPREAD_TITLE | MATCH | SP DMF0037_GET_SPREAD_TITLE |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread > InitSpread_X | 381 | DM.DMF0037_GET_SPREAD_TITLE_DATE | MATCH | SP DMF0037_GET_SPREAD_TITLE_DATE |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread > GetSpdTitle | 1176 | DM.DMF0037_GET_SPREAD_TITLE | MATCH | SP DMF0037_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls | 199 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 209 | biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 212 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 256 | biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_KRW] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 258 | biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_USD] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 260 | biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_LOC] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > InitSpread_X | 381 | DM.DMF0037_GET_SPREAD_TITLE_DATE | MATCH | SP DMF0037_GET_SPREAD_TITLE_DATE |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 1176 | DM.DMF0037_GET_SPREAD_TITLE | MATCH | SP DMF0037_GET_SPREAD_TITLE |
| event:this.Load | Form_Load > InitControls > GetBucketType | 1193 | DM.DMF0003_GET_BUCKET_TYPE_CODE | MATCH | SP DMF0003_GET_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > InitControls > GetItemType | 1206 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| event:this.Load | Form_Load > InitControls > GetBizTypebyDivision | 1279 | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION |
| event:this.Load | Form_Load > InitControls > GetQtyData | 1307 | DM.DMF0003_GET_QTY_TYPE_CODE | MATCH | SP DMF0003_GET_QTY_TYPE_CODE |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange > GetScmSitebyDivision | 1098 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange > GetPlantSitebyEndCustomer | 1130 | SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | MATCH | SP SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER |
| unreached:(진입점 미연결) | GetScmSitebyDivisionAsync | 1114 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |
| unreached:(진입점 미연결) | GetPlantSitebyEndCustomerAsync | 1146 | SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | MATCH | SP SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER |
| unreached:(진입점 미연결) | GetTeambyDivision | 1221 | SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | SP SCM0001_GET_TEAM_BY_DIVISION |
| unreached:(진입점 미연결) | GetTeambyDivisionAsync | 1235 | SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | SP SCM0001_GET_TEAM_BY_DIVISION |
| unreached:(진입점 미연결) | GetCustomerbyDivision | 1249 | SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | SP SCM0001_GET_CUSTOMER_BY_DIVISION |
| unreached:(진입점 미연결) | GetCustomerbyDivisionAsync | 1264 | SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | SP SCM0001_GET_CUSTOMER_BY_DIVISION |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE_ITEM, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_USER_INFO, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_DEPT_INFO, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_KRW] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_LOC] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=SALES_PLAN_AMOUNT_USD] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| DM.DMF0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DMF0003_GET_BUCKET_TYPE_CODE | EXEC:DMF0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| DM.DMF0003_GET_QTY_TYPE_CODE | MATCH | 1 | SP DMF0003_GET_QTY_TYPE_CODE | EXEC:DMF0003_GET_QTY_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| DM.DMF0037_GET_DM_PLN_SALES_PLAN_DATAEx_REPORT | MATCH | 1 | SP DMF0037_GET_DM_PLN_SALES_PLAN_DATAEx_REPORT | EXEC:DMF0037_GET_DM_PLN_SALES_PLAN_DATAEX_REPORT | ⚠ DB에 SP 없음 |
| DM.DMF0037_GET_SPREAD_TITLE | MATCH | 1 | SP DMF0037_GET_SPREAD_TITLE | EXEC:DMF0037_GET_SPREAD_TITLE | ⚠ DB에 SP 없음 |
| DM.DMF0037_GET_SPREAD_TITLE_DATE | MATCH | 1 | SP DMF0037_GET_SPREAD_TITLE_DATE | EXEC:DMF0037_GET_SPREAD_TITLE_DATE | ⚠ DB에 SP 없음 |
| SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | 2 | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION | EXEC:SCM0001_GET_BIZ_TYPE_BY_DIVISION, SELECT:SCM_MST_PROJECT, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | 2 | SP SCM0001_GET_CUSTOMER_BY_DIVISION | EXEC:SCM0001_GET_CUSTOMER_BY_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | 1 | SP SCM0001_GET_LOOKUP_VALUES | EXEC:SCM0001_GET_LOOKUP_VALUES, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | MATCH | 2 | SP SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | EXEC:SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER, SELECT:SCM_MST_SITE, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | 2 | SP SCM0001_GET_SITE_BY_DIVISION | EXEC:SCM0001_GET_SITE_BY_DIVISION, SELECT:SCM_MST_SITE, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | 2 | SP SCM0001_GET_TEAM_BY_DIVISION | EXEC:SCM0001_GET_TEAM_BY_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, REF:VALUE, REF:NODES |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| clbCustomer_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| ClbDivision_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbTeam_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| FindData | UserInfoContext.Current | NowGroupID |
| GetDayRange | UserInfoContext.Current | TimeZone |
| InitControls | UserInfoContext.Current | NowGroupID |
| InitSpread_X | nvc | p_start_yyyymmdd, p_end_yyyymmdd, p_created_by |
| InitSpread_X | dt.Rows[i] | COLLIST, COLUMN_LABEL_NAME, DESCRIPTION, NEWCOLLIST, ColumnWidth |
| InitSpread_X | dt.Rows[i - 1] | BASIS_YYYYMM, WEEK_NAME |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | InitControls:246, InitControls:247, InitControls:248, FindData:573, ClbDivision_SelectedIndexChanged:786, ClbDivision_SelectedIndexChanged:791, ClbDivision_SelectedIndexChanged:818, ClbDivision_SelectedIndexChanged:826 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:353 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| CreateSheetHeaderColumn | InitSpread:354 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:168 |
| this.txtProject | KeyDown | txtProject_KeyDown | DefineProperty:290 |
| this.txtItemId | KeyDown | txtItemId_KeyDown | DefineProperty:291 |
| clbDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:483 |
| clbSalesSite | SelectedIndexChanged | ClbSalesSite_SelectedIndexChanged | InitEvent:484 |
| clbPlantSite | SelectedIndexChanged | ClbPlantSite_SelectedIndexChanged | InitEvent:485 |
| cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitEvent:486 |
| cboKRW | SelectedIndexChanged | cboKRW_SelectedIndexChanged | FindData:733 |
| cboUSD | SelectedIndexChanged | cboUSD_SelectedIndexChanged | FindData:734 |
| cboLOC | SelectedIndexChanged | cboLOC_SelectedIndexChanged | FindData:735 |
| cboKRW | SelectedIndexChanged | cboKRW_SelectedIndexChanged | FindData:737 |
| cboUSD | SelectedIndexChanged | cboUSD_SelectedIndexChanged | FindData:738 |
| cboLOC | SelectedIndexChanged | cboLOC_SelectedIndexChanged | FindData:739 |
| this.btnMeasure | Click | btnMeasure_Click | InitializeComponent:269 |
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:306 |
| this.btnProject | Click | btnProject_Click | InitializeComponent:342 |
| this.btnItemId | Click | btnItemId_Click | InitializeComponent:412 |
| this.clbCustomer | SelectedIndexChanged | clbCustomer_SelectedIndexChanged | InitializeComponent:641 |
| this.clbTeam | SelectedIndexChanged | clbTeam_SelectedIndexChanged | InitializeComponent:681 |
| this.txtVersion | KeyDown | txtVersion_KeyDown | InitializeComponent:755 |
| this.btnVersion | Click | btnVersion_Click | InitializeComponent:791 |
| this.txtVersionB | KeyDown | txtVersionB_KeyDown | InitializeComponent:826 |
| this.btnVersionB | Click | btnVersionB_Click | InitializeComponent:862 |
| this.cboKRW | SelectedIndexChanged | cboKRW_SelectedIndexChanged | InitializeComponent:899 |
| this.cboUSD | SelectedIndexChanged | cboUSD_SelectedIndexChanged | InitializeComponent:936 |
| this.cboLOC | SelectedIndexChanged | cboLOC_SelectedIndexChanged | InitializeComponent:973 |
| this.cboQTY | SelectedIndexChanged | cboQTY_SelectedIndexChanged | InitializeComponent:1010 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:1458 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:1459 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:1460 |
| this.spdMain | KeyUp | spdMain_KeyUp | InitializeComponent:1461 |

## 6. 컨트롤 (59개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 24 | lblTeam, lblCustomer, lblBizType, lblSalesSite, lblModel, layoutControlItem3, layoutControlItem1, Period, lblProject, lblPlantSite, lblItemType, lblVersion, layoutControlItem6, lblVersion1, layoutControlItem5 … |
| UsrCheckedList | 6 | clbPlantSite, clbSalesSite, clbBizType, clbCustomer, clbTeam, clbItemType |
| UsrButton | 6 | btnMeasure, btnColumn, btnProject, btnItemId, btnVersion, btnVersionB |
| UsrCombo | 6 | cboBucketType, cboKRW, cboUSD, cboLOC, cboQTY, clbDivision |
| UsrMultiLineEditor | 4 | txtProject, txtItemId, txtVersion, txtVersionB |
| EmptySpaceItem | 4 | emptySpaceItem3, emptySpaceItem2, emptySpaceItem9, emptySpaceItem6 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrDateRangePicker | 1 | drpPeriod |
| UsrCheckBox | 1 | InternalYN |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|

## 9. 주석/비활성 처리된 호출 (1건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 1175 | DM_H.DM0023_GET_SPREAD_TITLE | commented:MATCH |

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Sales Plan Report
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumn@InitSpread:354
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread_X |  | 414 | DB루프 | AddNumColumn | {?dt.Rows[i]["DESCRIPTION"]} | {?dt.Rows[i]["NEWCOLLIST"]} | for(i < dt.Rows.Count) |
| spdMain_CellDoubleClick |  | 921 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ for(iCol < siMain.GetMaxColumnIndex()) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| spdMain_CellDoubleClick |  | 927 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ for(iCol < siMain.GetMaxColumnIndex()) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siMain.ActiveSheet.Columns[iCol].Visible) |
| spdMain_CellDoubleClick |  | 943 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ else!(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("W_") == 0) ⟫ for(iCol < siMain.GetMaxColumnIndex()) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 1070 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1074 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 1082 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 1086 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| InitializeComponent |  | 1477 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1478 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1479 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1480 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
