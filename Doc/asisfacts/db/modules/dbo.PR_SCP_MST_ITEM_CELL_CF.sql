

/*
 * Program ID   : PR_SCP_MST_ITEM_CELL_CF
 * Description  : GPLM MQ 환산계수 IF
 * Program History
 * 
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022.04.29   vadabi3        Create	XIF_PLM_BOM_CF_GSCM_IF_R => SCP_MST_ITEM_CELL_CF


exec PR_SCP_MST_ITEM_CELL_CF
select * from SCP_MST_ITEM_CELL_CF
select * from XIF_PLM_BOM_CF_GSCM_IF_R_SN  WHERE TRANSFER_FLAG = 'N'

 */

CREATE PROCEDURE [dbo].[PR_SCP_MST_ITEM_CELL_CF]
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
  DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_MST_ITEM_CELL_CF';
  DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
  DECLARE @n_log_count    INTEGER = 0;
  DECLARE @v_log_message  NVARCHAR(1000);
  DECLARE @v_description  NVARCHAR(500);
  DECLARE @d_event_date   DATETIME;
  DECLARE @v_ifseqno      NVARCHAR(30); 
  DECLARE @n_history_seq  BIGINT;
  DECLARE @n_WORK_CNT  BIGINT;

  ------------------------------------------------------------------------------ 
  -- 시작 LOG
  ------------------------------------------------------------------------------
  SET @v_log_type    = 'START';
  SET @v_log_message = '########## Start of procedure ##########';
  SET @v_description = '';
  SET @d_event_date  = SYSDATETIME();
  SET @n_WORK_CNT = 0;

  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  -- 트랜잭션 (START)
  BEGIN TRANSACTION PR_SCP_ANL_MONTH_END_STOCK_R;

  BEGIN TRY

    BEGIN
    
      -- 인터페이스 테이블 처리 ROW UPDATE
	  
      --------------------------------------------------------------------------------
      -- 1. SCP_MST_ITEM_CELL_CF 전체 삭제 후 신규 입력
      -------------------------------------------------------------------------------- 

   	    UPDATE XIF_PLM_BOM_CF_GSCM_IF_R_SN 
		SET    PROC_FLAG = 'P'
		      ,PROC_DATE = GETDATE()
		WHERE  ISNULL(PROC_FLAG,'N') = 'N';
     

      --------------------------------------------------------------------------------
      -- 1. IF 처리
      --------------------------------------------------------------------------------        
      BEGIN

			
					MERGE INTO  [dbo].[SCP_MST_ITEM_CELL_CF] A
					USING (
								  
								  SELECT DATA.CELL_SEQ					
										,DATA.LVL						
										,DATA.ITEM_SEQ					
										,DATA.PART_NUMBER				
										,DATA.PART_NAME					
										,DATA.SPEC						
										,DATA.UNIT						
										,DATA.AMOUNT					
										,ISNULL(DATA.TARGET_CELL, '-') AS TARGET_CELL			
										,DATA.CELL_CF					
										,DATA.REVISION					
										,DATA.BOM_MODIFY_DATE			
										,ISNULL(DATA.CELL_TYPE, '-') AS CELL_TYPE			
										,DATA.ATTR01					
										,DATA.ATTR02					
										,DATA.ATTR03					
										,DATA.ATTR04					
										,DATA.IF_SEQ	AS IF_SEQ					
										,@v_batch_user	AS CREATE_USER
										,GETDATE()		AS CREATE_DATE
										,@v_batch_user	AS UPDATE_USER
										,GETDATE()		AS UPDATE_DATE									
								  FROM  
									  (
									  SELECT DISTINCT PART_NUMBER
													, CELL_TYPE
													, TARGET_CELL
													, IF_SEQ
													, ROW_NUMBER() OVER (PARTITION BY PART_NUMBER ORDER BY BOM_MODIFY_DATE DESC, IF_SEQ DESC) AS RankNo
									   FROM [dbo].[XIF_PLM_BOM_CF_GSCM_IF_R_SN]
								      WHERE PROC_FLAG = 'P'
									  ) LIST
							 LEFT JOIN [dbo].[XIF_PLM_BOM_CF_GSCM_IF_R_SN] DATA ON DATA.IF_SEQ = LIST.IF_SEQ
								  WHERE LIST.RankNo = 1
									AND DATA.PROC_FLAG = 'P'

						  ) B
					ON(
							    A.ITEM_ID		= B.PART_NUMBER
							--AND A.TARGET_CELL	= B.TARGET_CELL
							--AND A.CELL_TYPE	    = B.CELL_TYPE
					  )
					WHEN MATCHED THEN
						 UPDATE SET 
								 CELL_SEQ				=	   		B.CELL_SEQ				
								,LVL					=	   		B.LVL					
								,ITEM_SEQ				=	   		B.ITEM_SEQ								
								,ITEM_DESCRIPTION		=	   		B.PART_NAME		
								,ITEM_SPEC				=	   		B.SPEC				
								,UNIT					=	   		B.UNIT					
								,AMOUNT					=			B.AMOUNT					
								,TARGET_CELL			=	   		B.TARGET_CELL			
								,CELL_CF				=	   		B.CELL_CF				
								,REVISION				=	   		B.REVISION				
								,BOM_MODIFY_DATE		=			B.BOM_MODIFY_DATE		
								,CELL_TYPE				=	   		B.CELL_TYPE				
								,ATTRIBUTE1				=	   		B.ATTR01				
								,ATTRIBUTE2				=	   		B.ATTR02				
								,ATTRIBUTE3				=			B.ATTR03				
								,ATTRIBUTE4				=			B.ATTR04				
								,ATTRIBUTE5				=			B.IF_SEQ				
								,CREATED_BY				=	   		B.CREATE_USER	
								,CREATION_DATE			=	   		B.CREATE_DATE	
								,LAST_UPDATED_BY	    =	   		B.UPDATE_USER		   
								,LAST_UPDATE_DATE	    =			B.UPDATE_DATE	

					WHEN NOT MATCHED THEN

						 INSERT					   
						 (
							[CELL_SEQ]
						   ,[LVL]
						   ,[ITEM_SEQ]
						   ,[ITEM_ID]
						   ,[ITEM_DESCRIPTION]
						   ,[ITEM_SPEC]
						   ,[UNIT]
						   ,[AMOUNT]
						   ,[TARGET_CELL]
						   ,[CELL_CF]
						   ,[REVISION]
						   ,[BOM_MODIFY_DATE]
						   ,[CELL_TYPE]
						   ,[ATTRIBUTE1]
						   ,[ATTRIBUTE2]
						   ,[ATTRIBUTE3]
						   ,[ATTRIBUTE4]
						   ,[ATTRIBUTE5]
						   ,[CREATED_BY]
						   ,[CREATION_DATE]
						   ,[LAST_UPDATED_BY]
						   ,[LAST_UPDATE_DATE]
					    )
						 VALUES
						(	
							    B.CELL_SEQ							
							   ,B.LVL								
							   ,B.ITEM_SEQ							
							   ,B.PART_NUMBER						
							   ,B.PART_NAME							
							   ,B.SPEC								
							   ,B.UNIT								
							   ,B.AMOUNT							
							   ,B.TARGET_CELL						
							   ,B.CELL_CF							
							   ,B.REVISION							
							   ,B.BOM_MODIFY_DATE					
							   ,B.CELL_TYPE							
							   ,B.ATTR01							
							   ,B.ATTR02							
							   ,B.ATTR03							
							   ,B.ATTR04							
							   ,B.IF_SEQ							
							   ,B.CREATE_USER						
							   ,B.CREATE_DATE						
							   ,B.UPDATE_USER		   				
							   ,B.UPDATE_DATE	  				
						);											


          -----------------------------------------------------------
          -- 전송 LOG
          -----------------------------------------------------------
          SET @n_log_count = @@ROWCOUNT;
          SET @v_log_type = 'GPLM MQ IF';
          SET @v_log_message = 'XIF_PLM_BOM_CF_GSCM_IF_R 전송';
          SET @v_description = 'XIF_PLM_BOM_CF_GSCM_IF_R => SCP_MST_ITEM_CELL_CF';
          SET @d_event_date = SYSDATETIME();
          EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
          -----------------------------------------------------------

      END

	-----------------------------------------------------------
	-- 전송 후 결과 처리
	-----------------------------------------------------------
      -- 인터페이스 테이블 처리 ROW UPDATE
      UPDATE XIF_PLM_BOM_CF_GSCM_IF_R_SN
      SET    PROC_FLAG = 'Y'
	       , PROC_MSG              = concat(PROC_MSG, N'이관대상 ', CONVERT(CHAR(23), getdate(), 21))
      WHERE  IF_SEQ in (SELECT ATTRIBUTE5 FROM  [dbo].[SCP_MST_ITEM_CELL_CF]) 
	    AND  PROC_FLAG = 'P';


	  -- 인터페이스 테이블 처리 대상 아닌 경우 ROW UPDATE
      UPDATE XIF_PLM_BOM_CF_GSCM_IF_R_SN
      SET    PROC_FLAG = 'S'
	       , PROC_MSG              = concat(PROC_MSG, N'이관대상 제외 ', CONVERT(CHAR(23), getdate(), 21))
      WHERE  PROC_FLAG = 'P';


		-----------------------------------------------------------
		-- 결과 처리 LOG
		-----------------------------------------------------------
		SET @n_log_count = @@ROWCOUNT;
		SET @v_log_type = 'GPLM MQ IF Result';
		SET @v_log_message = 'XIF_PLM_BOM_CF_GSCM_IF_R PROC_FLAG';
		SET @v_description = 'XIF_PLM_BOM_CF_GSCM_IF_R PROC_FLAG = Y';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		-----------------------------------------------------------

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
    -- ERROR LOG
    SET @v_log_type    = 'ERROR';
    SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
    SET @v_description = 'ERROR_LINE : '+ CAST(ERROR_LINE() AS nvarchar(10));
    SET @d_event_date  = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
  END CATCH;

  -- 종료 LOG
  SET @v_log_type    = 'END';
  SET @v_log_message = '########## END of procedure ##########';
  SET @v_description = '';
  SET @d_event_date  = SYSDATETIME();
  EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

END;
