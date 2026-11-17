# AS-IS 실측 요약 — FP00631

- 실행: 2026-11-12 22:04:12.210 ~ 2026-11-12 22:05:09.341 · 계정 jaeuk.shin · 상태 OK
- 화면: Cell Simulation(Cell~Pack) (GSCM.FP.Planning.UIL.FP00631_Cell_Simul_Cell_Pack)
- 조회 결과: None ·  · 완료 판단 dialog
- 조건: 시나리오 {"rule": "recent", "set": [{"name": "date_instance", "prop": "DateTime", "value": "20260918"}]}

## 호출된 SP (화면 로드·조회)

| 시각 | 구간 | 서비스 | SP | 건수 | ms | 인자 |
|---|---|---|---|---|---|---|
| 22:04:12.968 | load | GSCM.BizService.WSL | UP_FX_GetGSCMSecurityACL | 1 | 3.5 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00631 |
| 22:04:12.988 | load | GSCM.FP_Common | SELECT * | 351 | 9.85 | USER_ID= |
| 22:04:13.024 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 34.06 | PROG_ID=get_all_code, QUERY_ID=FP\admin\code_lookup, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service


SELECT * 
     FROM   SCM_CODE_LOOKUP_VALUE A WITH(NOLOCK) 
      , JOB_TYPE=read,  |
| 22:04:13.178 | load | GSCM.FP_Common | UI_FP_COMMON | 0 | 8.28 | code=USER_AUTH, user_id=jaeuk.shin, non_auth=, save_auth=, param1=ADMIN, param2=NONE, param3=, param4=, param5=, param6=, param7=, param8=, param9=, param10=, param11=, param12=, param13=, param14=, param15=, param16=, param17=, param18=, param19=, param20=, param21=, param22=, param23=, param24=, p |
| 22:04:13.182 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.87 | PROG_ID=UI_FP_COMMON, QUERY_ID=FP_Common.UI_FP_COMMON, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=StoredProcedure UI_FP_COMMON, JOB_TYPE=procedure, START_TIME=2026-11-12 22:04:13, END_TIME=2026-11-12 22:04:13, INSERT_ID=jaeuk.shin, LOG_TYPE=SQL, IP_ADDRESS=100.113.200.36, SESSION_ID=20261112220413_17, PAR |
| 22:04:13.435 | load | GSCM.FP_Common | SELECT SITE_ID AS CODE | 2 | 188.48 | USER_ID=jaeuk.shin |
| 22:04:13.461 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 26.12 | PROG_ID=find_site, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---FOUND USER_ID
-- TYPE = nvarchar---Add string Service
---Check client parameter : IS_REL_ |
| 22:04:13.514 | load | GSCM.FP_Common | SELECT A.SEGMENT1 AS SITE_ID | 8 | 39.64 | SITE_ID=A003 |
| 22:04:13.585 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 71.42 | PROG_ID=find_instance, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0SITE_ID
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check client parameter : IS_REL_FORM
---Check |
| 22:04:13.669 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 24.6 | LOGTYPE=SpeedUp, NOTE=FP00631
instance_id_changed
start
, USER_ID=jaeuk.shin |
| 22:04:13.673 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.67 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 22:04:13.892 | load | GSCM.FP_Common | WITH SITE_T AS ( | 1 | 213.01 |  |
| 22:04:13.926 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 33.58 | PROG_ID=find_currdate, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_LT
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check client parameter : IS_REL_FORM
---C |
| 22:04:14.173 | load | GSCM.FP_Common | SELECT CONVERT(VARCHAR, MAX(A.RELEASE_TIME), 20) AS LAST_TIME | 1 | 240.99 |  |
| 22:04:14.191 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 18.11 | PROG_ID=find_LastestReleaseTime, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_LT
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check client parameter : IS_REL |
| 22:04:14.201 | load | GSCM.FP_Common | PR_UI_SQL_LOG | 0 | 3.91 | LOGTYPE=SpeedUp, NOTE=FP00631
instance_id_changed
end
, USER_ID=jaeuk.shin |
| 22:04:14.204 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.56 | PROG_ID=note2, QUERY_ID=FP\Common\Utility, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0USER_ID
---Service Parameter : 1LOGTYPE
---Service Parameter : 2NOTE
---Check client parameter : LOGTYPE
---FOUND LOGTYPE
-- TYPE = nvarchar---Add string Service
---Check client parameter : NOTE
- |
| 22:04:14.424 | load | GSCM.FP_Common | WITH SITE_T AS ( | 1 | 213.79 |  |
| 22:04:14.447 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 21.77 | PROG_ID=find_currdate, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_LT
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check client parameter : IS_REL_FORM
---C |
| 22:04:14.459 | load | GSCM.FP_Common | WITH CURR_DATE AS ( | 1 | 6.28 | PLAN_DATE=20261112 |
| 22:04:14.506 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 46.83 | PROG_ID=find_bucketdate, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0PLAN_DATE
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check client parameter : IS_REL_FORM
---C |
| 22:04:14.600 | load | GSCM.FP_Common | SELECT A.PLAN_ID AS CODE, A.PLAN_ID AS NAME | 0 | 85.6 | PLAN_DATE=20261112, INSTANCE_ID=US_PACK |
| 22:04:14.617 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 17.21 | PROG_ID=find_plan, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check clien |
| 22:04:14.685 | load | GSCM.FP_Common | SELECT A.PLAN_ID AS CODE, A.PLAN_ID AS NAME | 0 | 62.28 | PLAN_DATE=20261112, INSTANCE_ID=US_FORM_A |
| 22:04:14.690 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.89 | PROG_ID=find_plan, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check clien |
| 22:04:14.760 | load | GSCM.FP_Common | SELECT A.PLAN_ID AS CODE, A.PLAN_ID AS NAME | 0 | 64.61 | PLAN_DATE=20261112, INSTANCE_ID=US_CELL |
| 22:04:14.764 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.98 | PROG_ID=find_plan, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check clien |
| 22:04:14.781 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 3.12 | p_program_id=FP00631, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 22:04:14.822 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 19 | 36.79 | p_program_id=FP00631, p_sheet_name=Main |
| 22:04:14.830 | load | GSCM.SCM.Master.WSL | SELECT COUNT(*) AS CNT | 1 | 2.86 | p_program_id=FP00631, p_sheet_name=Main, p_user_id=jaeuk.shin |
| 22:04:14.835 | load | GSCM.SCM.Master.WSL | SELECT C.PROGRAM_ID | 19 | 3.55 | p_program_id=FP00631, p_sheet_name=Main |
| 22:04:15.019 | load | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 86.8 | MenuID=Cell Simulation(Cell~Pack), CnntCode=0104001, UserID=jaeuk.shin |
| 22:04:15.112 | load | GSCM.BizService.WSL | UP_FX_GetSearchCondition | 0 | 3.0 | GroupID=ADMIN, UserID=jaeuk.shin, MenuID=FP00631 |
| 22:04:24.029 | load | GSCM.FP_Common | WITH CURR_DATE AS ( | 1 | 6.19 | PLAN_DATE=20260918 |
| 22:04:24.067 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 37.04 | PROG_ID=find_bucketdate, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0PLAN_DATE
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check client parameter : IS_REL_FORM
---C |
| 22:04:24.080 | load | GSCM.FP_Common | SELECT A.PLAN_ID AS CODE, A.PLAN_ID AS NAME | 3 | 5.88 | PLAN_DATE=20260918, INSTANCE_ID=US_PACK |
| 22:04:24.084 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 3.88 | PROG_ID=find_plan, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check clien |
| 22:04:24.098 | load | GSCM.FP_Common | SELECT A.PLAN_ID AS CODE, A.PLAN_ID AS NAME | 0 | 3.81 | PLAN_DATE=20260918, INSTANCE_ID=US_FORM_A |
| 22:04:24.102 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.58 | PROG_ID=find_plan, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check clien |
| 22:04:24.116 | load | GSCM.FP_Common | SELECT A.PLAN_ID AS CODE, A.PLAN_ID AS NAME | 1 | 5.43 | PLAN_DATE=20260918, INSTANCE_ID=US_CELL |
| 22:04:24.120 | load | GSCM.FP_Common | INSERT INTO [dbo].[TH_UIS_SQL_LOG] | 1 | 4.06 | PROG_ID=find_plan, QUERY_ID=FP\Planning\FP00631_CellSimul_CellPack, QUERY_SEQ=0, INST_SEQ=0, QUERY_VALUE=---Service Parameter : 0INSTANCE_ID
---Service Parameter : 1PLAN_DATE
---Check client parameter : BUCKET
---Check client parameter : USER_ID
---Check client parameter : IS_REL_ASSY
---Check clien |
| 22:05:08.553 | find | GSCM.BizService.WSL | UP_FX_SaveMenuConnect | -1 | 56.85 | MenuID=Cell Simulation(Cell~Pack), CnntCode=0104002, UserID=jaeuk.shin |

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

- 2026-11-12 22:04:29.261 [] Plan ID(Form) is Required → default_button(id=1)
