
/*
 * Program ID   : PR_DM_XIF_ERP_NSD0012_S
 * Description  : NERP SAP PO 전송
 * Program History
 *====================================================================================================
 *   Date       In Charge      Description
 *====================================================================================================
 * 2024.11.11	P.C.I			[PJ20228272] NERP 대응
 * ---------------------------------------------------------------------------------------------------
 */

CREATE PROCEDURE [dbo].[PR_DM_XIF_ERP_NSD0012_S]

AS

BEGIN
    SET NOCOUNT ON; 
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET XACT_ABORT ON;
		
    DECLARE @E_TYPE               NVARCHAR(50)  = N'S'; --메시지 유형: S 성공, E 오류
    DECLARE @E_MESSAGE            NVARCHAR(100) = N'SUCCESS';
	

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_XIF_ERP_NSD0012_S';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;


		-- 시작 LOG
		SET @v_log_type    = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date  = SYSDATETIME();

		--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		-- 트랜잭션 (START)
		BEGIN TRANSACTION NSD0012_S;

		DECLARE @XIF_ERP_PR_DETAIL_S AS TABLE(
			[SEND_TIME] [nvarchar](30) NOT NULL,
			[SERI_NO] [nvarchar](30) NOT NULL,
			[REQUEST_NO] [nvarchar](60) NOT NULL,
			[ITEM_SEQ] [int] NOT NULL,
			[DIVISION_ID] [nvarchar](60) NOT NULL,
			[PROJECT_CODE] [nvarchar](100) NOT NULL,
			[SCM_SITE_ID] [nvarchar](60) NOT NULL,
			[ITEM_ID] [nvarchar](100) NOT NULL,
			[DOM_EXP] [nvarchar](6) NOT NULL,
			[FCST_TYPE] [nvarchar](20) NOT NULL,
			[INCOTERMS] [nvarchar](20) NOT NULL,
			[PLANT_SITE_ID] [nvarchar](60) NOT NULL,
			[REQ_YYYYMMDD] [nvarchar](8) NOT NULL,
			[YYYYMMDD] [nvarchar](8) NOT NULL,
			[UOM] [nvarchar](8) NULL,
			[PLAN_QTY] [numeric](30, 10) NULL,
			[STORAGE_ID] [nvarchar](120) NULL,
			[STORAGE_PLANT_ID] [nvarchar](120) NULL,
			[PUCH_MGR] [nvarchar](300) NULL,
			[PUCH_GROUP] [nvarchar](300) NULL,
			[PR_HEADER] [nvarchar](max) NOT NULL,
			[PR_ITEM_DETAIL] [nvarchar](max) NULL,
			[CREATED_BY] [nvarchar](300) NULL,
			[CREATION_DATE] [datetime] NULL,
			[LAST_UPDATED_BY] [nvarchar](300) NULL,
			[LAST_UPDATE_DATE] [datetime] NULL,
			[SSP_TRANSFER_FLAG] [nvarchar](2) NOT NULL,
			[TRANSFER_FLAG] [nvarchar](1) NULL,
			[TRANSFER_DATE] [datetime] NULL
		)


	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	
		-- I/F 테이블에 INSERT 처리
		BEGIN

			UPDATE XIF_ERP_PR_DETAIL_S_SN
			SET    TRANSFER_FLAG = 'P'
			WHERE  TRANSFER_FLAG = 'N'

			INSERT INTO @XIF_ERP_PR_DETAIL_S
					( SEND_TIME
					, SERI_NO
					, REQUEST_NO
					, ITEM_SEQ
					, DIVISION_ID
					, PROJECT_CODE
					, SCM_SITE_ID
					, ITEM_ID
					, DOM_EXP
					, FCST_TYPE
					, INCOTERMS
					, PLANT_SITE_ID
					, REQ_YYYYMMDD
					, YYYYMMDD
					, UOM
					, PLAN_QTY
					, STORAGE_ID
					, STORAGE_PLANT_ID
					, PUCH_MGR
					, PUCH_GROUP
					, PR_HEADER
					, PR_ITEM_DETAIL
					, CREATED_BY
					, CREATION_DATE
					, LAST_UPDATED_BY
					, LAST_UPDATE_DATE
					, SSP_TRANSFER_FLAG
					)
			SELECT SEND_TIME
				 , SERI_NO
				 , REQUEST_NO
				 , ITEM_SEQ
				 , DIVISION_ID
				 , PROJECT_CODE
				 , SCM_SITE_ID
				 , ITEM_ID
				 , DOM_EXP
				 , FCST_TYPE
				 , INCOTERMS
				 , PLANT_SITE_ID
				 , REQ_YYYYMMDD
				 , YYYYMMDD
				 , UOM
				 , PLAN_QTY
				 , STORAGE_ID
				 , STORAGE_PLANT_ID
				 , PUCH_MGR
				 , PUCH_GROUP
				 , PR_HEADER
				 , PR_ITEM_DETAIL
				 , CREATED_BY
				 , CREATION_DATE
				 , LAST_UPDATED_BY
				 , LAST_UPDATE_DATE
				 , SSP_TRANSFER_FLAG
			FROM   XIF_ERP_PR_DETAIL_S_SN WITH(NOLOCK)
			WHERE  TRANSFER_FLAG = 'P' 
			;
			
			-- 전송대상
			SELECT SEND_TIME
				 , SERI_NO
				 , REQUEST_NO
				 , ITEM_SEQ
				 , DIVISION_ID
				 , PROJECT_CODE
				 , SCM_SITE_ID
				 , ITEM_ID
				 , DOM_EXP
				 , FCST_TYPE
				 , INCOTERMS
				 , PLANT_SITE_ID
				 , REQ_YYYYMMDD
				 , YYYYMMDD
				 , UOM
				 , PLAN_QTY
				 , STORAGE_ID
				 , STORAGE_PLANT_ID
				 , PUCH_MGR
				 , PUCH_GROUP
				 , PR_HEADER
				 , PR_ITEM_DETAIL
				 , CREATED_BY
				 , CREATION_DATE
				 , LAST_UPDATED_BY
				 , LAST_UPDATE_DATE
				 , SSP_TRANSFER_FLAG
			FROM   @XIF_ERP_PR_DETAIL_S 
			;

			UPDATE XIF_ERP_PR_DETAIL_S_SN
			SET    TRANSFER_FLAG = 'Y'
			     , TRANSFER_DATE = GETDATE()
			WHERE  TRANSFER_FLAG = 'P'
			;

		END
		
		IF @@ROWCOUNT > 0 
		BEGIN
			-- HISTORY LOG    
			SET @n_log_count   = @@ROWCOUNT;
			SET @v_log_type    = 'TXN';
			SET @v_log_message = 'INSERT INTO @XIF_ERP_PR_DETAIL_S_SN';
			SET @v_description = '';
			SET @d_event_date  = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END

  		-- 트랜잭션 (COMMIT)
        COMMIT WORK;

	--------------------------------------------------------------------------------------------	
		END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	-- 트랜잭션 (END)
	ROLLBACK TRANSACTION NSD0012_S;
	
		SET @E_TYPE = 'E';
		SET @E_MESSAGE = ERROR_MESSAGE();
		
		-- ERROR LOG
		SET @v_log_type    = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : '+ CAST(ERROR_LINE() AS nvarchar(10));
		SET @d_event_date  = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		

	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

	-- 수행결과 성공여부 DISPLAY
	SELECT @E_TYPE AS E_TYPE, @E_MESSAGE AS E_MESSAGE
	
	-- 종료 LOG
	SET @v_log_type    = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = + 'I/F COUNT : ' + CONVERT(VARCHAR(10), @@ROWCOUNT)
	SET @d_event_date  = SYSDATETIME();
	--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;

