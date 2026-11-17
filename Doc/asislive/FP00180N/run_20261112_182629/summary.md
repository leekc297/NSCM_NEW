# AS-IS 실측 요약 — FP00180N

- 실행: 2026-11-12 18:26:29.148 ~ 2026-11-12 18:27:04.504 · 계정 jaeuk.shin · 상태 OK
- 화면: Material (GSCM.FP.Master.UIL.FP00180_Material)
- 조회 결과:  · DB : 16.18s, UI : 0.766s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 18:26:29.528 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.43 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00180 |
| 18:26:29.543 | load | GSCM.FP_Common | SELECT * | 351 | 9.75 | USER_ID= |
| 18:26:29.547 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.06 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 18:26:29.646 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 8.07 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 18:26:29.649 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.14 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 18:26:29, END_TIME=2026-11-12 18:26:29, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112182629_638, PA |
| 18:26:32.992 | load | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 4 | 3288.48 | p_sys_type=, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR2_UI_FP00180_FINDITEMTYPE, opt_none=, in_columns=USER_ID^ACTIVE_FLAG^, in_row=mXlVW48SU1c3wPszIA83/w==^Y^, in_row1=, in_row2=, in_row3=, in_row4=, in_row5=, in_row6=, in_row7=, in_row8=, in_row9= |
| 18:26:32.998 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.36 | PROG_ID=PR2_UI_FP00180_FINDITEMTYPE, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR2_UI_FP00180_FINDITEMTYP |
| 18:26:33.141 | load | GSCM.FP_Common | select distinct | 47 | 111.65 | USER_ID=jaeuk.shin |
| 18:26:33.145 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.32 | PROG_ID=list_material_class2, QUERY_ID=FP\COMMON\BigFilter_FP, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : ACTIVE_FLAG


   select distinct
   '(' + a.LEV |
| 18:26:33.314 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 6.67 | p_program_id=FP00180, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 18:26:33.351 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 31 | 32.9 | p_program_id=FP00180, p_sheet_name=Main |
| 18:26:33.358 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.4 | p_program_id=FP00180, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 18:26:33.365 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 31 | 3.93 | p_program_id=FP00180, p_sheet_name=Main |
| 18:26:33.472 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 77.22 | MenuID=Material, CnntCode=0104001, UserID=jaeuk.shin |
| 18:26:33.506 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 2.97 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00180 |
| 18:26:41.552 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.05 | p_program_id=FP00180, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 18:26:41.561 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 31 | 3.93 | p_program_id=FP00180, p_sheet_name=Main |
| 18:26:41.569 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.05 | p_program_id=FP00180, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 18:26:41.578 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 31 | 3.93 | p_program_id=FP00180, p_sheet_name=Main |
| 18:26:53.033 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 108959 | 11441.06 | p_sys_type=Select, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR2_UI_FP00180_FIND_FP00180, opt_none=, in_columns=USER_ID^ACTIVE_FLAG^DIVISION_ID^SITE_ID^, in_row=mXlVW48SU1c3wPszIA83/w==^Y^40,81,81_HD,81_HM,81_ST,81_UC,82^A001,A002,A003,A004,A007,A009^, in_row1=, in_row2=, in_row3= |
| 18:26:53.090 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 56.52 | PROG_ID=PR2_UI_FP00180_FIND_FP00180, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'Select',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR2_UI_FP00180_FIND_ |
| 18:26:58.399 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 0 | 69.1 | p_sys_type=Select, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR2_UI_FP00180_FINDFORMATTRIBUTE, opt_none=, in_columns=USER_ID^ACTIVE_FLAG^DIVISION_ID^SITE_ID^, in_row=mXlVW48SU1c3wPszIA83/w==^Y^40,81,81_HD,81_HM,81_ST,81_UC,82^A001,A002,A003,A004,A007,A009^, in_row1=, in_row2=, in_ |
| 18:26:58.410 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 11.28 | PROG_ID=PR2_UI_FP00180_FINDFORMATTRIBUTE, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'Select',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR2_UI_FP00180_ |
| 18:26:58.501 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 143 | 84.29 | p_sys_type=Select, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR2_UI_FP00180_FINDATTRIBUTE, opt_none=, in_columns=USER_ID^ACTIVE_FLAG^DIVISION_ID^SITE_ID^LOOKUP_TYPE_CODE^, in_row=mXlVW48SU1c3wPszIA83/w==^Y^40,81,81_HD,81_HM,81_ST,81_UC,82^A001,A002,A003,A004,A007,A009^ITEM_ATTRIBU |
| 18:26:58.506 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.81 | PROG_ID=PR2_UI_FP00180_FINDATTRIBUTE, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'Select',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR2_UI_FP00180_FIND |
| 18:26:58.522 | find | GSCM.FP_Common | PR_UI_GENERAL_COMMAND2 | 226 | 6.74 | p_sys_type=Select, p_sys_flag=, p_sys_gubun=, p_user_id=jaeuk.shin, p_proc_name=PR2_UI_FP00180_FINDATTRIBUTE, opt_none=, in_columns=USER_ID^ACTIVE_FLAG^DIVISION_ID^SITE_ID^LOOKUP_TYPE_CODE^, in_row=mXlVW48SU1c3wPszIA83/w==^Y^40,81,81_HD,81_HM,81_ST,81_UC,82^A001,A002,A003,A004,A007,A009^SETUP_ATTRIB |
| 18:26:58.527 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.59 | PROG_ID=PR2_UI_FP00180_FINDATTRIBUTE, QUERY_ID=FP_Common.PR_UI_GENERAL_COMMAND2, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=--GSCM.FP.Common.WSL/FoxDataService.svc
EXEC PR_UI_GENERAL_COMMAND2 @p_sys_type=N'Select',@p_sys_flag=N'',@p_sys_gubun=N'',@p_user_id=N'jaeuk.shin',@p_proc_name=N'PR2_UI_FP00180_FIND |
| 18:26:58.541 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.27 | p_menu_id=FP00180, p_log_type=FIND, p_log_cnt=, p_db_time=16.18, p_ui_time=0.766, p_user_id=jaeuk.shin |
| 18:27:03.391 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.51 | MenuID=Material, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| Site | mcbo_site |  |
| Division. | clbDivision |  |
| Class | tbClass |  |
| layoutControlItem2 | btnExcelImport |  |
| Material Type | cbo_itemType |  |
| Class1 | cbo_class1 |  |
| Class2 | cbo_class2 |  |
| Model | tbModel |  |
| Material | tbMaterial |  |
| Nick Name | tbNickName |  |
| Active | cbo_active |  |
| lblSql | btnSql |  |

## 그리드

- spdMain / Main: 행 108959 · 컬럼 32(보임 31) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
