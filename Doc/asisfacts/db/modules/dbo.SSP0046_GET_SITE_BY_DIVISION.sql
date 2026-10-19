

/*
 * Program ID   : SSP0046_GET_SITE_BY_DIVISION
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/11/15  SongDH         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/01/09  SongDH         조건 추가 @p_dept_name_ko, @p_end_customer
 *
 */

CREATE PROCEDURE [dbo].[SSP0046_GET_SITE_BY_DIVISION]
    @p_division_id  NVARCHAR(MAX),
    @p_dept_id      NVARCHAR(MAX),
    @p_end_customer NVARCHAR(MAX)
AS
BEGIN
	
    SELECT A.SCM_SITE_ID      AS CODE
         , A.SITE_DESCRIPTION AS NAME
    FROM   [dbo].[SCM_MST_SITE]          A  WITH(NOLOCK)
    WHERE  1 = 1
    AND    A.SITE_TYPE = 'SALES'
    AND    A.VALID_YN  = 'Y'
    AND    CASE WHEN @p_division_id = 'ALL' THEN 'ALL'
                ELSE A.DIVISION_ID
	       END  IN (SELECT t.c.value('.', 'NVARCHAR(4000)')
                    FROM   (SELECT x = CAST('<t>' + REPLACE(@p_division_id, ',', '</t><t>') + '</t>' AS xml)) b
                    CROSS APPLY x.nodes('/t') t(c)
	               )
    AND    CASE WHEN @p_dept_id = 'ALL' THEN 'ALL'
                ELSE A.DEPT_ID
	       END  IN (SELECT t.c.value('.', 'NVARCHAR(4000)')
                    FROM   (SELECT x = CAST('<t>' + REPLACE(@p_dept_id, ',', '</t><t>') + '</t>' AS xml)) b
                    CROSS APPLY x.nodes('/t') t(c)
	               )
	 AND    CASE WHEN @p_end_customer = 'ALL' THEN 'ALL'
                ELSE A.END_CUSTOMER
	       END  IN (SELECT t.c.value('.', 'NVARCHAR(4000)')
                    FROM   (SELECT x = CAST('<t>' + REPLACE(@p_end_customer, ',', '</t><t>') + '</t>' AS xml)) b
                    CROSS APPLY x.nodes('/t') t(c)
	               )
	ORDER BY A.SITE_DESCRIPTION
	;

END

