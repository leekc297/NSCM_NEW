/*
 * Program ID   : [SCP0007_SAVE_BOD]
 * Description  : BOD 등록, 수정
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/03/14   pjs				Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/06/25   ygkimn			전극 관련 로직 추가(@p_input_status = 'R'이고 @p_vmi_yn = 'Y' 일 경우 Incoterms 'DAP'로 데이터 생성
 * 2018/07/13   ygkim			DAP 체크 쿼리 조건 INCOTERMS -> TRANSPORT_MODE 로 변경
 * 2018/07/17   ygkim			DAP 체크 쿼리 조건 INCOTERMS, TRANSPORT_MODE 추가
 * 2020/09/01   KSW             PJ20202001R    LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : 법인간 거래 Incoterms 동기화
 *                              SSP용 Incoterms 컬럼 추가 <== SCP_MST_BOD.attribute1
 * 2021/05/10   khj79           [PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선 - BOD LT 1단계 개발(BEFORE_LEAD_TIME, AFTER_LEAD_TIME,REMARKS 추가)
 * 2021/06/10   khj79           [PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선 - BOD LT 2단계 개발(FROM_YYYYMMDD, TO_YYYYMMDD 추가)
 * 2026/06/16	YMH				E20260616-000549  BOD 중복 입력 Validation 오류 수정 요청
 */
CREATE PROCEDURE [dbo].[SCP0007_SAVE_BOD]
	 @p_active_flag 		NVARCHAR(MAX)
	,@p_bod_id				NVARCHAR(MAX)
	,@p_division_id			NVARCHAR(MAX)
	,@p_customer_code		NVARCHAR(MAX)
	,@p_from_site			NVARCHAR(MAX)
	,@p_to_site				NVARCHAR(MAX)
	,@p_incoterms			NVARCHAR(MAX)
	,@p_incoterms_ssp		NVARCHAR(MAX)
	,@p_priority			NVARCHAR(MAX)
	,@p_route_id			NVARCHAR(MAX)
	,@p_safety_stock		NVARCHAR(MAX)
	,@p_input_status		NVARCHAR(MAX)
	,@p_vmi_yn				NVARCHAR(MAX)
	,@p_from_yyyymmdd		NVARCHAR(MAX)
	,@p_to_yyyymmdd			NVARCHAR(MAX)
	,@p_before_lead_time	NVARCHAR(MAX)
	,@p_after_lead_time		NVARCHAR(MAX)
	,@p_remarks				NVARCHAR(MAX)
	,@p_valid_yn			NVARCHAR(MAX)
	,@p_user_id				NVARCHAR(MAX)
	
	,@debug_mode          NVARCHAR(1) ='F'
AS

BEGIN

	--SET NOCOUNT ON;
	--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
	
	--DECLARE @DEBUG_MODE NVARCHAR(20) ='FALSE';
	--DECLARE @DEBUG_MODE NVARCHAR(20) ='TRUE';
	DECLARE @v_working_time       datetime =sysdatetime();     
	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;


	DECLARE @v_active_flag       NVARCHAR(MAX);  
	DECLARE @v_bod_id            NVARCHAR(MAX);  
	DECLARE @v_division_id       NVARCHAR(MAX);   
	DECLARE @v_customer_code     NVARCHAR(MAX);   
	DECLARE @v_from_site         NVARCHAR(MAX);   
	DECLARE @v_to_site           NVARCHAR(MAX);   
	DECLARE @v_incoterms         NVARCHAR(MAX);   
	DECLARE @v_incoterms_ssp     NVARCHAR(MAX);         -- SSP용 Incoterms 추가
	DECLARE @v_priority          NVARCHAR(MAX);   
	DECLARE @v_route_id          NVARCHAR(MAX);   
	DECLARE @v_valid_yn          NVARCHAR(MAX);   
	DECLARE @v_created_by        NVARCHAR(MAX);
	DECLARE @v_creation_date     datetime	;
	DECLARE @v_last_updated_by   NVARCHAR(MAX);
	DECLARE @v_last_update_date  datetime	;

	DECLARE @v_safety_stock			NVARCHAR(MAX);
	DECLARE @v_vmi_yn				NVARCHAR(MAX);
	DECLARE @v_from_yyyymmdd		NVARCHAR(8);
	DECLARE @v_to_yyyymmdd			NVARCHAR(8);
	DECLARE @v_before_lead_time		NVARCHAR(MAX);
	DECLARE @v_after_lead_time      NVARCHAR(MAX);
	DECLARE @v_remarks				NVARCHAR(MAX);
	DECLARE @v_bod_new_list			NVARCHAR(MAX);  -- BOD 2단계 : 신규
	DECLARE @v_bod_list				NVARCHAR(MAX);  -- BOD 2단계 : 전체(신규 + 수정)
	
	DECLARE @v_transport_mode    NVARCHAR(100) = ''; --에러반환용


	SET @v_created_by       = @p_user_id;
	SET @v_creation_date    = @v_working_time;
	SET @v_last_updated_by  = @p_user_id
	SET @v_last_update_date = @v_working_time

	PRINT ' @v_last_updated_by ='+@v_last_updated_by;

	SET @v_active_flag   = NULL;
	SET @v_bod_id        = NULL;
	SET @v_division_id   = NULL;
	SET @v_customer_code = NULL;
	SET @v_from_site     = NULL;
	SET @v_to_site       = NULL;
	SET @v_incoterms     = NULL;
	SET @v_incoterms_ssp = NULL;      -- SSP용 Incoterms 추가
	SET @v_priority      = NULL;
	SET @v_route_id      = NULL;
	SET @v_valid_yn      = NULL;
	SET @v_safety_stock  = NULL;

	SET @v_vmi_yn			= NULL;
	SET @v_before_lead_time	= NULL;
	SET @v_after_lead_time	= NULL;
	SET @v_remarks			= NULL;
	SET @v_bod_new_list		= NULL;
	--SET @debug_mode	

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	DECLARE @mst_loop_cnt_chk	INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = '[SCP0007_SAVE_BOD]';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;


	DECLARE @v_data_dup_cnt  INT=0;
	DECLARE @v_data_dup_priority_cnt  INT=0;
	DECLARE @v_data_loop_cnt INT=0; -- BOD 건수 확인(기간 체크를 위한 건수)
	
	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';
	
	-- 트렌젝션 시작
	BEGIN TRAN;

	BEGIN TRY

			-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);    

		
		
		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN    
				
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;			

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN

				SET @v_active_flag   = dbo.SCM_ARR_SPL_VAL( @p_active_flag       , @v_delimiter, @mst_loop_cnt );
				SET @v_bod_id        = dbo.SCM_ARR_SPL_VAL( @p_bod_id            , @v_delimiter, @mst_loop_cnt );
				SET @v_division_id   = dbo.SCM_ARR_SPL_VAL( @p_division_id       , @v_delimiter, @mst_loop_cnt );
				SET @v_customer_code = dbo.SCM_ARR_SPL_VAL( @p_customer_code     , @v_delimiter, @mst_loop_cnt );
				SET @v_from_site     = dbo.SCM_ARR_SPL_VAL( @p_from_site         , @v_delimiter, @mst_loop_cnt );
				SET @v_to_site       = dbo.SCM_ARR_SPL_VAL( @p_to_site           , @v_delimiter, @mst_loop_cnt );
				SET @v_incoterms     = dbo.SCM_ARR_SPL_VAL( @p_incoterms         , @v_delimiter, @mst_loop_cnt );
				SET @v_incoterms_ssp = dbo.SCM_ARR_SPL_VAL( @p_incoterms_ssp     , @v_delimiter, @mst_loop_cnt );     -- SSP용 Incoterms 추가
				SET @v_priority      = dbo.SCM_ARR_SPL_VAL( @p_priority          , @v_delimiter, @mst_loop_cnt );
				SET @v_route_id      = dbo.SCM_ARR_SPL_VAL( @p_route_id          , @v_delimiter, @mst_loop_cnt );
				SET @v_valid_yn      = dbo.SCM_ARR_SPL_VAL( @p_valid_yn          , @v_delimiter, @mst_loop_cnt );
				SET @v_safety_stock  = dbo.SCM_ARR_SPL_VAL( @p_safety_stock      , @v_delimiter, @mst_loop_cnt );

				SET @v_vmi_yn			= dbo.SCM_ARR_SPL_VAL( @p_vmi_yn			, @v_delimiter, @mst_loop_cnt );  
				SET @v_from_yyyymmdd	= dbo.SCM_ARR_SPL_VAL( @p_from_yyyymmdd		, @v_delimiter, @mst_loop_cnt );-- PJ20209642 : BOD LT 2단계 개발
				SET @v_to_yyyymmdd		= dbo.SCM_ARR_SPL_VAL( @p_to_yyyymmdd		, @v_delimiter, @mst_loop_cnt );-- PJ20209642 : BOD LT 2단계 개발
				SET @v_before_lead_time = dbo.SCM_ARR_SPL_VAL( @p_before_lead_time	, @v_delimiter, @mst_loop_cnt );-- PJ20209642 : BOD LT 1단계 개발
				SET @v_after_lead_time  = dbo.SCM_ARR_SPL_VAL( @p_after_lead_time	, @v_delimiter, @mst_loop_cnt );-- PJ20209642 : BOD LT 1단계 개발
				SET @v_remarks			= dbo.SCM_ARR_SPL_VAL( @p_remarks			, @v_delimiter, @mst_loop_cnt );-- PJ20209642 : BOD LT 1단계 개발

			END;

			-- LOOP 파라미터 출력 DEBUG용			
			IF (@debug_mode ='T') 
			BEGIN		
				PRINT '=================INPUT==============================';			
				PRINT '@mst_loop_cnt     = ' + CONVERT(VARCHAR,@mst_loop_cnt)   ;
				PRINT '@v_active_flag    = ' + @v_active_flag   ;
				PRINT '@v_bod_id         = ' + @v_bod_id        ;
				PRINT '@v_division_id    = ' + @v_division_id   ;
				PRINT '@v_customer_code  = ' + @v_customer_code ;
				PRINT '@v_from_site      = ' + @v_from_site     ;
				PRINT '@v_to_site        = ' + @v_to_site       ;
				PRINT '@v_incoterms      = ' + @v_incoterms     ;
				PRINT '@v_incoterms_ssp  = ' + @v_incoterms_ssp ;
				PRINT '@v_priority       = ' + @v_priority      ;
				PRINT '@v_route_id       = ' + @v_route_id      ;
				PRINT '@v_valid_yn       = ' + @v_valid_yn      ;
				PRINT '@v_safety_stock   = ' + @v_safety_stock    ;
				PRINT '@v_vmi_yn			= ' + @v_vmi_yn    ;
				PRINT '@p_input_status		= ' + @p_input_status    ;
				PRINT '@v_from_yyyymmdd		= ' + @v_from_yyyymmdd;
				PRINT '@v_to_yyyymmdd		= ' + @v_to_yyyymmdd;
				PRINT '@v_before_lead_time  = ' + @v_before_lead_time;
				PRINT '@v_after_lead_time   = ' + @v_after_lead_time;
				PRINT '@v_remarks			= ' + @v_remarks    ;

			END;

			SET @v_transport_mode ='';
			SET @v_transport_mode =(SELECT TRANSPORT_MODE FROM scp_mst_distribution_route WHERE ROUTE_ID = @v_route_id );


			-- PK생성
			IF( isnull(@v_bod_id,'') ='')
				BEGIN
					SET @v_bod_id=NEXT VALUE FOR SEQ1_SCP_MST_BOD
					--SELECT @v_bod_id= CONVERT(numeric, ISNULL(MAX(bod_id),0)) +1  FROM SCP_MST_BOD;
					IF (@debug_mode ='T') 
					BEGIN	
						PRINT ' CREATE PK @v_bod_id  = ' + @v_bod_id      ;
					END; 

				END

			IF( isnull(@v_bod_list,'') ='')
				BEGIN
					SET @v_bod_list = @v_bod_id;
				END
				ELSE
				BEGIN
					SET @v_bod_list = @v_bod_list + @v_delimiter + @v_bod_id;
				END

				
		    --이력저장
			EXEC [dbo].[PR_SCP_MST_BOD_HIST]
					 @v_bod_id           
					,@v_division_id      
					,@v_from_site        
					,@v_to_site          
					,@v_incoterms
					,@v_incoterms_ssp          -- SSP용 Incoterms 추가
					,@v_safety_stock     
					,@v_priority         
					,@v_route_id         
					,@v_valid_yn
					,@v_from_yyyymmdd		-- PJ20209642 : BOD LT 2단계 개발
					,@v_to_yyyymmdd			-- PJ20209642 : BOD LT 2단계 개발
					,@v_before_lead_time	-- PJ20209642 : BOD LT 1단계 개발
					,@v_after_lead_time		-- PJ20209642 : BOD LT 1단계 개발
					,@v_remarks				-- PJ20209642 : BOD LT 1단계 개발
					,@v_created_by       
					,@v_creation_date    
					,@v_last_updated_by  
					,@v_last_update_date ;

			--데이터 저장
			IF @mst_loop_cnt > 0 			
				BEGIN		
					-- 수정
					IF( @v_active_flag ='M' OR @v_active_flag ='I') 
						BEGIN
							MERGE INTO SCP_MST_BOD A
							USING (
									SELECT @v_bod_id as bod_id
									) B
							ON(
										A.bod_id = B.bod_id
								)
							WHEN MATCHED THEN
								UPDATE 
								   SET division_id      = @v_division_id      
									  ,safety_stock     = (CASE WHEN @v_safety_stock ='' THEN NULL ELSE @v_safety_stock END)   
									  ,from_site        = @v_from_site        
									  ,to_site          = @v_to_site          
									  ,incoterms        = @v_incoterms    
									  ,attribute1       = @v_incoterms_ssp       -- SSP용 Incoterms 추가
									  ,priority         = @v_priority         
									  ,route_id         = @v_route_id         
									  ,valid_yn         = @v_valid_yn
									  ,attribute2       = @v_from_yyyymmdd					-- PJ20209642 : BOD LT 2단계 개발
									  ,attribute3       = @v_to_yyyymmdd					-- PJ20209642 : BOD LT 1단계 개발
									  ,attribute4       = ISNULL(@v_before_lead_time,0)		-- PJ20209642 : BOD LT 1단계 개발
									  ,attribute5       = ISNULL(@v_after_lead_time,0)		-- PJ20209642 : BOD LT 1단계 개발
									  ,attribute6       = @v_remarks						-- PJ20209642 : BOD LT 1단계 개발
									  ,last_updated_by  = @v_last_updated_by  
									  ,last_update_date = @v_last_update_date 
					                
							WHEN NOT MATCHED THEN							                                             
								INSERT 
									   (bod_id
									   ,division_id
									   ,safety_stock
									   ,from_site
									   ,to_site
									   ,incoterms
									   ,attribute1           -- SSP용 Incoterms 추가
									   ,priority
									   ,route_id
									   ,valid_yn
									   ,attribute2		-- PJ20209642 : BOD LT 2단계 개발
									   ,attribute3		-- PJ20209642 : BOD LT 2단계 개발
									   ,attribute4		-- PJ20209642 : BOD LT 1단계 개발
									   ,attribute5		-- PJ20209642 : BOD LT 1단계 개발
									   ,attribute6		-- PJ20209642 : BOD LT 1단계 개발
									   ,created_by
									   ,creation_date
									   ,last_updated_by
									   ,last_update_date
									   )
								 VALUES
									   ( @v_bod_id                
										,@v_division_id           
										,(CASE WHEN @v_safety_stock ='' THEN NULL ELSE @v_safety_stock END) 
										,@v_from_site             
										,@v_to_site               
										,@v_incoterms    
										,@v_incoterms_ssp    -- SSP용 Incoterms 추가
										,@v_priority              
										,@v_route_id              
										,@v_valid_yn
										,@v_from_yyyymmdd					-- PJ20209642 : BOD LT 2단계 개발
										,@v_to_yyyymmdd						-- PJ20209642 : BOD LT 2단계 개발
										,ISNULL(@v_before_lead_time,0)		-- PJ20209642 : BOD LT 1단계 개발
										,ISNULL(@v_after_lead_time,0)		-- PJ20209642 : BOD LT 1단계 개발
										,@v_remarks							-- PJ20209642 : BOD LT 1단계 개발
										,@v_created_by            
										,@v_creation_date         
										,@v_last_updated_by       
										,@v_last_update_date      
									   ); 

									    -- BOD_ITEM 수정
										UPDATE SCP_MST_BOD_ITEM
										   SET from_yyyymmdd	= @v_from_yyyymmdd
											 , to_yyyymmdd		= @v_to_yyyymmdd
											 , last_updated_by  = @v_created_by
											 , last_update_date = @v_last_update_date
										 WHERE BOD_ID = @v_bod_id;
										 ;

								--전극 로직 추가
								--Input Status Required 이고 To Site VMI 'Y' 인 경우 Incoterms 'DAP'로 데이터 넣어준다.
								IF @p_input_status = 'R' AND @v_vmi_yn = 'Y'
									BEGIN
										SET @v_data_dup_cnt  =0;

										SET @v_incoterms = 'DAP';

										-- 중복체크
										SELECT @v_data_dup_cnt = COUNT(*) 			
										  FROM SCP_MST_BOD A
											  INNER JOIN scp_mst_distribution_route B ON A.ROUTE_ID = B.ROUTE_ID
										 WHERE A.DIVISION_ID     = @v_division_id
										   AND A.FROM_SITE       = @v_from_site
										   AND A.TO_SITE         = @v_to_site
										   AND A.INCOTERMS       = @v_incoterms
										   AND B.TRANSPORT_MODE  = @v_transport_mode

										IF( @v_data_dup_cnt = 0)
											BEGIN
												SET @v_bod_id=NEXT VALUE FOR SEQ1_SCP_MST_BOD

												MERGE INTO SCP_MST_BOD A
												USING (
														SELECT @v_bod_id as bod_id
														) B
												ON(
															A.bod_id = B.bod_id
													)
												WHEN MATCHED THEN
													UPDATE 
													   SET division_id      = @v_division_id      
														  ,safety_stock     = (CASE WHEN @v_safety_stock ='' THEN NULL ELSE @v_safety_stock END)   
														  ,from_site        = @v_from_site        
														  ,to_site          = @v_to_site          
														  ,incoterms        = @v_incoterms      
														  ,attribute1       = @v_incoterms_ssp      -- SSP용 Incoterms 추가
														  ,priority         = @v_priority         
														  ,route_id         = @v_route_id         
														  ,valid_yn         = @v_valid_yn
														  ,attribute2       = @v_from_yyyymmdd					-- PJ20209642 : BOD LT 2단계 개발
														  ,attribute3       = @v_to_yyyymmdd					-- PJ20209642 : BOD LT 1단계 개발
														  ,attribute4       = ISNULL(@v_before_lead_time,0)		-- PJ20209642 : BOD LT 1단계 개발
														  ,attribute5       = ISNULL(@v_after_lead_time,0)		-- PJ20209642 : BOD LT 1단계 개발
														  ,attribute6       = @v_remarks						-- PJ20209642 : BOD LT 1단계 개발
														  ,last_updated_by  = @v_last_updated_by  
														  ,last_update_date = @v_last_update_date 
					                
												WHEN NOT MATCHED THEN							                                             
													INSERT 
														   (bod_id
														   ,division_id
														   ,safety_stock
														   ,from_site
														   ,to_site
														   ,incoterms
														   ,attribute1        -- SSP용 Incoterms 추가
														   ,priority
														   ,route_id
														   ,valid_yn
														   ,attribute2			-- PJ20209642 : BOD LT 2단계 개발
														   ,attribute3			-- PJ20209642 : BOD LT 2단계 개발
														   ,attribute4			-- PJ20209642 : BOD LT 1단계 개발
														   ,attribute5			-- PJ20209642 : BOD LT 1단계 개발
														   ,attribute6			-- PJ20209642 : BOD LT 1단계 개발
														   ,created_by
														   ,creation_date
														   ,last_updated_by
														   ,last_update_date
														   )
													 VALUES
														   ( @v_bod_id                
															,@v_division_id           
															,(CASE WHEN @v_safety_stock ='' THEN NULL ELSE @v_safety_stock END) 
															,@v_from_site             
															,@v_to_site               
															,@v_incoterms           
															,@v_incoterms_ssp      -- SSP용 Incoterms 추가
															,@v_priority              
															,@v_route_id              
															,@v_valid_yn
															,@v_from_yyyymmdd				-- PJ20209642 : BOD LT 2단계 개발
															,@v_to_yyyymmdd					-- PJ20209642 : BOD LT 2단계 개발
															,ISNULL(@v_before_lead_time,0)	-- PJ20209642 : BOD LT 1단계 개발
															,ISNULL(@v_after_lead_time,0)	-- PJ20209642 : BOD LT 1단계 개발
															,@v_remarks						-- PJ20209642 : BOD LT 1단계 개발
															,@v_created_by            
															,@v_creation_date         
															,@v_last_updated_by       
															,@v_last_update_date      
														   ); 


													-- BOD_ITEM 수정
													UPDATE SCP_MST_BOD_ITEM
													   SET from_yyyymmdd	= @v_from_yyyymmdd
														 , to_yyyymmdd		= @v_to_yyyymmdd
														 , last_updated_by  = @v_created_by
														 , last_update_date = @v_last_update_date
													 WHERE BOD_ID = @v_bod_id;

												--SELECT @v_bod_id= CONVERT(numeric, ISNULL(MAX(bod_id),0)) +1  FROM SCP_MST_BOD;
												IF (@debug_mode ='T') 
												BEGIN	
													PRINT ' CREATE PK @v_bod_id  = ' + @v_bod_id      ;
												END; 

											END

										--이력저장
										EXEC [dbo].[PR_SCP_MST_BOD_HIST]
													@v_bod_id           
												,@v_division_id      
												,@v_from_site        
												,@v_to_site          
												,@v_incoterms      
												,@v_incoterms_ssp      -- SSP용 Incoterms 추가
												,@v_safety_stock     
												,@v_priority         
												,@v_route_id         
												,@v_valid_yn
												,@v_from_yyyymmdd		-- PJ20209642 : BOD LT 2단계 개발
												,@v_to_yyyymmdd			-- PJ20209642 : BOD LT 2단계 개발
												,@v_before_lead_time	-- PJ20209642 : BOD LT 1단계 개발
												,@v_after_lead_time		-- PJ20209642 : BOD LT 1단계 개발
												,@v_remarks				-- PJ20209642 : BOD LT 1단계 개발
												,@v_created_by       
												,@v_creation_date    
												,@v_last_updated_by  
												,@v_last_update_date ;
									END;
							END ;
					ELSE IF(@v_active_flag ='D')
						BEGIN
							DELETE FROM dbo.SCP_MST_BOD
							WHERE bod_id   = @v_bod_id 
							
							;     
						END; 	
				END  -- END OF STMT. IF( @mst_loop_cnt > 0 )			
			
		END -- END OF STMT. WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
		
		SET @v_active_flag   = NULL;
		SET @v_bod_id        = NULL;
		SET @v_division_id   = NULL;
		SET @v_customer_code = NULL;
		SET @v_from_site     = NULL;
		SET @v_to_site       = NULL;
		SET @v_incoterms     = NULL;
		SET @v_incoterms_ssp = NULL;        -- SSP용 Incoterms 추가
		SET @v_priority      = NULL;
		SET @v_route_id      = NULL;
		SET @v_valid_yn      = NULL;
		SET @v_safety_stock  = NULL;
		SET @v_vmi_yn        = NULL;
		SET @v_from_yyyymmdd = NULL;	-- PJ20209642 : BOD LT 2단계 개발
		SET @v_to_yyyymmdd	 = NULL;	-- PJ20209642 : BOD LT 2단계 개발

		/* 중복체크 */
		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt_chk < @max_loop_cnt
		BEGIN    
				
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt_chk = @mst_loop_cnt_chk + 1;			

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN

				SET @v_active_flag   = dbo.SCM_ARR_SPL_VAL( @p_active_flag       , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_bod_id        = dbo.SCM_ARR_SPL_VAL( @p_bod_id            , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_division_id   = dbo.SCM_ARR_SPL_VAL( @p_division_id       , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_customer_code = dbo.SCM_ARR_SPL_VAL( @p_customer_code     , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_from_site     = dbo.SCM_ARR_SPL_VAL( @p_from_site         , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_to_site       = dbo.SCM_ARR_SPL_VAL( @p_to_site           , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_incoterms     = dbo.SCM_ARR_SPL_VAL( @p_incoterms         , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_incoterms_ssp = dbo.SCM_ARR_SPL_VAL( @p_incoterms_ssp     , @v_delimiter, @mst_loop_cnt_chk );      -- SSP용 Incoterms 추가
				SET @v_priority      = dbo.SCM_ARR_SPL_VAL( @p_priority          , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_route_id      = dbo.SCM_ARR_SPL_VAL( @p_route_id          , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_valid_yn      = dbo.SCM_ARR_SPL_VAL( @p_valid_yn          , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_safety_stock  = dbo.SCM_ARR_SPL_VAL( @p_safety_stock      , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_vmi_yn        = dbo.SCM_ARR_SPL_VAL( @p_vmi_yn			 , @v_delimiter, @mst_loop_cnt );
				SET @v_from_yyyymmdd = dbo.SCM_ARR_SPL_VAL( @p_from_yyyymmdd	 , @v_delimiter, @mst_loop_cnt_chk );
				SET @v_to_yyyymmdd	 = dbo.SCM_ARR_SPL_VAL( @p_to_yyyymmdd		 , @v_delimiter, @mst_loop_cnt_chk );


			END;

			-- LOOP 파라미터 출력 DEBUG용			
			IF (@debug_mode ='T') 
			BEGIN		
				PRINT '================DUP CHK============================';			
				PRINT '@mst_loop_cnt     = ' + CONVERT(VARCHAR,@mst_loop_cnt_chk)   ;
				PRINT '@v_active_flag    = ' + @v_active_flag   ;
				PRINT '@v_bod_id         = ' + @v_bod_id        ;
				PRINT '@v_division_id    = ' + @v_division_id   ;
				PRINT '@v_customer_code  = ' + @v_customer_code ;
				PRINT '@v_from_site      = ' + @v_from_site     ;
				PRINT '@v_to_site        = ' + @v_to_site       ;
				PRINT '@v_incoterms      = ' + @v_incoterms     ;
				PRINT '@v_incoterms_ssp  = ' + @v_incoterms_ssp ;      -- SSP용 Incoterms 추가
				PRINT '@v_priority       = ' + @v_priority      ;
				PRINT '@v_route_id       = ' + @v_route_id      ;
				PRINT '@v_valid_yn       = ' + @v_valid_yn      ;
				PRINT '@v_safety_stock   = ' + @v_safety_stock    ;
				PRINT '@v_vmi_yn         = ' + @v_vmi_yn    ;
				PRINT '@v_from_yyyymmdd  = ' + @v_from_yyyymmdd    ;
				PRINT '@v_to_yyyymmdd    = ' + @v_to_yyyymmdd    ;
				PRINT '@p_input_status   = ' + @p_input_status    ;
			END;

			IF @p_input_status = 'R' AND @v_vmi_yn = 'Y'
				BEGIN
					SET @v_incoterms = 'DAP'
				END

			SET @v_data_dup_cnt  =0;

			-- E20260616-000549  BOD 중복 입력 Validation 오류 수정 요청 추가로직 시작
			SET @v_transport_mode ='';
			SET @v_transport_mode =(SELECT TRANSPORT_MODE FROM scp_mst_distribution_route WHERE ROUTE_ID = @v_route_id );
			-- E20260616-000549  BOD 중복 입력 Validation 오류 수정 요청 추가로직 끝


			-- trans mode 중복체크
			SELECT @v_data_dup_cnt = COUNT(*) 			
			  FROM SCP_MST_BOD A
				  INNER JOIN scp_mst_distribution_route B ON A.ROUTE_ID = B.ROUTE_ID
			 WHERE A.DIVISION_ID     = @v_division_id
			   --AND A.CUSTOMER_CODE   = @v_customer_code
			   AND A.FROM_SITE       = @v_from_site
			   AND A.TO_SITE         = @v_to_site
			   AND A.INCOTERMS       = @v_incoterms
			   AND B.TRANSPORT_MODE  = @v_transport_mode
			   -------------------------------------------
			   AND A.ATTRIBUTE3      >= @v_from_yyyymmdd  -- to 
			   AND A.ATTRIBUTE2		 <= @v_to_yyyymmdd    -- from
			   -------------------------------------------
			  -- AND ( ISNULL(@v_bod_id,'')=''  OR  A.BOD_ID  != @v_bod_id ) --자기 자신은 제외하고 체크
			   ;

			IF (@debug_mode ='T') 
			BEGIN	
				PRINT '@v_transport_mode  = ' + @v_transport_mode      ;
				PRINT '@v_data_dup_cnt  = ' + CONVERT(VARCHAR,@v_data_dup_cnt)     ;
			END; 


			IF( @v_data_dup_cnt>1) 
			BEGIN
				SET @v_err_code    = 99030 ; 
				SET @v_err_message = N'중복된 기간을 저장할 수 없습니다';
				THROW  @v_err_code, @v_err_message , 1; --예외발생
			END;
			
			-- 기간 연속성 확인
			--SELECT @v_data_loop_cnt =  COUNT(1)
			--  FROM  SCP_MST_BOD A
			-- INNER JOIN scp_mst_distribution_route B ON A.ROUTE_ID = B.ROUTE_ID
			-- WHERE A.DIVISION_ID     = @v_division_id
			--   AND A.FROM_SITE       = @v_from_site
			--   AND A.TO_SITE         = @v_to_site
			--   AND A.INCOTERMS       = @v_incoterms
			--   AND B.TRANSPORT_MODE  = @v_transport_mode
			--;

			--DECLARE @v_data_cnt int = 0

			--IF ( @v_data_loop_cnt > 1)
			--BEGIN
			--	WHILE @v_data_loop_cnt > 0
			--	BEGIN
			--		SELECT @v_data_cnt = COUNT(1)
			--		  FROM SCP_MST_BOD A  WITH(NOLOCK)
			--		 INNER JOIN scp_mst_distribution_route B  WITH(NOLOCK) ON A.ROUTE_ID = B.ROUTE_ID
			--		 --INNER JOIN (SELECT CONVERT(VARCHAR(8) , dateadd(day, -1 , ATTRIBUTE2 ) , 112) AS FROM_YYYYMMDD
			--			--			  , CONVERT(VARCHAR(8) ,dateadd(day,  1 , ATTRIBUTE3 ) , 112) AS TO_YYYYMMDD
			--			--		   FROM SCP_MST_BOD A  WITH(NOLOCK)
			--			--		  WHERE A.BOD_ID	= @v_bod_id
			--			--		) X
			--			--ON (A.ATTRIBUTE3	= X.FROM_YYYYMMDD OR  A.ATTRIBUTE2	= X.TO_YYYYMMDD ) 
			--		 WHERE A.DIVISION_ID     = @v_division_id
			--		   AND A.FROM_SITE       = @v_from_site
			--		   AND A.TO_SITE         = @v_to_site
			--		   AND A.INCOTERMS       = @v_incoterms
			--		   AND B.TRANSPORT_MODE  = @v_transport_mode
			--		   AND (	A.ATTRIBUTE3 = CONVERT(VARCHAR(8), dateadd(day, -1 , @v_from_yyyymmdd)	,112)
			--				 OR A.ATTRIBUTE2 = CONVERT(VARCHAR(8), dateadd(day,  1 , @v_to_yyyymmdd)	,112)
			--				) 
			--	;

			--	IF( @v_data_cnt < 1) 
			--	BEGIN
			--		SET @v_err_code    = 99040 ; 
			--		SET @v_err_message = N'연속 기간이 아닙니다.';
			--		THROW  @v_err_code, @v_err_message , 1; --예외발생
			--	END;

			--		SET @v_data_loop_cnt =  @v_data_loop_cnt -1;
			--	END
			--END

			--SET @v_data_dup_cnt  =0;

			 --priority 중복체크
			 -- 제외 처리 함
			--SELECT @v_data_dup_priority_cnt = COUNT(*) 			
			--  FROM SCP_MST_BOD A
			-- WHERE A.DIVISION_ID     = @v_division_id
			--   --AND A.CUSTOMER_CODE   = @v_customer_code
			--   AND A.FROM_SITE       = @v_from_site
			--   AND A.TO_SITE         = @v_to_site
			--   AND A.INCOTERMS       = @v_incoterms
			--   AND A.PRIORITY        = @v_priority
			--  -- AND ( ISNULL(@v_bod_id,'')=''  OR  A.BOD_ID  != @v_bod_id ) --자기 자신은 제외하고 체크
			--   ;

   --         IF( @v_data_dup_priority_cnt>1) 
			--	BEGIN
			--		SET @v_err_code    = 99020 ; 
			--		SET @v_err_message = N'이미 존재하는 데이타 입니다.';
			--		THROW  @v_err_code, @v_err_message , 1; --예외발생
			--	END; 

		END -- END OF STMT. WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt_chk < @max_loop_cnt

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		COMMIT TRAN;
		
		-- BOD_ITEM 추가
		EXEC [dbo].[PR_SCP_MST_BOD_ITEM] @v_bod_list;	-- 전체 추가

		
		
		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  @mst_loop_cnt AS result_cnt ;

	END TRY

	BEGIN CATCH 
		BEGIN
			if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리
						
			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			--IF @@TRANCOUNT > 0
			--  COMMIT WORK;
					  

			-- error코드, errror 메시지 반환
			SELECT 'F' AS result_code;

			IF( @v_err_code IS NULL OR @v_err_code ='')
				SET @v_err_code= ERROR_NUMBER() ;
			IF( @v_err_message IS NULL OR @v_err_message ='') 
				SET @v_err_message=  ERROR_MESSAGE();
			   						
			/* 에러 메시지, 에러 데이터  반환   */	
			SELECT  @v_err_code			AS err_code
				   ,@v_err_message		AS err_message
				   ,@v_division_id      AS DIVISION_ID            
				   ,@v_customer_code    AS CUSTOMER
				   ,@v_from_site        AS FROM_SITE_CODE           
				   ,@v_to_site			AS TO_SITE_CODE      
				   ,@v_incoterms		AS INCOTERMS   
				   ,@v_incoterms_ssp	AS INCOTERMS_SSP          -- SSP용 Incoterms 추가
				   ,@v_transport_mode   AS TRANSPORT_MODE
				   ,@v_priority         AS PRIORITY
				   ,@v_route_id			AS ROUTE_ID           
				   ,@p_bod_id			AS BOD_ID         
				   ,@p_from_yyyymmdd	AS FROM_YYYYMMDD
				   ,@p_to_yyyymmdd		AS TO_YYYYMMDD
			; 

		END;
	END CATCH;
END

