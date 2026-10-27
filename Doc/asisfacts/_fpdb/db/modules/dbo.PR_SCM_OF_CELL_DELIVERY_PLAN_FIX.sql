CREATE PROCEDURE [dbo].[PR_SCM_OF_CELL_DELIVERY_PLAN_FIX]
@p_master_id nvarchar(MAX) = '-' ,@p_confirm_id nvarchar(MAX) ='-' ,@p_user_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_OF_CELL_DELIVERY_PLAN_FIX                                         **/
/** 프로그램 명   :                                                                           **/
/** 설 명         :                                                                           **/
/** Version       : 1.0.0                                                                     **/
/**                                                                                           **/
/** Argument                                                                                  **/
/**                                                                                           **/
/**  [검색 조건]                                                                              **/
/**                                                                                           **/
/** [Biz Logic]                                                                               **/
/**                                                                                           **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                                    **/
/**===========================================================================================**/
/** 2018.07.12    SHS          최초 작성                                                      **/
/** 2020.09.09    CYS          과거 구간 Copy 데이타가 Confirm 되지 않도록 Confirm 구간을 지정 - (D20200909~R0909.01)                     **/
/***********************************************************************************************/
/*
  EXEC PR_SCM_OF_PACK_REQUIRE_FIX
*/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  DECLARE
    @v_proc_name        nvarchar(150) = 'PR_SCM_OF_CELL_DELIVERY_PLAN_FIX', 
    @v_table_name       nvarchar(150) = NULL, 
    @v_master_id        nvarchar(150) = @p_master_id ,
    @v_confirm_id       nvarchar(20) = @p_confirm_id ,
    @v_plan_id          nvarchar(150) = '-',
    @v_user_id          nvarchar(150) = isnull(@p_user_id,'PR_SCM_OF_CELL_DELIVERY_PLAN_FIX') , 
    @v_confirm_date     nvarchar(30) = substring(@p_confirm_id , 1, 8) ,
    @v_site_id          nvarchar(30) = '-'
    
  DECLARE
    @n_count            Integer  = 0,
    @n_log_count        Integer  = 0,
    @sysdate            DATETIME2 = GETDATE(),
    @v_message          nvarchar(200),
    @v_description      nvarchar(200)

  DECLARE 
    @plan_start_time  datetime,
    @plan_end_time    datetime,
    @key_date         nvarchar(8),
    @v_plan_date         nvarchar(8),
    @v_basis_plan_id  nvarchar(100),
    @v_plan_type      nvarchar(8)
    
  DECLARE
    @confirm_area     nvarchar(30) = 'BUILDING' ,
    @n_row_count      Integer  = 0 ,
    @v_cutoff_date    date
  
  DECLARE
    @offset$scp_target_id       nvarchar(150), 
    @offset$qty                 numeric(20,10),
    @offset$minus_qty           numeric(20,10),
    @offset$mfg_qty             numeric(20,10)  
  
  DECLARE
    @v_form_master_id            nvarchar(150),
    @v_form_master_id2           nvarchar(150)
    
  DECLARE 
    @v_offset_seq integer  

  BEGIN TRY
    --LOG 생성
    SET @n_log_count = @n_log_count + 1
    SET @sysdate = GETDATE()
    EXEC PR_LOG_PROCESS @sysdate, @v_master_id, '-', @v_proc_name, '###############', 'START', @n_log_count, null, '############### Start of procedure ###############', null
    
    IF CHARINDEX('FORM', @v_master_id) > 0 
    BEGIN
    
      SELECT @v_site_id = isnull(max(SEGMENT4), 'A001')
      FROM  dbo.SCM_SYS_LOOKUP_VALUE
      WHERE LOOKUP_TYPE_CODE = 'INSTANCE_INFO'
      AND   SEGMENT1 =  @v_master_id
   
      --LOG 생성
  
      SET @v_table_name = 'TH_MST_PLAN'
      SELECT  @key_date = INSTANCE_DATE,
              @v_plan_date = INSTANCE_DATE,
              @v_cutoff_date  = RELEASE_DATE 
      FROM   (
              SELECT MAX(INSTANCE_DATE) AS INSTANCE_DATE,
                     MAX(RELEASE_DATE) AS RELEASE_DATE
              FROM   TH_BUF_RELEASE_PLAN 
              WHERE INSTANCE_ID = @v_master_id
              GROUP  BY INSTANCE_ID 
             ) A
             
             
      --LOG 생성
      SET @v_message = 'cutoff_date : ' + CONVERT(nvarchar,@v_cutoff_date, 112)  + ' @v_confirm_date : ' + CONVERT(nvarchar,@v_confirm_date)
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, '-', @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
       
      SELECT @v_form_master_id = CASE WHEN @v_master_id = 'KR_PACK'   THEN 'KR_FORM_A'
                                      WHEN @v_master_id = 'CN_PACK'   THEN 'CN_FORM_A'
                                      WHEN @v_master_id = 'PL_PACK'   THEN 'PL_FORM_A'
                                      WHEN @v_master_id = 'US_PACK'   THEN 'US_FORM_A'
                                      ELSE 'NA' END    
    
      --LOG 생성
      SET @v_message = '@v_form_master_id : ' + @v_form_master_id
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
      
      SELECT @v_form_master_id2 = CASE WHEN @v_master_id = 'CN_PACK'   THEN 'CN_FORM_E'
                                        ELSE 'NA' END    
    
      --LOG 생성
      SET @v_message = '@v_form_master_id2 : ' + @v_form_master_id2
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
      
      UPDATE SCM_FP_IN_HOUSE_PLAN_H
      SET CONFIRM_FLAG = 'Y' ,
          CONFIRM_TIME = dbo.FN_SITE_TIME  (@v_site_id) ,  
          UPDATE_ID  = @v_user_id , 
          UPDATE_TIME = dbo.FN_SITE_TIME  (@v_site_id) 
      WHERE  INSTANCE_ID = @v_master_id
      AND    PLAN_ID = @v_confirm_id
      
      --LOG 생성
      SET @v_message = 'SCM_FP_IN_HOUSE_PLAN_H  : ' + @v_confirm_id
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'UPDATE', @n_log_count, null, @v_message, null
		
       -- (D20200909~R0909.01) ADD 
        SET 		@v_table_name = 'SCM_FP_IN_HOUSE_PLAN_H'
        
      	SELECT	@v_plan_date = A.PLAN_DATE
		FROM   	SCM_FP_IN_HOUSE_PLAN_H A WITH(NOLOCK) 
		WHERE  	INSTANCE_ID 	= @v_master_id
		AND    	PLAN_ID 			= @v_confirm_id

		--LOG 생성
      	SET @v_message = 'PLAN_DATE : ' + CONVERT(nvarchar, @v_plan_date) 
      	SET @n_log_count = @n_log_count + 1
      	SET @sysdate = GETDATE()
      	EXECUTE pr_log_process  null, @v_master_id, '-', @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
      	
      BEGIN
      
        SET @v_table_name = 'FP_CELL_DELIVERY_PLAN_FIX_H'
        SET @n_row_count = 0
      
        DELETE FP_CELL_DELIVERY_PLAN_FIX_H 
        WHERE INSTANCE_ID = @v_master_id 
        AND   PLAN_ID = @v_confirm_id
        --AND   DELIVERY_DATE >= convert(date,getdate(),112)
      
        INSERT INTO FP_CELL_DELIVERY_PLAN_FIX_H 
            (
            	INSTANCE_ID ,
              PLAN_ID , 
              COMPANY_ID ,
              DIVISION_ID ,
              SITE_ID ,
              PLANT_ID ,
              ITEM_ID ,
              STORAGE_ID ,
              SOC_ID ,
              MARKET ,
              DELIVERY_DATE ,
              ORG_DELIVERY_QTY ,
              DELIVERY_QTY ,
              INSERT_ID ,
              INSERT_TIME ,
              UPDATE_ID ,
              UPDATE_TIME,
              MOQ
            )      
        SELECT  INSTANCE_ID ,
                PLAN_ID , 
                COMPANY_ID ,
                DIVISION_ID ,
                SITE_ID ,
                PLANT_ID ,
                ITEM_ID ,
                STORAGE_ID ,
                SOC_ID ,
                MARKET ,
                DELIVERY_DATE ,
                ORG_DELIVERY_QTY ,
                DELIVERY_QTY ,
                @v_user_id AS  INSERT_ID , 
		       			GETDATE() AS INSERT_TIME , 
		       			@v_user_id AS UPDATE_ID , 
		       			GETDATE() AS UPDATE_TIME ,
                MOQ
       	FROM FP_CELL_DELIVERY_PLAN_H		
       	WHERE INSTANCE_ID = @v_master_id
        AND   PLAN_ID = @v_confirm_id
        AND   DELIVERY_DATE >=  CONVERT(DATE, @v_plan_date , 112)	-- (D20200909~R0909.01) 
        --AND   DELIVERY_DATE >=  convert(date,getdate(),112)		-- site 가 틀리거나 일자가 변경됐을 경우 기준일자가 틀려짐
        
         --LOG 생성
        SET @v_message = @@ROWCOUNT
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null
      
      END
        
      
    END
    
    /*
      History data 생성
    */
    BEGIN
    
      SET @v_table_name = 'FP_CELL_INHOUSE_PLAN_H'
      
      DELETE FP_CELL_INHOUSE_PLAN_H
      WHERE CATEGORY = 'MOVING'
      AND   INSTANCE_ID = @v_master_id
      AND   PLAN_DATE >=  convert(date,@v_confirm_date,112)
      
      --LOG 생성
      SET @v_message = @@ROWCOUNT
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'DELETE', @n_log_count, null, @v_message, null
      
      INSERT INTO FP_CELL_INHOUSE_PLAN_H
          (
            CATEGORY,
            INSTANCE_ID,
            COMPANY_ID,
            DIVISION_ID,
            SITE_ID,
            PLANT_ID,
            ITEM_ID,
            STORAGE_ID,
            SOC_ID,
            MARKET,
            PLAN_DATE,
            QTY,
            CONFIRM_ID, 
            INSERT_ID, 
            INSERT_DTTM
          )
      SELECT  'MOVING' AS CATEGORY_ID , 
    				  INSTANCE_ID , 
    				  COMPANY_ID , 
    				  DIVISION_ID , 
    				  SITE_ID , 
    				  PLANT_ID , 
    				  ITEM_ID , 
    				  STORAGE_ID , 
    				  SOC_ID , 
    				  MARKET , 
    				  DELIVERY_DATE AS PLAN_DATE ,
    				  DELIVERY_QTY AS QTY ,
    				  @v_confirm_id AS CONFIRM_ID ,
    				  @v_user_id AS  INSERT_ID , 
	       		  GETDATE() AS INSERT_TIME 
      FROM FP_CELL_DELIVERY_PLAN_H		
      WHERE INSTANCE_ID = @v_master_id
      AND   PLAN_ID = @v_confirm_id  
	    AND   DELIVERY_DATE >=  convert(date,@v_confirm_date,112)  

      --LOG 생성
      SET @v_message = @@ROWCOUNT
      SET @n_log_count = @n_log_count + 1
      SET @sysdate = GETDATE()
      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'INSERT', @n_log_count, null, @v_message, null

    
    END
    
    -----------------------------------------------------------------------------------------------------------------------------------

    
    --LOG 생성
    EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, '===============', 'END', 999999, null, '=============== End of procedure ===============', null

    IF @@TRANCOUNT > 0
       COMMIT WORK 

  END TRY

  BEGIN CATCH
    BEGIN

      DECLARE 
        @v_error_message nvarchar(max),
        @v_error_procedure nvarchar(max),
        @v_error_line nvarchar(max)

      SET @v_error_message = ERROR_MESSAGE()

      SET @v_error_procedure = ERROR_PROCEDURE()

      SET @v_error_line = convert(nvarchar,ERROR_LINE())


      EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_error_procedure, null, 'ERROR', null, @v_error_line, null, @v_error_message

      IF @@TRANCOUNT > 0
         COMMIT WORK 
    END
  END CATCH
END
