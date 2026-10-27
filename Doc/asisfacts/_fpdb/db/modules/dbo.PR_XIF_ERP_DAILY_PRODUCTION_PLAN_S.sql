
CREATE PROCEDURE [dbo].[PR_XIF_ERP_DAILY_PRODUCTION_PLAN_S]
/*
-- ================================================================================================
-- BATCH PERIOD        : 1DAY
-- DESCRIPTION         : 
-- 1. FP_DAILY_PRODUCTION_PLAN_H 테이블을 기초로 ERP NPP023에 전송할 IF 테이블을 만든다. (IFSEQ 리턴)
-- 2. IF 테이블을 리턴한다 (IFSEQ 기준으로 미전송 데이터를 리턴)
-- 3. IF 테이블에 전송결과를 저장한다 (IFSEQ 기준으로 전송결과 / 전송시간 기록)
-- SOURCE SYSTEM       : FP
-- DESTINATION SYSTEM  : NERP
-- SOURCE TABLE        : XIF_ERP_DAILY_PRODUCTION_PLAN_S
-- DESTINATION TABLE   : 
--
-- CREATE DATE		   : 2024.05.08
-- command : create - today production plan
-- command : list - list all data (if_seq)
-- command : success - update if 'S'
-- VERSION             : 1.0
-- ================================================================================================
*/
-- PARAMETER

@p_option NVARCHAR(10) = 'create', -- create (list ifseq) , list (list with if_seq) , success (set success with if_seq) , fail (set fail with if_seq)
@p_if_seq NVARCHAR(50) = 'NULL',
@p_company_id NVARCHAR(50) = '' -- not used yet

AS

BEGIN

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
	SET XACT_ABORT ON

	-- LOG 용 변수 설정
	DECLARE @v_proc_name NVARCHAR(100) = '[PR_XIF_ERP_DAILY_PRODUCTION_PLAN_S]'
	DECLARE @v_descr     NVARCHAR(250)
	DECLARE @v_count     INTEGER	  = 0
	DECLARE @sysdate     DATETIME     = GETDATE()

	DECLARE @ROWCOUNT    INTEGER

	-- ERROR_LINE
	DECLARE @v_temp1     NVARCHAR(1000)
	DECLARE @v_temp2     NVARCHAR(1000)


	-- ================================================
    -- Declare start
	-- ================================================

	DECLARE @IF_ID       NVARCHAR(50)
	DECLARE @ACCUM_DATE          NVARCHAR(1000)
	DECLARE @SITE_ID          NVARCHAR(1000)

	--declare @today_yyyymmdd nvarchar(10) = ''
	--declare @if_seq nvarchar(50) = ''
	--set @today_yyyymmdd = convert(char(8), getdate(), 112)
	
	-- ================================================
    -- Declare end
	-- ================================================

	SET @v_temp1 = 'S' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))
	SET @v_temp2 = 'E' + REPLICATE('0', 4-LEN(CAST(ERROR_LINE() AS NVARCHAR(10)))) + CAST(ERROR_LINE() AS NVARCHAR(10))

	-- Start 로그는 무조건 남김
	EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', NULL, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate
		


	BEGIN TRY

	   	IF @p_option = 'create' BEGIN
		EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'START CREATE IF TABLE', @ROWCOUNT, @V_TEMP1, '############### START OF CREATE ###############', NULL, @SYSDATE

	   BEGIN TRAN
	   -- FAIL의 경우 재전송하는 경우
	   --select ifseqno from dbo.SY_XIF_ERP_DAILY_PRODUCTION_PLAN_S with(nolock) where  TRANSFER_FLAG <> 'Y' group by ifseqno

	   -- 한번 전송해 보고 실패하면 무시
	   select ifseqno from dbo.SY_XIF_ERP_DAILY_PRODUCTION_PLAN_S with(nolock) where  TRANSFER_FLAG = 'N' group by ifseqno

	--SET @IF_SEQ = replace(replace(replace(convert(NVARCHAR(19),getdate(),121),'-',''),':',''),' ','') 
		
--insert into dbo.SY_XIF_ERP_DAILY_PRODUCTION_PLAN_S
--		select 
--distinct 
--@IF_SEQ as [IFSEQNO],
--'N' AS [TRANSFER_FLAG],
--null as [TRANSFER_DATE],

--a.company_id,
--a.division_id,
--a.site_id,
--a.plant_id,
--a.factory_id,

--a.plan_group_id,
--a.instance_type,
--a.top_item_id,
--a.item_id,
--a.operation_id,

--a.location,
--a.production_type,
--a.market,
--a.line_id,
--a.electrode_type,

--a.plan_date,
--a.plan_qty,
--a.plan_in_qty,
--a.insert_id,
--a.insert_time,

--a.update_id,
--a.update_time,
--a.plan_type,
--a.equipment_id,
--a.fp_production_type,

--a.roll_in_qty,
--a.roll_out_qty,
--a.jr_in_qty,
--a.jr_out_qty,
--a.batch_in_qty,

--a.batch_out_qty,
--a.cell_in_qty,
--a.cell_out_qty,
--a.full_cleaning_flag,
--a.model_type_change_flag,

--a.seq,
--a.cell_material_id,
--a.total_batch,
--a.pig_cleaning_flag,
--a.setup_color_code,

--null as shift,
--a.work_request_model_id,
--a.version,
--a.prod_seq,
--a.plm_ec_no,

--sl.work_center_id as workcenter_id,
--s.scp_plan_id as scp_plan_id,
----s.plan_id as k,
--'-' as wo_release_flag,
--(select max(convert(nvarchar(8), weekend_date, 112)) 
--from dbo.scm_sys_calendar_m with(nolock)
--where date_id = dateadd(ww, convert(int,
--	(select slv.attribute15 from scm_sys_lookup_value slv with(nolock) where slv.lookup_type_code = 'instance_id' and slv.segment1 = b.instance_id)
--			) -1, @today_yyyymmdd)) as planning_horizon_date,
----a.line_id, b.release_plan_id,
--s.plan_id as attr_01,

--'' as attr_02,
--'' as attr_03,
--'' as attr_04,
--'' as attr_05

----from fp_daily_production_plan_r a with(nolock)
--from [dbo].[fp_daily_productioin_plan_h] a with(nolock)
--left outer join
--(select a.instance_id, a.instance_date, a.release_plan_id
--, a.factory_id, a.operation_id, a.line_id, a.electrode_type,dense_rank() over (partition by a.instance_date
--                                , a.factory_id
--                                , a.operation_id
--                                , a.line_id
--                                , a.electrode_type
--                    order     by a.release_plan_id) as seq
--from   fp_release_plan_line_info_h a with(nolock)
--, (
--		select a.factory_id, a.operation_id, a.line_id, a.electrode_type
--				, max(instance_date) as instance_date
				

--		from   fp_release_plan_line_info_h a with(nolock)
--		where  a.instance_date  <= @today_yyyymmdd
--		and    exists (
--						select 1
--						from   his_fp_plan_detail_h x with(nolock)
--						where  x.instance_id        = a.instance_id
--						and    x.plan_date          = a.instance_date
--						and    x.release_plan_id    = a.release_plan_id
--						and    x.confirm_flag       = 'y'
--						and    x.release_flag       = 'y'
--						and    x.mes_transfer_flag  = 'y'
--						union  all
--						select 1
--						from   his_fp_plan_group_detail_h x with(nolock)
--						where  x.instance_id        = a.instance_id
--						and    x.plan_date          = a.instance_date
--						and    x.release_plan_id    = a.release_plan_id
--						and    x.confirm_flag       = 'y'
--						and    x.release_flag       = 'y'
--						and    x.mes_transfer_flag  = 'y'                                        
--					)
--		group  by
--				a.factory_id, a.operation_id, a.line_id, a.electrode_type
--) b
--where  a.instance_date  = b.instance_date
--and    a.factory_id     = b.factory_id
--and    a.operation_id   = b.operation_id
--and    a.line_id        = b.line_id
--and    a.electrode_type = b.electrode_type
--)b
----(
----select aa.release_plan_id,aa.factory_id,aa.instance_id, aa.operation_id, aa.line_id, aa.electrode_type
----				, max(instance_date) as instance_date
----	from fp_release_plan_line_info_h aa with(nolock)
----	where aa.instance_date < = getdate()
----	and exists (
----		select 1 from his_fp_plan_detail_h x with(nolock)
----		where x.instance_id = aa.instance_id
----		and x.plan_date = aa.instance_date
----		and x.release_plan_id = aa.release_plan_id
----		and x.confirm_flag = 'y' and x.release_flag = 'y' and x.mes_transfer_flag = 'y'
----		union all
----		select 1 from his_fp_plan_group_detail_h x with(nolock)
----		where x.instance_id = aa.instance_id
----		and x.plan_date = aa.instance_date
----		and x.release_plan_id =aa.release_plan_id
----		and x.confirm_flag = 'y' and x.release_flag = 'y' and x.mes_transfer_flag = 'y'
----	)
----	group by aa.release_plan_id,aa.instance_id, aa.factory_id, aa.operation_id,aa.line_id, aa.electrode_type
----) b
--on  1=1
--and a.factory_id = b.factory_id 
--and a.operation_id = b.operation_id
--and a.electrode_type = b.electrode_type


--left outer join scm_fp_plan_h s with(nolock)
--on b.release_plan_id = s.plan_id
--left outer join scm_line_m sl with(nolock)
--on 1=1
----and a.factory_id = sl.factory_id
----and a.company_id = sl.company_id
----and a.plant_id = sl.plant_id
--and a.line_id = sl.line_id
--and sl.division_id = a.division_id
--and sl.electrode_type = a.electrode_type
--and sl.operation_id = a.operation_id

----and a.plan_date = b.instance_date
--where --b.release_plan_id,'') < > ''
--a.plan_date = @today_yyyymmdd
--and a.plan_qty = 0
--and a.operation_id < > 'f6000'
--and b.seq = 1
	--select @if_seq as [IFSEQNO]

		COMMIT TRAN
	END	ELSE IF @p_option = 'list' BEGIN
			EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'START READ IF DATA', 0, @V_TEMP1, '############### START OF LIST ###############', @p_if_seq, @SYSDATE
		    BEGIN TRAN
		--print @p_if_seq
		--print '---0-'
		IF isnull(@p_if_seq,'') <> '' BEGIN
			--print '--1-'
			SELECT [IFSEQNO]
      ,[TRANSFER_FLAG]
      ,[TRANSFER_DATE]
      ,[COMPANY_ID]
      ,[DIVISION_ID]
      ,[SITE_ID]
      ,[PLANT_ID]
      ,[FACTORY_ID]
      ,[PLAN_GROUP_ID]
      ,[INSTANCE_TYPE]
      ,[TOP_ITEM_ID]
      ,[ITEM_ID]
      ,[OPERATION_ID]
      ,[LOCATION]
      ,[PRODUCTION_TYPE]
      ,[MARKET]
      ,[LINE_ID]
      ,[ELECTRODE_TYPE]
      ,[PLAN_DATE]
      ,[PLAN_QTY]
      ,[PLAN_IN_QTY]
      ,[INSERT_ID]
      ,[INSERT_TIME]
      ,[UPDATE_ID]
      , [UPDATE_TIME]
      ,[PLAN_TYPE]
      ,[EQUIPMENT_ID]
      ,[FP_PRODUCTION_TYPE]
      ,[ROLL_IN_QTY]
      ,[ROLL_OUT_QTY]
      ,[JR_IN_QTY]
      ,[JR_OUT_QTY]
      ,[BATCH_IN_QTY]
      ,[BATCH_OUT_QTY]
      ,[CELL_IN_QTY]
      ,[CELL_OUT_QTY]
      ,[FULL_CLEANING_FLAG]
      ,[MODEL_TYPE_CHANGE_FLAG]
      ,[SEQ]
      ,[CELL_MATERIAL_ID]
      ,[TOTAL_BATCH]
      ,[PIG_CLEANING_FLAG]
      ,[SETUP_COLOR_CODE]
      ,[SHIFT]
      ,[WORK_REQUEST_MODEL_ID]
      ,[VERSION]
      ,[PROD_SEQ]
      ,[PLM_EC_NO]
      ,[WORKCENTER_ID]
      ,[SCP_PLAN_ID]
      ,[WO_RELEASE_FLAG]
      ,[PLANNING_HORIZON_DATE]
      ,[ATTR_01]
      ,[ATTR_02]
      ,[ATTR_03]
      ,[ATTR_04]
      ,[ATTR_05]
	  from SY_XIF_ERP_DAILY_PRODUCTION_PLAN_S A with(nolock) where [IFSEQNO] = @p_if_seq 
			--print 'xxx'
		END
			COMMIT TRAN
			EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'START READ IF DATA', @ROWCOUNT, @V_TEMP1, '############### END OF LIST ###############', NULL, @SYSDATE
	END ELSE IF @p_option = 'success' BEGIN
			--print 'success'
			--print @p_if_seq
			EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'START UPDATE IF RESULT', 0, @V_TEMP1, '############### START OF UPDATE ###############', @p_if_seq, @SYSDATE
		   BEGIN TRAN
		IF isnull(@p_if_seq,'') <> '' BEGIN
		update SY_XIF_ERP_DAILY_PRODUCTION_PLAN_S SET [TRANSFER_FLAG] = 'Y', [TRANSFER_DATE] = GetDate() where [IFSEQNO] = @p_if_seq
			--print @p_if_seq --	20240508145846

		END
		COMMIT TRAN
			EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'END UPDATE IF RESULT', @ROWCOUNT, @V_TEMP1, '############### END OF UPDATE ###############', NULL, @SYSDATE
	END ELSE IF @p_option = 'fail' BEGIN
			EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'START UPDATE IF FAIL', 0, @V_TEMP1, '############### START OF UPDATE ###############', @p_if_seq, @SYSDATE
		   BEGIN TRAN
		IF isnull(@p_if_seq,'') <> '' BEGIN
		update SY_XIF_ERP_DAILY_PRODUCTION_PLAN_S SET [TRANSFER_FLAG] = 'F', [TRANSFER_DATE] = GetDate() where [IFSEQNO] = @p_if_seq

		END
		COMMIT TRAN
			EXEC PR_XIF_LOG @V_PROC_NAME, NULL, 'END UPDATE IF FAIL', @ROWCOUNT, @V_TEMP1, '############### END OF UPDATE ###############', NULL, @SYSDATE
	END
	






	END TRY	
	BEGIN CATCH

	    ROLLBACK TRAN
		-- 에러나도 로그는 인서트
		SET @v_descr = ERROR_MESSAGE()
		-- print @v_descr
		EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate
	END CATCH

end
