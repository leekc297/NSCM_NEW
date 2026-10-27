

/*
 * Program ID   : PR_UI_FP00070_GET_OPERATION
 * Description  : Operation Master
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/01/15   LJS				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00070_GET_OPERATION]  
  
  @p_sys_type		NVARCHAR(MAX),
  @p_sys_flag		NVARCHAR(MAX),
  @p_sys_gubun		NVARCHAR(MAX),
  @p_user_id		NVARCHAR(MAX),
  @p_division_id		NVARCHAR(MAX),
  @p_site_id			NVARCHAR(MAX),
  @p_operation_group_id	NVARCHAR(MAX),
  @p_operation_id  		NVARCHAR(MAX)

AS 
BEGIN
	
    SET NOCOUNT ON;

		DECLARE @v_proc_name	nvarchar(100) = 'PR_UI_FP00070_GET_OPERATION';
		DECLARE @runstart		datetime;
		DECLARE @runend			datetime;
		DECLARE @v_dSql			nvarchar(MAX)='';

		BEGIN
			SET @v_dSql = 'SELECT  A.COMPANY_ID AS COMPANY, (SELECT ISNULL(COMPANY_NAME, COMPANY_ID) FROM SCM_COMPANY_M(NOLOCK) WHERE COMPANY_ID = A.COMPANY_ID) COMPANY_NAME,
								   A.DIVISION_ID AS DIVISION, (SELECT ISNULL(DIVISION_NAME, DIVISION_ID) FROM SCM_DIVISION_M(NOLOCK) WHERE COMPANY_ID = A.COMPANY_ID AND DIVISION_ID = A.DIVISION_ID) DIVISION_NAME,
								   A.SITE_ID AS SITE, SITE_ID AS SITE_NAME,
								   '''' AS FACTORY, '''' AS FACTORY_NAME,
								   '''' AS SHOP, '''' AS SHOP_NAME,
								   A.OPERATION_ID AS OPERATION, A.OPERATION_NAME, A.ERP_OPERATION_ID AS ERP_OPERATION, A.ACTIVE_FLAG AS IS_VALID,
								   '''' AS MASTER_ID, '''' AS PLAN_ID, A.WO_FLAG, A.MO_FLAG, A.INSTANCE_TYPE, '''' AS IS_TRANSFER_MO,
								   CASE WHEN WO_FLAG = ''Y'' THEN ''WO'' ELSE '''' END
								   + CASE WHEN MO_FLAG = ''Y'' THEN ''MO'' ELSE '''' END AS ORDER_TYPE, OPERATION_GROUP_ID, SHOP_GROUP_ID
						   FROM   SCM_OPERATION_M A WITH(NOLOCK)
						   WHERE  1 = 1'
						+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10)
						+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
						+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_GROUP_ID' , 'EQ', @p_operation_group_id)) + char(10)
						+ (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.OPERATION_ID' , 'EQ', @p_operation_id)) + char(10)
						+ 'AND   (WO_FLAG = ''Y'' OR MO_FLAG = ''Y'')
						   AND  EXISTS (
								 SELECT 1
								 FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)
								 WHERE  A.COMPANY_ID   = B.COMPANY_ID
								 AND    A.DIVISION_ID  = B.DIVISION_ID
								 AND    A.SITE_ID      = B.SITE_ID
								 AND    A.OPERATION_ID = B.OPERATION_ID
								 AND    B.USER_ID      = ''' + @p_user_id + '''
						   )
						   AND   ((exists (select 1 from SCM_MMD_OPERATION_GROUP_M B(NOLOCK) WHERE B.OPERATION_GROUP_ID=A.OPERATION_GROUP_ID AND B.ROUTE_TYPE=''P'')
										   AND MES_ERP_INTERFACE_FLAG=''Y''
								  ) or (
								   not exists (select 1 from SCM_MMD_OPERATION_GROUP_M B(NOLOCK) WHERE B.OPERATION_GROUP_ID=A.OPERATION_GROUP_ID AND B.ROUTE_TYPE=''P'')
								  ))
							ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID
							';
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
			exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql, @p_sys_type, @runstart, @runend
		END
  
END

