



/*
 * Program ID   : [SCP0019_SAVE_WORKING_TIME]
 * Description  : Working Time 등록, 수정, 삭제
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/03/14   pjs				Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/05/28	hwyoon			except 시트 삭제로직 추가
 * 2019/04/08	hwyoon			[CSR:]GSCM 고도화 - Formation 수율 필드 추가, 기능개선
 * 2025/09/22   KH 	            PJ20257329    최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - 날짜중복체크 추가
 * 2025/10/29   hrkim		    [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : JV plant site 기준으로 매핑된 ESS 가상 plant 사이트 데이터 동기화
 *
 */
CREATE PROCEDURE [dbo].[SCP0022_SAVE_FORMATION_EXCEPT]
	  @p_active_flag 			NVARCHAR(MAX)
	, @p_division_id			NVARCHAR(MAX)
	, @p_plant_site_id			NVARCHAR(MAX)
	, @p_item_id				NVARCHAR(MAX)
	, @p_formation_start_date	NVARCHAR(MAX)
	, @p_formation_end_date		NVARCHAR(MAX)
	, @p_formation_yield		NVARCHAR(MAX)
	, @p_char_yield				NVARCHAR(MAX)
	, @p_formation_total_yield	NVARCHAR(MAX)
	, @p_comment				NVARCHAR(MAX)
	, @p_created_by				NVARCHAR(MAX)
	, @p_last_updated_by		NVARCHAR(MAX)
	, @p_org_division_id		NVARCHAR(MAX)
	, @p_org_plant_site_id		NVARCHAR(MAX)
	, @p_org_item_id			NVARCHAR(MAX)
	, @p_org_start_date			NVARCHAR(MAX)
	, @p_org_end_date			NVARCHAR(MAX)
	,@debug_mode          NVARCHAR(1) ='F'

AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = @p_active_flag

	declare @v_active_flag			NVARCHAR(MAX) = null;
	DECLARE @v_division_id			NVARCHAR(MAX) = null;
	DECLARE @v_plant_site_id		NVARCHAR(MAX) = null;
	DECLARE @v_item_id				NVARCHAR(MAX) = null;
	DECLARE @v_formation_start_date	NVARCHAR(MAX) = null;
	DECLARE @v_formation_end_date	NVARCHAR(MAX) = null;
	DECLARE @v_formation_yield		NVARCHAR(MAX) = null;
	DECLARE @v_char_yield			NVARCHAR(MAX) = null;
	DECLARE @v_formation_total_yield	NVARCHAR(MAX) = null;
	DECLARE @v_comment				NVARCHAR(MAX) = null;
	DECLARE @v_created_by			NVARCHAR(MAX) = @p_created_by;		  -- [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : 변수 초기값 (파라미터 값)
	DECLARE @v_last_updated_by	    NVARCHAR(MAX) = @p_last_updated_by;	  -- [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : 변수 초기값 (파라미터 값)
	
	-- 수정시 필요한 pk원본 값 2018-04-09 추가 pjs
	DECLARE @v_org_division_id		NVARCHAR(MAX) = NULL;
	DECLARE @v_org_plant_site_id	NVARCHAR(MAX) = NULL;
	DECLARE @v_org_item_id			NVARCHAR(MAX) = NULL;
	DECLARE @v_org_start_date		NVARCHAR(MAX) = NULL;
	DECLARE @v_org_end_date			NVARCHAR(MAX) = NULL;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0022_SAVE_FORMATION_EXCEPT';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	DECLARE @v_data_dup_cnt  INT=0;
	
	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';
	
	-- 트렌젝션 시작
	BEGIN TRAN;

	BEGIN TRY

		--PRINT '1';
		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		--PRINT '2';
		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag , @v_delimiter);    

		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN    
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;			

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN
				SET @v_active_flag      = dbo.SCM_ARR_SPL_VAL( @p_active_flag       , @v_delimiter, @mst_loop_cnt );
				SET @v_division_id      = dbo.SCM_ARR_SPL_VAL( @p_division_id       , @v_delimiter, @mst_loop_cnt );
				SET @v_plant_site_id    = dbo.SCM_ARR_SPL_VAL( @p_plant_site_id     , @v_delimiter, @mst_loop_cnt );
				SET @v_item_id			= dbo.SCM_ARR_SPL_VAL( @p_item_id           , @v_delimiter, @mst_loop_cnt );
				SET @v_formation_start_date  = dbo.SCM_ARR_SPL_VAL( @p_formation_start_date     , @v_delimiter, @mst_loop_cnt );
				SET @v_formation_end_date    = dbo.SCM_ARR_SPL_VAL( @p_formation_end_date     , @v_delimiter, @mst_loop_cnt );
				SET @v_formation_yield	= dbo.SCM_ARR_SPL_VAL( @p_formation_yield     , @v_delimiter, @mst_loop_cnt );
				SET @v_char_yield	= dbo.SCM_ARR_SPL_VAL( @p_char_yield     , @v_delimiter, @mst_loop_cnt );
				SET @v_formation_total_yield	= dbo.SCM_ARR_SPL_VAL( @p_formation_total_yield     , @v_delimiter, @mst_loop_cnt );
				SET @v_comment				= dbo.SCM_ARR_SPL_VAL( @p_comment , @v_delimiter, @mst_loop_cnt );
				SET @v_org_division_id     = dbo.SCM_ARR_SPL_VAL( @p_org_division_id     , @v_delimiter, @mst_loop_cnt );
				SET @v_org_plant_site_id   = dbo.SCM_ARR_SPL_VAL( @p_org_plant_site_id   , @v_delimiter, @mst_loop_cnt );
				SET @v_org_item_id      = dbo.SCM_ARR_SPL_VAL( @p_org_item_id      , @v_delimiter, @mst_loop_cnt );
				SET @v_org_start_date = dbo.SCM_ARR_SPL_VAL( @p_org_start_date , @v_delimiter, @mst_loop_cnt );
				SET @v_org_end_date   = dbo.SCM_ARR_SPL_VAL( @p_org_end_date   , @v_delimiter, @mst_loop_cnt );

				--PRINT '6';
				--PRINT ' @v_valid_yn ='+ ISNULL(@v_valid_yn,'') ;
			END;

						-- LOOP 파라미터 출력 DEBUG용			
			IF (@debug_mode ='T') 
			BEGIN		
				PRINT '=================LOOP VARS==============================';			
				PRINT ' @v_active_flag         = ''' + @v_active_flag          + '''' ;
				PRINT ' @v_division_id         = ''' + @v_division_id          + '''' ;
				PRINT ' @v_plant_site_id       = ''' + @v_plant_site_id        + '''' ;
				PRINT ' @v_item_id				= ''' + @v_item_id           + '''' ;
				PRINT ' @v_formation_start_date = ''' + @v_formation_start_date      + '''' ;
				PRINT ' @v_formation_end_date   = ''' + @v_formation_end_date        + '''' ;
				PRINT ' @v_formation_yield	   = ''' + @v_formation_yield		   + '''' ;
				PRINT ' @v_char_yield			= ''' + @v_char_yield		   + '''' ;
				PRINT ' @v_formation_total_yield	   = ''' + @v_formation_total_yield		   + '''' ;
				PRINT ' @v_comment			   = ''' + @v_comment			   + '''' ;
				PRINT ' @v_org_division_id     = ''' + @v_org_division_id      + '''' ;
				PRINT ' @v_org_plant_site_id   = ''' + @v_org_plant_site_id    + '''' ;
				PRINT ' @v_org_item_id      = ''' + @v_org_item_id       + '''' ;
				PRINT ' @v_org_start_date = ''' + @v_org_start_date  + '''' ;
				PRINT ' @v_org_end_date   = ''' + @v_org_end_date    + '''' ;
			END;

			------------------------------------------------------------------------------------------------------------------------------ 
			--### Start : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : JV plant site 기준으로 매핑된 ESS 가상 plant 사이트 데이터 동기화
			-- JV real plant site -> ESS virtaul plant site 단방향 저장 (virtual plant이면 skip) 
			------------------------------------------------------------------------------------------------------------------------------
			IF EXISTS (SELECT TOP 1 'X'
						 FROM SCM_MST_SITE RS WITH(NOLOCK)
							  INNER JOIN SCM_MST_PLANT_SN RP WITH(NOLOCK)	-- COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID 
									  ON RS.COMPANY_ID	= RP.COMPANY_ID
									 AND RS.DIVISION_ID	= RP.DIVISION_ID
									 AND RS.SITE_ID		= RP.SITE_ID
									 AND RS.PLANT_ID	= RP.PLANT_ID
						WHERE 1=1
						  AND RS.DIVISION_ID	= @v_division_id
						  AND RS.SCM_SITE_ID	= @v_plant_site_id
						  AND RP.PLANT_TYPE		= 'VIRTUAL'	
						)  CONTINUE ;  -- virtual plant site 이면 skip  
			------------------------------------------------------------------------------------------------------------------------------ 
			--### End : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : JV plant site 기준으로 매핑된 ESS 가상 plant 사이트 데이터 동기화
			------------------------------------------------------------------------------------------------------------------------------

			--데이터 저장
			IF @mst_loop_cnt > 0 		
			IF @v_active_flag != 'D'	
				BEGIN
				
				   -- [PJ20257329] 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - START 
					/**** 날짜 중복 체크 ****/
					DECLARE @cnt INTEGER;
					SELECT @cnt = COUNT(1)
					FROM SCP_MST_FORMATION_EXCEPT x
					WHERE DIVISION_ID	= @v_division_id
					AND plant_site_id   = @v_plant_site_id
					AND item_id	        = @v_item_id
					AND NOT ( @v_formation_end_date   < x.formation_start_date OR @v_formation_start_date > x.formation_end_date )
					AND NOT (x.formation_start_date = @v_org_start_date AND X.formation_end_date = @v_org_end_date ) -- 기존 값
 
					IF(@cnt > 0)
					BEGIN
						SET @v_err_code    = 99010 ; 
						SET @v_err_message = N' 입력 데이터 중 날짜가 중복되는 데이터가 있습니다.';
						THROW  @v_err_code, @v_err_message , 1; --예외발생
					END
					/**** 날짜 중복 체크 END ***/
					-- [PJ20257329] 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - END

					--declare @dYield numeric(20,10) = convert(numeric(20,4) , @v_formation_yield);
					declare @dYield numeric(20,10) = convert(numeric(20,4) , convert(float , @v_formation_yield) / 100);
					declare @dcharY numeric(20,10) = convert(numeric(20,4) , convert(float , @v_char_yield) / 100);
					declare @dtotalY numeric(20,10) = convert(numeric(20,4) , convert(float , @v_formation_total_yield) / 100);
					declare @dtCurrent datetime = SYSDATETIME();

					MERGE INTO SCP_MST_FORMATION_EXCEPT a
					USING (
							SELECT 
										@v_org_division_id		AS division_id
									,@v_org_plant_site_id	AS plant_site_id
									,@v_org_item_id			AS item_id
									,@v_org_start_date AS formation_start_date
									,@v_org_end_date	AS formation_end_date
							) b
					ON(
							a.division_id			= b.division_id
						AND a.plant_site_id			= b.plant_site_id
						AND a.item_id				= b.item_id
						AND a.formation_start_date	= b.formation_start_date
						AND a.formation_end_date	= b.formation_end_date
					)
					WHEN MATCHED THEN
						UPDATE SET
								formation_start_date	 = @v_formation_start_date
							,formation_end_date		 = @v_formation_end_date
							,formation_yield		 = CASE WHEN ISNULL(@v_formation_yield,'')='' THEN null ELSE (convert(numeric(20,4) , convert(float , @v_formation_yield) / 100)) end
							,CHAR_YIELD				 = CASE WHEN ISNULL(@v_char_yield,'')='' THEN null ELSE (convert(numeric(20,4) , convert(float , @v_char_yield) / 100)) end
							,FORMATION_TOTAL_YIELD	 = CASE WHEN ISNULL(@v_formation_total_yield,'')='' THEN null ELSE (convert(numeric(20,4) , convert(float , @v_formation_total_yield) / 100)) end
							,except_comment      = @v_comment
							,last_updated_by	 = @p_last_updated_by
							,last_update_date	 = @dtCurrent
					WHEN NOT MATCHED THEN							                                             
						INSERT 	   ( division_id                    
									,plant_site_id                  
									,item_id                     
									,formation_start_date                   
									,formation_end_date
									,formation_yield
									,CHAR_YIELD
									,FORMATION_TOTAL_YIELD
									,except_comment
									,created_by                     
									,creation_date                  
									,last_updated_by
									,last_update_date               
									)                   
								VALUES                                  
									(@v_division_id     
									,@v_plant_site_id   
									,@v_item_id      
									,@v_formation_start_date    
									,@v_formation_end_date
									,CASE WHEN ISNULL(@v_formation_yield,'')='' THEN null ELSE (convert(numeric(20,4) , convert(float , @v_formation_yield) / 100)) end
									,CASE WHEN ISNULL(@v_char_yield,'')='' THEN null ELSE (convert(numeric(20,4) , convert(float , @v_char_yield) / 100)) end
									,CASE WHEN ISNULL(@v_formation_total_yield,'')='' THEN null ELSE (convert(numeric(20,4) , convert(float , @v_formation_total_yield) / 100)) end
									,@v_comment
									,@p_created_by
									,@dtCurrent
									,@p_last_updated_by 
									,@dtCurrent
									);

					declare @p_creation_date datetime =  SYSDATETIME();

					EXEC [dbo].[PR_SCP_MST_FORMATION_EXCEPT_HIST]
						@v_division_id , @v_plant_site_id , @v_item_id , @v_formation_start_date , @v_formation_end_date ,
						@v_formation_yield , @v_char_yield , @v_formation_total_yield , @v_comment , @p_created_by , @p_last_updated_by	, @dtCurrent
					;

					------------------------------------------------------------------------------------------------------------------------------ 
					--### Start : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : JV plant site 기준으로 매핑된 ESS 가상 plant 사이트 데이터 동기화
					------------------------------------------------------------------------------------------------------------------------------
					----------------------------------------------------- 
					-- #.1 가상 Plant 사이트 대상 데이터 추출 
					----------------------------------------------------- 
					IF OBJECT_ID('TEMPDB..#SCP_MST_FORMATION_EXECPT_VIRTUAL_SITE') IS NOT NULL DROP TABLE #SCP_MST_FORMATION_EXECPT_VIRTUAL_SITE

					SELECT VS.DIVISION_ID	AS VS_DIVISION_ID
						  ,VS.SCM_SITE_ID	AS VS_PLANT_SITE_ID
						  ,VS.PLANT_ID		AS VS_PLANT_ID
						  ,RS.DIVISION_ID	AS RS_DIVISION_ID
						  ,RS.SCM_SITE_ID	AS RS_PLANT_SITE_ID
						  ,RS.PLANT_ID		AS RS_PLANT_ID
						  ,RF.ITEM_ID
						  ,RF.FORMATION_START_DATE
						  ,RF.FORMATION_END_DATE
						  ,CAST(RF.FORMATION_YIELD			AS NUMERIC(20,10))	AS FORMATION_YIELD		
						  ,CAST(RF.CHAR_YIELD				AS NUMERIC(20,10))	AS CHAR_YIELD			
						  ,CAST(RF.FORMATION_TOTAL_YIELD	AS NUMERIC(20,10))	AS FORMATION_TOTAL_YIELD
						  ,CAST(RF.SSP_MODIFY_YIELD			AS NUMERIC(20,10))	AS SSP_MODIFY_YIELD		
						  ,RF.EXCEPT_COMMENT	
						  ,ROW_NUMBER() OVER (PARTITION BY VS.DIVISION_ID
														  ,VS.SCM_SITE_ID
														  ,RF.ITEM_ID
														  ,RF.FORMATION_START_DATE
														  ,RF.FORMATION_END_DATE
												  ORDER BY RF.LAST_UPDATE_DATE DESC) AS RN 
					 INTO #SCP_MST_FORMATION_EXECPT_VIRTUAL_SITE
					 FROM SCM_MST_PLANT_SN VP WITH(NOLOCK)
						  INNER JOIN SCM_MST_SITE VS WITH(NOLOCK)
								  ON VS.COMPANY_ID	= VP.COMPANY_ID
								 AND VS.DIVISION_ID = VP.DIVISION_ID
								 AND VS.PLANT_ID	= VP.PLANT_ID
								 AND VS.SITE_ID		= VP.SITE_ID
								 AND VS.SITE_TYPE	= 'PLANT'
								 AND VS.VALID_YN	= 'Y'
						  INNER JOIN SCM_MST_SITE RS WITH(NOLOCK)
								  ON RS.SCM_SITE_ID	= VS.ATTRIBUTE9 
								 AND RS.PLANT_ID	= VP.LINK_PLANT_ID
								 AND RS.SITE_TYPE	= 'PLANT'
								 AND RS.VALID_YN	= 'Y'
						  INNER JOIN SCP_MST_FORMATION_EXCEPT RF WITH(NOLOCK)  -- DIVISION_ID, PLANT_SITE_ID, ITEM_ID, FORMATION_START_DATE, FORMATION_END_DATE 
								  ON RF.DIVISION_ID		= RS.DIVISION_ID
								 AND RF.PLANT_SITE_ID	= RS.SCM_SITE_ID
					WHERE 1=1
					  AND RS.DIVISION_ID			= @v_division_id	-- Real plant 기준
					  AND RS.SCM_SITE_ID			= @v_plant_site_id
					  AND RF.ITEM_ID				= @v_item_id
					  AND RF.FORMATION_START_DATE	= @v_formation_start_date
					  AND RF.FORMATION_END_DATE		= @v_formation_end_date
					  AND VP.PLANT_TYPE				= 'VIRTUAL'

					----------------------------------------------------- 
					-- #.2.1 가상 Plant 사이트 대상 이력 생성 
					----------------------------------------------------- 
					INSERT INTO SCP_MST_FORMATION_EXCEPT_H
						  (HISTORY_SEQ
						  ,DIVISION_ID
						  ,PLANT_SITE_ID
						  ,ITEM_ID
						  ,FORMATION_START_DATE
						  ,FORMATION_END_DATE
						  ,FORMATION_YIELD
						  ,CHAR_YIELD
						  ,FORMATION_TOTAL_YIELD
						  ,SSP_MODIFY_YIELD
						  ,EXCEPT_COMMENT
						  ,CREATED_BY
						  ,CREATION_DATE
						  ,LAST_UPDATED_BY
						  ,LAST_UPDATE_DATE
						  ,HISTORY_CREATION_DATE)
					SELECT NEXT VALUE FOR SEQ1_SCP_MST_FORMATION_EXCEPT_H	AS HISTORY_SEQ
						  ,TG.DIVISION_ID
						  ,TG.PLANT_SITE_ID
						  ,TG.ITEM_ID
						  ,TG.FORMATION_START_DATE
						  ,TG.FORMATION_END_DATE
						  ,TG.FORMATION_YIELD
						  ,TG.CHAR_YIELD
						  ,TG.FORMATION_TOTAL_YIELD
						  ,TG.SSP_MODIFY_YIELD
						  ,TG.EXCEPT_COMMENT
						  ,TG.CREATED_BY
						  ,TG.CREATION_DATE
						  ,TG.LAST_UPDATED_BY
						  ,TG.LAST_UPDATE_DATE
						  ,GETDATE()								AS HISTORY_CREATION_DATE
					 FROM SCP_MST_FORMATION_EXCEPT TG WITH(NOLOCK)
						  INNER JOIN #SCP_MST_FORMATION_EXECPT_VIRTUAL_SITE VF
								  ON VF.VS_DIVISION_ID			= TG.DIVISION_ID
								 AND VF.VS_PLANT_SITE_ID		= TG.PLANT_SITE_ID
								 AND VF.ITEM_ID					= TG.ITEM_ID 
								 AND VF.FORMATION_START_DATE	= TG.FORMATION_START_DATE
								 AND VF.FORMATION_END_DATE		= TG.FORMATION_END_DATE
								 AND VF.RN						= 1 
					WHERE ISNULL(VF.FORMATION_YIELD, 0)			!= ISNULL(TG.FORMATION_YIELD, 0)
					   OR ISNULL(VF.CHAR_YIELD, 0)				!= ISNULL(TG.CHAR_YIELD, 0)
					   OR ISNULL(VF.FORMATION_TOTAL_YIELD, 0)	!= ISNULL(TG.FORMATION_TOTAL_YIELD, 0)
					   OR ISNULL(VF.SSP_MODIFY_YIELD, 0)		!= ISNULL(TG.SSP_MODIFY_YIELD, 0)
					   OR ISNULL(VF.EXCEPT_COMMENT, '')			!= ISNULL(TG.EXCEPT_COMMENT, '')

					----------------------------------------------------- 
					-- #.2.2 가상 Plant 사이트 이력 생성(날짜key컬럼 변경) 
					----------------------------------------------------- 
					INSERT INTO SCP_MST_FORMATION_EXCEPT_H
						  (HISTORY_SEQ
						  ,DIVISION_ID
						  ,PLANT_SITE_ID
						  ,ITEM_ID
						  ,FORMATION_START_DATE
						  ,FORMATION_END_DATE
						  ,FORMATION_YIELD
						  ,CHAR_YIELD
						  ,FORMATION_TOTAL_YIELD
						  ,SSP_MODIFY_YIELD
						  ,EXCEPT_COMMENT
						  ,CREATED_BY
						  ,CREATION_DATE
						  ,LAST_UPDATED_BY
						  ,LAST_UPDATE_DATE
						  ,HISTORY_CREATION_DATE)
					SELECT NEXT VALUE FOR SEQ1_SCP_MST_FORMATION_EXCEPT_H	AS HISTORY_SEQ
						  ,TG.DIVISION_ID
						  ,TG.PLANT_SITE_ID
						  ,TG.ITEM_ID
						  ,TG.FORMATION_START_DATE
						  ,TG.FORMATION_END_DATE
						  ,TG.FORMATION_YIELD
						  ,TG.CHAR_YIELD
						  ,TG.FORMATION_TOTAL_YIELD
						  ,TG.SSP_MODIFY_YIELD
						  ,TG.EXCEPT_COMMENT
						  ,TG.CREATED_BY
						  ,TG.CREATION_DATE
						  ,TG.LAST_UPDATED_BY
						  ,TG.LAST_UPDATE_DATE
						  ,GETDATE()								AS HISTORY_CREATION_DATE
					 FROM SCP_MST_FORMATION_EXCEPT TG WITH(NOLOCK)
						  INNER JOIN #SCP_MST_FORMATION_EXECPT_VIRTUAL_SITE VF
								  ON VF.VS_DIVISION_ID			= TG.DIVISION_ID
								 AND VF.VS_PLANT_SITE_ID		= TG.PLANT_SITE_ID
								 AND VF.ITEM_ID					= TG.ITEM_ID 
					WHERE 1=1
					  AND TG.FORMATION_START_DATE	= @v_org_start_date
					  AND TG.FORMATION_END_DATE		= @v_org_end_date
					  AND ISNULL(@v_org_start_date,'') != ''			
					  AND (@v_org_start_date != @v_formation_start_date 
							or @v_org_end_date != @v_formation_end_date )

					----------------------------------------------------- 
					-- #.2.3 가상 Plant 사이트 변경전 날짜 데이터 삭제
					-- key컬럼 변경하지 않고 delete/insert
					----------------------------------------------------- 
					DELETE TG
					 FROM SCP_MST_FORMATION_EXCEPT TG WITH(NOLOCK)
						  INNER JOIN #SCP_MST_FORMATION_EXECPT_VIRTUAL_SITE VF
								  ON VF.VS_DIVISION_ID			= TG.DIVISION_ID
								 AND VF.VS_PLANT_SITE_ID		= TG.PLANT_SITE_ID
								 AND VF.ITEM_ID					= TG.ITEM_ID 
					WHERE 1=1
					  AND TG.FORMATION_START_DATE	= @v_org_start_date
					  AND TG.FORMATION_END_DATE		= @v_org_end_date
					  AND ISNULL(@v_org_start_date,'') != ''			
					  AND (@v_org_start_date != @v_formation_start_date 
							or @v_org_end_date != @v_formation_end_date )

					----------------------------------------------------- 
					-- #.3 가상 Plant 사이트 대상 데이터 Update 
					----------------------------------------------------- 
					UPDATE TG
					   SET TG.FORMATION_YIELD		= VF.FORMATION_YIELD
						 , TG.CHAR_YIELD			= VF.CHAR_YIELD
						 , TG.FORMATION_TOTAL_YIELD	= VF.FORMATION_TOTAL_YIELD
						 , TG.SSP_MODIFY_YIELD		= VF.SSP_MODIFY_YIELD
						 , TG.EXCEPT_COMMENT		= VF.EXCEPT_COMMENT
						 , TG.LAST_UPDATE_DATE		= GETDATE()
						 , TG.LAST_UPDATED_BY		= @v_last_updated_by
					 FROM SCP_MST_FORMATION_EXCEPT TG WITH(NOLOCK)
						  INNER JOIN #SCP_MST_FORMATION_EXECPT_VIRTUAL_SITE VF
								  ON VF.VS_DIVISION_ID			= TG.DIVISION_ID
								 AND VF.VS_PLANT_SITE_ID		= TG.PLANT_SITE_ID
								 AND VF.ITEM_ID					= TG.ITEM_ID 
								 AND VF.FORMATION_START_DATE	= TG.FORMATION_START_DATE
								 AND VF.FORMATION_END_DATE		= TG.FORMATION_END_DATE
								 AND VF.RN						= 1 
					WHERE ISNULL(VF.FORMATION_YIELD, 0)			!= ISNULL(TG.FORMATION_YIELD, 0)
					   OR ISNULL(VF.CHAR_YIELD, 0)				!= ISNULL(TG.CHAR_YIELD, 0)
					   OR ISNULL(VF.FORMATION_TOTAL_YIELD, 0)	!= ISNULL(TG.FORMATION_TOTAL_YIELD, 0)
					   OR ISNULL(VF.SSP_MODIFY_YIELD, 0)		!= ISNULL(TG.SSP_MODIFY_YIELD, 0)
					   OR ISNULL(VF.EXCEPT_COMMENT, '')			!= ISNULL(TG.EXCEPT_COMMENT, '')

					----------------------------------------------------- 
					-- #.4 가상 Plant 사이트 대상 데이터 insert 
					----------------------------------------------------- 
					INSERT INTO SCP_MST_FORMATION_EXCEPT
						  (  DIVISION_ID
							,PLANT_SITE_ID
							,ITEM_ID
							,FORMATION_START_DATE
							,FORMATION_END_DATE
							,FORMATION_YIELD
							,CHAR_YIELD
							,FORMATION_TOTAL_YIELD
							,SSP_MODIFY_YIELD
							,EXCEPT_COMMENT
							,CREATED_BY
							,CREATION_DATE
							,LAST_UPDATED_BY
							,LAST_UPDATE_DATE)
					SELECT VF.VS_DIVISION_ID
						  ,VF.VS_PLANT_SITE_ID
						  ,VF.ITEM_ID
						  ,VF.FORMATION_START_DATE
						  ,VF.FORMATION_END_DATE
						  ,VF.FORMATION_YIELD
						  ,VF.CHAR_YIELD
						  ,VF.FORMATION_TOTAL_YIELD
						  ,VF.SSP_MODIFY_YIELD
						  ,VF.EXCEPT_COMMENT
						  ,@v_created_by		AS CREATED_BY
						  ,GETDATE()			AS CREATION_DATE
						  ,@v_last_updated_by	AS LAST_UPDATED_BY
						  ,GETDATE()			AS LAST_UPDATE_DATE
					 FROM #SCP_MST_FORMATION_EXECPT_VIRTUAL_SITE VF
					WHERE 1=1
					  AND VF.RN		=	1
					  AND NOT EXISTS (SELECT 'X'
										FROM SCP_MST_FORMATION_EXCEPT TG WITH(NOLOCK)
									   WHERE TG.DIVISION_ID				= VF.VS_DIVISION_ID
										 AND TG.PLANT_SITE_ID			= VF.VS_PLANT_SITE_ID
										 AND TG.ITEM_ID					= VF.ITEM_ID
										 AND TG.FORMATION_START_DATE	= VF.FORMATION_START_DATE
										 AND TG.FORMATION_END_DATE		= VF.FORMATION_END_DATE  ) 

					------------------------------------------------------------------------------------------------------------------------------ 
					--### End : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : JV plant site 기준으로 매핑된 ESS 가상 plant 사이트 데이터 동기화
					------------------------------------------------------------------------------------------------------------------------------

				END;
			ELSE IF @v_active_flag = 'D'
				BEGIN
					------------------------------------------------------------------------------------------------------------------------------ 
					--### Start : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : JV plant site 기준으로 매핑된 ESS 가상 plant 사이트 데이터 동기화
					------------------------------------------------------------------------------------------------------------------------------
					----------------------------------------------------- 
					-- #.1 가상 Plant 사이트 대상 데이터 추출 
					----------------------------------------------------- 
					IF OBJECT_ID('TEMPDB..#SCP_MST_FORMATION_EXECPT_VIRTUAL_SITE_TO_DELETE') IS NOT NULL DROP TABLE #SCP_MST_FORMATION_EXECPT_VIRTUAL_SITE_TO_DELETE

					SELECT VS.DIVISION_ID	AS VS_DIVISION_ID
						  ,VS.SCM_SITE_ID	AS VS_PLANT_SITE_ID
						  ,RF.ITEM_ID
						  ,RF.FORMATION_START_DATE
						  ,RF.FORMATION_END_DATE
					 INTO #SCP_MST_FORMATION_EXECPT_VIRTUAL_SITE_TO_DELETE
					 FROM SCM_MST_PLANT_SN VP WITH(NOLOCK)
						  INNER JOIN SCM_MST_SITE VS WITH(NOLOCK)
								  ON VS.COMPANY_ID	= VP.COMPANY_ID
								 AND VS.DIVISION_ID = VP.DIVISION_ID
								 AND VS.PLANT_ID	= VP.PLANT_ID
								 AND VS.SITE_ID		= VP.SITE_ID
								 AND VS.SITE_TYPE	= 'PLANT'
								 AND VS.VALID_YN	= 'Y'
						  INNER JOIN SCM_MST_SITE RS WITH(NOLOCK)
								  ON RS.SCM_SITE_ID	= VS.ATTRIBUTE9 
								 AND RS.PLANT_ID	= VP.LINK_PLANT_ID
								 AND RS.SITE_TYPE	= 'PLANT'
								 AND RS.VALID_YN	= 'Y'
						  INNER JOIN SCP_MST_FORMATION_EXCEPT RF WITH(NOLOCK)  -- DIVISION_ID, PLANT_SITE_ID, ITEM_ID, FORMATION_START_DATE, FORMATION_END_DATE 
								  ON RF.DIVISION_ID		= RS.DIVISION_ID
								 AND RF.PLANT_SITE_ID	= RS.SCM_SITE_ID
					WHERE 1=1
					  AND RS.DIVISION_ID			= @v_org_division_id	-- Real plant 기준
					  AND RS.SCM_SITE_ID			= @v_org_plant_site_id
					  AND RF.ITEM_ID				= @v_org_item_id
					  AND RF.FORMATION_START_DATE	= @v_org_start_date
					  AND RF.FORMATION_END_DATE		= @v_org_end_date
					  AND VP.PLANT_TYPE				= 'VIRTUAL'

					----------------------------------------------------- 
					-- #.2 가상 Plant 사이트 대상 이력 생성 (삭제전)
					----------------------------------------------------- 
					INSERT INTO SCP_MST_FORMATION_EXCEPT_H
						  (HISTORY_SEQ
						  ,DIVISION_ID
						  ,PLANT_SITE_ID
						  ,ITEM_ID
						  ,FORMATION_START_DATE
						  ,FORMATION_END_DATE
						  ,FORMATION_YIELD
						  ,CHAR_YIELD
						  ,FORMATION_TOTAL_YIELD
						  ,SSP_MODIFY_YIELD
						  ,EXCEPT_COMMENT
						  ,CREATED_BY
						  ,CREATION_DATE
						  ,LAST_UPDATED_BY
						  ,LAST_UPDATE_DATE
						  ,HISTORY_CREATION_DATE)
					SELECT NEXT VALUE FOR SEQ1_SCP_MST_FORMATION_EXCEPT_H	AS HISTORY_SEQ
						  ,TG.DIVISION_ID
						  ,TG.PLANT_SITE_ID
						  ,TG.ITEM_ID
						  ,TG.FORMATION_START_DATE
						  ,TG.FORMATION_END_DATE
						  ,TG.FORMATION_YIELD
						  ,TG.CHAR_YIELD
						  ,TG.FORMATION_TOTAL_YIELD
						  ,TG.SSP_MODIFY_YIELD
						  ,TG.EXCEPT_COMMENT
						  ,TG.CREATED_BY
						  ,TG.CREATION_DATE
						  ,TG.LAST_UPDATED_BY
						  ,TG.LAST_UPDATE_DATE
						  ,GETDATE()								AS HISTORY_CREATION_DATE
					 FROM SCP_MST_FORMATION_EXCEPT TG WITH(NOLOCK)
						  INNER JOIN #SCP_MST_FORMATION_EXECPT_VIRTUAL_SITE_TO_DELETE VF
								  ON VF.VS_DIVISION_ID			= TG.DIVISION_ID
								 AND VF.VS_PLANT_SITE_ID		= TG.PLANT_SITE_ID
								 AND VF.ITEM_ID					= TG.ITEM_ID 
								 AND VF.FORMATION_START_DATE	= TG.FORMATION_START_DATE
								 AND VF.FORMATION_END_DATE		= TG.FORMATION_END_DATE
					WHERE 1=1

					----------------------------------------------------- 
					-- #.3 가상 Plant 사이트 대상 데이터 삭제 
					----------------------------------------------------- 
					DELETE TG 
					 FROM SCP_MST_FORMATION_EXCEPT TG WITH(NOLOCK)
						  INNER JOIN #SCP_MST_FORMATION_EXECPT_VIRTUAL_SITE_TO_DELETE VF
								  ON VF.VS_DIVISION_ID			= TG.DIVISION_ID
								 AND VF.VS_PLANT_SITE_ID		= TG.PLANT_SITE_ID
								 AND VF.ITEM_ID					= TG.ITEM_ID 
								 AND VF.FORMATION_START_DATE	= TG.FORMATION_START_DATE
								 AND VF.FORMATION_END_DATE		= TG.FORMATION_END_DATE
					WHERE 1=1
					------------------------------------------------------------------------------------------------------------------------------ 
					--### Start : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : JV plant site 기준으로 매핑된 ESS 가상 plant 사이트 데이터 동기화
					------------------------------------------------------------------------------------------------------------------------------

					DELETE FROM SCP_MST_FORMATION_EXCEPT
						  WHERE division_id				= @v_org_division_id
							AND plant_site_id			= @v_org_plant_site_id
							AND item_id					= @v_org_item_id
							AND formation_start_date	= @v_org_start_date
							AND formation_end_date		= @v_org_end_date
				END;
			
		END -- END OF STMT. WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		--PRINT 'COMMIT'
		COMMIT TRAN;			

		IF OBJECT_ID('TEMPDB..#SCP_MST_FORMATION_EXECPT_VIRTUAL_SITE')			 IS NOT NULL DROP TABLE #SCP_MST_FORMATION_EXECPT_VIRTUAL_SITE				-- [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : 임시테이블 정리
		IF OBJECT_ID('TEMPDB..#SCP_MST_FORMATION_EXECPT_VIRTUAL_SITE_TO_DELETE') IS NOT NULL DROP TABLE #SCP_MST_FORMATION_EXECPT_VIRTUAL_SITE_TO_DELETE	-- [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : 임시테이블 정리

		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  @mst_loop_cnt AS result_cnt ;

	END TRY

	BEGIN CATCH 
		BEGIN
			if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리
						
			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (@v_program_name,'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

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
				   ,@v_formation_start_date  AS formation_start_date
				   ,@v_formation_end_date    AS formation_end_date
			; 
		END;
	END CATCH;
END



