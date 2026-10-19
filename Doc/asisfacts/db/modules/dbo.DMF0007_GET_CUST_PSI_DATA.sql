/*
 * Program ID  : DMF0007_GET_CUST_PSI_DATA                                                             
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/02/23  SongDH       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 
 * 2018/05/30  JYE			복수 팀 권한 관련  수정  
** 20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리
 * 20221026 KDW2819	[C20221024-000507]CUST FCST Upload 오류 수정
*/
CREATE PROCEDURE [dbo].[DMF0007_GET_CUST_PSI_DATA]
    @p_plan_week     NVARCHAR(6),
    @p_division_id   NVARCHAR(50),
    @p_dept_id       NVARCHAR(100),
    @p_end_customer  NVARCHAR(100),
    @p_scm_site_id   NVARCHAR(100),
    @p_bucket_type   NVARCHAR(100),
    @p_valid_yn      NVARCHAR(3),
    @p_created_by	   NVARCHAR(50), --, @p_debug         NVARCHAR(MAX) OUTPUT
	@p_user_group		NVARCHAR(100)
AS  
  
BEGIN
    SET NOCOUNT ON;

    DECLARE @v_sql_text       AS NVARCHAR(MAX);
    DECLARE @v_iteration      AS NVARCHAR(MAX);
    DECLARE @v_column_text    AS NVARCHAR(200);
    --DECLARE @v_iteration      AS NVARCHAR(4000);
    DECLARE @v_column_name    AS NVARCHAR(20);
    DECLARE @v_weekstart_date AS NVARCHAR(8);
    DECLARE @p_param_list     AS NVARCHAR(4000);
	DECLARE @v_plan_week      AS NVARCHAR(6);  
    DECLARE @v_start_week     AS NVARCHAR(8);  
    DECLARE @v_end_week       AS NVARCHAR(8);
    DECLARE @v_start_yyyymmdd AS NVARCHAR(8);  
    DECLARE @v_end_yyyymmdd   AS NVARCHAR(8);
    DECLARE @v_bucket_type    AS NVARCHAR(10);

	DECLARE @v_group_id nvarchar(50)='';

	--IF @p_user_group = 'ADMIN' OR @p_user_group = 'DM ADMIN'
	--	SET @v_group_id = 'ADMIN'

	---------------------------------------------------------------------------------
	--            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
	---------------------------------------------------------------------------------
	IF ISNULL((
				SELECT COUNT(1) FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
					where LOOKUP_TYPE = 'GET_ADMIN_GROUP' 
						AND VALID_YN = 'Y'
						AND SEGMENT2 = 'ALL'  -- 'ALL'인경우 DM Planner (W/S) 제외 / 주석처리인경우 DM Planner (W/S) 포함 
						AND SEGMENT1 = @p_user_group
			  ),0) > 0
		BEGIN
			SET @v_group_id = 'ADMIN'
		END
	---------------------------------------------------------------------------------
	--            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
	---------------------------------------------------------------------------------
  
    SET @v_start_week = '';
    SET @v_end_week = '';
	SET @v_sql_text = '';

    SET @v_start_week = @p_plan_week;
    SET @v_bucket_type = @p_bucket_type;

	SELECT @v_plan_week = C.ISO_YYYYWW
    FROM   [dbo].[SCM_SYS_CALENDAR_M] C  WITH(NOLOCK)
    WHERE  C.BASIS_YYYYMMDD = CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112);
  
    SET @v_sql_text = '
    SELECT CF.PLAN_WEEK
         , CF.DIVISION_ID	
		 , S.DEPT_ID	 
         , CF.CUSTOMER_CODE   
		 , CF.SCM_SITE_ID      
		 , CF.SUMMARY_BUCKET_TYPE
		 , CF.MEASURE_GROUP
         , CF.MEASURE
         , CF.EDI_FCST_YN
		 , CF.CUSTOMER_PSI
         , CF.UPLOAD_UOM
		 , CF.UPLOAD_BUCKET_TYPE
         , CF.VALID_YN   AS VALID_YN  
		 , CF.LAST_UPDATED_BY
		 , CF.LAST_UPDATE_DATE
		 , CASE WHEN (([dbo].[FN_GET_DEPT_LIST](''[@p_created_by]'', S.DEPT_ID) = ''Y'') OR ''[@v_group_id]'' =''ADMIN'') 
			THEN ''Y'' ELSE ''N'' END AS EDIT_FLAG
    FROM   [dbo].[DM_MST_CUSTOMER_FCST] CF  WITH(NOLOCK)
	     , [dbo].[SCM_MST_SITE]         S   WITH(NOLOCK)
    WHERE  1 = 1
	AND    CF.DIVISION_ID   = S.DIVISION_ID
	AND    CF.CUSTOMER_CODE = S.END_CUSTOMER
	AND    CF.SCM_SITE_ID   = S.SCM_SITE_ID
	AND    CF.MEASURE_GROUP = ''PSI''
	AND    CF.PLAN_WEEK     = ''[@p_plan_week]'' 
	--AND    CF.SUMMARY_BUCKET_VALUE BETWEEN ''[@v_start_yyyymmdd]'' AND ''[@v_end_yyyymmdd]''
	[@p_division_id]  
	[@p_dept_id]     	
    [@p_end_customer]	
    [@p_scm_site_id]
	[@p_bucket_type]	
	[@p_valid_yn]    
/*	GROUP BY CF.PLAN_WEEK
           , CF.DIVISION_ID		
		   , S.DEPT_ID 
           , CF.CUSTOMER_CODE   
		   , CF.SCM_SITE_ID      
		   , CF.SUMMARY_BUCKET_TYPE
           , CF.MEASURE
		   , CF.MEASURE_GROUP
           , CF.EDI_FCST_YN
		   , CF.CUSTOMER_PSI
           , CF.UPLOAD_UOM
		   , CF.UPLOAD_BUCKET_TYPE  */
    ORDER BY CF.DIVISION_ID
	       , S.DEPT_ID
           , CF.CUSTOMER_CODE
           , CF.SCM_SITE_ID
		   , CF.MEASURE_GROUP
		   , CF.MEASURE
  '; 
  
  --SET @v_sql_text = REPLACE(@v_sql_text,'[@v_iteration]'     , @v_iteration     );
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_plan_week]'     , @v_plan_week     );
  --SET @v_sql_text = REPLACE(@v_sql_text,'[@v_start_yyyymmdd]', @v_start_yyyymmdd);
  --SET @v_sql_text = REPLACE(@v_sql_text,'[@v_end_yyyymmdd]'  , @v_end_yyyymmdd  );
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_division_id]'   , [dbo].[FN_SCM_GET_WHERE_SQL]('CF.DIVISION_ID'        , 'IN', @p_division_id ));
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_dept_id]'       , [dbo].[FN_SCM_GET_WHERE_SQL]('S.DEPT_ID'             , 'IN', @p_dept_id     ));
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_end_customer]'  , [dbo].[FN_SCM_GET_WHERE_SQL]('CF.CUSTOMER_CODE'      , 'IN', @p_end_customer));
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_scm_site_id]'   , [dbo].[FN_SCM_GET_WHERE_SQL]('CF.SCM_SITE_ID'        , 'IN', @p_scm_site_id ));
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_bucket_type]'   , [dbo].[FN_SCM_GET_WHERE_SQL]('CF.SUMMARY_BUCKET_TYPE', 'EQ', @p_bucket_type ));
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_valid_yn]'      , [dbo].[FN_SCM_GET_WHERE_SQL]('CF.VALID_YN'           , 'EQ', @p_valid_yn    ));
  SET @v_sql_text = REPLACE(@v_sql_text,'[@p_created_by]'    , @p_created_by    );
  SET @v_sql_text = REPLACE(@v_sql_text,'[@v_group_id]'    , @v_group_id    );

  --SELECT @v_sql_text;

  --SET @p_debug = @v_sql_text;
  --RETURN @v_sql_text;
  --SELECT @v_sql_text;

  --EXEC(@v_sql_text);
  EXEC SP_EXECUTESQL @v_sql_text; --, @p_param_list, 
                                  --@p_plan_week, @p_division_code, @p_customer_id, @p_fcst_sit_id, @p_measure, @p_edi_fcst_yn, @p_valid_yn;

								  
END

