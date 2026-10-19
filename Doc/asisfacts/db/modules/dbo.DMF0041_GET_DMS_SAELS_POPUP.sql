/****************************************************************************************************/
/* Program ID  : [DMF0041_GET_DMS_SAELS_POPUP]                                            */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2019/02/25  JYE			Initial Release - DMS Sales 팝업 데이터 조회        */
/*                                      */
/****************************************************************************************************/

CREATE PROCEDURE [dbo].[DMF0041_GET_DMS_SAELS_POPUP]
	@p_division_id   NVARCHAR(MAX),  
	@p_dms_sales       NVARCHAR(MAX),
	@p_search       NVARCHAR(MAX)
AS
BEGIN
	
    SET NOCOUNT ON;

	-- 왼쪽 스프레드 데이터
	SELECT DIVISION_ID, DMS_SALES
		, ROW_NUMBER() OVER (ORDER BY DMS_SALES) * 100 AS SORT_ORDER_NO
	FROM (
		SELECT DISTINCT DIVISION_ID, ATTRIBUTE1 AS DMS_SALES
		FROM SCM_MST_SITE_ITEM AS A WITH(NOLOCK)
		INNER JOIN ( SELECT '%'+token+'%' tst FROM dbo.String_Split(@p_search,',') ) b
			ON CASE WHEN @p_search = '' THEN @p_search ELSE A.ATTRIBUTE1  END LIKE  B.TST
		WHERE
		DIVISION_ID = @p_division_id
		AND ATTRIBUTE1 <> ''
		AND ATTRIBUTE1 NOT IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_dms_sales,',') )
		UNION
		SELECT SEGMENT1, SEGMENT2 AS DMS_SALES
		FROM  [SCM_ADM_LOOKUP_MASTER_DETAIL] AS A WITH(NOLOCK)
		INNER JOIN ( SELECT '%'+token+'%' tst FROM dbo.String_Split(@p_search,',') ) b
			ON CASE WHEN @p_search = '' THEN @p_search ELSE A.ATTRIBUTE1  END LIKE  B.TST
		where  LOOKUP_TYPE = 'END_CUSTOMER'
		AND SEGMENT2 <> '-'
		AND SEGMENT1  = CASE WHEN @p_division_id = '' THEN SEGMENT1 ELSE @p_division_id END
		AND SEGMENT2 NOT IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_dms_sales,',') )
	) MA
	ORDER BY DMS_SALES

	-- 오른쪽 스프레드 데이터
	SELECT DISTINCT DIVISION_ID, ATTRIBUTE1 AS DMS_SALES
		, (SELECT NR FROM dbo.String_Split(@p_dms_sales,',') WHERE TOKEN = ATTRIBUTE1) AS SORT_ORDER_NO
	FROM SCM_MST_SITE_ITEM WITH(NOLOCK)
	WHERE
	DIVISION_ID = @p_division_id
	AND ATTRIBUTE1 <> ''
	AND ATTRIBUTE1 IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_dms_sales,',') )
	UNION
	SELECT SEGMENT1, SEGMENT2 AS DMS_SALES
		, (SELECT NR FROM dbo.String_Split(@p_dms_sales,',') WHERE TOKEN = SEGMENT2) AS SORT_ORDER_NO
	FROM  [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
	where  LOOKUP_TYPE = 'END_CUSTOMER'
	AND SEGMENT2 <> '-'
	AND SEGMENT1  = CASE WHEN @p_division_id = '' THEN SEGMENT1 ELSE @p_division_id END
	AND SEGMENT2 IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_dms_sales,',') )
	ORDER BY ATTRIBUTE1
END
