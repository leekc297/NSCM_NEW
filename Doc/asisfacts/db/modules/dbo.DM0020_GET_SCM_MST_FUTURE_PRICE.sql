/****************************************************************************************************/
/* Program ID  : [DMF0006_GET_CUSTOMERMODELMAPPING]                                                           */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/03/12  SeungJae.Hwnag       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 2018/05/30  JYE			복수 팀 권한 관련  수정  */
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[DM0020_GET_SCM_MST_FUTURE_PRICE]
    @p_division_id              NVARCHAR(30),
	@p_dept_id        NVARCHAR(MAX),	--Department
    @p_end_customer   NVARCHAR(MAX),	--Endcustomer
	@p_scm_site_id              NVARCHAR(MAX),
	@p_plant_site_id              NVARCHAR(MAX),
    @p_project_code             NVARCHAR(MAX),
	@p_item_id                  NVARCHAR(MAX),
	@p_customer_project_code    NVARCHAR(MAX),
	@p_customer_model           NVARCHAR(MAX),
	@p_from_yyyymmdd            NVARCHAR(8),
	@p_to_yyyymmdd             NVARCHAR(8),
	@p_biztype                 NVARCHAR(MAX),
	@p_created_by              NVARCHAR(MAX),
	@p_userinfo                 NVARCHAR(MAX)
 
AS  
  -- EXEC DM0020_GET_SCM_MST_FUTURE_PRICE @p_division_id='81', @p_dept_id='ALL', @p_end_customer='ALL', @p_scm_site_id='ALL', @p_plant_site_id='ALL', @p_project_code='', @p_item_id='', @p_customer_project_code='', @p_customer_model='', @p_from_yyyymmdd='20180326', @p_to_yyyymmdd='20180926', @p_biztype='ALL', @p_created_by='20140001', @p_userinfo='ADMIN'

BEGIN
  SET NOCOUNT ON;

    DECLARE @v_dept_id nvarchar(max)='';
	DECLARE @v_group_id nvarchar(max)='';

	IF @p_userinfo = 'ADMIN' OR @p_userinfo = 'DM ADMIN'
		SET @v_group_id = 'ADMIN'

  DECLARE @Prod varchar(max);
  DECLARE @nsql nvarchar(max);
  SELECT  @Prod = '';
  
IF OBJECT_ID (N'tempdb..#tmpData', N'U') IS NOT NULL 
	DROP TABLE #tmpData
IF OBJECT_ID (N'tempdb..#tmpOutput', N'U') IS NOT NULL 
	DROP TABLE #tmpOutput
	
SELECT    
   A.DIVISION_ID,
   B.DIVISION_NAME,
   DEPRTMENT.DEPT_ID AS UPPER_DEPT_ID,
   TEAM.DEPT_ID, 
   --CASE WHEN isnull(TEAM.DEPT_NAME_KO,'') = '' THEN '' ELSE RIGHT(isnull(TEAM.DEPT_NAME_KO,''), CHARINDEX('.',REVERSE(isnull(TEAM.DEPT_NAME_KO,''))) -1) END AS TEAM_INCHARGE,
   A.SCM_SITE_ID,
   A.PLANT_SITE_ID,
   C.SITE_DESCRIPTION,   
   isnull(C.END_CUSTOMER,'') AS END_CUSTOMER,
   A.PROJECT_CODE,
   PJT.PROJECT_NAME,
   PJT.BIZ_TYPE as BIZ_TYPE_NAME,
   --PJT.BIZ_TYPE_NAME,
   PJT.PROJECT_STATUS,
   A.ITEM_ID,
   ITEM.ITEM_CLASS_NAME, 
   isnull(ITEM.ITEM_NAME,'')AS ITEM_NAME,
   A.INCOTERMS,
   --SITE_ITEM.CURRENCY,
   A.CURRENCY,
   A.FCST_TYPE,
   A.DOM_EXP,
   MEASURE.LOOKUP_CODE AS MEASURE,
   MEASURE.DISPLAY_SEQ,
   --CASE WHEN (RTRIM(TEAM.DEPT_ID) = RTRIM(@v_dept_id) OR @v_group_id ='ADMIN') THEN 'Y' ELSE 'N' END AS AUTHORITY_YN
   CASE WHEN (([dbo].[FN_GET_DEPT_LIST](@p_created_by, TEAM.DEPT_ID) = 'Y') OR @v_group_id ='ADMIN') THEN 'Y' ELSE 'N' END AS AUTHORITY_YN
   ,A.YYYYMMDD
   --,A.PRICE

INTO #tmpData
FROM SCM_MST_FUTURE_PRICE AS A WITH(NOLOCK)
LEFT JOIN (SELECT * FROM SCM_MST_DIVISION WITH(NOLOCK) WHERE VALID_YN = 'Y') AS B 
ON A.DIVISION_ID = B.DIVISION_ID
LEFT JOIN (SELECT * FROM SCM_MST_SITE WITH(NOLOCK) WHERE VALID_YN = 'Y') AS C 
ON A.DIVISION_ID = C.DIVISION_ID AND A.SCM_SITE_ID = C.SCM_SITE_ID AND C.SITE_TYPE = 'SALES'
LEFT JOIN (SELECT * FROM SCM_MST_SITE WITH(NOLOCK) WHERE VALID_YN = 'Y') AS D
ON A.DIVISION_ID = D.DIVISION_ID AND A.SCM_SITE_ID = D.SCM_SITE_ID AND C.SITE_TYPE = 'PLANT'
LEFT JOIN (SELECT * FROM SCM_MST_SSO_DEPT_INFO WITH(NOLOCK) WHERE VALID_YN = 'Y') AS TEAM			       
			       ON C.DEPT_ID = TEAM.DEPT_ID
LEFT JOIN (SELECT * FROM SCM_MST_SSO_DEPT_INFO WITH(NOLOCK) WHERE VALID_YN = 'Y') AS DEPRTMENT			       
	ON TEAM.UPPER_DEPT_ID = DEPRTMENT.DEPT_ID
INNER JOIN   
(
--SELECT DISTINCT DIVISION_ID, ITEM_ID, NICK_NAME, ITEM_CLASS, ITEM_CLASS_NAME
--FROM SCM_MST_ITEM_SN WITH(NOLOCK)
  SELECT * FROM DM_MST_ITEM_SINGLE_V  WITH(NOLOCK)
)  AS ITEM 
ON   A.DIVISION_ID = ITEM.DIVISION_ID AND A.ITEM_ID  = ITEM.ITEM_ID
LEFT JOIN 
(

SELECT PJTS.DIVISION_ID, PJTS.PROJECT_CODE, PJTS.PROJECT_NAME, PJTS.PROJECT_VER_SEQ, PJTS.CAPACITY, BIZ_TYPE, BIZ_TYPE_NAME, PROJECT_STATUS
	FROM SCM_MST_PROJECT PJTS WITH(NOLOCK)
	INNER JOIN 
	(
		SELECT DIVISION_ID, PROJECT_CODE, MAX(PROJECT_VER_SEQ) AS PROJECT_VER_SEQ
		FROM SCM_MST_PROJECT WITH(NOLOCK)
		GROUP BY DIVISION_ID, PROJECT_CODE
	) PJTSG 
	ON PJTSG.DIVISION_ID = PJTS.DIVISION_ID AND PJTSG.PROJECT_CODE = PJTS.PROJECT_CODE AND PJTSG.PROJECT_VER_SEQ = PJTS.PROJECT_VER_SEQ


) AS PJT ON   A.DIVISION_ID = PJT.DIVISION_ID AND A.PROJECT_CODE = PJT.PROJECT_CODE
LEFT JOIN (SELECT * FROM SCM_MST_SITE_ITEM WITH(NOLOCK) WHERE VALID_YN = 'Y') AS SITE_ITEM
ON SITE_ITEM.DIVISION_ID = A.DIVISION_ID
	AND SITE_ITEM.PROJECT_CODE = A.PROJECT_CODE
	AND SITE_ITEM.SCM_SITE_ID = A.SCM_SITE_ID
	AND SITE_ITEM.ITEM_ID = A.ITEM_ID
CROSS JOIN
(
SELECT  COLUMN_NAME AS LOOKUP_CODE, 
		COLUMN_LABEL_NAME AS [DESCRIPTION], 
		SORT_ORDER_NO AS DISPLAY_SEQ
FROM     SCM_MST_SHEET_MEASURE WITH(NOLOCK)
WHERE  (PROGRAM_ID = 'DMF1006' AND SHEET_NAME = 'Sales Price')
		AND COLUMN_NAME <> 'LOC'
UNION
SELECT  COLUMN_NAME AS LOOKUP_CODE, 
		COLUMN_LABEL_NAME AS [DESCRIPTION], 
		SORT_ORDER_NO AS DISPLAY_SEQ
FROM     SCM_MST_SHEET_MEASURE WITH(NOLOCK)
WHERE  (PROGRAM_ID = 'DMF1006' AND SHEET_NAME = 'Sales Price')
		AND COLUMN_NAME = 'LOC'
--ORDER BY SORT_ORDER_NO
) AS MEASURE
--WHERE
--SITE_ITEM.CURRENCY IS NOT NULL
WHERE   (A.YYYYMMDD >= @p_from_yyyymmdd and A.YYYYMMDD <= @p_to_yyyymmdd)		       
		AND CASE WHEN @p_division_id = 'ALL' THEN 'ALL'
		   		 ELSE A.DIVISION_ID			
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_division_id,',') as P Where 
					(CASE WHEN @p_division_id = 'ALL' THEN 'ALL' ELSE A.DIVISION_ID END) = P.data
	               )
		AND CASE WHEN @p_dept_id = 'ALL' THEN 'ALL'
		   		 ELSE TEAM.DEPT_ID			
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_dept_id,',') as P Where 
					(CASE WHEN @p_dept_id = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END) = P.data
	               )
		AND CASE WHEN @p_end_customer = 'ALL' THEN 'ALL'
		   		 ELSE isnull(C.END_CUSTOMER,'')			
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_end_customer,',') as P Where 
					(CASE WHEN @p_end_customer = 'ALL' THEN 'ALL' ELSE isnull(C.END_CUSTOMER,'') END) = P.data
	               )				   
		AND CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL'
		   		 ELSE A.SCM_SITE_ID			
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_scm_site_id,',') as P Where 
					(CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL' ELSE A.SCM_SITE_ID END) = P.data
	               )
		AND CASE WHEN @p_plant_site_id = 'ALL' THEN 'ALL'
		   		 ELSE A.PLANT_SITE_ID			
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_plant_site_id,',') as P Where 
					(CASE WHEN @p_plant_site_id = 'ALL' THEN 'ALL' ELSE A.PLANT_SITE_ID END) = P.data
	               )
		AND CASE WHEN @p_project_code = '' THEN ''
		   		 ELSE A.PROJECT_CODE			
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_project_code,',') as P Where 
					(CASE WHEN @p_project_code = '' THEN '' ELSE A.PROJECT_CODE END) = P.data
	               )

		AND CASE WHEN @p_biztype = 'ALL' THEN 'ALL'
		   		 ELSE PJT.BIZ_TYPE			
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_biztype,',') as P Where 
					(CASE WHEN @p_biztype = 'ALL' THEN 'ALL' ELSE PJT.BIZ_TYPE END) = P.data
	               )
-- Muliti Like case.
	   AND Exists (Select * from dbo.UF_FX_String_Split (@p_item_id,',') as P Where A.ITEM_ID LIKE N'%' + P.token +'%')
	   --AND Exists (Select * from dbo.UF_FX_String_Split (@p_item_id,',') as P Where A.ITEM_ID LIKE N'%' + P.token +'%')


GROUP BY 
		A.DIVISION_ID,
		B.DIVISION_NAME,
		DEPRTMENT.DEPT_ID,
		TEAM.DEPT_ID, 
		--CASE WHEN isnull(TEAM.DEPT_NAME_KO,'') = '' THEN '' ELSE RIGHT(isnull(TEAM.DEPT_NAME_KO,''), CHARINDEX('.',REVERSE(isnull(TEAM.DEPT_NAME_KO,''))) -1) END,
		A.SCM_SITE_ID,
		A.PLANT_SITE_ID,
		C.SITE_DESCRIPTION,		
		isnull(C.END_CUSTOMER,''),
		A.PROJECT_CODE,
		PJT.PROJECT_NAME,
	   PJT.BIZ_TYPE,
	   --PJT.BIZ_TYPE_NAME,
	   PJT.PROJECT_STATUS,
		A.ITEM_ID,
		ITEM.ITEM_CLASS_NAME, 
		isnull(ITEM.ITEM_NAME,''),
		A.INCOTERMS,
		 A.FCST_TYPE,
		 A.DOM_EXP,
		A.CURRENCY,		
		MEASURE.LOOKUP_CODE,
		MEASURE.DISPLAY_SEQ,
		CASE WHEN RTRIM(TEAM.DEPT_ID) = RTRIM(@v_dept_id) THEN 'Y' ELSE 'N' END
		,A.YYYYMMDD
		--,A.PRICE

CREATE INDEX IDX_PRICE_KEYS ON #tmpData(DIVISION_ID ASC, PROJECT_CODE ASC, SCM_SITE_ID ASC, PLANT_SITE_ID ASC, ITEM_ID ASC, CURRENCY ASC, MEASURE ASC, DOM_EXP ASC, FCST_TYPE ASC, INCOTERMS ASC, YYYYMMDD ASC);



-- 1. 실데이타와 조인
SELECT 
		A.DIVISION_ID,
		A.DIVISION_NAME,
		A.UPPER_DEPT_ID,
		A.DEPT_ID	,
		A.SCM_SITE_ID,
		A.PLANT_SITE_ID,
		A.SITE_DESCRIPTION,
		A.END_CUSTOMER,
		A.PROJECT_CODE,
		A.PROJECT_NAME,
		A.BIZ_TYPE_NAME,
		A.PROJECT_STATUS,
		A.ITEM_ID,
		A.ITEM_CLASS_NAME,
		A.ITEM_NAME,
		A.INCOTERMS,
		A.CURRENCY,
		A.FCST_TYPE,
		A.DOM_EXP,
		A.MEASURE,
		A.DISPLAY_SEQ,
		A.AUTHORITY_YN,
		A.YYYYMMDD,
		ISNULL(B.PRICE,0) AS PRICE
INTO #tmpOutput
FROM #tmpData A
LEFT JOIN (SELECT * FROM SCM_MST_FUTURE_PRICE WITH(NOLOCK) WHERE (YYYYMMDD >= @p_from_yyyymmdd and YYYYMMDD <= @p_to_yyyymmdd)) AS B 
ON A.DIVISION_ID = B.DIVISION_ID 
   AND A.PROJECT_CODE = B.PROJECT_CODE
   AND A.SCM_SITE_ID = B.SCM_SITE_ID 
   AND A.PLANT_SITE_ID = B.PLANT_SITE_ID 
   AND A.ITEM_ID = B.ITEM_ID 
   AND A.CURRENCY = B.CURRENCY
   AND A.MEASURE = B.MEASURE
   AND A.DOM_EXP = B.DOM_EXP
   AND A.FCST_TYPE = B.FCST_TYPE
   AND A.INCOTERMS = B.INCOTERMS
   AND A.YYYYMMDD = B.YYYYMMDD

--SELECT * FROM #tmpOutput RETURN;
--return (0)

/* tmpPlanData 에 대한 처리들  */
		SELECT @Prod = @Prod + '[' + A.YYYYMMDD + '],'
		FROM (SELECT DISTINCT YYYYMMDD FROM #tmpOutput) A
		IF @Prod = '' 
		BEGIN
			SET @Prod = 'D_99999999'
		END
		ELSE
		BEGIN
			Select @Prod = LEFT(@Prod, LEN(@Prod)-1)
		END

--SELECT DISTINCT YYYYMMDD FROM #tmpOutput
--SELECT @Prod 
--SELECT * FROM #tmpOutput
--return (0)

SELECT  @nsql = '
SELECT  
		DIVISION_ID,
		DIVISION_NAME,
		UPPER_DEPT_ID,
		DEPT_ID	,
		SCM_SITE_ID,
		PLANT_SITE_ID,
		SITE_DESCRIPTION,
		END_CUSTOMER,
		PROJECT_CODE,
		PROJECT_NAME,
		BIZ_TYPE_NAME,
		PROJECT_STATUS,
		ITEM_ID,
		ITEM_CLASS_NAME,
		ITEM_NAME,
		INCOTERMS,
		CURRENCY,
		FCST_TYPE,
		DOM_EXP,
		AUTHORITY_YN,		
		DISPLAY_SEQ,
		MEASURE,				
		' + @Prod + '
From(
	SELECT 
		*
	FROM #tmpOutput
	) T
PIVOT (MAX(PRICE) FOR YYYYMMDD IN (' + @prod + ')
) AS PVT
ORDER BY 		

		DIVISION_ID,
		DEPT_ID,
		END_CUSTOMER,
		SCM_SITE_ID,
		PROJECT_CODE,
		PROJECT_STATUS,
		BIZ_TYPE_NAME,
		ITEM_ID,
		ITEM_CLASS_NAME,
		ITEM_NAME,
		INCOTERMS,
		FCST_TYPE,
		DOM_EXP,
		CURRENCY,
		PLANT_SITE_ID,
		DISPLAY_SEQ, 
		MEASURE		
' 

--PRINT @NSQL 
execute dbo. SP_executesql @NSQL 

IF OBJECT_ID (N'tempdb..#tmpData', N'U') IS NOT NULL 
	DROP TABLE #tmpData
IF OBJECT_ID (N'tempdb..#tmpOutput', N'U') IS NOT NULL 
	DROP TABLE #tmpOutput


END

