# SCP0201 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0201_CAPA.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0201_CAPA.UIL\SCP0201_CAPA.UIL.csproj | 37 |
| current | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0201_CAPA.UIL\SCP0201_CAPA.cs | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0201_CAPA.UIL\SCP0201_CAPA.UIL.csproj | 2807 |
| current | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0201_CAPA.UIL\SCP0201_CAPA.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0201_CAPA.UIL\SCP0201_CAPA.UIL.csproj | 2425 |
| current | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0201_CAPA.UIL\TestCode.cs | 06.UIL\GSCM.FP.Forms.UIL\CAPA\SCP0201_CAPA.UIL\SCP0201_CAPA.UIL.csproj | 48 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 423 | biz:CommonData.CommonDataList [code=OperationByLine] | BIZ_MATCH |  |
| event:cboGroup.SelectedIndexChanged | CboGroup_SelectedIndexChanged | 2345 | biz:CommonData.CommonDataList [code=OperationByLine] | BIZ_MATCH |  |
| event:clbBuilding.SelectedIndexChanged | ClbBuilding_SelectedIndexChanged | 2380 | biz:CommonData.CommonDataList [code=OperationByLine] | BIZ_MATCH |  |
| event:clbLine.SelectedIndexChanged | ClbLine_SelectedIndexChanged | 2425 | biz:CommonData.CommonDataList [code=OperationByLine] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged | 2364 | biz:CommonData.CommonDataList [code=OperationByLine] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_Main | 877 | SCP.SCP0201_GET_CAPA | MATCH | SP SCP0049_GET_CAPA_chool |
| button:FindButton | FindButton > FindData_Main > InitSpread > SetSpreadInit > GetSpdTitle | 1419 | SCP.SCP0049_GET_SHEET_CALENDAR | MATCH | SP SCP0049_GET_SHEET_CALENDAR |
| button:FindButton | FindButton > FindData_Main > InitSpread > GetUserTitle | 1438 | SCP.SCP0049_GET_SHEET_USER_TITLE | MATCH | SP SCP0049_GET_SHEET_USER_TITLE |
| button:SaveButton | SaveButton > SaveData_Main | 1241 | biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.SCP0049_SAVE_CAPA] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData_Main | 1241 | {?definition_path}#dbo.SCP0049_SAVE_CAPA | UNRESOLVED |  |
| button:SaveButton | SaveButton > SaveData_Main > SCM_SYS_LOG_BATCH | 1303 | SCP.PR_SCM_SYS_LOG_BATCH | MATCH | SP PR_SCM_SYS_LOG_BATCH |
| event:this.btnColumn.Click | BtnColumn_Click > InitSpread > SetSpreadInit > GetSpdTitle | 1419 | SCP.SCP0049_GET_SHEET_CALENDAR | MATCH | SP SCP0049_GET_SHEET_CALENDAR |
| event:this.btnColumn.Click | BtnColumn_Click > InitSpread > GetUserTitle | 1438 | SCP.SCP0049_GET_SHEET_USER_TITLE | MATCH | SP SCP0049_GET_SHEET_USER_TITLE |
| event:this.btnExcelUpload.Click | btnExcelUpload_Click > FindData_Main | 877 | SCP.SCP0201_GET_CAPA | MATCH | SP SCP0049_GET_CAPA_chool |
| event:this.btnExcelUpload.Click | btnExcelUpload_Click > FindData_Main > InitSpread > SetSpreadInit > GetSpdTitle | 1419 | SCP.SCP0049_GET_SHEET_CALENDAR | MATCH | SP SCP0049_GET_SHEET_CALENDAR |
| event:this.btnExcelUpload.Click | btnExcelUpload_Click > FindData_Main > InitSpread > GetUserTitle | 1438 | SCP.SCP0049_GET_SHEET_USER_TITLE | MATCH | SP SCP0049_GET_SHEET_USER_TITLE |
| event:this.btnRequest.Click | BtnRequest_Click > RequestData | 1367 | SCP.SCP0049_SAVE_MAIL_SEND_REQUEST | MATCH | SP SCP0049_SAVE_MAIL_SEND_REQUEST |
| event:this.formDown.Click | btnExcelFormDownload_Click > FindData_Excel_DownLoad > InitSpread > SetSpreadInit > GetSpdTitle | 1419 | SCP.SCP0049_GET_SHEET_CALENDAR | MATCH | SP SCP0049_GET_SHEET_CALENDAR |
| event:this.formDown.Click | btnExcelFormDownload_Click > FindData_Excel_DownLoad > InitSpread > GetUserTitle | 1438 | SCP.SCP0049_GET_SHEET_USER_TITLE | MATCH | SP SCP0049_GET_SHEET_USER_TITLE |
| event:this.formDown.Click | btnExcelFormDownload_Click > FindData_Excel_DownLoad | 2745 | SCP.SCP0049_GET_CAPA | MATCH | SP SCP0049_GET_CAPA |
| event:this.Load | Form_Load > InitControls | 383 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_line_by_operation] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 383 | FP\Capa\CAPA_PIC#get_line_by_operation | MATCH | [sql] foxquery_sql\FP_Capa_CAPA_PIC_get_line_by_operation.sql |
| event:this.Load | Form_Load > InitControls | 389 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_instance_authority] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 389 | FP\Capa\CAPA_PIC#get_instance_authority | MATCH | [sql] foxquery_sql\FP_Capa_CAPA_PIC_get_instance_authority.sql |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 423 | biz:CommonData.CommonDataList [code=OperationByLine] | BIZ_MATCH |  |
| event:this.Load | Form_Load > CreateSpread > InitSpread > SetSpreadInit > GetSpdTitle | 1419 | SCP.SCP0049_GET_SHEET_CALENDAR | MATCH | SP SCP0049_GET_SHEET_CALENDAR |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetUserTitle | 1438 | SCP.SCP0049_GET_SHEET_USER_TITLE | MATCH | SP SCP0049_GET_SHEET_USER_TITLE |
| event:this.Load | Form_Load > InitControls > GetDayRange | 1516 | SCP.SCP0049_GET_DAY_RANGE | MATCH | SP SCP0049_GET_DAY_RANGE |
| event:txtMaterialId.KeyDown | TxtMaterialId_KeyDown > FindButton > FindData_Main | 877 | SCP.SCP0201_GET_CAPA | MATCH | SP SCP0049_GET_CAPA_chool |
| event:txtMaterialId.KeyDown | TxtMaterialId_KeyDown > FindButton > FindData_Main > InitSpread > SetSpreadInit > GetSpdTitle | 1419 | SCP.SCP0049_GET_SHEET_CALENDAR | MATCH | SP SCP0049_GET_SHEET_CALENDAR |
| event:txtMaterialId.KeyDown | TxtMaterialId_KeyDown > FindButton > FindData_Main > InitSpread > GetUserTitle | 1438 | SCP.SCP0049_GET_SHEET_USER_TITLE | MATCH | SP SCP0049_GET_SHEET_USER_TITLE |
| event:txtModelId.KeyDown | TxtModelId_KeyDown > FindButton > FindData_Main | 877 | SCP.SCP0201_GET_CAPA | MATCH | SP SCP0049_GET_CAPA_chool |
| event:txtModelId.KeyDown | TxtModelId_KeyDown > FindButton > FindData_Main > InitSpread > SetSpreadInit > GetSpdTitle | 1419 | SCP.SCP0049_GET_SHEET_CALENDAR | MATCH | SP SCP0049_GET_SHEET_CALENDAR |
| event:txtModelId.KeyDown | TxtModelId_KeyDown > FindButton > FindData_Main > InitSpread > GetUserTitle | 1438 | SCP.SCP0049_GET_SHEET_USER_TITLE | MATCH | SP SCP0049_GET_SHEET_USER_TITLE |
| event:txtNickName.KeyDown | TxtNickName_KeyDown > FindButton > FindData_Main | 877 | SCP.SCP0201_GET_CAPA | MATCH | SP SCP0049_GET_CAPA_chool |
| event:txtNickName.KeyDown | TxtNickName_KeyDown > FindButton > FindData_Main > InitSpread > SetSpreadInit > GetSpdTitle | 1419 | SCP.SCP0049_GET_SHEET_CALENDAR | MATCH | SP SCP0049_GET_SHEET_CALENDAR |
| event:txtNickName.KeyDown | TxtNickName_KeyDown > FindButton > FindData_Main > InitSpread > GetUserTitle | 1438 | SCP.SCP0049_GET_SHEET_USER_TITLE | MATCH | SP SCP0049_GET_SHEET_USER_TITLE |
| unreached:(진입점 미연결) | <field:dtMyDivision> | 54 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| {?definition_path}#dbo.SCP0049_SAVE_CAPA | UNRESOLVED | 1 |  |  |  |
| biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.SCP0049_SAVE_CAPA] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=OperationByLine] | BIZ_MATCH | 5 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_LINE_HIERARCHY_V_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_OPERATION_SN, UP_FX_GetCommonDataList:REF:STRING_SPLIT, UP_FX_GetCommonDataList_SCP_ALL:SELECT:SCM_LINE_HIERARCHY_CPS_V_SN, UP_FX_GetCommonDataList_SCP_ALL:SELECT:SCM_MST_OPERATION_SN |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_instance_authority] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=get_line_by_operation] | BIZ_MATCH | 1 |  |  |  |
| FP\Capa\CAPA_PIC#get_instance_authority | MATCH | 1 | [sql] foxquery_sql\FP_Capa_CAPA_PIC_get_instance_authority.sql | SELECT:TH_UIS_ROLE_INSTANCE, SELECT:WITH_ROLE_FACTORY |  |
| FP\Capa\CAPA_PIC#get_line_by_operation | MATCH | 1 | [sql] foxquery_sql\FP_Capa_CAPA_PIC_get_line_by_operation.sql | SELECT:SCM_LINE_M, SELECT:SCM_FACTORY_M, SELECT:FP_INSTANCE_FACTORY_M, REF:STRING_SPLIT |  |
| SCP.PR_SCM_SYS_LOG_BATCH | MATCH | 1 | SP PR_SCM_SYS_LOG_BATCH | EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0049_GET_CAPA | MATCH | 1 | SP SCP0049_GET_CAPA | EXEC:SCP0049_GET_CAPA, SELECT:SCM_SYS_CALENDAR_M, SELECT:SCM_MASTER_VERSION_INFO_H_SN, SELECT:SCM_SYS_LOOKUP_VALUE_SN, INSERT:#TMP_SCP0049_LOOKUP, CREATE:#TMP_SCP0049_STD_ITEM, CREATE:#TMP_SCP0049_STD, INSERT:#TMP_SCP0049_STD, SELECT:SCM_LINE_HIERARCHY_V_SN, REF:STRING_SPLIT, CREATE:#TMP_SCP0049_STD_ITEM_DATA, INSERT:#TMP_SCP0049_STD_ITEM_DATA, SELECT:#TMP_SCP0049_STD, SELECT:SCM_MST_ITEM_LINE_ASSIGN_SN, SELECT:XIF_ERP_ITEM_LINE_ASSIGN_S_SN, SELECT:SCM_ITEM_M_SN, DELETE:TD, SELECT:#TMP_SCP0049_STD_ITEM_DATA, SELECT:SCM_MST_ITEM_CLASS_M, INSERT:#TMP_SCP0049_STD_ITEM, CREATE:#TMP_SCP0049_STD_ITEM_TACT, INSERT:#TMP_SCP0049_STD_ITEM_TACT, SELECT:#TMP_SCP0049_STD_ITEM, CREATE:#TMP_SCP0049_STD_ITEM_YIELD, INSERT:#TMP_SCP0049_STD_ITEM_YIELD, CREATE:#TMP_SCP0049_AVG_DATA, CREATE:#TMP_SCP0049_AVG, CREATE:#TMP_SCP0049_AVG_MIN_MAX, CREATE:#TMP_SCP0049_DMY, CREATE:#TMP_SCP0049_ADD_STD, CREATE:#TMP_SCP0049_LTY, CREATE:#TMP_SCP0049_LTY_RESULT, CREATE:#TMP_SCP0049_ALL, INSERT:#TMP_SCP0049_AVG_DATA, SELECT:#TMP_SCP0049_LOOKUP, SELECT:SCM_WORK_CALENDAR_M_SN, SELECT:SCM_LOSS_M_SN, SELECT:HIST_SCM_WORK_CALENDAR_M_SN, SELECT:HIST_SCM_LOSS_M_SN, SELECT:HIST_SCM_ITEM_LINE_ASSIGN_M_SN, SELECT:SCM_MST_TACT_TIME_SN, SELECT:#TMP_SCP0049_STD_ITEM_TACT, SELECT:HIST_SCM_TACT_TIME_M_SN, SELECT:SCM_MST_YIELD_SN, SELECT:#TMP_SCP0049_STD_ITEM_YIELD, SELECT:HIST_SCM_YIELD_M_SN, INSERT:#TMP_SCP0049_AVG, SELECT:#TMP_SCP0049_AVG_DATA, INSERT:#TMP_SCP0049_AVG_MIN_MAX, INSERT:#TMP_SCP0049_DAILY, INSERT:#TMP_SCP0049_MM, INSERT:#TMP_SCP0049_YEAR, INSERT:#TMP_SCP0049_LTY, SELECT:SCM_MST_ITEM_LINE_ASSIGN_EXCEPT_SN, SELECT:SCM_MST_TACT_TIME_EXCEPT_SN, SELECT:SCM_MST_YIELD_EXCEPT_SN, INSERT:#TMP_SCP0049_DMY, SELECT:#TMP_SCP0049_DAILY, SELECT:#TMP_SCP0049_MM, SELECT:#TMP_SCP0049_YEAR |  |
| SCP.SCP0049_GET_DAY_RANGE | MATCH | 1 | SP SCP0049_GET_DAY_RANGE | EXEC:SCP0049_GET_DAY_RANGE, SELECT:TB_FX_USER, SELECT:SCM_SYS_CALENDAR_M, REF:FN_MULTY_TIME, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| SCP.SCP0049_GET_SHEET_CALENDAR | MATCH | 1 | SP SCP0049_GET_SHEET_CALENDAR | EXEC:SCP0049_GET_SHEET_CALENDAR, SELECT:SCM_SYS_CALENDAR_M |  |
| SCP.SCP0049_GET_SHEET_USER_TITLE | MATCH | 1 | SP SCP0049_GET_SHEET_USER_TITLE | EXEC:SCP0049_GET_SHEET_USER_TITLE, SELECT:SCM_MST_TITLESET_USER, SELECT:SCM_MST_SHEET_COLUMNS |  |
| SCP.SCP0049_SAVE_MAIL_SEND_REQUEST | MATCH | 1 | SP SCP0049_SAVE_MAIL_SEND_REQUEST | EXEC:SCP0049_SAVE_MAIL_SEND_REQUEST, EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:SCM_CAPA_MAIL_SEND_H_SN, REF:UF_FX_STRING_SPLIT, SELECT:SCM_MASTER_MANAGER_M_SN, SELECT:SCM_CAPA_MAIL_SEND_H_SN, UPDATE:SCM_CAPA_MAIL_SEND_H_SN, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0201_GET_CAPA | MATCH | 1 | SP SCP0049_GET_CAPA_chool | EXEC:SCP0049_GET_CAPA_CHOOL | ⚠ DB에 SP 없음 |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| <field:dtMyDivision> | UserInfoContext.Current | NowGroupID |
| CAPA_Export_Excel | dr | CODE, NAME |
| CboVersionId_Click | drCurrentRow | CODE, NAME |
| EditButton | UserInfoContext.Current | NowGroupID |
| FindData_Excel_DownLoad | UserInfoContext.Current | NowGroupID |
| FindData_Main | UserInfoContext.Current | NowGroupID |
| InitControls | dataRow | CODE, NAME, SORT_ORDER |
| InitControls | dr | CODE, NAME |
| InitControls | drCurrentRow | CODE, NAME |
| InitControls | dt.Rows[0] | TO_VALUE, FROM_VALUE |
| InitControls | drBucketMonthRow | CODE, NAME |
| InitControls | drBucketDayRow | CODE, NAME |
| InitControls | UserInfoContext.Current | NowGroupID |
| InitControls | Filter | USER_ID, DIVISION_ID, SITE_ID, OPERATION_ID, PLANT_ID, FACTORY_ID |
| RequestData | ds.Tables[0].Rows[0] | result_code |
| SaveData_Main | dRow | p_division_id, p_company_id, p_site_id, p_plant_id, p_factory_id, p_line_id, p_operation_id, p_electrode_type, p_item_id, p_loss_code, p_data_table, p_data_type, p_day_name, p_day_qty, p_lane_qty, p_confirm_flag, p_update_id |
| SaveData_Main | result.Rows[0] | result_code, result_cnt, err_message |
| Set_CalculatorBestWorst | a | value |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | SetChangedControl:403, SetChangedControl:407, SetChangedControl:411, SetChangedControl:416, SetChangedControl:421, FindData_Main:820, FindData_Main:852, FindData_Main:853 | CString.GetCheckedListValue | CODE |
| GetSpdTitle | SetSpreadInit:472 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SetSheetHeaderColumn | SetSpreadInit:475, SetSpreadInit:479 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| InitSpreadDateColumn | SetSpreadInit:482 | SpreadInfo.InitSpreadDateColumn | COLUMN_LABEL_NAME, COLUMN_NAME, DAY_CODE, LARGE_CLASS_LABEL_NAME, SMALL_CLASS_LABEL_NAME |
| LoadData | BtnNewModel_Click:2502, BtnNewVersion_Click:2521, BtnVersionInfo_Click:2539 | UsrCheckedListBox.LoadData | APPLFACTORY, APPLSITE, CODE, FACTORY, NAME, OPERGROUP, PANELFACTORY, PANELSITE, RESOURCE, SCHGROUP, SHIFTTYPE, SITE, ShiftType |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:247 |
| cboDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:490 |
| cboGroup | SelectedIndexChanged | CboGroup_SelectedIndexChanged | InitEvent:491 |
| clbPlant | SelectedIndexChanged | ClbPlant_SelectedIndexChanged | InitEvent:492 |
| clbBuilding | SelectedIndexChanged | ClbBuilding_SelectedIndexChanged | InitEvent:493 |
| clbLine | SelectedIndexChanged | ClbLine_SelectedIndexChanged | InitEvent:494 |
| cboVersionId | SelectedIndexChanged | CboVersionId_SelectedIndexChanged | InitEvent:495 |
| cboVersionId | Click | CboVersionId_Click | InitEvent:496 |
| clbBucket | SelectedIndexChanged | ClbBucket_SelectedIndexChanged | InitEvent:498 |
| checkRESULT | CheckedChanged | CheckRESULT_CheckedChanged | InitEvent:499 |
| this.spdMain | ClipboardPasted | SpdMain_ClipboardPasted | InitEvent:501 |
| this.spdMain | CellClick | SpdMain_CellClick | InitEvent:502 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitEvent:503 |
| dsdm | Changed | shtMain_Changed | InitEvent:506 |
| this.buttonNewModel | Click | BtnNewModel_Click | InitEvent:508 |
| this.buttonNewVersion | Click | BtnNewVersion_Click | InitEvent:509 |
| this.buttonVersionInfo | Click | BtnVersionInfo_Click | InitEvent:510 |
| this.btnColumn | Click | BtnColumn_Click | InitEvent:511 |
| this.btnRequest | Click | BtnRequest_Click | InitEvent:512 |
| txtModelId | KeyDown | TxtModelId_KeyDown | InitEvent:514 |
| txtMaterialId | KeyDown | TxtMaterialId_KeyDown | InitEvent:515 |
| txtNickName | KeyDown | TxtNickName_KeyDown | InitEvent:516 |
| this.formDown | Click | btnExcelFormDownload_Click | InitializeComponent:665 |
| this.btnExcelUpload | Click | btnExcelUpload_Click | InitializeComponent:707 |

## 6. 컨트롤 (96개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 31 | layoutDivision, layoutModel, layoutMaterial, layoutNickName, layoutVersionId, layoutBtnColumn, layoutPeriodMonth, layoutControlItem1, layoutControlItem2, layoutControlItem3, layoutTotal, layoutSmall, layoutAuto, layoutElec, layoutPIC … |
| EmptySpaceItem | 21 | emptySpaceItem3, emptySpaceItem8, emptySpaceItem9, emptySpaceItem2, emptySpaceItem7, emptySpaceItem10, emptySpaceItem11, emptySpaceItem15, emptySpaceItem12, emptySpaceItem1, emptySpaceItem13, emptySpaceItem14, emptySpaceItem16, emptySpaceItem17, emptySpaceItem18 … |
| UsrButton | 7 | btnRequest, formDown, btnExcelUpload, btnColumn, buttonVersionInfo, buttonNewModel, buttonNewVersion |
| UsrCheckBox | 6 | checkEmpty, checkRESULT, checkYield, checkTactTime, checkLineAssign, checkLoss |
| UsrCheckedList2 | 5 | clbBucket, clbOperation, clbLine, clbBuilding, clbPlant |
| UsrTextBox | 5 | txtPIC, txtElec, txtAuto, txtSmall, txtTotal |
| UsrCombo | 3 | cboGroup, cboVersionId, cboDivision |
| UsrMultiLineEditor | 3 | txtNickName, txtMaterialId, txtModelId |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrTriStateTreeView | 2 | tvTri, triLeft |
| FpSpread | 2 | spdMain, spdExcel |
| SheetView | 2 | spdMain_Sheet1, spdExcel_Sheet1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrMonthRangePicker | 1 | drpPeriodMonth |
| ImageList | 1 | imageList1 |
| SplitContainer | 1 | dataPanel |
| TreeView | 1 | tvMain |

## 7. 확인 필요 (1건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 1241 | SaveData_Main | {?definition_path}#dbo.SCP0049_SAVE_CAPA | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 · pattern no match |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 51 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_GroupMenuAuth | 4 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0201 | CAPA | 34/0 | 34/0 | 34/0 | 34/0 | 34/0 | 34/0 | 34/0 | 34/0 | 34/0 | 34/0 | 34/0 | 34/0 | 34/0 | 34/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + DB루프(코드) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: CAPA, CAPA EXCEL
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@SetSpreadInit:475, SetSheetHeaderColumn@SetSpreadInit:479
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): SetSpreadColumnTitle, SetSpreadColumn, SetSpreadColumnRESULT, InitSpreadDateColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpreadDateColumn |  | 1461 | DB루프 | AddNumColumnEx | {?dr[DefColumnsTitle.COLUMN_LABEL_NAME]} | {?dr[DefColumnsTitle.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(spdInfo.SheetName == "CAPA") |
| InitSpreadDateColumn |  | 1467 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?dr["DAY_CODE"].ToString() == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ if(spdInfo.SheetName == "CAPA") ⟫ if(dr["DAY_CODE"].ToString() == "SAT"\|\| dr["DAY_CODE"].ToString() == "SUN") |
| InitSpreadDateColumn |  | 1473 | DB루프 | AddNumColumnEx | {?sColumnName.Replace("D_", "").Replace("M_", "")} | {?dr[DefColumnsTitle.COLUMN_NAME]} | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(spdInfo.SheetName == "CAPA") ⟫ if(spdInfo.SheetName == "CAPA EXCEL") |
| InitSpreadDateColumn |  | 1479 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?dr["DAY_CODE"].ToString() == "SAT"? Color.Blue : Color.Red} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(spdInfo.SheetName == "CAPA") ⟫ if(spdInfo.SheetName == "CAPA EXCEL") ⟫ if(dr["DAY_CODE"].ToString() == "SAT"\|\| dr["DAY_CODE"].ToString() == "SUN") |
| InitSpreadDateColumn |  | 1483 | 표시/라벨 변경 | set:BackColor | BackColor = {?Color.LightGreen} |  | foreach(dr in dsSpdTitle.Tables[0].Rows) ⟫ else!(spdInfo.SheetName == "CAPA") ⟫ if(spdInfo.SheetName == "CAPA EXCEL") ⟫ else!(dr["DAY_CODE"].ToString() == "SAT"\|\| dr["DAY_CODE"].ToString() == "SUN") ⟫ if(dr["DAY_CODE"].ToString() == "") |
| InitSpreadRequestColumn |  | 1503 | 하드코딩 | AddCheckColumn | Mail REQ | REQUEST_CHK | if(spdInfo.SheetName == "CAPA") |
| InitSpreadRequestColumn |  | 1505 | 표시/라벨 변경 | set:CellType | CellType = {?chk} | REQUEST_CHK | if(spdInfo.SheetName == "CAPA") |
| InitSpreadRequestColumn |  | 1506 | 표시/라벨 변경 | set:Value | Value = {?false} | REQUEST_CHK | if(spdInfo.SheetName == "CAPA") |
| InitSpreadRequestColumn |  | 1507 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | REQUEST_CHK | if(spdInfo.SheetName == "CAPA") |
| InitSpreadRequestColumn |  | 1508 | 표시/라벨 변경 | set:Text | Text = Mail REQ | REQUEST_CHK | if(spdInfo.SheetName == "CAPA") |
| SetSpreadColumnRESULT |  | 1892 | 표시/라벨 변경 | set:Visible | Visible = {?bVisible} |  | for(i<= 5) |
| SetSpreadColumnRESULT |  | 1893 | 표시/라벨 변경 | set:Visible | Visible = {?bVisibleResult} |  | for(i<= 5) |
| SetSpreadColumnRESULT |  | 1896 | 표시/라벨 변경 | set:Visible | Visible = {?!checkRESULT.Checked} |  |  |
| SetSpreadColumnRESULT |  | 1897 | 표시/라벨 변경 | set:Visible | Visible = {?!checkRESULT.Checked} |  |  |
| SetSpreadColumnRESULT |  | 1898 | 표시/라벨 변경 | set:Visible | Visible = {?checkRESULT.Checked} |  |  |
| SetSpreadColumnRESULT |  | 1899 | 표시/라벨 변경 | set:Visible | Visible = {?checkRESULT.Checked} |  |  |
| SetSpreadColumnTitle |  | 1912 | 표시/라벨 변경 | SetColumnHeader | 0 | BEF_M6 |  |
| SetSpreadColumnTitle |  | 1913 | 표시/라벨 변경 | SetColumnHeader | 0 | BEF_M5 |  |
| SetSpreadColumnTitle |  | 1914 | 표시/라벨 변경 | SetColumnHeader | 0 | BEF_M4 |  |
| SetSpreadColumnTitle |  | 1915 | 표시/라벨 변경 | SetColumnHeader | 0 | BEF_M3 |  |
| SetSpreadColumnTitle |  | 1916 | 표시/라벨 변경 | SetColumnHeader | 0 | BEF_M2 |  |
| SetSpreadColumnTitle |  | 1917 | 표시/라벨 변경 | SetColumnHeader | 0 | BEF_M1 |  |
| SetSpreadColumnTitle |  | 1919 | 표시/라벨 변경 | SetColumnHeader | 0 | BEF_M6_RESULT |  |
| SetSpreadColumnTitle |  | 1920 | 표시/라벨 변경 | SetColumnHeader | 0 | BEF_M5_RESULT |  |
| SetSpreadColumnTitle |  | 1921 | 표시/라벨 변경 | SetColumnHeader | 0 | BEF_M4_RESULT |  |
| SetSpreadColumnTitle |  | 1922 | 표시/라벨 변경 | SetColumnHeader | 0 | BEF_M3_RESULT |  |
| SetSpreadColumnTitle |  | 1923 | 표시/라벨 변경 | SetColumnHeader | 0 | BEF_M2_RESULT |  |
| SetSpreadColumnTitle |  | 1924 | 표시/라벨 변경 | SetColumnHeader | 0 | BEF_M1_RESULT |  |
| SetSpreadColumn |  | 1941 | 표시/라벨 변경 | set:Visible | Visible = {?true} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Y_") == 0) |
| SetSpreadColumn |  | 1944 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  | for(iCol <= siMain.GetMaxColumnIndex()) ⟫ else!(siMain.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| siMain.GetColumnTag(iCol).IndexOf("Y_") == 0) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| CAPA_Export_Excel |  | 2136 | 표시/라벨 변경 | set:Formula | Formula =  |  | for(iSheetIndex < spSpread.Sheets.Count) ⟫ for(i >= 0) ⟫ else!(newSheet.Columns[i].Visible == false) ⟫ if(newSheet.Columns[i].CellType != null) ⟫ else!(newSheet.Columns[i].CellType.GetType().FullName == "FarPoint.Win.Spread.CellType.ComboBoxCellType") ⟫ else!(newSheet.Columns[i].CellType.GetType().FullName == "FarPoint.Win.Spread.CellType.MultiColumnComboBoxCellType") ⟫ if(newSheet.Columns[i].Formula != string.Empty) |
| CAPA_Export_Excel |  | 2253 | 표시/라벨 변경 | set:DefaultStyle | DefaultStyle = {?siNewColHeader} |  |  |
| spdMain_CellDoubleClick |  | 2459 | 표시/라벨 변경 | set:Visible | Visible = {?!siMain.ActiveSheet.Columns[iCol].Visible} |  | if(e.ColumnHeader) ⟫ if(siMain.GetColumnTag(e.Column).IndexOf("M_") == 0) ⟫ for(iCol <= siMain.GetMaxColumnIndex()) ⟫ if(siMain.GetColumnTag(iCol).IndexOf("D_") == 0) |
| InitializeComponent |  | 2112 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 2113 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 2114 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 2115 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| CAPA | META+코드연결 | 35 | 35 | 35 | 35 | 35 | 35 | 35 | 35 | 35 | 35 | 35 | 35 | 35 | 35 |
| CAPA EXCEL | 코드 하드코딩 전용(메타 없음) | · | · | · | · | · | · | · | · | · | · | · | · | · | · |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
