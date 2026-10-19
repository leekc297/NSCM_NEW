
/*
 * Program ID   : PR_SCM_DNM_STOCK_LOT_CONTROL
 * Description  :  Pack 보류 재고
 * Program History
 * 
 *===================================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================================
 * 2022.11.16   vadabi3        Initial Release PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 : XIF_QMS_LOT_CONTROL_R => SCM_DNM_STOCK_LOT_CONTROL
 * 2022.11.22   vadabi3        Batch정책	1, KEY = Inspection ID 기준 전체 IF 이므로 Inspection ID 기준으로 Delete / Insert 처리
                                            2, DIVISION 매핑은 ITEM 정보로 찾음
											3. CUTOFF DAY = 처리일자
 * 
 --------------------------------------------------------------------------------------------------------------------
 EXEC PR_SCM_DNM_STOCK_LOT_CONTROL
 */
CREATE PROCEDURE [dbo].[PR_SCM_DNM_STOCK_LOT_CONTROL]
AS

  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON; 

    -- LOG 용 변수 설정
	DECLARE @SummaryOfChanges TABLE(CHANGE VARCHAR(20), IF_SEQ NVARCHAR(50) );
    DECLARE @v_batch_user   NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_DNM_STOCK_LOT_CONTROL';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @v_ifseqno      NVARCHAR(30); 
	DECLARE @n_success_cnt	BIGINT;
	DECLARE @n_fail_cnt  	BIGINT;
	DECLARE @batch_no       NVARCHAR(20)
	DECLARE @if_seq nvarchar(max);
	DECLARE @v_cutoff_date  NVARCHAR(8); 
	DECLARE @v_pre_cutoff_date  NVARCHAR(8); 
	
	SET @n_success_cnt	= 0 ;
	SET @n_fail_cnt 	= 0 ; 	
	SET @v_cutoff_date     = CONVERT(CHAR(8), GETDATE()-1, 112) ;
	SET @v_pre_cutoff_date = CONVERT(CHAR(8), DATEADD(DD, -1, CONVERT(DATE, @v_cutoff_date)), 112) ;

	-- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN

	  --------------------------------------------------------------------------------
      -- 1. @batch_no / ATTR_10
      -------------------------------------------------------------------------------- 
	  select @batch_no = FORMAT(getdate(), 'yyyyMMddHHmmss')	  

	  -- 처리 비대상 정보 
   	  UPDATE XIF_QMS_LOT_CONTROL_R_SN
	  SET    PROC_FLAG = 'Y'
		   , PROC_MSG  = concat(PROC_MSG, N'처리 비대상 ', CONVERT(CHAR(23), getdate(), 21))
		   ,PROC_DATE = GETDATE()
	  WHERE INSP_MCLASS_CODE      NOT IN ('ECMM003')
	  AND   ISNULL(PROC_FLAG,'N') = 'N';

      --------------------------------------------------------------------------------
      -- 1. XIF_QMS_LOT_CONTROL_R_SN 배치 대상 count
      --------------------------------------------------------------------------------  
   	    UPDATE XIF_QMS_LOT_CONTROL_R_SN
		SET    PROC_FLAG = 'P'
		      ,PROC_DATE = GETDATE()
			  ,ATTR_10 = @batch_no
		WHERE INSP_MCLASS_CODE      = 'ECMM003'
		AND   ISNULL(PROC_FLAG,'N') = 'N';

		SET @n_log_count = @@ROWCOUNT;
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'STEP1', @n_log_count, N'배치 대상 Count ( PROC_FLAG : N) ', @v_description, @d_event_date;

      -------------------------------------------------------------------------------------------------------------
      -- 2. SCM_DNM_STOCK_LOT_CONTROL  :당일 정보가 처음 생성되는 경우 전일 정보를 당일 정보로 Copy
	  --    당일 정보 존재 시 Skip
      -------------------------------------------------------------------------------------------------------------
	  SET @n_log_count = 0;

	  SELECT @n_log_count = COUNT(*) 
		FROM SCM_DNM_STOCK_LOT_CONTROL WITH(NOLOCK)
	   WHERE CUTOFF_DATE = @v_cutoff_date

	  SELECT @v_pre_cutoff_date = MAX(CUTOFF_DATE)
		FROM SCM_DNM_STOCK_LOT_CONTROL WITH(NOLOCK)
	   WHERE CUTOFF_DATE <  @v_cutoff_date
	     AND CUTOFF_DATE >= CONVERT(CHAR(8), GETDATE()-3, 112);	   

      -- CUTOFF_DATE = @v_cutoff_date 에 정보 존재하면 Copy는 Skip 함
	  -- 없으면 전일 정보를 Copy하여 당일 정보로 Insert함
	  IF (@n_log_count < 1)
		BEGIN
            INSERT INTO SCM_DNM_STOCK_LOT_CONTROL
              (
                DIVISION_ID, SCM_SITE_ID, CUTOFF_DATE, ITEM_ID, ORG_ITEM_ID, QTY
              , RELEASE_DATE, HOLD_START_DATE, HOLD_END_DATE, CHANGE_REQUEST_USER
              , DIR, LOT_ID, PLANT_ID, SHOP_ID, LINE_ID, APPLY_PSN_ID, APPLY_DATE
              , INSPECTION_ID, NOTE, INSP_LCLASS_CODE, INSP_MCLASS_CODE, RISK_RANGE_FLAG
              , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
              , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
              , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
              )
            SELECT DIVISION_ID, SCM_SITE_ID, @v_cutoff_date AS CUTOFF_DATE, ITEM_ID, ORG_ITEM_ID, QTY
                 , RELEASE_DATE, HOLD_START_DATE, HOLD_END_DATE, CHANGE_REQUEST_USER
                 , DIR, LOT_ID, PLANT_ID, SHOP_ID, LINE_ID, APPLY_PSN_ID, APPLY_DATE
                 , INSPECTION_ID, NOTE, INSP_LCLASS_CODE, INSP_MCLASS_CODE, RISK_RANGE_FLAG
                 , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                 , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
                 , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
			FROM   SCM_DNM_STOCK_LOT_CONTROL WITH(NOLOCK)
			WHERE  CUTOFF_DATE  = @v_pre_cutoff_date
			AND    DIR          = 'HOLD'
			
		    SET @n_log_count = @@ROWCOUNT;
		    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'STEP2', @n_log_count, N'SCM_DNM_STOCK_LOT_CONTROL > HOLD Copy ', @v_description, @d_event_date;
		END

      -------------------------------------------------------------------------------------------------------------
      -- 3. SCM_DNM_STOCK_LOT_CONTROL 에서 HOLD 
	  --> CUTOFF_DATE 배치시행일로 생성
	  --> Inspection ID 기준 전체 IF 이므로 Inspection ID 기준으로 Delete / Insert 처리
      -------------------------------------------------------------------------------------------------------------
	    SET @n_log_count = 0;

	    DELETE SCM_DNM_STOCK_LOT_CONTROL
		WHERE  INSPECTION_ID IN (SELECT DISTINCT INSPECTION_ID
		                         FROM   XIF_QMS_LOT_CONTROL_R_SN X WITH(NOLOCK)
                                 WHERE  1=1
						         AND    PROC_FLAG = 'P'
								)
		AND    CUTOFF_DATE = @v_cutoff_date

		--------------------------------------------------------------------------------
		-- 3-1. CURSOR Start
		-------------------------------------------------------------------------------- 
				--IF OBJECT_ID (N'CURSOR_CONTROL', N'U') IS NOT NULL 
					--DEALLOCATE CURSOR_CONTROL;
			BEGIN TRY
				
				DECLARE CURSOR_CONTROL CURSOR FAST_FORWARD FOR

				    -- [PLANT_ID, PROD_ID, INSPECTION_ID] 기준으로 가장 최신 데이터 적용
					SELECT IF_SEQ
					FROM
						(
						SELECT X.IF_SEQ
							 , ROW_NUMBER() OVER (PARTITION BY PLANT_ID, PROD_ID, INSPECTION_ID ORDER BY IF_SEQ DESC) AS RankNo
						  FROM XIF_QMS_LOT_CONTROL_R_SN X WITH(NOLOCK)
						 WHERE 1=1
						   AND PROC_FLAG = 'P'
						) data
					where RankNo = 1
					  ORDER BY IF_SEQ

				
				OPEN CURSOR_CONTROL;
				FETCH NEXT FROM CURSOR_CONTROL INTO @if_seq
				WHILE @@FETCH_STATUS = 0   
				BEGIN
				--###########################################################################################################################################

				  -------------------------------------------------------------------------------
				  -- 3-1. MERGE INTO SCM_DNM_STOCK_LOT_CONTROL
				  -------------------------------------------------------------------------------- 
                  INSERT INTO SCM_DNM_STOCK_LOT_CONTROL
                  (
                    DIVISION_ID, SCM_SITE_ID, CUTOFF_DATE, ITEM_ID, ORG_ITEM_ID, QTY
                  , RELEASE_DATE, HOLD_START_DATE, HOLD_END_DATE, CHANGE_REQUEST_USER
                  , DIR, LOT_ID, PLANT_ID, SHOP_ID, LINE_ID, APPLY_PSN_ID, APPLY_DATE
                  , INSPECTION_ID, NOTE, INSP_LCLASS_CODE, INSP_MCLASS_CODE, RISK_RANGE_FLAG
                  , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                  , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
                  , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                 ) 
				  SELECT ISNULL(I.division_id, '-') AS division_id
                       , ISNULL(s.scm_site_id, '-') AS scm_site_id
                       --, CONVERT(CHAR(8), IF_RCV_DATE, 112) AS CUTOFF_DATE
                       , @v_cutoff_date AS CUTOFF_DATE 
                       , DBO.FN_GET_PACKER_PLAN_ITEM_ID(S.DIVISION_ID, X.PROD_ID) AS ITEM_ID
                       , X.PROD_ID AS org_item_id
                       , ISNULL(CONVERT(NUMERIC, X.ATTR_01), 0.0)        AS QTY
                       , CONVERT(CHAR(8), CONVERT(DATE, X.ATTR_02), 112) AS RELEASE_DATE
                       , CONVERT(CHAR(8), CONVERT(DATE, X.ATTR_03), 112) AS HOLD_START_DATE
                       , CONVERT(CHAR(8), CONVERT(DATE, X.ATTR_04), 112) AS HOLD_END_DATE
                       , X.ATTR_05                                       AS CHANGE_REQUEST_USER
                       , X.DIR, X.LOT_ID, X.PLANT_ID, X.SHOP_ID, X.LINE_ID, X.APPLY_PSN_ID, X.APPLY_DATE
                       , X.INSPECTION_ID, X.NOTE, X.INSP_LCLASS_CODE, X.INSP_MCLASS_CODE, X.RISK_RANGE_FLAG
                       , @v_batch_user AS CREATED_BY, GETDATE() AS CREATION_DATE, @v_batch_user AS LAST_UPDATED_BY, GETDATE() AS LAST_UPDATE_DATE
                       , NULL AS ATTRIBUTE1, NULL AS ATTRIBUTE2, NULL AS ATTRIBUTE3, NULL AS ATTRIBUTE4, NULL AS ATTRIBUTE5
                       , NULL AS ATTRIBUTE6, NULL AS ATTRIBUTE7, NULL AS ATTRIBUTE8, NULL AS ATTRIBUTE9
                       , X.IF_SEQ AS ATTRIBUTE10
                  FROM   XIF_QMS_LOT_CONTROL_R_SN X
                  LEFT JOIN (SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP_ID FROM SCM_MST_FINAL_ITEM_ORIGIN_DIV_V WITH(NOLOCK)) I ON  X.PROD_ID = I.ITEM_ID
                  LEFT JOIN SCM_MST_SITE S WITH(NOLOCK)
                  ON  I.DIVISION_ID        = S.DIVISION_ID
                  AND X.PLANT_ID           = S.PLANT_ID
                  AND S.OPERATION_GROUP    = 'P' -- PACK PLANT SITE로 처리
                  AND S.OSP_YN             = 'Y' -- 외주만 대상
                  AND S.VALID_YN           = 'Y'
                  WHERE 1 = 1
                  AND X.IF_SEQ  = @if_seq
                  AND PROC_FLAG = 'P'
                  --OUTPUT $action, B.IF_SEQ INTO @SummaryOfChanges;
			
                  --------------------------------------------------------------------------------
                  -- 3-2.  배치 성공 처라
                  -------------------------------------------------------------------------------- 
                  UPDATE XIF_QMS_LOT_CONTROL_R_SN 
                  SET    PROC_FLAG = 'Y' 
                  WHERE  IF_SEQ    = @IF_SEQ
                  AND    PROC_FLAG = 'P';
		   
		          SET @n_log_count = @n_log_count + @@ROWCOUNT;

                  FETCH NEXT FROM CURSOR_CONTROL INTO @IF_SEQ;
				END

				CLOSE CURSOR_CONTROL;  
				DEALLOCATE CURSOR_CONTROL;

		END TRY
		BEGIN CATCH
			IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'CURSOR_CONTROL')
			BEGIN
				CLOSE CURSOR_CONTROL
				DEALLOCATE CURSOR_CONTROL
			END
		END CATCH
			
		--------------------------------------------------------------------------------
		-- 3-2.  처리 한 row 마킹
		-------------------------------------------------------------------------------- 
		select * from @SummaryOfChanges;

        UPDATE [dbo].[XIF_QMS_LOT_CONTROL_R_SN]
        SET    proc_flag = 'S' 
             , PROC_MSG  = concat(PROC_MSG, N'이관대상 제외 ', CONVERT(CHAR(23), getdate(), 21))
             , PROC_DATE = SYSDATETIME()
        WHERE  proc_flag = 'P'; 

		-----------------------------------------------------------
		-- History LOG
		-----------------------------------------------------------
        SET @v_log_type = 'HISTORY';
        SET @v_description = '@n_history_seq' +':'+ CAST(@n_success_cnt AS nvarchar(100));
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, 'Insert Count', @n_log_count, @d_event_date;

        IF @@TRANCOUNT > 0
		  BEGIN
            COMMIT WORK;
		  END;

      END
    END TRY

    BEGIN CATCH
	  IF @@TRANCOUNT > 0
		  BEGIN
            ROLLBACK;
		  END;
		-----------------------------------------------------------
		-- Error LOG
		-----------------------------------------------------------
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : '+ CAST(ERROR_LINE() AS nvarchar(10));;
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_fail_cnt, @v_log_message, @v_description, @d_event_date;
    END CATCH;

	-----------------------------------------------------------
	-- 종료 LOG
	-----------------------------------------------------------
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;
