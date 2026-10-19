
/*
 * Program ID   : SCM0001_GET_TO_SITE
 * Description  : To Site 정보 Combobox 생성
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/12/26   junheejeen   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */

CREATE PROCEDURE [dbo].[SCM0001_GET_TO_SITE_BY_DIVISION]
    @p_division_id NVARCHAR(18)
AS
BEGIN
	
	SET NOCOUNT ON;
  
	SELECT SCM_SITE_ID        AS CODE
		 , SITE_DESCRIPTION   AS NAME
	FROM [dbo].[SCM_MST_SITE] AS A WITH(NOLOCK)	
	WHERE   A.VALID_YN  = 'Y'
	AND    CASE WHEN @p_division_id = 'ALL' THEN 'ALL'
                ELSE A.DIVISION_ID
	       END  IN (SELECT t.c.value('.', 'NVARCHAR(4000)')
                    FROM   (SELECT x = CAST('<t>' + REPLACE(@p_division_id, ',', '</t><t>') + '</t>' AS xml)) b
                    CROSS APPLY x.nodes('/t') t(c)
	               )
	;

	;

END


