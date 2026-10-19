


/*
 * Program ID   : SCP0024_SAVE_PRODUCTION_PLAN_FIX_DATASET
 * Description  : PRODUCTION_PLAN_FIX 일괄등록/수정
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2019/06/07   YHW				[CSR ID:4010290] SCP UI 생산/출하 계획 저장속도 개선
 * 2021/10/20   KMJ				[PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - 속도 개선을 위한 변경
 * 2022/04/29   chaan			81_UC, EE_UC 추가로 DIVSION 크기 확장
 *
 */
CREATE PROCEDURE [dbo].[SCP0024_SAVE_PRODUCTION_PLAN_FIX_DATASET_20251111_org]
	 @SCP0013			AS DBO.SCP0013       READONLY
AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @max_loop_cnt		NVARCHAR(50);

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0024_SAVE_PRODUCTION_PLAN_FIX_DATASET';
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
	IF OBJECT_ID('tempdb..#TblDynamic_SCP0013Fix') IS NOT NULL	
		DROP TABLE #TblDynamic_SCP0013Fix
	;

	CREATE TABLE #TblDynamic_SCP0013Fix (
		p_active_flag			nvarchar(1),
--chaan	p_division_id           NVARCHAR(2)
        p_division_id           NVARCHAR(30),--chaan
		p_plan_start_yyyymmdd	nvarchar(8),	-- 2021.10.18 : 주차 fix 를 위한 컬럼 추가
		p_plan_type				nvarchar(2),	-- 2021.10.18 : 주차 fix 를 위한 컬럼 추가
		p_seq					nvarchar(10),	-- 2021.10.18 : 주차 fix 를 위한 컬럼 추가
		p_operation_group		nvarchar(1),
		p_scm_site_id			nvarchar(100),
		p_item_id				nvarchar(100),
		p_line_id				nvarchar(50),
		p_operation_id			nvarchar(100),
		p_measure				nvarchar(50),
		p_yyyymmdd				nvarchar(8),
		p_qty					nvarchar(200),
		p_fix_reason			nvarchar(100),
--chaan		p_origin_division_id	nvarchar(2),
		p_origin_division_id	nvarchar(30),--chaan
		p_electrode_type		nvarchar(50),
		p_user_id				nvarchar(100),
		p_bucket_type			nvarchar(10),
		FIX_ID					nvarchar(20)
	);

	BEGIN TRY
			-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


		INSERT INTO #TblDynamic_SCP0013Fix
		SELECT p_active_flag,
				p_division_id,
				p_plan_start_yyyymmdd,	-- 2021.10.18 : 주차 fix 를 위한 컬럼 추가
				p_plan_type,			-- 2021.10.18 : 주차 fix 를 위한 컬럼 추가
				p_seq,					-- 2021.10.18 : 주차 fix 를 위한 컬럼 추가
				p_operation_group,
				p_scm_site_id,
				p_item_id,
				p_line_id,
				p_operation_id,
				p_measure,
				p_yyyymmdd,
				ISNULL(p_qty, 0) AS p_qty,
				p_fix_reason,
				p_origin_division_id,
				p_electrode_type,
				p_user_id,
				p_bucket_type,
				''
		FROM @SCP0013
		;


		--INSERT INTO TEMP_TEST_SCP0013
		--SELECT *
		-- FROM @SCP0013;

		-- 주 SUM fix 처리  시 0 -> scp_anl_production_plan 값으로 수정
		UPDATE X
		   SET X.P_QTY = T.QTY
		  FROM #TblDynamic_SCP0013Fix X
		  JOIN SCP_ANL_PRODUCTION_PLAN T WITH(NOLOCK)
		    ON T.DIVISION_ID			= X.P_DIVISION_ID
		   AND T.PLAN_START_YYYYMMDD	= X.P_PLAN_START_YYYYMMDD
		   AND T.PLAN_TYPE				= X.P_PLAN_TYPE
		   AND T.SEQ					= X.P_SEQ
		   AND T.OPERATION_GROUP		= X.P_OPERATION_GROUP
		   AND T.SCM_SITE_ID			= X.P_SCM_SITE_ID
		   AND T.ITEM_ID				= X.P_ITEM_ID
		   AND T.LINE_ID				= X.P_LINE_ID
		   AND T.OPERATION_ID			= X.P_OPERATION_ID
		   --AND T.MEASURE				= X.P_MEASURE
		   AND T.YYYYMMDD				= X.P_YYYYMMDD
		   AND T.MEASURE = 'PROD_PLAN_AMEND'
		   AND X.P_BUCKET_TYPE = 'WEEKLY'
		;


		--SELECT*
		-- INTO TEMP_TEST_SCP0013_2
		-- FROM @SCP0013;

		--수정 Row
		SET @max_loop_cnt = convert(nvarchar(50), ISNULL((
									SELECT COUNT(*) 
									FROM #TblDynamic_SCP0013Fix  
								  ),0))
		;

		-- 입력,수정모드 결정
		UPDATE #TblDynamic_SCP0013Fix
		SET p_active_flag = ''
		WHERE p_active_flag !='D'


		-- 수정모드
		UPDATE B
		SET B.p_active_flag = 'M'
			, B.FIX_ID = A.FIX_ID
		FROM SCP_ANL_PRODUCTION_PLAN_FIX A, #TblDynamic_SCP0013Fix B
		WHERE 1=1
			AND A.division_id     = B.p_division_id
			AND A.operation_group = B.p_operation_group
			AND A.scm_site_id     = B.p_scm_site_id
			AND A.item_id         = B.p_item_id
			AND A.line_id         = B.p_line_id
			AND A.operation_id    = B.p_operation_id
			AND A.yyyymmdd        = B.p_yyyymmdd
			AND ISNULL(NULLIF(A.ELECTRODE_TYPE,''),'-')  = ISNULL(NULLIF(B.p_electrode_type,''),'-')    
			AND B.p_active_flag !='D'
		;

		--입력모드
		UPDATE #TblDynamic_SCP0013Fix
		SET p_active_flag = 'I'
		WHERE p_active_flag = ''
		;

		--입력대상 데이타 FIX_ID 채번
		UPDATE #TblDynamic_SCP0013Fix
		SET FIX_ID = CAST( (NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX) AS NVARCHAR )
		WHERE p_active_flag = 'I'
		;

		UPDATE #TblDynamic_SCP0013Fix
		SET FIX_ID = 'F' + p_yyyymmdd + REPLICATE('0', 11 - LEN(FIX_ID)) + FIX_ID
		WHERE p_active_flag = 'I'
		;

		--수량 Null 처리
		UPDATE #TblDynamic_SCP0013Fix
		SET p_qty=NULL
		WHERE ISNULL(p_qty,'') = ''
		;

		--1. 입력
		INSERT INTO DBO.SCP_ANL_PRODUCTION_PLAN_FIX (	
			FIX_ID	
			,DIVISION_ID
			,OPERATION_GROUP
			,SCM_SITE_ID
			,ITEM_ID
			,LINE_ID
			,OPERATION_ID
			,YYYYMMDD
			,QTY
			,FIX_REASON
			,ORIGIN_DIVISION_ID
			,ELECTRODE_TYPE
			,CREATED_BY
			,CREATION_DATE
			,LAST_UPDATED_BY
			,LAST_UPDATE_DATE
		)
		SELECT FIX_ID
			  ,p_division_id 
			  ,p_operation_group
			  ,p_scm_site_id
			  ,p_item_id
			  ,p_line_id
			  ,p_operation_id
			  ,p_yyyymmdd
			  ,p_qty
			  ,p_fix_reason
			  ,p_origin_division_id
			  ,p_electrode_type
			  ,p_user_id
			  ,@d_event_date
			  ,p_user_id
			  ,@d_event_date
		FROM #TblDynamic_SCP0013Fix
		WHERE p_active_flag = 'I'
		;


		--2. 수정
		UPDATE A
		SET A.qty			    = B.p_qty
			,A.fix_reason	    = B.p_fix_reason
			,A.last_updated_by  = B.p_user_id
			,A.last_update_date = @d_event_date
		FROM SCP_ANL_PRODUCTION_PLAN_FIX A, #TblDynamic_SCP0013Fix B
		WHERE 1=1
		AND A.division_id     = B.p_division_id
		AND A.operation_group = B.p_operation_group
		AND A.scm_site_id     = B.p_scm_site_id
		AND A.item_id         = B.p_item_id
		AND A.line_id         = B.p_line_id
		AND A.operation_id    = B.p_operation_id
		AND A.yyyymmdd        = B.p_yyyymmdd
		AND ISNULL(NULLIF(A.ELECTRODE_TYPE,''),'-')  = ISNULL(NULLIF(B.p_electrode_type,''),'-')
		AND B.p_active_flag IN ('M')
		;

		--3. Fix History
		-- 2021.10.20 : 주차 fix UI 에서 fix 처리 시 0 으로 전달. 임시 테이블로 이력 테이블 생성 
		DECLARE @SCP0013_HIST	AS DBO.SCP0013;

		INSERT INTO @SCP0013_HIST
		(
			p_division_id, 
			p_operation_group, 
			p_scm_site_id, 
			p_item_id,
			p_line_id,
			p_operation_id,
			p_yyyymmdd,
			p_qty,
			p_origin_division_id,
			p_electrode_type,
			p_user_id, 
			p_active_flag
		)
		SELECT
			p_division_id, 
			p_operation_group, 
			p_scm_site_id, 
			p_item_id,
			p_line_id,
			p_operation_id,
			p_yyyymmdd,
			p_qty,
			p_origin_division_id,
			p_electrode_type,
			p_user_id, 
			p_active_flag
		FROM #TblDynamic_SCP0013Fix
		;

		EXEC [PR_SCP_ANL_PRODUCTION_PLAN_FIX_HIST_DATASET] @SCP0013_HIST;

		--4. 삭제
		DELETE A
		FROM SCP_ANL_PRODUCTION_PLAN_FIX A, #TblDynamic_SCP0013Fix B
		WHERE A.division_id     = B.p_division_id
		AND A.operation_group	= B.p_operation_group
		AND A.scm_site_id		= B.p_scm_site_id
		AND A.item_id			= B.p_item_id
		AND A.line_id			= B.p_line_id
		AND A.operation_id		= B.p_operation_id
		AND A.yyyymmdd			= B.p_yyyymmdd
		AND ISNULL(NULLIF(A.ELECTRODE_TYPE,''),'-')  = ISNULL(NULLIF(B.p_electrode_type,''),'-')
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

	IF OBJECT_ID('tempdb..#TblDynamic_SCP0013Fix') IS NOT NULL	
		DROP TABLE #TblDynamic_SCP0013Fix
	;







