
/*
 * Program ID   : UP_FX_GetApprovalAuthRequest_New
 * Description  : 신규사용자 권한 요청 승인 조회[GSCM + FP통합]
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/10/19   jyj		    GSCM + FP통합
 */

CREATE PROCEDURE [dbo].[UP_FX_GetApprovalAuthRequest_New]
	@p_Division_id		NVARCHAR(max) ,
	@p_User_id			NVARCHAR(150) ,
	@p_Dept_Name		NVARCHAR(50) ,
	@p_ReqFromDate		NVARCHAR(12) ,
	@p_ReqToDate		NVARCHAR(12) ,
	@p_ApprFromDate		nvarchar(12) ,
	@p_ApprToDate		nvarchar(12) ,
	@p_ApprResult		nvarchar(max)
AS
BEGIN

    SELECT
          AA.CHK AS  CHK
        , AA.REQUEST_DATE AS  REQUEST_DATE
        , AA.USER_ID  AS  USER_ID 
        , AA.USER_NAME  AS  USER_NAME 
        , AA.DEPT_ID  AS  DEPT_ID 
        , AA.DEPT_NAME_KO  AS  DEPT_NAME_KO 
        , AA.GROUP_ID  AS  GROUP_ID 
        , AA.DIVISION_ID  AS  DIVISION_ID 
        , AA.DIVISION_NAME  AS  DIVISION_NAME 
        , AA.PLANT_ID AS  PLANT_ID
        , AA.PLANT_NAME AS  PLANT_NAME
        , AA.APPROVAL_RESULT  AS  APPROVAL_RESULT 
        , AA.APPROVAL_DATE AS  APPROVAL_DATE
        , AA.SHOP_GROUP_ID AS  SHOP_GROUP_ID
        , AA.INSTANCE_ID AS  INSTANCE_ID
        , AA.FACTORY_ID AS  FACTORY_ID
        , AA.PLAN_GROUP_ID AS  PLAN_GROUP_ID
        , AA.RELEASE_NOTIFIY_TYPE AS  RELEASE_NOTIFIY_TYPE
        , AA.REQUEST_ID AS  REQUEST_ID
        , AA.REQUEST_NAME AS  REQUEST_NAME
        , AA.APPROVAL_USER  AS  APPROVAL_USER 
        , AA.REJECT_REASON  AS  REJECT_REASON 
        , AA.APPROVAL_DATE AS  APPROVAL_DATE
		, AA.CLASS_GROUP_ID AS CLASS_GROUP_ID
		, AA.SEQ  AS SEQ
		, AA.DIVISION_ID  AS  ORG_DIVISION_ID 
		, AA.PLANT_ID AS  ORG_PLANT_ID
		, AA.SHOP_GROUP_ID AS  ORG_SHOP_GROUP_ID
		, AA.INSTANCE_ID AS  ORG_INSTANCE_ID
        , AA.FACTORY_ID AS  ORG_FACTORY_ID
        , AA.PLAN_GROUP_ID AS  ORG_PLAN_GROUP_ID
    FROM (
          SELECT
          	' ' as CHK
          	, a.CREATION_DATE AS REQUEST_DATE  
          	, a.USER_ID    AS USER_ID
          	, b.USER_NAME  AS USER_NAME
          	, b.DEPT_ID    AS DEPT_ID
          	, c.DEPT_NAME_KO  AS DEPT_NAME_KO
          	, a.GROUP_ID  AS GROUP_ID
          	, a.DIVISION_ID As DIVISION_ID
          	, d.DIVISION_NAME  AS DIVISION_NAME
          	, a.PLANT_ID AS PLANT_ID
          	, MAX((CASE WHEN SN.PLANT_NAME IS NULL OR SN.PLANT_NAME = '' THEN V.VENDOR_NAME ELSE SN.PLANT_NAME END )) AS PLANT_NAME
          	, a.APPROVAL_RESULT  AS APPROVAL_RESULT
    
          	, '' AS  SHOP_GROUP_ID
          	, '' AS  INSTANCE_ID
          	, '' AS  FACTORY_ID
          	, '' AS  PLAN_GROUP_ID
          	, '' AS  RELEASE_NOTIFIY_TYPE
          	, a.CREATED_BY AS  REQUEST_ID
          	, B.USER_NAME AS  REQUEST_NAME
          	, a.APPROVAL_USER  AS APPROVAL_USER
          	, a.REJECT_REASON  AS REJECT_REASON
          	, a.LAST_UPDATE_DATE AS APPROVAL_DATE
			, 'SCM' AS CLASS_GROUP_ID
			, '' AS SEQ
          FROM SCM_MST_AUTH_REQUEST a
          INNER JOIN SCM_MST_SSO_USER_INFO (NOLOCK) B ON A.USER_ID=B.USER_ID
          LEFT JOIN SCM_MST_SSO_DEPT_INFO (NOLOCK) C ON B.DEPT_ID = C.DEPT_ID
          LEFT JOIN SCM_MST_DIVISION (NOLOCK) D ON A.DIVISION_ID = D.DIVISION_ID
          LEFT OUTER JOIN  SCM_MST_PLANT_SN SN ON A.DIVISION_ID = SN.DIVISION_ID AND A.PLANT_ID = SN.PLANT_ID
          LEFT OUTER JOIN  SCM_MST_VENDOR V ON V.VENDOR_CODE = A.PLANT_ID
          WHERE 1=1
          	AND a.CREATION_DATE >= @p_ReqFromDate + ' 00:00:00'
          	AND a.CREATION_DATE <= @p_ReqToDate	+ ' 23:59:59'
          	AND (isnull(@p_division_id,   '' ) = '' OR a.DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@p_division_id	 ,',')) )
          	AND (isnull(@p_ApprResult,   '' ) = '' OR a.APPROVAL_RESULT IN ( SELECT token FROM dbo.String_Split(@p_ApprResult	 ,',')) )
          	AND (isnull(@p_Dept_Name, '') = '' OR c.DEPT_NAME_KO like N'%' + @p_Dept_Name + N'%')
          	AND (ISNULL(@p_User_id,'') = '' or b.USER_NAME like N'%' +  @p_User_id + N'%' or a.USER_ID like '%' +  @p_User_id + '%' )
          GROUP BY a.CREATION_DATE
          	, a.USER_ID ,  b.USER_NAME 
          	, b.DEPT_ID , c.DEPT_NAME_KO 
          	, a.GROUP_ID 
          	, a.DIVISION_ID , d.DIVISION_NAME ,a.PLANT_ID
          	, a.APPROVAL_RESULT , a.CREATED_BY, B.USER_NAME
          	, a.APPROVAL_USER 
          	, a.REJECT_REASON 
          	, a.LAST_UPDATE_DATE
          --ORDER BY A.CREATION_DATE asc ,  A.DIVISION_ID asc, A.USER_ID asc
    
          UNION
          
          SELECT 
              ' ' AS CHK
              , F.REQUEST_TIME AS REQUEST_DATE
              , F.USER_ID  AS  USER_ID
              , (SELECT Top 1 USERNAME FROM  TB_FX_User with(nolock) WHERE USERID= F.USER_ID) AS USER_NAME
              , B.DEPT_ID AS DEPT_ID
              , C.DEPT_NAME_KO AS DEPT_NAME_KO
              , F.MENU_AUTHORITY_ID AS GROUP_ID
              , F.DIVISION_ID  AS DIVISION_ID
              , ( SELECT TOP 1 DIVISION_NAME  FROM  SCM_MST_DIVISION with(nolock) WHERE DIVISION_ID = F.DIVISION_ID ) AS DIVISION_NAME
              , F.PLANT_ID  AS PLANT_ID  
              , ( SELECT TOP 1 PLANT_NAME FROM SCM_MST_PLANT_SN WHERE DIVISION_ID = F.DIVISION_ID AND PLANT_ID = F.PLANT_ID ) AS PLANT_NAME
              , ( CASE WHEN F.APPROVAL_FLAG = 'R' THEN 'REQUESTING' WHEN F.APPROVAL_FLAG = 'Y' THEN 'APPROVED' WHEN F.APPROVAL_FLAG = 'N' THEN 'REJECT' ELSE F.APPROVAL_FLAG END ) AS APPROVAL_RESULT 
              , F.SHOP_GROUP_ID  AS SHOP_GROUP_ID
              , F.INSTANCE_ID    AS INSTANCE_ID
              , F.FACTORY_ID     AS FACTORY_ID
              , F.PLAN_GROUP_ID  AS PLAN_GROUP_ID
              , F.RELEASE_NOTIFIY_TYPE AS RELEASE_NOTIFIY_TYPE
              , F.REQUEST_ID AS REQUEST_ID
              , ( SELECT Top 1 USERNAME FROM  TB_FX_User with(nolock) WHERE USERID= F.REQUEST_ID) AS REQUEST_NAME
              , F.APPROVAL_ID  AS APPROVAL_USER 
              , F.DESCRIPTION  AS REJECT_REASON
              , F.APPROVAL_TIME  AS APPROVAL_DATE
			  , 'FP' AS CLASS_GROUP_ID
			  , F._SEQ AS SEQ
          FROM LGCE_FP_TR.dbo.FP_AUTH_REQUEST_INFO_M  F WITH(nolock) 
           INNER JOIN SCM_MST_SSO_USER_INFO B WITH(NOLOCK) ON F.USER_ID = B.USER_ID
           LEFT JOIN SCM_MST_SSO_DEPT_INFO C WITH(NOLOCK) ON B.DEPT_ID  = C.DEPT_ID
          WHERE  1=1   
           AND  (isnull(@p_division_id,   '' ) = '' OR F.DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@p_division_id	 ,',')) )
           AND F.REQUEST_TIME >= @p_ReqFromDate + ' 00:00:00'
           AND F.REQUEST_TIME <= @p_ReqToDate + ' 23:59:59'
	       AND  F.APPROVAL_FLAG LIKE ( CASE WHEN @p_ApprResult  = 'REQUESTING' THEN 'R%'
                                            WHEN @p_ApprResult  = 'APPROVED' THEN  'Y%'
      			                            WHEN @p_ApprResult  = 'REJECT' THEN  'N%' 
			                           ELSE  '%%' END
			) 
           AND ( (ISNULL( @p_User_id,'') = ''  or F.USER_ID like '%' +  @p_User_id + '%' ) 
               OR F.USER_ID LIKE ( SELECT TOP 1 userid FROM TB_FX_User WHERE username like '%' +  @p_User_id + '%' ) )
     ) AA
     ORDER BY AA.CLASS_GROUP_ID DESC, AA.REQUEST_DATE asc ,  AA.DIVISION_ID asc, AA.PLANT_ID ASC, AA.INSTANCE_ID ASC , AA.FACTORY_ID ASC, AA.USER_ID asc;

END
