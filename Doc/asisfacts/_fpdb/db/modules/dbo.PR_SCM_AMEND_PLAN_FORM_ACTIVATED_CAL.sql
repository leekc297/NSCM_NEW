CREATE PROCEDURE [dbo].[PR_SCM_AMEND_PLAN_FORM_ACTIVATED_CAL]
@p_instance_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
  SET XACT_ABORT ON

  -- LOG 용 변수 설정
  DECLARE @v_proc_name nvarchar(100) = 'PR_SCM_AMEND_PLAN_FORM_ACTIVATED_CAL'
  DECLARE @v_descr     nvarchar(250)
  DECLARE @v_flag  nvarchar(1) = 'N'
  DECLARE @v_run_flag  nvarchar(1) = 'N'
  DECLARE @v_run_step  nvarchar(1) = '0'
  DECLARE @v_plan_flag  nvarchar(1) = 'C'
  DECLARE @v_run_step2  nvarchar(1) = '0'
  DECLARE @n_loop_date nvarchar(250)
  DECLARE @n_loop_count INTEGER    = 0
  
  DECLARE @v_temp1            nvarchar(1000)
  DECLARE @v_temp2            nvarchar(1000)
  
  DECLARE @n_log_count INTEGER    = 0
  DECLARE @sysdate     DATETIME     = GETDATE()
  DECLARE @v_log_code   nvarchar(10)
  DECLARE @v_isfinished nvarchar(20)
  
  DECLARE @v_instance_id  nvarchar(1000)  
  DECLARE @v_plan_id    nvarchar(1000)
  

  -- Start 로그는 무조건 남김
  SET @n_log_count = @n_log_count + 1
  EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', @n_log_count, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate
  
  EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null
  
  BEGIN TRY        

    BEGIN
    
      SET @v_instance_id  = @p_instance_id
      SET @v_plan_id    = @p_plan_id
      
      BEGIN
      
        UPDATE FP_AMEND_PLAN_FORM_R
        SET FP_AMEND_PLAN_FORM_R.AVAILABILITY = A.QTY
        FROM (
        			SELECT COMPANY_ID , DIVISION_ID , SITE_ID , PLANT_ID , EQUIPMENT_ID , ITEM_ID , PLAN_DATE , QTY 
        FROM FP_FORMATION_PSI_UI
        WHERE INSTANCE_ID = @v_instance_id 
        AND FP_PLAN_ID = @V_PLAN_ID
        AND CATEGORY_ID = 'AVAILABILITY'
        		)A
        WHERE FP_AMEND_PLAN_FORM_R.INSTANCE_ID  = @v_instance_id
        AND    FP_AMEND_PLAN_FORM_R.FP_PLAN_ID = @V_PLAN_ID
        AND    FP_AMEND_PLAN_FORM_R.COMPANY_ID = A.COMPANY_ID
        AND    FP_AMEND_PLAN_FORM_R.DIVISION_ID = A.DIVISION_ID
        AND    FP_AMEND_PLAN_FORM_R.SITE_ID = A.SITE_ID
        AND    FP_AMEND_PLAN_FORM_R.PLANT_ID = A.PLANT_ID
        AND    FP_AMEND_PLAN_FORM_R.LINE_ID = A.EQUIPMENT_ID
        AND    FP_AMEND_PLAN_FORM_R.ITEM_ID = A.ITEM_ID
        AND    FP_AMEND_PLAN_FORM_R.PLAN_DATE = A.PLAN_DATE
      
      END
      
      /*
         SY_FP_AMEND_FORM_ACTIVATED 기초 데이터는 속도 문제상 계획 수립시  생성
         호출시 단순 업데이트
      */
      
      /*UPDATE FP_AMEND_FORM_ACTIVATED
      SET FP_AMEND_FORM_ACTIVATED.PRODUCT_SUM_QTY =  A.PRODUCT_SUM_QTY
      FROM (           
            SELECT  A.COMPANY_ID ,
    				  			A.DIVISION_ID,
    				  			A.SITE_ID,
    				  			A.PLANT_ID , 
    				  			A.ITEM_ID,
    				  			A.FACTORY_ID,
    				  			A.LINE_ID AS EQUIPMENT_ID,
    				  			A.PLAN_DATE,
    				  			 SUM(A.OUT_QTY) OVER (PARTITION BY A.COMPANY_ID
    				                                                         , A.DIVISION_ID
    				                                                         , A.SITE_ID
    				                                                         , A.PLANT_ID
    				                                                         , A.ITEM_ID
    				                                                         , A.FACTORY_ID
    				                                                         , A.LINE_ID
    				                                              ORDER     BY A.PLAN_DATE    )  AS PRODUCT_SUM_QTY
    				FROM  FP_AMEND_PLAN_FORM_R A 
    				WHERE A.INSTANCE_ID =  @v_instance_id
    				AND A.FP_PLAN_ID =  @v_plan_id 
    				AND A.LINE_ID <> '-'
    				)A
      WHERE    FP_AMEND_FORM_ACTIVATED.INSTANCE_ID = @v_instance_id
      AND   	 FP_AMEND_FORM_ACTIVATED.FP_PLAN_ID = @v_plan_id
      AND 		 FP_AMEND_FORM_ACTIVATED.COMPANY_ID = A.COMPANY_ID
      AND 		 FP_AMEND_FORM_ACTIVATED.DIVISION_ID = A.DIVISION_ID
      AND		   FP_AMEND_FORM_ACTIVATED.SITE_ID = A.SITE_ID
      AND 		 FP_AMEND_FORM_ACTIVATED.PLANT_ID = A.PLANT_ID
      AND 		 FP_AMEND_FORM_ACTIVATED.ITEM_ID = A.ITEM_ID
      AND 		 FP_AMEND_FORM_ACTIVATED.FACTORY_ID = A.FACTORY_ID
      AND      FP_AMEND_FORM_ACTIVATED.EQUIPMENT_ID = A.EQUIPMENT_ID
      AND      FP_AMEND_FORM_ACTIVATED.PLAN_DATE = A.PLAN_DATE 
      
      SET @v_descr = 'SY_FP_AMEND_FORM_ACTIVATED UPDATE :'+CONVERT(nvarchar,@@ROWCOUNT)
      SET @n_log_count = @n_log_count + 1
      EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'UPDATE', @n_log_count, NULL, @v_descr, null
      
      UPDATE FP_AMEND_PLAN_FORM_R 
      SET 	FP_AMEND_PLAN_FORM_R.AVAILABILITY =  A.QTY , 
            FP_AMEND_PLAN_FORM_R.UPDATE_ID = @v_proc_name  ,
            FP_AMEND_PLAN_FORM_R.UPDATE_TIME = @sysdate
      FROM (
      				SELECT A.INSTANCE_ID,
				              A.FP_PLAN_ID,
				              A.COMPANY_ID,
				              A.DIVISION_ID,
				              A.SITE_ID,
				              A.PLANT_ID,
				              A.ITEM_ID,
				              A.FACTORY_ID,
				              A.EQUIPMENT_ID,
				              A.PLAN_DATE,
				              A.STOCK_SUM_QTY + A.CELL_SUM_QTY - A.PRODUCT_SUM_QTY AS QTY
				FROM   FP_AMEND_FORM_ACTIVATED A
				WHERE A.INSTANCE_ID = @v_instance_id
				AND 	   A.FP_PLAN_ID  = @v_plan_id
      			)A
      WHERE    FP_AMEND_PLAN_FORM_R.INSTANCE_ID = @v_instance_id 
      AND 		 FP_AMEND_PLAN_FORM_R.FP_PLAN_ID = @v_plan_id
      AND      FP_AMEND_PLAN_FORM_R.INSTANCE_ID = A.INSTANCE_ID
      AND 		 FP_AMEND_PLAN_FORM_R.FP_PLAN_ID = A.FP_PLAN_ID
      AND 		 FP_AMEND_PLAN_FORM_R.COMPANY_ID = A.COMPANY_ID
      AND 		 FP_AMEND_PLAN_FORM_R.DIVISION_ID = A.DIVISION_ID
      AND 		 FP_AMEND_PLAN_FORM_R.SITE_ID = A.SITE_ID
      AND      FP_AMEND_PLAN_FORM_R.FACTORY_ID = A.FACTORY_ID
      AND      FP_AMEND_PLAN_FORM_R.LINE_ID = A.EQUIPMENT_ID
      AND      FP_AMEND_PLAN_FORM_R.ITEM_ID = A.ITEM_ID
      AND      FP_AMEND_PLAN_FORM_R.PLAN_DATE = A.PLAN_DATE
      AND      EXISTS (
                        SELECT 1
                        FROM FP_AMEND_PLAN_FORM_R X
                        WHERE X.INSTANCE_ID = @v_instance_id 
                        AND X.FP_PLAN_ID = @v_plan_id 
                        AND X.OUT_QTY <> X.ORG_OUT_QTY
                        AND FP_AMEND_PLAN_FORM_R.INSTANCE_ID = X.INSTANCE_ID
                        AND FP_AMEND_PLAN_FORM_R.FP_PLAN_ID = X.FP_PLAN_ID
                        AND FP_AMEND_PLAN_FORM_R.COMPANY_ID = X.COMPANY_ID
                        AND FP_AMEND_PLAN_FORM_R.DIVISION_ID = X.DIVISION_ID
                        AND FP_AMEND_PLAN_FORM_R.SITE_ID = X.SITE_ID
                        AND FP_AMEND_PLAN_FORM_R.FACTORY_ID = X.FACTORY_ID
                        AND FP_AMEND_PLAN_FORM_R.LINE_ID = X.LINE_ID
                        AND FP_AMEND_PLAN_FORM_R.ITEM_ID = X.ITEM_ID
                      )
      
      SET @v_descr = 'SY_FP_AMEND_FORM_ACTIVATED UPDATE :'+CONVERT(nvarchar,@@ROWCOUNT)
      SET @n_log_count = @n_log_count + 1
      EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'UPDATE', @n_log_count, NULL, @v_descr, null*/
    
    END

  END TRY

  BEGIN CATCH
       
    -- 에러나도 로그는 인서트
    SET @v_log_code = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
    SET @v_descr = ERROR_MESSAGE()
    EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate
    
    EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_log_code, null, @v_descr

      IF @@TRANCOUNT > 0
         COMMIT WORK 
  END CATCH
  
  EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   999999, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
  
  EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

END
