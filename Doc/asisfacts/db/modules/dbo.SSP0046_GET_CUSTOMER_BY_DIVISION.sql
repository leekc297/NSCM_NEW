

/*
 * Program ID   : SSP0046_GET_CUSTOMER_BY_DIVISION
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/12/18  SongDH         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/01/09  SongDH         검색 조건 수정   @p_scm_site_id -> @p_dept_name_ko
 *
 */

CREATE PROCEDURE [dbo].[SSP0046_GET_CUSTOMER_BY_DIVISION]
  @p_division_id  NVARCHAR(MAX),
  @p_dept_id      NVARCHAR(MAX)
AS
BEGIN
	
  SELECT DISTINCT
         A.END_CUSTOMER AS CODE
       , A.END_CUSTOMER AS NAME
  FROM   [dbo].[SCM_MST_SITE]          A WITH(NOLOCK)
       , [dbo].[SCM_MST_SSO_DEPT_INFO] T WITH(NOLOCK)
  WHERE  1 = 1  
  AND    A.DEPT_ID = T.DEPT_ID
  AND    A.VALID_YN  = 'Y'
  AND    A.END_CUSTOMER <> ''
  AND    CASE WHEN @p_division_id = 'ALL' THEN 'ALL'
              ELSE A.DIVISION_ID
	     END  IN (SELECT t.c.value('.', 'NVARCHAR(4000)')
                  FROM   (SELECT x = CAST('<t>' + REPLACE(@p_division_id, ',', '</t><t>') + '</t>' AS xml)) b
                  CROSS APPLY x.nodes('/t') t(c)
	             )
  AND    CASE WHEN @p_dept_id = 'ALL' THEN 'ALL'
              ELSE T.DEPT_ID
	     END  IN (SELECT t.c.value('.', 'NVARCHAR(4000)')
                  FROM   (SELECT x = CAST('<t>' + REPLACE(@p_dept_id, ',', '</t><t>') + '</t>' AS xml)) b
                  CROSS APPLY x.nodes('/t') t(c)
	             )
  ;

END

