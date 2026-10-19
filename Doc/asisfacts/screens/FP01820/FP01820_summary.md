# FP01820 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01820_Net_Job.UIL\FP01820_Net_Job_AddPop.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01820_Net_Job.UIL\FP01820_Net_Job.UIL.csproj | 1081 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01820_Net_Job.UIL\FP01820_Net_Job_AddPop.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01820_Net_Job.UIL\FP01820_Net_Job.UIL.csproj | 1394 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01820_Net_Job.UIL\FP01820_Net_Job_DatePop.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01820_Net_Job.UIL\FP01820_Net_Job.UIL.csproj | 271 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01820_Net_Job.UIL\FP01820_Net_Job_DatePop.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01820_Net_Job.UIL\FP01820_Net_Job.UIL.csproj | 732 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01820_Net_Job.UIL\FP01820_Net_Job_ExceptPop.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01820_Net_Job.UIL\FP01820_Net_Job.UIL.csproj | 842 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01820_Net_Job.UIL\FP01820_Net_Job_ExceptPop.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01820_Net_Job.UIL\FP01820_Net_Job.UIL.csproj | 1138 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01820_Net_Job.UIL\FP01820_Net_Job.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01820_Net_Job.UIL\FP01820_Net_Job.UIL.csproj | 1605 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01820_Net_Job.UIL\FP01820_Net_Job.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01820_Net_Job.UIL\FP01820_Net_Job.UIL.csproj | 1035 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01820_Net_Job.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01820_Net_Job.UIL\FP01820_Net_Job.UIL.csproj | 37 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01820_Net_Job.UIL\Properties\Resources.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01820_Net_Job.UIL\FP01820_Net_Job.UIL.csproj | 64 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData > Find_Data_Line | 463 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_FP01820_except] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData > Find_Data_Line | 463 | FP\Admin\FP01820_Net_Job#find_FP01820_except | MATCH | [sql] foxquery_sql\FP_Admin_FP01820_Net_Job_find_FP01820_except.sql |
| button:FindButton | FindButton > FindData > Find_Data_Line_except | 478 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_FP01820_except] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData > Find_Data_Line_except | 478 | FP\Admin\FP01820_Net_Job#find_FP01820_except | MATCH | [sql] foxquery_sql\FP_Admin_FP01820_Net_Job_find_FP01820_except.sql |
| button:FindButton | FindButton > FindData > Find_Data_Line | 485 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_FP01820_Sub] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData > Find_Data_Line | 485 | FP\Admin\FP01820_Net_Job#find_FP01820_Sub | MATCH | [sql] foxquery_sql\FP_Admin_FP01820_Net_Job_find_FP01820_Sub.sql |
| button:FindButton | FindButton > FindData > Find_Data_Line_except | 501 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_FP01820_Sub] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData > Find_Data_Line_except | 501 | FP\Admin\FP01820_Net_Job#find_FP01820_Sub | MATCH | [sql] foxquery_sql\FP_Admin_FP01820_Net_Job_find_FP01820_Sub.sql |
| button:FindButton | FindButton > Find_Main > lfn_SearchDetailGrid > Find_Data_Sub > Find_Data_Sub_Execute | 946 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_FP01820_Sub] | BIZ_MATCH |  |
| button:FindButton | FindButton > Find_Main > lfn_SearchDetailGrid > Find_Data_Sub > Find_Data_Sub_Execute | 946 | FP\ADMIN\FP01820_Net_Job#find_FP01820_Sub | MATCH | [sql] foxquery_sql\FP_Admin_FP01820_Net_Job_find_FP01820_Sub.sql |
| button:InsertButton | InsertButton > fn_detailView > Find_Main > lfn_SearchDetailGrid > Find_Data_Sub > Find_Data_Sub_Execute | 946 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_FP01820_Sub] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > fn_detailView > Find_Main > lfn_SearchDetailGrid > Find_Data_Sub > Find_Data_Sub_Execute | 946 | FP\ADMIN\FP01820_Net_Job#find_FP01820_Sub | MATCH | [sql] foxquery_sql\FP_Admin_FP01820_Net_Job_find_FP01820_Sub.sql |
| event:popSql.OnSql | RunSqlSource > Find_Data_Sub_Execute | 946 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_FP01820_Sub] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Sub_Execute | 946 | FP\ADMIN\FP01820_Net_Job#find_FP01820_Sub | MATCH | [sql] foxquery_sql\FP_Admin_FP01820_Net_Job_find_FP01820_Sub.sql |
| button:SaveButton | SaveButton > saveData | 637 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_GroupId] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > saveData | 637 | FP\ADMIN\FP01820_Net_Job#find_GroupId | MATCH | [sql] foxquery_sql\FP_Admin_FP01820_Net_Job_find_GroupId.sql |
| button:SaveButton | SaveButton > saveData > lfn_saveAllDetail | 788 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP01820_except] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > saveData > lfn_saveAllDetail | 788 | FP\ADMIN\FP01820_Net_Job#merge_FP01820_except | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > saveData > lfn_saveAllDetail | 801 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=delete_FP01820_except] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > saveData > lfn_saveAllDetail | 801 | FP\ADMIN\FP01820_Net_Job#delete_FP01820_except | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > saveData > lfn_saveMaster | 847 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_FP01820_master] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > saveData > lfn_saveMaster | 847 | FP\ADMIN\FP01820_Net_Job#insert_FP01820_master | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > saveData > lfn_saveDetail | 887 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_FP01820_detail] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > saveData > lfn_saveDetail | 887 | FP\ADMIN\FP01820_Net_Job#insert_FP01820_detail | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > saveData > lfn_saveAllMaster | 921 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=update_FP01820_master] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > saveData > lfn_saveAllMaster | 921 | FP\ADMIN\FP01820_Net_Job#update_FP01820_master | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > Save_Main > Find_Main > lfn_SearchDetailGrid > Find_Data_Sub > Find_Data_Sub_Execute | 946 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_FP01820_Sub] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > Save_Main > Find_Main > lfn_SearchDetailGrid > Find_Data_Sub > Find_Data_Sub_Execute | 946 | FP\ADMIN\FP01820_Net_Job#find_FP01820_Sub | MATCH | [sql] foxquery_sql\FP_Admin_FP01820_Net_Job_find_FP01820_Sub.sql |
| button:SaveButton | SaveButton > saveData > lfn_saveAllDetail | 999 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP01820_detail] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > saveData > lfn_saveAllDetail | 999 | FP\ADMIN\FP01820_Net_Job#merge_FP01820_detail | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > saveData > lfn_saveAllDetail | 1012 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=delete_FP01820_detail] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > saveData > lfn_saveAllDetail | 1012 | FP\ADMIN\FP01820_Net_Job#delete_FP01820_detail | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > Save_Main > Save_Data_Execute | 1113 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=delete_FP01820_all] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > Save_Main > Save_Data_Execute | 1113 | FP\ADMIN\FP01820_Net_Job#delete_FP01820_all | MATCH | [update-batch]  |
| event:this.btn_detail.Click | btn_detail_Click > fn_detailView > Find_Main > lfn_SearchDetailGrid > Find_Data_Sub > Find_Data_Sub_Execute | 946 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_FP01820_Sub] | BIZ_MATCH |  |
| event:this.btn_detail.Click | btn_detail_Click > fn_detailView > Find_Main > lfn_SearchDetailGrid > Find_Data_Sub > Find_Data_Sub_Execute | 946 | FP\ADMIN\FP01820_Net_Job#find_FP01820_Sub | MATCH | [sql] foxquery_sql\FP_Admin_FP01820_Net_Job_find_FP01820_Sub.sql |
| event:this.btn_start.Click | btn_start_Click | 1460 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=save_FP01820_start] | BIZ_MATCH |  |
| event:this.btn_start.Click | btn_start_Click | 1460 | FP\ADMIN\FP01820_Net_Job#save_FP01820_start | MATCH | [update-batch]  |
| event:this.btn_stop.Click | btn_stop_Click | 1494 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=save_FP01820_stop] | BIZ_MATCH |  |
| event:this.btn_stop.Click | btn_stop_Click | 1494 | FP\ADMIN\FP01820_Net_Job#save_FP01820_stop | MATCH | [update-batch]  |
| event:this.btnFind.Click | btnFind_Click > FindData > Find_Data_Line | 463 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_FP01820_except] | BIZ_MATCH |  |
| event:this.btnFind.Click | btnFind_Click > FindData > Find_Data_Line | 463 | FP\Admin\FP01820_Net_Job#find_FP01820_except | MATCH | [sql] foxquery_sql\FP_Admin_FP01820_Net_Job_find_FP01820_except.sql |
| event:this.btnFind.Click | btnFind_Click > FindData > Find_Data_Line_except | 478 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_FP01820_except] | BIZ_MATCH |  |
| event:this.btnFind.Click | btnFind_Click > FindData > Find_Data_Line_except | 478 | FP\Admin\FP01820_Net_Job#find_FP01820_except | MATCH | [sql] foxquery_sql\FP_Admin_FP01820_Net_Job_find_FP01820_except.sql |
| event:this.btnFind.Click | btnFind_Click > FindData > Find_Data_Line | 485 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_FP01820_Sub] | BIZ_MATCH |  |
| event:this.btnFind.Click | btnFind_Click > FindData > Find_Data_Line | 485 | FP\Admin\FP01820_Net_Job#find_FP01820_Sub | MATCH | [sql] foxquery_sql\FP_Admin_FP01820_Net_Job_find_FP01820_Sub.sql |
| event:this.btnFind.Click | btnFind_Click > FindData > Find_Data_Line_except | 501 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_FP01820_Sub] | BIZ_MATCH |  |
| event:this.btnFind.Click | btnFind_Click > FindData > Find_Data_Line_except | 501 | FP\Admin\FP01820_Net_Job#find_FP01820_Sub | MATCH | [sql] foxquery_sql\FP_Admin_FP01820_Net_Job_find_FP01820_Sub.sql |
| event:this.btnSave.Click | btnSave_Click > Save_Data | 209 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_FP01820_timechk] | BIZ_MATCH |  |
| event:this.btnSave.Click | btnSave_Click > Save_Data | 209 | FP\Admin\FP01820_Net_Job#find_FP01820_timechk | MATCH | [sql] foxquery_sql\FP_Admin_FP01820_Net_Job_find_FP01820_timechk.sql |
| event:this.btnSave.Click | btnSave_Click > saveData | 637 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_GroupId] | BIZ_MATCH |  |
| event:this.btnSave.Click | btnSave_Click > saveData | 637 | FP\ADMIN\FP01820_Net_Job#find_GroupId | MATCH | [sql] foxquery_sql\FP_Admin_FP01820_Net_Job_find_GroupId.sql |
| event:this.btnSave.Click | btnSave_Click > saveData > lfn_saveAllDetail | 788 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP01820_except] | BIZ_MATCH |  |
| event:this.btnSave.Click | btnSave_Click > saveData > lfn_saveAllDetail | 788 | FP\ADMIN\FP01820_Net_Job#merge_FP01820_except | MATCH | [update-batch]  |
| event:this.btnSave.Click | btnSave_Click > saveData > lfn_saveAllDetail | 801 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=delete_FP01820_except] | BIZ_MATCH |  |
| event:this.btnSave.Click | btnSave_Click > saveData > lfn_saveAllDetail | 801 | FP\ADMIN\FP01820_Net_Job#delete_FP01820_except | MATCH | [update-batch]  |
| event:this.btnSave.Click | btnSave_Click > saveData > lfn_saveMaster | 847 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_FP01820_master] | BIZ_MATCH |  |
| event:this.btnSave.Click | btnSave_Click > saveData > lfn_saveMaster | 847 | FP\ADMIN\FP01820_Net_Job#insert_FP01820_master | MATCH | [update-batch]  |
| event:this.btnSave.Click | btnSave_Click > saveData > lfn_saveDetail | 887 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_FP01820_detail] | BIZ_MATCH |  |
| event:this.btnSave.Click | btnSave_Click > saveData > lfn_saveDetail | 887 | FP\ADMIN\FP01820_Net_Job#insert_FP01820_detail | MATCH | [update-batch]  |
| event:this.btnSave.Click | btnSave_Click > saveData > lfn_saveAllMaster | 921 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=update_FP01820_master] | BIZ_MATCH |  |
| event:this.btnSave.Click | btnSave_Click > saveData > lfn_saveAllMaster | 921 | FP\ADMIN\FP01820_Net_Job#update_FP01820_master | MATCH | [update-batch]  |
| event:this.btnSave.Click | btnSave_Click > saveData > lfn_saveAllDetail | 999 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP01820_detail] | BIZ_MATCH |  |
| event:this.btnSave.Click | btnSave_Click > saveData > lfn_saveAllDetail | 999 | FP\ADMIN\FP01820_Net_Job#merge_FP01820_detail | MATCH | [update-batch]  |
| event:this.btnSave.Click | btnSave_Click > saveData > lfn_saveAllDetail | 1012 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=delete_FP01820_detail] | BIZ_MATCH |  |
| event:this.btnSave.Click | btnSave_Click > saveData > lfn_saveAllDetail | 1012 | FP\ADMIN\FP01820_Net_Job#delete_FP01820_detail | MATCH | [update-batch]  |
| event:this.Load | Form_Load > InitControls | 181 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 189 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 194 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findLookupCode] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 194 | FP\ADMIN\FP01820_Net_Job#findLookupCode | MATCH | [sql] foxquery_sql\FP_Admin_FP01820_Net_Job_findLookupCode.sql |
| event:this.Load | Form_Load > InitControls | 202 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findLookupCode] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 202 | FP\ADMIN\FP01820_Net_Job#findLookupCode | MATCH | [sql] foxquery_sql\FP_Admin_FP01820_Net_Job_findLookupCode.sql |
| event:this.Load | Form_Load > InitControls | 224 | biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData > Find_Data_Line | 463 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_FP01820_except] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData > Find_Data_Line | 463 | FP\Admin\FP01820_Net_Job#find_FP01820_except | MATCH | [sql] foxquery_sql\FP_Admin_FP01820_Net_Job_find_FP01820_except.sql |
| event:this.Load | Form_Load > FindData > Find_Data_Line_except | 478 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_FP01820_except] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData > Find_Data_Line_except | 478 | FP\Admin\FP01820_Net_Job#find_FP01820_except | MATCH | [sql] foxquery_sql\FP_Admin_FP01820_Net_Job_find_FP01820_except.sql |
| event:this.Load | Form_Load > FindData > Find_Data_Line | 485 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_FP01820_Sub] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData > Find_Data_Line | 485 | FP\Admin\FP01820_Net_Job#find_FP01820_Sub | MATCH | [sql] foxquery_sql\FP_Admin_FP01820_Net_Job_find_FP01820_Sub.sql |
| event:this.Load | Form_Load > FindData > Find_Data_Line_except | 501 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_FP01820_Sub] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData > Find_Data_Line_except | 501 | FP\Admin\FP01820_Net_Job#find_FP01820_Sub | MATCH | [sql] foxquery_sql\FP_Admin_FP01820_Net_Job_find_FP01820_Sub.sql |
| event:this.spdMain.CellClick | spdMain_CellClick > lfn_SearchDetailGrid > Find_Data_Sub > Find_Data_Sub_Execute | 946 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_FP01820_Sub] | BIZ_MATCH |  |
| event:this.spdMain.CellClick | spdMain_CellClick > lfn_SearchDetailGrid > Find_Data_Sub > Find_Data_Sub_Execute | 946 | FP\ADMIN\FP01820_Net_Job#find_FP01820_Sub | MATCH | [sql] foxquery_sql\FP_Admin_FP01820_Net_Job_find_FP01820_Sub.sql |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > fn_detailView > Find_Main > lfn_SearchDetailGrid > Find_Data_Sub > Find_Data_Sub_Execute | 946 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_FP01820_Sub] | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > fn_detailView > Find_Main > lfn_SearchDetailGrid > Find_Data_Sub > Find_Data_Sub_Execute | 946 | FP\ADMIN\FP01820_Net_Job#find_FP01820_Sub | MATCH | [sql] foxquery_sql\FP_Admin_FP01820_Net_Job_find_FP01820_Sub.sql |
| event:this.spdMain.KeyUp | spdMain_KeyUp > lfn_SearchDetailGrid > Find_Data_Sub > Find_Data_Sub_Execute | 946 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_FP01820_Sub] | BIZ_MATCH |  |
| event:this.spdMain.KeyUp | spdMain_KeyUp > lfn_SearchDetailGrid > Find_Data_Sub > Find_Data_Sub_Execute | 946 | FP\ADMIN\FP01820_Net_Job#find_FP01820_Sub | MATCH | [sql] foxquery_sql\FP_Admin_FP01820_Net_Job_find_FP01820_Sub.sql |
| event:this.spdSub.CellClick | spdSub_CellClick > lfn_SearchDetailGrid > Find_Data_Sub > Find_Data_Sub_Execute | 946 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_FP01820_Sub] | BIZ_MATCH |  |
| event:this.spdSub.CellClick | spdSub_CellClick > lfn_SearchDetailGrid > Find_Data_Sub > Find_Data_Sub_Execute | 946 | FP\ADMIN\FP01820_Net_Job#find_FP01820_Sub | MATCH | [sql] foxquery_sql\FP_Admin_FP01820_Net_Job_find_FP01820_Sub.sql |
| event:this.spdSub.CellClick | spdSub_CellClick | 1262 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=update_InitStatus] | BIZ_MATCH |  |
| event:this.spdSub.CellClick | spdSub_CellClick | 1262 | FP\ADMIN\FP01820_Net_Job#update_InitStatus | MATCH | [update-batch]  |
| unreached:(진입점 미연결) | ExcelImport_Main_SaveDataDelegate | 574 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=merge_FP02550] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | ExcelImport_Main_SaveDataDelegate | 574 | FP\Master\FP02550_OperationBod#merge_FP02550 | MATCH | [update-batch]  |
| unreached:(진입점 미연결) | ExcelImport_Main_ValidateDataDelegate | 593 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | ExcelImport_Main_ValidateDataDelegate | 593 | FP\MASTER\FP02550_OperationBod#delete_Excel_buffer | MATCH | [sql] foxquery_sql\FP_Master_FP02550_OperationBod_delete_Excel_buffer.sql |
| unreached:(진입점 미연결) | ExcelImport_Main_ValidateDataDelegate | 596 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | ExcelImport_Main_ValidateDataDelegate | 596 | FP\MASTER\FP02550_OperationBod#insert_Excel_buffer | MATCH | [update-batch]  |
| unreached:(진입점 미연결) | ExcelImport_Main_ValidateDataDelegate | 597 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | ExcelImport_Main_ValidateDataDelegate | 597 | FP\MASTER\FP02550_OperationBod#find_Excel_buffer_validation | MATCH | [sql] foxquery_sql\FP_Master_FP02550_OperationBod_find_Excel_buffer_validation.sql |
| unreached:(진입점 미연결) | ExcelImport_Sub_SaveDataDelegate | 620 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=merge_FP02550_Sub] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | ExcelImport_Sub_SaveDataDelegate | 620 | FP\Master\FP02550_OperationBod#merge_FP02550_Sub | MATCH | [update-batch]  |
| unreached:(진입점 미연결) | ExcelImport_Sub_ValidateDataDelegate | 636 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer_sub] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | ExcelImport_Sub_ValidateDataDelegate | 636 | FP\MASTER\FP02550_OperationBod#delete_Excel_buffer_sub | MATCH | [sql] foxquery_sql\FP_Master_FP02550_OperationBod_delete_Excel_buffer_sub.sql |
| unreached:(진입점 미연결) | ExcelImport_Sub_ValidateDataDelegate | 639 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer_sub] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | ExcelImport_Sub_ValidateDataDelegate | 639 | FP\MASTER\FP02550_OperationBod#insert_Excel_buffer_sub | MATCH | [update-batch]  |
| unreached:(진입점 미연결) | ExcelImport_Sub_ValidateDataDelegate | 640 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation_sub] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | ExcelImport_Sub_ValidateDataDelegate | 640 | FP\MASTER\FP02550_OperationBod#find_Excel_buffer_validation_sub | MATCH | [sql] foxquery_sql\FP_Master_FP02550_OperationBod_find_Excel_buffer_validation_sub.sql |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList_SCP:REF:FN_GET_DIVISION |
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer_sub] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation_sub] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_FP01820_except] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_FP01820_Sub] | BIZ_MATCH | 3 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_FP01820_timechk] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_GroupId] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=findLookupCode] | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer_sub] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=insert_Excel_buffer] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=merge_FP02550_Sub] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=merge_FP02550] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=delete_FP01820_all] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=delete_FP01820_detail] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=delete_FP01820_except] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_FP01820_detail] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_FP01820_master] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP01820_detail] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP01820_except] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=save_FP01820_start] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=save_FP01820_stop] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=update_FP01820_master] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=update_InitStatus] | BIZ_MATCH | 1 |  |  |  |
| FP\ADMIN\FP01820_Net_Job#delete_FP01820_all | MATCH | 1 | [update-batch]  |  |  |
| FP\ADMIN\FP01820_Net_Job#delete_FP01820_detail | MATCH | 1 | [update-batch]  |  |  |
| FP\ADMIN\FP01820_Net_Job#delete_FP01820_except | MATCH | 1 | [update-batch]  |  |  |
| FP\Admin\FP01820_Net_Job#find_FP01820_except | MATCH | 2 | [sql] foxquery_sql\FP_Admin_FP01820_Net_Job_find_FP01820_except.sql | REF:SYSDATE1, SELECT:JOB_SCHEDULE_EXCEPTION |  |
| FP\Admin\FP01820_Net_Job#find_FP01820_Sub | MATCH | 2 | [sql] foxquery_sql\FP_Admin_FP01820_Net_Job_find_FP01820_Sub.sql | SELECT:JOB_SCHEDULE_HISTORY, SELECT:JOB_SCHEDULE_DETAIL |  |
| FP\ADMIN\FP01820_Net_Job#find_FP01820_Sub | MATCH | 1 | [sql] foxquery_sql\FP_Admin_FP01820_Net_Job_find_FP01820_Sub.sql | SELECT:JOB_SCHEDULE_HISTORY, SELECT:JOB_SCHEDULE_DETAIL |  |
| FP\Admin\FP01820_Net_Job#find_FP01820_timechk | MATCH | 1 | [sql] foxquery_sql\FP_Admin_FP01820_Net_Job_find_FP01820_timechk.sql | REF:SYSDATE1 |  |
| FP\ADMIN\FP01820_Net_Job#find_GroupId | MATCH | 1 | [sql] foxquery_sql\FP_Admin_FP01820_Net_Job_find_GroupId.sql | SELECT:JOB_SCHEDULE_MASTER |  |
| FP\ADMIN\FP01820_Net_Job#findLookupCode | MATCH | 2 | [sql] foxquery_sql\FP_Admin_FP01820_Net_Job_findLookupCode.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\ADMIN\FP01820_Net_Job#insert_FP01820_detail | MATCH | 1 | [update-batch]  |  |  |
| FP\ADMIN\FP01820_Net_Job#insert_FP01820_master | MATCH | 1 | [update-batch]  |  |  |
| FP\ADMIN\FP01820_Net_Job#merge_FP01820_detail | MATCH | 1 | [update-batch]  |  |  |
| FP\ADMIN\FP01820_Net_Job#merge_FP01820_except | MATCH | 1 | [update-batch]  |  |  |
| FP\ADMIN\FP01820_Net_Job#save_FP01820_start | MATCH | 1 | [update-batch]  |  |  |
| FP\ADMIN\FP01820_Net_Job#save_FP01820_stop | MATCH | 1 | [update-batch]  |  |  |
| FP\ADMIN\FP01820_Net_Job#update_FP01820_master | MATCH | 1 | [update-batch]  |  |  |
| FP\ADMIN\FP01820_Net_Job#update_InitStatus | MATCH | 1 | [update-batch]  |  |  |
| FP\MASTER\FP02550_OperationBod#delete_Excel_buffer | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP02550_OperationBod_delete_Excel_buffer.sql | DELETE:BUF_OPERATION_MOVE_M |  |
| FP\MASTER\FP02550_OperationBod#delete_Excel_buffer_sub | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP02550_OperationBod_delete_Excel_buffer_sub.sql | DELETE:BUF_ITEM_FLOW_EXCEPT_M |  |
| FP\MASTER\FP02550_OperationBod#find_Excel_buffer_validation | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP02550_OperationBod_find_Excel_buffer_validation.sql | SELECT:BUF_OPERATION_MOVE_M, SELECT:SCM_FACTORY_M, SELECT:SCM_OPERATION_M, SELECT:SCM_SYS_LOOKUP_VALUE, SELECT:FP_USER_ROLE_INFO_V |  |
| FP\MASTER\FP02550_OperationBod#find_Excel_buffer_validation_sub | MATCH | 1 | [sql] foxquery_sql\FP_Master_FP02550_OperationBod_find_Excel_buffer_validation_sub.sql | SELECT:BUF_ITEM_FLOW_EXCEPT_M, SELECT:SCM_ITEM_M, SELECT:SCM_ITEM_CLASS_M, SELECT:SCM_FACTORY_M, SELECT:SCM_OPERATION_M, SELECT:SCM_SYS_LOOKUP_VALUE, SELECT:FP_USER_ROLE_INFO_V |  |
| FP\MASTER\FP02550_OperationBod#insert_Excel_buffer | MATCH | 1 | [update-batch]  |  |  |
| FP\MASTER\FP02550_OperationBod#insert_Excel_buffer_sub | MATCH | 1 | [update-batch]  |  |  |
| FP\Master\FP02550_OperationBod#merge_FP02550 | MATCH | 1 | [update-batch]  |  |  |
| FP\Master\FP02550_OperationBod#merge_FP02550_Sub | MATCH | 1 | [update-batch]  |  |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| .ctor | filterDs | START_YMD, END_YMD, START_HOUR, END_HOUR, START_MIN, END_MIN |
| btn_start_Click | dsbind.Tables[0].Rows[iClickRow] | GROUP_ID |
| btn_stop_Click | dsbind.Tables[0].Rows[iClickRow] | GROUP_ID |
| cboValid_SelectedValueChanged | Filter | VALID |
| Find_Data_Execute | Filter | DIVISION_ID, JOB_LIST, ITEM_ID, SEARCH_COND |
| Find_Data_Line | Filter | GROUP_ID, DIVISION_ID, GROUP_NAME, VALID_YN |
| Find_Data_Line_except | Filter | GROUP_ID, DIVISION_ID, GROUP_NAME |
| find_Master | Filter | JOB_LIST, DIVISION_ID |
| fn_detailView | dsbind.Tables[0].Rows[nRow] | GROUP_ID, DIVISION_ID |
| fn_exceptView | dsbind.Tables[0].Rows[nRow] | GROUP_ID, DIVISION_ID |
| GetSearchCondition | dRow | GROUP_ID, GROUP_NAME, DIVISION_ID |
| InitControls | row | CODE, NAME |
| InitControls | divrow | CODE, NAME |
| InsertData | newRow | VALID, VIEW_FLAG, DIVISION_ID, GROUP_ID |
| lfn_saveAllDetail | row | DIVISION_ID, GROUP_ID, ORG_JOB_ID, JOB_ID, ORG_NO, NO |
| lfn_saveAllMaster | dtMaster.Rows[0] | DIVISION_ID, GROUP_NAME, DESCRIPTION, PERIOD, TIME, VALID |
| lfn_saveDetail | row | DIVISION_ID, ORG_JOB_ID, JOB_ID, ORG_NO, NO |
| lfn_saveMaster | dtMaster.Rows[0] | DIVISION_ID, GROUP_NAME, DESCRIPTION, PERIOD, TIME, VALID |
| Save_Data | FilterTmp | START_DATE |
| saveData | Filter | VALID |
| saveData | dtMaster.Rows[0] | START_DATE, END_DATE, GROUP_ID |
| saveData | row | GROUP_ID |
| set_AftereFind | dtMaster.Rows[0] | DIVISION_ID, GROUP_ID, GROUP_NAME, DESCRIPTION, START_YMD, START_HOUR, START_MIN, END_YMD, END_HOUR, END_MIN, PERIOD, TIME, START_DATE, END_DATE, VALID |
| SetChangedControl | Filter | DIVISION_ID |
| spdMain_CellClick | FilterTmp | START_YMD, END_YMD, START_HOUR, END_HOUR, START_MIN, END_MIN |
| spdSub_CellClick | tmp | GROUP_NAME, JOB_DESC, HIS_ERROR_MSG |
| spdSub_CellClick | dsbind.Tables[0].Rows[e.Row] | GROUP_ID, DIVISION_ID, JOB_ID, NO |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | SetChangedControl:257, SetChangedControl:265, Find_Data_Execute:840, Find_Data_Execute:841, Find_Data_Sub_Execute:918, Find_Data_Sub_Execute:920, Save_Sub:1058 | CString.GetCheckedListValue | CODE |
| FP_PseudoBatch | ExcelImport_Main_SaveDataDelegate:574, ExcelImport_Main_ValidateDataDelegate:596, ExcelImport_Sub_SaveDataDelegate:620, ExcelImport_Sub_ValidateDataDelegate:639 | DataService.FP_PseudoBatch | COUNT, EXCEPTION, RESULT |
| GetSearchCondition | ExcelPopup_Search_Sub_Data:608, RunSqlSource:1397, lfn_SearchDetailGrid:1407 | BaseForm.GetSearchCondition | ControlName, ControlValue |
| FP_UpdateBatch2 | Save_Data_Execute:1113, lfn_saveMaster:847, lfn_saveDetail:887, lfn_saveAllMaster:921, lfn_saveAllDetail:999, lfn_saveAllDetail:1012, lfn_saveAllDetail:788, lfn_saveAllDetail:801 | DataService.FP_UpdateBatch2 | COUNT, EXCEPTION, RESULT |
| FP_UpdateBatch | spdSub_CellClick:1262, btn_start_Click:1460, btn_stop_Click:1494 | DataService.FP_UpdateBatch | COUNT, RESULT |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:129 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitializeComponent:130 |
| this.spdMain | KeyUp | spdMain_KeyUp | InitializeComponent:131 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:355 |
| this.btn_except | Click | btn_except_Click | InitializeComponent:427 |
| this.btn_detail | Click | btn_detail_Click | InitializeComponent:464 |
| this.btn_stop | Click | btn_stop_Click | InitializeComponent:501 |
| this.btn_start | Click | btn_start_Click | InitializeComponent:538 |
| this.spdSub | CellClick | spdSub_CellClick | InitializeComponent:784 |
| this | Load | Form_Load | .ctor:157 |
| clbDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:181 |
| clbJobList | SelectedIndexChanged | clbJobList_SelectedIndexChanged | InitEvent:182 |
| popSql | OnSql | RunSqlSource | btnSql_Click:661 |
| this.cboValid | SelectedValueChanged | cboValid_SelectedValueChanged | InitializeComponent:275 |
| this.btnSave | Click | btnSave_Click | InitializeComponent:697 |
| this.btnFind | Click | btnFind_Click | InitializeComponent:752 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:808 |
| this.btnAdd | Click | btnAdd_Click | InitializeComponent:863 |
| this.btnDel | Click | btnDel_Click | InitializeComponent:900 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:1248 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:1249 |
| this | Load | Form_Load | .ctor:132 |
| this | Load | Form_Load | .ctor:85 |
| popSql | OnSql | RunSqlSource | btnSql_Click:181 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:368 |
| this.btnSave | Click | btnSave_Click | InitializeComponent:406 |
| this.dateRange | ValueChanged | dateRange_ValueChanged | InitializeComponent:458 |
| this.btnSave | Click | btnSave_Click | InitializeComponent:445 |
| this.btnFind | Click | btnFind_Click | InitializeComponent:500 |
| this.btnClose | Click | btnClose_Click | InitializeComponent:556 |
| this.btnAdd | Click | btnAdd_Click | InitializeComponent:611 |
| this.btnDel | Click | btnDel_Click | InitializeComponent:648 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:1004 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:1005 |
| this | Load | Form_Load | .ctor:127 |

## 6. 컨트롤 (157개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 52 | lblDivision, lblSite, lblExcelUpload, lblSql, layoutControlItem3, layoutControlItem6, layoutControlItem7, layoutControlItem4, layoutControlItem5, layoutControlItem1, layoutControlItem11, layoutControlItem2, layoutControlItem4, layoutControlItem2, layoutControlItem14 … |
| UsrButton | 17 | btnSql, btn_except, btn_detail, btn_stop, btn_start, btnSave, btnFind, btnClose, btnAdd, btnDel, btnClose, btnSave, btnSave, btnFind, btnClose … |
| UsrCombo | 14 | cboHourE, cboMinE, cboValid, clbDivision, cboPeriod, cboMinS, cboHourS, cboMinE, cboHourE, cboMinS, cboHourS, cboValid, clbDivision, cboPeriod |
| UsrTextBox | 12 | txtSearch, txtCreator, txtJobName, txtJobGroupID, txtJobDesc, txtTime, txtJobName, txtJobGroupID, txtJobDesc, txtTime, txtStartTime, txtEndTime |
| SimpleLabelItem | 9 | simpleLabelItem1, simpleLabelItem2, simpleLabelItem4, simpleLabelItem1, simpleLabelItem2, simpleLabelItem3, simpleLabelItem1, simpleLabelItem2, simpleLabelItem4 |
| UsrLayoutControl | 8 | usrLayoutControl1, usrLayoutControl3, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 8 | layoutControlGroup1, layoutControlGroup3, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| ImageList | 8 | imageList1, imageList1, imageList2, imageList3, imageList1, imageList1, imageList2, imageList3 |
| EmptySpaceItem | 6 | emptySpaceItem1, emptySpaceItem4, emptySpaceItem5, emptySpaceItem3, emptySpaceItem2, emptySpaceItem7 |
| FpSpread | 4 | spdMain, spdSub, spdMain, spdMain |
| SheetView | 4 | spdMain_Sheet1, spdSub_Sheet1, spdMain_Sheet1, spdMain_Sheet1 |
| UsrConditionPanel | 4 | usrConditionPanel1, usrConditionPanel1, usrConditionPanel1, usrConditionPanel1 |
| UsrCheckedList2 | 2 | clbJobList, clbDivision |
| UsrDatePicker2 | 2 | dpStartRunTime, dpEndRunTime |
| HelpProvider | 2 | helpProvider1, helpProvider1 |
| Panel | 1 | StockPanel |
| Label | 1 | label1 |
| Splitter | 1 | splitter1 |
| UsrLabel | 1 | usrLabel3 |
| UsrDateRangePicker2 | 1 | dateRange |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 57 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 1 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 2 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP01820 | AddPopup | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 | 15/0 |
| SCM_MST_SHEET_COLUMNS | FP01820 | ExceptPopup | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 | 8/0 |
| SCM_MST_SHEET_COLUMNS | FP01820 | Main | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 |
| SCM_MST_SHEET_COLUMNS | FP01820 | Sub | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Main, Sub, AddPopup, ExceptPopup
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@InitSpread:296, SetSheetHeaderColumn_FP@InitSpread:304, SetSheetHeaderColumn_FP@SetSpreadInit:279, SetSheetHeaderColumn_FP@SetSpreadInit:277

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 1265 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1266 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1267 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1268 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 1021 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1022 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1023 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1024 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 147 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 148 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 149 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 150 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 800 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 801 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 802 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 803 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| AddPopup | META+코드연결 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 |
| ExceptPopup | META+코드연결 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 |
| Main | META+코드연결 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 |
| Sub | META+코드연결 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
