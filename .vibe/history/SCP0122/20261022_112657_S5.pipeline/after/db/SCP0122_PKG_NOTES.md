# PKG_SCP0122 이식 메모

프로시저 3개. 각 프로시저 끝의 /* ASIS … */ 원문을 Oracle 로 옮기고 블록을 지운다. O_RC 수는 As-is 최상위 SELECT 수에서 추정 — FE 플랜(e2e_plan.json procs)과 맞춘다.

- P_SCP0121_GET_SEARCH_INFO: 임시테이블 #division_info, #line_master, #osp_plant_info → GTT(03_GTT) 또는 WITH 절/컬렉션으로
- P_SCP0122_GET_PLAN_ACTIVITY_MGMT: 첫 결과셋 컬럼(As-is 실측 15): DIVISION_ID(nvarchar(30)), OPMZ_PRS_CD(nvarchar(30)), OPMZ_PRS_NAME(nvarchar(100)), OPMZ_PLAN_GR_ID(nvarchar(30)), OPMZ_PLAN_GR_NAME(nvarchar(100)), OPMZ_ACTV_SEQ(tinyint), OPMZ_ACTV_CD(nvarchar(30)), OPMZ_ACTV_NAME(nvarchar(30)), LINK_UI_TYPE(nvarchar(150)), PROGRAM_NAME(nvarchar(150)), CONFIRM_YN(nvarchar(150)), AUTO_YN(nvarchar(150)), OPTION_YN(nvarchar(150)), PRE_OPMZ_ACTV_CD(nvarchar(30)), PRE_OPMZ_ACTV_SEQ(tinyint)
- P_SCP0122_SAVE_PLAN_ACTIVITY_MGMT: TRY/CATCH → EXCEPTION WHEN OTHERS(골격 포함) / 하위 SP 호출 PR_SCM_SYS_LOG_BATCH, SCP0122_SCP_OPMZ_PLAN_GR_ACTV_HIST → 해당 To-Be PKG.PROC 로 (공통이면 PKG_COM0000/PKG_DM0000)
