/****************************************************************************************************/
/* Program ID  : DMF0001_GET_CUST_FCST_DATA                                                             */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2017/10/25  SongDH       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/*                                                                                                  */
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[DMF0001_GET_CUST_FCST_DATA]
  @p_plan_week          NVARCHAR(6),
  @p_division_code      NVARCHAR(18),
  @p_customer_id        NVARCHAR(50),
  @p_fcst_sit_id        NVARCHAR(30),
  @p_measure            NVARCHAR(50),
  @p_edi_fcst_yn        NVARCHAR(3),
  @p_valid_yn           NVARCHAR(3)
AS  
  
BEGIN
  SET NOCOUNT ON;

  DECLARE @v_sql_text       AS NVARCHAR(MAX);
  DECLARE @v_iteration      AS NVARCHAR(MAX);
  DECLARE @v_column_text    AS NVARCHAR(100);
  --DECLARE @v_iteration      AS NVARCHAR(4000);
  DECLARE @v_column_name    AS NVARCHAR(20);
  DECLARE @v_weekstart_date AS NVARCHAR(8);
  DECLARE @p_param_list     AS NVARCHAR(4000);
  DECLARE @p_end_week       AS NVARCHAR(6);
  
  SET @p_end_week = CONVERT(CHAR(4), SUBSTRING(@p_plan_week, 1, 4) + 1) + CONVERT(CHAR(2), SUBSTRING(@p_plan_week, 5, 2) -1);

  DECLARE c_bucket CURSOR FAST_FORWARD FOR
    SELECT 'W_' + a.basis_start_date + '_' + a.basis_end_date AS column_name       
         , basis_start_date AS weekstart_date
    FROM   [dbo].[SCM_SYS_CALENDAR_M] a WITH(NOLOCK)	
    WHERE  a.iso_yyyyww > @p_plan_week --   CONVERT(CHAR(4), YEAR(CURRENT_TIMESTAMP)) + CONVERT(CHAR(2), DATEPART(WEEK, CURRENT_TIMESTAMP))
    AND    a.iso_yyyyww <= @p_end_week --CONVERT(CHAR(4), YEAR(DATEADD(YYYY, 1, CURRENT_TIMESTAMP))) + CONVERT(CHAR(2), DATEPART(WEEK, CURRENT_TIMESTAMP))
    GROUP BY a.basis_start_date
           , a.basis_end_date
	;
	
  SELECT @v_iteration = '';

  OPEN c_bucket;
  FETCH NEXT FROM c_bucket INTO @v_column_name, @v_weekstart_date
  WHILE @@FETCH_STATUS = 0   
  BEGIN

	SET @v_column_text = ', MAX(CASE WHEN a.from_bucket = ''[@v_weekstart_date]'' THEN ''Y'' ELSE '''' END) AS [@v_column_name] ';
	
	SET @v_column_text = REPLACE(@v_column_text,'[@v_weekstart_date]', @v_weekstart_date);
	SET @v_column_text = REPLACE(@v_column_text,'[@v_column_name]', @v_column_name);

	SELECT @v_iteration = @v_iteration + @v_column_text;	
    
    FETCH NEXT FROM c_Bucket INTO @v_column_name, @v_weekstart_date
  END;
  
  --SELECT @v_iteration AS xxxx;

  CLOSE c_bucket;  
  DEALLOCATE c_bucket;

  SET @v_sql_text = '
    SELECT a.plan_week
         , a.division_id
         , a.customer_code
         , a.scm_site_id
         , a.measure
         , a.edi_fcst_yn
         , a.upload_uom
         , a.valid_yn
         , a.bucket_type
         [@v_iteration]    
    FROM   [dbo].[dm_mst_customer_fcst] a  WITH(NOLOCK)
    WHERE  a.plan_week   = ''[@p_plan_week]'' 
    AND    a.division_id = [@p_division_code] 
    AND    CASE WHEN N''[@p_customer_id]'' = ''ALL'' THEN ''ALL''
                ELSE a.customer_code
	       END  IN (SELECT t.c.value(''.'', ''NVARCHAR(4000)'')
                    FROM   (SELECT x = CAST(''<t>'' + REPLACE(N''[@p_customer_id]'', '','', ''</t><t>'') + ''</t>'' AS xml)) b
                    CROSS APPLY x.nodes(''/t'') t(c)
	               )
    AND    CASE WHEN N''[@p_fcst_sit_id]'' = ''ALL'' THEN ''ALL''
                ELSE a.scm_site_id
	       END  IN (SELECT t.c.value(''.'', ''NVARCHAR(4000)'')
                  FROM   (SELECT x = CAST(''<t>'' + REPLACE(N''[@p_fcst_sit_id]'', '','', ''</t><t>'') + ''</t>'' AS xml)) b
                  CROSS APPLY x.nodes(''/t'') t(c)
	             ) 
    AND    CASE WHEN N''[@p_measure]'' = ''ALL'' THEN ''ALL''
                ELSE a.measure
	       END  IN (SELECT t.c.value(''.'', ''NVARCHAR(4000)'')
                    FROM   (SELECT x = CAST(''<t>'' + REPLACE(N''[@p_measure]'', '','', ''</t><t>'') + ''</t>'' AS xml)) b
                    CROSS APPLY x.nodes(''/t'') t(c)
				   )    
    AND    CASE WHEN ''[@p_edi_fcst_yn]'' = ''ALL'' THEN ''ALL''
                ELSE a.edi_fcst_yn
	       END  IN (SELECT t.c.value(''.'', ''NVARCHAR(4000)'')
                    FROM   (SELECT x = CAST(''<t>'' + REPLACE(''[@p_edi_fcst_yn]'', '','', ''</t><t>'') + ''</t>'' AS xml)) b
                    CROSS APPLY x.nodes(''/t'') t(c)
	               ) 
    AND    CASE WHEN ''[@p_valid_yn]'' = ''ALL'' THEN ''ALL''
                ELSE a.valid_yn
	       END  IN (SELECT t.c.value(''.'', ''NVARCHAR(4000)'')
                    FROM   (SELECT x = CAST(''<t>'' + REPLACE(''[@p_valid_yn]'', '','', ''</t><t>'') + ''</t>'' AS xml)) b
                    CROSS APPLY x.nodes(''/t'') t(c)
	               )
	GROUP BY a.plan_week
           , a.division_id
           , a.customer_code
           , a.scm_site_id
           , a.measure
           , a.edi_fcst_yn
           , a.upload_uom
           , a.valid_yn
           , a.bucket_type
  '; 
  
  SET @v_sql_text = REPLACE(@v_sql_text,'[@v_iteration]', @v_iteration);
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_plan_week]', @p_plan_week);
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_division_code]', @p_division_code);
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_customer_id]', @p_customer_id);
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_fcst_sit_id]', @p_fcst_sit_id); 
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_measure]', @p_measure);
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_edi_fcst_yn]', @p_edi_fcst_yn);
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_valid_yn]', @p_valid_yn);

  --SET @p_debug = @v_sql_text;
  --RETURN @p_debug;

  --EXEC(@v_sql_text);
  EXEC SP_EXECUTESQL @v_sql_text; --, @p_param_list, 
                                  --@p_plan_week, @p_division_code, @p_customer_id, @p_fcst_sit_id, @p_measure, @p_edi_fcst_yn, @p_valid_yn;

								  
END

