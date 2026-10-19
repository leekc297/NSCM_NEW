
/**=========================================================================================================================================================
 * Program ID   : SSP0026_SAVE_SHIP_REQ_DETAIL_PACK
 * Description  : PACKER 재고 PSI 정보 재 생성 
 * OutTable     :
 * Execute      : SSP0026 'SAVE' 클릭 시 PLAN REQ 정보 저장 후 실행 (신규)
 * Program History
 *=========================================================================================================================================================
 *   Date            In Charge      Description
 *   2020.10.07      KIMYONGHO      신규추가
 *   2021/09/02		 KIMYONGHO      SCP_MST_BOD_N_V 조회 로직 추가
 *   2021/11/03      SHINMYUNGSU    XIF_SCS_PACK_SHIP_PLAN_S 입력값수정, SSP_ANL_SHIP_PLAN_PACK_REQ_H -> SSP_ANL_SHIP_REQ_P_H 변경
 *   2022/01/04      KIMYONGHO		ITEM 코드 11자리까지 동일하면 유효한 BOD ITEM
 *   2024/10/01      KHJ            NERP_SSP
 *=========================================================================================================================================================
 	<MEASURE>  
	--PACK_FP(Pack FP)             : SCM_DNM_SCS_PROD_PLAN 의 정보기준 생산계획을 생성
	TOTAL_PLAN(Total)            : SSP_ANL_SHIP_PLAN_PACKER 의 MEASURE   = 'SCP_SHIP_PLAN' 기준
	TOTAL_REQ(Total)             : SSP_ANL_SHIP_PLAN_PACKER 의 MEASURE   = 'SHIP_REQ' 기준
	WH_BOH_PLAN(W/H BOH(Plan))   : SSP_ANL_SHIP_PLAN_PACKER 의 MEASURE   = 'TOTAL_PLAN' & 'PACK_FP' 인 정보기준 출하 REQUEST 을 생성
	WH_BOH_REQ(W/H BOH(Req))     : SSP_ANL_SHIP_PLAN_PACKER 의 MEASURE   = 'TOTAL_REQ' & 'PACK_FP' 인 정보기준 출하 REQUEST 을 생성
*=========================================================================================================================================================
*========================================================================================================================================================= */

CREATE PROCEDURE [dbo].[SSP0026_SAVE_SHIP_REQ_DETAIL_PACK]
( 
     @p_active_flag			NVARCHAR(MAX)
	,@p_division_id			NVARCHAR(MAX)
	,@p_item_id				NVARCHAR(MAX)
	,@p_from_site			NVARCHAR(MAX)
	,@p_to_site				NVARCHAR(MAX)
	,@p_shipto_code			NVARCHAR(MAX)
	,@p_incoterms			NVARCHAR(MAX)
	,@p_transport_mode		NVARCHAR(MAX)
	,@p_fcst_type			NVARCHAR(MAX)
	,@p_bod_id				NVARCHAR(MAX)
	,@p_yyyymmdd			NVARCHAR(MAX)
	,@p_qty					NVARCHAR(MAX)
	,@p_remark				NVARCHAR(MAX)
	,@p_order_type_detail	NVARCHAR(60)
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
		,FROM_SITE					NVARCHAR(50)
		,TO_SITE					NVARCHAR(30)
		,SHIPTO_CODE				NVARCHAR(30)
		,INCOTERMS					NVARCHAR(10)
		,TRANSPORT_MODE				NVARCHAR(10)
		,FCST_TYPE					NVARCHAR(10)
		,BOD_ID						NVARCHAR(150)
		,YYYYMMDD					NVARCHAR(8)
		,QTY						NVARCHAR(30)
		,REMARK						NVARCHAR(MAX)
		,ORDER_TYPE_DETAIL			NVARCHAR(60)
		,REQUEST_ID					NVARCHAR(30)
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
	DECLARE @v_confirm_day		NVARCHAR(8);

	

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

	SET @v_confirm_day = NULL;

    -- LOG 용 변수 설정
	DECLARE @v_program_name NVARCHAR(150) = N'SSP0026_SAVE_SHIP_REQ_PACKER';
	DECLARE @v_log_type     NVARCHAR(30);
	DECLARE @n_log_count    INTEGER = 0;
	DECLARE @v_log_message  NVARCHAR(1000);
	DECLARE @v_description  NVARCHAR(500);
	DECLARE @d_event_date   DATETIME;
	DECLARE @v_table_id     NVARCHAR(150) = N'SSP_ANL_SHIP_PLAN_PACKER'; -- ▶ 테이블 필수
     DECLARE @v_batch_user   NVARCHAR(150) = N'scp_packer_batch';  

	-- 시작 LOG
	SET @v_log_type = N'START';
	SET @v_log_message = N'########## Start of procedure ##########';
	SET @v_description = @v_program_name + ':' + N' SHIP_PLAN INSERT LOGIC';
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


	DECLARE @v_plan_start_date			 [NVARCHAR](8);
	DECLARE @v_plan_end_date			 [NVARCHAR](8);
	DECLARE @v_cutoff_date				 [NVARCHAR](8);
	DECLARE @v_cutoff_end_date		     [NVARCHAR](8);
	DECLARE @v_plan_start_yyyymmdd		 [NVARCHAR](8);
	DECLARE @IF_GROUP_NO				 [NVARCHAR](50)   = FORMAT(CURRENT_TIMESTAMP, 'yyyyMMddHHmmss');

	SET @v_plan_start_yyyymmdd = CONVERT(CHAR(8), GETDATE(), 112);
	SET @v_plan_start_date = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112);

	SELECT @v_plan_end_date = BASIS_END_DATE
	FROM   SCM_SYS_CALENDAR_M
	WHERE  BASIS_YYYYMMDD = CONVERT(VARCHAR, DATEADD(D, 64, CONVERT(DATETIME, @v_plan_start_date ,112)) ,112)
	
	SET @v_cutoff_date = CONVERT(VARCHAR, DATEADD(D, -1, CONVERT(DATETIME, @v_plan_start_date ,112)) ,112)
	SET @v_cutoff_end_date = CONVERT(CHAR(8), GETDATE()-1, 112);


	PRINT @v_plan_end_date;

    -- 데이터 생성 실행부
    BEGIN TRY
        BEGIN TRAN TX_SH

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
				SET @v_shipto_code		= [dbo].[SCM_ARR_SPL_VAL](@p_shipto_code,		@v_delimiter, @mst_loop_cnt);
				--SET @v_project_code 	= [dbo].[SCM_ARR_SPL_VAL](@p_project_code,		@v_delimiter, @mst_loop_cnt);
				SET @v_incoterms		= [dbo].[SCM_ARR_SPL_VAL](@p_incoterms,			@v_delimiter, @mst_loop_cnt);
				SET @v_fcst_type		= [dbo].[SCM_ARR_SPL_VAL](@p_fcst_type,			@v_delimiter, @mst_loop_cnt);
				SET @v_transport_mode	= [dbo].[SCM_ARR_SPL_VAL](@p_transport_mode,	@v_delimiter, @mst_loop_cnt);
				SET @v_bod_id			= [dbo].[SCM_ARR_SPL_VAL](@p_bod_id,			@v_delimiter, @mst_loop_cnt);
				--SET @v_measure			= [dbo].[SCM_ARR_SPL_VAL](@p_measure,			@v_delimiter, @mst_loop_cnt);
				SET @v_yyyymmdd			= [dbo].[SCM_ARR_SPL_VAL](@p_yyyymmdd,			@v_delimiter, @mst_loop_cnt);
				SET @v_remark			= [dbo].[SCM_ARR_SPL_VAL](@p_remark,				@v_delimiter, @mst_loop_cnt);
				SET @v_qty				= [dbo].[SCM_ARR_SPL_VAL](@p_qty,				@v_delimiter, @mst_loop_cnt);
				SET @v_order_type_detail = [dbo].[SCM_ARR_SPL_VAL](@p_order_type_detail,	@v_delimiter, @mst_loop_cnt);
				
			END
			;

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
									--FROM SCP_MST_BOD_V WITH(NOLOCK)
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
				   JOIN ( SELECT DISTINCT 
							A.DIVISION_ID 
							, V.FROM_SITE
							, CASE WHEN ISNULL(B.PACKER_ITEM_ID_SUFFIX,'') = '' THEN A.ITEM_ID ELSE ISNULL(STUFF(A.ITEM_ID,12,1, B.PACKER_ITEM_ID_SUFFIX), A.ITEM_ID)  END  AS ITEM_ID 
							, A.BOD_ID 
						   FROM   SCP_MST_BOD_ITEM  A WITH(NOLOCK) 
						   INNER JOIN SCP_MST_BOD_N_V V WITH(NOLOCK) 
							 ON A.DIVISION_ID =  V.DIVISION_ID
							AND A.BOD_ID	  =  V.BOD_ID
						   INNER JOIN SCM_MST_SITE	B
							 ON B.DIVISION_ID = V.DIVISION_ID
							AND B.SCM_SITE_ID = V.FROM_SITE
						   WHERE  A.DIVISION_ID =   @v_division_id
							 AND  B.OSP_YN		= 'Y'
						     AND CASE WHEN ISNULL(B.PACKER_ITEM_ID_SUFFIX,'') = '' THEN A.ITEM_ID ELSE ISNULL(STUFF(A.ITEM_ID,12,1, B.PACKER_ITEM_ID_SUFFIX), A.ITEM_ID) END =  @v_item_id 						     
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
						PRINT '#';
						THROW 60001, 'Unauthorized', 1;  -- ERROR 발생 시켜 UI에서 사용함 	
			
						--SELECT 'X' AS result_code, NULL AS Request_no;

						--SET @v_log_type = 'END';
						--SET @v_log_message = '########## END of procedure ##########';
						--SET @v_description = '';
						--SET @d_event_date = SYSDATETIME();
						--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

						--RETURN;

					END

			INSERT INTO #TblDynamic_SSP0026_ShpimentReq
			SELECT @v_active_flag			 AS ACTIVE_FLAG
					, @v_division_id		 AS DIVISION_ID
					, @v_item_id			 AS ITEM_ID
					, @v_from_site			 AS FROM_SITE
					, @v_to_site			 AS TO_SITE
					, @v_shipto_code		 AS SHIPTO_CODE
					, @v_new_incoterms_temp	 AS INCOTERMS
					, @v_new_transport_mode_temp AS TRANSPORT_MODE
					, @v_fcst_type			 AS FCST_TYPE
					, @v_new_bod_id_temp	 AS BOD_ID
					, @v_yyyymmdd			 AS YYYYMMDD
					, @v_qty				 AS QTY
					, @v_remark				 AS REMARK
					, @v_order_type_detail   AS ORDER_TYPE_DETAIL
					, 'R'+ CONVERT(VARCHAR(8), GETDATE(), 112) + RIGHT('000000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_PACKER_REQ_ID),6) AS REQUEST_ID
			;

			--INSERT INTO #TblDynamic_SSP0026_ShpimentReq
			--SELECT @v_active_flag			 AS ACTIVE_FLAG
			--		, @v_division_id		 AS DIVISION_ID
			--		, @v_item_id			 AS MODEL_ID
			--		, @v_from_site			 AS FROM_SITE
			--		, @v_to_site			 AS TO_SITE
			--		, @v_shipto_code		 AS SHIPTO_CODE
			--		, @v_incoterms			 AS INCOTERMS
			--		, @v_transport_mode		AS TRANSPORT_MODE
			--		, @v_bod_id				AS BOD_ID
			--		, @v_yyyymmdd			 AS YYYYMMDD
			--		, @v_qty				 AS QTY
			--		, @v_remark				 AS REMARK
			--		, @v_order_type_detail   AS ORDER_TYPE_DETAIL
			--		, 'R'+ CONVERT(VARCHAR(8), GETDATE(), 112) + RIGHT('000000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_PACKER_REQ_ID),6) AS REQUEST_ID
			--;

		END

		


		SELECT @v_confirm_day = CONVERT(VARCHAR, DATEADD(D, 0 + ISNULL(B.SHIP_FROZEN,0), CONVERT(DATETIME,GETDATE() ,112)) ,112)
		FROM #TblDynamic_SSP0026_ShpimentReq A
		LEFT OUTER JOIN SCM_MST_SITE B WITH(NOLOCK)
			ON A.DIVISION_ID = B.DIVISION_ID
			AND A.FROM_SITE  = B.SCM_SITE_ID
		WHERE 1=1 
		AND A.YYYYMMDD < CONVERT(VARCHAR, DATEADD(D, 0 + ISNULL(B.SHIP_FROZEN,0), CONVERT(DATETIME,GETDATE() ,112)) ,112)
		;


		IF @v_confirm_day IS NOT NULL
		BEGIN
			PRINT '#';
			THROW 60002, 'ConfirmDayCheck', 1;  -- ERROR 발생 시켜 UI에서 사용함 	
		END
			



		SELECT  @v_cnt = COUNT(*)  
		FROM #TblDynamic_SSP0026_ShpimentReq;
		
		--select * from #TblDynamic_SSP0026_ShpimentReq;

		IF @v_cnt > 0 
		BEGIN

			SET @d_event_date = SYSDATETIME();
			-- 수정
			-- 삭제기능은 없으므로 Active Flag는 'I' 또는 'M'으로 가정하고 입력/수정만 진행

			---- 2020-09-25 KIMYONGHO REQUEST_ID 없는 경우 새로 생성
			--SELECT @v_req_id_seq = 'R'+ CONVERT(VARCHAR(8), GETDATE(), 112) + RIGHT('000000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_PACKER_REQ_ID),6)
			--FROM SSP_ANL_SHIP_PLAN_PACK_REQ A WITH(NOLOCK)
			--JOIN #TblDynamic_SSP0026_ShpimentReq B WITH(NOLOCK) ON A.DIVISION_ID		= B.DIVISION_ID
			--										AND A.FROM_SITE		= B.FROM_SITE
			--										AND A.TO_SITE			= B.TO_SITE
			--										AND A.SHIPTO_CODE		= B.SHIPTO_CODE
			--										AND A.MODEL_ID			= B.MODEL_ID
			--										AND A.INCOTERMS			= B.INCOTERMS
			--										AND A.BOD_ID			= B.BOD_ID				
			--										AND A.TRANSPORT_MODE	= B.TRANSPORT_MODE	
			--										AND A.YYYYMMDD			= B.YYYYMMDD
		 --    WHERE A.REQUEST_ID IS NULL
			--;

			--SET @v_req_id_seq = 'R'+ CONVERT(VARCHAR(8), GETDATE(), 112) + RIGHT('000000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_PACKER_REQ_ID),6);
			--DETAIL UPDATE



			UPDATE A
			SET A.QTY = B.QTY
				--, A.INCOTERMS		  = B.INCOTERMS
				--, A.TRANSPORT_MODE	  = B.TRANSPORT_MODE
				, A.BOD_ID			  = B.BOD_ID
				, A.PROJECT_CODE	  = EC.SOLDTO_CUSTOMER
				, A.FCST_TYPE		  = B.FCST_TYPE
			    , A.ORDER_TYPE_DETAIL = B.ORDER_TYPE_DETAIL
				, A.REQUEST_ID		  = CASE WHEN A.REQUEST_ID IS NULL THEN B.REQUEST_ID ELSE A.REQUEST_ID END
				, A.REMARK			  = B.REMARK
				, A.LAST_UPDATED_BY   = @p_created_by
				, A.LAST_UPDATE_DATE  = @d_event_date
			FROM [DBO].[SSP_ANL_SHIP_REQ_P] A WITH(NOLOCK)
			JOIN #TblDynamic_SSP0026_ShpimentReq B WITH(NOLOCK) ON A.DIVISION_ID		= B.DIVISION_ID
													--AND A.FROM_SITE						= B.FROM_SITE
													--AND A.TO_SITE						= B.TO_SITE
													AND A.SHIPTO_CODE					= B.SHIPTO_CODE
													AND A.ITEM_ID						= B.ITEM_ID
													--AND A.FCST_TYPE						= B.FCST_TYPE
													--AND A.INCOTERMS						= B.INCOTERMS
													AND A.BOD_ID						= B.BOD_ID				
													--AND A.TRANSPORT_MODE				= B.TRANSPORT_MODE	
													AND A.YYYYMMDD						= B.YYYYMMDD
			LEFT OUTER JOIN SCM_MST_SITE EC  WITH(NOLOCK)														
			  ON EC.DIVISION_ID = A.DIVISION_ID																	
			  AND EC.SCM_SITE_ID = B.TO_SITE																	
			 AND EC.VALID_YN = 'Y'																			

			--*   2020.09.21      KIM BOK KI     HISTORY 추가
			--*   2021.11.03      SHIN MYUNG SU  수정 ( SSP_ANL_SHIP_PLAN_PACK_REQ_H -> SSP_ANL_SHIP_REQ_P_H 변경)
			-- ITEM_ID
			INSERT INTO SSP_ANL_SHIP_REQ_P_H (
				   HISTORY_SEQ
				 , DIVISION_ID
				 -- , MODEL_TYPE
				 -- , MODEL_ID
				 -- , FROM_SITE
				 -- , TO_SITE
				 , SHIPTO_CODE
				 , YYYYMMDD
				 , BOD_ID
				 , QTY
				 , REQUEST_ID
				 , CONFIRM_ID
				 -- , INCOTERMS
				 -- , TRANSPORT_MODE
				 , ORDER_TYPE_DETAIL
				 , REMARK
				 , CREATED_BY
				 , CREATION_DATE
				 , LAST_UPDATED_BY
				 , LAST_UPDATE_DATE
				 , ATTRIBUTE1
				 , ATTRIBUTE2
				 , ATTRIBUTE3
				 , ATTRIBUTE4
				 , ATTRIBUTE5
				 , ATTRIBUTE6
				 , ATTRIBUTE7
				 , ATTRIBUTE8
				 , ATTRIBUTE9
				 , ATTRIBUTE10
				 , ITEM_ID
				   )
			SELECT NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_PACKER_REQ_H   AS HISTORY_SEQ
				 , A.DIVISION_ID
				 -- , '-' AS MODEL_TYPE
				 --, A.ITEM_ID
				 --, B.FROM_SITE
				 --, B.TO_SITE
				 , A.SHIPTO_CODE
				 , A.YYYYMMDD
				 , A.BOD_ID
				 , A.QTY
				 , A.REQUEST_ID
				 , A.CONFIRM_ID
				 --, B.INCOTERMS
				 --, B.TRANSPORT_MODE
				 , A.ORDER_TYPE_DETAIL
				 , A.REMARK
				 , A.CREATED_BY
				 , A.CREATION_DATE
				 , A.LAST_UPDATED_BY
				 , A.LAST_UPDATE_DATE
				 , A.ATTRIBUTE1
				 , A.ATTRIBUTE2
				 , A.ATTRIBUTE3
				 , A.ATTRIBUTE4
				 , A.ATTRIBUTE5
				 , A.ATTRIBUTE6
				 , A.ATTRIBUTE7
				 , A.ATTRIBUTE8
				 , A.ATTRIBUTE9
				 , A.ATTRIBUTE10
				 , A.ITEM_ID
			FROM   [DBO].[SSP_ANL_SHIP_REQ_P]  A WITH(NOLOCK)
					JOIN #TblDynamic_SSP0026_ShpimentReq B WITH(NOLOCK) ON A.DIVISION_ID		= B.DIVISION_ID
															--AND A.FROM_SITE			= B.FROM_SITE
															--AND A.TO_SITE			= B.TO_SITE
															AND A.SHIPTO_CODE		= B.SHIPTO_CODE
															AND A.ITEM_ID			= B.ITEM_ID
															--AND A.INCOTERMS			= B.INCOTERMS
															AND A.BOD_ID			= B.BOD_ID				
															--AND A.TRANSPORT_MODE	= B.TRANSPORT_MODE
															--AND A.FCST_TYPE			= B.FCST_TYPE
				
						AND A.YYYYMMDD			= B.YYYYMMDD
			WHERE  1 = 1
			;
			--INSERT INTO SSP_ANL_SHIP_PLAN_PACK_REQ_H (
			--	   HISTORY_SEQ
			--	 , DIVISION_ID
			--	 , MODEL_TYPE
			--	 , MODEL_ID
			--	 , FROM_SITE
			--	 , TO_SITE
			--	 , SHIPTO_CODE
			--	 , YYYYMMDD
			--	 , BOD_ID
			--	 , QTY
			--	 , REQUEST_ID
			--	 , CONFIRM_ID
			--	 , INCOTERMS
			--	 , TRANSPORT_MODE
			--	 , ORDER_TYPE_DETAIL
			--	 , REMARK
			--	 , CREATED_BY
			--	 , CREATION_DATE
			--	 , LAST_UPDATED_BY
			--	 , LAST_UPDATE_DATE
			--	 , ATTRIBUTE1
			--	 , ATTRIBUTE2
			--	 , ATTRIBUTE3
			--	 , ATTRIBUTE4
			--	 , ATTRIBUTE5
			--	 , ATTRIBUTE6
			--	 , ATTRIBUTE7
			--	 , ATTRIBUTE8
			--	 , ATTRIBUTE9
			--	 , ATTRIBUTE10
			--	   )
			--SELECT NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_PACKER_REQ_H   AS HISTORY_SEQ
			--	 , A.DIVISION_ID
			--	 , '-' AS MODEL_TYPE
			--	 , A.ITEM_ID
			--	 , B.FROM_SITE
			--	 , B.TO_SITE
			--	 , A.SHIPTO_CODE
			--	 , A.YYYYMMDD
			--	 , A.BOD_ID
			--	 , A.QTY
			--	 , A.REQUEST_ID
			--	 , A.CONFIRM_ID
			--	 , B.INCOTERMS
			--	 , B.TRANSPORT_MODE
			--	 , A.ORDER_TYPE_DETAIL
			--	 , A.REMARK
			--	 , A.CREATED_BY
			--	 , A.CREATION_DATE
			--	 , A.LAST_UPDATED_BY
			--	 , A.LAST_UPDATE_DATE
			--	 , A.ATTRIBUTE1
			--	 , A.ATTRIBUTE2
			--	 , A.ATTRIBUTE3
			--	 , A.ATTRIBUTE4
			--	 , A.ATTRIBUTE5
			--	 , A.ATTRIBUTE6
			--	 , A.ATTRIBUTE7
			--	 , A.ATTRIBUTE8
			--	 , A.ATTRIBUTE9
			--	 , A.ATTRIBUTE10
			--FROM   [DBO].[SSP_ANL_SHIP_REQ_P]  A WITH(NOLOCK)
			--		JOIN #TblDynamic_SSP0026_ShpimentReq B WITH(NOLOCK) ON A.DIVISION_ID		= B.DIVISION_ID
			--												--AND A.FROM_SITE			= B.FROM_SITE
			--												--AND A.TO_SITE			= B.TO_SITE
			--												AND A.SHIPTO_CODE		= B.SHIPTO_CODE
			--												AND A.ITEM_ID			= B.ITEM_ID
			--												--AND A.INCOTERMS			= B.INCOTERMS
			--												AND A.BOD_ID			= B.BOD_ID				
			--												--AND A.TRANSPORT_MODE	= B.TRANSPORT_MODE
			--												--AND A.FCST_TYPE			= B.FCST_TYPE
				
			--			AND A.YYYYMMDD			= B.YYYYMMDD
			--WHERE  1 = 1
			--;


			-- SCS I/F 정보 생성
			-- I/F 주체는 SCS 에서 함
			INSERT INTO XIF_SCS_PACK_SHIP_PLAN_S_SN (
				   IF_SEQ           
				 , IF_TYPE          
				 , IF_ID            
				 , IF_INS_DATE      
				 , IF_FLAG          
				 , PACKER_CODE      
				 , DIVISION_ID      
				 , PLAN_VERSION   
				 , PACK_MODEL_CODE  
				 , NICK_NAME 
				 , TARGET_ORDER
				 , SSP_CNFM
				 , SALES_SITE
				 , SHIP_TO
				 , SHIP_TO_NAME
				 , TRANSPORT_MODE
				 , INCOTERMS
				 , SHIP_PLAN_DATE 
				 , SHIP_PLAN_QTY 
				 , COMMENT
				 , ATTR_01           
				 , ATTR_02           
				 , ATTR_03           
				 , ATTR_04           
				 , ATTR_05           
				 , ATTR_06           
				 , ATTR_07           
				 , ATTR_08           
				 , ATTR_09           
				 , ATTR_10 
				 , ORDER_TYPE_DETAIL
				 )
			SELECT
				'OSCM' + CONVERT(VARCHAR,GETDATE(),12) + DBO.FN_ZERO_LPAD(CONVERT(VARCHAR,NEXT VALUE FOR DBO.SEQ1_XIF_SCS),10)  AS IF_SEQ
				, N'I'         AS IF_TYPE          
				, N'OSCM_OSCS_SCS_PACK_SHIP_PLAN'  AS IF_ID            
				, GETDATE()    AS IF_INS_DATE      
				, 'N'          AS IF_FLAG          
				, ISNULL(X1.NEW_VALUE1, A.PACKER_CODE)		AS PACKER_CODE        
				, A.DIVISION_ID      
				, @v_plan_start_yyyymmdd   AS PLAN_VERSION   
				, A.PACK_MODEL_CODE  
				, A.NICK_NAME 
				, N'O'          AS TARGET_ORDER
				, A.SSP_CNFM
				, A.SALES_SITE
				, A.SHIP_TO
				, A.SHIP_TO_NAME
				, A.TRANSPORT_MODE
				, A.INCOTERMS
				, A.SHIP_PLAN_DATE 
				, A.SHIP_PLAN_QTY 
				, A.COMMENT
				, A.ATTR_01           
				, NULL								AS ATTR_02          
				, A.ATTR_03      --Model PIC   				
				, A.ATTR_04		--MTK_OWNER       
				, NULL								AS ATTR_05           
				, NULL								AS ATTR_06           
				, NULL								AS ATTR_07           
				, NULL								AS ATTR_08           
				, NULL								AS ATTR_09           
				, NULL								AS ATTR_10
				, A.ORDER_TYPE_DETAIL
				/***************************************************************************/
			FROM
			(
				SELECT B.FROM_SITE  AS PACKER_CODE      
					 , B.DIVISION_ID AS DIVISION_ID      
					 , B.ITEM_ID    AS PACK_MODEL_CODE  
					 , [dbo].[FN_GET_ITEM_NICKNAME](B.DIVISION_ID, B.ITEM_ID)  AS NICK_NAME 
					 , A.REQUEST_ID AS SSP_CNFM
					 , B.TO_SITE     AS SALES_SITE
					 , B.SHIPTO_CODE AS SHIP_TO
					 , [dbo].[FN_GET_SITE_CUSTOMER_INFO](B.DIVISION_ID, B.TO_SITE,'SHIPTO_DESCRIPTION')	AS SHIP_TO_NAME
					 , B.TRANSPORT_MODE
					 , B.INCOTERMS
					 , B.YYYYMMDD    AS SHIP_PLAN_DATE 
					 , B.QTY         AS SHIP_PLAN_QTY 
					 /* 20211102  SHINMYUNGSU  수정  ********************************************/
					 --, NULL								AS COMMENT
					 , B.REMARK								AS COMMENT
					 /***************************************************************************/
					 , B.DIVISION_ID + '_' + @v_plan_start_yyyymmdd + '_' + @IF_GROUP_NO	AS ATTR_01           
					/* 20211102  SHINMYUNGSU  수정  ****************************************************/
				-- , NULL								AS ATTR_03    
					 , U2.UserName + '(' + MU.USER_ID + ')'					AS ATTR_03      --Model PIC   				
				-- , NULL								AS ATTR_04           
					 , DBO.FN_GET_SSP_MKT_OWNER_NAME (SI.OWNER, '', 'KO')	AS ATTR_04		--MTK_OWNER       
				/***************************************************************************************/
					 /* 20211102  SHINMYUNGSU  수정  ********************************************/
					 --, A.ORDER_TYPE_DETAIL				AS ORDER_TYPE_DETAIL
					 , ISNULL(LK.SEGMENT2, A.FCST_TYPE) AS ORDER_TYPE_DETAIL
					 /***************************************************************************/
				FROM [DBO].[SSP_ANL_SHIP_REQ_P] A WITH(NOLOCK)
				JOIN #TblDynamic_SSP0026_ShpimentReq B WITH(NOLOCK) ON A.DIVISION_ID		= B.DIVISION_ID
														--AND A.FROM_SITE		= B.FROM_SITE
														--AND A.TO_SITE			= B.TO_SITE
														AND A.SHIPTO_CODE		= B.SHIPTO_CODE
														AND A.ITEM_ID			= B.ITEM_ID
														--AND A.INCOTERMS			= B.INCOTERMS
														AND A.BOD_ID			= B.BOD_ID				
														--AND A.TRANSPORT_MODE	= B.TRANSPORT_MODE	
														--AND A.FCST_TYPE			= B.FCST_TYPE	
														AND A.YYYYMMDD			= B.YYYYMMDD
					/* 20211102  SHINMYUNGSU  추가 *****************************************************************************************/
						 LEFT OUTER JOIN (SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
 							FROM(																						
 								SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID									
 								  ,ROW_NUMBER() over(partition by DIVISION_ID, SCM_SITE_ID, ITEM_ID order by PROJECT_CODE) num	
 							FROM scm_mst_site_item																				
 						 ) a WHERE num = 1) g on g.DIVISION_ID =  B.DIVISION_ID and g.SCM_SITE_ID = B.TO_SITE and g.ITEM_ID = B.ITEM_ID	
						 LEFT OUTER JOIN SCM_MST_SITE_ITEM AS SI WITH(NOLOCK)
					  ON B.DIVISION_ID					= SI.DIVISION_ID
					 AND B.TO_SITE						= SI.SCM_SITE_ID
					 AND B.ITEM_ID						= SI.ITEM_ID
					 AND G.PROJECT_CODE					= SI.PROJECT_CODE
						 LEFT OUTER JOIN SSP_MST_MODEL_USER AS MU WITH(NOLOCK)
					  ON B.DIVISION_ID = MU.DIVISION_ID
					 AND B.FROM_SITE = MU.FROM_SITE
					 AND B.ITEM_ID = MU.ITEM_ID
					 AND MU.VALID_YN = 'Y'
						 LEFT OUTER JOIN TB_FX_User as U2 with(nolock) 
					  ON mu.user_id = u2.UserID 
	   				 AND U2.UseYN = 'Y'
						 LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL AS LK WITH(NOLOCK)
					  ON LK.LOOKUP_TYPE = 'SALES_TYPE_CODE'
					 AND LK.VALID_YN	= 'Y'
					 AND B.FCST_TYPE	= LK.SEGMENT1
					/*********************************************************************************************************************/
			) A								
			LEFT OUTER JOIN NERP_CONV_MASTER X1 WITH(NOLOCK) ON X1.CODETYPE = 'SCP_SITE_ID'	AND A.PACKER_CODE = X1.OLD_VALUE1
			

													;
			
			SET @v_cnt = 0;  -- 저장 후 초기화

		END
		-- UPDATE END


		-- INSERT START
		SELECT @v_cnt = COUNT(*)
		FROM #TblDynamic_SSP0026_ShpimentReq B WITH(NOLOCK)
		WHERE 1=1
		AND NOT EXISTS (SELECT 1 
						FROM [DBO].[SSP_ANL_SHIP_REQ_P] A WITH(NOLOCK)
						WHERE 1=1
						AND A.DIVISION_ID		= B.DIVISION_ID
						--AND A.FROM_SITE			= B.FROM_SITE
						--AND A.TO_SITE			= B.TO_SITE
						AND A.SHIPTO_CODE		= B.SHIPTO_CODE
						AND A.ITEM_ID			= B.ITEM_ID
						AND A.YYYYMMDD			= B.YYYYMMDD
						AND A.BOD_ID			= B.BOD_ID
						--AND A.FCST_TYPE			= B.FCST_TYPE
						)
	
     	IF @v_cnt > 0
		BEGIN
			--SET @v_req_id_seq = 'R'+ CONVERT(VARCHAR(8), GETDATE(), 112) + RIGHT('000000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_PACKER_REQ_ID),6);
			-- INSERT 대상 건 ACTIVE FLAG 변경
			UPDATE  A
			SET A.ACTIVE_FLAG = 'I'
			FROM #TblDynamic_SSP0026_ShpimentReq A
			WHERE  NOT EXISTS (SELECT 1 
							FROM [DBO].[SSP_ANL_SHIP_REQ_P] B WITH(NOLOCK)
							WHERE 1=1
							AND A.DIVISION_ID		= B.DIVISION_ID
							--AND A.FROM_SITE			= B.FROM_SITE
							--AND A.TO_SITE			= B.TO_SITE
							AND A.SHIPTO_CODE		= B.SHIPTO_CODE
							AND A.ITEM_ID			= B.ITEM_ID
							AND A.YYYYMMDD			= B.YYYYMMDD
							AND A.BOD_ID			= B.BOD_ID
							--AND A.FCST_TYPE			= B.FCST_TYPE
							)
			;

			-- 신규 REQEUST INSERT
			--DETAIL INSERT
			INSERT INTO [DBO].[SSP_ANL_SHIP_REQ_P]
			(
				 DIVISION_ID
				,ITEM_ID
				,SHIPTO_CODE
				,BOD_ID
				,YYYYMMDD
				,QTY
				,REQUEST_ID
				--,INCOTERMS
				--,TRANSPORT_MODE
				,FCST_TYPE
				,PROJECT_CODE
				,ORDER_TYPE_DETAIL
				,REMARK
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
			)
			SELECT 
				  B.DIVISION_ID	
				, B.ITEM_ID
				, B.SHIPTO_CODE            
				, B.BOD_ID
				, B.YYYYMMDD
				, B.QTY	
				, B.REQUEST_ID
				--, @v_req_id_seq AS REQUEST_ID
				--, 'R'+ CONVERT(VARCHAR(8), GETDATE(), 112) + RIGHT('000000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_PACKER_REQ_ID),6) AS REQUEST_ID
				--, B.YYYYMMDD +'001'   AS REQUEST_ID		
				, B.FCST_TYPE
				, C.SOLDTO_CUSTOMER
				, B.ORDER_TYPE_DETAIL
				, B.REMARK
				, @p_created_by		AS CREATED_BY
				, @d_event_date		AS CREATION_DATE
				, @p_created_by		AS LAST_UPDATED_BY
				, @d_event_date		AS LAST_UPDATE_DATE
			FROM #TblDynamic_SSP0026_ShpimentReq B WITH(NOLOCK)
			INNER JOIN SCM_MST_SITE C  WITH(NOLOCK)
				ON B.DIVISION_ID = C.DIVISION_ID 
				AND B.TO_SITE = C.SCM_SITE_ID
				AND C.VALID_YN = 'Y'
			WHERE 1=1
			AND B.ACTIVE_FLAG  ='I'
			AND NOT EXISTS (SELECT 1 
							FROM [DBO].[SSP_ANL_SHIP_REQ_P] A WITH(NOLOCK)
							WHERE 1=1
							AND A.DIVISION_ID		= B.DIVISION_ID
							--AND A.FROM_SITE			= B.FROM_SITE
							--AND A.TO_SITE			= B.TO_SITE
							AND A.SHIPTO_CODE		= B.SHIPTO_CODE
							AND A.ITEM_ID			= B.ITEM_ID
							AND A.YYYYMMDD			= B.YYYYMMDD
							AND A.BOD_ID			= B.BOD_ID
							--AND A.FCST_TYPE			= B.FCST_TYPE
							)
			;

			--*   2020.09.21      KIM BOK KI     HISTORY 추가
			--*   2021.11.03      SHIN MYUNG SU  수정 ( SSP_ANL_SHIP_PLAN_PACK_REQ_H -> SSP_ANL_SHIP_REQ_P_H 변경)
			INSERT INTO SSP_ANL_SHIP_REQ_P_H (
				   HISTORY_SEQ
				 , DIVISION_ID
				 --, MODEL_TYPE
				 --, MODEL_ID
				 --, FROM_SITE
				 --, TO_SITE
				 , SHIPTO_CODE
				 , YYYYMMDD
				 , BOD_ID
				 , QTY
				 , REQUEST_ID
				 , CONFIRM_ID
				 --, INCOTERMS
				 --, TRANSPORT_MODE
				 , FCST_TYPE
				 , PROJECT_CODE
				 , ORDER_TYPE_DETAIL
				 , REMARK
				 , CREATED_BY
				 , CREATION_DATE
				 , LAST_UPDATED_BY
				 , LAST_UPDATE_DATE
				 , ATTRIBUTE1
				 , ATTRIBUTE2
				 , ATTRIBUTE3
				 , ATTRIBUTE4
				 , ATTRIBUTE5
				 , ATTRIBUTE6
				 , ATTRIBUTE7
				 , ATTRIBUTE8
				 , ATTRIBUTE9
				 , ATTRIBUTE10
				 , ITEM_ID
				   )
			SELECT NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_PACKER_REQ_H   AS HISTORY_SEQ
				 , A.DIVISION_ID
				 --, '-'
				 --, A.ITEM_ID
				 --, V.FROM_SITE
				 --, V.TO_SITE
				 , A.SHIPTO_CODE
				 , A.YYYYMMDD
				 , A.BOD_ID
				 , A.QTY
				 , A.REQUEST_ID
				 , A.CONFIRM_ID
				 --, V.INCOTERMS
				 --, V.TRANSPORT_MODE
				 , A.FCST_TYPE
				 , C.SOLDTO_CUSTOMER
				 , A.ORDER_TYPE_DETAIL
				 , A.REMARK
				 , A.CREATED_BY
				 , A.CREATION_DATE
				 , A.LAST_UPDATED_BY
				 , A.LAST_UPDATE_DATE
				 , A.ATTRIBUTE1
				 , A.ATTRIBUTE2
				 , A.ATTRIBUTE3
				 , A.ATTRIBUTE4
				 , A.ATTRIBUTE5
				 , A.ATTRIBUTE6
				 , A.ATTRIBUTE7
				 , A.ATTRIBUTE8
				 , A.ATTRIBUTE9
				 , A.ATTRIBUTE10
				 , A.ITEM_ID
			FROM   [DBO].[SSP_ANL_SHIP_REQ_P]  A WITH(NOLOCK)

			JOIN SCP_MST_BOD_N_V   V WITH(NOLOCK)
				ON   A.DIVISION_ID = V.DIVISION_ID
				AND  A.BOD_ID      = V.BOD_ID
			
			INNER JOIN SCM_MST_SITE C  WITH(NOLOCK)
				ON A.DIVISION_ID = C.DIVISION_ID 
				AND V.TO_SITE = C.SCM_SITE_ID
				AND C.VALID_YN = 'Y'
			
			JOIN #TblDynamic_SSP0026_ShpimentReq B WITH(NOLOCK) 
				ON A.DIVISION_ID		= B.DIVISION_ID
				--AND A.FROM_SITE			= B.FROM_SITE
				--AND A.TO_SITE			= B.TO_SITE
				AND A.SHIPTO_CODE		= B.SHIPTO_CODE
				AND A.ITEM_ID			= B.ITEM_ID
				--AND A.INCOTERMS			= B.INCOTERMS
				AND A.BOD_ID			= B.BOD_ID				
				--AND A.TRANSPORT_MODE	= B.TRANSPORT_MODE	
				--AND A.FCST_TYPE			= B.FCST_TYPE
				AND A.YYYYMMDD			= B.YYYYMMDD
			WHERE  1 = 1
			;
			--INSERT INTO SSP_ANL_SHIP_PLAN_PACK_REQ_H (
			--	   HISTORY_SEQ
			--	 , DIVISION_ID
			--	 , MODEL_TYPE
			--	 , MODEL_ID
			--	 , FROM_SITE
			--	 , TO_SITE
			--	 , SHIPTO_CODE
			--	 , YYYYMMDD
			--	 , BOD_ID
			--	 , QTY
			--	 , REQUEST_ID
			--	 , CONFIRM_ID
			--	 , INCOTERMS
			--	 , TRANSPORT_MODE
			--	 , FCST_TYPE
			--	 , PROJECT_CODE
			--	 , ORDER_TYPE_DETAIL
			--	 , REMARK
			--	 , CREATED_BY
			--	 , CREATION_DATE
			--	 , LAST_UPDATED_BY
			--	 , LAST_UPDATE_DATE
			--	 , ATTRIBUTE1
			--	 , ATTRIBUTE2
			--	 , ATTRIBUTE3
			--	 , ATTRIBUTE4
			--	 , ATTRIBUTE5
			--	 , ATTRIBUTE6
			--	 , ATTRIBUTE7
			--	 , ATTRIBUTE8
			--	 , ATTRIBUTE9
			--	 , ATTRIBUTE10
			--	   )
			--SELECT NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_PACKER_REQ_H   AS HISTORY_SEQ
			--	 , A.DIVISION_ID
			--	 , '-'
			--	 , A.ITEM_ID
			--	 , V.FROM_SITE
			--	 , V.TO_SITE
			--	 , A.SHIPTO_CODE
			--	 , A.YYYYMMDD
			--	 , A.BOD_ID
			--	 , A.QTY
			--	 , A.REQUEST_ID
			--	 , A.CONFIRM_ID
			--	 , V.INCOTERMS
			--	 , V.TRANSPORT_MODE
			--	 , A.FCST_TYPE
			--	 , C.SOLDTO_CUSTOMER
			--	 , A.ORDER_TYPE_DETAIL
			--	 , A.REMARK
			--	 , A.CREATED_BY
			--	 , A.CREATION_DATE
			--	 , A.LAST_UPDATED_BY
			--	 , A.LAST_UPDATE_DATE
			--	 , A.ATTRIBUTE1
			--	 , A.ATTRIBUTE2
			--	 , A.ATTRIBUTE3
			--	 , A.ATTRIBUTE4
			--	 , A.ATTRIBUTE5
			--	 , A.ATTRIBUTE6
			--	 , A.ATTRIBUTE7
			--	 , A.ATTRIBUTE8
			--	 , A.ATTRIBUTE9
			--	 , A.ATTRIBUTE10
			--FROM   [DBO].[SSP_ANL_SHIP_REQ_P]  A WITH(NOLOCK)

			--JOIN SCP_MST_BOD_N_V   V WITH(NOLOCK)
			--	ON   A.DIVISION_ID = V.DIVISION_ID
			--	AND  A.BOD_ID      = V.BOD_ID
			
			--INNER JOIN SCM_MST_SITE C  WITH(NOLOCK)
			--	ON A.DIVISION_ID = C.DIVISION_ID 
			--	AND V.TO_SITE = C.SCM_SITE_ID
			--	AND C.VALID_YN = 'Y'
			
			--JOIN #TblDynamic_SSP0026_ShpimentReq B WITH(NOLOCK) 
			--	ON A.DIVISION_ID		= B.DIVISION_ID
			--	--AND A.FROM_SITE			= B.FROM_SITE
			--	--AND A.TO_SITE			= B.TO_SITE
			--	AND A.SHIPTO_CODE		= B.SHIPTO_CODE
			--	AND A.ITEM_ID			= B.ITEM_ID
			--	--AND A.INCOTERMS			= B.INCOTERMS
			--	AND A.BOD_ID			= B.BOD_ID				
			--	--AND A.TRANSPORT_MODE	= B.TRANSPORT_MODE	
			--	--AND A.FCST_TYPE			= B.FCST_TYPE
			--	AND A.YYYYMMDD			= B.YYYYMMDD
			--WHERE  1 = 1
			--;


			-- SCS I/F 정보 생성
			-- I/F 주체는 SCS 에서 함
			INSERT INTO XIF_SCS_PACK_SHIP_PLAN_S_SN (
				   IF_SEQ           
				 , IF_TYPE          
				 , IF_ID            
				 , IF_INS_DATE      
				 , IF_FLAG          
				 , PACKER_CODE      
				 , DIVISION_ID      
				 , PLAN_VERSION   
				 , PACK_MODEL_CODE  
				 , NICK_NAME 
				 , TARGET_ORDER
				 , SSP_CNFM
				 , SALES_SITE
				 , SHIP_TO
				 , SHIP_TO_NAME
				 , TRANSPORT_MODE
				 , INCOTERMS
				 , SHIP_PLAN_DATE 
				 , SHIP_PLAN_QTY 
				 , COMMENT
				 , ATTR_01           
				 , ATTR_02           
				 , ATTR_03           
				 , ATTR_04           
				 , ATTR_05           
				 , ATTR_06           
				 , ATTR_07           
				 , ATTR_08           
				 , ATTR_09           
				 , ATTR_10
				 , ORDER_TYPE_DETAIL
				 )
			SELECT
				 'OSCM' + CONVERT(VARCHAR,GETDATE(),12) + DBO.FN_ZERO_LPAD(CONVERT(VARCHAR,NEXT VALUE FOR DBO.SEQ1_XIF_SCS),10)  AS IF_SEQ
				, N'I'         AS IF_TYPE          
				, N'OSCM_OSCS_SCS_PACK_SHIP_PLAN'  AS IF_ID            
				, GETDATE()    AS IF_INS_DATE      
				, 'N'          AS IF_FLAG          
				, ISNULL(X1.NEW_VALUE1, A.PACKER_CODE)	AS PACKER_CODE       
				, A. DIVISION_ID      
				, @v_plan_start_yyyymmdd   AS PLAN_VERSION   
				, A.PACK_MODEL_CODE  
				, A.NICK_NAME 
				, N'O'          AS TARGET_ORDER
				, A.SSP_CNFM
				, A.SALES_SITE
				, A.SHIP_TO
				, A.SHIP_TO_NAME
				, A.TRANSPORT_MODE
				, A.INCOTERMS
				, A.SHIP_PLAN_DATE 
				, A.SHIP_PLAN_QTY 
				, A.COMMENT
				, A.ATTR_01           
				, NULL								AS ATTR_02           
				, A.ATTR_03      --Model PIC   				
				, A.ATTR_04		--MTK_OWNER       
				, NULL								AS ATTR_05           
				, NULL								AS ATTR_06           
				, NULL								AS ATTR_07           
				, NULL								AS ATTR_08           
				, NULL								AS ATTR_09           
				, NULL								AS ATTR_10
				, A.ORDER_TYPE_DETAIL
				/********************************************************************************************************************/
			FROM
			(
				SELECT B.FROM_SITE  AS PACKER_CODE      
					 , B.DIVISION_ID AS DIVISION_ID      
					 , B.ITEM_ID    AS PACK_MODEL_CODE  
					 , [dbo].[FN_GET_ITEM_NICKNAME](B.DIVISION_ID, B.ITEM_ID)  AS NICK_NAME 
					 , B.REQUEST_ID  AS SSP_CNFM
					 , B.TO_SITE     AS SALES_SITE
					 , B.SHIPTO_CODE AS SHIP_TO
					 , [dbo].[FN_GET_SITE_CUSTOMER_INFO](B.DIVISION_ID, B.TO_SITE,'SHIPTO_DESCRIPTION')	AS SHIP_TO_NAME
					 , B.TRANSPORT_MODE
					 , B.INCOTERMS
					 , B.YYYYMMDD    AS SHIP_PLAN_DATE 
					 , B.QTY         AS SHIP_PLAN_QTY 
					 , B.REMARK								AS COMMENT
					 , B.DIVISION_ID + '_' + @v_plan_start_yyyymmdd + '_' + @IF_GROUP_NO	AS ATTR_01           
					 , U2.UserName + '(' + MU.USER_ID + ')'					AS ATTR_03      --Model PIC   				
					 , DBO.FN_GET_SSP_MKT_OWNER_NAME (SI.OWNER, '', 'KO')	AS ATTR_04		--MTK_OWNER 
					 , ISNULL(LK.SEGMENT2, B.FCST_TYPE) AS ORDER_TYPE_DETAIL
					 /********************************************************************************************************************/
				FROM #TblDynamic_SSP0026_ShpimentReq B WITH(NOLOCK)
					/* 20211102  SMS  추가 *****************/
						 LEFT OUTER JOIN (SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
 							FROM(																						
 								SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID									
 								  ,ROW_NUMBER() over(partition by DIVISION_ID, SCM_SITE_ID, ITEM_ID order by PROJECT_CODE) num	
 							FROM scm_mst_site_item																				
 						 ) a WHERE num = 1) g on g.DIVISION_ID =  B.DIVISION_ID and g.SCM_SITE_ID = B.TO_SITE and g.ITEM_ID = B.ITEM_ID	
						 LEFT OUTER JOIN SCM_MST_SITE_ITEM AS SI WITH(NOLOCK)
					  ON B.DIVISION_ID					= SI.DIVISION_ID
					 AND B.TO_SITE						= SI.SCM_SITE_ID
					 AND B.ITEM_ID						= SI.ITEM_ID
					 AND G.PROJECT_CODE					= SI.PROJECT_CODE
						 LEFT OUTER JOIN SSP_MST_MODEL_USER AS MU WITH(NOLOCK)
					  ON B.DIVISION_ID = MU.DIVISION_ID
					 AND B.FROM_SITE = MU.FROM_SITE
					 AND B.ITEM_ID = MU.ITEM_ID
					 AND MU.VALID_YN = 'Y'
						 LEFT OUTER JOIN TB_FX_User as U2 with(nolock) 
					  ON mu.user_id = u2.UserID 
	   				 AND U2.UseYN = 'Y'
						 LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL AS LK WITH(NOLOCK)
					  ON LK.LOOKUP_TYPE = 'SALES_TYPE_CODE'
					 AND LK.VALID_YN	= 'Y'
					 AND B.FCST_TYPE	= LK.SEGMENT1
					/*******************************************************************************************************************/
				WHERE 1=1
				AND B.ACTIVE_FLAG = 'I'
				--AND NOT EXISTS (SELECT 1 
				--				FROM SSP_ANL_SHIP_PLAN_PACK_REQ A WITH(NOLOCK)
				--				WHERE 1=1
				--				AND A.DIVISION_ID		= B.DIVISION_ID
				--				AND A.FROM_SITE			= B.FROM_SITE
				--				AND A.TO_SITE			= B.TO_SITE
				--				AND A.MODEL_ID			= B.MODEL_ID
				--				AND A.YYYYMMDD			= B.YYYYMMDD
				--				AND A.BOD_ID			= B.BOD_ID)
			) A
			LEFT OUTER JOIN NERP_CONV_MASTER X1 WITH(NOLOCK) ON X1.CODETYPE = 'SCP_SITE_ID'	AND A.PACKER_CODE = X1.OLD_VALUE1
			;

			SET @v_cnt = 0;  -- 저장 후 초기화
		END

		
		SELECT 'S' AS RESULT_CODE, '' AS MSG;
        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------
        IF @@TRANCOUNT > 0
	    BEGIN
			COMMIT TRAN TX_SH;
         END;       

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
		IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK TRAN TX_SH
			END;
      
		---- ERROR LOG
		--SET @v_log_type = N'ERROR';
		--SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		--SET @v_description = @v_program_name + N'ERROR_LINE : ' + STR(ERROR_LINE());
		--SET @d_event_date = SYSDATETIME();
		--EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
		--						,@p_log_type      =@v_log_type
		--						,@p_log_count     =@n_log_count 
		--						,@p_log_message   =@v_log_message 
		--						,@p_description   =@v_description 
		--						,@p_event_date    =@d_event_date 
		--						,@p_user_id       =@v_batch_user
		--						;
		--return -1

		IF ERROR_NUMBER() != 60001  AND ERROR_NUMBER() != 60002
		BEGIN
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

		END


		IF ERROR_NUMBER() = 60001  
		BEGIN
			SELECT 'X' AS result_code, NULL AS Request_no;

			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			return -1

		END


		IF ERROR_NUMBER() = 60002  
		BEGIN
			SELECT 'Y' AS result_code, CONVERT(CHAR(10),CONVERT(DATETIME, @v_confirm_day,112),23)  AS ConfirmDay;

			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			return -1

		END




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
   
    return 1  

  END; 
