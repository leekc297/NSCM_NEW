# AS-IS 실측 요약 — FP00631

- 실행: 2026-11-12 19:08:05.382 ~ 2026-11-12 19:08:56.684 · 계정 jaeuk.shin · 상태 OK
- 화면: Cell Simulation(Cell~Pack) (GSCM.FP.Planning.UIL.FP00631_Cell_Simul_Cell_Pack)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: AS-IS 화면 기본값

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 19:08:06.285 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.11 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00631 |
| 19:08:06.305 | load | GSCM.FP_Common | SELECT * | 351 | 10.11 | USER_ID= |
| 19:08:06.336 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 31.72 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 19:08:06.547 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 8.93 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 19:08:06.552 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.3 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 19:08:06, END_TIME=2026-11-12 19:08:06, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112190806_539, PA |
| 19:08:06.995 | load | GSCM.FP_Common | SELECT SITE_ID AS CODE | 2 | 371.95 | USER_ID=jaeuk.shin |
| 19:08:07.016 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 19.57 | PROG_ID=find_site, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : IS_REL_ |
| 19:08:07.073 | load | GSCM.FP_Common | SELECT A.SEGMENT1 AS SITE_ID | 8 | 37.26 | SITE_ID=A003 |
| 19:08:07.097 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.98 | PROG_ID=find_instance, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0SITE_ID
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check client parameter : IS_REL_FORM
---Check |
| 19:08:07.222 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 3.69 | LOGTYPE=SpeedUp, NOTE=FP00631
instance_id_changed
start
, USER_ID=jaeuk.shin |
| 19:08:07.247 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 24.94 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 19:08:07.483 | load | GSCM.FP_Common | WITH SITE_T AS ( | 1 | 227.88 |  |
| 19:08:07.507 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 22.75 | PROG_ID=find_currdate, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_LT
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check client parameter : IS_REL_FORM
---C |
| 19:08:07.764 | load | GSCM.FP_Common | SELECT CONVERT(VARCHAR, MAX(A.RELEASE_TIME), 20) AS LAST_TIME | 1 | 252.97 |  |
| 19:08:07.801 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 36.1 | PROG_ID=find_LastestReleaseTime, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_LT
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check client parameter : IS_REL |
| 19:08:07.848 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 40.55 | LOGTYPE=SpeedUp, NOTE=FP00631
instance_id_changed
end
, USER_ID=jaeuk.shin |
| 19:08:07.882 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 32.5 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 19:08:08.109 | load | GSCM.FP_Common | WITH SITE_T AS ( | 1 | 220.92 |  |
| 19:08:08.156 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 46.49 | PROG_ID=find_currdate, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_LT
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check client parameter : IS_REL_FORM
---C |
| 19:08:08.169 | load | GSCM.FP_Common | WITH CURR_DATE AS ( | 1 | 6.12 | PLAN_DATE=20261111 |
| 19:08:08.219 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 49.71 | PROG_ID=find_bucketdate, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0PLAN_DATE
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check client parameter : IS_REL_FORM
---C |
| 19:08:08.303 | load | GSCM.FP_Common | SELECT A.PLAN_ID AS CODE, A.PLAN_ID AS NAME | 0 | 74.31 | PLAN_DATE=20261111, INSTANCE_ID=US_PACK |
| 19:08:08.308 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.61 | PROG_ID=find_plan, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check clien |
| 19:08:08.371 | load | GSCM.FP_Common | SELECT A.PLAN_ID AS CODE, A.PLAN_ID AS NAME | 0 | 54.8 | PLAN_DATE=20261111, INSTANCE_ID=US_FORM_A |
| 19:08:08.375 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.21 | PROG_ID=find_plan, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check clien |
| 19:08:08.431 | load | GSCM.FP_Common | SELECT A.PLAN_ID AS CODE, A.PLAN_ID AS NAME | 0 | 47.44 | PLAN_DATE=20261111, INSTANCE_ID=US_CELL |
| 19:08:08.436 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.28 | PROG_ID=find_plan, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check clien |
| 19:08:08.452 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.47 | p_program_id=FP00631, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:08:08.485 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 19 | 25.31 | p_program_id=FP00631, p_sheet_name=Main |
| 19:08:08.493 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.05 | p_program_id=FP00631, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 19:08:08.501 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 19 | 3.84 | p_program_id=FP00631, p_sheet_name=Main |
| 19:08:08.737 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 78.17 | MenuID=Cell Simulation(Cell~Pack), CnntCode=0104001, UserID=jaeuk.shin |
| 19:08:08.921 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.05 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00631 |
| 19:08:55.916 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 6.73 | MenuID=Cell Simulation(Cell~Pack), CnntCode=0104002, UserID=jaeuk.shin |

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

- 2026-11-12 19:08:18.476 [] Plan ID(Pack) is Required → default_button(id=1)
