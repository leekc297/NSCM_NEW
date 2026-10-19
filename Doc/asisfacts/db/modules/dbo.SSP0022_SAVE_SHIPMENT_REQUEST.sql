
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
 * Program ID   : SSP0022_SAVE_SHIPMENT_REQUEST
 * Description  : Shipment Request 입력
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2020/04/14	 KIMYONGHO		신규추가
 * 2021/09/02   KIMYONGHO       SCP_MST_BOD_N_V 조회 로직 추가


 *
 */
CREATE PROCEDURE [dbo].[SSP0022_SAVE_SHIPMENT_REQUEST]
	 @p_active_flag		NVARCHAR(MAX)
	,@p_division_id		NVARCHAR(MAX)
	,@p_company_id		NVARCHAR(MAX)
	,@p_scm_site_id		NVARCHAR(MAX)
	,@p_plant_id		NVARCHAR(MAX)
	,@p_model_id		NVARCHAR(MAX)
	,@p_item_id			NVARCHAR(MAX)
	,@p_from_site		NVARCHAR(MAX)
	,@p_to_site			NVARCHAR(MAX)
	,@p_eta_date		NVARCHAR(MAX)
	,@p_bod_id			NVARCHAR(MAX)
	,@p_qty				NVARCHAR(MAX)	
	,@p_incoterms		NVARCHAR(MAX)
	,@p_transport_mode	NVARCHAR(MAX)
	,@p_created_by		NVARCHAR(300)
	,@debug_mode		NVARCHAR(1)

AS

BEGIN

	/********************************************************************************      
	* 임시테이블만들기
	********************************************************************************/ 
	IF OBJECT_ID('tempdb..#TblDynamic_SSP0022_ShpimentReq') IS NOT NULL
		DROP TABLE #TblDynamic_SSP0022_ShpimentReq;    

	IF OBJECT_ID('tempdb..#TblDynamic_SSP0022_ShpimentReq_H') IS NOT NULL
		DROP TABLE #TblDynamic_SSP0022_ShpimentReq_H;    

	CREATE TABLE #TblDynamic_SSP0022_ShpimentReq (
		ACTIVE_FLAG					NVARCHAR(1)
		,FROM_COMPANY_ID			NVARCHAR(30)
		,FROM_DIVISION_ID			NVARCHAR(30)
		,FROM_PLANT_ID				NVARCHAR(50)
		,FROM_SITE					NVARCHAR(50)
		,TO_COMPANY_ID				NVARCHAR(30)
		,TO_DIVISION_ID				NVARCHAR(30)
		,TO_PLANT_ID				NVARCHAR(50)
		,TO_SITE					NVARCHAR(50)
		,MODEL_ID					NVARCHAR(50)
		,ITEM_ID					NVARCHAR(50)
		,BOD_ID						NVARCHAR(8)
		,INCOTERMS					NVARCHAR(8)
		,TRANSPORT_MODE				NVARCHAR(8)
		,ETA_DATE					NVARCHAR(8)
		,ETD_DATE					NVARCHAR(8)
		,QTY						NVARCHAR(30)
		,QTY_TO_PCM					NVARCHAR(30)
		,QTY_TO_CELL				NVARCHAR(30)
	);



	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	--DECLARE @recv_active_flag		NVARCHAR(MAX);
	--SET @recv_active_flag = @p_active_flag;

	DECLARE @recv_division_id		NVARCHAR(MAX);
	SET @recv_division_id = NULL;		
	SET @recv_division_id = @p_division_id;

	DECLARE @v_active_flag		NVARCHAR(1);
	DECLARE @v_division_id		NVARCHAR(30);
	DECLARE @v_company_id		NVARCHAR(30);
	DECLARE @v_plant_id			NVARCHAR(30);
	DECLARE @v_scm_site_id		NVARCHAR(30);
	DECLARE @v_model_id			NVARCHAR(50);
	DECLARE @v_item_id			NVARCHAR(50);
	DECLARE @v_bod_id			NVARCHAR(50);
	DECLARE @v_incoterms		NVARCHAR(50);
	DECLARE @v_transport_mode	NVARCHAR(50);
	DECLARE @v_from_site		NVARCHAR(50);
	DECLARE @v_to_site			NVARCHAR(30);
	DECLARE @v_eta_date			NVARCHAR(8);
	DECLARE @v_qty				NVARCHAR(30);

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
	SET @v_company_id = NULL;
	SET @v_division_id = NULL;
	SET @v_plant_id = NULL;
	SET @v_scm_site_id = NULL;
	SET @v_model_id = NULL;
	SET @v_item_id = NULL;
	SET @v_bod_id = NULL;
	SET @v_incoterms = NULL;
	SET @v_transport_mode = NULL;
	SET @v_from_site = NULL;
	SET @v_to_site = NULL;
	SET @v_eta_date = NULL;
	SET @v_qty = NULL;
	SET @v_cnt = 0;

	-- LOG 용 변수 설정
	DECLARE @v_program_name NVARCHAR(150) = 'SSP0022_SAVE_SHIPMENT_REQUEST';
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
				SET @v_company_id		= [dbo].[SCM_ARR_SPL_VAL](@p_company_id,		@v_delimiter, @mst_loop_cnt);
				SET @v_division_id		= [dbo].[SCM_ARR_SPL_VAL](@p_division_id,		@v_delimiter, @mst_loop_cnt);
				SET @v_plant_id			= [dbo].[SCM_ARR_SPL_VAL](@p_plant_id,			@v_delimiter, @mst_loop_cnt);
				SET @v_scm_site_id		= [dbo].[SCM_ARR_SPL_VAL](@p_scm_site_id,		@v_delimiter, @mst_loop_cnt);
				SET @v_model_id			= [dbo].[SCM_ARR_SPL_VAL](@p_model_id,			@v_delimiter, @mst_loop_cnt);
				SET @v_item_id			= [dbo].[SCM_ARR_SPL_VAL](@p_item_id,			@v_delimiter, @mst_loop_cnt);
				SET @v_bod_id			= [dbo].[SCM_ARR_SPL_VAL](@p_bod_id,			@v_delimiter, @mst_loop_cnt);
				SET @v_incoterms		= [dbo].[SCM_ARR_SPL_VAL](@p_incoterms,			@v_delimiter, @mst_loop_cnt);
				SET @v_transport_mode	= [dbo].[SCM_ARR_SPL_VAL](@p_transport_mode,    @v_delimiter, @mst_loop_cnt);
				SET @v_from_site		= [dbo].[SCM_ARR_SPL_VAL](@p_from_site,			@v_delimiter, @mst_loop_cnt);
				SET @v_to_site			= [dbo].[SCM_ARR_SPL_VAL](@p_to_site,			@v_delimiter, @mst_loop_cnt);				
				SET @v_eta_date			= [dbo].[SCM_ARR_SPL_VAL](@p_eta_date,			@v_delimiter, @mst_loop_cnt);
				SET @v_qty				= [dbo].[SCM_ARR_SPL_VAL](@p_qty,				@v_delimiter, @mst_loop_cnt);
			END
			;

			-- LOOP 파라미터 출력 DEBUG용
			BEGIN		
				PRINT '===============================================';
				PRINT '@v_active_flag         = ''' +@v_active_flag             +'''';
				PRINT '@v_company_id          = ''' +@v_company_id              +'''';
				PRINT '@v_division_id         = ''' +@v_division_id             +'''';
				PRINT '@v_plant_id			  = ''' +@v_plant_id				+'''';
				PRINT '@v_scm_site_id         = ''' +@v_scm_site_id             +'''';
				PRINT '@v_model_id            = ''' +@v_model_id                +'''';
				PRINT '@v_item_id             = ''' +@v_item_id                 +'''';
				PRINT '@v_bod_id              = ''' +@v_bod_id                  +'''';
				PRINT '@v_from_site           = ''' +@v_from_site				+'''';
				PRINT '@v_to_site			  = ''' +@v_to_site					+'''';
				PRINT '@v_eta_date            = ''' +@v_eta_date                +'''';
				PRINT '@v_qty				  = ''' +@v_qty						+'''';

				PRINT '@mst_loop_cnt          = ''' +CONVERT(VARCHAR(10), @mst_loop_cnt) +'''';
			END;

 
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

					--  V.DIVISION_ID 
					--, V.BOD_ID 
					--, V.FROM_SITE
					--, V.TO_SITE 
					--, V.SSP_INCOTERMS
					--, V.TRANSPORT_MODE
					--, V.ROUTE_ID 
					--, V.D_COUNTRY        
					--, V.D_PORT_CODE      
					--, V.A_COUNTRY        
					--, V.A_PORT_CODE      
					--, V.LT_TOTAL      
					--, V.TO_COUNTRY       
					--, V.TO_CITY

				FROM    (
							SELECT   DISTINCT B.DIVISION_ID , B.BOD_ID , B.FROM_SITE, B.TO_SITE , B.SSP_INCOTERMS, B.TRANSPORT_MODE
									,B.ROUTE_ID, B.D_COUNTRY, B.D_PORT_CODE, B.A_COUNTRY, B.A_PORT_CODE, B.LT_TOTAL, B.LT_TOTAL_ORIGIN, B.TO_COUNTRY, B.TO_CITY , B.PRIORITY, B.bod_valid_yn
							FROM (
									SELECT TOP 1 DIVISION_ID 
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
									AND   FROM_YYYYMMDD <= CONVERT(VARCHAR(8), GETDATE(), 112)
									AND   TO_YYYYMMDD >= CONVERT(VARCHAR(8), GETDATE(), 112)
									ORDER BY PRIORITY ASC		

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

				--return;

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


			PRINT @recv_division_id;
			-- 변경, 추가 대상 건 TEMP 생성
			INSERT INTO #TblDynamic_SSP0022_ShpimentReq
			SELECT 
				T0.ACTIVE_FLAG
				,MS.COMPANY_ID			AS FROM_COMPANY_ID
				,L.SEGMENT2				AS FROM_DIVISION_ID
				,MS.PLANT_ID			AS FROM_PLANT_ID
				,T0.FROM_SITE
				,T0.COMPANY_ID			AS TO_COMPANY_ID
				,T0.TO_DIVISION_ID
				,T0.PLANT_ID			AS TO_PLANT_ID
				,T0.TO_SITE
				,T0.MODEL_ID
				,T0.ITEM_ID
				,T0.BOD_ID
				,T0.INCOTERMS
				,T0.TRANSPORT_MODE
				,T0.ETA_DATE
				,T0.ETD_DATE
				,CEILING(T0.QTY * 1000)/1000						 AS QTY
				,CEILING((T0.QTY * ISNULL(F.CONVERT_TO_PCM,  1)) * 1000)/1000  AS QTY_TO_PCM
				,CEILING((T0.QTY * ISNULL(F.CONVERT_TO_CELL, 1)) * 1000)/1000  AS QTY_TO_CELL

			FROM(
				SELECT @v_active_flag						AS ACTIVE_FLAG
					, @p_company_id							AS COMPANY_ID
					, @v_division_id						AS DIVISION_ID
					, @v_plant_id							AS PLANT_ID
					, @v_scm_site_id						AS SCM_SITE_ID
					, (SELECT DIVISION_ID FROM SCM_MST_SITE WITH(NOLOCK) WHERE SCM_sITE_ID = @v_from_site)	AS FROM_DIVISION_ID
					, @v_from_site							AS FROM_SITE
					, (SELECT DIVISION_ID FROM SCM_MST_SITE WITH(NOLOCK) WHERE SCM_sITE_ID = @v_to_site) AS TO_DIVISION_ID
					, @v_to_site							AS TO_SITE	
					, @v_model_id							AS MODEL_ID
					, @v_item_id							AS ITEM_ID
					, @v_eta_date							AS ETA_DATE
					, dbo.FN_GET_SSP_ETD_DATE(@v_division_id, @v_new_bod_id_temp, @v_eta_date) AS ETD_DATE
					, @v_new_bod_id_temp						AS BOD_ID
					, @v_new_incoterms_temp						AS INCOTERMS
					, @v_new_transport_mode_temp				AS TRANSPORT_MODE
					, CONVERT(decimal(30,3),@v_qty)				AS QTY
			) T0
			LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)	
				ON L.LOOKUP_TYPE = 'ELECTRODE_SHIP_FROM_TO'
				 AND SEGMENT5 = T0.TO_DIVISION_ID
				 AND SEGMENT3 = T0.FROM_SITE
				 AND ATTRIBUTE1 = T0.TO_SITE
			LEFT JOIN SCM_MST_SITE MS WITH(NOLOCK) 
				ON L.SEGMENT2 = MS.DIVISION_ID
				AND T0.FROM_SITE = MS.SCM_SITE_ID
			JOIN SSP_MST_SITE_ITEM_EE_V F WITH(NOLOCK) 
				ON L.SEGMENT2 = F.DIVISION_ID
				AND T0.FROM_SITE = F.SCM_SITE_ID
				AND T0.ITEM_ID = F.ITEM_ID   
			;

			--SELECT * FROM #TblDynamic_SSP0022_ShpimentReq;
		--	--SELECT * FROM SSP_ANL_SHIP_REQ_EE WHERE ITEM_ID = 'APCCA1299A'
		END

		--RETURN;

		SELECT  @v_cnt = COUNT(*)  
		FROM #TblDynamic_SSP0022_ShpimentReq

		---- 삭제기능은 없으므로 Active Flag는 'I' 또는 'M'으로 가정하고 입력/수정만 진행


		IF @v_cnt > 0 
		BEGIN
			SET @d_event_date = SYSDATETIME();

			-- 수정
			UPDATE A
			SET A.QTY = B.QTY
				, A.QTY_TO_PCM = B.QTY_TO_PCM
				, A.QTY_TO_CELL = B.QTY_TO_CELL
				, A.LAST_UPDATED_BY	= @p_created_by
				, A.LAST_UPDATE_DATE = @d_event_date
			FROM SSP_ANL_SHIP_REQ_EE A WITH(NOLOCK)
			JOIN #TblDynamic_SSP0022_ShpimentReq B WITH(NOLOCK) ON A.FROM_DIVISION_ID		= B.FROM_DIVISION_ID
														AND A.FROM_SITE			= B.FROM_SITE
														AND A.FROM_PLANT_ID		= B.FROM_PLANT_ID
														AND A.TO_SITE			= B.TO_SITE
														AND A.MODEL_ID			= B.MODEL_ID
														AND A.ITEM_ID			= B.ITEM_ID
														AND A.ETA_DATE			= B.ETA_DATE
														AND A.BOD_ID			= B.BOD_ID

			;

			SET @v_cnt = 0;  -- 저장 후 초기화
		END
		-- UPDATE END

		-- INSERT START
		SELECT @v_cnt = COUNT(*)
		FROM #TblDynamic_SSP0022_ShpimentReq B WITH(NOLOCK)
		WHERE 1=1
		AND NOT EXISTS (SELECT 1 
						FROM SSP_ANL_SHIP_REQ_EE A WITH(NOLOCK)
						WHERE 1=1
						AND A.FROM_DIVISION_ID	= B.FROM_DIVISION_ID
						AND A.FROM_SITE		= B.FROM_SITE
						AND A.FROM_PLANT_ID		= B.FROM_PLANT_ID
						AND A.TO_SITE			= B.TO_SITE
						AND A.MODEL_ID			= B.MODEL_ID
						AND A.ITEM_ID			= B.ITEM_ID
						AND A.ETA_DATE			= B.ETA_DATE
						AND A.BOD_ID			= B.BOD_ID	)
	
     	IF @v_cnt > 0
		BEGIN
			
			-- INSERT 대상 건 ACTIVE FLAG 변경
			UPDATE  A
			SET A.ACTIVE_FLAG = 'I'
			FROM #TblDynamic_SSP0022_ShpimentReq A
			WHERE  NOT EXISTS (SELECT 1 
							FROM SSP_ANL_SHIP_REQ_EE B WITH(NOLOCK)
							WHERE 1=1
							AND A.FROM_DIVISION_ID	= B.FROM_DIVISION_ID
							AND A.FROM_SITE		= B.FROM_SITE
							AND A.FROM_PLANT_ID		= B.FROM_PLANT_ID
							AND A.TO_SITE			= B.TO_SITE
							AND A.MODEL_ID			= B.MODEL_ID
							AND A.ITEM_ID			= B.ITEM_ID
							AND A.ETA_DATE			= B.ETA_DATE
							AND A.BOD_ID			= B.BOD_ID)
			;


			-- 신규 REQEUST INSERT
			INSERT INTO SSP_ANL_SHIP_REQ_EE
			(
				 FROM_COMPANY_ID
				,FROM_DIVISION_ID
				,FROM_PLANT_ID
				,FROM_SITE
				,TO_COMPANY_ID
				,TO_DIVISION_ID
				,TO_PLANT_ID
				,TO_SITE
				,MODEL_ID
				,ITEM_ID
				,BOD_ID
				,ETD_DATE
				,ETA_DATE
				,QTY
				,QTY_TO_PCM
				,QTY_TO_CELL
				,SCP_PLAN_START_YYYYMMDD
				,SCP_PLAN_TYPE
				,SCP_PLAN_SEQ
				,REQUEST_ID
				,CONFIRM_ID
				,CONFIRM_FLAG
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
			)
			SELECT 
				 B.FROM_COMPANY_ID
				,B.FROM_DIVISION_ID
				,B.FROM_PLANT_ID
				,B.FROM_SITE
				,B.TO_COMPANY_ID
				,B.TO_DIVISION_ID
				,B.TO_PLANT_ID
				,B.TO_SITE
				,B.MODEL_ID
				,B.ITEM_ID
				,B.BOD_ID
				, dbo.FN_GET_SSP_ETD_DATE(B.TO_DIVISION_ID, B.BOD_ID, B.ETA_DATE) AS ETD_DATE
				,B.ETA_DATE
				,B.QTY
				,B.QTY_TO_PCM AS QTY_TO_PCM
				,B.QTY_TO_CELL AS QTY_TO_CELL
				, NULL				AS SCP_PLAN_START_YYYYMMDD
				, NULL				AS SCP_PLAN_TYPE
				, NULL				AS SCP_PLAN_SEQ
				, ('R'+ CONVERT(VARCHAR(8), GETDATE(), 112) + RIGHT('000000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_REQ_EE_ID),6)) AS REQUEST_ID
				, NULL				AS CONFIRM_ID
				, 'N'				AS CONFIRM_FLAG
				, @p_created_by		AS CREATED_BY
				, @d_event_date		AS CREATION_DATE
				, @p_created_by		AS LAST_UPDATED_BY
				, @d_event_date		AS LAST_UPDATE_DATE
			FROM #TblDynamic_SSP0022_ShpimentReq B WITH(NOLOCK)
			WHERE 1=1
			AND NOT EXISTS (SELECT 1 
							FROM SSP_ANL_SHIP_REQ_EE A WITH(NOLOCK)
							WHERE 1=1
							AND A.FROM_DIVISION_ID	= B.FROM_DIVISION_ID
							AND A.FROM_SITE		= B.FROM_SITE
							AND A.FROM_PLANT_ID		= B.FROM_PLANT_ID
							AND A.TO_SITE			= B.TO_SITE
							AND A.MODEL_ID			= B.MODEL_ID
							AND A.ITEM_ID			= B.ITEM_ID
							AND A.ETA_DATE			= B.ETA_DATE
							AND A.BOD_ID			= B.BOD_ID)
			;

			SET @v_cnt = 0;  -- 저장 후 초기화
		END

		-- HISTORY 대상 건 TEMP 생성
		SELECT    NEXT VALUE FOR  SEQ1_SSP_ANL_SHIP_REQ_EE_H AS HISTORY_SEQ
				,B.ACTIVE_FLAG
				,A.FROM_COMPANY_ID
				,A.FROM_DIVISION_ID
				,A.FROM_PLANT_ID
				,A.FROM_SITE
				,A.TO_COMPANY_ID
				,A.TO_DIVISION_ID
				,A.TO_PLANT_ID
				,A.TO_SITE
				,A.MODEL_ID
				,A.ITEM_ID
				,A.BOD_ID	
				,A.ETD_DATE
				,A.ETA_DATE
				,A.QTY
				,A.QTY_TO_PCM
				,A.QTY_TO_CELL
				,A.SCP_PLAN_START_YYYYMMDD
				,A.SCP_PLAN_TYPE
				,A.SCP_PLAN_SEQ
				,A.REQUEST_ID
				,A.CONFIRM_ID
				,A.CONFIRM_FLAG
				,A.CREATED_BY
				,A.CREATION_DATE
				,A.LAST_UPDATED_BY
				,A.LAST_UPDATE_DATE 
				,GETDATE() AS HISTORY_CREATION_DATE
		INTO #TblDynamic_SSP0022_ShpimentReq_H
		FROM SSP_ANL_SHIP_REQ_EE A WITH(NOLOCK) 
		JOIN #TblDynamic_SSP0022_ShpimentReq B WITH(NOLOCK)
		ON A.FROM_DIVISION_ID	= B.FROM_DIVISION_ID
			AND A.FROM_SITE		= B.FROM_SITE
			AND A.FROM_PLANT_ID		= B.FROM_PLANT_ID
			AND A.TO_SITE			= B.TO_SITE
			AND A.MODEL_ID			= B.MODEL_ID
			AND A.ITEM_ID			= B.ITEM_ID
			AND A.ETA_DATE			= B.ETA_DATE
			AND A.BOD_ID			= B.BOD_ID
     	


		-- HISTORY 입력
		INSERT INTO SSP_ANL_SHIP_REQ_EE_H (
				HISTORY_SEQ
				,TRANS_TYPE
				,FROM_COMPANY_ID
				,FROM_DIVISION_ID
				,FROM_PLANT_ID
				,FROM_SITE
				,TO_COMPANY_ID
				,TO_DIVISION_ID
				,TO_PLANT_ID
				,TO_SITE
				,MODEL_ID
				,ITEM_ID
				,BOD_ID
				,ETD_DATE
				,ETA_DATE
				,QTY
				,QTY_TO_PCM
				,QTY_TO_CELL
				,SCP_PLAN_START_YYYYMMDD
				,SCP_PLAN_TYPE
				,SCP_PLAN_SEQ
				,REQUEST_ID
				,CONFIRM_ID
				,CONFIRM_FLAG
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE 
				,HISTORY_CREATION_DATE
				) 
		SELECT     T.HISTORY_SEQ
				,T.ACTIVE_FLAG
				,T.FROM_COMPANY_ID
				,T.FROM_DIVISION_ID
				,T.FROM_PLANT_ID
				,T.FROM_SITE
				,T.TO_COMPANY_ID
				,T.TO_DIVISION_ID
				,T.TO_PLANT_ID
				,T.TO_SITE
				,T.MODEL_ID
				,T.ITEM_ID
				,T.BOD_ID
				,T.ETD_DATE
				,T.ETA_DATE
				,ROUND(T.QTY, 10)  AS QTY
				,ROUND(T.QTY_TO_PCM, 10)  AS QTY_TO_PCM
				,ROUND(T.QTY_TO_CELL, 10)  AS QTY_TO_CELL
				,T.SCP_PLAN_START_YYYYMMDD
				,T.SCP_PLAN_TYPE
				,T.SCP_PLAN_SEQ
				,T.REQUEST_ID             
				,T.CONFIRM_ID             
				,T.CONFIRM_FLAG             
				,T.CREATED_BY             
				,T.CREATION_DATE             
				,T.LAST_UPDATED_BY             
				,T.LAST_UPDATE_DATE 
				,T.HISTORY_CREATION_DATE					
		FROM #TblDynamic_SSP0022_ShpimentReq_H T WITH(NOLOCK) 
		;

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



	IF OBJECT_ID('tempdb..#TblDynamic_SSP0022_ShpimentReq') IS NOT NULL
		DROP TABLE #TblDynamic_SSP0022_ShpimentReq;    

	IF OBJECT_ID('tempdb..#TblDynamic_SSP0022_ShpimentReq_H') IS NOT NULL
		DROP TABLE #TblDynamic_SSP0022_ShpimentReq_H;    

 
END











