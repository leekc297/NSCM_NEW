



/*
 * Program ID   : SSP0045_SAVE_SHIPMENT_REQUEST
 * Description  : Shipment Request 입력
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2021-11-16	KIMYONGHO   SCP0045 - > SSP0045 전환
 *
 */
create PROCEDURE [dbo].[SSP0045_SAVE_SHIPMENT_REQUEST]
	 @p_active_flag		NVARCHAR(MAX)
	,@p_division_id		NVARCHAR(MAX)
	,@p_from_site		NVARCHAR(MAX)
	,@p_item_id			NVARCHAR(MAX)
	,@p_incoterms		NVARCHAR(MAX)
	,@p_transport_mode	NVARCHAR(MAX)
	,@p_to_site			NVARCHAR(MAX)
	,@p_bod_id			NVARCHAR(MAX)
	,@p_measure			NVARCHAR(MAX)
	,@p_yyyymmdd		NVARCHAR(MAX)
	,@p_qty				NVARCHAR(MAX)
	,@p_project_code	NVARCHAR(MAX)
	,@p_fcst_type		NVARCHAR(MAX)
	,@p_created_by		NVARCHAR(300)
	,@debug_mode		NVARCHAR(1)
AS

BEGIN

	/********************************************************************************      
	* 임시테이블만들기
	********************************************************************************/ 
	IF OBJECT_ID('tempdb..#TblDynamic_SSP0045_ShpimentReq') IS NOT NULL
	DROP TABLE #TblDynamic_SSP0045_ShpimentReq;    

	CREATE TABLE #TblDynamic_SSP0045_ShpimentReq (
		ACTIVE_FLAG				NVARCHAR(1)
		,DIVISION_ID			NVARCHAR(30)
		,FROM_SITE				NVARCHAR(50)
		,ITEM_ID				NVARCHAR(50)
		,INCOTERMS				NVARCHAR(10)
		,TRANSPORT_MODE			NVARCHAR(10)
		,TO_SITE				NVARCHAR(30)
		,BOD_ID					NVARCHAR(150)
		,MEASURE				NVARCHAR(50)
		,YYYYMMDD				NVARCHAR(8)
		,QTY					NVARCHAR(30)
		,PROJECT_CODE			NVARCHAR(30)
		,FCST_TYPE				NVARCHAR(30)
	);


	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	DECLARE @recv_division_id		NVARCHAR(MAX);
	SET @recv_division_id = NULL;		
	SET @recv_division_id = @p_division_id;

	DECLARE @v_active_flag		NVARCHAR(1);
	DECLARE @v_division_id		NVARCHAR(30);
	DECLARE @v_from_site		NVARCHAR(50);
	DECLARE @v_item_id			NVARCHAR(50);
	DECLARE @v_incoterms		NVARCHAR(10);
	DECLARE @v_transport_mode	NVARCHAR(10);
	DECLARE @v_to_site			NVARCHAR(30);
	DECLARE @v_bod_id			NVARCHAR(30);
	DECLARE @v_measure			NVARCHAR(50);
	DECLARE @v_yyyymmdd			NVARCHAR(8);
	DECLARE @v_qty				NVARCHAR(30);
	DECLARE @v_project_code		NVARCHAR(30);
	DECLARE @v_fcst_type		NVARCHAR(30);

		
		

	SET @v_active_flag = NULL;
	SET @v_division_id = NULL;
	SET @v_from_site = NULL;
	SET @v_item_id = NULL;
	SET @v_incoterms = NULL;
	SET @v_transport_mode = NULL;
	SET @v_to_site = NULL;
	SET @v_bod_id = NULL;
	SET @v_measure = NULL;
	SET @v_yyyymmdd = NULL;
	SET @v_qty = NULL;
	SET @v_project_code = NULL;
	SET @v_fcst_type = NULL;

	-- LOG 용 변수 설정
	DECLARE @v_program_name NVARCHAR(150) = 'SSP0045_SAVE_SHIPMENT_REQUEST';
	DECLARE @v_log_type     NVARCHAR(30);
	DECLARE @n_log_count    INTEGER = 0;
	DECLARE @v_log_message  NVARCHAR(1000);
	DECLARE @v_description  NVARCHAR(500);
	DECLARE @d_event_date   DATETIME;

	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';

	BEGIN TRY

		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_item_id, @v_delimiter);    


		/*** 1. 신규건 MEASURE별 입력데이터 정리   *****/
		WHILE LEN(@recv_division_id) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN
			
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN
				SET @v_active_flag		= [dbo].[SCM_ARR_SPL_VAL](@p_active_flag,		@v_delimiter, @mst_loop_cnt);
				SET @v_division_id		= [dbo].[SCM_ARR_SPL_VAL](@p_division_id,		@v_delimiter, @mst_loop_cnt);
				SET @v_from_site		= [dbo].[SCM_ARR_SPL_VAL](@p_from_site,			@v_delimiter, @mst_loop_cnt);
				SET @v_item_id			= [dbo].[SCM_ARR_SPL_VAL](@p_item_id,			@v_delimiter, @mst_loop_cnt);
				SET @v_incoterms		= [dbo].[SCM_ARR_SPL_VAL](@p_incoterms,			@v_delimiter, @mst_loop_cnt);
				SET @v_transport_mode	= [dbo].[SCM_ARR_SPL_VAL](@p_transport_mode,	@v_delimiter, @mst_loop_cnt);
				SET @v_to_site			= [dbo].[SCM_ARR_SPL_VAL](@p_to_site,			@v_delimiter, @mst_loop_cnt);
				SET @v_bod_id			= [dbo].[SCM_ARR_SPL_VAL](@p_bod_id,			@v_delimiter, @mst_loop_cnt);
				SET @v_measure			= [dbo].[SCM_ARR_SPL_VAL](@p_measure,			@v_delimiter, @mst_loop_cnt);
				SET @v_yyyymmdd			= [dbo].[SCM_ARR_SPL_VAL](@p_yyyymmdd,			@v_delimiter, @mst_loop_cnt);
				SET @v_qty				= [dbo].[SCM_ARR_SPL_VAL](@p_qty,				@v_delimiter, @mst_loop_cnt);
				SET @v_project_code		= [dbo].[SCM_ARR_SPL_VAL](@p_project_code,		@v_delimiter, @mst_loop_cnt);
				SET @v_fcst_type		= [dbo].[SCM_ARR_SPL_VAL](@p_fcst_type,			@v_delimiter, @mst_loop_cnt);
			END
			;

			INSERT INTO #TblDynamic_SSP0045_ShpimentReq
			SELECT @v_active_flag			AS ACTIVE_FLAG
					, @v_division_id		AS DIVISION_ID
					, @v_from_site			AS FROM_SITE
					, @v_item_id			AS ITEM_ID
					, @v_incoterms			AS INCOTERMS
					, @v_transport_mode		AS TRANSPORT_MODE
					, @v_to_site			AS TO_SITE
					, @v_bod_id				AS BOD_ID
					, 'SHIP_REQ'			AS MEASURE
					, @v_yyyymmdd			AS YYYYMMDD
					, @v_qty				AS QTY
					, @v_project_code		AS PROJECT_CODE
					, @v_fcst_type			AS FCST_TYPE
			;

		END

		-- BOD 2단계 개발 : BOD ID 를 변경하지 못하도록 주석 처리 함
		-- BOD ID Update
		-- Active Flag가 M이여도 로직 상 Insert 대상인 건들이 있음.
		--UPDATE A
		--SET A.BOd_ID = B.BOD_ID
		--FROM #TblDynamic_SSP0045_ShpimentReq A
		--JOIN SCP_MST_BOD B ON A.DIVISION_ID=B.DIVISION_ID
		--				   AND A.FROM_SITE = B.FROM_SITE
		--				   AND A.TO_SITE = B.TO_SITE
		--				   AND A.INCOTERMS = B.INCOTERMS
		--				   AND B.VALID_YN='Y'
		--JOIN SCP_MST_DISTRIBUTION_ROUTE R ON R.ROUTE_ID = B.ROUTE_ID
		--								  AND R.TRANSPORT_MODE = A.TRANSPORT_MODE
		--WHERE B.ROUTE_ID=R.ROUTE_ID
		--AND A.ACTIVE_FLAG = 'M'
		;

		--SELECT * FROM #TblDynamic_SSP0045_ShpimentReq

		-- BOD CHECK
		DECLARE @v_cnt_no_bod	INT =0;
		DECLARE @v_str_no_bod	NVARCHAR(150)='';

		SET @v_cnt_no_bod = (
							SELECT COUNT(*) 
							FROM #TblDynamic_SSP0045_ShpimentReq  
							WHERE 1=1
							AND ACTIVE_FLAG  = 'M'
							AND isnull(BOD_ID, '') = ''
							);

		IF(@v_cnt_no_bod>0)
			BEGIN
				SET @v_str_no_bod = (
								SELECT TOP 1 DIVISION_ID+'/'+FROM_SITE+'/'+TO_SITE+'/'+INCOTERMS+'/'+TRANSPORT_MODE AS NO_BOD
								FROM #TblDynamic_SSP0045_ShpimentReq
								WHERE 1=1
								AND ACTIVE_FLAG  = 'M'
								AND isnull(BOD_ID, '') = ''
								);

				SET @v_err_code    = 99111 ; 
				SET @v_err_message = N'Div, From Site, To Site 에 해당되는 BOD(Trans mode, Incoterms) 정보가 유효하지 않습니다. '+@v_str_no_bod;
				THROW  @v_err_code, @v_err_message , 1; --예외발생
			END


		SET @d_event_date = SYSDATETIME();

		-- 수정
		-- 삭제기능은 없으므로 Active Flag는 'I' 또는 'M'으로 가정하고 입력/수정만 진행
		UPDATE A
		SET A.QTY = B.QTY
			, A.LAST_UPDATED_BY	= @p_created_by
			, A.LAST_UPDATE_DATE = @d_event_date
		FROM DM_PLN_SHIPMENT_REQ A WITH(NOLOCK)
		JOIN #TblDynamic_SSP0045_ShpimentReq B WITH(NOLOCK) ON A.DIVISION_ID		= B.DIVISION_ID
															AND A.SCM_SITE_ID		= B.TO_SITE
															AND A.ITEM_ID			= B.ITEM_ID
															AND A.INCOTERMS			= B.INCOTERMS
															AND A.TRANSPORT_MODE	= B.TRANSPORT_MODE
															AND A.MEASURE			= B.MEASURE
															AND A.PLANT_SITE_ID		= B.FROM_SITE
															AND A.YYYYMMDD			= B.YYYYMMDD
															AND A.BOD_ID			= B.BOD_ID 	-- BOD 2단계 개발 : 추가
															AND A.PROJECT_CODE		= CASE WHEN (B.PROJECT_CODE = '' OR B.PROJECT_CODE = NULL OR B.PROJECT_CODE = '-') THEN  '-' ELSE B.PROJECT_CODE END
															AND A.FCST_TYPE			= CASE WHEN (B.FCST_TYPE = '' OR B.FCST_TYPE = NULL OR B.FCST_TYPE = '-') THEN  '-' ELSE B.FCST_TYPE END
		;

		INSERT INTO DM_PLN_SHIPMENT_REQ
		(DIVISION_ID,	PROJECT_CODE,	SCM_SITE_ID,		ITEM_ID,								FCST_TYPE
		,INCOTERMS,		TRANSPORT_MODE,	MEASURE,			PLANT_SITE_ID,		YYYYMMDD,			QTY
		,BOD_ID,		SITE_TYPE,		CREATED_BY,			CREATION_DATE,		LAST_UPDATED_BY,	LAST_UPDATE_DATE)
		SELECT 
			B.DIVISION_ID
			,B.PROJECT_CODE AS PROJECT_CODE
			,B.TO_SITE
			,B.ITEM_ID
			--,'-' AS DOM_EXP
			,B.FCST_TYPE AS FCST_TYPE
			,B.INCOTERMS
			,B.TRANSPORT_MODE
			,B.MEASURE
			,B.FROM_SITE
			,B.YYYYMMDD
			,B.QTY
			,B.BOD_ID
			,'PLANT'
			,@p_created_by
			,@d_event_date
			,@p_created_by
			,@d_event_date
		FROM #TblDynamic_SSP0045_ShpimentReq B WITH(NOLOCK)
		WHERE 1=1
		AND NOT EXISTS (SELECT 'X' 
						FROM DM_PLN_SHIPMENT_REQ A WITH(NOLOCK)
						WHERE 1=1
						AND A.DIVISION_ID		= B.DIVISION_ID
						AND A.SCM_SITE_ID		= B.TO_SITE
						AND A.ITEM_ID			= B.ITEM_ID
						AND A.INCOTERMS			= B.INCOTERMS
						AND A.TRANSPORT_MODE	= B.TRANSPORT_MODE
						AND A.MEASURE			= B.MEASURE
						AND A.PLANT_SITE_ID		= B.FROM_SITE
						AND A.YYYYMMDD			= B.YYYYMMDD
						AND A.BOD_ID			= B.BOD_ID -- BOD 2단계 개발 : 추가
						AND A.PROJECT_CODE		= CASE WHEN (B.PROJECT_CODE = '' OR B.PROJECT_CODE = NULL OR B.PROJECT_CODE = '-') THEN  '-' ELSE B.PROJECT_CODE END
						AND A.FCST_TYPE			= CASE WHEN (B.FCST_TYPE = '' OR B.FCST_TYPE = NULL OR B.FCST_TYPE = '-') THEN  '-' ELSE B.FCST_TYPE END
						)	
		;

		--History
		INSERT INTO DM_PLN_SHIPMENT_REQ_H
			(DIVISION_ID,	PROJECT_CODE,		SCM_SITE_ID,		ITEM_ID,								FCST_TYPE
			,INCOTERMS,		TRANSPORT_MODE,		MEASURE,			PLANT_SITE_ID,		YYYYMMDD,			QTY
			,BOD_ID,		SITE_TYPE,			CREATED_BY,			CREATION_DATE,		LAST_UPDATED_BY,	LAST_UPDATE_DATE)
		SELECT B.DIVISION_ID
				,B.PROJECT_CODE AS PROJECT_CODE
				,B.TO_SITE
				,B.ITEM_ID
				--,'-' AS DOM_EXP
				,B.FCST_TYPE AS FCST_TYPE
				,B.INCOTERMS
				,B.TRANSPORT_MODE
				,B.MEASURE
				,B.FROM_SITE
				,B.YYYYMMDD
				,B.QTY
				,B.BOD_ID
				,'PLANT'
				,@p_created_by
				,@d_event_date
				,@p_created_by
				,@d_event_date
		FROM #TblDynamic_SSP0045_ShpimentReq B

		SELECT 'S' AS RESULT_CODE, '' AS MSG

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

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
			IF( @v_err_message IS NULL OR @v_err_message ='')
				SELECT 'F' AS result_code, '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE() AS ERR_MESSAGE ;
			ELSE
				SELECT 'N' AS result_code, @v_err_message AS ERR_MESSAGE ;

			--SELECT 'F' AS result_code, '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE() AS ERR_MESSAGE ;
			--SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
		END CATCH;



	IF OBJECT_ID('tempdb..#TblDynamic_SSP0045_ShpimentReq') IS NOT NULL
	DROP TABLE #TblDynamic_SSP0045_ShpimentReq;    
 
END










