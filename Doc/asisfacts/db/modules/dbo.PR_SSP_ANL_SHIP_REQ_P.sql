
/*
 * PROGRAM ID   : PR_SSP_ANL_SHIP_REQ_P
 * DESCRIPTION  : SCP_SHIP_PLAN 생성시 SSP_ANL_SHIP_REQ_P 에 데이터를 복사해주는 기능
 * OUTTABLE     :
 * EXECUTE      : EXEC PR_SSP_ANL_SHIP_REQ_P '40', '1204'
 * PROGRAM HISTORY
 *===================================================================================================
 *   DATE       IN CHARGE      DESCRIPTION
 *===================================================================================================
 * 2021.10.01   SSP Pjt.       Create.
 * 2022.01.24   SSP Pjt.       소형 Pack 수요 vs 출하 코드 이원화 이슈로 인한 Plant Site ITEM suffix 적용
 * 
 */
CREATE PROC [dbo].[PR_SSP_ANL_SHIP_REQ_P]
      @p_division_id     NVARCHAR(30)
    , @p_start_yyyymmdd  NVARCHAR(8)
    , @p_plan_type       NVARCHAR(50)
    , @p_seq             int
AS
BEGIN
	SET NOCOUNT ON

	-- LOG 용 변수 설정
	DECLARE @v_program_name				NVARCHAR(150) = 'PR_SSP_ANL_SHIP_REQ_P';
	DECLARE @v_log_type					NVARCHAR(30);
	DECLARE @n_log_count				INTEGER = 0;
	DECLARE @v_log_message				NVARCHAR(1000);
	DECLARE @v_description				NVARCHAR(500);
    DECLARE @v_table_id					NVARCHAR(150)	= N'SSP_ANL_SHIP_REQ_P'; --테이블 필수
	DECLARE @d_event_date				DATETIME;
	DECLARE @v_del_cnt					NVARCHAR(10);
    DECLARE @v_batch_user				NVARCHAR(150)	= N'System';
    DECLARE @v_insert_cnt				INTEGER = 0;
	DECLARE @v_insert_sum				INTEGER = 0;

	-- 예외처리 변수 설정
	DECLARE @v_err_code  INTEGER;
	DECLARE @v_err_message  NVARCHAR(4000)='';

	-----------------------------------------------------------
	-- START LOG
	-----------------------------------------------------------
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

	-- 트랜잭션 (START)
    BEGIN TRANSACTION;
	BEGIN TRY


		-- SCP FINAL PLAN INFO
		DECLARE @v_scp_plan_start_yyyymmdd    NVARCHAR(8);
		DECLARE @v_scp_plan_type              NVARCHAR(10); 
		DECLARE @v_scp_seq                    INTEGER ;    


		; 
		SET @v_scp_plan_start_yyyymmdd	= @p_start_yyyymmdd
		SET @v_scp_plan_type			= @p_plan_type
		SET @v_scp_seq					= @p_seq

		--[C20200723-000010]-----------------------------------------------------------------------------------------------
		--SCP계획사용안할 경우는 자동 생성 제외(Admin > System > SCP I/F Blocking 의 FP Target YN = 'N'일 경우) 
		--휴가기간, 연말(Season Holiday)등의 경우 등록됨 

		DECLARE @v_scp_block_count   INTEGER = 0;
	
		SELECT @v_scp_block_count	=  COUNT(*)
		  FROM SCP_PLN_INTERFACE_YN WITH(NOLOCK)
		 WHERE DIVISION_ID			= @p_division_id 
		   AND PLAN_START_YYYYMMDD	= @v_scp_plan_start_yyyymmdd 
		   AND FP_TARGET_YN			= 'N'
		;
	
		IF @v_scp_block_count <= 0
		BEGIN
		
			-- SCP_ANL_SHIPMENT_PLAN_FG에는 없는 FCST_TYPE 추출을 위해 
			-- SCP_ANL_SHIPMENT_PLAN_FG의 원천인SCP_PLN_SHIPMENT_PLAN_PEGGING + SCP_PLN_SHIPMENT_PLAN 으로 생성 
			-- UNPEGGING 된건 FCST_TYPE 이 없음     
			IF OBJECT_ID('tempdb..#TMP_SCP_ANL_SHIP_REQ_P') IS NOT NULL
				DROP TABLE #TMP_SCP_ANL_SHIP_REQ_P

			SELECT DIVISION_ID                        
				  ,ITEM_ID                        
				  ,YYYYMMDD  
				  ,BOD_ID                        
				  ,SHIPTO_CODE
				  ,PROJECT_CODE                
				  ,FCST_TYPE
				  ,SUM(QTY)					AS QTY                                     
			  INTO #TMP_SCP_ANL_SHIP_REQ_P
			  FROM (                        
				   SELECT        
						  B.DIVISION_ID                        
						 ,CASE WHEN ISNULL(FS.PACKER_ITEM_ID_SUFFIX,'') = '' THEN B.ITEM_ID ELSE ISNULL(STUFF(B.ITEM_ID,12,1, FS.PACKER_ITEM_ID_SUFFIX), B.ITEM_ID)  END  AS ITEM_ID              
						 ,B.YYYYMMDD                        
						 ,B.BOD_ID                         
						 ,[DBO].[FN_GET_SSP_SITE_INFO](B.DIVISION_ID, B.TO_SITE, 'SHIPTO_CODE') AS SHIPTO_CODE
						 ,ISNULL(A.PROJECT_CODE, '-') AS PROJECT_CODE 
						 ,ISNULL(A.FCST_TYPE, '-')    AS FCST_TYPE                        
						 ,A.ALLOCATION_QTY         AS QTY 
					 FROM SCP_PLN_SHIPMENT_PLAN_PEGGING A  WITH(NOLOCK)                         
					      LEFT OUTER JOIN SCP_PLN_SHIPMENT_PLAN B  WITH(NOLOCK)                   
					   ON 1 = 1                
				      AND A.DIVISION_ID				= B.DIVISION_ID                        
					  AND A.PLAN_START_YYYYMMDD		= B.PLAN_START_YYYYMMDD                
					  AND A.PLAN_TYPE				= B.PLAN_TYPE                          
					  AND A.SEQ						= B.SEQ                               
					  AND A.ORDER_ID				= B.ORDER_ID                 
					  AND A.DIVISION_ID				= @p_division_id               
					  AND A.PLAN_START_YYYYMMDD		= @v_scp_plan_start_yyyymmdd                    
					  AND A.PLAN_TYPE				= @v_scp_plan_type                  
					  AND A.SEQ						= @v_scp_seq                      
					  AND B.MEASURE					= 'SHIP_PLAN'                
					  AND B.SEMI_YN					= 'N'                      
					  AND B.OPERATION_GROUP			= ( CASE WHEN @p_division_id = '40' THEN 'P' ELSE B.OPERATION_GROUP END)
					--AND A.ENG_DEMAND_ID        <> 'UNPEGGING'  
					      INNER JOIN SCM_MST_SITE AS FS
                       ON B.DIVISION_ID = FS.DIVISION_ID
                      AND B.FROM_SITE = FS.SCM_SITE_ID
					  AND FS.VALID_YN = 'Y'
                      AND FS.OSP_YN = 'Y' 
					  AND FS.SITE_TYPE = 'PLANT'
					  AND FS.OPERATION_GROUP = 'P'
					      INNER JOIN SCM_MST_SITE AS TS
                       ON B.DIVISION_ID = TS.DIVISION_ID
                      AND B.TO_SITE = TS.SCM_SITE_ID
                      AND TS.VALID_YN = 'Y' 
					  AND TS.SITE_TYPE = 'SALES'
					      INNER JOIN SCP_MST_BOD_N_V  C WITH(NOLOCK)
					   ON C.DIVISION_ID				= B.DIVISION_ID                        
					  AND C.BOD_ID					= B.BOD_ID
					WHERE 1 = 1                        
					  AND A.DIVISION_ID				= @p_division_id                  
					  AND A.PLAN_START_YYYYMMDD		= @v_scp_plan_start_yyyymmdd                          
					  AND A.PLAN_TYPE				= @v_scp_plan_type                        
					  AND A.SEQ						= @v_scp_seq                            
					  AND B.DIVISION_ID				IS NOT NULL           
					  --AND A.ENG_DEMAND_ID        <> 'UNPEGGING' 
			       ) X                        
			 GROUP BY                        
 				   DIVISION_ID                        
				  ,ITEM_ID                        
				  ,YYYYMMDD  
				  ,BOD_ID                        
				  ,SHIPTO_CODE
				  ,PROJECT_CODE                
				  ,FCST_TYPE
				;

			DECLARE  @v_ow_day_cnt INT ; -- 사업부별로 확정구간 이후 구간에 대해서 사용자가 입력/변경한 데이터를 며칠까지 보존할 것인지의 일수	

			SELECT @v_ow_day_cnt	= CAST(SEGMENT2 AS INT)
			  FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
			 WHERE LOOKUP_TYPE		= 'DM_SHIP_OW_FROZEN'
			   AND SEGMENT1			= @p_division_id
			;


			DELETE R
			  FROM SSP_ANL_SHIP_REQ_P AS R WITH(NOLOCK)
				   INNER JOIN SCP_MST_BOD_N_V AS B
				ON R.DIVISION_ID		= B.DIVISION_ID
			   AND R.BOD_ID				= B.BOD_ID
				   JOIN SCM_MST_SITE AS FS WITH(NOLOCK) 
				ON R.DIVISION_ID		= FS.DIVISION_ID 
			   AND B.FROM_SITE			= FS.SCM_SITE_ID
				   JOIN SCM_MST_SITE AS TS WITH(NOLOCK) 
				ON R.DIVISION_ID		= TS.DIVISION_ID 
			   AND B.TO_SITE			= TS.SCM_SITE_ID
			 WHERE R.DIVISION_ID		= @p_division_id
			   AND ISNULL(TS.ATTRIBUTE2, 'N') = N'Y'		--	해당 사이트가 자동생성 사이트일 경우
			   AND r.YYYYMMDD			>= CONVERT(CHAR(8), DATEADD(DAY, ISNULL(FS.SHIP_FROZEN, 10) , getdate()), 112) -- 확정구간 보존
			      
			   -- 확정구간 이후 사업부별 보존구간 적용
			   AND ((
							r.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DAY, ISNULL(FS.SHIP_FROZEN, 10) , getdate()), 112) 
						AND r.YYYYMMDD <  CONVERT(CHAR(8), DATEADD(DAY, ISNULL(FS.SHIP_FROZEN, 10)  + ISNULL(@v_ow_day_cnt, 0) , getdate()), 112) 
						AND ISNULL(R.LAST_UPDATED_BY, 'Y') IN (@v_batch_user, 'ssp_batch')		--	사용자가 수정한 데이터가 아니고
					) 
					OR	-- 그 이후 구간은 그냥 삭제
					(	
						r.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DAY, ISNULL(FS.SHIP_FROZEN, 10)  + ISNULL(@v_ow_day_cnt, 0) , getdate()), 112) 
					)
					OR  r.Qty = 0
				   )

				SET @v_del_cnt = CAST(@@ROWCOUNT AS NVARCHAR(30))
				
				
				-- REQ 에 데이터를 생성하는데, 위에서 보존할 데이터를 제외하고는 모두 삭제했으므로, 확정구간 이후 구간에 대해 Insert 를 하되 아래의 경우만 제외한다.
				-- 1. REQ 와 키가 겹치는 경우, 2.Sales Site 기준으로 자동생성 사이트가 아닌 경우
				INSERT INTO SSP_ANL_SHIP_REQ_P (
					   DIVISION_ID
					 , ITEM_ID
					 , YYYYMMDD
					 , BOD_ID
					 , SHIPTO_CODE
					 , PROJECT_CODE
					 , FCST_TYPE
					 , REQUEST_ID
					 , QTY
					 , CONFIRM_ID
					 , CREATED_BY
					 , CREATION_DATE
					 , LAST_UPDATED_BY
					 , LAST_UPDATE_DATE
					 )
				SELECT A.DIVISION_ID
					 , A.ITEM_ID
					 , A.YYYYMMDD
					 , A.BOD_ID
					 , A.SHIPTO_CODE
					 , A.PROJECT_CODE
					 , A.FCST_TYPE
					 , 'R'+ CONVERT(VARCHAR(8), getdate(), 112) + RIGHT('000000' + CONVERT(NVARCHAR, NEXT VALUE FOR SEQ1_SSP_ANL_SHIP_PACKER_REQ_ID),6) AS REQUEST_ID
					 , A.QTY
					 , null
					 , @v_batch_user		
					 , getdate()	
					 , @v_batch_user	
					 , getdate()	
				  FROM #TMP_SCP_ANL_SHIP_REQ_P				AS A WITH(NOLOCK)					
				       INNER JOIN SCM_SYS_CALENDAR_M		AS O WITH(NOLOCK)  
					ON A.YYYYMMDD			= O.BASIS_YYYYMMDD
				       INNER JOIN SCP_MST_BOD_N_V			AS B WITH(NOLOCK) 
					ON A.DIVISION_ID		= B.DIVISION_ID 
				   AND A.BOD_ID				= B.BOD_ID
				       INNER JOIN SCM_MST_SITE				AS FS WITH(NOLOCK) 
					ON A.DIVISION_ID		= FS.DIVISION_ID 
				   AND B.FROM_SITE			= FS.SCM_SITE_ID
				       INNER JOIN SCM_MST_SITE				AS TS WITH(NOLOCK) 
				    ON A.DIVISION_ID		= TS.DIVISION_ID
				   AND B.TO_SITE			= TS.SCM_SITE_ID 
				       LEFT OUTER JOIN SSP_ANL_SHIP_REQ_P	AS E  WITH(NOLOCK) 
					ON A.DIVISION_ID		= E.DIVISION_ID 
				   AND A.ITEM_ID			= E.ITEM_ID 
				   AND A.YYYYMMDD			= E.YYYYMMDD
				   AND A.BOD_ID				= E.BOD_ID
				   AND A.SHIPTO_CODE		= E.SHIPTO_CODE
				   AND A.PROJECT_CODE		= E.PROJECT_CODE
				   AND A.FCST_TYPE			= E.FCST_TYPE
				   AND A.QTY				<> 0 
				 WHERE A.DIVISION_ID		= @p_division_id		
				   AND A.YYYYMMDD			>= CONVERT(CHAR(8), DATEADD(DAY, ISNULL(FS.SHIP_FROZEN, 10) , getdate()), 112) -- 확정구간 보존
				   AND A.YYYYMMDD			<  CONVERT(VARCHAR, DATEADD(D, 56 + 7, getdate()) ,112) -- 8주 + 7일  
				   AND E.DIVISION_ID		IS NULL						-- 키가 겹치는 경우 제외
				   AND ISNULL(TS.ATTRIBUTE2, 'N') = 'Y'				-- 자동 생성여부를 SITE 별로 적용
				   AND A.QTY				> 0
				 --GROUP BY 
				 --      A.DIVISION_ID
					-- , A.FROM_SITE
					-- , A.ITEM_ID
					-- , A.YYYYMMDD
					-- , A.BOD_ID
					-- , A.SHIPTO_CODE
					-- , A.PROJECT_CODE
					-- , A.FCST_TYPE



				SET @v_description = N'DIV : ' + @p_division_id + N'/ PLAN_ID : ' + @v_description + N'/ ROW_COUNT : ' + CONVERT(NVARCHAR(30), @@ROWCOUNT) + N'/ DEL_COUNT : ' + ISNULL(@v_del_cnt, '0' )



		END

 		-----------------------------------------------------------
		-- TXN LOG
		-----------------------------------------------------------
		SET @v_log_type = 'TXN';
		SET @v_log_message = N'INSERT INTO '+ @v_table_id;
		--SET @v_description = @p_plan_id;
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		-- 트랜잭션 (COMMIT)
		COMMIT WORK;

	END TRY
	
	BEGIN CATCH
		ROLLBACK TRANSACTION;

 		-----------------------------------------------------------
		-- ERROR LOG
		-----------------------------------------------------------
		SET @v_log_type		= N'ERROR';
		SET @v_log_message	= CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description	= N'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date	= SYSDATETIME();

		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
								  ,@p_log_type      = @v_log_type
								  ,@p_log_count     = @n_log_count
								  ,@p_log_message   = @v_log_message
								  ,@p_description   = @v_description
								  ,@p_event_date    = @d_event_date
								  ,@p_user_id       = @v_batch_user
								  ;


	END CATCH;

	-----------------------------------------------------------
	-- END LOG
	-----------------------------------------------------------
    SET @v_log_type		= N'END';
    SET @v_log_message	= N'########## END of procedure ##########';
    SET @v_description	= N'';
    SET @d_event_date	= SYSDATETIME();

    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
							  ,@p_log_type      = @v_log_type
							  ,@p_log_count     = @v_insert_sum
							  ,@p_log_message   = @v_log_message
							  ,@p_description   = @v_description
							  ,@p_event_date    = @d_event_date
							  ,@p_user_id       = @v_batch_user
							  ;

	IF OBJECT_ID('tempdb..#TMP_SCP_ANL_SHIP_REQ_P') IS NOT NULL
		DROP TABLE #TMP_SCP_ANL_SHIP_REQ_P

END
