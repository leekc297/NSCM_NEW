
/**=========================================================================================================================================================
 * Program ID   : SSP0026_SAVE_SHIP_REQ_PACK
 * Description  : PACKER 재고 PSI 정보 재 생성 
 * OutTable     :
 * Execute      : SSP0026 'SAVE' 클릭 시 PLAN REQ 정보 저장 후 실행 (신규)
 * Program History
 *=========================================================================================================================================================
 *   Date            In Charge      Description
 *   2020.10.07      KIMYONGHO		신규추가
 *   2021/09/02		 KIMYONGHO      SCP_MST_BOD_N_V 조회 로직 추가
 *   2021/11/03      SHINMYUNGSU    XIF_SCS_PACK_SHIP_PLAN_S 입력값수정, SSP_ANL_SHIP_PLAN_PACK_REQ_H -> SSP_ANL_SHIP_REQ_P_H 변경
 *   2024/10/01      KHJ            NERP_SSP
 *=========================================================================================================================================================
 	<MEASURE>  
	--PACK_FP(Pack FP)           : SCM_DNM_SCS_PROD_PLAN 의 정보기준 생산계획을 생성
	TOTAL_PLAN(Total)            : SSP_ANL_SHIP_PLAN_PACKER 의 MEASURE   = 'SCP_SHIP_PLAN' 기준
	TOTAL_REQ(Total)             : SSP_ANL_SHIP_PLAN_PACKER 의 MEASURE   = 'SHIP_REQ' 기준
	WH_BOH_PLAN(W/H BOH(Plan))   : SSP_ANL_SHIP_PLAN_PACKER 의 MEASURE   = 'TOTAL_PLAN' & 'PACK_FP' 인 정보기준 출하 REQUEST 을 생성
	WH_BOH_REQ(W/H BOH(Req))     : SSP_ANL_SHIP_PLAN_PACKER 의 MEASURE   = 'TOTAL_REQ' & 'PACK_FP' 인 정보기준 출하 REQUEST 을 생성
*=========================================================================================================================================================
*========================================================================================================================================================= */

CREATE PROCEDURE [dbo].[SSP0026_SAVE_SHIP_REQ_PACK]
( 
      @p_active_flag		NVARCHAR(MAX)
	,@p_division_id			NVARCHAR(MAX)
	,@p_item_id				NVARCHAR(MAX)
	,@p_from_site			NVARCHAR(MAX)
	,@p_to_site				NVARCHAR(MAX)
	,@p_project_code		NVARCHAR(MAX)
	,@p_incoterms			NVARCHAR(MAX)
	,@p_fcst_type			NVARCHAR(MAX)
	,@p_transport_mode		NVARCHAR(MAX)
	,@p_bod_id				NVARCHAR(MAX)
	,@p_measure 			NVARCHAR(MAX)
	,@p_yyyymmdd			NVARCHAR(MAX)
	,@p_qty					NVARCHAR(MAX)
--	,@p_order_type_detail	NVARCHAR(MAX)
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
		,MODEL_ID					NVARCHAR(50)
		,FROM_SITE				NVARCHAR(50)
		,TO_SITE					NVARCHAR(30)
		,PROJECT_CODE				NVARCHAR(30)
		,INCOTERMS				NVARCHAR(10)
		,FCST_TYPE				NVARCHAR(10)
		,TRANSPORT_MODE			NVARCHAR(10)
		,BOD_ID					NVARCHAR(150)
		,MEASURE					NVARCHAR(50)
		,YYYYMMDD					NVARCHAR(8)
		,QTY						NVARCHAR(30)
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
	DECLARE @v_project_code 		NVARCHAR(10);
	DECLARE @v_incoterms		NVARCHAR(10);
	DECLARE @v_fcst_type		NVARCHAR(10);
	DECLARE @v_transport_mode	NVARCHAR(10);
	DECLARE @v_bod_id			NVARCHAR(30);
	DECLARE @v_measure			NVARCHAR(50);
	DECLARE @v_yyyymmdd			NVARCHAR(8);
	DECLARE @v_qty				NVARCHAR(30);
	DECLARE @v_request_id	    NVARCHAR(MAX);

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
	SET @v_project_code = NULL;
	SET @v_incoterms = NULL;
	SET @v_fcst_type = NULL;
	SET @v_transport_mode = NULL;
	SET @v_bod_id = NULL;
	SET @v_measure = NULL;
	SET @v_yyyymmdd = NULL;
	SET @v_qty = NULL;
	SET @v_request_id = NULL;
	SET @v_cnt = 0;




    -- LOG 용 변수 설정
	DECLARE @v_program_name NVARCHAR(150) = N'SSP0026_SAVE_SHIP_REQ_PACK';
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


    -- 데이터 생성 실행부
    BEGIN TRY
       -- BEGIN TRAN TX_SH

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
				SET @v_yyyymmdd			= [dbo].[SCM_ARR_SPL_VAL](@p_yyyymmdd,			@v_delimiter, @mst_loop_cnt);
				SET @v_qty				= [dbo].[SCM_ARR_SPL_VAL](@p_qty,				@v_delimiter, @mst_loop_cnt);
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


				--print @v_division_id_temp			  ;
				--print @v_new_bod_id_temp			  ;
				--print @v_from_site_temp				  ;
				--print @v_to_site_temp				  ;
				--print @v_new_incoterms_temp			  ;
				--print @v_new_transport_mode_temp	  ;
				--print @v_new_route_id_temp			  ;
				--print @v_new_d_contry_temp			  ;
				--print @v_new_d_port_code_temp		  ;
				--print @v_new_a_country_temp			  ;
				--print @v_new_a_port_code_temp		  ;
				--print @v_new_customer_lt_temp		  ;
				--print @v_new_to_country_temp		  ;
				--print @v_new_to_city_temp			  ;


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
			SELECT @v_active_flag			AS ACTIVE_FLAG
					, @v_division_id		AS DIVISION_ID
					, @v_item_id			AS MODEL_ID
					, @v_from_site			AS FROM_SITE
					, @v_to_site			AS TO_SITE
					, @v_project_code		AS PROJECT_CODE
					, @v_new_incoterms_temp	AS INCOTERMS
					, @v_fcst_type			AS FCST_TYPE
					, @v_new_transport_mode_temp	AS TRANSPORT_MODE
					, @v_new_bod_id_temp	AS BOD_ID
					, @v_measure			AS MEASURE
					, @v_yyyymmdd			AS YYYYMMDD
					, @v_qty				AS QTY
					, 'R'+ CONVERT(VARCHAR(8), GETDATE(), 112) + RIGHT('000000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_PACKER_REQ_ID),6) AS REQUEST_ID
			;

		END


		SELECT  @v_cnt = COUNT(*)  
		FROM #TblDynamic_SSP0026_ShpimentReq;

		IF @v_cnt > 0 
		BEGIN

			--SET @v_request_id = 'R'+ CONVERT(VARCHAR(8), GETDATE(), 112) + RIGHT('000000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_PACKER_REQ_ID),6);

			SET @d_event_date = SYSDATETIME();
			-- 수정
			-- 삭제기능은 없으므로 Active Flag는 'I' 또는 'M'으로 가정하고 입력/수정만 진행
			--UPDATE A
			--SET A.QTY = B.QTY
			--	 --, A.REQUEST_ID = ISNULL(A.REQUEST_ID, 'R'+ CONVERT(VARCHAR(8), GETDATE(), 112) + RIGHT('000000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_PACKER_REQ_ID),6))
			--	, A.LAST_UPDATED_BY	= @p_created_by
			--	, A.LAST_UPDATE_DATE = @d_event_date
			--	--, A.ATTRIBUTE1 = N'Y'
			--FROM SSP_ANL_SHIP_PLAN_PACKER A WITH(NOLOCK)
			--JOIN #TblDynamic_SSP0026_ShpimentReq B WITH(NOLOCK) 
			--	ON A.DIVISION_ID		= B.DIVISION_ID
			--	AND A.FROM_SITE			= B.FROM_SITE
			--	AND A.TO_SITE			= B.TO_SITE
			--	AND A.PROJECT_CODE		= B.PROJECT_CODE
			--	AND A.MODEL_ID			= B.MODEL_ID
			--	AND A.INCOTERMS			= B.INCOTERMS
			--	AND A.BOD_ID			= B.BOD_ID			
			--	AND A.FCST_TYPE			= B.FCST_TYPE			
			--	AND A.TRANSPORT_MODE	= B.TRANSPORT_MODE	
			--	AND A.MEASURE			= B.MEASURE
			--	AND A.YYYYMMDD			= B.YYYYMMDD
			--;



			UPDATE A
			SET A.QTY = B.QTY
				--, A.REQUEST_ID		 = CASE WHEN A.REQUEST_ID IS NULL THEN @v_request_id ELSE A.REQUEST_ID END
				, A.REQUEST_ID		 = CASE WHEN A.REQUEST_ID IS NULL THEN B.REQUEST_ID ELSE A.REQUEST_ID END
				, A.LAST_UPDATED_BY	 = @p_created_by
				, A.LAST_UPDATE_DATE = @d_event_date
				--, A.ATTRIBUTE1 = N'Y'
			FROM SSP_ANL_SHIP_PLAN_PACK_REQ A WITH(NOLOCK)
			JOIN #TblDynamic_SSP0026_ShpimentReq B WITH(NOLOCK) 
				ON A.DIVISION_ID		= B.DIVISION_ID
				AND A.FROM_SITE			= B.FROM_SITE
				AND A.TO_SITE			= B.TO_SITE
				AND A.MODEL_ID			= B.MODEL_ID
				AND A.INCOTERMS			= B.INCOTERMS
				AND A.BOD_ID			= B.BOD_ID			
				AND A.TRANSPORT_MODE	= B.TRANSPORT_MODE	
				AND A.YYYYMMDD			= B.YYYYMMDD
				--AND ISNULL(A.FCST_TYPE,'-')			= B.FCST_TYPE
				AND A.SHIPTO_CODE		= (SELECT SHIPTO_CODE 
											FROM SCM_MST_SITE_CUSTOMER
											WHERE DIVISION_ID = B.DIVISION_ID
												AND SCM_SITE_ID = B.TO_SITE
												AND VALID_YN = 'Y'
												AND REP_YN   = 'Y')
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
			SELECT  NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_PACKER_REQ_H   AS HISTORY_SEQ
				 , A.DIVISION_ID
				 --, A.MODEL_TYPE
				 --, A.MODEL_ID
				 --, A.FROM_SITE
				 --, A.TO_SITE
				 , A.SHIPTO_CODE
				 , A.YYYYMMDD
				 , A.BOD_ID
				 , A.QTY
				 , A.REQUEST_ID
				 , A.CONFIRM_ID
				 --, A.INCOTERMS
				 --, A.TRANSPORT_MODE
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
				 , B.MODEL_ID
			FROM   SSP_ANL_SHIP_PLAN_PACK_REQ  A WITH(NOLOCK)
			JOIN #TblDynamic_SSP0026_ShpimentReq B WITH(NOLOCK) 
				ON A.DIVISION_ID		= B.DIVISION_ID
				AND A.FROM_SITE			= B.FROM_SITE
				AND A.TO_SITE			= B.TO_SITE
				AND A.SHIPTO_CODE		= [dbo].[FN_GET_SITE_CUSTOMER_INFO](B.DIVISION_ID, B.TO_SITE,'SHIPTO_CODE')	
				AND A.MODEL_ID			= B.MODEL_ID
				AND A.INCOTERMS			= B.INCOTERMS
				AND A.BOD_ID			= B.BOD_ID				
				AND A.TRANSPORT_MODE	= B.TRANSPORT_MODE	
				--AND ISNULL(A.FCST_TYPE,'-')			= B.FCST_TYPE
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
			--SELECT  NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_PACKER_REQ_H   AS HISTORY_SEQ
			--	 , A.DIVISION_ID
			--	 , A.MODEL_TYPE
			--	 , A.MODEL_ID
			--	 , A.FROM_SITE
			--	 , A.TO_SITE
			--	 , A.SHIPTO_CODE
			--	 , A.YYYYMMDD
			--	 , A.BOD_ID
			--	 , A.QTY
			--	 , A.REQUEST_ID
			--	 , A.CONFIRM_ID
			--	 , A.INCOTERMS
			--	 , A.TRANSPORT_MODE
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
			--FROM   SSP_ANL_SHIP_PLAN_PACK_REQ  A WITH(NOLOCK)
			--JOIN #TblDynamic_SSP0026_ShpimentReq B WITH(NOLOCK) 
			--	ON A.DIVISION_ID		= B.DIVISION_ID
			--	AND A.FROM_SITE			= B.FROM_SITE
			--	AND A.TO_SITE			= B.TO_SITE
			--	AND A.SHIPTO_CODE		= [dbo].[FN_GET_SITE_CUSTOMER_INFO](B.DIVISION_ID, B.TO_SITE,'SHIPTO_CODE')	
			--	AND A.MODEL_ID			= B.MODEL_ID
			--	AND A.INCOTERMS			= B.INCOTERMS
			--	AND A.BOD_ID			= B.BOD_ID				
			--	AND A.TRANSPORT_MODE	= B.TRANSPORT_MODE	
			--	--AND ISNULL(A.FCST_TYPE,'-')			= B.FCST_TYPE
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
				, ISNULL(X1.NEW_VALUE1, A.PACKER_CODE)		AS PACKER_CODE       
				, A.DIVISION_ID      
				, @v_plan_start_yyyymmdd   AS PLAN_VERSION   
				, A.PACK_MODEL_CODE  
				, A.NICK_NAME 
				, N'O'          AS TARGET_ORDER
				, N'-' AS SSP_CNFM
				, A.SALES_SITE
				, A.SHIP_TO
				, A.SHIP_TO_NAME
				, A.TRANSPORT_MODE
				, A.INCOTERMS
				, A.SHIP_PLAN_DATE 
				, A.SHIP_PLAN_QTY 
				, NULL								AS COMMENT
				, A.ATTR_01           
				, NULL								AS ATTR_02           
			/* 20211102  SHINMYUNGSU  수정  ****************************************************/
				--, NULL								AS ATTR_03    
				, A.ATTR_03      --Model PIC   				
				--, NULL								AS ATTR_04           
				, A.ATTR_04		--MTK_OWNER       
			/***********************************************************************************/
				, NULL								AS ATTR_05           
				, NULL								AS ATTR_06           
				, NULL								AS ATTR_07           
				, NULL								AS ATTR_08           
				, NULL								AS ATTR_09           
				--, A.REQUEST_ID						AS ATTR_10
				, A.ATTR_10
				/* 20211102  SHINMYUNGSU  수정  ********************************************/
				--, A.ORDER_TYPE_DETAIL				AS ORDER_TYPE_DETAIL
				, A.ORDER_TYPE_DETAIL
				/***************************************************************************/
			FROM
			(
				SELECT A.FROM_SITE  AS PACKER_CODE      
					 , A.DIVISION_ID AS DIVISION_ID      
					 , A.MODEL_ID    AS PACK_MODEL_CODE  
					 , [dbo].[FN_GET_ITEM_NICKNAME](A.DIVISION_ID, A.MODEL_ID)  AS NICK_NAME 
					 , A.TO_SITE     AS SALES_SITE
					 , [dbo].[FN_GET_SITE_CUSTOMER_INFO](A.DIVISION_ID, A.TO_SITE,'SHIPTO_CODE')	AS SHIP_TO
					 , [dbo].[FN_GET_SITE_CUSTOMER_INFO](A.DIVISION_ID, A.TO_SITE,'SHIPTO_DESCRIPTION')	AS SHIP_TO_NAME
					 , A.TRANSPORT_MODE
					 , A.INCOTERMS
					 , A.YYYYMMDD    AS SHIP_PLAN_DATE 
					 , B.QTY         AS SHIP_PLAN_QTY 
					 , NULL								AS COMMENT
					 , A.DIVISION_ID + '_' + @v_plan_start_yyyymmdd + '_' + @IF_GROUP_NO	AS ATTR_01           
					/* 20211102  SHINMYUNGSU  수정  ****************************************************/
					 --, NULL								AS ATTR_03    
					 , U2.UserName + '(' + MU.USER_ID + ')'					AS ATTR_03      --Model PIC   				
					 --, NULL								AS ATTR_04           
					 , DBO.FN_GET_SSP_MKT_OWNER_NAME (SI.OWNER, '', 'KO')	AS ATTR_04		--MTK_OWNER       
					/***********************************************************************************/
					 --, A.REQUEST_ID						AS ATTR_10
					 , B.REQUEST_ID						AS ATTR_10
					 /* 20211102  SHINMYUNGSU  수정  ********************************************/
					 --, A.ORDER_TYPE_DETAIL				AS ORDER_TYPE_DETAIL
					 , ISNULL(LK.SEGMENT2, A.FCST_TYPE) AS ORDER_TYPE_DETAIL
					 /***************************************************************************/
				FROM SSP_ANL_SHIP_PLAN_PACK_REQ A WITH(NOLOCK)
				JOIN #TblDynamic_SSP0026_ShpimentReq B WITH(NOLOCK) 
					ON A.DIVISION_ID		= B.DIVISION_ID
					AND A.FROM_SITE			= B.FROM_SITE
					AND A.TO_SITE			= B.TO_SITE
					AND A.MODEL_ID			= B.MODEL_ID
					AND A.INCOTERMS			= B.INCOTERMS
					AND A.BOD_ID			= B.BOD_ID			
					AND A.TRANSPORT_MODE	= B.TRANSPORT_MODE	
					--AND ISNULL(A.FCST_TYPE,'-')			= B.FCST_TYPE
					AND A.YYYYMMDD			= B.YYYYMMDD
					AND A.SHIPTO_CODE		= (SELECT SHIPTO_CODE 
												FROM SCM_MST_SITE_CUSTOMER
												WHERE DIVISION_ID = B.DIVISION_ID
													AND SCM_SITE_ID = B.TO_SITE
													AND VALID_YN = 'Y'
													AND REP_YN   = 'Y')
					/* 20211102  SHINMYUNGSU  추가 **************************************************************************************/
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
			) A
			LEFT OUTER JOIN NERP_CONV_MASTER X1 WITH(NOLOCK) ON X1.CODETYPE = 'SCP_SITE_ID'	AND A.PACKER_CODE = X1.OLD_VALUE1
			;


				/*********************************************************************************************************************/
			--INSERT INTO XIF_SCS_PACK_SHIP_PLAN_S_SN (
			--	   IF_SEQ           
			--	 , IF_TYPE          
			--	 , IF_ID            
			--	 , IF_INS_DATE      
			--	 , IF_FLAG          
			--	 , PACKER_CODE      
			--	 , DIVISION_ID      
			--	 , PLAN_VERSION   
			--	 , PACK_MODEL_CODE  
			--	 , NICK_NAME 
			--	 , TARGET_ORDER
			--	 , SSP_CNFM
			--	 , SALES_SITE
			--	 , SHIP_TO
			--	 , SHIP_TO_NAME
			--	 , TRANSPORT_MODE
			--	 , INCOTERMS
			--	 , SHIP_PLAN_DATE 
			--	 , SHIP_PLAN_QTY 
			--	 , COMMENT
			--	 , ATTR_01           
			--	 , ATTR_02           
			--	 , ATTR_03           
			--	 , ATTR_04           
			--	 , ATTR_05           
			--	 , ATTR_06           
			--	 , ATTR_07           
			--	 , ATTR_08           
			--	 , ATTR_09           
			--	 , ATTR_10
			--	 , ORDER_TYPE_DETAIL
			--	 )
			--SELECT 'OSCM' + CONVERT(VARCHAR,GETDATE(),12) + DBO.FN_ZERO_LPAD(CONVERT(VARCHAR,NEXT VALUE FOR DBO.SEQ1_XIF_SCS),10)  AS IF_SEQ
			--     , N'I'         AS IF_TYPE          
			--	 , N'OSCM_OSCS_SCS_PACK_SHIP_PLAN'  AS IF_ID            
			--	 , GETDATE()    AS IF_INS_DATE      
			--	 , 'N'          AS IF_FLAG          
			--	 , A.FROM_SITE  AS PACKER_CODE      
			--	 , A.DIVISION_ID AS DIVISION_ID      
			--	 , @v_plan_start_yyyymmdd   AS PLAN_VERSION   
			--	 , A.MODEL_ID    AS PACK_MODEL_CODE  
			--	 , [dbo].[FN_GET_ITEM_NICKNAME](A.DIVISION_ID, A.MODEL_ID)  AS NICK_NAME 
			--	 , N'O'          AS TARGET_ORDER
			--	 , N'-' AS SSP_CNFM
			--	 , A.TO_SITE     AS SALES_SITE
			--	 , [dbo].[FN_GET_SITE_CUSTOMER_INFO](A.DIVISION_ID, A.TO_SITE,'SHIPTO_CODE')	AS SHIP_TO
			--	 , [dbo].[FN_GET_SITE_CUSTOMER_INFO](A.DIVISION_ID, A.TO_SITE,'SHIPTO_DESCRIPTION')	AS SHIP_TO_NAME
			--	 , A.TRANSPORT_MODE
			--	 , A.INCOTERMS
			--	 , A.YYYYMMDD    AS SHIP_PLAN_DATE 
			--	 , B.QTY         AS SHIP_PLAN_QTY 
			--	 , NULL								AS COMMENT
			--	 , A.DIVISION_ID + '_' + @v_plan_start_yyyymmdd + '_' + @IF_GROUP_NO	AS ATTR_01           
			--	 , NULL								AS ATTR_02           
			--	 , NULL								AS ATTR_03           
			--	 , NULL								AS ATTR_04           
			--	 , NULL								AS ATTR_05           
			--	 , NULL								AS ATTR_06           
			--	 , NULL								AS ATTR_07           
			--	 , NULL								AS ATTR_08           
			--	 , NULL								AS ATTR_09           
			--	 --, A.REQUEST_ID						AS ATTR_10
			--	 , B.REQUEST_ID						AS ATTR_10
			--	 , A.ORDER_TYPE_DETAIL				AS ORDER_TYPE_DETAIL
			--FROM SSP_ANL_SHIP_PLAN_PACK_REQ A WITH(NOLOCK)
			--JOIN #TblDynamic_SSP0026_ShpimentReq B WITH(NOLOCK) 
			--	ON A.DIVISION_ID		= B.DIVISION_ID
			--	AND A.FROM_SITE			= B.FROM_SITE
			--	AND A.TO_SITE			= B.TO_SITE
			--	AND A.MODEL_ID			= B.MODEL_ID
			--	AND A.INCOTERMS			= B.INCOTERMS
			--	AND A.BOD_ID			= B.BOD_ID			
			--	AND A.TRANSPORT_MODE	= B.TRANSPORT_MODE	
			--	--AND ISNULL(A.FCST_TYPE,'-')			= B.FCST_TYPE
			--	AND A.YYYYMMDD			= B.YYYYMMDD
			--	AND A.SHIPTO_CODE		= (SELECT SHIPTO_CODE 
			--								FROM SCM_MST_SITE_CUSTOMER
			--								WHERE DIVISION_ID = B.DIVISION_ID
			--									AND SCM_SITE_ID = B.TO_SITE
			--									AND VALID_YN = 'Y'
			--									AND REP_YN   = 'Y')

			SET @v_cnt = 0;  -- 저장 후 초기화
		END
		-- UPDATE END

		-- INSERT START
		SELECT @v_cnt = COUNT(*)
		FROM #TblDynamic_SSP0026_ShpimentReq B WITH(NOLOCK)
		WHERE 1=1
		AND NOT EXISTS (SELECT 1 
						FROM SSP_ANL_SHIP_PLAN_PACK_REQ A WITH(NOLOCK)
						WHERE 1=1
						AND A.DIVISION_ID		= B.DIVISION_ID
						AND A.FROM_SITE			= B.FROM_SITE
						AND A.TO_SITE			= B.TO_SITE
						AND A.MODEL_ID			= B.MODEL_ID
						AND A.YYYYMMDD			= B.YYYYMMDD
						AND A.BOD_ID			= B.BOD_ID
						--AND ISNULL(A.FCST_TYPE,'-')			= B.FCST_TYPE
						)
	
     	IF @v_cnt > 0
		BEGIN

			--SET @v_request_id = 'R'+ CONVERT(VARCHAR(8), GETDATE(), 112) + RIGHT('000000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_PACKER_REQ_ID),6);

			-- INSERT 대상 건 ACTIVE FLAG 변경
			UPDATE  A
			SET A.ACTIVE_FLAG = 'I'
			FROM #TblDynamic_SSP0026_ShpimentReq A
			WHERE  NOT EXISTS (SELECT 1 
							FROM SSP_ANL_SHIP_PLAN_PACK_REQ B WITH(NOLOCK)
							WHERE 1=1
							AND A.DIVISION_ID		= B.DIVISION_ID
							AND A.FROM_SITE			= B.FROM_SITE
							AND A.TO_SITE			= B.TO_SITE
							AND A.MODEL_ID			= B.MODEL_ID
							AND A.YYYYMMDD			= B.YYYYMMDD
							AND A.BOD_ID			= B.BOD_ID
							--AND ISNULL(A.FCST_TYPE,'-')			= B.FCST_TYPE
							)
			;


			-- 신규 REQEUST INSERT
			--DETAIL INSERT
			INSERT INTO SSP_ANL_SHIP_PLAN_PACK_REQ
			(
				 DIVISION_ID
				,MODEL_TYPE
				,FROM_SITE
				,TO_SITE
				,MODEL_ID
				,SHIPTO_CODE
				,BOD_ID
				,YYYYMMDD
				,QTY
				,REQUEST_ID
				,INCOTERMS
				,TRANSPORT_MODE
				,ORDER_TYPE_DETAIL
				,REMARK
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
			)
			SELECT 
				  B.DIVISION_ID
				, '-'
				, B.FROM_SITE
				, B.TO_SITE
				, B.MODEL_ID
				, [dbo].[FN_GET_SITE_CUSTOMER_INFO](B.DIVISION_ID, B.TO_SITE,'SHIPTO_CODE')	AS SHIP_TO
				, B.BOD_ID
				, B.YYYYMMDD
				, B.QTY	
				, B.REQUEST_ID
				--, @v_request_id	AS REQUEST_ID
				--, 'R'+ CONVERT(VARCHAR(8), GETDATE(), 112) + RIGHT('000000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_PACKER_REQ_ID),6) AS REQUEST_ID
				--, B.YYYYMMDD +'001'   AS REQUEST_ID
				, B.INCOTERMS
				, B.TRANSPORT_MODE
				, '-'               AS ORDER_TYPE_DETAIL
				--, B.ORDER_TYPE_DETAIL
				, '-'               AS REMARK
				, @p_created_by		AS CREATED_BY
				, @d_event_date		AS CREATION_DATE
				, @p_created_by		AS LAST_UPDATED_BY
				, @d_event_date		AS LAST_UPDATE_DATE
			FROM #TblDynamic_SSP0026_ShpimentReq B WITH(NOLOCK)
			WHERE 1=1
			AND NOT EXISTS (SELECT 1 
							FROM SSP_ANL_SHIP_PLAN_PACK_REQ A WITH(NOLOCK)
							WHERE 1=1
							AND A.DIVISION_ID		= B.DIVISION_ID
							AND A.FROM_SITE			= B.FROM_SITE
							AND A.TO_SITE			= B.TO_SITE
							AND A.SHIPTO_CODE		= [dbo].[FN_GET_SITE_CUSTOMER_INFO](B.DIVISION_ID, B.TO_SITE,'SHIPTO_CODE')
							AND A.MODEL_ID			= B.MODEL_ID
							AND A.YYYYMMDD			= B.YYYYMMDD
							AND A.BOD_ID			= B.BOD_ID
							--AND ISNULL(A.FCST_TYPE,'-')			= B.FCST_TYPE
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
				 --, A.MODEL_TYPE
				 --, A.MODEL_ID
				 --, A.FROM_SITE
				 --, A.TO_SITE
				 , A.SHIPTO_CODE
				 , A.YYYYMMDD
				 , A.BOD_ID
				 , A.QTY
				 , A.REQUEST_ID
				 , A.CONFIRM_ID
				 --, A.INCOTERMS
				 --, A.TRANSPORT_MODE
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
				 , B.MODEL_ID
			FROM   SSP_ANL_SHIP_PLAN_PACK_REQ  A WITH(NOLOCK)
			JOIN #TblDynamic_SSP0026_ShpimentReq B WITH(NOLOCK) 
				ON A.DIVISION_ID		= B.DIVISION_ID
				AND A.FROM_SITE			= B.FROM_SITE
				AND A.TO_SITE			= B.TO_SITE
				AND A.SHIPTO_CODE		= [dbo].[FN_GET_SITE_CUSTOMER_INFO](B.DIVISION_ID, B.TO_SITE,'SHIPTO_CODE')	
				AND A.MODEL_ID			= B.MODEL_ID
				AND A.INCOTERMS			= B.INCOTERMS
				AND A.BOD_ID			= B.BOD_ID				
				AND A.TRANSPORT_MODE	= B.TRANSPORT_MODE	
				AND A.YYYYMMDD			= B.YYYYMMDD
				--AND ISNULL(A.FCST_TYPE,'-')			= B.FCST_TYPE
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
			--	 , A.MODEL_TYPE
			--	 , A.MODEL_ID
			--	 , A.FROM_SITE
			--	 , A.TO_SITE
			--	 , A.SHIPTO_CODE
			--	 , A.YYYYMMDD
			--	 , A.BOD_ID
			--	 , A.QTY
			--	 , A.REQUEST_ID
			--	 , A.CONFIRM_ID
			--	 , A.INCOTERMS
			--	 , A.TRANSPORT_MODE
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
			--FROM   SSP_ANL_SHIP_PLAN_PACK_REQ  A WITH(NOLOCK)
			--JOIN #TblDynamic_SSP0026_ShpimentReq B WITH(NOLOCK) 
			--	ON A.DIVISION_ID		= B.DIVISION_ID
			--	AND A.FROM_SITE			= B.FROM_SITE
			--	AND A.TO_SITE			= B.TO_SITE
			--	AND A.SHIPTO_CODE		= [dbo].[FN_GET_SITE_CUSTOMER_INFO](B.DIVISION_ID, B.TO_SITE,'SHIPTO_CODE')	
			--	AND A.MODEL_ID			= B.MODEL_ID
			--	AND A.INCOTERMS			= B.INCOTERMS
			--	AND A.BOD_ID			= B.BOD_ID				
			--	AND A.TRANSPORT_MODE	= B.TRANSPORT_MODE	
			--	AND A.YYYYMMDD			= B.YYYYMMDD
			--	--AND ISNULL(A.FCST_TYPE,'-')			= B.FCST_TYPE
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
					, N'-' AS SSP_CNFM
					, A.SALES_SITE
					, A.SHIP_TO
					, A.SHIP_TO_NAME
					, A.TRANSPORT_MODE
					, A.INCOTERMS
					, A.SHIP_PLAN_DATE 
					, A.SHIP_PLAN_QTY 
					, NULL								AS COMMENT
					, A.ATTR_01           
					, NULL								AS ATTR_02           
				/* 20211102  SHINMYUNGSU  수정  ****************************************************/
					--, NULL								AS ATTR_03    
					, A.ATTR_03      --Model PIC   				
					--, NULL								AS ATTR_04           
					, A.ATTR_04		--MTK_OWNER       
			/***************************************************************************************/
					, NULL								AS ATTR_05           
					, NULL								AS ATTR_06           
					, NULL								AS ATTR_07           
					, NULL								AS ATTR_08           
					, NULL								AS ATTR_09           
					--, @v_request_id					AS ATTR_10 
					, A.ATTR_10 
					/* 20211102  SHINMYUNGSU  수정  ********************************************/
					--, '-'								AS ORDER_TYPE_DETAIL
					, A.ORDER_TYPE_DETAIL
					/***************************************************************************/
			FROM
			(
				SELECT B.FROM_SITE  AS PACKER_CODE      
					 , B.DIVISION_ID AS DIVISION_ID      
					 , B.MODEL_ID    AS PACK_MODEL_CODE  
					 , [dbo].[FN_GET_ITEM_NICKNAME](B.DIVISION_ID, B.MODEL_ID)  AS NICK_NAME 
					 , B.TO_SITE     AS SALES_SITE
					 , [dbo].[FN_GET_SITE_CUSTOMER_INFO](B.DIVISION_ID, B.TO_SITE,'SHIPTO_CODE')	AS SHIP_TO
					 , [dbo].[FN_GET_SITE_CUSTOMER_INFO](B.DIVISION_ID, B.TO_SITE,'SHIPTO_DESCRIPTION')	AS SHIP_TO_NAME
					 , B.TRANSPORT_MODE
					 , B.INCOTERMS
					 , B.YYYYMMDD    AS SHIP_PLAN_DATE 
					 , B.QTY         AS SHIP_PLAN_QTY 
					 , B.DIVISION_ID + '_' + @v_plan_start_yyyymmdd + '_' + @IF_GROUP_NO	AS ATTR_01           
					/* 20211102  SHINMYUNGSU  수정  ****************************************************/
					 --, NULL								AS ATTR_03    
					 , U2.UserName + '(' + MU.USER_ID + ')'					AS ATTR_03      --Model PIC   				
					 --, NULL								AS ATTR_04           
					 , DBO.FN_GET_SSP_MKT_OWNER_NAME (SI.OWNER, '', 'KO')	AS ATTR_04		--MTK_OWNER       
				/***************************************************************************************/
					 , B.REQUEST_ID						AS ATTR_10 
					 /* 20211102  SHINMYUNGSU  수정  ********************************************/
					 --, '-'								AS ORDER_TYPE_DETAIL
					 , ISNULL(LK.SEGMENT2, A.FCST_TYPE) AS ORDER_TYPE_DETAIL
					 /***************************************************************************/
				FROM #TblDynamic_SSP0026_ShpimentReq B WITH(NOLOCK)
					/* 20211102  SHINMYUNGSU  추가 ***************************************************************************************/
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
					/********************************************************************************************************************/
				WHERE 1=1
				AND ACTIVE_FLAG = 'I'
			) A
			LEFT OUTER JOIN NERP_CONV_MASTER X1 WITH(NOLOCK) ON X1.CODETYPE = 'SCP_SITE_ID'	AND A.PACKER_CODE = X1.OLD_VALUE1
			


			--AND NOT EXISTS (SELECT 1 
			--				FROM SSP_ANL_SHIP_PLAN_PACK_REQ A WITH(NOLOCK)
			--				WHERE 1=1
			--				AND A.DIVISION_ID		= B.DIVISION_ID
			--				AND A.FROM_SITE			= B.FROM_SITE
			--				AND A.TO_SITE			= B.TO_SITE
			--				AND A.SHIPTO_CODE		= [dbo].[FN_GET_SITE_CUSTOMER_INFO](B.DIVISION_ID, B.TO_SITE,'SHIPTO_CODE')
			--				AND A.MODEL_ID			= B.MODEL_ID
			--				AND A.YYYYMMDD			= B.YYYYMMDD
			--				AND A.BOD_ID			= B.BOD_ID)
			;
			--INSERT INTO XIF_SCS_PACK_SHIP_PLAN_S_SN (
			--	   IF_SEQ           
			--	 , IF_TYPE          
			--	 , IF_ID            
			--	 , IF_INS_DATE      
			--	 , IF_FLAG          
			--	 , PACKER_CODE      
			--	 , DIVISION_ID      
			--	 , PLAN_VERSION   
			--	 , PACK_MODEL_CODE  
			--	 , NICK_NAME 
			--	 , TARGET_ORDER
			--	 , SSP_CNFM
			--	 , SALES_SITE
			--	 , SHIP_TO
			--	 , SHIP_TO_NAME
			--	 , TRANSPORT_MODE
			--	 , INCOTERMS
			--	 , SHIP_PLAN_DATE 
			--	 , SHIP_PLAN_QTY 
			--	 , COMMENT
			--	 , ATTR_01           
			--	 , ATTR_02           
			--	 , ATTR_03           
			--	 , ATTR_04           
			--	 , ATTR_05           
			--	 , ATTR_06           
			--	 , ATTR_07           
			--	 , ATTR_08           
			--	 , ATTR_09           
			--	 , ATTR_10
			--	 , ORDER_TYPE_DETAIL
			--	 )
			--SELECT 'OSCM' + CONVERT(VARCHAR,GETDATE(),12) + DBO.FN_ZERO_LPAD(CONVERT(VARCHAR,NEXT VALUE FOR DBO.SEQ1_XIF_SCS),10)  AS IF_SEQ
			--     , N'I'         AS IF_TYPE          
			--	 , N'OSCM_OSCS_SCS_PACK_SHIP_PLAN'  AS IF_ID            
			--	 , GETDATE()    AS IF_INS_DATE      
			--	 , 'N'          AS IF_FLAG          
			--	 , B.FROM_SITE  AS PACKER_CODE      
			--	 , B.DIVISION_ID AS DIVISION_ID      
			--	 , @v_plan_start_yyyymmdd   AS PLAN_VERSION   
			--	 , B.MODEL_ID    AS PACK_MODEL_CODE  
			--	 , [dbo].[FN_GET_ITEM_NICKNAME](B.DIVISION_ID, B.MODEL_ID)  AS NICK_NAME 
			--	 , N'O'          AS TARGET_ORDER
			--	 , N'-' AS SSP_CNFM
			--	 , B.TO_SITE     AS SALES_SITE
			--	 , [dbo].[FN_GET_SITE_CUSTOMER_INFO](B.DIVISION_ID, B.TO_SITE,'SHIPTO_CODE')	AS SHIP_TO
			--	 , [dbo].[FN_GET_SITE_CUSTOMER_INFO](B.DIVISION_ID, B.TO_SITE,'SHIPTO_DESCRIPTION')	AS SHIP_TO_NAME
			--	 , B.TRANSPORT_MODE
			--	 , B.INCOTERMS
			--	 , B.YYYYMMDD    AS SHIP_PLAN_DATE 
			--	 , B.QTY         AS SHIP_PLAN_QTY 
			--	 , NULL								AS COMMENT
			--	 , B.DIVISION_ID + '_' + @v_plan_start_yyyymmdd + '_' + @IF_GROUP_NO	AS ATTR_01           
			--	 , NULL								AS ATTR_02           
			--	 , NULL								AS ATTR_03           
			--	 , NULL								AS ATTR_04           
			--	 , NULL								AS ATTR_05           
			--	 , NULL								AS ATTR_06           
			--	 , NULL								AS ATTR_07           
			--	 , NULL								AS ATTR_08           
			--	 , NULL								AS ATTR_09           
			--	 --, @v_request_id					AS ATTR_10 
			--	 , B.REQUEST_ID						AS ATTR_10 
			--	 , '-'								AS ORDER_TYPE_DETAIL
			--FROM #TblDynamic_SSP0026_ShpimentReq B WITH(NOLOCK)
			--WHERE 1=1
			--AND ACTIVE_FLAG = 'I'
			----AND NOT EXISTS (SELECT 1 
			----				FROM SSP_ANL_SHIP_PLAN_PACK_REQ A WITH(NOLOCK)
			----				WHERE 1=1
			----				AND A.DIVISION_ID		= B.DIVISION_ID
			----				AND A.FROM_SITE			= B.FROM_SITE
			----				AND A.TO_SITE			= B.TO_SITE
			----				AND A.SHIPTO_CODE		= [dbo].[FN_GET_SITE_CUSTOMER_INFO](B.DIVISION_ID, B.TO_SITE,'SHIPTO_CODE')
			----				AND A.MODEL_ID			= B.MODEL_ID
			----				AND A.YYYYMMDD			= B.YYYYMMDD
			----				AND A.BOD_ID			= B.BOD_ID)
			--;

			SET @v_cnt = 0;  -- 저장 후 초기화
		END


		---- MAIN UPDATE

		--UPDATE T1
		--SET QTY = T2.QTY
		--, LAST_UPDATED_BY = @p_created_by
		--, LAST_UPDATE_DATE = @d_event_date
		--FROM SSP_ANL_SHIP_PLAN_PACKER T1
		--INNER JOIN ( SELECT DISTINCT A.DIVISION_ID,A.FROM_SITE, A.TO_SITE, A.MODEL_ID, A.INCOTERMS,A.BOD_ID, A.TRANSPORT_MODE, A.YYYYMMDD, SUM(A.QTY) QTY
		--			FROM SSP_ANL_SHIP_PLAN_PACK_REQ A
		--			JOIN (SELECT DISTINCT C.DIVISION_ID, C.FROM_SITE, C.TO_SITE, C.MODEL_ID, C.INCOTERMS, C.BOD_ID, C.TRANSPORT_MODE, C.YYYYMMDD
		--				   FROM #TblDynamic_SSP0026_ShpimentReq C
		--				 ) B 
		--			ON A.DIVISION_ID		= B.DIVISION_ID
		--			AND A.FROM_SITE			= B.FROM_SITE
		--			AND A.TO_SITE			= B.TO_SITE
		--			AND A.MODEL_ID			= B.MODEL_ID
		--			AND A.INCOTERMS			= B.INCOTERMS
		--			AND A.BOD_ID			= B.BOD_ID			
		--			AND A.TRANSPORT_MODE	= B.TRANSPORT_MODE	
		--			AND A.YYYYMMDD			= B.YYYYMMDD
		--			GROUP BY A.DIVISION_ID,A.FROM_SITE, A.TO_SITE, A.MODEL_ID, A.INCOTERMS,A.BOD_ID, A.TRANSPORT_MODE, A.YYYYMMDD
		--			) T2
		--ON  T1.DIVISION_ID	= T2.DIVISION_ID
		--AND T1.FROM_SITE	= T2.FROM_SITE
		--AND T1.TO_SITE		= T2.TO_SITE
		--AND T1.MODEL_ID		= T2.MODEL_ID
		--AND T1.INCOTERMS    = T2.INCOTERMS
		--AND T1.BOD_ID		= T2.BOD_ID
		--AND T1.TRANSPORT_MODE = T2.TRANSPORT_MODE
		--AND T1.YYYYMMDD	= T2.YYYYMMDD
		--WHERE T1.MEASURE = 'SHIP_REQ'
		--;

		-----------------------------------------------------------
		-- 이력처리
		-----------------------------------------------------------
		SET @v_insert_cnt	=  @@ROWCOUNT;
		SET @v_insert_sum	= @v_insert_sum + @v_insert_cnt;


		-----------------------------------------------------------------------------------------------------
		-- SSP_ANL_SHIP_PLAN_PACKER 의 MEASURE   = 'SHIP_REQ' 기준
		-- DIVISION / PLAN_START_YYYYMMDD / MODEL / FROM_SITE 기준으로 집계
		-- 생성 MEASURE = 'TOTAL_REQ'
		-----------------------------------------------------------------------------------------------------
		 --    MERGE INTO SSP_ANL_SHIP_PLAN_PACKER AS A
			--USING (
			--		SELECT A.DIVISION_ID
			--			  , N'-'               AS PLAN_START_YYYYMMDD
			--			  , N'-'               AS MODEL_TYPE
			--			  , 1                  AS SEQ
			--			  , A.MODEL_ID
			--			  , A.FROM_SITE
			--			  , '-'                AS TO_SITE
			--			  , N'TOTAL_REQ'       AS MEASURE
			--			  , A.YYYYMMDD
			--			  , '-'                AS BOD_ID
			--			  , SUM(A.QTY)         AS QTY
			--			  , '-'                AS REQUEST_ID
			--			  , '-'                AS INCOTERMS
			--			  , '-'                AS TRANSPORT_MODE
			--			  , '-'                AS BIZ_TYPE
			--			  , '-'                AS PROJECT_CODE
			--			  , '-'                AS FCST_TYPE
			--			  , '-'                AS FCST_ETD_DATE
			--			  , '-'                AS FCST_ETA_DATE
			--			  , '-'                AS ETD_DATE
			--			  , '-'                AS ETA_DATE
			--			  , N'N'               AS CONFIRM_FLAG
			--			  , N'-'               AS CONFIRM_ID
			--			  , N'SYSTEM'          AS CREATED_BY  -- @v_program_name
			--			  , GETDATE()          AS CREATION_DATE
			--			  , @p_created_by          AS LAST_UPDATED_BY   -- @v_program_name
			--			  , GETDATE()          AS LAST_UPDATE_DATE
			--			  , N'N'               AS ELECTRODE_YN
			--			  , '-'                AS ELECTRODE_TYPE
			--			  , '-'                AS ORIGIN_FROM_DIVISION_ID
			--			  , '-'                AS ORIGIN_TO_DIVISION_ID
			--			  , NULL               AS ATTRIBUTE1
			--			  , NULL               AS ATTRIBUTE2
			--			  , NULL               AS ATTRIBUTE3
			--			  , NULL               AS ATTRIBUTE4
			--			  , NULL               AS ATTRIBUTE5
			--			  , NULL               AS ATTRIBUTE6
			--			  , NULL               AS ATTRIBUTE7
			--			  , NULL               AS ATTRIBUTE8
			--			  , NULL               AS ATTRIBUTE9
			--			  , NULL               AS ATTRIBUTE10
			--		FROM   SSP_ANL_SHIP_PLAN_PACKER  A WITH(NOLOCK)
			--		JOIN #TblDynamic_SSP0026_ShpimentReq B WITH(NOLOCK) 
			--			ON A.DIVISION_ID		= B.DIVISION_ID
			--			AND A.FROM_SITE			= B.FROM_SITE
			--			AND A.TO_SITE			= B.TO_SITE
			--			AND A.MODEL_ID			= B.MODEL_ID
			--			AND A.INCOTERMS			= B.INCOTERMS
			--			AND A.BOD_ID			= B.BOD_ID				
			--			AND A.TRANSPORT_MODE	= B.TRANSPORT_MODE	
			--			AND A.YYYYMMDD			= B.YYYYMMDD
			--		WHERE  1 = 1
			--		AND    A.DIVISION_ID = @v_division_id
			--		--AND    A.YYYYMMDD <= @v_plan_start_date
			--		--AND    A.YYYYMMDD >= @v_plan_end_date
			--		AND    A.MEASURE   = 'SHIP_REQ'
			--		GROUP BY A.DIVISION_ID
			--			  , A.PLAN_START_YYYYMMDD
			--			  , A.MODEL_ID
			--			  , A.FROM_SITE
			--			  , A.YYYYMMDD
			--	  ) B
			--ON  (
			--		  A.DIVISION_ID = B.DIVISION_ID
			--	AND   A.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD
			--	AND   A.MODEL_TYPE = B.MODEL_TYPE
			--	AND   A.MODEL_ID = B.MODEL_ID
			--	AND   A.FROM_SITE = B.FROM_SITE
			--	AND   A.TO_SITE = B.TO_SITE
			--	AND   A.MEASURE = B.MEASURE
			--	AND   A.YYYYMMDD = B.YYYYMMDD
			--	AND   A.BOD_ID = B.BOD_ID
			--	AND   A.INCOTERMS = B.INCOTERMS
			--	AND   A.TRANSPORT_MODE = B.TRANSPORT_MODE
			--	AND   A.PROJECT_CODE = B.PROJECT_CODE
			--	AND   A.FCST_TYPE = B.FCST_TYPE
			--)
			--WHEN MATCHED THEN
			--UPDATE SET A.QTY  = B.QTY
			--		 , A.LAST_UPDATED_BY = B.LAST_UPDATED_BY
			--		 , A.LAST_UPDATE_DATE = B.LAST_UPDATE_DATE
			--WHEN NOT MATCHED THEN
			--INSERT (
			--		DIVISION_ID
			--	  , PLAN_START_YYYYMMDD
			--	  , MODEL_TYPE
			--	  , SEQ
			--	  , MODEL_ID
			--	  , FROM_SITE
			--	  , TO_SITE
			--	  , MEASURE
			--	  , YYYYMMDD
			--	  , BOD_ID
			--	  , QTY
			--	  , REQUEST_ID
			--	  , INCOTERMS
			--	  , TRANSPORT_MODE
			--	  , BIZ_TYPE
			--	  , PROJECT_CODE
			--	  , FCST_TYPE
			--	  , FCST_ETD_DATE
			--	  , FCST_ETA_DATE
			--	  , ETD_DATE
			--	  , ETA_DATE
			--	  , CONFIRM_FLAG
			--	  , CONFIRM_ID
			--	  , CREATED_BY
			--	  , CREATION_DATE
			--	  , LAST_UPDATED_BY
			--	  , LAST_UPDATE_DATE
			--	  , ELECTRODE_YN
			--	  , ELECTRODE_TYPE
			--	  , ORIGIN_FROM_DIVISION_ID
			--	  , ORIGIN_TO_DIVISION_ID
			--	  , ATTRIBUTE1
			--	  , ATTRIBUTE2
			--	  , ATTRIBUTE3
			--	  , ATTRIBUTE4
			--	  , ATTRIBUTE5
			--	  , ATTRIBUTE6
			--	  , ATTRIBUTE7
			--	  , ATTRIBUTE8
			--	  , ATTRIBUTE9
			--	  , ATTRIBUTE10
			--	   )
			--VALUES (
			--		B.DIVISION_ID
			--	  , B.PLAN_START_YYYYMMDD
			--	  , B.MODEL_TYPE
			--	  , B.SEQ
			--	  , B.MODEL_ID
			--	  , B.FROM_SITE
			--	  , B.TO_SITE
			--	  , B.MEASURE
			--	  , B.YYYYMMDD
			--	  , B.BOD_ID
			--	  , B.QTY
			--	  , B.REQUEST_ID
			--	  , B.INCOTERMS
			--	  , B.TRANSPORT_MODE
			--	  , B.BIZ_TYPE
			--	  , B.PROJECT_CODE
			--	  , B.FCST_TYPE
			--	  , B.FCST_ETD_DATE
			--	  , B.FCST_ETA_DATE
			--	  , B.ETD_DATE
			--	  , B.ETA_DATE
			--	  , B.CONFIRM_FLAG
			--	  , B.CONFIRM_ID
			--	  , B.CREATED_BY
			--	  , B.CREATION_DATE
			--	  , B.LAST_UPDATED_BY
			--	  , B.LAST_UPDATE_DATE
			--	  , B.ELECTRODE_YN
			--	  , B.ELECTRODE_TYPE
			--	  , B.ORIGIN_FROM_DIVISION_ID
			--	  , B.ORIGIN_TO_DIVISION_ID
			--	  , B.ATTRIBUTE1
			--	  , B.ATTRIBUTE2
			--	  , B.ATTRIBUTE3
			--	  , B.ATTRIBUTE4
			--	  , B.ATTRIBUTE5
			--	  , B.ATTRIBUTE6
			--	  , B.ATTRIBUTE7
			--	  , B.ATTRIBUTE8
			--	  , B.ATTRIBUTE9
			--	  , B.ATTRIBUTE10
			--	   ) ;


		-----------------------------------------------------------
		-- 이력처리
		-----------------------------------------------------------
		SET @v_insert_cnt	=  @@ROWCOUNT;
		SET @v_insert_sum	= @v_insert_sum + @v_insert_cnt;

		-----------------------------------------------------------------------------------------------------
		-- SSP_ANL_SHIP_PLAN_PACKER 의 MEASURE   = 'TOTAL_REQ' & 'PACK_FP' 인 정보기준 출하 REQUEST 을 생성
		-- 생성 MEASURE = 'WH_BOH_REQ' 
		-----------------------------------------------------------------------------------------------------

  --   	MERGE INTO SSP_ANL_SHIP_PLAN_PACKER AS A
		--USING (
		--		SELECT A.DIVISION_ID
		--				, N'-'               AS PLAN_START_YYYYMMDD
		--				, N'-'               AS MODEL_TYPE
		--				, 1                  AS SEQ
		--				, A.MODEL_ID
		--				, A.FROM_SITE
		--				, '-'                AS TO_SITE
		--				, N'WH_BOH_REQ'      AS MEASURE
		--				, A.YYYYMMDD
		--				, '-'                AS BOD_ID
		--				--, SUM(CASE WHEN C.MEASURE = 'TOTAL_REQ' AND C.YYYYMMDD > @v_plan_start_date THEN -1 * ISNULL(C.QTY,0)  -- @p_from_yyyymmdd
		--				--			WHEN C.MEASURE <> 'TOTAL_REQ' AND C.YYYYMMDD < A.YYYYMMDD THEN ISNULL(C.QTY, 0)
		--				--	ELSE 0 END) + ISNULL(B.STOCK_QTY, 0) AS QTY
		--				, SUM(CASE WHEN C.MEASURE = 'TOTAL_REQ' AND C.YYYYMMDD = CONVERT(NVARCHAR(8), GETDATE()-1, 112) THEN 0  -- @p_from_yyyymmdd
		--								   WHEN C.MEASURE = 'TOTAL_REQ' AND C.YYYYMMDD >= CONVERT(NVARCHAR(8), GETDATE(), 112) THEN -1 * ISNULL(C.QTY,0)  -- @p_from_yyyymmdd
		--						           WHEN C.MEASURE <> 'TOTAL_REQ' AND C.YYYYMMDD = CONVERT(NVARCHAR(8), GETDATE()-1, 112) THEN 0
		--								   WHEN C.MEASURE <> 'TOTAL_REQ' AND C.YYYYMMDD >= CONVERT(NVARCHAR(8), GETDATE(), 112) AND C.YYYYMMDD < A.YYYYMMDD THEN ISNULL(C.QTY, 0)
		--							ELSE 0 END) + ISNULL(B.STOCK_QTY, 0) AS QTY
		--				, '-'                AS REQUEST_ID
		--				, '-'                AS INCOTERMS
		--				, '-'                AS TRANSPORT_MODE
		--				, '-'                AS BIZ_TYPE
		--				, '-'                AS PROJECT_CODE
		--				, '-'                AS FCST_TYPE
		--				, '-'                AS FCST_ETD_DATE
		--				, '-'                AS FCST_ETA_DATE
		--				, '-'                AS ETD_DATE
		--				, '-'                AS ETA_DATE
		--				, N'N'               AS CONFIRM_FLAG
		--				, N'-'               AS CONFIRM_ID
		--				, N'SYSTEM'          AS CREATED_BY  -- @v_program_name
		--				, GETDATE()          AS CREATION_DATE
		--				, @p_created_by      AS LAST_UPDATED_BY   -- @v_program_name
		--				, GETDATE()          AS LAST_UPDATE_DATE
		--				, N'N'               AS ELECTRODE_YN
		--				, '-'                AS ELECTRODE_TYPE
		--				, '-'                AS ORIGIN_FROM_DIVISION_ID
		--				, '-'                AS ORIGIN_TO_DIVISION_ID
		--				, NULL               AS ATTRIBUTE1
		--				, NULL               AS ATTRIBUTE2
		--				, NULL               AS ATTRIBUTE3
		--				, NULL               AS ATTRIBUTE4
		--				, NULL               AS ATTRIBUTE5
		--				, NULL               AS ATTRIBUTE6
		--				, NULL               AS ATTRIBUTE7
		--				, NULL               AS ATTRIBUTE8
		--				, NULL               AS ATTRIBUTE9
		--				, NULL               AS ATTRIBUTE10
		--		FROM   (
		--					SELECT B.DIVISION_ID
		--							, B.MODEL_ID
		--							, B.FROM_SITE
		--							, A.BASIS_YYYYMMDD AS YYYYMMDD
		--					FROM   SCM_SYS_CALENDAR_M  A WITH(NOLOCK)
		--							CROSS APPLY (
		--										SELECT A.DIVISION_ID
		--												, A.MODEL_ID
		--												, A.FROM_SITE
		--										FROM   SSP_ANL_SHIP_PLAN_PACKER  A WITH(NOLOCK)
		--										JOIN #TblDynamic_SSP0026_ShpimentReq B WITH(NOLOCK) 
		--											ON A.DIVISION_ID		= B.DIVISION_ID												
		--											AND A.MODEL_ID			= B.MODEL_ID
		--											AND A.YYYYMMDD			= B.YYYYMMDD
		--										WHERE  1 = 1
		--										AND    A.DIVISION_ID = @v_division_id
		--										AND    A.YYYYMMDD >= CONVERT(NVARCHAR(8), GETDATE()-1, 112) --@v_plan_start_date
		--										AND    A.YYYYMMDD <= @v_plan_end_date
		--										AND    A.MEASURE   IN ('TOTAL_REQ', 'PACK_FP')
		--										GROUP BY A.DIVISION_ID
		--												, A.MODEL_ID
		--												, A.FROM_SITE
		--										) B
		--					WHERE  1 = 1
		--					AND    A.BASIS_YYYYMMDD >= CONVERT(NVARCHAR(8), GETDATE()-1, 112) --@v_plan_start_date
		--					AND    A.BASIS_YYYYMMDD <= @v_plan_end_date
		--					) A
		--					LEFT OUTER JOIN (
		--									SELECT DIVISION_ID
		--											, SCM_SITE_ID     AS FROM_SITE
		--											, ITEM_ID         AS MODEL_ID
		--											, STOCK_DATE      AS YYYYMMDD
		--											, SUM(ISNULL(STOCK_QTY, 0))  AS STOCK_QTY
		--									FROM   SCM_DNM_SCS_STOCK A (NOLOCK)
		--									WHERE  1 = 1
		--									AND    DIVISION_ID = @v_division_id
		--									AND    CUTOFF_DATE = @v_cutoff_end_date
		--									--AND    STOCK_DATE >= @v_plan_start_date
		--									--AND    STOCK_DATE <= @v_plan_end_date
		--									AND    CELL_PACK   = 'P'
		--									GROUP BY DIVISION_ID
		--											, SCM_SITE_ID
		--											, ITEM_ID
		--											, STOCK_DATE
		--									) B
		--					ON   A.DIVISION_ID = B.DIVISION_ID
		--					AND  A.MODEL_ID    = B.MODEL_ID
		--					AND  A.FROM_SITE	  = B.FROM_SITE
		--					LEFT OUTER JOIN (
		--									SELECT A.DIVISION_ID
		--											, A.PLAN_START_YYYYMMDD
		--											, A.MODEL_ID
		--											, A.FROM_SITE
		--											, A.YYYYMMDD
		--											, A.MEASURE
		--											, A.QTY
		--									FROM   SSP_ANL_SHIP_PLAN_PACKER  A WITH(NOLOCK)
		--									JOIN #TblDynamic_SSP0026_ShpimentReq B WITH(NOLOCK) 
		--											ON A.DIVISION_ID		= B.DIVISION_ID												
		--											AND A.MODEL_ID			= B.MODEL_ID
		--											AND A.YYYYMMDD			= B.YYYYMMDD
		--									WHERE  1 = 1
		--									AND    A.DIVISION_ID = @v_division_id
		--									AND    A.YYYYMMDD >= CONVERT(NVARCHAR(8), GETDATE()-1, 112) -- @v_plan_start_date
		--									AND    A.YYYYMMDD <= @v_plan_end_date
		--									AND    A.MEASURE   IN ('TOTAL_REQ', 'PACK_FP')
		--									) C
		--					ON   C.DIVISION_ID = A.DIVISION_ID 
		--					AND  C.MODEL_ID    = A.MODEL_ID 
		--					AND  C.YYYYMMDD   <= A.YYYYMMDD 
		--					AND  C.FROM_SITE   = A.FROM_SITE
		--			WHERE  1 = 1
		--			GROUP BY A.DIVISION_ID
		--					, C.PLAN_START_YYYYMMDD
		--					, A.MODEL_ID
		--					, A.FROM_SITE
		--					, A.YYYYMMDD
		--					, B.STOCK_QTY
		--		) B
		--ON  (
		--		 A.DIVISION_ID = B.DIVISION_ID
		--	AND   A.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD
		--	AND   A.MODEL_TYPE = B.MODEL_TYPE
		--	AND   A.MODEL_ID = B.MODEL_ID
		--	AND   A.FROM_SITE = B.FROM_SITE
		--	AND   A.TO_SITE = B.TO_SITE
		--	AND   A.MEASURE = B.MEASURE
		--	AND   A.YYYYMMDD = B.YYYYMMDD
		--	AND   A.BOD_ID = B.BOD_ID
		--	AND   A.INCOTERMS = B.INCOTERMS
		--	AND   A.TRANSPORT_MODE = B.TRANSPORT_MODE
		--	AND   A.PROJECT_CODE = B.PROJECT_CODE
		--	AND   A.FCST_TYPE = B.FCST_TYPE
		--)
		--WHEN MATCHED THEN
		--UPDATE SET A.QTY  = B.QTY
		--			, A.LAST_UPDATED_BY = B.LAST_UPDATED_BY
		--			, A.LAST_UPDATE_DATE = B.LAST_UPDATE_DATE
		--WHEN NOT MATCHED THEN
		--INSERT (
		--		DIVISION_ID
		--		, PLAN_START_YYYYMMDD
		--		, MODEL_TYPE
		--		, SEQ
		--		, MODEL_ID
		--		, FROM_SITE
		--		, TO_SITE
		--		, MEASURE
		--		, YYYYMMDD
		--		, BOD_ID
		--		, QTY
		--		, REQUEST_ID
		--		, INCOTERMS
		--		, TRANSPORT_MODE
		--		, BIZ_TYPE
		--		, PROJECT_CODE
		--		, FCST_TYPE
		--		, FCST_ETD_DATE
		--		, FCST_ETA_DATE
		--		, ETD_DATE
		--		, ETA_DATE
		--		, CONFIRM_FLAG
		--		, CONFIRM_ID
		--		, CREATED_BY
		--		, CREATION_DATE
		--		, LAST_UPDATED_BY
		--		, LAST_UPDATE_DATE
		--		, ELECTRODE_YN
		--		, ELECTRODE_TYPE
		--		, ORIGIN_FROM_DIVISION_ID
		--		, ORIGIN_TO_DIVISION_ID
		--		, ATTRIBUTE1
		--		, ATTRIBUTE2
		--		, ATTRIBUTE3
		--		, ATTRIBUTE4
		--		, ATTRIBUTE5
		--		, ATTRIBUTE6
		--		, ATTRIBUTE7
		--		, ATTRIBUTE8
		--		, ATTRIBUTE9
		--		, ATTRIBUTE10
		--		)
		--VALUES (
		--		B.DIVISION_ID
		--		, B.PLAN_START_YYYYMMDD
		--		, B.MODEL_TYPE
		--		, B.SEQ
		--		, B.MODEL_ID
		--		, B.FROM_SITE
		--		, B.TO_SITE
		--		, B.MEASURE
		--		, B.YYYYMMDD
		--		, B.BOD_ID
		--		, B.QTY
		--		, B.REQUEST_ID
		--		, B.INCOTERMS
		--		, B.TRANSPORT_MODE
		--		, B.BIZ_TYPE
		--		, B.PROJECT_CODE
		--		, B.FCST_TYPE
		--		, B.FCST_ETD_DATE
		--		, B.FCST_ETA_DATE
		--		, B.ETD_DATE
		--		, B.ETA_DATE
		--		, B.CONFIRM_FLAG
		--		, B.CONFIRM_ID
		--		, B.CREATED_BY
		--		, B.CREATION_DATE
		--		, B.LAST_UPDATED_BY
		--		, B.LAST_UPDATE_DATE
		--		, B.ELECTRODE_YN
		--		, B.ELECTRODE_TYPE
		--		, B.ORIGIN_FROM_DIVISION_ID
		--		, B.ORIGIN_TO_DIVISION_ID
		--		, B.ATTRIBUTE1
		--		, B.ATTRIBUTE2
		--		, B.ATTRIBUTE3
		--		, B.ATTRIBUTE4
		--		, B.ATTRIBUTE5
		--		, B.ATTRIBUTE6
		--		, B.ATTRIBUTE7
		--		, B.ATTRIBUTE8
		--		, B.ATTRIBUTE9
		--		, B.ATTRIBUTE10
		--		) ;

		-----------------------------------------------------------
		-- 이력처리
		-----------------------------------------------------------
		SET @v_insert_cnt	=  @@ROWCOUNT;
		SET @v_insert_sum	= @v_insert_sum + @v_insert_cnt;

        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------
   --     IF @@TRANCOUNT > 0
			--BEGIN
			--COMMIT TRAN TX_SH;
   --      END; 
	    
	   SELECT 'S' AS RESULT_CODE, '' AS MSG

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
			RETURN -1;
		
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
