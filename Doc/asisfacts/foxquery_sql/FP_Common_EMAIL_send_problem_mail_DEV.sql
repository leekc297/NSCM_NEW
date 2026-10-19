BEGIN
	DECLARE @mail_content NVARCHAR(MAX)
	DECLARE @developer NVARCHAR(MAX) = ''--'chkim.68@lgespartner.com;hwi1993@lgespartner.com;iamarock@lgespartner.com;wonyeoulb@lgespartner.com' -- ;'chkim.68@lgespartner.com;lgda106@lgespartner.com' 처럼 받고싶으면 ;로 추가해서 넣어준다
	DECLARE @p_lookup_type NVARCHAR(1000) = 'PROBLEM_REPORT'
SET @mail_content =  '--Dev--' --- 개발은 Dev, 운영은 Manage
+char(10) + 'REPORTER:' + char(10) +ISNULL(@REPORTER,'')
+char(10) + 'MESSAGE:' + char(10) +ISNULL(@MESSAGE,'')
+ char(10) + 'Source:' + char(10) + ISNULL(@SOURCE,'') 
+ char(10) + 'StackTrace:' + char(10) +ISNULL(@STACKTRACE,'')
+ char(10) + 'TARGETSITE:'+ char(10) +ISNULL(@TARGETSITE,'') 
+char(10) + 'HELPLINK:' + char(10) +ISNULL(@HELPLINK,'')
+char(10) + 'INNEREXCEPTION:'+ char(10) +ISNULL(@INNEREXCEPTION,'') 
+char(10) + 'BASEEXCEPTION:' + char(10) +ISNULL(@BASEEXCEPTION,'')


	SELECT @developer = STUFF(
    (SELECT '; ' + CAST(SEGMENT2 AS VARCHAR(100))
    FROM LGCE_SCMDEV.dbo.SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
    WHERE (ISNULL(lookup_type,'') = @p_lookup_type AND ISNULL(VALID_YN,'')='Y')
    FOR XML PATH('')), 1, 2, '') 
	
	IF ISNULL(@developer,'')  <> ''
	BEGIN
		exec msdb.dbo.sp_send_dbmail @profile_name           =  'FP_MAIL_TEST'--- 개발은 FP_MAIL_TEST, 운영은 FP_MAIL
		, @recipients             = @developer 
		, @query_result_separator = ';'
		, @subject                = N'PROBLEM REPORT'--@EMAIL_TITLE
		, @body                   = @mail_content 
		, @body_format            = 'text'
	END		
END