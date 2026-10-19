



/*
 * Program ID   : SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_FIX_DATASET
 * Description  : SHIPMENT PLAN SEMI FIX 등록,수정
 * Program History
 *===================================================================================================
 *   Date       In Charge	Description
 *===================================================================================================
 * 2019/05/27   YHW			[CSR ID:4010290] SCP UI 생산/출하 계획 저장속도 개선
 * 2022/04/29   chaan			81_UC, EE_UC 추가로 DIVSION 크기 확장
 * 
 */
CREATE PROCEDURE [dbo].[SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_FIX_DATASET_20251113_org]
	@SCP0010			AS DBO.SCP0010       READONLY
AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @max_loop_cnt		NVARCHAR(50);

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_FIX_DATASET';
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
	IF OBJECT_ID('tempdb..#TblDynamic_SCP0010Fix') IS NOT NULL	
		DROP TABLE #TblDynamic_SCP0010Fix
	;

	CREATE TABLE #TblDynamic_SCP0010Fix (
		p_active_flag	nvarchar(1),
--chaan		p_division_id	nvarchar(2),
		p_division_id	nvarchar(30),--chaan
		p_biz_type	nvarchar(1),
		p_item_id	nvarchar(100),
		p_to_site	nvarchar(100),
		p_from_site	nvarchar(50),
		p_bod_id	nvarchar(50),
		p_yyyymmdd	nvarchar(8),
		p_qty	nvarchar(200),
--chaan		p_origin_from_division_id	nvarchar(2),
		p_origin_from_division_id	nvarchar(30),--chaan
--chaan		p_origin_to_division_id	nvarchar(2),
		p_origin_to_division_id	nvarchar(30),--chaan
		p_electrode_type	nvarchar(50),
		p_fix_reason	nvarchar(100),
		p_user_id	nvarchar(150),
		debug_mode	nvarchar(1),
		FIX_ID	nvarchar(20)
	);

	BEGIN TRY
			-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


		INSERT INTO #TblDynamic_SCP0010Fix
		SELECT p_active_flag,
				p_division_id,
				p_biz_type,
				p_item_id,
				p_to_site,
				p_from_site,
				p_bod_id,
				p_yyyymmdd,
				p_qty,
				p_origin_from_division_id,
				p_origin_to_division_id,
				p_electrode_type,
				p_fix_reason,
				p_last_updated_by,
				debug_mode,
				''
		FROM @SCP0010
		;

		--수정 Row
		SET @max_loop_cnt = convert(nvarchar(50), ISNULL((
									SELECT COUNT(*) 
									FROM #TblDynamic_SCP0010Fix  
								  ),0))
		;

		-- 입력,수정모드 결정
		UPDATE #TblDynamic_SCP0010Fix
		SET p_active_flag = ''
		WHERE p_active_flag !='D'


		-- 수정모드
		UPDATE B
		SET B.p_active_flag = 'M'
			, B.FIX_ID = A.FIX_ID
		FROM SCP_ANL_SHIPMENT_PLAN_FIX A, #TblDynamic_SCP0010Fix B
		WHERE 1=1
			AND A.division_id	= B.p_division_id
			AND A.BIZ_TYPE		= B.p_biz_type
			AND A.ITEM_ID		= B.p_item_id
			AND A.TO_SITE       = B.p_to_site
			AND A.FROM_SITE     = B.p_from_site
			AND A.BOD_ID		= B.p_bod_id
			AND A.yyyymmdd      = B.p_yyyymmdd
			AND A.ORIGIN_FROM_DIVISION_ID	= B.p_origin_from_division_id
			AND A.ORIGIN_TO_DIVISION_ID		= B.p_origin_to_division_id
			AND ISNULL(NULLIF(a.ELECTRODE_TYPE,''),'-')	= ISNULL(NULLIF(B.p_electrode_type,''),'-')
			AND B.p_active_flag !='D'
		;

		--입력모드
		UPDATE #TblDynamic_SCP0010Fix
		SET p_active_flag = 'I'
		WHERE p_active_flag = ''
		;

		--입력대상 데이타 FIX_ID 채번
		UPDATE #TblDynamic_SCP0010Fix
		SET FIX_ID = CAST( (NEXT VALUE FOR SEQ1_SCP_ANL_SHIPMENT_PLAN_FIX) AS NVARCHAR )
		WHERE p_active_flag = 'I'
		;

		UPDATE #TblDynamic_SCP0010Fix
		SET FIX_ID = 'F' + p_yyyymmdd + REPLICATE('0', 11 - LEN(FIX_ID)) + FIX_ID
		WHERE p_active_flag = 'I'
		;

		--수량 Null 처리
		UPDATE #TblDynamic_SCP0010Fix
		SET p_qty=NULL
		WHERE ISNULL(p_qty,'') = ''
		;

		--1. 입력
		INSERT INTO DBO.SCP_ANL_SHIPMENT_PLAN_FIX (	
			FIX_ID	
			,DIVISION_ID
			,BIZ_TYPE
			,ITEM_ID
			,TO_SITE
			,FROM_SITE
			,PROJECT_CODE
			,INCOTERMS
			,BOD_ID
			,YYYYMMDD
			,QTY
			,ORIGIN_FROM_DIVISION_ID
			,ORIGIN_TO_DIVISION_ID
			,ELECTRODE_TYPE
			,FIX_REASON
			,CREATED_BY
			,CREATION_DATE
			,LAST_UPDATED_BY
			,LAST_UPDATE_DATE
		)
		SELECT FIX_ID
			  ,p_division_id 
			  ,p_biz_type
			  ,p_item_id
			  ,p_to_site
			  ,p_from_site
			  ,null
			  ,null
			  ,p_bod_id
			  ,p_yyyymmdd
			  ,p_qty
			  ,p_origin_from_division_id
			  ,p_origin_to_division_id
			  ,p_electrode_type
			  ,p_fix_reason
			  ,p_user_id
			  ,@d_event_date
			  ,p_user_id
			  ,@d_event_date
		FROM #TblDynamic_SCP0010Fix
		WHERE p_active_flag = 'I'
		;

		--2. 수정
		UPDATE A
		SET A.qty			    = B.p_qty
			,A.fix_reason	    = B.p_fix_reason
			,A.last_updated_by  = B.p_user_id
			,A.last_update_date = @d_event_date
		FROM SCP_ANL_SHIPMENT_PLAN_FIX A, #TblDynamic_SCP0010Fix B
		WHERE 1=1
		AND A.division_id				= B.p_division_id
		and A.BIZ_TYPE					= B.p_biz_type
		and A.ITEM_ID					= B.p_item_id
		and A.TO_SITE					= B.p_to_site
		and A.FROM_SITE					= B.p_from_site
		and A.BOD_ID					= B.p_bod_id
		and A.yyyymmdd					= B.p_yyyymmdd
		and A.ORIGIN_FROM_DIVISION_ID	= B.p_origin_from_division_id
		and A.ORIGIN_TO_DIVISION_ID		= B.p_origin_to_division_id
		and ISNULL(NULLIF(A.ELECTRODE_TYPE,''),'-')	= ISNULL(NULLIF(B.p_electrode_type,''),'-')
		AND B.p_active_flag IN ('M')

		--3. Fix History
		EXEC [PR_SCP_ANL_SHIPMENT_PLAN_SEMI_FIX_HIST_DATASET] @SCP0010

		--4. 삭제
		DELETE A
		FROM SCP_ANL_SHIPMENT_PLAN_FIX A, #TblDynamic_SCP0010Fix B
		WHERE A.division_id				= B.p_division_id
		and A.BIZ_TYPE					= B.p_biz_type
		and A.ITEM_ID					= B.p_item_id
		and A.TO_SITE					= B.p_to_site
		and A.FROM_SITE					= B.p_from_site
		and A.BOD_ID					= B.p_bod_id
		and A.yyyymmdd					= B.p_yyyymmdd
		and A.ORIGIN_FROM_DIVISION_ID	= B.p_origin_from_division_id
		and A.ORIGIN_TO_DIVISION_ID		= B.p_origin_to_division_id
		and ISNULL(NULLIF(A.ELECTRODE_TYPE,''),'-')	= ISNULL(NULLIF(B.p_electrode_type,''),'-')
		AND B.p_active_flag			= 'D'
		;

		SET @v_exec_time  =  REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
							 REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))    
		;

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
	END

	IF OBJECT_ID('tempdb..#TblDynamic_SCP0010Fix') IS NOT NULL	
		DROP TABLE #TblDynamic_SCP0010Fix
	;

