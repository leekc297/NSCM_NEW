/****************************************************************************************************/
/* Program ID  : [DM0015_SAVE_SALES_SITE_DATA]														*/
/* Description : SCM_MST_SITE HISTORYT INSERT														*/
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/01/03  JJH			Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/*                                                                                                  */
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[DM0015_SAVE_BOD_DATA]
	@p_active_flag		NVARCHAR(MAX),
	@p_valid_yn			NVARCHAR(MAX),
	@p_division_id		NVARCHAR(MAX),
	@p_bod_id			NVARCHAR(MAX),
	@p_bod_type			NVARCHAR(MAX),
	@p_from_site		NVARCHAR(MAX),
	@p_pol				NVARCHAR(MAX),
	@p_pod				NVARCHAR(MAX),
	@p_hub_sloc			NVARCHAR(MAX),
	@p_to_site			NVARCHAR(MAX),
	@p_incoterms		NVARCHAR(MAX),
	@p_transport_mode	NVARCHAR(MAX),
	@p_priority			NVARCHAR(MAX),
	@p_per_mon			NVARCHAR(MAX),
	@p_per_tue			NVARCHAR(MAX),
	@p_per_wed			NVARCHAR(MAX),
	@p_per_thu			NVARCHAR(MAX),
	@p_per_fri			NVARCHAR(MAX),
	@p_per_sat			NVARCHAR(MAX),
	@p_per_sun			NVARCHAR(MAX),
	@p_fre_forwarder	NVARCHAR(MAX),
	@p_safety_stock		NVARCHAR(MAX),
	@p_pe1_lt			NVARCHAR(MAX),
	@p_pol_clr_lt		NVARCHAR(MAX),
	@p_pe2_lt			NVARCHAR(MAX),
	@p_pod_lt			NVARCHAR(MAX),
	@p_pe3_lt			NVARCHAR(MAX),
	@p_cust_lt          NVARCHAR(MAX),
	@p_user_id			NVARCHAR(MAX)

AS
BEGIN
	SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	DECLARE @recv_valid_yn		NVARCHAR(MAX);
	SET @recv_valid_yn = NULL;		
	SET @recv_valid_yn = @p_active_flag;

	DECLARE	@v_active_flag		NVARCHAR(MAX);
	DECLARE @v_valid_yn			NVARCHAR(MAX);
	DECLARE @v_division_id		NVARCHAR(MAX);
	DECLARE @v_bod_id			NVARCHAR(MAX);
	DECLARE @v_bod_type			NVARCHAR(MAX);
	DECLARE @v_from_site		NVARCHAR(MAX);
	DECLARE @v_pol				NVARCHAR(MAX);
	DECLARE @v_pod				NVARCHAR(MAX);
	DECLARE @v_hub_sloc			NVARCHAR(MAX);
	DECLARE @v_to_site			NVARCHAR(MAX);
	DECLARE @v_incoterms		NVARCHAR(MAX);
	DECLARE @v_transport_mode	NVARCHAR(MAX);
	DECLARE @v_priority			NVARCHAR(MAX);
	DECLARE @v_per_mon			NVARCHAR(MAX);
	DECLARE @v_per_tue			NVARCHAR(MAX);
	DECLARE @v_per_wed			NVARCHAR(MAX);
	DECLARE @v_per_thu			NVARCHAR(MAX);
	DECLARE @v_per_fri			NVARCHAR(MAX);
	DECLARE @v_per_sat			NVARCHAR(MAX);
	DECLARE @v_per_sun			NVARCHAR(MAX);
	DECLARE @v_fre_forwarder	NVARCHAR(MAX);
	DECLARE @v_safety_stock		numeric(20, 1);
	DECLARE @v_pe1_lt			int;
	DECLARE @v_pol_clr_lt		int;
	DECLARE @v_pe2_lt			int;
	DECLARE @v_pod_lt			int;
	DECLARE @v_pe3_lt			int;
	DECLARE @v_cust_lt          int;
	DECLARE @v_user_id			NVARCHAR(MAX);

	SET @v_active_flag = NULL;
	SET @v_valid_yn		=NULL;
	SET @v_division_id		=NULL;
	SET @v_bod_id			=NULL;
	SET @v_bod_type			=NULL;
	SET @v_from_site		=NULL;
	SET @v_pol				=NULL;
	SET @v_pod				=NULL;
	SET @v_hub_sloc			=NULL;
	SET @v_to_site			=NULL;
	SET @v_incoterms		=NULL;
	SET @v_transport_mode	=NULL;
	SET @v_priority			=NULL;
	SET @v_per_mon			=NULL;
	SET @v_per_tue			=NULL;
	SET @v_per_wed			=NULL;
	SET @v_per_thu			=NULL;
	SET @v_per_fri			=NULL;
	SET @v_per_sat			=NULL;
	SET @v_per_sun			=NULL;
	SET @v_fre_forwarder	=NULL;
	SET @v_safety_stock		=NULL;
	SET @v_pe1_lt			=NULL;
	SET @v_pol_clr_lt		=NULL;
	SET @v_pe2_lt			=NULL;
	SET @v_pod_lt			=NULL;
	SET @v_pe3_lt			=NULL;
	SET @v_cust_lt          =NULL;
	SET @v_user_id			=NULL;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^'
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	-- 자식 프로시저 성공/에러 셋팅
	--DECLARE	@v_OK_description		NVARCHAR(1200);	

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DM0015_SAVE_BOD_DATA';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	-- 시작 LOG  (END)
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

	BEGIN TRAN DM0015_SAVE_BOD_DATA;
	
	BEGIN TRY

		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_valid_yn, @v_delimiter);    
		--SELECT    @max_loop_cnt;
		--	WHILE LEN(@p_valid_yn) > 0
		WHILE LEN(@recv_valid_yn) > 0 AND @mst_loop_cnt < @max_loop_cnt

		BEGIN    
			
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;
			--SELECT @mst_loop_cnt,'@mst_loop_cnt'		

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			
		
			
			IF @mst_loop_cnt > 0 

				BEGIN       
				
				

				SET @v_valid_yn		=[dbo].[SCM_ARR_SPL_VAL]( @p_valid_yn	, @v_delimiter, @mst_loop_cnt) ;	
				SET @v_division_id		=[dbo].[SCM_ARR_SPL_VAL]( @p_division_id	, @v_delimiter, @mst_loop_cnt) ;	
				SET @v_bod_id			=[dbo].[SCM_ARR_SPL_VAL]( @p_bod_id			, @v_delimiter, @mst_loop_cnt) ;
				SET @v_bod_type			=[dbo].[SCM_ARR_SPL_VAL]( @p_bod_type		, @v_delimiter, @mst_loop_cnt) ;	
				SET @v_from_site		=[dbo].[SCM_ARR_SPL_VAL]( @p_from_site		, @v_delimiter, @mst_loop_cnt) ;
				SET @v_pol				=[dbo].[SCM_ARR_SPL_VAL]( @p_pol			, @v_delimiter, @mst_loop_cnt) ;	
				SET @v_pod				=[dbo].[SCM_ARR_SPL_VAL]( @p_pod			, @v_delimiter, @mst_loop_cnt) ;	
				SET @v_hub_sloc			=[dbo].[SCM_ARR_SPL_VAL]( @p_hub_sloc		, @v_delimiter, @mst_loop_cnt) ;	
				SET @v_to_site			=[dbo].[SCM_ARR_SPL_VAL]( @p_to_site		, @v_delimiter, @mst_loop_cnt) ;	
				SET @v_incoterms		=[dbo].[SCM_ARR_SPL_VAL]( @p_incoterms		, @v_delimiter, @mst_loop_cnt) ;
				SET @v_transport_mode	=[dbo].[SCM_ARR_SPL_VAL]( @p_transport_mode	, @v_delimiter, @mst_loop_cnt) ;
				SET @v_priority			=[dbo].[SCM_ARR_SPL_VAL]( @p_priority		, @v_delimiter, @mst_loop_cnt) ;	
				SET @v_per_mon			=[dbo].[SCM_ARR_SPL_VAL]( @p_per_mon		, @v_delimiter, @mst_loop_cnt) ;	
				SET @v_per_tue			=[dbo].[SCM_ARR_SPL_VAL]( @p_per_tue		, @v_delimiter, @mst_loop_cnt) ;	
				SET @v_per_wed			=[dbo].[SCM_ARR_SPL_VAL]( @p_per_wed		, @v_delimiter, @mst_loop_cnt) ;	
				SET @v_per_thu			=[dbo].[SCM_ARR_SPL_VAL]( @p_per_thu		, @v_delimiter, @mst_loop_cnt) ;	
				SET @v_per_fri			=[dbo].[SCM_ARR_SPL_VAL]( @p_per_fri		, @v_delimiter, @mst_loop_cnt) ;	
				SET @v_per_sat			=[dbo].[SCM_ARR_SPL_VAL]( @p_per_sat		, @v_delimiter, @mst_loop_cnt) ;	
				SET @v_per_sun			=[dbo].[SCM_ARR_SPL_VAL]( @p_per_sun		, @v_delimiter, @mst_loop_cnt) ;	
				SET @v_fre_forwarder	=[dbo].[SCM_ARR_SPL_VAL]( @p_fre_forwarder	, @v_delimiter, @mst_loop_cnt) ;
				SET @v_safety_stock		=cast([dbo].[SCM_ARR_SPL_VAL]( @p_safety_stock	, @v_delimiter, @mst_loop_cnt) 			 AS numeric(20,1));
				SET @v_pe1_lt			=cast([dbo].[SCM_ARR_SPL_VAL]( @p_pe1_lt			, @v_delimiter, @mst_loop_cnt) 		 AS int);
				SET @v_pol_clr_lt		=cast([dbo].[SCM_ARR_SPL_VAL]( @p_pol_clr_lt		, @v_delimiter, @mst_loop_cnt) 		 AS int);
				SET @v_pe2_lt			=cast([dbo].[SCM_ARR_SPL_VAL]( @p_pe2_lt			, @v_delimiter, @mst_loop_cnt) 		 AS int);
				SET @v_pod_lt			=cast([dbo].[SCM_ARR_SPL_VAL]( @p_pod_lt			, @v_delimiter, @mst_loop_cnt) 		 AS int);
				SET @v_pe3_lt			=cast([dbo].[SCM_ARR_SPL_VAL]( @p_pe3_lt			, @v_delimiter, @mst_loop_cnt) 		 AS int);
				SET @v_cust_lt          =cast([dbo].[SCM_ARR_SPL_VAL]( @p_cust_lt        , @v_delimiter, @mst_loop_cnt)   		 AS int);

				SET @v_user_id			=[dbo].[SCM_ARR_SPL_VAL]( @p_user_id		, @v_delimiter, @mst_loop_cnt) ;	

				--HISTORY INSERT

				EXEC [dbo].[PR_DM_MST_BOD_HIST]
					@v_division_id,
					@v_bod_id,
					@v_bod_type,
					@v_from_site,
					@v_pol,	
					@v_pod,
					@v_hub_sloc,
					@v_to_site,
					@v_incoterms,
					@v_transport_mode,
					@v_priority,
					@v_per_mon,
					@v_per_tue,
					@v_per_wed,
					@v_per_thu,
					@v_per_fri,
					@v_per_sat,
					@v_per_sun,
					@v_fre_forwarder,
					@v_safety_stock,
					@v_pe1_lt,
					@v_pol_clr_lt,
					@v_pe2_lt,
					@v_pod_lt,
					@v_pe3_lt,
					@v_cust_lt,
					@v_valid_yn,
					@v_user_id

					--@v_OK_description OUTPUT
					--SELECT @v_OK_description;

			 
					MERGE INTO [dbo].[SCM_MST_BOD] A
					USING (
							SELECT 
								@v_division_id	as division_id, 
								@v_bod_id		as bod_id
						  ) B
					ON(
							    A.division_id  = B.division_id
							AND A.bod_id	   = B.bod_id
					  )
					WHEN MATCHED THEN
						 UPDATE SET 
								DIVISION_ID				  =    		@v_division_id		,
								BOD_ID					  =	   		@v_bod_id		   	,
								BOD_TYPE				  =	   		@v_bod_type		   	,
								FROM_SITE				  =	   		@v_from_site		,
								POL						  =	   		@v_pol			   	,
								POD						  =	   		@v_pod			   	,
								HUB_SLOC				  =	   		@v_hub_sloc		   	,
								TO_SITE					  =	   		@v_to_site		   	,
								INCOTERMS				  =	   		@v_incoterms		,
								TRANSPORT_MODE			  =	   		@v_transport_mode  	,
								PRIORITY				  =	   		@v_priority		   	,
								PERIOD_SHIPSCH_MON		  =	   		@v_per_mon		   	,
								PERIOD_SHIPSCH_TUE		  =	   		@v_per_tue		   	,
								PERIOD_SHIPSCH_WED		  =	   		@v_per_wed		   	,
								PERIOD_SHIPSCH_THU		  =	   		@v_per_thu		   	,
								PERIOD_SHIPSCH_FRI		  =	   		@v_per_fri		   	,
								PERIOD_SHIPSCH_SAT		  =	   		@v_per_sat		   	,
								PERIOD_SHIPSCH_SUN		  =	   		@v_per_sun		   	,
								FREIGHT_FORWARDER		  =	   		@v_fre_forwarder	,
								SAFETY_STOCK			  =	   		@v_safety_stock	   	,
								PERIOD1_LT				  =	   		@v_pe1_lt		   	,
								POL_CLEARANCE_LT		  =	   		@v_pol_clr_lt	   	,
								PERIOD2_LT				  =	   		@v_pe2_lt		   	,
								POD_CLEARANCE_LT		  =	   		@v_pod_lt		   	,
								PERIOD3_LT				  =	   		@v_pe3_lt		   	,
								CUSTOMER_LT				  =	   		@v_cust_lt   		,				    
								VALID_YN				  =	     	@v_valid_yn	   	,
								LAST_UPDATED_BY			  =	   		@v_user_id		   	,
								LAST_UPDATE_DATE		  =			getdate()		

					WHEN NOT MATCHED THEN

						 INSERT (	DIVISION_ID		  ,
									BOD_ID			  ,
									BOD_TYPE		  ,
									FROM_SITE		  ,
									POL				  ,
									POD				  ,
									HUB_SLOC		  ,
									TO_SITE			  ,
									INCOTERMS		  ,
									TRANSPORT_MODE	  ,
									PRIORITY		  ,
									PERIOD_SHIPSCH_MON,
									PERIOD_SHIPSCH_TUE,
									PERIOD_SHIPSCH_WED,
									PERIOD_SHIPSCH_THU,
									PERIOD_SHIPSCH_FRI,
									PERIOD_SHIPSCH_SAT,
									PERIOD_SHIPSCH_SUN,
									FREIGHT_FORWARDER ,
									SAFETY_STOCK	  ,
									PERIOD1_LT		  ,
									POL_CLEARANCE_LT  ,
									PERIOD2_LT		  ,
									POD_CLEARANCE_LT  ,
									PERIOD3_LT		  ,
									CUSTOMER_LT		  ,
									VALID_YN		  ,
									CREATED_BY		  ,
									CREATION_DATE	  ,
									LAST_UPDATED_BY	  ,
									LAST_UPDATE_DATE

								)
						 VALUES (	@v_division_id		,
									(SELECT  MAX(CAST(BOD_ID AS INT)) FROM SCM_MST_BOD)+1		   	,
									@v_bod_type		   	,
									@v_from_site		,
									@v_pol			   	,
									@v_pod			   	,
									@v_hub_sloc		   	,
									@v_to_site		   	,
									@v_incoterms		,
									@v_transport_mode  	,
									@v_priority		   	,
									@v_per_mon		   	,
									@v_per_tue		   	,
									@v_per_wed		   	,
									@v_per_thu		   	,
									@v_per_fri		   	,
									@v_per_sat		   	,
									@v_per_sun		   	,
									@v_fre_forwarder	,
									@v_safety_stock	   	,
									@v_pe1_lt		   	,
									@v_pol_clr_lt	   	,
									@v_pe2_lt		   	,
									@v_pod_lt		   	,
									@v_pe3_lt		   	,
									@v_cust_lt   		,	
									@v_valid_yn	   	,
									@v_user_id		   	,
									getdate()			,
									@v_user_id		   	,
									getdate()		
								  
								  
								  
								);

			  END

			ELSE    --단일 ROW 일때
			 
				BEGIN        

				SET @v_division_id		= @p_division_id		
				SET @v_bod_id		   	= @p_bod_id		   	
				SET @v_bod_type		   	= @p_bod_type		   	
				SET @v_from_site		= @p_from_site		
				SET @v_pol			   	= @p_pol			   	
				SET @v_pod			   	= @p_pod			   	
				SET @v_hub_sloc		   	= @p_hub_sloc		   	
				SET @v_to_site		   	= @p_to_site		   	
				SET @v_incoterms		= @p_incoterms		
				SET @v_transport_mode  	= @p_transport_mode  	
				SET @v_priority		   	= @p_priority		   	
				SET @v_per_mon		   	= @p_per_mon		   	
				SET @v_per_tue		   	= @p_per_tue		   	
				SET @v_per_wed		   	= @p_per_wed		   	
				SET @v_per_thu		   	= @p_per_thu		   	
				SET @v_per_fri		   	= @p_per_fri		   	
				SET @v_per_sat		   	= @p_per_sat		   	
				SET @v_per_sun		   	= @p_per_sun		   	
				SET @v_fre_forwarder	= @p_fre_forwarder	
				SET @v_safety_stock	   	= @p_safety_stock	   	
				SET @v_pe1_lt		   	= @p_pe1_lt		   	
				SET @v_pol_clr_lt	   	= @p_pol_clr_lt	   	
				SET @v_pe2_lt		   	= @p_pe2_lt		   	
				SET @v_pod_lt		   	= @p_pod_lt		   	
				SET @v_pe3_lt		   	= @p_pe3_lt		   	
				SET @v_cust_lt   		= @p_cust_lt   		
				SET @v_valid_yn	   		= @p_valid_yn	   	
				SET @v_user_id		   	= @p_user_id		   	


				--HISTORY INSERT

				EXEC [dbo].[PR_DM_MST_BOD_HIST]
					@v_division_id,
					@v_bod_id,
					@v_bod_type,
					@v_from_site,
					@v_pol,	
					@v_pod,
					@v_hub_sloc,
					@v_to_site,
					@v_incoterms,
					@v_transport_mode,
					@v_priority,
					@v_per_mon,
					@v_per_tue,
					@v_per_wed,
					@v_per_thu,
					@v_per_fri,
					@v_per_sat,
					@v_per_sun,
					@v_fre_forwarder,
					@v_safety_stock,
					@v_pe1_lt,
					@v_pol_clr_lt,
					@v_pe2_lt,
					@v_pod_lt,
					@v_pe3_lt,
					@v_cust_lt,
					@v_valid_yn,
					@v_user_id

					--@v_OK_description OUTPUT
					--SELECT @v_OK_description;
			 
					
					MERGE INTO [dbo].[SCM_MST_BOD] A
					USING (
							SELECT 
								@v_division_id	as division_id, 
								@v_bod_id		as bod_id
						  ) B
					ON(
							    A.division_id  = B.division_id
							AND A.bod_id	   = B.bod_id
					  )
					WHEN MATCHED THEN
						 UPDATE SET 
								DIVISION_ID				  =    		@v_division_id		,
								BOD_ID					  =	   		@v_bod_id		   	,
								BOD_TYPE				  =	   		@v_bod_type		   	,
								FROM_SITE				  =	   		@v_from_site		,
								POL						  =	   		@v_pol			   	,
								POD						  =	   		@v_pod			   	,
								HUB_SLOC				  =	   		@v_hub_sloc		   	,
								TO_SITE					  =	   		@v_to_site		   	,
								INCOTERMS				  =	   		@v_incoterms		,
								TRANSPORT_MODE			  =	   		@v_transport_mode  	,
								PRIORITY				  =	   		@v_priority		   	,
								PERIOD_SHIPSCH_MON		  =	   		@v_per_mon		   	,
								PERIOD_SHIPSCH_TUE		  =	   		@v_per_tue		   	,
								PERIOD_SHIPSCH_WED		  =	   		@v_per_wed		   	,
								PERIOD_SHIPSCH_THU		  =	   		@v_per_thu		   	,
								PERIOD_SHIPSCH_FRI		  =	   		@v_per_fri		   	,
								PERIOD_SHIPSCH_SAT		  =	   		@v_per_sat		   	,
								PERIOD_SHIPSCH_SUN		  =	   		@v_per_sun		   	,
								FREIGHT_FORWARDER		  =	   		@v_fre_forwarder	,
								SAFETY_STOCK			  =	   		@v_safety_stock	   	,
								PERIOD1_LT				  =	   		@v_pe1_lt		   	,
								POL_CLEARANCE_LT		  =	   		@v_pol_clr_lt	   	,
								PERIOD2_LT				  =	   		@v_pe2_lt		   	,
								POD_CLEARANCE_LT		  =	   		@v_pod_lt		   	,
								PERIOD3_LT				  =	   		@v_pe3_lt		   	,
								CUSTOMER_LT				  =	   		@v_cust_lt   		,				    
								VALID_YN				  =	     	@v_valid_yn	   	,
								LAST_UPDATED_BY			  =	   		@v_user_id		   	,
								LAST_UPDATE_DATE		  =			getdate()		

					WHEN NOT MATCHED THEN

						 INSERT (	DIVISION_ID		  ,
									BOD_ID			  ,
									BOD_TYPE		  ,
									FROM_SITE		  ,
									POL				  ,
									POD				  ,
									HUB_SLOC		  ,
									TO_SITE			  ,
									INCOTERMS		  ,
									TRANSPORT_MODE	  ,
									PRIORITY		  ,
									PERIOD_SHIPSCH_MON,
									PERIOD_SHIPSCH_TUE,
									PERIOD_SHIPSCH_WED,
									PERIOD_SHIPSCH_THU,
									PERIOD_SHIPSCH_FRI,
									PERIOD_SHIPSCH_SAT,
									PERIOD_SHIPSCH_SUN,
									FREIGHT_FORWARDER ,
									SAFETY_STOCK	  ,
									PERIOD1_LT		  ,
									POL_CLEARANCE_LT  ,
									PERIOD2_LT		  ,
									POD_CLEARANCE_LT  ,
									PERIOD3_LT		  ,
									CUSTOMER_LT		  ,
									VALID_YN		  ,
									CREATED_BY		  ,
									CREATION_DATE	  ,
									LAST_UPDATED_BY	  ,
									LAST_UPDATE_DATE

								)
						 VALUES (	@v_division_id		,
									(SELECT  MAX(CAST(BOD_ID AS INT)) FROM SCM_MST_BOD)+1		   	,
									@v_bod_type		   	,
									@v_from_site		,
									@v_pol			   	,
									@v_pod			   	,
									@v_hub_sloc		   	,
									@v_to_site		   	,
									@v_incoterms		,
									@v_transport_mode  	,
									@v_priority		   	,
									@v_per_mon		   	,
									@v_per_tue		   	,
									@v_per_wed		   	,
									@v_per_thu		   	,
									@v_per_fri		   	,
									@v_per_sat		   	,
									@v_per_sun		   	,
									@v_fre_forwarder	,
									@v_safety_stock	   	,
									@v_pe1_lt		   	,
									@v_pol_clr_lt	   	,
									@v_pe2_lt		   	,
									@v_pod_lt		   	,
									@v_pe3_lt		   	,
									@v_cust_lt   		,	
									@v_valid_yn	   	,
									@v_user_id		   	,
									getdate()			,
									@v_user_id		   	,
									getdate()		
								  
								  
								);

				END
			END

			COMMIT  ;	

		END TRY
				

	BEGIN CATCH

		-- ROLLBACK
		ROLLBACK TRAN DM0015_SAVE_BOD_DATA;	

		-- ERROR LOG
		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();

		-- 자식 프로시저 에러발생 원인분석
		--IF @v_OK_description <> 'OK'
		--SET @v_log_message = CAST(@v_OK_description AS NVARCHAR(1000));

		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();

    END CATCH;

	--select 'success'

		-- 종료 LOG
		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();

		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;						

