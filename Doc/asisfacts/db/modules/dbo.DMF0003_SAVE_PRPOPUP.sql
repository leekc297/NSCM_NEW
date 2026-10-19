
/*========================================================================================================================
* Program ID  : DMF0003_SAVE_PRPOPUP                                               
* Description : Procedure 작성 가이드                                                             
* Usage       : PR POPUP 에서 Request 를 생성할 때 사용
* Parameter   :            
*========================================================================================================================
*	Date		In Charge	Description                                                           
*========================================================================================================================
* 2021.04.13	HWI1993		[과제] PR POPUP
* 2021.06.21	HWI1993		메일의 일자를 REQUEST DATE 에서 YYYYMMDD 로 변경
* 2021.08.27	HWI1993		[C20210813-000004]_[SCM PI] GSCM 상품 자재 PR 발생시, 서비스 플랜트 추가 요청의 건
* 2022.11.23	hwi1993		[C20221117-000272]_PR 마이너스 request 적용시 팝업 메시지 발생 
* 2023.08.04	HMIN        [E20230721-001841]_용어 수정  GSCM->SCM
* 2025.04.04	JSSBAE		[E20250401-000548]_SMS 선감지 대상 정리
 ========================================================================================================================*/

CREATE PROCEDURE [dbo].[DMF0003_SAVE_PRPOPUP]
	  @p_POPUP_TYPE			NVARCHAR(30)
	, @p_ITEM_SEQ			NVARCHAR(max)
	, @p_DIVISION_ID		NVARCHAR(max)
	, @p_PROJECT_CODE		NVARCHAR(max)
	, @p_SCM_SITE_ID		NVARCHAR(max)
	, @p_ITEM_ID			NVARCHAR(max)
	, @p_DOM_EXP			NVARCHAR(max)
	, @p_FCST_TYPE			NVARCHAR(max)
	, @p_INCOTERMS			NVARCHAR(max)
	, @p_PLANT_SITE_ID		NVARCHAR(max)
	, @p_YYYYMMDD			NVARCHAR(max)
	, @p_UOM				NVARCHAR(max)
	, @p_PLAN_QTY			NVARCHAR(max)
	, @p_STORAGE_ID			NVARCHAR(max)
	, @p_STORAGE_PLANT_ID	NVARCHAR(max)
	, @p_PUCH_MGR			NVARCHAR(max)
	, @p_PUCH_GROUP			NVARCHAR(max)
	, @p_PR_HEADER			NVARCHAR(max)
	, @p_PR_ITEM_DETAIL		NVARCHAR(max)
	, @p_CREATED_BY			NVARCHAR(200)
AS  
BEGIN

    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
	SET ANSI_WARNINGS ON;
	
	/*========================================================================================================================
	-- LOG 용 변수 설정
	========================================================================================================================*/
    DECLARE @v_program_name			NVARCHAR(150) = 'DMF0003_SAVE_PRPOPUP';
    DECLARE @v_log_type				NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count			INTEGER = 0;
    DECLARE @v_log_message			NVARCHAR(1000);
    DECLARE @v_log_description		NVARCHAR(500);
    DECLARE @d_event_date			DATETIME;
    DECLARE @n_delete_count			INTEGER = 0;
    DECLARE @n_insert_count			INTEGER = 0;
    DECLARE @n_input_count			INTEGER = 0;
    DECLARE @n_logo_count			INTEGER = 0;
	DECLARE @n_Invalid_item			NVARCHAR(50)
	DECLARE @n_msg					NVARCHAR(1000)
	DECLARE @V_BF_REQ_NO			NVARCHAR(30)
	DECLARE @V_BF_QTY				INT = 0;
	DECLARE @V_THIS_QTY				INT = 0;
	
	/*========================================================================================================================
	-- MKT FCST 테이블 접근을 위한 변수
	========================================================================================================================*/
	DECLARE @V_DIVISION_ID			NVARCHAR(30)
		  , @V_PROJECT_CODE			NVARCHAR(50)
		  , @V_SCM_SITE_ID			NVARCHAR(30)
		  , @V_ITEM_ID				NVARCHAR(50)
		  , @V_DOM_EXP				NVARCHAR(3)
		  , @V_FCST_TYPE			NVARCHAR(20)
		  , @V_INCOTERMS			NVARCHAR(10)
		  , @V_MEASURE				NVARCHAR(50)
		  , @V_YYYYMMDD				NVARCHAR(8)
		  , @V_PLANT_SITE_ID		NVARCHAR(30)
		  , @V_BEFORE_UPDATE_QTY	NUMERIC(30,10)	-- ADD HISTORY 일 경우 업데이트 하기 전 MKT FCST 테이블 수량
	
	/*========================================================================================================================
	-- 시작 LOG  (START)
	========================================================================================================================*/
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure @@@##########';
	SET @v_log_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_log_description, @d_event_date, @p_CREATED_BY
	SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/ 

	/*========================================================================================================================
	--BEGIN TRANSACTION
	========================================================================================================================*/
	BEGIN TRANSACTION 
	--------------------------------------------------------------------------------------------	
	BEGIN TRY
	--------------------------------------------------------------------------------------------
		DECLARE @V_REQUEST_NO NVARCHAR(30)
			  , @V_MAX_NO	  NVARCHAR(30)
			  , @V_SUM_QTY    INT
	
		SELECT @V_MAX_NO = MAX(REQUEST_NO)
		FROM DM_PLN_PR_DETAIL WITH(NOLOCK)
		WHERE REQUEST_NO LIKE CONVERT(CHAR(8), GETDATE(), 112) + '%'

		IF @V_MAX_NO IS NOT NULL 
		BEGIN
			SET @V_REQUEST_NO = CONCAT(CONVERT(CHAR(8), GETDATE(), 112), DBO.FN_ZERO_LPAD(RIGHT(@V_MAX_NO, 6) + 1, 6))
		END
		ELSE
		BEGIN
			SET @V_REQUEST_NO = CONVERT(CHAR(8), GETDATE(), 112) + '000001'
		END
			
		SELECT @V_REQUEST_NO AS REQUEST_NO
			, B1.TOKEN AS ITEM_SEQ, B2.TOKEN AS DIVISION_ID, B3.TOKEN AS PROJECT_CODE, B4.TOKEN AS SCM_SITE_ID
			, B5.TOKEN AS ITEM_ID, B6.TOKEN AS DOM_EXP, B7.TOKEN AS FCST_TYPE, B8.TOKEN AS INCOTERMS, ISNULL(B9.TOKEN,'') AS PLANT_SITE_ID
			, B10.TOKEN AS YYYYMMDD, B11.TOKEN AS UOM		 
			, B12.TOKEN AS PLAN_QTY, B13.TOKEN AS STORAGE_ID, B14.TOKEN AS STORAGE_PLANT_ID, B15.TOKEN AS PUCH_MGR				 
			, B16.TOKEN AS PUCH_GROUP, B17.TOKEN AS PR_HEADER, B18.TOKEN AS PR_ITEM_DETAIL, @p_CREATED_BY AS CREATED_BY	
			, GETDATE() AS CREATION_DATE, @p_CREATED_BY AS LAST_UPDATED_BY, GETDATE() AS LAST_UPDATE_DATE
			, 'N' AS SSP_TRANSFER_FLAG
			, CAST(NULL AS NVARCHAR(150)) AS ATTRIBUTE1
		INTO #T_MAIN
		FROM DBO.UF_FX_String_Split(@p_ITEM_SEQ, '^') B1
			LEFT OUTER JOIN DBO.UF_FX_String_Split(@p_DIVISION_ID		, '^') B2  ON B1.NR = B2.NR
			LEFT OUTER JOIN DBO.UF_FX_String_Split(@p_PROJECT_CODE		, '^') B3  ON B1.NR = B3.NR
			LEFT OUTER JOIN DBO.UF_FX_String_Split(@p_SCM_SITE_ID		, '^') B4  ON B1.NR = B4.NR
			LEFT OUTER JOIN DBO.UF_FX_String_Split(@p_ITEM_ID			, '^') B5  ON B1.NR = B5.NR
			LEFT OUTER JOIN DBO.UF_FX_String_Split(@p_DOM_EXP			, '^') B6  ON B1.NR = B6.NR
			LEFT OUTER JOIN DBO.UF_FX_String_Split(@p_FCST_TYPE			, '^') B7  ON B1.NR = B7.NR
			LEFT OUTER JOIN DBO.UF_FX_String_Split(@p_INCOTERMS			, '^') B8  ON B1.NR = B8.NR
			LEFT OUTER JOIN DBO.UF_FX_String_Split(@p_PLANT_SITE_ID		, '^') B9  ON B1.NR = B9.NR
			LEFT OUTER JOIN DBO.UF_FX_String_Split(@p_YYYYMMDD			, '^') B10 ON B1.NR = B10.NR
			LEFT OUTER JOIN DBO.UF_FX_String_Split(@p_UOM				, '^') B11 ON B1.NR = B11.NR
			LEFT OUTER JOIN DBO.UF_FX_String_Split(@p_PLAN_QTY			, '^') B12 ON B1.NR = B12.NR
			LEFT OUTER JOIN DBO.UF_FX_String_Split(@p_STORAGE_ID		, '^') B13 ON B1.NR = B13.NR
			LEFT OUTER JOIN DBO.UF_FX_String_Split(@p_STORAGE_PLANT_ID	, '^') B14 ON B1.NR = B14.NR
			LEFT OUTER JOIN DBO.UF_FX_String_Split(@p_PUCH_MGR			, '^') B15 ON B1.NR = B15.NR
			LEFT OUTER JOIN DBO.UF_FX_String_Split(@p_PUCH_GROUP		, '^') B16 ON B1.NR = B16.NR
			LEFT OUTER JOIN DBO.UF_FX_String_Split(@p_PR_HEADER			, '^') B17 ON B1.NR = B17.NR
			LEFT OUTER JOIN DBO.UF_FX_String_Split(@p_PR_ITEM_DETAIL	, '^') B18 ON B1.NR = B18.NR

		IF EXISTS ( SELECT *
					FROM #T_MAIN A
					LEFT OUTER JOIN SCM_MST_SITE_ITEM B WITH(NOLOCK)
								 ON A.DIVISION_ID	= B.DIVISION_ID 
								AND A.SCM_SITE_ID	= B.SCM_SITE_ID 
								AND A.PROJECT_CODE	= B.PROJECT_CODE 
								AND A.ITEM_ID		= B.ITEM_ID 
								AND B.VALID_YN		= 'Y'
					WHERE B.ITEM_ID IS NULL )
		BEGIN			
			--[E20250401-000548]_Validation인데도 불구하고 ERROR로 찍히므로 해당 부분 VALIDATION으로 수정 START
			--원소스 주석 처리 
			/*			
			SELECT TOP 1 @n_Invalid_item = A.ITEM_ID
			FROM #T_MAIN A
			LEFT OUTER JOIN SCM_MST_SITE_ITEM B WITH(NOLOCK) 
						 ON A.DIVISION_ID	= B.DIVISION_ID 
						AND A.SCM_SITE_ID	= B.SCM_SITE_ID 
						AND A.PROJECT_CODE	= B.PROJECT_CODE 
						AND A.ITEM_ID		= B.ITEM_ID 
						AND B.VALID_YN		= 'Y'
			WHERE B.ITEM_ID IS NULL
			SET @n_msg = RTRIM(@n_Invalid_item) + N'은 사용할 수 없는 Model 입니다.'
			RAISERROR( @n_msg, 16, 1);
			*/			
			SELECT TOP 1 @n_Invalid_item = A.ITEM_ID
			FROM #T_MAIN A
			LEFT OUTER JOIN SCM_MST_SITE_ITEM B WITH(NOLOCK) 
						 ON A.DIVISION_ID	= B.DIVISION_ID 
						AND A.SCM_SITE_ID	= B.SCM_SITE_ID 
						AND A.PROJECT_CODE	= B.PROJECT_CODE 
						AND A.ITEM_ID		= B.ITEM_ID 
						AND B.VALID_YN		= 'Y'
			WHERE B.ITEM_ID IS NULL
			BEGIN 				
				SET @v_log_type = 'INVALID';
				SET @v_log_message = RTRIM(@n_Invalid_item) + N'은 사용할 수 없는 Model 입니다.';
				GOTO ERR_RTN
			END			
			--[E20250401-000548]_Validation인데도 불구하고 ERROR로 찍히므로 해당 부분 VALIDATION으로 수정 END
		END
				
		SELECT TOP 1
			  @V_DIVISION_ID	= DIVISION_ID	
			, @V_PROJECT_CODE	= PROJECT_CODE	
			, @V_SCM_SITE_ID	= SCM_SITE_ID	
			, @V_ITEM_ID		= ITEM_ID		
			, @V_DOM_EXP		= DOM_EXP		
			, @V_FCST_TYPE		= FCST_TYPE		
			, @V_INCOTERMS		= INCOTERMS		
			, @V_MEASURE		= 'BNPIn'		
			, @V_YYYYMMDD		= YYYYMMDD		
			, @V_PLANT_SITE_ID	= PLANT_SITE_ID	
		FROM #T_MAIN
		
		/*========================================================================================================================
		-- ADD HISTORY 일 경우 MKT FCST 를 업데이트 해준다.
		========================================================================================================================*/
		IF ( @p_POPUP_TYPE = 'ADD_HISTORY')
		BEGIN			
			SELECT @V_SUM_QTY = SUM(PLAN_QTY)
			FROM (	SELECT SUM(PLAN_QTY) AS PLAN_QTY
					FROM DM_PLN_PR_DETAIL WITH(NOLOCK)
					WHERE DIVISION_ID	= @V_DIVISION_ID
					AND PROJECT_CODE	= @V_PROJECT_CODE
					AND SCM_SITE_ID		= @V_SCM_SITE_ID
					AND ITEM_ID			= @V_ITEM_ID
					AND DOM_EXP			= @V_DOM_EXP
					AND FCST_TYPE		= @V_FCST_TYPE
					AND INCOTERMS		= @V_INCOTERMS
					AND YYYYMMDD		= @V_YYYYMMDD
					AND PLANT_SITE_ID	= @V_PLANT_SITE_ID
					UNION ALL
					SELECT PLAN_QTY
					FROM #T_MAIN ) A

			-- [C20221117-000272]
			SELECT @V_BF_QTY = SUM(PLAN_QTY)
			FROM DM_PLN_PR_DETAIL WITH(NOLOCK)
			WHERE DIVISION_ID	= @V_DIVISION_ID
			AND PROJECT_CODE	= @V_PROJECT_CODE
			AND SCM_SITE_ID		= @V_SCM_SITE_ID
			AND ITEM_ID			= @V_ITEM_ID
			AND DOM_EXP			= @V_DOM_EXP
			AND FCST_TYPE		= @V_FCST_TYPE
			AND INCOTERMS		= @V_INCOTERMS
			AND YYYYMMDD		= @V_YYYYMMDD
			AND PLANT_SITE_ID	= @V_PLANT_SITE_ID

			SELECT TOP 1 @V_THIS_QTY = PLAN_QTY
			FROM #T_MAIN
			
			/*========================================================================================================================
			-- 수량이 마이너스일 경우 직전 REQ 의 수량보다 크면 안됨
			========================================================================================================================*/
			--[E20250401-000548]_Validation인데도 불구하고 ERROR로 찍히므로 해당 부분 VALIDATION으로 수정 START
			--원소스 주석 처리 
			/*			
			IF ( @V_THIS_QTY < 0 
				AND ABS(@V_THIS_QTY) > @V_BF_QTY )		
			BEGIN
				RAISERROR(N'마이너스 REQUEST 는 이전 REQUEST 총합 수량 만큼만 가능합니다.', 16, 1);
			END
			*/			
			IF ( @V_THIS_QTY < 0 
				AND ABS(@V_THIS_QTY) > @V_BF_QTY )	
			BEGIN 				
				SET @v_log_type = 'INVALID';
				SET @v_log_message = N'마이너스 REQUEST 는 이전 REQUEST 총합 수량 만큼만 가능합니다.';
				GOTO ERR_RTN
			END			
			--[E20250401-000548]_Validation인데도 불구하고 ERROR로 찍히므로 해당 부분 VALIDATION으로 수정 END

			--[E20250401-000548]_Validation인데도 불구하고 ERROR로 찍히므로 해당 부분 VALIDATION으로 수정 START
			--원소스 주석 처리 
			/*			
			IF ( @V_THIS_QTY = 0 )
			BEGIN
				RAISERROR(N'수량이 0인 경우는 생성할 수 없습니다.', 16, 1);
			END
			*/		
			IF ( @V_THIS_QTY = 0 )	
			BEGIN 				
				SET @v_log_type = 'INVALID';
				SET @v_log_message = N'수량이 0인 경우는 생성할 수 없습니다.';
				GOTO ERR_RTN
			END
			--[E20250401-000548]_Validation인데도 불구하고 ERROR로 찍히므로 해당 부분 VALIDATION으로 수정 END

			SELECT TOP 1 @V_BEFORE_UPDATE_QTY = QTY
			FROM DM_PLN_MKT_FCST WITH(NOLOCK)
			WHERE DIVISION_ID	= @V_DIVISION_ID
			AND PROJECT_CODE	= @V_PROJECT_CODE
			AND SCM_SITE_ID		= @V_SCM_SITE_ID
			AND ITEM_ID			= @V_ITEM_ID
			AND DOM_EXP			= @V_DOM_EXP
			AND FCST_TYPE		= @V_FCST_TYPE
			AND INCOTERMS		= @V_INCOTERMS
			AND YYYYMMDD		= @V_YYYYMMDD
			AND PLANT_SITE_ID	= @V_PLANT_SITE_ID
			AND MEASURE			= 'BNPIn'

			UPDATE DM_PLN_MKT_FCST
			SET QTY = @V_SUM_QTY
			WHERE DIVISION_ID	= @V_DIVISION_ID
			AND PROJECT_CODE	= @V_PROJECT_CODE
			AND SCM_SITE_ID		= @V_SCM_SITE_ID
			AND ITEM_ID			= @V_ITEM_ID
			AND DOM_EXP			= @V_DOM_EXP
			AND FCST_TYPE		= @V_FCST_TYPE
			AND INCOTERMS		= @V_INCOTERMS
			AND YYYYMMDD		= @V_YYYYMMDD
			AND PLANT_SITE_ID	= @V_PLANT_SITE_ID
			AND MEASURE			= 'BNPIn'
		END
		
		/*========================================================================================================================
		-- 2021.6.21 LAST_UPDATED_BY 는 USER NAME 으로 처리한다.
		-- 2021.6.28	LAST_UPDATED_BY 는 아이디로, ATTRIBUTE1 에는 KR NAME 으로 한다.
		========================================================================================================================*/
		UPDATE A
		SET ATTRIBUTE1 = B.USER_NAME
		FROM #T_MAIN A
		JOIN SCM_MST_SSO_USER_INFO B WITH(NOLOCK)
		  ON A.LAST_UPDATED_BY = B.USER_ID

		INSERT INTO DM_PLN_PR_DETAIL
		( REQUEST_NO, ITEM_SEQ, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
		, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
		, YYYYMMDD, UOM, PLAN_QTY, STORAGE_ID, STORAGE_PLANT_ID
		, PUCH_MGR, PUCH_GROUP, PR_HEADER, PR_ITEM_DETAIL, CREATED_BY
		, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, SSP_TRANSFER_FLAG
		, ATTRIBUTE1 )
		SELECT REQUEST_NO, ITEM_SEQ, DIVISION_ID, PROJECT_CODE, SCM_SITE_ID
			 , ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
			 , YYYYMMDD, UOM, PLAN_QTY, STORAGE_ID, STORAGE_PLANT_ID
			 , PUCH_MGR, PUCH_GROUP, PR_HEADER, PR_ITEM_DETAIL, CREATED_BY
			 , CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, SSP_TRANSFER_FLAG
			 , ATTRIBUTE1
		FROM   #T_MAIN
		--RAISERROR('ASAAAA', 16, 1)
		
		/*========================================================================================================================
		-- ESS 프로시저 호출	------------------------------------------------------------------------------------
		-- 트랜잭션 문제가 해결이 안된 관계로 여기서 처리하고, 문제 발생시 DM_PLN_PR_DETAIL 삭제 및 DM_PLN_MKT_FCST UPDATE 한다.
		========================================================================================================================*/
		DECLARE @V_MSG NVARCHAR(1000)
				
		--[E20250401-000548]_Validation인데도 불구하고 ERROR로 찍히므로 해당 부분 VALIDATION으로 수정 START
		--원소스 주석 처리 
		/*
		EXEC PR_SSP_ANL_ESS_REQ @V_REQUEST_NO, @V_DIVISION_ID, @V_MSG OUTPUT		
		IF ISNULL(@V_MSG,'') <> N'OK'
		BEGIN
			RAISERROR(@V_MSG, 16, 1);
		END
		*/			
		EXEC PR_SSP_ANL_ESS_REQ @V_REQUEST_NO, @V_DIVISION_ID, @V_MSG OUTPUT		
		IF ISNULL(@V_MSG,'') <> N'OK'
		BEGIN 				
			SET @v_log_type = 'INVALID';
			SET @v_log_message = @V_MSG;
			GOTO ERR_RTN
		END
		--[E20250401-000548]_Validation인데도 불구하고 ERROR로 찍히므로 해당 부분 VALIDATION으로 수정 END
		
		/*========================================================================================================================
		-- 메일발송하기 위한 문자 생성
		========================================================================================================================*/
		DECLARE @TABLE_BODY			NVARCHAR(MAX)
			  , @v_body_contents	NVARCHAR(MAX)
			  , @v_head_cont		NVARCHAR(MAX)
			  , @v_body_cont		NVARCHAR(MAX)
			  , @v_to_mail			NVARCHAR(150)
			  , @v_mail_title		NVARCHAR(100)
			  , @v_cnt int
			  , @v_i int

		DECLARE @V_ITEM_SEQ			INT
			  , @V_ITEM_NAME		NVARCHAR(50)
			  , @V_UOM				NVARCHAR(8)
			  , @V_PLAN_QTY			NUMERIC(30,10)
			  , @V_CREATED_BY		NVARCHAR(150)
			  , @V_LAST_UPDATE_DATE	DATETIME
			  , @V_CURSOR_YYYYMMDD	NVARCHAR(10)

		DECLARE @T_MAIL_ADDR TABLE 
		( ADDR	NVARCHAR(150)
		, SEQ	INT				IDENTITY(0,1))

		INSERT INTO @T_MAIL_ADDR ( ADDR )
		SELECT A.SEGMENT1
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL A WITH (NOLOCK)
		WHERE A.LOOKUP_TYPE = 'DM_PR_MAIL_ADDR'
		AND A.VALID_YN = 'Y'

		SELECT @V_CNT = COUNT(*), @V_I = 0, @v_to_mail = ''
		FROM @T_MAIL_ADDR

		WHILE ( @V_I < @V_CNT )
		BEGIN		
			SELECT @V_TO_MAIL = @V_TO_MAIL + ADDR  + ';' -- + CASE WHEN @V_I <> 0 THEN ';'  ELSE '' END + ADDR
			FROM @T_MAIL_ADDR
			WHERE SEQ = @V_I

			SET @V_I = @V_I + 1
		END

		---------------------------------------------------------------------------------------------------------
		--SET @v_mail_title = N'[GSCM] PR Requested'
		SET @v_mail_title = N'[SCM] PR Requested'     -- [E20230721-001841] 용어 수정  GSCM->SCM
		SET @v_body_contents = N'하기와 같이 PR Request 가 접수 되었습니다. 기 확보된 재고 Allo 후 PR 생성 바랍니다.'
		SET @v_body_cont = '';
		SET @v_head_cont = N'<TR>
			<TH>Request No</TH>
			<TH>Div</TH>
			<TH>Project Code</TH>
			<TH>Seq.</TH>
			<TH>Model</TH>
			<TH>Model Name</TH>
			<TH>UOM</TH>
			<TH>To Site</TH>
			<TH>Request Date</TH>
			<TH>Request Qty</TH>
			<TH>Requestor</TH>
			<TH>Update date</TH>
			</TR>'

		DECLARE CUR_SEND CURSOR FAST_FORWARD FOR
		SELECT A.DIVISION_ID, A.PROJECT_CODE, A.ITEM_SEQ, A.ITEM_ID, B.ITEM_NAME
			 , A.UOM, A.SCM_SITE_ID, A.YYYYMMDD, A.PLAN_QTY, A.CREATED_BY
			 , A.LAST_UPDATE_DATE
		FROM DM_PLN_PR_DETAIL A WITH (NOLOCK)
		LEFT OUTER JOIN DM_MST_ITEM_SINGLE_V B WITH (NOLOCK)
					 ON A.DIVISION_ID = B.DIVISION_ID 
					AND A.ITEM_ID = B.ITEM_ID
		WHERE REQUEST_NO = @V_REQUEST_NO
		ORDER BY ITEM_SEQ

		OPEN CUR_SEND;
		FETCH NEXT FROM CUR_SEND INTO @V_DIVISION_ID, @V_PROJECT_CODE, @V_ITEM_SEQ, @V_ITEM_ID, @V_ITEM_NAME
								    , @V_UOM, @V_SCM_SITE_ID, @V_CURSOR_YYYYMMDD, @V_PLAN_QTY, @V_CREATED_BY, @V_LAST_UPDATE_DATE

		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @v_body_cont = @v_body_cont+ '<TR>'
			SET @v_body_cont = @v_body_cont+ '<TD>' + ISNULL(@V_REQUEST_NO,'') + '</TD>'	
			SET @v_body_cont = @v_body_cont+ '<TD>'	+ ISNULL(@V_DIVISION_ID,'') + '</TD>'	
			SET @v_body_cont = @v_body_cont+ '<TD>'	+ ISNULL(@V_PROJECT_CODE,'') + '</TD>'	
			SET @v_body_cont = @v_body_cont+ '<TD>'	+ ISNULL(CONVERT(NVARCHAR(5), @V_ITEM_SEQ),'') + '</TD>'	
			SET @v_body_cont = @v_body_cont+ '<TD>'	+ ISNULL(@V_ITEM_ID,'') + '</TD>'	
			SET @v_body_cont = @v_body_cont+ '<TD>'	+ ISNULL(@V_ITEM_NAME,'') + '</TD>'	
			SET @v_body_cont = @v_body_cont+ '<TD>'	+ ISNULL(@V_UOM,'') + '</TD>'	
			SET @v_body_cont = @v_body_cont+ '<TD>'	+ ISNULL(@V_SCM_SITE_ID,'') + '</TD>'	
			SET @v_body_cont = @v_body_cont+ '<TD>'	+ ISNULL(CONVERT(NVARCHAR(10), CAST(@V_CURSOR_YYYYMMDD AS DATETIME), 120),'') + '</TD>'	
			SET @v_body_cont = @v_body_cont+ '<TD ALIGN="RIGHT">'	+ DBO.FN_GET_NUMER_TO_STRING(@V_PLAN_QTY,0) + '</TD>'	
			SET @v_body_cont = @v_body_cont+ '<TD>'	+ ISNULL(@V_CREATED_BY,'') + '</TD>'	
			SET @v_body_cont = @v_body_cont+ '<TD>'	+ ISNULL(CONVERT(NVARCHAR(10), @V_LAST_UPDATE_DATE, 120),'') + '</TD>'	
			SET @v_body_cont = @v_body_cont+ '</TR>'
		
			FETCH NEXT FROM CUR_SEND INTO @V_DIVISION_ID, @V_PROJECT_CODE, @V_ITEM_SEQ, @V_ITEM_ID, @V_ITEM_NAME
									    , @V_UOM, @V_SCM_SITE_ID, @V_CURSOR_YYYYMMDD, @V_PLAN_QTY, @V_CREATED_BY, @V_LAST_UPDATE_DATE
		END
	
		CLOSE CUR_SEND;
		DEALLOCATE CUR_SEND;

			SET @TABLE_BODY = ' <html>
							<head>
									<title>Untitled Document</title>
									<style>
										* {margin:0;padding:0;}
										body {font-family:Malgun Gothic, Arial, Helvetica, sans-serif;font-size:12px;line-height:1.8;color:#333333;}
										table {border-collapse:collapse;width:100%;}
										table th {background:#f5f5f5;border-bottom:1px solid #e1e1e1;}
										table td {background:#fff;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1;border-bottom:1px solid #e1e1e1;}
										table tbody th {border-left:1px solid #e1e1e1;text-align:right;padding:6px 8px;font-size:12px}
										table tbody td {padding:6px 8px;font-size:12px}
										table thead th {text-align:center;padding:3px;border-right:1px solid #e1e1e1;border-left:1px solid #e1e1e1; border-bottom:1px solid #d1d1d1;font-size:12px}
										.hori-table table thead td {text-align:center;padding:3px;}  
										.hori-table table tbody td {text-align:center;padding:3px;}
										.vertical-table, .hori-table {margin-bottom:20px;}
									</style>
									</head>
									<body>' +'</br>'+
											'<b>' + REPLACE(ISNULL(@v_body_contents, ''), CHAR(10), '<br>') + '</b>' +
											'<div id="divBody" style="width: 100%; overflow-x: auto; overflow-y: auto; font-size: 9pt; line-break: auto;">'    +   
										'<table style=''border-top:2px solid #c8294b; width:1450px;''>
										<thead>' + ISNULL(@v_head_cont,'') +'</thead>
										<tbody>' + ISNULL(@v_body_cont, '') + '</tbody>
										</div>
									</body>
							</html>';

		/*========================================================================================================================
		-- 메일 발송
		========================================================================================================================*/
		IF DB_NAME() <> 'LGCE_SCMDEV'
		BEGIN
			EXEC SCM_ADM_MAIL_SEND
				 @v_to_mail					--//'kahonmalu@lgensol.com'
			   , @v_mail_title
			   , @TABLE_BODY
			  , 'Y'
			;
		END

		/*========================================================================================================================			
		--MAIL 발송 LOG 저장
		========================================================================================================================*/
		EXEC SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG 
			'MAIL'
			, '-'
			, @v_program_name
			, @v_division_id
			, @V_REQUEST_NO
			, ''
			, ''
			, ''
			, ''
			, ''
			, ''
			, ''
			, '' --p_send_pgm
			, @v_to_mail
		;

		SELECT @V_REQUEST_NO AS REQUEST_NO

		--declare @a nvarchar(20)
		--exec dm_tran_test_sub 1, @a output
		
		--if isnull(@a, '') <> 'ok'
		--	raiserror(@a, 16, 1)

		--raiserror('ss', 16, 1)

		-- ESS 프로시저 호출	------------------------------------------------------------------------------------

  		-- 트랜잭션 (COMMIT)
		--IF XACT_STATE() <> 0
		--BEGIN
		--	SELECT @@TRANCOUNT
		--	COMMIT TRANSACTION;  -- sss
		--END
		IF XACT_STATE() > 0 and @@trancount > 0
		BEGIN
			COMMIT TRAN 
		END
	------------------------------------------------------------------------------------------	
	END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
		-- 트랜잭션 (END)
		--select XACT_STATE() as xact_state_1, @@trancount 
		--select XACT_STATE() as xact_state_2, @@trancount, 'A21'
		IF @@trancount > 0
		BEGIN 
			ROLLBACK TRAN
		END
		
		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_log_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();

		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE() AS ERR_MSG;  /*-- 에러메시지 DISPLAY --*/

		EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_log_description, @d_event_date, @p_CREATED_BY;

	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

	/*========================================================================================================================		
    -- 종료 LOG
	========================================================================================================================*/	
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure @@@##########';
    SET @v_log_description = 'input_count: ' + Convert(NVARCHAR(10), @n_input_count) ;
    SET @d_event_date = SYSDATETIME();

    EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_log_description, @d_event_date, @p_CREATED_BY;

  END;
  	
	--[E20250401-000548]_VALIDATION 체크시 로그 찍는 부분 추가 START
	/*========================================================================================================================
	-- 트랜잭션 (INVALID)
	========================================================================================================================*/
	ERR_RTN:
	IF @v_log_type = 'INVALID'
		BEGIN
			IF @@trancount > 0
			BEGIN 
				ROLLBACK TRAN
			END

			SET @d_event_date = SYSDATETIME();
			EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_log_description, @d_event_date, @p_CREATED_BY;
			
			SELECT @v_log_message AS ERR_MSG;  /*-- 에러메시지 DISPLAY --*/
			
			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_log_description = 'input_count: ' + Convert(NVARCHAR(10), @n_input_count) ;
			SET @d_event_date = SYSDATETIME();
			EXEC PR_DM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_log_description, @d_event_date, @p_CREATED_BY;
		END
	--[E20250401-000548]_VALIDATION 체크시 로그 찍는 부분 추가 END








