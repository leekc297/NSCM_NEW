


/*
 * Program ID   : [SSP0020_GET_DELEGATE]
 * Description  : Delegate 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/07/09   mcTheJ		   [CSR ID:4044806] Model PIC 담당자 위임 기능 추가	
 */
CREATE PROCEDURE [dbo].[SSP0020_GET_DELEGATE]
	@p_user_id              NVARCHAR(MAX)
	,@p_language			 NVARCHAR(MAX) = 'KO'
AS

BEGIN

	SET NOCOUNT ON;
	
	DECLARE @mDelegateQuery					NVARCHAR(MAX);
	DECLARE @mDelegatedQuery					NVARCHAR(MAX);

	SET @mDelegateQuery = '';
	SET @mDelegateQuery = @mDelegateQuery + ' SELECT 																	' + CHAR(10);
	SET @mDelegateQuery = @mDelegateQuery + ' 	T0.DIVISION_ID,                                                         ' + CHAR(10);
	SET @mDelegateQuery = @mDelegateQuery + ' 	CONVERT(DATE, T0.FROM_DATE) AS FROM_DATE,                                                           ' + CHAR(10);
	SET @mDelegateQuery = @mDelegateQuery + ' 	CONVERT(DATE, T0.TO_DATE) AS TO_DATE,                                                             ' + CHAR(10);
	SET @mDelegateQuery = @mDelegateQuery + ' 	CASE ''' + @p_language + ''' WHEN ''KO'' THEN T1.UserName ELSE T1.UserName_E END  + ''('' + T0.DELEGATEE_ID + '')'' AS DELEGATEE,              ' + CHAR(10);
	SET @mDelegateQuery = @mDelegateQuery + ' 	T0.VALID_YN  AS VALID,                                                            ' + CHAR(10);
	SET @mDelegateQuery = @mDelegateQuery + ' 	CASE ''' + @p_language + ''' WHEN ''KO'' THEN T2.UserName ELSE T2.UserName_E END + ''('' + T0.LAST_UPDATED_BY + '')'' AS LAST_UPDATED_BY,        ' + CHAR(10);
	SET @mDelegateQuery = @mDelegateQuery + ' 	CONVERT(DATETIME, T0.LAST_UPDATE_DATE) AS LAST_UPDATE_DATE,                                                     ' + CHAR(10);
	SET @mDelegateQuery = @mDelegateQuery + ' 	T0.USER_ID, T0.DELEGATEE_ID                                                     ' + CHAR(10);
	SET @mDelegateQuery = @mDelegateQuery + ' FROM SSP_MST_DELEGATE T0  WITH(NOLOCK)                                                 ' + CHAR(10);
	SET @mDelegateQuery = @mDelegateQuery + ' INNER JOIN TB_FX_USER T1  WITH(NOLOCK)                                           ' + CHAR(10);
	SET @mDelegateQuery = @mDelegateQuery + ' 	ON T1.UserID = T0.DELEGATEE_ID                                               ' + CHAR(10);
	SET @mDelegateQuery = @mDelegateQuery + ' INNER JOIN TB_FX_USER T2  WITH(NOLOCK)                                           ' + CHAR(10);
	SET @mDelegateQuery = @mDelegateQuery + ' 	ON T2.UserID = T0.LAST_UPDATED_BY                                       ' + CHAR(10);
	SET @mDelegateQuery = @mDelegateQuery + ' WHERE 1 = 1                                                               ' + CHAR(10);
	SET @mDelegateQuery = @mDelegateQuery + ' AND T0.VALID_YN = ''Y''													' + CHAR(10);
	SET @mDelegateQuery = @mDelegateQuery + ' AND T0.USER_ID = ''' + @p_user_id + '''                                                  ' + CHAR(10);
	SET @mDelegateQuery = @mDelegateQuery + ' ORDER BY T0.DELEGATEE_ID, CONVERT(DATE, T0.FROM_DATE), CONVERT(DATE, T0.TO_DATE), T0.DIVISION_ID, T0.LAST_UPDATE_DATE ' + CHAR(10);


	SET @mDelegatedQuery = '';
	SET @mDelegatedQuery = @mDelegatedQuery + ' SELECT 																	' + CHAR(10);
	SET @mDelegatedQuery = @mDelegatedQuery + ' 	T0.DIVISION_ID,                                                         ' + CHAR(10);
	SET @mDelegatedQuery = @mDelegatedQuery + ' 	CONVERT(DATE, T0.FROM_DATE) AS FROM_DATE,                                                           ' + CHAR(10);
	SET @mDelegatedQuery = @mDelegatedQuery + ' 	CONVERT(DATE, T0.TO_DATE) AS TO_DATE,                                                             ' + CHAR(10);
	SET @mDelegatedQuery = @mDelegatedQuery + ' 	CASE ''' + @p_language + ''' WHEN ''KO'' THEN T1.UserName ELSE T1.UserName_E END  + ''('' + T0.USER_ID + '')'' AS DELEGATOR,              ' + CHAR(10);
	SET @mDelegatedQuery = @mDelegatedQuery + ' 	T0.VALID_YN AS VALID,                                                            ' + CHAR(10);
	SET @mDelegatedQuery = @mDelegatedQuery + ' 	CASE ''' + @p_language + ''' WHEN ''KO'' THEN T2.UserName ELSE T2.UserName_E END + ''('' + T0.LAST_UPDATED_BY + '')'' AS LAST_UPDATED_BY,        ' + CHAR(10);
	SET @mDelegatedQuery = @mDelegatedQuery + ' 	CONVERT(DATETIME, T0.LAST_UPDATE_DATE) AS LAST_UPDATE_DATE                                                     ' + CHAR(10);
	SET @mDelegatedQuery = @mDelegatedQuery + ' FROM SSP_MST_DELEGATE T0  WITH(NOLOCK)                                                 ' + CHAR(10);
	SET @mDelegatedQuery = @mDelegatedQuery + ' INNER JOIN TB_FX_USER T1  WITH(NOLOCK)                                            ' + CHAR(10);
	SET @mDelegatedQuery = @mDelegatedQuery + ' 	ON T1.UserID = T0.USER_ID                                               ' + CHAR(10);
	SET @mDelegatedQuery = @mDelegatedQuery + ' INNER JOIN TB_FX_USER T2  WITH(NOLOCK)                                             ' + CHAR(10);
	SET @mDelegatedQuery = @mDelegatedQuery + ' 	ON T2.UserID = T0.LAST_UPDATED_BY                                       ' + CHAR(10);
	SET @mDelegatedQuery = @mDelegatedQuery + ' WHERE 1 = 1                                                               ' + CHAR(10);
	SET @mDelegatedQuery = @mDelegatedQuery + ' AND T0.VALID_YN = ''Y''													' + CHAR(10);
	SET @mDelegatedQuery = @mDelegatedQuery + ' AND T0.DELEGATEE_ID = ''' + @p_user_id + '''                                                  ' + CHAR(10);
	SET @mDelegatedQuery = @mDelegatedQuery + ' ORDER BY T0.DELEGATEE_ID, CONVERT(DATE, T0.FROM_DATE), CONVERT(DATE, T0.TO_DATE), T0.DIVISION_ID, T0.LAST_UPDATE_DATE ' + CHAR(10);

	exec(@mDelegateQuery);
	exec(@mDelegatedQuery);

	--exec SSP0020_GET_DELEGATE 'kahonmalu', 'KO';
END



