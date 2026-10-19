

/***************************************************************************************************
 * Program ID   : PR_SSP_XIF_SCS_PACK_SHIP_PLAN_F_S
 * Description  : Packer 출하 TARGET 전송('FN' 생성시)
 * OutTable     : XIF_SCS_PACK_SHIP_PLAN_S (I/F Table)
 * Execute      : EXEC PR_SSP_XIF_SCS_PACK_SHIP_PLAN_F_S
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021.12.01   SSP Pjt.       생성
 * 2024.10.01   KHJ            NERP_SSP
****************************************************************************************************/
 
CREATE PROCEDURE [dbo].[PR_SSP_XIF_SCS_PACK_SHIP_PLAN_F_S]
( 
      @p_division_id          NVARCHAR(10)
    , @p_start_yyyymmdd       NVARCHAR(8)
    , @p_plan_type            NVARCHAR(40)
    , @p_seq                  INT
    , @p_user_id              NVARCHAR(100)
) AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

	-- LOG 용 변수 설정  
    DECLARE @v_batch_user   NVARCHAR(150) = N'SCS_BATCH'; 
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SSP_XIF_SCS_PACK_SHIP_PLAN_F_S';  
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...  
    DECLARE @n_log_count    INTEGER = 0;  
    DECLARE @v_log_message  NVARCHAR(1000);  
    DECLARE @v_description  NVARCHAR(500);      --상세설명   
    DECLARE @v_table_id     NVARCHAR(150) = N'XIF_SCS_PACK_SHIP_PLAN_S'; --테이블 필수  
    DECLARE @d_event_date   DATETIME;  
	DECLARE @v_division_id  NVARCHAR(100) = N'';
	DECLARE @v_insert_cnt   INTEGER = 0;
	DECLARE @v_insert_sum   INTEGER = 0;

	DECLARE @INX					  [INT]					= 0;
	DECLARE @MAX_NUM				  [INT]					= 0;
	DECLARE @PROC_FLAG				  [NVARCHAR](50)		= 'N';
	DECLARE @PROC_MSG				  [NVARCHAR](1000)		= NULL;
	DECLARE @ERROR_NUMBER			  [INT]					= NULL;
	DECLARE @ERROR_MESSAGE			  [NVARCHAR](2048)		= NULL;

	DECLARE @TAB_DIVISION TABLE
    (
        [TID]                         INT IDENTITY(1,1)		NOT NULL PRIMARY KEY,
		[DIVISION_ID]                 [nvarchar](50)
    );

	DECLARE @IF_TYPE				NVARCHAR(1)    = 'I';
    DECLARE @IF_ID					NVARCHAR(50)   = 'OSCM_OSCS_SCS_PACK_SHIP_PLAN';
    DECLARE @IF_INS_DATE			DATETIME       = GETDATE();
    DECLARE @IF_FLAG				NVARCHAR(100)  = 'N';

	DECLARE @PLAN_START_YYYYMMDD    NVARCHAR(8);
	DECLARE @DELETE_START_YYYYMMDD  NVARCHAR(8);
	DECLARE @DIVISION_ID            NVARCHAR(50);
	DECLARE @PLAN_TYPE				NVARCHAR(50); 
	DECLARE @PLAN_SEQ               INT;
    DECLARE @IFSEQNO				INT					= 1;

	IF @p_plan_type NOT IN ('FN')
	BEGIN
		RETURN;
	END

	SET @DIVISION_ID			= @p_division_id
	SET @PLAN_START_YYYYMMDD	= @p_start_yyyymmdd
	SET @PLAN_TYPE				= @p_plan_type
	SET @PLAN_SEQ				= @p_seq	
	
	SET @DELETE_START_YYYYMMDD = CONVERT(CHAR(8), DATEADD(DD, -7*4, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 4주 전

	-----------------------------------------------------------
	-- START LOG
	-----------------------------------------------------------
    SET @v_log_type		= N'START';  
    SET @v_log_message	= N'########## Start of procedure ##########';  
    SET @v_description	= @v_program_name + ':' + N' XIF_SCS_PACK_SHIP_PLAN_S INSERT LOGIC';  
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

		/*****************************************************
		*	 Packer 출하 타겟 Interface 데이터 생성      
		*****************************************************/
		INSERT INTO XIF_SCS_PACK_SHIP_PLAN_S_SN (
			   IF_SEQ           
			 , IF_TYPE          
			 , IF_ID            
			 , IF_INS_DATE      
			 , IF_FLAG          
			 , PACKER_CODE      
			 , DIVISION_ID      
			 , PLAN_VERSION   
			 , PACK_MODEL_CODE  
			 , NICK_NAME 
			 , TARGET_ORDER
			 , SSP_CNFM
			 , SALES_SITE
			 , SHIP_TO
			 , SHIP_TO_NAME
			 , TRANSPORT_MODE
			 , INCOTERMS
			 , SHIP_PLAN_DATE 
			 , SHIP_PLAN_QTY 
			 , COMMENT      
			 , ATTR_01           
			 , ATTR_02           
			 , ATTR_03           
			 , ATTR_04           
			 , ATTR_05           
			 , ATTR_06           
			 , ATTR_07           
			 , ATTR_08           
			 , ATTR_09           
			 , ATTR_10           
			 )
		SELECT
			  'OSCM' + CONVERT(VARCHAR,GETDATE(),12) + dbo.FN_ZERO_LPAD(CONVERT(VARCHAR,NEXT VALUE FOR DBO.SEQ1_XIF_SCS),10)  AS IF_SEQ
			, @IF_TYPE								AS IF_TYPE
			, @IF_ID								AS IF_ID
			, @IF_INS_DATE							AS IF_INS_DATE
			, @IF_FLAG								AS IF_FLAG
			, ISNULL(X1.NEW_VALUE1, A.PACKER_CODE)	AS PACKER_CODE
			, A.DIVISION_ID
			, A.PLAN_VERSION
			, A.PACK_MODEL_CODE
			, A.NICK_NAME   
			, 'F'									AS TARGET_ORDER
			, NULL									AS SSP_CONFIRM
			, A.SALES_SITE     
			, A.SHIP_TO                                          
			, A.SHIP_TO_NAME
			, A.TRANSPORT_MODE
			, A.INCOTERMS
			, A.SHIP_PLAN_DATE
			, A.SHIP_PLAN_QTY 
			, NULL									AS COMMENT
			, A.ATTR_01          
			, NULL									AS ATTR_02           
			, NULL									AS ATTR_03           
			, NULL									AS ATTR_04           
			, NULL									AS ATTR_05           
			, NULL									AS ATTR_06           
			, NULL									AS ATTR_07           
			, NULL									AS ATTR_08           
			, NULL									AS ATTR_09           
			, NULL									AS ATTR_10  
		FROM
		(
			SELECT 
				   P.FROM_SITE							AS PACKER_CODE
				 , P.DIVISION_ID						AS DIVISION_ID
				 , P.PLAN_START_YYYYMMDD				AS PLAN_VERSION
				 , P.ITEM_ID							AS PACK_MODEL_CODE
				 , MAX(FI.NICK_NAME)    	            AS NICK_NAME   
				 , P.TO_SITE							AS SALES_SITE        
				 , [dbo].[FN_GET_SITE_CUSTOMER_INFO](P.DIVISION_ID,P.TO_SITE,'SHIPTO_CODE')			AS SHIP_TO                                             
				 , [dbo].[FN_GET_SITE_CUSTOMER_INFO](P.DIVISION_ID,P.TO_SITE,'SHIPTO_DESCRIPTION')	AS SHIP_TO_NAME
				 , B.TRANSPORT_MODE						AS TRANSPORT_MODE
				 , P.INCOTERMS							AS INCOTERMS
				 , P.YYYYMMDD							AS SHIP_PLAN_DATE
				 , ROUND(SUM(P.QTY),0)			        AS SHIP_PLAN_QTY 
				 , @DIVISION_ID + '_' + @PLAN_START_YYYYMMDD + '_' + @PLAN_TYPE + '_' + CONVERT(VARCHAR, @PLAN_SEQ) +'_' + FORMAT(CURRENT_TIMESTAMP, 'yyyyMMddHHmmss')	AS ATTR_01          
			  FROM SCP_ANL_SHIPMENT_PLAN_FG  P  (NOLOCK)
				   INNER JOIN [SCM_MST_SITE] AS FS (NOLOCK)
				ON FS.DIVISION_ID					= P.DIVISION_ID 
			   AND FS.SCM_SITE_ID					= P.FROM_SITE
			   AND FS.DIVISION_ID					= @DIVISION_ID
			   AND FS.SITE_TYPE					    = 'PLANT'
			   AND FS.OSP_YN						= 'Y'
			   AND FS.VALID_YN						= 'Y'
			   AND FS.OPERATION_GROUP       	    = 'P' -- Pack Site
		   		   LEFT OUTER JOIN SCP_MST_BOD_N_V AS B WITH(NOLOCK)
				ON B.DIVISION_ID					= P.DIVISION_ID 
			   AND B.BOD_ID							= P.BOD_ID
			   AND B.BOD_VALID_YN					= 'Y'
				   LEFT OUTER JOIN SCP_MST_FINAL_ITEM AS FI WITH(NOLOCK)
				ON P.DIVISION_ID					= FI.DIVISION_ID 
			   AND P.item_id  						= FI.item_id
			 WHERE 1 = 1
			   AND P.PLAN_START_YYYYMMDD			= @PLAN_START_YYYYMMDD 
			   AND P.PLAN_TYPE						= @PLAN_TYPE
			   AND P.SEQ							= @PLAN_SEQ
			   AND P.MEASURE						= 'SHIP_PLAN_AMEND'
			   AND P.FROM_SITE						<> P.TO_SITE
			   AND P.QTY							> 0
			 GROUP BY
				   P.FROM_SITE                                        
				 , P.DIVISION_ID
				 , P.PLAN_START_YYYYMMDD
				 , P.ITEM_ID
				 , P.TO_SITE         
				 , B.TRANSPORT_MODE  
				 , P.INCOTERMS
				 , P.YYYYMMDD					 
		) A
		LEFT OUTER JOIN NERP_CONV_MASTER X1 WITH(NOLOCK) ON X1.CODETYPE = 'SCP_SITE_ID'	AND A.PACKER_CODE = X1.OLD_VALUE1
		
		-----------------------------------------------------------
		-- 이력처리
		-----------------------------------------------------------
		SET @v_insert_cnt	=  @@ROWCOUNT;
		SET @v_insert_sum	= @v_insert_sum + @v_insert_cnt;
 
 		-----------------------------------------------------------
		-- TXN LOG
		-----------------------------------------------------------
		SET @v_log_type		= N'TXN';    --로그타입  
		SET @n_log_count	= @v_insert_cnt; -- @@ROWCOUNT;
		SET @v_log_message	= N'INSERT INTO '+ @v_table_id;  
		SET @d_event_date	= SYSDATETIME();
		SET @v_description	= N'Process Complete...' + ':' + CONVERT(CHAR(23) ,@d_event_date ,121) + ' [DIVISION]: ' + @DIVISION_ID ;
					 
		EXEC PR_SCP_SYS_LOG_BATCH @p_program_name  =@v_program_name  
									,@p_log_type      =@v_log_type  
									,@p_log_count     =@n_log_count   
									,@p_log_message   =@v_log_message   
									,@p_description   =@v_description   
									,@p_event_date    =@d_event_date   
									,@p_user_id       =@v_batch_user  
									;  



    END TRY

    BEGIN CATCH 
 		-----------------------------------------------------------
		-- ERROR LOG
		-----------------------------------------------------------
		SET @v_log_type		= N'ERROR';  
		SET @v_log_message	= CAST(ERROR_MESSAGE() AS NVARCHAR(1000));  
		SET @v_description	= N'ERROR_LINE : ' + STR(ERROR_LINE());  
		SET @d_event_date	= SYSDATETIME();  
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name  
                                  ,@p_log_type      =@v_log_type  
                                  ,@p_log_count     =@n_log_count   
                                  ,@p_log_message   =@v_log_message   
                                  ,@p_description   =@v_description   
                                  ,@p_event_date    =@d_event_date   
                                  ,@p_user_id       =@v_batch_user  
                                  ;  

		return -1 
    END CATCH;

    -- 지난 정보 삭제
    DELETE XIF_SCS_PACK_SHIP_PLAN_S_SN
     WHERE DIVISION_ID   = @DIVISION_ID
       AND PLAN_VERSION <= @DELETE_START_YYYYMMDD;

 	-----------------------------------------------------------
	-- END LOG
	-----------------------------------------------------------
    SET @v_log_type		= N'END';  
    SET @v_log_message	= N'########## END of procedure ##########';  
    SET @v_description	= N'';  
    SET @d_event_date	= SYSDATETIME();  
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name  
                              ,@p_log_type      =@v_log_type  
                              ,@p_log_count     =@v_insert_sum   
                              ,@p_log_message   =@v_log_message   
                              ,@p_description   =@v_description   
                              ,@p_event_date    =@d_event_date   
                              ,@p_user_id       =@v_batch_user  
                              ;  
    return 1 
END;

