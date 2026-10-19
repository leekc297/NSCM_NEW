# FP00631 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00631_Cell_Simul_Cell_Pack.UIL\FP00631_Cell_Simul_Cell_Pack_2.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00631_Cell_Simul_Cell_Pack.UIL\FP00631_Cell_Simul_Cell_Pack.UIL.csproj | 5649 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00631_Cell_Simul_Cell_Pack.UIL\FP00631_Cell_Simul_Cell_Pack_3.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00631_Cell_Simul_Cell_Pack.UIL\FP00631_Cell_Simul_Cell_Pack.UIL.csproj | 5649 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00631_Cell_Simul_Cell_Pack.UIL\FP00631_Cell_Simul_Cell_Pack.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00631_Cell_Simul_Cell_Pack.UIL\FP00631_Cell_Simul_Cell_Pack.UIL.csproj | 7493 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00631_Cell_Simul_Cell_Pack.UIL\FP00631_Cell_Simul_Cell_Pack.designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00631_Cell_Simul_Cell_Pack.UIL\FP00631_Cell_Simul_Cell_Pack.UIL.csproj | 1779 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00631_Cell_Simul_Cell_Pack.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Planning\FP00631_Cell_Simul_Cell_Pack.UIL\FP00631_Cell_Simul_Cell_Pack.UIL.csproj | 37 |
| shared | 06.UIL\GSCM.FP.Planning.UIL\FP00631_CellSimul_CellPack.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 5222 |
| shared | 06.UIL\GSCM.FP.Planning.UIL\FP00631_CellSimul_CellPack.designer.cs | 06.UIL\GSCM.FP.Planning.UIL\GSCM.FP.Planning.UIL.csproj | 2326 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cbo_pack_plan_group.SelectedIndexChanged | cbo_pack_plan_group_changed > GetCurrDate | 1453 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_currdate] | BIZ_MATCH |  |
| event:cbo_pack_plan_group.SelectedIndexChanged | cbo_pack_plan_group_changed > GetCurrDate | 1453 | FP\Planning\FP00631_CellSimul_CellPack#find_currdate | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_currdate.sql |
| event:cbo_pack_plan_group.SelectedIndexChanged | cbo_pack_plan_group_changed > GetLastReleaseTime | 1463 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LastestReleaseTime] | BIZ_MATCH |  |
| event:cbo_pack_plan_group.SelectedIndexChanged | cbo_pack_plan_group_changed > GetLastReleaseTime | 1463 | FP\Planning\FP00631_CellSimul_CellPack#find_LastestReleaseTime | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_LastestReleaseTime.sql |
| event:cbo_pack_plan_group.SelectedIndexChanged | cbo_pack_plan_group_changed > GetCurrDate | 1927 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_currdate] | BIZ_MATCH |  |
| event:cbo_pack_plan_group.SelectedIndexChanged | cbo_pack_plan_group_changed > GetCurrDate | 1927 | FP\Planning\FP00631_CellSimul_CellPack#find_currdate | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_currdate.sql |
| event:cbo_pack_plan_group.SelectedIndexChanged | cbo_pack_plan_group_changed > GetLastReleaseTime | 1937 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LastestReleaseTime] | BIZ_MATCH |  |
| event:cbo_pack_plan_group.SelectedIndexChanged | cbo_pack_plan_group_changed > GetLastReleaseTime | 1937 | FP\Planning\FP00631_CellSimul_CellPack#find_LastestReleaseTime | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_LastestReleaseTime.sql |
| event:cbo_pack_plan_group.SelectedIndexChanged | cbo_pack_plan_group_changed > GetCurrDate | 1942 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_currdate] | BIZ_MATCH |  |
| event:cbo_pack_plan_group.SelectedIndexChanged | cbo_pack_plan_group_changed > GetCurrDate | 1942 | FP\Planning\FP00631_CellSimul_CellPack#find_currdate | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_currdate.sql |
| event:cbo_pack_plan_group.SelectedIndexChanged | cbo_pack_plan_group_changed > GetCurrDate | 1942 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_currdate] | BIZ_MATCH |  |
| event:cbo_pack_plan_group.SelectedIndexChanged | cbo_pack_plan_group_changed > GetCurrDate | 1942 | FP\Planning\FP00631_CellSimul_CellPack#find_currdate | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_currdate.sql |
| event:cbo_pack_plan_group.SelectedIndexChanged | cbo_pack_plan_group_changed > GetLastReleaseTime | 1952 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LastestReleaseTime] | BIZ_MATCH |  |
| event:cbo_pack_plan_group.SelectedIndexChanged | cbo_pack_plan_group_changed > GetLastReleaseTime | 1952 | FP\Planning\FP00631_CellSimul_CellPack#find_LastestReleaseTime | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_LastestReleaseTime.sql |
| event:cbo_pack_plan_group.SelectedIndexChanged | cbo_pack_plan_group_changed > GetLastReleaseTime | 1952 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LastestReleaseTime] | BIZ_MATCH |  |
| event:cbo_pack_plan_group.SelectedIndexChanged | cbo_pack_plan_group_changed > GetLastReleaseTime | 1952 | FP\Planning\FP00631_CellSimul_CellPack#find_LastestReleaseTime | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_LastestReleaseTime.sql |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > GetInstance | 1410 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instance] | BIZ_MATCH |  |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > GetInstance | 1410 | FP\Planning\FP00631_CellSimul_CellPack#find_instance | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_instance.sql |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > GetInstance > cbo_pack_plan_group_changed > GetCurrDate | 1453 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_currdate] | BIZ_MATCH |  |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > GetInstance > cbo_pack_plan_group_changed > GetCurrDate | 1453 | FP\Planning\FP00631_CellSimul_CellPack#find_currdate | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_currdate.sql |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > GetInstance > cbo_pack_plan_group_changed > GetLastReleaseTime | 1463 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LastestReleaseTime] | BIZ_MATCH |  |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > GetInstance > cbo_pack_plan_group_changed > GetLastReleaseTime | 1463 | FP\Planning\FP00631_CellSimul_CellPack#find_LastestReleaseTime | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_LastestReleaseTime.sql |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > GetInstance | 1892 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instance] | BIZ_MATCH |  |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > GetInstance | 1892 | FP\Planning\FP00631_CellSimul_CellPack#find_instance | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_instance.sql |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > GetInstance | 1904 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instance] | BIZ_MATCH |  |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > GetInstance | 1904 | FP\Planning\FP00631_CellSimul_CellPack#find_instance | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_instance.sql |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > GetInstance | 1904 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instance] | BIZ_MATCH |  |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > GetInstance | 1904 | FP\Planning\FP00631_CellSimul_CellPack#find_instance | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_instance.sql |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > GetInstance > cbo_pack_plan_group_changed > GetCurrDate | 1942 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_currdate] | BIZ_MATCH |  |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > GetInstance > cbo_pack_plan_group_changed > GetCurrDate | 1942 | FP\Planning\FP00631_CellSimul_CellPack#find_currdate | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_currdate.sql |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > GetInstance > cbo_pack_plan_group_changed > GetCurrDate | 1942 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_currdate] | BIZ_MATCH |  |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > GetInstance > cbo_pack_plan_group_changed > GetCurrDate | 1942 | FP\Planning\FP00631_CellSimul_CellPack#find_currdate | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_currdate.sql |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > GetInstance > cbo_pack_plan_group_changed > GetLastReleaseTime | 1952 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LastestReleaseTime] | BIZ_MATCH |  |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > GetInstance > cbo_pack_plan_group_changed > GetLastReleaseTime | 1952 | FP\Planning\FP00631_CellSimul_CellPack#find_LastestReleaseTime | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_LastestReleaseTime.sql |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > GetInstance > cbo_pack_plan_group_changed > GetLastReleaseTime | 1952 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LastestReleaseTime] | BIZ_MATCH |  |
| event:cbo_site.SelectedIndexChanged | cbo_site_changed > GetInstance > cbo_pack_plan_group_changed > GetLastReleaseTime | 1952 | FP\Planning\FP00631_CellSimul_CellPack#find_LastestReleaseTime | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_LastestReleaseTime.sql |
| event:date_instance.ValueChanged | plan_day_changed > GetListBucketDate | 1472 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bucketdate] | BIZ_MATCH |  |
| event:date_instance.ValueChanged | plan_day_changed > GetListBucketDate | 1472 | FP\Planning\FP00631_CellSimul_CellPack#find_bucketdate | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_bucketdate.sql |
| event:date_instance.ValueChanged | plan_day_changed > GetPlan | 1493 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:date_instance.ValueChanged | plan_day_changed > GetPlan | 1493 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:date_instance.ValueChanged | plan_day_changed > GetPlan | 1515 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:date_instance.ValueChanged | plan_day_changed > GetPlan | 1515 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:date_instance.ValueChanged | plan_day_changed > GetPlan | 1536 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:date_instance.ValueChanged | plan_day_changed > GetPlan | 1536 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:date_instance.ValueChanged | plan_day_changed > GetListBucketDate | 1946 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bucketdate] | BIZ_MATCH |  |
| event:date_instance.ValueChanged | plan_day_changed > GetListBucketDate | 1946 | FP\Planning\FP00631_CellSimul_CellPack#find_bucketdate | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_bucketdate.sql |
| event:date_instance.ValueChanged | plan_day_changed > GetListBucketDate | 1961 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bucketdate] | BIZ_MATCH |  |
| event:date_instance.ValueChanged | plan_day_changed > GetListBucketDate | 1961 | FP\Planning\FP00631_CellSimul_CellPack#find_bucketdate | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_bucketdate.sql |
| event:date_instance.ValueChanged | plan_day_changed > GetListBucketDate | 1961 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bucketdate] | BIZ_MATCH |  |
| event:date_instance.ValueChanged | plan_day_changed > GetListBucketDate | 1961 | FP\Planning\FP00631_CellSimul_CellPack#find_bucketdate | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_bucketdate.sql |
| event:date_instance.ValueChanged | plan_day_changed > GetPlan | 1967 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:date_instance.ValueChanged | plan_day_changed > GetPlan | 1967 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:date_instance.ValueChanged | plan_day_changed > GetPlan | 1982 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:date_instance.ValueChanged | plan_day_changed > GetPlan | 1982 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:date_instance.ValueChanged | plan_day_changed > GetPlan | 1982 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:date_instance.ValueChanged | plan_day_changed > GetPlan | 1982 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:date_instance.ValueChanged | plan_day_changed > GetPlan | 1985 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:date_instance.ValueChanged | plan_day_changed > GetPlan | 1985 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:date_instance.ValueChanged | plan_day_changed > GetPlan | 2003 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:date_instance.ValueChanged | plan_day_changed > GetPlan | 2003 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:date_instance.ValueChanged | plan_day_changed > GetPlan | 2004 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:date_instance.ValueChanged | plan_day_changed > GetPlan | 2004 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:date_instance.ValueChanged | plan_day_changed > GetPlan | 2004 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:date_instance.ValueChanged | plan_day_changed > GetPlan | 2004 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:date_instance.ValueChanged | plan_day_changed > GetPlan | 2025 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:date_instance.ValueChanged | plan_day_changed > GetPlan | 2025 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:date_instance.ValueChanged | plan_day_changed > GetPlan | 2025 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:date_instance.ValueChanged | plan_day_changed > GetPlan | 2025 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:date_instance.ValueChanged | plan_day_changed | 4442 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:date_instance.ValueChanged | plan_day_changed | 4442 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:date_instance.ValueChanged | plan_day_changed | 4443 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:date_instance.ValueChanged | plan_day_changed | 4443 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:date_instance.ValueChanged | plan_day_changed | 4444 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:date_instance.ValueChanged | plan_day_changed | 4444 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:date_instance.ValueChanged | plan_day_changed | 4863 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:date_instance.ValueChanged | plan_day_changed | 4863 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:date_instance.ValueChanged | plan_day_changed | 4863 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:date_instance.ValueChanged | plan_day_changed | 4863 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:date_instance.ValueChanged | plan_day_changed | 4864 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:date_instance.ValueChanged | plan_day_changed | 4864 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:date_instance.ValueChanged | plan_day_changed | 4864 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:date_instance.ValueChanged | plan_day_changed | 4864 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:date_instance.ValueChanged | plan_day_changed | 4865 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:date_instance.ValueChanged | plan_day_changed | 4865 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:date_instance.ValueChanged | plan_day_changed | 4865 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:date_instance.ValueChanged | plan_day_changed | 4865 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:date_instance.ValueChanged | plan_day_changed | 6874 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:date_instance.ValueChanged | plan_day_changed | 6874 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:date_instance.ValueChanged | plan_day_changed | 6875 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:date_instance.ValueChanged | plan_day_changed | 6875 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:date_instance.ValueChanged | plan_day_changed | 6876 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:date_instance.ValueChanged | plan_day_changed | 6876 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| button:FindButton | FindButton > UIFindData > SetReleaseProcess | 1203 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isCurrWeek] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > SetReleaseProcess | 1203 | FP\Common\XpCommonAmend#find_isCurrWeek | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_isCurrWeek.sql |
| button:FindButton | FindButton > UIFindData > FindTotalValue > GetInstance | 1410 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instance] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindTotalValue > GetInstance | 1410 | FP\Planning\FP00631_CellSimul_CellPack#find_instance | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_instance.sql |
| button:FindButton | FindButton > UIFindData > FindTotalValue > GetInstance > cbo_pack_plan_group_changed > GetCurrDate | 1453 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_currdate] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindTotalValue > GetInstance > cbo_pack_plan_group_changed > GetCurrDate | 1453 | FP\Planning\FP00631_CellSimul_CellPack#find_currdate | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_currdate.sql |
| button:FindButton | FindButton > UIFindData > FindTotalValue > GetInstance > cbo_pack_plan_group_changed > GetLastReleaseTime | 1463 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LastestReleaseTime] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindTotalValue > GetInstance > cbo_pack_plan_group_changed > GetLastReleaseTime | 1463 | FP\Planning\FP00631_CellSimul_CellPack#find_LastestReleaseTime | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_LastestReleaseTime.sql |
| button:FindButton | FindButton > UIFindData > SetReleaseProcess | 1671 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isCurrWeek] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > SetReleaseProcess | 1671 | FP\Common\XpCommonAmend#find_isCurrWeek | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_isCurrWeek.sql |
| button:FindButton | FindButton > UIFindData > SetReleaseProcess | 1682 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isCurrWeek] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > SetReleaseProcess | 1682 | FP\Common\XpCommonAmend#find_isCurrWeek | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_isCurrWeek.sql |
| button:FindButton | FindButton > UIFindData > SetReleaseProcess | 1682 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isCurrWeek] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > SetReleaseProcess | 1682 | FP\Common\XpCommonAmend#find_isCurrWeek | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_isCurrWeek.sql |
| button:FindButton | FindButton > UIFindData > FindMainData | 1756 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData | 1756 | FP\Planning\FP00631_CellSimul_CellPack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_Release_Plan_list.sql |
| button:FindButton | FindButton > UIFindData > FindMainData | 1784 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData | 1784 | FP\Planning\FP00631_CellSimul_CellPack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_Release_Plan_list.sql |
| button:FindButton | FindButton > UIFindData > FindMainData | 1812 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData | 1812 | FP\Planning\FP00631_CellSimul_CellPack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_Release_Plan_list.sql |
| button:FindButton | FindButton > UIFindData > FindTotalValue > GetInstance | 1892 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instance] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindTotalValue > GetInstance | 1892 | FP\Planning\FP00631_CellSimul_CellPack#find_instance | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_instance.sql |
| button:FindButton | FindButton > UIFindData > FindTotalValue > GetInstance | 1904 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instance] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindTotalValue > GetInstance | 1904 | FP\Planning\FP00631_CellSimul_CellPack#find_instance | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_instance.sql |
| button:FindButton | FindButton > UIFindData > FindTotalValue > GetInstance | 1904 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instance] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindTotalValue > GetInstance | 1904 | FP\Planning\FP00631_CellSimul_CellPack#find_instance | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_instance.sql |
| button:FindButton | FindButton > UIFindData > FindTotalValue > GetInstance > cbo_pack_plan_group_changed > GetCurrDate | 1942 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_currdate] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindTotalValue > GetInstance > cbo_pack_plan_group_changed > GetCurrDate | 1942 | FP\Planning\FP00631_CellSimul_CellPack#find_currdate | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_currdate.sql |
| button:FindButton | FindButton > UIFindData > FindTotalValue > GetInstance > cbo_pack_plan_group_changed > GetCurrDate | 1942 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_currdate] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindTotalValue > GetInstance > cbo_pack_plan_group_changed > GetCurrDate | 1942 | FP\Planning\FP00631_CellSimul_CellPack#find_currdate | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_currdate.sql |
| button:FindButton | FindButton > UIFindData > FindTotalValue > GetInstance > cbo_pack_plan_group_changed > GetLastReleaseTime | 1952 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LastestReleaseTime] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindTotalValue > GetInstance > cbo_pack_plan_group_changed > GetLastReleaseTime | 1952 | FP\Planning\FP00631_CellSimul_CellPack#find_LastestReleaseTime | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_LastestReleaseTime.sql |
| button:FindButton | FindButton > UIFindData > FindTotalValue > GetInstance > cbo_pack_plan_group_changed > GetLastReleaseTime | 1952 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LastestReleaseTime] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindTotalValue > GetInstance > cbo_pack_plan_group_changed > GetLastReleaseTime | 1952 | FP\Planning\FP00631_CellSimul_CellPack#find_LastestReleaseTime | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_LastestReleaseTime.sql |
| button:FindButton | FindButton > UIFindData > FindListData | 2198 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindListData | 2198 | FP\Planning\FP00631_CellSimul_CellPack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_Release_Plan_list.sql |
| button:FindButton | FindButton > UIFindData > FindListData | 2226 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindListData | 2226 | FP\Planning\FP00631_CellSimul_CellPack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_Release_Plan_list.sql |
| button:FindButton | FindButton > UIFindData > FindMainData | 2239 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData | 2239 | FP\Planning\FP00631_CellSimul_CellPack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_Release_Plan_list.sql |
| button:FindButton | FindButton > UIFindData > FindMainData | 2239 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData | 2239 | FP\Planning\FP00631_CellSimul_CellPack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_Release_Plan_list.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2253 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2253 | FP\Common\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_WeekCnt.sql |
| button:FindButton | FindButton > UIFindData > FindListData | 2254 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindListData | 2254 | FP\Planning\FP00631_CellSimul_CellPack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_Release_Plan_list.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2254 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2254 | FP\Common\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_DateMap.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2255 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2255 | FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2256 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2256 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo.sql |
| button:FindButton | FindButton > UIFindData > FindMainData | 2267 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData | 2267 | FP\Planning\FP00631_CellSimul_CellPack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_Release_Plan_list.sql |
| button:FindButton | FindButton > UIFindData > FindMainData | 2267 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData | 2267 | FP\Planning\FP00631_CellSimul_CellPack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_Release_Plan_list.sql |
| button:FindButton | FindButton > UIFindData > FindListData | 2294 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BOM_RATE] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindListData | 2294 | FP\Planning\FP00631_CELLSIMUL_CELLPACK#find_BOM_RATE | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_BOM_RATE.sql |
| button:FindButton | FindButton > UIFindData > FindListData | 2295 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_YLD_F6000] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindListData | 2295 | FP\Planning\FP00631_CELLSIMUL_CELLPACK#find_YLD_F6000 | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_YLD_F6000.sql |
| button:FindButton | FindButton > UIFindData > FindMainData | 2295 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData | 2295 | FP\Planning\FP00631_CellSimul_CellPack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_Release_Plan_list.sql |
| button:FindButton | FindButton > UIFindData > FindMainData | 2295 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData | 2295 | FP\Planning\FP00631_CellSimul_CellPack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_Release_Plan_list.sql |
| button:FindButton | FindButton > UIFindData > FindListData | 2296 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AGING_STOCK] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindListData | 2296 | FP\Planning\FP00631_CELLSIMUL_CELLPACK#find_AGING_STOCK | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_AGING_STOCK.sql |
| button:FindButton | FindButton > UIFindData > FindListData | 2297 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Cell_ExchangeValue] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindListData | 2297 | FP\Planning\FP00631_CELLSIMUL_CELLPACK#find_Cell_ExchangeValue | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_Cell_ExchangeValue.sql |
| button:FindButton | FindButton > UIFindData > FindListData | 2299 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yield_F1000] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindListData | 2299 | FP\Planning\FP00631_CELLSIMUL_CELLPACK#find_yield_F1000 | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_yield_F1000.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2318 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2318 | FP\Common\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_WeekCnt.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2319 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2319 | FP\Common\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_DateMap.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2320 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2320 | FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2321 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2321 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2667 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2667 | FP\Common\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_WeekCnt.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2667 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2667 | FP\Common\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_WeekCnt.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2668 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2668 | FP\Common\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_DateMap.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2668 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2668 | FP\Common\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_DateMap.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2669 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2669 | FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2669 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2669 | FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2670 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2670 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo.sql |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2670 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| button:FindButton | FindButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2670 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo.sql |
| button:InsertButton | InsertButton > UIFindData > SetReleaseProcess | 1671 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isCurrWeek] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > SetReleaseProcess | 1671 | FP\Common\XpCommonAmend#find_isCurrWeek | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_isCurrWeek.sql |
| button:InsertButton | InsertButton > UIFindData > FindTotalValue > GetInstance | 1892 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instance] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > FindTotalValue > GetInstance | 1892 | FP\Planning\FP00631_CellSimul_CellPack#find_instance | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_instance.sql |
| button:InsertButton | InsertButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2253 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2253 | FP\Common\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_WeekCnt.sql |
| button:InsertButton | InsertButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2254 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2254 | FP\Common\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_DateMap.sql |
| button:InsertButton | InsertButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2255 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2255 | FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql |
| button:InsertButton | InsertButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2256 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| button:InsertButton | InsertButton > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2256 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData | 1756 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData | 1756 | FP\Planning\FP00631_CellSimul_CellPack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_Release_Plan_list.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData | 1784 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData | 1784 | FP\Planning\FP00631_CellSimul_CellPack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_Release_Plan_list.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData | 1812 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData | 1812 | FP\Planning\FP00631_CellSimul_CellPack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_Release_Plan_list.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData | 2239 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData | 2239 | FP\Planning\FP00631_CellSimul_CellPack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_Release_Plan_list.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData | 2239 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData | 2239 | FP\Planning\FP00631_CellSimul_CellPack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_Release_Plan_list.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2253 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2253 | FP\Common\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_WeekCnt.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2254 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2254 | FP\Common\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_DateMap.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2255 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2255 | FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2256 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2256 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData | 2267 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData | 2267 | FP\Planning\FP00631_CellSimul_CellPack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_Release_Plan_list.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData | 2267 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData | 2267 | FP\Planning\FP00631_CellSimul_CellPack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_Release_Plan_list.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData | 2295 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData | 2295 | FP\Planning\FP00631_CellSimul_CellPack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_Release_Plan_list.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData | 2295 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData | 2295 | FP\Planning\FP00631_CellSimul_CellPack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_Release_Plan_list.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2318 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2318 | FP\Common\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_WeekCnt.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2319 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2319 | FP\Common\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_DateMap.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2320 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2320 | FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2321 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2321 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2667 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2667 | FP\Common\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_WeekCnt.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2667 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2667 | FP\Common\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_WeekCnt.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2668 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2668 | FP\Common\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_DateMap.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2668 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2668 | FP\Common\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_DateMap.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2669 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2669 | FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2669 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2669 | FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2670 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2670 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo.sql |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2670 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| event:popSql.OnSql | RunSqlSource > FindMainData > ApplyAmendCalendarCondition | 2670 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo.sql |
| button:SaveButton | SaveButton > UISaveData > Save_Data | 1069 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > Save_Data | 1069 | FP\Common\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonCond_find_AMend_Save_Check.sql |
| button:SaveButton | SaveButton > UISaveData > Save_Data | 1090 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=saveAll_MPPWPP] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > Save_Data | 1090 | FP\Common\FP00602_PlanAmendLineAssy#saveAll_MPPWPP | MATCH_PATTERN | [update-batch]  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > SetReleaseProcess | 1203 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isCurrWeek] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > SetReleaseProcess | 1203 | FP\Common\XpCommonAmend#find_isCurrWeek | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_isCurrWeek.sql |
| button:SaveButton | SaveButton > UISaveData > Save_Data | 1205 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > Save_Data | 1205 | FP\Common\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonCond_find_AMend_Save_Check.sql |
| button:SaveButton | SaveButton > UISaveData > Save_Data | 1216 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > Save_Data | 1216 | FP\Common\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonCond_find_AMend_Save_Check.sql |
| button:SaveButton | SaveButton > UISaveData > Save_Data | 1216 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > Save_Data | 1216 | FP\Common\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonCond_find_AMend_Save_Check.sql |
| button:SaveButton | SaveButton > UISaveData > Save_Data | 1226 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=saveAll_MPPWPP] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > Save_Data | 1226 | FP\Common\FP00602_PlanAmendLineAssy#saveAll_MPPWPP | MATCH_PATTERN | [update-batch]  |
| button:SaveButton | SaveButton > UISaveData > Save_Data | 1237 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=saveAll_MPPWPP] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > Save_Data | 1237 | FP\Common\FP00602_PlanAmendLineAssy#saveAll_MPPWPP | MATCH_PATTERN | [update-batch]  |
| button:SaveButton | SaveButton > UISaveData > Save_Data | 1237 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=saveAll_MPPWPP] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > Save_Data | 1237 | FP\Common\FP00602_PlanAmendLineAssy#saveAll_MPPWPP | MATCH_PATTERN | [update-batch]  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindTotalValue > GetInstance | 1410 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instance] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindTotalValue > GetInstance | 1410 | FP\Planning\FP00631_CellSimul_CellPack#find_instance | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_instance.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindTotalValue > GetInstance > cbo_pack_plan_group_changed > GetCurrDate | 1453 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_currdate] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindTotalValue > GetInstance > cbo_pack_plan_group_changed > GetCurrDate | 1453 | FP\Planning\FP00631_CellSimul_CellPack#find_currdate | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_currdate.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindTotalValue > GetInstance > cbo_pack_plan_group_changed > GetLastReleaseTime | 1463 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LastestReleaseTime] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindTotalValue > GetInstance > cbo_pack_plan_group_changed > GetLastReleaseTime | 1463 | FP\Planning\FP00631_CellSimul_CellPack#find_LastestReleaseTime | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_LastestReleaseTime.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > SetReleaseProcess | 1671 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isCurrWeek] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > SetReleaseProcess | 1671 | FP\Common\XpCommonAmend#find_isCurrWeek | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_isCurrWeek.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > SetReleaseProcess | 1682 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isCurrWeek] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > SetReleaseProcess | 1682 | FP\Common\XpCommonAmend#find_isCurrWeek | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_isCurrWeek.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > SetReleaseProcess | 1682 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isCurrWeek] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > SetReleaseProcess | 1682 | FP\Common\XpCommonAmend#find_isCurrWeek | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_isCurrWeek.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData | 1756 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData | 1756 | FP\Planning\FP00631_CellSimul_CellPack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_Release_Plan_list.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData | 1784 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData | 1784 | FP\Planning\FP00631_CellSimul_CellPack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_Release_Plan_list.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData | 1812 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData | 1812 | FP\Planning\FP00631_CellSimul_CellPack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_Release_Plan_list.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindTotalValue > GetInstance | 1892 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instance] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindTotalValue > GetInstance | 1892 | FP\Planning\FP00631_CellSimul_CellPack#find_instance | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_instance.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindTotalValue > GetInstance | 1904 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instance] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindTotalValue > GetInstance | 1904 | FP\Planning\FP00631_CellSimul_CellPack#find_instance | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_instance.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindTotalValue > GetInstance | 1904 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instance] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindTotalValue > GetInstance | 1904 | FP\Planning\FP00631_CellSimul_CellPack#find_instance | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_instance.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindTotalValue > GetInstance > cbo_pack_plan_group_changed > GetCurrDate | 1942 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_currdate] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindTotalValue > GetInstance > cbo_pack_plan_group_changed > GetCurrDate | 1942 | FP\Planning\FP00631_CellSimul_CellPack#find_currdate | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_currdate.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindTotalValue > GetInstance > cbo_pack_plan_group_changed > GetCurrDate | 1942 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_currdate] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindTotalValue > GetInstance > cbo_pack_plan_group_changed > GetCurrDate | 1942 | FP\Planning\FP00631_CellSimul_CellPack#find_currdate | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_currdate.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindTotalValue > GetInstance > cbo_pack_plan_group_changed > GetLastReleaseTime | 1952 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LastestReleaseTime] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindTotalValue > GetInstance > cbo_pack_plan_group_changed > GetLastReleaseTime | 1952 | FP\Planning\FP00631_CellSimul_CellPack#find_LastestReleaseTime | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_LastestReleaseTime.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindTotalValue > GetInstance > cbo_pack_plan_group_changed > GetLastReleaseTime | 1952 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LastestReleaseTime] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindTotalValue > GetInstance > cbo_pack_plan_group_changed > GetLastReleaseTime | 1952 | FP\Planning\FP00631_CellSimul_CellPack#find_LastestReleaseTime | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_LastestReleaseTime.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindListData | 2198 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindListData | 2198 | FP\Planning\FP00631_CellSimul_CellPack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_Release_Plan_list.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindListData | 2226 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindListData | 2226 | FP\Planning\FP00631_CellSimul_CellPack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_Release_Plan_list.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData | 2239 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData | 2239 | FP\Planning\FP00631_CellSimul_CellPack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_Release_Plan_list.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData | 2239 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData | 2239 | FP\Planning\FP00631_CellSimul_CellPack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_Release_Plan_list.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2253 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2253 | FP\Common\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_WeekCnt.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindListData | 2254 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindListData | 2254 | FP\Planning\FP00631_CellSimul_CellPack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_Release_Plan_list.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2254 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2254 | FP\Common\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_DateMap.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2255 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2255 | FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2256 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2256 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData | 2267 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData | 2267 | FP\Planning\FP00631_CellSimul_CellPack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_Release_Plan_list.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData | 2267 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData | 2267 | FP\Planning\FP00631_CellSimul_CellPack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_Release_Plan_list.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindListData | 2294 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BOM_RATE] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindListData | 2294 | FP\Planning\FP00631_CELLSIMUL_CELLPACK#find_BOM_RATE | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_BOM_RATE.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindListData | 2295 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_YLD_F6000] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindListData | 2295 | FP\Planning\FP00631_CELLSIMUL_CELLPACK#find_YLD_F6000 | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_YLD_F6000.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData | 2295 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData | 2295 | FP\Planning\FP00631_CellSimul_CellPack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_Release_Plan_list.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData | 2295 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData | 2295 | FP\Planning\FP00631_CellSimul_CellPack#find_Release_Plan_list | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_Release_Plan_list.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindListData | 2296 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AGING_STOCK] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindListData | 2296 | FP\Planning\FP00631_CELLSIMUL_CELLPACK#find_AGING_STOCK | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_AGING_STOCK.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindListData | 2297 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Cell_ExchangeValue] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindListData | 2297 | FP\Planning\FP00631_CELLSIMUL_CELLPACK#find_Cell_ExchangeValue | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_Cell_ExchangeValue.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindListData | 2299 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yield_F1000] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindListData | 2299 | FP\Planning\FP00631_CELLSIMUL_CELLPACK#find_yield_F1000 | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_yield_F1000.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2318 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2318 | FP\Common\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_WeekCnt.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2319 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2319 | FP\Common\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_DateMap.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2320 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2320 | FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2321 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2321 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2667 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2667 | FP\Common\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_WeekCnt.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2667 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2667 | FP\Common\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_WeekCnt.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2668 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2668 | FP\Common\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_DateMap.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2668 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2668 | FP\Common\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_DateMap.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2669 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2669 | FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2669 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2669 | FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2670 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2670 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo.sql |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2670 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > UISaveData > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2670 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo.sql |
| event:this.btn_column.Click | btnColumn_Click > FindTotalValue > GetInstance | 1410 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instance] | BIZ_MATCH |  |
| event:this.btn_column.Click | btnColumn_Click > FindTotalValue > GetInstance | 1410 | FP\Planning\FP00631_CellSimul_CellPack#find_instance | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_instance.sql |
| event:this.btn_column.Click | btnColumn_Click > FindTotalValue > GetInstance > cbo_pack_plan_group_changed > GetCurrDate | 1453 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_currdate] | BIZ_MATCH |  |
| event:this.btn_column.Click | btnColumn_Click > FindTotalValue > GetInstance > cbo_pack_plan_group_changed > GetCurrDate | 1453 | FP\Planning\FP00631_CellSimul_CellPack#find_currdate | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_currdate.sql |
| event:this.btn_column.Click | btnColumn_Click > FindTotalValue > GetInstance > cbo_pack_plan_group_changed > GetLastReleaseTime | 1463 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LastestReleaseTime] | BIZ_MATCH |  |
| event:this.btn_column.Click | btnColumn_Click > FindTotalValue > GetInstance > cbo_pack_plan_group_changed > GetLastReleaseTime | 1463 | FP\Planning\FP00631_CellSimul_CellPack#find_LastestReleaseTime | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_LastestReleaseTime.sql |
| event:this.btn_column.Click | btnColumn_Click > FindTotalValue > GetInstance | 1904 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instance] | BIZ_MATCH |  |
| event:this.btn_column.Click | btnColumn_Click > FindTotalValue > GetInstance | 1904 | FP\Planning\FP00631_CellSimul_CellPack#find_instance | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_instance.sql |
| event:this.btn_column.Click | btnColumn_Click > FindTotalValue > GetInstance | 1904 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instance] | BIZ_MATCH |  |
| event:this.btn_column.Click | btnColumn_Click > FindTotalValue > GetInstance | 1904 | FP\Planning\FP00631_CellSimul_CellPack#find_instance | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_instance.sql |
| event:this.btn_column.Click | btnColumn_Click > FindTotalValue > GetInstance > cbo_pack_plan_group_changed > GetCurrDate | 1942 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_currdate] | BIZ_MATCH |  |
| event:this.btn_column.Click | btnColumn_Click > FindTotalValue > GetInstance > cbo_pack_plan_group_changed > GetCurrDate | 1942 | FP\Planning\FP00631_CellSimul_CellPack#find_currdate | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_currdate.sql |
| event:this.btn_column.Click | btnColumn_Click > FindTotalValue > GetInstance > cbo_pack_plan_group_changed > GetCurrDate | 1942 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_currdate] | BIZ_MATCH |  |
| event:this.btn_column.Click | btnColumn_Click > FindTotalValue > GetInstance > cbo_pack_plan_group_changed > GetCurrDate | 1942 | FP\Planning\FP00631_CellSimul_CellPack#find_currdate | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_currdate.sql |
| event:this.btn_column.Click | btnColumn_Click > FindTotalValue > GetInstance > cbo_pack_plan_group_changed > GetLastReleaseTime | 1952 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LastestReleaseTime] | BIZ_MATCH |  |
| event:this.btn_column.Click | btnColumn_Click > FindTotalValue > GetInstance > cbo_pack_plan_group_changed > GetLastReleaseTime | 1952 | FP\Planning\FP00631_CellSimul_CellPack#find_LastestReleaseTime | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_LastestReleaseTime.sql |
| event:this.btn_column.Click | btnColumn_Click > FindTotalValue > GetInstance > cbo_pack_plan_group_changed > GetLastReleaseTime | 1952 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LastestReleaseTime] | BIZ_MATCH |  |
| event:this.btn_column.Click | btnColumn_Click > FindTotalValue > GetInstance > cbo_pack_plan_group_changed > GetLastReleaseTime | 1952 | FP\Planning\FP00631_CellSimul_CellPack#find_LastestReleaseTime | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_LastestReleaseTime.sql |
| event:this.btnDppCopy.Click | btnDppWppCopy_Click > UIFindData > SetReleaseProcess | 1671 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isCurrWeek] | BIZ_MATCH |  |
| event:this.btnDppCopy.Click | btnDppWppCopy_Click > UIFindData > SetReleaseProcess | 1671 | FP\Common\XpCommonAmend#find_isCurrWeek | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_isCurrWeek.sql |
| event:this.btnDppCopy.Click | btnDppWppCopy_Click > UIFindData > FindTotalValue > GetInstance | 1892 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instance] | BIZ_MATCH |  |
| event:this.btnDppCopy.Click | btnDppWppCopy_Click > UIFindData > FindTotalValue > GetInstance | 1892 | FP\Planning\FP00631_CellSimul_CellPack#find_instance | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_instance.sql |
| event:this.btnDppCopy.Click | btnDppWppCopy_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2253 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:this.btnDppCopy.Click | btnDppWppCopy_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2253 | FP\Common\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_WeekCnt.sql |
| event:this.btnDppCopy.Click | btnDppWppCopy_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2254 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:this.btnDppCopy.Click | btnDppWppCopy_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2254 | FP\Common\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_DateMap.sql |
| event:this.btnDppCopy.Click | btnDppWppCopy_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2255 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:this.btnDppCopy.Click | btnDppWppCopy_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2255 | FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql |
| event:this.btnDppCopy.Click | btnDppWppCopy_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2256 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| event:this.btnDppCopy.Click | btnDppWppCopy_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2256 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo.sql |
| event:this.btnDppCopy.Click | btnDppWppCopy_Click | 5027 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] | BIZ_MATCH |  |
| event:this.btnDppCopy.Click | btnDppWppCopy_Click | 5027 | FP\Common\XpCommonAmend#find_save_chk | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_save_chk.sql |
| event:this.btnDWSubmit.Click | btnDwSubmit_Click | 5074 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] | BIZ_MATCH |  |
| event:this.btnDWSubmit.Click | btnDwSubmit_Click | 5074 | FP\Common\XpCommonAmend#find_save_chk | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_save_chk.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > SetReleaseProcess | 1671 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isCurrWeek] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > SetReleaseProcess | 1671 | FP\Common\XpCommonAmend#find_isCurrWeek | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_isCurrWeek.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > FindTotalValue > GetInstance | 1892 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instance] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > FindTotalValue > GetInstance | 1892 | FP\Planning\FP00631_CellSimul_CellPack#find_instance | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_instance.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2253 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2253 | FP\Common\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_WeekCnt.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2254 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2254 | FP\Common\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_DateMap.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2255 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2255 | FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2256 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH |  |
| event:this.btnExcelImport.Click | btnExcelImport_Click > UIFindData > FindMainData > ApplyAmendCalendarCondition | 2256 | FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo.sql |
| event:this.btnMRP.Click | btnMRP_Click | 4752 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] | BIZ_MATCH |  |
| event:this.btnMRP.Click | btnMRP_Click | 4752 | FP\Common\XpCommonAmend#find_save_chk | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_save_chk.sql |
| event:this.btnMRP.Click | btnMRP_Click | 4776 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_MRP_Transit] | BIZ_MATCH |  |
| event:this.btnMRP.Click | btnMRP_Click | 4776 | FP\Common\XpCommonAmend#saveAll_MRP_Transit | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_saveAll_MRP_Transit.sql |
| event:this.btnRelease.Click | btnRelease_Click | 4908 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRelease.Click | btnRelease_Click | 4926 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnRelease.Click | btnRelease_Click | 4929 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| event:this.btnSSP.Click | btnSSP_Click | 4717 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] | BIZ_MATCH |  |
| event:this.btnSSP.Click | btnSSP_Click | 4717 | FP\Common\XpCommonAmend#find_save_chk | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_save_chk.sql |
| event:this.btnSSP.Click | btnSSP_Click | 4741 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_SSP_Transit] | BIZ_MATCH |  |
| event:this.btnSSP.Click | btnSSP_Click | 4741 | FP\Common\XpCommonAmend#saveAll_SSP_Transit | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_saveAll_SSP_Transit.sql |
| event:this.btnStatus.Click | btnStatus_Click | 5132 | FP_Master.PR_UI_FP00602_FIND_FP0060 | NOT_IN_FOXQUERY |  |
| event:this.btnStatus.Click | btnStatus_Click | 5141 | FP_Master.PR_UI_FP00602_FIND_FP0060 | NOT_IN_FOXQUERY |  |
| event:this.Load | Form_Load > InitControls | 208 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 208 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:this.Load | Form_Load > InitControls | 209 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 209 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:this.Load | Form_Load > InitControls | 210 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 210 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:this.Load | Form_Load > InitControls | 213 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 213 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:this.Load | Form_Load > InitControls | 213 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 213 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:this.Load | Form_Load > InitControls | 214 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 214 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:this.Load | Form_Load > InitControls | 214 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 214 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:this.Load | Form_Load > InitControls | 215 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 215 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:this.Load | Form_Load > InitControls | 215 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 215 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:this.Load | Form_Load > InitControls | 226 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 226 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:this.Load | Form_Load > InitControls | 227 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 227 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:this.Load | Form_Load > InitControls | 228 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 228 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:this.Load | Form_Load > InitControls > GetSite | 1403 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_site] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetSite | 1403 | FP\Planning\FP00631_CellSimul_CellPack#find_site | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_site.sql |
| event:this.Load | Form_Load > InitControls > GetInstance | 1410 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instance] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetInstance | 1410 | FP\Planning\FP00631_CellSimul_CellPack#find_instance | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_instance.sql |
| event:this.Load | Form_Load > InitControls > GetCurrDate | 1453 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_currdate] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetCurrDate | 1453 | FP\Planning\FP00631_CellSimul_CellPack#find_currdate | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_currdate.sql |
| event:this.Load | Form_Load > InitControls > GetInstance > cbo_pack_plan_group_changed > GetLastReleaseTime | 1463 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LastestReleaseTime] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetInstance > cbo_pack_plan_group_changed > GetLastReleaseTime | 1463 | FP\Planning\FP00631_CellSimul_CellPack#find_LastestReleaseTime | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_LastestReleaseTime.sql |
| event:this.Load | Form_Load > InitControls > GetListBucketDate | 1472 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bucketdate] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetListBucketDate | 1472 | FP\Planning\FP00631_CellSimul_CellPack#find_bucketdate | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_bucketdate.sql |
| event:this.Load | Form_Load > InitControls > GetPlan | 1493 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetPlan | 1493 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:this.Load | Form_Load > InitControls > GetPlan | 1515 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetPlan | 1515 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:this.Load | Form_Load > InitControls > GetPlan | 1536 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetPlan | 1536 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:this.Load | Form_Load > InitControls > GetSite | 1885 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_site] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetSite | 1885 | FP\Planning\FP00631_CellSimul_CellPack#find_site | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_site.sql |
| event:this.Load | Form_Load > InitControls > GetInstance | 1892 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instance] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetInstance | 1892 | FP\Planning\FP00631_CellSimul_CellPack#find_instance | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_instance.sql |
| event:this.Load | Form_Load > InitControls > GetSite | 1897 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_site] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetSite | 1897 | FP\Planning\FP00631_CellSimul_CellPack#find_site | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_site.sql |
| event:this.Load | Form_Load > InitControls > GetSite | 1897 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_site] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetSite | 1897 | FP\Planning\FP00631_CellSimul_CellPack#find_site | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_site.sql |
| event:this.Load | Form_Load > InitControls > GetInstance | 1904 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instance] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetInstance | 1904 | FP\Planning\FP00631_CellSimul_CellPack#find_instance | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_instance.sql |
| event:this.Load | Form_Load > InitControls > GetInstance | 1904 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instance] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetInstance | 1904 | FP\Planning\FP00631_CellSimul_CellPack#find_instance | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_instance.sql |
| event:this.Load | Form_Load > InitControls > GetCurrDate | 1927 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_currdate] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetCurrDate | 1927 | FP\Planning\FP00631_CellSimul_CellPack#find_currdate | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_currdate.sql |
| event:this.Load | Form_Load > InitControls > GetCurrDate | 1942 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_currdate] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetCurrDate | 1942 | FP\Planning\FP00631_CellSimul_CellPack#find_currdate | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_currdate.sql |
| event:this.Load | Form_Load > InitControls > GetCurrDate | 1942 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_currdate] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetCurrDate | 1942 | FP\Planning\FP00631_CellSimul_CellPack#find_currdate | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_currdate.sql |
| event:this.Load | Form_Load > InitControls > GetListBucketDate | 1946 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bucketdate] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetListBucketDate | 1946 | FP\Planning\FP00631_CellSimul_CellPack#find_bucketdate | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_bucketdate.sql |
| event:this.Load | Form_Load > InitControls > GetInstance > cbo_pack_plan_group_changed > GetLastReleaseTime | 1952 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LastestReleaseTime] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetInstance > cbo_pack_plan_group_changed > GetLastReleaseTime | 1952 | FP\Planning\FP00631_CellSimul_CellPack#find_LastestReleaseTime | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_LastestReleaseTime.sql |
| event:this.Load | Form_Load > InitControls > GetInstance > cbo_pack_plan_group_changed > GetLastReleaseTime | 1952 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LastestReleaseTime] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetInstance > cbo_pack_plan_group_changed > GetLastReleaseTime | 1952 | FP\Planning\FP00631_CellSimul_CellPack#find_LastestReleaseTime | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_LastestReleaseTime.sql |
| event:this.Load | Form_Load > InitControls > GetListBucketDate | 1961 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bucketdate] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetListBucketDate | 1961 | FP\Planning\FP00631_CellSimul_CellPack#find_bucketdate | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_bucketdate.sql |
| event:this.Load | Form_Load > InitControls > GetListBucketDate | 1961 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bucketdate] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetListBucketDate | 1961 | FP\Planning\FP00631_CellSimul_CellPack#find_bucketdate | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_bucketdate.sql |
| event:this.Load | Form_Load > InitControls > GetPlan | 1967 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetPlan | 1967 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:this.Load | Form_Load > InitControls > GetPlan | 1982 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetPlan | 1982 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:this.Load | Form_Load > InitControls > GetPlan | 1982 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetPlan | 1982 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:this.Load | Form_Load > InitControls > GetPlan | 1985 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetPlan | 1985 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:this.Load | Form_Load > InitControls > GetPlan | 2003 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetPlan | 2003 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:this.Load | Form_Load > InitControls > GetPlan | 2004 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetPlan | 2004 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:this.Load | Form_Load > InitControls > GetPlan | 2004 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetPlan | 2004 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:this.Load | Form_Load > InitControls > GetPlan | 2025 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetPlan | 2025 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| event:this.Load | Form_Load > InitControls > GetPlan | 2025 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetPlan | 2025 | FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 82 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 82 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 82 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 82 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SetChangeControl | 356 | biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE_AMEND] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SetChangeControl | 381 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SetChangeControl | 390 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SetChangeControl | 390 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SetChangeControl | 403 | biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Col_Save | 2471 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Col_Save | 2471 | FP\Common\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonCond_find_AMend_Save_Check.sql |
| unreached:(진입점 미연결) | SaveExcelRows | 2550 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_seq] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SaveExcelRows | 2550 | FP\Common\AmendValidation#find_save_seq | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendValidation_find_save_seq.sql |
| unreached:(진입점 미연결) | call_Excel_Col_Validation | 2679 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Col_Validation | 2679 | FP\Common\FP00602_ExcelImportRow#delete_Excel_buffer | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_ExcelImportRow_delete_Excel_buffer.sql |
| unreached:(진입점 미연결) | call_Excel_Col_Validation | 2684 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Col_Validation | 2684 | FP\Common\FP00602_ExcelImportRow#insert_Excel_buffer | MATCH_PATTERN | [update-batch]  |
| unreached:(진입점 미연결) | call_Excel_Row_Save | 2738 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Row_Save | 2738 | FP\Common\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonCond_find_AMend_Save_Check.sql |
| unreached:(진입점 미연결) | call_Excel_Row_Save | 2751 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_seq] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Row_Save | 2751 | FP\Common\AmendValidation#find_save_seq | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendValidation_find_save_seq.sql |
| unreached:(진입점 미연결) | call_Excel_Row_Validation | 2867 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Row_Validation | 2867 | FP\Common\FP00602_ExcelImport#delete_Excel_buffer | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_ExcelImport_delete_Excel_buffer.sql |
| unreached:(진입점 미연결) | call_Excel_Row_Validation | 2872 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Row_Validation | 2872 | FP\Common\FP00602_ExcelImport#insert_Excel_buffer | MATCH_PATTERN | [update-batch]  |
| unreached:(진입점 미연결) | call_Excel_Row_Validation | 2882 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Row_Validation | 2882 | FP\Common\FP00602_ExcelImport#delete_Excel_buffer | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_ExcelImport_delete_Excel_buffer.sql |
| unreached:(진입점 미연결) | call_Excel_Col_Save | 2885 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Col_Save | 2885 | FP\Common\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonCond_find_AMend_Save_Check.sql |
| unreached:(진입점 미연결) | call_Excel_Col_Save | 2885 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Col_Save | 2885 | FP\Common\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonCond_find_AMend_Save_Check.sql |
| unreached:(진입점 미연결) | call_Excel_Row_Validation | 2887 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Row_Validation | 2887 | FP\Common\FP00602_ExcelImport#insert_Excel_buffer | MATCH_PATTERN | [update-batch]  |
| unreached:(진입점 미연결) | SaveExcelRows | 2964 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_seq] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SaveExcelRows | 2964 | FP\Common\AmendValidation#find_save_seq | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendValidation_find_save_seq.sql |
| unreached:(진입점 미연결) | SaveExcelRows | 2964 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_seq] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SaveExcelRows | 2964 | FP\Common\AmendValidation#find_save_seq | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendValidation_find_save_seq.sql |
| unreached:(진입점 미연결) | call_Excel_Col_Validation | 3093 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Col_Validation | 3093 | FP\Common\FP00602_ExcelImportRow#delete_Excel_buffer | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_ExcelImportRow_delete_Excel_buffer.sql |
| unreached:(진입점 미연결) | call_Excel_Col_Validation | 3093 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Col_Validation | 3093 | FP\Common\FP00602_ExcelImportRow#delete_Excel_buffer | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_ExcelImportRow_delete_Excel_buffer.sql |
| unreached:(진입점 미연결) | call_Excel_Col_Validation | 3098 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Col_Validation | 3098 | FP\Common\FP00602_ExcelImportRow#insert_Excel_buffer | MATCH_PATTERN | [update-batch]  |
| unreached:(진입점 미연결) | call_Excel_Col_Validation | 3098 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Col_Validation | 3098 | FP\Common\FP00602_ExcelImportRow#insert_Excel_buffer | MATCH_PATTERN | [update-batch]  |
| unreached:(진입점 미연결) | call_Excel_Row_Save | 3152 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Row_Save | 3152 | FP\Common\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonCond_find_AMend_Save_Check.sql |
| unreached:(진입점 미연결) | call_Excel_Row_Save | 3152 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Row_Save | 3152 | FP\Common\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonCond_find_AMend_Save_Check.sql |
| unreached:(진입점 미연결) | call_Excel_Row_Save | 3165 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_seq] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Row_Save | 3165 | FP\Common\AmendValidation#find_save_seq | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendValidation_find_save_seq.sql |
| unreached:(진입점 미연결) | call_Excel_Row_Save | 3165 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_seq] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Row_Save | 3165 | FP\Common\AmendValidation#find_save_seq | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_AmendValidation_find_save_seq.sql |
| unreached:(진입점 미연결) | call_Excel_Row_Validation | 3281 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Row_Validation | 3281 | FP\Common\FP00602_ExcelImport#delete_Excel_buffer | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_ExcelImport_delete_Excel_buffer.sql |
| unreached:(진입점 미연결) | call_Excel_Row_Validation | 3281 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Row_Validation | 3281 | FP\Common\FP00602_ExcelImport#delete_Excel_buffer | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_ExcelImport_delete_Excel_buffer.sql |
| unreached:(진입점 미연결) | call_Excel_Row_Validation | 3286 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Row_Validation | 3286 | FP\Common\FP00602_ExcelImport#insert_Excel_buffer | MATCH_PATTERN | [update-batch]  |
| unreached:(진입점 미연결) | call_Excel_Row_Validation | 3286 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Row_Validation | 3286 | FP\Common\FP00602_ExcelImport#insert_Excel_buffer | MATCH_PATTERN | [update-batch]  |
| unreached:(진입점 미연결) | call_Excel_Row_Validation | 3296 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Row_Validation | 3296 | FP\Common\FP00602_ExcelImport#delete_Excel_buffer | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_ExcelImport_delete_Excel_buffer.sql |
| unreached:(진입점 미연결) | call_Excel_Row_Validation | 3296 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Row_Validation | 3296 | FP\Common\FP00602_ExcelImport#delete_Excel_buffer | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_FP00602_ExcelImport_delete_Excel_buffer.sql |
| unreached:(진입점 미연결) | call_Excel_Row_Validation | 3301 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Row_Validation | 3301 | FP\Common\FP00602_ExcelImport#insert_Excel_buffer | MATCH_PATTERN | [update-batch]  |
| unreached:(진입점 미연결) | call_Excel_Row_Validation | 3301 | biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | call_Excel_Row_Validation | 3301 | FP\Common\FP00602_ExcelImport#insert_Excel_buffer | MATCH_PATTERN | [update-batch]  |
| unreached:(진입점 미연결) | btnSSP_Click | 5144 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | btnSSP_Click | 5144 | FP\Common\XpCommonAmend#find_save_chk | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_save_chk.sql |
| unreached:(진입점 미연결) | btnSSP_Click | 5144 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | btnSSP_Click | 5144 | FP\Common\XpCommonAmend#find_save_chk | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_save_chk.sql |
| unreached:(진입점 미연결) | btnSSP_Click | 5168 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_SSP_Transit] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | btnSSP_Click | 5168 | FP\Common\XpCommonAmend#saveAll_SSP_Transit | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_saveAll_SSP_Transit.sql |
| unreached:(진입점 미연결) | btnSSP_Click | 5168 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_SSP_Transit] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | btnSSP_Click | 5168 | FP\Common\XpCommonAmend#saveAll_SSP_Transit | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_saveAll_SSP_Transit.sql |
| unreached:(진입점 미연결) | btnMRP_Click | 5179 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | btnMRP_Click | 5179 | FP\Common\XpCommonAmend#find_save_chk | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_save_chk.sql |
| unreached:(진입점 미연결) | btnMRP_Click | 5179 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | btnMRP_Click | 5179 | FP\Common\XpCommonAmend#find_save_chk | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_save_chk.sql |
| unreached:(진입점 미연결) | btnMRP_Click | 5203 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_MRP_Transit] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | btnMRP_Click | 5203 | FP\Common\XpCommonAmend#saveAll_MRP_Transit | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_saveAll_MRP_Transit.sql |
| unreached:(진입점 미연결) | btnMRP_Click | 5203 | biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_MRP_Transit] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | btnMRP_Click | 5203 | FP\Common\XpCommonAmend#saveAll_MRP_Transit | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_saveAll_MRP_Transit.sql |
| unreached:(진입점 미연결) | btnRelease_Click | 5335 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| unreached:(진입점 미연결) | btnRelease_Click | 5335 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| unreached:(진입점 미연결) | btnRelease_Click | 5353 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| unreached:(진입점 미연결) | btnRelease_Click | 5353 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| unreached:(진입점 미연결) | btnRelease_Click | 5356 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| unreached:(진입점 미연결) | btnRelease_Click | 5356 | FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | SP PR_UI_FP_PLAN_FORM_CODE |
| unreached:(진입점 미연결) | btnDppWppCopy_Click | 5454 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | btnDppWppCopy_Click | 5454 | FP\Common\XpCommonAmend#find_save_chk | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_save_chk.sql |
| unreached:(진입점 미연결) | btnDppWppCopy_Click | 5454 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | btnDppWppCopy_Click | 5454 | FP\Common\XpCommonAmend#find_save_chk | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_save_chk.sql |
| unreached:(진입점 미연결) | btnDwSubmit_Click | 5501 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | btnDwSubmit_Click | 5501 | FP\Common\XpCommonAmend#find_save_chk | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_save_chk.sql |
| unreached:(진입점 미연결) | btnDwSubmit_Click | 5501 | biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | btnDwSubmit_Click | 5501 | FP\Common\XpCommonAmend#find_save_chk | MATCH_PATTERN | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_save_chk.sql |
| unreached:(진입점 미연결) | btnStatus_Click | 5559 | FP_Master.PR_UI_FP00602_FIND_FP0060 | NOT_IN_FOXQUERY |  |
| unreached:(진입점 미연결) | btnStatus_Click | 5559 | FP_Master.PR_UI_FP00602_FIND_FP0060 | NOT_IN_FOXQUERY |  |
| unreached:(진입점 미연결) | btnStatus_Click | 5568 | FP_Master.PR_UI_FP00602_FIND_FP0060 | NOT_IN_FOXQUERY |  |
| unreached:(진입점 미연결) | btnStatus_Click | 5568 | FP_Master.PR_UI_FP00602_FIND_FP0060 | NOT_IN_FOXQUERY |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 4 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE_AMEND] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | BIZ_MATCH | 4 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] | BIZ_MATCH | 9 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_MRP_Transit] | BIZ_MATCH | 3 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=saveAll_SSP_Transit] | BIZ_MATCH | 3 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AGING_STOCK] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_AMend_Save_Check] | BIZ_MATCH | 10 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_BOM_RATE] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bucketdate] | BIZ_MATCH | 4 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_bukInfo] | BIZ_MATCH | 4 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Cell_ExchangeValue] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_currdate] | BIZ_MATCH | 4 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_DateMap] | BIZ_MATCH | 4 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_instance] | BIZ_MATCH | 4 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_isCurrWeek] | BIZ_MATCH | 4 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_LastestReleaseTime] | BIZ_MATCH | 4 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_MonthCnt] | BIZ_MATCH | 4 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_plan] | BIZ_MATCH | 36 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Release_Plan_list] | BIZ_MATCH | 12 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_chk] | BIZ_MATCH | 12 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_save_seq] | BIZ_MATCH | 6 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_site] | BIZ_MATCH | 4 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_WeekCnt] | BIZ_MATCH | 4 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_yield_F1000] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_YLD_F6000] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] | BIZ_MATCH | 9 |  |  |  |
| biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=saveAll_MPPWPP] | BIZ_MATCH | 4 |  |  |  |
| FP_Master.PR_UI_FP00602_FIND_FP0060 | NOT_IN_FOXQUERY | 6 |  |  | DB에도 없음 (폐기/오타 가능) |
| FP_Planning.PR_UI_FP_PLAN_FORM_CODE | MATCH | 9 | SP PR_UI_FP_PLAN_FORM_CODE | EXEC:PR_UI_FP_PLAN_FORM_CODE | ⚠ DB에 SP 없음 |
| FP\Common\AmendValidation#find_save_seq | MATCH_PATTERN | 6 | [sql] foxquery_sql\FP_Common_AmendValidation_find_save_seq.sql |  |  |
| FP\Common\FP00602_ExcelImport#delete_Excel_buffer | MATCH_PATTERN | 6 | [sql] foxquery_sql\FP_Common_FP00602_ExcelImport_delete_Excel_buffer.sql | DELETE:BUF_AMEND_PLAN_CELL_R |  |
| FP\Common\FP00602_ExcelImport#insert_Excel_buffer | MATCH_PATTERN | 6 | [update-batch]  |  |  |
| FP\Common\FP00602_ExcelImportRow#delete_Excel_buffer | MATCH_PATTERN | 3 | [sql] foxquery_sql\FP_Common_FP00602_ExcelImportRow_delete_Excel_buffer.sql | DELETE:BUF_AMEND_PLAN_CELL_R |  |
| FP\Common\FP00602_ExcelImportRow#insert_Excel_buffer | MATCH_PATTERN | 3 | [update-batch]  |  |  |
| FP\Common\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | 4 | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_bukInfo.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | 4 | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_DateMap.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | 4 | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_MonthCnt.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | 4 | [sql] foxquery_sql\FP_Common_FP00602_PlanAmendLineAssy_find_WeekCnt.sql | SELECT:TH_UIS_CAL |  |
| FP\Common\FP00602_PlanAmendLineAssy#saveAll_MPPWPP | MATCH_PATTERN | 4 | [update-batch]  |  |  |
| FP\Common\XpCommonAmend#find_isCurrWeek | MATCH_PATTERN | 4 | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_isCurrWeek.sql | REF:FN_SITE_TIME, SELECT:SCM_SYS_LOOKUP_VALUE, SELECT:FP_RELEASE_PLAN_INFO_H |  |
| FP\Common\XpCommonAmend#find_save_chk | MATCH_PATTERN | 12 | [sql] foxquery_sql\FP_Common_XpCommonAmend_find_save_chk.sql | SELECT:FP_USER_ROLE_INFO_V |  |
| FP\Common\XpCommonAmend#saveAll_MRP_Transit | MATCH_PATTERN | 3 | [sql] foxquery_sql\FP_Common_XpCommonAmend_saveAll_MRP_Transit.sql | UPDATE:SCM_FP_PLAN_H |  |
| FP\Common\XpCommonAmend#saveAll_SSP_Transit | MATCH_PATTERN | 3 | [sql] foxquery_sql\FP_Common_XpCommonAmend_saveAll_SSP_Transit.sql | UPDATE:SCM_FP_PLAN_H |  |
| FP\Common\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | 10 | [sql] foxquery_sql\FP_Common_XpCommonCond_find_AMend_Save_Check.sql | SELECT:FP_PLAN_STATUS_H, SELECT:SCM_FP_PLAN_DETAIL_H, SELECT:SCM_FP_PLAN_GROUP_DETAIL_H, SELECT:FP_RELEASE_CALCULATION_STATUS_H |  |
| FP\Planning\FP00631_CELLSIMUL_CELLPACK#find_AGING_STOCK | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_AGING_STOCK.sql | SELECT:TH_MST_STOCK_PLAN_V |  |
| FP\Planning\FP00631_CELLSIMUL_CELLPACK#find_BOM_RATE | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_BOM_RATE.sql | SELECT:SCM_BOM_M, SELECT:FP_INSTANCE_FACTORY_M, SELECT:SCM_FACTORY_M, SELECT:SCM_ITEM_M, SELECT:SCM_ITEM_CLASS_M, SELECT:SCM_ITEM_LINE_ASSIGN_M |  |
| FP\Planning\FP00631_CellSimul_CellPack#find_bucketdate | MATCH | 4 | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_bucketdate.sql | SELECT:TH_UIS_CALENDAR, SELECT:TH_UIS_CAL, SELECT:CURR_DATE |  |
| FP\Planning\FP00631_CELLSIMUL_CELLPACK#find_Cell_ExchangeValue | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_Cell_ExchangeValue.sql | SELECT:SCM_MODEL_COMP_EFFECTIVE_DATEMCT |  |
| FP\Planning\FP00631_CellSimul_CellPack#find_currdate | MATCH | 4 | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_currdate.sql | REF:FN_SITE_TIME, SELECT:FP_INSTANCE_START_TIME_V, SELECT:SITE_T, SELECT:FP_INSTANCE_OPERATION_V |  |
| FP\Planning\FP00631_CellSimul_CellPack#find_instance | MATCH | 4 | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_instance.sql | SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Planning\FP00631_CellSimul_CellPack#find_LastestReleaseTime | MATCH | 4 | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_LastestReleaseTime.sql | SELECT:HIS_FP_PLAN_DETAIL_H, SELECT:HIS_FP_PLAN_GROUP_DETAIL_H |  |
| FP\Planning\FP00631_CellSimul_CellPack#find_plan | MATCH | 36 | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_plan.sql | SELECT:SCM_FP_PLAN_H |  |
| FP\Planning\FP00631_CellSimul_CellPack#find_Release_Plan_list | MATCH | 12 | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_Release_Plan_list.sql | SELECT:FP_RELEASE_PLAN_INFO_H, SELECT:SCM_SYS_LOOKUP_VALUE |  |
| FP\Planning\FP00631_CellSimul_CellPack#find_site | MATCH | 4 | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_site.sql | SELECT:SCM_SITE_M, SELECT:FP_USER_ROLE_INFO_V |  |
| FP\Planning\FP00631_CELLSIMUL_CELLPACK#find_yield_F1000 | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_yield_F1000.sql | SELECT:SCM_YIELD_M, SELECT:FP_INSTANCE_FACTORY_M, SELECT:SCM_FACTORY_M |  |
| FP\Planning\FP00631_CELLSIMUL_CELLPACK#find_YLD_F6000 | MATCH | 1 | [sql] foxquery_sql\FP_Planning_FP00631_CellSimul_CellPack_find_YLD_F6000.sql | SELECT:FP_INSTANCE_FACTORY_M, SELECT:SCM_FACTORY_M, SELECT:SCM_SYS_CALENDAR_M, SELECT:SCM_YIELD_M, SELECT:SCM_YIELD_EXCEPT_M |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| ApplyAmendCalendarCondition | Filter | MONTH_INFO, BUCKET, WEEK_INFO, CATE_INFO |
| btnDppWppCopy_Click | Filter | PLAN_ID, PLAN_TYPE, INSTANCE_ID, BUCKET_FROM, BUCKET_TO, PLAN_DATE, PLANT_ID, SITE_ID, FACTORY_ID, DIVISION_ID |
| btnDppWppCopy_Click | WMPCopy.Filter | SUBMIT_TYPE, MASTER_ID, INSTANCE_ID, BUCKET_FROM, BUCKET_TO, PLAN_ID, PLAN_DATE, PLANT_ID, SITE_ID, FACTORY_ID, DIVISION_ID, USER_ID |
| btnDwSubmit_Click | Filter | PLAN_ID, PLAN_TYPE, INSTANCE_ID, BUCKET_FROM, BUCKET_TO, PLAN_DATE, PLANT_ID, SITE_ID, FACTORY_ID, DIVISION_ID |
| btnDwSubmit_Click | DwSubmit.Filter | SUBMIT_TYPE, MASTER_ID, INSTANCE_ID, BUCKET_FROM, BUCKET_TO, PLAN_ID, PLAN_DATE, PLANT_ID, SITE_ID, FACTORY_ID, DIVISION_ID, USER_ID |
| btnExcelImport_Click | colPopup.KeyColumns | DIVISION_ID, SITE_ID, PLANT_ID, TOP_ITEM_ID, ITEM_ID, OPERATION_ID, FACTORY_ID, LOCATION, PRODUCTION_TYPE, MARKET, LINE_ID, ELECTRODE_TYPE |
| btnExcelImport_Click | colPopup.ColumnTitle | DIVISION_ID, SITE_ID, PLANT_ID, TOP_ITEM_ID, ITEM_ID, NICK_NAME, ITEM_TYPE, OPERATION_ID, FACTORY_ID, LOCATION, MARKET, PRODUCTION_TYPE, LINE_ID, LINE_NAME, ELECTRODE_TYPE, ELECTROD_TYPE |
| btnExcelImport_Click | rowPopup.KeyColumns | DIVISION_ID, SITE_ID, PLANT_ID, TOP_ITEM_ID, ITEM_ID, OPERATION_ID, FACTORY_ID, LOCATION, PRODUCTION_TYPE, MARKET, LINE_ID, ELECTRODE_TYPE, PLAN_DATE, QTY |
| btnExcelImport_Click | rowPopup.ColumnTitle | DIVISION_ID, SITE_ID, PLANT_ID, TOP_ITEM_ID, ITEM_ID, NICK_NAME, ITEM_TYPE, OPERATION_ID, FACTORY_ID, LOCATION, PRODUCTION_TYPE, MARKET, LINE_ID, LINE_NAME, ELECTRODE_TYPE, PLAN_DATE, QTY, MESSAGE, ELECTROD_TYPE |
| btnMemo_Click | Filter | MASTER_ID, INSTANCE_ID, BUCKET_FROM, BUCKET_TO, TOP_ITEM_ID, ITEM_ID, PLAN_ID, PLAN_DATE, DIVISION_ID, FACTORY_ID, OPERATION_ID, LINE_ID, PLANT_ID, SITE_ID |
| btnMemo_Click | memoPopup.Filter | MASTER_ID, INSTANCE_ID, BUCKET_FROM, BUCKET_TO, MODEL_ID, TOP_ITEM_ID, ITEM_ID, PLAN_ID, PLAN_DATE, DIVISION_ID, FACTORY_ID, OPERATION_ID, LINE_ID, PLANT_ID, SITE_ID, USER_ID |
| btnMRP_Click | Filter | PLAN_ID, PLAN_TYPE, MASTER_ID, INSTANCE_ID |
| btnRelease_Click | Filter | SITE_ID, INSTANCE_ID, FP_PLAN_ID, PLAN_DATE |
| btnRelease_Click | dtEngineFlag.Rows[0] | INBOUND, ENGINE, OUTBOUND |
| btnRelease_Click | dtPlanRunFlag.Rows[0] | PLAN_ID, INSERT_ID |
| btnRelease_Click | dtParam2.Rows[0] | CONFIRM_AREA, IS_SAME_PLAN_ID, USE_WOW_STATUS |
| btnRelease_Click | Application.OpenForms | FP00590_GroupReleaseTotalPopup |
| btnSSP_Click | Filter | PLAN_ID, PLAN_TYPE, MASTER_ID, INSTANCE_ID |
| btnStatus_Click | Filter | INSTANCE_ID, PLAN_DATE, PLAN_ID |
| btnStatus_Click | dtDataInfo.Rows[0] | USE_WOW_STATUS |
| btnStatus_Click | dtParam2.Rows[0] | CONFIRM_AREA, IS_SAME_PLAN_ID |
| btnStatus_Click | Application.OpenForms | FP00590_WoWStatusPopup |
| call_Excel_Col_Save | checkSave.Tables[0].Rows[0] | _TYPE |
| call_Excel_Col_Save | pivotLine | INSTANCE_ID, FP_PLAN_ID, PLAN_DATE, QTY, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, OPERATION_ID, FACTORY_ID, LOCATION, PRODUCTION_TYPE, MARKET, LINE_ID, ELECTRODE_TYPE, TOP_ITEM_ID, ITEM_TYPE, USER_ID |
| call_Excel_Col_Save | popup.Filter | MASTER_ID, PLAN_ID |
| call_Excel_Col_Save | row | DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, OPERATION_ID, FACTORY_ID, LOCATION, PRODUCTION_TYPE, MARKET, LINE_ID, ELECTRODE_TYPE, TOP_ITEM_ID, ITEM_TYPE, USER_ID |
| call_Excel_Col_Search | popup.Filter | PLAN_TYPE |
| call_Excel_Col_Validation | popup.Filter | PLAN_TYPE, NEW_SEQ |
| call_Excel_Col_Validation | data.Tables[0].Rows[i] | JOB_ORDER, NEW_SEQ |
| call_Excel_Row_Save | checkSave.Tables[0].Rows[0] | _TYPE |
| call_Excel_Row_Save | popup.Filter | PLAN_TYPE, NEW_SEQ, MPP_WPP, FP_PLAN_ID, INSTANCE_ID |
| call_Excel_Row_Save | nSeq.Tables[0].Rows[0] | NEW_SEQ |
| call_Excel_Row_Save | row | JOB_ORDER, MPP_WPP, NEW_SEQ, IN_QTY, OUT_QTY, CELL_IN_QTY, CELL_OUT_QTY, QTY, INSTANCE_ID, FP_PLAN_ID |
| call_Excel_Row_Search | popup.Filter | PLAN_TYPE |
| call_Excel_Row_Validation | popup.Filter | PLAN_TYPE |
| cbo_cell_plan_id_changed | Filter | ASSY_PLAN_ID, BUCKET_FROM, BUCKET_TO |
| cbo_cell_plan_id_changed | dtPlanId.Rows[selected] | PLAN_START_DATE, PLAN_END_DATE, SITE_ID, DESCRIPTION, PLAN_TYPE, READ_ONLY, NAME, CODE, INSERT_ID, INSERT_Time, BASIC_VERSION, FACTORY_LT |
| cbo_form_plan_id_changed | Filter | FORM_PLAN_ID |
| cbo_pack_plan_id_changed | Filter | PACK_PLAN_ID |
| cbo_site_changed | Filter | SITE_ID |
| CheckAndGetMeasure | measure.Data | chk_week, chk_day, chk_month |
| chk_changed | Filter | IS_REL_PACK, IS_REL_FORM, IS_REL_ASSY |
| CreateDataLine | material_column | P_IN, P_IN_CELL, P_OUT, P_OUT_CELL |
| CreateFilterDataSet | result_row | _MM_ |
| CreateFilterDataSet | measure | chk_uom, chk_inqty, chk_outqty, chk_result, chk_mpp_inqty, chk_mpp_outqty, chk_wpp_inqty, chk_wpp_outqty, chk_target, chk_cell, chk_total, chk_off, chk_setup, chk_capa, chk_wpp_inqty_tot, chk_wpp_outqty_tot, chk_mpp_inqty_tot, chk_mpp_outqty_tot, chk_inqty_tot, chk_outqty_tot, chk_result_tot, chk_target_tot, chk_subTotal |
| CreateFilterDataSet | x | _MM_ |
| FilterValidation | Filter | PACK_PLAN_ID, IS_REL_PACK, FORM_PLAN_ID, IS_REL_FORM, ASSY_PLAN_ID, IS_REL_ASSY, BUCKET_FROM, BUCKET_TO |
| Find_Line_Savings_Index_FromData | x | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, MARKET, FACTORY_ID, LINE_ID, ELECTRODE_TYPE, LOCATION, TOP_ITEM_ID, ITEM_ID, CELL_ITEM_ID, CELL_GROUP_CODE |
| Find_Line_Savings_Index_FromData | clicked_row | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, MARKET, FACTORY_ID, LINE_ID, ELECTRODE_TYPE, LOCATION, TOP_ITEM_ID, ITEM_ID, CELL_ITEM_ID, CELL_GROUP_CODE |
| Find_Line_Savings_Index_FromData | related_row | CATEGORY_ID, MEASURE_NAME, PRODUCTION_TYPE |
| Find_MaterialData_Index_FromData | x | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, MARKET, FACTORY_ID, LINE_ID, ELECTRODE_TYPE, LOCATION, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE, CELL_ITEM_ID, CELL_GROUP_CODE |
| Find_MaterialData_Index_FromData | clicked_row | DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, MARKET, FACTORY_ID, LINE_ID, ELECTRODE_TYPE, LOCATION, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE, CELL_ITEM_ID, CELL_GROUP_CODE |
| Find_MaterialData_Index_FromData | related_row | CATEGORY_ID, MEASURE_NAME |
| FindButton | Filter | PLAN_ID |
| FindFP00631 | Filter | PARMA_CATE_INFO, PACK_AMEND_TABLE, PACK_AMEND_SALES_TABLE, FORM_AMEND_TABLE, CELL_AMEND_TABLE, CELL_AMEND_SALES_TABLE, IS_REL_PACK, TARGET_INSTANCE, PACK_INSTANCE_ID, PACK_PLAN_LT, PACK_CONFIRM_AREA, PACK_PLAN_ID |
| FindListData | Filter | PACK_AMEND_TABLE, PACK_AMEND_SALES_TABLE, FORM_AMEND_TABLE, CELL_AMEND_TABLE, CELL_AMEND_SALES_TABLE, IS_REL_PACK, TARGET_INSTANCE, PACK_INSTANCE_ID, PACK_PLAN_LT, PACK_PLAN_ID, IS_REL_FORM, FORM_INSTANCE_ID, FORM_PLAN_LT, FORM_PLAN_ID, IS_REL_ASSY, ASSY_INSTANCE_ID, ASSY_PLAN_LT, ASSY_PLAN_ID, PLAN_ID_SCRIPT |
| FindListData | dtReleasePlanList.Rows[i] | release_plan_id |
| FindMainData | Filter | CATE_INFO, PACK_AMEND_TABLE, PACK_AMEND_SALES_TABLE, FORM_AMEND_TABLE, CELL_AMEND_TABLE, CELL_AMEND_SALES_TABLE, IS_REL_PACK, TARGET_INSTANCE, PACK_INSTANCE_ID, PACK_PLAN_LT, PACK_CONFIRM_AREA, PACK_PLAN_ID, IS_REL_FORM, FORM_INSTANCE_ID, FORM_PLAN_LT, FORM_CONFIRM_AREA, FORM_PLAN_ID, IS_REL_ASSY, ASSY_INSTANCE_ID, ASSY_PLAN_LT, ASSY_CONFIRM_AREA, ASSY_PLAN_ID, BUCKET_SCRIPT_PART0, BUCKET_SCRIPT_PART1, BUCKET_SCRIPT_PART2, BUCKET_SCRIPT_PART3, BUCKET_SCRIPT_PART4, BUCKET_SCRIPT_PART5, BUCKET_SCRIPT_PART6, BUCKET_SCRIPT_PART7, BUCKET_SCRIPT_PART8, BUCKET_SCRIPT_PART9, BUCKET_SCRIPT_PART10, BUCKET_SCRIPT_PART11, BUCKET_SCRIPT_PART12, FP_PLAN_ID, PLAN_ID |
| FindMainData | dtReleasePlanList.Rows[i] | release_plan_id |
| FindMainData | dateMap.Tables[0].Rows[i] | _DATE |
| GetCellDataOfCellGroup | x | DATA_TYPE, SHOP_TYPE, CELL_GROUP_CODE, CELL_GROUP_CODE_RANK, PACK_RANK |
| GetCellDataOfCellGroup | click_row | CELL_GROUP_CODE, CELL_GROUP_CODE_RANK, PACK_RANK |
| GetCurrDate | dtCurrdate.Rows[0] | CURR_DATE |
| GetDataOfCellGroup | x | DATA_TYPE, CELL_GROUP_CODE |
| GetDataOfCellGroup | click_row | CELL_GROUP_CODE |
| GetFormDataOfCellGroup | x | DATA_TYPE, SHOP_TYPE, CELL_GROUP_CODE, CELL_GROUP_CODE_RANK |
| GetFormDataOfCellGroup | click_row | CELL_GROUP_CODE, CELL_GROUP_CODE_RANK |
| GetFpPlanId | Filter | PLAN_ID, PLAN_TYPE |
| GetFpPlanId | dtPlanId.Rows[0] | PLAN_ID, PLAN_TYPE, DESCRIPTION, INSERT_ID, INSERT_Time, BASIC_VERSION, FACTORY_LT |
| GetInstance | pack_row | CODE, NAME |
| GetInstance | row | PACK_INSTANCE_ID, PACK_INSTANCE_NAME, CELL_INSTANCE_ID, CELL_INSTANCE_NAME, INSTANCE_ID, INSTANCE_NAME |
| GetInstance | cell_row | CODE, NAME |
| GetInstance | form_row | CODE, NAME |
| GetLastReleaseTime | Filter | LAST_RELEASE_TIME |
| GetLastReleaseTime | dtLastestRel.Rows[0] | LAST_TIME |
| GetListBucketDate | dtBucketdate.Rows[0] | START_DATE, END_DATE |
| GetPackDataOfCellGroup | x | DATA_TYPE, SHOP_TYPE, CELL_GROUP_CODE, CELL_GROUP_CODE_RANK, PACK_RANK |
| GetPackDataOfCellGroup | click_row | CELL_GROUP_CODE, CELL_GROUP_CODE_RANK, PACK_RANK |
| GetPlan | Filter | SHOP, INSTANCE_ID, PACK_PLAN_ID, FORM_PLAN_ID, ASSY_PLAN_ID |
| GoEditMode | Filter | PLAN_TYPE |
| GoEditMode | row | DATA_TYPE, MEASURE_ID, CATEGORY_ID, EDIT_YN |
| InitControls | Filter | BUCKET, USER_ID, IS_REL_PACK, IS_REL_FORM, IS_REL_ASSY, SITE_ID, PLAN_DATE, BUCKET_FROM, BUCKET_TO |
| InsertButton | Filter | DONOTEDIT |
| InsertButton | row | TOP_ITEM_ID |
| lfn_setCell_EOH | x | CATEGORY_ID |
| lfn_setCell_EOH | Filter | PLAN_DATE |
| lfn_setCell_EOH | cell_data_rows.ElementAt(0) | BOH_QTY |
| lfn_setCell_EOH | planout | LT |
| lfn_setCell_Form_Request | x | CATEGORY_ID |
| lfn_setCell_SCP_Balance | x | CATEGORY_ID |
| lfn_setCell_SCP_Balance | Filter | PLAN_DATE |
| lfn_setForm_Cell_Request | x | CATEGORY_ID, RNK, PLANT_ID, CELL_ITEM_ID, PARENT_ITEM_ID, MONTH |
| lfn_setForm_Cell_Request | out_row | PLANT_ID, CELL_ITEM_ID, PACK_ITEM_ID |
| lfn_setForm_Cell_Request | nBOMTmp_row.ElementAt(0) | BOM_RATE_CELL, BOM_RATE_P5000 |
| lfn_setForm_EOH | x | CATEGORY_ID |
| lfn_setForm_EOH | Filter | PLAN_DATE |
| lfn_setForm_EOH | data_rows.ElementAt(0) | BOH_QTY |
| lfn_setForm_EOH | planout | LT |
| lfn_setForm_Remained_Activated_Cell | x | CATEGORY_ID |
| lfn_setForm_Remained_Activated_Cell_Detail | x | FACTORY_ID, CELL_ITEM_ID, LINE_ID, CATEGORY_ID, PLAN_DATE, ITEM_ID, OPERATION_ID, MONTH |
| lfn_setForm_Remained_Activated_Cell_Detail | form_p_remined | FACTORY_ID, CELL_ITEM_ID, LINE_ID, OPERATION_ID |
| lfn_setForm_Remained_Activated_Cell_Detail | Filter | PLAN_DATE |
| lfn_setForm_Remained_Activated_Cell_Detail | nAgingRow.ElementAt(0) | AGING_STOCK |
| lfn_setForm_Remained_Activated_Cell_Detail | nYieldRow.ElementAt(0) | YIELD |
| lfn_setForm_Remained_Activated_Cell_Detail | planout | LT |
| lfn_setForm_Remained_Activated_Cell_Detail | yield_f1000.ElementAt(0) | YIELD |
| lfn_setPack_EOH_SCPTarget | x | CATEGORY_ID |
| lfn_setPack_EOH_SCPTarget | Filter | PLAN_DATE |
| lfn_setPack_EOH_ShippingPlan | x | CATEGORY_ID |
| lfn_setPack_EOH_ShippingPlan | Filter | PLAN_DATE |
| lfn_setPack_EOH_ShippingPlan | data_rows.ElementAt(0) | BOH_QTY |
| lfn_setPack_EOH_ShippingPlan | planout | LT |
| lfn_setUpdateTotalValue | Filter | PLAN_DATE |
| lfn_setUpdateTotalValue | x | CELL_GROUP_CODE, DATA_TYPE, SHOP_TYPE |
| MakeInstanceLT | Filter | PACK_INSTANCE_ID, FORM_INSTANCE_ID, ASSY_INSTANCE_ID, INSTANCE_LT |
| MakeMemoBold | dsMainFiltered.Tables[0].Rows[i] | CATE |
| onMemoMenu | frm.Filter | MEMO_TYPE |
| onNLFAmendMenu | frm.Filter | MASTER_ID, INSTANCE_ID, FP_PLAN_ID, PLAN_ID |
| onNLFAmendMenu | Filter | INSTANCE_ID, PLAN_ID |
| onZeroBucketMenu | row_to_test | CATEGORY_ID |
| onZeroMaterialMenu | row_to_test | CATEGORY_ID |
| OpenAlarmMemo | row | PRODUCTION_TYPE |
| OpenAlarmMemo | frm.Filter | MEMO_TYPE |
| OpenLineMemo | frm.Filter | MEMO_TYPE |
| OpenMaterialMemo | frm.Filter | MEMO_TYPE |
| plan_day_changed | Filter | PLAN_DATE |
| plan_range_changed | Filter | BUCKET_FROM, BUCKET_TO |
| RefreshHeader | row | DATA_TYPE |
| RefreshSpreadSheet | Filter | DONOTEDIT |
| Save_Data | Filter | PLAN_TYPE, PLAN_DATE, INSTANCE_ID, FP_PLAN_ID |
| Save_Data | checkSave.Tables[0].Rows[0] | _TYPE |
| Save_Data | BohSet | PLAN_DATE, MASTER_ID, PLAN_ID, AMEND_CUTOFF_BOH_TABLE |
| Save_Data | res.Rows[0] | RESULT, COUNT |
| SaveButton | Filter | DONOTEDIT |
| SaveExcelRows | popupFilter | PLAN_TYPE, NEW_SEQ, MPP_WPP, FP_PLAN_ID, PLAN_DATE, INSTANCE_ID |
| SaveExcelRows | nSeq.Tables[0].Rows[0] | NEW_SEQ |
| SaveExcelRows | row | JOB_ORDER, MPP_WPP, NEW_SEQ, IN_QTY, OUT_QTY, CELL_IN_QTY, CELL_OUT_QTY, QTY |
| SaveExcelRows | BohSet | PLAN_DATE, MASTER_ID, PLAN_ID, AMEND_CUTOFF_BOH_TABLE |
| SaveExcelRows | data.Tables[0].Rows[0] | FP_PLAN_ID |
| SetBohQty | row | DATA_TYPE, OPERATION_ID, BOH_QTY, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, TOP_ITEM_ID |
| SetBohQty | each_row | _TYPE, OPERATION_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID, TOP_ITEM_ID |
| SetBohQty | result.First() | QTY |
| SetChangeControl | Filter | INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, PLAN_TYPE, BUILDING, MASTER_ID, PLAN_ID |
| SetMemoCell | set | BUCKET_FROM, BUCKET_TO, MEMO |
| SetPlanOutCell | clicked_row | PLANT_ID, TOP_ITEM_ID, ITEM_ID, DIVISION_ID, SITE_ID, FACTORY_ID, OPERATION_ID, LINE_ID, CATEGORY_ID, MEASURE_ID |
| SetPlanOutCell | Filter | INSTANCE_ID, FP_PLAN_ID, PLAN_ID, PLAN_TYPE |
| SetPlanOutCell | x | INSTANCE_ID, FP_PLAN_ID, DIVISION_ID, CATEGORY_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, MARKET, FACTORY_ID, LINE_ID, ELECTRODE_TYPE, LOCATION, PLAN_DATE, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE |
| SetPlanOutCell | row | DIVISION_ID, CATEGORY_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, MARKET, FACTORY_ID, LINE_ID, ELECTRODE_TYPE, LOCATION, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE |
| SetPlanOutCell | selected | ORG_WPP_OUT_QTY, ORG_MPP_OUT_QTY, MPP_OUT_QTY, WPP_OUT_QTY, ORIG_OUT_QTY, IN_QTY, OUT_QTY, M |
| SetPlanOutCell | newrow | CATEGORY_ID, INSTANCE_ID, FP_PLAN_ID, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, MARKET, FACTORY_ID, LINE_ID, ELECTRODE_TYPE, LOCATION, PLAN_DATE, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE, MPP_OUT_QTY, ORG_MPP_OUT_QTY, ORG_WPP_OUT_QTY, WPP_OUT_QTY, IN_QTY, OUT_QTY, ORIG_IN_QTY, ORIG_OUT_QTY, M, USER_ID |
| SetPlanOutCellRaw | clicked_row | COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, PACK_ITEM_ID, CELL_ITEM_ID, PRODUCTION_TYPE, MARKET, ITEM_TYPE, CATEGORY_ID, MODEL_ID, CHILD_ITEM_ID |
| SetPlanOutCellRaw | x | FACTORY_ID, LOCATION, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, PLAN_DATE, TOP_ITEM_ID, ITEM_ID, PRODUCTION_TYPE, MARKET, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ID, CHILD_ITEM_ID, INSTANCE_ID, FP_PLAN_ID, CATEGORY_ID, COMPANY_ID, ITEM_TYPE |
| SetPlanOutCellRaw | new_row | INSTANCE_ID, FP_PLAN_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, PRODUCTION_TYPE, MARKET, ITEM_ID, TOP_ITEM_ID, PLAN_DATE, LOCATION, ITEM_TYPE, M, SEQ |
| SetPlanOutCellRaw | Filter | PACK_INSTANCE_ID, PACK_PLAN_ID, FORM_INSTANCE_ID, FORM_PLAN_ID, INSTANCE_ID, FP_PLAN_ID, PLAN_ID, PLAN_TYPE |
| SetPlanOutCellRaw | editorCurrentRow | OUT_QTY, ORG_QTY |
| SetPlanOutCellRaw | nExcRow.ElementAt(0) | ACCUM_QTY |
| SetPlanOutCellRaw | row | DIVISION_ID, CATEGORY_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, MARKET, FACTORY_ID, LINE_ID, ELECTRODE_TYPE, LOCATION, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE |
| SetPlanOutCellRaw | selected | ORG_WPP_OUT_QTY, ORG_MPP_OUT_QTY, MPP_OUT_QTY, WPP_OUT_QTY, ORIG_OUT_QTY, IN_QTY, OUT_QTY, M |
| SetPlanOutCellRaw | newrow | CATEGORY_ID, INSTANCE_ID, FP_PLAN_ID, DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, OPERATION_ID, PRODUCTION_TYPE, MARKET, FACTORY_ID, LINE_ID, ELECTRODE_TYPE, LOCATION, PLAN_DATE, TOP_ITEM_ID, ITEM_ID, ITEM_TYPE, MPP_OUT_QTY, ORG_MPP_OUT_QTY, ORG_WPP_OUT_QTY, WPP_OUT_QTY, IN_QTY, OUT_QTY, ORIG_IN_QTY, ORIG_OUT_QTY, M, USER_ID |
| SetReleaseProcess | Filter | PLAN_TYPE |
| SetReleaseProcess | ds_isCurrWeek.Tables[0].Rows[0] | CURR_DATE |
| SetReleaseProcess | row | _DATE, IS_PLAN |
| spdMain_CellClick | row | LINE_ID, PRODUCTION_TYPE, DATA_TYPE, OPERATION_ID, TOP_ITEM_ID |
| spdMain_CellClick2 | row | DATA_TYPE, OPERATION_ID, TOP_ITEM_ID |
| SwitchMemo | r | DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ELECTRODE_TYPE, EQUIPMENT_ID, ITEM_ID, TOP_ITEM_ID, PRODUCTION_TYPE, MARKET |
| SwitchMemo | memoRow | PRODUCTION_TYPE, ITEM_ID |
| SwitchMemo | memo[k] | ITEM_ID |
| SwitchMemo | materialRow | PRODUCTION_TYPE |
| UIFindData | Filter | DONOTEDIT, USE_WOW_STATUS, PLAN_TYPE |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | InitControls:191, MakeInstanceLT:259, MakeInstanceLT:260, MakeInstanceLT:261, SetChangeControl:393, GetPlan:1980, GetPlan:1999, GetPlan:2002 | CString.GetCheckedListValue | CODE |
| SetFilter | SetChangePlanDate:287, SetChangeControl:393, Save_Data:1213, mcbo_operation_changed:4847, cell_code_changed:4917, pack_code_changed:4922, pack_nick_changed:4927, cell_nick_changed:4932 | BaseForm.SetFilter | AllYn, Col, SheetName, Value |
| FP_UpdateBatch | Save_Data:1237, call_Excel_Col_Validation:3098, call_Excel_Row_Validation:3286, call_Excel_Row_Validation:3301, Save_Data:1090, Save_Data:1226, call_Excel_Col_Validation:2684, call_Excel_Row_Validation:2872 | DataService.FP_UpdateBatch | COUNT, RESULT |
| FP_Log2 | cbo_pack_plan_group_changed:6655, cbo_pack_plan_group_changed:6668 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |
| GetMeasure | CheckAndGetMeasure:478, RefreshSpreadSheet:1697 | MeasureService.GetMeasure | FLAG, MEA_ID, MEA_NAME, MEA_VALUE, MENU_ID, TYPE, USER_ID |
| SetRowVisibleOnMeasureDatatypeCategory | CreateFilterDataSet:1543 | MeasureService.SetRowVisibleOnMeasureDatatypeCategory | CATEGORY_ID, DATA_TYPE, MEASURE_ID, _MM_ |
| SetRowVisibleOnDatatypeCategory | CreateFilterDataSet:1544 | MeasureService.SetRowVisibleOnDatatypeCategory | CATEGORY_ID, DATA_TYPE, _MM_ |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:124 |
| cbo_site | SelectedIndexChanged | cbo_site_changed | InitEvent:411 |
| cbo_pack_plan_group | SelectedIndexChanged | cbo_pack_plan_group_changed | InitEvent:413 |
| cbo_pack_plan_id | SelectedIndexChanged | cbo_pack_plan_id_changed | InitEvent:417 |
| cbo_form_plan_id | SelectedIndexChanged | cbo_form_plan_id_changed | InitEvent:418 |
| cbo_cell_plan_id | SelectedIndexChanged | cbo_cell_plan_id_changed | InitEvent:419 |
| date_instance | ValueChanged | plan_day_changed | InitEvent:422 |
| range_plan | ValueChanged | plan_range_changed | InitEvent:423 |
| txt_pack_code | TextChanged | pack_code_changed | InitEvent:425 |
| txt_cell_code | TextChanged | cell_code_changed | InitEvent:426 |
| txt_pack_nick | TextChanged | pack_nick_changed | InitEvent:427 |
| txt_cell_nick | TextChanged | cell_nick_changed | InitEvent:428 |
| chk_form_plan_group | CheckedChanged | chk_changed | InitEvent:431 |
| chk_pack_plan_group | CheckedChanged | chk_changed | InitEvent:432 |
| chk_cell_plan_group | CheckedChanged | chk_changed | InitEvent:433 |
| spdMain | CellClick | spdMain_CellClick2 | InitEvent:435 |
| popSql | OnSql | RunSqlSource | btnSql_Click:1285 |
| cbo_pack_plan_group | SelectedIndexChanged | cbo_pack_plan_group_changed | GetInstance:1905 |
| cbo_pack_plan_group | SelectedIndexChanged | cbo_pack_plan_group_changed | GetInstance:1932 |
| bucke_menu | Click | onZeroBucketMenu | spdMain_CellClick2:4580 |
| memo_menu | Click | onMemoMenu | spdMain_CellClick2:4590 |
| bucke_menu | Click | onZeroMaterialMenu | spdMain_CellClick2:4605 |
| bucke_menu | Click | onZeroMaterialMenu | spdMain_CellClick2:4617 |
| nlfamend_menu | Click | onNLFAmendMenu | spdMain_CellClick2:4624 |
| range_plan | ValueChanged | plan_range_changed | plan_range_changed:4939 |
| range_plan | ValueChanged | plan_range_changed | plan_range_changed:4947 |
| this | Load | Form_Load | .ctor:124 |
| cbo_site | SelectedIndexChanged | cbo_site_changed | InitEvent:411 |
| cbo_pack_plan_group | SelectedIndexChanged | cbo_pack_plan_group_changed | InitEvent:413 |
| cbo_pack_plan_id | SelectedIndexChanged | cbo_pack_plan_id_changed | InitEvent:417 |
| cbo_form_plan_id | SelectedIndexChanged | cbo_form_plan_id_changed | InitEvent:418 |
| cbo_cell_plan_id | SelectedIndexChanged | cbo_cell_plan_id_changed | InitEvent:419 |
| date_instance | ValueChanged | plan_day_changed | InitEvent:422 |
| range_plan | ValueChanged | plan_range_changed | InitEvent:423 |
| txt_pack_code | TextChanged | pack_code_changed | InitEvent:425 |
| txt_cell_code | TextChanged | cell_code_changed | InitEvent:426 |
| txt_pack_nick | TextChanged | pack_nick_changed | InitEvent:427 |
| txt_cell_nick | TextChanged | cell_nick_changed | InitEvent:428 |
| chk_form_plan_group | CheckedChanged | chk_changed | InitEvent:431 |
| chk_pack_plan_group | CheckedChanged | chk_changed | InitEvent:432 |
| chk_cell_plan_group | CheckedChanged | chk_changed | InitEvent:433 |
| spdMain | CellClick | spdMain_CellClick2 | InitEvent:435 |
| popSql | OnSql | RunSqlSource | btnSql_Click:1285 |
| cbo_pack_plan_group | SelectedIndexChanged | cbo_pack_plan_group_changed | GetInstance:1905 |
| cbo_pack_plan_group | SelectedIndexChanged | cbo_pack_plan_group_changed | GetInstance:1932 |
| bucke_menu | Click | onZeroBucketMenu | spdMain_CellClick2:4580 |
| memo_menu | Click | onMemoMenu | spdMain_CellClick2:4590 |
| bucke_menu | Click | onZeroMaterialMenu | spdMain_CellClick2:4605 |
| bucke_menu | Click | onZeroMaterialMenu | spdMain_CellClick2:4617 |
| nlfamend_menu | Click | onNLFAmendMenu | spdMain_CellClick2:4624 |
| range_plan | ValueChanged | plan_range_changed | plan_range_changed:4939 |
| range_plan | ValueChanged | plan_range_changed | plan_range_changed:4947 |
| this | Load | Form_Load | .ctor:136 |
| cbo_site | SelectedIndexChanged | cbo_site_changed | InitEvent:424 |
| cbo_pack_plan_group | SelectedIndexChanged | cbo_pack_plan_group_changed | InitEvent:426 |
| cbo_pack_plan_id | SelectedIndexChanged | cbo_pack_plan_id_changed | InitEvent:430 |
| cbo_form_plan_id | SelectedIndexChanged | cbo_form_plan_id_changed | InitEvent:431 |
| cbo_cell_plan_id | SelectedIndexChanged | cbo_cell_plan_id_changed | InitEvent:432 |
| date_instance | ValueChanged | plan_day_changed | InitEvent:435 |
| range_plan | ValueChanged | plan_range_changed | InitEvent:436 |
| txt_pack_code | TextChanged | pack_code_changed | InitEvent:438 |
| txt_cell_code | TextChanged | cell_code_changed | InitEvent:439 |
| txt_pack_nick | TextChanged | pack_nick_changed | InitEvent:440 |
| txt_cell_nick | TextChanged | cell_nick_changed | InitEvent:441 |
| chk_form_plan_group | CheckedChanged | chk_changed | InitEvent:444 |
| chk_pack_plan_group | CheckedChanged | chk_changed | InitEvent:445 |
| chk_cell_plan_group | CheckedChanged | chk_changed | InitEvent:446 |
| popSql | OnSql | RunSqlSource | btnSql_Click:1138 |
| cbo_pack_plan_group | SelectedIndexChanged | cbo_pack_plan_group_changed | GetInstance:1414 |
| cbo_pack_plan_group | SelectedIndexChanged | cbo_pack_plan_group_changed | GetInstance:1448 |
| range_plan | ValueChanged | plan_range_changed | plan_range_changed:6950 |
| range_plan | ValueChanged | plan_range_changed | plan_range_changed:6958 |
| bucke_menu | Click | onZeroBucketMenu | spdMain_CellClick:7367 |
| memo_menu | Click | onMemoMenu | spdMain_CellClick:7377 |
| bucke_menu | Click | onZeroMaterialMenu | spdMain_CellClick:7392 |
| bucke_menu | Click | onZeroMaterialMenu | spdMain_CellClick:7404 |
| nlfamend_menu | Click | onNLFAmendMenu | spdMain_CellClick:7411 |
| this.btnToggleSave | Click | btnToggleSave_Click | InitializeComponent:527 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:886 |
| this.spdMain | ChildControlDeactivated | spdMain_ChildControlDeactivated | InitializeComponent:1233 |
| this.spdMain | EditModeOn | spdMain_EditModeOn | InitializeComponent:1234 |
| this.spdMain | EditModeOff | spdMain_EditModeOff | InitializeComponent:1235 |
| this.spdMain | ActiveSheetChanged | spdMain_ActiveSheetChanged | InitializeComponent:1236 |
| this.spdMain | ColumnWidthChanged | spdMain_ColumnWidthChanged | InitializeComponent:1237 |
| this.spdMain | TableChanged | spdMain_TableChanged | InitializeComponent:1238 |
| this.spdMain | Change | spdMain_Change | InitializeComponent:1239 |
| this.spdMain | DragFillBlockCompleted | spdMain_DragFillBlockCompleted | InitializeComponent:1240 |
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:1241 |
| this.spdMain | ButtonClicked | spdMain_ButtonClicked | InitializeComponent:1242 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:1243 |
| this.spdMain | EditChange | spdMain_EditChange | InitializeComponent:1244 |
| this.spdMain | EditorFocused | spdMain_EditorFocused | InitializeComponent:1245 |
| this.spdMain | SubEditorClosed | spdMain_SubEditorClosed | InitializeComponent:1246 |
| this.spdMain | SubEditorOpening | spdMain_SubEditorOpening | InitializeComponent:1247 |
| this.spdMain | TextChanged | spdMain_TextChanged | InitializeComponent:1248 |
| this.spdMain | Enter | spdMain_Enter | InitializeComponent:1249 |
| this.spdMain | KeyDown | spdMain_KeyDown | InitializeComponent:1250 |
| this.spdMain | Leave | spdMain_Leave | InitializeComponent:1251 |
| this.spdMain | Validating | spdMain_Validating | InitializeComponent:1252 |
| this.spdMain | Validated | spdMain_Validated | InitializeComponent:1253 |
| this.btn_column | Click | btnColumn_Click | InitializeComponent:1492 |
| this | Load | Form_Load | .ctor:124 |
| cbo_site | SelectedIndexChanged | cbo_site_changed | InitEvent:402 |
| cbo_pack_plan_group | SelectedIndexChanged | cbo_pack_plan_group_changed | InitEvent:404 |
| cbo_pack_plan_id | SelectedIndexChanged | cbo_pack_plan_id_changed | InitEvent:408 |
| cbo_form_plan_id | SelectedIndexChanged | cbo_form_plan_id_changed | InitEvent:409 |
| cbo_cell_plan_id | SelectedIndexChanged | cbo_cell_plan_id_changed | InitEvent:410 |
| date_instance | ValueChanged | plan_day_changed | InitEvent:413 |
| range_plan | ValueChanged | plan_range_changed | InitEvent:414 |
| txt_pack_code | TextChanged | pack_code_changed | InitEvent:416 |
| txt_cell_code | TextChanged | cell_code_changed | InitEvent:417 |
| txt_pack_nick | TextChanged | pack_nick_changed | InitEvent:418 |
| txt_cell_nick | TextChanged | cell_nick_changed | InitEvent:419 |
| chk_form_plan_group | CheckedChanged | chk_changed | InitEvent:422 |
| chk_pack_plan_group | CheckedChanged | chk_changed | InitEvent:423 |
| chk_cell_plan_group | CheckedChanged | chk_changed | InitEvent:424 |
| spdMain | CellClick | spdMain_CellClick2 | InitEvent:426 |
| popSql | OnSql | RunSqlSource | btnSql_Click:1274 |
| bucke_menu | Click | onZeroBucketMenu | spdMain_CellClick2:4163 |
| memo_menu | Click | onMemoMenu | spdMain_CellClick2:4173 |
| bucke_menu | Click | onZeroMaterialMenu | spdMain_CellClick2:4188 |
| bucke_menu | Click | onZeroMaterialMenu | spdMain_CellClick2:4200 |
| nlfamend_menu | Click | onNLFAmendMenu | spdMain_CellClick2:4207 |
| range_plan | ValueChanged | plan_range_changed | plan_range_changed:4518 |
| range_plan | ValueChanged | plan_range_changed | plan_range_changed:4526 |
| this.btnToggleSave | Click | btnToggleSave_Click | InitializeComponent:556 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:882 |
| this.btnExcelImport | Click | btnExcelImport_Click | InitializeComponent:922 |
| this.btnStatus | Click | btnStatus_Click | InitializeComponent:1269 |
| this.btnDWSubmit | Click | btnDwSubmit_Click | InitializeComponent:1307 |
| this.btnDppCopy | Click | btnDppWppCopy_Click | InitializeComponent:1346 |
| this.btnSSP | Click | btnSSP_Click | InitializeComponent:1383 |
| this.btnMRP | Click | btnMRP_Click | InitializeComponent:1420 |
| this.btnRelease | Click | btnRelease_Click | InitializeComponent:1457 |
| this.btnMemo | Click | btnMemo_Click | InitializeComponent:1566 |
| this.spdMain | ChildControlDeactivated | spdMain_ChildControlDeactivated | InitializeComponent:1578 |
| this.spdMain | EditModeOn | spdMain_EditModeOn | InitializeComponent:1579 |
| this.spdMain | EditModeOff | spdMain_EditModeOff | InitializeComponent:1580 |
| this.spdMain | ActiveSheetChanged | spdMain_ActiveSheetChanged | InitializeComponent:1581 |
| this.spdMain | TableChanged | spdMain_TableChanged | InitializeComponent:1582 |
| this.spdMain | Change | spdMain_Change | InitializeComponent:1583 |
| this.spdMain | DragFillBlockCompleted | spdMain_DragFillBlockCompleted | InitializeComponent:1584 |
| this.spdMain | ButtonClicked | spdMain_ButtonClicked | InitializeComponent:1585 |
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:1586 |
| this.spdMain | EditChange | spdMain_EditChange | InitializeComponent:1587 |
| this.spdMain | EditorFocused | spdMain_EditorFocused | InitializeComponent:1588 |
| this.spdMain | SubEditorClosed | spdMain_SubEditorClosed | InitializeComponent:1589 |
| this.spdMain | SubEditorOpening | spdMain_SubEditorOpening | InitializeComponent:1590 |
| this.spdMain | TextChanged | spdMain_TextChanged | InitializeComponent:1591 |
| this.spdMain | Enter | spdMain_Enter | InitializeComponent:1592 |
| this.spdMain | KeyDown | spdMain_KeyDown | InitializeComponent:1593 |
| this.spdMain | Leave | spdMain_Leave | InitializeComponent:1594 |
| this.spdMain | Validating | spdMain_Validating | InitializeComponent:1595 |
| this.spdMain | Validated | spdMain_Validated | InitializeComponent:1596 |
| this.button1 | Click | button1_Click | InitializeComponent:1727 |
| this.btn_column | Click | btnColumn_Click | InitializeComponent:2011 |

## 6. 컨트롤 (161개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 37 | lblSql, lblData, layoutControlItem15, layoutControlItem10, layoutControlItem22, layoutControlItem11, layoutControlItem29, layoutControlItem8, layoutControlItem5, layoutControlItem3, layoutControlItem30, layoutControlItem20, layoutControlItem17, layoutControlItem6, layoutControlItem4 … |
| UsrButton | 19 | btnToggleSave, btnSql, btnReplan, usrButton2, btn_column, btnToggleSave, btnSql, btnExcelImport, btnStatus, btnDWSubmit, btnDppCopy, btnSSP, btnMRP, btnRelease, btnReplan … |
| UsrCombo | 14 | cbo_form_plan_id, cbo_form_plan_group, cbo_cell_plan_id, cbo_cell_plan_group, cbo_pack_plan_group, cbo_pack_plan_id, cbo_site, cbo_form_plan_id, cbo_form_plan_group, cbo_cell_plan_id, cbo_cell_plan_group, cbo_pack_plan_group, cbo_pack_plan_id, cbo_site |
| EmptySpaceItem | 14 | emptySpaceItem4, emptySpaceItem2, emptySpaceItem3, emptySpaceItem1, emptySpaceItem5, emptySpaceItem6, emptySpaceItem7, emptySpaceItem4, emptySpaceItem2, emptySpaceItem3, emptySpaceItem1, emptySpaceItem5, emptySpaceItem6, emptySpaceItem7 |
| Label | 13 | label1, label3, txtBuilding, txtBasic, txtDesc, txtCreation, txtCreator, label7, label6, label5, label4, label2, label1 |
| UsrTextBox | 8 | txt_cell_nick, txt_pack_code, txt_pack_nick, txt_cell_code, txt_cell_nick, txt_pack_code, txt_pack_nick, txt_cell_code |
| Panel | 8 | panel2, panel4, panel1, infoPanel, menuPanel, panel2, panel4, panel1 |
| UsrCheckBox | 6 | chk_pack_plan_group, chk_cell_plan_group, chk_form_plan_group, chk_pack_plan_group, chk_cell_plan_group, chk_form_plan_group |
| FpSpread | 5 | spdMain, spdEdit, spdMain, spdEdit, spdInfo |
| SheetView | 5 | spdMain_Sheet1, spdEdit_Sheet1, spdMain_Sheet1, spdEdit_Sheet1, spdInfo_Sheet1 |
| UsrLayoutControl | 4 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 4 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| UsrLabel | 4 | txtPlanId, usrLabel2, txtPlanId, usrLabel2 |
| DataGridView | 4 | dgEditCell, dgEditForm, dgEditPack, dgEdit |
| UsrConditionPanel | 2 | usrConditionPanel1, usrConditionPanel1 |
| UsrDatePicker2 | 2 | date_instance, date_instance |
| UsrDateRangePicker2 | 2 | range_plan, range_plan |
| SplitContainer | 2 | splitter, splitter |
| TextBox | 2 | tbLog, tbLog |
| Splitter | 2 | splitter2, splitter1 |
| ImageList | 2 | imageList1, imageList1 |
| Button | 1 | button1 |
| GroupBox | 1 | groupBox1 |

## 7. 확인 필요 (82건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 5559 | btnStatus_Click | FP_Master.PR_UI_FP00602_FIND_FP0060 | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 5568 | btnStatus_Click | FP_Master.PR_UI_FP00602_FIND_FP0060 | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 5559 | btnStatus_Click | FP_Master.PR_UI_FP00602_FIND_FP0060 | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 5568 | btnStatus_Click | FP_Master.PR_UI_FP00602_FIND_FP0060 | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 5132 | btnStatus_Click | FP_Master.PR_UI_FP00602_FIND_FP0060 | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 5141 | btnStatus_Click | FP_Master.PR_UI_FP00602_FIND_FP0060 | NOT_IN_FOXQUERY | DB에도 없음 (폐기/오타 가능) · SP 직접호출 또는 미등록 — DB 단계에서 확인 |
| 1069 | Save_Data | FP\{?default:part_service}\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1203 | SetReleaseProcess | FP\{?default:part_service}\XpCommonAmend#find_isCurrWeek | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2318 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2319 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2320 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2321 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1216 | Save_Data | FP\{?default:part_service}\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1682 | SetReleaseProcess | FP\{?default:part_service}\XpCommonAmend#find_isCurrWeek | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2667 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2668 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2669 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2670 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2885 | call_Excel_Col_Save | FP\{?default:part_service}\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2964 | SaveExcelRows | FP\{?default:part_service}\AmendValidation#find_save_seq | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 3152 | call_Excel_Row_Save | FP\{?default:part_service}\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 3165 | call_Excel_Row_Save | FP\{?default:part_service}\AmendValidation#find_save_seq | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1216 | Save_Data | FP\{?default:part_service}\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1682 | SetReleaseProcess | FP\{?default:part_service}\XpCommonAmend#find_isCurrWeek | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2667 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2668 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2669 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2670 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2885 | call_Excel_Col_Save | FP\{?default:part_service}\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2964 | SaveExcelRows | FP\{?default:part_service}\AmendValidation#find_save_seq | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 3152 | call_Excel_Row_Save | FP\{?default:part_service}\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 3165 | call_Excel_Row_Save | FP\{?default:part_service}\AmendValidation#find_save_seq | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1205 | Save_Data | FP\{?default:part_service}\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1671 | SetReleaseProcess | FP\{?default:part_service}\XpCommonAmend#find_isCurrWeek | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2253 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#find_WeekCnt | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2254 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#find_DateMap | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2255 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#find_MonthCnt | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2256 | ApplyAmendCalendarCondition | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#find_bukInfo | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2471 | call_Excel_Col_Save | FP\{?default:part_service}\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2550 | SaveExcelRows | FP\{?default:part_service}\AmendValidation#find_save_seq | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2738 | call_Excel_Row_Save | FP\{?default:part_service}\XpCommonCond#find_AMend_Save_Check | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2751 | call_Excel_Row_Save | FP\{?default:part_service}\AmendValidation#find_save_seq | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 3093 | call_Excel_Col_Validation | FP\{?default:part_service}\FP00602_EXCELIMPORTROW#delete_Excel_buffer | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 3281 | call_Excel_Row_Validation | FP\{?default:part_service}\FP00602_EXCELIMPORT#delete_Excel_buffer | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 3296 | call_Excel_Row_Validation | FP\{?default:part_service}\FP00602_EXCELIMPORT#delete_Excel_buffer | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 5168 | btnSSP_Click | FP\{?default:part_service}\XpCommonAmend#saveAll_SSP_Transit | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 5203 | btnMRP_Click | FP\{?default:part_service}\XpCommonAmend#saveAll_MRP_Transit | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 3093 | call_Excel_Col_Validation | FP\{?default:part_service}\FP00602_EXCELIMPORTROW#delete_Excel_buffer | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 3281 | call_Excel_Row_Validation | FP\{?default:part_service}\FP00602_EXCELIMPORT#delete_Excel_buffer | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 3296 | call_Excel_Row_Validation | FP\{?default:part_service}\FP00602_EXCELIMPORT#delete_Excel_buffer | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 5168 | btnSSP_Click | FP\{?default:part_service}\XpCommonAmend#saveAll_SSP_Transit | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 5203 | btnMRP_Click | FP\{?default:part_service}\XpCommonAmend#saveAll_MRP_Transit | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2679 | call_Excel_Col_Validation | FP\{?default:part_service}\FP00602_EXCELIMPORTROW#delete_Excel_buffer | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2867 | call_Excel_Row_Validation | FP\{?default:part_service}\FP00602_EXCELIMPORT#delete_Excel_buffer | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2882 | call_Excel_Row_Validation | FP\{?default:part_service}\FP00602_EXCELIMPORT#delete_Excel_buffer | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 4741 | btnSSP_Click | FP\{?default:part_service}\XpCommonAmend#saveAll_SSP_Transit | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 4776 | btnMRP_Click | FP\{?default:part_service}\XpCommonAmend#saveAll_MRP_Transit | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 5144 | btnSSP_Click | FP\{?default:part_service}\XpCommonAmend#find_save_chk | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 5179 | btnMRP_Click | FP\{?default:part_service}\XpCommonAmend#find_save_chk | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 5454 | btnDppWppCopy_Click | FP\{?default:part_service}\XpCommonAmend#find_save_chk | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 5501 | btnDwSubmit_Click | FP\{?default:part_service}\XpCommonAmend#find_save_chk | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 5144 | btnSSP_Click | FP\{?default:part_service}\XpCommonAmend#find_save_chk | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 5179 | btnMRP_Click | FP\{?default:part_service}\XpCommonAmend#find_save_chk | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 5454 | btnDppWppCopy_Click | FP\{?default:part_service}\XpCommonAmend#find_save_chk | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 5501 | btnDwSubmit_Click | FP\{?default:part_service}\XpCommonAmend#find_save_chk | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 4717 | btnSSP_Click | FP\{?default:part_service}\XpCommonAmend#find_save_chk | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 4752 | btnMRP_Click | FP\{?default:part_service}\XpCommonAmend#find_save_chk | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 5027 | btnDppWppCopy_Click | FP\{?default:part_service}\XpCommonAmend#find_save_chk | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 5074 | btnDwSubmit_Click | FP\{?default:part_service}\XpCommonAmend#find_save_chk | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1090 | Save_Data | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#saveAll_MPPWPP | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1237 | Save_Data | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#saveAll_MPPWPP | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 3098 | call_Excel_Col_Validation | FP\{?default:part_service}\FP00602_EXCELIMPORTROW#insert_Excel_buffer | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 3286 | call_Excel_Row_Validation | FP\{?default:part_service}\FP00602_EXCELIMPORT#insert_Excel_buffer | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 3301 | call_Excel_Row_Validation | FP\{?default:part_service}\FP00602_EXCELIMPORT#insert_Excel_buffer | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1237 | Save_Data | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#saveAll_MPPWPP | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 3098 | call_Excel_Col_Validation | FP\{?default:part_service}\FP00602_EXCELIMPORTROW#insert_Excel_buffer | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 3286 | call_Excel_Row_Validation | FP\{?default:part_service}\FP00602_EXCELIMPORT#insert_Excel_buffer | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 3301 | call_Excel_Row_Validation | FP\{?default:part_service}\FP00602_EXCELIMPORT#insert_Excel_buffer | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 1226 | Save_Data | FP\{?default:part_service}\FP00602_PlanAmendLineAssy#saveAll_MPPWPP | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2684 | call_Excel_Col_Validation | FP\{?default:part_service}\FP00602_EXCELIMPORTROW#insert_Excel_buffer | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2872 | call_Excel_Row_Validation | FP\{?default:part_service}\FP00602_EXCELIMPORT#insert_Excel_buffer | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |
| 2887 | call_Excel_Row_Validation | FP\{?default:part_service}\FP00602_EXCELIMPORT#insert_Excel_buffer | MATCH_PATTERN | 후보 복수 — 패턴 매칭, 실행 시 결정 · matches=1 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_MST_SHEET_COLUMNS | 19 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 2 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 6 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 17 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | FP00631 | Main | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 | 19/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Main
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@RefreshHeaderOnly:704, SetSheetHeaderColumn_FP@RefreshHeaderOnly:610, SetSheetHeaderColumn_FP@RefreshHeaderOnly:693

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitializeComponent |  | 1269 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1270 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1271 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1272 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 1574 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1575 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1576 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1577 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| RefreshHeader |  | 584 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Blue} |  | if(monthInfo != null) ⟫ if(calendar != null && dsMainFiltered.Good()) ⟫ if(day_measure != null && day_measure.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ if(date.isSatureDay()) ⟫ if(index > -1) |
| RefreshHeader |  | 590 | 표시/라벨 변경 | set:ForeColor | ForeColor = {?System.Drawing.Color.Red} |  | if(monthInfo != null) ⟫ if(calendar != null && dsMainFiltered.Good()) ⟫ if(day_measure != null && day_measure.On) ⟫ foreach(date_item in calendar.Days) ⟫ if(date != null) ⟫ else!(date.isSatureDay()) ⟫ if(date.IsSunDay()) ⟫ if(index > -1) |
| InitializeComponent |  | 1612 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1613 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1614 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1615 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 2055 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 2056 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 2057 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 2058 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 2106 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 2107 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 2108 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 2109 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Main | META+코드연결 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 | 19 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
