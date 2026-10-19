
/*
 * Program ID   : SCM0002_GET_CUSTOMER_BY_DIVISION_POPUP
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/12/04   songdh         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 20180604 주석제거 modified by khsong
 */

CREATE PROCEDURE [dbo].[SCM0002_GET_CUSTOMER_BY_DIVISION_POPUP]  
  @p_division_id  NVARCHAR(1000),
  @p_soldto_code  NVARCHAR(1000),
  @p_shipto_code  NVARCHAR(1000)
AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT C.DIVISION_ID
		 , D.DIVISION_NAME
		 , C.SOLDTO_CODE
		 , C.SOLDTO_DESCRIPTION
		 , C.SHIPTO_CODE
		 , C.SHIPTO_DESCRIPTION		
		 , C.SHIPTO_REGION_NAME 
		 , C.SHIPTO_CITY_NAME
	FROM   [dbo].[SCM_MST_CUSTOMER]  C WITH(NOLOCK)  
		 , [dbo].[SCM_MST_DIVISION]  D WITH(NOLOCK)
	WHERE  C.DIVISION_ID = D.DIVISION_ID
	AND    C.VALID_YN = 'Y'
	AND    CASE WHEN @p_division_id = 'ALL' THEN 'ALL'
	            ELSE C.DIVISION_ID
		   END  IN ( 
					SELECT t.c.value('.', 'NVARCHAR(4000)')
		            FROM   (SELECT x = CAST('<t>' + REPLACE(@p_division_id, ',', '</t><t>') + '</t>' AS xml)) b
					CROSS APPLY x.nodes('/t') t(c)
				   )
	AND    (   C.SHIPTO_CODE        LIKE '%'+ @p_shipto_code + '%'
		    OR C.SHIPTO_DESCRIPTION LIKE '%'+ @p_shipto_code + '%'
		   ) 
    
	AND    (   C.SOLDTO_CODE        LIKE '%'+ @p_soldto_code + '%'
		    OR C.SOLDTO_DESCRIPTION LIKE '%'+ @p_soldto_code + '%'
		   )
	AND NOT EXISTS (SELECT *
	                FROM   [dbo].[SCM_MST_SITE_CUSTOMER] SC WITH(NOLOCK)
                          ,dbo.scm_mst_site b  -- added by ytchoi 20180730 plant와 구분 하기 위해서 
					WHERE  1 = 1
					AND    SC.SOLDTO_CODE = C.SOLDTO_CODE  -- 20180604 주석제거 modified by khsong
					AND    SC.SHIPTO_CODE = C.SHIPTO_CODE
					AND    sc.division_id = c.DIVISION_ID
					and    sc.valid_YN = 'Y'

					-- added by ytchoi 20180730 plant와 구분 하기 위해서 
					and    sc.division_id = b.DIVISION_ID
					and    sc.scm_site_id = b.scm_site_id
					and    b.site_type = 'SALES'

	               )
    ;

END

