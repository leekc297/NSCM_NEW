CREATE PROCEDURE [dbo].[PR_SCM_AMEND_PLAN_PRIORITY]
@p_instance_id nvarchar(MAX) = '-', @p_plan_id nvarchar(MAX) = '-'
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_AMEND_PLAN_PRIORITY                                                 **/
/** 프로그램 명   : Procedure PR_SCM_AMEND_PLAN_PRIORITY                                       **/
/** 설 명         :                                                                           **/
/** Version       :				                                                              **/
/**                                                                                           **/
/** Argument                                                                                  **/
/**                                                                                           **/
/** [검색 조건]                                                                               **/
/**                                                                                           **/
/** [Biz Logic]                                                                               **/
/**                                                                                           **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자    작 성 자      사     유                                                      **/
/**===========================================================================================**/
/** 2026/06/08   kimcd      [PJ2026-50273] MI ESS LINK 공장 SCM(SCP/FP/PSCM ) 대응.            **/
/**                         Pack 공정군 로직에 LINK 공정군 추가                                 **/
/***********************************************************************************************/
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED
    SET NOCOUNT ON
  SET XACT_ABORT ON

  -- LOG 용 변수 설정
  DECLARE @v_proc_name nvarchar(100) = 'PR_SCM_AMEND_PLAN_PRIORITY'
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
  
  DECLARE @v_start_date  DATE
  
  SET @v_instance_id  = @p_instance_id
  SET @v_plan_id    = @p_plan_id
    
  -- Start 로그는 무조건 남김
  SET @n_log_count = @n_log_count + 1
 -- EXEC PR_XIF_LOG @v_proc_name, NULL, 'START', @n_log_count, @v_temp1, '############### Start of procedure ###############', NULL, @sysdate
  
  EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null
  
  SELECT  @v_start_date   = CONVERT(DATE, PLAN_START_TIME,112)
  FROM    SCM_FP_PLAN_H
  WHERE   INSTANCE_ID = @v_instance_id 
  AND     PLAN_ID     = @v_plan_id
  
  BEGIN TRY        
    
    IF (charindex('PMIX' , @v_instance_id) > 0) or (charindex('PRE',@v_instance_id) > 0) AND ( @v_instance_id <> 'KR_E_PRE_M2' )
    BEGIN
      
      -- 투입수량 없는 (계획이 존재하지 않는) SEQ 만 입력된경우 SEQ 0 처리.
      
      UPDATE FP_AMEND_DAILY_PLAN_R
      SET SEQ = 0 
      WHERE INSTANCE_ID  = @v_instance_id
      AND   FP_PLAN_ID = @v_plan_id
      AND   ADJUST_IN_QTY_BATCH IS NULL
      AND   ADJUST_OUT_QTY_BATCH IS NULL
      
      UPDATE FP_AMEND_DAILY_PLAN_R
      SET SEQ = 0 
      WHERE INSTANCE_ID  = @v_instance_id
      AND   FP_PLAN_ID = @v_plan_id
      AND   ADJUST_IN_QTY_BATCH = 0
      AND   ADJUST_OUT_QTY_BATCH = 0
      
      -- LINE 별 일자별 ORDER BY  PK 전체 조건
      
      UPDATE FP_AMEND_DAILY_PLAN_R
      SET FP_AMEND_DAILY_PLAN_R.SEQ = A.NEW_SEQ
      FROM (
              SELECT INSTANCE_ID ,
                     FP_PLAN_ID, 
                     FACTORY_ID,
                     LOCATION,
                     OPERATION_ID,
                     LINE_ID,
            			   ELECTRODE_TYPE,
                     EQUIPMENT_ID,
                     PLAN_DATE,
                     TOP_ITEM_ID,
                     ITEM_ID,
                     PRODUCTION_TYPE,
                     MARKET,
                     CUSTOMER_ID,
                     DENSE_RANK() OVER (PARTITION BY LINE_ID, PLAN_DATE ORDER BY   SEQ ,PRODUCTION_TYPE, MARKET, ADJUST_IN_QTY)  AS NEW_SEQ
              FROM FP_AMEND_DAILY_PLAN_R 
              WHERE INSTANCE_ID = @v_instance_id
              AND   FP_PLAN_ID = @v_plan_id			
              AND   ADJUST_IN_QTY_BATCH IS NOT NULL
              AND   ADJUST_OUT_QTY_BATCH IS NOT NULL
              AND   ADJUST_IN_QTY_BATCH != 0
              AND   ADJUST_OUT_QTY_BATCH != 0
              AND   PLAN_DATE >= @v_start_date
            )A
      WHERE FP_AMEND_DAILY_PLAN_R.INSTANCE_ID = @v_instance_id
      AND   FP_AMEND_DAILY_PLAN_R.FP_PLAN_ID = @v_plan_id			
      AND   FP_AMEND_DAILY_PLAN_R.INSTANCE_ID = A.INSTANCE_ID
      AND   FP_AMEND_DAILY_PLAN_R.FP_PLAN_ID = A.FP_PLAN_ID
      AND   FP_AMEND_DAILY_PLAN_R.FACTORY_ID = A.FACTORY_ID
      AND   FP_AMEND_DAILY_PLAN_R.LOCATION = A.LOCATION
      AND   FP_AMEND_DAILY_PLAN_R.OPERATION_ID = A.OPERATION_ID
      AND   FP_AMEND_DAILY_PLAN_R.LINE_ID = A.LINE_ID
      AND   FP_AMEND_DAILY_PLAN_R.ELECTRODE_TYPE = A.ELECTRODE_TYPE
      AND   FP_AMEND_DAILY_PLAN_R.EQUIPMENT_ID = A.EQUIPMENT_ID
      AND   FP_AMEND_DAILY_PLAN_R.PLAN_DATE = A.PLAN_DATE
      AND   FP_AMEND_DAILY_PLAN_R.TOP_ITEM_ID = A.TOP_ITEM_ID
      AND   FP_AMEND_DAILY_PLAN_R.ITEM_ID = A.ITEM_ID
      AND   FP_AMEND_DAILY_PLAN_R.PRODUCTION_TYPE = A.PRODUCTION_TYPE
      AND   FP_AMEND_DAILY_PLAN_R.MARKET = A.MARKET
      AND   FP_AMEND_DAILY_PLAN_R.CUSTOMER_ID = A.CUSTOMER_ID 
      
      SET @v_descr = CONVERT(nvarchar,@@ROWCOUNT)
      SET @n_log_count = @n_log_count + 1
      EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, 'FP_AMEND_DAILY_PLAN_R', 'UPDATE', @n_log_count, NULL, @v_descr, null
    
    END 
    ELSE IF (charindex('CELL' , @v_instance_id) > 0)
    BEGIN
    
      UPDATE FP_AMEND_PLAN_CELL_R
      SET DATE_SEQ = 0 
      WHERE INSTANCE_ID  = @v_instance_id
      AND   FP_PLAN_ID = @v_plan_id
      AND   IN_QTY IS NULL
      AND   OUT_QTY IS NULL
      
      UPDATE FP_AMEND_PLAN_CELL_R
      SET DATE_SEQ = 0 
      WHERE INSTANCE_ID  = @v_instance_id
      AND   FP_PLAN_ID = @v_plan_id
      AND   IN_QTY = 0
      AND   OUT_QTY = 0
      
      UPDATE FP_AMEND_PLAN_CELL_R
      SET FP_AMEND_PLAN_CELL_R.DATE_SEQ = A.NEW_SEQ
      FROM (
              SELECT 	INSTANCE_ID,
      								FP_PLAN_ID,
      								COMPANY_ID,
      								DIVISION_ID,
      								CATEGORY_ID,
      								SITE_ID,
      								PLANT_ID,
      								ITEM_ID,
      								OPERATION_ID,
      								FACTORY_ID,
      								LOCATION,
      								PRODUCTION_TYPE,
      								MARKET,
      								LINE_ID,
      								ELECTRODE_TYPE,
      								PLAN_DATE,
      								TOP_ITEM_ID,
      								ITEM_TYPE,
                 			DENSE_RANK() OVER (PARTITION BY LINE_ID, PLAN_DATE ORDER BY   DATE_SEQ ,PRODUCTION_TYPE, MARKET,IN_QTY)  AS NEW_SEQ
              FROM FP_AMEND_PLAN_CELL_R 
              WHERE INSTANCE_ID = @v_instance_id
              AND   FP_PLAN_ID = @v_plan_id			
              AND   IN_QTY IS NOT NULL
              AND   OUT_QTY IS NOT NULL
              AND   IN_QTY != 0
              AND   OUT_QTY != 0
            )A
      WHERE FP_AMEND_PLAN_CELL_R.INSTANCE_ID = @v_instance_id
      AND   FP_AMEND_PLAN_CELL_R.FP_PLAN_ID = @v_plan_id		
      AND   FP_AMEND_PLAN_CELL_R.INSTANCE_ID = A.INSTANCE_ID
      AND   FP_AMEND_PLAN_CELL_R.FP_PLAN_ID = A.FP_PLAN_ID
      AND   FP_AMEND_PLAN_CELL_R.COMPANY_ID = A.COMPANY_ID
      AND   FP_AMEND_PLAN_CELL_R.DIVISION_ID = A.DIVISION_ID
      AND   FP_AMEND_PLAN_CELL_R.CATEGORY_ID = A.CATEGORY_ID
      AND   FP_AMEND_PLAN_CELL_R.SITE_ID = A.SITE_ID
      AND   FP_AMEND_PLAN_CELL_R.PLANT_ID = A.PLANT_ID
      AND   FP_AMEND_PLAN_CELL_R.ITEM_ID = A.ITEM_ID
      AND   FP_AMEND_PLAN_CELL_R.OPERATION_ID = A.OPERATION_ID
      AND   FP_AMEND_PLAN_CELL_R.FACTORY_ID = A.FACTORY_ID
      AND   FP_AMEND_PLAN_CELL_R.LOCATION = A.LOCATION
      AND   FP_AMEND_PLAN_CELL_R.PRODUCTION_TYPE = A.PRODUCTION_TYPE
      AND   FP_AMEND_PLAN_CELL_R.MARKET = A.MARKET
      AND   FP_AMEND_PLAN_CELL_R.LINE_ID = A.LINE_ID
      AND   FP_AMEND_PLAN_CELL_R.ELECTRODE_TYPE = A.ELECTRODE_TYPE
      AND   FP_AMEND_PLAN_CELL_R.PLAN_DATE = A.PLAN_DATE
      AND   FP_AMEND_PLAN_CELL_R.TOP_ITEM_ID = A.TOP_ITEM_ID
      AND   FP_AMEND_PLAN_CELL_R.ITEM_TYPE = A.ITEM_TYPE
      
      SET @v_descr = CONVERT(nvarchar,@@ROWCOUNT)
      SET @n_log_count = @n_log_count + 1
      EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, 'FP_AMEND_PLAN_CELL_R', 'UPDATE', @n_log_count, NULL, @v_descr, null
      
    END
    ELSE IF (charindex('PACK',@v_instance_id) > 0) OR (charindex('LINK',@v_instance_id) > 0)  -- 2026/06/08 kimcd [PJ2026-50273] MI ESS LINK 공장 SCM(SCP/FP/PSCM ) 대응. Pack 공정군 로직에 LINK 공정군 추가  
    BEGIN
    
      UPDATE FP_AMEND_PLAN_PACK_R
      SET DATE_SEQ = 0 
      WHERE INSTANCE_ID  = @v_instance_id
      AND   FP_PLAN_ID = @v_plan_id
      AND   IN_QTY IS NULL
      AND   OUT_QTY IS NULL
      
      UPDATE FP_AMEND_PLAN_PACK_R
      SET DATE_SEQ = 0 
      WHERE INSTANCE_ID  = @v_instance_id
      AND   FP_PLAN_ID = @v_plan_id
      AND   IN_QTY = 0
      AND   OUT_QTY = 0
      
      UPDATE FP_AMEND_PLAN_PACK_R
      SET FP_AMEND_PLAN_PACK_R.DATE_SEQ = A.NEW_SEQ
      FROM (
              SELECT 	INSTANCE_ID,
      								FP_PLAN_ID,
      								COMPANY_ID,
      								DIVISION_ID,
      								CATEGORY_ID,
      								SITE_ID,
      								PLANT_ID,
      								ITEM_ID,
      								OPERATION_ID,
      								FACTORY_ID,
      								LOCATION,
      								PRODUCTION_TYPE,
      								MARKET,
      								LINE_ID,
      								ELECTRODE_TYPE,
      								PLAN_DATE,
      								TOP_ITEM_ID,
      								ITEM_TYPE,
                 			DENSE_RANK() OVER (PARTITION BY LINE_ID, PLAN_DATE ORDER BY   DATE_SEQ ,PRODUCTION_TYPE, MARKET,IN_QTY)  AS NEW_SEQ
              FROM FP_AMEND_PLAN_PACK_R 
              WHERE INSTANCE_ID = @v_instance_id
              AND   FP_PLAN_ID = @v_plan_id			
              AND   IN_QTY IS NOT NULL
              AND   OUT_QTY IS NOT NULL
              AND   IN_QTY != 0
              AND   OUT_QTY != 0
            )A
      WHERE FP_AMEND_PLAN_PACK_R.INSTANCE_ID = @v_instance_id
      AND   FP_AMEND_PLAN_PACK_R.FP_PLAN_ID = @v_plan_id		
      AND   FP_AMEND_PLAN_PACK_R.INSTANCE_ID = A.INSTANCE_ID
      AND   FP_AMEND_PLAN_PACK_R.FP_PLAN_ID = A.FP_PLAN_ID
      AND   FP_AMEND_PLAN_PACK_R.COMPANY_ID = A.COMPANY_ID
      AND   FP_AMEND_PLAN_PACK_R.DIVISION_ID = A.DIVISION_ID
      AND   FP_AMEND_PLAN_PACK_R.CATEGORY_ID = A.CATEGORY_ID
      AND   FP_AMEND_PLAN_PACK_R.SITE_ID = A.SITE_ID
      AND   FP_AMEND_PLAN_PACK_R.PLANT_ID = A.PLANT_ID
      AND   FP_AMEND_PLAN_PACK_R.ITEM_ID = A.ITEM_ID
      AND   FP_AMEND_PLAN_PACK_R.OPERATION_ID = A.OPERATION_ID
      AND   FP_AMEND_PLAN_PACK_R.FACTORY_ID = A.FACTORY_ID
      AND   FP_AMEND_PLAN_PACK_R.LOCATION = A.LOCATION
      AND   FP_AMEND_PLAN_PACK_R.PRODUCTION_TYPE = A.PRODUCTION_TYPE
      AND   FP_AMEND_PLAN_PACK_R.MARKET = A.MARKET
      AND   FP_AMEND_PLAN_PACK_R.LINE_ID = A.LINE_ID
      AND   FP_AMEND_PLAN_PACK_R.ELECTRODE_TYPE = A.ELECTRODE_TYPE
      AND   FP_AMEND_PLAN_PACK_R.PLAN_DATE = A.PLAN_DATE
      AND   FP_AMEND_PLAN_PACK_R.TOP_ITEM_ID = A.TOP_ITEM_ID
      AND   FP_AMEND_PLAN_PACK_R.ITEM_TYPE = A.ITEM_TYPE
      
      SET @v_descr = CONVERT(nvarchar,@@ROWCOUNT)
      SET @n_log_count = @n_log_count + 1
      EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, 'FP_AMEND_PLAN_PACK_R', 'UPDATE', @n_log_count, NULL, @v_descr, null
      
    END

  END TRY

  BEGIN CATCH
       
    -- 에러나도 로그는 인서트
    SET @v_log_code = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
    SET @v_descr = ERROR_MESSAGE()
    --EXEC PR_XIF_LOG @v_proc_name, NULL, 'ERROR', NULL, @v_temp2, NULL, @v_descr, @sysdate
    
    EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_log_code, null, @v_descr

      IF @@TRANCOUNT > 0
         COMMIT WORK 
  END CATCH
  
  EXEC PR_XIF_LOG @v_proc_name, NULL, 'END',   999999, @v_temp1, '############### End of procedure ###############', NULL, @sysdate
  
  EXEC PR_LOG_PROCESS @sysdate, @v_instance_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

END