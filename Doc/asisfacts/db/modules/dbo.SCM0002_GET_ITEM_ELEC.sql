
/*
* Program ID   : SCM0002_GET_ITEM_ELEC
* Description  : 전극 모델목록 조회
* Program History
*
*===========================================================================================================================================
* Date          In Charge       Description
*===========================================================================================================================================
* 2023.04.24    chaan           PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - V1.1.1   Initial Release
*/


--CREATE PROCEDURE [dbo].[SCM0002_GET_ITEM_ELEC]
CREATE PROCEDURE [dbo].[SCM0002_GET_ITEM_ELEC]
    @p_division_id   NVARCHAR(MAX),
    @p_company_id    NVARCHAR(MAX),
    @p_item_id       NVARCHAR(MAX)
AS
BEGIN
    --DECLARE @p_division_id   NVARCHAR(MAX)       = N'ALL';
    --DECLARE @p_company_id    NVARCHAR(MAX)       = N'ALL';
    --DECLARE @p_item_id       NVARCHAR(MAX)       = N'';


    SET NOCOUNT ON;

    SELECT DISTINCT
		      D.DIVISION_ID
		    , D.DIVISION_NAME
		    , ISNULL(P.PROJECT_CODE,'-') AS PROJECT_CODE
		    , ISNULL(P.PROJECT_NAME,'-') AS PROJECT_NAME
		    , S.COMPANY_ID
		    , I.ITEM_ID
		    , T.ITEM_NAME
		    , T.NICK_NAME
		    , T.ITEM_CLASS_NAME
    FROM	dbo.SCM_MST_SITE_ITEM I WITH(NOLOCK)
		    JOIN SCM_MST_DIVISION D WITH(NOLOCK) ON
				    I.DIVISION_ID  = D.DIVISION_ID
		    JOIN SCM_MST_SITE S WITH(NOLOCK) ON
				    I.DIVISION_ID  = S.DIVISION_ID
			    AND I.SCM_SITE_ID  = S.SCM_SITE_ID
		    JOIN (
				    SELECT	*
				    FROM    SCM_MST_ITEM_SN A (NOLOCK)
				    WHERE	1=1
					    AND SCP_OPERATION_GROUP = 'E'
					    AND CASE
							    WHEN FLOW_ID IS NULL THEN SCP_FLOW_ID
							    ELSE FLOW_ID
						    END LIKE 'E2000%'
		         ) T ON
				    I.DIVISION_ID  = T.DIVISION_ID
			    AND I.ITEM_ID      = T.ITEM_ID
		    LEFT OUTER JOIN SCM_MST_PROJECT P WITH(NOLOCK) ON
                    I.DIVISION_ID  = P.DIVISION_ID
                AND I.PROJECT_CODE = P.PROJECT_CODE
    WHERE	1=1
	    AND CASE
			    WHEN @p_division_id = 'ALL' THEN 'ALL'
			    ELSE I.DIVISION_ID
		    END IN (SELECT token FROM dbo.String_Split(@p_division_id, ','))
	    AND CASE
			    WHEN @p_company_id = 'ALL' THEN 'ALL'
			    ELSE S.COMPANY_ID
		    END IN (SELECT token FROM dbo.String_Split(@p_company_id, ','))
	    AND (   I.ITEM_ID   LIKE '%' + @p_item_id + '%'
		     OR T.ITEM_NAME LIKE '%' + @p_item_id + '%'
		     OR T.NICK_NAME LIKE '%' + @p_item_id + '%'
             OR (   I.ITEM_ID   IN (SELECT token FROM dbo.String_Split(@p_item_id, ','))
                 OR T.ITEM_NAME IN (SELECT token FROM dbo.String_Split(@p_item_id, ','))
                 OR T.NICK_NAME IN (SELECT token FROM dbo.String_Split(@p_item_id, ','))
                )
            )
    ORDER BY	  D.DIVISION_ID
		        , D.DIVISION_NAME
		        , ISNULL(P.PROJECT_CODE,'-')
		        , ISNULL(P.PROJECT_NAME,'-')
		        , S.COMPANY_ID
		        , I.ITEM_ID
		        , T.ITEM_NAME
		        , T.NICK_NAME
		        , T.ITEM_CLASS_NAME

END
