



/*      
 * Program ID  : [PR_SCP_MST_CELL_PROD_ASSY_MAP]      
 * Description : Cell Product/Cell Assy 매핑 정보 생성 

	* 매핑 케이스 
		1. Cell Product - Cell Assy1
		   - Cell Product - Cell Assy1
		2. TCO Cell Product - Cell Product - Cell Assy1
		   - TCO Cell Product - Cell Assy1
		   - Cell Product - Cell Assy1
		3. TCO Cell Product - Cell Assy2 - Cell Assy1
		   - TCO Cell Product - Cell Assy2
		   - TCO Cell Product - Cell Assy12023

	* source table : SCM_MST_BOM_SN
	* target table : SCP_MST_CELL_PROD_ASSY_MAP
 *
 * Program History      
 *============================================================================================================================      
 *   Date		In Charge	Description      
 *============================================================================================================================      
 * 2023/06/12	hrkim		Initial Release  [PJ20230691] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화코드 분리 대응
 *   현재 한국만 생성 : 8월에 전체 생성으로 수정 필요함     
 * 2023/07/12	hrkim		[PJ20230691] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화코드 분리 대응 - 전체 생성으로 수정
 * 2023/12/18	hrkim		성능 이슈 대응 구조 변경 
 * 
*/

CREATE PROCEDURE [dbo].[PR_SCP_MST_CELL_PROD_ASSY_MAP]
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_MST_CELL_PROD_ASSY_MAP'; --Proc별 이름 설정
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @v_batch_user   NVARCHAR(150) = N'scm_batch'; 

	-- 임시 실행시간 확인용              
    DECLARE @v_start_time   DATETIME   = SYSDATETIME();              
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';    

	BEGIN TRY
		BEGIN

			-- 시작 LOG  (START)
			SET @v_log_type = 'START';
			SET @v_log_message = '##### Start of procedure #####';  
			SET @v_description = CONVERT(NVARCHAR(8),'',112) ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			SET @v_log_message = NULL      /*-- < - 변수 재사용을 위하여 초기화해야함 --*/
			-- 시작 LOG  (END)

/* 2023.12.18 변경전 
			---------------------------------------------------------------------------------------------------------------------------------------
			PRINT convert(varchar(30), getdate(), 121) +  N' ### 1 #tmp_CELL_PROD_ASSY_MAP 추출 - 대상 데이터 추출'
			---------------------------------------------------------------------------------------------------------------------------------------
			IF  OBJECT_ID('tempdb..#tmp_CELL_PROD_ASSY_MAP')  IS NOT NULL
				DROP TABLE #tmp_CELL_PROD_ASSY_MAP ; 

			SELECT *
			  INTO #tmp_CELL_PROD_ASSY_MAP
			 FROM (
					-- Parent - Child 구조
					SELECT DISTINCT B.DIVISION_ID
								  , B.PLANT_ID
								  , B.PARENT_ITEM_ID	AS CELL_PROD
								  , B.CHILD_ITEM_ID		AS CELL_ASSY
								  , FA.ATTRIBUTE8		AS CELL_TYPE
					FROM SCM_MST_BOM_SN B WITH(NOLOCK)
						INNER JOIN  SCM_MST_ITEM_SN P WITH(NOLOCK)	-- parent 
								ON P.DIVISION_ID		 = B.DIVISION_ID
							   AND P.COMPANY_ID			 = B.COMPANY_ID
							   AND P.SITE_ID			 = B.SITE_ID
							   AND P.ITEM_ID			 = B.PARENT_ITEM_ID
							   AND P.ACTIVE_FLAG		 = 'Y'
							   AND P.SCP_OPERATION_GROUP = 'A'
						INNER JOIN SCP_MST_FINAL_ITEM FP WITH(NOLOCK)
								ON FP.DIVISION_ID		 = B.DIVISION_ID
							   AND FP.ITEM_ID			 = B.PARENT_ITEM_ID
							   AND FP.ATTRIBUTE8		 = 'CP'
						INNER JOIN SCM_MST_ITEM_SN C WITH(NOLOCK)       -- child
								ON C.DIVISION_ID		 = B.DIVISION_ID
							   AND C.COMPANY_ID			 = B.COMPANY_ID
							   AND C.SITE_ID			 = B.SITE_ID
							   AND C.ITEM_ID			 = B.CHILD_ITEM_ID
							   AND C.ACTIVE_FLAG		 = 'Y'
							   AND C.SCP_OPERATION_GROUP = 'A'
						INNER JOIN SCP_MST_FINAL_ITEM FA WITH(NOLOCK)
								ON FA.DIVISION_ID		= B.DIVISION_ID
							   AND FA.ITEM_ID			= B.CHILD_ITEM_ID
							   AND FA.ATTRIBUTE8		IN ('CA1', 'CA2')
					WHERE 1=1
			-- 현재 한국만 생성 : 8월에 전체 생성으로 수정 필요함
			--AND B.company_id = 'C100'
					UNION ALL
					-- Model ID 하위 Cell Assy 전체 (Model과 Parent가 같은 건 제외 : Parent-Child 구조 결과에 포함됨) 
					SELECT DISTINCT B.DIVISION_ID
								  , B.PLANT_ID
								  , B.MODEL_ID			AS CELL_PROD
								  , B.CHILD_ITEM_ID		AS CELL_ASSY
								  , FA.ATTRIBUTE8		AS CELL_TYPE
					FROM SCM_MST_BOM_SN B WITH(NOLOCK)
						INNER JOIN  SCM_MST_ITEM_SN P WITH(NOLOCK)	-- model 
								ON P.DIVISION_ID		 = B.DIVISION_ID
							   AND P.COMPANY_ID			 = B.COMPANY_ID
							   AND P.SITE_ID			 = B.SITE_ID
							   AND P.ITEM_ID			 = B.MODEL_ID
							   AND P.ACTIVE_FLAG		 = 'Y'
							   AND P.SCP_OPERATION_GROUP = 'A'
						INNER JOIN SCP_MST_FINAL_ITEM FP WITH(NOLOCK)
								ON FP.DIVISION_ID		 = B.DIVISION_ID
							   AND FP.ITEM_ID			 = B.MODEL_ID
							   AND FP.ATTRIBUTE8		 = 'CP'
						INNER JOIN SCM_MST_ITEM_SN C WITH(NOLOCK)       -- child
								ON C.DIVISION_ID		 = B.DIVISION_ID
							   AND C.COMPANY_ID			 = B.COMPANY_ID
							   AND C.SITE_ID			 = B.SITE_ID
							   AND C.ITEM_ID			 = B.CHILD_ITEM_ID
							   AND C.ACTIVE_FLAG		 = 'Y'
							   AND C.SCP_OPERATION_GROUP = 'A'
						INNER JOIN SCP_MST_FINAL_ITEM FA WITH(NOLOCK)
								ON FA.DIVISION_ID		= B.DIVISION_ID
							   AND FA.ITEM_ID			= B.CHILD_ITEM_ID
							   AND FA.ATTRIBUTE8		IN ('CA1', 'CA2')
					WHERE 1=1
			-- 현재 한국만 생성 : 8월에 전체 생성으로 수정 필요함
			--AND B.company_id = 'C100'
					  AND B.PARENT_ITEM_ID	 != B.MODEL_ID -- Parent - Child 구조 제외 
				) AS TG 
*/
			---------------------------------------------------------------------------------------------------------------------------------------
			PRINT convert(varchar(30), getdate(), 121) +  N' ### 0.1 #tmp_CELL_PROD 추출 - Cell Product'
			---------------------------------------------------------------------------------------------------------------------------------------
			IF  OBJECT_ID('tempdb..#tmp_CELL_PROD')  IS NOT NULL
				DROP TABLE #tmp_CELL_PROD ; 

			SELECT FC.DIVISION_ID	AS DIVISION_ID_CP
				  ,FC.ITEM_ID		AS ITEM_ID_CP
				  ,P.COMPANY_ID		AS COMPANY_ID_CP
				  ,P.SITE_ID		AS SITE_ID_CP
			 INTO #tmp_CELL_PROD
			 FROM SCP_MST_FINAL_ITEM FC WITH(NOLOCK)
				  INNER JOIN SCM_MST_ITEM_SN P WITH(NOLOCK)
						  ON P.DIVISION_ID			= FC.DIVISION_ID
						 AND P.ITEM_ID				= FC.ITEM_ID
						 AND P.ACTIVE_FLAG			= 'Y'
						 AND P.SCP_OPERATION_GROUP	= 'A'
			WHERE 1=1
			  AND FC.ATTRIBUTE8		= 'CP'

			---------------------------------------------------------------------------------------------------------------------------------------
			PRINT convert(varchar(30), getdate(), 121) +  N' ### 0.1 #tmp_CELL_ASSY 추출 - Cell Assy'
			---------------------------------------------------------------------------------------------------------------------------------------
			IF  OBJECT_ID('tempdb..#tmp_CELL_ASSY')  IS NOT NULL
				DROP TABLE #tmp_CELL_ASSY ; 

			SELECT FA.DIVISION_ID	AS DIVISION_ID_CA
				  ,FA.ITEM_ID		AS ITEM_ID_CA
				  ,FA.ATTRIBUTE8	AS CELL_TYPE
				  ,C.COMPANY_ID		AS COMPANY_ID_CA
				  ,C.SITE_ID		AS SITE_ID_CA
			 INTO #tmp_CELL_ASSY
			 FROM SCP_MST_FINAL_ITEM FA WITH(NOLOCK)
				  INNER JOIN SCM_MST_ITEM_SN C WITH(NOLOCK)
						  ON C.DIVISION_ID			= FA.DIVISION_ID
						 AND C.ITEM_ID				= FA.ITEM_ID
						 AND C.ACTIVE_FLAG			= 'Y'
						 AND C.SCP_OPERATION_GROUP	= 'A'
			WHERE 1=1
			  AND FA.ATTRIBUTE8		IN ('CA1', 'CA2')

			---------------------------------------------------------------------------------------------------------------------------------------
			PRINT convert(varchar(30), getdate(), 121) +  N' ### 1 #tmp_CELL_PROD_ASSY_MAP 추출 - 대상 데이터 추출'
			---------------------------------------------------------------------------------------------------------------------------------------
			IF  OBJECT_ID('tempdb..#tmp_CELL_PROD_ASSY_MAP')  IS NOT NULL
				DROP TABLE #tmp_CELL_PROD_ASSY_MAP ; 

			SELECT *
			  INTO #tmp_CELL_PROD_ASSY_MAP
			 FROM (
				-- Parent - Child 구조
				SELECT DISTINCT B.DIVISION_ID
							  , B.PLANT_ID
							  , B.PARENT_ITEM_ID	AS CELL_PROD
							  , B.CHILD_ITEM_ID		AS CELL_ASSY
							  , CA.CELL_TYPE
				FROM #tmp_CELL_ASSY CA WITH(NOLOCK) 
					 INNER	JOIN SCM_MST_BOM_SN B WITH(NOLOCK)
							  ON B.CHILD_ITEM_ID = CA.ITEM_ID_CA
							 AND B.DIVISION_ID   = CA.DIVISION_ID_CA
					 INNER  JOIN #tmp_CELL_PROD CP WITH(NOLOCK)
							  ON CP.ITEM_ID_CP		= B.PARENT_ITEM_ID
							 AND CP.DIVISION_ID_CP	= B.DIVISION_ID
				WHERE 1=1
				UNION ALL 
				SELECT DISTINCT B.DIVISION_ID
							  , B.PLANT_ID
							  , B.MODEL_ID			AS CELL_PROD
							  , B.CHILD_ITEM_ID		AS CELL_ASSY
							  , CA.CELL_TYPE
				FROM #tmp_CELL_ASSY CA WITH(NOLOCK) 
					 INNER	JOIN SCM_MST_BOM_SN B WITH(NOLOCK)
							  ON B.CHILD_ITEM_ID = CA.ITEM_ID_CA
							 AND B.DIVISION_ID   = CA.DIVISION_ID_CA
							 AND B.COMPANY_ID	 = CA.COMPANY_ID_CA
							 AND B.SITE_ID		 = CA.SITE_ID_CA
					 INNER  JOIN #tmp_CELL_PROD CP WITH(NOLOCK)
							  ON B.MODEL_ID		=  CP.ITEM_ID_CP		
							 AND B.DIVISION_ID	=  CP.DIVISION_ID_CP	
							 AND B.COMPANY_ID	=  CP.COMPANY_ID_CP    
							 AND B.SITE_ID		=  CP.SITE_ID_CP	    
				WHERE 1=1
				  AND B.PARENT_ITEM_ID	 != B.MODEL_ID -- Parent - Child 구조 제외 
			) AS SRC

		--------------------------------------------------------------- 최종 테이블에 반영 --------------------------------------------------------------

		BEGIN TRAN

			---------------------------------------------------------------------------------------------------------------------------------------------
			PRINT convert(varchar(30), getdate(), 121) +  N' ### 2.1 대상에 없는 기 생성 데이터 VALID_YN 업데이트 '
			---------------------------------------------------------------------------------------------------------------------------------------------
			UPDATE TGT 
			   SET TGT.VALID_YN = 'N'
			      ,TGT.LAST_UPDATE_DATE = GETDATE()
				  ,TGT.LAST_UPDATED_BY  = @v_program_name 
			  FROM SCP_MST_CELL_PROD_ASSY_MAP TGT WITH(NOLOCK)
			WHERE 1=1
			  AND TGT.VALID_YN = 'Y'
			  AND NOT EXISTS ( SELECT  TOP 1 *
							   FROM #tmp_CELL_PROD_ASSY_MAP F
							  WHERE F.DIVISION_ID	= TGT.DIVISION_ID
								AND F.PLANT_ID		= TGT.PLANT_ID
								AND F.CELL_PROD		= TGT.ITEM_ID_PROD
								AND F.CELL_ASSY		= TGT.ITEM_ID_ASSY
								) 
			;

			-----------------------------------------------------------------------------------------------------------------------------------------------
			PRINT convert(varchar(30), getdate(), 121) +  N' ### 2.2 MERGE INTO (UPDATE / INSERT) '
			-----------------------------------------------------------------------------------------------------------------------------------------------
			MERGE INTO SCP_MST_CELL_PROD_ASSY_MAP TGT 
			USING ( 
				SELECT F.DIVISION_ID
					  ,F.PLANT_ID
					  ,F.CELL_PROD	AS ITEM_ID_PROD
					  ,F.CELL_ASSY	AS ITEM_ID_ASSY
					  ,F.CELL_TYPE	
				FROM #tmp_CELL_PROD_ASSY_MAP F
				WHERE 1=1
				  AND NOT EXISTS ( 
								-- TGT와 동일한 값으로 존재하는 건 제외 (VALID_YN = 'Y')
								SELECT *
								  FROM SCP_MST_CELL_PROD_ASSY_MAP T
								 WHERE 1=1
								   AND T.DIVISION_ID	= F.DIVISION_ID
								   AND T.PLANT_ID		= F.PLANT_ID
								   AND T.ITEM_ID_PROD	= F.CELL_PROD
								   AND T.ITEM_ID_ASSY	= F.CELL_ASSY
								   AND T.CELL_TYPE		= F.CELL_TYPE
								   AND T.VALID_YN		= 'Y'
								)
			) SRC
			 ON (
					TGT.DIVISION_ID		= SRC.DIVISION_ID
				AND TGT.PLANT_ID		= SRC.PLANT_ID
				AND TGT.ITEM_ID_PROD	= SRC.ITEM_ID_PROD
				AND TGT.ITEM_ID_ASSY	= SRC.ITEM_ID_ASSY
				)
			WHEN MATCHED THEN
				 UPDATE SET LAST_UPDATE_DATE	= GETDATE()
						   ,LAST_UPDATED_BY		= @v_program_name
						   ,VALID_YN			= 'Y'
						   ,CELL_TYPE			= SRC.CELL_TYPE
			WHEN NOT MATCHED THEN 
					INSERT (
							 DIVISION_ID
							,PLANT_ID
							,ITEM_ID_PROD
							,ITEM_ID_ASSY
							,CELL_TYPE
							,VALID_YN 
							,CREATED_BY
							,CREATION_DATE 
							,LAST_UPDATED_BY
							,LAST_UPDATE_DATE 
					)
					VALUES ( SRC.DIVISION_ID
							,SRC.PLANT_ID
							,SRC.ITEM_ID_PROD
							,SRC.ITEM_ID_ASSY
							,SRC.CELL_TYPE
							,'Y'					-- VALID_YN
							,@v_program_name		-- created_by
							,GETDATE()				-- creation_date 
							,@v_program_name		-- last_updated_by
							,GETDATE()				-- last_update_date 
							);

			COMMIT TRAN
				  
		END			    
    END TRY

    BEGIN CATCH                  

		if (xact_state() <> 0) ROLLBACK TRAN; 

		-- ERROR LOG                  
		SET @v_log_type = N'ERROR';                  
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));                  
		SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE());                  
		SET @d_event_date = SYSDATETIME();                  
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name                  
		                          ,@p_log_type      = @v_log_type                  
		                          ,@p_log_count     = @n_log_count                   
		                          ,@p_log_message   = @v_log_message                   
		                          ,@p_description   = @v_description                   
		                          ,@p_event_date    = @d_event_date                   
		                          ,@p_user_id       = @v_batch_user                  
		                          ;                  
		PRINT @v_log_message      + ' : ' + @v_description ;          
		RETURN -1;                
    END CATCH;   

    SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +                 
                         REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))                 
    -- 종료 LOG                  
    SET @v_log_type = N'END';                  
    SET @v_log_message = N'##### END of procedure #####';                  
    SET @v_description = N'['  + @v_exec_time + ']';             
    SET @d_event_date = SYSDATETIME()  ;                 
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name                  
                              ,@p_log_type      =@v_log_type                  
                              ,@p_log_count     =@n_log_count                   
                              ,@p_log_message   =@v_log_message                   
                              ,@p_description   =@v_description                   
                              ,@p_event_date    =@d_event_date                   
                              ,@p_user_id       =@v_batch_user                  
                              ;                  
    RETURN 1;                
                  
END

