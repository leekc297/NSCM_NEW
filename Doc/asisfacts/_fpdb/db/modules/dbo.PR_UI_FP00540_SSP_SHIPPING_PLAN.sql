

/*
 * Program ID   : PR_UI_FP00540_SSP_SHIPPING_PLAN
 * Description  : SSP Shipping Plan
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021-01-21   CYS				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00540_SSP_SHIPPING_PLAN]
  
  @p_sys_type			NVARCHAR(MAX),  
  @p_sys_flag			NVARCHAR(MAX),
  @p_sys_gubun			NVARCHAR(MAX),  
  @p_user_id			NVARCHAR(MAX),
  @p_instance_id		NVARCHAR(MAX),
  @p_division_id		NVARCHAR(MAX),
  @p_site_id			NVARCHAR(MAX),
  @p_plant_id			NVARCHAR(MAX),
  --@p_shop_group_id		NVARCHAR(MAX),
  @p_scp_plan_id		NVARCHAR(MAX),
  @p_production_type	NVARCHAR(MAX),
  @p_item_id			NVARCHAR(MAX),
  @p_nick_name			NVARCHAR(MAX)

AS 
BEGIN
	
    SET NOCOUNT ON;
	
	DECLARE @v_proc_name	nvarchar(100) = 'PR_UI_FP00540_SSP_SHIPPING_PLAN';
	DECLARE @runstart		datetime;
	DECLARE @runend			datetime;
	DECLARE @v_dSql			nvarchar(MAX)='';

	BEGIN
	
		SET	@v_dSql = ''
		SET @v_dSql += '	SELECT   A.COMPANY_ID
									,A.DIVISION_ID
									,A.SITE_ID
									,A.PLANT_ID
									,A.SHOP_GROUP_ID
									,A.SCP_PLAN_ID
									,A.SCP_TARGET_ID
									,A.FP_TARGET_ID
									,A.ITEM_ID
									,ISNULL(B.NICK_NAME, ''-'') AS NICK_NAME
									,A.TO_SITE_ID
									,A.TO_PLANT_ID
									,A.CUSTOMER_ID
									,A.SHIP_WEEK
									,CONVERT(VARCHAR,A.SHIP_DATE,112) AS SHIP_DATE
									,A.SHIP_QTY
									,A.PRODUCTION_TYPE
									,A.TRANSPORT_MODE
									,A.BIZ_TYPE
									,A.CONFIRM_TYPE
									,C.SEGMENT4 AS INSTANCE_ID
							FROM     FP_WEEKLY_DEMAND_SHIPMENT_H A WITH(NOLOCK)
									INNER HASH JOIN (
														SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.NICK_NAME
														FROM   SCM_ITEM_M A WITH(NOLOCK), SCM_ITEM_CLASS_M B WITH(NOLOCK)
														WHERE  A.ITEM_CLASS  = B.CLASS_ID
														AND    A.ACTIVE_FLAG = ''Y''
														AND    B.USE_FLAG    = ''Y''
													) B
									ON  A.COMPANY_ID  = B.COMPANY_ID
									AND A.DIVISION_ID = B.DIVISION_ID
									AND A.SITE_ID     = B.SITE_ID
									AND A.ITEM_ID     = B.ITEM_ID
									INNER HASH JOIN SCM_SYS_LOOKUP_VALUE C
									ON  A.SITE_ID          = C.SEGMENT2
									AND A.SHOP_GROUP_ID    = C.SEGMENT3
									AND A.DIVISION_ID      = C.SEGMENT5
									AND C.LOOKUP_TYPE_CODE = ''TARGET_INSTANCE''
									AND C.SEGMENT1         = ''SCP SHIPPING TARGET''
									AND C.ACTIVE_FLAG      = ''Y''
						';
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('C.SEGMENT4' , 'EQ', @p_instance_id)) + char(10);
		SET	@v_dSql += '	WHERE 	1=1
							AND		EXISTS  (
												SELECT 1
												FROM   FP_USER_ROLE_INFO_V B WITH(NOLOCK)
												WHERE  A.COMPANY_ID   = B.COMPANY_ID
												AND    A.DIVISION_ID  = B.DIVISION_ID
												AND    A.SITE_ID      = B.SITE_ID
												AND    A.PLANT_ID     = B.PLANT_ID
												AND    C.SEGMENT4     = B.INSTANCE_ID
												AND    B.USER_ID      = '''+ @p_user_id + '''
											)
						' ;
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10);
		--SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SHOP_GROUP_ID' , 'EQ', @p_shop_group_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SCP_PLAN_ID' , 'EQ', @p_scp_plan_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PRODUCTION_TYPE' , 'EQ', @p_production_type)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ITEM_ID' , 'LIKE', @p_item_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('B.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10);

		SET	@v_dSql += '	ORDER BY SCP_PLAN_ID, DIVISION_ID, SITE_ID, PLANT_ID, SHOP_GROUP_ID, ITEM_ID	' ;
	
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

