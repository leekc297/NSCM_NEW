
/*
 * Program ID   : PR_UI_FP00470_CODE
 * Description  : Master Data Validation
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/02/02   CYS				Initial Release UI통합
 */

CREATE PROCEDURE [dbo].[PR_UI_FP00470_CODE]
	  @p_code	  NVARCHAR(100)
    , @p_user_id  NVARCHAR(100)
	, @param1     NVARCHAR(MAX)  
	, @param2     NVARCHAR(MAX)  
	, @param3     NVARCHAR(MAX)  
	, @param4     NVARCHAR(MAX)  
	, @param5     NVARCHAR(MAX)
	, @param6     NVARCHAR(MAX)
	, @param7     NVARCHAR(MAX)
	, @param8     NVARCHAR(MAX)
	, @param9     NVARCHAR(MAX)
	, @param10    NVARCHAR(MAX)
	, @param11    NVARCHAR(MAX)
	, @param12    NVARCHAR(MAX)
	, @param13    NVARCHAR(MAX)
	, @param14    NVARCHAR(MAX)
	, @param15    NVARCHAR(MAX)
	, @param16    NVARCHAR(MAX)
	, @param17    NVARCHAR(MAX)
	, @param18    NVARCHAR(MAX)
	, @param19    NVARCHAR(MAX)
	, @param20    NVARCHAR(MAX)
AS
BEGIN
	
    SET NOCOUNT ON;

	DECLARE @v_proc_name	nvarchar(100) = 'PR_UI_FP00470_CODE';
	DECLARE @runstart		datetime;
	DECLARE @runend			datetime;
	DECLARE @v_dSql			nvarchar(MAX)='';

	IF @p_code = 'ListLookup'
	BEGIN
		SET	@v_dSql = ''
		SET @v_dSql = '  SELECT A.SEGMENT1,A.SEGMENT2,A.SEGMENT3,A.SEGMENT4,A.SEGMENT5
								,A.SORT_ORDER
								,A.SEGMENT2 AS CODE, A.SEGMENT3 AS NAME
						  FROM   SCM_SYS_LOOKUP_VALUE A(NOLOCK)
						  WHERE  A.LOOKUP_TYPE_CODE = '''+ @param1 +'''
						  AND    A.ACTIVE_FLAG = ''Y''
						  and    A.SEGMENT1 = '''+ @param2 +'''
						  ORDER BY SORT_ORDER
					 ' ;

	END

	BEGIN
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
		exec PR_UI_SQL_LOG @v_proc_name,  @p_user_id, @p_code,'',@v_dSql,'SELECT',@runstart, @runend
    END
END

