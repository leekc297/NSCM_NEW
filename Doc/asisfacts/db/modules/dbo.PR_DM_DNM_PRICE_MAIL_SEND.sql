/****************************************************************************************************
* Program ID  : PR_DM_DNM_PRICE_MAIL_SEND                                                 
* Description : 금요일 아침에 PRICE 누락건에 관련해 마케팅팀과 영업관리팀에게 현재상황 발송
* Usage       :                                 
* Parameter   :                                                                                    
*                                                                                                  
*--------------------------------------------------------------------------------------------------
* Date        In Charge    Description                                                             
*--------------------------------------------------------------------------------------------------
* 2022.02.22	rosia27		신규생성([PJ20216891R] LGES Digital SCM 3 Level 가속화를 위한 개선_요구사항 질문사항)
* 2022.04.05    HWI1993     GM JV 작업
* 2022.04.20	rosia27		[C20220323-000058]Sales Price 누락 안내 메일 수신자 리스트 확대 및 Price 구간 축소 요청
* 2023-08-04    HMIN        [E20230721-001841] 용어 수정  GSCM->SCM
---------------------------------------------------------------------------------------------------------------------
*/

CREATE PROC [dbo].[PR_DM_DNM_PRICE_MAIL_SEND]
AS
SET NOCOUNT ON

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_DNM_PRICE_MAIL_SEND';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @dispatch_serial_no INT;

	-- 시작 LOG
	SET @v_log_type = 'START';
	SET @v_log_message = '########## Start of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

BEGIN TRY

	IF OBJECT_ID (N'tempdb..#TEMP_MEASURE', N'U') IS NOT NULL 
	    DROP TABLE #TEMP_MEASURE;
    IF OBJECT_ID (N'tempdb..#TEMP_FCST_TYPE', N'U') IS NOT NULL 
	    DROP TABLE #TEMP_FCST_TYPE;
	IF OBJECT_ID (N'tempdb..#T_PRICE', N'U') IS NOT NULL 
	    DROP TABLE #T_PRICE;
	IF OBJECT_ID (N'tempdb..#T_PRICE_RESULT', N'U') IS NOT NULL 
	    DROP TABLE #T_PRICE_RESULT;

-- 1. MIN_DATE를 차주 월요일, MAX_DATE는 52주후의 월요일 전날 설정

	DECLARE @MIN_DATE NCHAR(8), @MAX_DATE NCHAR(8);

	SELECT @MIN_DATE = MIN(BASIS_START_DATE)
		, @MAX_DATE = MAX(BASIS_END_DATE)
	FROM [DBO].[SCM_SYS_CALENDAR_M] M WITH(NOLOCK) 
	WHERE M.BASIS_YYYYMMDD >= CONVERT(CHAR(8), DBO.FN_NEXT_DAY(GETDATE(), 'MON'), 112)  --차주 월요일부터
		AND M.CALENDAR_YYYY = CONVERT(CHAR(4), GETDATE(), 112);  -- 해당연도
	

-- 2. MEASURE와 FCST_TYPE인 것을 임시테이블에 INSERT

	SELECT SEGMENT2 
	INTO #TEMP_MEASURE
	FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST with(nolock)
	WHERE 1=1
	AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
	AND MST.SEGMENT1     = 'MEASURE'
	AND VALID_YN        = 'Y' ;

	SELECT SEGMENT2 
	INTO #TEMP_FCST_TYPE 
	FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST with(nolock)
	WHERE 1=1
	AND MST.LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
	AND MST.SEGMENT1     = 'FCST_TYPE'
	AND VALID_YN        = 'Y' ;

-- 3. 집계

		SELECT A.DIVISION_ID
				, A.PROJECT_CODE
				, A.SCM_SITE_ID
				, A.ITEM_ID
				, A.DOM_EXP
				, A.FCST_TYPE
				, A.INCOTERMS
				, ISNULL(A.PLANT_SITE_ID ,'')AS PLANT_SITE_ID
				, A.OWNER
				, UI.DEPT_ID
				, M.BASIS_START_DATE
				, 1 AS TOTAL_NUM
		INTO #T_PRICE
		FROM (SELECT DISTINCT B.DIVISION_ID, B.PROJECT_CODE, B.SCM_SITE_ID, B.PLANT_SITE_ID, B.ITEM_ID, B.DOM_EXP, FCST.SEGMENT1 AS FCST_TYPE, B.INCOTERMS, C.token AS OWNER
				FROM DM_PLN_MKT_FCST AS B
				INNER JOIN SCM_MST_SITE_ITEM AS Z WITH(NOLOCK)
						ON ( B.DIVISION_ID		 = Z.DIVISION_ID
						AND B.PROJECT_CODE	 = Z.PROJECT_CODE
						AND B.SCM_SITE_ID		 = Z.SCM_SITE_ID
						AND B.ITEM_ID			 = Z.ITEM_ID
						AND Z.VALID_YN			 = 'Y'
						AND ( Z.SALES_PLAN_ADJUST_YN = 'Y'OR Z.SALES_PLAN_ADJUST_YN = '' OR Z.SALES_PLAN_ADJUST_YN IS NULL ) ) 
				JOIN (SELECT SEGMENT1, SEGMENT2
						FROM SCM_ADM_LOOKUP_MASTER_DETAIL MST WITH(NOLOCK)
						WHERE 1=1
						AND MST.LOOKUP_TYPE = 'SALES_TYPE_CODE') AS FCST
						ON FCST.SEGMENT1    = B.FCST_TYPE
				CROSS APPLY DBO.STRING_SPLIT(Z.OWNER, ',') AS C 
				WHERE B.MEASURE IN ( SELECT * FROM #TEMP_MEASURE)
				  AND B.FCST_TYPE NOT IN (  SELECT * FROM #TEMP_FCST_TYPE)
				  AND B.YYYYMMDD BETWEEN @MIN_DATE  AND @MAX_DATE
				  AND B.DIVISION_ID='40'
				  AND B.QTY <> 0
				  AND C.token IS NOT NULL) AS A
		INNER JOIN SCM_MST_SSO_USER_INFO AS UI WITH(NOLOCK)
				ON A.OWNER = UI.USER_ID
		INNER JOIN (
					SELECT BASIS_START_DATE 
					FROM [DBO].[SCM_SYS_CALENDAR_M] M WITH(NOLOCK) 
						WHERE M.BASIS_YYYYMMDD >= CONVERT(CHAR(8), DBO.FN_NEXT_DAY(GETDATE(), 'MON'), 112)  --차주 월요일부터
						AND  M.CALENDAR_YYYY = CONVERT(CHAR(4), GETDATE(), 112) -- 해당 연도
					GROUP BY BASIS_START_DATE
					) AS M
			ON 1=1
		LEFT JOIN (SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY, DOM_EXP, FCST_TYPE, INCOTERMS
				FROM SCM_MST_FUTURE_PRICE  WITH (NOLOCK)
				WHERE DIVISION_ID = '40'
					AND MEASURE IN ( 'KRW', 'LOC', 'USD' )
					AND YYYYMMDD BETWEEN @MIN_DATE AND @MAX_DATE
					AND PRICE <> 0
				GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, PLANT_SITE_ID, ITEM_ID, YYYYMMDD, CURRENCY, DOM_EXP, FCST_TYPE, INCOTERMS
				HAVING COUNT(*) = 3) AS P
				ON (A.DIVISION_ID		= P.DIVISION_ID
				AND A.PROJECT_CODE	= P.PROJECT_CODE
				AND A.SCM_SITE_ID	= P.SCM_SITE_ID
				AND A.ITEM_ID		= P.ITEM_ID
				AND A.DOM_EXP		= P.DOM_EXP
				AND A.FCST_TYPE		= P.FCST_TYPE
				AND A.INCOTERMS		= P.INCOTERMS
				AND A.PLANT_SITE_ID = CASE WHEN A.DIVISION_ID LIKE '81%' THEN P.PLANT_SITE_ID ELSE A.PLANT_SITE_ID END 
				AND P.YYYYMMDD		= M.BASIS_START_DATE)
		WHERE 1=1
		AND P.YYYYMMDD IS NULL  -- PRICE값이 없는경우
		
-- 4. 최종 정리(PIVOT)

		SELECT *
		INTO #T_PRICE_RESULT
		FROM (
			SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, OWNER, DEPT_ID, TOTAL_NUM
					, ISNULL([1],'')
					+ CASE WHEN ISNULL([2], '') <> '' THEN ', ' + [2] ELSE '' END
					+ CASE WHEN ISNULL([3], '') <> '' THEN ', ' + [3] ELSE '' END
					+ CASE WHEN ISNULL([4], '') <> '' THEN ', ' + [4] ELSE '' END
					+ CASE WHEN ISNULL([5], '') <> '' THEN ', ' + [5] ELSE '' END
					+ CASE WHEN ISNULL([6], '') <> '' THEN ', ' + [6] ELSE '' END
					+ CASE WHEN ISNULL([7], '') <> '' THEN ', ' + [7] ELSE '' END
					+ CASE WHEN ISNULL([8], '') <> '' THEN ', ' + [8] ELSE '' END
					+ CASE WHEN ISNULL([9], '') <> '' THEN ', ' + [9] ELSE '' END
					+ CASE WHEN ISNULL([10], '') <> '' THEN ', ' + [10] ELSE '' END
					+ CASE WHEN ISNULL([11], '') <> '' THEN ', ' + [11] + '</br>' ELSE '' END
					+ CASE WHEN ISNULL([12], '') <> '' THEN ', ' + [12] ELSE '' END
					+ CASE WHEN ISNULL([13], '') <> '' THEN ', ' + [13] ELSE '' END
					+ CASE WHEN ISNULL([14], '') <> '' THEN ', ' + [14] ELSE '' END
					+ CASE WHEN ISNULL([15], '') <> '' THEN ', ' + [15] ELSE '' END
					+ CASE WHEN ISNULL([16], '') <> '' THEN ', ' + [16] ELSE '' END
					+ CASE WHEN ISNULL([17], '') <> '' THEN ', ' + [17] ELSE '' END
					+ CASE WHEN ISNULL([18], '') <> '' THEN ', ' + [18] ELSE '' END
					+ CASE WHEN ISNULL([19], '') <> '' THEN ', ' + [19] ELSE '' END
					+ CASE WHEN ISNULL([20], '') <> '' THEN ', ' + [20] ELSE '' END
					+ CASE WHEN ISNULL([21], '') <> '' THEN ', ' + [21] ELSE '' END
					+ CASE WHEN ISNULL([22], '') <> '' THEN ', ' + [22] + '</br>' ELSE '' END
					+ CASE WHEN ISNULL([23], '') <> '' THEN ', ' + [23] ELSE '' END
					+ CASE WHEN ISNULL([24], '') <> '' THEN ', ' + [24] ELSE '' END
					+ CASE WHEN ISNULL([25], '') <> '' THEN ', ' + [25] ELSE '' END
					+ CASE WHEN ISNULL([26], '') <> '' THEN ', ' + [26] ELSE '' END
					+ CASE WHEN ISNULL([27], '') <> '' THEN ', ' + [27] ELSE '' END
					+ CASE WHEN ISNULL([28], '') <> '' THEN ', ' + [28] ELSE '' END
					+ CASE WHEN ISNULL([29], '') <> '' THEN ', ' + [29] ELSE '' END
					+ CASE WHEN ISNULL([30], '') <> '' THEN ', ' + [30] ELSE '' END
					+ CASE WHEN ISNULL([31], '') <> '' THEN ', ' + [31] ELSE '' END
					+ CASE WHEN ISNULL([32], '') <> '' THEN ', ' + [32] ELSE '' END
					+ CASE WHEN ISNULL([33], '') <> '' THEN ', ' + [33] + '</br>' ELSE '' END
					+ CASE WHEN ISNULL([34], '') <> '' THEN ', ' + [34] ELSE '' END
					+ CASE WHEN ISNULL([35], '') <> '' THEN ', ' + [35] ELSE '' END
					+ CASE WHEN ISNULL([36], '') <> '' THEN ', ' + [36] ELSE '' END
					+ CASE WHEN ISNULL([37], '') <> '' THEN ', ' + [37] ELSE '' END
					+ CASE WHEN ISNULL([38], '') <> '' THEN ', ' + [38] ELSE '' END
					+ CASE WHEN ISNULL([39], '') <> '' THEN ', ' + [39] ELSE '' END
					+ CASE WHEN ISNULL([40], '') <> '' THEN ', ' + [40] ELSE '' END
					+ CASE WHEN ISNULL([41], '') <> '' THEN ', ' + [41] ELSE '' END
					+ CASE WHEN ISNULL([42], '') <> '' THEN ', ' + [42] ELSE '' END
					+ CASE WHEN ISNULL([43], '') <> '' THEN ', ' + [43] ELSE '' END
					+ CASE WHEN ISNULL([44], '') <> '' THEN ', ' + [44] + '</br>' ELSE '' END
					+ CASE WHEN ISNULL([45], '') <> '' THEN ', ' + [45] ELSE '' END
					+ CASE WHEN ISNULL([46], '') <> '' THEN ', ' + [46] ELSE '' END
					+ CASE WHEN ISNULL([47], '') <> '' THEN ', ' + [47] ELSE '' END
					+ CASE WHEN ISNULL([48], '') <> '' THEN ', ' + [48] ELSE '' END
					+ CASE WHEN ISNULL([49], '') <> '' THEN ', ' + [49] ELSE '' END
					+ CASE WHEN ISNULL([50], '') <> '' THEN ', ' + [50] ELSE '' END
					+ CASE WHEN ISNULL([51], '') <> '' THEN ', ' + [51] ELSE '' END
					+ CASE WHEN ISNULL([52], '') <> '' THEN ', ' + [52] ELSE '' END
					+ CASE WHEN ISNULL([53], '') <> '' THEN ', ' + [53] ELSE '' END
					+ CASE WHEN ISNULL([54], '') <> '' THEN ', ' + [54] ELSE '' END
					+ CASE WHEN ISNULL([55], '') <> '' THEN ', ' + [55] + '</br>' ELSE '' END
					+ CASE WHEN ISNULL([56], '') <> '' THEN ', ' + [56] ELSE '' END
					+ CASE WHEN ISNULL([57], '') <> '' THEN ', ' + [57] ELSE '' END
					+ CASE WHEN ISNULL([58], '') <> '' THEN ', ' + [58] ELSE '' END
					+ CASE WHEN ISNULL([59], '') <> '' THEN ', ' + [59] ELSE '' END
					+ CASE WHEN ISNULL([60], '') <> '' THEN ', ' + [60] ELSE '' END
					+ CASE WHEN ISNULL([61], '') <> '' THEN ', ' + [61] ELSE '' END
					+ CASE WHEN ISNULL([62], '') <> '' THEN ', ' + [62] ELSE '' END
					+ CASE WHEN ISNULL([63], '') <> '' THEN ', ' + [63] ELSE '' END
					+ CASE WHEN ISNULL([64], '') <> '' THEN ', ' + [64] ELSE '' END
					+ CASE WHEN ISNULL([65], '') <> '' THEN ', ' + [65] ELSE '' END AS MISSING_DATE
		FROM(
		SELECT PRI.DIVISION_ID, PRI.PROJECT_CODE, PRI.SCM_SITE_ID, PRI.ITEM_ID, PRI.DOM_EXP, PRI.FCST_TYPE, PRI.INCOTERMS, PRI.PLANT_SITE_ID, PRI.OWNER, PRI.DEPT_ID, PRI.BASIS_START_DATE
			, SUM(PRI.TOTAL_NUM) OVER (PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, OWNER, DEPT_ID
								ORDER BY ITEM_ID) AS TOTAL_NUM
			, ROW_NUMBER() OVER (PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, OWNER, DEPT_ID, TOTAL_NUM
								ORDER BY BASIS_START_DATE) AS ROWNUM
		FROM #T_PRICE AS PRI) TOTAL
		PIVOT(MAX(BASIS_START_DATE) FOR ROWNUM IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12], [13], [14], [15], [16], [17], [18], [19], [20]
												, [21], [22], [23], [24], [25], [26], [27], [28], [29], [30], [31], [32], [33], [34], [35], [36], [37], [38], [39], [40]
												, [41], [42], [43], [44], [45], [46], [47], [48], [49], [50], [51], [52], [53], [54], [55], [56], [57], [58], [59], [60]
												, [61], [62], [63], [64], [65]) ) AS PIVOT_RESULTS) AS RESULTS

	-----------------------------------------------------------------------------------------------------------------------------------------
	-- 메일발송 대상 
	-----------------------------------------------------------------------------------------------------------------------------------------

	DECLARE @T_MAIL_ADDR TABLE (
	ADDR			NVARCHAR(150)
	, OWNER_TYPE	CHAR(3)
	, DEPT_ID		NVARCHAR(50)
	, SEQ			INT				IDENTITY(0,1)
	);

	-- 마케팅팀 주소 
	INSERT INTO @T_MAIL_ADDR ( ADDR, OWNER_TYPE, DEPT_ID )
	SELECT DISTINCT UI.USER_ID+'@LGENSOL.COM', 'GEN', A.DEPT_ID
	FROM SCM_MST_SSO_USER_INFO AS UI
	INNER JOIN #T_PRICE_RESULT AS A WITH(NOLOCK)
			ON UI.DEPT_ID = A.DEPT_ID
	


	-- 영업관리팀 주소 추가 ( 영업관리는 모든 데이터를 보낸다 )
	INSERT INTO @T_MAIL_ADDR ( ADDR, OWNER_TYPE )
	SELECT LU.SEGMENT2, 'MNG'
	FROM (
		SELECT A.SEGMENT2
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL AS A
		WHERE A.LOOKUP_TYPE = 'DM_PRICE_MAIL_ADDR'
			AND A.VALID_YN = 'Y'
		) AS LU
	

	
	--select * from @t_mail_addr;

	------------------------------------------------------------------------------------------------------
	-- 메일발송 시작
	------------------------------------------------------------------------------------------------------

		DECLARE @TABLE_BODY			NVARCHAR(MAX)
			, @v_body_contents	NVARCHAR(MAX)
			, @v_head_cont		NVARCHAR(MAX)
			, @v_body_cont		NVARCHAR(MAX)
			, @v_to_mail		NVARCHAR(150)
			, @v_mail_title		NVARCHAR(100)
			, @V_OWNER			NVARCHAR(100)
			, @V_OWNER_TYPE		CHAR(3)
			, @v_cnt int
			, @v_i int
			, @V_DEPT_ID		NVARCHAR(50)
			;

		DECLARE   @C_DIVISION_ID		NVARCHAR(150)
				, @C_PROJECT_CODE		NVARCHAR(50)
				, @C_SCM_SITE_ID		NVARCHAR(30)
				, @C_ITEM_ID			NVARCHAR(50)
				, @C_INCOTERMS			NVARCHAR(10)
				, @C_FCST_TYPE			NVARCHAR(20)
				, @C_DOM_EXP			NVARCHAR(3)
				, @C_MISSING_TOTAL		NVARCHAR(3)
				, @C_MISSING_DATE		NVARCHAR(MAX)
				, @C_OWNER				NVARCHAR(100)
				;


		------------------------------------------------------------------------------------------------------
		-- 테이블 HEADER 
		------------------------------------------------------------------------------------------------------
		SET @v_mail_title = N'Price 누락 건 리스트 안내';
		SET @v_body_contents = N'안녕하십니까? </br> ' + CONVERT(NVARCHAR(40), GETDATE(), 120)
			+ N' 기준 MKT FCST 대비 Price 누락건을 아래와 같이 안내드리오니</br> 차주 월요일까지 SCM 에서 수정하여 주시기 바랍니다.</BR>'  -- [E20230721-001841] 용어 수정  GSCM->SCM
			+ N'</br> ◈ 누락된 PRICE 리스트 ◈ </br>';
		SET @v_head_cont = N'<TR>
			<TH width:110px>Owner</TH>
			<TH width:40px>Div</TH>
			<TH width:150px>Project Code</TH>
			<TH width:150px>Sales Site</TH>
			<TH width:150px>Model</TH>
			<TH width:70px>Incoterms</TH>
			<TH width:70px>FCST Type</TH>
			<TH width:70px>Customs Handbook</TH>
			<TH width:70px>Total Number</TH>
			<TH width:510px>Missing Cases</TH>
			</TR>';

		------------------------------------------------------------------------------------------------------
		-- 테이블 반복 내용
		------------------------------------------------------------------------------------------------------	
		SELECT @V_CNT = COUNT(*), @V_I = 0, @v_to_mail = '', @V_OWNER = '', @V_DEPT_ID = ''
		FROM @T_MAIL_ADDR;

		SELECT @V_CNT;

		IF EXISTS(SELECT * FROM #T_PRICE_RESULT)
		BEGIN
			WHILE ( @V_I < @V_CNT )
			BEGIN

				SELECT @V_OWNER = ADDR
					, @V_OWNER_TYPE = OWNER_TYPE
					, @V_DEPT_ID = DEPT_ID
				FROM @T_MAIL_ADDR
				WHERE SEQ = @V_I;

				SET @v_body_cont = '';

				-- 본문내용 생성
				DECLARE CUR_SEND CURSOR FAST_FORWARD FOR
				SELECT 
					DIVISION_ID
					, PROJECT_CODE
					, SCM_SITE_ID	
					, ITEM_ID	
					, INCOTERMS	
					, FCST_TYPE		
					, DOM_EXP		
					, TOTAL_NUM	
					, MISSING_DATE		
					, OWNER			
				FROM #T_PRICE_RESULT A
				WHERE DEPT_ID = CASE WHEN @V_OWNER_TYPE = 'GEN' THEN @V_DEPT_ID
									ELSE DEPT_ID
									END
				ORDER BY OWNER
				;


				OPEN CUR_SEND;
				FETCH NEXT FROM CUR_SEND INTO @C_DIVISION_ID, @C_PROJECT_CODE, @C_SCM_SITE_ID, @C_ITEM_ID, @C_INCOTERMS, @C_FCST_TYPE	
					, @C_DOM_EXP, @C_MISSING_TOTAL, @C_MISSING_DATE, @C_OWNER;

				WHILE @@FETCH_STATUS = 0
				BEGIN

					SET @v_body_cont = @v_body_cont+ N'<TR>';
					SET @v_body_cont = @v_body_cont+ N'<TD ALIGN = LEFT >'	+ ISNULL(@C_OWNER,'') + N'</TD>'	;
					SET @v_body_cont = @v_body_cont+ N'<TD ALIGN = LEFT >'	+ ISNULL(@C_DIVISION_ID,'') + N'</TD>'	;
					SET @v_body_cont = @v_body_cont+ N'<TD ALIGN = LEFT >'	+ ISNULL(@C_PROJECT_CODE,'') + N'</TD>'	;
					SET @v_body_cont = @v_body_cont+ N'<TD ALIGN = LEFT >'	+ ISNULL(@C_SCM_SITE_ID,'') + N'</TD>'	;
					SET @v_body_cont = @v_body_cont+ N'<TD ALIGN = LEFT >'	+ ISNULL(@C_ITEM_ID,'') + N'</TD>'	;
					SET @v_body_cont = @v_body_cont+ N'<TD ALIGN = LEFT >'	+ ISNULL(@C_INCOTERMS,'') + N'</TD>';	
					SET @v_body_cont = @v_body_cont+ N'<TD ALIGN = LEFT >'	+ ISNULL(@C_FCST_TYPE,'') + N'</TD>';	
					SET @v_body_cont = @v_body_cont+ N'<TD ALIGN = LEFT >'	+ ISNULL(@C_DOM_EXP,'') + N'</TD>'	;
					SET @v_body_cont = @v_body_cont+ N'<TD ALIGN = LEFT >'	+ ISNULL(@C_MISSING_TOTAL,'') + N'</TD>'	;
					SET @v_body_cont = @v_body_cont+ N'<TD ALIGN = LEFT >'	+ ISNULL(@C_MISSING_DATE,'') + N'</TD>'	;
					SET @v_body_cont = @v_body_cont+ N'</TR>';
				
				FETCH NEXT FROM CUR_SEND INTO @C_DIVISION_ID, @C_PROJECT_CODE, @C_SCM_SITE_ID, @C_ITEM_ID, @C_INCOTERMS, @C_FCST_TYPE	
					, @C_DOM_EXP, @C_MISSING_TOTAL, @C_MISSING_DATE, @C_OWNER;
		
				END
	
				CLOSE CUR_SEND;
				DEALLOCATE CUR_SEND;

				SET @TABLE_BODY = N' <html>
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
									<body></br><b>' + REPLACE(ISNULL(@v_body_contents, ''), CHAR(10), N'<br>') + N'</b>'
											+ N'<div id="divBody" style="width: 100%; overflow-x: auto; overflow-y: auto; font-size: 9pt; line-break: auto;">'
											+ N'<table style=''border-top:2px solid #c8294b; width:1450px;''>
										<thead>' + ISNULL(@v_head_cont,'') + N'</thead>
										<tbody>' + ISNULL(@v_body_cont, '') + N'</tbody>
										</div>
									</body>
							</html>';

				--SELECT @TABLE_BODY
				----------------------------------------------------------
				-- 테스트용
				----------------------------------------------------------
				--SET @V_MAIL_ADDR_LIST = @V_MAIL_ADDR_LIST + @V_OWNER + ';';
				--SELECT * FROM @T_MAIL_ADDR;
				--SELECT @V_OWNER, @V_I;
				--SET @V_MAIL_TITLE = 'MAIL 제목:' + @V_OWNER;
				--SET @V_OWNER = 'rosia27@lgespartner.com';	
				--SET @V_OWNER_TYPE = 'MNG';
				--SELECT @V_OWNER;		
				----------------------------------------------------------
				------------------------------------------------------------------------------------------------------
				-- Mail 전송
				------------------------------------------------------------------------------------------------------
		
				IF @V_OWNER_TYPE = 'MNG'	-- 영업관리팀
				BEGIN 
					EXEC SCM_ADM_MAIL_SEND
						@V_OWNER 
						, @v_mail_title
						, @TABLE_BODY
						, 'Y';

				END
				ELSE
				BEGIN
					-- 현업한테 가는 메일은 운영일 경우에만 발송함.
					IF DB_NAME() <> 'LGCE_SCMDEV'
					BEGIN 
						EXEC SCM_ADM_MAIL_SEND
							@V_OWNER
							, @v_mail_title
							, @TABLE_BODY
							, 'Y';
					END
				END
			
			

				--MAIL 발송 LOG 저장
				EXEC SCM_ADM_SAVE_MAIL_SEND_BATCH_LOG 
					'MAIL'
					, '-'
					, @v_program_name
					, @V_OWNER
					, ''
					, ''
					, ''
					, ''
					, ''
					, ''
					, ''
					, ''
					, '' --p_send_pgm
					,  ''
				;

				IF ( @V_I % 5 IN ( 0, 5 ))
				BEGIN
					WAITFOR DELAY '00:00:30'
				END

				SET @V_I = @V_I + 1;
			END
		END

	IF OBJECT_ID (N'tempdb..#mshychu1', N'U') IS NOT NULL 
	    DROP TABLE #mshychu1;
    IF OBJECT_ID (N'tempdb..#mshychu2', N'U') IS NOT NULL 
	    DROP TABLE #mshychu2;
	IF OBJECT_ID (N'tempdb..#T_PRICE', N'U') IS NOT NULL 
	    DROP TABLE #T_PRICE;
	IF OBJECT_ID (N'tempdb..#T_PRICE_RESULT', N'U') IS NOT NULL 
	    DROP TABLE #T_PRICE_RESULT;

END TRY
			
BEGIN CATCH

		SET @v_log_type = 'ERROR';
		SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
		SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
END CATCH

	
	-- 종료 LOG
	SET @v_log_type = 'END';
	SET @v_log_message = '########## END of procedure ##########';
	SET @v_description = '';
	SET @d_event_date = SYSDATETIME();
	EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
