# AS-IS 실측 요약 — FP00631

- 실행: 2026-11-13 04:51:29.586 ~ 2026-11-13 04:52:35.744 · 계정 jaeuk.shin · 상태 OK
- 화면: Cell Simulation(Cell~Pack) (GSCM.FP.Planning.UIL.FP00631_Cell_Simul_Cell_Pack)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "date_instance", "prop": "DateTime", "value": "20260918"}, {"name": "date_instance", "prop": "DateTime", "value": "20260917"}, {"name": "date_instance", "prop": "DateTime", "value": "20260916"}, {"name": "date_instance", "prop": "DateTime", "value": "20260915"}, {"name": "date_instance", "prop": "DateTime", "value": "20260914"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 04:51:30.058 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.87 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00631 |
| 04:51:30.076 | load | GSCM.FP_Common | SELECT * | 351 | 9.59 | USER_ID= |
| 04:51:30.081 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.25 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 04:51:30.191 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 25.49 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 04:51:30.195 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.56 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-13 04:51:30, END_TIME=2026-11-13 04:51:30, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045130_165, PA |
| 04:51:30.523 | load | GSCM.FP_Common | SELECT SITE_ID AS CODE | 2 | 303.6 | USER_ID=jaeuk.shin |
| 04:51:30.542 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 18.32 | PROG_ID=find_site, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : IS_REL_ |
| 04:51:30.576 | load | GSCM.FP_Common | SELECT A.SEGMENT1 AS SITE_ID | 8 | 4.76 | SITE_ID=A003 |
| 04:51:30.604 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 26.62 | PROG_ID=find_instance, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0SITE_ID
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check client parameter : IS_REL_FORM
---Check |
| 04:51:30.671 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 3.99 | LOGTYPE=SpeedUp, NOTE=FP00631
instance_id_changed
start
, USER_ID=jaeuk.shin |
| 04:51:30.675 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.98 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 04:51:30.919 | load | GSCM.FP_Common | WITH SITE_T AS ( | 1 | 238.31 |  |
| 04:51:30.942 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 21.89 | PROG_ID=find_currdate, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_LT
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check client parameter : IS_REL_FORM
---C |
| 04:51:31.218 | load | GSCM.FP_Common | SELECT CONVERT(VARCHAR, MAX(A.RELEASE_TIME), 20) AS LAST_TIME | 1 | 260.15 |  |
| 04:51:31.252 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 32.71 | PROG_ID=find_LastestReleaseTime, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_LT
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check client parameter : IS_REL |
| 04:51:31.300 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 32.07 | LOGTYPE=SpeedUp, NOTE=FP00631
instance_id_changed
end
, USER_ID=jaeuk.shin |
| 04:51:31.305 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.42 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 04:51:31.535 | load | GSCM.FP_Common | WITH SITE_T AS ( | 1 | 215.35 |  |
| 04:51:31.559 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 23.42 | PROG_ID=find_currdate, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_LT
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check client parameter : IS_REL_FORM
---C |
| 04:51:31.572 | load | GSCM.FP_Common | WITH CURR_DATE AS ( | 1 | 5.63 | PLAN_DATE=20261112 |
| 04:51:31.612 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 39.19 | PROG_ID=find_bucketdate, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0PLAN_DATE
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check client parameter : IS_REL_FORM
---C |
| 04:51:31.718 | load | GSCM.FP_Common | SELECT A.PLAN_ID AS CODE, A.PLAN_ID AS NAME | 0 | 87.17 | PLAN_DATE=20261112, INSTANCE_ID=US_PACK |
| 04:51:31.724 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.18 | PROG_ID=find_plan, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check clien |
| 04:51:31.789 | load | GSCM.FP_Common | SELECT A.PLAN_ID AS CODE, A.PLAN_ID AS NAME | 0 | 39.35 | PLAN_DATE=20261112, INSTANCE_ID=US_FORM_A |
| 04:51:31.795 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.35 | PROG_ID=find_plan, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check clien |
| 04:51:31.860 | load | GSCM.FP_Common | SELECT A.PLAN_ID AS CODE, A.PLAN_ID AS NAME | 0 | 43.8 | PLAN_DATE=20261112, INSTANCE_ID=US_CELL |
| 04:51:31.866 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.49 | PROG_ID=find_plan, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check clien |
| 04:51:31.891 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.99 | p_program_id=FP00631, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 04:51:31.927 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 19 | 27.19 | p_program_id=FP00631, p_sheet_name=Main |
| 04:51:31.945 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 4.19 | p_program_id=FP00631, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 04:51:31.960 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 19 | 4.84 | p_program_id=FP00631, p_sheet_name=Main |
| 04:51:32.112 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 86.76 | MenuID=Cell Simulation(Cell~Pack), CnntCode=0104001, UserID=jaeuk.shin |
| 04:51:32.243 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.08 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00631 |
| 04:51:40.509 | load | GSCM.FP_Common | WITH CURR_DATE AS ( | 1 | 6.35 | PLAN_DATE=20260918 |
| 04:51:40.543 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 34.04 | PROG_ID=find_bucketdate, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0PLAN_DATE
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check client parameter : IS_REL_FORM
---C |
| 04:51:40.564 | load | GSCM.FP_Common | SELECT A.PLAN_ID AS CODE, A.PLAN_ID AS NAME | 3 | 4.2 | PLAN_DATE=20260918, INSTANCE_ID=US_PACK |
| 04:51:40.596 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 31.29 | PROG_ID=find_plan, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check clien |
| 04:51:40.618 | load | GSCM.FP_Common | SELECT A.PLAN_ID AS CODE, A.PLAN_ID AS NAME | 0 | 3.82 | PLAN_DATE=20260918, INSTANCE_ID=US_FORM_A |
| 04:51:40.623 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.94 | PROG_ID=find_plan, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check clien |
| 04:51:40.636 | load | GSCM.FP_Common | SELECT A.PLAN_ID AS CODE, A.PLAN_ID AS NAME | 1 | 5.59 | PLAN_DATE=20260918, INSTANCE_ID=US_CELL |
| 04:51:40.642 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.43 | PROG_ID=find_plan, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check clien |
| 04:51:43.593 | load | GSCM.FP_Common | WITH CURR_DATE AS ( | 1 | 4.4 | PLAN_DATE=20260917 |
| 04:51:43.621 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 26.09 | PROG_ID=find_bucketdate, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0PLAN_DATE
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check client parameter : IS_REL_FORM
---C |
| 04:51:43.639 | load | GSCM.FP_Common | SELECT A.PLAN_ID AS CODE, A.PLAN_ID AS NAME | 2 | 3.95 | PLAN_DATE=20260917, INSTANCE_ID=US_PACK |
| 04:51:43.644 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.04 | PROG_ID=find_plan, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check clien |
| 04:51:43.658 | load | GSCM.FP_Common | SELECT A.PLAN_ID AS CODE, A.PLAN_ID AS NAME | 0 | 3.4 | PLAN_DATE=20260917, INSTANCE_ID=US_FORM_A |
| 04:51:43.662 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.22 | PROG_ID=find_plan, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check clien |
| 04:51:43.675 | load | GSCM.FP_Common | SELECT A.PLAN_ID AS CODE, A.PLAN_ID AS NAME | 0 | 3.58 | PLAN_DATE=20260917, INSTANCE_ID=US_CELL |
| 04:51:43.679 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.32 | PROG_ID=find_plan, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check clien |
| 04:51:46.492 | load | GSCM.FP_Common | WITH CURR_DATE AS ( | 1 | 3.72 | PLAN_DATE=20260916 |
| 04:51:46.522 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 28.06 | PROG_ID=find_bucketdate, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0PLAN_DATE
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check client parameter : IS_REL_FORM
---C |
| 04:51:46.536 | load | GSCM.FP_Common | SELECT A.PLAN_ID AS CODE, A.PLAN_ID AS NAME | 3 | 4.64 | PLAN_DATE=20260916, INSTANCE_ID=US_PACK |
| 04:51:46.541 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.74 | PROG_ID=find_plan, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check clien |
| 04:51:46.559 | load | GSCM.FP_Common | SELECT A.PLAN_ID AS CODE, A.PLAN_ID AS NAME | 0 | 4.41 | PLAN_DATE=20260916, INSTANCE_ID=US_FORM_A |
| 04:51:46.566 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.87 | PROG_ID=find_plan, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check clien |
| 04:51:46.586 | load | GSCM.FP_Common | SELECT A.PLAN_ID AS CODE, A.PLAN_ID AS NAME | 2 | 4.28 | PLAN_DATE=20260916, INSTANCE_ID=US_CELL |
| 04:51:46.608 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 21.91 | PROG_ID=find_plan, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check clien |
| 04:51:49.239 | load | GSCM.FP_Common | WITH CURR_DATE AS ( | 1 | 5.41 | PLAN_DATE=20260915 |
| 04:51:49.260 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 20.07 | PROG_ID=find_bucketdate, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0PLAN_DATE
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check client parameter : IS_REL_FORM
---C |
| 04:51:49.272 | load | GSCM.FP_Common | SELECT A.PLAN_ID AS CODE, A.PLAN_ID AS NAME | 1 | 4.84 | PLAN_DATE=20260915, INSTANCE_ID=US_PACK |
| 04:51:49.277 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.81 | PROG_ID=find_plan, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check clien |
| 04:51:49.290 | load | GSCM.FP_Common | SELECT A.PLAN_ID AS CODE, A.PLAN_ID AS NAME | 0 | 3.69 | PLAN_DATE=20260915, INSTANCE_ID=US_FORM_A |
| 04:51:49.295 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.11 | PROG_ID=find_plan, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check clien |
| 04:51:49.307 | load | GSCM.FP_Common | SELECT A.PLAN_ID AS CODE, A.PLAN_ID AS NAME | 4 | 3.68 | PLAN_DATE=20260915, INSTANCE_ID=US_CELL |
| 04:51:49.311 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.08 | PROG_ID=find_plan, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check clien |
| 04:51:51.953 | load | GSCM.FP_Common | WITH CURR_DATE AS ( | 1 | 4.7 | PLAN_DATE=20260914 |
| 04:51:51.983 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 29.36 | PROG_ID=find_bucketdate, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0PLAN_DATE
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check client parameter : IS_REL_FORM
---C |
| 04:51:52.004 | load | GSCM.FP_Common | SELECT A.PLAN_ID AS CODE, A.PLAN_ID AS NAME | 3 | 5.28 | PLAN_DATE=20260914, INSTANCE_ID=US_PACK |
| 04:51:52.011 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 5.29 | PROG_ID=find_plan, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check clien |
| 04:51:52.041 | load | GSCM.FP_Common | SELECT A.PLAN_ID AS CODE, A.PLAN_ID AS NAME | 2 | 4.3 | PLAN_DATE=20260914, INSTANCE_ID=US_FORM_A |
| 04:51:52.048 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.88 | PROG_ID=find_plan, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check clien |
| 04:51:52.075 | load | GSCM.FP_Common | SELECT A.PLAN_ID AS CODE, A.PLAN_ID AS NAME | 2 | 4.57 | PLAN_DATE=20260914, INSTANCE_ID=US_CELL |
| 04:51:52.081 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.46 | PROG_ID=find_plan, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check clien |
| 04:51:56.895 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.08 | p_program_id=FP00631, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 04:51:56.902 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 19 | 4.11 | p_program_id=FP00631, p_sheet_name=Main |
| 04:51:56.909 | find | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.66 | p_program_id=FP00631, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 04:51:56.916 | find | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 19 | 4.02 | p_program_id=FP00631, p_sheet_name=Main |
| 04:52:10.290 | find | GSCM.FP_Common | SELECT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID | 634 | 13342.66 | PACK_INSTANCE_ID=US_PACK, ASSY_INSTANCE_ID=US_CELL, PLAN_DATE=20260914, BUCKET_FROM=20260914, BUCKET_TO=20261011 |
| 04:52:10.352 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 60.43 | PROG_ID=find_BOM_RATE, QUERY_ID=FP\Planning\FP00631_CELLSIMUL_CELLPACK, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=, JOB_TYPE=read, START_TIME=2026-11-13 04:51:56, END_TIME=2026-11-13 04:52:10, INSERT_ID=jaeuk.shin, LOG_TYPE=PARAM, IP_ADDRESS=100.113.200.36, SESSION_ID=20261113045156_945, PARAM_VALUE={BUC |
| 04:52:10.358 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.57 | PROG_ID=find_BOM_RATE, QUERY_ID=FP\Planning\FP00631_CELLSIMUL_CELLPACK, QUERY_SEQ=1, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0PACK_INSTANCE_ID
---Service Parameter : 1ASSY_INSTANCE_ID
---Service Parameter : 2BUCKET_FROM
---Service Parameter : 3BUCKET_TO
---Service Parameter : 4PLAN_DATE
---Ch |
| 04:52:10.363 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.41 | PROG_ID=find_BOM_RATE, QUERY_ID=FP\Planning\FP00631_CELLSIMUL_CELLPACK, QUERY_SEQ=1, INST_SEQ=1, QUERY_VALUE=    	AND  A.COMPANY_ID  = CC.COMPANY_ID
    	AND  A.DIVISION_ID = CC.DIVISION_ID
    	AND  A.SITE_ID     = CC.SITE_ID
    	AND  A.PARENT_ITEM_ID = CC.ITEM_ID 
    	INNER HASH JOIN ( ---B: CEL |
| 04:52:11.225 | find | GSCM.FP_Common | SELECT A.* | 476 | 830.67 | FORM_INSTANCE_ID=US_FORM_A, BUCKET_FROM=20260914, BUCKET_TO=20261011 |
| 04:52:11.261 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 33.68 | PROG_ID=find_YLD_F6000, QUERY_ID=FP\Planning\FP00631_CELLSIMUL_CELLPACK, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0FORM_INSTANCE_ID
---Service Parameter : 1BUCKET_FROM
---Service Parameter : 2BUCKET_TO
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check |
| 04:52:11.333 | find | GSCM.FP_Common | SELECT CONVERT(VARCHAR, A.RECEIVING_DTTM, 112) AS PLAN_DATE | 0 | 28.18 | FORM_INSTANCE_ID=US_FORM_A |
| 04:52:11.373 | find | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 38.77 | PROG_ID=find_AGING_STOCK, QUERY_ID=FP\Planning\FP00631_CELLSIMUL_CELLPACK, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0FORM_INSTANCE_ID
---Service Parameter : 1PLAN_ID_SCRIPT
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_AS |
| 04:52:35.022 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 5.07 | MenuID=Cell Simulation(Cell~Pack), CnntCode=0104002, UserID=jaeuk.shin |

## 조회조건 (LayoutControl 라벨)

| 라벨 | 컨트롤 | 필수 |
|---|---|---|
| lblSql | btnSql |  |
| Data | btnToggleSave |  |
| Site | cbo_site |  |
| Plan Id(Form) | cbo_form_plan_id |  |
| Instance Date | date_instance |  |
| Plan Period | range_plan |  |
| Plan Group(Pack) | cbo_pack_plan_group |  |
| layoutControlItem8 | chk_pack_plan_group |  |
| Plan Id(Pack) | cbo_pack_plan_id |  |
| Plan Id(Cell) | cbo_cell_plan_id |  |
| Pack Code | txt_pack_code |  |
| Pack Nick Name | txt_pack_nick |  |
| Cell Code | txt_cell_code |  |
| Cell Nick Name | txt_cell_nick |  |
| PlanGroup(Form) | cbo_form_plan_group |  |
| Plan Group(Cell) | cbo_cell_plan_group |  |
| layoutControlItem13 | chk_form_plan_group |  |
| layoutControlItem7 | chk_cell_plan_group |  |

## 그리드

- spdMain / Main: 행 0 · 컬럼 20(보임 19) · 헤더 2단 · 고정 컬럼 0

> 주의: 실행 중 다른 AS-IS 런처가 떠 있었음(GSCM.Launcher.exe(34700)) — 호출 기록에 그쪽 호출이 섞였을 수 있음

## 대화상자

- 2026-11-13 04:52:12.053 [GSCM] 시스템 오류입니다. 담당자에게 화면 캡쳐해서 시스템 담당자에게 전달하세요. → default_button(id=1)
