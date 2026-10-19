




/*
 * Program ID   : SCP0025_SAVE_SHIPMENT_PLAN_FIX_DATASET
 * Description  : SHIPMENT PLAN FG/SEMI FIX 삭제
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2019/07/25   yhw				[CSR ID:4071705] Production Plan Fix에서 Unfix 기능 추가
 * 2022/04/29   chaan			81_UC, EE_UC 추가로 DIVSION 크기 확장
 * 
 */
CREATE PROCEDURE [dbo].[SCP0025_SAVE_SHIPMENT_PLAN_FIX_DATASET_20251114_org]
	 @SCP0025			AS DBO.SCP0025       READONLY
AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @max_loop_cnt		NVARCHAR(50);
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0025_SAVE_SHIPMENT_PLAN_FIX_DATASET';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 실행시간 확인용    
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();    
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'00:00';   
	
	/********************************************************************************
	* 임시테이블만들기
	********************************************************************************/
	/*
	IF OBJECT_ID('tempdb..#TblDynamic_SCP0025UnFix') IS NOT NULL	
		DROP TABLE #TblDynamic_SCP0025UnFix

	CREATE TABLE TblDynamic_SCP0025UnFix (
		p_active_flag	nvarchar(1),
		p_division_id NVARCHAR(30),
		p_biz_type	nvarchar(1),
		p_item_id	nvarchar(100),
		p_to_site	nvarchar(100),
		p_from_site	nvarchar(50),
		p_bod_id	nvarchar(50),
		p_yyyymmdd	nvarchar(8),
		p_project_code	nvarchar(100),
		p_incoterms	nvarchar(20),
		p_qty	nvarchar(200),
		p_origin_from_division_id NVARCHAR(30),
		p_origin_to_division_id NVARCHAR(30),
		p_electrode_type	nvarchar(50),
		p_user_id	nvarchar(150),
		FIX_ID	nvarchar(20)
	);
	*/

	BEGIN TRY
			-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


		--수정 Row
		SET @max_loop_cnt = convert(nvarchar(50), ISNULL((
									SELECT COUNT(*) 
									FROM @SCP0025  
								  ),0))
		;

		/*
		INSERT INTO #TblDynamic_SCP0025UnFix
		SELECT p_active_flag,
				p_division_id,
				p_operation_group,
				p_item_id,
				p_to_site,
				p_from_site,
				p_bod_id,
				p_yyyymmdd,
				p_project_code,
				p_incoterms,
				p_qty,
				p_origin_from_division_id,
				p_origin_to_division_id,
				p_electrode_type,
				p_created_by,
				''
		FROM @SCP0025
		*/

		--3. Fix History
		INSERT INTO SCP_ANL_SHIPMENT_PLAN_FIX_H (
			history_seq,
			fix_id,
			division_id,
			BIZ_TYPE ,
			ITEM_ID ,
			TO_SITE ,
			FROM_SITE ,
			PROJECT_CODE ,
			INCOTERMS ,
			BOD_ID ,
			yyyymmdd,
			qty,
			ORIGIN_FROM_DIVISION_ID ,
			ORIGIN_TO_DIVISION_ID ,
			ELECTRODE_TYPE ,
			fix_reason,
			created_by,
			creation_date,
			last_updated_by,
			last_update_date,
			history_creation_date,
			ATTRIBUTE1)
		SELECT (NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H)
				,A.FIX_ID
				,B.p_division_id 
				,B.p_operation_group 
				,B.p_item_id
				,B.p_to_site
				,B.p_from_site
				,B.p_project_code
				,B.p_incoterms
				,B.p_bod_id
				,B.p_yyyymmdd
				,cast(round (cast(B.p_qty as numeric(20,10)), 0 ,1) as int)
				,B.p_origin_from_division_id
				,B.p_origin_to_division_id
				,B.p_electrode_type
				,A.fix_reason
				,B.p_created_by
				,SYSDATETIME()
				,B.p_created_by
				,SYSDATETIME()
				,SYSDATETIME()
				,ISNULL(B.p_active_flag,'')
		FROM SCP_ANL_SHIPMENT_PLAN_FIX A, @SCP0025 B
		WHERE A.division_id				= B.p_division_id
		and A.BIZ_TYPE					= B.p_operation_group
		and A.ITEM_ID					= B.p_item_id
		and A.TO_SITE					= B.p_to_site
		and A.FROM_SITE					= B.p_from_site
		and ISNULL(NULLIF(A.PROJECT_CODE,''),'-')				= ISNULL(NULLIF(B.p_project_code,''),'-')
		and ISNULL(NULLIF(A.INCOTERMS,''),'-')					= ISNULL(NULLIF(B.p_incoterms,''),'-')
		and A.BOD_ID					= B.p_bod_id
		and A.yyyymmdd					= B.p_yyyymmdd
		AND ISNULL(NULLIF(A.ORIGIN_FROM_DIVISION_ID,''),'-')	= ISNULL(NULLIF(B.p_origin_from_division_id,''),'-')
		AND ISNULL(NULLIF(A.ORIGIN_TO_DIVISION_ID,''),'-')		= ISNULL(NULLIF(B.p_origin_to_division_id,''),'-')
		AND ISNULL(NULLIF(A.ELECTRODE_TYPE,''),'-') = ISNULL(NULLIF(B.p_electrode_type,''),'-')


		--4. 삭제
		DELETE A
		FROM SCP_ANL_SHIPMENT_PLAN_FIX A, @SCP0025 B
		WHERE A.division_id				= B.p_division_id
		and A.BIZ_TYPE					= B.p_operation_group
		and A.ITEM_ID					= B.p_item_id
		and A.TO_SITE					= B.p_to_site
		and A.FROM_SITE					= B.p_from_site
		and ISNULL(NULLIF(A.PROJECT_CODE,''),'-')				= ISNULL(NULLIF(B.p_project_code,''),'-')
		and ISNULL(NULLIF(A.INCOTERMS,''),'-')					= ISNULL(NULLIF(B.p_incoterms,''),'-')
		and A.BOD_ID					= B.p_bod_id
		and A.yyyymmdd					= B.p_yyyymmdd
		and ISNULL(NULLIF(A.ORIGIN_FROM_DIVISION_ID,''),'-')	= ISNULL(NULLIF(B.p_origin_from_division_id,''),'-')
		and ISNULL(NULLIF(A.ORIGIN_TO_DIVISION_ID,''),'-')		= ISNULL(NULLIF(B.p_origin_to_division_id,''),'-')
		and ISNULL(NULLIF(A.ELECTRODE_TYPE,''),'-')	= ISNULL(NULLIF(B.p_electrode_type,''),'-')
		AND B.p_active_flag			= 'D'
		;

		SET @v_exec_time  =  REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
							 REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))    


		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description  = N'[' + @v_exec_time + ']';   
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  @max_loop_cnt AS result_cnt ;
		
	END TRY

	BEGIN CATCH
		BEGIN
			INSERT INTO scm_sys_log_batch (program_name
										  ,log_type
										  ,log_count
										  ,log_message
										  ,description
										  ,event_date
										  ,creation_date
										  ,created_by
										  ,last_update_date
										  ,last_updated_by)
			VALUES (ERROR_PROCEDURE()
				   ,'ERROR'
				   ,NULL
				   ,ERROR_MESSAGE()
				   ,NULL
				   ,SYSDATETIME()
				   ,SYSDATETIME()
				   ,ERROR_PROCEDURE()
				   ,SYSDATETIME()
				   ,ERROR_PROCEDURE());

			IF @@TRANCOUNT > 0
			  COMMIT WORK;
		END;

		-- error코드, errror 메시지 반환
		SELECT 'F' AS result_code, '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE() AS err_message ;
		  
	END CATCH;

	IF OBJECT_ID('tempdb..#TblDynamic_SCP0025UnFix') IS NOT NULL	
	DROP TABLE #TblDynamic_SCP0025UnFix 

END



