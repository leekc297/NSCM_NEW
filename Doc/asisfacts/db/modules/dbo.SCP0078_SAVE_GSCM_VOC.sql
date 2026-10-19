/* =============================================================================
프로그램ID	: SCP0078_SAVE_GSCM_VOC
업  무  명	: 시스템관리 - 프로그램관리 목록
프로그램명	: GSCM system VOC
최초작성일	: 2022.02.09
최종작성일	: 2022.02.09
개  발  자	: vadabi3
입  력  값	: 
출  력  값	: 
*===================================================================================================      
*   Date       In Charge	Description      
*===================================================================================================      
* 2022.02.09   vadabi3		Create   
* 2022,03,18   VADABI3      DIVISION ID 추가
* 2022,03,18   VADABI3      FILE_UPLOAD 추가
* 2022,05,23   VADABI3      종결, 기대효과, 공수 항목 추가
* 2022,08,24   VADABI3      시작일 추가 (CLASSIFY, PRIORITY, DEV)
============================================================================= */

--CREATE PROCEDURE dbo.SCP0078_SAVE_GSCM_VOC
CREATE PROCEDURE [dbo].[SCP0078_SAVE_GSCM_VOC]
 @p_active_flag                NVARCHAR(MAX) , 
 @p_voc_no              	   NVARCHAR(MAX) ,      
 @p_voc_type             	   NVARCHAR(MAX) ,   
 @p_voc_name             	   NVARCHAR(MAX) , 
 @p_voc_detail           	   NVARCHAR(MAX) , 
 @p_request_date         	   NVARCHAR(MAX) ,
 @p_request_user_id      	   NVARCHAR(MAX) ,
 @p_classify_status      	   NVARCHAR(MAX) ,
 @p_classify_date        	   NVARCHAR(MAX) ,
 @p_classify_user_id           NVARCHAR(max) ,	
 @p_receipt_status      	   NVARCHAR(MAX) ,      
 @p_receipt_date         	   NVARCHAR(MAX) ,   
 @p_receipt_user_id      	   NVARCHAR(MAX) , 
 @p_review_status        	   NVARCHAR(MAX) , 
 @p_review_date          	   NVARCHAR(MAX) ,
 @p_review_user_id       	   NVARCHAR(MAX) ,
 @p_priority_status      	   NVARCHAR(MAX) ,
 @p_priority_date        	   NVARCHAR(MAX) ,
 @p_priority_user_id           NVARCHAR(max) ,	
 @p_dev_status          	   NVARCHAR(MAX) ,      
 @p_dev_date             	   NVARCHAR(MAX) ,   
 @p_dev_user_id          	   NVARCHAR(MAX) , 
 @p_test_status          	   NVARCHAR(MAX) , 
 @p_test_date            	   NVARCHAR(MAX) ,
 @p_test_user_id         	   NVARCHAR(MAX) ,
 @p_finish_status        	   NVARCHAR(MAX) ,
 @p_finish_date          	   NVARCHAR(MAX) ,
 @p_finish_user_id             NVARCHAR(max) ,	
 @p_scm_pi_user_id       	   NVARCHAR(MAX) , 
 @p_scm_solution_user_id 	   NVARCHAR(MAX) , 
 @p_csr_no               	   NVARCHAR(MAX) ,
 @p_remark               	   NVARCHAR(MAX) ,
 @p_use_yn               	   NVARCHAR(MAX) ,
 @p_division_id				   NVARCHAR(MAX) ,
 @p_confirm_status        	   NVARCHAR(MAX) ,
 @p_confirm_date          	   NVARCHAR(MAX) ,
 @p_confirm_user_id       	   NVARCHAR(MAX) ,
 @p_confirm_opinion       	   NVARCHAR(MAX) ,
 @p_man_month_plan        	   NVARCHAR(MAX) ,
 @p_man_month_real        	   NVARCHAR(MAX) ,
 @p_benefit_quantitative	   NVARCHAR(MAX) ,
 @p_benefit_qualitative		   NVARCHAR(MAX) ,

 @p_classify_start_date		   NVARCHAR(MAX) ,
 @p_priority_start_date		   NVARCHAR(MAX) ,
 @p_dev_start_date			   NVARCHAR(MAX) 

AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;

	DECLARE @v_active_flag			NVARCHAR(MAX);
	SET @v_active_flag = NULL;

	DECLARE @v_voc_no              	   	   NVARCHAR(MAX) ;      
	DECLARE @v_voc_type             	   NVARCHAR(MAX) ;   
	DECLARE @v_voc_name             	   NVARCHAR(MAX) ; 
	DECLARE @v_voc_detail           	   NVARCHAR(MAX) ; 
	DECLARE @v_request_date         	   NVARCHAR(MAX) ;
	DECLARE @v_request_user_id      	   NVARCHAR(MAX) ;
	DECLARE @v_classify_status      	   NVARCHAR(MAX) ;
	DECLARE @v_classify_date        	   NVARCHAR(MAX) ;
	DECLARE @v_classify_user_id            NVARCHAR(max) ;	
	DECLARE @v_receipt_status      	       NVARCHAR(MAX) ;      
	DECLARE @v_receipt_date         	   NVARCHAR(MAX) ;   
	DECLARE @v_receipt_user_id      	   NVARCHAR(MAX) ; 
	DECLARE @v_review_status        	   NVARCHAR(MAX) ; 
	DECLARE @v_review_date          	   NVARCHAR(MAX) ;
	DECLARE @v_review_user_id       	   NVARCHAR(MAX) ;
	DECLARE @v_priority_status      	   NVARCHAR(MAX) ;
	DECLARE @v_priority_date        	   NVARCHAR(MAX) ;
	DECLARE @v_priority_user_id            NVARCHAR(max) ;	
	DECLARE @v_dev_status          	       NVARCHAR(MAX) ;      
	DECLARE @v_dev_date             	   NVARCHAR(MAX) ;   
	DECLARE @v_dev_user_id          	   NVARCHAR(MAX) ; 
	DECLARE @v_test_status          	   NVARCHAR(MAX) ; 
	DECLARE @v_test_date            	   NVARCHAR(MAX) ;
	DECLARE @v_test_user_id         	   NVARCHAR(MAX) ;
	DECLARE @v_finish_status        	   NVARCHAR(MAX) ;
	DECLARE @v_finish_date          	   NVARCHAR(MAX) ;
	DECLARE @v_finish_user_id              NVARCHAR(max) ;	
	DECLARE @v_scm_pi_user_id       	   NVARCHAR(MAX) ; 
	DECLARE @v_scm_solution_user_id 	   NVARCHAR(MAX) ; 
	DECLARE @v_csr_no               	   NVARCHAR(MAX) ;
	DECLARE @v_remark               	   NVARCHAR(MAX) ;
	DECLARE @v_use_yn               	   NVARCHAR(MAX) ;
	DECLARE @v_division_id                 NVARCHAR(MAX) ;

	-- 20220523 종결, 기대효과, 공수 항목 추가
	DECLARE @v_confirm_status              NVARCHAR(MAX) ;
	DECLARE @v_confirm_date                NVARCHAR(MAX) ;
	DECLARE @v_confirm_user_id             NVARCHAR(MAX) ;
	DECLARE @v_confirm_opinion             NVARCHAR(MAX) ;
	DECLARE @v_man_month_plan              NVARCHAR(MAX) ;
	DECLARE @v_man_month_real              NVARCHAR(MAX) ;
	DECLARE @v_benefit_quantitative        NVARCHAR(MAX) ;
	DECLARE @v_benefit_qualitative	       NVARCHAR(MAX) ;

	-- 20220824 시작일 추가
	DECLARE @v_classify_start_date	       NVARCHAR(MAX) ;
	DECLARE @v_priority_start_date	       NVARCHAR(MAX) ;
	DECLARE @v_dev_start_date		       NVARCHAR(MAX) ;


	SET @v_voc_no              	 = NULL;
	SET @v_voc_type              = NULL;
	SET @v_voc_name              = NULL;
	SET @v_voc_detail            = NULL;
	SET @v_request_date          = NULL;
	SET @v_request_user_id       = NULL;
	SET @v_classify_status       = NULL;
	SET @v_classify_date         = NULL;
	SET @v_classify_user_id      = NULL;
	SET @v_receipt_status      	 = NULL;
	SET @v_receipt_date          = NULL;
	SET @v_receipt_user_id       = NULL;
	SET @v_review_status         = NULL;
	SET @v_review_date           = NULL;
	SET @v_review_user_id        = NULL;
	SET @v_priority_status       = NULL;
	SET @v_priority_date         = NULL;
	SET @v_priority_user_id      = NULL;
	SET @v_dev_status          	 = NULL;
	SET @v_dev_date              = NULL;
	SET @v_dev_user_id           = NULL;
	SET @v_test_status           = NULL;
	SET @v_test_date             = NULL;
	SET @v_test_user_id          = NULL;
	SET @v_finish_status         = NULL;
	SET @v_finish_date           = NULL;
	SET @v_finish_user_id        = NULL;
	SET @v_scm_pi_user_id        = NULL;
	SET @v_scm_solution_user_id  = NULL;
	SET @v_csr_no                = NULL;
	SET @v_remark                = NULL;
	SET @v_use_yn                = NULL;
	SET @v_division_id           = NULL;
	SET @v_confirm_status        = NULL;
	SET @v_confirm_date          = NULL;
	SET @v_confirm_user_id       = NULL;
	SET @v_confirm_opinion       = NULL;
	SET @v_man_month_plan        = NULL;
	SET @v_man_month_real        = NULL;
	SET @v_benefit_quantitative  = NULL;
	SET @v_benefit_qualitative	 = NULL;

	SET @v_classify_start_date	 = NULL;
	SET @v_priority_start_date	 = NULL;
	SET @v_dev_start_date		 = NULL;


	--------------------------------------------------------------
	DECLARE @v_before_classify_status			NVARCHAR(MAX);
	DECLARE @v_before_receipt_status			NVARCHAR(MAX);
	DECLARE @v_before_review_status				NVARCHAR(MAX);
	DECLARE @v_before_priority_status			NVARCHAR(MAX);
	DECLARE @v_before_dev_status				NVARCHAR(MAX);
	DECLARE @v_before_test_status				NVARCHAR(MAX);
	DECLARE @v_before_finish_status				NVARCHAR(MAX);

	SET @v_before_classify_status	  = NULL;
	SET @v_before_receipt_status	  = NULL;
	SET @v_before_review_status		  = NULL;
	SET @v_before_priority_status	  = NULL;
	SET @v_before_dev_status		  = NULL;
	SET @v_before_test_status		  = NULL;
	SET @v_before_finish_status		  = NULL;

	--------------------------------------------------------------
	DECLARE @v_mailsend_classify_status			NVARCHAR(MAX);
	DECLARE @v_mailsend_receipt_status			NVARCHAR(MAX);
	DECLARE @v_mailsend_review_status			NVARCHAR(MAX);
	DECLARE @v_mailsend_priority_status			NVARCHAR(MAX);
	DECLARE @v_mailsend_dev_status				NVARCHAR(MAX);
	DECLARE @v_mailsend_test_status				NVARCHAR(MAX);
	DECLARE @v_mailsend_finish_status			NVARCHAR(MAX);

	SET @v_mailsend_classify_status	  = NULL;
	SET @v_mailsend_receipt_status	  = NULL;
	SET @v_mailsend_review_status	  = NULL;
	SET @v_mailsend_priority_status	  = NULL;
	SET @v_mailsend_dev_status		  = NULL;
	SET @v_mailsend_test_status		  = NULL;
	SET @v_mailsend_finish_status	  = NULL;

	--------------------------------------------------------------
	DECLARE  @v_mailsend_delay_classify_status 		NVARCHAR(MAX);
	DECLARE  @v_mailsend_delay_receipt_status		NVARCHAR(MAX);
	DECLARE  @v_mailsend_delay_review_status		NVARCHAR(MAX);
	DECLARE  @v_mailsend_delay_priority_status 		NVARCHAR(MAX);
	DECLARE  @v_mailsend_delay_dev_status			NVARCHAR(MAX);
	DECLARE  @v_mailsend_delay_test_status	 		NVARCHAR(MAX);
	DECLARE  @v_mailsend_delay_finish_status	 	NVARCHAR(MAX);

	SET @v_mailsend_delay_classify_status		= NULL;
	SET @v_mailsend_delay_receipt_status		= NULL;
	SET @v_mailsend_delay_review_status			= NULL;
	SET @v_mailsend_delay_priority_status		= NULL;
	SET @v_mailsend_delay_dev_status			= NULL;
	SET @v_mailsend_delay_test_status			= NULL;
	SET @v_mailsend_delay_finish_status			= NULL;

	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0078_SAVE_GSCM_VOC';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;


	-- 트렌젝션 시작
	BEGIN TRAN;

	BEGIN TRY

		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		--PRINT '2';
		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);   

		WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN   
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;	



			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			BEGIN

				SET @v_active_flag					= [dbo].[SCM_ARR_SPL_VAL](@p_active_flag			, @v_delimiter , @mst_loop_cnt) ;    
				SET @v_voc_no              			= [dbo].[SCM_ARR_SPL_VAL](@p_voc_no                 , @v_delimiter , @mst_loop_cnt) ; 
				SET @v_voc_type             		= [dbo].[SCM_ARR_SPL_VAL](@p_voc_type             	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_voc_name             		= [dbo].[SCM_ARR_SPL_VAL](@p_voc_name             	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_voc_detail           		= [dbo].[SCM_ARR_SPL_VAL](@p_voc_detail           	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_request_date         		= [dbo].[SCM_ARR_SPL_VAL](@p_request_date         	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_request_user_id      		= [dbo].[SCM_ARR_SPL_VAL](@p_request_user_id      	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_classify_status      		= [dbo].[SCM_ARR_SPL_VAL](@p_classify_status      	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_classify_date        		= [dbo].[SCM_ARR_SPL_VAL](@p_classify_date        	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_classify_user_id     		= [dbo].[SCM_ARR_SPL_VAL](@p_classify_user_id     	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_receipt_status      			= [dbo].[SCM_ARR_SPL_VAL](@p_receipt_status      	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_receipt_date         		= [dbo].[SCM_ARR_SPL_VAL](@p_receipt_date         	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_receipt_user_id      		= [dbo].[SCM_ARR_SPL_VAL](@p_receipt_user_id      	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_review_status        		= [dbo].[SCM_ARR_SPL_VAL](@p_review_status        	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_review_date          		= [dbo].[SCM_ARR_SPL_VAL](@p_review_date          	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_review_user_id       		= [dbo].[SCM_ARR_SPL_VAL](@p_review_user_id       	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_priority_status      		= [dbo].[SCM_ARR_SPL_VAL](@p_priority_status      	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_priority_date        		= [dbo].[SCM_ARR_SPL_VAL](@p_priority_date        	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_priority_user_id     		= [dbo].[SCM_ARR_SPL_VAL](@p_priority_user_id     	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_dev_status          			= [dbo].[SCM_ARR_SPL_VAL](@p_dev_status          	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_dev_date             		= [dbo].[SCM_ARR_SPL_VAL](@p_dev_date             	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_dev_user_id          		= [dbo].[SCM_ARR_SPL_VAL](@p_dev_user_id          	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_test_status          		= [dbo].[SCM_ARR_SPL_VAL](@p_test_status          	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_test_date            		= [dbo].[SCM_ARR_SPL_VAL](@p_test_date            	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_test_user_id         		= [dbo].[SCM_ARR_SPL_VAL](@p_test_user_id         	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_finish_status        		= [dbo].[SCM_ARR_SPL_VAL](@p_finish_status        	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_finish_date          		= [dbo].[SCM_ARR_SPL_VAL](@p_finish_date          	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_finish_user_id       		= [dbo].[SCM_ARR_SPL_VAL](@p_finish_user_id       	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_scm_pi_user_id       		= [dbo].[SCM_ARR_SPL_VAL](@p_scm_pi_user_id       	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_scm_solution_user_id 		= [dbo].[SCM_ARR_SPL_VAL](@p_scm_solution_user_id 	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_csr_no               		= [dbo].[SCM_ARR_SPL_VAL](@p_csr_no               	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_remark               		= [dbo].[SCM_ARR_SPL_VAL](@p_remark               	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_use_yn               		= [dbo].[SCM_ARR_SPL_VAL](@p_use_yn               	, @v_delimiter , @mst_loop_cnt) ; 
				SET @v_division_id               	= [dbo].[SCM_ARR_SPL_VAL](@p_division_id            , @v_delimiter , @mst_loop_cnt) ; 

				SET @v_confirm_status               = [dbo].[SCM_ARR_SPL_VAL](@p_confirm_status                    , @v_delimiter , @mst_loop_cnt) ; 
				SET @v_confirm_date                 = [dbo].[SCM_ARR_SPL_VAL](@p_confirm_date                      , @v_delimiter , @mst_loop_cnt) ; 
				SET @v_confirm_user_id              = [dbo].[SCM_ARR_SPL_VAL](@p_confirm_user_id                   , @v_delimiter , @mst_loop_cnt) ; 
				SET @v_confirm_opinion              = [dbo].[SCM_ARR_SPL_VAL](@p_confirm_opinion                   , @v_delimiter , @mst_loop_cnt) ; 
				SET @v_man_month_plan               = [dbo].[SCM_ARR_SPL_VAL](@p_man_month_plan                    , @v_delimiter , @mst_loop_cnt) ; 
				SET @v_man_month_real               = [dbo].[SCM_ARR_SPL_VAL](@p_man_month_real                    , @v_delimiter , @mst_loop_cnt) ; 
				SET @v_benefit_quantitative         = [dbo].[SCM_ARR_SPL_VAL](@p_benefit_quantitative              , @v_delimiter , @mst_loop_cnt) ; 
				SET @v_benefit_qualitative	        = [dbo].[SCM_ARR_SPL_VAL](@p_benefit_qualitative	           , @v_delimiter , @mst_loop_cnt) ; 

				SET @v_classify_start_date	        = [dbo].[SCM_ARR_SPL_VAL](@p_classify_start_date		       , @v_delimiter , @mst_loop_cnt) ; 
				SET @v_priority_start_date	        = [dbo].[SCM_ARR_SPL_VAL](@p_priority_start_date		       , @v_delimiter , @mst_loop_cnt) ; 
				SET @v_dev_start_date				= [dbo].[SCM_ARR_SPL_VAL](@p_dev_start_date			           , @v_delimiter , @mst_loop_cnt) ; 

				IF LEN(@v_classify_date) < 8 
				BEGIN
				SET @v_classify_date  = NULL;
				END 
				
				IF LEN(@v_receipt_date) < 8 BEGIN SET @v_receipt_date = NULL; END 
				IF LEN(@v_review_date) < 8 BEGIN SET @v_review_date  = NULL; END 
				IF LEN(@v_priority_date) < 8 BEGIN SET @v_priority_date  = NULL; END 
				IF LEN(@v_dev_date) < 8 BEGIN SET @v_dev_date  = NULL; END 
				IF LEN(@v_test_date ) < 8 BEGIN SET @v_test_date   = NULL; END 
				IF LEN(@v_finish_date) < 8 BEGIN SET @v_finish_date  = NULL; END 



					SET @v_before_classify_status	  = NULL;
					SET @v_before_receipt_status	  = NULL;
					SET @v_before_review_status		  = NULL;
					SET @v_before_priority_status	  = NULL;
					SET @v_before_dev_status		  = NULL;
					SET @v_before_test_status		  = NULL;
					SET @v_before_finish_status		  = NULL;

					/********************************************************************************
					* VOC_BEFORE_DATA
					********************************************************************************/
					SELECT @v_before_classify_status		= A.CLASSIFY_STATUS  
						  ,@v_before_receipt_status			= A.RECEIPT_STATUS   
						  ,@v_before_review_status		    = A.REVIEW_STATUS    
						  ,@v_before_priority_status	    = A.PRIORITY_STATUS  
						  ,@v_before_dev_status				= A.DEV_STATUS       
						  ,@v_before_test_status		    = A.TEST_STATUS      
						  ,@v_before_finish_status		    = A.FINISH_STATUS    	
 					  FROM dbo.SCM_ADM_SYS_VOC A WITH(NOLOCK) 	
 					 WHERE VOC_NO = @v_voc_no	

				
			END

			--SELECT @v_classify_date;

			--데이터 저장
			IF @mst_loop_cnt > 0 			
				BEGIN		

					IF( @v_active_flag ='M') 
						BEGIN
							/********************************************************************************
							-- UPDATE
							********************************************************************************/
							UPDATE SCM_ADM_SYS_VOC
							SET VOC_TYPE			=	@v_voc_type,
							    VOC_NAME			=	@v_voc_name,
							    VOC_DETAIL			=	@v_voc_detail,
							    CSR_NO				=	@v_csr_no,
								REMARK				=	@v_remark,
								USE_YN				=	@v_use_yn,

								CLASSIFY_STATUS		=	@v_classify_status,	
								CLASSIFY_DATE		=	@v_classify_date,
								RECEIPT_STATUS		=	@v_receipt_status,
								RECEIPT_DATE		=	@v_receipt_date,
								REVIEW_STATUS		=	@v_review_status,
								REVIEW_DATE			=	@v_review_date,
								PRIORITY_STATUS		=	@v_priority_status,
								PRIORITY_DATE		=	@v_priority_date,
								DEV_STATUS			=	@v_dev_status,
								DEV_DATE			=	@v_dev_date,
								TEST_STATUS			=	@v_test_status,
								TEST_DATE			=	@v_test_date,
								FINISH_STATUS		=	@v_finish_status,
								FINISH_DATE			=	@v_finish_date,

								CLASSIFY_USER_ID	=	@v_classify_user_id,	
								RECEIPT_USER_ID		=	@v_receipt_user_id,
								REVIEW_USER_ID		=	@v_review_user_id,
								PRIORITY_USER_ID	=	@v_priority_user_id,
								DEV_USER_ID			=	@v_dev_user_id,
								TEST_USER_ID		=	@v_test_user_id,
								FINISH_USER_ID		=	@v_finish_user_id,

								REQUEST_USER_ID		=	@v_request_user_id,
								SCM_PI_USER_ID		=	@v_scm_pi_user_id,
								SCM_SOLUTION_USER_ID=	@v_scm_solution_user_id,
								ATTRIBUTE1          =   @v_division_id,

								BENEFIT_QUANTITATIVE    =	@v_benefit_quantitative,
								BENEFIT_QUALITATIVE 	=	@v_benefit_qualitative,
								MAN_MONTH_PLAN  		=	@v_man_month_plan,
								MAN_MONTH_REAL  		=	@v_man_month_real,

								CLASSIFY_START_DATE  	=	@v_classify_start_date,
								PRIORITY_START_DATE  	=	@v_priority_start_date,
								DEV_START_DATE  		=	@v_dev_start_date
							WHERE VOC_NO = @v_voc_no
							;



							
							/********************************************************************************
							-- 구체화 부터 solution 개입
							********************************************************************************/
							IF LEN(@v_scm_solution_user_id) > 1
							BEGIN 
							
								UPDATE SCM_ADM_SYS_VOC 
								SET SCM_SOLUTION_USER_ID =	@v_scm_solution_user_id
								WHERE VOC_NO = @v_voc_no;
							END 

							
							/********************************************************************************
							-- 과제 접수/협의 부터 PI 개입
							********************************************************************************/
							IF LEN(@v_scm_pi_user_id) > 1 
							BEGIN 
									UPDATE SCM_ADM_SYS_VOC
									SET SCM_PI_USER_ID		=	@v_scm_pi_user_id
									WHERE VOC_NO = @v_voc_no;
							END 


							/********************************************************************************
							-- 20220523 종료 항목 추가
							********************************************************************************/
							IF LEN(@v_confirm_status) > 1 
							BEGIN 
								UPDATE SCM_ADM_SYS_VOC
								SET 
									  CONFIRM_STATUS 		=	@v_confirm_status,
									  CONFIRM_OPINION 		=	@v_confirm_opinion,
									  CONFIRM_DATE 			=	@v_confirm_date,
									  CONFIRM_USER_ID		=	@v_confirm_user_id
								WHERE VOC_NO = @v_voc_no
							END 


							/**********************************************************************************************************
							* 메일 발송 : 상태가 달라진 경우 + FH 인경우 + MAIL_SEND_YN = Y 인 경우 + DELAY 여부
							**********************************************************************************************************/
							---------------------------------------------------------------------------------
							-- Mail Send 여부
							---------------------------------------------------------------------------------
							select @v_mailsend_classify_status    = SEGMENT3 , @v_mailsend_delay_classify_status  = SEGMENT4  from SCM_ADM_LOOKUP_MASTER_DETAIL where lookup_type = 'VOC_STEP' AND SEGMENT1 = 'CLASSIFY'
							select @v_mailsend_receipt_status	  = SEGMENT3 , @v_mailsend_delay_receipt_status	  = SEGMENT4  from SCM_ADM_LOOKUP_MASTER_DETAIL where lookup_type = 'VOC_STEP' AND SEGMENT1 = 'RECEIPT'
							select @v_mailsend_review_status	  = SEGMENT3 , @v_mailsend_delay_review_status	  = SEGMENT4  from SCM_ADM_LOOKUP_MASTER_DETAIL where lookup_type = 'VOC_STEP' AND SEGMENT1 = 'REVIEW'
							select @v_mailsend_priority_status    = SEGMENT3 , @v_mailsend_delay_priority_status  = SEGMENT4  from SCM_ADM_LOOKUP_MASTER_DETAIL where lookup_type = 'VOC_STEP' AND SEGMENT1 = 'PRIORITY'
							select @v_mailsend_dev_status		  = SEGMENT3 , @v_mailsend_delay_dev_status		  = SEGMENT4  from SCM_ADM_LOOKUP_MASTER_DETAIL where lookup_type = 'VOC_STEP' AND SEGMENT1 = 'DEV'
							select @v_mailsend_test_status	      = SEGMENT3 , @v_mailsend_delay_test_status	  = SEGMENT4  from SCM_ADM_LOOKUP_MASTER_DETAIL where lookup_type = 'VOC_STEP' AND SEGMENT1 = 'TEST'
							select @v_mailsend_finish_status	  = SEGMENT3 , @v_mailsend_delay_finish_status	  = SEGMENT4  from SCM_ADM_LOOKUP_MASTER_DETAIL where lookup_type = 'VOC_STEP' AND SEGMENT1 = 'FINISH'



							SET @v_log_type = 'RUN';
							SET @v_log_message = '########## MAIL SEND ##########';
							SET @v_description = @v_voc_no +','+ @v_before_classify_status +','+ @v_classify_status +','+ @v_mailsend_classify_status +','+ @v_mailsend_delay_classify_status;

							SET @d_event_date = SYSDATETIME();
							EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			
							IF @v_before_classify_status != @v_classify_status AND @v_classify_status = 'FH' AND @v_mailsend_classify_status = 'Y'
								BEGIN
								EXEC SCP0078_GET_GSCM_VOC_MAIL_SEND   @p_active_flag = @v_active_flag,  @p_voc_no=@v_voc_no, @p_voc_step = 'CLASSIFY';
								END

							IF @v_before_receipt_status != @v_receipt_status AND @v_receipt_status	 = 'FH' AND @v_mailsend_receipt_status = 'Y'
								BEGIN
								EXEC SCP0078_GET_GSCM_VOC_MAIL_SEND   @p_active_flag = @v_active_flag,  @p_voc_no=@v_voc_no, @p_voc_step = 'RECEIPT';
								END

							IF @v_before_review_status != @v_review_status	 AND @v_review_status	 = 'FH' AND @v_mailsend_review_status = 'Y'
								BEGIN
								EXEC SCP0078_GET_GSCM_VOC_MAIL_SEND   @p_active_flag = @v_active_flag,  @p_voc_no=@v_voc_no, @p_voc_step = 'REVIEW';
								END

							IF @v_before_priority_status != @v_priority_status	 AND @v_priority_status	 = 'FH' AND @v_mailsend_priority_status = 'Y'
								BEGIN
								EXEC SCP0078_GET_GSCM_VOC_MAIL_SEND   @p_active_flag = @v_active_flag,  @p_voc_no=@v_voc_no, @p_voc_step = 'PRIORITY';
								END

							IF @v_before_dev_status != @v_dev_status	 AND @v_dev_status	 = 'FH' AND @v_mailsend_dev_status = 'Y'
								BEGIN
								EXEC SCP0078_GET_GSCM_VOC_MAIL_SEND   @p_active_flag = @v_active_flag,  @p_voc_no=@v_voc_no, @p_voc_step = 'DEV';
								END

							IF @v_before_test_status != @v_test_status	 AND @v_test_status	 = 'FH' AND @v_mailsend_test_status = 'Y'
								BEGIN
								EXEC SCP0078_GET_GSCM_VOC_MAIL_SEND   @p_active_flag = @v_active_flag,  @p_voc_no=@v_voc_no, @p_voc_step = 'TEST';
								END

							IF @v_before_finish_status != @v_finish_status	 AND @v_finish_status	 = 'FH' AND @v_mailsend_finish_status = 'Y'
								BEGIN
								EXEC SCP0078_GET_GSCM_VOC_MAIL_SEND   @p_active_flag = @v_active_flag,  @p_voc_no=@v_voc_no, @p_voc_step = 'FINISH';
								END


							---------------------------------------------------------------------------------
							-- 지연 시 Mail Send 여부 (지연은 배치로 처리)
							---------------------------------------------------------------------------------



						END

					ELSE IF(@v_active_flag ='I') 
						BEGIN
							/********************************************************************************
							-- INSERT
							********************************************************************************/
							SELECT @v_voc_no = NEXT VALUE FOR SEQ_SCM_ADM_SYS_VOC;

							INSERT INTO SCM_ADM_SYS_VOC
							(	
								VOC_NO,
								VOC_NAME,
								VOC_DETAIL,
								REQUEST_DATE,
								REQUEST_USER_ID,
								USE_YN,
								ATTRIBUTE1
							)
							VALUES
							(
								@v_voc_no,
								@v_voc_name,
								@p_voc_detail,
								GETDATE(),
								@v_request_user_id,
								'Y',
								@v_division_id
							);


							/********************************************************************************
							* 메일 발송
							********************************************************************************/
							EXEC SCP0078_GET_GSCM_VOC_MAIL_SEND   @p_active_flag = @v_active_flag,  @p_voc_no=@v_voc_no, @p_voc_step = 'CREATE'; 
	
						END
				END  -- END OF STMT. IF( @mst_loop_cnt > 0 )			
			
		END -- END OF STMT. WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt



		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			
		COMMIT TRAN;

		-- 결과코드, 결과 카운트 반환
		SELECT  'S' AS result_code,  @max_loop_cnt AS result_cnt ;





	END TRY

	BEGIN CATCH 

		  if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리

		  BEGIN
			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			--IF @@TRANCOUNT > 0
			--  COMMIT WORK;
		  END;

		  -- error코드, errror 메시지 반환
		  SELECT 'F' AS result_code;
		  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	END CATCH;
END
