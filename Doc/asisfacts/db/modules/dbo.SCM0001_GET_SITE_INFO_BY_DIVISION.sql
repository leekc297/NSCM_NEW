
/*
 * Program ID   : SCM0001_GET_SITE_BY_DIVISION
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/11/15  SongDH         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */

CREATE PROCEDURE [dbo].[SCM0001_GET_SITE_INFO_BY_DIVISION]
  @p_division_id NVARCHAR(1000),
  @p_scm_site_id NVARCHAR(1000)
AS
BEGIN
	
  SELECT A.DIVISION_ID
       , A.SCM_SITE_ID
       , A.CITY
       , A.COUNTRY
	   , A.PLANT_ID
	   , A.OPERATION_GROUP
	   , D.DEPT_ID
	   , D.DEPT_NAME_KO
	   , T.DEPT_ID       AS TEAM_ID
	   , T.DEPT_NAME_KO  AS TEAM_NAME_KO
	   , SC.SOLDTO_CODE  
	   , C.SOLDTO_DESCRIPTION 
	   , SC.SHIPTO_CODE   
	   , C.SHIPTO_DESCRIPTION 	   
	   , A.VMI_YN
	   , A.VALID_YN
	   , A.NEW_YN
	   , A.SITE_HRCY_ID
	   , A.OSP_YN
	   , A.SHIP_FROZEN
	   , A.PROD_FROZEN
	   , A.END_CUSTOMER
	   , A.FP_PLAN_PERIOD
       , A.SCM_SITE_ID AS NAME
  FROM   [dbo].[SCM_MST_SITE]             A  WITH(NOLOCK)
         LEFT JOIN SCM_MST_SSO_DEPT_INFO  T  WITH(NOLOCK)
	       ON A.DEPT_ID = T.DEPT_ID
	     LEFT JOIN SCM_MST_SSO_DEPT_INFO  D  WITH(NOLOCK)
	       ON T.UPPER_DEPT_ID = D.DEPT_ID
	    LEFT OUTER JOIN SCM_MST_SITE_CUSTOMER AS SC  WITH(NOLOCK)
	       ON (    A.DIVISION_ID = SC.DIVISION_ID
	           AND A.SCM_SITE_ID = SC.SCM_SITE_ID
	           AND SC.REP_YN = 'Y' )
		LEFT JOIN SCM_MST_CUSTOMER  AS C  WITH(NOLOCK)
		  ON (    SC.DIVISION_ID = C.DIVISION_ID
		      AND SC.SOLDTO_CODE = C.SOLDTO_CODE
		      AND SC.SHIPTO_CODE = C.SHIPTO_CODE
			 )
  WHERE  1 = 1
  AND    A.SITE_TYPE     = 'SALES'
  AND    CASE WHEN @p_division_id = 'ALL' THEN @p_division_id			
                        ELSE A.DIVISION_ID
 	               END  IN ( SELECT token FROM dbo.String_Split(@p_division_id,',') )
  AND    CASE WHEN @p_scm_site_id = 'ALL' THEN @p_division_id			
                        ELSE A.SCM_SITE_ID
 	               END  IN ( SELECT token FROM dbo.String_Split(@p_scm_site_id,',') )
  --AND    CASE WHEN @p_division_id = 'ALL' THEN 'ALL'
  --              ELSE A.DIVISION_ID
	 --      END  IN (SELECT t.c.value('.', 'NVARCHAR(4000)')
  --                  FROM   (SELECT x = CAST('<t>' + REPLACE(@p_division_id, ',', '</t><t>') + '</t>' AS xml)) b
  --                  CROSS APPLY x.nodes('/t') t(c)
	 --              )
  --AND    CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL'
  --              ELSE A.SCM_SITE_ID
	 --      END  IN (SELECT t.c.value('.', 'NVARCHAR(4000)')
  --                  FROM   (SELECT x = CAST('<t>' + REPLACE(@p_scm_site_id, ',', '</t><t>') + '</t>' AS xml)) b
  --                  CROSS APPLY x.nodes('/t') t(c)
	 --              )
	;

END

