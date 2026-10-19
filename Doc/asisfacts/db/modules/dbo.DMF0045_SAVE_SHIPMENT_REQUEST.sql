
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




/*
 * Program ID   : DMF0045_SAVE_SHIPMENT_REQUEST
 * Description  : Shipment Request 입력
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2019/08/27	YJS				[PJ20189106] 전지GSCM 고도화
 * 2020/03/05	hwi1993		사용자가 변경했는지 여부 추가 ( ATTRIBUTE1 )
 * 2020/09/21  KIMYONGHO			SSP INCOTERMS 변경 작업
 *
 */
CREATE PROCEDURE [dbo].[DMF0045_SAVE_SHIPMENT_REQUEST]
	 @p_active_flag		NVARCHAR(MAX)
	,@p_division_id		NVARCHAR(MAX)
	,@p_item_id			NVARCHAR(MAX)
	,@p_from_site		NVARCHAR(MAX)
	,@p_to_site			NVARCHAR(MAX)
	,@p_project_code	NVARCHAR(MAX)
	,@p_incoterms		NVARCHAR(MAX)
	,@p_fcst_type		NVARCHAR(MAX)
	,@p_transport_mode	NVARCHAR(MAX)
	,@p_bod_id			NVARCHAR(MAX)
	,@p_measure 		NVARCHAR(MAX)
	,@p_yyyymmdd		NVARCHAR(MAX)
	,@p_qty				NVARCHAR(MAX)
	,@p_created_by		NVARCHAR(300)
	,@debug_mode		NVARCHAR(1)
AS

BEGIN

	/********************************************************************************      
	* 임시테이블만들기
	********************************************************************************/ 
	IF OBJECT_ID('tempdb..#TblDynamic_DMF0045_ShpimentReq') IS NOT NULL
	DROP TABLE #TblDynamic_DMF0045_ShpimentReq;    

	CREATE TABLE #TblDynamic_DMF0045_ShpimentReq (
		ACTIVE_FLAG				NVARCHAR(1)
		,DIVISION_ID			NVARCHAR(30)
		,ITEM_ID				NVARCHAR(50)
		,FROM_SITE				NVARCHAR(50)
		,TO_SITE				NVARCHAR(30)
		,PROJECT_CODE			NVARCHAR(30)
		,INCOTERMS				NVARCHAR(10)
		,FCST_TYPE				NVARCHAR(10)
		,TRANSPORT_MODE			NVARCHAR(10)
		,BOD_ID					NVARCHAR(150)
		,MEASURE				NVARCHAR(50)
		,YYYYMMDD				NVARCHAR(8)
		,QTY					NVARCHAR(30)
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
	DECLARE @v_item_id			NVARCHAR(50);
	DECLARE @v_from_site		NVARCHAR(50);
	DECLARE @v_to_site			NVARCHAR(30);
	DECLARE @v_project_code 	NVARCHAR(10);
	DECLARE @v_incoterms		NVARCHAR(10);
	DECLARE @v_fcst_type		NVARCHAR(10);
	DECLARE @v_transport_mode	NVARCHAR(10);
	DECLARE @v_bod_id			NVARCHAR(30);
	DECLARE @v_measure			NVARCHAR(50);
	DECLARE @v_yyyymmdd			NVARCHAR(8);
	DECLARE @v_qty				NVARCHAR(30);

	SET @v_active_flag = NULL;
	SET @v_division_id = NULL;
	SET @v_item_id = NULL;
	SET @v_from_site = NULL;
	SET @v_to_site = NULL;
	SET @v_project_code = NULL;
	SET @v_incoterms = NULL;
	SET @v_fcst_type = NULL;
	SET @v_transport_mode = NULL;
	SET @v_bod_id = NULL;
	SET @v_measure = NULL;
	SET @v_yyyymmdd = NULL;
	SET @v_qty = NULL;

	-- LOG 용 변수 설정
	DECLARE @v_program_name NVARCHAR(150) = 'DMF0045_SAVE_SHIPMENT_REQUEST';
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
				SET @v_item_id			= [dbo].[SCM_ARR_SPL_VAL](@p_item_id,			@v_delimiter, @mst_loop_cnt);
				SET @v_from_site		= [dbo].[SCM_ARR_SPL_VAL](@p_from_site,			@v_delimiter, @mst_loop_cnt);
				SET @v_to_site			= [dbo].[SCM_ARR_SPL_VAL](@p_to_site,			@v_delimiter, @mst_loop_cnt);
				SET @v_project_code 	= [dbo].[SCM_ARR_SPL_VAL](@p_project_code,		@v_delimiter, @mst_loop_cnt);
				SET @v_incoterms		= [dbo].[SCM_ARR_SPL_VAL](@p_incoterms,			@v_delimiter, @mst_loop_cnt);
				SET @v_fcst_type		= [dbo].[SCM_ARR_SPL_VAL](@p_fcst_type,			@v_delimiter, @mst_loop_cnt);
				SET @v_transport_mode	= [dbo].[SCM_ARR_SPL_VAL](@p_transport_mode,	@v_delimiter, @mst_loop_cnt);
				SET @v_bod_id			= [dbo].[SCM_ARR_SPL_VAL](@p_bod_id,			@v_delimiter, @mst_loop_cnt);
				SET @v_measure			= [dbo].[SCM_ARR_SPL_VAL](@p_measure,			@v_delimiter, @mst_loop_cnt);
				SET @v_yyyymmdd		= [dbo].[SCM_ARR_SPL_VAL](@p_yyyymmdd,			@v_delimiter, @mst_loop_cnt);
				SET @v_qty			= [dbo].[SCM_ARR_SPL_VAL](@p_qty,				@v_delimiter, @mst_loop_cnt);
			END
			;

			INSERT INTO #TblDynamic_DMF0045_ShpimentReq
			SELECT @v_active_flag			AS ACTIVE_FLAG
					, @v_division_id		AS DIVISION_ID
					, @v_item_id			AS ITEM_ID
					, @v_from_site			AS FROM_SITE
					, @v_to_site			AS TO_SITE
					, @v_project_code		AS PROJECT_CODE
					, @v_incoterms			AS INCOTERMS
					, @v_fcst_type			AS FCST_TYPE
					, @v_transport_mode		AS TRANSPORT_MODE
					, @v_bod_id				AS BOD_ID
					, @v_measure			AS MEASURE
					, @v_yyyymmdd			AS YYYYMMDD
					, @v_qty				AS QTY
			;

		END

        --select * from #TblDynamic_DMF0045_ShpimentReq;
		-- BOD ID Update
		-- Active Flag가 M이여도 로직 상 Insert 대상인 건들이 있음.
		--UPDATE A
		--SET A.BOd_ID = B.BOD_ID
		--FROM #TblDynamic_DMF0045_ShpimentReq A
		--JOIN SCP_MST_BOD_N_V B
		-- ON A.DIVISION_ID = B.DIVISION_ID
		--	AND A.FROM_SITE = B.FROM_SITE
		--	AND A.TO_SITE   = B.TO_SITE
		--	AND A.INCOTERMS = B.SSP_INCOTERMS
		--	and a.TRANSPORT_MODE = b.TRANSPORT_MODE
		--	AND B.FROM_YYYYMMDD <= A.YYYYMMDD
		--	AND B.TO_YYYYMMDD >= A.YYYYMMDD
		--	AND B.BOD_VALID_YN ='Y'
		--	;

		UPDATE A
		SET A.BOd_ID = B.BOD_ID
		FROM #TblDynamic_DMF0045_ShpimentReq A
		INNER JOIN (
				SELECT  BB.*	
				, ROW_NUMBER() OVER (PARTITION BY AA.FROM_SITE, AA.TO_SITE, AA.INCOTERMS, AA.TRANSPORT_MODE ORDER BY BB.PRIORITY ASC) AS ROWNUM
				FROM #TblDynamic_DMF0045_ShpimentReq AA WITH(NOLOCK)
				INNER JOIN SCP_MST_BOD BB 
				ON AA.DIVISION_ID = BB.DIVISION_ID
					AND AA.FROM_SITE = BB.FROM_SITE
					AND AA.TO_SITE   = BB.TO_SITE
					--* 2020/09/21  KIMYONGHO     SSP INCOTERMS 변경 작업
					--AND A.INCOTERMS = B.INCOTERMS
					AND AA.INCOTERMS = BB.ATTRIBUTE1
					AND BB.VALID_YN='Y'
					AND BB.ATTRIBUTE2 <= AA.YYYYMMDD
					AND BB.ATTRIBUTE3 >= AA.YYYYMMDD

				JOIN SCP_MST_DISTRIBUTION_ROUTE R
					ON R.ROUTE_ID = BB.ROUTE_ID
					AND R.TRANSPORT_MODE = AA.TRANSPORT_MODE

				WHERE BB.ROUTE_ID=R.ROUTE_ID
				AND AA.ACTIVE_FLAG = 'M'
				--ORDER BY PRIORITY ASC
		) B
		ON A.DIVISION_ID = B.DIVISION_ID
			AND A.FROM_SITE = B.FROM_SITE
			AND A.TO_SITE   = B.TO_SITE
			AND A.INCOTERMS = B.ATTRIBUTE1
			AND B.VALID_YN='Y'
			AND B.ATTRIBUTE2 <= A.YYYYMMDD
			AND B.ATTRIBUTE3 >= A.YYYYMMDD
			AND B.ROWNUM = 1

		--JOIN SCP_MST_BOD B ON A.DIVISION_ID=B.DIVISION_ID
		--				   AND A.FROM_SITE = B.FROM_SITE
		--				   AND A.TO_SITE = B.TO_SITE
		--				    --* 2020/09/21  KIMYONGHO     SSP INCOTERMS 변경 작업
		--				   --AND A.INCOTERMS = B.INCOTERMS
		--				   AND A.INCOTERMS = B.ATTRIBUTE1
		--				   AND B.VALID_YN='Y'
		--				   AND B.ATTRIBUTE2 <= A.YYYYMMDD
		--				   AND B.ATTRIBUTE3 >= A.YYYYMMDD
		--;

        
		-- BOD CHECK
		DECLARE @v_cnt_no_bod	INT =0;
		DECLARE @v_str_no_bod	NVARCHAR(150)='';

		SET @v_cnt_no_bod = (
							SELECT COUNT(*) 
							FROM #TblDynamic_DMF0045_ShpimentReq  
							WHERE 1=1
							AND ACTIVE_FLAG  = 'M'
							AND isnull(BOD_ID, '') = ''
							);

		IF(@v_cnt_no_bod>0)
			BEGIN
				SET @v_str_no_bod = (
								SELECT TOP 1 DIVISION_ID+'/'+FROM_SITE+'/'+TO_SITE+'/'+INCOTERMS+'/'+TRANSPORT_MODE AS NO_BOD
								FROM #TblDynamic_DMF0045_ShpimentReq
								WHERE 1=1
								AND ACTIVE_FLAG  = 'M'
								AND isnull(BOD_ID, '') = ''
								);

				SET @v_err_code    = 99111 ; 
				SET @v_err_message = N'Div, From Site, To Site 에 해당되는 BOD(Trans mode, Incoterms) 정보가 유효하지 않습니다. '+@v_str_no_bod;
				THROW  @v_err_code, @v_err_message , 1; --예외발생
			END


		SET @d_event_date = SYSDATETIME();
        --select * from #TblDynamic_DMF0045_ShpimentReq;
		-- 수정
		-- 삭제기능은 없으므로 Active Flag는 'I' 또는 'M'으로 가정하고 입력/수정만 진행
		UPDATE A
		SET A.QTY = B.QTY
			, A.LAST_UPDATED_BY	= @p_created_by
			, A.LAST_UPDATE_DATE = @d_event_date
			, A.ATTRIBUTE1 = N'Y'
		FROM DM_PLN_SHIPMENT_REQ A WITH(NOLOCK)
		JOIN #TblDynamic_DMF0045_ShpimentReq B WITH(NOLOCK) ON A.DIVISION_ID		= B.DIVISION_ID
												AND A.SCM_SITE_ID		= B.TO_SITE
												AND A.PROJECT_CODE		= B.PROJECT_CODE
												AND A.ITEM_ID			= B.ITEM_ID
												AND A.INCOTERMS		= B.INCOTERMS
												AND A.BOD_ID			= B.BOD_ID			-- 20200624 KIMYONGHO 저장 문제로 해당 조건 추가
												AND A.FCST_TYPE		= B.FCST_TYPE			-- 20200624 KIMYONGHO 저장 문제로 해당 조건 추가
												AND A.TRANSPORT_MODE	= B.TRANSPORT_MODE	
												AND A.MEASURE			= B.MEASURE
												AND A.PLANT_SITE_ID		= B.FROM_SITE
												AND A.YYYYMMDD			= B.YYYYMMDD
		;

        --select '1' + convert(nvarchar,@@TRANCOUNT);
        --select '1' + convert(nvarchar,@@TRANCOUNT);
       -- select * from #TblDynamic_DMF0045_ShpimentReq;
		--입력
		INSERT INTO DM_PLN_SHIPMENT_REQ
		(DIVISION_ID,	PROJECT_CODE,	SCM_SITE_ID,		ITEM_ID,			FCST_TYPE
		,INCOTERMS,		TRANSPORT_MODE,	MEASURE,			PLANT_SITE_ID,		YYYYMMDD,			QTY
		,BOD_ID,		SITE_TYPE,		CREATED_BY,			CREATION_DATE,		LAST_UPDATED_BY,	LAST_UPDATE_DATE
		,ATTRIBUTE1 )
		SELECT 
			B.DIVISION_ID
			,B.PROJECT_CODE
			,B.TO_SITE
			,B.ITEM_ID
			,B.FCST_TYPE
			,B.INCOTERMS
			,B.TRANSPORT_MODE
			,B.MEASURE
			,B.FROM_SITE
			,B.YYYYMMDD
			,B.QTY
			,B.BOD_ID
			,'SALES'
			,@p_created_by
			,@d_event_date
			,@p_created_by
			,@d_event_date
			, N'Y'
		FROM #TblDynamic_DMF0045_ShpimentReq B WITH(NOLOCK)
		WHERE 1=1
		AND NOT EXISTS (SELECT 1 
						FROM DM_PLN_SHIPMENT_REQ A WITH(NOLOCK)
						WHERE 1=1
						AND A.DIVISION_ID		= B.DIVISION_ID
						AND A.PROJECT_CODE		= B.PROJECT_CODE
						AND A.SCM_SITE_ID		= B.TO_SITE
						AND A.ITEM_ID			= B.ITEM_ID
						AND A.INCOTERMS			= B.INCOTERMS
						AND A.BOD_ID			= B.BOD_ID -- 20200624 KIMYONGHO 저장 문제로 해당 조건 추가
						AND A.FCST_TYPE		= B.FCST_TYPE -- 20200624 KIMYONGHO 저장 문제로 해당 조건 추가
						AND A.TRANSPORT_MODE	= B.TRANSPORT_MODE
						AND A.MEASURE			= B.MEASURE
						AND A.PLANT_SITE_ID		= B.FROM_SITE
						AND A.YYYYMMDD			= B.YYYYMMDD)
		;
        --select '2' + convert(nvarchar,@@TRANCOUNT);

		--History
		INSERT INTO DM_PLN_SHIPMENT_REQ_H
			(DIVISION_ID,	PROJECT_CODE,		SCM_SITE_ID,		ITEM_ID,			FCST_TYPE
			,INCOTERMS,		TRANSPORT_MODE,		MEASURE,			PLANT_SITE_ID,		YYYYMMDD,			QTY
			,BOD_ID,		SITE_TYPE,			CREATED_BY,			CREATION_DATE,		LAST_UPDATED_BY,	LAST_UPDATE_DATE
			, ATTRIBUTE1 )
		SELECT B.DIVISION_ID
				,B.PROJECT_CODE
				,B.TO_SITE
				,B.ITEM_ID
				,B.FCST_TYPE
				,B.INCOTERMS
				,B.TRANSPORT_MODE
				,B.MEASURE
				,B.FROM_SITE
				,B.YYYYMMDD
				,B.QTY
				,B.BOD_ID
				,'SALES'
				,@p_created_by
				,@d_event_date
				,@p_created_by
				,@d_event_date
				,N'Y'
		FROM #TblDynamic_DMF0045_ShpimentReq B
        --select '3' + convert(nvarchar,@@TRANCOUNT);
        --select * from #TblDynamic_DMF0045_ShpimentReq;

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



	IF OBJECT_ID('tempdb..#TblDynamic_DMF0045_ShpimentReq') IS NOT NULL
	DROP TABLE #TblDynamic_DMF0045_ShpimentReq;    
 
END











