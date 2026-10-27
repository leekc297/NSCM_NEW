

/*
 * Program ID   : PR_UI_FP00470_MASTER_DATA_VALIDATION
 * Description  : BOM Explosion 1 Level
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/01/27   CYS				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00470_MASTER_DATA_VALIDATION]
  @p_sys_type			NVARCHAR(MAX),  
  @p_sys_flag			NVARCHAR(MAX),
  @p_sys_gubun			NVARCHAR(MAX),  
  @p_user_id			NVARCHAR(MAX),

  @p_instance_id		NVARCHAR(MAX),
  @p_plan_date			NVARCHAR(MAX),
  @p_division_id		NVARCHAR(MAX),
  @p_site_id			NVARCHAR(MAX),
  @p_plant_id			NVARCHAR(MAX),
  @p_check_category		NVARCHAR(MAX),
  @p_problem_type		NVARCHAR(MAX),
  @p_check_data			NVARCHAR(MAX),
  @p_check_ui			NVARCHAR(MAX),
  @p_item_id			NVARCHAR(MAX)

AS 
BEGIN
	
    SET NOCOUNT ON;

	DECLARE @v_proc_name	nvarchar(100) = 'PR_UI_FP00470_MASTER_DATA_VALIDATION';
	DECLARE @runstart		datetime;
	DECLARE @runend			datetime;
	DECLARE @v_dSql			nvarchar(MAX)='';
	
	IF @p_sys_flag = 'ListLookup'
	BEGIN
		SET	@v_dSql = ''
		SET @v_dSql = '  SELECT A.SEGMENT1,A.SEGMENT2,A.SEGMENT3,A.SEGMENT4,A.SEGMENT5
								,A.SORT_ORDER
								,A.SEGMENT2 AS CODE_ID, A.SEGMENT3 AS CODE_NAME
						  FROM   SCM_SYS_LOOKUP_VALUE A(NOLOCK)
						  WHERE  A.LOOKUP_TYPE_CODE = '''+ @p_sys_gubun +'''
						  AND    A.ACTIVE_FLAG = ''Y''
						  and    A.SEGMENT1 = '''+ @p_instance_id +'''
						  ORDER BY SORT_ORDER
					 ' ;

	END
	ELSE BEGIN
		SET	@v_dSql = ''

		SET @v_dSql = '		SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID
									,A.PLAN_DATE
									,A.CHECK_CATEGORY
									,A.CHECK_TABLE
									,A.PROBLEM_TYPE
									,A.CHECK_DATA
									,A.PROBLEM_DATA
									,A.PROBLEM_LIST
									,A.REFERENCE_TABLE
									,A.CHECK_UI
									,A.PROBLEM_DESCRIPTION
									,A.TOP_ITEM_ID
									,A.INSTANCE_ID
									,A.INSERT_ID, CONVERT(VARCHAR, A.INSERT_TIME, 120) AS INSERT_TIME
										,B.NICK_NAME AS PROBLEM_DATA_NICK
									,C.NICK_NAME AS TOP_ITEM_ID_NICK
									,D.INSTANCE_NAME
							FROM	FP_MASTER_VALIDATION_H A WITH(NOLOCK)
									LEFT OUTER HASH JOIN SCM_ITEM_M B WITH(NOLOCK)
										ON  A.COMPANY_ID  = B.COMPANY_ID
										AND A.DIVISION_ID = B.DIVISION_ID
										AND A.SITE_ID     = B.SITE_ID
										AND A.PROBLEM_DATA = B.ITEM_ID
									LEFT OUTER HASH JOIN SCM_ITEM_M C WITH(NOLOCK)
										ON  A.COMPANY_ID  = C.COMPANY_ID
										AND A.DIVISION_ID = C.DIVISION_ID
										AND A.SITE_ID     = C.SITE_ID
										AND A.TOP_ITEM_ID = C.ITEM_ID
									LEFT OUTER JOIN (
														SELECT A.SEGMENT1 AS INSTANCE_ID,A.SEGMENT2 AS INSTANCE_NAME
														FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
														WHERE  A.LOOKUP_TYPE_CODE = ''INSTANCE_ID''
														AND    A.ACTIVE_FLAG = ''Y''
													) D
										ON  A.INSTANCE_ID = D.INSTANCE_ID
							WHERE  REPLACE(A.PLAN_DATE, ''-'', '''') = '''+ @p_plan_date + '''
							AND    EXISTS	(
												SELECT 1
												FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)
												WHERE  A.PLANT_ID    = B.PLANT_ID
												AND    A.INSTANCE_ID = B.INSTANCE_ID
												AND    B.USER_ID     = '''+ @p_user_id +'''
											)
						' ;
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.INSTANCE_ID' , 'EQ', @p_instance_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.CHECK_CATEGORY' , 'EQ', @p_check_category)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PROBLEM_TYPE' , 'EQ', @p_problem_type)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.CHECK_DATA' , 'EQ', @p_check_data)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.CHECK_UI' , 'EQ', @p_check_ui)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.TOP_ITEM_ID' , 'LIKE', @p_item_id)) + char(10);
	
		SET @v_dSql += '	ORDER BY A.INSTANCE_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.TOP_ITEM_ID, A.PROBLEM_TYPE, A.CHECK_UI, A.PROBLEM_DATA
						' ;
	END
	
	IF @p_sys_type = 'SQL'
    BEGIN
		select @v_dSql as [QUERY_VALUE]
    END ELSE BEGIN
		SET @runstart = GetDate()
		BEGIN TRY
		     BEGIN TRAN
	             exec sp_executesql @v_dSql
		     COMMIT TRAN
		END TRY
        BEGIN CATCH
             ROLLBACK
        END CATCH
	    SET @runend = GetDate()
		exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql,'SELECT',@runstart, @runend
    END
	
  
END

