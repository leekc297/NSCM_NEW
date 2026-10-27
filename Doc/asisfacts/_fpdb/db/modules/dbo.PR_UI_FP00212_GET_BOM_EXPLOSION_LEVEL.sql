

/*
 * Program ID   : PR_UI_FP00212_GET_BOM_EXPLOSION_LEVEL
 * Description  : BOM Explosion 1 Level
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/01/14   CYS				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00212_GET_BOM_EXPLOSION_LEVEL]
  @p_sys_type			NVARCHAR(MAX),  
  @p_sys_flag			NVARCHAR(MAX),
  @p_sys_gubun			NVARCHAR(MAX),  
  @p_user_id			NVARCHAR(MAX),
  @p_division_lt		NVARCHAR(MAX),
  @p_site_id			NVARCHAR(MAX),
  @p_plant_lt			NVARCHAR(MAX),
  @p_model				NVARCHAR(MAX),
  @p_nick_name			NVARCHAR(MAX)

AS 
BEGIN
	
    SET NOCOUNT ON;
	
	DECLARE @v_proc_name	nvarchar(100) = 'PR_UI_FP00212_GET_BOM_EXPLOSION_LEVEL';
	DECLARE @runstart		datetime;
	DECLARE @runend			datetime;
	DECLARE @v_dSql			nvarchar(MAX)='';

	BEGIN

		SET	@v_dSql = ''
		SET @v_dSql += '  SELECT CT.COMPANY_ID
								,MAX(CT.DIVISION_ID) AS DIVISION_ID
								,CT.SITE_ID 
								,CT.MODEL_ID
								,CT.PLANT_ID
								,CT.CHILD_ITEM_ID
								,MAX(CT.ITEM_NAME)   AS ITEM_NAME
								,MAX(CT.NICK_NAME)   AS NICK_NAME
								,MAX(CT.DESCRIPTION) AS DESCRIPTION
								,MAX(CT.ITEM_TYPE)   AS ITME_TYPE
								,MAX(CT.ITEM_CLASS)  AS ITEM_CLASS
								,MAX(CT.ITEM_CLASS_NAME) AS ITEM_CLASS_NAME
								,MAX(CT.FLOW_ID)     AS FLOW_ID
								,MAX(CT.ITEM_UOM)    AS ITEM_UOM
								,MIN(CT.SORT_ORDER)  AS SORT_ORDER
								,SUM(CT.ACCUMULATED_CHILD_QTY) AS ACCUMULATED_CHILD_QTY
								,MAX(CT.CHILD_QTY)   AS CHILD_QTY
								,MAX(CT.ALT_PRIORITY) AS ALT_PRIORITY
								,MAX(CT.CHECK_ALT)   AS CHECK_ALT
						  FROM  (
							  SELECT CT.COMPANY_ID
									,CT.DIVISION_ID
									,CT.SITE_ID 
									,CT.MODEL_ID
									,CT.PLANT_ID
									,CT.CHILD_ITEM_ID
									,SI.ITEM_NAME
									,SI.NICK_NAME
									,SI.DESCRIPTION
									,SI.ITEM_TYPE
									,SI.ITEM_CLASS
									,SI.ITEM_CLASS_NAME
									,SUBSTRING(SI.FLOW_ID,1,5) AS FLOW_ID
									,SI.ITEM_UOM
									,CT.SORT_ORDER
									,CT.ACCUMULATED_CHILD_QTY
									,CT.CHILD_QTY
									,CT.ALT_PRIORITY
									,CT.NLEVEL
									,CT.INSERT_TIME
									,(SELECT TOP 1 ''Y''
									  FROM   SCM_MODEL_COMP_TEMP CK WITH(NOLOCK)
									  WHERE  CK.COMPANY_ID     = CT.COMPANY_ID
									  AND    CK.DIVISION_ID    = CT.DIVISION_ID
									  AND    CK.SITE_ID        = CT.SITE_ID
									  AND    CK.MODEL_ID       = CT.MODEL_ID
									  AND    CK.PLANT_ID       = CT.PLANT_ID
									  AND    CK.PARENT_ITEM_ID = CT.PARENT_ITEM_ID
									  AND    CK.ALT_ID         = CT.ALT_ID
									  AND    CK.ALT_PRIORITY  IS NULL) AS CHECK_ALT
							  FROM   SCM_MODEL_COMP_TEMP CT WITH(NOLOCK)
									,SCM_ITEM_M  SI WITH(NOLOCK)
									,SCM_ITEM_CLASS_M IC WITH(NOLOCK)
							  WHERE  CT.CHILD_COMPANY_ID  = SI.COMPANY_ID
							  AND    CT.CHILD_DIVISION_ID = SI.DIVISION_ID
							  AND    CT.CHILD_SITE_ID     = SI.SITE_ID
							  AND    CT.CHILD_ITEM_ID     = SI.ITEM_ID
							  AND    SI.ITEM_CLASS        = IC.CLASS_ID
							  AND    IC.USE_FLAG          = ''Y''
						' ;
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('CT.DIVISION_ID' , 'EQ', @p_division_lt)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('CT.SITE_ID' , 'EQ', @p_site_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('CT.PLANT_ID' , 'EQ', @p_plant_lt)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('CT.MODEL_ID' , 'LIKE', @p_model)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('SI.NICK_NAME' , 'LIKE', @p_nick_name)) + char(10);

		SET @v_dSql += '	  AND    ISNULL(SI.ITEM_TYPE,''H'') IN (''P'',''Q'',''H'')
							  AND    CT.ALT_PRIORITY = ''Y''
						  )  CT
						  GROUP BY CT.COMPANY_ID ,CT.SITE_ID ,CT.MODEL_ID ,CT.PLANT_ID ,CT.CHILD_ITEM_ID
						  ORDER BY CT.COMPANY_ID ,CT.SITE_ID ,CT.MODEL_ID ,CT.PLANT_ID ,MIN(CT.NLEVEL) ,MIN(CT.INSERT_TIME) ,CT.CHILD_ITEM_ID
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
			exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_sys_flag,'',@v_dSql, @p_sys_type, @runstart, @runend
		END
  
END

