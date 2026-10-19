# FP00461 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.FP.Master.UIL\FP00461_PackWorker_Master.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 1424 |
| only | 06.UIL\GSCM.FP.Master.UIL\FP00461_PackWorker_Master.designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 1096 |
| only | 06.UIL\GSCM.FP.Master.UIL\POPUP\FP00461_ExcelPopup.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 839 |
| only | 06.UIL\GSCM.FP.Master.UIL\POPUP\FP00461_ExcelPopup.designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 509 |
| only | 06.UIL\GSCM.FP.Master.UIL\POPUP\FP00461_PackWorkerAddPopup.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 463 |
| only | 06.UIL\GSCM.FP.Master.UIL\POPUP\FP00461_PackWorkerAddPopup.Designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 445 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboOperation.SelectedIndexChanged | cboOperation_changed > GetLine | 287 | biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | CboSite_SelectedIndexChanged > GetPlant | 246 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | cboSite_changed > GetPlant | 256 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > GetPlant | 246 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | clbDivision_changed > GetPlant | 256 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:clbFactory.SelectedIndexChanged | clbBuilding_changed > GetOperation | 275 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | cblPlant_changed > GetFactory | 264 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE] | BIZ_MATCH |  |
| event:dpDate.ValueChanged | DpDate_ValueChanged > GetDate | 300 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findWeekFirstDay] | BIZ_MATCH |  |
| event:dpDate.ValueChanged | DpDate_ValueChanged > GetDate | 300 | FP\Master\FP00461_PackWorker#findWeekFirstDay | MATCH | [sql] foxquery_sql\FP_Master_FP00461_PackWorker_findWeekFirstDay.sql |
| button:FindButton | FindButton > UIFindData > FindData | 1015 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findBucketList] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindData | 1015 | FP\Master\FP00461_PackWorker#findBucketList | MATCH | [sql] foxquery_sql\FP_Master_FP00461_PackWorker_findBucketList.sql |
| event:p.DoSaveData | FP00180_SaveDataDelegate | 1115 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP00461] | BIZ_MATCH |  |
| event:p.DoSaveData | FP00180_SaveDataDelegate | 1115 | FP\MASTER\FP00461_PackWorker#merge_FP00461 | MATCH | [update-batch]  |
| event:p.DoSearchData | FP00180_SearchDataDelegate > FindData | 1015 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findBucketList] | BIZ_MATCH |  |
| event:p.DoSearchData | FP00180_SearchDataDelegate > FindData | 1015 | FP\Master\FP00461_PackWorker#findBucketList | MATCH | [sql] foxquery_sql\FP_Master_FP00461_PackWorker_findBucketList.sql |
| event:p.DoValidationData | FP00180_ValidateDataDelegate | 1133 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] | BIZ_MATCH |  |
| event:p.DoValidationData | FP00180_ValidateDataDelegate | 1133 | FP\MASTER\FP00461_PackWorker#delete_Excel_buffer | MATCH | [sql] foxquery_sql\FP_Master_FP00461_PackWorker_delete_excel_buffer.sql |
| event:p.DoValidationData | FP00180_ValidateDataDelegate | 1137 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] | BIZ_MATCH |  |
| event:p.DoValidationData | FP00180_ValidateDataDelegate | 1137 | FP\MASTER\FP00461_PackWorker#insert_Excel_buffer | MATCH | [update-batch]  |
| event:p.DoValidationData | FP00180_ValidateDataDelegate | 1141 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] | BIZ_MATCH |  |
| event:p.DoValidationData | FP00180_ValidateDataDelegate | 1141 | FP\MASTER\FP00461_PackWorker#find_Excel_buffer_validation | MATCH | [sql] foxquery_sql\FP_Master_FP00461_PackWorker_find_Excel_buffer_validation.sql |
| event:popSql.OnSql | RunSqlSource > FindData | 1015 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findBucketList] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindData | 1015 | FP\Master\FP00461_PackWorker#findBucketList | MATCH | [sql] foxquery_sql\FP_Master_FP00461_PackWorker_findBucketList.sql |
| button:SaveButton | SaveButton > Save_Data | 614 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=saveAll_FP00461] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > Save_Data | 614 | FP\Master\FP00461_PackWorker#saveAll_FP00461 | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > Save_Data | 759 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=saveAll_FP00461_sub] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > Save_Data | 759 | FP\Master\FP00461_PackWorker#saveAll_FP00461_sub | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > Save_Data > UIFindData > FindData | 1015 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findBucketList] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > Save_Data > UIFindData > FindData | 1015 | FP\Master\FP00461_PackWorker#findBucketList | MATCH | [sql] foxquery_sql\FP_Master_FP00461_PackWorker_findBucketList.sql |
| event:this.btnUpload.Click | btnExcelImport_Click > UIFindData > FindData | 1015 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findBucketList] | BIZ_MATCH |  |
| event:this.btnUpload.Click | btnExcelImport_Click > UIFindData > FindData | 1015 | FP\Master\FP00461_PackWorker#findBucketList | MATCH | [sql] foxquery_sql\FP_Master_FP00461_PackWorker_findBucketList.sql |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged | 397 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:this.clbDivision.SelectedIndexChanged | clbDivision_SelectedIndexChanged | 405 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetDivision | 230 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetSite | 237 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > InitComponents > GetDivision | 240 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetPlant | 246 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > InitComponents > GetSite | 247 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > InitComponents > GetPlant | 256 | biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > InitComponents > GetFactory | 264 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > InitComponents > GetOperation | 275 | biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > InitComponents > GetLine | 287 | biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > InitComponents > GetDate | 300 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findWeekFirstDay] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > InitComponents > GetDate | 300 | FP\Master\FP00461_PackWorker#findWeekFirstDay | MATCH | [sql] foxquery_sql\FP_Master_FP00461_PackWorker_findWeekFirstDay.sql |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 76 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | FindAttribute | 974 | FP_Master.PR_UI_FP00180_FINDATTRIBUTE | MATCH | SP PR_UI_FP00180_FINDATTRIBUTE |
| unreached:(진입점 미연결) | FindFormAttribute | 994 | FP_Master.PR_UI_FP00180_FINDFORMATTRIBUTE | MATCH | SP PR_UI_FP00180_FINDFORMATTRIBUTE |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList_SCP:REF:FN_GET_DIVISION |
| biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_LINE_M_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:REF:STRING_SPLIT, UP_FX_GetCommonDataList_FP:SELECT:SCM_SYS_LOOKUP_VALUE_SN |
| biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList_FP:SELECT:SCM_OPERATION_M_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_USER_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:TH_UIS_ROLE_FACTORY_RELATE_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_MMD_OPERATION_GROUP_M_SN, UP_FX_GetCommonDataList_FP:SELECT:SCM_LINE_M_SN, UP_FX_GetCommonDataList_FP:REF:STRING_SPLIT, UP_FX_GetCommonDataList_FP:SELECT:SCM_FACTORY_M_SN, UP_FX_GetCommonDataList_FP:SELECT:FP_INSTANCE_FACTORY_M_SN |
| biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | BIZ_MATCH | 3 |  |  | 코드분기 FN_GET_SSP_ANL_BOH_QTY:SELECT:SSP_PLN_PLANT_ONHAND, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_MST_PLANT_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_VENDOR, PR_SCM_DNM_EXFACTORY_RESULT_CUTOFF:SELECT:SCP_MST_BOD_N_V, FN_GET_SCP_ANL_BOH_QTY:SELECT:SCP_PLN_PLANT_ONHAND |
| biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH | 3 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findBucketList] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findWeekFirstDay] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP00461] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=saveAll_FP00461_sub] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=saveAll_FP00461] | BIZ_MATCH | 1 |  |  |  |
| FP_Master.PR_UI_FP00180_FINDATTRIBUTE | MATCH | 1 | SP PR_UI_FP00180_FINDATTRIBUTE | EXEC:PR_UI_FP00180_FINDATTRIBUTE | ⚠ DB에 SP 없음 |
| FP_Master.PR_UI_FP00180_FINDFORMATTRIBUTE | MATCH | 1 | SP PR_UI_FP00180_FINDFORMATTRIBUTE | EXEC:PR_UI_FP00180_FINDFORMATTRIBUTE | ⚠ DB에 SP 없음 |
| FP\MASTER\FP00461_PackWorker#delete_Excel_buffer | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP00461_PackWorker_delete_excel_buffer.sql | DELETE:BUF_PACK_WORKER_M |  |
| FP\MASTER\FP00461_PackWorker#find_Excel_buffer_validation | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP00461_PackWorker_find_Excel_buffer_validation.sql | SELECT:BUF_PACK_WORKER_M, SELECT:SCM_LINE_M, SELECT:SCM_ITEM_M, SELECT:SCM_ITEM_CLASS_M, SELECT:SCM_BOM_M, SELECT:SCM_OPERATION_M, SELECT:FP_USER_ROLE_INFO_V |  |
| FP\Master\FP00461_PackWorker#findBucketList | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP00461_PackWorker_findBucketList.sql | SELECT:TH_UIS_CAL |  |
| FP\Master\FP00461_PackWorker#findWeekFirstDay | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP00461_PackWorker_findWeekFirstDay.sql | SELECT:TH_UIS_CAL |  |
| FP\MASTER\FP00461_PackWorker#insert_Excel_buffer | MATCH | 1 | [update-batch]  |  |  |
| FP\MASTER\FP00461_PackWorker#merge_FP00461 | MATCH | 1 | [update-batch]  |  |  |
| FP\Master\FP00461_PackWorker#saveAll_FP00461 | MATCH | 1 | [update-batch]  |  |  |
| FP\Master\FP00461_PackWorker#saveAll_FP00461_sub | MATCH | 1 | [update-batch]  |  |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| btnExcelImport_Click | p.KeyColumns | Company_id, PLANT_ID, DIVISION_ID, site_id, ITEM_ID, FACTORY_ID, OPERATION_ID, LINE_ID |
| btnExcelImport_Click | p.ColumnTitle | Company_id, DIVISION_ID, PLANT_ID, site_id, ITEM_ID, FACTORY_ID, OPERATION_ID, LINE_ID, NICK_NAME, WORKER_QTY, MESSAGE |
| cblPlant_changed | Filter | PLANT_ID |
| cbo_active_SelectedIndexChanged | Filter | ACTIVE_FLAG |
| cboLine_changed | Filter | LINE_ID |
| cboOperation_changed | Filter | OPERATION_ID |
| cboSite_changed | Filter | SITE_ID |
| CboSite_SelectedIndexChanged | Filter | SITE_ID |
| clbBuilding_changed | Filter | FACTORY_ID |
| clbDivision_changed | Filter | DIVISION_ID |
| ClbDivision_SelectedIndexChanged | Filter | DIVISION_ID |
| ClbPlant_SelectedIndexChanged | Filter | PLANT_ID |
| DpDate_ValueChanged | Filter | BASIS_DATE |
| FindData | Filter | BUCKET_FROM, BUCKET_TO, BUCKETLIST, DAYLIST |
| FindData | row | VALUE |
| GetDate | row | VALUE, WEEK |
| GetFactory | Filter | DIVISION_ID, SITE_ID, PLANT_ID |
| GetLine | Filter | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID |
| GetOperation | Filter | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID |
| GetPlant | Filter | DIVISION_ID, SITE_ID |
| InitComponents | Filter | BUCKET_FROM, BUCKET_TO, BASIS_DATE, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID |
| InitControls | Filter | USER_ID, DIVISION_ID, SITE_ID, PLANT_ID |
| InsertButton | addPopup.Filter | DIVISION_ID, SITE_ID, PLANT_ID |
| Save_Data | ro | USER_ID |
| Save_Data | res.Rows[0] | RESULT, COUNT, EXCEPTION |
| Save_Data | siSub.ActiveSheet.Columns | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID |
| Save_Data | saved | WORKER_QTY, WORK_DATE, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, USER_ID |
| SaveToDB | dsMain.Tables[0].Rows[i] | USER_ID, JOB_ORDER |
| SaveToDB | eachRow | _VALID |
| SaveToDB | valrow | _VALID, _MSG |
| SaveToDB | xlsrow | MESSAGE |
| tbNickName_OnSearchConditionChanged | Filter | NICK_NAME, NICK_NAME_LT |
| txtMaterial_changed | Filter | ITEM_ID |
| UIFindData | dsMain.Tables[0].Columns | WORKER_QTY |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | InitComponents:205, InitComponents:209, InitComponents:214, InitComponents:219, InitComponents:224, InitComponents:228, cbo_active_SelectedIndexChanged:1081, clbDivision_changed:1357 | CString.GetCheckedListValue | CODE |
| FP_UpdateBatch2 | Save_Data:614, Save_Data:759 | DataService.FP_UpdateBatch2 | COUNT, EXCEPTION, RESULT |
| FP_UpdateBatch | FP00180_SaveDataDelegate:1115, FP00180_ValidateDataDelegate:1137 | DataService.FP_UpdateBatch | COUNT, RESULT |
| CommonDefaultLineCheck | DefaultLineCheck:787 | ExcelService.CommonDefaultLineCheck | BUCKET_FROM, BUCKET_TO, MESSAGE, QTY |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:137 |
| clbDivision | SelectedIndexChanged | clbDivision_changed | InitEvent:405 |
| cboSite | SelectedIndexChanged | cboSite_changed | InitEvent:406 |
| clbPlant | SelectedIndexChanged | cblPlant_changed | InitEvent:407 |
| clbFactory | SelectedIndexChanged | clbBuilding_changed | InitEvent:408 |
| cboOperation | SelectedIndexChanged | cboOperation_changed | InitEvent:410 |
| cboLine | SelectedIndexChanged | cboLine_changed | InitEvent:411 |
| txtMaterial | TextChanged | txtMaterial_changed | InitEvent:413 |
| dpDate | ValueChanged | DpDate_ValueChanged | InitEvent:414 |
| tbNickName | BeforeOpenSearch | tbNickName_BeforeOpenSearch | InitEvent:416 |
| tbNickName | OnSearchConditionChanged | tbNickName_OnSearchConditionChanged | InitEvent:417 |
| popSql | OnSql | RunSqlSource | btnSql_Click:782 |
| p | DoSearchData | FP00180_SearchDataDelegate | btnExcelImport_Click:1177 |
| p | DoLineCheck | FP00180_RowCheckDelegate | btnExcelImport_Click:1178 |
| p | DoSaveData | FP00180_SaveDataDelegate | btnExcelImport_Click:1179 |
| p | DoValidationData | FP00180_ValidateDataDelegate | btnExcelImport_Click:1180 |
| this.btnUpload | Click | btnExcelImport_Click | InitializeComponent:199 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:519 |
| this.tbNickName | TextChanged | tbNickName_TextChanged | InitializeComponent:604 |
| this.spdMain | ActiveSheetChanged | spdMain_ActiveSheetChanged | InitializeComponent:819 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:820 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:821 |
| this.spdMain | KeyDown | spdMain_KeyDown | InitializeComponent:822 |
| this | Load | Form_Load | .ctor:153 |
| this.btnSave | Click | btnSave_Click | InitializeComponent:153 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:204 |
| this.btnFind | Click | btnFind_Click | InitializeComponent:244 |
| this.btnDownload | Click | btnDownload_Click | InitializeComponent:284 |
| this.btnUpload | Click | btnUpload_Click | InitializeComponent:324 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:407 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:408 |
| this.clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitializeComponent:182 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:232 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:351 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:352 |
| this | Load | Form_Load | .ctor:124 |
| this | Load | Form_Load | .ctor:135 |
| this | Load | Form_Load | .ctor:146 |
| this | Load | Form_Load | .ctor:160 |
| clbDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitControls:205 |
| cboSite | SelectedIndexChanged | CboSite_SelectedIndexChanged | InitControls:206 |
| clbPlant | SelectedIndexChanged | ClbPlant_SelectedIndexChanged | InitControls:207 |

## 6. 컨트롤 (76개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 20 | lblSql, layoutControlItem6, layoutControlItem7, layoutControlItem3, lblNickName, Factory, layoutControlItem8, lblClass2, layoutControlItem9, layoutControlItem5, layoutControlItem2, layoutControlItem2, layoutControlItem4, layoutControlItem5, layoutControlItem6 … |
| UsrButton | 8 | btnUpload, btnSql, usrButton2, btnSave, btnClose, btnFind, btnDownload, btnUpload |
| EmptySpaceItem | 7 | emptySpaceItem1, emptySpaceItem3, emptySpaceItem2, emptySpaceItem4, emptySpaceItem5, emptySpaceItem6, emptySpaceItem1 |
| UsrLayoutControl | 6 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 6 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| UsrCombo | 4 | cboLine, cboSite, cboOperation, cboSite |
| FpSpread | 4 | spdMain, spdTotal, spdMain, spdMain |
| SheetView | 4 | spdMain_Sheet1, spdTotal_Sheet1, spdMain_Sheet1, spdMain_Sheet1 |
| UsrConditionPanel | 3 | usrConditionPanel1, usrConditionPanel1, usrConditionPanel1 |
| UsrCheckedList2 | 3 | clbPlant, clbDivision, clbFactory |
| ImageList | 2 | imageList1, imageList1 |
| UsrCheckedList | 2 | clbDivision, clbPlant |
| UsrDatePicker2 | 1 | dpDate |
| UsrTextBox | 1 | txtMaterial |
| UsrPopupTextBox | 1 | tbNickName |
| SplitContainer | 1 | splitContainer1 |
| Panel | 1 | panel1 |
| Label | 1 | label1 |
| UsrButtonList | 1 | btnButtonList |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 18 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
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
| SCM_MST_SHEET_COLUMNS | FP00461 | Main | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 | 10/0 |
| SCM_MST_SHEET_COLUMNS | FP00461 | Total | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 |
| SCM_MST_SHEET_COLUMNS | FP00461 | TotalAdd | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Main, Total, AutoExcelPopup, TotalAdd
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@InitSpread:382, SetSheetHeaderColumn_FP@InitSpread:390, SetSheetHeaderColumn_FP@SetSpreadInit:283

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 838 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 839 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 840 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 841 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 946 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 947 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 948 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 949 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| FindData |  | 329 | 표시/라벨 변경 | set:CellType | CellType = {?chk} | CHK | if(DoSearchData != null) ⟫ if(AutoCHK) |
| FindData |  | 330 | 표시/라벨 변경 | set:Value | Value = {?false} | CHK | if(DoSearchData != null) ⟫ if(AutoCHK) |
| FindData |  | 331 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | CHK | if(DoSearchData != null) ⟫ if(AutoCHK) |
| InitializeComponent |  | 424 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 425 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 426 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 427 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 368 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 369 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 370 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 371 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Main | META+코드연결 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 | 10 |
| Total | META+코드연결 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 |
| TotalAdd | META+코드연결 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
