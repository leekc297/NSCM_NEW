# FP00450 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00450_Setup_Condition.UIL\FP00450_Setup_Condition.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00450_Setup_Condition.UIL\FP00450_Setup_Condition.UIL.csproj | 2123 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00450_Setup_Condition.UIL\FP00450_Setup_Condition.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00450_Setup_Condition.UIL\FP00450_Setup_Condition.UIL.csproj | 935 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00450_Setup_Condition.UIL\Popup\FP00450_MaterialSetupGroupPopup.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00450_Setup_Condition.UIL\FP00450_Setup_Condition.UIL.csproj | 494 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00450_Setup_Condition.UIL\Popup\FP00450_MaterialSetupGroupPopup.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00450_Setup_Condition.UIL\FP00450_Setup_Condition.UIL.csproj | 696 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00450_Setup_Condition.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Master\FP00450_Setup_Condition.UIL\FP00450_Setup_Condition.UIL.csproj | 37 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\FP00450_Setup_Condition.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 70 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\FP00450_Setup_Condition.designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 531 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\POPUP\FP00450_MaterialSetupGroupPopup.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 128 |
| legacy | 06.UIL\GSCM.FP.Master.UIL\POPUP\FP00450_MaterialSetupGroupPopup.Designer.cs | 06.UIL\GSCM.FP.Master.UIL\GSCM.FP.Master.UIL.csproj | 248 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboCategory.SelectedIndexChanged | CboCategory_SelectedIndexChanged > SetChangeControl | 300 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findSetupCategory] | BIZ_MATCH |  |
| event:cboCategory.SelectedIndexChanged | CboCategory_SelectedIndexChanged > SetChangeControl | 300 | FP\MASTER\FP00450_SetupCondition#findSetupCategory | MATCH | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_findSetupCategory.sql |
| event:cboOperation.SelectedIndexChanged | cboOperation_changed > SetChangeControl | 300 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findSetupCategory] | BIZ_MATCH |  |
| event:cboOperation.SelectedIndexChanged | cboOperation_changed > SetChangeControl | 300 | FP\MASTER\FP00450_SetupCondition#findSetupCategory | MATCH | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_findSetupCategory.sql |
| event:cboOperation.SelectedIndexChanged | cboOperation_changed | 1841 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findSetupCategory] | BIZ_MATCH |  |
| event:cboOperation.SelectedIndexChanged | cboOperation_changed | 1841 | FP\MASTER\FP00450_SetupCondition#findSetupCategory | MATCH | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_findSetupCategory.sql |
| event:cboSite.SelectedIndexChanged | cboSite_changed > SetChangeControl | 300 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findSetupCategory] | BIZ_MATCH |  |
| event:cboSite.SelectedIndexChanged | cboSite_changed > SetChangeControl | 300 | FP\MASTER\FP00450_SetupCondition#findSetupCategory | MATCH | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_findSetupCategory.sql |
| event:clbDivision.SelectedIndexChanged | clbDivision_changed > SetChangeControl | 300 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findSetupCategory] | BIZ_MATCH |  |
| event:clbDivision.SelectedIndexChanged | clbDivision_changed > SetChangeControl | 300 | FP\MASTER\FP00450_SetupCondition#findSetupCategory | MATCH | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_findSetupCategory.sql |
| event:clbPlant.SelectedIndexChanged | clbPlant_changed > SetChangeControl | 300 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findSetupCategory] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | clbPlant_changed > SetChangeControl | 300 | FP\MASTER\FP00450_SetupCondition#findSetupCategory | MATCH | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_findSetupCategory.sql |
| button:FindButton | FindButton > UIFindData > FindData > FindOptionData | 1307 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findLineSetupGroup] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindData > FindOptionData | 1307 | FP\MASTER\FP00450_SetupCondition#findLineSetupGroup | MATCH | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_findLineSetupGroup.sql |
| button:FindButton | FindButton > UIFindData > FindData > FindOptionData | 1310 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_condition_category] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindData > FindOptionData | 1310 | FP\MASTER\FP00450_SetupCondition#find_condition_category | MATCH | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_find_condition_category.sql |
| button:FindButton | FindButton > UIFindData > FindData > FindOptionData | 1313 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_condition_key] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindData > FindOptionData | 1313 | FP\MASTER\FP00450_SetupCondition#find_condition_key | MATCH | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_find_condition_key.sql |
| button:FindButton | FindButton > UIFindData > FindData > FindOptionData | 1318 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findMatrix_setupconditon] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindData > FindOptionData | 1318 | FP\MASTER\FP00450_SetupCondition#findMatrix_setupconditon | MATCH | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_findMatrix_setupconditon.sql |
| button:FindButton | FindButton > UIFindData > FindData > FindOptionData | 1322 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findMatrix_itemsetup] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindData > FindOptionData | 1322 | FP\MASTER\FP00450_SetupCondition#findMatrix_itemsetup | MATCH | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_findMatrix_itemsetup.sql |
| event:popSql.OnSql | RunSqlSource > FindData > FindOptionData | 1307 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findLineSetupGroup] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindData > FindOptionData | 1307 | FP\MASTER\FP00450_SetupCondition#findLineSetupGroup | MATCH | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_findLineSetupGroup.sql |
| event:popSql.OnSql | RunSqlSource > FindData > FindOptionData | 1310 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_condition_category] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindData > FindOptionData | 1310 | FP\MASTER\FP00450_SetupCondition#find_condition_category | MATCH | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_find_condition_category.sql |
| event:popSql.OnSql | RunSqlSource > FindData > FindOptionData | 1313 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_condition_key] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindData > FindOptionData | 1313 | FP\MASTER\FP00450_SetupCondition#find_condition_key | MATCH | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_find_condition_key.sql |
| event:popSql.OnSql | RunSqlSource > FindData > FindOptionData | 1318 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findMatrix_setupconditon] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindData > FindOptionData | 1318 | FP\MASTER\FP00450_SetupCondition#findMatrix_setupconditon | MATCH | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_findMatrix_setupconditon.sql |
| event:popSql.OnSql | RunSqlSource > FindData > FindOptionData | 1322 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findMatrix_itemsetup] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindData > FindOptionData | 1322 | FP\MASTER\FP00450_SetupCondition#findMatrix_itemsetup | MATCH | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_findMatrix_itemsetup.sql |
| button:SaveButton | SaveButton > Save_Data | 764 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=saveAll_FP00450] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > Save_Data | 764 | FP\Master\FP00450_SetupCondition#saveAll_FP00450 | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > Save_Data | 768 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=deleteAll_FP00450] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > Save_Data | 768 | FP\Master\FP00450_SetupCondition#deleteAll_FP00450 | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > Save_Data | 876 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=saveAll_FP00450_cal] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > Save_Data | 876 | FP\Master\FP00450_SetupCondition#saveAll_FP00450_cal | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > Save_Data | 893 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=deleteAll_FP00450_cal] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > Save_Data | 893 | FP\Master\FP00450_SetupCondition#deleteAll_FP00450_cal | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > Save_Data > FindData > FindOptionData | 1307 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findLineSetupGroup] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > Save_Data > FindData > FindOptionData | 1307 | FP\MASTER\FP00450_SetupCondition#findLineSetupGroup | MATCH | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_findLineSetupGroup.sql |
| button:SaveButton | SaveButton > Save_Data > FindData > FindOptionData | 1310 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_condition_category] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > Save_Data > FindData > FindOptionData | 1310 | FP\MASTER\FP00450_SetupCondition#find_condition_category | MATCH | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_find_condition_category.sql |
| button:SaveButton | SaveButton > Save_Data > FindData > FindOptionData | 1313 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_condition_key] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > Save_Data > FindData > FindOptionData | 1313 | FP\MASTER\FP00450_SetupCondition#find_condition_key | MATCH | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_find_condition_key.sql |
| button:SaveButton | SaveButton > Save_Data > FindData > FindOptionData | 1318 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findMatrix_setupconditon] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > Save_Data > FindData > FindOptionData | 1318 | FP\MASTER\FP00450_SetupCondition#findMatrix_setupconditon | MATCH | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_findMatrix_setupconditon.sql |
| button:SaveButton | SaveButton > Save_Data > FindData > FindOptionData | 1322 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findMatrix_itemsetup] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > Save_Data > FindData > FindOptionData | 1322 | FP\MASTER\FP00450_SetupCondition#findMatrix_itemsetup | MATCH | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_findMatrix_itemsetup.sql |
| event:this.btnUpload.Click | btnUpload_Click > FindData > FindOptionData | 1307 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findLineSetupGroup] | BIZ_MATCH |  |
| event:this.btnUpload.Click | btnUpload_Click > FindData > FindOptionData | 1307 | FP\MASTER\FP00450_SetupCondition#findLineSetupGroup | MATCH | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_findLineSetupGroup.sql |
| event:this.btnUpload.Click | btnUpload_Click > FindData > FindOptionData | 1310 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_condition_category] | BIZ_MATCH |  |
| event:this.btnUpload.Click | btnUpload_Click > FindData > FindOptionData | 1310 | FP\MASTER\FP00450_SetupCondition#find_condition_category | MATCH | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_find_condition_category.sql |
| event:this.btnUpload.Click | btnUpload_Click > FindData > FindOptionData | 1313 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_condition_key] | BIZ_MATCH |  |
| event:this.btnUpload.Click | btnUpload_Click > FindData > FindOptionData | 1313 | FP\MASTER\FP00450_SetupCondition#find_condition_key | MATCH | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_find_condition_key.sql |
| event:this.btnUpload.Click | btnUpload_Click > FindData > FindOptionData | 1318 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findMatrix_setupconditon] | BIZ_MATCH |  |
| event:this.btnUpload.Click | btnUpload_Click > FindData > FindOptionData | 1318 | FP\MASTER\FP00450_SetupCondition#findMatrix_setupconditon | MATCH | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_findMatrix_setupconditon.sql |
| event:this.btnUpload.Click | btnUpload_Click > FindData > FindOptionData | 1322 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findMatrix_itemsetup] | BIZ_MATCH |  |
| event:this.btnUpload.Click | btnUpload_Click > FindData > FindOptionData | 1322 | FP\MASTER\FP00450_SetupCondition#findMatrix_itemsetup | MATCH | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_findMatrix_itemsetup.sql |
| event:this.Load | Form_Load > InitControls > GetCategory | 235 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findCategory] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetCategory | 235 | FP\MASTER\FP00450_SetupCondition#findCategory | MATCH | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_findCategory.sql |
| event:this.Load | Form_Load > InitControls > InitComponents > CboCategory_SelectedIndexChanged > SetChangeControl | 300 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findSetupCategory] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > InitComponents > CboCategory_SelectedIndexChanged > SetChangeControl | 300 | FP\MASTER\FP00450_SetupCondition#findSetupCategory | MATCH | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_findSetupCategory.sql |
| event:this.Load | Form_Load > InitControls > InitComponents > cboOperation_changed | 1841 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findSetupCategory] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > InitComponents > cboOperation_changed | 1841 | FP\MASTER\FP00450_SetupCondition#findSetupCategory | MATCH | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_findSetupCategory.sql |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 73 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | ExcelImport_Main_SaveDataDelegate | 1986 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP00450] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | ExcelImport_Main_SaveDataDelegate | 1986 | FP\Master\FP00450_SetupCondition#merge_FP00450 | MATCH | [update-batch]  |
| unreached:(진입점 미연결) | ExcelImport_Main_ValidateDataDelegate | 2002 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | ExcelImport_Main_ValidateDataDelegate | 2002 | FP\MASTER\FP00450_SetupCondition#delete_Excel_buffer | MATCH | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_delete_Excel_buffer.sql |
| unreached:(진입점 미연결) | ExcelImport_Main_ValidateDataDelegate | 2006 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | ExcelImport_Main_ValidateDataDelegate | 2006 | FP\MASTER\FP00450_SetupCondition#insert_Excel_buffer | MATCH | [update-batch]  |
| unreached:(진입점 미연결) | ExcelImport_Main_ValidateDataDelegate | 2010 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | ExcelImport_Main_ValidateDataDelegate | 2010 | FP\MASTER\FP00450_SetupCondition#find_Excel_buffer_validation | MATCH | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_find_Excel_buffer_validation.sql |
| unreached:(진입점 미연결) | ExcelImport_Matrix_SaveDataDelegate | 2075 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP00450_cal] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | ExcelImport_Matrix_SaveDataDelegate | 2075 | FP\Master\FP00450_SetupCondition#merge_FP00450_cal | MATCH | [update-batch]  |
| unreached:(진입점 미연결) | ExcelImport_Matrix_ValidateDataDelegate | 2086 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer_sub] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | ExcelImport_Matrix_ValidateDataDelegate | 2086 | FP\MASTER\FP00450_SetupCondition#delete_Excel_buffer_sub | MATCH | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_delete_Excel_buffer_sub.sql |
| unreached:(진입점 미연결) | ExcelImport_Matrix_ValidateDataDelegate | 2090 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer_sub] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | ExcelImport_Matrix_ValidateDataDelegate | 2090 | FP\MASTER\FP00450_SetupCondition#insert_Excel_buffer_sub | MATCH | [update-batch]  |
| unreached:(진입점 미연결) | ExcelImport_Matrix_ValidateDataDelegate | 2094 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation_sub] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | ExcelImport_Matrix_ValidateDataDelegate | 2094 | FP\MASTER\FP00450_SetupCondition#find_Excel_buffer_validation_sub | MATCH | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_find_Excel_buffer_validation_sub.sql |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer_sub] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_condition_category] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_condition_key] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation_sub] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findCategory] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findLineSetupGroup] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findMatrix_itemsetup] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findMatrix_setupconditon] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findSetupCategory] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=deleteAll_FP00450] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=deleteAll_FP00450_cal] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer_sub] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP00450_cal] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP00450] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=saveAll_FP00450_cal] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=saveAll_FP00450] | BIZ_MATCH | 1 |  |  |  |
| FP\MASTER\FP00450_SetupCondition#delete_Excel_buffer | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_delete_Excel_buffer.sql | DELETE:BUF_SETUP_CONDITION_M |  |
| FP\MASTER\FP00450_SetupCondition#delete_Excel_buffer_sub | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_delete_Excel_buffer_sub.sql | DELETE:BUF_SETUP_MATRIX_M |  |
| FP\Master\FP00450_SetupCondition#deleteAll_FP00450 | MATCH | 1 | [update-batch]  |  |  |
| FP\Master\FP00450_SetupCondition#deleteAll_FP00450_cal | MATCH | 1 | [update-batch]  |  |  |
| FP\MASTER\FP00450_SetupCondition#find_condition_category | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_find_condition_category.sql | SELECT:SCM_ITEM_SETUP_GROUP_M, SELECT:SCM_LINE_SETUP_GROUP_M |  |
| FP\MASTER\FP00450_SetupCondition#find_condition_key | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_find_condition_key.sql | SELECT:SCM_ITEM_SETUP_GROUP_M, SELECT:SCM_LINE_SETUP_GROUP_M |  |
| FP\MASTER\FP00450_SetupCondition#find_Excel_buffer_validation | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_find_Excel_buffer_validation.sql | SELECT:BUF_SETUP_CONDITION_M, SELECT:SCM_PLANT_M, SELECT:SCM_OPERATION_M, SELECT:SCM_LINE_SETUP_GROUP_M, SELECT:SCM_ITEM_SETUP_GROUP_M |  |
| FP\MASTER\FP00450_SetupCondition#find_Excel_buffer_validation_sub | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_find_Excel_buffer_validation_sub.sql | SELECT:BUF_SETUP_MATRIX_M, SELECT:SCM_PLANT_M, SELECT:SCM_OPERATION_M, SELECT:SCM_LINE_SETUP_GROUP_M, SELECT:SCM_ITEM_SETUP_GROUP_M, SELECT:SCM_ITEM_FLOW_V, SELECT:SCM_SETUP_CONDITION_M, SELECT:FP_USER_ROLE_INFO_V |  |
| FP\MASTER\FP00450_SetupCondition#findCategory | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_findCategory.sql | SELECT:SCM_ITEM_SETUP_GROUP_M, SELECT:SCM_LINE_SETUP_GROUP_M |  |
| FP\MASTER\FP00450_SetupCondition#findLineSetupGroup | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_findLineSetupGroup.sql | SELECT:SCM_LINE_SETUP_GROUP_M |  |
| FP\MASTER\FP00450_SetupCondition#findMatrix_itemsetup | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_findMatrix_itemsetup.sql | SELECT:SCM_ITEM_SETUP_GROUP_M, SELECT:SCM_LINE_SETUP_GROUP_M |  |
| FP\MASTER\FP00450_SetupCondition#findMatrix_setupconditon | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_findMatrix_setupconditon.sql | SELECT:SCM_SETUP_CONDITION_M |  |
| FP\MASTER\FP00450_SetupCondition#findSetupCategory | MATCH | 2 | [sql] foxquery_sql\FP_Master_FP00450_SetupCondition_findSetupCategory.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\MASTER\FP00450_SetupCondition#insert_Excel_buffer | MATCH | 1 | [update-batch]  |  |  |
| FP\MASTER\FP00450_SetupCondition#insert_Excel_buffer_sub | MATCH | 1 | [update-batch]  |  |  |
| FP\Master\FP00450_SetupCondition#merge_FP00450 | MATCH | 1 | [update-batch]  |  |  |
| FP\Master\FP00450_SetupCondition#merge_FP00450_cal | MATCH | 1 | [update-batch]  |  |  |
| FP\Master\FP00450_SetupCondition#saveAll_FP00450 | MATCH | 1 | [update-batch]  |  |  |
| FP\Master\FP00450_SetupCondition#saveAll_FP00450_cal | MATCH | 1 | [update-batch]  |  |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| btnUpload_Click | p.KeyColumns | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, LINE_SETUP_GROUP_ID, SETUP_CATEGORY_ID, SETUP_KEY_ID, SETUP_CONDITION_ID, FROM_ITEM_SETUP_GROUP_ID, TO_ITEM_SETUP_GROUP_ID |
| btnUpload_Click | p.ColumnTitle | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, LINE_SETUP_GROUP_ID, SETUP_CATEGORY_ID, SETUP_KEY_ID, SETUP_CONDITION_ID, SETUP_TIME, MESSAGE, FROM_ITEM_SETUP_GROUP_ID, FROM_ITEM_SETUP_GROUP_NAME, TO_ITEM_SETUP_GROUP_ID, TO_ITEM_SETUP_GROUP_NAME, ADJUST_CELL_QTY |
| btnUpload_Click | p.ColumnWidth | OPERATION_GROUP_ID, SETUP_TIME_UOM, DESCRIPTION, EDIT_YN, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, LINE_SETUP_GROUP_ID, SETUP_CATEGORY_ID, SETUP_KEY_ID, FROM_ITEM_SETUP_GROUP_ID, FROM_ITEM_SETUP_GROUP_NAME, TO_ITEM_SETUP_GROUP_ID, TO_ITEM_SETUP_GROUP_NAME, SETUP_CONDITION_ID, SETUP_TIME, ADJUST_CELL_QTY, MESSAGE |
| btnUpload_Click | p.ColumnBgColor | SETUP_TIME |
| cboCategory_selectedIndexChanged | Filter | SETUP_CATEGORY_ID |
| cboKey_SelectedIndexChanged | Filter | SETUP_KEY_ID |
| ExcelImport_Matrix_SearchDataDelegate | row | DIVISION_ID, SITE_ID, COMPANY_ID, PLANT_ID, OPERATION_ID, SETUP_CATEGORY_ID, SETUP_KEY_ID, LINE_SETUP_GROUP_ID |
| ExcelImport_Matrix_SearchDataDelegate | Filter | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, SETUP_CATEGORY_ID, SETUP_KEY_ID, LINE_SETUP_GROUP_ID |
| FindData | Filter | SETUP_CATEGORY_ID, ITEM_SETUP_GROUP_ID |
| FindSubData | Filter | DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, SETUP_CATEGORY_ID, SETUP_KEY_ID, COMPANY_ID, LINE_SETUP_GROUP_ID |
| FindSubData | row | DIVISION_ID, SITE_ID, COMPANY_ID, PLANT_ID, OPERATION_ID, SETUP_CATEGORY_ID, SETUP_KEY_ID, LINE_SETUP_GROUP_ID |
| FindSubData | dRow | DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, LINE_SETUP_GROUP_ID, SETUP_CATEGORY_ID, SETUP_KEY_ID, CODE, NAME |
| FindSubData | siSub.ActiveSheet.Columns | SETUP_CONDITION_ID |
| GetDivision | Filter | USER_ID |
| InitControls | Filter | USER_ID, DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, LINE_SETUP_GROUP_ID, SETUP_CATEGORY_ID |
| InsertButton | row | DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, LINE_SETUP_GROUP_ID, SETUP_CATEGORY_ID, SETUP_KEY_ID, SETUP_CONDITION_ID, SETUP_TIME, COMPANY_ID |
| InsertButton | newRow | DIVISION_ID, SITE_ID, COMPANY_ID, PLANT_ID, OPERATION_ID, SETUP_CATEGORY_ID, SETUP_KEY_ID, LINE_SETUP_GROUP_ID |
| InsertButton | dRow | DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, CODE, NAME, LINE_SETUP_GROUP_ID, SETUP_CATEGORY_ID, SETUP_KEY_ID |
| Save_Data | ro | USER_ID, ADJUST_CELL_QTY |
| SetChangeControl | Filter | PLANT_ID, OPERATION_ID, SETUP_CATEGORY_ID |
| SetOperationInfo | Filter | SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID |
| SetOperationInfo | this.dtFindData.Rows[iClick_Row] | SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID |
| spdMain_CellClick | row | COMPANY_ID, OPERATION_GROUP_ID, SETUP_TIME_UOM |
| spdMain_CellClick | dRow | DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, CODE, NAME |
| spdMain_CellDoubleClick | this.dtFindData.Rows[e.Row] | ITEM_SETUP_GROUP_ID, SETUP_CATEGORY_ID, SETUP_KEY_ID |
| spdMain_CellDoubleClick | Filter | SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID |
| spdMain_ComboSelChange | dRow | DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, LINE_SETUP_GROUP_ID, CODE, NAME, SETUP_CATEGORY_ID |
| spdTotal_CellClick | row | COMPANY_ID, OPERATION_GROUP_ID, SETUP_TIME_UOM |
| spdTotal_CellClick | dRow | DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, CODE, NAME, LINE_SETUP_GROUP_ID, SETUP_CATEGORY_ID, SETUP_KEY_ID |
| spdTotal_CellClick | pop.Filter | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, LINE_SETUP_GROUP_ID, SETUP_CATEGORY_ID, ITEM_SETUP_GROUP_ID, SETUP_KEY_ID |
| UIFindData | Filter | DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, SETUP_CATEGORY_ID, SETUP_KEY_ID, COMPANY_ID, LINE_SETUP_GROUP_ID |
| UIFindData | dsMain.Tables[0].Rows[0] | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, SETUP_CATEGORY_ID, SETUP_KEY_ID, LINE_SETUP_GROUP_ID |
| UIFindData | dRow | DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, LINE_SETUP_GROUP_ID, SETUP_CATEGORY_ID, SETUP_KEY_ID, CODE, NAME |
| UIFindData | siSub.ActiveSheet.Columns | SETUP_CONDITION_ID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetInnerTable | GetDivision:246, SetChangeControl:270, SetChangeControl:276, SetChangeControl:284, SetChangeControl:292 | DataService.GetInnerTable | ACTIVE_FLAG, ALL_LINE, AMEND_FLAG, AMEND_INSTANCE, AMEND_MAIN_FLAG, AMEND_UI_NAME, CODE, CONFIRM_AREA, DIVISION_ID, DIVISION_NAME, FACTORY_ID, FACTORY_NAME, INSTANCE_ID, INSTANCE_NAME, IN_ACT, IS_SAME_PLAN_ID, LINE_AUTH, LINE_ID, LINE_NAME, NAME, OPERATION_ID, OPERATION_NAME, PLANT_ID, PLANT_NAME, SHOP_GROUP_ID, SITE_ID, SITE_NAME, SORT_ORDER, USE_FLAG, USE_WOW_STATUS, VERSION_YN |
| GetCheckedListValue | SetChangeControl:274, SetChangeControl:283, SetChangeControl:291, SetChangeControl:299, SetChangeControl:306, cboKey_SelectedIndexChanged:1847, InitControls:227, cboCategory_selectedIndexChanged:372 | CString.GetCheckedListValue | CODE |
| SetFilter | SetChangeControl:275 | BaseForm.SetFilter | AllYn, Col, SheetName, Value |
| FP_UpdateBatch | Save_Data:764, Save_Data:876, Save_Data:893, ExcelImport_Main_SaveDataDelegate:1986, ExcelImport_Main_ValidateDataDelegate:2006, ExcelImport_Matrix_SaveDataDelegate:2075, ExcelImport_Matrix_ValidateDataDelegate:2090 | DataService.FP_UpdateBatch | COUNT, RESULT |
| FP_PseudoBatch | Save_Data:768 | DataService.FP_PseudoBatch | COUNT, EXCEPTION, RESULT |
| LoadCombo | UIFindData:1113, FindSubData:1731 | SpreadInfo.LoadCombo | CODE, NAME |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:142 |
| clbDivision | SelectedIndexChanged | clbDivision_changed | InitEvent:360 |
| cboSite | SelectedIndexChanged | cboSite_changed | InitEvent:361 |
| clbPlant | SelectedIndexChanged | clbPlant_changed | InitEvent:362 |
| cboOperation | SelectedIndexChanged | cboOperation_changed | InitEvent:364 |
| cboCategory | SelectedIndexChanged | CboCategory_SelectedIndexChanged | InitEvent:365 |
| cboKey | SelectedIndexChanged | cboKey_SelectedIndexChanged | InitEvent:366 |
| popSql | OnSql | RunSqlSource | btnSql_Click:963 |
| this.formTestButton | Click | formTestButton_Click | InitializeComponent:183 |
| this.btnUpload | Click | btnUpload_Click | InitializeComponent:294 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:475 |
| this.spdMain | ActiveSheetChanged | spdMain_ActiveSheetChanged | InitializeComponent:668 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:669 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:670 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:671 |
| this.spdMain | KeyDown | spdMain_KeyDown | InitializeComponent:672 |
| this.spdTotal | CellClick | spdTotal_CellClick | InitializeComponent:781 |
| this.cboCategory | SelectedIndexChanged | cboCategory_selectedIndexChanged | InitializeComponent:382 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:438 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:585 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:586 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:587 |
| this | Load | Form_Load | .ctor:164 |
| this | Load | Form_Load | .ctor:182 |

## 6. 컨트롤 (60개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 17 | lblSql, layoutControlItem6, layoutControlItem7, layoutControlItem3, layoutControlItem9, layoutControlItem2, layoutControlItem5, lclForm, lblClass2, layoutControlItem1, layoutControlItem3, layoutControlItem5, layoutControlItem6, layoutControlItem7, layoutControlItem2 … |
| UsrTextBox | 6 | txtSetupGroup, txtLineSetup, txtDivision, txtSite, txtOperation, txtPlant |
| UsrCombo | 5 | cboKey, cboCategory, cboSite, cboOperation, cboCategory |
| EmptySpaceItem | 5 | emptySpaceItem4, emptySpaceItem2, emptySpaceItem1, emptySpaceItem3, emptySpaceItem2 |
| UsrLayoutControl | 4 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 4 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| UsrButton | 4 | formTestButton, btnUpload, btnSql, usrButton2 |
| FpSpread | 3 | spdMain, spdTotal, spdMain |
| SheetView | 3 | spdMain_Sheet1, spdTotal_Sheet1, spdMain_Sheet1 |
| UsrConditionPanel | 2 | usrConditionPanel1, usrConditionPanel1 |
| UsrCheckedList2 | 2 | clbPlant, clbDivision |
| ImageList | 1 | imageList1 |
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
| dbo.SCM_MST_SHEET_COLUMNS | 32 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_GroupMenuAuth | 5 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
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
| SCM_MST_SHEET_COLUMNS | FP00450 | Main | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 |
| SCM_MST_SHEET_COLUMNS | FP00450 | MaterialSetupGroup | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 | 9/0 |
| SCM_MST_SHEET_COLUMNS | FP00450 | Matrix | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 | 14/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Main, Matrix, MaterialSetupGroup
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@InitSpread:343, SetSheetHeaderColumn_FP@InitSpread:351, SetSheetHeaderColumn_FP@SetSpreadInit:275

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 688 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 689 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 690 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 691 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 797 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 798 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 799 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 800 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 603 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 604 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 605 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 606 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Main | META+코드연결 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 |
| MaterialSetupGroup | META+코드연결 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 |
| Matrix | META+코드연결 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
