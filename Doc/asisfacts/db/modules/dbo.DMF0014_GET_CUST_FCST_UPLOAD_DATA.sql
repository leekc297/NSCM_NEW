/*
 * Program ID  : DMF0014_GET_CUST_FCST_UPLOAD_DATA                                                             
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/12/22   SongDH       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 
 * 2018/05/30  JYE			복수 팀 권한 관련  수정 
** 20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리
* 20221026		KDW2819		[C20221024-000507]CUST FCST Upload 오류 수정
* 2024/09/18	KJJ			[PJ2024-50461] Team Mapping
* 2024.11.20	KJJ			[PJ2024-50611] Team Mapping 반영 후 오류 수정
*/

/*
 EXEC DMF0014_GET_CUST_FCST_UPLOAD_DATA @p_division_id='81', @p_dept_id='ALL', @p_end_customer='ALL', @p_scm_site_id='ALL', @p_plant_site_id='ALL', @p_project_code=''
 , @p_item_id='', @p_start_yyyymmdd='20230904', @p_end_yyyymmdd='20240310', @p_bucket_type='WEEKLY', @p_dom_exp='ALL', @p_created_by='chano0612', @p_userinfo='ADMIN'
*/

CREATE PROCEDURE [dbo].[DMF0014_GET_CUST_FCST_UPLOAD_DATA]
  @p_division_id     NVARCHAR(MAX),
  @p_dept_id         NVARCHAR(MAX),
  @p_end_customer    NVARCHAR(MAX),
  @p_scm_site_id     NVARCHAR(MAX),
  @p_plant_site_id   NVARCHAR(MAX),
  @p_project_code    NVARCHAR(MAX),
  @p_item_id         NVARCHAR(MAX),
  @p_start_yyyymmdd  NVARCHAR(8),
  @p_end_yyyymmdd    NVARCHAR(8),
  @p_bucket_type     NVARCHAR(10),
  @p_dom_exp         NVARCHAR(10),
  @p_created_by      NVARCHAR(50),    --, @p_debug NVARCHAR(MAX) OUTPUT
  @p_userinfo		NVARCHAR(MAX)
AS  
  
BEGIN
    SET NOCOUNT ON;

    DECLARE @v_sql_text       AS NVARCHAR(MAX);
    DECLARE @v_iteration      AS NVARCHAR(MAX);
    DECLARE @v_column_text    AS NVARCHAR(200);
    DECLARE @v_column_name    AS NVARCHAR(50);  
    DECLARE @v_yyyymmdd       AS NVARCHAR(8);  
    DECLARE @v_start_yyyymmdd AS NVARCHAR(8);  

	DECLARE @v_group_id nvarchar(50)='';

	--IF @p_userinfo = 'ADMIN' OR @p_userinfo = 'DM ADMIN'
	--	SET @v_group_id = 'ADMIN'

	---------------------------------------------------------------------------------
	--            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
	---------------------------------------------------------------------------------
	IF ISNULL((
				SELECT COUNT(1) FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
					where LOOKUP_TYPE = 'GET_ADMIN_GROUP' 
						AND VALID_YN = 'Y'
						AND SEGMENT2 = 'ALL'  -- 'ALL'인경우 DM Planner (W/S) 제외 / 주석처리인경우 DM Planner (W/S) 포함 
						AND SEGMENT1 = @p_userinfo
			  ),0) > 0
		BEGIN
			SET @v_group_id = 'ADMIN'
		END
	---------------------------------------------------------------------------------
	--            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
	---------------------------------------------------------------------------------

	SELECT @v_start_yyyymmdd = A.BASIS_START_DATE
    FROM   [DBO].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
    WHERE  A.BASIS_YYYYMMDD = @p_start_yyyymmdd;
  
    SELECT @v_iteration = '';

	IF @p_bucket_type = 'DAILY'		   
	BEGIN
		DECLARE c_cust_fcst CURSOR FAST_FORWARD FOR    
	    SELECT 'D_' + BASIS_YYYYMMDD  AS COLUMN_NAME
              , BASIS_YYYYMMDD        AS YYYYMMDD
        FROM   [DBO].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
        WHERE  A.BASIS_YYYYMMDD >= @v_start_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
        AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd   --CONVERT(CHAR(8), DATEADD(MM, 6, CURRENT_TIMESTAMP), 112)        
        ORDER BY COLUMN_NAME ;
		
		OPEN c_cust_fcst;
        FETCH NEXT FROM c_cust_fcst INTO @v_column_name, @v_yyyymmdd
        
		WHILE @@FETCH_STATUS = 0   
        BEGIN
            SET @v_column_text = ', SUM(CASE WHEN CP.YYYYMMDD = ''[@v_yyyymmdd]'' THEN CP.QTY ELSE NULL END) AS [@v_column_name] ';
	
            SET @v_column_text = REPLACE(@v_column_text,'[@v_yyyymmdd]'   , @v_yyyymmdd   );
            SET @v_column_text = REPLACE(@v_column_text,'[@v_column_name]', @v_column_name);

            SELECT @v_iteration = @v_iteration + @v_column_text;	
    
            FETCH NEXT FROM c_cust_fcst INTO @v_column_name, @v_yyyymmdd
        END;

		CLOSE c_cust_fcst;  
        DEALLOCATE c_cust_fcst;
    END;
	ELSE IF @p_bucket_type = 'WEEKLY'
	BEGIN
		DECLARE c_cust_fcst CURSOR FAST_FORWARD FOR    
		SELECT 'D_' + MIN(A.BASIS_START_DATE)  AS COLUMN_NAME
             , A.ISO_YYYYWW --A.BASIS_YYYYMM + MIN(RIGHT('00' + CONVERT(VARCHAR, DATEPART(WEEK, A.BASIS_START_DATE), 23), 2))  AS YYYYMMDD  
        FROM   [DBO].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
        WHERE  A.BASIS_YYYYMMDD >= @v_start_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
        AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd   --CONVERT(CHAR(8), DATEADD(MM, 6, CURRENT_TIMESTAMP), 112)
        GROUP BY A.ISO_YYYYWW, A.WEEK_NAME    
        ORDER BY COLUMN_NAME ;

	    OPEN c_cust_fcst;
        FETCH NEXT FROM c_cust_fcst INTO @v_column_name, @v_yyyymmdd
        
		WHILE @@FETCH_STATUS = 0   
        BEGIN
            SET @v_column_text = ', SUM(CASE WHEN SUBSTRING(CP.YYYYMMDD, 1, 4) + RIGHT(''00'' + CONVERT(VARCHAR, DATEPART(WEEK, CP.YYYYMMDD), 23), 2) = ''[@v_yyyymmdd]'' THEN CP.QTY ELSE NULL END) AS [@v_column_name] ';
	
            SET @v_column_text = REPLACE(@v_column_text,'[@v_yyyymmdd]'   , @v_yyyymmdd   );
            SET @v_column_text = REPLACE(@v_column_text,'[@v_column_name]', @v_column_name);

            SELECT @v_iteration = @v_iteration + @v_column_text;	
    
            FETCH NEXT FROM c_cust_fcst INTO @v_column_name, @v_yyyymmdd
        END;

		CLOSE c_cust_fcst;  
        DEALLOCATE c_cust_fcst;
	END;
	ELSE IF @p_bucket_type = 'MONTHLY'
	BEGIN
		DECLARE c_cust_fcst CURSOR FAST_FORWARD FOR    
		SELECT 'D_' + MIN(A.BASIS_YYYYMM) + '01' AS COLUMN_NAME
             , MIN(A.BASIS_YYYYMM)               AS YYYYMMDD  
        FROM   [DBO].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
        WHERE  A.BASIS_YYYYMMDD >= @v_start_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
        AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd   --CONVERT(CHAR(8), DATEADD(MM, 6, CURRENT_TIMESTAMP), 112)
        GROUP BY A.MONTH_NAME 
	    ORDER BY COLUMN_NAME;

		OPEN c_cust_fcst;
        FETCH NEXT FROM c_cust_fcst INTO @v_column_name, @v_yyyymmdd
        
		WHILE @@FETCH_STATUS = 0   
        BEGIN
            SET @v_column_text = ', SUM(CASE WHEN SUBSTRING(CP.YYYYMMDD, 1, 6) = ''[@v_yyyymmdd]'' THEN CP.QTY ELSE NULL END) AS [@v_column_name] ';
	
            SET @v_column_text = REPLACE(@v_column_text,'[@v_yyyymmdd]'   , @v_yyyymmdd   );
            SET @v_column_text = REPLACE(@v_column_text,'[@v_column_name]', @v_column_name);

            SELECT @v_iteration = @v_iteration + @v_column_text;	
    
            FETCH NEXT FROM c_cust_fcst INTO @v_column_name, @v_yyyymmdd
        END;
		CLOSE c_cust_fcst;  
        DEALLOCATE c_cust_fcst;
	END;

    SET @v_sql_text = '
        SELECT CP.DIVISION_ID
		     , CP.SCM_SITE_ID
			 , CP.PLANT_SITE_ID
             , CP.CUSTOMER_PROJECT_CODE
             , CP.CUSTOMER_MODEL
             , CP.INCOTERMS             
             , CP.FCST_TYPE
			 , CP.DOM_EXP
			 , CP.MEASURE_GROUP
             , CP.MEASURE
			 , CP.UPLOAD_UOM
             , CP.PROJECT_CODE
             , CP.ITEM_ID
		--[PJ2024-50461] Team Mapping------------------------------------
			 --, CASE WHEN (([dbo].[FN_GET_DEPT_LIST](''[@p_created_by]'', S.DEPT_ID) = ''Y'') OR ''[@v_group_id]'' =''ADMIN'') 
				--THEN ''Y'' ELSE ''N'' END AS EDIT_FLAG
			 , CASE WHEN (([dbo].[FN_GET_DEPT_LIST](''[@p_created_by]'', TEAM.DEPT_ID) = ''Y'') OR ''[@v_group_id]'' =''ADMIN'') 
				THEN ''Y'' ELSE ''N'' END AS EDIT_FLAG
		--[PJ2024-50461] Team Mapping------------------------------------
             [@v_iteration]
        FROM   [dbo].[DM_PLN_CUSTOMER_PSI] CP WITH(NOLOCK)
		     			--, [dbo].[SCM_MST_SITE]        S  WITH(NOLOCK)
		--[PJ2024-50611] 명시적으로 INNER JOIN 처리 START
		INNER JOIN  [dbo].[SCM_MST_SITE]        S  WITH(NOLOCK)
			ON CP.DIVISION_ID   = S.DIVISION_ID
			AND    CP.SCM_SITE_ID   = S.SCM_SITE_ID
		--[PJ2024-50611] 명시적으로 INNER JOIN 처리 END
--[PJ2024-50461] Team Mapping------------------------------------
			LEFT OUTER JOIN SCM_MST_SITE_ITEM ITM WITH(NOLOCK)
				ON S.DIVISION_ID = ITM.DIVISION_ID
				AND S.SCM_SITE_ID = ITM.SCM_SITE_ID
				AND CP.PROJECT_CODE = ITM.PROJECT_CODE--[PJ2024-50611] 조인 추가
				AND CP.ITEM_ID = ITM.ITEM_ID--[PJ2024-50611] 조인 추가
			LEFT JOIN (
				SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO, C.UPPER_DEPT_ID 
				FROM [SCM_MST_SSO_USER_INFO] AS B WITH(NOLOCK)
				INNER JOIN SCM_MST_SSO_DEPT_INFO AS C WITH(NOLOCK)
				ON B.DEPT_ID = C.DEPT_ID
			) AS TEAM
			ON      
			TEAM.USER_ID   IN (SELECT top 1 token FROM [dbo].[String_Split](ITM.owner, '',''))
--[PJ2024-50461] Team Mapping------------------------------------
        WHERE  1 = 1
		AND    CP.DIVISION_ID   = S.DIVISION_ID
		AND    CP.SCM_SITE_ID   = S.SCM_SITE_ID
        AND    CP.MEASURE_GROUP = ''CUST_FCST'' 
		[@p_division_id]  
		[@p_dept_id]     
        [@p_scm_site_id]
		[@p_plant_site_id]
		[@p_project_code]
        [@p_item_id]
	    [@p_dom_exp]	    
		[@p_end_customer]	
		AND    CP.YYYYMMDD BETWEEN ''[@p_start_yyyymmdd]'' AND ''[@p_end_yyyymmdd]''
		AND    CP.MEASURE IN (SELECT DISTINCT MEASURE
		                      FROM   [dbo].[DM_MST_CUSTOMER_FCST] X WITH(NOLOCK)
							  WHERE  1 = 1
							  AND    X.DIVISION_ID = CP.DIVISION_ID                                     
                              AND    X.SCM_SITE_ID = CP.SCM_SITE_ID -- 해당 SITE에 연결된 Measure만 구함.
                              AND    X.UPLOAD_BUCKET_TYPE = ''[@p_bucket_type]''	
							  AND    X.VALID_YN    = ''Y''
							)		
		GROUP BY CP.DIVISION_ID
		--[PJ2024-50461] Team Mapping------------------------------------
				--, S.DEPT_ID
			   , TEAM.DEPT_ID
		--[PJ2024-50461] Team Mapping------------------------------------
		       , CP.SCM_SITE_ID
			   , CP.PLANT_SITE_ID
               , CP.CUSTOMER_PROJECT_CODE
               , CP.CUSTOMER_MODEL
               , CP.INCOTERMS             
               , CP.FCST_TYPE
			   , CP.DOM_EXP
			   , CP.MEASURE_GROUP
               , CP.MEASURE
			   , CP.UPLOAD_UOM
               , CP.PROJECT_CODE
               , CP.ITEM_ID
			   
        ORDER BY CP.DIVISION_ID
		       , CP.SCM_SITE_ID
			   , CP.PLANT_SITE_ID
		       , CP.CUSTOMER_PROJECT_CODE
			   , CP.CUSTOMER_MODEL
			   
  '; 
  
  SET @v_sql_text = REPLACE(@v_sql_text,'[@v_iteration]'     , @v_iteration     );
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_division_id]'   , [dbo].[FN_SCM_GET_WHERE_SQL]('CP.DIVISION_ID'   , 'IN', @p_division_id ));
  --[PJ2024-50461] Team Mapping------------------------------------
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_dept_id]'       , [dbo].[FN_SCM_GET_WHERE_SQL]('TEAM.DEPT_ID'        , 'IN', @p_dept_id ));
  --[PJ2024-50461] Team Mapping------------------------------------
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_end_customer]'  , [dbo].[FN_SCM_GET_WHERE_SQL]('S.END_CUSTOMER'   , 'IN', @p_end_customer));
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_scm_site_id]'   , [dbo].[FN_SCM_GET_WHERE_SQL]('CP.SCM_SITE_ID'   , 'IN', @p_scm_site_id));
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_plant_site_id]' , [dbo].[FN_SCM_GET_WHERE_SQL]('CP.PLANT_SITE_ID' , 'IN', @p_plant_site_id));
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_project_code]'  , [dbo].[FN_SCM_GET_WHERE_SQL]('CP.PROJECT_CODE'  , 'IN', @p_project_code));
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_item_id]'       , [dbo].[FN_SCM_GET_WHERE_SQL]('CP.ITEM_ID'       , 'IN', @p_item_id));
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_dom_exp]'       , [dbo].[FN_SCM_GET_WHERE_SQL]('CP.DOM_EXP'       , 'IN', @p_dom_exp));
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_start_yyyymmdd]', @v_start_yyyymmdd);
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_end_yyyymmdd]'  , @p_end_yyyymmdd  );
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_bucket_type]'   , @p_bucket_type   );  
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_created_by]'    , @p_created_by    );
  SET @v_sql_text = REPLACE(@v_sql_text,'[@v_group_id]'    , @v_group_id    );

  --SET @p_debug = @v_sql_text;
  --RETURN @p_debug;
  --SELECT @v_sql_text;
  PRINT SUBSTRING(@v_sql_text, 1, 3000)
  PRINT SUBSTRING(@v_sql_text, 3001, 6000)
  --EXEC(@v_sql_text);
  EXEC SP_EXECUTESQL @v_sql_text; --, @p_param_list, 
                                  --@p_plan_week, @p_division_code, @p_customer_id, @p_fcst_sit_id, @p_measure, @p_edi_fcst_yn, @p_valid_yn;
 --xml확인할경우
SELECT CONVERT(TEXT, @v_sql_text)
FOR XML PATH('')--,ROOT('x')  
END

