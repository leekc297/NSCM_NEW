

/*
 * Program ID   : PR_UI_FP02560_SITE_BOD
 * Description  : Site(BOD)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021-03-18   CYS				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP02560_SITE_BOD]
  
  @p_sys_type			NVARCHAR(MAX),  
  @p_sys_flag			NVARCHAR(MAX),
  @p_sys_gubun			NVARCHAR(MAX),  
  @p_user_id			NVARCHAR(MAX),
  @p_division_id		NVARCHAR(MAX),
  @p_site_id			NVARCHAR(MAX),
  @p_plant_id			NVARCHAR(MAX)
  
AS 
BEGIN
	
    SET NOCOUNT ON;
	
	DECLARE @v_proc_name	nvarchar(100) = 'PR_UI_FP02560_SITE_BOD';
	DECLARE @runstart		datetime;
	DECLARE @runend			datetime;
	DECLARE @v_dSql			nvarchar(MAX)='';

	BEGIN
	
		SET	@v_dSql = ''
		SET @v_dSql += '	SELECT COMPANY_ID, DIVISION_ID, A.SITE_ID, TO_SITE_ID,A.PLANT_ID,								' + char(10)			
		SET @v_dSql += '	      TO_PLANT_ID, TRANSPORT_MODE, TRANSPORT_PRIORITY,                                   ' + char(10)
		SET @v_dSql += '	     OUT_BUFFER_DAY, OUTBOUND_DAY, SHIP_PORT_DAY,                                                   ' + char(10)
		SET @v_dSql += '	     MON, TUE, WED, THU, FRI, SAT, SUN,                                                             ' + char(10)
		SET @v_dSql += '	     VOYAGE_DAY, INBOUND_DAY, IN_BUFFER_DAY, ACTIVE_FLAG, DESCRIPTION,                              ' + char(10)
		SET @v_dSql += '	     (CASE WHEN R.PLANT_ID IS NULL THEN ''N'' ELSE ''Y'' END) AS EDIT_YN,                           ' + char(10)
		SET @v_dSql += '	     (CASE WHEN R2.PLANT_ID IS NULL THEN ''N'' ELSE ''Y'' END) AS EDIT_YN2                          ' + char(10)
		SET @v_dSql += '	FROM   SCM_SHIPMENT_M A WITH(NOLOCK)                                                                ' + char(10)
		SET @v_dSql += '	LEFT OUTER JOIN (                                                                                   ' + char(10)
		SET @v_dSql += '	   SELECT DISTINCT R.SITE_ID, R.PLANT_ID                                                            ' + char(10)
		SET @v_dSql += '	   FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)                                                        ' + char(10)
		SET @v_dSql += '	   WHERE  R.USER_ID   = '''+ @p_user_id + '''                                                       ' + char(10)
		SET @v_dSql += '	   AND    R.SAVE_FLAG = ''Y''                                                                       ' + char(10)
		SET @v_dSql += '	) R                                                                                                 ' + char(10)
		SET @v_dSql += '	ON   A.SITE_ID      = R.SITE_ID                                                                     ' + char(10)
		SET @v_dSql += '	AND  A.PLANT_ID     = R.PLANT_ID                                                                    ' + char(10)
		SET @v_dSql += '	LEFT OUTER JOIN (                                                                                   ' + char(10)
		SET @v_dSql += '	   SELECT DISTINCT R.SITE_ID, R.PLANT_ID                                                            ' + char(10)
		SET @v_dSql += '	   FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)                                                        ' + char(10)
		SET @v_dSql += '	   WHERE  R.USER_ID   = '''+ @p_user_id + '''                                                       ' + char(10)
		SET @v_dSql += '	   AND    R.SAVE_FLAG = ''Y''                                                                       ' + char(10)
		SET @v_dSql += '	) R2                                                                                                ' + char(10)
		SET @v_dSql += '	ON   A.TO_SITE_ID   = R2.SITE_ID                                                                    ' + char(10)
		SET @v_dSql += '	AND  A.TO_PLANT_ID  = R2.PLANT_ID                                                                   ' + char(10)
		SET @v_dSql += '	WHERE  1=1                                                                                          ' + char(10)
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.DIVISION_ID' , 'EQ', @p_division_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.SITE_ID' , 'EQ', @p_site_id)) + char(10);
		SET @v_dSql += (SELECT  [DBO].[FN_SCM_GET_WHERE_SQL]('A.PLANT_ID' , 'EQ', @p_plant_id)) + char(10);
		SET @v_dSql += '	ORDER BY A.DIVISION_ID, A.SITE_ID, A.TO_SITE_ID, A.PLANT_ID, A.TO_PLANT_ID, A.TRANSPORT_MODE        ' + char(10)
	
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

