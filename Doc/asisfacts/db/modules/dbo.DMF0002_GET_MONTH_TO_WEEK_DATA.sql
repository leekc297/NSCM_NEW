/****************************************************************************************************/
/* Program ID  : DMF0002_GET_MONTH_TO_WEEK_DATA                                                             */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2017/11/15  SongDH       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/*                                                                                                  */
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[DMF0002_GET_MONTH_TO_WEEK_DATA]
  @p_division_id  NVARCHAR(30),
  @p_site_id      NVARCHAR(30),
  @p_from_yyyymm  NVARCHAR(6),
  @p_to_yyyymm    NVARCHAR(6)
  --@p_debug        NVARCHAR(4000) OUTPUT
AS  
  
BEGIN
  SET NOCOUNT ON;

  DECLARE @v_sql_text       AS NVARCHAR(MAX);
  DECLARE @v_iteration      AS NVARCHAR(MAX);
  DECLARE @v_column_text    AS NVARCHAR(1000);
  DECLARE @v_column_name    AS NVARCHAR(50);
  DECLARE @v_weekstart_date AS NVARCHAR(8);
  DECLARE @p_param_list     AS NVARCHAR(4000);
  DECLARE @p_end_week       AS NVARCHAR(6);
  
  DECLARE c_bucket CURSOR FAST_FORWARD FOR
    SELECT 'W_' + C.BASIS_START_DATE + '_' + CASE WHEN C.BASIS_START_DATE > CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112) 
                                                THEN 'UNLOCK_' + CONVERT(CHAR(1), ROW_NUMBER() OVER(PARTITION BY C.month_name  ORDER BY C.month_name ASC))
		  							          ELSE 'LOCK_' + CONVERT(CHAR(1), ROW_NUMBER() OVER(PARTITION BY month_name  ORDER BY month_name ASC))
			  							 END   AS column_name       
         , C.BASIS_START_DATE
    FROM   [dbo].[SCM_SYS_CALENDAR_M] C WITH(NOLOCK)	
    WHERE  C.basis_yyyymm >= @p_from_yyyymm --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
    AND    C.basis_yyyymm <= @p_to_yyyymm   --CONVERT(CHAR(6), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
    GROUP BY C.BASIS_START_DATE
           , C.BASIS_END_DATE
           , C.week_name
           , C.month_name                                  
           --, C.start_yyyymmdd
           --, C.end_yyyymmdd
	;
	
  SELECT @v_iteration = '';

  OPEN c_bucket;
  FETCH NEXT FROM c_bucket INTO @v_column_name, @v_weekstart_date
  WHILE @@FETCH_STATUS = 0   
  BEGIN

	SET @v_column_text = ', SUM(CASE WHEN A.YYYYMMDD = ''[@v_weekstart_date]'' THEN A.BUCKET_PER ELSE '''' END) AS [@v_column_name] ';
	
	SET @v_column_text = REPLACE(@v_column_text,'[@v_weekstart_date]', @v_weekstart_date);
	SET @v_column_text = REPLACE(@v_column_text,'[@v_column_name]', @v_column_name);

	SELECT @v_iteration = @v_iteration + @v_column_text;	
    
    FETCH NEXT FROM c_Bucket INTO @v_column_name, @v_weekstart_date
  END;
  
  --SELECT @v_iteration AS xxxx;

  CLOSE c_bucket;  
  DEALLOCATE c_bucket;

  SET @v_sql_text = '
    SELECT A.DIVISION_ID
         , B.END_CUSTOMER
      	 , A.SCM_SITE_ID
         [@v_iteration]    
    FROM   [dbo].[DM_MST_BUCKET_CONVERSION] A WITH(NOLOCK)
         , [dbo].[SCM_MST_SITE]             B WITH(NOLOCK)
    WHERE  A.SCM_SITE_ID = B.SCM_SITE_ID
    AND    A.CONVERSION_TYPE = ''MTOW''
    AND    A.YYYYMMDD >= ''[@p_from_yyyymm]'' 
    AND    A.YYYYMMDD <= ''[@p_to_yyyymm]'' 
    AND    CASE WHEN N''[@p_division_id]'' = ''ALL'' THEN ''ALL''
                ELSE A.DIVISION_ID
	       END  IN (SELECT t.c.value(''.'', ''NVARCHAR(4000)'')
                    FROM   (SELECT x = CAST(''<t>'' + REPLACE(N''[@p_division_id]'', '','', ''</t><t>'') + ''</t>'' AS xml)) b
                    CROSS APPLY x.nodes(''/t'') t(c)
	               )
    AND    CASE WHEN N''[@p_site_id]'' = ''ALL'' THEN ''ALL''
                ELSE A.SCM_SITE_ID
	       END  IN (SELECT t.c.value(''.'', ''NVARCHAR(4000)'')
                    FROM   (SELECT x = CAST(''<t>'' + REPLACE(N''[@p_site_id]'', '','', ''</t><t>'') + ''</t>'' AS xml)) b
                    CROSS APPLY x.nodes(''/t'') t(c)
	               )     
	GROUP BY A.DIVISION_ID
           , B.END_CUSTOMER
           , A.SCM_SITE_ID
  '; 
  
  SET @v_sql_text = REPLACE(@v_sql_text,'[@v_iteration]'  , @v_iteration);
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_from_yyyymm]', @p_from_yyyymm);
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_to_yyyymm]'  , @p_to_yyyymm);
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_division_id]', @p_division_id);
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_site_id]'    , @p_site_id); 

  --SET @p_debug = @v_sql_text;
  --RETURN @p_debug;
    
  EXEC SP_EXECUTESQL @v_sql_text; 
								  
END

