/***************************************************************************************************
 * Program ID   : PR_SSP_DNM_STOCK
 * Description  : scm_dnm_stock_v -> SSP_DNM_STOCK 1시간 배치 적용
 * OutTable     : 
 * Execute      : EXEC PR_SSP_DNM_STOCK
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021.05.14   SSP Pjt.       Create
 * 2021.07.12   SSP SM         [C20210706-000555][SCM PI] Shipment Plan(Auto ESS) ERP 재고 SLOC별 안보임 수정 
 * 2022.04.01   SSP Pjt.       JV DIVISION_ID 적용
 * 2023.09.11   jilee          MODEL_ID 추가 등록
 * 2026.08.07	강주용		   [E20260730-001507] 가상 Plant BOH를 받아오지 못함 (Cell, Pack)
****************************************************************************************************/

CREATE PROCEDURE [dbo].[PR_SSP_DNM_STOCK] 
AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user				NVARCHAR(150)	= N'ssp_batch';  

    DECLARE @v_program_name				NVARCHAR(150)	= N'PR_SSP_DNM_STOCK';
    DECLARE @v_log_type					NVARCHAR(30); 
    DECLARE @n_log_count				INTEGER = 0;
    DECLARE @v_log_message				NVARCHAR(1000);
    DECLARE @v_description				NVARCHAR(500);      -- ▶ 상세설명 
    DECLARE @v_table_id					NVARCHAR(150)	= N'SSP_DNM_STOCK_C'; -- ▶ 테이블 필수
    DECLARE @d_event_date				DATETIME;

	DECLARE @dm_req_cnt					INT = 0;	
	DECLARE @v_division_id              NVARCHAR(10);
    DECLARE @v_dm_req_no				NVARCHAR(60)	= '';

    DECLARE @v_start_time				DATETIME		= SYSDATETIME();
    DECLARE @v_exec_time				NVARCHAR(10)	= '';

	DECLARE @v_cutoff_date              date;

	DECLARE @INX		INT	= 0;
    DECLARE @MAX_NUM	INT	= 0;

	DECLARE @TAB   TABLE
	(
	 --   TID						INT IDENTITY(1,1)	NOT NULL PRIMARY KEY,
		[COMPANY_ID]	        [nvarchar](30)	not null INDEX VIX_TAB_01([COMPANY_ID],[DIVISION_ID],[PLANT_ID]	,[STORAGE_ID],[CUTOFF_DATE],[STOCK_TYPE],[ITEM_ID],[SCM_SITE_ID]),
		[DIVISION_ID]	        [nvarchar](30)	not null,
		[PLANT_ID]		        [nvarchar](30)	not null,
		[STORAGE_ID]	        [nvarchar](30)	not null,
		[CUTOFF_DATE]	        [date]			not null,
		[STOCK_TYPE]	        [nvarchar](30)	not null,
		[ITEM_ID]		        [nvarchar](150) not null,
		[SCM_SITE_ID]	        [nvarchar](30)	not null,
		[SITE_ID]               [nvarchar](30)  null,
		[OPERATION_ID]          [nvarchar](30)  null,
		[QTY_UOM]               [nvarchar](10)	null,
		[WIPHOLD_YN]            [nvarchar](1)	null,
		[HOLDING_DATE]          [datetime]		null,
		[AVAILABLE_DATE]        [datetime]		null,
		[OUTSOURCING_FLAG]      [nvarchar](1)	null,
		[OUTSOURCING_FACTORY]   [nvarchar](30)	null,
		[SCM_QTY]		        [numeric](28, 10) null,
		[SSP_QTY]	            [numeric](28, 10) null,
		[MOVING_QTY]            [numeric](28, 10) null,
		[DEFECT_QTY]            [numeric](28, 10) null,
		[MODEL_ID]		        [nvarchar](150)  null
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

		SELECT @v_cutoff_date = max(cutoff_date)
		  FROM [dbo].[SCM_DNM_STOCK_SN] with(nolock)
		 WHERE DIVISION_ID  IN ('81', '82')
		   AND DATEADD(DAY,1,cutoff_date) >  convert(varchar, getdate() - 3, 112) -- 현재일 - 3
		   AND DATEADD(DAY,1,cutoff_date) <= convert(varchar, getdate(), 112) -- 변수 : 현재일
		   AND STOCK_TYPE IN ('INVENTORY', 'WIP')

		INSERT INTO @TAB (
	           [COMPANY_ID]	 	
			  ,[DIVISION_ID]	 
			  ,[PLANT_ID]		 
			  ,[STORAGE_ID]	 
			  ,[CUTOFF_DATE]	 
			  ,[STOCK_TYPE]	 
			  ,[ITEM_ID]		 
			  ,[SCM_SITE_ID]
			  ,[SITE_ID]            
			  ,[OPERATION_ID]       
			  ,[QTY_UOM]            
			  ,[WIPHOLD_YN]         
			  ,[HOLDING_DATE]       
			  ,[AVAILABLE_DATE]     
			  ,[OUTSOURCING_FLAG]   
			  ,[OUTSOURCING_FACTORY]
			  ,[SCM_QTY]		 
			  ,[SSP_QTY]	     
			  ,[MOVING_QTY]     
			  ,[DEFECT_QTY]
			  ,[MODEL_ID]
			  )
        SELECT FP.[COMPANY_ID]	 	
			  ,FP.[DIVISION_ID]	 
			  ,FP.[PLANT_ID]		 
			  ,FP.[STORAGE_ID]	 
			  ,FP.cutoff_date 
			  ,FP.[STOCK_TYPE]	 
			  ,FP.[ITEM_ID]		 
			  ,ISNULL(FP.[SCM_SITE_ID],'-')
              ,FP.[SITE_ID]      
              ,FP.[OPERATION_ID]      
              ,FP.[QTY_UOM]          
              ,FP.[WIPHOLD_YN]        
              ,FP.[HOLDING_DATE]     
              ,FP.[AVAILABLE_DATE]  
              ,FP.[OUTSOURCING_FLAG]
              ,FP.[OUTSOURCING_FACTORY]		 
			  ,SUM(ISNULL(FP.[SCM_QTY],0))		 
			  ,SUM(ISNULL(FP.[SSP_QTY],0))	     
			  ,SUM(ISNULL(FP.[MOVING_QTY],0))     
			  ,SUM(ISNULL(FP.[DEFECT_QTY],0))
			  ,IM.APPLIED_MODEL
          FROM dbo.scm_dnm_stock_v FP WITH(NOLOCK)
		  LEFT OUTER JOIN [dbo].SCM_MST_ITEM_SN IM WITH(NOLOCK) 
			ON   IM.DIVISION_ID = FP.DIVISION_ID							   
			AND  IM.COMPANY_ID = FP.COMPANY_ID
			AND  IM.SITE_ID = FP.SITE_ID
			AND  IM.ITEM_ID = FP.ITEM_ID
			AND  IM.ITEM_CLASS IN ('ES1901', 'ES2001','ES2002', 'ES2003', 'ES2004')	
         WHERE FP.DIVISION_ID  IN (SELECT DIVISION_ID
                                     FROM SCM_MST_DIVISION WITH(NOLOCK)
                                    WHERE VALID_YN = 'Y'
                                      AND ATTRIBUTE3 IN ('81','82','40') )
		   AND FP.cutoff_date		= @v_cutoff_date
		   AND FP.ITEM_ID IS NOT NULL
	     GROUP BY
			   FP.[COMPANY_ID]	
			  ,FP.[DIVISION_ID]	
			  ,FP.[PLANT_ID]		
			  ,FP.[STORAGE_ID]	
			  ,FP.[CUTOFF_DATE]	
			  ,FP.[STOCK_TYPE]	
		      ,FP.[ITEM_ID]		
			  ,FP.[SCM_SITE_ID]	
			  ,FP.[SITE_ID]            
			  ,FP.[OPERATION_ID]       
			  ,FP.[QTY_UOM]            
			  ,FP.[WIPHOLD_YN]         
			  ,FP.[HOLDING_DATE]       
			  ,FP.[AVAILABLE_DATE]     
			  ,FP.[OUTSOURCING_FLAG]   
			  ,FP.[OUTSOURCING_FACTORY]
			  ,IM.[APPLIED_MODEL]

		-- OWMS 재고 SCM_SITE_ID 적용
	    UPDATE FP
           SET FP.SCM_SITE_ID = SITE.SCM_SITE_ID
		  FROM @TAB AS FP
			   JOIN (
				    SELECT DISTINCT MS.COMPANY_ID
						  ,MS.DIVISION_ID
						  ,MS.SITE_ID
						  ,ML.FACTORY_ID
						  ,ML.PLANT_ID
						  ,ML.STORAGE_ID
						  ,MS.SCM_SITE_ID
						  ,ML.LOCATION_CODE 
						  ,MS.OPERATION_GROUP 
					  FROM SCM_MST_SITE		AS MS WITH(NOLOCK)
					       JOIN SSP_MST_LOCATION_V	AS ML WITH(NOLOCK)
					    ON MS.DIVISION_ID = ML.DIVISION_ID
					   AND MS.SCM_SITE_ID = ML.SCM_SITE_ID
					       JOIN SCM_MST_DIVISION	AS D WITH(NOLOCK)
						ON MS.DIVISION_ID = D.DIVISION_ID
					 WHERE MS.VALID_YN    = 'Y'
					   AND ML.VALID_YN    = 'Y'
					   AND ISNULL(ML.STORAGE_ID, '') <> '' 
					   AND ML.LOCATION_CODE IN ('CELL_OWMS', 'PACK_OWMS', 'FORMATION_CHECK_PACKAGING','CMA_BMA')
					   AND MS.VMI_YN = CASE D.ATTRIBUTE3   WHEN '40' THEN 'N' 
														   WHEN '81' THEN 'N' 
														   ELSE MS.VMI_YN 
									   END 
				    ) SITE
		    ON FP.COMPANY_ID		= [DBO].[FN_SCM_SYS_NVL](SITE.COMPANY_ID, FP.COMPANY_ID) 
		   AND FP.DIVISION_ID		= SITE.DIVISION_ID
		   AND FP.SITE_ID			= [DBO].[FN_SCM_SYS_NVL](SITE.SITE_ID, FP.SITE_ID) 
		   AND FP.PLANT_ID			= SITE.PLANT_ID 
		   AND FP.STORAGE_ID		= SITE.STORAGE_ID	
		   --AND FP.STORAGE_ID	IN (SELECT TOKEN FROM DBO.UF_FX_STRING_SPLIT(SITE.STORAGE_ID,','))
		   -- START [E20260730-001507] 가상 Plant BOH를 받아오지 못함 (Cell, Pack)
		   /*
			   JOIN SCP_MST_FINAL_ITEM AS ITEM with(nolock)
            ON FP.DIVISION_ID       = ITEM.DIVISION_ID
		   AND FP.ITEM_ID           = ITEM.ITEM_ID
		   AND ITEM.OPERATION_GROUP = SITE.OPERATION_GROUP
		   */
		   AND SITE.OPERATION_GROUP = DBO.FN_GET_ITEM_OPERATION_GROUP(FP.DIVISION_ID, FP.ITEM_ID) 
		   -- END [E20260730-001507] 가상 Plant BOH를 받아오지 못함 (Cell, Pack)
         WHERE FP.STOCK_TYPE		= 'INVENTORY'
           AND FP.SCM_SITE_ID		= '-'

		-- START [E20260730-001507] 가상 Plant BOH를 받아오지 못함 (Cell, Pack) - 가상플렌트 데이터 추가
		INSERT INTO @TAB (
	           [COMPANY_ID]	 	
			  ,[DIVISION_ID]	 
			  ,[PLANT_ID]		 
			  ,[STORAGE_ID]	 
			  ,[CUTOFF_DATE]	 
			  ,[STOCK_TYPE]	 
			  ,[ITEM_ID]		 
			  ,[SCM_SITE_ID]
			  ,[SITE_ID]            
			  ,[OPERATION_ID]       
			  ,[QTY_UOM]            
			  ,[WIPHOLD_YN]         
			  ,[HOLDING_DATE]       
			  ,[AVAILABLE_DATE]     
			  ,[OUTSOURCING_FLAG]   
			  ,[OUTSOURCING_FACTORY]
			  ,[SCM_QTY]		 
			  ,[SSP_QTY]	     
			  ,[MOVING_QTY]     
			  ,[DEFECT_QTY]
			  ,[MODEL_ID]
			  )
		   SELECT [COMPANY_ID]	 	
			  ,[VP_DIVISION_ID]	 
			  ,[VP_PLANT_ID]		 
			  ,[STORAGE_ID]	 
			  ,[CUTOFF_DATE]	 
			  ,[STOCK_TYPE]	 
			  ,[ITEM_ID]		 
			  ,[VP_SCM_SITE_ID]
			  ,[SITE_ID]            
			  ,[OPERATION_ID]       
			  ,[QTY_UOM]            
			  ,[WIPHOLD_YN]         
			  ,[HOLDING_DATE]       
			  ,[AVAILABLE_DATE]     
			  ,[OUTSOURCING_FLAG]   
			  ,[OUTSOURCING_FACTORY]
			  ,[SCM_QTY]		 
			  ,[SSP_QTY]	     
			  ,[MOVING_QTY]     
			  ,[DEFECT_QTY]
			  ,[MODEL_ID] 
			  FROM (
				  SELECT [COMPANY_ID]	 	
					  ,[VP_DIVISION_ID]	 
					  ,[VP_PLANT_ID]		 
					  ,[STORAGE_ID]	 
					  ,[CUTOFF_DATE]	 
					  ,[STOCK_TYPE]	 
					  ,[ITEM_ID]		 
					  ,[VP_SCM_SITE_ID]
					  ,[SITE_ID]            
					  ,[OPERATION_ID]       
					  ,[QTY_UOM]            
					  ,[WIPHOLD_YN]         
					  ,[HOLDING_DATE]       
					  ,[AVAILABLE_DATE]     
					  ,[OUTSOURCING_FLAG]   
					  ,[OUTSOURCING_FACTORY]
					  ,[SCM_QTY]		 
					  ,[SSP_QTY]	     
					  ,[MOVING_QTY]     
					  ,[DEFECT_QTY]
					  ,[MODEL_ID] 
					 FROM @tab FP
					INNER JOIN FN_GET_JV_REAL_ESS_VIRTUAL_SITE_MAP() MP
					ON FP.DIVISION_iD = MP.RP_DIVISION_ID
					AND FP.PLANT_ID = MP.RP_PLANT_ID
					AND FP.SCM_SITE_ID = MP.RP_SCM_SITE_ID
			  ) FP
			  WHERE 1=1	
			  AND NOT EXISTS (SELECT 1 -- 이미 생성되어 있는 가상플렌트 데이터 중복 제거(STOCK TYPE  = WIP)
							   FROM @tab OFP
							  WHERE FP.[COMPANY_ID]			 = OFP.[COMPANY_ID]	
								AND FP.[VP_DIVISION_ID]		 = OFP.[DIVISION_ID]	
								AND FP.[VP_PLANT_ID]		 = OFP.[PLANT_ID]		
								AND FP.[STORAGE_ID]			 = OFP.[STORAGE_ID]	
								AND FP.[CUTOFF_DATE]		 = OFP.[CUTOFF_DATE]	
								AND FP.[STOCK_TYPE]			 = OFP.[STOCK_TYPE]	
								AND FP.[ITEM_ID]			 = OFP.[ITEM_ID]		
								AND FP.[VP_SCM_SITE_ID]		 = OFP.[SCM_SITE_ID]	
								AND ISNULL(FP.[SITE_ID],'')             = ISNULL(OFP.[SITE_ID],'')
								AND ISNULL(FP.[OPERATION_ID],'')        = ISNULL(OFP.[OPERATION_ID],'')
								AND ISNULL(FP.[QTY_UOM],'')             = ISNULL(OFP.[QTY_UOM],'')
								AND ISNULL(FP.[WIPHOLD_YN],'')          = ISNULL(OFP.[WIPHOLD_YN],'')
								AND ISNULL(FP.[HOLDING_DATE],'')        = ISNULL(OFP.[HOLDING_DATE],'')
								AND ISNULL(FP.[AVAILABLE_DATE],'')      = ISNULL(OFP.[AVAILABLE_DATE],'')     
								AND ISNULL(FP.[OUTSOURCING_FLAG],'')    = ISNULL(OFP.[OUTSOURCING_FLAG],'')   
								AND ISNULL(FP.[OUTSOURCING_FACTORY],'') = ISNULL(OFP.[OUTSOURCING_FACTORY],'')
								AND ISNULL(FP.[MODEL_ID],'')			= ISNULL(OFP.[MODEL_ID],'')
							  )

		-- END [E20260730-001507] 가상 Plant BOH를 받아오지 못함 (Cell, Pack)

		----BEGIN TRAN TX_SH

		MERGE INTO [dbo].[SSP_DNM_STOCK_C] T
		USING @TAB AS S
		   ON T.[COMPANY_ID]			= S.[COMPANY_ID]	
		  AND T.[DIVISION_ID]			= S.[DIVISION_ID]	
		  AND T.[PLANT_ID]			    = S.[PLANT_ID]	
		  AND T.[STORAGE_ID]			= S.[STORAGE_ID]	
		  AND T.[CUTOFF_DATE]			= S.[CUTOFF_DATE]	
		  AND T.[STOCK_TYPE]			= S.[STOCK_TYPE]	
		  AND T.[ITEM_ID]				= S.[ITEM_ID]		
		  AND T.[SCM_SITE_ID]			= S.[SCM_SITE_ID]	
		  AND ISNULL(T.[SITE_ID]            ,'')    = ISNULL(S.[SITE_ID]            ,'')        
		  AND ISNULL(T.[OPERATION_ID]       ,'')	= ISNULL(S.[OPERATION_ID]       ,'')
		  AND ISNULL(T.[QTY_UOM]            ,'')	= ISNULL(S.[QTY_UOM]            ,'')
		  AND ISNULL(T.[WIPHOLD_YN]         ,'')	= ISNULL(S.[WIPHOLD_YN]         ,'')
		  AND ISNULL(T.[HOLDING_DATE]       ,'')	= ISNULL(S.[HOLDING_DATE]       ,'')
		  AND ISNULL(T.[AVAILABLE_DATE]     ,'')	= ISNULL(S.[AVAILABLE_DATE]     ,'')
		  AND ISNULL(T.[OUTSOURCING_FLAG]   ,'')	= ISNULL(S.[OUTSOURCING_FLAG]   ,'')
		  AND ISNULL(T.[OUTSOURCING_FACTORY],'')	= ISNULL(S.[OUTSOURCING_FACTORY],'')
		WHEN MATCHED THEN
			UPDATE 
			   SET T.[SCM_QTY]				= S.[SCM_QTY]	
				  ,T.[SSP_QTY]				= S.[SSP_QTY]	
				  ,T.[MOVING_QTY] 			= S.[MOVING_QTY] 
				  ,T.[DEFECT_QTY] 			= S.[DEFECT_QTY] 
		          ,T.LAST_UPDATED_BY		= @v_batch_user
			      ,T.LAST_UPDATE_DATE		= GETDATE()	
	    WHEN NOT MATCHED THEN
			INSERT (	
			  	   [COMPANY_ID]	 	
			  	  ,[DIVISION_ID]	
			  	  ,[PLANT_ID]		
			  	  ,[STORAGE_ID]	 
			  	  ,[CUTOFF_DATE]	
			  	  ,[STOCK_TYPE]	 
			  	  ,[ITEM_ID]		
			      ,[SCM_SITE_ID]	
                  ,[SITE_ID]      
                  ,[OPERATION_ID]      
                  ,[QTY_UOM]          
                  ,[WIPHOLD_YN]        
                  ,[HOLDING_DATE]     
                  ,[AVAILABLE_DATE]  
                  ,[OUTSOURCING_FLAG]
                  ,[OUTSOURCING_FACTORY]
			      ,[SCM_QTY]		
			      ,[SSP_QTY]	    
			      ,[MOVING_QTY]     
				  ,[DEFECT_QTY]     
	              ,[CREATED_BY]		    
	              ,[CREATION_DATE]		
	              ,[LAST_UPDATED_BY]	
	              ,[LAST_UPDATE_DATE]	
				  ,[ATTRIBUTE1]
				  )
		   VALUES (
			  	   S.[COMPANY_ID]	 	
			  	  ,S.[DIVISION_ID]	
			  	  ,S.[PLANT_ID]		
			  	  ,S.[STORAGE_ID]	 
			  	  ,S.[CUTOFF_DATE]	
			  	  ,S.[STOCK_TYPE]	 
			  	  ,S.[ITEM_ID]		
				  ,S.[SCM_SITE_ID]
                  ,S.[SITE_ID]      
                  ,S.[OPERATION_ID]      
                  ,S.[QTY_UOM]          
                  ,S.[WIPHOLD_YN]        
                  ,S.[HOLDING_DATE]     
                  ,S.[AVAILABLE_DATE]  
                  ,S.[OUTSOURCING_FLAG]
                  ,S.[OUTSOURCING_FACTORY]				  
				  ,S.[SCM_QTY]		
				  ,S.[SSP_QTY]	    
				  ,S.[MOVING_QTY]     
				  ,S.[DEFECT_QTY]     
			      ,@v_batch_user      
			      ,GETDATE()          
			      ,@v_batch_user      
			      ,GETDATE()
				  ,S.[MODEL_ID]
				  );

		DELETE T
		  FROM [dbo].[SSP_DNM_STOCK_C] AS T WITH(NOLOCK)
		       LEFT OUTER JOIN @TAB AS S
		    ON S.[COMPANY_ID]			= T.[COMPANY_ID]	
		   AND S.[DIVISION_ID]			= T.[DIVISION_ID]	
		   AND S.[PLANT_ID]			    = T.[PLANT_ID]	
		   AND S.[STORAGE_ID]			= T.[STORAGE_ID]	
		   AND S.[CUTOFF_DATE]			= T.[CUTOFF_DATE]	
		   AND S.[STOCK_TYPE]			= T.[STOCK_TYPE]	
		   AND S.[ITEM_ID]				= T.[ITEM_ID]		
		   AND S.[SCM_SITE_ID]			= T.[SCM_SITE_ID]
		   AND ISNULL(S.[SITE_ID]            ,'')   = ISNULL(T.[SITE_ID]            ,'')        
		   AND ISNULL(S.[OPERATION_ID]       ,'')	= ISNULL(T.[OPERATION_ID]       ,'')
		   AND ISNULL(S.[QTY_UOM]            ,'')	= ISNULL(T.[QTY_UOM]            ,'')
		   AND ISNULL(S.[WIPHOLD_YN]         ,'')	= ISNULL(T.[WIPHOLD_YN]         ,'')
		   AND ISNULL(S.[HOLDING_DATE]       ,'')	= ISNULL(T.[HOLDING_DATE]       ,'')
		   AND ISNULL(S.[AVAILABLE_DATE]     ,'')	= ISNULL(T.[AVAILABLE_DATE]     ,'')
		   AND ISNULL(S.[OUTSOURCING_FLAG]   ,'')	= ISNULL(T.[OUTSOURCING_FLAG]   ,'')
		   AND ISNULL(S.[OUTSOURCING_FACTORY],'')	= ISNULL(T.[OUTSOURCING_FACTORY],'')
		 WHERE S.DIVISION_ID IS NULL
		   AND T.CUTOFF_DATE            = @v_cutoff_date


        DELETE 
		  FROM [dbo].[SSP_DNM_STOCK_C]
		 WHERE CUTOFF_DATE < convert(datetime,@v_cutoff_date) - 30
		 ;

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
		SET @v_description	= @v_program_name + N' ERROR_LINE : ' + STR(ERROR_LINE());
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

