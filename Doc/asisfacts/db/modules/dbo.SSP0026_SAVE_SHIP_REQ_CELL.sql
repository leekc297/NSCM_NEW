/**=========================================================================================================================================================
 * Program ID   : SSP0026_SAVE_SHIP_REQ_CELL
 * Description  : 
 * OutTable     :
 * Execute      : 
 * Program History
 *=========================================================================================================================================================
 *   Date            In Charge      Description
 *   2020.10.20     KIMYONGHO       신규추가
 *   2020.10.21		KIMYONGHO		SSP_ANL_SHIP_REQ_40 -> DM_PLN_SHIPMENT_REQ 테이블 변경
 *   2021/09/02		KIMYONGHO		SCP_MST_BOD_N_V 조회 로직 추가
 *=========================================================================================================================================================

*========================================================================================================================================================= */

CREATE PROCEDURE [dbo].[SSP0026_SAVE_SHIP_REQ_CELL]
( 
      @p_active_flag		NVARCHAR(MAX)
	,@p_division_id		NVARCHAR(MAX)
	,@p_item_id			NVARCHAR(MAX)
	,@p_from_site			NVARCHAR(MAX)
	,@p_to_site			NVARCHAR(MAX)
	,@p_project_code		NVARCHAR(MAX)
	,@p_incoterms			NVARCHAR(MAX)
	,@p_fcst_type			NVARCHAR(MAX)
	,@p_transport_mode		NVARCHAR(MAX)
	,@p_bod_id			NVARCHAR(MAX)
	,@p_measure 			NVARCHAR(MAX)
	,@p_yyyymmdd			NVARCHAR(MAX)
	,@p_qty				NVARCHAR(MAX)
	,@p_remark			NVARCHAR(MAX)
	,@p_created_by			NVARCHAR(300)
	,@debug_mode			NVARCHAR(1)
)AS
  BEGIN

	/********************************************************************************      
	* 임시테이블만들기
	********************************************************************************/ 
	IF OBJECT_ID('tempdb..#TblDynamic_SSP0026_ShpimentReq') IS NOT NULL
		DROP TABLE #TblDynamic_SSP0026_ShpimentReq;    

	CREATE TABLE #TblDynamic_SSP0026_ShpimentReq (
		 ACTIVE_FLAG				NVARCHAR(1)
		,DIVISION_ID				NVARCHAR(30)
		,ITEM_ID					NVARCHAR(50)
		,FROM_SITE				NVARCHAR(50)
		,TO_SITE					NVARCHAR(30)
		,SHIPTO_CODE				NVARCHAR(30)
		,INCOTERMS				NVARCHAR(10)
		,TRANSPORT_MODE			NVARCHAR(10)
		,FCST_TYPE				NVARCHAR(10)
		,BOD_ID					NVARCHAR(150)
		,YYYYMMDD					NVARCHAR(8)
		,QTY						NVARCHAR(30)
		,REMARK					NVARCHAR(MAX)
	);


	DECLARE @v_delimiter			NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt			INTEGER = 0; 
	DECLARE @mst_loop_cnt			INTEGER = 0;

	DECLARE @recv_division_id		NVARCHAR(MAX);
	SET @recv_division_id = NULL;		
	SET @recv_division_id = @p_division_id;

	DECLARE @v_active_flag		NVARCHAR(1);
	DECLARE @v_division_id		NVARCHAR(30);
	DECLARE @v_item_id			NVARCHAR(50);
	DECLARE @v_from_site		NVARCHAR(50);
	DECLARE @v_to_site			NVARCHAR(30);
	DECLARE @v_shipto_code		NVARCHAR(30);
	DECLARE @v_project_code 		NVARCHAR(10);
	DECLARE @v_incoterms		NVARCHAR(10);
	DECLARE @v_fcst_type		NVARCHAR(10);
	DECLARE @v_transport_mode	NVARCHAR(10);
	DECLARE @v_bod_id			NVARCHAR(30);
	DECLARE @v_measure			NVARCHAR(50);
	DECLARE @v_yyyymmdd			NVARCHAR(8);
	DECLARE @v_remark			NVARCHAR(MAX);
	DECLARE @v_qty				NVARCHAR(30);
	DECLARE @v_order_type_detail	NVARCHAR(60);
	DECLARE @v_req_id_seq		NVARCHAR(60);

	DECLARE @v_cnt				INT;


	DECLARE @v_division_id_temp		         NVARCHAR(MAX);
	DECLARE @v_new_bod_id_temp		         NVARCHAR(MAX);
	DECLARE @v_from_site_temp		         NVARCHAR(MAX);
	DECLARE @v_to_site_temp			         NVARCHAR(MAX);
	DECLARE @v_new_incoterms_temp            NVARCHAR(MAX);
	DECLARE @v_new_transport_mode_temp       NVARCHAR(MAX);
	DECLARE @v_new_route_id_temp			 NVARCHAR(MAX);  
	DECLARE @v_new_d_contry_temp			 NVARCHAR(MAX);      
	DECLARE @v_new_d_port_code_temp          NVARCHAR(MAX);  
	DECLARE @v_new_a_country_temp            NVARCHAR(MAX);  
	DECLARE @v_new_a_port_code_temp          NVARCHAR(MAX);  
	DECLARE @v_new_customer_lt_temp          NVARCHAR(MAX);
	DECLARE @v_new_to_country_temp           NVARCHAR(MAX);  
	DECLARE @v_new_to_city_temp		         NVARCHAR(MAX);


	DECLARE @v_model_pic			         NVARCHAR(MAX);
	DECLARE @v_model_pic_temp		         NVARCHAR(MAX);




	SET @v_active_flag = NULL;
	SET @v_division_id = NULL;
	SET @v_item_id = NULL;
	SET @v_from_site = NULL;
	SET @v_to_site = NULL;
	SET @v_shipto_code = NULL;
	SET @v_project_code = NULL;
	SET @v_incoterms = NULL;
	SET @v_fcst_type = NULL;
	SET @v_transport_mode = NULL;
	SET @v_bod_id = NULL;
	SET @v_measure = NULL;
	SET @v_yyyymmdd = NULL;
	SET @v_remark = NULL;
	SET @v_qty = NULL;
	SET @v_order_type_detail = NULL;
	SET @v_req_id_seq = NULL;
	

	SET @v_cnt = 0;

    -- LOG 용 변수 설정
	DECLARE @v_program_name NVARCHAR(150) = N'SSP0026_SAVE_SHIP_REQ_CELL';
	DECLARE @v_log_type     NVARCHAR(30);
	DECLARE @n_log_count    INTEGER = 0;
	DECLARE @v_log_message  NVARCHAR(1000);
	DECLARE @v_description  NVARCHAR(500);
	DECLARE @d_event_date   DATETIME;
	DECLARE @v_table_id     NVARCHAR(150) = N'DM_PLN_SHIPMENT_REQ'; -- ▶ 테이블 필수
     DECLARE @v_batch_user   NVARCHAR(150) = N'System';  

	-- 시작 LOG
	SET @v_log_type = N'START';
	SET @v_log_message = N'########## Start of procedure ##########';
	SET @v_description = @v_program_name + ':' + N'DM_PLN_SHIPMENT_REQ INSERT LOGIC';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
					,@p_log_type      =@v_log_type
					,@p_log_count     =@n_log_count 
					,@p_log_message   =@v_log_message 
					,@p_description   =@v_description 
					,@p_event_date    =@d_event_date 
					,@p_user_id       =@v_batch_user
					;

	DECLARE @v_insert_cnt   INTEGER = 0;
	DECLARE @v_insert_sum   INTEGER = 0;


	DECLARE @v_plan_start_date		 [NVARCHAR](8);
	DECLARE @v_plan_end_date			 [NVARCHAR](8);
	DECLARE @v_cutoff_date		      [NVARCHAR](8);
	DECLARE @v_cutoff_end_date		      [NVARCHAR](8);
	DECLARE @v_plan_start_yyyymmdd   [NVARCHAR](8);
	DECLARE @IF_GROUP_NO             [NVARCHAR](50)   = FORMAT(CURRENT_TIMESTAMP, 'yyyyMMddHHmmss');

	SET @v_plan_start_yyyymmdd = CONVERT(CHAR(8), GETDATE(), 112);
	SET @v_plan_start_date = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112);

	SELECT @v_plan_end_date = BASIS_END_DATE
	FROM   SCM_SYS_CALENDAR_M WITH(NOLOCK)
	WHERE  BASIS_YYYYMMDD = CONVERT(VARCHAR, DATEADD(D, 64, CONVERT(DATETIME, @v_plan_start_date ,112)) ,112)
	
	SET @v_cutoff_date = CONVERT(VARCHAR, DATEADD(D, -1, CONVERT(DATETIME, @v_plan_start_date ,112)) ,112)
	SET @v_cutoff_end_date = CONVERT(CHAR(8), GETDATE()-1, 112);


	PRINT @v_plan_end_date;

	-- 데이터 생성 실행부
	BEGIN TRY
		--BEGIN TRAN TX_SH

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
					--SET @v_project_code 	= [dbo].[SCM_ARR_SPL_VAL](@p_project_code,		@v_delimiter, @mst_loop_cnt);
					SET @v_incoterms		= [dbo].[SCM_ARR_SPL_VAL](@p_incoterms,			@v_delimiter, @mst_loop_cnt);
					SET @v_fcst_type		= [dbo].[SCM_ARR_SPL_VAL](@p_fcst_type,			@v_delimiter, @mst_loop_cnt);
					SET @v_transport_mode	= [dbo].[SCM_ARR_SPL_VAL](@p_transport_mode,	@v_delimiter, @mst_loop_cnt);
					SET @v_bod_id			= [dbo].[SCM_ARR_SPL_VAL](@p_bod_id,			@v_delimiter, @mst_loop_cnt);
					--SET @v_measure			= [dbo].[SCM_ARR_SPL_VAL](@p_measure,			@v_delimiter, @mst_loop_cnt);
					SET @v_yyyymmdd		= [dbo].[SCM_ARR_SPL_VAL](@p_yyyymmdd,			@v_delimiter, @mst_loop_cnt);
					SET @v_remark			= [dbo].[SCM_ARR_SPL_VAL](@p_remark,				@v_delimiter, @mst_loop_cnt);
					SET @v_qty			= [dbo].[SCM_ARR_SPL_VAL](@p_qty,				@v_delimiter, @mst_loop_cnt);
				
				END

				SELECT TOP 1
					 @v_division_id_temp			= V.DIVISION_ID 
					,@v_new_bod_id_temp				= V.BOD_ID 
					,@v_from_site_temp				= V.FROM_SITE
					,@v_to_site_temp				= V.TO_SITE 
					,@v_new_incoterms_temp			= V.SSP_INCOTERMS
					,@v_new_transport_mode_temp		= V.TRANSPORT_MODE
					,@v_new_route_id_temp			= V.ROUTE_ID 
					,@v_new_d_contry_temp			= V.D_COUNTRY        
					,@v_new_d_port_code_temp		= V.D_PORT_CODE      
					,@v_new_a_country_temp			= V.A_COUNTRY        
					,@v_new_a_port_code_temp		= V.A_PORT_CODE      
					,@v_new_customer_lt_temp		= V.LT_TOTAL      
					,@v_new_to_country_temp			= V.TO_COUNTRY       
					,@v_new_to_city_temp			= V.TO_CITY

				FROM    (
							SELECT   DISTINCT B.DIVISION_ID , B.BOD_ID , B.FROM_SITE, B.TO_SITE , B.SSP_INCOTERMS, B.TRANSPORT_MODE
									,B.ROUTE_ID, B.D_COUNTRY, B.D_PORT_CODE, B.A_COUNTRY, B.A_PORT_CODE, B.LT_TOTAL, B.LT_TOTAL_ORIGIN, B.TO_COUNTRY, B.TO_CITY , B.PRIORITY, B.bod_valid_yn
							FROM (
									SELECT DIVISION_ID 
									,      BOD_ID
									,      FROM_SITE
									,      TO_SITE 
									,      SSP_INCOTERMS		AS SSP_INCOTERMS
									,      TRANSPORT_MODE 			
									,      SHIP_LT_TOTAL_ORIGIN  AS SHIP_LT_TOTAL 
									,	   ROUTE_ID
									,      d_country
									,      d_port_code
									,      a_country
									,      a_port_code
									,      lt_total
									,      LT_TOTAL_ORIGIN 
									,	   to_country
									,      to_city
									,      PRIORITY 			
									,      bod_valid_yn
									FROM SCP_MST_BOD_N_V WITH(NOLOCK) 
									--FROM scp_mst_bod_n_v WITH(NOLOCK)
									WHERE DIVISION_ID	 = @v_division_id
									AND   FROM_SITE		 = @v_from_site
									AND   TO_SITE		 = @v_to_site
									AND	  TRANSPORT_MODE = @v_transport_mode
									AND	  ssp_incoterms  = @v_incoterms
									AND   BOD_VALID_YN	 = 'Y'				
									AND   FROM_YYYYMMDD <= @v_yyyymmdd
									AND   TO_YYYYMMDD >= @v_yyyymmdd

								)  B 
		
				   )  V

					JOIN ( SELECT DISTINCT DIVISION_ID , ITEM_ID , BOD_ID 
						   FROM   SCP_MST_BOD_ITEM  WITH(NOLOCK)   -- SCP_MST_BOD_ITEM A WITH(NOLOCK) 
						   WHERE  DIVISION_ID =   @v_division_id
						   AND    ITEM_ID  = @v_item_id 
						  )   A
					  ON A.DIVISION_ID  = V.DIVISION_ID 
					 AND A.BOD_ID       = V.BOD_ID

				WHERE 1=1
				  AND V.division_id = @v_division_id
				  AND V.from_site = @v_from_site
				  AND V.to_site = @v_to_site
				  AND V.TRANSPORT_MODE = @v_transport_mode
				  AND V.ssp_incoterms = @v_incoterms
				  AND V.bod_valid_yn = 'Y'
				order by V.PRIORITY


				print @v_division_id_temp			  ;
				print @v_new_bod_id_temp			  ;
				print @v_from_site_temp				  ;
				print @v_to_site_temp				  ;
				print @v_new_incoterms_temp			  ;
				print @v_new_transport_mode_temp	  ;
				print @v_new_route_id_temp			  ;
				print @v_new_d_contry_temp			  ;
				print @v_new_d_port_code_temp		  ;
				print @v_new_a_country_temp			  ;
				print @v_new_a_port_code_temp		  ;
				print @v_new_customer_lt_temp		  ;
				print @v_new_to_country_temp		  ;
				print @v_new_to_city_temp			  ;


				IF ( (  @v_division_id_temp			= '' or @v_division_id_temp IS NULL				)
					OR (@v_new_bod_id_temp			= '' or @v_new_bod_id_temp IS NULL				)
					OR (@v_from_site_temp			= '' or @v_from_site_temp IS NULL		   		)
					OR (@v_to_site_temp				= '' or @v_to_site_temp IS NULL			   		)
					OR (@v_new_incoterms_temp		= '' or @v_new_incoterms_temp IS NULL			)
					OR (@v_new_transport_mode_temp	= '' or @v_new_transport_mode_temp IS NULL		)
					OR (@v_new_route_id_temp		= '' or @v_new_route_id_temp IS NULL			)
					OR (@v_new_d_contry_temp		= '' or @v_new_d_contry_temp IS NULL	 		)
					OR (@v_new_d_port_code_temp		= '' or @v_new_d_port_code_temp IS NULL	  		)
					OR (@v_new_a_country_temp		= '' or @v_new_a_country_temp IS NULL	  		)
					OR (@v_new_a_port_code_temp		= '' or @v_new_a_port_code_temp IS NULL	 		)
					OR (@v_new_customer_lt_temp		= '' or @v_new_customer_lt_temp IS NULL	 		)
					OR (@v_new_to_country_temp		= '' or @v_new_to_country_temp IS NULL			)
					OR (@v_new_to_city_temp			= '' or @v_new_to_city_temp IS NULL				)
					)
					BEGIN
					
			
						SELECT 'X' AS result_code, NULL AS Request_no;

						SET @v_log_type = 'END';
						SET @v_log_message = '########## END of procedure ##########';
						SET @v_description = '';
						SET @d_event_date = SYSDATETIME();
						EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

						RETURN;

					END

				INSERT INTO #TblDynamic_SSP0026_ShpimentReq
				SELECT @v_active_flag		AS ACTIVE_FLAG
					, @v_division_id		AS DIVISION_ID
					, @v_item_id			AS ITEM_ID
					, @v_from_site			AS FROM_SITE
					, @v_to_site			AS TO_SITE
					, @v_shipto_code		AS SHIPTO_CODE
					, @v_new_incoterms_temp AS INCOTERMS
					, @v_new_transport_mode_temp	AS TRANSPORT_MODE
					, @v_fcst_type			AS FCST_TYPE
					, @v_new_bod_id_temp	AS BOD_ID
					, @v_yyyymmdd			AS YYYYMMDD
					, @v_qty				AS QTY
					, @v_remark				AS REMARK
			
				--INSERT INTO #TblDynamic_SSP0026_ShpimentReq
				--SELECT @v_active_flag		AS ACTIVE_FLAG
				--	, @v_division_id		AS DIVISION_ID
				--	, @v_item_id			AS ITEM_ID
				--	, @v_from_site			AS FROM_SITE
				--	, @v_to_site			AS TO_SITE
				--	, @v_shipto_code		AS SHIPTO_CODE
				--	, @v_incoterms			AS INCOTERMS
				--	, @v_transport_mode		AS TRANSPORT_MODE
				--	, @v_fcst_type			AS FCST_TYPE
				--	, @v_bod_id			AS BOD_ID
				--	, @v_yyyymmdd			AS YYYYMMDD
				--	, @v_qty				AS QTY
				--	, @v_remark			AS REMARK
			;

			END


			SELECT  @v_cnt = COUNT(*)  
			FROM #TblDynamic_SSP0026_ShpimentReq;

			IF @v_cnt > 0 
			BEGIN

				SET @d_event_date = SYSDATETIME();
				-- 수정
				-- 삭제기능은 없으므로 Active Flag는 'I' 또는 'M'으로 가정하고 입력/수정만 진행

				--DETAIL UPDATE
				UPDATE A
				SET A.QTY = B.QTY
					--, A.REMARKS3		  = B.REMARK
					, A.LAST_UPDATED_BY   = @p_created_by
					, A.LAST_UPDATE_DATE  = @d_event_date
					, A.ATTRIBUTE1 = N'Y'
				FROM DM_PLN_SHIPMENT_REQ A WITH(NOLOCK)
				JOIN #TblDynamic_SSP0026_ShpimentReq B WITH(NOLOCK) ON A.DIVISION_ID		= B.DIVISION_ID
														AND A.PLANT_SITE_ID					= B.FROM_SITE
														AND A.SCM_SITE_ID					= B.TO_SITE
														AND A.ITEM_ID						= B.ITEM_ID
														AND A.INCOTERMS						= B.INCOTERMS
														AND A.FCST_TYPE						= B.FCST_TYPE
														AND A.BOD_ID						= B.BOD_ID				
														AND A.TRANSPORT_MODE				= B.TRANSPORT_MODE	
														AND A.YYYYMMDD						= B.YYYYMMDD
				;

				--History
				INSERT INTO DM_PLN_SHIPMENT_REQ_H
					(DIVISION_ID,	PROJECT_CODE,		SCM_SITE_ID,		ITEM_ID,			FCST_TYPE
					,INCOTERMS,		TRANSPORT_MODE,		MEASURE,			PLANT_SITE_ID,		YYYYMMDD,			QTY
					,BOD_ID,		SITE_TYPE,			CREATED_BY,			CREATION_DATE,		LAST_UPDATED_BY,	LAST_UPDATE_DATE
					, ATTRIBUTE1 )
				SELECT B.DIVISION_ID
					,'-'--B.PROJECT_CODE
					,B.TO_SITE
					,B.ITEM_ID
					,B.FCST_TYPE
					,B.INCOTERMS
					,B.TRANSPORT_MODE
					,'SHIP_REQ'
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
				FROM DM_PLN_SHIPMENT_REQ  A WITH(NOLOCK)
				JOIN #TblDynamic_SSP0026_ShpimentReq B WITH(NOLOCK) 
					ON  A.DIVISION_ID		= B.DIVISION_ID
					AND A.PLANT_SITE_ID		= B.FROM_SITE
					AND A.SCM_SITE_ID		= B.TO_SITE
					AND A.ITEM_ID			= B.ITEM_ID
					AND A.INCOTERMS			= B.INCOTERMS
					AND A.FCST_TYPE			= B.FCST_TYPE
					AND A.BOD_ID			= B.BOD_ID				
					AND A.TRANSPORT_MODE	= B.TRANSPORT_MODE	
					AND A.YYYYMMDD			= B.YYYYMMDD
				WHERE  1 = 1
				;

				SET @v_cnt = 0;  -- 저장 후 초기화
			END
			-- UPDATE END


			-- INSERT START
			SELECT @v_cnt = COUNT(*)
			FROM #TblDynamic_SSP0026_ShpimentReq B WITH(NOLOCK)
			WHERE 1=1
			AND NOT EXISTS (SELECT 1 
						FROM DM_PLN_SHIPMENT_REQ A WITH(NOLOCK)
						WHERE 1=1
						AND A.DIVISION_ID		= B.DIVISION_ID
						AND A.PLANT_SITE_ID		= B.FROM_SITE
						AND A.SCM_SITE_ID		= B.TO_SITE
						AND A.ITEM_ID			= B.ITEM_ID
						AND A.YYYYMMDD			= B.YYYYMMDD
						AND A.BOD_ID			= B.BOD_ID
						AND A.FCST_TYPE		= B.FCST_TYPE
						)
	
			IF @v_cnt > 0
			BEGIN
			
				-- INSERT 대상 건 ACTIVE FLAG 변경
				UPDATE  A
				SET A.ACTIVE_FLAG = 'I'
				FROM #TblDynamic_SSP0026_ShpimentReq A
				WHERE  NOT EXISTS (SELECT 1 
								FROM DM_PLN_SHIPMENT_REQ B WITH(NOLOCK)
								WHERE 1=1
								AND A.DIVISION_ID		= B.DIVISION_ID			
								AND A.FROM_SITE		= B.PLANT_SITE_ID			
								AND A.TO_SITE			= B.SCM_SITE_ID			
								AND A.ITEM_ID			= B.ITEM_ID				
								AND A.YYYYMMDD			= B.YYYYMMDD				
								AND A.BOD_ID			= B.BOD_ID				
								AND A.FCST_TYPE		= B.FCST_TYPE				
								)											
				;															
																			
																			
				-- 신규 REQEUST INSERT											
				--DETAIL INSERT
				INSERT INTO DM_PLN_SHIPMENT_REQ
				(
					 DIVISION_ID							
					--,COMPANY_ID
					--,PLAN_START_YYYYMMDD
					--,PLAN_TYPE
					--,SEQ
					,ITEM_ID
					,PLANT_SITE_ID
					,SCM_SITE_ID
					,SITE_TYPE
					,MEASURE
					,YYYYMMDD
					,BOD_ID
					,QTY
					--,ROUTE_ID
					,INCOTERMS
					,TRANSPORT_MODE
					--,BIZ_TYPE
					,PROJECT_CODE    
					,FCST_TYPE
					--,FCST_ETD_DATE
					--,FCST_ETA_DATE
					--,ETD_DATE
					--,ETA_DATE
					--,CONFIRM_ID
					--,REMARKS3
					,CREATED_BY
					,CREATION_DATE
					,LAST_UPDATED_BY
					,LAST_UPDATE_DATE
					,ATTRIBUTE1
				)
				SELECT 
					   B.DIVISION_ID
					 --, [dbo].[FN_GET_COMPANY_ID_FROM_PLANT](B.FROM_SITE)
					 --, @v_plan_start_yyyymmdd
					 --, 'SP'
					 --, 1
					 , B.ITEM_ID
					 , B.FROM_SITE
					 , B.TO_SITE
					 , 'SALES'
					 , 'SHIP_REQ'
					 , B.YYYYMMDD
					 , B.BOD_ID
					 , B.QTY
					 --, '-'
					 , B.INCOTERMS
					 , B.TRANSPORT_MODE
					 --, 'A'
					 , '-'
					 , B.FCST_TYPE
					 --, B.YYYYMMDD
					 --, [dbo].[FN_GET_SSP_ETA_DATE](B.DIVISION_ID, B.BOD_ID, B.YYYYMMDD) 
					 --, B.YYYYMMDD
					 --, [dbo].[FN_GET_SSP_ETA_DATE](B.DIVISION_ID, B.BOD_ID, B.YYYYMMDD) 
					 --, '-'
					 --, B.REMARK
					 , @p_created_by		AS CREATED_BY
					 , @d_event_date		AS CREATION_DATE
					 , @p_created_by		AS LAST_UPDATED_BY
					 , @d_event_date		AS LAST_UPDATE_DATE
					 ,N'Y'
				FROM #TblDynamic_SSP0026_ShpimentReq B WITH(NOLOCK)
				WHERE 1=1
				AND B.ACTIVE_FLAG  ='I'
				AND NOT EXISTS (SELECT 1 
								FROM DM_PLN_SHIPMENT_REQ A WITH(NOLOCK)
								WHERE 1=1
								AND A.DIVISION_ID		= B.DIVISION_ID
								AND A.PLANT_SITE_ID		= B.FROM_SITE
								AND A.SCM_SITE_ID		= B.TO_SITE
								AND A.ITEM_ID			= B.ITEM_ID
								AND A.YYYYMMDD			= B.YYYYMMDD
								AND A.BOD_ID			= B.BOD_ID
								AND A.FCST_TYPE		= B.FCST_TYPE
							)
				;

				--History
				INSERT INTO DM_PLN_SHIPMENT_REQ_H
					(DIVISION_ID,	PROJECT_CODE,		SCM_SITE_ID,		ITEM_ID,			FCST_TYPE
					,INCOTERMS,		TRANSPORT_MODE,		MEASURE,			PLANT_SITE_ID,		YYYYMMDD,			QTY
					,BOD_ID,		SITE_TYPE,			CREATED_BY,			CREATION_DATE,		LAST_UPDATED_BY,	LAST_UPDATE_DATE
					, ATTRIBUTE1 )
				SELECT B.DIVISION_ID
					,'-' --B.PROJECT_CODE
					,B.TO_SITE
					,B.ITEM_ID
					,B.FCST_TYPE
					,B.INCOTERMS
					,B.TRANSPORT_MODE
					,'SHIP_REQ'
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
				FROM   DM_PLN_SHIPMENT_REQ  A WITH(NOLOCK)
				JOIN #TblDynamic_SSP0026_ShpimentReq B WITH(NOLOCK) 
					ON A.DIVISION_ID		= B.DIVISION_ID
					AND A.PLANT_SITE_ID		= B.FROM_SITE
					AND A.SCM_SITE_ID		= B.TO_SITE
					AND A.ITEM_ID			= B.ITEM_ID
					AND A.INCOTERMS		= B.INCOTERMS
					AND A.BOD_ID			= B.BOD_ID				
					AND A.TRANSPORT_MODE	= B.TRANSPORT_MODE	
					AND A.YYYYMMDD			= B.YYYYMMDD
				WHERE  1 = 1
				;

				SET @v_cnt = 0;  -- 저장 후 초기화
			END
	
			SELECT 'S' AS RESULT_CODE, '' AS MSG;

			-----------------------------------------------------------
			-- 실행 Logic END --
			-----------------------------------------------------------
			--IF @@TRANCOUNT > 0
			--BEGIN
			--	COMMIT TRAN TX_SH;
			--END;       

			-- TXN LOG
			SET @v_log_type = N'TXN';    -- ▶ 로그타입
			SET @n_log_count = @@ROWCOUNT;
			SET @v_log_message = N'INSERT INTO '+@v_table_id;
			SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
			SET @d_event_date = SYSDATETIME();

			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
									,@p_log_type      =@v_log_type
									,@p_log_count     =@n_log_count 
									,@p_log_message   =@v_log_message 
									,@p_description   =@v_description 
									,@p_event_date    =@d_event_date 
									,@p_user_id       =@v_batch_user
									;      

		END TRY

		BEGIN CATCH
			--IF @@TRANCOUNT > 0
			--BEGIN
			--	ROLLBACK TRAN TX_SH
			--END;
      
			-- ERROR LOG
			SET @v_log_type = N'ERROR';
			SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
			SET @v_description = @v_program_name + N'ERROR_LINE : ' + STR(ERROR_LINE());
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
								,@p_log_type      =@v_log_type
								,@p_log_count     =@n_log_count 
								,@p_log_message   =@v_log_message 
								,@p_description   =@v_description 
								,@p_event_date    =@d_event_date 
								,@p_user_id       =@v_batch_user
								;
			return -1
		END CATCH;


 		-----------------------------------------------------------
		-- END LOG
		-----------------------------------------------------------
		SET @v_log_type		= N'END';  
		SET @v_log_message	= N'########## END of procedure ##########';  
		SET @v_description	= N'';  
		SET @d_event_date	= SYSDATETIME();  
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name  
							,@p_log_type      =@v_log_type  
							,@p_log_count     =@v_insert_sum   
							,@p_log_message   =@v_log_message   
							,@p_description   =@v_description   
							,@p_event_date    =@d_event_date   
							,@p_user_id       =@v_batch_user  
							; 
							

		IF OBJECT_ID('tempdb..#TblDynamic_SSP0026_ShpimentReq') IS NOT NULL
			DROP TABLE #TblDynamic_SSP0026_ShpimentReq;    
   
		return 1  

  END; 
