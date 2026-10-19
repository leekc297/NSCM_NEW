
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


/****************************************************************************************************/
/* Program ID  : SSP0046_GET_ITEM_BY_DIVISION_POPUPEx                                                 */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2019/09/16  hwi1993		DMF0002_GET_ITEM_BY_DIVISION_POPUPEx Copy 해서 추가함. Pack/Cell 조건 추가 */
/* 2022/05/10  hwi1993		GM JV 적용 */
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[SSP0046_GET_ITEM_BY_DIVISION_POPUPEx]  
  @p_division_id   NVARCHAR(MAX),
  @p_dept_id        NVARCHAR(MAX),	--Department
  @p_end_customer   NVARCHAR(MAX),	--Endcustomer
  @p_project_code  NVARCHAR(MAX),
  @p_scm_site_id   NVARCHAR(MAX),
  @p_item_id       NVARCHAR(MAX),
  @p_biz_type		nvarchar(max)
AS
BEGIN
	
  SET NOCOUNT ON;
    
  SELECT DISTINCT I.DIVISION_ID
     , I.DIVISION_ID  AS DIVISION_NAME
     , D.PROJECT_CODE
     , A.PROJECT_NAME
     , S.SCM_SITE_ID
     , S.SITE_DESCRIPTION
     , D.ITEM_ID	 
	 , T.ITEM_NAME
	 , T.ITEM_TYPE
	 , ITEM_TYPE_CODE.NAME AS ITEM_TYPE_NAME
	 , T.NICK_NAME
	 , T.ITEM_CLASS_NAME
	 , TEAM.DEPT_ID
	 , TEAM.DEPT_NAME_KO
	 , C.END_CUSTOMER
	 , D.CURRENCY
	 , D.PROJECT_CODE AS END_CUSTOMER40
  FROM   ( SELECT * FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK) WHERE VALID_YN='Y') AS  I 
       LEFT JOIN (SELECT * FROM [dbo].[SCM_MST_SITE_ITEM] WITH(NOLOCK) WHERE VALID_YN='Y') AS D 
	   ON I.DIVISION_ID  = D.DIVISION_ID
       LEFT JOIN (SELECT * FROM [dbo].[SCM_MST_PROJECT] WITH(NOLOCK)) AS A 
	   ON D.PROJECT_CODE = A.PROJECT_CODE
       LEFT JOIN (SELECT * FROM [dbo].[SCM_MST_SITE] WITH(NOLOCK) WHERE VALID_YN='Y') S 
	   ON D.SCM_SITE_ID  = S.SCM_SITE_ID   
	   --LEFT JOIN [dbo].[SCM_MST_ITEM_SN]     T WITH(NOLOCK)
	   LEFT JOIN [dbo].DM_MST_ITEM_SINGLE_V     T WITH(NOLOCK)
	   ON I.DIVISION_ID  = T.DIVISION_ID AND    D.ITEM_ID      = T.ITEM_ID
	   LEFT JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, DEPT_ID, END_CUSTOMER FROM SCM_MST_SITE WITH(NOLOCK) WHERE VALID_YN = 'Y') AS C 
	   ON I.DIVISION_ID = C.DIVISION_ID AND D.SCM_SITE_ID = C.SCM_SITE_ID
	   LEFT JOIN (SELECT * FROM SCM_MST_SSO_DEPT_INFO WITH(NOLOCK) WHERE VALID_YN = 'Y')  AS TEAM			       
	   ON C.DEPT_ID = TEAM.DEPT_ID
	   LEFT JOIN (
					 SELECT  SEGMENT1 AS CODE, SEGMENT2 AS NAME
					 FROM [dbo].SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
					WHERE
					VALID_YN ='Y' 
					AND LOOKUP_TYPE = 'ITEM_TYPE_CODE'
	   )  AS ITEM_TYPE_CODE			       
	   ON T.ITEM_TYPE = ITEM_TYPE_CODE.CODE
	   INNER JOIN SCM_MST_ITEM_SN U ON I.DIVISION_ID = U.DIVISION_ID AND D.ITEM_ID = U.ITEM_ID AND U.SCP_OPERATION_GROUP = @p_biz_type /* AND S.SCM_SITE_ID = U.SITE_ID  */
	   
WHERE   I.DIVISION_ID LIKE '81%'   -- DIVISION 이 자동차인 경우에는 SITE-ITEM에 연결된것 만 조회 
  AND   SITE_TYPE = 'SALES'
  AND   CASE WHEN @p_division_id = 'ALL' THEN 'ALL'
		   		 ELSE I.DIVISION_ID			
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_division_id,',') as P Where 
					(CASE WHEN @p_division_id = 'ALL' THEN 'ALL' ELSE I.DIVISION_ID END) = P.data
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
		   		 ELSE S.SCM_SITE_ID			
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_scm_site_id,',') as P Where 
					(CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL' ELSE S.SCM_SITE_ID END) = P.data
	               )
	 AND (
		 Exists (Select * from dbo.UF_FX_String_Split (@p_project_code,',') as P Where D.PROJECT_CODE LIKE P.token +'%')
	     OR
		 Exists (Select * from dbo.UF_FX_String_Split (@p_project_code,',') as P Where A.PROJECT_NAME LIKE P.token +'%')
		 )
	 AND (
		 Exists (Select * from dbo.UF_FX_String_Split (@p_item_id,',') as P Where D.ITEM_ID LIKE P.token +'%')
	  --   OR
		 --Exists (Select * from dbo.UF_FX_String_Split (@p_item_id,',') as P Where T.ITEM_NAME LIKE P.token +'%')
		  OR
		 Exists (Select * from dbo.UF_FX_String_Split (@p_item_id,',') as P Where T.nick_name LIKE P.token +'%')
		 )	 -- 20181205 nick name 조회요청으로 변경

UNION 

  SELECT DISTINCT I.DIVISION_ID
     , I.DIVISION_ID  AS DIVISION_NAME
     , D.PROJECT_CODE
     , A.PROJECT_NAME
     , S.SCM_SITE_ID
     , S.SITE_DESCRIPTION
     , T.ITEM_ID	 
	 , T.ITEM_NAME
	 , T.ITEM_TYPE
	 , ITEM_TYPE_CODE.NAME AS ITEM_TYPE_NAME
	 , T.NICK_NAME
	 , T.ITEM_CLASS_NAME
	 , TEAM.DEPT_ID
	 , TEAM.DEPT_NAME_KO
	 , C.END_CUSTOMER
	 , D.CURRENCY
	 , D.PROJECT_CODE AS END_CUSTOMER40
  FROM   (SELECT * FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK) WHERE VALID_YN='Y') AS  I 
       LEFT JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, CURRENCY FROM [dbo].[SCM_MST_SITE_ITEM] WITH(NOLOCK) WHERE VALID_YN='Y') AS D 
    ON I.DIVISION_ID  = D.DIVISION_ID
       LEFT OUTER JOIN (SELECT * FROM [dbo].[SCM_MST_PROJECT] WITH(NOLOCK)) AS A 
    ON D.PROJECT_CODE = A.PROJECT_CODE
       LEFT JOIN (SELECT * FROM [dbo].[SCM_MST_SITE] WITH(NOLOCK) WHERE VALID_YN='Y') S 
    ON D.SCM_SITE_ID  = S.SCM_SITE_ID

    LEFT OUTER JOIN [dbo].DM_MST_ITEM_SINGLE_V     T WITH(NOLOCK)

    ON I.DIVISION_ID  = T.DIVISION_ID AND T.ITEM_TYPE not in ( 'H', 'R')  AND T.ITEM_ID LIKE 'E%' -- 자재 반재품 는 제외
    LEFT JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, DEPT_ID, END_CUSTOMER FROM SCM_MST_SITE WITH(NOLOCK) WHERE VALID_YN = 'Y') AS C 
    ON I.DIVISION_ID = C.DIVISION_ID AND D.SCM_SITE_ID = C.SCM_SITE_ID
    LEFT JOIN (SELECT * FROM SCM_MST_SSO_DEPT_INFO WITH(NOLOCK) WHERE VALID_YN = 'Y')  AS TEAM          
    ON C.DEPT_ID = TEAM.DEPT_ID
    LEFT JOIN (
     SELECT  SEGMENT1 AS CODE, SEGMENT2 AS NAME
     FROM [dbo].SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
     WHERE
     VALID_YN ='Y' 
     AND LOOKUP_TYPE = 'ITEM_TYPE_CODE'
    )  AS ITEM_TYPE_CODE          
    ON T.ITEM_TYPE = ITEM_TYPE_CODE.CODE
	INNER JOIN SCM_MST_ITEM_SN U ON I.DIVISION_ID = U.DIVISION_ID AND T.ITEM_ID = U.ITEM_ID AND U.SCP_OPERATION_GROUP = @p_biz_type	   /* AND S.SCM_SITE_ID = U.SITE_ID  */
WHERE   I.DIVISION_ID = '82'   -- DIVISION 이 자동차인 경우에는 SITE-ITEM에 연결된것 만 조회 
  AND   SITE_TYPE = 'SALES'
--  AND   D.PROJECT_CODE = 'DC-17-001'


  AND   CASE WHEN @p_division_id = 'ALL' THEN 'ALL'
		   		 ELSE I.DIVISION_ID			
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_division_id,',') as P Where 
					(CASE WHEN @p_division_id = 'ALL' THEN 'ALL' ELSE I.DIVISION_ID END) = P.data
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
		   		 ELSE S.SCM_SITE_ID			
			END IN (
					Select * from dbo.UF_FX_String_SplitForIN (@p_scm_site_id,',') as P Where 
					(CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL' ELSE S.SCM_SITE_ID END) = P.data
	               )
	 AND (
		 Exists (Select * from dbo.UF_FX_String_Split (@p_project_code,',') as P Where D.PROJECT_CODE LIKE P.token +'%')
	     OR
		 Exists (Select * from dbo.UF_FX_String_Split (@p_project_code,',') as P Where A.PROJECT_NAME LIKE P.token +'%')
		 )
	 AND (
		 Exists (Select * from dbo.UF_FX_String_Split (@p_item_id,',') as P Where T.ITEM_ID LIKE P.token +'%')
	  --   OR
		 --Exists (Select * from dbo.UF_FX_String_Split (@p_item_id,',') as P Where T.ITEM_NAME LIKE P.token +'%')
		  OR
		 Exists (Select * from dbo.UF_FX_String_Split (@p_item_id,',') as P Where T.nick_name LIKE P.token +'%')
		 )	 -- 20181205 nick name 조회요청으로 변경

  ORDER BY I.DIVISION_ID
         , D.PROJECT_CODE
         --, A.PROJECT_NAME
         , S.SCM_SITE_ID
         , S.SITE_DESCRIPTION
         , D.ITEM_ID
	     , T.ITEM_NAME

END
