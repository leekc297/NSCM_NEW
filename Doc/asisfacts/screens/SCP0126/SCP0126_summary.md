# SCP0126 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0126_CAPA\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0126_CAPA\SCP0126_CAPA.csproj | 37 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0126_CAPA\Properties\Resources.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0126_CAPA\SCP0126_CAPA.csproj | 72 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0126_CAPA\Properties\Settings.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0126_CAPA\SCP0126_CAPA.csproj | 31 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0126_CAPA\SCP0126_CAPA.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0126_CAPA\SCP0126_CAPA.csproj | 4222 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0126_CAPA\SCP0126_CAPA.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0126_CAPA\SCP0126_CAPA.csproj | 828 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0126_CAPA\SCP0126_NoWork_BatchPopup.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0126_CAPA\SCP0126_CAPA.csproj | 536 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0126_CAPA\SCP0126_NoWork_BatchPopup.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0126_CAPA\SCP0126_CAPA.csproj | 590 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0126_CAPA\SCP0126_SingleDatePopup.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0126_CAPA\SCP0126_CAPA.csproj | 748 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0126_CAPA\SCP0126_SingleDatePopup.designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0126_CAPA\SCP0126_CAPA.csproj | 427 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:btnBatchSave.Click | BtnBatchSave_Click > FindData_Main | 1257 | {?string.Empty} | UNRESOLVED |  |
| event:btnBatchSave.Click | BtnBatchSave_Click > FindData_Main | 1257 | SCP.SCP0126_GET_DAILY_CAPA | MATCH | SP SCP0126_GET_DAILY_CAPA |
| event:btnBatchSave.Click | BtnBatchSave_Click > FindData_Main | 1257 | SCP.SCP0126_GET_NO_WORK_WEEK | MATCH | SP SCP0126_GET_NO_WORK_WEEK |
| event:btnBatchSave.Click | BtnBatchSave_Click > FindData_Main | 1257 | SCP.SCP0126_GET_NO_WORK | MATCH | SP SCP0126_GET_NO_WORK |
| event:btnBatchSave.Click | BtnBatchSave_Click > FindData_Main | 1257 | SCP.SCP0126_GET_SOP_EOP | MATCH | SP SCP0126_GET_SOP_EOP |
| event:btnBatchSave.Click | BtnBatchSave_Click > FindData_Main | 1257 | SCP.SCP0126_GET_RAMP_UP | MATCH | SP SCP0126_GET_RAMP_UP |
| event:btnBatchSave.Click | BtnBatchSave_Click > FindData_Main | 1257 | SCP.SCP0126_GET_RAMP_UP_ITVL | MATCH | SP SCP0126_GET_RAMP_UP_ITVL |
| event:btnBatchSave.Click | BtnBatchSave_Click > FindData_Main | 1257 | SCP.SCP0126_GET_PREP_RT | MATCH | SP SCP0126_GET_PREP_RT |
| event:btnBatchSave.Click | BtnBatchSave_Click > FindData_Main | 1257 | SCP.SCP0126_GET_UTIL_RT | MATCH | SP SCP0126_GET_UTIL_RT |
| event:btnBatchSave.Click | BtnBatchSave_Click > FindData_Main | 1257 | SCP.SCP0126_GET_YLD_ELEC | MATCH | SP SCP0126_GET_YLD_ELEC |
| button:FindButton | FindButton > FindData_Main | 1257 | {?string.Empty} | UNRESOLVED |  |
| button:FindButton | FindButton > FindData_Main | 1257 | SCP.SCP0126_GET_DAILY_CAPA | MATCH | SP SCP0126_GET_DAILY_CAPA |
| button:FindButton | FindButton > FindData_Main | 1257 | SCP.SCP0126_GET_NO_WORK_WEEK | MATCH | SP SCP0126_GET_NO_WORK_WEEK |
| button:FindButton | FindButton > FindData_Main | 1257 | SCP.SCP0126_GET_NO_WORK | MATCH | SP SCP0126_GET_NO_WORK |
| button:FindButton | FindButton > FindData_Main | 1257 | SCP.SCP0126_GET_SOP_EOP | MATCH | SP SCP0126_GET_SOP_EOP |
| button:FindButton | FindButton > FindData_Main | 1257 | SCP.SCP0126_GET_RAMP_UP | MATCH | SP SCP0126_GET_RAMP_UP |
| button:FindButton | FindButton > FindData_Main | 1257 | SCP.SCP0126_GET_RAMP_UP_ITVL | MATCH | SP SCP0126_GET_RAMP_UP_ITVL |
| button:FindButton | FindButton > FindData_Main | 1257 | SCP.SCP0126_GET_PREP_RT | MATCH | SP SCP0126_GET_PREP_RT |
| button:FindButton | FindButton > FindData_Main | 1257 | SCP.SCP0126_GET_UTIL_RT | MATCH | SP SCP0126_GET_UTIL_RT |
| button:FindButton | FindButton > FindData_Main | 1257 | SCP.SCP0126_GET_YLD_ELEC | MATCH | SP SCP0126_GET_YLD_ELEC |
| button:SaveButton | SaveButton > SaveData | 411 | SCP.SCP0126_SAVE_NO_WORK_BATCH | MATCH | SP SCP0126_SAVE_NO_WORK_BATCH |
| button:SaveButton | SaveButton > Save_YieldElec > FindData_Main | 1257 | {?string.Empty} | UNRESOLVED |  |
| button:SaveButton | SaveButton > Save_YieldElec > FindData_Main | 1257 | SCP.SCP0126_GET_DAILY_CAPA | MATCH | SP SCP0126_GET_DAILY_CAPA |
| button:SaveButton | SaveButton > Save_YieldElec > FindData_Main | 1257 | SCP.SCP0126_GET_NO_WORK_WEEK | MATCH | SP SCP0126_GET_NO_WORK_WEEK |
| button:SaveButton | SaveButton > Save_YieldElec > FindData_Main | 1257 | SCP.SCP0126_GET_NO_WORK | MATCH | SP SCP0126_GET_NO_WORK |
| button:SaveButton | SaveButton > Save_YieldElec > FindData_Main | 1257 | SCP.SCP0126_GET_SOP_EOP | MATCH | SP SCP0126_GET_SOP_EOP |
| button:SaveButton | SaveButton > Save_YieldElec > FindData_Main | 1257 | SCP.SCP0126_GET_RAMP_UP | MATCH | SP SCP0126_GET_RAMP_UP |
| button:SaveButton | SaveButton > Save_YieldElec > FindData_Main | 1257 | SCP.SCP0126_GET_RAMP_UP_ITVL | MATCH | SP SCP0126_GET_RAMP_UP_ITVL |
| button:SaveButton | SaveButton > Save_YieldElec > FindData_Main | 1257 | SCP.SCP0126_GET_PREP_RT | MATCH | SP SCP0126_GET_PREP_RT |
| button:SaveButton | SaveButton > Save_YieldElec > FindData_Main | 1257 | SCP.SCP0126_GET_UTIL_RT | MATCH | SP SCP0126_GET_UTIL_RT |
| button:SaveButton | SaveButton > Save_YieldElec > FindData_Main | 1257 | SCP.SCP0126_GET_YLD_ELEC | MATCH | SP SCP0126_GET_YLD_ELEC |
| button:SaveButton | SaveButton > Save_NoWork | 1550 | SCP.SCP0126_SAVE_NO_WORK | MATCH | SP SCP0126_SAVE_NO_WORK |
| button:SaveButton | SaveButton > Save_NoWork_Week | 1736 | SCP.SCP0126_SAVE_NO_WORK_WEEK | MATCH | SP SCP0126_SAVE_NO_WORK_WEEK |
| button:SaveButton | SaveButton > Save_DailyCapa | 2041 | SCP.SCP0126_SAVE_DAILY_CAPA | MATCH | SP SCP0126_SAVE_DAILY_CAPA |
| button:SaveButton | SaveButton > Save_SopEop | 2263 | SCP.SCP0126_SAVE_SOP_EOP | MATCH | SP SCP0126_SAVE_SOP_EOP |
| button:SaveButton | SaveButton > Save_Rampup | 2546 | SCP.SCP0126_SAVE_RAMP_UP | MATCH | SP SCP0126_SAVE_RAMP_UP |
| button:SaveButton | SaveButton > Save_Rampup_Itvl | 2827 | SCP.SCP0126_SAVE_RAMP_UP_ITVL | MATCH | SP SCP0126_SAVE_RAMP_UP_ITVL |
| button:SaveButton | SaveButton > Save_PrepRt | 3096 | SCP.SCP0126_SAVE_PREP_RT | MATCH | SP SCP0126_SAVE_PREP_RT |
| button:SaveButton | SaveButton > Save_UtilRt | 3352 | SCP.SCP0126_SAVE_UTIL_RT | MATCH | SP SCP0126_SAVE_UTIL_RT |
| button:SaveButton | SaveButton > Save_YieldElec | 3559 | SCP.SCP0126_SAVE_YLD_ELEC | MATCH | SP SCP0126_SAVE_YLD_ELEC |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveButton > SaveData | 411 | SCP.SCP0126_SAVE_NO_WORK_BATCH | MATCH | SP SCP0126_SAVE_NO_WORK_BATCH |
| event:this.Load | Form_Load > InitControls > GetDivision | 526 | SCM.SCM0001_GET_DIVISION | MATCH | SP SCM0001_GET_DIVISION |
| unreached:(진입점 미연결) | GetSearchInfo | 152 | SCP.SCP0126_GET_CAPA_SEARCH_INFO | MATCH | SP SCP0126_GET_CAPA_SEARCH_INFO |
| unreached:(진입점 미연결) | GetSearchInfo | 324 | SCP.SCP0126_GET_CAPA_SEARCH_INFO | MATCH | SP SCP0126_GET_CAPA_SEARCH_INFO |
| unreached:(진입점 미연결) | GetPlanGroupByUserID | 358 | SCP.SCP0121_GET_SEARCH_INFO | MATCH | SP SCP0121_GET_SEARCH_INFO |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| {?string.Empty} | UNRESOLVED | 1 |  |  |  |
| SCM.SCM0001_GET_DIVISION | MATCH | 1 | SP SCM0001_GET_DIVISION | EXEC:SCM0001_GET_DIVISION, SELECT:SCM_MST_DIVISION |  |
| SCP.SCP0121_GET_SEARCH_INFO | MATCH | 1 | SP SCP0121_GET_SEARCH_INFO | EXEC:SCP0121_GET_SEARCH_INFO, INSERT:#DIVISION_INFO, SELECT:SCM_MST_DIVISION, INSERT:#LINE_MASTER, SELECT:SCM_MST_LINE_SN, SELECT:SCM_MST_FACTORY_SN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, INSERT:#OSP_PLANT_INFO, SELECT:SCM_MST_LINE_OSP, SELECT:SCM_MST_SITE, SELECT:SCM_MST_VENDOR, SELECT:#LINE_MASTER, SELECT:#DIVISION_INFO, SELECT:SCP_MST_CAPA_LINE, SELECT:#OSP_PLANT_INFO, SELECT:SCP_OPMZ_PLAN_GR_M, SELECT:SCM_ADM_LOOKUP_MASTER, SELECT:SCM_OPERATION_M_SN |  |
| SCP.SCP0126_GET_CAPA_SEARCH_INFO | MATCH | 2 | SP SCP0126_GET_CAPA_SEARCH_INFO | EXEC:SCP0126_GET_CAPA_SEARCH_INFO, INSERT:#DIVISION_INFO, SELECT:SCM_MST_DIVISION, INSERT:#LINE_MASTER, SELECT:SCM_MST_LINE_SN, SELECT:SCM_MST_FACTORY_SN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, INSERT:#OSP_PLANT_INFO, SELECT:SCM_MST_LINE_OSP, SELECT:SCM_MST_SITE, SELECT:SCM_MST_VENDOR, SELECT:#LINE_MASTER, SELECT:#DIVISION_INFO, SELECT:SCP_MST_CAPA_LINE, SELECT:#OSP_PLANT_INFO, SELECT:SCM_ADM_LOOKUP_MASTER, SELECT:SCM_OPERATION_M_SN |  |
| SCP.SCP0126_GET_DAILY_CAPA | MATCH | 1 | SP SCP0126_GET_DAILY_CAPA | EXEC:SCP0126_GET_DAILY_CAPA, SELECT:SCM_MST_ITEM_LINE_ASSIGN_SN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:DIVISION_INFO, SELECT:PLAN_GR_LINE, SELECT:SCM_MST_ITEM_SN, SELECT:LINE_MASTER, SELECT:SCP_OPMZ_DDLY_CAPA, REF:STRING_SPLIT, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_LINE_SN, SELECT:SCM_MST_FACTORY_SN, SELECT:SCP_OPMZ_PLAN_GR_LINE_M, SELECT:SCP_OPMZ_PLAN_GR_M |  |
| SCP.SCP0126_GET_NO_WORK | MATCH | 1 | SP SCP0126_GET_NO_WORK | EXEC:SCP0126_GET_NO_WORK, SELECT:SCP_OPMZ_NO_WORK, SELECT:PLAN_GROUP_LINE, SELECT:LINE_MASTER, SELECT:SCM_SYS_CALENDAR_M, REF:STRING_SPLIT, SELECT:SCM_MST_LINE_SN, SELECT:SCM_MST_FACTORY_SN, SELECT:SCP_OPMZ_PLAN_GR_LINE_M, SELECT:SCP_OPMZ_PLAN_GR_M, SELECT:SCM_MST_ITEM_LINE_ASSIGN_SN, SELECT:SCP_OPMZ_LOOKUP_MASTER_DETAIL, SELECT:SCP_OPMZ_SOP_EOP |  |
| SCP.SCP0126_GET_NO_WORK_WEEK | MATCH | 1 | SP SCP0126_GET_NO_WORK_WEEK | EXEC:SCP0126_GET_NO_WORK_WEEK, SELECT:SCP_OPMZ_NO_WORK, SELECT:PLAN_GROUP_LINE, SELECT:LINE_MASTER, SELECT:SCM_SYS_CALENDAR_M, REF:STRING_SPLIT, SELECT:SCM_MST_LINE_SN, SELECT:SCM_MST_FACTORY_SN, SELECT:SCP_OPMZ_PLAN_GR_LINE_M, SELECT:SCP_OPMZ_PLAN_GR_M, SELECT:SCM_MST_ITEM_LINE_ASSIGN_SN, SELECT:SCP_OPMZ_LOOKUP_MASTER_DETAIL, SELECT:SCP_OPMZ_SOP_EOP |  |
| SCP.SCP0126_GET_PREP_RT | MATCH | 1 | SP SCP0126_GET_PREP_RT | EXEC:SCP0126_GET_PREP_RT, SELECT:SCP_OPMZ_PREP_RT, SELECT:PLAN_GROUP_LINE, SELECT:LINE_MASTER, REF:STRING_SPLIT, SELECT:SCM_MST_LINE_SN, SELECT:SCM_MST_FACTORY_SN, SELECT:SCP_OPMZ_PLAN_GR_LINE_M, SELECT:SCP_OPMZ_PLAN_GR_M, SELECT:SCM_MST_ITEM_LINE_ASSIGN_SN, SELECT:SCM_SYS_CALENDAR_M, SELECT:SCP_OPMZ_LOOKUP_MASTER_DETAIL, SELECT:SCP_OPMZ_SOP_EOP |  |
| SCP.SCP0126_GET_RAMP_UP | MATCH | 1 | SP SCP0126_GET_RAMP_UP | EXEC:SCP0126_GET_RAMP_UP, SELECT:SCP_OPMZ_RAMP_UP, SELECT:PLAN_GROUP_LINE, SELECT:SCM_MST_ITEM_SN, SELECT:LINE_MASTER, REF:STRING_SPLIT, SELECT:SCM_MST_LINE_SN, SELECT:SCM_MST_FACTORY_SN, SELECT:SCM_MST_LINE_OSP, SELECT:SCM_MST_SITE, SELECT:SCM_MST_VENDOR, SELECT:SCP_OPMZ_PLAN_GR_LINE_M, SELECT:SCP_OPMZ_PLAN_GR_M |  |
| SCP.SCP0126_GET_RAMP_UP_ITVL | MATCH | 1 | SP SCP0126_GET_RAMP_UP_ITVL | EXEC:SCP0126_GET_RAMP_UP_ITVL, SELECT:SCP_OPMZ_RAMP_UP_ITVL, SELECT:PLAN_GROUP_LINE, SELECT:SCM_MST_ITEM_SN, SELECT:LINE_MASTER, REF:STRING_SPLIT, SELECT:SCM_MST_LINE_SN, SELECT:SCM_MST_FACTORY_SN, SELECT:SCM_MST_LINE_OSP, SELECT:SCM_MST_SITE, SELECT:SCM_MST_VENDOR, SELECT:SCP_OPMZ_PLAN_GR_LINE_M, SELECT:SCP_OPMZ_PLAN_GR_M |  |
| SCP.SCP0126_GET_SOP_EOP | MATCH | 1 | SP SCP0126_GET_SOP_EOP | EXEC:SCP0126_GET_SOP_EOP, SELECT:SCP_OPMZ_SOP_EOP, SELECT:PLAN_GROUP_LINE, SELECT:SCM_MST_ITEM_SN, SELECT:LINE_MASTER, REF:STRING_SPLIT, SELECT:SCM_MST_LINE_SN, SELECT:SCM_MST_FACTORY_SN, SELECT:SCM_MST_LINE_OSP, SELECT:SCM_MST_SITE, SELECT:SCM_MST_VENDOR, SELECT:SCP_OPMZ_PLAN_GR_LINE_M, SELECT:SCP_OPMZ_PLAN_GR_M |  |
| SCP.SCP0126_GET_UTIL_RT | MATCH | 1 | SP SCP0126_GET_UTIL_RT | EXEC:SCP0126_GET_UTIL_RT, SELECT:SCP_OPMZ_UTIL_RT, SELECT:PLAN_GROUP_LINE, SELECT:LINE_MASTER, REF:STRING_SPLIT, SELECT:SCM_MST_LINE_SN, SELECT:SCM_MST_FACTORY_SN, SELECT:SCM_MST_LINE_OSP, SELECT:SCM_MST_SITE, SELECT:SCM_MST_VENDOR, SELECT:SCP_OPMZ_PLAN_GR_LINE_M, SELECT:SCP_OPMZ_PLAN_GR_M, SELECT:SCM_MST_ITEM_LINE_ASSIGN_SN, SELECT:SCM_SYS_CALENDAR_M, SELECT:SCP_OPMZ_LOOKUP_MASTER_DETAIL, SELECT:SCP_OPMZ_SOP_EOP |  |
| SCP.SCP0126_GET_YLD_ELEC | MATCH | 1 | SP SCP0126_GET_YLD_ELEC | EXEC:SCP0126_GET_YLD_ELEC, SELECT:SCP_OPMZ_YLD_ELEC, SELECT:PLAN_GROUP_LINE, SELECT:SCM_MST_ITEM_SN, REF:STRING_SPLIT, SELECT:SCM_MST_LINE_SN, SELECT:SCM_MST_FACTORY_SN, SELECT:SCP_OPMZ_PLAN_GR_LINE_M, SELECT:SCM_MST_ITEM_LINE_ASSIGN_SN, SELECT:SCM_SYS_CALENDAR_M, SELECT:SCP_OPMZ_LOOKUP_MASTER_DETAIL, SELECT:SCP_OPMZ_SOP_EOP, SELECT:SCP_OPMZ_PLAN_GR_M |  |
| SCP.SCP0126_SAVE_DAILY_CAPA | MATCH | 1 | SP SCP0126_SAVE_DAILY_CAPA | EXEC:SCP0126_SAVE_DAILY_CAPA, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SCP_OPMZ_DDLY_CAPA, INSERT:SCP_OPMZ_DDLY_CAPA, UPDATE:SCP_OPMZ_DDLY_CAPA, DELETE:SCP_OPMZ_DDLY_CAPA, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0126_SAVE_NO_WORK | MATCH | 1 | SP SCP0126_SAVE_NO_WORK | EXEC:SCP0126_SAVE_NO_WORK, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SCP_OPMZ_NO_WORK, INSERT:SCP_OPMZ_NO_WORK, UPDATE:SCP_OPMZ_NO_WORK, DELETE:SCP_OPMZ_NO_WORK, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0126_SAVE_NO_WORK_BATCH | MATCH | 1 | SP SCP0126_SAVE_NO_WORK_BATCH | EXEC:SCP0126_SAVE_NO_WORK_BATCH, EXEC:PR_SCM_SYS_LOG_BATCH, CREATE:#DATERANGE, CREATE:#PATTERNWEEK, CREATE:#PATTERNTEMP, CREATE:#PATTERNDATA, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, INSERT:#PATTERNWEEK, INSERT:#DATERANGE, SELECT:#PATTERNWEEK, INSERT:#PATTERNTEMP, SELECT:#DATERANGE, INSERT:#DIVISION_INFO, SELECT:SCM_MST_DIVISION, DELETE:SCP_OPMZ_NO_WORK, REF:STRING_SPLIT, INSERT:SCP_OPMZ_NO_WORK, SELECT:SCM_MST_LINE_SN, SELECT:SCM_MST_FACTORY_SN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:#DIVISION_INFO, SELECT:#PATTERNTEMP, SELECT:SCP_OPMZ_NO_WORK, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0126_SAVE_NO_WORK_WEEK | MATCH | 1 | SP SCP0126_SAVE_NO_WORK_WEEK | EXEC:SCP0126_SAVE_NO_WORK_WEEK, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SCM_SYS_CALENDAR_M, DELETE:SCP_OPMZ_NO_WORK, SELECT:SCP_OPMZ_NO_WORK, INSERT:SCP_OPMZ_NO_WORK, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0126_SAVE_PREP_RT | MATCH | 1 | SP SCP0126_SAVE_PREP_RT | EXEC:SCP0126_SAVE_PREP_RT, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SCP_OPMZ_PREP_RT, INSERT:SCP_OPMZ_PREP_RT, UPDATE:SCP_OPMZ_PREP_RT, DELETE:SCP_OPMZ_PREP_RT, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0126_SAVE_RAMP_UP | MATCH | 1 | SP SCP0126_SAVE_RAMP_UP | EXEC:SCP0126_SAVE_RAMP_UP, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SCP_OPMZ_RAMP_UP, INSERT:SCP_OPMZ_RAMP_UP, UPDATE:SCP_OPMZ_RAMP_UP, DELETE:SCP_OPMZ_RAMP_UP, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0126_SAVE_RAMP_UP_ITVL | MATCH | 1 | SP SCP0126_SAVE_RAMP_UP_ITVL | EXEC:SCP0126_SAVE_RAMP_UP_ITVL, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SCP_OPMZ_RAMP_UP_ITVL, INSERT:SCP_OPMZ_RAMP_UP_ITVL, UPDATE:SCP_OPMZ_RAMP_UP_ITVL, DELETE:SCP_OPMZ_RAMP_UP_ITVL, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0126_SAVE_SOP_EOP | MATCH | 1 | SP SCP0126_SAVE_SOP_EOP | EXEC:SCP0126_SAVE_SOP_EOP, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SCP_OPMZ_SOP_EOP, INSERT:SCP_OPMZ_SOP_EOP, UPDATE:SCP_OPMZ_SOP_EOP, DELETE:SCP_OPMZ_SOP_EOP, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0126_SAVE_UTIL_RT | MATCH | 1 | SP SCP0126_SAVE_UTIL_RT | EXEC:SCP0126_SAVE_UTIL_RT, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SCP_OPMZ_UTIL_RT, INSERT:SCP_OPMZ_UTIL_RT, UPDATE:SCP_OPMZ_UTIL_RT, DELETE:SCP_OPMZ_UTIL_RT, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0126_SAVE_YLD_ELEC | MATCH | 1 | SP SCP0126_SAVE_YLD_ELEC | EXEC:SCP0126_SAVE_YLD_ELEC, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SCP_OPMZ_YLD_ELEC, INSERT:SCP_OPMZ_YLD_ELEC, UPDATE:SCP_OPMZ_YLD_ELEC, DELETE:SCP_OPMZ_YLD_ELEC, INSERT:SCM_SYS_LOG_BATCH |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| ClbDivision_SelectedIndexChanged | dtExptDiv.Rows[i] | SHEET_NAME |
| CreateSpread | dtExptDiv.Rows[i] | SHEET_NAME |
| GetOperationByLine | dtPlant.Rows[0] | CODE |
| GetOperationByLine | dtTemp.Rows[0] | OPERATION_ID |
| GetPlanGroupByUserID | TheOne.Security.FoxUserInfoContext.Current | NowGroupID |
| InitControls | row | CODE, NAME |
| InitControls | rowFix | CODE, NAME |
| InitControls | drBucketDayRow | CODE, NAME |
| InitControls | drBucketWeekhRow | CODE, NAME |
| RefreshLine | dtTemp.Rows[0] | ORG_DIVISION_ID |
| RefreshLine | dtLineCombo.Rows[i] | NAME, CODE |
| RefreshLineByCombo | dtTemp.Rows[0] | ORG_DIVISION_ID |
| RefreshLineByCombo | dtLineCombo.Rows[i] | NAME, CODE |
| RefreshOperationByDivision | dtOperation.Rows[i] | NAME, CODE |
| RefreshPlantIdByCombo | dtTemp.Rows[0] | ORG_DIVISION_ID |
| RefreshPlantIdByCombo | dtPlantCombo.Rows[i] | NAME, CODE |
| RefreshPlantIdByDivision | dtTemp.Rows[0] | ORG_DIVISION_ID |
| RefreshPlantIdByDivision | dtPlantCombo.Rows[i] | NAME, CODE |
| SpdMain_ClipboardPasted | dtLineAll.Select("CODE = '" + lineId + "'")[0] | LINE_NAME |
| SpdMain_ComboSelChange | dtLineCombo.Rows[i] | NAME, CODE |
| SpdMain_ComboSelChange | dtLineAll.Select("CODE = '" + lineId + "'")[0] | LINE_NAME |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | RefreshPlanGroupByDivision:374, RefreshPlantIdByDivision:382, RefreshPlantIdByCombo:425, RefreshPlantIdByCombo:426, RefreshLine:466, RefreshLine:467, RefreshLineByCombo:505, RefreshOperationByDivision:539 | CString.GetCheckedListValue | CODE |
| SetSheetHeaderColumn | InitSpread:661, InitSpread:674, InitSpread:698, SetSpreadInit:728 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| SaveData | SaveButton:252 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:193 |
| cboDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitEvent:734 |
| cboPlanGroup | SelectedIndexChanged | CboPlanGroup_SelectedIndexChanged | InitEvent:735 |
| clbPlant | SelectedIndexChanged | ClbPlant_SelectedIndexChanged | InitEvent:736 |
| cboBucketType | SelectedIndexChanged | cboBucketType_SelectedIndexChanged | InitEvent:737 |
| btnExcelUpload | Click | BtnExcelUpload_Click | InitEvent:738 |
| btnExcelForm | Click | BtnExcelForm_Click | InitEvent:739 |
| btnBatchSave | Click | BtnBatchSave_Click | InitEvent:740 |
| this.spdMain | CellClick | SpdMain_CellClick | InitEvent:742 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:743 |
| this.spdMain | ActiveSheetChanged | SpdMain_ActiveSheetChanged | InitEvent:744 |
| this.spdMain | ActiveSheetChanging | SpdMain_ActiveSheetChanging | InitEvent:745 |
| this.spdMain | ClipboardPasted | SpdMain_ClipboardPasted | InitEvent:746 |
| this.spdMain | ComboSelChange | SpdMain_ComboSelChange | InitEvent:747 |
| _defaultDataModel | Changed | _defaultDataModel_Changed | InitEvent:751 |
| this.clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | InitializeComponent:237 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:339 |
| this | Load | Form_Load | .ctor:95 |
| this.spdMain | CellClick | SpdMain_CellClick | InitEvent:181 |
| this | FormClosing | SCP0126_NoWork_BatchPopup_FormClosing | InitEvent:182 |
| this.clbScmSite | SelectedIndexChanged | ClbScmSite_SelectedIndexChanged | InitEvent:183 |
| dgv_Dates | SelectionChanged | dgv_Dates_SelectionChanged | frmDatePicker_Load:113 |
| cmb_Months | SelectedIndexChanged | cmb_Months_SelectedIndexChanged | frmDatePicker_Load:131 |
| dgv_Dates | SelectionChanged | dgv_Dates_SelectionChanged | frmDatePicker_Load:135 |
| cmb_Months | SelectedIndexChanged | cmb_Months_SelectedIndexChanged | frmDatePicker_Load:137 |
| dgv_Dates | SelectionChanged | dgv_Dates_SelectionChanged | dgv_Dates_SelectionChanged:661 |
| dgv_Dates | SelectionChanged | dgv_Dates_SelectionChanged | dgv_Dates_SelectionChanged:665 |
| dgv_Dates | SelectionChanged | dgv_Dates_SelectionChanged | dgv_Dates_SelectionChanged:689 |
| dgv_Dates | SelectionChanged | dgv_Dates_SelectionChanged | dgv_Dates_SelectionChanged:693 |
| this.dgv_Dates | CellEnter | dgvDates_CellEnter | InitializeComponent:140 |
| this.dgv_Dates | SelectionChanged | dgv_Dates_SelectionChanged | InitializeComponent:141 |
| this.dgv_Dates | MouseDoubleClick | dgv_Dates_MouseDoubleClick | InitializeComponent:142 |
| this.btn_NextMonth | Click | btn_NextMonth_Click | InitializeComponent:204 |
| this.btn_PrevMonth | Click | btn_PrevMonth_Click | InitializeComponent:217 |
| this.cmb_Months | SelectedIndexChanged | cmb_Months_SelectedIndexChanged | InitializeComponent:232 |
| this.cmb_Years | SelectedIndexChanged | cmb_Years_SelectedIndexChanged | InitializeComponent:246 |
| this.btnCancel | Click | btnCancel_Click | InitializeComponent:288 |
| this.splitContainer1.Panel2 | Paint | splitContainer1_Panel2_Paint | InitializeComponent:307 |
| this.btnOK | Click | btnOK_Click | InitializeComponent:323 |
| this.btnExit | Click | exitButton_Click | InitializeComponent:356 |
| this | Load | frmDatePicker_Load | InitializeComponent:383 |
| this | Paint | frmDatePicker_Paint | InitializeComponent:384 |

## 6. 컨트롤 (71개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 17 | layoutControlItem9, Division, layoutControlItem3, layoutControlItem1, layoutControlItem2, lciNickName, lciModel, lciExcelUpload, lciExcelForm, lciBatchSave, lciBucketType, layoutControlItem1, lciDivision, lciWeek, lciLine … |
| Panel | 8 | pnBack, panel5, pn_Controls, panel2, pn_Header, panel1, panel4, bg |
| UsrCheckedList2 | 5 | clbLine, clbPlant, clbLine, clbDivision, clbScmSite |
| Button | 5 | btn_NextMonth, btn_PrevMonth, btnCancel, btnOK, btnExit |
| UsrLayoutControl | 4 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 4 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup2 |
| UsrButton | 3 | btnBatchSave, btnExcelForm, btnExcelUpload |
| UsrTextBox | 3 | txtModel, txtNickName, txtWeek |
| Label | 3 | label2, label1, lblCaption |
| UsrConditionPanel | 2 | usrConditionPanel1, usrConditionPanel1 |
| UsrCombo | 2 | cboDivision, cboBucketType |
| EmptySpaceItem | 2 | emptySpaceItem1, emptySpaceItem2 |
| FpSpread | 2 | spdMain, spdMain |
| SheetView | 2 | spdMain_Sheet1, spdMain_Sheet1 |
| ComboBox | 2 | cmb_Months, cmb_Years |
| UsrMonthRangePicker | 1 | mrpPeriod |
| UsrComboBox | 1 | cboPlanGroup |
| UsrButtonList | 1 | btnButtonList |
| UsrDateRangePicker3 | 1 | drpPeriod |
| DataGridView | 1 | dgv_Dates |
| ToolTip | 1 | toolTip1 |
| SplitContainer | 1 | splitContainer1 |

## 7. 확인 필요 (1건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 1257 | FindData_Main | {?string.Empty} | UNRESOLVED | 빈 값(미사용 코드 경로) |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 440 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_ADM_EXCEL_COLUMNS | 1 | dbmeta_dbo_SCM_ADM_EXCEL_COLUMNS.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL | 49 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL_H | 124 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL_H.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 131 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_GroupMenuAuth | 3 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (1건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 527 | DM.Get_Division | commented:NOT_IN_FOXQUERY |

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0126 | Daily Capa | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 |
| SCM_MST_SHEET_COLUMNS | SCP0126 | No Work | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 | 18/0 |
| SCM_MST_SHEET_COLUMNS | SCP0126 | Preparation Rate | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 |
| SCM_MST_SHEET_COLUMNS | SCP0126 | Ramp-up(From/To) | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 | 17/0 |
| SCM_MST_SHEET_COLUMNS | SCP0126 | Ramp-up(Interval) | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 | 23/0 |
| SCM_MST_SHEET_COLUMNS | SCP0126 | SOP/EOP | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 | 16/0 |
| SCM_MST_SHEET_COLUMNS | SCP0126 | Utilization Rate | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 | 13/0 |
| SCM_MST_SHEET_COLUMNS | SCP0126 | Yield(Elec.) | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 | 12/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: No Work, Daily Capa, SOP/EOP, Ramp-up(From/To), Ramp-up(Interval), Preparation Rate, Utilization Rate, Yield(Elec.), ?_spdSheets[i], No Work Popup
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:661, SetSheetHeaderColumn@InitSpread:674, SetSheetHeaderColumn@InitSpread:698, SetSheetHeaderColumn@SetSpreadInit:728
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): AddGridViewColumns

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SetVisibleSheetColumns |  | 764 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, SpdSheet.shtNoWork)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtDailyCapa)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtSopEop)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampup)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampupItvl)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtPrepRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtUtilRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtYield)} \|\| {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} \|\| {?GetSheetInfo(spdMain.Name, _spdSheets[i])} |  | if(_sActiveSheetName == "Daily Capa") ⟫ if(division.IndexOf("EE_UC") >= 0) |
| SetVisibleSheetColumns |  | 765 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, SpdSheet.shtNoWork)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtDailyCapa)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtSopEop)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampup)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampupItvl)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtPrepRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtUtilRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtYield)} \|\| {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} \|\| {?GetSheetInfo(spdMain.Name, _spdSheets[i])} |  | if(_sActiveSheetName == "Daily Capa") ⟫ if(division.IndexOf("EE_UC") >= 0) |
| SetVisibleSheetColumns |  | 766 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, SpdSheet.shtNoWork)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtDailyCapa)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtSopEop)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampup)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampupItvl)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtPrepRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtUtilRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtYield)} \|\| {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} \|\| {?GetSheetInfo(spdMain.Name, _spdSheets[i])} |  | if(_sActiveSheetName == "Daily Capa") ⟫ if(division.IndexOf("EE_UC") >= 0) |
| SetVisibleSheetColumns |  | 767 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, SpdSheet.shtNoWork)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtDailyCapa)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtSopEop)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampup)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampupItvl)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtPrepRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtUtilRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtYield)} \|\| {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} \|\| {?GetSheetInfo(spdMain.Name, _spdSheets[i])} |  | if(_sActiveSheetName == "Daily Capa") ⟫ if(division.IndexOf("EE_UC") >= 0) |
| SetVisibleSheetColumns |  | 772 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, SpdSheet.shtNoWork)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtDailyCapa)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtSopEop)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampup)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampupItvl)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtPrepRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtUtilRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtYield)} \|\| {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} \|\| {?GetSheetInfo(spdMain.Name, _spdSheets[i])} |  | if(_sActiveSheetName == "Daily Capa") ⟫ else!(division.IndexOf("EE_UC") >= 0) ⟫ if(division.IndexOf("EE") >= 0) |
| SetVisibleSheetColumns |  | 773 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, SpdSheet.shtNoWork)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtDailyCapa)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtSopEop)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampup)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampupItvl)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtPrepRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtUtilRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtYield)} \|\| {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} \|\| {?GetSheetInfo(spdMain.Name, _spdSheets[i])} |  | if(_sActiveSheetName == "Daily Capa") ⟫ else!(division.IndexOf("EE_UC") >= 0) ⟫ if(division.IndexOf("EE") >= 0) |
| SetVisibleSheetColumns |  | 774 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, SpdSheet.shtNoWork)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtDailyCapa)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtSopEop)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampup)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampupItvl)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtPrepRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtUtilRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtYield)} \|\| {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} \|\| {?GetSheetInfo(spdMain.Name, _spdSheets[i])} |  | if(_sActiveSheetName == "Daily Capa") ⟫ else!(division.IndexOf("EE_UC") >= 0) ⟫ if(division.IndexOf("EE") >= 0) |
| SetVisibleSheetColumns |  | 775 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, SpdSheet.shtNoWork)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtDailyCapa)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtSopEop)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampup)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampupItvl)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtPrepRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtUtilRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtYield)} \|\| {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} \|\| {?GetSheetInfo(spdMain.Name, _spdSheets[i])} |  | if(_sActiveSheetName == "Daily Capa") ⟫ else!(division.IndexOf("EE_UC") >= 0) ⟫ if(division.IndexOf("EE") >= 0) |
| SetVisibleSheetColumns |  | 779 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, SpdSheet.shtNoWork)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtDailyCapa)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtSopEop)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampup)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampupItvl)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtPrepRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtUtilRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtYield)} \|\| {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} \|\| {?GetSheetInfo(spdMain.Name, _spdSheets[i])} |  | if(_sActiveSheetName == "Daily Capa") ⟫ else!(division.IndexOf("EE_UC") >= 0) ⟫ else!(division.IndexOf("EE") >= 0) |
| SetVisibleSheetColumns |  | 780 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, SpdSheet.shtNoWork)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtDailyCapa)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtSopEop)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampup)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampupItvl)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtPrepRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtUtilRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtYield)} \|\| {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} \|\| {?GetSheetInfo(spdMain.Name, _spdSheets[i])} |  | if(_sActiveSheetName == "Daily Capa") ⟫ else!(division.IndexOf("EE_UC") >= 0) ⟫ else!(division.IndexOf("EE") >= 0) |
| SetVisibleSheetColumns |  | 781 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, SpdSheet.shtNoWork)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtDailyCapa)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtSopEop)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampup)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampupItvl)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtPrepRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtUtilRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtYield)} \|\| {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} \|\| {?GetSheetInfo(spdMain.Name, _spdSheets[i])} |  | if(_sActiveSheetName == "Daily Capa") ⟫ else!(division.IndexOf("EE_UC") >= 0) ⟫ else!(division.IndexOf("EE") >= 0) |
| SetVisibleSheetColumns |  | 782 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, SpdSheet.shtNoWork)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtDailyCapa)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtSopEop)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampup)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampupItvl)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtPrepRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtUtilRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtYield)} \|\| {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} \|\| {?GetSheetInfo(spdMain.Name, _spdSheets[i])} |  | if(_sActiveSheetName == "Daily Capa") ⟫ else!(division.IndexOf("EE_UC") >= 0) ⟫ else!(division.IndexOf("EE") >= 0) |
| SetVisibleSheetColumns |  | 793 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, SpdSheet.shtNoWork)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtDailyCapa)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtSopEop)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampup)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampupItvl)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtPrepRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtUtilRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtYield)} \|\| {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} \|\| {?GetSheetInfo(spdMain.Name, _spdSheets[i])} |  | else!(_sActiveSheetName == "Daily Capa") ⟫ if(_sActiveSheetName == "No Work") ⟫ if(bucketType == "W") |
| SetVisibleSheetColumns |  | 794 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, SpdSheet.shtNoWork)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtDailyCapa)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtSopEop)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampup)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampupItvl)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtPrepRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtUtilRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtYield)} \|\| {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} \|\| {?GetSheetInfo(spdMain.Name, _spdSheets[i])} |  | else!(_sActiveSheetName == "Daily Capa") ⟫ if(_sActiveSheetName == "No Work") ⟫ if(bucketType == "W") |
| SetVisibleSheetColumns |  | 795 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, SpdSheet.shtNoWork)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtDailyCapa)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtSopEop)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampup)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampupItvl)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtPrepRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtUtilRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtYield)} \|\| {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} \|\| {?GetSheetInfo(spdMain.Name, _spdSheets[i])} |  | else!(_sActiveSheetName == "Daily Capa") ⟫ if(_sActiveSheetName == "No Work") ⟫ if(bucketType == "W") |
| SetVisibleSheetColumns |  | 796 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, SpdSheet.shtNoWork)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtDailyCapa)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtSopEop)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampup)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampupItvl)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtPrepRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtUtilRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtYield)} \|\| {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} \|\| {?GetSheetInfo(spdMain.Name, _spdSheets[i])} |  | else!(_sActiveSheetName == "Daily Capa") ⟫ if(_sActiveSheetName == "No Work") ⟫ if(bucketType == "W") |
| SetVisibleSheetColumns |  | 797 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, SpdSheet.shtNoWork)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtDailyCapa)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtSopEop)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampup)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampupItvl)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtPrepRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtUtilRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtYield)} \|\| {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} \|\| {?GetSheetInfo(spdMain.Name, _spdSheets[i])} |  | else!(_sActiveSheetName == "Daily Capa") ⟫ if(_sActiveSheetName == "No Work") ⟫ if(bucketType == "W") |
| SetVisibleSheetColumns |  | 802 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, SpdSheet.shtNoWork)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtDailyCapa)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtSopEop)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampup)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampupItvl)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtPrepRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtUtilRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtYield)} \|\| {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} \|\| {?GetSheetInfo(spdMain.Name, _spdSheets[i])} |  | else!(_sActiveSheetName == "Daily Capa") ⟫ if(_sActiveSheetName == "No Work") ⟫ else!(bucketType == "W") |
| SetVisibleSheetColumns |  | 803 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, SpdSheet.shtNoWork)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtDailyCapa)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtSopEop)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampup)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampupItvl)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtPrepRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtUtilRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtYield)} \|\| {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} \|\| {?GetSheetInfo(spdMain.Name, _spdSheets[i])} |  | else!(_sActiveSheetName == "Daily Capa") ⟫ if(_sActiveSheetName == "No Work") ⟫ else!(bucketType == "W") |
| SetVisibleSheetColumns |  | 804 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, SpdSheet.shtNoWork)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtDailyCapa)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtSopEop)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampup)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampupItvl)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtPrepRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtUtilRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtYield)} \|\| {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} \|\| {?GetSheetInfo(spdMain.Name, _spdSheets[i])} |  | else!(_sActiveSheetName == "Daily Capa") ⟫ if(_sActiveSheetName == "No Work") ⟫ else!(bucketType == "W") |
| SetVisibleSheetColumns |  | 805 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, SpdSheet.shtNoWork)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtDailyCapa)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtSopEop)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampup)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampupItvl)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtPrepRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtUtilRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtYield)} \|\| {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} \|\| {?GetSheetInfo(spdMain.Name, _spdSheets[i])} |  | else!(_sActiveSheetName == "Daily Capa") ⟫ if(_sActiveSheetName == "No Work") ⟫ else!(bucketType == "W") |
| SetVisibleSheetColumns |  | 806 | 표시/라벨 변경 | SetVisibleSheetColumn | {?GetSheetInfo(spdMain.Name, SpdSheet.shtNoWork)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtDailyCapa)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtSopEop)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampup)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtRampupItvl)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtPrepRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtUtilRt)} \|\| {?GetSheetInfo(spdMain.Name, SpdSheet.shtYield)} \|\| {?GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)} \|\| {?GetSheetInfo(spdMain.Name, _spdSheets[i])} |  | else!(_sActiveSheetName == "Daily Capa") ⟫ if(_sActiveSheetName == "No Work") ⟫ else!(bucketType == "W") |
| InitializeComponent |  | 677 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 678 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 679 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 680 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread |  | 192 | 하드코딩 | AddTextColumn | Seq | SEQ |  |
| InitSpread |  | 193 | 하드코딩 | AddTextColumn | Day Of Week | DAY_OF_WEEK |  |
| InitSpread |  | 194 | 하드코딩 | AddTextColumn | Off Time(Day) | OFF_TIME |  |
| InitSpread |  | 195 | 하드코딩 | AddTextColumn | Type | NO_WORK_TYPE |  |
| InitSpread |  | 196 | 하드코딩 | AddTextColumn | Desc | DESC |  |
| InitializeComponent |  | 443 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 444 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 445 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 446 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Daily Capa | META+코드연결 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 |
| No Work | META+코드연결 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 | 18 |
| No Work Popup | 코드 하드코딩 전용(메타 없음) | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 |
| Preparation Rate | META+코드연결 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 |
| Ramp-up(From/To) | META+코드연결 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 |
| Ramp-up(Interval) | META+코드연결 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 | 23 |
| SOP/EOP | META+코드연결 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 | 16 |
| Utilization Rate | META+코드연결 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 |
| Yield(Elec.) | META+코드연결 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 | 12 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
