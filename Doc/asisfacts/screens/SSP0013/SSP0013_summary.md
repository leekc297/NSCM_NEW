# SSP0013 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.SSP.Plan.UIL\SSP0013_ShipmentPlanAdjustment.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 3088 |
| only | 06.UIL\GSCM.SSP.Plan.UIL\SSP0013_ShipmentPlanAdjustment.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 1153 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData_Main | 742 | SSP.SSP0013_GET_SHIPMENT_PLAN_CHANGE | MATCH | SP SSP0013_GET_SHIPMENT_PLAN_CHANGE |
| button:SaveButton | SaveButton > SaveData > FindData_Main | 742 | SSP.SSP0013_GET_SHIPMENT_PLAN_CHANGE | MATCH | SP SSP0013_GET_SHIPMENT_PLAN_CHANGE |
| button:SaveButton | SaveButton > SaveData | 1020 | SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40 | MATCH | SP SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40 |
| button:SaveButton | SaveButton > SaveData | 1020 | SSP.SSP0013_SAVE_SHIPMENT_REQUEST_CONFIRM | MATCH | SP SSP0013_SAVE_SHIPMENT_REQUEST_CONFIRM |
| button:SaveButton | SaveButton > SaveData > GetERPInterface > NonSoNo | 1592 | SSP.SSP0013_SAVE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0013_SAVE_SHIPMENT_REQUEST_DRAFTING |
| button:SaveButton | SaveButton > SaveData > GetERPInterface > SoNo | 1795 | SSP.SSP0013_SAVE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0013_SAVE_SHIPMENT_REQUEST_DRAFTING |
| button:SaveButton | SaveButton > SaveData > GetERPInterface > GetErpSoNoCnt | 1883 | SSP.SSP0013_GET_ERP_SO_NO_CNT | MATCH | SP SSP0013_GET_ERP_SO_NO_CNT |
| button:SaveButton | SaveButton > SaveData > GetERPInterface > GetShipmentStatusChk | 1908 | SSP.SSP0013_GET_SHIPMENT_STATUS | MATCH | SP SSP0013_GET_SHIPMENT_STATUS |
| button:SaveButton | SaveButton > SaveData > GetERPInterface > SoNo > GetErpIFCheck | 1966 | SSP.SSP0013_DELETE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0013_DELETE_SHIPMENT_REQUEST_DRAFTING |
| button:SaveButton | SaveButton > SaveData > EngProcessingChk | 2075 | SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK | MATCH | SP SSP0003_GET_SSP_PLAN_PROCESSING_CHECK |
| event:spdMain.CellClick | SpdMain_CellClick | 2899 | biz:CommonData.CommonDataList [code=TransMode] | BIZ_MATCH |  |
| event:spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Sub | 833 | SSP.SSP0013_GET_STOCK_INFOMATION | MATCH | SP SSP0013_GET_STOCK_INFOMATION |
| event:spdMain.ClipboardPasted | SpdMain_ClipboardPasted | 2637 | biz:CommonData.CommonDataList [code=TransMode] | BIZ_MATCH |  |
| event:this.btnChecked.Click | BtnChecked_Click > SaveData_Check > FindData_Main | 742 | SSP.SSP0013_GET_SHIPMENT_PLAN_CHANGE | MATCH | SP SSP0013_GET_SHIPMENT_PLAN_CHANGE |
| event:this.btnChecked.Click | BtnChecked_Click > SaveData_Check | 1360 | SSP.SSP0013_SAVE_SHIPMENT_REQUEST_CONFIRM_CHECK | MATCH | SP SSP0013_SAVE_SHIPMENT_REQUEST_CONFIRM_CHECK |
| event:this.btnSearch.Click | BtnSearch_Click > FindData_Sub | 833 | SSP.SSP0013_GET_STOCK_INFOMATION | MATCH | SP SSP0013_GET_STOCK_INFOMATION |
| event:this.Load | Form_Load > InitControls | 358 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetDayRange | 2120 | SCP.GET_DATE_RANGE_1MONTH | MATCH | [statement] foxquery_sql\SCP.GET_DATE_RANGE_1MONTH.sql |
| unreached:(진입점 미연결) | <field:dtChangeReasonCode> | 52 | biz:CommonData.CommonDataList [code=CHANGE_REASON_CODE_ALL] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtChangeStatusCode> | 54 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtFcstType> | 55 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtBaseDay> | 57 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtChangeReqType> | 58 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 60 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtMyModelChk> | 61 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtStockStatus> | 64 | biz:CommonData.CommonDataList [code=LookupCommon3] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SetChangedPeriod | 2013 | biz:CommonData.CommonDataList [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=CHANGE_REASON_CODE_ALL] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:SELECT:TB_FX_USER |
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 5 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=LookupCommon3] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:SELECT:TB_FX_USER |
| biz:CommonData.CommonDataList [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=TransMode] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCP_MST_BOD_V |
| biz:CommonData.YesOrNo | BIZ_MATCH | 2 |  |  |  |
| SCP.GET_DATE_RANGE_1MONTH | MATCH | 1 | [statement] foxquery_sql\SCP.GET_DATE_RANGE_1MONTH.sql | SELECT:SCM_SYS_CALENDAR_M |  |
| SSP.SSP0003_GET_SSP_PLAN_PROCESSING_CHECK | MATCH | 1 | SP SSP0003_GET_SSP_PLAN_PROCESSING_CHECK | EXEC:SSP0003_GET_SSP_PLAN_PROCESSING_CHECK, SELECT:SCM_MST_PLAN, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_PLAN_DETAIL |  |
| SSP.SSP0013_DELETE_SHIPMENT_REQUEST_DRAFTING | MATCH | 1 | SP SSP0013_DELETE_SHIPMENT_REQUEST_DRAFTING | EXEC:SSP0013_DELETE_SHIPMENT_REQUEST_DRAFTING, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, UPDATE:SSP_ANL_SHIP_CONFIRM_CHG_REQ, UPDATE:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, INSERT:SCM_SYS_LOG_BATCH |  |
| SSP.SSP0013_GET_ERP_SO_NO_CNT | MATCH | 1 | SP SSP0013_GET_ERP_SO_NO_CNT | EXEC:SSP0013_GET_ERP_SO_NO_CNT, SELECT:SSP_ANL_SHIP_CONFIRM |  |
| SSP.SSP0013_GET_SHIPMENT_PLAN_CHANGE | MATCH | 1 | SP SSP0013_GET_SHIPMENT_PLAN_CHANGE | EXEC:SSP0013_GET_SHIPMENT_PLAN_CHANGE, REF:FN_GET_IN_STR, DYNAMIC@SSP0013_GET_SHIPMENT_PLAN_CHANGE, REF:FN_SCM_SPLIT |  |
| SSP.SSP0013_GET_SHIPMENT_STATUS | MATCH | 1 | SP SSP0013_GET_SHIPMENT_STATUS | EXEC:SSP0013_GET_SHIPMENT_STATUS, SELECT:SSP_ANL_SHIP_CONFIRM, REF:STRING_SPLIT |  |
| SSP.SSP0013_GET_STOCK_INFOMATION | MATCH | 1 | SP SSP0013_GET_STOCK_INFOMATION | EXEC:SSP0013_GET_STOCK_INFOMATION, REF:FN_GET_ITEM_NICKNAME, SELECT:SSP_DNM_OWMS_STOCK, SELECT:SCM_MST_SLOC, REF:STRING_SPLIT, SELECT:SSP_ANL_OWMS_STOCK, SELECT:SCM_MST_ITEM_SN |  |
| SSP.SSP0013_SAVE_SHIPMENT_REQUEST_CONFIRM | MATCH | 1 | SP SSP0013_SAVE_SHIPMENT_REQUEST_CONFIRM | EXEC:SSP0013_SAVE_SHIPMENT_REQUEST_CONFIRM, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SSP_ANL_SHIP_CONFIRM, UPDATE:SSP_ANL_SHIP_CONFIRM, SELECT:SSP_PLAN_VERSION_V, SELECT:SSP_ANL_SHIP_PLAN, DELETE:SSP_ANL_SHIP_PLAN, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, INSERT:SSP_ANL_SHIP_PLAN, EXEC:PR_SSP_ANL_SHIP_UPDATE_BOH_VAL, EXEC:PR_SSP_ANL_SHIP_CONFIRM_HIST, SELECT:SSP_MST_SEND_MAIL_REQ, INSERT:SSP_MST_SEND_MAIL_REQ, EXEC:PR_SSP_MAIL_SEND_ADJUST_MST, INSERT:SCM_SYS_LOG_BATCH, EXEC:PR_SCP_SYS_LOG_BATCH, CREATE:#TMP_SSP_ANL_SHIP_UPDATE_BOH, INSERT:#TMP_SSP_ANL_SHIP_UPDATE_BOH, UPDATE:SSP_ANL_SHIP_PLAN, SELECT:#TMP_SSP_ANL_SHIP_UPDATE_BOH, INSERT:SSP_ANL_SHIP_CONFIRM_H, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ, INSERT:#TBLSSPADJUSTMAILSEND, REF:FN_GET_ITEM_NICKNAME, REF:FN_GET_SCM_SITE_DESCRIPTION, REF:FN_GET_SSP_MKT_OWNER_NAME, REF:FN_GET_USER_NAME, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_SITE, SELECT:SSP_MST_MODEL_USER_EE, SELECT:#TBLSSPADJUSTMAILSEND, UPDATE:SSP_MST_SEND_MAIL_REQ, EXEC:PR_SSP_MAIL_SEND_ADJUST_SUB, EXEC:SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_MST_SSO_USER_INFO, EXEC:SP_SEND_DBMAIL, INSERT:SCM_ADM_SMS_MAIL_SEND_LOG |  |
| SSP.SSP0013_SAVE_SHIPMENT_REQUEST_CONFIRM_CHECK | MATCH | 1 | SP SSP0013_SAVE_SHIPMENT_REQUEST_CONFIRM_CHECK | EXEC:SSP0013_SAVE_SHIPMENT_REQUEST_CONFIRM_CHECK, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SSP_ANL_SHIP_CONFIRM, UPDATE:SSP_ANL_SHIP_CONFIRM, INSERT:SCM_SYS_LOG_BATCH |  |
| SSP.SSP0013_SAVE_SHIPMENT_REQUEST_DRAFTING | MATCH | 2 | SP SSP0013_SAVE_SHIPMENT_REQUEST_DRAFTING | EXEC:SSP0013_SAVE_SHIPMENT_REQUEST_DRAFTING, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, INSERT:SSP_ANL_SHIP_CONFIRM_CHG_REQ, INSERT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SELECT:SSP_ANL_SHIP_CONFIRM, EXEC:PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH, INSERT:SCM_SYS_LOG_BATCH, EXEC:PR_SCP_SYS_LOG_BATCH, INSERT:XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, REF:FN_GET_SSP_SITE_INFO, REF:FN_GET_SSP_SITE_INFO_EXCEPTION, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, REF:FN_GET_SSP_VMI_YN, REF:FN_GET_SSP_MKT_FCST_INCOTERMS, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_SITE, SELECT:NERP_CONV_MASTER, UPDATE:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:DM_PLN_MKT_FCST |  |
| SSP.SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40 | MATCH | 1 | SP SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40 | EXEC:SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40, EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:#TBLDYNAMIC_SSP0015_40_STD, SELECT:SSP_ANL_SHIP_PLAN_40, SELECT:SCM_MST_SITE, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SSP_ANL_SHIP_CONFIRM, SELECT:SCP_MST_BOD_N_V, SELECT:SCP_MST_BOD_ITEM, REF:FN_GET_SSP_ETA_DATE, UPDATE:SSP_ANL_SHIP_CONFIRM, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:FN_MULTY_TIME, SELECT:SSP_PLAN_VERSION_V, INSERT:SSP_ANL_SHIP_CONFIRM, SELECT:SSP_MST_SITE_ITEM_EE_V, INSERT:SSP_ANL_SHIP_CONFIRM_H, INSERT:XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:NERP_CONV_MASTER, EXEC:PR_DM_SSP_CONFIRM_SYNC, SELECT:TB_FX_USER, INSERT:SSP_ANL_SHIP_CONFIRM_CHG_REQ, INSERT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SELECT:#TBLDYNAMIC_SSP0015_40_STD, DELETE:SSP_ANL_SHIP_PLAN_40, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, INSERT:SSP_ANL_SHIP_PLAN_40, EXEC:PR_SSP_ANL_SHIP_CONFIRM_HIST, SELECT:SSP_MST_SEND_MAIL_REQ, INSERT:SSP_MST_SEND_MAIL_REQ, EXEC:PR_SSP_MAIL_SEND_ADJUST_MST, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCM_SYS_CALENDAR_M, REF:FN_WEEKOFDAY_DATE, EXEC:PR_SSP_ANL_SHIP_CONFIRM_ROUTE, REF:UF_FX_STRING_SPLIT, REF:FN_NEXT_DAY, CREATE:#T_CONFIRM_ID, CREATE:#T_SSP, CREATE:#T_SSP_SUM, CREATE:#T_MKT_RESULT, CREATE:#T_MKT_RESULT_SUM, CREATE:#TEMP_SALES_RESULT, INSERT:#T_CONFIRM_ID, DELETE:A, SELECT:DM_PLN_MKT_FCST_CONFIRM, SELECT:#T_CONFIRM_ID, INSERT:DM_PLN_MKT_FCST_CONFIRM, SELECT:SCP_MST_DISTRIBUTION_ROUTE, SELECT:DM_MST_ITEM_SINGLE_V, UPDATE:A, INSERT:#TEMP_SHIP_RESULT, SELECT:SCM_DNM_EXFACTORY_RESULT, SELECT:#TEMP_SHIP_RESULT, INSERT:#TEMP_SALES_RESULT, SELECT:DM_PLN_MKT_FCST_RESULT, REF:FN_SPLITSTRING, SELECT:#TEMP_SALES_RESULT |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| <field:dtMyDivision> | UserInfoContext.Current | NowGroupID |
| chkERPIFBlockYn | dtERPBlockYnIF.Rows[0] | BLOCK_YN, PERIOD |
| FindData_Sub | ds.Tables[2].Rows[0] | CREATION_DATE |
| GetErpSoNoCnt | ds.Tables[0].Rows[0] | CNT |
| GetShipmentStatusChk | ds.Tables[0].Rows[iRow] | CONFIRM_ID |
| GetShipmentStatusChk | ds.Tables[1].Rows[iRow] | CONFIRM_ID |
| InitControls | dataRow | CODE, NAME |
| InitControls | dr | CODE, NAME |
| InitControls | dtCompany.Rows[0] | COMPANY_ID |
| InitControls | c | CODE |
| InitControls | dtShipmentInputPeriod.Rows[0] | VALUE, Diff_VALUE |
| InitControls | dtShipmentInputPeriod.Rows[1] | VALUE, Diff_VALUE |
| SetChangedControl | UserInfoContext.Current | NowGroupID |
| SetChangedPeriod | dt.Rows[0] | FROM_VALUE, TO_VALUE |
| SpdMain_ClipboardPasted | c | CODE |
| SpdMain_ClipboardPasted | dr | ROUTE_ID, BOD_ID, INCOTERMS, D_COUNTRY, D_PORT_CODE, A_COUNTRY, A_PORT_CODE, TO_COUNTRY, TO_CITY, LT_TOTAL |
| SpdMain_ComboSelChange | c | CODE |
| SpdMain_ComboSelChange | dr | ROUTE_ID, BOD_ID, INCOTERMS, D_COUNTRY, D_PORT_CODE, A_COUNTRY, A_PORT_CODE, TO_COUNTRY, TO_CITY, LT_TOTAL |
| Validation_Check | row | confirm_id |
| Validation_Check | Validationdr | shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks |
| Validation_Check | SONoValidationdr | shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| DataBind | InitControls:358 | UsrComboBox.DataBind | CODE, NAME |
| GetCheckedListValue | SetChangedControl:403, FindData_Main:721, FindData_Main:722, FindData_Main:727, FindData_Main:728, FindData_Main:729 | CString.GetCheckedListValue | CODE |
| SetSheetHeaderColumn | InitSpread:454, InitSpread:478, InitSpread:490 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| SaveData | SaveButton:644 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:243 |
| cboDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:261 |
| spdMain | TopChange | SpdMain_TopChange | InitEvent:262 |
| spdMain | CellClick | SpdMain_CellClick | InitEvent:263 |
| spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:264 |
| spdMain | ComboSelChange | SpdMain_ComboSelChange | InitEvent:265 |
| spdMain | ClipboardPasted | SpdMain_ClipboardPasted | InitEvent:266 |
| spdMain | EditChange | SpdMain_EditChange | InitEvent:268 |
| this.btnItemId | Click | btnItemId_Click | InitEvent:271 |
| this.btnItemID2 | Click | BtnItemID2_Click | InitEvent:272 |
| this.btnSearch | Click | BtnSearch_Click | InitEvent:273 |
| this.btnChecked | Click | BtnChecked_Click | InitEvent:274 |
| dsdm | Changed | shtMain_Change | InitEvent:277 |

## 6. 컨트롤 (49개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 16 | layoutControlItem7, PlanType, layoutControlItem1, Model, layoutControlItem2, PlanType1, lblSONo, layoutControlItem3, Division, layoutControlItem10, layoutControlItem8, lcCheck, layoutControlItem4, layoutControlItem5, layoutControlItem6 … |
| EmptySpaceItem | 5 | emptySpaceItem6, emptySpaceItem4, emptySpaceItem7, emptySpaceItem2, emptySpaceItem3 |
| UsrMultiLineEditor | 3 | txtSoNo, txtRequest, txtModel2 |
| UsrCombo | 3 | cboStatus, cboChangeType, cboDivision |
| FpSpread | 2 | spdMain, spdSub |
| SheetView | 2 | spdMain_Sheet1, spdSub_Sheet1 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl3 |
| UsrCheckedList | 2 | clbFromSite, clbToSite |
| UsrButton | 2 | btnItemId, btnItemID2 |
| SimpleButton | 2 | btnChecked, btnSearch |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup3 |
| UsrDateRangePicker | 1 | drpPeriod |
| UsrComboBox | 1 | cboChecked |
| UsrCheckBox | 1 | chkMyModel |
| ImageList | 1 | imageList1 |
| Panel | 1 | StockPanel |
| TextBox | 1 | txtCreateDate |
| Splitter | 1 | splitter1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 27 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL | 1 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL_H | 4 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL_H.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 105 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 1 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 11 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 63 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (3건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 669 | SSP.PR_SSP_ADJUST_MAIL_SEND | commented:NOT_IN_FOXQUERY |
| 1022 | SSP.SSP0013_SAVE_SHIPMENT_REQUEST_CONFIRM | commented:MATCH |
| 2121 | SCP.SCM0001_GET_SCP_DAY_PERIOD | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SSP0013 | Shipment Plan Adjustment | 34/0 | 34/0 | 34/0 | 34/0 | 34/0 | 34/0 | 34/0 | 34/0 | 34/0 | 34/0 | 34/0 | 34/0 | 34/0 | 34/0 |
| SCM_MST_SHEET_COLUMNS | SSP0013 | Stock Information | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 |
| SCM_MST_SHEET_COLUMNS | SSP0013 | Stock Information Detail | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 | 25/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Shipment Plan Adjustment, Stock information, Stock information Detail
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:454, SetSheetHeaderColumn@InitSpread:478, SetSheetHeaderColumn@InitSpread:490

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 466 | 표시/라벨 변경 | set:CellType | CellType = {?chk} | CHK | if(spreadInfo.SheetName == "Shipment Plan Adjustment") |
| InitSpread |  | 467 | 표시/라벨 변경 | set:Value | Value = {?false} | CHK | if(spreadInfo.SheetName == "Shipment Plan Adjustment") |
| InitSpread |  | 468 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | CHK | if(spreadInfo.SheetName == "Shipment Plan Adjustment") |
| InitSpread |  | 470 | 표시/라벨 변경 | set:CellType | CellType = {?cellTypeImage} | CHANGE_REQ_NO | if(spreadInfo.SheetName == "Shipment Plan Adjustment") |
| SpdMain_CellClick |  | 2917 | 표시/라벨 변경 | set:Value | Value = {?false} |  | if(siMain != null && siMain.IsLock(siMain.SheetName) == false) ⟫ if(siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ⟫ if(siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType.GetType() == typeof(CheckBoxCellType)) |
| SpdMain_CellClick |  | 2949 | 표시/라벨 변경 | set:Value | Value = {?false} |  | else!(siMain != null && siMain.IsLock(siMain.SheetName) == false) ⟫ if(siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ⟫ if(siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType.GetType() == typeof(CheckBoxCellType)) ⟫ if(Convert.ToBoolean(siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value)) |
| SpdMain_CellClick |  | 2953 | 표시/라벨 변경 | set:Value | Value = {?true} |  | else!(siMain != null && siMain.IsLock(siMain.SheetName) == false) ⟫ if(siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ⟫ if(siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType.GetType() == typeof(CheckBoxCellType)) ⟫ else!(Convert.ToBoolean(siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value)) |
| InitializeComponent |  | 144 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 145 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 146 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 147 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 819 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 820 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 821 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 822 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Shipment Plan Adjustment | META+코드연결 | 34 | 34 | 34 | 34 | 34 | 34 | 34 | 34 | 34 | 34 | 34 | 34 | 34 | 34 |
| Stock Information | META+코드연결 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 |
| Stock Information Detail | META+코드연결 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
