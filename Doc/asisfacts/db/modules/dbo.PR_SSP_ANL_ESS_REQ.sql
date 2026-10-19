
/***************************************************************************************************
 * Program ID   : PR_SSP_ANL_ESS_REQ
 * Description  : PLAN ALL
 * OutTable     : 
 * Execute      : EXEC PR_SSP_ANL_ESS_REQ
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 *   20210317   SSP Pjt.       Create
 *   20241001   KHJ            NERP_SSP
****************************************************************************************************/

CREATE PROCEDURE [dbo].[PR_SSP_ANL_ESS_REQ] 
(
	 @p_dm_req_no                NVARCHAR(60)
    ,@p_division_id              NVARCHAR(10)
	,@r_error_msg                NVARCHAR(1000)  OUTPUT 
)
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    --SET XACT_ABORT ON;
    SET ANSI_WARNINGS ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user				NVARCHAR(150)	= N'ssp_batch';  

    DECLARE @v_program_name				NVARCHAR(150)	= N'PR_SSP_ANL_ESS_REQ';
    DECLARE @v_log_type					NVARCHAR(30); 
    DECLARE @n_log_count				INTEGER = 0;
    DECLARE @v_log_message				NVARCHAR(1000);
    DECLARE @v_description				NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id					NVARCHAR(150)	= N'SSP_ANL_ESS_REQ'; -- ▶ 테이블 필수
    DECLARE @d_event_date				DATETIME;

	DECLARE @dm_req_cnt					INT = 0;	
	DECLARE @v_division_id              NVARCHAR(10);
    DECLARE @v_dm_req_no				NVARCHAR(60)	= '';

    DECLARE @v_start_time				DATETIME		= SYSDATETIME();
    DECLARE @v_exec_time				NVARCHAR(10)	= '';

	-- NERP 매핑코드
    DECLARE @v_KR012031 NVARCHAR(20);
	SET @v_KR012031 = dbo.FN_GET_LOOKUP_VALUE('PR_SSP_ANL_ESS_REQ'  ,'KR012031P')

	IF @p_division_id IS NULL
		SET @v_division_id = '82';
    ELSE
   	    SET @v_division_id =  @p_division_id ; 

	IF @p_dm_req_no IS NULL
		RETURN 0;
    ELSE
	BEGIN
   		SET @v_dm_req_no =  @p_dm_req_no ; 

		SELECT @dm_req_cnt = COUNT(*)
		  FROM (
				SELECT REQUEST_NO, ITEM_ID
				  FROM DM_PLN_PR_DETAIL WITH(NOLOCK)
				 WHERE 1 = 1
				   AND REQUEST_NO		= @v_dm_req_no
				 GROUP BY 
				       REQUEST_NO
				      ,ITEM_ID
				HAVING COUNT(*) > 1
			   ) AS C
			   ;

		IF @dm_req_cnt > 0
		BEGIN
 			SET @r_error_msg =  N'Duplicated ITEM. REQUEST NO : ' + @v_dm_req_no;
			RETURN 0;
		END;

		SELECT @dm_req_cnt	= COUNT(ITEM_ID)
		  FROM SSP_ANL_ESS_REQ WITH(NOLOCK)
		 WHERE DM_REQ_NO	= @v_dm_req_no
		;

		IF @dm_req_cnt > 0
		BEGIN
 			SET @r_error_msg =  N'Already requested. REQUEST NO : ' + @v_dm_req_no;
			RETURN 0;
		END;

		SELECT @dm_req_cnt	= COUNT(*)
		  FROM DM_PLN_PR_DETAIL AS A WITH(NOLOCK)
		       LEFT OUTER JOIN SCP_MST_BOD_V AS B WITH(NOLOCK)
			ON B.DIVISION_ID = A.DIVISION_ID
			
--		   AND B.FROM_SITE	 = CASE WHEN A.PLANT_SITE_ID IS NULL OR A.PLANT_SITE_ID = '' THEN 'KR012031-P' ELSE  A.PLANT_SITE_ID END
		   AND B.FROM_SITE	 = CASE WHEN A.PLANT_SITE_ID IS NULL OR A.PLANT_SITE_ID = '' THEN @v_KR012031 ELSE  A.PLANT_SITE_ID END
		   AND B.TO_SITE	 = A.SCM_SITE_ID
		   AND B.INCOTERMS	 = A.INCOTERMS 
		   AND B.BOD_VALID_YN = 'Y'
		 WHERE 1 = 1
		   AND A.REQUEST_NO		= @v_dm_req_no
		   AND B.BOD_ID IS NULL

		IF @dm_req_cnt > 0
		BEGIN
 			SET @r_error_msg =  N'No BOD referenced in SSP. REQUEST NO : ' + @v_dm_req_no;
			RETURN 0;
		END;
	END

	DECLARE @INX		INT	= 0;
    DECLARE @MAX_NUM	INT	= 0;

	DECLARE @TAB   TABLE
	(
	    TID							INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
		[DM_REQ_NO]					[nvarchar](60) NOT NULL,
		[ITEM_SEQ]					[int] NULL,
		[ITEM_ID]					[nvarchar](50) NOT NULL,
		[DIVISION_ID]				[nvarchar](10) NULL,
		[PROJECT_CODE]				[nvarchar](50) NULL,
		[SCM_SITE_ID]				[nvarchar](50) NULL,
		[PLANT_SITE_ID]				[nvarchar](50) NULL,
		[DOM_EXP]					[nvarchar](6) NULL,
		[FCST_TYPE]					[nvarchar](50) NULL,
		[INCOTERMS]					[nvarchar](20) NULL,
		[YYYYMMDD]					[nvarchar](8) NOT NULL,
		[PLAN_QTY]					[numeric](20, 10) NULL,
		[UOM]						[nvarchar](10) NULL,
		[INV_ALLO_QTY]				[numeric](20, 10) NULL,
		[SLOC_ID]					[nvarchar](10) NULL,
		[SLOC_PLANT_ID]				[nvarchar](50) NULL,
		[PUCH_MGR]					[nvarchar](300) NULL,
		[PUCH_GROUP]				[nvarchar](300) NULL,
		[PR_HEADER]					[nvarchar](max) NULL,
		[PR_ITEM_DETAIL]			[nvarchar](max) NULL,
		[DM_REQUESTED_BY]			[nvarchar](50) NULL,
		[DM_REQUEST_DATE]			[datetime] NULL,
		[BOD_ID]					[nvarchar](150) NULL,
		[HOLD_FLAG]					[nvarchar](1) NULL,
		[CONFIRM_ID]				[nvarchar](20) NULL,
		[CREATED_BY]				[nvarchar](50) NULL,
		[CREATION_DATE]				[datetime] NULL,
		[LAST_UPDATED_BY]			[nvarchar](50) NULL,
		[LAST_UPDATE_DATE]			[datetime] NULL,
		[NET_YN]					[nvarchar](1) NULL
	)


    -- 시작 LOG
    SET @v_log_type		= N'START';
    SET @v_log_message	= N'########## Start of procedure ##########';
    SET @v_description	= @v_program_name + ': ' + @v_table_id + N' INSERT LOGIC';  
    SET @d_event_date	= SYSDATETIME();

    EXEC PR_DM_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                              ,@p_log_type      = @v_log_type
                              ,@p_log_count     = @n_log_count 
                              ,@p_log_message   = @v_log_message 
                              ,@p_description   = @v_description 
                              ,@p_event_date    = @d_event_date 
                              ,@p_user_id       = @v_batch_user
                              ;

    BEGIN TRY

		INSERT INTO @TAB (
	           [DM_REQ_NO]			
			  ,[ITEM_SEQ]			
			  ,[ITEM_ID]			
			  ,[DIVISION_ID]		
			  ,[PROJECT_CODE]		
			  ,[SCM_SITE_ID]		
			  ,[PLANT_SITE_ID]		
			  ,[DOM_EXP]			
			  ,[FCST_TYPE]			
			  ,[INCOTERMS]			
			  ,[YYYYMMDD]			
			  ,[PLAN_QTY]			
			  ,[UOM]				
			  ,[INV_ALLO_QTY]		
			  ,[SLOC_ID]			
			  ,[SLOC_PLANT_ID]		
			  ,[PUCH_MGR]			
			  ,[PUCH_GROUP]		
			  ,[PR_HEADER]			
			  ,[PR_ITEM_DETAIL]	
			  ,[DM_REQUESTED_BY]	
			  ,[DM_REQUEST_DATE]	
			  ,[BOD_ID]			
			  ,[HOLD_FLAG]		
			  ,[CONFIRM_ID]		
			  ,[CREATED_BY]		
			  ,[CREATION_DATE]		
			  ,[LAST_UPDATED_BY]	
			  ,[LAST_UPDATE_DATE]
			  )
		SELECT A.REQUEST_NO     AS DM_REQ_NO
			  ,A.ITEM_SEQ
			  ,A.ITEM_ID
			  ,A.DIVISION_ID
			  ,A.PROJECT_CODE
			  ,A.SCM_SITE_ID
--			  ,CASE WHEN A.PLANT_SITE_ID IS NULL OR A.PLANT_SITE_ID = '' THEN 'KR012031-P' ELSE  A.PLANT_SITE_ID END
			  ,CASE WHEN A.PLANT_SITE_ID IS NULL OR A.PLANT_SITE_ID = '' THEN @v_KR012031 ELSE  A.PLANT_SITE_ID END
			  ,A.DOM_EXP
			  ,A.FCST_TYPE
			  ,A.INCOTERMS
			  ,A.YYYYMMDD
			  ,A.PLAN_QTY
			  ,A.UOM
			  ,0					AS INV_ALLO_QTY
			  ,A.STORAGE_ID			AS SLOC_ID
			  ,A.STORAGE_PLANT_ID	AS SLOC_PLANT_ID
			  ,A.PUCH_MGR
			  ,A.PUCH_GROUP
			  ,A.PR_HEADER
			  ,A.PR_ITEM_DETAIL
			  --,A.LAST_UPDATED_BY	AS DM_REQUESTED_BY
			  ,A.ATTRIBUTE1	AS DM_REQUESTED_BY				-- 요청자 한글 이름
			  ,A.LAST_UPDATE_DATE	AS DM_REQUEST_DATE
			  ,(SELECT TOP 1 BOD_ID 
			      FROM SCP_MST_BOD_V WITH(NOLOCK)
			     WHERE DIVISION_ID	= A.DIVISION_ID  
--			       AND FROM_SITE	= CASE WHEN A.PLANT_SITE_ID IS NULL OR A.PLANT_SITE_ID = '' THEN 'KR012031-P' ELSE  A.PLANT_SITE_ID END
			       AND FROM_SITE	= CASE WHEN A.PLANT_SITE_ID IS NULL OR A.PLANT_SITE_ID = '' THEN @v_KR012031 ELSE  A.PLANT_SITE_ID END
			       AND TO_SITE		= A.SCM_SITE_ID 
				   AND INCOTERMS    = A.INCOTERMS
				   AND BOD_VALID_YN = 'Y'
			     ORDER BY 
				       PRIORITY ASC
			   )                  AS BOD_ID                  
			  ,'N'
			  ,NULL
			  ,@v_batch_user      AS CREATED_BY
			  ,GETDATE()          AS CREATION_DATE
			  --,@v_batch_user      AS LAST_UPDATED_BY
			  ,A.LAST_UPDATED_BY  AS LAST_UPDATED_BY		-- 요청자 GPORTAL ID
			  ,GETDATE()          AS LAST_UPDATE_DATE
		  FROM DM_PLN_PR_DETAIL   A WITH(NOLOCK)
		 WHERE 1 = 1
		   AND A.REQUEST_NO		= @v_dm_req_no
		    ;
        ---------------------------------------------------------------
		-- 음수수량 요청시 이전 요청 확인하여 블로킹
		SELECT @INX			= 1
			  ,@MAX_NUM		= COUNT(*)
		  FROM @TAB

		declare @DM_REQ_NO					[nvarchar](60) 
		declare @ITEM_ID					[nvarchar](50) 
		declare @DIVISION_ID				[nvarchar](10) 
		declare @PROJECT_CODE				[nvarchar](50) 
		declare @SCM_SITE_ID				[nvarchar](50) 
		declare @PLANT_SITE_ID				[nvarchar](50) 
		declare @DOM_EXP					[nvarchar](6)  
		declare @FCST_TYPE					[nvarchar](50) 
		declare @INCOTERMS					[nvarchar](20) 
		declare @YYYYMMDD					[nvarchar](8) 
		declare @PLAN_QTY					[numeric](20, 10) 
		declare @DM_REQUEST_DATE			[datetime] 

		declare @BEFORE_DM_REQ_NO			[nvarchar](60) 
		declare @BEFORE_ITEM_ID				[nvarchar](50) 
		declare @BEFORE_PLAN_QTY			[numeric](20, 10) 

		WHILE @INX <= @MAX_NUM
		BEGIN

		    SELECT 
				   @DM_REQ_NO			= DM_REQ_NO	
				  ,@ITEM_ID				= ITEM_ID		
				  ,@DIVISION_ID			= DIVISION_ID
				  ,@PROJECT_CODE		= PROJECT_CODE
				  ,@SCM_SITE_ID			= SCM_SITE_ID
				  ,@PLANT_SITE_ID		= PLANT_SITE_ID
				  ,@DOM_EXP				= DOM_EXP	
				  ,@FCST_TYPE			= FCST_TYPE	
				  ,@INCOTERMS			= INCOTERMS	
				  ,@YYYYMMDD			= YYYYMMDD	
				  ,@PLAN_QTY            = PLAN_QTY
				  ,@DM_REQUEST_DATE     = DM_REQUEST_DATE
			  FROM @TAB 
			 WHERE TID					= @INX

			IF @PLAN_QTY < 0
			BEGIN

				SET @BEFORE_DM_REQ_NO	= NULL
				SET @BEFORE_ITEM_ID		= NULL
				SET @BEFORE_PLAN_QTY	= NULL

				SELECT TOP 1 
				       @BEFORE_DM_REQ_NO	= R.DM_REQ_NO
					  ,@BEFORE_ITEM_ID		= R.ITEM_ID
					  ,@BEFORE_PLAN_QTY		= R.PLAN_QTY
				  FROM SSP_ANL_ESS_REQ AS R WITH(NOLOCK) 
					   LEFT OUTER JOIN SSP_ANL_ESS_PR AS P WITH(NOLOCK)
				    ON R.DM_REQ_NO			= P.DM_REQ_NO
				   AND R.ITEM_ID			= P.PR_ITEM_ID
			     WHERE 1 =1
				   AND R.ITEM_ID			= @ITEM_ID
				   AND R.DIVISION_ID		= @DIVISION_ID
				   AND R.PROJECT_CODE		= @PROJECT_CODE
				   AND R.SCM_SITE_ID		= @SCM_SITE_ID
				   AND R.PLANT_SITE_ID		= @PLANT_SITE_ID
				   AND R.DOM_EXP			= @DOM_EXP
				   AND R.FCST_TYPE			= @FCST_TYPE
				   AND R.INCOTERMS			= @INCOTERMS
				   AND R.YYYYMMDD			= @YYYYMMDD
				   AND R.DM_REQUEST_DATE	< @DM_REQUEST_DATE
				   AND P.PR_NO		IS NULL 
				   AND P.ATTRIBUTE1 IS NULL
			     ORDER BY 
				       DM_REQUEST_DATE DESC

				IF (@PLAN_QTY * -1) = @BEFORE_PLAN_QTY
				BEGIN

					UPDATE SSP_ANL_ESS_REQ
					   SET HOLD_FLAG = 'Y'
					 WHERE DM_REQ_NO = @BEFORE_DM_REQ_NO
					   AND ITEM_ID   = @BEFORE_ITEM_ID

                    UPDATE @TAB
					   SET HOLD_FLAG = 'Y'
					 WHERE DM_REQ_NO = @DM_REQ_NO
					   AND ITEM_ID   = @ITEM_ID
				END

			END

			SET @INX = @INX + 1

		END
		---------------------------------------------------------------

		-- DM 정보 기준 SSP_ANL_ESS_REQ 정보 생성
		INSERT INTO SSP_ANL_ESS_REQ (
	           [DM_REQ_NO]			
			  ,[ITEM_SEQ]			
			  ,[ITEM_ID]			
			  ,[DIVISION_ID]		
			  ,[PROJECT_CODE]		
			  ,[SCM_SITE_ID]		
			  ,[PLANT_SITE_ID]		
			  ,[DOM_EXP]			
			  ,[FCST_TYPE]			
			  ,[INCOTERMS]			
			  ,[YYYYMMDD]			
			  ,[PLAN_QTY]			
			  ,[UOM]				
			  ,[INV_ALLO_QTY]		
			  ,[SLOC_ID]			
			  ,[SLOC_PLANT_ID]		
			  ,[PUCH_MGR]			
			  ,[PUCH_GROUP]		
			  ,[PR_HEADER]			
			  ,[PR_ITEM_DETAIL]	
			  ,[DM_REQUESTED_BY]	
			  ,[DM_REQUEST_DATE]	
			  ,[BOD_ID]			
			  ,[HOLD_FLAG]		
			  ,[CONFIRM_ID]		
			  ,[CREATED_BY]		
			  ,[CREATION_DATE]		
			  ,[LAST_UPDATED_BY]	
			  ,[LAST_UPDATE_DATE]
			  ,[ATTRIBUTE1]			-- 최초 DM_REQUESTOR 
			  )
		SELECT 
	           [DM_REQ_NO]			
			  ,[ITEM_SEQ]			
			  ,[ITEM_ID]			
			  ,[DIVISION_ID]		
			  ,[PROJECT_CODE]		
			  ,[SCM_SITE_ID]		
			  ,[PLANT_SITE_ID]		
			  ,[DOM_EXP]			
			  ,[FCST_TYPE]			
			  ,[INCOTERMS]			
			  ,[YYYYMMDD]			
			  ,[PLAN_QTY]			
			  ,[UOM]				
			  ,[INV_ALLO_QTY]		
			  ,[SLOC_ID]			
			  ,[SLOC_PLANT_ID]		
			  ,[PUCH_MGR]			
			  ,[PUCH_GROUP]		
			  ,[PR_HEADER]			
			  ,[PR_ITEM_DETAIL]	
			  ,[DM_REQUESTED_BY]	
			  ,[DM_REQUEST_DATE]	
			  ,[BOD_ID]			
			  ,[HOLD_FLAG]		
			  ,[CONFIRM_ID]		
			  ,[CREATED_BY]		
			  ,[CREATION_DATE]		
			  ,[LAST_UPDATED_BY]	
			  ,[LAST_UPDATE_DATE]	
			  ,[LAST_UPDATED_BY] -- 최초 DM_REQUESTOR 
		  FROM @TAB
		;

		-- DM 정보 기준 SSP_ANL_ESS_REQ_H 정보 생성
		INSERT INTO SSP_ANL_ESS_REQ_H (
			   HISTORY_SEQ
	          ,[DM_REQ_NO]			
			  ,[ITEM_SEQ]			
			  ,[ITEM_ID]			
			  ,[DIVISION_ID]		
			  ,[PROJECT_CODE]		
			  ,[SCM_SITE_ID]		
			  ,[PLANT_SITE_ID]		
			  ,[DOM_EXP]			
			  ,[FCST_TYPE]			
			  ,[INCOTERMS]			
			  ,[YYYYMMDD]			
			  ,[PLAN_QTY]			
			  ,[UOM]				
			  ,[INV_ALLO_QTY]		
			  ,[SLOC_ID]			
			  ,[SLOC_PLANT_ID]		
			  ,[PUCH_MGR]			
			  ,[PUCH_GROUP]		
			  ,[PR_HEADER]			
			  ,[PR_ITEM_DETAIL]	
			  ,[DM_REQUESTED_BY]	
			  ,[DM_REQUEST_DATE]	
			  ,[BOD_ID]			
			  --,[CONFIRM_FLAG]		
			  --,[CONFIRM_ID]		
			  ,[CREATED_BY]		
			  ,[CREATION_DATE]		
			  ,[LAST_UPDATED_BY]	
			  ,[LAST_UPDATE_DATE]	
			  )
		SELECT CONVERT(CHAR(8), GETDATE(), 112) + DBO.FN_ZERO_LPAD(CONVERT(VARCHAR,NEXT VALUE FOR DBO.SEQ1_SSP_ANL_ESS),6)  AS HISTORY_SEQ
	          ,[DM_REQ_NO]			
			  ,[ITEM_SEQ]			
			  ,[ITEM_ID]			
			  ,[DIVISION_ID]		
			  ,[PROJECT_CODE]		
			  ,[SCM_SITE_ID]		
			  ,[PLANT_SITE_ID]		
			  ,[DOM_EXP]			
			  ,[FCST_TYPE]			
			  ,[INCOTERMS]			
			  ,[YYYYMMDD]			
			  ,[PLAN_QTY]			
			  ,[UOM]				
			  ,[INV_ALLO_QTY]		
			  ,[SLOC_ID]			
			  ,[SLOC_PLANT_ID]		
			  ,[PUCH_MGR]			
			  ,[PUCH_GROUP]		
			  ,[PR_HEADER]			
			  ,[PR_ITEM_DETAIL]	
			  ,[DM_REQUESTED_BY]	
			  ,[DM_REQUEST_DATE]	
			  ,[BOD_ID]			
			  --,[CONFIRM_FLAG]		
			  --,[CONFIRM_ID]		
			  ,[CREATED_BY]		
			  ,[CREATION_DATE]		
			  ,[LAST_UPDATED_BY]	
			  ,[LAST_UPDATE_DATE]	
		  FROM @TAB
		;

		-- DM 정보 기준 SSP REQ 정보 생성 후 DM 테이블 SSP_TRANSFER_FLAG 및 LAST_UPDATE_DATE 변경
		UPDATE DM_PLN_PR_DETAIL
		   SET SSP_TRANSFER_FLAG	= 'Y'
		      ,LAST_UPDATED_BY		= @v_batch_user
			  ,LAST_UPDATE_DATE		= GETDATE()
		 WHERE 1 = 1
		   AND REQUEST_NO			= @v_dm_req_no
		;

		---------------------------------------------------------------------------------------------------  
		-- ERP 재고 NETTING PROGRAM CALL
		---------------------------------------------------------------------------------------------------  
		DECLARE @v_return INT ;

		EXEC @v_return = [dbo].[PR_SSP_ANL_ESS_REQ_NET] @v_dm_req_no, @v_division_id, @v_log_message OUTPUT;

		IF @v_return = -1 
		BEGIN
			SET @v_log_message = 'PR_SSP_ANL_ESS_REQ_NET : '+ @v_log_message ;
			THROW 60000, @v_log_message, 1  ;
		END; 


		-----------------------------------------------------------
		-- 실행 Logic END --
		-----------------------------------------------------------

		-- TXN LOG
		SET @v_log_type		= N'TXN';    -- ▶ 로그타입
		SET @n_log_count	= @@ROWCOUNT;
		SET @v_log_message	= N'EXECUTE '+ @v_program_name;
		SET @v_description	= N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
		SET @d_event_date	= SYSDATETIME();

		EXEC PR_DM_SYS_LOG_BATCH  @p_program_name  = @v_program_name
								  ,@p_log_type      = @v_log_type
								  ,@p_log_count     = @n_log_count 
								  ,@p_log_message   = @v_log_message 
								  ,@p_description   = @v_description 
								  ,@p_event_date    = @d_event_date 
								  ,@p_user_id       = @v_batch_user
								  ;      



	END TRY

    BEGIN CATCH

		-- ERROR LOG
		SET @v_log_type		= N'ERROR';
		SET @v_log_message	= CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description	= @v_program_name + N'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date	= SYSDATETIME();

		EXEC PR_DM_SYS_LOG_BATCH  @p_program_name  = @v_program_name
								  ,@p_log_type      = @v_log_type
								  ,@p_log_count     = @n_log_count 
								  ,@p_log_message   = @v_log_message 
								  ,@p_description   = @v_description 
								  ,@p_event_date    = @d_event_date 
								  ,@p_user_id       = @v_batch_user
								  ;

 		SET @r_error_msg =  CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		RETURN -1
 
    END CATCH;

     --임시 운영반영시에 주석처리 할것.
     SET @v_exec_time  =  REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' + 
                          REPLICATE('0', 2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) 

    -- 종료 LOG
    SET @v_log_type		= N'END';
    SET @v_log_message	= N'########## END of procedure ##########';
    SET @v_description	= N'['++'][' + @v_exec_time + ']';  
    SET @d_event_date	= SYSDATETIME()  ;

    EXEC PR_DM_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                              ,@p_log_type      = @v_log_type
                              ,@p_log_count     = @n_log_count 
                              ,@p_log_message   = @v_log_message 
                              ,@p_description   = @v_description 
                              ,@p_event_date    = @d_event_date 
                              ,@p_user_id       = @v_batch_user
                              ;

 	SET @r_error_msg =  'OK';
   
    RETURN 1 ;
END ;

