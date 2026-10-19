/****************************************************************************************************/
/* Program ID  : [DMF0041_GET_APPLICATION_POPUP]                                            */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2019/07/22  JYE			Initial Release - Application 팝업 데이터 조회        */
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[DMF0041_GET_APPLICATION_POPUP]
	@p_division_id   NVARCHAR(MAX),  
	@p_app       NVARCHAR(MAX),
	@p_search       NVARCHAR(MAX)
AS
BEGIN
	
    SET NOCOUNT ON;
	-- 왼쪽 스프레드 데이터
	SELECT SEGMENT1 AS APPLICATION,
			SEGMENT2 AS NAME,
			ROW_NUMBER() OVER (ORDER BY SEGMENT1) * 100 AS SORT_ORDER_NO
	FROM SCM_ADM_LOOKUP_MASTER_DETAIL AS DETAIL
	INNER JOIN ( SELECT '%'+token+'%' tst FROM dbo.String_Split(@p_search,',') ) b
			ON CASE WHEN @p_search = '' THEN @p_search ELSE DETAIL.SEGMENT2  END LIKE  B.TST
	WHERE  (LOOKUP_TYPE = 'APPLICATION')
		AND SEGMENT2 NOT IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_app,',') )
	ORDER BY  SEGMENT1

	-- 오른쪽 스프레드 데이터
	SELECT SEGMENT1 AS APPLICATION,
			SEGMENT2 AS NAME,
			ROW_NUMBER() OVER (ORDER BY SEGMENT1) * 100 AS SORT_ORDER_NO
	FROM SCM_ADM_LOOKUP_MASTER_DETAIL AS DETAIL
	INNER JOIN ( SELECT '%'+token+'%' tst FROM dbo.String_Split(@p_search,',') ) b
			ON CASE WHEN @p_search = '' THEN @p_search ELSE DETAIL.SEGMENT2  END LIKE  B.TST
	WHERE  (LOOKUP_TYPE = 'APPLICATION')
		AND SEGMENT2 IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@p_app,',') )
	ORDER BY  SEGMENT1
END
