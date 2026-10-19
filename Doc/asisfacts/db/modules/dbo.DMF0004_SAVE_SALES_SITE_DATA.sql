
/*=====================================================================================================================
 * Program ID  : [DM0004_SAVE_SALES_SITE_DATA]														
 * Description : SCM_MST_SITE HISTORYT INSERT														
 * Usage       : Procedure 작성 시 참조하세요!                                                      
 * Parameter   :                                                                                   
 *=====================================================================================================================
 * Date       In Charge     Description                                                             
 *=====================================================================================================================
 * 2017/12/04 DWOK/DWPARK	Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/05/14 KHSONG		Site 중복 Validation 조건 추가                                         
 * 2018/06/21 KHSONG		vmi_yn값이 없는경우 'N'으로 기본값 셋팅
 * 2018/06/27 KHSONG		Team Id값 Validation 추가
 * 2018/07/12 KHSONG		SCM_MST_SITE 에 UPDATE건중 VALID_YN='N'이면 SCM_MST_SITE_CUSTOMER의 데이터를 VALID_YN='N'으로 일괄 업데이트함
 * 2018/07/26 KHSONG		VALID_YN='N'으로 일괄 업데이트건 History 생성 추가
 * 2018/09/07 KHSONG		company_id 추가
 * 2018/11/21 KHSONG		VALID_YN='N' 처리시 DM_PLN_SALES_PLAN,DM_PLN_SALES_PLAN_RESULT 테이블의 정보를 확인후 alert창을 띄움
 * 2019/01/23 khsong		전지재료 로직추가
 * 2020/03/06 hwi1993		이름 변경 ( DM --> DMF ) DM0004_SAVE_SALES_SITE_DATA --> DMF0004_SAVE_SALES_SITE_DATA
 * 2020/03/06 hwi1993		[CSR:C20200303-000235 ] Ship plan Auto 추가 ( Attribute2 컬럼 사용 )
 * 2020/04/22 P.C.I			[PJ20200138] 전지 공급 대응력 향상을 위한 RTF 적확도 개선-유통경로 추가
 * 2020/10/08 P.C.I			[C20200915-000323] Sales Site 에대한 team 변경 권한 추가
 * 2020/11/11 hwi1993		SI mkt fcst 입력시 vmi req 자동 산출. site 별로 vmi 재고일수 추가 ( attribute5)
 * 2020/12/15 hwi1993		Invalid 가 나와도 마지막 로그는 END 가 찍히도록 변경
 * 2021/01/18 KUNI			[C20210115-000214] (1)Sales Site (Sales Customer) - Active 이력 저장관련 오류사항 
 * 2025/07/15 JSSBAE		[E20250522-001188]_Business Plan UI 데이터 저장 시 Trim 처리
 * =======================================================================================================================*/

CREATE PROCEDURE [dbo].[DMF0004_SAVE_SALES_SITE_DATA]
	@p_active_flag		NVARCHAR(MAX),
	@p_division_id		NVARCHAR(MAX),
	@p_scm_site_id		NVARCHAR(MAX),
	@p_site_description	NVARCHAR(MAX),
	@p_end_customer     NVARCHAR(MAX),
	@p_sold_customer    NVARCHAR(MAX),
	@p_city				NVARCHAR(MAX),
	@p_country			NVARCHAR(MAX),
	@p_dept_id			NVARCHAR(MAX),
	@p_vmi_yn			NVARCHAR(MAX),
	@p_valid_yn			NVARCHAR(MAX),
	@p_created_by		NVARCHAR(MAX),
	@p_company_id 		NVARCHAR(MAX),  -- 20180907 KHSONG company_id 추가
	@p_ship_plan_auto	NVARCHAR(MAX),  -- 20200306
	@p_distribution_channel	NVARCHAR(MAX),  -- [PJ20200138] Distribution Channel 추가
	@p_attribute5		NVARCHAR(MAX)	-- 


AS

BEGIN

	SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;
	--DECLARE	@v_OK_description		NVARCHAR(1200);	-- cut off Generated Number	

	DECLARE @v_active_flag			    NVARCHAR(MAX);
	DECLARE @v_DIVISION_ID      		NVARCHAR(MAX);
	DECLARE @v_SCM_SITE_ID      		NVARCHAR(MAX);
	DECLARE @v_PLANT_ID         		NVARCHAR(MAX);
	DECLARE @v_OPERATION_GROUP  		NVARCHAR(MAX);
	DECLARE @v_SITE_DESCRIPTION 		NVARCHAR(MAX);
	DECLARE @v_SITE_TYPE        		NVARCHAR(MAX);
	DECLARE @v_CITY             		NVARCHAR(MAX);
	DECLARE @v_COUNTRY          		NVARCHAR(MAX);
	DECLARE @v_DEPT_ID          		NVARCHAR(MAX);
	DECLARE @v_VMI_YN           		NVARCHAR(MAX);
	DECLARE @v_VALID_YN         		NVARCHAR(MAX);
	DECLARE @v_NEW_YN           		NVARCHAR(MAX);
	DECLARE @v_SITE_HRCY_ID     		NVARCHAR(MAX);
	DECLARE @v_OSP_YN           		NVARCHAR(MAX);
	DECLARE @v_SHIP_FROZEN      		NVARCHAR(MAX);
	DECLARE @v_PROD_FROZEN      		NVARCHAR(MAX);
	DECLARE @v_END_CUSTOMER     		NVARCHAR(MAX);
	DECLARE @v_SOLDTO_CUSTOMER  		NVARCHAR(MAX);
	DECLARE @v_FP_PLAN_PERIOD   		NVARCHAR(MAX);
	DECLARE @v_BUILD_AHEAD      		NVARCHAR(MAX);
	DECLARE @v_LOGISTIC_PLANT_ID		NVARCHAR(MAX);
	DECLARE @v_COMPANY_ID       		NVARCHAR(MAX);
	DECLARE @v_SITE_ID          		NVARCHAR(MAX);
	DECLARE @v_CREATED_BY       		NVARCHAR(MAX);
	DECLARE @v_LAST_UPDATED_BY  		NVARCHAR(MAX);
	DECLARE @v_ship_plan_auto	  		NVARCHAR(MAX);
	DECLARE @v_distribution_channel	    NVARCHAR(MAX); -- [PJ20200138] Distribution Channel 추가
	DECLARE @v_attribute5				NVARCHAR(MAX);

	SET @v_active_flag       = NULL;
	SET @v_DIVISION_ID       = NULL;
	SET @v_SCM_SITE_ID       = NULL;
	SET @v_PLANT_ID          = NULL;
	SET @v_OPERATION_GROUP   = NULL;
	SET @v_SITE_DESCRIPTION  = NULL;
	SET @v_SITE_TYPE         = NULL;
	SET @v_CITY              = NULL;
	SET @v_COUNTRY           = NULL;
	SET @v_DEPT_ID           = NULL;
	SET @v_VMI_YN            = NULL;
	SET @v_VALID_YN          = NULL;
	SET @v_NEW_YN            = NULL;
	SET @v_SITE_HRCY_ID      = NULL;
	SET @v_OSP_YN            = NULL;
	SET @v_SHIP_FROZEN       = NULL;
	SET @v_PROD_FROZEN       = NULL;
	SET @v_END_CUSTOMER      = NULL;
	SET @v_SOLDTO_CUSTOMER   = NULL;
	SET @v_FP_PLAN_PERIOD    = NULL;
	SET @v_BUILD_AHEAD       = NULL;
	SET @v_LOGISTIC_PLANT_ID = NULL;
	SET @v_COMPANY_ID        = NULL;
	SET @v_SITE_ID           = NULL;
	SET @v_CREATED_BY        = NULL;
	SET @v_LAST_UPDATED_BY   = NULL;
	SET @v_ship_plan_auto	 = NULL;
	SET @v_distribution_channel = NULL; -- [PJ20200138] Distribution Channel 추가
	SET @v_attribute5		= NULL;

	DECLARE @v_delimiter NVARCHAR(1);
	SET @v_delimiter = '^';

	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'DM0004_SAVE_SALES_SITE_DATA';
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
	
PRINT @v_program_name +' : A001--' + CONVERT(VARCHAR(30), GETDATE(), 121);
	-- 시작 LOG  (END)
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

	BEGIN TRAN SAVE_SALES_SITE_DATA;
	
	BEGIN TRY
	
		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);    
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

				SET @v_site_description = [dbo].[SCM_ARR_SPL_VAL](@p_site_description, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_site_description
			    
				SET @v_end_customer = [dbo].[SCM_ARR_SPL_VAL](@p_end_customer, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @v_end_customer

				SET @v_soldto_customer = [dbo].[SCM_ARR_SPL_VAL](@p_sold_customer, @v_delimiter , @mst_loop_cnt) ;    
				--SELECT @@v_soldto_customer

				SET @v_city = [dbo].[SCM_ARR_SPL_VAL](@p_city, @v_delimiter , @mst_loop_cnt) ; 
				--SELECT @v_city

				SET @v_country = [dbo].[SCM_ARR_SPL_VAL](@p_country, @v_delimiter, @mst_loop_cnt) ; 
				--SELECT @v_country

				SET @v_dept_id = [dbo].[SCM_ARR_SPL_VAL](@p_dept_id, @v_delimiter, @mst_loop_cnt) ; 
				--SELECT @v_dept_id

				SET @v_vmi_yn = [dbo].[SCM_ARR_SPL_VAL](@p_vmi_yn, @v_delimiter, @mst_loop_cnt) ; 
				--SELECT @v_vmi_yn

				-- 20180621 KHSONG vmi_yn값이 없는경우 'N'으로 기본값 셋팅
				IF  @v_vmi_yn = '' OR @v_vmi_yn IS NULL
					SET @v_vmi_yn = 'N'

				IF  @v_dept_id  IS NULL
					SET @v_dept_id = ''

				SET @v_valid_yn = [dbo].[SCM_ARR_SPL_VAL](@p_valid_yn, @v_delimiter, @mst_loop_cnt) ; 
				--SELECT @v_valid_yn

				SET @v_created_by = [dbo].[SCM_ARR_SPL_VAL](@p_created_by, @v_delimiter, @mst_loop_cnt) ; 
				--SELECT @v_created_by
						
				SET @v_LAST_UPDATED_BY = @v_created_by
				
				SET @v_COMPANY_ID = [dbo].[SCM_ARR_SPL_VAL](@p_COMPANY_ID, @v_delimiter, @mst_loop_cnt) ;
				
				SET @v_ship_plan_auto = [dbo].[SCM_ARR_SPL_VAL](@p_ship_plan_auto, @v_delimiter, @mst_loop_cnt) ; 

				--[PJ20200138] Distribution Channel 추가
				SET @v_distribution_channel = [dbo].[SCM_ARR_SPL_VAL](@p_distribution_channel, @v_delimiter, @mst_loop_cnt) ; 

				SET @v_attribute5	= [dbo].[SCM_ARR_SPL_VAL](@p_attribute5, @v_delimiter, @mst_loop_cnt) ; 
				
				--------------------------------------------------------------------------------------------------
				-- [E20250522-001188]_RTRLIM, LTRIM 추가한다. (START)	
				SET @v_active_flag			= RTRIM(LTRIM(@v_active_flag))
				SET @v_division_id			= RTRIM(LTRIM(@v_division_id))
				SET @v_scm_site_id			= RTRIM(LTRIM(@v_scm_site_id))
				SET @v_site_description		= RTRIM(LTRIM(@v_site_description))
				SET @v_end_customer			= RTRIM(LTRIM(@v_end_customer))
				SET @v_soldto_customer		= RTRIM(LTRIM(@v_soldto_customer))
				SET @v_city					= RTRIM(LTRIM(@v_city))
				SET @v_country				= RTRIM(LTRIM(@v_country))
				SET @v_OPERATION_GROUP		= RTRIM(LTRIM(@v_OPERATION_GROUP))
				SET @v_dept_id				= RTRIM(LTRIM(@v_dept_id))
				SET @v_vmi_yn				= RTRIM(LTRIM(@v_vmi_yn))
				SET @v_valid_yn				= RTRIM(LTRIM(@v_valid_yn))
				SET @v_created_by			= RTRIM(LTRIM(@v_created_by))
				SET @v_LAST_UPDATED_BY		= RTRIM(LTRIM(@v_LAST_UPDATED_BY))
				SET @v_COMPANY_ID			= RTRIM(LTRIM(@v_COMPANY_ID))
				SET @v_ship_plan_auto		= RTRIM(LTRIM(@v_ship_plan_auto))
				SET @v_distribution_channel	= RTRIM(LTRIM(@v_distribution_channel))
				SET @v_attribute5			= RTRIM(LTRIM(@v_attribute5))
				-- [E20250522-001188]_RTRLIM, LTRIM 추가한다. (END)					
				--------------------------------------------------------------------------------------------------
			END
			
PRINT @v_program_name +' : A002--' + CONVERT(VARCHAR(30), GETDATE(), 121);
	       -- 필수컬럼값 null 인입되었을때 강제 RollBack 시킴 start 20180426 skh -----------------------------------------------
	       IF     @v_division_id = ''
		      or  @v_scm_site_id = ''
			  or  @v_end_customer = ''
			  or  @v_soldto_customer = ''
			  or  @v_city = ''
			  or  @v_country = ''
			  or  @v_division_id is null
			  or  @v_scm_site_id is null
			  or  @v_end_customer is null
			  or  @v_soldto_customer is null
			  or  @v_city is null
			  or  @v_country is null
			  or  @v_ship_plan_auto is null

			  BEGIN
				   SET @v_log_type = 'INVALID';
				   SELECT N'필수 입력값을 확인하세요.'
				   SET @v_description = N'필수 입력값을 확인하세요.'
				   goto err_rtn
			  END
	       -- 필수컬럼값 null 인입되었을때 강제 RollBack 시킴 end 20180426 skh -----------------------------------------------
		   
PRINT @v_program_name +' : A003--' + CONVERT(VARCHAR(30), GETDATE(), 121);
			--[E20250305-000665]_Sales Site UI 입력항목 필수입력 처리 요청 START
			IF @v_COMPANY_ID = ''
			
			  BEGIN
				   SET @v_log_type = 'INVALID';
				   SELECT N'Company는 필수 입력 항목입니다.'
				   SET @v_description = N'Company는 필수 입력 항목입니다.'
				   goto err_rtn
			  END
			--[E20250305-000665]_Sales Site UI 입력항목 필수입력 처리 요청 END
			
PRINT @v_program_name +' : A004--' + CONVERT(VARCHAR(30), GETDATE(), 121);
				----------◎◎◎◎ 20181121 KHSONG VALID_YN='N' 처리시 DM_PLN_SALES_PLAN,DM_PLN_SALES_PLAN_RESULT 테이블의 정보를 확인후 alert창을 띄움 (START)
				IF @v_valid_yn = 'N' and @v_division_id = '40'
					BEGIN
						IF (
							SELECT ISNULL(COUNT(1),0) FROM
															(SELECT TOP 1 DIVISION_ID
																FROM  DM_PLN_SALES_PLAN WITH(NOLOCK)
																	WHERE 1=1
																	  AND DIVISION_ID		=	@v_DIVISION_ID
																	  AND SCM_SITE_ID		=	@v_SCM_SITE_ID
																	  AND QTY <> 0
															UNION
															SELECT TOP 1 DIVISION_ID
																FROM  DM_PLN_SALES_PLAN_RESULT WITH(NOLOCK)
																	WHERE 1=1
																	  AND DIVISION_ID		=	@v_DIVISION_ID
																	  AND SCM_SITE_ID		=	@v_SCM_SITE_ID
																	  AND QTY <> 0
																) A
						   ) > 0
							BEGIN
								set @v_description =  N'SALES PLAN 정보가 존재하므로 Active=''N'' 처리가 불가합니다.'+char(10) + N'Sales Site : ' + @v_SCM_SITE_ID
								select @v_description
								SET @v_log_type = 'INVALID';
								GOTO ERR_RTN;	
							END
					END
				----------◎◎◎◎ 20181121 KHSONG VALID_YN='N' 처리시 DM_PLN_SALES_PLAN,DM_PLN_SALES_PLAN_RESULT 테이블의 정보를 확인후 alert창을 띄움 (END)
PRINT @v_program_name +' : A005--' + CONVERT(VARCHAR(30), GETDATE(), 121);

		   -- 20180627 KHSONG Team Id값 Validation 추가 (start)
		   --IF @v_division_id <> '40'
		   IF @v_division_id not in('40','42','44')  -- 20190123 khsong 전지재료 로직추가
		   BEGIN
			   IF   ISNULL((SELECT COUNT(*) FROM SCM_MST_SSO_DEPT_INFO WITH(NOLOCK) 
								WHERE VALID_YN = 'Y' AND DEPT_ID = @v_dept_id),0)
								= 0
				   BEGIN
						   SET @v_log_type = 'INVALID';
						   SELECT N'입력값:[ ' + @v_dept_id + ' ]' + N' Team Id는 PopUp 화면에서 선택해주세요.'
						   SET @v_description = N'입력값:[ ' + @v_dept_id + ' ]' + N' Team Id는 PopUp 화면에서 선택해주세요.'
						   goto err_rtn
				   END 
			   -- 20180627 KHSONG Team Id값 Validation 추가 (end)
		   END
PRINT @v_program_name +' : A006--' + CONVERT(VARCHAR(30), GETDATE(), 121);


		   IF 
				(SELECT COUNT(*)
					FROM SCM_MST_SITE WITH(NOLOCK)
						WHERE SCM_SITE_ID = @v_SCM_SITE_ID
						AND  division_id = @v_division_id
						AND @v_active_flag = 'I')  > 0
				   BEGIN
						   SET @v_log_type = 'INVALID';
						   SELECT N'이미 존재하는 Site 정보입니다.'
						   SET @v_description = @v_SCM_SITE_ID + N'이미 존재하는 Site 정보입니다.'
						   goto err_rtn
				   END 


		   -- 20180712 KHSONG SCM_MST_SITE 에 UPDATE건중 VALID_YN='N'이면 SCM_MST_SITE_CUSTOMER의 데이터를 VALID_YN='N'으로 일괄 업데이트함  (START)
		   IF		@v_active_flag = 'M'  -- UPDATE건인 경우
				AND @v_valid_yn = 'N'     -- valid 'N'처리요청건인경우
					BEGIN
						UPDATE [dbo].[SCM_MST_SITE_CUSTOMER]
							SET VALID_YN = 'N' , REP_YN = 'N' , LAST_UPDATED_BY = @v_created_by , LAST_UPDATE_DATE = GETDATE()
								WHERE 	division_id  = @v_division_id
									AND scm_site_id  = @v_scm_site_id

							-- History 생성 20180726 Added
							EXEC	[dbo].[PR_DM_MST_SITE_CUSTOMER_HIST]
										@v_division_id,
										@v_scm_site_id,
										'ALL', --@v_soldto_code,
										'ALL', --@v_shipto_code,		
										'N',--@v_rep_yn,
										@v_created_by
										, @v_valid_yn  -- [C20210115-000214] (1)
					END
		   -- 20180712 KHSONG SCM_MST_SITE 에 UPDATE건중 VALID_YN='N'이면 SCM_MST_SITE_CUSTOMER의 데이터를 VALID_YN='N'으로 일괄 업데이트함  (END)

				--HISTORY INSERT
PRINT @v_program_name +' : A007--' + CONVERT(VARCHAR(30), GETDATE(), 121);
--select @v_DIVISION_ID+' / '+@v_SCM_SITE_ID+' / '+@v_SITE_DESCRIPTION+' / '+@v_CITY+' / '+@v_COUNTRY +' / '+@v_VMI_YN +' / ' + @v_VALID_YN
--+' / '+@v_PLANT_ID
--+' / '+@v_DEPT_ID
-- / '+ +' / '+@v_SITE_HRCY_ID+' / '+@v_OSP_YN +' / '+@v_SHIP_FROZEN +' / '+@v_PROD_FROZEN +' / '+@v_END_CUSTOMER +' / '+@v_SOLDTO_CUSTOMER+' / '+@v_FP_PLAN_PERIOD+' / '+@v_BUILD_AHEAD+' / '+@v_LOGISTIC_PLANT_ID+' / '+@v_COMPANY_ID+' / '+@v_SITE_ID+' / '+@v_ship_plan_auto+' / '+@v_distribution_channel+' / '+@v_attribute5
				
				EXEC	[dbo].[PR_DM_MST_SITE_HIST]	--@return_value = [dbo].[PR_DM_MST_SITE_HIST]
						 @v_DIVISION_ID      
						,@v_SCM_SITE_ID      
						,@v_SITE_DESCRIPTION 
						,'SALES' --@v_SITE_TYPE  
						,@v_CITY             
						,@v_COUNTRY          
						,' ' --@v_PLANT_ID         
						,@v_OPERATION_GROUP  
						,' ' --@v_DEPT_ID          
						,@v_VMI_YN           
						,@v_VALID_YN         
						,'Y' --@v_NEW_YN           
						,@v_SITE_HRCY_ID     
						,@v_OSP_YN           
						,@v_SHIP_FROZEN      
						,@v_PROD_FROZEN      
						,@v_END_CUSTOMER     
						,@v_SOLDTO_CUSTOMER  
						,@v_FP_PLAN_PERIOD   
						,@v_BUILD_AHEAD      
						,@v_LOGISTIC_PLANT_ID
						,@v_COMPANY_ID       
						,@v_SITE_ID          
						,@v_CREATED_BY       
						,@v_LAST_UPDATED_BY
						,''
						,@v_ship_plan_auto  
						,@v_distribution_channel --[PJ20200138] Distribution Channel 추가
						,@v_attribute5
						
PRINT @v_program_name +' : A008--' + CONVERT(VARCHAR(30), GETDATE(), 121);
			IF @mst_loop_cnt > 0 

				BEGIN       
			 
					-- 임시확인용
					--select '@v_division_id', @v_division_id,'@v_scm_site_id',@v_scm_site_id
					MERGE INTO [dbo].[SCM_MST_SITE] A
					USING (
							SELECT 
								@v_division_id	as division_id, 
								@v_scm_site_id	as site_id
						  ) B
					ON(
							    A.division_id  = B.division_id
							AND A.scm_site_id  = B.site_id
					  )
					WHEN MATCHED THEN
						 UPDATE SET 
/*
								 division_id		= @v_division_id
								,scm_site_id		= @v_scm_site_id 
								,site_description   = @v_site_description
								,site_type			= 'SALES'
								,end_customer       = @v_end_customer
								,soldto_customer		= @v_soldto_customer
								,city				= @v_city
								,country			= @v_country
*/								--[C20200915-000323] Sales Site 에대한 team 변경 권한 추가
								 dept_id			= ' ' --@v_dept_id
								,vmi_yn				= @v_vmi_yn
								,valid_yn			= @v_valid_yn
							--	,new_yn				= @v_new_yn
								,COMPANY_ID         = @v_COMPANY_ID  --20180907 KHSONG company_id 추가
								,last_updated_by	= @v_created_by
								,last_update_date	= sysdatetime()
								,attribute2			= @v_ship_plan_auto
								,attribute3			= @v_distribution_channel --[PJ20200138] Distribution Channel 추가
								,attribute5			= @v_attribute5

					WHEN NOT MATCHED THEN

						 INSERT (  
								    division_id								   
								   ,scm_site_id
								   ,site_description
								   ,site_type
								   ,end_customer
								   ,soldto_customer
								   ,city
								   ,country
								   ,dept_id
								   ,vmi_yn
								   ,valid_yn
								   ,new_yn
								   ,COMPANY_ID --20180907 KHSONG company_id 추가
								   ,created_by
								   ,creation_date
								   ,last_updated_by
								   ,last_update_date
								   ,attribute2
								   ,attribute3
								   ,attribute5
								)
						 VALUES (   
									@v_division_id
								   ,@v_scm_site_id
								   ,@v_site_description
								   ,'SALES'
								   ,@v_end_customer
								   ,@v_soldto_customer
								   ,@v_city
								   ,@v_country
								   ,' ' --@v_dept_id
								   ,@v_vmi_yn
								   ,@v_valid_yn
								   ,'Y'
								   ,@v_COMPANY_ID --20180907 KHSONG company_id 추가
								   ,@v_created_by
								   ,sysdatetime()
								   ,@v_created_by
								   ,sysdatetime()
								   ,@v_ship_plan_auto
								   ,@v_distribution_channel --[PJ20200138] Distribution Channel 추가
								   ,@v_attribute5
								);

			  END

			ELSE    --단일 ROW 일때
			 
				BEGIN        
					SET @v_active_flag		= @p_active_flag        
					SET @p_active_flag		= NULL       
					SET @v_division_id		= @p_division_id        
					SET @p_division_id		= NULL      
					SET @v_site_description = @p_site_description        
					SET @p_site_description = NULL  
					SET @v_end_customer     = @p_end_customer
					SET @p_end_customer     = NULL
					SET @v_soldto_customer		= @p_sold_customer
					SET @p_sold_customer	= NULL
					SET @v_city				= @p_city        
					SET @p_city				= NULL  
					SET @v_country			= @p_country        
					SET @p_country			= NULL  
					SET @v_dept_id			= @p_dept_id     
					SET @p_dept_id			= NULL  
					SET @v_vmi_yn			= @p_vmi_yn      
					SET @p_vmi_yn			= NULL  
					SET @v_ship_plan_auto	= @p_ship_plan_auto
					SET @p_ship_plan_auto	= NULL  
					--[PJ20200138] Distribution Channel 추가
					SET @v_distribution_channel	= @p_distribution_channel
					SET @p_distribution_channel	= NULL  

					-- 20180621 KHSONG vmi_yn값이 없는경우 'N'으로 기본값 셋팅
					IF  @v_vmi_yn = '' OR @v_vmi_yn IS NULL
						SET @v_vmi_yn = 'N'

					SET @v_valid_yn			= @p_valid_yn      
					SET @p_valid_yn			= NULL  
					SET @v_created_by = @p_created_by
					SET @p_created_by = NULL

					SET @v_attribute5		= @p_attribute5
					SET @p_attribute5		= NULL
			 
					--------------------------------------------------------------------------------------------------
					-- [E20250522-001188]_RTRLIM, LTRIM 추가한다. (START)	
					SET @v_active_flag			= RTRIM(LTRIM(@v_active_flag))
					SET @v_division_id			= RTRIM(LTRIM(@v_division_id))
					SET @v_site_description		= RTRIM(LTRIM(@v_site_description))
					SET @v_end_customer			= RTRIM(LTRIM(@v_end_customer))
					SET @v_soldto_customer		= RTRIM(LTRIM(@v_soldto_customer))
					SET @v_city					= RTRIM(LTRIM(@v_city))
					SET @v_country				= RTRIM(LTRIM(@v_country))
					SET @v_dept_id				= RTRIM(LTRIM(@v_dept_id))
					SET @v_vmi_yn				= RTRIM(LTRIM(@v_vmi_yn))
					SET @v_ship_plan_auto		= RTRIM(LTRIM(@v_ship_plan_auto))
					SET @v_distribution_channel	= RTRIM(LTRIM(@v_distribution_channel))
					SET @v_valid_yn				= RTRIM(LTRIM(@v_valid_yn))
					SET @v_created_by			= RTRIM(LTRIM(@v_created_by))
					SET @v_attribute5			= RTRIM(LTRIM(@v_attribute5))
					-- [E20250522-001188]_RTRLIM, LTRIM 추가한다. (END)					
					--------------------------------------------------------------------------------------------------

					--HISTORY INSERT
					EXEC	[dbo].[PR_DM_MST_SITE_HIST]	--@return_value = [dbo].[PR_DM_MST_SITE_HIST]
						 @v_DIVISION_ID      
						,@v_SCM_SITE_ID      
						,@v_SITE_DESCRIPTION 
						,'SALES' -- @v_SITE_TYPE        
						,@v_CITY             
						,@v_COUNTRY          
						,@v_PLANT_ID         
						,@v_OPERATION_GROUP  
						,@v_DEPT_ID          
						,@v_VMI_YN           
						,@v_VALID_YN         
						,'Y' --@v_NEW_YN           
						,@v_SITE_HRCY_ID     
						,@v_OSP_YN           
						,@v_SHIP_FROZEN      
						,@v_PROD_FROZEN      
						,@v_END_CUSTOMER     
						,@v_SOLDTO_CUSTOMER  
						,@v_FP_PLAN_PERIOD   
						,@v_BUILD_AHEAD      
						,@v_LOGISTIC_PLANT_ID
						,@v_COMPANY_ID       
						,@v_SITE_ID          
						,@v_CREATED_BY       
						,@v_LAST_UPDATED_BY
						,''
						,@v_ship_plan_auto  
						,@v_distribution_channel --[PJ20200138] Distribution Channel 추가
						,@v_attribute5



					MERGE INTO [dbo].[SCM_MST_SITE] A
					USING (
							SELECT 
								@v_division_id	as division_id, 
								@v_scm_site_id	as site_id
						  ) B
					ON(
							    A.division_id  = B.division_id
							AND A.scm_site_id  = B.site_id
					  )
					WHEN MATCHED THEN
						 UPDATE SET 
/*
								 division_id		= @v_division_id
								,scm_site_id		= @v_scm_site_id 
								,site_description   = @v_site_description
								,site_type			= 'SALES'
								,end_customer       = @v_end_customer
								,soldto_customer		= @v_soldto_customer
								,city				= @v_city
								,country			= @v_country
								,dept_id			= @v_dept_id
*/
								 vmi_yn				= @v_vmi_yn
								,valid_yn			= @v_valid_yn
								--	,new_yn			= @v_new_yn
								,COMPANY_ID         = @v_COMPANY_ID  --20180907 KHSONG company_id 추가
								,last_updated_by	= @v_created_by
								,last_update_date	= sysdatetime()
								,attribute2			= @v_ship_plan_auto
								,attribute3			= @v_distribution_channel --[PJ20200138] Distribution Channel 추가
								,attribute5			= @v_attribute5

					WHEN NOT MATCHED THEN

						 INSERT (  
								    division_id								   
								   ,scm_site_id
								   ,site_description
								   ,site_type	
								   ,end_customer	
								   ,soldto_customer		
								   ,city
								   ,country
								   ,dept_id
								   ,vmi_yn
								   ,valid_yn
								   ,new_yn
								   ,COMPANY_ID --20180907 KHSONG company_id 추가
								   ,created_by
								   ,creation_date
								   ,last_updated_by
								   ,last_update_date
								   ,attribute2
								   ,attribute3 --[PJ20200138] Distribution Channel 추가
								   ,attribute5
								)
						 VALUES (   
									@v_division_id
								   ,@v_scm_site_id
								   ,@v_site_description
								   ,'SALES'
								   ,@v_end_customer
								   ,@v_soldto_customer
								   ,@v_city
								   ,@v_country
								   ,' ' --@v_dept_id
								   ,@v_vmi_yn
								   ,@v_valid_yn
								   ,'Y'
								   ,@v_COMPANY_ID --20180907 KHSONG company_id 추가
								   ,@v_created_by
								   ,sysdatetime()
								   ,@v_created_by
								   ,sysdatetime()
								   ,@v_ship_plan_auto
								   ,@v_distribution_channel --[PJ20200138] Distribution Channel 추가
								   ,@v_attribute5
								);

				END
			END
PRINT @v_program_name +' : A009--' + CONVERT(VARCHAR(30), GETDATE(), 121);

	
		COMMIT  ;	



		END TRY

				
	BEGIN CATCH

      -- ROLLBACK
		ROLLBACK TRAN SAVE_SALES_SITE_DATA ;	

      -- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();

      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();

    END CATCH;


	--SELECT 'success'

	-- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	 				

	-- 트랜잭션 (END)
	err_rtn:
	IF @v_log_type = 'INVALID'
		begin
			ROLLBACK TRAN SAVE_SALES_SITE_DATA;
			SET @v_log_message = '########## END of procedure ##########';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			-- 2020.12.15 hwi1993
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, N'END', @n_log_count, @v_log_message, @v_description, @d_event_date;
				
			-- 종료 LOG
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		end
  END;		 
	


