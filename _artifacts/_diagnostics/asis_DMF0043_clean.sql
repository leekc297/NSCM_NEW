/* Program ID  : DMF0043_GET_CONTRIBUTION_SALES_LIST                                                */
/* Description : 해외법인 기여매출 목록                                                             */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/* Date        In Charge    Description                                                             */
/* 2019/06/20     JSYOUN    [CSR ID:3948994] GSCM 해외법인기여율 화면 개발 요청의 건 - 해외법인 기여매출 목록 */
/* 2019/11/25     hwi1993   합계컬럼 추가, FORECAST_INFO_BIZ_TYPE 조건 제외																		*/
/* 2019/11/27     hwi1993   하단합계 추가																		*/
/* 2019/12/12	  hwi1993   컬럼변수 정리, 컬럼합계를 commission/markup 구분없이 통합 ( Total 컬럼 ) */
/* 2020/01/28	  P.C.I     Sales Report의 테이블로 변경 */
/* 2020/02/07	  P.C.I     #tmp_sales_list_c 생성시 INNER JOIN 을 OUTER JOIN 으로 변경함 */
/* 2020/02/07	  HWI1993   마지막 유효성검사에 로직 추가 */
/* 2020/03/24	  HWI1993   DM_PLN_SALES_REPORT_C 에 BP 를 임시로 넣었는데, 이 데이터가 양쪽 테이블에 들어가있는 관계로 조회시 2배로 표시됨. --> 원천테이블에서 데이터 집계하는 로직 변경 */
/* 20200427       KHSONG    C20200305-000035 매출 쿼리 수정 요청의 건 (COMPANY정보 실시간 현행화)   */
CREATE PROCEDURE [dbo].[DMF0043_GET_CONTRIBUTION_SALES_LIST]
@p_division_id      NVARCHAR(30),
@p_ver_seq          NVARCHAR(MAX),
@p_version_no       NVARCHAR(MAX),
@p_end_cust_report  NVARCHAR(MAX),
@p_product_group    NVARCHAR(MAX),
@p_biz_type         NVARCHAR(MAX),
@p_million_yn       NVARCHAR(MAX),
@p_compatibility_yn NVARCHAR(MAX),
@p_created_by       NVARCHAR(50)
AS
BEGIN
SET NOCOUNT ON;
DECLARE @v_sql_text          AS NVARCHAR(MAX);
DECLARE @v_code              AS NVARCHAR(MAX);
DECLARE @v_large_code        AS NVARCHAR(MAX);
DECLARE @v_small_code        AS NVARCHAR(MAX);
DECLARE @v_groupby           AS NVARCHAR(MAX);
DECLARE @v_orderby           AS NVARCHAR(MAX);
DECLARE @v_col_name			 AS NVARCHAR(50);
DECLARE @v_sort_order_no     AS NVARCHAR(50);
DECLARE @v_program_id        AS NVARCHAR(10);
DECLARE @v_sheet_name        AS NVARCHAR(100);
DECLARE @v_user_col_cnt      AS INT;
	DECLARE @v_seq				 AS INT;
	-- 동적쿼리에사용하는 컬럼 관련 ( CTE 문을 이용한 마지막 Select 문에서 사용 )
	DECLARE @v_col				 AS NVARCHAR(MAX);		-- 일반 로우의 일반 컬럼
	DECLARE @v_col_Sum			 AS NVARCHAR(MAX) = ''; -- 일반로우의 합계컬럼 ( 국가별, commision/markup 구분별)
	DECLARE @v_bottom			 AS NVARCHAR(MAX);		-- 합계로우의 일반컬럼
DECLARE @v_bottom_Sum        AS NVARCHAR(MAX) = ''; -- 합계로우의 합계컬럼 ( 국가별, commision/markup 구분별)
	DECLARE @v_col_Total		 AS NVARCHAR(MAX) = ''; -- Total 컬럼 ( 로우 구분 없음 - 수식이 동일해서 )
DECLARE @nsql2 nvarchar(max); -- order by 정보
DECLARE @va_program_id     NVARCHAR(MAX)
DECLARE @va_sheet_name     NVARCHAR(MAX)
SET @va_program_id = 'DMF0043'
SET @va_sheet_name = 'ContributeSalesList'
SET @v_col_name = '';
SET @v_col = '';
SET @v_groupby = '';
SET @v_user_col_cnt = 0;
SELECT @v_user_col_cnt = COUNT(*)
FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
WHERE  1 = 1
AND  U.PROGRAM_ID = @va_program_id
AND    U.SHEET_NAME = @va_sheet_name
AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
AND    U.USER_ID    = @p_created_by;
IF @v_user_col_cnt = 0
BEGIN
INSERT INTO [dbo].[SCM_MST_TITLESET_USER]
( USER_ID
, PROGRAM_ID
, SHEET_NAME
, USER_INQUIRY_COLUMN_TYPE_CODE
, COLUMN_NAME
, SORT_ORDER_NO
, SUB_TOTAL_FLAG
, DATA_SORT_METHOD_CODE
, CREATED_BY
, CREATION_DATE
, LAST_UPDATED_BY
, LAST_UPDATE_DATE
SELECT @p_created_by
, C.PROGRAM_ID
, C.SHEET_NAME
, 'C'
, C.COLUMN_NAME
, C.SORT_ORDER_NO
, 'N'
, @p_created_by
, CONVERT(varchar(19), GETDATE(), 121)
, @p_created_by
, CONVERT(varchar(19), GETDATE(), 121)
FROM   [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
WHERE  1 = 1
AND    C.PROGRAM_ID  = @va_program_id
AND    C.SHEET_NAME  = @va_sheet_name
AND    C.DEFAULT_FLAG = 'Y'
AND    C.VALID_YN     = 'Y' ;
END;
--정렬 정보 쿼리 add son young suk 20180727
SET  @nsql2 = 'SELECT U.PROGRAM_ID
, U.SHEET_NAME
, U.COLUMN_NAME
, U.SORT_ORDER_NO
, U.DATA_SORT_METHOD_CODE
FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
, [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
WHERE  1 = 1
AND    U.PROGRAM_ID  = C.PROGRAM_ID
AND    U.SHEET_NAME  = C.SHEET_NAME
AND    U.COLUMN_NAME = C.COLUMN_NAME
AND    U.PROGRAM_ID  = ''' + @va_program_id +'''
AND    U.SHEET_NAME  = ''' + @va_sheet_name +'''
AND    U.USER_ID     = ''' + @p_created_by + '''
AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = ''C''
AND    C.VALID_YN = ''Y''
AND  ''' + @p_division_id + ''' IN (SELECT token FROM dbo.String_Split(C.DIVISION_ID ,'','') )  -- 20190214
UNION ALL
SELECT C.PROGRAM_ID
, C.SHEET_NAME
, C.COLUMN_NAME
, C.SORT_ORDER_NO
, C.DATA_SORT_METHOD_CODE
FROM   [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
WHERE  1 = 1
AND    C.PROGRAM_ID  = ''' + @va_program_id +'''
AND    C.SHEET_NAME  = ''' + @va_sheet_name +'''
AND    C.DEFAULT_FLAG = ''''
AND    C.VALID_YN     = ''Y''
ORDER BY SORT_ORDER_NO';
DECLARE c_title CURSOR FAST_FORWARD FOR
SELECT U.PROGRAM_ID
, U.SHEET_NAME
, U.COLUMN_NAME
, U.SORT_ORDER_NO
FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)
, [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
WHERE  1 = 1
AND    U.PROGRAM_ID  = C.PROGRAM_ID
AND    U.SHEET_NAME  = C.SHEET_NAME
AND    U.COLUMN_NAME = C.COLUMN_NAME
AND    U.PROGRAM_ID  = @va_program_id
AND    U.SHEET_NAME  = @va_sheet_name
AND    U.USER_ID     = @p_created_by
AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
UNION ALL
SELECT C.PROGRAM_ID
, C.SHEET_NAME
, C.COLUMN_NAME
, C.SORT_ORDER_NO
FROM   [dbo].[SCM_MST_SHEET_COLUMNS] C WITH(NOLOCK)
WHERE  1 = 1
AND    C.PROGRAM_ID  = @va_program_id
AND    C.SHEET_NAME  = @va_sheet_name
AND    C.DEFAULT_FLAG = ''
AND    C.VALID_YN     = 'Y'
ORDER BY SORT_ORDER_NO ;
OPEN c_title;
FETCH NEXT FROM c_title INTO @v_program_id, @v_sheet_name, @v_col_name, @v_sort_order_no
WHILE @@FETCH_STATUS = 0
BEGIN
IF @v_col = ''
BEGIN
			  SET @v_col =  'A.' + @v_col_name;
			  SET @v_groupby = ' GROUP BY A.' + @v_col_name;
			  SET @v_orderby = ' ORDER BY A.' + @v_col_name;
			  SET @v_bottom = N'''Total'''
END;
ELSE
BEGIN
SET @v_col = @v_col + ', A.' + @v_col_name;
SET @v_groupby = @v_groupby + ', A.' + @v_col_name;
SET @v_orderby = @v_orderby + ', A.' + @v_col_name;
			  SET @v_bottom = @v_bottom + ', null';
END;
FETCH NEXT FROM c_title INTO @v_program_id, @v_sheet_name, @v_col_name, @v_sort_order_no
END;
CLOSE c_title;
DEALLOCATE c_title;
IF OBJECT_ID (N'tempdb..#tmp_plan_report_c', N'U') IS NOT NULL
DROP TABLE #tmp_plan_report_c;
/*IF OBJECT_ID (N'tempdb..#tmp_sales_plan_c', N'U') IS NOT NULL
DROP TABLE #tmp_sales_plan_c;
IF OBJECT_ID (N'tempdb..#tmp_sales_result_c', N'U') IS NOT NULL
DROP TABLE #tmp_sales_result_c;*/
IF OBJECT_ID (N'tempdb..#tmp_sales_list_c', N'U') IS NOT NULL
DROP TABLE #tmp_sales_list_c;
SELECT DIVISION_ID
, VERSION_NO
		 , PROJECT_CODE
, SCM_SITE_ID
, ITEM_ID
, YYYYMMDD
, QTY
INTO #tmp_sales_plan_c
FROM DM_PLN_SALES_PLAN_C WITH (NOLOCK)
WHERE DIVISION_ID = @p_division_id
AND VERSION_NO = @p_version_no
AND MEASURE = 'SalesAmt_USD'
AND SCM_SITE_ID NOT IN (SELECT SEGMENT1
FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK)
WHERE LOOKUP_TYPE = 'INTERNAL_TXN')  -- 20190906 소거매출 제외
AND YYYYMMDD LIKE (SELECT YYYY FROM DM_MST_CONTRIBUTE_VER WITH (NOLOCK) WHERE VER_SEQ = @p_ver_seq)+'%'
SELECT PR.DIVISION_ID
, PR.VERSION_NO
, PR.PROJECT_CODE
, PR.SCM_SITE_ID
, PR.ITEM_ID
, PR.YYYYMMDD
, CASE WHEN ISNULL(FP.EXCHANGE_PRICE,0) = 0 THEN 0
ELSE PR.QTY/ISNULL(FP.EXCHANGE_PRICE,0)
END AS QTY
INTO #tmp_sales_result_c
FROM DM_PLN_SALES_PLAN_RESULT_C PR WITH (NOLOCK)
LEFT OUTER JOIN DM_MST_EXCHANGE_RATE_C FP WITH (NOLOCK)
ON PR.DIVISION_ID = FP.DIVISION_ID
AND PR.VERSION_NO = FP.VERSION_NO
AND SUBSTRING(PR.YYYYMMDD,1,6)+'01' = FP.YYYYMMDD
AND FP.UNIT_CURRENCY = 'USD'
WHERE PR.DIVISION_ID = @p_division_id
AND PR.VERSION_NO = @p_version_no
AND PR.MEASURE = 'SalesAmt_KRW'
AND PR.SCM_SITE_ID NOT IN (SELECT SEGMENT1
FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK)
WHERE LOOKUP_TYPE = 'INTERNAL_TXN')  -- 20190906 소거매출 제외
AND PR.YYYYMMDD LIKE (SELECT YYYY FROM DM_MST_CONTRIBUTE_VER WITH (NOLOCK) WHERE VER_SEQ = @p_ver_seq)+'%'
	CREATE TABLE #tmp_plan_report_c (
	DIVISION_ID		nvarchar(5)
	, VERSION_NO	nvarchar(30)
	, PROJECT_CODE	nvarchar(30)
	, SCM_SITE_ID	nvarchar(30)
	, ITEM_ID		nvarchar(50)
	, YYYYMMDD		nvarchar(8)
	, QTY			NUMERIC(30,10)
	IF ( @p_version_no LIKE 'BP%')
	BEGIN
		INSERT INTO #tmp_plan_report_c
		SELECT DIVISION_ID
			 , VERSION_NO
			 , PROJECT_CODE
			 , SCM_SITE_ID
			 , ITEM_ID
			 , YYYYMMDD
			 , QTY
		 FROM (
				   SELECT DIVISION_ID
					 , VERSION_NO
					 , PROJECT_CODE
					 , SCM_SITE_ID
					 , ITEM_ID
					 , YYYYMM AS YYYYMMDD
					 , QTY
				  FROM DM_PLN_BP_FCST_REPORT_C WITH (NOLOCK)
				 WHERE DIVISION_ID = @p_division_id
				   AND VERSION_NO = @p_version_no
				   AND MEASURE = 'SalesAmt_USD'
				   AND SCM_SITE_ID NOT IN (
											--SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK) WHERE LOOKUP_TYPE = 'INTERNAL_TXN'  -- 20190906 소거매출 제외 -- 20200427 KHSONG 주석처리
											SELECT COMPANY_ID FROM SCM_MST_COMPANY_SN WITH(NOLOCK)  -- 20200427 KHSONG C20200305-000035 매출 쿼리 수정 요청의 건 (COMPANY정보 실시간 현행화)
				   AND YYYYMM LIKE (SELECT YYYY FROM DM_MST_CONTRIBUTE_VER WITH (NOLOCK) WHERE VER_SEQ = @p_ver_seq)+'%'
				   ) A
	END
	ELSE
	BEGIN
		INSERT INTO #tmp_plan_report_c
		SELECT DIVISION_ID
			 , VERSION_NO
			 , PROJECT_CODE
			 , SCM_SITE_ID
			 , ITEM_ID
			 , YYYYMMDD
			 , QTY
		 FROM ( SELECT DIVISION_ID
					 , VERSION_NO
					 , PROJECT_CODE
					 , SCM_SITE_ID
					 , ITEM_ID
					 , YYYYMMDD
					 , QTY
				  FROM DM_PLN_SALES_PLAN_REPORT_C WITH (NOLOCK)
				 WHERE DIVISION_ID = @p_division_id
				   AND VERSION_NO = @p_version_no
				   AND MEASURE = 'SalesAmt_USD'
				   AND SCM_SITE_ID NOT IN (
											--SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK) WHERE LOOKUP_TYPE = 'INTERNAL_TXN'  -- 20190906 소거매출 제외 -- 20200427 KHSONG 주석처리
											SELECT COMPANY_ID FROM SCM_MST_COMPANY_SN WITH(NOLOCK)  -- 20200427 KHSONG C20200305-000035 매출 쿼리 수정 요청의 건 (COMPANY정보 실시간 현행화)
				   AND YYYYMMDD LIKE (SELECT YYYY FROM DM_MST_CONTRIBUTE_VER WITH (NOLOCK) WHERE VER_SEQ = @p_ver_seq)+'%'
				) A
	END
SELECT *
INTO #tmp_sales_list_c
FROM
(SELECT SUBSTRING(A.YYYYMMDD,1,6) AS YYYYMM
, TEAM.DEPARTMENT_ID
, TEAM.DEPARTMENT_NAME
, TEAM.DEPT_ID
, TEAM.DEPT_NAME_KO AS DEPT_NAME
, ISNULL(I.REPORT_GROUP2,'') AS CUST_REPORT
, ISNULL(I.ATTRIBUTE2,'') AS END_CUST_REPORT
, ISNULL(I.ATTRIBUTE1,'') AS SOLDTO_CUST_REPORT
, ISNULL(SC.SHIPTO_CODE,'') AS SHIPTO_CODE
, ISNULL(I.REPORT_GROUP3,'') AS PRODUCT_GROUP
, ISNULL(C.FORECAST_INFO_BIZ_TYPE,'') AS DM_BIZ_TYPE
, CASE WHEN ISNULL(@p_million_yn,'N') = 'Y' THEN SUM(QTY)/1000000 ELSE SUM(QTY) END AS AMT
			 , 'Y' AS EDIT_FLAG
FROM #tmp_plan_report_c A WITH (NOLOCK) --Inner join에서 Left join 으로 변경
LEFT JOIN SCM_MST_SITE_ITEM I WITH (NOLOCK)
ON A.DIVISION_ID = I.DIVISION_ID
AND A.PROJECT_CODE = I.PROJECT_CODE
AND A.SCM_SITE_ID = I.SCM_SITE_ID
AND A.ITEM_ID = I.ITEM_ID
LEFT JOIN SCM_MST_SITE_CUSTOMER SC WITH (NOLOCK)
ON SC.DIVISION_ID = I.DIVISION_ID
AND SC.SCM_SITE_ID = I.SCM_SITE_ID
AND SC.REP_YN      = 'Y'
LEFT JOIN SCM_MST_SITE B WITH (NOLOCK)
ON A.DIVISION_ID = B.DIVISION_ID
				 AND A.SCM_SITE_ID = B.SCM_SITE_ID
LEFT JOIN DM_MST_ITEM_SINGLE_V C WITH (NOLOCK)
ON A.DIVISION_ID = C.DIVISION_ID
AND A.ITEM_ID = C.ITEM_ID
--AND ISNULL(C.FORECAST_INFO_BIZ_TYPE,'') <> ''
LEFT JOIN (
SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO , D.DEPT_ID AS DEPARTMENT_ID, D.DEPT_NAME_KO AS DEPARTMENT_NAME
FROM [SCM_MST_SSO_USER_INFO] AS B WITH (NOLOCK)
INNER JOIN SCM_MST_SSO_DEPT_INFO AS C WITH (NOLOCK)
ON B.DEPT_ID = C.DEPT_ID
INNER JOIN SCM_MST_SSO_DEPT_INFO AS D WITH (NOLOCK)
ON C.UPPER_DEPT_ID = D.DEPT_ID
) AS TEAM
ON TEAM.USER_ID IN (SELECT TOP 1 TOKEN FROM [DBO].[STRING_SPLIT](I.OWNER, ','))
WHERE A.DIVISION_ID = @p_division_id
AND A.VERSION_NO = @p_version_no
AND A.YYYYMMDD LIKE (SELECT YYYY FROM DM_MST_CONTRIBUTE_VER WITH (NOLOCK) WHERE VER_SEQ = @p_ver_seq)+'%'
GROUP BY SUBSTRING(A.YYYYMMDD,1,6)
, TEAM.DEPARTMENT_ID
, TEAM.DEPARTMENT_NAME
, TEAM.DEPT_ID
, TEAM.DEPT_NAME_KO
, ISNULL(I.REPORT_GROUP2,'')
, ISNULL(I.ATTRIBUTE2,'')
, ISNULL(I.ATTRIBUTE1,'')
, ISNULL(SC.SHIPTO_CODE,'')
, ISNULL(I.REPORT_GROUP3,'')
, ISNULL(C.FORECAST_INFO_BIZ_TYPE,'')
UNION ALL
SELECT SUBSTRING(A.YYYYMMDD,1,6) AS YYYYMM
, TEAM.DEPARTMENT_ID
, TEAM.DEPARTMENT_NAME
, TEAM.DEPT_ID
, TEAM.DEPT_NAME_KO AS DEPT_NAME
, ISNULL(I.REPORT_GROUP2,'') AS CUST_REPORT
, ISNULL(I.ATTRIBUTE2,'') AS END_CUST_REPORT
, ISNULL(I.ATTRIBUTE1,'') AS SOLDTO_CUST_REPORT
, ISNULL(SC.SHIPTO_CODE,'') AS SHIPTO_CODE
, ISNULL(I.REPORT_GROUP3,'') AS PRODUCT_GROUP
, ISNULL(C.FORECAST_INFO_BIZ_TYPE,'') AS DM_BIZ_TYPE
, CASE WHEN ISNULL(@p_million_yn,'N') = 'Y' THEN SUM(QTY)/1000000 ELSE SUM(QTY) END AS AMT
			 , 'Y' AS EDIT_FLAG
FROM #tmp_sales_result_c A WITH (NOLOCK)
INNER JOIN SCM_MST_SITE_ITEM I WITH (NOLOCK)
ON A.DIVISION_ID = I.DIVISION_ID
AND A.PROJECT_CODE = I.PROJECT_CODE
AND A.SCM_SITE_ID = I.SCM_SITE_ID
AND A.ITEM_ID = I.ITEM_ID
INNER JOIN SCM_MST_SITE_CUSTOMER SC WITH (NOLOCK)
ON SC.DIVISION_ID = I.DIVISION_ID
AND SC.SCM_SITE_ID = I.SCM_SITE_ID
AND SC.REP_YN      = 'Y'
INNER JOIN SCM_MST_SITE B WITH (NOLOCK)
ON A.DIVISION_ID = B.DIVISION_ID
AND A.SCM_SITE_ID = B.SCM_SITE_ID
INNER JOIN DM_MST_ITEM_SINGLE_V C WITH (NOLOCK)
ON A.DIVISION_ID = C.DIVISION_ID
AND A.ITEM_ID = C.ITEM_ID
--AND ISNULL(C.FORECAST_INFO_BIZ_TYPE,'') <> ''
LEFT JOIN (
SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO , D.DEPT_ID AS DEPARTMENT_ID, D.DEPT_NAME_KO AS DEPARTMENT_NAME
FROM [SCM_MST_SSO_USER_INFO] AS B WITH (NOLOCK)
INNER JOIN SCM_MST_SSO_DEPT_INFO AS C WITH (NOLOCK)
ON B.DEPT_ID = C.DEPT_ID
INNER JOIN SCM_MST_SSO_DEPT_INFO AS D WITH (NOLOCK)
ON C.UPPER_DEPT_ID = D.DEPT_ID
) AS TEAM
ON TEAM.USER_ID IN (SELECT TOP 1 TOKEN FROM [DBO].[STRING_SPLIT](I.OWNER, ','))
WHERE A.DIVISION_ID = @p_division_id
AND A.VERSION_NO = @p_version_no
AND A.YYYYMMDD LIKE (SELECT YYYY FROM DM_MST_CONTRIBUTE_VER WITH (NOLOCK) WHERE VER_SEQ = @p_ver_seq)+'%'
GROUP BY SUBSTRING(A.YYYYMMDD,1,6)
, TEAM.DEPARTMENT_ID
, TEAM.DEPARTMENT_NAME
, TEAM.DEPT_ID
, TEAM.DEPT_NAME_KO
, ISNULL(I.REPORT_GROUP2,'')
, ISNULL(I.ATTRIBUTE2,'')
, ISNULL(I.ATTRIBUTE1,'')
, ISNULL(SC.SHIPTO_CODE,'')
, ISNULL(I.REPORT_GROUP3,'')
, ISNULL(C.FORECAST_INFO_BIZ_TYPE,'')*/
) A
DECLARE c_code CURSOR FAST_FORWARD FOR
	SELECT DISTINCT CODE, LARGE_CODE, SMALL_CODE, SEQ
	FROM (
		SELECT
			  L.SEGMENT1 + '#' + CASE WHEN L.SEGMENT4 = 'Y' THEN '' ELSE M.SEGMENT1 END AS CODE
			, L.SEGMENT1  AS LARGE_CODE
			, CASE WHEN L.SEGMENT4 = 'Y' THEN L.SEGMENT1 ELSE M.SEGMENT1 END AS SMALL_CODE
			, RANK() OVER ( ORDER BY L.DISPLAY_SEQ, CASE WHEN L.SEGMENT4 = 'Y' THEN 0 ELSE M.DISPLAY_SEQ END ) AS SEQ
		FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)
			,  [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] M  WITH(NOLOCK)
		WHERE  1 = 1
		AND    L.LOOKUP_TYPE = 'DM_OS_CORP_CD'
		AND    M.LOOKUP_TYPE = 'DM_CONTRIBUTION_TYPE_CD'
		AND    L.VALID_YN    = 'Y'
		AND    L.SEGMENT3    = 'Y'
		AND    M.VALID_YN    = 'Y'
		) A
ORDER BY A.SEQ
SET @v_sql_text = '
WITH SALES_LIST AS (
SELECT A.YYYYMM
, A.DEPARTMENT_NAME
, A.DEPT_NAME
, A.DEPARTMENT_ID
, A.DEPT_ID
, A.CUST_REPORT
, A.END_CUST_REPORT
, A.SOLDTO_CUST_REPORT
, A.SHIPTO_CODE
, A.PRODUCT_GROUP
, A.DM_BIZ_TYPE
		 , A.EDIT_FLAG ';
OPEN c_code;
FETCH NEXT FROM c_code INTO @v_code, @v_large_code, @v_small_code, @v_seq -- @v_seq 는 사용하지 않음. 커서문에서 distinct 를 넣기 위해 사용
WHILE @@FETCH_STATUS = 0
BEGIN
SET @v_sql_text = @v_sql_text + '
, SUM(CASE WHEN ISNULL(B.CONTRIBUTION_RATIO,0) > 0 AND B.CONTRIBUTION_TYPE = ''' + @v_small_code + ''' AND B.OS_CORP_CD = ''' + @v_large_code + '''
THEN B.CONTRIBUTION_RATIO/100*A.AMT
ELSE 0
END) AS ' + @v_code + ' ';
--select @v_code
		IF @v_code NOT LIKE '%Total%'
		BEGIN
			SET @v_col_Sum = @v_col_Sum + ', SUM('+@v_code+') AS ' + @v_code;
			SET @v_bottom_Sum = @v_bottom_Sum + ', SUM('+@v_code+') AS ' + @v_code;
		END
		---- 컬럼합계 ( Total )
		IF @v_code NOT LIKE '%Total%'	-- Total 이 아닌 컬럼에서는 SUM 을 구성하고
			SET @v_col_Total = @v_col_Total +  CASE WHEN @v_col_Total = '' THEN '' ELSE ' +' END + 'ISNULL(SUM(' + @v_code + '), 0)'
		ELSE							-- Total 컬럼에서는 AS 를 붙여서 마무리
			SET @v_col_Total = @v_col_Total + ' AS ' + @v_code
-- select @v_col_Sum as v_sum_column, @v_code as v_code, @v_col_Total, @v_ttsum_column_com
FETCH NEXT FROM c_code INTO @v_code, @v_large_code, @v_small_code, @v_seq
END
CLOSE c_code;
DEALLOCATE c_code;
SET @v_sql_text = @v_sql_text + '
FROM #tmp_sales_list_c A
INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL B WITH (NOLOCK)
ON A.DEPARTMENT_ID = B.DEPARTMENT_ID
AND A.DEPT_ID = B.DEPT_ID
AND A.END_CUST_REPORT = B.END_CUST_REPORT
AND A.SOLDTO_CUST_REPORT = B.SOLDTO_CUST_REPORT
AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
AND A.DM_BIZ_TYPE = B.DM_BIZ_TYPE
AND A.YYYYMM = B.YYYYMM
WHERE B.VER_SEQ = ' + @p_ver_seq + '
[@v_end_cust_report]
[@v_product_group]
[@v_biz_type]
SET @v_sql_text = @v_sql_text + '
GROUP BY A.YYYYMM
, A.DEPARTMENT_NAME
, A.DEPT_NAME
, A.DEPARTMENT_ID
, A.DEPT_ID
, A.CUST_REPORT
, A.END_CUST_REPORT
, A.SOLDTO_CUST_REPORT
, A.SHIPTO_CODE
, A.PRODUCT_GROUP
, A.DM_BIZ_TYPE
		 , A.EDIT_FLAG
SELECT [@v_col]  [@v_col_Sum],' + @v_col_Total + '
FROM   SALES_LIST A
[@v_groupby]
UNION ALL	--합계행
SELECT [@v_bottom] [@v_bottom_Sum],' + @v_col_Total + '
FROM   SALES_LIST A
[@v_orderby]
--    SET @v_sql_text = REPLACE(@v_sql_text,'[@v_end_cust_report]'  , [dbo].[FN_SCM_GET_WHERE_SQL]('A.END_CUST_REPORT'  , 'IN', @p_end_cust_report));
SET @v_sql_text = REPLACE(@v_sql_text,'[@v_end_cust_report]'  , ' AND A.END_CUST_REPORT LIKE N''%' + @p_end_cust_report + '%'' ');
SET @v_sql_text = REPLACE(@v_sql_text,'[@v_product_group]'  , [dbo].[FN_SCM_GET_WHERE_SQL]('A.PRODUCT_GROUP'  , 'IN', @p_product_group));
SET @v_sql_text = REPLACE(@v_sql_text,'[@v_biz_type]'  , [dbo].[FN_SCM_GET_WHERE_SQL]('A.DM_BIZ_TYPE'  , 'IN', @p_biz_type));
SET @v_sql_text = REPLACE(@v_sql_text,'[@v_col]'  , @v_col);
	SET @v_sql_text = REPLACE(@v_sql_text,'[@v_bottom]'  , @v_bottom);
SET @v_sql_text = REPLACE(@v_sql_text,'[@v_col_Sum]'  , @v_col_Sum);
--   SET @v_sql_text = REPLACE(@v_sql_text,'[@v_col_Sum]'  , @v_col_Sum);
--   SET @v_sql_text = REPLACE(@v_sql_text,'[@v_col_Sum]'  , @v_col_Sum);
SET @v_sql_text = REPLACE(@v_sql_text,'[@v_bottom_Sum]'  , @v_bottom_Sum);
SET @v_sql_text = REPLACE(@v_sql_text,'[@v_groupby]'  , @v_groupby);
SET @v_sql_text = REPLACE(@v_sql_text,'[@v_orderby]'  , @v_orderby);
--select @v_col;
--select @v_sql_text;
--return;
EXEC SP_EXECUTESQL @v_sql_text;
EXEC SP_EXECUTESQL @nsql2;
IF ISNULL(@p_compatibility_yn,'N') = 'Y'
BEGIN
SELECT
-- 등록이 안된 건 count
(SELECT COUNT(*)
FROM (SELECT TEAM.DEPARTMENT_ID
, TEAM.DEPT_ID AS DEPT_ID
, ISNULL(A.ATTRIBUTE2,'') AS END_CUST_REPORT
, ISNULL(A.ATTRIBUTE1,'') AS SOLDTO_CUST_REPORT
, ISNULL(A.REPORT_GROUP3,'') AS PRODUCT_GROUP
, ISNULL(C.FORECAST_INFO_BIZ_TYPE,'') AS DM_BIZ_TYPE
FROM SCM_MST_SITE_ITEM A WITH (NOLOCK)
INNER JOIN SCM_MST_SITE B WITH (NOLOCK)
ON A.DIVISION_ID = B.DIVISION_ID
AND A.SCM_SITE_ID = B.SCM_SITE_ID
INNER JOIN DM_MST_ITEM_SINGLE_V C WITH (NOLOCK)
ON A.DIVISION_ID = C.DIVISION_ID
AND A.ITEM_ID = C.ITEM_ID
LEFT JOIN (
SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO
, D.DEPT_ID AS DEPARTMENT_ID, D.DEPT_NAME_KO AS DEPARTMENT_NAME
FROM [SCM_MST_SSO_USER_INFO] AS B WITH (NOLOCK)
INNER JOIN SCM_MST_SSO_DEPT_INFO AS C WITH (NOLOCK)
ON B.DEPT_ID = C.DEPT_ID
INNER JOIN SCM_MST_SSO_DEPT_INFO AS D WITH (NOLOCK)
ON C.UPPER_DEPT_ID = D.DEPT_ID
) AS TEAM
ON TEAM.USER_ID IN (SELECT TOP 1 TOKEN FROM [DBO].[STRING_SPLIT](A.OWNER, ','))
WHERE A.DIVISION_ID = @p_division_id
AND B.SITE_TYPE = 'SALES'
AND ISNULL(C.FORECAST_INFO_BIZ_TYPE,'') <> ''
AND ISNULL(A.ATTRIBUTE2,'') <> ''
AND ISNULL(A.ATTRIBUTE1,'') <> ''
AND ISNULL(A.REPORT_GROUP3,'') <> ''
GROUP BY A.DIVISION_ID
, TEAM.DEPARTMENT_ID
, TEAM.DEPT_ID
, ISNULL(A.ATTRIBUTE2,'')
, ISNULL(A.ATTRIBUTE1,'')
, ISNULL(A.REPORT_GROUP3,'')
, ISNULL(C.FORECAST_INFO_BIZ_TYPE,'')
) LIST
LEFT OUTER JOIN DM_MST_CONTRIBUTE_RATIO_MST RATIO WITH (NOLOCK)
ON LIST.DEPARTMENT_ID = RATIO.DEPARTMENT_ID
AND LIST.DEPT_ID = RATIO.DEPT_ID
AND LIST.END_CUST_REPORT = RATIO.END_CUST_REPORT
AND LIST.SOLDTO_CUST_REPORT = RATIO.SOLDTO_CUST_REPORT
AND LIST.PRODUCT_GROUP = RATIO.PRODUCT_GROUP
AND LIST.DM_BIZ_TYPE = RATIO.DM_BIZ_TYPE
WHERE RATIO.DEPARTMENT_ID IS NULL
AND RATIO.VER_SEQ = @p_ver_seq)
-- 100%가 안되는 건 COUNT
(SELECT COUNT(*)
FROM (SELECT SUM(A.CONTRIBUTION_RATIO) AS RATIO
FROM DM_MST_CONTRIBUTE_RATIO_MST M WITH (NOLOCK)
INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL A WITH (NOLOCK)
ON M.VER_SEQ = A.VER_SEQ
AND M.DEPARTMENT_ID = A.DEPARTMENT_ID
AND M.DEPT_ID = A.DEPT_ID
AND M.END_CUST_REPORT = A.END_CUST_REPORT
AND M.SOLDTO_CUST_REPORT = A.SOLDTO_CUST_REPORT
AND M.PRODUCT_GROUP = A.PRODUCT_GROUP
AND M.DM_BIZ_TYPE = A.DM_BIZ_TYPE
WHERE A.VER_SEQ = @p_ver_seq
GROUP BY A.DEPARTMENT_ID
, A.DEPT_ID
, A.END_CUST_REPORT
, A.SOLDTO_CUST_REPORT
, A.PRODUCT_GROUP
, A.DM_BIZ_TYPE
, A.YYYYMM
) R
WHERE R.RATIO <> 100)
			 SELECT COUNT(*)
			  FROM #tmp_sales_list_c A
			left outer JOIN DM_MST_CONTRIBUTE_RATIO_DTL B WITH (NOLOCK)
						  ON A.DEPARTMENT_ID = B.DEPARTMENT_ID
						 AND A.DEPT_ID = B.DEPT_ID
						 AND A.END_CUST_REPORT = B.END_CUST_REPORT
						 AND A.SOLDTO_CUST_REPORT = B.SOLDTO_CUST_REPORT
						 AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
						 AND A.DM_BIZ_TYPE = B.DM_BIZ_TYPE
						 AND A.YYYYMM = B.YYYYMM
						 and B.VER_SEQ = 2
				 WHERE A.END_CUST_REPORT LIKE N'%%'
				  and b.dept_id is null
				) AS CNT;
END
ELSE
BEGIN
SELECT 0 AS CNT;
END
-- --xml확인할경우
--SELECT CONVERT(TEXT, @v_sql_text)
--FOR XML PATH('')--,ROOT('x')
select max(version_no) from dm_pln_sales_plan_c with (nolock);
select * from DM_MST_CONTRIBUTE_VER where version_no = 'SP_W_20190905_V001'
EXEC DMF0043_GET_CONTRIBUTION_SALES_LIST
@p_division_id='40',
@p_ver_seq='19',
@p_version_no='SP_W_20190905_V001',
@p_end_cust_report='',
@p_product_group='ALL',
@p_biz_type='ALL',
@p_million_yn='N',
@p_compatibility_yn='N',
@p_created_by='hwi1993'
EXEC [dbo].[DMF0043_GET_CONTRIBUTION_SALES_LIST]
@p_division_id = '40',
@p_ver_seq = 1,
@p_version_no = 'SP_W_20190905_V001',
@p_end_cust_report = '',
@p_product_group   = '',
@p_biz_type         = '',
@p_million_yn       = 'N',
@p_compatibility_yn = 'Y',
@p_created_by       = 'hwi1993'
END
