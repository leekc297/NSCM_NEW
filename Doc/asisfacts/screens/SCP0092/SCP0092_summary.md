# SCP0092 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0092_RTF_ArcheivementRate\POPUP\SCP0092_PICPopup.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0092_RTF_ArcheivementRate\SCP0092_RTF_ArcheivementRate.csproj | 298 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0092_RTF_ArcheivementRate\POPUP\SCP0092_PICPopup.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0092_RTF_ArcheivementRate\SCP0092_RTF_ArcheivementRate.csproj | 279 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0092_RTF_ArcheivementRate\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0092_RTF_ArcheivementRate\SCP0092_RTF_ArcheivementRate.csproj | 37 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0092_RTF_ArcheivementRate\SCP0092_RTF_ArcheivementRate.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0092_RTF_ArcheivementRate\SCP0092_RTF_ArcheivementRate.csproj | 3456 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0092_RTF_ArcheivementRate\SCP0092_RTF_ArcheivementRate.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0092_RTF_ArcheivementRate\SCP0092_RTF_ArcheivementRate.csproj | 3004 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:btnSummaryColumn.Click | btnSummaryColumn_Click > InitSpreadSummary > SetSpreadInitSummary > SetSpdTitleSummary | 2733 | SCP.SCP0092_GET_SHEET_CALENDAR_MONTH_WEEK | MATCH | SP SCP0092_GET_SHEET_CALENDAR_MONTH_WEEK |
| event:cboSummaryDivision.SelectedIndexChanged | cboSummaryDivision_SelectedIndexChanged > InitSummaryEndCustomer | 616 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:cboSummaryDivision.SelectedIndexChanged | cboSummaryDivision_SelectedIndexChanged > InitSpreadSummary > SetSpreadInitSummary > SetSpdTitleSummary | 2733 | SCP.SCP0092_GET_SHEET_CALENDAR_MONTH_WEEK | MATCH | SP SCP0092_GET_SHEET_CALENDAR_MONTH_WEEK |
| event:cboSummaryDivision.SelectedIndexChanged | cboSummaryDivision_SelectedIndexChanged > InitSummaryItemType > GetItemType | 2777 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| event:cboWeeklyDivision.SelectedIndexChanged | cboWeeklyDivision_SelectedIndexChanged > InitWeeklyEndCustomer | 601 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:cboWeeklyDivision.SelectedIndexChanged | cboWeeklyDivision_SelectedIndexChanged > InitWeeklyItemType > GetItemType | 2777 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| event:cboWeeklyWeek.SelectedIndexChanged | cboWeeklyWeek_SelectedIndexChanged > InitWeeklyEndCustomer | 601 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:cboWeeklyWeek.SelectedIndexChanged | cboWeeklyWeek_SelectedIndexChanged > rgrpWeeklyIsPreWeek_SelectedIndexChanged > SetPlanWeek | 3232 | SCP.SCP0092_GET_RTF_ARCHEIVEMENT_RATE_WEEKLY_TERM | MATCH | SP SCP0092_GET_RTF_ARCHEIVEMENT_RATE_WEEKLY_TERM |
| event:clbSummaryTeam.SelectedIndexChanged | clbSummaryTeam_SelectedIndexChanged > InitSummaryEndCustomer | 616 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:clbWeeklyTeam.SelectedIndexChanged | clbWeeklyTeam_SelectedIndexChanged > InitWeeklyEndCustomer | 601 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData | 175 | SCP.SCP0092_GET_PIC_USERINFO_POPUP | MATCH | SP SCP0092_GET_PIC_USERINFO_POPUP |
| event:rgrpWeeklyIsPreWeek.SelectedIndexChanged | rgrpWeeklyIsPreWeek_SelectedIndexChanged > SetPlanWeek | 3232 | SCP.SCP0092_GET_RTF_ARCHEIVEMENT_RATE_WEEKLY_TERM | MATCH | SP SCP0092_GET_RTF_ARCHEIVEMENT_RATE_WEEKLY_TERM |
| event:this.btnButtonList.UsrButtonList_Click_Detected | BtnButtonList_UsrButtonList_Click_Detected > FindButton > FindData | 175 | SCP.SCP0092_GET_PIC_USERINFO_POPUP | MATCH | SP SCP0092_GET_PIC_USERINFO_POPUP |
| event:this.Load | Form_Load > FindData | 175 | SCP.SCP0092_GET_PIC_USERINFO_POPUP | MATCH | SP SCP0092_GET_PIC_USERINFO_POPUP |
| event:this.Load | Form_Load > InitControls > InitWeeklyEndCustomer | 601 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > InitSummaryEndCustomer | 616 | biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > CreateSpreadSummary > InitSpreadSummary > SetSpreadInitSummary > SetSpdTitleSummary | 2733 | SCP.SCP0092_GET_SHEET_CALENDAR_MONTH_WEEK | MATCH | SP SCP0092_GET_SHEET_CALENDAR_MONTH_WEEK |
| event:this.Load | Form_Load > InitControls > InitSummaryQty > GetQtyData | 2746 | DM.DMF0003_GET_QTY_TYPE_CODE | MATCH | SP DMF0003_GET_QTY_TYPE_CODE |
| event:this.Load | Form_Load > InitControls > InitSummaryFcstType > GetFcstType | 2759 | DM.UP_FX_GetCommonDataList_DM | MATCH | SP UP_FX_GETCOMMONDATALIST_DM |
| event:this.Load | Form_Load > InitControls > InitSummaryItemType > GetItemType | 2777 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| unreached:(진입점 미연결) | GetBucketType | 541 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |
| unreached:(진입점 미연결) | GetDivision | 2668 | SCM.SCM0001_GET_DIVISION | MATCH | SP SCM0001_GET_DIVISION |
| unreached:(진입점 미연결) | GetScmSitebyDivision | 2682 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |
| unreached:(진입점 미연결) | GetPlantSitebyEndCustomer | 2699 | SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | MATCH | SP SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER |
| unreached:(진입점 미연결) | GetDayRange | 2716 | DM.PR_GET_DAY_RANGE | MATCH | SP PR_GET_DAY_RANGE |
| unreached:(진입점 미연결) | GetTeambyDivision | 2792 | SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | SP SCM0001_GET_TEAM_BY_DIVISION |
| unreached:(진입점 미연결) | GetCustomerbyDivision | 2806 | SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | SP SCM0001_GET_CUSTOMER_BY_DIVISION |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE_ITEM, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_USER_INFO, UP_FX_GetCommonDataList:SELECT:SCM_MST_SSO_DEPT_INFO, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| DM.DMF0003_GET_QTY_TYPE_CODE | MATCH | 1 | SP DMF0003_GET_QTY_TYPE_CODE | EXEC:DMF0003_GET_QTY_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| DM.PR_GET_DAY_RANGE | MATCH | 1 | SP PR_GET_DAY_RANGE | EXEC:PR_GET_DAY_RANGE, SELECT:TB_FX_USER, SELECT:SCM_SYS_CALENDAR_M, REF:FN_MULTY_TIME, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| DM.UP_FX_GetCommonDataList_DM | MATCH | 1 | SP UP_FX_GETCOMMONDATALIST_DM | EXEC:UP_FX_GETCOMMONDATALIST_DM, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_SITE, REF:STRING_SPLIT, SELECT:TB_FX_USERGROUPAUTHEXTENTION, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_MST_SHEET_MEASURE, SELECT:SCM_SYS_CALENDAR_M, DYNAMIC@UP_FX_GETCOMMONDATALIST_DM, SELECT:SCM_ITEM_M_SN, SELECT:SCM_MST_SITE_ITEM_PRIORITY, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_LINE_HIERARCHY_V_SN, SELECT:DM_MST_BUCKET_CONVERSION, SELECT:SCM_MST_PLANT_SN |  |
| SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | MATCH | 1 | SP SCM0001_GET_CUSTOMER_BY_DIVISION | EXEC:SCM0001_GET_CUSTOMER_BY_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_DIVISION | MATCH | 1 | SP SCM0001_GET_DIVISION | EXEC:SCM0001_GET_DIVISION, SELECT:SCM_MST_DIVISION |  |
| SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | 1 | SP SCM0001_GET_LOOKUP_VALUES | EXEC:SCM0001_GET_LOOKUP_VALUES, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | MATCH | 1 | SP SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER | EXEC:SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER, SELECT:SCM_MST_SITE, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | 1 | SP SCM0001_GET_SITE_BY_DIVISION | EXEC:SCM0001_GET_SITE_BY_DIVISION, SELECT:SCM_MST_SITE, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_TEAM_BY_DIVISION | MATCH | 1 | SP SCM0001_GET_TEAM_BY_DIVISION | EXEC:SCM0001_GET_TEAM_BY_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_DEPT_INFO, REF:VALUE, REF:NODES |  |
| SCP.SCP0092_GET_PIC_USERINFO_POPUP | MATCH | 1 | SP SCP0092_GET_PIC_USERINFO_POPUP | EXEC:SCP0092_GET_PIC_USERINFO_POPUP, SELECT:SCP_MST_FINAL_ITEM, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, REF:STRING_SPLIT |  |
| SCP.SCP0092_GET_RTF_ARCHEIVEMENT_RATE_WEEKLY_TERM | MATCH | 1 | SP SCP0092_GET_RTF_ARCHEIVEMENT_RATE_WEEKLY_TERM | EXEC:SCP0092_GET_RTF_ARCHEIVEMENT_RATE_WEEKLY_TERM, SELECT:SCM_SYS_CALENDAR_M, REF:FN_NEXT_DAY, CREATE:#T_WEEKS_ALL, INSERT:#T_WEEKS_ALL, SELECT:SCP_PLN_INTERFACE_YN, INSERT:#T_WEEKS_Y, SELECT:#T_WEEKS_ALL, INSERT:#TEMP_SEQ, SELECT:SCP_PLAN_VERSION_V, SELECT:#T_WEEKS_Y, SELECT:#TEMP_SEQ, UPDATE:#T_WEEKS_ALL |  |
| SCP.SCP0092_GET_SHEET_CALENDAR_MONTH_WEEK | MATCH | 1 | SP SCP0092_GET_SHEET_CALENDAR_MONTH_WEEK | EXEC:SCP0092_GET_SHEET_CALENDAR_MONTH_WEEK, REF:FN_NEXT_DAY, INSERT:#TBL_SCP0092_WEEK_MONTH_INFO, SELECT:SCM_SYS_CALENDAR_M, SELECT:#TBL_SCP0092_WEEK_MONTH_INFO |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| AfterFindDataWeekly | ds.Tables[4].Rows[0] | DATA_ORDER |
| AfterFindDataWeekly | ds.Tables[3].Rows[0] | ISO_WEEK |
| FindDataSummary | UserInfoContext.Current | Dept_ID, NowGroupID |
| FindDataWeekly | UserInfoContext.Current | Dept_ID, NowGroupID |
| Form_Load | this._weeklys | 81, 82, 40 |
| GetFcstType | UserInfoContext.Current | NowGroupID |
| GetYearTable | newR | CODE, NAME |
| GetYearTable | r | NAME |
| HideAllSpread | this | 81, 82, 40 |
| InitSummaryEndCustomer | UserInfoContext.Current | NowGroupID |
| InitSummaryItemType | r | CODE |
| InitSummaryTeam | UserInfoContext.Current | NowGroupID |
| InitWeeklyEndCustomer | UserInfoContext.Current | NowGroupID |
| InitWeeklyItemType | r | CODE |
| InitWeeklyTeam | UserInfoContext.Current | NowGroupID |
| SetAmountCalculatingSummary | dsOldSummary.Tables[0].Rows[i] | RPT_MEASURE |
| SetPlanWeek | dt.Rows[0] | THIS_ISO_YYYYWW, PRE_ISO_YYYYWW |
| ShowSpread | this | 81, 82, 40 |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| SetSheetHeaderColumn | InitSpreadWeekly:1136, SetSpreadInitSummary:1327, SetSpreadInitWeekly:1360, SetSheetHeaderColumn:3446 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:74 |
| spdMain | CellDoubleClick | SpdMain_CellDoubleClick | .ctor:75 |
| this.btnButtonList | UsrButtonList_Click_Detected | BtnButtonList_UsrButtonList_Click_Detected | Form_Load:109 |
| this.spdMain | CellClick | SpdMain_CellClick | Form_Load:110 |
| this | Load | Form_Load | .ctor:262 |
| cboWeeklyDivision | SelectedIndexChanged | cboWeeklyDivision_SelectedIndexChanged | InitEvent:1679 |
| cboWeeklyYear | SelectedIndexChanged | cboWeeklyYear_SelectedIndexChanged | InitEvent:1680 |
| cboWeeklyWeek | SelectedIndexChanged | cboWeeklyWeek_SelectedIndexChanged | InitEvent:1681 |
| rgrpWeeklyIsPreWeek | SelectedIndexChanged | rgrpWeeklyIsPreWeek_SelectedIndexChanged | InitEvent:1682 |
| clbWeeklyTeam | SelectedIndexChanged | clbWeeklyTeam_SelectedIndexChanged | InitEvent:1683 |
| btnWeeklyProject | Click | btnWeeklyProject_Click | InitEvent:1685 |
| btnWeeklyItemId | Click | btnWeeklyItemId_Click | InitEvent:1686 |
| btnWeeklyOwner | Click | btnWeeklyOwner_Click | InitEvent:1687 |
| btnWeeklyColumn | Click | btnWeeklyColumn_Click | InitEvent:1688 |
| cboWeeklyQTY | SelectedIndexChanged | cboWeeklyQTY_SelectedIndexChanged | InitEvent:1690 |
| cboSummaryDivision | SelectedIndexChanged | cboSummaryDivision_SelectedIndexChanged | InitEvent:1694 |
| cboSummaryYear | SelectedIndexChanged | cboSummaryYear_SelectedIndexChanged | InitEvent:1695 |
| clbSummaryTeam | SelectedIndexChanged | clbSummaryTeam_SelectedIndexChanged | InitEvent:1696 |
| btnSummaryProject | Click | btnSummaryProject_Click | InitEvent:1698 |
| btnSummaryItemId | Click | btnSummaryItemId_Click | InitEvent:1699 |
| btnSummaryOwner | Click | btnSummaryOwner_Click | InitEvent:1700 |
| btnSummaryColumn | Click | btnSummaryColumn_Click | InitEvent:1701 |
| spdSummary | CellDoubleClick | spdSummary_CellDoubleClick | InitEvent:1703 |
| cboSummaryQTY | SelectedIndexChanged | cboSummaryQTY_SelectedIndexChanged | InitEvent:1705 |

## 6. 컨트롤 (140개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| EmptySpaceItem | 41 | emptySpaceItem2, emptySpaceItem1, emptySpaceItem6, emptySpaceItem7, emptySpaceItem18, emptySpaceItem21, emptySpaceItem24, emptySpaceItem27, emptySpaceItem28, emptySpaceItem29, emptySpaceItem37, emptySpaceItem39, emptySpaceItem40, emptySpaceItem41, emptySpaceItem38 … |
| LayoutControlItem | 38 | layoutControlItem1, layoutControlItem3, lblWeek, lciSummaryTeam, lciSummaryCustomer, lciSummaryColumn, lciSummaryQty, lciSummaryItemType, lciSummaryYear, lciSummaryDivision, lciSummaryModel, lciSummaryItem, lciSummaryProject, lciSummaryFcstType, lciSummaryOwner … |
| UsrCheckedList | 10 | clbSummaryTeam, clbSummaryCustomer, clbSummaryOperationGroup, clbSummaryItemType, clbSummaryFcstType, clbWeeklyTeam, clbWeeklyCustomer, clbWeeklyOperationGroup, clbWeeklyItemType, clbWeeklyFcstType |
| UsrButton | 8 | btnSummaryColumn, btnSummaryOwner, btnSummaryProject, btnSummaryItemId, btnWeeklyColumn, btnWeeklyOwner, btnWeeklyProject, btnWeeklyItemId |
| UsrCombo | 8 | cboSummaryDivision, cboSummaryQTY, cboSummaryYear, cboSummaryCategory, cboWeeklyDivision, cboWeeklyQTY, cboWeeklyYear, cboWeeklyWeek |
| UsrMultiLineEditor | 7 | txtSummaryProject, txtSummaryItemId, txtSummaryOwner, txtWeeklyProject, txtWeeklyItemId, txtWeeklyOwner, txtWeeklyPlanPreWeek |
| FpSpread | 5 | spdMain, spdSummary, spdWeekly40, spdWeekly82, spdWeekly81 |
| SheetView | 5 | spdMain_Sheet1, spdSummary_Sheet1, spdWeekly40_Sheet1, spdWeekly82_Sheet1, spdWeekly81_Sheet1 |
| UsrLayoutControl | 4 | usrLayoutControl1, ulcWeekly, ulcSummaryFIlter, ulcWeeklyFIlter |
| LayoutControlGroup | 4 | layoutControlGroup1, layoutControlGroup3, lcgSummaryFilter, lcgWeeklyFilter |
| TabPage | 2 | tabSummary, tabWeekly |
| UsrConditionPanel | 2 | ucpSummaryFilter, ucpWeeklyFilter |
| RadioGroup | 2 | rgrpSummaryIsPreWeek, rgrpWeeklyIsPreWeek |
| UsrButtonList | 1 | btnButtonList |
| UsrTextBox | 1 | txtSearch |
| TabControl | 1 | tbcSheet |
| Panel | 1 | pnlWeekly |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 163 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 96 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.SCM_MST_SHEET_MEASURE | 30 | dbmeta_dbo_SCM_MST_SHEET_MEASURE.csv |
| dbo.TB_FX_Favorite | 4 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 5 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 38 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (3건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 2351 | SCP.SCP0092_WEEKLY_GET_SPREAD_TITLE | commented:MATCH |
| 2669 | DM.Get_Division | commented:NOT_IN_FOXQUERY |
| 2822 | SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0092 | RTF Archeivement Rate Summary Report | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 | 3/0 |
| SCM_MST_SHEET_COLUMNS | SCP0092 | RTF Archeivement Rate Weekly Report - 40 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 |
| SCM_MST_SHEET_COLUMNS | SCP0092 | RTF Archeivement Rate Weekly Report - 81 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 |
| SCM_MST_SHEET_COLUMNS | SCP0092 | RTF Archeivement Rate Weekly Report - 82 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 |
| SCM_MST_SHEET_MEASURE | SCP0092 | RTF Archeivement Rate Summary Report | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 |
| SCM_MST_SHEET_MEASURE | SCP0092 | RTF Archeivement Rate Weekly Report - 82 | · | · | · | · | · | · | · | · | · | · | · | · | · | · |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: UserInfo, RTF Archeivement Rate Summary Report, {?this.SheetName}
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpreadWeekly:1136, SetSheetHeaderColumn@SetSpreadInitSummary:1327, SetSheetHeaderColumn@SetSpreadInitWeekly:1360, SetSheetHeaderColumn@SetSheetHeaderColumn:3446
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): InitSheet, InitSpreadDateColumnSummary, SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 143 | 하드코딩 | AddTextColumn | UserID | USER_ID |  |
| InitSpread |  | 144 | 하드코딩 | AddTextColumn | UserName | USER_NAME |  |
| InitSpread |  | 145 | 하드코딩 | AddTextColumn | EnglishName | USER_NAME_EN |  |
| InitSpread |  | 146 | 하드코딩 | AddTextColumn | Dept_ID | DEPT_ID |  |
| InitSpread |  | 147 | 하드코딩 | AddTextColumn | Dept_Name | DEPT_NAME |  |
| SpdMain_CellClick |  | 228 | 표시/라벨 변경 | set:Value | Value = {?false} |  | if(siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ⟫ if(siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType.GetType() == typeof(FarPoint.Win.Spread.CellType.CheckBoxCell…) ⟫ for(iRow < siMain.ActiveSheet.RowCount) ⟫ if(Convert.ToBoolean(siMain.ActiveSheet.GetValue("0", e.Column))) |
| SpdMain_CellClick |  | 233 | 표시/라벨 변경 | set:Value | Value = {?true} |  | if(siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ⟫ if(siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType.GetType() == typeof(FarPoint.Win.Spread.CellType.CheckBoxCell…) ⟫ for(iRow < siMain.ActiveSheet.RowCount) ⟫ else!(Convert.ToBoolean(siMain.ActiveSheet.GetValue("0", e.Column))) |
| InitializeComponent |  | 215 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 216 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 217 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 218 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpreadDateColumnSummary |  | 1181 | DB루프 | AddNumColumn | {?dr[DefColumnsSummary.SMALL_CLASS_LABEL_NAME]} | {?dr[DefColumnsSummary.COLUMN_NAME]} \|\| {?columnName += "_CELL"} | for(i <= dtWeeklyTitle.Rows.Count - 1) |
| InitSpreadDateColumnSummary |  | 1198 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| SetSheetColumnNumericFormat |  | 1383 | 표시/라벨 변경 | set:CellType | CellType = {?numCellType} |  | for(i <= sv.Columns.Count - 1) ⟫ if(sv.Columns["0"].DataField.IndexOf("W_") == 0 \|\| sv.Columns["0"].DataField.IndexOf("M_") == 0 \|\| sv.Columns["0"].DataField.IndexOf("YEAR") == 0) |
| spdMain_CellDoubleClick |  | 2395 | 표시/라벨 변경 | set:Visible | Visible = {?!_siSummary.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ if(_siSummary.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ for(iCol <= _siSummary.GetMaxColumnIndex()) ⟫ if(_siSummary.GetColumnTag(iCol).IndexOf("W_") == 0) |
| spdMain_CellDoubleClick |  | 2410 | 표시/라벨 변경 | set:Visible | Visible = {?!_siSummary.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ if(_siSummary.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ for(iCol <= _siSummary.GetMaxColumnIndex()) ⟫ else!(_siSummary.GetColumnTag(iCol).IndexOf("W_") == 0) ⟫ if(_siSummary.GetColumnTag(iCol).IndexOf("M_") == 0) ⟫ if(!_siSummary.ActiveSheet.Columns[iCol].Visible) |
| ElapseOrCollapseColumns |  | 3152 | 표시/라벨 변경 | set:Visible | Visible = {?this._elapsedColumns} |  | if(isAllColumn) ⟫ for(i <= endIdx) |
| ElapseOrCollapseColumns |  | 3159 | 표시/라벨 변경 | set:Visible | Visible = {?!sv.Columns[i].Visible} |  | else!(isAllColumn) ⟫ for(i <= endIdx) |
| InitializeComponent |  | 382 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 383 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 384 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 385 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 1523 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1524 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1525 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1526 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 1574 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1575 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1576 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1577 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 1625 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1626 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1627 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1628 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| RTF Archeivement Rate Summary Report | META+코드연결 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 |
| RTF Archeivement Rate Weekly Report - 40 | 메타 정의만, 코드 미참조(미사용 가능) | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 |
| RTF Archeivement Rate Weekly Report - 81 | 메타 정의만, 코드 미참조(미사용 가능) | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 |
| RTF Archeivement Rate Weekly Report - 82 | 메타 정의만, 코드 미참조(미사용 가능) | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 |
| UserInfo | 코드 하드코딩 전용(메타 없음) | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
