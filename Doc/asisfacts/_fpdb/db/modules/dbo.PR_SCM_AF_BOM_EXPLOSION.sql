CREATE PROCEDURE [dbo].[PR_SCM_AF_BOM_EXPLOSION]
WITH EXEC AS CALLER
AS
/***********************************************************************************************/
/** 프로그램 ID   : PR_SCM_AF_BOM_EXPLOSION					             	    				                **/
/** 프로그램 명   :											                                                     **/
/** 설 명         :											                                                      **/
/** Version       : 1.0.0                                                                     **/
/**                 			                                                                    **/
/** Argument     										        							                                    **/
/**                 			                                                                    **/
/**	[검색 조건]																				                                        **/
/**                 			                                                                    **/
/** [Biz Logic]										        								                                    **/
/**                 			                                                                    **/
/**-------------------------------------------------------------------------------------------**/
/** 작 성 일 자		작 성 자			사	   유											                                 **/
/**===========================================================================================**/
/** 2016.10.19		LJH					최초 작성											                                  **/
/***********************************************************************************************/
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
	SET XACT_ABORT ON;

  -- 필수 칼럼
	DECLARE @v_company			    nvarchar(30)   
	DECLARE @v_division			    nvarchar(30)
	DECLARE @v_corporation      nvarchar(30)
	DECLARE @v_plant   			    nvarchar(30)
	DECLARE @v_master_id			  nvarchar(30)
	DECLARE @v_plan_id				  nvarchar(30)
	DECLARE @v_top_plan_id		  nvarchar(30)
  DECLARE @plan_start_time    datetime
  DECLARE @plan_end_time      datetime
  DECLARE @plan_date          nvarchar(10) = CONVERT(nvarchar(10),GETDATE(),23)


  DECLARE @v_product_plan_id  nvarchar(30)
  DECLARE @v_shipment_plan_id nvarchar(30)
  DECLARE @v_srs_plan_id      nvarchar(30)
  
  DECLARE @v_start_week       nvarchar(10)
  DECLARE @v_end_week         nvarchar(10)
  
  DECLARE @validation_seq     Integer = 0

  -- LOG 용 변수 설정
	DECLARE @v_proc_name			  nvarchar(100) = 'PR_SCM_AF_BOM_EXPLOSION'
	DECLARE @v_table_name       nvarchar(100)
  DECLARE @v_message          nvarchar(250)
	DECLARE @v_descr				    nvarchar(250)
	DECLARE @n_row_count			  Integer	= 0
	DECLARE @n_log_count  		  Integer	= 0
	DECLARE @v_log_code			    nvarchar(10)
	DECLARE @n_level  		      Integer	= 0
	DECLARE @n_loop   		      Integer	= 0
  
	
	DECLARE @sysdate				    DATETIME2 = GETDATE()

	DECLARE @v_temp1				    nvarchar(1000)
	DECLARE @v_temp2				    nvarchar(1000)
  
  SET @v_master_id  = 'MASTER'
  SET @v_plan_id    = 'VALIDATION_' + CONVERT(nvarchar, GETDATE(), 112)
	
  SET @v_temp1 = 'S' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
	SET @v_temp2 = 'E' + replicate('0', 4-LEN(CAST(ERROR_LINE() AS nvarchar(10)))) + CAST(ERROR_LINE() AS nvarchar(10))
  
  SET @n_log_count = @n_log_count + 1
  SET @sysdate = GETDATE()
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'START', @n_log_count, null, '############### Start of procedure ###############', null

  BEGIN TRY
    
    BEGIN

      BEGIN
      
        DELETE FROM FP_BOM_EXPLOSION_INFO
        
        INSERT INTO FP_BOM_EXPLOSION_INFO
        SELECT A.COMPANY_ID
              ,A.DIVISION_ID
              ,A.SITE_ID
              ,A.PLANT_ID
              ,A.PARENT_ITEM_ID
              ,A.CHILD_ITEM_ID
              ,A.KEY_DATE
              ,A.EFF_START_DATE
              ,A.EFF_END_DATE
              ,A.PARENT_QTY
              ,A.PARENT_UOM
              ,A.CHILD_QTY
              ,A.CHILD_UOM
              ,PD1.ITEM_TYPE AS PARENT_ITEM_TYPE
              ,PD1.ITEM_CLASS AS PARENT_ITEM_CLASS
              ,PD1.NICK_NAME AS PARENT_NICK_NAME
              ,PDC1.LEVEL_2_CODE AS PARENT_LEVEL_2_CODE
              ,PDC1.LEVEL_3_NAME AS PARENT_LEVEL_3_NAME
              ,PD2.ITEM_TYPE AS CHILD_ITEM_TYPE
              ,PD2.ITEM_CLASS AS CHILD_ITEM_CLASS
              ,PD2.NICK_NAME AS CHILD_NICK_NAME
              ,PDC2.LEVEL_2_CODE AS CHILD_LEVEL_2_CODE
              ,PDC2.LEVEL_3_NAME AS CHILD_LEVEL_3_NAME
              --,1 AS NLEVEL
        FROM  SCM_BOM_M A(NOLOCK)
              INNER MERGE JOIN SCM_ITEM_M PD1(NOLOCK)
                    ON    A.COMPANY_ID      = PD1.COMPANY_ID
                    AND   A.DIVISION_ID     = PD1.DIVISION_ID
                    AND   A.SITE_ID         = PD1.SITE_ID
                    AND   A.PARENT_ITEM_ID  = PD1.ITEM_ID
              INNER MERGE JOIN SCM_ITEM_CLASS_M PDC1(NOLOCK)
                    ON    PD1.ITEM_CLASS    = PDC1.CLASS_ID
              INNER MERGE JOIN SCM_ITEM_M PD2(NOLOCK)
                    ON    A.COMPANY_ID      = PD2.COMPANY_ID
                    AND   A.DIVISION_ID     = PD2.DIVISION_ID
                    AND   A.SITE_ID         = PD2.SITE_ID
                    AND   A.CHILD_ITEM_ID   = PD2.ITEM_ID
              INNER MERGE JOIN SCM_ITEM_CLASS_M PDC2(NOLOCK)
                    ON    PD2.ITEM_CLASS    = PDC2.CLASS_ID
        WHERE A.EFF_START_DATE <= DBO.SYSDATE1()
        AND   A.EFF_END_DATE   >= DBO.SYSDATE1()
        AND   A.ACTIVE_FLAG     = 'Y'
        AND   PD1.ACTIVE_FLAG   = 'Y'
        AND   PDC1.USE_FLAG     = 'Y'
        AND   PD2.ACTIVE_FLAG   = 'Y'
        AND   PDC2.USE_FLAG     = 'Y'

        --LOG 생성
        SET @v_table_name = 'FP_BOM_EXPLOSION_INFO'
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

      END
      
      SET @n_loop += 1
      
      -- MODEL 기준 BOM 전개
      BEGIN
      
        SET @n_level = 1

        DELETE FROM FP_BOM_EXPLOSION_COMBINE
        
        INSERT INTO FP_BOM_EXPLOSION_COMBINE
        SELECT DISTINCT
               COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID
             , PARENT_ITEM_ID AS MODEL_ID
             , PARENT_ITEM_ID AS TOP_ITEM_ID
             , PARENT_ITEM_ID
             , CHILD_ITEM_ID
             , KEY_DATE
             , @n_level   AS LEVEL
             , @n_loop    AS loop_no
        FROM   FP_BOM_EXPLOSION_INFO A
        WHERE  PARENT_ITEM_ID IN (
                                  SELECT PARENT_ITEM_ID FROM FP_BOM_EXPLOSION_INFO
                                  EXCEPT
                                  SELECT CHILD_ITEM_ID  FROM FP_BOM_EXPLOSION_INFO
                                 )
        
        --LOG 생성
        SET @v_table_name = 'FP_BOM_EXPLOSION_INFO'
        SET @v_message = ' ' + CONVERT(NVARCHAR, @n_level) + ' - LEVEL : ' + CONVERT(NVARCHAR, @n_row_count)
        SET @n_log_count = @n_log_count + 1
        SET @sysdate = GETDATE()
        EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null
        
        BEGIN
        
          WHILE 1=1
          BEGIN

            INSERT INTO FP_BOM_EXPLOSION_COMBINE
            SELECT DISTINCT
                   B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID
                 , A.MODEL_ID
                 , A.TOP_ITEM_ID
                 , B.PARENT_ITEM_ID
                 , B.CHILD_ITEM_ID
                 , B.KEY_DATE
                 , A.LEVEL + 1
                 , @n_loop    AS loop_no
            FROM   FP_BOM_EXPLOSION_COMBINE A,
                   FP_BOM_EXPLOSION_INFO B
            WHERE  A.CHILD_ITEM_ID = B.PARENT_ITEM_ID
            AND    A.LEVEL = @n_level          
            
            SET @n_row_count = @@ROWCOUNT
            
            SET @n_level += 1

            IF @n_row_count = 0
              BREAK
          
            --LOG 생성
            SET @v_table_name = 'FP_BOM_EXPLOSION_INFO'
            SET @v_message = ' ' + CONVERT(NVARCHAR, @n_level) + ' - LEVEL : ' + CONVERT(NVARCHAR, @n_row_count)
            SET @n_log_count = @n_log_count + 1
            SET @sysdate = GETDATE()
            EXECUTE pr_log_process  null, @v_master_id, @v_plan_id, @v_proc_name, @v_table_name, 'SELECT', @n_log_count, null, @v_message, null

          END
        
        END
      
      END
      

      -- 하위 BOM 을 전개한다.      
      /*
      BEGIN
      
        SET @n_loop = 1

        WHILE 1=1
        BEGIN

          SET @n_loop += 1
        
        END
      
      END
      */

      IF @@TRANCOUNT > 0
        COMMIT WORK 
    END
    
	END TRY

	BEGIN CATCH
		--ROLLBACK

		SET @v_descr = ERROR_MESSAGE()
    SET @sysdate = GETDATE()

		EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'ERROR', null, @v_temp2, null, @v_descr
		commit;
	END CATCH

  SET @n_log_count = @n_log_count + 1
  EXEC PR_LOG_PROCESS @sysdate, @v_master_id, @v_plan_id, @v_proc_name, null, 'END', 999999, null, '############### End of procedure ###############', null

END
