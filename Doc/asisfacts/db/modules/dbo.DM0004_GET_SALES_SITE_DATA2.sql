/****************************************************************************************************/
/* Program ID  : DM0004_GET_SALES_SITE_DATA                                                         */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2017/11/30  SongDH       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/*                                                                                                  */
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[DM0004_GET_SALES_SITE_DATA2]
  @p_division_id	NVARCHAR(MAX),	--Division
  @p_dept_id        NVARCHAR(MAX),	--Team
  @p_end_customer   NVARCHAR(MAX),	--  EndCustomer
  @p_scm_site_id    NVARCHAR(MAX),	--FCST Type
  @p_active_flag    NVARCHAR(MAX)   --, @p_debug         NVARCHAR(MAX) OUTPUT
AS  
  
BEGIN
  SET NOCOUNT ON;

  DECLARE @v_sql_text          AS NVARCHAR(MAX);

  --DECLARE @v_division_id         AS NVARCHAR(MAX);
  --DECLARE @v_upper_dept_id         AS NVARCHAR(MAX);
  --DECLARE @v_dept_id         AS NVARCHAR(MAX);
  --DECLARE @v_scm_site_id         AS NVARCHAR(MAX);
   
  SET @v_sql_text = '
	SELECT S.DIVISION_ID		  
		  ,S.DEPT_ID       AS TEAM_ID
		  ,T.DEPT_NAME_KO  AS TEAM_NAME	  
		  ,S.END_CUSTOMER
		  ,S.SOLDTO_CODE 
		  ,C.SOLDTO_CODE   AS REP_SOLDTO_CODE
		  ,C.SHIPTO_CODE   AS REP_SHIPTO_CODE
		  ,S.COUNTRY
		  ,CO.COUNTRY_NAME
		  ,S.CITY
		  ,CT.CITY_NAME
		  ,S.SCM_SITE_ID
		  ,S.SITE_DESCRIPTION
		  ,S.VALID_YN
		  ,S.LAST_UPDATED_BY
		  ,S.LAST_UPDATE_DATE
	FROM  SCM_MST_SITE AS S
	LEFT JOIN SCM_MST_SSO_DEPT_INFO AS T
	   ON S.DEPT_ID = T.DEPT_ID
	LEFT OUTER JOIN SCM_MST_SITE_CUSTOMER AS C
	   ON (    S.DIVISION_ID = C.DIVISION_ID
	       AND S.SCM_SITE_ID = C.SCM_SITE_ID
	       AND C.REP_YN = ''Y'' )
	LEFT JOIN SCM_MST_COUNTRY AS CO
	   ON S.COUNTRY = CO.COUNTRY
	LEFT JOIN SCM_MST_CITY AS CT
	   ON (    S.COUNTRY = CT.COUNTRY
	       AND S.CITY    = CT.CITY )	
	INNER JOIN SCM_MST_SSO_DEPT_INFO AS DEPT
	ON S.DEPT_ID = DEPT.DEPT_ID
	WHERE 1 = 1	   
	AND SITE_TYPE = ''SALES''
	[@v_division_id]
	[@v_dept_id]
	[@v_end_customer]
	[@v_scm_site_id]
	[@v_active_flag]
	ORDER BY S.DIVISION_ID, S.DEPT_ID, S.END_CUSTOMER, S.SITE_DESCRIPTION, S.SCM_SITE_ID
	';
	
	SET @v_sql_text = REPLACE(@v_sql_text,'[@v_division_id]'  , [dbo].[FN_SCM_GET_WHERE_SQL]('S.DIVISION_ID' , 'EQ', @p_division_id ));
	SET @v_sql_text = REPLACE(@v_sql_text,'[@v_dept_id]'      , [dbo].[FN_SCM_GET_WHERE_SQL]('S.DEPT_ID'     , 'EQ', @p_dept_id     ));
	SET @v_sql_text = REPLACE(@v_sql_text,'[@v_end_customer]' , [dbo].[FN_SCM_GET_WHERE_SQL]('S.END_CUSTOMER', 'EQ', @p_end_customer));
	SET @v_sql_text = REPLACE(@v_sql_text,'[@v_scm_site_id]'  , [dbo].[FN_SCM_GET_WHERE_SQL]('S.SCM_SITE_ID' , 'EQ', @p_scm_site_id ));
	SET @v_sql_text = REPLACE(@v_sql_text,'[@v_active_flag]'  , [dbo].[FN_SCM_GET_WHERE_SQL]('S.VALID_YN'    , 'EQ', @p_active_flag ));

	/*
	AND CASE WHEN @p_division_id = 'ALL' THEN 'ALL'
             ELSE S.DIVISION_ID
		END IN (SELECT t.c.value('.', 'NVARCHAR(4000)')
                FROM   (SELECT x = CAST('<t>' + REPLACE(@p_division_id, ',', '</t><t>') + '</t>' AS xml)) b
                CROSS APPLY x.nodes('/t') t(c)
	           )   
	AND CASE WHEN @p_upper_dept_id = '' OR @p_upper_dept_id is null THEN ''
			 ELSE D.DEPT_ID
		END IN (SELECT t.c.value('.', 'NVARCHAR(4000)')
                FROM   (SELECT x = CAST('<t>' + REPLACE(@p_upper_dept_id, ',', '</t><t>') + '</t>' AS xml)) b
                CROSS APPLY x.nodes('/t') t(c)
	           )   
	AND CASE WHEN @p_dept_id = '' OR @p_dept_id is null THEN ''
			 ELSE T.DEPT_ID
		END IN (SELECT t.c.value('.', 'NVARCHAR(4000)')
                FROM   (SELECT x = CAST('<t>' + REPLACE(@p_dept_id, ',', '</t><t>') + '</t>' AS xml)) b
                CROSS APPLY x.nodes('/t') t(c)
	           )   
	AND D.DEPT_NAME_KO LIKE '%' + @p_upper_dept_id + '%'
	AND T.DEPT_NAME_KO LIKE '%' + @p_dept_id + '%'
	AND CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL'
			 ELSE S.SCM_SITE_ID
		END IN (SELECT t.c.value('.', 'NVARCHAR(4000)')
                FROM   (SELECT x = CAST('<t>' + REPLACE(@p_scm_site_id, ',', '</t><t>') + '</t>' AS xml)) b
                CROSS APPLY x.nodes('/t') t(c)
	           ) 
    AND CASE WHEN @p_active_flag = 'ALL' THEN 'ALL'
	         ELSE S.VALID_YN
		END = @p_active_flag*/
  
  --SELECT @p_end_customer 
  --SELECT [dbo].[FN_SCM_GET_WHERE_SQL]('S.END_CUSTOMER', 'EQ', @p_end_customer);
  --SELECT @v_sql_text = '[@v_end_customer]';
  --SELECT REPLACE(@v_sql_text,N'[@v_end_customer]' , [dbo].[FN_SCM_GET_WHERE_SQL2]('S.END_CUSTOMER', 'EQ', @p_end_customer));
  SELECT @v_sql_text
  --SET @p_debug = @v_sql_text;
  RETURN ;
    
  EXEC SP_EXECUTESQL @v_sql_text; 
								  
END

