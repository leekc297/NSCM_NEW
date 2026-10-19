# DM0003 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.DM.Mst.UIL\DM0003_MktFcstTest97.cs | 06.UIL\GSCM.DM.Mst.UIL\GSCM.DM.Mst.UIL.csproj | 3516 |
| only | 06.UIL\GSCM.DM.Mst.UIL\DM0003_MktFcstTest97.Designer.cs | 06.UIL\GSCM.DM.Mst.UIL\GSCM.DM.Mst.UIL.csproj | 1420 |
| only | 06.UIL\GSCM.DM.Report\DM0003_TEST.cs | 06.UIL\GSCM.DM.Report\GSCM.DM.Report.csproj | 333 |
| only | 06.UIL\GSCM.DM.Report\DM0003_TEST.Designer.cs | 06.UIL\GSCM.DM.Report\GSCM.DM.Report.csproj | 241 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged | 1456 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged | 1462 | biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged > InitSpread > GetSpdTitle | 3384 | DM.DM0003_GET_SPREAD_TITLE_40 | MATCH | SP DM0003_GET_SPREAD_TITLE_40 |
| event:cboDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged > InitSpread > GetSpdTitle | 3388 | DM.DM0003_GET_SPREAD_TITLE_SML_40 | MATCH | SP DM0003_GET_SPREAD_TITLE_SML_40 |
| event:cboDivision.SelectedIndexChanged | cboDivision_SelectedIndexChanged > GetBizTypebyDivision | 3463 | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION |
| event:dsdm.Changed | spdMain_Changed | 2150 | biz:CommonData.CommonDataList [code=MktFcstEditMeasure40] | BIZ_MATCH |  |
| event:dsdm.Changed | spdMain_Changed | 2154 | biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | BIZ_MATCH |  |
| event:dsdm.Changed | spdMain_Changed | 2493 | biz:CommonData.CommonDataList [code=DefaultBucketDay] | BIZ_MATCH |  |
| event:dsdm.Changed | spdMain_Changed | 2579 | biz:CommonData.CommonDataList [code=DefaultBucketDay] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_BIZ | 181 | biz:Authentication.DoAuthentication | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_BIZ | 195 | biz:GSCM_DM_Report_BLL.BLL_DM_REORT_M | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_BIZ | 207 | biz:GSCM_DM_Report_BLL.BLL_DM_REORT_M | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData | 806 | DM.DM0003_GET_MKT_FCST_DATA_SML_40 | MATCH | SP DM0003_GET_MKT_FCST_DATA_SML_40 |
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle | 3384 | DM.DM0003_GET_SPREAD_TITLE_40 | MATCH | SP DM0003_GET_SPREAD_TITLE_40 |
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle | 3388 | DM.DM0003_GET_SPREAD_TITLE_SML_40 | MATCH | SP DM0003_GET_SPREAD_TITLE_SML_40 |
| button:InsertButton | InsertButton > InsertRow | 1222 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > InsertRow | 1237 | biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > InsertRow | 1246 | biz:CommonData.CommonDataList [code=MktFcstEditMeasure40] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData > FindData | 153 | DM.DMF_QTEST001 | MATCH | [statement] foxquery_sql\DM.DMF_QTEST001.sql |
| button:SaveButton | SaveButton > SaveData > FindData | 806 | DM.DM0003_GET_MKT_FCST_DATA_SML_40 | MATCH | SP DM0003_GET_MKT_FCST_DATA_SML_40 |
| button:SaveButton | SaveButton > SaveData | 1066 | DM.DM0003_SAVE_MKT_FCST_40 | MATCH | SP DM0003_SAVE_MKT_FCST_40 |
| button:SaveButton | SaveButton > SaveData > FindData > InitSpread > GetSpdTitle | 3384 | DM.DM0003_GET_SPREAD_TITLE_40 | MATCH | SP DM0003_GET_SPREAD_TITLE_40 |
| button:SaveButton | SaveButton > SaveData > FindData > InitSpread > GetSpdTitle | 3388 | DM.DM0003_GET_SPREAD_TITLE_SML_40 | MATCH | SP DM0003_GET_SPREAD_TITLE_SML_40 |
| event:this.btnColumn.Click | btnColumn_Click > InitSpread > GetSpdTitle | 3384 | DM.DM0003_GET_SPREAD_TITLE_40 | MATCH | SP DM0003_GET_SPREAD_TITLE_40 |
| event:this.btnColumn.Click | btnColumn_Click > InitSpread > GetSpdTitle | 3388 | DM.DM0003_GET_SPREAD_TITLE_SML_40 | MATCH | SP DM0003_GET_SPREAD_TITLE_SML_40 |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread > GetSpdTitle | 3384 | DM.DM0003_GET_SPREAD_TITLE_40 | MATCH | SP DM0003_GET_SPREAD_TITLE_40 |
| event:this.btnMeasure.Click | btnMeasure_Click > InitSpread > GetSpdTitle | 3388 | DM.DM0003_GET_SPREAD_TITLE_SML_40 | MATCH | SP DM0003_GET_SPREAD_TITLE_SML_40 |
| event:this.clbCustomer.SelectedIndexChanged | clbCustomer_SelectedIndexChanged | 1513 | biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | BIZ_MATCH |  |
| event:this.clbTeam.SelectedIndexChanged | clbTeam_SelectedIndexChanged | 1485 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.clbTeam.SelectedIndexChanged | clbTeam_SelectedIndexChanged | 1498 | biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | BIZ_MATCH |  |
| event:this.Load | Form_Load | 209 | biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | BIZ_MATCH |  |
| event:this.Load | Form_Load | 213 | biz:CommonData.CommonDataList [code=MktFcstEditMeasure40] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 238 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 263 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.Load | Form_Load > cboDivision_SelectedIndexChanged | 1456 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.Load | Form_Load > cboDivision_SelectedIndexChanged | 1462 | biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetDayRange | 3368 | DM.PR_GET_DAY_RANGE | MATCH | SP PR_GET_DAY_RANGE |
| event:this.Load | Form_Load > cboDivision_SelectedIndexChanged > InitSpread > GetSpdTitle | 3384 | DM.DM0003_GET_SPREAD_TITLE_40 | MATCH | SP DM0003_GET_SPREAD_TITLE_40 |
| event:this.Load | Form_Load > cboDivision_SelectedIndexChanged > InitSpread > GetSpdTitle | 3388 | DM.DM0003_GET_SPREAD_TITLE_SML_40 | MATCH | SP DM0003_GET_SPREAD_TITLE_SML_40 |
| event:this.Load | Form_Load > InitControls > GetBucketType | 3406 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |
| event:this.Load | Form_Load > InitControls > GetItemType | 3419 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| event:this.Load | Form_Load > cboDivision_SelectedIndexChanged > GetBizTypebyDivision | 3463 | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 1567 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 1604 | biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 1613 | biz:CommonData.CommonDataList [code=MktFcstEditMeasure40] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 1642 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 1701 | biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange | 1714 | biz:CommonData.CommonDataList [code=MktFcstEditMeasure40] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | spdMain_ComboSelChange > GetBizTypebyDivision | 3463 | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION |
| unreached:(진입점 미연결) | GetDivision | 3322 | SCM.SCM0001_GET_DIVISION | MATCH | SP SCM0001_GET_DIVISION |
| unreached:(진입점 미연결) | GetScmSitebyDivision | 3336 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |
| unreached:(진입점 미연결) | GetPlantSitebyEndCustomer | 3352 | SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | MATCH | SP SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER |
| unreached:(진입점 미연결) | GetTeambyDivision | 3434 | SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | SP SCM0001_GET_TEAM_BY_DIVISION |
| unreached:(진입점 미연결) | GetCustomerbyDivision | 3448 | SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | SP SCM0001_GET_CUSTOMER_BY_DIVISION |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:Authentication.DoAuthentication | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=DefaultBucketDay] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH | 6 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE_ITEM, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_USER_INFO, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_DEPT_INFO, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=MktFcstEditMeasure] | BIZ_MATCH | 5 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:DM_MST_CUSTOMER_FCST |
| biz:CommonData.CommonDataList [code=MktFcstEditMeasure40] | BIZ_MATCH | 5 |  |  |  |
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=SiteByEndCustomer40] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE_ITEM, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_USER_INFO, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_DEPT_INFO, UP_FX_GetCommonDataList:REF:STRING_SPLIT, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_MST_SITE, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_MST_SITE_ITEM, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_MST_SSO_USER_INFO, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_MST_SSO_DEPT_INFO, UP_FX_GETCOMMONDATALIST_DM:REF:STRING_SPLIT, UP_FX_GETCOMMONDATALIST_DM:SELECT:TB_FX_USERGROUPAUTHEXTENTION, UP_FX_GETCOMMONDATALIST_DM:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:GSCM_DM_Report_BLL.BLL_DM_REORT_M | BIZ_MATCH | 2 |  |  |  |
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| DM.DM0003_GET_MKT_FCST_DATA_SML_40 | MATCH | 1 | SP DM0003_GET_MKT_FCST_DATA_SML_40 | EXEC:DM0003_GET_MKT_FCST_DATA_SML_40 | ⚠ DB에 SP 없음 |
| DM.DM0003_GET_SPREAD_TITLE_40 | MATCH | 1 | SP DM0003_GET_SPREAD_TITLE_40 | EXEC:DM0003_GET_SPREAD_TITLE_40 | ⚠ DB에 SP 없음 |
| DM.DM0003_GET_SPREAD_TITLE_SML_40 | MATCH | 1 | SP DM0003_GET_SPREAD_TITLE_SML_40 | EXEC:DM0003_GET_SPREAD_TITLE_SML_40 | ⚠ DB에 SP 없음 |
| DM.DM0003_SAVE_MKT_FCST_40 | MATCH | 1 | SP DM0003_SAVE_MKT_FCST_40 | EXEC:DM0003_SAVE_MKT_FCST_40 | ⚠ DB에 SP 없음 |
| DM.DMF_QTEST001 | MATCH | 1 | [statement] foxquery_sql\DM.DMF_QTEST001.sql | SELECT:DM_MST_CUSTOMER_MODEL |  |
| DM.PR_GET_DAY_RANGE | MATCH | 1 | SP PR_GET_DAY_RANGE | EXEC:PR_GET_DAY_RANGE, SELECT:TB_FX_USER, SELECT:SCM_SYS_CALENDAR_M, REF:FN_MULTY_TIME, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | MATCH | 1 | SP SCM0001_GET_BIZ_TYPE_BY_DIVISION | EXEC:SCM0001_GET_BIZ_TYPE_BY_DIVISION, SELECT:SCM_MST_PROJECT, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | 1 | SP SCM0001_GET_CUSTOMER_BY_DIVISION | EXEC:SCM0001_GET_CUSTOMER_BY_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_DIVISION | MATCH | 1 | SP SCM0001_GET_DIVISION | EXEC:SCM0001_GET_DIVISION, SELECT:SCM_MST_DIVISION |  |
| SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | 1 | SP SCM0001_GET_LOOKUP_VALUES | EXEC:SCM0001_GET_LOOKUP_VALUES, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | MATCH | 1 | SP SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | EXEC:SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER, SELECT:SCM_MST_SITE, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | 1 | SP SCM0001_GET_SITE_BY_DIVISION | EXEC:SCM0001_GET_SITE_BY_DIVISION, SELECT:SCM_MST_SITE, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | 1 | SP SCM0001_GET_TEAM_BY_DIVISION | EXEC:SCM0001_GET_TEAM_BY_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, REF:VALUE, REF:NODES |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| cboDivision_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbCustomer_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| clbTeam_SelectedIndexChanged | UserInfoContext.Current | NowGroupID |
| DefineProperty | UserInfoContext.Current | NowGroupID |
| FindData | UserInfoContext.Current | NowGroupID |
| InitControls | UserInfoContext.Current | NowGroupID |
| InsertRow | UserInfoContext.Current | NowGroupID |
| SaveData | dr | A, RegtUserID |
| SaveData | saveDS.Tables[0].Rows[i] | A |
| spdMain_ComboSelChange | UserInfoContext.Current | NowGroupID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| OnShown | OnShown:219 | BaseForm.OnShown | NowGroupID, USER_ID |
| GetCheckedListValue | OnShown:221, InitControls:241, InitControls:248, InitControls:259, InitControls:269, FindData:763, FindData:764, cboDivision_SelectedIndexChanged:1416 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | InitSpread:359 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| CreateSheetHeaderColumn | InitSpread:360 | SpreadInfo.CreateSheetHeaderColumn | CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, LARGE_CLASS_LABEL_NAME, PROGRAM_ID, SHEET_NAME, SMALL_CLASS_LABEL_NAME, UPPERCASE_APPLY_FLAG, VALID_YN |
| SaveData | SaveButton:749, SaveButton:135 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| LoadData | btnCutOff_Click:3161 | UsrCheckedListBox.LoadData | APPLFACTORY, APPLSITE, CODE, FACTORY, NAME, OPERGROUP, PANELFACTORY, PANELSITE, RESOURCE, SCHGROUP, SHIFTTYPE, SITE, ShiftType |
| GetChanges | SaveData:289 | FPExtensions.GetChanges | ROW_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnOwner | Click | btnOwner_Click | InitializeComponent:216 |
| this.btnIncotermsChg | Click | btnIncotermsChg_Click | InitializeComponent:253 |
| this.btnCutOff | Click | btnCutOff_Click | InitializeComponent:329 |
| this.chkSum | CheckedChanged | chkSum_CheckedChanged | InitializeComponent:366 |
| this.btnMeasure | Click | btnMeasure_Click | InitializeComponent:442 |
| this.btnColumn | Click | btnColumn_Click | InitializeComponent:479 |
| this.btnProject | Click | btnProject_Click | InitializeComponent:515 |
| this.btnItemId | Click | btnItemId_Click | InitializeComponent:585 |
| this.cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitializeComponent:622 |
| this.clbCustomer | SelectedIndexChanged | clbCustomer_SelectedIndexChanged | InitializeComponent:815 |
| this.clbTeam | SelectedIndexChanged | clbTeam_SelectedIndexChanged | InitializeComponent:855 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:1261 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:1262 |
| this.spdMain | TopChange | spdMain_TopChange | InitializeComponent:1263 |
| this.spdMain | KeyUp | spdMain_KeyUp | InitializeComponent:1264 |
| this | Load | Form_Load | .ctor:192 |
| dsdm | Changed | spdMain_Changed | InitEvent:475 |
| cboDivision | SelectedIndexChanged | cboDivision_SelectedIndexChanged | InitEvent:477 |
| cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitEvent:478 |
| this | Load | Form_Load | .ctor:64 |

## 6. 컨트롤 (64개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 21 | lblTeam, lblCustomer, lblBizType, Period, lblSalesSite, lblModel, lblProject, layoutControlItem3, layoutControlItem1, lblBucket, layoutControlItem2, layoutControlItem4, lblPlantSite, layoutControlItem5, layoutControlItem6 … |
| UsrButton | 7 | btnOwner, btnIncotermsChg, btnCutOff, btnMeasure, btnColumn, btnProject, btnItemId |
| EmptySpaceItem | 7 | emptySpaceItem6, emptySpaceItem1, emptySpaceItem12, emptySpaceItem2, emptySpaceItem4, emptySpaceItem3, emptySpaceItem1 |
| UsrCheckedList | 6 | clbItemType, clbPlantSite, clbSalesSite, clbBizType, clbCustomer, clbTeam |
| UsrLayoutControl | 4 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 4 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| UsrMultiLineEditor | 3 | txtProject, txtItemId, txtOwner |
| UsrConditionPanel | 2 | usrConditionPanel1, usrConditionPanel1 |
| UsrCombo | 2 | cboBucketType, cboDivision |
| FpSpread | 2 | spdMain, spdMain |
| SheetView | 2 | spdMain_Sheet1, spdMain_Sheet1 |
| UsrCheckBox | 1 | chkSum |
| UsrDateRangePicker | 1 | drpPeriod |
| ImageList | 1 | imageList1 |
| UsrTextBox | 1 | usrTextBox1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 136 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 28 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 20 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.TB_FX_GroupMenuAuth | 8 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 18 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (2건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 3323 | DM.Get_Division | commented:NOT_IN_FOXQUERY |
| 3391 | DM.DM0003_GET_SPREAD_TITLE_SML_40 | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | DM0003 | Mkt Fcst | 12/8 | 12/8 | 11/7 | 11/7 | 11/7 | 11/7 | 12/8 | 12/8 | 11/7 | 11/7 | 11/7 | 11/7 | 11/7 | 11/7 |
| SCM_MST_SHEET_MEASURE | DM0003 | Mkt Fcst | 3/16 | 3/16 | 2/16 | 2/16 | 2/16 | 2/16 | 3/16 | 3/16 | 2/16 | 2/16 | 2/16 | 2/16 | 2/16 | 2/16 |

실제 SP 실행 결과 대조: 14개 시트×division 비교, 차이 1088건 (grid_diff.csv). 날짜 컬럼 등 SP가 생성하는 컬럼은 '메타에 없음'으로 표시됩니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Mkt Fcst, XXXX
- 메타 컬럼 생성 호출(프레임워크): CreateSheetHeaderColumn@InitSpread:360
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): SetSpreadHeaderSpan, SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetSpreadHeaderSpan |  | 404 | 표시/라벨 변경 | VisibleColumns | 0 |  | foreach(dr in dt.Rows) ⟫ else!("0"<= iSmallStartCol) ⟫ if(dr["COLUMN_NAME"].ToString().IndexOf("B_") > 0) |
| SetSpreadHeaderSpan |  | 417 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?dr["DAY_CODE"].ToString() == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dt.Rows) ⟫ else!("0"<= iSmallStartCol) ⟫ else!(dr["COLUMN_NAME"].ToString().IndexOf("B_") > 0) ⟫ if(dr["DAY_CODE"].ToString() == "SAT"\|\| dr["DAY_CODE"].ToString() == "SUN") |
| spdMain_CellDoubleClick |  | 1729 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ for(iCol < siMain.GetMaxColumnIndex()) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| spdMain_CellDoubleClick |  | 1735 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ for(iCol < siMain.GetMaxColumnIndex()) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siMain.ActiveSheet.Columns[iCol].Visible) |
| spdMain_CellDoubleClick |  | 1751 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ else!(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("W_") == 0) ⟫ for(iCol < siMain.GetMaxColumnIndex()) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 3184 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 3189 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(cboBucketType.ControlValues == "DAILY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 3196 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| SetSpreadColumn |  | 3200 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 3205 | 표시/라벨 변경 | set:Visible | Visible = {?chkSum.Checked} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ if(cboBucketType.ControlValues == "WEEKLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| SetSpreadColumn |  | 3212 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) |
| SetSpreadColumn |  | 3216 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(cboBucketType.ControlValues == "DAILY") ⟫ else!(cboBucketType.ControlValues == "WEEKLY") ⟫ if(cboBucketType.ControlValues == "MONTHLY") ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("D_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0) |
| InitializeComponent |  | 1280 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1281 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1282 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1283 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread |  | 96 | 하드코딩 | AddTextColumn | Column1 | CUSTOMER_PROJECT_CODE |  |
| InitSpread |  | 97 | 하드코딩 | AddTextColumn | Column2 | Column2 |  |
| InitSpread |  | 98 | 하드코딩 | AddTextColumn | Column3 | Column3 |  |
| InitializeComponent |  | 175 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 176 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 177 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 178 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Mkt Fcst | META+코드연결 | 12 | 12 | 11 | 11 | 11 | 11 | 12 | 12 | 11 | 11 | 11 | 11 | 11 | 11 |
| XXXX | 코드 하드코딩 전용(메타 없음) | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
