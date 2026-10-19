/***************************************************************************************************
 * Program ID   : PR_SSP_DNM_FP_PLAN_FROZEN
 * Description  : SCM_DNM_PLAN_FROZEN_V 1시간 배치 적용
 * OutTable     : 
 * Execute      : EXEC PR_SSP_DNM_FP_PLAN_FROZEN
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021.05.14   SSP Pjt.       Create
 * 2021.11.25   SSP Pjt.       성능개선을 위한 튜닝
 * 2022.04.01   SSP Pjt.       JV DIVISION_ID 적용
****************************************************************************************************/

CREATE PROCEDURE [dbo].[PR_SSP_DNM_FP_PLAN_FROZEN] 
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user				NVARCHAR(150)	= N'ssp_batch';  

    DECLARE @v_program_name				NVARCHAR(150)	= N'PR_SSP_DNM_FP_PLAN_FROZEN';
    DECLARE @v_log_type					NVARCHAR(30); 
    DECLARE @n_log_count				INTEGER = 0;
    DECLARE @v_log_message				NVARCHAR(1000);
    DECLARE @v_description				NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id					NVARCHAR(150)	= N'SSP_DNM_FP_PLAN_FROZEN'; -- ▶ 테이블 필수
    DECLARE @d_event_date				DATETIME;

	DECLARE @dm_req_cnt					INT = 0;	
	DECLARE @v_division_id              NVARCHAR(10);
    DECLARE @v_dm_req_no				NVARCHAR(60)	= '';

    DECLARE @v_start_time				DATETIME		= SYSDATETIME();
    DECLARE @v_exec_time				NVARCHAR(10)	= '';

	DECLARE @v_from_yyyymmdd  NVARCHAR(8)
	DECLARE @v_to_yyyymmdd    NVARCHAR(8)

	SET @v_from_yyyymmdd	= CONVERT(CHAR(8), getdate()-2, 112);
	SET @v_to_yyyymmdd		= CONVERT(CHAR(8), DATEADD(DD, 60, CONVERT(VARCHAR, @v_from_yyyymmdd, 121)), 112);

	DECLARE @INX		INT	= 0;
    DECLARE @MAX_NUM	INT	= 0;

	DECLARE @TAB   TABLE
	(
	    TID						INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
		[DIVISION_ID]			[nvarchar](30) NOT NULL INDEX VIX_TAB_01(DIVISION_ID, SCM_SITE_ID, ITEM_ID, PLAN_DATE, OPERATION_ID, SITE_ID,COMPANY_ID),
		[SCM_SITE_ID]			[nvarchar](30) NOT NULL,
		[ITEM_ID]				[nvarchar](50) NOT NULL,
		[PLAN_DATE]				[nvarchar](8) NOT NULL,
		[OPERATION_ID]			[nvarchar](30) NOT NULL,
		[SITE_ID]				[nvarchar](30) NULL,
		[COMPANY_ID]			[nvarchar](30) NULL,
		[PLAN_QTY]				[numeric](20, 10) NULL
	)

    -- 시작 LOG
    SET @v_log_type		= N'START';
    SET @v_log_message	= N'########## Start of procedure ##########';
    SET @v_description	= @v_program_name + ': ' + @v_table_id + N' INSERT LOGIC';  
    SET @d_event_date	= SYSDATETIME();

    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                              ,@p_log_type      = @v_log_type
                              ,@p_log_count     = @n_log_count 
                              ,@p_log_message   = @v_log_message 
                              ,@p_description   = @v_description 
                              ,@p_event_date    = @d_event_date 
                              ,@p_user_id       = @v_batch_user
                              ;

    BEGIN TRY

		INSERT INTO @TAB (
	           [DIVISION_ID]	
			  ,[SCM_SITE_ID]	
			  ,[ITEM_ID]		
			  ,[PLAN_DATE]		
			  ,[OPERATION_ID]	
			  ,[SITE_ID]		
			  ,[COMPANY_ID]	
			  ,[PLAN_QTY]	
			  )
        SELECT FP.DIVISION_ID
			 , FP.SCM_SITE_ID							
			 , FP.ITEM_ID
			 , CONVERT(NVARCHAR(8), FP.PLAN_DATE, 112) 
			  ,FP.[OPERATION_ID]
			  ,FP.[SITE_ID]		
			  ,FP.[COMPANY_ID]	
			 , SUM(FP.PLAN_QTY) AS PLAN_QTY						
          FROM (SELECT 
                       m.SCM_SITE_ID
                     , r.company_id  --
                     , r.division_id  --
                     , r.site_id     --
                     , r.plant_id
                     , r.factory_id  
                     , r.operation_id
                     , r.location    
                     , r.top_item_id 
                     , ISNULL(fi.packer_plan_item_id,r.item_id) item_id --2018.06.29   
	                 , r.item_id origin_item_id --2018.06.29  
                     , r.fp_production_type
                     , r.market      
                     , r.line_id     
                     , r.electrode_type
                     , r.plan_date   
                     , r.plan_qty          -- OUT 수량
	                  -- IN 수량
                     , CASE WHEN r.plan_in_qty <= 0 THEN r.plan_qty
                            ELSE r.plan_in_qty
                       END plan_in_qty
                     , r.equipment_id
                  FROM dbo.scm_dnm_fp_release_plan_v_sn r WITH(NOLOCK)
                       LEFT JOIN scp_mst_final_item fi --2018.06.29
                    ON r.division_id = fi.division_id
                   AND r.item_id = fi.item_id 
                       OUTER APPLY (
                       SELECT TOP 1 ISNULL(I.SCP_OPERATION_GROUP,'') AS SCP_OPERATION_GROUP
                         FROM DBO.SCM_MST_ITEM_SN              I WITH(NOLOCK)
                        WHERE 1=1
                          AND I.DIVISION_ID          = r.division_id
                          AND I.ITEM_ID              = r.item_id
                       ) AS OG
                       OUTER APPLY (
                       SELECT TOP 1 ISNULL(I.SCM_SITE_ID,'') AS SCM_SITE_ID
                         FROM DBO.SCM_MST_SITE             I WITH(NOLOCK)
                        WHERE 1 = 1
                          AND I.PLANT_ID             = r.plant_id
                          AND I.OPERATION_GROUP      = OG.SCP_OPERATION_GROUP
                          AND I.SITE_TYPE            = 'PLANT'
                          AND I.VALID_YN             = 'Y'
                      ) AS M
                WHERE ISNULL(r.fp_production_type, '-') NOT IN ('TEST', 'REWORK', 'M/C') 
			   ) AS FP 
               INNER JOIN dbo.SCM_MST_SITE FS  WITH(NOLOCK)
			ON FP.DIVISION_ID      = FS.DIVISION_ID
		   AND FP.SCM_SITE_ID		= FS.SCM_SITE_ID
		   AND FS.SITE_TYPE			= 'PLANT'
           --AND FS.OSP_YN          = 'N'
           AND FS.VALID_YN			= 'Y'
         WHERE 1 = 1
		   --AND FP.DIVISION_ID  IN (SELECT DIVISION_ID
     --                                FROM SCM_MST_DIVISION WITH(NOLOCK)
     --                               WHERE VALID_YN = 'Y'
     --                                 AND ATTRIBUTE3 IN ('81','82') )
		   AND FP.DIVISION_ID   in ('81','82', '81_UC', '81_HM','81_ST','81_HD','81_HG')
		   AND FP.PLAN_DATE		>= @v_from_yyyymmdd
		   AND FP.PLAN_DATE		<= @v_to_yyyymmdd
		   AND FP.PLAN_QTY		> 0
		   AND FP.PLAN_IN_QTY	> 0
	     GROUP BY
			   FP.[DIVISION_ID]	
			  ,FP.[SCM_SITE_ID]	
			  ,FP.[ITEM_ID]		
			  ,FP.[PLAN_DATE]		
			  ,FP.[OPERATION_ID]
			  ,FP.[SITE_ID]		
			  ,FP.[COMPANY_ID]	
		    ;


		----BEGIN TRAN TX_SH

		MERGE INTO [dbo].[SSP_DNM_FP_PLAN_FROZEN] A
		USING @TAB AS B
		   ON A.[DIVISION_ID]			= B.[DIVISION_ID]	
		  AND A.[SCM_SITE_ID]			= B.[SCM_SITE_ID]	
		  AND A.[ITEM_ID]				= B.[ITEM_ID]		
		  AND A.[PLAN_DATE]				= B.[PLAN_DATE]		
		  AND A.[OPERATION_ID]			= B.[OPERATION_ID]	
		  AND A.SITE_ID					= B.SITE_ID
		  AND A.COMPANY_ID				= B.COMPANY_ID
		WHEN MATCHED THEN
			UPDATE 
			   SET [PLAN_QTY]           = B.[PLAN_QTY]
		          ,LAST_UPDATED_BY		= @v_batch_user
			      ,LAST_UPDATE_DATE		= GETDATE()	
	    WHEN NOT MATCHED THEN
			INSERT (	
			  	   [DIVISION_ID]	
			  	  ,[SCM_SITE_ID]	
			  	  ,[ITEM_ID]		
			  	  ,[PLAN_DATE]		
			  	  ,[OPERATION_ID]	
			  	  ,[SITE_ID]		
			  	  ,[COMPANY_ID]	
			  	  ,[PLAN_QTY]
			      ,[CREATED_BY]		
			      ,[CREATION_DATE]		
			      ,[LAST_UPDATED_BY]	
			      ,[LAST_UPDATE_DATE]	
				  )
		   VALUES (
			  	   B.[DIVISION_ID]	
			  	  ,B.[SCM_SITE_ID]	
			  	  ,B.[ITEM_ID]		
			  	  ,B.[PLAN_DATE]		
			  	  ,B.[OPERATION_ID]	
			  	  ,B.[SITE_ID]		
			  	  ,B.[COMPANY_ID]	
			  	  ,B.[PLAN_QTY]
			      ,@v_batch_user      
			      ,GETDATE()          
			      ,@v_batch_user      
			      ,GETDATE()          
				  );

		DELETE T
		  FROM [dbo].[SSP_DNM_FP_PLAN_FROZEN] AS T WITH(NOLOCK)
		       LEFT OUTER JOIN @TAB AS S
		    ON S.[DIVISION_ID]		= T.[DIVISION_ID]	
		   AND S.[SCM_SITE_ID]		= T.[SCM_SITE_ID]	
		   AND S.[ITEM_ID]			= T.[ITEM_ID]		
		   AND S.[PLAN_DATE]		= T.[PLAN_DATE]		
		   AND S.[OPERATION_ID]		= T.[OPERATION_ID]	
		   AND S.SITE_ID			= T.SITE_ID
		   AND S.COMPANY_ID			= T.COMPANY_ID
		 WHERE S.DIVISION_ID IS NULL


		--COMMIT TRAN TX_SH;
		-----------------------------------------------------------
		-- 실행 Logic END --
		-----------------------------------------------------------

		-- TXN LOG
		SET @v_log_type		= N'TXN';    -- ▶ 로그타입
		SET @n_log_count	= @@ROWCOUNT;
		SET @v_log_message	= N'EXECUTE '+ @v_program_name;
		SET @v_description	= N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
		SET @d_event_date	= SYSDATETIME();

		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
								  ,@p_log_type      = @v_log_type
								  ,@p_log_count     = @n_log_count 
								  ,@p_log_message   = @v_log_message 
								  ,@p_description   = @v_description 
								  ,@p_event_date    = @d_event_date 
								  ,@p_user_id       = @v_batch_user
								  ;      



	END TRY

    BEGIN CATCH

	    --ROLLBACK TRAN TX_SH

		-- ERROR LOG
		SET @v_log_type		= N'ERROR';
		SET @v_log_message	= CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description	= @v_program_name + N'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date	= SYSDATETIME();

		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
								  ,@p_log_type      = @v_log_type
								  ,@p_log_count     = @n_log_count 
								  ,@p_log_message   = @v_log_message 
								  ,@p_description   = @v_description 
								  ,@p_event_date    = @d_event_date 
								  ,@p_user_id       = @v_batch_user
								  ;


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

    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                              ,@p_log_type      = @v_log_type
                              ,@p_log_count     = @n_log_count 
                              ,@p_log_message   = @v_log_message 
                              ,@p_description   = @v_description 
                              ,@p_event_date    = @d_event_date 
                              ,@p_user_id       = @v_batch_user
                              ;

   
    RETURN 1 ;
END ;

