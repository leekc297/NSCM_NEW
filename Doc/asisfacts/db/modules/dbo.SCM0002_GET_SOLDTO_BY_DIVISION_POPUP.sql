
/*
 * Program ID   : SCM0002_GET_SOLDTO_BY_DIVISION_POPUP
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/01/25   songdh         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */

CREATE PROCEDURE [dbo].[SCM0002_GET_SOLDTO_BY_DIVISION_POPUP]  
  @p_division_id  NVARCHAR(1000),
  @p_soldto_code  NVARCHAR(1000)
AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT DISTINCT
	       C.DIVISION_ID
		 , D.DIVISION_NAME
		 , C.SOLDTO_CODE
		 , C.SOLDTO_DESCRIPTION		  
	FROM   [dbo].[SCM_MST_CUSTOMER]  C WITH(NOLOCK)
		 , [dbo].[SCM_MST_DIVISION]  D WITH(NOLOCK)
	WHERE  C.DIVISION_ID = D.DIVISION_ID
	AND    C.VALID_YN = 'Y'
	AND    CASE WHEN @p_division_id = 'ALL' THEN 'ALL'
	            ELSE C.DIVISION_ID
		   END  IN (SELECT t.c.value('.', 'NVARCHAR(4000)')
		            FROM   (SELECT x = CAST('<t>' + REPLACE(@p_division_id, ',', '</t><t>') + '</t>' AS xml)) b
					CROSS APPLY x.nodes('/t') t(c)
				   )	
	AND    (   C.SOLDTO_CODE        LIKE '%'+ @p_soldto_code + '%'
		    OR C.SOLDTO_DESCRIPTION LIKE '%'+ @p_soldto_code + '%'
		   )
    ;

END
