

/*
 * Program ID   : PR_SCP_MST_NO_USE_3M
 * Description  : MRP NO USE 3M 데이터 이관
 * Program History
 * 
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022.07.27   vadabi3        Create	XIF_MRP_NO_USE_3M_OUT_IF => SCP_MST_NO_USE_3M
 * 2022.07.27   vadabi3        Modify	SCP_MST_NO_USE_3M 전체 삭제 후 새로 입력하는 방식 (=PI 요청)
 ----------------------------------------------------------------------------------------------------
  EXEC PR_SCP_MST_NO_USE_3M
 */

CREATE PROCEDURE [dbo].[PR_SCP_MST_NO_USE_3M]
AS
BEGIN
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
  SET NOCOUNT ON; 
  SET XACT_ABORT ON;

  DECLARE @v_opdv_cd      NVARCHAR(30); 
  DECLARE @v_yrqt         NVARCHAR(30); 

  ------------------------------------------------------------------------------
  -- LOG 용 변수 설정
  ------------------------------------------------------------------------------
  DECLARE @v_batch_user   NVARCHAR(150) = 'scm_batch';
  DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_MST_NO_USE_3M';
  DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
  DECLARE @n_log_count    INTEGER = 0;
  DECLARE @n_log_count_insert    INTEGER = 0;
  DECLARE @n_log_count_update    INTEGER = 0;
  DECLARE @v_log_message  NVARCHAR(1000);
  DECLARE @v_description  NVARCHAR(500);
  DECLARE @d_event_date   DATETIME;
  DECLARE @v_ifseqno      NVARCHAR(30); 
  DECLARE @n_history_seq  BIGINT;
  DECLARE @n_WORK_CNT  BIGINT;
  DECLARE @n_success_cnt	BIGINT;
  DECLARE @n_fail_cnt  	BIGINT;
  SET @n_success_cnt	= 0 ;
  SET @n_fail_cnt 	= 0 ; 	


  ------------------------------------------------------------------------------ 
  -- 시작 LOG
  ------------------------------------------------------------------------------
  SET @v_log_type    = 'START';
  SET @v_log_message = '########## Start of procedure ##########';
  SET @v_description = '';
  SET @d_event_date  = SYSDATETIME();
  SET @n_WORK_CNT = 0;
  DECLARE @SummaryOfChanges TABLE(CHANGE VARCHAR(20), IF_SEQ NVARCHAR(50) );

  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  -- 트랜잭션 (START)
  BEGIN TRANSACTION PR_SCP_MST_NO_USE_3M_R;

  BEGIN TRY

    BEGIN
    
      -- 인터페이스 테이블 처리 ROW UPDATE
      --------------------------------------------------------------------------------
      -- 1. XIF_MRP_NO_USE_3M_OUT_IF_R_SN 배치 대상 체크
      -------------------------------------------------------------------------------- 
		SELECT @n_log_count = COUNT(*) FROM XIF_MRP_NO_USE_3M_OUT_IF_R_SN WHERE  ISNULL(PROC_FLAG,'N') = 'N';
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'STEP1', @n_log_count, N'배치 대상 Count ( PROC_FLAG : N => P) ', @v_description, @d_event_date;

   	    UPDATE XIF_MRP_NO_USE_3M_OUT_IF_R_SN 
		SET    PROC_FLAG = 'P'
		      ,PROC_DATE = GETDATE()
		WHERE  ISNULL(PROC_FLAG,'N') = 'N';

      BEGIN
	  			  --------------------------------------------------------------------------------
				  -- 2. TRUNCATE SCP_MST_NO_USE_3M (전체 데이터 삭제 후 입력)
				  ------------------------------------------------------------------------------
				  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'STEP2', @n_log_count, N'TRUNCATE SCP_MST_NO_USE_3M', @v_description, @d_event_date;
				  TRUNCATE TABLE SCP_MST_NO_USE_3M;    


				  	--------------------------------------------------------------------------------
					-- 3-1. INSERT SCP_MST_NO_USE_3M
					-------------------------------------------------------------------------------- 
					INSERT INTO  [dbo].[SCP_MST_NO_USE_3M] 
					(
							COMPANY_ID		 
						   ,PLANT_ID		 
						   ,OPER_NM		
						   ,MDM_GRP_01_NM   
						   ,MDM_GRP_02_NM	
						   ,ITEM_ID	 
						   ,ITEM_NM		
						   ,STOCK_QTY     	
						   ,CUR_CD		     
						   ,STOCK_AMT		 
						   ,BASE_UOM		
						   ,PIC_NO			
						   ,PIC_NM     	
						   ,ATTRIBUTE1		
						   ,ATTRIBUTE2		
						   ,ATTRIBUTE3		
						   ,ATTRIBUTE4		
						   ,ATTRIBUTE5		
						   ,CREATED_BY		
						   ,CREATION_DATE	
						   ,LAST_UPDATED_BY
						   ,LAST_UPDATE_DATE
					
					)
					SELECT
							     ISNULL(CMPY_ID, '-')  AS CMPY_ID  				
							   , ISNULL(PLANT_CD, '-')  AS PLANT_CD  			
							   ,OPER_NM						
							   ,MDM_GRP_01_NM		
							   ,MDM_GRP_02_NM				
							   , ISNULL(ITEM_CD, '-')  AS ITEM_CD   			
							   ,ITEM_NM						
							   ,STOCK_QTY			
							   ,CUR_CD						
							   ,STOCK_AMT						
							   ,BASE_UOM								
							   , ISNULL(PIC_NO, '-')  AS PIC_NO  			   				
							   ,PIC_NM
							   ,ATTR_01						
							   ,ATTR_02						
							   ,ATTR_03						
							   ,ATTR_04						
							   ,IF_SEQ						
							   ,@v_batch_user			
							   ,SYSDATETIME()			
							   ,@v_batch_user		   			
							   ,SYSDATETIME()					   				
					FROM XIF_MRP_NO_USE_3M_OUT_IF_R_SN 
			       WHERE IF_SEQ IN (	  
									SELECT IF_SEQ
										FROM
										(
											SELECT IF_SEQ 
												, RANK() OVER(PARTITION BY CMPY_ID,PLANT_CD,ITEM_CD ORDER BY IF_SEQ DESC) AS SEQ
											FROM XIF_MRP_NO_USE_3M_OUT_IF_R_SN WITH(NOLOCK)
											WHERE proc_flag = 'P'
										) LIST
									WHERE LIST.SEQ = 1
							)


      END

	-----------------------------------------------------------
	-- 전송 후 결과 처리
	-----------------------------------------------------------
      -- 인터페이스 테이블 처리 ROW UPDATE
      UPDATE XIF_MRP_NO_USE_3M_OUT_IF_R_SN
      SET    PROC_FLAG = 'Y'
	       , PROC_MSG              = concat(PROC_MSG, N'이관대상 ', CONVERT(CHAR(23), getdate(), 21))
      WHERE  IF_SEQ in (SELECT ATTRIBUTE5 FROM  [dbo].[SCP_MST_NO_USE_3M]) 
	    AND  PROC_FLAG = 'P';


	  -- 인터페이스 테이블 처리 대상 아닌 경우 ROW UPDATE
      UPDATE XIF_MRP_NO_USE_3M_OUT_IF_R_SN
      SET    PROC_FLAG = 'S'
	       , PROC_MSG              = concat(PROC_MSG, N'이관대상 제외 ', CONVERT(CHAR(23), getdate(), 21))
      WHERE  PROC_FLAG = 'P';


	-----------------------------------------------------------
	-- 결과 처리 LOG
	-----------------------------------------------------------
    SET @v_log_type = 'HISTORY';
    SET @v_description = '@n_history_seq' +':'+ CAST(@n_success_cnt AS nvarchar(100));
    SET @d_event_date = SYSDATETIME();
	SET @n_log_count = @@ROWCOUNT;
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, 'Insert Count', @n_log_count, @d_event_date;

	SELECT @n_success_cnt = count(*) FROM XIF_MRP_NO_USE_3M_OUT_IF_R_SN WHERE proc_flag = 'Y' AND  PROC_DATE > getdate() - 0.002; -- 3분 이내
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_success_cnt, N'이관대상', @n_success_cnt, @d_event_date;

	SELECT @n_success_cnt = count(*) FROM XIF_MRP_NO_USE_3M_OUT_IF_R_SN WHERE proc_flag = 'S' AND  PROC_DATE > getdate() - 0.002; -- 3분 이내
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_success_cnt, N'이관대상 제외', @n_success_cnt, @d_event_date;

	SELECT @n_success_cnt = count(*) FROM SCP_MST_NO_USE_3M;
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_success_cnt, N'SCP_MST_NO_USE_3M COUNT', @n_success_cnt, @d_event_date;


      IF @@TRANCOUNT > 0
        BEGIN
          COMMIT WORK;
        END;

    END
    --COMMIT TRANSACTION
  END TRY

  BEGIN CATCH
    IF @@TRANCOUNT > 0
      BEGIN
        ROLLBACK;
      END;
    
		-----------------------------------------------------------
		-- ERROR LOG
		-----------------------------------------------------------
		SET @v_log_type    = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : '+ CAST(ERROR_LINE() AS nvarchar(10));
		SET @d_event_date  = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
  END CATCH;

  
	-----------------------------------------------------------
	-- 종료 LOG
	-----------------------------------------------------------
	SET @v_log_type    = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = '';
	SET @d_event_date  = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

END;

