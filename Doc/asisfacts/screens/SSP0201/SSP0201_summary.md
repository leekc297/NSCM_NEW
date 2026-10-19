# SSP0201 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0201_ShipmentChangeRequest.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0201_ShipmentChangeRequest.UIL\SSP0201_ShipmentChangeRequest.UIL.csproj | 37 |
| current | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0201_ShipmentChangeRequest.UIL\SSP0201_ShipmentChangeRequest.cs | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0201_ShipmentChangeRequest.UIL\SSP0201_ShipmentChangeRequest.UIL.csproj | 5879 |
| current | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0201_ShipmentChangeRequest.UIL\SSP0201_ShipmentChangeRequest.Designer.cs | 06.UIL\GSCM.SSP.Forms.UIL\Plan\SSP0201_ShipmentChangeRequest.UIL\SSP0201_ShipmentChangeRequest.UIL.csproj | 1732 |
| legacy | 06.UIL\GSCM.SSP.Plan.UIL\SSP0201_ShipmentChangeRequest.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 5874 |
| legacy | 06.UIL\GSCM.SSP.Plan.UIL\SSP0201_ShipmentChangeRequest.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 1729 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:btnCancel.Click | BtnCancel_Click > DeleteDataDrafting > FindButton > FindData_Main | 1325 | SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST | MATCH | SP SSP0201_GET_SHIPMENT_CHANGE_REQUEST |
| event:btnCancel.Click | BtnCancel_Click > DeleteDataDrafting > FindButton > FindData_Sub_Draft | 1796 | SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0201_GET_SHIPMENT_REQUEST_DRAFTING |
| event:btnCancel.Click | BtnCancel_Click > DeleteDataDrafting | 2379 | SSP.SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING |
| event:btnChangeRe.Click | BtnChangeRe_Click > SaveDataDrafting > FindButton > FindData_Main | 1325 | SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST | MATCH | SP SSP0201_GET_SHIPMENT_CHANGE_REQUEST |
| event:btnChangeRe.Click | BtnChangeRe_Click > SaveDataDrafting > FindButton > FindData_Sub_Draft | 1796 | SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0201_GET_SHIPMENT_REQUEST_DRAFTING |
| event:btnChangeRe.Click | BtnChangeRe_Click > SaveDataDrafting | 2222 | SSP.SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE | MATCH | SP SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE |
| event:btnChangeRe2.Click | BtnChangeRe_Click > SaveDataDrafting > FindButton > FindData_Main | 1325 | SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST | MATCH | SP SSP0201_GET_SHIPMENT_CHANGE_REQUEST |
| event:btnChangeRe2.Click | BtnChangeRe_Click > SaveDataDrafting > FindButton > FindData_Sub_Draft | 1796 | SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0201_GET_SHIPMENT_REQUEST_DRAFTING |
| event:btnChangeRe2.Click | BtnChangeRe_Click > SaveDataDrafting | 2222 | SSP.SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE | MATCH | SP SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE |
| event:btnNew.Click | BtnNew_Click | 2996 | biz:CommonData.CommonDataList [code=ShipToCodeByDivision] | BIZ_MATCH |  |
| event:btnSave.Click | BtnSave_Click > SaveDataDrafting > FindButton > FindData_Main | 1325 | SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST | MATCH | SP SSP0201_GET_SHIPMENT_CHANGE_REQUEST |
| event:btnSave.Click | BtnSave_Click > SaveDataDrafting > FindButton > FindData_Sub_Draft | 1796 | SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0201_GET_SHIPMENT_REQUEST_DRAFTING |
| event:btnSave.Click | BtnSave_Click > SaveDataDrafting | 2222 | SSP.SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE | MATCH | SP SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE |
| event:cboChangeType.SelectedIndexChanged | CboChangeType_SelectedIndexChanged > GetDayRange | 2721 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| button:FindButton | FindButton > FindData_Main | 1325 | SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST | MATCH | SP SSP0201_GET_SHIPMENT_CHANGE_REQUEST |
| button:FindButton | FindButton > FindData_Sub_Draft | 1796 | SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0201_GET_SHIPMENT_REQUEST_DRAFTING |
| button:InsertButton | InsertButton > InsertRow | 2455 | biz:CommonData.CommonDataList [code=ShipToCodeByDivision] | BIZ_MATCH |  |
| button:SaveButton | SaveButton | 780 | SSP.SSP0201_GET_CHANGE_REQ_NO | MATCH | SP SSP0201_GET_CHANGE_REQ_NO |
| button:SaveButton | SaveButton | 936 | SSP.SSP0201_SAVE_SHIPMENT_CONFIRM_NEW | MATCH | SP SSP0201_SAVE_SHIPMENT_CONFIRM_NEW |
| button:SaveButton | SaveButton > FindButton > FindData_Main | 1325 | SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST | MATCH | SP SSP0201_GET_SHIPMENT_CHANGE_REQUEST |
| button:SaveButton | SaveButton > FindData_Main_Nonasync | 1417 | SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST_N | MATCH | SP SSP0201_GET_SHIPMENT_CHANGE_REQUEST_N |
| button:SaveButton | SaveButton > FindButton > FindData_Sub_Draft | 1796 | SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0201_GET_SHIPMENT_REQUEST_DRAFTING |
| button:SaveButton | SaveButton > GetERPInterface > GetShipmentStatusChk | 3571 | SSP.SSP0201_GET_SHIPMENT_STATUS | MATCH | SP SSP0201_GET_SHIPMENT_STATUS |
| button:SaveButton | SaveButton > GetERPInterface > GetErpSoNoCnt | 3636 | SSP.SSP0201_GET_ERP_SO_NO_CNT | MATCH | SP SSP0201_GET_ERP_SO_NO_CNT |
| button:SaveButton | SaveButton > GetNewERPInterface > NewNonSoNo | 3768 | SSP.SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING |
| button:SaveButton | SaveButton > GetERPInterface > NonSoNo | 3939 | SSP.SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING |
| button:SaveButton | SaveButton > GetERPInterface > SoNo | 4163 | SSP.SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING |
| event:this.Load | Form_Load > InitControls > GetDayRange | 2721 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:this.spdMain.CellClick | SpdMain_CellClick | 4677 | biz:CommonData.CommonDataList [code=TransMode] | BIZ_MATCH |  |
| event:this.spdMain.CellClick | SpdMain_CellClick | 4691 | biz:CommonData.CommonDataList [code=ShipToCodeByDivision] | BIZ_MATCH |  |
| event:this.spdMain.ClipboardPasted | SpdMain_ClipboardPasted | 5143 | biz:CommonData.CommonDataList [code=ShipToCodeByDivision] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | SpdMain_ComboSelChange | 4815 | biz:CommonData.CommonDataList [code=ShipToCodeByDivision] | BIZ_MATCH |  |
| event:this.spdMain.ComboSelChange | SpdMain_ComboSelChange > FindData_BOD | 5840 | SSP.SSP0026_GET_BOD_ITEM | MATCH | SP SSP0026_GET_BOD_ITEM |
| event:this.spdMain.ComboSelChange | SpdMain_ComboSelChange > FindData_BOD | 5860 | biz:CommonData.CommonDataList [code=TransMode] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetErpIFCheck | 4276 | SSP.SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=ShipToCodeByDivision] | BIZ_MATCH | 5 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_CUSTOMER, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE_CUSTOMER, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE |
| biz:CommonData.CommonDataList [code=TransMode] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCP_MST_BOD_V |
| SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | 1 | SP SCM0001_GET_SCP_DAY_PERIOD | EXEC:SCM0001_GET_SCP_DAY_PERIOD, REF:FN_MULTY_TIME, SELECT:SCM_SYS_CALENDAR_M, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| SSP.SSP0026_GET_BOD_ITEM | MATCH | 1 | SP SSP0026_GET_BOD_ITEM | EXEC:SSP0026_GET_BOD_ITEM, SELECT:SCP_MST_BOD_N_V, SELECT:SCP_MST_BOD_ITEM, REF:STRING_SPLIT |  |
| SSP.SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING | MATCH | 2 | SP SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING | EXEC:SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, UPDATE:SSP_ANL_SHIP_CONFIRM_CHG_REQ, UPDATE:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, UPDATE:SSP_ANL_SHIP_CONFIRM, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, DELETE:SSP_ANL_SHIP_CONFIRM, EXEC:PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_PACKER, INSERT:SCM_SYS_LOG_BATCH, EXEC:PR_SCP_SYS_LOG_BATCH, REF:FN_ZERO_LPAD, INSERT:XIF_ERP_PACK_SHIP_PLAN_S_SN, REF:FN_GET_ITEM_NICKNAME, REF:FN_GET_SSP_MKT_OWNER_NAME, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_SITE_ITEM, SELECT:SSP_MST_MODEL_USER, SELECT:TB_FX_USER, SELECT:SCM_MST_SITE, SELECT:NERP_CONV_MASTER, INSERT:XIF_SCS_PACK_SHIP_PLAN_S_SN, REF:FN_GET_SITE_CUSTOMER_INFO, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_CUSTOMER, SELECT:SCM_MST_SITE_CUSTOMER |  |
| SSP.SSP0201_GET_CHANGE_REQ_NO | MATCH | 1 | SP SSP0201_GET_CHANGE_REQ_NO | EXEC:SSP0201_GET_CHANGE_REQ_NO |  |
| SSP.SSP0201_GET_ERP_SO_NO_CNT | MATCH | 1 | SP SSP0201_GET_ERP_SO_NO_CNT | EXEC:SSP0201_GET_ERP_SO_NO_CNT, SELECT:SSP_ANL_SHIP_CONFIRM |  |
| SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST | MATCH | 1 | SP SSP0201_GET_SHIPMENT_CHANGE_REQUEST | EXEC:SSP0201_GET_SHIPMENT_CHANGE_REQUEST, REF:FN_GET_IN_STR, DYNAMIC@SSP0201_GET_SHIPMENT_CHANGE_REQUEST, REF:FN_SCM_SPLIT |  |
| SSP.SSP0201_GET_SHIPMENT_CHANGE_REQUEST_N | MATCH | 1 | SP SSP0201_GET_SHIPMENT_CHANGE_REQUEST_N | EXEC:SSP0201_GET_SHIPMENT_CHANGE_REQUEST_N, REF:FN_GET_IN_STR, DYNAMIC@SSP0201_GET_SHIPMENT_CHANGE_REQUEST_N, REF:FN_SCM_SPLIT |  |
| SSP.SSP0201_GET_SHIPMENT_REQUEST_DRAFTING | MATCH | 1 | SP SSP0201_GET_SHIPMENT_REQUEST_DRAFTING | EXEC:SSP0201_GET_SHIPMENT_REQUEST_DRAFTING, INSERT:#TMP_SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, REF:FN_GET_PROJECT_NAME, REF:FN_GET_ITEM_NICKNAME, REF:FN_GET_SCM_SITE_DESCRIPTION, REF:FN_GET_SITE_CUSTOMER_INFO, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SELECT:SCP_MST_BOD_N_V, SELECT:SSP_ANL_SHIP_CONFIRM, SELECT:#TMP_SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SELECT:SSP_MST_MODEL_USER, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_MST_PROJECT, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_MST_CUSTOMER, SELECT:SCM_MST_SITE_CUSTOMER |  |
| SSP.SSP0201_GET_SHIPMENT_STATUS | MATCH | 1 | SP SSP0201_GET_SHIPMENT_STATUS | EXEC:SSP0201_GET_SHIPMENT_STATUS, SELECT:SSP_ANL_SHIP_CONFIRM, REF:STRING_SPLIT |  |
| SSP.SSP0201_SAVE_SHIPMENT_CONFIRM_NEW | MATCH | 1 | SP SSP0201_SAVE_SHIPMENT_CONFIRM_NEW | EXEC:SSP0201_SAVE_SHIPMENT_CONFIRM_NEW, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SCP_MST_BOD_N_V, SELECT:SCP_MST_BOD_ITEM, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_MST_PROJECT, REF:STRING_SPLIT, REF:FN_MULTY_TIME, SELECT:SSP_PLAN_VERSION_V, REF:FN_GET_SSP_SITE_INFO, REF:FN_GET_SSP_SITE_INFO_EXCEPTION, SELECT:SCM_MST_FUTURE_PRICE, SELECT:SCM_SYS_CALENDAR_M, REF:FN_NEXT_DAY, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, REF:FN_GET_SSP_ETA_DATE, REF:FN_GET_SSP_ETD_DATE, INSERT:SSP_ANL_SHIP_CONFIRM, INSERT:SCM_SYS_LOG_BATCH, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:CTE_DATE |  |
| SSP.SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE | MATCH | 1 | SP SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE | EXEC:SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, SELECT:TB_FX_USER, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SSP_ANL_SHIP_CONFIRM, SELECT:SSP_MST_MODEL_USER, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, UPDATE:SSP_ANL_SHIP_CONFIRM, MERGE:SSP_ANL_SHIP_CONFIRM_CHG_REQ, EXEC:SCM_SSP_MAIL_SEND, INSERT:SCM_SYS_LOG_BATCH, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ, SELECT:SCM_ADM_RECIPIENT_LIST, SELECT:SCM_ADM_RECIPIENT_MESSAGE, SELECT:SCM_ADM_RECIPIENT_ASSIGN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, INSERT:#TBLSSPAPPROVEDMAILSEND, REF:FN_GET_USER_NAME, REF:FN_GET_ITEM_NICKNAME, REF:FN_GET_SCM_SITE_DESCRIPTION, REF:FN_GET_SSP_MKT_OWNER_NAME, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SELECT:SCM_MST_SITE_ITEM, SELECT:#TBLSSPAPPROVEDMAILSEND, EXEC:PR_SCM_SYS_LOG_BATCH, EXEC:SCM_ADM_MAIL_SEND, SELECT:SSP_MST_DELEGATE, EXEC:SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG, SELECT:SCM_MST_ITEM_SN, EXEC:SP_SEND_DBMAIL, INSERT:SCM_ADM_SMS_MAIL_SEND_LOG |  |
| SSP.SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING | MATCH | 3 | SP SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING | EXEC:SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING, EXEC:PR_SCM_SYS_LOG_BATCH, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SSP_ANL_SHIP_CONFIRM, SELECT:SCP_MST_BOD_N_V, SELECT:SCP_MST_BOD_ITEM, SELECT:SCM_MST_SITE, MERGE:SSP_ANL_SHIP_CONFIRM_CHG_REQ, REF:FN_GET_SSP_ETA_DATE, INSERT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SELECT:SSP_MST_SITE_ITEM_EE_V, UPDATE:SSP_ANL_SHIP_CONFIRM, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_SYS_CALENDAR_M |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| BtnNew_Click | UserInfoContext.Current | NowGroupID |
| chkERPIFBlockYn | dtERPBlockYnIF.Rows[0] | BLOCK_YN, PERIOD |
| FindData_Sub_Draft | ds.Tables[1].Rows[0] | USER_ID, DEPT_ID, USER_NAME, DEPT_NAME_KO, USER_NAME_EN, DEPT_NAME_EN |
| GetErpSoNoCnt | ds.Tables[0].Rows[0] | CNT |
| GetShipmentStatusChk | ds.Tables[0].Rows[iRow] | CONFIRM_ID |
| GetShipmentStatusChk | ds.Tables[1].Rows[iRow] | CONFIRM_ID |
| GetShipmentStatusChk | ds.Tables[2].Rows[iRow] | CONFIRM_ID |
| InitControls | c | CODE |
| InitControls | dtShipmentInputPeriod.Rows[0] | VALUE, Diff_VALUE |
| InitControls | dtShipmentInputPeriod.Rows[1] | VALUE, Diff_VALUE |
| InsertRow | UserInfoContext.Current | NowGroupID |
| SaveDataDrafting | UserInfoContext.Current | NowGroupID |
| SetChangeControl | Filter | GROUP_ID, USER_ID |
| SetChangeControl | UserInfoContext.Current | NowGroupID |
| SetChangedControl | UserInfoContext.Current | NowGroupID |
| SetChangeRequestInfo | dt.Rows[0] | CHANGE_REQ_NO, REQUEST_USER, REQUEST_USER_NAME, REQUEST_DEPT, REQUEST_DEPT_NAME, REQUEST_TITLE, APPROVAL_USER, APPROVAL_USER_NAME, APPROVAL_DEPT, CHANGE_REASON_CODE, CHANGE_REASON_DETAIL, APPROVAL_DEPT_NAME |
| setEndCustomer | dtEndCustomer.Rows[0] | CODE |
| setEndCustomer | drRow | CODE, NAME |
| SpdMain_ComboSelChange | UserInfoContext.Current | NowGroupID |
| SpdMain_ComboSelChange | c | CODE |
| SpdMain_ComboSelChange | dr | ROUTE_ID, BOD_ID, INCOTERMS, D_COUNTRY, D_PORT_CODE, A_COUNTRY, A_PORT_CODE, TO_COUNTRY, TO_CITY, LT_TOTAL |
| SSP_Main_Validation | row | confirm_id |
| SSP_Main_Validation | Validationdr | shipment_confirm_qty, shipment_date, TRANSPORT_MODE, INCOTERMS, remarks2, remarks, TO_SITE_SHIPTO_CODE |
| SSP_Main_Validation | SONoValidationdr | shipment_confirm_qty, shipment_date, TRANSPORT_MODE, remarks2, remarks, TO_SITE_SHIPTO_CODE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetSSPInnerTable | SetChangeControl:319, SetChangeControl:324, SetChangeControl:329, SetChangeControl:334, SetChangeControl:339, SetChangeControl:344, SetChangeControl:349 | DataService.GetSSPInnerTable | CODE, COMPANY_ID, DEPT_ID, DIVISION_ID, END_CUSTOMER, LANGUAGE_CODE, NAME, PLANT_ID, SCM_SITE_ID |
| FP_Log2 | InitControls:419, InitControls:428 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |
| GetCheckedListValue | SetChangedControl:503, SaveButton:795, FindData_Main:1303, FindData_Main:1304, FindData_Main:1305, FindData_Main:1306, FindData_Main:1307, FindData_Main_Nonasync:1395 | CString.GetCheckedListValue | CODE |
| SetSheetHeaderColumn | InitSpread:546, InitSpread:599 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:288 |
| clbDivision_ID | SelectedIndexChanged | clbDivision_ID_SelectedIndexChanged | InitEvent:360 |
| spdMain | TopChange | SpdMain_TopChange | InitEvent:361 |
| btnApprovalUser | Click | BtnApprovalUser_Click | InitEvent:362 |
| dsdm | Changed | shtMain_Change | InitEvent:365 |
| btnSave | Click | BtnSave_Click | InitEvent:370 |
| btnChangeRe | Click | BtnChangeRe_Click | InitEvent:371 |
| btnChangeRe2 | Click | BtnChangeRe_Click | InitEvent:372 |
| btnCancel | Click | BtnCancel_Click | InitEvent:375 |
| btnNew | Click | BtnNew_Click | InitEvent:376 |
| this.spdMain | CellClick | SpdMain_CellClick | InitEvent:378 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:379 |
| this.spdMain | EditChange | SpdMain_EditChange | InitEvent:380 |
| this.spdMain | ClipboardPasted | SpdMain_ClipboardPasted | InitEvent:381 |
| this.spdMain | ComboSelChange | SpdMain_ComboSelChange | InitEvent:382 |
| this.btnItemId | Click | btnItemId_Click | InitEvent:383 |
| cboChangeType | SelectedIndexChanged | CboChangeType_SelectedIndexChanged | InitEvent:385 |
| spdMain | CursorChanged | SpdMain_CursorChanged | InitEvent:387 |

## 6. 컨트롤 (80개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 28 | layoutControlItem7, lcChgReq, PlanType, layoutControlItem1, Model, layoutControlItem2, PlanType1, lblSONo, layoutControlItem3, layoutControlItem12, layoutControlItem8, layoutControlItem11, lcAdd, lcDel, lcCancel … |
| EmptySpaceItem | 8 | emptySpaceItem1, emptySpaceItem2, emptySpaceItem3, emptySpaceItem4, emptySpaceItem8, emptySpaceItem5, emptySpaceItem6, emptySpaceItem7 |
| TextBox | 7 | txtRequestNo, txtTitle, txtRequestor, txtRequestDeptName, txtAppDeptName, txtReasonDetail, txtApproval |
| SimpleButton | 6 | btnChangeRe, btnDel, btnCancel, btnSave, btnAdd, btnChangeRe2 |
| UsrMultiLineEditor | 4 | txtConfirmId, txtSoNo, txtRequest, txtItemId |
| UsrLayoutControl | 3 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl3 |
| UsrCombo | 3 | clbDivision_ID, cboStatus, cboChangeType |
| UsrButton | 3 | btnItemId, btnNew, btnApprovalUser |
| LayoutControlGroup | 3 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup3 |
| FpSpread | 2 | spdMain, spdSub |
| SheetView | 2 | spdMain_Sheet1, spdSub_Sheet1 |
| UsrCheckedList | 2 | clbFromSite, clbToSite |
| Panel | 2 | panel3, panel1 |
| SplitContainer | 1 | splitContainer1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrDateRangePicker | 1 | drpPeriod |
| UsrDatePicker | 1 | dtDate |
| UsrComboBox | 1 | cboChangeReason |
| UsrLabel | 1 | usrLabel2 |
| ImageList | 1 | imageList1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 61 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL | 1 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL_H | 4 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL_H.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 123 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 15 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 8 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 2 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 2 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 5 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (4건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 1179 | SSP.SSP0201_SAVE_SHIPMENT_CONFIRM_NEW | commented:MATCH |
| 1561 | SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING | commented:MATCH |
| 1937 | SSP.SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING | commented:MATCH |
| 2720 | SCP.GET_DATE_RANGE_1MONTH | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SSP0201 | Change Request | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 | 28/0 |
| SCM_MST_SHEET_COLUMNS | SSP0201 | Shipment Change Request | 33/0 | 33/0 | 33/0 | 33/0 | 33/0 | 33/0 | 33/0 | 33/0 | 33/0 | 33/0 | 33/0 | 33/0 | 33/0 | 33/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Shipment Change Request, Change Request
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:546, SetSheetHeaderColumn@InitSpread:599

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 554 | 표시/라벨 변경 | set:Width | Width = 0 | ERP_SO_NO | if(spreadInfo.SheetName == "Shipment Change Request") ⟫ if(cboChangeType.SelectedValue.ToString() == "P") |
| InitSpread |  | 555 | 표시/라벨 변경 | set:Width | Width = 0 | CONFIRM_ID | if(spreadInfo.SheetName == "Shipment Change Request") ⟫ if(cboChangeType.SelectedValue.ToString() == "P") |
| InitSpread |  | 567 | 표시/라벨 변경 | set:Width | Width = 120 | CONFIRM_ID | if(spreadInfo.SheetName == "Shipment Change Request") ⟫ else!(cboChangeType.SelectedValue.ToString() == "P") |
| InitSpread |  | 578 | 표시/라벨 변경 | set:Visible | Visible = {?true} | END_CUSTOMER | if(spreadInfo.SheetName == "Shipment Change Request") ⟫ if(clbDivision_ID.SelectedValue.ToString() == "40" \|\| clbDivision_ID.SelectedValue.ToString() == "EE") |
| InitSpread |  | 579 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PROJECT_CODE | if(spreadInfo.SheetName == "Shipment Change Request") ⟫ if(clbDivision_ID.SelectedValue.ToString() == "40" \|\| clbDivision_ID.SelectedValue.ToString() == "EE") |
| InitSpread |  | 580 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PROJECT_NAME | if(spreadInfo.SheetName == "Shipment Change Request") ⟫ if(clbDivision_ID.SelectedValue.ToString() == "40" \|\| clbDivision_ID.SelectedValue.ToString() == "EE") |
| InitSpread |  | 585 | 표시/라벨 변경 | set:Visible | Visible = {?false} | END_CUSTOMER | if(spreadInfo.SheetName == "Shipment Change Request") ⟫ else!(clbDivision_ID.SelectedValue.ToString() == "40" \|\| clbDivision_ID.SelectedValue.ToString() == "EE") |
| InitSpread |  | 586 | 표시/라벨 변경 | set:Visible | Visible = {?true} | PROJECT_CODE | if(spreadInfo.SheetName == "Shipment Change Request") ⟫ else!(clbDivision_ID.SelectedValue.ToString() == "40" \|\| clbDivision_ID.SelectedValue.ToString() == "EE") |
| InitSpread |  | 587 | 표시/라벨 변경 | set:Visible | Visible = {?true} | PROJECT_NAME | if(spreadInfo.SheetName == "Shipment Change Request") ⟫ else!(clbDivision_ID.SelectedValue.ToString() == "40" \|\| clbDivision_ID.SelectedValue.ToString() == "EE") |
| InitSpread |  | 608 | 표시/라벨 변경 | set:CellType | CellType = {?chk} | CHK | if(spreadInfo.SheetName == "Change Request") |
| InitSpread |  | 609 | 표시/라벨 변경 | set:Value | Value = {?false} | CHK | if(spreadInfo.SheetName == "Change Request") |
| InitSpread |  | 610 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | CHK | if(spreadInfo.SheetName == "Change Request") |
| InitSpread |  | 619 | 표시/라벨 변경 | set:Width | Width = 0 | REMARKS | if(spreadInfo.SheetName == "Change Request") |
| InitSpread |  | 624 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ERP_SO_NO | if(spreadInfo.SheetName == "Change Request") ⟫ if(cboChangeType.SelectedValue.ToString() == "P") |
| InitSpread |  | 646 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ERP_SO_NO | if(spreadInfo.SheetName == "Change Request") ⟫ else!(cboChangeType.SelectedValue.ToString() == "P") |
| SetChangeRequestSOGrid |  | 2042 | 표시/라벨 변경 | set:Visible | Visible = {?false} | {?CAppSetting.StringAction} | for(i < siSub.ActiveSheet.RowCount) |
| SetChangeRequestSOGrid |  | 2061 | 표시/라벨 변경 | set:Visible | Visible = {?false} | CHK | for(i < siSub.ActiveSheet.RowCount) ⟫ else!(sShipStatus == "R") ⟫ if(sSearchType == "Exist") |
| SpdMain_CellClick |  | 4705 | 표시/라벨 변경 | set:Value | Value = {?false} |  | if(siMain != null && siMain.IsLock(siMain.SheetName) == false) ⟫ if(siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ⟫ if(siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType.GetType() == typeof(CheckBoxCellType)) |
| SpdMain_CellClick |  | 4740 | 표시/라벨 변경 | set:Value | Value = {?false} |  | else!(siMain != null && siMain.IsLock(siMain.SheetName) == false) ⟫ if(siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ⟫ if(siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType.GetType() == typeof(CheckBoxCellType)) ⟫ if(Convert.ToBoolean(siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value)) |
| SpdMain_CellClick |  | 4744 | 표시/라벨 변경 | set:Value | Value = {?true} |  | else!(siMain != null && siMain.IsLock(siMain.SheetName) == false) ⟫ if(siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ⟫ if(siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType.GetType() == typeof(CheckBoxCellType)) ⟫ else!(Convert.ToBoolean(siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value)) |
| SpdMain_ComboSelChange |  | 4870 | 표시/라벨 변경 | set:Visible | Visible = {?true} | END_CUSTOMER | if(e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ⟫ if(sDivisionID == "40" \|\| sDivisionID == "EE") |
| SpdMain_ComboSelChange |  | 4871 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PROJECT_CODE | if(e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ⟫ if(sDivisionID == "40" \|\| sDivisionID == "EE") |
| SpdMain_ComboSelChange |  | 4872 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PROJECT_NAME | if(e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ⟫ if(sDivisionID == "40" \|\| sDivisionID == "EE") |
| SpdMain_ComboSelChange |  | 4879 | 표시/라벨 변경 | set:Visible | Visible = {?false} | END_CUSTOMER | if(e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ⟫ else!(sDivisionID == "40" \|\| sDivisionID == "EE") |
| SpdMain_ComboSelChange |  | 4880 | 표시/라벨 변경 | set:Visible | Visible = {?true} | PROJECT_CODE | if(e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ⟫ else!(sDivisionID == "40" \|\| sDivisionID == "EE") |
| SpdMain_ComboSelChange |  | 4881 | 표시/라벨 변경 | set:Visible | Visible = {?true} | PROJECT_NAME | if(e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ⟫ else!(sDivisionID == "40" \|\| sDivisionID == "EE") |
| InitializeComponent |  | 220 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 221 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 222 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 223 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 904 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 905 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 906 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 907 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Change Request | META+코드연결 | 27 (?5) | 28 (?5) | 28 (?5) | 28 (?5) | 28 (?5) | 28 (?5) | 28 (?5) | 28 (?5) | 27 (?5) | 28 (?5) | 28 (?5) | 28 (?5) | 28 (?5) | 28 (?5) |
| Shipment Change Request | META+코드연결 | 31 (?4) | 32 (?4) | 32 (?4) | 32 (?4) | 32 (?4) | 32 (?4) | 32 (?4) | 32 (?4) | 31 (?4) | 32 (?4) | 32 (?4) | 32 (?4) | 32 (?4) | 32 (?4) |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
판단불가(?) 분류: 런타임:컬럼별 루프/태그 판정 84, 런타임:화면컨트롤값 28, 런타임:조회데이터 28 — 런타임 분류는 실행 시점에만 결정되는 정상 동적 분기, '미지원식'만 파서 보완 대상.
분기 조건 판단불가 적용 140건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
