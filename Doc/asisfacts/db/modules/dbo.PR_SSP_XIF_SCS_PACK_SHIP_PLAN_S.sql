

/***************************************************************************************************
 * Program ID   : PR_SSP_XIF_SCS_PACK_SHIP_PLAN_S 
 * Description  : Packer Pack 출하계획 전송(매일)
 * OutTable     : XIF_SCS_PACK_SHIP_PLAN_S (I/F Table)
 * Execute      : EXEC PR_SSP_XIF_SCS_PACK_SHIP_PLAN
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020.05.20   YJJ           Initial Release [외주Packer Visibility 프로젝트]
 * 2020.06.10   SCSIF         전체 수정
 * 2020.12.07   KIMBOKKI      XIF_SCS_PACK_SHIP_PLAN_S_SN.ATTR_02 : PROJECT_CODE ADD
 * 2021.01.12   KIM BOK KI    PACKER 조회 기준 SCM_MST_SITE 의 PACKER 로 변경 (HARD CODING 제거)
 * 2023.04.11   jilee         프로젝트 Name명 추가 전송
 * 2024.10.01   KHJ           NERP_SSP
 * 2026.07.31	강주용		  [E20260731-001736] SSP -> PSCM 출하계획 I/F 시 소수점 데이터 정수화 요청
****************************************************************************************************/
 
CREATE PROCEDURE [dbo].[PR_SSP_XIF_SCS_PACK_SHIP_PLAN_S]
( 
     @IF_ID                     NVARCHAR(50)
    ,@O_ERRFLAG                 NVARCHAR(50)  OUTPUT
    ,@O_ERRDESC                 NVARCHAR(200) OUTPUT
) AS
BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

	-- LOG 용 변수 설정  
    DECLARE @v_batch_user			NVARCHAR(150) = N'SCS_BATCH'; 
    DECLARE @v_program_name			NVARCHAR(150) = N'PR_SSP_XIF_SCS_PACK_SHIP_PLAN_S';  
    DECLARE @v_log_type				NVARCHAR(30); -- START/END/ERROR/...  
    DECLARE @n_log_count			INTEGER = 0;  
    DECLARE @v_log_message			NVARCHAR(1000);  
    DECLARE @v_description			NVARCHAR(500);      --상세설명   
    DECLARE @v_table_id				NVARCHAR(150) = N'XIF_SCS_PACK_SHIP_PLAN_S'; --테이블 필수  
    DECLARE @d_event_date			DATETIME;  
    DECLARE @v_insert_cnt			INTEGER = 0; 
	DECLARE @v_insert_sum			INTEGER = 0; 

    DECLARE @IF_TYPE				NVARCHAR(1)    = 'I';
    --DECLARE @IF_ID					NVARCHAR(50)   = 'OSCM_OSCS_SCS_PACK_SHIP_PLAN';
    DECLARE @IF_INS_DATE			DATETIME       = GETDATE();
    DECLARE @IF_FLAG				NVARCHAR(100)  = 'N';
	DECLARE @IF_GROUP_NO            NVARCHAR(50)   = FORMAT(CURRENT_TIMESTAMP, 'yyyyMMddHHmmss');

	DECLARE @PLAN_START_YYYYMMDD    NVARCHAR(8);
	DECLARE @DIVISION_ID            NVARCHAR(50);
	DECLARE @PLAN_TYPE              NVARCHAR(40)   = 'SP';
    DECLARE @IFSEQNO				INT            = 1;

	DECLARE @TAB_PACKER TABLE
    (
        [TID]                         INT IDENTITY(1,1)		NOT NULL PRIMARY KEY,
		[DIVISION_ID]                 [nvarchar](50),
		[PACKER_CODE]                 [nvarchar](50)
    );


	--IF @p_start_yyyymmdd IS NULL
		-- 현재일 기준 -1일 이 최신
		SET @PLAN_START_YYYYMMDD   = CONVERT(CHAR(8), DATEADD(dd, -1, GETDATE()),112);         
	--ELSE
	--    -- 강제로 실행시 입력한 날짜 기준
	--	SET @PLAN_START_YYYYMMDD   = @p_start_yyyymmdd;						

	-----------------------------------------------------------
	-- PREPROCESSING
	-----------------------------------------------------------
	SET @IF_ID						= 'OSCM_OSCS_SCS_PACK_SHIP_PLAN';
	SET @O_ERRFLAG					= ''
	SET @O_ERRDESC					= '' 

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
		 *	 ESS (DIVISION 82)         
		 *****************************************************/
		SET @DIVISION_ID = '82'

		INSERT INTO XIF_SCS_PACK_SHIP_PLAN_S_SN
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
			 , ORDER_TYPE_DETAIL
		     )
		SELECT
			'OSCM' + CONVERT(VARCHAR,GETDATE(),12) + DBO.FN_ZERO_LPAD(CONVERT(VARCHAR,NEXT VALUE FOR DBO.SEQ1_XIF_SCS),10)  AS IF_SEQ
			, @IF_TYPE							AS IF_TYPE
			, @IF_ID							AS IF_ID
			, @IF_INS_DATE						AS IF_INS_DATE
			, @IF_FLAG							AS IF_FLAG 
			, ISNULL(X1.NEW_VALUE1, A.PACKER_CODE)	AS PACKER_CODE 
			, A.DIVISION_ID     -- DIVISION 
			, A.PLAN_VERSION    -- 원본테이블의  PLAN_START_YYYYMMDD날자를 VERSION(기준일)으로 갖고간다  
			, A.PACK_MODEL_CODE -- PACK ID 
			, A.NICK_NAME
			, 'O'
			, A.SSP_CNFM
			, A.SALES_SITE
			, A.SHIP_TO                         
			, A.SHIP_TO_NAME
			, A.TRANSPORT_MODE  -- 운송수단
			, A.INCOTERMS       -- 거래조건
			, A.SHIP_PLAN_DATE  -- 출하계획일 
			, A.SHIP_PLAN_QTY   -- 출하계획수량
			, NULL								AS REMARKS
			, @DIVISION_ID + '_' + @PLAN_START_YYYYMMDD + '_' + @IF_GROUP_NO	AS ATTR_01      
			, A.ATTR_02           
			, A.ATTR_03    --Model PIC
			, A.ATTR_04    --MTK_OWNER       
			-- 230411 jilee 프로젝트 Name명 추가
			, A.ATTR05           
			, NULL								AS ATTR06           
			, NULL								AS ATTR07           
			, NULL								AS ATTR08           
			, NULL								AS ATTR09           
			, NULL								AS ATTR10 
			, A.FCST_TYPE       --ORDER_TYPE_DETAIL
		FROM
		(
			SELECT 
				   P.FROM_SITE						AS PACKER_CODE
				 , P.DIVISION_ID					AS DIVISION_ID     -- DIVISION 
				 , P.PLAN_START_YYYYMMDD			AS PLAN_VERSION    -- 원본테이블의  PLAN_START_YYYYMMDD날자를 VERSION(기준일)으로 갖고간다  
				 , P.ITEM_ID						AS PACK_MODEL_CODE -- PACK ID 
				 , [dbo].[FN_GET_ITEM_NICKNAME]( P.DIVISION_ID, P.ITEM_ID)  AS NICK_NAME
				 , P.CONFIRM_ID						AS SSP_CNFM
				 , P.TO_SITE						AS SALES_SITE
				 , [dbo].[FN_GET_SITE_CUSTOMER_INFO](P.DIVISION_ID,P.TO_SITE,'SHIPTO_CODE')			AS SHIP_TO                                             
				 , [dbo].[FN_GET_SITE_CUSTOMER_INFO](P.DIVISION_ID,P.TO_SITE,'SHIPTO_DESCRIPTION')	AS SHIP_TO_NAME
				 , P.TRANSPORT_MODE					AS TRANSPORT_MODE  -- 운송수단
				 , P.INCOTERMS						AS INCOTERMS       -- 거래조건
				 , P.YYYYMMDD						AS SHIP_PLAN_DATE  -- 출하계획일 
				 --START [E20260731-001736] SSP -> PSCM 출하계획 I/F 시 소수점 데이터 정수화 요청
				 --원본, P.QTY							AS SHIP_PLAN_QTY   -- 출하계획수량
				 , ROUND(P.QTY,0)					AS SHIP_PLAN_QTY	-- 출하계획수량
				 --END [E20260731-001736] SSP -> PSCM 출하계획 I/F 시 소수점 데이터 정수화 요청
				 , P.PROJECT_CODE					AS ATTR_02           
				 , U2.UserName + '(' + MU.USER_ID + ')'					AS ATTR_03    --Model PIC
				 , DBO.FN_GET_SSP_MKT_OWNER_NAME (SI.OWNER, '', 'KO')	AS ATTR_04    --MTK_OWNER       
				 -- 230411 jilee 프로젝트 Name명 추가
				 , ISNULL((SELECT TOP 1 M.PROJECT_NAME FROM SCM_MST_PROJECT M with(nolock) 
						   WHERE M.DIVISION_ID = P.DIVISION_ID AND M.PROJECT_CODE = P.PROJECT_CODE),NULL) 
													AS ATTR05   
				 , ISNULL(LK.SEGMENT2, P.FCST_TYPE) AS FCST_TYPE       --ORDER_TYPE_DETAIL
  			  FROM dbo.SSP_ANL_SHIP_PLAN_C			AS P WITH(NOLOCK)
				   INNER JOIN SCM_MST_SITE          AS TAB WITH(NOLOCK)
				ON TAB.DIVISION_ID					= P.DIVISION_ID
			   AND TAB.SCM_SITE_ID					= P.FROM_SITE
			   AND TAB.DIVISION_ID					= @DIVISION_ID
			   AND TAB.SITE_TYPE					= 'PLANT'
			   AND TAB.VALID_YN						= 'Y'
			   AND TAB.OSP_YN						= 'Y'
			   AND TAB.OPERATION_GROUP				= 'P'
				   LEFT OUTER JOIN SCM_MST_SITE_ITEM AS SI WITH(NOLOCK)
				ON P.DIVISION_ID					= SI.DIVISION_ID
			   AND P.TO_SITE						= SI.SCM_SITE_ID
			   AND P.ITEM_ID						= SI.ITEM_ID
			   AND P.PROJECT_CODE					= SI.PROJECT_CODE
				   LEFT OUTER JOIN SSP_MST_MODEL_USER AS MU WITH(NOLOCK)
				ON P.DIVISION_ID = MU.DIVISION_ID
			   AND P.FROM_SITE = MU.FROM_SITE
			   AND P.ITEM_ID = MU.ITEM_ID
			   AND MU.VALID_YN = 'Y'
				   LEFT OUTER JOIN TB_FX_User as U2 with(nolock) 
				ON mu.user_id = u2.UserID 
			   AND U2.UseYN = 'Y'
				   LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL AS LK WITH(NOLOCK)
				ON LK.LOOKUP_TYPE = 'SALES_TYPE_CODE'
			   AND LK.VALID_YN	= 'Y'
			   AND P.FCST_TYPE	= LK.SEGMENT1
			 WHERE P.PLAN_START_YYYYMMDD			= @PLAN_START_YYYYMMDD  -- 현재일 기준 -1일 이 최신 '20200518' 
			   AND P.MEASURE						= 'SHIP_PLAN'
			   AND P.QTY							> 0 
		) A
		LEFT OUTER JOIN NERP_CONV_MASTER X1 WITH(NOLOCK) ON X1.CODETYPE = 'SCP_SITE_ID'	AND A.PACKER_CODE = X1.OLD_VALUE1
		   ;


		SET @v_insert_cnt = @@ROWCOUNT;
		SET @v_insert_sum = @v_insert_sum + @v_insert_cnt;

		-----------------------------------------------------------
		-- 이력처리
		-----------------------------------------------------------
		SELECT @IFSEQNO				= IIF(COUNT(1) = 0, 1, COUNT(1) + 1)
		  FROM dbo.SCP_PLN_INTERFACE_SEND_H WITH(NOLOCK)
		 WHERE PLAN_START_YYYYMMDD	= @PLAN_START_YYYYMMDD
		   AND DIVISION_ID			= @DIVISION_ID
		   AND PLAN_TYPE            = @PLAN_TYPE
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

		/*****************************************************
		 *	 소형 (DIVISION 40) : 화면 정장 시 바로 등록 처리 함        
		 *****************************************************/
		--SET @DIVISION_ID = '40'

		--엑셀 업로드 테이블 정의되면 여기에 추가

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
    return 1  
END;
