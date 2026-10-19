# FP06970 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP06970_Code_Lookup.UIL\FP06970_Code_Lookup.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP06970_Code_Lookup.UIL\FP06970_Code_Lookup.UIL.csproj | 2016 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP06970_Code_Lookup.UIL\FP06970_Code_Lookup.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP06970_Code_Lookup.UIL\FP06970_Code_Lookup.UIL.csproj | 813 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP06970_Code_Lookup.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP06970_Code_Lookup.UIL\FP06970_Code_Lookup.UIL.csproj | 37 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP06970_Code_Lookup.UIL\Properties\Resources.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP06970_Code_Lookup.UIL\FP06970_Code_Lookup.UIL.csproj | 64 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP06970_Code_Lookup.UIL\Properties\Settings.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP06970_Code_Lookup.UIL\FP06970_Code_Lookup.UIL.csproj | 27 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > UIFindData > Find_Data_Amend | 1546 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_code_lookup] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend | 1546 | FP\admin\code_lookup#find_code_lookup | MATCH | [sql] foxquery_sql\FP_Admin_code_lookup_find_code_lookup.sql |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend | 1550 | biz:AppService.GeneralExecuteQuery [batchId=find_code_lookup] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend | 1550 | scp\admin\code_lookup#find_code_lookup | MATCH | [sql] foxquery_sql\SCP_Admin_code_lookup_find_code_lookup.sql |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend | 1553 | biz:QACommonDataBLL.GeneralExecuteQuery [batchId=find_code_lookup] | BIZ_NOT_FOUND |  |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend | 1553 | qa\nerp\code_lookup_fp#find_code_lookup | MATCH | [sql] foxquery_sql\QA_NERP_code_lookup_fp_find_code_lookup.sql |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend | 1556 | biz:QACommonDataBLL.GeneralExecuteQuery [batchId=find_code_lookup] | BIZ_NOT_FOUND |  |
| button:FindButton | FindButton > UIFindData > Find_Data_Amend | 1556 | qa\nerp\code_lookup#find_code_lookup | MATCH | [sql] foxquery_sql\QA_NERP_code_lookup_find_code_lookup.sql |
| button:FindButton | FindButton > UIFindData > FindData_Sub > Find_Data_sub | 1659 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_code_lookup_sub] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindData_Sub > Find_Data_sub | 1659 | FP\admin\code_lookup#find_code_lookup_sub | MATCH | [sql] foxquery_sql\FP_Admin_code_lookup_find_code_lookup_sub.sql |
| button:FindButton | FindButton > UIFindData > FindData_Sub > Find_Data_sub | 1663 | biz:AppService.GeneralExecuteQuery [batchId=find_code_lookup_sub] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindData_Sub > Find_Data_sub | 1663 | scp\admin\code_lookup#find_code_lookup_sub | MATCH | [sql] foxquery_sql\SCP_Admin_code_lookup_find_code_lookup_sub.sql |
| button:FindButton | FindButton > UIFindData > FindData_Sub > Find_Data_sub | 1666 | biz:QACommonDataBLL.GeneralExecuteQuery [batchId=find_code_lookup_sub] | BIZ_NOT_FOUND |  |
| button:FindButton | FindButton > UIFindData > FindData_Sub > Find_Data_sub | 1666 | qa\nerp\code_lookup_fp#find_code_lookup_sub | MATCH | [sql] foxquery_sql\QA_NERP_code_lookup_fp_find_code_lookup_sub.sql |
| button:FindButton | FindButton > UIFindData > FindData_Sub > Find_Data_sub | 1669 | biz:QACommonDataBLL.GeneralExecuteQuery [batchId=find_code_lookup_sub] | BIZ_NOT_FOUND |  |
| button:FindButton | FindButton > UIFindData > FindData_Sub > Find_Data_sub | 1669 | qa\nerp\code_lookup#find_code_lookup_sub | MATCH | [sql] foxquery_sql\QA_NERP_code_lookup_find_code_lookup_sub.sql |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend | 1546 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_code_lookup] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend | 1546 | FP\admin\code_lookup#find_code_lookup | MATCH | [sql] foxquery_sql\FP_Admin_code_lookup_find_code_lookup.sql |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend | 1550 | biz:AppService.GeneralExecuteQuery [batchId=find_code_lookup] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend | 1550 | scp\admin\code_lookup#find_code_lookup | MATCH | [sql] foxquery_sql\SCP_Admin_code_lookup_find_code_lookup.sql |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend | 1553 | biz:QACommonDataBLL.GeneralExecuteQuery [batchId=find_code_lookup] | BIZ_NOT_FOUND |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend | 1553 | qa\nerp\code_lookup_fp#find_code_lookup | MATCH | [sql] foxquery_sql\QA_NERP_code_lookup_fp_find_code_lookup.sql |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend | 1556 | biz:QACommonDataBLL.GeneralExecuteQuery [batchId=find_code_lookup] | BIZ_NOT_FOUND |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_Amend | 1556 | qa\nerp\code_lookup#find_code_lookup | MATCH | [sql] foxquery_sql\QA_NERP_code_lookup_find_code_lookup.sql |
| event:popSql.OnSql | RunSqlSource > Find_Data_sub | 1659 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_code_lookup_sub] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_sub | 1659 | FP\admin\code_lookup#find_code_lookup_sub | MATCH | [sql] foxquery_sql\FP_Admin_code_lookup_find_code_lookup_sub.sql |
| event:popSql.OnSql | RunSqlSource > Find_Data_sub | 1663 | biz:AppService.GeneralExecuteQuery [batchId=find_code_lookup_sub] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_sub | 1663 | scp\admin\code_lookup#find_code_lookup_sub | MATCH | [sql] foxquery_sql\SCP_Admin_code_lookup_find_code_lookup_sub.sql |
| event:popSql.OnSql | RunSqlSource > Find_Data_sub | 1666 | biz:QACommonDataBLL.GeneralExecuteQuery [batchId=find_code_lookup_sub] | BIZ_NOT_FOUND |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_sub | 1666 | qa\nerp\code_lookup_fp#find_code_lookup_sub | MATCH | [sql] foxquery_sql\QA_NERP_code_lookup_fp_find_code_lookup_sub.sql |
| event:popSql.OnSql | RunSqlSource > Find_Data_sub | 1669 | biz:QACommonDataBLL.GeneralExecuteQuery [batchId=find_code_lookup_sub] | BIZ_NOT_FOUND |  |
| event:popSql.OnSql | RunSqlSource > Find_Data_sub | 1669 | qa\nerp\code_lookup#find_code_lookup_sub | MATCH | [sql] foxquery_sql\QA_NERP_code_lookup_find_code_lookup_sub.sql |
| button:SaveButton | SaveButton > SaveData | 1096 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=delete_code_lookup] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData | 1096 | FP\admin\code_lookup#delete_code_lookup | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > SaveData | 1100 | biz:AppService.GeneralPseudoBatch [batchId=delete_code_lookup] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData | 1100 | scp\admin\code_lookup#delete_code_lookup | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > SaveData | 1103 | biz:QACommonDataBLL.GeneralPseudoBatch [batchId=delete_code_lookup] | BIZ_NOT_FOUND |  |
| button:SaveButton | SaveButton > SaveData | 1103 | qa\nerp\code_lookup_fp#delete_code_lookup | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > SaveData | 1106 | biz:QACommonDataBLL.GeneralPseudoBatch [batchId=delete_code_lookup] | BIZ_NOT_FOUND |  |
| button:SaveButton | SaveButton > SaveData | 1106 | qa\nerp\code_lookup#delete_code_lookup | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > SaveData | 1360 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_code_lookup_value] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData | 1360 | FP\admin\code_lookup#save_code_lookup_value | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > SaveData | 1364 | biz:AppService.GeneralPseudoBatch [batchId=save_code_lookup_value] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData | 1364 | scp\admin\code_lookup#save_code_lookup_value | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > SaveData | 1367 | biz:QACommonDataBLL.GeneralPseudoBatch [batchId=save_code_lookup_value] | BIZ_NOT_FOUND |  |
| button:SaveButton | SaveButton > SaveData | 1367 | qa\nerp\code_lookup_fp#save_code_lookup_value | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > SaveData | 1370 | biz:QACommonDataBLL.GeneralPseudoBatch [batchId=save_code_lookup_value] | BIZ_NOT_FOUND |  |
| button:SaveButton | SaveButton > SaveData | 1370 | qa\nerp\code_lookup#save_code_lookup_value | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > SaveData | 1382 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=delete_code_lookup_value] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData | 1382 | FP\admin\code_lookup#delete_code_lookup_value | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > SaveData | 1386 | biz:QACommonDataBLL.GeneralPseudoBatch [batchId=delete_code_lookup_value] | BIZ_NOT_FOUND |  |
| button:SaveButton | SaveButton > SaveData | 1386 | scp\admin\code_lookup#delete_code_lookup_value | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > SaveData | 1389 | biz:QACommonDataBLL.GeneralPseudoBatch [batchId=delete_code_lookup_value] | BIZ_NOT_FOUND |  |
| button:SaveButton | SaveButton > SaveData | 1389 | qa\nerp\code_lookup_fp#delete_code_lookup_value | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > SaveData | 1392 | biz:QACommonDataBLL.GeneralPseudoBatch [batchId=delete_code_lookup_value] | BIZ_NOT_FOUND |  |
| button:SaveButton | SaveButton > SaveData | 1392 | qa\nerp\code_lookup#delete_code_lookup_value | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > SaveData > UIFindData > Find_Data_Amend | 1546 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_code_lookup] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData > UIFindData > Find_Data_Amend | 1546 | FP\admin\code_lookup#find_code_lookup | MATCH | [sql] foxquery_sql\FP_Admin_code_lookup_find_code_lookup.sql |
| button:SaveButton | SaveButton > SaveData > UIFindData > Find_Data_Amend | 1550 | biz:AppService.GeneralExecuteQuery [batchId=find_code_lookup] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData > UIFindData > Find_Data_Amend | 1550 | scp\admin\code_lookup#find_code_lookup | MATCH | [sql] foxquery_sql\SCP_Admin_code_lookup_find_code_lookup.sql |
| button:SaveButton | SaveButton > SaveData > UIFindData > Find_Data_Amend | 1553 | biz:QACommonDataBLL.GeneralExecuteQuery [batchId=find_code_lookup] | BIZ_NOT_FOUND |  |
| button:SaveButton | SaveButton > SaveData > UIFindData > Find_Data_Amend | 1553 | qa\nerp\code_lookup_fp#find_code_lookup | MATCH | [sql] foxquery_sql\QA_NERP_code_lookup_fp_find_code_lookup.sql |
| button:SaveButton | SaveButton > SaveData > UIFindData > Find_Data_Amend | 1556 | biz:QACommonDataBLL.GeneralExecuteQuery [batchId=find_code_lookup] | BIZ_NOT_FOUND |  |
| button:SaveButton | SaveButton > SaveData > UIFindData > Find_Data_Amend | 1556 | qa\nerp\code_lookup#find_code_lookup | MATCH | [sql] foxquery_sql\QA_NERP_code_lookup_find_code_lookup.sql |
| button:SaveButton | SaveButton > SaveData > FindData_Sub_Save > FindData_Sub > Find_Data_sub | 1659 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_code_lookup_sub] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData > FindData_Sub_Save > FindData_Sub > Find_Data_sub | 1659 | FP\admin\code_lookup#find_code_lookup_sub | MATCH | [sql] foxquery_sql\FP_Admin_code_lookup_find_code_lookup_sub.sql |
| button:SaveButton | SaveButton > SaveData > FindData_Sub_Save > FindData_Sub > Find_Data_sub | 1663 | biz:AppService.GeneralExecuteQuery [batchId=find_code_lookup_sub] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData > FindData_Sub_Save > FindData_Sub > Find_Data_sub | 1663 | scp\admin\code_lookup#find_code_lookup_sub | MATCH | [sql] foxquery_sql\SCP_Admin_code_lookup_find_code_lookup_sub.sql |
| button:SaveButton | SaveButton > SaveData > FindData_Sub_Save > FindData_Sub > Find_Data_sub | 1666 | biz:QACommonDataBLL.GeneralExecuteQuery [batchId=find_code_lookup_sub] | BIZ_NOT_FOUND |  |
| button:SaveButton | SaveButton > SaveData > FindData_Sub_Save > FindData_Sub > Find_Data_sub | 1666 | qa\nerp\code_lookup_fp#find_code_lookup_sub | MATCH | [sql] foxquery_sql\QA_NERP_code_lookup_fp_find_code_lookup_sub.sql |
| button:SaveButton | SaveButton > SaveData > FindData_Sub_Save > FindData_Sub > Find_Data_sub | 1669 | biz:QACommonDataBLL.GeneralExecuteQuery [batchId=find_code_lookup_sub] | BIZ_NOT_FOUND |  |
| button:SaveButton | SaveButton > SaveData > FindData_Sub_Save > FindData_Sub > Find_Data_sub | 1669 | qa\nerp\code_lookup#find_code_lookup_sub | MATCH | [sql] foxquery_sql\QA_NERP_code_lookup_find_code_lookup_sub.sql |
| event:this.Load | Form_Load > InitControls | 277 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| event:this.spdMain.ActiveSheet.CellChanged | ActiveSheet_CellChanged > FindData_Sub > Find_Data_sub | 1659 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_code_lookup_sub] | BIZ_MATCH |  |
| event:this.spdMain.ActiveSheet.CellChanged | ActiveSheet_CellChanged > FindData_Sub > Find_Data_sub | 1659 | FP\admin\code_lookup#find_code_lookup_sub | MATCH | [sql] foxquery_sql\FP_Admin_code_lookup_find_code_lookup_sub.sql |
| event:this.spdMain.ActiveSheet.CellChanged | ActiveSheet_CellChanged > FindData_Sub > Find_Data_sub | 1663 | biz:AppService.GeneralExecuteQuery [batchId=find_code_lookup_sub] | BIZ_MATCH |  |
| event:this.spdMain.ActiveSheet.CellChanged | ActiveSheet_CellChanged > FindData_Sub > Find_Data_sub | 1663 | scp\admin\code_lookup#find_code_lookup_sub | MATCH | [sql] foxquery_sql\SCP_Admin_code_lookup_find_code_lookup_sub.sql |
| event:this.spdMain.ActiveSheet.CellChanged | ActiveSheet_CellChanged > FindData_Sub > Find_Data_sub | 1666 | biz:QACommonDataBLL.GeneralExecuteQuery [batchId=find_code_lookup_sub] | BIZ_NOT_FOUND |  |
| event:this.spdMain.ActiveSheet.CellChanged | ActiveSheet_CellChanged > FindData_Sub > Find_Data_sub | 1666 | qa\nerp\code_lookup_fp#find_code_lookup_sub | MATCH | [sql] foxquery_sql\QA_NERP_code_lookup_fp_find_code_lookup_sub.sql |
| event:this.spdMain.ActiveSheet.CellChanged | ActiveSheet_CellChanged > FindData_Sub > Find_Data_sub | 1669 | biz:QACommonDataBLL.GeneralExecuteQuery [batchId=find_code_lookup_sub] | BIZ_NOT_FOUND |  |
| event:this.spdMain.ActiveSheet.CellChanged | ActiveSheet_CellChanged > FindData_Sub > Find_Data_sub | 1669 | qa\nerp\code_lookup#find_code_lookup_sub | MATCH | [sql] foxquery_sql\QA_NERP_code_lookup_find_code_lookup_sub.sql |
| event:this.spdMain.CellClick | SpdMain_CellClick > FindData_Sub > Find_Data_sub | 1659 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_code_lookup_sub] | BIZ_MATCH |  |
| event:this.spdMain.CellClick | SpdMain_CellClick > FindData_Sub > Find_Data_sub | 1659 | FP\admin\code_lookup#find_code_lookup_sub | MATCH | [sql] foxquery_sql\FP_Admin_code_lookup_find_code_lookup_sub.sql |
| event:this.spdMain.CellClick | SpdMain_CellClick > FindData_Sub > Find_Data_sub | 1663 | biz:AppService.GeneralExecuteQuery [batchId=find_code_lookup_sub] | BIZ_MATCH |  |
| event:this.spdMain.CellClick | SpdMain_CellClick > FindData_Sub > Find_Data_sub | 1663 | scp\admin\code_lookup#find_code_lookup_sub | MATCH | [sql] foxquery_sql\SCP_Admin_code_lookup_find_code_lookup_sub.sql |
| event:this.spdMain.CellClick | SpdMain_CellClick > FindData_Sub > Find_Data_sub | 1666 | biz:QACommonDataBLL.GeneralExecuteQuery [batchId=find_code_lookup_sub] | BIZ_NOT_FOUND |  |
| event:this.spdMain.CellClick | SpdMain_CellClick > FindData_Sub > Find_Data_sub | 1666 | qa\nerp\code_lookup_fp#find_code_lookup_sub | MATCH | [sql] foxquery_sql\QA_NERP_code_lookup_fp_find_code_lookup_sub.sql |
| event:this.spdMain.CellClick | SpdMain_CellClick > FindData_Sub > Find_Data_sub | 1669 | biz:QACommonDataBLL.GeneralExecuteQuery [batchId=find_code_lookup_sub] | BIZ_NOT_FOUND |  |
| event:this.spdMain.CellClick | SpdMain_CellClick > FindData_Sub > Find_Data_sub | 1669 | qa\nerp\code_lookup#find_code_lookup_sub | MATCH | [sql] foxquery_sql\QA_NERP_code_lookup_find_code_lookup_sub.sql |
| event:this.spdMain.KeyUp | spdMain_KeyUp > FindData_Sub > Find_Data_sub | 1659 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_code_lookup_sub] | BIZ_MATCH |  |
| event:this.spdMain.KeyUp | spdMain_KeyUp > FindData_Sub > Find_Data_sub | 1659 | FP\admin\code_lookup#find_code_lookup_sub | MATCH | [sql] foxquery_sql\FP_Admin_code_lookup_find_code_lookup_sub.sql |
| event:this.spdMain.KeyUp | spdMain_KeyUp > FindData_Sub > Find_Data_sub | 1663 | biz:AppService.GeneralExecuteQuery [batchId=find_code_lookup_sub] | BIZ_MATCH |  |
| event:this.spdMain.KeyUp | spdMain_KeyUp > FindData_Sub > Find_Data_sub | 1663 | scp\admin\code_lookup#find_code_lookup_sub | MATCH | [sql] foxquery_sql\SCP_Admin_code_lookup_find_code_lookup_sub.sql |
| event:this.spdMain.KeyUp | spdMain_KeyUp > FindData_Sub > Find_Data_sub | 1666 | biz:QACommonDataBLL.GeneralExecuteQuery [batchId=find_code_lookup_sub] | BIZ_NOT_FOUND |  |
| event:this.spdMain.KeyUp | spdMain_KeyUp > FindData_Sub > Find_Data_sub | 1666 | qa\nerp\code_lookup_fp#find_code_lookup_sub | MATCH | [sql] foxquery_sql\QA_NERP_code_lookup_fp_find_code_lookup_sub.sql |
| event:this.spdMain.KeyUp | spdMain_KeyUp > FindData_Sub > Find_Data_sub | 1669 | biz:QACommonDataBLL.GeneralExecuteQuery [batchId=find_code_lookup_sub] | BIZ_NOT_FOUND |  |
| event:this.spdMain.KeyUp | spdMain_KeyUp > FindData_Sub > Find_Data_sub | 1669 | qa\nerp\code_lookup#find_code_lookup_sub | MATCH | [sql] foxquery_sql\QA_NERP_code_lookup_find_code_lookup_sub.sql |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 39 | biz:CommonData.YesOrNo | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:AppService.GeneralExecuteQuery [batchId=find_code_lookup_sub] | BIZ_MATCH | 1 |  |  |  |
| biz:AppService.GeneralExecuteQuery [batchId=find_code_lookup] | BIZ_MATCH | 1 |  |  |  |
| biz:AppService.GeneralPseudoBatch [batchId=delete_code_lookup] | BIZ_MATCH | 1 |  |  |  |
| biz:AppService.GeneralPseudoBatch [batchId=save_code_lookup_value] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.YesOrNo | BIZ_MATCH | 2 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_code_lookup_sub] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_code_lookup] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=delete_code_lookup_value] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=delete_code_lookup] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_code_lookup_value] | BIZ_MATCH | 1 |  |  |  |
| biz:QACommonDataBLL.GeneralExecuteQuery [batchId=find_code_lookup_sub] | BIZ_NOT_FOUND | 2 |  |  |  |
| biz:QACommonDataBLL.GeneralExecuteQuery [batchId=find_code_lookup] | BIZ_NOT_FOUND | 2 |  |  |  |
| biz:QACommonDataBLL.GeneralPseudoBatch [batchId=delete_code_lookup_value] | BIZ_NOT_FOUND | 3 |  |  |  |
| biz:QACommonDataBLL.GeneralPseudoBatch [batchId=delete_code_lookup] | BIZ_NOT_FOUND | 2 |  |  |  |
| biz:QACommonDataBLL.GeneralPseudoBatch [batchId=save_code_lookup_value] | BIZ_NOT_FOUND | 2 |  |  |  |
| FP\admin\code_lookup#delete_code_lookup | MATCH | 1 | [update-batch]  |  |  |
| FP\admin\code_lookup#delete_code_lookup_value | MATCH | 1 | [update-batch]  |  |  |
| FP\admin\code_lookup#find_code_lookup | MATCH | 1 | [sql] foxquery_sql\FP_Admin_code_lookup_find_code_lookup.sql | SELECT:SCM_CODE_LOOKUP_VALUE |  |
| FP\admin\code_lookup#find_code_lookup_sub | MATCH | 1 | [sql] foxquery_sql\FP_Admin_code_lookup_find_code_lookup_sub.sql | SELECT:SCM_CODE_LOOKUP_VALUE |  |
| FP\admin\code_lookup#save_code_lookup_value | MATCH | 1 | [update-batch]  |  |  |
| qa\nerp\code_lookup_fp#delete_code_lookup | MATCH | 1 | [update-batch]  |  |  |
| qa\nerp\code_lookup_fp#delete_code_lookup_value | MATCH | 1 | [update-batch]  |  |  |
| qa\nerp\code_lookup_fp#find_code_lookup | MATCH | 1 | [sql] foxquery_sql\QA_NERP_code_lookup_fp_find_code_lookup.sql | SELECT:SCM_CODE_LOOKUP_VALUE |  |
| qa\nerp\code_lookup_fp#find_code_lookup_sub | MATCH | 1 | [sql] foxquery_sql\QA_NERP_code_lookup_fp_find_code_lookup_sub.sql | SELECT:SCM_CODE_LOOKUP_VALUE |  |
| qa\nerp\code_lookup_fp#save_code_lookup_value | MATCH | 1 | [update-batch]  |  |  |
| qa\nerp\code_lookup#delete_code_lookup | MATCH | 1 | [update-batch]  |  |  |
| qa\nerp\code_lookup#delete_code_lookup_value | MATCH | 1 | [update-batch]  |  |  |
| qa\nerp\code_lookup#find_code_lookup | MATCH | 1 | [sql] foxquery_sql\QA_NERP_code_lookup_find_code_lookup.sql | SELECT:SCM_CODE_LOOKUP_VALUE |  |
| qa\nerp\code_lookup#find_code_lookup_sub | MATCH | 1 | [sql] foxquery_sql\QA_NERP_code_lookup_find_code_lookup_sub.sql | SELECT:SCM_CODE_LOOKUP_VALUE |  |
| qa\nerp\code_lookup#save_code_lookup_value | MATCH | 1 | [update-batch]  |  |  |
| scp\admin\code_lookup#delete_code_lookup | MATCH | 1 | [update-batch]  |  |  |
| scp\admin\code_lookup#delete_code_lookup_value | MATCH | 1 | [update-batch]  |  |  |
| scp\admin\code_lookup#find_code_lookup | MATCH | 1 | [sql] foxquery_sql\SCP_Admin_code_lookup_find_code_lookup.sql | SELECT:SCM_CODE_LOOKUP_VALUE |  |
| scp\admin\code_lookup#find_code_lookup_sub | MATCH | 1 | [sql] foxquery_sql\SCP_Admin_code_lookup_find_code_lookup_sub.sql | SELECT:SCM_CODE_LOOKUP_VALUE |  |
| scp\admin\code_lookup#save_code_lookup_value | MATCH | 1 | [update-batch]  |  |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| ActiveSheet_CellChanged | Filter | ACTIVE_FLAG |
| btnSql_Click | Application.OpenForms | FPC0099_SqlPopup |
| Find_Data_Amend | Filter | P_SEGMENT1, P_SEGMENT2, P_SEGMENT3, P_SEGMENT4, P_SEGMENT5, USER_ID, P_LOOKUP_TYPE_CODE, V_ACTIVE_FLAG |
| Find_Data_sub | Filter | P_LOOKUP_TYPE_CODE, P_SEGMENT1, P_SEGMENT2, P_SEGMENT3, P_SEGMENT4, P_SEGMENT5, USER_ID, V_ACTIVE_FLAG |
| InitControls | r | CODE, NAME |
| SaveData | r | _OPCODE_, LOOKUP_TYPE_CODE, sort_order |
| SaveData | bindingRow | _OPCODE_ |
| SpdMain_CellClick | Filter | ACTIVE_FLAG |
| SpdMain_CellClick | r | LOOKUP_TYPE_CODE |
| SpdMain_CellDoubleClick | Filter | ACTIVE_FLAG |
| spdMain_KeyUp | Filter | ACTIVE_FLAG |
| UIFindData | Filter | ACTIVE_FLAG |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| DataBind | InitControls:277 | UsrComboBox.DataBind | CODE, NAME |
| EditQuery | RefreshSpreadSheet:538, RefreshSpreadSheet:543 | FPExtensions.EditQuery | ROW_ID |
| SaveData | SaveButton:592 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| FP_PseudoBatch | SaveData:1096, SaveData:1360, SaveData:1382 | DataService.FP_PseudoBatch | COUNT, EXCEPTION, RESULT |
| ReadResult | SaveData:1097, SaveData:1361, SaveData:1383, Find_Data_Amend:1547, Find_Data_sub:1660 | DataService.ReadResult | COUNT, EXCEPTION, RESULT |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.spdMain | KeyUp | spdMain_KeyUp | InitializeComponent:133 |
| this.usrTextBox_Att | KeyUp | usrTextBox_Att_KeyUp | InitializeComponent:276 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:316 |
| this.simpleButton1 | Click | simpleButton1_Click | InitializeComponent:423 |
| this | Load | Form_Load | .ctor:148 |
| this.spdMain | CellClick | SpdMain_CellClick | InitEvent:156 |
| this.spdMain.ActiveSheet | CellChanged | ActiveSheet_CellChanged | InitEvent:157 |
| popSql | OnSql | RunSqlSource | btnSql_Click:1919 |

## 6. 컨트롤 (35개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 10 | layoutControlItem1, layoutControlItem5, layoutControlItem3, layoutControl_segment, layoutControlItem4, layoutControlItem6, layoutControlItem8, layoutControlItem7, layoutControlItem2, layoutControlItem9 |
| EmptySpaceItem | 6 | emptySpaceItem1, emptySpaceItem2, emptySpaceItem3, emptySpaceItem4, emptySpaceItem5, emptySpaceItem6 |
| UsrTextBox | 4 | txtGuide, usrTextBox_Att, txtLookupType, usrTextBox_Seg |
| UsrComboBox | 4 | cboValid, usrComboBox_Seg, SubComboBox_param, cboServerDB |
| FpSpread | 2 | spdMain, spdSub |
| SheetView | 2 | spdMain_Sheet1, spdSub_Sheet1 |
| SplitContainer | 1 | splitContainer1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl1 |
| UsrButton | 1 | btnSql |
| SimpleButton | 1 | simpleButton1 |
| LayoutControlGroup | 1 | layoutControlGroup1 |
| UsrCheckBox | 1 | cbGenTmplate |

## 7. 확인 필요 (11건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 1103 | SaveData | QACommonDataBLL.GeneralPseudoBatch [batchId=delete_code_lookup] | BIZ_NOT_FOUND | BIZ 메서드 없음(DLL 외부 또는 폐기) |
| 1106 | SaveData | QACommonDataBLL.GeneralPseudoBatch [batchId=delete_code_lookup] | BIZ_NOT_FOUND | BIZ 메서드 없음(DLL 외부 또는 폐기) |
| 1367 | SaveData | QACommonDataBLL.GeneralPseudoBatch [batchId=save_code_lookup_value] | BIZ_NOT_FOUND | BIZ 메서드 없음(DLL 외부 또는 폐기) |
| 1370 | SaveData | QACommonDataBLL.GeneralPseudoBatch [batchId=save_code_lookup_value] | BIZ_NOT_FOUND | BIZ 메서드 없음(DLL 외부 또는 폐기) |
| 1386 | SaveData | QACommonDataBLL.GeneralPseudoBatch [batchId=delete_code_lookup_value] | BIZ_NOT_FOUND | BIZ 메서드 없음(DLL 외부 또는 폐기) |
| 1389 | SaveData | QACommonDataBLL.GeneralPseudoBatch [batchId=delete_code_lookup_value] | BIZ_NOT_FOUND | BIZ 메서드 없음(DLL 외부 또는 폐기) |
| 1392 | SaveData | QACommonDataBLL.GeneralPseudoBatch [batchId=delete_code_lookup_value] | BIZ_NOT_FOUND | BIZ 메서드 없음(DLL 외부 또는 폐기) |
| 1553 | Find_Data_Amend | QACommonDataBLL.GeneralExecuteQuery [batchId=find_code_lookup] | BIZ_NOT_FOUND | BIZ 메서드 없음(DLL 외부 또는 폐기) |
| 1556 | Find_Data_Amend | QACommonDataBLL.GeneralExecuteQuery [batchId=find_code_lookup] | BIZ_NOT_FOUND | BIZ 메서드 없음(DLL 외부 또는 폐기) |
| 1666 | Find_Data_sub | QACommonDataBLL.GeneralExecuteQuery [batchId=find_code_lookup_sub] | BIZ_NOT_FOUND | BIZ 메서드 없음(DLL 외부 또는 폐기) |
| 1669 | Find_Data_sub | QACommonDataBLL.GeneralExecuteQuery [batchId=find_code_lookup_sub] | BIZ_NOT_FOUND | BIZ 메서드 없음(DLL 외부 또는 폐기) |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.TB_FX_GroupMenuAuth | 1 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (1건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 653 | SCM.SCM0003_GET_LOOKUP_MASTER | commented:MATCH |

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Lookup Type, Lookup Values

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 316 | 하드코딩 | AddTextColumn | Code Type - Procedure* | LOOKUP_TYPE_CODE | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 317 | 하드코딩 | AddTextColumn | Code Value Descriptionn* | LOOKUP_DESCRIPTION | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 318 | 하드코딩 | AddComboColumn | Active* | ACTIVE_FLAG | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 319 | 하드코딩 | AddTextColumn | Segment1* | SEGMENT1 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 320 | 하드코딩 | AddTextColumn | Segment2* | SEGMENT2 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 321 | 하드코딩 | AddTextColumn | Segment3* | SEGMENT3 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 322 | 하드코딩 | AddTextColumn | Segment4* | SEGMENT4 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 323 | 하드코딩 | AddTextColumn | Segment5* | SEGMENT5 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 324 | 하드코딩 | AddTextColumn | Attribute1 | ATTRIBUTE1 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 325 | 하드코딩 | AddTextColumn | Attribute2 | ATTRIBUTE2 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 326 | 하드코딩 | AddTextColumn | Attribute3 | ATTRIBUTE3 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 327 | 하드코딩 | AddTextColumn | Attribute4 | ATTRIBUTE4 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 328 | 하드코딩 | AddTextColumn | Attribute5 | ATTRIBUTE5 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 329 | 하드코딩 | AddTextColumn | Attribute6 | ATTRIBUTE6 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 330 | 하드코딩 | AddTextColumn | Attribute7 | ATTRIBUTE7 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 331 | 하드코딩 | AddTextColumn | Attribute8 | ATTRIBUTE8 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 332 | 하드코딩 | AddTextColumn | Attribute9 | ATTRIBUTE9 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 333 | 하드코딩 | AddTextColumn | Attribute10 | ATTRIBUTE10 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 334 | 하드코딩 | AddTextColumn | Attribute11 | ATTRIBUTE11 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 335 | 하드코딩 | AddTextColumn | Attribute12 | ATTRIBUTE12 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 336 | 하드코딩 | AddTextColumn | Attribute13 | ATTRIBUTE13 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 337 | 하드코딩 | AddTextColumn | Attribute14 | ATTRIBUTE14 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 338 | 하드코딩 | AddTextColumn | Attribute15 | ATTRIBUTE15 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 341 | 하드코딩 | AddDateTimeColumn | Last Update | MODIFY_DATE | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 342 | 하드코딩 | AddTextColumn | Update ID | modify_user_id | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 354 | 하드코딩 | AddTextColumn | lookup type code* | LOOKUP_TYPE_CODE | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 355 | 하드코딩 | AddTextColumn | Segment1 | SEGMENT1 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 356 | 하드코딩 | AddTextColumn | Segment2 | SEGMENT2 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 357 | 하드코딩 | AddTextColumn | Segment3 | SEGMENT3 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 358 | 하드코딩 | AddTextColumn | Segment4 | SEGMENT4 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 359 | 하드코딩 | AddTextColumn | Segment5 | SEGMENT5 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 360 | 하드코딩 | AddComboColumn | Active | ACTIVE_FLAG | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 361 | 하드코딩 | AddTextColumn | Attribute1 | ATTRIBUTE1 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 362 | 하드코딩 | AddTextColumn | Attribute2 | ATTRIBUTE2 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 363 | 하드코딩 | AddTextColumn | Attribute3 | ATTRIBUTE3 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 364 | 하드코딩 | AddTextColumn | Attribute4 | ATTRIBUTE4 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 365 | 하드코딩 | AddTextColumn | Attribute5 | ATTRIBUTE5 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 366 | 하드코딩 | AddTextColumn | Attribute6 | ATTRIBUTE6 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 367 | 하드코딩 | AddTextColumn | Attribute7 | ATTRIBUTE7 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 368 | 하드코딩 | AddTextColumn | Attribute8 | ATTRIBUTE8 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 369 | 하드코딩 | AddTextColumn | Attribute9 | ATTRIBUTE9 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 370 | 하드코딩 | AddTextColumn | Attribute10 | ATTRIBUTE10 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 371 | 하드코딩 | AddTextColumn | Attribute11 | ATTRIBUTE11 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 372 | 하드코딩 | AddTextColumn | Attribute12 | ATTRIBUTE12 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 373 | 하드코딩 | AddTextColumn | Attribute13 | ATTRIBUTE13 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 374 | 하드코딩 | AddTextColumn | Attribute14 | ATTRIBUTE14 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 375 | 하드코딩 | AddTextColumn | Attribute15 | ATTRIBUTE15 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 376 | 하드코딩 | AddTextColumn | Sort Order | SORT_ORDER | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 377 | 하드코딩 | AddTextColumn | Value Description | VALUE_DESCRIPTION | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 382 | 하드코딩 | AddDateTimeColumn | Last Update Date | MODIFY_DATE | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 383 | 하드코딩 | AddTextColumn | Last Updated By | modify_user_id | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 386 | 하드코딩 | AddTextColumn | Segment1 | SEGMENT1_KEY | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 387 | 하드코딩 | AddTextColumn | Segment2 | SEGMENT2_KEY | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 388 | 하드코딩 | AddTextColumn | Segment3 | SEGMENT3_KEY | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 389 | 하드코딩 | AddTextColumn | Segment4 | SEGMENT4_KEY | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 390 | 하드코딩 | AddTextColumn | Segment5 | SEGMENT5_KEY | if(spreadInfo.SheetName == "Lookup Values") |
| InitializeComponent |  | 149 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 150 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 151 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 152 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 660 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 661 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 662 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 663 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Lookup Type | 코드 하드코딩 전용(메타 없음) | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 | 25 |
| Lookup Values | 코드 하드코딩 전용(메타 없음) | 31 | 31 | 31 | 31 | 31 | 31 | 31 | 31 | 31 | 31 | 31 | 31 | 31 | 31 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
