---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------





/****************************************************************************************************
* Program ID  : PR_DM_DNM_ESS_MAIL_SEND                                                 
* Description : 월요일 아침에 ESS 마케팅 입력자들에게 현재상황 발송
* Usage       :                                 
* Parameter   :                                                                                    
*                                                                                                  
*--------------------------------------------------------------------------------------------------
* Date        In Charge    Description                                                             
*--------------------------------------------------------------------------------------------------
* 2021.06.03	HWI1993	신규생성
* 2021.06.17	SJ.HAN [C20210617-000029] - [ESS영업관리팀] 사전 알림 메일 주택용(법인 매출) 리스트 제외 요청
* 2023-08-04   HMIN         [E20230721-001841] 용어 수정  GSCM->SCM
* 2024-03-27   HMIN    [E20240228-001115] RTF/빌링 자동메일 수정요청
						→ 로직 수정 + 문구 수정 필요
						1) 계획 대비 실적 이 적은 경우에만 메일 발송
						2) 건별로 비교 X, 구간 단위 비교
						3) 자동문구 메일 수정
						제목: SCM 시스템 계획 대비 실적(ERP) 미달 건
						본문: 전주 SCM시스템에 반영한 매출 계획 대비 ERP에서 확정된 매출 실적이 상이합니다.
						Billing 미처리 내역이 있는지, 또는 매출 조정에 따른 차이인지 확인을 부탁드립니다. 
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------





*/

CREATE PROC [dbo].[PR_DM_DNM_ESS_MAIL_SEND]
AS
SET NOCOUNT ON

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_DNM_ESS_MAIL_SEND';
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
	


	IF OBJECT_ID (N'tempdb..#TEMP_SCM_MST_SITE_ITEM', N'U') IS NOT NULL 		DROP TABLE #TEMP_SCM_MST_SITE_ITEM
	IF OBJECT_ID (N'tempdb..#T_PLAN', N'U') IS NOT NULL 		DROP TABLE #T_PLAN
	IF OBJECT_ID (N'tempdb..#T_RESULT', N'U') IS NOT NULL 		DROP TABLE #T_RESULT
	IF OBJECT_ID (N'tempdb..#T_MAIN', N'U') IS NOT NULL 		DROP TABLE #T_MAIN

	--[E20240228-001115]
	IF OBJECT_ID (N'tempdb..#T_MAIN_FINAL', N'U') IS NOT NULL 	DROP TABLE #T_MAIN_FINAL
	IF OBJECT_ID (N'tempdb..#T_PLAN_FINAL', N'U') IS NOT NULL 	DROP TABLE #T_PLAN_FINAL
	IF OBJECT_ID (N'tempdb..#T_RESULT_FINAL', N'U') IS NOT NULL DROP TABLE #T_RESULT_FINAL

	SELECT *
		, DBO.FN_GET_DM_MKT_OWNER_NAME (SMSI.OWNER, ',', 'EN' )                AS OWNER_NAME
		, DBO.FN_GET_DM_MKT_OWNER_NAME (SMSI.OWNER, ',', 'KO' )                AS OWNER_NAME_KO
		,(	SELECT SU.DEPT_ID  
			FROM SCM_MST_SSO_USER_INFO SU WITH (NOLOCK)
			WHERE SU.USER_ID = (SELECT top 1 token FROM [dbo].[String_Split](SMSI.owner, ',')) ) DEPT_ID
	INTO #TEMP_SCM_MST_SITE_ITEM
	FROM [10.34.221.78,7433].[LGCE_SCMPROD].[DBO].SCM_MST_SITE_ITEM SMSI WITH(NOLOCK)
	WHERE SMSI.Division_id = '82'


-- 1. 전주 컷오프에는 계획이 있었는데, 금주에 실적이 안들어온 건

	DECLARE @V_BF_VERSION_NO NVARCHAR(30)

	SELECT @V_BF_VERSION_NO = MAX(VERSION_NO)
	FROM [10.34.221.78,7433].[LGCE_SCMPROD].[DBO].DM_MST_VERSION
	WHERE VERSION_TYPE = 'SP_W'
		AND DIVISION_ID = '82'
		AND YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -14, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)

PRINT @V_BF_VERSION_NO;

	SELECT D.DEPT_NAME_KO, ISNULL(E.SEGMENT3, C.END_CUSTOMER) AS END_CUSTOMER, A.PROJECT_CODE, F.PROJECT_NAME, A.YYYYMMDD, B.WEEK_NAME, A.INCOTERMS, A.CURRENCY, G.OWNER
		, A.MEASURE, SUM(QTY) AS QTY
	INTO #T_PLAN
	FROM [10.34.221.78,7433].[LGCE_SCMPROD].[DBO].DM_PLN_SALES_PLAN_C A
	JOIN [10.34.221.78,7433].[LGCE_SCMPROD].[DBO].SCM_SYS_CALENDAR_M B ON A.YYYYMMDD = B.BASIS_YYYYMMDD
	JOIN [10.34.221.78,7433].[LGCE_SCMPROD].[DBO].SCM_MST_SITE C ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID
	LEFT OUTER JOIN [10.34.221.78,7433].[LGCE_SCMPROD].[DBO].SCM_MST_SSO_DEPT_INFO D ON C.DEPT_ID = D.DEPT_ID
	LEFT OUTER JOIN [10.34.221.78,7433].[LGCE_SCMPROD].[DBO].SCM_ADM_LOOKUP_MASTER_DETAIL E ON C.DIVISION_ID = E.SEGMENT1 AND C.END_CUSTOMER = E.SEGMENT2 AND E.LOOKUP_TYPE = 'END_CUSTOMER'
	LEFT OUTER JOIN [10.34.221.78,7433].[LGCE_SCMPROD].[DBO].SCM_MST_PROJECT F ON A.DIVISION_ID = F.DIVISION_ID AND A.PROJECT_CODE = F.PROJECT_CODE
	LEFT OUTER JOIN #TEMP_SCM_MST_SITE_ITEM G ON A.DIVISION_ID = G.DIVISION_ID AND A.PROJECT_CODE = G.PROJECT_CODE AND A.ITEM_ID = G.ITEM_ID AND A.SCM_SITE_ID = G.SCM_SITE_ID
	LEFT OUTER JOIN [10.34.221.78,7433].[LGCE_SCMPROD].[DBO].SCM_ADM_LOOKUP_MASTER_DETAIL H ON C.SCM_SITE_ID = H.SEGMENT1 AND H.LOOKUP_TYPE = 'DM_ESS_MAIL_NOT_SITE'		-- [C20210617-000029] - [ESS영업관리팀] 사전 알림 메일 주택용(법인 매출) 리스트 제외 요청
	WHERE A.DIVISION_ID = '82'
		AND VERSION_NO = @V_BF_VERSION_NO
		AND MEASURE IN ( 'SALESAMT_KRW', 'SALESAMT_LOC')		
		AND YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -14, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) 
		AND YYYYMMDD  < CONVERT(CHAR(8), DATEADD(DD,   0, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)	-- PLAN 은 2주		
		AND A.QTY <> 0
		AND H.SEGMENT1 IS NULL		-- [C20210617-000029] - [ESS영업관리팀] 사전 알림 메일 주택용(법인 매출) 리스트 제외 요청
	GROUP BY D.DEPT_NAME_KO, ISNULL(E.SEGMENT3, C.END_CUSTOMER), A.PROJECT_CODE, F.PROJECT_NAME, A.YYYYMMDD, B.WEEK_NAME, A.INCOTERMS, A.CURRENCY, A.MEASURE, G.OWNER


	SELECT D.DEPT_NAME_KO, ISNULL(E.SEGMENT3, C.END_CUSTOMER) AS END_CUSTOMER, A.PROJECT_CODE, F.PROJECT_NAME, A.YYYYMMDD, B.WEEK_NAME, A.INCOTERMS, A.CURRENCY, G.OWNER
		, A.MEASURE, SUM(QTY) AS QTY
	INTO #T_RESULT
	FROM [10.34.221.78,7433].[LGCE_SCMPROD].[DBO].DM_PLN_SALES_PLAN_RESULT A
	JOIN [10.34.221.78,7433].[LGCE_SCMPROD].[DBO].SCM_SYS_CALENDAR_M B ON A.YYYYMMDD = B.BASIS_YYYYMMDD
	JOIN [10.34.221.78,7433].[LGCE_SCMPROD].[DBO].SCM_MST_SITE C ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID
	LEFT OUTER JOIN [10.34.221.78,7433].[LGCE_SCMPROD].[DBO].SCM_MST_SSO_DEPT_INFO D ON C.DEPT_ID = D.DEPT_ID
	LEFT OUTER JOIN [10.34.221.78,7433].[LGCE_SCMPROD].[DBO].SCM_ADM_LOOKUP_MASTER_DETAIL E ON C.DIVISION_ID = E.SEGMENT1 AND C.END_CUSTOMER = E.SEGMENT2 AND E.LOOKUP_TYPE = 'END_CUSTOMER'
	LEFT OUTER JOIN [10.34.221.78,7433].[LGCE_SCMPROD].[DBO].SCM_MST_PROJECT F ON A.DIVISION_ID = F.DIVISION_ID AND A.PROJECT_CODE = F.PROJECT_CODE
	LEFT OUTER JOIN #TEMP_SCM_MST_SITE_ITEM G ON A.DIVISION_ID = G.DIVISION_ID AND A.PROJECT_CODE = G.PROJECT_CODE AND A.ITEM_ID = G.ITEM_ID AND A.SCM_SITE_ID = G.SCM_SITE_ID
	LEFT OUTER JOIN [10.34.221.78,7433].[LGCE_SCMPROD].[DBO].SCM_ADM_LOOKUP_MASTER_DETAIL H ON C.SCM_SITE_ID = H.SEGMENT1 AND H.LOOKUP_TYPE = 'DM_ESS_MAIL_NOT_SITE'		-- [C20210617-000029] - [ESS영업관리팀] 사전 알림 메일 주택용(법인 매출) 리스트 제외 요청
	WHERE A.DIVISION_ID = '82'
		AND MEASURE IN ( 'SALESAMT_KRW', 'SALESAMT_LOC')		
		AND YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -14, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) 
		AND YYYYMMDD  < CONVERT(CHAR(8), DATEADD(DD,  -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)	
		AND A.QTY <> 0
		AND H.SEGMENT1 IS NULL		-- [C20210617-000029] - [ESS영업관리팀] 사전 알림 메일 주택용(법인 매출) 리스트 제외 요청
	GROUP BY D.DEPT_NAME_KO, ISNULL(E.SEGMENT3, C.END_CUSTOMER), A.PROJECT_CODE, F.PROJECT_NAME, A.YYYYMMDD, B.WEEK_NAME, A.INCOTERMS, A.CURRENCY, A.MEASURE, G.OWNER

--[E20240228-001115]------------------------------------------------------------------------------------------------------------------
/* 실제 메일 발송 정보 취합 (계획) */
SELECT DEPT_NAME_KO, END_CUSTOMER, PROJECT_CODE, PROJECT_NAME, LEFT(YYYYMMDD, 6) AS YYYY_MM, WEEK_NAME, INCOTERMS, CURRENCY, OWNER
	 , ISNULL(SUM(CASE WHEN MEASURE = 'SALESAMT_LOC'  THEN QTY ELSE 0 END),0) AS PLAN_AMT_LOC
     , ISNULL(SUM(CASE WHEN MEASURE = 'SALESAMT_KRW'  THEN QTY ELSE 0 END),0) AS PLAN_AMT_KRW
INTO #T_PLAN_FINAL
FROM #T_PLAN 
GROUP BY DEPT_NAME_KO, END_CUSTOMER, PROJECT_CODE, PROJECT_NAME, LEFT(YYYYMMDD, 6) , WEEK_NAME, INCOTERMS, CURRENCY, OWNER;

/* 실제 메일 발송 정보 취합 (실적) */
SELECT DEPT_NAME_KO, END_CUSTOMER, PROJECT_CODE, PROJECT_NAME, LEFT(YYYYMMDD, 6) AS YYYY_MM, WEEK_NAME, INCOTERMS, CURRENCY, OWNER
	 , ISNULL(SUM(CASE WHEN MEASURE = 'SALESAMT_LOC'  THEN QTY ELSE 0 END),0) AS RESULT_AMT_LOC
     , ISNULL(SUM(CASE WHEN MEASURE = 'SALESAMT_KRW'  THEN QTY ELSE 0 END),0) AS RESULT_AMT_KRW
INTO #T_RESULT_FINAL
FROM #T_RESULT 
GROUP BY DEPT_NAME_KO, END_CUSTOMER, PROJECT_CODE, PROJECT_NAME, LEFT(YYYYMMDD, 6) , WEEK_NAME, INCOTERMS, CURRENCY, OWNER;

SELECT ISNULL(A.DEPT_NAME_KO, B.DEPT_NAME_KO) AS DEPT_NAME_KO
	, ISNULL(A.END_CUSTOMER, B.END_CUSTOMER) AS END_CUSTOMER
	, ISNULL(A.PROJECT_CODE, B.PROJECT_CODE) AS PROJECT_CODE
	, ISNULL(A.PROJECT_NAME, B.PROJECT_NAME) AS PROJECT_NAME
	, ISNULL(A.YYYY_MM, '') AS YYYY_MM
	, ISNULL(A.WEEK_NAME, '') AS PLAN_WEEK
	, ISNULL(B.WEEK_NAME, '') AS RESULT_WEEK
	, ISNULL(A.INCOTERMS, B.INCOTERMS) AS INCOTERMS
	, ISNULL(A.CURRENCY, '') AS PLAN_CURR
	, ISNULL(A.PLAN_AMT_LOC, 0) AS PLAN_LOC
	, ISNULL(A.PLAN_AMT_KRW, 0) AS PLAN_KRW
	, ISNULL(B.CURRENCY, '')		AS RESULT_CURR
	, ISNULL(B.RESULT_AMT_LOC, 0) AS RESULT_LOC
	, ISNULL(B.RESULT_AMT_KRW, 0) AS RESULT_KRW
	, ISNULL(A.OWNER, B.OWNER) AS OWNER
	, ROW_NUMBER() OVER ( ORDER BY ISNULL(A.WEEK_NAME, 'W99'), ISNULL(B.WEEK_NAME, 'W99'), ISNULL(A.YYYY_MM, '')  ) AS SORT_KEY
INTO #T_MAIN
FROM 
(
	SELECT DEPT_NAME_KO, END_CUSTOMER, PROJECT_CODE, PROJECT_NAME, YYYY_MM, WEEK_NAME, INCOTERMS, CURRENCY, OWNER, PLAN_AMT_LOC, PLAN_AMT_KRW
	FROM #T_PLAN_FINAL A
) A
FULL OUTER JOIN 
(
	SELECT DEPT_NAME_KO, END_CUSTOMER, PROJECT_CODE, PROJECT_NAME, YYYY_MM, WEEK_NAME, INCOTERMS, CURRENCY, OWNER, RESULT_AMT_LOC, RESULT_AMT_KRW
	FROM #T_RESULT_FINAL A	
) B ON A.DEPT_NAME_KO = B.DEPT_NAME_KO
	AND A.END_CUSTOMER = B.END_CUSTOMER
	AND A.PROJECT_CODE = B.PROJECT_CODE
	AND A.PROJECT_NAME = B.PROJECT_NAME			
	AND A.WEEK_NAME = B.WEEK_NAME
	AND A.INCOTERMS = B.INCOTERMS
WHERE 1=1

/* 최종 발송 데이터 취합 (계획+실적) */
SELECT * 
INTO #T_MAIN_FINAL 
FROM #T_MAIN
WHERE PLAN_LOC > RESULT_LOC;

--20240402 확인후 삭제------------START
SELECT '#T_PLAN_FINAL' AS TB, * FROM #T_PLAN_FINAL WHERE PROJECT_CODE = 'C-21-011';
SELECT '#T_RESULT_FINAL' AS TB, * FROM #T_RESULT_FINAL WHERE PROJECT_CODE = 'C-21-011';
SELECT '#T_MAIN_FINAL' AS TB, * FROM #T_MAIN_FINAL WHERE PROJECT_CODE = 'C-21-011';

SELECT '#T_PLAN' AS TB, * FROM #T_PLAN WHERE PROJECT_CODE = 'C-21-011';
SELECT '#T_RESULT' AS TB, * FROM #T_RESULT WHERE PROJECT_CODE = 'C-21-011';
SELECT '#T_MAIN' AS TB, * FROM #T_MAIN WHERE PROJECT_CODE = 'C-21-011';
RETURN;
---------------------------------END
---------------------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------

	DECLARE @T_MAIL_ADDR TABLE (
	ADDR			NVARCHAR(150)
	, OWNER_TYPE	CHAR(3)
	, SEQ			INT				IDENTITY(0,1)
	)

	INSERT INTO @T_MAIL_ADDR ( ADDR, OWNER_TYPE )
	SELECT DISTINCT B.TOKEN+'@LGENSOL.COM', 'GEN'
	FROM #T_MAIN A
	CROSS APPLY DBO.STRING_SPLIT(A.OWNER, ',') B 
	WHERE B.TOKEN IS NOT NULL

	-- 영업관리팀 주소 추가 ( 영업관리는 모든 데이터를 보낸다 )
	INSERT INTO @T_MAIL_ADDR ( ADDR, OWNER_TYPE )
	SELECT	  CASE WHEN [1] IS NOT NULL THEN [1]+';' ELSE '' END
		+ CASE WHEN [2] IS NOT NULL THEN [2]+';' ELSE '' END
		+ CASE WHEN [3] IS NOT NULL THEN [3]+';' ELSE '' END
		+ CASE WHEN [4] IS NOT NULL THEN [4]+';' ELSE '' END
		+ CASE WHEN [5] IS NOT NULL THEN [5]+';' ELSE '' END
		+ CASE WHEN [6] IS NOT NULL THEN [6]+';' ELSE '' END
		+ CASE WHEN [7] IS NOT NULL THEN [7]+';' ELSE '' END
		, 'MNG'
	FROM (
		SELECT A.SEGMENT1, ROW_NUMBER() OVER ( ORDER BY DISPLAY_SEQ ) AS ROW_NUM
		FROM SCM_ADM_LOOKUP_MASTER_DETAIL A
		WHERE A.LOOKUP_TYPE = 'DM_ESS_MAIL_ADDR'
			AND A.VALID_YN = 'Y'
		) A
	PIVOT ( 
		MAX(SEGMENT1) FOR ROW_NUM IN ([1],[2],[3],[4],[5],[6],[7])
		) AS PVT


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
			, @V_LIKE_STRING	NVARCHAR(100)
			, @v_cnt int
			, @v_i int

		DECLARE   @C_DEPT_NAME_KO	NVARCHAR(150)
				, @C_END_CUSTOMER	NVARCHAR(100)
				, @C_PROJECT_CODE	NVARCHAR(50)
				, @C_PROJECT_NAME	NVARCHAR(200)
				, @C_YYYY_MM		NVARCHAR(8)  --[E20240228-001115] 계획년월(DP년월)
				--, @C_PLAN_DATE		NVARCHAR(8)
				, @C_PLAN_WEEK		NVARCHAR(10)
				--, @C_RESULT_DATE	NVARCHAR(8)
				, @C_RESULT_WEEK	NVARCHAR(10)
				, @C_INCOTERMS		NVARCHAR(10)
				, @C_PLAN_CURR		NVARCHAR(10)
				, @C_PLAN_LOC		NUMERIC(38,10)
				, @C_PLAN_KRW		NUMERIC(38,10)
				, @C_RESULT_CURR	NVARCHAR(10)
				, @C_RESULT_LOC		NUMERIC(38,10)
				, @C_RESULT_KRW		NUMERIC(38,10)
				, @C_OWNER			NVARCHAR(100)


		

		-----------------------------
		--SET @v_mail_title = N'GSCM RTF 일자 대비 Billing 처리 미완료/금주 RTF 리스트 안내'
		--SET @v_mail_title = N'SCM RTF 일자 대비 Billing 처리 미완료/금주 RTF 리스트 안내' -- [E20230721-001841] 용어 수정  GSCM->SCM
		SET @v_mail_title = N'SCM 시스템 계획 대비 실적(ERP) 미달 건' -- [E20240228-001115] RTF/빌링 자동메일 수정요청
		SET @v_body_contents = N'안녕하십니까? </br> ' + CONVERT(NVARCHAR(40), GETDATE(), 120) 
			--+ N' 기준 SCM RTF 일자 대비 Billing 처리 미완료/금주 RTF 리스트 아래와 같이 안내드리오니 </br> Billing 일자 확인하시어 금일 내 SCM에서 수정하여 주시기 바랍니다.</BR>' -- [E20230721-001841] 용어 수정  GSCM->SCM
			-- [E20230721-001841] 용어 수정 ▼
			+ N' 전주 SCM시스템에 반영한 매출 계획 대비 ERP에서 확정된 매출 실적이 상이합니다. </br> Billing 미처리 내역이 있는지, 또는 매출 조정에 따른 차이인지 확인을 부탁드립니다.</BR>'
			+ N'</br> ◈ 전주 RTF 대비 Billing 처리 미완료/금주 RTF 리스트 ◈ </br>'
			
		--[E20240228-001115] YYYY-MM 추가 및 일자제거
		SET @v_head_cont = N'<TR>
			<TH rowspan="2">팀</TH>
			<TH rowspan="2">고객명</TH>
			<TH rowspan="2">Project Code</TH>
			<TH rowspan="2">프로젝트명</TH>
			<TH rowspan="2">YYYY-MM</TH>
			<TH colspan="1">RTF</TH>
			<TH colspan="1">Billing</TH>
			<TH rowspan="2">Incoterms</TH>
			<TH colspan="3">계획</TH>
			<TH colspan="3">실적</TH>
			<TH rowspan="2">담당자</TH>
			</TR>
			<TR>
			
			<TH>주차</TH>
			
			<TH>주차</TH>
			<TH>통화</TH>
			<TH>Sales Amount (LOC)</TH>
			<TH>Sales Amount (KRW)</TH>
			<TH>통화</TH>
			<TH>Sales Amount (LOC)</TH>
			<TH>Sales Amount (KRW)</TH>
			</TR>'

		SELECT @V_CNT = COUNT(*), @V_I = 0, @v_to_mail = '', @V_OWNER = ''
		FROM @T_MAIL_ADDR

		WHILE ( @V_I < @V_CNT )
		BEGIN
	
			SELECT @V_OWNER = ADDR
				, @V_OWNER_TYPE = OWNER_TYPE
			FROM @T_MAIL_ADDR
			WHERE SEQ = @V_I

			SET @V_LIKE_STRING = CASE WHEN CHARINDEX('@', @V_OWNER) > 0 THEN LEFT(@V_OWNER, CHARINDEX('@', @V_OWNER)-1)
									ELSE @V_OWNER
									END

			SET @v_body_cont = '';

				-- 본문내용 생성
				DECLARE CUR_SEND CURSOR FAST_FORWARD FOR
				SELECT 
					DEPT_NAME_KO	
					, END_CUSTOMER	
					, PROJECT_CODE	
					, PROJECT_NAME					
					, YYYY_MM --[E20240228-001115]
					--, PLAN_DATE		
					, PLAN_WEEK		
					--, RESULT_DATE	
					, RESULT_WEEK	
					, INCOTERMS		
					, PLAN_CURR		
					, PLAN_LOC		
					, PLAN_KRW		
					, RESULT_CURR	
					, RESULT_LOC		
					, RESULT_KRW		
					, OWNER						
				--FROM #T_MAIN A
				FROM #T_MAIN_FINAL A  --[E20240228-001115]
				WHERE OWNER LIKE '%' + CASE WHEN @V_OWNER_TYPE = 'GEN' THEN @V_LIKE_STRING  ELSE '' END + '%'
				ORDER BY SORT_KEY

				OPEN CUR_SEND;
				
				FETCH NEXT FROM CUR_SEND INTO @C_DEPT_NAME_KO, @C_END_CUSTOMER, @C_PROJECT_CODE, @C_PROJECT_NAME, @C_YYYY_MM, @C_PLAN_WEEK	
					, @C_RESULT_WEEK, @C_INCOTERMS, @C_PLAN_CURR, @C_PLAN_LOC, @C_PLAN_KRW, @C_RESULT_CURR, @C_RESULT_LOC, @C_RESULT_KRW, @C_OWNER


				WHILE @@FETCH_STATUS = 0
				BEGIN
					SET @v_body_cont = @v_body_cont+ N'<TR>'
					SET @v_body_cont = @v_body_cont+ N'<TD>' + ISNULL(@C_DEPT_NAME_KO,'') + N'</TD>'	
					SET @v_body_cont = @v_body_cont+ N'<TD>'	+ ISNULL(@C_END_CUSTOMER,'') + N'</TD>'	
					SET @v_body_cont = @v_body_cont+ N'<TD>'	+ ISNULL(@C_PROJECT_CODE,'') + N'</TD>'	
					SET @v_body_cont = @v_body_cont+ N'<TD>'	+ ISNULL(@C_PROJECT_NAME,'') + N'</TD>'	
					SET @v_body_cont = @v_body_cont+ N'<TD>'	+ ISNULL(@C_YYYY_MM,'') + N'</TD>' --[E20240228-001115]					
					--SET @v_body_cont = @v_body_cont+ N'<TD>'	+ CASE WHEN ISDATE(@C_PLAN_DATE)>0 THEN CONVERT(NCHAR(10), CONVERT(DATETIME, @C_PLAN_DATE), 120) ELSE '' END + N'</TD>'	
					SET @v_body_cont = @v_body_cont+ N'<TD>'	+ ISNULL(@C_PLAN_WEEK,'') + N'</TD>'	
					--SET @v_body_cont = @v_body_cont+ N'<TD>'	+ CASE WHEN ISDATE(@C_RESULT_DATE)>0 THEN CONVERT(NCHAR(10), CONVERT(DATETIME, @C_RESULT_DATE), 120) ELSE '' END + N'</TD>'	
					SET @v_body_cont = @v_body_cont+ N'<TD>'	+ ISNULL(@C_RESULT_WEEK,'') + N'</TD>'	
					SET @v_body_cont = @v_body_cont+ N'<TD>'	+ ISNULL(@C_INCOTERMS,'') + N'</TD>'	
					SET @v_body_cont = @v_body_cont+ N'<TD>'	+ ISNULL(@C_PLAN_CURR,'') + N'</TD>'	
					SET @v_body_cont = @v_body_cont+ N'<TD ALIGN="RIGHT">'	+ DBO.FN_GET_NUMER_TO_STRING(@C_PLAN_LOC,0) + N'</TD>'
					SET @v_body_cont = @v_body_cont+ N'<TD ALIGN="RIGHT">'	+ DBO.FN_GET_NUMER_TO_STRING(@C_PLAN_KRW,0) + N'</TD>'
					SET @v_body_cont = @v_body_cont+ N'<TD>'	+ ISNULL(@C_RESULT_CURR,'') + N'</TD>'	
					SET @v_body_cont = @v_body_cont+ N'<TD ALIGN="RIGHT">'	+ DBO.FN_GET_NUMER_TO_STRING(@C_RESULT_LOC,0) + N'</TD>'
					SET @v_body_cont = @v_body_cont+ N'<TD ALIGN="RIGHT">'	+ DBO.FN_GET_NUMER_TO_STRING(@C_RESULT_KRW,0) + N'</TD>'	
					SET @v_body_cont = @v_body_cont+ N'<TD>'	+ ISNULL(@C_OWNER,'') + N'</TD>'	
					SET @v_body_cont = @v_body_cont+ N'</TR>'
		
				FETCH NEXT FROM CUR_SEND INTO @C_DEPT_NAME_KO, @C_END_CUSTOMER, @C_PROJECT_CODE, @C_PROJECT_NAME, @C_YYYY_MM,  @C_PLAN_WEEK	
					, @C_RESULT_WEEK, @C_INCOTERMS, @C_PLAN_CURR, @C_PLAN_LOC, @C_PLAN_KRW, @C_RESULT_CURR, @C_RESULT_LOC, @C_RESULT_KRW, @C_OWNER
		

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

			--//메일 발송
			IF @V_OWNER_TYPE = 'MNG'	-- 영업관리팀
			BEGIN 
				--EXEC SCM_ADM_MAIL_SEND
				--	@V_OWNER 
				--	, @v_mail_title
				--	, @TABLE_BODY
				--	, 'Y'

				EXEC SCM_ADM_MAIL_SEND
					  'hmyong@lgespartner.com;jssbae@lgespartner.com'
					, @v_mail_title
					, @TABLE_BODY
					, 'Y'

				PRINT 2;
			END
			ELSE
			BEGIN
				-- 현업한테 가는 메일은 운영일 경우에만 발송함.
				IF DB_NAME() <> 'LGCE_SCMDEV'
				BEGIN 
					--EXEC SCM_ADM_MAIL_SEND
					--	@V_OWNER
					--	, @v_mail_title
					--	, @TABLE_BODY
					--	, 'Y'
					PRINT 3;
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



			SET @V_I = @V_I + 1
		END


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





