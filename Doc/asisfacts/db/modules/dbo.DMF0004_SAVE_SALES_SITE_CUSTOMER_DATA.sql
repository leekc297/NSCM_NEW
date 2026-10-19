/****************************************************************************************************/
/* Program ID  : [DMF0004_SAVE_SALES_SITE_CUSTOMER_DATA]														*/
/* Description : SCM_MST_SITE HISTORYT INSERT														*/
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2017/12/05  DWOK/DWPARK  Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 20180611 ytchoi : @v_valid_yn = 'Y' 조건 추가 Valid를 Y로 하는 경우에만 Check 하도록 함. 
 * 20180626 khsong INVALID LOG 생성
 * 20180628 ytchoi soldto_code validation 조건에 추가
 * 20180712 KHSONG 컬럼값 null인경우 validation 조건 추가
 * 20181011 KHSONG SCM_MST_CUSTOMER Validation Check
 * 20181030 KHSONG rep_yn 중복 Validation 추가
 * 20181107 KHSONG 기존 SCM_MST_SITE_CUSTOMER의 soldto_code 와 동일한지 Validation Check 
 * 20181115 KHSONG 신규 insert 요청시 기존 Shipto code에 앞 2자리가 SCM_MST_SITE의 국가코드와 Validation
 * 20200528 KHSONG C20200417-000237 (Sales site-Ship-to 코드 생성시 Validation 로직 변경)
 * 2020/12/21	P.C.I	[C20201217-000228] Sales Site에서 Sold to, Ship to의 Valid가 'N'인 대상도 수정가능하도록 적용, Valid가 'N'인 대상은 Active 'Y'로 변경 불가
 * 2021/01/18		KUNI	[C20210115-000214] (1)Sales Site (Sales Customer) - Active 이력 저장관련 오류사항 , Parameter 값으로 저장
 * 2021/03/09		KUNI	[C20210305-000229] 판매법인 SALES SITE의 경우 국가/도시 통제 해제, (중복 SCM_SITE_ID)Lookup으로 관리
												1. SOLDTO CODE 2개이상 저장가능
												2. 국가/도시 통제 해제
 * 2022/04/26	rosia27		[C20220419-000344]판매처납품처 조합1-복수의 Sales Site 내 Validation Y 지정 불가 로직 점검 요청의 件
 * 2022/10/24	ROSIA27		[C20221024-000510]DM UI 소스 정리 요청
 * 2024/06/05	P.C.I		[PJ20228272]NERP 대응 - NERP 오픈 이후 신코드만 대표코드로 설정 가능, SOLDTO_CODE 중복 확인 시 NERP 신코드/구코드가 동일한 경우에 제외 
 * 2025/02/05	JSSBAE		[E20250205-001041]_Sales Site의 Sold To 구코드, 신코드 인식 오류 검토 요청의 건
 * 2025/06/29	JSSBAE		[IT20250117A] NERP 오펀차수별 Mapping Code적용
*/
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[DMF0004_SAVE_SALES_SITE_CUSTOMER_DATA]
	
	--@p_success_yn			NVARCHAR(1) OUTPUT
	@p_active_flag			NVARCHAR(MAX),
	@p_division_id			NVARCHAR(MAX),
	@p_scm_site_id			NVARCHAR(MAX),
	@p_soldto_code			NVARCHAR(MAX),
	@p_soldto_description	NVARCHAR(MAX),
	@p_shipto_code			NVARCHAR(MAX),
	@p_shipto_description	NVARCHAR(MAX),
	@p_rep_yn				NVARCHAR(MAX),
	@p_valid_yn				NVARCHAR(MAX),
	@p_created_by			NVARCHAR(MAX)
	
AS

BEGIN

	SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_active_flag			NVARCHAR(MAX);
	DECLARE @v_division_id			NVARCHAR(MAX);
	DECLARE @v_scm_site_id			NVARCHAR(MAX);
	DECLARE @v_soldto_code			NVARCHAR(MAX);
	DECLARE @v_soldto_description	NVARCHAR(MAX);
	DECLARE @v_shipto_code			NVARCHAR(MAX);
	DECLARE @v_shipto_description	NVARCHAR(MAX);
	DECLARE @v_rep_yn				NVARCHAR(MAX);
	DECLARE @v_valid_yn				NVARCHAR(MAX);
	DECLARE @v_created_by			NVARCHAR(MAX);

	SET @v_active_flag = NULL;
	SET @v_division_id = NULL;
	SET @v_scm_site_id = NULL;
	SET @v_soldto_code = NULL;
	SET @v_soldto_description = NULL;	 
	SET @v_shipto_code = NULL;	 
	SET @v_shipto_description = NULL;	 
	SET @v_rep_yn = NULL;	 
	SET @v_valid_yn = NULL;	
	SET @v_created_by = NULL;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^'
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	-- @results TEMP TABLE(20180418 ADD SKH)
	DECLARE @results TABLE (
             division_id      NVARCHAR(MAX)
			,scm_site_id      NVARCHAR(MAX)
			,soldto_code      NVARCHAR(MAX)
			,shipto_code      NVARCHAR(MAX)
			)
	DECLARE @v_dup_scm_site_id		NVARCHAR(MAX);
	SET @v_dup_scm_site_id = '';

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DMF0004_SAVE_SALES_SITE_CUSTOMER_DATA';
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

	BEGIN TRAN;

		BEGIN TRY

		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);    
		--SELECT    @max_loop_cnt;
		--	WHILE LEN(@p_active_flag) > 0
		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt

		BEGIN    
			
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;
			--SELECT @mst_loop_cnt,'@mst_loop_cnt'		

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN

				SET @v_active_flag = [dbo].[SCM_ARR_SPL_VAL](@p_active_flag, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_active_flag
					  
				SET @v_division_id = [dbo].[SCM_ARR_SPL_VAL](@p_division_id, @v_delimiter , @mst_loop_cnt) ; 
				--SELECT @v_division_id

				SET @v_scm_site_id = [dbo].[SCM_ARR_SPL_VAL](@p_scm_site_id, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_scm_site_id

				SET @v_soldto_code = [dbo].[SCM_ARR_SPL_VAL](@p_soldto_code, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_soldto_code
			
				SET @v_soldto_description = [dbo].[SCM_ARR_SPL_VAL](@p_soldto_description, @v_delimiter , @mst_loop_cnt) ; 
				--SELECT @v_soldto_description

				SET @v_shipto_code = [dbo].[SCM_ARR_SPL_VAL](@p_shipto_code, @v_delimiter, @mst_loop_cnt) ; 
				--SELECT @v_shipto_code

				SET @v_shipto_description = [dbo].[SCM_ARR_SPL_VAL](@p_shipto_description, @v_delimiter, @mst_loop_cnt) ; 
				--SELECT @v_shipto_description

				SET @v_rep_yn = [dbo].[SCM_ARR_SPL_VAL](@p_rep_yn, @v_delimiter, @mst_loop_cnt) ; 
				--SELECT @v_rep_yn

				SET @v_valid_yn = [dbo].[SCM_ARR_SPL_VAL](@p_valid_yn, @v_delimiter, @mst_loop_cnt) ; 
				--SELECT @v_valid_yn

				SET @v_created_by = [dbo].[SCM_ARR_SPL_VAL](@p_created_by, @v_delimiter, @mst_loop_cnt) ; 
				--SELECT @v_created_by
						
			END

			--HISTORY INSERT
			EXEC	[dbo].[PR_DM_MST_SITE_CUSTOMER_HIST]	--@return_value = [dbo].[PR_DM_MST_SITE_CUSTOMER_HIST]
						@v_division_id,
						@v_scm_site_id,
						@v_soldto_code,
						@v_shipto_code,		
						@v_rep_yn,
						@v_created_by	
						, @v_valid_yn -- [C20210115-000214] (1)  

						--,@v_OK_description OUTPUT
						--SELECT @v_OK_description;

			----------------------------------------------------- 20180712 KHSONG 컬럼값 null인경우 validation 조건 추가 (end)
			   IF       @v_division_id is null
					or  @v_scm_site_id is null
					or  @v_soldto_code is null
					or  @v_shipto_code is null
					or  @v_rep_yn is null
					or  @v_division_id = ''
					or  @v_scm_site_id = ''
					or  @v_soldto_code = ''
					or  @v_shipto_code = ''
					or  @v_rep_yn = ''
				   BEGIN  -- 중복 발생인경우의 logic
					   SET @v_log_type = 'INVALID';
					   SELECT N'입력값을 확인하세요.' 
					   SET @v_description = N'입력값을 확인하세요.' 
					   goto err_rtn
				   END
			----------------------------------------------------- 20180712 KHSONG 컬럼값 null인경우 validation 조건 추가 (end)
			--------------------------------------------------------------------------------------------------------------------------------------- 20181011 KHSONG SCM_MST_CUSTOMER Validation Check (START)
			   IF isnull((select count(1) from SCM_MST_CUSTOMER 
			                where 1=1
  							  and division_id = @v_division_id
  							  and shipto_code = @v_shipto_code
							  and soldto_code = @v_soldto_code
							  --and VALID_YN = 'Y' --[C20201217-000228] Sales Site에서 Sold to, Ship to의 Valid가 'N'인 대상도 수정가능하도록 적용
						   ),0) = 0
				   BEGIN
					   SET @v_log_type = 'INVALID';
					   SELECT N'Invalid soldto - shipto mapping' +char(10) + N'Ship-To Code: '+ RTRIM(LTRIM(@v_shipto_code)) +char(10) +  N'Sold-To Code: ' + RTRIM(LTRIM(@v_soldto_code))
					   SET @v_description =  N'Invalid soldto - shipto mapping' +char(10) +  N'Sold-To Code: ' + RTRIM(LTRIM(@v_soldto_code)) + N'Ship-To Code: '+ RTRIM(LTRIM(@v_shipto_code)) +char(10)
					   goto err_rtn
				   END

				--Start [C20201217-000228] Sales Site에서 Sold to, Ship to의 Valid가 'N'인 대상은 Active 'Y'로 변경 불가
			   IF isnull((select count(1) from SCM_MST_CUSTOMER 
			                where 1=1
  							  and division_id = @v_division_id
  							  and shipto_code = @v_shipto_code
							  and soldto_code = @v_soldto_code
							  and VALID_YN	  = 'N' 
							  and 'Y'         = @v_valid_yn
						   ),0) > 0
				   BEGIN
					   SET @v_log_type = 'INVALID';
					   SELECT N'MDM에서 사용 중지되었습니다.' +char(10) + N'Ship-To Code: '+ RTRIM(LTRIM(@v_shipto_code)) +char(10) +  N'Sold-To Code: ' + RTRIM(LTRIM(@v_soldto_code))
					   SET @v_description =  N'Invalid soldto - shipto mapping' +char(10) +  N'Sold-To Code: ' + RTRIM(LTRIM(@v_soldto_code)) + N'Ship-To Code: '+ RTRIM(LTRIM(@v_shipto_code)) +char(10) 
					   goto err_rtn
				   END
				   
				--End [C20201217-000228] Sales Site에서 Sold to, Ship to의 Valid가 'N'인 대상은 Active 'Y'로 변경 불가
			--------------------------------------------------------------------------------------------------------------------------------------- 20181011 KHSONG SCM_MST_CUSTOMER Validation Check (END)
			
				--[PJ20228272]NERP 대응 - NERP 오픈 이후 신코드만 대표코드로 설정 가능
				--20240522 SM NERP관련 수정
				--START
				--print @v_rep_yn + '/' + @v_division_id + '/' + @v_shipto_code + '/' + @v_soldto_code
			   IF @v_rep_yn = 'Y' 
			   BEGIN
					-----------------------------------------------------------------------------------------------------------------------------
					--[IT20250117A]_NERP MASTER 바라보도록 수정 START
					-- ERP에서 1차 CONVERSION 대상들에 대해서도 계속 OLD 데이터로 데이터를 넘겨주는 것을 확인하여, 직접 NERP 테이블을 바라보고 이미 지나간 차수에 
					--대해서는 OLD VALUE가 저장되지 않도록 수정 과거 소스 주석처리하고 NERP MASTER 바라보도록 수정 
					--SHIPTO_CODE, SOLDTO_CODE 둘중에 하나라도 OLD가 들어오면 안되므로, OR로 JOIN함.
					-----------------------------------------------------------------------------------------------------------------------------
					/*
					IF isnull((select count(1) from SCM_MST_CUSTOMER 
								where 1=1
  								  and division_id = @v_division_id
  								  and shipto_code = @v_shipto_code
								  and soldto_code = @v_soldto_code
								  AND ISNULL(attribute1,'') = 'OLD'
							   ),0) > 0*/
					IF isnull((	SELECT COUNT(1)
								FROM 
								(	SELECT SHIPTO_CODE, SOLDTO_CODE
									FROM SCM_MST_CUSTOMER WITH(NOLOCK)
									WHERE DIVISION_ID = @v_division_id
									AND   SHIPTO_CODE = @v_shipto_code
									AND   SOLDTO_CODE = @v_soldto_code ) A
								INNER JOIN ( SELECT OLD_VALUE1
											 FROM NERP_CONV_MASTER WITH(NOLOCK)
											 WHERE CODETYPE = 'END_CUSTOMER_ID') B
										ON A.SOLDTO_CODE = B.OLD_VALUE1	OR A.SHIPTO_CODE = B.OLD_VALUE1
							   ),0) > 0  
					-----------------------------------------------------------------------------------------------------------------------------
					--[IT20250117A]_NERP MASTER 바라보도록 수정 END
					----------------------------------------------------------------------------------------------------------------------------- 
					BEGIN
						SET @v_log_type = 'INVALID';
						SELECT N'구버전 soldto_code를 대표코드로 선택할 수 없습니다.'
						SET @v_description =  N'구버전 soldto_code를 대표코드로 선택할 수 없습니다.'
						GOTO err_rtn;
					END
				END
				--END

			IF @mst_loop_cnt > 0 

				--다중 ROW 일때 (START)
				BEGIN       
				
				-- 	SCM_MST_SITE_CUSTOMER MASTER SAVE LOGIC
					
					IF EXISTS
					(
						SELECT 
							A.division_id,A.scm_site_id,A.soldto_code,A.shipto_code  
						FROM	
						[dbo].[SCM_MST_SITE_CUSTOMER] A  WITH(NOLOCK)	,
						(
								SELECT 
									@v_division_id	as division_id, 
									@v_scm_site_id	as scm_site_id, 
									@v_soldto_code	as soldto_code, 
									@v_shipto_code	as shipto_code
						) B
						,dbo.scm_mst_site C  -- Added by ytchoi 180730
						WHERE  1 = 1	
								AND A.division_id  = B.division_id
								AND A.scm_site_id  = B.scm_site_id
								AND A.soldto_code  = B.soldto_code
								AND A.shipto_code  = B.shipto_code

								  -- Added by ytchoi 180730
								and A.division_id  = c.DIVISION_ID
								and A.scm_site_id  = c.scm_site_id
								and c.site_type    = 'SALES'
					)

						IF @v_rep_yn = 'Y'

							BEGIN

								 UPDATE [dbo].[SCM_MST_SITE_CUSTOMER] 
								 SET
										REP_YN = 'N'
								 WHERE 
										division_id  = @v_division_id
									AND scm_site_id  = @v_scm_site_id
								;	
						
								UPDATE [dbo].[SCM_MST_SITE_CUSTOMER] 
								 SET 
										 division_id		= @v_division_id
										,scm_site_id	    = @v_scm_site_id
										,soldto_code	    = @v_soldto_code
										,shipto_code		= @v_shipto_code
										,rep_yn				= @v_rep_yn
										,valid_yn			= @v_valid_yn
										,last_updated_by	= @v_created_by
										,last_update_date	= sysdatetime()
								WHERE
										division_id  = @v_division_id
									AND scm_site_id  = @v_scm_site_id
									AND soldto_code  = @v_soldto_code
									AND shipto_code  = @v_shipto_code	
								;

							END

						ELSE

							BEGIN

								UPDATE [dbo].[SCM_MST_SITE_CUSTOMER] 
								 SET 
										 division_id		= @v_division_id
										,scm_site_id	    = @v_scm_site_id
										,soldto_code	    = @v_soldto_code
										,shipto_code		= @v_shipto_code
										,rep_yn				= @v_rep_yn
										,valid_yn			= @v_valid_yn
										,last_updated_by	= @v_created_by
										,last_update_date	= sysdatetime()
								WHERE
										division_id  = @v_division_id
									AND scm_site_id  = @v_scm_site_id
									AND soldto_code  = @v_soldto_code
									AND shipto_code  = @v_shipto_code	
								;

							END

					ELSE
						BEGIN
						----------------------------------------------------------------------------------------------------------------------------------------- 20181115 KHSONG 신규 insert 요청시 기존 Shipto code에 앞 2자리가 SCM_MST_SITE의 국가코드와 Validation (START)
						IF  (SELECT LEN(@v_shipto_code)) > 4   -- 20200528 KHSONG C20200417-000237 (Sales site-Ship-to 코드 생성시 Validation 로직 변경) 국가코드4자리값이 아닌경우
							-----
							BEGIN
							-----
								-- [C20210305-000229]
								IF( NOT EXISTS (SELECT TOP 1 *
													   FROM [DBO].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)  
													  WHERE LOOKUP_TYPE = 'SALES_SITE_ID_ADDTION'  
														AND SEGMENT1 = @V_SCM_SITE_ID
														AND VALID_YN = 'Y'  
														)
										) 
								BEGIN

										IF (SELECT ISNULL(count(*),0) 	FROM SCM_MST_SITE with(nolock)
																			WHERE DIVISION_ID	= @v_division_id
																			  and scm_site_id	= @v_scm_site_id
																			  and COUNTRY		= substring(@v_shipto_code,1,2)
																			  and VALID_YN = 'Y'
											) = 0

											-----------
											BEGIN
											-----------
												SET @v_log_type = 'INVALID';
												SET @v_description =  N'Sales Site의 국가와 등록하려는 Shipto Code의 국가 코드가 다릅니다.' +char(10)+ N' Div : ' 
																	+ RTRIM(LTRIM(@v_division_id)) +char(10) + N' Sales Site : ' + RTRIM(LTRIM(@v_scm_site_id)) +char(10) + N' Shipto Code : ' + RTRIM(LTRIM(@v_shipto_code)) 
												SELECT @v_description
												GOTO ERR_RTN
											-----------
											END
											-----------
								END
							-----
							END
							-----
						----------------------------------------------------------------------------------------------------------------------------------------- 20181115 KHSONG 신규 insert 요청시 기존 Shipto code에 앞 2자리가 SCM_MST_SITE의 국가코드와 Validation (END)
						INSERT INTO	[dbo].[SCM_MST_SITE_CUSTOMER]
								(  
								    division_id		
								   ,scm_site_id							   
								   ,soldto_code
								   ,shipto_code
								   ,rep_yn
								   ,valid_yn
								   ,created_by
								   ,creation_date
								   ,last_updated_by
								   ,last_update_date
								)
						 VALUES (   
									@v_division_id
								   ,@v_scm_site_id	
								   ,@v_soldto_code
								   ,@v_shipto_code
								   ,@v_rep_yn
								   ,@v_valid_yn
								   --,CONVERT(INT,  CAST(@v_qty AS NVARCHAR(10)))
								   ,@v_created_by
								   ,sysdatetime()
								   ,@v_created_by
								   ,sysdatetime()
								);
						END


				END
				--다중 ROW 일때 (END)

			ELSE    
			 
				--단일 ROW 일때 (START)
				BEGIN        
					SET @v_active_flag			= @p_active_flag        
					SET @p_active_flag			= NULL       
					SET @v_division_id			= @p_division_id        
					SET @p_division_id			= NULL      
					SET @v_soldto_code			= @p_soldto_code        
					SET @p_soldto_code			= NULL  
					SET @v_soldto_description	= @p_soldto_description        
					SET @p_soldto_description	= NULL  
					SET @v_shipto_code			= @p_shipto_code        
					SET @p_shipto_code			= NULL  
					SET @v_shipto_description	= @p_shipto_description     
					SET @p_shipto_description	= NULL  
					SET @v_rep_yn				= @p_rep_yn      
					SET @p_rep_yn				= NULL  
					SET @v_valid_yn				= @p_valid_yn      
					SET @p_valid_yn				= NULL  
					SET @v_created_by = @p_created_by
					SET @p_created_by = NULL
			 
				--HISTORY INSERT
				EXEC	[dbo].[PR_DM_MST_SITE_CUSTOMER_HIST]	--@return_value = [dbo].[PR_DM_MST_SITE_CUSTOMER_HIST]
						@v_division_id,
						@v_scm_site_id,
						@v_soldto_code,
						@v_shipto_code,		
						@v_rep_yn,
						@v_created_by
						, @v_valid_yn		-- [C20210115-000214] (1)

						--SELECT @v_OK_description;
						--@v_OK_description OUTPUT
					
					IF EXISTS
					(
						SELECT 
							A.division_id,A.scm_site_id,A.soldto_code,A.shipto_code  
						FROM	
						[dbo].[SCM_MST_SITE_CUSTOMER] A  WITH(NOLOCK)	,
						(
								SELECT 
									@v_division_id	as division_id, 
									@v_scm_site_id	as scm_site_id, 
									@v_soldto_code	as soldto_code, 
									@v_shipto_code	as shipto_code
						) B
						,dbo.scm_mst_site C  -- Added by ytchoi 180730
						WHERE  1 = 1	
								AND A.division_id  = B.division_id
								AND A.scm_site_id  = B.scm_site_id
								AND A.soldto_code  = B.soldto_code
								AND A.shipto_code  = B.shipto_code

								  -- Added by ytchoi 180730
								and A.division_id  = c.DIVISION_ID
								and A.scm_site_id  = c.scm_site_id
								and c.site_type    = 'SALES'

					)

						IF @v_rep_yn = 'Y'

							BEGIN

								 UPDATE [dbo].[SCM_MST_SITE_CUSTOMER] 
								 SET
										REP_YN = 'N'
								 WHERE 
										division_id  = @v_division_id
									AND scm_site_id  = @v_scm_site_id
								;	
						
								UPDATE [dbo].[SCM_MST_SITE_CUSTOMER] 
								 SET 
										 division_id		= @v_division_id
										,scm_site_id	    = @v_scm_site_id
										,soldto_code	    = @v_soldto_code
										,shipto_code		= @v_shipto_code
										,rep_yn				= @v_rep_yn
										,valid_yn			= @v_valid_yn
										,last_updated_by	= @v_created_by
										,last_update_date	= sysdatetime()
								WHERE
										division_id  = @v_division_id
									AND scm_site_id  = @v_scm_site_id
									AND soldto_code  = @v_soldto_code
									AND shipto_code  = @v_shipto_code	
								;
							END

						ELSE

							BEGIN

								UPDATE [dbo].[SCM_MST_SITE_CUSTOMER] 
								 SET 
										 division_id		= @v_division_id
										,scm_site_id	    = @v_scm_site_id
										,soldto_code	    = @v_soldto_code
										,shipto_code		= @v_shipto_code
										,rep_yn				= @v_rep_yn
										,valid_yn			= @v_valid_yn
										,last_updated_by	= @v_created_by
										,last_update_date	= sysdatetime()
								WHERE
										division_id  = @v_division_id
									AND scm_site_id  = @v_scm_site_id
									AND soldto_code  = @v_soldto_code
									AND shipto_code  = @v_shipto_code	
								;

							END


					ELSE
						BEGIN
						--------------------------------------------------------------------------------------------------------------------------------------- 20181115 KHSONG 신규 insert 요청시 기존 Shipto code에 앞 2자리가 SCM_MST_SITE의 국가코드와 Validation (START)

						IF  (SELECT LEN(@v_shipto_code)) > 4   -- 20200528 KHSONG C20200417-000237 (Sales site-Ship-to 코드 생성시 Validation 로직 변경) 국가코드4자리값이 아닌경우
							-----
							BEGIN
							-----
								-- [C20210305-000229]
								IF( NOT EXISTS (SELECT TOP 1 *
													   FROM [DBO].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)  
													  WHERE LOOKUP_TYPE = 'SALES_SITE_ID_ADDTION'  
														AND SEGMENT1 = @V_SCM_SITE_ID
														AND VALID_YN = 'Y'  
														)
										) 
								BEGIN
										IF (SELECT ISNULL(count(*),0) 	FROM SCM_MST_SITE with(nolock)
																			WHERE DIVISION_ID	= @v_division_id
																			  and scm_site_id	= @v_scm_site_id
																			  and COUNTRY		= substring(@v_shipto_code,1,2)
																			  and VALID_YN = 'Y'
											) = 0

											-----------
											BEGIN
											-----------
												SET @v_log_type = 'INVALID';
												SET @v_description =  N'Sales Site의 국가와 등록하려는 Shipto Code의 국가 코드가 다릅니다.' +char(10)+ N' Div : ' 
																	+ RTRIM(LTRIM(@v_division_id)) +char(10) + N' Sales Site : ' + RTRIM(LTRIM(@v_scm_site_id)) +char(10) + N' Shipto Code : ' + RTRIM(LTRIM(@v_shipto_code)) 
												SELECT @v_description
												GOTO ERR_RTN
											-----------
											END
											-----------
								END
							-----
							END
							-----

						--------------------------------------------------------------------------------------------------------------------------------------- 20181115 KHSONG 신규 insert 요청시 기존 Shipto code에 앞 2자리가 SCM_MST_SITE의 국가코드와 Validation (END)
						INSERT INTO	[dbo].[SCM_MST_SITE_CUSTOMER]
								(  
								    division_id		
								   ,scm_site_id							   
								   ,soldto_code
								   ,shipto_code
								   ,rep_yn
								   ,valid_yn
								   ,created_by
								   ,creation_date
								   ,last_updated_by
								   ,last_update_date
								)
						 VALUES (   
									@v_division_id
								   ,@v_scm_site_id	
								   ,@v_soldto_code
								   ,@v_shipto_code
								   ,@v_rep_yn
								   ,@v_valid_yn
								   --,CONVERT(INT,  CAST(@v_qty AS NVARCHAR(10)))
								   ,@v_created_by
								   ,sysdatetime()
								   ,@v_created_by
								   ,sysdatetime()
								);
						END

				END
				--단일 ROW 일때 (END)
			--------------------------------------------------------------------------------------------------------------------------------------- 20180418 ADD SKH -- 20220426 EDIT(start)
			   IF ISNULL((SELECT COUNT(1) 
			                FROM SCM_MST_SITE_CUSTOMER A
							    ,DBO.SCM_MST_SITE C  -- ADDED BY YTCHOI 180730
			                WHERE 1=1
  							  AND A.DIVISION_ID = @v_division_id
  							  AND A.SHIPTO_CODE = @v_shipto_code
							  AND A.SOLDTO_CODE = @v_soldto_code -- added by ytchoi 20180628
							  AND A.VALID_YN = 'Y'                    -- VALID_YN = 'Y' 것만 중복체크
							  -- Added by ytchoi 180730
							  AND A.DIVISION_ID  = C.DIVISION_ID
							  AND A.SCM_SITE_ID  = C.SCM_SITE_ID
							  AND C.SITE_TYPE    = 'SALES'
			                GROUP BY A.DIVISION_ID, A.SHIPTO_CODE
							HAVING COUNT(*) > 1                     -- ui에서 input받은 데이터 포함하여 2건이상인것 체크
				   ),0) > 1  AND @v_valid_yn = 'Y' -- Valid를 Y로 하는 경우에만 Check 하도록 함. 20180611 ytchoi
				   BEGIN  -- 중복 발생인경우의 logic

					   SELECT TOP 1 @v_dup_scm_site_id = A.SCM_SITE_ID 
						FROM SCM_MST_SITE_CUSTOMER A  -- 정상인경우 2건이상일수 없지만 현재 데이터정비가 되어있지 않아 TOP 1 으로 한건만 추출
						INNER JOIN SCM_MST_SITE C
								ON A.DIVISION_ID  = C.DIVISION_ID
								AND A.SCM_SITE_ID  = C.SCM_SITE_ID
								AND C.SITE_TYPE    = 'SALES'
						WHERE 1=1
  							AND A.DIVISION_ID = @v_division_id
  							AND A.SHIPTO_CODE = @v_shipto_code
							AND A.SOLDTO_CODE = @v_soldto_code -- added by ytchoi 20180628
							AND A.SCM_SITE_ID <> @v_scm_site_id      -- ui에서 input받은 scm_site_id 제외하고 존재하고있는 scm_site_id 를 추출
							AND A.VALID_YN = 'Y'

					   SET @v_log_type = 'INVALID';
					   SELECT N'MSG00179',@v_dup_scm_site_id,@v_shipto_code     -- ui측에 전달하여 중복대상인 scm_site_id와 shipto_code를 pop_up 시킴
					   --  ' Ford_US_RDF Sales Site 에서 USH000534A Ship-To Code가 이미 사용중입니다.'
					   --   {0} Sales Site 에서  {1} Ship-To Code가 이미 사용중입니다.
					   SET @v_description = @v_dup_scm_site_id + N' Sales Site 에서' + @v_shipto_code + N'Ship-To Code가 이미 사용중입니다.'  -- 20180626 khsong INVALID LOG 생성
					   GOTO err_rtn
				   END
			--------------------------------------------------------------------------------------------------------------------------------------- 20180418 ADD SKH -- 20220426 EDIT (end)




			END

			--------------------------------------------------------------------------------------------------------------------------------------- 20181030 KHSONG rep_yn 중복 Validation 추가 (start)
			   IF isnull((select count(1) 
			                from SCM_MST_SITE_CUSTOMER A
							    ,dbo.scm_mst_site C
			                where 1=1
  							  and A.division_id  = @v_division_id
							  and A.scm_site_id  = @v_scm_site_id
							  and A.rep_yn       = 'Y'              -- rep_yn   = 'Y' 것만 중복체크
							  and A.division_id  = c.DIVISION_ID
							  and A.scm_site_id  = c.scm_site_id
							  and c.site_type    = 'SALES'
			                group by A.division_id, A.scm_site_id
							HAVING COUNT(*) > 1                     -- ui에서 input받은 데이터 포함하여 2건이상인것 체크
				   ),0) > 1
				   begin  -- 중복 발생인경우의 logic
					   SET @v_log_type = 'INVALID';
					   SELECT N'MSG00149'
					   SET @v_description = @v_dup_scm_site_id + N' Sales Site 에서 Rep값 설정이 중복되었습니다.'
					   goto err_rtn
				   end
			--------------------------------------------------------------------------------------------------------------------------------------- 20181030 KHSONG rep_yn 중복 Validation 추가 (end)
			
			--------------------------------------------------------------------------------------------------------------------------------------- 20181107 KHSONG 기존 SCM_MST_SITE_CUSTOMER의 soldto_code 와 동일한지 Validation Check (START)
			-- [C20210305-000229]
			IF( NOT EXISTS (SELECT TOP 1 *
								   FROM [DBO].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)  
								  WHERE LOOKUP_TYPE = 'SALES_SITE_ID_ADDTION'  
									AND SEGMENT1 = @V_SCM_SITE_ID
									AND VALID_YN = 'Y'  
									)
					) 
			BEGIN

				IF (SELECT ISNULL(MAX(ROWNUM),0) FROM (
										--[E20250205-001041]_Sales Site의 Sold To 구코드, 신코드 인식 오류 검토 요청의 건
										-- SOLDTO_CODE 중복 확인 시 NERP 신코드/구코드가 동일한 경우에 제외
										/*
										SELECT division_id,SCM_SITE_ID,SOLDTO_CODE,row_number() OVER (ORDER BY DIVISION_ID) AS ROWNUM
											 FROM SCM_MST_SITE_CUSTOMER with(nolock)
												  WHERE DIVISION_ID = @v_division_id
													and scm_site_id = @v_scm_site_id
													AND VALID_Yn = 'Y'
										GROUP BY DIVISION_ID, SCM_SITE_ID,SOLDTO_CODE
										*/
										SELECT A.DIVISION_ID, A.SCM_SITE_ID, ISNULL(B.NEW_VALUE1, A.SOLDTO_CODE) AS SOLDTO_CODE, row_number() OVER (ORDER BY DIVISION_ID) AS ROWNUM
										FROM   SCM_MST_SITE_CUSTOMER A  WITH (NOLOCK)
										LEFT JOIN NERP_CONV_MASTER B WITH (NOLOCK)
										ON    A.SOLDTO_CODE = B.OLD_VALUE1
										AND   B.CODETYPE = 'END_CUSTOMER_ID'
										WHERE A.DIVISION_ID = @v_division_id
										AND   A.SCM_SITE_ID = @v_scm_site_id
										AND   A.VALID_YN = 'Y'
										GROUP BY A.DIVISION_ID, A.SCM_SITE_ID, ISNULL(B.NEW_VALUE1, A.SOLDTO_CODE)
											) A
					) > 1

				   BEGIN
					   SET @v_log_type = 'INVALID';
					   SELECT N'하나의 Sales Site에 2개 이상의 Sold-To는 등록할 수 없습니다.'-- +char(10) 
							--+ N'Invalid soldto - shipto mapping' +char(10) 
							--+ N'Sold-To Code: ' + RTRIM(LTRIM(@v_soldto_code))
					   SET @v_description =  N'하나의 Sales Site에 2개 이상의 Sold-To는 등록할 수 없습니다. ' + N'Sold-To Code: ' + RTRIM(LTRIM(@v_soldto_code)) 
					   goto err_rtn
				   END
			END
			--------------------------------------------------------------------------------------------------------------------------------------- 20181107 KHSONG 기존 SCM_MST_SITE_CUSTOMER의 soldto_code 와 동일한지 Validation Check (END)

			COMMIT TRAN ;	

		END TRY

	BEGIN CATCH

		ROLLBACK TRAN ;	

		  -- ERROR LOG
		  SET @v_log_type = 'ERROR';
		  SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		  SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		  SET @d_event_date = SYSDATETIME();

		  --IF @v_OK_description <> 'OK'
		  --SET @v_log_message = CAST(@v_OK_description AS NVARCHAR(1000));
		  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();

	END CATCH;

	SET NOCOUNT OFF;


	-- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	
    --------------------------------------------------------------------------------------------------------------------------------------- 20180418 ADD SKH (start)
	-- 트랜잭션 (END)
	err_rtn:
	IF @v_log_type = 'INVALID'
		begin
			ROLLBACK TRAN
			--20180626 khsong INVALID LOG 생성
			SET @v_log_message = '########## END of procedure ##########';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
				
			-- 종료 LOG
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		end
    --------------------------------------------------------------------------------------------------------------------------------------- 20180418 ADD SKH (end)

	END;
