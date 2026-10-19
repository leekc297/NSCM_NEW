# SSP0002 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0002_ShipmentConfirmInsertPopup.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 1462 |
| only | 06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0002_ShipmentConfirmInsertPopup.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 295 |
| only | 06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0002_UserInfoPopup.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 303 |
| only | 06.UIL\GSCM.SSP.Plan.UIL\Popup\SSP0002_UserInfoPopup.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 290 |
| only | 06.UIL\GSCM.SSP.Plan.UIL\SSP0002_ShipmentChangeRequest_Backup.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 2313 |
| only | 06.UIL\GSCM.SSP.Plan.UIL\SSP0002_ShipmentChangeRequest_Backup.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 1466 |
| only | 06.UIL\GSCM.SSP.Plan.UIL\SSP0002_ShipmentChangeRequest.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 3164 |
| only | 06.UIL\GSCM.SSP.Plan.UIL\SSP0002_ShipmentChangeRequest.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 1676 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:btnAdd.Click | BtnAdd_Click > FindAddData > SaveAddDataDrafting > FindData_Sub | 650 | SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_GET_SHIPMENT_REQUEST_DRAFTING |
| event:btnAdd.Click | BtnAdd_Click > FindAddData > SaveAddDataDrafting > FindData_Sub > FindData_Sub_Draft | 833 | SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_GET_SHIPMENT_REQUEST_DRAFTING |
| event:btnAdd.Click | BtnAdd_Click > FindAddData > SaveAddDataDrafting > FindData_Sub | 920 | SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_GET_SHIPMENT_REQUEST_DRAFTING |
| event:btnAdd.Click | BtnAdd_Click > FindAddData > SaveAddDataDrafting > FindData_Sub > GetErpIFCheck | 935 | SSP.SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING |
| event:btnAdd.Click | BtnAdd_Click > FindAddData > SaveAddDataDrafting > FindData_Sub > SaveDataDrafting | 1150 | SSP.SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING |
| event:btnAdd.Click | BtnAdd_Click > FindAddData > SaveAddDataDrafting > FindData_Sub > FindData_Sub_Draft | 1156 | SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_GET_SHIPMENT_REQUEST_DRAFTING |
| event:btnAdd.Click | BtnAdd_Click > FindAddData > SaveAddDataDrafting > FindData_Sub > GetErpIFCheck | 1270 | SSP.SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING |
| event:btnAdd.Click | BtnAdd_Click > FindAddData > SaveAddDataDrafting | 1277 | SSP.SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING |
| event:btnAdd.Click | BtnAdd_Click > FindAddData > SaveAddDataDrafting > FindData_Sub > SaveDataDrafting | 1553 | SSP.SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING |
| event:btnAdd.Click | BtnAdd_Click > FindAddData > SaveAddDataDrafting | 1725 | SSP.SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING |
| event:btnAdd.Click | BtnAdd_Click > FindAddData | 2220 | SSP.SSP0002_GET_SHIPMENT_CHANGE_REQUEST_ADD | MATCH | SP SSP0002_GET_SHIPMENT_CHANGE_REQUEST_ADD |
| event:btnAdd.Click | BtnAdd_Click > FindAddData | 2990 | SSP.SSP0002_GET_SHIPMENT_CHANGE_REQUEST_ADD | MATCH | SP SSP0002_GET_SHIPMENT_CHANGE_REQUEST_ADD |
| event:btnCancel.Click | BtnCancel_Click > DeleteDataDrafting > FindData_Sub | 650 | SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_GET_SHIPMENT_REQUEST_DRAFTING |
| event:btnCancel.Click | BtnCancel_Click > DeleteDataDrafting > FindData_Sub > FindData_Sub_Draft | 833 | SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_GET_SHIPMENT_REQUEST_DRAFTING |
| event:btnCancel.Click | BtnCancel_Click > DeleteDataDrafting > FindData_Sub | 920 | SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_GET_SHIPMENT_REQUEST_DRAFTING |
| event:btnCancel.Click | BtnCancel_Click > DeleteDataDrafting > FindData_Sub > GetErpIFCheck | 935 | SSP.SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING |
| event:btnCancel.Click | BtnCancel_Click > DeleteDataDrafting > FindData_Sub > SaveDataDrafting | 1150 | SSP.SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING |
| event:btnCancel.Click | BtnCancel_Click > DeleteDataDrafting > FindData_Sub > FindData_Sub_Draft | 1156 | SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_GET_SHIPMENT_REQUEST_DRAFTING |
| event:btnCancel.Click | BtnCancel_Click > DeleteDataDrafting > FindData_Sub > GetErpIFCheck | 1270 | SSP.SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING |
| event:btnCancel.Click | BtnCancel_Click > DeleteDataDrafting | 1383 | SSP.SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING |
| event:btnCancel.Click | BtnCancel_Click > DeleteDataDrafting > FindData_Sub > SaveDataDrafting | 1553 | SSP.SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING |
| event:btnCancel.Click | BtnCancel_Click > DeleteDataDrafting | 1853 | SSP.SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING |
| event:btnChangeRe.Click | BtnChangeRe_Click > SaveDataDrafting > FindData_Sub | 650 | SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_GET_SHIPMENT_REQUEST_DRAFTING |
| event:btnChangeRe.Click | BtnChangeRe_Click > SaveDataDrafting > FindData_Sub > FindData_Sub_Draft | 833 | SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_GET_SHIPMENT_REQUEST_DRAFTING |
| event:btnChangeRe.Click | BtnChangeRe_Click > SaveDataDrafting > FindData_Sub | 920 | SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_GET_SHIPMENT_REQUEST_DRAFTING |
| event:btnChangeRe.Click | BtnChangeRe_Click > SaveDataDrafting > FindData_Sub > GetErpIFCheck | 935 | SSP.SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING |
| event:btnChangeRe.Click | BtnChangeRe_Click > SaveDataDrafting | 1150 | SSP.SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING |
| event:btnChangeRe.Click | BtnChangeRe_Click > SaveDataDrafting > FindData_Sub > FindData_Sub_Draft | 1156 | SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_GET_SHIPMENT_REQUEST_DRAFTING |
| event:btnChangeRe.Click | BtnChangeRe_Click > SaveDataDrafting > FindData_Sub > GetErpIFCheck | 1270 | SSP.SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING |
| event:btnChangeRe.Click | BtnChangeRe_Click > SaveDataDrafting | 1553 | SSP.SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING |
| event:btnChangeRe2.Click | BtnChangeRe_Click > SaveDataDrafting > FindData_Sub | 920 | SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_GET_SHIPMENT_REQUEST_DRAFTING |
| event:btnChangeRe2.Click | BtnChangeRe_Click > SaveDataDrafting > FindData_Sub > FindData_Sub_Draft | 1156 | SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_GET_SHIPMENT_REQUEST_DRAFTING |
| event:btnChangeRe2.Click | BtnChangeRe_Click > SaveDataDrafting > FindData_Sub > GetErpIFCheck | 1270 | SSP.SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING |
| event:btnChangeRe2.Click | BtnChangeRe_Click > SaveDataDrafting | 1553 | SSP.SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING |
| event:btnDel.Click | BtnDel_Click > DeleteDataDrafting > FindData_Sub | 650 | SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_GET_SHIPMENT_REQUEST_DRAFTING |
| event:btnDel.Click | BtnDel_Click > DeleteDataDrafting > FindData_Sub > FindData_Sub_Draft | 833 | SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_GET_SHIPMENT_REQUEST_DRAFTING |
| event:btnDel.Click | BtnDel_Click > DeleteDataDrafting > FindData_Sub | 920 | SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_GET_SHIPMENT_REQUEST_DRAFTING |
| event:btnDel.Click | BtnDel_Click > DeleteDataDrafting > FindData_Sub > GetErpIFCheck | 935 | SSP.SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING |
| event:btnDel.Click | BtnDel_Click > DeleteDataDrafting > FindData_Sub > SaveDataDrafting | 1150 | SSP.SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING |
| event:btnDel.Click | BtnDel_Click > DeleteDataDrafting > FindData_Sub > FindData_Sub_Draft | 1156 | SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_GET_SHIPMENT_REQUEST_DRAFTING |
| event:btnDel.Click | BtnDel_Click > DeleteDataDrafting > FindData_Sub > GetErpIFCheck | 1270 | SSP.SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING |
| event:btnDel.Click | BtnDel_Click > DeleteDataDrafting | 1383 | SSP.SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING |
| event:btnDel.Click | BtnDel_Click > DeleteDataDrafting > FindData_Sub > SaveDataDrafting | 1553 | SSP.SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING |
| event:btnDel.Click | BtnDel_Click > DeleteDataDrafting | 1853 | SSP.SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING |
| event:btnNew.Click | BtnNew_Click > FindData_Main_Nonasync | 777 | SSP.SSP0002_GET_SHIPMENT_CHANGE_REQUEST | MATCH | SP SSP0002_GET_SHIPMENT_CHANGE_REQUEST |
| event:btnNew.Click | BtnNew_Click > SpdMain_CellDoubleClick > FindData_Sub | 920 | SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_GET_SHIPMENT_REQUEST_DRAFTING |
| event:btnNew.Click | BtnNew_Click > SpdMain_CellDoubleClick > FindData_Sub > FindData_Sub_Draft | 1156 | SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_GET_SHIPMENT_REQUEST_DRAFTING |
| event:btnNew.Click | BtnNew_Click > SpdMain_CellDoubleClick > FindData_Sub > GetErpIFCheck | 1270 | SSP.SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING |
| event:btnNew.Click | BtnNew_Click > SpdMain_CellDoubleClick > FindData_Sub > SaveDataDrafting | 1553 | SSP.SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING |
| event:btnNew.Click | BtnNew_Click > SpdMain_CellDoubleClick | 2147 | biz:CommonData.CommonDataList [code=TransMode] | BIZ_MATCH |  |
| event:btnNew.Click | BtnNew_Click > GetDayRange | 2533 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:btnSave.Click | BtnSave_Click > SaveDataDrafting > FindData_Sub | 650 | SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_GET_SHIPMENT_REQUEST_DRAFTING |
| event:btnSave.Click | BtnSave_Click > SaveDataDrafting > FindData_Sub > FindData_Sub_Draft | 833 | SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_GET_SHIPMENT_REQUEST_DRAFTING |
| event:btnSave.Click | BtnSave_Click > SaveDataDrafting > FindData_Sub | 920 | SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_GET_SHIPMENT_REQUEST_DRAFTING |
| event:btnSave.Click | BtnSave_Click > SaveDataDrafting > FindData_Sub > GetErpIFCheck | 935 | SSP.SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING |
| event:btnSave.Click | BtnSave_Click > SaveDataDrafting | 1150 | SSP.SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING |
| event:btnSave.Click | BtnSave_Click > SaveDataDrafting > FindData_Sub > FindData_Sub_Draft | 1156 | SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_GET_SHIPMENT_REQUEST_DRAFTING |
| event:btnSave.Click | BtnSave_Click > SaveDataDrafting > FindData_Sub > GetErpIFCheck | 1270 | SSP.SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING |
| event:btnSave.Click | BtnSave_Click > SaveDataDrafting | 1553 | SSP.SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING |
| event:cboChangeType.SelectedIndexChanged | CboChangeType_SelectedIndexChanged > GetDayRange | 2533 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetChangedControl | 276 | biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData > InitSpread | 148 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData | 176 | SSP.SSP0002_GET_USER_INFO_LIST | MATCH | SP SSP0002_GET_USER_INFO_LIST |
| button:FindButton | FindButton > FindData_Main | 524 | SSP.SSP0002_GET_SHIPMENT_CHANGE_REQUEST | MATCH | SP SSP0002_GET_SHIPMENT_CHANGE_REQUEST |
| button:FindButton | FindButton > FindData_Main | 700 | SSP.SSP0002_GET_SHIPMENT_CHANGE_REQUEST | MATCH | SP SSP0002_GET_SHIPMENT_CHANGE_REQUEST |
| button:SaveButton | SaveButton > SaveData | 386 | SSP.SSP0002_SAVE_SHIPMENT_CONFIRM_NEW | MATCH | SP SSP0002_SAVE_SHIPMENT_CONFIRM_NEW |
| button:SaveButton | SaveButton > SaveData > BodValidChk | 503 | SSP.SSP0002_GET_BOD_VALID_CHECK | MATCH | SP SSP0002_GET_BOD_VALID_CHECK |
| button:SaveButton | SaveButton > SaveData > PlantSiteChk | 561 | SSP.SSP0002_GET_PLANT_SITE_CHECK | MATCH | SP SSP0002_GET_PLANT_SITE_CHECK |
| event:spdMain.CellClick | SpdMain_CellClick | 782 | biz:CommonData.CommonDataList [code=TransMode] | BIZ_MATCH |  |
| event:spdMain.ClipboardPasted | SpdMain_ClipboardPasted | 1177 | biz:CommonData.CommonDataList [code=TransMode] | BIZ_MATCH |  |
| event:spdMain.ClipboardPasted | SpdMain_ClipboardPasted | 1224 | biz:CommonData.CommonDataList [code=PlantByElectordeShipToSite_EE] | BIZ_MATCH |  |
| event:spdMain.ComboSelChange | SpdMain_ComboSelChange > PlantSiteChk | 561 | SSP.SSP0002_GET_PLANT_SITE_CHECK | MATCH | SP SSP0002_GET_PLANT_SITE_CHECK |
| event:spdMain.ComboSelChange | SpdMain_ComboSelChange | 897 | biz:CommonData.CommonDataList [code=PlantByElectordeShipToSite_EE] | BIZ_MATCH |  |
| event:this.btnButtonList.UsrButtonList_Click_Detected | BtnButtonList_UsrButtonList_Click_Detected > FindButton > FindData > InitSpread | 148 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| event:this.btnButtonList.UsrButtonList_Click_Detected | BtnButtonList_UsrButtonList_Click_Detected > FindButton > FindData | 176 | SSP.SSP0002_GET_USER_INFO_LIST | MATCH | SP SSP0002_GET_USER_INFO_LIST |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData | 386 | SSP.SSP0002_SAVE_SHIPMENT_CONFIRM_NEW | MATCH | SP SSP0002_SAVE_SHIPMENT_CONFIRM_NEW |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData > BodValidChk | 503 | SSP.SSP0002_GET_BOD_VALID_CHECK | MATCH | SP SSP0002_GET_BOD_VALID_CHECK |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData > PlantSiteChk | 561 | SSP.SSP0002_GET_PLANT_SITE_CHECK | MATCH | SP SSP0002_GET_PLANT_SITE_CHECK |
| event:this.Load | Form_Load > FindData > InitSpread | 148 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData | 176 | SSP.SSP0002_GET_USER_INFO_LIST | MATCH | SP SSP0002_GET_USER_INFO_LIST |
| event:this.Load | Form_Load > InitControls > SetChangedControl | 276 | biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetDayRange | 1449 | SCP.GET_DATE_RANGE_1MONTH | MATCH | [statement] foxquery_sql\SCP.GET_DATE_RANGE_1MONTH.sql |
| event:this.Load | Form_Load > InitControls > GetDayRange | 1898 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:this.Load | Form_Load > InitControls > GetDayRange | 2533 | SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | SP SCM0001_GET_SCP_DAY_PERIOD |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Sub | 650 | SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_GET_SHIPMENT_REQUEST_DRAFTING |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Sub > FindData_Sub_Draft | 833 | SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_GET_SHIPMENT_REQUEST_DRAFTING |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Sub | 920 | SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_GET_SHIPMENT_REQUEST_DRAFTING |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Sub > GetErpIFCheck | 935 | SSP.SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Sub > SaveDataDrafting | 1150 | SSP.SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Sub > FindData_Sub_Draft | 1156 | SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_GET_SHIPMENT_REQUEST_DRAFTING |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Sub > GetErpIFCheck | 1270 | SSP.SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Sub > SaveDataDrafting | 1553 | SSP.SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING | MATCH | SP SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick | 1593 | biz:CommonData.CommonDataList [code=TransMode] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick | 2147 | biz:CommonData.CommonDataList [code=TransMode] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtMyDivision> | 42 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtChangeReasonCode> | 44 | biz:CommonData.CommonDataList [code=LookupCommon3] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtChangeStatusCode> | 45 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtFcstType> | 46 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtFcstType> | 46 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtOperationGroup> | 47 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtBaseDay> | 48 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtBaseDay> | 48 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtChangeReasonCode> | 53 | biz:CommonData.CommonDataList [code=LookupCommon3] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtChangeStatusCode> | 54 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtFcstType> | 55 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtBaseDay> | 57 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtChangeReqType> | 58 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SetChangedPeriod | 1507 | biz:CommonData.CommonDataList [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SetChangedPeriod | 1998 | biz:CommonData.CommonDataList [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 10 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=LookupCommon3] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:SELECT:TB_FX_USER |
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] | BIZ_MATCH | 2 |  |  |  |
| biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=PlantByElectordeShipToSite_EE] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=TransMode] | BIZ_MATCH | 4 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCP_MST_BOD_V |
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| SCP.GET_DATE_RANGE_1MONTH | MATCH | 1 | [statement] foxquery_sql\SCP.GET_DATE_RANGE_1MONTH.sql | SELECT:SCM_SYS_CALENDAR_M |  |
| SCP.SCM0001_GET_SCP_DAY_PERIOD | MATCH | 2 | SP SCM0001_GET_SCP_DAY_PERIOD | EXEC:SCM0001_GET_SCP_DAY_PERIOD, REF:FN_MULTY_TIME, SELECT:SCM_SYS_CALENDAR_M, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| SSP.SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING | MATCH | 4 | SP SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING | EXEC:SSP0002_DELETE_SHIPMENT_REQUEST_DRAFTING, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, UPDATE:SSP_ANL_SHIP_CONFIRM, DELETE:SSP_ANL_SHIP_CONFIRM, UPDATE:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, UPDATE:SSP_ANL_SHIP_CONFIRM_CHG_REQ, DELETE:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, DELETE:SSP_ANL_SHIP_CONFIRM_CHG_REQ, EXEC:PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH, INSERT:SCM_SYS_LOG_BATCH, EXEC:PR_SCP_SYS_LOG_BATCH, INSERT:XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, REF:FN_GET_SSP_SITE_INFO, REF:FN_GET_SSP_SITE_INFO_EXCEPTION, REF:FN_GET_SSP_VMI_YN, REF:FN_GET_SSP_MKT_FCST_INCOTERMS, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_SITE, SELECT:NERP_CONV_MASTER, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:DM_PLN_MKT_FCST |  |
| SSP.SSP0002_GET_BOD_VALID_CHECK | MATCH | 1 | SP SSP0002_GET_BOD_VALID_CHECK | EXEC:SSP0002_GET_BOD_VALID_CHECK, SELECT:SCP_MST_BOD_N_V |  |
| SSP.SSP0002_GET_PLANT_SITE_CHECK | MATCH | 1 | SP SSP0002_GET_PLANT_SITE_CHECK | EXEC:SSP0002_GET_PLANT_SITE_CHECK, SELECT:SCM_MST_SITE |  |
| SSP.SSP0002_GET_SHIPMENT_CHANGE_REQUEST | MATCH | 3 | SP SSP0002_GET_SHIPMENT_CHANGE_REQUEST | EXEC:SSP0002_GET_SHIPMENT_CHANGE_REQUEST, REF:FN_GET_IN_STR, DYNAMIC@SSP0002_GET_SHIPMENT_CHANGE_REQUEST, REF:FN_SCM_SPLIT |  |
| SSP.SSP0002_GET_SHIPMENT_CHANGE_REQUEST_ADD | MATCH | 2 | SP SSP0002_GET_SHIPMENT_CHANGE_REQUEST_ADD | EXEC:SSP0002_GET_SHIPMENT_CHANGE_REQUEST_ADD, REF:FN_GET_SITE_CUSTOMER_INFO, SELECT:SSP_ANL_SHIP_CONFIRM, SELECT:SCP_MST_BOD_N_V, REF:FN_MULTY_TIME, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ, SELECT:TB_FX_USER, SELECT:SCM_MST_CUSTOMER, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:SCM_MST_SITE, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |  |
| SSP.SSP0002_GET_SHIPMENT_REQUEST_DRAFTING | MATCH | 4 | SP SSP0002_GET_SHIPMENT_REQUEST_DRAFTING | EXEC:SSP0002_GET_SHIPMENT_REQUEST_DRAFTING, DYNAMIC@SSP0002_GET_SHIPMENT_REQUEST_DRAFTING, REF:FN_GET_PROJECT_NAME, REF:FN_GET_SCM_SITE_DESCRIPTION, REF:FN_GET_SITE_CUSTOMER_INFO, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SELECT:SCP_MST_BOD_N_V, SELECT:SSP_ANL_SHIP_CONFIRM, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:TB_FX_USER, SELECT:SSP_MST_MODEL_USER, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_PROJECT, SELECT:SCM_MST_SITE, SELECT:SCM_MST_CUSTOMER, SELECT:SCM_MST_SITE_CUSTOMER |  |
| SSP.SSP0002_GET_USER_INFO_LIST | MATCH | 1 | SP SSP0002_GET_USER_INFO_LIST | EXEC:SSP0002_GET_USER_INFO_LIST, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:TB_FX_GROUPINFO, SELECT:TB_FX_USERGROUPINFO, SELECT:TB_FX_USER, SELECT:TB_FX_USERGROUPAUTHEXTENTION |  |
| SSP.SSP0002_SAVE_SHIPMENT_CONFIRM_NEW | MATCH | 1 | SP SSP0002_SAVE_SHIPMENT_CONFIRM_NEW | EXEC:SSP0002_SAVE_SHIPMENT_CONFIRM_NEW, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_MST_PROJECT, REF:STRING_SPLIT, REF:FN_MULTY_TIME, SELECT:SSP_PLAN_VERSION_V, REF:FN_GET_SSP_SITE_INFO, REF:FN_GET_SSP_SITE_INFO_EXCEPTION, SELECT:SCM_MST_FUTURE_PRICE, SELECT:SCM_SYS_CALENDAR_M, REF:FN_NEXT_DAY, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, REF:FN_GET_SSP_ETA_DATE, INSERT:SSP_ANL_SHIP_CONFIRM, INSERT:SCM_SYS_LOG_BATCH, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:SCP_MST_BOD_N_V, SELECT:CTE_DATE |  |
| SSP.SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING | MATCH | 4 | SP SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING | EXEC:SSP0002_SAVE_SHIPMENT_REQUEST_DRAFTING, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ, SELECT:TB_FX_USER, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SSP_ANL_SHIP_CONFIRM, SELECT:SSP_MST_MODEL_USER, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, UPDATE:SSP_ANL_SHIP_CONFIRM, MERGE:SSP_ANL_SHIP_CONFIRM_CHG_REQ, SELECT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, REF:FN_GET_SSP_ETA_DATE, UPDATE:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, SELECT:SSP_MST_SITE_ITEM_EE_V, INSERT:SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE, EXEC:SCM_SSP_MAIL_SEND, EXEC:PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCP_MST_BOD_N_V, SELECT:SCM_MST_SITE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_SYS_CALENDAR_M, SELECT:SCM_ADM_RECIPIENT_LIST, SELECT:SCM_ADM_RECIPIENT_MESSAGE, SELECT:SCM_ADM_RECIPIENT_ASSIGN, INSERT:#TBLSSPAPPROVEDMAILSEND, REF:FN_GET_USER_NAME, REF:FN_GET_ITEM_NICKNAME, REF:FN_GET_SCM_SITE_DESCRIPTION, REF:FN_GET_SSP_MKT_OWNER_NAME, SELECT:SCM_MST_SITE_ITEM, SELECT:#TBLSSPAPPROVEDMAILSEND, EXEC:PR_SCM_SYS_LOG_BATCH, EXEC:SCM_ADM_MAIL_SEND, SELECT:SSP_MST_DELEGATE, EXEC:SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG, EXEC:PR_SCP_SYS_LOG_BATCH, INSERT:XIF_ERP_SHIP_PLAN_CONFIRM_S_SN, REF:FN_GET_SSP_SITE_INFO, REF:FN_GET_SSP_SITE_INFO_EXCEPTION, REF:FN_GET_SSP_VMI_YN, REF:FN_GET_SSP_MKT_FCST_INCOTERMS, SELECT:SCM_MST_DIVISION, SELECT:NERP_CONV_MASTER, SELECT:SCM_MST_ITEM_SN, EXEC:SP_SEND_DBMAIL, INSERT:SCM_ADM_SMS_MAIL_SEND_LOG, SELECT:SCM_MST_SITE_CUSTOMER, SELECT:DM_PLN_MKT_FCST |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| <field:dtDivision> | UserInfoContext.Current | NowGroupID |
| <field:dtMyDivision> | UserInfoContext.Current | NowGroupID |
| chkERPIFBlockYn | dtERPBlockYnIF.Rows[0] | BLOCK_YN, PERIOD |
| FindData_Sub | ds.Tables[2].Rows[0] | USER_ID, DEPT_ID, USER_NAME, DEPT_NAME_KO, USER_NAME_EN, DEPT_NAME_EN |
| InitControls | c | CODE |
| SaveAddDataDrafting | UserInfoContext.Current | NowGroupID |
| SaveDataDrafting | UserInfoContext.Current | NowGroupID |
| SetChangedControl | UserInfoContext.Current | NowGroupID |
| SetChangedPeriod | dt.Rows[0] | FROM_VALUE, TO_VALUE |
| SetChangeRequestInfo | dt.Rows[0] | CHANGE_REQ_NO, REQUEST_USER, REQUEST_USER_NAME, REQUEST_DEPT, REQUEST_DEPT_NAME, REQUEST_TITLE, APPROVAL_USER, APPROVAL_USER_NAME, APPROVAL_DEPT, CHANGE_REASON_CODE, CHANGE_REASON_DETAIL, APPROVAL_DEPT_NAME |
| setEndCustomer | dtEndCustomer.Rows[0] | CODE |
| setEndCustomer | drRow | CODE, NAME |
| SpdMain_ClipboardPasted | UserInfoContext.Current | NowGroupID |
| SpdMain_ClipboardPasted | dtOriginDivFromTo.Rows[0] | DIVISION_ID, OPERATION_GROUP |
| SpdMain_ClipboardPasted | c | CODE |
| SpdMain_ClipboardPasted | dr | ROUTE_ID, BOD_ID, INCOTERMS, D_COUNTRY, D_PORT_CODE, A_COUNTRY, A_PORT_CODE, TO_COUNTRY, TO_CITY, LT_TOTAL, LT_TOTAL_ORIGIN |
| SpdMain_ComboSelChange | UserInfoContext.Current | NowGroupID |
| SpdMain_ComboSelChange | dtOriginDivFromTo.Rows[0] | OPERATION_GROUP, DIVISION_ID |
| SpdMain_ComboSelChange | c | CODE |
| SpdMain_ComboSelChange | dr | ROUTE_ID, BOD_ID, INCOTERMS, D_COUNTRY, D_PORT_CODE, A_COUNTRY, A_PORT_CODE, TO_COUNTRY, TO_CITY, LT_TOTAL, LT_TOTAL_ORIGIN |
| SpdSub_ComboSelChange | c | CODE |
| SpdSub_ComboSelChange | dr | ROUTE_ID, BOD_ID, INCOTERMS, D_COUNTRY, D_PORT_CODE, A_COUNTRY, A_PORT_CODE, TO_COUNTRY, TO_CITY, LT_TOTAL |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| SaveData | SaveButton:262, btnButtonList_UsrButtonList_Click_Detected:598, SaveButton:660, SaveButton:486 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| GetCheckedListValue | SetChangedControl:361, FindData_Main:681, FindData_Main:682, FindData_Main:687, FindData_Main:688, FindData_Main:689, FindData_Main_Nonasync:760, FindData_Main_Nonasync:761 | CString.GetCheckedListValue | CODE |
| SetSheetHeaderColumn | InitSpread:407, InitSpread:476, InitSpread:305, InitSpread:350 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:148 |
| this | Load | Form_Load | .ctor:137 |
| spdMain | CellClick | SpdMain_CellClick | Form_Load:152 |
| spdMain | ComboSelChange | SpdMain_ComboSelChange | Form_Load:153 |
| spdMain | ClipboardPasted | SpdMain_ClipboardPasted | Form_Load:154 |
| spdMain | EditChange | SpdMain_EditChange | Form_Load:155 |
| this | Load | Form_Load | .ctor:84 |
| spdMain | CellDoubleClick | SpdMain_CellDoubleClick | .ctor:85 |
| this.btnButtonList | UsrButtonList_Click_Detected | BtnButtonList_UsrButtonList_Click_Detected | Form_Load:100 |
| this.spdMain | CellClick | SpdMain_CellClick | Form_Load:101 |
| this | Load | Form_Load | .ctor:242 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | .ctor:243 |
| this.spdSub | CellClick | SpdSub_CellClick | .ctor:244 |
| this.spdSub | ComboSelChange | SpdSub_ComboSelChange | .ctor:245 |
| clbDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:262 |
| spdMain | TopChange | SpdMain_TopChange | InitEvent:263 |
| btnApprovalUser | Click | BtnApprovalUser_Click | InitEvent:264 |
| dsdm | Changed | shtSub_Change | InitEvent:267 |
| btnSave | Click | BtnSave_Click | InitEvent:269 |
| btnChangeRe | Click | BtnChangeRe_Click | InitEvent:270 |
| btnChangeRe2 | Click | BtnChangeRe_Click | InitEvent:271 |
| btnAdd | Click | BtnAdd_Click | InitEvent:272 |
| btnDel | Click | BtnDel_Click | InitEvent:273 |
| btnCancel | Click | BtnCancel_Click | InitEvent:274 |
| this.btnItemId | Click | btnItemId_Click | InitEvent:275 |
| cboChangeType | SelectedIndexChanged | CboChangeType_SelectedIndexChanged | InitEvent:276 |
| btnNew | Click | BtnNew_Click | InitEvent:277 |
| spdMain | CursorChanged | SpdMain_CursorChanged | InitEvent:279 |
| dsdmSub | Changed | shtSub_Change | shtSub_Change:2592 |
| dsdmSub | Changed | shtSub_Change | shtSub_Change:2603 |
| dsdmSub | Changed | shtSub_Change | shtSub_Change:2625 |
| this | Load | Form_Load | .ctor:189 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | .ctor:190 |
| this.spdSub | CellClick | SpdSub_CellClick | .ctor:191 |
| this.spdSub | ComboSelChange | SpdSub_ComboSelChange | .ctor:192 |
| clbDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:209 |
| spdMain | TopChange | SpdMain_TopChange | InitEvent:210 |
| btnApprovalUser | Click | BtnApprovalUser_Click | InitEvent:211 |
| dsdm | Changed | shtSub_Change | InitEvent:214 |
| btnSave | Click | BtnSave_Click | InitEvent:216 |
| btnChangeRe | Click | BtnChangeRe_Click | InitEvent:217 |
| btnAdd | Click | BtnAdd_Click | InitEvent:218 |
| btnDel | Click | BtnDel_Click | InitEvent:219 |
| btnCancel | Click | BtnCancel_Click | InitEvent:220 |
| this.btnItemId | Click | btnItemId_Click | InitEvent:221 |
| dsdmSub | Changed | shtSub_Change | shtSub_Change:1954 |
| dsdmSub | Changed | shtSub_Change | shtSub_Change:1965 |
| dsdmSub | Changed | shtSub_Change | shtSub_Change:1987 |

## 6. 컨트롤 (171개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 53 | layoutControlItem3, layoutControlItem1, layoutControlItem3, lcDivision, layoutControlItem7, lcChgReq, PlanType, layoutControlItem1, Model, layoutControlItem2, PlanType1, lblSONo, layoutControlItem3, layoutControlItem12, lcAdd … |
| EmptySpaceItem | 19 | emptySpaceItem1, emptySpaceItem2, emptySpaceItem1, emptySpaceItem2, emptySpaceItem3, emptySpaceItem4, emptySpaceItem8, emptySpaceItem5, emptySpaceItem6, emptySpaceItem7, emptySpaceItem1, emptySpaceItem2, emptySpaceItem9, emptySpaceItem3, emptySpaceItem4 … |
| TextBox | 14 | txtRequestNo, txtTitle, txtRequestor, txtRequestDeptName, txtAppDeptName, txtReasonDetail, txtApproval, txtRequestNo, txtTitle, txtRequestor, txtRequestDeptName, txtAppDeptName, txtReasonDetail, txtApproval |
| SimpleButton | 11 | btnChangeRe, btnDel, btnCancel, btnSave, btnAdd, btnChangeRe2, btnChangeRe, btnDel, btnCancel, btnSave, btnAdd |
| LayoutControlGroup | 10 | layoutControlGroup1, layoutControlGroup2, Root, layoutControlGroup1, layoutControlGroup1, layoutControlGroup2, layoutControlGroup3, layoutControlGroup1, layoutControlGroup2, layoutControlGroup3 |
| UsrLayoutControl | 9 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl1, usrLayoutControl2, usrLayoutControl3, usrLayoutControl1, usrLayoutControl2, usrLayoutControl3 |
| FpSpread | 6 | spdMain, spdMain, spdMain, spdSub, spdMain, spdSub |
| SheetView | 6 | spdMain_Sheet1, spdMain_Sheet1, spdMain_Sheet1, spdSub_Sheet1, spdMain_Sheet1, spdSub_Sheet1 |
| UsrMultiLineEditor | 6 | txtSoNo, txtRequest, txtItemId, txtSoNo, txtRequest, txtItemId |
| UsrCheckedList | 5 | clbDivision, clbFromSite, clbToSite, clbDivision, clbFromSite |
| UsrButton | 5 | btnItemId, btnNew, btnApprovalUser, btnItemId, btnApprovalUser |
| UsrConditionPanel | 4 | usrConditionPanel1, usrConditionPanel1, usrConditionPanel1, usrConditionPanel1 |
| Panel | 4 | panel3, panel1, panel3, panel1 |
| ImageList | 3 | imageList1, imageList1, imageList1 |
| UsrCombo | 3 | cboStatus, cboChangeType, cboStatus |
| UsrButtonList | 2 | btnButtonList, btnButtonList |
| SplitContainer | 2 | splitContainer1, splitContainer1 |
| UsrDateRangePicker | 2 | drpPeriod, drpPeriod |
| UsrDatePicker | 2 | dtDate, dtDate |
| UsrComboBox | 2 | cboChangeReason, cboChangeReason |
| UsrLabel | 2 | usrLabel2, usrLabel2 |
| UsrTextBox | 1 | txtSearch |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 39 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL | 1 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL_H | 3 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL_H.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 93 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 99 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 12 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 830 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (3건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 1450 | SCP.SCM0001_GET_SCP_DAY_PERIOD | commented:MATCH |
| 2532 | SCP.GET_DATE_RANGE_1MONTH | commented:MATCH |
| 1897 | SCP.GET_DATE_RANGE_1MONTH | commented:MATCH |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SSP0002 | Change Request | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 |
| SCM_MST_SHEET_COLUMNS | SSP0002 | Shipment Change Request | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 | 26/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Shipment Confirm, UserInfo, Shipment Change Request, Change Request, Change Request SO
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:407, SetSheetHeaderColumn@InitSpread:476, SetSheetHeaderColumn@InitSpread:305, SetSheetHeaderColumn@InitSpread:350

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 204 | 하드코딩 | AddComboColumn | Div* | DIVISION_ID |  |
| InitSpread |  | 205 | 하드코딩 | AddComboColumn | From Site* | FROM_SITE |  |
| InitSpread |  | 206 | 하드코딩 | AddComboColumn | To Site* | TO_SITE |  |
| InitSpread |  | 207 | 하드코딩 | AddComboColumn | End Customer* | PROJECT_CODE40 |  |
| InitSpread |  | 208 | 하드코딩 | AddTextColumn | Project | PROJECT_CODE |  |
| InitSpread |  | 209 | 하드코딩 | AddComboColumn | FCST Type*  | FCST_TYPE |  |
| InitSpread |  | 210 | 하드코딩 | AddComboColumn | Model* | ITEM_ID |  |
| InitSpread |  | 211 | 하드코딩 | AddComboColumn | Operation Group* | OPERATION_GROUP |  |
| InitSpread |  | 212 | 하드코딩 | AddTextColumn | Nick Name | NICK_NAME |  |
| InitSpread |  | 213 | 하드코딩 | AddDateColumn | Shipment Date* | SHIPMENT_DATE |  |
| InitSpread |  | 214 | 하드코딩 | AddNumColumn | Qty*  | SHIPMENT_QTY |  |
| InitSpread |  | 215 | 하드코딩 | AddComboColumn | Incoterms* | INCOTERMS |  |
| InitSpread |  | 216 | 하드코딩 | AddComboColumn | Trans Mode*  | TRANSPORT_MODE |  |
| InitSpread |  | 217 | 하드코딩 | AddNumColumn | L/T(Day) | LT |  |
| InitSpread |  | 218 | 하드코딩 | AddDateColumn | ETD | ETD |  |
| InitSpread |  | 219 | 하드코딩 | AddDateColumn | ETA | ETA |  |
| InitSpread |  | 221 | 하드코딩 | AddTextColumn | ROUTE_ID | ROUTE_ID |  |
| InitSpread |  | 222 | 하드코딩 | AddTextColumn | BOD_ID | BOD_ID |  |
| InitSpread |  | 223 | 하드코딩 | AddTextColumn | D_COUNTRY | D_COUNTRY |  |
| InitSpread |  | 224 | 하드코딩 | AddTextColumn | D_PORT_CODE | D_PORT_CODE |  |
| InitSpread |  | 225 | 하드코딩 | AddTextColumn | A_COUNTRY | A_COUNTRY |  |
| InitSpread |  | 226 | 하드코딩 | AddTextColumn | A_PORT_CODE | A_PORT_CODE |  |
| InitSpread |  | 227 | 하드코딩 | AddTextColumn | TO_COUNTRY | TO_COUNTRY |  |
| InitSpread |  | 228 | 하드코딩 | AddTextColumn | TO_CITY | TO_CITY |  |
| InitSpread |  | 230 | 하드코딩 | AddTextColumn | ELECTRODE_YN | ELECTRODE_YN |  |
| InitSpread |  | 231 | 하드코딩 | AddTextColumn | ORIGIN_FROM_DIVISION_ID | ORIGIN_FROM_DIVISION_ID |  |
| InitSpread |  | 232 | 하드코딩 | AddTextColumn | ORIGIN_TO_DIVISION_ID | ORIGIN_TO_DIVISION_ID |  |
| InitSpread |  | 240 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PROJECT_CODE40 |  |
| SpdMain_ComboSelChange |  | 806 | 표시/라벨 변경 | set:Visible | Visible = {?true} | PROJECT_CODE40 | if(e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ⟫ if(sDivisionID != "EE") ⟫ if(sDivisionID == "40") |
| SpdMain_ComboSelChange |  | 807 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PROJECT_CODE | if(e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ⟫ if(sDivisionID != "EE") ⟫ if(sDivisionID == "40") |
| SpdMain_ComboSelChange |  | 811 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PROJECT_CODE40 | if(e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ⟫ if(sDivisionID != "EE") ⟫ else!(sDivisionID == "40") |
| SpdMain_ComboSelChange |  | 812 | 표시/라벨 변경 | set:Visible | Visible = {?true} | PROJECT_CODE | if(e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ⟫ if(sDivisionID != "EE") ⟫ else!(sDivisionID == "40") |
| SpdMain_ComboSelChange |  | 823 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PROJECT_CODE40 | if(e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ⟫ else!(sDivisionID != "EE") |
| SpdMain_ComboSelChange |  | 824 | 표시/라벨 변경 | set:Visible | Visible = {?true} | PROJECT_CODE | if(e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ⟫ else!(sDivisionID != "EE") |
| SpdMain_ComboSelChange |  | 902 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PROJECT_CODE40 | else!(e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ⟫ if(e.Column == siMain.GetColumnIndex("FROM_SITE")) ⟫ if(dtOriginDivFromTo.Rows[0]["OPERATION_GROUP"].ToString() == "E") |
| SpdMain_ComboSelChange |  | 903 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PROJECT_CODE | else!(e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ⟫ if(e.Column == siMain.GetColumnIndex("FROM_SITE")) ⟫ if(dtOriginDivFromTo.Rows[0]["OPERATION_GROUP"].ToString() == "E") |
| SpdMain_ComboSelChange |  | 904 | 표시/라벨 변경 | set:Visible | Visible = {?false} | FCST_TYPE | else!(e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ⟫ if(e.Column == siMain.GetColumnIndex("FROM_SITE")) ⟫ if(dtOriginDivFromTo.Rows[0]["OPERATION_GROUP"].ToString() == "E") |
| SpdMain_ComboSelChange |  | 918 | 표시/라벨 변경 | set:Visible | Visible = {?true} | PROJECT_CODE40 | else!(e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ⟫ if(e.Column == siMain.GetColumnIndex("FROM_SITE")) ⟫ else!(dtOriginDivFromTo.Rows[0]["OPERATION_GROUP"].ToString() == "E") ⟫ if(sDivisionID == "40") |
| SpdMain_ComboSelChange |  | 919 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PROJECT_CODE | else!(e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ⟫ if(e.Column == siMain.GetColumnIndex("FROM_SITE")) ⟫ else!(dtOriginDivFromTo.Rows[0]["OPERATION_GROUP"].ToString() == "E") ⟫ if(sDivisionID == "40") |
| SpdMain_ComboSelChange |  | 920 | 표시/라벨 변경 | set:Visible | Visible = {?true} | FCST_TYPE | else!(e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ⟫ if(e.Column == siMain.GetColumnIndex("FROM_SITE")) ⟫ else!(dtOriginDivFromTo.Rows[0]["OPERATION_GROUP"].ToString() == "E") ⟫ if(sDivisionID == "40") |
| SpdMain_ComboSelChange |  | 924 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PROJECT_CODE40 | else!(e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ⟫ if(e.Column == siMain.GetColumnIndex("FROM_SITE")) ⟫ else!(dtOriginDivFromTo.Rows[0]["OPERATION_GROUP"].ToString() == "E") ⟫ else!(sDivisionID == "40") |
| SpdMain_ComboSelChange |  | 925 | 표시/라벨 변경 | set:Visible | Visible = {?true} | PROJECT_CODE | else!(e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ⟫ if(e.Column == siMain.GetColumnIndex("FROM_SITE")) ⟫ else!(dtOriginDivFromTo.Rows[0]["OPERATION_GROUP"].ToString() == "E") ⟫ else!(sDivisionID == "40") |
| SpdMain_ComboSelChange |  | 926 | 표시/라벨 변경 | set:Visible | Visible = {?true} | FCST_TYPE | else!(e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ⟫ if(e.Column == siMain.GetColumnIndex("FROM_SITE")) ⟫ else!(dtOriginDivFromTo.Rows[0]["OPERATION_GROUP"].ToString() == "E") ⟫ else!(sDivisionID == "40") |
| SpdMain_ComboSelChange |  | 954 | 표시/라벨 변경 | set:Visible | Visible = {?true} | FCST_TYPE | else!(e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ⟫ else!(e.Column == siMain.GetColumnIndex("FROM_SITE")) ⟫ if(e.Column == siMain.GetColumnIndex("TO_SITE")) ⟫ if(dtOriginDivFromTo.Rows.Count > 0) ⟫ if(siMain.GetValue(e.Row, siMain.GetColumnIndex("OPERATION_GROUP")).ToString() == "E") ⟫ if(!PlantSiteChk()) |
| SpdMain_ComboSelChange |  | 958 | 표시/라벨 변경 | set:Visible | Visible = {?true} | PROJECT_CODE40 | else!(e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ⟫ else!(e.Column == siMain.GetColumnIndex("FROM_SITE")) ⟫ if(e.Column == siMain.GetColumnIndex("TO_SITE")) ⟫ if(dtOriginDivFromTo.Rows.Count > 0) ⟫ if(siMain.GetValue(e.Row, siMain.GetColumnIndex("OPERATION_GROUP")).ToString() == "E") ⟫ if(!PlantSiteChk()) ⟫ if(sDivisionID == "40") |
| SpdMain_ComboSelChange |  | 959 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PROJECT_CODE | else!(e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ⟫ else!(e.Column == siMain.GetColumnIndex("FROM_SITE")) ⟫ if(e.Column == siMain.GetColumnIndex("TO_SITE")) ⟫ if(dtOriginDivFromTo.Rows.Count > 0) ⟫ if(siMain.GetValue(e.Row, siMain.GetColumnIndex("OPERATION_GROUP")).ToString() == "E") ⟫ if(!PlantSiteChk()) ⟫ if(sDivisionID == "40") |
| SpdMain_ComboSelChange |  | 963 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PROJECT_CODE40 | else!(e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ⟫ else!(e.Column == siMain.GetColumnIndex("FROM_SITE")) ⟫ if(e.Column == siMain.GetColumnIndex("TO_SITE")) ⟫ if(dtOriginDivFromTo.Rows.Count > 0) ⟫ if(siMain.GetValue(e.Row, siMain.GetColumnIndex("OPERATION_GROUP")).ToString() == "E") ⟫ if(!PlantSiteChk()) ⟫ else!(sDivisionID == "40") |
| SpdMain_ComboSelChange |  | 964 | 표시/라벨 변경 | set:Visible | Visible = {?true} | PROJECT_CODE | else!(e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ⟫ else!(e.Column == siMain.GetColumnIndex("FROM_SITE")) ⟫ if(e.Column == siMain.GetColumnIndex("TO_SITE")) ⟫ if(dtOriginDivFromTo.Rows.Count > 0) ⟫ if(siMain.GetValue(e.Row, siMain.GetColumnIndex("OPERATION_GROUP")).ToString() == "E") ⟫ if(!PlantSiteChk()) ⟫ else!(sDivisionID == "40") |
| SpdMain_ClipboardPasted |  | 1099 | 표시/라벨 변경 | set:Visible | Visible = {?true} | PROJECT_CODE40 | if(siMain.IsLock(siMain.SheetName) == false) ⟫ if(siMain.ActiveSheet.SheetName == "Shipment Confirm") ⟫ for(iRow < e.CellRange.Row + e.CellRange.RowCount) ⟫ for(iCol < e.CellRange.Column + e.CellRange.ColumnCount) ⟫ if(siMain.ActiveSheet.Cells[iRow, iCol].Text != "") ⟫ if(iCol == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ⟫ if(sDivisionID != "EE") ⟫ if(sDivisionID == "40") |
| SpdMain_ClipboardPasted |  | 1100 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PROJECT_CODE | if(siMain.IsLock(siMain.SheetName) == false) ⟫ if(siMain.ActiveSheet.SheetName == "Shipment Confirm") ⟫ for(iRow < e.CellRange.Row + e.CellRange.RowCount) ⟫ for(iCol < e.CellRange.Column + e.CellRange.ColumnCount) ⟫ if(siMain.ActiveSheet.Cells[iRow, iCol].Text != "") ⟫ if(iCol == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ⟫ if(sDivisionID != "EE") ⟫ if(sDivisionID == "40") |
| SpdMain_ClipboardPasted |  | 1104 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PROJECT_CODE40 | if(siMain.IsLock(siMain.SheetName) == false) ⟫ if(siMain.ActiveSheet.SheetName == "Shipment Confirm") ⟫ for(iRow < e.CellRange.Row + e.CellRange.RowCount) ⟫ for(iCol < e.CellRange.Column + e.CellRange.ColumnCount) ⟫ if(siMain.ActiveSheet.Cells[iRow, iCol].Text != "") ⟫ if(iCol == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ⟫ if(sDivisionID != "EE") ⟫ else!(sDivisionID == "40") |
| SpdMain_ClipboardPasted |  | 1105 | 표시/라벨 변경 | set:Visible | Visible = {?true} | PROJECT_CODE | if(siMain.IsLock(siMain.SheetName) == false) ⟫ if(siMain.ActiveSheet.SheetName == "Shipment Confirm") ⟫ for(iRow < e.CellRange.Row + e.CellRange.RowCount) ⟫ for(iCol < e.CellRange.Column + e.CellRange.ColumnCount) ⟫ if(siMain.ActiveSheet.Cells[iRow, iCol].Text != "") ⟫ if(iCol == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ⟫ if(sDivisionID != "EE") ⟫ else!(sDivisionID == "40") |
| SpdMain_ClipboardPasted |  | 1116 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PROJECT_CODE40 | if(siMain.IsLock(siMain.SheetName) == false) ⟫ if(siMain.ActiveSheet.SheetName == "Shipment Confirm") ⟫ for(iRow < e.CellRange.Row + e.CellRange.RowCount) ⟫ for(iCol < e.CellRange.Column + e.CellRange.ColumnCount) ⟫ if(siMain.ActiveSheet.Cells[iRow, iCol].Text != "") ⟫ if(iCol == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ⟫ else!(sDivisionID != "EE") |
| SpdMain_ClipboardPasted |  | 1117 | 표시/라벨 변경 | set:Visible | Visible = {?true} | PROJECT_CODE | if(siMain.IsLock(siMain.SheetName) == false) ⟫ if(siMain.ActiveSheet.SheetName == "Shipment Confirm") ⟫ for(iRow < e.CellRange.Row + e.CellRange.RowCount) ⟫ for(iCol < e.CellRange.Column + e.CellRange.ColumnCount) ⟫ if(siMain.ActiveSheet.Cells[iRow, iCol].Text != "") ⟫ if(iCol == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ⟫ else!(sDivisionID != "EE") |
| SpdMain_ClipboardPasted |  | 1227 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PROJECT_CODE40 | if(siMain.IsLock(siMain.SheetName) == false) ⟫ if(siMain.ActiveSheet.SheetName == "Shipment Confirm") ⟫ for(iRow < e.CellRange.Row + e.CellRange.RowCount) ⟫ for(iCol < e.CellRange.Column + e.CellRange.ColumnCount) ⟫ if(siMain.ActiveSheet.Cells[iRow, iCol].Text != "") ⟫ else!(iCol == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ⟫ else!(iCol == siMain.GetColumnIndex("INCOTERMS")) ⟫ else!(iCol == siMain.GetColumnIndex("TRANSPORT_MODE")) ⟫ if(iCol == siMain.GetColumnIndex("FROM_SITE")) ⟫ if(siMain.GetValue(iRow, siMain.GetColumnIndex("OPERATION_GROUP")).ToString() == "E") |
| SpdMain_ClipboardPasted |  | 1228 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PROJECT_CODE | if(siMain.IsLock(siMain.SheetName) == false) ⟫ if(siMain.ActiveSheet.SheetName == "Shipment Confirm") ⟫ for(iRow < e.CellRange.Row + e.CellRange.RowCount) ⟫ for(iCol < e.CellRange.Column + e.CellRange.ColumnCount) ⟫ if(siMain.ActiveSheet.Cells[iRow, iCol].Text != "") ⟫ else!(iCol == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ⟫ else!(iCol == siMain.GetColumnIndex("INCOTERMS")) ⟫ else!(iCol == siMain.GetColumnIndex("TRANSPORT_MODE")) ⟫ if(iCol == siMain.GetColumnIndex("FROM_SITE")) ⟫ if(siMain.GetValue(iRow, siMain.GetColumnIndex("OPERATION_GROUP")).ToString() == "E") |
| SpdMain_ClipboardPasted |  | 1229 | 표시/라벨 변경 | set:Visible | Visible = {?false} | FCST_TYPE | if(siMain.IsLock(siMain.SheetName) == false) ⟫ if(siMain.ActiveSheet.SheetName == "Shipment Confirm") ⟫ for(iRow < e.CellRange.Row + e.CellRange.RowCount) ⟫ for(iCol < e.CellRange.Column + e.CellRange.ColumnCount) ⟫ if(siMain.ActiveSheet.Cells[iRow, iCol].Text != "") ⟫ else!(iCol == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ⟫ else!(iCol == siMain.GetColumnIndex("INCOTERMS")) ⟫ else!(iCol == siMain.GetColumnIndex("TRANSPORT_MODE")) ⟫ if(iCol == siMain.GetColumnIndex("FROM_SITE")) ⟫ if(siMain.GetValue(iRow, siMain.GetColumnIndex("OPERATION_GROUP")).ToString() == "E") |
| SpdMain_ClipboardPasted |  | 1243 | 표시/라벨 변경 | set:Visible | Visible = {?true} | PROJECT_CODE40 | if(siMain.IsLock(siMain.SheetName) == false) ⟫ if(siMain.ActiveSheet.SheetName == "Shipment Confirm") ⟫ for(iRow < e.CellRange.Row + e.CellRange.RowCount) ⟫ for(iCol < e.CellRange.Column + e.CellRange.ColumnCount) ⟫ if(siMain.ActiveSheet.Cells[iRow, iCol].Text != "") ⟫ else!(iCol == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ⟫ else!(iCol == siMain.GetColumnIndex("INCOTERMS")) ⟫ else!(iCol == siMain.GetColumnIndex("TRANSPORT_MODE")) ⟫ if(iCol == siMain.GetColumnIndex("FROM_SITE")) ⟫ else!(siMain.GetValue(iRow, siMain.GetColumnIndex("OPERATION_GROUP")).ToString() == "E") ⟫ if(sDivisionID == "40") |
| SpdMain_ClipboardPasted |  | 1244 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PROJECT_CODE | if(siMain.IsLock(siMain.SheetName) == false) ⟫ if(siMain.ActiveSheet.SheetName == "Shipment Confirm") ⟫ for(iRow < e.CellRange.Row + e.CellRange.RowCount) ⟫ for(iCol < e.CellRange.Column + e.CellRange.ColumnCount) ⟫ if(siMain.ActiveSheet.Cells[iRow, iCol].Text != "") ⟫ else!(iCol == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ⟫ else!(iCol == siMain.GetColumnIndex("INCOTERMS")) ⟫ else!(iCol == siMain.GetColumnIndex("TRANSPORT_MODE")) ⟫ if(iCol == siMain.GetColumnIndex("FROM_SITE")) ⟫ else!(siMain.GetValue(iRow, siMain.GetColumnIndex("OPERATION_GROUP")).ToString() == "E") ⟫ if(sDivisionID == "40") |
| SpdMain_ClipboardPasted |  | 1245 | 표시/라벨 변경 | set:Visible | Visible = {?true} | FCST_TYPE | if(siMain.IsLock(siMain.SheetName) == false) ⟫ if(siMain.ActiveSheet.SheetName == "Shipment Confirm") ⟫ for(iRow < e.CellRange.Row + e.CellRange.RowCount) ⟫ for(iCol < e.CellRange.Column + e.CellRange.ColumnCount) ⟫ if(siMain.ActiveSheet.Cells[iRow, iCol].Text != "") ⟫ else!(iCol == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ⟫ else!(iCol == siMain.GetColumnIndex("INCOTERMS")) ⟫ else!(iCol == siMain.GetColumnIndex("TRANSPORT_MODE")) ⟫ if(iCol == siMain.GetColumnIndex("FROM_SITE")) ⟫ else!(siMain.GetValue(iRow, siMain.GetColumnIndex("OPERATION_GROUP")).ToString() == "E") ⟫ if(sDivisionID == "40") |
| SpdMain_ClipboardPasted |  | 1249 | 표시/라벨 변경 | set:Visible | Visible = {?false} | PROJECT_CODE40 | if(siMain.IsLock(siMain.SheetName) == false) ⟫ if(siMain.ActiveSheet.SheetName == "Shipment Confirm") ⟫ for(iRow < e.CellRange.Row + e.CellRange.RowCount) ⟫ for(iCol < e.CellRange.Column + e.CellRange.ColumnCount) ⟫ if(siMain.ActiveSheet.Cells[iRow, iCol].Text != "") ⟫ else!(iCol == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ⟫ else!(iCol == siMain.GetColumnIndex("INCOTERMS")) ⟫ else!(iCol == siMain.GetColumnIndex("TRANSPORT_MODE")) ⟫ if(iCol == siMain.GetColumnIndex("FROM_SITE")) ⟫ else!(siMain.GetValue(iRow, siMain.GetColumnIndex("OPERATION_GROUP")).ToString() == "E") ⟫ else!(sDivisionID == "40") |
| SpdMain_ClipboardPasted |  | 1250 | 표시/라벨 변경 | set:Visible | Visible = {?true} | PROJECT_CODE | if(siMain.IsLock(siMain.SheetName) == false) ⟫ if(siMain.ActiveSheet.SheetName == "Shipment Confirm") ⟫ for(iRow < e.CellRange.Row + e.CellRange.RowCount) ⟫ for(iCol < e.CellRange.Column + e.CellRange.ColumnCount) ⟫ if(siMain.ActiveSheet.Cells[iRow, iCol].Text != "") ⟫ else!(iCol == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ⟫ else!(iCol == siMain.GetColumnIndex("INCOTERMS")) ⟫ else!(iCol == siMain.GetColumnIndex("TRANSPORT_MODE")) ⟫ if(iCol == siMain.GetColumnIndex("FROM_SITE")) ⟫ else!(siMain.GetValue(iRow, siMain.GetColumnIndex("OPERATION_GROUP")).ToString() == "E") ⟫ else!(sDivisionID == "40") |
| SpdMain_ClipboardPasted |  | 1251 | 표시/라벨 변경 | set:Visible | Visible = {?true} | FCST_TYPE | if(siMain.IsLock(siMain.SheetName) == false) ⟫ if(siMain.ActiveSheet.SheetName == "Shipment Confirm") ⟫ for(iRow < e.CellRange.Row + e.CellRange.RowCount) ⟫ for(iCol < e.CellRange.Column + e.CellRange.ColumnCount) ⟫ if(siMain.ActiveSheet.Cells[iRow, iCol].Text != "") ⟫ else!(iCol == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ⟫ else!(iCol == siMain.GetColumnIndex("INCOTERMS")) ⟫ else!(iCol == siMain.GetColumnIndex("TRANSPORT_MODE")) ⟫ if(iCol == siMain.GetColumnIndex("FROM_SITE")) ⟫ else!(siMain.GetValue(iRow, siMain.GetColumnIndex("OPERATION_GROUP")).ToString() == "E") ⟫ else!(sDivisionID == "40") |
| InitializeComponent |  | 222 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 223 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 224 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 225 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread |  | 140 | 하드코딩 | AddTextColumn | UserID | UserID |  |
| InitSpread |  | 141 | 하드코딩 | AddTextColumn | UserName | UserName |  |
| InitSpread |  | 142 | 하드코딩 | AddTextColumn | EnglishName | UserName_E |  |
| InitSpread |  | 144 | 하드코딩 | AddTextColumn | Email | Email | if(!SSOUserYN && !SingleSelectYn) |
| InitSpread |  | 145 | 하드코딩 | AddTextColumn | Dept_ID | Dept_ID |  |
| InitSpread |  | 146 | 하드코딩 | AddTextColumn | Dept_Name | Dept_Name |  |
| InitSpread |  | 148 | 하드코딩 | AddComboColumn | UseYN | UseYN | if(!SSOUserYN && !SingleSelectYn) |
| SpdMain_CellClick |  | 221 | 표시/라벨 변경 | set:Value | Value = {?false} |  | if(siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ⟫ if(siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType.GetType() == typeof(FarPoint.Win.Spread.CellType.CheckBoxCell…) ⟫ for(iRow < siMain.ActiveSheet.RowCount) ⟫ if(Convert.ToBoolean(siMain.ActiveSheet.GetValue("0", e.Column))) |
| SpdMain_CellClick |  | 226 | 표시/라벨 변경 | set:Value | Value = {?true} |  | if(siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ⟫ if(siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType.GetType() == typeof(FarPoint.Win.Spread.CellType.CheckBoxCell…) ⟫ for(iRow < siMain.ActiveSheet.RowCount) ⟫ else!(Convert.ToBoolean(siMain.ActiveSheet.GetValue("0", e.Column))) |
| InitializeComponent |  | 162 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 163 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 164 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 165 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread |  | 359 | 표시/라벨 변경 | set:CellType | CellType = {?chk} | CHK | if(spreadInfo.SheetName == "Change Request SO") |
| InitSpread |  | 360 | 표시/라벨 변경 | set:Value | Value = {?false} | CHK | if(spreadInfo.SheetName == "Change Request SO") |
| InitSpread |  | 361 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | CHK | if(spreadInfo.SheetName == "Change Request SO") |
| SetChangeRequestSOGrid |  | 1033 | 표시/라벨 변경 | set:Visible | Visible = {?false} | {?CAppSetting.StringAction} | for(i < siSub.ActiveSheet.RowCount) |
| SetChangeRequestSOGrid |  | 1052 | 표시/라벨 변경 | set:Visible | Visible = {?false} | CHK | for(i < siSub.ActiveSheet.RowCount) ⟫ else!(sShipStatus == "R") ⟫ if(sSearchType == "Exist") |
| InitializeComponent |  | 204 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 205 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 206 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 207 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 697 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 698 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 699 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 700 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread |  | 415 | 표시/라벨 변경 | set:Width | Width = 0 | ERP_SO_NO | if(spreadInfo.SheetName == "Shipment Change Request") ⟫ if(cboChangeType.SelectedValue.ToString() == "P") |
| InitSpread |  | 416 | 표시/라벨 변경 | set:Width | Width = 0 | CONFIRM_ID | if(spreadInfo.SheetName == "Shipment Change Request") ⟫ if(cboChangeType.SelectedValue.ToString() == "P") |
| InitSpread |  | 426 | 표시/라벨 변경 | set:Width | Width = 100 | ERP_SO_NO | if(spreadInfo.SheetName == "Shipment Change Request") ⟫ else!(cboChangeType.SelectedValue.ToString() == "P") |
| InitSpread |  | 427 | 표시/라벨 변경 | set:Width | Width = 120 | CONFIRM_ID | if(spreadInfo.SheetName == "Shipment Change Request") ⟫ else!(cboChangeType.SelectedValue.ToString() == "P") |
| InitSpread |  | 485 | 표시/라벨 변경 | set:CellType | CellType = {?chk} | CHK | if(spreadInfo.SheetName == "Change Request") |
| InitSpread |  | 486 | 표시/라벨 변경 | set:Value | Value = {?false} | CHK | if(spreadInfo.SheetName == "Change Request") |
| InitSpread |  | 487 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | CHK | if(spreadInfo.SheetName == "Change Request") |
| InitSpread |  | 496 | 표시/라벨 변경 | set:Width | Width = 0 | REMARKS | if(spreadInfo.SheetName == "Change Request") |
| InitSpread |  | 501 | 표시/라벨 변경 | set:Visible | Visible = {?false} | ERP_SO_NO | if(spreadInfo.SheetName == "Change Request") ⟫ if(cboChangeType.SelectedValue.ToString() == "P") |
| InitSpread |  | 523 | 표시/라벨 변경 | set:Visible | Visible = {?true} | ERP_SO_NO | if(spreadInfo.SheetName == "Change Request") ⟫ else!(cboChangeType.SelectedValue.ToString() == "P") |
| FindData_Sub |  | 876 | 표시/라벨 변경 | SetColumnLabel | 0 | REMARKS2 | if(electrodeYn =="Y") |
| SetChangeRequestSOGrid |  | 1375 | 표시/라벨 변경 | set:Visible | Visible = {?false} | {?CAppSetting.StringAction} | for(i < siSub.ActiveSheet.RowCount) |
| SetChangeRequestSOGrid |  | 1394 | 표시/라벨 변경 | set:Visible | Visible = {?false} | CHK | for(i < siSub.ActiveSheet.RowCount) ⟫ else!(sShipStatus == "R") ⟫ if(sSearchType == "Exist") |
| InitializeComponent |  | 216 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 217 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 218 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 219 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 857 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 858 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 859 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 860 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Change Request | META+코드연결 | 22 (?2) | 22 (?2) | 22 (?2) | 22 (?2) | 22 (?2) | 22 (?2) | 22 (?2) | 22 (?2) | 22 (?2) | 22 (?2) | 22 (?2) | 22 (?2) | 22 (?2) | 22 (?2) |
| Change Request SO | 코드 시트, 컬럼 미확인(DB루프/동적) | 0 (?1) | 0 (?1) | 0 (?1) | 0 (?1) | 0 (?1) | 0 (?1) | 0 (?1) | 0 (?1) | 0 (?1) | 0 (?1) | 0 (?1) | 0 (?1) | 0 (?1) | 0 (?1) |
| Shipment Change Request | META+코드연결 | 26 (?1) | 26 (?1) | 26 (?1) | 26 (?1) | 26 (?1) | 26 (?1) | 26 (?1) | 26 (?1) | 26 (?1) | 26 (?1) | 26 (?1) | 26 (?1) | 26 (?1) | 26 (?1) |
| Shipment Confirm | 코드 하드코딩 전용(메타 없음) | 26 (?3) | 26 (?3) | 26 (?3) | 26 (?3) | 26 (?3) | 26 (?3) | 26 (?3) | 26 (?3) | 26 (?3) | 26 (?3) | 26 (?3) | 26 (?3) | 26 (?3) | 26 (?3) |
| UserInfo | 코드 하드코딩 전용(메타 없음) | 7 (?2) | 7 (?2) | 7 (?2) | 7 (?2) | 7 (?2) | 7 (?2) | 7 (?2) | 7 (?2) | 7 (?2) | 7 (?2) | 7 (?2) | 7 (?2) | 7 (?2) | 7 (?2) |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
판단불가(?) 분류: 런타임:컬럼별 루프/태그 판정 224, 런타임:조회데이터 56, 정적평가 미지원식 28, 런타임:화면컨트롤값 28 — 런타임 분류는 실행 시점에만 결정되는 정상 동적 분기, '미지원식'만 파서 보완 대상.
분기 조건 판단불가 적용 336건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
