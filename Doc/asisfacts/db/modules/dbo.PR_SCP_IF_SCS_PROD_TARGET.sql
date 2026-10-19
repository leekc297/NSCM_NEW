
/***************************************************************************************************
 * Program ID   : PR_SCP_IF_SCS_PROD_TARGET 
 * Description  : Packer 생산TARGET 전송(주 화요일 24시 1회)
 * OutTable     : XIF_SCS_PROD_TARGET_S (I/F Table)
 * Execute      : EXEC PR_SCP_IF_SCS_PROD_TARGET
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020.05.20   YJJ           Initial Release [외주Packer Visibility 프로젝트]
 *                            매주 52주차 Packer 생산 TARGET 데이타 송신 INTERFACE                                  
 * 2020.06.09   SCSIF         전체 수정
 * 2023.06.12   KSG           E20230607-000617 [SCM.물류PI팀] GSCM->SCS 팩 계획 전송구간 52주 고정 요청 건 : 생성 기간 제한(Plan 구간 내)
 * 2023.08.18   KSG           E20230816-000554 [소형SCM.Pack공급관리팀] No Plan 주차의 팩 타겟관련 요청사항 : No Plan 주차 인터페이스 안내리도록 처리
 * 2024.03.22   KSG           E20240320-000935 ESS사업부 Final plan Target 정보(생산출하) → PSCM 전송 추가 건 : @p_division_id Parameter 추가 및 관련 로직 변경
****************************************************************************************************/
 
CREATE PROCEDURE [dbo].[PR_SCP_IF_SCS_PROD_TARGET]
( 
      @p_division_id          NVARCHAR(8) = NULL  -- 2024.03.22 E20240320-000935 Parameter 추가
    , @p_start_yyyymmdd       NVARCHAR(8) = NULL
) AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

	-- LOG 용 변수 설정  
    DECLARE @v_batch_user   NVARCHAR(150) = N'SCS_BATCH'; 
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_IF_SCS_PROD_TARGET';  
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...  
    DECLARE @n_log_count    INTEGER = 0;  
    DECLARE @v_log_message  NVARCHAR(1000);  
    DECLARE @v_description  NVARCHAR(500);      --상세설명   
    DECLARE @v_table_id     NVARCHAR(150) = N'XIF_SCS_PROD_TARGET_S'; --테이블 필수  
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
    DECLARE @IF_ID					NVARCHAR(50)   = 'OSCM_OSCS_SCS_PROD_TARGET';
    DECLARE @IF_INS_DATE			DATETIME       = GETDATE();
    DECLARE @IF_FLAG				NVARCHAR(100)  = 'N';

	DECLARE @PLAN_START_YYYYMMDD    NVARCHAR(8);
	DECLARE @DELETE_START_YYYYMMDD  NVARCHAR(8);
	DECLARE @HORIZON_END_DATE       NVARCHAR(8); -- 20230612 E20230607-000617 생성 기간 제한(Plan 구간 내)
	DECLARE @DIVISION_ID            NVARCHAR(50);
	DECLARE @PLAN_TYPE				NVARCHAR(50); 
	DECLARE @PLAN_SEQ               INT;
    DECLARE @IFSEQNO				INT					= 1;

	IF @p_start_yyyymmdd IS NULL
	BEGIN
		--원본테이블 데이타 일자(PLAN_START_YYYYMMDD)를 Search하기 위함
		SET @PLAN_START_YYYYMMDD = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD
    END
	ELSE
		--강제수행시 입력일자 기준.
		SET @PLAN_START_YYYYMMDD = @p_start_yyyymmdd; 
		
    SET @DELETE_START_YYYYMMDD = CONVERT(CHAR(8), DATEADD(DD, -7*4, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 4주 전
	
	----------------------------------------------------------
	-- 20230818 E20230816-000554 : No Plan 주차 인터페이스 안내리도록 처리
	-- FP_TARGET_YN = N 셋팅시 수행안함
	----------------------------------------------------------
	INSERT INTO @TAB_DIVISION(DIVISION_ID) 
	SELECT DISTINCT d.DIVISION_ID 
    FROM   SCM_MST_DIVISION d WITH(NOLOCK)
	INNER JOIN (SELECT DIVISION_ID
                FROM   SCP_PLN_INTERFACE_YN WITH(NOLOCK)
                WHERE  1=1
                AND    DIVISION_ID              = ISNULL(@P_DIVISION_ID, DIVISION_ID) -- 20240322 E20240320-000935 Parameter 추가
                AND    PLAN_START_YYYYMMDD      = @PLAN_START_YYYYMMDD
                AND    ISNULL(FP_TARGET_YN,'Y') = 'Y'
               ) i
    ON d.division_id = i.division_id
	--SELECT DISTINCT DIVISION_ID FROM SCM_MST_DIVISION WITH(NOLOCK)

	-----------------------------------------------------------
	-- START LOG
	-----------------------------------------------------------
    SET @v_log_type		= N'START';  
    SET @v_log_message	= N'########## Start of procedure ##########';  
    SET @v_description	= @v_program_name + ':' + N' XIF_SCS_PROD_TARGET_S INSERT LOGIC';  
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

		SELECT @INX			= 1
		      ,@MAX_NUM		= COUNT(*)
		  FROM @TAB_DIVISION

		WHILE @INX <= @MAX_NUM
		BEGIN

			SELECT @DIVISION_ID = DIVISION_ID
			  FROM @TAB_DIVISION
			 WHERE TID = @INX

			   SET @PLAN_TYPE	= NULL;
			   SET @PLAN_SEQ	= NULL;
			   SET @HORIZON_END_DATE = NULL;-- 20230612 E20230607-000617 생성 기간 제한(Plan 구간 내)

			--기준일의 최종 PLAN
	        SELECT TOP 1 @PLAN_TYPE = V.PLAN_TYPE, @PLAN_SEQ = V.PLAN_SEQ
                       , @HORIZON_END_DATE = V.HORIZON_END_DATE  -- 20230612 E20230607-000617 생성 기간 제한(Plan 구간 내)
			  FROM (
					SELECT D.DIVISION_ID,
						   P.PLAN_NAME AS PLAN_START_YYYYMMDD,
						   P.HORIZON_END_DATE,
						   D.PLAN_SEQ,
						   D.PLAN_TYPE,
						   ISNULL(D.CONFIRM_FLAG,'N') AS CONFIRM_FLAG,
						   CASE(D.PLAN_TYPE) WHEN 'PR' THEN 1 WHEN 'MA' THEN 2 WHEN 'SE' THEN 3 WHEN 'FN' THEN 4 ELSE 0 END AS PLAN_TYPE_ORDER
					  FROM SCM_MST_PLAN_DETAIL D (NOLOCK)
						  ,SCM_MST_PLAN        P (NOLOCK)
						  ,SCM_MST_MODELING    M (NOLOCK)
					 WHERE M.MODELING_ID   = D.MODELING_ID
					   AND M.PLAN_CYCLE    = 'WEEKLY'
					   AND M.DIVISION_ID   = D.DIVISION_ID
					   AND M.MODELING_ID   = D.MODELING_ID
					   AND P.DIVISION_ID   = D.DIVISION_ID
					   AND P.PLAN_CYCLE    = M.PLAN_CYCLE
					   AND P.PLAN_ID       = D.PLAN_ID
					   AND D.PLAN_STATUS   = '1'
					   AND D.PLAN_TYPE IN ('PR','MA','SE','FN')
					   AND P.PLAN_NAME >= [DBO].[FN_GET_BUCKET_YYYYMMDD](-10) --10주전
					) AS V
			WHERE V.plan_start_yyyymmdd	= @PLAN_START_YYYYMMDD
			  AND V.DIVISION_ID			= @DIVISION_ID
			ORDER BY 
				  V.PLAN_TYPE_ORDER DESC 
				 ,V.CONFIRM_FLAG DESC
				 ,V.PLAN_SEQ DESC


			IF @PLAN_TYPE IS NOT NULL AND @PLAN_SEQ IS NOT NULL
			BEGIN	

				/*****************************************************
				 *	 Packer 생산타겟 Interface 데이터 생성      
				 *****************************************************/
				INSERT INTO dbo.XIF_SCS_PROD_TARGET_S_SN
					 ( IF_SEQ           
					 , IF_TYPE          
					 , IF_ID            
					 , IF_INS_DATE      
					 , IF_FLAG          
					 , PACKER_CODE      
					 , DIVISION_ID      
					 , PLAN_VERSION
					 , PACK_MODEL_CODE  
					 , NICK_NAME        
					 , LINE_ID          
					 , TARGET_OPERATION 
					 , TARGET_DATE      
					 , TARGET_QTY       
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

				SELECT 'OSCM' + CONVERT(VARCHAR,GETDATE(),12) + dbo.FN_ZERO_LPAD(CONVERT(VARCHAR,NEXT VALUE FOR DBO.SEQ1_XIF_SCS),10)  AS IF_SEQ
					 , @IF_TYPE					AS IF_TYPE
					 , @IF_ID					AS IF_ID
					 , @IF_INS_DATE			    AS IF_INS_DATE
					 , @IF_FLAG					AS IF_FLAG
					 , MV.SCM_SITE_ID               AS PACKER_CODE
					 , MV.DIVISION_ID			AS DIVISION_ID
					 , MV.PLAN_START_YYYYMMDD	AS PLAN_VERSION    --SCM Job Batch일 기준(매주 월요일)
					 , MV.ITEM_ID				AS PACK_MODEL_CODE      
					 , FI.NICK_NAME				AS NICK_NAME   
					 , MV.LINE_ID               AS LINE_ID
					 , 'ASSY'					AS TARGET_OPERATION 
					 , MV.YYYYMMDD				AS TARGET_DATE
					 , MV.QTY     				AS TARGET_QTY
					  , @DIVISION_ID + '_' + @PLAN_START_YYYYMMDD + '_' + @PLAN_TYPE + '_' + CONVERT(VARCHAR, @PLAN_SEQ) +'_' + FORMAT(CURRENT_TIMESTAMP, 'yyyyMMddHHmmss')	AS ATTR_01      
					 , NULL						AS ATTR_02           
					 , NULL						AS ATTR_03           
					 , NULL						AS ATTR_04           
					 , NULL						AS ATTR_05           
					 , NULL						AS ATTR_06           
					 , NULL						AS ATTR_07           
					 , NULL						AS ATTR_08           
					 , NULL						AS ATTR_09           
					 , NULL						AS ATTR_10           
				  FROM dbo.SCP_ANL_PRODUCTION_PLAN AS MV (NOLOCK)

			      INNER JOIN [SCM_MST_SITE] AS SITE (NOLOCK)
				     ON SITE.DIVISION_ID			= MV.DIVISION_ID 
				    AND SITE.SCM_SITE_ID			= MV.SCM_SITE_ID
				    AND SITE.DIVISION_ID			= @DIVISION_ID
					AND SITE.SITE_TYPE				= 'PLANT'
					AND SITE.OSP_YN					= 'Y'
					AND SITE.VALID_YN               = 'Y'
				  
				  LEFT OUTER JOIN (SELECT DISTINCT division_id, item_id, nick_name
				                   FROM   SCP_MST_FINAL_ITEM WITH(NOLOCK)
				                  ) FI
				     ON MV.DIVISION_ID			= FI.DIVISION_ID 
				    AND MV.item_id  			= FI.item_id

				 WHERE MV.PLAN_START_YYYYMMDD   = @PLAN_START_YYYYMMDD
				   AND MV.PLAN_TYPE             = @PLAN_TYPE
				   AND MV.SEQ                   = @PLAN_SEQ
                   AND MV.MEASURE               = 'PROD_PLAN_AMEND'
                   AND MV.QTY                   > 0
                   AND MV.YYYYMMDD             <= @HORIZON_END_DATE -- 20230612 E20230607-000617 생성 기간 제한(Plan 구간 내)
				   ;  

				-----------------------------------------------------------
				-- 이력처리
				-----------------------------------------------------------
				SET @v_insert_cnt	=  @@ROWCOUNT;
				SET @v_insert_sum	= @v_insert_sum + @v_insert_cnt;

				--	 인터페이스 전송이력  테이블에 기록한다. 
				SELECT @IFSEQNO				= IIF(COUNT(1) = 0, 1, COUNT(1) + 1)
				  FROM dbo.SCP_PLN_INTERFACE_SEND_H (NOLOCK)
				 WHERE PLAN_START_YYYYMMDD	= @PLAN_START_YYYYMMDD
				   AND DIVISION_ID			= @DIVISION_ID
				   AND PLAN_TYPE			= @PLAN_TYPE
				   AND IF_ID				= @IF_ID 


				INSERT INTO dbo.SCP_PLN_INTERFACE_SEND_H
					( PLAN_START_YYYYMMDD
					, DIVISION_ID
					, PLAN_TYPE
					, IF_ID
					, IFSEQNO
					, CREATED_BY
					, CREATION_DATE )
				VALUES
					( @PLAN_START_YYYYMMDD
					, @DIVISION_ID 
					, @PLAN_TYPE
					, @IF_ID
					, @IFSEQNO
					, @v_batch_user
					, GETDATE()    
					)
 
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

			END
            -----------------------------------------------------------
			SET @INX = @INX + 1
		END
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

    -- 지난 정보 삭제
    DELETE XIF_SCS_PROD_TARGET_S_SN
    WHERE 1=1 --DIVISION_ID   = @DIVISION_ID
    AND   PLAN_VERSION <= @DELETE_START_YYYYMMDD;

    return 1 
END;

