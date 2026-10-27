
/*
 * Program ID   : PR_SCM_CONV_CELL_PRODUCT_TO_ASSY
 * Description  : 활성화 셀 완제품 코드를 반제품 코드로 전환
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023.06.01   FP Pjt.        Create
 * 
 */

CREATE PROCEDURE [dbo].[PR_CONV_CELL_PRODUCT_TO_ASSY_G630]
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = 'PR_CONV_CELL_PRODUCT_TO_ASSY'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	   = 0
	DECLARE @sysdate     DATETIME2     = GETDATE()
	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))


--insert into conv_scm_item_m
--select distinct company_id, division_id, site_id, applied_model, item_id
--from scm_item_m (nolock)
--where item_class = 'ES1901'

--@@@@@@@@@@@@@@@@@@@@  PR_XIF_SCM_WO_ROLLING_PST 주석처리

	-- Start 로그는 무조건 남김
	--EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate

	BEGIN TRY				

		BEGIN TRAN
		-- ================================================
		-- 로직 추가
		-- ================================================


/* 티라에서 전환 영역

        --FP_AMEND_CUTOFF_BOH_H
        select t.* 
        --update t set t.item_id = ISNULL(s.assy_item_id, t.item_id)
         from FP_AMEND_CUTOFF_BOH_H as t with(nolock) 
              left outer join CONV_SCM_ITEM_M as s with(nolock)
           on t.company_id = s.company_id
          and t.DIVISION_ID = s.division_id
          and t.SITE_ID = s.SITE_ID
          and t.ITEM_ID = s.ITEM_ID
        where 1 = 1
		  and t.company_id = 'G630' and (operation_id in ('A3000', 'A9000') or operation_id like 'F%' )
          and t.INSTANCE_ID in (
        		select INSTANCE_ID
        		  from FP_INSTANCE_FACTORY_M with(nolock)
        		 where shop_group_id IN ('A', 'F')
        		   and active_flag = 'Y'
              )
          and s.assy_item_id is not null
		  and t.fp_plan_id in ('', '', '')


       --FP_AMEND_MEMO_M
       select t.* 
       --update t set t.item_id = ISNULL(s.assy_item_id, t.item_id)
         from FP_AMEND_MEMO_M	 as t  with(nolock) 
              left outer join CONV_SCM_ITEM_M as s with(nolock)
           on t.company_id = s.company_id
          and t.DIVISION_ID = s.division_id
          and t.SITE_ID = s.SITE_ID
          and t.ITEM_ID = s.ITEM_ID
        where 1 = 1
          and t.company_id = 'G630' and (t.operation_id in ('A3000', 'A9000', 'B1000') or t.operation_id like 'F%' )
          and s.assy_item_id is not  null


       --FP_AMEND_PLAN_CELL_BOR_H
       select t.* 
       --update t set t.item_id = ISNULL(s.assy_item_id, t.item_id)
         from FP_AMEND_PLAN_CELL_BOR_H	 as t  with(nolock) 
              left outer join CONV_SCM_ITEM_M as s with(nolock)
           on t.company_id = s.company_id
          and t.DIVISION_ID = s.division_id
          and t.SITE_ID = s.SITE_ID
          and t.ITEM_ID = s.ITEM_ID
        where 1 = 1
          and t.company_id = 'G630' and (t.operation_id in ('A3000', 'A9000', 'B1000') or t.operation_id like 'F%' )
          and s.assy_item_id is not  null

       --FP_AMEND_PLAN_CELL_H
       select t.* 
       --update t set t.item_id = ISNULL(s.assy_item_id, t.item_id), t.update_time = getdate()
         from FP_AMEND_PLAN_CELL_H	 as t  with(nolock) 
              left outer join CONV_SCM_ITEM_M as s with(nolock)
           on t.company_id = s.company_id
          and t.DIVISION_ID = s.division_id
          and t.SITE_ID = s.SITE_ID
          and t.ITEM_ID = s.ITEM_ID
        where 1 = 1
          and t.company_id = 'G630' and (t.operation_id in ('A3000', 'A9000', 'B1000') or t.operation_id like 'F%' )
          and s.assy_item_id is not  null
		  and t.fp_plan_id in ('', '', '')

       --FP_AMEND_PLAN_CELL_SALES_H
      select t.* 
       --update t set t.item_id = ISNULL(s.assy_item_id, t.item_id)
         from FP_AMEND_PLAN_CELL_SALES_H	 as t  with(nolock) 
              left outer join CONV_SCM_ITEM_M as s with(nolock)
           on t.company_id = s.company_id
          and t.DIVISION_ID = s.division_id
          and t.SITE_ID = s.SITE_ID
          and t.ITEM_ID = s.ITEM_ID
        where 1 = 1
          and t.company_id = 'G630' and (t.operation_id in ('A3000', 'A9000', 'B1000') or t.operation_id like 'F%' )
          and s.assy_item_id is not  null

       --FP_AMEND_PLAN_FORM_H
      select t.* 
       --update t set t.item_id = ISNULL(s.assy_item_id, t.item_id), t.update_time = getdate()
         from FP_AMEND_PLAN_FORM_H	 as t  with(nolock) 
              left outer join CONV_SCM_ITEM_M as s with(nolock)
           on t.company_id = s.company_id
          and t.DIVISION_ID = s.division_id
          and t.SITE_ID = s.SITE_ID
          and t.ITEM_ID = s.ITEM_ID
        where 1 = 1
          and t.company_id = 'G630' --and (t.operation_id in ('A3000', 'A9000', 'B1000') or t.operation_id like 'F%' )
          and s.assy_item_id is not  null
		  and t.fp_plan_id in ('', '', '')


       --FP_AMEND_PLAN_FORM_H
      select t.* 
       --update t set t.item_id = ISNULL(s.assy_item_id, t.item_id), t.update_time = getdate()
         from FP_DAILY_PRODUCTIOIN_PLAN_H	 as t  with(nolock) 
              left outer join CONV_SCM_ITEM_M as s with(nolock)
           on t.company_id = s.company_id
          and t.DIVISION_ID = s.division_id
          and t.SITE_ID = s.SITE_ID
          and t.ITEM_ID = s.ITEM_ID
        where 1 = 1
          and t.company_id = 'G630' and (t.operation_id in ('A3000', 'A9000', 'B1000') or t.operation_id like 'F%' )
          and s.assy_item_id is not  null
		  and t.plan_date = '2023-07-01 00:00:00.000'


       --FP_FORMATION_SHORTER_LT_M
       select t.* 
       --update t set t.item_id = ISNULL(s.assy_item_id, t.item_id)
         from FP_FORMATION_SHORTER_LT_M	 as t  with(nolock) 
              left outer join CONV_SCM_ITEM_M as s with(nolock)
           on t.company_id = s.company_id
          and t.DIVISION_ID = s.division_id
          and t.SITE_ID = s.SITE_ID
          and t.ITEM_ID = s.ITEM_ID
        where 1 = 1
          and t.company_id = 'G630' --and (t.operation_id in ('A3000', 'A9000', 'B1000') or t.operation_id like 'F%' )
          and s.assy_item_id is not  null


       --FP_MPP_WPP_BASE_PLAN_M
      select t.* 
       --update t set t.item_id = ISNULL(s.assy_item_id, t.item_id)
         from FP_MPP_WPP_BASE_PLAN_M	 as t  with(nolock) 
              left outer join CONV_SCM_ITEM_M as s with(nolock)
           on t.company_id = s.company_id
          and t.DIVISION_ID = s.division_id
          and t.SITE_ID = s.SITE_ID
          and t.ITEM_ID = s.ITEM_ID
        where 1 = 1
          and t.company_id = 'G630' and (t.operation_id in ('A3000', 'A9000', 'B1000') or t.operation_id like 'F%' )
          and s.assy_item_id is not  null


       --FP_RELEASE_FIX_PLAN_H
      select t.* 
      --update t set t.item_id = ISNULL(s.assy_item_id, t.item_id), t.update_time = getdate()
         from FP_RELEASE_FIX_PLAN_H	 as t  with(nolock) 
		      join scm_factory_m as V with(nolock)
           on t.factory_id = v.factory_id
              left outer join CONV_SCM_ITEM_M as s with(nolock)
           on v.company_id = s.company_id
          and v.DIVISION_ID = s.division_id
          and v.SITE_ID = s.SITE_ID
          and t.ITEM_ID = s.ITEM_ID
        where 1 = 1
          and v.company_id = 'G630' and (t.operation_id in ('A3000', 'A9000', 'B1000') or t.operation_id like 'F%' )
          and s.assy_item_id is not  null
		  and t.release_plan_id in ('', '', '')

       --FP_RELEASE_FULL_PLAN_H
      select t.* 
       --update t set t.item_id = ISNULL(s.assy_item_id, t.item_id), t.update_time = getdate()
         from FP_RELEASE_FULL_PLAN_H	 as t  with(nolock) 
		      join scm_factory_m as V with(nolock)
           on t.factory_id = v.factory_id
              left outer join CONV_SCM_ITEM_M as s with(nolock)
           on v.company_id = s.company_id
          and v.DIVISION_ID = s.division_id
          and v.SITE_ID = s.SITE_ID
          and t.ITEM_ID = s.ITEM_ID
        where 1 = 1
          and v.company_id = 'G630' and (t.operation_id in ('A3000', 'A9000', 'B1000') or t.operation_id like 'F%' )
          and s.assy_item_id is not  null
		  and t.release_plan_id in ('', '', '')

*/


--FP_MODEL_LOT_M -> SCM_AGING_ITEM_FLOW_M , SCM_FCS_TRAY_MODEL_M

       --SCM_AGING_ITEM_FLOW_M
      select t.* 
       --update t set t.item_id = ISNULL(s.assy_item_id, t.item_id)
         from SCM_AGING_ITEM_FLOW_M	 as t  with(nolock) 
              left outer join CONV_SCM_ITEM_M as s with(nolock)
           on t.company_id = s.company_id
          and t.DIVISION_ID = s.division_id
          and t.SITE_ID = s.SITE_ID
          and t.ITEM_ID = s.ITEM_ID
        where 1 = 1
          and t.company_id = 'G630' --and (t.operation_id in ('A3000', 'A9000', 'B1000') or t.operation_id like 'F%' )
          and s.assy_item_id is not  null

       --SCM_DAILY_PRODUCT_RESULT_H    작업제외
    --  select t.* 
    --   --update t set t.item_id = ISNULL(s.assy_item_id, t.item_id)
    --     from SCM_DAILY_PRODUCT_RESULT_H	 as t  with(nolock) 
    --          left outer join CONV_SCM_ITEM_M as s with(nolock)
    --       on t.company_id = s.company_id
    --      and t.DIVISION_ID = s.division_id
    --      and t.SITE_ID = s.SITE_ID
    --      and t.ITEM_ID = s.ITEM_ID
    --    where 1 = 1
    --      and t.company_id = 'G630' and (t.operation_id in ('A3000', 'A9000', 'B1000') or t.operation_id like 'F%' )
    --      and s.assy_item_id is not  null
		  --and t.plan_date = '2023-06-30 00:00:00.000'    --전일 실적

       --SCM_FCS_TRAY_MODEL_M
      select t.* 
       --update t set t.item_id = ISNULL(s.assy_item_id, t.item_id)
         from SCM_FCS_TRAY_MODEL_M	 as t  with(nolock) 
              left outer join CONV_SCM_ITEM_M as s with(nolock)
           on t.company_id = s.company_id
          and t.DIVISION_ID = s.division_id
          and t.SITE_ID = s.SITE_ID
          and t.ITEM_ID = s.ITEM_ID
        where 1 = 1
          and t.company_id = 'G630' --and (t.operation_id in ('A3000', 'A9000', 'B1000') or t.operation_id like 'F%' )
          and s.assy_item_id is not  null

       --SCM_ITEM_FLOW_EXCEPT_M
      select t.* 
       --update t set t.item_id = ISNULL(s.assy_item_id, t.item_id)
         from SCM_ITEM_FLOW_EXCEPT_M	 as t  with(nolock) 
              left outer join CONV_SCM_ITEM_M as s with(nolock)
           on t.company_id = s.company_id
          and t.DIVISION_ID = s.division_id
          and t.SITE_ID = s.SITE_ID
          and t.ITEM_ID = s.ITEM_ID
        where 1 = 1
          and t.company_id = 'G630' and (t.operation_id in ('A3000', 'A9000', 'B1000') or t.operation_id like 'F%' )
          and s.assy_item_id is not  null


       --SCM_ITEM_LINE_ASSIGN_M
    --   select t.* 
    --   --update t set t.item_id = ISNULL(s.assy_item_id, t.item_id), t.update_time = getdate()
    --     from SCM_ITEM_LINE_ASSIGN_M	 as t  with(nolock) 
    --          left outer join CONV_SCM_ITEM_M as s with(nolock)
    --       on t.company_id = s.company_id
    --      and t.DIVISION_ID = s.division_id
    --      and t.SITE_ID = s.SITE_ID
    --      and t.ITEM_ID = s.ITEM_ID
    --    where 1 = 1
    --      and t.company_id = 'G630' and (t.operation_id in ('A3000', 'A9000', 'B1000') or t.operation_id like 'F%' )
    --      and s.assy_item_id is not  null
		  --and t.month >= '202308'

		  -- select t.* 
    --   --update t set t.item_id = ISNULL(s.form_item_id, t.item_id), t.update_time = getdate()
    --     from SCM_ITEM_LINE_ASSIGN_M	 as t  with(nolock) 
    --          left outer join CONV_SCM_ITEM_M as s with(nolock)
    --       on t.company_id = s.company_id
    --      and t.DIVISION_ID = s.division_id
    --      and t.SITE_ID = s.SITE_ID
    --      and t.ITEM_ID = s.ITEM_ID
    --    where 1 = 1
    --      and t.company_id = 'G630' and t.operation_id like 'F%' 
    --      and s.form_item_id is not  null
		  --and t.month >= '202308'

	INSERT INTO [dbo].[SCM_ITEM_LINE_ASSIGN_M]
			   ([COMPANY_ID]
			   ,[DIVISION_ID]
			   ,[SITE_ID]
			   ,[PLANT_ID]
			   ,[FACTORY_ID]
			   ,[ITEM_ID]
			   ,[OPERATION_ID]
			   ,[LINE_ID]
			   ,[ELECTRODE_TYPE]
			   ,[MONTH]
			   ,[LANE_QTY]
			   ,[WORK_CENTER_ID]
			   ,[PRIORITY]
			   ,[CERTIFICATION_FLAG]
			   ,[CERTIFICATION_DATE]
			   ,[ACTIVE_FLAG]
			   ,[DESCRIPTION]
			   ,[INSERT_ID]
			   ,[INSERT_TIME]
			   ,[UPDATE_ID]
			   ,[UPDATE_TIME]
			   ,[WIP_LEVEL_QTY]
			   ,[OLD_WIP_LEVEL_QTY])
       SELECT t.[COMPANY_ID]
            , t.[DIVISION_ID]
            , t.[SITE_ID]
            , t.[PLANT_ID]
            , t.[FACTORY_ID]
            , ISNULL(s.assy_item_id, t.item_id) as [ITEM_ID]
            , t.[OPERATION_ID]
            , t.[LINE_ID]
            , t.[ELECTRODE_TYPE]
            , t.[MONTH]
            , t.[LANE_QTY]
            , t.[WORK_CENTER_ID]
            , t.[PRIORITY]
            , t.[CERTIFICATION_FLAG]
            , t.[CERTIFICATION_DATE]
            , t.[ACTIVE_FLAG]
            , t.[DESCRIPTION]
            , t.[INSERT_ID]
            , t.[INSERT_TIME]
            , t.[UPDATE_ID]
            , getdate() [UPDATE_TIME]
            , t.[WIP_LEVEL_QTY]
            , t.[OLD_WIP_LEVEL_QTY]
         from SCM_ITEM_LINE_ASSIGN_M	 as t  with(nolock) 
              left outer join CONV_SCM_ITEM_M as s with(nolock)
           on t.company_id = s.company_id
          and t.DIVISION_ID = s.division_id
          and t.SITE_ID = s.SITE_ID
          and t.ITEM_ID = s.ITEM_ID
        where 1 = 1
          and t.company_id = 'G630' and (t.operation_id in ('A3000', 'A9000', 'B1000') or t.operation_id like 'F%' )
          and s.assy_item_id is not  null
		  and t.month >= '202308'
		  and not exists (
		  select *
         from SCM_ITEM_LINE_ASSIGN_M	 as x  with(nolock) 
        where 1 = 1
          and x.company_id = 'G630' and (x.operation_id in ('A3000', 'A9000', 'B1000') or x.operation_id like 'F%' )
		  and x.month >= '202308'
		  and x.company_id				= t.company_id     
		  and x.division_id				= t.division_id
		  and x.site_id					= t.site_id
		  and x.plant_id				= t.plant_id
		  and x.factory_id				= t.factory_id
		  and x.item_id			        = S.assy_item_id
		  and x.operation_id			= t.operation_id
		  and x.line_id					= t.line_id
		  and x.ELECTRODE_TYPE			= t.ELECTRODE_TYPE
		  and x.month 			        = t.month 
		  )

	  --SCM_ITEM_LINE_ASSIGN_UI_M
	INSERT INTO [dbo].[SCM_ITEM_LINE_ASSIGN_UI_M]
			   ([COMPANY_ID]
			   ,[DIVISION_ID]
			   ,[SITE_ID]
			   ,[PLANT_ID]
			   ,[FACTORY_ID]
			   ,[ITEM_ID]
			   ,[OPERATION_ID]
			   ,[LINE_ID]
			   ,[ELECTRODE_TYPE]
			   ,[MONTH]
			   ,[LANE_QTY]
			   ,[WORK_CENTER_ID]
			   ,[PRIORITY]
			   ,[CERTIFICATION_FLAG]
			   ,[CERTIFICATION_DATE]
			   ,[ACTIVE_FLAG]
			   ,[DESCRIPTION]
			   ,[INSERT_ID]
			   ,[INSERT_TIME]
			   ,[UPDATE_ID]
			   ,[UPDATE_TIME]
			   ,[WIP_LEVEL_QTY])
      SELECT t.[COMPANY_ID]
            , t.[DIVISION_ID]
            , t.[SITE_ID]
            , t.[PLANT_ID]
            , t.[FACTORY_ID]
            , ISNULL(s.assy_item_id, t.item_id) as [ITEM_ID]
            , t.[OPERATION_ID]
            , t.[LINE_ID]
            , t.[ELECTRODE_TYPE]
            , t.[MONTH]
            , t.[LANE_QTY]
            , t.[WORK_CENTER_ID]
            , t.[PRIORITY]
            , t.[CERTIFICATION_FLAG]
            , t.[CERTIFICATION_DATE]
            , t.[ACTIVE_FLAG]
            , t.[DESCRIPTION]
            , t.[INSERT_ID]
            , t.[INSERT_TIME]
            , t.[UPDATE_ID]
            , getdate() [UPDATE_TIME]
            , t.[WIP_LEVEL_QTY]
         from SCM_ITEM_LINE_ASSIGN_UI_M	 as t  with(nolock) 
              left outer join CONV_SCM_ITEM_M as s with(nolock)
           on t.company_id = s.company_id
          and t.DIVISION_ID = s.division_id
          and t.SITE_ID = s.SITE_ID
          and t.ITEM_ID = s.ITEM_ID
        where 1 = 1
          and t.company_id = 'G630' and (t.operation_id in ('A3000', 'A9000', 'B1000') or t.operation_id like 'F%' )
          and s.assy_item_id is not  null
		  and t.month >= '202308'
		  and not exists (
		  select *
         from SCM_ITEM_LINE_ASSIGN_UI_M	 as x  with(nolock) 
        where 1 = 1
          and x.company_id = 'G630' and (x.operation_id in ('A3000', 'A9000', 'B1000') or x.operation_id like 'F%' )
		  and x.month >= '202308'
		  and x.company_id				= t.company_id     
		  and x.division_id				= t.division_id
		  and x.site_id					= t.site_id
		  and x.plant_id				= t.plant_id
		  and x.factory_id				= t.factory_id
		  and x.item_id			        = S.assy_item_id
		  and x.operation_id			= t.operation_id
		  and x.line_id					= t.line_id
		  and x.ELECTRODE_TYPE			= t.ELECTRODE_TYPE
		  and x.month 			        = t.month 
		  )

       --SCM_TACT_TIME_EXCT_VER_H
      select t.* 
       --update t set t.item_id = ISNULL(s.assy_item_id, t.item_id)
         from SCM_TACT_TIME_EXCT_VER_H	 as t  with(nolock) 
              left outer join CONV_SCM_ITEM_M as s with(nolock)
           on t.company_id = s.company_id
          and t.DIVISION_ID = s.division_id
          and t.SITE_ID = s.SITE_ID
          and t.ITEM_ID = s.ITEM_ID
        where 1 = 1
          and t.company_id = 'G630' and (t.operation_id in ('A3000', 'A9000', 'B1000') or t.operation_id like 'F%' )
          and s.assy_item_id is not  null


       --SCM_TACT_TIME_M
    --  select t.* 
    --   --update t set t.item_id = ISNULL(s.assy_item_id, t.item_id), t.update_time = getdate()
    --     from SCM_TACT_TIME_M	 as t  with(nolock) 
    --          left outer join CONV_SCM_ITEM_M as s with(nolock)
    --       on t.company_id = s.company_id
    --      and t.DIVISION_ID = s.division_id
    --      and t.SITE_ID = s.SITE_ID
    --      and t.ITEM_ID = s.ITEM_ID
    --    where 1 = 1
    --      and t.company_id = 'G630' and (t.operation_id in ('A3000', 'A9000', 'B1000') or t.operation_id like 'F%' )
    --      and s.assy_item_id is not  null
		  --and t.month >= '202308'


		  --     select t.* 
    --   --update t set t.item_id = ISNULL(s.form_item_id, t.item_id), t.update_time = getdate()
    --     from SCM_TACT_TIME_M	 as t  with(nolock) 
    --          left outer join CONV_SCM_ITEM_M as s with(nolock)
    --       on t.company_id = s.company_id
    --      and t.DIVISION_ID = s.division_id
    --      and t.SITE_ID = s.SITE_ID
    --      and t.ITEM_ID = s.ITEM_ID
    --    where 1 = 1
    --      and t.company_id = 'G630' and  t.operation_id like 'F%' 
    --      and s.form_item_id is not  null
		  --and t.month >= '202308'


  INSERT INTO [dbo].[SCM_TACT_TIME_M]
            ( [COMPANY_ID]
            , [DIVISION_ID]
            , [SITE_ID]
            , [PLANT_ID]
            , [FACTORY_ID]
            , [OPERATION_ID]
            , [LINE_ID]
            , [ELECTRODE_TYPE]
            , [ITEM_ID]
            , [MONTH]
            , [WORK_CENTER_ID]
            , [TACT_TIME]
            , [TACT_TIME_UOM]
            , [DAILY_CAPA]
            , [DESCRIPTION]
            , [INSERT_ID]
            , [INSERT_TIME]
            , [UPDATE_ID]
            , [UPDATE_TIME]
            , [GPLM_TACT_TIME]
            , [RESULT_TACT_TIME]
            , [DAILY_CAPA_PM])
	   SELECT t.[COMPANY_ID]
			, t.[DIVISION_ID]
			, t.[SITE_ID]
			, t.[PLANT_ID]
			, t.[FACTORY_ID]
			, t.[OPERATION_ID]
			, t.[LINE_ID]
			, t.[ELECTRODE_TYPE]
			, ISNULL(s.assy_item_id, t.item_id) as [ITEM_ID]
			, t.[MONTH]
			, t.[WORK_CENTER_ID]
			, t.[TACT_TIME]
			, t.[TACT_TIME_UOM]
			, t.[DAILY_CAPA]
			, t.[DESCRIPTION]
			, t.[INSERT_ID]
			, t.[INSERT_TIME]
			, t.[UPDATE_ID]
			, getdate() [UPDATE_TIME]
			, t.[GPLM_TACT_TIME]
			, t.[RESULT_TACT_TIME]
			, t.[DAILY_CAPA_PM]
         from SCM_TACT_TIME_M	 as t  with(nolock) 
              left outer join CONV_SCM_ITEM_M as s with(nolock)
           on t.company_id = s.company_id
          and t.DIVISION_ID = s.division_id
          and t.SITE_ID = s.SITE_ID
          and t.ITEM_ID = s.ITEM_ID
        where 1 = 1
          and t.company_id = 'G630' and (t.operation_id in ('A3000', 'A9000', 'B1000') or t.operation_id like 'F%' )
          and s.assy_item_id is not  null
		  and t.month >= '202308'
		  and not  exists (
		        select t.* 
         from SCM_TACT_TIME_M	 as x  with(nolock) 
        where 1 = 1
          and x.company_id = 'G630' and (x.operation_id in ('A3000', 'A9000', 'B1000') or x.operation_id like 'F%' )
          and s.assy_item_id is not  null
		  and x.month >= '202308'
		  and x.company_id				= t.company_id     
		  and x.division_id				= t.division_id
		  and x.site_id					= t.site_id
		  and x.plant_id				= t.plant_id
		  and x.factory_id				= t.factory_id
		  and x.line_id					= t.line_id
		  and x.electrode_type			= t.electrode_type
		  and x.item_id					= s.assy_item_id
		  and x.month 					= t.month 
		  )

       --SCM_TACT_TIME_UI_M
      --select t.* 
      -- --update t set t.item_id = ISNULL(s.assy_item_id, t.item_id)
      --   from SCM_TACT_TIME_UI_M	 as t  with(nolock) 
      --        left outer join CONV_SCM_ITEM_M as s with(nolock)
      --     on t.company_id = s.company_id
      --    and t.DIVISION_ID = s.division_id
      --    and t.SITE_ID = s.SITE_ID
      --    and t.ITEM_ID = s.ITEM_ID
      --  where 1 = 1
      --    and t.company_id = 'G630' and (t.operation_id in ('A3000', 'A9000', 'B1000') or t.operation_id like 'F%' )
      --    and s.assy_item_id is not  null


  INSERT INTO [dbo].SCM_TACT_TIME_UI_M
            ( [COMPANY_ID]
            , [DIVISION_ID]
            , [SITE_ID]
            , [PLANT_ID]
            , [FACTORY_ID]
            , [OPERATION_ID]
            , [LINE_ID]
            , [ELECTRODE_TYPE]
            , [ITEM_ID]
            , [MONTH]
            , [WORK_CENTER_ID]
            , [TACT_TIME]
            , [TACT_TIME_UOM]
            , [DAILY_CAPA]
            , [DESCRIPTION]
            , [INSERT_ID]
            , [INSERT_TIME]
            , [UPDATE_ID]
            , [UPDATE_TIME]
            , [GPLM_TACT_TIME])
	   SELECT t.[COMPANY_ID]
			, t.[DIVISION_ID]
			, t.[SITE_ID]
			, t.[PLANT_ID]
			, t.[FACTORY_ID]
			, t.[OPERATION_ID]
			, t.[LINE_ID]
			, t.[ELECTRODE_TYPE]
			, ISNULL(s.assy_item_id, t.item_id) as [ITEM_ID]
			, t.[MONTH]
			, t.[WORK_CENTER_ID]
			, t.[TACT_TIME]
			, t.[TACT_TIME_UOM]
			, t.[DAILY_CAPA]
			, t.[DESCRIPTION]
			, t.[INSERT_ID]
			, t.[INSERT_TIME]
			, t.[UPDATE_ID]
			, getdate() [UPDATE_TIME]
			, t.[GPLM_TACT_TIME]
         from SCM_TACT_TIME_UI_M	 as t  with(nolock) 
              left outer join CONV_SCM_ITEM_M as s with(nolock)
           on t.company_id = s.company_id
          and t.DIVISION_ID = s.division_id
          and t.SITE_ID = s.SITE_ID
          and t.ITEM_ID = s.ITEM_ID
        where 1 = 1
          and t.company_id = 'G630' and (t.operation_id in ('A3000', 'A9000', 'B1000') or t.operation_id like 'F%' )
          and s.assy_item_id is not  null
		  and t.month >= '202308'
		  and not  exists (
		        select t.* 
         from SCM_TACT_TIME_UI_M	 as x  with(nolock) 
        where 1 = 1
          and x.company_id = 'G630' and (x.operation_id in ('A3000', 'A9000', 'B1000') or x.operation_id like 'F%' )
          and s.assy_item_id is not  null
		  and x.month >= '202308'
		  and x.company_id				= t.company_id     
		  and x.division_id				= t.division_id
		  and x.site_id					= t.site_id
		  and x.plant_id				= t.plant_id
		  and x.factory_id				= t.factory_id
		  and x.line_id					= t.line_id
		  and x.electrode_type			= t.electrode_type
		  and x.item_id					= s.assy_item_id
		  and x.month 					= t.month 
		  )

       --SCM_YIELD_M
    --  select t.* 
    --   --update t set t.item_id = ISNULL(s.assy_item_id, t.item_id), t.update_time = getdate()
    --     from SCM_YIELD_M	 as t  with(nolock) 
    --          left outer join CONV_SCM_ITEM_M as s with(nolock)
    --       on t.company_id = s.company_id
    --      and t.DIVISION_ID = s.division_id
    --      and t.SITE_ID = s.SITE_ID
    --      and t.ITEM_ID = s.ITEM_ID
    --    where 1 = 1
    --      and t.company_id = 'G630' and (t.operation_id in ('A3000', 'A9000', 'B1000') or t.operation_id like 'F%' )
    --      and s.assy_item_id is not  null
		  --and t.month >= '202308'


		  --      select t.* 
    --   --update t set t.item_id = ISNULL(s.form_item_id, t.item_id), t.update_time = getdate()
    --     from SCM_YIELD_M	 as t  with(nolock) 
    --          left outer join CONV_SCM_ITEM_M as s with(nolock)
    --       on t.company_id = s.company_id
    --      and t.DIVISION_ID = s.division_id
    --      and t.SITE_ID = s.SITE_ID
    --      and t.ITEM_ID = s.ITEM_ID
    --    where 1 = 1
    --      and t.company_id = 'G630' and t.operation_id like 'F%'
    --      and s.form_item_id is not  null
		  --and t.month >= '202308'


  INSERT INTO [dbo].[SCM_YIELD_M]
            ( [COMPANY_ID]
            , [DIVISION_ID]
            , [SITE_ID]
            , [PLANT_ID]
            , [FACTORY_ID]
            , [OPERATION_ID]
            , [LINE_ID]
            , [ITEM_ID]
            , [MONTH]
            , [WORK_CENTER_ID]
            , [YIELD]
            , [DESCRIPTION]
            , [INSERT_ID]
            , [INSERT_TIME]
            , [UPDATE_ID]
            , [UPDATE_TIME]
            , [RESULT_YIELD])
      SELECT  t.[COMPANY_ID]
            , t.[DIVISION_ID]
            , t.[SITE_ID]
            , t.[PLANT_ID]
            , t.[FACTORY_ID]
            , t.[OPERATION_ID]
            , t.[LINE_ID]
            , ISNULL(s.assy_item_id, t.item_id) as [ITEM_ID]
            , t.[MONTH]
            , t.[WORK_CENTER_ID]
            , t.[YIELD]
            , t.[DESCRIPTION]
            , t.[INSERT_ID]
            , t.[INSERT_TIME]
            , t.[UPDATE_ID]
            , getdate() [UPDATE_TIME]
            , t.[RESULT_YIELD]
         from SCM_YIELD_M	 as t  with(nolock) 
              left outer join CONV_SCM_ITEM_M as s with(nolock)
           on t.company_id = s.company_id
          and t.DIVISION_ID = s.division_id
          and t.SITE_ID = s.SITE_ID
          and t.ITEM_ID = s.ITEM_ID
        where 1 = 1
          and t.company_id = 'G630' and (t.operation_id in ('A3000', 'A9000', 'B1000') or t.operation_id like 'F%' )
          and s.assy_item_id is not  null
		  and t.month >= '202308'
		  and not exists (
		  select *
         from SCM_YIELD_M	 as x  with(nolock) 
        where 1 = 1
          and x.company_id = 'G630' and (x.operation_id in ('A3000', 'A9000', 'B1000') or x.operation_id like 'F%' )
		  and x.month >= '202308'
		  and x.company_id				= t.company_id     
		  and x.division_id				= t.division_id
		  and x.site_id					= t.site_id
		  and x.plant_id				= t.plant_id
		  and x.factory_id				= t.factory_id
		  and x.operation_id			= t.operation_id
		  and x.line_id					= t.line_id
		  and x.item_id					= S.assy_item_id
		  and x.month 					= t.month 
		  )


	   --SCM_YIELD_UI_M
       --select t.* 
       ----update t set t.item_id = ISNULL(s.assy_item_id, t.item_id)
       --  from SCM_YIELD_UI_M	 as t  with(nolock) 
       --       left outer join CONV_SCM_ITEM_M as s with(nolock)
       --    on t.company_id = s.company_id
       --   and t.DIVISION_ID = s.division_id
       --   and t.SITE_ID = s.SITE_ID
       --   and t.ITEM_ID = s.ITEM_ID
       -- where 1 = 1
       --   and t.company_id = 'G630' and (t.operation_id in ('A3000', 'A9000', 'B1000') or t.operation_id like 'F%' )
       --   and s.assy_item_id is not  null


	INSERT INTO [dbo].SCM_YIELD_UI_M
            ( [COMPANY_ID]
            , [DIVISION_ID]
            , [SITE_ID]
            , [PLANT_ID]
            , [FACTORY_ID]
            , [OPERATION_ID]
            , [LINE_ID]
            , [ITEM_ID]
            , [MONTH]
            , [WORK_CENTER_ID]
            , [YIELD]
            , [DESCRIPTION]
            , [INSERT_ID]
            , [INSERT_TIME]
            , [UPDATE_ID]
            , [UPDATE_TIME]
            , [RESULT_YIELD])
      SELECT  t.[COMPANY_ID]
            , t.[DIVISION_ID]
            , t.[SITE_ID]
            , t.[PLANT_ID]
            , t.[FACTORY_ID]
            , t.[OPERATION_ID]
            , t.[LINE_ID]
            , ISNULL(s.assy_item_id, t.item_id) as [ITEM_ID]
            , t.[MONTH]
            , t.[WORK_CENTER_ID]
            , t.[YIELD]
            , t.[DESCRIPTION]
            , t.[INSERT_ID]
            , t.[INSERT_TIME]
            , t.[UPDATE_ID]
            , getdate() [UPDATE_TIME]
            , t.[RESULT_YIELD]
         from SCM_YIELD_UI_M	 as t  with(nolock) 
              left outer join CONV_SCM_ITEM_M as s with(nolock)
           on t.company_id = s.company_id
          and t.DIVISION_ID = s.division_id
          and t.SITE_ID = s.SITE_ID
          and t.ITEM_ID = s.ITEM_ID
        where 1 = 1
          and t.company_id = 'G630' and (t.operation_id in ('A3000', 'A9000', 'B1000') or t.operation_id like 'F%' )
          and s.assy_item_id is not  null
		  and t.month >= '202308'
		  and not exists (
		  select *
         from SCM_YIELD_UI_M	 as x  with(nolock) 
        where 1 = 1
          and x.company_id = 'G630' and (x.operation_id in ('A3000', 'A9000', 'B1000') or x.operation_id like 'F%' )
		  and x.month >= '202308'
		  and x.company_id				= t.company_id     
		  and x.division_id				= t.division_id
		  and x.site_id					= t.site_id
		  and x.plant_id				= t.plant_id
		  and x.factory_id				= t.factory_id
		  and x.operation_id			= t.operation_id
		  and x.line_id					= t.line_id
		  and x.item_id					= S.assy_item_id
		  and x.month 					= t.month 
		  )


    --SCM_FORMATION_YIELD_M
	select t.* 
    --   update t set t.item_id = ISNULL(s.assy_item_id, t.item_id), t.update_time = getdate()
         from SCM_FORMATION_YIELD_M	 as t  with(nolock) 
              left outer join CONV_SCM_ITEM_M as s with(nolock)
           on t.company_id = s.company_id
          and t.DIVISION_ID = s.division_id
          and t.SITE_ID = s.SITE_ID
          and t.ITEM_ID = s.ITEM_ID
        where 1 = 1
          and t.company_id = 'G630'
          and s.assy_item_id is not  null
		  and not exists (
		  select *
         from SCM_FORMATION_YIELD_M	 as x  with(nolock) 
        where 1 = 1
          and x.company_id = 'G630'
		  and x.company_id				= t.company_id     
		  and x.division_id				= t.division_id
		  and x.site_id					= t.site_id
		  and x.plant_id				= t.plant_id
		  and x.factory_id				= t.factory_id
		  and x.line_id					= t.line_id
		  and x.item_id					= S.assy_item_id
		  )

        --SCM_STOCK_H
      select t.* 
		--update t set t.item_id = ISNULL(s.assy_item_id, t.item_id), t.update_time = getdate()
		from SCM_STOCK_H as t with(nolock)
			 left outer join CONV_SCM_ITEM_M as s with(nolock)
					on t.company_id = s.company_id
				   and t.DIVISION_ID = s.division_id
				   and t.SITE_ID = s.SITE_ID
				   and t.ITEM_ID = s.ITEM_ID
		where 1 = 1
		and t.CUTOFF_DATE = '2023-08-02'
		and t.COMPANY_ID = 'G630'
		and s.assy_item_id is not null


        --SCM_AGING_STOCK_H  *
      select t.* 
		--update t set t.item_id = ISNULL(s.assy_item_id, t.item_id), update_time = getdate()
		from SCM_AGING_STOCK_H as t with(nolock)
			 left outer join CONV_SCM_ITEM_M as s with(nolock)
					on t.company_id = s.company_id
				   and t.DIVISION_ID = s.division_id
				   and t.SITE_ID = s.SITE_ID
				   and t.ITEM_ID = s.ITEM_ID
		where 1 = 1
		and t.CUTOFF_DATE = '2023-08-02'
		and t.COMPANY_ID = 'G630'
		and s.assy_item_id is not null


		--SCM_AGING_TRAY_STOCK_H  *
      select t.* 
		--update t set t.item_id = ISNULL(s.assy_item_id, t.item_id), update_time = getdate()
		from SCM_AGING_TRAY_STOCK_H as t with(nolock)
			 left outer join CONV_SCM_ITEM_M as s with(nolock)
					on t.company_id = s.company_id
				   and t.DIVISION_ID = s.division_id
				   and t.SITE_ID = s.SITE_ID
				   and t.ITEM_ID = s.ITEM_ID
		where 1 = 1
		and t.CUTOFF_DATE = '2023-08-02'
		and t.COMPANY_ID = 'G630'
		and s.assy_item_id is not null




		-- formation_flow_id
		select x.*
		--update x set x.formation_flow_id = y.formation_flow_id 
		  from scm_item_m as x with(nolock)
		       join scm_item_m as y with(nolock)
		    on x.company_id = y.company_id
		   and x.division_id = y.division_id
		   and x.site_id = y.site_id
		   and x.applied_model = y.item_id
		 where 1 = 1
		   and x.company_id = 'G630'
		   and x.ITEM_CLASS = 'ES1901'
		   and x.formation_flow_id is null

		select x.*
		--update x set x.scp_flow_id = y.scp_flow_id 
		  from scm_item_m as x with(nolock)
		       join scm_item_m as y with(nolock)
		    on x.company_id = y.company_id
		   and x.division_id = y.division_id
		   and x.site_id = y.site_id
		   and x.applied_model = y.item_id
		 where 1 = 1
		   and x.company_id = 'G630'
		   and x.ITEM_CLASS = 'ES1901'
		   and x.scp_flow_id is null

		select x.*
		--update x set x.flow_id = y.flow_id 
		  from scm_item_m as x with(nolock)
		       join scm_item_m as y with(nolock)
		    on x.company_id = y.company_id
		   and x.division_id = y.division_id
		   and x.site_id = y.site_id
		   and x.applied_model = y.item_id
		 where 1 = 1
		   and x.company_id = 'G630'
		   and x.ITEM_CLASS = 'ES1901'
		   and x.flow_id is null


select x.work_order_spl_id, x.work_order_id, y.new_work_order_id, y.assy_item_id
--update x set x.work_order_spl_id = y.new_work_order_id, x.work_order_id = y.new_work_order_id, item_id = y.assy_item_id
from [dbo].[FP_MES_WORK_ORDER_STATUS_H] as X with(nolock)
     join CONV_WORK_ORDER as y 
 on x.COMPANY_ID = y.company_id
and x.work_order_id = y.WORK_ORDER_ID
and CUTOFF_DATE = '2023-08-02 00:00:00.000'
and x.company_id = 'G630'

select x.work_order_id, y.new_work_order_id, y.assy_item_id
--update x set x.work_order_id = y.new_work_order_id,   x.item_id =  y.assy_item_id
from FP_ERP_PRODUCTION_PLAN_M as x with(nolock)
     join CONV_WORK_ORDER as y 
 on x.COMPANY_ID = y.company_id
and x.work_order_id = y.WORK_ORDER_ID
and x.company_id = 'G630'


select x.work_order_spl_id, x.work_order_id, y.new_work_order_id, y.assy_item_id 
--update x set x.work_order_spl_id = y.new_work_order_id, x.work_order_id = y.new_work_order_id, item_id = y.assy_item_id
from FP_MES_PRODUCTION_PLAN_M as x with(nolock)
     join CONV_WORK_ORDER as y 
 on x.COMPANY_ID = y.company_id
and x.work_order_id = y.WORK_ORDER_ID
and x.company_id = 'G630'



--insert into conv_work_order
--select T.COMPANY_ID,  T.WORK_ORDER_ID, T.ITEM_ID, T.NEW_WORK_ORDER_ID, X.ASSY_ITEM_ID
--from (
--SELECT INSTANCE_ID, FP_PLAN_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID, ITEM_ID, PLAN_DATE, WORK_ORDER_ID, LEFT(WORK_ORDER_ID,9) + B.ORDER_ID AS NEW_WORK_ORDER_ID, B.ORDER_NO, PLAN_QTY
--FROM (

----ORDER BY PLAN_DATE DESC, WORK_ORDER_ID
--) as T
--join conv_scm_item_m as x
--on t.company_id = x.COMPANY_ID
--and t.DIVISION_ID = x.DIVISION_ID
--and t.SITE_ID = x.SITE_ID
--and t.ITEM_ID = x.ITEM_ID




------------------------------------
-- SCP 요청
------------------------------------


select * 

--update t set t.item_id = ISNULL(s.assy_item_id, t.item_id)
from SCM_ITEM_LINE_ASSIGN_VER_H as t with(nolock)
              left outer join CONV_SCM_ITEM_M as s with(nolock)
           on t.company_id = s.company_id
          and t.DIVISION_ID = s.division_id
          and t.SITE_ID = s.SITE_ID
          and t.ITEM_ID = s.ITEM_ID
        where 1 = 1
          and t.company_id = 'G630' --and (t.operation_id in ('A3000', 'A9000', 'B1000') or t.operation_id like 'F%' )
          and s.assy_item_id is not  null
		  and month >= '202308'
and t.VERSION_ID in (
 '202326_026'
,'202326_027'
,'202326_028'
,'202326_029'
,'202326_030'
,'202326_031'
,'202326_032'
,'202326_033'
,'202326_034'
,'202326_035'
,'202326_036'
,'202326_037'
,'202326_038'
)
		  and not exists (
		  select *
         from SCM_ITEM_LINE_ASSIGN_VER_H	 as x  with(nolock) 
        where 1 = 1
          and x.company_id = 'G630' and (x.operation_id in ('A3000', 'A9000', 'B1000') or x.operation_id like 'F%' )
		  and x.month >= '202308'
		  and x.VERSION_ID   = t.VERSION_ID
		  and x.company_id				= t.company_id     
		  and x.division_id				= t.division_id
		  and x.site_id					= t.site_id
		  and x.plant_id				= t.plant_id
		  and x.factory_id				= t.factory_id
		  and x.item_id			        = S.assy_item_id
		  and x.operation_id			= t.operation_id
		  and x.line_id					= t.line_id
		  and x.ELECTRODE_TYPE			= t.ELECTRODE_TYPE
		  and x.month 			        = t.month 

		  )


select t.* 
--update t set t.item_id = ISNULL(s.assy_item_id, t.item_id)
from SCM_TACT_TIME_VER_H	as t	  with(nolock)
              left outer join CONV_SCM_ITEM_M as s with(nolock)
           on t.company_id = s.company_id
          and t.DIVISION_ID = s.division_id
          and t.SITE_ID = s.SITE_ID
          and t.ITEM_ID = s.ITEM_ID
        where 1 = 1
          and t.company_id = 'G630' --and (t.operation_id in ('A3000', 'A9000', 'B1000') or t.operation_id like 'F%' )
          and s.assy_item_id is not  null
		  and month >= '202308'
and t.VERSION_ID in (
 '202326_026'
,'202326_027'
,'202326_028'
,'202326_029'
,'202326_030'
,'202326_031'
,'202326_032'
,'202326_033'
,'202326_034'
,'202326_035'
,'202326_036'
,'202326_037'
,'202326_038'
)

		  and not exists (
		  select *
         from SCM_TACT_TIME_VER_H	 as x  with(nolock) 
        where 1 = 1
          and x.company_id = 'G630' and (x.operation_id in ('A3000', 'A9000', 'B1000') or x.operation_id like 'F%' )
		  and x.month >= '202308'
		  and x.VERSION_ID   = t.VERSION_ID
		  and x.company_id				= t.company_id     
		  and x.division_id				= t.division_id
		  and x.site_id					= t.site_id
		  and x.plant_id				= t.plant_id
		  and x.factory_id				= t.factory_id
		  and x.item_id			        = S.assy_item_id
		  and x.operation_id			= t.operation_id
		  and x.line_id					= t.line_id
		  and x.ELECTRODE_TYPE			= t.ELECTRODE_TYPE
		  and x.month 			        = t.month 

		  )



select * 
--update t set t.item_id = ISNULL(s.assy_item_id, t.item_id)
from SCM_YIELD_VER_H	as t		  with(nolock)
              left outer join CONV_SCM_ITEM_M as s with(nolock)
           on t.company_id = s.company_id
          and t.DIVISION_ID = s.division_id
          and t.SITE_ID = s.SITE_ID
          and t.ITEM_ID = s.ITEM_ID
         where 1 = 1
          and t.company_id = 'G630' --and (t.operation_id in ('A3000', 'A9000', 'B1000') or t.operation_id like 'F%' )
          and s.assy_item_id is not  null
		  and month >= '202308'
and t.VERSION_ID in (
 '202326_026'
,'202326_027'
,'202326_028'
,'202326_029'
,'202326_030'
,'202326_031'
,'202326_032'
,'202326_033'
,'202326_034'
,'202326_035'
,'202326_036'
,'202326_037'
,'202326_038'
)
		  and not exists (
		  select *
         from SCM_YIELD_VER_H	 as x  with(nolock) 
        where 1 = 1
          and x.company_id = 'G630' and (x.operation_id in ('A3000', 'A9000', 'B1000') or x.operation_id like 'F%' )
		  and x.month >= '202308'
		  and x.VERSION_ID   = t.VERSION_ID
		  and x.company_id				= t.company_id     
		  and x.division_id				= t.division_id
		  and x.site_id					= t.site_id
		  and x.plant_id				= t.plant_id
		  and x.factory_id				= t.factory_id
		  and x.item_id			        = S.assy_item_id
		  and x.operation_id			= t.operation_id
		  and x.line_id					= t.line_id
		
		  and x.month 			        = t.month 

		  )



 -------------------------------------------------------------------------------------
 -- 후처리
 


		 select *
		-- delete t
		 from SCM_ITEM_LINE_ASSIGN_M	 as t  with(nolock) 
        where 1 = 1
          and t.company_id = 'G630' and (t.operation_id in ('A3000', 'A9000', 'B1000') or t.operation_id like 'F%' )
		  and t.month >= '202308'
		  and t.item_id in (
		  select applied_model 
		    from scm_item_m with(nolock)
		   where item_class = 'ES1901'
		    and company_id = 'G630'
			)


----------------------

		 select *
		-- delete t
		 from SCM_TACT_TIME_M	 as t  with(nolock) 
        where 1 = 1
          and t.company_id = 'G630' and (t.operation_id in ('A3000', 'A9000', 'B1000') or t.operation_id like 'F%' )
		  and t.month >= '202308'
		  and t.item_id in (
		  select applied_model 
		    from scm_item_m with(nolock)
		   where item_class = 'ES1901'
		    and company_id = 'G630'
			)



----------------------

		 select *
		-- delete t
		 from SCM_YIELD_M	 as t  with(nolock) 
        where 1 = 1
          and t.company_id = 'G630' and (t.operation_id in ('A3000', 'A9000', 'B1000') or t.operation_id like 'F%' )
		  and t.month >= '202308'
		  and t.item_id in (
		  select applied_model 
		    from scm_item_m with(nolock)
		   where item_class = 'ES1901'
		    and company_id = 'G630'
			)




		COMMIT TRAN

		--EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   NULL, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
		
	END TRY

	BEGIN CATCH

		--IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CUR_SHIP_CONFIRM')
		--BEGIN
		--	CLOSE CUR_SHIP_CONFIRM
		--	DEALLOCATE CUR_SHIP_CONFIRM
		--END

		ROLLBACK TRAN

		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		--EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate

	END CATCH

END
