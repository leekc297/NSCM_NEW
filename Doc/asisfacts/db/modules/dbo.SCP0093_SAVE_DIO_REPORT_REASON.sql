


/*
 * Program ID   : SCP0093_SAVE_DIO_REPORT_REASON
 * Description  : DIO Report REASON 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2022/10/27   vadabi3			[PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3) - 최초생성
 * 2023/01/11   vadabi3			[PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3) - 모델 대상 @p_plan_start_yyyymmdd 일치로 제한
 * 2023/01/11   vadabi3			[PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3) - p_category_dv 추가
 * 2023/01/25   vadabi3			[PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3) - Plan Date 관랸 이슈 조치
 * 2023/03/20   vadabi3			PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제  - [MODEL -> CELL] 기준으로 수정
 ----------------------------------------------------------------------------------------------------
  EXEC SCP0093_SAVE_DIO_REPORT_REASON 
  @p_active_flag='M'
  , @p_yyyymm='202302'
  , @p_division_id='81'
  , @p_cell_group='????'
  , @p_aggr_dv='*'
  , @p_item_id='ACEH1057I-A1'
  , @p_dio_reason='QUALITY_ISSUES_REPORT'
  , @p_quantity='1'
  , @p_amount=null
  , @p_remark='test'
  , @p_user_id='vadabi3'

 EXEC SCP0093_SAVE_DIO_REPORT_REASON 
 @p_active_flag='M^M'
 , @p_yyyymm='202301^202301'
 , @p_division_id='81^81'
 , @p_cell_group='????^????'
 , @p_aggr_dv='*^*'
 , @p_item_id='ACEH1057I-A1^ACEH1057I-A1'
 , @p_dio_reason='ETC1^ETC2'
 , @p_quantity='1^0'
 , @p_amount='0^2'
 , @p_remark='^'
 , @p_user_id='vadabi3'

 */

CREATE PROCEDURE [dbo].[SCP0093_SAVE_DIO_REPORT_REASON]
 @p_active_flag             NVARCHAR(MAX) , 
 @p_plan_start_yyyymmdd     NVARCHAR(8)	  , 
 @p_yyyymm             		NVARCHAR(MAX) ,  
 @p_category_dv			    NVARCHAR(MAX),
 @p_division_id             NVARCHAR(MAX) ,       
 @p_cell_group             	NVARCHAR(MAX) , 
 @p_aggr_dv             	NVARCHAR(MAX) , 
 @p_item_id             	NVARCHAR(MAX) ,    
 @p_dio_reason             	NVARCHAR(MAX) ,      
 @p_quantity             	NVARCHAR(MAX) ,  
 @p_amount             		NVARCHAR(MAX) ,  
 @p_remark             		NVARCHAR(MAX) ,
 @p_user_id             	NVARCHAR(MAX) 
AS

BEGIN

	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @recv_active_flag		NVARCHAR(MAX);
	SET @recv_active_flag = NULL;		
	SET @recv_active_flag = @p_active_flag;
	DECLARE @max_loop_cnt		INTEGER = 0; 
	DECLARE @mst_loop_cnt		INTEGER = 0;
	DECLARE @v_delimiter NVARCHAR(1)
	SET @v_delimiter = '^' 

	DECLARE @v_active_flag               	   	   NVARCHAR(MAX) ;    
	DECLARE @v_plan_start_yyyymmdd                 NVARCHAR(MAX) ;   
	DECLARE @v_yyyymm                    	   	   NVARCHAR(MAX) ;  
	DECLARE @v_division_id               	   	   NVARCHAR(MAX) ;      
	DECLARE @v_cell_group                	   	   NVARCHAR(MAX) ; 
	DECLARE @v_aggr_dv                	   	       NVARCHAR(MAX) ; 
	DECLARE @v_item_id                   	   	   NVARCHAR(MAX) = '*';  
	DECLARE @v_dio_reason                	   	   NVARCHAR(MAX) ;     
	DECLARE @v_quantity                  	   	   NVARCHAR(MAX) ;     
	DECLARE @v_amount                    	   	   NVARCHAR(MAX) ;  
	DECLARE @v_remark                    	   	   NVARCHAR(MAX) ;   
	DECLARE @v_category_dv	                       NVARCHAR(MAX) ; 

	DECLARE @n_quantity                  	   	   numeric;     
	DECLARE @n_amount                    	   	   numeric;  
	DECLARE @n_quantity_sum                  	   numeric;     
	DECLARE @n_amount_sum                   	   numeric ; 


	SET @v_active_flag           	 = NULL;  
	SET @v_plan_start_yyyymmdd       = NULL;  
	SET @v_yyyymm                	 = NULL;  
	SET @v_division_id           	 = NULL;  
	SET @v_cell_group            	 = NULL;  
	SET @v_aggr_dv            	     = NULL;  
  --SET @v_item_id               	 = NULL;  
	SET @v_dio_reason             	 = NULL;  
	SET @v_quantity              	 = NULL;  
	SET @v_amount                	 = NULL;  
	SET @v_remark                	 = NULL; 
	SET @v_category_dv               = NULL; 
	SET @n_quantity					 = 0;  
	SET @n_amount					 = 0;  
	SET @n_quantity_sum              = 0;  
	SET @n_amount_sum                = 0;  


	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCP0093_SAVE_DIO_REPORT_REASON';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';
	
	-- 트렌젝션 시작
	BEGIN TRAN;
	BEGIN TRY

		-- 프로시저 LOOP 길이를 판단
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@p_active_flag, @v_delimiter);   

		WHILE LEN(@p_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN   
			-- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;	

			-- 각 컬럼들에 대한 스플릿처리로직 스타트
			SET @v_active_flag 			= [dbo].[SCM_ARR_SPL_VAL](@p_active_flag			, @v_delimiter , @mst_loop_cnt) ; 
			SET @v_plan_start_yyyymmdd	= [dbo].[SCM_ARR_SPL_VAL](@p_plan_start_yyyymmdd    , @v_delimiter , @mst_loop_cnt) ;    
			SET @v_yyyymm      			= [dbo].[SCM_ARR_SPL_VAL](@p_yyyymm     			, @v_delimiter , @mst_loop_cnt) ;   
			SET @v_division_id 			= [dbo].[SCM_ARR_SPL_VAL](@p_division_id			, @v_delimiter , @mst_loop_cnt) ;    
			SET @v_cell_group  			= [dbo].[SCM_ARR_SPL_VAL](@p_cell_group 			, @v_delimiter , @mst_loop_cnt) ;    
			SET @v_aggr_dv  			= [dbo].[SCM_ARR_SPL_VAL](@p_aggr_dv 				, @v_delimiter , @mst_loop_cnt) ;   
		  --SET @v_item_id     			= [dbo].[SCM_ARR_SPL_VAL](@p_item_id    			, @v_delimiter , @mst_loop_cnt) ;   
			SET @v_dio_reason  			= [dbo].[SCM_ARR_SPL_VAL](@p_dio_reason  			, @v_delimiter , @mst_loop_cnt) ;     
			SET @v_quantity    			= [dbo].[SCM_ARR_SPL_VAL](@p_quantity   			, @v_delimiter , @mst_loop_cnt) ;    
			SET @v_amount      			= [dbo].[SCM_ARR_SPL_VAL](@p_amount     			, @v_delimiter , @mst_loop_cnt) ;   
			SET @v_remark      			= [dbo].[SCM_ARR_SPL_VAL](@p_remark     			, @v_delimiter , @mst_loop_cnt) ;    
			SET @v_category_dv      	= [dbo].[SCM_ARR_SPL_VAL](@p_category_dv     		, @v_delimiter , @mst_loop_cnt) ;  
			-----------------------------------------------------------------------
			if @v_quantity = '' or @v_quantity is null
				begin
				SET @v_quantity = null;
				SET @n_quantity = 0;
				end
			else
				begin
				SET @n_quantity = CONVERT(numeric, @v_quantity);
				end

			-----------------------------------------------------------------------
			if @v_amount = '' or @v_amount is null
				begin
				SET @v_amount = null;
				SET @n_amount = 0;
				end
			else
				begin
				SET @n_amount = CONVERT(numeric, @v_amount);
				end

			-----------------------------------------------------------------------
			--SET @n_quantity_sum     += @n_quantity;
			--SET @n_amount_sum		+= @n_amount;

			-----------------------------------------------------------------------
			-- @v_remark not null
			if @v_remark = '' or @v_remark is null
				begin
				SET @v_remark = ' ';
				end


			---------------------------------------------------------------------------------------------------------------------
			-- 각 ROW
			---------------------------------------------------------------------------------------------------------------------
			MERGE INTO SCP_RPT_DIO_TREND_MM_REASON A		
					USING (
					 		  SELECT 
									@v_active_flag        AS ACTIVE_FLAG    
								   ,@v_yyyymm             AS YYYYMM       
								   ,@v_division_id        AS DIVISION_ID  
								   ,@v_cell_group         AS CELL_GROUP   
								   ,@v_aggr_dv            AS AGGR_DV      
								   ,@v_item_id            AS ITEM_ID      
								   ,@v_dio_reason         AS DIO_REASON    
								   ,@v_quantity           AS QUANTITY     
								   ,@v_amount             AS AMOUNT       
								   ,@v_remark             AS REMARK       
								   ,@v_category_dv        AS CATEGORY_DV    
									--,WEEK_NO			
									--,PLAN_DATE		
									--,ATTRIBUTE1		
									--,ATTRIBUTE2		
									--,ATTRIBUTE3		
									--,ATTRIBUTE4		
									--,ATTRIBUTE5		
									--,ATTRIBUTE6		
									--,ATTRIBUTE7		
									--,ATTRIBUTE8		
									--,ATTRIBUTE9		
									--,ATTRIBUTE10		
						) B
				  ON(     
							  A.YYYYMM			=  B.YYYYMM
						  AND A.DIVISION_ID		=  B.DIVISION_ID
						  AND A.ITEM_ID			=  B.ITEM_ID
						  AND A.CELL_GROUP		=  B.CELL_GROUP
						  AND A.AGGR_DV		    =  B.AGGR_DV
						  AND A.DIO_REASON		=  B.DIO_REASON
						  AND A.CATEGORY_DV		=  B.CATEGORY_DV 
					)
				  WHEN MATCHED THEN
					 UPDATE SET 
								 A.QUANTITY          = B.QUANTITY        
								,A.AMOUNT			 = B.AMOUNT
								,A.REMARK			 = B.REMARK
								,A.LAST_UPDATED_BY	 = @p_user_id
								,A.LAST_UPDATE_DATE	 = GETDATE()
							 	
				  WHEN NOT MATCHED THEN
						INSERT  
								   (
									YYYYMM
								   ,CATEGORY_DV
								   ,DIVISION_ID			
								   ,ITEM_ID				
								   ,CELL_GROUP	
								   ,AGGR_DV													
								   ,DIO_REASON			
								   ,QUANTITY				
								   ,AMOUNT				
								   ,CREATED_BY
								   ,CREATION_DATE
								   ,LAST_UPDATED_BY
								   ,LAST_UPDATE_DATE
								   ,REMARK

						)
					VALUES
						( 
									B.YYYYMM
								   ,B.CATEGORY_DV
								   ,B.DIVISION_ID			
								   ,B.ITEM_ID				
								   ,B.CELL_GROUP	
								   ,B.AGGR_DV													
								   ,B.DIO_REASON			
								   ,B.QUANTITY				
								   ,B.AMOUNT						
								   ,@p_user_id				
								   ,GETDATE()	
								   ,@p_user_id
								   ,GETDATE()		
								   ,REMARK			
						);
		END;

		COMMIT TRAN;			
		
		SELECT  'S' AS result_code,  @mst_loop_cnt AS result_cnt ;

	END TRY

	BEGIN CATCH 
	    if (xact_state() <> 0) ROLLBACK TRAN; --입력 데이타 롤백 처리
		BEGIN
	 
			INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
			VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

			IF( @v_err_code IS NULL OR @v_err_code ='')
				SET @v_err_code= ERROR_NUMBER() ;
			IF( @v_err_message IS NULL OR @v_err_message ='') 
				SET @v_err_message=  ERROR_MESSAGE();
						
			/* 에러 메시지, 에러 데이터  반환   */	
			SELECT  @v_err_code			AS err_code
				   ,@v_err_message		AS err_message     
			; 
		END;
	END CATCH;
END




