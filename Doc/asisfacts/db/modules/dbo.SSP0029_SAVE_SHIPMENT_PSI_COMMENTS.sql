

/*
 * Program ID   : SSP0029_SAVE_SHIPMENT_PSI_COMMENTS
 * Description  : Shipment PSI COMMENTS 저장
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2022.09.01   SSP Pjt. 	    Created.
 *
 ex) 
 */

CREATE PROCEDURE [dbo].[SSP0029_SAVE_SHIPMENT_PSI_COMMENTS]
	 @p_change_flag			 CHAR(1)					--'Y', 'N'
	,@p_division_id          NVARCHAR(MAX)
	,@p_from_site            NVARCHAR(MAX)
	,@p_item_id              NVARCHAR(MAX)
	,@p_plan_start_yyyymmdd  NVARCHAR(MAX)
	,@p_yyyymmdd             NVARCHAR(MAX)
	,@p_plan_type            NVARCHAR(MAX)
	,@p_seq		          NVARCHAR(MAX)
	,@p_measure              NVARCHAR(MAX)
	,@p_qty                  NVARCHAR(MAX)
	,@p_prodQty              NVARCHAR(MAX)
	,@p_comments			NVARCHAR(MAX)
	,@p_user_id              NVARCHAR(MAX)
AS

BEGIN

	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	DECLARE @v_last_update_date     datetime;
	SET @v_last_update_date    = SYSDATETIME();
	
	DECLARE @v_comments_cnt	INTEGER;
	SET @v_comments_cnt = 0;					--기존 Comments 유무 Count

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = '[SSP0029_SAVE_SHIPMENT_PSI_COMMENTS]';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';

	-- 트렌젝션 시작 : 
	BEGIN TRANSACTION PSI_CMT;

	BEGIN TRY
	BEGIN	
		
		-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		IF @p_change_flag = 'Y'
		BEGIN
			
			--////////////////////////////
			--//PSI 변경 내용 저장 Start//
			--////////////////////////////

			-- [C20200506-000210] USER_ADD_QTY 추가  
			-- Change Qty + Prod Qty로 변경  
			--  Change Qty 음수 가능
			UPDATE SSP_ANL_SHIP_PLAN_40                       
			SET  QTY				 = CONVERT(INT,CEILING(@p_qty))  + CONVERT(INT,CEILING(@p_prodQty))
				,LAST_UPDATED_BY     = @p_user_id
				,LAST_UPDATE_DATE    = @v_last_update_date
			WHERE 1 = 1
			AND DIVISION_ID         = @p_division_id
			AND FROM_SITE           = @p_from_site
			AND ITEM_ID             = @p_item_id        
			AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
			AND YYYYMMDD            = @p_yyyymmdd
			AND PLAN_TYPE           = @p_plan_type          
			AND SEQ                 = @p_seq                
			AND MEASURE             = @p_measure;


			-- [C20200506-000210] USER_ADD_QTY 추가
			INSERT INTO SSP_ANL_SHIP_PLAN_40_WH_IN_H
			(
				HISTORY_SEQ,			
				DIVISION_ID,			PLAN_START_YYYYMMDD,				PLAN_TYPE,			SEQ,
				ITEM_ID,				FROM_SITE,						TO_SITE,				MEASURE,
				YYYYMMDD,				USER_ADD_QTY,						BOD_ID,				QTY,					ROUTE_ID,
				INCOTERMS,			TRANSPORT_MODE,					BIZ_TYPE,				PROJECT_CODE,
				FCST_TYPE,			FCST_ETD_DATE,						FCST_ETA_DATE,			ETD_DATE,
				ETA_DATE,				CONFIRM_FLAG,						CONFIRM_ID,			CREATED_BY,
				CREATION_DATE,			LAST_UPDATED_BY,					LAST_UPDATE_DATE,		ELECTRODE_YN,
				ELECTRODE_TYPE,			ORIGIN_FROM_DIVISION_ID,			ORIGIN_TO_DIVISION_ID,	HISTORY_CREATION_DATE
			)
			SELECT
				NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_PLAN_40_WH_IN_H AS HISTORY_SEQ,					
				DIVISION_ID,			PLAN_START_YYYYMMDD,				PLAN_TYPE,			SEQ,
				ITEM_ID,				FROM_SITE,						TO_SITE,				MEASURE,
				YYYYMMDD,				@p_qty,							BOD_ID,				QTY,					ROUTE_ID,
				INCOTERMS,			TRANSPORT_MODE,					BIZ_TYPE,				PROJECT_CODE,
				FCST_TYPE,			FCST_ETD_DATE,						FCST_ETA_DATE,			ETD_DATE,
				ETA_DATE,				CONFIRM_FLAG,						CONFIRM_ID,			CREATED_BY,
				CREATION_DATE,			LAST_UPDATED_BY,					LAST_UPDATE_DATE,		ELECTRODE_YN,
				ELECTRODE_TYPE,			ORIGIN_FROM_DIVISION_ID,			ORIGIN_TO_DIVISION_ID,	GETDATE() AS HISTORY_CREATION_DATE
			FROM dbo.SSP_ANL_SHIP_PLAN_40 WITH(NOLOCK)
			WHERE 1 = 1
			AND DIVISION_ID         = @p_division_id
			AND FROM_SITE           = @p_from_site
			AND ITEM_ID             = @p_item_id        
			AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
			AND YYYYMMDD            = @p_yyyymmdd
			AND PLAN_TYPE           = @p_plan_type          
			AND SEQ                 = @p_seq                
			AND MEASURE             = @p_measure;
			--//PSI 변경 내용 저장 End///////////////////////////////////////////////////////////////////////////////////////////////////
		END;

		SELECT 
			@v_comments_cnt = ISNULL(COUNT(*), 0)
		FROM SSP_ANL_SHIP_PLAN_40_WH_IN_CMT WITH(NOLOCK)
		WHERE 1 = 1
		AND DIVISION_ID         = @p_division_id
		AND FROM_SITE           = @p_from_site
		AND ITEM_ID             = @p_item_id  
		AND YYYYMMDD            = @p_yyyymmdd;

		--/////////////////////////////////
		--//COMMENTS 변경 내용 저장 Start//
		--/////////////////////////////////
		IF @v_comments_cnt > 0 
		BEGIN
		--//COMMENTS UPDATE
			UPDATE SSP_ANL_SHIP_PLAN_40_WH_IN_CMT
			SET COMMENTS			 = @p_comments
				,USER_ADD_QTY		 = @p_qty
				,LAST_UPDATED_BY     = @p_user_id
				,LAST_UPDATE_DATE    = @v_last_update_date
			WHERE 1 = 1
			AND DIVISION_ID         = @p_division_id
			AND FROM_SITE           = @p_from_site
			AND ITEM_ID             = @p_item_id  
			AND YYYYMMDD            = @p_yyyymmdd;
		END
		ELSE
		BEGIN
		--//COMMENTS INSERT
			INSERT INTO SSP_ANL_SHIP_PLAN_40_WH_IN_CMT
			(
				DIVISION_ID,		FROM_SITE,				ITEM_ID,			YYYYMMDD,		USER_ADD_QTY,
				COMMENTS,			CREATION_DATE,			LAST_UPDATED_BY,	LAST_UPDATE_DATE
			)
			VALUES
			(
				@p_division_id,		@p_from_site,			@p_item_id,			@p_yyyymmdd,		@p_qty,
				@p_comments,		@v_last_update_date,	@p_user_id,			@v_last_update_date
			);
		END;

		--//HISTORY INSERT
		INSERT INTO SSP_ANL_SHIP_PLAN_40_WH_IN_CMT_H
		(
			HISTORY_SEQ,
			DIVISION_ID,			FROM_SITE,				ITEM_ID,			YYYYMMDD,		USER_ADD_QTY,
			COMMENTS,				CREATION_DATE,			LAST_UPDATED_BY,	LAST_UPDATE_DATE,
			HISTORY_CREATION_DATE
		)
		SELECT
			NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_PLAN_40_WH_IN_CMT_H AS HISTORY_SEQ,
			DIVISION_ID,			FROM_SITE,				ITEM_ID,			YYYYMMDD,		USER_ADD_QTY,
			COMMENTS,				CREATION_DATE,			LAST_UPDATED_BY,	LAST_UPDATE_DATE,
			GETDATE() AS HISTORY_CREATION_DATE
		FROM SSP_ANL_SHIP_PLAN_40_WH_IN_CMT  WITH(NOLOCK)
		WHERE 1 = 1
		AND DIVISION_ID         = @p_division_id
		AND FROM_SITE           = @p_from_site
		AND ITEM_ID             = @p_item_id  
		AND YYYYMMDD            = @p_yyyymmdd;
		--//COMMENTS 내용 저장 End///////////////////////////////////////////////////////////////////////////////////////////////////

		IF @@TRANCOUNT > 0
		BEGIN
			COMMIT TRANSACTION PSI_CMT;
		END;

		--중첩 TRANSACTION
		--EXEC PR_SSP_ANL_SHIP_UPDATE_BOH_VAL_40 @p_division_id, @p_item_id, @p_from_site, @p_yyyymmdd, @p_user_id;

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH_CALL_TRAN @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		-- 결과코드 반환
		SELECT 'S' AS result_code;
		SET XACT_ABORT OFF;
		

	END;
	END TRY
	
	BEGIN CATCH 
	BEGIN
		IF @@TRANCOUNT > 0
		BEGIN
			ROLLBACK TRANSACTION PSI_CMT;--입력 데이타 롤백 처리
		END;
					
		INSERT INTO scm_sys_log_batch (program_name,log_type,log_count,log_message,description,event_date,creation_date,created_by,last_update_date,last_updated_by)
		VALUES (ERROR_PROCEDURE(),'ERROR',NULL,ERROR_MESSAGE(),NULL,SYSDATETIME(),SYSDATETIME(),ERROR_PROCEDURE(),SYSDATETIME(),ERROR_PROCEDURE());

		-- error코드, errror 메시지 반환
		SELECT 'F' AS result_code;

		IF( @v_err_code IS NULL OR @v_err_code ='')
			SET @v_err_code= ERROR_NUMBER() ;
		IF( @v_err_message IS NULL OR @v_err_message ='') 
			SET @v_err_message=  ERROR_MESSAGE();
						
		/* 에러 메시지, 에러 데이터  반환   */	
		SELECT  @v_err_code			AS err_code
				,@v_err_message		AS err_message; 
	END;
	END CATCH;
	
END


