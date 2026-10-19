# SCP0123 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0123_PlanControl\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0123_PlanControl\SCP0123_PlanControl.csproj | 37 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0123_PlanControl\Properties\Resources.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0123_PlanControl\SCP0123_PlanControl.csproj | 72 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0123_PlanControl\Properties\Settings.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0123_PlanControl\SCP0123_PlanControl.csproj | 31 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0123_PlanControl\SCP0123_PlanControl.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0123_PlanControl\SCP0123_PlanControl.csproj | 1328 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0123_PlanControl\SCP0123_PlanControl.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0123_PlanControl\SCP0123_PlanControl.csproj | 477 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0123_PlanControl\SCP0123_PlanIDCreatePopup.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0123_PlanControl\SCP0123_PlanControl.csproj | 608 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0123_PlanControl\SCP0123_PlanIDCreatePopup.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0123_PlanControl\SCP0123_PlanControl.csproj | 1732 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData_Main > GetDataSet_Main | 488 | SCP.SCP0123_GET_PLAN_CONTROL | MATCH | SP SCP0123_GET_PLAN_CONTROL |
| event:this.btnCreatePlan.Click | BtnCreatePlan_Click > SaveData | 533 | SCP.SCP0123_SAVE_PLAN_ID_CREATE | MATCH | SP SCP0123_SAVE_PLAN_ID_CREATE |
| event:this.Load | Form_Load > InitControls | 116 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetInitInfo | 276 | SCP.SCP0123_GET_PLAN_ID_CREATE_INFO | MATCH | SP SCP0123_GET_PLAN_ID_CREATE_INFO |
| event:this.spdMain.CellClick | SpdMain_CellClick > GetDataSet_Main | 488 | SCP.SCP0123_GET_PLAN_CONTROL | MATCH | SP SCP0123_GET_PLAN_CONTROL |
| event:this.spdMain.CellClick | SpdMain_CellClick > FindData_Sub | 557 | SCP.SCP0123_GET_PLAN_ENGINE_RUN | MATCH | SP SCP0123_GET_PLAN_ENGINE_RUN |
| event:this.spdMain.CellClick | SpdMain_CellClick > SaveData | 733 | SCP.SCP0123_SAVE_PLAN_CTRL_ACTV_RUN | MATCH | SP SCP0123_SAVE_PLAN_CTRL_ACTV_RUN |
| event:this.spdMain.CellClick | SpdMain_CellClick > GoPage | 816 | MenuContainer.UP_FX_GetGSCMAuthenticationMenuList | MATCH | SP UP_FX_GetGSCMAuthenticationMenuList |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Sub > GetDataSet_Main | 488 | SCP.SCP0123_GET_PLAN_CONTROL | MATCH | SP SCP0123_GET_PLAN_CONTROL |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Sub | 557 | SCP.SCP0123_GET_PLAN_ENGINE_RUN | MATCH | SP SCP0123_GET_PLAN_ENGINE_RUN |
| event:this.spdMain.ComboSelChange | SpdMain_ComboSelChange > GetDataSet_Main | 488 | SCP.SCP0123_GET_PLAN_CONTROL | MATCH | SP SCP0123_GET_PLAN_CONTROL |
| event:timerStatus.Tick | CheckEngineStatus > FindData_Sub > GetDataSet_Main | 488 | SCP.SCP0123_GET_PLAN_CONTROL | MATCH | SP SCP0123_GET_PLAN_CONTROL |
| event:timerStatus.Tick | CheckEngineStatus > FindData_Sub | 557 | SCP.SCP0123_GET_PLAN_ENGINE_RUN | MATCH | SP SCP0123_GET_PLAN_ENGINE_RUN |
| unreached:(진입점 미연결) | <field:dtSysProdCd> | 44 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtSysShipCd> | 45 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtDivision_GM> | 59 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetPlanGroupByUserID | 338 | SCP.SCP0121_GET_SEARCH_INFO | MATCH | SP SCP0121_GET_SEARCH_INFO |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 4 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| MenuContainer.UP_FX_GetGSCMAuthenticationMenuList | MATCH | 1 | SP UP_FX_GetGSCMAuthenticationMenuList | EXEC:UP_FX_GETGSCMAUTHENTICATIONMENULIST, SELECT:TB_FX_MENUITEMINFO, SELECT:TB_FX_USER, SELECT:TB_FX_USERGROUPINFO, SELECT:TB_FX_GROUPMENUAUTH, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:TB_FX_USERGROUPAUTHEXTENTION, SELECT:MENUCTE1, SELECT:TB_FX_PROGRAMINFO |  |
| SCP.SCP0121_GET_SEARCH_INFO | MATCH | 1 | SP SCP0121_GET_SEARCH_INFO | EXEC:SCP0121_GET_SEARCH_INFO, INSERT:#DIVISION_INFO, SELECT:SCM_MST_DIVISION, INSERT:#LINE_MASTER, SELECT:SCM_MST_LINE_SN, SELECT:SCM_MST_FACTORY_SN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, INSERT:#OSP_PLANT_INFO, SELECT:SCM_MST_LINE_OSP, SELECT:SCM_MST_SITE, SELECT:SCM_MST_VENDOR, SELECT:#LINE_MASTER, SELECT:#DIVISION_INFO, SELECT:SCP_MST_CAPA_LINE, SELECT:#OSP_PLANT_INFO, SELECT:SCP_OPMZ_PLAN_GR_M, SELECT:SCM_ADM_LOOKUP_MASTER, SELECT:SCM_OPERATION_M_SN |  |
| SCP.SCP0123_GET_PLAN_CONTROL | MATCH | 1 | SP SCP0123_GET_PLAN_CONTROL | EXEC:SCP0123_GET_PLAN_CONTROL, INSERT:#TEMP_PLAN_CONTROL, SELECT:SCP_OPMZ_PLAN_CTRL_ACTV_M, SELECT:SCP_OPMZ_PLAN_GR_M, SELECT:OPMZ_PROCESS, SELECT:OPMZ_ACTIVITY, SELECT:SCP_OPMZ_PLAN_CTRL_ACTV_RUN_M, SELECT:OPMZ_ACTIVITY_RUN_STATUS, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:#TEMP_PLAN_CONTROL |  |
| SCP.SCP0123_GET_PLAN_ENGINE_RUN | MATCH | 1 | SP SCP0123_GET_PLAN_ENGINE_RUN | EXEC:SCP0123_GET_PLAN_ENGINE_RUN, SELECT:SCP_OPMZ_PLAN_CTRL_ACTV_RUN_M, SELECT:SCP_OPMZ_PLAN_GR_M, SELECT:SCP_OPMZ_LOOKUP_MASTER_DETAIL, SELECT:SCP_OPT_ENG_ENGINE_RUN_STATUS_DETAIL_SN |  |
| SCP.SCP0123_GET_PLAN_ID_CREATE_INFO | MATCH | 1 | SP SCP0123_GET_PLAN_ID_CREATE_INFO | EXEC:SCP0123_GET_PLAN_ID_CREATE_INFO, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_PLAN, SELECT:DM_PLN_NET_DEMAND, SELECT:SCM_MST_SITE, SELECT:SCP_OPMZ_PLAN_GR_LINE_M, INSERT:#DIVISION_INFO, SELECT:SCM_MST_DIVISION, SELECT:SCM_DNM_FP_RELEASE_PROD_PLAN_C, SELECT:#DIVISION_INFO, SELECT:SCP_PLAN_VERSION_V, SELECT:SCP_OPMZ_PLAN_M, SELECT:SCM_ADM_LOOKUP_MASTER |  |
| SCP.SCP0123_SAVE_PLAN_CTRL_ACTV_RUN | MATCH | 1 | SP SCP0123_SAVE_PLAN_CTRL_ACTV_RUN | EXEC:SCP0123_SAVE_PLAN_CTRL_ACTV_RUN, EXEC:PR_SCM_SYS_LOG_BATCH, EXEC:PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL, EXEC:PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_SMALL, EXEC:PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_EE, EXEC:PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_ESS, EXEC:PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_GM_A, EXEC:PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_GM_EE, EXEC:PR_SCP_OPT_ENG_OUTPUT_FP_PROD_TARGET, EXEC:PR_SCP_OPT_ENG_INPUT_SHIPMENT_SNAPSHOT, SELECT:SCP_OPMZ_PLAN_CTRL_ACTV_RUN_M, UPDATE:SCP_OPMZ_PLAN_CTRL_ACTV_RUN_M, INSERT:SCP_OPMZ_PLAN_CTRL_ACTV_RUN_M, UPDATE:SCP_OPMZ_PLAN_CTRL_ACTV_M, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCM_SYS_CALENDAR_M, SELECT:SCP_OPMZ_PLAN_M, SELECT:SCP_OPT_ENG_SCP_PLAN_ID_M_SN, SELECT:SCP_PLAN_VERSION_V, SELECT:SCP_OPT_ENG_PHASES_SN, UPDATE:SCP_OPT_ENG_OUT_ORDER_PRODUCTION_SN, UPDATE:SCP_OPT_ENG_OUT_ORDER_PRODUCTION_INT_SN, UPDATE:SCP_OPT_ENG_OUT_ORDER_SHIPPING_INT_SN, UPDATE:SCP_OPT_ENG_OUT_ORDER_SHIPPING_SN, SELECT:SCP_OPT_ENG_OUT_ORDER_PRODUCTION_SN, SELECT:SCP_OPT_ENG_OUT_DEMAND_ASSIGN_PEGGING_SN, SELECT:SCP_OPT_ENG_RESOURCE_SN, SELECT:SCP_MST_FINAL_ITEM, SELECT:SCP_OPT_ENG_OUT_ORDER_PRODUCTION_INT_SN, SELECT:SCP_OPT_ENG_OUT_DEMAND_ASSIGN_PEGGING_INT_SN, UPDATE:SCP_ANL_PRODUCTION_PLAN, SELECT:SCP_ANL_PRODUCTION_PLAN, SELECT:SCP_OPT_ENG_MODEL_LIST_N_SN, MERGE:SCP_ANL_PRODUCTION_PLAN, INSERT:SCP_ANL_PRODUCTION_PLAN_H, UPDATE:SCP_ANL_PRODUCTION_PLAN_FIX, SELECT:SCP_ANL_PRODUCTION_PLAN_FIX, INSERT:SCP_ANL_PRODUCTION_PLAN_FIX_H, SELECT:SCP_OPT_ENG_OUT_ORDER_SHIPPING_SN, SELECT:SCP_OPT_ENG_BOD_SN, SELECT:SCP_OPT_ENG_SCHEDULED_MOVE_SN, SELECT:SCP_OPT_ENG_OUT_ORDER_SHIPPING_INT_SN, UPDATE:SCP_ANL_SHIPMENT_PLAN_SEMI, SELECT:SCP_ANL_SHIPMENT_PLAN_SEMI, MERGE:SCP_ANL_SHIPMENT_PLAN_SEMI, INSERT:SCP_ANL_SHIPMENT_PLAN_SEMI_H, UPDATE:SCP_ANL_SHIPMENT_PLAN_FIX, SELECT:SCP_ANL_SHIPMENT_PLAN_FIX, UPDATE:SCP_ANL_SHIPMENT_PLAN_FG, SELECT:SCP_ANL_SHIPMENT_PLAN_FG, MERGE:SCP_ANL_SHIPMENT_PLAN_FG, INSERT:SCP_ANL_SHIPMENT_PLAN_FG_H, INSERT:SCP_ANL_SHIPMENT_PLAN_FIX_H, SELECT:SCP_MST_CELL_PROD_ASSY_MAP, UPDATE:SCP_XLS_PSI_GLOBAL, SELECT:SCP_XLS_PSI_GLOBAL, UPDATE:SCP_OPT_ENG_PLAN_MASTER_SN, UPDATE:SCP_OPT_ENG_OUT_ORDER_DEMAND_DELIVERY_SN, UPDATE:SCP_OPT_ENG_OUT_ORDER_DEMAND_DELIVERY_INT_SN, SELECT:SCP_OPT_ENG_OUT_ORDER_DEMAND_DELIVERY_SN |  |
| SCP.SCP0123_SAVE_PLAN_ID_CREATE | MATCH | 1 | SP SCP0123_SAVE_PLAN_ID_CREATE | EXEC:SCP0123_SAVE_PLAN_ID_CREATE, EXEC:PR_SCM_SYS_LOG_BATCH, REF:FN_ZERO_LPAD, SELECT:SCP_OPMZ_PLAN_M, INSERT:SCP_OPMZ_PLAN_M, EXEC:SCP0123_SAVE_PLAN_CTRL_ACTV_RUN, INSERT:SCM_SYS_LOG_BATCH, EXEC:PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL, EXEC:PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_SMALL, EXEC:PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_EE, EXEC:PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_ESS, EXEC:PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_GM_A, EXEC:PR_SCP_OPT_ENG_OUTPUT_TRANS_ANL_GM_EE, EXEC:PR_SCP_OPT_ENG_OUTPUT_FP_PROD_TARGET, EXEC:PR_SCP_OPT_ENG_INPUT_SHIPMENT_SNAPSHOT, SELECT:SCP_OPMZ_PLAN_CTRL_ACTV_RUN_M, UPDATE:SCP_OPMZ_PLAN_CTRL_ACTV_RUN_M, INSERT:SCP_OPMZ_PLAN_CTRL_ACTV_RUN_M, UPDATE:SCP_OPMZ_PLAN_CTRL_ACTV_M, SELECT:SCM_SYS_CALENDAR_M, SELECT:SCP_OPT_ENG_SCP_PLAN_ID_M_SN, SELECT:SCP_PLAN_VERSION_V, SELECT:SCP_OPT_ENG_PHASES_SN, UPDATE:SCP_OPT_ENG_OUT_ORDER_PRODUCTION_SN, UPDATE:SCP_OPT_ENG_OUT_ORDER_PRODUCTION_INT_SN, UPDATE:SCP_OPT_ENG_OUT_ORDER_SHIPPING_INT_SN, UPDATE:SCP_OPT_ENG_OUT_ORDER_SHIPPING_SN, SELECT:SCP_OPT_ENG_OUT_ORDER_PRODUCTION_SN, SELECT:SCP_OPT_ENG_OUT_DEMAND_ASSIGN_PEGGING_SN, SELECT:SCP_OPT_ENG_RESOURCE_SN, SELECT:SCP_MST_FINAL_ITEM, SELECT:SCP_OPT_ENG_OUT_ORDER_PRODUCTION_INT_SN, SELECT:SCP_OPT_ENG_OUT_DEMAND_ASSIGN_PEGGING_INT_SN, UPDATE:SCP_ANL_PRODUCTION_PLAN, SELECT:SCP_ANL_PRODUCTION_PLAN, SELECT:SCP_OPT_ENG_MODEL_LIST_N_SN, MERGE:SCP_ANL_PRODUCTION_PLAN, INSERT:SCP_ANL_PRODUCTION_PLAN_H, UPDATE:SCP_ANL_PRODUCTION_PLAN_FIX, SELECT:SCP_ANL_PRODUCTION_PLAN_FIX, INSERT:SCP_ANL_PRODUCTION_PLAN_FIX_H, SELECT:SCP_OPT_ENG_OUT_ORDER_SHIPPING_SN, SELECT:SCP_OPT_ENG_BOD_SN, SELECT:SCP_OPT_ENG_SCHEDULED_MOVE_SN, SELECT:SCP_OPT_ENG_OUT_ORDER_SHIPPING_INT_SN, UPDATE:SCP_ANL_SHIPMENT_PLAN_SEMI, SELECT:SCP_ANL_SHIPMENT_PLAN_SEMI, MERGE:SCP_ANL_SHIPMENT_PLAN_SEMI, INSERT:SCP_ANL_SHIPMENT_PLAN_SEMI_H, UPDATE:SCP_ANL_SHIPMENT_PLAN_FIX, SELECT:SCP_ANL_SHIPMENT_PLAN_FIX, UPDATE:SCP_ANL_SHIPMENT_PLAN_FG, SELECT:SCP_ANL_SHIPMENT_PLAN_FG, MERGE:SCP_ANL_SHIPMENT_PLAN_FG, INSERT:SCP_ANL_SHIPMENT_PLAN_FG_H, INSERT:SCP_ANL_SHIPMENT_PLAN_FIX_H, SELECT:SCP_MST_CELL_PROD_ASSY_MAP, UPDATE:SCP_XLS_PSI_GLOBAL, SELECT:SCP_XLS_PSI_GLOBAL, UPDATE:SCP_OPT_ENG_PLAN_MASTER_SN |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| GetPlanGroupByUserID | TheOne.Security.FoxUserInfoContext.Current | NowGroupID |
| InitControls | drRow1 | CODE, NAME |
| Set_PlanID_Info | this.dtPlanIDInfo.Rows[0] | PROD_REF_SYS_DIVS_CD, PROD_REF_SYS_PLAN_ID, PMDU_PROD_FRZ_END_YYYYMMDD, CELL_PROD_FRZ_END_YYYYMMDD, SHIP_REF_SYS_DIVS_CD, SHIP_REF_SYS_PLAN_ID, SHIP_FRZ_END_YYYYMMDD, OPMZ_PRAM_TP_CD, OPMZ_PLAN_DESC, PLAN_END_YYYYMMDD, PROD_NO_FROZEN_YN, CELL_NO_FROZEN_YN, SHIP_NO_FROZEN_YN |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | RefreshPlanGroupByDivision:211, RefreshPlanDate:220, RefreshPlanID:245, RefreshPlanID:246, RefreshPlanID:259, FindData_Main:379, FindData_Main:380, FindData_Main:393 | CString.GetCheckedListValue | CODE |
| SetSheetHeaderColumnSCP | InitSpread:305 | SpreadInfo.SetSheetHeaderColumnSCP | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| SetSheetHeaderColumn | InitSpread:313 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| SaveData | SpdMain_CellClick:1054, SpdMain_CellClick:1095, SpdMain_CellClick:1143, SpdMain_CellClick:1180, BtnCreatePlan_Click:430 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:134 |
| this.spdMain | CellClick | SpdMain_CellClick | InitEvent:151 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:152 |
| this.spdMain | ComboSelChange | SpdMain_ComboSelChange | InitEvent:153 |
| this.spdMain | KeyPress | SpdMain_KeyPress | InitEvent:154 |
| timerStatus | Tick | CheckEngineStatus | InitEvent:157 |
| cboDivision | SelectedIndexChanged | cboDivision_SelectedIndexChanged | InitControls:203 |
| cboPlanGroup | SelectedIndexChanged | CboPlanGroup_SelectedIndexChanged | InitControls:204 |
| cboPlanDate | SelectedIndexChanged | CboPlanDate_SelectedIndexChanged | InitControls:205 |
| dpPlanDate_Days | ValueChanged | DpPlanDate_Days_ValueChanged | InitControls:206 |
| this | Load | Form_Load | .ctor:70 |
| this | Load | Form_Load | .ctor:86 |
| this.btnClose | Click | BtnClose_Click | InitEvent:293 |
| this.btnCreatePlan | Click | BtnCreatePlan_Click | InitEvent:294 |
| this.cboProdCd | SelectedIndexChanged | CboProdCd_SelectedIndexChanged | InitEvent:296 |
| this.cboShipCd | SelectedIndexChanged | CboShipCd_SelectedIndexChanged | InitEvent:297 |
| this.chkProdNoFrozen | CheckedChanged | ChkProdNoFrozen_CheckedChanged | InitEvent:299 |
| this.chkCellNoFrozen | CheckedChanged | ChkCellNoFrozen_CheckedChanged | InitEvent:300 |
| this.chkShipNoFrozen | CheckedChanged | ChkShipNoFrozen_CheckedChanged | InitEvent:301 |

## 6. 컨트롤 (97개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 25 | lciPlanDate, layoutControlItem1, layoutControlItem5, lciPlanDate_Days, layoutControlItem1, layoutControlItem2, layoutControlItem3, layoutControlItem4, layoutControlItem5, layoutControlItem8, layoutControlItem9, lciProdStart, lciProdEnd, lciCellStart, lciCellEnd … |
| EmptySpaceItem | 13 | emptySpaceItem1, emptySpaceItem1, emptySpaceItem3, emptySpaceItem4, emptySpaceItem6, emptySpaceItem7, emptySpaceItem10, emptySpaceItem9, emptySpaceItem12, emptySpaceItem5, emptySpaceItem8, emptySpaceItem11, emptySpaceItem2 |
| UsrConditionPanel | 8 | usrConditionPanel1, usrConditionPanel1, usrConditionPanel2, usrConditionPanel3, usrConditionPanel4, usrConditionPanel5, usrConditionPanel6, usrConditionPanel7 |
| UsrLayoutControl | 8 | usrLayoutControl1, usrLayoutControl1, usrLayoutControl2, usrLayoutControl3, usrLayoutControl4, usrLayoutControl5, usrLayoutControl6, usrLayoutControl7 |
| LayoutControlGroup | 8 | layoutControlGroup1, layoutControlGroup1, layoutControlGroup2, layoutControlGroup3, layoutControlGroup4, layoutControlGroup5, layoutControlGroup6, layoutControlGroup7 |
| UsrCombo | 7 | cboPlanDate, cboDivision, cboProdCd, cboProdPlanID, cboShipPlanID, cboShipCd, cboParameter |
| UsrTextBox | 7 | txtFcstVersion, txtPlanGroup, txtHorizonStart, txtCellStart, txtProdStart, txtShipStart, txtDesc |
| UsrDatePicker | 5 | dpPlanDate_Days, dpCellEnd, dpProdEnd, dpShipEnd, dpHorizonEnd |
| SimpleLabelItem | 3 | simpleLabelItem1, simpleLabelItem2, simpleLabelItem3 |
| UsrCheckBox | 3 | chkCellNoFrozen, chkProdNoFrozen, chkShipNoFrozen |
| FpSpread | 2 | spdMain, spdSub |
| SheetView | 2 | spdMain_Sheet1, spdSub_Sheet1 |
| UsrButton | 2 | btnClose, btnCreatePlan |
| SplitContainer | 1 | splitContainer1 |
| UsrComboBox | 1 | cboPlanGroup |
| ImageList | 1 | imageList1 |
| Timer | 1 | timerStatus |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 123 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 29 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_GroupMenuAuth | 3 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 6 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0123 | Plan Control | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 | 22/0 |
| SCM_MST_SHEET_COLUMNS | SCP0123 | Status | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 | 7/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Plan Control, Status
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumnSCP@InitSpread:305, SetSheetHeaderColumn@InitSpread:313

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 120 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 121 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 122 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 123 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 384 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 385 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 386 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 387 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Plan Control | META+코드연결 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 | 22 |
| Status | META+코드연결 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
