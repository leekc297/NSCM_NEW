

/*
 * Program ID   : PR_UI_FP00020_SITE_PLANT
 * Description  : Site & Plant
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/01/15   CYS				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00020_SITE_PLANT]
  @p_sys_type			NVARCHAR(MAX),  
  @p_sys_flag			NVARCHAR(MAX),
  @p_sys_gubun			NVARCHAR(MAX),  
  @p_user_id			NVARCHAR(MAX),
  @p_division_lt		NVARCHAR(MAX),
  @p_site_id			NVARCHAR(MAX),
  @p_plant_lt			NVARCHAR(MAX),
  @p_factory_lt			NVARCHAR(MAX),
  @p_active				NVARCHAR(MAX)

AS 
BEGIN
	
    SET NOCOUNT ON;
	
	DECLARE @v_proc_name	nvarchar(100) = 'PR_UI_FP00020_SITE_PLANT';
	DECLARE @runstart		datetime;
	DECLARE @runend			datetime;
	DECLARE @v_dSql			nvarchar(MAX)='';

	BEGIN

		SET	@v_dSql = ''
		SET @v_dSql += '	SELECT	A.COMPANY_ID
									,A.DIVISION_ID
									,DBO.FN_GETNAME_DIVISION(A.COMPANY_ID,A.DIVISION_ID) AS DIVISION_NAME
									,A.SITE_ID
									,DBO.FN_GETNAME_SITE(A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID) AS SITE_NAME
									,A.PLANT_ID
									,DBO.FN_GETNAME_PLANT(A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID) AS PLANT_NAME
									,A.FACTORY_ID
									,A.FACTORY_NAME
									,A.SHOP_GROUP_ID
									,A.SHOP_GROUP_NAME
									,A.OUTSOURCING_FLAG
									,A.ACTIVE_FLAG
							FROM   SCM_FACTORY_M A WITH(NOLOCK)
							WHERE  1=1
						' + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_lt)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_lt)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.FACTORY_ID' , 'EQ', @p_factory_lt)) + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.ACTIVE_FLAG' , 'EQ', @p_active)) + char(10)
		SET @v_dSql += '	ORDER BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID '

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

