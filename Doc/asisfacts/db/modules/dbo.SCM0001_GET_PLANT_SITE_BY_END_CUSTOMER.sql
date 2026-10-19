
/*
 * Program ID   : SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/01/26  SongDH         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */

CREATE PROCEDURE [dbo].[SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER]
    @p_division_id  NVARCHAR(MAX),
    @p_dept_id      NVARCHAR(MAX),
    @p_end_customer NVARCHAR(MAX)
AS
BEGIN
	
    SELECT A.SCM_SITE_ID      AS CODE
         , A.SITE_DESCRIPTION AS NAME
    FROM   [dbo].[SCM_MST_SITE]          A  WITH(NOLOCK)
    WHERE  1 = 1
    AND    A.SITE_TYPE = 'PLANT'
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
	;

END


