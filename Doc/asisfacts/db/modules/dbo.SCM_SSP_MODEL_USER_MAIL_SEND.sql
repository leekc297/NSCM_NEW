
/*
 * Program ID   : SCM_SSP_MODEL_USER_MAIL_SEND
 * Description  : SSP 모델 PIC 추가 사용자 MAIL 발송
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023/01/25   jilee   Initial Release SSP_MST_MODEL_USER 등록된 추가 사용자 메일 발송 

 */
CREATE PROCEDURE [dbo].[SCM_SSP_MODEL_USER_MAIL_SEND]

	 @p_request_no     nvarchar(max)
	,@p_request_status nvarchar(100)
	,@p_division_id    nvarchar(max)
	,@p_from_site	   nvarchar(max)
	,@p_item_id	       nvarchar(max)
	
AS

BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;
	
	DECLARE @v_to_mail              NVARCHAR(MAX);
	DECLARE @v_category_id			INT;
	DECLARE @v_approval_id			NVARCHAR(MAX);
	DECLARE @v_request_id			NVARCHAR(MAX);
	DECLARE @v_mail_title			NVARCHAR(MAX);
	DECLARE @v_body_contents		NVARCHAR(MAX);
	DECLARE @v_body_contents_sh		NVARCHAR(MAX);

	DECLARE @v_body_text			NVARCHAR(MAX);
	DECLARE @v_head_cont		    NVARCHAR(MAX);
	DECLARE @v_a_body_contents		NVARCHAR(MAX);
	DECLARE @TABLE_BODY				NVARCHAR(MAX);
	DECLARE @p_html_yn				NVARCHAR(1);
	
	DECLARE @v_division_id		NVARCHAR(30);
	DECLARE @v_item_id			NVARCHAR(50);
	DECLARE @v_nick_name		NVARCHAR(50);
	DECLARE @v_from_site		NVARCHAR(30);
	DECLARE @v_from_site_description	NVARCHAR(MAX);
	DECLARE @v_to_site			NVARCHAR(30);
	DECLARE @v_to_site_description		NVARCHAR(MAX);
	DECLARE @v_mtk_owner		NVARCHAR(MAX);
	DECLARE @v_incoterms		NVARCHAR(10);
	DECLARE @v_yyyymmdd			NVARCHAR(10);
	DECLARE @v_qty				NVARCHAR(MAX);
	DECLARE @v_transport_mode	NVARCHAR(50);
	DECLARE @v_new_yyyymmdd		NVARCHAR(10);
	DECLARE @v_new_qty			NVARCHAR(MAX);
	DECLARE @v_new_transport_mode	NVARCHAR(50);
	DECLARE @v_last_update_date	NVARCHAR(50);
	DECLARE @v_last_update_by	NVARCHAR(MAX);

	SET @v_to_mail              = null;
	SET @v_category_id			= 0;
	SET @v_approval_id			= null;
	SET @v_request_id			= null;
	SET @v_mail_title			= null;
	SET @v_body_contents		= null;
	SET @v_body_contents_sh		= null;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'SCM_SSP_MODEL_USER_MAIL_SEND';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

	--계산용 변수
	DECLARE @chk INT=0; -- 쿼리결과 총 건수

	--DECLARE @i INT=1;	-- LOOP용
	DECLARE @mailChkCnt INT = 0;
	
	DECLARE @max_loop_cnt		   INTEGER; 
	DECLARE @mst_loop_cnt		   INTEGER;	
	DECLARE @v_modelUserattribute  NVARCHAR(MAX); 
	DECLARE @v_modelUser           NVARCHAR(50); 
	DECLARE @v_delimiter NVARCHAR(1)

	SET     @max_loop_cnt         = 0;
	SET     @mst_loop_cnt         = 0;	
	SET     @v_modelUserattribute = NULL;
	SET     @v_modelUser          = NULL;
	SET     @v_delimiter = '^' 
			
    --추가 메일 발송자 조회 : 수신자 갯수 확정시 추가 조건 넣기
	SELECT @v_modelUserattribute = ISNULL(mu.ATTRIBUTE1,'X') + @v_delimiter + ISNULL(mu.ATTRIBUTE2,'X') + @v_delimiter + ISNULL(mu.ATTRIBUTE3,'X')
	                               + @v_delimiter + ISNULL(mu.ATTRIBUTE4,'X') + @v_delimiter + ISNULL(mu.ATTRIBUTE5,'X')
	FROM SSP_MST_MODEL_USER mu WITH(NOLOCK)   
	WHERE  mu.DIVISION_ID	= @p_division_id			                                                                                                     
	AND    mu.FROM_SITE		= @p_from_site		                                                                                                     
	AND    mu.ITEM_ID		= @p_item_id				                                                                                                     
	AND    mu.VALID_YN		= 'Y'

	--임시테이블 생성(출하 계획 승인)
	IF OBJECT_ID('tempdb..#TblSSPApprovedMailSend2') IS NOT NULL
		DROP TABLE #TblSSPApprovedMailSend2 

	--IF @p_request_status = 'Q' --출하 계획 요청
	--	BEGIN
	--		SET @v_category_id = 14
	--	END
	--ELSE IF @p_request_status = 'A' --출하 계획 승인
	--	BEGIN
	--		SET @v_category_id = 15
	--	END
	--ELSE IF @p_request_status = 'R' --출하 계획 반려
	--	BEGIN
	--		SET @v_category_id = 16
	--	END
	--ELSE IF @p_request_status = 'S' --출하 계획 자가반려
	--	BEGIN
	--		SET @v_category_id = 13
	--	END    
	
	-- 출하 계획 승인만 해당됨
	SET @v_category_id = 15

	/********************************************************************************
	* Mail Setup 메뉴에 등록된 메일 정보 조회
	********************************************************************************/

	SELECT --@v_approval_id = C.APPROVAL_USER
		   --,@v_request_id = C.REQUEST_USER
		   @v_mail_title = CONCAT(C.MAIL_TITLE,'[',C.CHANGE_REQ_NO,']')
		  ,@v_body_contents = c.body_contents
	FROM(
		SELECT *
		FROM(
		SELECT A.APPROVAL_USER
			  ,A.REQUEST_USER
			  ,A.CHANGE_REQ_NO
			  ,A.CHANGE_REQ_STATUS
			  ,'KO' language
		FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ A WITH(NOLOCK)
		INNER JOIN TB_FX_User U ON A.REQUEST_USER = U.UserID AND U.UseYN = 'Y'
		) A,
		(
			SELECT a.use_type_code 
				,c.user_id
				,e.UserName as user_name 
				,e.Email as email_addr 
				,e.CellPhoneNum as mobile_phone 
				,b.language_code 
				,b.mail_title 
				,d.SEGMENT3       header_contents 
				,CASE A.USE_TYPE_CODE WHEN 'MAIL' THEN replace(b.message_content,char(10),'<br><br>') 
										WHEN 'SMS' THEN b.message_content END body_contents 
				,d.SEGMENT3      foot_contents
				,a.SQL_LONG_TEXT
			FROM SCM_ADM_RECIPIENT_LIST  a WITH(NOLOCK)
				INNER JOIN SCM_ADM_RECIPIENT_MESSAGE b ON a.CATEGORY_ID = B.CATEGORY_ID
				LEFT OUTER JOIN SCM_ADM_RECIPIENT_ASSIGN  c ON B.CATEGORY_ID = C.CATEGORY_ID  
				INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL  d ON D.SEGMENT1 = B.LANGUAGE_CODE AND D.LOOKUP_TYPE = 'MAIL_HEADER_FOOT' AND D.VALID_YN = 'Y' 
				LEFT OUTER JOIN TB_FX_User e ON B.LANGUAGE_CODE = E.Language AND C.USER_ID = E.UserID 
			WHERE a.category_id   = convert(nvarchar,@v_category_id)
				AND a.VALID_YN = 'Y' 
		) B
		WHERE A.language = B.LANGUAGE_CODE
	) C  WHERE 1=1
			AND c.CHANGE_REQ_NO = @p_request_no
			AND C.CHANGE_REQ_STATUS = @p_request_status

    

	/********************************************************************************
	* 출하 계획 요청 건 상세 내용 
	********************************************************************************/

	SELECT T0.DIVISION_ID
	,      T0.ITEM_ID
	,      T0.NICK_NAME
	,	   T0.FROM_SITE
	,      T0.FROM_SITE_DESCRIPTION
	,	   T0.TO_SITE
	,      T0.TO_SITE_DESCRIPTION
	,      T0.MTK_OWNER
	,      T0.INCOTERMS
	,	   T0.YYYYMMDD
	,	   T0.QTY
	,      T0.TRANSPORT_MODE
	,	   T0.NEW_YYYYMMDD
	,	   T0.NEW_QTY
	,      T0.NEW_TRANSPORT_MODE
	,      CONVERT(CHAR(23), T0.LAST_UPDATE_DATE, 21) AS LAST_UPDATE_DATE
	,      [dbo].[FN_GET_USER_NAME](T0.LAST_UPDATED_BY) + '(' +  T0.LAST_UPDATED_BY + ')'  AS LAST_UPDATED_BY
	,	   ROW_NUMBER() OVER (ORDER BY T0.DIVISION_ID, T0.ITEM_ID , T0.FROM_SITE, T0.TO_SITE, T0.YYYYMMDD, T0.TRANSPORT_MODE) AS ROWNUM
	INTO #TblSSPApprovedMailSend2
	FROM
	(
		SELECT D.DIVISION_ID 
		,      D.ITEM_ID 
		,      [dbo].[FN_GET_ITEM_NICKNAME](D.DIVISION_ID,D.ITEM_ID)              AS NICK_NAME 
		,      D.FROM_SITE 
		,      [dbo].[FN_GET_SCM_SITE_DESCRIPTION]( D.DIVISION_ID , D.FROM_SITE ) AS FROM_SITE_DESCRIPTION
		,      D.TO_SITE 
		,      [dbo].[FN_GET_SCM_SITE_DESCRIPTION]( D.DIVISION_ID , D.TO_SITE )   AS TO_SITE_DESCRIPTION
		,      DBO.FN_GET_SSP_MKT_OWNER_NAME (S.OWNER, ',', 'KO' )                AS MTK_OWNER
		,      D.INCOTERMS 
		,      SUBSTRING(D.YYYYMMDD,1,4)+'-'+SUBSTRING(D.YYYYMMDD,5,2)+'-'+SUBSTRING(D.YYYYMMDD,7,2) AS YYYYMMDD 
		,      REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(D.QTY AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') AS QTY 
		,      D.TRANSPORT_MODE 
		,      SUBSTRING(D.NEW_YYYYMMDD,1,4)+'-'+SUBSTRING(D.NEW_YYYYMMDD,5,2)+'-'+SUBSTRING(D.NEW_YYYYMMDD,7,2) AS NEW_YYYYMMDD 
		,      REPLACE(ISNULL(REPLACE(CONVERT(VARCHAR(50), CAST(D.NEW_QTY AS MONEY), 1) , '.00', ''),''), CHAR(10),' ') AS NEW_QTY 
		,      D.NEW_TRANSPORT_MODE
		,      D.PROJECT_CODE  
		,      H.APPROVAL_DEPT 
		,      CASE WHEN @p_request_status = 'A' THEN H.APPROVAL_TIME 
				    WHEN @p_request_status = 'R' THEN H.APPROVAL_TIME 
				ELSE H.LAST_UPDATE_DATE END LAST_UPDATE_DATE
		,      CASE WHEN @p_request_status = 'A' THEN CASE WHEN H.DELEGATEE_USER IS NULL THEN H.APPROVAL_USER ELSE H.DELEGATEE_USER END
				    WHEN @p_request_status = 'R' THEN CASE WHEN H.DELEGATEE_USER IS NULL THEN H.APPROVAL_USER ELSE H.DELEGATEE_USER END
				ELSE H.LAST_UPDATED_BY END LAST_UPDATED_BY
		FROM   SSP_ANL_SHIP_CONFIRM_CHG_REQ H WITH(NOLOCK) 
		JOIN SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE D WITH(NOLOCK) 
		ON H.CHANGE_REQ_NO = D.CHANGE_REQ_NO 
		AND D.VALID_YN = 'Y'
		LEFT OUTER JOIN  SCM_MST_SITE_ITEM S WITH(NOLOCK) 
		ON  S.DIVISION_ID  = CASE WHEN D.DIVISION_ID ='EE' THEN D.ORIGIN_TO_DIVISION_ID ELSE D.DIVISION_ID END 
		AND  S.SCM_SITE_ID  = D.TO_SITE 
		AND  S.ITEM_ID      = D.ITEM_ID 
		AND  S.PROJECT_CODE = D.PROJECT_CODE 
		WHERE  1=1  
		AND    H.CHANGE_REQ_STATUS = @p_request_status
		AND    H.CHANGE_REQ_NO =  @p_request_no
	) AS T0
	GROUP BY T0.DIVISION_ID, T0.ITEM_ID, T0.NICK_NAME, T0.FROM_SITE, T0.FROM_SITE_DESCRIPTION, T0.TO_SITE, T0.TO_SITE_DESCRIPTION, T0.MTK_OWNER,
	         T0.INCOTERMS, T0.YYYYMMDD, T0.QTY, T0.TRANSPORT_MODE, T0.NEW_YYYYMMDD, T0.NEW_QTY, T0.NEW_TRANSPORT_MODE, T0.LAST_UPDATE_DATE, T0.LAST_UPDATED_BY
			 
	ORDER BY T0.DIVISION_ID, T0.ITEM_ID , T0.FROM_SITE, T0.TO_SITE, T0.YYYYMMDD, T0.TRANSPORT_MODE

	SELECT @chk = COUNT(*)
	FROM #TblSSPApprovedMailSend2


	/********************************************************************************
	* 출하 계획 요청 건 상세 내용 테이블 만들기
	********************************************************************************/	
	
	SET @v_head_cont = '';
	SET @v_head_cont = @v_head_cont+ '<tr>'
	SET @v_head_cont = @v_head_cont+ '<th rowspan=''2''>' + 'Div' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th rowspan=''2''>' + 'Model' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th rowspan=''2''>' + 'Nick Name' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th rowspan=''2''>' + 'From Site' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th rowspan=''2''>' + 'To Site' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th rowspan=''2''>' + 'MKT Owner' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th rowspan=''2''>' + 'Incoterms' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th colspan=''3''>' + 'Old' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th colspan=''3''>' + 'New' + '</th>'
	SET @v_head_cont = @v_head_cont+ '</tr>'
	SET @v_head_cont = @v_head_cont+ '<tr>'
	SET @v_head_cont = @v_head_cont+ '<th width=''90px''>' + 'Shipment Date' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th width=''90px''>' + 'Shipment Qty' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th width=''80px''>' + 'Trans Mode' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th width=''90px''>' + 'Shipment Date' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th width=''90px''>' + 'Shipment Qty' + '</th>'
	SET @v_head_cont = @v_head_cont+ '<th width=''80px''>' + 'Trans Mode' + '</th>'
	SET @v_head_cont = @v_head_cont+ '</tr>'

	SET @v_a_body_contents = ''
	SET @v_body_text = ''

	SET @mailChkCnt = @mailChkCnt + 1; -- 한 행 FETCH시 마다 +1


	SELECT @v_division_id		= DIVISION_ID
			, @v_item_id			= ITEM_ID
			, @v_nick_name		= NICK_NAME
			, @v_from_site		= FROM_SITE
			, @v_from_site_description	= FROM_SITE_DESCRIPTION
			, @v_to_site			= TO_SITE
			, @v_to_site_description		= TO_SITE_DESCRIPTION
			, @v_mtk_owner		= MTK_OWNER
			, @v_incoterms		= INCOTERMS
			, @v_yyyymmdd		= YYYYMMDD
			, @v_qty				= QTY
			, @v_transport_mode	= TRANSPORT_MODE
			, @v_new_yyyymmdd	= NEW_YYYYMMDD
			, @v_new_qty			= NEW_QTY
			, @v_new_transport_mode		= NEW_TRANSPORT_MODE
			, @v_last_update_date		= LAST_UPDATE_DATE
			, @v_last_update_by	= LAST_UPDATED_BY
	FROM #TblSSPApprovedMailSend2
	WHERE ROWNUM=@mailChkCnt

	--WHILE @@FETCH_STATUS = 0
	WHILE @mailChkCnt <= @chk+1
		BEGIN

			IF @mailChkCnt=1
				BEGIN
					SET @v_body_text = @v_body_text+ 'Last updated by : '+@v_last_update_by+'    Last update Date : '+@v_last_update_date+'</br>'
				END

			IF (@mailChkCnt=@chk+1)
				BEGIN

					SET @TABLE_BODY = ''
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
														'<b>' + REPLACE(ISNULL(@v_body_contents, ''), CHAR(10), '<br>') + '</b>' + '</br>'+ '</br>'+
														'<b>' + REPLACE(ISNULL(@v_body_text, ''), CHAR(10), '<br>') + '</b>' +
				--										'<div id="divBody" style="width: 100%; overflow-x: auto; overflow-y: auto; font-size: 9pt; line-break: auto;">'    + '</br>'+   
													'<table style=''border-top:2px solid #c8294b; width:1200px;''>
													<thead>' + ISNULL(@v_head_cont,'') +'</thead>
													<tbody>' + ISNULL(@v_a_body_contents, '') + '</tbody>
													</div>
												</body>
										</html>'
				END

		SET @v_a_body_contents = @v_a_body_contents+ '<tr>'
		SET @v_a_body_contents = @v_a_body_contents+ '<td>' + REPLACE(ISNULL(@v_division_id,''), CHAR(10),' ') + '</td>'
		SET @v_a_body_contents = @v_a_body_contents+ '<td>' + REPLACE(ISNULL(@v_item_id,''), CHAR(10),' ') + '</td>'
		SET @v_a_body_contents = @v_a_body_contents+ '<td>' + REPLACE(ISNULL(@v_nick_name,''), CHAR(10),' ') + '</td>'
		SET @v_a_body_contents = @v_a_body_contents+ '<td>' + REPLACE(ISNULL(@v_from_site_description,''), CHAR(10),' ') + '</td>'
		SET @v_a_body_contents = @v_a_body_contents+ '<td>' + REPLACE(ISNULL(@v_to_site_description,''), CHAR(10),' ') + '</td>'
		SET @v_a_body_contents = @v_a_body_contents+ '<td>' + REPLACE(ISNULL(@v_mtk_owner,''), CHAR(10),' ') + '</td>'
		SET @v_a_body_contents = @v_a_body_contents+ '<td>' + REPLACE(ISNULL(@v_incoterms,''), CHAR(10),' ') + '</td>'
		SET @v_a_body_contents = @v_a_body_contents+ '<td align=''center''>' + REPLACE(ISNULL(@v_yyyymmdd,''), CHAR(10),' ') + '</td>'
		SET @v_a_body_contents = @v_a_body_contents+ '<td align=''right''>' + REPLACE(ISNULL(@v_qty,''), CHAR(10),' ') + '</td>'
		SET @v_a_body_contents = @v_a_body_contents+ '<td>' + REPLACE(ISNULL(@v_transport_mode,''), CHAR(10),' ') + '</td>'
		SET @v_a_body_contents = @v_a_body_contents+ '<td align=''center''>' + REPLACE(ISNULL(@v_new_yyyymmdd,''), CHAR(10),' ') + '</td>'
		SET @v_a_body_contents = @v_a_body_contents+ '<td align=''right''>' + REPLACE(ISNULL(@v_new_qty,''), CHAR(10),' ') + '</td>'
		SET @v_a_body_contents = @v_a_body_contents+ '<td>' + REPLACE(ISNULL(@v_new_transport_mode,''), CHAR(10),' ') + '</td>'
		SET @v_a_body_contents = @v_a_body_contents+ '</tr>'

		SET @mailChkCnt = @mailChkCnt + 1;

		SELECT @v_division_id		= DIVISION_ID
				, @v_item_id			= ITEM_ID
				, @v_nick_name		= NICK_NAME
				, @v_from_site		= FROM_SITE
				, @v_from_site_description	= FROM_SITE_DESCRIPTION
				, @v_to_site			= TO_SITE
				, @v_to_site_description		= TO_SITE_DESCRIPTION
				, @v_mtk_owner		= MTK_OWNER
				, @v_incoterms		= INCOTERMS
				, @v_yyyymmdd		= YYYYMMDD
				, @v_qty				= QTY
				, @v_transport_mode	= TRANSPORT_MODE
				, @v_new_yyyymmdd	= NEW_YYYYMMDD
				, @v_new_qty			= NEW_QTY
				, @v_new_transport_mode		= NEW_TRANSPORT_MODE
				, @v_last_update_date		= LAST_UPDATE_DATE
				, @v_last_update_by	= LAST_UPDATED_BY
		FROM #TblSSPApprovedMailSend2
		WHERE ROWNUM=@mailChkCnt

				
	END;

	BEGIN TRY
			-- 시작 LOG
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		--IF @p_request_status = 'Q' --출하 계획 요청
		--	BEGIN
		--		SET @v_to_mail = @v_approval_id + '@lgensol.com'
		--	END
		--ELSE IF @p_request_status = 'A' --출하 계획 승인
		--	BEGIN
		--		SET @v_to_mail = @v_request_id + '@lgensol.com'
		--	END
		--ELSE IF @p_request_status = 'R' --출하 계획 반려
		--	BEGIN
		--		SET @v_to_mail = @v_request_id + '@lgensol.com'
		--	END
		--ELSE IF @p_request_status = 'S' --출하 계획 자가반려
		--	BEGIN
		--		SET @v_to_mail = @v_approval_id + '@lgensol.com'
		--	END

		SET @v_body_contents = @TABLE_BODY
		SET @p_html_yn = 'Y'

		-- While Loop Start 
		SET @max_loop_cnt = [dbo].[SCM_ARR_SPL_CNT](@v_modelUserattribute, @v_delimiter);

		WHILE LEN(@v_modelUserattribute) > 0 AND @mst_loop_cnt < @max_loop_cnt
		BEGIN
		    -- @mst_loop_cnt 1증가
			SET @mst_loop_cnt = @mst_loop_cnt + 1;

			IF LEN(@v_body_contents) > 100 AND @mst_loop_cnt = 1
				BEGIN
					SET @v_body_contents_sh = SUBSTRING(@v_body_contents,1,100);
				END
				
			BEGIN
			    
				SET @v_modelUser = dbo.SCM_ARR_SPL_VAL( @v_modelUserattribute, @v_delimiter, @mst_loop_cnt );
				
				IF @v_modelUser <> 'X' AND @v_modelUser <> ''
				BEGIN
				    SET @v_to_mail = @v_modelUser + '@lgensol.com'
					
					EXEC SCM_ADM_MAIL_SEND
							--@v_to_mail 운영배포용
							'jooyong026@@lgespartner.com'-- 개발 테스트용
							,@v_mail_title
							,@v_body_contents
							,@p_html_yn
							;

					--//대리자 검색=================================================================================
					--IF @p_request_status = 'Q' OR @p_request_status = 'S' --출하 계획 요청 or 출하 계획 자가반려
					--BEGIN
					--	DECLARE @v_delegatee		NVARCHAR(MAX);
					--	SET @v_delegatee=  NULL;
					--	SET @v_delegatee = (SELECT TOP 1 A.DELEGATEE_ID FROM SSP_MST_DELEGATE A 
					--						WHERE A.DIVISION_ID = @v_division_id
					--						AND A.USER_ID = @v_approval_id
					--						AND A.VALID_YN = 'Y'
					--						AND CONVERT(NVARCHAR(8), GETDATE(), 112) BETWEEN A.FROM_DATE AND A.TO_DATE
					--						GROUP BY A.DELEGATEE_ID);
					--	IF LEN(ISNULL(@v_delegatee, '')) > 0
					--	BEGIN
					--		SET @v_to_mail = @v_delegatee + '@lgensol.com';

					--		-- 메일 발송
					--		EXEC SCM_ADM_MAIL_SEND
					--				@v_to_mail
					--				,@v_mail_title
					--				,@v_body_contents
					--				,@p_html_yn
					--				;
					--	END;
					--END;
					--///////////////////////////////////////////////////////////////////////////////////////////////////
					
					--MAIL 발송 LOG 저장		
					EXEC SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG 'MAIL'
									,@v_category_id
									,@v_mail_title
									,@v_body_contents_sh
									,'Add Mail User'
									,''
									,''
									,''
									,''
									,''
									,''
									,''
									,'' --p_send_pgm
									,@v_to_mail;
				END		
			END
		END -- While Loop End

		SET @v_log_type = 'END';
		SET @v_log_message = '########## END of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

	END TRY

	BEGIN CATCH
		CLOSE CUR_SEND;
		DEALLOCATE CUR_SEND;
		BEGIN

		INSERT INTO scm_sys_log_batch (program_name
										,log_type
										,log_count
										,log_message
										,description
										,event_date
										,creation_date
										,created_by
										,last_update_date
										,last_updated_by)
		VALUES (ERROR_PROCEDURE()
				,'ERROR'
				,NULL
				,ERROR_MESSAGE()
				,NULL
				,SYSDATETIME()
				,SYSDATETIME()
				,ERROR_PROCEDURE()
				,SYSDATETIME()
				,ERROR_PROCEDURE());

		IF @@TRANCOUNT > 0
			COMMIT WORK;
		END;
				
		-- error코드, errror 메시지 반환
		SELECT 'F' AS result_code;
		SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
	END CATCH;

	--임시테이블 삭제
	IF OBJECT_ID('tempdb..#TblSSPApprovedMailSend2') IS NOT NULL
		DROP TABLE #TblSSPApprovedMailSend2
END







