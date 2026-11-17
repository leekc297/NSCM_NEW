# AS-IS 실측 요약 — FP01883

- 실행: 2026-11-12 19:20:21.958 ~ 2026-11-12 19:20:41.624 · 계정 jaeuk.shin · 상태 OK
- 화면: Instance Authority (GSCM.FP.Admin.UIL.FP01883_Instance_Authority)
- 조회 결과:  · DB : 0s, UI : 1.176s · 완료 판단 status
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:20:22.329 | load | GSCM.BizService.WSL | UP_FX_GetCommonDataList | 7 | 29.55 | Code=MyDivision, Param1=ADMIN, Param2=jaeuk.shin, Param3=, Param4=, Param5=, TimeZone=AS054 |
| 19:20:22.442 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.0 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP01883 |
| 19:20:22.458 | load | GSCM.FP_Common | SELECT * | 351 | 9.57 | USER_ID= |
| 19:20:22.461 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.57 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:20:22.674 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 5.74 | p_program_id=FP01883, p_sheet_name=Instance, p_user_id=jaeuk.shin |
| 19:20:22.702 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 10 | 22.54 | p_program_id=FP01883, p_sheet_name=Instance |
| 19:20:22.713 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.48 | p_program_id=FP01883, p_sheet_name=Instance, p_user_id=jaeuk.shin |
| 19:20:22.722 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 10 | 4.97 | p_program_id=FP01883, p_sheet_name=Instance |
| 19:20:22.735 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.57 | p_program_id=FP01883, p_sheet_name=User, p_user_id=jaeuk.shin |
| 19:20:22.747 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 5 | 6.38 | p_program_id=FP01883, p_sheet_name=User |
| 19:20:22.757 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.17 | p_program_id=FP01883, p_sheet_name=User, p_user_id=jaeuk.shin |
| 19:20:22.767 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 5 | 4.78 | p_program_id=FP01883, p_sheet_name=User |
| 19:20:22.988 | load | GSCM.FP_Common | WITH WITH_ROLE_FACTORY AS ( | 337 | 201.45 | DIVISION_ID=, SITE_ID=, OPERATION_ID=, PLANT_ID=, FACTORY_ID= |
| 19:20:22.993 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.26 | PROG_ID=get_instance_authority, QUERY_ID=FP\Admin\FP01883_Instance_Authority, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0DIVISION_ID
---Service Parameter : 1SITE_ID
---Service Parameter : 2PLANT_ID
---Service Parameter : 3FACTORY_ID
---Service Parameter : 4OPERATION_ID
---Check cli |
| 19:20:23.131 | load | GSCM.FP_Common | SELECT ROW_NUMBER() OVER ( ORDER BY A.INSTANCE_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.P | 1 | 7.85 | ROLE_ID=279 |
| 19:20:23.155 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.3 | PROG_ID=find_InstanceInfo_admin, QUERY_ID=FP\ADMIN\FP01883_Instance_Authority, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0ROLE_ID
---Check client parameter : ROLE_ID
---FOUND ROLE_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : USER_ID

      SELECT ROW_NUMBE |
| 19:20:25.374 | load | GSCM.FP_Common | SELECT ROW_NUMBER() OVER ( ORDER BY A.USER_ID ) AS NUM, A.USER_ID AS USER_ID_ALTER, B.USER_NAME, | 475 | 2205.86 | ROLE_ID=279 |
| 19:20:25.397 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.92 | PROG_ID=find_UserList_admin, QUERY_ID=FP\ADMIN\FP01883_Instance_Authority, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0ROLE_ID
---Check client parameter : ROLE_ID
---FOUND ROLE_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : USER_ID

      SELECT ROW_NUMBER()  |
| 19:20:25.851 | load | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.73 | p_menu_id=FP01883, p_log_type=FIND, p_log_cnt=, p_db_time=0, p_ui_time=3.064, p_user_id=jaeuk.shin |
| 19:20:25.970 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 91.91 | MenuID=Instance Authority, CnntCode=0104001, UserID=jaeuk.shin |
| 19:20:26.126 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.14 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP01883 |
| 19:20:34.289 | find | GSCM.FP_Common | WITH WITH_ROLE_FACTORY AS ( | 337 | 20.53 | DIVISION_ID=, SITE_ID=, OPERATION_ID=, PLANT_ID=, FACTORY_ID= |
| 19:20:34.294 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.56 | PROG_ID=get_instance_authority, QUERY_ID=FP\Admin\FP01883_Instance_Authority, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0DIVISION_ID
---Service Parameter : 1SITE_ID
---Service Parameter : 2PLANT_ID
---Service Parameter : 3FACTORY_ID
---Service Parameter : 4OPERATION_ID
---Check cli |
| 19:20:34.601 | find | GSCM.FP_Common | SELECT ROW_NUMBER() OVER ( ORDER BY A.INSTANCE_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.P | 1 | 3.59 | ROLE_ID=279 |
| 19:20:34.622 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 19.98 | PROG_ID=find_InstanceInfo_admin, QUERY_ID=FP\ADMIN\FP01883_Instance_Authority, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0ROLE_ID
---Check client parameter : ROLE_ID
---FOUND ROLE_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : USER_ID

      SELECT ROW_NUMBE |
| 19:20:34.812 | find | GSCM.FP_Common | SELECT ROW_NUMBER() OVER ( ORDER BY A.USER_ID ) AS NUM, A.USER_ID AS USER_ID_ALTER, B.USER_NAME, | 475 | 29.68 | ROLE_ID=279 |
| 19:20:34.838 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 25.68 | PROG_ID=find_UserList_admin, QUERY_ID=FP\ADMIN\FP01883_Instance_Authority, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0ROLE_ID
---Check client parameter : ROLE_ID
---FOUND ROLE_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : USER_ID

      SELECT ROW_NUMBER()  |
| 19:20:35.450 | find | GSCM.BizService.WSL | UP_FX_SaveMenuExecutionLog | 0 | 3.53 | p_menu_id=FP01883, p_log_type=FIND, p_log_cnt=, p_db_time=0, p_ui_time=1.176, p_user_id=jaeuk.shin |
| 19:20:40.854 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 7.99 | MenuID=Instance Authority, CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| °Authority ID | txtAuthority |  |
| °Upper Authority Name | txtUpperAuth |  |
| °Authority Desc | txtAuthDesc |  |
| °Approval Flag | cbApproval |  |
| °Insert ID | txtInsert |  |
| °Insert Date | dtInsert |  |
| °Update Date | dtUpdate |  |
| °Update ID | txtUpdate |  |
| °Authority Name | txtAuthorityName2 |  |
| Auth Folder | btn_AuthFolder |  |
| Add | btn_AddDetail |  |
| Del | btn_DelDetail |  |
| Save | btn_SaveDetail |  |
| Add | btn_Add |  |
| Save | btn_Save |  |
| Del | btn_Del |  |

## 그리드

- spdMain / Instance: 행 1 · 컬럼 11(보임 11) · 헤더 1단 · 고정 컬럼 0
- spdMain / User: 행 475 · 컬럼 6(보임 6) · 헤더 1단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음
