
/*
 * Program ID   : PR_XLS_SAVE_PLAN_AMEND_QTY
 * Description  : 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2024.09.01   FP Pjt.         Create.
 * 2024.09.25   and x.OPERATION_ID != 'A7000'  --2024-09-25 추가 (PR_XLS_GET_PLAN_AMEND) <- 이 프로시저와 정확히 일치해야 함. 
 * 2024.09.30   FP_PLAN_MODEL_CHANGE_EXCEPT_M 테이블에 삭제후 저장 처리(엑셀 Planning UI 시트에서 특정모델(예제:R23셀의 값을 140->170)을 강제로 변경 했을때, 이 테이블에 저장한다.)
 * 2024.10.08   모델마스터에 있는 경우 0 생성 관련 수정  (PR_XLS_GET_PLAN_AMEND) <- 이 프로시저와 정확히 일치해야 함. 
 * 2024.10.10   조립에 활성화데이터 잘못 들어감 해결 관련 수정       (PR_XLS_GET_PLAN_AMEND) <- 이 프로시저와 정확히 일치해야 함. 
 * 2024.10.10   FP_PLAN_MODEL_CHANGE_EXCEPT_P 테이블에 인서트 조건 변경.(FP_PLAN_MODEL_CHANGE_M 에 없거나 범위 밖의 계획일자일 떄.인서트함)
 * 2024.10.11   FP_PLAN_MODEL_CHANGE_EXCEPT_P 테이블에 인서트 로직 주석 처리
 * 2024.10.14   BUF_AMEND_PLAN_R_XLS_QTY 테이블에 33컬럼 업로드후 로직 수정
 * 
 ex) 
  exec PR_XLS_SAVE_PLAN_AMEND_QTY 'UC1-20240904-08', 'crjung'

 */

create PROCEDURE [dbo].[PR_XLS_SAVE_PLAN_AMEND_QTY_20240115]
	@p_intg_plan_id				NVARCHAR(MAX)    
    , @p_userid	    			NVARCHAR(MAX)    
AS
BEGIN
	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	DECLARE @v_intg_plan_id			nvarchar(50)
	declare @v_instance_id          nvarchar(50)
	DECLARE @v_fp_plan_id			nvarchar(50)
	declare @v_shop_group			nvarchar(1)
	DECLARE @v_yyyymmdd_from	    datetime
	DECLARE @v_yyyymmdd_to		    datetime

	declare @v_company_id           nvarchar(50)
	declare @v_division_id          nvarchar(50)
	declare @v_site_id              nvarchar(50)
	declare @v_release_group        nvarchar(50)

	DECLARE @INX					INT				= 0;
    DECLARE @MAX_NUM				INT				= 0;

    DECLARE @v_userid			    nvarchar(50)


	set @v_intg_plan_id	= @p_intg_plan_id
    set @v_userid	    = @p_userid



	if object_id('tempdb..#PLAN_ID') is not null
		drop table #PLAN_ID


	create table #PLAN_ID (
	          TID				        INT IDENTITY(1,1) NOT NULL PRIMARY KEY
            , INSTANCE_ID               nvarchar(30) 
			, FP_PLAN_ID 				nvarchar(30)
			)
			;

	
	BEGIN TRY		

		insert into #PLAN_ID (instance_id, fp_plan_id)
		select instance_id, plan_id
		  from scm_fp_plan_h with(nolock)
		 where intg_plan_id = @v_intg_plan_id
		

		SELECT @INX			= 1
			 , @MAX_NUM		= COUNT(*)
		  FROM #PLAN_ID

	  
		IF @MAX_NUM = 0
		BEGIN
			PRINT 'NG|' + 'No data.'
			RETURN 200;
		END

		
        --1. 전극
        insert into BUF_AMEND_DAILY_PLAN_R_XLS (
            [INSTANCE_ID]
           ,[FP_PLAN_ID]
           ,[COMPANY_ID]
           ,[DIVISION_ID]
           ,[SITE_ID]
           ,[PLANT_ID]
           ,[FACTORY_ID]
           ,[LOCATION]
           ,[OPERATION_ID]
           ,[LINE_ID]
           ,[ELECTRODE_TYPE]
           ,[EQUIPMENT_ID]
           ,[PLAN_DATE]
           ,[TOP_ITEM_ID]
           ,[ITEM_ID]
           ,[PRODUCTION_TYPE]
           ,[MARKET]
           ,[SEQ]
           ,[QTY]
           ,[ADJUST_OUT_QTY_BATCH]
           ,[ADJUST_OUT_QTY_M]
           ,[ADJUST_OUT_QTY_CELL]
           ,[JOB_USER_ID]
           ,[JOB_TIME]
           ,[JOB_TYPE]
           ,[JOB_SEQ]
           ,[JOB_ORDER]
           ,[ADJUST_OUT_QTY_JR]
           ,[ADJUST_IN_QTY_BATCH]
           ,[ADJUST_IN_QTY_M]
           ,[ADJUST_IN_QTY_CELL]
           ,[ADJUST_IN_QTY_JR]
           ,[ADJUST_IN_QTY_KG]
           ,[ADJUST_OUT_QTY_KG]
           ,[TOTAL_BATCH]
           ,[WORK_REQUEST_MODEL_ID]
           ,[VERSION]
           ,[PROD_SEQ]
           ,[PLM_EC_NO]
        
        )
        
        
		select 
               y.INSTANCE_ID           
			 , y.FP_PLAN_ID 			
			 , y.COMPANY_ID            
			 , y.DIVISION_ID 			
			 , y.SITE_ID 				
			 , y.PLANT_ID 				
			 , y.FACTORY_ID 			
			 , y.LOCATION 				
			 , y.OPERATION_ID 			
			 , y.LINE_ID 				
			 , y.ELECTRODE_TYPE 		
			 , y.EQUIPMENT_ID          
			 , y.PLAN_DATE 			
			 , y.MODEL_ID              
			 , y.ITEM_ID 				
			 , y.PRODUCTION_TYPE		
			 , y.MARKET 				
			 , y.SEQ                   
             , null
             , null
             , null
             , y.qty          
             , @v_userid
             , getdate()
             , 'EXCEL'
             , null
             , null
             , null
             , null
             , null
             , null
             , null
             , null
             , null
             , null
             , y.MODEL_ID  

             , y.VERSION 				
             , null
             , y.PLM_EC_NO  			
			 
        from BUF_AMEND_PLAN_R_XLS_QTY as y with(nolock)
        where y.insert_id   = @v_userid
        and   y.INSTANCE_ID = 'UC_E_PRE_A';  --전극만. 

        
        --2. 조립
        insert into BUF_AMEND_PLAN_CELL_R_XLS (
            [INSTANCE_ID]
           ,[FP_PLAN_ID]
           ,[COMPANY_ID]
           ,[DIVISION_ID]
           ,[CATEGORY_ID]
           ,[SITE_ID]
           ,[PLANT_ID]
           ,[ITEM_ID]
           ,[OPERATION_ID]
           ,[FACTORY_ID]
           ,[LOCATION]
           ,[PRODUCTION_TYPE]
           ,[MARKET]
           ,[LINE_ID]
           ,[ELECTRODE_TYPE]
           ,[PLAN_DATE]
           ,[TOP_ITEM_ID]
           ,[ITEM_TYPE]
           ,[IN_QTY]
           ,[OUT_QTY]
           ,[SALES_QTY]
           ,[CELL_IN_QTY]
           ,[CELL_OUT_QTY]
           ,[CELL_SALES_QTY]
           ,[YIELD]
           ,[DATE_SEQ]
           ,[ACTUAL_FLAG]
           ,[ORG_IN_QTY]
           ,[ORG_OUT_QTY]
           ,[ORG_SALES_QTY]
           ,[ORG_CELL_IN_QTY]
           ,[ORG_CELL_OUT_QTY]
           ,[ORG_CELL_SALES_QTY]
           ,[JOB_USER_ID]
           ,[JOB_TIME]
           ,[JOB_TYPE]
           ,[JOB_SEQ]
           ,[JOB_ORDER]
           ,[JOB_SAVE_SEQ]
           ,[PLM_EC_NO]
           ,[VERSION]
        
        )
        
		select 
               y.INSTANCE_ID           
			 , y.FP_PLAN_ID 			
			 , y.COMPANY_ID            
			 , y.DIVISION_ID 			
			 , y.CATEGORY_ID           
			 , y.SITE_ID 				
			 , y.PLANT_ID 				
			 , y.ITEM_ID 				
             , y.OPERATION_ID 			
             , y.FACTORY_ID 			
			 , y.LOCATION 				
			 , y.PRODUCTION_TYPE		
             , y.MARKET 				
			 , y.LINE_ID 				
			 , y.ELECTRODE_TYPE 		
			 , y.PLAN_DATE 			
             , y.MODEL_ID              
             , y.ITEM_TYPE
             , null
             , null
             , null
             , null
             , y.qty          
             , null
             , null
             , y.SEQ                   
             , null
             , null
             , null
             , null
             , null
             , null
             , null
             , @v_userid
             , getdate()
             , 'EXCEL'
             , null
             , null
             , null
             , y.PLM_EC_NO  			
             , y.VERSION 				
			 
        from BUF_AMEND_PLAN_R_XLS_QTY as y with(nolock)
        where y.insert_id   = @v_userid
        and   y.INSTANCE_ID = 'UC_CELL_A';  --조립

        
        --3. 활성화
        insert into BUF_AMEND_PLAN_FORM_R_XLS (
            [INSTANCE_ID]
           ,[FP_PLAN_ID]
           ,[COMPANY_ID]
           ,[DIVISION_ID]
           ,[SITE_ID]
           ,[PLANT_ID]
           ,[ITEM_ID]
           ,[OPERATION_ID]
           ,[FACTORY_ID]
           ,[LOCATION]
           ,[PRODUCTION_TYPE]
           ,[MARKET]
           ,[LINE_ID]
           ,[ELECTRODE_TYPE]
           ,[CUSTOMER_ID]
           ,[PLAN_DATE]
           ,[TOP_ITEM_ID]
           ,[QTY]
           ,[JOB_USER_ID]
           ,[JOB_TIME]
           ,[JOB_TYPE]
           ,[JOB_SEQ]
           ,[JOB_ORDER]
           ,[CELL_GROUP_CODE]
        
        )
        
		select 
               y.INSTANCE_ID           
			 , y.FP_PLAN_ID 			
			 , y.COMPANY_ID            
			 , y.DIVISION_ID 			
			 , y.SITE_ID 				
			 , y.PLANT_ID 				
			 , y.ITEM_ID 				
             , y.OPERATION_ID 			
             , y.FACTORY_ID 			
			 , y.LOCATION 				
			 , y.PRODUCTION_TYPE		
             , y.MARKET 				
			 , y.LINE_ID 				
			 , y.ELECTRODE_TYPE 		
			 , y.CUSTOMER_ID           
             , y.PLAN_DATE 			
             , y.MODEL_ID              
             , y.qty          
             , @v_userid
             , getdate()
             , 'EXCEL'
             , null
             , null
             , null
			 
        from BUF_AMEND_PLAN_R_XLS_QTY as y with(nolock)
        where y.insert_id   = @v_userid
        and   y.INSTANCE_ID = 'UC_FORM_A';  --활성화

        PRINT 'OK'
        
	END TRY

	BEGIN CATCH

		PRINT 'NG|' + ERROR_MESSAGE()

		if object_id('tempdb..#PLAN_ID') is not null
			drop table #PLAN_ID

		
	END CATCH

	if object_id('tempdb..#PLAN_ID') is not null
		drop table #PLAN_ID
		
	

END



