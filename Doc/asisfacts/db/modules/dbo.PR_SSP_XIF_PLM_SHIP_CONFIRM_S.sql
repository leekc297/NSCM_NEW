
/***************************************************************************************************
 * Program ID   : PR_SSP_XIF_PLM_SHIP_CONFIRM_S 
 * Description  : CONFIRM 정보 전송 (소형)
 * OutTable     : XIF_PLM_SHIP_CONFIRM_S (I/F Table)
 * Execute      : EXEC PR_SSP_XIF_PLM_SHIP_CONFIRM_S
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021.08.01   SSP Pjt.       Create.
 * 2021.09.01   SSP Pjt.       SCP_MST_BOD_N_V 적용
****************************************************************************************************/
 
CREATE PROCEDURE [dbo].[PR_SSP_XIF_PLM_SHIP_CONFIRM_S]
     @IF_ID                     NVARCHAR(50)
    ,@O_ERRFLAG                 NVARCHAR(50)  OUTPUT
    ,@O_ERRDESC                 NVARCHAR(200) OUTPUT
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS ON;

	-- LOG 용 변수 설정  
    DECLARE @v_batch_user			NVARCHAR(150) = N'ssp_batch'; 
    DECLARE @v_program_name			NVARCHAR(150) = N'PR_SSP_XIF_PLM_SHIP_CONFIRM_S';  
    DECLARE @v_log_type				NVARCHAR(30); -- START/END/ERROR/...  
    DECLARE @n_log_count			INTEGER = 0;  
    DECLARE @v_log_message			NVARCHAR(1000);  
    DECLARE @v_description			NVARCHAR(500);      --상세설명   
    DECLARE @v_table_id				NVARCHAR(150) = N'XIF_PLM_SHIP_CONFIRM_S'; --테이블 필수  
    DECLARE @d_event_date			DATETIME;  
    DECLARE @v_insert_cnt			INTEGER = 0; 
	DECLARE @v_insert_sum			INTEGER = 0; 

    DECLARE @IF_TYPE				NVARCHAR(1)    = 'I';
    --DECLARE @IF_ID					NVARCHAR(50)   = 'OSCM_OPLM_SHIP_CONFIRM';
    DECLARE @IF_INS_DATE			DATETIME       = GETDATE();
    DECLARE @IF_FLAG				NVARCHAR(100)  = 'N';
	DECLARE @IF_GROUP_ID            NVARCHAR(50)   = FORMAT(CURRENT_TIMESTAMP, 'yyyyMMddHHmmss');
	DECLARE @IF_GROUP_COUNT         INT

	DECLARE @DIVISION_ID            NVARCHAR(50);


	DECLARE @XIF_PLM_SHIP_CONFIRM_S TABLE (
		[IF_SEQ]			[nvarchar](50) ,
		[IF_TYPE]			[nvarchar](1) ,
		[IF_ID]				[nvarchar](50) ,
		[IF_INS_DATE]		[datetime] ,
		[IF_FLAG]			[nvarchar](1) ,
		[CONFIRM_ID]		[nvarchar](20) ,
		[FCST_TYPE]			[nvarchar](100) ,
		[ITEM_ID]			[nvarchar](50) ,
		[NICK_NAME]			[nvarchar](200) ,
		[FROM_SITE]			[nvarchar](30) ,
		[TO_SITE]			[nvarchar](30) ,
		[END_CUSTOMER]		[nvarchar](50) ,
		[MKT_OWNER]			[nvarchar](200) ,
		[PLANNED_QTY]		[numeric](20, 10) ,
		[YYYYMMDD]			[nvarchar](8) ,
		[TRANSPORT_MODE]	[nvarchar](50) ,
		[TO_SITE_SOLDTO_CODE] [nvarchar](10) ,
		[TO_SITE_SHIPTO_CODE] [nvarchar](10) ,
		[INCOTERMS]			[nvarchar](10) ,
		[LT_TOTAL]			[int] ,
		[ETD_DATE]			[nvarchar](8) ,
		[ETA_DATE]			[nvarchar](8) ,
		[EXPECTED_SHIPPING_DATE] [nvarchar](8) ,
		[MODEL_PIC]			[nvarchar](200) ,
		[ERP_SO_NO]			[nvarchar](50) ,
		[SHIP_DATE]			[nvarchar](8) ,
		[SHIP_QTY]			[numeric](20, 10) ,
		[LAST_UPDATE_DATE]  [datetime]
	)

	-----------------------------------------------------------
	-- PREPROCESSING
	-----------------------------------------------------------
	SET @IF_ID						= 'OSCM_OPLM_SHIP_CONFIRM';
	SET @O_ERRFLAG					= ''
	SET @O_ERRDESC					= '' 

	-----------------------------------------------------------
	-- START LOG
	-----------------------------------------------------------
    SET @v_log_type		= N'START';  
    SET @v_log_message	= N'########## Start of procedure ##########';  
    SET @v_description	= @v_program_name + ':' + N' XIF_PLM_SHIP_CONFIRM_S INSERT LOGIC';  
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
		 *	 소형 (DIVISION 40)   
		 *****************************************************/
		SET @DIVISION_ID = '40'

		INSERT INTO @XIF_PLM_SHIP_CONFIRM_S
		     ( IF_SEQ           
			 , IF_TYPE          
			 , IF_ID            
			 , IF_INS_DATE      
			 , IF_FLAG          
             , CONFIRM_ID
             , FCST_TYPE
             , ITEM_ID
             , NICK_NAME
             , FROM_SITE
             , TO_SITE
             , END_CUSTOMER
             , MKT_OWNER
             , PLANNED_QTY
             , YYYYMMDD
             , TRANSPORT_MODE
             , TO_SITE_SOLDTO_CODE
             , TO_SITE_SHIPTO_CODE
             , INCOTERMS
             , LT_TOTAL
             , ETD_DATE
             , ETA_DATE
             , EXPECTED_SHIPPING_DATE
             , MODEL_PIC
             , ERP_SO_NO
             , SHIP_DATE
             , SHIP_QTY
			 , LAST_UPDATE_DATE
		     )
		SELECT 'OSCM' + CONVERT(VARCHAR,GETDATE(),12) + dbo.FN_ZERO_LPAD(CONVERT(VARCHAR,NEXT VALUE FOR dbo.SEQ1_XIF_SCS),10)   AS IF_SEQ
			 , @IF_TYPE							AS IF_TYPE
			 , @IF_ID							AS IF_ID
			 , @IF_INS_DATE						AS IF_INS_DATE
			 , @IF_FLAG							AS IF_FLAG
             , A.CONFIRM_ID
             , ISNULL(LK.SEGMENT2, A.FCST_TYPE) AS FCST_TYPE                                                                                                          
             , A.ITEM_ID                                                                                                            
             , DBO.FN_GET_ITEM_NICKNAME(A.DIVISION_ID , A.ITEM_ID ) AS NICK_NAME         
             , A.FROM_SITE                                                                                                          
             , A.TO_SITE                                                                                                            
             , ISNULL(CASE WHEN A.DIVISION_ID = '40' THEN CASE WHEN A.PROJECT_CODE IS NOT NULL AND A.PROJECT_CODE != '-' THEN A.PROJECT_CODE 
                                                               ELSE G.PROJECT_CODE END 
                           WHEN A.DIVISION_ID = 'EE' AND A.ORIGIN_TO_DIVISION_ID = '40' THEN G.PROJECT_CODE 
                           ELSE F.END_CUSTOMER END, '-') END_CUSTOMER  
             , DBO.FN_GET_SSP_MKT_OWNER_NAME (SI.OWNER, ',', 'KO') AS MTK_OWNER 
             , CONVERT(NUMERIC, A.QTY) AS PLANNED_QTY  
             , A.YYYYMMDD
             , B.TRANSPORT_MODE   
             , A.TO_SITE_SOLDTO_CODE		
             , A.TO_SITE_SHIPTO_CODE		
             , B.SSP_INCOTERMS  AS INCOTERMS    
             , CONVERT(NUMERIC, B.LT_TOTAL) AS LT_DAY
             , A.ETD_DATE
             , A.ETA_DATE
             , CASE WHEN B.TRANSPORT_MODE = 'TRK' THEN '-' ELSE [DBO].[FN_GET_SSP_EXPECTED_SHIP_DATE](A.DIVISION_ID, A.BOD_ID, A.YYYYMMDD) 
			        END AS EXPECTED_SHIPPING_DATE    
             , CASE WHEN 'KO' = 'KO' THEN U2.USERNAME ELSE U2.USERNAME_E END + '(' + MU.USER_ID + ')' MODEL_PIC
             , A.ERP_SO_NO 
             , ERP.SHIP_DATE
             , ERP.SHIP_QTY
			 , A.LAST_UPDATE_DATE
          FROM SSP_ANL_SHIP_CONFIRM A with(nolock)                                                                                          
               INNER JOIN SCM_MST_SITE MS WITH(NOLOCK) 
            ON A.DIVISION_ID = MS.DIVISION_ID 
           AND A.FROM_SITE = MS.SCM_SITE_ID 
           AND MS.SITE_TYPE = 'PLANT' 
           AND A.DIVISION_ID = '40' 
           AND MS.OPERATION_GROUP = 'A'
               INNER JOIN  SCP_MST_BOD_N_V B WITH(NOLOCK) 
            ON A.DIVISION_ID = B.DIVISION_ID  
           AND A.BOD_ID = B.BOD_ID                                   
               LEFT OUTER JOIN SCM_MST_SITE F WITH(NOLOCK) 
            ON F.DIVISION_ID = A.ORIGIN_TO_DIVISION_ID 
           AND F.SCM_SITE_ID = A.TO_SITE      
               LEFT OUTER JOIN (SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID										
                             FROM (																						
                                  SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID									
                                        ,ROW_NUMBER() OVER(PARTITION BY DIVISION_ID, SCM_SITE_ID, ITEM_ID ORDER BY PROJECT_CODE) NUM	
                                    FROM SCM_MST_SITE_ITEM WITH(NOLOCK)																				
                                  ) A 
  	        			  WHERE NUM = 1) G 
  	        		ON G.DIVISION_ID =  A.DIVISION_ID AND G.SCM_SITE_ID = A.TO_SITE AND G.ITEM_ID = A.ITEM_ID	
               LEFT OUTER JOIN SSP_MST_MODEL_USER MU WITH(NOLOCK) 
            ON MU.DIVISION_ID = A.ORIGIN_FROM_DIVISION_ID 
           AND MU.FROM_SITE = A.FROM_SITE 
           AND MU.ITEM_ID = A.ITEM_ID 
           AND MU.VALID_YN = 'Y'                                                                                                              
               LEFT OUTER JOIN TB_FX_USER U2 WITH(NOLOCK) 
            ON MU.USER_ID = U2.USERID 
           AND U2.USEYN = 'Y'                                             
               LEFT OUTER JOIN SCM_MST_SITE_ITEM SI WITH(NOLOCK) 
            ON SI.DIVISION_ID	= A.DIVISION_ID       
           AND SI.SCM_SITE_ID	= A.TO_SITE        
           AND SI.ITEM_ID		= A.ITEM_ID        
           AND SI.PROJECT_CODE  = A.PROJECT_CODE   
		       LEFT OUTER JOIN (		
			                   SELECT E.CONFIRM_ID              
		                             ,MAX(E.EXFACTORY_DATE)     AS SHIP_DATE
		                             ,SUM(E.EXFACTORY_QTY)      AS SHIP_QTY 
		                         FROM SCM_DNM_EXFACTORY_RESULT E WITH(NOLOCK)
			                          JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
				                   ON L.LOOKUP_TYPE		= 'ERP_SSP_TYPE' -- LOOKUP에 등록된 공정만 
			                      AND L.VALID_YN		= 'Y'
			                      AND L.SEGMENT1		= E.SSP_TYPE 
		                        WHERE 1 = 1
		                          AND ISNULL(E.EXFACTORY_STATUS,'D90') NOT IN ('D90' ,'D10') -- D90: DO삭제 , D10:DO생성 
		                          AND E.DIVISION_ID = '40'
		                        GROUP BY E.CONFIRM_ID
                                ) AS ERP
			ON A.CONFIRM_ID = ERP.CONFIRM_ID
			   LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL AS LK WITH(NOLOCK)
            ON LK.LOOKUP_TYPE = 'SALES_TYPE_CODE'
		   AND LK.VALID_YN	= 'Y'
		   AND A.FCST_TYPE	= LK.SEGMENT1
         WHERE 1 = 1                                                                                                               
           AND YYYYMMDD >= CONVERT(VARCHAR, GETDATE() -30, 112)
           AND YYYYMMDD <= CONVERT(VARCHAR, GETDATE() +60, 112)                                           
           AND  A.DIVISION_ID   = '40'
           AND (A.SHIPMENT_STATUS IS NOT NULL AND ISNULL(A.SHIPMENT_STATUS,'') != '') 
           AND A.QTY > 0 
           AND A.CHANGE_TYPE	<> 'N'  
           AND A.BIZ_TYPE		<> 'E' 

		IF (format(getdate(), 'HHmm') BETWEEN '0730' AND '0739')
		BEGIN
		    SELECT @IF_GROUP_COUNT = COUNT(*)
              FROM @XIF_PLM_SHIP_CONFIRM_S

			INSERT INTO dbo.XIF_PLM_SHIP_CONFIRM_S_SN
				 ( IF_SEQ           
				 , IF_TYPE          
				 , IF_ID            
				 , IF_INS_DATE      
				 , IF_FLAG  
				 , IF_GROUP_ID
				 , IF_GROUP_COUNT
				 , CONFIRM_ID
				 , FCST_TYPE
				 , ITEM_ID
				 , NICK_NAME
				 , FROM_SITE
				 , TO_SITE
				 , END_CUSTOMER
				 , MKT_OWNER
				 , PLANNED_QTY
				 , YYYYMMDD
				 , TRANSPORT_MODE
				 , TO_SITE_SOLDTO_CODE
				 , TO_SITE_SHIPTO_CODE
				 , INCOTERMS
				 , LT_TOTAL
				 , ETD_DATE
				 , ETA_DATE
				 , EXPECTED_SHIPPING_DATE
				 , MODEL_PIC
				 , ERP_SO_NO
				 , SHIP_DATE
				 , SHIP_QTY
				 )
			SELECT IF_SEQ           
				 , IF_TYPE          
				 , IF_ID            
				 , IF_INS_DATE      
				 , IF_FLAG          
				 , @IF_GROUP_ID
				 , @IF_GROUP_COUNT
				 , CONFIRM_ID
				 , FCST_TYPE
				 , ITEM_ID
				 , NICK_NAME
				 , FROM_SITE
				 , TO_SITE
				 , END_CUSTOMER
				 , MKT_OWNER
				 , PLANNED_QTY
				 , YYYYMMDD
				 , TRANSPORT_MODE
				 , TO_SITE_SOLDTO_CODE
				 , TO_SITE_SHIPTO_CODE
				 , INCOTERMS
				 , LT_TOTAL
				 , ETD_DATE
				 , ETA_DATE
				 , EXPECTED_SHIPPING_DATE
				 , MODEL_PIC
				 , ERP_SO_NO
				 , SHIP_DATE
				 , SHIP_QTY
			  FROM @XIF_PLM_SHIP_CONFIRM_S AS A                                                                                      
			 WHERE 1 = 1                                                                                                               

		END
		ELSE
		BEGIN

			declare @v_getdate   datetime = getdate();

		    SELECT @IF_GROUP_COUNT = COUNT(*)
              FROM @XIF_PLM_SHIP_CONFIRM_S
             WHERE LAST_UPDATE_DATE > dateadd(minute, -15, @v_getdate)

			INSERT INTO dbo.XIF_PLM_SHIP_CONFIRM_S_SN
				 ( IF_SEQ           
				 , IF_TYPE          
				 , IF_ID            
				 , IF_INS_DATE      
				 , IF_FLAG          
				 , IF_GROUP_ID
				 , IF_GROUP_COUNT
				 , CONFIRM_ID
				 , FCST_TYPE
				 , ITEM_ID
				 , NICK_NAME
				 , FROM_SITE
				 , TO_SITE
				 , END_CUSTOMER
				 , MKT_OWNER
				 , PLANNED_QTY
				 , YYYYMMDD
				 , TRANSPORT_MODE
				 , TO_SITE_SOLDTO_CODE
				 , TO_SITE_SHIPTO_CODE
				 , INCOTERMS
				 , LT_TOTAL
				 , ETD_DATE
				 , ETA_DATE
				 , EXPECTED_SHIPPING_DATE
				 , MODEL_PIC
				 , ERP_SO_NO
				 , SHIP_DATE
				 , SHIP_QTY
				 )
			SELECT IF_SEQ           
				 , IF_TYPE          
				 , IF_ID            
				 , IF_INS_DATE      
				 , IF_FLAG          
				 , @IF_GROUP_ID
				 , @IF_GROUP_COUNT
				 , CONFIRM_ID
				 , FCST_TYPE
				 , ITEM_ID
				 , NICK_NAME
				 , FROM_SITE
				 , TO_SITE
				 , END_CUSTOMER
				 , MKT_OWNER
				 , PLANNED_QTY
				 , YYYYMMDD
				 , TRANSPORT_MODE
				 , TO_SITE_SOLDTO_CODE
				 , TO_SITE_SHIPTO_CODE
				 , INCOTERMS
				 , LT_TOTAL
				 , ETD_DATE
				 , ETA_DATE
				 , EXPECTED_SHIPPING_DATE
				 , MODEL_PIC
				 , ERP_SO_NO
				 , SHIP_DATE
				 , SHIP_QTY
			  FROM @XIF_PLM_SHIP_CONFIRM_S AS A                                                                                      
			 WHERE 1 = 1                                                                                                               
			   AND A.LAST_UPDATE_DATE > dateadd(minute, -15, @v_getdate)

		END

		SET @v_insert_cnt = @@ROWCOUNT;
		SET @v_insert_sum = @v_insert_sum + @v_insert_cnt;

		-----------------------------------------------------------
		-- TXN LOG
		-----------------------------------------------------------
		SET @v_log_type		= N'TXN';    --로그타입  
		SET @n_log_count	= @v_insert_cnt; -- @@ROWCOUNT;
		SET @v_log_message	= N'INSERT INTO '+ @v_table_id;  
		SET @d_event_date	= SYSDATETIME();
		SET @v_description	= N'Process Complete...' + ':' + CONVERT(CHAR(23) ,@d_event_date ,121) + ' [DIVISION]: ' + @DIVISION_ID ;
					 
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name  
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

    END CATCH;

	-- Interface History Data Deleting
    DELETE FROM dbo.XIF_PLM_SHIP_CONFIRM_S_SN
	 WHERE IF_SND_DATE < convert(datetime, convert(varchar, getdate(), 112)) - 10

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
END;
